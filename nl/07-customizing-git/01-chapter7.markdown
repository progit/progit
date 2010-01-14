# Git op Maat Maken #

Tot zover heb ik de basale werking van Git behandeld, en hoe het te gebruiken, en ik heb een aantal tools geintroduceerd die Git levert om je het makkelijk en efficient te laten gebruiken. In dit hoofdstuk zal ik wat operaties doorlopen die je kunt gebruiken om Git op een meer persoonlijke manier te laten werken door een aantal belangrijke configuratie instellingen te introduceren en het haken systeem. Met deze gereedschappen is het makkelijk om Git precies te laten werken op de manier zoals jij, je bedrijf, of je groep het graag wil.

## Git Configuratie ##

Zoals je kort in Hoofdstuk 1 gezien hebt, kun je Git configuratie instellingen specificeren met het `git config` commando. Een van de eerste dingen die je deed wat je naam en e-mail adres instellen:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Nu zul je een paar van de meer interessante opties leren, die je op deze manier kunt instellen om je Git op maat te maken.

Je zag wat eenvoudige Git configuratie details in het eerste hoofdstuk, maar ik zal ze hier nog eens snel laten zien. Git gebruikt een aantal configuratie bestanden om het niet-standaard gedrag dat je wil te bepalen. De eerste plaats waar Git kijkt voor deze waarden is in een `/etc/gitconfig` bestand, wat de waarden bevat voor alle gebruikers op het systeem en al hun repositories. Als je de optie `--systeem` aan `git config` meegeeft, leest en schrijft het specifiek naar dit bestand.

De volgende plaats waar Git kijkt is het `~/.gitconfig` bestand, wat specifiek is voor iedere gebruiker. Je kunt er voor zorgen dat Git naar dit bestand leest en schrijft door de `--global` optie mee te geven.

Als laatste kijkt Git naar configuratie waarden in het config bestand in de Git map (`.git/config`) of welk repository dat je op dat moment gebruikt. Deze waarden zijn specifiek voor dat ene repository. Ieder nivo overschrijft de waarden in het vorige nivo, dus waarden in `.git/config` gaan boven die in `/etc/gitconfig`, bijvoorbeeld. Je kunt die waarden ook instellen door het bestand handmatig aan te passen en de correcte syntax in te voegen, maar het is over het algemeen makkelijk m het `git config` commando uit te voeren.

### Basis Client Configuratie ###

De configuratie opties die herkent worden door Git vallen binnen twee categorien: de client kant en de server kant. De meerderheid van de opties zijn voor de client kant – de configuratie van je persoonlijke voorkeuren. Alhoewel er massa's opties beschikbaar zijn, zal ik alleen een paar behandelen die ofwel veelgebruikt zijn of je werkwijze significant kunnen beinvloeden. Veel opties zijn alleen bruikbaar in randgevallen waar ik hier niet naar kijk. Als je een lijst van alle opties wil zien, die jou versie van Git herkent kun je dit uitvoeren

	$ git config --help

De gebruikershandleiding voor `git config` toont alle beschikbare opties in groot detail.

#### core.editor ####

Standaard zal Git de standaard tekst editor gebruiken, die je hebt ingesteld of anders terugvallen op de Vi editor om je commit en tag boodschappen te maken of te wijzigen. Om die instelling naar iets anders om te zetten, kun je de `core.editor` instelling gebruiken:

	$ git config --global core.editor emacs

Zonder dat het uitmaakt wat je als je standaard shell editor waarde ingesteld hebt, zal Git Emacs starten om boodschappen aan te passen.

#### commit.template ####

Als je dit als een pad instelt dat naar een bestand op je systeem wijst, zal Git dat bestand als de standaard boodschap gebruiken als je commit. Bijvoorbeeld, stel dat je een sjabloon bestand aanmaakt als `$HOME/.gitmessage.txt` die er zo uitziet:

	onderwerp regel

	wat er gebeurd is

	[ticket: X]

Om Git te vertellen dat het dit moet gebruiken als standaard boodschap dat in je editor moet verschijnen als je `git commit` uitvoert, stel je de `commit.template` configuratie waarde in:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

Daarna zal je editor zoiets als dit openen als je standaard commit boodschap als je commit:

	onderwerp regel

	wat er gebeurd is

	[ticket: X]
	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	# modified:   lib/test.rb
	#
	~
	~
	".git/COMMIT_EDITMSG" 14L, 297C

Als je een beleid hebt voor commit boodschappen, dan vergroot het plaatsen van een sjabloon voor dat beleid op je systeem en het configureren ervan voor Git om het als standaard te gebruiken de kans dat dat beleid met regelmaat gevolgd wordt.

#### core.pager ####

De instelling voor 'core.pager' bepaald welke pagineer applicatie gebruikt wordt door Git om de uitvoer van `log` en `diff` weer te geven. Je kunt het instellen als `more` of als je favoriete pagineerder (standaard is het `less`), of je kunt het uit zetten door het als een lege tekst in te stellen: 

	$ git config --global core.pager ''

Als je dat uitvoert, zal Git de gehele uitvoer van alle commando's pagineren, hoe lang het ook is.

#### user.signingkey ####

Als je gebruik maakt van ondertekende tags (zoals besproken in Hoofdstuk 2), dan maakt het instellen van je GPG signeer sleutel als configuratie instelling het leven eenvoudiger. Stel je sleutel ID zo in:

	$ git config --global user.signingkey <gpg-key-id>

Nu kun je je tags signeren zonder steeds je sleutel op te hoeven geven bij het `git tag` commando:

	$ git tag -s <tag-name>

#### core.excludesfile ####

Je kunt patronen in het `.gitignore` bestand van je project zetten zodat Git ze niet ziet als ongevolgde bestanden of ze niet zal proberen te stagen als je `git add` op ze uitvoert, zoals besproken in Hoofdstuk 2. Maar als je wilt dat een ander bestand buiten je project die waarden of extra waarden bevat, kun je Git vertellen met de `core.excludesfile` vertellen waar dat bestand is. Stel het eenvoudigweg in als een pad naar een bestand dat een inhoud heeft dat vergelijkbaar is met wat een `.gitignore` bestand zou hebben.

#### help.autocorrect ####

Deze optie is alleen beschikbaar in Git 1.6.1. en later. Als je een commando in Git 1.6 verkeerd typed, toont het je zoiets als dit:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Als je `het.autocorrect` op 1 instelt, zal Git autoamitsch het commando uitvoeren als het slechts één passend commando heeft in dit scenario.

### Kleuren in Git ###

Git kan zijn uitvoer in je terminal kleuren, wat je kan helpen om de uitvoer snel en eenvoudig visueel te begrijpen. Een aantal opties kan je helpen om de kleuren naar je voorkeur in te stellen.

#### color.ui ####

Git zal automatisch het meeste van zijn uitvoer kleuren als je het vraagt. Je kunt erg specifiek zijn in wat je gekleurd wil en hoe; maar om alle standaard kleuren in de terminal aan te zetten, stel dan `color.ui` in op true:

	$ git config --global color.ui true

Als deze waarde ingesteld is, zal Git zijn uitvoer kleuren zodra deze naar een terminal gaat. Andere mogelijke opties zijn false, wat de uitvoer nooit kleurt, en always, wat de kleuren altijd weergeeft, zelfs als je Git commando's omleidt naar een bestand of naar een ander commando doorsluist. Deze instelling is toegevoegd in Git 1.5; als je een oudere versie hebt, zul je alle kleuren instellingen individueel in moeten stellen.

