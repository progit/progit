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
# Gedistribueerd Git #

Nu je een remote Git repository hebt ingesteld als een plaats waar alle ontwikkelaars hun code kunnen delen, en je bekend bent met fundamentele Git commando's in een lokale workflow, zul je hier zien hoe je een paar gedistribueerde workflows kunt gebruiken die je met Git kunt bereiken.

In dit hoofdstuk zul je zien hoe je met Git kunt werken in een gedistribueerde omgeving als een bijdrager (contributor) en als een integrator. Dat wil zeggen, je zult leren hoe je succesvol code kunt bijdragen aan een project en hoe je het zo makkelijk mogelijk maakt voor jou en de onderhouder van het project, en ook hoe je een project succesvol kunt onderhouden waarbij een aantal ontwikkelaars bijdragen.

## Gedistribueerde workflows ##

In tegenstelling tot gecentraliseerde versiebeheersystemen (CVCSen), stelt de gedistribueerde aard van Git je in staat om veel flexibeler te zijn in de manier waarop ontwikkelaars samenwerken in projecten. Bij gecentraliseerde systemen is iedere ontwikkelaar een knooppunt dat min of meer gelijkwaardig werkt op een centraal punt. In Git is iedere ontwikkelaar zowel een knooppunt als een spil - dat wil zeggen, iedere ontwikkelaar kan zowel code bijdragen aan andere repositories, als ook een publiek repository beheren waarop andere ontwikkelaars hun werk baseren en waaraan zij kunnen bijdragen. Dit stelt je project en/of je team in staat om een enorm aantal workflows er op na te houden, dus ik zal een aantal veel voorkomende manieren behandelen die gebruik maken van deze flexibiliteit. Ik zal de sterke en mogelijke zwakke punten van ieder ontwerp behandelen; je kunt er een kiezen om te gebruiken, of je kunt van iedere wijze een paar eigenschappen overnemen en mengen.

### Gecentraliseerde workflow ###

In gecentraliseerde systemen is er over het algemeen een enkel samenwerkingsmodel - de gecentraliseerde workflow. Één centraal punt, of repository, kan code aanvaarden, en iedereen synchroniseert zijn werk daarmee. Een aantal ontwikkelaars zijn knopen - gebruikers van dat centrale punt - en synchroniseren met die plaats (zie Figuur 5-1).

Insert 18333fig0501.png
Figuur 5-1. Gecentraliseerde workflow.

Dit betekent dat als twee ontwikkelaars clonen van het gecentraliseerde punt en beiden wijzigingen doen, de eerste ontwikkelaar zijn wijzigingen zonder problemen kan pushen. De tweede ontwikkelaar zal het werk van de eerste in het zijne moeten mergen voordat hij het zijne kan pushen, om zo niet het werk van de eerste te overschrijven. Dit concept werkt in Git zoals het ook werkt in Subversion (of ieder ander CVCS), en dit model werkt prima in Git.

Als je een klein team hebt, of al vertrouwd bent met een gecentraliseerde workflow in je bedrijf of team, dan kun je eenvoudig doorgaan met het gebruiken van die workflow met Git. Stel eenvoudigweg een enkele repository in, en geef iedereen in je team  push-toegang; Git zal gebruikers niet toestaan om elkaars wijzigingen te overschrijven. Als een ontwikkelaar cloned, wijzigingen maakt, en dan probeert zijn wijzigingen te pushen terwijl een andere ontwikkelaar de zijne in de tussentijd heeft gepusht, dan zal de server de wijzigingen van die ontwikkelaar weigeren. Ze zullen verteld worden dat ze een "non-fast-forward-wijziging" proberen te pushen en dat ze dat niet wordt toegestaan totdat ze hebben gefetched en gemerged.
Deze workflow is voor een hoop mensen aantrekkelijk omdat het er een is waarmee veel mensen bekend zijn en zich op hun gemak bij voelen.

### Integratie-manager workflow ###

Omdat Git je toestaat om meerdere remote repositories te hebben, is het mogelijk om een workflow te hebben waarbij iedere ontwikkelaar schrijftoegang heeft tot zijn eigen publieke repository en leestoegang op de andere. Dit scenario heeft vaak een gezagdragend (canonical) repository dat het "officiële" project voorstelt. Om bij te kunnen dragen tot dat project, maak je je eigen publieke clone van het project en pusht je wijzigingen daarin terug. Daarna stuur je een verzoek naar de eigenaar van het hoofdproject om jouw wijzigingen binnen te halen (pull request). Hij kan je repository toevoegen als een remote, je wijzigingen lokaal testen, ze in zijn branch mergen, en dan naar zijn repository pushen. Het proces werkt als volgt (zie Figuur 5-2):

1. De projecteigenaar pusht naar de publieke repository.
2. Een bijdrager cloned die repository en maakt wijzigingen.
3. De bijdrager pusht naar zijn eigen publieke kopie.
4. De bijdrager stuurt de eigenaar een e-mail met de vraag om de wijzigingen binnen te halen (pull request).
5. De eigenaar voegt de repo van de bijdrager toe als een remote en merged lokaal.
6. De eigenaar pusht de gemergde wijzigingen terug in de hoofdrepository.

Insert 18333fig0502.png
Figuur 5-2. Integratie-manager workflow.

Dit is een veel voorkomende workflow bij websites zoals GitHub, waarbij het eenvoudig is om een project af te splitsen (fork) en je wijzigingen te pushen in jouw afgesplitste project waar iedereen ze kan zien. Een van de grote voordelen van deze aanpak is dat je door kunt gaan met werken, en de eigenaar van de hoofdrepository jouw wijzigingen op ieder moment kan pullen. Bijdragers hoeven niet te wachten tot het project hun bijdragen invoegt - iedere partij kan op zijn eigen tempo werken.

### Dictator en luitenanten workflow ###

Dit is een variant op de multi-repository workflow. Het wordt over het algemeen gebruikt bij enorme grote projecten met honderden bijdragers; een bekend voorbeeld is de Linux-kernel. Een aantal integrators geven de leiding over bepaalde delen van de repository, zij worden luitenanten genoemd. Alle luitenanten hebben één integrator die bekend staat als de welwillende dictator. De repository van de welwillende dictator dient als het referentierepository vanwaar alle bijdragers dienen binnen te halen. Het proces werkt als volgt (zie Figuur 5-3):

1. Reguliere ontwikkelaars werken op hun eigen onderwerp (topic) branch en rebasen hun werk op de master. De masterbranch is die van de dictator.
2. Luitenanten mergen de topic branches van de ontwikkelaars in hun masterbranch.
3. De dictator merged de masterbranches van de luitenanten in de masterbranch van de dictator.
4. De dictator pusht zijn masterbranch terug naar het referentierepository zodat de andere ontwikkelaars kunnen rebasen.

Insert 18333fig0503.png
Figuur 5-3. Welwillende-dictatorwerkwijze.

Deze manier van werken is niet gewoon, maar kan handig zijn in hele grote projecten of in zeer hiërarchische omgevingen, omdat het de projectleider (de dictator) in staat stelt om het meeste werk te delegeren en grote subsets van code te verzamelen op meerdere punten alvorens ze te integreren.

Dit zijn veel voorkomende workflows die mogelijk zijn met een gedistribueerd systeem als Git, maar je kunt zien dat er veel variaties mogelijk zijn om ze te laten passen bij jouw specifieke workflow. Nu dat je (naar ik hoop) in staat bent om te bepalen welke combinatie van workflows voor jou werkt, zal ik wat specifiekere voorbeelden behandelen hoe je de belangrijkste rollen kunt vervullen die in de verschillende workflows voorkomen.

## Bijdragen aan een project ##

