# Základy práce se systémem Git #

Pokud jste ochotni přečíst si o systému Git jen jednu kapitolu, měla by to být právě tahle. Tato kapitola popíše všechny základní příkazy, jejichž prováděním strávíte při práci se systémem Git drtivou většinu času. Po přečtení kapitoly byste měli být schopni nakonfigurovat a inicializovat repozitář, spustit a ukončit sledování souborů, připravovat soubory a zapisovat revize. Ukážeme si také, jak nastavit Git, aby ignoroval určité soubory a masky souborů, jak rychle a jednoduše vrátit nežádoucí změny, jak procházet historii projektu a zobrazit změny mezi jednotlivými revizemi a jak posílat soubory do vzdálených repozitářů a naopak z nich soubory zase stahovat.

## Získání repozitáře Git ##

Projekt v systému Git lze získat dvěma základními způsoby. První způsob spočívá v tom, že vezmeme existující projekt nebo adresář a importujeme ho do systému Git. Druhý způsob spočívá v naklonování již existujícího repozitáře Git z jiného serveru.

### Inicializace repozitáře v existujícím adresáři ###

Chcete-li zahájit sledování existujícího projektu v systému Git, přejděte do adresáře projektu a zadejte příkaz:

	$ git init

Příkaz vytvoří nový podadresář s názvem `.git`, který bude obsahovat všechny soubory nezbytné pro repozitář, tzv. kostru repozitáře Git. V tomto okamžiku se z vašeho projektu ještě nic nesleduje. (Více informací o tom, jaké soubory obsahuje právě vytvořený adresář `.git`, naleznete v *kapitole 9*.)

Chcete-li spustit verzování existujících souborů (a ne jen prázdného adresáře), měli byste pravděpodobně zahájit sledování (tracking) těchto souborů a provést první revizi (commit). Můžete tak učinit pomocí několika příkazů `git add`, jimiž určíte soubory, které chcete sledovat, a provedete revizi:

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

K tomu, co přesně tyto příkazy provedou, se dostaneme za okamžik. V této chvíli máte vytvořen repozitář Git se sledovanými soubory a úvodní revizí.

### Klonování existujícího repozitáře ###

Chcete-li vytvořit kopii existujícího repozitáře Git (například u projektu, do nějž chcete začít přispívat), pak příkazem, který hledáte, je `git clone`. Pokud jste zvyklí pracovat s jinými systémy pro správu verzí, jako je například Subversion, jistě jste si všimli, že příkaz zní `clone`, a nikoli `checkout`. Souvisí to s jedním podstatným rozdílem: Git získá kopii téměř všech dat na serveru. Po spuštění příkazu `git clone` budou k historii projektu staženy všechny verze všech souborů. Pokud by někdy poté došlo k poruše disku serveru, lze použít libovolný z těchto klonů na kterémkoli klientovi a obnovit pomocí něj server zpět do stavu, v němž byl v okamžiku klonování (může dojít ke ztrátě některých zásuvných modulů na straně serveru a podobných věcí, ale všechna verzovaná data budou obnovena. Další podrobnosti naleznete v *kapitole 4*).

Repozitář naklonujete příkazem `git clone [url]`. Pokud například chcete naklonovat knihovnu Ruby Git nazvanou Grit, můžete to provést následovně:

	$ git clone git://github.com/schacon/grit.git

Tímto příkazem se vytvoří adresář s názvem `grit`, inicializuje se v něm adresář `.git`, stáhnou se všechna data pro tento repozitář a vytvoří se pracovní kopie nejnovější verze. Přejdete-li do nového adresáře `grit`, uvidíte v něm soubory projektu připravené ke zpracování nebo jinému použití. Pokud chcete naklonovat repozitář do adresáře pojmenovaného jinak než grit, můžete název zadat jako další parametr na příkazovém řádku:

	$ git clone git://github.com/schacon/grit.git mygrit

Tento příkaz učiní totéž co příkaz předchozí, ale cílový adresář se bude jmenovat `mygrit`.

Git nabízí celou řadu různých přenosových protokolů. Předchozí příklad využívá protokol `git://`, můžete se ale setkat také s protokolem `http(s)://` nebo `user@server:/path.git`, který používá přenosový protokol SSH. V *kapitole 4* budou představeny všechny dostupné možnosti, které mohou být pro přístup do repozitáře Git na serveru nastaveny, včetně jejich předností a nevýhod.

## Nahrávání změn do repozitáře ##

Nyní máte vytvořen opravdový gitový repozitář a pracovní kopii souborů k projektu (checkout). Řekněme, že potřebujete udělat pár změn a zapsat snímky těchto změn do svého repozitáře pokaždé, kdy se projekt dostane do stavu, který chcete zaznamenat.

Nezapomeňte, že každý soubor ve vašem pracovním adresáři může být ve dvou různých stavech: *sledován* (tracked) a *nesledován* (untracked). Za *sledované* jsou označovány soubory, které byly součástí posledního snímku. Mohou být ve stavu *změněn* (modified), *nezměněn* (unmodified) nebo *připraven k zapsání* (staged). *Nesledované* soubory jsou všechny ostatní, tedy veškeré soubory ve vašem pracovním adresáři, které nebyly obsaženy ve vašem posledním snímku a nejsou v oblasti připravených změn. Po úvodním klonování repozitáře budou všechny vaše soubory sledované a nezměněné, protože jste právě provedli jejich checkout a dosud jste neudělali žádné změny.

Jakmile začnete soubory upravovat, Git je bude považovat za změněné, protože jste v nich od poslední revize provedli změny. Poté všechny tyto změněné soubory *připravíte k zapsání* (stage) a následně všechny připravené změny zapíšete (commit). A celý cyklus se opakuje. Pracovní cyklus je znázorněn na obrázku 2-1.

Insert 18333fig0201.png
Obrázek 2-1. Cyklus stavů vašich souborů

### Kontrola stavu souborů ###

Hlavním nástrojem na zjišťování stavu jednotlivých souborů je příkaz `git status`. Spustíte-li tento příkaz bezprostředně po klonování, objeví se zhruba následující:

	$ git status
	On branch master
	nothing to commit, working directory clean

To znamená, že žádné soubory nejsou připraveny k zapsání a pracovní adresář je čistý. Jinými slovy, žádné sledované soubory nebyly změněny. Git také neví o žádných nesledovaných souborech, jinak by byly ve výčtu uvedeny. Příkaz vám dále sděluje, na jaké větvi (branch) se nacházíte. Pro tuto chvíli nebudeme situaci komplikovat a výchozí bude vždy hlavní větev (`master` branch). Větve a reference budou podrobně popsány v následující kapitole.

Řekněme, že nyní přidáte do projektu nový soubor, například soubor `README`. Pokud soubor dříve neexistoval a vy spustíte příkaz `git status`, bude nesledovaný soubor uveden takto:

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)

	        README

	nothing added to commit but untracked files present (use "git add" to track)

Vidíte, že nový soubor `README` není sledován, protože je ve výpisu stavů uveden v části „Untracked files“. Není-li soubor sledován, obecně to znamená, že Git ví o souboru, který nebyl v předchozím snímku (v předchozí revizi), a nezařadí ho ani do dalších snímků, dokud mu k tomu nedáte výslovný příkaz. Díky tomu se nemůže stát, že budou do revizí nedopatřením zahrnuty vygenerované binární soubory nebo jiné soubory, které si nepřejete zahrnout. Vy si ale přejete soubor README zahrnout, a proto ho začněme sledovat.

