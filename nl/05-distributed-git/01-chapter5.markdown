# Gedistribueerd Git #

Nu dat je een remote Git repository hebt ingesteld als een punt waar alle ontwikkelaars hun code kunnen delen, en je bekend bent met fundamentele Git commando's in een lokale werkwijze, zul je kijken hoe je een paar gedistribueerde werkwijzen kunt gebruiken die Git je toestaat.

In dit hoofdstuk zul je zien hoe je met Git kunt werken in een gedistribueerde omgeving als een bijdrager en als een integrator. Dat wil zeggen, je zult leren hoe je succesvol code kunt bijdragen aan een project en hoe je het zo makkelijk mogelijk maakt voor jou en de onderhouder van het project, en ook hoe je een project succesvol kunt onderhouden waarbij een aantal ontwikkelaars bijdragen.

## Gedistribueerde Werkwijzen ##

In tegenstelling tot gecentraliseerde versie beheersystemen (CVCS), staat de gedistribueerde aard van Git je toe om veel flexibeler te zijn in de manier waarop ontwikkelaars bijdragen in projecten. Bij gecentraliseerde systemen is iedere ontwikkelaar een knooppunt dat meer of minder gelijkwaardig werkt op een centraal punt. In Git is iedere ontwikkelaar zowel een knoop als een centraal punt – dat wil zeggen, iedere ontwikkelaar kan zowel code bijdragen aan andere repositories, als ook een publiek repository onderhouden waarop andere ontwikkelaars hun werk baseren en waaraan zij kunnen bijdragen. Dit stelt je project en of je team in staat om een enorm aantal werkwijzen er op na te houden, dus ik zal een aantal veel voorkomende manieren behandelen die gebruik maken van deze flexibiliteit. Ik zal de sterke en mogelijke zwakke punten van ieder ontwerp behandelen; je kunt er een kiezen om te gebruiken, of je kunt van iedere wijze een paar eigenschappen pakken en mengen.

### Gecentraliseerde Werkwijze ###

In gecentraliseerde systemen is er over het algemeen een enkel samenwerkingsmodel – de gecentraliseerde werkwijze. Eén centraal punt, of repository, kan code aanvaarden, en iedereen synchroniseerd hun werk daarmee. Een aantal ontwikkelaars zijn knopen – gebruikers van dat centrale punt – en synchroniseren met die plaats (zie Figuur 5-1). 

Insert 18333fig0501.png 
Figuur 5-1. Gecentraliseerde Werkwijze.

Dit betekend dat als twee ontwikkelaars clonen van het gecentraliseerde punt en beide wijzigingen doen, de eerste ontwikkelaar zijn wijzigingen terug kan zetten zonder problemen. De tweede ontwikkelaar zal het werk van de eerste in het zijne moeten samenvoegen voordat hij het zijne kan terugzetten, om zo niet het werk van de eerste te overschrijven. Dit concept werkt zo in Git zoals het ook werkt in Subversion (of ieder ander CVCS), en dit model werkt perfekt in Git.

Als je een klein team hebt, of al vertrouwd bent met een gecentraliseerde werkwijze in je bedrijf of team, dan kun je eenvoudig doorgaan met het gebruiken van die werkwijze met Git. Stel eenvoudigweg een enkel repository in, en geef iedereen in je team terugzet toegang; Git zal gebruikers niet toestaan om elkaar te overschrijven. Als een ontwikkelaar cloned, wijzigingen maakt, en dan probeert hun wijzigingen terug te zetten terwijl een andere ontwikkelaar de zijne in de tussentijd heeft teruggezet, dan zal de server de wijzigingen van die ontwikkelaar weigeren. Ze zullen worden gemeld dat ze non-fast-forward wijzigingen proberen terug te zetten en dat ze dat niet mogen totdat ze eerst fetchen en samenvoegen.
Deze werkwijze is voor een hoop mensen aantrekkelijk omdat het een wijze is waarmee veel mensen bekend zijn en zich op hun gemak bij voelen.

### Integratie-Manager Werkwijze ###

Omdat Git je toestaat om meerdere remote repositories te hebben, is het mogelijk om een werkwijze te hebben waarbij iedere ontwikkelaar schrijftoegang heeft tot hun eigen publieke repository en leestoegang op de andere. Dit scenario heeft vaak een gezagdragend repository dat het "officiele" project voorsteld. Om bij te kunnen dragen op dat project, maak je je eigen publieke clone van het project en zet je wijzigingen daarin terug. Daarna stuur je een verzoek naar de eigenaar van het hoofdproject om jouw wijzigingen binnen te halen. Ze kunnen je repository toevoegen als een remote, je wijzigingen lokaal testen, ze in hun branch samenvoegen, en naar hun repository terugzetten. Het proces werkt als volgt (zie Figuur 5-2):

1.	De project eigenaar zet terug naar zijn eigen repository.
2.	Een bijdrager cloned dat repository en maakt wijzigingen.
3.	De bijdrager zet terug naar zijn eigen publieke kopie.
4.	De bijdrager stuurt de eigenaar een e-mail met de vraag om de wijzigingen binnen te halen.
5.	De eigenaar voegt het repo van de bijdrager toe als een remote en voegt lokaal samen.
6.	De eigenaar zet samengevoegde wijzigingen terug in het hoofd repository.

Insert 18333fig0502.png 
Figuur 5-2. Integratie-manager werkwijze.

Dit is een veel voorkomende werkwijze bij websites zoals GitHub, waarbij het eenvoudig is om een project af te splitsen en je wijzigingen terug te zetten in jouw afgesplitste project zodat iedereen ze kan zien. Een van de grote voordelen van deze aanpak is dat je door kunt gaan met werken, en de eigenaar van het hoofd repository jouw wijzigingen op ieder moment binnen kan halen. Bijdragers hoeven niet te wachten tot het project hun bijdragen invoegt – iedere partij kan op hun eigen tempo werken.

### Dictator en Luitenanten Werkwijze ###

Dit is een variant op de multi-repository werkwijze. Het wordt over het algemeen gebruikt bij enorme projecten met honderden bijdragers; een bekend voorbeeld is de Linux kernel. Een aantal integrators geven de leiding over bepaalde delen van het repository; zij worden luitenanten genoemd. Alle luitenanten hebben één integrator die bekend staat als de welwillende dictator. Het repository van de welwillende dictator dient als het referentie repository vanwaar alle bijdragers dienen binnen te halen. Het proces werkt als volgt (zie Figuur 5-3):