Je zult zelden `color.ui = always` willen. In de meeste scenario's, als je kleuren in je omgeleide uitvoer wil, kun je een `--color` vlag aan het Git commando meegeven om het te forceren kleuren te gebruiken. De `color.ui = true` instelling is vrijwel altijd hetgene je wil gebruiken.

#### `color.*` ####

Als je meer specifiek wil zijn welke commando's gekleurd moeten zijn en hoe, of je hebt een oudere versie, dan voorziet Git in woord specifieke kleuren instellingen. Ieder van deze kan worden ingesteld op `true`, `false` of `always`:

	color.branch
	color.diff
	color.interactive
	color.status

Daarnaast heeft ieder van deze ook sub-instellingen die je kunt gebruiken om specifieke kleuren in te stellen voor delen van de uitvoer, als je iedere kleur wilt overschrijven. Bijvoorbeeld, om de meta informatie in je diff uitvoer in blauwe voorgrond, zwarte achtergrond en vetgedrukt in te stellen, kun je dit uitvoeren

	$ git config --global color.diff.meta “blue black bold”

Je kunt de kleur instellen op ieder van de volgende waarden: normal, black, red, green, yellow, blue, magenta, cyan, of white. Als je een attribuut wil hebben, zoals vetgerukt in het vorige voorbeeld, kun je kiezen uit bold, dim, ul, blink en reverse.

Zie de manpage van `git config` voor alle sub-instellingen die je kunt instellen, als je dat wil.

### Externe Merge en Diff Tools ###

Alhoewel Git een interne implementatie van diff heeft, die je tot nog toe gebruikte, kun je in plaats daarvan een extern tool instellen. Je kunt ook een grafisch samenvoeg conflict-oplossings tool instellen, in plaats van handmatig de conflicten op te moeten lossen. Ik zal nu demonstreren hoe je het Perforce Visuele Samenvoeg Tool (P4Merge) in moet stellen, om je diff en samenvoeg oplossingen te doen, omdat het een fijn grafisch tool is en omdat het gratis is.

P4Merge werkt op alle grote platformen als je dit wil proberen, dus je zou het moeten kunnen doen. Ik zal in de voorbeelden paden gebruiken die op Mac en Linux systemen werken; voor Windows moet je `/usr/local/bin` veranderen in een pad naar een uitvoerbaar bestand in je omgeving.

Je kunt P4Merge hier downloaden:

	http://www.perforce.com/perforce/downloads/component.html

Om te beginnen zul je externe wrapper scripts instellen om je commando's uit te voeren. Ik zal het Mac pad gebruiken voor de applicatie; in andere systemen zal het moeten wijzen naar waar de `p4merge` binary geinstalleerd is. Stel een samenvoeg wrapper script in, genaamd `extMerge`, die je applicatie met alle meegegeven argumenten aanroept:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

De diff wrapper controleert dat er zeker zeven argumenten meegegeven zijn, en geeft twee ervan aan je samenvoeg script. Standaard geeft Git de volgende argumenten aan het diff programma mee:

	path old-file old-hex old-mode new-file new-hex new-mode

Omdat je alleen de `oude-bestand` en `nieuwe-bestand` argumenten wil, zul je het wrapper script gebruiken om degenen door te geven die je wil.

	$ cat /usr/local/bin/extDiff 
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Je moet er ook zeker van zijn dat deze tools uitvoerbaar zijn:

	$ sudo chmod +x /usr/local/bin/extMerge 
	$ sudo chmod +x /usr/local/bin/extDiff

Nu kun je je config bestand instellen dat het je eigengemaakte samenvoeg en diff tools gebruikt. Dit wordt gedaan met een aantal eigen instellingen: `merge.tool` om Git te vertellen welke strategie hij moet gebruiken, `mergetool.*.cmd` om te specificeren hoe het het commando moet uitvoeren, `mergetool.trustExitCode` om Git te vertellen of de exit code van dat programma een succesvolle samenvoeging betekent of niet, en `diff.external` om Git te vertellen welk commando het moet uitvoeren voor diffs. Dus, je kunt of vier configuratie commando's uitvoeren

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

of je kunt je `~/.gitconfig` bestand aanpassen en deze regels toevoegen:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

Nadat dit alles ingesteld is, zul je als je diff commando's zoals deze uitvoert:
	
	$ git diff 32d1776b1^ 32d1776b1

in plaat van de uitvoer van diff op de commando regel, een instantie van P4Merge gestart door Git krijgen, wat er uitziet zoals in Figuur 7-1.

Insert 18333fig0701.png 
Figuur 7-1. P4Merge.

Als je twee branches probeert samen te voegen en je krijgt conflicten, dan kun je het `git mergetool` commando uitvoeren; het start P4Merge op om je het conflict op te laten lossen met behulp van dat GUI tool.

Het aardige van deze wrapper opstelling is dat je je diff en merge tools eenvoudig aan kunt passen. Bijvoorbeeld, om je `extDiff` en `extMerge` tools in te stellen dat ze in plaats daarvan het KDiff3 tool uitvoeren, is het enige dat je moet doen je `extMerge` bestand aanpassen:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh	
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

Nu zal Git het KDiff3 tool gebruiken voor het tonen van diff en het oplossen van samenvoeg conflicten.

Git is al ingesteld om een aantal andere conflict-oplossings tools te gebruiken zonder dat je de cmd configuratie in hoeft te stellen. Je kunt je merge tool op kdiff3 instellen, of opendiff, tkdiff, meld, xxdiff, emerge, vimdiff of gvimdiff. Als je niet geinteresseerd bent in het gebruik van KDiff3 als diff, maar het liever alleen wilt gebruiken voor conflict oplossing, en het kdiff3 commando zit in je pad, dan kun je dit uitvoeren

	$ git config --global merge.tool kdiff3

Als je dit uitvoert in plaats van de `extMerge` en `extDiff` bestanden in te stellen, zal Git KDiff3 gebruiken voor conflict oplossing en het normale Git diff tool voor diffs.

### Opmaak en Witruimten ###

Problemen met opmaak en witruimten zijn één van de veelvoorkomende frustrerende en subtiele problemen die veel ontwikkelaars tegenkomen bij het samenwerken, in het bijzonder over verschillende platformen. Het is heel eenvoudig voor patches en ander werk om subtiele witruimte veranderingen te introduceren, omdat editors ze stil introduceren of omdat Windows programmeurs harde returns aan het eind van de regels toevoegen die ze aanraken in gekruiste platformprojecten. Git heeft een aantal configuratie opties om met deze problemen te helpen.

#### core.autocrlf ####

Als je op Windows programmeert, of een ander systeem gebruikt maar samenwerkt met mensen die op Windows werken, zul je vroeg of laat waarschijnlijk tegen regeleinde problemen aanlopen. Dat komt omdat Windows zowel een harde return als ook een linefeed karakter gebruikt voor regeleindes in zijn bestanden, waar Mac en Linux systemen alleen het linefeed karakter gebruiken. Dit is een subtiel maar verschrikkelijk irritant feit van het werken met gekruiste platformen.

