# Git pod pokličkou #

Ať už jste do této kapitoly přeskočili z některé z předchozích, nebo jste se sem pročetli napříč celou knihou, v této kapitole se dozvíte něco o vnitřním fungování a implementaci systému Git. Osobně se domnívám, že je tato informace velmi důležitá, aby uživatel pochopil, jak užitečný a výkonný je systém Git. Ostatní mi však oponovali, že pro začátečníky mohou být tyto informace matoucí a zbytečně složité. Proto jsem tyto úvahy shrnul do poslední kapitoly knihy, kterou si můžete přečíst v libovolné fázi seznamování se systémem Git. Vhodný okamžik záleží jen na vás.

Nyní se však už pusťme do práce. Pokud tato informace ještě nezazněla dostatečně jasně, můžeme začít konstatováním, že Git je ve své podstatě obsahově adresovatelný systém souborů s uživatelským rozhraním VCS na svém vrcholu. Tomu, co tato definice znamená, se budeme věnovat za chvíli.

V dávných dobách (zhruba do verze 1.5) bývalo uživatelské rozhraní systému Git podstatně složitější než dnes. Git tehdy spíš než na uhlazené VCS kladl důraz právě na systém souborů. Uživatelské rozhraní však bylo za několik posledních let zkultivováno a dnes je už velmi čisté a uživatelsky příjemné. Ani v tomto ohledu se tak už Git nemusí obávat srovnání s ostatními systémy, navzdory tomu, že přetrvávající předsudky z raných dob hodnotí jeho uživatelské prostředí jako komplikované a náročné na pochopení.

Na systému Git je skvělý jeho obsahově adresovatelný systém souborů, a proto se v této kapitole zaměřím nejprve na něj. Poté se podíváme na mechanismy přenosu a úkony správy repozitářů, s nimiž se můžete jednou setkat.

## Nízkoúrovňové a vysokoúrovňové příkazy ##

V této knize jsme dosud uvedli asi 30 příkazů, které se používají k ovládání systému Git, např. `checkout`, `branch` nebo `remote`. Protože však byl Git původně spíš soupravou nástrojů k verzování než plným, uživatelsky přívětivým systémem VCS, zná celou řadu příkazů pracujících na nižších úrovních, které byly původně spojovány ve stylu UNIXu nebo volány ze skriptů. Těmto příkazům většinou říkáme „nízkoúrovňové“ (angl. plumbing commands), zatímco uživatelsky přívětivější příkazy označujeme jako „vysokoúrovňové“ (porcelain commands).

Prvních osm kapitol této knihy se zabývá téměř výhradně vysokoúrovňovými příkazy. V této kapitole se však budeme věnovat převážně nízkoúrovňovým příkazům, protože ty vám umožní nahlédnout do vnitřního fungování systému Git a pochopit, jak a proč Git dělá to, co dělá. Nepředpokládám, že byste chtěli tyto příkazy používat osamoceně na příkazovém řádku. Podíváme se na ně spíše jako na stavební kameny pro nové nástroje a skripty.

Spustíte-li v novém nebo existujícím adresáři příkaz `git init`, Git vytvoří adresář `.git`, tj. místo, kde je umístěno téměř vše, co Git ukládá a s čím manipuluje. Chcete-li zazálohovat nebo naklonovat repozitář, zkopírování tohoto jediného adresáře do jiného umístění vám poskytne prakticky vše, co budete potřebovat. Celá tato kapitola se bude zabývat v podstatě jen obsahem tohoto adresáře. Ten má následující podobu:

	$ ls
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

Možná ve svém adresáři najdete i další soubory. Toto je však příkazem `git init` čerstvě vytvořený repozitář s výchozím obsahem. Adresář `branches` se už v novějších verzích systému Git nepoužívá a soubor `description` používá pouze program GitWeb, takže o tyto dvě položky se nemusíte starat. Soubor `config` obsahuje konfigurační nastavení vašeho projektu a v adresáři `info` je uložen globální soubor `exclude` s maskami ignorovaných souborů a adresářů, které chcete explicitně ignorovat prostřednictvím souboru `.gitignore`. Adresář `hooks` obsahuje skripty zásuvných modulů na straně klienta nebo serveru, které jsme podrobně popisovali v kapitole 7.

Zbývají čtyři důležité položky: soubory `HEAD` a `index` a adresáře `objects` a `refs`. To jsou ústřední součásti adresáře Git. V adresáři `objects` je uložen celý obsah vaší databáze, v adresáři `refs` jsou uloženy ukazatele na objekty revizí v datech (větve). Soubor `HEAD` ukazuje na větev, na níž se právě nacházíte, a soubor `index` je pro systém Git úložištěm informací o oblasti připravených změn. Na každou z těchto částí se teď podíváme podrobněji, abyste pochopili, jak Git pracuje.

## Objekty Git ##

Git je obsahově adresovatelný systém souborů. Výborně. A co to znamená?
Znamená to, že v jádru systému Git se nachází jednoduché úložiště dat, ke kterému lze přistupovat pomocí klíčů. Můžete do něj vložit jakýkoli obsah a na oplátku dostanete klíč, který můžete kdykoli v budoucnu použít k vyzvednutí obsahu. Můžete tak použít například nízkoúrovňový příkaz `hash-object`, který vezme určitá data, uloží je v adresáři `.git` a dá vám klíč, pod nímž jsou tato data uložena. Vytvořme nejprve nový repozitář Git. Můžeme se přesvědčit, že je adresář `objects` prázdný:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

Git inicializoval adresář `objects` a vytvořil v něm podadresáře `pack` a `info`, nenajdeme tu však žádné skutečné soubory. Nyní můžete uložit kousek textu do databáze Git:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

Parametr `-w` sděluje příkazu `hash-object`, aby objekt uložil. Bez parametru by vám příkaz jen sdělil, jaký klíč by byl přidělen. Parametr `--stdin` zase příkazu sděluje, aby načetl obsah ze standardního vstupu. Pokud byste parametr nezadali, příkaz `hash-object` by očekával, že zadáte cestu k souboru. Výstupem příkazu je 40znakový otisk kontrolního součtu (checksum hash). Jedná se o otisk SHA-1 – kontrolní součet spojení ukládaného obsahu a záhlaví, o němž si povíme za okamžik. Nyní se můžete podívat, jak Git vaše data uložil:

	$ find .git/objects -type f
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Vidíte, že v adresáři `objects` přibyl nový soubor. Takto Git ukládá nejprve veškerý obsah – jeden soubor pro každý kus obsahu, nazvaný kontrolním součtem SHA-1 obsahu a záhlaví. Podadresář je pojmenován prvními dvěma znaky SHA, název souboru zbývajícími 38 znaky.

Obsah můžete ze systému Git zase vytáhnout, k tomu slouží příkaz `cat-file`. Tento příkaz je něco jako švýcarský nůž k prohlížení objektů Git. Přidáte-li k příkazu `cat-file` parametr `-p`, říkáte mu, aby zjistil typ obsahu a přehledně vám ho zobrazil:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Nyní tedy umíte vložit do systému Git určitý obsah a ten poté zase vytáhnout. Totéž můžete udělat také s obsahem v souborech. Na souboru můžete například provádět jednoduché verzování. Vytvořte nový soubor a uložte jeho obsah do své databáze:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt
	83baae61804e65cc73a7201a7252750c76066a30

