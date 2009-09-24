# Git op de Server #

Op dit punt zou je alledaagse taken waarvoor je Git zult gebruiken kunnen doen. Maar, om samen te kunnen werken in Git, zul je een remote repository moeten hebben. Technisch gezien kun je wijzigingen pushen en pullen van individuele repositories, maar dat wordt afgeraden, omdat je vrij gemakkelijk het werk waar anderen mee bezig zijn in de war kunt schoppen als je niet oppast. Daarnaast wil je dat je medewerkers bij het repository kunnen, zelfs als jouw computer van het netwerk is – het hebben van een betrouwbaar gezamenlijk repository is vaak handig. Daarom heeft het hebben van een tussenliggend repository waarin je met iemand anders samenwerkt de voorkeur, en daaruit kun je dan pushen en pullen. We zullen dit repository de `Git server` noemen, maar je zult zien dat het over het algemeen maar een klein beetje systeembronnen kost om een Git repository te verzorgen, dus je zult er zelden een complete server voor nodig hebben.

Een Git server draaien is eenvoudig. Als eerste kies je met welke protocollen je je server wilt laten communiceren. Het eerste gedeelte van dit hoofdstuk zullen we de beschikbare protocollen bespreken met de voor- en nadelen van elk. De volgende secties zullen veel voorkomende opstellingen bespreken, die van die protocollen gebruik maken hoe je je server ermee kunt opzetten. Als laatste laten we een paar servers van derden zien, als je het niet erg vindt om je code op iemands server te zetten en niet het gedoe wilt hebben van het opzetten en onderhouden van je eigen server.

Als je geen interesse hebt om je eigen server te draaien, dan kun je de rest overslaan en direct naar het laatste gedeelte van het hoofdstuk gaan om wat mogelijkheden van online accounts te zien en dan door te gaan naar het volgende hoofdstuk, waar we alle zaken bespreken die komen kijken bij het werken met een gedistribueerde versie beheer omgeving.

Een remote repository is over het algemeen een _bare repository_ (kaal repository) – een Git repository dat geen werkmap heeft. Omdat het repository alleen gebruikt wordt als een samenwerkingspunt, is er geen reden om een snapshot op de schijf te hebben; het alleen de Git data. Een bare repository is eenvoudigweg de inhoud van de `.git` map in je project, en niets anders.

## De Protocollen ##

Git kan vier veel voorkomende netwerk protocollen gebruiken om data te transporteren: Lokaal, Beveiligde Shell (SSH), Git en HTTP. Hier laten we zien wat het zijn, en in welke omstandigheden je ze wilt gebruiken (of juist niet).

Het is belangrijk om te zien dat met uitzondering van de HTTP protocollen, ze allemaal een werkende Git versie op de server geinstalleerd moeten hebben.

### Lokaal Protocol ###

Het meest basale is het _lokale protocol_, waarbij het remote repository in een andere map op de schijf is. Dit wordt vaak gebruikt als iedereen in je team toegang heeft op een gedeeld bestandssyteem zoals een NFS map, of in het weinig voorkomende geval dat iedereen in dezelfde computer werkt. Het laatste zou niet ideaal zijn, want dan zouden alle repositories zich op dezelfde computer bevinden, zodat de kans op een fataal verlies veel groter wordt.

Als je een gedeeld bestandssyteem hebt, dan kun je clonen, pushen en pullen van een lokaal bestand gebaseerd repository. Om een dergelijk repository te clonen, of om er een als een remote aan een bestaand project toe te voegen, moet je het pad naar het repository als URL gebruiken. Bijvoorbeeld, om een lokaal repository te clonen, kun je zoiets als dit uitvoeren:

	$ git clone /opt/git/project.git

Of je kunt dit doen:

	$ git clone file:///opt/git/project.git