Git kan hiermee omgaan door CRLF regeleinden automatisch om te zetten naar LF zodra je commit, en vice versa op het moment dat je code uitchecked op je systeem. Je kunt deze functionaliteit aanzetten met de `core.autocrlf` instelling. Als je op een Windows machine zit, stel het dan in op `true` – dit veranderd LF regeleinden in CRLF zodra je code uitchecked:

	$ git config --global core.autocrlf true

Als je op een Linux of Mac systeem zit dat LF regeleinden gebruikt, dan wil je niet dat Git ze autoamisch veranderd op het moment dat Git bestanden uitchecked; maar als een bestand met CRLF regeleinden onverhoopt toch geintroduceerd wordt, dan wil je misschien dat Git dit repareert. Je kunt Git vertellen dat je wilt dat hij CRLF in LF veranderd tijdens het committen, maar niet de andere kant op door het instellen van `core.autocrlf` op input:

	$ git config --global core.autocrlf input

Deze instelling zal CRLF regeleinden in Windows checkouts gebruiken, en LF einden in Mac en Linux systemen en in het repository moeten laten.

Als je een Windows programmeur bent, die een alleen-Windows project doet, dan kun je deze functionaliteit uitzetten, waarmee de harde returns in het repository opgeslagen worden door de configuratie waarde op `false` te zetten:

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git is vooraf ingesteld om een aantal witruimte problemen te detecteren en te repareren. Het kan op vier veelvoorkomende witruimte problemen letten – twee stan er standaard aan en kunnen uitgezet worden, en twee staan er standaard niet aan, maar kunnen aangezet worden.

De twee die standaard aan staan zijn `trailing-space`, wat kijkt of er spaties aan het eind van een regel staan, en `space-before-tab`, wat kijkt of er spaties voor tabs staan aan het begin van een regel.

De twee die standaard uit staan, maar aangezet kunnen worden, zijn `indent-with-non-tab`, wat kijkt naar regels die met acht of meer spaties beginnen in plaats van tabs, en `cr-at-eol`, wat Git verteld dat harde returns aan het eind van een regel OK zijn.

Je kunt Git vertellen welke van deze je aan wil zetten door `core.whitespace` naar de waardes in te stellen die je aan of uit wil, gescheiden door komma's. Je kunt waarden uitzetten door ze weg te laten uit de instelling tekst of door een `-` vooraf te laten gaan aan de waarde. Bijvoorbeeld, als je alles aan wil behalve `cr-ar-eol`, dan kun je dit doen:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Git zal deze problemen detecteren zodra je een `git diff` commando uitvoert en ze proberem te kleuren zodat je ze kunt repareren alvorens te committen. Het zal deze waarden ook gebruiken om je te helpen met patches toe te passen met `git apply`. Als je patches gaat toepassen, kun je Git vragen om je te waarschuwen als hij patches toepast waarin deze specifieke witruimte problemen zitten:

	$ git apply --whitespace=warn <patch>

Of je kunt Git vragen om automatisch deze problemen te repareren alvorens de patch toe te passen:

	$ git apply --whitespace=fix <patch>

Deze opties zijn ook op de git rebase optie van toepassing. Als je witruimte problemen gecommit hebt maar ze nog niet stroomopwaarts gepushed hebt, kun je een `rebase` uitvoeren met de `--whitespace=fix` optie uitvoeren om Git automatisch witruimte problemen te laten repareren zodra het de patches herschrijft.

### Server Configuratie ###

Er zijn lang niet zoveel configuratie opties beschikbaar voor de server kant van Git, maar er zijn er een paar interessante bij waar je misschien notie van wil hebben.

#### receive.fsckObjects ####

Standaard zal Git niet alle objecten die hij ontvangt gedurende een push op consistentie controleren. Alhoewel Git kan controleren of ieder object nog steeds bij zijn SHA-1 checksum past en naar geldige objecten wijst, doet hij dat niet standaard bij iedere push. Dit is een relatief dure operatie en kan veel tijd kosten voor iedere push, afhankelijk van de grootte van het repository of de push. Als je wil dat Git ieder object op consistentie controleert bij iedere push, dan kun je hem dwingen door `receive.fsckObjects` op true te zetten:

	$ git config --system receive.fsckObjects true

Nu zal Git de integriteit van je repository controleren voor iedere push geaccepteerd wordt, om er zeker van te zijn dat kapotte clients geen corrupte gegevens introduceren.

#### receive.denyNonFastForwards ####

Als je commits rebased die je al gepushed hebt en dan nog eens pushed, of op een andere manier een commit probeert te pushen naar een remote branch die niet de commit bevat waarnaar de remote branch op het moment wijst, dan wordt dat afgewezen. Dit is over het algemeen een goed beleid; maar in het geval van de rebase, kun je besluiten dat je weet waar je mee bezig bent en kun je de remote branch geforceerd vernieuwen door een `-f` vlag met je push commando mee te geven.

Om de mogelijkheid van het geforceerd vernieuwen van remote branches naar niet fast-forward referenties uit te schakelen, stel je `receive.denyNonFastForwards` in:

	$ git config --system receive.denyNonFastForwards true

Een andere manier waarop je dit kunt doen is het instellen van ontvangst haken op de server, wat we zometeen gaan behandelen. Die aanpak staat je toe meer complexe dingen te doen, zoals het weigeren van niet fast-forwards aan een bepaalde set gebruikers.

#### receive.denyDeletes ####

Een van de wegen om een `denyNonFastForwards` beleid heen is dat de gebruiker de branch verwijderd en het dan opnieuw terug pushed met de nieuwe referentie. In nieuwere versies van Git (beginnend bij versie 1.6.1), kun je `receive.denyDeletes` op true zetten:

	$ git config --system receive.denyDeletes true

Dit weigert branch en tag verwijdering door middel van een push over de hele breedte – geen enkele gebruiker mag het meer. Om remote branches te verwijderen, moet je de ref bestanden handmatig verwijderen van de server. Er zijn ook interessantere manieren om dit te doen op een per gebruiker basis door middel van ACL's, zoals je zult leren aan het eind van dit hoofdstuk.

## Git Attributen ##

Een aantal van deze instellingen kan ook gedaan worden voor een pad, zodat Git die instellingen alleen toepast om een submap of subset van bestanden. Deze pad-specifieke instellingen worden Git attributen genoemd en worden in een `.gitattribute` bestand in een van je mappen (normaliter in de hoofdmap van je project) of in het `.git/attributes` bestand als je niet wilt dat het attributes bestand gecommit wordt met je project.

Door attributes te gebruiken kun je dingen doen als het specificeren van aparte samenvoeg strategieën voor individuele bestanden of mappen in je project, Git vertellen hoe hij niet-tekst bestanden kan diff'en, of Git inhoud laten filteren voordat je het in- of uitchecked van Git. In deze sectie zul je iets leren over de attributen die je kun instellen op de paden in je Git project en een paar voorbeelden zien hoe je deze eigenschap in de praktijk gebruikt.

### Binaire Bestanden ###

Een stoere truc waarvoor je Git attributen kunt gebruiken is het vertellen aan Git welke bestanden binair zijn (in die gevallen waarin hij het niet zelf kan uitvinden) en Git dan speciale instructies geven hoe die bestanden te behandelen. Bijvoorbeeld, sommige tekstbestanden worden gegenereerd en zijn niet te diff'en, of sommige binaire bestanden kunnen wel gediff'ed worden – je zult zien hoe je Git verteld welke soort het is.

