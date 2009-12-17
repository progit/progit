# Het Binnenwerk van Git #

Je zult misschien naar dit hoofdstuk gesprongen zijn vanuit een vorig hoofdstuk, of je zult hier gekomen zijn nadat je de rest van het boek gelezen hebt – in ieder geval, zal hier het binnenwerk en implementatie van Git behandeld worden. Ik heb gemerkt dat het leren van deze informatie van fundamenteel belang is om te begrijpen hoe bruikbaar en krachtig Git is, maar anderen hebben daar tegenin gebracht dat het erg verwarrend en onnodig complex kan zijn voor beginners. Daarom heb ik deze beschrijving het laatste hoofdstuk gemaakt in het boek, zodat je het vroeg of later kunt lezen in je leerproces. Ik laat het aan jou over om dat te beslissen.

Laten we beginnen, nu je hier bent. Als eerste, mocht het nog niet duidelijk zijn, is Git eigenlijk een inhouds-toegankelijk bestandssyteem met een gebruikersinterface voor versiebeheer er bovenop geschreven. Je zult over een poosje meer leren over wat dit betekent.

In de eerste dagen van Git (het meerendeel pre 1.5), wat de gebruikersinterface veel complexer, omdat het de nadruk legde op dit bestandssysteem in plaats van op een gepolijst VCS. De laatste paar jaren is de interface verfijnd totdat het zo netjes en eenvoudig te gebruiken is als ieder systeem dat er bestaat; maar vaak blijft het stereotype hangen over de vroegere Gitinterface, die complex was en moeilijk te leren.

Deze laag met het inhouds-toegankelijke bestandssysteem is ongelofelijk gaaf, dus dat behandel ik dat als eerste dit hoofdstuk; daarna leer je over de transportmechanismen en het onderhouden van je repository's, iets waar je uiteindelijk te maken mee kunt krijgen.

## Sanitaire Inrichtingen en Porcelein ##

Dit boek behandeld Git met ongeveer 30 werkwoorden zoals `checkout`, `branch`, `remote` enzovoorts. Maar omdat Git in eerste instantie een toolkit voor een VCS was, in plaats van een volledig gebruiksvriendelijk VCS, heeft het een berg werkwoorden die laagbijdegronds werk doen en ontworpen waren om samengevoegd te worken zoals in UNIX gebruikelijk is, of vanuit scripts aangeroepen te worden. Naar deze commando's wordt over het algemeen als "plumbing" (sanitaire voorzieningen) commando's verwezen, en de meer gebruiksvriendelijke commando's worden "porcelain" (porcelein) commando's genoemd.

De eerste acht hoofdstukken van het boek behandelen bijna alleen porceleincommando's. Maar in dit hoofdstuk zul je het meest op het laagste niveau van de sanitaire voorzieningen om te gaan. Zij geven je toegang tot de diepste delen van Git, en demonstreren hoe en waarom Git doet wat het doet. Deze commando's zijn niet bedoeld voor normaal gebruik op de commandoregel, maar meer om als bouwstenen voor nieuwe tools en scripts gebruikt te worden.

Als je `git init` uitvoert in een nieuwe of bestaande map, zal Git de map `.git` aanmaken, wat de plek is waar Git bijna alles opslaat en manipuleert. Als je een backup of kopie van je repository wilt maken, dan hoef je alleen maar die map te kopiëren, en je hebt bijna alles wat je nodig hebt. Dit hele hoofdstuk gaat in essentie over de inhoud van deze map. Hier zie je hoe het eruit ziet:

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

Je kunt een paar andere bestanden zien, maar dit is een verse `git init` repository – dit is wat je standaard ziet. De `branches` map wordt niet gebruikt door nieuwere Git versies, en het `description` bestand wordt alleen gebruikt door het programma GitWeb, dus je hoeft je daar niet druk over te maken. Het bestand `config` bevat je project-specifieke configuratieopties, en de `info` map bevat een bestand met bestandsnaampatronen die je niet wilt volgen, maar ook niet wilt opnemen in een .gitignore bestand. De map `hooks` bevat scripts die aan bepaalde acties zijn “gehaakt” van gebruikers- en serverkant, die in detail beschreven zijn in Hoofdstuk 6.

