# Git na serwerze #

Powinieneś być już w stanie realizować większość codziennych zadań podczas pracy z Git. Jednakże do współpracy z innymi potrzebne będzie zdalne repozytorium Git. Choć, technicznie rzecz biorąc, możesz pchać zmiany i pobierać je z repozytoriów pojedynczych osób, nie jest to zalecana technika, ponieważ jeśli nie jest się ostrożnym, bardzo łatwo zrobić bałagan w czyjejś pracy. Dodatkowo niezbędny jest dostęp do Twojego repozytorium przez innych nawet gdy nie masz połączenia z siecią - bardzo przydatne jest posiadanie wiarygodnego, wspólnego repozytorium. Z tego powodu zalecaną metodą współpracy z innymi jest stworzenie pośredniego repozytorium, do którego wszyscy mają dostęp i wykonywanie operacji pchania i pobierania danych właśnie z niego. Nazwiemy to repozytorium "serwerem Git"; zobaczysz jednak że obsługa repozytorium Git zabiera zwykle bardzo niewiele zasobów systemowych przez co bardzo rzadko potrzebne będzie wydzielenie w tym celu dedykowanego serwera.

Zarządzanie serwerem Git jest proste. Po pierwsze określasz protokoły dostępu do tego serwera. Pierwsza część tego rozdziału zawiera informacje o dostępnych protokołach oraz ich wadach i zaletach. Kolejna część zawiera opis typowych konfiguracji wykorzystujących te protokoły oraz opis właściwych ustawień serwera. W końcu opiszemy dostępne opcje hostingu, jeśli nie przeszkadza Ci przechowywanie kodu na obcym serwerze i nie masz ochoty na tworzenie i zarządzanie własnym serwerem.

Jeśli nie masz zamiaru tworzyć własnego serwera możesz przejść od razu do ostatniej części tego rozdziału, aby sprawdzić dostępne możliwości tworzenia konta w zewnętrznej usłudze, a następnie możesz przejść do kolejnego rozdziału, który zawiera dyskusję na temat różnych aspektów pracy w rozproszonym środowisku kontroli wersji.

Zdalne repozytorium to nic innego jak samo repozytorium bez kopii roboczej (ang. _bare repository_). Ponieważ repozytorium to jest wykorzystywane wyłącznie jako miejsce współpracy, nie ma potrzeby by na dysku istniała migawka jakiejkolwiek wersji; to po prostu dane Git. Mówiąc krótko - takie repozytorium to wyłącznie zawartość katalogu `.git`.

## Protokoły ##

Git potrafi korzystać z czterech podstawowych protokołów sieciowych do przesyłu danych: lokalnego, Secure Shell (SSH), Git, oraz HTTP. Poniżej opiszemy czym się charakteryzują i w jakich sytuacjach wartko korzystać (lub wręcz przeciwnie) z jednego z nich.

Istotne jest, że z wyjątkiem protokołu HTTP, wszystkie pozostałe wymagają by na serwerze został zainstalowany Git.

### Protokół lokalny ###

Najbardziej podstawowym protokołem jest _protokół lokalny_, w którym zdalne repozytorium to po prostu inny katalog na dysku. Taką konfigurację często wykorzystuje się, gdy wszyscy z Twojego zespołu mają dostęp do jednego współdzielonego systemu plików, np. NFS lub, co mniej prawdopodobne, gdy wszyscy logują się do tego samego komputera. Ten drugi scenariusz nie jest zalecany z tego powodu, że wszystkie kopie repozytorium znajdują się na tej samej fizycznej maszynie, co może być katastrofalne w skutkach.

Jeśli posiadasz współdzielony, zamontowany system plików, możesz z niego klonować, pchać do niego własne zmiany oraz pobierać zmiany innych korzystając z plikowego repozytorium lokalnego. Aby sklonować takie repozytorium, albo wskazać jedno z takich repozytoriów jako repozytorium zdalne, skorzystaj ze ścieżki do katalogu jako adresu URL. Np. aby sklonować lokalne repozytorium możesz wywołać polecenie podobne do poniższego:

    $ git clone /opt/git/project.git

Możesz też użyć takiej formy:

    $ git clone file:///opt/git/project.git

Git działa odrobinę inaczej, gdy jawnie użyjesz przedrostka `file://` w adresie URL. Jeśli podasz samą ścieżkę, Git spróbuje użyć twardych linków albo po prostu skopiować potrzebne pliki. Jeśli podasz `file://`, Git uruchomi procesy normalnie wykorzystane do transferu sieciowego, co zwykle jest znacznie mniej efektywną metodą przesyłania danych. Głównym powodem podawania przedrostka `file://` jest chęć posiadania czystej kopii repozytorium bez niepotrzebnych referencji, czy obiektów, które zwykle powstają po zaimportowaniu repozytorium z innego systemu kontroli wersji (Rozdział 9 zawiera informacje na temat zadań administracyjnych). Tutaj skorzystamy ze zwykłej ścieżki do katalogu, ponieważ będzie szybciej.

Aby dodać do istniejącego projektu repozytorium plikowe jako repozytorium zdalne, wykonaj polecenie:

    $ git remote add local_proj /opt/git/project.git

Od tej chwili możesz pchać i pobierać z repozytorium zdalnego tak samo jakby repozytorium to istniało w sieci.

#### Zalety ####

Zaletą plikowego repozytorium jest prostota i możliwość skorzystania z istniejących uprawnień plikowych i sieciowych. Jeśli już posiadasz współdzielony sieciowy system plików, do którego Twój zespół posiada dostęp, konfiguracja takiego repozytorium jest bardzo prosta. Umieszczasz kopię czystego repozytorium w miejscu, do którego każdy zainteresowany ma dostęp i ustawiasz prawa odczytu/zapisu tak samo jak do każdego innego współdzielonego zasobu. Informacja o tym jak w tym celu wyeksportować czyste repozytorium znajduje się w następnej części "Konfiguracja Git na serwerze".

