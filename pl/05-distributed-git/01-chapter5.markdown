# Rozproszony Git #

Teraz, gdy masz już skonfigurowane zdalne repozytorium, które służy do wymiany pracy między programistami w projekcie oraz jesteś zaznajomiony z podstawowymi komendami pozwalającymi na pracę z lokalnym repozytorium Git, zobaczysz jak wykorzystać jego możliwości w rozproszonym trybie pracy, który Git umożliwia.

<!-- Now that you have a remote Git repository set up as a point for all the developers to share their code, and you’re familiar with basic Git commands in a local workflow, you’ll look at how to utilize some of the distributed workflows that Git affords you. -->

W tym rozdziale, zobaczysz jak pracować z Gitem w rozproszonym środowisku jako współpracownik lub integrator zmian. Nauczysz się jak udostępniać wprowadzone zmiany oraz jak zrobić to najprościej jak tylko się da dla siebie i opiekuna projektu, oraz jak zarządzać projektem w którym uczestniczy wielu programistów.

<!-- In this chapter, you’ll see how to work with Git in a distributed environment as a contributor and an integrator. That is, you’ll learn how to contribute code successfully to a project and make it as easy on you and the project maintainer as possible, and also how to maintain a project successfully with a number of developers contributing. -->

## Rozproszone przepływy pracy ##

Odmiennie do scentralizowanych systemów kontroli wersji (CVCS), rozproszona natura systemu Git pozwala na dużo bardziej elastyczne podejście do tego w jaki sposób przebiega współpraca między programistami. W scentralizowanych systemach każdy programista jest osobnym elementem pracującym na centralnym serwerze. W Gitcie każdy programista posiada zarówno swoje oddzielne repozytorium, które może zostać udostępnione dla innych, jak również centralny serwer do którego inni mogą wgrywać swoje zmiany. To umożliwia szerokie możliwości współpracy dla Twojego projektu i/lub zespołu, dlatego opiszę kilka często używanych zachować które z tego korzystają. Pokażę zalety i wady każdego z rozwiązań; możesz wybrać jeden odpowiadający tobie, lub możesz je połączyć i zmieszać ze sobą.

### Scentralizowany przepływ pracy ###

W scentralizowanych systemach, zazwyczaj jest stosowany model centralnego przepływu. W jednym centralnym punkcie znajduje się repozytorium, do którego wgrywane są zmiany, a pozostali współpracownicy synchronizują swoją pracę z nim. Wszyscy programiści uczestniczący w projekcie są końcówkami, łączącymi się z centralnym serwerem - oraz synchronizującymi się z nim (patrz rys. 5-1 )

<!-- In centralized systems, there is generally a single collaboration model—the centralized workflow. One central hub, or repository, can accept code, and everyone synchronizes their work to it. A number of developers are nodes — consumers of that hub — and synchronize to that one place (see Figure 5-1). -->

Insert 18333fig0501.png
Rysunek 5-1. Scentralizowany przepływ pracy.

Oznacza to tyle, że w sytuacji w której dwóch niezależnych programistów korzystających z tego centralnego repozytorium będzie próbowało wgrać swoje zmiany, tylko pierwszemu z nich uda się tego dokonać bezproblemowo. Drugi przed wgraniem, będzie musiał najpierw pobrać i zintegrować zmiany wprowadzone przez pierwszego programistę, a dopiero później ponowić próbę wysłania swoich na serwer. Taki rodzaj współpracy sprawdza się doskonale w Gitcie, tak samo jak funkcjonuje on w Subversion (lub każdym innym CVCS).

Jeżeli masz mały zespół, lub dobrze znacie pracę z jednym centralnym repozytorium w firmie lub zespole, możesz bez problemów kontynuować ten rodzaj pracy z Gitem. Po prostu załóż nowe repozytorium, nadaj każdej osobie z zespołu uprawnienia do wgrywania zmian (za pomocą komendy `push`); Git nie pozwoli na nadpisanie pracy jednego programisty przez innego. Jeżeli jeden z programistów sklonuje repozytorium, wprowadzi zmiany i będzie próbował wgrać je do głównego repozytorium, a w międzyczasie inny programista wgra już swoje zmiany, serwer odrzuci jego zmiany. Zostaną poinformowani że próbują wgrać zmiany (tzw. non-fast-forward) i że muszą najpierw pobrać je (fetch) i włączyć do swojego repozytorium (merge). Taki rodzaj współpracy jest atrakcyjny dla dużej ilości osób, ponieważ działa w taki sposób, w jaki przywykli oni pracować.

<!-- If you have a small team or are already comfortable with a centralized workflow in your company or team, you can easily continue using that workflow with Git. Simply set up a single repository, and give everyone on your team push access; Git won’t let users overwrite each other. If one developer clones, makes changes, and then tries to push their changes while another developer has pushed in the meantime, the server will reject that developer’s changes. They will be told that they’re trying to push non-fast-forward changes and that they won’t be able to do so until they fetch and merge.
This workflow is attractive to a lot of people because it’s a paradigm that many are familiar and comfortable with. -->

### Przepływ pracy z osobą integrującą zmiany ###


Ponieważ Git powala na posiadanie wielu zdalnych repozytoriów, możliwy jest schemat pracy w którym każdy programista ma uprawnienia do zapisu do swojego własnego repozytorium oraz uprawnienia do odczytu do repozytorium innych osób w zespole. Ten scenariusz często zawiera jedno centralne - "oficjalne" repozytorium projektu. Aby wgrać zmiany do projektu, należy stworzyć publiczną kopię tego repozytorium i wgrać ("push") zmiany do niego. Następnie należy wysłać prośbę do opiekuna aby pobrał zmiany do głównego repozytorium. Może on dodać Twoje repozytorium jako zdalne, przetestować Twoje zmiany lokalnie, włączyć je do nowej gałęzi i następnie wgrać do repozytorium. Proces ten wygląda następująco (rys. 5-2):

<!-- Because Git allows you to have multiple remote repositories, it’s possible to have a workflow where each developer has write access to their own public repository and read access to everyone else’s. This scenario often includes a canonical repository that represents the "official" project. To contribute to that project, you create your own public clone of the project and push your changes to it. Then, you can send a request to the maintainer of the main project to pull in your changes. They can add your repository as a remote, test your changes locally, merge them into their branch, and push back to their repository. The process works as follow (see Figure 5-2): -->

1. Opiekun projektu wgrywa zmiany do publicznego repozytorium.
2. Programiści klonują to repozytorium i wprowadzają zmiany.
3. Programista wgrywa zmiany do swojego publicznego repozytorium.
4. Programista wysyła prośbę do opiekuna projektu, aby pobrał zmiany z jego repozytorium.
5. Opiekun dodaje repozytorium programisty jako repozytorium zdalne i pobiera zmiany.
6. Opiekun wgrywa włączone zmiany do głównego repozytorium.

<!--
1. The project maintainer pushes to their public repository.
2. A contributor clones that repository and makes changes.
3. The contributor pushes to their own public copy.
4. The contributor sends the maintainer an e-mail asking them to pull changes.
5. The maintainer adds the contributor’s repo as a remote and merges locally.
6. The maintainer pushes merged changes to the main repository.
-->

Insert 18333fig0502.png
Rysunek 5-2. Przepływ pracy z osobą integrującą zmiany.

To jest bardzo popularne podejście podczas współpracy przy pomocy stron takich jak GitHub, gdzie bardzo łatwo można stworzyć kopię repozytorium i wgrywać zmiany do niego aby każdy mógł je zobaczyć. jedną z głównych zalet takiego podejścia jest to, że możesz kontynuować pracę, a opiekun może pobrać Twoje zmiany w dowolnym czasie. Programiści nie muszą czekać na opiekuna, aż ten włączy ich zmiany, każdy z nich może pracować oddzielnie.

<!-- This is a very common workflow with sites like GitHub, where it’s easy to fork a project and push your changes into your fork for everyone to see. One of the main advantages of this approach is that you can continue to work, and the maintainer of the main repository can pull in your changes at any time. Contributors don’t have to wait for the project to incorporate their changes — each party can work at their own pace. -->

### Przepływ pracy z dyktatorem i porucznikami ###

To jest wariant przepływu z wieloma repozytoriami. Zazwyczaj jest on używany w bardzo dużych projektach, z setkami programistów; najbardziej znanym przykładem może być jądro Linuksa. Kilkoro opiekunów jest wydelegowanych do obsługi wydzielonych części repozytorium; nazwijmy ich porucznikami. Wszyscy z nich mają jedną, główną osobę integrującą zmiany - znaną jako miłościwy dyktator. Repozytorium dyktatora jest wzorcowym, z którego wszyscy programiści pobierają zmiany. Cały proces działa następująco (rys. 5-3):

<!-- This is a variant of a multiple-repository workflow. It’s generally used by huge projects with hundreds of collaborators; one famous example is the Linux kernel. Various integration managers are in charge of certain parts of the repository; they’re called lieutenants. All the lieutenants have one integration manager known as the benevolent dictator. The benevolent dictator’s repository serves as the reference repository from which all the collaborators need to pull. The process works like this (see Figure 5-3): -->


1. Programiści pracują nad swoimi gałęziami tematycznymi, oraz wykonują "rebase" na gałęzi "master". Gałąź "master" jest tą pobraną od dyktatora.
2. Porucznicy włączają ("merge") zmiany programistów do swojej gałęzi "master".
3. Dyktator włącza ("merge") gałęzie "master" udostępnione przez poruczników do swojej gałęzi "master".
4. Dyktator wypycha ("push") swoją gałąź master do głównego repozytorium, tak aby inni programiści mogli na niej pracować.

<!--
1. Regular developers work on their topic branch and rebase their work on top of master. The master branch is that of the dictator.
2. Lieutenants merge the developers’ topic branches into their master branch.
3. The dictator merges the lieutenants’ master branches into the dictator’s master branch.
4. The dictator pushes their master to the reference repository so the other developers can rebase on it.
-->

Insert 18333fig0503.png
Rysunek 5-3. Przepływ pracy z miłościwym dyktatorem.

Ten rodzaj współpracy nie jest częsty w użyciu, ale może być użyteczny w bardzo dużych projektach, lub bardzo rozbudowanych strukturach zespołów w których lider zespołu może delegować większość pracy do innych i zbierać duże zestawy zmian przed integracją.

<!-- This kind of workflow isn’t common but can be useful in very big projects or in highly hierarchical environments, as it allows the project leader (the dictator) to delegate much of the work and collect large subsets of code at multiple points before integrating them. -->

To są najczęściej stosowane przepływy pracy możliwe przy użyciu rozproszonego systemu takiego jak Git, jednak możesz zauważyć że istnieje w tym względzie duża dowolność, tak abyś mógł dostosować go do używanego przez siebie tryby pracy. Teraz gdy (mam nadzieję) możesz już wybrać sposób pracy który jest dla Ciebie odpowiedni, pokaże kilka konkretnych przykładów w jaki sposób osiągnąć odpowiedni podział ról dla każdego z opisanych przepływów.

<!-- These are some commonly used workflows that are possible with a distributed system like Git, but you can see that many variations are possible to suit your particular real-world workflow. Now that you can (I hope) determine which workflow combination may work for you, I’ll cover some more specific examples of how to accomplish the main roles that make up the different flows. -->

## Wgrywanie zmian do projektu ##

Znasz już różne sposoby pracy, oraz powinieneś posiadać solidne podstawy używania Gita. W tej sekcji, nauczysz się kilku najczęstszych sposobów aby uczestniczyć w projekcie.

<!-- You know what the different workflows are, and you should have a pretty good grasp of fundamental Git usage. In this section, you’ll learn about a few common patterns for contributing to a project. -->

Główną trudnością podczas opisywania tego procesu, jest bardzo duża różnorodność sposobów w jaki jest to realizowane. Ponieważ Git jest bardzo elastycznym narzędziem, ludzie mogą i współpracują ze sobą na różne sposoby, dlatego też trudne jest pokazanie w jaki sposób Ty powinieneś  - każdy projekt jest inny. Niektóre ze zmiennych które warto wziąć pod uwagę to ilość aktywnych współpracowników, wybrany sposób przepływów pracy, uprawnienia, oraz prawdopodobnie sposób współpracy z zewnętrznymi programistami.

<!-- The main difficulty with describing this process is that there are a huge number of variations on how it’s done. Because Git is very flexible, people can and do work together many ways, and it’s problematic to describe how you should contribute to a project — every project is a bit different. Some of the variables involved are active contributor size, chosen workflow, your commit access, and possibly the external contribution method. -->

