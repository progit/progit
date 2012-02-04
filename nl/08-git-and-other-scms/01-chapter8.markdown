# Git en Andere Systemen #

Het is geen perfecte wereld. Meestal kun je niet meteen ieder project waar je mee in aanraking komt omzetten naar Git. Soms zit je vast op een project dat een ander VCS gebruike, en vaak is dat systeem Subversion. In het eerste gedeelte van dit hoofdstuk zul je leren over `git svn`, het bidirectionele Subversion poort tool in Git.

Op een bepaald punt zul je je bestaande project willen omzetten naar Git. Het tweede gedeelte van dit hoofdstuk beschrijft hoe je je project naar Git kunt migreren: eerst uit Subversion, dan vanuit Perforce, en als laatste via een eigen import script voor een niet standaard import geval.

## Git en Subversion ##

Op het moment maken het meerendeel van open source ontwikkelprojecten en een groot aantal bedrijfsprojecten gebruik van Subversion om hun broncode te beheren. Het is het meest populaire open source VCS en bestaat al bijna tien jaar. Het lijkt in veel manieren op CVS, wat daarvoor de grootste speler was in de code-beheer wereld.

Een van de beste eigenschappen van Git is een bidirectionele brug naar Subversion genaamd `git svn`. Dit tool staat je toe om Git als een volwaardige gebruiker van een Subversion server te gebruiken, zodat je alle lokale eigenschappen van Git kunt gebruiken en daarna naar een Subversion server kunt pushen alsof je Subversion lokaal gebruikt. Dit betekent dat je lokaal kunt branchen en mergen, het staging gebied gebruiken, kunt rebasen en cherry-picken enzovoorts, terwijl je medewerkers verder kunnen werken op hun duistere en ouderwetse manieren. Het is een goede manier om Git in de bedrijfsomgeving binnen te sluipen en je mede-ontwikkelaars te helpen efficienter te worden terwijl je lobbiet om de infrastructuur veranderd te krijgen zodat Git volledig gesupport wordt. De Subversion brug is de poort drug naar de DCVS wereld.

### git svn ###

Het basiscommando in Git voor alle Subversion brugcommando's is `git svn`. Je laat dit aan alles vooraf gaan. Je hebt best een aantal commando's nodig, dus je zult de meeste leren terwijl we door een aantal werkwijzen lopen.

Het is belangrijk om te zien dat terwijl je `git svn` gebruikt, je aan het commnuniceren bent met Subversion, wat een systeem is dat veel minder uitgekiend is dat Git. Alhoewel je eenvoudig lokaal kunt branchen en mergen, is het over het algemeen het beste om je geschiedenis zo lineair als mogelijk te houden door je werk te rebasen en te vermijden dingen te doen zoals simultaan communiceren met een Git remote repository.

Herschrijf je geschiedenis niet om daarna nogmaals te pushen, en ga niet tegelijkertijd een parallel Git repository ernaast gebuiken om met mede Git ontwikkelaars samen te werken. Subversion kan slechts één lineaire geschiedenis hebben, en het in de war brengen is heel eenvoudig. Als je met een team aan het werk bent en sommigen maken gebruik van Subversion en anderen van Git, zorg dan dat iedereen de SVN server gebruikt om samen te werken – het maakt je leven een stuk eenvoudiger.

### Instellen ###

Om deze functionaliteit te demonstreren heb je een typisch SVN repository nodig waarop je schrijftoegang hebt. Als je deze voorbeelden wilt kopieeren, zul je een schrijfbare kopie moeten maken van mijn test repository. Om dat eenvoudig te kunnen doen, kun je een tool gebruiken genaamd `svnsync` dat bij de meer recente versies van Subversion geleverd wordt – het zou minstens bij versie 1.4 moeten zitten. Voor deze tests heb ik een nieuw Subversion repository op Google code gemaakt wat een gedeeltelijke kopie is van het `protobuf` project, wat een tool is dat gestructureerde data voor netwerk transmissie codeert.

Om het te volgen zul je eerst een nieuw lokaal Subversion repository moeten maken:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Daarna sta je alle gebruikers toe om revprops te wijzigen – de makkelijke manier is om een pre-revprop-change script toe te voegen dat altijd met 0 afsluit:

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Je kunt dit project nu syncen naar je lokale machine door `svnsync init` aan te roepen met de van en naar repositories.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

