# Git op de Server #

Op dit punt zou je alledaagse taken waarvoor je Git zult gebruiken kunnen doen. Maar, om samen te kunnen werken in Git zul je een remote repository moeten hebben. Technisch gezien kun je wijzigingen pushen en pullen van individuele repositories, maar dat wordt afgeraden, omdat je vrij gemakkelijk het werk waar anderen mee bezig zijn in de war kunt schoppen als je niet oppast. Daarnaast wil je dat je medewerkers de repository kunnen bereiken, zelfs als jouw computer van het netwerk is – het hebben van een betrouwbare gezamenlijke repository is vaak handig. De voorkeursmethode om met iemand samen te werken is om een tussenliggende repository in te richten waar beide partijen toegang to hebben en om daar naartoe te pushen en vandaan te pullen. We zullen deze repository de `Git server` noemen, maar je zult zien dat het over het algemeen maar een klein beetje systeembronnen kost om een Git repository te verzorgen, dus je zult er zelden een complete server voor nodig hebben.

Een Git server draaien is eenvoudig. Als eerste kies je met welke protocollen je de server wilt laten communiceren. Het eerste gedeelte van dit hoofdstuk zullen we de beschikbare protocollen bespreken met de voor- en nadelen van elk. De daarop volgende paragrafen zullen we een aantal veel voorkomende opstellingen bespreken die van die protocollen gebruik maken en hoe je je server ermee kunt opzetten. Als laatste laten we een paar servers van derden zien, als je het niet erg vindt om je code op de server van een ander te zetten en niet het gedoe wilt hebben van het opzetten en onderhouden van je eigen server.

Als je niet van plan bent om je eigen server te draaien, dan kun je de direct naar de laatste paragraaf van dit hoofdstuk gaan om wat mogelijkheden van online accounts te zien en dan door gaan naar het volgende hoofdstuk, waar we diverse zaken bespreken die komen kijken bij het werken met een gedistribueerde versiebeheer omgeving.

Een remote repository is over het algemeen een _bare repository_ (kale repository) – een Git repository dat geen werkmap heeft. Omdat de repository alleen gebruikt wordt als een samenwerkingspunt, is er geen reden om een snapshot op de schijf te hebben; het is alleen de Git data. Een kale repository is eenvoudigweg de inhoud van de `.git` map in je project, en niets meer.

## De Protocollen ##

Git kan vier veel voorkomende netwerk protocollen gebruiken om data te transporteren: Lokaal, Beveiligde Shell (Secure Shell, SSH), Git en HTTP. Hier bespreken we wat deze zijn, en in welke omstandigheden je ze zou willen gebruiken (of juist niet).

Het is belangrijk om op te merken dat, met uitzondering van de HTTP protocollen, ze allemaal een werkende Git versie op de server geïnstalleerd moeten hebben.

### Lokaal Protocol ###

Het simpelste is het _Lokale protocol_, waarbij de remote repository in een andere directory op de schijf staat. Deze opzet wordt vaak gebruikt als iedereen in het team toegang heeft op een gedeeld bestandssyteem zoals een NFS mount, of in het weinig voorkomende geval dat iedereen op dezelfde computer werkt. Het laatste zou niet ideaal zijn, want dan zouden alle repositories op dezelfde computer staan, zodat een fataal verlies van gegevens veel groter wordt.

Als je een gedeeld bestandssyteem hebt, dan kun je clonen, pushen en pullen van een op een lokaal bestand aanwezige repository. Om een dergelijk repository te clonen, of om er een als een remote aan een bestaand project toe te voegen, moet je het pad naar het repository als URL gebruiken. Bijvoorbeeld, om een lokaal repository te clonen, kun je zoiets als het volgende uitvoeren:

	$ git clone /opt/git/project.git

Of je kunt dit doen:

	$ git clone file:///opt/git/project.git

Git werkt iets anders als je explicite `file://` aan het begin van de URL zet. Als je alleen het pad specificeert, probeert Git hardlinks te gebruiken, of het kopieert de bestanden die het nodig heeft. Als je `file://` specificeert, dan start Git de processen die het normaal gesproken gebruikt om data te transporteren over een netwerk, wat over het algemeen een minder efficiënte methode is om gegevens over te dragen. De belangrijkste reden om `file://` wel te specificeren is als je een schone kopie van de repository wilt met de vreemde refenties of objecten eruit gelaten – over het algemeen na een import uit een ander versiebeheer systeem of iets dergelijks (zie Hoofdstuk 9 voor onderhoudstaken). We zullen het normale pad hier gebruiken, omdat het bijna altijd sneller is om het zo te doen.

Om een lokale repository aan een bestaand Git project toe te voegen, kun je iets als het volgende uitvoeren:

	$ git remote add local_proj /opt/git/project.git

Daarna kun je op gelijke wijze pushen naar, en pullen van die remote als je over een netwerk zou doen.

#### De Voordelen ####

De voordelen van bestands-gebaseerde repositories zijn dat ze eenvoudig zijn en ze maken gebruik van bestaande bestandspermissies en netwerk toegang. Als je al een gedeeld bestandssysteem hebt, waar het hele team al toegang toe heeft, dan is een repository opzetten heel gemakkelijk. Je stopt de kale repository ergens waar iedereen gedeelde toegang tot heeft, en stelt de lees- en schrijfrechten in zoals je dat bij iedere andere gedeelde directory zou doen. In de volgende paragraaf "Git op een Server Krijgen" bespreken we hoe je een kopie van een kale repository kunt exporteren voor dit doeleinde.

Dit is ook een prettige optie om snel werk uit een repository van iemand anders te pakken. Als jij en een collega aan hetzelfde project werken, en hij wil dat je iets bekijkt, dan is het uitvoeren van een commando zoals `git pull /home/john/project` vaak makkelijker dan dat hij naar een remote server moet pushen, en jij er van moet pullen.

#### De Nadelen ####

Een van de nadelen van deze methode is dat gedeelde toegang over het algemeen moeilijker op te zetten en te bereiken is vanaf meerdere lokaties dan simpele netwerk toegang. Als je wilt pushen van je laptop als je thuis bent, dan moet je de remote schijf aankoppelen, wat moeilijk en langzaam kan zijn als je het vergelijkt met netwerk gebaseerde toegang.

Het is ook belangrijk om te vermelden dat het niet altijd de snelste optie is, als je een gedeeld koppelpunt (mount) of iets dergelijks gebruikt. Een lokale repository is alleen snel als je snelle toegang tot de data hebt. Een repository op NFS is vaak langzamer dan een repository via SSH op dezelfde server omdat dit Git in staat stelt om op lokale schijven te werken op elk van de betrokken systemen.

### Het SSH Protocol ###

Waarschijnlijk het meest voorkomende protocol voor Git is SSH. De reden hiervoor is dat toegang met SSH tot servers in veel plaatsen al geconfigureerd is – en als dat niet het geval is, dan is het eenvoudig om dat te doen. SSH is ook het enige netwerk gebaseerde protocol waarvan je makkelijk kunt lezen en naartoe kunt schrijven. De andere twee netwerk protocollen (HTTP en Git) zijn over het algemeen alleen-lezen, dus zelfs als je ze al beschikbaar hebt voor de ongeïnitieerde massas, dan heb je nog steeds SSH nodig voor je eigen schrijfcommandos. SSH is ook een geauthenticieerd protocol; en omdat het alom aanwezig is, is het over het algemeen eenvoudig om in te stellen en te gebruiken.

