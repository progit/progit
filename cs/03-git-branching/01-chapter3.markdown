# Větve v systému Git #

Téměř každý systém pro správu verzí podporuje do určité míry větvení. Větvení znamená, že se můžete odloučit od hlavní linie vývoje a pokračovat v práci, aniž byste hlavní linii zanášeli smetím. V mnoha VCS nástrojích se může jednat o poněkud náročný proces, který často vyžaduje vytvoření nové kopie adresáře se zdrojovým kódem. To může – zvláště u velkých projektů – trvat poměrně dlouho.

Někteří lidé mluví o modelu větvení v systému Git jako o převratné vlastnosti. Není sporu o tom, že je Git díky tomu ve skupině systémů pro správu verzí poměrně jedinečný. V čem je jeho větvení tak zvláštní? Větvení je v systému Git neuvěřitelně snadné a operace s ním související probíhají téměř okamžitě. A stejně rychlé je i přepínání mezi jednotlivými větvemi. Na rozdíl od ostatních systémů pro správu verzí vybízí Git ke způsobu práce s bohatým větvením a častým slučováním, a to i několikrát za den. Pokud tuto funkci pochopíte a zvládnete její ovládání, dostanete do ruky výkonný a unikátní nástroj, který doslova změní váš pohled na vývoj.

## Co je to větev ##

Abychom skutečně pochopili, jak funguje v systému Git větvení, budeme se muset vrátit o krok zpět a podívat se, jak Git ukládá data. Jak si možná vzpomínáte z kapitoly 1, Git neukládá data jako sérii změn nebo rozdílů, ale jako sérii snímků.

Zapíšete-li v systému Git revizi, Git uloží objekt revize, obsahující ukazatel na snímek obsahu, který jste určili k zapsání, metadata o autorovi a zprávě a nula nebo více ukazatelů na revizi nebo revize, které byly přímými rodiči této revize: žádné rodiče nemá první revize, jednoho rodiče má běžná revize a několik rodičů mají revize, které vznikly sloučením ze dvou či více větví.

Pro ilustraci předpokládejme, že máte adresář se třemi soubory, které připravíte k zapsání a následně zapíšete. Při přípravě souborů k zapsání je pro každý z nich vypočítán kontrolní součet (o otisku SHA-1 jsme se zmínili v kapitole 1), daná verze souborů se uloží v repozitáři Git (Git na ně odkazuje jako na bloby) a přidá jejich kontrolní součet do oblasti připravených změn:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Vytvoříte-li revizi příkazem `git commit`, provede Git kontrolní součet každého adresáře (v tomto případě pouze kořenového adresáře projektu) a uloží tyto objekty stromu v repozitáři Git. Poté vytvoří objekt revize s metadaty a ukazatelem na kořenový strom projektu, aby mohl v případě potřeby tento snímek obnovit.

Váš gitovský repozitář nyní obsahuje pět objektů: jeden blob pro obsah každého ze tří vašich souborů, jeden strom, který zaznamenává obsah adresáře a udává, které názvy souborů jsou uloženy jako který blob, a jeden objekt revize s ukazatelem na kořenový strom a se všemi metadaty revize. Data ve vašem repozitáři Git se dají schematicky znázornit jako na obrázku 3-1.

Insert 18333fig0301.png
Obrázek 3-1. Repozitář s daty jedné revize

Jestliže v souborech provedete změny a zapíšete je, další revize uloží ukazatel na revizi, jež jí bezprostředně předcházela. Po dalších dvou revizích bude vaše historie vypadat jako na obrázku 3-2.

Insert 18333fig0302.png
Obrázek 3-2. Data objektů Git pro několik revizí

Větev je v systému Git jen snadno přemístitelným ukazatelem na jednu z těchto revizí. Výchozím názvem větve v systému Git je `master` (hlavní větev). Při prvním zapisování revizí dostanete hlavní větev, jež bude ukazovat na poslední revizi, kterou jste zapsali. Pokaždé, když zapíšete novou revizi, větev se automaticky posune vpřed.

Insert 18333fig0303.png
Obrázek 3-3. Větev ukazující do historie dat revizí

Co se stane, když vytvoříte novou větev? Ano, nová větev znamená vytvoření nového ukazatele, s nímž můžete pohybovat. Řekněme, že vytvoříte novou větev a nazvete ji testing. Učiníte tak příkazem `git branch`:

	$ git branch testing

Tento příkaz vytvoří nový ukazatel na stejné revizi, na níž se právě nacházíte (viz obrázek 3-4).

Insert 18333fig0304.png
Obrázek 3-4. Několik větví ukazujících do historie dat revizí

Jak Git pozná, na jaké větvi se právě nacházíte? Používá speciální ukazatel zvaný HEAD. Nenechte se mást, tento HEAD je velmi odlišný od všech koncepcí v ostatních systémech pro správu verzí, na něž jste možná zvyklí, jako Subversion nebo CVS. V systému Git se jedná o ukazatel na lokální větev, na níž se právě nacházíte. V našem případě jste však stále ještě na hlavní větvi. Příkazem `git branch` jste pouze vytvořili novou větev, zatím jste na ni nepřepnuli (viz obrázek 3-5).

Insert 18333fig0305.png
Obrázek 3-5. Soubor HEAD ukazující na větev, na níž se nacházíte.

Chcete-li přepnout na existující větev, spusťte příkaz `git checkout`. My můžeme přepnout na novou větev testing:

	$ git checkout testing

Tímto příkazem přesunete ukazatel HEAD tak, že ukazuje na větev testing (viz obrázek 3-6).

Insert 18333fig0306.png
Obrázek 3-6. Soubor HEAD ukazuje po přepnutí na jinou větev.

A jaký to má smysl? Dobře, proveďme další revizi:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Obrázek 3-7 ukazuje výsledek.

Insert 18333fig0307.png
Obrázek 3-7. Větev, na niž ukazuje soubor HEAD, se posouvá vpřed s každou revizí.

Výsledek je zajímavý z toho důvodu, že se větev `testing` posunula vpřed, zatímco větev `master` stále ukazuje na revizi, na níž jste se nacházeli v okamžiku, kdy jste spustili příkaz `git checkout` a přepnuli tím větve. Přepněme zpět na větev `master`.

	$ git checkout master