1.	Reguliere ontwikkelaars werken op hun eigen onderwerp branch en rebasen hun werk op de hoofdbranch. De hoofdbranch is die van de dictator.
2.	Luitenanten voegen de onderwerp branches van de ontwikkelaars in hun hoofdbranch.
3.	De dictator voegt de hoofdbranches van de luitenanten in de dictator hoofdbranch.
4.	De dictator zet zijn hoofdbranch terug naar het referentie repository zodat de andere ontwikkelaars kunnen rebasen.

Insert 18333fig0503.png  
Figuur 5-3. Welwillende dictator werkwijze.

Deze manier van werken komt niet vaak voor, maar kan handig zijn in hele grote projecten of in zeer hierarchische omgevingen, omdat het de projectleider (de dictator) toestaat om het meeste werk te delegeren en grote subsets van code te verzamelen op meerdere punten alvorens ze te integreren.

Dit zijn veel voorkomende werkwijzen die mogelijk zijn met een gedistribueerd systeem als Git, maar je kunt zien dat er veel variaties mogelijk zijn die passen bij jouw specifieke werkwijze. Nu dat je (naar ik hoop) in staat bent om te bepalen welke werkwijze combinatie voor jou werkt, zal ik wat specifikere voorbeelden behandelen over hoe je de hoofd rollen kunt vervullen, die in de verschillende werkwijzen voorkomen.

## Bijdragen aan een Project ##

Je weet wat de verschillende werkwijzen zijn, en je zou een goed beeld moeten hebben van fundamenteel Git gebruik. In dit gedeelte zul je leren over een aantal voorkomende patronen voor het bijdragen aan een project.

De grote moeilijkheid bij het beschrijven van dit proces is dat er een enorm aantal variaties mogelijk zijn in hoe het gebeurd. Om dat Git erg flexibel is, kunnen en zullen mensen op vele manieren samenwerken, en het is lastig om te beschrijven hoe je zou moeten bijdragen aan een project – ieder project is een beetje anders. Een aantal van de betrokken variabelen zijn aktieve bijdrage grootte, gekozen werkwijze, je commit toegang, een mogelijk de externe bijdrage methode.

De eerste variabele is de aktieve bijdrage grootte. Hoeveel gebruikers dragen aktief code bij aan dit project, en hoe vaak? In veel gevallen zul je twee of drie ontwikkelaars met een paar commits per dag hebben, of misschien minder voor wat slaperige projecten. Voor zeer grote bedrijven of projecten kan het aantal ontwikkelaars in de duizenden zijn, met tientallen of zelfs honderden patches die iedere dag binnenkomen. Dit is belangrijk omdat met meer en meer ontwikkelaars, je meer en meer problemen tegenkomt met het zeker zijn dat code netjes toegepast kan worden of eenvoudig samengevoegd kan worden. Wijzigingen die je toevoegd kunnen verouderd of zwaar beschadigd raken door werk dat samengevoegd is terwijl je er aan het werken was of terwijl je wijzigingen in de wacht stonden voor goedkeuring of toepassing. Hoe kun je je code consequent bij de tijd en je patches geldig houden?

De volgende variabele is de gebruikte werkwijze in je project. Is het gecentraliseerd, waarbij iedere ontwikkelaar gelijkwaardige schrijftoegang heeft tot de hoofd codebasis? Heeft het project een eigenaar of integrator die alle patches nakijkt? Zijn alle patches gereviewed en goedgekeurd? Ben jij betrokken bij dat proces? Is er een luitenanten systeem in werking, en moet je je werk eerst bij hen inleveren?

Het volgende probleem is je commit toegang. De benodigde werkwijze om bij te dragen aan een project is heel verschillend als je wel schrijftoegang hebt tot het project dan als je dat niet hebt. Als je geen schrijftoegang hebt, wat heeft het project dan als voorkeur om bijdragen te ontvangen? Heeft het wel een beleid? Hoeveel werk draag je per keer bij? Hoe vaak draag je bij?

Al deze vragen kunnen van invloed zijn op hoe je effectief bijdraagt aan een project en welke werkwijzen de voorkeur hebben of die beschikbaar zijn voor je. Ik zal van ieder van deze aspecten wat behandelen in een aantal gevallen, waarbij ik van eenvoudig tot complex zal gaan; je zou in staat moeten zijn om de specifieke werkwijzen die je in de praktijk hebt te kunnen construeren vanuit deze voorbeelden.

### Commit Richtlijnen ###

Voordat je gaat kijken naar de specifieke gebruiksscenario's, volgt hier een kort stukje over commit berichten. Het hebben van een goede richtlijn voor het maken commits en je daar aan houden maakt het werken met Git en samenwerken met anderen een stuk makkelijker. Het Git project levert een document waarin een aantal tips staan voor het maken van commits van waar je patches uit kunt indienen – je kunt het lezen in de Git broncode in het `Documentation/SubmittingPatches` bestand.

Als eerste wil je geen witruimte fouten indienen. Git geeft je een eenvoudige manier om hierop te controleren – voordat je commit, voer `git diff --check` uit, wat mogelijke witruimte fouten identificeert en ze voor je afdrukt. Hier is een voorbeeld, waarbij ik een rode terminal kleur hebt vervangen door `X`en:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Als je dat commando uitvoert alvorens te committen, kun je al zien of je op het punt staat witruimte problemen te committen die andere ontwikkelaars boos kunnen maken.

Daarna, probeer om iedere van commit een logische set wijzigingen te maken. Probeer, als het je lukt, om je wijzigingen verteerbaar te maken – ga niet het hele weekend zitten coderen op vijf verschillende problemen om dat vervolgens op maandag als een gigantische commit in te dienen. Zels als je gedurende het weekend niet commit, gebruik dan het staging gebied op maandag om je werk in ten minste één commit per probleem op te splitsen, met een bruikbaar bericht per commit. Als een paar van de wijzigingen één bestand veranderen, probeer dan `git add --patch` te gebruiken om bestanden gedeeltelijk te stagen (wordt in detail behandeld in Hoofdstuk 6). Het snapshot van het project is gelijk of je nu één commit doet of vijf, zolang alle wijzigingen maar toegevoegd zijn op een bepaald punt, dus probeer om het je mede-ontwikkelaars makkelijk te maken als ze je wijzigingen moeten bekijken. Deze aanpak maakt het ook makkelijker om één wijziging op te halen of terug te draaien, mocht dat later nodig zijn. Hoofdstuk 6 beschrijft een aantal handige Git trucs om geschiedenis te herschrijven en bestanden interactief te stagen – gebruik deze applicaties om te helpen een schone en begrijpelijke historie op te bouwen.

