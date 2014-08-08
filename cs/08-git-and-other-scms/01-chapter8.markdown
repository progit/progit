# Git a ostatní systémy #

Svět není dokonalý. Většinou není možné okamžitě přepnout každý projekt, s nímž přijdete do styku, na systém Git. Někdy jste nuceni pracovat na projektu v jiném systému VCS, jímž často bývá Subversion. První část této kapitoly proto věnujeme nástroji `git svn`, obousměrné bráně k systému Subversion.

V určitém okamžiku možná budete chtít přepnout svůj existující projekt do systému Git. V druhé části této kapitoly se proto naučíte, jak přesunout svůj projekt do systému Git: nejprve ze systému Subversion, poté z Perforce a nakonec pomocí vlastního skriptu i v případech nestandardního importu.

## Git a Subversion ##

V současné době používá většina projektů vývoje open source softwaru a velká část korporátních projektů ke správě zdrojového kódu systém Subversion. Subversion je nejpopulárnějším systémem VCS s otevřeným zdrojovým kódem a využívá se už téměř deset let. V mnoha ohledech je velmi podobný systému CVS, který platil ve světě správy verzí před příchodem systému Subversion za nepřekonatelný.

Jednou ze skvělých funkcí systému Git je obousměrný most k systému Subversion: `git svn`. Tento nástroj umožňuje používat Git jako platného klienta serveru Subversion. Můžete tak využívat všech lokálních funkcí systému Git, ale revize odesílat na server Subversion, jako byste tento systém používali i lokálně. To znamená, že můžete vytvářet nové lokální větve a slučovat je, používat oblast připravených změn, přeskládávat, částečně přejímat atd., zatímco vaši spolupracovníci budou dále pracovat svými zašlými a prastarými způsoby. Jistě nebude od věci, jestliže se pokusíte propašovat Git do prostředí vaší společnosti a lobbováním za změnu infrastruktury směrem k plné podpoře systému Git pomůžete svým kolegům-vývojářům k vyšší efektivitě práce. Most k systému Subversion je branou do světa DVCS.

### git svn ###

Základním příkazem systému Git ke všem operacím směřujícím do systému Subversion je `git svn`. Takto začínají všechny příkazy. Ale není jich mnoho. Ty nejběžnější si představíme v několika malých modelových situacích.

V tomto místě bych rád upozornil, že použijete-li příkaz `git svn`, zahajujete interakci se systémem Subversion, nástrojem zdaleka ne tak sofistikovaným jako Git. Přestože není problém lokálně pracovat s větvemi a slučovat je, obecně doporučujeme, abyste se snažili udržet historii co nejlineárnější (pomůže vám v tom přeskládání) a vyhýbali se úkonům, jako je současná interakce se vzdáleným repozitářem Git.

Nepřepisujte svou historii a nepokoušejte se ji znovu odeslat a neodesílejte revize do paralelního repozitáře Git, přes nějž chcete současně spolupracovat s kolegy používajícími Git. Subversion může mít pouze jednu lineární historii a opravdu není těžké uvést ho do rozpaků. Pokud pracujete v týmu, v němž část vývojářů používá SVN a část Git, zajistěte, aby všichni spolupracovali na serveru SVN – váš život bude jednodušší.

### Vytvoření repozitáře ###

Abychom si mohli tuto funkci ukázat, budete potřebovat typický repozitář SVN, k němuž máte oprávnění pro zápis. Chcete-li si tyto příklady zkopírovat, budete si muset obstarat zapisovatelnou kopii mého testovacího repozitáře. Snadno ho zkopírujete pomocí nástroje `svnsync`, jenž je součástí novějších verzí systému Subversion – měl by být distribuován s verzí 1.4 a vyšší. Pro potřeby našich pokusů jsem na stránkách Google code vytvořil nový repozitář Subversion, který byl původně součástí kopie projektu `protobuf`, nástroje, který kóduje strukturovaná data pro síťový přenos.

Chcete-li postupovat podle mě, budete si nejprve muset vytvořit nový lokální repozitář Subversion:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Poté umožněte všem uživatelům měnit vlastnosti vlastnosti revprops – jednoduše to provedete přidáním skriptu pre-revprop-change, jehož návratovou hodnotou bude vždy 0:

	$ cat /tmp/test-svn/hooks/pre-revprop-change
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Nyní můžete tento projekt synchronizovat na svůj lokální počítač zadáním příkazu `svnsync init` s uvedením repozitářů „do“ a „z“.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/

