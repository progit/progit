# Branchen in Git #

Bijna elk versiebeheersysteem ondersteunt een bepaalde vorm van branchen. Branchen komt erop neer dat je een tak afsplitst van de grote lijn van de ontwikkeling en daar verder mee werkt zonder de hoofdlijn te vervuilen. Bij veel VCS'en gaat dat nogal moeizaam, en eisen vaak van je dat je een nieuwe kopie maakt van de map waar je bronbestanden in staan, wat lang kan duren voor grote projecten.

Sommige mensen verwijzen naar het branch model in Git als de "killer eigenschap", en het maakt Git zeker apart in de VCS gemeenschap. Waarom is het zo bijzonder? De manier waarop Git branched is ongelooflijk lichtgewicht, waardoor branch operaties vrijwel instant zijn en het wisselen tussen de branches over het algemeen net zo snel. In tegenstelling to vele andere VCS's, moedigt Git een werkwijze aan die vaak branched en merged, zelfs meerdere keren per dag. Deze eigenschap begrijpen en beheersen geeft je een krachtig en uniek gereedschap en kan letterlijk de manier waarop je ontwikkelt veranderen.

## Wat Een Branch Is ##

Om de manier waarop Git branched echt te begrijpen, moeten we een stap terug doen en onderzoeken hoe Git zijn gegevens opslaat. Zoals je je kunt herinneren van Hoofdstuk 1, slaat Git zijn gegevens niet op als een reeks van verandersets of delta's, maar in plaats daarvan als een serie snapshots.

Als je in Git commit, dan slaat Git een commit object op dat een verwijzing bevat naar het snapshot van de inhoud die je gestaged hebt, de auteur en bericht metagegevens, en nul of meer verwijzingen naar de commit of commits die de directe ouders van deze commit waren: nul ouders voor de eerste commit, één ouder voor een normale commit, en meerdere ouders voor een commit die resulteert uit een samenvoeging of twee of meer branches.

Om dit te visualiseren, laten we aannemen dat je een map hebt die drie bestanden bevat, en je staged ze allemaal en commit. Door de bestanden te stagen krijgen ze allen een checksum (de SHA-1 hash die we in Hoofdstuk 1 noemden), bewaart die versie van het bestand in het Git repository (Git verwijst ernaar als blobs), en voegt die checksum toe aan het stage gebied:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Als je de commit aanmaakt door `git commit` uit te voeren, zal Git iedere submap van een checksum voorzien (in dit geval, alleen de hoofdmap); en die drie objecten in het Git repository opslaan. Daarna crëeert Git een commit object dat de metagegevens bevat en een verwijzing naar de hoofd project boom zodat het het snapshot kan namaken als dat nodig is.

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

Dat commando deed twee dingen. Het verplaatste de HEAD verwijzing terug naar de master branch, en het draaide de bestanden in je werkmap terug naar het snapshot waar master naar wijst. Dit betekent ook dat de wijzigingen die je vanaf dit punt maakt zullen afwijken van een oudere versie van het project. Het betekent in essentie dat het het werk dat je in je testing branch hebt gedaan tijdelijk terugdraait zodat je in een andere richting kunt gaan.

Laten we een paar wijzigingen doen en nog eens committen:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Nu is je project historie afgeweken (zie Figuur 3-9). Je hebt een branch gemaakt en bent er naartoe omgeschakeld, hebt er wat werk op gedaan, en bent toen teruggeschakeld naar je hoofd branch en hebt nog ander werk gedaan. Beide van die veranderingen zijn geïsoleerd van elkaar in aparte branches: je kunt heen en weer schakelen tussen de branches en ze samenvoegen als je klaar bent. En je hebt dat alles gedaan met eenvoudige `branch` en `checkout` commando's.

Insert 18333fig0309.png 
Figuur 3-9. De branch histories zijn uiteen gegaan.

Omdat een branch in Git in feite een eenvoudig bestand is dat de 40 karakter lange SHA-1 checksum van de commit bevat waar het naar wijst, zijn branches goedkoop om te maken en weg te gooien. Een nieuwe branch aanmaken is zo makkelijk en eenvoudig als 41 bytes naar een bestand schrijven (40 karakters en een harde return).

Dit is in scherp contrast met de manier waarop de meeste VCS applicaties branchen, wat inhoud dat alle project bestanden naar een tweede map gekopieerd worden. Dit kan enkele seconden of zelfs minuten duren, afhankelijk van de grootte van het project, en daarentegen is het in Git altijd meteen klaar. En omdat we de ouders opslaan terwijl we comitten, wordt het vinden van een goede samenvoeg basis automatisch voor ons gedaan en is over het algemeen eenvoudig om te doen. Deze eigenschappen helpen ontwikkelaars aan te moedigen om branches vaak aan te maken en te gebruiken.

