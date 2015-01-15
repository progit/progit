<!-- Attentie heren en dames vertalers.
Ik zou het volgende willen voorstellen:
Er zijn bepaalde termen die voor de gemiddelde Nederlandse computer gebruiker 
veel beter klinken (of bekender voorkomen) dan de orginele Engelse term. In het
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
<!-- SHA-1 of last checked en-version: 4cefec  -->
# De basis van Git #

Als je slechts één hoofdstuk kunt lezen om met Git aan de slag te gaan, dan is dit het. In dit hoofdstuk worden alle basiscommando's behandeld, die je nodig hebben om het leeuwendeel van de dingen te doen waarmee je uiteindelijk je tijd met Git zult doorbrengen. Als je dit hoofdstuk doorgenomen hebt, zul je een repository kunnen configureren en initialiseren, bestanden beginnen en stoppen te volgen en veranderingen te ‘stagen’ en ‘committen’. We laten ook zien hoe je Git kunt instellen zodat het bepaalde bestanden en bestandspatronen negeert, hoe je vergissingen snel en gemakkelijk ongedaan kunt maken, hoe je de geschiedenis van je project kan doorlopen en wijzigingen tussen commits kunt zien, en hoe je kunt pushen naar en pullen van repositories.

## Een Git repository verkrijgen ##

Je kunt op twee manieren een Git project verkrijgen. De eerste maakt gebruik van een bestaand project of directory en importeert dit in Git. De tweede maakt een kloon (clone) van een bestaande Git repository op een andere server.

### Een repository initialiseren in een bestaande directory ###

Als je een bestaand project in Git wilt volgen (tracken), dan moet je naar de projectdirectory gaan en het volgende typen

	$ git init

Dit maakt een nieuwe subdirectory met de naam `.git` aan, die alle noodzakelijke repository bestanden bevat, een Git repository raamwerk. Op dit moment wordt nog niets in je project gevolgd. (Zie *Hoofdstuk 9* voor meer informatie over welke bestanden er precies in de `.git` directory staan, die je zojuist gemaakt hebt.)

Als je de versies van bestaande bestanden wilt gaan beheren (in plaats van een lege directory), dan zul je die bestanden moeten beginnen te tracken en een eerste commit doen. Dit kun je bereiken door een paar `git add` commando's waarin je de te volgen bestanden specificeert, gevolgd door een commit:

	$ git add *.c
	$ git add README
	$ git commit –m 'initial project version'

We zullen zodadelijk beschrijven wat deze commando's doen. Op dit punt heb je een Git repository met gevolgde (tracked) bestanden en een initiële commit.

### Een bestaand repository clonen ###

Als je een kopie wilt van een bestaande Git repository, bijvoorbeeld een project waaraan je wilt bijdragen, dan is `git clone` het commando dat je nodig hebt. Als je bekend bent met andere versie-beheersystemen zoals Subversion, dan zal het je opvallen dat het commando `clone` is en niet `checkout`. Dit is een belangrijk verschil: Git ontvangt een kopie van bijna alle gegevens die de server heeft. Elke versie van ieder bestand in de hele geschiedenis van een project wordt binnengehaald als je `git clone` doet. In feite kun je als de schijf van de server kapot gaat, een clone van een willekeurige client gebruiken om de server terug in de status te brengen op het moment van clonen (al zou je wel wat hooks aan de kant van de server en dergelijke verliezen, maar alle versies van alle bestanden zullen er zijn; zie *Hoofdstuk 4* voor meer informatie).

Je clonet een repository met `git clone [url]`. Bijvoorbeeld, als je de Ruby Git bibliotheek genaamd Grit wilt clonen, kun je dit als volgt doen:

	$ git clone git://github.com/schacon/grit.git

Dat maakt een directory genaamd `grit` aan, initialiseert hierin een `.git` directory, haalt alle data voor die repository binnen en doet een checkout van een werkkopie van de laatste versie. Als je in de nieuwe `grit` directory gaat kijken zal je de projectbestanden vinden, klaar om gebruikt of aan gewerkt te worden. Als je de repository in een directory met een andere naam dan grit wilt clonen, dan kun je dit met het volgende commando specificeren:

	$ git clone git://github.com/schacon/grit.git mygrit

Dat commando doet hetzelfde als het vorige, maar dan heet de doeldirectory `mygrit`.

Git heeft een aantal verschillende transportprotocollen die je kunt gebruiken. Het vorige voorbeeld maakt gebruik van het `git://` protocol, maar je kunt ook `http(s)://` of `gebruiker@server:/pad.git` tegenkomen, dat het SSH transport protocol gebruikt. *Hoofdstuk 4* zal alle beschikbare opties introduceren die de server kan inrichten om je toegang tot de Git-repositories te geven, met daarbij de voors en tegens van elk.

## Wijzigingen aan het repository vastleggen ##

Je hebt een eersteklas Git-repository en een checkout of werkkopie van de bestanden binnen dat project. Als je wijzigingen maakt dan moet je deze committen in je repository op elk moment dat het project een status bereikt die je wilt vastleggen.

Onthoud dat elk bestand in je werkdirectory in een van twee statussen kan verkeren: *gevolgd (tracked)* of *niet gevolgd (untracked)*. *Tracked* bestanden zijn bestanden die in het laatste snapshot zaten; ze kunnen *ongewijzigd (unmodified)*, *gewijzigd (modified)* of *staged* zijn. *untracked* bestanden zijn al het andere; elk bestand in je werkdirectory dat niet in je laatste snapshot en niet in je staging area zit. Als je een repository voor het eerst clonet, zullen alle bestanden tracked en unmodified zijn, omdat je ze zojuist uitgechecked hebt en nog niets gewijzigd hebt.

Zodra je bestanden wijzigt, ziet Git ze als modified omdat je ze veranderd hebt sinds je laatste commit. Je *staget* deze gewijzigde bestanden en commit al je gestagede wijzigingen, en de cyclus begint weer van voor af aan. Deze cyclus wordt in Figuur 2-1 geïllustreerd.

Insert 18333fig0201.png
Figuur 2-1. De levenscyclus van de status van je bestanden.

### De status van je bestanden controleren ###

Het commando dat je voornamelijk zult gebruiken om te bepalen welk bestand zich in welke status bevindt is `git status`. Als je dit commando direct na het clonen uitvoert, dan zal je zoiets als het volgende zien:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Dit betekent dat je een schone werkdirectory hebt, met andere woorden er zijn geen tracked bestanden die gewijzigd zijn. Git ziet ook geen untracked bestanden, anders zouden ze hier getoond worden. Als laatste vertelt het commando op welke tak (branch) je nu zit. Voor nu is dit altijd `master`, dat is de standaard; besteed daar voor nu nog geen aandacht aan. In het volgende hoofdstuk wordt gedetaileerd ingegaan op branches en referenties.

Stel dat je een nieuw bestand toevoegt aan je project, een simpel README bestand. Als het bestand voorheen nog niet bestond, en je doet `git status`, dan zul je het niet getrackte bestand op deze manier zien:

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)
	
	        README

	nothing added to commit but untracked files present (use "git add" to track)

