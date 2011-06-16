# Git op de Server #

Op dit punt zou je alledaagse taken waarvoor je Git zult gebruiken kunnen doen. Maar, om samen te kunnen werken in Git, zul je een remote repository moeten hebben. Technisch gezien kun je wijzigingen pushen en pullen van individuele repositories, maar dat wordt afgeraden, omdat je vrij gemakkelijk het werk waar anderen mee bezig zijn in de war kunt schoppen als je niet oppast. Daarnaast wil je dat je medewerkers bij het repository kunnen, zelfs als jouw computer van het netwerk is – het hebben van een betrouwbaar gezamenlijk repository is vaak handig. Daarom heeft het hebben van een tussenliggend repository waarin je met iemand anders samenwerkt de voorkeur, en daaruit kun je dan pushen en pullen. We zullen dit repository de `Git server` noemen, maar je zult zien dat het over het algemeen maar een klein beetje systeembronnen kost om een Git repository te verzorgen, dus je zult er zelden een complete server voor nodig hebben.

Een Git server draaien is eenvoudig. Als eerste kies je met welke protocollen je je server wilt laten communiceren. Het eerste gedeelte van dit hoofdstuk zullen we de beschikbare protocollen bespreken met de voor- en nadelen van elk. De volgende secties zullen veel voorkomende opstellingen bespreken, die van die protocollen gebruik maken hoe je je server ermee kunt opzetten. Als laatste laten we een paar servers van derden zien, als je het niet erg vindt om je code op iemands server te zetten en niet het gedoe wilt hebben van het opzetten en onderhouden van je eigen server.

Als je geen interesse hebt om je eigen server te draaien, dan kun je de rest overslaan en direct naar het laatste gedeelte van het hoofdstuk gaan om wat mogelijkheden van online accounts te zien en dan door te gaan naar het volgende hoofdstuk, waar we alle zaken bespreken die komen kijken bij het werken met een gedistribueerde versie beheer omgeving.

Een remote repository is over het algemeen een _bare repository_ (kale repository) – een Git repository dat geen werkmap heeft. Omdat het repository alleen gebruikt wordt als een samenwerkingspunt, is er geen reden om een snapshot op de schijf te hebben; alleen de Git data. Een kale repository is eenvoudigweg de inhoud van de `.git` map in je project, en niets anders.

## De Protocollen ##

Git kan vier veel voorkomende netwerk protocollen gebruiken om data te transporteren: Lokaal, Beveiligde Shell (SSH), Git en HTTP. Hier laten we zien wat het zijn, en in welke omstandigheden je ze wilt gebruiken (of juist niet).

Het is belangrijk om te zien dat, met uitzondering van de HTTP protocollen, ze allemaal een werkende Git versie op de server geinstalleerd moeten hebben.

### Lokaal Protocol ###

Het meest basale is het _lokale protocol_, waarbij het remote repository in een andere map op de schijf is. Dit wordt vaak gebruikt als iedereen in je team toegang heeft op een gedeeld bestandssyteem zoals een NFS map, of in het weinig voorkomende geval dat iedereen in dezelfde computer werkt. Het laatste zou niet ideaal zijn, want dan zouden alle repositories zich op dezelfde computer bevinden, zodat de kans op een fataal verlies veel groter wordt.

Als je een gedeeld bestandssyteem hebt, dan kun je clonen, pushen en pullen van een op een lokaal bestand gebaseerde repository. Om een dergelijk repository te clonen, of om er een als een remote aan een bestaand project toe te voegen, moet je het pad naar het repository als URL gebruiken. Bijvoorbeeld, om een lokaal repository te clonen, kun je zoiets als dit uitvoeren:

	$ git clone /opt/git/project.git

Of je kunt dit doen:

	$ git clone file:///opt/git/project.git

Git werkt iets anders als je explicite `file://` aan het begin van de URL zet. Als je alleen het pad specificeert, probeert Git hardlinks te gebruiken, of het kopieert de bestanden die het nodig heeft. Als je `file://` specificeert, dan start Git de processen die het normaal gebruikt om data te transporteren over een netwerk, wat over het algemeen een stuk minder efficiente methode is om data te transporteren. De reden om `file://` wel te specificeren is als je een schone kopie van de repository wilt met de extra referenties of objecten eruit gelaten – over het algemeen na een import van een ander versie beheer systeem of iets dergelijks (zie Hoofdstuk 9 voor onderhoudstaken). We zullen het normale pad hier gebruiken, omdat het bijna altijd sneller is om het zo te doen.

Om een lokaal repository aan een bestaand Git project toe te voegen, kun je zoiets als dit uitvoeren:

	$ git remote add local_proj /opt/git/project.git

Daarna kun je pushen en pullen van dat remote alsof je over een netwerk werkt.

#### De Voordelen ####

De voordelen van bestands-gebaseerde repositories zijn dat ze eenvoudig zijn en ze maken gebruik van bestaande bestandspermissies en netwerk toegang. Als je al een gedeeld bestandssysteem hebt, waar je hele team al toegang tot heeft, dan is een repository opzetten heel gemakkelijk. Je stopt de kale repository ergens waar iedereen gedeelde toegang tot heeft, en stelt de lees- en schrijfrechten in zoals je dat bij iedere andere gedeelde map zou doen. In de volgende sectie "Git op een Server krijgen" bespreken we hoe je een kopie van een kale repository kunt exporteren voor dit doeleind.

Dit is ook een fijne optie om snel werk van een repository van iemand anders te pakken. Als jij en een collega aan hetzelfde project aan het werk zijn, en hij wil dat je iets bekijkt, dan is het uitvoeren van een commando zoals `git pull /home/john/project` vaak makkelijker dan dat hij naar een remote server moet pushen, en jij er van moet pullen.

#### De Nadelen ####

Een van de nadelen van deze methode is dat gedeelde toegang over het algemeen moeilijker op te zetten en te bereiken is vanaf meerdere lokaties dan basaal netwerk toegang. Als je wilt pushen van je laptop als je thuis bent, dan moet je de remote schijf aankoppelen, wat moeilijk en langzaam kan zijn in vergelijking tot netwerk gebaseerde toegang.

Het is ook belangrijk om te melden dat het niet noodzakelijk de snelste optie is, als je een gedeeld koppelpunt of iets dergelijks gebruikt. Een lokale repository is alleen snel als je snelle toegang tot de data hebt. Een repository op NFS is vaak langzamer dan het repository via SSH op dezelfde server, wat Git toelaat om vanaf lokale schijven te werken op ieder systeem.

### Het SSH Protocol ###