Výsledek ukazuje obrázek 3-8.

Insert 18333fig0308.png
Obrázek 3-8. Ukazatel HEAD se po příkazu git checkout přesune na jinou větev.

Tento příkaz provedl dvě věci. Přemístil ukazatel `HEAD` zpět, takže nyní ukazuje na větev `master`, a vrátil soubory ve vašem pracovním adresáři zpět ke snímku, na nějž větev `master` ukazuje. To také znamená, že změny, které od teď provedete, se odštěpí od starší verze projektu. V podstatě dočasně vrátíte všechny změny, které jste provedli ve větvi testing, a vydáte se jiným směrem.

Proveďme pár změn a zapišme další revizi:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Nyní se historie vašeho projektu rozdělila (viz obrázek 3-9). Vytvořili jste novou větev, přepnuli jste na ni, provedli jste v ní změny a poté jste přepnuli zpět na hlavní větev, v níž jste rovněž provedli změny. Oboje tyto změny jsou oddělené na samostatných větvích. Můžete mezi nimi přepínat tam a zpět, a až uznáte za vhodné, můžete je sloučit. To vše jste provedli pomocí jednoduchých příkazů `branch` a `checkout`.

Insert 18333fig0309.png
Obrázek 3-9. Historie větví se rozdělila.

Vzhledem k tomu, že větev v systému Git tvoří jeden jednoduchý soubor, obsahující 40 znaků kontrolního součtu SHA-1 revize, na niž ukazuje, je snadné větve vytvářet i odstraňovat. Vytvořit novou větev je právě tak snadné a rychlé jako zapsat 41 bytů do souboru (40 znaků a jeden znak pro nový řádek).

Tato metoda se výrazně liší od způsobu, jakým probíhá větvení v ostatních nástrojích VCS, kde je nutné zkopírovat všechny soubory projektu do jiného adresáře. To může zabrat – podle velikosti projektu – několik sekund i minut, zatímco v systému Git probíhá tento proces vždy okamžitě. A protože při zapisování revize zaznamenáváme její rodiče, probíhá vyhledávání příslušné základny pro sloučení automaticky a je většinou velmi snadné. Tyto funkce slouží k tomu, aby se vývojáři nebáli vytvářet a používat nové větve.

Podívejme se, proč byste to měli dělat také tak.

## Základy větvení a slučování ##

Vytvořme si jednoduchý příklad větvení a slučování s pracovním postupem, který můžete využít i v reálném životě. Budete provádět tyto kroky:

1.  Pracujete na webových stránkách.
2.  Vytvoříte větev pro novou část stránek, v níž budete pracovat.
3.  Vytvoříte práci v této větvi.

V tomto okamžiku vám zavolají, že se vyskytla jiná kritická chyba, která vyžaduje rychlou opravu (hotfix). Uděláte následující:

1.  Vrátíte se zpět na produkční větev.
2.  Vytvoříte větev pro přidání hotfixu.
3.  Po úspěšném otestování začleníte větev s hotfixem a odešlete ji do produkce.
4.  Přepnete zpět na svou původní část a pokračujete v práci.

### Základní větvení ###

Řekněme, že pracujete na projektu a už jste vytvořili několik revizí (viz obrázek 3-10).

Insert 18333fig0310.png
Obrázek 3-10. Krátká a jednoduchá historie revizí

Rozhodli jste se, že budete pracovat na chybě č. 53, ať už vaše společnost používá jakýkoli systém sledování chyb. Přesněji řečeno, Git není začleněn do žádného konkrétního systému sledování chyb, ale protože je chyba č. 53 významná a chcete na ní pracovat, vytvoříte si pro ni novou větev. Abyste vytvořili novou větev a rovnou na ni přepnuli, můžete spustit příkaz `git checkout` s přepínačem `-b`:

	$ git checkout -b iss53
	Switched to a new branch 'iss53'

Tímto způsobem jste spojili dva příkazy:

	$ git branch iss53
	$ git checkout iss53

Obrázek 3-11 ukazuje výsledek.

Insert 18333fig0311.png
Obrázek 3-11. Vytvoření nového ukazatele na větev

Pracujete na webových stránkách a zapíšete několik revizí. S každou novou revizí se větev `iss53` posune vpřed, protože jste provedli její checkout (to znamená, že na ni přepnuli ukazuje HEAD – viz obrázek 3-12):

	$ vim index.html
	$ git commit -a -m 'add a new footer [issue 53]'

Insert 18333fig0312.png
Obrázek 3-12. Větev iss53 se s vaší prací posouvá vpřed.

V tomto okamžiku vám zavolají, že se na webových stránkách vyskytl problém, který musíte okamžitě vyřešit. Jelikož pracujete v systému Git, nemusíte svou opravu vytvářet uprostřed změn, které jste provedli v části `iss53`, ani nemusíte dělat zbytečnou práci, abyste všechny tyto změny vrátili, než budete moci začít pracovat na opravě produkční verze stránek. Jediné, co teď musíte udělat, je přepnout zpět na hlavní větev.

Než tak učiníte, zkontrolujte, zda nemáte v pracovním adresáři nebo v oblasti připravených změn nezapsané změny, které kolidují s větví, jejíž checkout provádíte. V takovém případě by vám Git přepnutí větví nedovolil. Při přepínání větví je ideální, pokud máte čistý pracovní stav. Existují způsoby, jak to obejít (jmenovitě odložení (stashing) a doplnění revize (commit amending)), těm se však budeme věnovat až později. Pro tuto chvíli jste zapsali všechny provedené změny a můžete přepnout zpět na hlavní větev.

	$ git checkout master
	Switched to branch 'master'

V tomto okamžiku vypadá váš pracovní adresář přesně tak, jak vypadal, než jste začali pracovat na chybě č. 53, a vy se nyní můžete soustředit na rychlou opravu. Tento důležitý bod si zapamatujte: Git vždy vrátí pracovní adresář do stejného stavu, jak vypadal snímek revize, na niž ukazuje větev, jejíž checkout nyní provádíte. Automaticky budou přidány, odstraněny a upraveny soubory tak, aby byla vaše pracovní kopie totožná se stavem větve v okamžiku, kdy jste na ni zapsali poslední revizi.