Je kunt zien dat het nieuwe README bestand untrackt is, omdat het onder de “Untracked files” kop staat in je status output. Untrackt betekent eigenlijk dat Git een bestand ziet dat je niet in het vorige snapshot (commit) had; Git zal het niet in je commit snapshots toevoegen totdat jij dit expliciet aangeeft. Dit wordt zo gedaan zodat je niet per ongeluk gegenereerde binaire bestanden toevoegt, of andere bestanden die je niet wilt toevoegen. Je wilt dit README bestand wel meenemen, dus laten we het gaan tracken.

### Nieuwe bestanden volgen (tracking) ###

Om een nieuw bestand te beginnen te tracken, gebruik je het commando `git add`. Om de README te tracken, voer je dit uit:

	$ git add README

Als je het `status` commando nogmaals uitvoert, zie je dat je README bestand nu getrackt en ge-staged is:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	

Je kunt zien dat het gestaged is, omdat het onder de kop “Changes to be committed” staat. Als je nu een commit doet, zal de versie van het bestand zoals het was ten tijde van je `git add` commando in de historische snapshot toegevoegd worden. Je zult je misschien herinneren dat, toen je `git init` eerder uitvoerde, je daarna `git add (bestanden)` uitvoerde; dat was om bestanden in je directory te beginnen te tracken. Het `git add` commando beschouwt een padnaam als een bestand of een directory. Als de padnaam een directory is, dan voegt het commando alle bestanden in die directory recursief toe.

### Gewijzigde bestanden stagen ###

Laten we een getrackt bestand wijzigen. Als je een reeds getrackt bestand genaamd `benchmarks.rb` wijzigt, en dan je `status` commando nog eens uitvoert, krijg je iets dat er zo uitziet:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Het `benchmarks.rb` bestand verschijnt onder een sectie genaamd “Changes not staged for commit”, wat inhoudt dat een bestand dat wordt getrackt is gewijzigd in de werkdirectory, maar nog niet is gestaged. Om het te stagen, voer je het `git add` commando uit (het is een veelzijdig commando: je gebruikt het om bestanden te laten tracken, om bestanden te stagen, en om andere dingen zoals een bestand met een mergeconflict als opgelost te markeren). Laten we nu `git add` uitvoeren om het `benchmarks.rb` bestand te stagen, en dan nog eens `git status` uitvoeren:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

Beide bestanden zijn gestaged en zullen met je volgende commit meegaan. Stel nu dat je je herinnert dat je nog een kleine wijziging in `benchmarks.rb` wilt maken voordat je het commit. Je kunt het opnieuw openen en die wijziging maken, en dan ben je klaar voor de commit. Alhoewel, laten we `git status` nog een keer uitvoeren:

	$ vim benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Asjemenou?! Nu staat `benchmarks.rb` zowel bij de staged en unstaged genoemd. Hoe is dat mogelijk? Het blijkt dat Git een bestand precies zoals het is staget wanneer je het `git add` commando uitvoert. Als je nu commit, dan zal de versie van `benchmarks.rb` zoals het was toen je voor 't laatst `git add` uitvoerde worden toegevoegd in de commit, en niet de versie van het bestand zoals het eruit ziet in je werkdirectory toen je `git commit` uitvoerde. Als je een bestand wijzigt nadat je `git add` uitvoert, dan moet je `git add` nogmaals uitvoeren om de laatste versie van het bestand te stagen:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

### Bestanden negeren ###

Vaak zul je een klasse bestanden hebben waarvan je niet wilt dat Git deze automatisch toevoegt of zelfs maar als untracked toont. Dit zijn doorgaans automatisch gegenereerde bestanden zoals logbestanden of bestanden die geproduceerd worden door je bouwsysteem. In die gevallen kun je een bestand genaamd `.gitignore` maken, waarin patronen staan die die bestanden passen. Hier is een voorbeeld van een `.gitignore` bestand:

	$ cat .gitignore
	*.[oa]
	*~

De eerste regel vertelt Git om ieder bestand te negeren waarvan de naam eindigt op een `.o` of `.a` (*object* en *archief* bestanden die het product kunnen zijn van het bouwen van je code). De tweede regel vertelt Git dat ze alle bestanden moet negeren die eindigen op een tilde (`~`), wat gebruikt wordt door editors zoals Emacs om tijdelijke bestanden aan te geven. Je mag ook `log`, `tmp` of een `pid` directory toevoegen, automatisch gegenereerde documentatie, enzovoort. Een `.gitignore` bestand aanmaken voordat je gaat beginnen is over 't algemeen een goed idee, zodat je niet per ongeluk bestanden commit die je echt niet in je repository wilt hebben.

De regels voor patronen die je in het `.gitignore` bestand kunt zetten zijn als volgt:

*	Lege regels of regels die beginnen met een `#` worden genegeerd.
*	Standaard expansie (glob) patronen werken.
*	Je mag patronen laten eindigen op een schuine streep (`/`) om een directory te specificeren.
*	Je mag een patroon ontkennend maken door het te laten beginnen met een uitroepteken (`!`).

Expansie (`glob`) patronen zijn vereenvoudigde reguliere expressies die in shell-omgevingen gebruikt worden. Een asterisk (`*`) komt overeen met nul of meer karakters, `[abc]` komt overeen met ieder karakter dat tussen de blokhaken staat (in dit geval `a`, `b` of `c`), een vraagteken (`?`) komt overeen met een enkel karakter en blokhaken waartussen karakters staan die gescheiden zijn door een streepje (`[0-9]`) komen overeen met ieder karakter wat tussen die karakters zit (in dit geval 0 tot en met 9).

