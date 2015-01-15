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
<!-- SHA-1 of last checked en-version: 4cefec  -->
# Git tools #

Nu heb je de meeste commando's en werkwijzen geleerd die je dagelijks nodig hebt om een Git repository voor je broncode te beheren en te onderhouden. Je hebt de basistaken van het tracken en committen van bestanden onder de knie, en je hebt de kracht van de staging area en lichtgewicht topic branching en mergen in de vingers.

Nu ga je een aantal zeer krachtige dingen verkennen die Git voor je kan doen, die je niet per se dagelijks gebruikt, maar die je op een bepaald moment toch nodig kunt gaan hebben.

## Revisie selectie ##

Git stelt je in staat om specifieke commits of een serie commits op diverse manieren te specificeren. Ze zijn niet meteen voor de hand liggend, maar behulpzaam om te weten.

### Enkele revisies ###

Natuurlijk kun je naar een commit refereren met de SHA-1 hash die het toegekend is, maar er zijn ook meer mensvriendelijke manieren om naar een commit te refereren. In deze paragraaf worden diverse manieren getoond waarop je naar een enkele commit kunt refereren.

### Korte SHA ###

Git is slim genoeg om uit te vinden welke commit je bedoelde te typen als je het de eerste paar karakters geeft, zolang je gedeeltelijke SHA-1 maar minstens vier karakters lang en ondubbelzinnig is; dat wil zeggen dat slechts één object in de huidige repository begint met die gedeeltelijke SHA-1.

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

Kies in dit geval `1c002dd....`. Als je op die commit `git show` uitvoert, dan zijn de volgende commando's gelijkwaardig (aangenomen dat de kortere versies ondubbelzinnig zijn):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git kan met een korte unieke afkorting van een SHA-1 waarde uit de voeten. Als je `--abbrev-commit` meegeeft aan het `git log` commando, dan zal de output kortere waarden gebruiken maar ze uniek houden; het gebruikt standaard zeven karakters maar maakt ze langer indien nodig om de SHA-1 ondubbelzinnig te houden:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Over het algemeen zijn acht tot tien karakters meer dan voldoende om binnen een project uniek te zijn. Een van de grootste Git projecten, de Linux kernel, begint 12 karakters van de mogelijke 40 nodig te hebben om uniek te blijven.

### EEN KORTE NOTITIE OVER SHA-1 ###

Veel mensen beginnen bezorgd te raken dat ze op een bepaald moment door puur toeval, twee objecten in hun repository hebben die naar dezelfde SHA-1 waarde hashen. Wat dan?

Mocht je een object committen dat hashed naar dezelfde SHA-1 waarde als een vorig object in je repository, dan zal Git het vorige reeds aanwezige object in je Git database zien en aannemen dat het al geschreven was. Als je op een bepaald moment dat object opnieuw probeert uit te checken, dan zal je altijd de gegevens van het eerste object krijgen.

<!-- Vraag: weet iemand de officiéle term voor botsingswaarschijnlijkheid? Via de Engelse Wikipedia kom ik (via collision probability) op universal hashing, maar is de formule niet te zien. -->
Maar wat je moet beseffen is hoe vreselijk onwaarschijnlijk dit scenario is. De SHA-1 waarde is 20 bytes, oftewel 160 bits. Het aantal benodigde random gehashte objecten om een 50% waarschijnlijkheid van een botsing te garanderen is ongeveer 2^80 (de formule om botsingswaarschijnlijkheid te bepalen is `p = (n(n-1)/2) * (1/2^160)`). 2^80 is 1.2 x 10^24 of 1 miljoen miljard miljard. Dat is 1.200 keer het aantal zandkorrels op aarde.

Hier is een voorbeeld om je een idee te geven wat er voor nodig is om een SHA-1 botsing te krijgen. Als alle 6.5 miljard mensen op aarde zouden programmeren, en iedere seconde zou ieder van hen code genereren die gelijk was aan de hele Linux kernel-geschiedenis (1 miljoen Git objecten) en dat in één gigantische Git repository pushen, dan zou het vijf jaar duren voordat die repository genoeg objecten zou bevatten om een 50% waarschijnlijkheid van één enkele SHA-1 object botsing te krijgen. De kans is groter dat elk lid van je programmeerteam zal worden aangevallen en gedood door wolven bij ongerelateerde incidenten op dezelfde avond.

### Branch referenties ###

De meest eenvoudige manier om een commit te specificeren heeft als voorwaarde dat je er een branchreferentie naar hebt wijzen. Dan kun je een branchnaam in ieder Git commando gebruiken dat een commitobject of SHA-1 waarde verwacht. Bijvoorbeeld, als je het laatste commitobject op een branch wil tonen, dan zijn de volgende commando's gelijkwaardig, aangenomen dat de `topic1` branch naar `ca82a6d` wijst:

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Als je wilt zien naar welke specifieke SHA een branch wijst, of als je wil zien wat ieder van deze voorbeelden in termen van SHA's voorstellen, dan kun je een Git sanitaire voorzieningen (plumbing) tool genaamd `rev-parse` gebruiken. Je kunt in Hoofdstuk 9 kijken voor meer informatie over plumbingtools, eigenlijk is `rev-parse` er voor low-level operaties en is niet ontworpen voor dagelijks gebruik. Maar het kan behulpzaam zijn op momenten dat je moet zien wat er echt aan de hand is. Hier kun je `rev-parse` uitvoeren op je branch.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### RefLog afkortingen ###

Een van de dingen die Git in de achtergrond doet terwijl jij lekker zit te werken is een reflog bijhouden: een log waarin is vastgelegd naar welke referenties de HEAD en de branches de laatste paar maanden hebben gewezen.

Je kunt je reflog zien door `git reflog` te gebruiken:

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

Iedere keer als de punt van je branch om een of andere reden is gewijzigd, dan bewaart Git die informatie voor je in deze tijdelijke geschiedenis. En je kunt ook oudere commits met deze gegevens specificeren. Als je de vijfde voorgaande waarde van de HEAD van je repository wilt zien, dan kun je de `@{n}` referentie gebruiken, die je in de reflog output kunt zien:

	$ git show HEAD@{5}

Je kunt deze syntax ook gebruiken om te zien waar een branch een bepaalde tijd geleden was. Bijvoorbeeld, om te zien waar je `master` branch gisteren was, kun je dit typen

	$ git show master@{yesterday}

Dat laat je zien waar de punt van de branch gisteren was. Deze techniek werkt alleen voor gegevens die nog steeds in je reflog staan, dus je kunt het niet gebruiken om te kijken naar commits die ouder zijn dan een paar maanden.

Om reflog informatie te zien, in hetzelfde formaat als de `git log` output, kun je `git log -g` uitvoeren:

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

