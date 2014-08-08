# Individuální přizpůsobení systému Git #

Do této chvíle jsem se věnoval základům práce v systému Git a tomu, jak systém používat. Představil jsem několik nástrojů, které Git nabízí pro usnadnění a zefektivnění práce. V této kapitole nastíním některé operace, jimiž lze Git přizpůsobit individuálním potřebám každého uživatele. Ukážeme si několik důležitých konfiguračních nastavení a systém zásuvných modulů. Pomocí těchto nástrojů lze systém Git snadno nastavit přesně tak, jak potřebujete vy, vaše společnost nebo vaše skupina.

## Konfigurace systému Git ##

Jak jsme v krátkosti ukázali v kapitole 1, příkazem `git config` lze specifikovat konfigurační nastavení systému Git. Jednou z prvních věcí, kterou jsme udělali, bylo nastavení nastavení jména a e-mailové adresy:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Nyní se podíváme na pár dalších zajímavých možností, jež můžete tímto způsobem nastavit, a přizpůsobit tak systém Git svým individuálním potřebám.

V první kapitole jste se seznámili s několika detaily konfigurace, ještě jednou bych se k nim ale rád v rychlosti vrátil. Git používá sérii konfiguračních souborů, v nichž lze nastavit odlišnosti od výchozí konfigurace. Prvním místem, kde Git tyto hodnoty vyhledává, je soubor `/etc/gitconfig`, obsahující hodnoty pro každého uživatele v systému a všechny jejich repozitáře. Zadáte-li parametr `--system` do nástroje `git config`, bude Git načítat a zapisovat pouze do tohoto souboru.

Dalším místem, kde Git vyhledává, je soubor `~/.gitconfig`, který je specifický pro každého uživatele. Git bude načítat a zapisovat výhradně do tohoto souboru, jestliže zadáte parametr `--global`.

Nakonec vyhledává Git konfigurační hodnoty v konfiguračním souboru v adresáři Git (`.git/config`) v právě používaném repozitáři. Tyto hodnoty platí pouze pro tento konkrétní repozitář. Každá další úroveň přepisuje hodnoty z předchozí úrovně, a tak např. hodnoty v souboru `.git/config` mají přednost před hodnotami v souboru `/etc/gitconfig`. Tyto hodnoty můžete nastavit také ruční editací souboru a vložením příslušné syntaxe, většinou je však snazší spustit příkaz `git config`.

### Základní konfigurace klienta ###

Parametry konfigurace systému Git se dělí do dvou kategorií: strana klienta a strana serveru. Většina parametrů připadá na stranu klienta, neboť se jedná o konfiguraci osobního pracovního nastavení. Přestože parametrů je velmi mnoho, já se zaměřím jen na ty, které se využívají často nebo které mouhou výrazně ovlivnit váš pracovní postup. Mnoho parametrů je využitelných pouze ve specifických případech, jimž se nebudu v této knize věnovat. Pokud vás zajímá seznam parametrů, které vaše verze systému Git rozeznává, můžete si nechat jejich seznam vypsat příkazem:

	$ git config --help

Manuálová stránka pro `git config` zobrazí seznam všech dostupných parametrů i s celou řadou podrobností.

#### core.editor ####

Git používá k vytváření a editaci zpráv k revizím a značkám standardně textový editor, který nastavíte jako výchozí, nebo použije editor Vi. Chcete-li změnit výchozí hodnotu, použijte nastavení `core.editor`:

	$ git config --global core.editor emacs

Nyní už nezáleží na tom, jaký editor máte v shellu nastaven jako výchozí, Git bude k editaci zpráv spouštět Emacs.

#### commit.template ####

Nastavíte-li tuto hodnotu na konkrétní umístění ve svém systému, Git použije tento soubor jako výchozí zprávu pro revize. Řekněme, například, že vytvoříte soubor šablony `$HOME/.gitmessage.txt`, který bude vypadat takto:

	řádek předmětu

	co bylo provedeno

	[tiket: X]

Chcete-li systému Git zadat, aby soubor používal jako výchozí zprávu, která se zobrazí v textovém editoru po spuštění příkazu `git commit`, nastavte konfigurační hodnotu `commit.template`:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

Při zapisování revize váš editor otevře následující šablonu zprávy k revizi:

	řádek předmětu

	co bylo provedeno

	[tiket: X]
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

Máte-li stanoveny standardy pro vytváření zpráv k revizím, může vám vytvoření šablony podle těchto standardů a nastavení systému Git na její používání pomoci k dodržování těchto standardů.

#### core.pager ####

Nastavení core.pager určuje, jaký stránkovač bude použit, musí-li Git rozdělit výpis na stránky (např. výstup příkazu `log` nebo `diff`). Můžete jej nastavit na `more` nebo na nějaký jiný oblíbený (výchozím stránkovačem je `less`). Můžete jej také vypnout zadáním prázdného řetězce:

	$ git config --global core.pager ''

Spustíte-li tento příkaz, Git nebude stránkovat celý výstup všech příkazů, bez ohledu na to, jak jsou dlouhé.

#### user.signingkey ####

Vytváříte-li podepsané anotované značky (jak je popsáno v kapitole 2), celou věc vám usnadní nastavení GPG podpisového klíče v konfiguraci. ID svého klíče nastavíte takto:

	$ git config --global user.signingkey <gpg-key-id>

Nyní můžete podepisovat značky, aniž byste museli pokaždé znovu zadávat svůj klíč příkazem `git tag`:

	$ git tag -s <tag-name>

#### core.excludesfile ####

Do souboru `.gitignore` ve svém projektu můžete vložit masky souborů, které Git neuvidí jakožto nesledované soubory ani se je nepokusí připravit k zapsání, až na ně spustíte příkaz `git add`, jak jsme popisovali v kapitole 2. Pokud však chcete, aby tyto hodnoty obsahoval jiný soubor mimo projekt, nebo chcete určit dodatečné hodnoty, parametrem `core.excludesfile` můžete systému Git sdělit, kde má tento soubor hledat. Jednoduše nastavte cestu k souboru s obsahem podobným souboru `.gitignore`.

#### help.autocorrect ####

Tato možnost je dostupná ve verzi systému Git 1.6.1 a novějších. Pokud ve verzi 1.6 uděláte překlep v příkazu, zobrazí se asi toto:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Nastavíte-li parametr `help.autocorrect` na hodnotu 1, Git automaticky spustí příkaz, který by v tomto dialogu vypsal, najde-li právě jediný takový.

### Barvy systému Git ###

Git může výstup na vašem terminálu barevně zvýraznit a pomoci vám tak snadno a rychle se ve výpisu zorientovat. S individuálním nastavením barev vám pomůže celá řada možností.

#### color.ui ####

Git na přání automaticky barevně zvýrazňuje většinu svých výstupů. Lze přitom velmi podrobně určit, co chcete barevně označit a jak. Chcete-li zapnout výchozí barvy terminálu, nastavte parametr `color.ui` na hodnotu true:

	$ git config --global color.ui true

Je-li tato hodnota nastavena, Git barevně zvýrazní výstup přicházející na terminál. Dalšími možnostmi nastavení jsou false, které výstup nevybarví nikdy, a always, které použije barvy pokaždé, a to i když jste přesměrovali příkazy Git do souboru nebo k jinému příkazu. Toto nastavení bylo přidáno ve verzi systému Git 1.5.5. Máte-li starší verzi, budete muset zadat veškerá barevná nastavení individuálně.

Možnost `color.ui = always` využijete zřídka. Chcete-li použít barevné kódy v přesměrovaném výstupu, můžete většinou místo toho přidat k příkazu Git příznak `--color`. Po jeho zadání příkaz použije barevné kódy. Téměř vždy vystačíte s příkazem `color.ui = true`.

#### `color.*` ####

Pokud byste rádi nastavili přesněji jak budou zvýrazněny různé příkazy nebo máte starší verzi, nabízí Git nastavení barev pro jednotlivé příkazy. Každý z příslušných parametrů může nabývat hodnoty na `true` (pravda), `false` (nepravda) nebo `always` (vždy):

	color.branch
	color.diff
	color.interactive
	color.status

