<!-- Attentie heren en dames vertalers.
Ik zou het volgende willen voorstellen:
Er zijn bepaalde termen die voor de gemiddelde Nederlandse computer gebruiker 
veel beter klinken (of bekender voorkomen) als de orginele Engelse term. In het
begin zullen deze termen niet vaak voorkomen, maar in de meer diepgaandere 
hoofdstukken komen deze steeds meer voor. Termen als "Committen", "Mergen" 
en "Applyen" klinken beter dan "Plegen" of "Toepassen", "Samenvoegen" en 
"Toepassen" (wat bovendien slecht valt te onderscheiden van de 
commit-toepassing). De mensen die dit boek lezen zijn, naar mijn bescheiden 
inschatting, al redelijk op de hoogte van versiebeheer en passen (zie ik in 
de praktijk) deze termen al toe. Een nieuwe terminologie introduceren lijkt 
me dan ook niet noodzakelijk.
Verder blijven er altijd kreten over als "directory", wat vertaald zou kunnen 
worden als "map", maar bij het Engelse werkwoord to map krijgen we dan weer het
probleem: hoe dit weer te vertalen? Daarom zou ik willen voorstellen om deze 
basis-termen toch onvertaald te laten.

Twijfelgevallen zullen altijd blijven zoals de term "file", daarvan wordt in de
praktijk zowel de term file als bestand gebruikt. Ik denk dat we hier moeten 
kijken hoe het in de context past. 
Maar ook een term als "tool" en (ik zit zelf nog op een mooie Nederlandse term
te broeden) "plumbing", hierbij stel ik voor om eenmalig een Nederlandse 
vertaling te geven, tussen haakjes de Engelse term te geven en in het vervolg
de Engelse term te gebruiken. Wederom is de context hier belangrijk.

Verder stel ik ook voor om de regels op https://onzetaal.nl/taaladvies zoveel
mogelijk te volgen. Bijvoorbeeld de regels omtrent het spellen van Engelse 
werkwoorden die in het Nederlands gebruikt worden.

Let wel: ik wil niemand tot iets verplichten, maar ik denk dat we moeten 
streven naar een zo duidelijk mogelijke en best bij de praktijk aansluitende
vertaling moeten proberen te maken.

Veel succes en plezier bij het vertalen...
-->
<!-- SHA-1 of last checked en-version: 4cefec -->
# Het binnenwerk van Git #

Je zult misschien naar dit hoofdstuk gesprongen zijn vanuit een voorafgaand hoofdstuk, of je zult hier gekomen zijn nadat je de rest van het boek gelezen hebt; hoe dan ook, hier is waar het binnenwerk en implementatie van Git behandeld gaat worden. Ik heb gemerkt dat het leren van deze informatie van fundamenteel belang is om te begrijpen hoe bruikbaar en krachtig Git is, maar anderen hebben daar tegenin gebracht dat het erg verwarrend en onnodig complex kan zijn voor beginners. Daarom heb ik de behandeling hiervan het laatste hoofdstuk gemaakt in het boek, zodat je kunt besluiten om het het vroeg of later in je leerproces kunt lezen. Ik laat het aan jou over om dat te beslissen.

Maar, nu je hier bent, laten we beginnen. Ten eerste, mocht het nog niet duidelijk zijn geworden, Git is eigenlijk een inhouds-adresseerbaar bestandssysteem met een gebruikersinterface voor versiebeheer er bovenop geschreven. Je zult over een poosje meer leren wat dit inhoudt.

In de eerste dagen van Git (voornamelijk pre 1.5), was de gebruikersinterface veel complexer, omdat de nadruk lag op dit bestandssysteem aspect in plaats van een gepolijste VCS. De laatste paar jaren is de interface verfijnd totdat het zo netjes en eenvoudig te gebruiken is als een willekeurig ander systeem; maar vaak blijft het stereotype hangen van de vroegere Gitinterface die complex was en moeilijk te leren.

Deze laag met het inhouds-toegankelijke bestandssysteem is ongelofelijk gaaf, dus dat behandel ik dat als eerste dit hoofdstuk; daarna leer je over de transportmechanismen en het onderhoudentaken van repository's, iets waar je uiteindelijk mee te maken kunt krijgen.

## Sanitaire voorzieningen en porselein ##

In dit boek wordt Git met ongeveer 30 werkwoorden zoals `checkout`, `branch`, `remote` enzovoorts behandeld. Maar omdat Git in eerste instantie een toolkit voor een VCS was, in plaats van een volledig gebruiksvriendelijk VCS, heeft het een berg werkwoorden die laag-bij-de-gronds werk doen en ontworpen waren om gebruikt te worden zoals in UNIX gebruikelijk is, of vanuit scripts aangeroepen te worden. Naar deze commando's wordt over het algemeen als "plumbing" (sanitaire voorzieningen) commando's gerefereerd, en de meer gebruiksvriendelijke commando's worden "porcelain" (porselein) commando's genoemd.

In de eerste acht hoofdstukken van het boek worden bijna alleen de porcelain commando's behandeld. Maar in dit hoofdstuk zal je het meest met het laagste niveau van de plumbing commando's te maken gaan krijgen. Zij geven je toegang tot het binnenwerk van Git, en laten zien hoe en waarom Git doet wat het doet. Deze commando's zijn niet bedoeld voor normaal gebruik op de commandoregel, maar meer om als bouwstenen voor nieuwe tools en zelfgemaakte scripts gebruikt te worden.

Als je `git init` uitvoert in een nieuwe of bestaande directory, zal Git de directory `.git` aanmaken, wat de plaats is waar bijna alles wordt bewaard wat Git opslaat en manipuleert. Als je een backup of kopie van je repository wilt maken, dan hoef je alleen maar die directory te kopiëren, en je hebt bijna alles wat je nodig hebt. Dit hele hoofdstuk gaat in essentie over de inhoud van deze directory. Hier zie je hoe het eruit ziet:

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

Je zou hier een paar andere bestanden kunnen zien, maar dit is een verse `git init` repository - dit is wat je standaard ziet. De `branches` directory wordt niet gebruikt door nieuwere Git versies, en het `description` bestand wordt alleen gebruikt door het programma GitWeb, dus je hoeft je daar geen zorgen over te maken. Het bestand `config` bevat je project-specifieke configuratieopties, en de `info` directory bevat een bestand met bestandsnaampatronen die je niet wilt volgen, maar die je niet wilt opnemen in een `.gitignore` bestand. De directory `hooks` bevat scripts die aan bepaalde acties zijn “gehaakt” aan client- en serverkant, deze zijn in detail behandeld in Hoofdstuk 7.

