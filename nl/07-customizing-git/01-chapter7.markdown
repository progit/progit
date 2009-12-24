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

Door attributes te gebruiken kun je dingen doen als het specificeren van aparte samenvoeg strategiëen voor individuele bestanden of mappen in je project, Git vertellen hoe hij niet-tekst bestanden kan diff'en, of Git inhoud laten filteren voordat je het in- of uitchecked van Git. In deze sectie zul je iets leren over de attributen die je kun instellen op de paden in je Git project en een paar voorbeelden zien hoe je deze eigenschap in de praktijk gebruikt.

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

This tells Git that any file that matches this pattern (.doc) should use the "word" filter when you try to view a diff that contains changes. What is the "word" filter? You have to set it up. Here you’ll configure Git to use the `strings` program to convert Word documents into readable text files, which it will then diff properly:

	$ git config diff.word.textconv strings

Now Git knows that if it tries to do a diff between two snapshots, and any of the files end in `.doc`, it should run those files through the "word" filter, which is defined as the `strings` program. This effectively makes nice text-based versions of your Word files before attempting to diff them.

Here’s an example. I put Chapter 1 of this book into Git, added some text to a paragraph, and saved the document. Then, I ran `git diff` to see what changed:

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

Git successfully and succinctly tells me that I added the string "Let’s see if this works", which is correct. It’s not perfect — it adds a bunch of random stuff at the end — but it certainly works. If you can find or write a Word-to-plain-text converter that works well enough, that solution will likely be incredibly effective. However, `strings` is available on most Mac and Linux systems, so it may be a good first try to do this with many binary formats.

Another interesting problem you can solve this way involves diffing image files. One way to do this is to run JPEG files through a filter that extracts their EXIF information — metadata that is recorded with most image formats. If you download and install the `exiftool` program, you can use it to convert your images into text about the metadata, so at least the diff will show you a textual representation of any changes that happened:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

If you replace an image in your project and run `git diff`, you see something like this:

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

You can easily see that the file size and image dimensions have both changed.

### Keyword Expansion ###

SVN- or CVS-style keyword expansion is often requested by developers used to those systems. The main problem with this in Git is that you can’t modify a file with information about the commit after you’ve committed, because Git checksums the file first. However, you can inject text into a file when it’s checked out and remove it again before it’s added to a commit. Git attributes offers you two ways to do this.

First, you can inject the SHA-1 checksum of a blob into an `$Id$` field in the file automatically. If you set this attribute on a file or set of files, then the next time you check out that branch, Git will replace that field with the SHA-1 of the blob. It’s important to notice that it isn’t the SHA of the commit, but of the blob itself:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

The next time you check out this file, Git injects the SHA of the blob:

	$ rm text.txt
	$ git checkout -- text.txt
	$ cat test.txt 
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

However, that result is of limited use. If you’ve used keyword substitution in CVS or Subversion, you can include a datestamp — the SHA isn’t all that helpful, because it’s fairly random and you can’t tell if one SHA is older or newer than another.

It turns out that you can write your own filters for doing substitutions in files on commit/checkout. These are the "clean" and "smudge" filters. In the `.gitattributes` file, you can set a filter for particular paths and then set up scripts that will process files just before they’re committed ("clean", see Figure 7-2) and just before they’re checked out ("smudge", see Figure 7-3). These filters can be set to do all sorts of fun things.

Insert 18333fig0702.png 
Figure 7-2. The “smudge” filter is run on checkout.

Insert 18333fig0703.png 
Figure 7-3. The “clean” filter is run when files are staged.

The original commit message for this functionality gives a simple example of running all your C source code through the `indent` program before committing. You can set it up by setting the filter attribute in your `.gitattributes` file to filter `*.c` files with the "indent" filter:

	*.c     filter=indent

Then, tell Git what the "indent"" filter does on smudge and clean:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

In this case, when you commit files that match `*.c`, Git will run them through the indent program before it commits them and then run them through the `cat` program before it checks them back out onto disk. The `cat` program is basically a no-op: it spits out the same data that it gets in. This combination effectively filters all C source code files through `indent` before committing.

Another interesting example gets `$Date$` keyword expansion, RCS style. To do this properly, you need a small script that takes a filename, figures out the last commit date for this project, and inserts the date into the file. Here is a small Ruby script that does that:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

All the script does is get the latest commit date from the `git log` command, stick that into any `$Date$` strings it sees in stdin, and print the results — it should be simple to do in whatever language you’re most comfortable in. You can name this file `expand_date` and put it in your path. Now, you need to set up a filter in Git (call it `dater`) and tell it to use your `expand_date` filter to smudge the files on checkout. You’ll use a Perl expression to clean that up on commit:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

