<!-- Attentie heren en dames vertalers.
Ik zou het volgende willen voorstellen:
Er zijn bepaalde termen die voor de gemiddelde Nederlandse computer gebruiker 
veel beter klinken (of bekender voorkomen) als de orginele Engelse term. In het
begin zullen deze termen niet vaak voorkomen, maar in de meer diepgaandere 
hoofdstukken komen deze steeds meer voor. Termen als "Committen", "Mergen" 
en "Applyen" klinken beter dan "Plegen" of "Toepassen", "Samenvoegen" en 
"Toepassen" (wat bovendien slecht valt te onderscheiden van de 
commit-toepassing). De mensen die dit boek lezen zijn, naar mijn bescheiden 
inschatting, al redelijk op de hoogte van versiebeheer en passen (zie ik in 
de praktijk) deze termen al toe. Een nieuwe terminologie introduceren lijkt 
me dan ook niet noodzakelijk.
Verder blijven er altijd kreten over als "directory", wat vertaald zou kunnen 
worden als "map", maar bij het Engelse werkwoord to map krijgen we dan weer het
probleem: hoe dit weer te vertalen? Daarom zou ik willen voorstellen om deze 
basis-termen toch onvertaald te laten.

Twijfelgevallen zullen altijd blijven zoals de term "file", daarvan wordt in de
praktijk zowel de term file als bestand gebruikt. Ik denk dat we hier moeten 
kijken hoe het in de context past. 
Maar ook een term als "tool" en (ik zit zelf nog op een mooie Nederlandse term
te broeden) "plumbing", hierbij stel ik voor om eenmalig een Nederlandse 
vertaling te geven, tussen haakjes de Engelse term te geven en in het vervolg
de Engelse term te gebruiken. Wederom is de context hier belangrijk.

Verder stel ik ook voor om de regels op https://onzetaal.nl/taaladvies zoveel
mogelijk te volgen. Bijvoorbeeld de regels omtrent het spellen van Engelse 
werkwoorden die in het Nederlands gebruikt worden.

Let wel: ik wil niemand tot iets verplichten, maar ik denk dat we moeten 
streven naar een zo duidelijk mogelijke en best bij de praktijk aansluitende
vertaling moeten proberen te maken.

Veel succes en plezier bij het vertalen...
-->
<!-- SHA-1 of last checked en-version: 4cefec -->
# Git op maat maken #

Tot zover heb ik de fundamentele werking van Git behandeld en hoe het te gebruiken, en ik heb een aantal tools geïntroduceerd die Git tot je beschikking stelt om je het makkelijk en efficiënt te laten gebruiken. In dit hoofdstuk zal ik wat operaties doorlopen die je kunt gebruiken om Git op een maat gemaakte manier te laten werken middels het introduceren van een aantal belangrijke configuratie-instellingen en het inhaak-systeem (hooks). Met deze tools is het makkelijk om Git precies te laten werken op de manier zoals jij, je bedrijf, of je groep het nodig hebben.

## Git configuratie ##

Zoals je kort in Hoofdstuk 1 gezien hebt, kun je Git configuratie instellingen specificeren met het `git config` commando. Een van de eerste dingen die je deed was je naam en e-mail adres instellen:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Hierna zal je een paar van de meer interessante opties gaan zien, die je op vergelijkbare manier kunt instellen om je Git op maat te maken.

Je zag al wat eenvoudige Git configuratie details in het eerste hoofdstuk, en die zal ik hier snel nog eens laten zien. Git gebruikt een aantal configuratie bestanden om het niet-standaard gedrag dat je wilt te bepalen. De eerste plek waar Git kijkt voor deze waarden is in een `/etc/gitconfig` bestand, deze bevat de waarden voor alle gebruikers op het systeem en al hun repositories. Als je de optie `--system` aan `git config` meegeeft, leest en schrijft Git naar dit bestand.

De volgende plaats waar Git kijkt is het `~/.gitconfig` bestand, wat specifiek is voor elke gebruiker. Je kunt er voor zorgen dat Git naar dit bestand leest en schrijft door de `--global` optie mee te geven.

Als laatste kijkt Git naar configuratie waarden in het config bestand in de Git directory (`.git/config`) van de repository dat op dat moment gebruikt wordt. Deze waarden zijn specifiek voor die ene repository. Ieder niveau overschrijft de waarden van de vorige, dus waarden in `.git/config` hebben voorrang op die in `/etc/gitconfig` bijvoorbeeld. Je kunt die waarden ook instellen door het bestand handmatig aan te passen en de correcte syntax te gebruiken, maar het is normaalgesproken eenvoudiger het `git config` commando uit te voeren.

### Basis client configuratie ###

De configuratie opties die herkend worden door Git vallen in twee categorieën: de client kant en de server kant. De meerderheid van de opties zijn voor de client kant: de configuratie van jouw persoonlijke voorkeuren. Alhoewel er massa's opties beschikbaar zijn, zal ik er maar een paar behandelen die ofwel veelgebruikt zijn ofwel je workflow significant kunnen beïnvloeden. Veel opties zijn alleen van toepassing in uitzonderlijke gevallen, die ik nu niet zal behandelen. Als je een lijst van alle opties wilt zien, die door jouw versie van Git worden herkend kan je dit uitvoeren

	$ git config --help

De gebruikershandleiding voor `git config` toont alle beschikbare opties in groot detail.

#### core.editor ####

Standaard zal Git de tekst editor gebruiken die je zelf ingesteld hebt als standaard en anders valt Git terug op de Vi editor om je commit en tag boodschappen te maken of te wijzigen. Om die instelling naar iets anders om te zetten, kun je de `core.editor` instelling gebruiken:

	$ git config --global core.editor emacs

Vanaf nu maakt het niet meer uit wat je als je standaard shell editor waarde ingesteld hebt, Git zal Emacs starten om boodschappen aan te passen.

#### commit.template ####

Als je hier het een pad instelt dat naar een bestand op je systeem wijst, zal Git dat bestand als de standaard boodschap gebruiken bij elke commit. Bijvoorbeeld, stel dat je een sjabloon bestand `$HOME/.gitmessage.txt` maakt die er zo uitziet:

	onderwerp regel

	wat er gebeurd is

	[ticket: X]

Om Git te vertellen dat het dit moet gebruiken als standaard boodschap dat in de editor moet verschijnen als je `git commit` uitvoert, stel je de `commit.template` configuratie waarde in:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

Daarna zal je editor zoiets als dit openen als je standaard commit boodschap bij een commit:

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

Als je een beleid hebt voor commit boodschappen, dan vergroot het plaatsen van een sjabloon op je systeem en het configureren ervan als standaard te gebruiken binnen Git de kans dat het beleid ook daadwerkelijk wordt gevolgd.

#### core.pager ####

De instelling voor 'core.pager' bepaalt welke pagineer tool gebruikt wordt door Git om de uitvoer van bijvoorbeeld `log` en `diff` weer te geven. Je kunt het instellen als `more` of als je favoriete pagineer tool (standaard is het `less`), of je kunt het uitzetten door het als een lege tekst in te stellen:

	$ git config --global core.pager ''

Als je dat uitvoert zal Git de gehele tekst van alle commando's ononderbroken tonen, ongeacht de lengte van die uitvoer.

#### user.signingkey ####

Als je gebruik maakt van ondertekende tags (zoals besproken in Hoofdstuk 2), dan maakt het instellen van een GPG signeersleutel als configuratie instelling je leven een stuk eenvoudiger. Stel je sleutel ID zo in:

	$ git config --global user.signingkey <gpg-key-id>

Nu kun je tags signeren zonder steeds je sleutel op te hoeven geven bij het `git tag` commando:

	$ git tag -s <tag-name>

#### core.excludesfile ####

Je kunt patronen in het `.gitignore` bestand van je project zetten zodat Git ze niet ziet als untracked bestanden en niet zal proberen ze te stagen als je `git add` op ze uitvoert, zoals besproken in Hoofdstuk 2. Maar als je wilt dat een ander bestand buiten je project die waarden bevat of additionele waarden wilt, kan je Git vertellen met de `core.excludesfile`-waarde waar dat bestand is. Stel het eenvoudigweg in als een pad naar een bestand met een inhoud dat vergelijkbaar is met wat in een `.gitignore` bestand zou staan.

#### help.autocorrect ####