#### Binaire Bestanden Identificeren ####

Sommige bestanden zien eruit als tekstbestanden, maar moeten toch behandeld worden als binaire gegevens. Bijvoorbeeld, Xcode projecten op de Mac bevatten een bestand dat eindigt in `.pbxproj`, wat eigenlijk een JSON (platte tekst javascript gegevens formaat) gegevensset is, dat geschreven wordt naar de schijf door de IDE, waarin je bouw instellingen opgeslagen zijn enzovoorts. Alhoewel het technisch een tekstbestand is, omdat het volledig ASCII is, zul je het niet als zodanig willen behandelen omdat het eigenlijk een lichtgewicht gegevensbank is – je kunt de inhoud niet samenvoegen als twee mensen het gewijzigd hebben, en diffs zijn over het algemeen niet behulpzaam. Het bestand is bedoeld om geconsumeerd te worden door een machine. In essentie wil je het behandelen als een binair bestand.

Om Git te vertellen dat hij alle `pbxproj` bestanden als binaire gegevens moet behandelen, voeg je de volgende regel toe aan je `.gitattributes` bestand:

	*.pbxproj -crlf -diff

Nu zal Git niet proberen om CRLF problemen te veranderen of te repareren; noch zal het proberen een diff te berekenen of te tonen voor de veranderingen in dit bestand als je git show of git diff uitvoert op je project. In de 1.6 serie van Git, kun je ook een macro gebruiken die meegeleverd wordt, en die `-crlf -diff` betekend:

	*.pbxproj binary

#### Binaire Bestanden Diff'en ####

In de 1.6 serie van Git, kun je de functionaliteit van Git attributen gebruiken om binaire bestanden effectief te diff'en. Je doet dit door Git te vertellen hoe het binaire gegevens naar tekst formaat moet omzetten, die dan via de normale diff vergeleken kan worden.

Omdat dit een erg stoer en weinig gebruikte eigenschap is, zal ik een paar voorbeelden laten zien. Eerst zul je deze techniek gebruiken om een van de meest irritante problemen van deze mensheid op te lossen: Word documenten versie beheren. Iedereen weet dat Word een van de meest erge editors is die er te vinden is; maar, vreemd genoeg, gebruikt iedereen het. Als je Word documenten wil beheren, kun je ze in een Git repository stoppen en eens in de zoveel tijd committen; maar waar is dat goed voor? Als je `git diff` op een normale manier uitvoert, zie je alleen zoiets als dit:

	$ git diff 
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

Je kunt twee versies niet direct vergelijken, tenzij je ze uitchecked en ze handmatig doorloopt, toch? Het blijkt dat je dit redelijk goed kunt doen door Git attributen te gebruiken. Stop de volgende regel in je `.gitattributes` bestand:

	*.doc diff=word

Dit verteld Git dat ieder bestand dat dit patroon past (.doc) het "word" filter zou moeten gebruiken als je een diff probeert te bekijken, die veranderingen bevat. Wat is het "word" filter? Je zult het moeten instellen. Hier zul je Git configureren om het `strings` programma te gebruiken om Word documenten in leesbare tekstbestanden om te vormen, die het dan fatsoenlijk kan diff'en:

	$ git config diff.word.textconv strings

Nu weet Git dat als het een diff probeert te doen tussen twee snapshots, en een van de bestanden eindigt in `.doc`, dan zou het deze bestanden door het "word" filter moeten halen, wat is gedefinieerd als het `strings` programma. Dit maakt effectief twee tekst-gebaseerde versies van je Word bestanden, alvorens ze proberen te diff'en.

Hier is een voorbeeld. Ik heb Hoofdstuk 1 van dit boek in Git gestopt, wat tekst aan een paragraaf toegevoegd, en het document bewaard. Daarna heb ik `git diff` uitgevoerd om te zien wat er gewijzigd is:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
	 re going to cover how to get it and set it up for the first time if you don
	 t already have it on your system.
	 In Chapter Two we will go over basic Git usage - how to use Git for the 80% 
	-s going on, modify stuff and contribute changes. If the book spontaneously 
	+s going on, modify stuff and contribute changes. If the book spontaneously 
	+Let's see if this works.

Git verteld me succesvol en beknopt dat ik de tekst "Let's see if this works" heb toegevoegd, wat correct is. Het is niet perfect – het voegt een serie willekeurig spul aan het einde toe – maar het werkt wel. Als je een Word-naar-gewone-tekst omvormer kunt vinden of schrijven die goed genoeg werkt, dan zal die oplossing waarschijnlijk zeer effectief zijn. Maar, `strings` is op de meeste Mac en Linux machines beschikbaar, dus dit kan een goede eerste poging zijn om dit te gebruiken bij andere binaire formaten.

Een ander interessant probleem dat je hiermee kunt oplossen in het diff'en van beeldbestanden. Een manier om dit te doen is JPEG bestanden door een filter te halen dat hun EXIF informatie eruit peutert – metadata die wordt opgeslagen met de meeste beeldbestanden. Als je het `exiftool` programma download en installeert, kun je het gebruiken om je plaatjes naar tekst over de metadata om te zetten, zodat de diff op z'n minst een tekstuele representatie van eventuele wijzigingen laat zien:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Als je een plaatje in je project veranderd en `git diff` uitvoert, dan zie je zoiets als dit:

	diff --git a/image.png b/image.png
	index 88839c4..4afcb7c 100644
	--- a/image.png
	+++ b/image.png
	@@ -1,12 +1,12 @@
	 ExifTool Version Number         : 7.74
	-File Size                       : 70 kB
	-File Modification Date/Time     : 2009:04:21 07:02:45-07:00
	+File Size                       : 94 kB
	+File Modification Date/Time     : 2009:04:21 07:02:43-07:00
	 File Type                       : PNG
	 MIME Type                       : image/png
	-Image Width                     : 1058
	-Image Height                    : 889
	+Image Width                     : 1056
	+Image Height                    : 827
	 Bit Depth                       : 8
	 Color Type                      : RGB with Alpha

Je kunt eenvoudig zien dat zowel de bestandsgrootte als de beeld dimensies gewijzigd zijn.

### Keyword Expansie ###

Keyword expansie zoals in SVN of CVS wordt vaak gevraagd door ontwikkelaars, die gewend zijn aan die systemen. Het grote probleem in Git is dat je een bestand niet mag wijzigen met informatie over de commit, nadat je het gecommit hebt, omdat Git eerst de checksum van het bestand maakt. Maar, je kunt tekst in een bestand injecteren zodra het uitgechecked wordt en opnieuw verwijderen voordat het aan een commit toegevoegd wordt. Met Git attributen zijn er twee manieren om dit te doen.

Als eerste kun je de SHA-1 checksum van een blob automatisch in een `$Id$` veld in het bestand stoppen. Als je dit attribuut op een bestand of serie bestanden insteld, dan zal Git de volgende keer dat je die branch uitchecked dat veld vervangen met de SHA-1 van de blob. Het is belangrijk om op te merken dat het niet de SHA van de commit is, maar van de blob zelf:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