Je weet wat de verschillende workflows zijn, en je zou het fundamentele gebruik van Git in de vingers moeten hebben. In dit gedeelte zul je leren over een aantal voorkomende patronen voor het bijdragen aan een project.

De grote moeilijkheid bij het beschrijven van dit proces is dat er een enorm aantal variaties mogelijk zijn in hoe het gebeurt. Om dat Git erg flexibel is, kunnen en zullen mensen op vele manieren samenwerken, en het is lastig om te beschrijven hoe je zou moeten bijdragen aan een project - ieder project is een beetje anders. Een aantal van de betrokken variabelen zijn de grote van actieve bijdragen, gekozen workflow, je commit toegang, en mogelijk de manier waarop externe bijdragen worden gedaan.

De eerste variabele is de grootte van actieve bijdrage. Hoeveel gebruikers dragen actief code bij aan dit project, en hoe vaak? In veel gevallen zal je twee of drie ontwikkelaars met een paar commits per dag hebben, of misschien minder voor wat meer slapende projecten. Voor zeer grote bedrijven of projecten kan het aantal ontwikkelaars in de duizenden lopen, met tientallen of zelfs honderden patches die iedere dag binnenkomen. Dit is belangrijk omdat met meer en meer ontwikkelaars, je meer en meer problemen tegenkomt bij het je verzekeren dat code netjes gepatched of eenvoudig gemerged kan worden. Wijzigingen die je indient kunnen verouderd of zwaar beschadigd raken door werk dat gemerged is terwijl je ermee aan het werken was, of terwijl je wijzigingen in de wacht stonden voor goedkeuring of toepassing. Hoe kun je jouw code consequent bij de tijd en je patches geldig houden?

De volgende variabele is de gebruikte workflow in het project. Is het gecentraliseerd, waarbij iedere ontwikkelaar gelijkwaardige schrijftoegang heeft tot de hoofd codebasis? Heeft het project een eigenaar of integrator die alle patches controleert? Worden alle patches gereviewed en goedgekeurd? Ben jij betrokken bij dat proces? Is er een luitenanten systeem neergezet, en moet je je werk eerst bij hen inleveren?

Het volgende probleem is je commit toegang. De benodigde workflow om bij te dragen aan een project is heel verschillend als je schrijftoegang hebt tot het project dan wanneer je dat niet hebt. Als je geen schrijftoegang hebt, wat is de voorkeur van het project om bijdragen te ontvangen? Is er überhaupt een beleid? Hoeveel werk draag je per keer bij? Hoe vaak draag je bij?

Al deze vragen kunnen van invloed zijn op hoe je effectief bijdraagt aan een project en welke workflows de voorkeur hebben of die beschikbaar zijn voor je. Ik zal een aantal van deze aspecten behandelen in een aantal voorbeelden, waarbij ik van eenvoudig tot complex zal gaan. Je zou in staat moeten zijn om de specifieke workflows die je in jouw praktijk nodig hebt te kunnen herleiden vanuit deze voorbeelden.

### Commit richtlijnen ###

Voordat je gaat kijken naar de specifieke gebruiksscenario's, volgt hier een kort stukje over commit berichten. Het hebben van een goede richtlijn voor het maken commits en je daar aan houden maakt het werken met Git en samenwerken met anderen een stuk makkelijker. Het Git project levert een document waarin een aantal goede tips staan voor het maken van commits waaruit je patches kunt indienen - je kunt het lezen in de Git broncode in het `Documentation/SubmittingPatches` bestand.

Als eerste wil je geen witruimte fouten indienen. Git geeft je een eenvoudige manier om hierop te controleren - voordat je commit, voer `git diff --check` uit, wat mogelijke witruimte fouten identificeert en ze voor je afdrukt. Hier is een voorbeeld, waarbij ik een rode terminal kleur hebt vervangen door `X`en:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Als je dat commando uitvoert alvorens te committen, kun je al zien of je op het punt staat witruimte problemen te committen waaraan andere ontwikkelaars zich zullen ergeren.

Probeer vervolgens om van elke commit een logische set wijzigingen te maken. Probeer, als het je lukt, om je wijzigingen verteerbaar te maken - ga niet het hele weekend zitten coderen op vijf verschillende problemen om dat vervolgens op maandag als een gigantische commit in te dienen. Zelfs als je gedurende het weekend niet commit, gebruik dan het staging gebied op maandag om je werk in ten minste één commit per probleem op te splitsen, met een bruikbaar bericht per commit. Als een paar van de wijzigingen één bestand veranderen, probeer dan `git add --patch` te gebruiken om bestanden gedeeltelijk te stagen (wordt in detail behandeld in Hoofdstuk 6). De snapshot aan de kop van het project is gelijk of je nu één commit doet of vijf, zolang alle wijzigingen op een gegeven moment maar toegevoegd zijn, dus probeer om het je mede-ontwikkelaars makkelijk te maken als ze je wijzigingen moeten bekijken. Deze aanpak maakt het ook makkelijker om één wijziging eruit te selecteren of terug te draaien, mocht dat later nodig zijn. Hoofdstuk 6 beschrijft een aantal handige Git trucs om geschiedenis te herschrijven en bestanden interactief te stagen - gebruik deze gereedschappen als hulp om een schone en begrijpelijke historie op te bouwen.

Het laatste om in gedachten te houden is het commit bericht. Als je er een gewoonte van maakt om een goede kwaliteit commit berichten aan te maken, dan maakt dat het gebruik van en samenwerken in Git een stuk eenvoudiger. In het algemeen zouden je berichten moeten beginnen met een enkele regel die niet langer is dan 50 karakters en die de wijzigingen beknopt omschrijft, gevolgd door een lege regel en daarna een meer gedetailleerde uitleg. Het Git project vereist dat de meer gedetailleerde omschrijving ook je motivatie voor de verandering bevat, en de nieuwe implementatie tegen het oude gedrag afzet. Dit is een goede richtlijn om te volgen. Het is ook een goed idee om de gebiedende wijs te gebruiken in deze berichten. Met andere woorden, gebruik commando's. In plaats van "Ik heb testen toegevoegd voor" of "Testen toegevoegd voor" gebruik je "Voeg testen toe voor".
Hier is een sjabloon dat origineel geschreven is door Tim Pope op tpope.net:

	Kort (50 karakters of minder) samenvatting van wijzigingen

	Gedetailleerdere beschrijvende tekst, indien nodig. Laat het na 
	ongeveer 72 karakters afbreken. In sommige contexten, wordt de 
	eerste regel behandeld als het onderwerp van een email en de rest
	als inhoud. De lege regel die de samenvatting scheidt van de 
	inhoud is essentieel (tenzij je de inhoud helemaal weglaat); 
	applicaties zoals rebase kunnen in de war raken als je ze 
	samenvoegt.

	Vervolg paragrafen komen na lege regels.

	 - Aandachtspunten zijn ook goed.

	 - Typisch wordt een streepje of sterretje gebruikt als "bullet",
	   voorafgegaan door een enkele spatie, met ertussen lege regels,
	   maar de conventies variëren hierin.

Als al je commit berichten er zo uit zien, dan zullen de dingen een stuk eenvoudiger zijn voor jou en de ontwikkelaars waar je mee samenwerkt. Het Git project heeft goed geformatteerde commit berichten - ik raad je aan om `git log --no-merges` uit te voeren om te zien hoe een goed geformatteerde project-commit historie eruit ziet.

In de volgende voorbeelden, en verder door de rest van dit boek, zal ik omwille van bondigheid de berichten niet zo netjes als dit formatteren; in plaats daarvan gebruik ik de `-m` optie voor `git commit`. Doe wat ik zeg, niet wat ik doe.

### Besloten klein team ###