Tím nastavíte vlastnosti synchronizace. Zdrojový kód pak naklonujete příkazem:

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Tato operace bude trvat jen několik minut. Pokud byste se však pokoušeli zkopírovat originální repozitář ne do lokálního, nýbrž do jiného vzdáleného repozitáře, protáhne se proces téměř na hodinu, přestože repozitář obsahuje necelých 100 revizí. Subversion musí klonovat každou revizi zvlášť a tu pak odesílá zpět do jiného repozitáře. Tento postup je sice velice neefektivní, ale jiná možnost neexistuje.

### První kroky ###

Nyní máte repozitář Subversion s oprávněním pro zápis, a proto se můžeme podívat na typický postup práce. Začneme příkazem `git svn clone`, který importuje celý repozitář Subversion do lokálního repozitáře Git. Nezapomeňte, že pokud import provádíte z reálně hostovaného repozitáře Subversion, je třeba nahradit `file:///tmp/test-svn` adresou URL vašeho repozitáře Subversion:

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

Na adrese URL, kterou jste zadali, tím v podstatě provedete dva příkazy: `git svn init` a `git svn fetch`. Proces může chvíli trvat. Testovací projekt má pouze kolem 75 revizí a základ kódu není příliš velký, takže bude stačit několik minut. Git však musí provést checkout každé verze jednotlivě a po jedné je také zapsat. U projektů se stovkami nebo tisíci revizí si můžete bez nadsázky počkat i celé hodiny nebo dny.

Část `-T trunk -b branches -t tags` říká systému Git, že tento repozitář Subversion dodržuje základní zásady větvení a značkování. Pokud pojmenujete svůj kmenový adresář (trunk), větve nebo značky jinak, lze tyto parametry změnit. Protože se jedná o častou situaci, můžete celou tuto část nahradit parametrem `-s`, který označuje standardní layout a implikuje všechny uvedené parametry. Následující příkaz je ekvivalentní:

	$ git svn clone file:///tmp/test-svn -s

V tomto okamžiku byste tedy měli mít platný repozitář Git s importovanými větvemi a značkami:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

Doplňme také, že tento nástroj odlišně přiřazuje jmenný prostor vzdálených referencí. Jestliže klonujete normální repozitář Git, získáte ze vzdáleného serveru všechny větve, lokálně dostupné pod označením `origin/[větev]` – jmenný prostor je dán jménem vzdáleného serveru. Příkaz `git svn` však předpokládá, že nebudete mít více vzdálených repozitářů a všechny odkazy na místa na vzdáleném serveru uloží bez použití jmenného prostoru. Pokud si přejete zobrazit všechny své reference s úplným názvem, můžete použít nízkoúrovňový příkaz `show-ref`:

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

Běžný repozitář Git vypadá naproti tomu spíš takto:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

Máte dva vzdálené servery: první nese označení `gitserver` a obsahuje větev `master`; druhý server je `origin`, který obsahuje větve `master` a`testing`.

Všimněte si, že v příkladu vzdálených referencí importovaných nástrojem `git svn` jsou značky přidány jako vzdálené větve, nikoli jako skutečné značky Git. Import ze systému Subversion vypadá, jako by měl vzdálený repozitář s názvem „tags“, v němž se nacházejí jednotlivé větve.

### Zapisování zpět do systému Subversion ###

Máte vytvořen pracovní repozitář a můžete se pustit do práce na projektu. Časem ale budete chtít odeslat revize zpět do repozitáře a použít při tom Git jako klienta SVN. Upravíte-li některý ze souborů a provedené změny zapíšete, budete mít revizi, která existuje lokálně v systému Git, ale neexistuje na serveru Subversion:

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

Jako další krok tak chcete odeslat provedené změny do vzdáleného repozitáře. Všimněte si, jak se tím mění váš způsob práce v systému Subversion. Můžete zapsat několik revizí offline a poté je na server Subversion odeslat všechny najednou. Pro odeslání revizí na server Subversion zadejte příkaz `git svn dcommit`:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Příkaz vezme všechny revize, které jste provedli na vrcholu kódu ze serveru Subversion, každou jednotlivě zapíše do systému Subversion a přepíše vaši lokální revizi Git tak, aby obsahovala unikátní identifikátor. To je důležité, protože to znamená, že se změní všechny kontrolní součty SHA-1 vašich revizí. To je také jeden z důvodů, proč není vhodné pracovat zároveň se serverem Subversion a s verzemi vzdálených repozitářů Git k témuž projektu. Pokud se podíváte na poslední revizi, uvidíte nově přidané `git-svn-id`:

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Všimněte si, že kontrolní součet SHA, který před zapsáním revize původně začínal kombinací znaků `97031e5`, nyní začíná `938b1a5`. Chcete-li revize odeslat jak na server Git, tak na server Subversion, odešlete je nejprve na server Subversion (`dcommit`), protože tím změníte data revizí.