Nyní přichází na řadu hotfix. Vytvořme větev s hotfixem, v níž budeme pracovat, dokud nebude oprava hotová (viz obrázek 3-13):

	$ git checkout -b hotfix
	Switched to a new branch 'hotfix'
	$ vim index.html
	$ git commit -a -m 'fix the broken email address'
	[hotfix 3a0874c] fix the broken email address
	 1 files changed, 1 deletion(-)

Insert 18333fig0313.png
Obrázek 3-13. Větev „hotfix“ začleněná zpět v místě hlavní větve

Můžete spustit testy, abyste se ujistili, že hotfix splňuje všechny požadavky, a pak můžete větev začlenit (merge) zpět do hlavní větve, aby byla připravena do produkce. Učiníte tak příkazem `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast-forward
	 README | 1 -
	 1 file changed, 1 deletion(-)

Při sloučení jste si možná všimli spojení „Fast forward“ (rychle vpřed). Jelikož revize, na niž ukazovala větev, do níž jste začleňovali, byla v přímé linii s revizí, na níž jste se nacházeli, Git přesunul ukazatel vpřed. Jinými slovy: pokud se pokoušíte sloučit jednu revizi s revizí druhou, k níž lze dospět následováním historie první revize, Git proces zjednoduší a přesune ukazatel vpřed, protože neexistuje žádná rozdílná práce, kterou by bylo třeba sloučit. Tomuto postupu se říká „rychle vpřed“.

Vaše změna je nyní obsažena ve snímku revize, na niž ukazuje hlavní větev `master`, a vy můžete pokračovat v provádění změn (viz obrázek 3-14).

Insert 18333fig0314.png
Obrázek 3-14. Hlavní větev ukazuje po sloučení na stejné místo jako větev „hotfix“.

Poté, co jste dokončili práci na bezodkladné opravě, můžete přepnout zpět na práci, jíž jste se věnovali před telefonátem. Nejprve však smažete větev `hotfix`, kterou teď už nebudete potřebovat – větev `master` ukazuje na totéž místo. Větev smažete přidáním parametru `-d` k příkazu `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (was 3a0874c).

Nyní můžete přepnout zpět na větev s rozdělanou prací a pokračovat na chybě č. 53 (viz obrázek 3-15):

	$ git checkout iss53
	Switched to branch 'iss53'
	$ vim index.html
	$ git commit -a -m 'finish the new footer [issue 53]'
	[iss53 ad82d7a] finish the new footer [issue 53]
	 1 file changed, 1 insertion(+)

Insert 18333fig0315.png
Obrázek 3-15. Větev iss53 může nezávisle postupovat vpřed.

Za zmínku stojí, že práce, kterou jste udělali ve větvi `hotfix`, není obsažena v souborech ve větvi `iss53`. Pokud potřebujete tyto změny do větve vtáhnout, můžete začlenit větev `master` do větve `iss53` provedením příkazu `git merge master`. Druhou možností je s integrací změn vyčkat a provést ji až ve chvíli, kdy budete chtít větev `iss53` vtáhnout zpět do větve `master`.

### Základní slučování ###

Předpokládejme, že jste dokončili práci na chybě č. 53 a nyní byste ji rádi začlenili do větve `master`. Učiníte tak začleněním větve `iss53`, které bude probíhat velmi podobně jako předchozí začlenění větve `hotfix`. Jediné, co pro to musíte udělat, je přepnout na větev, do níž chcete tuto větev začlenit, a spustit příkaz `git merge`.

	$ git checkout master
	$ git merge iss53
	Auto-merging README
	Merge made by the 'recursive' strategy.
	 README | 1 +
	 1 file changed, 1 insertion(+)

Toto už se trochu liší od začlenění větve `hotfix`, které jste prováděli před chvílí. V tomto případě se historie vývoje od určitého bodu v minulosti rozbíhala. Vzhledem k tomu, že revize na větvi, na níž se nacházíte, není přímým předkem větve, kterou chcete začlenit, Git bude muset podniknout určité kroky. Git v tomto případě provádí jednoduché třícestné sloučení: vychází ze dvou snímků, na které ukazují větve, a jejich společného předka. Obrázek 3-16 označuje ony tři snímky, které Git v tomto případě použije ke sloučení.

Insert 18333fig0316.png
Obrázek 3-16. Git automaticky identifikuje nejvhodnějšího společného předka jako základnu pro sloučení větví.

Git tentokrát neposune ukazatel větve vpřed, ale vytvoří nový snímek jako výsledek tohoto třícestného sloučení a automaticky vytvoří novou revizi, která bude na snímek ukazovat (viz obrázek 3-17). Takové revizi se říká revize sloučením (merge commit) a její zvláštností je to, že má více než jednoho rodiče.

Na tomto místě bych chtěl zopakovat, že Git určuje nejvhodnějšího společného předka, který bude použit jako základna pro sloučení, automaticky. Liší se tím od systému CVS i Subversion (před verzí 1.5), kde musí vývojář při slučování najít nejvhodnější základnu pro sloučení sám. Slučování větví je proto v systému Git o poznání jednodušší než v ostatních systémech.

Insert 18333fig0317.png
Obrázek 3-17. Git automaticky vytvoří nový objekt revize, který obsahuje sloučenou práci.

Nyní, když jste svou práci sloučili, větev `iss53` už nebudete potřebovat. Můžete ji smazat a poté ručně zavřít tiket v systému sledování tiketů:

	$ git branch -d iss53

### Základní konflikty při slučování ###

Může se stát, že sloučení neproběhne bez problémů. Pokud jste tutéž část jednoho souboru změnili odlišně ve dvou větvích, které chcete sloučit, Git je nebude umět sloučit čistě. Pokud se oprava chyby č. 53 týkala stejné části souboru jako větev `hotfix`, dojde ke konfliktu při slučování (merge conflict). Vypadá zhruba takto:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git nepřistoupil k automatickému vytvoření nové revize sloučením. Prozatím pozastavil celý proces do doby, než konflikt vyřešíte. Chcete-li kdykoli po konfliktu zjistit, které soubory zůstaly nesloučeny, spusťte příkaz `git status`:

	$ git status
	On branch master
	You have unmerged paths.
	  (fix conflicts and run "git commit")

	Unmerged paths:
	  (use "git add <file>..." to mark resolution)

	        both modified:      index.html

	no changes added to commit (use "git add" and/or "git commit -a")