Dit laat vier belangrijke vermeldingen over: de bestanden `HEAD` en `index`, en de directories `objects` en `refs`. Dit zijn de kernbestanddelen van Git. De directory `objects` bevat alle inhoud van je databank, de directory `refs` bevat verwijzingen naar commitobjecten (branches) in die databank, het bestand `HEAD` wijst naar de branch die je op dit moment uitgecheckt hebt, en het bestand `index` is waar Git de informatie van je staging area (wachtrij) opslaat. We gaan nu gedetaileerd naar elk van deze onderdelen kijken om te laten zien hoe Git werkt.

## Git objecten ##

Git is een inhouds-adresseerbaar bestandssysteem. Mooi. Wat betekent dat?
Het betekent dat in de kern Git een eenvoudige sleutel-waarde gegevensopslagsysteem is. Je kunt er elk vorm van inhoud in stoppen, en het zal je een sleutel teruggeven die je kunt gebruiken om de inhoud op ieder moment terug te krijgen. Om te demonstreren kan je het plumbing commando `hash-object` gebruiken die wat gegevens aanneemt, het in je `.git` directory opslaat, en je de sleutel teruggeeft waarmee de gegevens zijn opgeslagen. Als eerste initialiseer je een nieuw Git repository en verifieer je dat er niets in de `objects` directory staat:

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

Git heeft de `objects` directory geïnitialiseerd en de `pack` en `info` subdirectories erin aangemaakt, maar er zijn geen reguliere bestanden aanwezig. Nu sla je wat tekst in je Git databank op:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

De `-w` vertelt `hash-object` dat het object opgeslagen moet worden; anders zal het commando je alleen vertellen wat de sleutel zou zijn geweest. Met `--stdin` vertel je het commando dat het de inhoud moet lezen van stdin; als je dit niet specificeert verwacht `hash-object` een pad naar een bestand. De uitvoer van het commando is een hash checksum van 40 karakters. Dit is de SHA-1 hash: een checksum van de inhoud die je opslaat plus een kop, waarover je straks meer zult leren. Nu kun je zien hoe Git je gegevens opgeslagen heeft:

	$ find .git/objects -type f
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Je kunt een bestand in de `objects` directory zien. Dit is hoe Git de inhoud initieel opslaat - als een enkel bestand per stuk inhoud, vernoemd met de SHA-1 checksum van de inhoud en z'n kop. De subdirectory is vernoemd naar de eerste 2 karakters van de SHA, en de bestandsnaam is de overige 38 karakters.

Je kunt de inhoud terug uit Git halen met het `cat-file` commando. Dit commando is een soort Zwitsers zakmes om Git objecten mee te inspecteren. Door de `-p` optie mee te geven, instrueer je het `cat-file` commando om uit te zoeken wat het type van de inhoud is en om het netjes aan je te tonen:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Nu kun je inhoud aan Git toevoegen en het er weer uit halen. Je kunt dit ook doen met de inhoud van bestanden. Bijvoorbeeld, je kunt wat eenvoudig versie beheer op een bestand doen. Als eerste maak je een nieuw bestand en slaat de inhoud op in je databank:

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

Nu kun je het bestand terugdraaien naar de eerste versie

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt
	$ cat test.txt
	version 1

of de tweede versie:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt
	$ cat test.txt
	version 2

Maar de SHA-1 sleutel voor iedere versie van je bestand onthouden is niet erg praktisch; daarbij bewaar je de bestandsnaam niet in je systeem, alleen de inhoud. Dit objecttype heet een blob. Je kunt Git het objecttype van ieder object in Git laten vertellen, gegeven de SHA-1 sleutel, met `cat-file -t`:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Tree (boom) objecten ###

Het volgende type waar je naar gaat kijken is het tree object, wat het probleem van het opslaan van de bestandsnaam oplost en het ook mogelijk maakt om een groep bestanden bij elkaar op te slaan. Git bewaart inhoud op vergelijkbare wijze als een UNIX bestandssysteem, maar dan wat vereenvoudigd. Alle inhoud wordt opgeslagen als tree- en blob-objecten, waarbij trees corresponderen met UNIX directory vermeldingen en blobs min of meer corresponderen met inodes of bestandsinhoud. Een enkel treeobject bevat één of meer tree vermeldingen, waarvan ieder een SHA-1 pointer naar een blob of subtree bevat met zijn geassocieerde mode, type en bestandsnaam. Bijvoorbeeld, de meest recente tree in het simplegit project zou er zo uit kunnen zien:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

De `master^{tree}` syntax specificeert het tree object waarnaar gewezen wordt door de laatste commit op je `master` branch. Merk op dat de `lib` subdirectory geen blob is, maar een pointer naar een andere tree:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Conceptueel zijn de gegevens die Git opslaat zoiets als in Figuur 9-1.

Insert 18333fig0901.png
Figuur 9-1. Eenvoudige versie van het Git data model.

Je kunt je eigen tree maken. Normaal gesproken maakt Git een tree door de status van je staging area of index te pakken en daar een tree object mee te schrijven. Dus, om een treeobject te maken moet je eerst een index opzetten door een paar bestanden te stagen. Om een index te maken met een enkele vermelding - de eerste versie van je test.txt bestand - kun je het plumbing commando `update-index` gebruiken. Je gebruikt dit commando om kunstmatig de eerdere versie van het test.txt bestand toe te voegen aan een nieuwe staging area. Je moet het de `--add` optie meegeven omdat het bestand nog niet bestaat in je staging area (je hebt zelfs nog geen staging area ingesteld) en `--cacheinfo` omdat het bestand dat je toevoegt niet in je directory staat maar in je databank. Daarna specificeer je de modus, SHA-1 en bestandsnaam:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

In dit geval specificeer je een modus `100644`, wat aangeeft dat het een normaal bestand is. Andere opties zijn `100755`, wat aangeeft dat het een uitvoerbaar bestand is, en `120000` wat een symbolische link specificeert. De modus is afgekeken van normale UNIX modi, maar is veel minder flexibel; deze drie modi zijn de enige die geldig zijn voor bestanden (blobs) in Git (alhoewel andere modi worden gebruikt voor directories en submodules).

Nu kun je het `write-tree` commando gebruiken om het staging area naar een treeobject te schrijven. Er is geen `-w` optie nodig, `write-tree` aanroepen zorgt er automatisch voor dat een treeobject gecreëerd wordt van de status van de index als die tree nog niet bestaat:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Je kunt ook verifiëren dat dit een treeobject is:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Je gaat nu een nieuwe tree aanmaken met de tweede versie van het test.txt bestand en ook een nieuw bestand:

	$ echo 'new file' > new.txt
	$ git update-index test.txt
	$ git update-index --add new.txt