### Stažení nových změn ###

Pokud na projektu spolupracujete s dalšími vývojáři, stane se vám, že někdo z vás odešle své revize, a až se o totéž pokusí ostatní, dojde ke konfliktu. Jejich změna bude odmítnuta, dokud nezačlení dříve odeslanou práci. V nástroji `git svn` to bude vypadat následovně:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Chcete-li tuto situaci vyřešit, spusťte příkaz `git svn rebase`, jímž stáhnete veškeré změny na serveru, které ještě nemáte lokálně, a přeskládáte všechnu práci na vrchol toho, co se nachází na serveru:

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

Nyní je všechna vaše práce na vrcholu revizí, které jsou na serveru Subversion. Příkaz `dcommit` bude nyní úspěšně proveden:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Za zmínku stojí, že na rozdíl od systému Git, který před přijetím odesílaných dat vyžaduje, abyste začlenili práci na serveru, kterou ještě nemáte lokálně, nástroj `git svn` si toto vyžádá pouze v případě, že změny navzájem kolidují. Jestliže někdo odešle na server změnu v jednom souboru a vy poté odešlete změnu provedenou v jiném souboru, příkaz `dcommit` bude proveden úspěšně:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

Tuto skutečnost je dobré mít na paměti, neboť výsledkem takového postupu je stav projektu, který ve chvíli vašeho odeslání neexistoval na žádném z počítačů. Jsou-li změny nekompatibilní, přestože nekolidují, může dojít k těžko diagnostikovatelným problémům. V tom se tento postup liší od používání serveru Git. V systému Git můžete kompletně otestovat stav v systému klienta ještě před zveřejněním. V SVN si naproti tomu nemůžete být nikdy jisti, že je stav bezprostředně před revizí a po revizi identický.

Tento příkaz byste proto měli používat ke stažení změn ze serveru Subversion i v případě, že ještě sami nehodláte zapsat vlastní revize. Nová data sice můžete vyzvednout i příkazem `git svn fetch`, avšak příkaz `git svn rebase` data nejen stáhne, ale navíc aktualizuje vaše lokální revize.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Spustíte-li čas od času příkaz `git svn rebase`, budete mít jistotu, že pracujete s aktuálním kódem. Nezapomeňte však, že když příkaz spouštíte, je třeba, abyste měli čistý pracovní adresář. Máte-li lokální změny, musíte ještě před spuštěním příkazu `git svn rebase` práci buď odložit (stash), nebo ji dočasně zapsat. V opačném případě nebude příkaz proveden, protože systém zjistí, že by přeskládání vedlo ke konfliktu.

### Problémy s větvemi systému Git ###

Jakmile pracovní postupy v systému Git zvládnete, začnete pravděpodobně vytvářet tematické větve, budete v nich pracovat a potom je budete začleňovat (merge). Pokud odesíláte revizi na server Subversion nástrojem `git svn`, budete možná místo slučování chtít svou práci pokaždé přeskládat (rebase) na jedinou větev. Důvod, proč raději využít možnosti přeskládání, spočívá v tom, že Subversion uchovává lineární historii a neprovádí začleňování stejně jako Git. Takže `git svn` při konverzi snímků na revize Subversion sleduje pouze prvního rodiče.

Předpokládejme, že vaše historie vypadá následovně: vytvořili jste větev `experiment`, zapsali jste dvě revize a začlenili jste je zpět do větve `master`. Výstup příkazu `dcommit` bude nyní vypadat následovně:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Příkaz `dcommit` na větvi se začleněnou historií bude fungovat bez problémů, pomineme-li, že při pohledu na historii projektu Git zjistíme, že nepřepsal žádnou z revizí, kterou jste provedli ve větvi `experiment`. Všechny změny se místo toho objeví v SVN verzi jedné revize vzniklé sloučením.

Pokud tuto práci naklonuje jiný uživatel, uvidí jen jednu revizi vzniklou sloučením, obsahující všechnu práci skomprimovanou do ní. Neuvidí data revizí s informacemi, odkud revize pochází nebo kdy byla zapsána.

### Větve v systému Subversion ###

Princip větvení v systému Subversion se odlišuje od větvení v systému Git. Pravděpodobně nejlepší bude, když se mu pokusíte co nejvíc vyhýbat. Nicméně příkaz `git svn` vytváření větví a zapisování revizí do systému Subversion umožňuje.

#### Vytvoření nové větve SVN ####

