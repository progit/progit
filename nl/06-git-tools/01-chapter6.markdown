# Git Tools #

Nu heb je de meeste commando's en werkwijzen geleerd die je dagelijks nodig hebt om een Git repository voor je brondcode te beheren en te onderhouden. Je hebt de basistaken van het tracken en committen van bestanden gedaan, en je hebt de kracht van het staging area en lichtgewicht onderwerp branching en mergen in handen.

Nu ga je een aantal zeer krachtige dingen verkennen die Git kan, die je niet per se dagelijks nodig zult hebben, maar die je op een bepaald punt toch nodig kunt hebben.

## Revisie Selectie ##

Git staat je toe om specifieke commits of een serie commits op meerdere manieren te specificeren. Ze zijn niet per se voor de hand liggend, maar behulpzaam om te weten.

### Enkele Revisies ###

Natuurlijk kun je naar een commit refereren door de SHA-1 hash die het gegeven is, maar er zijn ook meer mensvriendelijke manieren om naar een commit te refereren. Deze sectie laat de diverse manieren zien waarop je naar een enkele commit kunt refereren.

### Korte SHA ###

Git is slim genoeg om uit te vinden welke commit je bedoelde in te typen als je de eerste karakters opgeeft, zolang je gedeeltelijke SHA-1 minstens vier karakters lang en ondubbelzinnig is – dat wil zeggen dat slechts één object in de huidige repository begint met dat gedeeltelijke SHA-1.

Bijvoorbeeld, stel dat je om een specifieke commit te zien een `git log` commando uitvoerd en de commit identificeerd waar een bepaalde functionaliteit hebt toegevoegd:

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

In dit geval, kies `1c002dd....` Als je op die commit `git show` doet, dan zijn de volgende commando's equivalent (aangenomen dat de kortere versies ondubbelzinnig zijn):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git kan een korte unieke afkorting voor je SHA-1 waardes uitvinden. Als je `--abbrev-commit` meegeeft aan het `git log` commando, dan zal de output kortere waarden gebruiken maar ze uniek houden; het gebruikt standaard zeven karakters, maar maakt ze langer om de SHA-1 ondubbelzinnig te houden:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Over het algemeen zijn acht tot tien karakters meer dan voldoende om binnen een project uniek te zijn. Een van de grootste Git projecten, de Linux kernel, begint 12 karakters van de mogelijke 40 nodig te hebben om uniek te blijven.

### Een Korte Notitie Over SHA-1 ###

Veel mensen zijn bezorgd geworden dat ze op een bepaald punt, door random toeval, twee objecten in hun repository hebben die naar dezelfde SHA-1 waarde hashen. Wat dan?

Mocht je een object committen dat hashed naar dezelfde SHA-1 waarde als een vorig object in je repository, dan zal Git het vorige reeds aanwezige object in je Git database zien en aannemen dat het al geschreven was. Als je dat object opnieuw probeert uit te checken op een bepaald punt, dan zul je altijd de gegevens van het eerste object krijgen.

Maar, je moet je bewust zijn hoe belachelijk onwaarschijnlijk dit scenario is. De SHA-1 waarde is 20 bytes of 160 bits. Het aantal benodigde random gehashte objecten om een 50% waarschijnlijkheid van een enkele botsing te garanderen is ongeveer 2^80 (de formule om botsing waarschijnlijkheid te bepalen is `p = (n(n-1)/2) * (1/2^160)`). 2^80 is 1.2 x 10^24 of 1 miljoen miljard miljad. Dat is 1.200 keer het aantal zandkorrels op de aarde.

Hier is een voorbeeld om je een idee te geven wat er voor nodig is om een SHA-1 botsing te krijgen. Als alle 6.5 miljard mensen op aarde zouden gaan programmeren, en iedere seconde zou iedereen code genereren die gelijk was aan de hele Linux kernel geschiedenis (1 miljoen Git objecten) en dat in één gigantische Git repository pushen, dan zou het vijf jaar duren voordat dat repository genoeg objecten zou bevatten om een 50% waarschijnlijkheid van een enkele SHA-1 object botsing te krijgen. Er bestaat een grotere kans dat ieder lid van je programmeer team zal worden aangevallen en worden gedood door wolven in ongerelateerde incidenten op dezelfde avond.

### Branch Referenties ###

