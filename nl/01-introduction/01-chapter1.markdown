# Aan de slag #

Dit hoofdstuk legt uit je hoe je aan de slag kunt gaan met Git.  We zullen bij het begin beginnen: je krijgt een beetje achtergrondinformatie over versiebeheersystemen, daarna een korte uitleg hoe je Git werkend kan krijgen op je computer en hoe je het kan instellen zodat je ermee aan het werk kunt.  Aan het einde van dit hoofdstuk zou je moeten kunnen begrijpen waarom Git er is, waarom je het nodig hebt en zul je helemaal klaar zijn om er mee aan de slag te gaan.

## Het wat en waarom van versiebeheer ##

Wat is versiebeheer? En wat heeft dat met jou te maken? Versiebeheer is een systeem dat veranderingen in een bestand of groep van bestanden over de tijd bijhoudt. Zodat je later specifieke versies kan opvragen. In de voorbeelden in dit boek is het broncode van computersoftware waarvan de versies beheerd worden maar je kan het eigenlijk met zo goed als elk soort bestand op een computer doen.

Als je een grafisch ontwerper bent of websites maakt en elke versie van een afbeelding of opmaak wilt bewaren (wat je zeker zou willen), is het verstandig een versiebeheersysteem (Version Control System in het Engels, afgekort tot VCS) te gebruiken. Als je dat gebruikt kan je eerdere versies van bestanden of hele project terughalen, veranderingen tussen twee momententen in tijd bekijken, zien wie het laatst iets aangepast heeft, wie een probleen heeft veroorzaakt en wanneer en nog veel meer. Een VCS gebruiken betekent meestal ook dat je de situatie gemakkelijk terug kan draaien als je een fout maakt of bestanden kwijtraakt. Daarbij komt nog dat dit allemaal heel weinig extra belasting met zich mee brengt.

### Lokale versiebeheersystemen ###

Veel mensen hebben hun eigen versiebeheer methode: ze kopiëren bestanden naar een andere map (en als ze slim zijn, geven ze die map ook een datum). Deze methode wordt veel gebruikt omdat het zo simpel is, maar het is ook ongelofelijk foutgevoelig. Het is makkelijk te vergeten in welke map je zit en naar het verkeerde bestand te schrijven, of over bestanden heen te kopiëren waar je dat niet wilde.

Om met dit probleem om te gaan hebben programmeurs lang geleden lokale VCSen ontwikkeld die een simpele database hadden om alle veranderingen aan bestanden te beheren (zie Figuur 1-1).

Insert 18333fig0101.png 
Figuur 1-1. Een diagram van een lokaal versiebeheersysteem.

Een populair gereedschap voor VCS was een systeem genaamd rcs, wat vandaag de dag nog steeds met veel computers wordt mee geleverd. Zelfs het populaire besturingssysteem Mac OS X heeft rcs, als je de Developer Tools installeert. Dit gereedschap werkt in principe door verzamelingen van ‘patches’ (de verschillen tussen bestanden) van de opvolgende bestandsversies in een speciaal formaat op de harde schijf op te slaan; zo kan je teruggaan naar hoe een bestand er uitzag op ieder willekeurig moment in tijd, door alle patches bij elkaar op te tellen.

### Gecentraliseerde versiebeheersystemen ###

Het volgende grote probleem waar mensen tegenaan lopen is dat ze samen moeten werken met ontwikkelaars op andere computers. Om dit probleem op te lossen ontwikkelde men Gecentraliseerde Versiebeheersystemen (CVCSen). Deze systemen, zoals CVS, Subversion en Perforce, hebben één centrale server waarop alle versies van de bestanden staan en een aantal clients die de bestanden daar van halen (‘check out’, in het Engels). Vele jaren was dit de standaard voor versiebeheer (zie Figuur 1-2).

Insert 18333fig0102.png 
Figuur 1-2. Een diagram van een gecentraliseerd versiebeheersysteem.

Deze manier van versiebeheer biedt veel voordelen, vooral als je het vergelijkt met lokale VCSen. Bijvoorbeeld, iedereen weet tot op zekere hoogte wat de overige project-medewerkers aan het doen zijn. Beheerders hebben precieze controle over wie wat kan doen; en het is veel eenvoudiger om een CVCS te beheren dan te moeten werken met lokale databases voor elke client.

