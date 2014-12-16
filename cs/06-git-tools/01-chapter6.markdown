# Nástroje systému Git #

Do této chvíle jste stačili poznat většinu každodenních příkazů a pracovních postupů, které budete při práci se zdrojovým kódem potřebovat k ovládání a správě repozitáře Git. Zvládli jste základní úkony sledování a zapisování souborů a pochopili jste přednosti přípravy souborů k zapsání i snadného vytváření a začleňování větví.

Nyní poznáte několik velmi účinných nástrojů, které vám Git nabízí. Pravděpodobně je nebudete používat každý den, ale přesto se vám mohou čas od času hodit.

## Výběr revize ##

Systém Git umožňuje určit jednotlivé revize nebo interval revizí několika způsoby. Není nezbytně nutné, abyste je všechny znali, ale mohou být užitečné.

### Jednotlivé revize ###

Revizi můžete samozřejmě specifikovat na základě otisku SHA-1, jenž jí byl přidělen. Existují však i uživatelsky příjemnější způsoby, jak označit konkrétní revizi. Tato část uvede několik různých způsobů, jak lze určit jednu konkrétní revizi.

### Zkrácená hodnota SHA ###

Git je dostatečně chytrý na to, aby pochopil, jakou revizi jste měli na mysli, zadáte-li pouze prvních několik znaků. Tento neúplný otisk SHA-1 musí mít alespoň čtyři znaky a musí být jednoznačný, tj. žádný další objekt v aktuálním repozitáři nesmí začínat stejnou zkrácenou hodnotou SHA-1.

Pokud si chcete například prohlédnout konkrétní revizi, řekněme, že spustíte příkaz `git log` a určíte revizi, do níž jste vložili určitou funkci:

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

V tomto případě vyberte `1c002dd....`. Pokud chcete na revizi použít příkaz `git show`, budou všechny následující příkazy ekvivalentní (za předpokladu, že jsou zkrácené verze jednoznačné):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git dokáže identifikovat krátkou, jednoznačnou zkratku hodnoty SHA-1. Zadáte-li k příkazu `git log` parametr `--abbrev-commit`, výstup bude používat kratší hodnoty, ale pouze v jednoznačném tvaru. Standardně se používá sedm znaků, avšak je-li to kvůli jednoznačnosti hodnoty SHA-1 nezbytné, bude použito znaků více:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Osm až deset znaků většinou bohatě stačí, aby byla hodnota v rámci projektu jednoznačná. V jednom z největších projektů Git, v jádru Linuxu, začíná být nutné zadávat pro jednoznačné určení už 12 znaků z celkových 40 možných.

### Krátká poznámka k hodnotě SHA-1 ###

Někteří uživatelé bývají zmateni, že mohou mít v repozitáři – shodou okolností – dva objekty, které mají stejnou hodnotu SHA-1 otisku. Co teď?

Pokud náhodou zapíšete objekt, který má stejnou hodnotu SHA-1 otisku jako předchozí objekt ve vašem repozitáři, Git už uvidí předchozí objekt v databázi Git a bude předpokládat, že už byl zapsán. Pokud se někdy v budoucnosti pokusíte znovu provést checkout tohoto objektu, vždy dostanete data prvního objektu.

Měli bychom však také říci, jak moc je nepravděpodobné, že taková situace nastane. Otisk SHA-1 má 20 bytů, neboli 160 bitů. Počet objektů s náhodným otiskem, které bychom potřebovali k 50% pravděpodobnosti, že nastane jediná kolize, je asi 2^80 (vzorec k určení pravděpodobnosti kolize je `p = (n(n-1)/2) * (1/2^160)`). 2^80 je 1,2 * 10^24, neboli 1 milion miliard miliard. To je 1200násobek počtu všech zrnek písku na celé Zemi.

Abyste si udělali představu, jak je nepravděpodobné, že dojde ke kolizi hodnot SHA-1, připojujeme jeden malý příklad. Kdyby 6,5 miliardy lidí na zemi programovalo a každý by každou sekundu vytvořil kód odpovídající celé historii linuxového jádra (1 milion objektů Git) a odesílal ho do jednoho obřího repozitáře Git, trvalo by 5 let, než by repozitář obsahoval dost objektů na to, aby existovala 50% pravděpodobnost, že dojde ke kolizi jediného objektu SHA-1. To už je pravděpodobnější, že všichni členové vašeho programovacího týmu budou během jedné noci v navzájem nesouvisejících incidentech napadeni a zabiti smečkou vlků.

### Reference větví ###

Nejčistší způsob, jak určit konkrétní revizi, vyžaduje, aby měla revize referenci větve, která na ni ukazuje. V takovém případě můžete použít název větve v libovolném příkazu Git, který vyžaduje objekt revize nebo hodnotu SHA-1. Pokud chcete například zobrazit objekt poslední revize větve, můžete využít některý z následujících příkazů (za předpokladu, že větev `topic1` ukazuje na `ca82a6d`):

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Jestliže vás zajímá, na kterou konkrétní hodnotu SHA větev ukazuje, nebo chcete-li zjistit, jak bude některý z těchto příkladů vypadat v podobě SHA, můžete použít jeden z nízkoúrovňových nástrojů systému Git: `rev-parse`. Více o nízkoúrovňových nástrojích najdete v kapitole 9. Nástroj `rev-parse` se používá v podstatě pouze pro operace na nižších úrovních a není koncipován pro každodenní používání. Může se však hodit, až budete jednou potřebovat zjistit, co se doopravdy odehrává. Tehdy můžete na svou větev spustit příkaz `rev-parse`:

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### Zkrácené názvy v záznamu RefLog ###

Jednou z věcí, které probíhají na pozadí systému Git, zatímco vy pracujete, je uchovávání záznamu reflog, v němž se ukládají pozice referencí HEAD a všech vašich větví za několik posledních měsíců.

Svůj reflog si můžete nechat zobrazit příkazem `git reflog`:

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

Pokaždé, když je z nějakého důvodu aktualizován vrchol větve, Git tuto informaci uloží v dočasné historii reflog. Pomocí těchto dat lze rovněž specifikovat starší revize. Chcete-li zobrazit pátou poslední hodnotu ukazatele HEAD svého repozitáře, použijte referenci `@{n}` z výstupu reflog:

	$ git show HEAD@{5}

Tuto syntaxi můžete použít také k zobrazení pozice, na níž se větev nacházela před určitou dobou. Chcete-li například zjistit, kde byla vaše větev `master` včera (yesterday), můžete zadat příkaz:

	$ git show master@{yesterday}

Git vám ukáže, kde se vrchol větve nacházel včera. Tato možnost funguje pouze pro data, jež jsou dosud v záznamu reflog. Nemůžete ji proto použít pro revize starší než několik měsíců.

Chcete-li zobrazit informace záznamu reflog ve formátu výstupu `git log`, zadejte příkaz `git log -g`:

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Měli bychom také doplnit, že informace záznamu reflog jsou čistě lokální, vztahují se pouze na to, co jste provedli ve svém repozitáři. V kopii repozitáře na počítači kohokoli jiného se budou tyto reference lišit. Bezprostředně poté, co poprvé naklonujete repozitář, bude váš reflog prázdný, protože ve vašem repozitáři ještě nebyla provedena žádná operace. Příkaz `git show HEAD@{2.months.ago}` bude fungovat, pouze pokud jste projekt naklonovali minimálně před dvěma měsíci (tedy „2 months ago“). Pokud jste jej naklonovali před pěti minutami, neobdržíte žádný výsledek.