Poté do souboru zapište nový obsah a znovu ho uložte:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Vaše databáze obsahuje dvě nové verze souboru a počáteční obsah, který jste do ní vložili:

	$ find .git/objects -type f
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Soubor nyní můžete vrátit do první verze:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt
	$ cat test.txt
	version 1

Nebo do druhé verze:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt
	$ cat test.txt
	version 2

Pamatovat si klíč SHA-1 každé verze souboru ale není praktické, navíc v systému neukládáte název souboru, pouze jeho obsah. Tento typ objektu se nazývá blob. Zadáte-li příkaz `cat-file -t` v kombinaci s klíčem SHA-1 objektu, Git vám sdělí jeho typ, ať se jedná o jakýkoli objekt Git.

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Objekty stromu ###

Dalším typem objektu, na který se podíváme, je objekt stromu (tree object), jenž řeší problém ukládání názvu souboru a zároveň umožňuje uložit skupinu souborů dohromady. Git ukládá obsah podobným způsobem jako systém souborů UNIX, jen trochu jednodušeji. Veškerý obsah se ukládá v podobě blobů a objektů stromu. Stromy odpovídají položkám v adresáři UNIX a bloby víceméně odpovídají inodům neboli obsahům souborů. Jeden objekt stromu obsahuje jednu nebo více položek stromu, z nichž každá obsahuje ukazatel SHA-1 na blob nebo podstrom s asociovaným režimem, typem a názvem souboru. Nejnovější strom v projektu „simplegit“ může vypadat například takto:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

Syntaxe `master^{tree}` určuje objekt stromu, na nějž ukazuje poslední revize větve `master`. Všimněte si, že podadresář `lib` není blob, ale ukazatel na jiný strom:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Data, která Git ukládá, vypadají v principu jako na obrázku 9-1.

Insert 18333fig0901.png
Obrázek 9-1. Zjednodušený model dat v systému Git

Můžete si vytvořit i vlastní strom. Git běžně vytváří strom tak, že vezme stav oblasti připravených změn nebo-li indexu a zapíše z nich objekt stromu. Proto chcete-li vytvořit objekt stromu, musíte ze všeho nejdříve připravit soubory k zapsání, a vytvořit tak index. Chcete-li vytvořit index s jediným záznamem – první verzí souboru text.txt – můžete k tomu použít nízkoúrovňový příkaz `update-index`. Tento příkaz lze použít, jestliže chcete uměle přidat starší verzi souboru test.txt do nové oblasti připravených změn. K příkazu je třeba zadat parametr `--add`, neboť tento soubor ve vaší oblasti připravených změn ještě neexistuje (dokonce ještě nemáte ani vytvořenou oblast připravených změn), a parametr `--cacheinfo`, protože soubor, který přidáváte, není ve vašem adresáři, je ale ve vaší databázi. K tomu všemu přidáte režim, SHA-1 a název souboru:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

V tomto případě jste zadali režim `100644`, který znamená, že se jedná o běžný soubor. Dalšími možnostmi režimu jsou `100755`, který označuje spustitelný soubor, a `120000`, který znamená symbolický odkaz. Režim (mode) je převzat z normálních režimů UNIX, jen je podstatně méně flexibilní. Tyto tři režimy jsou jediné platné pro soubory (bloby) v systému Git (ačkoli se pro adresáře a submoduly používají ještě další režimy).

Nyní můžete použít příkaz `write-tree`, jímž zapíšete stav oblasti připravovaných změn neboli indexu do objektu stromu. Tentokrát se obejdete bez parametru `-w`. Příkaz `write-tree` automaticky vytvoří objekt stromu ze stavu indexu, pokud tento strom ještě neexistuje:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Můžete si také ověřit, že jde skutečně o objekt stromu:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Nyní vytvoříte nový strom s druhou verzí souboru test.txt a jedním novým souborem (new.txt):

	$ echo 'new file' > new.txt
	$ git update-index test.txt
	$ git update-index --add new.txt

V oblasti připravených změn nyní máte jak novou verzi souboru test.txt, tak nový soubor new.txt. Uložte tento strom (zaznamenáním stavu oblasti připravených změn neboli indexu do objektu stromu) a prohlédněte si výsledek:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Všimněte si, že tento strom má oba záznamy souborů a že hodnota SHA souboru test.txt je SHA původní „verze 2“ (`1f7a7a`). Jen pro zábavu nyní můžete přidat první strom jako podadresář do tohoto stromu. Stromy můžete do oblasti připravených změn načíst příkazem `read-tree`. V tomto případě můžete načíst existující strom jako podstrom do oblasti připravených změn pomocí parametru `--prefix`, který zadáte k příkazu `read-tree`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Pokud byste vytvořili pracovní adresář z nového stromu, který jste právě zapsali, dostali byste dva soubory na nejvyšší úrovni pracovního adresáře a podadresář `bak`, obsahující první verzi souboru test.txt. Data, která Git pro tyto struktury obsahuje, si můžete představit jako ilustraci na obrázku 9-2.

Insert 18333fig0902.png
Obrázek 9-2. Struktura obsahu vašich současných dat Git

### Objekty revize ###

Máte vytvořeny tři stromy označující různé snímky vašeho projektu, jež chcete sledovat. Původního problému jsme se však stále nezbavili: musíte si pamatovat všechny tři hodnoty SHA-1, abyste mohli snímky znovu vyvolat. Nemáte také žádné informace o tom, kdo snímky uložil, kdy byly uloženy a proč se tak stalo. Toto jsou základní informace, které obsahuje objekt revize.