Om een Git repository via SSH te clonen, kun je een ssh:// URL opgeven zoals:

	$ git clone ssh://user@server:project.git

Of je geeft geen protocol op – Git gaat uit van SSH als je niet expliciet bent:
	
	$ git clone user@server:project.git

Je kunt ook de gebruiker weglaten, en Git gebruikt gegevens van de gebruiker waarmee je op dat moment bent ingelogd.

#### De Voordelen ####

Er zijn vele voordelen om SSH te gebruiken. Ten eerste moet je het eigenlijk wel gebruiken als je geauthenticeerde schrijftoegang op je repository via een netwerk wilt. Ten tweede is het relatief eenvoudig in te stellen – SSH daemons komen veel voor, veel systeembeheerders hebben er ervaring mee, en veel operating systemen zijn er mee uitgerust of hebben applicaties om ze te beheren. Daarnaast is toegang via SSH veilig – alle data transporten zijn versleuteld en geauthenticeerd. En als laatste is SSH efficiënt, net zoals het Git en lokale protocol, de gegevens worden zo compact mogelijk gemaakt voordat het getransporteerd wordt.

#### De Nadelen ####

Het negatieve aspect van SSH is dat je er geen anonieme toegang naar je repository over kunt geven. Mensen moeten via SSH toegang hebben om er gebruik van te kunnen maken, zelfs als het alleen lezen is, zodat SSH toegang niet bevordelijk is voor open source projecten. Als je het alleen binnen je bedrijfsnetwerk gebruikt, dan is SSH misschien het enige protocol waar je mee in aanraking komt. Als je anonieme alleen-lezen toegang wilt toestaan tot je projecten, dan moet je SSH voor jezelf instellen om over te pushen, maar iets anders voor anderen om over te pullen.

### Het Git Protocol ###

Het volgende is het Git protocol. Dit is een specifieke daemon, die met Git meegeleverd wordt; het luistert op een toegewezen poort (9418), en verleent een vergelijkbare dienst als het SSH protocol, maar dan zonder enige vorm van authenticatie. Om een repository beschikbaar te stellen over het Git protocol, moet je een `git-export-daemon-ok` bestand aanmaken – de daemon zal een repository zonder dit bestand erin niet verspreiden – maar daarbuiten is er geen beveiliging. De Git repository beschikbaar om gecloned te kunnen worden door iedereen, of het is het niet. Dit betekent dat er over het algemeen geen pushing is via dit protocol. Je kunt push toegang aanzetten, maar gegeven het gebrek aan authenticatie kan als je de push toegang aan zet iedereen die de URL van jouw project op het internet vindt, pushen naar jouw project. We volstaan met te zeggen dat dit zelden de bedoeling kan zijn.

#### De Voordelen ####

Het Git protocol is het snelste dat beschikbaar is. Als je veel verkeer verwerkt voor een publiek project, of een zeer groot project dat geen gebruikersauthenticatie nodig heeft voor leestoegang, dan is het waarschijnlijk dat je een Git daemon wilt inrichten om je project te verspreiden. Het maakt van hetzelfde data-transport mechanisme gebruik als het SSH protocol, maar dan zonder de extra belasting van versleuteling en authenticatie.

#### De Nadelen ####

Het nadeel van het Git protocol is het gebrek aan authenticatie. Het is over het algemeen onwenselijk dat het Git protocol de enige toegang tot je project is. Meestal zul je het samen met SSH toegang gebruiken voor de paar ontwikkelaars die push (schrijf-)toegang hebben en de rest laat je `git://` voor alleen leestoegang gebruiken.
Het is waarschijnlijk ook het meest ingewikkelde protocol om in te richten. Het moet een eigen daemon hebben, die speciaal voor die situatie ingericht is – we zullen er een instellen in het "Gitosis" gedeelte van dit hoofdstuk – het gebruikt `xinetd` configuratie of iets vergelijkbaars, wat ook niet altijd eenvoudig is op te zetten. Daarbij is ook firewall toegang tot poort 9418 nodig, wat geen standaard poort is dat in bedrijfsfirewalls is opengezet. Bij firewalls van grote bedrijven, is deze ongebruikelijke poort meestal dichtgezet.

### Het HTTP/S Protocol ###

Als laatste hebben we het HTTP protocol. Het mooie aan het HTTP of HTTPS protocol is dat het simpel in te stellen is. Eigenlijk is alles wat je moet doen de kale Git repository in je HTTP document root zetten, en een specifieke `post-update` hook (haak) instellen en je bent klaar (zie hoofdstuk 7 voor details over Git hooks). Vanaf dat moment kan iedereen die toegang heeft tot de webserver waar je de repository op gezet hebt ook je repository clonen. Om leestoegang tot je repository over HTTP toe te staan, doe je zoiets als het volgende:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Dat is alles. De `post-update` hook, die standaard bij Git geleverd wordt, voert het noodzakelijke commando uit (`git update-server-info`) om HTTP fetching en cloning goed werkend te krijgen en houden. Dit commando wordt uitgevoerd als je via SSH naar deze repository pushed; en andere mensen kunnen clonen met behulp van zoiets als

	$ git clone http://example.com/gitproject.git

In dit specifieke voorbeeld gebruiken we het `/var/www/htdocs` pad wat gebruikelijk is voor Apache opstellingen, maar je kunt iedere statische webserver gebruiken – stop de kale repository in het betreffende pad. De Git data wordt geserveerd als standaard statische bestanden (zie hoofdstuk 9 voor details over hoe het precies geserveerd wordt).

Het is mogelijk om Git ook over HTTP te laten pushen, alhoewel dat geen veelgebruikte techniek is en het vraagt dat je complexe WebDAV instellingen inricht. Omdat het zelden gebruikt wordt, zullen we het niet in dit boek beschrijven. Als je geïnteresseerd bent om de HTTP-push protocollen te gebruiken, dan kun je op `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` lezen hoe je een repository kunt maken. Het aardige van Git laten pushen over HTTP is dat je iedere WebDAV server kunt gebruiken, zonder specifieke Git funtionaliteit, dus je kunt deze functionaliteit gebruiken als je web-hosting provider WebDAV ondersteunt voor het maken van wijzigingen aan je webpagina.

#### De Voordelen ####

Het voordeel van het gebruik van het HTTP protocol is dat het eenvoudig in te stellen is. Een handvol benodigde commando's uitvoeren is alles wat er moet gebeuren om de wereld leestoegang te geven tot je Git repository. Het neemt maar een paar minuten van je tijd. Het HTTP protocol is niet erg belastend voor de systeembronnen van je server. Omdat het over het algemeen een statische webserver gebruikt om alle data te verspreiden - een normale Apache server kan gemiddeld duizenden bestanden zenden per seconde - is het moeilijk om zelfs een kleine server te overbelasten.

