# Git Tools #

Nu heb je de meeste commando's en werkwijzen geleerd die je dagelijks nodig hebt om een Git repository voor je broncode te beheren en te onderhouden. Je hebt de basistaken van het tracken en committen van bestanden uitgevoerd, en je hebt de kracht van de staging area en lichtgewicht topic branching en mergen in handen.

Nu ga je een aantal zeer krachtige dingen verkennen die Git kan, die je niet per se dagelijks gebruikt, maar die je op een bepaald punt toch nodig kunt hebben.

## Revisie Selectie ##

Git staat je toe om specifieke commits of een serie commits op meerdere manieren te specificeren. Ze zijn niet per se voor de hand liggend, maar behulpzaam om te weten.

### Enkele Revisies ###

Natuurlijk kun je naar een commit refereren door de SHA-1 hash die het toegekend is, maar er zijn ook meer mensvriendelijke manieren om naar een commit te refereren. Deze sectie laat de diverse manieren zien waarop je naar een enkele commit kunt refereren.

### Korte SHA ###

Git is slim genoeg om uit te vinden welke commit je bedoelde te typen als je de eerste karakters opgeeft, zolang je gedeeltelijke SHA-1 minstens vier karakters lang en ondubbelzinnig is – dat wil zeggen dat slechts één object in de huidige repository begint met die gedeeltelijke SHA-1.

Bijvoorbeeld, stel dat je om een specifieke commit te zien een `git log` commando uitvoert en de commit identificeert waarin je een bepaalde functionaliteit hebt toegevoegd:

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

In dit geval, kies `1c002dd...`. Als je op die commit `git show` uitvoert, dan zijn de volgende commando's equivalent (aangenomen dat de kortere versies ondubbelzinnig zijn):

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

Maar, je moet je bewust zijn hoe belachelijk onwaarschijnlijk dit scenario is. De SHA-1 waarde is 20 bytes of 160 bits. Het aantal benodigde random gehashte objecten om een 50% waarschijnlijkheid van een enkele botsing te garanderen is ongeveer 2^80 (de formule om botsingswaarschijnlijkheid te bepalen is `p = (n(n-1)/2) * (1/2^160)`). 2^80 is 1.2 x 10^24 of 1 miljoen miljard miljad. Dat is 1.200 keer het aantal zandkorrels op de aarde.

Hier is een voorbeeld om je een idee te geven wat er voor nodig is om een SHA-1 botsing te krijgen. Als alle 6.5 miljard mensen op aarde zouden gaan programmeren, en iedere seconde zou iedereen code genereren die gelijk was aan de hele Linux kernel-geschiedenis (1 miljoen Git objecten) en dat in één gigantische Git repository pushen, dan zou het vijf jaar duren voordat die repository genoeg objecten zou bevatten om een 50% waarschijnlijkheid van één enkele SHA-1 object botsing te krijgen. Er bestaat een grotere kans dat ieder lid van je programmeerteam zal worden aangevallen en worden gedood door wolven in ongerelateerde incidenten op dezelfde avond.

### Branch Referenties ###

De meest eenvoudige manier om een commit te specificeren heeft als voorwaarde dat je er een branchreferentie naar hebt wijzen. Dan kun je een branchnaam in ieder Git commando gebruiken dat een commitobject of SHA-1 waarde verwacht. Bijvoorbeeld, als je het laatste commitobject op een branch wil tonen, dan zijn de volgende commando's gelijk, aangenomen dat de `topic1` branch naar `ca82a6d` wijst:

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Als je wil zien naar welke specifieke SHA een branch wijst, of als je wil zien wat ieder van deze voorbeelden in termen van SHA's voorstellen, dan kun je een Git onderwatertool genaamd `rev-parse` gebruiken. Je kunt in Hoofdstuk 9 kijken voor meer informatie over onderwatertools; eigenlijk bestaat `rev-parse` voor low-level operaties en is niet ontworpen om in dagelijkse operaties gebruikt te worden. Maar, het kan behulpzaam zijn op momenten dat je moet zien wat er echt aan de hand is. Hier kun je `rev-parse` uitvoeren op je branch.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### RefLog Afkortingen ###

Een van de dingen die Git in de achtergrond doet terwijl jij zit te werken is een reflog bijhouden – een log waar je HEAD en branchreferenties zijn gebleven in de laatste paar maanden.

Je kunt je reflog zien door `git reflog` te gebruiken:

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Iedere keer als de punt van je branch om een of andere reden is gewijzigd, dan bewaart Git die informatie voor je in deze tijdelijke geschiedenis. En je kunt ook oudere commits hiermee specificeren. Als je de vijfde voorgaande waarde van de HEAD van je repository wil zien, dan kun je de `@{n}` referentie gebruiken, die je in de reflog output kunt zien:

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