Pierwszą zmienną jest ilość aktywnych współpracowników. Ilu aktywnych współpracowników/programistów aktywnie wgrywa zmiany do projektu, oraz jak często? Najczęściej będzie to sytuacja, w której uczestniczy dwóch lub trzech programistów, wgrywających kilka razy na dzień zmiany (lub nawet mniej, przy projektach nie rozwijanych aktywnie). Dla bardzo dużych firm lub projektów, ilość programistów może wynieść nawet tysiące, z dziesiątkami lub nawet setkami zmian wgrywanych każdego dnia. Jest to bardzo ważne, ponieważ przy zwiększającej się liczbie programistów, wypływa coraz więcej problemów podczas włączania efektów ich prac. Zmiany które próbujesz wgrać, mogą stać się nieużyteczne, lub niepotrzebne ze względu na zmiany innych osób z zespołu. Tylko w jaki sposób zachować spójność kodu i poprawność wszystkich przygotowanych łatek?

<!-- The first variable is active contributor size. How many users are actively contributing code to this project, and how often? In many instances, you’ll have two or three developers with a few commits a day, or possibly less for somewhat dormant projects. For really large companies or projects, the number of developers could be in the thousands, with dozens or even hundreds of patches coming in each day. This is important because with more and more developers, you run into more issues with making sure your code applies cleanly or can be easily merged. Changes you submit may be rendered obsolete or severely broken by work that is merged in while you were working or while your changes were waiting to be approved or applied. How can you keep your code consistently up to date and your patches valid? -->

Następną zmienną jest sposób przepływu pracy w projekcie. Czy jest scentralizowany, w którym każdy programista ma równy dostęp do wgrywania kodu? Czy projekt posiada głównego opiekuna, lub osobę integrującą, która sprawdza wszystkie łatki? Czy wszystkie łatki są wzajemnie zatwierdzane? Czy uczestniczysz w tym procesie? Czy funkcjonuje porucznik, do którego musisz najpierw przekazać swoje zmiany?

<!-- The next variable is the workflow in use for the project. Is it centralized, with each developer having equal write access to the main codeline? Does the project have a maintainer or integration manager who checks all the patches? Are all the patches peer-reviewed and approved? Are you involved in that process? Is a lieutenant system in place, and do you have to submit your work to them first? -->

Następnym elementem są uprawnienia do repozytorium. Sposób pracy z repozytorium do którego możesz wgrywać zmiany bezpośrednio, jest zupełnie inny, od tego w którym masz dostęp tylko do odczytu. Jeżeli nie masz uprawnień do zapisu, w jaki sposób w projekcie akceptowane są zmiany? Czy ma on określoną politykę? Jak duże zmiany wgrywasz za jednym razem? Jak często je wgrywasz?

<!-- The next issue is your commit access. The workflow required in order to contribute to a project is much different if you have write access to the project than if you don’t. If you don’t have write access, how does the project prefer to accept contributed work? Does it even have a policy? How much work are you contributing at a time? How often do you contribute? -->

Odpowiedzi na wszystkie te pytania, mogą wpływać na to w jaki sposób będziesz wgrywał zmiany do repozytorium, oraz jaki rodzaj przepływu pracy jest najlepszy lub nawet dostępny dla Ciebie. Omówię aspekty każdej z nich w serii przypadków użycia, przechodząc od prostych do bardziej złożonych, powinieneś móc skonstruować konkretny przepływ pracy który możesz zastosować w praktyce z tych przykładów.

<!-- All these questions can affect how you contribute effectively to a project and what workflows are preferred or available to you. I’ll cover aspects of each of these in a series of use cases, moving from simple to more complex; you should be able to construct the specific workflows you need in practice from these examples. -->

### Wskazówki wgrywania zmian ###

Zanim spojrzysz na poszczególne przypadki użycia, najpierw szybka informacja o treści komentarzy do zmian ("commit messages"). Dobre wytyczne do tworzenia commitów, oraz związanych z nią treścią komentarzy pozwala na łatwiejszą pracę z Gitem oraz innymi współpracownikami. Projekt Git dostarcza dokumentację która pokazuje kilka dobrych rad dotyczących tworzenia commit-ów i łat - możesz ją znaleźć w kodzie źródłowym Gita w pliku `Documentation/SubmittingPatches`.

<!-- Before you start looking at the specific use cases, here’s a quick note about commit messages. Having a good guideline for creating commits and sticking to it makes working with Git and collaborating with others a lot easier. The Git project provides a document that lays out a number of good tips for creating commits from which to submit patches — you can read it in the Git source code in the `Documentation/SubmittingPatches` file. -->

Po pierwsze, nie chcesz wgrywać żadnych błędów związanych z poprawkami pustych znaków (np. spacji). Git dostarcza łatwy sposób do tego - zanim wgrasz zmiany, uruchom `git diff --check`, komenda ta pokaże możliwe nadmiarowe spacje. Poniżej mamy przykład takiej sytuacji, zamieniłem kolor czerwony na terminalu znakami `X`:

<!-- First, you don’t want to submit any whitespace errors. Git provides an easy way to check for this — before you commit, run `git diff -\-check`, which identifies possible whitespace errors and lists them for you. Here is an example, where I’ve replaced a red terminal color with `X`s: -->

    $ git diff --check
    lib/simplegit.rb:5: trailing whitespace.
    +    @git_dir = File.expand_path(git_dir)XX
    lib/simplegit.rb:7: trailing whitespace.
    + XXXXXXXXXXX
    lib/simplegit.rb:26: trailing whitespace.
    +    def command(git_cmd)XXXX


Jeżeli uruchomisz tę komendę przed commit-em, dowiesz się czy zamierzasz wgrać zmiany które mogą zdenerwować innych programistów.

<!-- If you run that command before committing, you can tell if you’re about to commit whitespace issues that may annoy other developers. -->

Następnie spróbuj w każdym commit-ie zawrzeć logicznie odrębny zestaw zmian. Jeżeli możesz, twórz nie za duże łatki - nie programuj cały weekend poprawiając pięć różnych błędów, aby następnie wszystkie je wypuścić w jednym dużym commit-cie w poniedziałek. Nawet jeżeli nie zatwierdzasz zmian w ciągu weekendu, użyj przechowalni ("stage"), aby w poniedziałek rozdzielić zmiany na przynajmniej jeden commit dla każdego błędu, dodając użyteczny komentarz do każdego commitu. Jeżeli niektóre ze zmian modyfikują ten sam plik, spróbuj użyć komendy `git add --patch`, aby częściowo dodać zmiany do przechowalni (dokładniej opisane to jest w rozdziale 6). Końcowa migawka projektu w gałęzi jest identyczna, nieważne czy zrobisz jeden czy pięć commitów, więc spróbuj ułatwić życie swoim współpracownikom kiedy będą musieli przeglądać Twoje zmiany. Takie podejście ułatwia również pobranie lub przywrócenie pojedynczych zestawów zmian w razie potrzeby. Rozdział 6 opisuje kilka ciekawych trików dotyczących nadpisywania historii zmian i interaktywnego dodawania plików do przechowalni - używaj ich do utrzymania czystej i przejrzystej historii.

<!-- Next, try to make each commit a logically separate changeset. If you can, try to make your changes digestible — don’t code for a whole weekend on five different issues and then submit them all as one massive commit on Monday. Even if you don’t commit during the weekend, use the staging area on Monday to split your work into at least one commit per issue, with a useful message per commit. If some of the changes modify the same file, try to use `git add -\-patch` to partially stage files (covered in detail in Chapter 6). The project snapshot at the tip of the branch is identical whether you do one commit or five, as long as all the changes are added at some point, so try to make things easier on your fellow developers when they have to review your changes. This approach also makes it easier to pull out or revert one of the changesets if you need to later. Chapter 6 describes a number of useful Git tricks for rewriting history and interactively staging files — use these tools to help craft a clean and understandable history. -->

Ostatnią rzeczą na którą należy zwrócić uwagę są komentarze do zmian. Tworzenie dobrych komentarzy pozwala na łatwiejsze używanie i współpracę za pomocą Gita. Generalną zasadą powinno być to, że treść komentarza rozpoczyna się od pojedynczej linii nie dłuższej niż 50 znaków, która zwięźle opisuje zmianę, następnie powinna znaleźć się pusta linia, a poniżej niej szczegółowy opis zmiany. Projekt Git wymaga bardzo dokładnych wyjaśnień motywujących twoją zmianę w stosunku do poprzedniej implementacji - jest to dobra wskazówka do naśladowania. Dobrym pomysłem jest używania czasu teraźniejszego w trybie rozkazującym. Innymi słowy, używaj komend. Zamiast "Dodałem testy dla" lub "Dodawania testów dla", użyj "Dodaj testy do".
Poniżej znajduje się szablon komentarza przygotowany przez Tima Pope z tpope.net:

<!-- The last thing to keep in mind is the commit message. Getting in the habit of creating quality commit messages makes using and collaborating with Git a lot easier. As a general rule, your messages should start with a single line that’s no more than about 50 characters and that describes the changeset concisely, followed by a blank line, followed by a more detailed explanation. The Git project requires that the more detailed explanation include your motivation for the change and contrast its implementation with previous behavior — this is a good guideline to follow. It’s also a good idea to use the imperative present tense in these messages. In other words, use commands. Instead of "I added tests for" or "Adding tests for," use "Add tests for."
Here is a template originally written by Tim Pope at tpope.net: -->

    Krótki (50 znaków lub mniej) opis zmiany

    Bardziej szczegółowy tekst jeżeli jest taka konieczność. Zawijaj
    wiersze po około 72 znakach. Czasami pierwsza linia jest traktowana
    jako temat wiadomości email, a reszta komentarza jako treść. Pusta
    linia oddzielająca opis od streszczenia jest konieczna (chyba że
    ominiesz szczegółowy opis kompletnie); narzędzia takie jak `rebase`
    mogą się pogubić jeżeli nie oddzielisz ich.

    Kolejne paragrafy przychodzą po pustej linii.

     - wypunktowania są poprawne, również

     - zazwyczaj łącznik lub gwiazdka jest używana do punktowania,
       poprzedzona pojedynczym znakiem spacji, z pustą linią pomiędzy,
       jednak zwyczaje mogą się tutaj różnić.


Jeżeli wszystkie Twoje komentarz do zmian będą wyglądały jak ten, współpraca będzie dużo łatwiejsza dla Ciebie i twoich współpracowników. Projekt Git ma poprawnie sformatowane komentarze, uruchom polecenie `git log --no-merges` na tym projekcie, aby zobaczyć jak wygląda ładnie sformatowana i prowadzona historia zmian.

<!-- If all your commit messages look like this, things will be a lot easier for you and the developers you work with. The Git project has well-formatted commit messages — I encourage you to run `git log -\-no-merges` there to see what a nicely formatted project-commit history looks like. -->

W poniższych przykładach, i przez większość tej książki, ze względu na zwięzłość nie sformatowałem treści komentarzy tak ładnie; używam opcji `-m` do `git commit`. Rób tak jak mówię, nie tak jak robię.

<!-- In the following examples, and throughout most of this book, for the sake of brevity I don’t format messages nicely like this; instead, I use the `-m` option to `git commit`. Do as I say, not as I do. -->

### Małe prywatne zespoły ###

Najprostszym przykładem który możesz spotkać, to prywatne repozytorium z jednym lub dwoma innymi współpracownikami. Jako prywatne, mam na myśli repozytorium z zamkniętym kodem źródłowym - nie dostępnym do odczytu dla innych.Ty i inny deweloperzy mają uprawniania do wgrywania ("push") swoich zmian.

<!-- The simplest setup you’re likely to encounter is a private project with one or two other developers. By private, I mean closed source — not read-accessible to the outside world. You and the other developers all have push access to the repository. -->

W takim środowisku możesz naśladować sposób pracy znany z Subversion czy innego scentralizowanego systemu kontroli wersji. Nadal masz wszystkie zalety takie jak commitowanie bez dostępu do centralnego serwera, oraz prostsze tworzenie gałęzi i łączenie zmian, ale przepływ pracy jest bardzo podobny; główną różnicą jest to, że łączenie zmian wykonywane jest po stronie klienta a nie serwera podczas commitu.
Zobaczmy jak to może wyglądać, w sytuacji w której dwóch programistów rozpocznie prace z współdzielonym repozytorium. Pierwszy programista, John, klonuje repozytorium, wprowadza zmiany i zatwierdza je lokalnie. (Zamieniłem część informacji znakami `...` aby skrócić przykłady.)

<!-- In this environment, you can follow a workflow similar to what you might do when using Subversion or another centralized system. You still get the advantages of things like offline committing and vastly simpler branching and merging, but the workflow can be very similar; the main difference is that merges happen client-side rather than on the server at commit time.
    Let’s see what it might look like when two developers start to work together with a shared repository. The first developer, John, clones the repository, makes a change, and commits locally. (I’m replacing the protocol messages with `...` in these examples to shorten them somewhat.) -->

    # Komputer Johna
    $ git clone john@githost:simplegit.git
    Initialized empty Git repository in /home/john/simplegit/.git/
    ...
    $ cd simplegit/
    $ vim lib/simplegit.rb
    $ git commit -am 'removed invalid default value'
    [master 738ee87] removed invalid default value
     1 files changed, 1 insertions(+), 1 deletions(-)

