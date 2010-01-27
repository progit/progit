# Branchen in Git #

Bijna elk versiebeheersysteem ondersteunt een bepaalde vorm van branchen. Branchen komt erop neer dat je een tak afsplitst van de grote lijn van de ontwikkeling en daar verder mee werkt zonder de hoofdlijn te vervuilen. Bij veel VCS'en gaat dat nogal moeizaam, en eisen vaak van je dat je een nieuwe kopie maakt van de map waar je bronbestanden in staan, wat lang kan duren voor grote projecten.

Sommige mensen verwijzen naar het branch model in Git als de "killer eigenschap", en het maakt Git zeker apart in de VCS gemeenschap. Waarom is het zo bijzonder? De manier waarop Git branched is ongelooflijk lichtgewicht, waardoor branch operaties vrijwel instant zijn en het wisselen tussen de branches over het algemeen net zo snel. In tegenstelling to vele andere VCS's, moedigt Git een werkwijze aan die vaak branched en merged, zelfs meerdere keren per dag. Deze eigenschap begrijpen en beheersen geeft je een krachtig en uniek gereedschap en kan letterlijk de manier waarop je ontwikkeld veranderen.

## Wat Een Branch Is ##

Om de manier waarop Git branched echt te begrijpen, moeten we een stap terug doen en onderzoeken hoe Git zijn gegevens opslaat. Zoals je je kunt herinneren van Hoofdstuk 1, slaat Git zijn gegevens niet op als een reeks van verandersets of delta's, maar in plaats daarvan als een serie snapshots.

Als je in Git commit, dan slaat Git een commit object op dat een verwijzing bevat naar het snapshot van de inhoud die je gestaged hebt, de auteur en bericht metagegevens, en nul of meer verwijzingen naar de commit of commits die de directe ouders van deze commit waren: nul ouders voor de eerste commit, één ouder voor een normale commit, en meerdere ouders voor een commit die resulteert uit een samenvoeging of twee of meer branches.

Om dit te visualiseren, laten we aannemen dat je een map hebt die drie bestanden bevat, en je staged ze allemaal en commit. Door de bestanden te stagen krijgen ze allen een checksum (de SHA-1 hash die we in Hoofdstuk 1 noemden), bewaart die versie van het bestand in het Git repository (Git verwijst ernaar als blobs), en voegt die checksum toe aan het stage gebied:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Als je de commit aanmaakt door `git commit` uit te voeren, zal Git iedere submap van een checksum voorzien (in dit geval, alleen de hoofdmap). en die drie objecten in het Git repository opslaan. Daarna crëeert Git een commit object dat de metagegevens bevat en een verwijzing naar de hoofd project boom zodat het het snapshot kan namaken als dat nodig is.

Je Git repository bevat nu vijf objecten: een blob voor de inhoud van ieder van je drie bestanden, een boom dat de inhoud van de map weergeeft en specificeert welke bestandsnamen opgeslagen zijn als welke blobs, en een commit met de verwijzing naar die hoofd boom en alle commit metagegevens. Conceptueel zien de gegevens in je Git repository eruit zoals in Figuur 3-1.

Insert 18333fig0301.png 
Figuur 3-1. Enkele commit repository gegevens.

Als je wat wijzigingen doet en nogmaals commit, dan slaat de volgende commit een verwijzing op naar de commit die er direct aan vooraf ging. Na nog eens twee commits, zal je historie er misschien uit zien als Figuur 3-2.

Insert 18333fig0302.png 
Figuur 3-2. Git object gegevens voor meerdere commits.

Een branch in Git is simpelweg een lichtgewicht beweegbare verwijzing naar een van deze commits. De standaard branch naam in Git is master. Als je initieel commits maakt, dan wordt je een master branch gegeven die wijst naar de laatste commit die je gemaakt hebt. Iedere keer als je commit, beweegt het automatisch vooruit.