De volgende keer dat je dit bestand uitchecked, injecteerd Git de SHA van de blob:

	$ rm text.txt
	$ git checkout -- text.txt
	$ cat test.txt 
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Maar, het resultaat is slechts beperkt bruikbaar. Als je sleutelwoord vervanging in CVS of Subversion gebruikt hebt, kun je een tijdsstempel toevoegen – de SHA is niet zo bruikbaar, omdat het vrij willekeurig is en je kunt niet zeggen of een SHA ouder of nieuwer is dan een andere.

Het blijkt dat je je eigen filters voor het doen van vervanging bij commit/checkout kunt schrijven. Dit zijn de "clean" en "smudge" filters. In het `.gitattributes` bestand, kun je een filter op bepaalde paden instellen en dan scripts instellen die bestanden bewerkt vlak voordat ze gecommit worden ("clea", zie Figuur 7-2) en vlak voordat ze uitgechecked worden ("smudge", zie Figuur 7-3). De filters kunnen ingesteld worden zodat ze allerlei leuke dingen doen.

Insert 18333fig0702.png 
Figuur 7-2. Het “smudge” filter wordt bij checkout uitgevoerd.

Insert 18333fig0703.png 
Figuur 7-3. Het “clean” filter wordt uitgevoerd zodra bestanden worden gestaged.

De originele commit boodschap voor deze functionaliteit geeft een eenvoudig voorbeeld hoe je al je C broncode door het `indent` programma kunt halen alvorens te committen. Je kunt het instellen door het filter attribuut in je `.gitattributes` bestand te veranderen zodat `*.c` bestanden door het "inden" filter gehaald worden:

	*.c     filter=indent

Vervolgens vertel je Git wat het "indent" filter doet bij smudge en clean:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

In dit geval zal Git, als je bestanden commit die op `*.c` passen, ze door het indent programma halen alvorens ze te committen, en ze door het `cat` programma halen alvorens ze op de schijf uit te checken. Het `cat` programma is eigenlijk een no-op: het spuugt dezelfde gegevens uit als dat het inneemt. Deze combinatie zal effectief alle C broncode bestanden door `indent` filteren alvorens te committen.

Een ander interessant voorbeeld is `$Date$` sleutelwoord expansie, in RCS stijl. Om dit goed te doen, moet je een klein script hebben dat een bestandsnaam pakt, de laatste commit datum voor dit project uitvogelt, en de datum in een bestand toevoegt. Hier volgt een klein Ruby script dat dat doet:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Het enige dat het script doet is de laatste commit datum uit het `git log` commando halen, het in iedere `$Date$` tekst stoppen die het in stdin ziet, en de resultaten afdrukken – het moet eenvoudig te doen zijn in welke taal je je ook thuisvoelt. Je kunt dit bestand `expand_date` noemen en het in je pad stoppen. Nu moet je een filter in Git instellen (noem het `dater`), en het vertellen je `expand_date` filter te gebruiken om de bestanden tijdens checkout te 'smudgen'. Je zult een Perl expressie gebruiken om dat op te ruimen tijdens een commit:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Dit Perl stukje haalt alles weg dat het in en `$Date$` tekst ziet, om terug te komen vanwaar je gekomen bent. Nu je filter klaar is, kun je het testen door een bestand aan te maken met je `$Date$` sleutelwoord en dan een Git attribuut voor dat bestand in te stellen, die het nieuwe filter gebruikt.

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

Als je die veranderingen commit en het bestand opnieuw uitchecked, zul je zien dat het sleutelwoord vervangen is:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Je kunt wel zien hoe krachtig deze techniek is voor gebruik in eigengemaakte toepassingen. Je moet wel voorzichtig zijn, om dat het `.gitattributes` bestand ook gecommit wordt en meegestuurd wordt met het project, maar het filter (in dit geval `dater`) niet; dus het zal niet overal werken. Als je deze filters ontwerpt, zouden ze in staat moeten zijn om netjes te falen en het project nog steeds goed te laten werken.

### Je Repository Exporteren ###

De Git attribute gegevens staan je ook toe om interessante dingen te doen als je een archief van je project exporteerd.

#### export-ignore ####

Je kunt Git vertellen dat sommige bestanden of mappen niet geëxporteerd moeten worden als een archief gegenereerd wordt. Als er een submap of bestand is waarvan je niet wil dat het wordt meegenomen in je archief bestand, maar dat je wel in je project ingechecked wil hebben, dan kun je die bestanden bepalen met behulp van het `export-ignore` attribuut.

Bijvoorbeeld, stel dat je wat testbestanden in een `test/` submap hebt, en dat het geen zin heeft om die in de tarball export van je project mee te nemen. Je kunt dan de volgende regel in je Git attributes bestand toevoegen:

	test/ export-ignore

Als je nu git archive uitvoert om een tarball van je project te maken, zal die map niet meegenomen worden in het archief.

#### export-subst ####

Iets anders dat je kunt doen met je archieven is eenvoudige sleutelwoord vervanging. Git staat je toe om de tekst `$Format:$` in ieder bestand met ieder van de `--pretty=format` formaat afkortingen te zetten, waarvan je er al veel zag in Hoofdstuk 2. Bijvoorbeeld, als je een bestand genaamd `LAST_COMMIT` wilt meenemen in je project, en de laatste commit datum was hierin automatisch geinjecteerd toen `git archive` bezig was, kun je het bestand als volgt instellen:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

Als je `git archive` uitvoert, zal de inhoud van dat bestand als mensen het archief bestand openen er zo uit zien:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Samenvoeg Strategieën ###

Je kunt Git attributen ook gebruiken om Git te vertellen dat het verschillende samenvoeg strategieën moet gebruiken voor specifieke bestanden in je project. Een erg handige optie is Git te vertellen dat het niet moet proberen bepaalde bestanden samen te voegen als ze conflicten hebben, maar jouw versie moeten gebruiken in plaats van andermans versie.

Dit is handig als een branch in je project af is geweken of gespecialiseerd is, maar je in staat wil zijn om veranderingen daarvan terug samen te voegen, en je wilt bepaalde bestanden negeren. Stel dat je een gegevensbank instellingen bestand hebt dat database.xml heet en dat in twee branches verschillend is, en je wilt in je andere branch samenvoegen zonder het gegevensbank bestand te verprutsen. Je kunt dan een attribuut als volgt instellen:

	database.xml merge=ours

Als je in de andere branch samenvoegt, dan zul je in plaats van samenvoeg conflicten met je database.xml bestand zoiets als dit zien:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In dit geval blijft database.xml staan op welke versie je origineel ook had.

## Git Haken ##

Zoals vele andere Versie Beheer Systemen, heeft Git een manier om eigengemaakte scripts op te starten wanneer bepaalde belangrijke akties voorkomen. Er zijn twee groepen van dit soort haken: aan de client kant en aan de server kant. De haken aan de client kant zijn voor client operaties zoasl committen en samenvoegen. De haken voor de server kant zijn voor Git server operaties zoals het ontvangen van gepushte commits. Je kunt deze haken om allerlei redenen gebruiken, en je zult hier over een aantal ervan leren.

### Een Haak Installeren ###