Je staging area heeft nu een nieuwe versie van test.txt, als ook het nieuwe new.txt bestand. Schrijf de tree (wat de status van het staging area of index opslaat als tree object) en kijk hoe het er uit ziet:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Merk op dat deze tree beide bestandsvermeldingen bevat en ook dat de SHA van test.txt de "versie 2" SHA is van eerder (`1f7a7a`). Je gaat nu voor de lol de eerste tree als een subtree toevoegen aan deze. Je kunt trees in je staging area lezen door `read-tree` aan te roepen. In dit geval kun je een bestaande tree in je staging area lezen als een subtree met de `--prefix` optie aan `read-tree`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Als je een werkdirectory zou hebben gemaakt van de nieuwe tree die je zojuist geschreven hebt, zou je de twee bestanden in het hoogste niveau van de werkdirectory krijgen en een subdirectory genaamd `bak` die de eerste versie van het test.txt bestand bevat. Je kunt de gegevens die Git bevat voor deze structuren zien zoals getoond in Figuur 9-2.

Insert 18333fig0902.png
Figuur 9-2. De inhoud structuur van je huidige Git gegevens.

### Commit objecten ###

Je hebt drie trees die de verschillende snapshots weergeven die je wilt tracken, maar het eerdere probleem blijft: je moet alledrie SHA-1 waarden onthouden om de snapshots weer op te halen. Je hebt ook geen informatie over wie de snapshots opgeslagen heeft, wanneer ze opgeslagen zijn of waarom ze opgeslagen zijn. Dit is de basis informatie die het commit object voor je bevat.

Om een commit object te creëren moet je `commit-tree` aanroepen en één tree SHA-1 specificeren en welke commit objecten, als er die zijn, er direct aan vooraf gingen. Begin met de eerste tree die je geschreven hebt:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Nu kun je je nieuwe commit object bekijken met `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Het formaat van een commit object is simpel: het specificeert de hoogste tree voor de snapshot van het project op dat punt: de auteur/committer informatie die uit de `user.name` en `user.email` configuratie instellingen gehaald is, met de huidige tijd, een lege regel en dan de commit boodschap.

Vervolgens ga je de twee andere commit objecten schrijven, waarbij ze elk naar het commit object dat er direct aan vooraf gaat verwijzen:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Elk van de drie commit objecten wijst naar één van de drie snapshots die je gemaakt hebt. Grappig genoeg heb je nu een echte Git historie die je kunt bekijken met het `git log` commando, als je dat op de SHA-1 van de laatste commit uitvoert:

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

Verbazingwekkend. Je hebt zojuist de lagere operaties uitgevoerd om een Git history op te bouwen, zonder één van de front ends te gebruiken. Dit is in essentie wat Git doet als je de `git add` en `git commit` commando's uitvoert: het slaat de blobs voor de gewijzigde bestanden op, ververst de index, schrijft de trees weg, en schrijft commit objecten die de bovenste trees en commits refereren die direct voor ze kwamen. Deze drie hoofd Git-objecten – de blob, de tree en de commit – worden in eerste instantie als aparte bestanden opgeslagen in je `.git/objects` directory. Hier zijn alle objecten die nu in de voorbeeld directory staan, voorzien van commentaar met wat ze bevatten:

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
Figuur 9-3. Alle objecten in je Git directory.

### Object opslag ###

Ik vertelde eerder dat er een kop wordt opgeslagen bij de inhoud. Laten we eens kijken naar hoe Git zijn objecten opslaat. Je zult zien hoe je een blob object opslaat, in dit geval de tekst "what is up, doc?", op een interactieve manier in de Ruby scripttaal. Je kunt Ruby in de interactieve modus starten met het `irb` commando:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git stelt een kop samen die begint met het type van het object, in dit geval een blob. Daarna voegt het een spatie toe, gevolgd door de grootte van de inhoud en als laatste een null byte:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git voegt de kop en de originele inhoud samen en berekent vervolgens de SHA-1 checksum van die nieuwe inhoud. Je kunt de SHA-1 waarde van een regel tekst in Ruby berekenen door de SHA1 verwerkingsbibliotheek op te nemen met het `require` commando en dan `Digest::SHA1.hexdigest()` aan te roepen met de tekst:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git comprimeert de nieuwe inhoud met zlib, wat je in Ruby kunt doen met de zlib bibliotheek. Als eerste moet je de bibliotheek opnemen, en dan `Zlib::Deflate.deflate()` op de inhoud uitvoeren:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Als laatste schrijf je de zlib-gecomprimeerde inhoud naar een object op de schijf. Je bepaalt het pad van het object dat je wilt wegschrijven (de eerste twee karakters van de SHA-1 waarde zijn de subdirectory naam, en de laatste 38 karakters zijn de bestandsnaam in die directory). In Ruby kun je de `FileUtils.mkdir_p()` functie gebruiken om de subdirectory aan te maken als hij nog niet bestaat. Daarna open je het bestand met `File.open()` en schrijft de eerder met zlib gecomprimeerde inhoud in het bestand met een aanroep van `write()` op het resulterende file handle (bestands-aangrijpingspunt).

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

Dat is alles - je hebt nu een geldig Git blob object aangemaakt. Alle Git objecten zijn op dezelfde manier opgeslagen, alleen de types verschillen - in plaats van de tekst blob, zal de kop beginnen met commit of tree. En alhoewel de inhoud van een blob vrijwel alles kan zijn, is de inhoud van een commit en tree zeer specifiek geformatteerd.

## Git referenties ##

Je kunt zoiets als `git log 1a410e` uitvoeren om door je hele geschiedenis te kijken, maar je moet nog steeds onthouden dat `1a410e` de laatste commit is om die geschiedenis te kunnen doorlopen en alle objecten te vinden. Je hebt een bestand nodig waarin je de SHA-1 waarde als een eenvoudige naam kunt opslaan, zodat je die als wijzer kunt gebruiken in plaats van de kale SHA-1 waarde.

In Git worden deze "referenties" of "refs" genoemd; je kunt de bestanden die de SHA-1 waarden bevatten vinden in de `.git/refs` directory. In het huidige project bevat deze directory geen bestanden, maar het bevat wel een eenvoudige structuur:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Om een nieuwe referentie aan te maken, die je zal helpen herinneren waar je laatste commit is, kun je technisch zoiets eenvoudigs als dit doen:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Nu kan je de head referentie die je zojuist hebt aangemaakt gebruiken in je Git commando's, in plaats van de SHA-1 waarde:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Het wordt niet aangeraden om de referentie bestanden direct aan te passen. Git levert een veiliger commando mee om dit te doen als je een referentie wilt aanpassen, genaamd `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Dat is eigenlijk wat een branch in Git is: een eenvoudige wijzer of referentie naar de head van een bepaald stuk werk. Om een branch te maken terug bij de tweede commit, kun je dit doen:

	$ git update-ref refs/heads/test cac0ca