Dit laat vier belangrijke vermeldingen over: de bestanden `HEAD` en `index`, en de mappen `objects` en `refs`. Dit zijn de kernbestandsdelen van Git. De map `objects` bewaart alle inhoud van je databank, de map `refs` bevat verwijzingen (branches) naar commitobjecten in die databank, het bestand `HEAD` wijst naar de branch die je op dit moment uitgechecked hebt, en het bestand `index` is waar Git de informatie van je wachtrij opslaat. Je gaat nu in detail naar elk van deze secties kijken om te zien hoe Git werkt.

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

Daarna kun je zien wat de `master` branch op de `origin` remote was toen je voor 't laatst met de server communiceerder, door het `refs/remotes/origin/master`bestand te bekijken:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Remote referenties verschillen hoofdzakelijk van branches (`refs/heads referenties) in het feit dat ze niet uitgechecked kunnen worden. Git verplaatst ze als boekenleggers naar de laatste status van die branches op de servers. 

## Packfiles ##

Laten we eens terug gaan naar de object-databank van je test Git repository. Op dit punt heb je 11 objecten – 4 blobs, 3 bomen, 3 commits en 1 tag:

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

Git comprimeert de inhoud van deze bestanden met zlib, en je slaat maar weinig op, dus nemen deze bestanden samen maar 925 bytes in beslag. Je zult nu wat grotere inhoud toevoegen aan het repository om een interessante eigenschap van Git te demonstreren. Voeg het repo.rb bestand toe van de Grit bibliotheek waaraan je eerder gewerkt hebt – dit is een broncode bestand van ongeveer 12K groot:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Als je naar de resulterende boom kijkt, kun je zien welke SHA-1 waarde je repo.rb gekregen heeft voor het blob object:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Je kunt dan het `git cat-file` commando gebruiken om te zien hoe groot dat object is:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Pas het bestand nu eens een beetje aan, en kijk wat er gebeurd:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Bekijk de boom die door de commit gemaakt is, en je zult iets interessants zien:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

De blob is nu een andere blob, wat betekent dat alhoewel je slechts een enkele regel aan het eind van een bestand van 400 regels toegevoegd hebt, Git die nieuwe inhoud als een compleet nieuw object opgeslagen heeft:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

Je hebt nu twee vrijwel identieke 12K grote objecten op je disk. Zou het niet fijn zijn als Git één van de twee volledig op kon slaan, en het tweede object slechts als delta tussen die en de eerste?

Het blijkt dat dat kan. Het initiele formaat waarin Git objecten opslaat op disk wordt een los object formaat genoemd. Maar, eens in de zoveel tijd pakt Git een aantal van die objecten in een enkel binair bestand wat een packfile genoemd wordt, om wat ruimte te besparen en efficiënter te zijn. Git doet dit als je teveel losse objecten rond hebt slingeren, als je het `git gc` commando handmatig uitvoert, of als je naar een remote server pushed. Om te zien wat er gebeurd, kun je Git handmatig vragen om de objecten in te pakken met het `git gc` commando:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

Als je in je objecten map kijkt, zul je zien dat de meeste objecten verdwenen zijn, en er een aantal nieuwe bestanden verschenen zijn:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

De objecten die overgebleven zijn, zijn de blobs waarnaar geen enkel commit wijst – in dit geval zijn het de "what is up, doc?" en de "test content" voorbeeld-blobs die je eerder aangemaakt hebt. Omdat je ze nooit aan een commit toegevoegd hebt, worden ze beschouwd als 'rondslingerend' en worden ze niet in je nieuwe packfile ingepakt.

De andere bestanden zijn je nieuwe packfile en een index. De packfile is een enkel bestand dat de inhoud bevat van alle objecten die van je bestandssysteem verwijderd zijn. De index is een bestand dat offsets binnen de packfile bevat, zodat je snel naar een specifiek object kunt zoeken. Wat cool is, is dat alhoewel de objecten op de disk voordat je `gc` aanriep samen zo'n 12K groot waren, is de nieuwe packfile slechts 6K. Je hebt je diskverbruik gehalveerd door je bestanden in te pakken.

Hoe doet Git dit? Als Git objecten inpakt, zoekt het naar bestanden die gelijk genaamd en in grootte zijn, en slaat slechts de delta's van één versie van het bestand naar de volgende op. Je kunt in de packfile kijken en zien wat Git gedaan heeft om ruimte te besparen. Het `git verify-pack` sanitaire voorzieningen commando stelt je in staat om te zien wat er ingepakt is:

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