Het laatste ding om in gedachten te houden is het commit bericht. Als je er een gewoonte van maakt om een goede kwaliteit commit berichten aan te maken, dan maakt dat het gebruik van en samenwerken in Git een stuk eenvoudiger. Als een algemen regel, zouden je berichten moeten beginnen met een enkele regel, die niet langer is dan 50 karakters en die de set wijzigingen beknopt omschrijft, gevolgd door een lege regel, gevolgd door een meer gedetaileerde uitleg. Het Git project vereist dat de meer gedetaileerde omschrijving ook je motivatie voor de verandering bevat, en de nieuwe implementatie tegen het oude gedrag afzet – dit is een goede richtlijn om te volgen. Het is ook een goed idee om de gebiedende wijs te gebruiken in deze berichten. Met andere woorden, gebruik commando's. In plaats van "Ik heb testen toegevoegd voor" of "Testen toegevoegd voor" gebruik je "Voeg testen toe voor".
Hier is een sjabloon dat origineel geschreven is door Tim Pope op tpope.net:

	Kort (50 karakters of minder) samenvatting van wijzigingen

	Gededailleerdere tekst uitleg, als nodig. Laat het in ongeveer 72
	karakters afbreken. In sommige contexten, wordt de eerste regel
	behandeld als het onderwerp van een email en de rest als inhoud.
	De lege regel die de samenvatting scheidt van de inhoud is van
	kritiek belang (tenzij je de inhoud helemaal weglaat); applicaties
	zoals rebase kunnen in de war raken als je ze samenvoegt.

	Vervolg paragrafen komen na lege regels.

	 - Aandachtspunten zijn ook goed.

	 - Typisch wordt een streepje of sterretje gebruikt als punt, voorafgegaan
	   door een enkele spatie, met ertussen lege regels, maar de conventies
	   variëeren hierin.

Als al je commit berichten er zo uit zien, dan zullen de dingen een stuk eenvoudiger zijn voor jou en de ontwikkelaars waar je mee werkt. Het Git project heeft goed geformateerde commit berichten – ik raad je aan om `git log --no-merges` uit te voeren om te zien hoe een goed geformatteerde project-commit historie eruit ziet.

In de volgende voorbeelden, en verder door de rest van dit boek, zal ik omwille van bondigheid de berichten niet zo netjes als dit formatteren; in plaats daarvan gebruik ik de `-m` optie voor `git commit`. Doe wat ik zeg, niet wat ik doe.

### Besloten Klein Team ###

De eenvoudigste opzet die je waarschijnlijk zult tegenkomen is een besloten project met één of twee ondere ontwikkelaars. Met besloten bedoel ik gesloten broncode – zonder leestoegang voor de buitenwereld. Jij en de andere ontwikkelaars hebben allemaal terugzet toegang op het repository.

In deze omgeving kun je een werkwijze aanhouden die vergelijkbaar is met wat je zou doen als je Subversion of een andere gecentraliseerd systeem zou gebruiken. Je hebt nog steeds de voordelen van zaken als offline committen en veel eenvoudiger branchen en samenvoegen, maar de werkwijze kan erg vergelijkbaar zijn; het grote verschil is dat het samenvoegen aan de client-kant gebeurt tijdens het committen in plaats van aan de server-kant.
Laten we eens kijken hoe het er uit zou kunnen zien als twee ontwikkelaars samen beginnen te werken met een gedeeld repository. De eerste ontwikkelaar, John, cloned het repository, maakt een wijziging, en commit lokaal. (Ik vervang de protocol berichten met `...` in deze voorbeelden om ze iets in te korten.)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb 
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

De tweede ontwikkelaar, Jessica, doet hetzelfde – cloned het repository en commit een wijziging:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO 
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

Nu zet Jessica haar werk terug op de server:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

John probeert ook zijn werk terug te zetten:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

John mag niet terugzetten omdat Jessica in de tussentijd teruggezet heeft. Dit is in het bijzonder belangrijk om te begrijpen als je gewent bent aan Subversion, omdat het je zal opvallen dat de twee ontwikkelaars niet hetzelfde bestand hebben aangepast. Alhoewel Subversion automatisch zo'n samenvoeging op de server doet, als verschillende bestanden zijn aangepast, in Git moet je de commits lokaal samenvoegen. John moet Jessica's wijzigingen ophalen en ze samenvoegen voor hij terug mag zetten:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

Op dit punt ziet John's lokale repository er ongeveer uit zoals Figuur 5-4.

Insert 18333fig0504.png 
Figuur 5-4. John’s initiele repository.

John heeft een referentie naar de wijzigingen die Jessica teruggezet heeft, maar hij moet ze samenvoegen met zijn eigen werk voordat hij het terug mag zetten:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Het samenvoegen gaat soepel – de commit historie van John ziet er nu uit als Figuur 5-5.

Insert 18333fig0505.png 
Figuur 5-5. John’s repository na het samenvoegen van origin/master.

Nu kan John zijn code testen om er zeker van te zijn dat het nog steeds goed werkt, en dan kan hij zijn nieuwe samengevoegde werk terugzetten op de server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Tenslotte ziet John's commit historie eruit als Figuur 5-6.

Insert 18333fig0506.png 
Figuur 5-6. John’s history na teruggezet te hebben op de origin van de server.

In de tussentijd heeft Jessica gewerkt op een onderwerp branch. Ze heeft een onderwerp branch genaamd `issue54` aangemaakt en daar drie commits op gedaan. Ze heeft John's wijzigingen nog niet opgehaald, dus haar commit historie ziet er uit als Figuur 5-7.

Insert 18333fig0507.png 
Figuur 5-7. Jessica’s initiele commit historie.

Jessica wil met John synchroniseren, dus ze haalt de wijzigingen op:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Dat haalt het werk op dat John in de tussentijd teruggezet heeft. Jessica's historie ziet er nu uit als Figuur 5-8.

Insert 18333fig0508.png 
Figuur 5-8. Jessica’s historie na het ophalen van John's wijzigingen.

Jessica denkt dat haar onderwerp branch nu klaar is, maar ze wil weten wat ze in haar werk moet samenvoegen zodat ze terug kan zetten. Ze voert `git log` uit om dat uit te zoeken:

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

