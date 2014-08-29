# Distribuovaný charakter systému Git #

Nyní máte vytvořen vzdálený repozitář Git jako místo, kde mohou všichni vývojáři sdílet zdrojový kód, a znáte základní příkazy systému Git pro práci v lokálním prostředí. Je čas podívat se na využití některých distribuovaných postupů, které vám Git nabízí.

V této kapitole se dozvíte, jak pracovat se systémem Git v distribuovaném prostředí jako přispěvatel a zprostředkovatel integrace. Naučíte se tedy, jak úspěšně přispívat svým kódem do projektů a jak to učinit co nejjednodušeji pro vás i správce projektu. Dále se dozvíte, jak efektivně spravovat projekt, do nějž přispívá velký počet vývojářů.

## Distribuované pracovní postupy ##

Na rozdíl od centralizovaných systémů správy verzí (CVCS) umožňuje distribuovaný charakter systému Git mnohem větší flexibilitu při spolupráci vývojářů na projektech. V centralizovaných systémech představuje každý vývojář samostatný uzel, pracující více či méně na stejné úrovni vůči centrálnímu úložišti. Naproti tomu je v systému Git každý vývojář potenciálním uzlem i úložištěm, každý vývojář může přispívat kódem do jiných repozitářů i spravovat veřejný repozitář, na němž mohou ostatní založit svou práci a do nějž mohou přispívat. Tím se pro váš projekt a váš tým otvírá široké spektrum pracovních postupů. Zkusíme se tedy podívat na pár častých přístupů, které tato flexibilita umožňuje. Uvedeme jejich přednosti i eventuální slabiny. Budete si moci vybrat některý z postupů nebo je navzájem kombinovat a spojovat jejich vlastnosti.

### Centralizovaný pracovní postup ###

V centralizovaných systémech je většinou možný pouze jediný model spolupráce, tzv. centralizovaný pracovní postup. Jedno centrální úložiště (hub) nebo repozitář přijímá zdrojový kód a každý podle něj synchronizuje svou práci. Několik vývojářů představuje jednotlivé uzly (nodes) – uživatele centrálního místa – které se podle tohoto místa synchronizují (viz obrázek 5-1).

Insert 18333fig0501.png
Obrázek 5-1. Centralizovaný pracovní postup

To znamená, že pokud dva vývojáři klonují z centrálního úložiště a oba provedou změny, jen první z nich, který odešle své změny, to může provést bez komplikací. Druhý vývojář musí před odesláním svých změn začlenit práci prvního vývojáře do své, aby nepřepsal jeho změny. Tento koncept platí jak pro Git, tak pro Subversion (popř. jakýkoli CVCS). I v systému Git funguje bez problémů.

Pokud pracujete v malém týmu nebo už jste ve své společnosti nebo ve svém týmu zvyklí na centralizovaný pracovní postup, můžete v něm beze všeho pokračovat. Jednoduše vytvořte repozitář a přidělte všem ze svého týmu oprávnění k odesílání dat. Git neumožní uživatelům, aby se navzájem přepisovali. Pokud některý z vývojářů naklonuje data, provede změny a poté se je pokusí odeslat, a jiný vývojář mezitím odeslal svoje revize, server tyto změny odmítne. Git vývojáři při odmítnutí sdělí, že se pokouší odeslat změny, které nesměřují „rychle vpřed“, což není možné provést, dokud nevyzvedne a nezačlení (fetch and merge) stávající data z repozitáře.
Tento pracovní postup může být pro mnoho lidí zajímavý, protože je to schéma, které jsou zvyklí používat a jsou s ním spokojeni.

### Pracovní postup s integračním manažerem ###

Protože Git umožňuje, abyste měli několik vzdálených repozitářů, lze použít pracovní postup, kdy má každý vývojář oprávnění k zápisu do vlastního veřejného repozitáře a oprávnění pro čtení k repozitářům všech ostatních. Tento scénář často zahrnuje jeden standardní repozitář, který reprezentuje „oficiální“ projekt. Chcete-li do tohoto projektu přispívat, vytvořte vlastní veřejný klon projektu a odešlete do něj změny, které jste provedli. Poté odešlete správci hlavního projektu žádost, aby do projektu natáhl vaše změny. Správce může váš repozitář přidat jako vzdálený repozitář, lokálně otestovat vaše změny, začlenit je do své větve a odeslat zpět do svého repozitáře. Postup práce je následující (viz obrázek 5-2):

1. Správce projektu odešle data do svého veřejného repozitáře.
2. Přispěvatel naklonuje tento repozitář a provede změny.
3. Přispěvatel odešle změny do své vlastní veřejné kopie.
4. Přispěvatel pošle správci e-mail s žádostí, aby natáhl změny do projektu.
5. Správce přidá repozitář přispěvatele jako vzdálený repozitář a provede lokální začlenění.
6. Správce odešle začleněné změny do hlavního repozitáře.

Insert 18333fig0502.png
Obrázek 5-2. Pracovní postup s integračním manažerem

Tento pracovní postup je velmi rozšířený na serverech jako je GitHub, kde je snadné rozštěpit projekt a odeslat změny do své odštěpené části, kde jsou pro každého k nahlédnutí. Jednou z hlavních předností tohoto postupu je, že můžete pracovat bez přerušení a správce hlavního repozitáře může natáhnout vaše změny do projektu, kdykoli uzná za vhodné. Přispěvatelé nemusí čekat, až budou jejich změny začleněny do projektu – každá strana může pracovat svým tempem.

### Pracovní postup s diktátorem a poručíky ###

Jedná se o variantu pracovního postupu s více repozitáři. Většinou se používá u obřích projektů se stovkami spolupracovníků. Možná nejznámějším příkladem je vývoj jádra Linuxu. Několik různých integračních manažerů odpovídá za konkrétní části repozitáře – říká se jím poručíci (lieutenants). Všichni poručíci mají jednoho integračního manažera, kterému se říká „benevolentní diktátor“. Repozitář benevolentního diktátora slouží jako referenční repozitář, z nějž všichni spolupracovníci musí stahovat data. Postup práce je následující (viz obrázek 5-3):

1. Stálí vývojáři pracují na svých tematických větvích a přeskládávají svou práci na vrchol hlavní větve. Hlavní větev je větev diktátora.
2. Poručíci začleňují tematické větve vývojářů do svých hlavních větví.
3. Diktátor začleňuje hlavní větve poručíků do své hlavní větve.
4. Diktátor odesílá svou hlavní větev do referenčního repozitáře, aby si na jeho základě mohli ostatní vývojáři přeskládat data.

Insert 18333fig0503.png
Obrázek 5-3. Pracovní postup s benevolentním diktátorem

Tento typ pracovního postupu není sice obvyklý, ale může být užitečný u velmi velkých projektů nebo v silně hierarchizovaných prostředích, neboť umožňuje, aby vedoucí projektu (diktátor) velkou část práce delegoval. Pak sbírá velké kusy kódu, které integruje.

Toto jsou tedy některé z běžně používaných pracovních postupů, které můžete využít v distribuovaných systémech, jako je například Git. Uvidíte ale, že na pozadí vašich konkrétních potřeb v reálných situacích lze vytvořit celou řadu variací na tyto postupy. Nyní, když už se (jak doufám) dokážete rozhodnout, která kombinace postupů pro vás bude ta nejvhodnější, ukážeme si některé konkrétní příklady, jak lze rozdělit hlavní role, z nichž vyplývají jednotlivé postupy práce.

## Přispívání do projektu ##

V tuto chvíli už znáte různé pracovní postupy a na velmi solidní úrovni byste měli ovládat základy systému Git. V této části ukážeme několik běžných schémat, podle nichž může přispívání do projektů probíhat.

Popsat tento proces není právě jednoduché, protože existuje obrovské množství variací, jak lze do projektů přispívat. Vzhledem k velké flexibilitě systému Git mohou uživatelé spolupracovat mnoha různými způsoby, a není proto snadné popsat, jak byste měli do projektu přispívat. Každý projekt je trochu jiný. Mezi proměnné patří v tomto procesu počet aktivních přispěvatelů, zvolený pracovní postup, vaše oprávnění pro odesílání revizí a případně i metoda externího přispívání.