Het is belangrijk om op te merken dat deze informatie strikt lokaal is - het is een log van wat jij hebt gedaan in jouw repository. De referenties zullen niet hetzelfde zijn in de kopie van de repository die iemand anders gemaakt heeft; en meteen nadat je een eerste clone van een repository hebt gemaakt heb je een lege reflog, omdat er nog geen activiteit is geweest in je repository. `git show HEAD@{2.months.ago}` uitvoeren werkt alleen als je het project minstens twee maanden geleden gecloned hebt, als je het vijf minuten geleden gecloned hebt krijg je geen resultaten.

### Voorouder referenties ###

De andere veelgebruikte manier om een commit te specificeren is via zijn voorouders. Als je een `^` aan het einde van een referentie zet, zal Git hieruit herleiden dat het de ouder van die commit betekent.
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

Je kunt ook een getal na de `^` zetten, bijvoorbeeld `d921970^2` betekent "de tweede ouder van d921970." Deze syntax is alleen nuttig voor merge commits, omdat die meer dan één ouder hebben. De eerste ouder is de branch waar jij op was toen je mergede, en de andere is de commit op de branch die je gemerged hebt:

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

De andere manier om voorouders mee te specificeren is de `~`. Dit refereert ook naar de eerste ouder, dus `HEAD~` en `HEAD^` zijn gelijk. Het verschil wordt pas duidelijk als je een getal specificeert. `HEAD~2` betekent "de eerste ouder van de eerste ouder", of "de grootouder" - het doorloopt de eerste ouders het aantal keren dat je specificeert. Bijvoorbeeld, in de geschiedenis die eerder getoond werd, zou `HEAD~3` het volgende resultaat geven

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Dit kan ook geschreven worden als `HEAD^^^` wat, nogmaals, de eerste ouder van de eerste ouder van de eerste ouder is:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Je kunt deze syntaxen combineren: je kunt de tweede ouder van de vorige referentie krijgen (aangenomen dat het een merge commit was) door `HEAD~3^2` te gebruiken, enzovoort.

### Commit reeksen ###

Nu je individuele commits kunt specificeren, laten we zien hoe je reeksen van commits kunt specificeren. Dit is vooral erg nuttig bij het beheren van je branches - als je veel branches hebt, kan je reeks-specificaties gebruiken om vragen te beantwoorden als: "Wat voor werk zit er op deze branch dat ik nog niet in mijn hoofdbranch gemerged heb?"

#### Dubbel-punt ####

De meest voorkomende reeks specificatie is de dubbel-punt syntax. Eigenlijk vraag je hiermee aan Git een reeks commits op te zoeken, die bereikbaar zijn van de ene commit maar niet vanuit een ander. Bijvoorbeeld, stel dat je een commit-geschiedenis hebt die eruit ziet zoals in Figuur 6-1.

Insert 18333fig0601.png
Figuur 6-1. Voorbeeldgeschiedenis voor reeks-selectie.

Je wilt zien wat er in je experimentele branch zit dat nog niet in je hoofdbranch gemerged is. Je kunt Git vragen om een log te tonen van alleen die commits met `master..experiment`, wat zoveel betekent als "alle commits die bereikbaar zijn voor experiment, die niet bereikbaar zijn voor master". Om de voorbeelden kort en duidelijk te houden zal ik de letters van de commitobjecten in het diagram gebruiken in plaats van de echte log output, in de volgorde waarin ze getoond zouden worden:

	$ git log master..experiment
	D
	C

Als je echter het tegenovergestelde wilt zien - alle commits in `master` die niet in `experiment` zitten - dan moet je de branchnamen omdraaien. `experiment..master` toont je alles in `master` wat niet bereikbaar is vanuit `experiment`:

	$ git log experiment..master
	F
	E

Dit is handig als je de `experiment` branch up to date wilt houden en alvast wilt zien wat je op het punt staat te mergen. Een ander veel voorkomend gebruik van deze syntax is zien wat je op het punt staat naar een remote de pushen:

	$ git log origin/master..HEAD

Dit commando toont je alle commits in je huidige branch, die niet in de `master` branch op de remote `origin` zitten. Als je een `git push` uitvoert, en je huidige branch volgt de `origin/master`, dan zijn de commits die getoond worden door `git log origin/master..HEAD` de commits die verstuurd zullen worden naar de server.
Je kunt ook één kant van de syntax weglaten om Git de HEAD laten aannemen. Bijvoorbeeld, je krijgt dezelfde resultaten als in het vorige voorbeeld door `git log origin/master..` te typen - Git vult HEAD in als er één kant ontbreekt.

#### Dubbele punten ####

De syntax met de dubbel-punt is makkelijk als een afkorting, maar misschien wil je meer dan twee branches specificeren om je revisie aan te geven, zoals het zien welke commits in één van de branches in een reeks zitten, die nog niet in de branch zitten waar je nu op werkt. Git laat je dit doen door of het `^` karakter of `--not`, te gebruiken voor iedere referentie waarvan je de bereikbare commits niet wilt zien. Dus deze drie commando's zijn gelijk:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Dit is prettig omdat met deze syntax je meer dan twee referenties in je vraag kunt specificeren, wat je niet met de dubbel punt syntax kan doen. Bijvoorbeeld, als je alle commits wilt zien die bereikbaar zijn vanuit `refA` of `refB`, maar niet vanuit `refC`, dan kun je één van deze intypen:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Dit zorgt voor een erg krachtig revisie vraagsysteem dat je kan helpen om uit te zoeken wat in je branches zit.

#### Drievoudige punt ####

De laatste veelgebruikte reeks-selectie syntax is de drievoudige punt syntax, wat alle commits specificeert die bereikbaar zijn door één van de twee referenties, maar niet door allebei. Kijk nog eens naar de voorbeeld commitgeschiedenis in Figuur 6-1.
Als je wilt zien wat in je `master` of in je `experiment` zit, maar geen gedeelde referenties, dan kun je dit uitvoeren

	$ git log master...experiment
	F
	E
	D
	C

Nogmaals, dit geeft je normale `log` output, maar toont je alleen de commit-informatie voor deze vier commits, getoond in de traditionele volgorde van committijdstip.

Een veelgebruikte optie bij het `log` command in dit geval is `--left-right`, wat je laat zien aan welke kant van de reeks elke commit zit. Dit helpt de data bruikbaarder te maken:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Met deze tools, kun je Git eenvoudiger laten weten welke commit of commits je wilt inspecteren.

## Interactief stagen ##

Bij Git worden een aantal scripts geleverd, die sommige commandline taken makkelijker maken. Hier zul je een aantal interactieve commando's zien, die je kunnen helpen om je commits zo samen te stellen dat ze alleen bepaalde combinaties en delen van bestanden bevatten. Deze tools zijn erg nuttig als je een reeks bestanden aanpast en dan besluit dat je deze wijzigingen in een aantal gefocuste commits wilt hebben in plaats van één grote rommelige commit. Op deze manier ben je er zeker van dat je commits logische aparte wijzigingensets zijn en makkelijk gereviewed kunnen worden door je mede-ontwikkelaars.
Als je `git add` uitvoert met de `-i` of `--interactive` optie, dan schakelt Git over naar een interactieve shell modus, waarbij zoiets als dit getoond wordt:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