Het is belangrijk om te zien dat deze informatie strikt lokaal is – het is een log van wat jij hebt gedaan in jouw repository. De referenties zullen niet hetzelfde zijn in iemand anders zijn kopie van de repository; en meteen nadat je een eerste kloon van een repository hebt gemaakt, heb je een lege reflog, omdat er nog geen aktiviteit is geweest in je repository. `git show HEAD@{2.months.ago}` uitvoeren werkt alleen als je het project minstens twee maanden geleden gekloond hebt – als je het vijf minuten geleden gekloond hebt, krijg je geen resultaten.

### Voorouder Referenties ###

De andere veelgebruikte manier om een commit te specificeren is via zijn voorouder. Als je een `^` aan het einde van een referentie zet, zal Git hieruit herleiden dat het de ouder van de commit betekent.
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

Dan zie je de vorige commit door `HEAD^` te specificeren, wat "de ouder van HEAD" betekent:

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Je kunt ook een nummer na de `^` zetten – bijvoorbeeld, `d921970^2` betekent "de tweede ouder van d921970." Deze syntax is alleen bruikbaar voor merge commits, die meer dan één ouder hebben. De eerste ouder is de branch waar jij op was toen je merge-te, en de andere is de commit op de branch die in ingemerged hebt:

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

De andere manier om ouders mee te specificeren is de `~`. Dit refereert ook naar de eerste ouder, dus `HEAD~` en `HEAD^` zijn gelijk. Het verschil wordt duidelijk als je een nummer specificeert. `HEAD~2` betekent "de eerste ouder van de eerste ouder", of "de grootouder" – het bewandelt de eerste ouders het aantal keren dat je specificeert. Bijvoorbeeld, in de geschiedenis die eerder getoond werd, zou `HEAD~3` zijn

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

De meest voorkomende reeks specificatie is de dubbele punt syntax. Dit vraagt Git een reeks commits op te zoeken, die bereikbaar zijn van één commit maar niet vanuit een ander. Bijvoorbeeld, stel dat je een commitgeschiedenis hebt die eruit ziet zoals in Figuur 6-1.

Insert 18333fig0601.png 
Figuur 6-1. Voorbeeldgeschiedenis voor reeksselectie.

Je wilt zien wat er in je experimentele branch zit dat nog niet in je hoofdbranch gemerged is. Je kunt Git vragen om je een log te tonen van alleen die commits met `master..experiment` – wat betekent "alle commits die bereikbaar zijn door experiment, die niet bereikbaar zijn door master". Om de voorbeelden kort en duidelijk te houden zal ik de letters van de commitobjecten in het diagram gebruiken in plaats van de echte log output, in de volgorde waarin ze getoond zouden worden:

	$ git log master..experiment
	D
	C

Als je aan de andere kant het tegenovergestelde wilt zien – alle commits in `master` die niet bereikbaar zijn in `experiment` – dan kun je de branchnamen omdraaien. `experiment..master` toont je alles in `master` wat niet bereikbaar is in `experiment`:

	$ git log experiment..master
	F
	E

Dit is handig als je de `experiment` branch up to date wilt houden en vast wilt zien wat je op het punt staat te mergen. Een ander veel voorkomend gebruik van deze syntax is zien wat je op het punt staat naar een remote de pushen:

	$ git log origin/master..HEAD

Dit commando toont je alle commits in je huidige branch, die niet in de `master` branch op je `origin` remote zitten. Als je een `git push` uitvoert, en je huidige branch volgt de `origin/master`, dan zijn de commits die getoond worden door `git log origin/master..HEAD` de commits die verstuurd zullen worden naar de server.
Je kunt ook één kant van de syntax weglaten en Git de HEAD laten aannemen. Bijvoorbeeld, je krijgt dezelfde resultaten als in het vorige voorbeeld door `git log origin/master..` te typen – Git vult HEAD in als er een kant mist.

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

De laatste veelgebruikte reeks-selectie syntax is de drievoudige punt syntax, wat alle commits specificeert die bereikbaar zijn door één van de twee referenties, maar niet door allebei. Kijk nog eens naar de voorbeeld commitgeschiedenis in Figuur 6-1.
Als je wilt zien wat in je `master` of in je `experiment` zit, maar geen gedeelde referenties, dan kun je dit uitvoeren

	$ git log master...experiment
	F
	E
	D
	C

Nogmaals, dit geeft je normale `log` output, maar toont je alleen de commitinformatie voor die vier commits, getoond in de traditionele committijdstip volgorde.

Een veelgebruikte optie bij het `log` command in dit geval is `--left-right`, wat je laat zien aan welke kant van de reeks elke commit zit. Dit helpt de data bruikbaarder te maken:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Met deze tools, kun je Git eenvoudiger laten weten welke commit of commits je wilt inspecteren.