Je branch zal alleen werk bevatten vanaf die commit en eerder:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Nu ziet je Git gegevensbank er conceptueel ongeveer uit zoals in Figuur 9-4.

Insert 18333fig0904.png
Figuur 9-4. Git directory objecten met branch head referenties erbij.

Als je commando's zoals `git branch (branchnaam)` uitvoert, voert Git eigenlijk dat `update-ref` commando uit om de SHA-1 van de laatste commit van de branch waarop je zit toe te voegen aan een door jou te benoemen nieuwe referentie.

### De HEAD ###

De vraag is nu: als je `git branch (branchnaam)` uitvoert, hoe weet Git de SHA-1 van de laatste commit? Het antwoord is het HEAD bestand. Het HEAD bestand is een symbolische referentie naar de branch waar je momenteel op zit. Met symbolische referentie bedoel ik dat deze, in tegenstelling tot een normale referentie, over het algemeen geen SHA-1 waarde bevat maar een verwijzing naar een andere referentie. Als je naar het bestand kijkt, zal je normaal gesproken zoiets als dit zien:

	$ cat .git/HEAD
	ref: refs/heads/master

Als je `git checkout test` uitvoert, zal Git het bestand wijzigen zodat het er zo uit ziet:

	$ cat .git/HEAD
	ref: refs/heads/test

Als je `git commit` uitvoert wordt het commit object gecreëerd, waarbij de ouder van die commit object gezet wordt op de SHA-1 waarde van de referentie waar de HEAD op dat moment naar verwijst.

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

We hebben zojuist de drie hoofdobject types van Git behandeld, maar er bestaat een vierde. Het tag object lijkt erg op een commit object - het bevat een tagger, een datum, een bericht en een pointer. Het grootste verschil is dat een tag object naar een commit wijst in plaats van een tree. Het is vergelijkbaar met een branch referentie, maar het zal nooit verplaatst worden - het zal altijd naar dezelfde commit wijzen, maar geeft het een vriendelijker naam.

Zoals besproken in hoofdstuk 2, zijn er twee soorten tags: beschreven en lichtgewicht. Je kunt een lichtgewicht tag maken door zoiets als dit uit te voeren:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Dat is wat een lichtgewicht tag is - een branch die nooit beweegt. Een beschreven tag is echter ingewikkelder. Als je een beschreven tag aanmaakt, creëert Git een tag object en schrijft dan een referentie die daar naar wijst in plaats van direct naar de commit. Je kunt dit zien door een beschreven tag aan te maken (`-a` specificeert dat het een beschreven tag is):

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

Merk op dat de object regel wijst naar de SHA-1 waarde die je getagged hebt. Merk ook op dat het niet naar een commit hoeft te wijzen; je kunt ieder Git object een tag geven. In de Git broncode bijvoorbeeld, heeft de maintainer zijn publieke GPG sleutel als een blob object toegevoegd en het een tag gegeven. Je kunt de publieke sleutel bekijken door dit uit te voeren

	$ git cat-file blob junio-gpg-pub

in de Git broncode. De Linux kernel heeft ook een non-commit-verwijzend tag object – het eerste tag object wijst naar de initiële tree van de import van de broncode.

### Remotes ###

Het derde soort referentie dat je zult zien is een remote referentie. Als je een remote toevoegt en er naar pusht, slaat Git de laatste waarde op die je gepusht hebt naar die remote voor iedere branch in de `refs/remotes` directory. Bijvoorbeeld, je kunt een remote genaamd `origin` toevoegen en je master branch hier naar pushen:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Daarna kun je zien wat de `master` branch op de `origin` remote was toen je voor 't laatst met de server communiceerde, door het `refs/remotes/origin/master` bestand te bekijken:

	$ cat .git/refs/remotes/origin/master
	ca82a6dff817ec66f44342007202690a93763949

Remote referenties verschillen van branches (`refs/heads` referenties) voornamelijk in het feit dat ze niet uitgechecked kunnen worden. Git verplaatst ze als boekenleggers naar de laatste status van die branches op de servers.

## Packfiles ##

Laten we eens terug gaan naar de object-databank van je test Git repository. Op dit punt heb je 11 objecten – 4 blobs, 3 trees, 3 commits en 1 tag:

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

Git comprimeert de inhoud van deze bestanden met zlib en je slaat maar weinig op, dus nemen deze bestanden samen maar 925 bytes in beslag. Je zult nu wat grotere inhoud toevoegen aan het repository om een interessante eigenschap van Git te demonstreren. Voeg het repo.rb bestand toe van de Grit bibliotheek waaraan je eerder gewerkt hebt, dit is een broncode bestand van ongeveer 12K groot:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Als je naar de resulterende tree kijkt, kun je zien welke SHA-1 waarde repo.rb gekregen heeft voor het blob object:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Dan controleer je hoe groot het object is op jouw schijf:

	$ du -b .git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	4102	.git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e

Pas dat bestand nu eens een beetje aan, en kijk wat er gebeurt:

	$ echo '# testing' >> repo.rb
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Bekijk de tree die door de commit gemaakt is, en je zult iets interessants zien:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

De blob is nu een andere blob, wat betekent dat, alhoewel je slechts een enkele regel aan het eind van een bestand van 400 regels toegevoegd hebt, Git die nieuwe inhoud als een compleet nieuw object opgeslagen heeft:

	$ du -b .git/objects/05/408d195263d853f09dca71d55116663690c27c
	4109	.git/objects/05/408d195263d853f09dca71d55116663690c27c

Je hebt nu twee vrijwel identieke 12K grote objecten op je harde schijf. Zou het niet prettig zijn als Git één van de twee volledig op kon slaan, en het tweede object slechts als delta tussen die en de eerste?

Dat kan dus. Het initiële formaat waarin Git objecten opslaat op de harde schijf wordt een loose (losse) object formaat genoemd. Maar, eens in de zoveel tijd pakt Git een aantal van die objecten samen in een enkel binair bestand wat een packfile genoemd wordt, om ruimte te besparen en efficiënter te zijn. Git doet dit als je teveel loose objecten rond hebt slingeren, als je het `git gc` commando handmatig uitvoert, of als je naar een remote server pusht. Om te zien wat er gebeurt, kun je Git handmatig vragen om de objecten in te pakken met het `git gc` commando:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

Als je in je objecten directory kijkt, zul je zien dat de meeste objecten verdwenen zijn, en er een aantal nieuwe bestanden verschenen zijn:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

De objecten die overgebleven zijn, zijn de blobs waarnaar geen enkel commit wijst - in dit geval zijn het de "what is up, doc?" en de "test content" voorbeeld-blobs die je eerder aangemaakt hebt. Omdat je ze nooit aan een commit toegevoegd hebt, worden ze beschouwd als dangling (rondslingerend) en worden niet in je nieuwe packfile ingepakt.