Waarschijnlijk het meest voorkomende protocol voor Git is SSH. Dit is omdat SSH toegang tot servers in veel plaatsen al geconfigureerd is – en als dat niet het geval is, dan is het makkelijk om dat te doen. SSH is ook het enige netwerk gebaseerde protocol waarvan je makkelijk kunt lezen en naartoe kunt schrijven. De andere twee netwerk protocollen (HTTP en Git) zijn over het algemeen alleen-lezen, dus zelfs als je ze al beschikbaar hebt voor de ongeinitieerden, dan heb je nog steeds SSH nodig voor je eigen schrijftoegang. SSH is ook een geverifieerd protocol; en omdat het overal voorkomt, is het over het algemeen eenvoudig om in te stellen en te gebruiken.

Om een Git repository via SSH te clonen, kun je een ssh:// URL opgeven zoals:

	$ git clone ssh://user@server:project.git

Of je geeft geen protocol op – Git gaat uit van SSH als je niet expliciet bent:
	
	$ git clone user@server:project.git

Je kunt ook de gebruiker niet opgeven, en Git neemt aan dat je de gebruiker bedoelt waarmee je op het moment bent ingelogged.

#### De Voordelen ####

Er zijn vele voordelen om SSH te gebruiken. De eerste is dat je het eigenlijk wel moet gebruiken als je geverifieerde schrijftoegang op je repository via een netwerk wilt. Het tweede is dat het relatief eenvoudig in te stellen is – SSH daemons komen veel voor, veel systeembeheerders hebben er ervaring mee, en veel operating systemen zijn er mee uitgerust of hebben applicaties om ze te beheren. Daarnaast is toegang via SSH veilig – alle data transporten zijn versleuteld en geverifieerd. En als laatste is SSH efficient, zoals het Git en lokale protocol, waarbij de data zo compact mogelijk wordt gemaakt voordat het getransporteerd wordt.

#### De Nadelen ####

Het negatieve aspect van SSH is dat je er geen anonieme toegang over kunt geven. Mensen moeten via SSH toegang hebben om er gebruik van te kunnen maken, zelfs als het alleen lezen is, zodat SSH toegang niet bevordelijk is voor open source projecten. Als je het alleen binnen je bedrijfsnetwerk gebruikt, dan kan SSH misschien het enige protocol zijn waar je mee in aanraking komt. Als je anonieme alleen-lezen toegang wilt toestaan tot je projecten, dan moet je SSH voor jezelf instellen om over te pushen, maar iets anders voor anderen om over te pullen.

### Het Git Protocol ###

Het volgende is het Git protocol. Dit is een aparte daemon, die samen met Git geleverd wordt; het luistert op een toegewezen poort (9418), dat een vergelijkbare dienst verleend als het SSH protocol, maar dan zonder enige verificatie. Om een repository te serveren over het Git protocol, moet je het `git-export-daemon-ok` bestand aanmaken – de daemon zal een repository zonder dit bestand erin niet serveren – maar buiten dat is er geen beveiliging. Ofwel het Git repository is er om gecloned te kunnen worden door iedereen, of het is er helemaal niet. Dit betekent dat er over het algemeen geen pushing is via dit protocol. Je kunt push toegang aanzetten; maar gegeven het gebrek aan verificatie als je push toegang aan zet, kan iedereen die de URL van jouw project op het internet vindt, pushen naar jouw project. We volstaan met te zeggen dat dit zeldzaam is.

#### De Voordelen ####

Het Git protocol is het snelste dat beschikbaar is. Als je veel verkeer serveert voor een publiek project, of een zeer groot project dat geen gebruikersverificatie nodig heeft voor leestoegang, dan is het waarschijnlijk dat je een Git daemon wilt instellen om je project te serveren. Het maakt van hetzelfde data-transport mechanisme gebruik als het SSH protocol, maar dan zonder de extra belasting van versleuteling en verificatie.

#### De Nadelen ####

Het nadeel van het Git protocol is het gebrek van verificatie. Het is over het algemeen onwenselijk dat het Git protocol de enige toegang tot je project is. Over het algemeen zul je het samen met SSH toegang gebruiken voor de paar ontwikkelaars die push (schrijf-)toegang hebben en de rest laat je `git://` voor alleen leestoegang gebruiken.
Het is waarschijnlijk ook het meest ingewikkelde protocol om in te stellen. Het moet een eigen daemon hebben, die speciaal ontworpen is – we zullen er een instellen in het "Gitosis" gedeelte van dit hoofdstuk – het gebruikt `xinetd` configuratie of iets dergelijks, wat niet altijd eenvoudig is. Het heeft ook firewall toegang tot poort 9418 nodig, wat geen standaard poort is dat bedrijfsfirewalls altijd toestaan. Achter grote bedrijfsfirewalls, is deze obscure poort meestal geblokkeerd.

### Het HTTP/S Protocol ###

Als laatste hebben we het HTTP protocol. Het mooie aan het HTTP of HTTPS protocol is dat het simpel in te stellen is. Eigenlijk is alles wat je moet doen de kale Git repository in je HTTP document root zetten, en een specifieke `post-update` hook (haak) instellen en je bent klaar (zie hoofdstuk 7 voor details over Git hooks). Vanaf dat moment kan iedereen die toegang heeft tot de webserver waaronder je de repository gezet hebt ook je repository clonen. Om leestoegang tot je repository over HTTP toe te staan, doe je zoiets als het volgende:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Dat is alles. De `post-update` hook, die standaard bij Git zit, voert het noodzakelijke commando uit (`git update-server-info`) om HTTP fetching en cloning goed werkend te krijgen. Dit commando wordt uitgevoerd als je naar dit repository via SSH pushed; en dan kunnen andere mensen clonen met behulp van zoiets als

	$ git clone http://example.com/gitproject.git

In dit geval, gebruiken we het `/var/www/htdocs` pad wat gebruikelijk is voor Apache opstellingen, maar je kunt iedere statische webserver gebruiken – stop de kale repository in haar pad. De Git data wordt geserveerd als standaard statische bestanden (zie hoofdstuk 9 voor details over hoe het precies geserveerd wordt).

Het ook is mogelijk om Git over HTTP te laten pushen, alhoewel dat geen veelgebruikte techniek is en erom vraagt dat je complexe WebDAV vereisten insteld. Omdat het zelden gebruikt wordt, zullen we het niet in dit boek beschrijven. Als je geinteresseerd bent om de HTTP-push protocollen te gebruiken, dan kun je op `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` lezen hoe je een repository kunt maken. Een fijn ding aan Git laten pushen over HTTP is dat je iedere WebDAV server kunt gebruiken, zonder specifieke Git eigenschappen; dus je kunt deze functionaliteit gebruiken als je web-hosting provider WebDAV ondersteunt voor schrijf vernieuwingen aan je webpagina.

#### De Voordelen ####

Het voordeel van het gebruik van het HTTP protocol is dat het eenvoudig in te stellen is. Een handvol benodigde commando's uitvoeren zorgt voor een eenvoudige manier om de wereld leestoegang te geven aan je Git repository. Het kost slechts een paar minuten om te doen. Het HTTP protocol is niet erg belastend voor de systeembronnen van je server. Omdat het over het algemeen een statische webserver gebruikt om alle data te serveren, een normale Apache server kan gemiddeld duizenden bestanden serveren per seconde – is het moeilijk om zelfs een kleine server te overbelasten.