První proměnnou je počet aktivních přispěvatelů. Kolik uživatelů aktivně přispívá kódem do projektu a jak často? V mnoha případech budete mít dva nebo tři vývojáře přispívající několika málo revizemi denně, u projektů s nízkou prioritou možná i méně. V opravdu velkých společnostech a u velkých projektů se může počet vývojářů vyšplhat do tisíců a počet revizí se může pohybovat v desítkách i stovkách záplat denně. To je důležité zejména z toho hlediska, že s rostoucím počtem vývojářů se také zvětšují starosti s tím, aby byl kód aplikován čistě a aby ho bylo možné snadno začlenit. U změn, které postoupíte vyšší instanci, může docházet k zastarávání nebo vážnému narušení jinými daty, která byla začleněna během vaší práce nebo ve chvíli, kdy vaše změny čekaly na schválení či aplikaci. Jak lze důsledně udržovat kód aktuální a záplaty vždy platné?

Další proměnnou je pracovní postup, který se u projektu využívá. Probíhá vývoj centralizovaně, má každý vývojář stejné oprávnění pro zápis do hlavní linie kódu? Má projekt svého správce nebo integračního manažera, který kontroluje všechny záplaty? Jsou všechny záplaty odborně posuzovány a schvalovány? Jste součástí tohoto procesu? Jsou součástí systému poručíci a musíte všechnu svou práci odesílat nejprve jim?

Další otázkou je vaše oprávnění k zapisování revizí. Pracovní postup při přispívání do projektu se velmi liší podle toho, zda máte, či nemáte oprávnění k zápisu do projektu. Pokud oprávnění k zápisu nemáte, jakou metodu projekt zvolí pro přijímání příspěvků? Má k tomu vůbec vyvinutou metodiku? Kolik práce představuje jeden váš příspěvek? A jak často přispíváte?

Všechny tyto otázky mohou mít vliv na efektivní přispívání do projektu a určují, jaký pracovní postup je vůbec možný a který bude upřednostněn. Všem těmto aspektům bych se teď chtěl věnovat na sérii praktických příkladů, od těch jednodušších až po složité. Z uvedených příkladů byste si pak měli být schopni odvodit vlastní pracovní postup, který budete v praxi využívat.

### Pravidla pro revize ###

Než se podíváme na konkrétní praktické příklady, přidávám malou poznámku o zprávách k revizím. Není od věci stanovit si a dodržovat kvalitní pravidla pro vytváření revizí. Výrazně vám mohou usnadnit práci v systému Git a spolupráci s kolegy. Projekt Git obsahuje dokument, v němž je navržena celá řada dobrých tipů pro vytváření revizí, z nichž se skládají jednotlivé záplaty. Dokument najdete ve zdrojovém kódu systému Git v souboru `Documentation/SubmittingPatches`.

Především nechcete, aby revize obsahovaly chyby způsobené prázdnými znaky. Git nabízí snadný způsob, jak tyto chyby zkontrolovat. Před zapsáním revize zadejte příkaz `git diff --check`, který zkontroluje prázdné znaky a vypíše vám jejich seznam. Zde uvádím jeden příklad, v němž jsem červenou barvu terminálu nahradil znaky `X`:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Spustíte-li tento příkaz před zapsáním revize, můžete se rozhodnout, zda chcete zapsat i problematické prázdné znaky, které mohou obtěžovat ostatní vývojáře.

Dále se snažte provádět každou revizi jako logicky samostatný soubor změn. Pokud je to možné, snažte se provádět stravitelné změny. Není právě ideální pracovat celý víkend na pěti různých problémech a v pondělí je všechny najednou odeslat v jedné velké revizi. I pokud nebudete během víkendu zapisovat revize, využijte v pondělí oblasti připravených změn a rozdělte svou práci alespoň do stejného počtu revizí, kolik je řešených problémů, a přidejte k nim vysvětlující zprávy. Pokud některé změny modifikují tentýž soubor, zkuste použít příkaz `git add --patch` a připravit soubory k zapsání po částech (podrobnosti v kapitole 6). Snímek projektu na vrcholu větve bude stejný, ať zapíšete jednu revizi, nebo pět (za předpokladu, že vložíte všechny změny). Snažte se proto usnadnit práci svým kolegům, kteří – možná – budou vaše změny kontrolovat. Díky tomuto přístupu také později snáze vyjmete nebo vrátíte některou z provedených změn, bude-li to třeba. Kapitola 6 popisuje několik užitečných triků, jak v systému Git přepsat historii a jak interaktivně připravovat soubory k zapsání. Používejte tyto nástroje k udržení čisté a srozumitelné historie.

Poslední věcí, na niž se vyplatí soustředit pozornost, jsou zprávy k revizím. Pokud si zvyknete vytvářet k revizím kvalitní zprávy, bude pro vás práce a kooperace v systému Git mnohem jednodušší. Zpráva by měla obvykle začínat samostatným řádkem o maximálně 50 znacích, v níž stručně popíšete soubor provedených změn. Za ním by měl následovat prázdný řádek a za ním podrobnější popis revize. Projekt Git vyžaduje, aby podrobnější popis revize obsahoval vaši motivaci ke změnám a vymezil jejich implementaci na pozadí předchozích kroků. Tuto zásadu je dobré dodržovat. Vytváříte-li zprávy k revizím v angličtině, často se také doporučuje používat rozkazovací způsob, tj. příkazy. Místo „I added tests for“ nebo „Adding tests for“ používejte raději „Add tests for“.
Zde uvádíme vzor, jehož autorem je Tim Pope a v originále je k nalezení na stránkách tpope.net:

	Krátké (do 50 znaků) shrnutí změn

	Podrobnější popis revize, je-li třeba. Snažte se nepřesáhnout
	zhruba 72 znaků. V některých kontextech	je první řádek koncipován
	jako předmět e-mailu a zbytek textu jako jeho tělo. Prázdný řádek
	oddělující shrnutí od těla zprávy je nezbytně nutný (pokud
	nehodláte vypustit celé tělo). Spojení obou částí může zmást
	některé nástroje, např. přeskládání.

	Další odstavce následují za prázdným řádkem.

	 - Můžete používat i odrážky.

	 - Jako odrážka se nejčastěji používá pomlčka nebo hvězdička, před ně se vkládá
	   jedna mezera, mezi body výčtu prázdný řádek, avšak úzus tu není jednotný.

Budou-li takto vypadat všechny vaše zprávy k revizím, usnadníte tím práci sobě i svým spolupracovníkům. Projekt Git obsahuje kvalitně naformátované zprávy k revizím. Mohu vám doporučit, abyste v něm zkusili zadat příkaz `git log --no-merges` a podívali se, jak vypadá pěkně naformátovaná historie revizí projektu.

Já v následujících příkladech stejně jako ve většině případů v této knize v rámci zestručnění neformátuji zprávy podle uvedených zásad, naopak používám parametr `-m` za příkazem `git commit`. Řiďte se, prosím, podle toho, co říkám, ne podle toho, co dělám.

### Malý soukromý tým ###

Nejjednodušší sestavou, s níž se pravděpodobně setkáte, je soukromý projekt, na němž kromě vás pracují ještě jeden nebo dva vývojáři. Soukromým projektem myslím uzavřený zdrojový kód – okolní svět k němu nemá oprávnění pro čtení. Vy a vaši ostatní vývojáři máte všichni oprávnění odesílat změny do repozitáře.

V takovém prostředí můžete uplatnit podobný pracovní postup, na jaký jste možná zvyklí ze systému Subversion nebo jiného centralizovaného systému. Se systémem Git ale budete stále ještě ve výhodě v takových ohledech, jako je zapisování revizí offline a podstatně snazší větvení a slučování. Pracovní postup však bude velmi podobný. Hlavním rozdílem je to, že slučování probíhá na straně klienta, ne během zapisování revize na straně serveru.
Podívejme se, jak to může vypadat, když dva vývojáři začnou spolupracovat na projektu se sdíleným repozitářem. První vývojář, John, naklonuje repozitář, provede změny a zapíše lokální revizi. (V následujících příkladech nahrazuji zprávy protokolů třemi tečkami, abych je trochu zkrátil.)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