De meest eenvoudige manier om een commit te specificeren heeft als voorwaarde dat je er een brach referentie naar hebt wijzen. Dan kun je een branch naam in ieder Git commando gebruiken dat een commit object of SHA-1 waarde verwacht. Bijvoorbeeld, als je het laatste commit object op een branch wil tonen, dan zijn de volgende commando's gelijk, aangenomen dat de `topic1` branch naar `ca82a6d` wijst:

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Als je wil zien naar welke specifieke SHA een branch wijst, of als je wil zien wat ieder van deze voorbeelden in termen van SHA's voorstellen, dan kun je een Git onderwater tool genaamd `rev-parse` gebruiken. Je kunt in Hoofdstuk 9 kijken voor meer informatie over onderwater tools; eigenlijk bestaat `rev-parse` voor lage operaties en is niet ontworpen om in dagelijkse operaties gebruikt te worden. Maar, het kan behulpzaam zijn op momenten dat je moet zien wat er echt aan de hand is. Hier kun je `rev-parse` uitvoeren op je branch.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### RefLog Afkortingen ###

Een van de dingen die Git in de achtergrond doet terwijl jij zit te werken is een reflog bijhouden – een log waar je HEAD en branch referenties zijn gebleven in de laatste paar maanden.

Je kunt je reflog zien door `git reflog` te gebruiken:

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Iedere keer als de punt van je branch om een of andere reden is gewijzigd, dan bewaard Git die informatie voor je in deze tijdelijke geschiedenis. En je kunt ook oudere commits hiermee specificeren. Als je de vijfde voorgaande waarde van de HEAD van je repository wil zien, dan kun je de `@{n}` referentie gebruiken, die je in de reflog output kunt zien:

	$ git show HEAD@{5}

Je kunt deze syntax ook gebruiken om te zien waar een branch een bepaalde hoeveelheid tijd geleden was. Bijvoorbeeld, om te zien waar je `master` branch gisteren was, kun je dit typen

	$ git show master@{yesterday}

Dat laat je zien waar de punt van de branch gisteren was. Deze techniek werkt alleen voor gegevens die nog steeds in je reflog staan, dus je kunt het niet gebruiken om te kijken naar commits die ouder zijn dan een paar maanden.

Om reflog informatie te zien, die in hetzelfde formaat gezet is als de `git log` output, kun je `git log -g` uitvoeren:

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated 
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Het is belangrijk om te zien dat deze informatie strikt lokaal is – het is een log van wat jij hebt gedaan in jouw repository. De referenties zullen niet hetzelfde zijn in iemand anders zijn kopie vna het repository; en meteen nadat je een eerste clone van een repository hebt gemaakt, heb je een lege reflog, omdat er nog geen aktiviteit is geweest in je repository. `git show HEAD@{2.months.ago}` uitvoeren werkt alleen als je het project minstens twee maanden geleden gecloned hebt – als je het vijf minuten geleden gecloned hebt, krijg je geen resultaten.

### Voorouder Referenties ###

De andere veelgebruikte manier om een commit te specificeren is via zijn voorouder. Als je een `^` aan het einde van een referentie zet, zal Git hieruit herleiden dat het de ouder van de commit betekend.
Stel dat je naar de geschiedenis van je project kijkt:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\  
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/  
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Dan zie je de vorige commit door `HEAD^` te specificeren, wat "de ouder van HEAD" betekend:

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Je kunt ook een nummer na de `^` zetten – bijvoorbeeld, `d921970^2` betekend "de tweede ouder van d921970." Deze syntax is alleen bruikbaar voor merge commits, die meer dan één ouder hebben. De eerste ouder is de branch waar jij op was toen je merge-te, en de andere is de commit op de branch die in ingemerged hebt:

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

De andere manier om ouders mee te specificeren is de `~`. Dit refereerd ook naar de eerste ouder, dus `HEAD~` en `HEAD^` zijn gelijk. Het verschil wordt duidelijk als je een nummer specificeerd. `HEAD~2` betekend "de eerste ouder van de eerste ouder", of "de grootouder" – het bewandeld de eerste ouders het aantal keren dat je specificeerd. Bijvoorbeeld, in de geschiedenis die eerder getoond werd, zou `HEAD~3` zijn

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Dit kan ook geschreven worden als `HEAD^^^`, wat nogmaals de eerste ouder van de eerste ouder van de eerste ouder is:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Je kunt deze syntaxen combineren – je kunt de tweede ouder van de vorige reference krijgen (aangenomen dat het een merge commit was) door `HEAD~3^2` te gebruiken, enzovoort.

### Commit Reeksen ###