Je kunt ook je repositories alleen-lezen serveren via HTTPS, wat betekend dat je het transport kunt versleutelen; of je kunt zelfs zover gaan dat je clients een specifiek gesigneerd SSL certificaat moeten gebruiken. Als je over het algemeen zo ver gaat, dan is het makkelijker om publieke SSH sleutels te gebruiken; maar het kan een betere oplossing in jouw specifieke geval om gesigneerde SSL certificaten of andere HTTP-gebaseerde verificatie methoden te gebruiken voor alleen-lezen toegang via HTTPS.

Een ander fijn ding is dat HTTP zo'n veel voorkomend protocol is dat bedrijfsfirewalls vaak zo ingesteld zijn dat ze verkeerd via deze poort toelaten.

#### De Nadelen ####

Het nadeel van je repository serveren via HTTP is dat het relatief inefficient voor de client is. Over het algemeen duurt het een stuk langer om te clonen en te fetchen van de repository, en je hebt vaak een stuk meer netwerk belasting en transport volume via HTTP dan met elk van de andere netwerk protocollen. Omdat het niet zo ingewikkeld is om alleen de data te versturen die je nodig hebt – er wordt geen dynamisch werk door de server gedaan in deze transacties – wordt vaak naar het HTTP protocol gerefereerd als zijnde een _dom_ protocol. Voor meer informatie over de verschillen in efficientie tussen het HTTP protocol en andere protocollen, zie Hoofdstuk 9.

## Git op een Server Krijgen ##

Om een initiele Git server op te zetten, moet je een bestaande repository in een kale repository exporteren – een repository dat geen werkmap bevat. Dit is over het algemeen eenvoudig te doen.
Om je repository te clonen met als doel het maken van een kale repository, voer je het clone commando uit met de `--bare` optie. Als vaste gewoonte eindigen de namen van kale repository mappen in `.git`, zoals:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

De output van dit commando is een beetje verwarrend. Omdat `clone` eigenlijk een `git init` en dan een `git fetch` is, zien we de output van het `git init` gedeelte, wat een lege map aanmaakt. De eigenlijke object overdracht geeft geen output, maar het gebeurt wel. Nu zou je een kopie van de Git map data in je `my_project.git` map moeten hebben.

Dit is ongeveer gelijk aan

	$ cp -Rf my_project/.git my_project.git

Er zijn een paar kleine verschillen in het configuratie bestand; maar voor jouw doeleinde ligt dit dicht bij hetzelfde. Het neemt de Git repository zelf, zonder een werkmap, en maakt een map aan specifiek alleen voor dat ding.

### Het Bare Repository op een Server Zetten ###

Nu dat je een kale kopie van je repository hebt, is het enige dat je moet doen het op een server zetten en je protocollen instellen. Stel dat je een server ingesteld hebt, die `git.example.com` heet, waar je SSH toegang op hebt, en waar je al je Git repositories wilt opslaan onder de `/opt/git` map. Je kunt je nieuwe repository instellen door je kale repository ernaartoe te kopieeren:

	$ scp -r my_project.git user@git.example.com:/opt/git

Op dit punt kunnen andere gebruikers, die SSH toegang hebben tot dezelfde server en lees-toegang hebben tot de `/opt/git` map, jouw repository clonen door dit uit te voeren:

	$ git clone user@git.example.com:/opt/git/my_project.git

Als een gebruiker in een server SSH-ed en schrijftoegang heeft tot de `/opt/git/my_project.git` map, dan hebben ze automatisch ook push toegang. Git zal automatisch correcte groep schrijfrechten aan een repository toevoegen als je het `git init` commando met de `--shared` optie uitvoert.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Je ziet hoe eenvoudig het is om een Git repository te nemen, een kale versie aan te maken, en het op een server plaatsen waar jij en je medewerkers SSH toegang tot hebben. Nu ben je klaar om aan hetzelfde project samen te werken.

Het is belangrijk om te zien dat dit letterlijk alles is wat je moet doen om een bruikbare Git server te draaien waarop meerdere mensen toegang hebben – voeg alleen een paar SSH accounts toe op een server, en stop een kale repository ergens waar al die gebruikers lees- en schrijftoegang tot hebben. Je bent er klaar voor – je hebt niets anders nodig.

In de volgende secties zul je zien hoe je meer ingewikkelde opstellingen kunt maken. Deze bespreking zal het niet hoeven aanmaken van gebruikers accounts voor elke gebruiker, publieke leestoegang tot repositories, grafische web interfaces, de Gitosis applicatie gebruiken en meer omvatten. Maar, hou in gedachten dat om samen te kunnen werken met mensen op een prive project, alles wat je _nodig_ hebt is een SSH server en een kale repository.

### Kleine Opstellingen ###

Als je met een kleine groep bent of net begint met Git in je organisatie en slechts een paar ontwikkelaars hebt, dan kunnen de dingen eenvoudig voor je zijn. Een van de meest gecompliceerde aspecten van een Git server instellen is het beheren van gebruikers. Als je sommige repositories alleen-lezen voor bepaalde gebruikers wilt hebben, en lezen/schrijven voor anderen, dan kunnen toegang en permissies een beetje lastig in te stellen zijn.

#### SSH Toegang ####

Als je reeds een server hebt waar al je ontwikkelaars SSH toegang op hebben, dan is het over het algemeen het gemakkelijkst om je eerste repository daar in te stellen, omdat je dan bijna niets hoeft te doen (zoals beschreven in de vorige sectie). Als je meer complexe toegangscontrole wilt op je repositories, dan kun je ze instellen met de normale bestandssysteem permissies van het operating systeem dat op je server draait.

Als je je repositories op een server wilt zetten, die geen accounts heeft voor iedereen in je team die je schrijftoegang wilt geven, dan moet je SSH toegang voor ze instellen. We gaan er vanuit dat je een server hebt waarmee je dit kunt doen, je reeds een SSH server geinstalleerd hebt, en dat de manier is waarop je toegang hebt tot de server.

Er zijn een paar manieren waarop je iedereen in je team toegang kunt geven. De eerste is voor iedereen accounts aanmaken, wat rechttoe rechtaan is maar omslachtig kan zijn. Je wilt misschien niet `adduser` uitvoeren en tijdelijke wachtwoorden voor iedere gebruiker instellen.

Een tweede methode is een 'git' gebruiker aanmaken op de machine, aan iedere gebruiker die schijftoegang moet hebben vragen of ze je een publieke SSH sleutel sturen, en die sleutel toevoegen aan het `~/.ssh/authorized_keys` bestand van je nieuwe 'git' gebruiker. Vanaf dat punt zal iedereen toegang hebben op die machine via de 'git' gebruiker. Dit tast de commit data op geen enkele manier aan – de SSH gebruiker waarmee je inlogged zal de commits die je opgeslagen hebt niet beinvloeden.