Drugi programista, Jessica, robi to samo — klonuje repozytorium i commituje zmianę:

    # Komputer Jessici
    $ git clone jessica@githost:simplegit.git
    Initialized empty Git repository in /home/jessica/simplegit/.git/
    ...
    $ cd simplegit/
    $ vim TODO
    $ git commit -am 'add reset task'
    [master fbff5bc] add reset task
     1 files changed, 1 insertions(+), 0 deletions(-)

Następnie, Jessica wypycha swoje zmiany na serwer:

    # Komputer Jessici
    $ git push origin master
    ...
    To jessica@githost:simplegit.git
       1edee6b..fbff5bc  master -> master

John próbuje również wypchnąć swoje zmiany:

    # Komputer Johna
    $ git push origin master
    To john@githost:simplegit.git
     ! [rejected]        master -> master (non-fast forward)
    error: failed to push some refs to 'john@githost:simplegit.git'

John nie może wypchnąć swoich zmian, ponieważ w międzyczasie Jessica wypchnęła swoje. To jest szczególnie ważne do zrozumienia, jeżeli przywykłeś do Subversion, ponieważ zauważysz że każdy z deweloperów zmieniał inne pliki. Chociaż Subversion automatycznie połączy zmiany po stronie serwera jeżeli zmieniane były inne pliki, w Git musisz połączyć zmiany lokalnie. John musi pobrać zmiany Jessici oraz włączyć je do swojego repozytorium zanim będzie wypychał swoje zmiany:

<!-- John isn’t allowed to push because Jessica has pushed in the meantime. This is especially important to understand if you’re used to Subversion, because you’ll notice that the two developers didn’t edit the same file. Although Subversion automatically does such a merge on the server if different files are edited, in Git you must merge the commits locally. John has to fetch Jessica’s changes and merge them in before he will be allowed to push: -->

    $ git fetch origin
    ...
    From john@githost:simplegit
     + 049d078...fbff5bc master     -> origin/master

W tym momencie lokalne repozytorium Johna wygląda podobnie do tego z rys. 5-4.

<!-- At this point, John’s local repository looks something like Figure 5-4. -->

Insert 18333fig0504.png
Rysunek 5-4. Lokalne repozytorium Johna.

John ma już odniesienie do zmian które wypchnęła Jessica, ale musi je lokalnie połączyć ze swoimi zmianami, zanim będzie w stanie wypchnąć je:

<!-- John has a reference to the changes Jessica pushed up, but he has to merge them into his own work before he is allowed to push: -->

    $ git merge origin/master
    Merge made by recursive.
     TODO |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

Łączenie zmian poszło bez problemów - historia zmian u Johna wygląda tak jak na rys. 5-5.

<!-- The merge goes smoothly — John’s commit history now looks like Figure 5-5. -->

Insert 18333fig0505.png
Rysunek 5-5. Repozytorium Johna po połączeniu z origin/master.

Teraz, John może przetestować swój kod aby upewnić się że nadal działa poprawnie, oraz następnie wypchnąć swoje zmiany na serwer:

<!-- Now, John can test his code to make sure it still works properly, and then he can push his new merged work up to the server: -->

    $ git push origin master
    ...
    To john@githost:simplegit.git
       fbff5bc..72bbc59  master -> master

Ostatecznie, historia zmian u Johna wygląda tak jak na rys. 5-6.

<!-- Finally, John’s commit history looks like Figure 5-6. -->

Insert 18333fig0506.png
Rysunek 5-6. Historia zmian Johna po wypchnięciu ich na serwer "origin".

<!-- Figure 5-6. John’s history after pushing to the origin server. -->

W tym samym czasie, Jessica pracowała na swojej tematycznej gałęzi. Stworzyła gałąź `issue54` oraz wprowadziła trzy zmiany w niej. Nie pobrała jeszcze zmian Johna, więc jej historia zmian wygląda tak jak na rys. 5-7.

<!-- In the meantime, Jessica has been working on a topic branch. She’s created a topic branch called `issue54` and done three commits on that branch. She hasn’t fetched John’s changes yet, so her commit history looks like Figure 5-7. -->

Insert 18333fig0507.png
Rysunek 5-7. Początkowa historia zmian u Jessici.

Jessica chce zsynchronizować się ze zmianami Johna, więc pobiera ("fetch"):

<!-- Jessica wants to sync up with John, so she fetches: -->

    # Jessica's Machine
    $ git fetch origin
    ...
    From jessica@githost:simplegit
       fbff5bc..72bbc59  master     -> origin/master

Ta komenda pobiera zmiany Johna, które wprowadził w międzyczasie. Historia zmian u Jessici wygląda tak jak na rys. 5-8.

<!-- That pulls down the work John has pushed up in the meantime. Jessica’s history now looks like Figure 5-8. -->

Insert 18333fig0508.png
Rysunek 5-8. Historia zmian u Jessici po pobraniu zmian Johna.

<!-- Figure 5-8. Jessica’s history after fetching John’s changes. -->

Jessica uważa swoje prace w tej gałęzi za zakończone, ale chciałaby wiedzieć jakie zmiany musi włączyć aby mogła wypchnąć swoje. Uruchamia komendę `git log` aby się tego dowiedzieć:

<!-- Jessica thinks her topic branch is ready, but she wants to know what she has to merge her work into so that she can push. She runs `git log` to find out: -->

    $ git log --no-merges origin/master ^issue54
    commit 738ee872852dfaa9d6634e0dea7a324040193016
    Author: John Smith <jsmith@example.com>
    Date:   Fri May 29 16:01:27 2009 -0700

        removed invalid default value

Teraz Jessica może połączyć zmiany ze swojej gałęzi z gałęzią "master", włączyć zmiany Johna (`origin/master`) do swojej gałęzi `master`, oraz następnie wypchnąć zmiany ponownie na serwer.

<!-- Now, Jessica can merge her topic work into her master branch, merge John’s work (`origin/master`) into her `master` branch, and then push back to the server again. First, she switches back to her master branch to integrate all this work: -->

    $ git checkout master
    Switched to branch "master"
    Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Może ona włączyć `origin/master` lub `issue54` jako pierwszą, obie są nadrzędne więc kolejność nie ma znaczenia. Końcowa wersja plików powinna być identyczna bez względu na kolejność którą wybierze; tylko historia będzie się lekko różniła. Wybiera pierwszą do włączenia gałąź `issue54`:

<!-- She can merge either `origin/master` or `issue54` first — they’re both upstream, so the order doesn’t matter. The end snapshot should be identical no matter which order she chooses; only the history will be slightly different. She chooses to merge in `issue54` first: -->

    $ git merge issue54
    Updating fbff5bc..4af4298
    Fast forward
     README           |    1 +
     lib/simplegit.rb |    6 +++++-
     2 files changed, 6 insertions(+), 1 deletions(-)

Nie było problemów; jak widzisz był to proste połączenie tzw. fast-forward. Teraz Jessica może włączyć zmiany Johna (`origin/master`):

<!-- No problems occur; as you can see, it was a simple fast-forward. Now Jessica merges in John’s work (`origin/master`): -->

    $ git merge origin/master
    Auto-merging lib/simplegit.rb
    Merge made by recursive.
     lib/simplegit.rb |    2 +-
     1 files changed, 1 insertions(+), 1 deletions(-)

Wszystko połączyło się bez problemów, więc historia zmian u Jessici wygląda tak jak na rys. 5-9.

<!-- Everything merges cleanly, and Jessica’s history looks like Figure 5-9. -->

Insert 18333fig0509.png
Rysunek 5-9. Historia zmian u Jessici po włączeniu zmian Johna.

<!-- Figure 5-9. Jessica’s history after merging John’s changes. -->

Teraz `origin/master` jest dostępny z gałęzi `master` u Jessici, więc powinna bez problemów móc wypchnąć swoje zmiany (zakładając że w międzyczasie John nie wypchnął nic):

<!-- Now `origin/master` is reachable from Jessica’s `master` branch, so she should be able to successfully push (assuming John hasn’t pushed again in the meantime): -->

    $ git push origin master
    ...
    To jessica@githost:simplegit.git
       72bbc59..8059c15  master -> master

Każdy programista wprowadził zmiany kilkukrotnie, oraz połączył zmiany drugiego bez problemów; zobacz rys. 5-10.

<!-- Each developer has committed a few times and merged each other’s work successfully; see Figure 5-10. -->

Insert 18333fig0510.png
Rysunek 5-10. Historia zmian u Jessici po wypchnięciu zmian na serwer.

<!-- Figure 5-10. Jessica’s history after pushing all changes back to the server. -->

To jest jeden z najprostszych przepływów pracy. Pracujesz przez chwilę, generalnie na tematycznych gałęziach i włączasz je do gałęzi master kiedy są gotowe. Kiedy chcesz podzielić się swoją pracą, włączasz je do swojej gałęzi master, pobierasz i włączasz zmiany z `origin/master` jeżeli jakieś były, a następnie wypychasz gałąź `master` na serwer. Zazwyczaj sekwencja będzie wyglądała podobnie do tej pokazanej na rys. 5-11.

<!-- That is one of the simplest workflows. You work for a while, generally in a topic branch, and merge into your master branch when it’s ready to be integrated. When you want to share that work, you merge it into your own master branch, then fetch and merge `origin/master` if it has changed, and finally push to the `master` branch on the server. The general sequence is something like that shown in Figure 5-11. -->

Insert 18333fig0511.png
Rysunek 5-11. Sekwencja zdarzeń dla prostego przepływu zmian między programistami.

<!-- Figure 5-11. General sequence of events for a simple multiple-developer Git workflow. -->

### Prywatne zarządzane zespoły ###

W tym scenariuszu, zobaczysz jak działa współpraca w większych prywatnych grupach. Nauczysz się jak pracować w środowisku w którym małe grupy współpracują ze sobą nad funkcjonalnościami, a następnie stworzone przez nich zmiany są integrowane przez inną osobę.

<!-- In this next scenario, you’ll look at contributor roles in a larger private group. You’ll learn how to work in an environment where small groups collaborate on features and then those team-based contributions are integrated by another party. -->

Załóżmy że John i Jessica wspólnie pracują nad jedną funkcjonalnością, a Jessica i Josie nad drugą. W tej sytuacji, organizacja używa przepływu pracy z osobą integrującą zmiany, w której wyniki pracy poszczególnych grup są integrowane przez wyznaczone osoby, a gałąź `master` może być jedynie przez nie aktualizowana. W tym scenariuszu, cała praca wykonywana jest w osobnych gałęziach zespołów, a następnie zaciągana przez osoby integrujące.

<!-- Let’s say that John and Jessica are working together on one feature, while Jessica and Josie are working on a second. In this case, the company is using a type of integration-manager workflow where the work of the individual groups is integrated only by certain engineers, and the `master` branch of the main repo can be updated only by those engineers. In this scenario, all work is done in team-based branches and pulled together by the integrators later. -->

Prześledźmy sposób pracy Jessici w czasie gdy pracuje ona nad obiema funkcjonalnościami, współpracując jednocześnie z dwoma niezależnymi programistami. Zakładając że ma już sklonowane repozytorium, rozpoczyna pracę nad funkcjonalnością `featureA`. Tworzy nową gałąź dla niej i wprowadza w niej zmiany:

<!-- Let’s follow Jessica’s workflow as she works on her two features, collaborating in parallel with two different developers in this environment. Assuming she already has her repository cloned, she decides to work on `featureA` first. She creates a new branch for the feature and does some work on it there: -->

    # Jessica's Machine
    $ git checkout -b featureA
    Switched to a new branch "featureA"
    $ vim lib/simplegit.rb
    $ git commit -am 'add limit to log function'
    [featureA 3300904] add limit to log function
     1 files changed, 1 insertions(+), 1 deletions(-)

Teraz musi podzielić się swoją pracę z Johnem, więc wypycha zmiany z gałęzi `featureA` na serwer. Jessica nie ma uprawnień do zapisywania w gałęzi `master` - tylko osoby integrujące mają - musi więc wysłać osobną gałąź aby współpracować z Johnem:

<!-- At this point, she needs to share her work with John, so she pushes her `featureA` branch commits up to the server. Jessica doesn’t have push access to the `master` branch — only the integrators do — so she has to push to another branch in order to collaborate with John: -->

    $ git push origin featureA
    ...
    To jessica@githost:simplegit.git
     * [new branch]      featureA -> featureA

Jessica powiadamia Johna przez wiadomość e-mail, że wysłała swoje zmiany w gałęzi `featureA` i on może je zweryfikować. W czasie gdy czeka na informację zwrotną od Johna, Jessica rozpoczyna pracę nad `featureB` z Josie. Na początku, tworzy nową gałąź przeznaczoną dla nowej funkcjonalności, podając jako gałąź źródłową gałąź `master` na serwerze.