Nu kan Jessica het werk van haar onderwerp samenvoegen in haar master branch, John's werk (`origin/master`) in haar `master` branch samenvoegen, en dat naar de server terugzetten. Eerst schakelt ze terug naar haar master branch om al dit werk te integreren:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Ze kan of `origin/master` of `issue54` als eerste samenvoegen – ze zijn beide stroomopwaarts dus de volgorde maakt niet uit. Het snapshot aan het einde zou gelijk moeten zijn ongeacht welke volgorde ze kiest; allen de geschiedenis zal iets verschillen. Ze kiest ervoor om `issue54` eerst samen te voegen:

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Er doen zich geen problemen voor; zoals je kunt zien was het een eenvoudige fast-forware. Nu voegt Jessica John's werk in (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Alles voegt netjes samen, en Jessica's historie ziet er uit als Figuur 5-9.

Insert 18333fig0509.png 
Figuur 5-9. Jessica’s historie na het samenvoegen van John’s wijzigingen.

Nu is `origin/master` bereikbaar vanuit Jessica's `master` branch, dus ze zou in staat moeten zijn om succesvol terug te kunnen zetten (er vanuit gegaan dat John in de tussentijd niets teruggezet heeft):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Iedere ontwikkelaar heeft een paar keer gecommit en elkaars werk succesvol samengevoegd; zie Figuur 5-10.

Insert 18333fig0510.png 
Figuur 5-10. Jessica’s historie na alle wijzigingen teruggezet te hebben op de server.

Dat is één van de eenvoudigste werkwijzen. Je werkt een tijdje, over het algemeen in een onderwerp branch, en voegt samen in je master branch als het klaar is om te worden geïntegreerd. Als je dat werk wilt delen, dan voeg je het samen in je eigen master branch, en vervolgens haal je `origin/master` op en voegt het samen als het gewijzigd is, en als laatste zet je terug op de `master` branch op de server. De algemene volgorde is zoiets als die getoond in Figuur 5-11.

Insert 18333fig0511.png 
Figuur 5-11. Algemene volgorde van gebeurtenissen voor een eenvoudige multi-ontwikkelaar Git werkwijze.

### Besloten Aangestuurd Team ###

In het volgende scenario zul je kijken naar de rol van de bijdragers in een grotere besloten groep. Je zult leren hoe te werken in een omgeving waar kleine groepen samenwerken aan functies, waarna die team-gebaseerde bijdragen worden geïntegreerd door een andere partij.

Stel dat John en Jessica samen werken aan een functie, terwijl Jessica en Josie aan een tweede aan het werken zijn. In dit geval gebruikt het bedrijf een integratie-manager achtige werkwijze, waarbij het werk van de individuele groepen alleen wordt geïntegreerd door bepaalde ingenieurs, en de `master` branch van het hoofd repo alleen kan worden vernieuwd door die ingenieurs. In dit scenario, wordt al het werk gedaan in team-gebaseerde branches en later door de integrators samengevoegd.

Laten we Jessica's werkwijze volgen terwijl ze aan haar twee functies werkt, in parallel met twee verschillend ontwikkelaars in deze omgeving. Aangenomen dat ze haar repository al gecloned heeft, besluit ze als eerste te werken aan `featureA`. Ze maakt een nieuwe branch aan voor de functie en doet daar wat werk:

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

Op dit punt, moet ze haar werk delen met John, dus ze zet haar commits op de `featureA` branch terug naar de server. Jessica heeft geen terugzet toegang op de `master` branch – alleen de integratoren hebben dat – dus ze moet naar een andere branch terugzetten om samen te kunnen werken met John:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica e-mailed John om hem te zeggen dat ze wat werk teruggezet heeft in een branch genaamd `featureA` en dat hij er nu naar kan kijken. Terwijl ze op terugkoppeling van John wacht, besluit Jessica te beginnen met het werken aan `featureB` met Josie. Om te beginnen start ze een nieuwe functie branch, gebaseerd op de `master` branch van de server:

	# Jessica's Machine
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Nu doet Jessica een paar commits op de `featureB` branch:

	$ vim lib/simplegit.rb
	$ git commit -am 'made the ls-tree function recursive'
	[featureB e5b0fdc] made the ls-tree function recursive
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'add ls-files'
	[featureB 8512791] add ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

Jessica's repository ziet eruit als Figuur 5-12.

Insert 18333fig0512.png 
Figuur 5-12. Jessica’s initiele commit historie.

Ze is klaar om haar werk terug te zetten, maar ze krijgt een e-mail van Josie dat een branch met wat initieel werk erin al teruggezet is naar de server als `featureBee`. Jessica moet die wijzigingen eerst samenvoegen met haar eigen voordat ze terug kan zetten naar de server. Ze kan dan Josie's wijzigingen ophalen met `git fetch`:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Jessica kan dit nu samenvoegen in haar werk met `git merge`:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

Er is wel een klein probleem – ze moet het samengevoegde werk in haar `featureB` branch naar de `featureBee` branch op de server zetten. Ze kan dat doen door de lokale branch te specificeren aan het `git push` commando, gevolgd door een dubbele punt (:), gevolgd door de remote branch:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Dit wordt een _refspec_ genoemd. Zie Hoofdstuk 9 voor een gedaileerdere discussie van Git refspecs en de verschillende dingen die je met ze kan doen.

Vervolgens e-mailed John naar Jessica om te zeggen dat hij wat wijzigingen naar de `featureA` branch teruggezet heeft, en om haar te vragen die te verifieren. Ze voert een `git fetch` uit om die wijzigingen op te halen:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

Daarna kan ze zien wat er veranderd is met `git log`:

	$ git log origin/featureA ^featureA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    changed log output to 30 from 25

Uiteindelijk voegt ze John's werk in haar eigen `featureA` branch:

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica wil iets fijnstellen, dus doet ze nog een commit en zet dit terug naar de server:

	$ git commit -am 'small tweak'
	[featureA ed774b3] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

Jessica's commit historie ziet er nu uit zoals Figuur 5-13.

Insert 18333fig0513.png 
Figuur 5-13. Jessica’s historie na het committen op een functie branch.