De eenvoudigste opzet die je waarschijnlijk zult tegenkomen is een besloten project met één of twee andere ontwikkelaars. Met besloten bedoel ik gesloten broncode - zonder leestoegang voor de buitenwereld. Jij en de andere ontwikkelaars hebben allemaal push toegang op de repository.

In deze omgeving kan je een workflow aanhouden die vergelijkbaar is met wat je zou doen als je Subversion of een andere gecentraliseerd systeem zou gebruiken. Je hebt nog steeds de voordelen van zaken als offline committen en veel eenvoudiger branchen en mergen, maar de workflow kan erg vergelijkbaar zijn. Het grootste verschil is dat het mergen aan de client-kant gebeurt tijdens het committen in plaats van aan de server-kant.
Laten we eens kijken hoe het er uit zou kunnen zien als twee ontwikkelaars samen beginnen te werken met een gedeelde repository. De eerste ontwikkelaar, John, cloned de repository, maakt een wijziging, en commit lokaal. (Ik vervang de protocol berichten met `...` in deze voorbeelden om ze iets in te korten.)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

De tweede ontwikkelaar, Jessica, doet hetzelfde - cloned de repository en commit een wijziging:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

Nu pusht Jessica haar werk naar de server:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

John probeert ook zijn werk te pushen:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

John mag niet pushen omdat Jessica in de tussentijd gepusht heeft. Dit is belangrijk om te begrijpen als je gewend bent aan Subversion, omdat het je zal opvallen dat de twee ontwikkelaars niet hetzelfde bestand hebben aangepast. Waar Subversion automatisch zo'n merge op de server doet als verschillende bestanden zijn aangepast, moet je in Git de commits lokaal mergen. John moet Jessica's wijzigingen ophalen (fetch) en ze mergen voor hij mag pushen:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

Hierna ziet John's lokale repository er ongeveer uit zoals Figuur 5-4.

Insert 18333fig0504.png
Figuur 5-4. John's initiële repository.

John heeft een referentie naar de wijzigingen die Jessica gepusht heeft, maar hij moet ze mergen met zijn eigen werk voordat hij het mag pushen:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Het mergen gaat soepeltjes - de commit historie van John ziet er nu uit als Figuur 5-5.

Insert 18333fig0505.png
Figuur 5-5. John's repository na het mergen van `origin/master`.

Nu kan John zijn code testen om er zeker van te zijn dat alles nog steeds goed werkt, en dan kan hij zijn nieuwe gemergede werk pushen naar de server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Tenslotte ziet John's commit historie eruit als Figuur 5-6.

Insert 18333fig0506.png
Figuur 5-6. John's historie na gepusht te hebben naar de origin server.

In de tussentijd heeft Jessica gewerkt op een topic branch. Ze heeft een topic branch genaamd `issue54` aangemaakt en daar drie commits op gedaan. Ze heeft John's wijzigingen nog niet opgehaald, dus haar commit historie ziet er uit als Figuur 5-7.

Insert 18333fig0507.png
Figuur 5-7. Jessica's initiële commit historie.

Jessica wil met John synchroniseren, dus ze haalt de wijzigingen op:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Dit haalt het werk op dat John in de tussentijd gepusht heeft. Jessica's historie ziet er nu uit als Figuur 5-8.

Insert 18333fig0508.png
Figuur 5-8. Jessica's historie na het fetchen van John's wijzigingen.

Jessica denkt dat haar topic branch nu klaar is, maar ze wil weten wat ze in haar werk moet mergen zodat ze kan pushen. Ze voert `git log` uit om dat uit te zoeken:

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

Nu kan Jessica het werk van haar onderwerp mergen in haar `master` branch, John's werk (`origin/master`) in haar `master` branch mergen, en dan naar de server pushen. Eerst schakelt ze terug naar haar `master` branch om al dit werk te integreren:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Ze kan `origin/master` of `issue54` als eerste mergen - ze zijn beide stroomopwaarts dus de volgorde maakt niet uit. Uiteindelijk zou de snapshot gelijk moeten zijn ongeacht welke volgorde ze kiest; alleen de geschiedenis zal iets verschillen. Ze kiest ervoor om `issue54` eerst samen te voegen:

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Er doen zich geen problemen voor, zoals je kunt zien was het een eenvoudige fast-forward. Nu merged Jessica John's werk (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Alles merged netjes, en Jessica's historie ziet er uit als Figuur 5-9.

Insert 18333fig0509.png
Figuur 5-9. Jessica's historie na het mergen van John's wijzigingen.

Nu is `origin/master` bereikbaar vanuit Jessica's `master` branch, dus ze zou in staat moeten zijn om succesvol te pushen (even aangenomen dat John in de tussentijd niets gepusht heeft):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Iedere ontwikkelaar heeft een paar keer gecommit en elkaars werk succesvol samengevoegd, zie Figuur 5-10.

Insert 18333fig0510.png
Figuur 5-10. Jessica's historie na alle wijzigingen teruggezet te hebben op de server.

Dit is één van de eenvoudigste workflows. Je werkt een tijdje, over het algemeen in een topic branch, en merged dit in je `master` branch als het klaar is om te worden geïntegreerd. Als je dat werk wilt delen, dan merge je het in je eigen `master` branch, en vervolgens fetch je `origin/master` en merge je deze als het gewijzigd is, en als laatste push je deze naar de `master` branch op de server. De algemene volgorde is zoiets als die getoond in Figuur 5-11.

Insert 18333fig0511.png
Figuur 5-11. Algemene volgorde van gebeurtenissen voor een eenvoudige multi-ontwikkelaar Git workflow.

### Besloten aangestuurd team ###

In het volgende scenario zul je kijken naar de rol van de bijdragers in een grotere besloten groep. Je zult leren hoe te werken in een omgeving waar kleine groepen samenwerken aan functies, waarna die team-gebaseerde bijdragen worden geïntegreerd door een andere partij.

Stel dat John en Jessica samen werken aan een functie, terwijl Jessica en Josie aan een tweede aan het werken zijn. In dit geval gebruikt het bedrijf een integratie-manager achtige workflow, waarbij het werk van de individuele groepen alleen wordt geïntegreerd door bepaalde ontwikkelaars, en de `master` branch van het hoofd repo alleen kan worden vernieuwd door die ontwikkelaars. In dit scenario wordt al het werk gedaan in team-gebaseerde branches en later door de integrators samengevoegd.

Laten we Jessica's workflow volgen terwijl ze aan haar twee features werkt, in parallel met twee verschillende ontwikkelaars in deze omgeving. We nemen even aan dat ze haar repository al gecloned heeft, en dat ze besloten heeft als eerste te werken aan `featureA`. Ze maakt een nieuwe branch aan voor de functie en doet daar wat werk:

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

Op dit punt, moet ze haar werk delen met John, dus ze pusht haar commits naar de `featureA` branch op de server. Jessica heeft geen push toegang op de `master` branch - alleen de integratoren hebben dat - dus ze moet naar een andere branch pushen om samen te kunnen werken met John:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica mailt John om hem te zeggen dat ze wat werk gepusht heeft in een branch genaamd `featureA` en dat hij er nu naar kan kijken. Terwijl ze op terugkoppeling van John wacht, besluit Jessica te beginnen met het werken aan `featureB` met Josie. Om te beginnen start ze een nieuwe functie branch, gebaseerd op de `master` branch van de server:

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
Figuur 5-12. Jessica's initiële commit historie.

Ze is klaar om haar werk te pushen, maar ze krijgt een mail van Josie dat een branch met wat initieel werk erin al gepusht is naar de server in de `featureBee` branch. Jessica moet die wijzigingen eerst mergen met die van haar voordat ze kan pushen naar de server. Ze kan dan Josie's wijzigingen ophalen met `git fetch`:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Jessica kan dit nu mergen in het werk wat zij gedaan heeft met `git merge`:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