Pro vytvoření objektu revize zavolejte příkaz `commit-tree` a zadejte jeden SHA-1 stromu a eventuální objekty revize, které mu bezprostředně předcházely. Začněte prvním stromem, který jste zapsali:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Nyní se můžete podívat na nově vytvořený objekt revize. Použijte příkaz `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Formát objektu revize je prostý. Udává strom nejvyšší úrovně pro snímek projektu v tomto místě; informace o autorovi řešení/autorovi změny revize získané z konfiguračního nastavení `user.name` a `user.email`, spolu s aktuálním časovým údajem; poté následuje prázdný řádek a za ním zpráva k revizi.

Dále zapíšete i zbylé dva objekty revize. Oba budou odkazovat na revizi, která jim bezprostředně předcházela:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Všechny tři tyto objekty revizí ukazují na jeden ze tří stromů snímku, který jste vytvořili. Může se to zdát zvláštní, ale nyní máte vytvořenu skutečnou historii revizí Git, kterou lze zobrazit příkazem `git log` spuštěným pro hodnotu SHA-1 poslední revize:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Úžasné! Právě jste vytvořili historii Git jen na základě nízkoúrovňových operací, bez použití front-endů. To je v podstatě také to, co se odehrává, když zadáte příkazy jako `git add` nebo `git commit` – Git uloží bloby souborů, které byly změněny, akutalizuje index, uloží stromy a zapíše objekty revize, které referencí odkazují na stromy nejvyšší úrovně a revize, které jim bezprostředně předcházely. Tyto tři základní objekty Git – bloby, stromy a revize – jsou nejprve uloženy jako samostatné soubory do adresáře `.git/objects`. Toto jsou všechny objekty v ukázkovém adresáři spolu s komentářem k tomu co obsahují:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Pokud byste hledali vztahy mezi všemi interními ukazateli, vyšel by vám celý diagram objektů – viz obrázek 9-3.

Insert 18333fig0903.png
Obrázek 9-3. Všechny objekty v adresáři Git

### Ukládání objektů ###

Už jsem zmínil, že se spolu s obsahem ukládá také záhlaví (header). Zaměřme se teď chvíli na to, jak Git ukládá své objekty. Uvidíte, jak lze uložit objekt blobu – v našem případě řetězec „what is up, doc?“ – interaktivně v skriptovacím jazyce Ruby. Interaktivní režim Ruby spustíte příkazem `irb`:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git vytvoří záhlaví, které bude začínat typem objektu, jímž je v našem případě blob. Poté vloží mezeru, za níž bude následovat velikost obsahu a na konec nulový byte:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git vytvoří řetězec ze záhlaví a původního obsahu a vypočítá kontrolní součet SHA-1 tohoto nového obsahu. V Ruby můžete hodnotu SHA-1 daného řetězce spočítat tak, že příkazem `require` připojíte knihovnu pro počítání SHA1 a zavoláte `Digest::SHA1.hexdigest()` s daným řetězcem:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git zkomprimuje nový obsah metodou zlib, která je obsažena v knihovně zlib. Nejprve je třeba vyžádat si knihovnu a poté na obsah spustit příkaz `Zlib::Deflate.deflate()`:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Na závěr zapíšete obsah zkomprimovaný metodou zlib do objektu na disku. Musíte tu určit cestu k objektu, který chcete zapsat (první dva znaky hodnoty SHA-1 budou název podadresáře, zbývajících 38 znaků bude tvořit název souboru v tomto adresáři). Pokud podadresář neexistuje, můžete ho v jazyce Ruby vytvořit pomocí funkce `FileUtils.mkdir_p()`. Poté zadejte `File.open()` pro otevření souboru a voláním `write()` na vzniklý identifikátor souboru zapište do souboru právě zkomprimovaný (zlib) obsah:

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

A je hotovo. Právě jste vytvořili platný objekt blobu Git. Všechny objekty Git se ukládají stejným způsobem, jen s odlišným typem. Místo řetězce blob bude záhlaví začínat řetězcem „commit“ (u revize) nebo „tree“ (u stromu). A navíc, zatímco obsahem blobu může být téměř cokoliv, obsah revize nebo stromu má velmi specifický formát.

## Reference Git ##

Chcete-li si prohlédnout celou svou historii, můžete zadat příkaz `git log 1a410e`. Problém je v tom, že si k prohlížení historie a nalezení objektů stále ještě musíte pamatovat, že poslední revizí byla `1a410e`. Hodil by se soubor, do nějž budete pod jednoduchým názvem ukládat hodnotu SHA-1. Tento ukazatel pro vás bude srozumitelnější než nevlídná hodnota SHA-1.

V systému Git se těmto ukazatelům říká reference (angl. „references“ nebo „refs“). Soubory, které obsahují hodnoty SHA-1, najdete v adresáři `.git/refs`. V aktuálním projektu nejsou v tomto adresáři žádné soubory, zatím tu najdete jen jednoduchou strukturu:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Chcete-li vytvořit novou referenci, díky níž si budete pamatovat, kde se nachází vaše poslední revize, lze to technicky provést velmi jednoduše:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Nyní můžete v příkazech Git používat „head“ referenci, kterou jste právě vytvořili, místo hodnoty SHA-1:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Tím vás nenabádám, abyste přímo editovali soubory referencí. Git zná bezpečnější metodu, jak referenci aktualizovat: příkaz `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

A to je také skutečná podstata větví v systému Git. Jedná se o jednoduché ukazatele, neboli reference na „hlavu“ (angl. head) jedné linie práce. Chcete-li vytvořit větev zpětně na druhé revizi, můžete zadat:

	$ git update-ref refs/heads/test cac0ca

Vaše větev bude obsahovat pouze práci od této revize níže:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Vaše databáze Git bude nyní v principu vypadat tak, jak je znázorněno na obrázku 9-4.

Insert 18333fig0904.png
Obrázek 9-4. Objekty v adresáři Git s referencemi větve „head“

Spouštíte-li příkaz typu `git branch (název větve)`, Git ve skutečnosti spustí příkaz `update-ref` a vloží hodnotu SHA-1 poslední revize větve, na níž se nacházíte, do nové reference, kterou chcete vytvořit.

### Soubor HEAD ###

Nyní se však nabízí otázka, jak může Git při spuštění příkazu `git branch (název větve)` znát hodnotu SHA-1 poslední revize. Odpověď zní: soubor HEAD. Soubor HEAD je symbolická reference na větev, na níž se právě nacházíte. Symbolickou referencí myslím to, že na rozdíl od normálních referencí většinou neobsahuje hodnotu SHA-1, ale spíš ukazatel na jinou referenci. Pokud se na soubor podíváte, můžete v něm najít třeba následující:

	$ cat .git/HEAD
	ref: refs/heads/master

Spustíte-li příkaz `git checkout test`, Git aktualizuje soubor do následující podoby:

	$ cat .git/HEAD
	ref: refs/heads/test

Spustíte-li příkaz `git commit`, systém vytvoří objekt revize, jehož rodičem bude hodnota SHA-1, na niž ukazuje reference v souboru HEAD.

Soubor můžete editovat také ručně, ale opět existuje i bezpečnější příkaz: `symbolic-ref`. Hodnotu souboru HEAD můžete načíst tímto příkazem:

	$ git symbolic-ref HEAD
	refs/heads/master

Hodnotu pro soubor HEAD můžete také nastavit:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD
	ref: refs/heads/test

Nelze však zadat symbolickou referenci mimo adresář refs:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Značky ###

Už jsme se seznámili se třemi základními typy objektů. Jenže existuje ještě čtvrtý. Objekt značky se v mnohém podobá objektu revize – obsahuje autora značky, datum, zprávu a ukazatel. Hlavním rozdílem je, že objekt značky ukazuje na revizi, zatímco objekt revize na strom. Podobá se také referenci větve, jen se nikdy nepřesouvá. Stále ukazuje na stejnou revizi, jen jí dává hezčí jméno.

Jak jsme zmínili už v kapitole 2, existují dva typy značek: anotované a prosté. Prostou značku lze vytvořit spuštěním například tohoto příkazu:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

To je celá prostá značka – větev, která se nikdy nepřemisťuje. Anotovaná značka je už složitější. Vytvoříte-li anotovanou značku, Git vytvoří objekt značky a zapíše referenci, která na objekt ukazuje (neukazuje tedy na samotnou revizi). To je dobře vidět, vytvoříte-li anotovanou značku (`-a` udává, že se jedná o anotovanou značku):

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 -m 'test tag'

Pro objekt byla vytvořena tato hodnota SHA-1:

	$ cat .git/refs/tags/v1.1
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Nyní pro tuto hodnotu SHA-1 spusťte příkaz `cat-file`:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Všimněte si, že záznam objektu ukazuje na hodnotu revize SHA-1, k níž jste značku přidali. Měli byste také vědět, že nemusí ukazovat na revizi. Značkou můžete označit jakýkoli objekt Git. Ve zdrojovém kódu systému Git správce například vložil svůj veřejný klíč GPG jako objekt blobu a ten označil značkou. Veřejný klíč můžete zobrazit příkazem

	$ git cat-file blob junio-gpg-pub

spuštěným ve zdrojovém kódu Git. Také jádro Linuxu obsahuje objekt značky, který neukazuje na revizi. První vytvořená značka ukazuje na první strom importu zdrojového kódu.