Je kunt ook je repositories alleen-lezen serveren via HTTPS, wat inhoudt dat je het transport kunt versleutelen; je kunt zelfs zover gaan dat je clients een specifiek gesigneerd SSL certificaat laat gebruiken. Normaal gesproken als je je deze moeite wilt getroosten, dan is het makkelijker om publieke SSH sleutels te gebruiken; maar het kan in jouw specifieke geval een betere oplossing zijn om gesigneerde SSL certificaten of andere HTTP-gebaseerde authenticatie methoden te gebruiken voor alleen-lezen toegang via HTTPS.

Een andere prettige bijkomstigheid is dat HTTP een dusdanig veel voorkomend protocol is dat bedrijfsfirewalls vaak zo ingesteld zijn dat ze verkeer via deze poort toestaan.

#### De Nadelen ####

Het nadeel van je repository verspreiden via HTTP is dat het relatief inefficiënt voor de client is. Over het algemeen duurt het een stuk langer om te clonen en te fetchen van de repository, en je hebt vaak een veel hogere netwerk belasting en transport volume via HTTP dan met elk van de andere netwerk protocollen. Omdat het niet zo ingewikkeld is om alleen de data te versturen die je nodig hebt – er wordt geen dynamisch werk door de server gedaan in deze uitwisselingen – wordt vaak naar het HTTP protocol gerefereerd als zijnde een _dom_ protocol. Voor meer informatie over de verschillen in efficiëntie tussen het HTTP protocol en andere protocollen, zie Hoofdstuk 9.

## Git op een Server Krijgen ##

Om een Git server initieel op te zetten, moet je een bestaande repository naar een kale repository exporteren – een repository dat geen werkmap bevat. Dit is over het algemeen eenvoudig te doen.
Om je repository te clonen met als doel het maken van een kale repository, voer je het clone commando uit met de `--bare` optie. Als conventie eindigen de namen van kale repository mappen met `.git`, zoals:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

De output van dit commando is een beetje verwarrend. Omdat `clone` eigenlijk een `git init` en dan een `git fetch` is, zien we de output van het `git init` gedeelte, wat een lege map aanmaakt. De eigenlijke object overdracht geeft geen output, maar het gebeurt wel. Nu zou je een kopie van de Git map data in je `my_project.git` map moeten hebben.

Dit is ongeveer gelijk aan

	$ cp -Rf my_project/.git my_project.git

Er zijn een paar kleine verschillen in het configuratie bestand, maar het komt op hetzelfde neer. Het neemt de Git repository zelf, zonder een werkmap, en maakt een map aan specifiek hiervoor.

### De Kale Repository op een Server Zetten ###

Nu je een kale kopie van je repository hebt, is het enige dat je moet doen het op een server zetten en je protocollen instellen. Laten we aannemen dat je een server ingericht hebt, die `git.example.com` heet, waar je SSH toegang op hebt, en waar je al je Git repositories wilt opslaan onder de `/opt/git` map. Je kunt je nieuwe repository beschikbaar stellen door je kale repository ernaartoe te kopiëren:

	$ scp -r my_project.git user@git.example.com:/opt/git

Vanaf dat moment kunnen andere gebruikers, die SSH toegang hebben tot dezelfde server en lees-toegang hebben tot de `/opt/git` map, jouw repository clonen door dit uit te voeren:

	$ git clone user@git.example.com:/opt/git/my_project.git

Als een gebruiker met SSH op een server inlogt en schrijftoegang heeft tot de `/opt/git/my_project.git` map, dan hebben ze automatisch ook push toegang. Git zal automatisch de correcte groep schrijfrechten aan een repository toekennen als je het `git init` commando met de `--shared` optie uitvoert.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Je ziet hoe eenvoudig het is om een Git repository te nemen, een kale versie aan te maken, en het op een server plaatsen waar jij en je medewerkers SSH toegang tot hebben. Nu zijn jullie klaar om aan hetzelfde project samen te werken.

Het is belangrijk om op te merken dat dit letterlijk alles is wat je moet doen om een bruikbare Git server te draaien waarop meerdere mensen toegang hebben – maak alleen een paar accounts met SSH toegang aan op een server, en stop een kale repository ergens waar al die gebruikers lees- en schrijftoegang toe hebben. Je bent er klaar voor – je hebt niets anders nodig.

In de volgende paragrafen zul je zien hoe je meer ingewikkelde opstellingen kunt maken. Deze bespreking zal het niet hoeven aanmaken van gebruikers accounts voor elke gebruiker, publieke leestoegang tot repositories, grafische web interfaces, het gebruik van de Gitosis applicatie en meer omvatten. Maar, hou in gedachten dat om samen te kunnen werken met mensen op een privé project, alles wat je _nodig_ hebt een SSH server is en een kale repository.

### Kleine Opstellingen ###

Als je met een kleine groep bent of net begint met Git in je organisatie en slechts een paar ontwikkelaars hebt, dan kunnen de dingen eenvoudig voor je zijn. Een van de meest gecompliceerde aspecten van een Git server instellen is het beheren van gebruikers. Als je sommige repositories alleen-lezen voor bepaalde gebruikers wilt hebben, en lezen/schrijven voor anderen, dan kunnen toegang en permissies een beetje lastig in te stellen zijn.

#### SSH Toegang ####

Als je al een server hebt waar al je ontwikkelaars SSH toegang op hebben, dan is het over het algemeen het eenvoudigste om je eerste repository daar op te zetten, omdat je dan bijna niets hoeft te doen (zoals beschreven in de vorige paragraaf). Als je meer complexe toegangscontrole wilt op je repositories, dan kun je ze instellen met de normale bestandssysteem permissies van het operating systeem dat op je server draait.

Als je je repositories op een server wilt zetten, die geen accounts heeft voor iedereen in je team die je schrijftoegang wilt geven, dan moet je SSH toegang voor ze opzetten. We gaan er vanuit dat je een server hebt waarmee je dit kunt doen, dat je reeds een SSH server geïnstalleerd hebt, en dat de manier is waarop je toegang hebt tot de server.

Er zijn een paar manieren waarop je iedereen in je team toegang kunt geven. De eerste is voor iedereen accounts aanmaken, wat rechttoe rechtaan is maar bewerkelijk kan zijn. Je wilt vermoedelijk niet `adduser` uitvoeren en tijdelijke wachtwoorden instellen voor iedere gebruiker.

Een tweede methode is een generieke 'git' gebruiker aan te maken op de machine, aan iedere gebruiker die schijftoegang moet hebben vragen of ze je een publieke SSH sleutel sturen, en die sleutel toevoegen aan het `~/.ssh/authorized_keys` bestand van die nieuwe 'git' gebruiker. Vanaf dat moment zal iedereen toegang hebben op die machine via de 'git' gebruiker. Dit tast de commit data op geen enkele manier aan – de SSH gebruiker waarmee je inlogt zal de commits die je opgeslagen hebt niet beïnvloeden.

Een andere manier waarop je het kunt doen is je SSH server laten authenticeren middels een LDAP server of een andere gecentraliseerde authenticatie bron, die misschien al ingericht is. Zolang iedere gebruiker shell toegang kan krijgen op de machine, zou ieder SSH authenticatie mechanisme dat je kunt bedenken moeten werken.

## Je Publieke SSH Sleutel Genereren ##

