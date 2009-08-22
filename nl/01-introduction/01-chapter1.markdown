# Aan de Slag #

Dit hoofdstuk leg ik uit je hoe je aan de slag kunt gaan met Git.  We zullen aan het begin beginnen: je krijgt een beetje achtergrondinformatie over versiebeheersystemen, daarna een korte uitleg hoe je Git werkend kan krijgen op je computer en hoe je het kan instellen zodat je ermee aan het werk kunt.  Aan het einde van dit hoofdstuk zou je moeten kunnen begrijpen waarom Git er is, waarom je het nodig is en zal alles zo ingesteld staan dat dat ook kan.

## Het Wat en Waarom van Versiebeheer ##

Wat is versiebeheer, en wat heeft dat met jou te maken? Versiebeheer is een systeem dat veranderingen in een bestand, of groep van bestanden, over de tijd onthoudt, zodat je specifieke versies later kan opvragen. In de voorbeelden in dit boek is het broncode waarvan de versies worden beheerd, maar je kan het eigenlijk met zo goed als elk soort bestand op een computer doen.

Als je een grafisch ontwerper bent of websites maakt, en elke versie van een afbeelding of opmaak (wat je zeker zou willen), is het verstandig een versiebeheersysteem (Version Control System in het Engels, afgekort to VCS) te gebruiken. Als je dat gebruikt kan je eerdere versies van bestanden terughale, een eerdere versie van het hele project terughalen, verschillen tussen twee momentented bekijken, zien wie het laatst iets aangepast heeft wat problemen zou kunnen veroorzaken, wie een probleen heeft veroorzaakt en wanneer, en nog veel meer. Een VCS gebruiken betekent meestal ook dat je de situatie gemakkelijk terug kan draaien als je een fout maakt of bestanden kwijtraakt. Daarbij komt nog dat dit allemaal heel weinig extra kosten met zich mee brengt.

### Lokale Versiebeheersystemen ###

Veel mensen hebben hun eigen versiebeheer methode: ze kopiëren bestanden naar een andere map (en als ze slim zijn, geven ze die map ook een datum). Deze methode wordt veel gebruikt omdat het zo simpel is, maar het is ook ongelovelijk foutgevoelig. Het is makkelijk te vergeten in welke map je zit, en naar het verkeerde bestand te schrijven, of over bestanden heen te kopiëren waar je dat niet wou.

Om met dit probleem om te gaan, hebben programmeurs lang geleden lokale VCSen ontwikkeld die een simpele database hadden die alle veranderingen aan bestandend beheerden (zie Figuur 1-1).

Insert 18333fig0101.png 
Figuur 1-1. Een diagram van een lokaal versiebeheersysteem.

Een populair gereedschap voor VCS was een systeem genaamd rcs, wat vandaag de dag nog steeds met veel computers wordt mee geleverd. Zelfs het populaire besturingssysteem Mac OS X heeft rcs, als je de Developer Tools installeert. Dit gereedschap werkt in principe door verzamelingen van ‘patches’ (de verschillen tussen bestanden) van de verschillende bestanden in een speciaal formaat op de harde schijf op te slaan; zo kan je teruggaan naar hoe een bestand er uitzag op een bepaalde tijd, door alle patches bij elkaar op te tellen.

### Gecentraliseerde Versiebeheersystemen ###

Het volgende grote probleem waar mensen tegenaan lopen is dat ze samen moeten werken met ontwikkelaars op andere computers. Om dit probleem op te lossen ontwikkelden ze Gecentraliseerde Versiebeheersystemen (CVCSen). Deze systemen, zoals CVS, Subversion en Perforce, hebben één centrale server waarop alle versies van de bestanden staan, en een aantal clients die de bestanden daarvandaan halen (‘check out’, in het Engels). Vele jaren was dit de standaard voor versiebeheer (zie Figuur 1-2).

Insert 18333fig0102.png 
Figuur 1-2. Een diagram van een gecentraliseerd versiebeheersysteem.