Insert 18333fig0303.png 
Figuur 3-3. Branch wijzend in de commit gegevens historie.

Wat gebeurt er als je een nieuwe branch maakt? Wel, door dat te doen wordt een nieuwe verwijzing aangemaakt voor jou om voort de duwen. Laten we zeggen dat je een nieuwe branch genaamd testing maakt. Je doet dit met het `git branch` commando:

	$ git branch testing

Dit maakt een nieuwe verwijzing naar dezelfde commit waar je nu op zit (zie Figuur 3-4).

Insert 18333fig0304.png 
Figuur 3-4. Meerdere branches wijzend naar de commit gegevens historie.

Hoe weet Git op welke branch je nu zit? Het houdt een speciale verwijzing bij genaamd HEAD. Let op dat dit heel anders is dan het concept van HEAD in andere VCS's waar je misschien gewend aan bent, zoals bijvoorbeeld Subversion of CVS. In Git, is dit een verwijzing naar de lokale branch waar je nu op zit. In dit geval, zit je nog steeds op master. Het git branch commando heeft alleen een nieuwe branch aangemaakt – het is nog niet omgeschakeld naar die branch (zie Figuur 3-5).

Insert 18333fig0305.png 
Figuur 3-5. HEAD bestand wijzend naar de branch waar je op zit.

Om te schakelen naar een bestaande branch, voer je het `git checkout` commando uit. Laten we eens omschakelen naar de nieuwe testing branch:

	$ git checkout testing

Dit verplaatst HEAD zodat het wijst naar de testing branch (zie Figuur 3-6).

Insert 18333fig0306.png
Figuur 3-6. HEAD wijst naar een andere branch als je omschakelt.

Wat is hier het belang van? Wel, laten we eens een andere commit doen:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Figuur 3-7 toont het resultaat.

Insert 18333fig0307.png 
Figuur 3-7. De branch waar HEAD naar wijst gaat vooruit met iedere commit.

Dit is interessant, omdat je testing branch nu vooruit is gegaan, maar je master branch nog steeds wijst naar de commit waar je op was toen je `git checkout` uitvoerde om om te schakelen. Laten we eens terugschakelen naar de master branch:

	$ git checkout master

Figuur 3-8 toont het resultaat.

Insert 18333fig0308.png 
Figuur 3-8. HEAD verschuift naar een andere branch bij een checkout.

Dat commando deed twee dingen. Het verplaatste de HEAD verwijzing terug naar de master branch, en het draaide de bestanden in je werkmap terug naar het snapshot waar master naar wijst. Dit betekend ook dat de wijzigingen die je vanaf dit punt maakt zullen afwijken van een oudere versie van het project. Het betekent in essentie dat het het werk dat je in je testing branch hebt gedaan tijdelijk terugdraait zodat je in een andere richting kunt gaan.

Laten we een paar wijzigingen doen en nog eens committen:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Nu is je project historie afgeweken (zie Figuur 3-9). Je hebt een branch gemaakt en bent er naartoe omgeschakeld, hebt er wat werk op gedaan, en bent toen teruggeschakeld naar je hoofd branch en hebt nog ander werk gedaan. Beide van die veranderingen zijn geïsoleerd van elkaar in aparte branches: je kunt heen en weer schakelen tussen de branches en ze samenvoegen als je klaar bent. En je hebt dat alles gedaan met eenvoudige `branch` en `checkout` commando's.

Insert 18333fig0309.png 
Figuur 3-9. De branch histories zijn uiteen gegaan.

Omdat een branch in Git in feite een eenvoudig bestand is dat de 40 karakter lange SHA-1 checksum van de commit bevat waar het naar wijst, zijn branches goedkoop om te maken en weg te gooien. Een nieuwe branch aanmaken is zo makkelijk en eenvoudig als 41 bytes naar een bestand schrijven (40 karakters en een harde return).

