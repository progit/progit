# Úvod #

V této kapitole si vysvětlíme, jak začít s Gitem. Jak fungují systémy kontroly verzí, ukážeme si, jak Git nainstalovat
a jak ho nastavit tak, abychom s ním mohli pohodlně pracovat. Objasníme si, proč Git používá tolik lidí
a proč byste ho měli používat i vy.

## Správa verzí ##

Co je to správa verzí? Proč by vás to vůbec mělo zajímat? Správa verzí je systém,
který zaznamenává změny souborů v čase tak, že se v případě potřeby můžeme vrátit
k některé z předchozích verzí. Pro příklady v této knize použijeme zdrojový kód softwaru
jako ony spravované soubory, ale samozřejmě to není nutné -- můžete spravovat v podstatě
jakýkoli druh souborů.

Pokud jste grafik nebo web-designer a chcete si schovat každou verzi obrázku nebo
rozvržení stránky (což zcela jistě budete chtít), je velmi moudré rozhodnutí použít
systém pro správu verzí (SSV).[^1] Umožňuje vám vrátit jednotlivé soubory nebo celý projekt
do nějakého z předchozích stavů, porovnávat změny, vidět, kdo naposledy změnil soubor, ve kterém
se objevil nějaký problém, kdo napsal chybový kód a mnohé další ... Používat SSV také obecně
znamená, že pokud něco zkazíte nebo přijdete o nějaké soubory, můžete se jed\-no\-du\-še vrátit.
Navíc s minimálními režijními náklady.

[^1]: Pozn. překl.: V anglickém originále VCS -- Version Control System

### Místní systémy správy verzí ###

Mnoha lidmi používaná metoda je prosté kopírování souborů na jiné místo, občas označené
např. datem, pokud jsou chytřejší. Tento přístup je oblíbený pro svoji jednoduchost, ale
je neskutečně chybový. Je tak jednoduché zapomenout, ve kterém adresáři se zrovna nacházíte,
a omylem zapsat do špatného souboru nebo chybně kopírovat.

Kdysi dávno právě z těchto důvodů vznikly místní SSV, které v jednoduché databázi udržovaly
všechny změny spravovaných souborů (obr. 1-1).

Insert 18333fig0101.png 
Obrázek 1-1. Místní SSV

Jeden z populárnějších SSV byl program rcs, který je stále ještě dodáván i s mnoha dnešními počítači.
Zvláště populární operační systém Mac OS X obsahuje příkaz rcs, když instalujete Developer Tools.
Funguje v podstatě na principu uchovávání patchů mezi jednotlivými změnami ve speciálním formátu
na disku, takže může obnovit jakýkoli bod v minulosti aplikováním všech těchto patchů v sérii.

### Centralizované systémy správy verzí ###

Další požadavek na SSV je, aby umožnil spolupráci více vývojářů z různých koutů světa. Proto byly vytvořeny
centralizované systémy správy verzí (SSV). Tyto systémy, jako např. CVS, Subversion nebo Perforce,
mají vždy jeden server, který obsahuje všechny spravované soubory ve všech verzích, a množství klientů,
již stahují soubory z tohoto jednoho centrálního místa. Po mnoho let byl toto standard ve správě verzí (obr. 1-2).

Insert 18333fig0102.png 
Obrázek 1-2. Centralizovaný SSV

Toto uspořádání přináší mnoho výhod, zvláště proti místním SSV. Třeba všichni ví do jisté míry, kdo další
se ještě na projektu podílí. Administrátoři mají přesnou kontrolu nad tím, kdo co dělá -- je to daleko jednodušší
než spravovat místní databáze u každého klienta zvlášť.

Samozřejmě to má i vážná úskalí. Nejviditelnější je asi ten jeden jediný bod uprostřed reprezentovaný centralizovaným
serverem. Když má server hodinový výpadek, pak samozřejmě behem této hodiny nikdo nepřispěje, nikdo nemůže uložit
své provedené změny na projektu, na kterém právě pracuje. Pokud dojde k poruše harddisku centrální databáze a nikdo dostatečně nezálohoval,
pak ztratíte absolutně všechno. Kompletní historii projektu kromě nějakých osamělých kopií, které mají uživatelé a vývojáři na svém
vlastním počítači. Tím mimochodem trpí i místní SSV -- jakmile máte všechno na jednom místě, riskujete,
že při neopatrnosti nebo poruše jednoduše přijdete o všechno.

### Distribuované systémy správy verzí ###