<!-- Jessica e-mails John to tell him that she’s pushed some work into a branch named `featureA` and he can look at it now. While she waits for feedback from John, Jessica decides to start working on `featureB` with Josie. To begin, she starts a new feature branch, basing it off the server’s `master` branch: -->

    # Jessica's Machine
    $ git fetch origin
    $ git checkout -b featureB origin/master
    Switched to a new branch "featureB"

Następnie, Jessica wprowadza kilka zmian i zapisuje je w gałęzi `featureB`:

<!-- Now, Jessica makes a couple of commits on the `featureB` branch: -->

    $ vim lib/simplegit.rb
    $ git commit -am 'made the ls-tree function recursive'
    [featureB e5b0fdc] made the ls-tree function recursive
     1 files changed, 1 insertions(+), 1 deletions(-)
    $ vim lib/simplegit.rb
    $ git commit -am 'add ls-files'
    [featureB 8512791] add ls-files
     1 files changed, 5 insertions(+), 0 deletions(-)

Repozytorium Jessici wygląda tak jak na rys. 5-12.

<!-- Jessica’s repository looks like Figure 5-12. -->

Insert 18333fig0512.png
Rysunek 5-12. Początkowa historia zmian u Jessici.

<!-- Figure 5-12. Jessica’s initial commit history. -->

Jest gotowa do wypchnięcia swoich zmian, ale dostaje wiadomość e-mail od Josie, że gałąź z pierwszymi zmianami została już udostępniona na serwerze jako `featureBee`. Jessica najpierw musi połączyć te zmiany ze swoimi, zanim będzie mogła wysłać je na serwer. Może więc pobrać zmiany Jose za pomocą komendy `git fetch`:

<!-- She’s ready to push up her work, but gets an e-mail from Josie that a branch with some initial work on it was already pushed to the server as `featureBee`. Jessica first needs to merge those changes in with her own before she can push to the server. She can then fetch Josie’s changes down with `git fetch`: -->

    $ git fetch origin
    ...
    From jessica@githost:simplegit
     * [new branch]      featureBee -> origin/featureBee


Jessica może teraz połączyć zmiany ze swoimi za pomocą `git merge`:

<!-- Jessica can now merge this into the work she did with `git merge`: -->

    $ git merge origin/featureBee
    Auto-merging lib/simplegit.rb
    Merge made by recursive.
     lib/simplegit.rb |    4 ++++
     1 files changed, 4 insertions(+), 0 deletions(-)

Powstał drobny problem - musi wysłać połączone zmiany ze swojej gałęzi `featureB` do `featureBee` na serwerze. Może to zrobić poprzez wskazanie lokalnej i zdalnej gałęzi oddzielonej dwukropkiem (:), jako parametr do komendy `git push`:

<!-- There is a bit of a problem — she needs to push the merged work in her `featureB` branch to the `featureBee` branch on the server. She can do so by specifying the local branch followed by a colon (:) followed by the remote branch to the `git push` command: -->

    $ git push origin featureB:featureBee
    ...
    To jessica@githost:simplegit.git
       fba9af8..cd685d1  featureB -> featureBee

jest to nazywane _refspec_. Zobacz rozdział 9, aby dowiedzieć się więcej o refspecs i rzeczami które można z nimi zrobić.

<!-- This is called a _refspec_. See Chapter 9 for a more detailed discussion of Git refspecs and different things you can do with them. -->

Następnie John wysyła wiadomość do Jessici z informacją że wgrał swoje zmiany do gałęzi `featureA` i prosi ją o ich weryfikację. Uruchamia więc ona `git fetch` aby je pobrać:

<!-- Next, John e-mails Jessica to say he’s pushed some changes to the `featureA` branch and ask her to verify them. She runs a `git fetch` to pull down those changes: -->

    $ git fetch origin
    ...
    From jessica@githost:simplegit
       3300904..aad881d  featureA   -> origin/featureA

Następnie, może ona zobaczyć co zostało zmienione za pomocą komendy `git log`:

<!-- Then, she can see what has been changed with `git log`: -->

    $ git log origin/featureA ^featureA
    commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
    Author: John Smith <jsmith@example.com>
    Date:   Fri May 29 19:57:33 2009 -0700

        changed log output to 30 from 25

Na końcu, integruje ona zmiany Johna ze swoimi znajdującymi się w gałęzi `featureA`:

<!-- Finally, she merges John’s work into her own `featureA` branch: -->

    $ git checkout featureA
    Switched to branch "featureA"
    $ git merge origin/featureA
    Updating 3300904..aad881d
    Fast forward
     lib/simplegit.rb |   10 +++++++++-
    1 files changed, 9 insertions(+), 1 deletions(-)

Jessica postanawia jednak wprowadzić jeszcze jakieś zmiany, więc commituje je ponownie i wysyła je z powrotem na serwer:

<!-- Jessica wants to tweak something, so she commits again and then pushes this back up to the server: -->

    $ git commit -am 'small tweak'
    [featureA 774b3ed] small tweak
     1 files changed, 1 insertions(+), 1 deletions(-)
    $ git push origin featureA
    ...
    To jessica@githost:simplegit.git
       3300904..774b3ed  featureA -> featureA

Historia zmian u Jessici wygląda teraz tak jak na rys. 5-13.

<!-- Jessica’s commit history now looks something like Figure 5-13. -->

Insert 18333fig0513.png
Rysunek 5-13. Historia zmian Jessici po wprowadzeniu zmian w gałęzi.

<!-- Figure 5-13. Jessica’s history after committing on a feature branch. -->

Jessica, Josie i John powiadamiają osoby zajmujące się integracją, że gałęzie `featureA` i `featureBee` na serwerze są gotowe do integracji z głównym kodem. Po włączeniu tych gałęzi do głównej, zostaną pobrane zmiany, tworząc historię zmian podobną do tej na rys. 5-14.

<!-- Jessica, Josie, and John inform the integrators that the `featureA` and `featureBee` branches on the server are ready for integration into the mainline. After they integrate these branches into the mainline, a fetch will bring down the new merge commits, making the commit history look like Figure 5-14. -->

Insert 18333fig0514.png
Rysunek 5-14. Historia zmian u Jessici po włączeniu jej obu gałęzi.

<!-- Figure 5-14. Jessica’s history after merging both her topic branches. -->

Duża ilość grup przechodzi na Gita ze względu na możliwość jednoczesnej współpracy kilku zespołów, oraz możliwości włączania efektów ich prac w późniejszym terminie. Możliwość tworzenie małych grup współpracujących przy pomocy zdalnych gałęzi bez konieczności angażowania pozostałych członków zespołu jest bardzo dużą zaletą Gita. Sekwencja przepływu pracy którą tutaj zobaczyłeś, jest podobna do tej na rys. 5-15.

<!-- Many groups switch to Git because of this ability to have multiple teams working in parallel, merging the different lines of work late in the process. The ability of smaller subgroups of a team to collaborate via remote branches without necessarily having to involve or impede the entire team is a huge benefit of Git. The sequence for the workflow you saw here is something like Figure 5-15. -->

Insert 18333fig0515.png
Rysunek 5-15. Przebieg zdarzeń w takim przepływie.

<!-- Figure 5-15. Basic sequence of this managed-team workflow. -->

### Publiczny mały projekt ###

Uczestniczenie w publicznym projekcie trochę się różni. Ponieważ nie masz uprawnień do bezpośredniego wgrywania zmian w projekcie, musisz przekazać swoje zmiany do opiekunów w inny sposób. Pierwszy przykład opisuje udział w projekcie poprzez rozwidlenie poprzez serwis który to umożliwia. Obie strony repo.or.cz oraz GitHub umożliwiają takie działanie, a wielu opiekunów projektów oczekuje takiego stylu współpracy. Następny rozdział opisuje współpracę w projektach, które preferują otrzymywanie łat poprzez wiadomość e-mail.

<!-- Contributing to public projects is a bit different. Because you don’t have the permissions to directly update branches on the project, you have to get the work to the maintainers some other way. This first example describes contributing via forking on Git hosts that support easy forking. The repo.or.cz and GitHub hosting sites both support this, and many project maintainers expect this style of contribution. The next section deals with projects that prefer to accept contributed patches via e-mail. -->

Po pierwsze, na początku musisz sklonować główne repozytorium, stworzyć gałąź tematyczną dla zmian które planujesz wprowadzić, oraz zmiany te zrobić. Sekwencja komend wygląda tak:

<!-- First, you’ll probably want to clone the main repository, create a topic branch for the patch or patch series you’re planning to contribute, and do your work there. The sequence looks basically like this: -->

    $ git clone (url)
    $ cd project
    $ git checkout -b featureA
    $ (work)
    $ git commit
    $ (work)
    $ git commit

Możesz chcieć użyć `rebase -i`, aby złączyć swoje zmiany do jednego commita, lub przeorganizować je, tak aby łata była łatwiejsza do opiekuna do przeglądu - zobacz rozdział 6, aby dowiedzieć się więcej o tego typu operacjach.

<!-- You may want to use `rebase -i` to squash your work down to a single commit, or rearrange the work in the commits to make the patch easier for the maintainer to review — see Chapter 6 for more information about interactive rebasing. -->

Kiedy zmiany w Twojej gałęzi zostaną zakończone i jesteś gotowy do przekazania ich do opiekunów projektu, wejdź na stronę projektu i kliknij przycisk "Fork", tworząc w ten sposób swoją własną kopię projektu z uprawnieniami do zapisu. Następnie musisz dodać nowe zdalne repozytorium, w tym przykładzie nazwane `myfork`:

<!-- When your branch work is finished and you’re ready to contribute it back to the maintainers, go to the original project page and click the "Fork" button, creating your own writable fork of the project. You then need to add in this new repository URL as a second remote, in this case named `myfork`: -->

    $ git remote add myfork (url)

Musisz wysłać swoje zmiany do niego. Najprościej będzie wypchnąć lokalną gałąź na której pracujesz do zdalnego repozytorium, zamiast włączać zmiany do gałęzi master i je wysyłać. Warto zrobić tak dlatego, że w sytuacji w której Twoje zmiany nie zostaną zaakceptowane, lub zostaną zaakceptowane tylko w części, nie będziesz musiał cofać swojej gałęzi master. Jeżeli opiekun włączy, zmieni bazę lub pobierze część twoich zmian, będziesz mógł je otrzymać zaciągając je z ich repozytorium:

<!-- You need to push your work up to it. It’s easiest to push the remote branch you’re working on up to your repository, rather than merging into your master branch and pushing that up. The reason is that if the work isn’t accepted or is cherry picked, you don’t have to rewind your master branch. If the maintainers merge, rebase, or cherry-pick your work, you’ll eventually get it back via pulling from their repository anyhow: -->

    $ git push myfork featureA

Kiedy wgrasz wprowadzone zmiany do swojego rozwidlenia projektu, powinieneś powiadomić o tym opiekuna. Jest to często nazywane `pull request`, i możesz je wygenerować poprzez stronę - GitHub ma przycisk "pull request", który automatycznie generuje wiadomość do opiekuna - lub wykonaj komendę `git request-pull` i wyślij jej wynik do opiekuna projektu samodzielnie.

<!-- When your work has been pushed up to your fork, you need to notify the maintainer. This is often called a pull request, and you can either generate it via the website — GitHub has a "pull request" button that automatically messages the maintainer — or run the `git request-pull` command and e-mail the output to the project maintainer manually. -->

Komenda `request-pull` pobiera docelową gałąź do której chcesz wysłać zmiany, oraz adres URL repozytorium Gita z którego chcesz pobrać zmiany, oraz generuje podsumowanie zmian które będziesz wysyłał. Na przykład, jeżeli Jessica chce wysłać do Johna `pull request`, a wykonała dwie zmiany na swojej gałęzi którą właśnie wypchnęła, powinna uruchomić:

<!-- The `request-pull` command takes the base branch into which you want your topic branch pulled and the Git repository URL you want them to pull from, and outputs a summary of all the changes you’re asking to be pulled in. For instance, if Jessica wants to send John a pull request, and she’s done two commits on the topic branch she just pushed up, she can run this: -->

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


Wynik tej komendy może być wysłany do opiekuna - mówi on z której wersji została stworzona gałąź, podsumowuje zmiany, oraz pokazuje skąd można je pobrać.

<!-- The output can be sent to the maintainer—it tells them where the work was branched from, summarizes the commits, and tells where to pull this work from. -->