Vše, co při sloučení kolidovalo a nebylo vyřešeno, je označeno jako „unmerged“ (nesloučeno). Git přidává ke kolidujícím souborům standardní značky pro označení konfliktů (conflict-resolution markers), takže soubor můžete ručně otevřít a konflikty vyřešit. Jedna část vašeho souboru bude vypadat zhruba takto:

	<<<<<<< HEAD
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53

To znamená, že verze ve větvi s ukazatelem HEAD (vaše hlavní větev – v té jste se nacházeli při provádění příkazu merge) je uvedena v horní části tohoto bloku (všechno nad oddělovačem `=======`), verze obsažená ve větvi `iss53` je vše, co se nachází v dolní části. Chcete-li vzniklý konflikt vyřešit, musíte buď vybrat jednu z obou stran, nebo konflikt sloučit sami. Tento konflikt můžete vyřešit například nahrazením celého bloku tímto textem:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Toto řešení obsahuje trochu z každé části a zcela jsem odstranil řádky `<<<<<<<`, `=======` a `>>>>>>>`. Poté, co vyřešíte všechny tyto části ve všech kolidujících souborech, spusťte pro každý soubor příkaz `git add`, jímž ho označíte jako vyřešený. Připravení souboru k zápisu ho v systému Git označí jako vyřešený.
Chcete-li k vyřešení problémů použít grafický nástroj, můžete spustit příkaz `git mergetool`, kterým otevřete příslušný vizuální nástroj pro slučování, a ten vás všemi konflikty provede:

	$ git mergetool

	This message is displayed because 'merge.tool' is not configured.
	See 'git mergetool --tool-help' or 'git help config' for more details.
	'git mergetool' will now attempt to use one of the following tools:
	opendiff kdiff3 tkdiff xxdiff meld tortoisemerge gvimdiff diffuse diffmerge ecmerge p4merge araxis bc3 codecompare vimdiff emerge
	Merging:
	index.html

	Normal merge conflict for 'index.html':
	  {local}: modified file
	  {remote}: modified file
	Hit return to start merge resolution tool (opendiff):

Chcete-li použít jiný než výchozí nástroj pro slučování (Git mi v tomto případě vybral `opendiff`, protože jsem příkaz zadal v systému Mac), všechny podporované nástroje jsou uvedeny na začátku výstupu v části „merge tool candidates“ (možné nástroje pro slučování). Zadejte název nástroje, který chcete použít. V kapitole 7 probereme, jak lze tuto výchozí hodnotu pro vaše prostředí změnit.

Až nástroj pro slučování zavřete, Git se vás zeptá, zda sloučení proběhlo úspěšně. Pokud skriptu oznámíte, že ano, připraví soubor k zapsání a tím ho označí jako vyřešený.

Ještě jednou můžete spustit příkaz `git status`, abyste si ověřili, že byly všechny konflikty vyřešeny:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   index.html


Pokud jste s výsledkem spokojeni a ujistili jste se, že všechny kolidující soubory jsou připraveny k zapsání, můžete zadat příkaz `git commit` a dokončit revizi sloučením. Zpráva revize má v takovém případě přednastavenu tuto podobu:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a merge.
	# If this is not correct, please remove the file
	#       .git/MERGE_HEAD
	# and try again.
	#

Pokud myslíte, že to může být pro spolupracovníky, kteří si jednou budou toto sloučení prohlížet, užitečné, můžete tuto zprávu upravit a doplnit o podrobnosti, jak jste sloučení vyřešili – pokud to není zřejmé, můžete okomentovat, co jste udělali a proč právě takto.

## Správa větví ##

Nyní, když jste vytvořili, sloučili a odstranili své první větve, můžeme se podívat na pár nástrojů ke správě větví, které se vám budou hodit, až začnete s větvemi pracovat pravidelně.

Příkaz `git branch` umí víc, než jen vytvářet a mazat větve. Pokud ho spustíte bez dalších parametrů, získáte prostý výpis všech aktuálních větví:

	$ git branch
	  iss53
	* master
	  testing

Všimněte si znaku `*`, který předchází větvi `master`. Označuje větev, na níž se právě nacházíte. Pokud tedy nyní zapíšete revizi, vaše nová práce posune vpřed větev `master`. Chcete-li zobrazit poslední revizi na každé větvi, spusťte příkaz `git branch -v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Další užitečnou funkcí ke zjištění stavu vašich větví je filtrování tohoto seznamu podle větví, které byly/nebyly začleněny do větve, na níž se právě nacházíte. K tomuto účelu slouží v systému Git od verze 1.5.6 užitečné příkazy `--merged` a `--no-merged`. Chcete-li zjistit, které větve už byly začleněny do větve, na níž se nacházíte, spusťte příkaz `git branch --merged`:

	$ git branch --merged
	  iss53
	* master

Jelikož už jste větev `iss53` začlenili, nyní se zobrazí ve výpisu. Větve v tomto seznamu, které nejsou označeny `*`, lze většinou snadno smazat příkazem `git branch -d`. Jejich obsah už jste převzali do jiné větve, a tak jejich odstraněním nepřijdete o žádnou práci.

Chcete-li zobrazit větve, které obsahují dosud nezačleněnou práci, spusťte příkaz `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Nyní se zobrazila jiná větev. Jelikož obsahuje práci, která ještě nebyla začleněna, bude pokus o její smazání příkazem `git branch -d` neúspěšný:

	$ git branch -d testing
	error: The branch 'testing' is not fully merged.
	If you are sure you want to delete it, run 'git branch -D testing'.

Pokud chcete větev skutečně odstranit a zahodit práci, kterou obsahuje, můžete si to vynutit parametrem `-D` (jak napovídá užitečná zpráva pod řádkem s chybovým hlášením).

## Možnosti při práci s větvemi ##

Teď, když jste absolvovali základní seznámení s větvemi a jejich slučováním, nabízí se otázka, k čemu je to vlastně dobré. Proto se v této části podíváme na některé běžné pracovní postupy, které vám neobyčejně snadné větvení umožňuje, a můžete se zamyslet nad tím, zda větve při své vývojářské práci využijete, či nikoli.