### Reference podle původu ###

Další základní způsob, jak specifikovat konkrétní revizi, je na základě jejího původu. Umístíte-li na konec reference znak `^`, Git bude referenci chápat tak, že označuje rodiče dané revize.
Můžete mít například takovouto historii projektu:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Zobrazit předchozí revizi pak můžete pomocí `HEAD^`, což doslova znamená „rodič revize HEAD“:

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Za znakem `^` můžete zadat také číslo, např. `d921970^2` označuje „druhého rodiče revize d921970“. Tato syntaxe má význam pouze u revizí vzniklých sloučením, které mají více než jednoho rodiče. První rodič je větev, na níž jste se během začlenění nacházeli, druhým rodičem je větev, kterou jste začleňovali:

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

Další základní možností označení původu je znak `~`. Také tento znak označuje prvního rodiče, výrazy `HEAD~` a `HEAD^` jsou proto ekvivalentní. Rozdíl mezi nimi je patrný při zadání čísla. `HEAD~2` označuje „prvního rodiče prvního rodiče“, tedy „prarodiče“. Příkaz překročí prvního rodiče tolikrát, kolikrát udává číselná hodnota. Například v historii naznačené výše by `HEAD~3` znamenalo:

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Totéž by bylo možné označit výrazem `HEAD^^^`, který opět udává prvního rodiče prvního rodiče prvního rodiče:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Tyto syntaxe můžete také kombinovat. Druhého rodiče předchozí reference (jestliže se jednalo o revizi sloučením) lze získat výrazem `HEAD~3^2` atd.

### Intervaly revizí ###

Nyní, když umíte určit jednotlivé revize, podíváme se, jak lze určovat celé intervaly revizí. To využijete zejména při správě větví. Máte-li větší množství větví, pomůže vám označení intervalu revizí dohledat odpovědi na otázky typu: „Jaká práce je obsažena v této větvi, kterou jsem ještě nezačlenil do hlavní větve?“

#### Dvě tečky ####

Nejčastěji se při označení intervalu používá dvojtečková syntaxe. Pomocí ní systému Git v podstatě říkáte, aby uvažoval celý interval revizí, které jsou dostupné z jedné revize, ale nejsou dostupné z jiné. Předpokládejme tedy, že máte historii revizí jako na obrázku 6-1.

Insert 18333fig0601.png
Obrázek 6-1. Příklad historie revizí pro výběr intervalu

Vy chcete vidět, co všechno obsahuje vaše experimentální větev, kterou jste ještě nezačlenili do hlavní větve. Pomocí výrazu `master..experiment` můžete systému Git zadat příkaz, aby vám zobrazil log právě s těmito revizemi, doslova „všemi revizemi dostupnými z větve experiment a nedostupnými z hlavní větve“. V zájmu stručnosti a názornosti použiji v těchto příkladech místo skutečného výstupu logu písmena objektů revizí z diagramu v pořadí, jak by se zobrazily:

	$ git log master..experiment
	D
	C

A samozřejmě si můžete nechat zobrazit i pravý opak, všechny revize ve větvi `master`, které nejsou ve větvi `experiment`. K tomu stačí obrátit pořadí názvů větví v příkazu. Výraz `experiment..master` zobrazí vše ve větvi `master`, co není dostupné ve větvi `experiment`:

	$ git log experiment..master
	F
	E

Tento log využijete, pokud chcete udržovat větev `experiment` stále aktuální a zjistit, co hodláte začlenit. Tato syntaxe se velmi často používá také ke zjištění, co hodláte odeslat do vzdálené větve:

	$ git log origin/master..HEAD

Tento příkaz zobrazí všechny revize ve vaší aktuální větvi, které nejsou obsaženy ve větvi `master` vzdáleného repozitáře `origin`. Spustíte-li příkaz `git push` a vaše aktuální větev sleduje větev `origin/master`, budou na server přesunuty revize, které lze zobrazit příkazem `git log origin/master..HEAD`.
Jednu stranu intervalu můžete zcela vynechat, Git na její místo automaticky dosadí HEAD. Stejné výsledky jako v předchozím příkladu dostanete zadáním příkazu `git log origin/master..` – Git dosadí na prázdnou stranu výraz HEAD.

#### Několik bodů ####

Dvojtečková syntaxe je užitečná jako zkrácený výraz. Možná ale budete chtít k označení revize určit více než dvě větve, např. až budete chtít zjistit, které revize jsou obsaženy ve všech ostatních větvích a zároveň nejsou obsaženy ve větvi, na níž se právě nacházíte. V systému Git to můžete provést buď zadáním znaku `^` nebo parametru `--not` před referencí, jejíž dostupné revize si nepřejete zobrazit. Tyto tři příkazy jsou tedy ekvivalentní:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Tato syntaxe je užitečná zejména proto, že pomocí ní můžete zadat více než dvě reference, což není pomocí dvojtečkové syntaxe možné. Pokud chcete zobrazit například všechny revize, které jsou dostupné ve větvi `refA` nebo `refB`, ale nikoli ve větvi `refC`, zadejte jeden z následujících příkazů:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Tím máte v rukou velmi efektivní systém vyhledávání revizí, který vám pomůže zjistit, co vaše větve obsahují.

#### Tři tečky ####

Poslední významnou syntaxí k určení intervalu je trojtečková syntaxe, která vybere všechny revize dostupné ve dvou referencích, ale ne v obou zároveň. Podívejme se ještě jednou na příklad historie revizí na obrázku 6-1.
Chcete-li zjistit, co je ve větvi `master` nebo `experiment`, ale nechcete vidět jejich společné reference, zadejte příkaz:

	$ git log master...experiment
	F
	E
	D
	C

Výstupem příkazu bude běžný výpis příkazu `log`, ale zobrazí se pouze informace o těchto čtyřech revizích, uspořádané v tradičním pořadí podle data zapsání.

Přepínačem, který se v tomto případě běžně používá v kombinaci s příkazem `log`, je parametr `--left-right`. Příkaz pak zobrazí, na jaké straně intervalu se ta která revize nachází. Díky tomu získáte k datům další užitečné informace:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Pomocí těchto nástrojů můžete v systému Git daleko snáze specifikovat, kterou revizi nebo které revize chcete zobrazit.

## Interaktivní příprava k zapsání ##

Git nabízí také celou řadu skriptů, které vám mohou usnadnit provádění příkazů zadávaných v příkazovém řádku. V této části se podíváme na několik interaktivních příkazů, které vám mohou pomoci snadno určit, na jaké kombinace a části souborů má být omezena konkrétní revize. Tyto nástroje se vám mohou velmi hodit, jestliže upravujete několik souborů a rozhodnete se, že tyto změny zapíšete raději do několika specializovaných revizí než do jedné velké nepřehledné. Tímto způsobem zajistíte, že budou vaše revize logicky oddělenými sadami změn, jež mohou vaši spolupracovníci snadno zkontrolovat.
Spustíte-li příkaz `git add` s parametrem `-i` nebo `--interactive`, přejde Git do interaktivního režimu shellu a zobrazí zhruba následující:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

Vidíte, že tento příkaz vám poskytne podstatně odlišný pohled na vaši oblast připravených změn. Stejné informace, i když o něco stručnější a hutnější, získáte také příkazem `git status`. Tento příkaz vypíše všechny změny, které jste připravili k zapsání, na levé straně, nepřipravené změny na pravé.