Dit stelt de eigenschappen in om de sync uit te voeren. Je kunt de code dan clonen door dit uit te voeren

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Alhoewel deze operatie maar een paar minuten in beslag neemt, zal het kopieeren van het originele repository naar een ander remote repository in plaat van een lokale meer dan een uur duren, terwijl er minder dan 100 commits in zitten. Subversion moet één revisie per keer clonen en dan terug pushen in een ander repository – het is belachelijk inefficient, maar het is de enige makkelijke manier om dit te doen.

### Beginnen ###

Nu dat je een Subversion repository hebt met schrijftoegang, kun je door een typische werkwijze gaan. Je begint met het `git svn clone` commando, wat een volledig Subversion repository in een lokaal Git repository cloned. Onthoud dat als je van een echt beheerd Subversion repository importeerd, je de `file:///tmp/test-svn` hier moet vervangen door de URL van je Subversion repository:

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

Dit voert het equivalent uit van twee commando's – `git svn init` gevolgd door `git svn fetch` – op de URL die je aanleverd. Het kan een tijdje duren. Het testproject heeft slechts 75 commits en de hoeveelheid code is niet zo groot, dus het neemt maar een paar minuten in beslag. Maar, Git moet iedere versie uitchecken, één voor één, en ze individueel committen. Voor een project met honderdduizende commits kan dit letterlijk uren of zelfs dagen duren om af te ronden.

Het `-T trunk -b branches -t tags` gedeelte verteld Git dat dit Subversion repository de basale branch en tag conventie volgt. Als je je trunk, branches of tags anders noemt, kun je deze opties veranderen. Omdat dit zo gewoon is, kun je dit hele gedeelte vervangen door `-s`, wat standaard indeling betekend en al die opties impliceerd. Het volgende commando is gelijkwaardig:

	$ git svn clone file:///tmp/test-svn -s

Op dit punt zou je een geldig Git repository moeten hebben, dat je branches en tags geimporteerd heeft:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

Het is belangrijk om te zien hoe dit tool je remote references een andere naamruimte toebedeeld. Als je een normaal Git repository cloned, krijg je alle branches op die remote server lokaal beschikbaar in de vorm van `origin/[branch]` – volgens de naamruimte van de remote. Maar, `git svn` gaat er vanuit dan je niet meerdere remotes hebt en bewaard al zijn referentie punten om de remote server zonder naamruimte. Je kunt het Git loodgieters commando `show-ref` gebruiken om naar al je volledige referentie namen te kijken:

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

Een normaal Git repository ziet er meer zo uit:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

Je kunt twee remote servers hebben: een genaamd `gitserver` met een master branch; en een andere genaamd `origin` met twee branches, `master` en `testing`.

Zie hoe in het voorbeeld van geimporteerde remote referenties van `git svn`, de tags toegevoegd zijn als remote branches, niet als echte Git tags. Je Subversion import ziet eruit alsof het een remote heeft dat tags heet waaronder branches zitten.

### Terug naar Subversion Committen ###

Nu dat je een werkend repository hebt, kun je wat werken aan het project en je commits stroomopwaarts pushen, waarbij je Git effectief als een SVN gebruiker toepast. Als je een van de bestanden aanpast en het commit, heb je een commit dat lokaal in Git bestaat, die niet op de Subversion server bestaat:

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

Vervolgens moet je je verandering stroomopwaarts pushen. Zie hoe dit de manier veranderd waarop je met Subversion werkt  – je kunt een paar commits offline doen en ze dan ineens naar de Subversion server pushen. Om naar een Subversion server te pushen, voer je het `git svn dcommit` commando uit:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Dit neemt alle commits die je gedaan hebt bovenop de Subversion server code, doet voor elk een Subversion commit, en herschrijft je lokale Git commit zodat het een unieke identificatie heeft. Dit is belangrijk omdat het betekend dan alle SHA-1 checksums voor je commits veranderen. Deels is het voor de reden dat het werken met Git-gebaseerde remote versies van je projecten tegelijk met een Subversion server geen goed idee is. Als je kijkt naar de laatste commit, kun je het nieuwe `git-svn-id` zien dat is toegevoegd:

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Zie dat de SHA checksum die origineel begon met `97031e5` toen je committe, nu begint met `938b1a5`. Als je wilt pushen naar zowel een Git server als een Subversion server, moet je eerst naar de Subversion server pushen (`dcommit`), omdat die aktie je commit data veranderd.