### Dlouhé větve ###

Vzhledem k tomu, že Git používá jednoduché třícestné slučování, je velmi snadné začleňovat jednu větev do druhé i několikrát v rámci dlouhého časového intervalu. Můžete tak mít několik větví, které jsou stále otevřené a které používáte pro různé fáze vývojového cyklu. Pravidelně můžete začleňovat práci z jedné větve do ostatních.

Mnoho vývojářů systému Git používá pracovní postup, kdy mají ve větvi `master` pouze kód, který je stoprocentně stabilní — třeba jen kód, který byl nebo bude součástí vydání. Kromě ní mají další paralelní větev, pojmenovanou `develop` nebo `next`, v níž skutečně pracují nebo testují stabilitu kódu. Tato větev nemusí být nutně stabilní, ale jakmile se dostane do stabilního stavu, může být začleněna do větve `master`. Do ní se vtahují tématické větve (ty dočasné, jako byla vaše větev `iss53`) ve chvíli, kdy jsou připravené a je jisté, že projdou všemi testy a nezavlečou chyby.

Ve skutečnosti hovoříme o ukazatelích pohybujících se vzhůru po linii revizí, které zapisujete. Stabilní větve leží v linii historie revizí níže a nové, neověřené větve se nacházejí nad nimi (viz obrázek 3-18).

Insert 18333fig0318.png
Obrázek 3-18. Stabilnější větve většinou leží v historii revizí níže.

Snáze si je můžeme představit jako pracovní zásobníky, v nichž se sada revizí dostává do stabilnějšího zásobníku, když úspěšně absolvovala testování (viz obrázek 3-19).

Insert 18333fig0319.png
Obrázek 3-19. Větve si můžeme představit jako zásobníky

Tento postup lze použít hned pro několik úrovní stability. Některé větší projekty mají také větev `proposed` nebo `pu` (proposed updates, návrh aktualizací) s integrovanými větvemi, které nemusí být nutně způsobilé k začlenění do větve `next` nebo `master`. Idea je taková, že se větve nacházejí na různé úrovni stability. Jakmile dosáhnou stability o stupeň vyšší, jsou začleněny do větve nad nimi.
Není nutné používat při práci několik dlouhých větví, ale často to může být užitečné, zejména pokud pracujete ve velmi velkých nebo komplexních projektech.

### Tematické větve ###

Naproti tomu tematické větve se vám budou hodit v projektech jakékoli velikosti. Tematická větev (topic branch) je krátkodobá větev, kterou vytvoříte a používáte pro jediný konkrétní účel nebo práci. Je to záležitost, do které byste se v jiném systému pro správu verzí asi raději nikdy nepustili, protože vytvářet a slučovat větve je v něm opravdu složité. V systému Git naopak není výjimkou vytvářet, používat, slučovat a mazat větve i několikrát denně.

Viděli jste to v předchozí části, kdy jste si vytvořili větve `iss53` a `hotfix`. Provedli jste v nich pár revizí a smazali jste je hned po začlenění změn do hlavní větve. Tato technika umožňuje rychlé a snadné kontextové přepínání. Protože je vaše práce rozdělena do zásobníků, kde všechny změny v jedné větvi souvisí s jedním tématem, je při kontrole kódu snazší dohledat, čeho se změny týkaly apod. Změny tu můžete uchovávat několik minut, dní i měsíců a začlenit je přesně ve vhodnou chvíli. Na pořadí, v jakém byly větve vytvořeny nebo vyvíjeny, nezáleží.

Uvažujme nyní následující situaci: pracujete na projektu v hlavní větvi (`master`), odvětvíme se z ní k vyřešení jednoho problému (`iss91`), chvíli na něm pracujete, ale vytvoříte ještě další větev, abyste zkusili jiné řešení stejné chyby (`iss91v2`). Pak se vrátíte zpět do hlavní větve, kde pokračujete v práci, a pak dostanete nápad, který by se možná mohl osvědčit, a tak pro něj vytvoříte další větev (`dumbidea`). Historie revizí bude vypadat zhruba jako na obrázku 3-20.

Insert 18333fig0320.png
Obrázek 3-20. Historie revizí s několika tematickými větvemi

Řekněme, že se nyní rozhodnete, že druhé řešení vašeho problému bude vhodnější (`iss91v2`). Dále jste také ukázali svůj nápad ve větvi `dumbidea` kolegům a ti ho považují za geniální. Původní větev `iss91` tak nyní můžete zahodit (s ní i revize C5 a C6) a začlenit zbylé dvě větve. Vaši historii v tomto stavu znázorňuje obrázek 3-21.

Insert 18333fig0321.png
Obrázek 3-21. Vaše historie po začlenění větví „dumbidea“ a „iss91v2“

Při tom všem, co nyní děláte, je důležité mít na paměti, že všechny tyto větve jsou čistě lokální. Veškeré větvení a slučování se odehrává pouze v repozitáři Git, neprobíhá žádná komunikace se serverem.

## Vzdálené větve ##

Vzdálené větve jsou reference (tj. odkazy) na stav větví ve vašich vzdálených repozitářích. Jsou to lokální větve, které nemůžete přesouvat. Přesouvají se automaticky při síťové komunikaci. Vzdálené větve slouží jako záložky, které vám připomínají, kde byly větve ve vzdálených repozitářích, když jste se k nim naposledy připojili.

Vzdálené větve mají podobu `(vzdálený repozitář)/(větev)`. Pokud například chcete zjistit, jak vypadala větev `master` na vašem vzdáleném serveru `origin`, když jste s ní naposledy komunikovali, budete hledat větev `origin/master`. Pokud pracujete s kolegou na stejném problému a on odešle na server větev s názvem `iss53`, může se stát, že i vy máte jednu z lokálních větví pojmenovanou jako `iss53`. Větev na serveru však ukazuje na revizi označenou jako `origin/iss53`.