Jessica, Josie en John informeren de integrators nu dat de `featureA` en featureBee` branches op de server klaar zijn voor integratie in de hoofdlijn. Nadat ze die branches in de hoofdlijn geïntegreerd hebben, zal een fetch de nieuwe samenvoeg commits ophalen, waardoor de commit historie er uit ziet zoals Figuur 5-14.


Insert 18333fig0514.png 
Figuur 5-14. Jessica’s historie na het samenvoegen van allebei haar onderwerp branches.

Veel groepen schakelen om naar Git voor deze mogelijkheid om meerdere teams in paralleel te kunnen laten werken, waarbij de verschillende lijnen van werk laat in het proces samengevoegd worden. De mogelijkheid van kleinere subgroepen of een team om samen te werken via remote branches zonder het betrekken of dwarsliggen van het hele team is een enorm voordeel van Git. De volgorde van de werkwijze die je hier zag is ongeveer zoals Figuur 5-15.

Insert 18333fig0515.png 
Figuur 5-15. Basale volgorde van de werkwijze van dit aangestuurde team.

### Klein Publiek Project ###

Het bijdragen aan publieke projecten gaat wat anders. Omdat je niet de toestemming hebt om de branches van het project te vernieuwen, moet je het werk op een andere manier naar de beheerders krijgen. Dit eerste voorbeeld beschrijft het bijdragen via afsplitsen op Git hosts die eenvoudig afsplitsen ondersteunen. De repo.or.cz en GitHub hosting sites ondersteunen dit allebei, en veel project beheerders verwachten deze soort bijdrage. Het volgende deel behandelt projecten die de voorkeur hebben aan bijgedragen patches via e-mail.

Eerst wil je waarschijnlijk het hoofdrepository clonen, een onderwerp branch maken voor de patch of patch serie die je van plan bent bij te dragen, en je werk daarop doen. De volgorde ziet er in basis zo uit:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Je wil misschien de `rebase -i` optie gebruiken om je werk in één enkele commit samen te persen, of het werk in de commits herschikken om de patch eenvoudiger te kunnen laten reviewen door de beheerders – zie Hoofdstuk 6 voor meer informatie over het interactief rebasen.

Als je werk op de branch af is, en je klaar bent om het bij te dragen aan de beheerders, ga dan naar de originele project pagina en klik op de "Fork" knop, waarmee je een eigen schrijfbare fork van het project maakt. Je moet dit dan in een nieuwe repository URL toevoegen als een tweede remote, in dit geval `myfork` genaamd:

	$ git remote add myfork (url)

Je moet je werk hier naar terugzetten. Het is het makkelijkts om de remote branch waar je op zit te werken terug te zetten naar je repository, in plaats van het samenvoegen in je master branch en die terug te zetten. De reden is dat als het werk niet wordt geaccepteerd of ge-cherry picked, je je master branch niet hoeft terug te draaien. Als de beheerders je werk samenvoegen, rebasen of cherry picken, dan krijg je het uiteindelijk toch terug door hun repository binnen te halen:

	$ git push myfork featureA

Als jouw werk teruggezet is naar je fork, dan moet je de beheerder waarschuwen. Dit wordt vaak een pull request (haal binnen verzoek) genoemd, en je kunt het of via de website genereren – GitHub heeft een "pull request" knop die de beheerder automatisch een bericht stuurt – of het `git request-pull` commando uitvoeren en de uitvoer handmatig naar de beheerder e-mailen.

Het `request-pull` commando accepteerd de basis branch waarin je je onderwerp branch binnen gehaald wil hebben, en de URL van het Git repository waarvan je ze will laten halen, en voert een samenvatting uit van alle wijzigingen die je binnengehaald wenst te hebben. Bijvoorbeeld, als Jessica John een pull request wil sturen, en ze heeft twee commits gedaan op de onderwerp branch die ze zojuist teruggezet heeft, dan kan ze dit uitvoeren:

	$ git request-pull origin/master myfork
	The following changes since commit 1edee6b1d61823a2de3b09c160d7080b8d1b3a40:
	  John Smith (1):
	        added a new function

	are available in the git repository at:

	  git://githost/simplegit.git featureA

	Jessica Smith (2):
	      add limit to log function
	      change log output to 30 from 25

	 lib/simplegit.rb |   10 +++++++++-
	 1 files changed, 9 insertions(+), 1 deletions(-)

De uitvoer kan naar de beheerder gestuurd worden – het verteld ze waar het werk vanaf gebranched is, vat de commits samen, en verteld waar ze dit werk vandaan kunnen halen.

Bij een project waarvan je niet de beheerder bent, is het over het algemeen eenvoudiger om een branch zoals `master` altijd de `origin/master` te laten volgen, en je werk te doen in onderwerp branches die je eenvoudig weg kunt gooien als ze geweigerd worden. Als je je werk thema's gescheiden hebt in onderwerp branches maakt dat het ook eenvoudiger voor jou om je werk te rebasen als de punt van het hoof repository in de tussentijd verschoven is en je commits niet langer netjes toegepast kunnen worden. Bijvoorbeeld, als je een tweede onderwerp wil bijdragen aan een project, ga dan niet verder werken op de onderwerp branch die je zojuist teruggezet hebt – begin opnieuw vanaf de `master` branch van het hoofd repository:

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

Nu zijn al je onderwerpen opgeslagen in een silo – vergelijkbaar met een patch rij – die je kunt herschrijven, rebasen en wijzigen zonder dat de onderwerpen elkaar in de weg zitten of afhankelijk zijn zoals in Figuur 5-16.

Insert 18333fig0516.png 
Figuur 5-16. Initiele commit historie met werk van featureB.

Stel dat de project beheerder een berg andere patches binnengehaald heeft en je eerste branch geprobeerd heeft, maar dat die niet langer netjes samenvoegt. In dit geval kun je proberen die branch te rebasen op de punt van `origin/master`, de conflicten proberen op te lossen voor de beheerder, en dan je wijzigingen opnieuw aanbieden:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push –f myfork featureA

Dit herschrijft je geschiedenis zodat die eruit ziet als in Figuur 5-17.

Insert 18333fig0517.png 
Figuur 5-17. Commit historie na werk van featureA.

Omdat je de branch gerebased hebt, moet je de `-f` specificeren met je push commando om in staat te zijn de `featureA` branch op de server te vervangen met een commit die er geen afstammeling van is. Een alternatief zou zijn dit nieuwe werk naar een andere branch op de server terug te zetten (misschien `featureAv2` genaamd).

Laten we eens kijken naar nog een mogelijk scenario: de beheerder heeft je werk bekeken in je tweede branch en vind het concept goed, maar zou willen dat je een implementatie detail veranderd. Je zult deze kans ook gebruiken om het werk dat gebaseerd is van de huidige `master` branch van het project af te halen. Je begint een nieuwe branch gebaseerd op de huidige `origin/master` branch, perst de `featureB` wijzigingen hier samen, lost conflicten op, doet de implementatie wijziging, en zet dat terug als een nieuwe branch:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

De `--squash` optie pakt al het werk op de samengevoegde branch en perst dat samen in één non-merge commit bovenop de branch waar je op zit. De `--no-commit` optie verteld Git dat hij niet automatisch een commit moet vastleggen. Dit staat je toe om alle wijzigingen van een andere branch te introduceren en dan meer wijzigingen te doen, alvorens de commit vast te leggen.

Nu kun je de beheerder een bericht sturen dat je de gevraagde wijzigingen gemaakt hebt en dat ze die wijzigingen kunnen vinden in je `featureBv2` branch (zie Figuur 5-18).

Insert 18333fig0518.png 
Figuur 5-18. Commit historie na het featureBv2 werk.

### Publiek Groot Project ###

Veel grote projecten hebben procedures voor het accepteren van patches vastgelegd – je zult de specifieke regels voor ieder project moeten bekijken, omdat ze zullen verschillen. Maar, veel grote projecten accepteren patches via ontwikkelaar maillijsten, dus ik zal zo'n voorbeeld nu laten zien.

De werkwijze is vergelijkbaar met het vorige geval – je maakt onderwerp branches voor iedere patch waar je aan werkt. Het verschil is hoe je die indient bij het project. In plaats van het project te forken en naar je eigen schrijfbare versie terug te zetten, genereer je e-mail versies van iedere commit serie en e-mailed die naar de ontwikkelaar maillijst:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Nu heb je twee commits die je wil sturen naar de maillijst. Je gebruikt `git format-patch` om de mbox-geformatteerde bestanden te genereren, die je kunt e-mailen naar de lijst – het vormt ieder commit om naar een e-mail bericht met de eerste regel van het commit bericht als de onderwerp regel, en de rest van het bericht plus de patch die de commit introduceert als de inhoud. Het fijne hieraan is dat het toepassen van een patch uit een e-mail die gegenereerd is met `format-patch` alle commit informatie goed behoudt, zoals je in het volgende gedeelte meer zult zien als je deze commits toepast:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

Het `format-patch` commando voert de namen uit van de patch bestanden die het maakt. De `-M` optie verteld Git te kijken naar hernoemingen. De bestanden komen er uiteindelijk zo uit te zien:

	$ cat 0001-add-limit-to-log-function.patch 
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

	---
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index 76f47bc..f9815f1 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -14,7 +14,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log #{treeish}")
	+    command("git log -n 20 #{treeish}")
	   end

	   def ls_tree(treeish = 'master')
	-- 
	1.6.2.rc1.20.g8c5b.dirty

Je kunt deze patch bestanden ook aanpassen om meer informatie voor de maillijst toe te voegen, die je niet in het commit bericht wil laten zien. Als je tekst toevoegt tussen de `--` regel en het begin van de patch (de `lib/simplegit.rb` regel), dan kunnen ontwikkelaars dit lezen; maar tijdens het toepassen van de patch wordt dit weggelaten.

Om dit te e-mailen naar een maillijst, kun je het bestand in je e-mail applicatie plakken of het sturen via een commandoregel programma. Het plakken van de tekst veroorzaakt vaak formaat problemen, in het bijzonder bij "slimmere" clients die geen harde returns en andere witruimte juist behouden. Gelukkig levert Git een applicatie die je helpt om juist geformatteerde patches via IMAP te versturen, wat makkelijker voor je kan zijn. Ik zal demonstreren hoe je een patch via Gmail stuurt, wat de e-mail applicatie is die ik gebruik; je kunt gedetaileerde instrukties voor een aantal mail programma's vinden aan het eind van het voornoemde `Documentation/SubmittingPatches` bestand in de Git broncode.

Eerst moet je de imap sectie in je `~/.gitconfig` bestand instellen. Je kunt iedere waarde apart instellen met een serie `git config` commando's, of je kunt ze handmatig toevoegen; maar aan het einde moet je config bestand er ongeveer zo uitzien:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Als je IMAP server geen SSL gebruikt, zijn de laatste twee regels waarschijnlijk niet nodig, en de waarde voor host zal `imap://` zijn in plaats van `imaps://`.
Als dat ingesteld is, kun je `git send-email` gebruiken om de patch serie in de Drafts map van de gespecificeerde IMAP server te zetten:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>] 
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Dan spuugt Git een berg log informatie uit, die er zoiets als dit uitziet, voor iedere patch die je stuurt:

	(mbox) Adding cc: Jessica Smith <jessica@example.com> from 
	  \line 'From: Jessica Smith <jessica@example.com>'
	OK. Log says:
	Sendmail: /usr/sbin/sendmail -i jessica@example.com
	From: Jessica Smith <jessica@example.com>
	To: jessica@example.com
	Subject: [PATCH 1/2] added limit to log function
	Date: Sat, 30 May 2009 13:29:15 -0700
	Message-Id: <1243715356-61726-1-git-send-email-jessica@example.com>
	X-Mailer: git-send-email 1.6.2.rc1.20.g8c5b.dirty
	In-Reply-To: <y>
	References: <y>

	Result: OK