Chcete-li vytvořit novou větev v systému Subversion, spusťte příkaz `git svn branch [název větve]`:

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

Příkaz je ekvivalentní s příkazem `svn copy trunk branches/opera` v systému Subversion a pracuje na serveru Subversion. Měli bychom také dodat, že příkaz neprovede automaticky checkout dané větve. Pokud nyní zapíšete revizi, dostane se do větve `trunk` na serveru, ne do větve `opera`.

### Přepínání aktivních větví ###

Git zjistí, do jaké větve se vaše revize zapsané příkazem dcommit dostanou – podívá se na konec všech větví Subversion ve vaší historii. Měli byste mít pouze jednu a měla by to být poslední větev s `git-svn-id` ve vaší aktuální historii větve.

Chcete-li současně pracovat ve více než jedné větvi, můžete nastavit lokální větve tak, abyste příkazem `dcommit` zapisovali revize do konkrétních větví Subversion. Za tímto účelem umístěte začátek větví na importované revizi Subversion pro tuto větev. Chcete-li používat větev `opera`, v níž můžete pracovat odděleně, spusťte příkaz:

	$ git branch opera remotes/opera

Budete-li nyní chtít začlenit větev `opera` do větve `trunk` (vaše větev `master`), můžete tak učinit běžným příkazem `git merge`. Měli byste však uvést výstižnou zprávu revize (pomocí parametru `-m`). V opačném případě bude sloučení místo užitečných informací oznamovat jen „Merge branch opera“ („začleněna větev opera“).

Nezapomeňte, že přestože k operaci používáte příkaz `git merge` a sloučení bude pravděpodobně o mnoho snazší, než by bylo v systému Subversion (Git automaticky vyhledá vhodnou základu pro sloučení), nejedná se o standardní příkaz merge systému Git. Tato data budete muset odeslat zpět na server Subversion, který nedokáže pracovat s revizí sledující více než jednoho rodiče. Proto až je odešlete, budou vypadat jako jediná revize, jež zkomprimovala veškerou práci jiné větve do jedné revize. Poté, co začleníte jednu větev do druhé, můžete se beze všeho vrátit zpět a pokračovat v práci na této větvi, stejně jako byste mohli v systému Git. Spustíte-li příkaz `dcommit`, smažete všechny informace, které sdělují, jaká větev byla začleněna, a všechny následné výpočty základny pro sloučení tak budou nesprávné. Příkaz dcommit způsobí, že bude výsledek příkazu `git merge` vypadat, jako byste spustili příkaz `git merge --squash`. Bohužel však neexistuje žádný dobrý způsob, jak této situaci předejít, Subversion nedokáže tyto informace uchovávat. Dokud tedy budete používat server Subversion, vždy se budete muset s tímto jeho nedostatkem vyrovnat. Chcete-li se vyhnout možným problémům, smažte lokální větev (v našem případě `opera`) hned poté, co jste ji začlenili do kmenového adresáře (trunk).

### Příkazy systému Subversion ###

Sada nástrojů `git svn` dává uživateli do ruky celou řadu příkazů, jež jsou svou funkcí podobné příkazům v systému Subversion a uživateli tím usnadňují přechod do systému Git. Na tomto místě proto uvedu pár příkazů, které jsou podobné jako v systému Subversion.

#### Historie ve stylu SVN ####

Jestliže jste zvyklí na systém Subversion a chcete historii procházet ve stylu výstupu SVN, můžete použít příkaz `git svn log`. Historie revizí se zobrazí ve formátování SVN:

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines

	updated the changelog

O příkazu `git svn log` byste měli vědět dvě důležité věci. Zaprvé to, že pracuje i off-line, na rozdíl od skutečného příkazu `svn log`, který si data vyžádá ze serveru Subversion. Zadruhé pak to, že zobrazuje pouze revize, jež byly zapsány na server Subversion. Nezobrazuje tedy lokální revize Git, které jste nezapsali příkazem dcommit. Stejně tak nezobrazuje revize, které ostatní zapsali na server Subversion od vašeho posledního připojení. Jedná se tak spíše o poslední známý stav revizí na serveru Subversion.

#### Anotace SVN ####

Tak jako příkaz `git svn log` simuluje příkaz `svn log` (bez nutnosti připojení), ekvivalentem příkazu `svn annotate` je provedení `git svn blame [SOUBOR]`. Jeho výstup vypadá takto:

	$ git svn blame README.txt
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal
	79    schacon Committing in git-svn.
	78    schacon
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal

Ani tento příkaz nezobrazuje revize zapsané lokálně v systému Git a revize odeslané na server Subversion od posledního připojení.