Chcete-li sami nastavit jednotlivé barvy, mají všechny tyto parametry navíc dílčí nastavení, které můžete použít k určení konkrétních barev pro jednotlivé části výstupu. Budete-li chtít nastavit například meta informace ve výpisu příkazu diff tak, aby měly modré popředí, černé pozadí a tučné písmo, můžete použít příkaz:

	$ git config --global color.diff.meta "blue black bold"

U barev lze zadávat tyto hodnoty: `normal` (normální), `black` (černá), `red` (červená), `green` (zelená), `yellow` (žlutá), `blue` (modrá), `magenta` (purpurová), `cyan` (azurová) nebo `white` (bílá). Pokud chcete použít atribut, jakým bylo v předchozím příkladu například tučné písmo, můžete vybírat mezi `bold` (tučné), `dim` (tlumené), `ul` (podtržené), `blink` (blikající) a `reverse` (obrácené).

Chcete-li použít dílčí nastavení, podrobnější informace naleznete na manuálové stránce `git config`.

### Externí nástroje pro diff a slučování ###

Ačkoli Git disponuje vlastním nástrojem diff, který jste dosud používali, můžete místo něj nastavit i libovolný externí nástroj. Stejně tak můžete nastavit vlastní grafický nástroj k řešení konfliktů při slučování, nechcete-li řešit konflikty ručně. Já na tomto místě ukážu, jak nastavit Perforce Visual Merge Tool (P4Merge), protože se jedná o příjemný grafický nástroj pro řešení konfliktů a práci s výstupy nástroje diff. P4Merge je navíc dostupný zdarma.

Pokud ho chcete vyzkoušet, nemělo by vám v tom nic bránit, P4Merge funguje na všech hlavních platformách. V příkladech budu používat označení cest platné pro systémy Mac a Linux; pro systémy Windows budete muset cestu `/usr/local/bin` nahradit cestou ke spustitelnému souboru ve vašem prostředí.

P4Merge můžete stáhnout na této adrese:

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

Pro začátek je třeba nastavit kvůli spouštění příkazů externí skripty wrapperu. Jako cestu ke spustitelnému souboru používám cestu v systému Mac. V ostatních systémech použijte cestu k umístění, kde máte nainstalován binární soubor `p4merge`. Nastavte wrapperový skript pro slučování `extMerge`, který bude volat binární soubor všemi dostupnými parametry:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

Wrapper nástroje diff zkontroluje zda je skutečně zadáno sedm parametrů a předá dva z nich do skriptu pro slučování. Standardně Git předává do nástoje diff tyto parametry:

	path old-file old-hex old-mode new-file new-hex new-mode

Protože chcete pouze parametry `old-file` a `new-file`, použijete wrapperový skript k zadání těch, které potřebujete.

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Dále se potřebujete také ujistit, že lze tyto nástroje spustit:

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

Nyní můžete nastavit konfigurační soubor k používání vlastních nástrojů diff a nástrojů k řešení slučování. S tím souvisí celá řada uživatelských nastavení: `merge.tool`, jímž systému Git sdělíte, kterou strategii slučování má používat, `mergetool.*.cmd`, jímž určíte, jak příkaz spustit, `mergetool.trustExitCode`, který systému Git sdělí, zda návratový kód tohoto programu oznamuje, nebo neoznamuje úspěšné vyřešení sloučení, a `diff.external`, který systému Git říká, jakým příkazem se zjišťují rozdíly. Můžete tedy spustit kterýkoli ze čtyř konfiguračních příkazů:

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

nebo můžete upravit soubor `~/.gitconfig` a vložit následující řádky:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	  trustExitCode = false
	[diff]
	  external = extDiff

Až dokončíte celé nastavení, můžete spustit příkaz diff, např.:

	$ git diff 32d1776b1^ 32d1776b1

Výstup příkazu diff se nezobrazí na příkazovém řádku, ale Git spustí program P4Merge v podobě, jak je zachycen na obrázku 7-1.

Insert 18333fig0701.png
Obrázek 7-1. P4Merge

Jestliže se pokusíte sloučit dvě větve a dojde při tom ke konfliktu, můžete spustit příkaz `git mergetool`. Příkaz spustí program P4Merge, v němž budete moci v grafickém uživatelském rozhraní konflikt vyřešit.

Příjemné na tomto wrapperovém nastavení je, že lze snadno změnit nástroj diff i nástroj pro slučování. Chcete-li například změnit nástroje `extDiff` a `extMerge`, aby se místo nich spouštěl nástroj KDiff3, jediné, co musíte udělat, je upravit soubor `extMerge`:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

Git bude nyní k zobrazení výstupů nástoje diff a k řešení konfliktů při slučování používat nástroj KDiff3.

Git je standardně přednastaven tak, aby dokázal používat celou řadu různých nástrojů k řešení konfliktů při slučování, aniž byste museli nastavovat konfiguraci příkazu. Jako nástroj slučování můžete nastavit kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff nebo gvimdiff. Pokud nestojíte o to, aby systém Git používal nástroj KDiff3 pro nástroj diff, ale používal ho jen k řešení konfliktů při slučování, a příkaz kdiff3 je ve vašem umístění, spusťte příkaz:

	$ git config --global merge.tool kdiff3

Pokud spustíte tento příkaz místo nastavení souborů `extMerge` a `extDiff`, Git bude používat KDiff3 k řešení konfliktů při slučování a interní nástroj diff systému Git pro výpisy nástroje diff.

### Formátování a prázdné znaky ###