Mohlo by to být trochu matoucí, takže si uveďme příklad. Řekněme, že máte v síti server Git označený `git.ourcompany.com`. Pokud provedete klonování z tohoto serveru, Git ho automaticky pojmenuje `origin`, stáhne z něj všechna data, vytvoří ukazatel, který bude označovat jeho větev `master`, a lokálně ji pojmenuje `origin/master`. Tuto větev nemůžete přesouvat. Git vám rovněž vytvoří vaši vlastní větev `master`, která bude začínat ve stejném místě jako větev `master` serveru `origin`. Máte tak definován výchozí bod pro svoji práci (viz obrázek 3-22).

Insert 18333fig0322.png
Obrázek 3-22. Příkaz git clone vám vytvoří vlastní hlavní větev a větev origin/master, ukazující na hlavní větev serveru origin.

Pokud nyní budete pracovat na své lokální hlavní větvi a někdo z kolegů mezitím pošle svou práci na server `git.ourcompany.com` a aktualizuje jeho hlavní větev, budou se vaše historie vyvíjet odlišně. A dokud zůstanete od serveru origin odpojeni, váš ukazatel `origin/master` se nemůže přemístit (viz obrázek 3-23).

Insert 18333fig0323.png
Obrázek 3-23. Pokud pracujete lokálně a někdo jiný odešle svou práci na vzdálený server, obě historie se rozejdou.

K synchronizaci své práce použijte příkaz `git fetch origin`. Tento příkaz zjistí, který server je `origin` (v našem případě je to `git.ourcompany.com`), vyzvedne z něj všechna data, která ještě nemáte, a aktualizuje vaši lokální databázi. Při tom přemístí ukazatel `origin/master` na novou, aktuálnější pozici (viz obrázek 3-24).

Insert 18333fig0324.png
Obrázek 3-24. Příkaz `git fetch` aktualizuje vaše reference na vzdálený server.

Abychom si mohli ukázat, jak se pracuje s několika vzdálenými servery a jak vypadají vzdálené větve takových vzdálených projektů, předpokládejme, že máte ještě další interní server Git, který při vývoji používá pouze jeden z vašich sprint teamů. Tento server se nachází na `git.team1.ourcompany.com`. Můžete ho přidat jako novou vzdálenou referenci k projektu, na němž právě pracujete – spusťte příkaz `git remote add` (viz kapitola 2). Pojmenujte tento vzdálený server jako `teamone`, což bude zkrácený název pro celou URL adresu (viz obrázek 3-25).

Insert 18333fig0325.png
Obrázek 3-25. Přidání dalšího vzdáleného serveru.

Nyní můžete spustit příkaz `git fetch teamone`, který ze vzdáleného serveru `teamone` vyzvedne vše, co ještě nemáte. Protože je tento server podmnožinou dat, která jsou právě na serveru `origin`, Git nevyzvedne žádná data, ale nastaví vzdálenou větev nazvanou `teamone/master` tak, aby ukazovala na revizi, kterou má server `teamone` nastavenou jako větev `master` (viz obrázek 3-26).

Insert 18333fig0326.png
Obrázek 3-26. Lokálně získáte referenci na pozici hlavní větve serveru teamone.

### Odesílání ###

Chcete-li svou větev sdílet s okolním světem, musíte ji odeslat na vzdálený server, k němuž máte oprávnění pro zápis. Vaše lokální větve nejsou automaticky synchronizovány se vzdálenými servery, na něž zapisujete – ty, které chcete sdílet, musíte explicitně odeslat. Tímto způsobem si můžete zachovat soukromé větve pro práci, kterou nehodláte sdílet, a odesílat pouze tematické větve, na nichž chcete spolupracovat.

Máte-li větev s názvem `serverfix`, na níž chcete spolupracovat s ostatními, můžete ji odeslat stejným způsobem, jakým jste odesílali svou první větev. Spusťte příkaz `git push (server) (větev)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Toto je zkrácená verze příkazu. Git automaticky rozšíří název větve `serverfix` na `refs/heads/serverfix:refs/heads/serverfix`, což znamená: „Vezmi mou lokální větev `serverfix` a odešli ji na vzdálený server, kde aktualizuje tamní větev `serverfix`.“ Části `refs/heads/` se budeme podrobněji věnovat v kapitole 9, pro většinu uživatelů však nebude zajímavá. Můžete rovněž zadat příkaz `git push origin serverfix:serverfix`, který provede totéž. Systému Git říká: „Vezmi mou větev `serverfix` a udělej z ní `serverfix` na vzdáleném serveru.“ Tento formát můžete použít k odeslání lokální větve do vzdálené větve, která se jmenuje jinak. Pokud jste nechtěli, aby se větev na vzdáleném serveru jmenovala `serverfix`, mohli jste zadat příkaz ve tvaru `git push origin serverfix:awesomebranch`. Vaše lokální větev `serverfix` by byla odeslána do větve `awesomebranch` ve vzdáleném projektu.

Až bude příště některý z vašich spolupracovníků vyzvedávat data ze serveru, obdrží referenci o tom, kde se nachází serverová verze větve `serverfix` ve vzdálené větvi `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Tady je důležité upozornit, že pokud vyzvedáváte data a stáhnete s nimi i nové vzdálené větve, nemáte automaticky jejich lokální, editovatelné kopie. Jinak řečeno: v tomto případě nebudete mít novou větev `serverfix`, budete mít pouze ukazatel `origin/serverfix`, který nemůžete měnit.

Chcete-li začlenit tato data do své aktuální pracovní větve, spusťte příkaz `git merge origin/serverfix`. Chcete-li mít vlastní větev `serverfix`, na níž budete pracovat, můžete ji ze vzdálené větve vyvázat:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

Tímto způsobem získáte lokální větev, na níž můžete pracovat a která začíná na pozici `origin/serverfix`.

### Sledující větve ###

Checkoutem lokální větve ze vzdálené větve automaticky vytvoříte takzvanou *sledující větev* (angl. tracking branch). Sledující větve jsou lokální větve s přímým vztahem ke vzdálené větvi. Pokud se nacházíte na sledující větvi a zadáte příkaz `git push`, Git automaticky ví, na který server a do které větve má data odeslat. Také příkazem `git pull` zadaným na sledovací větvi vyzvednete všechny vzdálené reference a Git poté odpovídající vzdálenou větev automaticky začlení.

