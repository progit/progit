# Git na serveru #

V této chvíli byste už měli zvládat většinu každodenních úkonů, pro něž se vyplatí Git používat. Abyste však mohli v systému Git spolupracovat s ostatními, budete potřebovat vzdálený repozitář Git. Technicky vzato sice můžete odesílat a stahovat změny z repozitářů jednotlivých spolupracovníků, tento postup ale nedoporučujeme, protože se může při troše neopatrnosti velmi snadno stát, že zapomenete, kdo na čem pracuje. Navíc chcete, aby měli vaši spolupracovníci do repozitáře přístup, i když je váš počítač vypnutý nebo odpojený – na společný repozitář bývá často lepší spolehnutí. Jako nejlepší metodu spolupráce s ostatními proto můžeme doporučit nastavení „neutrálního“ repozitáře, do nějž budete mít všichni přístup, budete do něj moci odesílat data a budete z něj moci stahovat. Tomuto repozitáři budeme říkat „gitový server“. Jak ale zjistíte, nebývá hostování gitového repozitáře nijak zvlášť náročné na zdroje, a tak nejspíš nebudete potřebovat celý server.

Zprovoznění gitového serveru je jednoduché. Nejprve určíte, jakými protokoly má váš server komunikovat. První část této kapitoly se bude věnovat možným protokolům, jejich přednostem a nevýhodám. V dalších částech popíšeme některá typická nastavení pro použití těchto protokolů, a jak s nimi uvést server do provozu. Nakonec se podíváme na několik možností hostování pro případ, že nebudete mít chuť podstupovat martyrium s nastavováním a správou vlastního serveru a nevadí vám umístit svůj kód na cizí server.

Pokud víte, že nebudete chtít spravovat vlastní server, můžete přeskočit rovnou na poslední část této kapitoly a podívat se na možnosti nastavení hostovaného účtu. Pak přejděte na následující kapitolu, v níž se dočtete o detailech a záludnostech při práci v prostředí s distribuovanou správou zdrojového kódu.

Vzdálený repozitář je obvykle *holý repozitář* (bare repository), tj. gitový repozitář bez pracovního adresáře. Protože se repozitář používá pouze jako místo pro spolupráci, není žádný důvod, aby byl na disku načten konkrétní snímek. Jsou tu pouze uložena data systému Git. Jednoduše bychom mohli také říct, že holý repozitář je obsah adresáře `.git` vašeho projektu a nic víc.

## Protokoly ##

Git může k přenosu dat používat jeden ze čtyř hlavních síťových protokolů: Local, Secure Shell (SSH), Git nebo HTTP. V této části se podíváme na to, co jsou jednotlivé protokoly zač a za jakých okolností je (ne)vhodné je použít.

Neměli bychom zamlčet ani to, že s výjimkou protokolu HTTP všechny vyžadují, aby byl na serveru nainstalován a zprovozněn systém Git.

### Lokální protokol ###

Nejzákladnější variantou je *lokální protokol* (Local protocol), v němž je vzdálený repozitář uložen v jiném adresáři na disku. Často se využívá v případech, kdy mají všichni z vašeho týmu přístup k vašim sdíleným souborům, např. přes připojení systému NFS, nebo – v méně pravděpodobném případě – se všichni přihlašují na jednom počítači. Tato druhá varianta není právě ideální, protože všechny instance repozitáře s kódem jsou v takovém případě umístěny v jednom počítači, čímž se zvyšuje riziko nevratné ztráty dat.

Máte-li připojený sdílený systém souborů, můžete klonovat, odesílat a stahovat z lokálního souborového repozitáře (local file-based repository). Chcete-li takový repozitář naklonovat nebo přidat jako vzdálený repozitář do existujícího projektu, použijte jako URL cestu k repozitáři. K naklonování lokálního repozitáře můžete použít příkaz například v tomto tvaru:

	$ git clone /opt/git/project.git

Nebo můžete provést následující:

	$ git clone file:///opt/git/project.git

Pokud na začátek URL explicitně zadáte výraz `file://`, pracuje Git trochu jinak. Pokud pouze zadáte cestu a zdroj i cíl se nacházejí ve stejném systému souborů, pokusí se Git použít hardlinky na potřebné objekty. Pokud se nenacházejí ve stejném systému souborů, dojde k okopírování potřebných objektů pomocí standardních prostředků systému pro kopírování. Pokud zadáte výraz `file://`, Git spustí procesy, jež běžně používá k přenosu dat prostřednictvím sítě. Síť je většinou výrazně méně výkonnou metodou přenosu dat. Hlavním důvodem, proč zadat předponu `file://` je to, že tak získáte čistou kopii repozitáře bez nepotřebných referencí a objektů, například po importu z jiného verzovacího systému a podobně (úkony správy jsou popsány v kapitole 9). My budeme používat normální cestu, neboť tato metoda je téměř vždy rychlejší.

K přidání lokálního repozitáře do existujícího projektu Git můžete použít příkaz například v tomto tvaru:

	$ git remote add local_proj /opt/git/project.git

Poté můžete odesílat data a stahovat je z tohoto vzdáleného serveru, jako byste tak činili prostřednictvím sítě.

#### Výhody ####

Výhoda souborových repozitářů spočívá v tom, že jsou jednoduché a používají existující oprávnění k souborům a síťový přístup. Pokud už máte sdílený systém souborů, k němuž má přístup celý váš tým, je nastavení repozitáře velice jednoduché. Kopii holého repozitáře umístíte někam, kam mají všichni sdílený přístup, a nastavíte oprávnění ke čtení/zápisu stejně jako u jakéhokoli jiného sdíleného adresáře. O exportu kopie holého repozitáře pro tento účel se více dočtete v následující části „Jak umístit Git na server“.

Jedná se také o výbornou možnost, jak rychle získat práci z pracovního repozitáře někoho jiného. Pokud vy a váš kolega pracujete na společném projektu a vy potřebujete provést checkout kolegových dat, bývá například příkaz `git pull /home/john/project` jednodušší než odesílat data na vzdálený server a odsud je opět stahovat.

#### Nevýhody ####

Nevýhodou této metody je, že nastavit a získat sdílený přístup z více umístění je většinou těžší než obyčejný síťový přístup. Budete-li chtít pracovat doma a odeslat data z notebooku, budete muset připojit vzdálený disk, což může být ve srovnání s přístupem prostřednictvím sítě složité a pomalé.

Zapomenout bychom neměli ani na to, že používáte-li sdílené připojení určitého druhu, nemusí být tato možnost vždy nutně nejrychlejší. Lokální repozitář je rychlý pouze v případě, že máte rychlý přístup k datům. Repozitář na NFS je často pomalejší než stejný repozitář nad SSH na tomtéž serveru, který ve všech systémech umožňuje spustit Git z lokálních disků.

### Protokol SSH ###

Patrně nejčastějším přenosovým protokolem pro systém Git je SSH. Je to z toho důvodu, že SSH přístup k serverům je na většině míst už nastaven, a pokud ne, není ho těžké nastavit. SSH je navíc jediným síťovým protokolem, z nějž lze snadno číst a do nějž lze snadno zapisovat. Oba zbývající síťové protokoly (HTTP i Git) jsou většinou určeny pouze ke čtení, a proto i když je dáváte k dispozici ostatním, pro sebe budete potřebovat SSH protokol pro příkazy zápisu. SSH je také síťovým protokolem s autentizací, a protože je hojně rozšířen, je jeho nastavení a používání většinou snadné.

Chcete-li naklonovat repozitář Git pomocí protokolu SSH, zadejte `ssh://` URL, například:

	$ git clone ssh://user@server/project.git

Nebo můžete pro SSH protokol použít kratší zápis jako u scp:

	$ git clone user@server:project.git

Stejně tak nemusíte zadávat ani uživatele, Git automaticky použije uživatele, jehož účtem jste právě přihlášeni.

#### Výhody ####

Používání protokolu SSH přináší mnoho výhod. Především byste ho měli používat vždy, když chcete v síti používat autentizovaný zápis do repozitáře. Zadruhé: protokol SSH se snadno nastavuje – SSH démoni jsou zcela běžní, správci sítě si s nimi většinou vědí rady a mnoho distribucí OS je má ve výchozí instalaci nebo poskytuje nástroje pro jejich správu. Z dalších výhod bychom měli zmínit také to, že přístup přes protokol SSH je bezpečný, veškerý přenos dat je šifrovaný a autentizovaný. A stejně jako protokoly Git a Local je i protokol SSH výkonný, protože data jsou před přenosem upravena do co nejkompaktnější podoby.

#### Nevýhody ####