Je kunt zien dat dit commando je een heel andere kijk op je staging area geeft - eigenlijk dezelfde informatie die je krijgt met het `git status` commando, maar dan compacter en meer informatief. Het toont links de wijzigingen die je gestaged hebt, en de niet gestagede wijzigingen rechts.

Hierna volgt een commando-sectie. Hier kun je een aantal dingen doen waaronder bestanden stagen, bestanden unstagen, delen van bestanden stagen, ungetrackte bestanden toevoegen, en diffs zien van wat gestaged is.

### Bestanden stagen en unstagen ###

Als je `2` of `u` op de `What now>` prompt typt, dan vraagt het script welke bestanden je wilt stagen:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Om de TODO en index.html bestanden te stagen, kun je de getallen typen:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

De `*` naast ieder bestand geeft aan dat het bestand geselecteerd is om gestaged te worden. Als je Enter indrukt na niets getypt te hebben op de `Update>>` prompt, dan zal Git alles wat geselecteerd staat pakken en voor je stagen:

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

Nu kun je zien dat de TODO en index.html bestanden gestaged zijn, en het simplegit.rb bestand nog steeds unstaged is. Als je het TODO bestand nu wilt unstagen, dan gebruik je de `3` of `r` (voor revert) optie:

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

Als je nu nog eens naar je Git status kijkt, kun je zien dat je het TODO bestand ge-unstaged hebt:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Om de diff te zien van wat je gestaged hebt, kun je het `6` of `d` (voor diff) commando gebruiken. Het toont je een lijst van je gestagede bestanden, en je kunt de bestanden selecteren waarvan je de gestagede diff wilt zien. Dit is vergelijkbaar met het specificeren van `git diff --cached` op de commando regel:

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

Met deze simpele commando's kun je de interactieve toevoegmodus gebruiken om op een iets eenvoudigere manier met je staging area om te gaan.

### Patches stagen ###

Het is met Git ook mogelijk om bepaalde delen van bestanden te stagen en de rest niet. Bijvoorbeeld, als je twee wijzigingen maakt in je simplegit.rb bestand en één van die twee wilt stagen en de andere niet, dan is dat eenvoudig in Git. Vanaf de interactieve prompt, type `5` of `p` (voor patch). Git zal je vragen welke bestanden je deels wilt stagen en daarna, voor iedere sectie van de geselecteerde bestanden, zal het stukken van de bestandsdiff tonen en je vragen of je ze wilt stagen, één voor één:

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

Hier heb je erg veel opties. Door `?` te typen krijg je een lijst met wat je kunt doen:

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

Over het algemeen zal je `y` of `n` typen als je elke homp (hunk) wilt stagen, maar voor bepaalde bestanden ze allemaal stagen, of voor een bepaalde hunk de beslissing uit stellen kan ook behulpzaam zijn. Als je een gedeelte van het bestand wilt stagen en een ander gedeelte unstaged wilt laten, dan zal je status output er zo uitzien:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

De status van het simplegit.rb bestand is interessant. Het laat zien dat een paar regels gestaged zijn, en een paar niet. Je hebt dit bestand deels gestaged. Nu kan je het interactieve toevoeg script verlaten en het `git commit` commando uitvoeren om de gedeeltelijk gestagede bestanden te committen.

Tot slot hoef je niet in de interactieve toevoeg modus te zijn om het gedeeltelijke bestands-stagen te doen, je kunt hetzelfde script starten door `git add -p` of `git add --patch` op de commando regel te gebruiken.

## Stashen ##

Vaak, als je aan een deel van je project hebt zitten werken, zijn de dingen in een rommelige staat en wil je van branch veranderen om aan iets anders te werken. Het probleem is dat je geen halfklaar werk wilt committen, alleen maar om later verder te kunnen gaan vanaf hetzelfde punt. Het oplossing voor dit probleem is het `git stash` commando.

Stashen (wegstoppen) pakt de vervuilde status van je werkdirectory - dat wil zeggen: je gewijzigde getrackte bestanden en gestagede wijzigingen, en bewaart het op een stapel onafgemaakte wijzigingen die je op ieder tijdstip opnieuw kunt toepassen.

### Je werk stashen ###

Om dit te demonstreren, ga je project in en begin met werken aan een paar bestanden en misschien stage je een van de wijzigingen. Als je `git status` uitvoert, kun je de vervuilde status zien:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Nu wil je van branch veranderen, maar je wilt hetgeen je aan hebt zitten werken nog niet committen, dus je gaat de wijzigingen stashen. Om een nieuwe stash op de stapel te zetten, voer je `git stash` uit:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Je werkdirectory is schoon:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Nu kan je eenvoudig van branch wisselen en ergens anders aan werken, je wijzigingen zijn opgeslagen op de stapel. Om te zien welke stashes je opgeslagen hebt, kun je `git stash list` gebruiken:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

In dit geval waren er twee stashes al eerder opgeslagen, dus heb je toegang tot drie verschillende gestashede werken. Je kunt degene die je zojuist gestashed hebt opnieuw toepassen, door het commando uit te voeren dat in de help output van het originele stash commando stond: `git stash apply`. Als je een van de oudere stashes wilt toepassen, dan kun je die specificeren door hem te benoemen, zoals hier: `git apply stash stash@{2}`. Als je geen stash specificeert, neemt Git aan dat je de meest recente stash bedoelt en probeert die toe te passen:

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Je kunt zien dat Git opnieuw de bestanden wijzigt die je uncommitte toen je de stash opsloeg. In dit geval had je een schone werkdirectory toen je de stash probeerde toe te passen, en dat je probeerde deze op dezelfde branch toe te passen als waar je hem van opgeslagen hebt. Maar het hebben van een schone werkdirectory en het toepassen op dezelfde branch zijn niet noodzakelijk om een stash succesvol toe te kunnen passen. Je kunt een stash op één branch opslaan, later naar een andere branch omschakelen, en daar opnieuw de wijzigingen toe proberen te passen. Je kunt ook gewijzigde en uncommitted bestanden in je werkdirectory hebben wanneer je een stash probeert toe te passen, Git geeft merge conflicten aan als iets niet meer netjes toe te passen is.

De wijzigingen aan je bestanden zijn opnieuw toegepast, maar het bestand dat je eerder gestaged had is niet opnieuw gestaged. Om dat te doen moet je het `git stash apply` commando met de `--index` optie uitvoeren om het commando te vertellen de gestagede wijzigingen opnieuw proberen toe te passen. Als je dat had uitgevoerd, dan zou je weer op je originele uitgangspunt zijn uitgekomen:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

De apply optie probeert alleen het gestashete werk toe te passen - je blijft op de stapel behouden. Om het te verwijderen kun je `git stash drop` uitvoeren, met de naam van de stash die je wilt verwijderen:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Je kunt ook `git stash pop` uitvoeren om de stash toe te passen en deze direct van de stapel te verwijderen.

