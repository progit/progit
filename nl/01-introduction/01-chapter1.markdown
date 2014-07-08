<!-- Attentie heren en dames vertalers.
Ik zou het volgende willen voorstellen:
Er zijn bepaalde termen die voor de gemiddelde Nederlandse computer gebruiker 
veel beter klinken (of bekender voorkomen) dan de orginele Engelse term. In het
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
# Aan de slag #

In dit hoofdstuk wordt uitgelegd hoe je aan de slag kunt gaan met Git. We zullen beginnen met wat achtergrondinformatie over versiebeheersystemen te geven, daarna een korte uitleg hoe je Git werkend kan krijgen op je computer en sluiten af door uit te leggen hoe je Git kan instellen zodat je ermee aan het werk kunt.  Aan het einde van dit hoofdstuk zou je moeten kunnen begrijpen waarom Git er is, waarom je het zou moeten gebruiken en zal je helemaal klaar zijn om er mee aan de slag te gaan.

## Het wat en waarom van versiebeheer ##

Wat is versiebeheer, en wat heeft dat met jou te maken? Versiebeheer is het systeem waarbij veranderingen in een bestand of groep van bestanden over de tijd wordt bijgehouden, zodat je later specifieke versies kan opvragen. In de voorbeelden in dit boek is het broncode van computersoftware waarvan de versies beheerd worden maar in principe kan elk soort bestand op een computer aan versiebeheer worden onderworpen.

Als je een grafisch ontwerper bent of websites ontwerpt en elke versie van een afbeelding of opmaak wilt bewaren (wat je vrijwel zeker zult willen), is het verstandig een versiebeheersysteem (Version Control System in het Engels, afgekort tot VCS) te gebruiken. Als je dat gebruikt kan je eerdere versies van bestanden of het hele project terughalen, wijzigingen tussen twee momententen in tijd bekijken, zien wie het laatst iets aangepast heeft wat een probleem zou kunnen veroorzaken, wie een probleem heeft veroorzaakt en wanneer en nog veel meer. Een VCS gebruiken betekent meestal ook dat je de situatie gemakkelijk terug kan draaien als je een fout maakt of bestanden kwijtraakt. Daarbij komt nog dat dit allemaal heel weinig extra belasting met zich mee brengt.

### Lokale versiebeheersystemen ###

Veel mensen hebben hun eigen versiebeheer methode: ze kopiëren bestanden naar een andere map (en als ze slim zijn, geven ze die map ook een datum). Deze methode wordt veel gebruikt omdat het zo simpel is, maar het is ook ongelofelijk foutgevoelig. Het is makkelijk te vergeten in welke map je zit en naar het verkeerde bestand te schrijven, of onbedoeld over bestanden heen te kopiëren.

Om met dit probleem om te gaan hebben programmeurs lang geleden lokale VCSen ontwikkeld die een simpele database gebruikten om alle veranderingen aan bestanden te beheren (zie Figuur 1-1).

Insert 18333fig0101.png
Figuur 1-1. Een diagram van een lokaal versiebeheersysteem.

Een populair gereedschap voor VCS was een systeem genaamd rcs, wat vandaag de dag nog steeds met veel computers wordt meegeleverd. Zelfs het populaire besturingssysteem Mac OS X heeft rcs als je de Developer Tools installeert. Dit gereedschap werkt in principe door verzamelingen van ‘patches’ (de verschillen tussen bestanden) van de opvolgende bestandsversies in een speciaal formaat op de harde schijf op te slaan. Zo kan je een bestand reproduceren zoals deze er uitzag op enig moment in tijd door alle patches bij elkaar op te tellen.

### Gecentraliseerde versiebeheersystemen ###