Nevýhodou protokolu SSH je, že neumožňuje anonymní přístup do repozitáře. Chce-li někdo získat přístup do vašeho repozitáře, byť třeba jen ke čtení, musí mít přístup k vašemu počítači přes SSH. Proto se protokol SSH nehodí pro projekty s otevřeným zdrojovým kódem. Pokud repozitář používáte jen v rámci firemní sítě, bude pro vás protokol SSH zřejmě naprosto ideální. Pokud chcete povolit anonymní přístup pro čtení k vašim projektům, budete muset nastavit protokol SSH k odesílání svých dat, ale musíte přidat i jiný protokol, který budou ostatní používat pro stahování.

### Protokol Git ###

Dalším protokolem v pořadí je protokol Git. Je to speciální démon, který je distribuován spolu se systémem Git. Naslouchá na vyhrazeném portu (9418) a poskytuje podobnou službu jako protokol SSH, avšak bez jakékoliv autentizace. Chcete-li, aby byl repozitář zpřístupněn protokolem Git, musíte vytvořit soubor `git-daemon-export-ok`. Bez tohoto souboru nebude repozitář démonem zpřístupněn. Žádné jiné zabezpečení ale k dispozici není. Repozitář Git je buď dostupný pro všechny a všichni z něj mohou klonovat, nebo dostupný není. To znamená, že se přes tento protokol nedají odesílat žádné revize. Možnost odesílání lze zapnout, ale vzhledem k tomu, že protokol neumožňuje autentizaci, aktivované odesílání znamená, že kdokoli na internetu, kdo najde URL vašeho projektu, do něj bude moci odesílat data. Je jasné, že to většinou nechcete.

#### Výhody ####

Protokol Git je ze všech dostupných protokolů nejrychlejší. Potřebujete-li, aby protokol obsluhoval frekventovaný provoz u veřejného projektu nebo velmi velký projekt, u nějž není třeba ověřování identity uživatele ohledně oprávnění pro čtení, bude k obsluze nejvhodnější pravděpodobně právě démon Git. Používá stejný mechanismus přenosu dat jako protokol SSH, na rozdíl od něj ale není zpomalován šifrováním a ověřováním identity (autentizací).

#### Nevýhody ####

Nevýhodou protokolu Git je, že neprovádí autentizaci. Většinou není žádoucí, aby protokol Git tvořil jediný přístup k vašemu projektu. Protokol Git většinou využijete v kombinaci s přístupem přes SSH. Protokol SSH bude nastaven pro několik málo vývojářů s oprávněním k zápisu (odesílání dat) a všichni ostatní budou používat `git://` pro přístup pouze ke čtení.
Pravděpodobně se také jedná o protokol s nejobtížnějším nastavením. Vyžaduje spuštění vlastního démona – na jeho nastavení se podíváme v části „Gitosis“ této kapitoly – a dále konfiguraci `xinetd` nebo podobnou, což není zrovna procházka růžovou zahradou. Vyžaduje rovněž povolení přístupu k portu 9418 skrz firewall. Tento port nepatří mezi standardní porty, které by firemní firewally vždy povolovaly. Velkými podnikovými firewally je tento málo rozšířený port většinou blokován.

### Protokol HTTP/S ###

Na konec jsme si nechali protokol HTTP. Co je na protokolu HTTP nebo HTTPS sympatické, je jejich jednoduché nastavení. Jediné, co většinou stačí udělat, je umístit holý repozitář Git do kořenového adresáře HTTP a nastavit příslušný zásuvný modul `post-update` (zásuvné moduly Git viz kapitola 7). Tím je nastavení hotové. V tuto chvíli může každý, kdo má přístup na webový server, kam jste repozitář uložili, tento repozitář naklonovat. Chcete-li u svého repozitáře nastavit oprávnění pro čtení pomocí protokolu HTTP, proveďte následující:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

A to je vše. Zásuvný modul `post-update`, který je standardně součástí systému Git, spustí příslušný příkaz (`git update-server-info`), který zajistí správné vyzvedávání a klonování dat přes protokol HTTP. Tento příkaz se spustí, když do tohoto repozitáře odesíláte data přes protokol SSH. Poté mohou ostatní klonovat třeba takto:

	$ git clone http://example.com/gitproject.git

V tomto konkrétním případě používáme cestu `/var/www/htdocs`, která je obvyklá u nastavení Apache, ale použít lze v podstatě jakýkoli statický webový server – stačí uložit holý repozitář do dané cesty. Data repozitáře Git jsou obsluhována jako obyčejné statické soubory (podrobnosti o přesném způsobu obsluhy naleznete v kapitole 9).

Odesílat data do repozitáře Git je možné také přes protokol HTTP, avšak tento způsob není příliš rozšířený a vyžaduje nastavení komplexních požadavků protokolu WebDAV. Protože se tato možnost využívá zřídka, nebudeme se jí v této knize věnovat. Pokud vás zajímá používání protokolů HTTP k odesílání dat, více se o přípravě repozitáře k tomuto účelu dočtete na adrese: `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` (anglicky). Příjemným faktem na odesílání dat přes protokol HTTP je, že můžete použít jakýkoli server WebDAV i bez speciálních funkcí systému Git. Tuto možnost tak můžete využít, pokud váš poskytovatel webhostingu podporuje WebDAV pro zápis aktualizací na vaše webové stránky.

#### Výhody ####

Pro používání protokolu HTTP mluví zejména jeho snadné nastavení. Vystačíte s několika málo příkazy, ale získáte jednoduchý způsob, jak nastavit oprávnění pro čtení repozitáře Git pro okolní svět. Celý postup nezabere víc než pár minut. Protokol HTTP navíc jen minimálně omezuje zdroje serveru. Vzhledem k tomu, že k obsluze všech dat používá většinou statický HTTP server, obslouží běžný server Apache průměrně několik tisíc souborů za sekundu. Ani malý server proto není snadné přetížit.

Své repozitáře můžete zpřístupnit ke čtení prostřednictvím protokolu HTTPS, což znamená, že se přenášený obsah šifruje. Nebo můžete zajít ještě dál a vyžadovat, aby klienti používali konkrétní podepsané SSL certifikáty. Je pravda, že v takovém případě by už bylo jednodušší použít veřejné SSH klíče, ale ve vašem konkrétním případě může být použití podepsaných SSL certifikátů nebo jiné ověření identity na základě protokolu HTTP lepší metodou, jak zajistit přístup přes HTTPS pouze ke čtení.

Z dalších výhod protokolu HTTP bychom mohli jmenovat i jeho značné rozšíření, díky čemuž jsou firemní firewally často nastaveny tak, že umožňují provoz přes standardní port protokolu HTTP.

#### Nevýhody ####

Nevýhodou obsluhy repozitáře přes protokol HTTP je poměrně nízká výkonnost pro klienta. Klonovat nebo vyzvedávat data z repozitáře trvá v případě protokolu HTTP obecně mnohem déle a vyžádá si většinou podstatně větší režii síťových operací a objem přenášených dat, než je tomu u ostatních síťových protokolů. Protože protokol není natolik inteligentní, aby přenášel pouze data, která potřebujete – v těchto transakcích se na straně serveru nesetkáte s dynamickou činností – je protokol HTTP často nazýván *dumb protocol* (hloupý protokol). Více informací o rozdílech ve výkonnosti mezi protokolem HTTP a ostatními protokoly najdete v kapitole 9.

## Jak umístit Git na server ##

Pro úvodní nastavení serveru Git je třeba exportovat existující repozitář do nového, holého repozitáře (bare repository), tj. do repozitáře, který neobsahuje pracovní adresář. S tím obvykle nebývá problém.
Chcete-li naklonovat stávající repozitář, a vytvořit tak nový a holý, zadejte příkaz pro klonování s parametrem `--bare`. Je zvykem, že adresáře s holým repozitářem končí na `.git`, například:

	$ git clone --bare my_project my_project.git
	Cloning into bare repository 'my_project.git'...
	done.

V adresáři `my_project.git` byste nyní měli mít kopii dat z adresáře Git.

Je to přibližně stejné, jako byste zadali například:

	$ cp -Rf my_project/.git my_project.git

Bude tu sice pár menších rozdílů v konfiguračním souboru, ale pro náš účel můžeme příkazy považovat za ekvivalentní. Oba vezmou samotný repozitář Git (bez pracovního adresáře) a vytvoří pro něj samostatný adresář.

### Umístění holého repozitáře na server ###

Nyní, když máte vytvořenu holou kopii repozitáře, zbývá ji už jen umístit na server a nastavit protokoly. Řekněme, že jste nastavili server nazvaný `git.example.com`, k němuž máte SSH přístup, a všechny svoje repozitáře Git chcete uložit do adresáře `/opt/git`. Nový repozitář můžete nastavit zkopírováním holého repozitáře příkazem:

	$ scp -r my_project.git user@git.example.com:/opt/git

