# Komme i gang #

Dette kapittelet handler om å komme i gang med Git. Vi vil begynne på begynnelsen, ved å fortelle noe om bakgrunnen til versjonskontroll, før vi går over til hvordan du kan få Git til å kjøre på ditt system, og til slutt hvordan man kan sette opp og begynne å arbeide med det. Ved kapittelets slutt burde du kunne forstå hvorfor Git finnes, hvorfor du burde bruke det, og du burde være satt opp til å gjøre det.

## Om versjonskontroll ##

Hva er versjonskontroll, og hvorfor burde du bry deg? Versjonskontroll er et system som holder styr på forandringer i en fil, eller et sett av filer, over tid, slik at du kan finne tilbake til spesifikke versjoner senere. Selv om eksemplene i denne boka viser kildekodefiler under versjonskontroll, kan man i realiteten bruke det på alle typer filer på en datamaskin.

Er du en grafisk designer eller arbeider med webdesign og ønsker å beholde alle versjoner av et bilde eller en layout (som du sannsynligvis vil), så er det lurt å bruke et Version Control System (VCS). Et VCS gjør det mulig for deg å: tilbakestille filer til en tidligere utgave, tilbakestille hele prosjektet til en tidligere utgave, sjekke forandringer over tid, se hvem som sist forandret noe som muligens forårsaker et problem, hvem som introduserte en sak og når, osv. Å benytte seg av et VCS betyr også at dersom du roter det til eller mister filer, kan du vanligvis komme tilbake opp å kjøre raskt og enkelt. I tillegg, så får du alt dette uten at det krever noe videre av deg eller systemet ditt.

### Lokalt versjonskontrollsystem ###

Mange folks valgte versjonskontrollmetode innebærer å kopiere filer til en annen mappe (kanskje med datomerking hvis de er smarte). Denne tilnærmingen er vanlig, fordi den er enkel, men det kan også fort gå galt. Det er lett å glemme hvilken mappe man befinner seg i og så ved et uhell skrive til feil fil, eller kopiere over filer man ikke mente.

For å hanskes med dette problemet utviklet programmerere, for lenge siden, lokale VCSer der en enkel database holdt alle forandringer i filer som var under revisjonskontroll (se Figure 1-1).

Insert 18333fig0101.png
Figure 1-1. Lokalt versjonskontrolldiagram.

Et av de mer populære VCS-verktøyene var et system kalt rcs, som fremdeles distribueres med mange datamaskiner i dag. Selv det populære Mac OS X-operativsystemet inkluderer rcs-kommandoen når en installerer utviklerverktøyene. Dette verktøyet virker, enkelt fortalt, ved å beholde et sett av patcher (dvs, forskjellen mellom filene) fra en revisjon til en annen, i et spesielt format på disken; det kan så gjenskape hvordan enhver fil så ut på et hvilket som helst tidspunkt, ved å legge sammen alle patchene.

### Centralized Version Control Systems ###

The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems, such as CVS, Subversion, and Perforce, have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control (see Figure 1-2).

Insert 18333fig0102.png
Figure 1-2. Centralized version control diagram.

This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client.

However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything—the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCS systems suffer from this same problem—whenever you have the entire history of the project in a single place, you risk losing everything.

### Distribuerte versjonkontrollsystemer ###

Her er det Distribuerte Versjonkontrollsystemer  (DVCSer) komme inn. I et DVCS (slik som Git, Mercurial, Bazaar eller Darcs), så henter ikke klientene bare ut det nyeste bildet av filene: de speilere hele repositoriet. Så derfor, om en server skulle dø, og disse systemene samarbeidet via den, så kan hvilken som helst av klient repositoriene bli kopiert opp til serveren for å fikse det. Hver utsjekking er en hel backup av alle dataene (see Figure 1-3).

Insert 18333fig0103.png
Figure 1-3. Distributed version control diagram.

Mange av disse systemene håndterer også veldig godt det å ha flere fjerne repositorier å jobbe mot, sq du kan sammarbeide med flere forskjellige grupper folk på forskjellige måter samtidig innen for det samme prosjektet. Dette lar deg sette opp flere arbeidsmåter som ikke er mulig i sentraliserte systemer, som hierarkiske modeller.

## Kort Historie om Git ##