Dat gezegd hebbende, zijn er vele Git servers die authenticeren met een publieke SSH sleutel. Om een publieke sleutel te hebben, zal iedere gebruiker in je systeem er een moeten genereren als ze er nog geen hebben. Dit proces is bij alle operating systemen vergelijkbaar. Als eerste moet je controleren of je er niet al een hebt. Standaard staan de SSH sleutels van de gebruikers in hun eigen `~/.ssh` map. Je kunt makkelijk nagaan of je al een sleutel hebt door naar die map te gaan en de inhoud te bekijken:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Je bent op zoek naar een aantal bestanden genaamd iets en iets.pub, waarbij het `iets` meestal zoiets is als `id_dsa` of `id_rsa`. Het `.pub` bestand is je publieke sleutel en het andere bestand is je private sleutel. Als je deze bestanden niet hebt (of als je zelfs geen `.ssh` map hebt), dan kun je ze aanmaken door een applicatie genaamd `ssh-keygen` uit te voeren, deze wordt met het SSH pakket op Linux/Mac systemen meegeleverd en met het MSysGit pakket op Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Eerst wordt de lokatie waar je de sleutel wordt opgeslagen (`.ssh/id_rsa`) aangegeven, en vervolgens vraagt het tweemaal om een wachtwoord, die je leeg kunt laten als je geen wachtwoord wilt intypen op het moment dat je de sleutel gebruikt.

Iedere gebruiker die dit doet, moet zijn sleutel sturen naar jou of degene die de Git server beheert (aangenomen dat je een SSH server gebruikt die publieke sleutels vereist). Het enige dat ze hoeven doen is de inhoud van het `.pub` bestand kopiëren en e-mailen. De publieke sleutel ziet er ongeveer zo uit:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Voor een uitgebreide tutorial over het aanmaken van een SSH sleutel op meerdere operating systemen, verwijzen ze je naar de GitHub handleiding over SSH sleutels op `http://github.com/guides/providing-your-ssh-key`.

## De Server Opzetten ##

Laten we het opzetten van SSH toegang aan de server kant eens doorlopen. In dit voorbeeld zul je de `authorized_keys` methode gebruiken om je gebruikers te authenticeren. We gaan er ook vanuit dat je een standaard Linux distributie gebruikt zoals Ubuntu. Als eerste maak je een 'git' gebruiker aan en een `.ssh` map voor die gebruiker.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Vervolgens moet je een aantal publieke SSH sleutels van ontwikkelaars aan het `authorized_keys` bestand toevoegen voor die gebruiker. Laten we aannemen dat je een aantal sleutels per e-mail ontvangen hebt en ze hebt opgeslagen in tijdelijke bestanden. Nogmaals, de sleutels zien er ongeveer zo uit:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Je voegt ze eenvoudigweg toe aan je `authorized_keys` bestand:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Nu kun je een lege repository voor ze instellen door `git init` uit te voeren met de `--bare` optie, wat de repository initialiseert zonder een werkmap:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Daarna kunnen John, Josie of Jessica de eerste versie van hun project in de repository pushen door het als een remote toe te voegen en een branch te pushen. Merk op dat iemand met een shell op de machine zal moeten inloggen en een kale repository moet creëren voor elke keer dat je een project wilt toevoegen. Laten we `gitserver` als hostnaam gebruiken voor de server waar je de 'git' gebruiker en repository hebt aangemaakt. Als je het binnenshuis draait, en je de DNS instelt zodat `gitserver` naar die server wijst, dan kun je de commando's vrijwel ongewijzigd gebruiken:

	# op Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Vanaf dat moment kunnen de anderen het clonen en wijzigingen even gemakkelijk terug pushen:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Op deze manier kun je snel een lees/schrijf Git server draaiend krijgen voor een handjevol ontwikkelaars.

Als een extra voorzorgsmaatregel kun je de 'git' gebruiker makkelijk beperken tot het doen van alleen Git activiteiten, met een gelimiteerde shell applicatie genaamd `git-shell` die bij Git geleverd wordt.
Als je dit als login shell voor je 'git' gebruiker instelt, dan kan de 'git' gebruiker geen normale shell toegang hebben op je server. Specificeer `git-shell` in plaats van bash of csh voor je gebruikers login shell om dit te gebruiken. Om dit te doen zul je waarschijnlijk het `/etc/passwd` bestand aan moeten passen:

	$ sudo vim /etc/passwd

Aan het einde zou je een regel moeten vinden die er ongeveer zo uit ziet:

	git:x:1000:1000::/home/git:/bin/sh

Verander `/bin/sh` in `/usr/bin/git-shell` (of voer `which git-shell` uit om te zien waar het geïnstalleerd is). De regel moet er ongeveer zo uit zien:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Nu kan de 'git' gebruiker de SSH connectie alleen gebruiken om Git repositories te pushen en te pullen, en niet om in te loggen in de machine. Als je het probeert zul je een login weigering zoals deze zien:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Publieke Toegang ##

Wat als je anonieme leestoegang op je project wil? Misschien wil je geen intern privé project beheren, maar een open source project. Of misschien heb je een aantal geautomatiseerde bouwservers of continue integratie servers die vaak wisselen, en wil je niet doorlopend SSH sleutels hoeven genereren – je wil gewoon eenvoudige anonieme leestoegang toevoegen.

Waarschijnlijk is de eenvoudigste manier voor kleinschalige opstellingen om een statische webserver in te stellen, waarbij de document root naar de plaats van je Git repositories wijst, en dan de `post-update` haak aanzetten waar we het in de eerste paragraaf van dit hoofdstuk over gehad hebben. Laten we eens uitgaan van het voorgaande voorbeeld. Stel dat je je repositories in de `/opt/git` map hebt staan, en er draait een Apache server op je machine. Nogmaals, je kunt hiervoor iedere web server gebruiken: maar als voorbeeld zullen we wat simpele Apache configuraties laten zien, die je het idee weergeven van wat je nodig hebt.

Eerst moet je de haak inschakelen:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Als je een lagere versie dan 1.6 van Git gebruikt, dan is het `mv` commando niet nodig – Git is recentelijk pas begonnen met de namen van de haak voorbeelden op .sample te laten eindigen.

Wat doet deze `post-update` haak? Het ziet er eigenlijk als volgt uit:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Dit betekent dat wanneer je naar de server via SSH pushed, Git dit commando uitvoert om de benodigde bestanden voor HTTP fetching te verversen.

Vervolgens moet je een VirtualHost regel in je Apache configuratie aanmaken, met de document root als de hoofdmap van je Git projecten. Hier nemen we aan dat je wildcard DNS ingesteld hebt om `*.gitserver` door te sturen naar waar je dit alles draait:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Je zult ook de Unix gebruikers groep van de `/opt/git` mappen moeten zetten op `www-data` zodat je web server leestoegang hebt op de repositories, omdat de Apache instantie het CGI script (standaard) uitvoert als die gebruiker draait:

	$ chgrp -R www-data /opt/git

Als je Apache herstart, dan zou je je repositories onder die map moeten kunnen clonen door de URL van je project te specificeren:

	$ git clone http://git.gitserver/project.git

Op deze manier kun je HTTP-gebaseerde toegang voor elk van je projecten voor een groot aantal gebruikers in slechts een paar minuten regelen. Een andere eenvoudige optie om publieke ongeauthenticeerde toegang in te stellen is een Git daemon te starten, alhoewel dat vereist dat je het proces als daemon uitvoert – we beschrijven deze optie in de volgende paragraaf als je een voorkeur hebt voor deze variant.