V tomto okamžiku mohou všichni ostatní, kdo mají SSH přístup k tomuto serveru s oprávněním pro čtení k adresáři `/opt/git`, naklonovat váš repozitář příkazem:

	$ git clone user@git.example.com:/opt/git/my_project.git

Pokud se uživatel dostane přes SSH na server a má oprávnění k zápisu do adresáře `/opt/git/my_project.git`, má automaticky také oprávnění k odesílání dat. Zadáte-li příkaz `git init` s parametrem `--shared`, Git automaticky nastaví příslušná oprávnění skupiny k zápisu.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Vidíte, jak je jednoduché vzít repozitář Git, vytvořit jeho holou verzi a umístit ji na server, k níž máte vy i vaši spolupracovníci SSH přístup. Nic vám teď nebrání začít spolupracovat na projektu.

A to je skutečně vše, co je třeba ke spuštění serveru Git, k němuž bude mít přístup více lidí – na server stačí přidat SSH účty a umístit holý repozitář někam, kam budou mít všichni uživatelé oprávnění ke čtení i zápisu. Vše je připraveno, nic dalšího se od vás nevyžaduje.

V dalších částech se podíváme na některé pokročilé možnosti nastavení. Dozvíte se v nich, jak se vyhnout nutnosti vytvářet uživatelské účty pro všechny uživatele, jak k repozitářům přiřadit veřejné oprávnění pro čtení, jak nastavit webová rozhraní nebo k čemu se používá nástroj Gitosis. To však nemění nic na tom, že ke spolupráci se skupinou lidí na soukromém projektu *vystačíte* s jedním SSH serverem a holým repozitářem.

### Nastavení pro malou skupinu ###

Pokud provádíte nastavení jen pro malý okruh lidí nebo jen zkoušíte Git ve své organizaci a nemáte mnoho vývojářů, mnoho věcí pro vás bude jednodušších. Jedním z nejsložitějších aspektů nastavení serveru Git je totiž správa uživatelů. Pokud chcete, aby byly určité repozitáře pro některé uživatele pouze ke čtení a pro jiné i k zápisu, může být nastavení přístupu a oprávnění poměrně náročné.

#### SSH přístup ####

Jestliže už máte server, k němuž mají všichni vaši vývojáři SSH přístup, bude většinou nejjednodušší nastavit první repozitář tam, protože celé nastavení už tím máte v podstatě hotové (jak jsme ukázali v předchozí části). Pokud chcete pro své repozitáře nastavit komplexnější správu oprávnění, můžete je opatřit běžnými oprávněními k systému souborů, které vám nabízí operační systém daného serveru.

Pokud chcete své repozitáře umístit na server, jenž nemá účty pro všechny členy vašeho týmu, kteří by měli mít oprávnění k zápisu, musíte pro ně nastavit SSH přístup. Předpokládáme, že pokud máte server, na němž to lze provést, máte už nainstalován server SSH a jeho prostřednictvím k serveru přistupujete.

Existuje několik způsobů, jak umožnit přístup všem členům vašeho týmu. Prvním způsobem je nastavit účty pro všechny, což je sice přímočaré, ale může to být poněkud zdlouhavé. Možná nebudete mít chuť spouštět příkaz `adduser` (přidat uživatele) a nastavovat pro každého uživatele dočasná hesla.

Druhým způsobem je vytvořit na počítači jediného uživatele 'git', požádat všechny uživatele, kteří mají mít oprávnění k zápisu, aby vám poslali veřejný SSH klíč, a přidat tento klíč do souboru `~/.ssh/authorized_keys` vašeho nového uživatele 'git'. Nyní budou mít všichni přístup k tomuto počítači prostřednictvím uživatele 'git'. Tento postup nemá žádný vliv na data vašich revizí – SSH uživatel, jehož účtem se přihlašujete, neovlivní revize, které jste nahráli.

Dalším možným způsobem je nechat ověřovat SSH přístupy LDAP serveru nebo jinému centralizovanému zdroji ověření, který už možná máte nastavený. Dokud má každý uživatel shellový přístup k počítači, měly by fungovat všechny mechanismy ověřování SSH, které vás jen napadnou.

## Vygenerování veřejného SSH klíče ##

Mnoho serverů Git provádí ověřování totožnosti pomocí veřejných SSH klíčů. Aby vám mohli všichni uživatelé ve vašem systému poskytnout veřejný klíč, musí si ho každý z nich nechat vygenerovat (pokud klíč ještě nemá). Tento proces se napříč operačními systémy téměř neliší.
Nejprve byste se měli ujistit, že ještě žádný klíč nemáte. Uživatelské SSH klíče jsou standardně uloženy v adresáři `~/.ssh` daného uživatele. Nejsnazší způsob kontroly, zda už klíč vlastníte, je přejít do tohoto adresáře a zjistit jeho obsah:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Zobrazí se několik souborů s názvem `xxx` a `xxx.pub`, kde `xxx` je většinou `id_dsa` nebo `id_rsa`. Soubor `.pub` je váš veřejný klíč, druhý soubor je soukromý klíč. Pokud tyto soubory nemáte (nebo dokonce vůbec nemáte adresář `.ssh`), můžete si je vytvořit. Spusťte program `ssh-keygen`, který je v systémech Linux/Mac součástí balíčku SSH a v systému Windows součástí balíčku MSysGit:

	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Program nejprve potvrdí, kam chcete klíč uložit (`.ssh/id_rsa`), a poté se dvakrát zeptá na přístupové heslo. Pokud nechcete při používání klíče zadávat heslo, můžete ho nyní nechat prázdné.

Každý uživatel, který si tímto způsobem nechá vygenerovat veřejný klíč, ho nyní pošle vám nebo jinému správci serveru Git (za předpokladu, že používáte nastavení SSH serveru vyžadující veřejné klíče). Stačí přitom zkopírovat obsah souboru `.pub` a odeslat ho e-mailem. Veřejné klíče mají zhruba tuto podobu:

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Budete-li potřebovat podrobnější návod k vytvoření SSH klíče v různých operačních systémech, můžete se na vytváření SSH klíčů podívat do příručky GitHub: `http://github.com/guides/providing-your-ssh-key` (anglicky).

## Nastavení serveru ##

Projděme si nastavení SSH přístupu na straně serveru. V tomto příkladu použijeme k ověření identity uživatelů metodu `authorized_keys`. Předpokládáme také, že pracujete se standardní linuxovou distribucí, jako je např. Ubuntu. Nejprve vytvoříte uživatele 'git' a adresář `.ssh` pro tohoto uživatele.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

V dalším kroku musíte vložit veřejné SSH klíče od svých vývojářů do souboru `authorized_keys` pro tohoto uživatele. Předpokládejme, že jste e-mailem dostali několik klíčů a uložili jste je do dočasných souborů. Veřejné klíče vypadají opět nějak takto:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Vy nyní klíče přidáte do souboru `authorized_keys`:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Autentizace vůči SSH, která je založená na klíči, obvykle vynucuje zvýšenou bezpečnost tím, že pro zúčastněné soubory vyžaduje omezená oprávnění. Aby SSH neodmítl pracovat, napište následující:

	$ chmod -R go= ~/.ssh

Nyní pro ně můžete nastavit prázdný repozitář. Spusťte příkaz `git init` s parametrem `--bare`, který inicializuje repozitář bez pracovního adresáře:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

John, Josie a Jessica pak mohou do tohoto repozitáře odeslat první verzi svého projektu: přidají si ho jako vzdálený repozitář a odešlou do něj svou větev. Nezapomeňte, že pokaždé, když chcete vytvořit projekt, musí se k počítači někdo přihlásit a vytvořit holý repozitář. Pro server, na kterém jste nastavili uživatele 'git' a repozitář, můžeme použít název hostitele `gitserver`. Pokud server provozujete interně a nastavíte DNS pro `gitserver` tak, aby ukazovalo na tento server, můžete používat i takovéto příkazy:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Ostatní nyní mohou velmi snadno repozitář naklonovat i do něj odesílat změny:

	$ git clone git@gitserver:/opt/git/project.git
	$ cd project
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Tímto způsobem lze rychle vytvořit a spustit server Git ke čtení i zápisu pro menší počet vývojářů.

Pro větší bezpečnost máte možnost využít nástroj `git-shell`, který je distribuován se systémem Git. Pomocí něj lze uživatele 'git' snadno omezit tak, aby mohl prováděl pouze operace systému Git. Pokud ho nastavíte jako přihlašovací shell uživatele 'git', pak nebude mít uživatel 'git' normální shellový přístup k vašemu serveru. Chcete-li nástroj použít, zadejte pro přihlašovací shell vašeho uživatele `git-shell` místo bash nebo csh. V takovém případě pravděpodobně budete muset upravit soubor `/etc/passwd`:

	$ sudo vim /etc/passwd