De andere bestanden zijn het nieuwe packbestand en een index. Het packbestand is een enkel bestand dat de inhoud bevat van alle objecten die van je bestandssysteem verwijderd zijn. De index is een bestand dat offsets binnen de packfile bevat, zodat je snel naar een specifiek object kunt zoeken. Wat stoer is, is dat waar de objecten op de harde schijf voordat je `gc` aanriep samen zo'n 8K groot waren, de nieuwe packfile slechts 4K groot is. Je hebt je schijfgebruik gehalveerd door je bestanden in te pakken.

Hoe doet Git dit? Als Git objecten inpakt, zoekt het naar bestanden die qua naam en grootte gelijk zijn, en slaat slechts de delta's van de ene versie van het bestand naar de volgende op. Je kunt in de packfile kijken en zien wat Git gedaan heeft om ruimte te besparen. Het `git verify-pack` plumbing commando stelt je in staat om te zien wat er ingepakt is:

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
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1 \
	  05408d195263d853f09dca71d55116663690c27c
	ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Hier refereert de `9bc1d` blob wat, als je dat nog kunt herinneren, de eerste versie is van je repo.rb bestand, aan de `05408` blob, wat de tweede versie is van het bestand. De derde kolom in de uitvoer is de grootte van het object in het pakket, zodat je kunt zien dat `05408` 12K van het bestand in beslag neemt maar dat `9bc1d` slechts 7 bytes in beslag neemt. Wat ook interessant is, is dat de tweede versie van het bestand degene is die intact opgeslagen wordt, terwijl de originele versie als delta opgeslagen wordt - dit is zo gedaan omdat het aannemelijk is dat je snellere toegang nodig hebt tot de meest recente versie van het bestand.

Het echt prettige van dit alles is, dat het op ieder gewenst moment opnieuw ingepakt kan worden. Git zal op gezette tijden je databank automatisch opnieuw inpakken, omdat het altijd meer ruimte wil besparen. Je kunt ook handmatig opnieuw inpakken op elk gewenst tijdstip, door `git gc` met de hand uit te voeren.

## De refspec ##

Door dit boek heen heb je eenvoudige verwijzingen van remote branches naar lokale referenties gebruikt, maar ze kunnen ingewikkelder zijn.
Stel dat je een remote als deze toevoegt:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

Dit voegt een sectie toe aan je `.git/config` bestand, met de naam van de remote (`origin`), de URL van de remote repository, en de refspec die nodig is om te fetchen:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Het formaat van de refspec is een optionele `+`, gevolgd door `<src>:<dst>`, waarbij `<src>` het patroon voor referenties aan de remote kant is, en `<dst>` de locatie is waar die referenties lokaal geschreven zullen worden. De `+` vertelt Git om de referentie zelfs te vernieuwen als het geen fast-forward is.

In het standaard geval dat automatisch geschreven wordt door een `git remote add` commando, haalt Git alle referenties onder `refs/heads/` van de server op en schrijft ze lokaal naar `refs/remotes/origin/`. Dus als er een `master` branch op de server bestaat, kan je de log van die branch lokaal benaderen via

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Ze zijn allemaal gelijk, omdat Git elk expandeert naar `refs/remotes/origin/master`.

Als je wilt dat Git alleen de `master` branch pulled, en niet alle andere branches op de remote server, kun je de fetch regel veranderen in

	fetch = +refs/heads/master:refs/remotes/origin/master

Dit is alleen de standaard refspec voor `git fetch` voor die remote. Als je iets eenmalig wilt doen, kan je de refspec ook op de commandoregel specificeren. Om de `master` branch op de remote naar de lokale `origin/mymaster` te pullen, kun je dit uitvoeren

	$ git fetch origin master:refs/remotes/origin/mymaster

Je kunt ook meerdere refspecs specificeren. Met de commandoregel kan je meerdere branches op deze manier pullen:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In dit geval werd de pull van de master branch geweigerd, omdat het geen fast-forward referentie is. Je kunt dat teniet doen door de `+` voor de refspec te zetten.

Je kun ook meerdere refspecs voor het fetchen specificeren in je configuratie bestand. Als je altijd de master en experiment branches wilt fetchen, voeg je twee regels toe:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Je kunt geen gedeeltelijke globs in het patroon gebruiken, dus het volgende zou ongeldig zijn:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Maar je kunt wel namespaces (naamruimtes) gebruiken om zoiets voor elkaar te krijgen. Als je een QA team hebt dat naar een bepaalde reeks branches pusht, en je wilt de master branch en alle QA team branches hebben, maar niets anders, kun je een configuratie sectie zoals dit gebruiken:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

Als je een ingewikkelde workflow hebt waarbij het QA team branches pusht, ontwikkelaars branches pushen, en integratie teams op remote branches pushen en samenwerken, kun je ze op deze manier eenvoudig in namespaces onderverdelen.

### Refspecs pushen ###

Het is prettig dat je op die manier referenties met namespaces kunt fetchen, maar hoe krijgt het QA team om te beginnen al hun branches in een `qa/` namespace? Je krijgt dat voor elkaar door refspecs te gebruiken voor het pushen.

Als het QA team hun `master` branch naar `qa/master` op de remote server wil pushen, kunnen ze dit uitvoeren

	$ git push origin master:refs/heads/qa/master

Als ze willen dat Git dat automatisch doet iedere keer als ze `git push origin` uitvoeren, dan kunnen ze een `push` waarde aan hun configuratie bestand toevoegen:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Nogmaals, dit zal zorgen dat `git push origin` de lokale `master` branch standaard naar de remote `qa/master` branch zal pushen.

### Referenties verwijderen ###

Je kunt de refspec ook gebruiken om referenties te verwijderen van de remote server door zoiets als dit uit te voeren:

	$ git push origin :topic

Omdat de refspec `<src>:<dst>` is, wordt door het weglaten van het `<src>` gedeelte in feite verteld dat de onderwerp branch op de remote niets is, waardoor het verwijderd wordt.

## Overdracht protocollen ##

Git kan gegevens tussen twee repositories hoofdzakelijk op twee manieren overdragen: via HTTP en via de zogenaamde slimme protocollen die in de `file://`, `ssh://` en `git://` overdrachten gebruikt worden. Deze paragraaf zal laten zien hoe deze twee hoofdprotocollen werken.

### Het domme Protocol ###

Naar Git-overdracht via HTTP wordt vaak gerefereerd als het domme protocol, omdat het geen Git-specifieke code vereist op de server tijdens het overdrachtsproces. Het fetch proces is een reeks van GET verzoeken, waarbij de client de indeling van het Git repository van de server kent. Laten we het `http-fetch` proces eens volgen voor de simplegit bibliotheek:

	$ git clone http://github.com/schacon/simplegit-progit.git