Laten we eens kijken waarom je dat zou moeten doen.

## Eenvoudig Branchen en Mergen ##

Laten we eens door een eenvoudig voorbeeld van branchen en mergen stappen met een werkwijze die je zou kunnen gebruiken in de echte wereld. Je zult deze stappen volgen:

1.	Werken aan een website.
2.	Een branch aanmaken voor een nieuw verhaal waar je aan werkt.
3.	Wat werk doen in die branch.

Dan ontvang je een telefoontje dat je een ander probleem direct moet repareren. Je zult het volgende doen:

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

Op dit punt, is je project werkmap precies zoals het was voordat je begon te werken aan probleem #53, en je kunt je concentreren op je snelle reparatie. Dit is een belangrijk punt om te onthouden: Git herstelt je werkmap zodat die eruit ziet als het snapshot van de commit waar de branch die je uitchecked naar wijst. Het voegt toe, verwijdert en wijzigt bestanden automatisch om er zeker van te zijn dat je werkkopie eruit ziet zoals de branch eruit zag toen je er voor het laatst op committe.

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

Je zult de uitdrukking "Fast forward" zien in die samenvoeging. Omdat de commit van de branch waar je mee samenvoegde direct stroomopwaarts was van de commit waar je op zit, zal Git de verwijzing vooruit zetten. Om dat op een andere manier te zeggen, als je een commit probeert samen te voegen met een commit die bereikt kan worden door de historie van eerste commit te volgen, zal Git de dingen vereenvoudigen door de verwijzing vooruit te verplaatsen omdat er geen afwijkend werk is om samen te voegen – dit wordt een "Fast forward" genoemd.

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
Figuur 3-15. Je iss53 branch kan onafhankelijk vooruit bewegen.

Het is interessant om hier op te merken dat het werk dat je in je snelle reparatie branch gedaan hebt, niet zit in de bestanden van je `iss53` branch. Als je dat binnen moet halen, dan kun je je `master` branch in je `iss53` branch samenvoegen door `git merge master` uit te voeren, of je kunt wachten met die wijzigingen te integreren totdat je beslist om je `iss53` branch later in je `master` binnen te halen.

### Eenvoudig Samenvoegen ###

Stel dat je besloten hebt dat je probleem #53 werk compleet is en klaar bent om samen te gaan voegen in je `master` branch. Om dat te doen, zul je je `iss53` branch samenvoegen zoals je je snelle reparatie branch eerder hebt samengevoegd. Het enige dat je hoeft te doen is de branch uit te checken waar je in wenst samen te voegen en dan het `git merge` commando uit te voeren:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Dit ziet er iets anders uit dan de snelle reparatie samenvoeging die je eerder deed. In dit geval is je ontwikkelings historie afgeweken van een ouder punt. Omdat de commit op de branch waar je op zit geen directe voorouder is van de branch waar je in samenvoegt, moet Git wat werk doen. In dit geval, doet Git een eenvoudige drieweg samenvoeging, gebruikmakend van de twee snapshots waarnaar gewezen wordt door de branch punten en de gezamenlijke voorouder van die twee. Figuur 3-16 markeert de drie snapshots die Git gebruikt om zijn samenvoeging in dit geval te doen.

Insert 18333fig0316.png 
Figuur 3-16. Git identificeert automatisch de beste gezamenlijke voorouder samenvoegings basis voor het samenvoegen van de branches.

In plaats van de branch verwijzing vooruit te bewegen, maakt Git een nieuw snapshot dat resulteert uit deze drieweg samenvoeging en maakt automatisch een nieuwe commit die daar naar wijst (zie Figuur 3-17). Dit wordt een samenvoegings commit genoemd, en is bijzonder in dat het meer dan één ouder heeft.

Het is de moeite om te vertellen dat Git de beste gezamenlijke voorouder bepaalt om te gebruiken als samenvoeg basis; dit is anders dan CVS of Subversion (voor versie 1.5), waarbij de ontwikkelaar die de samenvoeging deed zelf de beste samenvoeg basis moest uitzoeken. Dit zorgt er voor dat samenvoegen in Git een serieus stuk eenvoudiger is dan in deze andere systemen.

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

