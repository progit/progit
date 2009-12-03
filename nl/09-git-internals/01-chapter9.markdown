# Het Binnenwerk van Git #

Je zult misschien naar dit hoofdstuk gesprongen zijn vanuit een vorig hoofdstuk, of je zult hier gekomen zijn nadat je de rest van het boek gelezen hebt – in ieder geval, zal hier het binnenwerk en implementatie van Git behandeld worden. Ik heb gemerkt dat het leren van deze informatie van fundamenteel belang is om te begrijpen hoe bruikbaar en krachtig Git is, maar anderen hebben daar tegenin gebracht dat het erg verwarrend en onnodig complex kan zijn voor beginners. Daarom heb ik deze beschrijving het laatste hoofdstuk gemaakt in het boek, zodat je het vroeg of later kunt lezen in je leerproces. Ik laat het aan jou over om te beslissen.

Laten we beginnen, nu je hier bent. Als eerste, mocht het nog niet duidelijk zijn, is Git in basis een inhouds-toegankelijk bestandssyteem met een VCS gebruikersinterface er bovenop geschreven. Je zult over een poosje meer leren over wat dit betekend.

In de eerste dagen van Git (het meerendeel pre 1.5), wat de gebruikersinterface veel complexer, omdat het de nadruk legde op dit bestandssysteem in plaats van op een gepolijst VCS. De laatste paar jaren is de interface verfijnd totdat het zo netjes en eenvoudig te gebruikten is als ieder systeem dat er bestaat; maar vaak blijft het stereotype hangen over de vroegere Git interface, die complex was en moeilijk te leren.

The content-addressable filesystem layer is amazingly cool, so I’ll cover that first in this chapter; then, you’ll learn about the transport mechanisms and the repository maintenance tasks that you may eventually have to deal with.

## Sanitaire Inrichtingen en Porcelein ##

Dit boek behandeld Git met ongeveer 30 werkwoorden zoals `checkout`, `branch`, `remote` enzovoorts. Maar omdat Git in eerste instantie een toolkit voor een VCS was, in plaats van een volledig gebruiksvriendelijk VCS, heeft het een berg werkwoorden die laagbijdegronds werk doen en ontworpen waren om samengevoegd te worken zoals in UNIX gebruikelijk is, of vanuit scripts aangeroepen te worden. Naar deze commando's wordt over het algemeen als "plumbing" (sanitaire voorzieningen) commando's verwezen, en de meer gebruiksvriendelijke commando's worden "porcelain" (porcelein) commando's genoemd.

De eerste acht hoofdstukken van het boek behandelen bijna alleen porcelein commando's. Maar in dit hoofdstuk zul je het meest met de lagere nivo sanitaire voorziening commando's omgaan, omdat zij je toegang tot de innerlijke werking van Git geven, en helpen te demonstreren hoe en waarom Git doet wat het doet. Deze commando's zijn niet bedoeld om handmatig op de commandoregel gebruikt te worden, maar meer om als bouwstenen voor nieuwe tools en scripts gebruikt te worden.

Als je `git init` uitvoerd in een nieuwe of bestaande map, zal Git de `.git` map aanmaken, wat de plek is waar Git bijna alles opslaat en manipuleert. Als je je repository wilt backup'en of clonen, dan geeft het elders kopieeren van deze map je bijna alles wat je nodig hebt. Dit hele hoofdstuk gaat in essentie over het spul in deze map. Hier zie je hoe het eruit ziet:

	$ ls 
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

Je kunt een paar andere bestanden zien, maar dit is een verse `git init` repository – dit is wat je standaard ziet. De `branches` map wordt niet gebruikt door nieuwere Git versies, en het `description` bestand wordt alleen gebruikt door het GitWeb programma, dus je hoeft je daar niet druk over te maken. Het `config` bestand bevat je project-specifieke configuratie opties, en de `info` map bevat een globaal exclude bestand voor genegeerde patronen, die je niet wilt volgen in een .gitignore bestand. De `hooks` map bevat je gebruiker- en server-kant haak scripts, die in detail beschreven zijn in Hoofdstuk 6.

