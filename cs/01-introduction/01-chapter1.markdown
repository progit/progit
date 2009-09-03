# Úvod #

V této kapitole si vysvětlíme, jak začít s Gitem: Jak fungují systémy kontroly verzí, ukážeme si, jak Git nainstalovat
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
centralizované systémy správy verzí (CSSV). Tyto systémy, jako např. CVS, Subversion nebo Perforce,
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
klient neuchovává jen poslední verzi souborů, nýbrž vytváří kompletní duplikát repositáře. Pak pokud nějaký
server v těchto podmínkách odejde do počítačového nebe, nic se vlastně nestane. Jakýkoli repositář u klienta
je možno nahrát zpět na server a jede se dál. Každý checkout je v podstatě kompletní záloha všech dat (obr. 1-3)

Insert 18333fig0103.png 
Obrázek 1-3. Distribuovaný SSV

Navíc mnoho těchto systémů umí slušně pracovat s více vzdálenými repositáři najednou, takže můžete spolupracovat
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
bude pro vás pravděpodobně výrazně jednodušší ho používat efektivně. Až se Git naůčíte, zkuste zapomenout všechno,
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
stav svého projektu do Gitu, jednoduše si udělá obrázek, jak teď právě vypadají všechny soubory, a uloží to. Pro úsporu
si nezměněné soubory ukládá jen jako odkaz na předchozí identický soubor. Git přemýšlí nad daty asi jako na obrázku 1-5.

<<<<<<< HEAD:cs/01-introduction/01-chapter1.markdown
[^2]: Pozn. překl.: Český ekvivalent "předáte" se v podstatě neužívá.
=======
[^2]Pozn. překl.: Český ekvivalent "předáte" se v podstatě neužívá.
>>>>>>> progit/master:cs/01-introduction/01-chapter1.markdown

Insert 18333fig0105.png 
Obrázek 1-5. Git ukládá data jako snapshoty projektu.

To je důležitý rozdíl mezi Gitem a skoro všemi ostatními SSV. Nutí to Git znovu uvážit téměř každý aspekt správy verzí, které většina
ostatních systémů převzala z předchozí generace. To dělá z Gitu spíše malý filesystém s několika neuvěřitelně mocnými nástroji
nad sebou než prostě SSV. K některým výhodám tohoto přístupu dojdeme v kapitole 3, kde se budeme zabývat větvením vývojového stromu.

### Většině operací stačí váš stroj ###

Drtivá většina operací v Gitu nepotřebuje víc než místní soubory a zdroje. Obecně nepotřebuje žádnou informawci z jiného než vašeho stroje.
Pokud jste zvyklí na CSSV, kde téměř všechny operace mají režijní náklady zvýšené o zpoždění na síti, pak si budete myslet, že božstvo rychlosti
požehnalo Gitu a udělilo mu nadzemskou moc. Protože máte celou historii projektu právě u sebe na místním disku, vypadá většina operací,
že jsou vykonány okamžitě.

Například pokud si chcete prohlédnout historii projektu, Git nepotřebuje jít na server, aby získal historii a zobrazil ji pro vás -- jednoduše
ji přečte přímo z vaší místní databáze. To znamená, že historii projektu vidíte téměř hned. Pokud chcete vidět změny mezi současnou verzí souboru
a verzí měsíc starou, Git najde soubor v místní databázi a spočítá rozdíly lokálně místo toho, aby o to buďto požádal vzdálený server, nebo alespoň
stáhl starou verzi.

To také znamená, že je velmi málo toho, co nemůžete dělat, pokud jste offline. Sedíte-li na palubě letadla nebo ve vlaku a chcete udělat trochu práce,
můžete vesele commitovat, i když zrovna nemáte připojení k síti. Pokud jste doma a nemůžete se připojit k repositáři,
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
ale jakmile jsou commitnuty, je velmi obtížné o ně přijít, zvláště pak pokud pravidelně zálohujete databázi do jiného repositáře.

Je pak radost používat Git, protože víme, že můžeme experimentovat bez nebezpečí, že bychom si něco vážně poškodili. Pro hlubší náhled do problematiky,
jak Git ukládá data a jak se můžete vrátit k datům, která vypadají, že jsou ztracena, si přečtěte kapitolu 9.

### Tři stavy ###

Teď dávejte pozor. Tohle je hlavní věc, kterou si u Gitu musíte pamatovat, pokud chcete, aby vaše další studium Gitu šlo hladce.
Git má tři základní stavy, kterých můžou vaše soubory nabývat: "commited", "modified" a "staged"[^3].
Commited znamená, že data jsou bezpečně uložena v místní databázi. Modified znamená, že soubor byl oproti poslednímu předání změněn.
A staged je ten soubor, u kterého máte značku, že bude v této verzi zařazen do nejbližšího commitu.

<<<<<<< HEAD:cs/01-introduction/01-chapter1.markdown
[^3]: Pozn. překl.: Vzhledem k neexistující lokalizaci Gitu do češtiny budu nadále používat tyto anglické výrazy,
=======
[^3] Pozn. překl.: Vzhledem k neexistující lokalizaci Gitu do češtiny budu nadále používat tyto anglické výrazy,
>>>>>>> progit/master:cs/01-introduction/01-chapter1.markdown
se kterými se v Gitu setkáte de facto na každém rohu narozdíl od českých ekvivalentů.

To nás vede ke třem hlavním sekcím projektu v Gitu: Git directory, working directory a staging area[^4].

<<<<<<< HEAD:cs/01-introduction/01-chapter1.markdown
[^4]: Pozn. překl.: Jako u předchozího. Tyto výrazy nemá nejmenší smysl překládat do češtiny.
=======
[^4] Pozn. překl.: Jako u předchozího. Tyto výrazy nemá nejmenší smysl překládat do češtiny.
>>>>>>> progit/master:cs/01-introduction/01-chapter1.markdown

Insert 18333fig0106.png 
Figure 1-6. Git directory, working directory a staging area

Git directory je místo, kde Git skladuje svoje vnitřní data a databázi objektů vašeho projektu. To je ta nejdůležitější část Gitu,
která se kopíruje, pokud si stahujete repositář z jiného počítače.

Working directory je samotný obraz jedné verze spravovaného projektu. Jsou to soubory vytažené z databáze v Git directory
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

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