De volgende belangrijke uitdaging waar mensen tegenaan lopen is dat ze samen moeten werken met ontwikkelaars op andere computers. Om deze uitdaging aan te gaan ontwikkelde men Gecentraliseerde Versiebeheersystemen (Centralized Version Control Systems, afgekort CVCSs). Deze systemen, zoals CVS, Subversion en Perforce, hebben één centrale server waarop alle versies van de bestanden staan en een aantal clients die de bestanden daar van ophalen (‘check out’). Vele jaren was dit de standaard voor versiebeheer (zie Figuur 1-2).

Insert 18333fig0102.png
Figuur 1-2. Een diagram van een gecentraliseerd versiebeheersysteem.

Deze manier van versiebeheer biedt veel voordelen, zeker ten opzichte van lokale VCSen. Bijvoorbeeld weet iedereen, tot op zekere hoogte, wat de overige project-medewerkers aan het doen zijn. Beheerders hebben een hoge mate van controle over wie wat kan doen, en het is veel eenvoudiger om een CVCS te beheren dan te moeten werken met lokale databases op elke client.

Maar helaas, deze methode heeft ook behoorlijke nadelen. De duidelijkste is de ‘single point of failure’: als de centrale server plat gaat en een uur later weer terug online komt kan niemand in dat uur samenwerken of versies bewaren van de dingen waar ze aan werken. Als de harde schrijf waar de centrale database op staat corrupt raakt en er geen backups van zijn verlies je echt alles; de hele geschiedenis van het project, behalve de momentopnames die mensen op hun eigen computers hebben staan. Lokale VCSen hebben hetzelfde probleem: als je de hele geschiedenis van het project op één enkele plaats bewaart, loop je ook kans alles te verliezen.

### Gedistribueerde versiebeheersystemen ###

En hier verschijnen Gedistribueerde versiebeheersystemen (Distributed Version Control Systems, DVCSs) ten tonele. In een DVCS (zoals Git, Mercurial, Bazaar en Darcs) downloaden clients niet simpelweg de laatste momentopnames van de bestanden: de hele opslagplaats (de ‘repository’) wordt gekopiëerd. Dus als een server neergaat en deze systemen werkten via die server samen dan kan de repository van elke willekeurige client terug worden gekopiëerd naar de server om deze te herstellen. Elke checkout is dus in feite een complete backup van alle data (zie Figuur 1-3).

Insert 18333fig0103.png
Figuur 1-3. Diagram van een gedistribueerd versiebeheersysteem

Bovendien kunnen veel van deze systemen behoorlijk goed omgaan met meerdere (niet-lokale) repositories tegelijk, zodat je met verschillende groepen mensen op verschillende manieren tegelijk aan hetzelfde project kan werken. Hierdoor kan je verschillende werkprocessen (‘workflows’) opzetten die niet mogelijk waren geweest met gecentraliseerde systemen zoals hiërarchische modellen.

## Een kort historisch overzicht van Git ##

Zoals zoveel goede dingen in het leven begon Git met een beetje creatieve destructie en een hoogoplopende controverse. De Linux kernel is een open source softwareproject met een behoorlijk grote omvang. Voor een lange tijd tijdens het onderhoud van de Linux kernel (1991–2002), werden aanpassingen aan de software voornamelijk verspreid via patches en gearchiveerde bestanden. In 2002 begon het project een gesloten DVCS genaamd BitKeeper te gebruiken.

In 2005 viel de relatie tussen de gemeenschap die de Linux kernel ontwikkelde en het commerciële bedrijf dat BitKeeper maakte uiteen, en het programma mocht niet langer meer gratis worden gebruikt. Dit was de aanleiding voor de gemeenschap (en Linus Torvalds, de maker van Linux, in het bijzonder) om hun eigen gereedschap te ontwikkelen, gebaseerd op de ervaring die opgedaan was toen ze nog BitKeeper gebruikten. Een paar van de doelen die ze hadden voor het nieuwe systeem waren als volgt:

