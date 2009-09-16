# De Basis van Git #

Als je slechts één hoofdstuk kunt lezen om met Git aan de slag te gaan, dan is dit het. Dit hoofdstuk behandelt elk van de basiscommando's, die je nodig hebt om het leeuwendeel van de dingen te doen waarmee je uiteindelijk je tijd met Git zult doorbrengen. zul je een repository kunnen configureren en initialiseren, bestanden beginnen en stoppen te volgen en veranderingen te ‘stagen’ en ‘committen’. We laten ook zien hoe je Git kunt instellen zodat het bepaalde bestanden en bestandspatronen negeert, hoe je vergissingen snel en gemakkelijk ongedaan kunt maken, hoe je de geschiedenis van je project kan doorlopen en wijzigingen tussen commits kunt zien, en hoe je kan pushen en pullen van en naar andere repositories.

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

Als je een kopie wilt van een bestaande Git repository — bijvoorbeeld een project waaraan je wilt bijdragen — dan is het git clone commando wat je nodig hebt. Als je bekend bent met andere versie-beheersystemen zoals Subversion, dan valt je op dat het commando 'clone' is en niet 'checkout'. Dit is een belangrijk verschil — Git ontvangt een kopie van bijna alle data die de server heeft. Iedere versie van ieder bestand van de hele geschiedenis van een project wordt binnengehaald als je `git clone` doet. In feite kun je, als je disk kapot gaat, iedere clone van iedere client gebruiken om de server terug in de status te brengen op het moment van clonen (al zou je wel wat hooks en dergelijke verliezen, maar alle versies van alle bestanden zouden er zijn-zie Hoofdstuk 4 voor meer informatie).

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

Dit betekend dat je een schone werkmap hebt-met andere woorden, er zijn geen gevolgde en gewijzigde bestanden. Git ziet ook geen ongevolgde bestanden, anders zouden ze hier getoond worden. Als laatste verteld het commando op welke tak (branch) je nu zit. Voor nu is dit altijd de master, dat is de standaard; maak je je hier nog niet druk om. Het volgende hoofdstuk gaat in detail over takken en referenties.

Stel dat je een nieuw bestand toevoegd aan je project, en simpel README bestand. Als het bestand voorheen nog niet bestond, en je doet `git status`, dan zul je je ongevolgde bestand zo zien:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Je kunt zien dat je nieuwe README bestand ongevolgd is, omdat het onder de “Untracked files” kop staat in je status output. Ongevolgd betekend eigenlijk dat Git een bestand ziet dat je niet in het vorige snapshot (commit) had; Git zal het niet in je commit snapshots toevoegen totdat jij haar er expliciet om vraagt. Ze doet dit zodat jij niet per ongeluk gegenereerde binaire bestanden toevoegd, of andere bestanden die je niet wou toevoegen. Je wilt dit README bestand wel toevoegen, dus laten we het gaan volgen.

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

Je kunt zien dat het ge-staged is, omdat het onder de kop “Changes to be committed” staat. Als je op dit punt een commit doet, zal de versie van het bestand zoals het wat ten tijde van je git add commando in de historische snapshot toegevoegd worden. Je zult je misschien herinneren dat, toen je git init eerder uitvoerde, je daarna git add (bestanden) uitvooerde — dat was om bestanden in je map te beginnen te volgden. Het git add commando neemt een padnaam voor een bestand of een map; als het een map is, dan voegt het commando alle bestanden in die map recursief toe.

### Gewijzigde Bestanden Stagen ###

Laten we een gevolgd bestand wijzigen. Als je een voorheen gewijzigd bestand genaamd `benchmarks.rb` wijzigd, en dan je `status` commando nog eens uitvoerd, krijg je iets dat er zo uitziet:

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