Som mange flotte ting i livet, så begynte Git med litt kreativ ødeleggelse og voldsom uenighet. Linux kjernen er et åpenkildekode prosjekt ved en ganske vidt skop. Mesteparten av livet til Linux kjerne vedlikeholdet (1991-2002), så var endringer i programvaren sendt rundt som patcher og arkiverte filer. I 2002 begynte Linux kjerne prosjektet å bruke et proprietært DVCS system med navn BitKeeper. 

I 2005 så falt forholdet mellom samholdet som utviklet Linux-kjernen og det komersielle firmaet som utviklet Bitkeeper sammen, og verktøyets gratis-bruk status ble fjernet. Dette fikk Linux utviklingssamholdet (og spesielt Linux Torvals, skaperen av Linux) til å utvikle deres eget verktøy med grunnlag i noen av tingene de lærte mens de brukte BitKeeper. Noen av målene for det nye systemet ble som følger:

*	Fart
*	Enkelt design
*	Sterk støtter for ikke-lineær utvikling (tusenvis av parallelle grener)
*	Helt distribuert
*	Able to handle large projects like the Linux kernel efficiently (speed and data size)
*	I stand til å håndtere store prosjekter som Linux-kjernern effektivt (fart og datastørrelse)

Siden den ble skapt i 2005, har Git utviklet seg og modnet til å bli et enkelt å bruke men forsatt beholde disse opprinnelige kvalitetene. Den er er utrolig rask, og den er veldig effektiv med store prosjekter, og den har et utrolig avgreningsystem for ikke-lineær utvikling (See Chapter 3).

## Grunnleggende Git ##

Så, hva er Git i et nøtteskall? Dette er en veldig viktig seksjon og ta innover seg, fordi om du forstår hva Git er og det fundamentelle rundt hvordan det virker, så vil det å bruke Git effektiv, sannsynligvis bli mye enklere for deg. Etter som du lærer Git, prøv å tøm tankene for de tingene du vet om andre VCSer, som Subversion og Perforce; å gjøre det vil hjelpe deg å unngå småforvirring når du bruker verktøyet. Git lagrer og tenker på informasjon veldig annerledes disse andre systemene, selv om bruker grensesnittet er ganske likt; å forstå de forskjellene vil hjelpe deg unngå å bli forvirret mens du bruker det.


### Bilder, Ikke Forskjeller ###

Hovedforskjellen mellom Git og andre VCS verktøy (inklusivt Subversion og dens venner) er hvordan den tenker på sin data. Konseptuelt, så lagrer de fleste andre systemer informasjon som en liste over filbaserte endringer. Disse systemene (CVS, Subversion, Perforce, Bazaar, og så vidre) tenker på informasjon som det tar vare på som et sett med filer og endringene gjort til hver fil over tid, som illustrert i Figur 1-4.

Insert 18333fig0104.png
Figure 1-4. Andre systemer pleier å lagre data som endringer til en grunnleggende versjon av hver fil.

Git verken tenker eller lagrere dataen på denne måten. Istedet så tenker Git på dataen mer som et sett med bilder av mini filsystemer. Hver gang du commit-er, eller lagrere tilstanden for prosjektet ditt i Git, så tar den i hovedask et bilde av hvordan alle filene dine ser ut i det øyeblikket of lagrer en referanse til det bildet. For å være effektiv, hvis filer ikke har blitt endre, så lagrer ikke Git filen igjen, den bare linker til forrige indentiske fil som den allerede har lagret. Git tenker på dataen mer som Figure 1-5.

Insert 18333fig0105.png
Figure 1-5.  Git lagrere data som et bilde av prosjektet over tid.

Dette er et viktig skille mellom Git og nesten alle andre VCSer. Det gjør at Git revurderer nesten alle aspekter av versjonkontroll som de fleste andre systemer kopierte fra den forrige generasjonen. Dette gjør Git mer til et mini-filsystem som har utrolig kraftige verktøy bygd oppå seg, istedet for bare en VCS. Vi vil utforske noen av fordelene du vil få ved å tenke på dataen din på denne måten når vi dekker Git avgrening  i Kapitell 3.

### Nærmest Alle Operasjoner Er Lokale  ###

De fleste operasjonene i Git trenger bare lokale filer og resurser for å operer - generelt sett så er ikke informasjon fra noen annen maskin på nettverket ditt nødvendig. Hvis du har brukt en CVCS hvor de fleste operasjoner har den type nettverk forsinkelse, så vil dette aspektet av Git få deg til å tenke at gudene for fart har velsignet Git med uparallelle krefter. Fordi du har hele historien til prosjektet rett der på den lokale disk, så virker de fleste operasjoner som om de nesten skjer med en gang.