#### Informace o serveru SVN ####

Stejné informace, jaké poskytuje příkaz `svn info`, získáte příkazem `git svn info`:

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

Stejně jako v případě příkazů `blame` a `log` pracuje i tento příkaz offline a zobrazuje stav v okamžiku, kdy jste naposledy komunikovali se serverem Subversion.

Tip: Pokud vaše skripty pro sestavení projektu chtějí spouštět `svn info`, pak si často můžete vystačit s obálkou příkazu git.
Můžete vyzkoušet

    #!/usr/bin/env bash

    if git rev-parse --git-dir > /dev/null 2>&1 && [[ $1 == "info" ]] ; then
      git svn info
    else
      /usr/local/bin/svn "$@"
    fi

#### Ignorování souborů, které ignoruje Subversion ####

Jestliže naklonujete repozitář Subversion s nastavenými vlastnostmi `svn:ignore`, pravděpodobně budete chtít nastavit také odpovídající soubory `.gitignore`, abyste omylem nezapsali nežádoucí soubory. Nástroj `git svn` vám k řešení tohoto problému nabízí dva příkazy. Tím prvním je `git svn create-ignore`, jenž automaticky vytvoří odpovídající soubory `.gitignore`, podle nichž se bude řídit už vaše příští revize.

Druhým z příkazů je `git svn show-ignore`, který zobrazí standardní výstup stdout s řádky, které budete muset vložit do souboru `.gitignore`. Výstup pak můžete přesměrovat do souboru exclude svého projektu:

	$ git svn show-ignore > .git/info/exclude

Díky tomu si nemusíte projekt znečišťovat soubory `.gitignore`. Tuto možnost oceníte, jste-li jediným uživatelem systému Git v týmu používajícím Subversion a vaši kolegové nestojí ve svém projektu o soubory `.gitignore`.

### Git-Svn: shrnutí ###

Nástroje `git svn` využijete, jestliže chcete pozvolna přejít ze systému Subversion na systém Git nebo pokud pracujete ve vývojovém prostředí, v němž je z nějakého důvodu nutné používat server Subversion. Mějte však stále na paměti, že v tomto případě nelze používat systém Git v celé jeho šíři. Mohlo by se stát, že způsobíte chyby v překladu, které znepříjemní život vám i vašim kolegům. Chcete-li se vyhnout problémům, dodržujte tato pravidla:

*	 Udržujte lineární historii Git, která neobsahuje revize sloučením, vytvořené příkazem `git merge`. Práci, kterou provedete mimo základní větev, na ni přeskládejte (rebase), nezačleňujte ji (merge).
*	 Nevytvářejte oddělený server Git ani na žádný takový nepřispívejte. Můžete ho sice využít k urychlení klonování pro nové vývojáře, ale neodesílejte na něj nic, co nemá záznam `git-svn-id`. Možná by nebylo od věci ani vytvořit zásuvný modul `pre-receive`, který by kontroloval všechny zprávy k revizím, zda obsahují `git-svn-id`, a odmítl by všechna odeslání, která obsahují revize bez něj.

Budete-li dodržovat tato pravidla, bude práce se serverem Subversion snesitelnější. Stále však platí, že pokud máte možnost přejít na skutečný server Git, získáte vy i váš tým daleko více.

## Přechod na systém Git ##

Máte-li existující základ kódu v jiném systému VCS, ale rádi byste začali používat Git, můžete do něj svůj projekt převést. Existuje přitom několik způsobů. V této části se seznámíte s několika importéry pro běžné systémy, které jsou součástí systému Git, a poté ukážeme, jak si můžete vytvořit importér vlastní.

### Import ###

Nyní se naučíte, jak importovat data ze dvou větších, profesionálně používaných systémů SCM – Subversion a Perforce. Oba tyto systémy jsem zvolil proto, že podle mých informací přechází na Git nejvíce uživatelů právě z nich, a také proto, že Git obsahuje vysoce kvalitní nástroje právě pro oba tyto systémy.

### Subversion ###

Pokud jste si přečetli předchozí část o používání nástrojů `git svn`, můžete získané informace použít. Příkazem `git svn clone` naklonujte repozitář, odešlete ho na nový server Git a začněte používat ten. Server Subversion můžete úplně přestat používat. Chcete-li získat historii projektu, dostanete ji tak rychle, jak jen dovedete stáhnout data ze serveru Subversion (což ovšem může chvíli trvat).