## Interactief Stagen ##

Bij Git zitten een aantal scripts, die sommige commandline taken makkelijker maken. Hier zul je een aantal interactieve commando's zien, die je kunnen helpen om je commits zo te maken dat ze alleen bepaalde combinaties en delen van bestanden bevatten. Deze tools zijn erg bruikbaar als je een serie bestanden aanpast en dan besluit dat je deze veranderingen in een aantal gefocuste commits wilt hebben in plaats van een rommelige commit. Op deze manier ben je er zeker van dat je commits logische aparte wijzigingensets zijn en makkelijk gereviewed kunnen worden door je mede-ontwikkelaars.
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

Je kunt zien dat dit commando je een heel andere view van je staging area geeft – eigenlijk dezelfde informatie die je krijgt met het `git status` commando, maar dan compacter en meer informatief. Het toont links de wijzigingen die je gestaged hebt, en de niet gestagede wijzigingen rechts.

Hierna volgt een commandosectie. Hier kun je een aantal dingen mee doen, inclusief bestanden stagen, bestanden unstagen, delen van bestanden stagen, ongevolgde bestanden toevoegen, en diffs zien van wat gestaged is.

### Bestanden Stagen en Unstagen ###

Als je `2` of `u` op de `What now>` prompt typted, dan vraagt het script welke bestanden je wilt stagen:

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

De `*` naast ieder bestand betekent dat het bestand geselecteerd staat om gestaged te worden. Als je Enter indrukt na niets getyped te hebben op de `Update>>` prompt, dan zal Git alles wat geselecteerd staat pakken en voor je stagen:

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

Met deze basiscommando's kun je de interactieve toevoegmodus gebruiken om een beetje makkelijker met je staging area om te gaan.

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

Vaak zul je, als je met Git werkt, je commit geschiedenis om een of andere reden willen aanpassen. Eén van de mooie dingen van Git is dat het je toelaat om beslissingen op het laatste moment te kunnen maken. Je kunt bepalen welke bestanden in welke commits gaan vlak voordat je commit op het staging area, je kunt beslissen dat je niet aan iets bedoelde te werken met het stash commando en je kunt commits herschrijven ook al zijn ze reeds gebeurd, zodat het lijkt alsof ze op een andere manier gebeurd zijn. Dit kan bijvoorbeeld de volgorde van de commits zijn, berichten of bestanden wijzigen, commits samenvoegen of opsplitsen, of complete commits weghalen – dat alles voordat je je werk met anderen deelt.

In deze sectie zul je leren hoe je deze handige taken doet, zodat je je commit geschiedenis er uit kunt laten zien zoals jij dat wilt, voordat je hem met anderen deelt.

### De Laatste Commit Veranderen ###

De laatste commit veranderen is waarschijnlijk de meest voorkomende geschiedenis wijziging die je wilt doen. Vaak wil je twee basale dingen aan je laatste commit wijzigen: het commit bericht, of het snapshot dat je zojuist opgeslagen hebt wijzigen door het toevoegen, wijzigen of weghalen van bestanden.

Als je alleen je laatste commit bericht wilt wijzigen, dan is dat heel eenvoudig:

	$ git commit --amend

Dat plaatst je in je teksteditor, met je laatste commit bericht erin, klaar voor jou om je bericht te wijzigen. Als je de editor opslaat en sluit, dan schrijft de editor een nieuwe commit met dat bericht en maakt dat je laatste commit.

Als je hebt gecommit en je wilt het snapshot dat je gecommit hebt wijzigen, door het toevoegen of wijzigen van bestanden, misschien omdat je vergeten was een nieuw bestand toe te voegen toen je committe, werkt het proces ongeveer op dezelfde manier. Je staged de wijzigingen die je wilt door een bestand te wijzigen en `git add` er op uit te voeren, of `git rm` op een gevolgd bestand, en de daaropvolgende `git commit --amend` pakt je huidige staging area en maakt dat het snapshot voor de nieuwe commit.

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

### De Nucleaire Optie: filter-branch ###

Er is nog een geschiedenis-herschrijvende optie, die je kunt gebruiken als je een groter aantal commits moet herschrijven in een scriptbare manier – bijvoorbeeld, het globaal veranderen van je e-mail adres of een bestand uit iedere commit verwijderen. Het commando heet `filter-branch`, en het kan grote gedeelten van je geschiedenis herschrijven, dus je moet het niet gebruiken tenzij je project nog niet publiekelijk is gemaakt en andere mensen nog geen werk hebben gebaseerd op jouw commits, die je op het punt staat te herschrijven. Maar het kan heel handig zijn. Je zult een paar gebruikelijke toepassingen leren zodat je een idee kunt krijgen van de mogelijkheden.