Nu dat je individuele commits kunt specificeren, laten we zien hoe je reeksen van commits kunt specificeren. Dit is erg bruikbaar om je branches te beheren – als je veel branches hebt, kun je reeks specificaties gebruiken om vragen te beantwoorden zoals, "Wat voor werk zit er op deze branch dat ik nog niet in mijn hoofdbranch heb?"

#### Dubbele Punt ####

De meest voorkomende reeks specificatie is de dubbele punt syntax. Dit vraagt Git eigenlijk om een reeks commits op te zoeken, die bereikbaar zijn van één commit maar niet vanuit een ander. Bijvoorbeeld, stel dat je een commit geschiedenis hebt die eruit ziet zoals Figuur 6-1.

Insert 18333fig0601.png 
Figuur 6-1. Voorbeeld geschiedenis voor reeksselectie.

Je wilt zien wat er in je experimentele branch zit, dat nog niet in je hoofdbranch gemerged is. Je kunt Git vragen om je een log te tonen van alleen die commits met `master..experiment` – wat betekend "alle commits die bereikbaar zijn door experiment, die niet bereikbaar zijn door master". Om de voorbeelden kort en duidelijk te houden zal ik de letters van de commit objecten in het diagram gebruiken in plaats van de echte log output, in de volgorde waarin ze getoond zouden worden:

	$ git log master..experiment
	D
	C

Als je aan de andere kant het tegenovergestelde wilt zien – alle commits in `master` die niet bereikbaar zijn in `experiment` – dan kun je de branch namen omdraaien. `experiment..master` toont je alles in `master` wat niet bereikbaar is in `experiment`:

	$ git log experiment..master
	F
	E

Dit is handig als je de `experiment` branch up to date wilt houden en vast wilt zien wat je op het punt staat te mergen. Een ander veel voorkomend gebruik van deze syntax is zien wat je op het punt staat naar een remote de pushen:

	$ git log origin/master..HEAD

Dit commando toont je alle commits in je huidige branch, die niet in de `master` branch op je `origin` remote zitten. Als je een `git push` uitvoerd, en je huidige branch volgt de `origin/master`, dan zijn de commits die getoond worden door `git log origin/master..HEAD` de commits die overgezet zullen worden naar de server.
Je kunt ook één kant van de syntax weglaten en Git de HEAD laten aannemen. Bijvoorbeeld, je krijgt dezelfde resultaten als in het vorige voorbeeld door `git log origin/master..` in te typen – Git vult HEAD in als er een kant mist.

#### Meerdere Punten ####

De dubbele punt is makkelijk als een afkorting; maar misschien wil je meer dan twee branches specificeren om je revisie aan te geven, zoals zien welke commits in één van een serie branches zit, die nog niet in de branch zit waar je nu op zit. Git laat je dit doen door of het `^` karakter te gebruiken, of `--not` voor iedere referentie waarvan je de bereikbare commits niet wilt zien. Dus deze drie commando's zijn gelijk:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Dit is fijn omdat met deze syntax je meer dan twee referenties in je vraag kunt specificeren, wat je niet met de dubbele put syntax kan. Bijvoorbeeld, als je alle commits wilt zien die bereikbaar zijn vanuit `refA` of `refB`, maar niet vanuit `refC`, dan kun je één van deze intypen:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Dit zorgt voor een erg krachtig revisie vraagsysteem dat je zou moeten helpen om uit te zoeken wat in je branches zit.

#### Drievoudige Punt ####

De laatste veelgebruikte reeks-selectie syntax is de drievoudige punt syntax, wat alle commits specificeerd die bereikbaar zijn door één van de twee referenties, maar niet door allebei. Kijk nog eens naar de voorbeeld commit geschiedenis in Figuur 6-1.
Als je wilt zien wat in je `master` of in je `experiment` zit, maar geen gedeelde referenties, dan kun je dit uitvoeren

	$ git log master...experiment
	F
	E
	D
	C

Nogmaals, dit geeft je normale `log` output, maar toont je alleen de commit informatie voor die vier commits, getoond in de traditionele commit datum volgorde.

Een veelgebruikte optie bij het `log` command in dit geval is `--left-right`, wat je laat zien aan welke kant van de reeks elke commit zit. Dit helpt de data bruikbaarder te maken:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Met deze tools, kun je Git eenvoudiger laten weten welke commit of commits je wilt inspecteren.

## Interactief Stagen ##