Pokud klonujete repozitář, většinou se vytvoří větev `master`, která bude sledovat větev `origin/master`. To je také důvod, proč příkazy `git push` a `git pull` fungují samy od sebe i bez dalších parametrů. Pokud chcete, můžete nastavit i jiné sledující větve – takové, které nebudou sledovat větve na serveru `origin` a nebudou sledovat hlavní větev `master`. Jednoduchým případem je příklad, který jste právě viděli: spuštění příkazu `git checkout -b [větev] [vzdálený server]/[větev]`. Máte-li Git ve verzi 1.6.2 nebo novější, můžete použít také zkrácenou variantu `--track`:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

Chcete-li nastavit lokální větev s jiným názvem, než má vzdálená větev, můžete jednoduše použít první variantu s odlišným názvem lokální větve:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch serverfix from origin.
	Switched to a new branch 'sf'

Vaše lokální větev `sf` bude nyní automaticky stahovat data ze vzdálené větve `origin/serverfix` a bude do ní i odesílat.

### Mazání vzdálených větví ###

Předpokládejme, že už nepotřebujete jednu ze vzdálených větví. Spolu se svými spolupracovníky jste dokončili určitou funkci a začlenili jste ji do větve `master` na vzdáleném serveru (nebo do jakékoli jiné větve, kterou používáte pro stabilní kód). Vzdálenou větev nyní můžete smazat pomocí poněkud neohrabané syntaxe `git push [vzdálený server] :[větev]`. Chcete-li ze serveru odstranit větev `serverfix`, můžete to provést takto:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Šup! A větev je ze serveru pryč. Na této stránce si možná chcete ohnout rožek, protože tento příkaz budete určitě potřebovat, ale jeho syntaxi pravděpodobně zapomenete. Zapamatovat si jej ale můžete tak, že si vybavíte příkaz `git push [vzdálený server] [lokální větev]:[vzdálená větev]`, o kterém jsme se zmínili před chvílí. Pokud vynecháte složku `[lokální větev]`, pak v podstatě říkáte: „Neber na mé straně nic a toto nic teď bude `[vzdálená větev]`.“

## Přeskládání ##

V systému Git existují dvě základní možnosti, jak integrovat změny z jedné větve do druhé: sloučení (neboli začlenění) příkazem `merge` a přeskládání příkazem `rebase`. V této části se dozvíte, co to je přeskládání, jak ho provést, v čem spočívají výhody tohoto nástroje a v jakých případech ho rozhodně nepoužívat.

### Základní přeskládání ###

Pokud se vrátíme k našemu dřívějšímu příkladu z části o slučování větví (viz obrázek 3-27), vidíme, že jsme svoji práci rozdělili a vytvářeli revize ve dvou různých větvích.

Insert 18333fig0327.png
Obrázek 3-27. Vaše původně rozdělená historie revizí

Víme, že nejjednodušším způsobem, jak integrovat větve, je příkaz `merge`. Ten provede třícestné sloučení mezi dvěma posledními snímky (C3 a C4) a jejich nejmladším společným předkem (C2), přičemž vytvoří nový snímek (a novou revizi) – viz obrázek 3-28.

Insert 18333fig0328.png
Obrázek 3-28. Integrace rozdělené historie sloučením větví

Existuje však ještě jiný způsob. Můžete vzít záplatu se změnou, kterou jste provedli revizí C3, a aplikovat ji na vrcholu revize C4. V systému Git se tato metoda nazývá *přeskládání* (rebasing). Příkazem `rebase` vezmete všechny změny, které byly zapsány na jedné větvi, a necháte je znovu provést na jiné větvi.

V našem případě tedy provedete následující:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Přeskládání funguje takto: systém najde společného předka obou větví (větve, na níž se nacházíte, a větve, na kterou přeskládáváte), provede příkaz diff pro všechny revize větve, na níž se nacházíte, uloží zjištěné rozdíly do dočasných souborů, vrátí aktuální větev na stejnou revizi jako větev, na kterou přeskládáváte, a nakonec po jedné aplikuje všechny změny. Tento proces je naznačen na obrázku 3-29.

Insert 18333fig0329.png
Obrázek 3-29. Přeskládání změny provedené v revizi C3 na revizi C4

Nyní můžete přejít zpět na hlavní větev a provést sloučení „rychle vpřed“ (viz obrázek 3-30).

Insert 18333fig0330.png
Obrázek 3-30. „Rychle vpřed“ po hlavní větvi

Snímek, na který nyní ukazuje revize C3', je zcela totožný se snímkem, na který v příkladu v části o slučování ukazovala C5. V koncových produktech integrace není žádný rozdíl, výsledkem přeskládání je však čistší historie. Pokud si prohlížíte log přeskládané větve, vypadá jako lineární historie – zdá se, jako by veškerá práce probíhala v jedné linii, ačkoli původně byla paralelní.

Tuto metodu budete často používat v situaci, kdy chcete mít jistotu, že byly vaše revize čistě aplikovány na vzdálenou větev – např. v projektu, do nějž chcete přidat příspěvek, který ale nespravujete. V takovém případě budete pracovat ve své větvi, a až budete mít připraveny záplaty k odeslání do hlavního projektu, přeskládáte svou práci na větev `origin/master`. Správce v tomto případě nemusí provádět žádnou integraci, provede pouze posun „rychle vpřed“ nebo čistou aplikaci.

Ještě jednou bychom chtěli upozornit, že snímek, na který ukazuje závěrečná revize – ať už se jedná o poslední z přeskládaných revizí po přeskládání, nebo poslední revizi sloučením jako výsledek začlenění – je vždy stejný. Jediné, co se liší, je historie. Přeskládání provede změny učiněné v jedné linii práce ještě jednou v jiné linii, a to v pořadí, v jakém byly provedeny. Sloučení naproti tomu vezme koncové body větví a sloučí je dohromady.

### Zajímavější možnosti přeskládání ###

Opětovné provedení změn pomocí příkazu rebase můžete využít i jiným účelům než jen k přeskládání větve. Vezměme například historii na obrázku 3-31. Vytvořili jste novou tematickou větev (`server`), pomocí níž chcete do svého projektu přidat funkci na straně serveru, a zapsali jste revizi. Poté jste tuto větev opustili a začali pracovat na změnách na straně klienta (`client`). I tady jste zapsali několik revizí. Nakonec jste se vrátili na větev `server` a zapsali tu další revize.

