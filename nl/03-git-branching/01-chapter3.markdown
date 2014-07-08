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
# Branchen in Git #

Bijna elk versiebeheersysteem ondersteunt een bepaalde vorm van branchen. Branchen komt erop neer dat je een tak afsplitst van de hoofd-ontwikkellijn en daar verder mee gaat werken zonder aan de hoofdlijn te komen. Bij veel VCS'en is dat nogal een duur proces, vaak wordt er een nieuwe kopie gemaakt van de directory waar je broncode in staat, wat lang kan duren voor grote projecten.

Sommige mensen verwijzen naar het branch model in Git als de "killer eigenschap", en het onderscheidt Git zeker in de VCS-gemeenschap. Waarom is het zo bijzonder? De manier waarop Git brancht is ongelooflijk lichtgewicht, waardoor branch operaties vrijwel instant zijn en het wisselen tussen de branches over het algemeen net zo snel. In tegenstelling tot vele andere VCS's, moedigt Git juist een workflow aan waarbij vaak gebrancht en gemerged wordt, zelfs meerdere keren per dag. Deze eigenschap begrijpen en de techniek beheersen geeft je een krachtig en uniek gereedschap en kan letterlijk de manier waarop je ontwikkelt veranderen.

## Wat is een branch ##

Om de manier waarop Git brancht echt te begrijpen, moeten we een stap terug doen en onderzoeken hoe Git zijn gegevens opslaat. Zoals je je misschien herinnert van Hoofdstuk 1, slaat Git zijn gegevens niet op als een reeks van wijzigingen of delta's, maar in plaats daarvan als een serie snapshots.

Als je in Git commit, dan slaat Git een commit object op dat een verwijzing bevat naar het snapshot van de inhoud die je gestaged hebt, de auteur- en bericht-metagegevens, en nul of meer verwijzingen naar de commit of commits die de directe ouders van deze commit waren: nul ouders voor de eerste commit, één ouder voor een normale commit, en meerdere ouders voor een commit die het resultaat is van een merge van twee of meer branches.

Om dit te visualiseren, gaan we aannemen dat je een directory hebt met drie bestanden, en je staget en commit ze allemaal. Je gaat de bestanden stagen waardoor ze allemaal een checksum krijgen (de SHA-1 hash waar we het in Hoofdstuk 1 over hadden), bewaart die versie van het bestand in het Git repository (Git noemt ze blobs), en voegt die checksum toe aan de staging area:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Als je de commit aanmaakt door `git commit` uit te voeren zal Git iedere directory in het project van een checksum voorzien en slaat ze als boomstructuur (`tree`) objecten in de Git repository op. Daarna creëert Git een `commit` object dat de metagegevens bevat en een verwijzing naar de hoofd-`tree`-object van het project zodat Git deze snapshot opnieuw kan oproepen als dat nodig is.

Je Git repository bevat nu vijf objecten: een blob voor de inhoud van ieder van de drie bestanden, een tree die de inhoud van de directory weergeeft en specificeert welke bestandsnamen opgeslagen zijn als welke blobs, en een commit met de verwijzing naar die hoofd-tree en alle commit-metagegevens. Conceptueel zien de gegevens in je Git repository eruit zoals in Figuur 3-1.

Insert 18333fig0301.png
Figuur 3-1. Repository gegevens van een enkele commit.

Als je wat wijzigingen maakt en nogmaals commit, dan slaat de volgende commit een verwijzing op naar de commit die er direct aan vooraf ging. Na nog eens twee commits, zal je historie er ongeveer uit zien als Figuur 3-2.

Insert 18333fig0302.png
Figuur 3-2. Git objectgegevens voor meerdere commits.

Een branch in Git is simpelweg een lichtgewicht verplaatsbare verwijzing naar een van deze commits. De standaard branch-naam in Git is master. Als je initieel commits maakt, dan krijg je een `master`-branch die wijst naar de laatste commit die je gemaakt hebt. Iedere keer als je commit, beweegt het automatisch vooruit.

Insert 18333fig0303.png
Figuur 3-3. Branch wijzend in de commit gegevens historie.

Wat gebeurt er als je een nieuwe branch maakt? Door dat te doen wordt een nieuwe verwijzing voor je aangemaakt die je dan kunt verplaatsen. Laten we zeggen dat je een nieuwe branch genaamd testing maakt. Je doet dit met het `git branch` commando:

	$ git branch testing

Dit maakt een nieuwe verwijzing naar dezelfde commit waar je nu op zit (zie Figuur 3-4).

Insert 18333fig0304.png
Figuur 3-4. Meerdere branches wijzend naar de commit-gegevenshistorie.

Hoe weet Git op welke branch je nu zit? Het houdt een speciale verwijzing bij genaamd HEAD. Let op dat dit heel anders is dan het concept van HEAD in andere VCS's waar je misschien gewend aan bent, zoals Subversion of CVS. In Git is dit een verwijzing naar de lokale branch waar je nu op zit. In dit geval zit je nog steeds op master. Het `git branch`-commando heeft alleen een nieuwe branch aangemaakt - we zijn nog niet overgeschakeld naar die branch (zie Figuur 3-5).

Insert 18333fig0305.png
Figuur 3-5. HEAD-bestand wijzend naar de branch waar je op zit.

Om over te schakelen naar een bestaande branch, voer je het `git checkout` commando uit. Laten we eens overschakelen naar de nieuwe testing branch:

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

Dit is interessant, omdat je testing branch nu vooruit is gegaan, maar je master branch nog steeds wijst naar de commit waar je op was toen je `git checkout` uitvoerde voor het overschakelen. Laten we eens terugschakelen naar de `master` branch:

	$ git checkout master

Figuur 3-8 toont het resultaat.

Insert 18333fig0308.png
Figuur 3-8. HEAD verschuift naar een andere branch bij een checkout.