*	Snelheid
*	Eenvoudig ontwerp
*	Goede ondersteuning voor niet-lineaire ontwikkeling (duizenden parallelle takken (branches) )
*	Volledig gedistribueerd
*	In staat om efficiënt om te gaan met grote projecten als de Linux kernel (voor wat betreft snelheid maar ook opslagruimte)

Sinds het ontstaan in 2005 is Git gegroeid tot zijn huidige vorm: het is eenvoudig te gebruiken en heeft toch die oorspronkelijke eigenschappen behouden. Het is ongelofelijk snel, enorm efficiënt met grote projecten en een ongeëvenaard systeem van branches voor het ondersteunen van niet-lineaire ontwikkeling (zie Hoofdstuk 3).

## De basis van Git ##

Dus, wat is Git in een notendop? Dit is een belangrijke paragraaf om in je op te nemen, omdat, als je goed begrijpt wat Git is en de fundamenten van de interne werking begrijpt, het waarschijnlijk een stuk makkelijker wordt om Git effectief te gebruiken. Probeer, als je Git aan het leren bent, te vergeten wat je al weet over andere VCSen zoals Subversion en Perforce; zo kan je verwarring bij gebruik door de subtiele verschillen voorkomen. Git gaat op een hele andere manier met informatie om dan die andere systemen, ook al lijken de verschillende commando’s behoorlijk op elkaar. Als je die verschillen begrijpt, kan je voorkomen dat je verward raakt als je Git gebruikt.

### Momentopnames in plaats van verschillen ###

Een groot verschil tussen Git en elke andere VCS (inclusief Subversion en consorten) is hoe Git denkt over zijn data. Conceptueel bewaren de meeste andere systemen informatie als een lijst van veranderingen per bestand. Deze systemen (CVS, Subversion, Perforce, Bazaar, enzovoort) zien de informatie die ze bewaren als een aantal bestanden en de veranderingen die aan die bestanden zijn aangebracht over de tijd, zoals geïllustreerd in Figuur 1-4.

Insert 18333fig0104.png
Figuur 1-4. Andere systemen bewaren data meestal als veranderingen aan een basisversie van elk bestand.

Git ziet en bewaart zijn data heel anders. De kijk van Git op zijn data kan worden uitgelegd als een reeks momentopnames (snapshots) van een miniatuurbestandssysteem. Elke keer dat je ‘commit’ (de status van je project in Git opslaat) neemt het een soort van foto van hoe al je bestanden er op dat moment uitzien en slaat een verwijzing naar die foto op. Voor efficiëntie slaat Git ongewijzigde bestanden niet elke keer opnieuw op, alleen een verwijzing naar het eerdere identieke bestand dat het eerder al opgeslagen had. In Figuur 1-5 kan je zie hoe Git ongeveer over zijn data denkt.

Insert 18333fig0105.png
Figuur 1-5. Git bewaart data als momentopnames van het project.

Dat is een belangrijk onderscheid tussen Git en bijna alle overige VCSen. Hierdoor moet Git bijna elk aspect van versiebeheer heroverwegen, terwijl de meeste andere systemen het hebben overgenomen van voorgaande generaties. Dit maakt Git meer een soort mini-bestandssysteem met een paar ongelooflijk krachtige gereedschappen, in plaats van niets meer of minder dan een VCS. We zullen een paar van de voordelen die je krijgt als je op die manier over data denkt gaan onderzoeken, als we ‘branching’ (gesplitste ontwikkeling) toelichten in Hoofdstuk 3.

### Bijna alles is lokaal ###

De meeste handelingen in Git hebben alleen lokale bestanden en hulpmiddelen nodig. Normaalgesproken is geen informatie nodig van een andere computer in je netwerk. Als je gewend bent aan een CVCS, waar de meeste handelingen vertraagd worden door het netwerk, lijkt Git door de goden van snelheid begenadigd met onwereldse krachten. Omdat je de hele geschiedenis van het project op je lokale harde schijf hebt staan, lijken de meeste acties geen tijd in beslag te nemen.