### Nieuwe Veranderingen Pullen ###

Als je met andere developers samenwerkt, dan zal op een bepaald punt een van jullie willen pushen en de ander zal een conflicterende wijziging willen pushen. Die wijziging zal worden geweigerd totdat je hun werk merged. In `git svn` ziet het er zo uit:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Om deze situatie op te lossen, kun je `git svn rebase` uitvoeren, wat alle wijzigingen op de server die je nog niet hebt pulled, en al het werk dat je hebt bovenop wat op de server staat rebased:

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

Nu dat al jouw werk bovenop hetgeen wat op de Subversion server staat gebracht is, kun je succesvol `dcommit` doen:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Het is belangrijk te onthouden dat `git svn` je dit alleen laat doen als de wijzigingen conflicteren, in tegenstelling tot Git dat je vereist om eerst al het stroomopwaartse werk dat je nog niet lokaal hebt te mergen voordat je kunt pushen. Als iemand anders een verandering naar een bestand pushed en daarna push jij een verandering op een ander bestand, dan zal je `dcommit` prima werken:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

Dit is belangrijk om te onthouden, want de uitkomst is een project status die niet bestond op een van jullie computers toen je pushte. Als de veranderingen incompatibel zijn, maar niet conflicteren, dan kun je problemen krijgen die lastig te diagnosticeren zijn. Het is anders dan een Git server gebruiken – in Git kun je de status volledig op je gebruikerssysteem testen voordat je het publiceert, waarbij in SVN je nooit zeker kunt zijn dat de statussen vlak voor je commit en na je commit gelijk zijn.

Je zou dit commando ook moeten uitvoeren om wijzigingen te pullen van de Subversion server, zelfs als je niet klaar bent om te committen. Je kunt `git svn fetch` uitvoeren om de nieuwe data te pakken, maar `git svn rebase` doet de fetch en vernieuwd je lokale commits.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Eens in de zoveel tijd `git svn rebase` uitvoeren zorgt er voor dat je code altijd up to date is. Je moet er wel zeker van zijn dat je werkmap schoon is als je dit uitvoert. Als je lokale wijzigingen hebt, moet je of eerst je werk stashen, of tijdelijk committen voordat je `git svn rebase` uitvoert – anders zal het commando stoppen als het ziet dat de rebase zal resulteren in een mergeconflict.

### Git Branch Problemen ###

Als je je op je gemak voelt met een Git manier van werken, zul je waarschijnlijk onderwerp branches gaan maken, er werk op doen, en ze dan inmergen. Als je naar een Subversion server pushed via git svn, wil je misschien je werk iedere keer in een enkele branch rebasen in plaats van de branches samen mergen. De reden om rebasen te prefereren is dat Subversion een lineaire geschiedenis heeft, en niet omgaat met merges op de manier zoals Git dat doet, dus git svn volgt alleen de eerste ouder op het moment dat de snapshots naar Subversion commits omgezet worden.

Stel dat je geschiedenis er zoals volgt uitziet: je hebt een `experiment` branch gemaakt, twee commits gedaan, en ze dan terug in `master` gemerged. Als je dan `dcommit` zie je output zoals dit:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Het uitvoeren van `dcommit` op een branch met gemergede historie werkt prima, behalve wanneer je naar je Git project historie kijkt, het geen van beide commits die je op de `experiment` branch gedaan hebt herschreven heeft – in plaats daarvan verschijnen al die wijzigingen in de SVN versie van de enkele merge commit.

Als iemand anders dat werk cloned, is alles wat ze zien de merge commit met al het werk erin gesquashed; ze zien niet de commit data met waar het vandaan kwam of wanneer het was gecommit.

### Subversion Branchen ###

Branchen in Subversion is niet hetzelfde als branchen in Git; het is waarschijnlijk het beste om het zoveel mogelijk te vermijden. Maar, je kunt Subversion branches maken en naar committen door gebruik te maken van git svn.

#### Een Nieuwe SVN Branch Maken ####

Om een nieuwe branch te maken in Subversion, voer je `git svn branch [branchnaam]` uit:

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

Dit doet het equivalent van het `svn copy trunk branches/opera` commando in Subversion en werkt op de Subversion server. Het is belangrijk om te zien dat het je niet uitchecked in die branch; als je op dit punt commit, dan zal die commit in de `trunk` op de server gaan, niet in `opera`.

