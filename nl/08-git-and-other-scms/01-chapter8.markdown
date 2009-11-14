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

### Teug naar Subversion Committen ###

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

## Migrating to Git ##

If you have an existing codebase in another VCS but you’ve decided to start using Git, you must migrate your project one way or another. This section goes over some importers that are included with Git for common systems and then demonstrates how to develop your own custom importer.

### Importing ###

You’ll learn how to import data from two of the bigger professionally used SCM systems — Subversion and Perforce — both because they make up the majority of users I hear of who are currently switching, and because high-quality tools for both systems are distributed with Git.

### Subversion ###

If you read the previous section about using `git svn`, you can easily use those instructions to `git svn clone` a repository; then, stop using the Subversion server, push to a new Git server, and start using that. If you want the history, you can accomplish that as quickly as you can pull the data out of the Subversion server (which may take a while).

However, the import isn’t perfect; and because it will take so long, you may as well do it right. The first problem is the author information. In Subversion, each person committing has a user on the system who is recorded in the commit information. The examples in the previous section show `schacon` in some places, such as the `blame` output and the `git svn log`. If you want to map this to better Git author data, you need a mapping from the Subversion users to the Git authors. Create a file called `users.txt` that has this mapping in a format like this:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

To get a list of the author names that SVN uses, you can run this:

	$ svn log --xml | grep author | sort -u | perl -pe 's/.>(.?)<./$1 = /'

That gives you the log output in XML format — you can look for the authors, create a unique list, and then strip out the XML. (Obviously this only works on a machine with `grep`, `sort`, and `perl` installed.) Then, redirect that output into your users.txt file so you can add the equivalent Git user data next to each entry.

You can provide this file to `git svn` to help it map the author data more accurately. You can also tell `git svn` not to include the metadata that Subversion normally imports, by passing `--no-metadata` to the `clone` or `init` command. This makes your `import` command look like this:

	$ git-svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Now you should have a nicer Subversion import in your `my_project` directory. Instead of commits that look like this

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029
they look like this:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Not only does the Author field look a lot better, but the `git-svn-id` is no longer there, either.

You need to do a bit of `post-import` cleanup. For one thing, you should clean up the weird references that `git svn` set up. First you’ll move the tags so they’re actual tags rather than strange remote branches, and then you’ll move the rest of the branches so they’re local.

To move the tags to be proper Git tags, run

	$ cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
	$ rm -Rf .git/refs/remotes/tags

This takes the references that were remote branches that started with `tag/` and makes them real (lightweight) tags.