Takový import však není úplně dokonalý a vzhledem k tomu, jak dlouho může trvat, nabízí se ještě jiná cesta. Prvním problémem jsou informace o autorovi. V Subversion má každá osoba zapisující revize v systému přiděleného uživatele, který je u zaznamenán informací o revizi. V předchozí části se u některých příkladů (výstupy příkazů `blame` nebo `git svn log`) objevilo jméno `schacon`. Jestliže vyžadujete podrobnější informace ve stylu systému Git, budete potřebovat mapování z uživatelů Subversion na autory Git. Vytvořte soubor `users.txt`, který bude toto mapování obsahovat v následující podobě:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

Chcete-li získat seznam jmen autorů používaných v SVN, spusťte tento příkaz:

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

Vytvoříte tím log ve formátu XML. Můžete v něm vyhledávat autory, vytvořit si vlastní seznam a XML zase vyjmout. (Tento příkaz pochopitelně funguje pouze na počítačích, v nichž je nainstalován `grep`, `sort` a `perl`.) Poté tento výstup přesměrujte do souboru users.txt, abyste mohli vedle každého záznamu přidat stejná data o uživatelích Git.

Tento soubor můžete dát k dispozici nástroji `git svn`, aby mohl přesněji zmapovat informace o autorech. Nástroji `git svn` můžete také zadat, aby ignoroval metadata, která systém Subversion normálně importuje: zadejte parametr `--no-metadata` k příkazu `clone` nebo `init`. Váš příkaz `import` pak bude mít tuto podobu:

	$ git svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Import ze systému Subversion v adresáři `my_project` by měl nyní vypadat o něco lépe. Revize už nebudou mít tuto podobu:

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029
they look like this:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Nejenže teď pole Author vypadá podstatně lépe, ale navíc jste se zbavili i záznamu `git-svn-id`.

Po importu bude nutné data trochu vyčistit. Zaprvé je nutné vyčistit podivné reference, které vytvořil příkaz `git svn`. Nejprve přesuňte značky tak, aby se z nich staly skutečné značky, a ne podivné vzdálené větve. V dalším kroku přesunete zbytek větví a uděláte z nich větve lokální.

Abyste značky upravili na korektní gitové značky, spusťte

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname"; done

Tím se reference, které označovaly vzdálené větve a začínaly `tag/`, převedou na skutečné (prosté) značky.

Ze zbytku referencí vytvořte v repozitáři `refs/remotes` lokální větve:

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname"; done

Všechny staré větve jsou nyní skutečnými větvemi Git a všechny staré značky jsou nyní skutečnými značkami Git. Poslední věcí, která ještě zbývá, je přidat nový server Git jako vzdálený repozitář a odeslat do něj revize. Tady je příklad, jak můžete váš server přidat jako vzdálený:

	$ git remote add origin git@my-git-server:myrepository.git

Protože do něj chcete odeslat všechny své větve a značky, můžete použít příkaz:

	$ git push origin --all
	$ git push origin --tags

Na novém serveru Git tak nyní máte v úhledném, čistém importu uloženy všechny větve a značky.

### Perforce ###

Dalším systémem, z nějž budeme importovat, bude Perforce. Také importér Perforce je distribuován se systémem Git. Pokud máte verzi Git starší než 1.7.11, pak importér naleznete jen v sekci `contrib` zdrojového kódu.  V takovém případě budete muset získat zdrojový text systému Git, který můžete stáhnout ze serveru git.kernel.org:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

V adresáři `fast-import` byste měli najít spustitelný skript napsaný v jazyce Python pojmenovaný `git-p4`. Aby vám import fungoval, musíte mít v počítači nainstalován Python a nástroj `p4`. Budete chtít například importovat projekt Jam z veřejného úložiště Perforce Public Depot. K nastavení svého klienta budete muset exportovat proměnnou prostředí P4PORT, která bude ukazovat na depot Perforce:

	$ export P4PORT=public.perforce.com:1666

Spusťte příkaz `git-p4 clone`, jímž importujete projekt Jam ze serveru Perforce. K příkazu zadejte depot a cestu k projektu, kromě toho také cestu, kam chcete projekt importovat:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

Přejdete-li do adresáře `/opt/p4import` a spustíte příkaz `git log`, uvidíte, co jste importovali:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

V každé revizi si můžete všimnout identifikátoru `git-p4`. Je dobré ponechat tu identifikátor pro případ, že budete někdy v budoucnu potřebovat odkázat na číslo změny Perforce. Pokud ale chcete identifikátor přesto odstranit, teď, dokud jste nezačali pracovat na novém repozitáři, je ta správná chvíle. K odstranění všech řetězců identifikátoru najednou můžete použít příkaz `git filter-branch`:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