Op dit punt zou je in staat moeten zijn om naar je Drafts map te gaan, het To veld te wijzigen in de maillijst waarnaar je de patch stuurt, misschien de beheerder of verantwoordelijke persoon voor dat gebied op de CC te zetten, en het weg te sturen.

### Samenvatting ###

Dit gedeelte heeft een aantal vaak voorkomende werkwijzen behandeld, om om te gaan met een aantal zeer verschillende typen Git projecten die je waarschijnlijk zult tegen komen en een aantal nieuwe programma's geïntroduceerd, die je helpen om dit proces te beheren. Vervolgens zul je zien hoe je aan de andere kant van de medaille werkt: een Git project beheren. Je zult leren hoe een welwillende dictator of integratie manager te zijn.

## Maintaining a Project ##

In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run.

### Werken in Onderwerp Branches ###

Als je denkt om nieuw werk te integreren, is het normaliter een goed idee om het uit te proberen in een onderwerp branch – een tijdelijke branch, speciaal gemaakt om dat nieuwe werk te proberen. Op deze manier is het handig om een patch individueel af te stemmen en het weg te laten als het niet werkt, totdat je tijd hebt om er op terug te komen. Als je een eenvoudige branchnaam maakt, gebaseerd op het thema van het werk dat je gaat proberen, bijvoorbeeld `ruby_client` of zoiets beschrijvends, dan kun je het makkelijk onthouden als je het voor een tijdje moet achterlaten en later terug moet komen. De beheerder van het Git project heeft de neiging om deze branches ook van een naamruimte te voorzien – zoals `sc/ruby_client`, waarbij `sc` een afkorting is van de persoon die het werk heeft bijgedragen.
Zoals je je zult herinneren, kun je de branch gebaseerd op je master branch zo maken:

	$ git branch sc/ruby_client master