Dit is in scherp contrast met de manier waarop de meeste VCS applicaties branchen, wat inhoud dat alle project bestanden naar een tweede map gekopieerd worden. Dit kan enkele seconden of zelfs minuten duren, afhankelijk van de grootte van het project, en daarentegen is het in Git altijd meteen klaar is. En omdat we de ouders opslaan terwijl we comitten, wordt het vinden van een goede samenvoeg basis automatisch voor ons gedaan en is over het algemeen eenvoudig om te doen. Deze eigenschappen helpen ontwikkelaars aan te moedigen om branches vaak aan te maken en te gebruiken.

Laten we eens kijken waarom je dat zou moeten doen.

## Eenvoudig Branchen en Mergen ##

Laten we eens door een eenvoudig voorbeeld van branchen en mergen stappen met een werkwijze die je zou kunnen gebruiken in de echte wereld. Je zult deze stappen volgen:

1.	Werken aan een web site.
2.	Een branch aanmaken voor een nieuw verhaal waar je aan werkt.
3.	Wat werk doen in die branch.

Op dit punt, zul je een telefoontje ontvangen dat een ander probleem kritiek is, en dat je een snelle reparatie moet doen. Je zult het volgende doen:

1.	Terugdraaien naar je productie branch.
2.	Een branch aanmaken om de snelle reparatie toe te voegen.
3.	Nadat het getest is, de snelle reparatie branch samenvoegen, en dat naar productie terugzetten.
4.	Terugschakelen naar je originele verhaal en doorgaan met werken.

### Eenvoudig Branchen ###

Als eerste, laten we zeggen dat je aan je project werkt en al een paar commits hebt (zie Figuur 3-10).

Insert 18333fig0310.png 
Figuur 3-10. Een korte en eenvoudige commit historie.

Je hebt besloten dan je gaat werken aan probleem #53 in wat voor probleem beheersysteem je bedrijf ook gebruikt. Om duidelijk te zijn, Git is niet verbonden een een probleem beheersysteem in het bijzonder; maar omdat probleem #53 een beperkt onderwerp is waar je aan werkt, zul je een nieuwe branch aanmaken waarin je gaat werken. Om een branch aan te maken en er meteen naartoe te schakelen, kun je het `git checkout` commando uitvoeren met de `-b` optie:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Dit is een afkorting voor:

	$ git branch iss53
	$ git checkout iss53

Figuur 3-11 toont het resultaat.

Insert 18333fig0311.png 
Figuur 3-11. Een nieuwe branch verwijzing maken.