Dit laat vier belangrijke vermeldingen over: de `HEAD` en `index` bestanden, en de `objects` en `refs` mappen. Dit zijn de kern bestandsdelen van Git. De `objects` map bewaard alle inhoud van je databank, de `refs` map bevat pointers naar commit objecten in die gegevens (branches), het `HEAD` bestand wijst naar de branch die je op dit moment uitgechecked hebt, en het `index` bestand is waar Git de informatie van je staging gebied opslaat. Je gaat nu in detail naar elk van deze secties kijken om te zien hoe Git werkt.

## Git Objecten ##

Git is een inhouds-adresseerbaar bestandssysteem. Mooi. Wat betekend dat?
Het betekend dat in de kern van Git een eenvoudige sleutel-waarde gegevens opslag zit. Je kunt er ieder soort inhoud in stoppen, en het zal je een sleutel geven dije kunt gebruiken om de inhoud op ieder moment terug te krijgen. Om te demonstreren, kun je het sanitaire voorzieningen commando `hash-object` gebruiken, die wat gegevens aanneemt, het in je `.git` map opslaat, en je de sleutel teruggeeft waarmee de gegevens zijn opgelsagen. Als eerste initialiseer je een nieuw Git repository en verifieer je dat er niets in de `objects` map staat:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

Git heeft de `objects` map geinitialiseerd en de `pack` en `info` submappen erin aangemaakt, maar er zijn geen reguliere bestanden. Nu sla je wat tekst in je Git databank op:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

De `-w` verteld `hash-object` dat het object opgeslagen moet worden; anders zal het commando je alleen vertellen wat de sleutel zou zijn. `--stdin` verteld het commando dat het moet lezen van stdin; als je dit niet specificeerd verwatch `hash-object` een pad naar een bestand. De uitvoer van het commando is een hash checksum van 40 karakters. Dit is de SHA-1 hash – een checksum van de inhoud die je opslaat plus een kop, waarover je zometeen meer zult leren. Nu kun je zien hoe Git je gegevens opgeslagen heeft:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Je kunt een bestand in de `objects` map zien. Dit is hoe Git de inhoud initieel opslaat – as een enkel bestand per stuk inhoud, vernoemd naar de SHA-1 checksum van de inhoud en z'n kop. De submap is vernoemd naar de eerste 2 karakters van de SHA, het het bestandsnaam zijn de overige 38 karakters.

Je kunt de inhoud terug uit Git halen met het `cat-file` commando. Dit commando is een soort Zwitsers zakmes om Git objecten mee te inspecteren. Door de `-p` optie mee te geven, instrueer je het `cat-file` commando om uit te zoeken van het type van de inhoud is en om het netjes aan je te tonen:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Nu kun je inhoud aan Git toevoegen, en het er weer uit halen. Je kunt dit ook doen met inhoud in bestanden. Bijvoorbeeld, je kunt wat eenvoudig versie beheer op een bestand doen. Als eerste maak je een nieuw bestand en slaat de inhoud op in je databank:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

Daarna schrijf je wat nieuwe inhoud in het bestand en slaat het opnieuw op:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Je databank bevat de twee nieuwe versies van het bestand, samen met de eerste inhoud die je daar opgeslagen hebt:

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Nu kun je het bestand terugbrengen naar de eerste versie

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

of de tweede versie:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

Maar de SHA-1 sleutel voor iedere versie van je bestand onthouden is niet erg praktisch; plus, je bewaard de bestandsnaam niet in je systeem – alleen de inhoud. Dit objecttype heet een blob. Je kunt Git jou het objecttype van ieder object in Git laten vertellen, gegeven de SHA-1 sleutel, met `cat-file -t`:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Boom Objecten ###

Het volgende type waar je naar gaat kijken is het boom object, wat het probleem van het opslaan van de bestandsnaam oplost en het je ook mogelijk maakt om een groep bestanden samen op te slaan. Git slaat inhoud op in dezelfde wijze als een UNIX bestandssysteem, maar dan wat vereenvoudigd. Alle inhoud wordt opgeslagen als boom- en blob-objecten, waarbij bomen corresponderen met UNIX map vermeldingen en blobs min of meer corresponderen aan inodes of bestandsinhoud. Een enkel boomobject bevat één of meer boom vermeldingen, waarvan ieder een SHA-1 point naar een blob of subboom bevat met zijn geassocieerde mode, type en bestandsnaam. Bijvoorbeeld, de meest recente boom in het simplegit project zou er zo uit kunnen zien:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