Opcja ta jest interesująca także w przypadku, gdy chcemy szybko pobrać zmiany z czyjegoś repozytorium. Jeśli działasz z kimś w tym samym projekcie i ktoś chce pokazać Ci swoje zmiany, wykonanie polecenia `git pull /home/john/project` jest często prostsze od czekania aż ktoś wypchnie zmiany na serwer, aby później je stamtąd pobrać.

#### Wady ####

Wadą tej metody jest to, że współdzielony dostęp plikowy dla wielu osób jest zwykle trudniejszy w konfiguracji niż prosty dostęp sieciowy. Jeśli chcesz pchać swoje zmiany z laptopa z domu, musisz zamontować zdalny dysk, co może być trudniejsze i wolniejsze niż dostęp sieciowy.

Warto również wspomnieć, że korzystanie z pewnego rodzaju sieciowego zasobu współdzielonego niekoniecznie jest najszybszą metodą dostępu. Lokalne repozytorium jest szybkie tylko wtedy, gdy masz szybki dostęp do danych. Repozytorium umieszczone w zasobie NFS jest często wolniejsze od repozytorium udostępnianego po SSH nawet jeśli znajduje się na tym samym serwerze, a jednocześnie pozwala na korzystanie z Git na lokalnych dyskach w każdym z systemów.

### Protokół SSH ###

SSH to prawdopodobnie najczęściej wykorzystywany protokół transportowy dla Git. Powodem jest fakt, że większość serwerów posiada już istniejącą konfigurację SSH, a jeśli nie, nie jest problemem utworzenie takiej konfiguracji. SSH to także jedyny sieciowy protokół, który pozwala na równie łatwy odczyt jak i zapis. Pozostałe protokoły sieciowe (HTTP i Git) są generalnie tylko do odczytu danych, zatem jeśli masz je skonfigurowane dla szarych użytkowników, nadal będzie Ci potrzebny protokół SSH, abyś mógł cokolwiek zapisać w zdalnym repozytorium. SSH posiada także wbudowane mechanizmy uwierzytelnienia; a ponieważ jest powszechnie wykorzystywany, jest prosty w konfiguracji i użyciu.

Aby sklonować repozytorium Git po SSH, użyj przedrostka `ssh://` jak poniżej:

    $ git clone ssh://user@server:project.git

Możesz także nie określać protokołu - Git zakłada właśnie SSH, jeśli go nie określisz:
   
    $ git clone user@server:project.git

Możesz także określić użytkownika - Git zakłada użytkownika na którego jesteś aktualnie zalogowany.

#### Zalety ####

Istnieje wiele zalet korzystania z SSH. Po pierwsze, w zasadzie nie ma innego wyjścia, jeśli wymagany jest uwierzytelniony dostęp podczas zapisu do repozytorium przez sieć. Po drugie - demony SSH są powszechnie wykorzystywane, wielu administratorów sieciowych jest doświadczonych w ich administracji, a wiele systemów operacyjnych posiada je zainstalowane standardowo, bądź zawiera niezbędne do ich zarządzania narzędzia. Dodatkowo, ostęp po SSH jest bezpieczny - cała transmisja jest szyfrowana i uwierzytelniona. Wreszcie, podobnie jak w protokołach Git i lokalnym, SSH jest protokołem efektywnym i pozwalającym na najbardziej optymalny transfer danych z punktu widzenia przepustowości.

#### Wady ####

Wadą dostępu po SSH jest to, że nie istnieje dostęp anonimowy do repozytorium. Programiści muszą posiadać dostęp do serwera po SSH nawet gdy chcą jedynie odczytać dane z repozytorium, co sprawia, że taki rodzaj dostępu nie jest interesujący z punktu widzenia projektów Open Source. Jeśli korzystasz z SSH wyłącznie w sieci korporacyjnej firmy, SSH z powodzeniem może być jedynym protokołem dostępu. Jeśli konieczny jest anonimowy dostęp do projektów tylko do odczytu, SSH jest potrzebny by pchać do nich zmiany, ale do pobierania danych przez innych wymagany jest inny rodzaj dostępu.

### Protokół Git ###

Następnie mamy protokół Git. To specjalny rodzaj procesu demona, który dostępny jest w pakiecie z Gitem; słucha na dedykowanym porcie (9418) i udostępnia usługi podobne do protokołu SSH, ale całkowicie bez obsługi uwierzytelnienia. Aby repozytorium mogło być udostępnione po protokole Git konieczne jest utworzenie pliku `git-export-daemon-ok` - bez niego demon nie udostępni repozytorium - ale to jedyne zabezpieczenie. Albo wszyscy mogą klonować dane repozytorium, albo nikt. Generalnie oznacza to że nie można pchać zmian po tym protokole. Można włączyć taką możliwość; ale biorąc pod uwagę brak mechanizmów uwierzytelniania, jeśli włączysz możliwość zapisu, każdy w Internecie, kto odkryje adres Twojego projektu może pchać do niego zmiany. Wystarczy powiedzieć, że nie spotyka się często takich sytuacji.

#### Zalety ####

Protokół Git to najszybszy dostępny protokół dostępu. Jeśli obsługujesz duży ruch sieciowy w publicznie dostępnych projektach, albo udostępniasz spory projekt, który nie wymaga uwierzytelniania dla dostępu tylko do odczytu, bardzo prawdopodobne jest, że skorzystasz w tym celu z demona Git. Korzysta on z tych samych mechanizmów transferu danych jak protokół SSH, ale bez narzutów związanych z szyfrowaniem i uwierzytelnieniem.