W projekcie w którym nie jesteś opiekunem, najprostszym sposobem jest utrzymywanie gałęzi `master` która śledzi `origin/master`, a wprowadzać zmiany w tematycznych gałęziach, które możesz łatwo usunąć jeżeli zostaną odrzucone. Posiadanie oddzielnych gałęzi dla różnych funkcjonalności, ułatwia również tobie zmianę bazy ("rebase") jeżeli główna gałąź zostanie zmieniona i przygotowana łata nie może się poprawnie nałożyć. Na przykład, jeżeli chcesz wysłać drugi zestaw zmian do projektu, nie kontynuuj pracy na gałęzi którą właśnie wypchnąłeś - rozpocznij nową z gałąź `master`:

<!-- On a project for which you’re not the maintainer, it’s generally easier to have a branch like `master` always track `origin/master` and to do your work in topic branches that you can easily discard if they’re rejected.  Having work themes isolated into topic branches also makes it easier for you to rebase your work if the tip of the main repository has moved in the meantime and your commits no longer apply cleanly. For example, if you want to submit a second topic of work to the project, don’t continue working on the topic branch you just pushed up — start over from the main repository’s `master` branch: -->

    $ git checkout -b featureB origin/master
    $ (work)
    $ git commit
    $ git push myfork featureB
    $ (email maintainer)
    $ git fetch origin

Teraz, każdy z zestawów zmian przechowywany jest w formie silosu - podobnego do kolejki z łatami - które możesz nadpisać, zmienić, bez konieczności nachodzenia na siebie, tak jak przedstawiono to na rys. 5-16.

<!-- Now, each of your topics is contained within a silo — similar to a patch queue — that you can rewrite, rebase, and modify without the topics interfering or interdepending on each other as in Figure 5-16. -->

Insert 18333fig0516.png
Rysunek 5-16. Początkowa historia ze zmianami featureB.

<!-- Figure 5-16. Initial commit history with featureB work. -->

Załóżmy, że opiekun projektu pobrał Twoje zmiany i sprawdził twoją pierwszą gałąź, ale niestety nie aplikuje się ona czysto. W takiej sytuacji, możesz spróbować wykonać `rebase` na gałęzi `origin/master`, rozwiązać konflikty i ponownie wysłać zmiany:

<!-- Let’s say the project maintainer has pulled in a bunch of other patches and tried your first branch, but it no longer cleanly merges. In this case, you can try to rebase that branch on top of `origin/master`, resolve the conflicts for the maintainer, and then resubmit your changes: -->

    $ git checkout featureA
    $ git rebase origin/master
    $ git push -f myfork featureA

To przepisuje twoją historię, która wygląda teraz tak jak na rys. 5-17.

<!-- This rewrites your history to now look like Figure 5-17. -->

Insert 18333fig0517.png
Rysunek 5-17. Historia zmian po pracach na featureA.

<!-- Figure 5-17. Commit history after featureA work. -->

Z powodu zmiany bazy ("rebase") na gałęzi, musisz użyć przełącznika `-f` do komendy push, tak abyś mógł nadpisać gałąź `featureA` na serwerze, commitem który nie jest jej potomkiem. Alternatywą może być wysłanie tych zmian do nowej gałęzi na serwerze (np. nazwanej `featureAv2`).

<!-- Because you rebased the branch, you have to specify the `-f` to your push command in order to be able to replace the `featureA` branch on the server with a commit that isn’t a descendant of it. An alternative would be to push this new work to a different branch on the server (perhaps called `featureAv2`). -->

Spójrzmy na jeszcze jeden scenariusz: opiekun spojrzał na zmiany w Twojej drugiej gałęzi i spodobał mu się pomysł, ale chciałby abyś zmienił sposób w jaki je zaimplementowałeś. Wykorzystasz to również do tego, aby przenieść zmiany do obecnej gałęzi `master`. Tworzysz więc nową gałąź bazując na `origin/master`, złączasz zmiany z gałęzi `featureB` tam, rozwiązujesz ewentualne konflikty, wprowadzasz zmiany w implementacji i następnie wypychasz zmiany do nowej gałęzi:

<!-- Let’s look at one more possible scenario: the maintainer has looked at work in your second branch and likes the concept but would like you to change an implementation detail. You’ll also take this opportunity to move the work to be based off the project’s current `master` branch. You start a new branch based off the current `origin/master` branch, squash the `featureB` changes there, resolve any conflicts, make the implementation change, and then push that up as a new branch: -->

    $ git checkout -b featureBv2 origin/master
    $ git merge --no-commit --squash featureB
    $ (change implementation)
    $ git commit
    $ git push myfork featureBv2


Opcja `--squash` pobiera wszystkie zmiany z gałęzi, oraz łączy je w jedną nie włączoną na gałęzi na której obecnie jesteś. Opcja `--no-commit` mówi Git aby nie zapisywał informacji o commit-cie. Pozwala to na zaimportowanie wszystkich zmian z innej gałęzi oraz wprowadzenie nowych przed ostatecznym zatwierdzeniem ich.

<!-- The `-\-squash` option takes all the work on the merged branch and squashes it into one non-merge commit on top of the branch you’re on. The `-\-no-commit` option tells Git not to automatically record a commit. This allows you to introduce all the changes from another branch and then make more changes before recording the new commit. -->

Teraz możesz wysłać do opiekuna wiadomość, że wprowadziłeś wszystkie wymagane zmiany, które może znaleźć w gałęzi `featureBv2` (zob. rys. 5-18).

<!-- Now you can send the maintainer a message that you’ve made the requested changes and they can find those changes in your `featureBv2` branch (see Figure 5-18). -->

Insert 18333fig0518.png
Rysunek 5-18. Historia zmian po zmianach w featureBv2.

<!-- Figure 5-18. Commit history after featureBv2 work. -->

### Duży publiczny projekt ###

Duża ilość większych projektów ma ustalone reguły dotyczące akceptowania łat - będziesz musiał sprawdzić konkretne zasady dla każdego z projektów, ponieważ będą się różniły. Jednak sporo większych projektów akceptuje łatki poprzez listy dyskusyjne przeznaczone dla programistów, dlatego też opiszę ten przykład teraz.

<!-- Many larger projects have established procedures for accepting patches — you’ll need to check the specific rules for each project, because they will differ. However, many larger public projects accept patches via a developer mailing list, so I’ll go over an example of that now. -->

Przepływ pracy jest podobny do poprzedniego - tworzysz tematyczne gałęzie dla każdej grupy zmian nad którymi pracujesz. Różnica polega na tym, w jaki sposób wysyłasz je do projektu. Zamiast tworzyć rozwidlenie i wypychać do niego zmiany, tworzysz wiadomość e-mail dla każdego zestawu zmian i wysyłasz je na listę dyskusyjną:

<!-- The workflow is similar to the previous use case — you create topic branches for each patch series you work on. The difference is how you submit them to the project. Instead of forking the project and pushing to your own writable version, you generate e-mail versions of each commit series and e-mail them to the developer mailing list: -->

    $ git checkout -b topicA
    $ (work)
    $ git commit
    $ (work)
    $ git commit

Teraz masz dwa commity, które chcesz wysłać na listę dyskusyjną. Uzyj `git format-patch` do wygenerowania plików w formacie mbox, które możesz wysłać na listę - zamieni to każdy commit w osobną wiadomość, z pierwszą linią komentarza ("commit message") jako tematem, jego pozostałą częścią w treści, dołączając jednoczenie zawartość wprowadzanej zmiany. Fajną rzeczą jest to, że aplikowanie łatki przesłanej przez e-mail i wygenerowanej za pomocą `format-patch` zachowuje wszystkie informacje o commit-cie, co zobaczysz w kolejnej sekcji kiedy zaaplikujesz te zmiany:

<!-- Now you have two commits that you want to send to the mailing list. You use `git format-patch` to generate the mbox-formatted files that you can e-mail to the list — it turns each commit into an e-mail message with the first line of the commit message as the subject and the rest of the message plus the patch that the commit introduces as the body. The nice thing about this is that applying a patch from an e-mail generated with `format-patch` preserves all the commit information properly, as you’ll see more of in the next section when you apply these patches: -->

    $ git format-patch -M origin/master
    0001-add-limit-to-log-function.patch
    0002-changed-log-output-to-30-from-25.patch

Komenda `format-patch` wypisuje nazwy plików które stworzyła. Opcja `-M` mówi Git, aby brał pod uwagę również zmiany nazw plików. Zawartość plików w efekcie końcowym wygląda tak:

<!-- The `format-patch` command prints out the names of the patch files it creates. The `-M` switch tells Git to look for renames. The files end up looking like this: -->

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

Możesz oczywiście zmienić te pliki i dodać większą ilość informacji w mailu, których nie chciałeś pokazywać w komentarzu do zmiany. Jeżeli dodasz tekst miedzy linię z `---`, oraz początkiem łaty (linia z `lib/simplegit.rb`), programiści będą mogli to przeczytać; ale podczas nakładania łaty zostanie do pominięte.

<!-- You can also edit these patch files to add more information for the e-mail list that you don’t want to show up in the commit message. If you add text between the `-\-\-` line and the beginning of the patch (the `lib/simplegit.rb` line), then developers can read it; but applying the patch excludes it. -->

Aby wysłać to na listę dyskusyjną, możesz albo wkleić zawartość plików w programie e-mail lub użyć programu uruchamianego z linii komend. Wklejanie tekstu często wprowadza problemy z zachowaniem formatowania, szczególnie przy użyciu tych "mądrzejszych" programów pocztowych, które nie zachowują poprawnie znaków nowej linii i spacji. Na szczęście Git udostępnia narzędzie, które pomoże Ci wysłać poprawnie sformatowane łaty poprzez protokół IMAP, może to być łatwiejsze dla Ciebie. Pokażę w jaki sposób wysyłać łaty przy pomocy Gmaila, którego używam; możesz znaleźć bardziej szczegółowe instrukcje dla różnych programów pocztowych na końcu wcześniej wymienionego pliku `Documentation/SubmittingPatches`, który znajduje się w kodzie źródłowym Gita.

<!-- To e-mail this to a mailing list, you can either paste the file into your e-mail program or send it via a command-line program. Pasting the text often causes formatting issues, especially with "smarter" clients that don’t preserve newlines and other whitespace appropriately. Luckily, Git provides a tool to help you send properly formatted patches via IMAP, which may be easier for you. I’ll demonstrate how to send a patch via Gmail, which happens to be the e-mail agent I use; you can read detailed instructions for a number of mail programs at the end of the aforementioned `Documentation/SubmittingPatches` file in the Git source code. -->

Najpierw musisz ustawić sekcję imap w swoim pliku `~/.gitconfig`. Możesz ustawić każdą wartość oddzielnie przy pomocy kilku komend `git config`, lub możesz je dodać ręcznie; jednak w efekcie twój plik konfiguracyjny powinien wyglądać podobnie do:

<!-- First, you need to set up the imap section in your `~/.gitconfig` file. You can set each value separately with a series of `git config` commands, or you can add them manually; but in the end, your config file should look something like this: -->

    [imap]
      folder = "[Gmail]/Drafts"
      host = imaps://imap.gmail.com
      user = user@gmail.com
      pass = p4ssw0rd
      port = 993
      sslverify = false

Jeżeli twój serwer IMAP nie używa SSL, dwie ostatnie linie prawdopodobnie nie są potrzebne, a wartość host będzie `imap://` zamiast `imaps://`. Po ustawieniu tego, możesz używać komendy `git send-email` aby umieścić łatki w folderze Draft na serwerze IMAP:

<!-- If your IMAP server doesn’t use SSL, the last two lines probably aren’t necessary, and the host value will be `imap://` instead of `imaps://`.
When that is set up, you can use `git send-email` to place the patch series in the Drafts folder of the specified IMAP server: -->

    $ git send-email *.patch
    0001-added-limit-to-log-function.patch
    0002-changed-log-output-to-30-from-25.patch
    Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
    Emails will be sent from: Jessica Smith <jessica@example.com>
    Who should the emails be sent to? jessica@example.com
    Message-ID to be used as In-Reply-To for the first email? y

Następnie, Git pokaże garść informacji podobnych tych, dla każdej łaty którą wysyłasz:

<!-- Then, Git spits out a bunch of log information looking something like this for each patch you’re sending: -->

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

Od tego momentu powinieneś móc przejść do folderu Draft, zmienić pole odbiorcy wiadomości na adres listy dyskusyjnej do której wysyłasz łatę, ewentualnie dodać adres osób zainteresowanych tym tematem w kopii i wysłać.

<!-- At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off. -->

### Podsumowanie ###

Ten rozdział opisywał kilka z najczęściej używanych sposobów przepływu pracy z różnymi projektami Git które możesz spotkać, oraz wprowadził kilka nowych narzędzi które ułatwiają ten proces. W następnych sekcjach zobaczysz jak pracować z drugiej strony: prowadząc projekt Gita. Nauczysz się jak być miłosiernym dyktatorem oraz osobą integrującą zmiany innych.