Een andere manier waarop je het kunt doen is je SSH server laten verifieren vanaf een LDAP server of een andere gecentraliseerde verificatie bron, die je misschien al ingesteld hebt. Zolang iedere gebruiker een shell toegang heeft op de machine, zou ieder SSH verificatie mechanisme dat je kunt bedenken moeten werken.

## Je Publieke SSH Sleutel Genereren ##

Dat gezegd hebbende, zijn er vele Git servers die verifieren met een publieke SSH sleutel. Om een publieke sleutel te hebben, zal iedere gebruiker in je systeem er een moeten genereren als ze er nog geen hebben. Dit proces is bij alle operating systemen vergelijkbaar.
Als eerste moet je controleren dat je er niet al een hebt. Standaard staan de SSH sleutels van de gebruikers in hun eigen `~/.ssh` map. Je kunt makkelijk nagaan of je al een sleutel hebt door naar die map te gaan en de inhoud te tonen:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Je bent op zoek naar een aantal bestanden genaamd iets en iets.pub, waarbij het `iets` meestal zoiets is als `id_dsa` of `id_rsa`. Het `.pub` bestand is je publieke sleutel en het andere bestand is je private sleutel. Als je deze bestanden niet hebt (of als je zelfs geen `.ssh` map hebt), dan kun je ze aanmaken door een applicatie genaamd `ssh-keygen` uit te voeren, wat meegeleverd wordt met het SSH pakket op Linux/Mac systemen en meegeleverd wordt met het MSysGit pakket op Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Eerst bevestigt het de lokatie waar je de sleutel wilt opslaan (`.ssh/id_rsa`), en vervolgens vraagt het tweemaal om een wachtzin, die je leeg kunt laten als je geen wachtwoord wilt intypen op het moment dat je de sleutel gebruikt.

Iedere gebruiker die dit doet, moet zijn sleutel sturen naar jou of degene die de Git server beheert (aangenomen dat je een SSH server gebruikt die publieke sleutels vereist). Het enige dat ze hoeven doen is de inhoud van het `.pub` bestand kopieeren en e-mailen. De publieke sleutel ziet er ongeveer zo uit:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Voor een uitgebreide tutorial over het aanmaken van een SSH sleutel op meerdere operating systemen, zie de GitHub handleiding over SSH sleutels op `http://github.com/guides/providing-your-ssh-key`.

## De Server Instellen ##

Laten we het instellen van SSH toegang aan de server kant eens doorlopen. In dit voorbeeld zul je de `authorized_keys` methode gebruiken om je gebruikers te verifieren. We gaan er ook vanuit dat je een standaard Linux distributie gebruikt zoals Ubuntu. Als eerste creeer je een 'git' gebruiker een een `.ssh` map voor die gebruiker.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Daarna moet je een aantal publieke SSH sleutels van ontwikkelaars aan het `authorized_keys` bestand toevoegen voor die gebruiker. Laten we aannemen dat je een aantal sleutels per e-mail ontvangen hebt en ze hebt opgeslagen in tijdelijke bestanden. Nogmaals, de sleutels zien er ongeveer zo uit:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Je voegt ze slechts toe aan je `authorized_keys` bestand:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Nu kun je een leeg repository voor ze instellen door `git init` uit te voeren met de `--bare` optie, wat het repository initialiseert zonder een werkmap:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Daarna kunnen John, Josie of Jessica de eerste versie van hun project in de repository pushen door het als een remote toe te voegen en naar een branch te pushen. Let op dat iemand met een shell op de machine zal moeten inloggen en een kale repository moet creeeren, iedere keer als je een project wilt toevoegen. Laten we `gitserver` als hostnaam gebruiken voor de server waar je je 'git' gebruiker en repository hebt ingesteld. Als je het intern gaat draaien, en je de DNS instelt zodat `gitserver` naar die server wijst, dan kun je de commando's vrijwel ongewijzigd gebruiken:

	# op Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Op dat punt kunnen de anderen het clonen en wijzigingen even gemakkelijk terug pushen:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Met deze methode kun je snel een lees/schrijf Git server draaiend krijgen voor een handvol ontwikkelaars.

Als een extra voorzorgsmaatregel kun je de 'git' gebruiker makkelijk beperken tot het doen van alleen Git activiteiten, met een gelimiteerde shell applicatie genaamd `git-shell` die bij Git geleverd wordt.
Als je dit als login shell voor je 'git' gebruiker instelt, dan kan de 'git' gebruiker geen normale shell toegang hebben op je server. Specificeer `git-shell` in plaats van bash of csh voor je gebruikers login shell om dit te gebruiken. Om dit te doen zul je waarschijnlijk het `/etc/passwd` bestand aan moeten passen:

	$ sudo vim /etc/passwd

Aan het einde zou je een regel moeten vinden die er ongeveer zo uit ziet:

	git:x:1000:1000::/home/git:/bin/sh

Verander `/bin/sh` in `/usr/bin/git-shell` (of voer `which git-shell` uit om te zien waar het geinstalleerd is). De regel moet er ongeveer zo uit zien:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Nu kan de 'git' gebruiker de SSH connectie alleen gebruiken om Git repositories te pushen en te pullen, en niet om in te loggen in de machine. Als je het probeert zul je een login weigering zoals deze zien:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Publieke Toegang ##

Wat als je anonieme leestoegang op je project wil? Misschien wil je geen intern prive project serveren, maar een open source project. Of misschien heb je een serie geautomatiseerde bouwservers of continue integratie servers die vaak wijzigen, en wil je niet doorlopend SSH sleutels hoeven genereren – je wil gewoon eenvoudige leestoegang toevoegen.

Waarschijnlijk is de eenvoudigste manier voor kleinschalige opstellingen om een statische webserver in te stellen, waarbij de document root naar de plaats van je Git repositories wijst, en dan die `post-update` haak aanzetten waar we het in de eerste sectie van dit hoofdstuk over gehad hebben. Laten we eens uitgaan van het vorige voorbeeld. Stel dat je je repositories in de `/opt/git` map hebt staan, en er draait een Apache server op je machine. Nogmaals, je kunt hiervoor iedere web server gebruiken: maar als voorbeeld zullen we wat basis Apache configuraties laten zien, die je een idee kunnen geven van wat je nodig hebt.

Eerst moet je de haak aanzetten:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Als je een lagere versie dan 1.6 van Git gebruikt, dan is het `mv` commando niet nodig – Git is recentelijk pas begonnen met de namen van de haak voorbeelden op .sample te laten eindigen.

Wat doet deze `post-update` haak? Het ziet er ongeveer zo uit:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Dit betekent dat wanneer je naar de server via SSH pushed, Git dit commando uitvoert om de benodigde bestanden voor HTTP fetching te verversen.