Maar helaas, deze methode heeft ook behoorlijke nadelen. De duidelijkste is de ‘single point of failure’: als de centrale server plat gaat en een uur later weer terug online komt kan niemand in dat uur samenwerken of versies bewaren van de dingen waar ze aan werken. Als de harde schrijf waar de centrale database op staat corrupt raakt en er geen backups van zijn verlies je echt alles — de hele geschiedenis van het project, behalve de momentopnames die mensen op hun eigen computers hebben staan. Lokale VCSen hebben hetzelfde probleem — als je de hele geschiedenis van het project op één enkele plaats bewaart, loop je ook kans alles te verliezen.

### Gedistribueerde versiebeheersystemen ###

En hier verschijnen Gedistribueerde versiebeheersystemen (DVCSen) ten tonele. In een DVCS (zoals Git, Mercurial, Bazaar en Darcs) downloaden clients niet alleen de laatste momentopnames van de bestanden. De hele geschiedenis (de ‘repository’) wordt gekopiëerd. Dus als een server neergaat en deze systemen werkten via die server samen dan kan de repository van elke willekeurige client terug worden gekopiëerd naar de server om deze te herstellen. Elke checkout is dus eigenlijk een complete backup van alle data (zie Figuur 1-3).

Insert 18333fig0103.png 
Figuur 1-3. Diagram van een gedistribueerd versiebeheersysteem

Bovendien werken veel van deze systemen behoorlijk goed met meerdere (niet-lokale) repositories tegelijk zodat je met verschillende groepen mensen op verschillende manieren tegelijk aan hetzelfde project kan werken. Hierdoor kan je verschillende werkprocessen (‘workflows’) opzetten die niet mogelijk waren geweest met gecentraliseerde systemen zoals hiërarchische modellen. 

## Een kleine geschiedenis van Git ##

Zoals zoveel goede dingen in het leven begon Git met een beetje creatieve destructie en een hoogoplopende controverse. De Linuxkernel is een open source softwareproject met een behoorlijk groot draagvlak. In het kader van het onderhoud van de Linuxkernel (1991–2002), werden aanpassingen aan de software voornamelijk verspreid via patches en gearchiveerde bestanden. In 2002 veranderde dat want vanaf dat jaar begon het project het gesloten DVCS genaamd BitKeeper te gebruiken.

In 2005 viel de relatie tussen de gemeenschap die de Linuxkernel ontwikkelde en het commerciële bedrijf dat BitKeeper maakte uiteen. Het programma kon niet langer meer gratis worden gebruikt. Dit was de aanleiding voor de gemeenschap (en Linus Torvalds, de maker van Linux, in het bijzonder) om hun eigen gereedschap te ontwikkelen. Gebaseerd op de ervaring die opgedaan was toen ze nog BitKeeper gebruikten. Een paar van de doelen die ze hadden voor het nieuwe systeem waren als volgt:

*	Snelheid
*	Eenvoudig ontwerp
*	Goede ondersteuning voor niet-lineaire ontwikkeling (duizenden aparte takken tegelijk)
*	Volledig gedistribueerd
*	In staat om efficiënt om te gaan met grote projecten als de Linuxkernel (voor wat betreft snelheid maar ook opslagruimte)

Sinds het ontstaan in 2005 is Git gegroeid tot zijn huidige vorm: het is eenvoudig te gebruiken en heeft toch die oorspronkelijke eigenschappen behouden. Het is ongelofelijk snel, enorm efficiënt met grote projecten en zijn systeem voor aparte takken (‘branches’) van niet-lineaire ontwikkeling is ongeëvenaard (zie Hoofdstuk 3).

## De basis van Git ##

Dus, wat is Git in een notendop? Dit is een belangrijk deelhoofdstuk, omdat het waarschijnlijk een stuk makkelijker wordt om Git effectief te gebruiken als je goed begrijpt wat Git is en hoe het werkt. Probeer te vergeten wat je al weet over andere VCSen zoals Subversion en Perforce als je Git aan het leren bent; zo kan je verwarring door de subtiele verschillen voorkomen. Git gaat op een hele andere manier met informatie om dan die andere systemen, ook al lijken de verschillende commando’s behoorlijk op elkaar. Als je die verschillen begrijpt, kan je voorkomen dat je verward raakt als je Git gebruikt.