Deze manier van versiebeheer bied veel voordelen, vooral als je het vergelijkt met lokale VCSen. Bijvoorbeeld, iedereen weet tot op een bepaalde hoogte wat de rest die aan het project werken aan het doen zijn. Beheerders hebben precieze controle over wie wat kan doen; en het is veel eenvoudiger om een CVCS te beheren dan te moeten werken met lokale databases voor elke client.

Maar helaas, deze methode heeft ook behoorlijke nadelen. De duidelijkste is het ‘single point of failure’: als de centrale server neergaat en een uur later weer terug komt, kan niemand in dat uur samenwerken, of versies bewaren van de dingen waar ze aan werken. Als de harde schrijf waar de centrale database op staat corrupt raakt, en er geen backups van zijn, verlies je echt alles — de hele geschiedenis van het project, behalve het momentopname mensen op hun eigen computers hebben staan. Lokale VCSen hebben hetzelfde probleem — als je de hele geschiedenis van het project op één enkele plaats bewaard, loop je ook kans alles te verliezen.

### Gedistribueerde Versiebeheersystemen ###

En hier verschijnen Gedistribueerde Versiebeheersystemen (DVCSen) ten tonele. In een DVCS (zoals Git, Mercurial, Bazaar of Darcs), downloaden clients niet alleen de laatste momentopnames van de bestanden: de hele geschiedenis (het ‘repository’) wordt gekopiërd. Dus als een server neergaat, en deze systemen werkten via die server samen, kan de kopie van elke willekeurige kopie client terug worden gekopiëerd naar de server om het te herstellen. Elke checkout is dus eigenlijk een complete backup van alle data (zie Figuur 1-3).

Insert 18333fig0103.png 
Figuur 1-3. Diagram van een gedistribueerd versiebeheersysteem

Bovendien werken veel van deze systemen behoorlijk goed met meerdere (niet-lokale) repositories tegelijk, zodat je met verschillende groepen mensen op verschillende manieren tegelijk aan hetzelfde project kan werken. Hierdoor kan je verschillende werkprocessen (‘workflows’) opzetten die niet mogelijk waren geweest met gecentraliseerde systemen, zoals hiërarchische modellen. 

## Een Kleine Geschiedenis van Git ##

Zoals zoveel goede dingen in het leven, begon Git met een beetje creatieve destructie en een hoogoplopende controverse. De Linuxkernel is een open source softwareproject met een behoorlijk groot draagvlak. Voor het grootste gedeelte van het leven van het onderhoud van de Linuxkernel (1991–2002), werden aanpassingen aan de software verspreid via patches en gearchiveerde bestanden. In 2002 veranderde dat, want vanaf dat jaar begon het project het gesloten DVCS genaamd BitKeeper te gebruiken.

In 2005 viel de relatie tussen de gemeenschap die de Linuxkernel ontwikkelde en het commerciële bedrijf dat BitKeeper maakte uiteen, en het programma kon niet meer gratis worden gebruikt. Dit was aanleiding voor de gemeenschap (en Linus Torvalds, de maker van Linux, in het bijzonder) om hun eigen gereedschap te ontwikkelen, gebaseerd op een paar lessen die ze geleerd hadden toen ze nog BitKeeper gebruikten. Een paar van de doelen die ze hadden voor het nieuwe systeem waren als volgt:

*	Snelheid
*	Eenvoudig ontwerp
*	Goede ondersteuning voor niet-lineaire ontwikkeling (duizenden aparte takken tegelijk)
*	Volledig gedistribueerd
*	In staat om efficient om te gaan met grote projecten als Linux efficiënt (zowel in snelheid als geheugenruimte)

Sinds zijn geboorte in 2005 is Git gegroeid tot zijn huidige vorm: het is gemakkelijk te gebruiken en heeft toch die oorspronkelijke eigenschappen behouden. Het is ongelofelijk snel, enorm efficiënt met grote projecten, en zijn systeem voor aparte takken (‘branches’) van niet-lineaire ontwikkeling is ongeëvenaard (zie Hoofdstuk 3).

## De Basis van Git ##