Een voorbeeld: om de geschiedenis van je project te doorlopen hoeft Git niet bij een of andere server de geschiedenis van je project op te vragen; het leest simpelweg jouw lokale database. Dat betekent dat je de geschiedenis van het project bijna direct te zien krijgt. Als je de veranderingen wilt zien tussen de huidige versie van een bestand en de versie van een maand geleden kan Git het bestand van een maand geleden opzoeken en lokaal de verschillen berekenen, in plaats van aan een niet-lokale server te moeten vragen om het te doen, of de oudere versie van het bestand ophalen van een server om het vervolgens lokaal te doen.

Dit betekent dat er maar heel weinig is dat je niet kunt doen als je offline bent of zonder VPN zit. Als je in een vliegtuig of trein zit en je wilt nog even wat werken, kan je vrolijk doorgaan met commits maken tot je een netwerkverbinding hebt zodat je dat werk kunt uploaden. Als je naar huis gaat en je VPN client niet aan de praat krijgt kan je nog steeds doorwerken. Bij veel andere systemen is dat onmogelijk of zeer onaangenaam. Als je bijvoorbeeld Perforce gebruikt kun je niet zo veel doen als je niet verbonden bent met de server. Met Subversion en CVS kun je bestanden bewerken maar je kunt geen commits maken naar je database (omdat die offline is). Dat lijkt misschien niet zo belangrijk maar je zult nog versteld staan wat een verschil het kan maken.

### Git heeft integriteit ###

Alles in Git krijgt een controlegetal (‘checksum’) voordat het wordt opgeslagen en er wordt later met dat controlegetal ernaar gerefereerd. Dat betekent dat het onmogelijk is om de inhoud van een bestand of map te veranderen zonder dat Git er weet van heeft. Deze functionaliteit is in het diepste deel van Git ingebouwd en staat centraal in zijn filosofie. Je kunt geen informatie kwijtraken als het wordt verstuurd en bestanden kunnen niet corrupt raken zonder dat Git het kan opmerken.

Het mechanisme dat Git gebruikt voor deze controlegetallen heet een SHA-1-hash. Dat is een tekenreeks van 40 karakters lang, bestaande uit hexadecimale tekens (0–9 en a–f) en wordt berekend uit de inhoud van een bestand of directory-structuur in Git. Een SHA-1-hash ziet er ongeveer zo uit:

	24b9da6552252987aa493b52f8696cd6d3b00373

Je zult deze hashwaarden overal tegenkomen omdat Git er zoveel gebruik van maakt. Sterker nog, Git bewaart alles niet onder een bestandsnaam maar in de database van Git met de hash van de inhoud als sleutel.

### Git voegt normaal gesproken alleen data toe ###

Bijna alles wat je in Git doet, leidt tot toevoeging van data in de Git database. Het is erg moeilijk om het systeem iets te laten doen wat je niet ongedaan kan maken of het de gegevens te laten wissen op wat voor manier dan ook. Zoals met elke VCS kun je veranderingen verliezen of verhaspelen als je deze nog niet hebt gecommit; maar als je dat eenmaal hebt gedaan, is het erg moeilijk om die data te verliezen, zeker als je de lokale database regelmatig uploadt (‘push’) naar een andere repository.

Dit maakt het gebruik van Git zo plezierig omdat je weet dat je kunt experimenteren zonder het gevaar te lopen jezelf behoorlijk in de nesten te werken. Zie Hoofdstuk 9 voor een iets diepgaandere uitleg over hoe Git zijn data bewaart en hoe je de data die verloren lijkt kunt terughalen.

### De drie toestanden ###