Chyby způsobené formátováním a prázdnými znaky jsou jedny z nejtitěrnějších a nejotravnějších problémů, s nimiž se vývojáři potýkají při vzájemné spolupráci, zvláště mezi různými platformami. U záplat nebo jiné společné práce dochází u prázdných znaků velmi snadno k nepatrným změnám, které v tichosti vytvářejí editory nebo programátoři pracující ve Windows, jež vkládají v projektech z jiných platforem na konce řádků znak pro návrat vozíku (CR, http://cs.wikipedia.org/wiki/Carriage_return). Git disponuje několika konfiguračními parametry, které vám pomohou tyto problémy vyřešit.

#### core.autocrlf ####

Pokud programujete v OS Windows nebo používáte jiný systém, ale spolupracujete s lidmi, kteří ve Windows programují, pravděpodobně se jednou budete potýkat s problémy způsobené konci řádků. Windows ve svých souborech používá pro nové řádky jak znak pro návrat vozíku (carriage return), tak znak pro posun o řádek (linefeed), zatímco systémy Mac a Linux používají pouze znak posun o řádek. Je to sice malý, ale neuvěřitelně obtěžující průvodní jev spolupráce mezi různými platformami.

Git může tento problém vyřešit automatickou konverzí konců řádků CRLF na konce LF, jestliže zapisujete revizi, nebo obráceně, jestliže provádíte checkout zdrojového kódu do svého systému souborů. Tato funkce se zapíná pomocí parametru `core.autocrlf`. Pracujete-li v systému Windows, nastavte hodnotu `true` – při checkoutu zdrojového kódu tím konvertujete konce řádků LF na CRLF:

	$ git config --global core.autocrlf true

Jestliže pracujete v systému Linux nebo Mac, který používá konce řádků LF, nebudete chtít, aby Git při checkoutu souborů automaticky konvertoval konce řádků. Pokud se však náhodou vyskytne soubor s konci řádků CRLF, budete chtít, aby Git tento problém vyřešil. Systému Git tak můžete zadat, aby při zapisování souborů konvertoval znaky CRLF na LF, avšak nikoli obráceně. Nastavte možnost `core.autocrlf` na hodnotu input:

	$ git config --global core.autocrlf input

Toto nastavení by vám mělo pomoci zachovat zakončení CRLF při checkoutu v systému Windows a zakončení LF v systémech Mac a Linux a v repozitářích.

Pokud programujete ve Windows a vytváříte projekt pouze pro Windows, můžete tuto funkci vypnout. Nastavíte-li hodnotu konfigurace na `false`, v repozitáři se budou zaznamenávat i návraty vozíku.

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git je standardně nastaven na vyhledávání a opravu chyb způsobených prázdnými znaky. Může vyhledávat čtyři základní chyby tohoto typu – dvě funkce jsou ve výchozím nastavení zapnuty a lze je vypnout, dvě nejsou zapnuty, avšak lze je aktivovat.

Funkce, které jsou standardně zapnuté, jsou `trailing-space`, která vyhledává mezery na koncích řádků, a `space-before-tab`, která vyhledává mezery před tabulátory na začátcích řádků.

Funkce, které jsou standardně vypnuté, ale lze je zapnout, jsou `indent-with-non-tab`, která vyhledává řádky začínající osmi nebo více mezerami místo tabulátoru, a `cr-at-eol`, která systému Git sděluje, že návraty vozíku na koncích řádků jsou v pořádku.

Které z těchto funkcí si přejete zapnout a které vypnout, to můžete systému Git sdělit zadáním čárkami oddělených hodnot do parametru `core.whitespace`. Funkci vypnete buď tím, že ji z řetězce nastavení zcela vynecháte, nebo tím, že před hodnotu vložíte znak `-`. Chcete-li například zapnout všechny funkce kromě `cr-at-eol`, zadejte příkaz v tomto tvaru:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Až spustíte příkaz `git diff`, Git se pokusí tyto problémy vyhledat a barevně označit, abyste je mohli případně ještě před zapsáním revize opravit. Git se těmito hodnotami řídí také při aplikaci záplat příkazem `git apply`. Jestliže aplikujete záplaty, můžete Git požádat, aby vás varoval, pokud je aplikována záplata s některým ze specifikovaných problémů:

	$ git apply --whitespace=warn <patch>

Git se může také pokusit automaticky daný problém vyřešit, ještě než bude záplata aplikována:

	$ git apply --whitespace=fix <patch>

A toto nastavení platí také pro příkaz `git rebase`. Pokud jste zapsali revize s chybami způsobenými prázdnými znaky, ale zatím jste je neodeslali na server, můžete spustit příkaz `rebase` s parametrem `--whitespace=fix`. Git automaticky opraví tyto chyby přepsáním záplat.

### Konfigurace serveru ###

Na straně serveru není ani zdaleka tolik parametrů konfigurace jako na straně klienta, avšak několik zajímavých si jistě zaslouží vaši pozornost.

#### receive.fsckObjects ####

Git ve výchozím nastavení nekontroluje konzistenci všech objektů, které přijímá při odesílání dat. Ačkoli může při každém odesílání ověřit, že všechny objekty stále souhlasí se svým kontrolním součtem SHA-1 a ukazují k platným objektům, standardně to nedělá. Jedná se o poměrně náročnou operaci, která může každé odesílání výrazně zpomalit. Závisí přitom na velikosti repozitáře nebo odesílaných dat. Pokud chcete, aby Git kontroloval konzistenci objektů při každém odeslání dat, můžete mu to zadat nastavením možnosti `receive.fsckObjects` na hodnotu true:

	$ git config --system receive.fsckObjects true

Git nyní bude kontrolovat integritu vašeho repozitáře před přijetím odeslaných souborů, aby zajistil, že defektní klienti nedodávají data s chybami.

#### receive.denyNonFastForwards ####

Pokud přeskládáte revize, které jste již odeslali, a poté se je pokusíte odeslat ještě jednou nebo pokud se pokusíte odeslat revizi do vzdálené větve, která neobsahuje revizi, na niž právě vzdálená větev ukazuje, bude váš požadavek zamítnut. Toto jsou většinou užitečná pravidla. V případě přeskládání však můžete oznámit, že víte, co děláte, a příznakem `-f` v kombinaci s příkazem push můžete donutit vzdálenou větev k aktualizaci.

Chcete-li vypnout možnost násilné aktualizace vzdálených větví na jiné reference než „rychle vpřed“, zadejte `receive.denyNonFastForwards`:

	$ git config --system receive.denyNonFastForwards true

Druhou možností, jak to provést, jsou přijímací zásuvné moduly (receive hooks) na straně serveru, jimž se budu věnovat později. Tato metoda umožňuje pokročilejší nastavení, jako zamítnutí jiných aktualizací než „rychle vpřed“ určité skupině uživatelů.

#### receive.denyDeletes ####

Jednou z možností, jak může uživatel obejít pravidlo `denyNonFastForwards`, je odstranit větev a odeslat ji zpět s novou referencí. V novějších verzích systému Git (počínaje verzí 1.6.1) lze nastavit možnost `receive.denyDeletes` na hodnotu true:

	$ git config --system receive.denyDeletes true

Paušálně tím zamezíte možnému smazání větve a značek při odesílání, žádný z uživatelů je nebude moci odstranit. Budete-li chtít odstranit vzdálenou větev, budete muset ručně smazat referenční soubory ze serveru. A jak uvidíte na konci kapitoly, existují ještě další zajímavé způsoby, jak provést stejné nastavení na bázi jednotlivých uživatelů prostřednictvím ACL.

## Atributy Git ##

Některá z těchto nastavení lze také provést pouze pro určité umístění, a Git je tak aplikuje pouze na jeden podadresář nebo skupinu souborů. Tomuto nastavení konkrétního umístění se říká atributy Git. Nastavují se buď v souboru `.gitattributes` v jednom z vašich adresářů (většinou kořenový adresář vašeho projektu), nebo v souboru `.git/info/attributes`, pokud nechcete, aby byl soubor s atributy zapsán spolu s projektem.

Pomocí atributů lze například určit odlišnou strategii slučování pro konkrétní soubory nebo adresáře projektu, zadat systému Git nástroj diff pro netextové soubory nebo jak filtrovat obsah před načtením dat do systému Git nebo jejich odesláním. V této části se podíváme na některé atributy, jež můžete pro různá umístění v projektu Git nastavit, a uvedeme pár příkladů, jak lze tuto funkci využít v praxi.

### Binární soubory ###

Jedním ze skvělých triků, který vás možná přesvědčí o užitečnosti atributů, je označení souborů jako binárních (v případech, kdy je Git není schopen identifikovat sám) a zadání speciálních instrukcí, jak s těmito soubory nakládat. Některé textové soubory mohou být například vygenerovány strojově a nelze na ně aplikovat nástroj diff, zatímco na jiné binární soubory lze. Ukážeme si, jak systému Git sdělit, které jsou které.

#### Identifikace binárních souborů ####

Některé soubory se tváří jako textové, ale v podstatě je s nimi třeba zacházet jako s binárními daty. Například projekty Xcode v systémech Mac obsahují soubory končící na `.pbxproj`, což je v podstatě sada dat JSON (datový formát prostého textu javascript) zapsaná na disk nástrojem IDE, který zaznamenává vaše nastavení atd. Ačkoli se technicky jedná o textový soubor, který je celý tvořen znaky ASCII, nechcete s ním nakládat jako s textovým souborem, protože se ve skutečnosti jedná o neohrabanou databázi. Pokud ji dva lidé změní, její obsah nemůžete sloučit a většinou nepochodíte ani s nástroji diff. Soubor je určen ke strojovému zpracování. Z těchto důvodů s ním budete chtít zacházet jako s binárním souborem.

Chcete-li systému Git zadat, aby nakládal se všemi soubory `pbxproj` jako s binárními daty, vložte do souboru `.gitattributes` následující řádek:

	*.pbxproj -crlf -diff

Až v projektu spustíte příkaz `git show` nebo `git diff`, Git se nebude pokoušet konvertovat nebo opravovat chyby CRLF ani vypočítat ani zobrazit rozdíly v tomto souboru pomocí nástroje diff. Můžete také použít zabudované makro `binary` s významem `-crlf -diff`:

	*.pbxproj binary

#### Nástroj diff pro binární soubory ####

V systému Git můžete zadáním vhodných parametrů efektivně porovnávat binární soubory. Dosáhnete toho tím, že systému Git sdělíte, jak má konvertovat binární data do textového formátu, který lze zpracovávat běžným algoritmem pro zjišťování rozdílů (diff). Ale otázkou je, jak byste měli konverzi *binárních* dat na text provést? Nejlepší by bylo, kdybyste našli nějaký nástroj, který vám binární tvar na textový převede. Naneštěstí existuje jen velmi málo binárních formátů, které lze převést na lidsky čitelný text. (Představte si, jak byste na text převáděli zvuková data.) Pokud takový případ nastal a nejste schopni textovou reprezentaci obsahu souboru získat, lze často poměrně snadno získat lidsky čitelný popis obsahu, metadata. Metadata vám sice neposkytnou plnou reprezentaci obsahu souboru, ale v každém případě je to lepší než nic.

Oba popsané přístupy k získání použitelných informací o rozdílech si ukážeme na některých běžně používaných binárních formátech.

Poznámka: Existují různé druhy binárních formátů, které obsahují text, a pro které se dají obtížně najít použitelné konvertory. V takovém případě můžete zkusit získat z vašeho souboru texty programem `strings`. Některé z těchto souborů ale mohou používat kódování UTF-16 nebo jiné kódování a `strings` v nich nic rozumného nenajde. Je to případ od případu. Nicméně program `strings` je k dispozici na většině operačních systémů Mac a Linux, takže může jít o dobrou první volbu při pokusech s celou řadou binárních souborů.

#### Soubory MS Word ####

Tuto metodu budete využívat především k řešení jednoho z nejpalčivějších problémů, s nímž se lidstvo potýká: verzování dokumentů Word. Je všeobecně známo, že Word je nejpříšernější editor na světě, přesto ho však – bůhví proč – všichni používají. Chcete-li verzovat dokumenty Word, můžete je uložit do repozitáře Git a všechny hned zapsat do revize. K čemu to však bude? Spustíte-li příkaz `git diff` normálně, zobrazí se zhruba toto:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

Srovnávat dvě verze přímo nelze, můžete je tak nanejvýš otevřít a ručně je projít, že? Nezapomínejme však na atributy Git, v této situaci vám odvedou nanahraditelnou službu. Do souboru `.gitattributes` vložte následující řádek:

	*.doc diff=word

Systému Git tím sdělíte, že pro všechny soubory, které odpovídají této masce (.doc), by měl být při zobrazení rozdílů použít filter „word“. Co je to filtr „word“? To budete muset nastavit. V našem případě nastavíme Git tak, aby ke konverzi dokumentů Word do čitelných textových souborů, způsobilých ke zpracování nástrojem diff, používal program `catdoc`, který byl napsán přímo pro extrakci textu z binární podoby dokumentů MS Word (můžete jej získat z `http://www.wagner.pp.ru/~vitus/software/catdoc/`). Tím wordovské dokumenty převedeme na čitelné textové soubory, na které lze úspěšně aplikovat algoritmus pro zjišťování rozdílů (diff):

	$ git config diff.word.textconv catdoc

Tento příkaz do vašeho `.git/config` přidá sekci, která vypadá následovně:

	[diff "word"]
		textconv = catdoc

Git nyní ví, že až se bude pokoušet vypočítat rozdíl mezi dvěma snímky a každý ze souborů končící na `.doc` se má prohnat přes filtr „word“, který je definován jako program `catdoc`. Než se Git pokusí zjistit ve wordovských souborech rozdíly, dojde k jejich převedení na hezké textové verze.

Uveďme malý příklad. Kapitolu 1 této knihy jsem vložil do systému Git, do jednoho odstavce jsem přidal kousek textu a dokument jsem uložil. Poté jsem spustil příkaz `git diff`, abych se podíval, co se změnilo:

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

Git mi stroze, ale pravdivě sděluje, že jsem přidal řetězec „(See Chapter 3)“, což je správné. Funguje to perfektně!

##### OpenDocument Text files #####

Stejný postup, který jsme použili pro soubory MS Word (`*.doc`), můžeme použít i pro soubory ve formátu OpenDocument Text (`*.odt`), které vytváří OpenOffice.org.

Do souboru `.gitattributes` přidejte následující řádek:

	*.odt diff=odt

A teď v `.git/config` nastavte diff filtr pro `odt`:

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

OpenDocument soubory jsou ve skutečnosti zazipované adresáře, které obsahují více souborů (obsah ve formátu XML, styly, obrázky atd.). Potřebujeme napsat skript, který by extrahoval obsah a vrátil jej jako prostý text. Vytvořte soubor `/usr/local/bin/odt-to-txt` (můžete jej umístit i do jiného adresáře) s následujícím obsahem:

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

Učiňte jej spustitelným:

	chmod +x /usr/local/bin/odt-to-txt

Teď už bude `git diff` schopen říci, co se v `.odt` souborech změnilo.


#### Soubory s obrázky ####

Dalším zajímavým problémem, který lze tímto způsobem řešit, je výpočet rozdílů u obrázkových souborů. Jedním způsobem, jak to udělat, je spustit soubory JPEG přes filtr, který extrahuje jejich informace EXIF – metadata, která se zaznamenávají s většinou obrázkových souborů. Pokud stáhnete a nainstalujete program `exiftool`, můžete ho použít ke konverzi obrázků na text prostřednictvím metadat, a nástroj diff vám tak přinejmenším zobrazí textovou verzi všech provedených změn.

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Pokud nahradíte některý z obrázků ve svém projektu a spustíte příkaz `git diff`, zobrazí se asi toto:

	diff --git a/image.png b/image.png
	index 88839c4..4afcb7c 100644
	--- a/image.png
	+++ b/image.png
	@@ -1,12 +1,12 @@
	 ExifTool Version Number         : 7.74
	-File Size                       : 70 kB
	-File Modification Date/Time     : 2009:04:17 10:12:35-07:00
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

Jasně vidíte, že se změnila jak velikost souboru, tak rozměry obrázku.

### Rozšíření klíčového slova ###

Vývojáři, kteří jsou zvyklí na jiné systémy, mohou požadovat nahrazení klíčového slova pro SVN nebo CVS. Hlavním problémem v systému Git je, že nelze upravit soubor s informacemi o revizi poté, co jste revizi zapsali, protože Git nejprve provede kontrolní součet souboru. Můžete však vložit text do souboru po jeho checkoutu a opět ho odstranit, než bude přidán do revize. Atributy Git nabízejí dvě možnosti, jak to provést.

První možností je automaticky vložit kontrolní součet SHA-1 blobu do pole `$Id$` v souboru. Pokud tento atribut nastavíte pro soubor nebo sadu souborů, při příštím checkoutu této větve Git nahradí toto pole kontrolním součtem SHA-1 blobu. Je tedy důležité si uvědomit, že se nejedná o SHA revize, ale SHA samotného blobu:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

Při příštím checkoutu tohoto souboru Git vloží SHA blobu:

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Tento výsledek má však omezené použití. Pokud nahradíte klíčové slovo v systému CVS nebo Subversion, můžete přidat časový údaj (datestamp) – SHA tu není moc platné, protože je generováno náhodně a nelze podle něj určit, zda je jedna revize starší než jiná.

Jak zjistíte, můžete pro substituce v souborech určených k zapsání/checkoutu napsat i vlastní filtry. Jedná se o filtry clean a smudge. V souboru `.gitattributes` můžete určit filtr pro konkrétní umístění a nastavit skripty, jimiž budou zpracovány soubory těsně před jejich zapsáním („clean“ – viz obrázek 7-2) a těsně před checkoutem („smudge“ – viz obrázek 7-3). Tyto filtry lze nastavit k různým šikovným úkonům.

Insert 18333fig0702.png
Obrázek 7-2. Filtr smudge spuštěný při checkoutu – git checkout

Insert 18333fig0703.png
Obrázek 7-3. Filtr clean spuštěný při přípravě souborů k zapsání – git add

Původní zpráva k revizi s touto funkcí uvádí jednoduchý příklad, jak můžete před zapsáním prohnat veškeré vaše céčkové zdrojové texty programem `indent`. V souboru `.gitattributes` můžeme nastavit atribut `filter` tak, aby se soubory `*.c` zpracovaly filtrem `indent`:

	*.c     filter=indent

Poté řekněte systému Git, co má filter indent dělat v situacích smudge a clean:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

Pokud v tomto případě zapíšete soubory odpovídající masce `*.c`, Git je ještě před zapsáním prožene programem pro úpravu odsazování a poté, před checkoutem zpět na disk, i programem `cat`. Program `cat` ve své podstatě nic neudělá: jeho výstupem jsou stejná data, která tvořila vstup. Tato kombinace ještě před zapsáním účinně přefiltruje veškeré zdrojové soubory pro jazyk C přes program `indent`.

Další zajímavý příklad se týká rozšíření klíčového slova `$Date$` ve stylu RCS. Ke správnému postupu budete potřebovat malý skript, který vezme název souboru, zjistí datum poslední revize v tomto projektu a vloží datum do souboru. Tady je malý Ruby skript, který to umí:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Skript pouze získá datum nejnovější revize z příkazu `git log` a rozšíří jím řetezce `$Date$`, které nalezne v standardním vstupu (stdin), a vrátí výsledek – snadno by to mělo jít provést v jakémkoli jazyce, který používáte. Tento soubor můžete pojmenovat `expand_date` a vložit ho do svého umístění. Nyní budete muset nastavit filtr v systému Git (pojmenujte ho `dater`) a určit, aby k operaci smudge při checkoutu souborů používal filtr `expand_date`. Při operaci clean během zapsání pak budete používat výraz Perlu:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Tento fragment Perl vyjme vše, co najde v řetězci `$Date$`, čímž se vrátí zpět do stavu, kde jste začali. Nyní, když máte filtr hotový, můžete ho otestovat vytvořením souboru s klíčovým slovem `$Date$` a nastavením atributu Git pro tento soubor, jímž nový filtr aktivujete:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

Pokud tyto změny zapíšete a provedete nový checkout souboru, uvidíte, že bylo klíčové slovo správně substituováno:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Zde vidíte, jak může být tato metoda účinná pro uživatelsky nastavené aplikace. Přesto je na místě opatrnost. Soubor `.gitattributes` je zapisován a předáván spolu s projektem, avšak ovladač (v tomto případě je to `dater`) nikoli. Soubor tak nebude fungovat všude. Při navrhování těchto filtrů byste tedy měli myslet i na to, aby projekt pracoval správně, i když filtr selže.

### Export repozitáře ###

Data atributů Git umožňují rovněž některé zajímavé úkony při exportu archivů z vašeho projektu.

#### export-ignore ####

Systému Git můžete zadat, aby při generování archivu neexportoval určité soubory nebo adresáře. Obsahuje-li projekt podadresář nebo soubor, který nechcete zahrnout do souboru archivu, ale který chcete ponechat jako součást projektu, můžete tyto soubory specifikovat atributem `export-ignore`.

Řekněme například, že máte v podadresáři `test/` několik testovacích souborů, které by nemělo smysl zahrnovat do exportu tarballu vašeho projektu. Do souboru s atributy Git můžete přidat následující řádek:

	test/ export-ignore

Až nyní spustíte příkaz `git archive` k vytvoření tarballu projektu, nebude tento adresář součástí archivu.

#### export-subst ####

Další možností pro archivy je jednoduchá substituce klíčového slova. Git umožňuje vložit řetězec `$Format:$` do libovolného souboru s kterýmkoli ze zkrácených kódů formátování `--pretty=format`, z nichž jsme několik poznali v kapitole 2. Chcete-li do projektu zahrnout například soubor s názvem `LAST_COMMIT` a při spuštění příkazu `git archive` do něj bylo automaticky vloženo datum poslední revize, můžete nastavit tento soubor takto:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

Spustíte-li příkaz `git archive`, bude po otevření soubor archivu vypadat obsah tohoto souboru takto:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Strategie slučování ###

Atributy Git lze použít také k nastavení různých strategií slučování pro různé soubory v projektu. Velmi užitečnou možností je například nastavení, aby se Git nepokoušel sloučit konkrétní soubory, pokud u nich dojde ke konfliktu, a raději použil vaši verzi souboru než jinou.

Tuto možnost využijete, pokud se rozdělila nebo specializovala některá z větví vašeho projektu, avšak vy z ní budete chtít začlenit změny zpět a ignorovat přitom určité soubory. Řekněme, že máte soubor s nastavením databáze nazvaný database.xml, který se ve dvou větvích liší, a vy sem chcete začlenit jinou svoji větev, aniž byste tento soubor změnili. V tom případě můžete nastavit tento atribut:

	database.xml merge=ours

A potom nadefinujete prázdnou slučovací strategii `ours` příkazem:

    git config --global merge.ours.driver true

Pokud začleníte druhou větev, místo řešení konfliktů u souboru database.xml se zobrazí následující:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

V tomto případě zůstane soubor database.xml ve své původní podobě.

## Zásuvné moduly Git ##

Stejně jako jiné systémy správy verzí přistupuje i Git k tomu, že spouští uživatelské skripty, nastane-li určitá důležitá akce. Rozlišujeme dvě skupiny těchto zásuvných modulů (háčků, angl. hooks): na straně klienta a na straně serveru. Zásuvné moduly na straně klienta jsou určeny pro operace klienta, např. zapisování revizí či slučování. Zásuvné moduly na straně serveru se týkají operací serveru Git, např. přijímání odeslaných revizí. Zásuvné moduly se dají využívat k různým účelům. V krátkosti si tu některé z nich představíme.

### Instalace zásuvného modulu ###

Všechny zásuvné moduly jsou uloženy v podadresáři `hooks` adresáře Git. U většiny projektů to bude konkrétně `.git/hooks`. Git do tohoto adresáře standardně ukládá několik ukázkových skriptů, které jsou často užitečné nejen samy o sobě, ale navíc dokumentují vstupní hodnoty všech skriptů. Všechny zdejší příklady jsou napsány jako shellové skripty, tu a tam obsahující Perl, avšak všechny řádně pojmenované spustitelné skripty budou fungovat správně – můžete je napsat v Ruby, Pythonu nebo jiném jazyce. U verzí systému Git vyšších než 1.6 končí tyto soubory ukázkových zásuvných modulů na .sample, budete je muset přejmenovat. U verzí systému Git před 1.6 jsou tyto ukázkové soubory pojmenovány správně, ale nejsou spustitelné.

Chcete-li aktivovat skript zásuvného modulu, vložte správně pojmenovaný a spustitelný soubor do podadresáře `hooks` adresáře Git. Od tohoto okamžiku by měl být skript volán. V dalších částech se budeme věnovat většině nejvýznamnějších názvů souborů zásuvných modulů.

### Zásuvné moduly na straně klienta ###

Na straně klienta existuje mnoho zásuvných modulů. V této části je rozdělíme na zásuvné moduly k zapisování revizí, zásuvné moduly pro práci s e-maily a na ostatní zásuvné moduly.

#### Zásuvné moduly k zapisování revizí ####

První čtyři zásuvné moduly se týkají zapisování revizí. Zásuvný modul `pre-commit` se spouští jako první, ještě než začnete psát zprávu k revizi. Slouží ke kontrole snímku, který hodláte zapsat. Může zjišťovat, zda jste na něco nezapomněli, spouštět kontrolní testy nebo prověřovat cokoli jiného, co potřebujete ve zdrojovém kódu zkontrolovat. Je-li výstup tohoto zásuvného modulu nenulový, zapisování bude přerušeno. Tomu se dá předejít zadáním příkazu `git commit --no-verify`. Můžete kontrolovat záležitosti jako styl kódu (spustit lint apod.), koncové mezery (výchozí zásuvný modul dělá právě toto) nebo správnou dokumentaci k novým metodám.

Zásuvný modul `prepare-commit-msg` se spouští ještě předtím, než se otevře editor pro vytvoření zprávy k revizi, ale poté, co byla vytvořena výchozí zpráva. Umožňuje upravit výchozí zprávu dřív, než se zobrazí autorovi revize. Tento zásuvný modul vyžaduje některá nastavení: cestu k souboru, v němž je zpráva k revizi uložena, typ revize, a jedná-li se o doplněnou revizi, také SHA-1 revize. Tento zásuvný modul většinou není pro normální revize využitelný. Hodí se spíše pro revize, u nichž je výchozí zpráva generována automaticky, např. zprávy k revizím ze šablony, revize sloučením, komprimované revize a doplněné revize. Zásuvný modul můžete v kombinaci se šablonou revize využívat k programovému vložení informací.

Zásuvný modul `commit-msg` používá jeden parametr, jímž je cesta k dočasnému souboru obsahujícímu aktuální zprávu k revizi. Je-li návratová hodnota skriptu nenulová, Git přeruší proces zapisování. Skript tak můžete používat k validaci stavu projektu nebo zprávy k revizi, než dovolíte, aby byla revize zapsána. V poslední části této kapitoly ukážeme, jak lze pomocí tohoto zásuvného modulu zkontrolovat, že zpráva k revizi odpovídá požadovanému vzoru.

Po dokončení celého procesu zapisování revize se spustí zásuvný modul `post-commit`. Nepoužívá žádné parametry, ale spuštěním příkazu `git log -1 HEAD` lze snadno zobrazit poslední revizi. Tento skript se tak většinou používá pro účely oznámení a podobně.

Skripty k zapisování revizí na straně klienta lze používat prakticky v každém pracovním postupu. Často se používají jako ujištění, že budou dodržovány stanovené standardy. Tady je však nutné upozornit, že se tyto skripty při klonování nepřenášejí. Standardy můžete kontrolovat na straně serveru a odmítnout odesílané revize, které neodpovídají požadavkům. Záleží však jen na samotném vývojáři, jestli bude tyto skripty využívat i na straně klienta. Toto jsou tedy skripty, které slouží jako pomůcka pro vývojáře. Uživatel je musí nastavit a spravovat, ale kdykoli je může také potlačit nebo upravit.

#### Zásuvné moduly pro práci s e-maily ####

Pro pracovní postup založený na e-mailové komunikaci lze nastavit tři zásuvné moduly na straně klienta. Všechny tři se spouštějí spolu s příkazem `git am`, takže pokud tento příkaz nepoužíváte, můžete beze všeho přeskočit rovnou na následující část. Pokud přebíráte e-mailem záplaty vytvořené příkazem `git format-patch`, mohou pro vás být tyto zásuvné moduly užitečné.

První zásuvným modulem, který se spouští, je `applypatch-msg`. Používá jediný parametr: název dočasného souboru s požadovaným tvarem zprávy k revizi. Je-li výstup tohoto skriptu nenulový, Git přeruší záplatu. Zásuvný modul můžete použít k ujištění, že je zpráva k revizi ve správném formátu, nebo ke standardizaci zprávy – skript může zprávu rovnou upravit.

Další zásuvným modulem, který se může spouštět při aplikaci záplaty příkazem `git am`, je `pre-applypatch`. Nepoužívá žádné parametry a spouští se až po aplikaci záplaty, takže ho můžete využít k ověření snímku před zapsáním revize. Tímto skriptem lze spouštět různé testy nebo jinak kontrolovat pracovní strom. Jestliže je záplata neúplná nebo neprojde prováděnými testy, bude výstup skriptu nenulový, příkaz `git am` bude přerušen a revize nebude zapsána.

Posledním zásuvným modulem, který je během operace `git am` spuštěn, je `post-applypatch`. Můžete ho použít k tomu, abyste skupině uživatelů nebo autorovi záplaty oznámili, že byla záplata natažena. Tímto skriptem nelze proces aplikace záplaty a zapsání revizí zastavit.

#### Ostatní zásuvné moduly na straně klienta ####

Zásuvný modul `pre-rebase` se spouští před každým přeskládáním a při nenulové hodnotě může tento proces zastavit. Zásuvný modul můžete využít i k zakázání přeskládání všech revizí, které už byly odeslány. Ukázkový zásuvný modul `pre-rebase`, který Git nainstaluje, dělá právě toto, ačkoli předpokládá, že následuje název větve, kterou publikujete. Pravděpodobně ho budete muset změnit na název stabilní, zveřejněné větve.

Po úspěšném spuštění příkazu `git checkout` se spustí zásuvný modul `post-checkout`. Ten slouží k nastavení pracovního adresáře podle potřeb prostředí vašeho projektu. Pod tím si můžete představit například přesouvání velkých binárních souborů, jejichž zdrojový kód si nepřejete verzovat, automatické generování dokumentace apod.

A konečně můžeme zmínit zásuvný modul `post-merge`, který se spouští po úspěšném provedení příkazu `merge`. Pomocí něj můžete obnovit data v pracovním stromě, které Git neumí sledovat, např. data oprávnění. Zásuvný modul může rovněž ověřit přítomnost souborů nezahrnutých do správy verzí systému Git, které možná budete chtít po změnách v pracovním stromě zkopírovat.

### Zásuvné moduly na straně serveru ###

Vedle zásuvných modulů na straně klienta můžete jako správce systému využívat také několik důležitých zásuvných modulů na straně serveru, které vám pomohou kontrolovat téměř jakýkoli typ standardů stanovených pro daný projekt. Tyto skripty se spouštějí před odesíláním revizí na server i po něm. Zásuvné moduly spouštěné před přijetím revizí mohou v případě nenulového výstupu odesílaná data kdykoli odmítnout a poslat klientovi chybové hlášení. Díky nim můžete nastavit libovolně komplexní požadavky na odesílané revize.

#### pre-receive a post-receive ####

Prvním skriptem, který se při manipulaci s revizemi přijatými od klienta spustí, je `pre-receive`. Skript používá seznam referencí, které jsou odesílány ze standardního vstupu stdin. Je-li návratová hodnota nenulová, nebude ani jedna z nich přijata. Zásuvný modul můžete využít např. k ověření, že všechny aktualizované reference jsou „rychle vpřed“, nebo ke kontrole, že uživatel odesílající revize má oprávnění k vytváření, mazání nebo odesílání nebo oprávnění aktualizovat všechny soubory, které svými revizemi mění.

Zásuvný modul `post-receive` se spouští až poté, co je celý proces dokončen. Lze ho použít k aktualizaci jiných služeb nebo odeslání oznámení jiným uživatelům. Používá stejná data ze standardního vstupu jako zásuvný modul `pre-receive`. Ukázkové skripty obsahují odeslání seznamu e-mailem, oznámení serveru průběžné integrace nebo aktualizaci systému sledování tiketů. Možné je dokonce i analyzovat zprávy k revizím a zjistit, zda je některé tikety třeba otevřít, upravit nebo zavřít. Tento skript nedokáže zastavit proces odesílání, avšak klient se neodpojí, dokud není dokončen. Buďte proto opatrní, pokud se chystáte provést akci, která může dlouho trvat.

#### update ####

Skript update je velice podobný skriptu `pre-receive`, avšak s tím rozdílem, že se spouští zvlášť pro každou větev, kterou chce odesílatel aktualizovat. Pokud se uživatel pokouší odeslat revize do více větví, skript `pre-receive` se spustí pouze jednou, zatímco update se spustí jednou pro každou větev, již se odesílatel pokouší aktualizovat. Tento skript nenačítá data ze standardního vstupu, místo nich používá tři jiné parametry: název reference (větve), hodnotu SHA-1, na niž reference ukazovala před odesláním, a hodnotu SHA-1, kterou se uživatel pokouší odeslat. Je-li výstup skriptu update nenulový, je zamítnuta pouze tato reference, ostatní mohou být aktualizovány.

## Příklad vynucení chování systémem Git ##

V této části použijeme to, co jsme se naučili o vytváření pracovního postupu v systému Git. Systém může kontrolovat formát uživatelovy zprávy k revizi, dovolit pouze aktualizace „rychle vpřed“ a umožňovat změnu obsahu konkrétních podadresářů projektu pouze vybraným uživatelům. V této části vytvoříte skripty pro klienta, které vývojářům pomohou zjistit, zda budou jejich revize odmítnuty, a skripty na server, které si specifikované požadavky přímo vynutí.

Já jsem k napsání skriptů použil Ruby, zaprvé proto, že je to můj oblíbený skriptovací jazyk, zadruhé proto, že ho považuji za skriptovací jazyk, který nejvíce vypadá jako pseudokód. Díky tomu byste měli kód bez problému rozluštit, i když Ruby nepoužíváte. Stejně dobře však pochodíte i s jakýmkoli jiným jazykem. Všechny vzorové skripty zásuvných modulů distribuované se systémem Git jsou buď ve skriptování Perl, nebo Bash. Podíváte-li se tyto vzorové skripty, budete mít i spoustu příkladů zásuvných modulů v těchto jazycích.

### Zásuvný modul na straně serveru ###

Veškerá práce na straně serveru bude uložena do souboru update v adresáři hooks. Soubor update bude spuštěn jednou na každou odesílanou větev a jako parametr použije referenci, do níž se odesílá, starou revizi, kde byla tato větev umístěna, a novou, odesílanou revizi. Pokud jsou revize odesílány prostřednictvím SSH, budete mít přístup také k uživateli, který data odesílá. Pokud jste všem povolili připojení s jedním uživatelem (např. „git“) na základě ověření veřejného klíče, možná budete muset poskytnout těmto uživatelům shellový wrapper, který určuje, který uživatel se připojuje na základě veřejného klíče, a nastavit proměnnou prostředí, jež tyto uživatele stanoví. V tomto okamžiku předpokládám, že je připojující se uživatel v proměnné prostředí `$USER`, a skript update tak začne shromažďovat všechny potřebné informace:

	#!/usr/bin/env ruby

	refname = ARGV[0]
	oldrev  = ARGV[1]
	newrev  = ARGV[2]
	user    = ENV['USER']

	puts "Enforcing Policies... \n(#{refname}) (#{oldrev[0,6]}) (#{newrev[0,6]})"

#### Standardizovaná zpráva k revizi ####

Vaším prvním úkolem bude zajistit, aby všechny zprávy k revizím splňovaly předepsaný formát. Abychom si stanovili nějaký cíl, řekněme, že každá zpráva musí obsahovat řetězec ve tvaru „ref: 1234“, protože potřebujete, aby se každá revize vztahovala k jedné pracovní položce vašeho tiketovacího systému. Každou odesílanou revizi si musíte prohlédnout, zjistit, zda zpráva k revizi obsahuje daný řetězec, a pokud v některé z nich chybí, vrátit nenulovou hodnotu, čímž odesílanou revizi odmítnete.

Vezmete-li hodnoty `$newrev` a `$oldrev` a zadáte je k nízkoúrovňovému příkazu `git rev-list`, získáte seznam hodnot SHA-1 všech odesílaných revizí. Tento příkaz má v podstatě stejnou funkci jako `git log`, jeho výstupem jsou ale pouze hodnoty SHA-1 bez dalších informací. Pokud tedy chcete získat seznam všech hodnot SHA revizí provedených mezi dvěma konkrétními revizemi, můžete spustit zhruba toto:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Tento výstup můžete vzít, projít všechny hodnoty SHA jednotlivých revizí, vzít jejich zprávy a otestovat je proti regulárnímu výrazu, který vyhledává vzor.

Budete muset najít postup, jak získat zprávy všech těchto revizí, které mají být otestovány. Chcete-li získat syrová data revizí, můžete použít další nízkoúrovňový příkaz: `git cat-file`. Všem těmto nízkoúrovňovým příkazům se budu podrobněji věnovat v kapitole 9. Pro tuto chvíli se jen podívejme, co příkazem získáme:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Jednoduchým způsobem, jak z revize, k níž máte hodnotu SHA-1, extrahovat její zprávu, je přejít k prvnímu prázdnému řádku a vzít vše, co následuje za ním. V systémech Unix to lze provést příkazem `sed`:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

Tento výraz můžete použít k extrakci zpráv ze všech odesílaných revizí a skript ukončit, jestliže najdete něco, co neodpovídá požadavkům. Chcete-li skript ukončit a odesílaná data odmítnout, návratová hodnota musí být nenulová. Celá metoda vypadá takto:

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

Pokud toto vložíte do skriptu `update`, budou odmítnuty všechny aktualizace s revizemi, které mají zprávu neodpovídající zadanému pravidlu.

#### Systém ACL podle uživatelů ####

Předpokládejme, že chcete přidat mechanismus, který bude používat seznam oprávnění ACL (access control list), v němž bude stanoveno, kteří uživatelé smějí do které části vašeho projektu odesílat změny. Někteří uživatelé budou mít plný přístup, jiní budou mít přístup jen do některých podadresářů nebo ke konkrétním souborům. Základ tohoto systému bude představovat soubor `acl`, který bude uložen v adresáři repozitáře na serveru a do nějž zapíšete všechna příslušná pravidla. Zásuvný modul `update` se podívá na tato pravidla, zjistí, jaké soubory byly ve všech odesílaných revizích doručeny, a určí, zda má odesílatel oprávnění aktualizovat všechny tyto soubory.

Prvním krokem, který budete muset udělat, je vytvoření seznamu ACL. Tady budete používat formát velmi podobný mechanismu CVS ACL. Využívá posloupnosti řádků, kdy v prvním poli stojí `avail` nebo `unavail`, v dalším poli je čárkami oddělený seznam uživatelů, jichž se pravidlo týká, a v posledním poli je uvedeno umístění, na něž se pravidlo vztahuje (prázdné pole označuje otevřený přístup). Všechna tato pole jsou oddělena svislicí (`|`).

V našem příkladu máte několik správců, několik tvůrců dokumentace s přístupem do adresáře `doc` a jednoho vývojáře, který má jako jediný přístup do adresářů `lib` a `tests`. Soubor ACL proto bude vypadat následovně:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

Začnete načtením těchto dat do struktury, kterou můžete použít. Abychom příklad nekomplikovali, budete vyžadovat pouze direktivy `avail` (využít). Používá se tu metoda asociativních polí, kdy klíč představuje jméno uživatele a hodnotu tvoří sada umístění, k nimž má uživatel oprávnění pro zápis:

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

V kombinaci se souborem ACL, který jsme si ukázali před chvílí, poskytne tato metoda `get_acl_access_data` datovou strukturu v této podobě:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Nyní, když jste uspořádali příslušná oprávnění, zbývá zjistit, která umístění odesílané revize změnily, abyste měli jistotu, že k nim ke všem má odesílající uživatel přístup.

Zjistit, které soubory byly v jedné revizi změněny, lze velmi snadno pomocí příkazu `git log` s parametrem `--name-only` (stručně popsáno v kapitole 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

Jestliže používáte strukturu ACL získanou metodou `get_acl_access_data` a kontrolujete ji proti seznamu souborů v každé revizi, můžete určit, zda bude mít uživatel oprávnění odesílat všechny své revize:

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
	        if !access_path || # user has access to everything
	          (path.index(access_path) == 0) # access to this path
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

Většina uvedeného by měla být jasná. Příkazem `git rev-list` získáte výpis nových revizí odesílaných na váš server. U každé z revizí uvidíte také soubory, které byly změněny, a budete se moci přesvědčit, zda má odesílající uživatel přístup ke všem umístěním, která svými daty mění. Snad jediným specifickým Ruby výrazem, který nemusí být jasný, je `path.index(access_path) == 0`, který je pravdivý, pokud kontrolovaná cesta začíná řetězcem `access_path` (cesta oprávnění) – díky tomu nepovoluje cesta v `access_path` jen konkrétní místo na disku (soubor nebo adresář), ale také všechny soubory nebo adresáře, které začínají tímto řetězcem.

Vaši uživatelé tak už teď nebudou moci odesílat revize se zprávami v nepatřičném tvaru nebo se soubory změněnými mimo umístění jim vyhrazená.

#### Pouze „rychle vpřed“ ####

Poslední věcí, která nám ještě zbývá, je povolit pouze odeslání směřující „rychle vpřed“ (fast forward). Ve verzi 1.6 systému Git a novějších lze nastavit možnosti `receive.denyDeletes` a `receive.denyNonFastForwards`. Pokud však totéž nastavíte pomocí zásuvného modulu, pochodíte i ve starších verzích systému Git a navíc ho můžete nastavit pouze pro konkrétní uživatele nebo na cokoli jiného, s čím se kdy setkáte.

Kontrolu můžete provést tak, že se podíváte, zda jsou některé revize dostupné ze starších verzí, ale nejsou dostupné z novějších. Pokud žádná taková revize neexistuje, směřovalo odeslání rychle vpřed. V opačném případě můžete odeslané revize odmítnout:

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

Nyní je vše nastaveno. Spustíte-li příkaz `chmod u+x .git/hooks/update`, což je soubor, do nějž byste měli celý tento kód vložit a poté zkusit odeslat referenci, která nesměřuje rychle vpřed, dostanete následující výstup:

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Výstup obsahuje řadu zajímavých informací. Zaprvé si všimněte místa, kde byl spuštěn zásuvný modul.

	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)

Všimněte si, že toto bylo posláno na standardní výstup „stdout“ na samém začátku skriptu update. Měli bychom také upozornit, že všechno, co váš skript vypíše do standardního výstupu stdout, bude přeneseno také klientovi.

Další věcí, jíž si všimnete, je chybové hlášení.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

První řádek jste vytvořili vy, dalšími dvěma řádky vám Git sděluje, že je výstup skriptu update nenulový, a proto bude odeslání odmítnuto. A na konci stojí následující:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Pro každou referenci, kterou váš zásuvný modul odmítne, se zobrazí jedna zpráva o odmítnutí vzdálené reference. Ze zprávy vyčtete, že byla reference odmítnuta kvůli chybě zásuvného modulu.

Pokud navíc není ukazatel reference v některé z vašich revizí, zobrazí se chybové hlášení, které jste pro tento účel určili.

	[POLICY] Your message is not formatted correctly

Nebo pokud se někdo pokusí upravit soubor, k němuž nemá přístup, a odešle revizi, jejíž součástí bude tento soubor, zobrazí se podobná zpráva. Pokud se například autor dokumentace pokusí odeslat revizi, která mění obsah adresáře `lib`, zobrazí se mu upozornění:

	[POLICY] You do not have access to push to lib/test.rb

A to je vše. Od této chvíle budete mít k dispozici skript `update` ve spustitelné podobě, váš repozitář nikdy nebude převinut zpět a nikdy nepřijme zprávu k revizi, která by neodpovídala předepsanému vzoru. Uživatelé se navíc budou moci pohybovat jen ve vymezeném prostoru.

### Zásuvné moduly na straně klienta ###

Nevýhodou uvedeného postupu jsou nářky vašich uživatelů, které vás nevyhnutelně čekají jako výsledek odmítnutí jejich revizí. Odmítnete-li na poslední chvíli práci, na níž si dávali záležet, budou vaši uživatelé zmatení a otrávení, nemluvě o tom, že budou muset kvůli opravě měnit svou historii, což může bázlivější povahy odradit.

Problém vám mohou pomoci vyřešit zásuvné moduly na straně klienta. Poskytněte je svým uživatelům a ti budou upozorněni pokaždé, až provedou něco, co by server s největší pravděpodobností odmítl. Všechny problémy tak budou moci opravit, dokud to ještě není příliš složité a dokud je nezapsali do revize. Jelikož se zásuvné moduly při naklonování projektu nekopírují, musíte tyto skripty distribuovat jinak a uživatelům zadat instrukce, aby je zkopírovali do svého adresáře `.git/hooks` a zajistili, že budou spustitelné. Zásuvné moduly můžete distribuovat v rámci projektu nebo v samostatném projektu, nelze je však nastavit automaticky.

Pro začátek byste měli zkontrolovat zprávy k revizi, než tyto revize nahrajete, abyste měli jistotu, že server vaše změny neodmítne jen kvůli zprávám v nesprávném formátu. K tomuto účelu můžete použít zásuvný modul `commit-msg`. Necháte-li zásuvný modul přečíst zprávu k revizi ze souboru, který zadáte jako první parametr, a srovnat se vzorem, můžete systému Git uložit, aby odmítl revize, které vzoru neodpovídají:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

Je-li skript na svém místě (`.git/hooks/commit-msg`) a je spustitelný, pak v případě, že zapíšete revizi se zprávou v nedovoleném formátu, zobrazí se následující:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

V takovém případě nebyla zapsána žádná revize. Pokud však zpráva obsahuje správný vzor, Git vám umožní revizi zapsat:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Dále se budete chtít ujistit, že neměníte soubory, jejichž úpravu vám zakazuje seznam ACL. Pokud adresář `.git` vašeho projektu obsahuje kopii souboru ACL, který jsme používali naposledy, příslušná omezení přístupu pro vás ohlídá tento skript `pre-commit`:

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

Jedná se o přibližně stejný skript, jaký funguje na serveru, avšak se dvěma podstatnými rozdíly. Zaprvé je soubor ACL na jiném místě, protože se tento skript spouští z vašeho pracovního adresáře, a ne z adresáře Git. Cestu k souboru ACL budete muset změnit z

	access = get_acl_access_data('acl')

na:

	access = get_acl_access_data('.git/acl')

Druhým důležitým rozdílem je způsob, jak se zobrazí seznam změněných souborů. Protože serverová metoda využívá záznam revizí, ale ve vašem případě ještě nebyla revize zaznamenána, musí být seznam souborů pořízen na základě oblasti připravených změn. Místo

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

budete muset použít:

	files_modified = `git diff-index --cached --name-only HEAD`

Toto jsou však jediné dvě změny, v ostatních ohledech pracuje skript stejně. Je však třeba upozornit, že skript očekává, že lokálně pracujete v roli stejného uživatele jako odesíláte data na vzdálený server. Pokud nejsou uživatelé stejní, budete muset ručně nastavit proměnnou `$user`.

Posledním krokem, který budete muset provést, je ověření, že nebudete odesílat reference nesměřující rychle vpřed. Tento krok však už není tak jednoduchý. Chcete-li vyhledat reference nesměřující rychle vpřed, budete muset buď provést přeskládání po revizi, kterou jste již odeslali, nebo se do stejné vzdálené větve pokusit odeslat jinou lokální větev.

Vzhledem k tomu, že vám server sdělí, že nelze odesílat revize nesměřující rychle vpřed, a zásuvný modul neumožní odeslat revize nesplňující dané požadavky, je vaší poslední možností přeskládat revize, které jste již odeslali.

Jako příklad uvedeme skript pre-rebase, který bude toto pravidlo kontrolovat. Použije seznam všech revizí, které hodláte přepsat, a ověří, zda neexistují už v některé z vašich vzdálených referencí. Pokud najde revizi, která je dostupná z některé z vašich vzdálených referencí, proces přeskládání přeruší:

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
	    if shas_pushed.split("\n").include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

Tento skript používá syntaxi, které jsme se v části Výběr revize v kapitole 6 nevěnovali. Seznam revizí, které už byly odeslány, získáte takto:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

Syntaxe `SHA^@` se vztahuje na všechny rodiče této revize. Vyhledáváte všechny revize, které jsou dostupné z poslední revize na vzdáleném serveru a nejsou dostupné z žádného rodiče jakékoli hodnoty SHA, kterou se pokoušíte odeslat. Tímto způsobem lze označit odeslání „rychle vpřed“.

Největší nevýhodou tohoto postupu je, že může být velmi pomalý a není vždy nutný. Pokud se nesnažíte vynutit si odeslání parametrem `-f`, server vás sám upozorní a odesílané revize nepřijme. Skript je však zajímavým cvičením a teoreticky vám může pomoci předejít nutnosti vracet se v historii a přeskládávat revize kvůli opravě chyby.

## Shrnutí ##

V sedmé kapitole jste se naučili základní způsoby, jak přizpůsobit klienta a server systému Git tak, aby nejlépe odpovídali potřebám vašeho pracovního postupu a vašich projektů. Poznali jste všechny druhy konfiguračního nastavení, atributy nastavované pomocí souborů a dokonce i zásuvné moduly. V neposlední řadě jste sestavili exemplární server, který si sám dokáže vynutit vámi předepsané standardy. Nyní byste měli systém Git bez potíží nastavit téměř na jakýkoli pracovní postup, který si vysníte.