#### Een Bestand Uit Iedere Commit Verwijderen ####

Dit gebeurd vrij vaak. Iemand voegt per ongeluk een enorm binair bestand toe met een gedachteloze `git add .`, en je wilt het overal weghalen. Misschien heb je per ongeluk een bestand toegevoegd dat een wachtwoord bevat, en wil je je project open source maken. `filter-branch` is het tool dat je waarschijnlijk wil gebruiken om je hele geschiedenis schoon te vegen. Om een bestand genaamd passwords.txt uit je hele geschiedenis weg te halen, kun je de `--tree-filter` optie toevoegen aan `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

De `--tree-filter` optie voert het gegeven commando uit na iedere checkout van het project, en commit de resultaten weer. In dit geval, verwijder je een bestand gnaamd passwords.txt van iedere snapshot, of het bestaat of niet. Als je alle per ongeluk toegevoegde editor backup bestanden wilt verwijderen, kun je zoiets als dit uitvoeren `git filter-branch --tree-filter 'rm -f *~' HEAD`.

Je kunt Git bomen en commits zien herschrijven en de branch wijzer aan het einde zien verplaatsen. Het is over het algemeen een goed idee om dit in een test branch te doen, en dan je master branch te hard-resetten nadat je gecontroleerd hebt dat de uitkomst echt zo is als je wil. Om `filter-branch` op al je branches uit te voeren, kun je `--all` aan het commando meegeven.

#### Een Subdirectory Het Nieuwe Beginpunt Maken ####

Stel dat je een import vanuit een ander versiebeheersysteem hebt gedaan, en subdirectories hebt die geen zin maken (trunk, tags enzovoort). Als je de `trunk` subdirectory het nieuwe beginpunt van het project wilt maken voor iedere commit, dan kan `filter-branch` je daar ook mee helpen:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Nu is je nieuwe project wat het was in de `trunk` subdirectory. Git zal ook automatisch commits verwijderen, die geen effect hadden op de subdirectory.

#### E-Mail Adressen Globaal Veranderen ####

Een ander veel voorkomend geval is dat je vergeten bent om `git config` uit te voeren om je naam en e-mail adres in te stellen voordat je bent begonnen met werken, of misschien wil je een project op het werk open source maken en al je werk e-mail adressen veranderen naar je privé adres. In ieder geval kun je e-mail adressen in meerdere commits ook ineens veranderen met `filter-branch`. Je moet wel oppassen om alleen de e-mail adressen aan te passen, die van jou zijn, dus gebruik je `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

Dit gaat door en herschrijft iedere commit zodat het jouw nieuwe adres bevat. Om dat commits de SHA-1 waarde van hun ouders bevatten, zal dit commando iedere commit SHA in jouw geschiedenis veranderen, niet alleen degenen die het passende e-mail adress bevatten.

## Debuggen Met Git ##

Git levert ook een paar tools om je problemen te helpen debuggen in je projecten. Omdat Git is ontworpen te werken met bijna ieder type project, zijn deze tools erg generiek, maar ze kunnen je vaak helpen op een bug of veroorzaker te jagen als de dingen verkeerd gaan.

### Bestandsannotatie ###

Als je een bug in je code traceert en wilt weten wanneer het was geintroduceerd en waarom, dan is bestandsannotatie vaak je beste tool. Het toont je welke commit de laatste was die iedere regel in een bestand wijzigde. Dus, als je ziet dat een functie in je code bugs bevat, dan kun je het bestand annoteren met `git blame` om te zien wanneer iedere regel van de functie voor het laatst aangepast was, en door wie. Dit voorbeeld gebruikt de `-L` optie om de output te limiteren van regel 12 tot 22:

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

Zie dat het eerste veld de gedeeltelijke SHA-1 van de commit is, die als laatste die regel aangepast heeft. De volgende twee velden zijn waarden, die gehaald zijn uit die commit – de naam van de auteur en de datum van die commit – zodat je makkelijk kunt zien wie wanneer die regel aangepast heeft. Daarna komt het regelnummer en de inhoud van dat bestand. Let op de `^4832fe2` commit regels, die aangeven dat die regels in de eerste commit van dat bestand zaten. Die commit is gedaan toen dit bestand als eerste is toegevoegd aan dit project, en die regels zijn sindsdien ongewijzigd gebleven. Dat is een beetje verwarrend, want nu heb je minstens drie manieren gezien waarop Git het `^` symbool gebruikt om een SHA van een commit aan te passen, maar dat is wat het hier betekent.