## GitWeb ##

Nu je gewone lees/schrijf en alleen-lezen toegang tot je project hebt, wil je misschien een eenvoudige web-gebaseerde visualisatie instellen. Git levert een CGI script genaamd GitWeb mee, dat normaalgesproken hiervoor gebruikt wordt. Je kunt GitWeb in actie zien bij sites zoals `http://git.kernel.org` (zie Figuur 4-1).

Insert 18333fig0401.png 
Figuur 4-1. De GitWeb web-gebaseerde gebruikers interface.

Als je wil zien hoe GitWeb er voor jouw project uitziet, dan heeft Git een commando waarmee je een tijdelijke instantie op kunt starten als je een lichtgewicht server op je systeem hebt zoals `lighttpd` of `webrick`. Op Linux machines is `lighttpd` vaak geïnstalleerd, dus je kunt het misschien draaiend krijgen door `git instaweb` in te typen in je project map. Als je op een Mac werkt: Leopard heeft Ruby voorgeïnstalleerd, dus `webrick` zou je de meeste kans geven. Om `instaweb` met een server anders dan lighttpd te starten, moet je het uitvoeren met de `--httpd` optie.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Dat start een HTTPD server op poort 1234 op en start automatisch een web browser die op die pagina opent. Het is dus makkelijk voor je. Als je klaar bent en de server wilt afsluiten, dan kun je hetzelfde commando uitvoeren met de `--stop` optie:

	$ git instaweb --httpd=webrick --stop

Als je de web interface doorlopend op een server wilt draaien voor je team of voor een open source project dat je verspreid, dan moet je het CGI script instellen zodat het door je normale web server geserveerd wordt. Sommige Linux distributies hebben een `gitweb` pakket dat je zou kunnen installeren via `apt` of `yum`, dus wellicht kan je dat eerst proberen. We zullen snel door een handmatige GitWeb installatie heen lopen. Eerst moet je de Git broncode pakken waar GitWeb bij zit, en het aangepaste CGI script genereren: 

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Merk op dat je het commando moet vertellen waar het je Git repositories kan vinden met de `GITWEB_PROJECTROOT` variabele. Nu moet je zorgen dat de Apache server CGI gebruikt voor dat script, waarvoor je een VirtualHost kunt toevoegen:

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

Nogmaals, GitWeb kan geserveerd worden met iedere web server die in staat is CGI te verwerken. Als je iets anders prefereert zou het niet moeilijk moeten zijn dit in te stellen. Vanaf dit moment zou je in staat moeten zijn om `http://gitserver/` te bezoeken en je repositories online te zien, en kun je `http://git.gitserver` gebruiken om je repositories over HTTP te clonen en te fetchen.

## Gitosis ##

De publieke sleutels van alle gebruikers in een `authorized_keys` bestand bewaren voor toegang werkt slechts korte tijd goed. Als je honderden gebruikers hebt, dan is het te bewerkelijk om dat proces te blijven volgen. Je moet iedere keer in de server inloggen, en er is geen toegangscontrole – iedereen in het bestand heeft lees- en schrijftoegang op ieder project.

Op dat moment zou je kunnen overwegen een veelgebruikt software project genaamd Gitosis te gaan gebruiken. Gitosis is in feite een verzameling scripts die je helpen het `authorized_keys` bestand te beheren alsmede eenvoudig toegangscontrole te implementeren. Het interessante hieraan is dat de gebruikers interface voor deze applicatie om mensen toe te voegen en toegang te bepalen, geen web interface is maar een speciale Git repository. Je beheert de informatie in dat project en als je het pushed, dan herconfigureert Gitosis de server op basis van dat project, wat best wel slim bedacht is.

Gitosis installeren is niet de makkelijkste taak ooit, maar het is ook niet al te moeilijk. Het is het makkelijkste om er een Linux server voor te gebruiken – deze voorbeelden gebruiken een standaard Ubuntu 8.10 server.

Gitosis vereist enkele Python tools, dus moet je eerst het Python setuptools pakket installeren, wat Ubuntu beschikbaar stelt als python-setuptools:

	$ apt-get install python-setuptools

Vervolgens clone en installeer je Gitosis van de hoofdpagina van het project:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Daarmee worden een aantal bestanden geïnstalleerd, die Gitosis zal gebruiken. Daarna wil Gitosis zijn repositories onder `/home/git` stoppen, wat prima is. Maar je hebt je repositories al in `/opt/git` geconfigureerd, dus in plaats van alles te herconfigureren maken we een symbolische link aan:

	$ ln -s /opt/git /home/git/repositories

Gitosis zal de sleutels voor je beheren, dus je moet het huidige bestand verwijderen, om de sleutels later opnieuw toe te voegen en Gitosis het `authorized_keys` bestand automatisch laten beheren. Voor nu verplaatsen we het `authorized_keys` bestand:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Nu moet je de shell terugzetten voor de 'git' gebruiker, als je het veranderd hebt naar het `git-shell` commando. Mensen zullen nog steeds niet in staat zijn in te loggen, Gitosis zal dat voor je beheren. Dus, laten we deze regel veranderen in je `/etc/passwd` bestand

	git:x:1000:1000::/home/git:/usr/bin/git-shell

terug naar dit:

	git:x:1000:1000::/home/git:/bin/sh

Nu wordt het tijd om Gitosis te initialiseren. Je doet dit door het `gitosis-init` commando met je eigen publieke sleutel uit te voeren. Als je publieke sleutel niet op de server staat zul je het daar naartoe moeten kopiëren:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Dit staat de gebruiker met die sleutel toe de hoofd Git repository, die de Gitosis setup regelt, aan te passen. Daarna zul je met de hand het execute bit op het `post-update` script moeten aanzetten voor je nieuwe beheer repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Je bent nu klaar voor de start. Als je alles juist hebt ingesteld, kun je nu met SSH in je server loggen als de gebruiker waarvoor je de publieke sleutel hebt toegevoegd om Gitosis te initialiseren. Je zou dan zoiets als dit moeten zien:

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

Het `gitosis.conf` bestand is het beheer bestand dat je zult gebruiken om gebruikers, repositories en permissies te specificeren. De `keydir` map is de plaats waar je de publieke sleutels opslaat van alle gebruikers die een vorm van toegang tot de repositories hebben – één bestand per gebruiker. De naam van het bestand in `keydir` (in het vorige voorbeeld, `scott.pub`) zal anders zijn in jouw geval – Gitosis haalt de naam uit de beschrijving aan het einde van de publieke sleutel die was geïmporteerd met het `gitosis-init` script.

Als je naar het `gitosis.conf` bestand kijkt, zou het alleen informatie over het zojuist geclonede `gitosis-admin` project mogen bevatten:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Het laat je zien dat de gebruiker 'scott' – de gebruiker met wiens publieke sleutel je Gitosis geïnitialiseerd hebt – de enige is die toegang heeft tot het `gitosis-admin` project.

Laten we nu een nieuw project voor je toevoegen. Je voegt een nieuwe sectie genaamd `mobile` toe, waar je de ontwikkelaars in het mobile team neerzet, en de projecten waar deze ontwikkelaars toegang tot moeten hebben. Omdat 'scott' op het moment de enige gebruiker in het systeem is, zul je hem als enig lid toevoegen en voeg je een nieuw project genaamd `iphone_project` toe om mee te beginnen:

	[group mobile]
	writable = iphone_project
	members = scott