De haken worden allemaal opgeslagen in de `hooks` submap van de Git map. In de meeste projecten is dat `.git/hooks`. Standaard voorziet Git deze map van een aantal voorbeeld scripts, waarvan de meeste al bruikbaar zijn; maar ze documenteren ook de invoer waarden van ieder script. Alle scripts zijn als shell script geschreven, met hier en daar wat Perl, maar iedere executable met de juiste naam zal prima werken – je kunt ze in Ruby of Python of wat je wil schrijven. Voor Git versies later dan 1.6, eindigen deze haak bestanden met .sample; je zult ze van naam moeten veranderen. Voor eerdere versies van Git, zijn de scripts al van de juiste naam voorzien, maar je moet ze nog uitvoerbaar maken.

Om een haak script aan te zetten, stop je een bestand met de juiste naam en dat uitvoerbaar is in de `hooks` map van je Git map. Vanaf dat punt zou het aangeroepen moeten worden. Ik zal de meestgebruikte haak bestandsnamen hier behandelen.

### Client-Kan Haken ###

Er zijn veel client-kant haken. Deze sectie verdeeld ze in commit-werwijze haken, e-mail-werkwijze scripts, en de rest van de client-kant scripts

#### Commit-Werkwijze Haken ####

De eerste vier haken hebben te maken met het commit proces. De `pre-commit` haak wordt eerst uitgevoerd, nog voor je een commit boodschap intyped. Het wordt gebruikt om het snapshot dat op het punt staat gecommit te worden te inspecteren, om te zien of je iets bent vergeten, om er zeker van te zijn dat tests uitgevoerd worden, of om te onderzoeken wat je wilt in de code. Deze haak met een waarde anders dan nul afsluiten breekt de commit af, alhoewel je 'm kunt omzeilen met `git commit --no-verify`. Je kunt dingen doen als op code stijl controleren (voer lint of iets dergelijks uit), op aanhangende spaties controleren (de standaard haak doet dat), of om de juiste documentatie op nieuwe functies te controleren.

De `prepare-commit-msg` haak wordt uitgevoerd voordat de commit boodschap editor gestart wordt, maar nadat de standaard boodschap aangemaakt is. Het stelt je in staat om de standaard boodschap aan te passen voordat de commit auteur het ziet. Deze haak accepteerd een aantal opties: het pad naar het bestand dat de huidige commit boodschap bevat, het type van de commit, en de SHA-1 van de commit als het een verbeterde commit betreft. Deze haak is voor normale commits niet zo bruikbaar; maar, het is goed voor commits waarbij de standaard boodschap automatisch gegenereerd wordt, zoals sjabloon commit boodschappen, samenvoeg commits, gesquashte commits en verbeterde commits. Je mag het samen met een commit sjabloon gebruiken om informatie in te voegen.

De `commit-msg` hook accepteerd één parameter, wat weer het pad naar een tijdelijk bestand is dat de huidige commit boodschap bevat. Als dit script eindigt met een waarde anders dan nul, dan zal Git het commit proces afbreken, dus je kunt het gebruiken om je project-status of de commit boodschap te valideren alvorens een commit toe te staan. In het laatste gedeelte van dit hoofdstuk, zal ik deze haak demonstreren om te controleren of je commit boodschap aan een bepaald patroon voldoet.

Nadat het hele commit proces afgerond is, zal de `post-commit` haak uitgevoerd worden. Het accepteerd geen parameters, maar je kunt de laatste commit eenvoudig ophalen door `git log -1 HEAD` uit te voeren. Over het algemeen wordt dit script gebruikt om notificaties of iets dergelijks uit te sturen.

De commit-werkwijze client-kant scripts kunnen gebruikt worden in vrijwel iedere werkwijze. Ze worden vaak gebruikt om een bepaald beleid af te dwingen, maar het is belangrijk om te weten dat deze scripts niet overgedragen worden tijdens een clone. Je kunt beleid afdwingen op de server kant om pushes of commits te weigeren, die niet voldoen aan een bepaald beleid, maar het is aan de ontwikkelaar om deze scripts aan de client kant te gebruiken. Dus, deze scripts zijn er om ontwikkelaars te helpen, en ze moeten door hen ingesteld en onderhouden worden, alhoewel ze aangepast of omzeilt kunnen worden op ieder tijdstip.

#### E-mail Werkwijze Haken ####

Je kunt drie client kant haken instellen voor een e-mail gebaseerde werkwijze. Ze worden allemaal aangeroepen door het `git am` commando, dus als je dat commndo niet gebruikt in je werkwijze, dan kun je veilig doorgaan naar de volgende sectie. Als je patches aanneemt via e-mail, die door `git format-patch` geprepareerd zijn, dan zullen sommige van deze behulpzaam zijn voor je.

De eerste haak die uitgevoerd wordt is `applypatch-msg`. Het accepteerd een enkel argument: de naam van het tijdelijke bestand dat de voorgestelde commit boodschap bevat. Git breekt de patch als dit script met een waarde ongelijk aan nul eindigt. Je kunt dit gebruiken om er zeker van te zijn dat een commit boodschap juist geformateerd is, of om de boodschap te normaliseren door het script de boodschap aan te laten passen.

De volgende haak die wordt uitgevoerd tijdens het toepassen van patches via `git am` is `pre-applypatch`. Dit neemt geen argumenten aan en wordt uitgevoerd nadat de patch is toegepast, zodat je het kunt gebruiken om het snapshot te inspecteren alvorens de commit te doen. Je kunt tests uitvoeren of de werkmap op een andere manier inspecteren met behulp van dit script. Als er iets mist of één van de tests faalt, dan zal eindigen met niet nul het `git am` script afbreken zonder de patch te committen.

De laatste haak die uitgevoerd wordt tijdens een `git am` operatie is de `post-applypatch`. Je kunt dat gebruiken om een groep te notificeren of de auteur van de patch die je zojuist gepulled hebt. Je kunt het patch proces niet stoppen met behulp van dit script. 

#### Andere Client Haken ####

De `pre-rebase` haak wordt uitgevoerd voordat je ook maar iets rebased, en kan het proces afbreken door met een waarde anders dan nul te eindigen. Je kunt deze haak gebruiken om tegen te gaan dat commits die al gepushed zijn gerebased worden. De voorbeeld `pre-rebase` haak die Git installeert doet dit, alhoewel deze er vanuit gaat dat next de naam is van de branch die je publiceert. Je zult dat waarschijnlijk moeten veranderen in de naam van je stabiele gepubliceerde branch.

Nadat je een succesvolle `git checkout` uitgevoerd hebt, wordt de `post-checkout` haak uitgevoerd; je kunt het gebruiken om je werkmap goed in te stellen voor je project omgeving. Dit kan het invoegen van grote binaire bestanden die je niet in versie beheer wil hebben betekenen, of het automatisch genereren van documentatie, of iets in die geest.

Als laatste wordt de `post-merge` haak uitgevoerd na een succesvol `merge` commando. Je kunt het gebruiken om gegevens in de boom die Git niet kan volgen terug te zetten, bijvoorbeeld permissie gegevens. Ook kan deze haak gebruikt worden om de aanwezigheid van bestanden buiten de controle van Git te controleren, die je misschien in je boom gekopieerd wil hebben zodra hij veranderd.

### Server-Kant Haken ###

Naast de client-kant haken, kun je als systeem administrator ook een paar belangrijke server-kant haken gebruiken om vrijwel ieder beleid op je project af te dwingen. Deze scripts worden voor en na de pushes op de server uitgevoerd. De pre haken kunnen met een ander getal dan nul eindigeen om de push te weigeren en een foutmelding naar de client te sturen; je kunt een push beleid instellen dat zo complex is als je zelf wenst.