Git werkt iets anders als je explicite `file://` aan het begin van de URL zet. Als je alleen het pad specificeerd, probeert Git hardlinks te gebruiken, of het kopieerd te bestanden die het nodig heeft. Als je `file://` specificeerd, dan start Git de processen die het normaal gebruikt om data te transporteren over een netwerk, wat over het algemeen een stuk minder efficiente methode is om data te transporteren. De reden om `file://` wel te specificeren is als je een schone kopie van het repository wilt met de extra referenties of objecten eruit gelaten – over het algemeen na een import van een ander versie beheer systeem of iets dergelijks (zie Hoofdstuk 9 voor onderhoudstaken). We zullen het normale pad hier gebruiken, omdat het bijna altijd sneller is om het zo te doen.

Om een lokaal repository aan een bestaand Git project toe te voegen, kun je zoiets als dit uitvoeren:

	$ git remote add local_proj /opt/git/project.git

Daarna kun je pushen en pullen van dat remote alsof je over een netwerk werkt.

#### De Voordelen ####

De voordelen van bestands-gebaseerde repositories zijn dat ze eenvoudig zijn en ze maken gebruik van bestaande bestandspermissies en netwerk toegang. Als je al een gedeeld bestandssysteem hebt, waar je hele team al toegang tot heeft, dan is een repository opzetten heel gemakkelijk. Je stopt het bare repository ergens waar iedereen gedeelde toegang tot heeft, en stelt de lees- en schrijfrechten in zoals je dat bij iedere andere gedeelde map zou doen. In de volgende sectie "Git op een Server krijgen" bespreken we hoe je een kopie van een bare repository kunt exporteren voor dit doeleind.

Dit is ook een fijne optie om snel werk van een repository van iemand anders te pakken. Als jij en een collega aan hetzelfde project aan het werk zijn, en hij wil dat je iets bekijkt, dan is het uitvoeren van een commando zoals `git pull /home/john/project` vaak makkelijker dan dat hij naar een remote server moet pushen, en jij er van moet pullen.

#### De Nadelen ####

De nadelen van deze methode zijn dat gedeelde toegang over het algemeen moeilijker op te zetten en te bereiken is vanaf meerdere lokaties dan basaal netwerk toegang. Als je wilt pushen van je laptop als je thuis bent, dan moet je de remote schijf aankoppelen, wat moeilijk en langzaam kan zijn in vergelijking tot netwerk gebaseerde toegang.

Het is ook belangrijk om te melden dat het niet noodzakelijk de snelste optie is, als je een gedeeld koppelpunt of iets dergelijks gebruikt. Een lokaal repository is alleen snel als je snelle toegang tot de data hebt. Een repository op NFS is vaak langzamer dan het repository via SSH op dezelfde server, wat Git toelaat om vanaf lokale schijven te werken op ieder systeem.

### Het SSH Protocol ###

Waarschijnlijk het meest voorkomende protocol voor Git is SSH. Dit is omdat SSH toegang tot servers in veel plaatsen al geconfigureerd is – en als dat niet het geval is, dan is het makkelijk om dat te doen. SSH is ook het enige netwerk gebaseerde protocol waarvan je makkelijk kunt lezen en naartoe kunt schrijven. De andere twee netwerk protocollen (HTTP en Git) zijn over het algemeen alleen-lezen, dus zelfs als je ze al beschikbaar hebt voor de ongewassen massa, dan heb je nog steeds SSH nodig voor je eigen schrijftoegang. SSH is ook een geverifieerd protocol; en omdat het overal voorkomt, is het over het algemeen eenvoudig om in te stellen en te gebruiken.

Om een Git repository via SSH te clonen, kun je een ssh:// URL opgeven zoals:

	$ git clone ssh://user@server:project.git

Of je geeft geen protocol op – Git gaat uit van SSH als je niet expliciet bent:
	
	$ git clone user@server:project.git

Je kunt ook de gebruiker niet opgeven, en Git neemt aan dat je de gebruiker bedoeld waarmee je op het moment bent ingelogged.

#### De Voordelen ####

Er zijn vele voordelen om SSH te gebruiken. De eerste is dat je het eigenlijk wel moet gebruiken als je geverifieerde schrijftoegang op je repository via een netwerk wilt. Het tweede is dat het relatief eenvoudig in te stellen is – SSH daemons komen veel voor, veel systeembeheerders hebben er ervaring mee, en veel operating systemen zijn er mee uitgerust of hebben applicaties om ze te beheren. Daarnaast is toegang via SSH veilig – alle data transporten zijn versleuteld en geverifieerd. En als laatste is SSH efficient, zoals het Git en lokale protocol, waarbij de data zo compact mogelijk wordt gemaakt voordat het getransporteerd wordt.