Er is wel een klein probleempje - ze moet het gemergde werk in haar `featureB` branch naar de `featureBee` branch op de server zetten. Ze kan dat doen door de lokale branch door te geven aan het `git push` commando, gevolgd door een dubbele punt (:), gevolgd door de remote branch:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Dit wordt een _refspec_ genoemd. Zie Hoofdstuk 9 voor een gedetailleerdere behandeling van Git refspecs en de verschillende dingen die je daarmee kan doen.

Vervolgens mailt John naar Jessica om te zeggen dat hij wat wijzigingen naar de `featureA` branch gepusht heeft, en om haar te vragen die te verifiëren. Ze voert een `git fetch` uit om die wijzigingen op te halen:

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

Uiteindelijk merged ze John's werk in haar eigen `featureA` branch:

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica wil iets kleins wijzigen, dus doet ze nog een commit en pusht dit naar de server:

	$ git commit -am 'small tweak'
	[featureA ed774b3] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

Jessica's commit historie ziet er nu uit zoals Figuur 5-13.

Insert 18333fig0513.png
Figuur 5-13. Jessica's historie na het committen op een feature branch.

Jessica, Josie en John informeren de integrators nu dat de `featureA` en `featureBee` branches op de server klaar zijn voor integratie in de hoofdlijn. Nadat zij die branches in de hoofdlijn geïntegreerd hebben, zal een fetch de nieuwe merge commits ophalen, waardoor de commit historie er uit ziet zoals Figuur 5-14.


Insert 18333fig0514.png
Figuur 5-14. Jessica's historie na het mergen van allebei haar onderwerp branches.

Veel groepen schakelen om naar Git juist vanwege de mogelijkheid om meerdere teams in parallel te kunnen laten werken, waarbij de verschillende lijnen van werk laat in het proces gemerged worden. De mogelijkheid van kleinere subgroepen of een team om samen te werken via remote branches zonder het hele team erin te betrekken of te hinderen is een enorm voordeel van Git. De volgorde van de workflow die je hier zag is ongeveer zoals Figuur 5-15.

Insert 18333fig0515.png
Figuur 5-15. Eenvoudige volgorde in de workflow van dit aangestuurde team.

### Klein openbaar project ###

Het bijdragen aan openbare, of publieke, projecten gaat op een iets andere manier. Omdat je niet de toestemming hebt om de branches van het project rechtstreeks te updaten, moet je het werk op een andere manier naar de beheerders krijgen. Dit eerste voorbeeld beschrijft het bijdragen via afsplitsen (forken) op Git hosts die het eenvoudig aanmaken van forks ondersteunen. De repo.or.cz en GitHub hosting sites ondersteunen dit beide, en veel project beheerders verwachten deze manier van bijdragen. De volgende paragraaf behandelt projecten die de voorkeur hebben om bijdragen in de vorm van patches via e-mail te ontvangen.

Eerst zal je waarschijnlijk de hoofdrepository clonen, een topic branch maken voor de patch of reeks patches die je van plan bent bij te dragen, en je werk daarop doen. De te volgen stappen zien er zo uit:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Je kunt eventueel besluiten `rebase -i` te gebruiken om je werk in één enkele commit samen te persen (squash), of het werk in de commits te herschikken om de patch eenvoudiger te kunnen laten reviewen door de beheerders - zie Hoofdstuk 6 voor meer informatie over het interactief rebasen.

Als je werk op de branch af is, en je klaar bent om het over te dragen aan de beheerders, ga je naar de originele project pagina en klik op de "Fork" knop. Hiermee maak je een eigen overschrijfbare fork van het project. Je moet de URL van deze nieuwe repository URL toevoegen als een tweede remote, in dit geval `myfork` genaamd:

	$ git remote add myfork (url)

Je wilt je werk daar naartoe pushen. Het is het makkelijkst om de remote branch waar je op zit te werken te pushen naar je repository, in plaats van het te mergen in je master branch en die te pushen. De reden hiervan is, dat als het werk niet wordt geaccepteerd of alleen ge-cherry picked (deels overgenomen), je jouw master branch niet hoeft terug te draaien. Als de beheerders je werk mergen, rebasen of cherry picken, dan krijg je het uiteindelijk toch binnen door hun repository te pullen:

	$ git push myfork featureA

Als jouw werk gepusht is naar jouw fork, dan moet je de beheerder inlichten. Dit wordt een pull request (haal-binnen-verzoek) genoemd, en je kunt deze via de website genereren - GitHub heeft een "pull request" knop die de beheerder automatisch een bericht stuurt - of het `git request-pull` commando uitvoeren en de uitvoer handmatig naar de projectbeheerder mailen.

Het `request-pull` commando neemt de basis branch waarin je de topic branch gepulled wil hebben, en de URL van de Git repository waar je ze uit wil laten pullen, en maakt een samenvatting van alle wijzigingen die je gepulled wenst te hebben. Bijvoorbeeld, als Jessica John een pull request wil sturen, en ze heeft twee commits gedaan op de topic branch die ze zojuist gepusht heeft, dan kan ze dit uitvoeren:

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

De uitvoer kan naar de beheerders gestuurd worden: het vertelt ze waar het werk vanaf gebranched is, vat de commits samen en vertelt waar vandaan ze dit werk kunnen pullen.

Bij een project waarvan je niet de beheerder bent, is het over het algemeen eenvoudiger om een branch zoals `master` altijd de `origin/master` te laten tracken, en je werk te doen in topic branches die je eenvoudig weg kunt gooien als ze geweigerd worden. Als je je werkthema's gescheiden houdt in topic branches maakt dat het ook eenvoudiger voor jou om je werk te rebasen als de punt van de hoofd-repository in de tussentijd verschoven is en je commits niet langer netjes toegepast kunnen worden. Bijvoorbeeld, als je een tweede onderwerp wilt bijdragen aan een project, ga dan niet verder werken op de topic branch die je zojuist gepusht hebt - begin opnieuw vanaf de `master` branch van het hoofd repository:

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

Nu zijn al je onderwerpen opgeslagen in een silo - vergelijkbaar met een patch reeks (queue) - die je kunt herschrijven, rebasen en wijzigen zonder dat de onderwerpen elkaar beïnvloeden of van elkaar afhankelijk zijn zoals in Figuur 5-16.

Insert 18333fig0516.png
Figuur 5-16. Initiële commit historie met werk van featureB.

Stel dat de project-beheerder een verzameling andere patches binnengehaald heeft en jouw eerste branch geprobeerd heeft, maar dat die niet meer netjes merged. In dat geval kun je proberen die branch te rebasen op `origin/master`, de conflicten op te lossen voor de beheerder, en dan je wijzigingen opnieuw aanbieden:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push -f myfork featureA

Dit herschrijft je geschiedenis zodat die eruit ziet als in Figuur 5-17.

Insert 18333fig0517.png
Figuur 5-17. Commit historie na werk van featureA.

Omdat je de branch gerebased hebt, moet je de `-f` specificeren met je push commando om in staat te zijn de `featureA` branch op de server te vervangen met een commit die er geen afstammeling van is. Een alternatief zou zijn dit nieuwe werk naar een andere branch op de server te pushen (misschien `featureAv2` genaamd).

Laten we eens kijken naar nog een mogelijk scenario: de beheerder heeft je werk bekeken in je tweede branch en vind het concept goed, maar zou willen dat je een implementatie detail verandert. Je moet deze gelegenheid meteen gebruiken om het werk te baseren op de huidige `master` branch van het project. Je begint een nieuwe branch gebaseerd op de huidige `origin/master` branch, squashed de `featureB` wijzigingen er naartoe, lost conflicten op, doet de implementatie wijziging en pusht deze terug als een nieuwe branch:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