Bij Git zitten een aantal scripts, die sommige commando-regel taken makkelijker maken. Hier zul je een aantal interactieve commando's zien, die je kunnen helpen om je commits zo te maken dat ze alleen bepaalde combinaties en delen van bestanden bevatten. Deze tools zijn erg bruikbaar als je een serie bestanden aanpast en dan besluit dat je deze veranderingen in een aantal gefocuste commits wilt hebben in plaats van een rommelige commit. Op deze manier ben je er zeker van dat je commits logische aparte wijzigingensets zijn en makkelijk gereviewed kunnen worden door je mede-ontwikkelaars.
Als je `git add` uitvoert met de `-i` of `--interactive` optie, dan gaat Git over in de interactieve shell modus, waarbij zoiets als dit getoond wordt:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 

Je kunt zien dat dit commando je een heel andere view van je staging gebied geeft – eigenlijk dezelfde informatie die je krijgt met het `git status` commando, maar dan compacter en meer informatief. Het toont links de wijzigingen die je gestaged hebt, en de niet gestagede wijzigingen rechts.

Hierna komt een Commando sectie. Hier kun je een aantal dingen mee doen, inclusief bestanden stagen, bestanden unstagen, delen van bestanden stagen, ongevolgde bestanden toevoegen, en diffs zien van wat gestaged is.

### Bestanden Stagen en Unstagen ###

Als je `2` of `u` op de `What now>` prompt typted, dan vraagt he script welke bestanden je wilt stagen:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Om de TODO en index.html bestanden te stagen, kun je de nummers typen:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Het `*` naast ieder bestand betekend dat het bestand geselecteerd staat om gestaged te worden. Als je Enter indrukt na niets getyped te hebben op de `Update>>` prompt, dan zal Git alles wat geselecteerd staat pakken en voor je stagen:

	Update>> 
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Nu kun je zien dat de TODO en index.html bestanden gestaged zijn, en het simplegit.rb bestand nog unstaged is. Als je het TODO bestand wilt unstagen op dit punt, dan gebruik je de `3` of `r` (voor revert) optie:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

Nogmaals kijkend naar je Git status, kun je zien dat je het TODO bestand unstaged hebt:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Om de diff te zien van wat je gestaged hebt, kun je het `6` of `d` (voor diff) commando gebruiken. Het toont je een lijst van je gestagede bestanden, en je kunt degenen selecteren waarvan je de gestagede diff wilt zien. Dit is vergelijkbaar met het specificeren van `git diff --cached` op de commando regel:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

Met deze basis commando's, kun je de interactieve toevoeg modus gebruiken om een beetje makkelijker met je staging gebied om te gaan.

### Patches Stagen ###

Het is ook mogelijk met Git om bepaalde delen van bestanden te stagen en de rest niet. Bijvoorbeeld, als je twee wijzigingen maakt in je simplegit.rb bestand en één van die twee wilt stagen en de andere niet, dan is dat eenvoudig in Git. Vanaf de interactieve prompt, type `5` of `p` (voor patch). Git zal je vragen welke bestanden je deels wilt stagen; dan, voor iedere sectie van de geselecteerde bestanden, zal het stukken van de bestandsdiff tonen en je vragen of je ze wilt stagen, één voor één: 

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? 

Op dit punt heb je veel opties. Door `?` te typen krijg je een lijst met wat je kunt doen:

	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? ?
	y - stage this hunk
	n - do not stage this hunk
	a - stage this and all the remaining hunks in the file
	d - do not stage this hunk nor any of the remaining hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

Over het algemeen zul je `y` of `n` typen als je ieder stuk wilt stagen, maar ze allemaal ineens stagen voor bepaalde bestanden, of een beslissen een stuk over te slaan tot later kan ook behulpzaam zijn. Als je een gedeelte van het bestand wilt stagen en een ander gedeelte unstaged wilt laten, dan zal je status output er zo uitzien:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

De status van het simplegit.rb bestand is interessant. Het laat zien dat een paar regels gestaged zijn, en een paar niet. Je hebt dit bestand deels gestaged. Op dit punt kun je het interactieve toevoeg script verlaten en het `git commit` commando uitvoeren om de gedeeltelijk gestagede bestanden te committen.

Finally, you don’t need to be in interactive add mode to do the partial-file staging — you can start the same script by using `git add -p` or `git add --patch` on the command line. 
Tot slot hoef je niet in de interactieve toevoeg modus te zijn om het gedeeltelijke bestands-stagen te doen – je kunt hetzelfde script starten door `git add -p` of `git add --patch` op de commando regel te gebruiken.