Wanneer je wijzigingen aan het `gitosis-admin` project maakt, moet je de veranderingen committen en terug pushen naar de server voordat ze effect hebben:

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

Je wil samen met je vrienden aan dit project werken, dus je zult hun publieke sleutels weer toe moeten voegen. Maar in plaats van ze handmatig aan het `~/.ssh/authorized_keys` bestand op je server toe te voegen, voeg je ze één sleutel per bestand, aan de `keydir` map toe. Hoe je de sleutels noemt bepaalt hoe je aan de gebruikers refereert in het `gitosis.conf` bestand. Laten we de publieke sleutels voor John, Josie en Jessica toevoegen:

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

Nu kan John het project clonen en updates krijgen, maar Gitosis zal hem niet toestaan om terug naar het project te pushen. Je kunt zoveel van deze groepen maken als je wilt, waarbij ze alle verschillende gebruikers en projecten mogen bevatten. Je kunt ook een andere groep als een van de leden specificeren (met @ als voorvoegsel), waarmee de groepsleden automatisch worden overerfd:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Als je problemen hebt, kan het handig zijn om `loglevel=DEBUG` onder de `[gitosis]` sectie te zetten. Als je je push-toegang bent verloren door een kapotte configuratie te pushen, kun je het handmatig repareren in het bestand `/home/git/.gitosis.conf` op de server – het bestand waar Gitosis zijn informatie vandaan haalt. Een push naar het project neemt het `gitosis.conf` bestand dat je zojuist gepushed hebt en stopt het daar. Als je het bestand handmatig aanpast, zal het zo blijven totdat de volgende succesvolle push gedaan wordt naar het `gitosis-admin` project.

## Gitolite ##

Merk op: de laatste versie van deze paragraaf in het ProGit boek is altijd beschikbaar binnen de [gitolite documentation][gldpg]. De auteur geeft ook nederig aan dat, hoewel deze paragraaf accuraat is, het *kan* (en vaak ook *is*) gebruikt om gitolie te installeren zonder enige andere documentatie te lezen, dat het niet gegarandeerd compleet is, en het zeker niet de gehele enorme hoeveelheid documentatie kan vervangen dat meegeleverd wordt met gitolite.

[gldpg]: http://github.com/sitaramc/gitolite/blob/pu/doc/progit-article.mkd

Git begint erg populair te worden in het bedrijfsleven, die de neiging hebben nog wat additionele eisen te hebben op het gebied van toegangscontrole. Gitolite was oorspronkelijk gemaakt om bij het vervullen van deze eisen te helpen, maar het blijkt dat het even bruikbaar is in de wereld van de open source: het Fedora Project beheert toegang tot hun package beheer repositories (meer dan 10.000 daarvan!) met gitolite, en het is waarschijnlijk daarbij ook nog eens de grootste gitolite installatie waar dan ook.

Gitolite stelt je in staat de permissies niet alleen per repository, maar ook per branch of tag naam binnen elke repository. Dus, je kunt aangeven dat bepaalde mensen (of groepen van mensen) alleen maar bepaalde "refs" (branches of tags) kunnen pushen maar niet andere.

### Installatie ###

Het installeren van Gitolite is zeer eenvoudig, zelfs als je de uitgebreide documentatie, dat erbij geleverd wordt, niet leest. Je hebt een account op een Unix(achtige) server hebben; verschillende Linux smaken en Solaris 10 zijn getest. Je hebt geen root toegang nodig, aangenomen dat git, perl, en een openssh compatible ssh server al zijn geïnstalleerd. In de onderstaand voorbeelden zullen we het `gitolite` account gebruiken op een host genaamd `gitserver`.

Gitolite is nogal ongebruikelijk in de zin van "server" software -- toegang gaat via ssh, en elke userid op de server is in potentie een "gitolite host". Het resultaat is, dat er een idee is van "installeren" van de software zelf, en dan het "opzetten" van een gebruiker als een "gitolist host".

Mensen zonder root toegang kunnen het installeren binnen hun eigen user id. Als laatste: gitlite kan geïnstalleerd worden door een script te starten *op het werkstation*, vanuit een bash-shell. (Zelfs de bash die meegeleverd wordt met msysgit volstaat, voor het geval je je dat afvroeg.)

We zullen dit laatste in dit stuk beschrijven, voor de overige methoden verwijzen we je naar de documentatie.

Je begint met het verkrijgen van toegang op basis van een publieke sleutel, zodat je vanaf je werkstation op de server kan inloggen zonder het intypen van je wachtwoord. De volgende methode werkt op Linux; voor andere werkstation besturingssystemen moet je dit wellicht handmatig doen. We gaan er vanuit dat je al een sleutelpaar hebt gegenereerd met `ssh-keygen`.

	$ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

Dit zal je vragen naar een wachtwoord naar het gitolite account, en dan de publieke sleutel toegang opzetten. Dit is **absoluut noodzakelijk** voor het installatiescript, dus controleer dit om er zeker van te zijn dat je een commando kan laten lopen zonder een wachtwoord te hoeven in typen.

	$ ssh gitolite@gitserver pwd
	/home/gitolite

Vervolgens, clone je Gitolite van de hoofdsite van het project en roept de "easy install" script aan (het derde argument is jouw naam zoals je deze in de resulterende gitolite-admin repository wilt laten verschijnen):

	$ git clone git://github.com/sitaramc/gitolite
	$ cd gitolite/src
	$ ./gl-easy-install -q gitolite gitserver sitaram

En dat is het! Gitolite is nu geïnstalleerdop je server, en je hebt nu een gloednieuwe repository genaamd `gitolite-admin` in de home directory van jouw werkstation. Je beheert je gitolite setup door een wijziging aan te brengen in deze reporitory en deze te pushen.

Dat laatste commando produceert nogal een hoeveelheid uitvoer dat wellicht interessant is om te lezen. Ook wordt er, de eerste keer dat je het laat lopen, er een nieuwe sleutelpaar gemaakt; je moet een wachtwoord kiezen of Enter als je er geen wilt. Waarom een tweede sleutelpaar nodig is, en hoe deze wordt gebruikt, wordt uitgelegd in het "ssh troubleshooting" document dat bij Gitolite wordt meegeleverd. (Hey, de documentatie moet *ergens* goed voor zijn!)

Repositories genaamd `gitolite-admin` en `testing` worden standaard op de server aangemaakt. Als je een van beide lokaal wilt clonen (van een account die SSA console toegang heeft naar het gitolite account via *authorized_keys*) type je:

	$ git clone gitolite:gitolite-admin
	$ git clone gitolite:testing
	
Om deze zelfde repositories te clonen van een willekeurige ander account:

	$ git clone gitolite@servername:gitolite-admin
	$ git clone gitolite@servername:testing

### De Installatie Aanpassen ###