### Een stash ont-toepassen ###

In sommige situaties zou het kunnen voorkomen dat je gestashde wijzigingen wilt toepassen, wat werk doen en dan de wijzigingen die van de stash waren gekomen ont-toepassen. Git heeft niet zoiets als een `stash unapply` commando, maar het is mogelijk om het effect te bereiken door simpelweg de patch op te halen die bij een stash hoort, en deze in zijn achteruit toe te passen:

    $ git stash show -p stash@{0} | git apply -R

Nogmaals: als je geen stash specificeert gaat Git van de meest recente stash uit:

    $ git stash show -p | git apply -R

Wellicht wil je een alias maken en effectief een `stash-unapply` commando aan je Git toevoegen. Bijvoorbeeld:

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

### Een branch van een stash maken ###

Als je wat werk stashed, het daar poosje laat liggen, en doorwerkt op de branch waarvan je het werk gestashed hebt, dan kun je een probleem krijgen met het opnieuw toe passen van dat werk. Als het toepassen een bestand probeert te wijzigen dat je sindsdien gewijzigd hebt krijg je een merge conflict en zul je dat moeten proberen oplossen. Als je een eenvoudiger manier wilt hebben om je gestashde wijzigingen opnieuw te testen, kun je `git stash branch` uitvoeren. Dit zal een nieuwe branch voor je aanmaken, de commit waar je op zat toen je het werk stashte uitchecken, je werk opnieuw toepassen en dan de stash droppen als het succesvol is toegepast:

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Dit is een prettige manier om gestashed werk eenvoudig terug te halen en eraan te werken in een nieuwe branch.

## Geschiedenis herschrijven ##

Vaak zal je, als je met Git werkt, je commit geschiedenis om een of andere reden willen aanpassen. Één van de mooie dingen van Git is dat het je in staat stelt om beslissingen op het laatst mogelijke moment te maken. Je kunt bepalen welke bestanden in welke commits gaan vlak voordat je commit, door middel van de staging area, je kunt besluiten dat je toch nog niet aan iets had willen beginnen met het stash commando en je kunt commits herschrijven ook al zijn ze al gebeurd, waardoor het lijkt alsof ze op een andere manier gebeurd zijn. Dit kan bijvoorbeeld de volgorde van de commits zijn, berichten of bestanden in een commit wijzigen, commits samenpersen(squashen) of opsplitsen, of complete commits weghalen - en dat allemaal voordat je jouw werk met anderen deelt.

In deze paragraaf zal je leren hoe je deze handige taken uitvoert, zodat je jouw commit geschiedenis er uit kunt laten zien zoals jij dat wilt, voordat je het met anderen deelt.

### De laatste commit veranderen ###

De laatste commit veranderen is waarschijnlijk de meest voorkomende geschiedenis wijziging die je zult doen. Vaak wil je twee basale dingen aan je laatste commit wijzigen: het commit bericht, of de snapshot, dat je zojuist opgeslagen hebt, wijzigen door het toevoegen, wijzigen of weghalen van bestanden.

Als je alleen je laatste commit bericht wilt wijzigen, dan is dat heel eenvoudig:

	$ git commit --amend

Dat plaatst je in de teksteditor met je laatste commit bericht erin, klaar voor je om het bericht te wijzigen. Als je opslaat en de editor sluit, dan schrijft de editor een nieuwe commit met dat bericht en maakt dat je laatste commit.

Als je hebt gecommit en daarna wil je het snapshot dat je gecommit hebt wijzigen, door het toevoegen of wijzigen van bestanden, misschien omdat je vergeten was een nieuw bestand toe te voegen toen je committe, gaat het proces vergelijkbaar. Je staged de wijzigingen die je wilt door een bestand te wijzigen en `git add` er op uit te voeren, of `git rm` op een getrackt bestand, en de daaropvolgende `git commit --amend` pakt je huidige staging area en maakt dat het snapshot voor de nieuwe commit.

Je moet wel oppassen met deze techniek, omdat het amenden de SHA-1 van de commit wijzigt. Het is vergelijkbaar met een kleine rebase: niet je laatste commit wijzigen als je die al gepusht hebt.

### Meerdere commit berichten wijzigen ###

Om een commit te wijzigen die verder terug in je geschiedenis zit, moet je meer complexe tools gebruiken. Git heeft geen geschiedenis-wijzig tool, maar je kunt de rebase tool gebruiken om een serie commits op de HEAD te rebasen waarop ze origineel gebaseerd, in plaats van ze naar een andere te verhuizen. Met de interactieve rebase tool kun je dan na iedere commit die je wilt wijzigen stoppen en het bericht wijzigen, bestanden toevoegen, of doen wat je ook maar wilt. Je kunt rebase interactief uitvoeren door de `-i` optie aan `git rebase` toe te voegen. Je moet aangeven hoe ver terug je commits wilt herschrijven door het commando te vertellen op welke commit het moet rebasen.

Bijvoorbeeld, als je de laatste drie commit berichten wilt veranderen, of een van de commit berichten in die groep, dan geef je de ouder van de laatste commit die je wilt wijzigen mee als argument aan `git rebase -i`, wat `HEAD~2^` of `HEAD~3` is. Het kan makkelijker zijn om de `~3` te onthouden, omdat je de laatste drie commits probeert te wijzigen; maar houd in gedachten dat je eigenlijk vier commits terug aangeeft; de ouder van de laatste commit die je wilt veranderen:

	$ git rebase -i HEAD~3

Onthoud, nogmaals, dat dit een rebase commando is - iedere commit in de reeks `HEAD~3..HEAD` zal worden herschreven, of je het bericht nu wijzigt of niet. Voeg geen commit toe die je al naar een centrale server gepusht hebt; als je dit doet breng je andere gebruikers in de war omdat je ze een alternatieve versie van dezelfde wijziging te geeft.

Dit commando uitvoeren geeft je een lijst met commits in je tekst editor die er ongeveer zo uit ziet:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

Het is belangrijk om op te merken dat deze commits in de tegengestelde volgorde getoond worden dan hoe je ze normaliter ziet als je het `log` commando gebruikt. Als je een `log` uitvoert, zie je zoiets als dit:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Merk de omgekeerde volgorde op. De interactieve rebase geeft je een script dat het gaat uitvoeren. Het zal beginnen met de commit die je specificeert op de commando regel (`HEAD~3`) en de wijzigingen in elk van deze commits van voor naar achter opnieuw afspelen. Het toont de oudste het eerst in plaats van de nieuwste, omdat dat deze de eerste is die zal worden afgespeeld.