Za seznamem změn následuje část Commands (Příkazy). Tady můžete provádět celou řadu věcí, včetně přípravy souborů k zapsání, vracení připravených souborů, přípravy částí souborů, přidávání nesledovaných souborů a prohlížení změn v připravených souborech.

### Příprava souborů k zapsání a jejich vracení ###

Zadáte-li na výzvu `What now>` (Co teď) odpověď `2` nebo `u`, skript se vás zeptá, které soubory chcete připravit k zapsání:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Jestliže chcete připravit k zapsání soubory TODO a index.html, zadejte příslušná čísla:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Znak `*` vedle souborů znamená, že je soubor vybrán jako připravený k zapsání. Jestliže na výzvu `Update>>` nic nezadáte a stisknete klávesu Enter, Git vezme všechny vybrané soubory a připraví je k zapsání:

	Update>>
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Jak vidíte, soubory TODO a index.html jsou připraveny k zapsání, soubor simplegit.rb nikoli. Chcete-li v tuto chvíli vrátit soubor TODO z oblasti připravených změn, použijte parametr `3` nebo `r` (jako „revert“ neboli „vrátit“):

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

Pokud se nyní znovu podíváte na stav Git souboru TODO, uvidíte, že už není připraven k zapsání:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Chcete-li zobrazit výpis diff připravených souborů, použijte příkaz `6` nebo `d` (jako „diff“). Příkaz zobrazí seznam připravených souborů. Můžete vybrat ty soubory, pro něž chcete zobrazit rozdíly připravených změn. Je to prakticky totéž, jako byste na příkazovém řádku zadali příkaz `git diff --cached`:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

Pomocí těchto základních příkazů můžete použít režim interaktivního přidávání, a snáze tak ovládat svou oblast připravených změn.

### Příprava záplat ###

Git také může připravit k zapsání pouze určité části souborů a ignorovat jejich zbytek. Pokud například provedete dvě změny v souboru simplegit.rb a chcete k zapsání připravit pouze jednu z nich, není to v systému Git žádný problém. Na interaktivní výzvu zadejte příkaz `5` nebo `p` (jako „patch“ – tedy záplata). Git se vás zeptá, které soubory chcete částečně připravit. Pro každou část vybraných souborů pak zobrazí komplexy (hunks) rozdílů diff daného souboru a u každého z nich se vás zeptá, jestli si ho přejete připravit k zapsání:

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]?

V tomto se nabízí celá řada možností. Zadáte-li znak `?`, zobrazí se seznam možností, které máte k dispozici.

	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? ?
	y - stage this hunk
	n - do not stage this hunk
	a - stage this and all the remaining hunks in the file
	d - do not stage this hunk nor any of the remaining hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

V českém překladu:

	Připravit tento soubor změn [y,n,a,d,/,j,J,g,e,?]? ?
	y - připravit soubor změn k zapsání
	n - nepřipravovat soubor změn k zapsání
	a - připravit tento soubor změn i všechny ostatní komplexy v souboru
	d - nepřipravovat tento soubor změn ani žádné další komplexy v souboru
	g - vybrat soubor změn, k němuž má systém přejít
	/ - najít soubor změn odpovídající danému regulárnímu výrazu
	j - nechat tento soubor změn nerozhodnutý, zobrazit další nerozhodnutý
	J - nechat tento soubor změn nerozhodnutý, zobrazit další komplex
	j - nechat tento soubor změn nerozhodnutý, zobrazit předchozí nerozhodnutý
	J - nechat tento soubor změn nerozhodnutý, zobrazit předchozí komplex
	s - rozdělit aktuální soubor změn do menších komplexů
	e - ručně editovat aktuální soubor změn
	? - nápověda

Chcete-li připravit k zapsání jednotlivé komplexy, většinou zadáte `y` nebo `n`. Přesto se vám může někdy hodit i možnost připravit všechny komplexy v určitých souborech nebo přeskočení komplexu, k němuž se vrátíte později. Připravíte-li k zapsání jednu část souboru a druhou nikoli, bude výstup příkazu status vypadat asi takto:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

Zajímavý je stav souboru simplegit.rb. Oznamuje vám, že několik řádků je připravených k zapsání a několik není. Soubor je částečně připraven k zapsání. V tomto okamžiku můžete ukončit skript interaktivního přidávání a spustit příkaz `git commit`, jímž zapíšete částečně připravené soubory.

K částečné přípravě souboru ostatně nemusíte být nutně v režimu interaktivního přidávání. Stejný skript spustíte také příkazem `git add -p` nebo `git add --patch` z příkazového řádku.

## Odložení ##

Až budete pracovat na některé části svého projektu, často vám může připadat, že je vaše práce poněkud neuspořádaná a vy budete třeba chtít přepnout větve a pracovat na chvíli na něčem jiném. Problém je, že nebudete chtít zapsat revizi nehotové práce, budete se k ní chtít vrátit později. Řešením této situace je odložení (stashing) příkazem `git stash`.

Odložení vezme neuspořádaný stav vašeho pracovního adresáře – tj. změněné sledované soubory a změny připravené k zapsání – a uloží ho do zásobníku nehotových změn, který můžete kdykoli znovu aplikovat.

### Odložení práce ###

Pro názornost uvažujme situaci, že ve svém projektu začnete pracovat na několika souborech a jednu z provedených změn připravíte k zapsání. Spustíte-li příkaz `git status`, uvidíte neuspořádaný stav svého projektu:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Nyní chcete přepnout na jinou větev, ale nechcete zapsat změny, na nichž jste dosud pracovali – proto změny odložíte. Chcete-li do zásobníku odeslat nový odklad, spusťte příkaz `git stash`:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Váš pracovní adresář se vyčistil:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Nyní můžete bez obav přepnout větve a pracovat na jiném úkolu, vaše změny byly uloženy do zásobníku. Chcete-li se podívat, které soubory jste odložili, spusťte příkaz `git stash list`:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

V tomto případě byly už dříve provedeny dva další odklady, a máte tak k dispozici tři různé odklady. Naposledy odložené soubory můžete znovu aplikovat příkazem, který byl uveden už v nápovědě ve výstupu původního příkazu stash: `git stash apply`. Chcete-li aplikovat některý ze starších odkladů, můžete ho určit na základě jeho označení, např. `git stash apply stash@{2}`. Pokud u příkazu neoznačíte konkrétní odklad, Git se automaticky pokusí aplikovat ten nejnovější:

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Jak vidíte, Git se pokusí obnovit změněné soubory, které jste nezapsali a uložili při odkladu. V tomto případě jste měli čistý pracovní adresář, když jste se pokusili odklad aplikovat. Pokusili jste se ho aplikovat na stejnou větev, z níž jste ho uložili. K úspěšnému odkladu však není nezbytně nutné, aby byl pracovní adresář čistý ani abyste ho aplikovali na stejnou větev. Odklad můžete uložit na jedné větvi, později přepnout na jinou větev a aplikovat změny tam. Když aplikujete odklad, můžete mít v pracovním adresáři také změněné a nezapsané soubory. Nebude-li něco aplikováno čistě, Git vám oznámí konflikty při slučování.