Hier is nog een voorbeeld van een `.gitignore` bestand:

	# een commentaar – dit wordt genegeerd
	# geen .a files
	*.a
	# maar track lib.a wel, ook al negeer je hierboven .a files
	!lib.a
	# negeer alleen de file TODO in de root, niet de subdirectory /TODO
	/TODO
	# negeer alle bestanden in de build/ directory
	build/
	# negeer doc/notes.txt, maar niet doc/server/arch.txt
	doc/*.txt

Een `**/` patroon is sinds versie 1.8.2 beschikbaar in Git.

### Je staged en unstaged wijzigingen zien ###

Als het `git status` commando te vaag is voor je, je wilt precies weten wat je veranderd hebt en niet alleen welke bestanden veranderd zijn, dan kun je het `git diff` commando gebruiken. We zullen `git diff` later in meer detail bespreken, maar je zult dit commando het meest gebruiken om deze twee vragen te beantwoorden: Wat heb je veranderd maar nog niet gestaged? En wat heb je gestaged en sta je op het punt te committen? Waar `git status` deze vragen heel algemeen beantwoordt, laat `git diff` je de exacte toegevoegde en verwijderde regels zien, de patch, als het ware.

Stel dat je het `README` bestand opnieuw verandert en staget, en dan het `benchmarks.rb` bestand verandert zonder het te stagen. Als je je `status` commando uitvoert, dan zie je nogmaals zoiets als dit:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Om te zien wat je gewijzigd maar nog niet gestaged hebt, typ `git diff` in zonder verdere argumenten:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

Dat commando vergelijkt wat er in je werkdirectory zit met wat er in je staging area zit. Het resultaat laat je zien welke wijzigingen je gedaan hebt, die je nog niet gestaged hebt.

Als je wilt zien wat je gestaged hebt en in je volgende commit zal zitten, dan kun je `git diff –-cached` gebruiken. (In Git versie 1.6.1 en nieuwer kun je ook `git diff --staged` gebruiken, wat misschien beter te onthouden is.) Dit commando vergelijkt je staged wijzigingen met je laatste commit:

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

Het is belangrijk om te zien dat `git diff` zelf niet alle wijzigingen sinds je laatste commit laat zien, alleen wijzigingen die nog niet gestaged zijn. Dit kan verwarrend zijn, omdat als je al je wijzigingen gestaged hebt, `git diff` geen output zal geven.

Nog een voorbeeld. Als je het `benchmarks.rb` bestand staget en vervolgens verandert, dan kun je `git diff` gebruiken om de wijzigingen in het bestand te zien dat gestaged is en de wijzigingen die niet gestaged zijn:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Nu kun je `git diff` gebruiken om te zien wat nog niet gestaged is

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

en `git diff --cached` om te zien wat je tot nog toe gestaged hebt:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### Je wijzigingen committen ###

Nu je staging area gevuld is zoals jij het wilt, kun je de wijzigingen committen. Onthoud dat alles wat niet gestaged is, dus ieder bestand dat je gemaakt of gewijzigd hebt en waarop je nog geen `git add` uitgevoerd hebt, niet in deze commit mee zal gaan. Ze zullen als gewijzigde bestanden op je schijf blijven staan.
In dit geval zag je de laatste keer dat je `git status` uitvoerde, dat alles gestaged was. Dus je bent er klaar voor om je wijzigingen te committen. De makkelijkste manier om te committen is om `git commit` in te typen:

	$ git commit

Dit start de door jou gekozen editor op. (Dit wordt bepaald door de `$EDITOR` omgevingsvariabele in je shell, meestal vim of emacs, alhoewel je dit kunt instellen op welke editor je wilt gebruiken met het `git config --global core.editor` commando zoals je in *Hoofdstuk 1* gezien hebt).

De editor laat de volgende tekst zien (dit voorbeeld is een Vim scherm):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#       new file:   README
	#       modified:   benchmarks.rb
	#
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Je kunt zien dat de standaard commit boodschap de laatste output van het `git status` commando als commentaar bevat en een lege regel bovenaan. Je kunt deze commentaren verwijderen en je eigen commit boodschap intypen, of je kunt ze laten staan om je eraan te helpen herinneren wat je aan het committen bent. (Om een meer expliciete herinnering van je wijzigingen te zien kun je de `-v` optie meegeven aan `git commit`. Als je dit doet zet Git de diff van je veranderingen in je editor zodat je precies kunt zien wat je gedaan hebt.) Als je de editor verlaat, creëert Git je commit boodschap (zonder de commentaren of de diff).

Als alternatief kun je de commit boodschap met het `commit` commando meegeven door hem achter de `-m` optie te specificeren, zoals hier:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Story 182: Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

Nu heb je je eerste commit gemaakt! Je kunt zien dat de commit je wat output over zichzelf heeft gegeven: op welke branch je gecommit hebt (`master`), welke SHA-1 checksum de commit heeft (`463dc4f`), hoeveel bestanden er veranderd zijn, en statistieken over toegevoegde en verwijderde regels in de commit.

Onthoud dat de commit de snapshot, die je in je staging area ingesteld hebt, opslaat. Alles wat je niet gestaged hebt staat nog steeds gewijzigd; je kunt een volgende commit doen om het aan je geschiedenis toe te voegen. Iedere keer dat je een commit doet, leg je een snapshot van je project vast dat je later terug kunt draaien of waarmee je kunt vergelijken.

### De staging area overslaan ###

Alhoewel het ontzettend makkelijk kan zijn om commits precies zoals je wilt te maken, is de staging area soms iets ingewikkelder dan je in je workflow nodig hebt. Als je de staging area wilt overslaan, dan kan je met Git makkelijk de route inkorten. Door de `-a` optie aan het `git commit` commando mee te geven zal Git automatisch ieder bestand dat al getrackt wordt voor de commit stagen, zodat je het `git add` gedeelte kunt overslaan:

	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	
	no changes added to commit (use "git add" and/or "git commit -a")
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+)

Merk op dat je nu geen `git add` op het `benchmarks.rb` bestand hoeft te doen voordat je commit.

### Bestanden verwijderen ###

Om een bestand van Git te verwijderen, moet je het van de getrackte bestanden verwijderen (of om precies te zijn: verwijderen van je staging area) en dan een commit doen. Het `git rm` commando doet dat, en verwijdert het bestand ook van je werkdirectory zodat je het de volgende keer niet als een untrackt bestand ziet.

Als je het bestand simpelweg verwijdert uit je werkdirectory, zal het te zien zijn onder het “Changes not staged for commit” (dat wil zeggen, _unstaged_) gedeelte van je `git status` output:

	$ rm grit.gemspec
	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add/rm <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        deleted:    grit.gemspec
	
	no changes added to commit (use "git add" and/or "git commit -a")

Als je daarna `git rm` uitvoert, zal de verwijdering van het bestand gestaged worden:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        deleted:    grit.gemspec
	

Als je de volgende keer een commit doet, zal het bestand verdwenen zijn en niet meer getrackt worden. Als je het bestand veranderd hebt en al aan de index toegevoegd, dan zul je de verwijdering moeten forceren met de `-f` optie. Dit is een veiligheidsmaatregel om te voorkomen dat je per ongeluk data die nog niet in een snapshot zit, en dus niet teruggehaald kan worden uit Git, weggooit.

Een ander handigheidje wat je misschien wilt gebruiken is het bestand in je werkdirectory houden, maar van je staging area verwijderen. Met andere woorden, je wilt het bestand misschien op je harde schijf bewaren, maar niet dat Git het bestand nog trackt. Dit is erg handig als je iets vergeten bent aan je `.gitignore` bestand toe te voegen, en het per ongeluk toegevoegd hebt. Zoals een groot logbestand, of een serie `.a` gecompileerde bestanden. Gebruik de `--cached` optie om dit te doen:

	$ git rm --cached readme.txt

Je kunt bestanden, directories en bestandspatronen aan het `git rm` commando meegeven. Dat betekent dat je zoiets als dit kunt doen

	$ git rm log/\*.log

Let op de backslash (`\`) voor de `*`. Dit is nodig omdat Git zijn eigen bestandsnaam-expansie doet, naast die van je shell. In de Windows systeemconsole moet de backslash worden weggelaten. Dit commando verwijdert alle bestanden die de `.log` extensie hebben in de `log/` directory. Of, je kunt zoiets als dit doen:

	$ git rm \*~

Dit commando verwijdert alle bestanden die eindigen met `~`.

### Bestanden verplaatsen ###

Anders dan vele andere VCS systemen, traceert Git niet expliciet verplaatsingen van bestanden. Als je een bestand een nieuwe naam geeft in Git, is er geen metadata opgeslagen in Git die vertelt dat je het bestand hernoemd hebt. Maar Git is slim genoeg om dit alsnog te zien, we zullen bestandsverplaatsing-detectie wat later behandelen.

Het is daarom een beetje verwarrend dat Git een `mv` commando heeft. Als je een bestand wilt hernoemen in Git, kun je zoiets als dit doen

	$ git mv file_from file_to

en dat werkt prima. Sterker nog, als je zoiets als dit uitvoert en naar de status kijkt, zul je zien dat Git het als een hernoemd bestand beschouwt:

	$ git mv README README.txt
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        renamed:    README -> README.txt
	

Maar dat is gelijk aan het uitvoeren van het volgende:

	$ mv README README.txt
	$ git rm README
	$ git add README.txt

Git komt er impliciet achter dat het om een hernoemd bestand gaat, dus het maakt niet uit of je een bestand op deze manier hernoemt of met het `mv` commando. Het enige echte verschil is dat het `mv` commando slechts één commando is in plaats van drie. En belangrijker nog is dat je iedere applicatie kunt gebruiken om een bestand te hernoemen, en de add/rm later kunt afhandelen voordat je commit.

## De commit geschiedenis bekijken ##

Nadat je een aantal commits gemaakt hebt, of als je een repository met een bestaande commit-geschiedenis gecloned hebt, zul je waarschijnlijk terug willen zien wat er gebeurd is. De meest basale en krachtige tool om dit te doen is het `git log` commando.

Deze voorbeelden maken gebruik van een eenvoudig project genaamd simplegit dat ik vaak voor demonstraties gebruik. Om het project op te halen, voer dit uit

	git clone git://github.com/schacon/simplegit-progit.git

Als je `git log` in dit project uitvoert, zou je output moeten krijgen die er ongeveer zo uitziet:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

Zonder argumenten toont `git log` standaard de commits die gedaan zijn in die repository, in omgekeerde chronologische volgorde. Dat wil zeggen: de meest recente commits worden als eerste getoond. Zoals je kunt zien, toont dit commando iedere commit met zijn SHA-1 checksum, de naam van de auteur en zijn e-mail, de datum van opslaan, en de commit boodschap.

Een gigantisch aantal en variëteit aan opties zijn beschikbaar voor het `git log` commando om je precies te laten zien waar je naar op zoek bent. Hier laten we je de meest gebruikte opties zien.

Een van de meest behulpzame opties is `-p`, wat de diff laat zien van de dingen die in iedere commit geïntroduceerd zijn. Je kunt ook `-2` gebruiken, om alleen de laatste twee items te laten zien:

	$ git log –p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,7 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

Deze optie toont dezelfde informatie, maar dan met een diff volgend op ieder item. Dit is erg handig voor een code review, of om snel te zien wat er tijdens een reeks commits gebeurd is die een medewerker toegevoegd heeft.

Soms is het handiger om wijzigingen na te kijken op woordniveau in plaats van op regelniveau. Er is een `--word-diff` optie beschikbaar in Git, die je aan het `git log -p` commando kan toevoegen om een woord diff te krijgen inplaats van de reguliere regel voor regel diff. Woord diff formaat is nogal nutteloos als het wordt toegepast op broncode, maar is erg handig als het wordt toegepast op grote tekstbestanden, zoals boeken of een dissertatie. Hier is een voorbeeld.

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

Zoals je kunt zien zijn er geen toegevoegde of verwijderde regels in deze uitvoer zoals in een normale diff. Wijzigingen worden daarentegen binnen de regel getoond. Je kunt het toegevoegde woord zien binnen een `{+ +}` en verwijderde binnen een `[- -]`. Je kunt ook kiezen om de gebruikelijke 3 regels context in de diff uitvoer tot één regel te verminderen, omdat de context nu woorden is, en geen regels. Je kunt dit doen met `-U1` zoals hierboven in het voorbeeld.

Je kunt ook een serie samenvattende opties met `git log` gebruiken. Bijvoorbeeld, als je wat verkorte statistieken bij iedere commit wilt zien, kun je de `--stat` optie gebruiken:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 file changed, 1 insertion(+), 1 deletion(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 file changed, 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+)

Zoals je ziet, drukt de `--stat` optie onder iedere commit een lijst gewijzigde bestanden af, hoeveel bestanden gewijzigd zijn, en hoeveel regels in die bestanden zijn toegevoegd en verwijderd. Het toont ook een samenvatting van de informatie aan het einde.
Een andere handige optie is `--pretty`. Deze optie verandert de log output naar een ander formaat dan de standaard. Er zijn al een paar voorgebouwde opties voor je beschikbaar. De `oneline` optie drukt iedere commit op een eigen regel af, wat handig is als je naar een hoop commits kijkt. Daarnaast tonen de `short`, `full` en `fuller` opties de output in grofweg hetzelfde formaat, maar met minder of meer informatie, respectievelijk:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

De meest interessante optie is `format`, waarmee je je eigen log-uitvoer-formaat kunt specificeren. Dit is in het bijzonder handig als je output aan het genereren bent voor automatische verwerking; omdat je expliciet het formaat kan specificeren, weet je dat het niet zal veranderen bij volgende versies van Git:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tabel 2-1 toont een aantal handige opties die aan format gegeven kunnen worden.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optie	Omschrijving van de Output
	%H	Commit hash
	%h	Afgekorte commit hash
	%T	Tree hash
	%t	Afgekorte tree hash
	%P	Parent hashes
	%p	Afgekorte parent hashes
	%an	Auteur naam
	%ae	Auteur e-mail
	%ad	Auteur datum (formaat respecteert de –date= optie)
	%ar	Auteur datum, relatief
	%cn	Committer naam
	%ce	Committer e-mail
	%cd	Committer datum
	%cr	Committer datum, relatief
	%s	Onderwerp

Je zult je misschien afvragen wat het verschil is tussen _author_ en _committer_. De _author_ is de persoon die de patch oorspronkelijk geschreven heeft, en de _committer_ is de persoon die de patch als laatste heeft toegepast. Dus als je een patch naar een project stuurt en een van de kernleden past de patch toe, dan krijgen jullie beiden de eer, jij als de auteur en het kernlid als de committer. We gaan hier wat verder op in in *Hoofdstuk 5*.

De `oneline` en `format` opties zijn erg handig in combinatie met een andere `log` optie genaamd `--graph`. Deze optie maakt een mooie ASCII grafiek waarin je branch- en merge-geschiedenis getoond worden, die we kunnen zien in onze kopie van het Grit project repository:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

Dat zijn slechts een paar simpele output formaat opties voor `git log`; er zijn er nog veel meer. Tabel 2-2 toont de opties waarover we het tot nog toe gehad hebben, en wat veel voorkomende formaat-opties die je misschien handig vindt, samen met hoe ze de output van het `log` commando veranderen.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optie	Omschrijving
	-p	Toon de patch geïntroduceerd bij iedere commit.
	--word-diff	Toon de patch in een woord diff formaat.
	--stat	Toon statistieken voor gewijzigde bestanden per commit.
	--shortstat	Toon alleen de gewijzigde/ingevoegde/verwijderde regel van het --stat commando.
	--name-only	Toon de lijst van bestanden die gewijzigd zijn na de commit-informatie.
	--name-status	Toon ook de lijst van bestanden die beïnvloed zijn door de toegevoegde/gewijzigde/verwijderde informatie.
	--abbrev-commit	Toon alleen de eerste paar karakters van de SHA-1 checksum in plaats van alle 40.
	--relative-date	Toon de datum in een relatief formaat (bijvoorbeeld, "2 weken geleden"), in plaats van het volledige datum formaat.
	--graph	Toon een ASCII grafiek van de branch- en merge-geschiedenis naast de log output.
	--pretty	Toon commits in een alternatief formaat. De opties bevatten oneline, short, full, fuller, en format (waarbij je je eigen formaat specificeert).
	--oneline	Een gemaks-optie, staat voor `--pretty=oneline --abbrev-commit`.

### Log output limiteren ###

Naast het formatteren van de output, heeft `git log` nog een aantal bruikbare limiterende opties; dat wil zeggen, opties die je een subset van de commits tonen. Je hebt zo'n optie al gezien: de `-2` optie, die slechts de laatste twee commits laat zien. Sterker nog: je kunt `-<n>` doen, waarbij `n` een heel getal is om de laatste `n` commits te laten zien. In feite zul je deze vorm weinig gebruiken, omdat Git standaard alle output door een pager (pagineer applicatie) stuurt zodat je de log-uitvoer pagina voor pagina ziet.

Dat gezegd hebbende, zijn de tijd-limiterende opties zoals `--since` en `--until` erg handig. Dit commando bijvoorbeeld, geeft een lijst met commits die gedaan zijn gedurende de laatste twee weken:

	$ git log --since=2.weeks

Dit commando werkt met veel formaten: je kunt een specifieke datum kiezen ("2008-01-15”) of een relatieve datum zoals "2 jaar 1 dag en 3 minuten geleden".

Je kunt ook de lijst met commits filteren op bepaalde criteria. De `--author` optie laat je filteren op een specifieke auteur, en de `--grep` optie laat je op bepaalde zoekwoorden filteren in de commit boodschappen. (Let op dat als je zowel auteur als grep opties specificeert het commando commits zal matchen met beide.) Als je meerdere grep opties wilt specificeren, zal je `--all-match` moet toevoegen, anders zal het commando ook commits met één van de twee criteria selecteren.

De laatste echt handige optie om aan `git log` als filter mee te geven is een pad. Als je een directory of bestandsnaam opgeeft, kun je de log output limiteren tot commits die een verandering introduceren op die bestanden. Dit is altijd de laatste optie en wordt over het algemeen vooraf gegaan door dubbele streepjes (`--`) om de paden van de opties te scheiden.

In Tabel 2-3 laten we deze en een paar andere veel voorkomende opties zien als referentie.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optie	Omschrijving
	-(n)	Laat alleen de laatste n commits zien
	--since, --after	Limiteer de commits tot degenen waarvan de CommitDate op of na de gegeven datum/tijd ligt.
	--until, --before	Limiteer de commits tot degenen waarvan de CommitDate op of voor de gegeven datum/tijd ligt.
	--author	Laat alleen de commits zien waarvan de auteur bij de gegeven tekst past.
	--committer	Laat alleen de commits zien waarvan de committer bij de gegeven tekst past.

### Log uitvoer beperken volgens datum/tijd ###

Om te bepalen welke commits in de Git broncode repository aanwezig zijn  (git://git.kernel.org/pub/scm/git/git.git) met een CommitDate van 2014-04-29 relatief aan je lokale tijdzone (zoals ingesteld op jouw computer), gebruik je

    $ git log --after="2014-04-29 00:00:00" --before="2014-04-29 23:59:59" \
      --pretty=fuller

Omdat de uitvoer zal verschillen met de tijdzone waar dit commando wordt gegeven, wordt het aangeraden om altijd een absolute tijd zoals volgens het ISO 8601 formaat (welke tijdzone informatie bevat) als argument bij `--after` and `--before` te gebruiken, zodat iedereen die het commando geeft dezelfde herhaalbare resultaten krijgt. 

Om de commits gemaakt op een specifiek moment in de tijd te krijgen (bijv. 29 April 2013 om 17:07:22 CET), kunnen we dit gebruiken

    $ git log  --after="2013-04-29T17:07:22+0200"      \
              --before="2013-04-29T17:07:22+0200" --pretty=fuller
    
    commit de7c201a10857e5d424dbd8db880a6f24ba250f9
    Author:     Ramkumar Ramachandra <artagnon@gmail.com>
    AuthorDate: Mon Apr 29 18:19:37 2013 +0530
    Commit:     Junio C Hamano <gitster@pobox.com>
    CommitDate: Mon Apr 29 08:07:22 2013 -0700
    
        git-completion.bash: lexical sorting for diff.statGraphWidth
        
        df44483a (diff --stat: add config option to limit graph width,
        2012-03-01) added the option diff.startGraphWidth to the list of
        configuration variables in git-completion.bash, but failed to notice
        that the list is sorted alphabetically.  Move it to its rightful place
        in the list.
        
        Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
        Signed-off-by: Junio C Hamano <gitster@pobox.com>

De bovenstaande tijden (`AuthorDate`, `CommitDate`) worden getoond in het standaard formaat (`--date=default`), welke de tijdzone informatie van respectievelijk de auteur en committer weergeeft.

Andere nuttige formaten zijn onder andere `--date=iso` (ISO 8601), `--date=rfc` (RFC 2822), `--date=raw` (seconden sinds de "epoch" (1970-01-01 UTC)) `--date=local` (tijden volgens jouw locale tijdzone) alsmede `--date=relative` (bijv. "2 hours ago").

Als het commando `git log` zonder tijdsaanduiding gebruikt wordt, wordt de tijd van je computer aangehouden op het moment dat het commando wordt uitgevoerd (met behoud van het relatieve verschil met UTC).

Bijvoorbeeld, het uitvoeren van een `git log` commando om 09:00 op jouw computer waarbij je tijdzone op dat moment 3 uur voorloopt op UTC, maakt de uitvoer van de volgende twee commando's gelijk:

    $ git log --after=2008-06-01 --before=2008-07-01
    $ git log --after="2008-06-01T09:00:00+0300" \
        --before="2008-07-01T09:00:00+0300"

Als laatste voorbeeld, als je commits wilt zien die de testbestanden wijzigen in de Git sourcecode geschiedenis die door Junio Hamano gecommit waren met de CommitDate in de maand  oktober 2008 (relatief tot de tijdzone van New York) en die geen merges waren, kan je bijvoorbeeld het volgende commando typen:

        $ git log --pretty="%h - %s" --author=gitster \
           --after="2008-10-01T00:00:00-0400"         \
          --before="2008-10-31T23:59:59-0400" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Van de bijna 36.000 commits in de Git broncode historie, laat dit commando de 6 zien die bij die criteria passen.

### Een grafische interface gebruiken om de historie te visualiseren ###

Als je een meer grafische applicatie wilt gebruiken om je commit historie te visualiseren, wil je misschien een kijkje nemen naar het Tcl/Tk programma genaamd `gitk` dat met Git meegeleverd wordt. Gitk is eigenlijk een visuele `git log` tool, en het accepteert bijna alle filter opties die `git log` ook accepteert. Als je `gitk` in op de commandoregel in je project typt, zou je zoiets als in Figuur 2-2 moeten zien.

Insert 18333fig0202.png
Figuur 2-2. De gitk historie-visualiseerder.

Je kunt de commit-historie in de bovenste helft van het scherm zien, samen met een afkomst graaf. De diff in de onderste helft van het scherm laat je de veranderingen zien die geïntroduceerd zijn bij iedere commit die je aanklikt.

## Dingen ongedaan maken ##

Op enig moment wil je misschien iets ongedaan maken. Hier zullen we een aantal basis-tools laten zien om veranderingen die je gemaakt hebt weer ongedaan te maken. Maar pas op, je kunt niet altijd het ongedaan maken weer ongedaan maken. Dit is één van de weinige gedeeltes in Git waarbij je werk kwijt kunt raken als je het verkeerd doet.

### Je laatste commit veranderen ###

Een van de veel voorkomende acties die ongedaan gemaakt moeten worden vinden plaats als je te vroeg commit en misschien vergeet een aantal bestanden toe te voegen, of je verknalt je commit boodschap. Als je opnieuw wilt proberen te committen, dan kun je commit met de `--amend` optie uitvoeren:

	$ git commit --amend

Dit commando neemt je staging area en gebruikt dit voor de commit. Als je geen veranderingen sinds je laatste commit hebt gedaan (bijvoorbeeld, je voert dit commando meteen na je laatste commit uit), dan zal je snapshot er precies hetzelfde uitzien en zal je commit boodschap het enige zijn dat je verandert.

Dezelfde commit-boodschap editor start op, maar deze bevat meteen de boodschap van je vorige commit. Je kunt de boodschap net als andere keren aanpassen, maar het overschrijft je vorige commit.

Bijvoorbeeld, als je commit en je dan realiseert dat je vergeten bent de veranderingen in een bestand dat je wou toevoegen in deze commit te stagen, dan kun je zoiets als dit doen:

	$ git commit -m 'initial commit'
	$ git add vergeten_bestand
	$ git commit --amend

Na deze drie commando's eindig je met één commit; de tweede commit vervangt de resultaten van de eerste.

### Een staged bestand unstagen ###

De volgende twee paragrafen laten zien hoe je de staging area en veranderingen in je werkdirectories aanpakt. Het prettige hier is dat het commando dat je gebruikt om de status van die gebieden te bepalen, je er ook aan herinnert hoe je de veranderingen eraan weer ongedaan kunt maken. Bijvoorbeeld, stel dat je twee bestanden gewijzigd hebt en je wilt ze committen als twee aparte veranderingen, maar je typt per ongeluk `git add *` en staged ze allebei. Hoe kun je één van de twee nu unstagen? Het `git status` commando herinnert je eraan:

	$ git add .
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	        modified:   benchmarks.rb
	

Direct onder de "Changes to be committed" tekst, staat dat je `git reset HEAD <file>...` moet gebruiken om te unstagen. Laten we dat advies volgen om het `benchmarks.rb` bestand te unstagen:

	$ git reset HEAD benchmarks.rb
	Unstaged changes after reset:
	M       benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Het commando is een beetje vreemd, maar het werkt. Het benchmarks.rb bestand is gewijzigd maar weer geunstaged.

### Een gewijzigd bestand weer ongewijzigd maken ###

Wat als je je realiseert dat je de wijzigingen aan het `benchmarks.rb` bestand niet wilt behouden? Hoe kun je dit makkelijk ongedaan maken; terugbrengen in de staat waarin het was toen je voor het laatst gecommit hebt (of initieel gecloned, of hoe je het ook in je werkdirectory gekregen hebt)? Gelukkig vertelt `git status` je ook hoe je dat moet doen. In de laatste voorbeeld-output, ziet het unstaged gebied er zo uit:

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Het vertelt je behoorlijk expliciet hoe je je veranderingen moet weggooien (tenminste, de nieuwere versies van Git, 1.6.1 of nieuwer, doen dit. Als je een oudere versie hebt, raden we je ten zeerste aan om het te upgraden zodat je een aantal van deze fijne bruikbaarheidsopties krijgt). Laten we eens doen wat er staat:

	$ git checkout -- benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	

Je kunt zien dat de veranderingen teruggedraaid zijn. Je moet je ook beseffen dat dit een gevaarlijk commando is: alle veranderingen die je aan dat bestand gedaan hebt zijn weg; je hebt er zojuist een ander bestand overheen gezet. Gebruik dit commando dan ook nooit, tenzij je heel zeker weet dat je het bestand niet wilt. Als je het alleen maar uit de weg wilt hebben, gebruik dan branching of stashing wat we behandelen in het volgende hoofdstuk; dit zijn vaak de betere opties.

Onthoud, alles dat in Git gecommit is kan bijna altijd weer hersteld worden. Zelfs commits die op reeds verwijderde branches gedaan zijn, of commits die zijn overschreven door een `--amend` commit, kunnen weer hersteld worden (zie *Hoofdstuk 9* voor data herstel). Maar, alles wat je verliest dat nog nooit was gecommit is waarschijnlijk voor altijd verloren.

## Werken met remotes ##

Om samen te kunnen werken op eender welke Git project, moet je weten hoe je de remote repositories moet beheren. Remote repositories zijn versies van je project, die worden beheerd op het Internet of ergens op een netwerk. Je kunt er meerdere hebben, waarvan over het algemeen ieder ofwel alleen leesbaar, of lees- en schrijfbaar is voor jou. Samenwerken met anderen houdt in dat je deze remote repositories kunt beheren en data kunt pushen en pullen op het moment dat je werk moet delen.
Remote repositories beheren houdt ook in weten hoe je ze moet toevoegen, ongeldige repositories moet verwijderen, meerdere remote branches moet beheren en ze als tracked of niet kunt definiëren, en meer. In deze sectie zullen we deze remote-beheer vaardigheden behandelen.

### Laat je remotes zien ###

Om te zien welke remote servers je geconfigureerd hebt, kun je het `git remote` commando uitvoeren. Het laat de verkorte namen van iedere remote alias zien die je gespecificeerd hebt. Als je de repository gecloned hebt, dan zul je op z'n minst de *origin* zien; dat is de standaard naam die Git aan de server geeft waarvan je gecloned hebt:

	$ git clone git://github.com/schacon/ticgit.git
	Cloning into 'ticgit'...
	remote: Reusing existing pack: 1857, done.
	remote: Total 1857 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (1857/1857), 374.35 KiB | 193.00 KiB/s, done.
	Resolving deltas: 100% (772/772), done.
	Checking connectivity... done.
	$ cd ticgit
	$ git remote
	origin

Je kunt ook `-v` specificeren, wat je de URL laat zien die Git bij de verkorte naam heeft opgeslagen om naar geëxpandeerd te worden:

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

Als je meer dan één remote hebt, dan laat het commando ze allemaal zien. Bijvoorbeeld, mijn Grit repository ziet er ongeveer zo uit.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Dit betekent dat we vrij gemakkelijk de bijdragen van ieder van deze gebruikers naar binnen kunnen pullen. Maar merk ook op dat alleen de origin een SSH URL is, dus dat is de enige waar ik naartoe kan pushen (we laten in *Hoofdstuk 4* zien waarom dat zo is).

### Remote repositories toevoegen ###

Ik heb het toevoegen van remote repositories al genoemd en getoond in vorige paragrafen, maar hier toon ik expliciet hoe dat gedaan wordt. Om een nieuw Git remote repository als een makkelijk te refereren alias toe te voegen, voer je `git remote add [verkorte naam] [url]` uit:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Nu kun je de naam pb op de commandoregel gebruiken in plaats van de hele URL. Bijvoorbeeld, als je alle informatie die Paul wel, maar jij niet in je repository hebt wilt fetchen, dan kun je git fetch pb uitvoeren:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

De master branch van Paul is lokaal toegankelijk als `pb/master`; je kunt het in een van jouw branches mergen, of je kunt een lokale branch uitchecken op dat punt als je het wil zien.

### Van je remotes fetchen en pullen ###

Zoals je zojuist gezien hebt, kun je om data van je remote projecten te halen dit uitvoeren:

	$ git fetch [remote-name]

Het commando gaat naar het remote project en haalt alle data van dat remote project dat jij nog niet hebt. Nadat je dit gedaan hebt, zou je references (referenties) naar alle branches van dat remote project moeten hebben, die je op ieder tijdstip kunt mergen en bekijken. (We zullen in meer detail zien wat branches precies zijn, en hoe je ze moet gebruiken in *Hoofdstuk 3*.)

Als je een repository clonet, voegt dat commando die remote repository automatisch toe onder de naam *origin*. Dus `git fetch origin` fetcht (haalt) ieder nieuw werk dat gepusht is naar die server sinds je gecloned hebt (of voor het laatst gefetcht hebt). Het is belangrijk om te weten dat het fetch commando de data naar je locale repository haalt; het merget niet automatisch met je werk of verandert waar je momenteel aan zit te werken. Je moet het handmatig in je werk mergen wanneer je er klaar voor bent.

Als je een branch geconfigureerd hebt om een remote branch te volgen (tracken) (zie de volgende paragraaf en *Hoofdstuk 3* voor meer informatie), dan kun je het `git pull` commando gebruiken om automatisch een remote branch te fetchen en mergen in je huidige branch. Dit kan makkelijker of meer comfortabele workflow zijn voor je; en standaard stelt het `git clone` commando je lokale master branch zo in dat het de remote master branch van de server waarvan je gecloned hebt volgt (aangenomen dat de remote een master branch heeft). Over het algemeen zal een `git pull` dat van de server waarvan je origineel gecloned hebt halen en proberen het automatisch in de code waar je op dat moment aan zit te werken te mergen.

### Naar je remotes pushen ###

Wanneer je jouw project op een punt hebt dat je het wilt delen, dan moet je het stroomopwaarts pushen. Het commando hiervoor is simpel: `git push [remote-name] [branch-name]`. Als je de master branch naar je `origin` server wilt pushen (nogmaals, over het algemeen zet clonen beide namen automatisch goed voor je), dan kun je dit uitvoeren om je werk terug op de server te pushen:

	$ git push origin master

Dit commando werkt alleen als je gecloned hebt van een server waarop je schrijfrechten hebt, en als niemand in de tussentijd gepusht heeft. Als jij en iemand anders op hetzelfde tijdstip gecloned hebben en zij pushen eerder stroomopwaarts dan jij, dan zal je push terecht geweigerd worden. Je zult eerst hun werk moeten pullen en in jouw werk verwerken voordat je toegestaan wordt te pushen. Zie *Hoofdstuk 3* voor meer gedetailleerde informatie over hoe je naar remote servers moet pushen.

### Een remote inspecteren ###

Als je meer informatie over een bepaalde remote wilt zien, kun je het `git remote show [remote-name]` commando gebruiken. Als je dit commando met een bepaalde alias uitvoert, zoals `origin`, dan krijg je zoiets als dit:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Het toont de URL voor de remote repository samen met de tracking branch informatie. Het commando vertelt je behulpzaam dat als je op de master branch zit en je voert `git pull` uit, dat Git dan automatisch de master branch van de remote zal mergen nadat het alle remote references opgehaald heeft. Het toont ook alle remote referenties die het gepulled heeft.

Dat is een eenvoudig voorbeeld dat je vaak zult tegenkomen. Als je Git echter intensiever gebruikt, zul je veel meer informatie van `git remote show` krijgen:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

Dit commando toont welke branch automatisch gepusht wordt als je `git push` uitvoert op bepaalde branches. Het toont je ook welke remote branches op de server je nog niet hebt, welke remote branches je hebt die verwijderd zijn van de server, en meerdere branches die automatisch gemerged worden als je `git pull` uitvoert.

### Remotes verwijderen en hernoemen ###

Als je een referentie wilt hernoemen, dan kun je in nieuwere versie van Git `git remote rename` uitvoeren om een alias van een remote te wijzigen. Bijvoorbeeld, als je `pb` wilt hernoemen naar `paul`, dan kun je dat doen met `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Het is de moeite waard om te melden dat dit ook je remote branch naam verandert. Wat voorheen gerefereerd werd als `pb/master` is nu `paul/master`.