#### De Nadelen ####

Het negatieve aspect van SSH is dat je er geen anonieme toegang over kunt geven. Mensen moeten via SSH toegang hebben om er gebruik van te kunnen maken, zelfs als het alleen lezen is, zodat SSH toegang niet bevordelijk is voor open source projecten. Als je het alleen binnen je bedrijfsnetwerk gebruikt, dan kan SSH misschien het enige protocol zijn waar je mee in aanraking komt. Als je anonieme alleen-lezen toegang wilt toestaan tot je projecten, dan moet je SSH voor jezelf instellen om over te pushen, maar iets anders voor anderen om over te pullen.

### Het Git Protocol ###

Het volgende is het Git protocol. Dit is een aparte daemon, die samen met Git geleverd wordt; het luistert op een toegewezen poort (9418), dat een vergelijkbaare dienst verleend als het SSH protocol, maar dan zonder enige verificatie. Om een repository te serveren over het Git protocol, moet je het `git-export-daemon-ok` bestand aanmaken – de daemon zal een repository zonder dit bestand erin niet serveren – maar buiten dat is er geen beveiliging. Ofwel het Git repository is er om gecloned te kunnen worden door iedereen, of het is er helemaal niet. Dit betekend dat er over het algemeen geen pushing is via dit protocol. Je kunt push toegang aanzetten; maar gegeven het gebrek aan verificatie als je push toegang aan zet, kan iedereen die jouw project's URL op het internet vind pushen naar jouw project. We volstaan met te zeggen dat dit zeldzaam is.

#### De Voordelen ####

Het Git protocol is het snelste dat beschikbaar is. Als je veel verkeer serveert voor een publiek project, of een zeer groot project dat geen gebruikersverificatie nodig heeft voor leestoegang, dan is het waarschijnlijk dat je een Git daemon wilt instellen om je project te serveren. Het maakt van hetzelfde data-transport mechanisme gebruik als het SSH protocol, maar dan zonder de extra belasting van versleuteling en verificatie.

#### De Nadelen ####

Het nadeel van het Git protocol is het gebrek van verificatie. Het is over het algemeen onwenselijk dat het Git protocol de enige toegang tot je project is. Over het algemeen zul je het samen met SSH toegang gebruiken voor de paar ontwikkelaars die push (schrijf-)toegang hebben en de rest laat je `git://` voor alleen leestoegang gebruiken.
Het is waarschijnlijk ook het meest ingewikkelde protocol om in te stellen. Het moet een eigen daemon hebben, die speciaal ontworpen is – we zullen er een instellen in het "Gitosis" gedeelte van dit hoofdstuk – het gebruikt `xinetd` configuratie of iets dergelijks, wat niet altijd eenvoudig is. Het heeft ook firewall toegang tot poort 9418 nodig, wat geen standaard poort is dat bedrijfsfirewalls altijd toestaan. Achter grote bedrijfsfirewalls, is deze obscure poort meestal geblokkeerd.

### Het HTTP/S Protocol ###

Als laatste hebben we het HTTP protocol. Het mooie aan het HTTP of HTTPS protocol is dat het simpel in te stellen is. Eigenlijk is alles wat je moet doen het bare Git repository in je HTTP document root zetten, en een specifieke `post-update` hook (haak) instellen en je bent klaar (zie hoofdstuk 7 voor details over Git hooks). Op dat punt kan iedereen die toegang heeft tot de webserver waaronder je het repository gezet hebt ook je repository clonen. Om leestoegang tot je repository over HTTP toe te staan, doe je zoiets als het volgende:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Dat is alles. De `post-update` hook, die standaard bij Git zit, voert het noodzakelijke commando uit (`git update-server-info`) om HTTP fetching en cloning goed werkend te krijgen. Dit commando wordt uitgevoerd als je naar dit repository via SSH pushed; en dan kunnen andere mensen clonen met behulp van zoiets als

	$ git clone http://example.com/gitproject.git