Spustíte-li příkaz `git log`, uvidíte, že se změnily všechny kontrolní součty revizí SHA-1, zato všechny řetězce `git-p4` ze zpráv k revizím zmizely:

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

Váš import je připraven k odeslání na nový server Git.

### Vlastní importér ###

Není-li vaším současným systémem ani Subversion, ani Perforce, zkuste vyhledat importér online. Kvalitní importéry se dají najít pro CVS, Clear Case, Visual Source Safe, dokonce i adresář s archivy. Pokud vám nefunguje ani jeden z těchto nástrojů, používáte méně častý nástroj nebo potřebujete speciální proces importu ještě z jiného důvodu, použijte `git fast-import`. Tento příkaz načítá ze vstupů stdin jednoduché instrukce k zapsáni specifických dat systému Git. Je podstatně jednodušší vytvořit objekty Git tímto způsobem než spouštět syrové příkazy Git či se pokoušet zapsat syrové objekty (podrobnější informace v kapitole 9). Tímto způsobem lze vytvořit importovací skript, který bude načítat potřebné informace ze systému, z nějž import provádíte, a vypíše jasné instrukce do výstupu stdout. Tento program můžete spustit a jeho výstup nechat zpracovat příkazem `git fast-import`.

Jako rychlou ukázku napíšeme jednoduchý importér. Řekněme, že pracujete na projektu, který příležitostně zálohujete zkopírováním pracovního adresáře do zálohového, datem označeného adresáře `back_YYYY_MM_DD`, a ten chcete nyní importovat do systému Git. Váš adresář má tuto strukturu:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

Chcete-li importovat adresář Git, budeme se muset podívat na to, jak Git ukládá svá data. Jak si možná vzpomínáte, říkali jsme, že Git je v podstatě seznam odkazů na objekty revizí, které ukazují na určitý snímek obsahu. Jediné, co tedy musíte udělat, je sdělit příkazu `fast-import`, co je obsahem snímků, jaká data revizí na ně ukazují a pořadí, v němž budou převzaty. Vaše strategie tedy bude spočívat v tom, že postupně projdete jednotlivé snímky a vytvoříte revize s obsahem každého adresáře, přičemž každá revize bude odkazovat na revizi předchozí.

Stejně jako v podkapitole „Příklad vynucení chování systémem Git“ v kapitole 7 použijeme i tentokrát Ruby, s nímž většinou pracuji a který je srozumitelný. Tento příklad můžete ale beze všeho napsat v čemkoli, co vám vyhovuje. Jedinou podmínkou je, aby byly potřebné informace zapsány na standardní výstup (stdout). A to v případě používání Windows znamená, že budete muset věnovat zvláštní pozornost tomu, abyste na koncích řádků nevkládali znaky CR (carriage return). Příkaz `git fast-import` je v tomto směru velmi vybíravý a chce jen znaky LF (line feed) a nikoliv kombinaci CRLF, kterou používají Windows.

Na začátku přejdete do cílového adresáře a identifikujete všechny podadresáře, z nichž bude každý představovat jeden snímek, který chcete importovat jako revizi. Přejdete do každého podadresáře a zadáte příkazy potřebné k jeho exportu. Základní smyčka bude mít tuto podobu:

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

V každém adresáři spustíte soubor `print_export`, který vezme manifest a známku předchozího snímku a poskytne manifest a označovač tohoto snímku. Tímto způsobem je lze řádně spojit. „Označovač“ (angl. mark) je termín používaný v souvislosti s metodou `fast-import`. Jedná se o identifikátor, který jednoznačně přiřadíte revizi a lze ho použít k odkazování na tuto revizi z revizí ostatních. Prvním krokem, který tak při metodě se souborem `print_export` uděláte, bude vygenerování označovače na základě názvu adresáře:

	mark = convert_dir_to_mark(dir)

Provedete to tak, že vytvoříte skupinu adresářů a jako označovač použijete hodnotu indexu, neboť označovač musí být celé číslo. Celý postup vypadá takto:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Nyní jste označili revizi celým číslem a zbývá stanovit datum pro metadata revize. Protože je datum obsaženo v názvu adresáře, lze ho vyčíst odtud. Dalším řádkem v souboru `print_export` bude

	date = convert_dir_to_date(dir)

kde `convert_dir_to_date` je definováno jako:

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

Tím dostanete celé číslo pro data každého adresáře. Posledními metadaty, jež budete pro všechny revize potřebovat, jsou informace o autorovi revize, které zadáte v globální proměnné:

	$author = 'Scott Chacon <schacon@example.com>'