Hier refereert de `9bc1d` blob, wat als je je dat herinnert de eerste versie is van je repo.rb bestand, aan de `05408` blob, wat de tweede versie was van het bestand. De derde kolom in de uitvoer is e grootte van het object in het pakket, zodat je kunt zien dat `05408` 12K van het bestand in beslag neemt maar dat `9bc1d` slechts 7 bytes in beslag neemt. Wat ook interessant is, is dat de tweede versie van het bestand degene is die intakt opgeslagen wordt, terwijl de originele versie als delta opgeslagen wordt – dit is zo gedaan omdat het waarschijnlijker is dat je snellere toegang nodig hebt tot de meest recente versie van het bestand.

Het fijnste van dit alles is, is dat het op ieder gewenst moment opnieuw ingepakt kan worden. Git zal op z'n tijd je databank automatisch opnieuw inpakken, waarmee het altijd meer ruimte wil besparen. Je kunt ook handmatig opnieuw inpakken op ieder tijdstip, door `git gc` met de hand uit te voeren.

## De Refspec ##

Door dit boek heen heb je eenvoudige verwijzingen van remote branches naar lokale referenties gebruikt; maar ze kunnen complexer zijn.
Stel dat je een remote zoals dit toevoegt:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

Dit voegt een sectie aan je `.git/config` bestand toe, wat de naam van de remote (`origin`) specificeerd, de URL van de remote repository, en de refspec die nodig is om te fetchen:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Het formaat van de refspec is een optionele `+`, gevolgd door `<src>:<dst>`, waarbij `<src>` het patroon voor referenties aan de remote kant is, en `<dst>` is de locatie waar die referenties lokaal geschreven worden. De `+` verteld Git om de referentie zelfs te vernieuwen als het geen fast-forward is.

In het standaard geval dat automatisch geschreven wordt door een `git remote add` commando, haalt Git alle referenties onder `refs/heads/` van de server en schrijft ze lokaal naar `refs/remotes/origin/`. Dus als er een `master` branch op de server bestaat, kun je de log van die branch lokaal benaderen via

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Ze zijn allemaal gelijk, omdat Git elk expandeerd naar `refs/remotes/origin/master`.

Als je wilt dat Git alleen de `master` branch pulled, en niet alle andere branches op de remote server, kun je de fetch regel veranderen in

	fetch = +refs/heads/master:refs/remotes/origin/master

Dit is alleen de standaard refspec voor `git fetch` voor die remote. Als je iets alleen eenmalig wilt doen, kun je de refspec ook op de commandoregel specificeren. Om de `master` branch op de remote naar de lokale `origin/mymaster` te pullen, kun je dit uitvoeren

	$ git fetch origin master:refs/remotes/origin/mymaster

Je kunt ook meerdere refspecs specificeren. Met de commandoregel kun je meerdere branches op deze manier pullen:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In dit geval wordt de pull van de master branch geweigerd, omdat het geen fast-forward referentie is. Je kunt dat teniet doen door de `+` voor de refspec te zetten.

Je kun ook meerdere refspecs voor het fetchen specificeren in je configuratie bestand. Als je altijd de master en experiment branches wilt fetchen, voeg dan twee regels toe:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Je kunt geen gedeeltelijke globs in het patroon gebruiken, dus het volgende zou ongeldig zijn:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Maar je kunt wel naamruimtes gebruiken om zoiets voor elkaar te krijgen. Als je een QA team hebt dat naar een serie branches pushed, en je wilt de master branch en alle QA team branches hebben, maar niets anders, kun je een configuratie sectie zoals dit gebruiken:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

Als je een ingewikkeld werkproces hebt waarbij het QA team branches pushed, ontwikkelaars branches pushen, en integratie teams pushen en samenwerken op remote branches, kun je ze op deze manier eenvoudig in naamruimten stoppen.

### Refspecs Pushen ###

Het is fijn dat je op die manier referenties in naamruimten kunt fetchen, maar hoe krijgt het QA team in de eerste plaats al hun branches in een `qa/` naamruimte? Je krijgt dat voor elkaar door refspecs te gebruiken om mee te pushen.

Als het QA team hun `master` branch naar `qa/master` op de remoter server wil pushen, kunnen ze dit uitvoeren

	$ git push origin master:refs/heads/qa/master

Als ze willen dat Git dat automatisch doet iedere keer als ze `git push origin` uitvoeren, dan kunnen ze een push waarde aan hun configuratie bestand toevoegen:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Nogmaals, dit zal zorgen dat `git push origin` de lokale `master` branch standaard naar de remote `qa/master` branch zal pushen.