Insert 18333fig0331.png
Obrázek 3-31. Historie s tematickou větví obsahující další tematickou větev.

Předpokládejme, že nyní chcete začlenit změny provedené na straně klienta do své hlavní linie k vydání, ale prozatím chcete počkat se změnami na straně serveru, dokud nebudou pečlivě otestovány. Můžete vzít změny na větvi client, které nejsou na větvi server (C8 a C9), a nechat je znovu provést na hlavní větvi. Použijte k tomu příkaz `git rebase` v kombinaci s parametrem `--onto`:

	$ git rebase --onto master server client

Tím v podstatě říkáte: „Proveď checkout větve `client`, zjisti záplaty ze společného předka větví `client` a `server` a znovu je aplikuj na hlavní větev `master`.“ Postup je možná trochu složitý, ale výsledek, znázorněný na obrázku 3-32, stojí opravdu za to.

Insert 18333fig0332.png
Obrázek 3-32. Přeskládání tematické větve, která byla součástí jiné tematické větve 72.

Nyní můžete posunout hlavní větev „rychle vpřed“ (viz obrázek 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
Obrázek 3-33. Posun hlavní větve rychle vpřed na konec změn přeskládaných z větve client

Řekněme, že se později rozhodnete vtáhnout i větev server. Větev server můžete přeskládat na hlavní větev příkazem `git rebase [základna] [tematická větev]`. Příkaz provede checkout tematické větve (v tomto případě větve `server`) a přeskládá její změny na základnu (angl. base branch, v tomto případě `master`):

	$ git rebase master server

Příkaz provede změny obsažené ve větvi `server` ještě jednou na vrcholu větve `master`, jak je znázorněno na obrázku 3-34.

Insert 18333fig0334.png
Obrázek 3-34. Přeskládání větve server na vrcholu hlavní větve.

Poté se můžete přesunout „rychle vpřed“ po základně (větev `master`):

	$ git checkout master
	$ git merge server

Poté můžete větev `client` i `server` smazat, protože všechna práce z nich je integrována a tyto větve už nebudete potřebovat. Vaše historie pak bude vypadat jako na obrázku 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
Obrázek 3-35. Konečná historie revizí

### Rizika spojená s přeskládáním ###

Přeskládání sice nabízí určité výhody, má však také svá úskalí. Ta se dají shrnout do jedné věty:

**Neprovádějte přeskládání u revizí, které jste odeslali do veřejného repozitáře.**

Budete-li se touto zásadou řídit, nemusíte se přeskládání obávat. V opačném případě vás čeká nenávist ostatních a rodina a přátelé vás zavrhnou.

Při přeskládání dat zahodíte existující revize a vytvoříte nové, které jsou jim podobné, ale přesto jiné. Pokud odešlete svou práci, ostatní si ji stáhnou a založí na nich svou práci. A vy potom tyto revize přepíšete příkazem `git rebase` a znovu je odešlete, vaši spolupracovníci do ní budou muset znovu začlenit svou práci a ve všem nastane chaos, až se pokusíte natáhnout jejich práci zpět do své.

Podívejme se na malý příklad, jaké problémy může přeskládání již zveřejněných dat způsobit. Představme si situaci, kdy jste naklonovali repozitář z centrálního serveru a provedli jste v něm několik změn. Vaše historie revizí bude vypadat jako na obrázku 3-36.

Insert 18333fig0336.png
Obrázek 3-36. Naklonovali jste repozitář a provedli v něm změny.

Někdo jiný teď provede jiné úpravy, jejichž součástí bude i začlenění, a odešle svou práci na centrální server. Vy tyto změny vyzvednete a začleníte novou vzdálenou větev do své práce – vaše historie teď vypadá jako na obrázku 3-37.

Insert 18333fig0337.png
Obrázek 3-37. Vyzvedli jste další revize a začlenili je do své práce.

Jenže osoba, která odeslala a začlenila své změny, se rozhodne vrátit a svou práci raději přeskládat. Provede příkaz `git push --force` a přepíše historii na serveru. Vy poté znovu vyzvednete data ze serveru a stáhnete nové revize.

Insert 18333fig0338.png
Obrázek 3-38. Kdosi odeslal přeskládané revize a zahodil ty, na nichž jste založili svou práci.

V tuto chvíli vám nezbývá, než změny znovu začlenit do své práce, ačkoli už jste je jednou začlenili. Přeskládáním se změnily otisky SHA-1 těchto revizí, a Git je proto považuje za nové revize, přestože změny označené jako C4 už jsou ve skutečnosti ve vaší historii obsaženy (viz obrázek 3-39).

Insert 18333fig0339.png
Obrázek 3-39. Znovu jste začlenili stejnou práci do nové revize sloučením.

Vy musíte tyto změny ve vhodném okamžiku začlenit do své práce, abyste do budoucna neztratili kontakt s ostatními vývojáři. Vaše historie pak bude obsahovat revize C4 i C4’, které mají obě jiný otisk SHA-1, ale představují stejnou práci a nesou i stejnou zprávu k revizi. Pokud s takovouto historií spustíte příkaz `git log`, nastane zmatečná situace, kdy se zobrazí dvě revize se stejným datem autora i stejnou zprávou k revizi. Pokud pak tuto historii odešlete zpět na server, znovu provedete všechny tyto přeskládané revize na centrálním serveru, což bude zmatečné i pro vaše spolupracovníky.

Budete-li používat přeskládání jako metodu vyčištění a práce s revizemi předtím, než je odešlete, a budete-li přeskládávat pouze revize, které dosud nikdy nebyly zveřejněny, nemusíte se žádných problémů obávat. Jestliže ale přeskládáte revize, které už byly zveřejněny a někdo na nich mohl založit svou práci, můžete si tím nepěkně zavařit.

## Shrnutí ##

V této kapitole jsme se věnovali základům větvení a slučování. Neměli byste teď mít problém s vytvářením větví, přepínáním na nové i existující větve ani se slučováním lokálních větví. Měli byste také umět odeslat své větve ke sdílení na server, spolupracovat s ostatními na sdílených větvích a před odesláním větve přeskládat.