Het benchmarks.rb bestand verschijnt onder een sectie genaamd “Changed but not updated” — wat betekend dat een bestand dat gevolgd wordt gewijzigd is in de werkmap, maar nog niet ge-staged. Om het te stagen, voer je het `git add` commando uit (het is een veelzijdig commando — je gebruikt het om bestanden te volgen, om bestanden te stagen, en andere dingen zoals een bestand met een mergeconflict als opgelost te markeren). Laten we `git add` nu uitvoeren om het benchmarks.rb bestand nu te stagen, en dan nog eens `git status`:

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

Hé! Nu staat benchmarks.rb zowel bij de staged en unstaged. Hoe kan dat? Het blijkt dat Git een bestand staged precies zoals het is wanneer je het git add commando uitvoerd. Als je nu commit, dan zal de versie van benchmarks.rb zoals het was toen je voor 't laatst git add uitvoerde worden toegevoegd in de commit, en niet de versie van het bestand zoals ie eruit zit in je map wanneer je git commit uitvoerd. Als je een bestand wijzigd nadat je `git add` uitvoert, dan moet je `git add` nogmaals uitvoeren om de laatste versie van het bestand te stagen:

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

Vaak zul je een klasse bestanden hebben waarvan je niet wilt dat Git deze automatisch toevoegd of zelfs maar als ongevolgd toont. Dit zijn doorgaans automatisch gegenereerde bestanden zoals logbestanden of bestanden die geproduceerd worden door je bouwsysteem. In die gevallen kun je een bestand genaamd .gitignore maken, waarin patronen staan die die bestanden passen. Hier is een voorbeeld .gitignore bestand:

	$ cat .gitignore
	*.[oa]
	*~

De eerste regel verteld Git om ieder bestand dat eindigt op een .o of .a – object en archief bestanden die het product kunnen zijn van het bouwen van je code. De tweede regel verteld Git dat ze alle bestanden die eindigen op een tilde (`~`), wat gebruikt wordt door editors zoals Emacs om tijdelijke bestanden te markeren, mag negeren. Je mag ook log, tmp of een pid map toevoegen; automatisch gegenereerde documentatie; enzovoort. Een .gitignore bestand aanmaken voordat je gaat beginnen is over 't algemeen een goed idee, zodat je niet per ongelijk bestanden commit die je echt niet in je repository wilt hebben.

De regels voor patronen die je in het .gitignore bestand kunt zetten zijn als volgt:

*	Lege regels of regels die beginnen met een # worden genegeerd.
*	Standaard expansie patronen werken.
*	Je mag patronen laten eindigen op een slash (`\`) om een map te specificeren.
*	Je mag een patroon ontkennend maken door het te laten beginnen met een uitroepteken (`!`).

Expansie (`glob`) patronen zijn vereenvoudigde reguliere expressies die shell omgevingen gebruiken. Een sterretje (`*`) komt overeen met nul of meer karakters; `[abc]` komt overeen met ieder karakter dat tussen de blokhaken staat (in dit geval a, b of c); een vraagteken (`?`) komt overeen met een enkel karakter; en blokhaken waar tussen karakters staan die gescheiden zijn door een streepje (`[0-9]`) komen overeen met ieder karakter wat tussen die karakters zit (in dit geval 0 tot en met 9).

Hier is nog een voorbeeld van een .gitignore bestand:

	# a comment – this is ignored
	*.a       # no .a files
	!lib.a    # but do track lib.a, even though you're ignoring .a files above
	/TODO     # only ignore the root TODO file, not subdir/TODO
	build/    # ignore all files in the build/ directory
	doc/*.txt # ignore doc/notes.txt, but not doc/server/arch.txt

### Je Staged En Unstaged Wijzigigen Zien ###

Als het `git status` commando te vaag is voor je – je wilt precies weten wat je vernanderd hebt, niet alleen welke bestanden veranderd zijn – dan kun je het `git diff` commando gebruiken. We zullen `git diff` later in meer detail bespreken; maar je zult het het meest gebruiken om deze twee vragen te beantwoorden: Wat heb je veranderd maar nog niet gestaged? En wat heb je gestaged en sta je op het punt te committen? Alhoewel `git status` deze vragen heel generiek beantwoord, laat `git diff` je de exacte toegevoegde en verwijderde regels zien – de patch, als het ware.

Stel dat je het README bestand opnieuw veranderd en staged, en dan het benchmarks.rb bestand veranderd zonder het te stagen. Als je je `status` commando uitvoert, dan zie je nogmaals zoiets als dit:

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

Nog een voorbeeld. Als je het benchmarks.rb bestand staged, en vervolgens veranderd, dan kun je `git diff` gebruiken om de wijzigingen in het bestand te zien dat gestaged is en de wijzigingen die niet gestaged zijn:

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

Je kunt zien dat de standaard commit boodschap de laatste output van het `git status` commando in commentaar bevat en een lege regel bovenaan. Je kunt deze commentaren verwijderen en je eigen commit boodschap intypen, of je kunt ze laten staan om je eraan te helpe herinneren wat je aan het committen bent. (Om een meer expliciete herinnering van je wijzigingen te zien kun je de `-v` optie meegeven aan `git commit`. Als je dit doet zet git de diff van je verandering in je editor zodat je precies kunt zien wat je gedaan hebt.) Als je de editor verlaat, crëeert Git je commit boodschap (zonder de commentaren of de diff).

Als alternatief kun je je commit boodschap met het `commit` commando meegeven door hem achter de -m optie te specificeren, zoals hier:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Nu heb je je eerste commit gemaakt! Je kunt zien dat de commit je wat output over zichzelf heeft gegeven: op welke branch je gecommit hebt (master), welke SHA-1 checksum de commit heeft (`463dc4f`), hoeveel bestandend er veranderd zijn, en statistieken over toegevoegde en verwijderde regels in de commit.

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

Om een bestand van Git te verwijderen, moet je het van de tracked bestanden verwijderen (om precies te zijn, verwijderen van je staging gebied) en dan een commit doen. Het `git rm` commando doet dat, en verwijderd het bestand ook van je werkmap zodat je het de volgende keer niet als een untracked bestand ziet.

Als je het bestand simpelweg verwijderd uit je werkmap, zal het te zien zijn onder het "Changed but not updated" (dat wil zeggen, _unstaged_) gedeelte van je `git status` output:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Als je daarna `git rm` uitvoerd, zal de verwijdering van het bestand gestaged worden:

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

Je kunt bestanden, mappen en bestandspatronen aan het `git rm` commando meegeven. Dat betekend dat je zoiets als dit kunt doen

	$ git rm log/\*.log

Let op de backslash (`\`) voor de `*`. Dit is nodig omdat Git zijn eigen bestandsnaam expansie doet, naast die van je shell. Dit commando verwijderd alle bestanden die de `.log` extensie hebben in de `log/` map. Of, je kunt zoiets als dit doen:

	$ git rm \*~

Dit commando verwijderd alle bestanden die eindigen met `~`.

### Bestanden Verplaatsen ###

Anders dan vele andere VCS systemen, traceert Git niet expliciete verplaatsingen van bestanden. Als je een bestand een nieuwe naam geeft in Git, is er geen metadata opgeslagen in Git die verteld dat je het bestand hernoemt hebt. Maar, Git is slim genoeg om dit alsnog te zien – we zullen bestandsverplaatsing detectie wat later behandelen.

Het is daarom een beetje verwarrend dat Git een `mv` commando heeft. Als je een bestand wilt hernoemen in Git, kun je zoiets als dit doen

	$ git mv file_from file_to

en dat werkt prima. Sterker nog, als je zoiets als dit uitvoert en naar de status kijkt, zul je zien dat Git het als een hernoemd bestand beschouwd:

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

Git komt er impliciet achter dat het om een hernoemd bestand gaat, dus het maakt niet uit of je een bestand op deze manier hernoemd of met het `mv` commando. Het enige echte verschil is dat het `mv` commando slechts één commando is in plaats van drie. En belangrijker nog is dat je iedere applicatie kunt gebruiken om een bestand te hernoemen, en de add/rm later kunt behandelen, voordat je commit.

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

### Limiting Log Output ###

In addition to output-formatting options, git log takes a number of useful limiting options — that is, options that let you show only a subset of commits. You’ve seen one such option already — the `-2` option, which show only the last two commits. In fact, you can do `-<n>`, where `n` is any integer to show the last `n` commits. In reality, you’re unlikely to use that often, because Git by default pipes all output through a pager so you see only one page of log output at a time.

However, the time-limiting options such as `--since` and `--until` are very useful. For example, this command gets the list of commits made in the last two weeks:

	$ git log --since=2.weeks

This command works with lots of formats — you can specify a specific date (“2008-01-15”) or a relative date such as “2 years 1 day 3 minutes ago”.

You can also filter the list to commits that match some search criteria. The `--author` option allows you to filter on a specific author, and the `--grep` option lets you search for keywords in the commit messages. (Note that if you want to specify both author and grep options, you have to add `--all-match` or the command will match commits with either.)

The last really useful option to pass to `git log` as a filter is a path. If you specify a directory or file name, you can limit the log output to commits that introduced a change to those files. This is always the last option and is generally preceded by double dashes (`--`) to separate the paths from the options.

In Table 2-3 we’ll list these and a few other common options for your reference.

	Option	Description
	-(n)	Show only the last n commits
	--since, --after	Limit the commits to those made after the specified date.
	--until, --before	Limit the commits to those made before the specified date.
	--author	Only show commits in which the author entry matches the specified string.
	--committer	Only show commits in which the committer entry matches the specified string.

For example, if you want to see which commits modifying test files in the Git source code history were committed by Junio Hamano and were not merges in the month of October 2008, you can run something like this:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Of the nearly 20,000 commits in the Git source code history, this command shows the 6 that match those criteria.

### Using a GUI to Visualize History ###

If you like to use a more graphical tool to visualize your commit history, you may want to take a look at a Tcl/Tk program called gitk that is distributed with Git. Gitk is basically a visual `git log` tool, and it accepts nearly all the filtering options that `git log` does. If you type gitk on the command line in your project, you should see something like Figure 2-2.

Insert 18333fig0202.png 
Figure 2-2. The gitk history visualizer.

You can see the commit history in the top half of the window along with a nice ancestry graph. The diff viewer in the bottom half of the window shows you the changes introduced at any commit you click.

## Undoing Things ##

At any stage, you may want to undo something. Here, we’ll review a few basic tools for undoing changes that you’ve made. Be careful, because you can’t always undo some of these undos. This is one of the few areas in Git where you may lose some work if you do it wrong.

### Changing Your Last Commit ###

One of the common undos takes place when you commit too early and possibly forget to add some files, or you mess up your commit message. If you want to try that commit again, you can run commit with the `--amend` option:

	$ git commit --amend

This command takes your staging area and uses it for the commit. If you’ve have made no changes since your last commit (for instance, you run this command immediately after your previous commit), then your snapshot will look exactly the same and all you’ll change is your commit message.

The same commit-message editor fires up, but it already contains the message of your previous commit. You can edit the message the same as always, but it overwrites your previous commit.

As an example, if you commit and then realize you forgot to stage the changes in a file you wanted to add to this commit, you can do something like this:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

All three of these commands end up with a single commit — the second commit replaces the results of the first.

### Unstaging a Staged File ###

The next two sections demonstrate how to wrangle your staging area and working directory changes. The nice part is that the command you use to determine the state of those two areas also reminds you how to undo changes to them. For example, let’s say you’ve changed two files and want to commit them as two separate changes, but you accidentally type `git add *` and stage them both. How can you unstage one of the two? The `git status` command reminds you:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Right below the “Changes to be committed” text, it says use `git reset HEAD <file>...` to unstage. So, let’s use that advice to unstage the benchmarks.rb file:

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

The command is a bit strange, but it works. The benchmarks.rb file is modified but once again unstaged.

### Unmodifying a Modified File ###

What if you realize that you don’t want to keep your changes to the benchmarks.rb file? How can you easily unmodify it — revert it back to what it looked like when you last committed (or initially cloned, or however you got it into your working directory)? Luckily, `git status` tells you how to do that, too. In the last example output, the unstaged area looks like this:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

It tells you pretty explicitly how to discard the changes you’ve made (at least, the newer versions of Git, 1.6.1 and later, do this — if you have an older version, we highly recommend upgrading it to get some of these nicer usability features). Let’s do what it says:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

You can see that the changes have been reverted. You should also realize that this is a dangerous command: any changes you made to that file are gone — you just copied another file over it. Don’t ever use this command unless you absolutely know that you don’t want the file. If you just need to get it out of the way, we’ll go over stashing and branching in the next chapter; these are generally better ways to go. 

Remember, anything that is committed in Git can almost always be recovered. Even commits that were on branches that were deleted or commits that were overwritten with an `--amend` commit can be recovered (see Chapter 9 for data recovery). However, anything you lose that was never committed is likely never to be seen again.

## Working with Remotes ##

To be able to collaborate on any Git project, you need to know how to manage your remote repositories. Remote repositories are versions of your project that are hosted on the Internet or network somewhere. You can have several of them, each of which generally is either read-only or read/write for you. Collaborating with others involves managing these remote repositories and pushing and pulling data to and from them when you need to share work.
Managing remote repositories includes knowing how to add remote repositories, remove remotes that are no longer valid, manage various remote branches and define them as being tracked or not, and more. In this section, we’ll cover these remote-management skills.

### Showing Your Remotes ###

To see which remote servers you have configured, you can run the git remote command. It lists the shortnames of each remote handle you’ve specified. If you’ve cloned your repository, you should at least see origin — that is the default name Git gives to the server you cloned from:

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

You can also specify `-v`, which shows you the URL that Git has stored for the shortname to be expanded to:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

If you have more than one remote, the command lists them all. For example, my Grit repository looks something like this.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

This means we can pull contributions from any of these users pretty easily. But notice that only the origin remote is an SSH URL, so it’s the only one I can push to (we’ll cover why this is in Chapter 4).

### Adding Remote Repositories ###

I’ve mentioned and given some demonstrations of adding remote repositories in previous sections, but here is how to do it explicitly. To add a new remote Git repository as a shortname you can reference easily, run `git remote add [shortname] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Now you can use the string pb on the command line in lieu of the whole URL. For example, if you want to fetch all the information that Paul has but that you don’t yet have in your repository, you can run git fetch pb:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul’s master branch is accessible locally as `pb/master` — you can merge it into one of your branches, or you can check out a local branch at that point if you want to inspect it.

### Fetching and Pulling from Your Remotes ###

As you just saw, to get data from your remote projects, you can run:

	$ git fetch [remote-name]

The command goes out to that remote project and pulls down all the data from that remote project that you don’t have yet. After you do this, you should have references to all the branches from that remote, which you can merge in or inspect at any time. (We’ll go over what branches are and how to use them in much more detail in Chapter 3.)

If you clone a repository, the command automatically adds that remote repository under the name origin. So, `git fetch origin` fetches any new work that has been pushed to that server since you cloned (or last fetched from) it. It’s important to note that the fetch command pulls the data to your local repository — it doesn’t automatically merge it with any of your work or modify what you’re currently working on. You have to merge it manually into your work when you’re ready.

If you have a branch set up to track a remote branch (see the next section and Chapter 3 for more information), you can use the `git pull` command to automatically fetch and then merge a remote branch into your current branch. This may be an easier or more comfortable workflow for you; and by default, the `git clone` command automatically sets up your local master branch to track the remote master branch on the server you cloned from (assuming the remote has a master branch). Running `git pull` generally fetches data from the server you originally cloned from and automatically tries to merge it into the code you’re currently working on.

### Pushing to Your Remotes ###

When you have your project at a point that you want to share, you have to push it upstream. The command for this is simple: `git push [remote-name] [branch-name]`. If you want to push your master branch to your `origin` server (again, cloning generally sets up both of those names for you automatically), then you can run this to push your work back up to the server:

	$ git push origin master

This command works only if you cloned from a server to which you have write access and if nobody has pushed in the meantime. If you and someone else clone at the same time and they push upstream and then you push upstream, your push will rightly be rejected. You’ll have to pull down their work first and incorporate it into yours before you’ll be allowed to push. See Chapter 3 for more detailed information on how to push to remote servers.

### Inspecting a Remote ###

If you want to see more information about a particular remote, you can use the `git remote show [remote-name]` command. If you run this command with a particular shortname, such as `origin`, you get something like this:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

It lists the URL for the remote repository as well as the tracking branch information. The command helpfully tells you that if you’re on the master branch and you run `git pull`, it will automatically merge in the master branch on the remote after it fetches all the remote references. It also lists all the remote references it has pulled down.

That is a simple example you’re likely to encounter. When you’re using Git more heavily, however, you may see much more information from `git remote show`:

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

This command shows which branch is automatically pushed when you run `git push` on certain branches. It also shows you which remote branches on the server you don’t yet have, which remote branches you have that have been removed from the server, and multiple branches that are automatically merged when you run `git pull`.

### Removing and Renaming Remotes ###

If you want to rename a reference, in newer versions of Git you can run `git remote rename` to change a remote’s shortname. For instance, if you want to rename `pb` to `paul`, you can do so with `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

It’s worth mentioning that this changes your remote branch names, too. What used to be referenced at `pb/master` is now at `paul/master`.

If you want to remove a reference for some reason — you’ve moved the server or are no longer using a particular mirror, or perhaps a contributor isn’t contributing anymore — you can use `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Tagging ##

Like most VCSs, Git has the ability to tag specific points in history as being important. Generally, people use this functionality to mark release points (v1.0, and so on). In this section, you’ll learn how to list the available tags, how to create new tags, and what the different types of tags are.

### Listing Your Tags ###

Listing the available tags in Git is straightforward. Just type `git tag`:

	$ git tag
	v0.1
	v1.3

This command lists the tags in alphabetical order; the order in which they appear has no real importance.

You can also search for tags with a particular pattern. The Git source repo, for instance, contains more than 240 tags. If you’re only interested in looking at the 1.4.2 series, you can run this:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creating Tags ###

Git uses two main types of tags: lightweight and annotated. A lightweight tag is very much like a branch that doesn’t change — it’s just a pointer to a specific commit. Annotated tags, however, are stored as full objects in the Git database. They’re checksummed; contain the tagger name, e-mail, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG). It’s generally recommended that you create annotated tags so you can have all this information; but if you want a temporary tag or for some reason don’t want to keep the other information, lightweight tags are available too.