<!-- This section has covered a number of common workflows for dealing with several very different types of Git projects you’re likely to encounter and introduced a couple of new tools to help you manage this process. Next, you’ll see how to work the other side of the coin: maintaining a Git project. You’ll learn how to be a benevolent dictator or integration manager. -->

## Utrzymywanie projektu ##

Ponad to co musisz wiedzieć, aby efektywnie uczestniczyć w projekcie, powinieneś również wiedzieć jak go utrzymywać. Składa się na to akceptowanie i nakładanie łat wygenerowanych przez `format-patch` i wysłanych do Ciebie, lub łączenie zmian z zewnętrznych repozytoriów które dodałeś w projekcie. Nieważne czy prowadzisz zwykłe repozytorium, lub chcesz pomóc przy weryfikacji i integrowaniu łat, musisz wiedzieć w jaki sposób akceptować zmiany innych w taki sposób, który będzie przejrzysty dla innych i spójny w dłuższym okresie.

<!-- In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run. -->

### Praca z gałęziami tematycznymi ###

Jeżeli zamierzasz włączyć nowe zmiany, dobrym pomysłem jest stworzenie do tego nowej tymczasowej gałęzi, specjalnie przygotowanej do tego, aby przetestować te zmiany. W ten sposób najłatwiej dostosować pojedyncze zmiany, lub zostawić je jeżeli nie działają, do czasu aż będziesz mógł się tym ponownie zająć. Jeżeli stworzysz nową gałąź bazując na głównym motywie wprowadzanych zmian które chcesz przetestować, np. `ruby_client` lub coś podobnego, możesz łatwo zapamiętać czy musiałeś ją zostawić aby później do niej wrócić. Opiekun projektu Git często tworzy oddzielną przestrzeń nazw dla nich - np. `sc/ruby_client`, gdzie `sc` jest skrótem od osoby która udostępniła zmianę.
Jak pamiętasz, możesz stworzyć nową gałąź bazując na swojej gałęzi master, w taki sposób:

<!-- When you’re thinking of integrating new work, it’s generally a good idea to try it out in a topic branch — a temporary branch specifically made to try out that new work. This way, it’s easy to tweak a patch individually and leave it if it’s not working until you have time to come back to it. If you create a simple branch name based on the theme of the work you’re going to try, such as `ruby_client` or something similarly descriptive, you can easily remember it if you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these branches as well — such as `sc/ruby_client`, where `sc` is short for the person who contributed the work.
As you’ll remember, you can create the branch based off your master branch like this: -->

    $ git branch sc/ruby_client master

Lub, jeżeli chcesz się od razu na nią przełączyć, możesz użyć komendy `checkout -b`:

<!-- Or, if you want to also switch to it immediately, you can use the `checkout -b` command: -->

    $ git checkout -b sc/ruby_client master

Teraz jesteś gotowy do tego, aby dodać do niej udostępnione zmiany i zdecydować czy chcesz je włączyć do jednej ze swoich gałęzi.

<!-- Now you’re ready to add your contributed work into this topic branch and determine if you want to merge it into your longer-term branches. -->

### Aplikowanie łat przychodzących e-mailem ###

Jeżeli otrzymasz łatę poprzez wiadomość e-mail, którą musisz włączyć do swojego projektu, musisz zaaplikować ją do gałęzi tematycznej w celu przetestowania. Istnieją dwa sposoby aby włączyć takie zmiany: przy użyciu `git apply` lub `git am`.

<!-- If you receive a patch over e-mail that you need to integrate into your project, you need to apply the patch in your topic branch to evaluate it. There are two ways to apply an e-mailed patch: with `git apply` or with `git am`. -->

#### Aplikowanie łaty za pomocą komendy apply ####

Jeżeli otrzymałeś łatę od kogoś kto wygenerował ją za pomocą komendy `git diff` lub uniksowej `diff`, możesz zaaplikować ją za pomocą komendy `git apply`. Zakładając, że zapisałeś plik w `/tmp/patch-ruby-client.patch`, możesz go nałożyć w taki sposób:

<!-- If you received the patch from someone who generated it with the `git diff` or a Unix `diff` command, you can apply it with the `git apply` command. Assuming you saved the patch at `/tmp/patch-ruby-client.patch`, you can apply the patch like this: -->

    $ git apply /tmp/patch-ruby-client.patch

Ta komenda zmodyfikuje pliki znajdujące się w obecnym katalogu. Jest ona prawie identyczna do komendy `patch -p1` w celu nałożenia łaty, ale jest bardziej restrykcyjna pod względem akceptowanych zmian. Obsługuje również dodawanie plików, usuwanie, oraz zmiany nazw jeżeli zostały zapisane w formacie `git diff`, czego komenda `patch` nie zrobi. Wreszcie, `git apply` ma zasadę "zaakceptuj lub odrzuć wszystko", gdzie albo wszystko jest zaakceptowane albo nic, a `patch` może częściowo nałożyć zmiany zostawiając projekt z niespójnym stanem. Komenda `git apply` jest z zasady bardziej restrykcyjna niż `patch`. Nie stworzy za Ciebie commita - po uruchomieniu, musisz zatwierdzić wprowadzone zmiany ręcznie.

<!-- This modifies the files in your working directory. It’s almost identical to running a `patch -p1` command to apply the patch, although it’s more paranoid and accepts fewer fuzzy matches than patch. It also handles file adds, deletes, and renames if they’re described in the `git diff` format, which `patch` won’t do. Finally, `git apply` is an "apply all or abort all" model where either everything is applied or nothing is, whereas `patch` can partially apply patchfiles, leaving your working directory in a weird state. `git apply` is overall much more paranoid than `patch`. It won’t create a commit for you — after running it, you must stage and commit the changes introduced manually. -->

Możesz również użyć `git apply` aby zobaczyć, czy łata nałoży się czysto zanim ją zaaplikujesz - jeżeli uruchomiesz `git apply --check` z łatą:

<!-- You can also use git apply to see if a patch applies cleanly before you try actually applying it — you can run `git apply -\-check` with the patch: -->

    $ git apply --check 0001-seeing-if-this-helps-the-gem.patch
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply

Jeżeli nie zostanie wygenerowany żaden komunikat, to łata nałoży się poprawnie. Ta komenda również kończy działanie z niezerowym statusem w przypadku błędu, możesz więc użyć jej w skryptach jeżeli tylko chcesz.

<!-- If there is no output, then the patch should apply cleanly. This command also exits with a non-zero status if the check fails, so you can use it in scripts if you want. -->

#### Aplikowanie łaty za pomocą am ####

Jeżeli otrzymałeś łatę wygenerowaną przez użytkownika używającego Gita, który stworzył go za pomocą `format-patch`, twoja praca będzie prostsza ponieważ łatka zawiera już informacje o autorze oraz komentarz do zmiany. Jeżeli możesz, namawiaj swoich współpracowników aby używali `format-patch` zamiast `diff` do generowania dla Ciebie łat. Powinieneś móc użyć jedynie `git apply` dla takich łat.

<!-- If the contributor is a Git user and was good enough to use the `format-patch` command to generate their patch, then your job is easier because the patch contains author information and a commit message for you. If you can, encourage your contributors to use `format-patch` instead of `diff` to generate patches for you. You should only have to use `git apply` for legacy patches and things like that. -->

Aby zaaplikować łatę wygenerowaną przez `format-patch`, użyj `git am`. Technicznie rzecz biorąc, `git am` został stworzony, aby odczytywać plik w formacie mbox, który jest prostym, tekstowym formatem zawierającym jedną lub więcej wiadomości e-mail w jednym pliku. Wygląda on podobnie do:

<!-- To apply a patch generated by `format-patch`, you use `git am`. Technically, `git am` is built to read an mbox file, which is a simple, plain-text format for storing one or more e-mail messages in one text file. It looks something like this: -->

    From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
    From: Jessica Smith <jessica@example.com>
    Date: Sun, 6 Apr 2008 10:17:23 -0700
    Subject: [PATCH 1/2] add limit to log function

    Limit log functionality to the first 20

To są pierwsze linie z wyniku komendy format-patch którą zobaczyłeś w poprzedniej sekcji. Jest to również poprawny plik w formacie mbox. Jeżeli ktoś poprawnie przesłał do Ciebie łatkę za pomocą `git send-email`, możesz ją zapisać w formacie mbox, następnie wskazać `git am` ten plik, a git zacznie aplikować wszystkie łatki które znajdzie. Jeżeli używasz klienta pocztowego, który potrafi zapisać kilka wiadomości e-mail w formacie mbox, możesz zapisać serię łatek do pliku i uzyć `git am` aby jest wszystkie nałożyć za jednym zamachem.

<!-- This is the beginning of the output of the format-patch command that you saw in the previous section. This is also a valid mbox e-mail format. If someone has e-mailed you the patch properly using git send-email, and you download that into an mbox format, then you can point git am to that mbox file, and it will start applying all the patches it sees. If you run a mail client that can save several e-mails out in mbox format, you can save entire patch series into a file and then use git am to apply them one at a time. -->

Również, jeżeli ktoś wgrał łatkę wygenerowaną poprzez `format-patch` do systemy rejestracji błędów lub czegoś podobnego, możesz zapisać lokalnie ten plik i potem przekazać go do `git am` aby zaaplikować go:

<!-- However, if someone uploaded a patch file generated via `format-patch` to a ticketing system or something similar, you can save the file locally and then pass that file saved on your disk to `git am` to apply it: -->

    $ git am 0001-limit-log-function.patch
    Applying: add limit to log function

Możesz zobaczyć, że został czysto nałożony i automatycznie zatwierdzony. Informacje o autorze zostały pobrane z wiadomości e-mail z nagłówków `From` i `Date`, a treść komentarz została pobrana z tematu i treści (przed łatką) e-maila. Na przykład, jeżeli ta łatka została zaaplikowana z pliku mbox który przed chwilą pokazałem, wygenerowany commit będzie wygląda podobnie do:

<!-- You can see that it applied cleanly and automatically created the new commit for you. The author information is taken from the e-mail’s `From` and `Date` headers, and the message of the commit is taken from the `Subject` and body (before the patch) of the e-mail. For example, if this patch was applied from the mbox example I just showed, the commit generated would look something like this: -->

    $ git log --pretty=fuller -1
    commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
    Author:     Jessica Smith <jessica@example.com>
    AuthorDate: Sun Apr 6 10:17:23 2008 -0700
    Commit:     Scott Chacon <schacon@gmail.com>
    CommitDate: Thu Apr 9 09:19:06 2009 -0700

       add limit to log function

       Limit log functionality to the first 20


Linie zaczynające się od `Commit` pokazują osobę która zaaplikowała łatkę oraz czas kiedy to zrobiła. Linie rozpoczynające się od `Author` pokazują osobę która stworzyła łatę wraz z dokładną datę.

<!-- The `Commit` information indicates the person who applied the patch and the time it was applied. The `Author` information is the individual who originally created the patch and when it was originally created. -->

Jednak możliwa jest również sytuacja, w której łatka nie zostanie bez problemów nałożona. Być może twoja gałąź zbyt mocno się zmieniła, w stosunku do gałęzi na której łatka została stworzona, albo zależna jest ona od innej łatki której jeszcze nie nałożyłeś. W takiej sytuacji `git am` zakończy się błędem i zapyta co robić dalej:

<!-- But it’s possible that the patch won’t apply cleanly. Perhaps your main branch has diverged too far from the branch the patch was built from, or the patch depends on another patch you haven’t applied yet. In that case, the `git am` process will fail and ask you what you want to do: -->

    $ git am 0001-seeing-if-this-helps-the-gem.patch
    Applying: seeing if this helps the gem
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply
    Patch failed at 0001.
    When you have resolved this problem run "git am --resolved".
    If you would prefer to skip this patch, instead run "git am --skip".
    To restore the original branch and stop patching run "git am --abort".

Ta komenda zaznacza pliku z którymi miała problemy, podobnie do konfliktów występujących podczas komend `merge` lub `rebase`. Rozwiązujesz takie sytuacja również analogicznie - zmień plik w celu rozwiązania konfliktu, dodaj do przechowalni nowe pliki i następnie uruchom `git am --resolved` aby kontynuować działanie do następnej łatki:

<!-- This command puts conflict markers in any files it has issues with, much like a conflicted merge or rebase operation. You solve this issue much the same way — edit the file to resolve the conflict, stage the new file, and then run `git am -\-resolved` to continue to the next patch: -->

    $ (fix the file)
    $ git add ticgit.gemspec
    $ git am --resolved
    Applying: seeing if this helps the gem

Jeżeli chcesz aby Git spróbował w bardziej inteligentny sposób rozwiązać konflikty, dodaj opcję `-3` do komendy, która daje Gitowi możliwość spróbowania trójstronnego łączenia. Opcja ta nie jest domyślnie włączona, ponieważ nie działa poprawnie w sytuacji gdy w twoim repozytorium nie ma commitu na którym bazuje łata. Jeżeli go masz - jeżeli łatka bazowała na publicznym commit-cie - to dodanie `-3` zazwyczaj pozwala na dużo mądrzejsze zaaplikowanie konfliktującej łatki:

<!-- If you want Git to try a bit more intelligently to resolve the conflict, you can pass a `-3` option to it, which makes Git attempt a three-way merge. This option isn’t on by default because it doesn’t work if the commit the patch says it was based on isn’t in your repository. If you do have that commit — if the patch was based on a public commit — then the `-3` option is generally much smarter about applying a conflicting patch: -->

    $ git am -3 0001-seeing-if-this-helps-the-gem.patch
    Applying: seeing if this helps the gem
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply
    Using index info to reconstruct a base tree...
    Falling back to patching base and 3-way merge...
    No changes -- Patch already applied.

W tej sytuacji, próbowałem zaaplikować łatkę którą już wcześniej włączyłem. Bez podanej opcji `-3` wyglądało to na konflikt.

<!-- In this case, I was trying to apply a patch I had already applied. Without the `-3` option, it looks like a conflict. -->

Jeżeli włączasz większą liczbę łat z pliku mbox, możesz użyć komendy `am` w trybie interaktywnym, który zatrzymuje się na każdej łacie którą znajdzie i pyta czy chcesz ją zaaplikować:

<!-- If you’re applying a number of patches from an mbox, you can also run the `am` command in interactive mode, which stops at each patch it finds and asks if you want to apply it: -->

    $ git am -3 -i mbox
    Commit Body is:
    --------------------------
    seeing if this helps the gem
    --------------------------
    Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

Jest to całkiem dobre jeżeli masz zapisaną większą liczbę łat, ponieważ możesz najpierw zobaczyć łatę jeżeli nie pamiętasz do czego była, lub nie aplikować jej jeżeli już to zrobiłeś.

<!-- This is nice if you have a number of patches saved, because you can view the patch first if you don’t remember what it is, or not apply the patch if you’ve already done so. -->

Kiedy wszystkie łatki zostaną wgrane i commitnięte w Twojej gałęzi, możesz zastanowić się w jaki sposób i czy chcesz integrować je do jednej z głównych gałęzi.

<!-- When all the patches for your topic are applied and committed into your branch, you can choose whether and how to integrate them into a longer-running branch. -->

### Sprawdzanie zdalnych gałęzi ###

Jeżeli zmiana przyszła od użytkownika Gita który ma skonfigurowane własne repozytorium, wgrał do niego już jakąś liczbę zmian i następnie wysłał do Ciebie adres URL repozytorium oraz nazwę zdalnej gałęzi zawierającej zmiany, możesz ją dodać jako zdalną i połączyć zmiany lokalnie.

<!-- If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and then sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and do merges locally. -->

Na przykład, jeżeli Jessica wysyła Ci wiadomość e-mail w której pisze, że ma nową funkcjonalność w gałęzi `ruby-client` w swoim repozytorium, możesz je przetestować dodając zdalne repozytorium i sprawdzając tą gałąź lokalnie:

<!-- For instance, if Jessica sends you an e-mail saying that she has a great new feature in the `ruby-client` branch of her repository, you can test it by adding the remote and checking out that branch locally: -->

    $ git remote add jessica git://github.com/jessica/myproject.git
    $ git fetch jessica
    $ git checkout -b rubyclient jessica/ruby-client

Jeżeli napisze do Ciebie ponownie z nową gałęzią która zawiera kolejną funkcjonalność, możesz ją pobrać i sprawdzić ponieważ masz już dodane zdalne repozytorium.

<!-- If she e-mails you again later with another branch containing another great feature, you can fetch and check out because you already have the remote setup. -->

Jest to bardzo pomocne w sytuacji, w której współpracujesz z jakąś osobą na stałe. Jeżeli ktoś ma tylko pojedyncze łatki które udostępnia raz na jakiś czas, to akceptowanie ich poprzez e-mail może być szybsze, niż zmuszanie wszystkich do tego aby mieli własny serwer, jak również dodawanie i usuwanie zdalnych repozytoriów aby otrzymać jedną lub dwie łatki. Jednakże, skrypty oraz usługi udostępniane mogą uczynić to prostszym - zależy od tego w taki sposób pracujesz, oraz jak pracują Twoi współpracownicy.

<!-- This is most useful if you’re working with a person consistently. If someone only has a single patch to contribute once in a while, then accepting it over e-mail may be less time consuming than requiring everyone to run their own server and having to continually add and remove remotes to get a few patches. You’re also unlikely to want to have hundreds of remotes, each for someone who contributes only a patch or two. However, scripts and hosted services may make this easier — it depends largely on how you develop and how your contributors develop. -->

Kolejną zaletą takiego podejścia jest to, że otrzymujesz również całą historię zmian. Chociaż mogą zdarzyć się uzasadnione problemy ze scalaniem zmian, wiesz na którym etapie historii ich praca bazowała; prawidłowe trójstronne scalenie jest domyślne, nie musisz więc podawać `-3` i mieć nadzieję że łatka została wygenerowana z publicznie dostępnego commitu/zmiany.

<!-- The other advantage of this approach is that you get the history of the commits as well. Although you may have legitimate merge issues, you know where in your history their work is based; a proper three-way merge is the default rather than having to supply a `-3` and hope the patch was generated off a public commit to which you have access. -->

Jeżeli nie współpracujesz z jakąś osobą na stałe, ale mimo wszystko chcesz pobrać od niej zmiany w ten sposób, możesz podać URL repozytorium do komendy `git pull`. Wykona ona jednokrotne zaciągnięcie zmian i nie zapisze URL repozytorium jako zdalnego:

<!-- If you aren’t working with a person consistently but still want to pull from them in this way, you can provide the URL of the remote repository to the `git pull` command. This does a one-time pull and doesn’t save the URL as a remote reference: -->

    $ git pull git://github.com/onetimeguy/project.git
    From git://github.com/onetimeguy/project
     * branch            HEAD       -> FETCH_HEAD
    Merge made by recursive.

### Ustalenie co zostało wprowadzone ###

Teraz posiadać gałąź tematyczną która zawiera otrzymane zmiany. W tym momencie możesz zdecydować co chcesz z nimi zrobić. Ta sekcja przywołuje kilka komend, tak abyś mógł zobaczyć w jaki sposób ich użyć, aby przejrzeć dokładnie co będziesz włączał do głównej gałęzi.

<!-- Now you have a topic branch that contains contributed work. At this point, you can determine what you’d like to do with it. This section revisits a couple of commands so you can see how you can use them to review exactly what you’ll be introducing if you merge this into your main branch. -->

Często pomocne jest przejrzenie wszystkich zmian które są w tej gałęzi, ale nie ma ich w gałęzi master. Możesz wyłączyć zmiany z gałęzi master poprzez dodanie opcji `--not` przed jej nazwą. Na przykład, jeżeli twój współpracownik prześle ci dwie łaty, a ty stworzysz nową gałąź `contrib` i włączysz te łatki tam, możesz uruchomić:

<!-- It’s often helpful to get a review of all the commits that are in this branch but that aren’t in your master branch. You can exclude commits in the master branch by adding the `-\-not` option before the branch name. For example, if your contributor sends you two patches and you create a branch called `contrib` and applied those patches there, you can run this: -->

    $ git log contrib --not master
    commit 5b6235bd297351589efc4d73316f0a68d484f118
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Fri Oct 24 09:53:59 2008 -0700

        seeing if this helps the gem

    commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Mon Oct 22 19:38:36 2008 -0700

        updated the gemspec to hopefully work better

Aby zobaczyć jakie zmiany każdy z commitów wniósł, zapamiętaj że możesz dodać opcję `-p` do `git log`, a otrzymasz również w wyniku różnice w kodzie.

<!-- To see what changes each commit introduces, remember that you can pass the `-p` option to `git log` and it will append the diff introduced to each commit. -->

Aby zobaczyć różnice tego co się stanie, jeżeli chciałbyś połączyć tą gałąź z inną, będziesz musiał użyć całkiem ciekawych sztuczek aby otrzymać poprawne wyniki. Możesz pomyśleć, aby uruchomić:

<!-- To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to use a weird trick to get the correct results. You may think to run this: -->

    $ git diff master

Ta komenda pokaże ci różnice w kodzie, ale może to być mylące. Jeżeli twoja gałąź `master` zmieniła się od czasu stworzenia gałęzi tematycznej, otrzymasz dziwne wyniki. Tak dzieje się dlatego, ponieważ Git porównuje bezpośrednio ostatnią migawkę z gałęzi tematycznej, z ostatnią migawkę w gałęzi `master`. Na przykład, jeżeli dodasz linię w pliku w gałęzi `master`, bezpośrednie porównanie pokaże, że gałąź tematyczna zamierza usunąć tą linię.

<!-- This command gives you a diff, but it may be misleading. If your `master` branch has moved forward since you created the topic branch from it, then you’ll get seemingly strange results. This happens because Git directly compares the snapshots of the last commit of the topic branch you’re on and the snapshot of the last commit on the `master` branch. For example, if you’ve added a line in a file on the `master` branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line. -->

Jeżeli `master` jest bezpośrednim przodkiem Twojej gałęzi tematycznej, nie stanowi to problemu; jeżeli jednak obie linie się rozjechały, wynik `diff` pokaże dodawane wszystkie zmiany z gałęzi tematycznej, a usuwane wszystkie unikalne z `master`.

<!-- If `master` is a direct ancestor of your topic branch, this isn’t a problem; but if the two histories have diverged, the diff will look like you’re adding all the new stuff in your topic branch and removing everything unique to the `master` branch. -->

Wynik którego naprawdę oczekujesz, to ten, pokazujący zmiany będące w gałęzi tematycznej - zmiany które wprowadzisz jeżeli scalisz tą gałąź z master. Możesz to zrobić, poprzez porównanie ostatniego commitu z gałęzi tematycznej, z pierwszym wspólnym przodkiem z gałęzi master.

<!-- What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch. -->

Technicznie rzecz ujmując, możesz to zrobić poprzez wskazanie wspólnego przodka i uruchomienie na nim diff:

<!-- Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it: -->

    $ git merge-base contrib master
    36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
    $ git diff 36c7db


Jednak to nie jest wygodne rozwiązanie, dlatego Git udostępnia krótszą metodę aby to osiągnąć: składnie z potrójną kropką. W kontekście komendy `diff`, możesz wstawić trzy kropki po nazwie gałęzi z którą chcesz porównać, aby otrzymać różnice z ostatniej zmiany z gałęzi na której się znajdujesz a wspólnym przodkiem tej drugiej.

<!-- However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch: -->

    $ git diff master...contrib

Ta komenda pokaże zmiany wprowadzone tylko w gałęzi tematycznej, od czasu jej stworzenia. Jest to bardzo użyteczna składnia warta zapamiętania.

<!-- This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember. -->

### Integrowanie otrzymanych zmian ###

Kiedy zakończysz prace nad zmianami w gałęzi tematycznej i będą one gotowe do włączenia do głównej, pozostaje pytanie w jaki sposób to zrobić. Ponadto, jaki rodzaj przepływu pracy chcesz stosować w swoim projekcie? Masz różne możliwości, opiszę więc kilka z nich.

<!-- When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them. -->

#### Przepływ pracy podczas scalania zmian ####

Jednym z prostszych przepływów pracy jest scalenie zmian z twoją gałęzią `master`. W tym scenariuszu, posiadasz gałąź `master` która zawiera stabilny kod. Kiedy masz zmiany w jednej z gałęzi tematycznych które wykonałeś, lub ktoś Ci przesłał a Ty je zweryfikowałeś, scalasz je z gałęzią `master`, usuwasz gałąź i kontynuujesz pracę. Jeżeli mielibyśmy repozytorium ze zmianami w dwóch gałęziach `ruby_client` oraz `php_client` (zob. rys. 5-19) i mielibyśmy scalić najpierw `ruby_client`, a w następnej kolejności `php_client`, to twoja historia zmian wyglądała by podobnie do rys. 5-20.

<!-- One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20. -->

Insert 18333fig0519.png
Rysunek 5-19. Historia zmian z kilkoma gałęziami tematycznymi.

<!-- Figure 5-19. History with several topic branches. -->

Insert 18333fig0520.png
Rysunek 5-20. Po scaleniu gałęzi.

<!-- Figure 5-20. After a topic branch merge. -->

To jest prawdopodobnie najprostszy schemat pracy, ale jest on również problematyczny jeżeli masz do czynienia z dużymi repozytoriami lub projektami.

<!-- That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects. -->