De `master^{tree}` syntax specificeerd het boom object waarnaar gewezen wordt door de laatste commit op je `master` branch. Zie dat de `lib` submap geen blob is, maar een pointer naar een andere boom:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Conceptueel zijn de gegevens die Git opslaat zoiets als in Figuur 9-1.

Insert 18333fig0901.png 
Figuur 9-1. Eenvoudige versie van het Git data model.

Je kunt je eigen boom maken. Normaal gesproken maakt Git een boom door de status van je staging gebied of index te pakken en daar een boom object mee te schrijven. Dus, om een boomobject te maken moet je eerst een index instellen door een paar bestanden te stagen. Om een index te maken met een enkele vermelding – de eerste versie van je test.txt bestand – kun je het sanitaire voorzieningen commando `update-index` gebruiken. Je gebruikt dit commando om kunstmatig de eerdere versie van het test.txt bestand toe te voegen aan een nieuw staging gebied. Je moet het de `--add` optie meegeven, omdat het bestand nog niet bestaat in je staging gebied (je hebt zelfs nog geen staging gebied ingesteld) en `--cacheinfo` omdat het bestand dat je toevoegd niet in je map staat, maar wel in je databank. Daarna specificeer je de mode, SHA-1 en bestandsnaam:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

In dit geval specificeer je een mode van `100644`, wat betekend dat het een normaal bestand is. Andere opties zijn `100755`, wat betekend dat het een uitvoerbaar bestand is; en `120000`, wat een symbolische link specificeerd. De mode is genomen van normale UNIX modes, maar is veel minder flexibel – deze drie modi zijn de enigen die geldig zijn voor bestanden (blobs) in Git (alhoewel andere modi worden gebruikt voor mappen en submodules).

Nu kun je het `write-tree` commando gebruiken om het staging gebied naar een boomobject te schrijven. Er is geen `-w` optie nodig – `write-tree` aanroepen zorgt er automatisch voor dat een boomobject gecreëeerd wordt van de status van de index als die boom nog niet bestaat:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Je kunt ook verifieren dat dit een boomobject is:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Je zult nu een nieuwe boom aanmaken met de tweede versie van het test.txt bestand en ook een nieuw bestand:

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

Je staging gebied heeft nu een nieuwe versie van test.txt, als ook het nieuwe new.txt bestand. Schrijf de boom (sla de status van het staging gebied of index op als boom object) en kijk hoe het er uit ziet:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Zie dat deze boom beide bestandsvermeldingen bevat en ook dat de SHA van test.txt dezelfde "versie 2" SHA is als eerder (`1f7a7a`). Je zult nu voor de lol de eerste boom als een subboom toevoegen aan deze. Je kunt bomen in je staging gebied lezen door `read-tree` aan te roepen. In dit geval kun je een bestaande boom in je staging gebied lezen als een subboom met de `--prefix` optie aan `read-tree`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

If you created a working directory from the new tree you just wrote, you would get the two files in the top level of the working directory and a subdirectory named `bak` that contained the first version of the test.txt file. You can think of the data that Git contains for these structures as being like Figure 9-2.
Als je een werkmap zou maken van de nieuwe boom die je zojuist geschreven hebt, zou je de twee bestanden in het bovenste nivo van de werkmap krijgen en een submap genaamd `bak` die de eerste versie van het test.txt bestand bevatte. Je kunt over de gegevens die Git bevat voor deze structuren denken zoals getoond in Figuur 9-2.

Insert 18333fig0902.png 
Figuur 9-2. De inhoud structuur van je huidige Git gegevens.

### Commit Objecten ###

Je hebt drie bomen die de verschillende snapshots specificeren die je wilt volgen, maar het eerdere probleem blijft: je moet alledrie de SHA-1 waarden onthouden om de snapshots weer op te halen. Je hebt ook geen informatie over wie de snapshots opgeslagen heeft, wanneer ze opgeslagen zijn, of waarom ze opgeslagen zijn. Dit is de basale informatie die het commit object voor je opslaat.