Vervolgens moet je een VirtualHost toevoeging in je Apache configuratie aanmaken, met de document root als de hoofdmap van je Git projecten. Hier nemen we aan dat je joker DNS ingesteld hebt om `*.gitserver` door te sturen naar waar je dit alles draait:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Je zult ook de Unix gebruikers groep van de `/opt/git` mappen moeten instellen op `www-data` zodat je web server leestoegang heeft op de repositories, omdat de Apache instantie die het CGI script uitvoert (standaard) als die gebruiker draait:

	$ chgrp -R www-data /opt/git

Als je Apache herstart, dan zou je je repositories onder die map moeten kunnen clonen door de URL van je project te specificeren:

	$ git clone http://git.gitserver/project.git

Op deze manier kun je HTTP-gebaseerde toegang voor ieder van je projecten voor een groot aantal gebruikers in slechts een paar minuten instellen. Een andere eenvoudige optie om publieke ongeverifieerde toegang in te stellen is een Git daemon starten, alhoewel dat vereist dat je het proces als daemon uitvoert – we beschrijven deze optie in de volgende sectie als je een voorkeur hebt voor die route.

## GitWeb ##

Nu dat je basis lees/schrijf en alleen-lezen toegang tot je project hebt, wil je misschien een eenvoudige web-gebaseerde visualiseerder instellen. Git levert een CGI script genaamd GitWeb mee, dat veelal voor hiervoor gebruikt wordt. Je kunt GitWeb in gebruik zien bij sites zoals `http://git.kernel.org` (zie Figuur 4-1).

Insert 18333fig0401.png 
Figuur 4-1. De GitWeb web-gebaseerde gebruikers interface.

Als je wil zien hoe GitWeb er op jouw project uitziet, dan heeft Git een commando waarmee je een tijdelijke instantie op kunt starten als je een lichtgewicht server op je systeem hebt zoals `lighttpd` of `webrick`. Op Linux machines is `lighttpd` vaak geinstalleerd, dus je kunt het misschien draaiend krijgen door `git instaweb` in te typen in je project map. Als je op een Mac werkt: Leopard heeft Ruby voorgeinstalleerd, dus `webrick` zou je beste gok kunnen zijn. Om `instaweb` met een server anders dan lighttpd te starten, kun je het uitvoeren met de `--httpd` optie.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Dat start een HTTPD server op poort 1234 op en start automatisch een web browser op die met die pagina opent. Het is dus makkelijk voor jou. Als je klaar bent en de server wilt afsluiten, dan kun je hetzelfde commando uitvoeren met de `--stop` optie:

	$ git instaweb --httpd=webrick --stop

Als je de web interface doorlopend op een server wilt draaien voor je team of voor een open source project dat je serveert, dan moet je het CGI script instellen zodat het door je normale web server geserveerd wordt. Sommige Linux distributies hebben een `gitweb` pakket dat je misschien kunt installeren via `apt` of `yum`, dus misschien wil je dat eerst proberen. We zullen zeer binnenkort door een handmatige GitWeb installatie heenlopen. Eerst moet je de Git broncode pakken, waar GitWeb bij zit, en het persoonlijke CGI script genereren: 

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Let op dat je het commando moet vertellen waar het je Git repositories kan vinden met de `GITWEB_PROJECTROOT` variabele. Nu moet je zorgen dat de Apache server CGI gebruikt voor dat script, waarvoor je een VirtualHost kunt toevoegen:

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

Nogmaals, GitWeb kan geserveerd worden met iedere CGI capabele web server; als je iets anders prefereert zou het niet moeilijk in te stellen moeten zijn. Op dit punt zou je in staat moeten zijn om `http://gitserver/` te bezoeken en je repositories online te zien, en kun je `http://git.gitserver` gebruiken om je repositories over HTTP te clonen en te fetchen.

## Gitosis ##

De publieke sleutels van alle gebruikers in een `authorized_keys` bestand bewaren voor toegang werkt slechts korte tijd goed. Als je honderden gebruikers hebt, dan is het moeizaam om dat proces te beheersen. Je moet iedere keer in de server inloggen, en er is geen toegangscontrole – iedereen in het bestand heeft lees- en schrijftoegang op ieder project.

Op dit punt wil je je misschien wenden tot een veelgebruikt software project genaamd Gitosis. Gitosis is in feite een set scripts die je helpen het `authorized_keys` bestand te beheren en eenvoudige toegangscontrole te implementeren. Het meest interessante gedeelte is dat de gebruikers interface voor deze applicatie om mensen toe te voegen en toegang te bepalen, geen web interface is maar een speciale Git repository. Je stelt de informatie in in dat project; en als je het pushed, dan herconfigureert Gitosis de server op basis van dat project, wat stoer is.

Gitosis installeren is niet de makkelijkste taak ooit, maar het is ook niet te moeilijk. Het is het makkelijkst om er een Linux server voor te gebruiken – deze voorbeelden gebruiken een standaard Ubuntu 8.10 server.

Gitosis vereist wat Python applicaties, dus moet je eerst het Python setuptools pakket installeren, wat Ubuntu meelevert als python-setuptools:

	$ apt-get install python-setuptools

Vervolgens clone en installeer je Gitosis van de hoofdpagina van het project:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Daarmee worden een aantal bestanden geinstalleerd, die Gitosis zal gebruiken. Daarna wil Gitosis zijn repositories onder `/home/git` stoppen, wat prima is. Maar je hebt je repositories al in `/opt/git` geconfigureerd, dus in plaats van alles te herconfigureren maken we een symbolische link aan:

	$ ln -s /opt/git /home/git/repositories

Gitosis zal je sleutels voor je beheren, dus je moet het huidige bestand verwijderen, de sleutels later opnieuw toevoegen en Gitosis het `authorized_keys` bestand automatisch laten beheren. Voor nu verplaatsen we het `authorized_keys` bestand:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Nu moet je je shell terugzetten voor de 'git' gebruiker, als je het veranderd hebt naar het `git-shell` commando. Mensen zullen nog steeds niet in staat zijn in te loggen, maar Gitosis zal dat voor je beheren. Dus, laten we deze regel veranderen in je `/etc/passwd` bestand

	git:x:1000:1000::/home/git:/usr/bin/git-shell

terug naar dit:

	git:x:1000:1000::/home/git:/bin/sh