Dole byste měli najít řádek, který vypadá asi takto:

	git:x:1000:1000::/home/git:/bin/sh

Změňte `/bin/sh` na `/usr/bin/git-shell` (nebo spusťte příkaz `which git-shell`, abyste viděli, kde je nainstalován). Řádek by měl vypadat takto:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Uživatel 'git' nyní může používat SSH připojení k odesílání a stahování repozitářů Git, ale nemůže se přihlásit k počítači. Pokud to zkusíte, zobrazí se zamítnutí přihlášení:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Veřejný přístup ##

A co když chcete u svého projektu nastavit anonymní oprávnění pro čtení? Nehostujete třeba interní soukromý projekt, ale „open source“ projekt. Nebo možná máte několik serverů průběžné integrace, které se neustále mění a vy nechcete stále generovat SSH klíče. Rádi byste vždy přidali jen obyčejné anonymní oprávnění pro čtení.

Patrně nejjednodušším způsobem pro menší týmy je spustit statický webový server s kořenovým adresářem dokumentů, v němž budou uloženy vaše Git repozitáře, a zapnout zásuvný modul `post-update`, o kterém jsme se zmínili už v první části této kapitoly. Můžeme pokračovat v našem předchozím příkladu. Řekněme, že máte repozitáře uloženy v adresáři `/opt/git` a na vašem počítači je spuštěn server Apache. Opět, můžete použít jakýkoli webový server. Pro názornost ale ukážeme některá základní nastavení serveru Apache, abyste získali představu, co vás může čekat.

Nejprve ze všeho budete muset zapnout zásuvný modul:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Jaká je funkce zásuvného modulu `post-update`? V principu vypadá asi takto:

	$ cat .git/hooks/post-update
	#!/bin/sh
	#
	# An example hook script to prepare a packed repository for use over
	# dumb transports.
	#
	# To enable this hook, rename this file to "post-update".
	#

	exec git-update-server-info

Znamená to, že až budete odesílat data na server prostřednictvím SSH, Git spustí tento příkaz a aktualizuje soubory vyžadované pro přístup přes HTTP.

Dále je třeba přidat záznam VirtualHost do konfigurace Apache s kořenovým adresářem dokumentů nastaveným jako kořenový adresář vašich projektů Git. Tady předpokládáme, že máte nastaveny zástupné znaky DNS (wildcard DNS) a můžete odeslat `*.gitserver` do kteréhokoli boxu, který používáte, a spustit následující:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Budete také muset nastavit uživatelskou skupinu adresáře `/opt/git` na `www-data`. Váš webový server tak získá přístup pro čtení k repozitářům, protože instance Apache, která spouští CGI skript, bude (standardně) spuštěna s tímto uživatelem:

	$ chgrp -R www-data /opt/git

Po restartování serveru Apache byste měli být schopni naklonovat své repozitáře v tomto adresáři. Zadejte adresu URL svého projektu:

	$ git clone http://git.gitserver/project.git

Tímto způsobem můžete během pár minut nastavit oprávnění pro čtení založené na protokolu HTTP pro větší počet uživatelů k jakémukoli svému projektu. Další jednoduchou možností nastavení veřejného neověřovaného přístupu je spustit démona Git. Pokud je pro vás tato cesta schůdnější, budeme se jí věnovat v následující části.

## GitWeb ##

Nyní, když máte ke svému projektu nastavena základní oprávnění pro čtení/zápis a pouze pro čtení, možná budete chtít nastavit jednoduchou online vizualizaci. Git vám nabízí CGI skript s názvem GitWeb, který se k tomuto účelu běžně používá. V činnosti můžete GitWeb pozorovat například na stránkách `http://git.kernel.org` (viz obrázek 4-1).

Insert 18333fig0401.png
Obrázek 4-1. Online uživatelské rozhraní GitWeb

Pokud vás zajímá, jak by GitWeb vypadal pro váš projekt, nabízí Git příkaz, jímž lze spustit dočasnou instanci. V systému je třeba mít lehký server typu `lighttpd` nebo `webrick`. V počítačích se systémem Linux je často nainstalován `lighttpd`. Spustit ho lze zadáním příkazu `git instaweb` v adresáři vašeho projektu. Pokud používáte OS Mac, v systému Leopard je předinstalován jazyk Ruby, a proto pro vás bude nejlepší variantou zřejmě server `webrick`. Chcete-li spustit `instaweb` s jiným správcem než `lighttpd`, použijte parametr `--httpd`:

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Tím spustíte HTTPD server na portu 1234 a automaticky se spustí webový prohlížeč, který otevře tuto stránku. Není to nic obtížného. Až skončíte a budete chtít server vypnout, spusťte stejný příkaz s parametrem `--stop`:

	$ git instaweb --httpd=webrick --stop

Chcete-li trvale spustit webové rozhraní na serveru pro svůj tým nebo nebo pro open-source projekt, který hostujete, musíte nastavit CGI skript tak, aby byl obsluhován vaším běžným webovým serverem. Některé linuxové distribuce mají balíček `gitweb`, který by mělo být možné nainstalovat pomocí nástrojů `apt` nebo `yum`. Zkuste proto tuto možnost jako první. Ruční instalaci skriptu probereme velmi rychle. Nejprve je třeba získat zdrojový kód systému Git, s nímž je GitWeb distribuován, a vygenerovat uživatelský CGI skript:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb
	$ sudo cp -Rf gitweb /var/www/

Všimněte si, že musíte příkazu pomocí proměnné `GITWEB_PROJECTROOT` sdělit, kde najde repozitáře Git. Nyní musíte zajistit, aby server Apache používal CGI pro skript, pro který můžete přidat VirtualHost:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

Znovu připomeňme, že GitWeb může být obsluhován jakýmkoli webovým serverem podporujícím CGI. Chcete-li používat jakýkoli jiný server, nemělo by být nastavení obtížné. V tomto okamžiku byste měli být schopni prohlížet své repozitáře online na adrese `http://gitserver/` a používat `http://git.gitserver` ke klonování a vyzvedávání repozitářů prostřednictvím protokolu HTTP.

## Gitosis ##

Uchovávat veřejné klíče všech uživatelů v souboru `authorized_keys` není uspokojivým řešením na věčné časy. Musíte-li spravovat stovky uživatelů, je tento proces příliš náročný. Pokaždé se musíte přihlásit na server a k dispozici nemáte žádnou správu přístupu – všichni, kdo jsou uvedeni v souboru, mají ke každému projektu oprávnění pro čtení i pro zápis.

Proto možná rádi přejdete na rozšířený softwarový projekt „Gitosis“. Gitosis je v podstatě sada skriptů usnadňující správu souboru `authorized_keys` a implementaci jednoduché správy přístupu. Nejzajímavější je na nástroji Gitosis jeho uživatelské rozhraní pro přidávání uživatelů a specifikaci přístupu – nejedná se totiž o webové rozhraní, ale o speciální repozitář Git. V tomto projektu nastavíte všechny informace, a až ho odešlete, Gitosis překonfiguruje server, který je na něm založen. To je jistě příjemné řešení.

Instalace nástroje Gitosis sice nepatří mezi nejsnazší, ale není ani příliš složitá. Nejjednodušší je k ní použít linuxový server – tyto příklady používají běžný Ubuntu server 8.10.

Gitosis vyžaduje některé nástroje v jazyce Python, a proto první, co musíte udělat, je nainstalovat pythonovský balíček setuptools, který je v Ubuntu dostupný jako python-setuptools:

	$ apt-get install python-setuptools

Dále naklonujte a nainstalujte Gitosis z hlavní stránky projektu:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Tímto příkazem nainstalujete několik spustitelných souborů, které bude Gitosis používat. Gitosis dále vyžaduje, abyste jeho repozitáře uložili do adresáře `/home/git`. Vy už však máte repozitáře vytvořeny ve složce `/opt/git`, a tak místo toho, abyste museli vše překonfigurovat, vytvoříte symbolický odkaz:

	$ ln -s /opt/git /home/git/repositories

Gitosis teď bude spravovat klíče za vás. Proto je třeba, abyste odstranili aktuální soubor, klíče znovu přidali později a nechali Gitosis automaticky spravovat soubor `authorized_keys`. Pro tuto chvíli tedy odstraňte soubor `authorized_keys`:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Dále musíte znovu zapnout shell na uživatele 'git', jestliže jste ho změnili na příkaz `git-shell`. Uživatelé se stále ještě nebudou moci přihlásit, ale Gitosis za vás bude provádět správu. Takže v souboru `/etc/passwd` změňte následující řádek

	git:x:1000:1000::/home/git:/usr/bin/git-shell

zpět na

	git:x:1000:1000::/home/git:/bin/sh