Druhý vývojář, Jessica, učiní totéž – naklonuje repozitář a zapíše provedené změny:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

Jessica nyní odešle svou práci na server:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

Také John se pokusí odeslat své změny na server:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

John nyní nesmí odeslat revize, protože mezitím odeslala své změny Jessica. To je třeba si uvědomit, zejména pokud jste zvyklí na systém Subversion. Oba vývojáři totiž neupravovali stejný soubor. Přestože Subversion provádí takové sloučení na serveru automaticky, pokud byly upraveny různé soubory, v systému Git musíte provést sloučení lokálně. John musí vyzvednout změny, které provedla Jessica, a začlenit je do své práce, než ji bude moci odeslat:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

V tomto okamžiku vypadá Johnův lokální repozitář jako na obrázku 5-4.

Insert 18333fig0504.png
Obrázek 5-4. Johnův výchozí repozitář

John má referenci ke změnám, které odeslala Jessica, ale než bude moci sám odeslat svá data, bude muset začlenit její práci:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Sloučení probíhá hladce, Johnova historie revizí teď vypadá jako na obrázku 5-5.

Insert 18333fig0505.png
Obrázek 5-5. Johnův repozitář po začlenění větve `origin/master`

John nyní může otestovat svůj kód, aby se ujistil, že stále pracuje správně, a pak může odeslat svou novou sloučenou práci na server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Johnova historie revizí bude nakonec vypadat jako na obrázku 5-6.

Insert 18333fig0506.png
Obrázek 5-6. Johnova historie po odeslání revize na server origin

Jessica mezitím pracovala na tematické větvi. Vytvořila tematickou větev s názvem `issue54` a zapsala do ní tři revize. Zatím ještě nevyzvedla Johnovy změny, a proto její historie revizí vypadá jako na obrázku 5-7.

Insert 18333fig0507.png
Obrázek 5-7. Výchozí historie revizí – Jessica

Jessica chce synchronizovat svou práci s Johnem, a proto vyzvedne jeho data:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Tím stáhne práci, kterou mezitím odeslal John. Historie revizí Jessicy teď vypadá jako na obrázku 5-8.

Insert 18333fig0508.png
Obrázek 5-8. Historie Jessicy po vyzvednutí Johnových změn

Jessica považuje svou tematickou větev za dokončenou, ale chce vědět, do čeho má svou práci začlenit, aby mohla změny odeslat. Spustí proto příkaz `git log`:

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

