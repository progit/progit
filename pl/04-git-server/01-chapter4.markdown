# Git na serwerze #

Powinieneś być już w stanie realizować większość codziennych zadań podczas pracy z Git. Jednakże do współpracy z innymi potrzebne będzie zdalne repozytorium Git. Choć, technicznie rzecz biorąc, możesz pchać zmiany i pobierać je z repozytoriów pojedynczych osób, nie jest to zalecana technika, ponieważ jeśli nie jest się ostrożnym, bardzo łatwo zrobić bałagan w czyjejś pracy. Dodatkowo niezbędny jest dostęp do Twojego repozytorium przez innych nawet gdy nie masz połączenia z siecią - bardzo przydatne jest posiadanie wiarygodnego, wspólnego repozytorium. Z tego powodu zalecaną metodą współpracy z innymi jest stworzenie pośredniego repozytorium, do którego wszyscy mają dostęp i wykonywanie operacji pchania i pobierania danych właśnie z niego. Nazwiemy to repozytorium "serwerem Git"; zobaczysz jednak że obsługa repozytorium Git zabiera zwykle bardzo niewiele zasobów systemowych przez co bardzo rzadko potrzebne będzie wydzielenie w tym celu dedykowanego serwera.

Zarządzanie serwerem Git jest proste. Po pierwsze określasz protokoły dostępu do tego serwera. Pierwsza część tego rozdziału zawiera informacje o dostępnych protokołach oraz ich wadach i zaletach. Kolejna część zawiera opis typowych konfiguracji wykorzystujących te protokoły oraz opis właściwych ustawień serwera. W końcu opiszemy dostępne opcje hostingu, jeśli nie przeszkadza Ci przechowywanie kodu na obcym serwerze i nie masz ochoty na tworzenie i zarządzanie własnym serwerem.

Jeśli nie masz zamiaru tworzyć własnego serwera możesz przejść od razu do ostatniej części tego rozdziału, aby sprawdzić dostępne możliwości tworzenia konta w zewnętrznej usłudze, a następnie możesz przejść do kolejnego rozdziału, który zawiera dyskusję na temat różnych aspektów pracy w rozproszonym środowisku kontroli wersji.

Zdalne repozytorium to nic innego jak samo repozytorium bez kopii roboczej (ang. _bare repository_). Ponieważ repozytorium to jest wykorzystywane wyłącznie jako miejsce współpracy, nie ma potrzeby by na dysku istniała migawka jakiejkolwiek wersji; to po prostu dane Git. Mówiąc krótko - takie repozytorium to wyłącznie zawartość katalogu `.git`.

## Protokoły ##

Git potrafi korzystać z czterech podstawowych protokołów sieciowych do przesyłu danych: lokalnego, Secure Shell (SSH), Git, oraz HTTP. Poniżej opiszemy czym się charakteryzują i w jakich sytuacjach warto korzystać (lub wręcz przeciwnie) z jednego z nich.

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

    $ git clone ssh://user@server/project.git

Możesz także nie określać protokołu - Git zakłada właśnie SSH, jeśli go nie określisz:
   
    $ git clone user@server:project.git

Możesz także określić użytkownika - Git zakłada użytkownika na którego jesteś aktualnie zalogowany.

#### Zalety ####

Istnieje wiele zalet korzystania z SSH. Po pierwsze, w zasadzie nie ma innego wyjścia, jeśli wymagany jest uwierzytelniony dostęp podczas zapisu do repozytorium przez sieć. Po drugie - demony SSH są powszechnie wykorzystywane, wielu administratorów sieciowych jest doświadczonych w ich administracji, a wiele systemów operacyjnych posiada je zainstalowane standardowo, bądź zawiera niezbędne do ich zarządzania narzędzia. Dodatkowo, dostęp po SSH jest bezpieczny - cała transmisja jest szyfrowana i uwierzytelniona. Wreszcie, podobnie jak w protokołach Git i lokalnym, SSH jest protokołem efektywnym i pozwalającym na optymalny transfer danych z punktu widzenia przepustowości.

#### Wady ####

Wadą dostępu po SSH jest to, że nie istnieje dostęp anonimowy do repozytorium. Programiści muszą posiadać dostęp do serwera po SSH nawet gdy chcą jedynie odczytać dane z repozytorium, co sprawia, że taki rodzaj dostępu nie jest interesujący z punktu widzenia projektów Open Source. Jeśli korzystasz z SSH wyłącznie w sieci korporacyjnej firmy, SSH z powodzeniem może być jedynym protokołem dostępu. Jeśli konieczny jest anonimowy dostęp do projektów tylko do odczytu, SSH jest potrzebny by pchać do nich zmiany, ale do pobierania danych przez innych wymagany jest inny rodzaj dostępu.

### Protokół Git ###

Następnie mamy protokół Git. To specjalny rodzaj procesu demona, który dostępny jest w pakiecie z Gitem; słucha na dedykowanym porcie (9418) i udostępnia usługi podobne do protokołu SSH, ale całkowicie bez obsługi uwierzytelnienia. Aby repozytorium mogło być udostępnione po protokole Git konieczne jest utworzenie pliku `git-daemon-export-ok` - bez niego demon nie udostępni repozytorium - ale to jedyne zabezpieczenie. Albo wszyscy mogą klonować dane repozytorium, albo nikt. Generalnie oznacza to że nie można pchać zmian po tym protokole. Można włączyć taką możliwość; ale biorąc pod uwagę brak mechanizmów uwierzytelniania, jeśli włączysz możliwość zapisu, każdy w Internecie, kto odkryje adres Twojego projektu może pchać do niego zmiany. Wystarczy powiedzieć, że nie spotyka się często takich sytuacji.

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