### Annotated Tags ###

Creating an annotated tag in Git is simple. The easiest way is to specify `-a` when you run the `tag` command:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

The `-m` specifies a tagging message, which is stored with the tag. If you don’t specify a message for an annotated tag, Git launches your editor so you can type it in.

You can see the tag data along with the commit that was tagged by using the `git show` command:

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

That shows the tagger information, the date the commit was tagged, and the annotation message before showing the commit information.

### Signed Tags ###

You can also sign your tags with GPG, assuming you have a private key. All you have to do is use `-s` instead of `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you run `git show` on that tag, you can see your GPG signature attached to it:

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

A bit later, you’ll learn how to verify signed tags.

### Lightweight Tags ###

Another way to tag commits is with a lightweight tag. This is basically the commit checksum stored in a file — no other information is kept. To create a lightweight tag, don’t supply the `-a`, `-s`, or `-m` option:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

This time, if you run `git show` on the tag, you don’t see the extra tag information. The command just shows the commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verifying Tags ###

To verify a signed tag, you use `git tag -v [tag-name]`. This command uses GPG to verify the signature. You need the signer’s public key in your keyring for this to work properly:

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

If you don’t have the signer’s public key, you get something like this instead:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Tagging Later ###

You can also tag commits after you’ve moved past them. Suppose your commit history looks like this:

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

Now, suppose you forgot to tag the project at v1.2, which was at the "updated rakefile" commit. You can add it after the fact. To tag that commit, you specify the commit checksum (or part of it) at the end of the command:

	$ git tag -a v1.2 9fceb02

You can see that you’ve tagged the commit:

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

### Sharing Tags ###

By default, the `git push` command doesn’t transfer tags to remote servers. You will have to explicitly push tags to a shared server after you have created them.  This process is just like sharing remote branches – you can run `git push origin [tagname]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