This Perl snippet strips out anything it sees in a `$Date$` string, to get back to where you started. Now that your filter is ready, you can test it by setting up a file with your `$Date$` keyword and then setting up a Git attribute for that file that engages the new filter:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

If you commit those changes and check out the file again, you see the keyword properly substituted:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

You can see how powerful this technique can be for customized applications. You have to be careful, though, because the `.gitattributes` file is committed and passed around with the project but the driver (in this case, `dater`) isn’t; so, it won’t work everywhere. When you design these filters, they should be able to fail gracefully and have the project still work properly.

### Exporting Your Repository ###

Git attribute data also allows you to do some interesting things when exporting an archive of your project.

#### export-ignore ####

You can tell Git not to export certain files or directories when generating an archive. If there is a subdirectory or file that you don’t want to include in your archive file but that you do want checked into your project, you can determine those files via the `export-ignore` attribute.

For example, say you have some test files in a `test/` subdirectory, and it doesn’t make sense to include them in the tarball export of your project. You can add the following line to your Git attributes file:

	test/ export-ignore

Now, when you run git archive to create a tarball of your project, that directory won’t be included in the archive.

#### export-subst ####

Another thing you can do for your archives is some simple keyword substitution. Git lets you put the string `$Format:$` in any file with any of the `--pretty=format` formatting shortcodes, many of which you saw in Chapter 2. For instance, if you want to include a file named `LAST_COMMIT` in your project, and the last commit date was automatically injected into it when `git archive` ran, you can set up the file like this:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

When you run `git archive`, the contents of that file when people open the archive file will look like this:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge Strategies ###

You can also use Git attributes to tell Git to use different merge strategies for specific files in your project. One very useful option is to tell Git to not try to merge specific files when they have conflicts, but rather to use your side of the merge over someone else’s.

This is helpful if a branch in your project has diverged or is specialized, but you want to be able to merge changes back in from it, and you want to ignore certain files. Say you have a database settings file called database.xml that is different in two branches, and you want to merge in your other branch without messing up the database file. You can set up an attribute like this:

	database.xml merge=ours

If you merge in the other branch, instead of having merge conflicts with the database.xml file, you see something like this:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In this case, database.xml stays at whatever version you originally had.

## Git Hooks ##

Like many other Version Control Systems, Git has a way to fire off custom scripts when certain important actions occur. There are two groups of these hooks: client side and server side. The client-side hooks are for client operations such as committing and merging. The server-side hooks are for Git server operations such as receiving pushed commits. You can use these hooks for all sorts of reasons, and you’ll learn about a few of them here.

### Installing a Hook ###

The hooks are all stored in the `hooks` subdirectory of the Git directory. In most projects, that’s `.git/hooks`. By default, Git populates this directory with a bunch of example scripts, many of which are useful by themselves; but they also document the input values of each script. All the examples are written as shell scripts, with some Perl thrown in, but any properly named executable scripts will work fine — you can write them in Ruby or Python or what have you. For post-1.6 versions of Git, these example hook files end with .sample; you’ll need to rename them. For pre-1.6 versions of Git, the example files are named properly but are not executable.

To enable a hook script, put a file in the `hooks` subdirectory of your Git directory that is named appropriately and is executable. From that point forward, it should be called. I’ll cover most of the major hook filenames here.

### Client-Side Hooks ###

There are a lot of client-side hooks. This section splits them into committing-workflow hooks, e-mail–workflow scripts, and the rest of the client-side scripts.

#### Committing-Workflow Hooks ####

The first four hooks have to do with the committing process. The `pre-commit` hook is run first, before you even type in a commit message. It’s used to inspect the snapshot that’s about to be committed, to see if you’ve forgotten something, to make sure tests run, or to examine whatever you need to inspect in the code. Exiting non-zero from this hook aborts the commit, although you can bypass it with `git commit --no-verify`. You can do things like check for code style (run lint or something equivalent), check for trailing whitespace (the default hook does exactly that), or check for appropriate documentation on new methods.

The `prepare-commit-msg` hook is run before the commit message editor is fired up but after the default message is created. It lets you edit the default message before the commit author sees it. This hook takes a few options: the path to the file that holds the commit message so far, the type of commit, and the commit SHA-1 if this is an amended commit. This hook generally isn’t useful for normal commits; rather, it’s good for commits where the default message is auto-generated, such as templated commit messages, merge commits, squashed commits, and amended commits. You may use it in conjunction with a commit template to programmatically insert information.

The `commit-msg` hook takes one parameter, which again is the path to a temporary file that contains the current commit message. If this script exits non-zero, Git aborts the commit process, so you can use it to validate your project state or commit message before allowing a commit to go through. In the last section of this chapter, I’ll demonstrate using this hook to check that your commit message is conformant to a required pattern.