Proto nastoupily na scénu distribuované SSV (DSSV). V takovém systému (Git, Mercurial, Bazaar, Darcs apod.)
klient neuchovává jen poslední verzi souborů, nýbrž vytváří kompletní duplikát repozitáře. Pak pokud nějaký
server v těchto podmínkách odejde do počítačového nebe, nic se vlastně nestane. Jakýkoli repozitář u klienta
je možno nahrát zpět na server a jede se dál. Každý checkout je v podstatě kompletní záloha všech dat (obr. 1-3)

Insert 18333fig0103.png 
Obrázek 1-3. Distribuovaný SSV

Navíc mnoho těchto systémů umí slušně pracovat s více vzdálenými repozitáři najednou, takže můžete spolupracovat
s různými skupinami lidí na různých částech téhož projektu. To umožňuje mít různé způsoby organizace práce,
které v centralizovaných systémech vůbec nejsou možné, jako je hierarchický model.

## Stručná historie Gitu ##

Stejně jako mnoho velkých událostí i historie Gitu začíná trochou tvořivé destrukce a prudké kontroverze.
Linuxové jádro je dosti rozsáhlý open-source softwarový projekt. Nejprve docela dlouho (1991-2002) byly
změny kódu prováděny jako patche a archivované soubory. V roce 2002 pak projekt přešel na proprietární DSSV
BitKeeper.

Po třech letech (2005) ochladly vztahy mezi vývojáři jádra a firmou, která BitKepper vyvinula, už neměl být zdarma,
a tak se komunita vývojářů jádra (zvláště Linus Torvalds, tvůrce Linuxu) rozhodla vytvořit vlastní DSSV
postavený na získaných zkušenostech z BitKeeperu. Požadované vlastnosti nového systému byly:

*	Rychlost
*	Jednoduchý návrh
*	Propracovaná podpora pro nelineární vývoj (tisíce paralelních větví)
*	Plná distribuovanost
*	Schopnost udržet tak velký projekt jako jádro Linuxu úsporně z hlediska rychlosti i množství dat

Od jeho zrodu v roce 2005 se Git vyvinul a dospěl do jednoduše použitelného systému a stále splňuje tyto původní
předpoklady. Je neuvěřitelně rychlý, bez velkých režijních nákladů i u obrovských projektů a má nevídaný systém větvení (kap. 3)
pro nelineární vývoj.

## Základy Gitu ##
Takže v kostce, co je to Git? Tohle je důležité vědět, protože pokud budete rozumět, co to Git je a jak zhruba funguje,
bude pro vás pravděpodobně výrazně jednodušší ho používat efektivně. Až se Git naučíte, zkuste zapomenout všechno,
co jste věděli o ostatních SSV jako Subversion nebo Perforce. Git ukládá informace a přemýšlí o nich naprosto
odlišným způsobem i přesto, že uživatelské rozhraní je dosti podobné. Porozumět těmto drobným rozdílům pomůže
překonat možnou prvotní zmatenost z přechodu na Git.

### Snapshoty, ne rozdíly ###

Hlavní rozdíl mezi Gitem a ostatními SSV (Subversion a jeho přátelé) je způsob, jakým Git přemýšlí nad svými daty.
Koncepcí většiny ostatních systémů je ukládat informace jako seznam změn v jednotlivých souborech. Udržují si sadu souborů
a změny v nich provedené (obr. 1-4).

Insert 18333fig0104.png
Obrázek 1-4. Ostatní systémy ukládají data jako změny každého souboru.

Gitu je takovýto přístup cizí. Místo toho jsou pro něj data spíše mnoho snapshotů malého filesystému. Pokaždé, když commitnete[^2]
stav svého projektu do Gitu, jednoduše si udělá snímek, o tom jak právě teď vypadají všechny soubory, a uloží ho. Pro úsporu
si nezměněné soubory ukládá jen jako odkaz na předchozí identický soubor. Git přemýšlí nad daty asi jako na obrázku 1-5.

[^2]: Pozn. překl.: Český ekvivalent "předáte" se v podstatě neužívá.

Insert 18333fig0105.png 
Obrázek 1-5. Git ukládá data jako snapshoty projektu.

To je důležitý rozdíl mezi Gitem a skoro všemi ostatními SSV. Nutí to Git znovu uvážit téměř každý aspekt správy verzí, které většina
ostatních systémů převzala z předchozí generace. To dělá z Gitu spíše malý filesystém s několika neuvěřitelně mocnými nástroji
nad sebou než prostě SSV. K některým výhodám tohoto přístupu dojdeme v kapitole 3, kde se budeme zabývat větvením vývojového stromu.