Jeżeli masz większą ilość deweloperów lub większy projekt, będziesz chciał pewnie używał przynajmniej dwufazowego cyklu scalania. W tym scenariuszu, posiadasz dwie długodystansowe gałęzie `master` oraz `develop`, z których `master` jest aktualizowana tylko z bardzo stabilnymi zmianami, a cały nowy kod jest włączany do gałęzi `develop`. Regularnie wysyłasz ("push") obie te gałęzie do publicznego repozytorium. Za każdym razem gdy masz nową gałąź tematyczną do zintegrowania (rys. 5-21), włączasz ją do `develop` (rys. 5-22); a kiedy tagujesz kolejną wersję, przesuwasz `master` za pomocą fast-forward o punktu w którym jest gałąź `develop`(rys. 5-23).

<!-- If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23). -->

Insert 18333fig0521.png
Rysunek 5-21. Przed scaleniem gałęzi tematycznej.

<!-- Figure 5-21. Before a topic branch merge. -->

Insert 18333fig0522.png
Rysunek 5-22. Po scaleniu gałęzi tematycznej.

<!-- Figure 5-22. After a topic branch merge. -->

Insert 18333fig0523.png
Rysunek 5-23. Po utworzeniu kolejnej wersji.

<!-- Figure 5-23. After a topic branch release. -->

W ten sposób, kiedy ludzie klonują Twoje repozytorium, mogą albo pobrać `master` aby zbudować najnowszą stabilną wersję i utrzymywać ją uaktualnioną, lub mogą pobrać `develop` która zawiera mniej stabilne zmiany.
Możesz rozbudować tą koncepcję, poprzez dodanie gałęzi służącej do integracji. Wtedy jeżeli kod w znajdujący się w niej jest stabilny i przechodzi wszystkie testy, scalasz ją do gałęzi `develop`; a jeżeli ta okaże się również stabilna, przesuwasz `master` za pomocą fast-forward.

<!-- This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.
You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch. -->

#### Large-Merging Workflows ####

Projekt Gita ma cztery długodystansowe gałęzie: `master`, `next`, `pu` (proponowane zmiany) dla nowych funkcjonalności, oraz `maint` do wprowadzania zmian wstecznych. Kiedy nowe zmiany są dostarczone przez deweloperów, zbierane są do gałęzi tematycznych w repozytorium opiekuna, w sposób podobny do tego który opisałem (zob. rys. 5-24). W tym momencie, są one weryfikowane i sprawdzane czy mogą być użyte, lub czy nadal wymagają dalszych prac. Jeżeli są gotowe, są włączona do `next`, a ta gałąź jest wypychana dalej, tak aby każdy mógł wypróbować nowe funkcjonalności.

<!-- The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together. -->

Insert 18333fig0524.png
Rysunek 5-24. Zarządzanie złożoną serią równoczesnych zmian w gałęziach tematycznych.

<!-- Figure 5-24. Managing a complex series of parallel contributed topic branches. -->

Jeżeli funkcjonalność potrzebuje jeszcze kolejnych zmian, są one włączane do gałęzi `pu`. Kiedy okaże się, że cały kod działa już poprawnie, zmiany są włączane do `master` oraz przebudowywane włącznie ze zmianami z gałęzi `next`, które nie znalazły się jeszcze w `master`. Oznacza to, że `master` praktycznie zawsze przesuwa się do przodu, `next` tylko czasami ma zmienianą bazę poprzez "rebase", a `pu` najczęściej z nich może się przesunąć w innym kierunku (zob. rys. 5-25).

<!-- If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25). -->

Insert 18333fig0525.png
Rysunek 5-25. Włączanie gałęzi tematycznych do gałęzi długodystansowych.

<!-- Figure 5-25. Merging contributed topic branches into long-term integration branches. -->

Z chwilą, gdy gałąź tematycznie zostanie włączona do `master`, jest usuwana z repozytorium. Projekt Gita ma również gałąź `maint`, która jest tworzona z ostatniej wersji, w celu dostarczania zmian w sytuacji gdy trzeba wydać wersję poprawkową. Dlatego kopiując repozytorium Gita masz cztery gałęzie, w których możesz zobaczyć projekt w różnych stadiach rozwoju, w zależności od tego jak stabilny kod chcesz używać, lub nad którym pracować; a opiekun ma ułatwiony przepływ zmian pomagający panować nad nowymi zmianami.

<!-- When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions. -->

#### Zmiana bazy oraz wybiórcze pobieranie zmian ####

Część opiekunów woli używać "rebase" lub "cherry-pick" w celu włączania zmian w gałęzi master, zamiast przy użyciu "merge", aby zachować bardziej liniową historię. Kiedy masz zmiany w gałęzi tematycznej i decydujesz się zintegrować je, przenosisz gałąź i uruchamiasz "rebase" aby nałożyć zmiany na górze swojej gałęzi master (lub `develop`, czy innej). Jeżeli to zadziała poprawnie, możesz przesunąć swoją gałąź `master` i otrzymasz praktycznie liniową historię.

<!-- Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history. -->

Drugim sposobem na przeniesienie zmian z jednej gałęzi do drugiej jest zrobienie tego za pomocą komendy `cherry-pick`. Komenda ta jest podobna do `rebase`, ale dla pojedynczej zmiany. Pobiera ona zmianę która została wprowadzona i próbuje ją ponownie nałożyć na gałąź na której obecnie pracujesz. Jest to całkiem przydatne, w sytuacji gdy masz większą ilość zmian w gałęzi tematycznej, a chcesz zintegrować tylko jedną z nich, lub jeżeli masz tylko jedną zmianę w gałęzi i wolisz używać cherry-pick zamiast rebase. Dla przykładu, załóżmy że masz projekt który wygląda podobnie do rys. 5-26.

<!-- The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26. -->

Insert 18333fig0526.png
Rysunek 5-26. Przykładowa historia przez wybiórczym zaciąganiem zmian.

<!-- Figure 5-26. Example history before a cherry pick. -->

Jeżeli chcesz pobrać zmianę `e43a6` do swojej gałęzi master, możesz uruchomić:

<!-- If you want to pull commit `e43a6` into your master branch, you can run -->

    $ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
    Finished one cherry-pick.
    [master]: created a0a41a9: "More friendly message when locking the index fails."
     3 files changed, 17 insertions(+), 3 deletions(-)

To pobierze tylko zmiany z commita `e43a6`, ale otrzyma nową sumę SHA-1, ze względu na nową datę nałożenia. Teraz Twoja historia wygląda podobnie do rysunku 5-27.

<!--  This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27. -->

Insert 18333fig0527.png
Rysunek 5-27. Historia po wybiórczym zaciągnięciu zmiany z gałęzi tematycznej.

<!-- Figure 5-27. History after cherry-picking a commit on a topic branch. -->

Teraz możesz usunąć swoją gałąź tematyczną, oraz zmiany których nie chciałeś pobierać.

<!-- Now you can remove your topic branch and drop the commits you didn’t want to pull in. -->

### Tagowanie Twoich Wersji ###

Kiedy zdecydowałeś, że wydasz nową wersję, najprawdopodobniej będziesz chciał stworzyć taga, tak abyś mógł odtworzyć tą wersję w każdym momencie. Możesz stworzyć nowego taga, tak jak zostało to opisane w rozdziale 2. Jeżeli zdecydujesz się na utworzenie taga jako opiekun, komenda powinna wyglądać podobnie do:

<!-- When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this: -->

    $ git tag -s v1.5 -m 'my signed 1.5 tag'
    You need a passphrase to unlock the secret key for
    user: "Scott Chacon <schacon@gmail.com>"
    1024-bit DSA key, ID F721C45A, created 2009-02-09

Jeżeli podpisujesz swoje tagi, możesz mieć problem z dystrybucją swojego publicznego klucza PGP, który został użyty. Można rozwiązać ten problem poprzez dodanie obiektu binarnego (ang. blob) w repozytorium, a następnie stworzenie taga kierującego dokładnie na jego zawartość. Aby to zrobić, musisz wybrać klucz za pomocą komendy `gpg --list-keys`:

<!-- If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg -\-list-keys`: -->

    $ gpg --list-keys
    /Users/schacon/.gnupg/pubring.gpg
    ---------------------------------
    pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
    uid                  Scott Chacon <schacon@gmail.com>
    sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]


Następnie, możesz bezpośrednio zaimportować wybrany klucz do Gita, poprzez eksport i przekazanie go do `git hash-object`, który zapisuje nowy obiekt binarny i zwraca jego sumę SHA-1:

<!-- Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob: -->

    $ gpg -a --export F721C45A | git hash-object -w --stdin
    659ef797d181633c87ec71ac3f9ba29fe5775b92

Teraz, gdy masz zawartość swojego klucza w Gitcie, możesz utworzyć taga wskazującego bezpośrednio na ten klucz, poprzez podanie sumy SHA-1 zwróconej przez `hash-object`:

<!-- Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you: -->

    $ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Po uruchomieniu `git push --tags`, etykieta `maintainer-pgp-pub` zostanie udostępniona dla wszystkich. Jeżeli ktoś chciałby zweryfikować etykietę, może bezpośrednio zaimportować twój klucz PGP poprzez pobranie zawartości z gita i import do GPG:

<!-- If you run `git push -\-tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG: -->

    $ git show maintainer-pgp-pub | gpg --import

Możesz używać tego klucza do weryfikacji wszystkich podpisanych etykiet. Możesz również dodać do komentarza do etykiety dodatkowe informacje, które będą możliwe do odczytania po uruchomieniu `git show <tag>` i pozwolą na prostszą weryfikację.

<!-- They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification. -->

### Generowanie numeru kompilacji ###

<!-- ### Generating a Build Number ### -->

Ponieważ Git nie zwiększa stale numerów, np. 'v123' lub w podobny sposób, jeżeli chcesz mieć łatwiejszą do używania nazwę dla konkretnej zmiany, możesz uruchomić `git describe` na commitcie. Git poda Ci nazwę najbliższej etykiety, wraz z ilością zmian, oraz skróconą sumą SHA-1:

<!-- Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing: -->

    $ git describe master
    v1.6.2-rc1-20-g8c5b85c

W ten sposób, możesz udostępnić konkretną wersję lub kompilację pod nazwą łatwiejszą do użycia przez ludzi. W rzeczywistości, jeżeli masz Gita zbudowanego ze źródeł pobranych z jego repozytorium, komenda `git --version` pokaże wynik podobny do powyższego. Jeżeli zamierzasz opisać zmianę którą bezpośrednio zatagowałeś, pokaże ona nazwę taga.

<!-- This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git -\-version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name. -->

Komenda `git describe` faworyzuje etykiety stworzone przy użyciu opcji `-a` lub `-s`, więc etykiety dotyczące konkretnych wersji powinny być tworzone w ten sposób, jeżeli używasz `git describe` w celu zapewnienia poprawnych nazw commitów. Możesz również używać tej nazwy do komend "checkout" lub "show", choć polegają one na skróconej wartości SHA-1, mogą więc nie być wiecznie poprawne. Na przykład, projekt jądra Linuksa przeszedł ostatnio z 8 na 10 znaków aby zapewnić unikalność sum SHA-1, więc poprzednie nazwy wygenerowane za pomocą `git describe` zostały unieważnione.

<!-- The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated. -->

### Przygotowywanie nowej wersji ###

<!--### Preparing a Release ### -->

Teraz chcesz stworzyć nową wersję. Jedną z rzeczy które będziesz musiał zrobić, jest przygotowanie spakowanego archiwum z ostatnią zawartością kodu, dla tych, którzy nie używają Gita. Komenda która to umożliwia to `git archive`:

<!-- Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`: -->

    $ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
    $ ls *.tar.gz
    v1.6.2-rc1-20-g8c5b85c.tar.gz

Jeżeli ktoś otworzy spakowany plik, otrzyma ostatnią wersję kodu w podkatalogu z nazwą projektu. Możesz również stworzyć archiwum zip w podobny sposób, dodając parametr `--format=zip` do `git archive`:

<!-- If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `-\-format=zip` option to `git archive`: -->

    $ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Masz teraz spakowane pliki projektu w formatach tar i zip, które możesz łatwo wgrać na serwer lub wysłać do ludzi.

<!-- You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people. -->

### Komenda Shortlog ###

Nadszedł czas aby wysłać na listę dyskusyjną

<!-- It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1: -->

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

Możesz pobrać podsumowanie wszystkich zmian począwszy od wersji v1.0.1 pogrupowanych po autorze, które jest gotowe do wysłania na listę.

<!-- You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list. -->

## Podsumowanie ##

Powinieneś się teraz czuć całkiem swobodnie uczestnicząc w projekcie używając Gita, zarówno jako opiekun własnego projektu jak również, integrator zmian dostarczonych przez innych użytkowników. Gratulacje! Właśnie stałeś się skutecznym deweloperem używającym Gita! W kolejnym rozdziale, nauczysz się bardziej zaawansowanych narzędzi oraz rozwiązywania złożonych sytuacji, które uczynią z Ciebie prawdziwego mistrza.

<!-- You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master. -->