### Referenties Verwijderen ###

Je kunt de refspec ook gebruiken om referenties te verwijderen van de remote server door zoiets als dit uit te voeren:

	$ git push origin :topic

Omdat de refspec `<src>:<dst>` is, verteld het weglaten van het `<src>` gedeelte in feite dat de onderwerp branch op de remote niks is, wat het verwijderd.

## Overdracht Protocollen ##

Git kan gegevens tussen twee repositories hoofdzakelijk overdragen op twee manieren: via HTTP en via de zogenaamde slimme protocollen die in de `file://`, `ssh://` en `git://` overdrachten gebruikt worden. Deze sectie zal laten zien hoe deze hoofdprotocollen werken.

### Het Domme Protocol ###

Naar Git overdracht over HTTP wordt vaak gerefereerd als het domme protocol, omdat het geen Git-specifieke code vereist op de server gedurene het overdrachtsprocess. Het fetch process is een reeks van GET verzoeken, waarbij de client de opmaak van het Git repository van de server kan overnemen. Laten we het `http-fetch` process eens volgen voor de simplegit bibliotheek:

	$ git clone http://github.com/schacon/simplegit-progit.git

Het eerste wat dit commando doet is het `info/refs` bestand pullen. Dit bestand wordt geschreven door het `update-server-info` commando, en dat is de reden waarom je dat als een `post-recieve` haak in moet stellen voordat de HTTP overdracht naar behoren werkt:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Nu heb je een lijst met de remote referenties en SHA's. Daarna kijk je naar wat de HEAD referentie is, zodat je weet wat je uit moet checken zodra je klaar bent:

	=> GET HEAD
	ref: refs/heads/master

Je moet de `master` branch uitchecken zora je het proces afgerond hebt.
Op dit punt ben je klaar om het doorloop proces te starten. Omdat je startpunt het `ca82a6` commit object is dat je in het `info/refs` bestand zag, begin je met dit op te halen:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

Je krijgt een object terug – dat object staat in los formaat op de server, en je hebt het gehaald door een statisch HTTP GET verzoek. Je kunt het met zlib decomprimeren, de kop eraf halen, en naar de commit inhoud kijken:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Daarna heb je nog twee objecten op te halen – `cfda3b`, wat de boom is met inhoud waar de commit die je zojuist hebt opgehaald naar wijst; en `085bb3`, wat de ouder commit is:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

Dat geeft je je volgende commit object. Pak het boom object:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops – het ziet ernaar uit dat dat boom object niet in het losse formaat op de server bestaat, dus krijg je een 404 antwoord. Er zijn hiervoor een aantal redenen – het object kan in een ander repository staat, of het kan in een packfile in dit repository staat. Git gaat eerst naar de genoemde alternatieven kijken:

	=> GET objects/info/http-alternates
	(empty file)

Als dit een lijst met alternatieve URL's bevat, zal Git daar voor losse bestanden en packfiles gaan kijken – dit is een fijn mechanisme voor projecten die een forks zijn van een ander zodat ze objecten kunnen delen op de schijf. Maar, omdat er in dit geval geen alternatieven vermeld staan, moet je object in een packfile zitten. Om te zien welke packfiles beschikbaar zijn op deze server, moet je het `objects/info/packs` bestand halen, wat een lijst hiervan bevat (ook gegenereerd door `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Er is slechts één packfile op de server, dus je object zit daar natuurlijk in, maar je bekijkt het index bestand om het zeker te weten. Dit is ook handig als je meerdere packfiles op de server hebt, zodat je kunt zien welke packfile het object dat je nodig hebt bevat:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Nu dat je de packfile index hebt, kun je zien of je object hier in zit – omdat de index de SHA's van de objecten in de packfile toont en de offset naar die objecten. Je object is aanwezig, dus ga ervoor en haal de hele packfile op:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Je hebt je boom object, dus je kunt verder gaan met het doorlopen van je commits. Ze zitten ook allemaal in de packfile die je zojuist gedownload hebt, dus je hoeft geen verzoeken meer te doen aan je server. Git checked een werkkopie uit van de `master` branch waarnaar gewezen werd door de HEAD referentie, die je aan het begin gedownload hebt.

Het gehele uitvoer van dit proces ziet er zo uit:

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

### Het Slimme Protocol ###