#### Wady ####

Wadą protokołu Git jest brak mechanizmów uwierzytelniania. Zwykle nie jest wskazane, by był to jedyny protokół dostępu do repozytoriów Git. Najczęściej stosuje się go wraz z protokołem SSH, który obsługuje zapis (pchanie zmian), podczas gdy odczyt przez wszystkich odbywa się z wykorzystaniem `git://`.
Prawdopodobnie jest to także protokół najtrudniejszy w konfiguracji. Musi działać w procesie dedykowanego demona - przyjrzymy się takiej konfiguracji w części "Gitosis" niniejszego rozdziału - wymaga konfiguracji `xinetd` lub analogicznej, co nie zawsze jest trywialne. Wymaga również osobnej reguły dla firewalla, który musi pozwalać na dostęp po niestandardowym porcie 9418, co zwykle nie jest proste do wymuszenia na korporacyjnych administratorach.

### Protokół HTTP/S ###

W końcu mamy protokół HTTP. Piękno protokołów HTTP i HTTPS tkwi w prostocie ich konfiguracji. Zwykle wystarczy umieścić czyste repozytorium Git poniżej katalogu głównego WWW oraz skonfigurować specjalny hook `post-update` i Voila! (Rozdział 7 zawiera szczegóły dotyczące hooków Git). Od tej chwili każdy, kto posiada dostęp do serwera WWW, w którym umieściłeś repozytorium może je sklonować. Aby umożliwić dostęp tylko do odczytu przez HTTP, wykonaj coś takiego:

    $ cd /var/www/htdocs/
    $ git clone --bare /path/to/git_project gitproject.git
    $ cd gitproject.git
    $ mv hooks/post-update.sample hooks/post-update
    $ chmod a+x hooks/post-update

I tyle. Hook `post-update`, który jest częścią Git uruchamia odpowiednie polecenie (`git update-server-info`) po to, aby pobieranie i klonowanie po HTTP działało poprawnie. To polecenie wykonywane jest, gdy do repozytorium pchasz dane po SSH; potem inni mogą sklonować je za pomocą:

    $ git clone http://example.com/gitproject.git

W tym konkretnym przypadku korzystamy ze ścieżki `/var/www/htdocs`, która jest standardowa dla serwera Apache, ale można skorzystać z dowolnego statycznego serwera WWW - wystarczy umieścić w nim czyste repozytorium. Dane Git udostępniane są jako proste pliki statyczne (Rozdział 9 zawiera więcej szczegółów na temat udostępniania danych w ten sposób).

Można również skonfigurować Git tak, by dało się pchać dane przez HTTP, choć ta technika nie jest tak często wykorzystywana i wymaga zaawansowanej konfiguracji WebDAV. Ponieważ nie spotyka się tego za często nie będziemy opisywać takiej konfiguracji w niniejszej książce. Jeśli ciekawi Cię wykorzystanie protokołów HTTP-push, możesz sprawdzić dokument znajdujący się pod adresem. Korzyścią płynącą z udostępnienia możliwości pchania zmian po HTTP jest to, że można wykorzystać w tym celu dowolny serwer WebDAV bez specyficznych funkcji Git; zatem możesz skorzystać z tej opcji, jeśli Twój provider pozwala na aktualizację Twojej witryny po WebDAV.

#### Zalety ####

Zaletą korzystania z HTTP jest prostota jego konfiguracji. Wystarczy wykonać kilka prostych poleceń i świat uzyskuje dostęp do odczytu do Twojego repozytorium Git. Potrzeba na to tylko kilku minut. Protokół HTTP nie pochłania także wielu zasobów systemowych serwera. Ponieważ zwykle wykorzystywany jest statyczny serwer HTTP, zwyczajny serwer Apache może udostępniać tysiące plików na sekundę - trudno jest przeciążyć nawet nieduży serwer.

Możesz także udostępniać repozytoria tylko do odczytu przez HTTPS, co oznacza, że możesz szyfrować dane w transmisji; możesz wręcz wymusić na klientach uwierzytelnienie za pomocą certyfikatów SSL. Jeśli jednak dojdzie aż do tego, łatwiej wykorzystać klucze publiczne SSH; ale w Twoim przypadku lepsze może się okazać wykorzystanie podpisanych certyfikatów SSL lub innej metody uwierzytelniania opartej na HTTP w celu udostępniania danych tylko do odczytu po HTTPS.

Inną korzystną cechą jest to, że HTTP jest tak powszechny, że zwykle korporacyjne firewalle nie blokują dostępu do tego portu.

#### Wady ####

Wadą udostępniania repozytorium po HTTP jest to, że ta metoda nie jest zbyt efektywna z punktu widzenia klienta. Zwykle znacznie dłużej trwa sklonowanie lub pobieranie danych z takiego repozytorium i w protokole HTTP istnieje zwykle znacznie większy narzut sieciowy oraz całkowity rozmiar przesyłanych danych niż w każdym innym protokole sieciowym. Ponieważ HTTP nie jest tak inteligentny w kwestii ograniczania przesyłania danych do tych niezbędnych, serwer HTTP nie musi wykonywać żadnych specjalnych czynności poza klasycznym udostępnianiem danych - z tego powodu protokół HTTP zwany jest _głupim_ protokołem. Więcej szczegółów na temat różnic w wydajności między protokołem HTTP i innymi protokołami znajduje się w rozdziale 9.

## Uruchomienie Git na serwerze ##