Hoewel de standaard, snelle, installatie werkt voor de meeste mensen, zijn er een aantal manieren om de installatie aan te passen als dat nodig is. Als je het `-q` argument weg laat, krijg je een "verbose" installatie wijze -- gedetaileerde informatie over wat de installatie aan het doen is bij elke stap. De verbose wijze staat je ook toe om bepaalde server-side parameters aan te passen, zoals de locatie van de eigenlijke repositories, door het wijzigen van een "rc" bestand dat de server gebruikt. Dit "rc" bestand is ruimhartig van commentaar voorzien dus je zou in staat moeten zijn om elke wijziging die je nodig vindt vrij snel te maken, op te slaan en door te gaan. Dit bestand bevat ook enkele instellingen die je kunt aanpassen om de meer geavanceerde functies van gitolite aan of uit te zetten.

### Config bestand en Beheer van Toegangsregels ###

Op het moment dat de installatie afgerond is, schakel je over naar de `gitolite-admin` repository (staat in je HOME directory) en begin je rond te snuffelen om te zien wat je daar hebt:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/sitaram.pub
	$ cat conf/gitolite.conf
	#gitolite conf
	# please see conf/example.conf for details on syntax and features

	repo gitolite-admin
	    RW+                 = sitaram

	repo testing
	    RW+                 = @all

Merk op dat "sitaram" (het laatste argument in het `gl-easy-install` commando dat je eerder gegeven hebt) lees en schrijf rechten heeft op de `gitolite-admin` repository en een publiek sleutelbestand met dezelfde naam.

De syntax van het config bestand voor gitolite is ruimhartig van documentatie voorzien in `conf/example.conf`, dus we zullen alleen wat hoofdpunten benoemen.

Je kunt voor het gemak gebruikers of repositories groeperen. De groepnamen zijn vergelijkbaar met macros; als je ze definieert maakt het niet uit of het projecten of gebruikers zijn, dat onderscheid wordt pas gemaakt als je de "macro" gaat *gebruiken*.

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott     # Adams, not Chacon, sorry :)
	@interns        = ashok     # get the spelling right, Scott!
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

Je kunt de permissies beheren op het "ref" niveau. In het volgende voorbeeld kunnen stagieres (interns) alleen maar naar de "int" branch pushen. Techneuten (engineers) kunnen naar elke branch pushen waarvan de naam begint met "eng-", en tags die beginnen met "rc" gevolgd door een getal. En de admins kunnen alles (inclusief terugdraaien) naar elke ref.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

De expressie achter de `RW` of `RW+` is een zgn. regular expression (regex) waartegen de refname (ref) die wordt gepushed wordt vergeleken. Dus we noemen het natuurlijk een "refex"! En natuurlijk kan een refex veel krachtiger zijn dan hier wordt getoond, dus ga het niet overdrijven als je niet al te goed in de perl regexen zit.

Zoals je wellicht al geraden hebt, prefixed Gitolite `refs/heads/` als een syntactische handigheid als de refex niet begint met `refs/`.

Een belangrijke eigenschap van de syntax van het config bestand is dat alle regels van een repository niet op één plek hoeft te staan. Je kunt al het generieke spul bij elkaar houden, zoals de regels voor alle `oss_repos` zoals ze hier boven staan, en dan op een latere plaats specifieke regels voor specifieke gevallen, zoals hier:

	repo gitolite
	    RW+                     = sitaram

Deze regel wordt gewoon toegevoegd aan de set met regels voor de `gitolite` repository.

Je zou je op dit punt kunnen afvragen hoe de toegangsregels eigenlijk worden toegepast, laten we dat kort behandelen.

Er zijn twee niveaus van toegangsbeheer in gitolite. De eerste is op repository niveau. Als je lees (of schrijf)rechten hebt tot *enige* ref in de repository, dan heb je lees (of schrijf) rechten tot de repository.

Het tweede niveau, alleen van toepassing voor "schrijf" toegang, is per branch of tag binnen een repository. De gebruikersnaam, het type toegang wat wordt gevraagd (`W` of '+'), en de refname dat wordt gewijzigd (update) zijn bekend. De toegangsregels worden gecontroleerd in volgorde van voorkomst in het config bestand, en er wordt gekeken naar een treffer voor deze combinatie (maar onthoudt dat de refname middels een regex wordt vergeleken, niet een simpele string-vergelijking). Als er een treffer is, dan slaagt de push. Als er geen treffer wordt gevonden (fallthrough) dan wordt toegang geweigerd.

### Geavanceerde Toegangs Controle met "deny" regels ###

Tot zover hebben we alleen permissies gezien uit het rijtje `R`, `RW` of `RW+`. Echter, gitolite kent een andere permissie: `-`, wat staat voor "deny" (ontken). Dit geeft je veel meer macht, tegen kosten van wat hogere complexiteit omdat een fallthrough nu niet de *enige* manier is waarop toegang kan worden geweigerd, wordt *de volgorde van regels belangrijk*!

Stel dat, in de onderstaande situatie, we de techneuten in staat willen stellen elke branch te laten terugdraaien *behalve* master en integ. Dit is de manier om dat te doen:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Nogmaals, je hoeft slechts de regels van boven naar beneden af te lopen tot je een treffer hebt voor je gevraagde toegangswijze, of een afwijzing. Een push die niets terugdraait naar master of integ wordt door de eerste regel toegestaan. Een terugdraai-push naar deze refs geeft geen treffer op de eerste regel en valt door naar de tweede regel en wordt daarom geweigerd. Elke push (terugdraaiend of niet) naar refs anders dan master of integ zullen op de eerste twee regels zowiezo niet treffen en de derde regel staat dit toe.

### Beperken van pushes bij gewijzigde bestanden ###

Bovenop het beperken van gebruikersrechten op branches voor een gebruiker, kan je ook de rechten van gebruikers beperken op bestanden. Als voorbeeld, misschien is de Makefile (of een ander programma) niet echt bedoeld om te worden gewijzigd door iedereen, omdat een groot aantal dingen afhankelijk ervan zijn of omdat het stuk loopt als de wijzigingen niet *precies goed* gebeuren. Je kunt het gitolite duidelijk maken:

    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

Deze krachtige eigenschap is gedocumenteerd in `conf/example.conf`.

### Persoonlijke branches ###

Gitolite heeft ook een mogelijkheid van "persoonlijke branches" (of liever gezegd "persoonlijke branch namespace") wat erg nuttig kan zijn in een bedrijfssituatie.

Veel van de code-uitwisselingen in de git-wereld verlopen via zgn. "please pull" aanvragen. In een bedrijfsomgeving echter is ongeauthoriseerde toegang taboe, en het werkstation van een ontwikkelaar kan geen authenticatie doen, dus je moet naar de centrale server pushen en iemand vragen daarvandaan te pullen.

Dit zou normaalgesproken een gelijksoortige branch-brij veroorzaken als in een gecentraliseerde versiebeheersysteem, en daarbij wordt het opzetten van permissies een vervelende klus voor de administrator.

Gitolite stelt je in staat een "personal" of "scratch" namespace prefix voor elke ontwikkelaar te definiëren (bijvoorbeeld `refs/personal/<devname>/*`); zie ook de "personal branches" paragraaf in `doc/3-faq-tips-etc.mkd` voor details.

### "Wildcard" repositores ###