De `--squash` optie pakt al het werk op de gemergde branch en perst dat samen in één non-merge commit bovenop de branch waar je op zit. De `--no-commit` optie vertelt Git dat hij niet automatisch een commit moet doen. Dit stelt je in staat om alle wijzigingen van een andere branch te introduceren en dan meer wijzigingen te doen, alvorens de nieuwe commit te doen.

Je kunt de beheerder nu een bericht sturen dat je de gevraagde wijzigingen gemaakt hebt en dat ze die wijzigingen kunnen vinden in je `featureBv2` branch (zie Figuur 5-18).

Insert 18333fig0518.png
Figuur 5-18. Commit historie na het featureBv2 werk.

### Openbaar groot project ###

Veel grote projecten hebben vastgestelde procedures voor het accepteren van patches - je zult de specifieke regels voor ieder project goed moeten bekijken, omdat ze verschillend zullen zijn. Veel grote projecten accepteren patches veelal via ontwikkelaar-maillijsten, daarom zal ik zo'n voorbeeld nu laten zien.

De workflow is vergelijkbaar met het vorige geval - je maakt topic branches voor iedere patch waar je aan werkt. Het verschil is hoe je die aanlevert bij het project. In plaats van het project te forken en naar je eigen schrijfbare versie te pushen, genereer je e-mail versies van iedere reeks commits en mailt die naar de ontwikkelaar-maillijst:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Nu heb je twee commits die je wil sturen naar de maillijst. Je gebruikt `git format-patch` om de mbox-geformatteerde bestanden te genereren die je kunt mailen naar de lijst. Dit vormt iedere commit om naar een e-mail bericht met de eerste regel van het commit bericht als het onderwerp, en de rest van het bericht plus de patch die door de commit wordt geïntroduceerd als de inhoud. Het prettige hieraan is dat met het toepassen van een patch uit een mail die gegenereerd is met `format-patch` alle commit informatie blijft behouden. In de volgende paragraaf zal je hiervan meer zien, als je deze commits gaat toepassen:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

Het `format-patch` commando drukt de namen af van de patch bestanden die het maakt. De `-M` optie vertelt Git te kijken naar hernoemingen. De bestanden komen er uiteindelijk zo uit te zien:

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

Je kunt deze patch bestanden ook aanpassen om meer informatie, die je niet in het commit bericht wilt laten verschijnen, voor de maillijst toe te voegen . Als je tekst toevoegt tussen de `---` regel en het begin van de patch (de `lib/simplegit.rb` regel), dan kunnen ontwikkelaars dit lezen, maar tijdens het toepassen van de patch wordt dit weggelaten.

Om dit te mailen naar een maillijst, kan je het bestand in je mail-applicatie plakken of het sturen via een commandoregel programma. Het plakken van de tekst veroorzaakt vaak formaterings problemen, in het bijzonder bij "slimmere" clients die de newlines en andere witruimte niet juist behouden. Gelukkig levert Git een gereedschap die je helpt om juist geformatteerde patches via IMAP te versturen, wat het alweer een stuk makkelijker voor je maakt. Ik zal zal je laten zien hoe je een patch via Gmail stuurt, wat de mail-applicatie is die ik toevallig gebruik. Je kunt gedetailleerde instructies voor een aantal mail programma's vinden aan het eind van het voornoemde `Documentation/SubmittingPatches` bestand in de Git broncode.

Eerst moet je de imap sectie in je `~/.gitconfig` bestand instellen. Je kunt iedere waarde apart instellen met een serie `git config` commando's, of je kunt ze handmatig toevoegen, maar uiteindelijk moet je config bestand er ongeveer zo uitzien:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Als je IMAP server geen SSL gebruikt, zijn de laatste twee regels waarschijnlijk niet nodig, en de waarde voor host zal `imap://` zijn in plaats van `imaps://`.
Als dat ingesteld is, kun je `git send-email` gebruiken om de patch reeks in de Drafts map van de gespecificeerde IMAP server te zetten:

	$ cat *.patch |git imap-send
	Resolving imap.gmail.com... ok
	Connecting to [74.125.142.109]:993... ok
	Logging in...
	sending 2 messages
	100% (2/2) done

Nu kan je naar jouw Drafts folder gaan, het To veld wijzigen naar de maillijst waar je de patch naartoe stuurt en misschien de beheerder of verantwoordelijke voor dat deel in de CC zetten en dan versturen.

Je kunt de patches ook via een SMTP server sturen. Zoals eerder kan je elke waarde apart instellen met een serie `git config` commando's, of je kunt ze handmatig in de sendmail sectie in je `~/.gitconfig` bestand zetten:

	[sendemail]
	  smtpencryption = tls
	  smtpserver = smtp.gmail.com
	  smtpuser = user@gmail.com
	  smtpserverport = 587

Als dit gedaan is, kan je `git send-email` gebruiken om je patches te sturen:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Dan spuuwt Git een bergje log-informatie uit voor elke patch die je stuurt, wat er ongeveer zo uitziet:

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

### Samenvatting ###

In dit hoofdstuk is een aantal veel voorkomende workflows behandeld, die je kunt gebruiken om te kunnen werken in een aantal zeer verschillende typen Git projecten die je misschien zult tegenkomen. En er zijn een aantal nieuwe gereedschappen geïntroduceerd die je helpen om dit proces te beheren. Wat hierna volgt zal je laten zien hoe je aan de andere kant van de tafel werkt: een Git project beheren. Je zult leren hoe een welwillende dictator of integratie manager te zijn.

## Het beheren van een project ##

Naast weten hoe effectief bij te dragen aan een project, moet je waarschijnlijk ook moeten weten hoe je er een beheert. Dit kan bestaan uit het accepteren en toepassen van patches die met `format-patch` gemaakt en naar je gemaild zijn, of het integreren van wijzigingen in de remote branches van repositories die je hebt toegevoegd als remotes van je project. Of je nu een canonieke repository beheert, of wilt bijdragen door het controleren of goedkeuren van patches, je moet weten hoe werk te ontvangen op een zodanige manier die het duidelijkst is voor andere bijdragers en voor jou op langere termijn vol te houden.

### Werken in topic branches ###

Als je overweegt om nieuw werk te integreren, is het over het algemeen een goed idee om het uit te proberen in een topic branch - een tijdelijke branch, speciaal gemaakt om dat nieuwe werk uit te proberen. Op deze manier is het handig om een patch individueel te behandelen en het even opzij te zetten als het niet werkt, totdat je tijd hebt om er op terug te komen. Als je een eenvoudige branchnaam maakt, gebaseerd op het onderwerp van het werk dat je aan het proberen bent, bijvoorbeeld `ruby_client` of zoiets beschrijvends, dan is het makkelijk om te herinneren als je het voor een tijdje opzij legt en er later op terug komt. De beheerder van het Git project heeft de neiging om deze branches ook van een naamsruimte (namespace) te voorzien - zoals `sc/ruby_client`, waarbij `sc` een afkorting is van de persoon die het werk heeft bijgedragen.
Zoals je je zult herinneren, kun je de branch gebaseerd op je master branch zo maken:

	$ git branch sc/ruby_client master

Of, als je er ook meteen naar wilt omschakelen, kun je de `checkout -b` optie gebruiken:

	$ git checkout -b sc/ruby_client master

Nu ben je klaar om het bijgedragen werk in deze topic branch toe te voegen, en te bepalen of je het wilt mergen in je meer permanente branches.

### Patches uit e-mail toepassen ###

Als je een patch per e-mail ontvangt, en je moet die integreren in je project, moet je de patch in je topic branch toepassen om het te evalueren. Er zijn twee manieren om een gemailde patch toe te passen: met `git apply` of met `git am`.