### Actieve Branches Wisselen ###

Git zoekt uit naar welke branch je dcommits heen gaan door te kijken naar de punt van ieder van je Subversion branches in je geschiedenis – je zou er slechts één moeten hebben, en het zou de laatse moeten zijn met een `git-svn-id` in je huidige branch historie.

Als je tegelijk wilt werken op meer dan één branch, dan kun je lokale branches instellen om de `dcommit` naar specifieke Subversion branches te doen door ze te starten bij de geimporteerde Subversion commit voor die branch. Als je een `opera` branch wilt hebben waar je apart op kunt werken, kun je dit uitvoeren

	$ git branch opera remotes/opera

Als je je `opera` branch nu in `trunk` (jouw `master` branch) wilt mergen, kun je dit doen met een normale `git merge`. Maar je moet een beschrijvend commit bericht meegeven (via `-m`), of de merge zal "Merge branch opera" bevatten in plaats van iets bruikbaars.

Onthoud dat, alhoewel je `git merge` gebruikt voor deze operatie, en de merge waarschijnlijk veel makkelijker gaat dan het in Subversion zou gaan (omdat Git automatisch de merge basis voor je zal detecteren), dit geen normale Git merge commit is. Je moet deze data terug pushen naar een Subversion server die geen commit aan kan die meer dan één ouder volgt; dus, nadat je het omhoog gepushed hebt, zal het eruit zien als een enkele commit waarbij al het werk van een andere branch erin gesquashed zit als een enkele commit. Nadat je een branch in een andere gemerged hebt, kun je niet eenvoudig terug gaan en op die branch verder werken, zoals je dat normaal kunt in Git. Het `dcommit` commando dat je uitvoert, wist alle informatie die kan vertellen welke branch erin gemerged was, dus opvolgende merge-basis berekeningen zullen fout gaan – de `dcommit` zal je `git merge` resultaat eruit laten zien alsof je `git merge --squash` uitgevoerd hebt. Helaas is er geen manier om deze situatie te vermijden – Subversion kan deze informatie niet opslaan, dus je zult altijd gelimiteerd zijn door zijn beperkingen zolang als je het als server gebruikt. Om problemen te vermijden, zou je de lokale branch moeten verwijderen (in dit geval `opera`), nadat je hem in trunk gemerged hebt.

### Subversion Commando's ###

De `git svn` toolset levert een aantal commando's mee om de overgang naar Git te vergemakkelijken, door sommige functionaliteit te leveren, die vergelijkbaar is met wat je in Subversion had. Hier zijn een paar commando's die je geven wat Subversion voorheen deed.

#### SVN Achtige Historie ####

Als je gewend bent aan Subversion en je wil je historie in SVN achtige output zien, kun je `git svn log` uitvoeren om je commit historie in SVN formattering te zien:

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines
	
	updated the changelog

Je moet twee belangrijke zaken weten over `git svn log`. Ten eerste, het werkt offline en niet zoals het echte `svn log` commando wat de Subversion server vraagt om de data. Ten tweede, het toont je alleen commits die zijn gecommit naar de Subversion server. Lokale Git commits, die je nog niet ge-dcommit hebt worden niet getoond; een ook commits die mensen gedaan hebben in de tussentijd naar de Subversion server. Het is meer zoiets als de laatst bekende status van de commits op de Subversion server.

#### SVN Annotatie ####

Zoals het `git svn log` commando het `svn log` commando offline simuleert, kun je het equivalent van `svn annotate` krijgen door `git svn blame [BESTAND]` uit te voeren. De output ziet er zo uit:

	$ git svn blame README.txt 
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal 
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal 
	79    schacon Committing in git-svn.
	78    schacon 
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal 

Nogmaals, het toont geen commits die je lokaal in Git gedaan hebt, of die in de tussentijd naar Subversion gepushed zijn.

#### SVN Server Informatie ####

Je kunt ook het soort informatie krijgen dat `svn info` je geeft door `git svn info` uit te voeren:

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

Dit is vergelijkbaar met `blame` en `log` in dat het offline draait en alleen up to date is vanaf de laatste keer dat je met de Subversion server gecommuniceerd hebt.

#### Negeren Wat Subversion Negeert ####