If you have a lot of tags that you want to push up at once, you can also use the `--tags` option to the `git push` command.  This will transfer all of your tags to the remote server that are not already there.

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

Now, when someone else clones or pulls from your repository, they will get all your tags as well.

## Tips and Tricks ##

Before we finish this chapter on basic Git, a few little tips and tricks may make your Git experience a bit simpler, easier, or more familiar. Many people use Git without using any of these tips, and we won’t refer to them or assume you’ve used them later in the book; but you should probably know how to do them.

### Auto-Completion ###

If you use the Bash shell, Git comes with a nice auto-completion script you can enable. Download the Git source code, and look in the `contrib/completion` directory; there should be a file called `git-completion.bash`. Copy this file to your home directory, and add this to your `.bashrc` file:

	source ~/.git-completion.bash

If you want to set up Git to automatically have Bash shell completion for all users, copy this script to the `/opt/local/etc/bash_completion.d` directory on Mac systems or to the `/etc/bash_completion.d/` directory on Linux systems. This is a directory of scripts that Bash will automatically load to provide shell completions.

If you’re using Windows with Git Bash, which is the default when installing Git on Windows with msysGit, auto-completion should be preconfigured.

Press the Tab key when you’re writing a Git command, and it should return a set of suggestions for you to pick from:

	$ git co<tab><tab>
	commit config