Aby wstępnie skonfigurować dowolny serwer Git należy wyeksportować istniejące repozytorium jak repozytorium czyste - takie, które nie posiada katalogu roboczego. Można to zrobić w bardzo prosty sposób.
Aby sklonować repozytorium jako nowe, czyste repozytorium, należy uruchomić polecenie `clone` z opcją `--bare`. Zgodnie z przyjętą konwencję, czyste repozytorium przechowywane jest w katalogu, którego nazwa kończy się na `.git`, np:

    $ git clone --bare my_project my_project.git
    Initialized empty Git repository in /opt/projects/my_project.git/

Informacje wyświetlane przez to polecenia mogą być mylące. Ponieważ `clone` to tak naprawdę `git init` + `git fetch`, można zobaczyć informacje wyświetlane przez część związaną z `git init`, która powoduje utworzenie pustego katalogu. Ma miejsce rzeczywiste kopiowanie obiektów, ale nie powoduje to wyświetlenia jakiejkolwiek informacji. Teraz powinieneś mieć kopię katalogu Git w katalogu `my_project.git`.

Ogólnie rzecz biorąc odpowiada to następującemu poleceniu:

    $ cp -Rf my_project/.git my_project.git

Istnieje kilka różnic w pliku konfiguracyjnym; ale dla naszych celów polecenia te wykonują te same czynności. Biorą samo repozytorium Git, bez kopii roboczej i tworzą dedykowany dla niego katalog.

### Umieszczanie czystego repozytorium na serwerze ###

Teraz, gdy posiadasz już czystą kopię repozytorium, pozostaje jedynie umieścić ją na serwerze i odpowiednio skonfigurować wybrane protokoły. Powiedzmy, że masz serwer `git.example.com`, masz do niego dostęp po SSH i chcesz, żeby wszystkie repozytoria przechowywane były w katalogu `/opt/git`. Możesz dodać nowe repozytorium kopiując tam Twoje czyste repozytorium:

    $ scp -r my_project.git user@git.example.com:/opt/git

Od tej chwili inni użytkownicy, którzy mają do tego serwera dostęp SSH oraz uprawnienia do odczytu katalogu `/opt/git` mogą sklonować Twoje repozytorium za pomocą:

    $ git clone user@git.example.com:/opt/git/my_project.git

Jeśli użytkownik może łączyć się z serwerem za pomocą SSH i ma uprawnienia do zapisu dla katalogu `/opt/git/my_project.git`, automatycznie zyskuje możliwość pchania zmian do tego repozytorium. Git automatycznie doda do katalogu dostęp do zapisu dla grupy jeśli uruchomisz polecenie `git init` z opcją `--shared`.

    $ ssh user@git.example.com
    $ cd /opt/git/my_project.git
    $ git init --bare --shared

Widać zatem, że bardzo prosto jest wziąć repozytorium Git, utworzyć jego czystą kopię i umieścić na serwerze do którego posiadasz wraz ze współpracownikami dostęp SSH. Jesteś teraz przygotowany do wspólnej pracy nad danym projektem.

Warto zaznaczyć, że to właściwie wszystko czego potrzeba, aby utworzyć działający serwer Git, do którego dostęp ma kilka osób - wystarczy utworzyć dla nich konta SSH i wstawić czyste repozytorium gdzieś, gdzie osoby te mają dostęp i uprawnienia do zapisu i odczytu. Więcej nie trzeba - można działać.

W następnych sekcjach zobaczysz jak przeprowadzić bardziej zaawansowaną konfigurację. Sprawdzimy jak uniknąć konieczności tworzenia kont użytkowników dla każdej osoby, jak dodać publiczny dostęp tylko do odczytu, jak skonfigurować interfejs WWW, jak wykorzystać narzędzie Gitosis i inne. Miej jednak na uwadzę, że do pracy nad prywatnym projektem w kilka osób, _wszystko_, czego potrzeba to serwer z dostępem SSH i czyste repozytorium.

### Prosta konfuguracja ###

Jeśli pracujesz w niewielkim zespole, albo testujesz Git w firmie i nie masz wielu programistów, wszystko jest proste. Jednym z najbardziej skomplikowanych aspektów konfiguracji serwera Git jest zarządzanie użytkownikami. Jeśli chcesz udostępnić niektóre repozytoria tylko do odczytu dla wybranych użytkowników, a pozwolić innym na zapis do nich, mogą pojawić się problemy z poprawną konfiguracją uprawnień.

#### Dostęp SSH ####

Jeśli już masz serwer, do którego wszyscy programiści mają dostęp SSH najprościej jest właśnie na nim stworzyć pierwsze repozytorium, ponieważ nie wymaga to praktycznie żadnej pracy (jak opisaliśmy to w poprzedniej sekcji). Jeśli potrzebujesz bardziej wyrafinowanej konfiguracji uprawnień dla repozytoriów możesz skorzystać z normalnych uprawnień systemu plików Twojego systemu operacyjnego.

Jeśli zamierzasz umieścić Twoje repozytoria na serwerze, w którym nie istnieją konta użytkowników dla wszystkich osób z zespołu, którym chcesz nadać uprawnienia do zapisu, będziesz musiał dodać im możliwość dostępu po SSH. Zakładamy oczywiście, że na serwerze, na którym chcesz przechowywać repozytoria Git ma już zainstalowany serwer SSH i właśnie w ten sposób uzyskujesz do niego dostęp.

Istnieje kilka sposobów pozwolenia na dostęp osobom z zespołu. Pierwszym z nich jest utworzenie dla wszystkich kont użytkowników. Jest to prosta, ale żmudna czynność. Niekoniecznie możesz mieć ochotę wywoływania wiele razy `adduser` oraz ustawiania haseł tymczasowych dla każdego użytkownika.