Je moet het script zodanig aanpassen dat het stopt bij de commit die je wilt wijzigen. Om dat te doen moet je het woord "pick" veranderen in het woord "edit" voor elke commit waarbij je het script wilt laten stoppen. Bijvoorbeeld, om alleen het derde commit bericht te wijzigen verander je het bestand zodat het er zo uitziet:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Als je dit opslaat en de editor sluit, spoelt Git terug naar de laatste commit van die lijst en zet je op de commando regel met de volgende boodschap:

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Deze instructies vertellen je precies wat je moet doen. Type

	$ git commit --amend

Wijzig het commit bericht en verlaat de editor. Voer vervolgens dit uit

	$ git rebase --continue

Dit commando zal de andere twee commits automatisch toepassen, en je bent klaar. Als je "pick" op meerdere regels in "edit" verandert, dan kan je deze stappen herhalen voor iedere commit die je in "edit" veranderd hebt. Elke keer zal Git stoppen, je de commit laten wijzigen en verder gaan als je klaar bent.

### Commits opnieuw rangschikken ###

Je kunt een interactieve rebase ook gebruiken om commits opnieuw te rangschikken of zijn geheel te verwijderen. Als je de "added cat-file" commit wilt verwijderen en de volgorde waarin de andere twee commits zijn geÃ¯ntroduceerd wilt veranderen, dan kun je het rebase script van dit

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

veranderen in dit:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Als je dan opslaat en de editor sluit, zal Git je branch terugzetten naar de ouder van deze commits, eerst `310154e` en dan `f7f3f6d` toepassen, en dan stoppen. Effectief verander je de volgorde van die commits en verwijder je de "added cat-file" commit volledig.

### Een commit samenpersen (squashing) ###

Het is ook mogelijk een serie commits te pakken en ze in één enkele commit samen te persen (squash) met de interactieve rebase tool. Het script stopt behulpzame instructies in het rebase bericht:

	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

Als je in plaats van "pick" of "edit", "squash" specificeert zal Git zowel die verandering als de verandering die er direct aan vooraf gaat toepassen, en je dwingen om de commit berichten samen te voegen. Dus als je een enkele commit van deze drie commits wil maken, laat je het script er zo uit zien:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Als je de editor opslaat en sluit, zal Git alle drie wijzigingen toepassen en je terug in de editor brengen om de drie commit berichten samen te voegen:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Als je dat opslaat, heb je een enkele commit die de veranderingen van alle drie vorige commits introduceert.

### Een commit splitsen ###

Een commit opsplitsen zal een commit ongedaan maken, en dan net zo vaak gedeeltelijk stagen en committen als het aantal commits waar je mee wilt eindigen. Bijvoorbeeld, stel dat je de middelste van je drie commits wilt splitsen. In plaats van "updated README formatting and added blame" wil je het splitsen in twee commits: "updated README formatting" als eerste, en "added blame" als tweede. Je kunt dat doen in het `rebase -i` script door de instructie van de commit die je wilt splitsen te veranderen in "edit":

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Als je opslaat en de editor verlaat, spoelt Git terug naar de parent van de eerste commit in de lijst, past de eerste commit toe (`f7f3f6d`), past de tweede toe (`310154e`), en zet je dan in de console. Daar kan je een gemengde reset doen van die commit met `git reset HEAD^` , wat effectief de commit terugdraait en de gewijzigde bestanden unstaged laat. Nu kan je de wijzigingen die gereset zijn nemen en er meerdere commits van maken. Eenvoudigweg bestanden stagen en committen tot je meerdere commits hebt, en dan `git rebase --continue` uitvoeren zodra je klaar bent:

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

Nogmaals, dit verandert alle SHA's van alle commits in de lijst, dus zorg er voor dat er geen commit in die lijst zit die je al naar een gedeelde repository gepusht hebt.

### De optie met atoomkracht: filter-branch ###

Er is nog een geschiedenis-herschrijvende optie, die je kunt gebruiken als je een groter aantal commits moet herschrijven op een gescripte manier. Bijvoorbeeld, het globaal veranderen van je e-mail adres of een bestand uit iedere commit verwijderen. Het commando heet `filter-branch` en het kan grote gedeelten van je geschiedenis herschrijven, dus je moet het niet gebruiken tenzij je project nog niet publiekelijk is gemaakt, en andere mensen nog geen werk hebben gebaseerd op jouw commits die je op het punt staat te herschrijven. Maar het kan heel handig zijn. Je zult een paar gebruikelijke toepassingen zien zodat je een idee krijgt waar het toe in staat is.

#### Een bestand uit iedere commit verwijderen ####

Dit gebeurt vrij regelmatig. Iemand voegt per ongeluk een enorm binair bestand toe met een achteloze `git add .`, en je wilt het overal weghalen. Misschien heb je per ongeluk een bestand dat een wachtwoord bevat gecommit, en je wilt dat project open source maken. `filter-branch` is dan de tool dat je wilt gebruiken om je hele geschiedenis schoon te poetsen. Om een bestand met de naam passwords.txt uit je hele geschiedenis weg te halen, kun je de `--tree-filter` optie toevoegen aan `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

De `--tree-filter` optie voert het gegeven commando uit na elke checkout van het project, en commit de resultaten weer. In dit geval verwijder je een bestand genaamd passwords.txt van elke snapshot, of het bestaat of niet. Als je alle per ongeluk toegevoegde editor backup bestanden wilt verwijderen, kun je bijvoorbeeld dit uitvoeren `git filter-branch --tree-filter "rm -f *~" HEAD`.

Je zult Git objectbomen en commits zien herschrijven en op het eind de branch wijzer zien verplaatsen. Het is over het algemeen een goed idee om dit in een test branch te doen, en dan je master branch te hard-resetten nadat je gecontroleerd hebt dat de uitkomst echt is als je het wilt hebben. Om `filter-branch` op al je branches uit te voeren, moet je `--all` aan het commando meegeven.

#### Een subdirectory de nieuwe root maken ####

Stel dat je een import vanuit een ander versiebeheersysteem hebt gedaan, en subdirectories hebt die niet zinnig zijn (trunk, tags, enzovoort). Als je de `trunk` subdirectory de nieuwe root van het project wilt maken voor elke commit, kan `filter-branch` je daar ook mee helpen:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Nu is de nieuwe project root elke keer de inhoud van de `trunk` subdirectory. Git zal ook automatisch commits verwijderen die geen betrekking hadden op die subdirectory.

#### E-mail adressen globaal veranderen ####

Een ander veel voorkomend geval is dat je vergeten bent om `git config` uit te voeren om je naam en e-mail adres in te stellen voordat je begon met werken, of misschien wil je een project op het werk open source maken en al je werk e-mail adressen veranderen naar je persoonlijke adres. Hoe dan ook, je kunt e-mail adressen in meerdere commits ook in één klap veranderen met `filter-branch`. Je moet wel oppassen dat je alleen die e-mail adressen aanpast die van jou zijn, dus gebruik je `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

Dit gaat alle commits door en herschrijft ze zodat het jouw nieuwe adres bevat. Om dat commits de SHA-1 waarde van hun ouders bevatten, zal dit commando iedere commit SHA in jouw geschiedenis veranderen, niet alleen diegene die het gezochte e-mailadres bevatten.

