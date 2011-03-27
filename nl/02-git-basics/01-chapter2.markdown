# De Basis van Git #

Als je slechts één hoofdstuk kunt lezen om met Git aan de slag te gaan, dan is dit het. Dit hoofdstuk behandelt elk van de basiscommando's, die je nodig hebt om het leeuwendeel van de dingen te doen waarmee je uiteindelijk je tijd met Git zult doorbrengen. Als je dit hoofdstuk doorgenomen hebt, zul je een repository kunnen configureren en initialiseren, bestanden beginnen en stoppen te volgen en veranderingen te ‘stagen’ en ‘committen’. We laten ook zien hoe je Git kunt instellen zodat het bepaalde bestanden en bestandspatronen negeert, hoe je vergissingen snel en gemakkelijk ongedaan kunt maken, hoe je de geschiedenis van je project kan doorlopen en wijzigingen tussen commits kunt zien, en hoe je kan pushen en pullen van en naar andere repositories.

## Een Git Repository Verkrijgen ##

Je kunt op twee manieren een Git project verkrijgen. De eerste maakt gebruik van een bestaand project of map en importeert dit in Git. De tweede maakt een clone van een bestaande Git repository op een andere server.

### Een Repository Initialiseren In Een Bestaande Map ###

Als je een bestaand project in Git wilt volgen (track), dan moet je naar de projectmap gaan en het volgende typen

	$ git init

Dit maakt een nieuwe submap aan genaamd .git, die alle noodzakelijke repository bestanden bevat – een Git repository skelet. Op dit punt wordt nog niets in je project gevolgd. (Zie Hoofdstuk 9 voor meer informatie over welke bestanden er precies in de `.git` map staan, die je zojuist gemaakt hebt.)

Als je bestaande bestanden wilt gaan versie-beheren (in plaats van een lege map), dan zul je waarschijnlijk die bestanden beginnen te volgen en een eerste commit willen doen. Dit kun je bereiken door een paar git add commando's die de te volgen bestanden specificeren, gevolgd door een commit:

	$ git add *.c
	$ git add README
	$ git commit –m 'initial project version'

We zullen zodadelijk beschrijven wat deze commando's doen. Op dit punt heb je een Git repository met gevolgde (tracked) bestanden en een eerste commit.

### Een Bestaand Repository Clonen ###

Als je een kopie wilt van een bestaande Git repository — bijvoorbeeld een project waaraan je wilt bijdragen — dan is het `git clone` commando wat je nodig hebt. Als je bekend bent met andere versie-beheersystemen zoals Subversion, dan valt je op dat het commando 'clone' is en niet 'checkout'. Dit is een belangrijk verschil — Git ontvangt een kopie van bijna alle data die de server heeft. Iedere versie van ieder bestand van de hele geschiedenis van een project wordt binnengehaald als je `git clone` doet. In feite kun je, als je disk kapot gaat, iedere clone van iedere client gebruiken om de server terug in de status te brengen op het moment van clonen (al zou je wel wat hooks en dergelijke verliezen, maar alle versies van alle bestanden zouden er zijn-zie Hoofdstuk 4 voor meer informatie).

Je cloned een repository met `git clone [url]`. Bijvoorbeeld, als je de Ruby Git bibliotheek genaamd Grit wilt clonen, kun je dit als volgt doen:

	$ git clone git://github.com/schacon/grit.git

Dat maakt een map genaamd "grit" aan, initialiseert hierin een `.git` map, haalt alle data voor dat repository binnen, en doet een checkout van een werkkopie van de laatste versie. Als je in de nieuwe `grit` map gaat, zul je de project bestanden vinden, klaar om gebruikt of aan gewerkt te worden. Als je de repository in een map met een andere naam dan grit wilt clonen, dan kun je dit met de volgend commando regel specificeren:

	$ git clone git://github.com/schacon/grit.git mygrit

Dat commando doet hetzelfde als het vorige, maar dan heet de doelmap mygrit.

Git heeft een aantal verschillende transport protocollen die je kunt gebruiken. Het vorige voorbeeld maakt gebruik van het `git://` protocol, maar je kunt ook `http(s)://` of `gebruiker@server:/pad.git` tegenkomen, dat het SSH transport protocol gebruikt. Hoofdstuk 4 zal alle beschikbare opties die de server kan gebruiken om je Git repository aan te kunnen, met daarbij de voors en tegens van elk.

## Wijzigingen Aan Het Repository Vastleggen ##

Je hebt een bona fide Git repository en een checkout of werkkopie van de bestanden voor dat project. Je moet wat wijzigingen maken en deze committen in je repository, iedere keer zodra het project een status bereikt die je wilt vastleggen.

Onthoud dat ieder bestand in je werkmap in twee statussen kan verkeren: gevolgd (tracked) of niet gevolgd (untracked). Gevolgde bestanden zijn bestanden die in het laatste snapshot zaten; ze kunnen ongewijzigd, gewijzigd of staged zijn. Niet gevolgde bestanden zijn al het andere - ieder bestand in je werkmap dat niet in je laatste snapshot en niet in je staging gebied zit. Als je voor het eerst een repository cloned, zullen al je bestanden gevolgd en ongewijzigd zijn, omdat je ze zojuist ge-checkout en niet gewijzigd hebt.

Zodra je bestanden wijzigt, ziet Git ze als gewijzigd omdat je ze veranderd hebt sinds je laatste commit. Je staged deze gewijzigde bestanden en commit al je ge-stagede wijzigingen, en de cyclus herhaalt zichzelf. Deze cyclus wordt in Figuur 2-1 geïllusteerd.

Insert 18333fig0201.png 
Figuur 2-1. De levenscyclus van de status van je bestanden.

### De Status Van Je Bestanden Controleren ###

Het hoofdcommando dat je zult gebruiken om te bepalen welk bestand zich in welke status bevindt is git status. Als je dit commando direct na een clone uitvoert, dan zul je zoiets als het volgende zien:

	$ git status
	# On branch master
	nothing to commit (working directory clean)