Deze optie is alleen beschikbaar in Git 1.6.1. en later. Als je in Git een commando verkeerd intypt, toont het je zoiets als dit:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Als je `het.autocorrect` op 1 instelt, zal Git automatisch het commando uitvoeren als het slechts één passend commando heeft in dit scenario.

### Kleuren in Git ###

Git kan zijn uitvoer op de terminal in kleur tonen, wat kan helpen om de uitvoer snel en eenvoudig visueel te verwerken. Er zijn een aantal opties die kunnen helpen om de kleuren naar jouw voorkeur in te stellen.

#### color.ui ####

Git zal automatisch het meeste van zijn uitvoer in kleur tonen als je het vraagt. Je kunt erg specifiek worden in wat je gekleurd wilt hebben en hoe; maar om alle standaard kleuren in de terminal aan te zetten, stel dan `color.ui` in op true:

	$ git config --global color.ui true

Als deze waarde ingesteld is, zal Git zijn uitvoer in kleur tonen zodra deze naar een terminal gaat. Andere mogelijke opties zijn false wat de uitvoer nooit kleurt, en always, wat de kleuren altijd weergeeft zelfs als je Git commando's uitvoert naar een bestand of deze naar een ander commando doorsluist (zgn. piping).

Je zult zelden `color.ui = always` willen. In de meeste scenario's, als je kleuren in je omgeleide uitvoer wil, kan je een `--color` vlag aan het Git commando meegeven om het te forceren kleuren te gebruiken. De `color.ui = true` instelling is degene die je vrijwel altijd wilt gebruiken.

#### `color.*` ####

Als je meer specifiek wil zijn welke commando's gekleurd moeten zijn en hoe, dan voorziet Git in woordspecifieke kleuren instellingen. Elk van deze kan worden ingesteld op `true`, `false` of `always`:

	color.branch
	color.diff
	color.interactive
	color.status

Daarnaast heeft elk van deze ook sub-instellingen die je kunt gebruiken om specifieke kleuren in te stellen voor delen van de uitvoer, als je iedere kleur wilt wijzigen. Bijvoorbeeld, om de meta-informatie in je diff uitvoer in blauwe voorgrond, zwarte achtergrond en vetgedrukt in te stellen, kun je dit uitvoeren

	$ git config --global color.diff.meta “blue black bold”

Je kunt de kleur instellen op een van de volgende waarden: ’normal’, ’black’, ’red’, ’green’, ’yellow’, ’blue’, ’magenta’, ’cyan’, of ’white’. Als je een attribuut wil hebben, zoals vetgedrukt in het vorige voorbeeld, kun je kiezen uit ’bold’, ’dim’, ’ul’, ’blink’ en ’reverse’.

Zie de manpage van `git config` voor alle sub-instellingen die je kunt instellen, als je dat wilt.

### Externe merge en diff tools ###

Alhoewel Git een interne implementatie van diff heeft, deze heb je tot nu toe gebruikt, kan je in plaats daarvan een externe tool instellen. Je kunt ook een grafisch merge conflict-oplossings tool instellen, in plaats van handmatig de conflicten op te moeten lossen. Ik zal nu demonstreren hoe je het Perforce Visuele Merge Tool (P4Merge) in moet stellen, om je diff en merge oplossingen te doen, omdat het een fijne grafische tool is en omdat het gratis is.

Als je dit wilt proberen, P4Merge werkt op alle grote platformen, dus je zou het moeten kunnen doen. Ik zal in de voorbeelden paden gebruiken die op Mac en Linux systemen werken; voor Windows moet je `/usr/local/bin` veranderen in een pad naar een uitvoerbaar bestand op jouw machine.

Je kunt P4Merge hier downloaden:

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

Om te beginnen ga je externe wrapper scripts instellen om de commando's uit te voeren. Ik zal het Mac pad gebruiken voor de applicatie; in andere systemen zal het moeten wijzen naar de plaats waar de `p4merge` binary geïnstalleerd is. Maak merge wrapper script, genaamd `extMerge`, die jouw applicatie met alle meegegeven argumenten aanroept:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

De diff wrapper controleert dat er precies zeven argumenten meegegeven zijn, en geeft twee ervan aan het merge script. Standaard geeft Git de volgende argumenten aan het diff programma mee:

	pad oud-bestand oude-hex oude-modus nieuwe-bestand nieuwe-hex nieuwe-modus

Omdat je alleen de `oude-bestand` en `nieuwe-bestand` argumenten wilt, zul je het wrapper script gebruiken om de juiste parameters door te geven.

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Je moet er ook voor zorgen dat deze scripts uitvoerbaar zijn:

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

Nu kun je het config bestand instellen om de zelfgemaakte merge en diff tools te gebruiken. Dit wordt gedaan met een aantal instellingen: `merge.tool` om Git te vertellen welke strategie hij moet gebruiken, `mergetool.*.cmd` om te specificeren hoe het commando moet worden uitgevoerd, `mergetool.trustExitCode` om Git te vertellen of de exit code van dat programma een succesvolle merge betekent of niet, en `diff.external` om Git te vertellen welk commando het moet uitvoeren voor diffs. Dus, je kunt de vier configuratie commando's uitvoeren

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

of je kunt je `~/.gitconfig` bestand aanpassen en deze regels toevoegen:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	  trustExitCode = false
	[diff]
	  external = extDiff

Nadat dit alles gebeurd is, kan je diff commando's zoals deze uitvoeren:

	$ git diff 32d1776b1^ 32d1776b1

in plaats van de uitvoer van diff op de commando regel, wordt een instantie van P4Merge gestart door Git, en dat ziet er ongeveer uit als in Figuur 7-1.

Insert 18333fig0701.png
Figuur 7-1. P4Merge.

Als je twee branches probeert te mergen en je krijgt vervolgens merge conflicten, kan je het `git mergetool` commando uitvoeren. P4Merge wordt dan opgestart om je het conflict op te laten lossen met behulp van de GUI tool.

Het aardige van deze wrapper opstelling is dat je de diff en merge tools eenvoudig aan kunt passen. Bijvoorbeeld, om je `extDiff` en `extMerge` tools in te stellen zodat ze bijvoorbeeld de KDiff3 tool uitvoeren, is het enige dat je moet doen het `extMerge` bestand aanpassen:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

Nu zal Git de KDiff3 tool gebruiken voor het tonen van diff en het oplossen van merge conflicten.

Git is 'af fabriek' al ingesteld om een aantal andere mergeconflict-oplossings tools te gebruiken zonder dat je de cmd configuratie op hoeft te zetten. Je kunt je merge tool op kdiff3 instellen, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff of gvimdiff. Als je niet geïnteresseerd bent in het gebruik van KDiff3 als diff, maar het liever alleen wilt gebruiken voor merge conflict oplossing, en het kdiff3 commando zit in je pad, dan kun je dit uitvoeren

	$ git config --global merge.tool kdiff3

Als je dit uitvoert in plaats van de `extMerge` en `extDiff` bestanden in te stellen, zal Git KDiff3 gebruiken voor conflict oplossing en het normale Git diff tool voor diffs.

### Opmaak en witruimten ###

Problemen met opmaak en witruimten zijn één van de meest frustrerende en subtiele problemen die veel ontwikkelaars tegenkomen bij het samenwerken, in het bijzonder over verschillende platformen. Het is heel eenvoudig voor patches en ander werk om subtiele witruimte veranderingen te introduceren, omdat editors ze stiekum introduceren of omdat Windows programmeurs carriage returns aan het eind van de regels toevoegen van bestanden die ze bewerken in gemengde platformprojecten. Git heeft een aantal configuratie opties om met deze problemen te helpen.

#### core.autocrlf ####

Als je op Windows programmeert, of een ander systeem gebruikt maar samenwerkt met mensen die op Windows werken, zal je op enig moment tegen regeleinde problemen aanlopen. Dat komt omdat Windows zowel een carriage-return als een linefeed karakter gebruikt voor regeleindes in zijn bestanden, terwijl Mac en Linux systemen alleen het linefeed karakter gebruiken. Dit is een subtiel maar verschrikkelijk irritant feit van het werken met gemengde platformen.

Git kan hiermee omgaan door CRLF regeleinden automatisch om te zetten naar LF zodra je commit, en vice versa op het moment dat je code uitcheckt op je bestandssysteem. Je kunt deze functionaliteit aanzetten met de `core.autocrlf` instelling. Als je op een Windows machine zit, stel het dan in op `true` – dit verandert LF regeleinden in CRLF zodra je code uitcheckt:

	$ git config --global core.autocrlf true