Drugi sposób polega na utworzeniu jednego konta użytkownika `git` oraz poproszeniu każdego użytkownika, który ma mieć dostęp do zapisu, by przesłał Ci swój publiczny klucz SSH. Nadesłane klucze należy dodać do pliku `~/.ssh/authorized_keys` w katalogu domowym użytkownika `git`. Od tej chwili każda z osób będzie miała dostęp do serwera jako użytkownik `git`. Nie powoduje to bynajmniej problemów z danymi w commitach - użytkownik SSH, na którego się logujesz nie jest używany do generowania tych danych.

Można jeszcze skonfigurować serwer SSH tak, aby dane uwierzytelniające przechowywane były na serwerze LDAP, albo w innym miejscu do tego przeznaczonym, które możesz posiadać w firmie. Jeśli tylko użytkownik ma dostęp do powłoki systemu każdy mechanizm uwierzytelniania SSH powinien działać.

## Generacja pary kluczy SSH ##

Jak wspomniano wcześniej, wiele serwerów Git korzysta z uwierzytelnienia za pomocą kluczy publicznych SSH. Aby dostarczyć na serwer klucz publiczny SSH, każdy z użytkowników musi go wygenerować jeśli jeszcze takiego nie posiada. W każdym z systemów operacyjnych proces ten wygląda podobnie.
Po pierwsze należy sprawdzić, czy już nie posiadasz takiego klucza. Domyślnie klucze SSH użytkownika przechowywane są w katalogu domowym, w podkatalogu `.ssh`. Łatwo sprawdzić, czy masz już taki klucz wyświetlając zawartość tego katalogu:

    $ cd ~/.ssh
    $ ls
    authorized_keys2  id_dsa       known_hosts
    config            id_dsa.pub

Interesuje Cię para plików nazwanych `coś` oraz `coś.pub`, gdzie to `coś` to zwykle `id_dsa` albo `id_rsa`. Plik z rozszerzeniem `.pub` to klucz publiczny, a ten drugi to klucz prywatny. Jeśli nie masz tych plików (albo w ogóle katalogu `.ssh`) możesz utworzyć parę kluczy za pomocą programu `ssh-keygen`, który jest częścią pakietu narzędzi SSH w systemach Linux albo Mac. W systemie Windows program ten jest częścią dystrybucji MSysGit:

    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /Users/schacon/.ssh/id_rsa.
    Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
    The key fingerprint is:
    43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Najpierw program pyta gdzie zapisać klucze (`.ssh/id_rsa`), a potem dwukrotnie prosi o podanie hasła, które nie jest obowiązkowe, jeśli nie masz zamiaru za każdym razem go podawać, gdy chcesz użyć klucza.

Następnie każdy użytkownik powinien wysłać Ci albo komukolwiek, kto podaje się za administratora serwera Git swój klucz publiczny (wciąż zakładając, że korzystasz z serwera SSH, który wymaga korzystania z kluczy publicznych). Aby wysłać klucz wystarczy skopiować zawartość pliku `.pub` i wkleić go do e-maila. Klucz publiczny wygląda mniej więcej tak:

    $ cat ~/.ssh/id_rsa.pub
    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
    GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
    Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
    t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
    mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
    NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Więcej szczegółów i porad dotyczących tworzenia kluczy SSH w różnych systemach operacyjnych znajduje się w witrynie GitHub w podręczniku dotyczącym kluczy SSH pod adresem `http://github.com/guides/providing-your-ssh-key`.

## Konfiguracja serwera ##

Spróbujmy więc prześledzić proces ustawienia dostępu SSH po stronie severa. Aby tego dokonać użyjesz metody 'authorized_keys' aby uwierzytelnić twoich użytkowników. Zakładamy również ze pracujesz na standardowej instalacji Linux (np. Ubuntu). Pierwszym krokiem będzie utworzenie użytkownika 'git' i lokalizacji '.ssh' dla tegoż użytkownika.

    $ sudo adduser git
    $ su git
    $ cd
    $ mkdir .ssh

Następnie potrzebujesz dodać klucz SSH programisty do pliku 'authorized_keys' dla tego użytkownika. Zauważmy ze otrzymałeś kilka kluczy mailem i zapisałeś je w pliku tymczasowym. Klucze publiczne wyglądać będą podobnie do tego:

    $ cat /tmp/id_rsa.john.pub
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
    ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
    Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
    Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
    O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
    dAv8JggJICUvax2T9va5 gsg-keypair

Załączasz do nich twój plik 'authorized keys':

    $ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
    $ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
    $ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Od tego momentu możesz ustawić puste repozytorium poprzez komendę 'git init' z opcja '--bare', która zainicjuje repozytorium bez ścieżki roboczej:

    $ cd /opt/git
    $ mkdir project.git
    $ cd project.git
    $ git --bare init

Teraz John, Josie lub Jessica ma mozliwosc wykonania komedy push (wysłania) pierwszej wersji projektu do repozytorium poprzez dodanie go (projektu) jako zdalny (remote) oraz wysłanie całej gałęzi projektu. Aby tego dokonać należny polaczyc sie poprzez shell z maszyna i utworzyc nowe repozytorium za kazdym razem kiedy chcemy dodac projekt. Użyjmy `gitserver` jako nazwę severa na którym ustawiasz użytkownika `git` oraz repozytorium. Jeżeli odpalasz je lokalnie i ustawiasz DNS jako `gitserver` do połączenia z tym serwerem, wtedy będziesz mógł użyć poniższych komend:

    # on Johns computer
    $ cd myproject
    $ git init
    $ git add .
    $ git commit -m 'initial commit'
    $ git remote add origin git@gitserver:/opt/git/project.git
    $ git push origin master

W tym momencie użytkownicy mogą klonować (clone) projekt i wysyłać (push) zmiany w prosty sposób:

    $ git clone git@gitserver:/opt/git/project.git
    $ vim README
    $ git commit -am 'fix for the README file'
    $ git push origin master