Als je om een of andere reden een referentie wilt verwijderen, je hebt de server verplaatst of je gebruikt een bepaalde mirror niet meer, of een medewerker doet niet meer mee, dan kun je `git remote rm` gebruiken:

	$ git remote rm paul
	$ git remote
	origin

## Taggen (Labelen) ##

Zoals de meeste VCS'en, heeft git de mogelijkheid om specifieke punten in de history als belangrijk te taggen (labelen). Over het algemeen gebruiken mensen deze functionaliteit om versie-punten te markeren (`v1.0`, en zo). In deze paragraaf zul je leren hoe de beschikbare tags te tonen, hoe nieuwe tags te creëren, en wat de verschillende typen tags zijn.

### Jouw tags laten zien ###

De beschikbare tags in Git laten zien is rechttoe rechtaan. Type gewoon `git tag`:

	$ git tag
	v0.1
	v1.3

Dit commando toont de tags in alfabetische volgorde; de volgorde waarin ze verschijnen heeft geen echte betekenis.

Je kunt ook zoeken op tags met een bepaald patroon. De Git bron-repository, bijvoorbeeld, bevat meer dan 240 tags. Als je alleen geïnteresseerd bent om naar de 1.4.2 serie te kijken, kun je dit uitvoeren:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Tags creëren ###