De HTTP methode is eenvoudig, maar een beetje inefficient. Slimme protocollen gebruiken is een meer gebruikte manier van gegevensoverdracht. Deze protocollen hebben een proces aan de remote kant dat bewust is van Git – het kan lokale gegevens lezen en uitvinden wat de client heeft, of nodig heeft en hier eigen gegevens voor genereren. Er zijn twee sets processen voor gegevensoverdracht: een paar voor het uploaden van gegevens, en een paar voor het downloaden van gegevens.

#### Gegevens Uploaden ####

Om gegevens te uploaden naar een remote proces, gebruikt Git de `send-pack` en `receive-pack` processen. Het `send-pack` proces draait op de client en maakt contact met een `receive-pack` proces aan de remote kant.

Bijvoorbeeld, stel dat je `git push origin master` uitvoert in je project, en `origin` is gedefinieerd als een URL dat het SSH protocol gebruikt. Git start het `send-pack` proces, wat een verbinding initieert, via SSH, naar je server. Het probeert een commando op de remote server uit te voeren met behulp van een SSH aanroep die er ongeveer zo uit ziet:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Het `git-receive-pack` commando antwoord onmiddelijk met één regel voor iedere referentie die het momenteel heeft – in dit geval alleen de `master` branch en zijn SHA. De eerste regel bevat ook een lijst van de mogelijkheden van de server (in dit geval, `report-status` en `delete-refs`).

Iedere regel begint met een hexadecimale waarde van 4 bytes, die specificeert hoe lang de rest van de regel is. Je eerste regel begint met 005b, wat 91 in hex is, wat betekend dat er nog 91 bytes over zijn op deze regel. De volgende regel begint met 003e, wat 62 is, zodat je de overgebleven 62 bytes leest. De volgende regel is 0000, wat betekent dat de server klaar is met het tonen van zijn referenties.

Nu dat het de status van de server weet, bepaalt je `send-pack` proces welke commits dat het heeft, die de server nog niet heeft. Voor iedere referentie die deze push zal vernieuwen, verteld het `send-pack` het `receive-pack` proces die informatie. Bijvoorbeeld, als je de `master` branch vernieuwt en een `experiment` branch toevoegt, zou het `send-pack` antwoord er zo uit kunnen zien:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

Een SHA-1 waarde met alleen '0' betekent dat er nog niets was – omdat je de experiment referentie toevoegt. Als je een referentie aan het verwijderen was, zou je het tegenovergestelde zien: allemaal '0' aan de rechterkant.

Git stuurt een regel voor iedere referentie die je vernieuwt, met de oude SHA, de nieuwe SHA en de referentie die vernieuwd wordt. De eerste regel bevat ook de mogelijkheden van de client. Vervolgens upload de client een packfile met alle objecten die de server nog niet heeft. Als laatste antwoord de server met een succes (of mislukking) indicatie:

	000Aunpack ok

#### Gegevens Downloaden ####

Op het moment dat je gegevens download zijn de `fetch-pack` en `upload-pack` processen betrokken. De client start een `fetch-pack` proces dat verbinding maakt met een `upload-pack` proces aan de remote kant om te onderhandelen welke gegevens gestuurd moeten worden.

Er zijn verschillende manieren om het `upload-pack` proces op de remote repository te starten. Je kunt het uitvoeren via SSH, op dezelfde manier als het `receive-pack` proces. Je kunt het proces ook starten via de Git daemon, die standaard op poort 9418 luistert. Het `fetch-pack` proces stuurt gegevens, die er zo uitzien voor de daemon na het maken van de verbinding:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Het begint met de 4 bytes die specificeren hoeveel gegevens er volgen, daarna het commando gevolgd door een null byte, en dan de hostname van de server gevolgd door een laatste null byte. De Git daemon bekijkt of dat commando uitgevoerd kan worden, dat het repository bestaat en dat het publieke permissies heeft. Als alles OK is, dan start het het `upload-pack` proces en geeft hier het verzoek aan door.

Als je de fetch via SSH dper, voert het `fetch-pack` in plaats daarvan zoiets als dit uit:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In beide gevallen stuurt `upload-pack`, nadat `fetch-pack` verbinding gemaakt heeft, zoiets als dit:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Dit komt erg overeen met waarmee `receive-pack` antwoord, maar de mogelijkheden zijn verschillend. Daarnaast stuurt het de HEAD referentie zodat de client weet wat er uitgechecked moet worden als dit een clone is.