V tomto okamžiku můžeme inicializovat nástroj Gitosis. Učiníte tak spuštěním příkazu `gitosis-init` se svým osobním veřejným klíčem. Není-li váš veřejný klíč na serveru, musíte ho tam nakopírovat:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Uživatel s tímto klíčem poté bude moci měnit hlavní repozitář Git, kterým se ovládá nastavení nástroje Gitosis. Dále je třeba ručně nastavit právo spuštění na skriptu `post-update` pro nový řídicí repozitář.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Teď to můžete rozjet. Pokud jste nastavení provedli správně, můžete vyzkoušet SSH přístup na server jako uživatel, pro kterého jste přidali veřejný klíč při inicializaci nástroje Gitosis. Mělo by se zobrazit asi následující:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	ERROR:gitosis.serve.main:Need SSH_ORIGINAL_COMMAND in environment.
	  Connection to gitserver closed.

To znamená, že vás Gitosis sice rozpoznal, ale nedovolí vám přístup, protože se nepokoušíte zadat žádný příkaz Git. Provedeme tedy skutečný příkaz systému Git a naklonujeme řídicí repozitář Gitosis:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Nyní máte adresář s názvem `gitosis-admin`, sestávající ze dvou hlavních částí:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Soubor `gitosis.conf` je řídicí soubor, který slouží ke specifikaci uživatelů, repozitářů a oprávnění. V adresáři `keydir` jsou pak uloženy veřejné klíče pro všechny uživatele, kteří mají (ať už jakýkoli) přístup k vašim repozitářům – jeden soubor pro každého uživatele. Název souboru v adresáři `keydir` (v předchozím příkladu `scott.pub`) bude ve vašem případě jiný. Gitosis převezme tento název z popisu na konci veřejného klíče, který byl importován spolu se skriptem `gitosis-init`.

Pokud se podíváte na soubor `gitosis.conf`, měl by udávat pouze informace o projektu `gitosis-admin`, který jste právě naklonovali:

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	members = scott
	writable = gitosis-admin

Tato informace znamená, že uživatel 'scott' – ten, jehož veřejným klíčem jste inicializovali Gitosis – je jediným uživatelem, který má přístup k projektu `gitosis-admin`.

Nyní přidáme nový projekt. Přidáte novou část s názvem `mobile`, která bude obsahovat seznam vývojářů vašeho mobilního týmu a projektů, k nimž tito vývojáři potřebují přístup. Protože je v tuto chvíli jediným uživatelem v systému 'scott', přidáte ho jako jediného člena a vytvoříte pro něj nový projekt s názvem `iphone_project`:

	[group mobile]
	members = scott
	writable = iphone_project

Pokaždé, když provedete změny v projektu `gitosis-admin`, musíte tyto změny zapsat a odeslat je zpět na server, aby nabyly účinnosti:

	$ git commit -am 'add iphone_project and mobile group'
	[master 8962da8] add iphone_project and mobile group
	 1 file changed, 4 insertions(+)
	$ git push origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 272 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:gitosis-admin.git
	   fb27aec..8962da8  master -> master

Do nového projektu `iphone_project` teď můžete odeslat svá první data: přidejte do lokální verze projektu svůj server jako vzdálený repozitář a odešlete změny. Od této chvíle už nebudete muset ručně vytvářet holé repozitáře pro nové projekty na serveru. Gitosis je vytvoří automaticky, jakmile zjistí první odeslání dat:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Všimněte si, že není třeba zadávat cestu (naopak, příkaz by pak nefungoval), pouze dvojtečku a za ní název projektu. Gitosis už projekt vyhledá.

Na tomto projektu chcete spolupracovat s přáteli, a proto budete muset znovu přidat jejich veřejné klíče. Ale místo toho, abyste je vkládali ručně do souboru `~/.ssh/authorized_keys` na serveru, přidáte je do adresáře `keydir`, jeden soubor pro každý klíč. Jak tyto klíče pojmenujete, závisí na tom, jak jsou uživatelé označeni v souboru `gitosis.conf`. Přidejme znovu veřejné klíče pro uživatele Johna, Josie a Jessicu:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Nyní je můžete všechny přidat do týmu 'mobile', čímž získají oprávnění pro čtení i pro zápis k `iphone_project`:

	[group mobile]
	members = scott john josie jessica
	writable = iphone_project

Až tuto změnu zapíšete a odešlete, všichni čtyři uživatelé budou moci z tohoto projektu číst a zapisovat do něj.

Gitosis nabízí také jednoduchou správu přístupu. Pokud chcete, aby měl John u projektu pouze oprávnění pro čtení, můžete provést následující:

	[group mobile]
	members = scott josie jessica
	writable = iphone_project

	[group mobile_ro]
	members = john
	readonly = iphone_project

John nyní může naklonovat projekt a stahovat jeho aktualizace, ale Gitosis mu neumožní, aby odesílal data zpět do projektu. Takových skupin můžete vytvořit libovolně mnoho. Každá může obsahovat různé uživatele a projekty. Jako jednoho ze členů skupiny můžete zadat také celou jinou skupinu (použijete pro ni předponu `@`). Všichni její členové se tím automaticky zdědí.

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	members   = @mobile_committers
	writable  = iphone_project

	[group mobile_2]
	members   = @mobile_committers john
	writable  = another_iphone_project

Máte-li jakékoli problémy, může vám pomoci zadání `loglevel=DEBUG` do části `[gitosis]`. Pokud jste odesláním nesprávné konfigurace ztratili oprávnění k odesílání dat, můžete ručně opravit soubor na serveru v adresáři `/home/git/.gitosis.conf` – jedná se o soubor, z nějž Gitosis načítá data. Po odeslání dat do projektu bude soubor `gitosis.conf`, který jste právě odeslali, umístěn do tohoto adresáře. Pokud soubor ručně upravíte, zůstane v této podobě až do dalšího úspěšného odeslání do projektu `gitosis-admin`.

## Gitolite ##

Tato podkapitola slouží k rychlému seznámení s Gitolite a uvádí základní pokyny pro instalaci a nastavení. Nemůže ale nahradit ohromný objem [dokumentace][gltoc], která se s Gitolite dodává. Tato podkapitola se může občas změnit, takže se možná chcete podívat na její [poslední verzi][gldpg].

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

Gitolite je autorizační vrstva nad gitem, která při autentizaci spoléhá na `sshd` nebo `httpd`. (Připomeňme si: autentizace spočívá v rozpoznání uživatele, autorizací rozumíme rozhodování, zda má povolení k provádění toho, co se provést pokouší.)

Gitolite umožňuje nastavit přístupová práva nejen na repozitáře (podobně jako Gitosis), ale také na větve a značky v každém repozitáři. To znamená, že lze nastavit, aby určití lidé mohli odesílat jen do určité větve (nebo určité značky; obecně „refs“), ale do jiné ne.

### Instalace ###

Instalace Gitolite je velmi jednoduchá a to i když si nepřečtete obsáhlou dokumentaci, která je k dispozici. Budete potřebovat účet na nějakém unixovém serveru. Pokud už jsou nainstalovány nástroje Git, Perl a SSH server kompatibilní s OpenSSH, nebudete potřebovat ani přístup root. V příkladech uvedených níže budeme používat účet `git` na serveru `gitserver`.

Nástroj Gitolite je ve smyslu „serverového“ softwaru poněkud neobvyklý. Přístup se realizuje přes SSH, takže každá serverová userid je potenciálně „hostitelem gitolite“ (gitolite host). Teď si popíšeme nejjednodušší způsob instalace. V dokumentaci naleznete další metody.

Začněte tím, že na serveru vytvoříte uživatele nazvaného `git` a přihlásíte se na něj. Z vaší pracovní stanice nakopírujte svůj veřejný SSH klíč (pokud jste spustili `ssh-keygen` s implicitními hodnotami, jde o soubor `~/.ssh/id_rsa.pub`) a přejmenujte jej na `<vasejmeno>.pub` (v příkladech budeme používat `scott.pub`). Potom proveďte následující příkazy:

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	    # assumes $HOME/bin exists and is in your $PATH
	$ gitolite setup -pk $HOME/scott.pub

Poslední příkaz vytvoří na serveru nový gitovský repozitář nazvaný `gitolite-admin`.

Nakonec přejděte zpět na pracovní stanici a spusťte `git clone git@gitserver:gitolite-admin`. To je všechno! Nyní máte Gitolite nainstalovaný na serveru a v domácím adresáři vaší pracovní stanice máte také úplně nový repozitář `gitolite-admin`. Své nastavení Gitolite spravujete pomocí provádění změn v tomto repozitáři jejich odesíláním (push).

### Přizpůsobení instalace ###