After the entire commit process is completed, the `post-commit` hook runs. It doesn’t take any parameters, but you can easily get the last commit by running `git log -1 HEAD`. Generally, this script is used for notification or something similar.

The committing-workflow client-side scripts can be used in just about any workflow. They’re often used to enforce certain policies, although it’s important to note that these scripts aren’t transferred during a clone. You can enforce policy on the server side to reject pushes of commits that don’t conform to some policy, but it’s entirely up to the developer to use these scripts on the client side. So, these are scripts to help developers, and they must be set up and maintained by them, although they can be overridden or modified by them at any time.

#### E-mail Workflow Hooks ####

You can set up three client-side hooks for an e-mail–based workflow. They’re all invoked by the `git am` command, so if you aren’t using that command in your workflow, you can safely skip to the next section. If you’re taking patches over e-mail prepared by `git format-patch`, then some of these may be helpful to you.

The first hook that is run is `applypatch-msg`. It takes a single argument: the name of the temporary file that contains the proposed commit message. Git aborts the patch if this script exits non-zero. You can use this to make sure a commit message is properly formatted or to normalize the message by having the script edit it in place.

The next hook to run when applying patches via `git am` is `pre-applypatch`. It takes no arguments and is run after the patch is applied, so you can use it to inspect the snapshot before making the commit. You can run tests or otherwise inspect the working tree with this script. If something is missing or the tests don’t pass, exiting non-zero also aborts the `git am` script without committing the patch.

The last hook to run during a `git am` operation is `post-applypatch`. You can use it to notify a group or the author of the patch you pulled in that you’ve done so. You can’t stop the patching process with this script.

#### Other Client Hooks ####

The `pre-rebase` hook runs before you rebase anything and can halt the process by exiting non-zero. You can use this hook to disallow rebasing any commits that have already been pushed. The example `pre-rebase` hook that Git installs does this, although it assumes that next is the name of the branch you publish. You’ll likely need to change that to whatever your stable, published branch is.

After you run a successful `git checkout`, the `post-checkout` hook runs; you can use it to set up your working directory properly for your project environment. This may mean moving in large binary files that you don’t want source controlled, auto-generating documentation, or something along those lines.

Finally, the `post-merge` hook runs after a successful `merge` command. You can use it to restore data in the working tree that Git can’t track, such as permissions data. This hook can likewise validate the presence of files external to Git control that you may want copied in when the working tree changes.

### Server-Side Hooks ###

In addition to the client-side hooks, you can use a couple of important server-side hooks as a system administrator to enforce nearly any kind of policy for your project. These scripts run before and after pushes to the server. The pre hooks can exit non-zero at any time to reject the push as well as print an error message back to the client; you can set up a push policy that’s as complex as you wish.

#### pre-receive and post-receive ####

The first script to run when handling a push from a client is `pre-receive`. It takes a list of references that are being pushed from stdin; if it exits non-zero, none of them are accepted. You can use this hook to do things like make sure none of the updated references are non-fast-forwards; or to check that the user doing the pushing has create, delete, or push access or access to push updates to all the files they’re modifying with the push.

The `post-receive` hook runs after the entire process is completed and can be used to update other services or notify users. It takes the same stdin data as the `pre-receive` hook. Examples include e-mailing a list, notifying a continuous integration server, or updating a ticket-tracking system — you can even parse the commit messages to see if any tickets need to be opened, modified, or closed. This script can’t stop the push process, but the client doesn’t disconnect until it has completed; so, be careful when you try to do anything that may take a long time.

#### update ####

The update script is very similar to the `pre-receive` script, except that it’s run once for each branch the pusher is trying to update. If the pusher is trying to push to multiple branches, `pre-receive` runs only once, whereas update runs once per branch they’re pushing to. Instead of reading from stdin, this script takes three arguments: the name of the reference (branch), the SHA-1 that reference pointed to before the push, and the SHA-1 the user is trying to push. If the update script exits non-zero, only that reference is rejected; other references can still be updated.

## An Example Git-Enforced Policy ##

In this section, you’ll use what you’ve learned to establish a Git workflow that checks for a custom commit message format, enforces fast-forward-only pushes, and allows only certain users to modify certain subdirectories in a project. You’ll build client scripts that help the developer know if their push will be rejected and server scripts that actually enforce the policies.

I used Ruby to write these, both because it’s my preferred scripting language and because I feel it’s the most pseudocode-looking of the scripting languages; thus you should be able to roughly follow the code even if you don’t use Ruby. However, any language will work fine. All the sample hook scripts distributed with Git are in either Perl or Bash scripting, so you can also see plenty of examples of hooks in those languages by looking at the samples.

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