### Momentopnames in plaats van verschillen ###

Een groot verschil tussen Git en elke andere VCS (inclusief Subversion en consoorten) is hoe Git denkt over zijn data. Conceptueel bewaren de meeste andere systemen informatie als een lijst van veranderingen per bestand. Deze systemen (CVS, Subversion, Perforce, Bazaar, enzovoort) zien de informatie die ze bewaren als een aantal bestanden en de veranderingen die aan die bestanden zijn aangebracht over de tijd, zoals geïllustreerd in Figuur 1-4.

Insert 18333fig0104.png 
Figuur 1-4. Andere systemen bewaren data meestal als veranderingen aan een basisversie van elk bestand.

Git ziet en bewaart zijn data heel anders. De kijk van Git op zijn data kan worden uitgelegd als een reeks momentopnames van een miniatuurbestandsysteem. Elke keer dat je ‘commit’ - de status van van je project in Git opslaat - neemt het een soort van foto van hoe al je bestanden er op dat moment uitzien en slaat een verwijzing naar die momentopname op. Voor efficiëntie slaat Git ongewijzigde bestanden niet elke keer opnieuw op — alleen een verwijzing naar het eerdere identieke bestand dat het eerder al opgeslagen had. In Figuur 1-5 kan je zie hoe Git ongeveer over zijn data denkt.

Insert 18333fig0105.png 
Figuur 1-5. Git bewaart data als momentopnames van het project.

Dat is een belangrijk verschil tussen Git en bijna alle overige VCSen. Hierdoor vindt Git bijna elk onderdeel van versiebeheer opnieuw uit, terwijl de meeste andere systemen het allemaal gewoon overnemen van de eerdere generaties. Hierdoor is Git meer een soort miniatuurbestandssysteem met een paar ongelooflijk krachtige gereedschappen, in plaats van niets meer dan een VCS. We zullen een paar van de voordelen die je krijgt als je op die manier over data denkt gaan onderzoeken, als we ‘branching’ (gesplitste ontwikkeling) toelichten in Hoofdstuk 3.

### Bijna alles is lokaal ###

De meeste handelingen in Git werken alleen op lokale bestanden en bronnen. Normaal gesproken is geen informatie nodig van een andere computer in je netwerk. Als je gewoon bent aan een CVCS, waar de meeste handelingen vertraagd worden door het netwerk, lijkt Git een geschenk van de snelheidsgoden. Omdat je de hele geschiedenis van het project op je lokale harde schijf hebt staan, lijken de meeste acties geen tijd in beslag te nemen.

Een voorbeeld: Git hoeft niet aan een of andere server de geschiedenis van je project te vragen als je de die wilt doorbladeren – het leest simpelweg jouw lokale database. Dat betekent dat je de geschiedenis bijna direct te zien krijgt. Als je de veranderingen wilt zien tussen de huidige versie van een bestand en de versie van een maand geleden kan Git het bestand van een maand geleden opzoeken, en de lokale verschillen berekenen, in plaats van aan een niet-lokale server te moeten vragen om het te doen, of de oudere versie van het bestand ophalen om het lokaal te doen.

Dit betekent dat er maar heel weinig is dat je niet kunt doen als je offline bent of zonder VPN zit. Als je in een vliegtuig of trein zit, en je wilt nog even een beetje werken, kun je vrolijk doorgaan met commits maken tot je een netwerkverbinding krijgt, zodat je je werk kunt uploaden. Als je naar huis gaat en je VPN client niet aan de praat kunt krijgen dan kun je nog steeds doorwerken. Bij veel andere systemen is dat of onmogelijk of zeer onaangenaam. Als je bijvoorbeeld Perforce gebruikt kun je niet zo veel doen als je niet verbonden bent met de server. Met Subversion en CVS kun je bestanden bewerken maar je kunt geen commits maken voor je database (omdat die offline is). Dat lijkt misschien niet zo belangrijk maar je zult nog versteld staan wat een verschil het kan maken.

### Git is integer ###