#### Een patch toepassen met apply ####

Als je de patch ontvangen hebt van iemand die het gegenereerd heeft met de `git diff` of een Unix `diff` commando, kun je het toepassen met het `git apply` commando. Aangenomen dat je de patch als `/tmp/patch-ruby-client.patch` opgeslagen hebt, kun je de patch als volgt toepassen:

	$ git apply /tmp/patch-ruby-client.patch

Dit wijzigt de bestanden in je werk directory. Het is vrijwel gelijk aan het uitvoeren van een `patch -p1` commando om de patch toe te passen, alhoewel het meer paranoïde is en minder "fuzzy matches" accepteert dan patch. Het handelt ook het toevoegen, verwijderen, en hernoemen van bestanden af als ze beschreven staan in het `git diff` formaat, wat `patch` niet doet. Als laatste volgt `git apply` een "pas alles toe of laat alles weg" model waarbij alles of niets wordt toegepast. Dit in tegenstelling tot `patch` die gedeeltelijke patches kan toepassen, waardoor je werkdirectory in een vreemde status achterblijft. Over het algemeen is `git apply` meer paranoïde dan `patch`. Het zal geen commit voor je aanmaken: na het uitvoeren moet je de geïntroduceerde wijzigingen handmatig stagen en committen.

Je kunt ook `git apply` gebruiken om te zien of een patch netjes kan worden toepast voordat je het echt doet; je kunt `git apply --check` uitvoeren met de patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

Als er geen uitvoer is, dan zou de patch netjes moeten passen. Dit commando retourneert ook een niet-nul status als de controle faalt, zodat je het kunt gebruiken in scripts als je dat zou willen.

#### Een patch met am toepassen ####

Als de bijdrager een Git gebruiker is en zo vriendelijk is geweest om het `format-patch` commando te gebruiken om de patch te genereren, dan is je werk eenvoudiger omdat de patch de auteur informatie en een commit bericht voor je bevat. Als het enigzins kan, probeer dan je bijdragers aan te moedigen om `format-patch` te gebruiken in plaats van `diff` om patches te genereren voor je. Je zou alleen `git apply` willen hoeven te gebruiken voor oude patches en dat soort dingen.

Om een patch gegenereerd met `format-patch` toe te passen, gebruik je `git am`. Technisch is `git am` gemaakt om een mbox bestand te lezen, dat een eenvoudig gewone platte tekstformaat is om één of meer e-mail berichten in een tekstbestand op te slaan. Het ziet er ongeveer zo uit:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

Dit is het begin van de uitvoer van het format-patch commando dat je gezien hebt in de vorige paragraaf. Dit is ook een geldig mbox e-mail formaat. Als iemand jou de patch correct gemaild heeft door gebruik te maken van `git send-email` en je downloadt dat in een mbox formaat, dan kan je het `git am` naar dat mbox bestand verwijzen, en het zal beginnen met alle patches die het tegenkomt toe te passen. Als je een mail client gebruikt die meerdere e-mails kan opslaan in mbox formaat, dan kun je hele reeksen patches in een bestand opslaan en dan `git am` gebruiken om ze één voor één toe te passen.

Maar, als iemand een patch bestand heeft geüpload die gegenereerd is met `format-patch` naar een ticket systeem of zoiets, kun je het bestand lokaal opslaan en dan dat opgeslagen bestand aan `git am` doorgeven om het te applyen:

	$ git am 0001-limit-log-function.patch
	Applying: add limit to log function

Je ziet dat het netjes is toegepast, en automatisch een nieuwe commit voor je heeft aangemaakt. De auteursinformatie wordt gehaald uit de `From` en `Date` velden in de kop, en het bericht van de commit wordt gehaald uit de `Subject` en de inhoud (voor de patch) uit het mailbericht zelf. Bijvoorbeeld, als deze patch was toegepast van het mbox voorbeeld dat ik zojuist getoond heb, dan zou de gegenereerde commit er ongeveer zo uit zien:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

De `Commit` informatie toont de persoon die de patch toegepast heeft en de tijd waarop het is toegepast. De `Author` informatie de persoon die de patch oorspronkelijk gemaakt heeft en wanneer het gemaakt is.

Maar het is mogelijk dat de patch niet netjes toegepast kan worden. Misschien is jouw hoofdbranch te ver afgeweken van de branch waarop de patch gebouwd is, of is de patch afhankelijk van een andere patch, die je nog niet hebt toegepast. In dat geval zal het `git am` proces falen en je vragen wat je wilt doen:

	$ git am 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

Dit commando zet conflict markeringen in alle bestanden waar het problemen mee heeft, net zoals een conflicterende merge of rebase operatie. Je lost dit probleem op een vergelijkbare manier op: wijzig het bestand om het conflict op te lossen, stage het bestand en voer dan `git am --resolved` uit om door te gaan met de volgende patch:

	$ (fix the file)
	$ git add ticgit.gemspec
	$ git am --resolved
	Applying: seeing if this helps the gem

Als je wilt dat Git iets meer intelligentie toepast om het conflict op te lossen, kun je een `-3` optie eraan meegeven, dit zorgt ervoor dat Git een driewegs-merge probeert. Deze optie staat standaard niet aan omdat het niet werkt als de commit waarvan de patch zegt dat het op gebaseerd is niet in je repository zit. Als je die commit wel hebt - als de patch gebaseerd was op een publieke commit - dan is de `-3` over het algemeen veel slimmer in het toepassen van een conflicterende patch:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In dit geval, probeerde ik een patch te applyen die ik al eerder toegepast had. Zonder de `-3` optie ziet het eruit als een conflict.

Als je een aantal patches van een mbox toepast, kun je ook het `am` commando in een interactieve modus uitvoeren, wat bij iedere patch die het vind stopt en je vraagt of je het wilt applyen:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

Dit is prettig als je een aantal patches bewaard hebt, omdat je de patch eerst kunt zien als je niet kunt herinneren wat het is, of de patch niet wilt toepassen omdat je dat al eerder gedaan hebt.

Als alle patches voor je topic branch zijn toegepast en gecommit zijn op je branch, kan je besluiten of en hoe ze te integreren in een branch met een langere looptijd.

### Remote branches uitchecken ###

Als je bijdrage van een Git gebruiker komt die zijn eigen repository opgezet heeft, een aantal patches daarin gepusht heeft, en jou de URL naar de repository gestuurd heeft en de naam van de remote branch waarin de wijzigingen zitten, kan je ze toevoegen als een remote en het mergen lokaal doen.

Bijvoorbeeld, als Jessica je een e-mail stuurt waarin staat dat ze een prachtig mooie nieuwe feature in de `ruby-client` branch van haar repository heeft, kun je deze testen door de remote toe te voegen en die branch lokaal te bekijken:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

Als ze je later opnieuw mailt met een andere branch die weer een andere mooie feature bevat, dan kun je die ophalen en bekijken omdat je de remote al ingesteld hebt.

Dit is meest practisch als je vaak met een persoon werkt. Als iemand een enkele patch eens in de zoveel tijd bij te dragen heeft, dan is het accepteren per mail misschien minder tijdrovend dan te eisen dat iedereen hun eigen server moet beheren, en daarna voortdurend remotes te moeten toevoegen en verwijderen voor die paar patches. Je zult daarbij waarschijnlijk ook niet honderden remotes willen hebben, elk voor iemand die maar een patch of twee bijdraagt. Aan de andere kant, scripts en gehoste diensten maken het wellicht eenvoudiger; het hangt sterk af van de manier waarop ontwikkelt en hoe je bijdragers ontwikkelen.