Als je een Subversion repository cloned, die ergens `svn:ignore` eigenschappen gezet heeft, dan zul je waarschijnlijk overeenkomende `.gitignore` bestanden in willen stellen so dat je niet per ongeluk bestanden commit die je niet had moeten committen. `git svn` heeft twee commando's die met dit probleem helpen. De eerste is `git svn create-ignore`, wat automatisch `.gitignore` bestanden voor je genereerd zodat je volgende commit ze niet kan bevatten.

Het tweede commando is `git svn show-ignore`, want op stdout de regels afdrukt die je in een `.gitignore` bestand moet stoppen zodat je de output in het exclude bestand van je project kunt stoppen:

	$ git svn show-ignore > .git/info/exclude

Op die manier vervuil je het project niet met `.gitignore` bestanden. Dit is een goeie optie als je de enige Git gebruiker in een Subversion team bent, en je teamgenoten geen `.gitignore` bestanden in het project willen hebben.

### Git-Svn Samenvatting ###

De `git svn` tools zijn bruikbaar als je voorlopig vast zit aan een Subversion server, of op een andere manier in een ontwikkelomgeving zit waar het draaien van een Subversion server noodzakelijk is. Je moet het echter beschouwen als een kreupele Git, of anders loop je tegen problemen in de vertaling aan, die jou en je medewerkers in verwarring kunnen brengen. Om uit de problemen te blijven moet je deze regels volgen:

* Houdt een lineaire Git historie aan, die geen merge commits bevat die gedaan zijn door `git merge`. Rebase al het werk dat je buiten je hoofd branch doet er terug in; niet erin mergen.
* Geen aparte Git server instellen en daar op samenwerken. Je kunt er een hebben om clones voor nieuwe developers te versnellen, maar push er niets terug in dat geen `git-svn-id` vermelding heeft. Je zou zelfs een `pre-receive` haak kunnen toevoegen, die ieder commit bericht na kijkt op een `git-svn-id` en pushes weigert die commits zonder bevatten.

Als je deze regels volgt, dan kan werken met een Subversion server meer dragelijk zijn. Maar, als het mogelijk is om over te gaan naar een echte Git server, dan kan dat je team een hoop meer toevoegen.

## Naar Git Migreren ##

Als je een bestaande hoeveelheid brondcode in een ander VCS hebt, maar je hebt besloten om Git te gaan gebruiken dan moet je je project op een of andere manier migreren. Deze sectie behandelt een aantal importeerders voor veel voorkomende systemen, die bij Git zitten en demonstreert daarna hoe je je eigen importeerder kunt ontwikkelen.

### Importeren ###

Je zult leren hoe je data uit twee van de grotere professioneel gebruikte SCM systemen kunt importeren – Subversion en Perforce –  omdat zij op dit moment de grootste hoeveelheid gebruikers hebben waarvan ik op dit moment hoor dat ze willen wisselen, en omdat er tools van hoge kwaliteit voor beide systemen meegeleverd worden met Git.

### Subversion ###

Als je de vorige sectie over het gebruik van `git svn` leest, kun je die instructies eenvoudig gebruiken om een `git svn clone` te doen op een repository; daarna stop je met het gebruik van de Subversion server, pushed naar de nieuwe Git server, en ga die gebruiken. Als je de historie wil hebbeen, kun je dat zo snel als dat je van de server kunt pullen voor elkaar krijgen (wat een tijdje kan duren).

Maar, de import is niet perfect; en omdat het zo lang zal duren, kun je het maar beter goed doen. Het eerste probleem is informatie over de auteurs. In Subversion heeft iedere persoon die commit een gebruikersaccount op het systeem, wat wordt opgenomen in de commit informatie. De voorbeelden in de voorgaande sectie toen `schacon` op bepaalde plaatsen zoals de `blame` output en bij `git svn log`. Als je dit beter wil transleren naar Git auteur datan, dan heb je een translatie nodig van de Subversion gebruikers naar de Git auteurs. Maak een bestand genaamd `users.txt`, die deze translatie in dit formaat heeft:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

Om een lijst te krijgen van de auteurnamen, die SVN gebruikt kun je dit uitvoeren:

	$ svn log --xml | grep author | sort -u | perl -pe 's/.>(.?)<./$1 = /'