Dat commando heeft twee dingen gedaan. Het verplaatste de HEAD verwijzing terug naar de `master` branch, en het draaide de bestanden in je werkdirectory terug naar de snapshot waar die `master` naar wijst. Dit betekent ook dat de wijzigingen die je vanaf dit punt maakt uiteen zullen gaan lopen met een oudere versie van het project. In essentie betekent het dat het werk dat je in je testing branch hebt gedaan tijdelijk wordt teruggedraaid, zodat je een andere richting op kunt gaan.

Laten we een paar wijzigingen maken en nog eens committen:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Nu is je projecthistorie uiteengelopen (zie Figuur 3-9). Je hebt een branch gemaakt en bent er naartoe overgeschakeld, hebt er wat werk op gedaan, en bent toen teruggeschakeld naar je hoofd-branch en hebt nog wat ander werk gedaan. Al die veranderingen zijn geïsoleerd van elkaar in aparte branches: je kunt heen en weer schakelen tussen de branches en ze mergen als je klaar bent. En je hebt dat alles gedaan met eenvoudige `branch` en `checkout` commando's.

Insert 18333fig0309.png
Figuur 3-9. De branch-histories zijn uiteen gaan lopen.

Omdat een branch in Git in feite een eenvoudig bestand is dat de 40 karakter lange SHA-1 checksum van de commit bevat waar het naar wijst, zijn branches goedkoop om te maken en weer weg te gooien. Een nieuwe branch aanmaken is zo snel en eenvoudig als 41 bytes naar een bestand schrijven (40 karakters en een harde return).

Dit is in scherp contrast met de wijze waarop de meeste VCS applicaties branchen, wat vaak het kopiëren van alle projectbestanden naar een tweede map inhoudt. Dit kan enkele seconden of zelfs minuten duren, afhankelijk van de grootte van het project, daarentegen is het in Git altijd vrijwel meteen klaar. En omdat we de ouders opslaan terwijl we committen, wordt het vinden van een goed punt dat kan dienen als basis voor het mergen automatisch voor ons gedaan en is dat over het algemeen eenvoudig om te doen. Deze eigenschappen moedigen ontwikkelaars aan om vaak branches aan te maken en te gebruiken.

Laten we eens kijken waarom je dat zou moeten doen.

## Eenvoudig branchen en mergen ##

Laten we eens door een eenvoudig voorbeeld van branchen en mergen stappen met een workflow die je zou kunnen gebruiken in de echte wereld. Je zult deze stappen volgen:

1. Werken aan een website.
2. Een branch aanmaken voor een nieuw verhaal waar je aan werkt.
3. Wat werk doen in die branch.

Dan ontvang je een telefoontje dat je een ander probleem direct moet repareren. Je zult het volgende doen:

1. Terugschakelen naar je productie-branch.
2. Een branch aanmaken om de snelle reparatie toe te voegen.
3. Nadat het getest is de snelle reparatie-branch mergen, en dat naar productie terugzetten.
4. Terugschakelen naar je originele verhaal en doorgaan met werken.

### Eenvoudig branchen ###

Als eerste, laten we zeggen dat je aan je project werkt en al een paar commits hebt staan (zie Figuur 3-10).

Insert 18333fig0310.png
Figuur 3-10. Een korte en eenvoudige commit-historie.

Je hebt besloten dan je gaat werken aan probleem #53 in wat voor systeem je bedrijf ook gebruikt om problemen te registreren. Voor de duidelijkheid: Git is niet verbonden met een specifiek probleembeheersysteem. Omdat probleem #53 een onderwerp is waar je gericht aan gaat werken, maak je een nieuwe branch aan waarin je aan de slag gaat. Om een branch aan te maken en er meteen naartoe te schakelen, kun je het `git checkout` commando uitvoeren met de `-b` optie:

	$ git checkout -b iss53
	Switched to a new branch 'iss53'

Dit is een afkorting voor:

	$ git branch iss53
	$ git checkout iss53

Figuur 3-11 toont het resultaat.

Insert 18333fig0311.png
Figuur 3-11. Een nieuwe branch-verwijzing maken.

Je doet wat werk aan je website en doet wat commits. Door dat te doen beweegt de `iss53` branch vooruit, omdat je het uitgecheckt hebt (dat wil zeggen, je HEAD wijst ernaar; zie Figuur 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png
Figuur 3-12. De iss53 branch is vooruit gegaan met je werk.

Nu krijg je het telefoontje dat er een probleem is met de website, en je moet het meteen repareren. Met Git hoef je de reparatie niet tegelijk uit te leveren met de `iss53` wijzigingen die je gemaakt hebt, en je hoeft ook niet veel moeite te doen om die wijzigingen terug te draaien voordat je kunt werken aan het toepassen van je reparatie in productie. Het enige wat je moet doen is terugschakelen naar je master-branch.

Maar voordat je dat doet, merk op dat als je werk-directory of staging area wijzigingen bevatten die nog niet gecommit zijn en conflicteren met de branch die je gaat uitchecken, Git je niet laat omschakelen. Het beste is om een schone werkstatus te hebben als je tussen branches gaat schakelen. Er zijn manieren om hier mee om te gaan (te weten, stashen en commit ammending) die we later gaan behandelen. Voor nu heb je alle wijzigingen gecommit, zodat je terug kunt schakelen naar je master-branch:

	$ git checkout master
	Switched to branch "master"

Hierna is je project-werk-directory precies zoals het was voordat je begon te werken aan probleem #53, en je kunt je concentreren op je snelle reparatie. Dit is een belangrijk punt om te onthouden: Git herstelt je werk-directory zodanig dat deze eruit ziet als het snapshot van de commit waar de branch die je uitcheckt naar wijst. Het voegt automatisch bestanden toe, verwijdert en wijzigt ze om er zeker van te zijn dat je werkkopie eruit ziet zoals de branch eruit zag toen je er voor het laatst op committe.

Vervolgens heb je een snelle reparatie (hotfix) te doen. Laten we een reparatie-branch maken om op te werken totdat het af is (zie Figuur 3-13):

	$ git checkout -b hotfix
	Switched to a new branch 'hotfix'
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix 3a0874c] fixed the broken email address
	 1 files changed, 1 deletion(-)