Dus, wat is Git in een notendop? Dit is een belangrijk deelhoofdstuk, omdat het waarschijnlijk een stuk makkelijker wordt om Git effectief te gebruiken als je goed begrijpt wat Git is en hoe het werkt. Probeer te vergeten wat je al weet over andere VCSen zoals Subversion en Perforce als je Git aan het leren bent; zo kan je verwarring door de subtiele verschillen voorkomen. Git gaat op een hele andere manier met informatie om dan die andere systemen, ook al lijken de verschillende commando’s behoorlijk op elkaar; als je die verschillen begrijpt, kan je voorkomen dat je verward raakt als je Git gebruikt.

### Momentopnames in Plaats van Verschillen ###

Een groot verschil tussen Git en elke andere VCS (inclusief Subversion en consorten) is hoe Git denkt over zijn data. Conceptueel bewaren de meeste andere systemen informatie als een lijst van veranderingen per bestand. Deze systemen (CVS, Subversion, Perforce, Bazaar, enzovoort) zien de informatie die ze bewaren als een aantal bestanden en de veranderingen die aan die bestanden zijn aangebracht over de tijd, zoals geïllustreerd in Figuur 1-4.

Insert 18333fig0104.png 
Figuur 1-4. Andere systemen bewaren data meestal als veranderingen aan een basisversie van elk bestand.

Git ziet en bewaart zijn data heel anders. De kijk van Git op zijn data kan worden uitgelegd als een reeks momentopnames van een miniatuurbestandsysteem. Elke keer dat je ‘commit’, de status van van je project in Git opslaat, neemt het een soort van foto van hoe al je bestanden er op dat moment uitzien en slaat een verwijzing naar die momentopname op. Voor efficiëntie Git ongewijzigde bestanden niet elke keer opnieuw op—alleen een verwijzing naar het eerdere identieke bestand dat het eerder al opgeslagen had. In Figuur 1-5 kan je zie hoe Git ongeveer over zijn data denkt.

Insert 18333fig0105.png 
Figuur 1-5. Git bewaart data als momentopnames van het project.

Dat is een belangrijk verschil tussen Git en bijna alle VCSen. Hierdoor vindt Git bijna elk onderdeel van versiebeheer opnieuw uit, terwijl de meeste andere systemen het allemaal gewoon overnemen van de eerdere generaties. Hierdoor is Git meer een soort miniatuurbestandssysteem met een paar ongelooflijk krachtige gereedschappen, in plaats van niets meer dan een VCS. We zullen een paar van de voordelen die je krijgt als je op die manier over data denkt gaan onderzoeken, als we het gaan hebben over ‘branches’ (takken van ontwikkeling) gaan hebben in Hoofdstuk 3 .

### Bijna Alles Is Lokaal ###

De meeste handelingen in Git hebben alleen lokale bestanden en bronnen nodig om te werken – normaal gesproken is geen informatie nodig van een andere computer in je netwerk. Als je gewent bent aan een CVCS, waar de meeste handelingen vertraagd worden door het netwerk, lijkt Git een geschenk van de snelheidsgoden. Omdat je de hele geschiedenis van het project op je lokale harde schijf hebt staan, lijken de meeste acties geen tijd in beslag te nemen.

Een voorbeeld: Git hoeft niet aan een of andere server de geschiedenis van je project te vragen als je de die wilt doorbladeren – het leest simpelweg jou lokale database. Dat betekend dat je de geschiedenis bijna direct krijgt te zien. Als je de veranderingen wilt zien tussen de huidige versie van een bestand en de versie van een maand geleden, kan Git het bestand van een maand geleden opzoeken, en de lokale verschillen berekenen, in plaats van aan een niet-lokale server te moeten vragen om het te doen, of de oudere versie van het bestand ophalen om het lokaal te doen.

Dat betekend dat er maar heel weinig is dat je niet kan doen als je offline bent of zonder VPN zit. Als je in een vliegtuig of trein zit, en je wilt nog even een beetje werken, kan je vrolijk doorgaan met commits maken tot je een netwerkverbinding krijgt, zodat je je werk kan uploaden. Als je naar huis gaat, en je VPN client niet aan de praat kan krijgen, kan je nog steeds doorwerken. Bij veel andere systemen is dat of onmogelijk, of anders zeer onaangenaam. Als je bijvoorbeeld Perforce gebruikt, kan je niet zo veel doen als je niet verbonden bent met de server; en met Subversion en CVS kan je bestanden bewerken, maar je kan geen commits maken voor je database (omdat die offline is). Dat lijkt misschien niet zo belangrijk, maar je zal nog versteld staan wat een verschil het kan maken.