### Reference na vzdálené repozitáře ###

Třetím typem reference, s níž se setkáte, je reference na vzdálený repozitář. Přidáte-li vzdálený repozitář a odešlete do něj revize, Git v adresáři `refs/remotes` uloží pro každou větev hodnotu, kterou jste do tohoto repozitáře naposled odesílali. Můžete například přidat vzdálený repozitář `origin` a odeslat do něj větev `master`:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Poté se můžete podívat, jakou podobu měla větev `master` na vzdáleném serveru `origin`, když jste s ním naposledy komunikovali. Pomůže vám s tím soubor `refs/remotes/origin/master`:

	$ cat .git/refs/remotes/origin/master
	ca82a6dff817ec66f44342007202690a93763949

Reference na vzdálené repozitáře se od větví (reference `refs/heads`) liší zejména tím, že nelze provést jejich checkout. Git je přemisťuje jako záložky poslední známé pozice těchto větví na serveru.

## Balíčkové soubory ##

Vraťme se zpět do databáze objektů vašeho testovacího repozitáře Git. V současné chvíli máte 11 objektů: 4 bloby, 3 stromy, 3 revize a 1 značku.

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git komprimuje obsah těchto souborů metodou zlib a uložená data tak nejsou příliš velká. Všechny tyto soubory zabírají dohromady pouhých 925 bytů. Do repozitáře tak nyní přidáme větší objem dat, na němž si budeme moci ukázat jednu zajímavou funkci systému Git. Z knihovny Grit, s níž jsme pracovali před časem, přidejte soubor „repo.rb“. Je to soubor se zdrojovým kódem o velikosti asi 12 kB:

	$ curl -L https://raw.github.com/mojombo/grit/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Pokud se podíváte na výsledný strom, uvidíte hodnotu SHA-1, kterou soubor repo.rb dostal pro objekt blobu:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Pomocí příkazu git cat-file zjistíte aktuální velikost objektu:

	$ du -b .git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	4102	.git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e

Nyní soubor trochu upravíme a uvidíme, co se stane:

	$ echo '# testing' >> repo.rb
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Prohlédněte si strom vytvořený touto revizí a uvidíte jednu zajímavou věc:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Nyní jde o úplně jiný blob. Přestože jste na konec 400řádkového souboru vložili jen jeden jediný řádek, Git uložil nový obsah jako úplně nový objekt:

	$ du -b .git/objects/05/408d195263d853f09dca71d55116663690c27c
	4109	.git/objects/05/408d195263d853f09dca71d55116663690c27c

Na disku teď máte dva téměř identické 12kB objekty. Nebylo by krásné, kdyby Git mohl uložit jeden z nich v plné velikosti, ale druhý už jen jako rozdíl mezi oběma těmito objekty?

A podívejme, ono to jde. Prvotní formát, v němž Git ukládá objekty na disku, se nazývá volný formát objektů (loose object format). Při vhodných příležitostech však Git sbalí několik těchto objektů do jediného binárního souboru, jemuž se říká „balíčkový“ (packfile). Tento soubor šetří místo na disku a zvyšuje výkon. Git k tomuto kroku přistoupí, pokud máte příliš mnoho volných objektů, pokud ručně spustíte příkaz `git gc` nebo jestliže odesíláte revize na vzdálený server. Chcete-li vidět, jak proces probíhá, můžete systému Git ručně zadat, aby objekty zabalil. Zadejte příkaz `git gc`:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

Podíváte-li se do adresáře s objekty, zjistíte, že většina objektů zmizela. Zato se objevily dva nové:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

Objekty, které zůstaly, jsou bloby, na něž neukazuje žádná revize, v našem případě bloby z příkladů „what is up, doc?“ a „test content“, které jsme vytvořili před časem. Jelikož jste je nikdy nevložili do žádné z revizí, Git je považuje za volné a nezabalil je do nového balíčkového souboru.

Ostatní soubory jsou v novém balíčkovém souboru a indexu. Balíčkový soubor je jediný soubor, v němž je zabalen obsah všech objektů odstraněných ze systému souborů. Index je soubor, který obsahuje ofsety do tohoto balíčkového souboru, díky nimž lze rychle vyhledat konkrétní objekt. Hlavní předností balíčkového souboru je jeho velikost. Přestože objekty na disku zabíraly před spuštěním příkazu `gc` celkem asi 12 kB, nový soubor má pouze 6 kB. Zabalením objektů jste zredukovali nároky na místo na polovinu.

Jak to Git dělá? Při balení objektů vyhledá Git soubory, které mají podobný název a podobnou velikost, a uloží pouze rozdíly mezi jednotlivými verzemi souboru. Do balíčkového souboru můžete ostatně nahlédnout a přesvědčit se, čím Git ušetřil místo. Nízkoúrovňový příkaz `git verify-pack` umožňuje prohlížet, co bylo zabaleno:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1 \
	  05408d195263d853f09dca71d55116663690c27c
	ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Blob `9bc1d`, který, jak si možná vzpomínáte, byl první verzí souboru repo.rb, odkazuje na blob `05408`, který byl druhou verzí tohoto souboru. Třetí sloupec výpisu udává velikost objektu v balíčku. Můžete si tak všimnout, že blob `05408` zabírá 12 kB z celkové velikosti souboru, zatímco blob `9bc1d` pouze 7 bytů. Za povšimnutí dále stojí, že byla v plné velikosti ponechána druhá verze souboru, původní verze byla uložena ve formě rozdílů. Je to z toho důvodu, že rychlejší přístup budete pravděpodobně potřebovat spíš k aktuálnější verzi souboru.

Na celém balíčku je navíc příjemné, že ho můžete kdykoli znovu zabalit do nové podoby. Git čas od času „přebalí“ celou vaši databázi automaticky a pokusí se tím ušetřit další místo. Totéž lze kdykoli provést i ručně spuštěním příkazu `git gc`.

## Refspec ##

V celé této knize jsme používali jednoduché mapování ze vzdálených větví do lokálních referencí. Mapování však může být i komplexnější.
Řekněme, že přidáte například tento vzdálený repozitář:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

Přidáte tím novou část do souboru `.git/config`, určíte název vzdáleného serveru (`origin`), URL vzdáleného repozitáře a refspec pro vyzvednutí dat:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Refspec má následující formát: fakultativní znak `+`, za nímž následuje `<src>:<dst>`, kde `<src>` je vzor pro referenci na straně vzdáleného serveru a `<dst>` je lokální umístění, kam mají být tyto reference zapsány. Znak `+` systému Git říká, aby aktualizoval referenci i v případě, že nesměřuje „rychle vpřed“.

Ve výchozím případě, který se automaticky zapisuje příkazem `git remote add`, Git vyzvedne všechny reference z adresáře `refs/heads/` na serveru a zapíše je do lokálního adresáře `refs/remotes/origin/`. Je-li tedy na serveru hlavní větev `master`, lokálně lze získat přístup k jejímu logu některým z příkazů:

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Všechny tři jsou přitom ekvivalentní, protože Git vždy rozšíří jejich podobu na `refs/remotes/origin/master`.

Pokud ale raději chcete, aby Git pokaždé stáhl pouze větev `master` a nestahoval žádné jiné větve na vzdáleném serveru, změňte řádek příkazu fetch na:

	fetch = +refs/heads/master:refs/remotes/origin/master