Of, als je er ook meteen naar wilt omschakelen, kun je de `checkout -b` optie gebruiken:

	$ git checkout -b sc/ruby_client master

Nu ben je klaar om je bijgedragen werk in deze onderwerp branch toe te voegen, en te bepalen of je het wilt samenvoegen in je lange termijn branches.

### Patches uit E-mail Toepassen ###

Als je een patch per e-mail ontvangt, die je moet integreren in je project, moet je de patch in je onderwerp branch toepassen om het te evalueren. Er zijn twee manieren om een ge-emailde patch toe te passen: met `git apply` of met `git am`.

#### Een Patch Toepassen met apply ####

Als je de patch ontvangen hebt van iemand die het gegenereerd heeft met de `git diff` of een Unix `diff` commando, kun je het toepassen met het `git apply` commando. Aangenomen dat je de patch als `/tmp/patch-ruby-client.patch` opgeslagen hebt, kun je de patch als volgt toepassen:

	$ git apply /tmp/patch-ruby-client.patch

Dit wijzigt de bestanden in je werkmap. Het is vrijwel gelijk aan het uitvoeren van een `patch -p1` commando om de patch toe te passen, alhoewel het meer paranoïde is en minder wazige paren dan patch. Het handelt ook bestandstoevoegingen af, verwijderingen, en hernoemingen als ze beschreven staan in het `git diff` formaat, wat `patch` niet doet. Als laatste is `git apply` een "pas alles toe of laat alles weg" model, waarbij alles of niets wordt toegepast, waarbij `patch` gedeeltelijke patches kan toepassen, zodat je werkmap in een vreemde status achterblijft. `git apply` is over het algemeen meer paranoïde dan `patch`. Het zal geen commit voor je aanmaken – na het uitgevoerd te hebben, moet je de geïntroduceerde wijzigingen handmatig stagen en committen.

Je kunt ook git apply gebruiken om te zien of een patch netjes toepast, voordat je het echt toepast – je kunt `git apply --check` uitvoeren met de patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch 
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

Als er geen uitvoer is, dan zou de patch netjes toe moeten passen. Dit commando eindigt ook met een status niet gelijk aan nul als de controle faalt, zodat je het kunt gebruiken in scripts als je dat wilt.

#### Een Patch met am Toepassen ####

Als de bijdrager een Git gebruiker is en zo goed was om het `format-patch` commando te gebruiken om hun patch te genereren, dan is je werk eenvoudiger omdade de patch auteur informatie en een commit bericht voor je bevat. Als je kunt, moedig je bijdragers aan om `format-patch` te gebruiken in plaats van `diff` om patches te genereren voor je. Je zou alleen `git apply` hoeven te gebruiken voor oude patches en dat soort dingen.

Om een patch gegenereerd met `format-patch` toe te passen, gebruik je `git am`. Technisch is `git am` gemaakt om een mbox bestand te lezen, dat een eenvoudig gewone tekst formaat of is om één of meer e-mail berichten in een tekst bestand op te slaan. Het ziet er zoiets als dit uit:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

Dit is het begin van de uitvoer van het format-patch commando dat je gezien hebt in het vorige gedeelte. Dit is ook een geldig mbox e-mail formaat. Als iemand jou de patch goed gemailed heeft door gebruik te maken van git send-email, en je download dat in een mbox formaat, dan kun je git am naar dat mbox bestand wijzen, en het zal beginnen met alle patches die het ziet toe te passen. Als je een mail client uitvoert die meerdere e-mails kan opslaan in mbox formaat, dan kun je hele patch series in een bestand opslaan en dan git am gebruiken om ze stuk voor stuk toe te passen.

Maar, als iemand een patch bestand heeft ge-upload die gegenereerd is met `format-patch` naar een ticket systeem of zoiets, kun je het bestand lokaal opslaan en dan dat bestand dat bewaard is op je schijf aan `git am` geven om het toe te passen:

	$ git am 0001-limit-log-function.patch 
	Applying: add limit to log function