Git gebruikt twee soorten tags: lightweight (lichtgewicht) en annotated (beschreven). Een lightweight tag komt overeen met een branch die niet verandert: het is slechts een wijzer naar een specifieke commit. Annotated tags daarentegen, zijn als volwaardige objecten in de Git database opgeslagen. Ze worden gechecksummed, bevatten de naam van de tagger, e-mail en datum, hebben een tag boodschap, en kunnen gesigneerd en geverifieerd worden met GNU Privacy Guard (GPG). Het wordt over het algemeen aangeraden om annotated tags te maken zodat je deze informatie hebt; maar als je een tijdelijke tag wilt of om een of andere reden de andere informatie niet wilt houden, dan zijn er ook lichtgewicht tags.

### Annotated tags ###

Een annotated tag in Git maken is eenvoudig. Het makkelijkst is om de `-a` optie te specificeren als je het `tag` commando uitvoert:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

De `-m` specificeert een tag boodschap, die bij de tag opgeslagen wordt. Als je geen boodschap voor een beschreven tag opgeeft, dan opent Git je editor zodat je hem in kunt typen.

Je kunt de tag data zien, samen met de commit die getagged was, door het `git show` commando te gebruiken:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Dat toont de tagger informatie, de datum waarop de commit getagged was, en de beschrijvende boodschap alvorens de commit boodschap te laten zien.