Toto je výchozí vzorec refspec pro příkaz `git fetch` pro tento vzdálený server. Chcete-li nějakou akci provést pouze jednou, můžete použít refspec také na příkazovém řádku. Chcete-li stáhnout větev `master` ze vzdáleného serveru do lokálního adresáře `origin/mymaster`, můžete zadat příkaz:

	$ git fetch origin master:refs/remotes/origin/mymaster

Použít lze také kombinaci několika vzorců refspec. Několik větví můžete přímo z příkazového řádku stáhnout například takto:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

V tomto případě bylo odeslání hlavní větve odmítnuto, protože reference nesměřovala „rychle vpřed“. Odmítnutí serveru můžete potlačit zadáním znaku `+` před vzorec refspec.

V konfiguračním souboru můžete také použít více vzorců refspec pro vyzvedávání dat. Chcete-li pokaždé vyzvednout hlavní větev a větev „experiment“, vložte do něj tyto dva řádky:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Ve vzorci nelze použít částečné nahrazení, např. toto zadání by bylo neplatné:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Místo nich však můžete využít možností jmenného prostoru. Jestliže pracujete v QA týmu, který odesílá několik větví, a vy chcete stáhnout hlavní větev a všechny větve QA týmu, avšak žádné jiné, můžete použít například takovouto část konfigurace:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

Jestliže používáte komplexní pracovní proces, kdy QA tým odesílá větve, vývojáři odesílají větve a integrační týmy odesílají větve a spolupracují na nich, můžete takto jednoduše využít možností, jež vám jmenný prostor nabízí.

### Odesílání vzorců refspec ###

Je sice hezké, že můžete tímto způsobem vyzvedávat reference na základě jmenného prostoru, jenže jak vůbec QA tým dostane své větve do jmenného prostoru `qa/`? Tady vám při odesílání větví pomůže vzorec refspec.

Chce-li QA tým odeslat větev `master` do adresáře `qa/master` na vzdáleném serveru, může použít příkaz:

	$ git push origin master:refs/heads/qa/master

Chcete-li, aby toto Git provedl automaticky pokaždé, když spustíte příkaz `git push origin`, můžete do konfiguračního souboru vložit hodnotu `push`:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Touto hodnotou zajistíte, že bude příkaz `git push origin` odesílat lokální větev `master` do vzdálené větve `qa/master`.

### Mazání referencí ###

Vzorce refspec můžete využít také k mazání referencí ze vzdáleného serveru. Spustit lze například příkaz následujícího znění:

	$ git push origin :topic

Vynecháte-li z původního vzorce refspec ve tvaru `<src>:<dst>` část `<src>`, říkáte v podstatě, aby byla větev „topic“ na vzdáleném serveru nahrazena ničím, čímž ji smažete.

## Přenosové protokoly ##

Git přenáší data mezi dvěma repozitáři dvěma základními způsoby: prostřednictvím protokolu HTTP a prostřednictvím takzvaných chytrých protokolů používaných při přenosu `file://`,`ssh://` a `git://`. Tato část se ve stručnosti zaměří na to, jak tyto dva základní protokoly fungují.

### Hloupý protokol ###

V souvislosti s přenosem dat systému Git prostřednictvím HTTP se často mluví o hloupém protokolu (dumb protocol), protože během přenosu nevyžaduje na straně serveru žádný specifický kód Git. Proces vyzvednutí dat je sledem požadavků GET, kdy klient dokáže předpokládat rozložení repozitáře Git na serveru. Podívejme se na proces `http-fetch` pro knihovnu „simplegit“:

	$ git clone http://github.com/schacon/simplegit-progit.git

První věcí, kterou příkaz udělá, je stažení souboru `info/refs`. Tento soubor se zapisuje příkazem `update-server-info`. To je také důvod, proč ho je nutné zapnout jako zásuvný modul `post-receive`, aby přenos dat prostřednictvím protokolu probíhal správně:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Nyní máte k dispozici seznam SHA a referencí na vzdálené repozitáře. Dále budete chtít zjistit, co je referencí HEAD, abyste mohli po dokončení procesu provést checkout.

	=> GET HEAD
	ref: refs/heads/master

Po dokončení procesu tedy budete muset přepnout na větev `master`.
V tomto okamžiku je vše připraveno a můžete zahájit proces procházení. Protože je vaším výchozím bodem objekt revize `ca82a6`, jak jste zjistili v souboru `info/refs`, začnete vyzvednutím tohoto objektu:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

Tímto postupem získáte jeden objekt. Ten je na serveru ve volném formátu a vy jste ho vyzvedli statickým požadavkem GET HTTP. Objekt můžete rozbalit, extrahovat záhlaví a prohlédnout si obsah revize:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Máte však ještě další dva objekty, které potřebujete načíst: `cfda3b`, což je strom obsahu, na nějž ukazuje revize, kterou jsme právě načetli; druhým objektem je `085bb3`, což je rodič revize:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

Tím získáte další objekt revize. Načtěte objekt stromu:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Uf, zdá se, že objekt stromu není na serveru ve volném formátu, proto byla vygenerována chyba 404. Chyba má hned několik příčin. Objekt by mohl být v jiném repozitáři nebo by mohl být v tomto repozitáři, avšak v balíčkovém souboru. Git nejprve zjistí, zda jsou k dispozici alternativní repozitáře:

	=> GET objects/info/http-alternates
	(empty file)