Można również skonfigurować Git tak, by dało się pchać dane przez HTTP, choć ta technika nie jest tak często wykorzystywana i wymaga zaawansowanej konfiguracji WebDAV. Ponieważ nie spotyka się tego za często nie będziemy opisywać takiej konfiguracji w niniejszej książce. Jeśli ciekawi Cię wykorzystanie protokołów HTTP-push, możesz sprawdzić dokument znajdujący się pod adresem `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. Korzyścią płynącą z udostępnienia możliwości pchania zmian po HTTP jest to, że można wykorzystać w tym celu dowolny serwer WebDAV bez specyficznych funkcji Git; zatem możesz skorzystać z tej opcji, jeśli Twój dostawca pozwala na aktualizację Twojej witryny po WebDAV.

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

Informacje wyświetlane przez to polecenie mogą być mylące. Ponieważ `clone` to tak naprawdę `git init` + `git fetch`, można zobaczyć informacje wyświetlane przez część związaną z `git init`, która powoduje utworzenie pustego katalogu. Ma miejsce rzeczywiste kopiowanie obiektów, ale nie powoduje to wyświetlenia jakiejkolwiek informacji. Teraz powinieneś mieć kopię katalogu Git w katalogu `my_project.git`.

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

W następnych sekcjach zobaczysz jak przeprowadzić bardziej zaawansowaną konfigurację. Sprawdzimy jak uniknąć konieczności tworzenia kont użytkowników dla każdej osoby, jak dodać publiczny dostęp tylko do odczytu, jak skonfigurować interfejs WWW, jak wykorzystać narzędzie Gitosis i inne. Miej jednak na uwadze, że do pracy nad prywatnym projektem w kilka osób, _wszystko_, czego potrzeba to serwer z dostępem SSH i czyste repozytorium.

### Prosta konfiguracja ###

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

Spróbujmy więc prześledzić proces ustawienia dostępu SSH po stronie serwera. Aby tego dokonać użyjesz metody 'authorized_keys' aby uwierzytelnić twoich użytkowników. Zakładamy również ze pracujesz na standardowej instalacji Linux (np. Ubuntu). Pierwszym krokiem będzie utworzenie użytkownika 'git' i lokalizacji '.ssh' dla tegoż użytkownika.

    $ sudo adduser git
    $ su git
    $ cd
    $ mkdir .ssh

Następnie potrzebujesz dodać klucz SSH programisty do pliku 'authorized_keys' dla tego użytkownika. Załóżmy ze otrzymałeś kilka kluczy mailem i zapisałeś je w pliku tymczasowym. Klucze publiczne wyglądać będą podobnie do tego:

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

Teraz John, Josie lub Jessica ma możliwość wykonania komendy push (wysłania) pierwszej wersji projektu do repozytorium poprzez dodanie go (projektu) jako zdalny (remote) oraz wysłanie całej gałęzi projektu. Aby tego dokonać należy połączyć się poprzez shell z maszyną i utworzyć nowe repozytorium za każdym razem kiedy chcemy dodać projekt. Użyjmy `gitserver` jako nazwę serwera, na którym ustawisz użytkownika `git` oraz repozytorium. Jeżeli odpalasz je lokalnie i ustawiasz DNS jako `gitserver` do połączenia z tym serwerem, wtedy będziesz mógł użyć poniższych komend:

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

Jako dodatkowy środek ostrożności możesz zastrzec dostęp do komend dla danego użytkownika `git` poprzez narzędzie `git-shell`, które dostępne jest wraz z Git. Jeżeli ustawisz je jako shell do logowania dla twojego danego użytkownika, to ten użytkownik nie będzie miał pełnego dostępu do twojego serwera. Aby użyć tej opcji ustaw `git-shell` zamiast bash lub csh dla shellu tegoż użytkownika. Aby to zrobić edytuj plik `/etc/passwd`:

    $ sudo vim /etc/passwd

Gdzieś na dole znajdziesz linie podobną do poniższej:

    git:x:1000:1000::/home/git:/bin/sh

Zamień `/bin/sh` na `/usr/bin/git-shell` (lub odpal  `which git-shell` aby znaleźć lokalizację). Linia powinna być podobna do poniższej:

    git:x:1000:1000::/home/git:/usr/bin/git-shell

Teraz użytkownik `git` może użyć połączenia SSH tylko do wysłania i odebrania repozytorium Git, nie możne natomiast uzyskać dostępu do powłoki serwera. Serwer odpowie informacją podobną do:

    $ ssh git@gitserver
    fatal: What do you think I am? A shell?
    Connection to gitserver closed.

## Dostęp publiczny ##

Co jeśli chcesz anonimowego dostępu do odczytu z twojego projektu? Być może zamiast hostingu wewnętrznego, prywatnego projektu chcesz hostować projekt open source. Albo masz garść serwerów automatycznej budowy lub serwery ciągłej integracji, które często się zmieniają i nie chcesz generować cały czas kluczy SSH  - chcesz po prostu dodać prosty anonimowy dostęp odczytu.

Prawdopodobnie najprostszym sposobem dla niewielkich instalacji jest prowadzić statyczny serwer www z głównym dokumentem w miejscu gdzie są twoje repozytoria i umożliwić podpięcie `post-update`, o którym wspomnieliśmy w pierwszej sekcji tego rozdziału. Popracujmy z poprzednim przykładem. Powiedzmy, że masz swoje repozytoria w `/opt/git/` i serwer Apache działa na twoim sprzęcie. Ponownie, możesz użyć do tego każdego serwera www, ale jako przykład zaprezentujemy parę podstawowych konfiguracji Apache, które powinny dać ci obraz czego możesz potrzebować.

Na początku musisz umożliwić to podpięcie:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Jeśli używasz Gita w wersji wcześniejszej niż 1.6, polecenie `mv` nie jest konieczne — tylko w ostatnich wersjach Gita przykłady podpięć posiadają w nazwie rozszerzenie `.sample`. 

Co robi to podpięcie `post-update`? Generalnie wygląda ono tak:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

To oznacza, że kiedy wysyłasz do serwera przez SSH, Git uruchomi tę komendę, aby uaktualnić pliki potrzebne do ściągania przez HTTP.

Następnie do ustawień swojego serwera Apache musisz dodać pozycję VirtualHost z głównym dokumentem jako główny katalog twoich projektów Git. Tutaj zakładamy, ze masz ustawiony wildcard DNS do wysyłania `*.gitserver` do jakiegokolwiek pudła, którego używasz do uruchamiania tego wszystkiego:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Będziesz tez musiał ustawić unixową grupę użytkowników do ścieżki `/opt/git` na `www-data` tak aby twój serwer www mógł dokonać odczytu z repozytoriów, ponieważ instancja serwera Apache uruchamiająca skrypt CGI (domyślnie) będzie go uruchamiać jako ten użytkownik:

	$ chgrp -R www-data /opt/git

Kiedy zrestartujesz serwer Apache powinieneś móc sklonować swoje repozytoria do tego katalogu określając URL dla swojego projektu.

	$ git clone http://git.gitserver/project.git

W ten sposób możesz ustawić oparty na HTTP dostęp odczytu do swoich projektów dla sporej liczby użytkowników w kilka minut. Inną prostą opcją dla publicznego nieautoryzowanego dostępu jest uruchomienie demona Git, jednakże to wymaga zdemonizowania tego procesu - zajmiemy się tą opcją w następnej sekcji, jeśli preferujesz tę drogę.

##GitWeb##

Teraz, gdy już podstawy odczytu i zapisu są dostępne tylko dla Twojego projektu, możesz założyć prostą internetową wizualizacje. Do tego celu Git wyposażony jest w skrypt CGI o nazwie GitWeb. Jak widać GitWeb stosowany jest w miejscach takich jak:`http://git.kernel.org` (patrz rys. 4-1).

Insert 18333fig0401.png
Rysunek 4-1.GitWeb internetowy interfejs użytkownika.

Jeśli chcesz zobaczyć jak GitWeb będzie wyglądał dla Twojego projektu, Git posiada polecenie do uruchamiania tymczasowej instancji, pod warunkiem, że posiadasz lekki serwer taki jak `lighttpd` lub `webrick`. Na komputerach z zainstalowanym linuxem `lighttpd` jest bardzo często instalowany więc należy go uruchomić wpisując `git instaweb` w katalogu projektu. Jeśli używasz komputera Mac, Leopard jest automatycznie instalowany z Ruby więc `webrick` może być najlepszym rozwiązaniem. Aby rozpocząć `instaweb` bez tymczasowej instancji, należy uruchomić go z opcją `--httpd`.

	$git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Powyższe polecenie uruchamia serwer HTTPD na porcie 1234, a następnie automatycznie uruchamia przeglądarkę internetową, która otwiera się na tej stronie. Kiedy skończysz i chcesz wyłączyć serwer, użyj tego samego polecenia z opcją `--stop`

	$ git instaweb --httpd=webrick --stop