Dit betekend dat de versie in HEAD (jouw master branch, omdat dat hetgene was dat je uitgechecked had toen je je samenvoeg commando uitvoerde) is het bovenste gedeelte van dat blok (alles boven de `======`), terwijl de versie in je `iss53` branch eruit ziet zoals alles in het onderste gedeelte. Om het conflict op te lossen, moet je één van de twee gedeeltes kiezen of de inhoud zelf samenvoegen. Bijvoorbeeld, je zou dit conflict op kunnen lossen door het hele blok met dit te vervangen:

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

Nadat je de samenvoeg applicatie afsluit, vraagt Git je of de samenvoeging succesvol was. Als je het script vertelt dat dat zo is, dan staged het het bestand om het voor je als opgelost te markeren.

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

Neem notie van het `*` karakter dat vooraf gaat aan de `master` branch: het geeft de branch aan die je op dit moment uitgechecked hebt. Dit betekent dat als je op dit punt commit, de `master` branch vooruit zal gaan met je nieuwe werk. Om de laatste commit op iedere branch te zien, kun je `git branch -v` uitvoeren:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Een andere handige optie om uit te vogelen in welke staat je branches zijn, is om deze lijst te filteren op branches die je wel of nog niet samengevoegd hebt in de branch waar je nu op zit. De handige `--merged` en `--no-merged` opties zijn voor dit doel beschikbaar in Git sinds versie 1.5.6. Om te zien welke branches al samengevoegd zijn in de branch waar je nu op zit, kun je `git branch --merged` uitvoeren`:


	$ git branch --merged
	  iss53
	* master

Omdat je `iss53` al eerder hebt samengevoegd, zie je het terug in je lijst. Branches op deze lijst zonder de `*` ervoor zijn over het algemeen geschikt om te verwijderen met `git branch -d`: je hebt hun werk al in een andere branch zitten, dus je zult niets kwijtraken.

Om alle branches te zien die werk bevatten dat je nog niet samengevoegd hebt, kun je `git branch --no-merged` uitvoeren:

	$ git branch --no-merged
	  testing

Dit toont je andere branch. Omdat het werk bevat dat nog niet samengevoegd is, zal het proberen te verwijderen met `git branch -d` falen:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Als je de branch echt wilt verwijderen en dat werk wilt verliezen, dan kun je het forceren met `-D`, zoals het behulpzame bericht verteld.

## Branch Werkwijzen ##

Nu dat je de basis van het branchen en samenvoegen onder de knie hebt, wat kan of zou je met ze kunnen doen? In dit gedeelte gaan we over een aantal veel voorkomende werkwijzen die deze lichtgewicht branches mogelijk maken, zodat je kunt beslissen of dat je ze wilt integreren in je ontwikkel cyclus.

### Lang-Lopende Branches ###

Omdat Git gebruik maakt van een eenvoudige drieweg samenvoeging, is het meerdere keren samenvoegen vanuit een branch met een andere over een langere periode over het algemeen eenvoudig om te doen. Dit betekent dat je meerdere branches kunt hebben, die altijd open staan en die je voor verschillende delen van je ontwikkel cyclus gebruikt; je kunt regelmatig samenvoegen van een aantal ervan in de anderen.

Veel Git ontwikkelaars hebben een werkwijze die deze aanpak omarmd, zoals het hebben van alleen volledig stabiele code in hun `master` branch – waarschijnlijk alleen code die is of zal worden vrijgegeven. Ze hebben een andere parallelle branch genaamd develop of next waarop ze werken of die ze gebruiken om stabiliteit te testen – het is niet noodzakelijk altijd stabiel, maar zodra het naar een stabiele status gaat, kan het worden samengevoegd in `master`. Het wordt gebruikt om onderwerp branches (branches met een korte levensduur, zoals jou eerdere `iss53` branch) binnen te halen, zodra die klaar zijn, om er zeker van te zijn dat ze voor alle testen slagen en geen fouten introduceren.

In werkelijkheid praten we over verwijzingen die zich verplaatsen over de lijn van de commits die je maakt. De stabiele branches zijn verder naar achter in je commit historie, en de splinternieuwe branches zijn verder naar voren in de historie (zie Figuur 3-18).

Insert 18333fig0318.png 
Figuur 3-18. Meer stabiele branches zijn vaak verder naar achter in de commit historie.

Ze zijn over het algemeen makkelijker voor te stellen als werk silo's, waar sets van commits slagen naar een meer stabiele silo als ze volledig getest zijn (zie Figuur 3-19).

Insert 18333fig0319.png 
Figuur 3-19. Het kan handig zijn om je branches voor te stellen als silo's.

Je kunt dit doen voor meerdere nivo's van stabiliteit. Sommige grotere projecten hebben ook een `proposed` of `pu` (proposed updates) branch die branches geïntegreerd heeft die wellicht nog niet klaar zijn om in de `next` of `master` branch te gaan. Het idee is dat je branches op verschillende nivo's van stabiliteit zitten; zodra ze een stabiel nivo bereiken, worden ze in de branch boven hun samengevoegd.
Nogmaals, het hebben van langlopende branches is niet noodzakelijk, maar het helpt vaak wel, in het bijzonder als je moet omgaan met zeer grote of complexe projecten.

### Onderwerp Branches ###

Maar, onderwerp branches zijn bruikbaar in projecten van iedere grootte. Een onderwerp branch is een kortlopende branch die je maakt en gebruikt om een enkele eigenschap of gerelateerd werk in te doen. Dit is iets wat je waarschijnlijk nooit vantevoren met een VCS gedaan hebt, omdat het over het algemeen te duur is om branches aan te maken en samen te voegen. Maar in Git komt het vaak voor om branches aan te maken, op te werken, en te verwijderen meerdere keren per dag.

Je zag dit in het laatste gedeelte met de `iss53` en `hotfix` branches die je gemaakt had. Je hebt een aantal commits op ze gedaan en ze meteen verwijderd zodra je ze samengevoegd had in je hoofd branch. Deze techniek staat je toe om snel en volledig van context te veranderen – omdat je werk is gescheiden in silo's waar alle wijzigingen in die branch met dat onderwerp te maken hebben, is het makkelijker te zien wat er is gebeurd tijdens een code review en dergelijke. Je kunt de wijzigingen daar minuten, dagen of maanden bewaren, en ze samenvoegen als je er klaar voor bent, ongeacht in de volgorde waarin ze gemaakt of aan gewerkt zijn.

Neem als voorbeeld een situatie waarbij wat werk gedaan wordt (op `master`), gebranched wordt voor een probleem (`iss91`), waar een beetje aan gewerkt wordt, gebranched wordt vanaf de tweede branch om op een andere manier te proberen hetzelfde op te lossen (`iss91v2`) terug te gaan naar je master branch en daar een tijdje te werken, en dan vanaf daar branchen om wat werk te doen waarvan je niet zeker weet of het wel een goed idee is (`dumbidea` branch). Je commit historie zal er uit zien als Figuur 3-20.

Insert 18333fig0320.png 
Figuur 3-20. Je commit geschiedenis met meerdere onderwerp branches.

Nu, laten we zeggen dat je beslist dat je de tweede oplossing voor je probleem het beste vindt (`iss91v2`); en je hebt de `dumbidea` branch aan je collega's laten zien, en het blijkt geniaal te zijn. Je kunt dan de originel `iss91` weggooien (waarbij je commits C5 en C6 verliest), en de andere twee samenvoegen. Je historie ziet er dan uit als Figuur 3-21).

Insert 18333fig0321.png 
Figuur 3-21. Je historie na het samenvoegen van dumbidea en iss91v2.

Het is belangrijk om te onthouden dat wanneer je dit alles doet, deze branches volledig lokaal zijn. Als je aan het branchen of samenvoegen bent, dan wordt alles gedaan in jouw Git repository – dus er gebeurt geen server communicatie.

## Remote Branches ##

Remote branches zijn referenties naar de staat ven de branches op je remote repositories. Ze zijn lokale branches die jij niet kunt verplaatsen; ze worden automatisch verplaatst zodra je wat netwerk communicatie doet. Remote branches gedragen zich als boekenleggers om je eraan te helpen herinneren waar de branches op je remote repositories waren de laatste keer dat je met ze in contact was.

Ze hebben de vorm `(remote)/(branch)`. Bijvoorbeeld, als je wil zien hoe de `master` branch op je `origin` er uit zag vanaf de laatste dat je er mee gecommuniceerd hebt, dan jou je de `origin/master` branch bekijken. Als je aan het werk bent aan een probleem met een partner en zij hebben een `iss53` branch teruggezet, dan zou je je eigen lokale `iss53` kunnen hebben; maar de branch op de server zou wijzen naar de commit op `origin/iss53`.

Dit kan wat verwarrend zijn, dus laten we eens naar een voorbeeld kijken. Stel dat je een Git server op je netwerk hebt op `git.ourcompany.com`. Als je hiervan cloned dan wordt die automatisch `origin` voor je genoemd, Git haalt al zijn gegevens binnen, maakt een verwijzing naar waar zijn `master` branch is, en noemt dat lokaal `origin/master`; en je kunt het niet verplaatsen. Git geeft je ook je eigen `master` branch, beginnend op dezelfde plaats als de `master` branch van origin, zodat je iets hebt om vanaf te werken (zie Figuur 3-22).

Insert 18333fig0322.png 
Figuur 3-22. Een Git clone geeft je je eigen master branch en origin/master wijzend naar de master branch van origin.

Als je wat werk doet op je lokale master branch, en in de tussentijd zet iemand anders iets terug naar `git.ourcompany.com` en vernieuwt die master branch, dan zijn jullie histories verschillend vooruit geschoven. En, zolang je geen contact hebt met je origin server, zal je `origin/master` verwijzing niet verplaatsen (zie Figuur 3-23).

Insert 18333fig0323.png 
Figuur 3-23. Lokaal werken terwijl iemand anders naar je remote server terugzet laat iedere historie anders vooruit gaan.

Om je werk te synchroniseren, voer je een `git fetch origin` commando uit. Dit commando bekijkt welke server origin is (in dit geval is het `git.ourcompany.com`), haalt gegevens er vanaf die je nog niet hebt, en vernieuwt je lokale gegevensbank, waarbij je `origin/master` verwijzing naar zijn nieuwere positie verplaast wordt (zie Figuur 3-24).

Insert 18333fig0324.png 
Figuur 3-24. Het git fetch commando vernieuwt je remote referenties.

Om het hebben van meerdere remote servers te demonstreren en hoe remote branches voor die remote projecten er uit zien, laten we eens aannemen dat je nog een interne Git server hebt, die alleen wordt gebruikt voor ontwikkeling gedaan door een van je sprint teams. Deze server bevindt zich op `git.team1.ourcompany.com`. Je kunt het als een nieuwe remote referentie toevoegen aan het project waar je nu aan werkt door het `git remote add` commando uit te voeren, zoals we behandeld hebben in Hoofdstuk 2. Noem deze remote `teamone`, wat je afkorting voor die hele URL wordt (zie Figuur 3-25).

Insert 18333fig0325.png 
Figuur 3-25. Een andere server als een remote toevoegen.

Nu kun je `git fetch teamone` uitvoeren om alles op te halen dat de server heeft en jij nog niet. Omdat server een subset is van de gegevens die je `origin` server op dit moment heeft, haalt Git geen gegevens maar stelt een remote branch genaamd `teamone/master` in om te wijzen naar de commit die `teamone` heeft naar zijn `master` branch (zie Figuur 3-26).

Insert 18333fig0326.png 
Figuur 3-26. Je krijgt lokaal een referentie naar de positie van teamone's master branch.

### Terugzetten ###

Als je een branch wil delen met de wereld, dan moet je het naar een remote terugzetten waar je schrijftoegang op hebt. Je lokale branches worden niet automatisch gesynchroniseerd met de remotes waar je naar schrijft – je moet de branches die je wilt delen expliciet terugzetten. Op die manier, kun je privé branches gebruiken voor werk dat je niet wil delen, en alleen de onderwerp branches terugzetten waar je op wilt samenwerken.

Als je een branch genaamd `serverfix` hebt, waar je met anderen aan wilt werken, dan kun je die terugzetten op dezelfde manier waarop je je eerste branch hebt teruggezet. Voer `git push (remote) (branch)` uit:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Dit is een beetje kort door de bocht. Git zal de `serverfix` branchnaam automatisch expanderen naar `refs/heads/serverfix:refs/heads/serverfix`, wat betekent "Neem mijn lokale serverfix branch en zet dat terug om de serverfix branch van de remote te vernieuwen.". We zullen in detail over het `refs/heads` gedeelte gaan hebben in Hoofdstuk 9, maar je kunt het over het algemeen weglaten. Je kun ook `git push origin serverfix:serverfix` doen, wat hetzelfde doet – het zegt, "Neem mijn serverfix en maak het de serverfix van de remote." Je kunt dit formaat gebruiken om een lokale branch naar een remote branch die anders heet terug te zetten. Als je niet wil dat het `serverfix` heet aan de remote kant, kun je in plaats daarvan `git push origin serverfix:awesomebranch` gebruiken om je lokale `serverfix` branch naar de `awesomebranch` op het remote project terug te zetten.

De volgende keer dat één van je medewerkers van de server fetched, zullen ze een referentie krijgen naar waar de servers versie van `serverfix` is onder de remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Het is belangrijk om op te merken dat als je een fetch doet die nieuwe remote branches ophaalt, je niet automatisch lokale, aanpasbare kopiëen daarvan hebt. In andere woorden, in dit geval heb je geen nieuwe `serverfix` branch – je hebt alleen een `origin/serverfix` verwijzing die je niet kunt aanpassen.

Om dit werk in je huidige werk branch samen te voegen, kun je `git merge origin/serverfix` uitvoeren. Als je je eigen `serverfix` branch wilt waar je op kunt werken, dan kun je deze vanaf je remote branch baseren:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Dit geeft je een lokale branch waar je op kunt werken, die begint met waar `origin/serverfix` is.

### Volg Branches ###

Een lokale branch uitchecken van een remote branch creëert automatisch een zogenaamde _volg branch_ (_tracking branch_). Volg branches zijn lokale branches die een directe releatie met een remote branch hebben. Als je op een volg branch zit en git push typed, dat weet Git automatisch naar welke server en branch hij moet terugzetten. En, terwijl je op een van die branches zit zal het uitvoeren van `git pull` alle remote referenties ophalen en ze automatisch in de corresponderende remote branch samenvoegen.

Als je een repository cloned, zal het over het algemeen automatisch een `master` branch aanmaken, die `origin/master` volgt. Daarom werken `git push` en `git pull` zo uit het doosje, zonder verdere argumenten. Maar, kun je kunt ook andere volg branches instellen als je dat wilt – anderen die niet branches volgen op `origin` en niet de `master` branch volgen. Het eenvoudige geval is het voorbeeld dat je zojuist zag, `git checkout -b [branch] [remotenaam]/[branch]` uitvoeren. Als je Git versie 1.6.2 of nieuwer hebt, kun je ook de `--track` afkorting gebruiken:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Om een lokale branch in te stellen met een andere naam dan de remote branch, kun je eenvoudig de eerste versie met een andere lokale branch naam gebruiken:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Nu zal je lokale sf branch automatisch halen en terugzetten van origin/serverfix.

### Remote Branches Verwijderen ###

Stel dat je klaar bent met een remote branch – stel dat jij en je medewerkers klaar zijn met een eigenschap en het hebben samengevoegd in je `master` branch van je remote (of welke branch je stabiele codelijn ook in zit). Dan kun je een remote branch verwijderen door de nogal stompzinnige syntax `git push [remotenaam] :[branch]` te gebruiken. Als je je `serverfix` branch van de server wilt verwijderen, dan voer je het volgende uit:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boem. Geen branch meer op je server. Je zult deze pagina wel een ezelsoor willen geven, omdat je dat commando nodig hebt, en je het waarschijnlijk zult vergeten. Een manier om dit commando te onthouden is door de `git push [remotenaam] [lokalebranch]:[remotebranch]` syntax te onthouden die we iets eerder behandeld hebben. Als je het `[lokalebranch]` gedeelte weglaat, dan zeg je in feite, "Neem iets willekeurigs aan mijn kant en maak dat de `[remotebranch]`."

## Rebasen ##

In Git zijn er twee hoofdmanieren om wijzigingen te integreren van één branch in een andere: de `samenvoeging` en de `rebase`. In dit gedeelte zul je leren wat rebasen is, hoe je het moet doen, waarom het een zeer bijzondere toepassing is, en in welke gevallen je het niet wilt gebruiken.

### De Eenvoudige Rebase ###

Als je teruggaat naar een eerder voorbeeld van de Samenvoegen sectie (zie Figuur 3-27), dan kun je zien dat je werk is afgeweken en dat je commits hebt gedaan op de twee verschillende branches.

Insert 18333fig0327.png 
Figuur 3-27. Je initiele afgeweken historie.

De eenvoudigste weg om de branches te integreren, zoals we al hebben besproken, is het `samenvoeg` commando. Het voert een drieweg samenvoeging uit tussen de twee laatste snapshots van de branches (C3 en C4), en de meest recente gezamenlijke voorouder van die twee (C2), creëeert een nieuw snapshot (en commit), zoals getoond in Figuur 3-28.

Insert 18333fig0328.png 
Figuur 3-28. Een branch samenvoegen om de afgeweken werk historie te integreren.

Maar, er is een andere manier: je kunt de patch van de wijziging die werd geïntroduceerd in C3 pakken en die opnieuw toepassen bovenop C4. In Git, wordt dit _rebasen_ genoemd. Met het `rebase` commando, kun je alle wijzigingen pakken die zijn gecommit op een branch, en ze opnieuw afspelen op een andere.

In dit voorbeeld, zou je het volgende uitvoeren:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Het werkt door naar de gezamenlijke voorouder van de twee branches te gaan (degene waar je op zit en degene waar je naar rebased), de diff pakken die geïntroduceerd is bij iedere commit op de branch waar je op zit, die diffs in tijdelijke bestanden bewaren, de huidige branch terugzetten naar dezelfde commit als de branch waar je op rebased, en uiteindelijk iedere wijziging om de beurt toepassen, Figuur 3-29 toont dit proces.

Insert 18333fig0329.png 
Figuur 3-29. De wijzigingen die geïntroduceerd zijn in C3 rebasen op C4.

Op dit punt kun je terug gaan naar de master branch en een fast-forward samenvoeging doen (zie Figuur 3-30).

Insert 18333fig0330.png 
Figuur 3-30. De master branch Fast-forwarden.

Nu is het snapshot waar C3 naar wijst precies hetzelfde als degene waar C5 naar wees in het samenvoeg voorbeeld. Er zit geen verschil in het eindproduct van de integratie, maar rebasen zorgt voor een schonere historie. Als je de log van een gerebasete branch bekijkt, ziet het eruit als een lineaire historie: het lijkt alsof al het werk in serie is gebeurt, zelfs als het in werkelijkheid in parallel gedaan is.

Vaak zul je dit doen om er zeker van te zijn dat je commits netjes aansluiten op een remote branch – misschien in een project waar je op probeert bij te dragen, maar dat je niet onderhoudt. In dit geval zou je je werk in een branch doen en dan je werk rebasen op `origin/master` als je klaar ben om je patches in te sturen naar het hoofd project. Op die manier hoeft de beheerder geen integratie werk te doen – gewoon een fast-forward of een schone toepassing.

Let op het snapshot waar de laatste commit naar wijst waar je mee eindigt, of het de laatste van de gerebasete commits voor een rebase is, of de laatste samenvoeg commit na een samenvoeging, het is hetzelfde snapshot – alleen de historie is verschillend. Rebasen speelt veranderingen van een werklijn opnieuw af op een andere in de volgorde waarin ze geïntroduceerd waren, en samenvoegen pakt de eindpunten en voegt die samen.

### Meer Interessante Rebases ###

Je kunt je rebase ook opnieuw laten afspelen op iets anders dan de rebase branch. Pak een historie zoals in Figuur 3-31, bijvoorbeeld. Je hebt een onderwerp branch afgesplitst (`server`) om wat server-kant functionaliteit toe te voegen aan je project, en toen een commit gedaan. Daarna, heb je daar vanaf gebranched om de client-kant wijzigingen te doen (`client`) en een paar keer gecommit. Als laatste, ben je teruggegaan naar je server branch en hebt nog een paar commits gedaan.

Insert 18333fig0331.png 
Figuur 3-31. Een historie met een onderwerp branch vanaf een andere onderwerp branch.

Stel dat je beslist dat je je client-kant wijzigingen wilt samenvoegen in je hoofdlijn voor een vrijgave, maar je wilt de server-kant wijzigingen nog laten wachten totdat het verder getest is. Je kunt de wijzigingen van client pakken, die nog niet op server zitten (C8 en C9) en die opnieuw afspelen op je master branch door de `--onto` optie te gebruiken van `git rebase`:

	$ git rebase --onto master server client

Dit zegt in feite, "Check de client branch uit, vogel de patches van de gezamenlijke voorouder van de `client` en de `server` branches uit, en speel die opnieuw af op `master`." Het is een beetje complex; maar het resultaat, getoond in Figuur 3-32, is erg vet.

Insert 18333fig0332.png 
Figuur 3-32. Een onderwerp branch rebasen vanaf een andere onderwerp branch.

Nu kun je een fast-forward doen van je master branch (zie Figuur 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figuur 3-33. Je master branch fast-forwarden om de client branch wijzigingen mee te nemen.

Stel dat je beslist om je server branch ook binnen te halen. Je kunt de server branch rebasen op de master branch zonder het eerst te moeten uitchecken door `git rebase [basisbranch] [onderwerpbranch]` uit te voeren – wat de onderwerp branch uitchecked (in dit geval, `server`) voor je en het opnieuw afspeelt om de basis branch (`master`):

	$ git rebase master server

Dit speelt je `server` werk opnieuw af bovenop je `master` werk, zoals getoond in Figuur 3-34.

Insert 18333fig0334.png 
Figuur 3-34. Je server branch bovenop je master branch rebasen.

Daarna, kun je de basis branch (`master`) fast-forwarden:

	$ git checkout master
	$ git merge server

Je kunt de `client` en `server` branches verwijderen, omdat al het werk geïntegreerd is en je ze niet meer nodig hebt, waarbij je historie voor het hele proces er uit ziet zoals Figuur 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figuur 3-35. Uiteindelijke commit historie.

### De Gevaren van Rebasen ###

Ahh, maar de zegen van rebasen is niet zonder nadelen, wat samengevat kan worden in een enkele regel:

**Rebase geen commits die je teruggezet hebt naar een publiek repository.**

Als je die richtlijn volgt, dan gebeurt je niets. Als je dat niet doet, zullen mensen je haten, en je zult door vrienden en familie uitgehoond worden.

Als je spullen rebaset, laat je bestaande commits achter en maak je nieuwe aan die vergelijkbaar zijn maar anders. Als je commits ergens naartoe zet en andere halen ze binnen en baseren daar werk op, en vervolgens herschrijf je die commits met `git rebase` en zet ze opnieuw terug, dan zullen je medewerkers hun werk opnieuw moeten samenvoegen en zullen de dingen vervelend worden als je hun werk probeert binnen te halen in het jouwe.

Laten we eens kijken naar een voorbeeld of hoe werk rebasen dat je publiekelijk gemaakt hebt problemen kan veroorzaken. Stel dat je van een centrale server cloned en dan daar wat werk vanaf doet. Je commit historie ziet er uit als Figuur 3-36.

Insert 18333fig0336.png 
Figuur 3-36. Clone een repository, en baseer wat werk daarop.

Nu, doet iemand anders wat meer werk dat een samenvoeging bevat, en zet dat werk terug naar de centrale server. Je pakt dat en voegt de nieuwe remote branch in jouw werk, zodat je historie er uit ziet zoals Figuur 3-37.

Insert 18333fig0337.png 
Figuur 3-37. Haal meer commits op, en voeg ze samen in je werk.

Daarna, beslist de persoon die het werk teruggezet heeft om terug te gaan en hun werk in plaats daarvan te rebasen; ze voeren een `git push --force` uit om de historie op de server te herschrijven. Je haalt dan van die server op, waarbij je de nieuwe commits omlaag haalt.

Insert 18333fig0338.png 
Figuur 3-38. Iemand zet gerebasete commits terug, daarbij commits achterlatend waar jij werk op gebaseerd hebt.

Op dit punt, moet je dit werk opnieuw samenvoegen, alhoewel je dat al gedaan hebt. Rebasen verandert de SHA-1 hashes van deze commits, dus voor Git zien ze er uit als nieuwe commits, terwijl je in feite als het C4 werk in je historie hebt (zie Figuur 3-39).

Insert 18333fig0339.png 
Figuur 3-39. Je voegt hetzelfde werk opnieuw samen in een nieuwe samenvoegingscommit.

Je moet dat werk op een bepaald punt samenvoegen, zodat je bij kunt blijven met de andere ontwikkelaar in de toekomst. Nadat je dat doet, zal je history zowel de C4 als de C4' commits bevatten, die verschillende SHA-1 hashes hebben, maar hetzelfde werk introduceren en hetzelfde commit bericht hebben. Als je een `git log` uitvoert als je historie er zo uitziet, dan zul je twee commits zien die dezelfde auteur en bericht hebben, wat verwarrend zal zijn. Daarnaast, als je deze historie terugzet naar de server, dan zul je al die gerebasete commits opnieuw introduceren op de centrale server, wat mensen nog meer kan verwarren.

Als je rebasen behandelt als een manier om op te ruimen en met commits werkt voordat je ze terugzet, en als je alleen commits rebaset die nog nooit publiekelijk beschikbaar zijn geweest, dan zal alles in orde zijn. Als je commits rebaset die al publiekelijk teruggezet zijn, en mensen kunnen werk gebaseerd hebben op die commits, dan bereid je maar voor op wat frustrerende problemen.

## Samenvatting ##

We hebben basis branchen en samenvoegen behandeld in Git. Je moet je op je gemak voelen met het maken en omschakelen naar nieuwe branches, schakelen tussen branches, en lokale branches samen te voegen. Je zou in staat moeten zijn om je branches te delen door ze naar een gedeelde server terug te zetten, met anderen op gedeelde branches samen te werken en je branches te rebasen voordat ze gedeeld zijn.