### Sledování nových souborů ###

K zahájení sledování nových souborů se používá příkaz `git add`. Chcete-li zahájit sledování souboru `README`, můžete zadat příkaz:

	$ git add README

Když nyní znovu provedete příkaz k výpisu stavů (git status), uvidíte, že je nyní soubor `README` sledován a připraven k zapsání:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README


Můžeme říci, že je připraven k zapsání, protože je uveden v části „Changes to be committed“, tedy „Změny k zapsání“. Pokud v tomto okamžiku zapíšete revizi, v historickém snímku bude verze souboru z okamžiku, kdy jste spustili příkaz `git add`. Možná si vzpomínáte, že když jste před časem spustili příkaz `git init`, provedli jste potom příkaz `git add (soubory)`. Příkaz jste zadávali kvůli zahájení sledování souborů ve vašem adresáři. Příkaz `git add` je doplněn uvedením cesty buď k souboru, nebo k adresáři. Pokud se jedná o adresář, příkaz přidá rekurzivně všechny soubory v tomto adresáři.

### Příprava změněných souborů k zapsání ###

Nyní provedeme změny v souboru, který už byl sledován. Pokud změníte už dříve sledovaný soubor s názvem `benchmarks.rb` a poté znovu spustíte příkaz `status`, zobrazí se něco takového:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Soubor `benchmarks.rb` je uveden v části „Changes not staged for commit“ (změny, které nejsou připraveny k zapsání). Znamená to, že soubor, který je sledován, byl v pracovním adresáři změněn, avšak ještě nebyl připraven k zapsání (staged). Chcete-li ho připravit k zapsání, spusťte příkaz `git add` (jedná se o víceúčelový příkaz – používá se k zahájení sledování nových souborů i k dalším operacím, jako je například označení vyřešených případů kolize souborů při slučování). Spusťme nyní příkaz `git add`, abychom soubor `benchmarks.rb` připravili k zapsání, a potom znovu zadejme příkaz `git status`:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README
	        modified:   benchmarks.rb


Oba soubory jsou nyní připraveny k zapsání a budou zahrnuty do příští revize. Nyní předpokládejme, že jste si vzpomněli na jednu malou změnu, kterou chcete ještě před zapsáním revize provést v souboru `benchmarks.rb`. Soubor znovu otevřete, provedete změnu a chcete jej zapsat. Spusťme však ještě jednou příkaz `git status`:

	$ vim benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README
	        modified:   benchmarks.rb

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Co to má být? Soubor `benchmarks.rb` je nyní uveden jak v části připraveno k zapsání (Changes to be committed), tak v části nepřipraveno k zapsání (Changes not staged for commit). Jak je tohle možné? Věc se má tak, že Git po spuštění příkazu `git add` připraví soubor k zapsání přesně ve tvaru, v jakém se nachází v daném okamžiku. Pokud nyní revizi zapíšete, bude obsahovat soubor `benchmarks.rb` tak, jak vypadal, když jste naposledy spustili příkaz `git add`, nikoli v té podobě, kterou měl v pracovním adresáři v okamžiku, když jste spustili příkaz `git commit`. Pokud upravíte soubor po provedení příkazu `git add`, je třeba spustit `git add` ještě jednou, aby byla připravena aktuální verze souboru:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README
	        modified:   benchmarks.rb


### Ignorované soubory ###

Ve vašem adresáři se často vyskytne skupina souborů, u nichž nebudete chtít, aby je Git automaticky přidával nebo aby je vůbec uváděl jako nesledované. Jedná se většinou o automaticky vygenerované soubory, jako soubory log nebo soubory vytvořené při překladu. V takových případech můžete vytvořit soubor `.gitignore` se seznamem masek pro ignorované soubory. Tady je malý příklad souboru `.gitignore`:

	$ cat .gitignore
	*.[oa]
	*~

První řádek říká systému Git, že má ignorovat všechny soubory končící na `.o` nebo `.a` – *objekty* a *archivní* soubory, které mohou být výsledkem překladu. Druhý řádek systému Git říká, aby ignoroval všechny soubory končící vlnovkou (`~`), kterou mnoho textových editorů (např. Emacs) používá k označení dočasných souborů. Můžete rovněž přidat adresář `log`, `tmp` nebo `pid`, automaticky vygenerovanou dokumentaci a podobné. Vytvoření a naplnění souboru `.gitignore` ještě dříve než se pustíte do práce bývá většinou dobrý nápad. Alespoň se vám nestane, že byste nedopatřením zapsali také soubory, o které v repozitáři Git nestojíte.

Pravidla pro masky, které můžete použít v souboru `.gitignore`, jsou následující:

*	Prázdné řádky nebo řádky začínající znakem `#` budou ignorovány.
*	Standardní masky souborů (glob patterns).
*	Chcete-li označit adresář, můžete masku zakončit lomítkem (`/`).
*	Pokud řádek začíná vykřičníkem (`!`), maska na něm je negována.

Masky souborů jsou jako zjednodušené regulární výrazy, které používá shell. Hvězdička (`*`) označuje žádný nebo více znaků; `[abc]` označuje jakýkoli znak uvedený v závorkách (v tomto případě `a`, `b` nebo `c`); otazník (`?`) označuje jeden znak; znaky v závorkách oddělené pomlčkou (`[0-9]`) označují jakýkoli znak v daném rozmezí (v našem případě 0 až 9).

Tady je další příklad souboru `.gitignore`:

	# komentář – ignoruje se
	# žádné soubory s příponou .a
	*.a
	# ale sleduj soubor lib.a, přestože máš ignorovat soubory s příponou .a
	!lib.a
	# ignoruj soubor TODO pouze v kořenovém adresáři, ne v podadresářích
	/TODO
	# ignoruj všechny soubory v adresáři build/
	build/
	# ignoruj doc/notes.txt, ale nikoli doc/server/arch.txt
	doc/*.txt
	# ignoruj všechny .txt soubory v adresáři doc/
	doc/**/*.txt

Část masky `**/` je v Gitu dostupná od verze 1.8.2.

### Zobrazení připravených a nepřipravených změn ###

Je-li pro vaše potřeby příkaz `git status` příliš neurčitý – chcete přesně vědět, co jste změnili, nejen které soubory – můžete použít příkaz `git diff`. Podrobněji se budeme příkazu `git diff` věnovat později. Vy ho však nejspíš budete nejčastěji využívat k zodpovězení těchto dvou otázek: Co jste změnili, ale ještě nepřipravili k zapsání? A co jste připravili a nyní může být zapsáno? Zatímco příkaz `git status` vám tyto otázky zodpoví velmi obecně, příkaz `git diff` přesně zobrazí přidané a odstraněné řádky – tedy samotnou záplatu.

Řekněme, že znovu upravíte a připravíte soubor `README` a poté bez připravení upravíte soubor `benchmarks.rb`. Po spuštění příkazu `status` se zobrazí zhruba toto:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Chcete-li vidět, co jste změnili, avšak ještě nepřipravili k zapsání, zadejte příkaz `git diff` bez dalších parametrů:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

Tento příkaz srovná obsah vašeho pracovního adresáře a oblasti připravených změn. Výsledek vám ukáže provedené změny, které jste dosud nepřipravili k zapsání.

Chcete-li vidět, co jste připravili a co bude součástí příští revize, použijte příkaz `git diff --cached`. (Ve verzích Git 1.6.1 a novějších můžete použít také příkaz `git diff --staged`, který se možná snáze pamatuje.) Tento příkaz srovná připravené změny (staged changes) s poslední revizí:

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