For eksempel, for å se gjennom historien til prosjektet, så trenger ikke Git å gå til serveren for å få historien, og vise det til deg- den simpelthen leser den rett fra din likale database. Dette betyr at du ser prosjekt historien nesten med en gang. Hvis du ønsker å se endringene introdusert mellom den nåværende versjonen av filen og filen for en måned isden, så kan Git sjekke den filen fra en måned siden og gjøre en lokal forskjell kalkulasjon, istedet for å enten måtte spøre en server om å gjøre det, eller å måtte hente en eldre versjon av filen fra den serveren for å gjøre det lokalt.

Dette betyr også at det er veldig lite du ikke kan gære om du er offline eller ikke er på VPN. Du kan gå på et fly, eller et tog og så ønske å jobbe litt, og du kan gladelig comitte det fram til du kommer til en nettverkstilkobling for å laste det opp. Hvis du går hjem og ikke kan få VPN klienten til å virke skikkelig, så kan du fortsatt jobbe. I mange systemer, så er det enten umulig å gjøre, eller smertefult. I Perforce, for eksempel, så kan du ikke gjære stort når du ikke er koblet til serveren, og i Subversion og CVS, så kan du endre filer, men du kan ikke bruke commit på endringene dine til databasen (siden databasen din er offline). Dette virker kanskje ikke som noe stort, men du kan bli overrasket over hvor stor forskjell det kan utgjøre.

### Git Har Integritet ###

Alt i Git er sjekksummert før det er lagret, og så blir den referert til med den sjekksummen. Dette betyr at det umulig å endre innhodlet på en fil eller mappe uten at Git vet om det. Denne funksjonaliteten er bygd inn i Git på de laveste nivåene og er viktig del av dens filosofi. Du kan ikke miste informasjon når den prossesserer endringer eller ende opp med en korrupt fil uten at Git er i stand til å oppdage det.

Mekanismen Git bruker for denne sjekksummeringen er kalt en SHA-1 hash. Dette er en 40-tegn lang tekst satt sammen av hexadecimal-tegn (0-9 og a-f) og er kalkulert baser på innholdet av en fil og mappe structuren i Git. En SHA-1 hash ser ut noe sånt som dette:

	24b9da6552252987aa493b52f8696cd6d3b00373

Du vil se disse hash verdiene overalt i Git fordi den bruker dem så mye. Git lagrer faktisk alt, ikke med navn, men i Git databasen adresserbart med hash verdien av innholdet dens.

### Git Legger Generelt Bare Til Data ###

Når du gjør ting i Git, så vil nesten alle bare legge til data til Git databasen. Det er veldig vanskelig å få systemet til å gjøre noe som ikke kan angres, eller få det til å slette data på en eller annen måte. Som i en hver VCS, så kan du miste eller rote til endringer du ikke har commitet enda; men etter du har commited et bilde inn i Git, så er det veldig vanskelig å miste det, spesielt om du jevnlig bruker push for å sende databasen til en annen repository.

Dette gjør det å bruke Git til en gledelig opplevelse fordi vi vet at vi kan eksperimentere uten fare for å virkelig rote til ting skikkelig. For en mer dypere innsyn i hvoradn Git lagerer data og hvordan du kan få tilbake data som virker tapt, se Kapitel 9.

### De Tre Tilstandene ###

Følg med. Detter er viktigeste å huske om Git om du ønsker at resten av læringsprossessen din skal gå flytende. Git har tre hoved tilstandet som filene dine kan være i: committed, modified, og staged. Commited betyr at dataen er laget trygt i din lokale database. Mofigied betyr at du har endret på filen men ikke har committed den til databasen enda. Staged betyr at du har markert en modified fil i dens nåværende versjon til å gå inn i ditt neste commit bilde.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png
Figure 1-6. Arbeidsmappe, staging området, og git mappe.

Git mappen er der Git  lagere metadata og objekt databasen for prosjektet ditt. Dette er den mest viktige delen av Git, og det er det som er kopier når du kloner et repository fra en annen maskin.

Arbeidsmappen er en enkel checkout av en versjon av prosjektet. Disse filene er dratt ut av den komprimerte databasen i Git mappen og plassert på disken slik at du kan bruke eller modifisere det.