Git maakt een controlegetal (‘checksum’) van alles voordat het wordt opgeslagen en er wordt later naar die data verwezen met dit controlegetal. Dat betekent dat het onmogelijk is om de inhoud van een bestand of map te veranderen zonder dat Git er vanaf weet. Deze functionaliteit is ingebouwd in het diepste deel van Git en staat centraal in zijn filosofie. Je kunt geen informatie kwijtraken als het wordt verstuurd en bestanden kunnen niet corrupt raken zonder dat Git het weet.

Het mechanisme dat Git gebruikt voor deze controlegetallen heet een SHA-1-hash. Dat is een tekenreeks van 40 karakters lang, bestaande uit hexadecimale tekens (0–9 en a–f) en wordt berekend uit de inhoud van een bestand of mapstructuur in Git. Een SHA-1-hash ziet er ongeveer zo uit:

	24b9da6552252987aa493b52f8696cd6d3b00373

Je zult deze hashtekenreeksen overal tegenkomen omdat Git er zoveel gebruik van maakt. Sterker nog, Git bewaart data niet onder hun bestandsnaam maar in de database van Git onder de hash van de inhoud.

### Git voegt normaal gesproken alleen data toe ###

Wanneer je iets doet in Git is de kans groot dat het alleen maar data aan de database van Git toevoegt. Het is erg moeilijk om het systeem iets te laten doen dat je niet ongedaan kan maken of de data uit te laten wissen op wat voor manier dan ook. Zoals met elke VCS kun je veranderingen verliezen of verhaspelen waar je nog geen momentopname van hebt gemaakt; maar als je dat eenmaal hebt gedaan, is het erg moeilijk om die data te verliezen, zeker als je je lokale database regelmatig uploadt (‘push’) naar een andere repository.

Je zult nog veel plezier van Git hebben omdat je weet dat je kunt experimenteren zonder het gevaar te lopen jezelf behoorlijk in de nesten te werken. Zie Hoofdstuk 9 voor een iets diepgaandere uitleg over hoe Git zijn data bewaart en hoe je de data die verloren lijkt kunt terughalen.

### De drie toestanden ###

Let nu goed op. Dit is het belangrijkste dat je over Git moet weten als je wilt dat de rest van het leerproces goed verloopt. Git heeft drie hoofdtoestanden waarin je bestanden zich kunnen bevinden: gecommit (‘commited’), aangepast (‘modified’) en voorbereid voor een commit (‘staged’). Gecommit betekent dat alle data al veilig opgeslagen is in je lokale database. Aangepast betekent dat je je bestand hebt veranderd maar dat je nog geen nieuwe momentopname in je database hebt. Voorbereid betekent dat je al hebt aangegeven dat je de huidige versie van het aangepaste bestand in je volgende momentopname toevoegt.

Dit brengt ons tot de drie hoofdonderdelen van een Gitproject: de Gitmap, de werkmap, en de wachtrij voor een commit (‘staging area’)

Insert 18333fig0106.png 
Figuur 1-6. Werkmap, wachtrij en Gitmap

De Gitmap is waar Git de metadata en objectdatabase van je project opslaat. Dit is het belangrijkste deel van Git. Deze map wordt gekopiëerd wanneer je een repository kloont vanaf een andere computer.

De werkmap is een kopie van een bepaalde versie van het project (een ‘checkout’). Deze bestanden worden uit de gecomprimeerde database in de Gitmap gehaald en op de harde schijf geplaatst waar jij ze kunt gebruiken of bewerken.

De wachtrij is een simpel bestand, dat zich in het algemeen in je Gitmap bevindt, waar informatie opgeslagen wordt over wat in de volgende commit meegaat. Het wordt soms de index genoemd, maar tegenwoordig wordt het de wachtrij (staging area) genoemd.

De algemene manier van werken met Git gaat ongeveer zo:

1.	Je bewerkt bestanden in je werkmap.
2.	Je bereidt de bestanden voor, waardoor momentopnames worden toegevoegd aan de wachtrij.
3.	Je maakt een commit. Een commit neemt alle momentopnames van de wachtrij en die permanent bewaard in je Gitmap.