Daarmee krijg je de log output in XML formaat – je kunt hierin zoeken naar de auteurs, een lijst met unieke vermeldingen creëeren en dan de XML eruit halen. (Dit werkt natuurlijk alleen op een machine waarop `grep`, `sort` en `Perl` geinstalleerd is.) Daarna stuur je die output naar je users.txt bestand zodat je de gelijkwaardige Git gebruiker data naast iedere vermelding kunt zetten.

Je kunt dit bestand meegeven aan `git svn` om het te helpen de autuer data accurater te transleren. Je kunt `git svn` ook vertellen dat het niet de metadat moet toevoegen die Subversion normaal importeerd, door de `--no-metadata` optie mee te geven aan het `clone` of `init` commando. Dit laat je `import` commando er zo uit zien:

	$ git-svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Nu zou je een betere Subversion import moeten hebben in je `my_project` map. In plaats van commits die er zo uit zien

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029
zien ze er zo uit:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Niet alleen het auteur veld ziet er beter uit, maar het `git-svn-id` is ook niet meer aanwezig.

Je moet nog een beetje `post-import` opruiming doen. Je moet nog de vreemde referenties die `git svn` ingesteld heeft opruimen, bijvoorbeeld. Als eerste verplaats je de tags zodat het echte tags worden, in plaats van vreemde remote branches, en dan verplaats je de rest van de branches zodat ze lokaal worden.

Om de tags goede Git tags te laten worden, voer dit uit

	$ cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
	$ rm -Rf .git/refs/remotes/tags

Dit neemt de referenties die remote branches waren en met `tag/` begonnen, en maakt er echte (lichtgewicht) tags van.