K tomu je třeba poznamenat, že příkaz `git diff` sám o sobě nezobrazí všechny změny provedené od poslední revize, ale jen změny, které zatím nejsou připraveny. To může být občas matoucí, protože pokud jste připravili všechny provedené změny, bude výstup příkazu `git diff` prázdný.

V dalším příkladu ukážeme situaci, kdy jste připravili soubor `benchmarks.rb` a poté ho znovu upravili. Příkaz `git diff` můžete nyní použít k zobrazení změn v souboru, které byly připraveny, a změn, které nejsou připraveny:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   benchmarks.rb

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Příkaz `git diff` nyní můžete použít k zobrazení změn, které dosud nejsou připraveny:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

A příkaz `git diff --cached` ukáže změny, které už připraveny jsou:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### Zapisování změn ###

Nyní, když jste seznam připravených změn nastavili podle svých představ, můžete začít zapisovat změny. Nezapomeňte, že všechno, co dosud nebylo připraveno k zapsání – všechny soubory, které jste vytvořili nebo změnili a na které jste po úpravách nepoužili příkaz `git add` –, nebudou do revize zahrnuty. Zůstanou na vašem disku jako změněné soubory.
Když jste v našem případě naposledy spustili příkaz `git status`, viděli jste, že všechny soubory byly připraveny k zapsání. Takže jste připraveni k samotnému zapsání změn. Nejjednodušší způsob zapsání změn spočívá v použití příkazu `git commit`:

	$ git commit

Po zadání příkazu se otevře vámi zvolený editor. (Ten je nastaven proměnnou prostředí `$EDITOR` vašeho shellu. Většinou se bude jednat o editor vim nebo emacs, ale pomocí příkazu `git config --global core.editor` můžete nastavit i jakýkoli jiný – viz *kapitola 1*.)

Editor zobrazí následující text (tento příklad je z editoru Vim):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#       new file:   README
	#       modified:   benchmarks.rb
	#
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Jak vidíte, výchozí zpráva k revizi (commit message) obsahuje zakomentovaný aktuální výstup příkazu `git status` a nahoře jeden prázdný řádek. Tyto komentáře můžete odstranit a napsat vlastní zprávu k revizi, nebo je můžete v souboru ponechat, abyste si lépe vzpomněli, co bylo obsahem dané revize. (Chcete-li zařadit ještě podrobnější informace o tom, co jste měnili, můžete k příkazu `git commit` přidat parametr `-v`. V editoru se pak zobrazí také výstup rozdílů (diff) ke konkrétním změnám a vy přesně uvidíte, co bylo změněno.) Jakmile editor zavřete, Git vytvoří revizi se zprávou, kterou jste napsali (s odstraněnými komentáři a rozdíly).

Zprávu k revizi můžete rovněž napsat do řádku k příkazu `commit`. Jako zprávu ji označíte tak, že před ni vložíte příznak `-m`:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Story 182: Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

Nyní jste vytvořili svou první revizi! Vidíte, že se po zapsání revize zobrazil výpis s informacemi: do jaké větve jste revizi zapsali (`master`), jaký je kontrolní součet SHA-1 revize (`463dc4f`), kolik souborů bylo změněno a statistiku přidaných a odstraněných řádků revize.

Nezapomeňte, že revize zaznamená snímek projektu, jak je obsažen v oblasti připravených změn. Vše, co jste nepřipravili k zapsání, zůstane ve stavu změněno na vašem disku. Chcete-li i tyto soubory přidat do své historie, zapište další revizi. Pokaždé, když zapíšete revizi, nahrajete snímek svého projektu, k němuž se můžete později vrátit nebo ho můžete použít k srovnání.

### Přeskočení oblasti připravených změn ###

Přestože může být oblast připravených změn opravdu užitečným nástrojem pro přesné vytváření revizí, je někdy při daném pracovním postupu zbytečným mezikrokem. Chcete-li oblast připravených změn úplně přeskočit, nabízí Git jednoduchou zkratku. Přidáte-li k příkazu `git commit` parametr `-a`, Git do revize automaticky zahrne každý soubor, který je sledován. Odpadá potřeba zadávat příkaz `git add`:

	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb

	no changes added to commit (use "git add" and/or "git commit -a")
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+)

Povšimněte si, že kvůli souboru `benchmarks.rb` v tomto případě nemusíte před zapsáním revize provádět příkaz `git add`.

### Odstraňování souborů ###

Chcete-li odstranit soubor ze systému Git, musíte ho odstranit ze sledovaných souborů (přesněji řečeno odstranit z oblasti připravených změn) a zapsat revizi. Odstranění provedete příkazem `git rm`, který odstraní soubor zároveň z vašeho pracovního adresáře, a proto ho už příště neuvidíte mezi nesledovanými soubory.

Pokud soubor jednoduše odstraníte z pracovního adresáře, zobrazí se ve výpisu `git status` v části „Changes not staged for commit“ (tedy *nepřipraveno*):

	$ rm grit.gemspec
	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add/rm <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        deleted:    grit.gemspec

	no changes added to commit (use "git add" and/or "git commit -a")

Pokud nyní provedete příkaz `git rm`, bude k zapsání připraveno odstranění souboru:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        deleted:    grit.gemspec


Po příštím zapsání revize soubor zmizí a přestane být sledován. Pokud už jste soubor upravili a přidali do indexu, musíte odstranění provést pomocí parametru `-f`. Jedná se o bezpečnostní funkci, jež má zabránit nechtěnému odstranění dat, která ještě nebyla nahrána do snímku, a nemohou proto být ze systému Git obnovena.

Další užitečnou možností, která se vám může hodit, je zachování souboru v pracovním stromě a odstranění z oblasti připravených změn. Soubor tak ponecháte na svém pevném disku, ale ukončíte jeho sledování systémem Git. To může být užitečné zejména v situaci, kdy něco zapomenete přidat do souboru `.gitignore`, a omylem to tak zahrnete do revize, např. velký log soubor nebo pár zkompilovaných souborů s příponou `.a`. V takovém případě použijte parametr `--cached`:

	$ git rm --cached readme.txt

Příkaz `git rm` lze používat v kombinaci se soubory, adresáři a maskami souborů. Můžete tak zadat například příkaz ve tvaru:

	$ git rm log/\*.log