Nu wordt het tijd om Gitosis te initialiseren. Je doet dit door het `gitosis-init` commando met je eigen publieke sleutel uit te voeren. Als je publieke sleutel niet op de server staat zul je het daar naartoe moeten kopieeren:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Dit staat de gebruiker met die sleutel toe de hoofd Git repository, die de Gitosis installatie beheert, aan te passen. Daarna zul je met de hand het execute
bit op het `post-update` script moeten instellen voor je nieuwe beheer repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Je bent nu klaar om te gaan. Als je alles juist hebt ingesteld, kun je nu met SSH in je server loggen als de gebruiker waarvoor je de publieke sleutel hebt toegevoegd om Gitosis te initialiseren. Je zou dan zoiets als dit moeten zien:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Dat betekent dat Gitosis je herkend heeft, maar je buitensluit omdat je geen Git commando's aan het doen bent. Dus, laten we een echt Git commando doen – je gaat de Gitosis beheer repository clonen:

	# op je locale computer
	$ git clone git@gitserver:gitosis-admin.git

Nu heb je een map genaamd `gitosis-admin`, die twee gedeeltes heeft:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Het `gitosis.conf` bestand is het beheer bestand, dat je zult gebruiken om gebruikers, repositories en permissies te specificeren. De `keydir` map is de plaats waar je de publieke sleutels opslaat van alle gebruikers die een vorm van toegang tot je repositories hebben – één bestand per gebruiker. De naam van het bestand in `keydir` (in het vorige voorbeeld, `scott.pub`) zal anders voor jou zijn – Gitosis haalt de naam uit de beschrijving aan het einde van de publieke sleutel die was geimporteerd met het `gitosis-init` script.

Als je naar het `gitosis.conf` bestand kijkt, zou het alleen informatie over het zojuist geclonede `gitosis-admin` project mogen bevatten:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Het laat je zien dat de gebruiker 'scott' – de gebruiker met wiens publieke sleutel je Gitosis geinitialiseerd hebt – de enige is die toegang heeft tot het `gitosis-admin project.

Laten we een nieuw project voor je toevoegen. Je voegt een nieuwe sectie genaamd `mobile` toe, waar je de ontwikkelaars in je mobile team neerzet, en de projecten waar deze ontwikkelaars toegang tot moeten hebben. Omdat 'scott' op het moment de enige gebruiker in het systeem is, zul je hem als enig lid toevoegen en zul je een nieuw project genaamd `iphone_project` toevoegen om mee te beginnen:

	[group mobile]
	writable = iphone_project
	members = scott

Wanneer je wijzigingen aan het `gitosis-admin` project moet maken, moet je de veranderingen committen en terug pushen naar de server voordat ze effect hebben:

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

Je kunt je eerste push naar het nieuwe `iphone_project` doen door je server als een remote aan je locale versie van je project toe te voegen en te pushen. Je hoeft geen bare repositories handmatig meer te maken voor nieuwe projecten op de server – Gitosis maakt ze automatisch als het de eerste push ziet:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Merk op dat je geen pad hoeft te specificeren (sterker nog, het wel doen zal niet werken), alleen een dubbele punt en dan de naam van het project – Gitosis zal het voor je vinden.

Je wil samen met je vrienden aan dit project werken, dus je zult hun publieke sleutels weer toe moeten voegen. Maar in plaats van ze handmatig aan het `~/.ssh/authorized_keys` bestand op je server toe te voegen, voeg je ze, één sleutel per bestand, aan de `keydir` map toe. Hoe je de sleutels noemt bepaalt hoe je aan de gebruikers refereert in het `gitosis.conf` bestand. Laten we de publieke sleutels voor John, Josie en Jessica toevoegen:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Nu kun je ze allemaal aan je 'mobile' team toevoegen zodat ze lees- en schrijftoegang hebben tot het `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Daarna commit en push je de wijziging, waarna vier gebruikers in staat zullen zijn te lezen en te schrijven van en naar dat project.

Gitosis heeft ook eenvoudige toegangscontrole. Als je wilt dat John alleen lees toegang tot dit project heeft, dan kun je in plaats daarvan dit doen:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Nu kan John het project clonen en updates krijgen, maar Gitosis zal hem niet toestaan om terug naar het project te pushen. Je kunt zoveel van deze groepen maken als je wilt, waarbij ze allen verschillende gebruikers en projecten mogen bevatten. Je kunt ook een andere groep als een van de leden specificeren (waarbij je `@` als prefix gebruikt), om alle leden automatisch over te erven:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Als je problemen hebt, kan het handig zijn om `loglevel=DEBUG` onder de `[gitosis] sectie te zetten. Als je je push-toegang bent verloren door een kapotte configuratie te pushen, kun je het handmatig repareren in het bestand `/home/git/.gitosis.conf` op de server – het bestand waar Gitosis zijn informatie vandaan haalt. Een push naar het project neemt het `gitosis.conf` bestand dat je zojuist gepushed hebt en stopt het daar. Als je het bestand handmatig aanpast, zal het zo blijven totdat de volgende succesvolle push gedaan wordt naar het `gitosis-admin` project. 

## Git Daemon ##

Voor publieke ongeverifieerde leestoegang tot je projecten zul je het HTTP protocol achter je willen laten, en overstappen op het Git protocol. De hoofdreden is snelheid. Het Git protocol is veel efficienter en daarmee sneller dan het HTTP protocol, dus het zal je gebruikers tijd besparen.

Nogmaals, dit is voor ongeverifieerde alleen-lezen toegang. Als je dit op een server buiten je firewall draait, zul je het alleen moeten gebruiken voor projecten die voor de hele wereld toegankelijk moeten zijn. Als de server waarop je het draait binnen je firewall staat, zou je het kunnen gebruiken voor projecten waarbij een groot aantal mensen of computers (continue integratie of bouwservers) alleen-lezen toegang moeten hebben, waarbij je niet voor iedereen een SSH sleutel wilt toevoegen.

In ieder geval is het Git protocol relatief eenvoudig in te stellen. Eigenlijk is het enige dat je moet doen dit commando een daemon uitvoeren:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` staat de server toe om te herstarten zonder te wachten tot oude connecties een time out krijgen, de `--base-path` optie staat mensen toe om projecten te clonen zonder het volledige pad te specificeren, en het pad aan het einde vertelt de Git daemon waar hij moet kijken voor de te exporteren repositories. Als je een firewall draait, zul je er ook een gat in moeten maken in poort 9418 op de machine waar je dit op instelt.

Je kunt dit proces op een aantal manieren daemonisern, afhankelijk van het besturingssystem waarop je draait. Op een Ubuntu machine, zul je een Upstart script gebruiken. Dus in het volgende bestand

	/etc/event.d/local-git-daemon

stop je dit script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Omwille van veiligheidsredenen, wordt sterk aangeraden om deze daemon uit te voeren als gebruiker met alleen-lezen toegang op de repositories – je kunt dit makkelijk doen door een gebruiker 'git-ro' aan te maken en de daemon als deze uit te voeren. Om het eenvoudig te houden voeren we het als dezelfde 'git' gebruiker uit, als waarin Gitosis draait.

Als je je machine herstart, zal je Git daemon automatisch opstarten en herstarten als hij onderuit gaat. Om het te laten draaien zonder te herstarten, kun je dit uitvoeren:

	initctl start local-git-daemon