Als een bepaalde versie van een bestand in de Gitmap staat, wordt het beschouwd als gecommit. Als het is aangepast, maar wel aan de wachtrij is toegevoegd, is het voorbereid. En als het veranderd is sinds het gekopiëerd werd, maar niet voorbereid is, is het aangepast. In Hoofdstuk 2 leer je meer over deze toestanden en hoe je er voordeel van kunt hebben, maar ook hoe je de wachtrij compleet over kunt slaan.

## Git installeren ##

Laten we eens een beetje Git gebruiken. Je kunt natuurlijk niet meteen beginnen — je moet het eerst installeren. Er zijn een aantal manieren om eraan te komen; de belangrijkste twee zijn installeren vanaf broncode of een bestaand pakket voor jouw platform gebruiken.

### Installeren vanaf de bron ###

Als het mogelijk is, is het meestal handig om Git vanaf de broncode te installeren, omdat je dan altijd de nieuwste versie hebt. Elke versie van Git brengt meestal goede verbeteringen aan de gebruikersinterface met zich mee, dus de laatste versie is vaak de beste manier als je het gewoon bent software vanaf de broncode te compileren. Vaak hebben Linuxdistributies behoorlijk oude pakketen - tenzij je een hele up-to-date distro hebt of ‘backports’ (verbeteringen van een nieuwe versie op een oudere versie toepassen) gebruikt - is installeren vanaf broncode misschien wel de beste manier voor jou.

Om Git te installeren heb je een aantal bibliotheken (‘libraries’) nodig: curl, zlib, openssl, expat, en libiconv. Als je bijvoorbeeld op een systeem werkt dat yum heeft (zoals Fedora) of apt-get (zoals systemen gebaseerd op Debian), kun je één van de volgende commando's gebruiken om alle bibliotheken waar Git van afhangt te installeren:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
Als je alle afhankelijkheden hebt, kun je de laatste momentopname van Git vanaf de officiële website downloaden:

	http://git-scm.com/download
	
Daarna compileren en installeren:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Als dat allemaal klaar is, kun je de nieuwste versie van Git uit Git ophalen met dit commando:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Op Linux installeren ###

Als je direct de uitvoerbare bestanden van Git op Linux wilt installeren, kun je dat normaal doen via het standaard pakketbeheersysteem dat meegeleverd is met je distributie. Als je Fedora gebruikt kun je yum gebruiken:

	$ yum install git-core

Of als je een distributie hebt die op Debian gebaseerd is, zoals Ubuntu, kun je apt-get proberen:

	$ apt-get install git-core

### Op een Mac installeren ###