Om een commit object te creëeren moet je `commit-tree` aanroepen en één boom SHA-1 specificeren en welke commit objecten, als er die zijn, er direct aan vooraf gingen. Start met de eerste boom, die je geschreven hebt:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Nu kun je je nieuwe commit object bekijken met `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Het formaat van een commit object is simpel: het specificeert de bovenste boom voor het snapshot van het project op dat punt; de auteur/committer informatie die uit je `user.name` en `user.email` configuratie instellingen gehaald is, met de huidige tijd; een lege regel, en dan de commit boodschap.

Nu zul je de twee andere commit objecten schrijven, waarbij ze elk het commit object dat er direct voor komt refereren:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Ieder van de drie commit objecten wijst naar één van de drie snapshots die je gemaakt hebt. Vreemd genoeg heb je nu een echte Git historie, die je kunt bekijken met het `git log` commando, als je dat op de SHA-1 van de laatste commit uitvoert:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Verbazingwekkend. Je hebt zojuist de lagere operaties uitgevoerd om een Git history op te bouwen, zonder één van de front ends te gebruiken. Dit is in essentie van Git doet als je de `git add` en `git commit` commando's uitvoerd – het slaat de blobs voor de gewijzigde bestanden op, ververst de index, schrijft de bomen weg, en schrijft commit objecten die de bovenste bomen en commits refereren die vlak voor ze kwamen. Deze drie hoofd Git-objecten – de blob, de boom en de commit – worden in eerste instantie als aparte bestanden opgeslagen in je `.git/objects` map. Hier zijn alle objecten die nu in de voorbeeld map staan, voorzien van commentaar met wat ze bevatten:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Als je alle interne verwijzingen volgt, krijg je een object-graaf die er uitzien zoals Figuur 9-3.

Insert 18333fig0903.png 
Figuur 9-3. Alle objecten in je Git map.

### Object Opslag ###

Ik vertelde eerder dat er een kop wordt opgeslagen bij de inhoud. Laten we eens een minuutje kijken naar hoe Git zijn objecten opslaat. Je zult zien hoe je interactief een blob object opslaat – in dit geval de tekst "what is up, doc?" – in de Ruby scripttaal. Je kunt de interactieve Ruby modus starten met het `irb` commando:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git construeert een kop, die begint met het type van het object, in dit geval een blob. Daarna voegt het een spatie toe, gevolgd door de grootte van de inhoud en als laatste een null byte:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git voegt de kop en de originele inhoud samen, en berekent vervolgens de SHA-1 checksum van die nieuwe inhoud. Je kunt de SHA-1 waarde van een regel tekst in Ruby berekenen door de SHA1 verwerkingsbibliotheek op te nemen met het `require` commando en dan `Digest::SHA1.hexdigest()` aan te roepen met de tekst:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git comprimeert de nieuwe inhoud met zlib, wat je in Ruby kunt doen met de zlib bibliotheek. Als eerste moet je de bibliotheek opnemen, en dan `Zlib::Deflate.deflate()' op de inhoud uitvoeren:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Als laatste schrijf je je zlib-gecomprimeerde inhoud naar een object op de schijf. Je zult het pad van het object dat je wilt wegschrijven moeten bepalen (de eerste twee karakters van de SHA-1 waarde zijn de submap naam, en de laatste 38 karakters zijn de bestandsnaam in die map). In Ruby kun je de `FileUtils.mkdir_p()` functie gebruiken om de submap aan te maken als hij nog niet bestaat. Daarna open je het bestand met `File.open()' en schrijft de eerder met zlib gecomprimeerde inhoud in het bestand met een aanroep van `write()` op het resulterende bestands-aangrijpingspunt.

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

Dat is het – je hebt nu een geldig Git blob object aangemaakt. Alle Git objecten zijn op dezelfde manier opgeslagen, alleen de types verschillen – in plaats van de tekst blob, zal de kop beginnen met commit of tree. En alhoewel de blob inhoud vrijwel alles kan zijn, hebben de commit en boom inhoud een zeer specificiek formaat.

## Git Referenties ##

Je kunt zoiets als `git log 1a410e` uitvoeren om door je hele geschiedenis te kijken, maar je moet nog steeds onthouden dat `1a410e` de laatste commit is om die geschiedenis te doorlopen en alle objecten te vinden. Je hebt een bestand nodig waarin je de SHA-1 waarde als een eenvoudige naam kunt opslaan, zodat je die als wijzer kunt gebruiken in plaats van de rauwe SHA-1 waarde.