Het andere voordeel van deze aanpak is dat je de historie van de commits ook krijgt. Alhoewel je misschien terechte merge problemen hebt, weet je op welk punt in de historie hun werk is gebaseerd; een echte drieweg merge is de standaard in plaats van een `-3` te moeten meegeven en hopen dat de patch gegenereerd was van een publieke commit waar je toegang toe hebt.

Als je maar af en toe met een persoon werkt, maar toch op deze manier van hen wilt pullen, dan kun je de URL van de remote repository geven aan het `git pull` commando. Dit doet een eenmalig pull en bewaart de URL niet als een remote referentie:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Bepalen wat geïntroduceerd wordt ###

Je hebt een topic branch dat bijgedragen werk bevat. Nu kan je besluiten wat je er mee wilt doen. Deze paragraaf behandelt een paar commando's nogmaals om te laten zien hoe je ze kunt gebruiken om precies te reviewen wat je zult introduceren als je dit merged in je hoofd branch.

Het is vaak handig om een review te krijgen van alle commits die in deze branch zitten, maar die niet in je master branch zitten. Je kunt commits weglaten die al in de master branch zitten door de `--not` optie mee te geven voor de branch naam. Bijvoorbeeld, als je bijdrager je twee patches stuurt, je hebt een branch genaamd `contrib` gemaakt en hebt die patches daar toegepast, dan kun je dit uitvoeren:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

Om te zien welke wijzigingen door een commit worden geïntroduceerd, onthoud dan dat je de `-p` optie kunt meegeven aan `git log` en dan zal het de geïntroduceerde diff erachter plakken bij iedere commit.

Om een volledige diff te zien van wat zou gebeuren als je deze topic branch merged met een andere branch, zul je misschien een vreemde truc moeten toepassen om de juiste resultaten te krijgen. Je zult misschien denken om dit uit te voeren:

	$ git diff master

Dit commando geeft je een diff, maar het kan misleidend zijn. Als je `master` branch vooruit geschoven is sinds je de topic branch er vanaf hebt gemaakt, dan zul je ogenschijnlijk vreemde resultaten krijgen. Dit gebeurt omdat Git de snapshots van de laatste commit op de topic branch waar je op zit vergelijkt met het laatste snapshot van de `master` branch. Bijvoorbeeld, als je een regel in een bestand hebt toegevoegd op de `master` branch, dan zal een directe vergelijking van de snapshots eruit zien alsof de topic branch die regel gaat verwijderen.

Als `master` een directe voorganger is van je topic branch is dit geen probleem, maar als de twee histories uit elkaar zijn gegaan, zal de diff eruit zien alsof je alle nieuwe spullen in je topic branch toevoegt en al hetgeen wat alleen in de `master` branch staat weghaalt.

Wat je eigenlijk had willen zien zijn de wijzigingen die in de topic branch zijn toegevoegd: het werk dat je zult introduceren als je deze branch met master merged. Je doet dat door Git de laatste commit op je topic branch te laten vergelijken met de eerste gezamenlijke voorouder die het heeft met de master branch.

Technisch, kun je dat doen door de gezamenlijke voorouder op te zoeken en dan daar je diff op uit te voeren:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db

Maar, dat is niet handig, dus levert Git een andere verkorte manier om hetzelfde te doen: de driedubbele punt syntax. In de context van het `diff` commando, kun je drie punten achter een andere branch zetten om een `diff` te doen tussen de laatste commit van de branch waar je op zit en de gezamenlijke voorouder met een andere branch:

	$ git diff master...contrib

Dit commando laat alleen het werk zien dat je huidige topic branch heeft geïntroduceerd sinds de gezamenlijke voorouder met master. Dat is een erg handige syntax om te onthouden.

### Bijgedragen werk integreren ###

Als al het werk in je onderwerp branch klaar is om te worden geïntegreerd in een hogere branch, dan is de vraag hoe het te doen. En daarbij, welke workflow wil je gebruiken om je project te beheren? Je hebt een aantal keuzes, dus ik zal er een paar behandelen.

#### Mergende workflows ####

Een eenvoudige workflow merged je werk in de `master` branch. In dit scenario heb je een `master` branch die feitelijk de stabiele code bevat. Als je werk in een topic branch hebt waaraan je gewerkt hebt, of dat iemand anders heeft bijgedragen en je hebt dat nagekeken, dan merge je het in de master branch, verwijdert de topic branch en vervolgt het proces. Als we een repository hebben met werk in twee branches genaamd `ruby_client` en `php_client`, wat eruit ziet zoals Figuur 5-19 en mergen eerst `ruby_client` en daarna `php_client`, dan zal je historie er uit gaan zien zoals in Figuur 5-20.

Insert 18333fig0519.png
Figuur 5-19. Historie met een aantal topic branches.

Insert 18333fig0520.png
Figuur 5-20. Na het mergen van een topic branch.

Dat is waarschijnlijk de eenvoudigste workflow, maar het wordt problematisch als je werkt met grotere repositories of projecten.

Als je meer ontwikkelaars hebt of een groter project, dan zul je waarschijnlijk minstens een twee-fasen merge cyclus willen toepassen. In dat geval heb je twee langlopende branches, `master` en `develop`, waarbij je bepaalt dat `master` alleen vernieuwd wordt als een zeer stabiele release is gemaakt en alle nieuwe code geïntegreerd is in de `develop` branch. Je pusht beide branches op regelmatige basis naar de publieke repository. Iedere keer als je een nieuw topic branch hebt om te mergen (Figuur 5-21), merge je het in `develop` (Figuur 5-22). En als je een tag gemaakt heb van een release, doe je een fast-forward van `master` naar waar de nu stabiele `develop` branch is (Figuur 5-23).

Insert 18333fig0521.png
Figuur 5-21. Voor een merge van een topic branch.

Insert 18333fig0522.png
Figuur 5-22. Na een merge van een topic branch.

Insert 18333fig0523.png
Figuur 5-23. Na een release van een topic branch.

Op deze manier, als mensen de repository van je project clonen, dan kunnen ze kiezen om master uit checken en daarmee de laatste stabiele versie te bouwen en die eenvoudig up-to-date te houden, of ze kunnen develop uit checken waar het nieuwere materiaal in staat.
Je kunt dit concept ook verder doorvoeren, waarbij je een integratie branch hebt waar al het werk gemerged wordt. Als de codebasis op die branch stabiel is en de alle tests daar slagen, dan merge je het in een develop branch. Pas als het daar een periode stabiel is gebleken, dan fast-forward je de master branch.

#### workflows met grote merges ####

Het Git project heeft vier langlopende branches: `master`, `next`, en `pu` (proposed updates, voorgestelde vernieuwingen) voor nieuw spul, en `maint` voor onderhoudswerk (maintenance backports). Als nieuw werk wordt geïntroduceerd door bijdragers, wordt het samengeraapt in topic branches in de repository van de beheerder op een manier die lijkt op wat ik omschreven heb (zie Figuur 5-24). Hier worden de topics geëvalueerd om te bepalen of ze veilig zijn en klaar voor verdere verwerking of dat ze nog wat werk nodig hebben. Als ze veilig zijn, worden ze in `next` gemerged, en wordt die branch gepusht zodat iedereen de geïntegreerde topics kan uitproberen.

Insert 18333fig0524.png
Figuur 5-24. Een complexe serie van parallel bijgedragen topic branches beheren.

Als de topics nog werk nodig hebben, dan worden ze in plaats daarvan gemerged in `pu`. Zodra vastgesteld is dat ze helemaal stabiel zijn, dan worden de topics opnieuw gemerged in `master` en worden dan herbouwd van de topics die in `next` waren, maar nog niet gepromoveerd waren naar `master`. Dit betekent dat `master` vrijwel altijd vooruit beweegt, `next` eens in de zoveel tijd gerebased wordt, en `pu` nog vaker gerebased wordt (zie Figuur 5-25).