### Většině operací stačí váš stroj ###

Drtivá většina operací v Gitu nepotřebuje víc než místní soubory a zdroje. Obecně nepotřebuje žádnou informaci z jiného než vašeho stroje.
Pokud jste zvyklí na CSSV, kde téměř všechny operace mají režijní náklady zvýšené o zpoždění na síti, pak si budete myslet, že božstvo rychlosti
požehnalo Gitu a udělilo mu nadzemskou moc. Protože máte celou historii projektu právě u sebe na místním disku, vypadá většina operací,
že jsou vykonány okamžitě.

Například pokud si chcete prohlédnout historii projektu, Git nepotřebuje jít na server, aby získal historii a zobrazil ji pro vás -- jednoduše
ji přečte přímo z vaší místní databáze. To znamená, že historii projektu vidíte téměř hned. Pokud chcete vidět změny mezi současnou verzí souboru
a verzí měsíc starou, Git najde soubor v místní databázi a spočítá rozdíly lokálně místo toho, aby o to buďto požádal vzdálený server, nebo alespoň
stáhl starou verzi.

To také znamená, že je velmi málo toho, co nemůžete dělat, pokud jste offline. Sedíte-li na palubě letadla nebo ve vlaku a chcete udělat trochu práce,
můžete vesele commitovat, i když zrovna nemáte připojení k síti. Pokud jste doma a nemůžete se připojit k repozitáři,
můžete stále pracovat. U mnoha jiných systému je to dosti bolestivý proces, ne-li zhola nemožný.
V Perforce např. nemůžete dělat skoro nic; v Subversion nebo CVS můžete upravovat soubory, ale
předat je nejde (logicky -- databáze je offline). To nemusí vypadat jako velká změna, ale může vás příjemně překvapit, jak výrazný rozdíl to může být.

### Git drží integritu ###

Než je cokoli v Gitu uloženo, je tomu spočítán kontrolní součet. Ten se potom používá i k identifikaci celého commitu.
To znamená, že je zhola nemožné změnit obsah jakéhokoli souboru nebo adresáře bez toho, aby o tom Git věděl. Tato vlastnost
je do Gitu zabudována na těch nejnižších úrovních a je nedílnou součástí jeho filosofie. Nemůžete ztratit informace při přenosu
nebo přijít k poškození dat bez toho, aby to byl Git schopen odhalit.

Git k tomu používá mechanismus zvaný SHA-1 hash. To je 40 znaků dlouhý řetězec sestávající z hexadecimálních znaků (0-9 a a-f)
a spočítaný na základě obsahu souboru nebo adresářové struktury v Gitu. SHA-1 hash vypadá nějak takto:

	24b9da6552252987aa493b52f8696cd6d3b00373

S těmito hashi se v Gitu setkáte úplně všude. V podstatě Git všechno ukládá nikoli na základě jména souboru, ale právě na základě
hashe jeho obsahu.

### Git obecně jen přidává data ###

Pokud něco v Gitu děláte, téměř cokoli z toho jen přidá data do jeho databáze. Je opravdu obtížné donutit systém udělat něco, co by se nedalo vrátit,
nebo donutit ho nějakým způsobem smazat svoje data. Jako v každém SSV můžete samozřejmě ztratit změny provedené od posledního commitu,
ale jakmile jsou commitnuty, je velmi obtížné o ně přijít, zvláště pak pokud pravidelně zálohujete databázi do jiného repozitáře.

Je pak radost používat Git, protože víte, že můžete experimentovat bez nebezpečí, že byste si něco vážně poškodili. Pro hlubší náhled do problematiky,
jak Git ukládá data a jak se můžete vrátit k datům, která vypadají, že jsou ztracena, si přečtěte kapitolu 9.

### Tři stavy ###

Teď dávejte pozor. Tohle je hlavní věc, kterou si u Gitu musíte pamatovat, pokud chcete, aby vaše další studium Gitu šlo hladce.
Git má tři základní stavy, kterých můžou vaše soubory nabývat: "commited", "modified" a "staged"[^3].
Commited znamená, že data jsou bezpečně uložena v místní databázi. Modified znamená, že soubor byl oproti poslednímu předání změněn.
A staged je ten soubor, u kterého máte značku, že bude v této verzi zařazen do nejbližšího commitu.

[^3]: Pozn. překl.: Vzhledem k neexistující lokalizaci Gitu do češtiny budu nadále používat tyto anglické výrazy,
se kterými se v Gitu setkáte de facto na každém rohu narozdíl od českých ekvivalentů.