Het eerste wat dit commando doet is het `info/refs` bestand pullen. Dit bestand wordt geschreven door het `update-server-info` commando, en dat is de reden waarom je dat als een `post-recieve` hook moet activeren voordat de HTTP overdracht naar behoren werkt:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Nu heb je een lijst met de remote referenties en SHA's. Daarna kijk je naar de waarde van de HEAD referentie, zodat je weet wat je uit moet checken zodra je klaar bent:

	=> GET HEAD
	ref: refs/heads/master

Je moet de `master` branch uitchecken zodra je het proces afgerond hebt.
Op dit punt kan je beginnen met het doorloop proces. Omdat je startpunt het `ca82a6` commit object is dat je in het `info/refs` bestand zag, begin je met dit op te halen:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

Je krijgt een object terug - dat object staat in los formaat op de server, en je hebt het gehaald met een statisch HTTP GET verzoek. Je kunt het met zlib decomprimeren, de kop eraf halen en naar de commit inhoud kijken:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Daarna heb je nog twee objecten op te halen - `cfda3b`, wat de tree is met inhoud waar de commit die je zojuist hebt opgehaald naar wijst, en `085bb3`, wat de ouder commit is:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

Dat geeft je het volgende commit object. Pak het tree object:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oeps, het ziet ernaar uit dat die tree object niet in het loose formaat op de server bestaat, dus krijg je een 404 antwoord. Er zijn hiervoor een aantal redenen: het object zou in een ander repository kunnen staan, of het kan in een packfile in deze repository staan. Git gaat eerst naar de benoemde alternatieven kijken:

	=> GET objects/info/http-alternates
	(empty file)

Als dit een lijst met alternatieve URL's bevat, zal Git daar voor loose bestanden en packfiles gaan kijken. Dit is een prettig mechanisme voor projecten die forks zijn van een ander zodat ze objecten kunnen delen op de schijf. Maar omdat er in dit geval geen alternatieven vermeld staan, moet het object in een packfile zitten. Om te zien welke packfiles beschikbaar zijn op deze server moet je het `objects/info/packs` bestand ophalen, wat een lijst hiervan bevat (ook gegenereerd door `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Er is slechts één packfile op de server dus dat object zit daar natuurlijk in, maar je controleert het index bestand om er zeker van te zijn. Dit is ook handig als je meerdere packfiles op de server hebt, zodat je kunt zien welke packfile het object dat je nodig hebt bevat:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Nu je de packfile index hebt kun je zien of het object hier in zit - omdat de index de SHA's van de objecten in de packfile toont en de offsets naar die objecten. Het gezochte object is aanwezig, dus ga je verder en haalt de hele packfile op:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Je hebt de tree object te pakken, dus je kunt verder gaan met het doorlopen van de commits. Ze zitten ook allemaal in de packfile die je zojuist gedownload hebt, dus je hoeft geen verzoeken meer te doen aan je server. Git checked een werkkopie uit van de `master` branch waarnaar gewezen werd door de HEAD referentie, die je aan het begin gedownload hebt.

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

### Het slimme protocol ###

De HTTP methode is eenvoudig, maar een beetje inefficiënt. Slimme protocollen gebruiken is een meer gebruikelijke manier van gegevensoverdracht. Deze protocollen hebben een proces aan de remote kant dat bewust is van Git - het kan lokale gegevens lezen en uitvinden wat de client heeft of nodig heeft en hier specifieke gegevens voor genereren. Er zijn twee paar processen voor gegevensoverdracht: één paar voor het uploaden van gegevens en één paar voor het downloaden van gegevens.

#### Gegevens uploaden ####

Om gegevens te uploaden naar een remote proces, gebruikt Git de `send-pack` en `receive-pack` processen. Het `send-pack` proces draait op de client en maakt contact met een `receive-pack` proces aan de remote kant.

Bijvoorbeeld, stel dat je `git push origin master` uitvoert in je project en `origin` is gedefinieerd als een URL dat het SSH protocol gebruikt. Git start het `send-pack` proces, wat een SSH verbinding initieert naar de server. Het probeert een commando op de remote server uit te voeren met behulp van een SSH aanroep die er ongeveer zo uit ziet:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Het `git-receive-pack` commando antwoordt direct met één regel voor iedere referentie die het momenteel heeft - in dit geval alleen de `master` branch en zijn SHA. De eerste regel bevat ook een lijst van de mogelijkheden van de server (hier: `report-status` en `delete-refs`).

Iedere regel begint met een hexadecimale waarde van 4 bytes, die specificeert hoe lang de rest van de regel is. Je eerste regel begint met 005b, wat 91 in hex is, wat betekent dat er nog 91 bytes over zijn op deze regel. De volgende regel begint met 003e, wat 62 is, waarna je de overgebleven 62 bytes leest. De volgende regel is 0000, wat betekent dat de server klaar is met het tonen van zijn referenties.

Nu de status van de server bekend is, bepaalt het `send-pack` proces welke commits het heeft die de server nog niet heeft. Voor iedere referentie die deze push zal vernieuwen, geeft het `send-pack` die informatie aan het `receive-pack` door. Bijvoorbeeld, als je de `master` branch vernieuwt en een `experiment` branch toevoegt, zou het `send-pack` antwoord er zo uit kunnen zien:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

De SHA-1 waarde met alleen '0' betekent dat er nog niets was - omdat je de experiment referentie toevoegt. Als je een referentie aan het verwijderen was, zou je het tegenovergestelde zien: allemaal '0'en aan de rechterkant.

Git stuurt een regel voor iedere referentie die je vernieuwt met de oude SHA, de nieuwe SHA en de referentie die vernieuwd wordt. De eerste regel bevat ook de mogelijkheden van de client. Vervolgens uploadt de client een packfile met alle objecten die de server nog niet heeft. Als laatste antwoordt de server met een indicatie van succes (of mislukking):

	000Aunpack ok

#### Gegevens downloaden ####

Zodra je gegevens downloadt zijn de `fetch-pack` en `upload-pack` processen erbij betrokken. De client start een `fetch-pack` proces dat verbinding maakt met een `upload-pack` proces aan de remote kant om te onderhandelen welke gegevens opgehaald moeten worden.

Er zijn verschillende manieren om het `upload-pack` proces op de remote repository te starten. Je kunt het uitvoeren via SSH, zoals bij het `receive-pack` proces. Je kunt het proces ook starten via de Git daemon, die standaard op poort 9418 luistert. Het `fetch-pack` proces stuurt gegevens, naar de daemon na het maken van de verbinding die er zo uitzien:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Het begint met de 4 bytes die specificeren hoeveel gegevens er volgen, daarna het commando gevolgd door een null byte, en dan de hostname van de server gevolgd door een laatste null byte. De Git daemon controleert of dat commando uitgevoerd kan worden, dat de repository bestaat en dat het publieke permissies heeft. Als alles in orde is, dan start het het `upload-pack` proces en geeft het verzoek hier aan door.