Insert 18333fig0313.png
Figuur 3-13. snelle reparatie branch gebaseerd op de positie van je master branch.

Je kunt je tests draaien, jezelf ervan verzekeren dat de reparatie is wat je wil, en het mergen in je master-branch en het naar productie uitrollen. Je doet dit met het `git merge` commando:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast-forward
	 README | 1 -
	 1 file changed, 1 deletion(-)

Je zult de uitdrukking "Fast forward" zien in die merge. Omdat de commit van de branch waar je mee mergede direct stroomopwaarts is van de commit waar je op zit, zal Git de verwijzing vooruit verplaatsen. Om het op een andere manier te zeggen, als je een commit probeert te mergen met een commit die bereikt kan worden door de historie van eerste commit te volgen, zal Git de dingen vereenvoudigen door de verwijzing vooruit te verplaatsen omdat er geen afwijkend werk is om te mergen; dit wordt een "fast forward" genoemd.

Je wijziging zit nu in het snapshot van de commit waar de `master` branch naar wijst, en je kunt je wijziging uitrollen (zie Figuur 3-14).

Insert 18333fig0314.png
Figuur 3-14. Je master-branch wijst na de merge naar dezelfde plek als de hotfix branch.

Nadat je super-belangrijke reparatie uitgerold is, ben je klaar om terug te schakelen naar het werk dat je deed voordat je onderbroken werd. Maar, eerst ga je de hotfix branch verwijderen, omdat je die niet langer nodig hebt - de `master` branch wijst naar dezelfde plek. Je kunt het verwijderen met de `-d` optie op `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Nu kun je terugschakelen naar je werk-in-uitvoering-branch voor probleem #53 en doorgaan met daaraan te werken (zie Figuur 3-15):

	$ git checkout iss53
	Switched to branch 'iss53'
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53 ad82d7a] finished the new footer [issue 53]
	 1 file changed, 1 insertion(+)

Insert 18333fig0315.png
Figuur 3-15. Je `iss53`-branch kan onafhankelijk vooruitbewegen.

Het is nuttig om hier op te merken dat het werk dat je in de `hotfix`-branch gedaan hebt, niet in de bestanden van je `iss53` branch zit. Als je dat binnen moet halen, dan kun je de `master`-branch in de `iss53`-branch mergen door `git merge master` uit te voeren, of je kunt wachten met die wijzigingen te integreren tot het moment dat je het besluit neemt de `iss53`-branch in de `master` te trekken.

### Eenvoudig samenvoegen ###

Stel dat je besloten hebt dat je probleem #53 werk gereed is en klaar bent om het te mergen in de `master`-branch. Om dat te doen, zul je de `iss53`-branch mergen zoals je die hotfix branch eerder hebt gemerged. Het enige dat je hoeft te doen is de branch uit te checken waar je in wenst te mergen en dan het `git merge` commando uit te voeren:

	$ git checkout master
	$ git merge iss53
	Auto-merging README
	Merge made by the 'recursive' strategy.
	 README | 1 +
	 1 file changed, 1 insertion(+)

Dit ziet er iets anders uit dan de `hotfix` merge die je eerder gedaan hebt. In dit geval is je ontwikkelhistorie afgeweken van een eerder punt. Omdat de commit op de branch waar je op zit geen directe voorouder is van de branch waar je in merget, moet Git wat werk doen. In dit geval doet Git een eenvoudige drieweg-merge, gebruikmakend van de twee snapshots waarnaar gewezen wordt door de uiteinden van de branch en de gezamenlijke voorouder van die twee. Figuur 3-16 markeert de drie snapshots die Git in dit geval gebruikt om de merge te doen.

Insert 18333fig0316.png
Figuur 3-16. Git identificeert automatisch de meest geschikte gezamenlijke voorouder als basis voor het mergen van de branches.

In plaats van de branch-verwijzing vooruit te verplaatsen, maakt Git een nieuw snapshot dat het resultaat is van deze drieweg-merge en maakt automatisch een nieuwe commit die daarnaar wijst (zie Figuur 3-17). Dit wordt een merge-commit genoemd, en is bijzonder in die zin dat het meer dan één ouder heeft.

Het is belangrijk om erop te wijzen dat Git de meest geschikte gezamenlijke voorouder bepaalt om te gebruiken als merge basis; dit is anders dan CVS of Subversion (voor versie 1.5), waar de ontwikkelaar die de merge doet ook degene is die de beste merge-basis moest uitzoeken. Dit maakt het mergen in Git een behoorlijk stuk eenvoudiger in vergelijking met deze andere systemen.

Insert 18333fig0317.png
Figuur 3-17. Git maakt automatisch een nieuw commit-object aan die het gemergede werk bevat.

Nu dat je werk gemerged is, is er geen verdere noodzaak meer voor de `iss53`-branch. Je kunt deze verwijderen en daarna handmatig de ticket in het ticket-volgsysteem sluiten:

	$ git branch -d iss53

### Eenvoudige merge conflicten ###

Af en toe verloopt dit proces niet zo soepel. Als je hetzelfde gedeelte van hetzelfde bestand op een andere manier hebt gewijzigd in twee branches die je merget, dan zal Git niet in staat zijn om ze netjes te mergen. Als je reparatie voor probleem #53 hetzelfde gedeelte van een bestand heeft gewijzigd als de `hotfix`, dan krijg je een merge conflict dat er ongeveer zo uit ziet:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git heeft geen nieuwe merge-commit gemaakt. Het heeft het proces gepauzeerd zolang jij het conflict aan het oplossen bent. Als je wilt zien welke bestanden nog niet zijn gemerged op enig punt na een merge conflict, dan kun je `git status` uitvoeren:

	$ git status
	On branch master
	You have unmerged paths.
	  (fix conflicts and run "git commit")
	
	Unmerged paths:
	  (use "git add <file>..." to mark resolution)
	
	        both modified:      index.html
	
	no changes added to commit (use "git add" and/or "git commit -a")

Alles wat merge-conflicten heeft en wat nog niet is opgelost wordt getoond als unmerged. Git voegt standaard conflict-oplossingsmarkeringen toe aan de bestanden die conflicten hebben, zodat je ze handmatig kunt openen en die conflicten kunt oplossen. Je bestand bevat een sectie die er zo ongeveer uit ziet:

	<<<<<<< HEAD
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53

Dit betekent dat de versie in HEAD (jouw master branch, omdat dat degene was dat je uitgecheckt had toen je het merge-commando uitvoerde) is het bovenste gedeelte van dat blok (alles boven de `======`), terwijl de versie in je `iss53`-branch eruit ziet zoals alles in het onderste gedeelte. Om het conflict op te lossen, moet je één van de twee gedeeltes kiezen of de inhoud zelf mergen. Je zou bijvoorbeeld dit conflict op kunnen lossen door het hele blok met dit te vervangen:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Deze oplossing bevat een stukje uit beide secties, en ik heb de `<<<<<<<`, `=======`, en `>>>>>>>` regels volledig verwijderd. Nadat je elk van deze secties opgelost hebt in elk conflicterend bestand, voer dan `git add` uit voor elk van die bestanden om het als opgelost te markeren. Het bestand stagen markeert het als opgelost in Git.
Als je een grafische applicatie wil gebruiken om deze problemen op te lossen, kun je `git mergetool` uitvoeren, wat een toepasselijk grafische merge-applicatie opstart dat je door de conflicten heen leidt:

	$ git mergetool

	This message is displayed because 'merge.tool' is not configured.
	See 'git mergetool --tool-help' or 'git help config' for more details.
	'git mergetool' will now attempt to use one of the following tools:
	opendiff kdiff3 tkdiff xxdiff meld tortoisemerge gvimdiff diffuse diffmerge ecmerge p4merge araxis bc3 codecompare vimdiff emerge
	Merging:
	index.html

	Normal merge conflict for 'index.html':
	  {local}: modified file
	  {remote}: modified file
	Hit return to start merge resolution tool (opendiff):

Als je een andere dan de standaard merge-tool wilt gebruiken (Git koos `opendiff` voor me in dit geval, omdat ik het commando uitvoerde op een Mac), dan kun je alle ondersteunde applicaties opgenoemd zien na "... one of the following tools:". Type de naam van de applicatie die je liever gebruikt. In Hoofdstuk 7 zullen we bespreken hoe je deze standaard waarde voor jouw omgeving kunt wijzigen.

Nadat je de merge applicatie afsluit, vraagt Git je of de merge succesvol was. Als je het script vertelt dat dit het geval is, dan staget dit script het bestand voor je om het als opgelost te markeren.

Je kunt `git status` nogmaals uitvoeren om er zeker van te zijn dat alle conflicten opgelost zijn:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   index.html
	
Als je het daar mee eens bent, en je gecontroleerd hebt dat alles waar conflicten in zaten gestaged is, dan kun je `git commit` typen om de merge-commit af te ronden. Het commit-bericht ziet er standaard ongeveer zo uit:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Je kunt dat bericht aanpassen met details over hoe je het conflict opgelost hebt, als je denkt dat dat behulpzaam zal zijn voor anderen die in de toekomst naar deze merge kijken - waarom je hebt gedaan wat je gedaan hebt, als dat niet vanzelfsprekend is.

## Branch-beheer ##

Nu heb je wat branches aangemaakt, gemerged, en verwijderd. Laten we eens kijken naar wat branch-beheer-toepassingen die handig zijn als je vaker branches gaat gebruiken.

Het `git branch` commando doet meer dan alleen branches aanmaken en verwijderen. Als je het zonder argumenten uitvoert, dan krijg je een eenvoudige lijst van de huidige branches:

	$ git branch
	  iss53
	* master
	  testing

Merk op dat het `*` karakter vooraf gaat aan de `master` branch: het geeft de branch aan die je op dit moment uitgecheckt hebt. Dit betekent dat als je op dit punt commit, de `master` branch vooruit zal gaan met je nieuwe werk. Om de laatste commit op iedere branch te zien, kun je `git branch -v` uitvoeren:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Een andere handige optie om uit te vinden in welke staat je branches zijn, is om deze lijst te filteren op branches die je wel of nog niet gemerged hebt in de branch waar je nu op zit. De handige `--merged` en `--no-merged` opties zijn voor dit doel beschikbaar in Git. Om te zien welke branches al gemerged zijn in de branch waar je nu op zit, kun je `git branch --merged` uitvoeren:


	$ git branch --merged
	  iss53
	* master

Omdat je `iss53` al eerder hebt gemerged, zie je het terug in je lijst. Branches op deze lijst zonder de `*` ervoor zijn over het algemeen zonder problemen te verwijderen met `git branch -d`; je hebt hun werk al in een andere branch zitten, dus je zult niets kwijtraken.

Om alle branches te zien die werk bevatten dat je nog niet gemerged hebt, kun je `git branch --no-merged` uitvoeren:

	$ git branch --no-merged
	  testing

Dit toont je andere branch. Omdat het werk bevat dat nog niet samengevoegd is, zal het proberen te verwijderen met `git branch -d` falen:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Als je de branch echt wilt verwijderen en dat werk wilt verliezen, dan kun je het forceren met `-D`, zoals het behulpzame bericht je al meldt.

## Branch workflows ##

Nu je de basis van het branchen en mergen onder de knie hebt, wat kan of zou je daarmee kunnen doen? In deze paragraaf gaan we een aantal veel voorkomende workflows die deze lichtgewicht branches mogelijk maken behandelen, zodat je kunt besluiten of je ze wilt toepassen in je eigen ontwikkelcyclus.

### Langlopende branches ###

Omdat Git gebruik maakt van een eenvoudige drieweg-merge, is het meerdere keren mergen vanuit een branch in een andere gedurende een langere periode over het algemeen eenvoudig te doen. Dit betekent dat je meerdere branches kunt hebben, die altijd open staan en die je voor verschillende delen van je ontwikkelcyclus gebruikt; je kunt regelmatig vanuit een aantal mergen in andere.

Veel Git-ontwikkelaars hebben een workflow die deze aanpak omarmt, zoals het hebben van alleen volledig stabiele code in hun `master` branch — mogelijk alleen code die is of zal worden vrijgegeven. Ze hebben een andere parallelle branch "develop" of "next" genaamd waarop ze werken of die ze gebruiken om stabiliteit te testen — het is niet noodzakelijkerwijs altijd stabiel, maar zodra het in een stabiele status verkeert, kan het worden gemerged in `master`. Deze wordt gebruikt om topic branches (branches met een korte levensduur, zoals jou eerdere `iss53`-branch) te pullen zodra die klaar zijn, om zich ervan te overtuigen dat alle testen slagen en er geen fouten worden geïntroduceerd.

Feitelijk praten we over verwijzingen die worden verplaatst over de lijn van de commits die je maakt. De stabiele branches zijn verder naar achterop in je commit-historie, en de splinternieuwe branches zijn verder naar voren in de historie (zie Figuur 3-18).

Insert 18333fig0318.png
Figuur 3-18. Meer stabiele branches zijn over het algemeen verder naar achter in de commit-historie.

Ze zijn misschien makkelijker voor te stellen als werksilo's, waar sets van commits stapsgewijs naar een meer stabiele silo worden gepromoveerd als ze volledig getest zijn (zie Figuur 3-19).

Insert 18333fig0319.png
Figuur 3-19. Het kan handig zijn om je branches voor te stellen als silo's.

Je kunt dit blijven doen voor elk niveau van stabiliteit. Sommige grotere projecten hebben ook een `proposed` of `pu` (proposed updates) branch die branches geïntegreerd heeft die wellicht nog niet klaar zijn om in de `next` of `master` branch te gaan. Het idee erachter is dat de branches op verschillende niveaus van stabiliteit zitten. Zodra ze een stabieler niveau bereiken, worden ze in de branch boven hen gemerged.
Nogmaals, het hebben van langlopende branches is niet noodzakelijk, maar het helpt vaak wel; in het bijzonder als je te maken hebt met zeer grote of complexe projecten.

### Topic branches ###

Topic branches zijn nuttig in projecten van elke grootte. Een topic branch is een kortlopende branch die je maakt en gebruikt om een specifieke functie te realiseren of daaraan gerelateerd werk te doen. Dit is iets wat je waarschijnlijk nooit eerder met een VCS gedaan hebt, omdat het over het algemeen te duur is om branches aan te maken en te mergen. Maar in Git is het niet ongebruikelijk om meerdere keren per dag branches aan te maken, daarop te werken, en ze te verwijderen.

Je zag dit in de vorige paragraaf met de `iss53` en `hotfix` branches die je gemaakt had. Je hebt een aantal commits op ze gedaan en ze meteen verwijderd nadat je ze gemerged had in je hoofd-branch. Deze techniek stelt je in staat om snel en volledig van context te veranderen — omdat je werk is onderverdeeld in silo's waar alle wijzigingen in die branch te maken hebben met dat onderwerp, is het makkelijker te zien wat er is gebeurd tijdens een code review en dergelijke. Je kunt de wijzigingen daar minuten-, dagen- of maandenlang bewaren, en ze mergen als ze er klaar voor zijn, ongeacht de volgorde waarin ze gemaakt zijn of er aan gewerkt is.

Neem als voorbeeld een situatie waarbij wat werk gedaan wordt (op `master`), er wordt een branche gemaakt voor een probleem (`iss91`) en daar wordt wat aan gewerkt, er wordt een tweede branch gemaakt om op een andere manier te proberen hetzelfde op te lossen (`iss91v2`); weer even wordt teruggegaan naar de master branch om daar een tijdje te werken, en dan vanaf daar wordt gebrancht om wat werk te doen waarvan je niet zeker weet of het wel zo'n slim idee is (`dumbidea` branch). Je commit-historie zal eruitzien als Figuur 3-20.

Insert 18333fig0320.png
Figuur 3-20. Je commit-geschiedenis met meerdere topic branches.

Laten we zeggen dat je besluit dat je de tweede oplossing voor je probleem het beste vindt (`iss91v2`), en je hebt de `dumbidea` branch aan je collega's laten zien en het blijkt geniaal te zijn. Je kunt dan de oorspronkelijke `iss91` weggooien (waardoor je commits C5 en C6 kwijt raakt), en de andere twee mergen. Je historie ziet er dan uit als Figuur 3-21.

Insert 18333fig0321.png
Figuur 3-21. Je historie na het mergen van dumbidea en iss91v2.

Het is belangrijk om te beseffen dat tijdens al deze handelingen, al deze branches volledig lokaal zijn. Als je aan het branchen of mergen bent, dan wordt alles alleen in jouw Git repository gedaan - dus er vindt geen server communicatie plaats.

## Remote branches ##

Remote branches zijn referenties naar de staat van de branches op remote repositories. Ze zijn lokale branches die jij niet kunt verplaatsen; ze worden automatisch verplaatst zodra er netwerkcommunicatie plaatsvindt. Remote branches gedragen zich als boekenleggers om je eraan te helpen herinneren wat de staat van de branches was op je remote repositories toen je voor het laatst met ze in contact was.

Ze hebben de vorm `(remote)/(branch)`. Bijvoorbeeld, als je wil zien hoe de `master`-branch op je `origin` de laatste keer dat je er mee communiceerde eruitzag, dan zal je de `origin/master`-branch moeten bekijken. Als je samen met een partner aan het werk bent met een probleem en zij heeft een `iss53`-branch gepushed, zou je je een eigen lokale `iss53` kunnen hebben, maar de branch op de server zal wijzen naar de commit op `origin/iss53`.

Dit kan wat verwarrend zijn, dus laten we eens naar een voorbeeld kijken. Stel dat je een Git-server op je netwerk hebt op `git.ourcompany.com`. Als je hiervan clonet dan wordt die door Git automatisch `origin` voor je genoemd, Git haalt alle gegevens binnen, maakt een verwijzing naar waar de `master`-branch is en noemt dat lokaal `origin/master`, en deze kan je niet verplaatsen. Git geeft je ook een eigen `master`-branch, beginnend op dezelfde plaats als de `master`-branch van origin, zodat je iets hebt om vanaf te werken (zie Figuur 3-22).

Insert 18333fig0322.png
Figuur 3-22. Een Git clone geeft je een eigen `master`-branch en `origin/master` wijzend naar de `master`-branch van `origin`.

Als je wat werk doet op je lokale `master`-branch, en in de tussentijd pusht iemand anders iets naar `git.ourcompany.com` waardoor die `master`branch wordt vernieuwd, dan zijn jullie histories verschillend vooruit geschoven. En zolang je geen contact hebt met de origin server, zal jouw `origin/master` verwijzing niet verplaatsen (zie Figuur 3-23).

Insert 18333fig0323.png
Figuur 3-23. Lokaal werken terwijl iemand anders naar je remote server pusht laat elke historie anders vooruit gaan.

Om je werk te synchroniseren, voer je een `git fetch origin` commando uit. Dit commando bekijkt welke server origin is (in dit geval is het `git.ourcompany.com`), haalt gegevens er vanaf die je nog niet hebt en vernieuwt je lokale database, waarbij je `origin/master`-verwijzing naar zijn nieuwe positie verplaatst wordt die meer up-to-date is (zie Figuur 3-24).

Insert 18333fig0324.png
Figuur 3-24. Het `git fetch` commando vernieuwt je remote referenties.

Om het hebben van meerdere remote servers te tonen en hoe remote branches voor die remote projecten eruitzien, zullen we aannemen dat je nog een interne Git-server hebt die alleen wordt gebruikt voor ontwikkeling gedaan door een van je sprint teams. Deze server bevindt zich op `git.team1.ourcompany.com`. Je kunt het als een nieuwe remote referentie toevoegen aan het project waar je nu aan werkt door het `git remote add` commando uit te voeren, zoals we behandeld hebben in Hoofdstuk 2. Noem deze remote `teamone`, wat jouw afkorting voor die hele URL wordt (zie Figuur 3-25).

Insert 18333fig0325.png
Figuur 3-25. Een andere server als een remote toevoegen.

Nu kun je `git fetch teamone` uitvoeren om alles op te halen dat wat de `teamone` remote server heeft en jij nog niet. Omdat die server een subset heeft van de gegevens die jouw `origin` server op dit moment heeft, haalt Git geen gegevens op maar maakt een remote branch genaamd `teamone/master` aan en laat die wijzen naar de commit die `teamone` heeft als zijn `master`-branch (zie Figuur 3-26).

Insert 18333fig0326.png
Figuur 3-26. Je krijgt lokaal een referentie naar de `master`-branch-positie van teamone.

### Pushen ###

Als je een branch wil delen met de rest van de wereld, dan moet je het naar een remote terugzetten waar je schrijftoegang op hebt. Je lokale branches worden niet automatisch gesynchroniseerd met de remotes waar je naar schrijft - je moet de branches die je wilt delen uitdrukkelijk pushen. Op die manier kun je privé branches gebruiken voor het werk dat je niet wil delen, en alleen die topic branches pushen waar je op wilt samenwerken.

Als je een branch genaamd `serverfix` hebt waar je met anderen aan wilt werken, dan kun je die op dezelfde manier pushen als waarop je dat voor de eerste branch hebt gedaan. Voer `git push (remote) (branch)` uit:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Dit is een beetje de bocht afsnijden. Git zal de `serverfix` branchnaam automatisch expanderen naar `refs/heads/serverfix:refs/heads/serverfix`, wat staat voor "Neem mijn lokale serverfix branch en push die om de serverfix branch van de remote te vernieuwen.". We zullen het `refs/heads` gedeelte gedetaileerd behandelen in Hoofdstuk 9, maar je kunt het normaalgesproken weglaten. Je kun ook `git push origin serverfix:serverfix` doen, wat hetzelfde doet. Dit staat voor "Neem mijn serverfix en maak het de serverfix van de remote." Je kunt dit formaat gebruiken om een lokale branch te pushen naar een remote branch die anders heet. Als je niet wil dat het `serverfix` heet aan de remote kant, kan je in plaats daarvan `git push origin serverfix:awesomebranch` gebruiken om je lokale `serverfix` branch naar de `awesomebranch` op het remote project te pushen.

De volgende keer dat één van je medewerkers van de server fetchet zal deze een referentie krijgen naar de versie van `serverfix` op de server, onder de remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Het is belangrijk om op te merken dat wanneer je een fetch doet die nieuwe remote branches ophaalt, je niet automatisch lokale aanpasbare kopieën daarvan hebt. In andere woorden, in dit geval heb je geen nieuwe `serverfix` branch - je hebt alleen een `origin/serverfix` verwijzing die je niet kunt aanpassen.

Om dit werk in je huidige werk branch te mergen, kun je `git merge origin/serverfix` uitvoeren. Als je een eigen `serverfix` branch wilt waar je op kunt werken, dan kun je deze op je remote branch baseren:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

Dit maakt een lokale branch aan waar je op kunt werken, die begint met waar `origin/serverfix` is.

### Tracking branches ###

Een lokale branch uitchecken van een remote branch creëert automatisch een zogenaamde _tracking branch_ (_volg branch_). Tracking branches zijn lokale branches die een directe releatie met een remote branch hebben. Als je op een tracking branch zit en `git push` typt, dat weet Git automatisch naar welke server en branch hij moet pushen. En, als je op een van die branches zit zal het uitvoeren van `git pull` alle remote referenties ophalen en automatisch de corresponderende remote branch erin mergen.

Als je een repository clonet, zal het over het algemeen automatisch een `master`-branch aanmaken die `origin/master` trackt. Daarom werken `git push` en `git pull` zo uit het doosje, zonder verdere argumenten. Maar je kan ook andere tracking branches aanmaken als je dat wilt, andere die niet branches tracken op `origin` en niet de `master`-branch tracken. Een eenvoudig voorbeeld is wat je zojuist gezien hebt: `git checkout -b [branch] [remotenaam]/[branch]` uitvoeren. Als je Git versie 1.6.2 of nieuwer hebt, kun je ook de `--track` afkorting gebruiken:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

Om een lokale branch te maken met een andere naam dan de remote branch, kun je simpelweg de eerste variant met een andere lokale branchnaam gebruiken:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch serverfix from origin.
	Switched to a new branch 'sf'

Nu zal je lokale `sf`-branch automatisch pullen en pushen van origin/serverfix.

### Remote branches verwijderen ###

Stel dat je klaar bent met een remote branch - zeg maar, jij en je medewerkers zijn klaar met een feature en hebben het gemerged in de `master`-branch van de remote (of welke branch jullie stabiele code ook in zit). Dan kun je een remote branch verwijderen door de nogal botte syntax `git push [remotenaam] :[branch]` te gebruiken. Als je de `serverfix` branch van de server wilt verwijderen, dan voer je het volgende uit:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Poef. Geen branch meer op je server. Je zult deze pagina wel een ezelsoortje willen geven, omdat je dat commando nodig gaat hebben en het waarschijnlijk zult vergeten. Een manier om dit commando te onthouden is door de `git push [remotenaam] [lokalebranch]:[remotebranch]` syntax te onthouden die we kortgeleden behandeld hebben. Als je het `[lokalebranch]` gedeelte weglaat dan zeg je in feite, "Neem niets aan mijn kant en maak dat de `[remotebranch]`."

## Rebasen ##

In Git zijn er twee hoofdmanieren om wijzigingen te integreren van de ene branch in een andere: de `merge` en de `rebase`. In deze paragraaf ga je leren wat rebasen is, hoe je dat moet doen, waarom het een zeer bijzonder stukje gereedschap is en in welke gevallen je het niet wilt gebruiken.

### De simpele rebase ###

Als je het eerdere voorbeeld van de Merge-paragraaf erop terugslaat (zie Figuur 3-27), dan zul je zien dat je werk is uiteengelopen en dat je commits hebt gedaan op de twee verschillende branches.

Insert 18333fig0327.png
Figuur 3-27. Je initiële uiteengelopen historie.

De simpelste manier om de branches te integreren, zoals we al hebben besproken, is het `merge` commando. Het voert een drieweg-merge uit tussen de twee laatste snapshots van de branches (C3 en C4), en de meest recente gezamenlijke voorouder van die twee (C2), en maakt een nieuw snapshot (en commit) zoals getoond in Figuur 3-28.

Insert 18333fig0328.png
Figuur 3-28. Een branch mergen om de uiteengelopen werkhistories te integreren.

Maar, er is nog een manier: je kunt de patch van de wijziging die werd geïntroduceerd in C3 pakken en die opnieuw toepassen op C4. In Git, wordt dit _rebasen_ genoemd. Met het `rebase` commando kan je alle wijzigingen pakken die zijn gecommit op de ene branch, en ze opnieuw afspelen op een andere.

In dit voorbeeld zou je het volgende uitvoeren:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Het gebeurt door naar de gezamenlijke voorouder van de twee branches te gaan (degene waar je op zit en degene waar je op rebaset), de diff te nemen die geïntroduceerd is voor elke losse commit op de branch waar je op zit, die diffs in tijdelijke bestanden te bewaren, de huidige branch terug te zetten naar dezelfde commit als de branch waar je op rebaset, en uiteindelijk elke diff om de beurt te applyen, Figuur 3-29 toont dit proces.

Insert 18333fig0329.png
Figuur 3-29. De wijzigingen die geïntroduceerd zijn in C3 rebasen op C4.

Hierna kan je terug gaan naar de master branch en een fast-forward merge doen (zie Figuur 3-30).

Insert 18333fig0330.png
Figuur 3-30. De master branch Fast-forwarden.

Nu is het snapshot waar C3' naar wijst precies dezelfde als degene waar C5 naar wees in het merge voorbeeld. Er zit geen verschil in het eindresultaat van de integratie, maar rebasen zorgt voor een duidelijkere historie. Als je de log van een branch die gerebased is bekijkt, ziet het eruit als een lineaire historie: het lijkt alsof al het werk in serie heeft plaatsgevonden, zelfs wanneer het in werkelijkheid parallel eraan gedaan is.

Vaak zal je dit doen om er zeker van te zijn dat je commits netjes toegepast kunnen worden op een remote branch - misschien in een project waar je aan probeert bij te dragen, maar dat je niet beheert. In dit geval zou je het werk in een branch uitvoeren en dan je werk rebasen op `origin/master` als je klaar ben om je patches in te sturen naar het hoofdproject. Op die manier hoeft de beheerder geen integratiewerk te doen - gewoon een fast-forward of een schone apply.

Merk op dat de snapshot waar de laatste commit op het eind naar wijst, of het de laatste van de gerebasede commits voor een rebase is of de laatste merge commit na een merge, detzelfde snapshot is - alleen de historie is verschillend. Rebasen speelt veranderingen van een werklijn opnieuw af op een andere, in de volgorde waarin ze gemaakt zijn, terwijl mergen de eindresultaten pakt en die samenvoegt.

### Interessantere rebases ###

Je kunt je rebase ook opnieuw laten afspelen op iets anders dan de rebase branch. Pak een historie zoals in Figuur 3-31, bijvoorbeeld. Je hebt een topic branch afgesplitst (`server`) om wat server-kant functionaliteit toe te voegen aan je project en toen een keer gecommit. Daarna heb je daar vanaf gebranched om de client-kant wijzigingen te doen (`client`) en een paar keer gecommit. Als laatste, ben je teruggegaan naar je server branch en hebt nog een paar commits gedaan.

Insert 18333fig0331.png
Figuur 3-31. Een historie met een topic branch vanaf een andere topic branch.

Stel nu, je besluit dat je de client-kant wijzigingen wilt mergen in je hoofdlijn voor een release, maar je wilt de server-kant wijzigingen nog vasthouden totdat het verder getest is. Je kunt de wijzigingen van `client` pakken, die nog niet op `server` zitten (C8 en C9) en die opnieuw afspelen op je `master`-branch door de `--onto` optie te gebruiken van `git rebase`:

	$ git rebase --onto master server client

Dit zegt in feite, "Check de `client`-branch uit, verzamel de patches van de gezamenlijke voorouder van de `client` en de `server` branches, en speel die opnieuw af op `master`." Het is een beetje ingewikkeld, maar het resultaat, getoond in Figuur 3-32, is erg prettig.

Insert 18333fig0332.png
Figuur 3-32. Een topic branch rebasen vanaf een andere topic branch.

Nu kun je een fast-forward doen van je master branch (zie Figuur 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
Figuur 3-33. Je master branch fast-forwarden om de client branch wijzigingen mee te nemen.

Stel dat je besluit om de server branch ook te pullen. Je kunt de server branch rebasen op de master branch zonder het eerst te hoeven uitchecken door `git rebase [basisbranch] [topicbranch]` uit te voeren - wat de topic branch voor je uitcheckt (in dit geval, `server`) en het opnieuw afspeelt om de basis branch (`master`):

	$ git rebase master server

Dit speelt het `server` werk opnieuw af op het `master` werk, zoals getoond in Figuur 3-34.

Insert 18333fig0334.png
Figuur 3-34. Je server branch op je master branch rebasen.

Daarna kan je de basis branch (`master`) fast-forwarden:

	$ git checkout master
	$ git merge server

Je kunt de `client` en `server` branches verwijderen, omdat al het werk geïntegreerd is en je ze niet meer nodig hebt, en de historie voor het hele proces ziet eruit zoals in Figuur 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
Figuur 3-35. Uiteindelijke commit historie.

### De gevaren van rebasen ###

Ahh, maar de zegeningen van rebasen zijn niet geheel zonder nadelen, samengevat in één enkele regel:

**Rebase geen commits die je gepusht hebt naar een publiek repository.**

Als je die richtlijn volgt, kan je weinig gebeuren. Als je dat niet doet, zullen mensen je haten en je zult door vrienden en familie uitgehoond worden.

Als je spullen rebaset, zet je bestaande commits buitenspel en maak je nieuwe aan die vergelijkbaar zijn maar anders. Als je commits ergens pusht en andere pullen deze en baseren daar werk op, en vervolgens herschrijf je die commits met `git rebase` en pusht deze weer, dan zullen je medewerkers hun werk opnieuw moeten mergen en zal het allemaal erg vervelend worden als je hun werk probeert te pullen in het jouwe.

Laten we eens kijken naar een voorbeeld hoe werk rebasen dat je publiek gemaakt hebt problemen kan veroorzaken. Stel dat je van een centrale server clonet en dan daar wat werk aan doet. Je commit-historie ziet eruit als Figuur 3-36.

Insert 18333fig0336.png
Figuur 3-36. Clone een repository, en doe wat werk daarop.

Nu doet iemand anders wat meer werk wat een merge bevat, en pusht dat werk naar de centrale server. Je fetcht dat en merget de nieuwe remote branch in jouw werk, zodat je historie eruitziet zoals Figuur 3-37.

Insert 18333fig0337.png
Figuur 3-37. Haal meer commits op, en merge ze in je werk.

Daarna, beslist de persoon die het werk gepusht heeft om erop terug te komen en in plaats daarvan zijn werk te gaan rebasen; hij voeren een `git push --force` uit om de historie op de server te herschrijven. Je pullt daarna van die server, waarbij je de nieuwe commits binnen krijgt.

Insert 18333fig0338.png
Figuur 3-38. Iemand pusht gerebasede commits, daarbij commits buitenspel zettend waar jij werk op gebaseerd hebt.

Nu moet je dit werk opnieuw mergen, terwijl je dat al gedaan hebt. Rebasen verandert de SHA-1 hashes van deze commits, dus voor Git zien ze eruit als nieuwe commits, terwijl je in feite het C4 werk al in je historie hebt (zie Figuur 3-39).

Insert 18333fig0339.png
Figuur 3-39. Je merget hetzelfde werk opnieuw in een nieuwe merge commit.

Je moet dat werk op een gegeven moment mergen, zodat je in de toekomst bij kunt blijven met de andere ontwikkelaar. Nadat je dat gedaan hebt, zal je history zowel de C4 als de C4' commits bevatten, die verschillende SHA-1 hashes hebben, maar die hetzelfde werk introduceren en hetzelfde commit-bericht hebben. Wanneer je een `git log` uitvoert als je historie er zo uitziet, dan zul je twee commits zien die dezelfde auteur, datum en bericht hebben, wat alleen maar verwarring geeft. Daarnaast zal je, als je deze historie pusht naar de server, al die gerebasede commits opnieuw introduceren op de centrale server, wat mensen nog meer kan verwarren.

Als je rebasen behandelt als een manier om commits op te ruimen en ze te bewerken voordat je ze pusht, en als je alleen commits rebaset die nog nooit publiekelijk beschikbaar zijn geweest, dan zal er niets aan de hand zijn. Als je commits rebaset die al publiekelijk gepusht zijn, en mensen kunnen werk gebaseerd hebben op die commits, bereid je dan maar voor op een aantal frustrerende problemen.

## Samenvatting ##

We hebben de basis van branchen en mergen in Git behandeld. Je zou je op je gemak moeten voelen met het maken en omschakelen naar nieuwe branches, omschakelen tussen branches, en lokale branches te mergen. Je zou in staat moeten zijn om je branches te delen door ze naar een gedeelde server te pushen, met anderen op gedeelde branches samen te werken en je branches te rebasen voordat ze gedeeld zijn.
