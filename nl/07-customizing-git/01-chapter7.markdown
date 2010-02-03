# Git op Maat Maken #

Tot zover heb ik de fundamentele werking van Git behandeld, en hoe het te gebruiken, en ik heb een aantal tools geïntroduceerd die Git levert om je het makkelijk en efficiënt te laten gebruiken. In dit hoofdstuk zal ik wat operaties doorlopen die je kunt gebruiken om Git op een persoonlijker manier te laten werken door een aantal belangrijke configuratieinstellingen te introduceren en het hakensysteem. Met deze gereedschappen is het makkelijk om Git precies te laten werken op de manier zoals jij, je bedrijf, of je groep het graag wil.

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

## Een Voorbeeld van Git-Afgedwongen Beleid ##

In dit gedeelte zul je gebruiken wat je geleerd hebt om een Git werkwijze vast te leggen, die controleerd op een eigengemaakt commit boodschap formaat, afdwingt om alleen fast-forward pushes te accepteren, en alleen bepaalde gebruikers toestaat om bepaalde submappen te wijzigen in een project. Je zult client scripts maken die de ontwikkelaar helpen er achter te komen of hun push geweigerd zal worden, en server scripts die het beleid afdwingen.

Ik heb Ruby gebruikt om ze te schrijven, zowel omdat het mijn voorkeur script taal is en omdat ik vind dat het de meest pseudo code uitziende taal is van de scripttalen; dus je zou in staat moeten zijn om de code redelijk te kunnen volgen zelfs als je geen Ruby gebruikt. Maar, iedere taal zal prima werken. Alle voorbeeld haak scripts die met Git meegeleverd worden zijn Perl of Bash scripts, dus je kunt ook genoeg voorbeelden van haken in die talen zijn door naar de voorbeelden te kijken.

### Server-Kant Haak ###

Al het werk aan de server kant zal in het update bestand in je haken map gaa. Het update bestand zal eens per gepushte branch uitgevoerd worden en aanvaardt de referentie waarnaar gepushed wordt, de oude revisie waar die branch was, en de nieuwe gepushte revisie. Je hebt ook toegang tot de gebruiker die de push doet, als de push via SSH gedaan wordt. Als je iedereen hebt toegestaan om connectie te maken als één gebruiker (zoals "git") via publieke sleutel authenticatie, dan moet je misschien die gebruiker een shell wrapper geven die bepaalt welke gebruiker er connectie maakt op basis van de publieke sleutel, en een omgevingsvariabele instelt met daarin die gebruiker. Hier ga ik er vanuit dat de gebruiker in de `$USER` omgevingsvariabele staat, dus begint je update script met het verzamelen van alle gegevens die het nodig heeft:

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Ja, ik gebruik een globale variabele. Veroordeel me niet – het is makkelijker om het op deze manier te laten zien.

#### Een Specifiec Commit-Bericht Formaat Afdwingen ####

Je eerste uitdaging is afdwingen dat ieder commit bericht moet voldoen aan een specifiek formaat. Om maar een doel te hebben, gaan we er vanuit dat ieder bericht een stuk tekst bevat dat eruit ziet asl "ref: 1234", omdat je wil dat iedere commit gekoppeld is aan een werkonderdeel in je ticket systeem. Je moet kijken naar iedere commit die gepushed wordt, zien dat die tekst in de commit boodschap zit, en als de tekst niet in één van de commits zit, met niet nul eindigen zodat de push geweigerd wordt.

Je kunt de lijst met alle SHA-1 waarden van alle commits die gepushed worden verkrijgen door de `$newrev` en `$oldrev` waarden te pakken en ze aan een Git sanitaire voorzieningen commando genaamd `git rev-list` te geven. Dit is eigenlijk het `git log` commando, maar standaard voert het alleen de SHA-1 waarden uit en geen andere informatie. Dus, om een lijst te krijgen van alle commit SHA's die worden geintroduceerd tussen één commit SHA en een andere, kun je zoiets als dit uitvoeren:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Je kunt die uitvoer pakken, door ieder van die commit SHA's heen lopen, de boodschap daarvan pakken, en die boodschap testen tegen een reguliere expressie die op een bepaald patroon zoekt.