Op dit punt kijkt het `fetch-pack` process naar welk objecten dat het heeft en antwoord met de objecten die het nodig heeft door "want" te sturen, gevolgd door de SHA die het wil. Het stuurt al de objecten die het al heeft met "have" en dan de SHA. Aan het einde van deze lijst, schrijft het "done" om het `upload-pack` proces te starten met het sturen van de packfile van de gegevens die het nodig heeft:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

Dat is een basaal geval van de overdrachtsprotocollen. In meer complexe gevallen ondersteunt de client `multi_ack` of `side-band` mogelijkheden; maar dit voorbeeld toont je de basale heen en weer gang die gebruikt wordt door de slimme protocol processen.

## Onderhoud en het Herstellen van Gegevens ##

Soms moet je wat opruimen – een repository compacter maken, een geimporteerd repository opruimen, of verloren werk terughalen. Deze sectie zal deze scenario's doorlopen.

### Onderhoud ###

Soms voert Git automatisch een commando genaamg "auto gc" uit. Het meerendeel van de tijd doet dit commando niets. Maar, als je teveel losse objecten (objecten die niet in een packfile zitten) of teveel packfiles hebt, dan lanceert Git een volledig `git gc` commando. Het `gc` staat voor garbage collect (afval ophalen), en het commando doet een aantal zaken: het haalt alle losse objecten op en stopt ze in packfiles, het voegt packfiles samen in één grote packfile, en het verwijderd objecten die niet bereikbaar zijn vanuit een commit en die een paar maanden oud zijn.

Je kunt auto gc als volgt handmatig uitvoeren:

	$ git gc --auto

Nogmaals, over het algemeen doet dit commando niets. Je moet ongeveer 7.000 losse objecten of meer dan 50 packfiles hebben voordat Git een echt gc commando start. Je kunt deze grenzen respectievelijk met de `gc.auto` en `gc.autopacklimit` configuratie instellingen aanpassen.

Het andere ding dat `gc` zal doen is je referenties in een enkel bestand inpakken. Stel dat je repository de volgende branches en tags bevat:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

Als je `git gc` uitvoert, zul je deze bestanden niet langer in de `refs` map hebben. Git zal ze omwille van efficientie in een bestand genaamd `.git/packed-refs` stoppen, dat er zo uitziet:

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

Als je een referentie vernieuwt, zal Git dit bestand niet aanpassen maar een nieuw bestand in `refs/heads` schrijven. Om de juiste SHA voor een gegeven referentie te krijgen, kijkt Git voor die referentie in de `refs` map en kijkt in het `packed-res` bestand als terugval optie. Hoe dan ook, als je een referentie niet in de `refs` map kunt vinden, zit het waarschijnlijk in je `packed-refs` bestand.

Let op de laatste regel van het bestand, die begint met een `^`. Dit betekent dat de tag die er direct boven staat een beschreven tag is, en dat die regel e commit is waar de beschreven tag naar wijst.

### Gegevens Herstellen ###

Op een bepaald punt in je reis met Git, kun je per ongeluk wel eens een commit verliezen. Over het algemeen gebeurd dit omdat je een branch force-delete, waar werk op zat, en het blijkt dat je de branch uit eindelijk toch wou hebben; of je hard-reset een branch, waarmee je commits achterlaat waar je iets van wou hebben. Stel dat dit gebeurd, hoe kun je dan je commits terug halen?

Hier is een voorbeeld dat een hard-reset doet naar een oudere commit op de master branch in je test repository, en de verloren commits terug haalt. Laten we eerst eens bekijken waar je repository op dit punt staat:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Nu verplaats je de `master` branch terug naar de middelste commit:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Je bent nu effectief de twee bovenste commits kwijt – je hebt geen branch vanwaar deze commits bereikbaar zijn. Je moet de laatste commit SHA vinden en dan een branch toevoegen die daar naar wijst. De truuk is om de laatste commit SHA te vinden – het is toch niet alsof je die onthouden hebt, toch?

Vaak is de snelste manier een tool genaamd `git reflog` te gebruiken. Terwijl je werkt slaat Git stilletjes op wat je HEAD is, iedere keer als je die wijzigt. Iedere keer dat je commit, of van branch veranderd wordt de reflog vernieuwd. Het reflog wordt ook vernieuwd door het `git update-ref` commando, wat nog een reden is om het te gebruiken in plaats van gewoon de SHA's naar je ref bestanden te schrijven, zoals we beschreven hebben in de "Git References" sectie eerder in dit hoofdstuk. Je kunt op ieder moment zien waar je geweest bent, door `git reflog` uit te voeren.

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Hier kunnen we de twee commits zien die we uitgechecked hadden, maar er is niet veel informatie aanwezig. Om dezelfde informatie op een veel bruikbaarder manier kunnen we `git log -g` uitvoeren, wat je een normale log uitvoer geeft voor je reflog.

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