In Git worden deze "referenties" of "refs" genoemd; je kunt de bestanden die de SHA-1 waarden bevatten vinden in de `.git/refs` map. In het huidige project bevat deze map geen bestanden, maar het bevat wel een eenvoudige structuur:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Om een nieuwe referentie aan te maken, die je zal helpen herinneren waar je laatste commit is, kun je technisch zoiets eenvoudigs als dit doen:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Nu kun je de head referentie, die je zojuist hebt aangemaakt, gebruiken in je Git commando's, in plaats van de SHA-1 waarde:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Je wordt niet aangemoedigd om de referentie bestanden direkt aan te passen. Git levert een veiliger commando mee om dit te doen als je een referentie wilt aanpassen, genaamd `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Dat is eigenlijk wat een branch in Git is: een eenvoudige wijzer of referentie naar de head van een stuk werk. Om een branch te maken terug bij de tweede commit, kun je dit doen:

	$ git update-ref refs/heads/test cac0ca

Je branch zal alleen werk bevatten vanaf die commit en verder:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Nu ziet je Git gegevensbank er conceptueel ongeveer uit zoals in Figuur 9-4.

Insert 18333fig0904.png 
Figuur 9-4. Git map objecten met branch head referenties erbij.

Als je commando's zoals `git branch (branchnaam)` uitvoert, voert Git eigenlijk dat `update-ref` commando uit om de SHA-1 van de laatste commit van de branch waarop je zit, toe te voegen aan welke referentie je ook wil maken.

### De HEAD ###

De vraag is nu, als je `git branch (branchnaam)` uitvoert, hoe weet Git de SHA-1 van de laatste commit? Het antwoord is het HEAD bestand. Het HEAD bestand is een symbolische referentie naar de branch waar je momenteel op zit. Met symbolische referentie bedoel ik dat, in tegenstelling tot een normale referentie, het over het algemeen geen SHA-1 waarde bevat maar een pointer naar een andere referentie. Als je naar het bestand kijkt, zul je normaal gesproken zoiets als dit zien:

	$ cat .git/HEAD 
	ref: refs/heads/master

Als je `git checkout test` uitvoert, zal Git het bestand vernieuwen zodat het er zo uit ziet:

	$ cat .git/HEAD 
	ref: refs/heads/test

Als je `git commit` uitvoert, wordt het commit object gecreëerd, waarbij de ouder van dat commit object gezet wordt naar welke SHA-1 waarde de referentie in HEAD ook wijst.

Je kunt dit bestand ook handmatig aanpassen, maar ook daar bestaat weer een veiliger commando voor: `symbolic-ref`. Je kunt de waarde van je HEAD lezen via dit commando:

	$ git symbolic-ref HEAD
	refs/heads/master

Je kunt de waarde van HEAD ook instellen:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

Je kunt geen symbolische referentie instellen die buiten de refs stijl valt:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Tags ###

Je bent zojuist door drie hoofdobject types van Git gegaan, maar er bestaat een vierde. Het tag object komt veel overeen met een commit object – het bevat een tagger, een datum, een bericht, en een pointer. Het grootste verschil is dat een tag object naar een commit wijst in plaats van een boom. Het is vergelijkbaar met een branch referentie, maar het beweegt nooit – het zal altijd naar dezelfde commit wijzen, maar geeft het een vriendlijker naam.

Zoals besproken in hoofdstuk 2, zijn er twee soorten tags: beschreven en lichtgewicht. Je kunt een lichtgewicht tag maken door zoiets als dit uit te voeren:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Dat is wat een lichtgewicht tag is – een branch die nooit beweegt. Een beschreven tag is echter complexer. Als je een beschreven tag aanmaakt, creëert Git een tag object en schrijft een referentie die daar naar wijst, in plaats van direct naar de commit. Je kunt dit zien door een beschreven tag aan te maken (`-a` specificeert dat het een beschreven tag is):

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 –m 'test tag'