Er zijn twee makkelijke manieren om Git op een Mac te installeren. De simpelste is om het grafische Gitinstallatieprogram te gebruiken, dat je van de volgende pagina op Google Code kunt downloaden (zie Figuur 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figuur 1-7. Gitinstallatieprogramma voor OS X.

De andere veelgebruikte manier is om Git via MacPorts (`http://www.macports.org`) te installeren. Als je MacPorts hebt, kun je Git installeren met

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Je hoeft niet al die extra’s toe te voegen, maar je wilt waarschijnlijk +svn erbij hebben voor het geval je ooit onder Git met Subversion repositories moet omgaan (zie Hoofdstuk 8).

### Op Windows installeren ###

Git op Windows installeren is erg eenvoudig. Het msysGit project heeft één van de eenvoudiger installatieprocedures. Je hoeft alleen maar het installatieprogramma te downloaden van Google Code, en het uit te voeren:

	http://code.google.com/p/msysgit

Nadat het geïnstalleerd is, kun je Git zowel vanaf de commandprompt gebruiken (waar ook een SSH client bijzit die later nog van pas zal komen) als via de standaard GUI.

## Git klaarmaken voor eerste gebruik ##

Nu je Git op je computer hebt staan, is het handig dat je een paar dingen doet om je Gitomgeving aan je voorkeuren aan te passen. Je hoeft deze instellingen normaliter maar één keer te doen. Ze blijven hetzelfde als je een nieuwe versie van Git installeert. Je kunt ze op elk moment weer veranderen door de commando’s opnieuw uit te voeren.

Git bevat standaard een stuk gereedschap genaamd `git config`, waarmee je de configuratie-eigenschappen kunt bekijken en veranderen, die alle aspecten van het uiterlijk en gedrag van Git regelen. Deze eigenschappen kunnen op drie verschillende plaatsen worden bewaard:

*	Het bestand `/etc/gitconfig`: Bevat eigenschappen voor elk account op de computer en al hun repositories. Als je de optie `--system` meegeeft aan `git config`, zal het dit de configuratiegegevens in dit bestand lezen of  veranderen. 
*	Het bestand `~/.gitconfig`: Eigenschappen voor jouw account. Je kunt Git dit bestand laten gebruiken door de optie `--global` mee te geven.
*	Het configuratiebestand in de Gitmap (dus `.git/config`) van het repository dat je op het moment gebruikt: Specifiek voor dat ene repository. Elk niveau is belangrijker dan het voorgaande, dus waarden in `.git/config` zullen worden gebruikt in plaats van die in `/etc/gitconfig`.

Op systemen met Windows zoekt Git in de `$HOME` map naar het `.gitconfig`-bestand (`C:\Documents and Settings\$USER` voor de meesten). Het kijkt ook nog naar `/etc/gitconfig`, maar dan op de plek waar je MSys hebt staan, wat de plek is waar je Git op je Windowscomputer geïnstalleerd hebt.

### Jouw identiteit ###

Het eerste wat je zou moeten doen nadat je Git geïnstalleerd hebt, is je gebruikersnaam en e-mail addres opgeven. Dat is belangrijk, omdat elke commit in Git deze informatie gebruikt, en het onveranderlijk ingebed zit in de commits die je ronddeelt:

	$ git config --global user.name "Scott Chacon"
	$ git config --global user.email schacon@gmail.com

Nogmaals, dit hoef je maar één keer te doen als je de `--global` optie eraan plakt, omdat Git die informatie zal gebruiken voor alles wat je doet op dat systeem. Als je een andere naam of e-mail wilt gebruiken voor specifieke projecten, kun je het commando uitvoeren zonder de `--global` optie als je in de map van dat project zit.

### Je tekstverwerker ###

Nu Git weet wie je bent, kun je de tekstverwerker instellen die gebruikt zal worden als Git je een bericht in wilt laten typen. Normaliter gebruikt Git de standaardtekstverwerker van je systeem wat meestal Vi of Vim is. Als je een andere tekstverwerker wilt gebruiken, zoals Emacs, kun je het volgende doen:

	$ git config --global core.editor emacs
	
### Je diffprogramma ###

En andere bruikbare optie die je misschien wel wilt instellen is het standaard diffprogramma om samenvoegingsconflicten op te lossen. Stel dat je vimdiff wilt gebruiken:

	$ git config --global merge.tool vimdiff

Git accepteert kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge en opendiff als geldige samenvoegingsgereedschappen. Je kunt ook een ander programma gebruiken; zie Hoofdstuk 7 voor meer informatie daarover.

### Je instellingen bekijken ###

Als je je instellingen wilt zien, kan je `git config --list` gebruiken voor een lijstje met alle instellingen die Git vanaf de huidige map kan vinden:

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

Als je ooit hulp nodig hebt terwijl je Git gebruikt, hier zijn drie manieren om de gebruiksaanwijzing (manpage) voor elk Git commando te krijgen:

	$ git help <actie>
	$ git <actie> --help
	$ man git-<actie>

Bijvoorbeeld, je kunt de gebruikershandleiding voor het commando `git config` krijgen door het volgende te typen:

	$ git help config

Deze commando's zijn fijn omdat je ze overal kunt opvragen, zelfs als je offline bent.
Als de gebruiksaanwijzing en dit boek niet genoeg zijn en je persoonlijke hulp nodig hebt, kan je de kanalen `#git` of `#github` (beiden Engelstalig) op het Freenode IRC netwerk (irc.freenode.net) proberen. Deze kanalen zijn regelmatig gevuld met honderden mensen die allemaal zeer ervaren zijn met Git en vaak bereidwillig om te helpen.

## Samenvatting ##

Je zou nu een beetje een idee moeten hebben van wat Git is en op wat voor manieren het verschilt van het versiebeheersysteem dat je misschien eerder gebruikte. Je zou nu ook een werkende versie van Git op je systeem moeten hebben dat is ingesteld met jouw identiteit. Nu is het tijd om de grondbeginselen van Git te gaan leren.