Używając powyższej metody możesz łatwo utworzyć serwer Git (odczyt/zapis) dla grupki użytkowników.

Jako dodatkowy srodek ostroznosci mozesz zastrzec dostep do komend dla danego uzytkownika `git` poprzez narzedzie `git-shell` ktore dostepne jest wraz z Git. Jezeli ustawisz je jako shell do logowania dla twojego danego uzytkownika, to ten uzytkownik nie bedzie mial dostepu do pelnego dostepu do twojego serwera. Aby uzyc tej opcji ustaw `git-shell` zamiast bash lub csh dla shellu tegoz uzytkownika. Aby to zrobic edytuj plik `/etc/passwd`:

    $ sudo vim /etc/passwd

Gdzieś na dole znajdziesz linie podobna do poniższej:

    git:x:1000:1000::/home/git:/bin/sh

Zamien `/bin/sh` na `/usr/bin/git-shell` (lub odpal  `which git-shell` aby znaleźć lokalizacje). Linia podobna byc podobna do poniższej:

    git:x:1000:1000::/home/git:/usr/bin/git-shell

Teraz uzytkownik `git` moze uzyc polaczenia SSH tylko do wyslania i odebrania repozytorium Git, nie możne natomiast zyskać dostępu shell do servera. Serwer odpowie informacja podobna do:

    $ ssh git@gitserver
    fatal: What do you think I am? A shell?
    Connection to gitserver closed.

## Public Access ##

What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

First you need to enable the hook:

    $ cd project.git
    $ mv hooks/post-update.sample hooks/post-update
    $ chmod a+x hooks/post-update

If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently.

What does this `post-update` hook do? It looks basically like this:

    $ cat .git/hooks/post-update
    #!/bin/sh
    exec git-update-server-info

This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.

Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

    <VirtualHost *:80>
        ServerName git.gitserver
        DocumentRoot /opt/git
        <Directory /opt/git/>
            Order allow, deny
            allow from all
        </Directory>
    </VirtualHost>

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:

    $ chgrp -R www-data /opt/git