Základní rychlá metoda instalace bude většině lidí vyhovovoat. V případě potřeby existují další možnosti přizpůsobení. Něco můžete změnit jednoduše editací rc souboru. Pokud to ale nestačí, naleznete víc v dokumentaci věnované přizpůsobení Gitolite.

### Konfigurační soubor a pravidla přístupu ###

Jakmile je instalace dokončena, přepněte se do repozitáře `gitolite-admin`, který jste naklonovali na váš počítač, a podívejte se co tam je:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/scott.pub
	$ cat conf/gitolite.conf

	repo gitolite-admin
	    RW+                 = scott

	repo testing
	    RW+                 = @all

Všimněte si, že „scott“ (jméno veřejného klíče v dříve použitém příkazu `gitolite setup`) má práva pro čtení i zápis k repozitáři `gitolite-admin` a také stejnojmenný veřejný klíč.

Přidávání dalších uživatelů je snadné. Pokud chceme přidat uživatele „alice“, získáme její veřejný klíč, pojmenujeme jej `alice.pub` a umístíme jej do adresáře `keydir`. Je součástí klonu repozitáře `gitolite-admin`, který jsme právě vytvořili na pracovní stanici. Přidáme, potvrdíme a odešleme změny (add, commit, push). Tím jsme dosáhli přidání uživatele.

Syntaxe konfiguračního souboru pro Gitolite je dobře dokumentovaná, takže zde zdůrazníme jen pár věcí.

Pro usnadnění můžete uživatele i repozitáře sdružovat do skupin. Jména skupin se chovají jako makra; když je definujete, je úplně jedno jestli jde o projekty nebo uživatele; rozdíl se pozná až v momentu, kdy „makro“ *použijete*.

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

Můžete nastavovat přístupová práva na úrovni referencí. Skupina interns může v následujícím případě odesílat pouze větev „int“. Skupina engineers mohou odesílat větve, jejichž názvy začínají na „eng-“ a značky, které začínají na „rc“ a pak následuje číslo. A skupina admins může dělat cokoliv (včetně vracení změn) v kterékoliv referenci.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

Výraz za `RW` nebo `RW+` je regulární výraz (regex), se kterým se porovnává jméno odesílané reference (ref). Nazvěme jej tedy „refex“! Refex může mít samozřejmě mnohem více použití než je tady ukázáno, takže si dejte pozor ať to nepřeženete, zvláště pokud nejste kovaní v perlovských regulárních výrazech.

Gitolite přidává prefix `refs/heads/` jako usnadnění syntaxe, pokud refex nezačíná na `refs/`, jak jste mohli odhadnout z příkladu.

Důležitou vlastností syntaxe konfiguračního souboru je to, že všechna pravidla pro repozitáře nemusí být na jednom místě. Můžete nechat obecná nastavení, jako třeba pravidla pro všechny `oss_repos` z příkladu, a potom později přidávat pravidla pro více specifické případy. Např.:

	repo gitolite
	    RW+                     = sitaram

Toto pravidlo se pak přidá do skupiny pravidel repozitáře `gitolite`.

Teď by vás mohlo zajímat, jak jsou vlastně pravidla pro přístup aplikována, pojďme se na to tedy krátce podívat.

V Gitolite jsou dvě úrovně kontroly přístupů. První je úroveň repozitářů; jestliže máte práva na čtení (nebo zápis) *k jakékoliv* referenci v repozitáři, máte tím práva na čtení (nebo zápis) k tomuto repozitáři. Tohle je jediná možnost jakou měl nástroj Gitosis.

Druhá úroveň se dá použít jen pro práva pro „zápis“ a vázána na větve nebo značky v repozitáři. Uživatelské jméno uživatele snažícího se o přístup (`W` nebo `+`) a jméno reference, kterou uživatel chce aktualizovat, jsou dané. Pravidla pro přístup jsou procházena postupně v pořadí, tak jak jsou uvedena v konfiguračním souboru a hledají se záznamy odpovídající této kombinaci uživatelského jména a reference (nezapomeňte ale, že refname se porovnává jako regulární výraz nikoliv jako pouhý řetězec). Jestliže je nalezen odpovídající záznam, odesílání je povoleno. Pokud není nalezeno nic, je přístup zamítnut.

### Rozšířené řízení přístupu pravidly typu „odmítnutí“ ###

Prozatím jsme si ukázali jen oprávnění nastavená na jednu z hodnot `R`, `RW` nebo `RW+`. Ale Gitolite dovoluje nastavení dalšího oprávnění: `-` s významem „odmítnutí“. To vám dává mnohem více možností, ale za cenu zvýšení složitosti. Popadnutí sítem pravidel už totiž není *jedinou* možností vedoucí k zamítnutí přístupu. *Záleží na pořadí pravidel!*

Řekněme, že ve výše uvedené situaci budeme chtít, aby skupina engineers mohla vracet změny v jakékoliv větvi *s výjimkou* větví `master` a `integ`. Udělá se to následovně:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Pravidla se  budou opět procházet shora dolů až do momentu, kdy narazíte na shodu s vaším režimem přístupu nebo na pravidlo typu odmítnutí (deny). Odeslání do větve `master` nebo `integ`, která nevracejí zpět změny (non-rewind push), jsou povolena prvním pravidlem. Odeslání, která vracejí změny (rewind push) do těchto větví, neodpovídají prvnímu pravidlu. Porovnají se tedy s druhým pravidlem a na jeho základě budou zamítnuty. Jakékoliv odeslání (bez ohledu na to zda se jedná o vracení změn nebo ne) do jiných referencí než `master` nebo `integ` nebudou odpovídat ani prvnímu ani druhému pravidlu, a proto bude díky třetímu pravidlu povoleno.

### Omezení odesílání změn vázané na soubory ###

K omezení odesílání do určitých větví a určitými uživateli můžete přidat také omezení určující, které soubory mohou uživatelé měnit. Například  soubor Makefile (a možná některé programy) by asi neměl kdokoliv měnit, protože je na něm závislá řada dalších věcí. Pokud se neupraví *správným způsobem*, něco by se pokazilo. Nástroji Gitolite můžeme říct:

    repo foo
        RW                      =   @junior_devs @senior_devs

        -   VREF/NAME/Makefile  =   @junior_devs

Uživatelé, kteří přecházejí ze starší verze Gitolite by si měli dát pozor na to, že v souvislosti s uvedeným rysem došlo k výrazné změně chování. Věnujte prosím pozornost detailům, které jsou uvedeny v příručce pro přechod k nové verzi.

### Osobní větve ###

Konečně Gitolite má také funkci, která se nazývá „osobní větve“ (nebo raději „jmenný prostor osobních větví“) a může být velmi užitečná v korporátním prostředí.

Hodně výměny kódu probíhá v otevřeném gitovém světě metodou „prosím stáhněte si“. V korporátním prostředí ovšem nebývá jakýkoliv přístup bez prokázání totožnosti vítán a pracovní stanice vývojáře nemůže provádět autentizaci, takže můžete na centrální server odesílat, ale musíte požádat někoho jiného, když odtud chcete stahovat.

To by za normálních okolností způsobilo stejný zmatek ve jménech větví jako v centralizovaných systémech správy verzí a navíc nastavování přístupových práv by administrátorovi přidalo práci.

Gitolite vám umožní nadefinovat pro každého vývojáře jmenné prostory s prefixy „personal“ nebo „scratch“ (např. `refs/personal/<devname>/*`). Podrobnosti hledejte v dokumentaci.

### „Wildcard“ repozitáře ###

Gitolite vám umožní určit repozitáře zástupnými znaky (wildcards; ve skutečnosti jde o perlovské regulární výrazy) -- jako například u náhodně vybraného příkladu `assignments/s[0-9][0-9]/a[0-9][0-9]`. Umožní nám též přidělit nový režim oprávnění (`C`), který uživatelům povoluje vytvářet repozitáře popsané zástupnými znaky, automaticky přidělí vlastnictví konkrétnímu uživateli, který jej vytvořil, umožní mu přidělit oprávnění `R` a `RW` dalším spolupracovníkům atd. Podrobnosti opět hledejte v dokumentaci.

### Další vlastnosti ###

Vysvětlení Gitolite završíme přehledem několika vlastností, které jsou detailně popsány v dokumentaci.

**Logování:** Gitolite loguje všechny úspěšné přístupy. Jestliže máte volná pravidla pro přidělování oprávnění vracet změny (práva `RW+`) a stane se, že někdo takto „zkazí“ větev `master`, je tu ještě log soubor, který vám zachrání život, protože v něm můžete postižené SHA najít.