## Stashen ##

Vaak, als je aan een deel van je project hebt zitten werken, zijn de dingen in een rommelige staat en wil je van branch veranderen om aan wat anders te werken. Het probleem is dat je geen halfklaar werk wilt committen, alleen maar om later verder te kunnen gaan op dit punt. Het antwoord op dit probleem is het `git stash` commando.

Stashen pakt de vervuilde status van je werkmap – dat wil zeggen, je gewijzigde gevolgde bestanden en gestagede wijzingen – en bewaard het op een stapel onafgemaakte wijzigingen, die je op ieder tijdstip opnieuw kunt toepassen.

### Je Werk Stashen ###

Ter demonstratie, ga je in je project en begint met werken aan een paar bestanden en misschien stage je een van de wijzigingen. Als je `git status` uitvoerd, kun je je vervuilde status zien:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Nu wil je van branch veranderen, maar je wilt hetgeen je aan hebt zitten werken nog niet committen; dus ga je de wijzigingen stashen. Om een nieuwe stash op je stapel te duwen, voer dan `git stash` uit:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Je werkmap is schoon:

	$ git status
	# On branch master
	nothing to commit (working directory clean)

Op dit punt kun je makkelijk van branch wisselen en ergens anders werken; je wijzigingen worden opgeslagen op je stapel. Om te zien welke stashes je opgeslagen hebt, kun je `git stash list` gebruiken:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

In dit geval waren er twee stashes al eerder opgeslagen, dus heb je toegang tot drie verschillende gestashete werken. Je kunt degene die je zojuist gestashed hebt opnieuw toepassen, door het commando uit te voeren dat in de help output van het originele stash commando stond: `git stash apply`. Als je een van de oudere stashes wilt toepassen, dan kun je die specificeren door hem te noemen, zoals hier: `git apply stash stash@{2}`. Als je geen stash specificeerd, gaat Git uit van de meest recente stash en probeert die toe te passen:

	$ git stash apply
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Je kunt zien dat Git opnieuw de bestanden wijzigt, die je uncommitte toen je de stash opsloeg. In dit geval had je een schone werkmap toen je de stash probeerde toe te passen, en probeerde je hem op dezelfde branch toe te passen als waar je hem van opgeslagen hebt; maar het hebben van een schone werkmap en toepassen op dezelfde branch zijn niet noodzakelijk om een stash succesvol toe te kunnen passen. Je kunt een stash op één branch opslaan, later naar een andere branch wisselen, en daar opnieuw de wijzigingen toe proberen te passen. Je kunt ook gewijzigde en uncommitted bestanden in je werkmap hebben wanneer je een stash probeert toe te passen – Git geeft je merge conflicten als iets niet meer netjes toe te passen is.

De wijzigingen aan je bestanden zijn opnieuw toegepast, maar het bestand dat je eerder gestaged had, is niet opnieuw gestaged. Om dat te doen moet je het `git stash apply` commando met de `--index` optie uitvoeren om het commando te vertellen de gestagede wijzigingen opnieuw toe te passen. Als je dat had uitgevoerd, dan zou je weer op je originele vertrekpunt zijn uitgekomen:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

De apply optie probeert alleen het gestashete werk toe te passen – je blijft het op je stapel behouden. Om het te verwijderen, kun je `git stash drop` uitvoeren, met de naam van de stash die je wilt verwijderen:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Je kunt ook `git stash pop` uitvoeren om de stash toe te passen en hem onmiddelijk van je stapel te verwijderen.

### Een Branch Van Een Stash Maken ###

Als je wat werk stashet, het een poosje laat rusten, en dan doorwerkt op de branch waarvan je het werk gestashet hebt, dan kun je een probleem krijgen met het werk weer toe te passen. Als het toepassen een bestand probeert te wijzigen dat je sindsdien gewijzigd hebt, krijg je een merge conflict en zul je het moeten oplossen. Als je een eenvoudiger manier wilt hebben om je gestashete wijzigingen opnieuw te testen, kun je `git stash branch` uitvoeren, wat een nieuwe branch voor je zal aanmaken, de commit waar je op zat toen je het werk stashte weer uitchecken, je werk opnieuw toepassen en dan de stash droppen als het succesvol is toegepast:

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Dit is een fijne korte route om gestashed werk eenvoudig terug te halen en aan te werken in een nieuwe branch.

## Geschiedenis Herschrijven ##