Gitolite laat je repositories specificeren met wildcards (eigenlijk perl regex expressies), zoals bijvoorbeeld `assignments/s[0-9][0-9]/a[0-9][0-9]`, om maar een willekeurig voorbeeld te nemen. Dit is een *heel* krachtige eigenschap die wordt aangezet door de regel `$GL_WILDREPOS = 1;` in het rc bestand. Het laat je een nieuwe permissiewijze ("C") toe te wijzen welke gebruikers in staat stelt repositories aan te maken die voldoen aan zulke wildcards, automatisch eigenaarsschap toe te wijzen aan de gebruiker die hem heeft aangemaakt, staat deze gebruiker toe om "R" en "RW" permissies aan anderen toe te wijzen om samen te werken, etc. Deze eigenschap is beschreven in `doc/4-wildcard-repositories.mkd`.

### Andere eigenschappen ###

We ronden deze uiteenzetting af met een passe partout van andere eigenschappen, welke alle (en nog vele andere) tot in de kleinste detail zijn beschreven in de "faqs, tips, etc" en andere documenten.

**Logging**: Gitolite logt alle succesvolle toegangspogingen. Als je wat te los bent geweest in het toekennen van terugdraai permissies (`RW+`) en een of andere nozem heeft "master" vernaggelt, is de log-file een redder in de nood in de zin van snel en eenvoudig achterhalen van de SHA die verdwenen is.

**Git buiten reguliere PATH**: Een ontzettend handige eigenschap in gitolite is het ondersteunen van git buiten het regulier `$PATH` (dit komt vaker voor dan je zou denken, sommige bedrijfs omgevingen of zelfs sommige hosting providers weigeren dingen systeem-breed te installeren en je eindigt ermee dat je ze in je eigen directories zet). Normaalgesproken ben je gedwongen git aan de *client-side* op de een of andere manier te vertellen van deze niet-standaard locatie van de git binaries. Met gitolite hoe je alleen een verbose installatie te kiezen en `$GIT_PATH` in de "rc" bestanden in te vullen. Hierna geen wijzigingen aan de kant van de clients nodig :-)

**Rapportage van toegangsrechten**: Nog zo'n handige eigenschap is wat er gebeurt als je gewoon met ssh naar de server gaat. Gitolite laat zien welke repositories je toegang toe hebt en welke soort toegang dat dan wel is. Hier is een voorbeeld:

        hello sitaram, the gitolite version here is v1.5.4-19-ga3397d4
        the gitolite config gives you the following access:
             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter


**Delegeringen**: Voor extreem grote installaties kan je de verantwoordelijkheid voor groepen van repositories delegeren aan verschilllende mensen en hen het beheer van die delen onafhankelijk laten regelen. Dit vermindert de werkdruk van de hoofd-beheerder, en maakt van hem minder een faalpunt. Deze eigenschap heeft zijn eigen docuentatie bestand in de `doc/` directory.

**Gitweb ondersteuning**: Gitolite ondersteunt gitweb op verschillende manieren. Je kunt aangeven welke repositories zichtbaar zijn via gitweb. Je kunt de "owner" (eigenaar) en "description" (omschrijving) voor gitweb vanuit de gitolite configuratie bestanden definiëren. Gitweb heeft een mechanisme beschikbaar waarmee toegang via HTTP wordt geïmplementeerd, deze kan je het "gecompileerde" config bestand van de gitolite config file laten gebruiken, wat inhoudt dat gitweb en gitolite dezelfde toegangsregels gebruikt (voor lees toegang).


## Git Daemon ##

Voor publieke ongeauthenticeerde leestoegang tot je projecten zul je het HTTP protocol achter je willen laten, en overstappen op het Git protocol. De belangrijkste reden is snelheid. Het Git protocol is veel efficiënter en daarmee sneller dan het HTTP protocol, dus het zal je gebruikstijd besparen.

Nogmaals, dit is voor ongeauthenticeerde alleen-lezen toegang. Als je dit op een server buiten je firewall draait, zul je het alleen moeten gebruiken voor projecten die voor de hele wereld toegankelijk moeten zijn. Als de server waarop je het draait binnen je firewall staat, zou je het kunnen gebruiken voor projecten waarbij een groot aantal mensen of computers (continue integratie of bouwservers) alleen-lezen toegang moeten hebben, waarbij je niet voor iedereen een SSH sleutel wilt toevoegen.

In ieder geval is het Git protocol relatief eenvoudig in te stellen. Eigenlijk is het enige dat je moet doen dit commando een daemon uitvoeren:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` staat de server toe om te herstarten zonder te wachten tot oude connecties een time-out krijgen, de `--base-path` optie staat mensen toe om projecten te clonen zonder het volledige pad te specificeren, en het pad aan het einde vertelt de Git daemon waar hij moet kijken voor de te exporteren repositories. Als je een firewall draait, zul je er poort 9418 open moeten zetten op de machine waar je dit op gaat doen.

Je kunt dit proces op een aantal manieren daemoniseren, afhankelijk van het besturingssystem waarop je draait. Op een Ubuntu machine, zul je een Upstart script gebruiken. Dus in het volgende bestand

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

Als je de machine herstart, zal de Git daemon automatisch opstarten en herstarten als de server onderuit gaat. Om het te laten draaien zonder te herstarten, kun je dit uitvoeren:

	initctl start local-git-daemon

Op andere systemen zul je misschien `xinetd` willen gebruiken, een script in je `sysvinit` systeem, of iets anders – zolang je dat commando maar ge-daemoniseerd krijgt en deze op een of andere manier in de gaten gehouden wordt.

Vervolgens zul je je Gitosis server moeten vertellen welke repositories je onauthenticeerde Gitserver gebaseerde toegang toestaat. Als je een sectie toevoegt voor iedere repository, dan kun je die repositories specificeren waarop je je Git daemon wilt laten lezen. Als je Git protocol toegang tot je iphone project wilt toestaan, dan voeg je dit toe aan het eind van het `gitosis.conf` bestand:

	[repo iphone_project]
	daemon = yes

Als dat gecommit en gepushed is, dan zou de draaiende daemon verzoeken moeten serveren aan iedereen die toegang heeft op poort 9418 van je server.

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

Als je niet al het werk wilt doen om je eigen Git server op te zetten, heb je meerdere opties om je Git project op een externe speciale hosting pagina te laten beheren. Dit biedt een aantal voordelen: een ge-hoste pagina is over het algemeen snel in te stellen, eenvoudig om projecten mee op te starten, en er komt geen serverbeheer en -onderhoud bij kijken. Zelfs als je je eigen server intern ingesteld hebt, zul je misschien een publieke host pagina voor je open source broncode willen – dat is over het algemeen makkelijker voor de open source commune te vinden en je er mee te helpen.

Vandaag de dag heb je een enorm aantal beheer opties om uit te kiezen, elk met verschillende voor- en nadelen. Om een bijgewerkte lijst te zien, ga dan kijken op de GitHosting pagina op de hoofd Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Omdat we ze niet allemaal kunnen behandelen, en ik toevallig bij een ervan werk, zullen we deze paragraaf gebruiken het instellen van een account en het opzetten van een project op GitHub te doorlopen. Dit geeft je een idee van het benodigde werk.

GitHub is veruit de grootste open source Git beheer pagina en het is ook een van de weinige die zowel publieke als privé beheer opties biedt, zodat je je open source en commerciele privé code op dezelfde plaats kunt bewaren. Sterker nog, we hebben GitHub gebruikt om privé samen te werken aan dit boek.

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