Změny byly znovu aplikovány na vaše soubory, ale soubor, který jste předtím připravili k zapsání, nebyl znovu připraven. Chcete-li, aby se příkaz pokusil znovu aplikovat i změny připravené k zapsání, musíte zadat příkaz `git stash apply` s parametrem `--index`. Pokud jste spustili příkaz v této podobě, vrátili jste se zpět na svou původní pozici:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Parametr apply se pouze pokusí aplikovat odloženou práci, ta zůstává uložena ve vašem zásobníku. Chcete-li ji odstranit, spusťte příkaz `git stash drop` s názvem odkladu, který má být odstraněn:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Můžete také spustit příkaz `git stash pop`, jímž odklad aplikujete a současně ho odstraníte ze zásobníku.

### Odvolání odkladu ###

V některých případech můžete chtít aplikovat odložené změny, udělat nějakou práci, a pak odvolat změny, které byly v odkladu původně. Git nenabízí žádný příkaz ve smyslu `stash unapply`, ovšem je možné použít reverzní aplikaci patche reprezentujícího odklad:

    $ git stash show -p stash@{0} | git apply -R

Jestliže nespecifikujete konkrétní odklad, Git předpokládá odklad poslední:

    $ git stash show -p | git apply -R

Můžete si také vytvořit alias a do svého gitu přidat například příkaz `stash-unapply`:

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

### Vytvoření větve z odkladu ###

Jestliže odložíte část své práce, necháte ji určitou dobu v zásobníku a budete pokračovat ve větvi, z níž jste práci odložili, můžete mít problémy s opětovnou aplikací odkladu. Pokud se příkaz apply pokusí změnit soubor, který jste mezitím ručně změnili jinak, dojde ke konfliktu při slučování, který budete muset vyřešit. Pokud byste uvítali jednodušší způsob, jak znovu otestovat odložené změny, můžete spustit příkaz `git stash branch`, který vytvoří novou větev, stáhne do ní revizi, na níž jste se nacházeli při odložení práce, a aplikuje na ni vaši práci. Proběhne-li aplikace úspěšně, Git odklad odstraní:

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Jedná se o příjemný a jednoduchý způsob, jak obnovit odloženou práci a pokračovat na ní v nové větvi.

## Přepis historie ##

Při práci se systémem Git možná budete z nějakého důvodu čas od času potřebovat poopravit historii revizí. Jednou ze skvělých možností, které vám Git nabízí, jsou rozhodnutí na poslední chvíli. Jaké soubory budou součástí jaké revize? To můžete rozhodnout až těsně před tím, než soubory zapíšete z oblasti připravených změn. Můžete se rozmyslet, že jste na něčem ještě nechtěli pracovat, a použít možnost odložení. A stejně tak můžete přepsat už jednou zapsané revize. Budou vypadat, jako by byly zapsány v jiné podobě. K této možnosti patří změna pořadí revizí, změny ve zprávách nebo úprava souborů v revizích, komprimace i dělení revizí nebo třeba jejich úplné odstranění. Všechno toto můžete provést, dokud nezačnete sdílet revize s ostatními.

V této části se dozvíte, jak se tyto velmi užitečné úkony provádějí, abyste mohli svou historii revizí před zveřejněním upravit podle svých představ.

### Změna poslední revize ###

Změna poslední revize je pravděpodobně nejobvyklejším způsobem přepsání historie, který budete provádět. Na poslední revizi budete často chtít měnit dvě věci: zprávu k revizi nebo čerstvě zapsaný snímek, v němž budete chtít přidat, změnit nebo odstranit soubory.

Chcete-li pouze změnit zprávu k poslední revizi, je to velmi jednoduché:

	$ git commit --amend

Tím se přesunete do textového editoru, v němž bude otevřena vaše poslední zpráva k revizi. Nyní ji můžete upravit. Po uložení změn a zavření editoru zapíše editor novou revizi, která bude obsahovat upravenou zprávu a která bude vaší novou poslední revizí.

Pokud jste zapsali revizi a uvědomíte si, že jste např. zapomněli přidat nově vytvořený soubor, a proto byste chtěli zapsaný snímek změnit (tedy přidat nebo změnit soubory), je postup ke změně v podstatě stejný. Změny, které chcete zapsat, připravíte tím způsobem, že upravíte příslušné soubory a použijete na ně příkaz `git add`, resp. `git rm`. Příkaz `git commit --amend` poté vezme vaši oblast připravených změn v aktuální podobě a vytvoří snímek nové revize.

Tady byste měli být opatrní, protože oprava revize změní také její hodnotu SHA-1. Je to něco jako malé přeskládání – neopravujte poslední revizi, pokud jste ji už odeslali.

### Změna několika zpráv k revizím ###

Chcete-li změnit revizi, která leží hlouběji ve vaší historii, budete muset sáhnout po složitějších nástrojích. Git nemá zvláštní nástroj k úpravě historie, ale můžete využít nástroje přeskládání, jímž přeskládáte sérii revizí na revizi HEAD, na níž se původně zakládaly. Revize není třeba přesouvat jinam. S interaktivním nástrojem přeskládání pak můžete zastavit po každé revizi, kterou chcete upravit, a změnit u ní zprávu, přidat soubory nebo cokoli dalšího. Interaktivní režim přeskládání spustíte příkazem `git rebase` s parametrem `-i`. Musíte specifikovat, jak hluboko do historie se chcete vrátit a přepisovat revize. K příkazu proto musíte zadat, na jakou revizi si přejete přeskládání provést.

Pokud chcete například změnit zprávy u posledních tří revizí nebo jakoukoli zprávu k revizi z této skupiny, přidejte jako parametr k příkazu `git rebase -i` rodiče poslední revize, kterou chcete upravovat, v tomto případě tedy `HEAD~2^` nebo `HEAD~3`. Snazší k zapamatování je varianta s výrazem `~3`, neboť se pokoušíte upravit poslední tři revize. Nezapomeňte ale, že tím ve skutečnosti označujete čtvrtou revizi od konce, tedy rodiče poslední revize, kterou chcete upravit:

	$ git rebase -i HEAD~3

Mějte na paměti, že se stále jedná o příkaz přeskládání a každá revize zahrnutá v intervalu `HEAD~3..HEAD` bude přepsána, ať už její zprávu změníte, nebo ponecháte. Neměňte tímto způsobem žádné revize, které už jste odeslali na centrální server, způsobili byste tím problémy ostatním vývojářům, kteří by se museli potýkat s jinou verzí téže změny.

Spuštěním tohoto příkazu otevřete textový editor se seznamem revizí zhruba v této podobě:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

Tady bychom chtěli upozornit, že revize jsou uvedeny v opačném pořadí, než jste zvyklí v případě příkazu `log`. Po spuštění příkazu `log` by se zobrazilo následující:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Všimněte si, že se pořadí obrátilo. V interaktivním režimu přeskládání se nyní spustí skript. Začne na revizi, kterou jste označili na příkazovém řádku (`HEAD~3`), a přehraje změny provedené v každé z těchto revizí od shora dolů. Seznam uvádí nejstarší revizi nahoře z toho důvodu, že to bude první revize, kterou příkaz přehraje.

Skript je třeba upravit tak, aby zastavil na revizi, v níž chcete provést změny. Změňte proto slovo pick na edit pro každou z revizí, po níž má skript zastavit. Chcete-li například změnit pouze zprávu ke třetí revizi, změňte soubor následovně:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Po uložení změn a zavření editoru vás Git vrátí zpět na poslední revizi v seznamu a zobrazí vám příkazový řádek s touto zprávou:

<!-- This is actually weird, as the SHA-1 of 7482e0d is not present in the list,
nor is the commit message. Please review
-->

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Tyto instrukce vám sdělují, že nyní můžete upravit revizi příkazem git commit --amend, a až budete se změnami hotovi, spustit příkaz git rebase --continue. Zadejme tedy:

	$ git commit --amend

Změňte zprávu k revizi a zavřete textový editor. Poté spusťte příkaz:

	$ git rebase --continue

Tento příkaz automaticky aplikuje zbývající dvě revize. Tím je celý proces dokončen. Změníte-li výraz pick na edit na více řádcích, můžete tyto kroky opakovat pro každou revizi, u níž jste změnu provedli. Git pokaždé zastaví, nechá vás revizi upravit, a až budete hotovi, bude pokračovat.

### Změna pořadí revizí ###

Interaktivní přeskládání můžete použít rovněž ke změně pořadí revizí nebo k jejich odstranění. Budete-li chtít odstranit revizi „added cat-file“ a současně změnit pořadí, v němž se vyskytují zbývající dvě revize, změňte skript přeskládání z podoby:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

na:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Jakmile uložíte změny a zavřete editor, Git vrátí vaši větev zpět na rodiče těchto revizí, aplikuje revizi `310154e`, po ní revizi `f7f3f6d` a zastaví. Jednoduše jste změnili pořadí těchto revizí a zároveň jste zcela odstranili revizi „added cat-file“.

### Komprimace revize ###

Další možností, jak lze využít interaktivního nástroje přeskládání, je komprimace série revizí do jediné revize. Skript vám ve zprávě k přeskládání podává užitečné instrukce:

	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

Zadáte-li místo pick nebo edit instrukci pro komprimaci squash, Git aplikuje změnu na tomto řádku a změnu těsně před ní a zároveň sloučí dohromady obě zprávy k revizím. Chcete-li tedy vytvořit jedinou revizi z těchto tří revizí, bude skript vypadat takto:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Po uložení změn a zavření editoru aplikuje Git všechny tři změny a znovu otevře textový editor, abyste sloučili všechny zprávy k revizím:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Po uložení zprávy budete mít jedinou revizi, která bude obsahovat všechny změny předchozích tří revizí.

### Rozdělení revize ###

Rozdělení revize vrátí všechny změny v revizi obsažené a po částech je znovu připraví a zapíše do tolika revizí, kolik určíte jako konečný počet. Řekněme, že chcete rozdělit třeba prostřední ze svých tří revizí. Revizi „updated README formatting and added blame“ chcete rozdělit do dvou jiných: „updated README formatting“ jako první a „added blame“ jako druhou. Můžete to provést pomocí skriptu `rebase -i`. U revize, kterou si přejete rozdělit, změňte instrukci na edit:

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Až vás poté skript přesune na příkazový řádek, resetujete revizi, vezmete změny, které jste resetovali, a vytvoříte z nich několik dílčích revizí. Až uložíte změny a zavřete editor, Git se vrátí na rodiče první revize ve vašem seznamu, aplikuje první revizi (`f7f3f6d`), aplikuje druhou revizi (`310154e`) a přesune vás na konzoli. Tam můžete vytvořit smíšený reset této revize pomocí příkazu `git reset HEAD^`, který efektivně vrátí všechny změny v revizi a ponechá změněné soubory nepřipraveny k zapsání. Nyní můžete připravit a zapsat soubory. Až budete mít jednotlivé revize hotové a budete spokojeni s jejich podobou, zadejte příkaz `git rebase --continue`:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git aplikuje poslední revizi (`a5f4a0d`) ve skriptu. Vaše historie bude vypadat takto:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Také v tomto případě se změní hodnoty SHA všech revizí v seznamu, a proto se nejprve ujistěte, že seznam neobsahuje žádné revize, které jste už odeslali do sdíleného repozitáře.

### Pitbul mezi příkazy: filter-branch ###

Existuje ještě další možnost přepisu historie, kterou vám Git nabízí pro případy, kdy potřebujete skriptovatelným způsobem přepsat větší počet revizí, např. globálně změnit e-mailovou adresu nebo odstranit jeden soubor ze všech revizí. Příkaz pro tento případ je `filter-branch`. Dokáže přepsat velké části vaší historie, a proto byste ho určitě neměli používat, pokud už byl váš projekt zveřejněn a ostatní uživatelé už založili svou práci na revizích, které hodláte přepsat. Příkaz přesto může být velmi užitečný. Dále poznáte několik běžných situací, v nichž ho lze použít, a získáte tak představu, co všechno příkaz dovede.

#### Odstranění souboru ze všech revizí ####

Toto je opravdu velmi častá situace. Někdo příkazem `git add .` bezmyšlenkovitě zapsal obří binární soubor a vy ho chcete odstranit ze všech revizí. Nebo jste omylem zapsali soubor obsahující vaše heslo, ale chcete, aby byl váš projekt veřejný. Nástrojem, který hledáte k opravení celé historie, je `filter-branch`. Pro odstranění souboru s názvem passwords.txt z celé historie můžete použít parametr `--tree-filter`, který přidáte k příkazu `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

Parametr `--tree-filter` spustí zadaný příkaz po každém checkoutu projektu a znovu zapíše jeho výsledky. V tomto případě odstraníte soubor s názvem passwords.txt ze všech snímků, ať v nich existuje, nebo neexistuje. Chcete-li odstranit všechny nedopatřením zapsané záložní soubory editoru, můžete spustit zhruba toto: `git filter-branch --tree-filter "rm -f *~" HEAD`.

Uvidíte, jak Git přepisuje stromy a revize a poté přemístí ukazatel větve na konec. Většinou se vyplatí provádět toto všechno v testovací větvi a k tvrdému resetu hlavní větve přistoupit až poté, co se ujistíte, že výsledek odpovídá vašim očekáváním. Chcete-li spustit příkaz `filter-branch` na všech větvích, zadejte k příkazu parametr `--all`.

#### Povýšení podadresáře na nový kořenový adresář ####

Předpokládejme, že jste dokončili import z jiného systému ke správě zdrojového kódu a máte podadresáře, které nedávají žádný smysl (trunk, tags apod.). Chcete-li udělat z podadresáře `trunk` nový kořenový adresář projektu pro všechny revize, i s tím vám pomůže příkaz `filter-branch`:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Vaším nový kořenovým adresářem je nyní obsah podadresáře `trunk`. Git také automaticky odstraní revize, které nemají na podadresář žádný vliv.

#### Globální změna e-mailové adresy ####

Dalším častým případem bývá, že uživatel zapomene spustit příkaz `git config` a nastavit své jméno a e-mailovou adresu, než začne se systémem Git pracovat. Stejně tak se může stát, že budete chtít převést pracovní projekt na otevřený zdrojový kód a změnit všechny své pracovní e-mailové adresy na soukromé. V obou těchto případech můžete změnit e-mailové adresy v několika revizích hromadně příkazem `filter-branch`. Měli byste být opatrní, abyste změnili jen e-mailové adresy, které jsou opravdu vaše. Použijte proto parametr `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

Příkaz projde a přepíše všechny revize tak, aby obsahovaly novou adresu. Protože revize obsahují hodnoty SHA-1 svých rodičů, změní tento příkaz SHA všech revizí ve vaší historii, ne pouze těch, které mají odpovídající e-mailovou adresu.

### Velmi rychlá a nebezpečná zbraň: Big Friendly Giant Repo Cleaner (BFG) ###