Vaak zul je, als je met Git werkt, je commit geschiedenis om een of andere reden willen aanpassen. Eén van de mooie dingen van Git is dat het je toelaat om beslissingen op het laatste moment te kunnen maken. Je kunt bepalen welke bestanden in welke commits gaan vlak voordat je commit op het staging gebied, je kunt beslissen dat je niet aan iets bedoelde te werken met het stash commando en je kunt commits herschrijven ook al zijn ze reeds gebeurd, zodat het lijkt alsof ze op een andere manier gebeurd zijn. Dit kan bijvoorbeeld de volgorde van de commits zijn, berichten of bestanden wijzigen, commits samenvoegen of opsplitsen, of complete commits weghalen – dat alles voordat je je werk met anderen deelt.

In deze sectie zul je leren hoe je deze handige taken doet, zodat je je commit geschiedenis er uit kunt laten zien zoals jij dat wilt, voordat je hem met anderen deelt.

### De Laatste Commit Veranderen ###

De laatste commit veranderen is waarschijnlijk de meest voorkomende geschiedenis wijziging die je wilt doen. Vaak wil je twee basale dingen aan je laatste commit wijzigen: het commit bericht, of het snapshot dat je zojuist opgeslagen hebt wijzigen door het toevoegen, wijzigen of weghalen van bestanden.

Als je alleen je laatste commit bericht wilt wijzigen, dan is dat heel eenvoudig:

	$ git commit --amend

Dat plaatst je in je teksteditor, met je laatste commit bericht erin, klaar voor jou om je bericht te wijzigen. Als je de editor opslaat en sluit, dan schrijft de editor een nieuwe commit met dat bericht en maakt dat je laatste commit.

Als je hebt gecommit en je wilt het snapshot dat je gecommit hebt wijzigen, door het toevoegen of wijzigen van bestanden, misschien omdat je vergeten was een nieuw bestand toe te voegen toen je committe, werkt het proces ongeveer op dezelfde manier. Je staged de wijzigingen die je wilt door een bestand te wijzigen en `git add` er op uit te voeren, of `git rm` op een gevolgd bestand, en de daaropvolgende `git commit --amend` pakt je huidige staging gebied en maakt dat het snapshot voor de nieuwe commit.

Je moet oppassen met deze techniek, omdat het amenden de SHA-1 van de commit wijzigt. Het is vergelijkbaar met een kleine rebase – niet je laatste commit wijzigen als je die al gepushed hebt.

### Meerdere Commit Berichten Wijzigen ###

Om een commit te wijzigen die verder terug in je geschiedenis zit, moet je naar complexere tools gaan. Git heeft geen geschiedenis-wijzig tool, maar je kunt het rebase tool gebruiken om een serie commits op de HEAD waarvan ze origineel gebaseerd waren te rebasen, in plaats van ze naar een andere te verhuizen. Met het interactieve rebase tool, kun je dan na iedere commit die je wilt wijzigen stoppen en het bericht wijzigen, bestanden toevoegen, of doen wat je ook maar wilt. Je kunt rebase interactief uitvoeren door de `-i` optie aan `git rebase` toe te voegen. Je moet aangeven hoe ver terug je commits wilt herschrijven door het commando te vertellen op welke commit het moet rebasen.

Bijvoorbeeld, als je de laatste drie commit berichten wilt veranderen, of een van de commit berichten in die groep, dan geef je de ouder van de laatste commit die je wilt wijzigen mee als argument aan `git rebase -i`, wat `HEAD~2^` of `HEAD~3` is. Het kan makkelijker zijn om de `~3` te onthouden, omdat je de laatste drie commits probeert te wijzigen; maar houd in gedachten dat je eigenlijk vier commits terug aangeeft; de ouder van de laatste commit die je wilt veranderen:

	$ git rebase -i HEAD~3

Onthoud ook dat dit een rebase commando is – iedere commit in de serie `HEAD~3..HEAD` zal worden herschreven, of je het bericht wijzigt of niet. Voeg geen commit toe die je al naar een centrale server gepushed hebt – als je dit doet breng je andere gebruikers in de war door ze een alternatieve versie van dezelfde wijziging te geven.

Dit commando uitvoeren geeft je een lijst met commits in je tekst editor die er ongeveer zo uit ziet:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Het is belangrijk om te zien dat deze commits in de omgekeerde volgorde getoond worden dan wanneer je ze normaliter ziet als je het `log` commando gebruikt. Als je een `log` uitvoert, zie je zoiets als dit:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Zie de omgekeerde volgorde. De interactieve rebase geeft je een script dat het gaat uitvoeren. Het zal beginnen met de commit die je specificeerd op de commando regel (`HEAD~3`), en de wijzigingen in ieder van deze commits opnieuw afspelen van bove naar beneden. Het toont de oudste aan de bovenkant, in plaats van de nieuwste, omdat dat de eerste is die het zal afspelen.