Staging området er en enkelt fil, generelt holdt i Git mappen din, som lagrer informasjon om hva som vil gå inn i din neste commit. Det er noen ganger referert til som indeksen, men det begynner å bli det vanlige å kalle det staging området.

Den grunnleggende Git arbeidsmåten er litt som dette:

1. Du modifiserer filer i arbeidmappa.
2. Du stage-er filene, og lager bilder av den til staging området.
3. Du gjør en commit, som tar filene som de er i staging området og lagrer det bildet permanent i Git mappen din.

Hvis en bestemt versjon av en fil er i git mappen, så er den ansett som comitted. Hvis den er modifisert men har blitt lagt til i staging området, så der den staged. Og hvis den var endret siden den var sjekket ut men ikke blitt staged, så er den modifisert. I Kapitel 2 så vil du lære om disse tilstande og hvordan du kan utnytte deg av dem eller hoppe over staged-delen helt.

## Installer Git ##

La oss gå inn for å bruke litt Git. Det første du trenger gjøre er å installere det. Du kan gjøre det på flere måter; de to vanlige er å installere det fra kildekode eller å installere en allerede eksisterende pakke for din platform.

### Installere fra Kildekode ###

Hvis du kan, så er det generelt sett nyttig å installere Git fra kildekode, ettersom du vil få nyeste versjon. Hver versjon av Git pleier å inkludere nyttige grensensitt forbedringer, så å skaffe seg den nyeste versjonen er ofte den beste måten, dersom du føler deg komfortable med å kompilere programvare fra kildekode. Det er er også tilfellet at mange Linux distrobusjoner har veldig gamle pakker; så med mindre du er på en veldig up-to-date distro eller bruker backports, så er det å installere fra kildekode den beste løsningen.

For å installere git så trenger du følgene biblioteker som Git er avhengige av: curl, zlib, openssl, expat, and libiconv. For eksempel, om du er på et system som har yum (som Fedora) eller apt-get (som Debian baserte systemer), så kan du bruke en av disse kommandoene for å installere alle avhengighetene:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

Når du har alle de nødvendige avhengighetene, så kan du gå å laste det nyeste bildet fra Git nettsiden:

	http://git-scm.com/download

Og så, kompiler og installer:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Etter alt dette er gjort, så kan du også få Git gjennom Git for oppdateringer.

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Installer på Linux ###

Hvis du vil installere Git på Linux via en binær installasjonspakke, så kan du generelt få gjort det gjennom det vanlige pakkebehandlerverktøyet som kommer med distroen din. Hiv du er på Fedora, så kan du bruke yum:

	$ yum install git-core

Eller om du bruker en Debian-basert distro som Ubuntu, prøv apt-get:

	$ apt-get install git

### Installer på Mac ###

Det er to enkle måter å installere Git på en Mac. Den enkleste er å bruke den grafiske Git installasjonspakken, som du kan laste ned fra SourceForge siden (se Figur 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png
Figure 1-7. Git OS X innstallasjon.

Den andre vanlige måten å gjære det på er å installere Git via MacPorts ('http://macports.org'). Hvis du har MacPorts installert, installer Git med

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Du trenger ikke alt det ekstra, men du vil sannynligvis ønske å inkludere +svn sånn i fall du trenger å bruke git med Subversion repositorier (se Kapitel 8).

### Installer på Windows ###

Å installere Git på Windows er veldig enkelt. msysGit prosjektet har en av de enkleste installasjonprossedyrene. Bare last ned installasjons exe filen fra GitHub siden, og kjær den:

	http://msysgit.github.com/

Etter den er installert, så har du både en kommandolinje versjon (inkludert en SSH klient som vil bli nyttig senere) og det standard grafiske brukgergrensesnittet.

Merknad om Windows bruk: du burde bruke Git med msysGit shellet (Unix stil) som kommer med, det lar deg bruke de komplekse linjene med kommandoer gitt i denne boken. Om du av en eller annen grunn skulle trenge å bruke Windows sitt eget shell/kommandolinje konsoll, så må du bruker dobbelt annførsel tegn istedet for enkelt annførselstegn (for parametere med mellomrom i seg) og du må bruke annførseltegn på parametere som slutter med ^ om de er på slutten av linjen, siden det er et forsettelsesymbol i Windows.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically.
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option.
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`%USERPROFILE%` in Windows’ environment), which is `C:\Documents and Settings\$USER` or `C:\Users\$USER` for most people, depending on version (`$USER` is `%USERNAME%` in Windows’ environment). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

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