Op andere systemen zul je misschien `xinetd` willen gebruiken, een script in je `sysvinit` systeem, of iets anders – zolang je dat commando maar ge-daemoniseerd krijgt en op een of andere manier in de gaten gehouden wordt.

Vervolgens zul je je Gitosis server moeten vertellen welke repositories je ongeverifieerde Gitserver gebaseerde toegang toestaat. Als je een sectie toevoegt voor iedere repository, dan kun je die repositories specificeren waarop je je Git daemon wilt laten lezen. Als je Git protocol toegang tot je iphone project wilt toestaan, dan voeg je dit toe aan het eind van het `gitosis.conf` bestand:

	[repo iphone_project]
	daemon = yes

Als dat gecommit en gepushed is, dan zou je draaiende daemon verzoeken moeten serveren aan iedereen die toegang heeft op poort 9418 van je server.

Als je besluit om Gitosis niet te gebruiken, maar je wilt toch een Git daemon instellen, dan moet je dit op ieder project uitvoeren waarvoor je de Git daemon wilt laten serveren:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

De aanwezigheid van dat bestand vertelt Git dat het OK is om dit project zonder verificatie te serveren.

Gitosis kan ook de projecten die GitWeb toont beheren. Eerst moet je zoiets als het volgende aan het `/etc/gitweb.conf` bestand toevoegen:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Je kunt instellen welke projecten GitWeb gebruikers laat bladeren door een `gitweb` instelling in het Gitosis configuratie bestand toe te voegen, of te verwijderen. Bijvoorbeeld, als je het iphone project op GitWeb wilt tonen, zorg je dat de `repo` instelling er zo uitziet:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Als je nu het project commit en pushed, start GitWeb automatisch met het tonen van je iphone project.

## Hosted Git ##

Als je niet door al het werk heen wilt om je eigen Git server op te zetten, heb je meerdere opties om je Git project op een externe speciale hosting pagina te laten beheren. Dit biedt een aantal voordelen: een ge-hoste pagina is over het algemeen snel in te stellen, en eenvoudig om projecten op te starten, en er komt geen server beheer en onderhoud bij kijken. Zelfs als je je eigen server intern ingesteld hebt, zul je misschien een publieke host pagina voor je open source broncode willen – dat is over het algemeen makkelijker voor de open source commune te vinden en je er mee te helpen.

Vandaag de dag heb je een enorm aantal beheer opties om uit te kiezen, elk met verschillende voor- en nadelen. Om een bijgewerkte lijst te zien, ga dan kijken op de GitHosting pagina op de hoofd Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Omdat we ze niet allemaal kunnen behandelen, en ik toevalllig bij een ervan werk, zullen we deze sectie gebruiken om door het instellen van een account en het opzetten van een project op GitHub lopen. Dit geeft je een idee van het benodigde werk.

GitHub is veruit de grootste open source Git beheer pagina en het is ook een van de weinige die zowel publieke als privé beheer opties biedt, zodat je je open source en commerciele privé code in dezelfde plaats kunt bewaren. Sterker nog, we hebben GitHub gebruikt om privé samen te werken aan dit boek.

### GitHub ###

GitHub verschilt een beetje van de meeste code-beheer pagina's in de manier waarop het de projecten een naamruimte geeft. In plaats dat het primair gebaseerd is op het project, stelt GitHub gebruikers centraal. Dat betekent dat als ik mijn `grit` project op GitHub beheer, je het niet zult vinden op `github.com/grit` maar in plaats daarvan op `github.com/schacon/grit`. Er is geen generieke versie van een project, wat een project toestaat om naadloos van de ene op de andere gebruiker over te gaan als de eerste auteur het project verlaat.

GitHub is ook een commercieel bedrijf dat geld vraagt voor accounts die privé repositories beheren, maar iedereen kan snel een gratis account krijgen om zoveel open source projecten als ze willen te beheren. We zullen er snel doorheen lopen hoe je dat doet.

### Een Gebruikers Account Instellen ###

Het eerste dat je moet doen is een gratis gebruikers account instellen. Als je de Pricing and Signup pagina op `http://github.com/plans` bezoekt en de "Sign Up" knop aanklikt op het gratis account (zie figuur 4-2), dan wordt je naar de inteken pagina gebracht.

Insert 18333fig0402.png
Figuur 4-2. De GitHub inteken pagina.

Hier moet je een gebruikersnaam kiezen die nog niet bezet is in het systeem, en een e-mail adres invullen dat bij het account hoort, en een wachtwoord (zie Figuur 4-3).

Insert 18333fig0403.png 
Figuur 4-3. Het GitHub gebruikers inteken formulier.

Als je account beschikbaar hebt, is dit een goed moment om je publieke SSH sleutel ook toe te voegen. We hebben je eerder laten zien hoe je een nieuwe sleutel kunt genereren, in de "Eenvoudige Instellingen" sectie. Neem de inhoud van de publieke sleutel van dat paar, en plak het in het SSH publieke sleutel tekstveld. Door op de "explain ssh keys" link te klikken wordt je naar gedetaileerde instructies gebracht die je vertellen hoe dit te doen op alle veelgebruikte besturingssystemen.
Door op de "I agree, sign me up" knop te klikken wordt je naar je nieuwe gebruikers dashboard gebracht (zie Figuur 4-4).

Insert 18333fig0404.png 
Figuur 4-4. Het GitHub gebruikers dashboard.

Vervolgens kun je een nieuw repository aanmaken.

### Een Nieuw Repository Aanmaken ###

Start door op de "create a new one" link te klikken naast Your Repositories op het gebruikers dashboard. Je wordt naar het Create a New Repository formulier gebracht (zie Figuur 4-5).

Insert 18333fig0405.png 
Figuur 4-5. Een nieuw repository aanmaken op GitHub.

Het enige dat je eigenlijk moet doen is een projectnaam opgeven, maar je kunt ook een beschrijving toevoegen. Wanneer je dat gedaan hebt, klik dan op de "Create Repository" knop. Nu heb je een nieuw repository op GitHub (zie Figuur 4-6).

Insert 18333fig0406.png 
Figuur 4-6. GitHub project hoofd informatie.

Omdat je er nog geen code hebt, zal GitHub je de instructies tonen hoe je een splinternieuw project moet aanmaken, een bestaand Git project moet pushen, of een project van een publieke Subversion repository moet importeren (zie Figuur 4-7).

Insert 18333fig0407.png 
Figuur 4-7. Instructies voor een nieuwe repository.

Deze instructies zijn vergelijkbaar met wat we al hebben laten zien. Om een project te initialiseren dat nog geen Git project is, gebruik je

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Als je een lokaal Git repository hebt, voeg dan GitHub als remote toe en push je master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Nu wordt je project beheerd op GitHub, en kun je de URL aan iedereen geven waarmee je je project wilt delen. In dit geval is het `http://githup.com/testinguser/iphone_project`. Je kunt aan het begin van ieder van je project pagina's zien dat je twee Git URLs hebt (zie Figuur 4-8).