Als je op een Linux of Mac systeem werkt (die LF regeleinden gebruiken) dan wil je niet dat Git ze automatisch verandert op het moment dat Git bestanden uitcheckt. Maar als een bestand met CRLF regeleinden onverhoopt toch geïntroduceerd wordt, dan wil je waarschijnlijk dat Git dit repareert. Je kunt Git vertellen dat je wilt dat hij CRLF in LF veranderd tijdens het committen, maar niet de andere kant op door het instellen van `core.autocrlf` op input:

	$ git config --global core.autocrlf input

Deze instelling zal CRLF regeleinden in Windows checkouts gebruiken, en LF regeleinden in Mac en Linux systemen en in de repository.

Als je een Windows programmeur bent die aan een project voor alleen Windows werkt dan kun je deze functionaliteit uitzetten, waardoor de carriage-returns in de repository worden opgeslagen door de configuratie waarde op `false` te zetten:

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git is standaard ingericht om een aantal witruimte problemen te detecteren en te repareren. Het kan op vier veelvoorkomende witruimte problemen letten – twee staan er standaard aan en kunnen uitgezet worden, en twee staan standaard uit, maar kunnen aangezet worden.

De twee die standaard aan staan zijn `trailing-space`, waarmee wordt gekeken of er spaties aan het eind van een regel staan, en `space-before-tab`, wat kijkt of er spaties voor tabs staan aan het begin van een regel.

De twee die standaard uit staan maar aangezet kunnen worden, zijn `indent-with-non-tab` die kijkt naar regels die met acht of meer spaties beginnen in plaats van tabs, en `cr-at-eol`, wat Git vertelt dat carriage-returns aan het eind van een regel geaccepteerd mogen worden.

Je kunt Git vertellen welke van deze je aan wilt zetten door `core.whitespace` de waardes te geven die je aan of uit wilt zetten, gescheiden door komma's. Je kunt waarden uitzetten door ze weg te laten uit de instelling tekst of door een `-` vooraf te laten gaan aan de waarde. Bijvoorbeeld, als je alles aan wil behalve `cr-ar-eol`, dan kan je dit doen:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Git zal deze problemen detecteren zodra je een `git diff` commando uitvoert en ze proberen in te kleuren zodat je ze mogelijk kunt repareren voordat je ze commit. Het zal deze waarden ook gebruiken om je te helpen met patches toe te passen met `git apply`. Als je patches gaat applyen, kan je Git vragen om je te waarschuwen als hij patches toepast waarin deze specifieke witruimte-problemen zitten:

	$ git apply --whitespace=warn <patch>

Of je kunt Git vragen om automatisch deze problemen te repareren alvorens de patch te applyen:

	$ git apply --whitespace=fix <patch>

Deze opties zijn ook op het `git rebase` commando van toepassing. Als je witruimte problemen gecommit hebt maar ze nog niet stroomopwaarts gepushed hebt, kun je een `rebase` uitvoeren met de `--whitespace=fix` optie om Git automatisch witruimte problemen te laten repareren terwijl het de patches herschrijft.

### Server configuratie ###

Er zijn lang niet zoveel configuratie opties beschikbaar voor de server kant van Git, maar er zijn er een paar interessante bij waar je misschien op gewezen wilt worden.

#### receive.fsckObjects ####

Standaard zal Git niet alle objecten die tijdens een push ontvangen worden op consistentie controleren. Alhoewel Git kan controleren of ieder object nog steeds bij zijn SHA-1 checksum past en naar geldige objecten wijst, doet gebeurt dat niet standaard bij iedere push. Het is een relatief dure operatie en kan veel extra tijd kosten bij iedere push, afhankelijk van de grootte van het repository of de push. Als je wilt dat Git ieder object op consistentie controleert bij elke push, dan kun je dit afdwingen door `receive.fsckObjects` op true te zetten:

	$ git config --system receive.fsckObjects true

Nu zal Git de integriteit van de repository controleren voordat een push geaccepteerd wordt, om er zeker van te zijn dat defecte clients geen corrupte gegevens introduceren.

#### receive.denyNonFastForwards ####

Als je commits rebased die je al gepusht hebt en dan nog eens pusht, of op een andere manier een commit probeert te pushen naar een remote branch die niet de commit bevat waarnaar de remote branch op dat moment wijst, dan wordt dat afgewezen. Dit is over het algemeen goed beleid, maar in het geval van de rebase kan je besluiten dat je weet waar je mee bezig bent en kan je de remote branch geforceerd vernieuwen door een `-f` vlag met je push commando mee te geven.

Om de mogelijkheid van het geforceerd vernieuwen van remote branches naar niet fast-forward referenties uit te schakelen, stel je `receive.denyNonFastForwards` in:

	$ git config --system receive.denyNonFastForwards true

Een andere manier waarop je dit kunt doen is het instellen van ontvangst hooks op de server wat we zo meteen gaan behandelen. Die aanpak stelt je in staat meer complexe dingen te doen, zoals het weigeren van niet fast-forwards afkomstig van een bepaalde groep gebruikers.

#### receive.denyDeletes ####

Een van de manieren waarop een gebruiker het `denyNonFastForwards` beleid kan omzeilen is door de branch te verwijderen en het dan opnieuw terug pushen met de nieuwe referenties. In nieuwere versies van Git (beginnend bij versie 1.6.1), kun je `receive.denyDeletes` op true zetten:

	$ git config --system receive.denyDeletes true

Dit zal systeembreed branch en tag verwijdering door middel van een push weigeren - geen enkele gebruiker mag het meer. Om remote branches te verwijderen, moet je de ref bestanden handmatig verwijderen van de server. Er zijn ook interessantere manieren om dit per gebruiker af te dwingen door middel van ACL's, zoals je zult leren aan het eind van dit hoofdstuk.

## Git attributen ##

Een aantal van deze instellingen kan ook gedaan worden voor een pad, zodat Git die instellingen alleen toepast voor een subdirectory of subset van bestanden. Deze pad-specifieke instellingen worden Git attributen genoemd en worden in een `.gitattribute` bestand in een van je directories gezet (normaliter in de hoofddirectory van je project) of in het `.git/info/attributes` bestand als je niet wilt dat het attributes bestand gecommit wordt met je project.

Door attributen te gebruiken kun je dingen doen als het specificeren van aparte merge strategieën voor individuele bestanden of directories in je project, Git vertellen hoe niet-tekst bestanden moeten worden gediff'ed, of Git inhoud laten filteren voordat je het in- of uitcheckt van Git. In deze paragraaf zal je iets leren over de attributen die je kun instellen op de paden in je Git project en een paar voorbeelden zien hoe je deze eigenschappen in de praktijk gebruikt.

### Binaire bestanden ###

Een leuke truc waarvoor je Git attributen kunt gebruiken is het vertellen aan Git welke bestanden binair zijn (in die gevallen waarin hij het niet zelf kan ontdekken) en Git dan speciale instructies geven hoe die bestanden te behandelen. Bijvoorbeeld, sommige tekstbestanden worden gegenereerd en zijn niet te diff'en, of sommige binaire bestanden kunnen wel gediff'ed worden – je zult zien hoe je Git vertelt welke soort het is.

#### Binaire bestanden identificeren ####

Sommige bestanden zien eruit als tekstbestanden, maar moeten toch behandeld worden als binaire gegevens. Bijvoorbeeld, Xcode projecten op de Mac bevatten een bestand dat eindigt in `.pbxproj`, wat eigenlijk een JSON (javascript gegevens in platte tekst formaat) gegevensset is, dat geschreven wordt naar de schijf door de IDE en waarin je bouw-instellingen enzovoorts opgeslagen zijn. Alhoewel het technisch gezien een tekstbestand is, omdat het volledig ASCII is, zul je het niet als zodanig willen behandelen omdat het eigenlijk een lichtgewicht gegevensbank is – je kunt de inhoud niet mergen als twee mensen het gewijzigd hebben, en diffs zijn over het algemeen niet behulpzaam. Het bestand is bedoeld om gebruikt te worden door een machine. In essentie wil je het behandelen als een binair bestand.

Om Git te vertellen dat hij alle `pbxproj` bestanden als binaire gegevens moet behandelen, voeg je de volgende regel toe aan je `.gitattributes` bestand:

	*.pbxproj -crlf -diff