#### pre-receive en post-receive ####

Het eerste script dat uitgevoerd wordt tijdens het afhandelen van een push van een client is `pre-receive`. Het aanvaardt een lijst van referenties die worden gepushed op stdin; als het eindigt met een andere waarde dan nul, worden ze allen geweigerd. Je kunt deze haak gebruiken om dingen te doen als valideren dat geen van de vernieuwde referenties een non-fast-forward is; of om te controleren dat de gebruiker die de push doet ook creatie, verwijder, of push toegang of toegang om vernieuwingen te pushen naar alle bestanden die ze proberen aan te passen met de push.

De `post-receive` haak wordt uitgevoerd nadat het hele proces afgerond is, en hij kan gebruikt worden om andere services te vernieuwen of gebruikers te notificeren. Het aanvaardt dezelfde gegevens op stdin als de `pre-receive` haak. Voorbeelden zijn een e-mail sturen naar een lijst, een continue integratie server notificeren, of het vernieuwen van een ticket-volg systeem – je kunt zelfs de commit boodschappen doorlopen om te zien of er nog tickets zijn die moeten worden geopend, aangepast of afgesloten moeten worden. Dit script kan het push proces niet stopppen, maar de client verbreekt de connectie niet totdat het afgerond is; dus ben voorzichtig als je iets probeert te doen dat een lange tijd in beslag neemt.

#### update ####

Het update script is vergelijkbaar met het `pre-receive` script, behalve dan dat het uitgevoerd wordt voor iedere branch die de pusher probeert te vernieuwen. Als de pusher naar meerdere branches probeert te pushen, wordt `pre-receive` slechts één keer uitgevoerd, maar `update` bij iedere branch waar ze naar pushen. In plaats van stdin te lezen, aanvaardt dit script drie argumenten: de naam van de referentie (branch), de SHA-1 waar die referentie naar wees voor de push, en de SHA-1 die de gebruiker probeert te pushen. Als het update script met een andere waarde dan nul eindigt, wordt alleen die referentie geweigerd; andere referenties kunnen nog steeds vernieuwd worden.

## Een Voorbeeld van Git-Afgedwonen Beleid ##

In dit gedeelte zul je gebruiken wat je geleerd hebt om een Git werkwijze vast te leggen, die controleerd op een eigengemaakt commit boodschap formaat, afdwingt om alleen fast-forward pushes te accepteren, en alleen bepaalde gebruikers toestaat om bepaalde submappen te wijzigen in een project. Je zult client scripts maken die de ontwikkelaar helpen er achter te komen of hun push geweigerd zal worden, en server scripts die het beleid afdwingen.

Ik heb Ruby gebruikt om ze te schrijven, zowel omdat het mijn voorkeur script taal is en omdat ik vind dat het de meest pseudo code uitziende taal is van de scripttalen; dus je zou in staat moeten zijn om de code redelijk te kunnen volgen zelfs als je geen Ruby gebruikt. Maar, iedere taal zal prima werken. Alle voorbeeld haak scripts die met Git meegeleverd worden zijn Perl of Bash scripts, dus je kunt ook genoeg voorbeelden van haken in die talen zijn door naar de voorbeelden te kijken.

### Server-Side Hook ###

All the server-side work will go into the update file in your hooks directory. The update file runs once per branch being pushed and takes the reference being pushed to, the old revision where that branch was, and the new revision being pushed. You also have access to the user doing the pushing if the push is being run over SSH. If you’ve allowed everyone to connect with a single user (like "git") via public-key authentication, you may have to give that user a shell wrapper that determines which user is connecting based on the public key, and set an environment variable specifying that user. Here I assume the connecting user is in the `$USER` environment variable, so your update script begins by gathering all the information you need:

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Yes, I’m using global variables. Don’t judge me — it’s easier to demonstrate in this manner.

#### Enforcing a Specific Commit-Message Format ####

Your first challenge is to enforce that each commit message must adhere to a particular format. Just to have a target, assume that each message has to include a string that looks like "ref: 1234" because you want each commit to link to a work item in your ticketing system. You must look at each commit being pushed up, see if that string is in the commit message, and, if the string is absent from any of the commits, exit non-zero so the push is rejected.

You can get a list of the SHA-1 values of all the commits that are being pushed by taking the `$newrev` and `$oldrev` values and passing them to a Git plumbing command called `git rev-list`. This is basically the `git log` command, but by default it prints out only the SHA-1 values and no other information. So, to get a list of all the commit SHAs introduced between one commit SHA and another, you can run something like this:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

You can take that output, loop through each of those commit SHAs, grab the message for it, and test that message against a regular expression that looks for a pattern.

You have to figure out how to get the commit message from each of these commits to test. To get the raw commit data, you can use another plumbing command called `git cat-file`. I’ll go over all these plumbing commands in detail in Chapter 9; but for now, here’s what that command gives you:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

A simple way to get the commit message from a commit when you have the SHA-1 value is to go to the first blank line and take everything after that. You can do so with the `sed` command on Unix systems:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

You can use that incantation to grab the commit message from each commit that is trying to be pushed and exit if you see anything that doesn’t match. To exit the script and reject the push, exit non-zero. The whole method looks like this:

	$regex = /\[ref: (\d+)\]/

	# enforced custom commit message format
	def check_message_format
	  missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  missed_revs.each do |rev|
	    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
	    if !$regex.match(message)
	      puts "[POLICY] Your message is not formatted correctly"
	      exit 1
	    end
	  end
	end
	check_message_format

Putting that in your `update` script will reject updates that contain commits that have messages that don’t adhere to your rule.

#### Enforcing a User-Based ACL System ####

Suppose you want to add a mechanism that uses an access control list (ACL) that specifies which users are allowed to push changes to which parts of your projects. Some people have full access, and others only have access to push changes to certain subdirectories or specific files. To enforce this, you’ll write those rules to a file named `acl` that lives in your bare Git repository on the server. You’ll have the `update` hook look at those rules, see what files are being introduced for all the commits being pushed, and determine whether the user doing the push has access to update all those files.

The first thing you’ll do is write your ACL. Here you’ll use a format very much like the CVS ACL mechanism: it uses a series of lines, where the first field is `avail` or `unavail`, the next field is a comma-delimited list of the users to which the rule applies, and the last field is the path to which the rule applies (blank meaning open access). All of these fields are delimited by a pipe (`|`) character.

In this case, you have a couple of administrators, some documentation writers with access to the `doc` directory, and one developer who only has access to the `lib` and `tests` directories, and your ACL file looks like this:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

You begin by reading this data into a structure that you can use. In this case, to keep the example simple, you’ll only enforce the `avail` directives. Here is a method that gives you an associative array where the key is the user name and the value is an array of paths to which the user has write access:

	def get_acl_access_data(acl_file)
	  # read in ACL data
	  acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
	  access = {}
	  acl_file.each do |line|
	    avail, users, path = line.split('|')
	    next unless avail == 'avail'
	    users.split(',').each do |user|
	      access[user] ||= []
	      access[user] << path
	    end
	  end
	  access
	end

On the ACL file you looked at earlier, this `get_acl_access_data` method returns a data structure that looks like this:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Now that you have the permissions sorted out, you need to determine what paths the commits being pushed have modified, so you can make sure the user who’s pushing has access to all of them.