Let nu goed op. Dit is het belangrijkste dat je over Git moet weten als je wilt dat de rest van het leerproces gladjes verloopt. Git heeft drie hoofdtoestanden waarin bestanden zich kunnen bevinden: gecommit (‘commited’), aangepast (‘modified’) en voorbereid voor een commit (‘staged’). Committed houdt in dat alle data veilig opgeslagen is in je lokale database. Modified betekent dat je het bestand hebt gewijzigd maar dat je nog niet naar je database gecommit hebt. Staged betekent dat je al hebt aangegeven dat de huidige versie van het aangepaste bestand in je volgende commit meegenomen moet worden.

Dit brengt ons tot de drie hoofdonderdelen van een Gitproject: de Git directory, de werk-directory, en de wachtrij voor een commit (‘staging area’)

Insert 18333fig0106.png 
Figuur 1-6. Werk-directory, wachtrij en Git directory

De Git directory is waar Git de metadata en objectdatabase van je project opslaat. Dit is het belangrijkste deel van Git. Deze directory wordt gekopiëerd wanneer je een repository kloont vanaf een andere computer.

De werk directory is een checkout van een bepaalde versie van het project. Deze bestanden worden uit de gecomprimeerde database in de Git directory gehaald en op de harde schijf geplaatst waar jij ze kunt gebruiken of bewerken.

De wachtrij is een simpel bestand, dat zich normaalgesproken in je Git directory bevindt, waar informatie opgeslagen wordt over wat in de volgende commit meegaat. Het wordt soms de index genoemd, maar tegenwoordig wordt het de staging area genoemd.

De algemene workflow met Git gaat ongeveer zo:

1. Je bewerkt bestanden in je werk directory.
2. Je bereidt de bestanden voor (staged), waardoor momentopnames (snapshots) worden toegevoegd aan de staging area.
3. Je maakt een commit. Een commit neemt alle snapshots van de staging area en bewaart die voorgoed in je Git directory.

Als een bepaalde versie van een bestand in de Git directory staat, wordt het beschouwd als gecommit. Als het is aangepast, maar wel aan de staging area is toegevoegd, is het staged. En als het veranderd is sinds het was uitgechecked maar niet staged is, is het aangepast. In Hoofdstuk 2 leer je meer over deze toestanden en hoe je er je voordeel mee kunt doen, maar ook hoe je de staging area compleet over kunt slaan.

## Git installeren ##

Laten we Git eens beginnen te gebruiken. Je kunt natuurlijk niet meteen beginnen, je moet het eerst installeren. Er zijn een aantal manieren om eraan te komen; de belangrijkste twee zijn installeren vanaf broncode of een bestaand pakket voor jouw platform gebruiken.

### Installeren vanaf de broncode ###

Als het mogelijk is, is het meestal nuttig om Git vanaf de broncode te installeren, omdat je dan de meest recente versie krijgt. Elke versie van Git brengt meestal nuttige verbeteringen aan de gebruikersinterface met zich mee, dus de laatste versie is vaak de beste manier als je het gewend bent software vanaf de broncode te compileren. Vaak hebben Linuxdistributies behoorlijk oude pakketen, dus tenzij je een hele up-to-date distro hebt of ‘backports’ (verbeteringen van een nieuwe versie op een oudere versie toepassen) gebruikt, is installeren vanaf broncode misschien wel het beste voor je.

Om Git te installeren heb je een aantal bibliotheken (‘libraries’) nodig waar Git van afhankelijk is: curl, zlib, openssl, expat, en libiconv. Als je bijvoorbeeld op een systeem werkt dat yum heeft (zoals Fedora) of apt-get (zoals systemen gebaseerd op Debian), kun je één van de volgende commando's gebruiken om alle bibliotheken waar Git van afhankelijk is te installeren:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev

Als je alle benodigde afhankelijkheden hebt, kun je de laatste snapshot van Git vanaf de officiële website downloaden:

	http://git-scm.com/download

Daarna compileren en installeren:

	$ tar -zxf git-1.7.10.4.tar.gz
	$ cd git-1.7.10.4
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Als dat allemaal klaar is, kun je de ook nieuwste versie van Git met Git ophalen met dit commando:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Op Linux installeren ###