Nu zal Git niet proberen om CRLF problemen te corrigeren of repareren; noch zal het proberen een diff te berekenen of te tonen voor de veranderingen in dit bestand als je `git show` of `git diff` uitvoert op je project. In de 1.6 serie van Git, kun je ook het ingebouwde macro `binary` gebruiken die `-crlf -diff` vervangt:

	*.pbxproj binary

#### Binaire bestanden diff'en ####

In Git kan je de functionaliteit van Git attributen gebruiken om binaire bestanden uiteindelijk toch te diff'en. Je doet dit door Git te vertellen hoe het de binaire gegevens naar tekst formaat moet omzetten, die dan via de normale diff vergeleken kan worden. Maar de vraag is hoe je de *binaire* gegevens naar tekst omzet. De beste oplossing is om een tool te vinden die deze conversie van binair naar tekstformaat voor je doet. Helaas kunnen weinig binaire formaten als mens-leesbaar formaat gerepresenteerd worden (probeer maar eens de gegevens van een geluidsfragment om te zetten naar tekst). Als dit het geval is en je bent er niet in geslaagd om een tekst-representatie te krijgen van de inhoud van het bestand, is het vaak relatief eenvoudig om een menselijk leesbare omschrijving van de inhoud of metadata te verkrijgen. Metadata geeft je niet een volledige representatie van de inhoud van het bestand, maar het is in elk geval beter dan niets.

We gaan beide beschreven varianten gebruiken om bruikbare diff's te krijgen voor vaakgebruikte binaire formaten.

Even een terzijde: Er zijn verscheidene binaire formaten met een tekstinhoud waar moeilijk een bruikbare converter voor te vinden is. In die gevallen kan je proberen een tekst uit het bestand extraheren met het `strings` programma. Sommige van deze bestanden zouden een UTF-16 encoding of andere "codepages" kunnen gebruiken en dan kan `strings` niets bruikbaars in die bestanden vinden. Resultaten in het verleden geven geen garantie voor de toekomst. Echter `strings` wordt geleverd bij de meeste Mac en Linux systemen, dus het zou een goede eerste kandidaat zijn om dit te proberen bij veel binaire formaten.

#### MS Word bestanden ####

Ten eerste zullen we de beschreven techniek gebruiken om een van de meest ergerlijke problemen in de menselijke geschiedenis op te lossen: Word documenten onder versiebeheer brengen. Iedereen weet dat Word een van de slechtste editors verkrijgbaar is; maar, vreemd genoeg, iedereen gebruikt het. Als je Word documenten in versie beheer wilt krijgen, kan je ze in een Git repostiory gooien en om de zoveel tijd een commit uitvoeren, maar wat voor nut heeft dit? Als je `git diff` uitvoert, zou je iets als dit zien:


	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

Je kunt niet direct twee versies vergelijken tenzij je ze uitcheckt en handmatig doorneemt, toch? Maar gelukkig kan je dit toch redelijk goed met Git attributen doen. Zet de volgende regel in je `.gitattributes` bestand:

	*.doc diff=word

Dit vertelt Git dat alle bestanden die in het patroon (.doc) passen het "word" filter moeten gebruiken als je een diff probeert te bekijken die wijzigingen bevat. Wat is dat "word" filter eigenlijk? Je moet het zelf opzetten. Hier ga je Git configureren om het `catdoc` programma te gebruiken, die specifiek geschreven is om tekst uit binaire MS Word documenten te extraheren (je kunt het krijgen op `http://www.wagner.pp.ru/~vitus/software/catdoc/`), om Word documenten in leesbare tekstbestanden te converteren, en die vervolgens juist diff'en:

	$ git config diff.word.textconv catdoc

Dit commando voegt een sectie toe aan je `.git/config`, wat er ongeveer zo uitziet:

	[diff "word"]
		textconv = catdoc

Nu weet Git dat wanneer het probeert een diff uit te voeren tussen twee snapshots, en bestandsnamen eindigen op `.doc` dat het deze bestanden door de "word" filter moet halen, die gedefinieerd is als het `catdoc` programma. Effectief maakt het twee gewone tekst-gebaseerde versies van je Word bestanden vooraleer te proberen ze met diff te vergelijken.

Hier is een voorbeeld. Ik heb hoofdstuk 1 van dit boek in Git gezet, wat tekst in een paragraaf toegevoegd en daarna het document gesaved. Daarna voerde ik `git diff` uit om te zien wat er gewijzigd was:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -128,7 +128,7 @@ and data size)
	 Since its birth in 2005, Git has evolved and matured to be easy to use
	 and yet retain these initial qualities. It’s incredibly fast, it’s
	 very efficient with large projects, and it has an incredible branching
	-system for non-linear development.
	+system for non-linear development (See Chapter 3).

Git vertelt me succesvol en kort en bondig dat ik de tekst "(See Chapter 3)" heb toegevoegd, wat juist is. Werkt perfect!

##### OpenDocument tekst bestanden #####

Dezelfde aanpak die we hebben gebruikt vooro MS Word bestanden (`*.doc`) kan worden gebruikt bij OpenDocument Tekst bestanden (`*.odt`) wat gemaakt is door OpenOffice.org.

Voeg de volgende regel toe aan je `.gitattributes` bestand:

	*.odt diff=odt

Zet nu het `odt` diff filter op in `.git/config`:

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

OpenDocument bestanden zijn eigenlijk gezipte directories met daarin meerdere bestanden (de inhoud ervan in een XML formaat, stylesheets, plaatjes, etc.). Ze zullen een script moeten schrijven om de inhoud te extraheren en dit terug te geven als platte tekst. Maak een bestand `/usr/local/bin/odt-to-txt` (het staat je vrij om dit in een andere directory neer te zetten) met de volgende inhoud:

	#! /usr/bin/env perl
	# Simplistic OpenDocument Text (.odt) to plain text converter.
	# Author: Philipp Kempgen

	if (! defined($ARGV[0])) {
		print STDERR "No filename given!\n";
		print STDERR "Usage: $0 filename\n";
		exit 1;
	}

	my $content = '';
	open my $fh, '-|', 'unzip', '-qq', '-p', $ARGV[0], 'content.xml' or die $!;
	{
		local $/ = undef;  # slurp mode
		$content = <$fh>;
	}
	close $fh;
	$_ = $content;
	s/<text:span\b[^>]*>//g;           # remove spans
	s/<text:h\b[^>]*>/\n\n*****  /g;   # headers
	s/<text:list-item\b[^>]*>\s*<text:p\b[^>]*>/\n    --  /g;  # list items
	s/<text:list\b[^>]*>/\n\n/g;       # lists
	s/<text:p\b[^>]*>/\n  /g;          # paragraphs
	s/<[^>]+>//g;                      # remove all XML tags
	s/\n{2,}/\n\n/g;                   # remove multiple blank lines
	s/\A\n+//;                         # remove leading blank lines
	print "\n", $_, "\n\n";

En maak het uitvoerbaar

	chmod +x /usr/local/bin/odt-to-txt

Nu zal `git diff` je kunnen vertellen wat er gewijzigd is in `.odt` bestanden.


##### Beeldbestanden #####

Een ander interessant probleem dat je hiermee kunt oplossen is het diff'en van beeldbestanden. Een manier om dit te doen is PNG bestanden door een filter te halen dat de EXIF informatie eruit peutert - dat is metadata die wordt opgeslagen bij de meeste beeldbestand formaten. Als je het `exiftool` programma downloadt en installeert, kan je dit gebruiken om je plaatjes naar tekst over de metadata om te zetten, zodat de diff op z'n minst een tekstuele representatie van eventuele wijzigingen laat zien:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Als je een plaatje in je project vervangt en `git diff` uitvoert, dan zie je zoiets als dit:

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

### Keyword expansie ###

Keyword expansie zoals in SVN of CVS gebruikt wordt, wordt vaak gevraagd door ontwikkelaars die gewend zijn aan die systemen. Het grote probleem in Git is dat je een bestand niet mag wijzigen met informatie over de commit nadat je het gecommit hebt, omdat Git eerst de checksum van het bestand maakt. Maar, je kunt tekst in een bestand injecteren zodra het uitgechecked wordt en dit weer verwijderen voordat het aan een commit toegevoegd wordt. Met Git attributen zijn er twee manieren om dit te doen.