Als je de fetch via SSH doet, voert het `fetch-pack` in plaats daarvan zoiets als dit uit:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In beide gevallen wordt, nadat `fetch-pack` verbinding gemaakt heeft, door `upload-pack` zoiets als het volgende gestuurd:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Dit komt sterk overeen met hoe `receive-pack` antwoordt, maar de mogelijkheden zijn verschillend. Daarnaast stuurt het de HEAD referentie zodat de client weet wat er uitgechecked moet worden als dit een clone is.

Op dit punt kijkt het `fetch-pack` proces naar welke objecten het heeft en antwoordt met de objecten die het nodig heeft door "want" te sturen, gevolgd door de SHA die het wil hebben. Het stuurt al de objecten die het al heeft met "have" en dan de SHA. Aan het einde van deze lijst schrijft het "done" om het `upload-pack` proces te laten beginnen met het sturen van de packfile met de gegevens die het nodig heeft:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

Dat is een erg basaal geval van de overdrachtsprotocollen. In meer complexe gevallen ondersteunt de client `multi_ack` of `side-band` mogelijkheden; maar dit voorbeeld toont je het basale over en weer dat plaatsvindt bij de slimme protocol processen.

## Onderhoud en het herstellen van gegevens ##

Soms moet je wat opruimen - een repository compacter maken, een geïmporteerde repository opruimen of verloren werk terughalen. In deze paragraaf zal een aantal van deze scenario's behandeld worden.

### Onderhoud ###

Geregeld voert Git automatisch een commando genaamd "auto gc" uit. Het merendeel van de tijd doet dit commando niets. Maar, als je teveel loose objecten (objecten die niet in een packfile zitten) of teveel packfiles hebt, lanceert Git een uitgebreid `git gc` commando. Het `gc` staat voor garbage collect (afval ophalen), en het commando doet een aantal zaken: het haalt alle loose objecten op en stopt ze in packfiles, het consolideert packfiles tot één grote packfile, en het verwijdert objecten die niet bereikbaar zijn vanuit een commit en een paar maanden oud zijn.

Je kunt auto gc als volgt handmatig uitvoeren:

	$ git gc --auto

Nogmaals, over het algemeen doet dit commando niets. Je moet ongeveer 7.000 losse objecten of meer dan 50 packfiles hebben voordat Git een echt gc commando start. Je kunt deze grenzen aanpassen met respectievelijk de `gc.auto` en `gc.autopacklimit` configuratie instellingen.

Het andere dat `gc` zal doen is je referenties in een enkel bestand inpakken. Stel dat je repository de volgende branches en tags bevat:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

Als je `git gc` uitvoert, zal je deze bestanden niet langer in de `refs` directory hebben. Git zal ze omwille van efficiëntie in een bestand genaamd `.git/packed-refs` stoppen, dat er zo uitziet:

	$ cat .git/packed-refs
	# pack-refs with: peeled
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

Als je een referentie vernieuwt, zal Git dit bestand niet aanpassen maar een nieuw bestand in `refs/heads` schrijven. Om de juiste SHA voor een gegeven referentie te krijgen, kijkt Git voor die referentie in de `refs` directory en kijkt in het `packed-res` bestand als terugval optie. Hoe dan ook, als je een referentie niet in de `refs` directory kunt vinden zit het waarschijnlijk in je `packed-refs` bestand.

Let op de laatste regel van het bestand, die begint met een `^`. Dit betekent dat de tag die er direct boven staat een beschreven tag is, en dat die regel de commit is waar de beschreven tag naar wijst.

### Gegevens herstellen ###

Op een gegeven moment tijdens je reis met Git, is het mogelijk dat je per ongeluk een commit kwijtraakt. Meestal gebeurt dit omdat je een branch waar werk op zat geforceerd verwijdert, en je komt erachter dat je de branch achteraf toch had willen houden. Of je hard-reset een branch, waarmee je commits verliest waar je iets uit wilde hebben. Stel dat dit gebeurt, hoe kun je dan je commits terug halen?

Hier is een voorbeeld dat de master branch hard-reset naar een oudere commit in je test repository, en daarna verloren commits terug haalt. Laten we eerst eens bekijken waar je repository op dit punt staat:

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

Je bent nu effectief de twee bovenste commits kwijt - je hebt geen branch van waaruit deze commits bereikbaar zijn. Je moet de SHA van de laatste commit vinden en dan een branch toevoegen die daar naar wijst. De truuk is om de SHA van de laatste commit te vinden, het is niet waarschijnlijk dat je die uit je hoofd geleerd hebt, toch?

Vaak is de snelste manier een tool genaamd `git reflog` te gebruiken. Terwijl je werkt slaat Git stilletjes op wat je HEAD is, iedere keer als je die wijzigt. Elke keer als je commit, of van branch verandert wordt de reflog vernieuwd. Het reflog wordt ook vernieuwd door het `git update-ref` commando, wat nog een reden is om het te gebruiken in plaats van gewoon de SHA's naar je ref bestanden te schrijven, zoals we beschreven hebben in de "Git Referenties" paragraaf eerder in dit hoofdstuk. Je kunt op ieder moment zien waar je geweest bent, door `git reflog` uit te voeren.

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Hier kunnen we de twee commits zien die we uitgechecked hadden, maar er is hier niet veel informatie aanwezig. Om dezelfde informatie op een veel bruikbaarder manier te zien kunnen we `git log -g` uitvoeren, wat je een normale log uitvoer geeft voor je reflog.

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

Vet – nu heb je een branch genaamd `recover-branch` die staat op het punt waar je `master` branch vroeger op stond, waarmee de eerste twee commits weer bereikbaar zijn.
Vervolgens, stel dat je verloren commit om een of andere reden niet in de reflog stond; je kunt dat simuleren door `recover-branch` te verwijderen en het reflog te wissen. Nu zijn de eerste twee commits nergens meer mee te bereiken:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

Omdat de reflog gegevens bewaard worden in de `.git/logs/` directory, heb je nu effectief geen reflog meer. Hoe kun je die commit nu herstellen? Één manier is om gebruik te maken van de `git fsck` tool, wat de integriteit van je gegevensbank controleert. Als je het met de `--full` optie uitvoert, dan toont het je alle objecten waarnaar niet gewezen wordt door een ander object:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In dit geval, kun je de vermiste commit zien na de dangling commit (rondslingerende commit). Je kunt het op dezelfde manier herstellen, door een branch te maken die naar die SHA wijst.

### Objecten verwijderen ###