Je-li výsledkem hledání seznam alternativních adres URL, Git se v těchto repozitářích pokusí najít volné a balíčkové soubory. Jedná se o užitečný mechanismus pro projekty, které byly odštěpeny od jiného projektu a sdílejí jeho objekty. Protože však seznam v tomto případě neobsahuje žádné alternativní repozitáře, váš objekt musí být v balíčkovém souboru. Chcete-li zjistit, jaké balíčkové soubory jsou na serveru dostupné, pomůže vám soubor `objects/info/packs`, který obsahuje jejich seznam (rovněž generován příkazem `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Na serveru je pouze jeden balíčkový soubor, takže váš objekt musí být evidentně v něm. Pro jistotu se však ještě podíváte do souboru indexu. To je rovněž užitečné, máte-li na serveru více balíčkových souborů. Zjistíte tak, který z nich obsahuje hledaný objekt:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Nyní, když máte index balíčkového souboru, můžete ověřit, zda se v něm nachází váš objekt. Index uvádí hodnoty SHA všech objektů obsažených v balíčkovém souboru a ofsety k těmto objektům. Váš objekt se v tomto souboru nachází, a proto neváhejte a stáhněte celý balíčkový soubor:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Stáhli jste objekt stromu, a můžete tak pokračovat v procházení revizí. Všechny jsou navíc součástí balíčkového souboru, který jste právě stáhli, a proto nebude nutné zadávat serveru žádné další požadavky. Git provede checkout pracovní kopie větve `master`, na niž ukazovala reference HEAD, kterou jste stáhli na začátku.

Celý výstup tohoto procesu vypadá následovně:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### Chytrý protokol ###

Metoda přenosu HTTP je jednoduchá, avšak málo výkonná. Rozšířenější metodou přenosu dat je použití chytrého protokolu. Tyto protokoly mají na vzdáleném konci proces, který inteligentně spolupracuje se systémem Git. Umí načítat lokální data a zjistí, co klient vlastní a co potřebuje. Podle toho pro něj vygeneruje potřebná data. Existují dvě sady procesů pro přenos dat: jeden pár pro upload dat a jeden pár pro jejich stahování.

#### Upload dat ####

K uploadu dat do vzdáleného procesu používá Git procesy `send-pack` a `receive-pack`. Proces `send-pack` se spouští na klientovi a připojuje se k procesu `receive-pack` na straně vzdáleného serveru.

Řekněme například, že ve svém projektu spustíte příkaz `git push origin master` a `origin` je definován jako URL používající protokol SSH. Git spustí proces `send-pack`, který iniciuje spojení se serverem přes SSH. Na vzdáleném serveru se pokusí spustit příkaz prostřednictvím volání SSH:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Příkaz `git-receive-pack` okamžitě odpoví jedním řádkem pro každou referenci, kterou v danou chvíli obsahuje – v tomto případě je to pouze větev `master` a její SHA. První řádek uvádí rovněž seznam schopností serveru (zde `report-status` a `delete-refs`).

Každý řádek začíná 4bytovou hexadecimální hodnotou, která udává, jak dlouhý je zbytek řádku. Váš první řádek začíná hodnotou 005b, tedy 91 v hexadecimální soustavě, což znamená, že na tomto řádku zbývá 91 bytů. Další řádek začíná hodnotou 003e (tedy 62), což znamená dalších 62 bytů. Následující řádek je 0000 – touto kombinací server označuje konec seznamu referencí.

Nyní, když zná proces `send-pack` stav serveru, určí, jaké revize má, které přitom nejsou na serveru. Pro každou referenci, která bude tímto odesláním aktualizována, sdělí proces `send-pack` tuto informaci procesu `receive-pack`. Pokud například aktualizujete větev `master` a přidáváte větev `experiment`, odpověď procesu `send-pack` může mít následující podobu:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

Hodnota SHA-1 ze samých nul znamená, že na tomto místě předtím nic nebylo, protože přidáváte větev „experiment“. Pokud byste mazali referenci, viděli byste pravý opak: samé nuly na pravé straně.

Git odešle jeden řádek pro každou referenci, kterou aktualizujete. Řádek obsahuje starou hodnotu SHA, novou hodnotu SHA a referenci, která je aktualizována. První řádek navíc obsahuje schopnosti klienta. Jako další krok nahraje klient balíčkový soubor se všemi třemi objekty, které na serveru dosud nejsou. Na závěr procesu server oznámí, zda se akce zdařila, nebo nezdařila:

	000Aunpack ok

#### Stahování dat ####

Do stahování dat se zapojují procesy `fetch-pack` a `upload-pack`. Klient iniciuje proces `fetch-pack`, který vytvoří připojení k procesu `upload-pack` na straně vzdáleného serveru a dojedná, která data budou stažena.

Existují i jiné způsoby, jak iniciovat proces `upload-pack` ve vzdáleném repozitáři. Můžete ho spustit prostřednictvím SSH stejným způsobem jako proces `receive-pack`. Proces můžete iniciovat také prostřednictvím démona Git, který na serveru standardně naslouchá portu 9418. Proces `fetch-pack` pošle démonovi po připojení data, která mají následující podobu:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Informace začínají 4 byty, které uvádějí, jaké množství dat následuje; po nich následuje příkaz, který má být spuštěn, nulový byte, název hostitelského serveru a na závěr další nulový byte. Démon Git zkontroluje, zda je příkaz skutečně možné spustit, zda existuje daný repozitář a zda jsou oprávnění k němu veřejná. Je-li vše v pořádku, spustí démon Git proces `upload-pack` a předá mu svůj požadavek.

Vyzvedáváte-li data přes SSH, spustí místo toho proces `fetch-pack` následující:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

V obou případech zašle po připojení procesu `fetch-pack` proces `upload-pack` zpět následující informace:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Informace se nápadně podobají těm, jimiž odpovídá proces `receive-pack`, liší se však schopnosti. Kromě toho pošle proces zpět referenci HEAD, aby klient v případě, že se jedná o klonování, věděl, kam přepnout.

V tomto okamžiku proces `fetch-pack` zjistí, jaké objekty má, a vytvoří odpověď s objekty, které potřebuje. Odpověď má tvar „want“ (chci) a SHA požadovaných objektů. Naopak objekty, které už vlastní, uvádí kombinací výrazu „have“ (mám) a hodnoty SHA. Výpis je ukončen výrazem „done“, který iniciuje odeslání požadovaného balíčkového souboru nebo dat procesem `upload-pack`:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

Toto jsou pouze základní případy přenosových protokolů. Ve složitějších případech podporuje klient schopnosti `multi_ack` nebo `side-band`. Uvedený příklad ale dobře ilustruje základní komunikaci tam a zpět, jak ji používají procesy chytrých protokolů.

## Správa a obnova dat ##

Občas budete patrně nuceni přistoupit k menšímu úklidu – uvést repozitář do kompaktnější podoby, vyčistit importovaný repozitář nebo obnovit ztracenou práci. Tato část se na některé z těchto scénářů zaměří.

### Správa ###

Git čas od času automaticky spustí příkaz „auto gc“. Ve většině případů neprovede tento příkaz vůbec nic. Pokud však identifikuje příliš mnoho volných objektů (objektů nezabalených do balíčkového souboru) nebo balíčkových souborů, spustí Git plnou verzi příkazu `git gc`. Písmena `gc` jsou zkratkou anglického výrazu „garbage collect“ (sběr odpadků). Příkaz provádí hned několik věcí: sbírá všechny volné objekty a umisťuje je do balíčkových souborů, spojuje balíčkové soubory do jednoho velkého a odstraňuje objekty, jež nejsou dostupné z žádné revize a jsou starší několika měsíců.

Příkaz auto gc můžete spustit také ručně:

	$ git gc --auto

I tentokrát platí, že příkaz většinou neprovede nic. Aby Git spustil skutečný příkaz gc, musíte mít kolem 7000 volných objektů nebo více než 50 balíčkových souborů. Tyto hodnoty můžete změnit podle svých potřeb v konfiguračním nastavení `gc.auto` a `gc.autopacklimit`.

Další operací, kterou `gc` provede, je zabalení referencí do jediného souboru. Řekněme, že váš repozitář obsahuje tyto větve a značky:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

Spustíte-li příkaz `git gc`, tyto soubory z adresáře `refs` zmizí. Git je pro zvýšení účinnosti přesune do souboru `.git/packed-refs`, jenž má následující podobu:

	$ cat .git/packed-refs
	# pack-refs with: peeled
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

Pokud některou referenci aktualizujete, Git nebude tento soubor upravovat, ale zapíše nový soubor do adresáře `refs/heads`. Je-li třeba získat hodnotu SHA pro konkrétní referenci, Git se tuto referenci pokusí vyhledat nejprve v adresáři `refs` a poté, jako záložní možnost, v souboru `packed-refs`. Pokud však nemůžete najít některou z referencí v adresáři `refs`, bude patrně v souboru `packed-refs`.

Všimněte si také posledního řádku souboru, který začíná znakem `^`. Tento řádek znamená, že značka bezprostředně nad ním je anotovaná a tento řádek je revize, na niž tato anotovaná značka ukazuje.

### Obnova dat ###

Někdy se může stát, že nedopatřením přijdete o revizi Git. Většinou k tomu dochází tak, že násilím smažete větev, která uchovávala část vaší práce, a vy po čase zjistíte, že byste tuto větev přece jen potřebovali. Stejně tak jste mohli provést tvrdý reset větve a tím zavrhnout revize, z nichž nyní něco potřebujete. Pokud se už něco takového stane, jak dostanete své revize zpět?

Uvedeme příklad, při němž resetujeme hlavní větev v testovacím repozitáři na jednu ze starších revizí a poté ztracené revize obnovíme. Nejprve se podíváme, kde se váš repozitář v současnosti nachází:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Nyní vrátíme větev `master` zpět na prostřední revizi:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Účinně jsme se zbavili horních dvou revizí. Neexistuje žádná větev, z níž by byly tyto revize dostupné. Budete muset najít hodnotu SHA nejnovější revize a přidat větev, která na ni bude ukazovat. Problém tedy spočívá v určení hodnoty SHA nejnovější revize, protože nepředpokládáme, že si ji pamatujete.

Nejrychlejší cestou často bývá použít nástroj `git reflog`. Git během vaší práce v tichosti zaznamenává, kde se nachází ukazatel HEAD (pokaždé, když se změní jeho pozice). Vždy když zapíšete revizi nebo změníte větve, je reflog aktualizován. Reflog se také aktualizuje s každým spuštěním příkazu `git update-ref` – o důvod víc používat tento příkaz a nezapisovat hodnotu SHA přímo do souborů referencí, jak už jsme uváděli v části „Reference Git“ v této kapitole. Spuštěním příkazu `git reflog` zjistíte, kde jste se nacházeli v libovolném okamžiku:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Vidíme tu obě revize, jichž jsme se zbavili, ale není tu k nim mnoho informací. Chcete-li zobrazit stejné informace v užitečnějším formátu, můžete spustit příkaz `git log -g`, jímž získáte normální výstup příkazu log pro reflog.

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

Zdá se, že revize úplně dole je hledanou ztracenou revizí. Můžete ji obnovit tak, že na ní vytvoříte novou větev. Na revizi můžete vytvořit například větev `recover-branch` (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Výborně, nyní máte větev s názvem `recover-branch`, která se nachází na bývalé pozici větve `master`. První dvě revize jsou opět dostupné.
Můžeme ale také uvažovat situaci, že ztracené revize nebyly ve výpisu reflog k nalezení. Tento stav můžeme simulovat tak, že odstraníme větev `recover-branch` a smažeme reflog. První dvě revize tak nejsou odnikud dostupné:

	$ git branch -D recover-branch
	$ rm -Rf .git/logs/

Protože se data pro reflog uchovávají v adresáři `.git/logs/`, nemáte evidentně žádný reflog. Jak lze tedy v tuto chvíli ztracenou revizi obnovit? Jednou z možností je použít nástroj `git fsck`, který zkontroluje integritu vaší databáze. Pokud příkaz spustíte s parametrem `--full`, zobrazí vám všechny objekty, na něž neukazuje žádný jiný objekt:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

V tomto případě je vaše ztracená revize uvedena výrazem „dangling commit“. Nyní ji můžete obnovit stejným způsobem: přidejte novou větev, která bude ukazovat na její SHA.

### Odstraňování objektů ###

Systém Git nabízí velké množství úžasných funkcí a možností. Je však jedna věc, která vám může způsobovat problém. Je jí fakt, že příkaz `git clone` stáhne vždy celou historii projektu, všechny verze všech souborů.

To je v pořádku, je-li projektem zdrojový kód, neboť Git je vysoce optimalizován ke kompresi těchto dat. Pokud však někdo v kterémkoli místě historie projektu přidal jeden obrovský soubor, bude se stahovat při každém dalším klonování repozitáře. Nic na tom nezmění, ani pokud tento velký soubor hned v příští revizi z projektu odstraníte. Protože se nachází v historii, stále bude součástí všech klonů. To může způsobovat velké problémy, pokud konvertujete repozitáře Subversion nebo Perforce do systému Git. Protože v těchto systémech nestahujete celou historii, nebývá s vkládáním velkých souborů problém. Pokud provedete import do systému Git z jiného systému nebo jiným způsobem, zjistíte, že je váš repozitář výrazně větší, než by měl být. Nabízím návod, jak vyhledat a odstranit velké objekty.

Dejte však pozor, tento postup může být pro vaši historii revizí katastrofický. Přepíše všechny objekty revizí směrem dolů od nejstaršího stromu, který musíte pro odstranění reference na velký soubor upravit. Pokud po této metodě sáhnete hned po importu, než mohl kdokoli založit na revizi svou práci, nemusíte se ničeho obávat. V opačném případě budete muset upozornit všechny přispěvatele, že musí přeskládat svou práci na vaše nové revize.

Vyzkoušíme to na situaci, kdy do svého testovacího repozitáře vložíte velký soubor, v následující revizi ho odstraníte, vyhledáte ho a trvale ho z repozitáře odstraníte. Nejprve do historie přidejte velký objekt:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Ale ne! Vlastně jste nechtěli do projektu vložit tak velký tarball. Raději se ho zbavme:

	$ git rm git.tbz2
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Teď provedete `gc` své databáze, protože chcete zjistit, kolik místa je obsazeno:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

Chcete-li rychle zjistit, kolik místa je obsazeno, můžete použít příkaz `count-objects`:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

Řádek `size-pack` uvádí velikost vašich balíčkových souborů v kilobytech, využity jsou tedy 2 MB. Před zapsáním poslední revize jste využívali přibližně 2 kB. Je tedy jasné, že odstranění souboru z předchozí revize ho neodstranilo z historie. Pokaždé, když bude někdo tento repozitář klonovat, bude muset pro získání malinkého projektu naklonovat celé 2 MB jen proto, že jste jednou omylem přidali velký soubor. Proto ho raději odstraníme.

Nejprve ho budete muset najít. V tomto případě víte, o jaký soubor se jedná. Můžeme ale předpokládat, že to nevíte. Jak se dá zjistit, který soubor nebo soubory zabírají tolik místa? Spustíte-li příkaz `git gc`, všechny objekty jsou v balíčkovém souboru. Velké objekty lze identifikovat spuštěním jiného nízkoúrovňového příkazu, `git verify-pack`, a seřazením podle třetího pole ve výpisu, v němž je uvedena velikost souboru. Na výpis můžete rovněž použít příkaz `tail`, neboť vás beztak zajímá pouze několik posledních (největších) souborů:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

Hledaný velký objekt se nachází úplně dole: 2 MB. Chcete-li zjistit, o jaký soubor se jedná, můžete použít příkaz `rev-list`, který jsme používali už v kapitole 7. Zadáte-li k příkazu `rev-list` parametr `--objects`, výpis bude obsahovat všechny hodnoty SHA revizí a blobů s cestami k souborům, které jsou s nimi asociovány. Tuto kombinaci můžete použít k nalezení názvu hledaného blobu:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Nyní potřebujete odstranit tento soubor ze všech minulých stromů. Pomocí snadného příkazu lze zjistit, jaké revize tento soubor změnil:

	$ git log --pretty=oneline --branches -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Chcete-li tento soubor kompletně odstranit z historie Git, budete muset přepsat všechny revize od `6df76` směrem dolů. Použijte k tomu příkaz `filter-branch`, s nímž jsme se seznámili v kapitole 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

Parametr `--index-filter` je podobný parametru `--tree-filter`, který jsme používali v kapitole 6, jen s tím rozdílem, že příkazem nezměníte soubory načtené na disku, ale oblast připravených změn nebo-li index. Nepomůže odstranit konkrétní soubor příkazem `rm file` nebo podobným. Odstraňte ho raději příkazem `git rm --cached` – soubor musíte odstranit z indexu, ne z disku. Důvodem je rychlost. Git nemusí před spuštěním filtru provádět checkout každé jednotlivé revize na disk a celý proces je tak mnohem, mnohem rychlejší. Pokud chcete, můžete provést stejný úkon i pomocí parametru `--tree-filter`. Zadáte-li k příkazu `git rm` parametr `--ignore-unmatch`, nařídíte systému Git, aby nepovažoval za chybu, jestliže nenajde vzor, který se snažíte odstranit. A konečně požádáte příkaz `filter-branch`, aby přepsal historii až od revize `6df7640` dále, neboť víte, že tady problém začíná. Bez této konkretizace začne proces od začátku a bude trvat zbytečně dlouho.

Vaše historie už neobsahuje referenci na problémový soubor. Obsahuje ho však stále ještě reflog a v adresáři `.git/refs/original` také nová sada referencí, které Git přidal při spuštění příkazu `filter-branch`. Budete je proto muset odstranit a databázi znovu zabalit. Před novým zabalením je třeba odstranit vše, co na tyto staré revize ukazuje:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Podívejme se, kolik místa jste ušetřili.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

Velikost zabaleného repozitáře byla zredukována na 7 kB, což je jistě lepší než 2 MB. Podle hodnoty velikosti je vidět, že se velký objekt stále ještě nachází mezi volnými objekty, a nebyl tedy odstraněn. Nebude ale součástí přenášených dat při odesílání nebo následném klonování, což je pro nás rozhodující. Pokud jste chtěli, mohli jste objekt zcela odstranit příkazem `git prune --expire`.

## Shrnutí ##

Jak doufám, udělali jste si v této kapitole názorný obrázek o tom, jak Git pracuje v pozadí, a do určité míry také o jeho implementaci Seznámili jsme se s celou řadou nízkoúrovňových příkazů, tj. takových, které jsou na nižší úrovni a jsou jednodušší než „vysokoúrovňové příkazy“, jimiž jsme se zabývali ve všech předchozích kapitolách. Poznání, jak Git pracuje na nižší úrovni, by vám mělo pomoci pochopit, proč dělá to, co dělá, a zároveň by vám mělo umožnit napsat vlastní nástroje a podpůrné skripty, pomocí nichž budete moci automatizovat zvolený pracovní postup.

Git jakožto obsahově adresovatelný systém souborů je velmi výkonným nástrojem, který snadno využijete i k jiným účelům než jako pouhý systém VCS. Jsem přesvědčen, že vám nově nabyté znalosti interních principů systému Git pomohou implementovat vlastní užitečné aplikace této technologie a že se i v pokročilých funkcích systému Git budete cítit příjemněji.

## Poznámky k překladu ##

Tento český překlad naleznete v elektronické podobě na http://git-scm.com/book. Jeho zdrojové texty jsou spolu s texty originálu a se zdrojovými texty překladů do ostatních jazyků dostupné na GitHub (https://github.com/progit/progit).

### Historie překladu na GitHub ###

První kroky k překladu Pro Git ve výše zmíněném GitHub projektu pocházejí z klávesnice Jana Matějky ml. (alias Mosquitoe):

    Author: Jan Matějka ml. aka Mosquitoe <...@gmail.com>  2009-08-21 12:15:41
    Committer: Jan Matějka ml. aka Mosquitoe <...@gmail.com>  2009-08-21 12:15:41
    ...
    Branches: master, remotes/origin/master
    Follows:
    Precedes:

        [cs] Initial commit of the Czech version

Vzhledem k následujícím skutečnostem překladu zanechal...

### První kompletní překlad z Edice CZ.NIC ###

Z iniciativy sdružení CZ.NIC byl financován překlad celé knihy, která vyšla jako druhá kniha Edice CZ.NIC v roce 2009, (ISBN: 978-80-904248-1-4). Můžete si ji objednat v tištěné podobě -- viz http://knihy.nic.cz/. Je zde dostupná i volně, v podobě PDF souboru. V předmluvě najdete popis motivace k překladu. Na zadním přebalu knihy naleznete také následující souhrnné informace o autorovi, o knize a o Edici CZ.NIC...

**O autorovi:** Scott Chacon je popularizátorem systému správy verzí Git a pracuje také jako vývojář v Ruby na projektu GitHub.com. Ten umožňuje hosting, sdílení a kooperaci při vývoji kódu v systému Git. Scott je autorem dokumentu Git Internals Peepcode PDF, správcem domovské stránky Git a online knihy Git Community Book. O Gitu přednášel například na konferencích RailsConf, RubyConf, Scotland on Rails, Ruby Kaigi nebo OSCON. Pořádá také školení systému Git pro firmy.

**O knize:** Git je distribuovaný systém pro správu verzí, který se používá zejména při vývoji svobodného a open source softwaru. Git si klade za cíl být rychlým a efektivním nástrojem pro správu verzí. V knize se čtenář seznámí jak se stát rychlým a efektivním při jeho používání. Seznámí se nejen s principy používání, ale také s detaily jak Git funguje interně nebo s možnostmi, které nabízejí některé další doplňkové nástroje.

**O edici:** Edice CZ.NIC je jedním z osvětových projektů správce české domény nejvyšší úrovně. Cílem tohoto projektu je vydávat odborné, ale i populární publikace spojené s internetem a jeho technologiemi. Kromě tištěných verzí vychází v této edici současně i elektronická podoba knih. Ty je možné najít na stránkách knihy.nic.cz

### Zpětná synchronizace s originálem ###

Vzhledem k licenci dokumentu (Attribution-NonCommercial-ShareAlike 3.0 United States (CC BY-NC-SA 3.0)) se nabízí možnost českého překladu vydaného v Edici CZ.NIC dále nekomerčně využít.

V říjnu 2012 zahájil Petr Přikryl převod výše zmíněného PDF do podoby textového souboru využívajícího syntaxe *markdown* (viz https://github.com/pepr/progitCZ/). Prvotním cílem bylo dostat úplný, kvalitní český překlad přímo na server http://git-scm.com/. Druhým cílem byla synchronizace s originálem a doplnění oprav a úprav, které se od doby vydání překladu v Edici CZ.NIC objevily. Třetí cíl vyplývá z prvního a druhého: učinit text překladu živým a dostupným všem, kteří jej budou chtít upravovat a vylepšovat.

Obsah PDF souboru byl nejdříve vyexportován jako text ("Uložit jako - Text..."). Poté byly pro ten účel vytvořenými pythonovskými skripty extrahovány prvky dokumentu (nadpisy, odstavce, odrážky,...) a odstraněny prvky vzniklé sazbou (záhlaví stránek, čísla jednotlivých stránek, ...). V několika mezifázích byl původní text ručně upravován a dalšími pythonovskými skripty převáděn do "čistší" podoby -- bližší strukturou a značkování originálu. Při synchronizaci byla zajištěna identická podoba příkladů kódu. Při kontrole značkování v běžném textu byl původní překlad někdy změněn tak, aby přesněji odpovídal originálu v technickém smyslu (formulace *hlavní větev* nahrazena `master` tam, kde bylo v originálu uvedeno `master`). Synchronizace byla dokončena na začátku prosince 2012.