In this case, typing git co and then pressing the Tab key twice suggests commit and config. Adding `m<tab>` completes `git commit` automatically.
	
This also works with options, which is probably more useful. For instance, if you’re running a `git log` command and can’t remember one of the options, you can start typing it and press Tab to see what matches:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

That’s a pretty nice trick and may save you some time and documentation reading.

### Git Aliases ###

Git doesn’t infer your command if you type it in partially. If you don’t want to type the entire text of each of the Git commands, you can easily set up an alias for each command using `git config`. Here are a couple of examples you may want to set up:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

This means that, for example, instead of typing `git commit`, you just need to type `git ci`. As you go on using Git, you’ll probably use other commands frequently as well; in this case, don’t hesitate to create new aliases.

This technique can also be very useful in creating commands that you think should exist. For example, to correct the usability problem you encountered with unstaging a file, you can add your own unstage alias to Git:

	$ git config --global alias.unstage 'reset HEAD --'

This makes the following two commands equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

This seems a bit clearer. It’s also common to add a `last` command, like this:

	$ git config --global alias.last 'log -1 HEAD'

This way, you can see the last commit easily:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

As you can tell, Git simply replaces the new command with whatever you alias it for. However, maybe you want to run an external command, rather than a Git subcommand. In that case, you start the command with a `!` character. This is useful if you write your own tools that work with a Git repository. We can demonstrate by aliasing `git visual` to run `gitk`:

	$ git config --global alias.visual "!gitk"

## Summary ##

At this point, you can do all the basic local Git operations — creating or cloning a repository, making changes, staging and committing those changes, and viewing the history of all the changes the repository has been through. Next, we’ll cover Git’s killer feature: its branching model.