Je doet wat werk aan je web site en doet wat commits. Door dat te doen beweegt de `iss53` branch vooruit, omdat je het uitgechecked hebt (dat wil zeggen, je HEAD wijst ernaar; zie Figuur 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Figuur 3-12. De iss53 branch is vooruit gegaan met je werk.

Nu krijg je het telefoontje dan er een probleem is met de web site, en je moet het meteen repareren. Met Git hoef je je reparatie niet meteen uit te leveren samen met de `iss53` wijzigingen die je gedaan hebt, en je hoeft ook niet veel moeite te stoppen in het terugdraaien van die wijzigingen voordat je kunt werken aan het toepassen van je reparatie in productie. Het enige dat je moet doen in terugschakelen naar je master branch.

Maar, voordat je dat doet, let dan op dat als je werkmap of staging gebied wijzigingen bevat die nog niet gecommit zijn en conflicteren met de branch die je gaat uitchecken, dan laat Git je niet omschakelen. Het is het beste om een schone werk status te hebben als je tussen branches gaat schakelen. Er zijn altijd manieren om hier omheen te gaan (te weten, stashen en commit ammending). die we later gaan behandelen. Voor nu, heb je al je wijzigingen gecommit, zodat je terug kunt schakelen naar je master branch:

	$ git checkout master
	Switched to branch "master"

Op dit punt, is je project werkmap precies zoals het was voordat je begon te werken aan probleem #53, en je kunt je concentreren op je snelle reparatie. Dit is een belangrijk punt om te onthouden: Git hersteld je werkmap zodat die eruit ziet als het snapshot van de commit waar de branch die je uitchecked naar wijst. Het voegt toe, verwijderd en wijzigt bestanden automatisch om er zeker van te zijn dat je werkkopie eruit ziet zoals de branch eruit zag toen je er voor het laatst op committe.

Vervolgens heb je een snelle reparatie te doen. Laten we een reparatie branch maken om op te werken totdat het af is (zie Figuur 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figuur 3-13. snelle reparatie branch gebaseerd op de tip van je master branch.

Je kunt je tests draaien, er zeker van zijn dat de reparatie is wat je wil, en het samenvoegen met je master branch om het naar productie uit te rollen. Je doet dit met het `git merge` commando:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Je zult de uitdrukking "Fast forward" zien in die samenvoeging. Omdat de commit waar de branch waar je mee samenvoegde naar wees direct stroomopwaarts was van de commit waar je op zit, zal Git de verwijzing vooruit zetten. Om dat op een andere manier te zeggen, als je een commit probeert samen te voegen met een commit die bereikt kan worden door de historie van eerste commit te volgen, zal Git de dingen vereenvoudigen door de verwijzing vooruit te verplaatsen omdat er geen afwijkend werk is om samen te voegen – dit wordt een "Fast forward" genoemd.

Je wijziging is nu in het snapshot van de commit waar de `master` branch naar wijst, en je kunt je wijziging uitrollen (zie Figuur 3-14).

Insert 18333fig0314.png 
Figuur 3-14. Je master branch wijst naar dezelfde plek als de snelle reparatie branch na de wijziging.

Nadat je super-belangrijke reparatie uitgerold is, ben je klaar om terug te schakelen naar het werk dat je deed voordat je onderbroken werd. Maar, eerst zul je de snelle reparatie branch verwijderen, omdat je die niet langer nodig hebt – de `master` branch wijst naar dezelfde plek. Je kunt het verwijderen met de `-d` optie op `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Nu kun je terugschakelen naar je werk in uitvoering branch voor probleem #53 en doorgaan met daar aan te werken (zie Figuur 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Figure 3-15. Je iss53 branch kan onafhankelijk vooruit bewegen.

Het is interessant om hier op te merken dan het werk dat je in je snelle reparatie branch gedaan hebt, niet zit in de bestanden van je `iss53` branch. Als je dat binnen moet halen, dan kun je je `master` branch in je `iss53` branch samenvoegen door `git merge master` uit te voeren, of je kunt wachten met die wijzgingen te integreren totdat je beslist om je `iss53` branch later in je `master` binnen te halen.

### Eenvoudig Samenvoegen ###

Stel dat je besloten hebt dat je probleem #53 werk compleet is en klaar bent om samen ta gaan voegen in je `master` branch. Om dat te doen, zul je je `iss53` branch samenvoegen zoals je je snelle reparatie branch eerder hebt samengevoegd. Het enige dat je hoeft te doen is de branch uit te checken waar je in wenst samen te voegen en dan het `git merge` commando uit te voeren:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Dit ziet er iets anders uit dan de snelle reparatie samenvoeging die je eerder deed. In dit geval is je ontwikkelings historie afgeweken van een ouder punt. Omdat de commit op de branch waar je op zit geen directe voorouder is van de branch waar je in samenvoegt, moet Git wat werk doen. In dit geval, doet Git een eenvoudige drieweg samenvoeging, gebruikmakend van de twee snapshots waarnaar gewezen wordt door de branch punten en de gezamenlijke voorouder van die twee. Figuur 3-16 markeert de drie snapshots die Git gebruikt om zijn samenvoeging in dit geval te doen.

Insert 18333fig0316.png 
Figuur 3-16. Git identificeert automatisch de beste gezamenlijke voorouder samenvoegings basis voor het samenvoegen van de branches.

In plaats van de branch verwijzing vooruit te bewegen, maakt Git een nieuw snapshot dat resulteert uit deze drieweg samenvoeging en maakt automatisch een nieuwe commit die daar naar wijst (zie Figuur 3-17). Dit wordt een samenvoegings commit genoemd, en is bijzonder in dat het meer dan één ouder heeft.

Het is de moeite om te vertellen dat Git de beste gezamenlijke voorouder bepaald om te gebruiken als samenvoeg basis; dit is anders dan CVS of Subversion (voor versie 1.5), waarbij de ontwikkelaar die de samenvoeging deed zelf de beste samenvoeg basis moest uitzoeken. Dit zorgt er voor dat samenvoegen in Git een serieus stuk eenvoudiger is dan in deze andere systemen.

Insert 18333fig0317.png 
Figuur 3-17. Git maakt automatisch een nieuw commit object aan die het samengevoegde werk bevat.

Nu dat je werk samengevoegd is, heb je geen verdere noodzaak voor de `iss53` branch. Je kunt het verwijderen en dan handmatig het ticket in je ticket-volg systeem sluiten:

	$ git branch -d iss53

### Eenvoudige Samenvoeg Conflicten ###

Soms, gaat dit proces niet soepel. Als je hetzelfde gedeelte van hetzelfde bestand anders hebt gewijzigd in twee branches die je samenvoegt, dan zal Git niet in staat zijn om ze netjes samen te voegen. Als je reparatie voor probleem #53 hetzelfde gedeelte van een bestand heeft aangepast als de snelle reparatie, dan krijg je een samenvoeg conflict dat er ongeveer zo uit ziet:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git heeft niet automatisch een nieuwe samenvoeg commit gemaakt. Het heeft het proces gestopt totdat jij het conflict oplost. Als je wilt zien welke bestanden nog niet zijn samengevoegd op ieder punt na een samenvoeg conflict, dan kun je `git status` uitvoeren:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Alles dat samenvoeg conflicten heeft en dat nog niet is opgelost wordt getoond als niet-samengevoegd. Git voegt standaard conflict-oplossings markeringen toe aan de bestanden die conflicten hebben, zodat je ze handmatig kunt openen en die conflicten kunt oplossen. Je bestand bevat een sectie die er ongeveer zo uit ziet:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Dit betekend dat de versie in HEAD (jouw master branch, omdat dat hetgene was dat je uitgechecked had toen je je samenvoeg commando uitvoerdr) is het bovenste gedeelte van dat blok (alles boven de `======`), terwijl de versie in je `iss53` branch eruit ziet zoals alles in het onderste gedeelte. Om het conflict op te lossen, moet je één van de twee gedeeltes kiezen of de inhoud zelf samenvoegen. Bijvoorbeeld, je zou dit conflict op kunnen lossten door het hele blok met dit te vervangen:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Deze oplossing bevat een stukje uit elke sectie, en ik heb de `<<<<<<<`, `=======`, en `>>>>>>>` regels volledig verwijderd. Nadat je elk van deze secties opgelost hebt in elk conflicterend bestand, voer dan `git add` uit op ieder bestand om het als opgelost te markeren. Het bestand stagen markeert het als opgelost in Git.
Als je een grafische applicatie wil gebruiken om deze problemen op te lossen, kun je `git mergetool` uitvoeren, wat een toepasselijk visuele samenvoeg applicatie opstart en je door de conflicten heen loopt:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Als je een ander samenvoeg applicatie wil gebruiken dan de standaard (Git koos `opendiff` voor me in dit geval, omdat ik het commando uitvoerde op een Mac), dan kun je alle ondersteunde applicaties zien aan de top na "merge tool candidates". Type de naam van de applicatie die je liever gebruikt. In Hoofdstuk 7 zullen we bespreken hoe je deze standaard waarde voor je omgeving kunt wijzigen.

Nadat je de samenvoeg applicatie afsluit, vraagt Git je of de samenvoeging succesvol was. Als je het script verteld dat dat zo is, dan staged het het bestand om het voor je als opgelost te markeren.

Je kunt `git status` nogmaals uitvoeren om er zeker van te zijn dat alle conflicten opgelost zijn:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Als je daar blij mee bent, en je controleert dat alles waar conflicten in zaten gestaged zijn, dan kun je `git commit` typen om de samenvoeg commit af te ronden. Het commit bericht ziet er standaard ongeveer zo uit:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Je kunt dat bericht aanpassen met details over hoe je het conflict opgelost hebt, als je denkt dat dat behulpzaam zou zijn voor anderen die in de toekomst naar deze samenvoeging kijken – waarom je deed wat je deed, als dat niet vanzelfsprekend is.

## Branch Beheer ##

Nu heb je wat branches aangemaakt, samengevoegd, en verwijderd. Laten we eens kijken naar wat branch beheer applicaties die handig zijn als je begint met het doorlopend gebruik van branches.

Het `git branch` commando doet meer dan alleen branches aanmaken en verwijderen. Als je het zonder argumenten uitvoert, dan krijg je een eenvoudige uitvoer van je huidige branches:

	$ git branch
	  iss53
	* master
	  testing

Neem notie van het `*` karakter dat vooraf gaat aan de `master` branch: het geeft de branch aan die je op dit moment uitgechecked hebt. Dit betekend dat als je op dit punt commit, de `master` branch vooruit zal gaan met je nieuwe werk. Om de laatste commit op iedere branch te zient, kun je `git branch -v` uitvoeren:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Een andere handige optie om uit te vogelen in welke staat je branches zijn is om deze lijst te filteren op branches die je wel of nog niet samengevoegd hebt in de branch waar je nu op zit. De handige `--merged` en `--no-merged` opties zijn voor dit doel beschikbaar in Git sinds versie 1.5.6. Om te zien welke branches al samengevoegd zijn in de branch waar je nu op zit, kun je `git branch --merged` uitvoeren`:


	$ git branch --merged
	  iss53
	* master

Omdat je `iss53` al eerder hebt samengevoegd, zie je het terug in je lijst. Branches op deze lijst zonder de `*` ervoor zijn over het algemeen geschikt om te verwijderen met `git branch -d`: je hebt hun werk al in een andere branch zitten, dus je zult niets kwijtraken.

Om alle branches te zien die werk bevatten dat je nog niet samengevoegd hebt, kun je `git branch --no-merged` uitvoeren:

	$ git branch --no-merged
	  testing

Dit toont je andere branch. Omdat het werk bevat dat nog niet samengevoegd is, zal het proberen te werwijderen met `git branch -d` falen:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Als je de branch echt wilt verwijderen en dat werk wilt verliezen, dan kun je het forceren met `-D`, zoals het behulpzame bericht verteld.

## Branching Workflows ##

Now that you have the basics of branching and merging down, what can or should you do with them? In this section, we’ll cover some common workflows that this lightweight branching makes possible, so you can decide if you would like to incorporate it into your own development cycle.

### Long-Running Branches ###

Because Git uses a simple three-way merge, merging from one branch into another multiple times over a long period is generally easy to do. This means you can have several branches that are always open and that you use for different stages of your development cycle; you can merge regularly from some of them into others.

Many Git developers have a workflow that embraces this approach, such as having only code that is entirely stable in their `master` branch — possibly only code that has been or will be released. They have another parallel branch named develop or next that they work from or use to test stability — it isn’t necessarily always stable, but whenever it gets to a stable state, it can be merged into `master`. It’s used to pull in topic branches (short-lived branches, like your earlier `iss53` branch) when they’re ready, to make sure they pass all the tests and don’t introduce bugs.

In reality, we’re talking about pointers moving up the line of commits you’re making. The stable branches are farther down the line in your commit history, and the bleeding-edge branches are farther up the history (see Figure 3-18).

Insert 18333fig0318.png 
Figure 3-18. More stable branches are generally farther down the commit history.

It’s generally easier to think about them as work silos, where sets of commits graduate to a more stable silo when they’re fully tested (see Figure 3-19).

Insert 18333fig0319.png 
Figure 3-19. It may be helpful to think of your branches as silos.

You can keep doing this for several levels of stability. Some larger projects also have a `proposed` or `pu` (proposed updates) branch that has integrated branches that may not be ready to go into the `next` or `master` branch. The idea is that your branches are at various levels of stability; when they reach a more stable level, they’re merged into the branch above them.
Again, having multiple long-running branches isn’t necessary, but it’s often helpful, especially when you’re dealing with very large or complex projects.

### Topic Branches ###

Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and use for a single particular feature or related work. This is something you’ve likely never done with a VCS before because it’s generally too expensive to create and merge branches. But in Git it’s common to create, work on, merge, and delete branches several times a day.

You saw this in the last section with the `iss53` and `hotfix` branches you created. You did a few commits on them and deleted them directly after merging them into your main branch. This technique allows you to context-switch quickly and completely — because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.

Consider an example of doing some work (on `master`), branching off for an issue (`iss91`), working on it for a bit, branching off the second branch to try another way of handling the same thing (`iss91v2`), going back to your master branch and working there for a while, and then branching off there to do some work that you’re not sure is a good idea (`dumbidea` branch). Your commit history will look something like Figure 3-20.

Insert 18333fig0320.png 
Figure 3-20. Your commit history with multiple topic branches.

Now, let’s say you decide you like the second solution to your issue best (`iss91v2`); and you showed the `dumbidea` branch to your coworkers, and it turns out to be genius. You can throw away the original `iss91` branch (losing commits C5 and C6) and merge in the other two. Your history then looks like Figure 3-21.

Insert 18333fig0321.png 
Figure 3-21. Your history after merging in dumbidea and iss91v2.

It’s important to remember when you’re doing all this that these branches are completely local. When you’re branching and merging, everything is being done only in your Git repository — no server communication is happening.

## Remote Branches ##

Remote branches are references to the state of branches on your remote repositories. They’re local branches that you can’t move; they’re moved automatically whenever you do any network communication. Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.

They take the form `(remote)/(branch)`. For instance, if you wanted to see what the `master` branch on your `origin` remote looked like as of the last time you communicated with it, you would check the `origin/master` branch. If you were working on an issue with a partner and they pushed up an `iss53` branch, you might have your own local `iss53` branch; but the branch on the server would point to the commit at `origin/iss53`.

This may be a bit confusing, so let’s look at an example. Let’s say you have a Git server on your network at `git.ourcompany.com`. If you clone from this, Git automatically names it `origin` for you, pulls down all its data, creates a pointer to where its `master` branch is, and names it `origin/master` locally; and you can’t move it. Git also gives you your own `master` branch starting at the same place as origin’s `master` branch, so you have something to work from (see Figure 3-22).

Insert 18333fig0322.png 
Figure 3-22. A Git clone gives you your own master branch and origin/master pointing to origin’s master branch.

If you do some work on your local master branch, and, in the meantime, someone else pushes to `git.ourcompany.com` and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your `origin/master` pointer doesn’t move (see Figure 3-23).

Insert 18333fig0323.png 
Figure 3-23. Working locally and having someone push to your remote server makes each history move forward differently.

To synchronize your work, you run a `git fetch origin` command. This command looks up which server origin is (in this case, it’s `git.ourcompany.com`), fetches any data from it that you don’t yet have, and updates your local database, moving your `origin/master` pointer to its new, more up-to-date position (see Figure 3-24).

Insert 18333fig0324.png 
Figure 3-24. The git fetch command updates your remote references.

To demonstrate having multiple remote servers and what remote branches for those remote projects look like, let’s assume you have another internal Git server that is used only for development by one of your sprint teams. This server is at `git.team1.ourcompany.com`. You can add it as a new remote reference to the project you’re currently working on by running the `git remote add` command as we covered in Chapter 2. Name this remote `teamone`, which will be your shortname for that whole URL (see Figure 3-25).

Insert 18333fig0325.png 
Figure 3-25. Adding another server as a remote.

Now, you can run `git fetch teamone` to fetch everything server has that you don’t have yet. Because that server is a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (see Figure 3-26).

Insert 18333fig0326.png 
Figure 3-26. You get a reference to teamone’s master branch position locally.

### Pushing ###

When you want to share a branch with the world, you need to push it up to a remote that you have write access to. Your local branches aren’t automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share. That way, you can use private branches for work you don’t want to share, and push up only the topic branches you want to collaborate on.

If you have a branch named `serverfix` that you want to work on with others, you can push it up the same way you pushed your first branch. Run `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

This is a bit of a shortcut. Git automatically expands the `serverfix` branchname out to `refs/heads/serverfix:refs/heads/serverfix`, which means, “Take my serverfix local branch and push it to update the remote’s serverfix branch.” We’ll go over the `refs/heads/` part in detail in Chapter 9, but you can generally leave it off. You can also do `git push origin serverfix:serverfix`, which does the same thing — it says, “Take my serverfix and make it the remote’s serverfix.” You can use this format to push a local branch into a remote branch that is named differently. If you didn’t want it to be called `serverfix` on the remote, you could instead run `git push origin serverfix:awesomebranch` to push your local `serverfix` branch to the `awesomebranch` branch on the remote project.

The next time one of your collaborators fetches from the server, they will get a reference to where the server’s version of `serverfix` is under the remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

It’s important to note that when you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. In other words, in this case, you don’t have a new `serverfix` branch — you only have an `origin/serverfix` pointer that you can’t modify.

To merge this work into your current working branch, you can run `git merge origin/serverfix`. If you want your own `serverfix` branch that you can work on, you can base it off your remote branch:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

This gives you a local branch that you can work on that starts where `origin/serverfix` is.

### Tracking Branches ###

Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type git push, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.

When you clone a repository, it generally automatically creates a `master` branch that tracks `origin/master`. That’s why `git push` and `git pull` work out of the box with no other arguments. However, you can set up other tracking branches if you wish — ones that don’t track branches on `origin` and don’t track the `master` branch. The simple case is the example you just saw, running `git checkout -b [branch] [remotename]/[branch]`. If you have Git version 1.6.2 or later, you can also use the `--track` shorthand:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Now, your local branch sf will automatically push to and pull from origin/serverfix.

### Deleting Remote Branches ###

Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

## Rebasing ##

In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### The Basic Rebase ###

If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png 
Figure 3-27. Your initial diverged commit history.

The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.

Insert 18333fig0328.png 
Figure 3-28. Merging a branch to integrate the diverged work history.

However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.

Insert 18333fig0329.png 
Figure 3-29. Rebasing the change introduced in C3 onto C4.

At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).

Insert 18333fig0330.png 
Figure 3-30. Fast-forwarding the master branch.

Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### More Interesting Rebases ###

You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
Figure 3-31. A history with a topic branch off another topic branch.

Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
Figure 3-32. Rebasing a topic branch off another topic branch.

Now you can fast-forward your master branch (see Figure 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figure 3-33. Fast-forwarding your master branch to include the client branch changes.

Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
Figure 3-34. Rebasing your server branch on top of your master branch.

Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figure 3-35. Final commit history.

### The Perils of Rebasing ###

Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Do not rebase commits that you have pushed to a public repository.**

If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
Figure 3-36. Clone a repository, and base some work on it.

Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
Figure 3-37. Fetch more commits, and merge them into your work.

Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).

Insert 18333fig0339.png 
Figure 3-39. You merge in the same work again into a new merge commit.

You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## Summary ##

We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