**Přehledy uživatelských oprávnění:** Další příjemnou vlastností je to, co se stane, pokud se pouze pokusíte připojit pomocí SSH na server. Gitolite vám ukáže, ke kterým repozitářům máte přístup a s jakými oprávněními. Příklad:

        hello scott, this is git@git running gitolite3 v3.01-18-g9609868 on git 1.7.4.4

             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Delegace:** Pro opravdu velké instalace můžete delegovat zodpovědnost za skupiny a repozitáře dalším lidem a nechat je spravovat jednotlivé části nezávisle. To snižuje vytížení hlavního administrátora, který tím přestává být úzkým místem správy.

**Zrcadlení:** Gitolite vám pomůže se správou více zrcadel a při výpadku hlavního serveru můžete snadno přepnout na jiný.

## Démon Git ##

Jestliže potřebujete ke svým projektům přístup pro čtení bez ověřování totožnosti, budete muset obejít protokol HTTP a začít používat protokol Git. Mluví pro něj především rychlost. Protokol Git je daleko výkonnější, a proto také rychlejší než protokol HTTP, takže uživatelům ušetří nějaký čas.

I v tomto případě se jedná o přístup pouze pro čtení bez ověřování totožnosti. Pokud protokol používáte na serveru mimo firewall, mělo by to být pouze u projektů, které jsou veřejně viditelné okolnímu světu. Pokud je server, na kterém protokol spouštíte, uvnitř firewallu, můžete ho používat u projektů, k nimž má přístup pro čtení velký počet lidí nebo počítačů (servery průběžné integrace nebo servery sestavení), jimž nechcete jednotlivě přiřazovat SSH klíče.

Ať tak či tak, na protokolu Git jistě oceníte jeho snadné nastavení. V podstatě je třeba spustit tento příkaz:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` umožňuje serveru restartování bez nutnosti čekat na vypršení časového limitu pro stará spojení, parametr `--base-path` umožňuje uživatelům klonovat projekty, aniž by museli zadávat celou cestu, a cesta na konci příkazu říká démonovi Git, kde má hledat repozitáře určené k exportu. Jestliže používáte bránu firewall, budete rovněž muset na ní povolit port 9418.

Podle toho, jaký operační systém používáte, můžete přejít do režimu démon mnoha způsoby. U počítačů s Ubuntu můžete použít skript Upstart. Do souboru

	/etc/event.d/local-git-daemon

vložte tento skript:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Z bezpečnostních důvodů důrazně doporučujeme, aby byl tento démon spuštěn jako uživatel, který má k repozitářům oprávnění pouze pro čtení. To lze snadno zajistit vytvořením nového uživatele 'git-ro' a spuštěním démona v jeho roli. My ho pro zjednodušení spustíme jako uživatele 'git', kterého už využívá nástroj Gitosis.

Při restartování počítače se démon Git spustí automaticky. V případě pádu démona bude jeho činnost automaticky obnovena. Pokud nechcete počítač restartovat, spusťte tento příkaz:

	initctl start local-git-daemon

V jiných systémech možná budete chtít použít `xinetd`, skript systému `sysvinit`, nebo podobný skript – můžete-li spouštět příkaz démonizovaný a sledovaný.

Dále budete muset svému serveru Gitosis sdělit, k jakým repozitářům si přejete povolit neautentizovaný serverový přístup Git. Pokud pro každý repozitář přidáte sekci, můžete určit repozitáře, z nichž si přejete dovolit démonovi Git načítat data. Chcete-li povolit přístup přes protokol Git k projektu `iphone_project`, přidejte ho na konec souboru `gitosis.conf`:

	[repo iphone_project]
	daemon = yes

Po zapsání a odeslání této revize by měl váš spuštěný démon začít obsluhovat požadavky k projektu pro všechny, kdo mají přístup k portu 9418 na vašem serveru.

Pokud nechcete používat Gitosis, ale chcete nastavit démona Git, budete muset u každého projektu, který chcete obsluhovat démonem Git, provést následující:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

Přítomnost tohoto souboru systému Git sděluje, že si přejete obsluhovat tento projekt bez ověřování totožnosti.

Gitosis může také určovat, jaké projekty bude zobrazovat GitWeb. Nejprve budete muset do souboru `/etc/gitweb.conf` vložit následující:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Vložením nebo odstraněním nastavení `gitweb` z konfiguračního souboru Gitosis můžete určit, které projekty dovolí GitWeb uživatelům procházet. Pokud například chcete, aby GitWeb zobrazoval `iphone_project`, upravíte nastavení `repo` do této podoby:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Pokud teď zapíšete a odešlete projekt, GitWeb začne automaticky zobrazovat `iphone_project`.

## Hostování projektů Git ##

Pokud nemáte chuť absolvovat celý proces nastavování vlastního serveru Git, existuje několik možností hostování vašich projektů Git na externím specializovaném hostingovém místě. Toto řešení vám nabízí celou řadu výhod. Hostingové místo má většinou velmi rychlé nastavení, snadno se na něm zakládají projekty a nevyžaduje od vás správu ani monitoring serveru. Dokonce i když budete nastavovat a spouštět interně svůj vlastní server, budete možná přesto chtít použít veřejné hostingové místo pro otevřený zdrojový kód – komunita open source vývojářů si vás tak snáze najde a pomůže vám.

V dnešní době můžete vybírat z velkého počtu možností hostingu. Každá má jiné klady a zápory. Aktuální seznam těchto míst najdete na následující stránce:

	https://git.wiki.kernel.org/index.php/GitHosting

Protože se tu nemůžeme věnovat všem možnostem a protože shodou okolností na jednom hostingovém místě pracuji, využijeme tuto část k tomu, abychom ukázali nastavení účtu a vytvoření nového projektu na serveru GitHub. Získáte tak představu, co všechno vás čeká.

GitHub je zdaleka největším hostingovým místem pro projekty Git s otevřeným zdrojovým kódem a je zároveň jedním z velmi mála těch, která nabízejí možnosti jak veřejného, tak soukromého hostingu. Na jednom místě tak můžete mít uložen jak otevřený zdrojový kód, tak soukromý komerční kód. Možnost soukromého použití GitHub jsme ostatně používali pro spolupráci při vzniku této knihy.

### GitHub ###

GitHub se nepatrně liší od většiny míst hostujících zdrojový kód ve způsobu, jak zachází se jmenným prostorem projektů. Ten tu není založen primárně na názvu projektu, ale na uživateli. To znamená, že pokud budu hostovat svůj projekt `grit` na serveru GitHub, nenajdete ho na adrese `github.com/grit`, ale jako `github.com/schacon/grit`. Neexistuje tu žádná standardní verze projektu, která by umožňovala kompletní přechod projektu z jednoho uživatele na druhého, jestliže první autor projekt ukončí.

GitHub je zároveň komerční společnost, jejíž finanční příjmy plynou z účtů spravujících soukromé repozitáře. Kdokoli si však může rychle založit bezplatný účet k hostování libovolného počtu projektů s otevřeným kódem. A právě u účtů se teď na chvíli zastavíme.

### Založení uživatelského účtu ###

První věcí, kterou budete muset udělat, je vytvoření bezplatného uživatelské účtu. Jestliže na stránce „Pricing and Signup“ (`https://github.com/pricing`) kliknete u bezplatného účtu (Free) na tlačítko „Sign Up“ (viz obrázek 4-2), přejdete na registrační stránku.

Insert 18333fig0402.png
Obrázek 4-2. Výběr typu účtu na serveru GitHub

Tady si budete muset zvolit uživatelské jméno, které zatím není v systému obsazeno, a zadat e-mailovou adresu, která bude přiřazena k účtu a heslu (viz obrázek 4-3).

Insert 18333fig0403.png
Obrázek 4-3. Registrační formulář na serveru GitHub

Po vyplnění osobních údajů nadešel vhodný čas k vložení vašeho veřejného klíče SSH. Jak vygenerovat nový klíč, jsme popsali výše, v části 4.3. Vezměte obsah veřejného klíče z daného páru a vložte ho do textového pole „SSH Public Key“. Kliknutím na odkaz „explain ssh keys“ přejdete na stránku s podrobnými instrukcemi, jak klíč vložit ve všech hlavních operačních systémech.
Kliknutím na tlačítko „I agree, sign me up“ přejdete na svůj nový uživatelský ovládací panel (viz obrázek 4-4).

Insert 18333fig0404.png
Obrázek 4-4. Uživatelský ovládací panel na serveru GitHub

Jako další krok následuje vytvoření nového repozitáře.

### Vytvoření nového repozitáře ###

Začněte kliknutím na odkaz „create a new one“ (vytvořit nový) vedle nadpisu „Your Repositories“ na ovládacím panelu. Přejdete tím na formulář „Create a New Repository“ (viz obrázek 4-5).

Insert 18333fig0405.png
Obrázek 4-5. Vytvoření nového repozitáře na serveru GitHub