Insert 18333fig0525.png
Figuur 5-25. Bijgedragen topic branches mergen in langlopende integratie branches.

Als een onderwerp branch uiteindelijk is gemerged in `master`, dan wordt het verwijderd van de repository. Het Git project heeft ook een `maint` branch, die geforked is van de laatste release om teruggewerkte (backported) patches te leveren in het geval dat een onderhoudsrelease nodig is. Dus als je de Git repository cloned, dan heb je vier branches die je kunt uitchecken om het project in verschillende stadia van ontwikkeling te evalueren, afhankelijk van hoe nieuw je alles wilt hebben of hoe je wil bijdragen. En de beheerders hebben een gestructureerde workflow om ze te helpen nieuwe bijdragen aan de tand te voelen.

#### Rebasende en cherry pick workflows ####

Andere beheerders geven de voorkeur aan rebasen of bijgedragen werk te cherry picken naar hun master branch in plaats van ze erin te mergen, om een vrijwel lineaire historie te behouden. Als je werk in een topic branch hebt en hebt besloten dat je het wil integreren, dan ga je naar die branch en voert het rebase commando uit om de wijzigingen op je huidige master branch te baseren (of `develop`, enzovoorts). Als dat goed werkt, dan kun je de `master` branch fast-forwarden, en eindig je met een lineaire project historie.

De andere manier om geïntroduceerd werk van de ene naar de andere branch te verplaatsen is om het te cherry picken. Een cherry-pick in Git is een soort rebase voor een enkele commit. Het pakt de patch die was geïntroduceerd in een commit en probeert die weer toe te passen op de branch waar je nu op zit. Dit is handig als je een aantal commits op een topic branch hebt en je er slechts één van wilt integreren, of als je alleen één commit op een topic branch hebt en er de voorkeur aan geeft om het te cherry-picken in plaats van rebase uit te voeren. Bijvoorbeeld, stel dat je een project hebt dat eruit ziet als Figuur 5-26.

Insert 18333fig0526.png
Figuur 5-26. Voorbeeld historie voor een cherry pick.

Als je commit `e43a6` in je master branch wilt pullen, dan kun je dit uitvoeren

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

Dit pulled dezelfde wijziging zoals geïntroduceerd in `e43a6`, maar je krijgt een nieuwe SHA-1 waarde, omdat de gegevens op een andere manier toegepast zijn. Nu ziet je historie eruit als Figuur 5-27.

Insert 18333fig0527.png
Figuur 5-27. Historie na het cherry-picken van een commit op een topic branch.

Nu kun je de topic branch verwijderen en de commits die je niet wilde pullen weggooien.

### Je releases taggen ###

Als je hebt besloten om een release te maken, zul je waarschijnlijk een tag willen aanmaken zodat je die release op elk moment in de toekomst opnieuw kunt maken. Je kunt een nieuwe tag maken zoals ik heb beschreven in Hoofdstuk 2. Als je besluit om de tag als de beheerder te signeren, dan ziet het taggen er misschien zo uit:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Als je tags signeert, dan heb je misschien een problem om de publieke PGP sleutel, die gebruikt is om de tags te signeren, te distribueren. De beheerder van het Git project heeft dit probleem opgelost door hun publieke sleutel als een blob in de repository mee te nemen en een tag te maken die direct naar die inhoud wijst. Om dit te doen kun je uitvinden welke sleutel je wilt door `gpg --list-keys` uit te voeren:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Daarna kun je de sleutel direct in de Git database importeren, door het te exporteren en te "pipen" naar `git hash-object`, wat een nieuwe blob schrijft in Git met die inhoud en je de SHA-1 van de blob teruggeeft:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Nu je de inhoud van je sleutel in Git hebt, kun je een tag aanmaken die direct daar naar wijst door de nieuw SHA-1 waarde die het `hash-object` commando je gaf te specificeren:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Als je `git push --tags` uitvoert, zal de `maintainer-pgp-pub` tag met iedereen gedeeld worden. Als iemand een tag wil verifiëren, dan kunnen ze jouw PGP sleutel direct importeren door de blob direct uit de database te halen en het in GPG te importeren:

	$ git show maintainer-pgp-pub | gpg --import

Ze kunnen die sleutel gebruiken om al je gesigneerde tags te verifiëren. Als je instructies in het tag bericht zet, dan zal `git show <tag>` je eindgebruikers meer specifieke instructies geven over tag verificatie.

### Een bouw nummer genereren ###

Omdat Git geen monotoon oplopende nummers heeft zoals 'v123' of iets gelijkwaardigs om bij iedere commit mee te worden genomen, en je een voor mensen leesbare naam wilt hebben bij een commit, kan je `git describe` uitvoeren op die commit. Git geeft je de naam van de dichtstbijzijnde tag met het aantal commits achter die tag en een gedeeltelijke SHA-1 waarde van de commit die je omschrijft:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

Op deze manier kun je een snapshot of "build" exporteren en het vernoemen naar iets dat begrijpelijk is voor mensen. Sterker nog: als je Git, gecloned van het Git repository, vanaf broncode gebouwd hebt geeft `git --version` je iets dat er zo uitziet. Als je een commit omschrijft die je direct getagged hebt, dan krijg je de tag naam.

Het `git describe` commando geeft beschreven tags de voorkeur (tags gemaakt met de `-a` of `-s` vlag), dus release tags moeten op deze manier aangemaakt worden als je `git describe` gebruikt, om er zeker van te zijn dat de commit juist benoemd wordt als het omschreven wordt. Je kunt deze tekst ook gebruiken als het doel van een checkout of show commando, alhoewel het afhankelijk is van de verkorte SHA-1 waarde aan het einde, dus het zou niet eeuwig geldig kunnen zijn. Bijvoorbeeld, de Linux kernel sprong recentelijk van 8 naar 10 karakters om er zeker van de zijn dat de SHA-1 uniek zijn, oudere `git describe` commando uitvoernamen werden daardoor ongeldig.

### Een release voorbereiden ###

Nu wil je een build vrijgeven. Een van de dingen die je wilt doen is een archief maken van de laatste snapshot van je code voor de arme stumperds die geen Git gebruiken. Het commando om dit te doen is `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

Als iemand die tarball opent, dan krijgen ze de laatste snapshot van je project onder een project directory. Je kunt op vrijwel dezelfde manier ook een zip archief maken, maar dan door de `format=zip` optie mee te geven aan `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Je hebt nu een mooie tarball en een zip archief van je project release, die je kunt uploaden naar je website of naar mensen kunt e-mailen.

### De shortlog ###

De tijd is gekomen om de maillijst met mensen die willen weten wat er gebeurt in je project te mailen. Een prettige manier om een soort van wijzigingsverslag te krijgen van wat er is toegevoegd in je project sinds je laatste release of e-mail is om het `git shortlog` commando te gebruiken. Het vat alle commits samen binnen de grenswaarden die je het geeft. Bijvoorbeeld het volgende geeft je een samenvatting van alle commits sinds je vorige release, als je laatste release v1.0.1 heette:

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

Je krijgt een opgeschoonde samenvatting van alle commits sinds v1.0.1, gegroepeerd op auteur, die je naar de lijst kunt e-mailen.

## Samenvatting ##

Je zou je nu redelijk op je gemak moeten voelen om aan een project bij te dragen met Git, maar ook om je eigen project te beheren of de bijdragen van andere gebruikers te integreren. Gefeliciteerd, je bent nu een effectieve Git ontwikkelaar! In het volgende hoofdstuk vindt je nog krachtigere tools en tips om met complexe situaties om te gaan, waarmee je een echte Git meester zullen worden.