Insert 18333fig0408.png 
Figuur 4-8. Project met een publieke URL en een privé URL.

De publieke Clone URL is een publieke alleen-lezen Git URL, waarmee iedereen het project kan clonen. Deel deze URL maar gewoon uit en zet 'm op je website of wat je ook hebt.

De Your Clone URL is een lees/schrijf SSH-gebaseerde URL waar je alleen over kunt lezen of schrijven als je connectie maakt met de privé SSH sleutel die geassocieerd is met de publieke sleutel die je voor jouw gebruiker geupload hebt. Wanneer andere gebruikers deze project pagina bezoeken, zullen ze die URL niet zien – alleen de publieke.

### Importeren vanuit Subversion ###

Als je een bestaande publiek Subversion project hebt dat je in Git wilt importeren, kan GitHub dat vaak voor je doen. Aan de onderkant van de instructies pagina staat een link naar een Subversion import. Als je die aanklikt, zie je een formulier met informatie over het importeer proces een een tekstveld waar je de URL van je publieke Subversion project in kan plakken (zie Figuur 4-9).

Insert 18333fig0409.png 
Figuur 4-9. Subversion importeer interface.

Als je project erg groot is, niet standaard, of privé, dan zal dit process waarschijnlijk niet voor je werken. In Hoofdstuk 7 zul je leren om meer gecompliceerde handmatige project imports te doen.

### Medewerkers Toevoegen ###

Laten we de rest van het team toevoegen. Als John, Josie en Jessica allemaal intekenen voor accounts op GitHub, en je wilt ze push toegang op je repository geven, kun je ze aan je project toevoegen als medewerkers. Door dat te doen zullen pushes vanaf hun publieke sleutels werken.

Klik de "edit" knop aan de bovenkant van het project, of de Admin tab, om de Admin pagina te bereiken van je GitHub project (zie Figuur 4-10).

Insert 18333fig0410.png 
Figuur 4-10. GitHub administratie pagina.

Om een andere gebruiker schrijftoegang tot je project te geven, klik dan de "Add another collaborator" link. Er verschijnt een nieuw tekstveld, waarin je een gebruikersnaam kunt invullen. Op het moment dat je typt, komt er een hulp omhoog, waarin alle mogelijke overeenkomende gebruikersnamen staan. Als je de juiste gebruiker vind, klik dan de Add knop om die gebruiker als een medewerker aan je project toe te voegen (zie Figuur 4-11). 

Insert 18333fig0411.png 
Figuur 4-11. Een medewerker aan je project toevoegen.

Als je klaar bent met medewerkers toevoegen, dan zou je een lijst met de namen moeten zien in het Repository Collaborators veld (zie Figuur 4-12).

Insert 18333fig0412.png 
Figuur 4-12. Een lijst met medewerkers aan je project.

Als je toegang van individuen moet intrekken, dan kun je de "revoke" link klikken, en dan wordt hun push toegang ingetrokken. Voor toekomstige projecten, kun je ook de medewerker groepen kopieeren door de permissies van een bestaand project te kopieeren.

### Je Project ###

Nadat je je project gepushed hebt, of geimporteerd vanuit Subversion, heb je een hoofd project pagina die er uitziet zoals Figuur 4-13.

Insert 18333fig0413.png 
Figuur 4-13. Een GitHub project hoofpagina.

Als mensen je project bezoeken, zien ze deze pagina. Het bevat tabs naar de verschillende aspecten van je projecten. De Commits tab laat een lijst van commits in omgekeerde chronologische volgorde zien, vergelijkbaar met de output van het `git log` commando. De Network tab toont alle mensen die je project hebben geforked en bijgedragen hebben. De Downloads tab staat je toe project binaries te uploaden en naar tarballs en gezipte versies van ieder getagged punt in je project te linken. De Wiki tab voorziet in een wiki waar je documentatie kunt schrijven of andere informatie over je project. De Graphs tab heeft wat contributie visualisaties en statistieken over je project. De hoofd Source tab waarop je binnen komt toont de inhoud van de hoofdmap van je project en toont automatisch het README bestand eronder als je er een hebt. Deze tab toont ook een veld met de laatste commit informatie.

### Projecten Forken ###

Als je aan een bestaand project waarop je geen push toegang hebt wilt bijdragen, dan moedigt GitHub het forken van een project toe. Als je op een project pagina belandt, die interessant lijkt en je wilt er een beetje op hacken, dan kun je de "fork" knop klikken aan de bovenkant van het project om GitHub dat project te laten kopieeren naar jouw gebruiker zodat je er naar kunt pushen.

Op deze manier hoeven projecten zich geen zorgen te maken over het toevoegen van medewerkers om ze push toegang te geven. Mensen kunnen een project forken en ernaar pushen, en de hoofdeigenaar van het project kan die wijzigingen pullen door ze als remotes toe te voegen en hun werk te mergen.

Om een project te forken, bezoek dan de project pagina (in dit geval, mojombo/chronic) en klik de "fork" knop aan de bovenkant (zie Figuur 4-14).

Insert 18333fig0414.png 
Figuur 4-14. Een schrijfbare kopie van een project krijgen door de "fork" knop te klikken.

Na een paar seconden wordt je naar je nieuwe project pagina gebracht, wat aangeeft dat dit project een fork is van een ander (zie Figuur 4-15).

Insert 18333fig0415.png 
Figuur 4-15. Jouw fork van een project.

### GitHub Samenvatting ###

Dat is alles wat we laten zien over GitHub, maar het is belangrijk om te zien hoe makkelijk je dit allemaal kunt doen. Je kunt een nieuw account aanmaken, een nieuw project toevoegen en ernaar pushen binnen een paar minuten. Als je project open source is, kun je ook een enorme ontwikkelaars gemeenschap krijgen die nu zicht hebben op je project en het misschien forken en eraan helpen bijdragen. Op z'n minst is dit een snelle manier om met Git aan de slag te gaan en het snel uit te proberen.

## Samenvatting ##

Je hebt meerdere opties om een remote Git repository werkend te krijgen zodat je kunt samenwerken met anderen of je werk kunt delen.

Je eigen server draaien geeft je veel controle en staat je toe om de server binnen je firewall te draaien, maar zo'n server vraagt over het algemeen een redelijke hoeveelheid tijd om in te stellen en te onderhouden. Als je je gegevens op een beheerde server plaatst, is het eenvoudig in te stellen en te onderhouden; maar je moet in staat zijn je code op iemand anders zijn servers te bewaren, en sommige organisaties staan dit niet toe.

Het zou redelijk rechttoe rechtaan moeten zijn om te bepalen welke oplossing of combinatie van oplossingen van toepassing is op jou en je organisatie.