Vše, co tu opravdu musíte udělat, je zadat název projektu. Kromě toho můžete přidat i jeho popis. Poté klikněte na tlačítko „Create Repository“ (Vytvořit repozitář). Nyní máte na serveru GitHub vytvořen nový repozitář (viz obrázek 4-6).

Insert 18333fig0406.png
Obrázek 4-6. Záhlaví s informacemi o projektu na serveru GitHub

Protože v něm ještě nemáte uložen žádný kód, GitHub vám nabízí instrukce, jak vytvořit zcela nový projekt, odeslat sem existující projekt Git nebo naimportovat projekt z veřejného repozitáře Subversion (viz obrázek 4-7).

Insert 18333fig0407.png
Obrázek 4-7. Instrukce k novému repozitáři

Tyto instrukce jsou podobné těm, které jsme už uváděli. K inicializaci projektu, pokud to ještě není projekt Git, použijte příkaz:

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Pokud už máte lokální repozitář Git, přidejte GitHub jako vzdálený server a odešlete na něj svou hlavní větev:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Nyní je váš projekt hostován na serveru GitHub a vy můžete dát adresu URL komukoli, s kým chcete svůj projekt sdílet. V tomto případě je adresa `http://github.com/testinguser/iphone_project`. V záhlaví na stránce všech vašich projektů si můžete všimnout, že máte dvě adresy URL (viz obrázek 4-8).

Insert 18333fig0408.png
Obrázek 4-8. Záhlaví projektu s veřejnou a soukromou adresou URL

„Public Clone URL“ je veřejná adresa Git pouze pro čtení, na níž si může váš projekt kdokoli naklonovat. Nemusíte se bát poskytnout tuto adresu ostatním nebo ji třeba zveřejnit na svých webových stránkách.

„Your Clone URL“ je SSH adresa ke čtení a zápisu, přes níž můžete číst a zapisovat. To však pouze v případě, že se připojíte se soukromým klíčem SSH asociovaným s veřejným klíčem, který jste zadali pro svého uživatele. Navštíví-li tuto stránku projektu ostatní uživatelé, tuto adresu URL neuvidí, zobrazí se jim pouze veřejná adresa.

### Import ze systému Subversion ###

Máte-li existující veřejný projekt Subversion, který byste rádi importovali do systému Git, GitHub vám s tím obvykle pomůže. Dole na stránce s instrukcemi najdete odkaz na import ze systému Subversion. Pokud na něj kliknete, zobrazí se formulář s informacemi o importu a textové pole, kam můžete vložit adresu URL svého veřejného projektu Subversion (viz obrázek 4-9).

Insert 18333fig0409.png
Obrázek 4-9. Rozhraní importu ze systému Subversion

Proces nejspíš nebude fungovat, pokud je váš projekt příliš velký, nestandardní nebo soukromý. V kapitole 7 se dostaneme k tomu, jak lze ručně importovat složitější projekty.

### Přidávání spolupracovníků ###

Nyní přidáme zbytek vašeho týmu. Pokud si John, Josie i Jessica zaregistrují účty na serveru GitHub a vy jim chcete udělit oprávnění k odesílání dat do svého repozitáře, můžete je do svého projektu přidat jako spolupracovníky. Spolupracovníci mohou odesílat data i na základě svých veřejných klíčů.

Kliknutím na tlačítko „edit“ v záhlaví projektu nebo na záložce „Admin“ v horní části projektu se dostanete na stránku správy vašeho projektu na serveru GitHub (viz obrázek 4-10).

Insert 18333fig0410.png
Obrázek 4-10. Stránka správy na serveru GitHub

Chcete-li k svému projektu poskytnout oprávnění pro zápis ještě dalším uživatelům, klikněte na odkaz „Add another collaborator“ (Přidat dalšího spolupracovníka). Zobrazí se nové textové pole, do nějž můžete zadat jméno uživatele. Během psaní se zobrazuje pomocník, který vám navrhuje možná dokončení uživatelského jména. Poté, co najdete správného uživatele, klikněte na tlačítko „Add“. Tím uživatele přidáte jako spolupracovníka na svém projektu (viz obrázek 4-11).

Insert 18333fig0411.png
Obrázek 4-11. Přidání spolupracovníka do projektu

Po přidání všech spolupracovníků byste měli vidět jejich seznam v poli „Repository Collaborators“ (viz obrázek 4-12).

Insert 18333fig0412.png
Obrázek 4-12. Seznam spolupracovníků na projektu

Pokud potřebujete oprávnění pro některého z uživatelů zrušit, klikněte na odkaz „revoke“. Tím odstraníte jeho oprávnění k odesílání dat. U budoucích projektů budete také moci zkopírovat skupinu spolupracovníků zkopírováním oprávnění z existujícího projektu.

### Váš projekt ###

Po odeslání projektu nebo jeho naimportování ze systému Subversion budete mít hlavní stránku projektu, která bude vypadat přibližně jako na obrázku 4-13.

Insert 18333fig0413.png
Obrázek 4-13. Hlavní stránka projektu na serveru GitHub

Navštíví-li váš projekt ostatní uživatelé, tuto stránku uvidí. Obsahuje několik záložek k různým aspektům vašich projektů. Záložka „Commits“ zobrazuje seznam revizí v obráceném chronologickém pořadí, podobně jako výstup příkazu `git log`. Záložka „Network“ zobrazuje všechny uživatele, kteří se odštěpili od vašeho projektu a zase do něj přispěli. Záložka „Downloads“ umožňuje nahrávat binární soubory k projektu a přidávat odkazy na tarbally a komprimované verze všech míst ve vašem projektu, které jsou označeny značkou (tagem). Záložka „Wiki“ vám nabízí stránku wiki, kam můžete napsat dokumentaci nebo jiné informace ke svému projektu. Záložka „Graphs“ graficky zobrazuje některé příspěvky a statistiky k vašemu projektu. Hlavní záložka „Source“, na níž se stránka otvírá, zobrazuje hlavní adresář vašeho projektu, a máte-li soubor README, automaticky pod adresářem projektu zobrazí jeho obsah. Tato záložka obsahuje rovněž pole s informacemi o poslední zapsané revizi.

### Štěpení projektů ###

Chcete-li přispět do existujícího projektu, k němuž nemáte oprávnění pro odesílání, umožňuje GitHub rozštěpení projektu. Pokud se dostanete na zajímavou stránku projektu a chtěli byste se do projektu zapojit, můžete kliknout na tlačítko „fork“ (rozštěpit -- doslova vidlička) v záhlaví projektu a GitHub vytvoří kopii projektu pro vašeho uživatele. Do ní pak můžete odesílat revize.

Díky tomu se projekty nemusí starat o přidávání uživatelů do role spolupracovníků, kteří by měli právo zápisu. Uživatelé mohou projekt rozštěpit a odesílat do něj revize. Hlavní správce projektu tyto změny natáhne tím, že je přidá jako vzdálené repozitáře a začlení jejich data.

Chcete-li projekt rozštěpit, přejděte na stránku projektu (v tomto případě mojombo/chronic) a klikněte na tlačítko „fork“ v záhlaví (viz obrázek 4-14).

Insert 18333fig0414.png
Obrázek 4-14. Zapisovatelnou kopii jakéhokoli repozitáře získáte kliknutím na tlačítko „fork“.

Po několika sekundách přejdete na novou stránku svého projektu, která oznamuje, že je tento projekt odštěpen (fork) z jiného projektu (viz obrázek 4-15).

Insert 18333fig0415.png
Obrázek 4-15. Vaše rozštěpení projektu

### Shrnutí k serveru GitHub ###

O serveru GitHub je to vše. Ještě jednou bych rád zdůraznil, že všechny tyto kroky lze provést opravdu velmi rychle. Vytvoření účtu, přidání nového projektu a odeslání prvních revizí je záležitostí několika minut. Je-li váš projekt otevřený zdrojový kód, získáte také obrovskou komunitu vývojářů, kteří nyní váš projekt uvidí, mohou ho rozštěpit a pomoci vám svými příspěvky. V neposlední řadě může být toto způsob, jak rychle zprovoznit a vyzkoušet systém Git.

## Shrnutí ##

Existuje několik možností, jak vytvořit a zprovoznit vzdálený repozitář Git tak, abyste mohli spolupracovat s ostatními uživateli nebo sdílet svou práci.

Provoz vlastního serveru vám dává celou řadu možností kontroly a umožňuje provozovat server za vaším firewallem. Nastavení a správa takového serveru však obvykle bývají časově náročné. Umístíte-li data na hostovaný server, je jejich nastavení a správa jednoduchá. Svůj zdrojový kód však v takovém případě ukládáte na cizím serveru, což některé organizace nedovolují.

Teď už byste se měli umět rozhodnout, které řešení nebo jaká kombinace řešení se pro vás a pro vaši organizaci hodí.