Hier is de object SHA-1 waarde die het creëerde:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Voer nu het `cat-file` commando uit op die SHA-1 waarde:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Zie dat de object regel wijst naar de SHA-1 waarde die je getagged hebt. Zie ook dat het niet naar een commit hoeft te wijzen: je kunt ieder Git object een tag geven. In de Git broncode bijvoorbeeld, heeft de maintainer zijn publieke GPG sleutel als een blob object toegevoegt en het een tag gegeven. Je kunt de publieke sleutel bekijken door dit uit te voeren

	$ git cat-file blob junio-gpg-pub

in de Git broncode. De Linux kernel heeft ook een non-commit-wijzend tag object – het eerste tag object wijst naar de eerste tree van de import van de broncode.

### Remotes ###

Het derde soort referentie dat je zult zien is een remote referentie. Als je een remote toevoegt en er naar pushed, slaat Git de laatste waarde van iedere branch op die je gepushed hebt naar die remote in de `refs/remotes` map. Bijvoorbeeld, je kunt een remote genaamd `origin` toevoegen en je master branch hier naar pushen:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Then, you can see what the `master` branch on the `origin` remote was the last time you communicated with the server, by checking the `refs/remotes/origin/master` file:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Remote references differ from branches (`refs/heads` references) mainly in that they can’t be checked out. Git moves them around as bookmarks to the last known state of where those branches were on those servers.

## Packfiles ##

Let’s go back to the objects database for your test Git repository. At this point, you have 11 objects — 4 blobs, 3 trees, 3 commits, and 1 tag:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git compresses the contents of these files with zlib, and you’re not storing much, so all these files collectively take up only 925 bytes. You’ll add some larger content to the repository to demonstrate an interesting feature of Git. Add the repo.rb file from the Grit library you worked with earlier — this is about a 12K source code file:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

If you look at the resulting tree, you can see the SHA-1 value your repo.rb file got for the blob object:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

You can then use `git cat-file` to see how big that object is:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Now, modify that file a little, and see what happens:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Check the tree created by that commit, and you see something interesting:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

The blob is now a different blob, which means that although you added only a single line to the end of a 400-line file, Git stored that new content as a completely new object:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

You have two nearly identical 12K objects on your disk. Wouldn’t it be nice if Git could store one of them in full but then the second object only as the delta between it and the first?

It turns out that it can. The initial format in which Git saves objects on disk is called a loose object format. However, occasionally Git packs up several of these objects into a single binary file called a packfile in order to save space and be more efficient. Git does this if you have too many loose objects around, if you run the `git gc` command manually, or if you push to a remote server. To see what happens, you can manually ask Git to pack up the objects by calling the `git gc` command:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

If you look in your objects directory, you’ll find that most of your objects are gone, and a new pair of files has appeared:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

The objects that remain are the blobs that aren’t pointed to by any commit — in this case, the "what is up, doc?" example and the "test content" example blobs you created earlier. Because you never added them to any commits, they’re considered dangling and aren’t packed up in your new packfile.

The other files are your new packfile and an index. The packfile is a single file containing the contents of all the objects that were removed from your filesystem. The index is a file that contains offsets into that packfile so you can quickly seek to a specific object. What is cool is that although the objects on disk before you ran the `gc` were collectively about 12K in size, the new packfile is only 6K. You’ve halved your disk usage by packing your objects.

How does Git do this? When Git packs objects, it looks for files that are named and sized similarly, and stores just the deltas from one version of the file to the next. You can look into the packfile and see what Git did to save space. The `git verify-pack` plumbing command allows you to see what was packed up:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1
	05408d195263d853f09dca71d55116663690c27c \
	  ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Here, the `9bc1d` blob, which if you remember was the first version of your repo.rb file, is referencing the `05408` blob, which was the second version of the file. The third column in the output is the size of the object in the pack, so you can see that `05408` takes up 12K of the file but that `9bc1d` only takes up 7 bytes. What is also interesting is that the second version of the file is the one that is stored intact, whereas the original version is stored as a delta — this is because you’re most likely to need faster access to the most recent version of the file.

The really nice thing about this is that it can be repacked at any time. Git will occasionally repack your database automatically, always trying to save more space. You can also manually repack at any time by running `git gc` by hand.

## The Refspec ##

Throughout this book, you’ve used simple mappings from remote branches to local references; but they can be more complex.
Suppose you add a remote like this:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

It adds a section to your `.git/config` file, specifying the name of the remote (`origin`), the URL of the remote repository, and the refspec for fetching:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