In dit geval, gebruiken we het `/var/www/htdocs` pad wat gebruikelijk is voor Apache opstellingen., maar je kunt iedere statische webserver gebruiken – stop het bare repository in haar pad. De Git data wordt geserveerd als standaard statische bestanden (zie hoofdstuk 9 voor details over hoe het precies geserveerd wordt).

Het ook is mogelijk om Git over HTTP te laten pushen, alhoewel dat geen veelgebruikte techniek is en vereist dat je complexe WebDAV vereisten insteld. Omdat het zelden gebruikt wordt, zullen we het niet in dit boek beschrijven. Als je geinteresseerd bent om de HTTP-push protocollen te gebruiken, dan kun je op `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` lezen hoe je een repository kunt maken. Een fijn ding aan Git laten pushen over HTTP is dat je iedere WebDAV server kunt gebruiken, zonder specifieke Git eigenschappen; dus je kunt deze functionaliteit gebruiken als je web-hosting provider WebDAV ondersteund voor schrijf vernieuwingen aan je webpagina.

#### De Voordelen ####

Het voordeel van het gebruik van het HTTP protocol is dat het eenvoudig in te stellen is. Een handvol benodigde commando's uitvoeren zorgt voor een eenvoudige manier om de wereld leestoegang te geven aan je Git repository. Het kost slechts een paar minuten om te doen. Het HTTP protocol is niet erg belastend voor de systeembronnen van je server. Omdat het over het algemeen een statische webserver gebruikt om alle data te serveren, een normale Apache server kan gemiddeld duizenden bestanden serveren per seconde – is het moeilijk om zelfs een kleine server te overbelasten.

Je kunt ook je repositories alleen-lezen serveren via HTTPS, wat betekend dat je het transport kunt versleutelen; of je kunt zelfs zover gaan dat je clients een specifiek gesigneerd SSL certificaat moeten gebruiken. Als je over het algemeen zo ver gaat, dan is het makkelijker om publieke SSH sleutels te gebruiken; maar het kan een betere oplossing in jouw specifieke geval om gesigneerde SSL certificaten of andere HTTP-gebaseerde verificatie methoden te gebruiken voor alleen-lezen toegang via HTTPS.

Een ander fijn ding is dat HTTP zo'n veel voorkomend protocol is dat bedrijfsfirewalls vaak zo ingesteld zijn dat ze verkeerd via deze poort toelaten.

#### De Nadelen ####

Het nadeel van je repository serveren via HTTP is dat het relatief inefficient voor de client is. Over het algemeen duurt het een stuk langer om te clonen en te fetchen van het repository, en je hebt vaak een stuk meer netwerk belasting en transport volume via HTTP dan met ieder van de andere netwerk protocollen. Omdat het niet zo intelligent is om alleen de data te versturen die je nodig hebt – er wordt geen dynamisch werk door de server gedaan in deze transacties – wordt vaak naar het HTTP protocol gerefereerd als zijnde een _dom_ protocol. Voor meer informatie over de verschillen in efficientie tussen het HTTP protocol en andere protocollen, zie Hoofdstuk 9.

## Git op een Server Krijgen ##

Om een initiele Git server op te zetten, moet je een bestaand repository in een bare repository exporteren – een repository dat geen werkmap bevat. Dit is over het algemeen eenvoudig te doen.
Om je repository te clonen om een nieuw bare repository te maken, voer je het clone commando uit met de `--bare` optie. Als vaste gewoonte eindigen de namen van bare repository mappen in `.git`, zoals:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

De output van dit commando is een beetje verwarrend. Omdat `clone` eigenlijk een `git init` en dan een `git fetch` is, zien we de output van het `git init` gedeelte, wat een lege map aanmaakt. De eigenlijk object overdracht geeft geen output, maar het gebeurd wel. Nu zou je een kopie van de Git map data in je `my_project.git` map moeten hebben.

Dit is ongeveer gelijk aan

	$ cp -Rf my_project/.git my_project.git