Als eerste kun je de SHA-1 checksum van een blob automatisch in een `$Id$` veld in het bestand stoppen. Als je dit attribuut in een bestand of aantal bestanden zet, dan zal Git de volgende keer dat je die branch uitcheckt dat veld vervangen met de SHA-1 van de blob. Het is belangrijk om op te merken dat het niet de SHA van de commit is, maar van de blob zelf:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

De volgende keer dat je dit bestand uitcheckt, injecteert Git de SHA van de blob:

	$ rm text.txt
	$ git checkout -- text.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Echter dit resultaat heeft slechts een beperkte nut. Als je sleutelwoord vervanging (keyword substitution) in CVS of Subversion gebruikt hebt, kun je een datumstempel toevoegen – de SHA is niet zo bruikbaar, omdat het vrij willekeurig is en je kunt niet zeggen of de ene SHA ouder of nieuwer is dan de andere.

Je kunt echter je eigen filters voor het doen van vervanging bij commit/checkout schrijven. Dit zijn de "kuis" ("clean") en "besmeer" ("smudge") filters. In het `.gitattributes` bestand kan je voor bepaalde paden een filter instellen en dan scripts instellen die bestanden bewerkt vlak voordat ze uitgechecked worden ("smudge", zie Figuur 7-2) en vlak voordat ze gecommit worden ("clean", zie Figuur 7-3). De filters kunnen ingesteld worden om allerlei leuke dingen doen.

Insert 18333fig0702.png
Figuur 7-2. Het “smudge” filter wordt bij checkout uitgevoerd.

Insert 18333fig0703.png
Figuur 7-3. Het “clean” filter wordt uitgevoerd zodra bestanden worden gestaged.

De originele commit boodschap van deze functionaliteit geeft een eenvoudig voorbeeld hoe je al je C broncode door het `indent` programma kunt laten bewerken alvorens te committen. Je kunt het instellen door het filter attribuut in je `.gitattributes` bestand te zetten zodat `*.c` bestanden door de "indent" filter gehaald worden:

	*.c     filter=indent

Vervolgens vertel je Git wat het "indent" filter doet bij smudge en clean:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

In dit geval zal Git, als je bestanden commit die met `*.c` overeenkomen, ze door het indent programma halen alvorens ze te committen, en ze door het `cat` programma halen alvorens ze op de schijf uit te checken. Het `cat` programma is eigenlijk een no-op: het geeft de gegevens onveranderd door. Deze combinatie zal effectief alle C broncode bestanden door `indent` filteren alvorens te committen.

Een ander interessant voorbeeld is `$Date$` sleutelwoord expansie, in RCS stijl. Om dit goed te doen, moet je een klein script hebben dat een bestandsnaam pakt, de laatste commit datum voor dit project opzoekt, en de datum in dat bestand toevoegt. Hier volgt een klein Ruby script dat dat doet:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Het enige dat het script doet is de laatste commit datum uit het `git log` commando halen, het in iedere `$Date$` tekst stoppen die het in stdin ziet, en de resultaten afdrukken – het moet eenvoudig na te bouwen zijn in de taal waar je het beste in thuisbent. Je kunt dit bestand `expand_date` noemen en het in je pad stoppen. Nu moet je een filter in Git instellen (noem het `dater`), en het vertellen jouw `expand_date` filter te gebruiken om de bestanden tijdens checkout te 'besmeren'. Je zult een Perl expressie gebruiken om dat op te ruimen tijdens een commit:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Dit stukje Perl haalt alles weg dat het in een `$Date$` tekst ziet, om weer op het uitgangspunt uit te komen. Nu je filter klaar is, kun je het testen door een bestand aan te maken met het `$Date$` sleutelwoord en dan een Git attribuut voor dat bestand in te stellen, die het nieuwe filter aanroept.

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

Als je die veranderingen commit en het bestand opnieuw uitcheckt, zal je zien dat het sleutelwoord correct vervangen wordt:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Je ziet hier hoe krachtig deze techniek is voor gebruik in eigengemaakte toepassingen. Je moet wel voorzichtig zijn, om dat het `.gitattributes` bestand ook gecommit wordt en meegestuurd wordt met het project, maar het filter (in dit geval `dater`) niet; dus het zal niet overal werken. Als je deze filters ontwerpt, zouden ze in staat moeten zijn om netjes te falen en het project nog steeds goed te laten werken.

### Je repository exporteren ###

De Git attribute gegevens staan je ook toe om interessante dingen te doen als je een archief van je project exporteert.

#### export-ignore ####

Je kunt Git vertellen dat sommige bestanden of directories niet geëxporteerd moeten worden bij het genereren van een archief. Als er een subdirectory of bestand is waarvan je niet wilt dat het wordt meegenomen in je archief bestand, maar dat je wel in je project ingecheckt wil hebben, dan kun je die bestanden bepalen met behulp van het `export-ignore` attribuut.

Bijvoorbeeld, stel dat je wat testbestanden in een `test/` subdirectory hebt, en dat het geen zin heeft om die in de tarball export van je project mee te nemen. Dan kan je de volgende regel in je Git attributes bestand toevoegen:

	test/ export-ignore

Als je nu `git archive` uitvoert om een tarball van je project te maken, zal die map niet meegenomen worden in het archief.

#### export-subst ####

Iets anders dat je kunt doen met je archieven is eenvoudige sleutelwoord vervanging. Git staat je toe om de tekst `$Format:$` met een van de `--pretty=format` formaat afkortingen in één of meer bestanden te zetten. Veel voorbeelden van die formaatafkortingen zag je al in Hoofdstuk 2. Bijvoorbeeld, als je een bestand genaamd `LAST_COMMIT` wilt meenemen in je project, waarin de laatste commit datum automatisch wordt geïnjecteerd als `git archive` loopt, kun je het bestand als volgt instellen:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

Als je `git archive` uitvoert, zal de inhoud van dat bestand, als mensen het archief bestand openen, er zo uit zien:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge strategieën ###

Je kunt Git attributen ook gebruiken om Git te vertellen dat het verschillende merge strategieën moet gebruiken voor specifieke bestanden in je project. Een erg handige toepassing is Git te vertellen dat het bepaalde bestanden niet moet proberen te mergen als ze conflicten hebben, maar jouw versie moeten gebruiken in plaats van die van de ander.

Dit is handig als een branch in jouw project uiteen is gelopen of gespecialiseerd is, maar je wel in staat wilt zijn om veranderingen daarvan te mergen, en je wilt bepaalde bestanden negeren. Stel dat je een database instellingen bestand hebt dat database.xml heet en dat in twee branches verschillend is, en je wilt de andere branch mergen zonder jouw database bestand overhoop te halen. Je kunt dan een attribuut als volgt instellen:

	database.xml merge=ours

Als je in de andere branch merged, dan zul je in plaats van merge conflicten met je database.xml bestand zoiets als dit zien:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In dit geval blijft database.xml staan op de versie die je origineel al had.

## Git haken (hooks) ##

Zoals vele andere Versie Beheer Systemen, heeft Git een manier om eigengemaakte scripts aan te roepen wanneer bepaalde belangrijke acties plaatsvinden. Er zijn twee groepen van dit soort hooks: aan de client kant en aan de server kant. De hooks aan de client kant zijn voor client operaties zoals committen en mergen. De hooks voor de server kant zijn voor Git server operaties zoals het ontvangen van gepushte commits. Je kunt deze hooks om allerlei redenen gebruiken, en je zult hier over een aantal ervan kunnen lezen.

### Een hook installeren ###

De hooks zijn allemaal opgeslagen in de `hooks` subdirectory van de Git directory. In de meeste projecten is dat `.git/hooks`. Standaard voorziet Git deze map van een aantal voorbeeld scripts, waarvan de meeste op zich al bruikbaar zijn, maar ze documenteren ook de invoer waarden van elke script. Alle scripts zijn als shell script geschreven met hier en daar wat Perl, maar iedere executable met de juiste naam zal prima werken – je kunt ze in Ruby of Python of wat je wilt schrijven. De namen van de scripts eindigen op .sample; je zult ze van naam moeten veranderen.

Om een hook script aan te zetten, zet je een bestand met de juiste naam en dat uitvoerbaar is in de `hooks` subdirectory van je Git directory. Vanaf dat moment zou het aangeroepen moeten worden. Ik zal de meestgebruikte hook bestandsnamen hier behandelen.

### Hooks aan de client-kant ###