Een ander stoer ding van Git is dat het geen naamswijzigingen van bestanden expliciet bijhoudt. Het neemt de snapshots op en probeert impliciet uit te vogelen wat er hernoemd was, nadat het gebeurd is. Een van de interessantste eigenschappen hiervan is dat je ook het kunt vragen om allerlei soorten code verplaatsingen uit te vogelen. Als je `-C` aan `git blame` meegeeft, zal Git het bestand dat je annoteerd analyseren en proberen uit te vinden waar stukjes code erin oorspronkelijk vandaan kwamen als ze ergens vandaan gekopiëerd zijn. Recentelijk was ik een bestand genaamd `GITServerHandler.m` aan het refactoren naar meerdere bestanden, waarvan er een `GITPackUpload.m` heette. Door `GITPackUpload.m` te blamen met de `-C` optie, kon ik zien waar delen van de code oorspronkelijk vandaan kwamen:

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

Dit is heel handig. Normaal krijg je als de originele commit de commit waar je de code overheen gekopiëerd hebt, omdat dat de eerste keer is dat je die regels aangeraakt hebt in dit bestand. Git verteld je de originele commit waarin je deze regels geschreven hebt, zelfs als dat in een ander bestand is.

### Binair Zoeken ###

Een bestand annoteren helpt als je eenmaal weet waar het probleem zit. Als je niet weet wat er kapot is, en er zijn vele dozijnen of honderden commits geweest sinds de laatste staat waarvan je weet dat de code werkte, dan zul je waarschijnlijk bij `git bisect` aankloppen voor hulp. Het `bisect` commando zoekt binair door je commitgeschiedenis om je zo snel als mogelijk te helpen identificeren welke commit het issue introduceerde.