Jeśli chcesz aby uruchomiony interfejs WWW był cały czas dostępny dla Twojego zespołu lub projektu open source, będziesz musiał skonfigurować skrypt CGI dla normalnego serwera WWW. Niektóre dystrybucje linuxa mają pakiet `gitweb`, który można zainstalować przez `apt` lub `yum`, więc warto spróbować tego w pierwszej kolejności. Jeśli się nie uda to musimy zainstalować GitWeb ręcznie, co trwa tylko chwile. Najpierw musimy pobrać kod źródłowy GitWeb i wygenerować własny skrypt CGI:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
 	$ cd git/
 	$ make GITWEB_PROJECTROOT="/opt/git" \
        prefix=/usr gitweb/gitweb.cgi
 	$ sudo cp -Rf gitweb /var/www/

Zwróć uwagę że musisz ręcznie podać lokalizacje swoich repozytoriów gita w zmiennej `GITWEB_PROJECTROOT`. Następnie należy stworzyć serwer Apache używający skryptu CGI, na którym można dodać wirtualnego hosta:

	$<VirtualHost *:80>
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

GitWeb można używać z dowolnym serwerem CGI. Jeśli wolisz korzystać z czegoś innego to nie powinno być trudne do skonfigurowania. W tym momencie powinieneś być w stanie odwiedzić `http://gitserver/` w celu przeglądania repozytoriów online, a także używać `http://git.gitserver` w celu klonowania i pobierania repozytoriów HTTP.

##Gitosis##

Gdy będziemy trzymać klucze publiczne wszystkich użytkowników w pliku `authorized_keys` trzeba się liczyć, iż takie repozytorium będzie działać bardzo niestabilnie. Kiedy będziesz miał setki użytkowników, możesz napotkać pewne problemy przy zarządzaniu nimi. Za każdym razem musisz skonfigurować powłokę na serwerze w której nie masz kontroli dostępu - każdy użytkownik może zmieniać prawa dostępu do projektów.

Warto więc jednak przedstawić projekt oprogramowania wykorzystywanego na szeroką skalę o nazwie Gitosis. Gitosis to w zasadzie zestaw skryptów, który nie tylko pomoże Ci zarządzać plikiem `authorized_keys`, ale udostępnia również kilka prostych narzędzie kontroli dostępu. Ciekawostką jest fakt, iż narzędzie odpowiedzialne za dodawanie użytkowników oraz zarządzanie ich prawami nie jest aplikacją www lecz specjalnym repozytorium. Po wprowadzeniu zmian oraz ich zatwierdzeniu, Gitosis konfiguruje samodzielnie serwer, co jest bardzo wielkim udogodnieniem.

Instalacja Gitosis nie należy do najłatwiejszych, lecz nie jest skomplikowana. Jest najłatwiejsza przy wykorzystaniu systemu Linux - poniższe przykłady zostały zaimplementowane w Ubuntu ver. 8.10.

Gitosis wymaga pewnych pakietów Pythona, więc najpierw trzeba uruchomić pakiet instalacyjny Pythona:

	$ apt-get install python-setuptools

Następnie musisz skopiować oraz zainstalować pakiet Gitosis z głównej strony projektu:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Co zainstaluje kilka plików wykonywalnych, których to Gitosis potrzebuje do poprawnego działania. Gitosis będzie proponował umieścić repozytoria w `/home/git`, co jest poprawne. Lecz Twoje repozytoria są w `/opt/git`, więc zamiast konfigurować wszystko od początku najlepszym posunięciem będzie stworzenie dowiązania:

	$ ln -s /opt/git /home/git/repositories

Gitosis będzie teraz zarządzać Twoimi kluczami, więc musisz usunąć bieżący plik, następnie dodać ponownie klucze i pozwolić Gitosis na kontrole pliku `authorized_keys`. Teraz musimy przenieść plik `authorized_keys`:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak 

Kolejnym krokiem będzie zmiana powłoki na powłokę użytkownika, jeżeli zmienisz ją poleceniem `git-shell`. Ludzie wciąż nie będą mogli się zalogować, ale Gitosis będzie już ją kontrolował. Więc zmieńmy tą konkretną linię w pliku `/etc/passwd`

	git:x:1000:1000::/home/git:/usr/bin/git-shell

wróćmy do tego:

	git:x:1000:1000::/home/git:/bin/sh

Nadszedł czas, aby zainicjować Gitosis. Można to zrobić poprzez polecenie `gitosis-init` z użyciem klucza publicznego. Jeśli Twojego klucza publicznego nie ma na serwerze, musisz go tam skopiować.

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Dzięki temu użytkownik z kluczem publicznym może modyfikować repozytorium. Następnie musisz ustawić ręcznie atrybut wykonywalności w skrypcie `post-update` w celu kontroli nowego repozytorium. 

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Jeśli serwer został poprawnie skonfigurowany, możesz spróbować zalogować się jako użytkownik, do którego przypisałeś klucze publiczne dla zainicjowania Gitosis. Powinieneś zobaczyć coś takiego:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	Connection to gitserver closed.

Co oznacza, że system rozpoznał Cię lecz zamknął połączenie z powodu braku poleceń dla repozytorium. Więc spróbujmy skopiować repozytorium Gitosis:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Teraz masz katalog o nazwie `gitosis-admin`, który zawiera dwa podkatalogi:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Plik `gitosis.conf` jest odpowiedzialny za określanie użytkowników, repozytorium oraz praw dostępu. W katalogu `keydir` można przechowywać klucze publiczne dla wszystkich użytkowników, którzy mają jakikolwiek dostęp do Twojego repozytorium - jeden plik na użytkownika. Nazwa pliku w katalogu `keydir` (w poprzednim przykładzie, `scott.pub`) będzie inna w Twoim przypadku - Gitosis tworzy nazwę z dopisku na końcu klucza publicznego, który został zaimportowany razem z `gitosis-init`.

Jeżeli spojrzymy na plik `gitosis.conf`, powinien zawierać on informację o projekcie  `gitosis-admin` którego właśnie skopiowaliśmy:

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

To pokazuje, że użytkownik 'scott' - użytkownik posiadający ten sam klucz publiczny z którego został zainicjowany Gitosis jest jedynym, który posiada dostęp do projektu `gitosis-admin`.