## Debuggen met Git ##

Git levert ook een paar tools om je problemen te helpen debuggen in je projecten. Omdat Git is ontworpen te werken met bijna elk type project zijn deze tools erg generiek, maar ze kunnen je vaak helpen een bug of schuldige te vinden als de dingen verkeerd gaan.

### Aantekenen van bestanden ###

Als je een bug in je code traceert en wilt weten wanneer het was geÃ¯ntroduceerd en waarom, dan is bestands aantekenen vaak je beste methode. Het toont je welke commit de laatste was die iets wijzigde in een bepaald bestand. Dus als je ziet dat een methode in je code bugs bevat, dan kun je het bestand aantekenen met `git blame` om te zien wanneer een regel van de methode voor het laatst aangepast was en door wie. Dit voorbeeld gebruikt de `-L` optie om de output te beperken tot regel 12 tot en met 22:

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

Merk op dat het eerste veld de gedeeltelijke SHA-1 van de commit is die als laatste die regel gewijzigd heeft. De volgende twee velden zijn waarden die gehaald zijn uit die commit: de naam van de auteur en de datum van die commit, zodat je makkelijk kunt zien wie die regel aangepast heeft en wanneer. Daarna komt het regelnummer en de inhoud van dat bestand. Let ook op de `^4832fe2` commit regels, die aangeven dat die regels in de allereerste commit van dat bestand zaten. Die commit is gedaan toen dit bestand voor het eerst was toegevoegd aan dit project, en die regels zijn sindsdien ongewijzigd gebleven. Dit is ietwat wat verwarrend, want nu heb je minstens drie manieren gezien waarop Git het `^` symbool gebruikt om een SHA van een commit aan te passen, maar dit is wat het hier betekent.

Een ander gave ding van Git is dat het naamswijzigingen van bestanden niet expliciet bijhoudt. Het slaat de snapshots op en probeert dan impliciet uit te vogelen dat er iets hernoemd is, nadat dat gebeurd is. Een van de interessante gevolgen hiervan is dat je Git ook kunt vragen om allerlei soorten code verplaatsingen uit te zoeken. Als je `-C` aan `git blame` meegeeft, zal Git het bestand dat je aantekent analyseren en proberen uit te vinden waar stukjes code daarin oorspronkelijk vandaan kwamen als ze ergens vandaan gekopieerd zijn. Recentelijk was ik een bestand genaamd `GITServerHandler.m` aan het omschrijven naar meerdere bestanden, waarvan `GITPackUpload.m` er een was. Door `GITPackUpload.m` te blamen met de `-C` optie, kon ik zien waar delen van de code oorspronkelijk vandaan kwamen:

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

Dit is echt heel handig. Normaal krijg je als de originele commit de commit waar je de code naartoe gekopieerd hebt, omdat dat de eerste keer is dat je die regels aangeraakt hebt in dit bestand. Git vertelt je de oorspronkelijke commit waarin je deze regels geschreven hebt, zelfs als dat in een ander bestand was.

### Binair zoeken ###

Een bestand aantekenen helpt als je al weet waar het probleem zit. Als je niet weet waar de fout zit en er zijn dozijnen of honderden commits geweest sinds de laatste staat waarvan je weet dat de code werkte, dan zal je waarschijnlijk bij `git bisect` aankloppen voor hulp. Het `bisect` commando zoekt binair door je commit-geschiedenis om je zo snel als mogelijk te helpen identificeren welke commit het issue introduceerde.

Stel dat je zojuist een release van je code naar een productie omgeving gepusht hebt, en je krijgt bug rapporten dat er iets gebeurt wat niet in je development omgeving gebeurde en je kunt je niet voorstellen waarom de code dat aan het doen is. Je gaat terug naar je code, en het blijkt dat je het probleem kunt reproduceren maar je kunt niet zien wat er verkeerd gaat. Je kunt de code uitpluizen (bisecten) om het uit te vinden. Als eerste voer je `git bisect start` uit om aan de boel op te starten, en dan gebruik je `git bisect bad` om het systeem te vertellen dat de huidige commit waar je op zit kapot is. Dan moet je bisect vertellen wanneer de laatste goede status was, met `git bisect good [goede_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git heeft gezien dat er ongeveer 12 commits geweest zijn tussen de commit die je als laatste goede commit gemarkeerd hebt (v1.0) en de huidige slechte versie, en het heeft de middelste voor je uitgecheckt. Op dit punt kun je de test uitvoeren om te zien of het probleem op deze commit ook aanwezig is. Als dat zo is, dan was het probleem ergens voor deze middelste commit geÃ¯ntroduceerd, zo niet dan is het probleem na deze commit geÃ¯ntroduceerd. Het blijkt dat hier geen probleem is, dus vertel je Git dat door `git bisect good` te typen en je reis te vervolgen:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Nu zit je op een andere commit, halverwege degene die je zojuist getest hebt en je slechte commit. Je voert je test opnieuw uit, en stelt vast dat deze commit kapot is, dus vertel je dat Git met `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Deze commit is in orde, en nu heeft Git alle informatie die het nodig heeft om vast te stellen wanneer het probleem was geÃ¯ntroduceerd. Het vertelt je de SHA-1 van de eerste slechte commit en toont een stukje commit informatie en welke bestanden aangepast waren in die commit, zodat je er achter kunt komen wat deze bug geÃ¯ntroduceerd kan hebben:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Als je klaar bent, moet je `git bisect reset` uitvoeren om je HEAD terug te zetten naar het punt waar je was toen je startte, anders eindig je in een vreemde status:

	$ git bisect reset

Dit is een krachtige tool, die je kan helpen om in enkele minuten honderden commits te doorzoeken op zoek naar een fout. Sterker nog, als je een script hebt die eindigt met 0 als het project goed is of niet-0 als het fout is, kan je `git bisect` volledig automatiseren. Eerst vertel je het de scope van de bisect door het de goede en slechte commits te geven. Als je kan dit doen door ze op te geven bij het `bisect start` commando, waarbij je de slechte commit eerst en de laatst bekende goede commit als tweede geeft:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Door het zo te doen wordt `test-error.sh` uitgevoerd bij elke commit die uitgecheckt wordt, totdat Git de eerste kapotte commit vindt. Je kunt ook iets als `make` of `make tests` uitvoeren, of wat je ook hebt dat automatische tests voor je uitvoert.

## Submodules ##

Het komt vaak voor dat terwijl je zit te werken aan het ene project, je een ander project daarbinnen moet gebruiken. Bijvoorbeeld een library die een derde partij ontwikkeld heeft, of die je separaat aan het ontwikkelen bent en gebruikt in meerdere projecten. Een veel voorkomend probleem komt in deze scenario's naar voren: je wilt de twee projecten apart behandelen, maar wel binnen de andere kunnen gebruiken.