Stel dat je zojuist een release van je code naar een productie omgeving gepushed hebt, en je krijgt bug rapporten terug dat er iets gebeurd dat niet in je development omgeving gebeurde en je kunt je niet voorstellen waarom de code dat aan het doen is. Je gaat terug naar je code, en het blijkt dat je het probleem kunt reproduceren, maar je kunt niet zien wat er verkeerd gaat. Je kunt de code bisecten om het uit te vinden. Als eerste voer je `git bisect start` uit om aan de gang te gaan, en dan gebruik je `git bisect bad` om het systeem te vertellen dat de huidige commit kapot is. Dan moet je bisect vertellen wanneer de laatste goede status was, door `git bisect good [goede_commit]` te gebruiken:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git heeft gezien dat er ongeveer 12 commits gekomen zijn tussen de commit die je als laatste goede commit gemarkeerd hebt (v1.0) en de huidige slechte versie, en het heeft de middelste uitgechecked voor je. Op dit punt kun je je test uitvoeren om te zien of het probleem op deze commit ook aanwezig is. Als dat zo is, dan was het probleem ergens voor deze middelste commit geintroduceerd; zo niet, dan is het probleem na deze commit geintroduceerd. Het blijkt dat hier geen probleem is, dus je kunt Git dat vertellen door `git bisect good` te typen en je reis te vervolgen:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Nu zit je op een andere commit, halverwege degene die je zojuist getest hebt en je slechte commit. Je voert je test opnieuw uit, en stelt vast dat deze commit kapot is, dus vertel je dat Git met `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Deze commit is in orde, en nu heeft Git alle informatie die het nodig heeft om vast te stellen wanneer het probleem was geintroduceerd. Het verteld je de SHA-1 van de eerste slechte commit en toont een stukje commit informatie en welke bestanden aangepast waren in die commit, zodat je er achter kunt komen wat deze bug geintroduceerd kan hebben:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Als je klaar bent, zou je `git bisect reset` moeten uitvoeren om je HEAD terug te zetten naar het punt waar je was toen je startte, of anders eindig je in een vreemde status:

	$ git bisect reset

Dit is een krachtige tool, die je kan helpen om honderden commits te doorzoeken naar een fout in enkele minuten. In feite kun je `git bisect` volledig automatiseren als je een script hebt dat met 0 eindigt als het project in orde is, en niet-0 als het project slecht is. Eerst vertel je het de scope van de bisect door het de goede en slechte commits te geven, die je weet. Je kunt dit doen door ze te tonen met het `bisect start` commando als je dat wil, waarbij je de slechte commit eerst en de laatst bekende goede commit als tweede geeft:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Door het zo te doen wordt `test-error.sh` uitgevoerd bij iedere commit die uitgechecked wordt, totdat Git de eerste kapotte commit vindt. Je kunt ook zoiets als `make` of `make tests` uitvoeren, of wat je ook hebt dat automatische tests voor je uitvoerd.

## Submodules ##

Het gebeurt vaak dat terwijl je zit te werken aan het ene project, je een ander project er binnenin nodig hebt. Bijvoorbeeld een library die een derde partij ontwikkeld heeft, of die je apart aan het ontwikkelen bent en gebruikt in meerdere projecten. Een veel voorkomend probleem komt in deze scenario's naar voren: je wilt de twee projecten apart behandelen, maar de ene binnen de andere kunnen gebruiken.

Hier is een voorbeeld. Stel dat je een website aan het ontwikkelen bent en Atom feeds aan het maken bent. In plaats van je eigen Atom feedcode te schrijven, besluit je een library te gebruiken. Je zult deze code waarschijnlijk moeten includen van een gedeelde library zoals een CPAN installatie of een Ruby gem, of de broncode kopieëren naar je eigen projectboom. Het probleem met de library includen is dat het lastig is om de library op enige manier aan te passen, en vaak is het lastiger om het uit te rollen, omdat je zeker moet zijn dat iedere klant die library beschikbaar heeft. Het probleem van de broncode in je project stoppen is dat alle aanpassingen die je maakt lastig te mergen zijn op het moment dat stroomopwaarts veranderingen beschikbaar komen.

Git pakt dit probleem aan door submodules te gebruiken. Submodules geven je de mogelijkheid om een Git repository als een subdirectory van een ander Git repository te gebruiken. Dit staat je toe een ander repository in je project te clonen en je commits gescheiden te houden.

### Beginnen Met Submodules ###

Stel dat je de Rack library (een Ruby web server gateway interface) wilt toevoegen aan je project, misschien je eigen veranderingen eraan wilt onderhouden, maar ook veranderingen van stroomopwaarts wilt mergen. Het eerste dat je zou moeten doen is het exteren repository clonen in jouw submap. Je voegt externe projecten als submodules toe door middel van het `git submodule add` commando:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Nu heb je het Rack project onder een submap genaamd `rack` binnen je project. Je kunt in die submap gaan, wijzigingen maken, je eigen schrijfbare remote repository waar je veranderingen in kunt pushen toevoegen, vanuit het originele repository fetchen en mergen, en meer. Als je `git status` uitvoerd vlak nadat je de submodule toevoegd, zou je twee dingen moeten zien:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

Eerst zie je het `.gitmodules` bestand. Dit is een configuratie bestand dat de mapping opslaat tussen de URL van het project en de locale submap waarin je het binnen gepulled hebt:

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

Als je meerdere submodules hebt, zul je meerdere vermeldingen hebben in dit bestand. Het is belangrijk om te zien dat dit bestand net als je andere bestanden ook onder versiebeheer staat, zoals je `.gitignore` bestand. Het wordt gepushed en gepulled samen met de rest van je project. Op deze manier weten andere mensen die je project clonen waar ze de submodule projecten vandaan moeten halen.

De andere vermelding in de `git status` output is de rack regel. Als je `git diff` daarop uitvoert zul je iets interessants zien:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Alhoewel `rack` een submap in je werkmap is, ziet Git het als een submodule en zal de inhoud niet volgen als je niet in die map staat. In plaats daarvan slaat Git het als een aparte commit op van dat repository. Als je wijzigingen maakt en in die submap een commit doet, zal het superproject zien dat de HEAD daarin is veranderd en de exacte commit opslaan waarvan je op dat moment zit te werken; op die manier zullen anderen die dit project clonen de omgeving exact kunnen reproduceren.

Dit is een belangrijk punt met submodules: je slaat ze op als de exacte commit waar ze op staan. Je kunt een submodule niet opslaan als `master` of een andere symbolische referentie.

Als je commit, zou je zoiets als dit moeten zien:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Zie de 160000 modus voor de rack vermelding. Dat is een speciale modus binnen Git, die in feite betekent dat je een commit als een map vermelding opslaat in plaats van als een submap of een bestand.

Je kunt de `rack` map als een apart project behandelen en je superproject van tijd tot tijd vernieuwen met een pointer naar de laatste commit in dat subproject. Alle Git commando's werken onafhankelijk in de twee mappen:

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

### Een Project Met Submodules Clonen ###

Hier zul je een project met een submodule erin clonen. Als je zo'n project ontvangt, krijg je de mappen die submodules bevatten, maar nog niet meteen de bestanden:

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

De `rack` map is er, maar hij is leeg. Je moet twee commando's uitvoeren: `git submodule init` om je locale configuratie bestand te initialiseren, en `git submodule update` om alle data van dat project te fetchen en de juiste commit die in je superproject staat uit te checken:

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

Nu is je `rack` submap in exact dezelfde status is als het was toen je het eerder gecommit had. Als een andere developer wijzigingen doet op de rack code en commit, en je pulled die referentie en merged de code, dan krijg je iets dat een beetje vreemd is:

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

Je hebt iets ingemerged dat eigenlijk een wijziging is op de pointer naar je submodule; maar de code in de submodule map niet vernieuwd, dus het lijkt erop dat je een vieze status hebt in je werkmap:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Dit is het geval omdat de pointer die je hebt voor de submodule niet is wat eigenlijk in de submodule map zit. Om dit te reparen moet je `git submodule update` opnieuw uitvoeren:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

Je moet dit iedere keer dat je een submodule wijziging pulled in het hoofdproject. Het is vreemd, maar het werkt.

Er probleem doet zich voor als een developer een locale wijziging in en submodule doet en die niet naar een publieke server pushed. Dan, zullen ze een pointer naar de niet-publieke status committen en naar het superproject pushen. Als andere developers dan `git submodule update` proberen uit te voeren, dan zal het submodule systeem de commit die gerefereerd wordt niet kunnen vinden, omdat het alleen op het systeem van de eerste developer bestaat. Als dat gebeurd, zul je een foutmelding als deze zien:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Je moet dan zien wie als laatste de submodule veranderd heeft:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Dan stuur je een e-mail naar die man en schreeuwt tegen hem.

### Superprojecten ###

Soms willen developers een combinatie van de submappen van een groot project hebben, afhankelijk van het team waarin ze zitten. Dit komt vaak voor als je van CVS of Subversion af komt, waar je een module of verzameling submappen gedefiniëerd hebt, en je wilt deze manier van werken behouden.

Een goeie manier om dit in Git te doen is om ieder van de submappen een aparte Git repository te maken en dan superproject Git repositories te maken die meerdere submodules kunnen bevatten. Een voordeel van deze aanpak is dat je meer specifiek kunt definiëeren wat de relaties tussen de projecten zijn met behulp van tags en branches in de superprojects.

### Problemen Met Submodules ###

Submodules gebruiken is echter niet zonder gevaar. Ten eerste moet je relatief voorzichtig zijn met het werken in een submap. Als je `git submodule update` uitvoerd, zal het de specifieke versie van het project uitchecken, maar niet binnen een branch. Dit wordt een afgekoppelde HEAD genoemd – het betekent dat het HEAD bestand direct naar een commit wijst, en niet naar een symbolische referentie. Het probleem is dat je over het algemeen niet wilt werken in een afgekoppelde head omgeving, omdat het makkelijk is om veranderingen te verliezen. Als je een initiele `submodule update` doet, in die submodule map commit zonder een branch te maken om in te werken, an dan nogmaals `git submodule update` uitvoert in het superproject zonder in de tussentijd te committen, dan zal Git je veranderingen overschrijven zonder het je te vertellen. Technisch gezien ben je het werk niet kwijt, maar je zult geen branch hebben die er naar wijst, dus het zal lastig zijn om het terug te halen.

Om dit probleem te vermijden, creeer je een branch zodra je in een submodule map werkt met behulp van `git checkout -b work` of iets gelijkwaardigs. Als je de tweede keer de submodule update doet, zal het nog steeds je werk terugdraaien, maar je heb er tenminste een pointer van om naar terug te keren.

Van branches wisselen die submodules bevatten kan ook lastig zijn. Als je een nieuwe branch aanmaakt, daar een submodule toevoegt, en dat terug wisselt naar een branch zonder die submodule, zul je nog steeds de submodule map als een ongevolgde submap hebben:

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

Je moet hem verplaatsen of verwijderen, waarna je hem opnieuw moet clonen als je terug wisselt – en je loopt kans om locale wijzigingen of branches te verliezen die je niet omhoog gepushed hebt.

De laatste grote valkuil waar veel mensen in lopen heeft te maken met het wisselen van submappen naar submodules. Als je bestanden in je project aan het volgen bent, en je wilt ze in een submodule verplaatsen, dan moet je voorzichtig zijn of anders zal Git boos op je worden. Stel dat je de rack bestanden in een submap van je project hebt, en je wilt die naar een submodule wijzigen. Als je de submap weggooit en dan `submodule add` uitvoerd, begint Git naar je te schreeuwen:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Je moet de `rack` submap eerst unstagen. Dan kun je de submodule toevoegen:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Stel dat je dat in een branch gedaan had. Als je probeert terug te wisselen naar een branch waar die bestanden nog in de echte boom zitten in plaats van in een submodule – dan krijg je deze foutmelding:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Je moet de `rack` submodule map verplaatsen voordat je naar een branch kunt wisselen die hem nog niet heeft:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Als je dan terug wisselt krijg je een lege `rack` map. Je kunt dan nogmaals `git submodule update` uitvoeren om nog eens te clonen, of je kunt je `/tmp/rack` map terug zetten in de lege map.

## Subboom Mergen ##

Nu je de moeilijkheden van het submodulesysteem hebt gezien, laten we eens kijken naar een alternatieve manier om hetzelfde probleem aan te pakken. Zodra Git merge't, kijkt het naar wat het samen moet mergen en kiest dan een toepasselijke mergestrategie om te gebruiken. Als je twee branches aan het mergen bent, zal Git een _recursive_ strategie gebruiken. Als je meer dan twee branches aan het mergen bent, zal Git de _octopus_ strategie kiezen. Deze strategiëen worden automatisch voor je gekozen, omdat de recursieve strategie complexe drie-weg merge situaties kan behandelen – bijvoorbeeld, meer dan één gezamenlijke voorouder – maar het kan slechts twee branches behandelen. De octopus merge kan meerdere branches behandelen, maar is voorzichtiger om moeilijke conflicten te vermijden, dus is het gekozen als de standaard strategie als je meer dan twee branches probeert te mergen.

Maar er zijn meerdere strategiëen die je ook kunt kiezen. Eén ervan is de _subtree_ merge, en je kunt het gebruiken om met het subproject probleem om te gaan. Hier zul je zien hoe je dezelfde rack inbedding kunt doen als in de laatste sectie, maar in plaats daarvan subboommerges te gebruiken.

Het idee van de subboommerge is dat je twee projecten hebt, en één van de projecten wijst naar de submap van de andere en vice versa. Als je een subboommerge specificeerd, dan is Git slim genoeg om uit te vogelen dat de ene een subboom van de andere is en toepasselijk te mergen – het is erg verbazingwekkend.

Eerst voeg je de Rack applicatie toe aan je project. Dan voeg je het Rack project toe als een remote reference in je eigen project en checked het dan uit in zijn eigen branch:

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

Nu heb je de wortel van het Rack project in je `rack_branch` branch en je eigen project in de `master` branch. Als je één uitchecked en dan de andere, kun je zien dat ze verschillende project wortels hebben:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Je wilt het Rack project in je `master` project pullen als een submap. Je kunt dat in Git doen met `git read-tree`. Je zult meer over `read-tree` en zijn vrienden leren in Hoofdstuk 9, maar weet voor nu dat het de wortel boom van een branch in je huidige staging area en werkmap leest. Je hebt zojuist teruggewisseld naar je `master` branch, en je pulled de `rack` branch in de `rack` submap van je `master` branch in je hoofdproject:

	$ git read-tree --prefix=rack/ -u rack_branch

Als je commit, ziet het eruit alsof je alle Rack bestanden in die submap hebt – alsof je ze uit een tarball gekopiëerd hebt. Wat interessant is is dat je vrij makkelijk veranderingen van één branch in de andere kunt mergen. Dus als het Rack project vernieuwd kun je alle stroomopwaartse wijzigingen binnenhalen door naar die branch te wisselen en te pullen:

	$ git checkout rack_branch
	$ git pull

Dan kun je die veranderingen in je master branch mergen. Je kunt `git merge -s subtree` gebruiken en het zal prima werken; maar Git zal ook de geschiedenissen samenvoegen, wat je waarschijnlijk niet wilt. Om de veranderingen binnen te halen en het commit bericht te vullen, gebruik dan de `--squash` en `--no-commit` opties samen met de `-s subtree` strategie optie:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Alle wijzigingen van je Rack project worden ingemerged en zijn klaar om lokaal gecommit te worden. Je kunt ook het tegenovergestelde doen – veranderingen doen in de `rack` submap van je master branch en dan die later in je `rack_branch` branch mergen om ze naar de eigenaren te sturen of ze stroomopwaarts te pushen.

Om een diff te krijgen tussen wat je in je `rack` submap hebt en de code in je `rack_branch` branch – om te zien of je ze moet mergen – kun je niet het gebruikelijke `diff` commando toepassen. In plaats daarvan moet je `git diff-tree` uitvoeren met de branch waarmee je wilt vergelijken:

	$ git diff-tree -p rack_branch

Of, om te vergelijken met wat in je `rack` submap zit met wat in de `master` branch op de server zat de laatste keer dat je gefetched hebt, kun je dit uitvoeren:

	$ git diff-tree -p rack_remote/master

## Samenvatting ##

Je hebt een aantal geavanceerde tools gezien, die je toestaan je commits en je staging area meer exact te manipuleren. Als je problemen signaleert kun je vrij eenvoudig uitvinden welke commit deze geintroduceerd heeft, wanneer ze geintroduceerd zijn en door wie. Als je subprojecten in je project wilt gebruiken, heb je een paar manieren geleerd hoe je die kunt accomoderen. Op dit punt zou je in staat moeten zijn om het meeste van de dingen in Git te kunnen doen die je dagelijks op de commandline moet doen, en je er op je gemak bij moeten voelen.