### Git Is Integer ###

Git maakt een controlegetal (‘checksum’) van alles voordat het wordt opgeslaten, en er wordt later naar die data verwezen met dat controlegetal. Dat betekent dat het onmogelijk is om de inhoud van een bestand of map te veranderen zonder dat Git ervanaf weet. Deze functionaliteit is ingebouwd in de diepste diepten van Git en staat centraal in zijn filosofie. Je kan geen informatie kwijtraken als het wordt verstuurd en bestanden kunnen niet corrupt raken zonder dat Git het doorheeft.

Het mechanisme dat Git gebruikt voor die controlegetallen heet een SHA-1-hash. Dat is een tekenreeks van 40 karakters lang, bestaande uit hexadecimale tekens (0–9 en a–f) en berekend met de inhoud van een bestand of mapstructuur in Git. Een SHA-1-hash ziet er ongeveer zo uit:

	24b9da6552252987aa493b52f8696cd6d3b00373

Je zal deze hashtekenreeksen overal tegenkomen in Git, omdat het er zoveel gebruik van maakt. Sterker nog, Git bewaart data niet onder hun bestandsnaam maar in de database van Git, onder de hash van zijn inhoud.

### Git Voegt Normaal Gesproken Alleen Data Toe ###

Wanneer je iets doet in Git, is de kans groot dat het alleen maar data aan de database van Git toevoegt. Het is erg moeilijk om het systeem iets te laten doen wat je niet ongedaan kan maken, of het data uit te laten wissen op wat voor manier dan ook. Zoals met elke VCS kan je veranderingen verliezen of verhaspelen waar je nog geen momentopname van hebt gemaakt; maar als je dat eenmaal hebt gedaan, is het erg moeilijk om die data te verliezen, zeker als je je lokale database regelmatig uploadt (‘push’) naar een ander repository.

Je zult nog veel plezier van Git hebben, omdat je weet dat je kun experimenteren zonder het gevaar te lopen jezelf behoorlijk in de nesten te werken. Zie Hoofdstuk 9 voor een iets diepgaandere uitleg over hoe Git zijn data bewaart en hoe je de data die verloren lijkt kan terughalen.

### De Drie Toestanden ###

Let nu goed op. Dit is het belangrijkste wat je over Git moet weten als je wilt dat de rest van het leerproces goed verloopt. Git heeft drie hoofdtoestanden waarin je bestanden kunnen zijn: gecommit (‘commited’), aangepast (‘modified’) en voorbereid voor een commit (‘staged’). Gecommit betekent dat alle data al veilig opgeslagen is in je lokale database. Aangepast betekent dat je je bestand hebt veranderd maar dat je nog geen nieuwe momentopname in je database hebt. Voorbereid betekend dat je al hebt aangegeven dat de huidige versie van het aangepaste bestand in je volgende momentopname toevoegt.

Dit brengt ons tot de drie hoofdonderdelen van een Gitproject: de Gitmap, de werkmap, en de wachtrij voor een commit (‘staging area’)

Insert 18333fig0106.png 
Figuur 1-6. Werkmap, wachtrij en Gitmap

De Gitmap is waar Git de metadata en objectdatabase van je project opslaat. Dit is het belangrijkste deel van Git, dit is hetgene wat gekopiëerd wordt als je een repository kloont vanaf een andere computer.

De werkmap is een kopie van een bepaalde versie van het project (een ‘checkout’). Deze bestanden worden uit de gecomprimeerde database in de Gitmap gehaald en op de harde schijf geplaatst waar jij het kan gebruiken of bewerken.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

De algemene manier van werken met Git gaat ongeveer zo:

1.	Je bewerkt bestanden in je werkmap.
2.	Je bereid de bestanden voor, momentopnames worden toegevoegd aan de wachtrij.
3.	Je maakt een commit, wat alle momentopnames van de wachtrij neemt en die permanent in je Gitmap opslaat.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