Je moet uit zien te vinden hoe je de commit boodschap kunt krijgen van alle te testen commits. Om de rauwe commit gegevens te krijgen, kun je een andere sanitaire voorzieningen commando genaamd `git cat-file` gebruiken. Ik zal al deze sanitaire voorzieningen commando's behandelen in detail in Hoofdstuk 9; maar voor nu is dit wat het commando je geeft:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Een simpele manier om de commit boodschap te krijgen van een commit waarvan je de SHA-1 waarde hebt, is naar de eerste lege regel gaan en alles wat daarna komt pakken. Je kunt dat doen met het `sed` commando op Unix systemen:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

Je kunt die spreuk gebruiken om de commit boodschap te pakken van iedere commit die probeert te worden gepushed en eindigen als je ziet dat er iets is wat niet past. Om het script te eindigen en de push te weigeren, eindig je met niet nul. De hele methode ziet er zo uit:

	$regex = /\[ref: (\d+)\]/

	# afgedwongen eigen commit bericht formaat
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

Door dat in je `update` script te stoppen, zal het updates weigeren die commits bevatten die berichten hebben die niet aan je regel voldoen.

#### Een Gebruiker-Gebaseerd ACL Systeem Afdwingen ####

Stel dat je een mechanisme wil toevoegen dat gebruik maakt van een toegangs controle lijst (ACL) die specificeert welke gebruikers zijn toegestaan om wijzigingen te pushen naar welke delen van je project. Sommige mensen hebben volledige toegang, en andere hebben alleen toegang om wijzigingen te pushen naar bepaalde submappen of specifieke bestanden. Om dit af te dwingen zule je die regels schrijven in een bestand genaamd `acl` dat in je bare Git repository op de server leeft. Je zult de `update` haak naar die regels laten kijken, zien welke bestanden worden geintroduceerd voor alle commits die gepushed worden, en bepalen of de gebruiker die de push doet toegang heeft om al die bestanden te wijzigen.

Het eerste dat je zult doen is je ACL schrijven. Hier zul je een formaat gebruiken dat erg lijkt op het CVS ACL mechanisme: het gebruikt een serie regels, waarbij het eerste veld `avail` of `unavail` is, het volgende veld een komma gescheiden lijst van de gebruikers is waarvoor de regel geldt, en het laatste veld het pad is waarvoor de regel geldt (leeg betekent open toegang). Alle velden worden gescheiden door een pipe (`|`) karakter.

In dit geval heb je een aantal administrators, een aantal documentatie schrijvers met toegang tot de `doc` map, en één ontwikkelaar die alleen toegang heeft tot de `lib` en `test` mappen, en je ACL bestand ziet er zo uit:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

Je begint met het lezen van deze gegevens in een structuur die je kunt gebruiken. In dit geval, om het voorbeeld eenvoudig te houden, zul je alleen de `avail` richtlijnen handhaven. Hier is een methode die je een associatieve array geeft, waarbij de sleutel de gebruikersnaam is en de waarde een array van paden waar die gebruiker toegang tot heeft:

	def get_acl_access_data(acl_file)
	  # lees ACL gegevens
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

Op het ACL bestand dat je eerder bekeken hebt, zal deze `get_acl_access_data` methode een gegevens structuur teruggeven die er zo uit ziet:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Nu dat je de rechten bepaald hebt, moet je bepalen welke paden de commits die gepushed worden hebben aangepast, zodat je er zeker van kunt zijn dat de gebruiker die de push doet daar ook toegang tot heeft.