Teraz, dodajmy nowy projekt dla Ciebie. Dodamy nową sekcję o nazwie `mobile` w której umieścisz listę programistów swojego zespołu oraz całego projektu. Ponieważ 'scott' jest tylko zwykłym użytkownikiem, musimy dodać "scotta" jako jedynego członka zespołu, następnie tworzymy nowe repozytorium o nazwie `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott

Ilekroć dokonasz zmian w projekcie `gitosis-admin`, musisz zatwierdzić oraz przesłać je z powrotem na serwer w celu aktualizacji zmian:

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

Możemy wykonać pierwszą akcję dla nowego projektu `iphone_project` poprzez dodanie swojego serwera jako zdalnego, do lokalnej wersji projektu. Nie trzeba będzie już tworzyć ręcznie pustych repozytoriów dla nowych projektów na serwerze - Gitosis będzie tworzyć je automatycznie.

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Zauważ, że nie musimy określać ścieżek (w rzeczywistości, ten sposób by nie zadziałał), po prostu użyj dwukropka, następnie nazwy projektu - Gitosis znajdzie projekt automatycznie.

Jeżeli chcesz pracować nad tym projektem wraz ze swoimi przyjaciółmi, będziesz musiał ponownie dodać ich klucze publiczne. Ale zamiast dołączać je ręcznie do pliku `~/.ssh/authorized_keys` na serwerze, dodaj je do katalogu `keydir`, każdy klucz w osobnym pliku. Spróbujmy dodać klucze publiczne dla nowych użytkowników:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Teraz możemy dodać ich wszystkich do naszego zespołu o nazwie 'mobile', w którym będą mieli prawa do zapisu jak i odczytu.

	iphone_project:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Po zatwierdzeniu i wysłaniu zmian, wszyscy czterej użytkownicy będą mieli prawa odczytu a także zapisu w tym projekcie.

Gitosis posiada bardzo łatwy i sprawny system kontroli dostępu. Jeżeli chcesz aby John posiadał tylko prawa do odczytu w zakresie tego projektu, możesz posłużyć się poniższym przykładem:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Teraz John może kopiować projekt oraz pobierać aktualizacje, ale Gitosis nie pozwoli mu cofnąć wcześniej wprowadzonych zmian. Można tworzyć wiele podobnych grup zawierających różnych użytkowników i różne projekty. Można również określić grupę dla zbioru użytkowników innej grupy (używając `@` jako prefiksu), poprzez dziedziczenie.

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Jeśli masz jakieś problemy, pomocnym może się okazać ustawienie `loglevel=DEBUG` w sekcji `[gitosis]`. Jeżeli straciłeś poprzednią konfigurację poprzez podmianę jej na niewłaściwą, możesz ręcznie naprawić plik na serwerze `/home/git/.gitosis.conf` - plik konfiguracyjny Gitosis. Wyślij plik `gitosis.conf` do wyżej wymienionego katalogu. Jeżeli chcesz edytować ten plik ręcznie, pamiętaj że pozostanie on do następnej zmiany w projekcie `gitosis-admin`.

## Gitolite ##

Uwaga: najnowsza wersja tego podrozdziału książki ProGit jest zawsze dostępna na [gitolite documentation][gldpg]. Autor pragnie również pokornie stwierdzić, że chociaż ta część jest dokładna i *może być* (i często *jest*) użyta do instalacji gitolite bez czytania jakiejkolwiek innej dokumentacji, to nie jest kompletna i nie może całkowicie zastąpić ogromnej ilości dokumentacji dołączonej do gitolite.

[gldpg]: http://github.com/sitaramc/gitolite/blob/pu/doc/progit-article.mkd

Git zaczął się stawać bardzo popularny w środowiskach korporacyjnych, które wydają się mieć pewne dodatkowe wymagania w zakresie kontroli dostępu. Gitolite został stworzony aby zaspokoić te wymagania, ale okazuje się, że jest równie przydatny w świecie open source: Fedora Project kontroluje dostęp do swoich repozytoriów dotyczących zarządzania pakietami (ponad 10.000 z nich!) za pomocą gitolite i jest to też prawdopodobnie największa instalacja gitolite gdziekolwiek.

Gitolite pozwala określać uprawnienia nie tylko poprzez repozytorium, ale także przez nazwy gałęzi lub etykiet wewnątrz każdego repozytorium. Oznacza to, że można określić czy niektóre osoby (albo grupy) mogą dodawać tylko ustalone "refs" (gałęzi lub etykiet), a innych już nie.

### Instalacja ###

Instalacja Gitolite jest bardzo prosta, nawet jeśli nie przeczyta się jego obszernej dokumentacji. Potrzebne będzie konto na jakimś Uniksowym serwerze; przetestowane zostały różne wersje Linuksa i Solaris 10. Uprawnienia administratora nie są potrzebne, zakładając, że git, perl i serwer ssh kompatybilny z openssh są już zainstalowane. W poniższych przykładach będziemy używali konta `gitolite` na serwerze o nazwie `gitserver`.

Gitolite jest dość niezwykły jak na oprogramowanie "serwerowe" -- dostęp odbywa się przez ssh, dzięki czemu każdy użytkownik na serwerze jest potencjalnym "hostem gitolite".  W rezultacie, istnieje pojęcie "instalacji" samego oprogramowania, a następnie "stworzenie" użytkownika jako "hosta gitolite".

Gitolite posiada 4 metody instalacji. Osoby korzystające z systemów Fedora czy Debian mogą go zainstalować z pakietów RPM lub DEB. Osoby z uprawnieniami administratora mogą zainstalować go ręcznie. W tych dwóch przypadkach, każdy użytkownik systemu może stać się "hostem gitolite".

Osoby bez uprawnień administratora mogą go zainstalować we własnym identyfikatorze użytkownika. I wreszcie, gitolite może być instalowany przez uruchomienie skryptu *na stacji roboczej*, z powłoki basha. (Jeśli się nad tym zastanawiasz, to nawet bash pochodzący z msysgit da radę).

W tym artykule opiszemy tą ostatnią metodę; o pozostałych metodach można poczytać w dokumentacji.

Zaczynasz od uzyskania dostępu do serwera w oparciu o klucz publiczny, dzięki czemu ze swojego komputera zalogujesz się do serwera bez podawania hasła. Poniższa metoda działa na Linuksie; na innych systemach możliwe, że trzeba będzie zrobić to ręcznie. Zakładamy, że masz już parę kluczy wygenerowanych przy użyciu `ssh-keygen`.

	$ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

Zostaniesz poproszony o podanie hasła do konta gitolite, po czym ustawiony zostanie dostęp z klucza publicznego. Jest to **kluczowe** dla skryptu instalacyjnego, więc upewnij się, że możesz uruchomić jakieś polecenie bez monitu o podanie hasła:

	$ ssh gitolite@gitserver pwd
	/home/gitolite

Następnie, trzeba sklonować Gitolite z głównej strony projektu i uruchomić skrypt "easy install" (trzeci argument to twoja nazwa w nowo powstałym repozytorium gitolite-admin):

	$ git clone git://github.com/sitaramc/gitolite
	$ cd gitolite/src
	$ ./gl-easy-install -q gitolite gitserver sitaram

I gotowe! Gitolite został zainstalowany na serwerze, a nowe repozytorium o nazwie `gitolite-admin` zostało utworzone w katalogu domowym twojej stacji roboczej. Zarządzanie gitolite odbywa się poprzez dokonywanie zmian w repozytorium i wysyłanie ich na serwer (jak w Gitosis).

Ostatnie polecenie powoduje pojawienie się sporej ilości danych wyjściowych, które mogą być ciekawe do poczytania. Ponadto, pierwsze uruchomienie tego skryptu powoduje stworzenie nowej pary kluczy; trzeba będzie wybrać hasło (passphrase) lub wcisnąć enter aby nic nie wybrać. Do czego potrzebna jest druga para kluczy i jak jest ona wykorzystywana wyjaśniono w dokumencie "ssh troubleshooting" dołączonym do Gitolite. (W końcu dokumentacja musi się do *czegoś* przydać!)

Repozytoria o nazwach `gitolite-admin` i `testing` są tworzone na serwerze domyślnie. Jeśli chcesz sklonować któreś z nich lokalnie (z konta posiadającego dostęp przez konsolę SSH, do konta gitolite, przy użyciu *authorized_keys*), wpisz:

	$ git clone gitolite:gitolite-admin
	$ git clone gitolite:testing
	
Aby sklonować te same repozytoria z jakiegokolwiek innego konta:

	$ git clone gitolite@servername:gitolite-admin
	$ git clone gitolite@servername:testing


### Dostosowywanie procesu instalacji ###

Podczas gdy domyślna szybka instalacja działa dla większości osób jest kilka sposobów na dostosowanie jej do naszych potrzeb. Jeżeli pominiesz argument `-q` przejdziesz w tryb instalacji "verbose" -- są to szczegółowe informacje krok po kroku co wykonuje instalator. Tryb "verbose" pozwala również na zmianę pewnych parametrów po stronie serwera, takich jak lokalizacja aktualnego repozytorium, poprzez edytowanie pliku "rc" który jest używany przez serwer. Ten plik jest obficie zakomentowany wiec powinieneś w prosty sposób dokonywać różnych zmian, zapisywać i kontynuować. Plik ten zawiera też różne ustawienia które pozwolą Ci na włączanie i wyłączanie niektórych zaawansowanych możliwości gitolite.

### Plik konfiguracyjny i Kontrola Praw Dostępu ###

Gdy instalacja jest ukończona przełącz się na repozytorium `gitolite-admin` (znajduję się ono w twoim katalogu HOME) i przejrzyj je aby zobaczyć co otrzymałeś.

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

Zauważ że "sitaram" (ostatni argument w komendzie `gl-easy-install` którą podałeś wcześniej) posiada prawa odczyt-zapis na repozytorium `gitolite-admin` tak samo jak klucz publiczny z tą samą nazwą.

Składnia pliku konfiguracyjnego dla gitolite jest udokumentowana w `conf/example.conf`, więc omówimy tutaj tylko najważniejsze punkty.  
Dla wygody możesz połączyć użytkowników repozytorium w grupy. Nazwy grup są jak makra: kiedy je definiujesz nie ma znaczenia czy to są użytkownicy czy projekty; to rozróżnienie jest tylko robione gdy *używasz* "macro".

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott     # Adams, not Chacon, sorry :)
	@interns        = ashok     # get the spelling right, Scott!
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

Możesz kontrolować uprawnienia na poziomie "ref". W poniższym przykładzie stażyści mogą wysyłać tylko gałęzie "int". Inżynierowie mogą wysyłać każdą gałąź której nazwa zaczyna się od znaków "eng-", i kończy etykietą zaczynającą się od znaków "rc" za którymi występują liczby dziesiętne.   

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers

	    RW+                     = @admins

Wyrażenie po `RW` lub `RW+` jest wyrażeniem regularnym (regex), według którego sprawdzane jest wysyłane "refname" (ref). Dlatego nazywamy je "refex"! Oczywiście refex jest potężniejsze niż ukazany tutaj przykład. Dlatego nie nadużywaj tego jeżeli nie czujesz się wystarczająco pewnie z wyrażeniami regularnymi w perlu.

Również jak już prawdopodobnie zgadłeś, prefiksy Gitolite `refs/heads/` są składniowym udogodnieniem jeżeli refex nie rozpoczyna się od `refs/`.

Ważną możliwością składni plików konfiguracyjnych jest to że nie ma potrzeby aby wszystkie prawa dla repozytoriów przebywały w jednym miejscu. Możesz trzymać wszystko razem tak jak prawa dla wszystkich `oss_repos` pokazane powyżej. Lub możesz dodać wyszczególnione prawa dla wybranych przypadków później na przykład : 

	repo gitolite
        
        RW+                     = sitaram

Ta reguła zostanie dodana do zbioru reguł dla repozytorium `gitolite`.

W tym punkcie możesz zastanawiać się jak kontrola praw dostępu jest stosowana, omówimy to pokrótce.

Wyróżniamy dwa poziomy dostępu w gitolite. Pierwszy to poziom repozytorium; jeżeli posiadasz dostęp do odczytu (lub zapisu) do każdego ref w repozytorium, wtedy posiadasz prawo do odczytu lub zapisu dla repozytorium. 

Drugi poziom dostępu odnosi się tylko do "zapisu", występuje on przez gałąź lub etykietę w repozytorium. Nazwa użytkownika, usiłowanie dostępu (`W` or `+`), i aktualizowana lub znana 'refname'. Poziomy dostępu są zaznaczane w porządku w jakim pojawiły się w pliku konfiguracyjnym, poszukując dopasowania do tej kombinacji (ale pamiętaj że refname jest dopasowane na podstawie wyrażeń regex nie całkowicie na podstawie łańcucha znaków). Jeżeli znajdziemy dopasowanie operacja wysyłania zakończona jest sukcesem. W przeciwnym wypadku otrzymamy brak dostępu.

### Zaawansowana kontrola dostępu z regułą "odmowy" ###

Do tej pory uprawnienia widzieliśmy tylko jako jedno z `R`, `RW`, lub `RW+`. Jednakże gitolite pozwala na ustalanie innych uprawnień: `-`odnosi się to do "odmów". Daje Ci to dużo więcej możliwości w zamian za trochę złożoności, ponieważ "fallthrough" nie jest *jedynym* sposobem na odmówienie dostępu. Dlatego *porządek reguł teraz ma znaczenie*!  

Powiedzmy, w sytuacji powyżej chcemy żeby wszyscy inżynierowie byli w stanie "rewind" każdą gałąź *za wyjątkiem* master i integ. Dokonamy tego w ten sposób.

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Ponownie, po prostu podążasz za regułami od góry do dołu dopóki nie natrafisz na pasującą dla twojego rodzaju dostępu lub odrzucenia. Nie przewijalne (non-rewind) wysyłanie do gałęzi master lub integ jest dozwolone przez pierwszą regułę. "Rewind" (przewijalne) wysyłanie do tamtych "refs" (gałęzi lub etykiet) nie pasuje do pierwszej reguły, przechodzi do drugiej i dlatego jest odrzucone. Każde wysłanie "rewind lub non-rewind" (przewijalne lub nie) do "refs" (gałęzi lub etykiet) innej niż master lub integ nie będzie pasowało do dwóch pierwszych reguł a trzecia reguła pozwoli na to. 

### Ograniczenie wysyłania na podstawie zmian na plikach ###

Dodatkowo do ograniczeń na gałęzie na które użytkownik może wysyłać zmiany. Możesz również nakładać ograniczenia do których plików jest możliwość dostania się. Na przykład, być może Makefile (czy jakiś inny program) nie jest pożądane aby był zmieniany przez kogokolwiek. Bardzo dużo rzeczy jest od niego zależnych jeżeli zmiany wykonane na tym programie nie będą *poprawne* może to doprowadzić do uszkodzenia. Możesz powiedzieć gitolite: 


    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

To wszechstronna możliwość jest udokumentowana w `conf/example.conf`

### Osobiste Gałęzie ###

Gitolite posiada funkcje zwaną "osobiste gałęzie" (lub raczej, "przestrzeń nazw osobistych gałęzi") może być to bardzo użyteczne w korporacyjnych środowiskach.

Wiele wymiany kodu w świecie gita zdarza się jako żądania pobrania zmian "please pull". W środowisku korporacyjnym jednakże nieautoryzowany dostęp jest nie do przyjęcia, a stanowiska developerskie nie mogą wykonywać uwierzytelniania. Dlatego musisz wysłać wszystko na centralny serwer a następnie poprosić kogoś żeby wysłał to stamtąd.

Takie podejście spowodowałoby takie samo zamieszanie z gałęziami jak w scentralizowanych systemach VCS, dodatkowo ustawianie uprawnień jest harówką dla administratora.

Gitolite pozwala nam na zdefiniowanie prefiksów "osobistych" lub "scratch" przestrzeni nazw dla każdego developera (na przykład `refs/personal/<devname>/*`); zobacz sekcję "osobiste gałęzie" w `doc/3-faq-tips-etc.mkd`.

### Repozytoria "Wildcard" ###

Gitolite pozwala na wyszczególnienie repozytoriów z "wildcards" (właściwie są to perlowe wyrażenia regexes) jak na przykład `assignments/s[0-9][0-9]/a[0-9][0-9]`, losowy przykład. Jest to *bardzo* wszechstronna możliwość, która musi być aktywowana poprzez ustawienie `$GL_WILDREPOS = 1;` w pliku rc. Umożliwia Ci to przypisywanie nowego typu uprawnień ("C") który pozwala użytkownikowi: stworzyć repozytorium bazując na dzikich kartach, automatycznie przypisać posiadanie dla użytkownika który je stworzył, etc. Ta właściwość jest udokumentowana w `doc/4-wildcard-repositories.mkd`.

### Inne właściwości ###

Zakończymy tą dyskusje na przykładach innych właściwości. Wszystkie z nich i wiele innych jest świetnie opisana ze szczegółami w "faqs, tips, etc" oraz innych dokumentach.

**Logging** Gitolite zapisuje każdy udany dostęp. Jeżeli zawsze bardzo łatwo nadawałeś ludziom uprawnienia "rewind" (`RW+`) a jakiś dzieciak zniszczy gałąź "master" plik dziennika uratuje Ci życie, jeśli chodzi o łatwe i szybkie znalezienie SHA które zostało zniszczone.

**Git poza normalną ścieżką**: Jednym ekstremalne użytecznym udogodnieniem w gitolite jest wsparcie dla gita zainstalowanego poza normalną ścieżką `$PATH` (jest to bardziej powszechne niż Ci się wydaje, niektóre środowiska korporacyjne lub nawet dostarczyciele hostingu odmawiają instalowania rzeczy na całym systemie. Dlatego często kończysz instalując je w swojej własnej ścieżce). Normalnie jesteś zmuszony do zapewnienia po stronie klienta aby git znał to nie standardowe położenie binarek. Z gitolite wybierz tylko instalacje 'verbose' i ustaw `$GIT_PATH` w plikach "rc". Nie musisz już nic zmieniać po stronie klienta. 

**Raportowanie praw dostępu**: Kolejną wygodną funkcją jest to co się dzieje kiedy po prostu spróbujemy i zalogujemy się do serwera. Gitolite pokazuje nam do jakich repozytoriów i jakiego typu mamy dostęp. Oto przykład:

        hello sitaram, the gitolite version here is v1.5.4-19-ga3397d4
    
        the gitolite config gives you the following access:
             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Delegacja**: Dla naprawdę dużych instalacji, odpowiedzialność za grupy repozytoriów można oddelegować do różnych osób, aby niezależnie nimi zarządzały. Zmniejsza to obciążenie głównego administratora i czyni go mniej wąskim gardłem. Ta funkcja posiada własny plik dokumentacji w katalogu `doc/`.

**Wsparcie Gitweb**: Gitolite obsługuje gitweb na kilka sposobów. Można określić które repozytoria są widoczne poprzez gitweb. Z pliku konfiguracyjnego gitolite można ustawić "właściciela" i "opis" dla gitweb. Gitweb posiada mechanizm umożliwiający implementację kontroli dostępu opartej na uwierzytelnieniu HTTP, dzięki czemu można użyć "skompilowanego" pliku konfiguracyjnego stworzonego przez gitolite, co oznacza te same zasady kontroli dostępu (do odczytu) dla gitweb oraz gitolite.

**Mirroring**: Gitolite pomaga w utrzymaniu wielu mirrorów i łatwym przełączaniu się między nimi, kiedy główny serwer przestanie działać.

## Git Demon ##

Dla dostępu publicznego, nieautoryzowanego do Twojego projektu, możesz pominąć protokół HTTP i zacząć używać protokołu Git. Główną przyczyną użycia protokołu Git jest jego szybkość działania. Protokół Git jest znacznie bardziej wydajny i szybszy niż protokół HTTP, więc użycie go zaoszczędzi czas użytkowników.

Idąc dalej, dla dostępu nieautoryzowanego i tylko do odczytu. Jeśli używasz projektu na serwerze poza zaporą, powinieneś stosować ten protokół jedynie do projektów, które są publicznie widoczne dla świata. Jeśli serwer, którego używasz znajduje się wewnątrz sieci z zaporą, możesz również użyć go do projektów używanych przez wiele ludzi i komputerów (ciągła integracja lub budowa serwera) mających dostęp tylko do odczytu, jeśli nie chcesz dodawać klucza SSH dla każdego.

W każdym bądź razie, protokół Git jest stosunkowo prosty w konfiguracji. Po prostu, musisz uruchomić komendę poprzez demona:

	  git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` pozwala serwerowi na restart bez konieczności czekania na zakończenie starych połączeń, natomiast opcja `--base-path` pozwala ludziom na klonowanie bez konieczności podawania całej ścieżki, a ścieżka na końcu mówi Git demonowi, które repozytorium mają zostać eksportowane. Jeśli używasz zapory, będziesz musiał dodać regułę otwarcia portu 9418 w oknie ustawień swojej zapory.

Możesz demonizować ten proces na wiele sposobów, w zależności od używanego systemu. Na maszynie z Ubuntu, używamy Upstart script. Więc, w podanym pliku

	/etc/event.d/local-git-daemon

zamieszczasz ten skrypt:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Ze względów bezpieczeństwa, zachęcam do korzystania z demona jako użytkownik z uprawnieniami 'tylko do odczytu' dla repozytorium — możesz łatwo to zrobić tworząc nowego użytkownika 'git-ro' i użycie go do demona. Dla uproszczenia będziemy używać tego samego konta 'git', na którym uruchomiony jest Gitosis.

Kiedy zrestartujesz maszynę, Twój Git demon wystartuje automatycznie jeśli był wyłączony. Aby uruchomić go bez restartu, możesz użyć polecenia:

	initctl start local-git-daemon

Na innych systemach, możesz użyć `xinetd`, skryptu w folderze systemowym `sysvinit`, lub inaczej — tak długo jak będziesz demonizował to polecenie i obserwował jakoś.

Następnie, musisz powiedzieć swojemu serwerowi Gitosis które repozytorium Git pozwala na dostęp 'tylko do odczytu'. Jeśli dodasz wpis dla każdego repozytorium, możesz określić, które ma być czytane przez Git demona. Jeśli chcesz aby protokół Git był dostępny dla Twojego projektu iphone, musisz dodać to na końcu pliku `gitosis.conf` :

	[repo iphone_project]
	daemon = yes

Kiedy to zostanie zatwierdzone i wysłane na serwer, Twój uruchomiony demon powinien zacząć dawać odpowiedzi dla projektu każdemu kto ma dostęp do portu 9418 na Twoim serwerze.

Jeśli zdecydujesz się nie używać Gitosis, ale chcesz ustawić Git demona, musisz uruchomić go dla każdego projektu, który chcesz aby demon obsługiwał:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

Obecność tego pliku mówi Gitowi, że można serwować ten projekt bez autoryzacji.

Gitosis może także kontrolować, który projekt GitWeb ma pokazywać. Najpierw, musisz dodać coś takiego do pliku `/etc/gitweb.conf`:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Możesz kontrolować, który projekt jest widoczny w GitWeb, poprzez dodanie lub usunięcie ustawienia `gitweb` w pliku konfiguracyjnym Gitosis. Na przykład, jeśli chcesz pokazać projekt iphone w GitWeb, musisz zmienić ustawienia `repo` aby wyglądały jak to:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Teraz, jeśli zatwierdzisz i wyślesz projekt, GitWeb automatycznie zacznie pokazywać projekt iphone.

## Hosting Gita ##

Jeśli nie chcesz przechodzić przez wszystkie prace związane z tworzeniem własnego serwera Gita, masz do wyboru kilka opcji hostingu swojego projektu na zewnętrznej stronie hostingowej. Sposób ten oferuje szereg zalet: strony hostingowe są zazwyczaj szybkie w konfiguracji i łatwe do uruchomienia projektu, nie masz własnego zaangażowania w monitorowanie i obsługę serwerów. Nawet jeśli założysz swój własny wewnętrzny serwer to nadal możesz korzystać w publicznej witryny, gdzie dużo łatwiej znaleźć pomoc.

Na dzień dzisiejszy masz do wyboru bardzo dużo stron hostingowych. Każda z nich posiada swoje wady i zalety. Aby zobaczyć aktualną listę takich stron odwiedź adres:

	https://git.wiki.kernel.org/index.php/GitHosting

Ponieważ nie możemy opisać wszystkich z nich, a zdarza mi się na jednej z nich pracować, w tym rozdziale przejdziemy przez założenie konta i utworzenie nowego projektu w GitHubie. Da nam to wyobrażenie o tym co jest potrzebne.

GitHub jest zdecydowanie największą stroną hostingową Gita. Jako jedna z nielicznych oferuje zarówno publiczne, jak i prywatne opcje hostingu, dzięki czemu można przechowywać kod otwarty i prywatny w jednym miejscu. GitHub został prywatnie użyty do tworzenia tej właśnie książki.

### GitHub ###

GitHub jest nieco inny od reszty stron hostingowych ze względu na przestrzenie nazw projektów. Zamiast być w oparciu o projekt, GitHub jest głównie w oparciu o użytkownika. Oznacza to, że np. mój projekt `grit` na GitHubie nie znajduje się w `github.com/grit`, lecz w `github.com/schacon/grit`. Nie ma dzięki temu konieczności tworzenia wersji każdego projektu i pozwala na płynne przejście z jednego użytkownika na drugiego, jeśli któryś porzuca projekt.

GitHub jest również spółką handlową, która pobiera opłaty za utrzymanie prywatnych repozytoriów, lecz każdy może bez problemu dostać darmowe konto gościa dla darmowych projektów. Przejdziemy szybko przez ten proces.

### Konfigurowanie konta użytkownika ###

Pierwszą rzeczą jaką musisz zrobić jest założenie darmowego konta użytkownika. W tym celu wchodzisz na stronę rejestracji `https://github.com/pricing` i klikasz przycisk "Zarejestruj się" na darmowe konto (patrz rysunek 4-2) i jesteś już przeniesiony na stronę rejestracji.

Insert 18333fig0402.png
Rysunek 4-2. Strona rejestracji GitHub.

Tutaj musisz wybrać nazwę użytkownika, taką która nie istnieje jeszcze w systemie, podać adres e-mail, który będzie powiązany z kontem i podać hasło Rysunek 4-3).

Insert 18333fig0403.png 
Rysunek 4-3. Rejestracja użytkownika GitHub.

Jeśli jest to możliwe to jest to dobry moment aby dodać swój publiczny klucz SSH. W rozdziale "Simple Setups" wyjaśniliśmy już jak wygenerować nowy klucz. Skopiuj zawartość klucza i wklej go w polu "SSH Public Key". Kliknięcie "explain ssh keys" przeniesie Cię do szczegółowych informacji jak zrobić to na poszczególnych systemach operacyjnych.
Kliknięcie "I agree, sign me up" powoduje przeniesienie do nowego panelu użytkownika (patrz rysunek 4-4).

Insert 18333fig0404.png 
Rysunek 4-4. Panel użytkownika GitHub.

Następnie możesz utworzyć nowe repozytorium.

### Tworzenie nowego repozytorium ###

Zacznij klikając na link "create a new one" obok Twoich repozytoriów na panelu użytkownika. Jesteś na stronie do tworzenia nowego repozytorium (patrz rysunek 4-5).

Insert 18333fig0405.png 
Rysunek 4-5. Tworzenie nowego repozytorium na GitHubie.

Wszystko co tak naprawdę musisz zrobić to podać nazwę projektu. Możesz też podać dodatkowy opis. Kiedy to zrobisz klikasz przycisk "Create Repository". Masz już nowe repozytorium na GitHubie (patrz rysunek 4-6).

Insert 18333fig0406.png 
Rysunek 4-6. Główne informacje o projekcie.

Ponieważ nie masz tam jeszcze kodu, GitHub pokaże instrukcje jak stworzyć zupełnie nowy projekt. Wciśnij istniejący już projekt, lub zaimportuj projekt z publicznego repozytorium Subversion (patrz rysunek 4-7).

Insert 18333fig0407.png 
Rysunek 4-7. Instrukcja tworzenia nowego repozytorium.

Instrukcje te są podobne do tego co już przeszedłeś. Aby zainicjować projekt, jeśli nie jest jeszcze projektem gita, możesz użyć:

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Kiedy masz już lokalne repozytorium Gita, dodaj GitHub jako zdalne repozytorium i wyślij swoją główną gałąź:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Teraz Twój projekt jest już utrzymywany na GitHubie. Możesz każdemu udostępnić swój projekt wysyłając adres URL. W naszym przypadku jest to `http://github.com/testinguser/iphone_project`. Możesz także zobaczyć na nagłówku każdego z projektów, że masz dwa adresy URL (patrz rysunek 4-8).

Insert 18333fig0408.png 
Rysunek 4-8. Nagłówek projektu z prywatnym i publicznym adresem URL.

Publiczny adres URL służy tylko do pobierania repozytorium projektu. Zachęcamy do umieszczania go na stronach WWW.

Prywatny adres URL służy do pobierania i wysyłania repozytorium na serwer. Korzystać można z niego tylko wtedy, kiedy zostanie skojarzony z kluczem publicznym wysłanym do każdego użytkownika. Kiedy inni będą odwiedzać stronę projektu, będą widzieć tylko adres publiczny.

### Import z Subversion ###

Jeśli masz już projekt publiczny Subversion, który chcesz zaimportować do Gita, GitHub często może zrobić to dla Ciebie. Na dole strony instrukcji jest link służący do importu Subversion. Po kliknięciu na niego pojawi się formularz z informacjami o imporcie projektu i pole gdzie można wkleić adres swojego publicznego projektu Subversion (patrz rysunek 4-9).

Insert 18333fig0409.png 
Rysunek 4-9. Interfejs importowanie Subversion.

Jeśli Twój projekt jest bardzo duży, niestandardowy lub prywatny to proces ten najprawdopodobniej nie zadziała. W rozdziale 7 dowiesz się jak ręcznie przeprowadzić bardziej skomplikowany import.

### Dodawanie Współpracowników ###

Dodajmy więc resztę naszej drużyny. Jeśli John, Josie i Jessica zapiszą się do konta GitHub oraz jeśli chcesz dać im możliwość wykonywania komendy `push` do Twojego repozytorium, możesz dodać ich do projektu jako współpracowników. Takie postępowanie dopuści pushe z ich kluczy publicznych do pracy.

Naciśnij przycisk "edit" na nagłówku projektu lub w zakładce Admina na górze projektu aby uzyskać dostęp do strony Admina projektu GitHub (zobacz Rysunek 4-10).

Insert 18333fig0410.png 
Rysunek 4-10. Strona administratora GitHub.

Aby dać dostęp do projektu kolejnej osobie, naciśnij link “Add another collaborator”. Pojawia się nowe pole tekstowe gdzie można wpisać nazwę użytkownika. Jak już wpiszesz nazwę użytkownika, wyskakujące okienko podpowie Ci pasujących do nazwy użytkowników. Kiedy znajdziesz prawidłowego użytkownika, naciśnij przycisk "Add" aby dodać użytkownika do współpracowników w Twoim projekcie (zobacz Rysunek 4-11).

Insert 18333fig0411.png 
Rysunek 4-11. Dodawanie współpracowników do Twojego projektu.

Kiedy skończysz dodawanie współpracowników, powinieneś zobaczyć ich listę w okienku "Repository Collaborators" (zobacz Rysunek 4-12).

Insert 18333fig0412.png 
Rysunek 4-12. Lista współpracowników w Twoim projekcie.

Jeśli musisz zablokować dostęp poszczególnym osobom, możesz kliknąć link "revoke", w ten sposób usuniesz możliwość użycia komendy "push". Dla przyszłych projektów, możesz skopiować grupę współpracowników kopiując ich dane dostępowe w istniejącym projekcie.

### Twój projekt ###

Po tym jak wyślesz swój projekt lub zaimportujesz z Subversion, będziesz miał stronę główną projektu wyglądającą jak na Rysunku 4-13.

Insert 18333fig0413.png 
Rysunek 4-13. Strona główna projektu GitHub.

Kiedy ludzie będą odwiedzali Twój projekt, zobaczą tę stronę. Zawiera ona kilka kart. Karta zatwierdzeń pokazuje zatwierdzenia w odwrotnej kolejności, tak samo jak w przypadku polecenia `git log`. Karta połączeń pokazuje wszystkich którzy zrobili rozwidlenie Twojego projektu i uzupełniają go. Karta ściągnięć pozwala ci załadować pliki binarne do projektu oraz linki do paczek z kodami i spakowane wersje wszystkich zaznaczonych punktów w projekcie. Karta Wiki pozwala na dodawanie dokumentacji oraz informacji do projektu. Karta Grafów pokazuje w graficzny sposób statystyki użytkowania projektu. Głowna karta z plikami źródłowymi, które lądują w projekcie pokazuje listę katalogów w projekcie i automatycznie renderuje plik README poniżej jeśli taki znajduje się w głównym katalogu projektu. Ta karta pokazuje również okno z zatwierdzeniami.

### Rozwidlanie projektu ###

Jeśli chcesz przyczynić się do rozwoju istniejącego projektu, w którym nie masz możliwości wysyłania, GitHub zachęca do rozwidlania projektu. Kiedy znajdziesz się na stronie która wydaje się interesująca i chcesz pogrzebać w niej trochę, możesz nacisnąć przycisk "fork" w nagłówku projektu aby GitHub skopiował projekt do Twojego użytkownika tak abyś mógł do niego wprowadzać zmiany.

W tego typu projektach nie musimy martwić się o dodawanie współpracowników aby nadać im prawo do wysyłania. Ludzie mogą rozwidlić projekt i swobodnie wysyłać do niego, a główny opiekun projektu może pobrać te zmiany dodając gałąź jako zdalną i połączyć go z głównym projektem.

Aby rozwidlić projekt, odwiedź stronę projektu (w tym przykładzie, mojombo/chronic) i naciśnij przycisk "fork" w nagłówku (zobacz Rysunek 4-14).

Insert 18333fig0414.png 
Rysunek 4-14. Pozyskanie zapisywalnej wersji projektu poprzez użycie "fork".

Po kilku sekundach zostaniesz przeniesiony na swoją stronę projektu, która zawiera informacje, że dany projekt został rozwidlony (zobacz Rysunek 4-15).

Insert 18333fig0415.png 
Rysunek 4-15. Twoje rozwidlenie projektu.

### Podsumowanie GitHub ###

To już wszystko o GitHub, ale ważne jest aby zaznaczyć jak szybko można to wszystko zrobić. Możesz stworzyć konto, dodać nowy projekt i wysłać go w kilka minut. Jeśli Twój projekt jest typu open source, dodatkowo zyskujesz ogromną społeczność programistów, którzy mają teraz wgląd do twojego projektu i mogą pomóc w jego rozwoju tworząc rozwidlenie. W ostateczności, może to być sposób na zaznajomienie się i szybkie wypróbowanie Gita.

## Podsumowanie ##

Istnieje kilka sposobów na stworzenie repozytorium Gita, w celu kooperacji z innymi lub dzielenia się swoją pracą.

Postawienie własnego serwera daje Ci sporą kontrolę i umożliwia działanie serwera za własnym firewallem, ale taki serwer na ogół wymaga sporo czasu na stworzenie i utrzymanie. Jeśli umieścisz swoje dane na gotowym hostingu, to jest to łatwe do skonfigurowania i utrzymania, ale musisz być w stanie utrzymać swój kod na cudzych serwerach, a niektóre organizacje na to nie pozwalają.

Określenie, które rozwiązanie lub połączenie rozwiązań jest odpowiednie dla Ciebie i Twojej organizacji powinno być dość proste.