To nás vede ke třem hlavním sekcím projektu v Gitu: Git directory, working directory a staging area[^4].

[^4]: Pozn. překl.: Jako u předchozího. Tyto výrazy nemá nejmenší smysl překládat do češtiny.

Insert 18333fig0106.png 
Obrázek 1-6. Git directory, working directory a staging area

Git directory je místo, kde Git skladuje svoje vnitřní data a databázi objektů vašeho projektu. To je ta nejdůležitější část Gitu,
která se kopíruje, pokud si stahujete repozitář z jiného počítače.

Working directory je samotný snímek jedné verze spravovaného projektu. Jsou to soubory vytažené z databáze v Git directory
a umístěné na disk, abyste je použili nebo měnili.

Staging area je jednoduchý soubor, obvykle uložený ve vašem Git directory, který ukládá informace o tom, co bude součástí nejbližšího commitu.
Občas je též nazýván index, ale v angličtině se postupně stává standardem označovat ho jako "staging area".

Základní pracovní postup Gitu je pak zhruba takovýto:

1.	Změníte soubory ve svém working directory.
2.	Vložíte soubory do staging area.
3.	Vytvoříte commit, který vezme všechny soubory tak, jak jsou ve staging area, a uloží tento snímek permanentně do Git directory.

Pokud je nějaká verze souboru v Git directory, je označována jako commited, pokud je upravena a vložena do staging area, je staged. A konečně
pokud byla změněna a není staged, pak je modified. V kapitole 2 se dozvíte více o těchto stavech a jak můžete využít jejich výhod, nebo
naopak úplně přeskočit staging area.

## Instalujeme Git ##

Ponořme se nyní do používání Gitu. Ale od začátku -- nejprve ho musíte nainstalovat; dá se získat mnoha způsoby -- dva hlavní jsou
instalace ze zdrojových souborů a instalace už existujícího balíčku pro váš systém. 

### Instalujeme ze zdroje ###

Pokud to umíte, je obecně možné instalovat Git ze zdrojových kódů, protože získáte nejnovější verzi.
Vývojáři se stále snaží vylepšovat uživatelské rozhraní, takže stažení poslední verze je obvykle nejlepší cesta k cíli, 
pokud se tedy cítíte na překládání zdrojových souborů. To je také řešení případu, kdy je ve mnoha dostribucích Linuxu dostupný
jen nějaký starý balík; takže pokud zrovna nemáte nějakou aktuální distribuci nebo nepoužíváte "backports", bude instalace
ze zdroje asi nejlepší možností.

Git závisí na několika knihovnách, bez kterých ho nenainstalujete: curl, zlib, openssl, expat a libiconv. Např. pokud máte distribuci
užívající balíčkovací systém Yum (Fedora) nebo Apt (Debian a distribuce na něm založené), můžete použít jeden z těchto příkazů k instalaci
těchto závislostí.

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
Když jste už všechno nainstalovali, můžete pokročit dále a stáhnout si poslední verzi z webových stránek Gitu:

	http://git-scm.com/download
	
Rozbalíme, přeložíme a nainstalujeme:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Když jsme hotovi, můžeme také získat Git prostřednictvím jeho samotného (možnost další aktualizace):

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Instalujeme na Linuxu ###

Pokud chcete instalovat Git na Linuxu z binárního balíčku, měli byste použít váš balíčkovací program podle vaší distribuce,
který udělá vše za vás. Pokud máte Fedoru, můžete použít Yum:

	$ yum install git-core

Nebo pokud jste na distribuci založené na Debianu (např. Ubuntu), použijte Apt:

	$ apt-get install git-core

### Instalujeme na Macu ###