Dit betekent dat je een schone werkmap hebt-met andere woorden, er zijn geen gevolgde en gewijzigde bestanden. Git ziet ook geen ongevolgde bestanden, anders zouden ze hier getoond worden. Als laatste vertelt het commando op welke tak (branch) je nu zit. Voor nu is dit altijd de master, dat is de standaard; maak je je hier nog niet druk om. Het volgende hoofdstuk gaat in detail over takken en referenties.

Stel dat je een nieuw bestand toevoegt aan je project, en simpel README bestand. Als het bestand voorheen nog niet bestond, en je doet `git status`, dan zul je je ongevolgde bestand zo zien:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Je kunt zien dat je nieuwe README bestand ongevolgd is, omdat het onder de “Untracked files” kop staat in je status output. Ongevolgd betekent eigenlijk dat Git een bestand ziet dat je niet in het vorige snapshot (commit) had; Git zal het niet in je commit snapshots toevoegen totdat jij haar er expliciet om vraagt. Ze doet dit zodat jij niet per ongeluk gegenereerde binaire bestanden toevoegt, of andere bestanden die je niet wou toevoegen. Je wilt dit README bestand wel toevoegen, dus laten we het gaan volgen.

### Nieuwe Bestanden Volgen (Tracking) ###

Om een nieuw bestand te beginnen te volgen, gebruik je het commando `git add`. Om de README te volgen, kun je dit uitvoeren:

	$ git add README

Als je je status commando nogmaals uitvoert, zie je dat je README bestand nu gevolgd en ge-staged is:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Je kunt zien dat het ge-staged is, omdat het onder de kop “Changes to be committed” staat. Als je op dit punt een commit doet, zal de versie van het bestand zoals het wat ten tijde van je `git add` commando in de historische snapshot toegevoegd worden. Je zult je misschien herinneren dat, toen je `git init` eerder uitvoerde, je daarna `git add` (bestanden) uitvoerde — dat was om bestanden in je map te beginnen te volgen. Het `git add` commando neemt een padnaam voor een bestand of een map; als het een map is, dan voegt het commando alle bestanden in die map recursief toe.

### Gewijzigde Bestanden Stagen ###

Laten we een gevolgd bestand wijzigen. Als je een voorheen gewijzigd bestand genaamd `benchmarks.rb` wijzigt, en dan je `status` commando nog eens uitvoert, krijg je iets dat er zo uitziet:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Het benchmarks.rb bestand verschijnt onder een sectie genaamd “Changed but not updated” — wat betekent dat een bestand dat gevolgd wordt gewijzigd is in de werkmap, maar nog niet ge-staged. Om het te stagen, voer je het `git add` commando uit (het is een veelzijdig commando — je gebruikt het om bestanden te volgen, om bestanden te stagen, en andere dingen zoals een bestand met een mergeconflict als opgelost te markeren). Laten we `git add` nu uitvoeren om het benchmarks.rb bestand nu te stagen, en dan nog eens `git status`:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Beide bestanden zijn ge-staged en zullen in je volgende commit gaan. Stel dat je je op dit punt herinnert dat je een kleine wijziging in benchmarks.rb wil maken voor je volgende commit. Je kunt het opnieuw openen en die wijziging maken, en dan ben je klaar voor de commit. Maar, laten we `git status` nog een keer uitvoeren:

	$ vim benchmarks.rb 
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Hé! Nu staat benchmarks.rb zowel bij de staged en unstaged. Hoe kan dat? Het blijkt dat Git een bestand staged precies zoals het is wanneer je het `git add` commando uitvoert. Als je nu commit, dan zal de versie van benchmarks.rb zoals het was toen je voor 't laatst `git add` uitvoerde worden toegevoegd in de commit, en niet de versie van het bestand zoals ie eruit ziet in je map wanneer je git commit uitvoert. Als je een bestand wijzigt nadat je `git add` uitvoert, dan moet je `git add` nogmaals uitvoeren om de laatste versie van het bestand te stagen:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Bestanden Negeren ###

Vaak zul je een klasse bestanden hebben waarvan je niet wilt dat Git deze automatisch toevoegt of zelfs maar als ongevolgd toont. Dit zijn doorgaans automatisch gegenereerde bestanden zoals logbestanden of bestanden die geproduceerd worden door je bouwsysteem. In die gevallen kun je een bestand genaamd .gitignore maken, waarin patronen staan die die bestanden passen. Hier is een voorbeeld .gitignore bestand:

	$ cat .gitignore
	*.[oa]
	*~

De eerste regel verteld Git om ieder bestand dat eindigt op een .o of .a – object en archief bestanden die het product kunnen zijn van het bouwen van je code. De tweede regel vertelt Git dat ze alle bestanden die eindigen op een tilde (`~`), wat gebruikt wordt door editors zoals Emacs om tijdelijke bestanden te markeren, mag negeren. Je mag ook log, tmp of een pid map toevoegen, automatisch gegenereerde documentatie, enzovoort. Een .gitignore bestand aanmaken voordat je gaat beginnen is over 't algemeen een goed idee, zodat je niet per ongeluk bestanden commit die je echt niet in je repository wilt hebben.

De regels voor patronen die je in het .gitignore bestand kunt zetten zijn als volgt:

*	Lege regels of regels die beginnen met een # worden genegeerd.
*	Standaard expansie patronen werken.
*	Je mag patronen laten eindigen op een slash (`\`) om een map te specificeren.
*	Je mag een patroon ontkennend maken door het te laten beginnen met een uitroepteken (`!`).

Expansie (`glob`) patronen zijn vereenvoudigde reguliere expressies die shell omgevingen gebruiken. Een asterisk (`*`) komt overeen met nul of meer karakters; `[abc]` komt overeen met ieder karakter dat tussen de blokhaken staat (in dit geval a, b of c); een vraagteken (`?`) komt overeen met een enkel karakter, en blokhaken waar tussen karakters staan die gescheiden zijn door een streepje (`[0-9]`) komen overeen met ieder karakter wat tussen die karakters zit (in dit geval 0 tot en met 9).

Hier is nog een voorbeeld van een .gitignore bestand:

	# a comment – this is ignored
	*.a       # no .a files
	!lib.a    # but do track lib.a, even though you're ignoring .a files above
	/TODO     # only ignore the root TODO file, not subdir/TODO
	build/    # ignore all files in the build/ directory
	doc/*.txt # ignore doc/notes.txt, but not doc/server/arch.txt

### Je Staged En Unstaged Wijzigigen Zien ###

Als het `git status` commando te vaag is voor je – je wilt precies weten wat je veranderd hebt, niet alleen welke bestanden veranderd zijn – dan kun je het `git diff` commando gebruiken. We zullen `git diff` later in meer detail bespreken; maar je zult het het meest gebruiken om deze twee vragen te beantwoorden: Wat heb je veranderd maar nog niet gestaged? En wat heb je gestaged en sta je op het punt te committen? Alhoewel `git status` deze vragen heel algemeen beantwoordt, laat `git diff` je de exacte toegevoegde en verwijderde regels zien – de patch, als het ware.

Stel dat je het README bestand opnieuw verandert en staged, en dan het benchmarks.rb bestand verandert zonder het te stagen. Als je je `status` commando uitvoert, dan zie je nogmaals zoiets als dit:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

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

Dat commando vergelijkt wat er in je werkmap zit met wat er in je staging gebied zit. Het resultaat laat je zien welke wijzigingen je gedaan hebt, die je nog niet gestaged hebt.

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

Het is belangrijk om te zien dat `git diff` zelf niet alle wijzigingen sinds je laatste commit laat zien – alleen wijzigingen die nog niet gestaged zijn. Dit kan verwarrend zijn, omdat als je al je wijzigingen gestaged hebt, `git diff` geen output zal geven.

Nog een voorbeeld. Als je het benchmarks.rb bestand staged, en vervolgens verandert, dan kun je `git diff` gebruiken om de wijzigingen in het bestand te zien dat gestaged is en de wijzigingen die niet gestaged zijn:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#

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

### Je Wijzigingen Committen ###

Nu dat je staging gebied ingesteld is op de manier zoals jij het wilt, kun je je wijzigingen committen.  Onthoud dat alles wat niet gestaged is – ieder bestand dat je gemaakt of gewijzigd hebt en waarop je nog geen `git add` op uitgevoerd hebt – niet in deze commit mee zal gaan. Ze zullen als gewijzigde bestanden op je disk blijven staan.
In dit geval zag je de laatste keer dat je `git status` uitvoerde, dat alles gestaged was. Dus je bent er klaar voor om je wijzigingen te committen. De makkelijkste manier om te committen is om `git commit` in te typen:

	$ git commit

Dit start de door jou gekozen editor op. (Dit wordt bepaald door de `$EDITOR` omgevings variabele in je shell – meestal vim of emacs, alhoewel je dit kunt instellen op welke je ook wilt gebruiken met het `git config --global core.editor` commando zoals je in Hoofdstuk 1 gezien hebt).

De editor laat de volgende tekst zien (dit voorbeeld is een Vim scherm):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb 
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Je kunt zien dat de standaard commit boodschap de laatste output van het `git status` commando in commentaar bevat en een lege regel bovenaan. Je kunt deze commentaren verwijderen en je eigen commit boodschap intypen, of je kunt ze laten staan om je eraan te helpen herinneren wat je aan het committen bent. (Om een meer expliciete herinnering van je wijzigingen te zien kun je de `-v` optie meegeven aan `git commit`. Als je dit doet zet git de diff van je verandering in je editor zodat je precies kunt zien wat je gedaan hebt.) Als je de editor verlaat, crëeert Git je commit boodschap (zonder de commentaren of de diff).

Als alternatief kun je je commit boodschap met het `commit` commando meegeven door hem achter de -m optie te specificeren, zoals hier:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Nu heb je je eerste commit gemaakt! Je kunt zien dat de commit je wat output over zichzelf heeft gegeven: op welke branch je gecommit hebt (master), welke SHA-1 checksum de commit heeft (`463dc4f`), hoeveel bestanden er veranderd zijn, en statistieken over toegevoegde en verwijderde regels in de commit.

Onthoud dat de commit de snapshot, die je in je staging gebied ingesteld hebt, opslaat. Alles wat je niet gestaged hebt staat daar nog steeds gewijzigd; je kunt een volgende commit doen om het aan je geschiedenis toe te voegen. Iedere keer dat je een commit doet, leg je een snapshot van je project vast dat je later terug kunt draaien of mee kunt vergelijken.

### Het Staging Gebied overslaan ###

Alhoewel het ontzettend makkelijk kan zijn om commits precies zoals je wilt te maken, is het staging gebied soms iets ingewikkelder dan je in je manier van werken nodig hebt. Als je het staging gebied wilt overslaan, dan biedt Git een makkelijke route binnendoor. Door de `-a` optie aan het `git commit` commando mee te geven, zal Git automatisch ieder bestand dat al getracked wordt voor de commit stagen, zodat je het `git add` gedeelte kunt overslaan:

	$ git status
	# On branch master
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Let op dat je nu geen `git add` op het benchmarks.rb bestand hoeft te doen voordat je commit.

### Bestanden Verwijderen ###

Om een bestand van Git te verwijderen, moet je het van de tracked bestanden verwijderen (om precies te zijn, verwijderen van je staging gebied) en dan een commit doen. Het `git rm` commando doet dat, en verwijdert het bestand ook van je werkmap zodat je het de volgende keer niet als een untracked bestand ziet.

Als je het bestand simpelweg verwijdert uit je werkmap, zal het te zien zijn onder het "Changed but not updated" (dat wil zeggen, _unstaged_) gedeelte van je `git status` output:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Als je daarna `git rm` uitvoert, zal de verwijdering van het bestand gestaged worden:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

Als je de volgende keer een commit doet, zal het bestand verdwenen zijn en niet meer getracked worden. Als je het bestand veranderd hebt en al aan de index toegevoegd hebt, dan zul je de verwijdering moeten forceren met de `-f` optie. Dit is een veiligheids maatregel om te voorkomen dat je per ongeluk data die nog niet in een snapshot zit, en dus niet teruggehaald kan worden uit Git, weggooit.

Een ander handigheidje wat je misschien wilt doen is het bestand in je werkmap houden, maar van je staging gebied verwijderen. Met andere woorden, je wilt het bestand misschien op je harde schijf bewaren, maar niet dat Git het bestand nog tracked. Dit is erg handig als je iets vergeten bent aan je `.gitignore` bestand toe te voegen, en het per ongeluk toegevoegd hebt. Zoals een groot logbestand, of een serie `.a` gecompileerde bestanden. Gebruik de `--cached` optie om dit te doen:

	$ git rm --cached readme.txt

Je kunt bestanden, mappen en bestandspatronen aan het `git rm` commando meegeven. Dat betekent dat je zoiets als dit kunt doen

	$ git rm log/\*.log

Let op de backslash (`\`) voor de `*`. Dit is nodig omdat Git zijn eigen bestandsnaam expansie doet, naast die van je shell. Dit commando verwijdert alle bestanden die de `.log` extensie hebben in de `log/` map. Of, je kunt zoiets als dit doen:

	$ git rm \*~

Dit commando verwijderd alle bestanden die eindigen met `~`.

### Bestanden Verplaatsen ###

Anders dan vele andere VCS systemen, traceert Git niet expliciete verplaatsingen van bestanden. Als je een bestand een nieuwe naam geeft in Git, is er geen metadata opgeslagen in Git die vertelt dat je het bestand hernoemd hebt. Maar, Git is slim genoeg om dit alsnog te zien – we zullen bestandsverplaatsing detectie wat later behandelen.

Het is daarom een beetje verwarrend dat Git een `mv` commando heeft. Als je een bestand wilt hernoemen in Git, kun je zoiets als dit doen

	$ git mv file_from file_to

en dat werkt prima. Sterker nog, als je zoiets als dit uitvoert en naar de status kijkt, zul je zien dat Git het als een hernoemd bestand beschouwt:

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

Maar, dat is gelijk aan het volgende uitvoeren:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git komt er impliciet achter dat het om een hernoemd bestand gaat, dus het maakt niet uit of je een bestand op deze manier hernoemt of met het `mv` commando. Het enige echte verschil is dat het `mv` commando slechts één commando is in plaats van drie. En belangrijker nog is dat je iedere applicatie kunt gebruiken om een bestand te hernoemen, en de add/rm later kunt behandelen, voordat je commit.

## De Commit Geschiedenis Bekijken ##

Nadat je een aantal commits gecrëeerd hebt, of als je een repository met een bestaande commit geschiedenis gecloned hebt, zul je waarschijnlijk terug willen zien wat er gebeurd is. Het meest basale en krachtige tool om dit te doen is het `git log` commando.

Deze voorbeelden maken gebruik van een eenvoudig project genaamd simplegit dat ik vaak voor demonstraties gebruikt. Om het project te halen, voer dit uit

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

Zonder argumenten toont `git log` de commits die gedaan zijn in dat repository, in omgekeerde chronologische volgorde. Dat wil zeggen, de meest recente commits worden als eerste getoond. Zoals je kunt zien, toont dit commando iedere commit met zijn SHA-1 checksum, de naam van de maker en zijn e-mail, de datum van opslaan, en de commit boodschap.

Een gigantisch aantal en varieteit aan opties zijn op het `git log` commando beschikbaar om je precies te laten zien waar je naar op zoek bent. Hier laten we je de meest gebruikte opties zien.

Een van de meest behulpzame opties is `-p`, wat de diff laat zien van de dingen die in iedere commit geintroduceerd zijn. Je kunt ook `-2` gebruiken, om alleen de laatste twee items te laten zien:

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

Deze optie toont dezelfde informatie, maar dan met een diff volgend op ieder item. Dit is erg handig voor een code review, of om snel te zien wat er tijdens een serie commits gebeurd is die een medewerker toegevoegd heeft.
Je kunt ook een serie samenvattende opties met `git log` gebruiken. Bijvoorbeeld, als je wat verkorte statistieken bij iedere commit wilt zien, kun je de `--stat` optie gebruiken:

	$ git log --stat 
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

Zoals je ziet, drukt de `--stat` optie onder iedere commit een lijst gewijzigde bestanden af, hoeveel bestanden gewijzigd zijn, en hoeveel regels in die bestanden zijn toegevoegd en verwijderd. Het toont ook een samenvatting van de informatie aan het einde.
Een andere handige optie is `--pretty`. Deze optie veranderd de log output naar een ander formaat dan de standaard. Er zijn al een paar voorgebouwde opties voor je beschikbaar. De oneline optie drukt iedere commit op een enkele regel af, wat handig is als je naar een hoop commits kijkt. Daarnaast tonen de `short`, `full` en `fuller` optie de output in grofweg hetzelfde formaat, maar met minder of meer informatie, respektievelijk: 

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

De meest interessante optie is `format`, waarmee je je eigen log formaat kunt specificeren. Dit is in het bijzonder handig als je output aan het genereren bent voor een tool – omdat je expliciet het formaat kan specificeren, weet je dat het niet zal veranderen bij volgende versies van Git:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tabel 2-1 toont een aantal handige opties die aan format gegeven kunnen worden.

	Optie	Omschrijving van de Output
	%H	Commit hash
	%h	Afgekorte commit hash
	%T	Tree hash
	%t	Afgekorte tree hash
	%P	Parent hashes
	%p	Afgekorte parent hashes
	%an	Auteur naam
	%ae	Auteur e-mail
	%ad	Auteur datum (formaat respecteerd de –date= optie)
	%ar	Auteur datum, relatief
	%cn	Committer naam
	%ce	Committer e-mail
	%cd	Committer datum
	%cr	Committer datum, relatief
	%s	Onderwerp

Je zult je misschien afvragen wat het verschil is tussen _author_ en _committer_. De auteur is de persoon die het werk oorspronkelijk geschreven heeft, en de committer is de persoon die het werk als laatste toegevoegd heeft. Dus als je een patch naar een project stuurt en een van de leden voegt de patch toe, dan krijgen jullie beiden de eer – jij als de auteur en het kernlid als de committer. We gaan hier wat verder op in in Hoofdstuk 5.

De oneline en format opties zijn erg handig in combinatie met een andere `log` optie genaamd `--graph`. Deze optie maakt een mooie ASCII grafiek waarin je branch en merge geschiedenis getoond worden, die we kunnen zien in onze kopie van de Grite repository:

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

Dat zijn slechts een paar simpele output formaat opties voor `git log` – er zijn er nog veel meer. Tabel 2-2 toont de opties waarover we het tot nog toe gehad hebben, en wat veel voorkomende formaat opties die je misschien handig vindt, samen met hoe ze de output van het log commando veranderen.

	Optie	Omschrijving
	-p	Toon de patch geintroduceerd bij iedere commit.
	--stat	Toon statistieken voor gewijzigde bestanden in iedere commit.
	--shortstat	Toon alleen de gewijzigde/ingevoegde/verwijderde regel van het --stat commando.
	--name-only	Toon de lijst van bestanden die gewijzigd zijn na de commit informatie.
	--name-status	Toon ook de lijst van bestanden die beinvloed zijn door de toegevoegde/gewijzigde/verwijderde informatie.
	--abbrev-commit	Toon alleen de eerste paar karakteres van de SHA-1 checksum in plaats van alle 40.
	--relative-date	Display the date in a relative format (for example, “2 weeks ago”) instead of using the full date format.
	--graph	Display Een ASCII grafiek van de branch en merge geschiedenis naast de the log output.
	--pretty	Toon commits in een alternatief formaat. De opties bevatten oneline, short, full, fuller, en format (waarbij je je eigen formaat specificeert).

### Log Output Limiteren ###

Naast het formateren van de output, heeft git log nog een aantal bruikbare limiterende opties – dat wil zeggen, opties die je een subset van de commits tonen. Je hebt zo'n optie al gezien – de `-2` optie, die slechts de laatste twee commits laat zien. In feite kun je `-<n>` doen, waarbij `n` ieder heel getal is wat de laatste `n` commits laat zien. In feite zul je deze vorm weinig gebruiken, omdat Git standaard alle output door een pager (pagineer applicatie) stuurt zodat je één pagina log output per keer ziet.

Maar, de tijd limiterende opties zoals `--since` en `--until` zijn erg handig. Dit commando bijvoorbeeld, geeft een lijst met commits die gedaan zijn gedurende de laatste twee weken:

	$ git log --since=2.weeks

Dit commando werkt met veel formaten – je kunt een specifieke datum kiezen ("2008-01-15”) of een relatieve datum zoals "2 jaar 1 dag en 3 minuten geleden".

Je kunt ook de lijst met commits filteren op bepaalde criteria. De `--author` optie laat je filteren op een specifieke auteur, en de `--grep` optie laat je op bepaalde zoekwoorden filteren in de commit boodschappen. (Let op dat als je zowel auteur als grep opties wilt specificeren, je `--all-match` moet toevoegen of anders zal het commando beiden matchen.)

De laatste echt handige optie om aan `git log` als filter mee te geven is een pad. Als je een map of bestandsnaam opgeeft, kun je de log output limiteren tot commits die een verandering introduceren op die bestanden. Dit is altijd de laatste optie en wordt over het algemeen vooraf gegaan door dubbele streepjes (`--`) om de paden van de opties te scheiden.

In Tabel 2-3 laten we deze en een paar andere veel voorkomende opties zien als referentie.

	Optie	Omschrijving
	-(n)	Laat alleen de laatste n commits zien
	--since, --after	Limiteer de commits tot degenen na de gegeven datum.
	--until, --before	Limiteer de commits tot degenen voor de gegeven datum.
	--author	Laat alleen de commits zien waarvan de auteur bij de gegeven tekst past.
	--committer	Laat alleen de commits zien waarvan de committer bij de gegeven tekst past.

Bijvoorbeeld, als je wilt zien welke commits test bestanden in de Git broncode geschiedenis aanpasten waarvan de committer Junio Hamano is en die niet in de maand oktober van 2008 gemerged zijn, kun je zoiets als dit uitvoeren:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Van de bijna 20.000 commits in de Git broncode historie, laat dit commando de 6 zien die bij die criteria passen.

### Een Grafische Interface Gebruiken Om De Historie Te Visualiseren ###

Als je een meer grafische applicatie wilt gebruiken om je commit historie te visualiseren, wil je misschien een kijkje nemen naar het Tcl/Tk programma genaamd gitk dat met Git meegeleverd wordt. Gitk is eigenlijk een visuele `git log`, en het accepteerd bijna alle filter opties die `git log` ook accepteerd. Als je gitk in de shell in je project typed, zou je zoiets als in Figuur 2-2 moeten zien.

Insert 18333fig0202.png 
Figuur 2-2. De gitk historie visualiseerder.

Je kunt de commit historie in de bovenste helft van het scherm zien, samen met een afkomst graaf. De diff in de onderste helft van het scherm laat je de veranderingen zien die bij iedere commit die je aanklikt geintroduceerd zijn.

## Dingen Ongedaan Maken ##

Op enig moment wil je misschien iets ongedaan maken. Hier zullen we een aantal basis toepassingen laten zien om veranderingen die je gemaakt hebt weer ongedaan te maken. Let op, je kunt niet altijd het ongedaan maken weer ongedaan maken. Dit is één van de weinige gedeeltes in Git waarbij je werk kwijt kunt raken als je het verkeerd doet.

### Je Laatste Commit Veranderen ###

Een van de veel voorkomende ongedaan maak acties vindt plaats als je te vroeg commit en misschien vergeet een aantal bestanden toe te voegen, of je verknalt je commit boodschap. Als je opnieuw wilt proberen te committen, dan kun je commit met de `--amend` optie uitvoeren:

	$ git commit --amend

Dit commando neemt je staging gebied en gebruikt dit voor de commit. Als je geen veranderingen sinds je laatste commit hebt gedaan (bijvoorbeeld, je voert dit commando meteen na je laatste commit uit), dan zal je snapshot er precies hetzelfde uitzien en zal je commit boodschap het enige zijn dat je verandert.

Dezelfde commit-boodschap editor start op, maar het bevat meteen de boodschap van je vorige commit. Je kunt de boodschap net als andere keren aanpassen, maar het overschrijft je vorige commit.

Als voorbeeld, als je commit en je dan realiseert dat je vergeten bent de veranderingen in een bestand dat je wou toevoegen in deze commit te stagen, dan kun je zoiets als dit doen:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

Alledrie van deze commando's eindigen met één commit – de tweede commit vervangt de resultaten van de eerste.

### Een Staged Bestand Unstagen ###

De volgende twee paragrafen laten zien hoe je je staging gebied en veranderingen in je werkmappen aanpakt. Het leuke gedeelte is dat het commando dat je gebruikt om de status van die gebieden te bepalen, je ook herinnert hoe je de veranderingen eraan ongedaan kunt maken. Bijvoorbeeld, stel dat je twee bestanden gewijzigd hebt en je wilt ze committen als twee aparte veranderingen, maar je typed per ongeluk `git add *` en staged ze allebei. Hoe kun je één van de twee nu unstagen? Het `git status` commando herinnert je eraan:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Recht onder de "Changes to be committed" tekst, staat dat je `git reset HEAD <bestand>...` moet gebruiken om te unstagen. Laten we dat advies volgen om het benchmarks.rb bestand te unstagen:

	$ git reset HEAD benchmarks.rb 
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Het commando is een beetje vreemd, maar het werkt. Het benchmarks.rb bestand is gewijzigd maar weer ge-unstaged.

### Een Gewijzigd Bestand Ongedaan Maken ###

Wat als je je realiseert dat je je wijzigingen aan het benchmarks.rb bestand niet wilt houden? Hoe kun je dit makkelijk ongedaan maken – terug brengen in de staat waarin het was toen je voor het laatst gecommit hebt (of initieel gecloned, of hoe je het ook in je werkmap gekregen hebt)? Gelukkig vertelt `git status` je ook hoe je dat moet doen. In de laatse voorbeeld output, ziet het unstaged gebied er zo uit:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Het vertelt je behoorlijk expliciet hoe je je veranderingen moet weggooien (tenminste, de nieuwere versies van Git, 1.6.1 of nieuwer, doen dit – als je een oudere versie hebt, raden we je ten zeerste aan om het te upgraden zodat je een aantal van deze fijne bruikbaarheids opties krijgt). Laten we eens doen wat er staat:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Je kunt zien dat de veranderingen teruggedraaid zijn. Je moet je ook realiseren dat dit een gevaarlijk commando is: alle veranderingen die je aan dat bestand gedaan hebt zijn weg – je hebt er zojuist een ander bestand overheen gezet. Gebruik dit commando dan ook nooit, tenzij je heel zeker weet dat je het bestand niet wilt. Als je het alleen maar uit de weg wilt hebben, gebruik dan branching of stashing wat we behandelen in het volgende hoofdstuk; dit zijn vaak de betere opties.

Onthoud, alles dat in Git gecommit is kan bijna altijd weer hersteld worden. Zelfs commits die op reeds verwijderde branches gedaan zijn, of commits die zijn overschreven door een `--amend` commit, kunnen weer hersteld worden (zie Hoofdstuk 9 voor data herstel). Maar, alles wat je verliest dat nog nooit was gecommit is waarschijnlijk voor altijd verloren.

## Werken Met Remotes ##

Om samen te kunnen werken op ieder Git project, moet je weten hoe je je remote repositories moet beheren. Remote repositories zijn versies van je project, die worden beheerd op het Internet of ergens op een netwerk. Je kunt er meerdere hebben, waarvan ieder ofwel alleen leesbaar, of lees- en schrijfbaar is voor jou. Samenwerken met anderen houdt in dat je deze remote repositories kunt beheren en data kunt pushen en pullen op het moment dat je werk moet delen.
Remote repositories beheren houdt ook in hoe je ze moet toevoegen, ongeldige repositories moet verwijderen, meerdere remote branches moet beheren en ze als tracked of niet kunt definieren, en meer. In deze sectie zullen we deze remote-beheer vaardigheden behandelen.

### Laat Je Remotes Zien ###

Om te zien welke remote servers je geconfigureerd hebt, kun je het `git remote` commando uitvoeren. Het laat de verkorte namen van iedere remote alias zien die je gespecificeerd hebt. Als je je repository gecloned hebt, dan zul je op z'n minst de origin zien – dat is de standaard naam die Git aan de server geeft waarvan je gecloned hebt:

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote 
	origin

Je kunt ook `-v` specificeren, wat je de URL laat zien die Git bij de verkorte naam heeft opgeslagen om naar geexpandeerd te worden:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

Als je meer dan één remote hebt, dan laat het commande ze allemaal zien. Bijvoorbeeld, mijn Grit repository ziet er ongeveer zo uit.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Dit betekent dat we vrij gemakkelijk de bijdragen van ieder van deze gebruikers naar binnen kunnen pullen. Let op dat alleen de origin een SSH URL is, dus dat is de enige waar ik naartoe kan pushen (we laten het waarom zien in Hoofdstuk 4).

### Remote Repositories Toevoegen ###

Ik heb het toevoegen van remote repositories al genoemd en getoond in vorige secties, maar zo doe je het expliciet. Om een nieuw Git remote repository als een makkelijk te refereren alias toe te voegen, voer `git remote add [verkorte naam] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Nu kun je de naam pb in de shell gebruiken in plaats van de hele URL. Bijvoorbeeld, als je alle informatie die Paul wel, maar jij niet in je repository wilt fetchen, dan kun je git fetch pb uitvoeren:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul zijn master branch is lokaal toegankelijk als `pb/master` – je kunt het in een van jouw branches mergen, of je kunt een lokale branch uitchecken op dat punt als je het wil zien.

### Van Je Remotes Fetching En Pullen ###

Zoals je zojuist gezien hebt, kun je om data van je remote projecten te halen dit uitvoeren:

	$ git fetch [remote-name]

Het commando gaat naar het remote project en haalt alle data van dat remote project dat jij nog niet hebt. Nadat je dit gedaan hebt, zou je references (referenties) naar alle branches van dat remote moeten hebben, die je op ieder tijdstip kunt mergen en bekijken. (We zullen zien wat branches precies zijn, en hoe je ze moet gebruiken in meer detail in Hoofstuk 3.) 

Als je een repository cloned, voegt dat commando dat remote repository automatisch toe onder de naam origin. Dus `git fetch origin` fetched (haalt) ieder nieuw werk dat gepushed is naar die server sinds je gecloned hebt (of voor het laatst ge-fetched hebt). Het is belangrijk om te weten dat het fetch commando de data naar je locale repository haalt – het merged niet automatisch met je werk of verandert waar je momenteel aan zit te werken. Je kunt het handmatig in je werk mergen als je er klaar voor bent.

Als je een branch geconfigureerd hebt om een remote branch te tracken (volgen) (zie de volgende sectie en Hoofdstuk 3 voor meer informatie), dan kun je het `git pull` commando gebruiken om automatisch een remote branch te fetchen en mergen in je huidige branch. Dit kan makkelijker of meer comfortabel zijn voor je werkwijze; en standaard stelt het `git clone` commando je lokale master branch zo in dat het de remote master branch van de server waarvan je gecloned hebt volgt (aangenomen dat de remote een master branch heeft). Over het algemeen zal een `git pull` dat van de server waarvan je origineel gecloned hebt halen en proberen het automatisch in de code waar je op dat moment aan zit te werken te mergen.

### Je Remotes Pushen ###

Wanneer je je project op een punt krijgt dat je het wilt delen, dan moet je het stroomopwaarts pushen. Het commando hiervoor is simpel: `git push [remote-name] [branch-name]`. Als je je master branch naar je `origin` server wilt pushen (nogmaals, over het algemeen zet clonen beide namen automatisch goed voor je), dan kun je dit uitvoeren om je werk terug op de server te pushen:

	$ git push origin master

Dit commando werkt alleen als je gecloned hebt van een server waarop je schrijf toegang hebt, en als niemand in de tussentijd gepushed heeft. Als jij en iemand anders op hetzelfde tijdstip gecloned hebben en zij pushen stroomopwaarts en dan jij, dan zal je push terecht geweigerd worden. Je zult eerst hun werk moeten pullen en in jouw werk verwerken voordat je toegestaan wordt te pushen. Zie Hoofstuk 3 voor meer gedetaileerde informatie over hoe je naar remote servers moet pushen.

### Een Remote Inspecteren ###

Als je meer informatie over een bepaalde remote wilt zien, kun je het `git remote show [remote-name]` commando gebruiken. Als je dit commando met een bepaalde alias uitvoert, zoals `origin`, dan krijg je zoiets als dit:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Het toont de URL voor de remote repository, samen met de tracking branch informatie. Het commando vertelt je behulpzaam dat als je op de master branch zit, en je voert `git pull` uit, dan zal het automatisch de master branch op de remote mergen nadat het alle remote references opgehaald heeft. Het toont ook alle remote referenties die het gepulled heeft.

Dat is een eenvoudig voorbeeld dat je vaak tegenkomt. Als je Git meer intensief gebruikt, zul je veel meer informatie van `git remote show` krijgen:

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

Dit commando toont welke branch automatisch gepushed wordt als je `git push` uitvoert op bepaalde branches. Het toont je ook welke remote branches op de server je nog niet hebt, welke remote branches je hebt die verwijderd zijn van de server, en meerdere branches die automatisch gemerged worden als je `git pull` uitvoert.

### Remotes Verwijderen En Hernoemen ###

Als je een referentie wilt hernoemen, dan kun je in nieuwere versie van Git `git remote rename` uitvoeren om een alias van een remote te wijzigen. Bijvoorbeeld, als je `pb` wilt hernoemen naar `paul`, dan kun je dat doen met `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Het is de moeite om te melden dat dit ook je remote branch naam verandert. Wat voorheen gerefereerd werd als `pb/master` is nu `paul/master`.

Als je om een of andere reden een referentie wilt verwijderen – je hebt de server verplaatst of je gebruikt een bepaalde spiegel niet meer, of een medewerker doet niet meer mee – dan kun je `git remote rm` gebruiken:

	$ git remote rm paul
	$ git remote
	origin

## Labelen ##

Zoals de meeste VCS'en, heeft git de mogelijkheid om specifieke punten in de history als belangrijk te taggen (labelen). Over het algemeen gebruiken mensen deze functionaliteit om versie punten te markeren (v1.0, en verder). In deze sectie zul je leren hoe de beschikbare tags te tonen, hoe nieuwe tags te crëeren, en wat de verschillende typen tags zijn.

### Je Tags Laten Zien ###

De beschikbare tags in Git laten zien is rechttoe rechtaan. Type gewoon `git tag`:

	$ git tag
	v0.1
	v1.3

Dit commando toont de tags in alfabetische volgorde; de volgorde waarin ze verschijnen heeft geen echt belang.

Je kunt ook zoeken op tags met een bepaald patroon. De Git bron repository, bijvoorbeeld, bevat meer dan 240 tags. Als je alleen geinteresseerd bent om naar de 1.4.2 serie te kijken, kun je dit uitvoeren:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Tags Crëeren ###

Git gebruikt twee soorten tags: lightweight (lichtgewicht) en annotated (beschreven). Een lichtgewicht tag komt overeen met een branch die niet verandert – het is slechts een wijzer naar een specifieke commit. Beschreven tags daarentegen, zijn als volwaardige objecten in de Git database opgeslagen. Ze worden gechecksummed, bevatten de naam van de tagger, e-mail en datum, hebben een tag boodschap, en kunnen gesigneerd en geverifieerd worden met GNU Privacy Guard (GPG). Het wordt over het algemeen aangeraden om beschreven tags te maken zodat je deze informatie hebt; maar als je een tijdelijke tag wilt of om een of andere reden de andere informatie niet wilt houden, dan zijn er ook lichtgewicht tags.

### Beschreven Tags ###

Een beschreven tag in Git maken is eenvoudig. Het makkelijkst is om de `-a` optie te specificeren als je het `tag` commando uitvoerd:

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

### Gesigneerde Tags ###

Je kunt je tags ook signeren met GPG, aangenomen dat je een prive sleutel hebt. Het enige dat je moet doen is de `-s` optie gebruiken in plaats van de `-a`:

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

Verderop zul je leren hoe je gesigneerde tags kunt verifieeren.

### Lichtgewicht Tags ###

Een andere manier om een tag te committen is met behulp van een lichtgewicht tag. Dit is in principe de commit checksum in een bestand opgeslagen – er wordt geen andere informatie bijgehouden. Om een lichtgewicht tag te maken voeg je niet de `-a`, `-s` of de `-m` optie toe:

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

### Tags Verifieren ###

Om een gesigneerde tag te verifieren, gebruik je `git tag -v [tag-naam]`. Dit commando gebruikt GPG om de handtekening te verifieren. Je moet de publieke sleutel van degene die getekend heeft wel in je sleutelbos hebben staan om het goed te laten werken:

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

### Later Taggen ###

Je kunt ook commits taggen nadat je verder gegaan bent. Stel dat je commit historie er zo uitziet:

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

Nu, stel dat je vergeten bent het project op v1.2 te taggen, daar waar de "updated rakefile" commit was. Je kunt dit nadien toevoegen. Om die commit te taggen, specificeer je de commit boodschap (of een gedeelte daarvan) aan het einde van het commando:

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

### Tags Delen ###

Standaard zal het `git push` commando geen tags naar remote servers versturen. Je zult expliciet tags naar een gedeelde server moeten pushen, nadat je ze gemaakt hebt. Dit proces is hetzelfde als remote branches delen – je kunt `git push origin [tagnaam]` uitvoeren.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Als je veel tags hebt die je ineens wilt pushen, kun je ook de `--tags` optie aan het `git push` commando toevoegen. Dit zal al je tags, die nog niet op de remote server zijn, in een keer er naartoe sturen.

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

Als nu iemand anders van jouw repository cloned of pulled, dan zullen zij al jouw tags ook krijgen.

## Tips and Trucs ##

Voordat we dit hoofdstuk over de basis van Git afsluiten laten we je nog wat kleine tips en trucs zien die je Git ervaring een beetje eenvoudiger, makkelijker of bekender maken. Veel mensen gebruiken Git zonder deze tips, en we refereren er niet meer aan of gaan er niet vanuit dat je ze gebruikt verderop in dit boek; maar je zult waarschijnlijk willen weten hoe je ze moet doen.

### Auto-Aanvulling ###

Als je de Bash shell gebruikt, heeft Git een fijn auto-aanvulling script dat je aan kunt zetten. Download de Git broncode, en kijk in de `contrib/completion` map; daar zou een bestand genaamd `git-completion.bash` moeten staan. Kopieer dit bestand naar je home map, en voeg dit aan je `.bashrc` bestand toe:

	source ~/.git-completion.bash

Als je Git wilt instellen dat het automatische Bash shell aanvulling heeft voor alle gebruikers, kopieer dit script dan naar de `/opt/local/etc/bash_completion.d` map op Mac systemen, of naar de `/etc/bash_completion.d/` map op Linux systemen. Dit is een map met scripts dat Bash automatisch zal laden om shell aanvullingen aan te bieden.

Als je Windows gebruikt met Git Bash, wat de standaard is als je Git op Windows installeert met msysGit, dan zou auto-aanvulling voorgeconfigureerd moeten zijn.

Druk de Tab toets als je een Git commando aan het typen bent, en het zou een set suggesties voor je moeten teruggeven:

	$ git co<tab><tab>
	commit config

In dit geval zal git co en dan de Tab toets twee keer indrukken git commit en config voorstellen. `m<tab>` toevoegen, vult `git commit` automatisch aan.
	
Dit werkt ook met opties, wat waarschijnlijk meer bruikbaar is. Bijvoorbeeld, als je een `git log` commando uitvoert en je niet meer kunt herinneren wat een van de opties is, dan kun je beginnen met het te typen en Tab twee keer indrukken om te zien wat er past:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Dat is een erg handig trucje en zal je misschien wat tijd en documentatie lezen besparen.

### Git Aliasen ###

Git zal geen commando's raden als je het gedeeltelijk intyped. Als je niet de hele tekst van ieder Git commando wilt intypen, kun je gemakkelijk een alias voor ieder commando configureren door `git config` te gebruiken. Hier zijn een aantal voorbeelden die je misschien wilt instellen:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Dit betekent dat je, bijvoorbeeld, in plaats van `git commit` je alleen `git ci` hoeft in te typen. Als je verder gaat met Git, zul je waarschijnlijk andere commando's ook vaker gaan gebruiken; in dat geval, schroom je niet om nieuwe aliassen te maken.

Deze techniek kan ook makkelijk zijn om commando's te maken waarvan je vindt dat ze moeten bestaan. Bijvoorbeeld, om het bruikbaarheidsprobleem wat je met het unstagen van een bestand hebt op te lossen, kun je je eigen unstage alias aan Git toevoegen:

	$ git config --global alias.unstage 'reset HEAD --'

Dit maakt de volgende twee commando's equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

Het lijkt wat helderder. Het is ook gebruikelijk om een `last` commando toe te voegen:

	$ git config --global alias.last 'log -1 HEAD'

Op deze manier kun je de laatste commit makkelijk zien:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Zoals je kunt zien, vervangt Git eenvoudigweg het nieuwe commando met waarvoor je het gealiassed hebt. Maar, misschien wil je een extern commando uitvoeren, in plaats van een Git subcommando. In dat geval begin je het commando met een `!` karakter. Dit is handig als je je eigen applicaties maakt die met een Git repository werken. We kunnen dit demonstreren door `git visual` een `gitk` te laten uitvoeren:

	$ git config --global alias.visual "!gitk"

## Samenvatting ##

Op dit punt kun je alle basis locale Git operaties doen – een repository crëeeren of clonen, wijzigingen maken, de wijzigingen stagen en committen, en de historie van alle veranderingen die de repository ondergaan heeft is zien. Als volgende gaan we Gits beste optie bekijken: het branching model. 