[Roberto Tyley](https://github.com/rtyley) vytvořil nástroj, který se funkčností podobá `filter-branch` a nazval jej BFG. (Celý název lze doslova přeložit jako Velký, přátelský, obří čistič repozitáře --- představte si pod tím, co chcete.) BFG neumí tolik věcí jako `filter-branch`, ale je *velmi* rychlý. Pro velké repozitáře to může být zásadní rozdíl. Pokud lze vámi zamýšlenou změnu pomocí BFG provést a pokud máte problémy s výkonností prostředí, pak byste o použití tohoto nástroje měli uvažovat.

Podrobnosti naleznete na stránkách [BFG](http://rtyley.github.io/bfg-repo-cleaner/).

## Ladění v systému Git ##

Git také nabízí několik nástrojů, které vám pomohou ladit problémy v projektech. Protože je Git navržen tak, aby pracoval téměř s jakýmkoli typem projektu, jsou tyto nástroje velmi univerzální. Často vám mohou pomoci odhalit vzniklou chybu nebo problém.

### Anotace souboru ###

Zjistíte-li ve svém zdrojovém kódu chybu a chcete vědět, kdy a jak vznikla, je často nejlepším nástrojem anotace souboru (file annotation). Ukáže vám, při které revizi byly jednotlivé řádky každého souboru naposledy změněny. Pokud zjistíte, že některá metoda ve vašem kódu obsahuje chybu, můžete soubor anotovat příkazem `git blame`, který u každého řádku metody zobrazí, kdo a kdy ho naposledy upravil. Následující příklad používá parametr `-L`, který omezí výstup na řádky 12 až 22:

	$ git blame -L 12,22 simplegit.rb
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

Všimněte si, že první pole je část hodnoty SHA-1 revize, v níž byl řádek naposled změněn. Další dvě pole jsou hodnoty získané z revize: jméno autora a datum, zapsané u této revize. Z toho vyčtete, kdo a kdy tento řádek upravil. Za tímto údajem následuje číslo řádku a obsah souboru. Všimněte si také řádků revize `^4832fe2`, které oznamují, že tyto řádky byly obsaženy v originální revizi tohoto souboru. Tato revize vznikla prvním přidáním tohoto souboru do projektu a tyto řádky zůstaly od té doby nezměněny. Je to trochu matoucí, protože jsme před chvílí viděli minimálně tři různé způsoby, jak Git používá znak `^` k modifikaci hodnoty SHA revize. Tady má tento znak jiný význam.

Další skvělou věcí na systému Git je, že explicitně nesleduje přejmenování souboru. Zaznamenává snímky a poté se snaží zjistit, co bylo později implicitně přejmenováno. Zajímavou funkcí je také to, že můžete systému Git zadat, aby zjistil všechny druhy přesouvání kódu. Zadáte-li k příkazu `git blame` parametr `-C`, Git zanalyzuje soubor, který anotujete, a pokud jednotlivé kousky kódu v něm obsažené pocházejí původně odjinud, pokusí se Git zjistit odkud. Nedávno jsem refaktoroval soubor s názvem `GITServerHandler.m` do několika jiných souborů, jeden z nich se jmenoval `GITPackUpload.m`. Když jsem zadal příkaz `GITPackUpload.m` s parametrem `-C`, dostal jsem informace, odkud původně pocházejí jednotlivé kousky kódu:

	$ git blame -C -L 141,153 GITPackUpload.m
	f344f58d GITServerHandler.m (Scott 2009-01-04 141)
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

Tato funkce je opravdu užitečná. Normálně se jako původní revize zobrazí ta, kam jste kód zkopírovali, protože to bylo poprvé, kdy jste v daném souboru sáhli do těchto řádků. Git vám vyhledá původní revizi, kde jste tyto řádky napsali, dokonce i když jsou v jiném souboru.

### Binární vyhledávání ###

Anotace souboru má smysl, pokud víte, kde problém hledat. Pokud nemáte ponětí, co může chybu způsobovat, a od posledního zaručeně funkčního stavu kódu byly zapsány desítky nebo stovky revizí, možná budete pomoc hledat raději u příkazu `git bisect`. Příkaz `bisect` zahájí binární vyhledávání ve vaší historii revizí a pomůže vám co nejrychleji identifikovat, která revize je původcem problému.

Řekněme, že jste právě odeslali vydání svého zdrojového kódu do produkčního prostředí, ale dostanete hlášení o chybě, která se ve vašem vývojovém prostředí nevyskytovala, a nemáte tušení, proč kód takto zlobí. Vrátíte se zpět ke svému kódu, a ukáže se, že dokážete problém reprodukovat, ne však identifikovat. K odhalení problému můžete použít příkaz bisect (tedy „rozpůlit“). Nejprve spustíte příkaz `git bisect start`, jímž celý proces zahájíte, a poté použijete příkaz `git bisect bad`, jímž systému oznámíte, že aktuální revize, na níž se právě nacházíte, obsahuje chybu. Poté musíte nástroji bisect sdělit, kdy byl kód naposled nepochybně funkční. K tomu použijete příkaz `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git zjistil, že mezi revizí, kterou jste označili jako poslední dobrou (v1.0), a aktuální problémovou verzí je asi 12 revizí, a provedl checkout prostřední revize. Nyní můžete provést testování a vyzkoušet, zda problém existuje i v této revizi. Pokud ano, vznikla chyba někdy před touto prostřední revizí; pokud ne, pak je problém záležitostí revizí zapsaných až po této prostřední revizi. Ukáže se, že na této revizi k problému nedochází, a tak to systému Git sdělíte příkazem `git bisect good` a budete v hledání pokračovat:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Nyní jste na jiné revizi, na půl cesty mezi revizí, kterou jste právě otestovali, a problémovou revizí. Znovu provedete svůj test a zjistíte, že tato revize vykazuje chybu. Systému Git to sdělíte příkazem `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Tato revize je v pořádku, a Git tak má nyní všechny informace, které potřebuje k určení, kde problém vznikl. Sdělí vám SHA-1 první revize s chybou a zobrazí některé další informace o revizi a o tom, které soubory byly v této revizi změněny. Zjistíte tak, co bylo součástí revize a co může způsobovat hledanou chybu:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Až vyhledávání dokončíte, měli byste použít příkaz `git bisect reset`, abyste se vrátili do jednoznačného stavu. Příkaz vrátí váš ukazatel HEAD na pozici, z níž jste vyhledávání zahajovali:

	$ git bisect reset

bisect je výkonný nástroj, který vám může pomoci zkontrolovat za pár minut i stovky revizí s neurčitou chybou. A máte-li skript, jehož výstupem bude 0, pokud je projekt v pořádku, nebo nenulovou hodnotu, pokud je v projektu chyba, můžete příkaz `git bisect` dokonce plně automatizovat. Nejprve opět zadáte poslední známé revize s chybou a bez ní, jimiž vytyčíte cílovou oblast pro příkaz bisect. Chcete-li, můžete to provést příkazem `bisect start` – jako první uvedete známou revizi s chybou, jako druhá bude následovat poslední známá dobrá revize:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Automaticky se spustí `test-error.sh` na všech načtených revizích, dokud Git nenajde první revizi s chybou. Podobně můžete spustit také příkaz `make` nebo `make tests` či cokoli jiného, čím spouštíte automatické testování.

## Submoduly ##

Často se stává, že pracujete na jednom projektu, ale na chvíli si potřebujete odskočit do jiného. Jedná se třeba o knihovnu, kterou vyvinula třetí strana, nebo kterou vyvíjíte odděleně a používáte ji v několika nadřazených projektech. V obou případech se budete potýkat se stejným problémem: oba projekty chcete zachovat samostatné, a přesto potřebujete používat jeden v rámci druhého.

Uveďme malý příklad. Programujete webové stránky a vytváříte kanály Atom. Místo abyste psali vlastní zdrojový kód ke kanálům Atom, rozhodnete se použít knihovnu. Pravděpodobně budete muset použít tento kód ze sdílené knihovny, jako CPAN install nebo Ruby gem, nebo zkopírovat zdrojový kód do vlastního stromu projektu. Problém s použitím knihovny je ten, že je obtížné knihovnu jakýmkoli způsobem upravit a často ještě těžší ji nasadit, protože se musíte ujistit, že ji má k dispozici každý klient. Problémem s převzetím zdrojového kódu do vlastního projektu bývá, že jakékoli uživatelské změny, které provedete, se obtížně začleňují, pokud se objeví novější změny.

Git nabízí jako řešení tohoto problému nástroj submodulů. Submoduly umožňují uchovávat repozitář Git jako podadresář jiného repozitáře Git. Do svého projektu tak můžete naklonovat jiný repozitář a uchovávat revize oddělené.

### Začátek práce se submoduly ###

Předpokládejme, že budete chtít vložit do svého projektu knihovnu Rack (rozhraní brány webového serveru Ruby), udržovat v ní vlastní změny, ale nadále začleňovat i změny ze serveru. První věcí, kterou byste měli udělat, je naklonovat externí repozitář do vlastního podadresáře. Externí projekty přidáte do svého projektu jako submoduly příkazem `git submodule add`:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Nyní máte projekt Rack uložen ve svém projektu v podadresáři `rack`. Můžete přejít do tohoto podadresáře, provést změny, přidat vlastní vzdálený repozitář s oprávněním k zápisu, kam budete změny odesílat, vyzvednout a začlenit data z původního repozitáře atd. Pokud byste bezprostředně po přidání submodulu spustili příkaz `git status`, viděli byste dvě věci:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

Zaprvé si všimnete souboru `.gitmodules`. Jedná se o konfigurační soubor, v němž je uloženo mapování mezi adresou URL projektu a lokálním podadresářem, do nějž jste stáhli repozitář.

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

Máte-li submodulů více, bude v tomto souboru několik záznamů. Za zmínku stojí, že je tento soubor verzován spolu s ostatními soubory, podobně jako třeba soubor `.gitignore`. Soubor se odesílá a stahuje se zbytkem projektu. Ostatní uživatelé, kteří budou tento projekt klonovat, díky tomu zjistí, kde najdou projekty submodulů.

Tím dalším, co se objevuje ve výstupu příkazu `git status`, je položka rack. Pokud na ni použijete příkaz `git diff`, uvidíte zajímavou věc:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Ačkoli je `rack` podadresářem ve vašem pracovním adresáři, Git ví, že se jedná o submodul, a dokud se v tomto adresáři nenacházíte, nesleduje jeho obsah. Místo toho zaznamenává Git konkrétní revizi z tohoto adresáře. Provedete-li v tomto podadresáři změny a zapíšete revizi, superprojekt (tedy celkový, nadřízený projekt) zjistí, že se tu ukazatel HEAD změnil, a zaznamená přesnou revizi, na níž právě pracujete. Pokud pak tento projekt naklonují jiní uživatelé, budou schopni přesně obnovit původní prostředí.

Toto je důležitá vlastnost submodulů: zaznamenáváte je jako přesné revize, na nichž se nacházejí. Submodul nelze zaznamenat na větvi `master` nebo na jiné symbolické referenci.

Jestliže zapíšete revizi, zobrazí se přibližně toto:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Všimněte si režimu (mode) 160000 u záznamu rack. Jedná se o speciální režim systému Git, který udává, že revizi zaznamenáváte jako adresář, ne jako podadresář nebo soubor.

S adresářem `rack` můžete pracovat jako se samostatným projektem a čas od času aktualizovat superprojekt ukazatelem na nejnovější revizi v tomto subprojektu. Všechny příkazy Git pracují v obou adresářích nezávisle:

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### Klonování projektu se submoduly ###

Nyní naklonujeme projekt, jehož součástí je submodul. Pokud takový projekt obdržíte, získáte adresáře, které tyto submoduly obsahují, ale zatím žádný soubor:

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

Máte sice adresář `rack`, ten je však prázdný. Budete muset použít dva příkazy: `git submodule init` k inicializaci lokálního konfiguračního souboru a `git submodule update` k vyzvednutí všech dat z tohoto projektu a checkoutu příslušné revize uvedené ve vašem superprojektu:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Váš podadresář `rack` je nyní přesně ve stejném stavu, jako když jste předtím zapisovali revizi. Jestliže jiný vývojář provede změny v kódu adresáře rack a zapíše je do revize a vy poté tuto referenci stáhnete a začleníte, dostanete něco, co bude vypadat poněkud zvláštně:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

Začlenili jste něco, co je v podstatě změna ukazatele vašeho submodulu. Neaktualizovali jste tím však zdrojový kód v adresáři submodulu, takže to vypadá, jako že je váš pracovní adresář v chaotickém stavu:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

A tak to opravdu je. Ukazatel, který máte pro submodul, není to, co máte skutečně v adresáři submodulu. Abyste tento problém vyřešili, spusťte ještě jednou příkaz `git submodule update`:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

To budete muset udělat pokaždé, když stáhnete změnu v submodulu v hlavním projektu. Je to sice trochu zvláštní, ale opravdu to tak funguje.

K tradičním problémům dochází, jestliže vývojář provede lokální změnu v submodulu, ale neodešle ji na veřejný server. Poté zapíše ukazatel do tohoto neveřejného stavu a superprojekt odešle na server. Když se pak ostatní vývojáři pokusí spustit příkaz `git submodule update`, systém submodulu nemůže najít revizi, k níž se vztahuje jedna z referencí, protože existuje pouze v prvním systému vývojáře. Pokud dojde k něčemu takovému, zobrazí se následující chyba:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Musíte zjistit, kdo změnil submodul jako poslední:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Nyní znáte provinilcovu e-mailovou adresu a můžete mu vyčinit.

### Superprojekty ###

Vývojáři někdy chtějí získat kombinaci podadresářů velkého projektu podle toho, v jakém týmu pracují. K tomu může dojít, pokud přecházíte ze systému CVS nebo Subversion, kde jste definovali modul nebo několik podadresářů, a chcete v tomto typu pracovního postupu pokračovat.

Dobrým způsobem, jak to v systému Git provést, je učinit ze všech podsložek oddělené repozitáře Git a vytvořit repozitáře superprojektu Git, které budou obsahovat několik submodulů. Výhodou tohoto postupu je, že můžete podrobněji definovat vztah mezi projekty se značkami a větvemi v superprojektech.

### Problémy se submoduly ###

Používání submodulů se však vždy neobejde bez zádrhelů. Zaprvé je třeba, abyste si v adresáři submodulu počínali opatrně. Spustíte-li příkaz `git submodule update`, provedete tím checkout konkrétní verze projektu, avšak nikoli v rámci větve. Říká se tomu oddělená hlava (detached head) – znamená to, že soubor HEAD ukazuje přímo na revizi, ne na symbolickou referenci. Problém je, že většinou nechcete pracovat v prostředí oddělené hlavy, protože byste tak velmi snadno mohli přijít o provedené změny. Jestliže nejprve spustíte příkaz `submodule update`, zapíšete v adresáři tohoto submodulu revizi, aniž byste na tuto práci vytvořili novou větev, a poté ze superprojektu znovu spustíte příkaz `git submodule update`, aniž byste mezitím zapisovali revize, Git vaše revize bez varování přepíše. Technicky vzato práci neztratíte, ale nebude žádná větev, která by na ni ukazovala, a tak bude poněkud obtížené získat práci zpět.

Aby ve vašem projektu k tomuto problému nedošlo, vytvořte během práce v adresáři submodulu příkazem `git checkout -b work` nebo podobným novou větev. Až budete podruhé provádět příkaz submodule update, i tentokrát sice vrátí vaši práci, ale přinejmenším budete mít ukazatel, k němuž se budete moci vrátit.

Problematické může být také přepínání větví obsahujících submoduly. Vytvoříte-li novou větev, přidáte do ní submodul a poté přepnete zpět na větev bez tohoto submodulu, není adresář submodulu stále ještě sledován:

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

Budete ho muset buď přemístit, nebo odstranit. V druhém případě ho budete muset znovu naklonovat, až přepnete zpět, navíc hrozí, že ztratíte lokální změny nebo větve, které jste neodeslali.

Poslední velký problém s nímž se uživatelé často setkávají, souvisí s přepínáním z podadresářů na submoduly. Pokud jste ve svém projektu sledovali soubory a chcete je přesunout do submodulu, musíte být velmi opatrní, abyste si Git proti sobě nepoštvali. Řekněme, že máte soubory rack v podadresáři svého projektu a chcete ho přepnout do submodulu. Jestliže odstraníte podadresář a spustíte příkaz `submodule add`, Git vám vynadá:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Adresář `rack` už byl připraven k zapsání. Proto ho musíte nejprve vrátit, až potom můžete přidat submodul:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Nyní předpokládejme, že toto vše se odehrálo ve větvi. Pokud se pokusíte přepnout zpět do větve, kde jsou tyto soubory v aktuálním stromu, a ne v submodulu, zobrazí se tato chyba:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Nejprve budete muset přemístit adresář submodulu `rack`, než vám Git dovolí přepnout na větev, která adresář neobsahuje:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Až poté přepnete zpět, bude adresář `rack` prázdný. Buď můžete spustit příkaz `git submodule update` a provést nové klonování, nebo můžete přesunout adresář `/tmp/rack` zpět do prázdného adresáře.

## Začlenění podstromu ##

Nyní, když jsme poznali obtíže spojené se systémem submodulů, podívejme se na jedno alternativní řešení tohoto problému. Git se vždy při slučování nejprve podívá, co a kam začleňuje, a podle toho zvolí vhodnou strategii začlenění. Pokud slučujete dvě větve, používá Git *rekurzivní* strategii. Pokud slučujete více než dvě větve, zvolí Git tzv. strategii *chobotnice* (octopus strategy). Git vybírá tyto strategie automaticky. Rekurzivní strategie zvládá složité třícestné slučování (např. s více než jedním společným předkem), ale nedokáže sloučit více než dvě větve. Chobotnicové sloučení dokáže naproti tomu sloučit několik větví, ale je opatrnější při předcházení složitým konfliktům. Proto je ostatně nastaveno jako výchozí strategie při slučování více než dvou větví.

Existují však ještě další strategie. Jednou z nich je tzv. začlenění *podstromu* (subtree merge), které lze použít jako řešení problémů se subprojektem. Ukažme si, jak se dá začlenit stejný adresář rack jako v předchozí části, tentokrát však s využitím strategie začlenění podstromu.

Začlenění podstromu spočívá v tom, že máte dva projekty a jeden z projektů se promítá do podadresáře druhého projektu a naopak. Pokud určíte strategii začlenění podstromu, je Git natolik inteligentní, aby zjistil, že je jeden podstromem druhého, a provedl sloučení odpovídajícím způsobem – počíná si opravdu sofistikovaně.

Nejprve přidáte aplikaci Rack do svého projektu. Projekt Rack přidáte ve vlastním projektu jako vzdálenou referenci a provedete jeho checkout do vlastní větve:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

Nyní máte kořenový adresář s projektem Rack ve větvi `rack_branch` a vlastní projekt ve větvi `master`. Provedete-li checkout jedné a posléze druhé větve, uvidíte, že mají jiné kořenové adresáře:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Projekt Rack chcete do projektu `master` natáhnout jako podadresář. V systému Git k tomu slouží příkaz `git read-tree`. O příkazu `read-tree` a jeho příbuzných se více dočtete v kapitole 9, nyní však vězte, že načte kořenový strom jedné větve do vaší aktuální oblasti připravených změn a do pracovního adresáře. Přepnuli jste zpět na větev `master` a větev `rack_branch` natáhnete do podadresáře `rack` své větve `master` hlavního projektu:

	$ git read-tree --prefix=rack/ -u rack_branch

Až zapíšete revizi, bude to vypadat, jako byste měli všechny soubory Rack v tomto podadresáři, jako byste je zkopírovali z tarballu. Je zajímavé, že tak lze opravdu jednoduše začlenit změny z jedné větve do druhé. Pokud je proto projekt Rack aktualizován, můžete natáhnout novější změny přepnutím na tuto větev a jejím natažením:

	$ git checkout rack_branch
	$ git pull

Tyto změny pak můžete začlenit zpět do hlavní větve. Můžete použít příkaz `git merge -s subtree` a začlenění proběhne úspěšně. Git však sloučí také obě historie, což pravděpodobně nebylo vaším záměrem. Chcete-li natáhnout změny a předběžně vyplnit zprávu k revizi, použijte parametry `--squash`, `--no-commit` a také parametr strategie `-s subtree`:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Všechny změny z projektu Rack budou začleněny a budete je moci lokálně zapsat. Můžete ale postupovat také opačně – provést změny v podadresáři `rack` vaší hlavní větve, poté je začlenit do větve `rack_branch` a poslat je správcům nebo je odeslat do repozitáře.

Chcete-li se podívat na výpis „diff“ s rozdíly mezi tím, co máte v podadresáři `rack`, a kódem ve větvi `rack_branch` (abyste věděli, jestli je nutné je slučovat), nelze použít běžný příkaz `diff`. V tomto případě je třeba zadat příkaz `git diff-tree` a větev, s níž chcete srovnání provést:

	$ git diff-tree -p rack_branch

Popřípadě chcete-li porovnat, co je ve vašem podadresáři `rack`, s tím, co bylo ve větvi `master` na serveru v okamžiku, kdy jste naposledy vyzvedávali data, spusťte příkaz:

	$ git diff-tree -p rack_remote/master

## Shrnutí ##

V této kapitole jste poznali několik pokročilých nástrojů umožňujících preciznější manipulaci s revizemi a oblastí připravených změn. Vyskytnou-li se jakékoli problémy, měli byste být schopni snadno odhalit závadnou revizi, kdo je jejím autorem a kdy byla zapsána. Chcete-li ve svém projektu využívat subprojekty, znáte nyní několik způsobů, jak to provést. V této chvíli byste měli v systému Git zvládat většinu úkonů, které se běžně používají na příkazovém řádku, a neměly by vám činit větší potíže.