Er zijn een paar kleine verschillen in het configuratie bestand; maar voor jouw doeleinde ligt dit dicht bij hetzelfde. Het neemt de Git repository zelf, zonder een werkmap, en maakt een map aan specifiek alleen voor dat ding.

### Het Bare Repository op een Server Zetten ###

Nu dat je een bare kopie van je repository hebt, is het enige dat je moet doen het op een server zetten en je protocollen instellen. Stel dat je een server ingesteld hebt, die `git.example.com` heet, waar je SSH toegang op hebt, en waar je al je Git repositories wilt opslaan onder de `/opt/git` map. Je kunt je nieuwe repository instellen door je bare repository ernaartoe te kopieeren:

	$ scp -r my_project.git user@git.example.com:/opt/git

Op dit punt kunnen andere gebruikers, die SSH toegang hebben tot dezelfde server en welke lees-toegang hebben tot de `/opt/git` map, jouw repository clonen door dit uit te voeren:

	$ git clone user@git.example.com:/opt/git/my_project.git

Als een gebruiker in een server SSH-ed en schrijftoegang heeft tot de `/opt/git/my_project.git` map, dan hebben ze automatisch ook push toegang. Git zal automatisch correct groep schrijfrechten aan een repository toevoegen als je het `git init` commando met de `--shared` optie uitvoerd.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Je ziet hoe eenvoudig het is om een Git repository te nemen, een bare versie aan te maken, en het op een server plaatsen waar jij en je medewerkers SSH toegang tot hebben. Nu ben je klaar om aan hetzelfde project samen te werken.

Het is belangrijk om te zien dat dit letterlijk alles is wat je moet doen om een bruikbare Git server te draaien waarop meerdere mensen toegang hebben – voeg alleen een paar SSH accounts toe op een server, en stop een bare repository ergens waar al die gebruikers lees- en schrijftoegang tot hebben. Je bent er klaar voor – je hebt niets anders nodig.

In de volgende secties zul je zien hoe je meer ingewikkelde opstellingen kunt maken. Deze bespreking zal het niet hoeven aanmaken van gebruikers accounts voor elke gebruiker, publieke leestoegang tot repositories, grafische web interfaces, de Gitosis applicatie gebruiken en meer omvatten. Maar, hou in gedachten dat om samen te kunnen werken met mensen op een prive project, alles wat je _nodig_ hebt is een SSH server en een bare repository.

### Kleine Opstellingen ###

Als je met een kleine groep bent of zojuist begint met Git in je organisatie en slechts een paar ontwikkelaars hebt, dan kunnen de dingen eenvoudig voor je zijn. Een van de meest gecompliceerde aspecten van een Git server instellen is gebruikers management. Als je sommige repositories alleen-lezen voor bepaalde gebruikers wilt hebben, en lezen/schrijven voor anderen, dan kunnen toegang en permissies een beetje lastig in te stellen zijn.

#### SSH Toegang ####

Als je reeds een server hebt waar al je ontwikkelaars SSH toegang op hebben, dan is het over het algemeen het gemakkelijkst om je eerste repository daar in te stellen, omdat je dan bijna niets hoeft te doen (zoals getoond in de laatste sectie). Als je meer complexe toegangscontrole wilt op je repositories, dan kun je ze instellen met de normale bestandssysteem permissies van het operating systeem dat je server draait.

Als je je repositories op een server wilt zetten, die geen accounts heeft voor iedereen in je team die je schrijftoegang wilt geven, dan moet je SSH toegang voor ze instellen. We gaan er vanuit dat je een server hebt waarmee je dit kunt doen, je reeds een SSH server geinstalleerd hebt, en dat de manier is waarop je toegang hebt tot de server.

Er zijn een paar manieren waarop je iedereen in je team toegang kunt geven. De eerste is voor iedereen accounts aanmaken, wat rechttoe rechtaan is maar omslachtig kan zijn. Je wilt misschien niet `adduser` uitvoeren en tijdelijke wachtwoorden voor iedere gebruiker instellen.