Nyní je už vše připraveno k vygenerování dat revizí pro váš importér. Úvodní informace sděluje, že definujete objekt revize a na jaké větvi se nachází. Následuje vygenerovaný označovač, informace o autorovi revize a zpráva k revizi, po ní následuje eventuální předchozí revize. Kód má tuto podobu:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

Časové pásmo definujete napevno (--0700), protože je to jednoduché. Pokud importujete z jiného systému, musíte zadat časové pásmo jako posun.
Zpráva k revizi musí být ve speciálním formátu:

	data (size)\n(contents)

Tento formát tedy obsahuje slovo data, velikost načítaných dat (size), nový řádek a konečně data samotná (contents). Protože budete stejný formát potřebovat i později, k určení obsahu souboru vytvoříte pomocnou metodu – `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

Teď už zbývá jen určit obsah souborů všech snímků. To bude snadné, protože máte všechny v jednom adresáři. Zadejte příkaz `deleteall` a k němu přidejte obsah každého souboru v adresáři. Git pak odpovídajícím způsobem nahraje všechny snímky:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

Poznámka: Vzhledem k tomu, že mnoho systémů chápe revize jako změny od jednoho zapsání k druhému, přijímá fast-import také příkazy s každým zapsáním a zjišťuje, které soubory byly přidány, odstraněny nebo změněny a co je jejich novým obsahem. Mohli byste také vypočítat rozdíly mezi snímky a poskytnout pouze tato data. To je však o něco složitější. Stejně tak můžete systému Git zadat všechna data a přenechat výpočet na něm. Pokud je pro vaše data tato metoda vhodnější, odkážeme vás na manuálovou stránku `fast-import`, kde najdete podrobnosti o tom, jak zadat data tímto způsobem.

Formát pro výpis obsahu nového souboru nebo určení změněného souboru s novým obsahem je následující:

	M 644 inline path/to/file
	data (size)
	(file contents)

644 je v tomto případě režim (jde-li o spustitelné soubory, budete je muset vyhledat a zadat režim 755) a výraz inline říká, že obsah uvedete bezprostředně po tomto řádku. Metoda `inline_data` má tuto podobu:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

Znovu tu využijete metodu `export_data`, kterou jste aplikovali před chvílí. Jedná se totiž o stejný způsob, jakým jste specifikovali data zprávy k revizi.

Poslední věcí, kterou musíte udělat, je vrátit aktuální označovač, aby mohl být zadán do příští iterace:

	return mark

Poznámka: Pokud používáte Windows, budete muset provést jeden krok navíc. Jak už jsem se zmínil, Windows nahrazují znak konce řádku posloupností CRLF, zatímco `git fast-import` očekává pouze LF. Abychom tento problém obešli a přitom učinili příkaz `git fast-import` šťastným, musíte ruby říct, aby místo LF používal CRLF:

	$stdout.binmode

A to je celé. Spustíte-li tento skript, získáte obsah v následující podobě:

	$ ruby import.rb /opt/import_from
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

Pro spuštění importéru přesměrujte tento výstup do příkazu `git fast-import`. Příkaz spouštějte v adresáři Gitu, do nějž chcete data importovat. Můžete vytvořit nový adresář a spustit v něm příkaz `git init`, jímž si vytvoříte nový výchozí bod. Poté spusťte svůj skript:

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

Proběhne-li proces úspěšně, podá vám obsáhlou statistiku o tom, co bylo provedeno. V tomto případě jsme importovali celkem 18 objektů 5 revizí do 1 větve. Nyní si můžete nechat příkazem `git log` zobrazit svoji novou historii:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

A máme to tu — krásný, čistý repozitář Git. Měli bychom také dodat, že nejsou načtena žádná data, zatím neproběhl checkout žádných souborů do pracovního adresáře. Chcete-li je získat, musíte vaši větev resetovat do místa, kde se nyní nachází větev `master`:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

Nástroj `fast-import` vám nabízí ještě spoustu dalších možností – nastavení různých režimů, práci s binárními daty, manipulaci s několika větvemi a jejich slučování, značky, ukazatele postupu atd. Několik příkladů složitějších scénářů si můžete prohlédnout v adresáři `contrib/fast-import` ve zdrojovém kódu Git. Jedním z těch nejlepších je už zmíněný skript`git-p4`.

## Shrnutí ##

Po přečtení této kapitoly byste měli hravě zvládat používání systému Git v kombinaci se systémem Subversion a import téměř jakéhokoli existujícího repozitáře do repozitáře Git, aniž by došlo ke ztrátě dat. V následující kapitole se podíváme na elementární principy systému Git, abyste dokázali efektivně využívat každý jeho byte.