Hier is een voorbeeld. Stel dat je een website aan het ontwikkelen bent en Atom feeds aan het maken bent. In plaats van je eigen Atom-genererende code te schrijven, besluit je een library te gebruiken. Je zult deze code dan moeten includen van een gedeelde library zoals een CPAN installatie of een Ruby gem, of de broncode kopiéren naar je eigen projectboom. Het probleem met de library includen is dat het lastig is om de library op enige manier aan te passen, en vaak nog lastiger is om het uit te rollen omdat je zeker moet zijn dat iedere client die library beschikbaar heeft. Het probleem van de broncode in je project stoppen is dat alle aanpassingen die je maakt lastig te mergen zijn op het moment dat stroomopwaarts veranderingen beschikbaar komen.

Git pakt dit probleem aan door submodules te gebruiken. Submodules geven je de mogelijkheid om een Git repository als een subdirectory van een ander Git repository te gebruiken. Dit stelt je in staat staat een ander repository in je project te klonen en je commits gescheiden te houden.

### Beginnen met submodules ###

Stel dat je de Rack library (een Ruby web server gateway interface) wilt toevoegen aan je project, misschien je eigen veranderingen eraan wilt onderhouden, maar ook veranderingen van stroomopwaarts wilt mergen. Het eerste wat je moet doen is de externe repository klonen in jouw subdirectory. Je voegt externe projecten als submodules toe door middel van het `git submodule add` commando:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Nu heb je het Rack project als een subdirectory genaamd `rack` in je eigen project. Je kunt die subdirectory in gaan, wijzigingen maken, je eigen schrijfbare remote repository toevoegen waar je veranderingen in kunt pushen, vanuit de originele repository fetchen en mergen, en zo meer. Als je `git status` uitvoert vlak nadat je de submodule toevoegt, zie je twee dingen:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

Eerst zie je het `.gitmodules` bestand. Dit is een configuratie bestand dat de mapping opslaat tussen de URL van het project en de lokale subdirectory waarin je het gepulled hebt:

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

Als je meerdere submodules hebt, zal je meerdere vermeldingen hebben in dit bestand. Het is belangrijk om op te merken dat dit bestand net als je andere bestanden ook onder versiebeheer staat, net als het `.gitignore` bestand. Het wordt samen met de rest van het project gepusht en gepulled. Op deze manier weten andere mensen die je project klonen waar ze de submodule projecten vandaan moeten halen.

De andere vermelding in de `git status` uitvoer is de rack regel. Als je `git diff` daarop uitvoert zul je iets interessants zien:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Hoewel `rack` een subdirectory in je werkdirectory is, ziet Git het als een submodule en zal de inhoud niet tracken als je niet in die directory staat. In plaats daarvan slaat Git het als een aparte commit op van die repository. Als je wijzigingen maakt en in die subdirectory een commit doet, zal het superproject zien dat de HEAD daar is veranderd en de exacte commit opslaan waarop je op dat moment zit te werken; op die manier zullen anderen die dit project klonen de omgeving exact kunnen reproduceren.

Dit is een belangrijk punt met submodules: je slaat ze op als de exacte commit waar ze op staan. Je kunt een submodule niet opslaan als `master` of een andere symbolische referentie.

Als je commit, zou je zoiets als dit moeten zien:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Merk de 160000 modus op voor de rack vermelding. Dat is een speciale modus binnen Git, die in feite betekent dat je een commit als een directory vermelding opslaat in plaats van als een subdirectory of een bestand.

Je kunt de `rack` directory als een apart project behandelen en je superproject van tijd tot tijd vernieuwen met een pointer naar de laatste commit in dat subproject. Alle Git commando's werken onafhankelijk in de twee directories:

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

### Een project met submodules clonen ###

Hier ga je een project met een submodule erin clonen. Als je zo'n project ontvangt, krijg je de directories die submodules bevatten, maar nog niet de bestanden:

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

De `rack` directory is er, maar hij is leeg. Je moet twee commando's uitvoeren: `git submodule init` om je lokale configuratie bestand te initialiseren, en `git submodule update` om alle data van dat project te fetchen en de juiste commit die in je superproject staat uit te checken:

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

Nu is je `rack` subdirectory in exact dezelfde staat als het was toen je het eerder gecommit had. Als een andere developer wijzigingen doet op de rack code en commit en je pulled die referentie en merged de code, dan krijg je iets dat een beetje vreemd is:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

Je hebt iets gemerged dat eigenlijk een wijziging is op de pointer naar je submodule; maar de code in de submodule directory wordt niet vernieuwd, dus het lijkt erop dat je een vervuilde status hebt in je werkdirectory:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Dit is het omdat de pointer die je hebt voor de submodule niet is wat eigenlijk in de submodule directory zit. Om dit te repareren moet je `git submodule update` opnieuw uitvoeren:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

Je moet dit iedere keer doen wanneer je een submodule wijziging pulled in het hoofdproject. Het is vreemd, maar het werkt.

Één bekend probleem doet zich voor als een developer een lokale wijziging in een submodule doet maar die niet naar een publieke server pusht. Dan committen ze een pointer naar de niet-publieke status en pushen deze naar het superproject. Als andere developers dan `git submodule update` proberen uit te voeren, dan zal het submodule systeem de commit die gerefereerd wordt niet kunnen vinden omdat het alleen op het systeem van de eerste developer bestaat. Als dat gebeurt, zal je een foutmelding als deze zien:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Je moet dan bekijken wie als laatste de submodule veranderd heeft:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Dan stuur je een e-mail naar die jongen en gaat heel boos zijn tegen hem.

### Superprojecten ###

Soms willen developers een combinatie van subdirectories van een groot project hebben, afhankelijk van het team waarin ze zitten. Dit komt vaak voor als je van CVS of Subversion af komt, waar je een module of verzameling subdirectory gedefinieerd hebt en je wilt deze workflow behouden.

Een goeie manier om dit in Git te doen is om elk van de subdirectories een aparte Git repository te maken en dan superproject Git repositories te maken die meerdere submodules bevatten. Een voordeel van deze aanpak is dat je meer specifiek kunt definiéren wat de relaties tussen de projecten zijn met behulp van tags en branches in de superprojects.

### Problemen met submodules ###

Submodules gebruiken is echter niet zonder probleempjes. Ten eerste moet je relatief voorzichtig zijn met het werken in de directory van de submodule. Als je `git submodule update` uitvoert, zal het de specifieke versie van het project uitchecken, maar niet binnen een branch. Dit wordt een afgekoppelde (detached) HEAD genoemd - het houdt in dat het HEAD bestand direct naar een commit wijst en niet naar een symbolische referentie. Het probleem is dat je over het algemeen niet wilt werken in een detached HEAD omgeving, omdat het eenvoudig is om wijzigingen te verliezen. Als je een initiéle `submodule update` doet, in die submodule directory commit zonder een branch te maken om in te werken en dan nogmaals `git submodule update` uitvoert in het superproject zonder in de tussentijd te committen, dan zal Git je wijzigingen overschrijven zonder het je te vertellen. Technisch gezien ben je het werk niet kwijt, maar je zult geen branch hebben die er naar wijst, dus het zal wat lastig zijn om het terug te halen.