Er zijn veel hooks aan de client-kant. Deze paragraaf verdeelt ze in commit-workflow hooks, e-mail-workflow scripts, en de rest van de client-kant scripts

#### Commit-workflow hooks ####

De eerste vier hooks hebben te maken met het commit proces. De `pre-commit` hook wordt eerst uitgevoerd, nog voor je een commit boodschap intypt. Het wordt gebruikt om het snapshot dat op het punt staat gecommit te worden te inspecteren, om te zien of je iets bent vergeten, om er zeker van te zijn dat tests uitgevoerd worden of om wat je maar wilt te onderzoeken in de code. Als deze hook met een exit-waarde anders dan nul eindigt breekt de commit af, alhoewel je dit kunt omzeilen met `git commit --no-verify`. Je kunt dingen doen als op code stijl controleren (door lint of iets dergelijks uit te voeren), op 'trailing whitespaces' te controleren (de standaard hook doet precies dat), of om de juiste documentatie op nieuwe methodes te controleren.

De `prepare-commit-msg` hook wordt uitgevoerd voordat de commit boodschap editor gestart wordt, maar nadat de standaard boodschap aangemaakt is. Het stelt je in staat om de standaard boodschap aan te passen voordat de commit auteur het ziet. Deze hook accepteert een aantal opties: het pad naar het bestand dat de huidige commit boodschap bevat, het type van de commit, en de SHA-1 van de commit als het een verbeterde (amended) commit betreft. Deze hook is voor normale commits niet zo bruikbaar, maar het is juist bruikbaar voor commits waarbij de standaard boodschap automatisch gegenereerd wordt, zoals sjabloon commit boodschappen, merge commits, gesquashte commits en amended commits. Je kan het samen met een commit sjabloon gebruiken om informatie programmatisch in te voegen.

De `commit-msg` hook accepteert één parameter, wat, nogmaals, het pad naar een tijdelijk bestand is dat de huidige commit boodschap bevat. Als dit script eindigt met een waarde anders dan nul, dan zal Git het commit proces afbreken, je kunt deze gebruiken om je project-status of de commit boodschap te valideren alvorens een commit toe te staan. In het laatste gedeelte van dit hoofdstuk, zal ik met deze hook demonstreren hoe te controleren dat de commit boodschap aan een bepaald patroon voldoet.

Nadat het hele commit proces afgerond is, zal de `post-commit` hook uitgevoerd worden. Het accepteert geen parameters, maar je kunt de laatste commit eenvoudig ophalen door `git log -1 HEAD` uit te voeren. Over het algemeen wordt dit script gebruikt om notificaties of iets dergelijks uit te sturen.

De commit-workflow scripts aan de client-kant kunnen gebruikt worden in vrijwel iedere workflow. Ze worden vaak gebruikt om een bepaald beleid af te dwingen, maar het is belangrijk om op te merken dat deze scripts niet overgedragen worden bij het clonen. Je kunt beleid afdwingen aan de server kant door pushes of commits te weigeren die niet voldoen aan een bepaald beleid, maar het is aan de ontwikkelaar om deze scripts aan de client kant te gebruiken. Dus, deze scripts zijn er om ontwikkelaars te helpen en ze moeten door hen ingesteld en onderhouden worden, alhoewel ze door hen op elk moment aangepast of omzeild kunnen worden.

#### E-mail workflow hooks ####

Je kunt drie client-kant hooks instellen voor een e-mail gebaseerde workflow. Ze worden allemaal aangeroepen door het `git am` commando dus als je dat commando niet gebruikt in je workflow, dan kun je gerust doorgaan naar de volgende paragraaf. Als je patches aanneemt via e-mail die door `git format-patch` geprepareerd zijn, dan zullen sommige van deze scripts nuttig zijn voor je.

De eerste hook die uitgevoerd wordt is `applypatch-msg`. Het accepteert één enkel argument: de naam van het tijdelijke bestand dat de voorgedragen commit boodschap bevat. Git breekt de patch als dit script met een waarde ongelijk aan nul eindigt. Je kunt dit gebruiken om je ervan te verzekeren dat een commit boodschap juist geformatteerd is, of om de boodschap te normaliseren door het script de boodschap aan te laten passen.

De volgende hook die wordt uitgevoerd tijdens het toepassen van patches via `git am` is `pre-applypatch`. Dit neemt geen argumenten aan en wordt uitgevoerd nadat de patch is ge-applyed, zodat je het kunt gebruiken om het snapshot te inspecteren alvorens de commit te doen. Je kunt tests uitvoeren of de werkdirectory op een andere manier inspecteren met behulp van dit script. Als er iets mist of één van de tests faalt, dan zal eindigen met niet nul het `git am` script afbreken zonder de patch te committen.

De laatste hook die uitgevoerd wordt tijdens een `git am` operatie is de `post-applypatch`. Je kunt dat gebruiken om een groep te notificeren of de auteur van de patch die je zojuist gepulled hebt. Je kunt het patch proces niet stoppen met behulp van dit script.

#### Andere client hooks ####

De `pre-rebase` hook wordt uitgevoerd voordat je ook maar iets rebased, en kan het proces afbreken door met een waarde anders dan nul te eindigen. Je kunt deze hook gebruiken om te voorkomen dat commits die al gepusht zijn gerebased worden. De voorbeeld `pre-rebase` hook die Git installeert doet dit, alhoewel deze er vanuit gaat dat "next" de naam is van de branch die je publiceert. Je zult dat waarschijnlijk moeten veranderen in de naam van je stabiele gepubliceerde branch.

Nadat je een succesvolle `git checkout` uitgevoerd hebt, wordt de `post-checkout` hook uitgevoerd; je kunt het gebruiken om je werkdirectory goed in te stellen voor je project omgeving. Dit kan het invoegen van grote binaire bestanden die je niet in versie beheer wil hebben inhouden, of het automatisch genereren van documentatie of iets in die geest.

Als laatste wordt de `post-merge` hook uitgevoerd na een succesvolle `merge` commando. Je kunt deze gebruiken om gegevens in de werkstructuur terug te zetten die Git niet kan ophalen, bijvoorbeeld permissie gegevens. Ook kan deze hook gebruikt worden om te valideren of bestanden, die buiten het beheer van Git liggen, in je werkstructuur zitten die je wellicht erin wilt kopiëren als de werk-tree wijzigt.

### Hooks aan de server-kant ###

Naast de hooks aan de client-kant, kun je als systeem beheerder ook een paar belangrijke hooks aan de server-kant gebruiken om vrijwel elk beleid op het project af te dwingen. Deze scripts worden voor en na de pushes op de server uitgevoerd. De pre hooks kunnen op elk gewenst moment met een getal anders dan nul eindigen om de push te weigeren en een foutmelding naar de client te sturen; je kunt een push beleid instellen dat zo complex is als je zelf wenst.

#### pre-receive en post-receive ####

Het eerste script dat uitgevoerd wordt tijdens het afhandelen van een push van een client is `pre-receive`. Het leest een lijst van referenties die worden gepusht van stdin; als het eindigt met een andere waarde dan nul, worden ze geen van allen geaccepteerd. Je kunt deze hook gebruiken om dingen te doen als valideren dat geen van de vernieuwde referenties een non-fast-forward is, of om te controleren dat de gebruiker die de push uitvoert creatie, verwijder, of push toegang heeft, of toegang om wijzigingen te pushen voor alle bestanden die ze proberen aan te passen met de push.

De `post-receive` hook wordt uitgevoerd nadat het hele proces afgerond is, en het kan gebruikt worden om andere services te vernieuwen of gebruikers te notificeren. Het leest dezelfde stdin gegevens als de `pre-receive` hook. Voorbeelden zijn een e-mail sturen naar een lijst, een continue integratie server notificeren of het vernieuwen van een ticket-volg systeem. Je kunt zelfs de commit boodschappen doorlopen om te zien of er nog tickets zijn die moeten worden geopend, aangepast of afgesloten worden. Dit script kan het push proces niet stoppen, maar de client verbreekt de connectie niet totdat het afgerond is, wees dus een voorzichtig als je iets probeert te doen dat een lange tijd in beslag kan nemen.

#### update ####