### Ondertekende tags ###

Je kunt je tags ook ondertekenen met GPG, aangenomen dat je een privésleutel hebt. Het enige dat je moet doen is de `-s` optie gebruiken in plaats van de `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Als je `git show` op die tag uitvoert, dan kun je jouw GPG handtekening eraan vast zien zitten:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Verderop zul je leren hoe je ondertekende tags kunt verifiëren.

### Lightweight tags ###

Een andere manier om een tag te committen is met behulp van een lightweight tag. Dit is in principe de commit checksum in een bestand opgeslagen; er wordt geen andere informatie bijgehouden. Om een lightweight tag te maken voeg je niet de `-a`, `-s` noch de `-m` optie toe:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Als je deze keer `git show` op de tag doet, zie je niet de extra tag informatie. Het commando toont alleen de commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Tags verifiëren ###

Om een ondertekende tag te verifiëren, gebruik je `git tag -v [tag-naam]`. Dit commando gebruikt GPG om de handtekening te verifiëren. Je moet de publieke sleutel van degene die getekend heeft wel in je sleutelbos hebben staan om het goed te laten werken:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

Als je de publieke sleutel van degene die getekend heeft niet hebt, dan krijg je in plaats daarvan zoiets:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Later taggen ###

Je kunt ook commits taggen waar je al voorbij bent. Stel dat je commit historie er zo uitziet:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Stel nu dat je vergeten bent het project op v1.2 te taggen, daar waar de "updated rakefile" commit was. Je kunt dit nadien toevoegen. Om die commit te taggen, specificeer je de commit boodschap (of een gedeelte daarvan) aan het einde van het commando:

	$ git tag -a v1.2 9fceb02

Je kunt zien dat je de commit getagged hebt:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Tags delen ###

Standaard zal het `git push` commando geen tags naar remote servers versturen. Je zult expliciet tags naar een gedeelde server moeten pushen, nadat je ze gemaakt hebt. Dit proces is hetzelfde als remote branches delen — je kunt `git push origin [tagnaam]` uitvoeren.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Als je veel tags hebt die je ineens wilt pushen, kun je ook de `--tags` optie aan het `git push` commando toevoegen. Dit zal al je tags, die nog niet op de remote server zijn, in één keer er naartoe sturen.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Als nu iemand anders van jouw repository clonet of pullt, dan zullen zij al jouw tags ook krijgen.

## Tips en trucs ##

Voordat we dit hoofdstuk over de basis van Git afsluiten laten we je nog wat kleine tips en trucs zien die je Git ervaring een beetje eenvoudiger, makkelijker of bekender maken. Veel mensen gebruiken Git zonder deze tips, en we refereren er niet meer aan of gaan er niet vanuit dat je ze gebruikt verderop in dit boek; maar je zult waarschijnlijk willen weten hoe je ze moet doen.

### Auto-aanvulling ###

Als je de Bash shell gebruikt, heeft Git een prettige auto-aanvulling script dat je aan kunt zetten. Download het direct van de Git broncode op https://github.com/git/git/blob/master/contrib/completion/git-completion.bash. Kopieer dit bestand naar je home directory, en voeg dit aan je `.bashrc` bestand toe:

	source ~/.git-completion.bash

Als je Git wilt instellen dat het automatische Bash shell aanvulling heeft voor alle gebruikers, kopieer dit script dan naar de `/opt/local/etc/bash_completion.d` directory op Mac systemen, of naar de `/etc/bash_completion.d/` directory op Linux systemen. Dit is een directory met scripts dat Bash automatisch zal laden om shell aanvullingen aan te bieden.

Als je Windows gebruikt met Git Bash, wat de standaard is als je Git op Windows installeert met msysGit, dan zou auto-aanvulling voorgeconfigureerd moeten zijn.

Druk de Tab toets als je een Git commando aan het typen bent, en het zou een lijstje suggesties voor je moeten teruggeven:

	$ git co<tab><tab>
	commit config

In dit geval zal `git co` en dan de Tab toets twee keer indrukken git commit en config voorstellen. Als je daarna `m<tab>` toevoegt, wordt het automatisch tot `git commit` gecompleteerd.

Dit werkt ook met opties, wat nog bruikbaarder is. Bijvoorbeeld, als je een `git log` commando uitvoert en je een van de opties niet meer kunt herinneren, dan kun je beginnen met het te typen en Tab indrukken om te zien wat er past:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Dat is een erg handig trucje en zal je misschien wat tijd en documentatie lezen besparen.

### Git aliassen ###

Git zal geen commando's afleiden uit wat je gedeeltelijk intypt. Als je niet de hele tekst van ieder Git commando wilt intypen, kun je gemakkelijk een alias voor ieder commando configureren door `git config` te gebruiken. Hier zijn een aantal voorbeelden die je misschien wilt instellen:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Dit betekent dat je, bijvoorbeeld, in plaats van `git commit` je alleen `git ci` hoeft in te typen. Als je verder gaat met Git, zul je waarschijnlijk andere commando's ook vaker gaan gebruiken; in dat geval: schroom niet om nieuwe aliassen te maken.

Deze techniek kan ook makkelijk zijn om commando's te maken waarvan je vindt dat ze zouden moeten bestaan. Bijvoorbeeld, om het bruikbaarheidsprobleem wat je met het unstagen van een bestand tegenkwam op te lossen, kun je jouw eigen unstage alias aan Git toevoegen:

	$ git config --global alias.unstage 'reset HEAD --'

Dit maakt de volgende twee commando's equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

Het lijkt wat duidelijker. Het is ook gebruikelijk om een `last` commando toe te voegen:

	$ git config --global alias.last 'log -1 HEAD'

Op deze manier kun je de laatste commit makkelijk zien:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Zoals je kunt zien, vervangt Git eenvoudigweg het nieuwe commando met hetgeen waarvoor je het gealiassed hebt. Maar, misschien wil je een extern commando uitvoeren, in plaats van een Git subcommando. In dat geval begin je het commando met een `!` karakter. Dit is handig als je je eigen applicaties maakt die met een Git repository werken. We kunnen dit demonstreren door `git visual` een `gitk` te laten uitvoeren:

	$ git config --global alias.visual '!gitk'

## Samenvatting ##

Op dit punt kun je alle basis locale Git operaties doen: een repository creëren of clonen, wijzigingen maken, de wijzigingen stagen en committen en de historie bekijken van alle veranderingen die de repository ondergaan heeft. Als volgende gaan we de beste eigenschap van Git bekijken: het branching model.