Next, move the rest of the references under `refs/remotes` to be local branches:

	$ cp -Rf .git/refs/remotes/* .git/refs/heads/
	$ rm -Rf .git/refs/remotes

Now all the old branches are real Git branches and all the old tags are real Git tags. The last thing to do is add your new Git server as a remote and push to it. Because you want all your branches and tags to go up, you can run this:

	$ git push origin --all

All your branches and tags should be on your new Git server in a nice, clean import.

### Perforce ###

The next system you’ll look at importing from is Perforce. A Perforce importer is also distributed with Git, but only in the `contrib` section of the source code — it isn’t available by default like `git svn`. To run it, you must get the Git source code, which you can download from git.kernel.org:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

In this `fast-import` directory, you should find an executable Python script named `git-p4`. You must have Python and the `p4` tool installed on your machine for this import to work. For example, you’ll import the Jam project from the Perforce Public Depot. To set up your client, you must export the P4PORT environment variable to point to the Perforce depot:

	$ export P4PORT=public.perforce.com:1666

Run the `git-p4 clone` command to import the Jam project from the Perforce server, supplying the depot and project path and the path into which you want to import the project:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

If you go to the `/opt/p4import` directory and run `git log`, you can see your imported work:

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

You can see the `git-p4` identifier in each commit. It’s fine to keep that identifier there, in case you need to reference the Perforce change number later. However, if you’d like to remove the identifier, now is the time to do so — before you start doing work on the new repository. You can use `git filter-branch` to remove the identifier strings en masse:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

If you run `git log`, you can see that all the SHA-1 checksums for the commits have changed, but the `git-p4` strings are no longer in the commit messages:

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

Your import is ready to push up to your new Git server.

### A Custom Importer ###

If your system isn’t Subversion or Perforce, you should look for an importer online — quality importers are available for CVS, Clear Case, Visual Source Safe, even a directory of archives. If none of these tools works for you, you have a rarer tool, or you otherwise need a more custom importing process, you should use `git fast-import`. This command reads simple instructions from stdin to write specific Git data. It’s much easier to create Git objects this way than to run the raw Git commands or try to write the raw objects (see Chapter 9 for more information). This way, you can write an import script that reads the necessary information out of the system you’re importing from and prints straightforward instructions to stdout. You can then run this program and pipe its output through `git fast-import`.

To quickly demonstrate, you’ll write a simple importer. Suppose you work in current, you back up your project by occasionally copying the directory into a time-stamped `back_YYYY_MM_DD` backup directory, and you want to import this into Git. Your directory structure looks like this:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

In order to import a Git directory, you need to review how Git stores its data. As you may remember, Git is fundamentally a linked list of commit objects that point to a snapshot of content. All you have to do is tell `fast-import` what the content snapshots are, what commit data points to them, and the order they go in. Your strategy will be to go through the snapshots one at a time and create commits with the contents of each directory, linking each commit back to the previous one.

As you did in the "An Example Git Enforced Policy" section of Chapter 7, we’ll write this in Ruby, because it’s what I generally work with and it tends to be easy to read. You can write this example pretty easily in anything you’re familiar with — it just needs to print the appropriate information to stdout. And, if you are running on Windows, this means you'll need to take special care to not introduce carriage returns at the end your lines — git fast-import is very particular about just wanting line feeds (LF) not the carriage return line feeds (CRLF) that Windows uses.

To begin, you’ll change into the target directory and identify every subdirectory, each of which is a snapshot that you want to import as a commit. You’ll change into each subdirectory and print the commands necessary to export it. Your basic main loop looks like this:

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

You run `print_export` inside each directory, which takes the manifest and mark of the previous snapshot and returns the manifest and mark of this one; that way, you can link them properly. "Mark" is the `fast-import` term for an identifier you give to a commit; as you create commits, you give each one a mark that you can use to link to it from other commits. So, the first thing to do in your `print_export` method is generate a mark from the directory name:

	mark = convert_dir_to_mark(dir)

You’ll do this by creating an array of directories and using the index value as the mark, because a mark must be an integer. Your method looks like this:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Now that you have an integer representation of your commit, you need a date for the commit metadata. Because the date is expressed in the name of the directory, you’ll parse it out. The next line in your `print_export` file is

	date = convert_dir_to_date(dir)

where `convert_dir_to_date` is defined as

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

That returns an integer value for the date of each directory. The last piece of meta-information you need for each commit is the committer data, which you hardcode in a global variable:

	$author = 'Scott Chacon <schacon@example.com>'

Now you’re ready to begin printing out the commit data for your importer. The initial information states that you’re defining a commit object and what branch it’s on, followed by the mark you’ve generated, the committer information and commit message, and then the previous commit, if any. The code looks like this:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

You hardcode the time zone (-0700) because doing so is easy. If you’re importing from another system, you must specify the time zone as an offset. 
The commit message must be expressed in a special format:

	data (size)\n(contents)

The format consists of the word data, the size of the data to be read, a newline, and finally the data. Because you need to use the same format to specify the file contents later, you create a helper method, `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

All that’s left is to specify the file contents for each snapshot. This is easy, because you have each one in a directory — you can print out the `deleteall` command followed by the contents of each file in the directory. Git will then record each snapshot appropriately:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

Note:	Because many systems think of their revisions as changes from one commit to another, fast-import can also take commands with each commit to specify which files have been added, removed, or modified and what the new contents are. You could calculate the differences between snapshots and provide only this data, but doing so is more complex — you may as well give Git all the data and let it figure it out. If this is better suited to your data, check the `fast-import` man page for details about how to provide your data in this manner.

The format for listing the new file contents or specifying a modified file with the new contents is as follows:

	M 644 inline path/to/file
	data (size)
	(file contents)

Here, 644 is the mode (if you have executable files, you need to detect and specify 755 instead), and inline says you’ll list the contents immediately after this line. Your `inline_data` method looks like this:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

You reuse the `export_data` method you defined earlier, because it’s the same as the way you specified your commit message data. 

The last thing you need to do is to return the current mark so it can be passed to the next iteration:

	return mark

NOTE: If you are running on Windows you'll need to make sure that you add one extra step. As metioned before, Windows uses CRLF for new line characters while git fast-import expects only LF. To get around this problem and make git fast-import happy, you need to tell ruby to use LF instead of CRLF:

	$stdout.binmode

That’s it. If you run this script, you’ll get content that looks something like this:

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

To run the importer, pipe this output through `git fast-import` while in the Git directory you want to import into. You can create a new directory and then run `git init` in it for a starting point, and then run your script:

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

As you can see, when it completes successfully, it gives you a bunch of statistics about what it accomplished. In this case, you imported 18 objects total for 5 commits into 1 branch. Now, you can run `git log` to see your new history:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

There you go — a nice, clean Git repository. It’s important to note that nothing is checked out — you don’t have any files in your working directory at first. To get them, you must reset your branch to where `master` is now:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

You can do a lot more with the `fast-import` tool — handle different modes, binary data, multiple branches and merging, tags, progress indicators, and more. A number of examples of more complex scenarios are available in the `contrib/fast-import` directory of the Git source code; one of the better ones is the `git-p4` script I just covered.

## Summary ##

You should feel comfortable using Git with Subversion or importing nearly any existing repository into a new Git one without losing data. The next chapter will cover the raw internals of Git so you can craft every single byte, if need be.