Het ziet er naar uit dat de onderste commit degene is die je kwijt bent geraakt, dus je kunt hem herstellen door een nieuwe branch te maken op die commit. Bijvoorbeeld, je kunt een branch genaamd `recover-branch` beginnen op die commit (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Vet – nu heb je een branch genaamd `recover-branch` die staat op het punt waar je `master` branch was, waarmee de eerste twee commits weer bereikbaar zijn.
Vervolgens, stel dat je verloren commit om een of andere reden niet in de reflog stond – je kunt dat simuleren door `recover-branch` te verwijderen en het reflog te wissen. Nu zijn de eerste twee commits niet meer bereikbaar door wat dan ook:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

Omdat de reflog gegevens bewaard worden in de `.git/logs/` map, heb je effectief geen reflog. Hoe kun je die commit op dat punt herstellen? Één manier is om gebruik te maken van het `git fsck` tool, wat de integriteit van je gegevensbank controleert. Als je het met de `--full` optie uitvoert, dan toont het je alle objecten waarnaar niet gewezen wordt door een ander object:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In dit geval, kun je je vermiste commit zien na de hangende commit. Je kunt het op dezelfde manier herstellen, door een branch toe te voegen die naar die SHA wijst.

### Objecten Verwijderen ###

Er zijn een hoop geweldige dingen aan Git, maar één eigenschap die problemen kan geven is het feit dat `git clone` de hele historie van het project download, inclusief alle versies van alle bestanden. Dat is geen probleem als het hele ding broncode is, omdat Git zeer geoptimaliseerd is om die gegevens optimaal te comprimeren. Maar, als iemand op een bepaald punt in de geschiedenis een enkel enorm bestand heeft toegevoegd, zal iedere clone voor altijd gedwongen worden om dat grote bestand te downloaden, zelfs als het uit het project was verwijderd in de volgende commit. Omdat het bereikbaar is vanuit de geschiedenis, zal het er altijd zijn.

Dit kan een groot probleem zijn als je Subversion of Perforce repositories omzet naar Git. Omdat je niet de hele geschiedenis download in die systemen, zal dit soort toevoeging een paar gevolgen met zich meebrengen. Als je een import vanuit een ander systeem deed, of om een andere reden vindt dat je repository veel groter is dan het zou moeten zijn, kun je hier zien hoe je grote objecten kunt vinden en verwijderen.

Let op: deze techniek is verwoestend voor je commit geschiedenis. Het herschrijft ieder commit object stroomafwaarts vanaf de eerste boom die je moet aanpassen om een referentie naar een groot bestand te verwijderen. Als je dit meteen na een import doet, voordat iemand werk is gaan baseren op de commit, dan is er niets aan de hand – anders moet je alle bijdragers waarschuwen dat ze hun werk op je nieuwe commits moeten rebasen.

Om het te demonstreren, voeg je een groot bestand in je test repository toe, verwijderd het in de volgende commit, vindt het, en verwijderd het permanent uit het repository. Als eerste, voeg je een groot object toe aan je geschiedenis:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — je wou geen enorme tarball toevoegen aan je project. Laten we er snel vanaf zien te komen:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Nu `gc` je je gegevensbank en zie hoeveel ruimte je gebruikt:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

Je kunt het `count-objects` commando gebruiken om snel te zien hoeveel ruimte je gebruikt:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

Op de `size-pack` regel staat de grootte van je packfiles in kilobytes, dus je gebruikt 2Mb. Voor de laatste commit gebruikte je bijna 2K – dus het is duidelijk dat het verwijderen van het bestand uit de vorige commit, het niet uit je geschiedenis verwijderd heeft. Iedere keer als iemand dit repository cloned, zullen ze de volle 2Mb moeten clonen alleen maar om dit kleine project te krijgen, omdat jij per ongeluk een groot bestand toegevoegd hebt. Laten we het kwijtraken.

Eerst moet je het vinden. In dit geval weet je al welk bestand het is. Maar stel dat je het niet wist; hoe zou je kunnen vinden welk bestand of bestanden zoveel ruimte in beslag nemen? Als je `git gc` uitvoert zitten alle objecten in een packfile; je kunt de grote bestanden identificeren door een ander sanitaire voorzieningen commando genaamd `git verify-pack` uit te voeren en te sorteren op het derde veld in de uitvoer, wat de bestandsgrootte is. Je kunt het ook door het `tail` commando leiden omdat je alleen geinteresseerd bent in het laatste paar grote bestanden. 

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

Het grote object staat aan het einde: 2 Mb. Om uit te vinden welk bestand het is, zul je het `rev-list` commando gebruiken, wat je kort gebruikt hebt in Hoofdstuk 7. Als je `--objects` meegeeft aan `ref-list`, toont het alle commit SHA's en ook de blob SHA's met de bestandspaden die er aan geassocieerd zijn. Je kunt dit gebruiken om de naam van je blob te vinden:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Nu moet je dit bestand verwijderen van alle bomen in je verleden. Je kunt eenvoudig zien welke commits dit bestand aangepast hebben:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Je moet alle commits die stroomafwaarts van `6df76` liggen om dit bestand volledig uit je Git geschiedenis te verwijderen. Omdat te doen gebuik je `filter-branch`, wat je in Hoofdstuk 6 gebruikt hebt:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

De `--index-filter` optie is vergelijkbaar met de `--tree-filter` optie, die gebruikt is in Hoofstuk 6, behalve dan dat in plaats van het doorgeven van een commando dat bestanden aanpast die uitgechecked staan op je schijf, pas je je staging gebied of index iedere keer aan. In plaats van een specifiek bestand steeds te verwijderen met zoiets als `rm file`, moet je het met `git rm --cached` verwijderen – je moet het uit de index verwijderen, niet van de schijf. Reden om het zo te doen is snelheid – omdat Git niet iedere versie hoeft uit te checken op je schijf voordat het je filter uitvoert, kan het proces vele, vele malen sneller gaan. Je kunt dezelfde taak uitvoeren met `--tree-filter` als je dat wil. De `--ignore-unmatch` optie op `git rm` verteld het niet te stoppen op een fout als het patroon dat je probeert te verwijderen niet aanwezig is. Als laatste zul je `filter-branch` vragen om je geschiedenis alleen vanaf de `6df7640` commit te herschrijven, omdat je weet dat dat de plaats is waar het probleem begon. Anders start het vanaf het begin en duurt het onnodig langer.

Je geschiedenis zal niet langer een referentie bevatten naar dat bestand. Maar, je reflog en een nieuwe set refs die Git toevoegde toen je de `filter-branch` deed onder `.git/refs/original` bevatten het nog steeds, dus je moet die ook verwijderen en je gegevensbank opnieuw inpakken. Je moet alles dat een pointer naar die oude commits bevat kwijtraken voordat je opnieuw inpakt:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Laten we eens zien hoeveel ruimte je bespaard hebt.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

De grootte van je ingepakte repository is omlaag gegaan naar 7 K, wat veel beter is dan 2 Mb. Je kunt aan de waarde van size zien dat het grootte object nog steeds in je losse bestanden staat, dus het is niet weg; maar het zal niet meer overgedragen worden bij een push of opvolgende clone, wat het belangrijkste is. Als je het echt zou willen, kun je het object volledig verwijderen door `git prune --expire` uit te voeren.

## Samenvatting ##

Je moet een goed begrip hebben van wat Git op de achtergrond doet en, tot een bepaalde hoogte, hoe het in elkaar gezet is. Dit hoofdstuk heeft een aantal sanitaire voorzieningen commado's beslagen – commando's die op een lager nivo zitten en eenvoudige zijn dan de porcelein commando's waarover je in de rest van het boek geleerd hebt. Begrijpen hoe Git op een lager nivo werkt zou het makkelijker moeten maken om te begrijpen waarom het doet wat het doet en ook om je eigen applicaties te schrijven en hulp scripts om jouw specifieke werkwijze voor je te laten werken.

Git is als een inhouds-toegankelijk bestandssysteem een zeer krachtig tool dat je eenvoudig als meer dan alleen een VCS kunt gebruiken. Ik hoop dat je je nieuwe kennis van de werking van Git kunt gebruiken om je eigen coole applicatie te bouwen met deze technologie en je op je gemak voelt bij het gebruik van Git op meer geavanceerde manieren.