Existují dva jednoduché způsoby, jak nainstalovat Git na Mac. Nejjednodušší je použít grafický instalátor, který si můžete stáhnout ze stránek Google Code (viz obr. 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Obrázek 1-7. Git OS X installer

Druhá základní možnost je přes MacPorts (`http://www.macports.org`). Když už je máte, instalujete Git pomocí

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Nemusíte samozřejmě přidávat všechny extra balíčky, ale určitě si vyberete např. +svn, pokud musíte ještě
používat Git s repozitáři Subversion (více v kapitole 8).

### Instalujeme na Windows ###

Nainstalovat Git na Windows je velmi jednoduché. Stáhněte si exe instalátor ze stránek Google Code a spusťte ho:

	http://code.google.com/p/msysgit

Po dokončení instalace máte jak verzi pro příkazový řádek (včetně SSH klienta, který se bude hodit později), tak standardní grafické rozhraní.

## Počáteční nastavení ##

Teď, když máte na svém systému Git, si v něm možná budete chtít nastavit pár věcí, přizpůsobit svým požadavkům. Budete to muset udělat pouze jednou -- uchovávají se při upgradech. Samozřejmě je kdykoli můžete změnit provedením obdobných příkazů jako teď.

Git obsahuje nástroj zvaný git config, který umožňuje nastavovat konfigurační hodnoty, které ovládají, jak Git vypadá a jak se chová. Mohou být uloženy na třech různých místech:

*	soubor `/etc/gitconfig`: Obsahuje hodnoty pro všechny uživatele a všechny repozitáře na tomto systému dohromady. Pokud připojíte volbu ` --system` za `git config`, bude pracovat výhradně s tímto souborem.
*	soubot `~/.gitconfig`: Specifický pro uživatele. Tento soubor můžete upravovat také přidáním volby `--global`.
*	konfigurační soubor v Git directory (tj. `.git/config`) každého repozitáře: specifický pro každý jednotlivý repozitář.

Každá další vrstva překrývá tu předchozí, takže hodnoty v `.git/config` přebijí hodnoty z `/etc/gitconfig`.

Na Windows hledá Git soubor `.gitconfig` v `$HOME` (pro Windows 7 v `C:\Users\$USER` jinak obvykle `C:\Documents and Settings\$USER`). Samozřejmě pořád uvažuje /etc/gitconfig, přestože tato cesta je relativní ke kořenu MSys, což je místo, kam jste se rozhodli instalovat Git ve vašem systému Windows.

### Vaše identita ###

První věc, kterou máte udělat po instalaci Gitu, je nastavení vašeho uživatelského jména a e-mailu. To je důležité, jelikož každý commit tyto informace obsahuje, a jsou nevratně "zataveny" do všech vašich commitů.

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Znovu -- toto musíte udělat jen jednou, pokud připojíte volbu ` --global`, protože pak tyto informace použije Git pro cokoli, co na vašem systému děláte. Pokud je chcete přepsat jiným jménem nebo e-mailem pro nějaký projekt, stačí spustit příslušný příkaz bez volby ` --global` v adresáři onoho projektu.

### Váš editor ###

Teď, když máte nastaveno, kdo jste, si můžete nastavit výchozí textový editor, který Git použije, když bude chtít, abyste napsali zprávu. Jinak Git použije výchozí editor podle nastavení systému, což je obvykle Vi nebo Vim. Pokud chcete použít jiný textový editor, třeba Emacs, nastavte si to:

	$ git config --global core.editor emacs
	
### Váš nástroj pro řešení kolizních situací ###

Další užitečnou volbou je nastavení výchozího nástroje pro řešení kolizí. Takto nastavíte, že chcete používat vimdiff:

	$ git config --global merge.tool vimdiff

Git umí pracovat s nástroji kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff. Můžete také nastavit i jiný nástroj; více v kapitole 7.

### Kontrola vašeho nastavení ###

Pokud chcete zkontrolovat vaše nastavení, použijte `git config --list` k zobrazení všech nastavení, která dokáže na tomto místě Git najít:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Některé hodnoty můžete vidět vícekrát, protože je Git přečte z více různých souborů (např. `/etc/gitconfig` a `~/.gitconfig`). V takovém případě se Git řídí poslední načtenou hodnotou.

Také můžete zobrazit jednu konkrétní hodnotu napsáním `git config {key}`:

	$ git config user.name
	Scott Chacon

## První pomoc ##

Pokud náhodou potřebujete pomoct s používáním Gitu, jsou tři možnosti, jak získat manuál (manpage) pro každý jeden příkaz Gitu:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Například manpage pro příkaz config získáte spuštěním

	$ git help config

Tyto příkazy jsou užitečné zejména proto, že je můžete spustit kdykoli -- i offline.
Pokud by ani manuálové stránky, ani tato kniha neposkytly to, co potřebujete, zkuste IRC kanály `#git` nebo `#github` na Freenode IRC serveru (irc.freenode.net). Tyto kanály jsou pravidelně zaplněny stovkami lidí, kteří o Gitu ví opravdu mnoho a často vám rádi pomohou.

## Shrnutí ##

Měli byste v základu vědět, co to je Git a v jakém směru je odlišný od CSSV, který možná zrovna používáte. Měli byste mít na svém systému funkční Git nastavený podle vás. Nyní je čas na naučení se základů Gitu.