Er zijn een hoop geweldige dingen aan Git, maar één eigenschap die problemen kan geven is het feit dat `git clone` de hele historie van het project download, inclusief alle versies van alle bestanden. Dat is geen probleem als het hele project broncode is, omdat Git zeer geoptimaliseerd is om die gegevens optimaal te comprimeren. Maar, als iemand op een bepaald punt in de geschiedenis een enorm bestand heeft toegevoegd, zal iedere clone voor altijd gedwongen worden om dat grote bestand te downloaden, zelfs als het uit het project wordt verwijderd in de eerstvolgende commit. Omdat het bereikbaar is vanuit de geschiedenis, zal het er altijd zijn.

Dit kan een groot probleem zijn als je Subversion of Perforce repositories converteert naar Git. Omdat je niet de hele geschiedenis downloadt in die systemen, zal dit soort toevoeging weinig consequenties met zich meebrengen. Als je een import vanuit een ander systeem deed, of om een andere reden vindt dat je repository veel groter is dan het zou moeten zijn, kun je hier zien hoe je grote objecten kunt vinden en verwijderen.

Let op: deze techniek is destructief voor je commit geschiedenis. Het herschrijft ieder commit object stroomafwaarts vanaf de eerste tree die je moet aanpassen om een referentie naar een groot bestand te verwijderen. Als je dit meteen na een import doet, voordat iemand werk is gaan baseren op de commit, dan is er niets aan de hand - anders moet je alle bijdragers waarschuwen dat ze hun werk op je nieuwe commits moeten rebasen.

Om het te demonstreren, voeg je een groot bestand in je test repository toe, verwijdert het in de volgende commit, vindt het, en verwijdert het daarna permanent uit de repository. Als eerste, voeg je een groot object toe aan je geschiedenis:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oeps — je wilde geen enorme tarball toevoegen aan je project. Laten we het maar snel verwijderen:

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

Op de `size-pack` regel staat de grootte van je packfiles in kilobytes, dus je gebruikt 2Mb. Voor de laatste commit gebruikte je bijna 2K - het is duidelijk dat het verwijderen van het bestand uit de vorige commit, het niet uit je geschiedenis verwijderd heeft. Iedere keer als iemand dit repository cloned, zullen ze de volle 2Mb moeten clonen alleen maar om dit kleine project te krijgen, omdat jij per ongeluk een groot bestand toegevoegd hebt. Laten we het echt verwijderen.

Eerst moet je het vinden. In dit geval weet je al welk bestand het is. Maar stel dat je het niet zou weten; hoe zou je kunnen ontdekken welk bestand of bestanden zoveel ruimte in beslag nemen? Als je `git gc` uitvoert zitten alle objecten in een packfile; je kunt de grote bestanden identificeren door een ander plumbing commando genaamd `git verify-pack` uit te voeren en te sorteren op het derde veld in de uitvoer, wat de bestandsgrootte is. Je kunt het ook door het `tail` commando leiden omdat je alleen geïnteresseerd bent in het laatste paar grote bestanden.

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

Het grote object staat aan het einde: 2 Mb. Om uit te vinden welk bestand het is, kan je het `rev-list` commando gebruiken, wat je eventjes gebruikt hebt in Hoofdstuk 7. Als je `--objects` meegeeft aan `ref-list`, toont het alle commit SHA's en ook de blob SHA's met de bestandspaden die er mee geassocieerd zijn. Je kunt dit gebruiken om de naam van je blob te vinden:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Nu moet je dit bestand verwijderen uit alle trees in het verleden. Je kunt eenvoudig zien welke commits dit bestand aangepast hebben:

	$ git log --pretty=oneline --branches -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Je moet alle commits die stroomafwaarts van `6df76` liggen herschrijven om dit bestand volledig uit je Git geschiedenis te verwijderen. Omdat te doen gebuik je `filter-branch`, wat je in Hoofdstuk 6 gebruikt hebt:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

De `--index-filter` optie is vergelijkbaar met de `--tree-filter` optie, die gebruikt is in Hoofdstuk 6, met het verschil dat in plaats van het doorgeven van een commando dat bestanden aanpast die uitgecheckt staan op je schijf, je de staging area of index iedere keer aanpast. In plaats van een specifiek bestand steeds te verwijderen met zoiets als `rm file`, moet je het met `git rm --cached` verwijderen - je moet het uit de index verwijderen, niet van de schijf. Reden om het zo te doen is snelheid - omdat Git niet iedere versie hoeft uit te checken op je schijf voordat het je filter uitvoert, kan het proces vele, vele malen sneller gaan. Je kunt dezelfde taak uitvoeren met `--tree-filter` als je dat wilt. De `--ignore-unmatch` optie op `git rm` vertelt het niet te stoppen op een fout als het patroon dat je probeert te verwijderen niet aanwezig is. Als laatste zal je `filter-branch` vragen om je geschiedenis alleen vanaf de `6df7640` commit te herschrijven, omdat je weet dat dat de plaats is waar het probleem begon. Anders start het vanaf het begin en duurt het onnodig langer.

Je geschiedenis zal niet langer een referentie bevatten naar dat bestand. Maar, je reflog en een nieuwe verzameling refs die Git toevoegde toen je de `filter-branch` deed onder `.git/refs/original` bevatten het nog steeds, dus je moet die ook verwijderen en dan je gegevensbank opnieuw inpakken. Je moet alles wat een pointer naar die oude commits bevat kwijtraken voordat je opnieuw inpakt:

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

De grootte van je ingepakte repository is omlaag gegaan naar 7 K, wat veel beter is dan 2 Mb. Je kunt aan de waarde van size zien dat het grote object nog steeds in je loose objecten staat, dus het is niet weg; maar het zal niet meer overgedragen worden bij een push of opvolgende clone, wat het belangrijkste is. Als je het echt zou willen, kun je het object volledig verwijderen door `git prune --expire` uit te voeren.

## Samenvatting ##

Je moet een redelijk goed begrip hebben van wat Git op de achtergrond doet en, tot een bepaalde hoogte, hoe het geimplementeerd is. Dit hoofdstuk heeft een aantal plumbing commando's besproken – commando's die op een lager niveau zitten en eenvoudige zijn dan de porcelain commando's waarover je in de rest van het boek gelezen hebt. Begrijpen hoe Git op een lager niveau werkt zou het makkelijker moeten maken om te begrijpen waarom het doet wat het doet en ook om je eigen applicaties te schrijven en hulp scripts om jouw specifieke workflow voor je te laten werken.

Git is als een inhouds-toegankelijk bestandssysteem een zeer krachtige tool dat je eenvoudig als meer dan alleen een VCS kunt gebruiken. Ik hoop dat je deze nieuwe kennis van de werking van Git kunt gebruiken om je eigen coole applicatie te bouwen met deze technologie en dat je je prettig voelt bij het gebruik van Git op meer geavanceerde manieren.