Het update script is vergelijkbaar met het `pre-receive` script, behalve dat het uitgevoerd wordt voor iedere branch die de pusher probeert te vernieuwen. Als de pusher naar meerdere branches probeert te pushen wordt `pre-receive` slechts één keer uitgevoerd, daarentegen loopt update bij iedere branch waar ze naar pushen. In plaats van stdin te lezen, accepteert dit script drie argumenten: de naam van de referentie (branch), de SHA-1 waar die referentie naar wees vóór de push, en de SHA-1 die de gebruiker probeert te pushen. Als het update script met een andere waarde dan nul eindigt, wordt alleen die referentie geweigerd; andere referenties kunnen nog steeds vernieuwd worden.

## Een voorbeeld van Git-afgedwongen beleid ##

In deze paragraaf ga je gebruiken wat je geleerd hebt om een Git workflow te maken, die controleert op een aangepast commit boodschap formaat, afdwingt om alleen fast-forward pushes te accepteren en alleen bepaalde gebruikers toestaat om bepaalde subdirectories te wijzigen in een project. Je zult client scripts maken die de ontwikkelaar helpen te ontdekken of hun push geweigerd zal worden en server scripts die het beleid afdwingen.

Ik heb Ruby gebruikt om ze te schrijven, zowel omdat het mijn voorkeur script taal is, als omdat ik vind dat het de meest pseudo code uitziende taal is van de scripttalen; dus je zou in staat moeten zijn om de code redelijk te kunnen volgen zelfs als je geen Ruby gebruikt. Maar elke taal zou prima werken. Alle voorbeeld hook scripts die met Git meegeleverd worden zijn Perl of Bash scripts, dus je kunt ook genoeg voorbeelden van hooks in die talen vinden door naar die bestanden te kijken.

### Server-kant hook ###

Al het werk aan de server kant zal in het update bestand in je hooks directory gaan zitten. Het update bestand zal eens per gepushte branch uitgevoerd worden en accepteert de referentie waarnaar gepusht wordt, de oude revisie waar die branch was en de nieuwe gepushte revisie. Je hebt ook toegang tot de gebruiker die de push doet als de push via SSH gedaan wordt. Als je iedereen hebt toegestaan om connectie te maken als één gebruiker (zoals "git") via publieke sleutel authenticatie, dan moet je wellicht die gebruiker een shell wrapper geven die bepaalt welke gebruiker er connectie maakt op basis van de publieke sleutel, en dan een omgevingsvariabele instellen waarin die gebruiker wordt gespecificeerd. Ik ga er vanuit dat de gebruiker in de `$USER` omgevingsvariabele staat, dus begint je update script met het verzamelen van alle gegevens die het nodig heeft:

	#!/usr/bin/env ruby

	refname = ARGV[0]
	oldrev  = ARGV[1]
	newrev  = ARGV[2]
	user    = ENV['USER']

	puts "Enforcing Policies... \n(#{refname}) (#{oldrev[0,6]}) (#{newrev[0,6]})"

#### Een specifiek commit-bericht formaat afdwingen ####

Je eerste uitdaging is afdwingen dat elke commit bericht moet voldoen aan een specifiek formaat. Laten we zeggen dat ieder bericht een stuk tekst moet bevatten dat eruit ziet als "ref: 1234", omdat je wilt dat iedere commit gekoppeld is aan een werkonderdeel in je ticket systeem. Je moet dus kijken naar iedere commit die gepusht wordt, zien of die tekst in de commit boodschap zit en als de tekst in één van de commits ontbreekt, met niet nul eindigen zodat de push geweigerd wordt.

Je kunt de lijst met alle SHA-1 waarden van alle commits die gepusht worden verkrijgen door de `$newrev` en `$oldrev` waarden te pakken en ze aan een Git plumbing commando genaamd `git rev-list` te geven. Dit is min of meer het `git log` commando, maar standaard voert het alleen de SHA-1 waarden uit en geen andere informatie. Dus, om een lijst te krijgen van alle commit SHA's die worden geïntroduceerd tussen één commit SHA en een andere, kun je zoiets als dit uitvoeren:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Je kunt die uitvoer pakken, door elk van die commit SHA's heen lopen, de boodschap daarvan pakken en die boodschap testen tegen een reguliere expressie die op een bepaald patroon zoekt.

Je moet uit zien te vinden hoe je de commit boodschap kunt krijgen van alle te testen commits. Om de echte commit gegevens te krijgen, kun je een andere plumbing commando genaamd `git cat-file` gebruiken. Ik zal al plumbing commando's in detail behandelen in Hoofdstuk 9, maar voor nu is dit wat het commando je geeft:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Een simpele manier om de commit boodschap uit een commit waarvan je de SHA-1 waarde hebt te krijgen, is naar de eerste lege regel gaan en alles wat daarna komt pakken. Je kunt dat doen met het `sed` commando op Unix systemen:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

Je kunt die toverspreuk gebruiken om de commit boodschap te pakken van iedere commit die geprobeerd wordt te pushen en eindigen als je ziet dat er iets is wat niet past. Om het script te eindigen en de push te weigeren, eindig je met niet nul. De hele methode ziet er zo uit:

	$regex = /\[ref: (\d+)\]/

	# eigen commit bericht formaat afgedwongen
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

Door dat in je `update` script te stoppen, zullen updates geweigerd worden die commits bevatten met berichten die niet aan jouw beleid voldoen.

#### Een gebruiker-gebaseerd ACL systeem afdwingen ####

Stel dat je een mechanisme wil toevoegen dat gebruik maakt van een toegangscontrole lijst (ACL) die specificeert welke gebruikers zijn toegestaan om wijzigingen te pushen naar bepaalde delen van je project. Sommige mensen hebben volledige toegang, en anderen hebben alleen toestemming om wijzigingen te pushen naar bepaalde subdirectories of specifieke bestanden. Om dit af te dwingen zul je die regels schrijven in een bestand genaamd `acl` dat in je bare Git repository op de server zit. Je zult de `update` hook naar die regels laten kijken, zien welke bestanden worden geïntroduceerd voor elke commit die gepusht wordt en bepalen of de gebruiker die de push doet toestemming heeft om al die bestanden te wijzigen.

Het eerste dat je zult doen is de ACL schrijven. Hier zul je een formaat gebruiken wat erg lijkt op het CVS ACL mechanisme: het gebruikt een serie regels, waarbij het eerste veld `avail` of `unavail` is, het volgende veld een komma gescheiden lijst van de gebruikers is waarvoor de regel geldt en het laatste veld het pad is waarvoor deze regel geldt (leeg betekent open toegang). Alle velden worden gescheiden door een pipe (`|`) karakter.

In dit geval heb je een aantal beheerders, een aantal documentatie schrijvers met toegang tot de `doc` map, en één ontwikkelaar die alleen toegang heeft tot de `lib` en `test` mappen, en je ACL bestand ziet er zo uit:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

Je begint met deze gegevens in een structuur in te lezen die je kunt gebruiken. In dit geval, om het voorbeeld eenvoudig te houden, zul je alleen de `avail` richtlijnen handhaven. Hier is een methode die je een associatieve array teruggeeft, waarbij de sleutel de gebruikersnaam is en de waarde een array van paden waar die gebruiker toegang tot heeft:

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

Gegeven het ACL bestand dat je eerder bekeken hebt, zal deze `get_acl_access_data` methode een gegevensstructuur opleveren die er als volgt uit ziet:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Nu je de rechten bepaald hebt, moet je bepalen welke paden de commits die gepusht worden hebben aangepast, zodat je kunt controleren dat de gebruiker die de push doet daar ook toegang tot heeft.