Je kunt zien dat het netjes is toegepast, en automatisch een nieuwe commit voor je heeft aangemaakt. De auteur informatie wordt gehaald uit het `From` en `Date` veld in de kop, en het bericht van de commit wordt gehaald uit de `Subject` en inhoud (voor de patch` van de e-mail. Bijvoorbeeld, als deze patch was toegepast van het mbox voorbeeld dat ik zojuist getoond heb, dan zou de gegenereerde commit er ongeveer zo uit zien:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

De `Commit` informatie laat de persoon die de patch toepaste en de tijd waarop het was toegepast zien. De `Author` informatie is het individueel die de patch origineel gemaakt heeft en wanneer het origineel gemaakt is.

Maar, het is mogelijk dat de patch niet netjes toepast. Misschien is je hoofdbranch te ver afgeweken van de branch waarop de patch gebouwd is, of hangt de patch van een andere patch af, die je nog niet hebt toegepast. In dat geval zal het `git am` proces falen en je vragen wat je wilt doen:

	$ git am 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

Dit commando stopt conflict markeringen in alle bestanden waar het problemen mee heeft, net zoals een conflicterende samenvoeging of rebase operatie. Je lost dit probleem in een vergelijkbare manier op – wijzig het bestand om het conflict op te lossen, stage het bestand, en voer dan `git am --resolved` uit om door te gaan met de volgende patch:

	$ (fix the file)
	$ git add ticgit.gemspec 
	$ git am --resolved
	Applying: seeing if this helps the gem

Als je wil dat Git een beetje meer intelligent probeert om het conflict op te lossen, kun je een `-3` optie eraan meegeven, wat zorgt dat Git een drieweg samenvoeging probeert. Deze optie staat standaard niet aan, omdat het niet werkt als de commit waarvan de patch zegt dat het op gebaseerd is niet in je repository zit. Als je die commit wel hebt – als de patch gebaseerd was op een publieke commit – dan is de `-3` over het algemeen veel slimmer in het toepassen van een conflicterende patch:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In dit geval, probeerde ik een patch toe te passen die ik reeds toegepast had. Zonder de `-3` optie ziet het eruit als een conflict.

Als je een aantal patches van een mbox toepast, kun je ook het `am` commando in een interactieve modus uitvoeren, wat bij iedere patch die het vind stopt en je vraagt of je het wilt toepassen:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all 

Dit is fijn als je een aantal patches bewaard hebt, omdat je de patch eerst kunt zien als je je niet kunt herinneren wat het is, of de patch niet wilt toepassen als je het al gedaan hebt.

Als alle patches voor je onderwerp branch zijn toegepast en gecommit zijn op je branch, kun je kiezen of en hoe ze te integreren in een langer lopende branch.

### Remote Branches Bekijken ###

Als je bijdrage van een Git gebruiker komt, die hun eigen repository ingesteeld heeft, een aantal patches daarin teruggezet heeft, en jou de URL naar de repository gestuurd heeft en de naam van de remote branch waarin de wijzigingen zitten, dan kun je ze toevoegen als een remote en de samenvoegingen lokaal doen.

Bijvoorbeeld, als Jessica je een e-mail stuurt waarin staat dat ze een mooie nieuw eigenschap in de `ruby-client` branch van haar repository heeft, kun je het testen door de remote toe te voegen en die branch lokaal te bekijken:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

Als ze je later opnieuw e-mailed met een andere branch die een andere mooie eigenschap bevat, dan kun je die ophalen en bekijken omdat je de remote al ingesteld hebt.

Dit is erg handig als je consitent met een persoon werkt. Als iemand een enkele patch eens in de zoveel tijd bij te dragen heeft, dan is het accepteren per e-mail miscchien minder tijdrovend dan eisen dat iedereen hun eigen server moet draaien en doorlopend remotes toevoegen en verwijderen om een paar patches te krijgen. Je zult waarschijnlijk ook honderden remotes hebben, elk voor iemand die maar een patch of twee bijdraagt. Maar, scripts en gehoste diensten maken dit misschien makkelijker – het hangt veel af van hoe jij ontwikkeld en hoe je bijdragers ontwikkelen.

Het andere voordeel van deze aanpak is dat je de historie van de commits ook krijgt. Alhoewel je misschien geldige samenvoeg problemen hebt, weet je waar in je historie hun werk is gebaseerd; een goede drieweg samenvoeging is de standaard in plaats van een `-3` te moeten meegeven en hopen dat de patch gegenereerd was van een publieke commit waar je toegang toe hebt.

Als je niet consitent met een persoon werkt, maar toch op deze manier van hen wilt ophalen, dan kun je de URL van het remote repository geven aan het `git pull` commando. Dit haalt eenmalig  op en bewaart de URL niet als een remote referentie:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Bepalen wat Geïntroduceerd wordt ###

Nu heb je een onderwerp branch dat bijgedragen werk bevat. Op dit punt kun je bepalen wat je er mee wilt doen. Deze sectie bezoekt een paar commando's opnieuw zodat je kunt zien hoe je ze kunt gebruiken om precies te reviewen wat je zult indroduceren als je dit samenvoegt in je hoofd branch.

Het is vaak behulpzaam om een review te krijgen van alle commits die in deze branch zitten, maar die niet in je master branch zitten. Je kunt commits weglaten in de master branch door de `--not` optie mee te geven voor de branch naam. Bijvoorbeeld, als je bijdrager je twee patches stuurt en je wil een branch genaamd `contrib` maken en die patches daar toepassen, dan kun je dit uitvoeren:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

Om te zien welke wijzigingen iedere commit introduceert, onthoud dan dat je de `-p` optie kunt meegeven aan `git log` en dan zal het de diff geïntroduceerd bij iedere commit weergeven.

Om een volledige diff te zien van wat zou gebeuren als je deze onderwerp branch samenvoegt met een andere branch, zul je misschien een vreemde truc moeten toepassen om de juiste resultaten te krijgen. Je zult misschien denken om dit uit te voeren:

	$ git diff master

Dit commando geeft je een diff, maar het zou misleidend kunnen zijn. Als je `master` branch vooruit geschoven is sinds je de onderwerp branch er vanaf hebt gebaseerd, dan zul je ogenschijnlijk vreemde resultaten krijgen. Bijvoorbeeld, als je een regel in een bestand hebt toegevoegd op de `master` branch, dan zal een directe vergelijking van de snapshots eruit zien alsof de onderwerp branch die regel gaat verwijderen.

Als `master` een directe afstammeling is van je onderwerp branch, is dit geen probleem; maar als de twee histories uit elkaar zijn gegaan, zal de diff eruit zien alsof je alle nieuwe spullen in je onderwerp branch toevoegt en al het unieke weghaalt in de `master` branch.

What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.

Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db 

However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch:

	$ git diff master...contrib

This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember.

### Integrating Contributed Work ###

When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them.

#### Merging Workflows ####

One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20.

Insert 18333fig0519.png 
Figure 5-19. History with several topic branches.

Insert 18333fig0520.png
Figure 5-20. After a topic branch merge.

That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects.

If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23).

Insert 18333fig0521.png 
Figure 5-21. Before a topic branch merge.

Insert 18333fig0522.png 
Figure 5-22. After a topic branch merge.

Insert 18333fig0523.png 
Figure 5-23. After a topic branch release.

This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.
You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch.

#### Large-Merging Workflows ####

The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together.

Insert 18333fig0524.png 
Figure 5-24. Managing a complex series of parallel contributed topic branches.

If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25).

Insert 18333fig0525.png 
Figure 5-25. Merging contributed topic branches into long-term integration branches.

When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions.

#### Rebasing and Cherry Picking Workflows ####

Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history.

The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26.

Insert 18333fig0526.png 
Figure 5-26. Example history before a cherry pick.

If you want to pull commit `e43a6` into your master branch, you can run

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27.

Insert 18333fig0527.png 
Figure 5-27. History after cherry-picking a commit on a topic branch.

Now you can remove your topic branch and drop the commits you didn’t want to pull in.

### Tagging Your Releases ###

When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg --list-keys`:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

If you run `git push --tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG:

	$ git show maintainer-pgp-pub | gpg --import

They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification.

### Generating a Build Number ###

Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git --version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name.

The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated.

### Preparing a Release ###

Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `--format=zip` option to `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people.

### The Shortlog ###

It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1:

	$ git shortlog --no-merges master --not v1.0.1
	Chris Wanstrath (8):
	      Add support for annotated tags to Grit::Tag
	      Add packed-refs annotated tag support.
	      Add Grit::Commit#to_patch
	      Update version and History.txt
	      Remove stray `puts`
	      Make ls_tree ignore nils

	Tom Preston-Werner (4):
	      fix dates in history
	      dynamic version method
	      Version bump to 1.0.2
	      Regenerated gemspec for version 1.0.2

You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list.

## Summary ##

You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master.