Všimněte si tu zpětného lomítka (`\`) před znakem `*`. Je tu proto, že Git provádí své vlastní nahrazování masek souborů nad to, které provádí váš shell. Tímto příkazem odstraníte všechny soubory s příponou `.log` z adresáře `log/`. Provést můžete také tento příkaz:

	$ git rm \*~

Tento příkaz odstraní všechny soubory, které končí vlnovkou (`~`).

### Přesouvání souborů ###

Na rozdíl od ostatních systémů pro správu verzí nesleduje Git explicitně přesouvání souborů. Pokud soubor v systému Git přejmenujete, neuloží se žádná metadata s informací, že jste soubor přejmenovali. Git však používá jinou fintu, aby zjistil, že byl soubor přejmenován. Na ni se podíváme později.

Může se zdát zvláštní, že Git přesto používá příkaz `mv`. Chcete-li v systému Git přejmenovat soubor, můžete spustit třeba příkaz

	$ git mv původní_název nový_název

a vše funguje na výbornou. A skutečně, pokud takový příkaz provedete a podíváte se na stav souboru, uvidíte, že ho Git považuje za přejmenovaný (renamed):

	$ git mv README README.txt
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        renamed:    README -> README.txt


Výsledek je však stejný, jako byste provedli následující:

	$ mv README README.txt
	$ git rm README
	$ git add README.txt

Git implicitně zjistí, že se jedná o přejmenování, a proto nehraje roli, zda přejmenujete soubor tímto způsobem, nebo pomocí příkazu `mv`. Jediným skutečným rozdílem je, že `mv` je jediný příkaz, zatímco u druhého způsobu potřebujete příkazy tři — příkaz `mv` je pouze zjednodušením. Důležitější je, že můžete použít jakýkoli způsob přejmenování a příkaz add/rm provést později, před zapsáním revize.

## Zobrazení historie revizí ##

Až vytvoříte několik revizí nebo pokud naklonujete repozitář s existující historií revizí, možná budete chtít nahlédnout do historie projektu. Nejzákladnějším a nejmocnějším nástrojem je v tomto případě příkaz `git log`.

Následující příklady ukazují velmi jednoduchý projekt pojmenovaný `simplegit`, který pro názornost často používám. Chcete-li si projekt naklonovat, zadejte:

	git clone git://github.com/schacon/simplegit-progit.git

Po zadání příkazu `git log` v tomto projektu byste měli dostat výstup, který vypadá zhruba takto:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

Ve výchozím nastavení a bez dalších parametrů vypíše příkaz `git log` revize provedené v daném repozitáři v obráceném chronologickém pořadí. Nejnovější revize tak budou uvedeny nahoře. Jak vidíte, tento příkaz vypíše všechny revize s jejich kontrolním součtem SHA-1, jménem a e-mailem autora, datem zápisu a zprávou o revizi.

K příkazu `git log` je k dispozici velké množství nejrůznějších parametrů, díky nimž můžete zobrazit přesně to, co potřebujete. Ukážeme si některé z nejpoužívanějších možností.

Jedním z nejužitečnějších je parametr `-p`, který zobrazí rozdíly (diff) provedené v každé revizi. Můžete také použít parametr `-2`, který omezí výpis pouze na dva poslední záznamy:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,5 +5,5 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	     s.name      =   "simplegit"
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"
	     s.email     =   "schacon@gee-mail.com

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

Tento parametr zobrazí tytéž informace, ale za každým záznamem následuje informace o rozdílech. Tato funkce je velmi užitečná při kontrole kódu nebo k rychlému zjištění, co bylo obsahem série revizí, které přidal váš spolupracovník.

Někdy se změny kontrolují snadněji na úrovni slov než na úrovni řádků. Git nabízí parametr `--word-diff`, který můžeme přidat za příkaz `git log -p`. Místo obvyklé detekce rozdílů po řádcích získáme rozdíly po slovech. Zjišťování rozdílů po slovech je u zdrojového kódu celkem k ničemu, ale pokud porovnáváme velké textové soubory -- jako například knihy nebo vaši disertační práci --, pak se tato možnost hodí. Tady máme příklad:

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

Jak vidíte, výstup neobsahuje žádné přidané a odstraněné řádky, jak tomu bývá u běžného zobrazení rozdílů (diff). Místo toho se změny zobrazují uvnitř textu. Přidaná slova jsou uzavřena mezi značkami `{+ +}` a odstraněná jsou uzavřena v `[- -]`. Možná byste také rádi zredukovali obvyklé třířádkové okolí změny na pouhý jeden řádek, protože chcete znát okolí slova a ne okolí řádku. Můžeme toho dosáhnout zadáním parametru `-U1`, jako ve výše uvedeném příkladu.

Ve spojení s příkazem `git log` můžete použít také celou řadu shrnujících parametrů. Pokud například chcete zobrazit některé stručné statistiky pro každou revizi, použijte parametr `--stat`:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 file changed, 1 insertion(+), 1 deletion(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 file changed, 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+)

Jak vidíte, parametr `--stat` vypíše pod každým záznamem revize seznam změněných souborů, kolik souborů bylo změněno (changed) a kolik řádků bylo v těchto souborech vloženo (insertions) a smazáno (deletions). Zároveň vloží na konec výpisu shrnutí těchto informací.
Další opravdu užitečnou možností je parametr `--pretty`. Tento parametr změní výstup logu na jiný než výchozí formát. K dispozici máte několik přednastavených možností. Parametr `oneline` vypíše všechny revize na jednom řádku. Tuto možnost oceníte při velkém množství revizí. Dále se nabízejí parametry `short`, `full` a `fuller` (zkrácený, plný, úplný). Zobrazují výstup přibližně ve stejném formátu, avšak s více či méně podrobnými informacemi:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

Nejzajímavějším parametrem je pak `format`, který umožňuje definovat vlastní formát výstupu logu. Tato možnost je užitečná zejména v situaci, kdy vytváříte výpis pro strojovou analýzu. Jelikož specifikujete formát explicitně, máte jistotu, že se s aktualizací systému Git nezmění:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tabulka 2-1 uvádí některé užitečné parametry, které format akceptuje.

<!-- Poznámka pro překladatele: toto je zápis tabulky.
Řádky musí být formátovány následovně
<TAB><Text prvního sloupce><TAB><Text druhého sloupce>
-->

	Parametr	Popis výstupu
	%H	Otisk (hash) revize
	%h	Zkrácený otisk revize
	%T	Otisk stromu
	%t	Zkrácený otisk stromu
	%P	Otisky rodičovských revizí
	%p	Zkrácené otisky rodičovských revizí
	%an	Jméno autora
	%ae	E-mail autora
	%ad	Datum autora (formát je možné nastavit parametrem --date)
	%ar	Datum autora, relativní
	%cn	Jméno autora revize
	%ce	E-mail autora revize
	%cd	Datum autora revize
	%cr	Datum autora revize, relativní
	%s	Předmět

Možná se ptáte, jaký je rozdíl mezi *autorem* a *autorem revize*. *Autor* (author) je osoba, která práci původně napsala, zatímco *autor revize* (committer) je osoba, která práci zapsala do repozitáře. Pokud tedy pošlete záplatu k projektu a některý z ústředních členů (core members) ji použije, do výpisu se dostanete oba – vy jako autor a core member jako autor revize. K tomuto rozlišení se blíže dostaneme v *kapitole 5*.

Parametry `oneline` a `format` jsou zvlášť užitečné ve spojení s další možností `log`u – parametrem `--graph`. Tento parametr vloží pěkný malý ASCII graf, znázorňující historii vaší větve a slučování, kterou si ukážeme na naší kopii repozitáře projektu Grit:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

To je jen několik základních parametrů k formátování výstupu pro příkaz `git log`, celkově jich je mnohem více. Tabulka 2-2 uvádí parametry, které jsme už zmínili, a některé další běžné parametry formátování, které mohou být užitečné. Pravý sloupec popisuje, jak který parametr změní výstup `log`u.

<!-- Poznámka pro překladatele: toto je zápis tabulky.
Řádky musí být formátovány následovně
<TAB><Text prvního sloupce><TAB><Text druhého sloupce>
-->

	Parametr	Popis
	-p	Zobrazí záplatu vytvořenou s každou revizí.
	--word-diff	Zobrazí záplatu ve tvaru rozdílu po slovech.
	--stat	Zobrazí statistiku pro změněné soubory v každé revizi.
	--shortstat	Zobrazí pouze řádek změněno/vloženo/smazáno z příkazu --stat.
	--name-only	Za informacemi o revizi zobrazí seznam změněných souborů.
	--name-status	Zobrazí seznam dotčených souborů spolu s informací přidáno/změněno/smazáno.
	--abbrev-commit	Zobrazí pouze prvních několik znaků kontrolního součtu SHA-1 místo všech 40.
	--relative-date	Zobrazí datum v relativním formátu (např. "2 weeks ago", tj. před 2 týdny) místo formátu s úplným datem.
	--graph	Zobrazí vedle výstupu logu ASCII graf k historii větve a slučování.
	--pretty	Zobrazí revize v alternativním formátu. Parametry příkazu jsou oneline, short, full, fuller a format (ve kterém uvedete svůj vlastní formát).
	--oneline	Užitečná zkratka pro `--pretty=oneline --abbrev-commit`.

### Omezení výstupu logu ###

Kromě parametrů k formátování výstupu lze pro `git log` použít také celou řadu omezujících parametrů, tj. takových, které zobrazí jen definovanou podmnožinu revizí. My už jsme se s jedním takovým parametrem setkali. Byl to parametr `-2`, který zobrazí pouze dvě poslední revize. Obecně lze tedy říci, že můžete zadat parametr `-<n>`, kde `n` je libovolné celé číslo pro zobrazení posledních `n` revizí. Je však třeba dodat, že tuto funkci asi nebudete využívat příliš často. Git totiž standardně redukuje všechny výpisy stránkovačem, a proto se vždy najednou zobrazí pouze jedna stránka logu.

Velmi užitečné jsou naproti tomu časově omezující parametry, jako `--since` a `--until` („od“ a „do“). Například tento příkaz zobrazí seznam všech revizí pořízených za poslední dva týdny (2 weeks):

	$ git log --since=2.weeks

Tento příkaz pracuje s velkým množstvím formátů. Můžete zadat konkrétní datum („2008-01-15“) nebo relativní datum, např. „2 years 1 day 3 minutes ago“ (před 2 roky, 1 dnem a 3 minutami).

Z výpisu rovněž můžete filtrovat pouze revize, které odpovídají určitým kritériím. Parametr `--author` umožňuje filtrovat výpisy podle konkrétního autora, pomocí parametru `--grep` můžete ve zprávách k revizím vyhledávat klíčová slova. (Všimněte si, že pokud použijete současně parametry author a grep, bude příkaz vyhledávat záznamy splňující obojí.)

Pokud chcete zadat více parametrů grep, musíte přidat výraz `--all-match`, jinak se bude hledat kterýkoli z nich.

Posledním opravdu užitečným parametrem, který lze přidat k příkazu `git log` , je zadání cesty. Jestliže zadáte název adresáře nebo souboru, výstup logu tím omezíte na revize, které provedly změnu v těchto souborech. Cesta je vždy posledním parametrem a většinou jí předcházejí dvě pomlčky (`--`) , jimiž je oddělena od ostatních parametrů.

Tabulka 2-3 uvádí pro přehlednost zmíněné parametry a několik málo dalších. Tabulka 2.2

<!-- Poznámka pro překladatele: toto je zápis tabulky.
Řádky musí být formátovány následovně
<TAB><Text prvního sloupce><TAB><Text druhého sloupce>
-->

	Parametr	Popis
	-(n)	Zobrazí pouze posledních n revizí.
	--since, --after	Omezí výpis na revize provedené po zadaném datu.
	--until, --before	Omezí výpis na revize provedené před zadaným datem.
	--author	Zobrazí pouze revize, v nichž autor odpovídá zadanému řetězci.
	--committer	Zobrazí pouze revize, v nichž autor revize odpovídá zadanému řetězci.


### Omezení výstupního logu na určité datum nebo čas ###

Pokud chcete zjistit, které revize (commit) v repozitáři se zdrojovým kódem Git (git://git.kernel.org/pub/scm/git/git.git) mají datum zápisu (CommitDate) 2014-04-29 -- relativně k vašemu lokálnímu časovému pásmu (takovému, jaké je nastaveno na vašem počítači), použijte příkaz

    $ git log --after="2014-04-29 00:00:00" --before="2014-04-29 23:59:59" \
      --pretty=fuller

Protože se výstup bude lišit podle časového pásma v místě spuštění, doporučuje se v argumentech `--after` a `--before` vždy používat absolutní čas (například ve formátu ISO 8601, který obsahuje i informaci o časovém pásmu). Činíme tak proto, aby každý, kdo stejný příkaz spustí, obdržel stejné, opakovatelné výsledky.

Pokud chceme získat zápisy z určitého časového okamžiku (například z 29. dubna 2013 v 17:07:22 středoevropského času), můžeme použít příkaz

    $ git log  --after="2013-04-29T17:07:22+0200"      \
              --before="2013-04-29T17:07:22+0200" --pretty=fuller

    commit de7c201a10857e5d424dbd8db880a6f24ba250f9
    Author:     Ramkumar Ramachandra <artagnon@gmail.com>
    AuthorDate: Mon Apr 29 18:19:37 2013 +0530
    Commit:     Junio C Hamano <gitster@pobox.com>
    CommitDate: Mon Apr 29 08:07:22 2013 -0700

        git-completion.bash: lexical sorting for diff.statGraphWidth

        df44483a (diff --stat: add config option to limit graph width,
        2012-03-01) added the option diff.startGraphWidth to the list of
        configuration variables in git-completion.bash, but failed to notice
        that the list is sorted alphabetically.  Move it to its rightful place
        in the list.

        Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
        Signed-off-by: Junio C Hamano <gitster@pobox.com>

Výše uvedené časy (`AuthorDate`, `CommitDate`) se zobrazují v základním tvaru (`--date=default`), který zobrazuje informaci o časovém pásmu autora nebo přispěvatele.

K dalším užitečným formátům patří `--date=iso` (ISO 8601), `--date=rfc` (RFC 2822), `--date=raw` (sekundy od počátku (epoch; 1970-01-01 UTC)), `--date=local` (časy ve vašem lokálním časovém pásmu) a také `--date=relative` (jako například "2 hours ago", tj. před dvěma hodinami).

Pokud použijete příkaz `git log` bez určení času, uvažuje se čas odpovídající okamžiku spuštění na vašem počítači (používá stejný posun vůči UTC).

Pokud například na vašem počítači spustíte `git log` v 09:00 a vaše časové pásmo je vůči greenwichskému času posunuto o tři hodiny vpřed, pak se výsledek následujících dvou příkazů shoduje:

    $ git log --after=2008-06-01 --before=2008-07-01
    $ git log --after="2008-06-01T09:00:00+0300" \
        --before="2008-07-01T09:00:00+0300"

A poslední příklad. Pokud chcete zjistit, které revize upravující testovací soubory ve zdrojovém kódu Git zapsal Junio Hamano v říjnu 2008 (relativě k časové zóně New Yorku) a které přitom nebyly sloučením (merge), můžete zadat následující příkaz:

        $ git log --pretty="%h - %s" --author=gitster \
           --after="2008-10-01T00:00:00-0400"         \
          --before="2008-10-31T23:59:59-0400" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Z více než 36 tisíc revizí v historii zdrojového kódu Git zobrazí tento příkaz 6 záznamů, které odpovídají zadaným kritériím.

### Grafické uživatelské rozhraní pro procházení historie ###

Chcete-li použít graficky výrazněji zpracovaný nástroj k procházení historie revizí, možná oceníte Tcl/Tk program nazvaný `gitk`, který je distribuován spolu se systémem Git. Gitk je v zásadě grafická verze příkazu `git log` a umožňuje téměř všechny možnosti filtrování jako `git log`. Pokud do příkazového řádku ve svém projektu zadáte příkaz `gitk`, otevře se okno podobné jako na obrázku 2-2.

Insert 18333fig0202.png
Obrázek 2-2. Graficky zpracovaná historie v nástroji „gitk“

V horní polovině okna vidíte historii revizí, doplněnou názorným hierarchickým grafem. Prohlížeč rozdílů v dolní polovině okna zobrazuje změny provedené v každé revizi, na niž kliknete.

## Rušení změn ##

Kdykoli se může stát, že byste nějakou úpravu chtěli vrátit do původního stavu.. Podívejme se proto, jaké základní nástroje se nám tu nabízejí. Ale buďte opatrní! Ne všechny zrušené změny se dají vrátit. Je to jedna z mála oblastí v systému Git, kdy při neuváženém postupu riskujete, že přijdete o část své práce.

### Změna poslední revize ###

Jedním z nejčastějších důvodů pro rušení úprav je situace, kdy zapíšete revizi příliš brzy a ještě jste například zapomněli přidat některé soubory, nebo byste rádi změnili zprávu k revizi. Chcete-li opravit poslední revizi, můžete spustit příkaz commit s parametrem `--amend`:

	$ git commit --amend

Tento příkaz vezme vaši oblast připravených změn a použije ji k vytvoření revize. Pokud jste od poslední revize neprovedli žádné změny (například spustíte tento příkaz bezprostředně po předchozí revizi), bude snímek vypadat úplně stejně a jediné, co změníte, je zpráva k revizi.

Spustí se stejný editor pro editaci zpráv k revizím, ale tentokrát už obsahuje zprávu z vaší předchozí revize. Zprávu můžete editovat stejným způsobem jako vždy. Zpráva přepíše předchozí revizi.

Pokud například zapíšete revizi a potom si uvědomíte, že jste zapomněli připravit k zapsání změny v souboru, který jste chtěli do této revize přidat, můžete provést následující:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Provedení uvedených tří příkazů zůstane jediná revize – druhý příkaz `commit` nahradí výsledky prvního.

### Odstranění souboru z oblasti připravených změn ###

Následující dvě části popisují, jak se poprat s oblastí připravených změn a se změnami v pracovním adresáři. Je příjemné, že příkaz, jímž se zjišťuje stav těchto dvou oblastí, zároveň připomíná, jak v nich nežádoucí změny zrušit. Řekněme například, že jste změnili dva soubory a chcete je zapsat jako dvě oddělené změny. Jenže omylem jste zadali příkaz `git add *` a oba soubory jste tím připravili k zapsání. Jak lze tyto dva soubory vrátit z oblasti připravených změn? Připomene vám to příkaz `git status`:

	$ git add .
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   README.txt
	        modified:   benchmarks.rb


Přímo pod nadpisem „Changes to be committed“ (Změny k zapsání) se říká: pro návrat z oblasti připravených změn použijte příkaz `git reset HEAD <soubor>...` Budeme se tedy řídit touto radou a vrátíme soubor `benchmarks.rb` z oblasti připravených změn:

	$ git reset HEAD benchmarks.rb
	Unstaged changes after reset:
	M       benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   README.txt

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Příkaz je sice trochu zvláštní, ale funguje. Soubor `benchmarks.rb` má stav „změněn“, ale už se nenachází v oblasti připravených změn.

### Rušení změn ve změněných souborech ###

A co když zjistíte, že nechcete zachovat změny, které jste provedli v souboru `benchmarks.rb`? Jak je můžete snadno zrušit a vrátit soubor zpět do podoby při poslední revizi (nebo při prvním klonování nebo v jakémkoli okamžiku, kdy jste ho zaznamenali v pracovním adresáři)? Příkaz `git status` vám naštěstí řekne, co dělat. U posledního příkladu vypadá oblast připravených změn takto:

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)

	        modified:   benchmarks.rb


Výpis vám sděluje, jak zahodit změny (discard changes), které jste provedli (přinejmenším tak činí novější verze systému Git, od verze 1.6.1; pokud máte starší verzi, doporučujeme ji aktualizovat, čímž získáte některé z těchto vylepšených funkcí). Uděláme, co nám výpis radí:

	$ git checkout -- benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   README.txt


Jak vidíte, změny byly zahozeny. Všimněte si také, že se jedná o nebezpečný příkaz. Veškeré změny, které jste v souboru provedli, jsou ztraceny, soubor jste právě překopírovali jiným souborem. Nikdy tento příkaz nepoužívejte, pokud si nejste zcela jisti, že už daný soubor nebudete potřebovat. Pokud potřebujete pouze odstranit soubor z cesty, podívejte se na odkládání (stashing) a větvení v následující kapitole. Tyto postupy většinou bývají vhodnější.

Zapamatujte si, že vše, co je zapsáno v systému Git, lze téměř vždy obnovit. Obnovit lze dokonce i revize na odstraněných větvích nebo revize, které byly přepsány revizí `--amend` (o obnovování dat viz *kapitola 9*). Pokud však dojde ke ztrátě dat, která dosud nebyla součástí žádné revize, bude tato ztráta patrně nevratná.

## Práce se vzdálenými repozitáři ##

Abyste mohli spolupracovat na projektech v systému Git, je třeba vědět, jak manipulovat se vzdálenými repozitáři (remote repositories). Vzdálené repozitáře jsou verze vašeho projektu umístěné na Internetu nebo kdekoli v síti. Vzdálených repozitářů můžete mít hned několik, každý pro vás přitom bude buď pouze ke čtení (read-only) nebo ke čtení a zápisu (read write). Spolupráce s ostatními uživateli zahrnuje také správu těchto vzdálených repozitářů. Při sdílení práce musíte do těchto repozitářů data odesílat (push) a zase je z nich stahovat (pull).
Při správě vzdálených repozitářů musíte vědět, jak lze přidat vzdálený repozitář, jak odstranit vzdálený repozitář, který už není platný, jak spravovat různé vzdálené větve, jak je definovat jako sledované či nesledované a další věci. V této části se zaměříme právě na správu vzdálených repozitářů.

### Zobrazení vzdálených serverů ###

Chcete-li zjistit, jaké vzdálené servery máte nakonfigurovány, můžete použít příkaz `git remote`. Systém vypíše krátké názvy, přes které se se vzdálenými repozitáři manipuluje, a které jste dříve určili. Pokud byl váš repozitář vytvořen klonováním, měli byste vidět přinejmenším server *origin*. Jde o výchozí název, který Git dává serveru, z nějž jste repozitář klonovali.

	$ git clone git://github.com/schacon/ticgit.git
	Cloning into 'ticgit'...
	remote: Reusing existing pack: 1857, done.
	remote: Total 1857 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (1857/1857), 374.35 KiB | 193.00 KiB/s, done.
	Resolving deltas: 100% (772/772), done.
	Checking connectivity... done.
	$ cd ticgit
	$ git remote
	origin

Můžete rovněž zadat parametr `-v`, jenž zobrazí adresu URL, kterou má Git uloženou pro zkrácený název, který si přejete rozepsat.

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

Pokud používáte více než jeden vzdálený repozitář, příkaz je vypíše všechny. Například můj repozitář Grit vypadá takto:

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

To znamená, že mohu velmi snadno stáhnout příspěvky od kteréhokoli z těchto uživatelů. Ale všimněte si, že pouze vzdálený server origin je SSH URL, a je tedy jediným repozitářem, kam lze soubory odesílat (push; důvod objasníme v *kapitole 4*).

### Přidávání vzdálených repozitářů ###

V předchozích částech už jsem se letmo dotkl přidávání vzdálených repozitářů. V této části se dostávám k tomu, jak přesně při přidávání postupovat. Chcete-li přidat nový vzdálený repozitář Git a zadat zkrácený název, přes který se můžete snadno odkazovat, spusťte příkaz `git remote add [zkrácený název] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Řetězec `pb` nyní můžete používat na příkazovém řádku místo kompletní adresy URL. Pokud například chcete vyzvednout (fetch) všechny informace, které má Paul, ale vy je ještě nemáte ve svém repozitáři, můžete spustit příkaz `git fetch pb`:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paulova hlavní větev (master branch) je teď lokálně dostupná jako `pb/master`. Můžete ji začlenit (merge) do některé ze svých větví, nebo ji můžete zpřístupnit jako lokální větev (check out), jestliže si ji chcete prohlédnout.

### Vyzvedávání a stahování ze vzdálených repozitářů ###

Jak jste právě viděli, data ze vzdálených projektů můžete získat pomocí příkazu:

	$ git fetch [název vzdáleného repozitáře]

Příkaz zamíří do vzdáleného projektu a stáhne z něj všechna data, která ještě nemáte u sebe. Poté byste měli mít k dispozici odkazy na všechny větve tohoto vzdáleného projektu. Od toho okamžiku je můžete kdykoli slučovat nebo prohlížet. (Podrobněji se budeme větvím a jejich použití věnovat v *kapitole 3*.)

Pokud jste naklonovali repozitář, příkaz automaticky přidá tento vzdálený repozitář pod názvem *origin*. Takže příkaz `git fetch origin` vyzvedne veškerou novou práci, která byla na uvedený server poslána (push) od okamžiku, kdy jste odtud klonovali (nebo kdy jste odtud naposledy vyzvedávali práci). Měli bychom zmínit, že příkaz `fetch` stáhne data do vašeho lokálního repozitáře. V žádném případě ale data automaticky nesloučí s vaší prací ani jinak nezmění nic z toho, na čem právě pracujete. Sloučení s vaší prací musíte udělat ručně, až to uznáte za vhodné.

Pokud máte větev nastavenou ke sledování vzdálené větve (více informací naleznete v následující části a v *kapitole 3*), můžete použít příkaz `git pull`, který automaticky vyzvedne (fetch) a poté začlení (merge) vzdálenou větev do vaší aktuální větve. Tento postup pro vás může být snazší a pohodlnější. Standardně přitom příkaz `git clone` automaticky nastaví vaši lokální hlavní větev, aby sledovala vzdálenou hlavní větev na serveru, z kterého jste klonovali (za předpokladu, že má vzdálený server hlavní větev). Příkaz `git pull` většinou vyzvedne data ze serveru, z něhož jste původně klonovali, a automaticky se pokusí začlenit je do kódu, na němž právě pracujete.

### Odesílání do vzdálených repozitářů ###

Pokud se váš projekt nachází ve stavu, kdy ho chcete sdílet s ostatními, můžete ho odeslat (push) na vzdálený server. Příkaz pro tuto akci je jednoduchý: `git push [název vzdáleného repozitáře] [název větve]`. Pokud chcete poslat svou hlavní větev na server `origin` (i tady platí, že proces klonování vám nastaví názvy `master` i `origin` automaticky), můžete k odeslání své práce na server použít tento příkaz:

	$ git push origin master

Tento příkaz bude funkční, pouze pokud jste klonovali ze serveru, k němuž máte oprávnění pro zápis, a pokud sem od vašeho klonování nikdo neposílal svou práci. Pokud spolu s vámi provádí současně klonování ještě někdo další a ten poté svou práci odešle na server, vaše později odesílaná práce bude oprávněně odmítnuta. Nejprve musíte stáhnout práci ostatních a začlenit ji do své, teprve potom vám server umožní odeslání. Více informací o odesílání na vzdálené servery najdete v *kapitole 3*.

### Prohlížení vzdálených repozitářů ###

Jestliže chcete získat více informací o konkrétním vzdáleném repozitáři, můžete použít příkaz `git remote show [název vzdáleného repozitáře]`. Pokud použijete tento příkaz v kombinaci s konkrétním zkráceným názvem (např. `origin`), bude výstup vypadat zhruba následovně:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Bude obsahovat adresu URL vzdáleného repozitáře a informace ke sledování větví. Příkaz vám mimo jiné sděluje, že pokud se nacházíte na hlavní větvi (branch `master`) a spustíte příkaz `git pull`, pak se po vyzvednutí všech vzdálených referencí (fetch) práce z hlavní větve na vzdáleném serveru automaticky začlení (merge). Součástí výpisu jsou také všechny vzdálené reference, které příkaz stáhl.

S uvedeným jednoduchým případem se pravděpodobně setkáte. Pokud však Git používáte na intenzivněji, může vám příkaz `git remote show` zobrazit mnohem více informací:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

Tento příkaz ukazuje, která větev bude automaticky odeslána, pokud spustíte příkaz `git push` na určitých větvích. Příkaz vám také oznámí, které vzdálené větve na serveru ještě nemáte, které vzdálené větve máte, ale ze serveru už byly odstraněny, a několik větví, které budou automaticky sloučeny, jestliže spustíte příkaz `git pull`.

### Odstraňování a přejmenovávání vzdálených repozitářů ###

Chcete-li změnit zkrácené jméno vzdáleného repozitáře, můžete v novějších verzích systému Git spustit příkaz `git remote rename`. Pokud například chcete přejmenovat repozitář z `pb` na `paul`, můžete tak učinit příkazem `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Za zmínku stojí, že tímto příkazem změníte zároveň i názvy vzdálených větví. Z původní reference `pb/master` se tak nyní stává `paul/master`.

Chcete-li, ať už z jakéhokoli důvodu, odstranit referenci (přesunuli jste například server nebo už nepoužíváte dané zrcadlo, nebo třeba přispěvatel přestal přispívat), můžete využít příkaz `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Značky ##

Stejně jako většina systémů VCS nabízí i Git možnost označovat v historii určitá místa, jež považujete za důležitá. Tato funkce se nejčastěji používá k označení jednotlivých vydání (například `v1.0`). V této části vysvětlíme, jak pořídíte výpis všech dostupných značek, jak lze vytvářet značky nové a jaké typy značek se vám nabízejí.

### Výpis značek ###

Pořízení výpisu dostupných značek (tags) je v systému Git jednoduché. Stačí zadat příkaz `git tag`:

	$ git tag
	v0.1
	v1.3

Tento příkaz vypíše značky v abecedním pořadí. Pořadí, v němž se značky vyskytují, není relevantní.

Značky lze vyhledávat také pomocí konkrétní masky. Například zdrojový kód Git „repo“ obsahuje více než 240 značek. Pokud vás však zajímá pouze verze 1.4.2., můžete zadat:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Vytváření značek ###

Git používá dva hlavní druhy značek: prosté (lightweight) a anotované (annotated). Prostá značka se velmi podobá větvi, která se nemění – je to pouze ukazatel na konkrétní revizi. Naproti tomu anotované značky jsou ukládány jako plné objekty v databázi Git. U anotovaných značek se provádí kontrolní součet. Obsahují jméno autora značky (tagger), e-mail a datum, nesou vlastní zprávu (tagging message) a mohou být podepsány (signed) a ověřeny (verified) v programu GNU Privacy Guard (GPG). Obecně se doporučuje používat v zájmu úplnosti informací spíše anotované značky. Pokud však vytváříte pouze dočasnou značku nebo z nějakého důvodu nechcete zadávat podrobnější informace, můžete využívat i prosté značky.

### Anotované značky ###

Vytvoření anotované značky v systému Git je jednoduché. Nejjednodušším způsobem je zadat k příkazu `tag` parametr `-a`:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

Parametr `-m` udává zprávu značky, která bude uložena spolu se značkou. Pokud u anotované značky nezadáte žádnou zprávu, Git spustí textový editor, v němž zprávu zadáte.

Informace značky se zobrazí spolu s revizí, kterou značka označuje, po zadání příkazu `git show`:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4

	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Příkaz zobrazí ještě před informacemi o revizi informace o autorovi značky, datu, kdy byla revize označena, a zprávu značky.

### Podepsané značky ###

Máte-li soukromý klíč, lze značky rovněž podepsat v programu GPG. Jediné, co pro to musíte udělat, je zadat místo parametru `-a` parametr `-s`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Pokud pro tuto značku spustíte příkaz `git show`, uvidíte k ní připojen svůj podpis GPG:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

V dalších částech se naučíte, jak podepsané značky ověřovat.

### Prosté značky ###

Další možností, jak označit revizi, je prostá značka. Prostá značka je v podstatě kontrolní součet revize uložený v souboru, žádné další informace neobsahuje. Chcete-li vytvořit prostou značku, nezadávejte ani jeden z parametrů `-a`, `-s` nebo `-m`:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Pokud spustíte pro značku příkaz `git show` tentokrát, nezobrazí se k ní žádné další informace. Příkaz zobrazí pouze samotnou revizi:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Ověřování značek ###

Chcete-li ověřit podepsanou značku, použijte příkaz `git tag -v [název značky]`. Tento příkaz využívá k ověření podpisu program GPG. Aby příkaz správně fungoval, musíte mít ve své klíčence veřejný klíč podepisujícího (signer).

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

Pokud veřejný klíč podepisujícího nemáte, výstup bude vypadat následovně:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Dodatečné označení ###

Revizi lze označit značkou i poté, co jste ji už opustili. Předpokládejme, že vaše historie revizí vypadá takto:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Nyní předpokládejme, že jste projektu zapomněli přidělit značku `v1.2`, která byla obsažena v revizi označené jako „updated rakefile“. Značku můžete přidat dodatečně. Pro označení revize značkou zadejte na konec příkazu kontrolní součet revize (nebo jeho část):

	$ git tag -a v1.2 -m 'version 1.2' 9fceb02

Můžete se podívat, že jste revizi označil:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Sdílení značek ###

Příkaz `git push` nepřenáší značky na vzdálené servery automaticky. Pokud jste vytvořili značku, budete ji muset na sdílený server poslat explicitně. Tento proces je stejný jako sdílení vzdálených větví. Spusťte příkaz `git push origin [název značky]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Máte-li značek více a chcete je odeslat všechny najednou, můžete použít také parametr `--tags`, který se přidává k příkazu `git push`. Tento příkaz přenese na vzdálený server všechny vaše značky, které tam ještě nejsou.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Pokud nyní někdo bude klonovat nebo stahovat z vašeho repozitáře, stáhne rovněž všechny vaše značky.

## Tipy a triky ##

Než ukončíme tuto kapitolu věnovanou základům práce se systémem Git, přidáme ještě pár tipů a triků, které vám mohou usnadnit či zpříjemnit práci. Mnoho uživatelů pracuje se systémem Git, aniž by tyto triky znali a používali. V dalších částech knihy se už o nich nebudeme zmiňovat ani nebudeme předpokládat, že je používáte. Přesto pro vás mohou být užitečné.

### Automatické dokončování ###

Jestliže používáte shell Bash, nabízí vám Git možnost zapnout si skript pro automatické dokončování. Stáhněte si jej ze zdrojových textů systému Git z https://github.com/git/git/blob/master/contrib/completion/git-completion.bash. Soubor nakopírujte tento do vašeho domovského adresáře a do souboru `.bashrc` přidejte:

	source ~/git-completion.bash

Chcete-li nastavit Git tak, aby měl automaticky dokončování pro shell Bash pro všechny uživatele, zkopírujte u systému Mac tento skript do adresáře `/opt/local/etc/bash_completion.d`, nebo u systémů Linux do adresáře `/etc/bash_completion.d/`. Jde o adresář skriptů, ze kterého si Bash automaticky načítá podporu pro shellové dokončování.

Pokud používáte Git Bash v systému Windows (Git Bash je pro instalaci msysGit pod Windows výchozím programem), mělo by být automatické dokončování přednastaveno.

Při zadávání příkazu Git stiskněte klávesu Tab a měla by se objevit nabídka, z níž můžete zvolit příslušné dokončení:

	$ git co<tab><tab>
	commit config

Pokud zadáte – stejně jako v našem příkladu nahoře – `git co` a dvakrát stisknete klávesu Tab, systém vám navrhne „commit“ a „config“. Doplníte-li ještě `m<tab>`, skript automaticky dokončí příkaz na `git commit`.

Automatické dokončování pravděpodobně více využijete v případě parametrů. Pokud například zadáváte příkaz `git log` a nemůžete si vzpomenout na některý z parametrů, můžete zadat jeho začátek, stisknout klávesu Tab a podívat se, co by to mohlo přesně být:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Jedná se o užitečný trik, který vám může ušetřit čas a pročítání dokumentace.

### Aliasy Git ###

Jestliže zadáte systému Git neúplný příkaz, systém ho neakceptuje. Pokud nechcete zadávat celý text příkazů Git, můžete pomocí `git config` jednoduše nastavit pro každý příkaz tzv. alias. Uveďme několik příkladů možného nastavení:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

To znamená, že například místo kompletního příkazu `git commit` stačí zadat pouze zkrácené `git ci`. Budete-li pracovat v systému Git častěji, pravděpodobně budete hojně využívat i jiné příkazy. V takovém případě neváhejte a vytvořte si nové aliasy.

Tato metoda může být velmi užitečná také k vytváření příkazů, které by podle vás měly existovat. Pokud jste například narazili na problém s používáním příkazu pro vrácení souboru z oblasti připravených změn, můžete ho vyřešit zadáním vlastního aliasu:

	$ git config --global alias.unstage 'reset HEAD --'

Po zadání takového příkazu budete mít k dispozici dva ekvivalentní příkazy:

	$ git unstage fileA
	$ git reset HEAD fileA

Příkaz unstage je o něco jasnější. Běžně se také přidává příkaz `last`:

	$ git config --global alias.last 'log -1 HEAD'

Tímto způsobem snadno zobrazíte poslední revizi:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Chtělo by se tedy říci, že Git jednoduše nahradí nový příkaz jakýmkoli aliasem, který vytvoříte. Může se však stát, že budete chtít spustit externí příkaz, a ne dílčí příkaz Git. V takovém případě zadejte na začátek příkazu znak `!`. Tuto možnost využijete, pokud si píšete své vlastní nástroje, které fungují s repozitářem Git. Jako příklad můžeme uvést situaci, kdy nahradíte příkaz `git visual` aliasem `gitk`:

	$ git config --global alias.visual '!gitk'

## Shrnutí ##

V tomto okamžiku už tedy umíte v systému Git provádět všechny základní lokální operace: vytvářet a klonovat repozitáře, provádět změny, připravit je k zapsání i zapisovat nebo třeba zobrazit historii všech změn, které prošly repozitářem. V další kapitole se podíváme na exkluzivní funkci systému Git – na model větvení.