Als je direct de uitvoerbare bestanden van Git op Linux wilt installeren, kun je dat over het algemeen doen via het standaard pakketbeheersysteem dat meegeleverd is met je distributie. Als je Fedora gebruikt kun je yum gebruiken:

	$ yum install git-core

Of als je een distributie hebt die op Debian gebaseerd is, zoals Ubuntu, kun je apt-get proberen:

	$ apt-get install git

### Op een Mac installeren ###

Er zijn twee makkelijke manieren om Git op een Mac te installeren. De simpelste is om het grafische Git installatieprogramma te gebruiken, dat je van de volgende pagina op SourceForge kunt downloaden (zie Figuur 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png
Figuur 1-7. Gitinstallatieprogramma voor OS X.

De andere veelgebruikte manier is om Git via MacPorts (`http://www.macports.org`) te installeren. Als je MacPorts geïnstalleerd hebt, kun je Git installeren met

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Je hoeft niet alle extra’s toe te voegen, maar je wilt waarschijnlijk +svn erbij hebben voor het geval je ooit Git moet gebruiken met Subversion repositories (zie Hoofdstuk 8).

### Op Windows installeren ###

Git op Windows installeren is erg eenvoudig. Het msysGit project heeft één van de eenvoudigere installatieprocedures. Je hoeft alleen maar het installatieprogramma te downloaden van GitHub, en het uit te voeren:

	http://msysgit.github.com/

Nadat het geïnstalleerd is, kun je Git zowel vanaf de commando-regel gebruiken (waar ook een SSH client bijzit die later nog van pas zal komen) als via de standaard GUI.

Opmerking voor Windows gebruikers: je zou Git moeten gebruiken met de meegeleverde msysGit shell (Unix stijl), dit staat je toe de complexe commando's gegeven in dit boek te gebruiken. Als je om een of andere reden de Windows shell / commando-regel moet gebruiken, moet je dubbele quotes gebruiken in plaats van enkele quotes (voor parameters met spaties ertussen) en je moet quotes gebruiken bij parameters die eindigen met een circumflex (^) als ze als laatste op de regel staan, omdat dit een voortzettingssymbool is in Windows.

## Git klaarmaken voor eerste gebruik ##

Nu je Git op je computer hebt staan, is het handig dat je een paar dingen doet om je Gitomgeving aan je voorkeuren aan te passen. Je hoeft deze instellingen normaliter maar één keer te doen, ze blijven hetzelfde als je een nieuwe versie van Git installeert. Je kunt ze ook op elk moment weer veranderen door de commando’s opnieuw uit te voeren.

Git bevat standaard een stuk gereedschap genaamd `git config`, waarmee je de configuratie-eigenschappen kunt bekijken en veranderen, die alle aspecten van het uiterlijk en gedrag van Git regelen. Deze eigenschappen kunnen op drie verschillende plaatsen worden bewaard:

*	Het bestand `/etc/gitconfig`: Bevat eigenschappen voor elk account op de computer en al hun repositories. Als je de optie `--system` meegeeft aan `git config`, zal het de configuratiegegevens in dit bestand lezen en schrijven.
*	Het bestand `~/.gitconfig`: Eigenschappen voor jouw account. Je kunt Git dit bestand laten lezen en schrijven door de optie `--global` mee te geven.
*	Het configuratiebestand in de Gitdirectory (dus `.git/config`) van de repository die je op het moment gebruikt: Specifiek voor die ene repository. Elk niveau neemt voorrang boven het voorgaande, dus waarden die in `.git/config` zijn gebruikt zullen worden gebruikt in plaats van die in `/etc/gitconfig`.

Op systemen met Windows zoekt Git naar het `.gitconfig`-bestand in de `$HOME` directory (`%USERPROFILE%` in een Windows omgeving) wat zich vertaalt in `C:\Documents and Settings\$USER` of `C:\Users\$USER` voor de meesten, afhankelijk van de versie (`$USER` is `%USERNAME%` in Windows omgevingen). Het zoekt ook nog steeds naar `/etc/gitconfig`, maar dan gerelateerd aan de plek waar je MSys hebt staan, en dat is de plek is waar je Git op je Windowscomputer geïnstalleerd hebt.

### Jouw identiteit ###

Het eerste wat je zou moeten doen nadat je Git geïnstalleerd hebt, is je gebruikersnaam en e-mail adres opgeven. Dat is belangrijk omdat elke commit in Git deze informatie gebruikt, en het onveranderlijk ingebed zit in de commits die je ronddeelt:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Nogmaals, dit hoef je maar één keer te doen als je de `--global` optie erbij opgeeft, omdat Git die informatie zal gebruiken voor alles wat je doet op dat systeem. Als je een andere naam of e-mail wilt gebruiken voor specifieke projecten, kun je het commando uitvoeren zonder de `--global` optie als je in de directory van dat project zit.

### Je tekstverwerker ###

Nu Git weet wie je bent, kun je de standaard tekstverwerker instellen die gebruikt zal worden als Git je een bericht in wil laten typen. Normaliter gebruikt Git de standaardtekstverwerker van je systeem, wat meestal Vi of Vim is. Als je een andere tekstverwerker wilt gebruiken, zoals Emacs, kun je het volgende doen:

	$ git config --global core.editor emacs

### Je diffprogramma ###

Een andere nuttige optie die je misschien wel wilt instellen is het standaard diffprogramma om mergeconflicten op te lossen. Stel dat je vimdiff wilt gebruiken:

	$ git config --global merge.tool vimdiff

Git accepteert kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge en opendiff als geldige merge tools. Je kunt ook een ander programma gebruiken, zie Hoofdstuk 7 voor meer informatie daarover.

### Je instellingen controleren ###

Als je je instellingen wilt controleren, kan je het `git config --list` commando gebruiken voor een lijst met alle instellingen die Git vanaf die locatie kan vinden:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Je zult sommige sleutels misschien meerdere keren langs zien komen, omdat Git dezelfde sleutel uit verschillende bestanden heeft gelezen (bijvoorbeeld `/etc/gitconfig` en `~/.gitconfig`). In dit geval gebruikt Git de laatste waarde van elke unieke sleutel die het tegenkomt.

Je kan ook bekijken wat Git als instelling heeft bij een specifieke sleutel door `git config {sleutel}` in te voeren:

	$ git config user.name
	Scott Chacon

## Hulp krijgen ##

Als je ooit hulp nodig hebt terwijl je Git gebruikt, zijn er drie manieren om de gebruiksaanwijzing (manpage) voor elk Git commando te krijgen:

	$ git help <actie>
	$ git <actie> --help
	$ man git-<actie>

Bijvoorbeeld, je kunt de gebruikershandleiding voor het config commando krijgen door het volgende te typen:

	$ git help config

Deze commando's zijn prettig omdat je ze overal kunt opvragen, zelfs als je offline bent.
Als de manpage en dit boek niet genoeg zijn en je persoonlijke hulp nodig hebt, kan je de kanalen `#git` of `#github` (beiden Engelstalig) op het Freenode IRC netwerk (irc.freenode.net) proberen. In deze kanalen zijn regelmatig honderden mensen aangemeld die allemaal zeer ervaren zijn met Git en vaak bereidwillig om te helpen.

## Samenvatting ##

Je zou nu een beetje een idee moeten hebben wat Git is en op welke manieren het verschilt van het versiebeheersysteem dat je misschien eerder gebruikte. Je zou nu ook een werkende versie van Git op je systeem moeten hebben dat is ingesteld met jouw identiteit. Nu is het tijd om een aantal andere grondbeginselen van Git te gaan leren.