Om dit probleem te vermijden creéer je een branch zodra je in een submodule directory werkt met behulp van `git checkout -b work` of iets dergelijks. Als je de tweede keer de submodule update doet, zal het nog steeds je werk terugdraaien maar je heb tenminste een pointer om naar terug te keren.

Tussen branches omschakelen die submodules bevatten kan ook lastig zijn. Als je een nieuwe branch aanmaakt, daar een submodule toevoegt en dat terug wisselt naar een branch zonder die submodule, zul je nog steeds de submodule directory als een ungetrackte subdirectory hebben:

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

Je moet hem verplaatsen of verwijderen, in welk geval je hem opnieuw moet clonen als je terug wisselt. Daarbij loop je kans om lokale wijzigingen of branches te verliezen die je niet gepusht hebt.

De laatste grote valkuil waar veel mensen in lopen heeft te maken met het wisselen van subdirectories naar submodules. Als je bestanden in je project trackt, en je wilt ze naar een submodule verplaatsen, dan moet je voorzichtig zijn of zal Git boos op je worden. Stel dat je de rack bestanden in een subdirectory van je project hebt, en je wilt die naar een submodule omzetten. Als je de subdirectory weggooit en dan `submodule add` uitvoert, begint Git naar je te schreeuwen:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Je moet de `rack` subdirectory eerst unstagen. Dan kun je de submodule toevoegen:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Stel nu dat je dat in een branch gedaan zou hebben. Als je probeert terug te wisselen naar een branch waar die bestanden nog in de echte boom zitten in plaats van in een submodule - dan krijg je deze foutmelding:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Je moet de `rack` submodule directory uit de weg ruimen voordat je naar een branch kunt omschakelen die hem nog niet heeft:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Als je dan terug schakelt krijg je een lege `rack` directory. Je kunt dan nogmaals `git submodule update` uitvoeren om nog eens te clonen, of je kunt je `/tmp/rack` directory terug zetten in de lege directory.

## Subboom mergen ##

Nu je de moeilijkheden van het submodulesysteem hebt gezien, laten we eens kijken naar een alternatieve manier om hetzelfde probleem aan te pakken. Zodra Git merged, kijkt het naar wat het moet mergen en kiest dan een toepasselijke mergestrategie om te gebruiken. Als je twee branches aan het mergen bent zal Git een _recursive_ strategie gebruiken. Als je meer dan twee branches aan het mergen bent zal Git de _octopus_ strategie kiezen. Deze strategieén worden automatisch voor je gekozen omdat de recursieve strategie complexe drie-weg merge situaties aan kan - bijvoorbeeld meer dan één gezamenlijke voorouder, maar het kan het alleen mergen van twee branches aan. De octopus merge kan meerdere branches aan, maar is voorzichtiger om moeilijke conflicten te vermijden, dus wordt deze gekozen als de standaard strategie als je meer dan twee branches probeert te mergen.

Maar er zijn andere strategieén die je ook kunt kiezen. Eén ervan is de _subtree_ merge, en je kunt deze gebruiken om het subproject probleem aan te gaan. Hier zul je zien hoe je dezelfde rack inbedding kunt doen als in de vorige paragraaf, maar in plaats daarvan subboom-merges gebruiken.

Het idee van de subboom-merge is dat je twee projecten hebt, en één van de projecten komt overeen met een subdirectory van de andere en omgekeerd. Als je een subboommerge specificeert, dan is Git slim genoeg om erachter te komen dat de ene een subboom van de andere is en vervolgens juist te mergen - het is best wel verbazingwekkend.

Eerst voeg je de Rack applicatie toe aan je project. Voeg het Rack project toe als een remote reference in je eigen project en check het dan uit in zijn eigen branch:

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

Nu heb je de root van het Rack project in je `rack_branch` branch en je eigen project in de `master` branch. Als je eerste de ene uitchecked en dan de andere, kun je zien dat ze verschillende project roots hebben:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Je gaat nu het Rack project in je `master` project pullen als een subdirectory. Je kunt dat in Git doen met `git read-tree`. Je zult meer over `read-tree` en zijn vriendjes leren in Hoofdstuk 9, maar weet voor nu dat het de roottree van een branch in je huidige staging area en werkdirectory leest. Je hebt zojuist teruggewisseld naar je `master` branch, en je pulled de `rack_branch` branch in de `rack` subdirectory van de `master` branch van je hoofdproject:

	$ git read-tree --prefix=rack/ -u rack_branch

Als je commit, lijkt het alsof alle Rack bestanden in die subdirectory staan - alsof je ze uit een tarball gekopieerd hebt. Waar het interessant wordt is dat je vrij makkelijk veranderingen van één branch in de andere kunt mergen. Dus als het Rack project update kan je alle wijzigingen van stroomopwaartse binnenhalen door naar die branch te wisselen en te pullen:

	$ git checkout rack_branch
	$ git pull

Dan kun je die veranderingen terug in je master branch mergen. Je kunt `git merge -s subtree` gebruiken en het zal prima werken, maar Git zal ook de geschiedenissen samenvoegen, en dat wil je eigenlijk niet. Om de veranderingen binnen te halen en het commit bericht voor te vullen, gebruik je de `--squash` en `--no-commit` opties samen met de `-s subtree` strategie optie:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Alle wijzigingen van het Rack project worden gemerged en zijn klaar om lokaal gecommit te worden. Je kunt ook het tegenovergestelde doen: veranderingen doen in de `rack` subdirectory van de master branch en die later in je `rack_branch` branch mergen om ze naar de beheerders te sturen of ze stroomopwaarts te pushen.

Om een diff te krijgen tussen wat je in de `rack` subdirectory hebt en de code in je `rack_branch` branch (om te zien of je ze moet mergen) kan je niet het gebruikelijke `diff` commando toepassen. In plaats daarvan moet je `git diff-tree` uitvoeren met de branch waarmee je wilt vergelijken:

	$ git diff-tree -p rack_branch

Of om te vergelijken met wat in je `rack` subdirectory zit met wat in de `master` branch op de server zat toen je de laatste keer fetchde, kan je dit uitvoeren:

	$ git diff-tree -p rack_remote/master

## Samenvatting ##

Je hebt een aantal geavanceerde tools gezien, die je in staat stellen je commits en staging area heel exact te manipuleren. Als je problemen signaleert kun je vrij eenvoudig uitvinden welke commit deze geÃ¯ntroduceerd heeft, wanneer, en door wie. Als je subprojecten in je project wilt gebruiken, heb je een paar manieren gezien hoe je die een plaats kunt geven. Nu zou je in staat moeten zijn om de meeste dingen in Git te doen die je dagelijks op de commandline moet doen, en je erbij op je gemak te voelen.