Jessica nyní může začlenit tematickou větev do své větve `master`, začlenit (merge) i Johnovu práci (`origin/master`) do své větve `master` a vše odeslat zpět na server. Nejprve se přepne zpět na svou větev `master`, aby do ní mohla vše integrovat:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Jako první může začlenit buď větev `origin/master` nebo `issue54`. Obě směřují vpřed, a tak jejich pořadí nehraje žádnou roli. Konečný snímek bude stejný, ať zvolí jakékoli pořadí, mírně se bude lišit jen historie revizí. Jessica se rozhodne začlenit jako první větev `issue54`:

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Tento postup je bezproblémový. Jak vidíte, šlo o jednoduchý posun „rychle vpřed“. Nyní Jessica začlení Johnovu práci (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Začlenění proběhne čistě a historie Jessicy bude vypadat jako na obrázku 5-9.

Insert 18333fig0509.png
Obrázek 5-9. Historie Jessicy po začlenění Johnových změn

Větev `origin/master` teď má Jessica dostupnou ze své větve `master`, takže může svou práci úspěšně odeslat (za předpokladu, že John mezitím neodeslal další revize):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Všichni vývojáři zapsali několik revizí a úspěšně začlenili práci ostatních do své – viz obrázek 5-10.

Insert 18333fig0510.png
Obrázek 5-10. Historie Jessicy po odeslání všech změn zpět na server

Toto je jeden z nejjednodušších pracovních postupů. Po určitou dobu pracujete, obvykle na nějaké tematické větvi, a když je připravena k integraci, začleníte ji do své větve `master`. Chcete-li tuto práci sdílet, začleníte ji do své větve `master`. Poté vyzvednete (fetch) a začleníte (merge) větev `origin/master`, jestliže se změnila. Nakonec odešlete všechna data do větve `master` na serveru. Obecná posloupnost kroků je naznačena na obrázku 5-11.

Insert 18333fig0511.png
Obrázek 5-11. Obecná posloupnost kroků u jednoduchého pracovního postupu s více vývojáři v systému Git

### Soukromý řízený tým ###

V následujícím scénáři se podíváme na role přispěvatelů ve větší soukromé skupině. Naučíte se, jak pracovat v prostředí, v němž na jednotlivých úkolech spolupracují malé skupiny a tyto týmové příspěvky jsou poté integrovány druhou stranou.

Řekněme, že John a Jessica spolupracují na jednom úkolu a Jessica a Josie spolupracují na jiném. Společnost v tomto případě používá typ pracovního postupu s integračním manažerem, kdy práci jednotlivých skupin integrují pouze někteří technici a větev `master` hlavního repozitáře mohou aktualizovat pouze oni. V tomto scénáři se veškerá práce provádí ve větvích jednotlivých týmů a později je spojována zprostředkovateli integrace.

Sledujme pracovní postup Jessicy pracující na dvou úkolech a spolupracující v tomto prostředí paralelně s dvěma různými vývojáři. Protože už má naklonovaný repozitář, rozhodne se pracovat nejprve na úkolu A – `featureA`. Vytvoří si pro něj novou větev a udělá v ní určité penzum práce.

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

V tomto okamžiku potřebuje sdílet svou práci s Johnem, a tak odešle revize své větve `featureA` na server. Jessica nemá oprávnění pro odesílání dat do větve `master` (ten mají pouze zprostředkovatelé integrace), a proto musí své revize odeslat do jiné větve, aby mohla s Johnem spolupracovat:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica pošle Johnovi e-mail s informací, že odeslala svou práci do větve pojmenované `featureA` a že se na ni může podívat. Zatímco čeká na zpětnou vazbu od Johna, rozhodne se, že začne pracovat spolu s Josie na úkolu `featureB`. Začne tím, že založí novou větev, která bude založena na větvi `master` ze serveru:

	# Jessica's Machine
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Jessica nyní vytvoří několik revizí ve větvi `featureB`:

	$ vim lib/simplegit.rb
	$ git commit -am 'made the ls-tree function recursive'
	[featureB e5b0fdc] made the ls-tree function recursive
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'add ls-files'
	[featureB 8512791] add ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

Repozitář Jessicy vypadá jako na obrázku 5-12.

Insert 18333fig0512.png
Obrázek 5-12. Výchozí historie revizí – Jessica

Jessica je připravena odeslat svou práci, ale dostane e-mail od Josie, že již na server odeslala větev `featureBee`, v níž už je část práce hotová. Než bude Jessica moci odeslat svou práci na server, bude do ní nejprve muset začlenit práci Josie. Změny, které Josie provedla, vyzvedne příkazem `git fetch`:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Nyní může Jessica začlenit tyto změny do své práce pomocí příkazu `git merge`:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

Tady nastává určitý problém. Musí odeslat práci začleněnou ve své větvi `featureB` do větve `featureBee` na serveru. Může tak učinit příkazem `git push` s určením lokální větve, za níž bude následovat dvojtečka (:) a za ní vzdálená větev:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Říká se tomu *refspec*. Více o vzorcích refspec systému Git a různých možnostech, k nimž je lze využít, najdete v kapitole 9.

Poté pošle John Jessice e-mail, že odeslal několik změn do větve `featureA`, a poprosí ji, aby je ověřila. Jessica spustí příkaz `git fetch`, jímž tyto změny stáhne.

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

Poté si může příkazem `git log` prohlédnout, co všechno bylo změněno:

	$ git log origin/featureA ^featureA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    changed log output to 30 from 25

Nakonec začlení Johnovu práci do své vlastní větve `featureA`:

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica by ráda něco vylepšila, a proto vytvoří novou revizi a odešle ji zpět na server:

	$ git commit -am 'small tweak'
	[featureA 774b3ed] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..774b3ed  featureA -> featureA

Historie revizí Jessicy bude nyní vypadat jako na obrázku 5-13.

Insert 18333fig0513.png
Obrázek 5-13. Historie Jessicy po zapsání revizí do větve s úkolem

Jessica, Josie a John pošlou zprávu zprostředkovatelům integrace, že větve `featureA` a `featureBee` jsou na serveru připraveny k integraci do hlavní linie. Poté, co budou tyto větve do hlavní linie integrovány, vyzvednutím dat bude možné stáhnout nové revize vzniklé začleněním změn a historie revizí bude vypadat jako na obrázku 5-14.

Insert 18333fig0514.png
Obrázek 5-14. Historie Jessicy po začlenění obou jejích tematických větví

Mnoho skupin přechází na systém Git právě kvůli této možnosti paralelní spolupráce několika týmů a následného slučování různých linií práce. Možnost, aby několik menších podskupin jednoho týmu spolupracovalo prostřednictvím vzdálených větví a aby si práce nevyžádala účast celého týmu nebo nebránila ostatním v jiné práci, je velkou devízou systému Git. Posloupnost kroků vypadá v případě pracovního postupu, který jsme si právě ukázali, jako na obrázku 5-15.

Insert 18333fig0515.png
Obrázek 5-15. Základní posloupnost kroků u pracovního postupu v řízeném týmu

### Malý veřejný projekt ###

Přispívání do veřejných projektů se poněkud liší. Protože nemáte oprávnění aktualizovat větve projektu přímo, musíte svou práci doručit správcům jinak. První příklad popisuje, jak se přispívá s využitím rozštěpení na hostitelských serverech Git, které podporují snadné štěpení. Jak server repo.or.cz, tak místa pro hostování podporují štěpení a mnoho správců projektů tento styl přispívání vyžaduje. Další část se pak zabývá projekty, u nichž je upřednostňováno doručování záplat e-mailem.

Nejprve patrně bude nutné, abyste naklonovali hlavní repozitář, vytvořili tematickou větev pro záplatu nebo sérii záplat, které hodláte vytvořit, a udělali v nich zamýšlenou práci. Posloupnost příkazů bude tedy následující:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Možná budete chtít využít příkaz `rebase -i` a zkomprimovat svou práci do jediné revize nebo přeorganizovat práci v revizích tak, aby byla kontrola záplaty pro správce jednodušší – další informace o interaktivním přeskládání najdete v kapitole 6.

Až budete s prací ve větvi hotovi a budete ji chtít poslat zpět správcům, přejděte na původní stránku projektu a klikněte na tlačítko „Fork“, jímž vytvoříte vlastní odštěpenou větev projektu, do níž budete moci zapisovat. Poté bude třeba, abyste tuto novou adresu URL repozitáře přidali jako druhý vzdálený repozitář, v tomto případě pojmenovaný `myfork`:

	$ git remote add myfork (url)

Do něj teď musíte odeslat svou práci. Lepším řešením bude odeslat vzdálenou větev, na níž pracujete, do svého repozitáře, než ji začlenit do hlavní větve a tu pak celou odeslat. Důvod je prostý: pokud nebude vaše práce přijata nebo bude převzata částečně, nebudete muset vracet změny začleněné do vaší hlavní větve. Pokud správci začlení či přeskládají vaši práci (nebo její část), získáte ji zpět stažením z repozitáře:

	$ git push myfork featureA

Až svou práci odešlete do odštěpené větve, budete na ni muset upozornit správce. Tomu se říká „žádost o natažení“ (angl. pull request). Můžete ji vygenerovat buď na webové stránce – server GitHub má tlačítko „pull request“, které automaticky odešle správci upozornění – nebo můžete zadat příkaz `git request-pull` a jeho výstup e-mailem ručně odeslat správci projektu.

Příkaz `request-pull` vezme základní větev (základnu), do níž chcete natáhnout svou tematickou větev, a adresu URL repozitáře Git, z nějž chcete práci natáhnout, a vytvoří shrnutí všech změn, které by měl správce podle vaší žádosti natáhnout. Pokud chce například Jessica poslat Johnovi žádost o natažení a vytvořila předtím dvě revize v tematické větvi, kterou právě odeslala, může zadat tento příkaz:

	$ git request-pull origin/master myfork
	The following changes since commit 1edee6b1d61823a2de3b09c160d7080b8d1b3a40:
	  John Smith (1):
	        added a new function

	are available in the git repository at:

	  git://githost/simplegit.git featureA

	Jessica Smith (2):
	      add limit to log function
	      change log output to 30 from 25

	 lib/simplegit.rb |   10 +++++++++-
	 1 files changed, 9 insertions(+), 1 deletions(-)

Výstup příkazu lze odeslat správci. Sdělí mu, odkud daná větev pochází, podá mu přehled o revizích a řekne mu, odkud lze práci stáhnout.

U projektů, u nichž nejste v roli správce, je většinou jednodušší, aby vaše větev `master` stále sledovala větev `origin/master` a abyste práci prováděli v tematických větvích, jichž se můžete beze všeho vzdát v případě, že budou odmítnuty. Jednotlivé úkoly izolované v tematických větvích mají také tu výhodu, že snáze přeskládáte svou práci, jestliže se průběžně posouvá konec hlavního repozitáře a vaše revize už nelze aplikovat čistě. Pokud například chcete do projektu přispět druhým tématem, nerozvíjejte svou práci v tematické větvi, kterou jste právě odeslali. Začněte znovu od začátku z větve `master` hlavního repozitáře:

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

Nyní mají obě vaše témata samostatný zásobník – podobně jako řada záplat – které můžete přepsat, přeskládat a upravit, aniž by se tím obě témata navzájem ovlivňovala nebo omezovala (viz obrázek 5-16).

Insert 18333fig0516.png
Obrázek 5-16. Výchozí historie revizí s větví featureB

Řekněme, že správce projektu natáhl do projektu několik jiných záplat a nyní vyzkoušel vaši první větev, jenže tu už nelze čistě začlenit. V takovém případě můžete zkusit přeskládat tuto větev na vrcholu větve `origin/master`, vyřešit za správce vzniklé konflikty a poté své změny ještě jednou odeslat:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push -f myfork featureA

Tím přepíšete svou historii, která teď bude vypadat jako na obrázku 5-17.

Insert 18333fig0517.png
Obrázek 5-17. Historie revizí s větví featureA

Protože jste větev přeskládali, musíte k příkazu git push přidat parametr `-f`, abyste mohli větev `featureA` na serveru nahradit revizí, která není jejím potomkem. Druhou možností je odeslat tuto novou práci do jiné větve na serveru (nazvané např. `featureAv2`).

Podívejme se ještě na jeden pravděpodobnější scénář: Správce se podíval na práci ve vaší druhé větvi, váš koncept se mu líbí, ale rád by, abyste změnili jeden implementační detail. Vy tuto příležitost využijete zároveň k tomu, abyste práci přesunuli tak, aby byla založena na aktuálním stavu projektu ve větvi `master`. Začnete vytvořením nové větve z aktuální větve `origin/master`, zkomprimujete do ní změny z větve `featureB`, vyřešíte všechny konflikty, provedete změnu v implementaci a to vše odešlete jako novou větev:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

Parametr `--squash` (komprimovat) vezme všechnu vaši práci v začleněné větvi a zkomprimuje ji do jedné revize, která nevznikla jako výsledek sloučení a leží na vrcholu větve, na níž se právě nacházíte. Parametr `--no-commit` říká systému Git, aby revizi automaticky nezaznamenával. To vám umožní provést všechny změny z jiné větve a poté udělat více změn, než zaznamenáte novou revizi.

Nyní můžete správci oznámit, že jste provedli požadované změny a že je najde ve vaší větvi `featureBv2` (viz obrázek 5-18).

Insert 18333fig0518.png
Obrázek 5-18. Historie revizí s větví featureBv2

### Velký veřejný projekt ###

Mnoho větších projektů si vytvořilo vlastní, odlišné procedury k doručování záplat. U každého projektu se tak budete muset informovat o konkrétních pravidlech. U mnoha větších veřejných projektů se však záplaty doručují na základě poštovní konference vývojářů, a proto se teď zaměřím na tento případ.

Pracovní postup je podobný jako v předchozím případě. Pro každou sérii záplat, na níž pracujete, vytvoříte samostatnou tematickou větev. Liší se to, jak je budete doručovat do projektu. Místo toho, abyste rozštěpili projekt a odeslali své změny do vlastní zapisovatelné verze, vygenerujete e-mailovou verzi každé série revizí a pošlete je e-mailem do poštovní konference vývojářů:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Nyní máte dvě revize, které chcete odeslat do poštovní konference. Pro vygenerování emailových zpráv ve formátu mbox použijte příkaz `git format-patch`. Každá revize se přetransformuje na e-mailovou zprávu, jejíž předmět bude tvořit první řádek zprávy k revizi a tělo e-mailu bude tvořeno zbytkem zprávy a samotnou záplatou. Výhodou tohoto postupu je, že aplikace záplaty z e-mailu, který byl vygenerován příkazem `format-patch`, v pořádku uchová všechny informace o revizi. Podrobněji si to ukážeme v následující části, až budeme aplikovat tyto revize:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

Příkaz `format-patch` vypíše názvy souborů záplaty, kterou vytváří. Přepínač `-M` řekne systému Git, aby zkontroloval případné přejmenování. Soubory nakonec vypadají takto:

	$ cat 0001-add-limit-to-log-function.patch
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

	---
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index 76f47bc..f9815f1 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -14,7 +14,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log #{treeish}")
	+    command("git log -n 20 #{treeish}")
	   end

	   def ls_tree(treeish = 'master')
	--
	1.6.2.rc1.20.g8c5b.dirty

Tyto soubory záplaty můžete také upravit a přidat k nim další informace určené pro seznam příjemců e-mailu, u nichž nechcete, aby byly obsaženy ve zprávě k revizi. Přidáte-li text mezi řádek `---` a začátek záplaty (řádek `lib/simplegit.rb`), vývojářům se zobrazí, ale aplikace záplaty ho obsahovat nebude.

Chcete-li e-mail odeslat do poštovní konference, můžete soubor buď vložit do svého e-mailového programu, nebo ho odeslat pomocí příkazového řádku. Vložení textu může často způsobovat problémy s formátováním, zvlášť v případě některých „chytřejších“ klientů, kteří správně nezachovávají nové řádky a jiné prázdné znaky. Git naštěstí nabízí nástroj, který vám pomůže odeslat správně formátované patche pomocí protokolu IMAP. Já budu dokumentovat odeslání záplaty na příkladu Gmailu, který používám jako svého e-mailového agenta. Podrobné instrukce pro celou řadu poštovních programů najdete na konci již dříve zmíněného souboru `Documentation/SubmittingPatches` ve zdrojovém kódu systému Git.

Nejprve je třeba nastavit sekci „imap“ v souboru `~/.gitconfig`. Každou hodnotu můžete nastavit zvlášť pomocí série příkazů `git config` nebo můžete vložit hodnoty ručně. Na konci by ale měl váš soubor config vypadat přibližně takto:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Pokud váš server IMAP nepoužívá SSL, dva poslední řádky zřejmě nebudou vůbec třeba a hodnota hostitele bude `imap://`, a nikoli `imaps://`.
Až toto nastavení dokončíte, můžete použít příkaz `git imap-send`, jímž umístíte sérii záplat (patch) do složky Koncepty (Drafts) zadaného serveru IMAP:

	$ cat *.patch |git imap-send
	Resolving imap.gmail.com... ok
	Connecting to [74.125.142.109]:993... ok
	Logging in...
	sending 2 messages
	100% (2/2) done

V tomto okamžiku byste měli být schopni přejít do složky Drafts, změnit pole To na mailing list, do kterého záplatu posíláte, případně pole CC na správce nebo na osobu zodpovědnou za tuto část, a odeslat.

Záplaty můžete odesílat i přes SMTP server. Stejně jako v předchozím případu můžete nastavit sérií příkazů `git config` každou hodnotu zvlášť, nebo je můžete vložit ručně do sekce sendemail souboru `~/.gitconfig`:

	[sendemail]
	  smtpencryption = tls
	  smtpserver = smtp.gmail.com
	  smtpuser = user@gmail.com
	  smtpserverport = 587

Jakmile je to hotové, můžete záplaty odeslat příkazem `git send-email`:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Git poté vytvoří log s určitými informacemi, který bude pro každou záplatu, kterou posíláte, vypadat asi takto:

	(mbox) Adding cc: Jessica Smith <jessica@example.com> from
	  \line 'From: Jessica Smith <jessica@example.com>'
	OK. Log says:
	Sendmail: /usr/sbin/sendmail -i jessica@example.com
	From: Jessica Smith <jessica@example.com>
	To: jessica@example.com
	Subject: [PATCH 1/2] added limit to log function
	Date: Sat, 30 May 2009 13:29:15 -0700
	Message-Id: <1243715356-61726-1-git-send-email-jessica@example.com>
	X-Mailer: git-send-email 1.6.2.rc1.20.g8c5b.dirty
	In-Reply-To: <y>
	References: <y>

	Result: OK

### Shrnutí ###

V této části jsme popsali několik obvyklých pracovních postupů při přispívání do velmi odlišných typů projektů Git, s nimiž se můžete setkat. Představili jsme k nim také nové nástroje, které vám mohou v těchto procesech pomoci. V další části se na projekty podíváme z té druhé strany – ukážeme, jak může vypadat jejich správa. Dozvíte se, jak být benevolentním diktátorem nebo integračním manažerem.

## Správa projektu ##

Při práci na projektech Git možná nevystačíte jen s vědomostmi, jak do projektu efektivně přispívat. Pravděpodobně budete jednou potřebovat vědět něco i o správě projektů. Do této oblasti spadá přijímání a aplikace záplat vygenerovaných příkazem `format-patch`, které vám vývojáři poslali, nebo třeba integrace změn ve vzdálených větvích pro repozitáře, které jste do svého projektu přidali jako vzdálené repozitáře. Ať spravujete standardní repozitář, nebo pomáháte při ověřování či schvalování záplat, budete muset vědět, jak přijímat práci ostatních přispěvatelů, a to způsobem, který je pro ostatní co nejčistší a pro vás dlouhodobě udržitelný.

### Práce v tematických větvích ###

Pokud uvažujete o integraci nové práce do projektu, je většinou dobré zkusit si to v tematické větvi, tj. dočasné větvi, kterou vytvoříte konkrétně pro tento účel. Snadno tak můžete záplatu individuálně opravit, a pokud není funkční, opustit ji, dokud nebudete mít čas k její opravě. Pokud pro větev vytvoříte jednoduchý název spojený s tématem testované práce (např. `ruby_client` nebo něco obdobně popisného), snadno se na větev rozpomenete, jestliže se k ní musíte později vrátit. Správce projektů Git přiřazuje těmto větvím také jmenný prostor, např. `sc/ruby_client`, kde `sc` je zkratka pro osobu, která práci vytvořila.
Jak si vzpomínáte, můžete vytvořit větev založenou na své hlavní větvi:

	$ git branch sc/ruby_client master

Nebo pokud na ni chcete rovnou přepnout, můžete použít parametr `checkout -b`:

	$ git checkout -b sc/ruby_client master

Nyní tedy můžete vložit svůj příspěvek do této tematické větve a rozhodnout se, zda ho chcete začlenit do svých trvalejších větví.

### Aplikace záplat z e-mailu ###

Jestliže obdržíte e-mailem záplatu, kterou potřebujete integrovat do svého projektu, aplikujete ho nejprve do tematické větve, v níž ho vyhodnotíte. Existují dva způsoby aplikace záplaty z e-mailu: příkazem `git apply` nebo příkazem `git am`.

#### Aplikace záplaty příkazem „apply“ ####

Pokud dostanete záplatu od někoho, kdo ji vygeneroval příkazem `git diff` nebo unixovým příkazem `diff`, můžete ho aplikovat příkazem `git apply`. Předpokládejme, že jste záplatu uložili jako `/tmp/patch-ruby-client.patch`. Aplikaci pak provedete takto:

	$ git apply /tmp/patch-ruby-client.patch

Tím změníte soubory ve svém pracovním adresáři. Je to téměř stejné, jako byste k aplikaci záplaty použili příkaz `patch -p1`. Tento postup je však přísnější a nepřijímá tolik přibližných shod jako příkaz patch. Poradí si také s přidanými, odstraněnými a přejmenovanými soubory, jsou-li popsány ve formátu `git diff`, což příkaz `patch` nedělá. A konečně příkaz `git apply` pracuje na principu „aplikuj vše, nebo zruš vše“. Buď jsou tedy aplikovány všechny soubory, nebo žádný. Naproti tomu příkaz `patch` může aplikovat soubory záplaty jen částečně a zanechat váš pracovní adresář v neurčitém stavu. Příkaz `git apply` je tedy celkově víc paranoidní než příkaz `patch`. Tímto příkazem ostatně ani nezapíšete revizi, po jeho spuštění budete muset připravit a zapsat provedené změny ručně.

Příkaz `git apply` můžete použít také ke kontrole, zda bude záplata aplikována čistě. V takovém případě použijte na patch příkaz `git apply --check`:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

Pokud se nezobrazí žádný výstup, záplata bude aplikována čistě. Jestliže kontrola selže, příkaz vrací nenulový návratový kód, a proto ho lze snadno používat ve skriptech.

#### Aplikace záplaty příkazem „am“ ####

Pokud je přispěvatel uživatelem systému Git a byl natolik dobrý, že k vygenerování záplaty použil příkaz `format-patch`, budete mít usnadněnou práci, protože záplata obsahuje informace o autorovi a zprávu k revizi. Můžete-li, doporučte svým přispěvatelům, aby místo příkazu `diff` používali příkaz `format-patch`. Příkaz `git apply` je dobré používat jen pro starší záplaty a podobně.

K aplikaci patche vygenerovaného příkazem `format-patch` použijte příkaz `git am`. Příkaz `git am` je technicky koncipován tak, aby přečetl soubor mbox, tj. formát prostého textu pro ukládání jedné či více e-mailových zpráv do jednoho textového souboru. Vypadá například takto:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

Toto je začátek výstupu příkazu format-patch, s nímž jsme se setkali v předchozí části. Zároveň je to také platný e-mailový formát mbox. Jestliže vám přispěvatel řádně poslal záplatu e-mailem pomocí příkazu `git send-email` a vy záplatu stáhnete do formátu mbox, můžete na soubor mbox použít příkaz `git am`, který začne aplikovat všechny záplaty, které najde. Jestliže spustíte poštovního klienta, který dokáže uložit několik e-mailů ve formátu mbox, můžete do jednoho souboru uložit celou sérii záplat a příkazem `git am` je pak aplikovat všechny najednou.

Pokud však někdo nahrál soubor záplaty vygenerovaný příkazem `format-patch` do tiketového nebo podobného systému, můžete soubor uložit lokálně a poté na tento uložený soubor použít příkaz `git am`. Tímto způsobem záplatu aplikujete:

	$ git am 0001-limit-log-function.patch
	Applying: add limit to log function

Jak vidíte, záplata byla aplikována čistě a automaticky byla vytvořena nová revize. Informace o autorovi jsou převzaty z polí `From` a `Date` v e-mailu a zpráva k revizi je převzata z `Subject` a těla e-mailu (před samotnou záplatou). Pokud byl patch aplikován například ze souboru mbox v předchozím příkladu, vygenerovaná revize bude vypadat zhruba takto:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

Informace `Commit` uvádí osobu, která patch aplikovala, a čas, kdy se tak stalo. Informace `Author` naproti tomu označuje jedince, který patch původně vytvořil, a kdy tak učinil.

Může se ale stát, že záplata nebude aplikována čistě. Vaše hlavní větev se mohla příliš odchýlit od větve, z níž byla záplata vytvořena, nebo je záplata závislá na jiné záplatě, kterou jste ještě neaplikovali. V takovém případě proces `git am` neproběhne a Git se vás zeptá, co chcete udělat dál:

	$ git am 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

Tento příkaz vloží poznámku o konfliktu (conflict marker) do všech souborů, u nichž došlo k problémům, stejně jako u operací sloučení nebo přeskládání, při nichž došlo ke konfliktu. Problém se také řeší stejným způsobem. Úpravou souboru odstraňte konflikt, připravte nový soubor k zapsání a spusťte příkaz `git am --resolved`, jímž se přesunete k následující záplatě:

	$ (fix the file)
	$ git add ticgit.gemspec
	$ git am --resolved
	Applying: seeing if this helps the gem

Pokud chcete, aby se Git pokusil vyřešit konflikt inteligentněji, můžete zadat parametr `-3`. Git se pokusí o třícestné sloučení. Tato možnost není nastavena jako výchozí, protože ji nelze použít v situaci, kdy revize, o níž záplata říká, že je na ní založen, není obsažena ve vašem repozitáři. Pokud tuto revizi vlastníte – byla-li záplata založena na veřejné revizi – počíná si parametr `-3` při aplikaci kolidující záplaty většinou mnohem inteligentněji.

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

V tomto případě jsem se pokoušel aplikovat záplatu, kterou už jsem jednou aplikoval. Bez parametru `-3` se celá situace tváří jako konflikt.

Pokud aplikujete několik záplat z jednoho souboru mbox, můžete příkaz `am` spustit také v interaktivním režimu, který zastaví před každou záplatou, kterou najde, a zeptá se vás, zda ji chcete aplikovat:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

To oceníte v situaci, kdy máte uložených několik záplat. Pokud si nepamatujete, o co v dané záplatě šlo, můžete si ho před aplikací prohlédnout. Stejně tak vyloučíte záplaty, které jste už jednou aplikovali.

Až budete mít všechny záplaty aplikovány a zapsány do tematické větve, můžete se rozhodnout, zda a jak je chcete integrovat do některé z trvalejších větví.

### Checkout vzdálených větví ###

Pokud váš příspěvek pochází od uživatele systému Git, který založil vlastní repozitář, odeslal do něj sérii změn a následně vám poslal adresu URL k repozitáři a název vzdálené větve, v níž změny najdete, můžete je přidat jako vzdálené a lokálně je začlenit.

Pokud vám tedy například Jessica pošle e-mail, že vytvořila skvělou novou funkci ve větvi `ruby-client` ve svém repozitáři, můžete funkci otestovat tak, že přidáte větev jako vzdálenou a provedete její lokální checkout:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

Pokud vám později opět pošle e-mail, že jiná větev obsahuje další skvělou funkci, můžete tuto větev vyzvednout a provést její checkout, protože už máte nastaven tento repozitář jako vzdálený.

Tuto možnost využijete zejména tehdy, když s někým spolupracujete dlouhodobě. Má-li někdo jen jednu záplatu, jíž chce právě teď přispět, bude rychlejší, pokud vám záplatu doručí e-mailem, než abyste všechny vývojáře nutili provozovat kvůli pár záplatám vlastní servery a pravidelně přidávat a odstraňovat vzdálené repozitáře. Pravděpodobně také nebudete chtít mít nastaveny stovky vzdálených serverů, z nichž byste dostávali po jednom nebo dvou záplatách. Situaci vám mohou usnadnit skripty a hostované služby. Do velké míry tu záleží na tom, jak vy a vaši vývojáři k vývoji přistupujete.

Další výhodou tohoto postupu je, že získáte rovněž historii revizí. Přestože můžete mít oprávněné problémy se slučováním, víte, kde ve své historii můžete hledat příčiny. Řádné třícestné sloučení je vždy lepším řešením, než zadat parametr `-3` a doufat, že byl patch vygenerován z veřejné revize, k níž máte přístup.

Pokud s někým nespolupracujete dlouhodobě, ale přesto od něj chcete stáhnout data touto cestou, můžete zadat adresu URL vzdáleného repozitáře k příkazu `git pull`. Příkaz provede jednorázové stažení a nebude ukládat URL jako referenci na vzdálený repozitář:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Jak zjistit provedené změny ###

Nyní máte tematickou větev s prací, kterou jste obdrželi od jiného vývojáře. V tomto okamžiku můžete určit, jak s ní chcete naložit. V této části zopakujeme některé příkazy a podíváme se, jak je můžete použít, chcete-li zjistit, co přesně se stane, pokud novou práci začleníte do své hlavní větve.

Často může být užitečné získat přehled o všech revizích, které jsou obsaženy v určité větvi, ale dosud nejsou ve vaší hlavní větvi. Revize v hlavní větvi lze vyloučit vložením parametru `--not` před název větve. Pokud vám například přispěvatel pošle dvě záplaty a vy vytvoříte větev s názvem `contrib`, do níž tyto záplaty aplikujete, můžete použít tento příkaz:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

Chcete-li zjistit, jaké změny byly v jednotlivých revizích provedeny, můžete k příkazu `git log` přidat parametr `-p`, který ke každé revizi připojí rozdíly ve formátu diff.

Chcete-li vidět plný výpis diff, jak by vypadaly rozdíly, kdybyste tuto tematickou větev začlenili do jiné větve, můžete použít speciální trik, který vám zobrazí požadované informace. Můžete zadat následující příkaz:

	$ git diff master

Výstupem tohoto příkazu bude výpis diff, který však může být lehce matoucí. Jestliže se vaše větev `master` posunula vpřed od chvíle, kdy jste z ní vytvořili tematickou větev, budou výstupem příkazu zdánlivě nesmyslné výsledky. Je to z toho důvodu, že Git přímo srovnává snímky poslední revize v tematické větvi, na níž se nacházíte, se snímky poslední revize ve větvi `master`. Pokud jste například do souboru ve větvi `master` přidali jeden řádek, přímé srovnání snímků bude vypadat, jako by měla tematická větev tento řádek odstranit.

Pokud je větev `master` přímým předkem vaší tematické větve, nebude s příkazem žádný problém. Pokud se však obě historie v nějakém bodě rozdělily, bude výpis diff vypadat, jako byste chtěli přidat všechna nová data v tematické větvi a odstranit vše, co je pouze ve větvi `master`.

To, co chcete vidět ve skutečnosti, jsou změny přidané do tematické větve, práci, kterou provedete začleněním této větve do větve hlavní. Tohoto srovnání dosáhnete tak, že necháte Git porovnat poslední revizi ve vaší tematické větvi s prvním předkem, kterého má společného s hlavní větví.

Můžete tedy explicitně najít společného předka obou větví a spustit na něm příkaz diff:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db

To však není příliš pohodlný způsob, a proto Git nabízí jinou možnost, jak lze provést stejnou věc: trojtečkovou syntaxi. V kontextu příkazu `diff` můžete vložit tři tečky za druhou větev – získáte výpis `diff` mezi poslední revizí větve, na níž se nacházíte, a společným předkem s druhou větví:

	$ git diff master...contrib

Tento příkaz zobrazí pouze práci, která byla ve vaší aktuální tematické větvi provedena od chvíle, kdy se oddělila od hlavní větve. Určitě uděláte dobře, pokud si tuto syntaxi zapamatujete.

### Integrace příspěvků ###

Když už je práce v tematické větvi připravena a může být integrována do některé z významnějších větví, vyvstává otázka, jak to provést. A vůbec, jaký celkový pracovní postup zvolíte ke správě projektu? Existuje hned několik možností. Na některé z nich se můžeme podívat.

#### Pracovní postupy založené na slučování ####

Jeden jednoduchý pracovní postup začlení vaší práci do větve `master`. V tomto scénáři obsahuje vaše větev `master` převážně jen stabilní kód. Máte-li v tematické větvi práci, kterou jste vytvořili nebo kterou vám někdo doručil a vy jste ji schválili, začleníte ji do své hlavní větve, smažete tematickou větev a proces může pokračovat. Máme-li repozitář s prací ve dvou větvích pojmenovaných `ruby_client` a `php_client`, který vypadá jako na obrázku 5-19, a začleníme nejprve větev `ruby_client` a poté `php_client`, bude naše historie vypadat jako na obrázku 5-20.

Insert 18333fig0519.png
Obrázek 5-19. Historie s několika tematickými větvemi

Insert 18333fig0520.png
Obrázek 5-20. Po začlenění tematické větve

Jedná se patrně o nejjednodušší pracovní postup. Je však problematický, pokud ho používáme u velkých repozitářů nebo projektů.

Máte-li více vývojářů nebo větší projekt, pravděpodobně budete chtít použít přinejmenším dvoufázový cyklus začlenění. V tomto scénáři máte dvě dlouhodobé větve, hlavní větev `master` a větev `develop`. Určíte, že větev `master` bude aktualizována, pouze když je k dispozici velmi stabilní verze a do větve `develop` je integrován veškerý nový kód. Obě tyto větve pravidelně odesíláte do veřejného repozitáře. Pokaždé, když máte novou tematickou větev k začlenění (obrázek 5-21), začleníte ji do větve `develop` (obrázek 5-22). Když poté označujete vydání, posunete větev `master` rychle vpřed do místa, kde je nyní větev `develop` stabilní (obrázek 5-23).

Insert 18333fig0521.png
Obrázek 5-21. Před začleněním tematické větve

Insert 18333fig0522.png
Obrázek 5-22. Po začlenění tematické větve

Insert 18333fig0523.png
Obrázek 5-23. Po vydání tematické větve

Pokud někdo při tomto postupu klonuje repozitář vašeho projektu, může provést buď checkout hlavní větve, aby získal nejnovější stabilní verzi a udržoval ji aktuální, nebo checkout větve develop, která může být ještě o něco napřed.
Tento koncept můžete dále rozšířit o integrační větev, v níž budete veškerou práci slučovat. Teprve pokud je kód v této větvi stabilní a projde testováním, začleníte ho do větve develop. A až se větev develop ukáže v některém okamžiku jako stabilní, posunete rychle vpřed i svou hlavní větev.

#### Pracovní postupy se začleňováním velkého objemu dat ####

Váš projekt Git má čtyři trvalé větve: `master`, `next` a `pu` (proposed updates, tj. návrh aktualizací) pro novou práci a `maint` pro backporty správy. Pokud přispěvatelé vytvoří novou práci, je shromažďována v tematických větvích v repozitáři správce podobným způsobem, jaký už jsem popisoval (viz obrázek 5-24). Nyní budou tematické větve vyhodnoceny, zda jsou bezpečné a mohou být aplikovány, nebo zda potřebují další úpravy. Jsou-li vyhodnoceny jako bezpečné, budou začleněny do větve `next` a ta bude následně odeslána do repozitáře, aby mohli všichni vyzkoušet, jak fungují tematické větve po sloučení.

Insert 18333fig0524.png
Obrázek 5-24. Správa komplexní série současně zpracovávaných příspěvků v tematických větvích

Pokud ale tematické větve vyžadují další úpravy, budou začleněny do větve `pu`. Pokud se ukáže, že jsou tyto tematické větve naprosto stabilní, budou začleněny do větve `master` a poté budou znovu sestaveny z tematických větví, které byly ve větvi `next`, ale ještě se nedostaly do větve `master`. To znamená, že se větev `master` téměř neustále posouvá vpřed, větev `next` je čas od času přeskládána a větev `pu` je přeskládávána ještě o něco častěji (viz obrázek 5-25).

Insert 18333fig0525.png
Obrázek 5-25. Začlenění tematických větví s příspěvky do dlouhodobých integračních větví

Byla-li tematická větev konečně začleněna do větve `master`, může být odstraněna z repozitáře. Projekt Git má kromě toho větev `maint`, která byla odštěpena z posledního vydání a představuje záplaty backportované pro případ, že by bylo třeba vydat opravnou verzi. Pokud tedy klonujete repozitář Git, můžete stáhnout až čtyři větve, a hodnotit tak projekt na čtyřech různých úrovních vývoje. Záleží na vás, do jaké hloubky chcete proniknout nebo jak chcete přispívat. A správce projektu má k dispozici strukturovaný pracovní postup k evaluaci nových příspěvků.

#### Pracovní postupy s přeskládáním a částečným převzetím ####

Jiní správci dávají před začleněním práce z příspěvků přednost jejímu přeskládání nebo částečnému převzetí na vrchol hlavní větve, čímž udržují historii co nejlineárnější. Máte-li určitou práci v tematické větvi a rozhodli jste se, že ji integrujete, přejdete na tuto větev a spustíte příkaz rebase, jímž znovu sestavíte příslušné změny na vrcholu svojí aktuální hlavní větve (příp. větve `develop` apod.). Pokud vše funguje, můžete větev `master` posunout rychle vpřed a výsledkem procesu bude lineární historie projektu.

Druhým způsobem, jak přesunout práci z jedné větve do druhé, je tzv. částečné převzetí (angl. cherry picking, tedy něco jako „vyzobání třešniček“). Částečné převzetí lze v systému Git přirovnat k přeskládání jedné revize. Při této operaci vezme systém záplatu, která byla provedena v dané revizi, a pokusí se ji znovu aplikovat na větev, na níž se právě nacházíte. To využijete například v situaci, kdy máte několik revizí v tematické větvi, ale chcete integrovat pouze jednu z nich. Částečné převzetí však můžete použít i místo přeskládání, pokud máte v tematické větvi pouze jednu revizi. Uvažujme tedy projekt, který vypadá jako na obrázku 5-26.

Insert 18333fig0526.png
Obrázek 5-26. Uvažovaná historie před částečným převzetím

Chcete-li do hlavní větve natáhnout revizi `e43a6`, můžete zadat následující příkaz:

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

Tímto natáhnete stejnou změnu, která byla provedena revizí `e43a6`, avšak hodnota SHA-1 obou revizí se bude lišit, neboť bude rozdílné datum aplikace. Vaše historie revizí bude nyní vypadat jako na obrázku 5-27.

Insert 18333fig0527.png
Obrázek 5-27. Historie po částečném převzetí revize z tematické větve

Nyní můžete tematickou větev odstranit a zahodit revize, které nehodláte natáhnout do jiné větve.

### Označení vydání značkou ###

Až se rozhodnete vydat určitou verzi, pravděpodobně ji budete chtít označit značkou, abyste mohli toto vydání v kterémkoli okamžiku v budoucnosti obnovit. Novou značku vytvoříte podle návodu v kapitole 2. Pokud se rozhodnete podepsat značku jako správce, bude označení probíhat takto:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Pokud své značky podepisujete, můžete mít problémy s distribucí veřejného klíče PGP použitého k podepsání značky. Správce projektu Git vyřešil tento problém tak, že přidal svůj veřejný klíč jako blob do repozitáře a poté vložil značku, která ukazuje přímo na tento obsah. Pomocí příkazu `gpg --list-keys` můžete určit, jaký klíč chcete:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Poté můžete klíč přímo importovat do databáze Git: vyexportujte ho a použijte příkaz `git hash-object`, který zapíše nový blob s tímto obsahem do systému Git a vrátí vám otisk SHA-1 tohoto blobu:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Nyní máte obsah svého klíče v systému Git a můžete vytvořit značku, která bude ukazovat přímo na něj. Zadejte proto novou hodnotu SHA-1, kterou jste získali příkazem `hash-object`:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Zadáte-li příkaz `git push --tags`, začnete značku `maintainer-pgp-pub` sdílet s ostatními. Bude-li chtít značku kdokoli ověřit, může přímo importovat váš klíč PGP tak, že stáhne blob z databáze a naimportuje ho do programu GPG:

	$ git show maintainer-pgp-pub | gpg --import

Klíč pak může použít k ověření všech vašich podepsaných značek. Pokud navíc zadáte do zprávy značky další instrukce k jejímu ověření, může si je koncový uživatel zobrazit příkazem `git show <tag>`.

### Vygenerování čísla sestavení ###

Git nepoužívá pro jednotlivé revize monotónně rostoucí čísla („v123“ apod.), a proto možná rádi využijete příkaz `git describe`, jímž lze každé revizi přiřadit běžně zpracovatelný název. Git vám poskytne název nejbližší značky s počtem revizí na vrcholu této značky a část hodnoty SHA-1 revize, k níž se popis vztahuje:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

Díky tomu lze snímek nebo sestavení (build) vyexportovat a přiřadit mu pro člověka srozumitelný název. Pokud sestavujete Git ze zdrojového kódu naklonovaného z repozitáře Git, získáte po spuštění příkazu `git --version` něco, co vypadá zhruba podobně. Zadáváte-li popis revize, kterou jste právě opatřili značkou, dostanete název této značky.

Příkaz `git describe` upřednostňuje anotované značky (značky vytvořené s příznakem `-a` nebo `-s`). Pokud tedy používáte příkaz `git describe`, abyste se při vytváření popisu ujistili, že je revize pojmenována správně, měli byste značky jednotlivých vydání vytvářet tímto způsobem. Tento řetězec můžete také použít jako cíl příkazu checkout nebo show, ačkoli ty pracují se zkrácenou hodnotou SHA-1, a tak nebudou platné navždy. Například jádro Linuxu nyní přešlo z 8 na 10 znaků, aby byla zajištěna jedinečnost objektů SHA-1. Starší výstupy příkazu `git describe` proto už nebudou platné.

### Příprava vydání ###

Nyní budete chtít sestavení vydat. Jednou z věcí, kterou budete chtít udělat, je vytvoření archivu nejnovějšího snímku vašeho kódu pro všechny nebohé duše, které nepoužívají systém Git. Příkaz pro vytvoření archivu zní `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

Až někdo tento tarball otevře, získá nejnovější snímek vašeho projektu v projektovém adresáři. Stejným způsobem můžete vytvořit také archiv zip. K příkazu `git archive` stačí přidat parametr `--format=zip`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Nyní máte vytvořen tarball a archiv zip k vydání svého projektu, které můžete nahrát na svou webovou stránku nebo rozeslat e-mailem.

### Příkaz „shortlog“ ###

Nyní je na čase obeslat e-mailem poštovní konferenci lidí, kteří chtějí vědět, co je ve vašem projektu nového. Elegantním způsobem, jak rychle získat určitý druh záznamu o změnách (changelog), které byly do projektu přidány od posledního vydání nebo e-mailu, je použít příkaz `git shortlog`. Příkaz shrne všechny revize v zadaném rozmezí. Například následující příkaz zobrazí shrnutí všech revizí od posledního vydání (pokud bylo vaše poslední vydání pojmenováno v1.0.1):

	$ git shortlog --no-merges master --not v1.0.1
	Chris Wanstrath (8):
	      Add support for annotated tags to Grit::Tag
	      Add packed-refs annotated tag support.
	      Add Grit::Commit#to_patch
	      Update version and History.txt
	      Remove stray `puts`
	      Make ls_tree ignore nils

	Tom Preston-Werner (4):
	      fix dates in history
	      dynamic version method
	      Version bump to 1.0.2
	      Regenerated gemspec for version 1.0.2

Výstupem příkazu je čisté shrnutí všech revizí od v1.0.1, seskupené podle autora, kterého můžete přidat do e-mailu své konference.

## Shrnutí ##

V tomto okamžiku byste tedy už měli hravě zvládat přispívání do projektů v systému Git, správu vlastního projektu i integraci příspěvků jiných uživatelů. Gratulujeme, nyní je z vás efektivní vývojář v systému Git! V další kapitole poznáte další výkonné nástroje a tipy k řešení složitých situací, které z vás udělají opravdového mistra mezi uživateli systému Git.