When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:

    $ git clone http://git.gitserver/project.git

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png
Figure 4-1. The GitWeb web-based user interface.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

    $ git instaweb --httpd=webrick
    [2009-02-21 10:02:21] INFO  WEBrick 1.3.1
    [2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

    $ git instaweb --httpd=webrick --stop

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

    $ git clone git://git.kernel.org/pub/scm/git/git.git
    $ cd git/
    $ make GITWEB_PROJECTROOT="/opt/git" \
            prefix=/usr gitweb/gitweb.cgi
    $ sudo cp -Rf gitweb /var/www/

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

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

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

    $ apt-get install python-setuptools

Next, you clone and install Gitosis from the project’s main site:

    $ git clone git://eagain.net/gitosis.git
    $ cd gitosis
    $ sudo python setup.py install

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

    $ ln -s /opt/git /home/git/repositories

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

    $ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

    git:x:1000:1000::/home/git:/usr/bin/git-shell

back to this:

    git:x:1000:1000::/home/git:/bin/sh

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

    $ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
    Initialized empty Git repository in /opt/git/gitosis-admin.git/
    Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

    $ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

    $ ssh git@gitserver
    PTY allocation request failed on channel 0
    fatal: unrecognized command 'gitosis-serve schacon@quaternion'
      Connection to gitserver closed.

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

    # on your local computer
    $ git clone git@gitserver:gitosis-admin.git

Now you have a directory named `gitosis-admin`, which has two major parts:

    $ cd gitosis-admin
    $ find .
    ./gitosis.conf
    ./keydir
    ./keydir/scott.pub

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

    $ cat gitosis.conf
    [gitosis]

    [group gitosis-admin]
    writable = gitosis-admin
    members = scott

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

    [group mobile]
    writable = iphone_project
    members = scott

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

    $ git commit -am 'add iphone_project and mobile group'
    [master]: created 8962da8: "changed name"
     1 files changed, 4 insertions(+), 0 deletions(-)
    $ git push
    Counting objects: 5, done.
    Compressing objects: 100% (2/2), done.
    Writing objects: 100% (3/3), 272 bytes, done.
    Total 3 (delta 1), reused 0 (delta 0)
    To git@gitserver:/opt/git/gitosis-admin.git
       fb27aec..8962da8  master -> master

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

    $ git remote add origin git@gitserver:iphone_project.git
    $ git push origin master
    Initialized empty Git repository in /opt/git/iphone_project.git/
    Counting objects: 3, done.
    Writing objects: 100% (3/3), 230 bytes, done.
    Total 3 (delta 0), reused 0 (delta 0)
    To git@gitserver:iphone_project.git
     * [new branch]      master -> master

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

    $ cp /tmp/id_rsa.john.pub keydir/john.pub
    $ cp /tmp/id_rsa.josie.pub keydir/josie.pub
    $ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

    [group mobile]
    writable = iphone_project
    members = scott john josie jessica

After you commit and push that change, all four users will be able to read from and write to that project.

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

    [group mobile]
    writable = iphone_project
    members = scott josie jessica

    [group mobile_ro]
    readonly = iphone_project
    members = john

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

    [group mobile_committers]
    members = scott josie jessica

    [group mobile]
    writable  = iphone_project
    members   = @mobile_committers

    [group mobile_2]
    writable  = another_iphone_project
    members   = @mobile_committers john

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

## Gitolite ##

Git has started to become very popular in corporate environments, which tend to have some additional requirements in terms of access control.  Gitolite was created to help with those requirements.

Gitolite allows you to specify permissions not just by repository (like Gitosis does), but also by branch or tag names within each repository.  That is, you can specify that certain people (or groups of people) can only push certain "refs" (branches or tags) but not others.

### Installing ###

Installing Gitolite is very easy, even if you don't read the extensive documentation that comes with it.  You need an account on a Unix server of some kind; various Linux flavours, and Solaris 10, have been tested.  You do not need root access, assuming git, perl, and an openssh compatible ssh server are already installed.  In the examples below, we will use the `gitolite` account on a host called `gitserver`.

Curiously, Gitolite is installed by running a script *on the workstation*, so your workstation must have a bash shell available.  Even the bash that comes with msysgit will do, in case you're wondering.

You start by obtaining public key based access to your server, so that you can log in from your workstation to the server without getting a password prompt.  The following method works on Linux; for other workstation OSs you may have to do this manually.  We assume you already had a key pair generated using `ssh-keygen`.

    $ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

This will ask you for the password to the gitolite account, and then set up public key access.  This is **essential** for the install script, so check to make sure you can run a command without getting a password prompt:

    $ ssh gitolite@gitserver pwd
    /home/gitolite

Next, you clone Gitolite from the project's main site and run the "easy install" script (the third argument is your name as you would like it to appear in the resulting gitolite-admin repository):

    $ git clone git://github.com/sitaramc/gitolite
    $ cd gitolite/src
    $ ./gl-easy-install -q gitolite gitserver sitaram

And you're done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in the home directory of your workstation.  You administer your gitolite setup by making changes to this repository and pushing (just like Gitosis).

[By the way, *upgrading* gitolite is also done the same way.  Also, if you're interested, run the script without any arguments to get a usage message.]

That last command does produce a fair amount of output, which might be interesting to read.  Also, the first time you run this, a new keypair is created; you will have to choose a passphrase or hit enter for none.  Why a second keypair is needed, and how it is used, is explained in the "ssh troubleshooting" document that comes with Gitolite.  (Hey the documentation has to be good for *something*!)

### Customising the Install ###

While the default, quick, install works for most people, there are some ways to customise the install if you need to.  If you omit the `-q` argument, you get a "verbose" mode install -- detailed information on what the install is doing at each step.  The verbose mode also allows you to change certain server-side parameters, such as the location of the actual repositories, by editing an "rc" file that the server uses.  This "rc" file is liberally commented so you should be able to make any changes you need quite easily, save it, and continue.  This file also contains various settings that you can change to enable or disable some of gitolite's advanced features.

### Config File and Access Control Rules ###

So once the install is done, you switch to the `gitolite-admin` repository (placed in your HOME directory) and poke around to see what you got:

    $ cd ~/gitolite-admin/
    $ ls
    conf/  keydir/
    $ find conf keydir -type f
    conf/gitolite.conf
    keydir/sitaram.pub
    $ cat conf/gitolite.conf
    #gitolite conf
    # please see conf/example.conf for details on syntax and features

    repo gitolite-admin
        RW+                 = sitaram

    repo testing
        RW+                 = @all

Notice that "sitaram" (the last argument in the `gl-easy-install` command you gave earlier) has read-write permissions on the `gitolite-admin` repository as well as a public key file of the same name.

The config file syntax for Gitolite is *quite* different from Gitosis.  Again, this is liberally documented in `conf/example.conf`, so we'll only mention some highlights here.

You can group users or repos for convenience.  The group names are just like macros; when defining them, it doesn't even matter whether they are projects or users; that distinction is only made when you *use* the "macro".

    @oss_repos      = linux perl rakudo git gitolite
    @secret_repos   = fenestra pear

    @admins         = scott     # Adams, not Chacon, sorry :)
    @interns        = ashok     # get the spelling right, Scott!
    @engineers      = sitaram dilbert wally alice
    @staff          = @admins @engineers @interns

You can control permissions at the "ref" level.  In the following example, interns can only push the "int" branch.  Engineers can push any branch whose name starts with "eng-", and tags that start with "rc" followed by a digit.  And the admins can do anything (including rewind) to any ref.

    repo @oss_repos
        RW  int$                = @interns
        RW  eng-                = @engineers
        RW  refs/tags/rc[0-9]   = @engineers
        RW+                     = @admins

The expression after the `RW` or `RW+` is a regular expression (regex) that the refname (ref) being pushed is matched against.  So we call it a "refex"!  Of course, a refex can be far more powerful than shown here, so don't overdo it if you're not comfortable with perl regexes.

Also, as you probably guessed, Gitolite prefixes `refs/heads/` as a syntactic convenience if the refex does not begin with `refs/`.

An important feature of the config file's syntax is that all the rules for a repository need not be in one place.  You can keep all the common stuff together, like the rules for all `oss_repos` shown above, then add specific rules for specific cases later on, like so:

    repo gitolite
        RW+                     = sitaram

That rule will just get added to the ruleset for the `gitolite` repository.

At this point you might be wondering how the access control rules are actually applied, so let's go over that briefly.

There are two levels of access control in gitolite.  The first is at the repository level; if you have read (or write) access to *any* ref in the repository, then you have read (or write) access to the repository.  This is the only access control that Gitosis had.

The second level, applicable only to "write" access, is by branch or tag within a repository.  The username, the access being attempted (`W` or `+`), and the refname being updated are known.  The access rules are checked in order of appearance in the config file, looking for a match for this combination (but remember that the refname is regex-matched, not merely string-matched).  If a match is found, the push succeeds.  A fallthrough results in access being denied.

### Advanced Access Control with "deny" rules ###

So far, we've only seen permissions to be one or `R`, `RW`, or `RW+`.  However, gitolite allows another permission: `-`, standing for "deny".  This gives you a lot more power, at the expense of some complexity, because now fallthrough is not the *only* way for access to be denied, so the *order of the rules now matters*!

Let us say, in the situation above, we want engineers to be able to rewind any branch *except* master and integ.  Here's how to do that:

        RW  master integ    = @engineers
        -   master integ    = @engineers
        RW+                 = @engineers

Again, you simply follow the rules top down until you hit a match for your access mode, or a deny.  Non-rewind push to master or integ is allowed by the first rule.  A rewind push to those refs does not match the first rule, drops down to the second, and is therefore denied.  Any push (rewind or non-rewind) to refs other than master or integ won't match the first two rules anyway, and the third rule allows it.

### Restricting pushes by files changed ###

In addition to restricting what branches a user can push changes to, you can also restrict what files they are allowed to touch.  For example, perhaps the Makefile (or some other program) is really not supposed to be changed by just anyone, because a lot of things depend on it or would break if the changes are not done *just right*.  You can tell gitolite:

    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

This powerful feature is documented in `conf/example.conf`.

### Personal Branches ###

Gitolite also has a feature called "personal branches" (or rather, "personal branch namespace") that can be very useful in a corporate environment.

A lot of code exchange in the git world happens by "please pull" requests.  In a corporate environment, however, unauthenticated access is a no-no, and a developer workstation cannot do authentication, so you have to push to the central server and ask someone to pull from there.

This would normally cause the same branch name clutter as in a centralised VCS, plus setting up permissions for this becomes a chore for the admin.

Gitolite lets you define a "personal" or "scratch" namespace prefix for each developer (for example, `refs/personal/<devname>/*`), with full permissions for that dev only, and read access for everyone else.  Just choose a verbose install and set the `$PERSONAL` variable in the "rc" file to `refs/personal`.  That's all; it's pretty much fire and forget as far as the admin is concerned, even if there is constant churn in the project team composition.

### "Wildcard" repositories ###

Gitolite allows you to specify repositories with wildcards (actually perl regexes), like, for example `assignments/s[0-9][0-9]/a[0-9][0-9]`, to pick a random example.  This is a *very* powerful feature, which has to be enabled by setting `$GL_WILDREPOS = 1;` in the rc file.  It allows you to assign a new permission mode ("C") which allows users to create repositories based on such wild cards, automatically assigns ownership to the specific user who created it, allows him/her to hand out R and RW permissions to other users to collaborate, etc.  This feature is documented in `doc/4-wildcard-repositories.mkd`.

### Other Features ###

We'll round off this discussion with a bunch of other features, all of which are described in great detail in the "faqs, tips, etc" document.

**Logging**: Gitolite logs all successful accesses.  If you were somewhat relaxed about giving people rewind permissions (`RW+`) and some kid blew away "master", the log file is a life saver, in terms of easily and quickly finding the SHA that got hosed.

**Git outside normal PATH**: One extremely useful convenience feature in gitolite is support for git installed outside the normal `$PATH` (this is more common than you think; some corporate environments or even some hosting providers refuse to install things system-wide and you end up putting them in your own directories).  Normally, you are forced to make the *client-side* git aware of this non-standard location of the git binaries in some way.  With gitolite, just choose a verbose install and set `$GIT_PATH` in the "rc" files.  No client-side changes are required after that :-)

**Access rights reporting**: Another convenient feature is what happens when you try and just ssh to the server.  Older versions of gitolite used to complain about the `SSH_ORIGINAL_COMMAND` environment variable being empty (see the ssh documentation if interested).  Now Gitolite comes up with something like this:

    hello sitaram, the gitolite version here is v0.90-9-g91e1e9f
    you have the following permissions:
      R     anu-wsd
      R     entrans
      R  W  git-notes
      R  W  gitolite
      R  W  gitolite-admin
      R     indic_web_input
      R     shreelipi_converter

**Delegation**: For really large installations, you can delegate responsibility for groups of repositories to various people and have them manage those pieces independently.  This reduces the load on the main admin, and makes him less of a bottleneck.  This feature has its own documentation file in the `doc/` directory.

**Gitweb support**: Gitolite supports gitweb in several ways.  You can specify which repos are visible via gitweb.  You can set the "owner" and "description" for gitweb from the gitolite config file.  Gitweb has a mechanism for you to implement access control based on HTTP authentication, so you can make it use the "compiled" config file that gitolite produces, which means the same access control rules (for read access) apply for gitweb and gitolite.

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

    git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

    /etc/event.d/local-git-daemon

you put this script:

    start on startup
    stop on shutdown
    exec /usr/bin/git daemon \
        --user=git --group=git \
        --reuseaddr \
        --base-path=/opt/git/ \
        /opt/git/
    respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories — you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

    initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

    [repo iphone_project]
    daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

    $ cd /path/to/project.git
    $ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

    $projects_list = "/home/git/gitosis/projects.list";
    $projectroot = "/home/git/repositories";
    $export_ok = "git-daemon-export-ok";
    @git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

    [repo iphone_project]
    daemon = yes
    gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

    http://git.or.cz/gitwiki/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved.

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page.

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png
Figure 4-3. The GitHub user signup form.

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png
Figure 4-4. The GitHub user dashboard.

Next you can create a new repository.

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png
Figure 4-5. Creating a new repository on GitHub.

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png
Figure 4-6. GitHub project header information.

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png
Figure 4-7. Instructions for a new repository.

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

    $ git init
    $ git add .
    $ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

    $ git remote add origin git@github.com:testinguser/iphone_project.git
    $ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png
Figure 4-8. Project header with a public URL and a private URL.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png
Figure 4-9. Subversion importing interface.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png
Figure 4-10. GitHub administration page.

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png
Figure 4-11. Adding a collaborator to your project.

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png
Figure 4-12. A list of collaborators on your project.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png
Figure 4-13. A GitHub main project page.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png
Figure 4-15. Your fork of a project.

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.