Je moet het script wijzigen zodat het stopt bij de commit die je wilt wijzigen. Om dat te doen moet je het woord pick veranderen in het woord edit voor ieder van de commits waarbij je het script wilt laten stoppen. Bijvoorbeeld, om alleen het derde commit bericht te wijzigen, verander je het bestand zodat het er zo uitziet:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Als je de editor opslaat en sluit, plaatst Git je terug in de laatste commit van die lijst en zet je op de commando regel met de volgende boodschap:

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Deze instructies vertellen je precies wat je moet doen. Type

	$ git commit --amend

Wijzig het commit bericht, en verlaat de editor. Voer daarna dit uit

	$ git rebase --continue

Dit commando zal de andere twee commits automatisch toepassen, en dan ben je klaar. Als je pick in edit veranderd op meerdere regels, dan kun je deze stappen herhalen voor iedere commit die je in edit veranderd hebt. Iedere keer zal Git stoppen, je de commit laten amenden, en verder gaan waar je gewijzigd bent.

### Commits Rangschikken ###

Je kunt een interactieve rebase ook gebruiken om commits te rangschikken of volledig te verwijderen. Als je de "added cat-file" commit wilt verwijderen en de volgorde waarin de andere twee commits zijn geintroduceerd wilt veranderen, dan kun je het rebase script van dit

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

veranderen in dit:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Als je de editor opslaat en sluit, zal Git je branch terugzetten naar de ouder van deze commits, eerst `310154e` en dan `f7f3f6d` toepassen, en dan stoppen. Effectief verander je de volgorde van die commits en verwijder je de "added cat-file" commit in zijn geheel.

### Een Commit Squashen ###

Het is ook mogelijk een serie commits te pakken en ze in één enkele commit te squashen met het interactieve rebase tool. Het script stopt behulpzame instructies in het rebase bericht:

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Als je, in plaats van "pick" of "edit", "squash" specificeert zal Git zowel die verandering als de verandering die er direct aan vooraf gaat toepassen, en je dwingen om de merge berichten samen te voegen. Dus als je een enkele commit van deze drie commits wil maken, laat je het script er zo uit zien:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Als je de editor opslaat en sluit, zal Git alledrie de veranderingen toepassen en je terug in de editor brengen om de drie commit berichten samen te voegen:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Als je dat opslaat, heb je een enkele commit die de veranderingen van alledrie de vorige commits introduceerd.

### Een Commit Splitsen ###

Een commit opsplitsen zal een commit ongedaan maken, en dan zo vaak als het aantal commits waar je mee wilt eindigen gedeeltelijk stagen en committen. Bijvoorbeld, stel dat je de middelste van je drie commits wilt splitsen. In plaats van "updated README formatting and added blame", wil je het splitsen in twee commits: "updated README formatting" als eerste, en "added blame" als tweede. Je kunt dat doen in het `rebase -i` script door de instructie van de commit die je wilt splitsen te veranderen in "edit":

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Als het script je dan op de commando regel zet, reset je die commit, neemt de wijzigingen die zijn gereset, en maakt daar meerdere commits van.Als je de editor opslaat en sluit, zal Git teruggaan naar de ouder van de eerste commit in je lijst, de eerste commit toepassen (`f7f3f6d`), de tweede commit toepassen (`310154e`), en je op de console plaatsen. Dan kun je een gemengde reset van die commit doen met `git reset HEAD^`, wat effectief die commit ongedaan maakt en de gewijzigde bestanden unstaged laat. Nu kun je bestanden stagen en committen totdat je meerdere commits hebt, en `git rebase --continue` uitvoeren zodra je klaar bent:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git zal de laatste commit (`a5f4a0d`) in het script toepassen, en je geschiedenis zal er zo uitzien:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Nogmaals, dit veranderd alle SHA's van alle commits in je lijst, dus zorg er voor dat er geen commit in die lijst zit die je al naar een gedeeld repository gepushed hebt.

### The Nuclear Option: filter-branch ###

There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit. The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite. However, it can be very useful. You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of.

#### Removing a File from Every Commit ####