Een tweede methode is een 'git' gebruiker aanmaken op de machine, aan iedere gebruiker die schijftoegang moet hebben vragen of ze je een publieke SSH sleutel sturen, en die sleutel toevoegen aan het `~/.ssh/authorized_keys` bestand van je nieuwe 'git' gebruiker. Vanaf dat punt zal iedereen toegang hebben op die machine via de 'git' gebruiker. Dit tast de commit data op geen enkele manier aan – de SSH gebruiker waarmee je inlogged zal de commits die je opgeslagen hebt niet beinvloeden.

Een andere manier waarop je het kunt doen is je SSH server laten verifieren vanaf een LDAP server of een andere gecentraliseerde verifivatie bron, die je misschien al ingesteld hebt. Zolang dat iedere gebruiker een shell toegang heeft op de machine, zou ieder SSH verificatie mechanisme dat je kunt bedenken moeten werken.

## Generating Your SSH Public Key ##

That being said, many Git servers authenticate using SSH public keys. In order to provide a public key, each user in your system must generate one if they don’t already have one. This process is similar across all operating systems.
First, you should check to make sure you don’t already have a key. By default, a user’s SSH keys are stored in that user’s `~/.ssh` directory. You can easily check to see if you have a key already by going to that directory and listing the contents:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

You’re looking for a pair of files named something and something.pub, where the something is usually `id_dsa` or `id_rsa`. The `.pub` file is your public key, and the other file is your private key. If you don’t have these files (or you don’t even have a `.ssh` directory), you can create them by running a program called `ssh-keygen`, which is provided with the SSH package on Linux/Mac systems and comes with the MSysGit package on Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

First it confirms where you want to save the key (`.ssh/id_rsa`), and then it asks twice for a passphrase, which you can leave empty if you don’t want to type a password when you use the key.

Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). All they have to do is copy the contents of the `.pub` file and e-mail it. The public keys look something like this:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

For a more in-depth tutorial on creating an SSH key on multiple operating systems, see the GitHub guide on SSH keys at `http://github.com/guides/providing-your-ssh-key`.

## Setting Up the Server ##

Let’s walk through setting up SSH access on the server side. In this example, you’ll use the `authorized_keys` method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a `.ssh` directory for that user.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Next, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

You just append them to your `authorized_keys` file:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Now, you can set up an empty repository for them by running `git init` with the `--bare` option, which initializes the repository without a working directory:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

At this point, the others can clone it down and push changes back up just as easily:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

With this method, you can quickly get a read/write Git server up and running for a handful of developers.

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:

	$ sudo vim /etc/passwd

At the bottom, you should find a line that looks something like this:

	git:x:1000:1000::/home/git:/bin/sh

Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). The line should look something like this:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Public Access ##

What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

First you need to enable the hook:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently. 

What does this `post-update` hook do? It looks basically like this:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.

Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:

	$ chgrp -R www-data /opt/git

When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:

	$ git clone http://git.gitserver/project.git

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. The GitWeb web-based user interface.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

	$ git instaweb --httpd=webrick --stop

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

	$ apt-get install python-setuptools

Next, you clone and install Gitosis from the project’s main site:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

	$ ln -s /opt/git /home/git/repositories

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

	git:x:1000:1000::/home/git:/usr/bin/git-shell

back to this:

	git:x:1000:1000::/home/git:/bin/sh

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Now you have a directory named `gitosis-admin`, which has two major parts:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

	[group mobile]
	writable = iphone_project
	members = scott

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

After you commit and push that change, all four users will be able to read from and write to that project.

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories – you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

	[repo iphone_project]
	daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved. 

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page.

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Figure 4-3. The GitHub user signup form.

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Figure 4-4. The GitHub user dashboard.

Next you can create a new repository. 

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Figure 4-5. Creating a new repository on GitHub.

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Figure 4-6. GitHub project header information.

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instructions for a new repository.

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Figure 4-8. Project header with a public URL and a private URL.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Figure 4-9. Subversion importing interface.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Figure 4-10. GitHub administration page.

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adding a collaborator to your project.

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Figure 4-12. A list of collaborators on your project.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Figure 4-13. A GitHub main project page.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project.

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