You can pretty easily see what files have been modified in a single commit with the `--name-only` option to the `git log` command (mentioned briefly in Chapter 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

If you use the ACL structure returned from the `get_acl_access_data` method and check it against the listed files in each of the commits, you can determine whether the user has access to push all of their commits:

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # see if anyone is trying to push something they can't
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path  # user has access to everything
	          || (path.index(access_path) == 0) # access to this path
	          has_file_access = true 
	        end
	      end
	      if !has_file_access
	        puts "[POLICY] You do not have access to push to #{path}"
	        exit 1
	      end
	    end
	  end  
	end

	check_directory_perms

Most of that should be easy to follow. You get a list of new commits being pushed to your server with `git rev-list`. Then, for each of those, you find which files are modified and make sure the user who’s pushing has access to all the paths being modified. One Rubyism that may not be clear is `path.index(access_path) == 0`, which is true if path begins with `access_path` — this ensures that `access_path` is not just in one of the allowed paths, but an allowed path begins with each accessed path. 

Now your users can’t push any commits with badly formed messages or with modified files outside of their designated paths.

#### Enforcing Fast-Forward-Only Pushes ####

The only thing left is to enforce fast-forward-only pushes. In Git versions 1.6 or newer, you can set the `receive.denyDeletes` and `receive.denyNonFastForwards` settings. But enforcing this with a hook will work in older versions of Git, and you can modify it to do so only for certain users or whatever else you come up with later.

The logic for checking this is to see if any commits are reachable from the older revision that aren’t reachable from the newer one. If there are none, then it was a fast-forward push; otherwise, you deny it:

	# enforces fast-forward only pushes 
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

Everything is set up. If you run `chmod u+x .git/hooks/update`, which is the file you into which you should have put all this code, and then try to push a non-fast-forwarded reference, you get something like this:

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies... 
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non-fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

There are a couple of interesting things here. First, you see this where the hook starts running.

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Notice that you printed that out to stdout at the very beginning of your update script. It’s important to note that anything your script prints to stdout will be transferred to the client.

The next thing you’ll notice is the error message.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

The first line was printed out by you, the other two were Git telling you that the update script exited non-zero and that is what is declining your push. Lastly, you have this:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

You’ll see a remote rejected message for each reference that your hook declined, and it tells you that it was declined specifically because of a hook failure.

Furthermore, if the ref marker isn’t there in any of your commits, you’ll see the error message you’re printing out for that.

	[POLICY] Your message is not formatted correctly

Or if someone tries to edit a file they don’t have access to and push a commit containing it, they will see something similar. For instance, if a documentation author tries to push a commit modifying something in the `lib` directory, they see

	[POLICY] You do not have access to push to lib/test.rb

That’s all. From now on, as long as that `update` script is there and executable, your repository will never be rewound and will never have a commit message without your pattern in it, and your users will be sandboxed.

### Client-Side Hooks ###

The downside to this approach is the whining that will inevitably result when your users’ commit pushes are rejected. Having their carefully crafted work rejected at the last minute can be extremely frustrating and confusing; and furthermore, they will have to edit their history to correct it, which isn’t always for the faint of heart.

The answer to this dilemma is to provide some client-side hooks that users can use to notify them when they’re doing something that the server is likely to reject. That way, they can correct any problems before committing and before those issues become more difficult to fix. Because hooks aren’t transferred with a clone of a project, you must distribute these scripts some other way and then have your users copy them to their `.git/hooks` directory and make them executable. You can distribute these hooks within the project or in a separate project, but there is no way to set them up automatically.

To begin, you should check your commit message just before each commit is recorded, so you know the server won’t reject your changes due to badly formatted commit messages. To do this, you can add the `commit-msg` hook. If you have it read the message from the file passed as the first argument and compare that to the pattern, you can force Git to abort the commit if there is no match:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

If that script is in place (in `.git/hooks/commit-msg`) and executable, and you commit with a message that isn’t properly formatted, you see this:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

No commit was completed in that instance. However, if your message contains the proper pattern, Git allows you to commit:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Next, you want to make sure you aren’t modifying files that are outside your ACL scope. If your project’s `.git` directory contains a copy of the ACL file you used previously, then the following `pre-commit` script will enforce those constraints for you:

	#!/usr/bin/env ruby

	$user    = ENV['USER']

	# [ insert acl_access_data method from above ]

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('.git/acl')

	  files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
	  files_modified.each do |path|
	    next if path.size == 0
	    has_file_access = false
	    access[$user].each do |access_path|
	    if !access_path || (path.index(access_path) == 0)
	      has_file_access = true
	    end
	    if !has_file_access
	      puts "[POLICY] You do not have access to push to #{path}"
	      exit 1
	    end
	  end
	end

	check_directory_perms

This is roughly the same script as the server-side part, but with two important differences. First, the ACL file is in a different place, because this script runs from your working directory, not from your Git directory. You have to change the path to the ACL file from this

	access = get_acl_access_data('acl')

to this:

	access = get_acl_access_data('.git/acl')

The other important difference is the way you get a listing of the files that have been changed. Because the server-side method looks at the log of commits, and, at this point, the commit hasn’t been recorded yet, you must get your file listing from the staging area instead. Instead of

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

you have to use

	files_modified = `git diff-index --cached --name-only HEAD`

But those are the only two differences — otherwise, the script works the same way. One caveat is that it expects you to be running locally as the same user you push as to the remote machine. If that is different, you must set the `$user` variable manually.

The last thing you have to do is check that you’re not trying to push non-fast-forwarded references, but that is a bit less common. To get a reference that isn’t a fast-forward, you either have to rebase past a commit you’ve already pushed up or try pushing a different local branch up to the same remote branch.

Because the server will tell you that you can’t push a non-fast-forward anyway, and the hook prevents forced pushes, the only accidental thing you can try to catch is rebasing commits that have already been pushed.

Here is an example pre-rebase script that checks for that. It gets a list of all the commits you’re about to rewrite and checks whether they exist in any of your remote references. If it sees one that is reachable from one of your remote references, it aborts the rebase:

	#!/usr/bin/env ruby

	base_branch = ARGV[0]
	if ARGV[1]
	  topic_branch = ARGV[1]
	else
	  topic_branch = "HEAD"
	end

	target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
	remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

	target_shas.each do |sha|
	  remote_refs.each do |remote_ref|
	    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
	    if shas_pushed.split(“\n”).include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

This script uses a syntax that wasn’t covered in the Revision Selection section of Chapter 6. You get a list of commits that have already been pushed up by running this:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

The `SHA^@` syntax resolves to all the parents of that commit. You’re looking for any commit that is reachable from the last commit on the remote and that isn’t reachable from any parent of any of the SHAs you’re trying to push up — meaning it’s a fast-forward.

The main drawback to this approach is that it can be very slow and is often unnecessary — if you don’t try to force the push with `-f`, the server will warn you and not accept the push. However, it’s an interesting exercise and can in theory help you avoid a rebase that you might later have to go back and fix.

## Summary ##

You’ve covered most of the major ways that you can customize your Git client and server to best fit your workflow and projects. You’ve learned about all sorts of configuration settings, file-based attributes, and event hooks, and you’ve built an example policy-enforcing server. You should now be able to make Git fit nearly any workflow you can dream up.