Daarna verplaats je de rest van de referenties onder `refs/remotes` zodat het lokale branches worden:

	$ cp -Rf .git/refs/remotes/* .git/refs/heads/
	$ rm -Rf .git/refs/remotes

Nu zijn alle oude branches echte Git branches, en alle oude tags echte Git tags. Het laatste ding dan je moet doen is je nieuwe Git server als een remote toevoegen en er naar pushen. Omdat je al jouw branches en tags omhoog wil laten gaan, kun je dit uitvoeren:

	$ git push origin --all

Al je branches en tags zouden op je Git server moeten staan in een fijne schone import.

### Perforce ###

Het volgende systeem waar je naar gaat kijken om vanuit te importeren is Perforce. Er zit een Perforce importeerder bij de Git distributie, maar alleen in het `contrib` gedeelte van de broncode – het is niet standaard beschikbaar zoals `git svn`. Om het uit te voeren, moet je de Git broncode pakken, die je van git.kernel.org kunt downloaden:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

In deze `fast-import` map, zou je een uitvoerbaar Python script genaamd `git-p4` moeten vinden. Je moet Python en het `p4` tool geinstalleerd hebben op je machine om deze import te laten werken. Als voorbeeld ga je het Jam project van de Perforce Public Depot importeren. Om je gebruiker in te stellen, moet je de P$PORT omgevingsvariabele laten wijzen naar het Perforce depot:

	$ export P4PORT=public.perforce.com:1666

Voer het `git-p4-clone` commando uit om het Jam project van de Perforce server te importeren, waarbij je het pad naar het depot en het project en het pad waarnaar je wilt importeren mee geeft:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

Als je naar de `/opt/p4import` map gaat en `git log` uitvoert, kun je je geimporteerde werk zien:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

Je kunt de `git-p4` identificator in iedere commit zien. Het is fijn om die identificator daar te bewaren, voor het geval je later naar het Perforce wijzigings nummer moet refereren. Maar, als je de identificator wilt verwijderen, is nu het geschikte moment om dat te doen – voordat je begint met werken op de nieuwe repository. Je kunt `git filter-branch` gebruiken om de identificatie tekst en masse te verwijderen:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

Als je `git log` uitvoert, kun je zien dat alle SHA-1 checksums voor de commits gewijzigd zijn, maar de `git-p4` teksten staan niet langer in de commit berichten:

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

Je import is nu klaar om naar je nieuwe Git server gepushed te worden.

### Een Eigen Importeerder ###

Als het door jou gebruikte systeem niet Subversion of Perforce is, zou je online voor een importeerder moeten zoeken – er zijn importeerders van goede kwaliteit beschikbaar voor CVS, Clear Case, Visual Source Safe, en zelfs een map met archieven. Als geen van deze tools voor jou geschikt is, je hebt een zeldzamer tool, of je hebt om een andere reden een eigen import proces nodig, dan zou je `git fast-import` moeten gebruiken. Dit commando leest eenvoudige instructies van stdin om specifieke Git data te schrijven. Het is veel eenvoudiger om op deze manier Git objecten te maken, dan de rauwe Git commando's uit te voeren, of om te proberen de rauwe objecten te schrijven (zie hoofdstuk 9 voor meer informatie). Op deze manier kun je een import script schrijven dat de noodzakelijke data uit het systeem leest dat je aan het importeren bent en rechttoe rechtaan instructies op stdout afdrukt. Je kunt dit programma dan uitvoeren en de output door `git fast-import` sluizen.

Voor een snelle demonstratie zul je een eenvoudige importeerde schrijven. Stel dan je in current werkt, waarbij je je project eens in de zoveel tijd backup'ed door de map te kopieeren naar een backup map die gelabeled is met de tijd `back_YYYY_MM_DD`, en je wil dit in Git importeren. Je mapstructuur ziet er zo uit:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

Om naar een Git map te importeren, moet je bekijken hoe Git zijn data opslaat. Je kunt je misschien herinneren dat Git in fundament een gelinkte lijst is met commit objecten die naar een snapshot van inhoud wijzen. Het enige dat je hoeft te doen, is `fast-import` vertellen wat de inhoud snapshots zijn, welke commit data er naar wijst en de volgorde waarin ze moeten staan. Je strategie bestaat uit het doorlopen van de snapshots en commits te creëeren met de inhoud van iedere map, waarbij je iedere commit terug linked met de vorige.

Zoals je dat gedaan hebt in de "Een Voorbeeld van Git Afgedwongen Beleid" sectie van Hoofdstuk 7, gaan we dit in Ruby schrijven, omdat het is waar ik over het algemeen mee werk en het neigt eenvoudig te lezen te zijn. Je kunt dit voorbeeld vrij eenvoudig schrijven in alles waar je bekend mee bent – het hoeft alleen de juiste informatie naar stdout te schrijven. En dat betekent dat als je op Windows werkt, je erg voorzichtig moet zijn om geen carriage returns te introduceren aan het einde van je regels – git fast-import is erg kieskeurig in de manier waarop hij slechts line feeds (LF) wil hebben en niet de cariage return line feeds (CRLF), die Windows gebruikt.

Om te beginnen ga je naar de doelmap en identificeer je iedere submap, waarvan elk een snapshot is dat je als commit wil importeren. Je zult in iedere submap gaan en de noodzakelijke commando's printen om ze te exporteren. Je basis hoofdlus ziet er zo uit:

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do 
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

Je voert `print_export` uit binnen iedere map, wat het manifest en het merk van de vorige snapshot neemt, en het manifest en merk van deze terug geeft; op die manier kun je ze goed linken. "Mark" is de `fast-import` term voor een identificator die je aan een commit geeft; terwijl je commits maakt, geef je ze een merk die je kunt gebruiken om vanuit andere commits naar te linken. Dus, het eerste wat je moet doen in je `print_export` functie is een merk genereren van de mapnaam:

	mark = convert_dir_to_mark(dir)

Je zult dit doen door een lijst van mappen te creëeren en de index waarde als merk te gebruiken, omdat een merk een geheel getal moet zijn. Je functie ziet er zo uit:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Nu dat je een geheel getal hebt als voorstelling van je commit, moet je een datum hebben voor de commit metadata. Omdat de datum is uitgedrukt in de naam van de map, zul je het daar uit moeten halen. De volgende regel in de `print_export` bestand is

	date = convert_dir_to_date(dir)

waarbij `convert_dir_to_date` als volgt gedefinieerd is

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

Dat geeft een geheel getal terug als waarde voor de datum van iedere map. Het laatste stukje meta-informatie dat je voor iedere commit nodig hebt is de committer data, wat je in een globale variabele stopt:

	$author = 'Scott Chacon <schacon@example.com>'

Nu ben je klaar om te beginnen met de commit data af te drukken voor je importeerder. De initiele informatie stelt dat je een commit object definieert en op welke branch het zit, gevolgd door het merk dat je gegenereerd hebt, de committer informatie en het commit bericht, en de vorige commit, als die er is. De code ziet er zo uit:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

Je stelt de tijdzone (-0700) hardgecodeerd in omdat dat eenvoudig is. Als je vanuit een ander systeem importeert, moet je de tijdzone als een compensatiewaarde specificeren.
Het commit bericht moet uitgedrukt worden in een speciaal formaat:

	data (size)\n(contents)

Het formaat bestaat uit de woorddata, de grootte van de data die gelezen moet worden, een newline, en als laatste de data. Omdat je hetzelfde formaat nodig hebt om later de bestandsinhoud te specificeren, zul je een hulpfunctie creëeren, `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

Het enige dat nog gespecificeerd moet worden is de bestandsinhoud voor ieder snapshot. Dit is makkelijk, omdat je ze allemaal in een map hebt – je kunt het `deleteall` commando afdruken, gevolgd door de inhoud van ieder bestand in de map. Git zal dan ieder snapshot op de juiste manier opslaan:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

Let op: Omdat veel systemen over hun revisie als veranderingen van de ene naar de andere commit denken, kan fast-import ook commando's aan waarbij bij iedere commit is gespecificeerd welke bestanden zijn toegevoegd, verwijderd, of aangepast en wat de nieuwe inhouden zijn. Je kunt de verschillen tussen snapshots berekenen en alleen deze data geven, maar om het zo te doen is complexer – je kunt net zo goed Git alle data geven en hem het uit laten zoeken. Als dit beter geschikt is voor jouw data, bekijk dan de `fast-import` man pagina voor details over hoe je jouw data op deze manier kunt aanleveren.

Het formaat om de nieuwe bestandsinhoud te tonen of een aangepast bestand met de nieuwe inhoud te specificeren is als volgt:

	M 644 inline path/to/file
	data (size)
	(file contents)

Hierbij is 644 de modus (als je uitvoerbare bestanden hebt, moet je dit detecteren en in plaats daarvan 755 specificeren), en inline verteld dat je de inhoud onmiddelijk na deze regel toont. Je `inline_data` functie ziet er zo uit:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

Je hergebruikt de `export_data` data functie, die je eerder gedefinieerd hebt, omdat het hetzelfde is als de manier waarop je je commit bericht data gespecificeerd hebt.

Het laatste wat je moet doen is het huidige merk teruggeven, zodat het meegegeven kan worden aan de volgende iteratie:

	return mark

Let op: Als je op Windows werkt, moet je er zeker van zijn dat je nog één extra stap toevoegt. Zoals voorheen gemeld is, gebruikt Windows CRLF als new line karakters, terwijl git fast-import alleen LF verwacht. Om om dit probleem heen te werken en git fast-import blij te maken, moet je ruby vertellen om LF in plaats van CRLF te gebruiken:

	$stdout.binmode

Dat is alles. Als je dit script uitvoert, zul je inhoud krijgen die er ongeveer zo uit ziet:

	$ ruby import.rb /opt/import_from 
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

Om de importeerder uit te voeren, sluis je deze uitvoer door `git fast-import` terwijl je in de Git map staat waar je naar toe wilt importeren. Je kunt een nieuwe map aanmaken en er dan `git init` in uitvoeren als startpunt, en dan kun je je script uitvoeren:

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

Zoals je kunt zien geeft het je een berg statistieken over wat het heeft bereikt, als het succesvol heeft kunnen afronden. In dit geval heb je in totaal 18 objecten geimporteerd, voor 5 commits in 1 branch. Nu kun je `git log` uitvoeren en je nieuwe historie zien:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

Hier heb je 't – een fijne, schone Git repository. Het is belangrijk om te zien dat nog niks uitgechecked is – je hebt om te beginnen geen bestanden in je werkmap. Om ze te krijgen moet je je branch resetten tot het punt waar `master` nu is:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

Je kunt nog veel meer doen met het `fast-import` tool – verschillende bestandsmodi behandelen, binaire gegevens, meerdere branches en merges, tags, voortgangsindicatoren, en meer. Een aantal voorbeelden voor complexe scenario's zijn voorhanden in de `contrib/fast-import` map van de Git broncode; een van de betere is het `git-p4` script dat ik zojuist behandeld heb.

## Samenvatting ##

Je zou je op je gemak moeten voelen om Git met Subversion te gebruiken, of bijna ieder bestaand repository te importeren in een Git versie zonder gegevens te verliezen. Het volgende hoofdstuk zal het rauwe binnenwerk van Git behandelen, zodat je iedere byte in elkaar kunt zetten, als dat nodig is.