The format of the refspec is an optional `+`, followed by `<src>:<dst>`, where `<src>` is the pattern for references on the remote side and `<dst>` is where those references will be written locally. The `+` tells Git to update the reference even if it isn’t a fast-forward.

In the default case that is automatically written by a `git remote add` command, Git fetches all the references under `refs/heads/` on the server and writes them to `refs/remotes/origin/` locally. So, if there is a `master` branch on the server, you can access the log of that branch locally via

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

They’re all equivalent, because Git expands each of them to `refs/remotes/origin/master`.

If you want Git instead to pull down only the `master` branch each time, and not every other branch on the remote server, you can change the fetch line to

	fetch = +refs/heads/master:refs/remotes/origin/master

This is just the default refspec for `git fetch` for that remote. If you want to do something one time, you can specify the refspec on the command line, too. To pull the `master` branch on the remote down to `origin/mymaster` locally, you can run

	$ git fetch origin master:refs/remotes/origin/mymaster

You can also specify multiple refspecs. On the command line, you can pull down several branches like so:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In this case, the  master branch pull was rejected because it wasn’t a fast-forward reference. You can override that by specifying the `+` in front of the refspec.

You can also specify multiple refspecs for fetching in your configuration file. If you want to always fetch the master and experiment branches, add two lines:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

You can’t use partial globs in the pattern, so this would be invalid:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

However, you can use namespacing to accomplish something like that. If you have a QA team that pushes a series of branches, and you want to get the master branch and any of the QA team’s branches but nothing else, you can use a config section like this:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

If you have a complex workflow process that has a QA team pushing branches, developers pushing branches, and integration teams pushing and collaborating on remote branches, you can namespace them easily this way.

### Pushing Refspecs ###

It’s nice that you can fetch namespaced references that way, but how does the QA team get their branches into a `qa/` namespace in the first place? You accomplish that by using refspecs to push.

If the QA team wants to push their `master` branch to `qa/master` on the remote server, they can run

	$ git push origin master:refs/heads/qa/master

If they want Git to do that automatically each time they run `git push origin`, they can add a `push` value to their config file:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Again, this will cause a `git push origin` to push the local `master` branch to the remote `qa/master` branch by default.

### Deleting References ###

You can also use the refspec to delete references from the remote server by running something like this:

	$ git push origin :topic

Because the refspec is `<src>:<dst>`, by leaving off the `<src>` part, this basically says to make the topic branch on the remote nothing, which deletes it. 

## Transfer Protocols ##

Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate.

### The Dumb Protocol ###

Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library:

	$ git clone http://github.com/schacon/simplegit-progit.git

The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished:

	=> GET HEAD
	ref: refs/heads/master

You need to check out the `master` branch when you’ve completed the process. 
At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

That gives you your next commit object. Grab the tree object:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first:

	=> GET objects/info/http-alternates
	(empty file)

If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning.

The entire output of this process looks like this:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### The Smart Protocol ###

The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data.

#### Uploading Data ####

To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side.

For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`).

Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing.

Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side.

Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication:

	000Aunpack ok

#### Downloading Data ####

When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down.

There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it.

If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In either case, after `fetch-pack` connects, `upload-pack` sends back something like this:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone.

At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes.

## Maintenance and Data Recovery ##

Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios.

### Maintenance ###

Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old.

You can run auto gc manually as follows:

	$ git gc --auto

Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively.

The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this:

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file.

Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to.

### Data Recovery ###

At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back?

Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, move the `master` branch back to the middle commit:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right?

Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog.

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again. 
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `--full` option, it shows you all objects that aren’t pointed to by another object:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA.

### Removing Objects ###

There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there.

This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects.

Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits.

To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — you didn’t want to add a huge tarball to your project. Better get rid of it:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Now, `gc` your database and see how much space you’re using:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

You can run the `count-objects` command to quickly see how much space you’re using:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it.

First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `--objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

The `--index-filter` option is similar to the `--tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm --cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `--tree-filter` if you want. The `--ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer.

Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Let’s see how much space you saved.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune --expire`.

## Summary ##

You should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helping scripts to make your specific workflow work for you.

Git as a content-addressable filesystem is a very powerful tool that you can easily use as more than just a VCS. I hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways.