Je kunt eenvoudig zien welke bestanden gewijzigd zijn in een enkele commit met de `--name-only` optie op het `git log` commando (kort besproken in Hoofdstuk 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

Als je gebruik maakt van de ACL structuur die wordt teruggegeven door de `get_acl_access_data` methode en dat gebruikt met de bestanden in elk van de commits, dan kun je bepalen of de gebruiker toegang heeft om al hun commits te pushen:

	# staat alleen bepaalde gebruikers toe om bepaalde subdirectories in een project te wijzigen
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # kijk of iemand iets probeert te pushen waar ze niet bij mogen komen
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path || # gebruiker heeft overal toegang tot
	          (path.index(access_path) == 0) # toegang tot dit pad
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

Het meeste hiervan zou makkelijk te volgen moeten zijn. Je krijgt een lijst met commits die gepusht worden naar je server met `git rev-list`. Daarna vind je, voor iedere commit, de bestanden die aangepast worden en stelt vast of de gebruiker die pusht toegang heeft tot alle paden die worden aangepast. Een Ruby-isme dat wellicht niet duidelijk is, is `path.index(access_path) == 0`, wat waar is als het pad begint met `access_path` – dit zorgt ervoor dat `access_path` niet slechts in één van de toegestane paden zit, maar dat het voorkomt in alle toegestane paden.

Nu kunnen je gebruikers geen commits pushen met slecht vormgegeven berichten of met aangepaste bestanden buiten hun toegewezen paden.

#### Fast-forward-only pushes afdwingen ####

Het laatste om af te dwingen is fast-forward-only pushes. Om dit te regelen, kan je simpelweg de `receive.denyDeletes` en `receive.denyNonFastForwards` instellingen aanpassen. Maar dit afdwingen met behulp van een hook werkt ook, en je kunt het aanpassen zodat het alleen gebeurt bij bepaalde gebruikers of om elke reden die je later bedenkt.

De logica om dit te controleren, is te kijken of er een commit is die bereikbaar is vanuit de oudere revisie, maar niet bereikbaar is vanuit de nieuwere. Als er geen zijn dan was het een fast-forward push, anders weiger je het:

	# dwingt fast-forward-only pushes af
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

Alles is ingesteld. Als je `chmod u+x .git/hooks/update` uitvoert, wat het bestand is waarin je al deze code gestopt hebt, en dan probeert een non-fast-forwarded referentie te pushen krijg je zoiets als dit:


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

Er zijn hier een aantal interessante dingen. Ten eerste, zie je dit als de hook start met uitvoeren.

	Enforcing Policies...
	(refs/heads/master) (fb8c72) (c56860)

Merk op dat je dat afgedrukt hebt naar stdout aan het begin van je update script. Het is belangrijk om te zien dat alles dat je script naar stdout uitvoert, naar de client overgebracht wordt.

Het volgende dat je op zal vallen is de foutmelding.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

De eerste regel was door jou afgedrukt, de andere twee komen van Git die je vertelt dat het update script met niet nul geëindigd is en dat die degene is die je push weigerde. Tot slot heb je dit:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Je zult een remote afwijs bericht zien voor elke referentie die door de hook wordt geweigerd, en het vertelt je dat het specifiek was geweigerd wegens een hook fout.

Daarnaast zal je een foutmelding zien als in één van je commits de referentie markering ontbreekt.

	[POLICY] Your message is not formatted correctly

Of als iemand een bestand probeert aan te passen waar ze geen toegang tot hebben en een commit proberen te pushen waar het in zit, dan zullen ze iets vergelijkbaars zien. Bijvoorbeeld, als een documentatie schrijver een commit probeert te pushen dat iets wijzigt dat in de `lib` map zit, dan zien ze

	[POLICY] You do not have access to push to lib/test.rb

Dat is alles. Vanaf nu, zolang als het `update` script aanwezig en uitvoerbaar is, zal je repository nooit teruggedraaid worden en zal nooit een commit bericht bevatten waar het patroon niet in zit, en je gebruikers zullen in hun bewegingsruimte beperkt zijn.

### Hooks aan de client-kant ###

Het nadeel van deze aanpak is het zeuren dat geheid zal beginnen zodra de commits van je gebruikers geweigerd worden. Het feit dat hun zorgzaam vervaardigde werk op het laatste moment pas geweigerd wordt kan enorm frustrerend en verwarrend zijn en daarnaast zullen ze hun geschiedenis moeten aanpassen om het te corrigeren, wat niet altijd geschikt is voor de wat zwakkeren van hart.

Het antwoord op dit dilemma is een aantal client-kant hooks te leveren, die gebruikers kunnen gebruiken om hen te waarschuwen dat ze iets doen dat de server waarschijnlijk gaat weigeren. Op die manier kunnen ze alle problemen corrigeren voordat ze gaan committen en voordat die problemen lastiger te herstellen zijn. Omdat haken niet overgebracht worden bij het klonen van een project, moet je deze scripts op een andere manier distribueren en je gebruikers ze in hun `.git/hooks` map laten zetten en ze uitvoerbaar maken. Je kunt deze hooks in je project of in een apart project distribueren, maar er is geen manier om ze automatisch in te laten stellen.

Om te beginnen zou je de commit boodschap moeten controleren vlak voordat iedere commit opgeslagen wordt, zodat je weet dat de server je wijzigingen niet gaat weigeren omdat de commit boodschap een verkeerd formaat heeft. Om dit te doen, kun je de `commit-msg` hook toevoegen. Als je dat de commit boodschap laat lezen uit het bestand dat als eerste argument opgegeven wordt, en dat vergelijkt met het patroon dan kun je Git dwingen om de commit af te breken als het niet juist is:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

Als dat script op z'n plaats staat (in `.git/hooks/commit-msg`), uitvoerbaar is en je commit met een verkeerd geformateerd bericht, dan zie je dit:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

In dat geval is er geen commit gedaan. Maar als je bericht het juiste patroon bevat, dan staat Git je toe te committen:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Vervolgens wil je er zeker van zijn dat je geen bestanden buiten je ACL scope aanpast. Als de `.git` directory van je project een kopie van het ACL bestand bevat dat je eerder gebruikte, dan zal het volgende `pre-commit` script die beperkingen voor je controleren:

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

Dit is grofweg hetzelfde script als aan de server kant, maar met twee belangrijke verschillen. Als eerste staat het ACL bestand op een andere plek, omdat dit script vanuit je werkdirectory draait, en niet vanuit je Git directory. Je moet het pad naar het ACL bestand wijzigen van dit

	access = get_acl_access_data('acl')

naar dit:

	access = get_acl_access_data('.git/acl')

Het andere belangrijke verschil is de manier waarop je een lijst krijgt met bestanden die gewijzigd is. Omdat de server kant methode naar de log van commits kijkt en nu je commit nog niet opgeslagen is, moet je de bestandslijst in plaats daarvan uit het staging area halen. In plaats van

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

moet je dit gebruiken

	files_modified = `git diff-index --cached --name-only HEAD`

Maar dat zijn de enige twee verschillen - verder werkt het script op dezelfde manier. Een aandachtspunt is dat het van je verlangt dat je lokaal werkt als dezelfde gebruiker die pusht naar de remote machine. Als dat anders is, moet je de `$user` variabele handmatig instellen.

Het laatste wat je moet doen is het controleren dat je niet probeert non-fast-forward referenties te pushen, maar dat komt minder voor. Om een referentie te krijgen dat non-fast-forward is, moet je voorbij een commit rebasen die je al gepusht hebt, of een andere lokale branch naar dezelfde remote branch proberen te pushen.

Omdat de server je zal vertellen dat je geen non-fast-forward push kunt doen, en de hook de push tegenhoudt, is het enige ding wat je kunt proberen af te vangen het abusievelijk rebasen van commits die je al gepusht hebt.

Hier is een voorbeeld pre-rebase script dat daarop controleert. Het haalt een lijst met alle commits die je op het punt staat te herschrijven, en controleert of ze al ergens bestaan in één van je remote referenties. Als het er een ziet die bereikbaar is vanuit een van je remote referenties, dan stopt het de rebase:

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

Dit script gebruikt een syntax dat niet behandeld is in de Revisie Selectie paragraaf van Hoofdstuk 6. Je krijgt een lijst van commits die al gepusht zijn door dit uit te voeren:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

De `SHA^@` syntax wordt vervangen door alle ouders van die commit. Je bent op zoek naar een commit die bereikbaar is vanuit de laatste commit op de remote en die niet bereikbaar is vanuit enige ouder van alle SHA's die je probeert te pushen – wat betekent dat het een fast-forward is.

Het grote nadeel van deze aanpak is dat het erg traag kan zijn en vaak onnodig is, als je de push niet probeert te forceren met de `-f` optie, dan zal de server je al waarschuwen en de push niet accepteren. Maar, het is een aardige oefening en kan je in theorie helpen om een rebase te voorkomen die je later zult moeten herstellen.

## Samenvatting ##

We hebben nu de meeste manieren behandeld waarin je jouw Git client en server aan kunt passen om aan jouw workflow en projecten te voldoen. Je hebt allerhande configuratie instellingen geleerd, bestands-gebaseerde attributen, en gebeurtenis hooks (event hooks) en je hebt een voorbeeld gemaakt van een server die beleid afdwingt. Je zou nu in staat moeten zijn om Git binnen iedere workflow die je kunt verzinnen te laten werken.