This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your project open source. `filter-branch` is the tool you probably want to use to scrub your entire history. To remove a file named passwords.txt from your entire history, you can use the `--tree-filter` option to `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

The `--tree-filter` option runs the specified command after each checkout of the project and then recommits the results. In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch --tree-filter 'rm -f *~' HEAD`.

You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end. It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want. To run `filter-branch` on all your branches, you can pass `--all` to the command.

#### Making a Subdirectory the New Root ####

Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on). If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Now your new project root is what was in the `trunk` subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory. 

#### Changing E-Mail Addresses Globally ####

Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address. In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well. You need to be careful to change only the e-mail addresses that are yours, so you use `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address.

## Debugging with Git ##

Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.

### File Annotation ###

If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22:

	$ git blame -L 12,22 simplegit.rb 
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19) 
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.

Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:

	$ git blame -C -L 141,153 GITPackUpload.m 
	f344f58d GITServerHandler.m (Scott 2009-01-04 141) 
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file.

### Binary Search ###

Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.

Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:

	$ git bisect reset

This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.

## Submodules ##

It often happens that while working on one project, you need to use another project from within it. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.

Here’s an example. Suppose you’re developing a web site and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.

Git addresses this issue using submodules. Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.

### Starting with Submodules ###

Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes. The first thing you should do is clone the external repository into your subdirectory. You add external projects as submodules with the `git submodule add` command:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Now you have the Rack project under a subdirectory named `rack` within your project. You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more. If you run `git status` right after you add the submodule, you see two things:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

First you notice the `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file. It’s pushed and pulled with the rest of your project. This is how other people who clone this project know where to get the submodule projects from.

The other listing in the `git status` output is the rack entry. If you run `git diff` on that, you see something interesting:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory. Instead, Git records it as a particular commit from that repository. When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly.

This is an important point with submodules: you record them as the exact commit they’re at. You can’t record a submodule at `master` or some other symbolic reference.

When you commit, you see something like this:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Notice the 160000 mode for the rack entry. That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file.

You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject. All the Git commands work independently in the two directories:

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### Cloning a Project with Submodules ###

Here you’ll clone a project with a submodule in it. When you receive such a project, you get the directories that contain submodules, but none of the files yet:

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

The `rack` directory is there, but empty. You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Now your `rack` subdirectory is at the exact state it was in when you committed earlier. If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory. To fix this, you must run `git submodule update` again:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

You have to do this every time you pull down a submodule change in the main project. It’s strange, but it works.

One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server. Then, they commit a pointer to that non-public state and push up the superproject. When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system. If that happens, you see an error like this:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

You have to see who last changed the submodule:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Then, you e-mail that guy and yell at him.

### Superprojects ###

Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on. This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow.

A good way to do this in Git is to make each of the subfolders a separate Git repository and then create superproject Git repositories that contain multiple submodules. A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects.

### Issues with Submodules ###

Using submodules isn’t without hiccups, however. First, you must be relatively careful when working in the submodule directory. When you run `git submodule update`, it checks out the specific version of the project, but not within a branch. This is called having a detached head — it means the HEAD file points directly to a commit, not to a symbolic reference. The issue is that you generally don’t want to work in a detached head environment, because it’s easy to lose changes. If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.  Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieive.

To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent. When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to.

Switching branches with submodules in them can also be tricky. If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory:

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up.

The last main caveat that many people run into involves switching from subdirectories to submodules. If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you. Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule. If you delete the subdirectory and then run `submodule add`, Git yells at you:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

You have to unstage the `rack` directory first. Then you can add the submodule:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Now suppose you did that in a branch. If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Then, when you switch back, you get an empty `rack` directory. You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory.

## Subtree Merging ##

Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a _recursive_ strategy. If you’re merging more than two branches, Git picks the _octopus_ strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.

However, there are other strategies you can choose as well. One of them is the _subtree_ merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.

The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.

You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch. If you check out one and then the other, you can see that they have different project roots:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

You want to pull the Rack project into your `master` project as a subdirectory. You can do that in Git with `git read-tree`. You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project:

	$ git read-tree --prefix=rack/ -u rack_branch

When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:

	$ git checkout rack_branch
	$ git pull

Then, you can merge those changes back into your master branch. You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the `--squash` and `--no-commit` options as well as the `-s subtree` strategy option:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream.

To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command. Instead, you must run `git diff-tree` with the branch you want to compare to:

	$ git diff-tree -p rack_branch

Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run

	$ git diff-tree -p rack_remote/master

## Summary ##

You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely. When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom. If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs. At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so.