Je kunt eenvoudig zien welke bestanden gewijzigd zijn in een enkele commit met de `--name-only` optie op het `git log` commando (dat kort genoemd wordt in Hoofdstuk 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

Als je gebruik maakt van de ACL struktuur die wordt teruggegeven door de `get_acl_access_data` methode en dat controleerd met de bestanden in elk van de commits, dan kun je bepalen of de gebruiker toegang heeft om al hun commits te pushen:

	# staat alleen bepaalde gebruikers toe om bepaalde submappen in een project te wijzigen
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # zie of iemand iets probeert te pushen dat ze niet mogen
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path  # gebruiker heeft overal toegang tot
	          || (path.index(access_path) == 0) # toegang tot dit pad
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

Het meeste daarvan zou makkelijk te volgen moeten zijn. Je krijgt een lijst met commits die gepushed worden naar je server met `git rev-list`. Daarna vind je, voor iedere commit, de bestanden die aangepast worden en stelt vast of de gebruiker die pushed toegang heeft tot alle paden die worden aangepast. Een Ruby-isme dat wellicht niet duidelijk is is `path.index(access_path) == 0`, wat waar is als het pad begint met `access_path` – dit zorgt ervoor dat `access_path` niet slechts in één van de toegestane paden zit, maar dat een toegestaan pad begint met ieder aangeraakt pad.

Nu kunnen je gebruikers geen commits pushen met slechte berichten of met aangepaste bestanden buiten hun toegewezen paden.

#### Fast-Forward-Only Pushes Afdwingen ####

Het enige overgebleven ding om af te dwingen is fast-forward-only pushes. In Git versie 1.6 of nieuwer, kun je de `receive.denyDeletes` en `receive.denyNonFastForwards` instellingen aanpassen. Maar dit afdwingen met behulp van een haak werkt ook in oudere versies van Git, en je kunt het aanpasen zodat het alleen gebeurd bij bepaalde gebruikers of wat je later ook verzint.

De logica om dit te controleren is zien of iedere commit die bereikbaar is vanuit de oudere revisie, niet bereikbaar is vanuit de nieuwere. Als er geen zijn, dan was het een fast-forward push; anders weiger je het:

	# dwingt fast-forward only pushes af
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

Alles is ingesteld. Als je `chmod u+x .git/hooks/update` uitvoert, wat het bestand is waarin je al deze code gestopt hebt, en dan probeert te pushen naar een non-fast-forwarded referentie, krijg je zoiets als dit:


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

Er zijn hier een aantal interessante dingen. Ten eerste, zie je dit als de haak start met uitvoeren.

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Zie dat je dat afgedrukt hebt naar stdout aan het begin van je update script. Het is belangrijk om te zien dat alles dat je script naar stdout uitvoert, naar de client overgebracht wordt.

Het volgende dat je op zal vallen is de foutmelding.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

De eerste regel was door jou afgedrukt, de andere twee waren Git die je vertelde dat het update script met niet nul eindigde en dat dat hetgeen is dat je push weigerde. Als laatste heb je dit:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Je zult een remote weiger bericht zien voor iedere referentie die je haak weigerde, en het verteld je dat het specifiek was geweigerd omdat het een haak fout was.

Daarnaast zul je een foutmelding zien dat je uitvoert als de ref marker niet in één van je commits zit.

	[POLICY] Your message is not formatted correctly

Of als iemand een bestand probeert aan te passen waar ze geen toegang tot hebben en een commit probeert te pushen waar het in zit, dan zullen ze iets vergelijkbaars zien. Bijvoorbeeld, als een documentatie schrijver een commit probeert te pushen dat iets wijzigt dat in de `lib` map zit, dan zien ze


	[POLICY] You do not have access to push to lib/test.rb

Dat is alles. Vanaf nu, zolang als het `update` script aanwezig en uitvoerbaar is, zal je repository nooit teruggedraaid worden en zal nooit een commit bericht zonder je patroon erin bevatten, en je gebruikers zullen ingeperkt zijn.

### Client-Kant Haken ###

Het nadeel hiervan is het zeuren dat geheid zal gebeuren zodra de commits van je gebruikers geweigerd worden. Het feit dat hun zorgzaam vervaardigde werk geweigerd wordt op het laatste moment kan enorm frustrerend en verwarrend zijn: daarnaast, zullen ze hun geschiedenis moeten aanpassen om het te corrigeren, wat niet altijd voor de mensen met een zwak hart is.

Het antwoord op dit dilemma is een aantal client-kant haken te leveren, die gebruikers kunnen toepassen om hen te waarschuwen dat ze iets doen dat de server waarschijnlijk gaat weigeren. Op die manier kunnen ze alle problemen corrigeren voordat ze gaan committen en voordat die problemen moeilijk te herstellen zijn. Omdat haken niet overgebracht worden bij een clone van een project, moet je deze scripts op een andere manier distribueren en je gebruikers ze dan in hun `.git/hooks` map laten zetten en ze uitvoerbaar maken. Je kunt deze haken in je project of in een apart project distribueren, maar er is geen manier om ze automatisch in te laten stellen.

Om te beginnen zou je je commit boodschap moeten controleren, vlak voordat iedere commit opgeslagen wordt, zodat je weet dat de server je wijzigingen niet gaat weigeren omdat de commit boodschap een verkeerd formaat heeft. Om dit te doen, kun je de `commit-msg` haak toevoegen. Als je dat de commit boodschap laat lezen uit het bestand dat als eerste argument opgegeven wordt, en dat vergelijkt met het patroon, dan kun je Git forceren om de commit af te breken als er geen overeenkomst is:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

Als dat script op z'n plaats staat (in `.git/hooks/commit-msg`) en uitvoerbaar is, en je commit met een verkeerd formaat bericht, dan zie je dit:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

In dat geval was er geen commit afgerond. Maar, als je bericht het juiste patroon bevat, dan staat Git je toe te committen:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Vervolgens wil je er zeker van zijn dat je geen bestanden buiten je ACL scope aanpast. Als de `.git` map van je project een copie van het ACL bestand bevat dat je eerder gebruikte, dan zal het volgende `pre-commit` script die beperkingen op je toepassen:

	#!/usr/bin/env ruby

	$user    = ENV['USER']

	# [ insert acl_access_data method from above ]

	# staat alleen bepaalde gebruikers toe bepaalde mappen aan te passen
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

Dit is ongeveer hetzelfde script als aan de server kant, maar met twee belangrijke verschillen. Als eerste staat het ACL bestand op een andere plek, omdat dit script vanuit je werkmap draait, niet vanuit je Git map. Je moet het pad naar het ACL bestand wijzigen van dit

	access = get_acl_access_data('acl')

in dit:

	access = get_acl_access_data('.git/acl')

Het andere belangrijke verschil is de manier waarop je een lijst krijgt met bestanden die je gewijzigd hebt. Omdat de server kant methode naar de log van commits kijkt, en op dit punt je commit nog niet opgeslagen is, moet je je bestandslijst in plaats daarvan uit het stage gebied halen. In plaats van

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

moet je dit gebruiken

	files_modified = `git diff-index --cached --name-only HEAD`

Maar dat zijn de enige twee verschillen – voor de rest werkt het scipt op dezelde manier. Een instinker is dat het van je verwacht dat je lokaal werkt als dezelfde gebruiker die pushed naar de remote machine. Als dat verschillend is, moet je de `$user` variabele handmatig instellen.

Het laatste ding dat je moet doen is controleren dat je niet non-fast-forward referenties probeert te pushen, maar dat komt minder voor. Om een referentie te krijgen dat geen fast-forward is, moet je voorbij een commit rebasen die je al gepushed hebt, of een andere lokale branch naar dezelfde remote branch proberen te pushen.

Omdat de server je zal vertellen dat je geen non-fast-forward push kunt doen, en de haak de push tegenhoudt, is het enige ongelukkige ding dat je kunt proberen te vangen het rebasen van commits die je al gepushed hebt.


Hier is een voorbeeld pre-rebase script dat daarop controleert. Het haalt een lijst met alle commits die je op het punt staat te herschrijven, en controleert of ze al op een bepaalde manier bestaan in één van je remote referenties. Als het er een ziet die bereikbaar is vanuit een van je remote referenties, dan stopt het de rebase:

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

Dit script gebruikt een syntax dat niet behandeld is in de Revisie Selectie sectie van Hoofdstuk 6. Je krijgt een lijst van commits die al gepushed zijn door dit uit te voeren:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

De `SHA^@` syntax wordt vervangen door alle ouders van die commit. Je bent aan het kijken naar iedere commit die bereikbaar is vanuit de laatste commit op de remote en die niet bereikbaar is vanuit elke ouder van de SHA's die je probeert te pushen – wat betekend dat het een fast-forward is.

Het grote nadeel van deze aanpak is dat het erg traag kan zijn en vaak onnodig is – als je de push niet probeert te forceren met de `-f` optie, dan zal de server je proberen te waarschuwen en de push niet accepteren. Maar, het is een aardige oefening en kan je in theorie helpen om een rebase te omzeilen die je later zult moeten herstellen.

## Samenvatting ##

Je hebt nu de meeste manieren behandeld waarin je je Git client en server aan kunt passen om aan jouw werkwijze en projecten te voldoen. Je hebt over alle soorten configuratie instellingen geleerd, bestands-gebaseerde attributen, en gebeurtenis haken, en je hebt een voorbeeld server met een afgedwongen beleid gebouwd. Je zou nu in staat moeten zijn om Git bijna iedere werkwijze die je kunt verzinnen te laten doen.
