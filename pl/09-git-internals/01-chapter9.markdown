# Mechanizmy wewnętrzne w Git #

<!-- # Git Internals # -->

Być może przeskoczyłeś do tego rozdziału z poprzedniego, lub dotarłeś aż dotąd po przeczytaniu reszty książki - w każdym z tych przypadków, dowiesz się tutaj o tym w jaki sposób pracują wewnętrzne mechanizmy i ich implementacja w Git. Wiem, jak ważne jest poznanie tych rzeczy, aby zrozumieć jak przydatnym i potężnym narzędziem jest Git, jednak niektóre osoby wskazywały że może to wprowadzać zamieszanie i niepotrzebnie komplikować sprawy dla początkujących użytkowników. Dlatego zawarłem te informacje w ostatnim rozdziale w książce, tak abyś mógł go przeczytać w dowolnym momencie nauki. Decyzję zostawiam Tobie.

<!-- You may have skipped to this chapter from a previous chapter, or you may have gotten here after reading the rest of the book — in either case, this is where you’ll go over the inner workings and implementation of Git. I found that learning this information was fundamentally important to understanding how useful and powerful Git is, but others have argued to me that it can be confusing and unnecessarily complex for beginners. Thus, I’ve made this discussion the last chapter in the book so you could read it early or later in your learning process. I leave it up to you to decide. -->

Teraz, gdy jesteś już tutaj, rozpocznijmy. Po pierwsze, jeżeli nie jest to jeszcze jasne, podstawą Gita jest systemem plików ukierunkowanym na treść, z nałożonym interfejsem użytkownika obsługującym kontrolę wersji (VCS). Dowiesz się co to oznacza za chwilę.

<!-- Now that you’re here, let’s get started. First, if it isn’t yet clear, Git is fundamentally a content-addressable filesystem with a VCS user interface written on top of it. You’ll learn more about what this means in a bit. -->

We wczesnych fazach Gita (głównie przed wersją 1.5), interfejs użytkownika był dużo bardziej skomplikowany, ponieważ kładł nacisk na sam system plików, a nie funkcjonalności VCS. W ciągu ostatnich kilku lat, interfejs został dopracowany i jest teraz tak łatwy jak inne; jednak często pokutuje stereotyp na temat pierwszych wersji UI, które były skomplikowane i trudne do nauczenia.

<!-- In the early days of Git (mostly pre 1.5), the user interface was much more complex because it emphasized this filesystem rather than a polished VCS. In the last few years, the UI has been refined until it’s as clean and easy to use as any system out there; but often, the stereotype lingers about the early Git UI that was complex and difficult to learn. -->

Warstwa systemu plików jest zadziwiająco fajna, dlatego właśnie ją opiszę w tym rozdziale; następnie, nauczysz się na temat protokołów transportowych oraz zadań związanych z obsługą repozytorium z którymi być może będziesz miał do czynienia.

<!-- The content-addressable filesystem layer is amazingly cool, so I’ll cover that first in this chapter; then, you’ll learn about the transport mechanisms and the repository maintenance tasks that you may eventually have to deal with. -->

## Komendy Plumbing i Porcelain ##

<!-- ## Plumbing and Porcelain ## -->

Ta książka opisuje jak używać Gita przy użyciu około 30 komend, takich jak `checkout`, `branch`, `remote` itd. Ale ponieważ Git był początkowo tylko zestawem narzędzi do obsługi VCS, a nie pełnoprawnym systemem VCS, ma garść komend które wykonują niskopoziomowe czynności i zostały zaprojektowane do łączenia ich w łańcuchy komend w stylu UNIX lub wywoływania z skryptów. Te komendy generalnie nazywane są komendami "plumbing", a te bardziej przyjazne dla użytkownika to komendy "porcelain".

<!-- This book covers how to use Git with 30 or so verbs such as `checkout`, `branch`, `remote`, and so on. But because Git was initially a toolkit for a VCS rather than a full user-friendly VCS, it has a bunch of verbs that do low-level work and were designed to be chained together UNIX style or called from scripts. These commands are generally referred to as "plumbing" commands, and the more user-friendly commands are called "porcelain" commands. -->

Pierwsze osiem rozdziałów książki opisywało praktycznie wyłącznie komendy "porcelain". Ale w tym rozdziale, będziesz używał głównie komend niskopoziomowych "plumbing", ponieważ daje one dostęp do wewnętrznych mechanizmów Gita i pomagają pokazać jak i dlaczego Git robi to co robi. Te komendy nie zostały stworzone do ręcznego uruchamiania z linii komend, ale raczej aby mogły być użyte do budowania nowych narzędzi lub niestandardowych skryptów.

<!-- The book’s first eight chapters deal almost exclusively with porcelain commands. But in this chapter, you’ll be dealing mostly with the lower-level plumbing commands, because they give you access to the inner workings of Git and help demonstrate how and why Git does what it does. These commands aren’t meant to be used manually on the command line, but rather to be used as building blocks for new tools and custom scripts. -->

Kiedy uruchomisz `git init` w nowym lub istniejącym katalogu, Git stworzy katalog `.git`, w którym praktycznie wszystko czego używa Git jest umieszczone. Kiedy chcesz wykonać kopię zapasową lub sklonować repozytorium, skopiowanie tylko tego katalogu da Ci praktycznie wszystko czego potrzebujesz. Praktycznie cały ten rozdział dotyczy rzeczy które są umieszczone w tym katalogu. Wygląda on tak:

<!-- When you run `git init` in a new or existing directory, Git creates the `.git` directory, which is where almost everything that Git stores and manipulates is located. If you want to back up or clone your repository, copying this single directory elsewhere gives you nearly everything you need. This entire chapter basically deals with the stuff in this directory. Here’s what it looks like: -->

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

Możesz zobaczyć tam inne pliki, ale jest to nowy katalog zainicjowany przez `git init` - standardowo właśnie to widzisz. Katalog `branches` nie jest używany przez nowsze wersje Gita, a plik `description` jest używany tylko przez program GitWeb, więc nie zwracaj na nie uwagi na razie. Plik `config` zawiera ustawienia konfiguracyjne dotyczące danego projektu, a katalog `info` przechowuje globalny plik wykluczeń, który przechowuje ignorowane wzorce których nie chcesz mieć w pliku .gitignore. Katalog `hooks` zawiera komendy uruchamiane po stronie klienta lub serwera, które były omawiane w rozdziale 7.

<!-- You may see some other files in there, but this is a fresh `git init` repository — it’s what you see by default. The `branches` directory isn’t used by newer Git versions, and the `description` file is only used by the GitWeb program, so don’t worry about those. The `config` file contains your project-specific configuration options, and the `info` directory keeps a global exclude file for ignored patterns that you don’t want to track in a .gitignore file. The `hooks` directory contains your client- or server-side hook scripts, which are discussed in detail in Chapter 7. -->

Pozostały bardzo istotne wpisy: pliki `HEAD` i `index`, oraz katalogi `objects` i `refs`. Są one podstawowymi częściami Gita. Katalog `objects` przechowuje całą zawartość bazy danych, katalog `refs` przechowuje wskaźniki do obiektów commitów w danych (branches), plik `HEAD` wskazuje gałąź na której się znajdujesz, a plik `index` jest miejscem w którym przechowywane są informacje na temat przechowalni. W kolejnych częściach tego rozdziału dokładnie zobaczysz jak Git funkcjonuje.

<!-- This leaves four important entries: the `HEAD` and `index` files and the `objects` and `refs` directories. These are the core parts of Git. The `objects` directory stores all the content for your database, the `refs` directory stores pointers into commit objects in that data (branches), the `HEAD` file points to the branch you currently have checked out, and the `index` file is where Git stores your staging area information. You’ll now look at each of these sections in detail to see how Git operates. -->


## Obiekty Gita ##

<!-- ## Git Objects ## -->

Git to tak naprawdę system plików zorientowany na treść. Super. Ale co to oznacza?
Oznacza to, że Git u podstaw, to baza danych w której znajdują się dane i przypisane do nich klucze (ang. key-value datastore). Możesz zapisać w niej każdy rodzaj danych, a w odpowiedzi otrzymasz klucz, dzięki któremu będziesz mógł dostać się do tych danych w każdej chwili. Aby zademonstrować jak to działa, możesz użyć komendy `hash-object`, która pobiera jakieś dane, zapisuje je w katalogu `.git` i zwraca klucz pod którym te dane zostały zapisane. Najpierw zainicjujesz nowe repozytorium Gita i sprawdzisz, że katalog `objects` jest pusty:

<!-- Git is a content-addressable filesystem. Great. What does that mean?
It means that at the core of Git is a simple key-value data store. You can insert any kind of content into it, and it will give you back a key that you can use to retrieve the content again at any time. To demonstrate, you can use the plumbing command `hash-object`, which takes some data, stores it in your `.git` directory, and gives you back the key the data is stored as. First, you initialize a new Git repository and verify that there is nothing in the `objects` directory: -->

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

Git zainicjował katalog `objects` oraz stworzył w nim dwa katalogi `pack` i `info`, jednak nie ma w nich żadnych plików. Teraz zapisz jakieś dane w bazie danych Gita:

<!-- Git has initialized the `objects` directory and created `pack` and `info` subdirectories in it, but there are no regular files. Now, store some text in your Git database: -->

    $ echo 'test content' | git hash-object -w --stdin
    d670460b4b4aece5915caf5c68d12f560a9fe3e4

Opcja `-w` wskazuje komendzie `hash-object` aby zapisała obiekt, w przeciwnym wypadku pokazała by tylko jaki klucz byłby użyty. Opcja `--stdin` wskazuje, aby dane zostały odczytane ze standardowego wejścia; jeżeli nie podasz tej opcji, `hash-object` będzie wymagał podania ścieżki do pliku. Wynikiem działania tej komendy jest 40 znakowa suma kontrolna. Jest to skrót SHA-1 - suma kontrolna zawartości którą zapisujesz, oraz nagłówków, o których dowiesz się za chwilę. Teraz możesz zobaczyć w jaki sposób Git zachował dane:

<!-- The `-w` tells `hash-object` to store the object; otherwise, the command simply tells you what the key would be. `-\-stdin` tells the command to read the content from stdin; if you don’t specify this, `hash-object` expects the path to a file. The output from the command is a 40-character checksum hash. This is the SHA-1 hash — a checksum of the content you’re storing plus a header, which you’ll learn about in a bit. Now you can see how Git has stored your data: -->

    $ find .git/objects -type f
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Możesz zobaczyć nowy plik w katalogu `objects`. W ten sposób Git początkowo zapisuje dane - jako pojedynczy plik dla każdej części danych, nazwany tak jak wyliczony skrót SHA-1 z treści danych i nagłówka. Podkatalog jest nazwany od 2 pierwszych znaków SHA, a nazwa pliku to pozostałe 38 znaków.

<!-- You can see a file in the `objects` directory. This is how Git stores the content initially — as a single file per piece of content, named with the SHA-1 checksum of the content and its header. The subdirectory is named with the first 2 characters of the SHA, and the filename is the remaining 38 characters. -->

Możesz pobrać dane z Gita za pomocą komendy `cat-file`. Polecenie to, to coś w rodzaju szwajcarskiego scyzoryka dla inspekcji obiektów Gita. Przekazanie opcji `-p` mówi `cat-file`, aby rozpoznała ona rodzaj przechowywanych danych i wypisała je na ekran:

<!-- You can pull the content back out of Git with the `cat-file` command. This command is sort of a Swiss army knife for inspecting Git objects. Passing `-p` to it instructs the `cat-file` command to figure out the type of content and display it nicely for you: -->

    $ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
    test content

Teraz, możesz dodać dane do Gita i pobrać je z powrotem. Możesz również to zrobić z danymi znajdującymi się w plikach. Dla przykładu, dodajmy plik do systemu kontroli wersji. Najpierw stwórzmy nowy plik i zapiszmy jego zawartość w bazie danych:

<!-- Now, you can add content to Git and pull it back out again. You can also do this with content in files. For example, you can do some simple version control on a file. First, create a new file and save its contents in your database: -->

    $ echo 'version 1' > test.txt
    $ git hash-object -w test.txt
    83baae61804e65cc73a7201a7252750c76066a30

Następnie wprowadź nowe dane do tego pliku i zapisz ponownie:

<!-- Then, write some new content to the file, and save it again: -->

    $ echo 'version 2' > test.txt
    $ git hash-object -w test.txt
    1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Twoja baza danych zawiera teraz dwie nowe wersje pliku, jak również początkową jego zawartość którą zapisałeś:

<!-- Your database contains the two new versions of the file as well as the first content you stored there: -->

    $ find .git/objects -type f
    .git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
    .git/objects/83/baae61804e65cc73a7201a7252750c76066a30
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Teraz możesz cofnąć zawartość pliku do pierwszej wersji:

<!-- Now you can revert the file back to the first version -->

    $ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt
    $ cat test.txt
    version 1

lub drugiej:

<!-- or the second version: -->

    $ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt
    $ cat test.txt
    version 2

Ale zapamiętywanie kluczy SHA-1 dla każdej wersji nie jest praktyczne; dodatkowo nie zachowujesz nazwy pliku - tylko treść. Ten rodzaj obiektu nazywa się "blob". Możesz uzyskać informacje o tym jaki typ obiektu kryje się pod danym skrótem SHA-1 za pomocą `cat-file -t`:

<!-- But remembering the SHA-1 key for each version of your file isn’t practical; plus, you aren’t storing the filename in your system — just the content. This object type is called a blob. You can have Git tell you the object type of any object in Git, given its SHA-1 key, with `cat-file -t`: -->

    $ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
    blob

### Obiekty drzew ###

<!-- ### Tree Objects ### -->

Następnym typem obiektów który poznasz są obiekty drzew (ang. tree), które rozwiązują problem przechowywania nazw plików oraz pozwalają na przechowywanie grupy plików razem. Git przechowuje treść w sposób podobny do systemu plików UNIX, lecz z pewnymi uproszczeniami. Wszystkie dane przechowywane są jako obiekty tree i blob, obiektami tree odpowiadającymi strukturze katalogów w systemie UNIX, oraz obiektami blob, które w mniejszym lub większym stopniu odpowiadają inodom lub treści plików. Pojedynczy obiekt tree zawiera jeden lub więcej wpisów dotyczących ścieżki, z których każdy zawiera skrót SHA-1 wskazujący na obiekt blob lub poddrzewem (ang. subtree) z przypisanym trybem, typem i nazwą pliku. Na przykład, najnowsze drzewo w projekcie simplegit może wygląda tak:

<!-- The next type you’ll look at is the tree object, which solves the problem of storing the filename and also allows you to store a group of files together. Git stores content in a manner similar to a UNIX filesystem, but a bit simplified. All the content is stored as tree and blob objects, with trees corresponding to UNIX directory entries and blobs corresponding more or less to inodes or file contents. A single tree object contains one or more tree entries, each of which contains a SHA-1 pointer to a blob or subtree with its associated mode, type, and filename. For example, the most recent tree in the simplegit project may look something like this: -->

    $ git cat-file -p master^{tree}
    100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
    100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
    040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

Składnia `master^{tree}` wskazuje na obiekt tree na który wskazuje ostatni commit w Twojej gałęzi `master`. Zauważ, że podkatalog `lib` nie jest blobem, ale wskaźnikiem na inny obiekt tree.

<!-- The `master^{tree}` syntax specifies the tree object that is pointed to by the last commit on your `master` branch. Notice that the `lib` subdirectory isn’t a blob but a pointer to another tree: -->

    $ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
    100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

W ogólnym zarysie, dane które Git przechowuje wyglądają podobnie do tych pokazanych na rysunku 9-1.

<!-- Conceptually, the data that Git is storing is something like Figure 9-1. -->

Insert 18333fig0901.png
Rysunek 9-1. Prosty przykład modelu danych w Git.

<!-- Figure 9-1. Simple version of the Git data model. -->

Możesz stworzyć swój własny obiekt tree. Git zazwyczaj tworzy taki obiekt poprzez pobranie stanu przechowalni lub indeksu i zapisanie obiektu tree z tych danych. A więc, aby stworzyć obiekt tree, na początek musisz ustawić indeks poprzez dodanie do przechowalni plików. Indeks z jednym elementem - z pierwszą wersją Twojego pliku test.txt - możesz stworzyć używając komendy `update-index`. Możesz jej również do sztucznego dodania poprzedniej wersji pliku test.txt do przechowalni. Musisz podać jej opcje `--add` ponieważ plik nie istnieje jeszcze w przechowalni (nie masz jeszcze nawet ustawionej przechowalni) oraz `--cacheinfo` ponieważ plik który dodajesz nie istnieje w katalogu, a tylko w bazie danych. Następnie wskazujesz tryb, sumę SHA-1 oraz nazwę pliku:

<!-- You can create your own tree. Git normally creates a tree by taking the state of your staging area or index and writing a tree object from it. So, to create a tree object, you first have to set up an index by staging some files. To create an index with a single entry — the first version of your test.txt file — you can use the plumbing command `update-index`. You use this command to artificially add the earlier version of the test.txt file to a new staging area. You must pass it the `-\-add` option because the file doesn’t yet exist in your staging area (you don’t even have a staging area set up yet) and `-\-cacheinfo` because the file you’re adding isn’t in your directory but is in your database. Then, you specify the mode, SHA-1, and filename: -->

    $ git update-index --add --cacheinfo 100644 \
      83baae61804e65cc73a7201a7252750c76066a30 test.txt

W tym przykładzie, podałeś tryb `100644`, który wskazuje na normalny plik. Inne dostępne tryby to `100755`, który wskazuje na plik wykonywalny; oraz `120000`, który wskazuje na dowiązanie symboliczne. Tryby bazują na normalnych uprawnieniach w systemie UNIX, ale mają znacznie mniej opcji - te trzy tryby są jedynymi, które mogą być stosowane do plików (blob-ów) w Gitcie (chociaż inne tryby mogą być użyte dla katalogów i podmodułów).

<!-- In this case, you’re specifying a mode of `100644`, which means it’s a normal file. Other options are `100755`, which means it’s an executable file; and `120000`, which specifies a symbolic link. The mode is taken from normal UNIX modes but is much less flexible — these three modes are the only ones that are valid for files (blobs) in Git (although other modes are used for directories and submodules). -->

Teraz, możesz użyć komendy `write-tree`, w celu zapisania zawartości przechowani do obiektu tree. Opcja `-w` nie jest potrzebna - wywołanie `write-tree` automatycznie tworzy obiekt tree ze stanu indeksu, jeżeli ten obiekt jeszcze nie istnieje.

<!-- Now, you can use the `write-tree` command to write the staging area out to a tree object. No `-w` option is needed — calling `write-tree` automatically creates a tree object from the state of the index if that tree doesn’t yet exist: -->

    $ git write-tree
    d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    $ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Możesz również zweryfikować, że to jest obiekt tree:

<!-- You can also verify that this is a tree object: -->

    $ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    tree

Stworzysz teraz nowy obiekt tree, zawierający drugą wersję pliku test.txt oraz nowy plik:

<!-- You’ll now create a new tree with the second version of test.txt and a new file as well: -->

    $ echo 'new file' > new.txt
    $ git update-index test.txt
    $ git update-index --add new.txt


W Twojej przechowalni znajduje się teraz nowa wersja pliku test.txt oraz nowy plik new.txt. Zapisz ten stan (pobierając stan z przechowalni lub indeksu do obiektu tree) i sprawdź jak on teraz wygląda:

<!-- Your staging area now has the new version of test.txt as well as the new file new.txt. Write out that tree (recording the state of the staging area or index to a tree object) and see what it looks like: -->

    $ git write-tree
    0155eb4229851634a0f03eb265b69f5a2d56f341
    $ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
    100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Zauważ, że to drzewo posiada oba wpisy dotyczące plików, oraz że suma SHA w pliku test.txt jest sumą przypisaną do "wersji 2" (`1f7a7a`). Dla zabawy, dodasz pierwszy obiekt tree jako podkatalog w obecnym. Możesz wczytać obiekt tree do swojej przechowalni poprzez wywołanie `read-tree`. W takim wypadku, możesz wczytać obecne drzewo do swojej przechowalni i umieścić je w podkatalogu za pomocą opcji `--prefix` dodanej do `read-tree`:

<!-- Notice that this tree has both file entries and also that the test.txt SHA is the "version 2" SHA from earlier (`1f7a7a`). Just for fun, you’ll add the first tree as a subdirectory into this one. You can read trees into your staging area by calling `read-tree`. In this case, you can read an existing tree into your staging area as a subtree by using the `-\-prefix` option to `read-tree`: -->

    $ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    $ git write-tree
    3c4e9cd789d88d8d89c1073707c3585e41b0e614
    $ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
    040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
    100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Jeżeli odtworzyłeś katalog roboczy z drzewa które właśnie zapisałeś, otrzymałeś dwa pliki na najwyższym poziomie w tym katalogu, oraz podkatalog `bak`, który zawiera pierwszą wersję pliku test.txt. Możesz myśleć o danych przechowywanych w Gitcie z tymi strukturami, tak jak przedstawiono na rysunku 9-2.

<!-- If you created a working directory from the new tree you just wrote, you would get the two files in the top level of the working directory and a subdirectory named `bak` that contained the first version of the test.txt file. You can think of the data that Git contains for these structures as being like Figure 9-2. -->

Insert 18333fig0902.png
Rysunek 9-2. Zawartość struktury obecnych danych Git.

<!-- Figure 9-2. The content structure of your current Git data. -->

### Obiekty Commit ###

<!-- ### Commit Objects ### -->

Masz teraz trzy obiekty tree, które wskazują na różne migawki śledzonego projektu, ale poprzedni problem pozostał: musisz pamiętasz wszystkie trzy wartości SHA-1 aby przywrócić migawkę. Nie masz również żadnych informacji o tym kto zapisał migawkę, kiedy była zapisana, ani dlaczego. To są podstawowe informacje, które przechowywane są w obiektach typu commit.

<!-- You have three trees that specify the different snapshots of your project that you want to track, but the earlier problem remains: you must remember all three SHA-1 values in order to recall the snapshots. You also don’t have any information about who saved the snapshots, when they were saved, or why they were saved. This is the basic information that the commit object stores for you. -->

Aby stworzyć obiekt commit, wywołaj `commit-tree` i podaj jedną sumę SHA-1 wskazującą na obiekt tree oraz obiekty commit, o ile były jakieś, które bezpośrednio go poprzedziły.

<!-- To create a commit object, you call `commit-tree` and specify a single tree SHA-1 and which commit objects, if any, directly preceded it. Start with the first tree you wrote: -->

    $ echo 'first commit' | git commit-tree d8329f
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Możesz teraz zobaczyć jak wygląda nowy obiekt commit za pomocą `cat-file`:

<!-- Now you can look at your new commit object with `cat-file`: -->

    $ git cat-file -p fdf4fc3
    tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
    author Scott Chacon <schacon@gmail.com> 1243040974 -0700
    committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

    first commit

Format obiektu commit jest prosty: wskazuje on najnowszy obiekt tree dla migawki projektu w momencie tworzenia; informacje o autorze/integratorze zmiany pobrane z są ustawień konfiguracyjnych `user.name` i `user.email` wraz z obecnym znacznikiem czasu; pustą linię i potem treść komentarza do zmiany.

<!-- The format for a commit object is simple: it specifies the top-level tree for the snapshot of the project at that point; the author/committer information pulled from your `user.name` and `user.email` configuration settings, with the current timestamp; a blank line, and then the commit message. -->

Następnie, zapiszesz dwa inne obiekty commit, z których każdy odwołuje się do commit-a który był bezpośrednio przed nim:

<!-- Next, you’ll write the other two commit objects, each referencing the commit that came directly before it: -->

    $ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
    cac0cab538b970a37ea1e769cbbde608743bc96d
    $ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
    1a410efbd13591db07496601ebc7a059dd55cfe9

Każdy z trzech obiektów commit wskazuje na jedną z trzech migawek które stworzyłeś. Co ciekawe, masz teraz prawdziwą historię w Git, którą możesz obejrzeć za pomocą komendy `git log`, jeżeli uruchomisz ją na ostatniej sumą SHA-1 obiektu commit:

<!-- Each of the three commit objects points to one of the three snapshot trees you created. Oddly enough, you have a real Git history now that you can view with the `git log` command, if you run it on the last commit SHA-1: -->

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

Niesamowite. Wykonałeś właśnie niskopoziomowe operacje i stworzyłeś historię w Git bez używania żadnej z komend użytkownika. Jest to w zasadzie to, co Git robi kiedy uruchomisz komendy `git add` oraz `git commit` - zapisuje obiekty blob dla plików które zmieniłeś, aktualizuje indeks, zapisuje obiekt tree, oraz tworzy obiekt commit odnoszący się do obiektu tree oraz obiektów commit które wystąpiły bezpośrednio przed nim. Te trzy główne obiekty Gita - blob, tree oraz commit - są na początku zapisywane jako pojedyncze pliki w katalogu `.git/objects`. Poniżej widać wszystkie obiekty z naszego przykładu, z komentarzami wskazującymi na to co było w nich zapisane:

<!-- Amazing. You’ve just done the low-level operations to build up a Git history without using any of the front ends. This is essentially what Git does when you run the `git add` and `git commit` commands — it stores blobs for the files that have changed, updates the index, writes out trees, and writes commit objects that reference the top-level trees and the commits that came immediately before them. These three main Git objects — the blob, the tree, and the commit — are initially stored as separate files in your `.git/objects` directory. Here are all the objects in the example directory now, commented with what they store: -->

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

Jeżeli prześledzisz wszystkie wskaźniki, dostaniesz widok obiektów podobny do rysunku 9-3.

<!-- If you follow all the internal pointers, you get an object graph something like Figure 9-3. -->

Insert 18333fig0903.png
Rysunek 9-3. Wszystkie obiekty w Twoim repozytorium Gita.

<!-- Figure 9-3. All the objects in your Git directory. -->

### Zapisywanie obiektów ###

<!-- ### Object Storage ### -->

Wcześniej wspomniałem, że nagłówek jest zapisywanie wraz z treścią. Spójrzmy przez chwilę w jaki sposób Git zapisuje swoje obiekty. Zobaczysz jak zapisać obiekt blob - na przykładzie treści "what is up, doc?" - interaktywnie w języku skryptowym Ruby. Możesz uruchomić tryb interaktywny w Ruby, za pomocą komendy `irb`:

<!-- I mentioned earlier that a header is stored with the content. Let’s take a minute to look at how Git stores its objects. You’ll see how to store a blob object — in this case, the string "what is up, doc?" — interactively in the Ruby scripting language. You can start up interactive Ruby mode with the `irb` command: -->

    $ irb
    >> content = "what is up, doc?"
    => "what is up, doc?"

Git tworząc nagłówek na początku wskazuje jakiego typu jest obiekt, w tym wypadku blob. Następnie, dodaje spację i wielkość treści, oraz na końcu znak null:

<!-- Git constructs a header that starts with the type of the object, in this case a blob. Then, it adds a space followed by the size of the content and finally a null byte: -->

    >> header = "blob #{content.length}\0"
    => "blob 16\000"

Git łączy nagłówek z treścią, a potem oblicza sumę SHA-1 całości. Możesz obliczyć sumę SHA-1 dla treści w Ruby, po włączeniu biblioteki "SHA1 digest" za pomocą komendy `require`, oraz po wywołaniu `Digest::SHA1.hexdigest()` na nim:

<!-- Git concatenates the header and the original content and then calculates the SHA-1 checksum of that new content. You can calculate the SHA-1 value of a string in Ruby by including the SHA1 digest library with the `require` command and then calling `Digest::SHA1.hexdigest()` with the string: -->

    >> store = header + content
    => "blob 16\000what is up, doc?"
    >> require 'digest/sha1'
    => true
    >> sha1 = Digest::SHA1.hexdigest(store)
    => "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git kompresuje nową treść za pomocą zlib, co możesz wykonać w Ruby przy użyciu biblioteki zlib. Najpierw, musisz dodać wpis `require`, a potem uruchomić na treści `Zlib::Deflate.deflate()`:

<!-- Git compresses the new content with zlib, which you can do in Ruby with the zlib library. First, you need to require the library and then run `Zlib::Deflate.deflate()` on the content: -->

    >> require 'zlib'
    => true
    >> zlib_content = Zlib::Deflate.deflate(store)
    => "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Na koniec, zapiszesz spakowaną treść jako obiektu na dysku. Ustalisz ścieżkę dla obiektu który zapisujesz (pierwsze dwa znaki z sumy SHA-1 są nazwą podkatalogu, a pozostałe 38 znaków są nazwą pliku w tym katalogu). W Ruby możesz użyć funkcji `FileUtils.mkdir_p()`, aby stworzyć podkatalog w przypadku gdy on nie istnieje. Następnie otwórz plik za pomocą `File.open()` i zapisz otrzymaną skompresowaną zawartość do pliku za pomocą funkcji `write()` wywołanej na otrzymanym uchwycie pliku:

<!-- Finally, you’ll write your zlib-deflated content to an object on disk. You’ll determine the path of the object you want to write out (the first two characters of the SHA-1 value being the subdirectory name, and the last 38 characters being the filename within that directory). In Ruby, you can use the `FileUtils.mkdir_p()` function to create the subdirectory if it doesn’t exist. Then, open the file with `File.open()` and write out the previously zlib-compressed content to the file with a `write()` call on the resulting file handle: -->

    >> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
    => ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
    >> require 'fileutils'
    => true
    >> FileUtils.mkdir_p(File.dirname(path))
    => ".git/objects/bd"
    >> File.open(path, 'w') { |f| f.write zlib_content }
    => 32

To tyle - stworzyłeś poprawny obiekt blog w Gitcie. Wszystkie obiekty w Git przechowywane są w taki sam sposób, tylko z innymi typami - zamiast ciągu znaków blob, nagłówek będzie rozpoczynał się od commit lub tree. Choć obiekt blob może zawierać praktycznie dowolne dane, to jednak obiekty commit i tree są bardzo specyficznie sformatowane.

<!-- That’s it — you’ve created a valid Git blob object. All Git objects are stored the same way, just with different types — instead of the string blob, the header will begin with commit or tree. Also, although the blob content can be nearly anything, the commit and tree content are very specifically formatted. -->

## Referencje w Git ##

<!-- ## Git References ## -->

Za pomocą komendy `git log 1a410e` możesz również przejrzeć całą historię swojego projektu, ale musisz wiedzieć, że `1a410e` jest ostatnią zmianą (commitem) aby zobaczyć wszystkie modyfikacje. Potrzebujesz pliku w którym będziesz mógł zapisywać wartość SHA-1 pod łatwiejszą nazwą, tak abyś mógł jej używać zamiast sumy SHA-1. 

<!-- You can run something like `git log 1a410e` to look through your whole history, but you still have to remember that `1a410e` is the last commit in order to walk that history to find all those objects. You need a file in which you can store the SHA-1 value under a simple name so you can use that pointer rather than the raw SHA-1 value. -->

W Gitcie nazywane są one "referencjami" lub krócej "refs"; możesz znaleźć pliki zawierające wartość SHA-1 w katalogu `.git/refs`. W obecnym projekcie ten katalog nie zawiera żadnych plików, a jego struktura wygląda tak:

<!-- In Git, these are called "references" or "refs"; you can find the files that contain the SHA-1 values in the `.git/refs` directory. In the current project, this directory contains no files, but it does contain a simple structure: -->

    $ find .git/refs
    .git/refs
    .git/refs/heads
    .git/refs/tags
    $ find .git/refs -type f
    $

Aby stworzyć nową referencję, która pomocna będzie przy zapamiętywaniu który commit jest ostatni, możesz wykonać tę prostą komendę: 

<!-- To create a new reference that will help you remember where your latest commit is, you can technically do something as simple as this: -->

    $ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Teraz, możesz używać referencji którą właśnie stworzyłeś zamiast sumy SHA-1 w komendach Gita:

<!-- Now, you can use the head reference you just created instead of the SHA-1 value in your Git commands: -->

    $ git log --pretty=oneline  master
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Nie musisz bezpośrednio zmieniać plików referencji. Git udostępnia bezpieczniejsze narzędzie do tego, gdy chcesz zaktualizować referencje wywołaj `update-ref`:

<!-- You aren’t encouraged to directly edit the reference files. Git provides a safer command to do this if you want to update a reference called `update-ref`: -->

    $ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Praktycznie tym samym są gałęzie w Git: proste wskazanie lub referencja na najnowszą wprowadzoną zmianę. Aby stworzyć gałąź z poprzedniego commita, wykonaj to:

<!-- That’s basically what a branch in Git is: a simple pointer or reference to the head of a line of work. To create a branch back at the second commit, you can do this: -->

    $ git update-ref refs/heads/test cac0ca

Twoja gałąź będzie zawierała tylko zmiany starsze niż podany commit:

<!-- Your branch will contain only work from that commit down: -->

    $ git log --pretty=oneline test
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

W tej chwili, Twoja baza w Git wygląda podobnie do tej z rysunka 9-4.

<!-- Now, your Git database conceptually looks something like Figure 9-4. -->

Insert 18333fig0904.png
Rysunek 9-4. Obiekty w katalogach Git z uwzględnieniem referencji do gałęzi.

<!-- Figure 9-4. Git directory objects with branch head references included. -->

Gdy uruchamiasz komendę taką jak `git branch (nazwagałęzi)`, Git po prostu uruchamia komendę `update-ref`, w celu dodania sumy SHA-1 ostatniego commita w gałęzi na której się obecnie znajdujesz, do referencji którą chcesz stworzyć. 

<!-- When you run commands like `git branch (branchname)`, Git basically runs that `update-ref` command to add the SHA-1 of the last commit of the branch you’re on into whatever new reference you want to create. -->

### HEAD ###

<!-- ### The HEAD ### -->

Powstaje pytanie, po uruchomieniu `git branch (nazwagałęzi)`, skąd Git wie jaka jest suma SHA-1 ostatniego commita? Odpowiedź to plik HEAD. W tym pliku znajduje się symboliczne dowiązanie do gałęzi w której się obecnie znajdujesz. Poprzez symboliczne dowiązanie, mam na myśli to, że inaczej niż w przypadku normalnego dowiązania, nie zawiera ono sumy SHA-1, ale wskaźnik na inną referencję. Jak zobaczysz na zawartość tego pliku, zazwyczaj zobaczysz coś w stylu:

<!-- The question now is, when you run `git branch (branchname)`, how does Git know the SHA-1 of the last commit? The answer is the HEAD file. The HEAD file is a symbolic reference to the branch you’re currently on. By symbolic reference, I mean that unlike a normal reference, it doesn’t generally contain a SHA-1 value but rather a pointer to another reference. If you look at the file, you’ll normally see something like this: -->

    $ cat .git/HEAD
    ref: refs/heads/master

Po uruchomieniu `git checkout test`, Git zaktualizuje ten plik, aby zawierał:

<!-- If you run `git checkout test`, Git updates the file to look like this: -->

    $ cat .git/HEAD
    ref: refs/heads/test

Gdy uruchomisz `git commit`, zostanie stworzony obiekt commit, określając rodzica tego obiektu na podstawie wartość SHA-1 na którą wskazuje HEAD.

<!-- When you run `git commit`, it creates the commit object, specifying the parent of that commit object to be whatever SHA-1 value the reference in HEAD points to. -->

Możesz również ręcznie zmodyfikować ten plik, ale bezpieczniej będzie użyć komendy `symbilic-ref`. Możesz odczytać wartość która jest w HEAD przy jej pomocy:

<!-- You can also manually edit this file, but again a safer command exists to do so: `symbolic-ref`. You can read the value of your HEAD via this command: -->

    $ git symbolic-ref HEAD
    refs/heads/master

Możesz również ustawić nową wartość HEAD:

<!-- You can also set the value of HEAD: -->

    $ git symbolic-ref HEAD refs/heads/test
    $ cat .git/HEAD
    ref: refs/heads/test

Nie możesz jednak wstawić symbolicznego dowiązania które jest poza katalogiem refs:

<!-- You can’t set a symbolic reference outside of the refs style: -->

    $ git symbolic-ref HEAD test
    fatal: Refusing to point HEAD outside of refs/

### Tagi ###

<!-- ### Tags ### -->

Poznałeś już trzy główne obiekty Gita, ale istnieje jeszcze czwarty. Obiekt tag, jest bardzo podobny do obiektu commit - zawiera informacje o osobie, dacie, treści komentarza i wskaźnik. Główną różnicą jest to, że obiekt tag wskazuje na commit, a nie na obiekt tree. Jest podobny do referencji gałęzi, ale nigdy się nie zmienia - zawsze wskazuje na ten sam commit, ale z łatwiejszą nazwą.

<!-- You’ve just gone over Git’s three main object types, but there is a fourth. The tag object is very much like a commit object — it contains a tagger, a date, a message, and a pointer. The main difference is that a tag object points to a commit rather than a tree. It’s like a branch reference, but it never moves — it always points to the same commit but gives it a friendlier name. -->

Jak opisałem w rozdziale 2, istnieją dwa typy tagów: opisanych i lekkich. Możesz stworzyć lekką etykietę poprzez uruchomienie:

<!-- As discussed in Chapter 2, there are two types of tags: annotated and lightweight. You can make a lightweight tag by running something like this: -->

    $ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Właśnie tym jest lekka etykieta - gałęzią która nigdy się nie zmienia. Opisana etykieta jest jednak bardziej skomplikowana. Gdy tworzysz opisaną etykietę, Git stworzy obiekt tag, a następnie zapisze referencję wskazująca na niego, zamiast na obiekt commit. Możesz to zauważyć, po stworzeniu opisanej etykiety (`-a` wskazuje że będzie to opisana etykieta):

<!-- That is all a lightweight tag is — a branch that never moves. An annotated tag is more complex, however. If you create an annotated tag, Git creates a tag object and then writes a reference to point to it rather than directly to the commit. You can see this by creating an annotated tag (`-a` specifies that it’s an annotated tag): -->

    $ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 -m 'test tag'

Stworzona została następująca wartość SHA-1:

<!-- Here’s the object SHA-1 value it created: -->

    $ cat .git/refs/tags/v1.1
    9585191f37f7b0fb9444f35a9bf50de191beadc2

Teraz, uruchom komendę `cat-file` na tej wartość SHA-1:

<!-- Now, run the `cat-file` command on that SHA-1 value: -->

    $ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
    object 1a410efbd13591db07496601ebc7a059dd55cfe9
    type commit
    tag v1.1
    tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

    test tag

Zauważ, że wpis rozpoczynający się od "object" wskazuje na sumą SHA-1 commitu który zatagowałeś. Zauważ również, że nie musi on wskazywać na commit; możesz stworzyć etykietę dla każdego obiektu w Git. Na przykład, w kodzie źródłowym Gita, opiekun projektu zamieścił publiczny klucz GPG, jako obiekt blob i następnie go otagował. Możesz zobaczyć zawartość tego klucz, po wykonaniu

<!-- Notice that the object entry points to the commit SHA-1 value that you tagged. Also notice that it doesn’t need to point to a commit; you can tag any Git object. In the Git source code, for example, the maintainer has added their GPG public key as a blob object and then tagged it. You can view the public key by running -->

    $ git cat-file blob junio-gpg-pub

w kodzie źródłowym Gita. Repozytorium ze źródłami projektu Linux ma również taki tag - pierwszy tag stworzony z początkowego stanu kodu źródłowego.

<!-- in the Git source code repository. The Linux kernel repository also has a non-commit-pointing tag object — the first tag created points to the initial tree of the import of the source code. -->

### Zdalne repozytoria ###

<!-- ### Remotes ### -->

Trzecim typem referencji który poznasz, są referencje zdalne. Jeżeli dodasz zdalne repozytorium i wypchniesz do niego kod, Git przechowa wartość którą ostatnio wypchnąłeś do niego, dla każdej gałęzi w katalogu `refs/remotes`. Na przykład, możesz dodać zdalne repozytorium o nazwie `origin` i wypchnąć gałąź `master` do niego:

<!-- The third type of reference that you’ll see is a remote reference. If you add a remote and push to it, Git stores the value you last pushed to that remote for each branch in the `refs/remotes` directory. For instance, you can add a remote called `origin` and push your `master` branch to it: -->

    $ git remote add origin git@github.com:schacon/simplegit-progit.git
    $ git push origin master
    Counting objects: 11, done.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (7/7), 716 bytes, done.
    Total 7 (delta 2), reused 4 (delta 1)
    To git@github.com:schacon/simplegit-progit.git
       a11bef0..ca82a6d  master -> master

Następnie możesz zobaczyć w którym miejscu była gałąź `master` na zdalnym repozytorium `origin` w czasie gdy wysyłałeś zmiany, przez sprawdzenie pliku `refs/remotes/origin/master`:

<!-- Then, you can see what the `master` branch on the `origin` remote was the last time you communicated with the server, by checking the `refs/remotes/origin/master` file: -->

    $ cat .git/refs/remotes/origin/master
    ca82a6dff817ec66f44342007202690a93763949

Zdalne referencje różnią się od gałęzi (referencji w `refs/heads`) głównie tym, że nie mogą być pobrane (przez komendę "checkout"). Git zapisuje jest rodzaj zakładek wskazujących na ostatni znany stan w którym te gałęzi były na serwerze.

<!-- Remote references differ from branches (`refs/heads` references) mainly in that they can’t be checked out. Git moves them around as bookmarks to the last known state of where those branches were on those servers. -->



## Spakowane pliki (packfiles) ##

<!-- ## Packfiles ## -->

Spójrzmy na obiekty które znajdują się w testowym repozytorium Gita. W tej chwili, masz 11 obiektów - 4 blob, 3 tree, 3 commit i 1 tag.

<!-- Let’s go back to the objects database for your test Git repository. At this point, you have 11 objects — 4 blobs, 3 trees, 3 commits, and 1 tag: -->

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

Git kompresuje zawartość tych plików za pomocą biblioteki zlib, a Ty nie masz dużej ilości danych, więc te pliki łącznie zajmują tylko 925 bajtów. Dodajmy trochę większych plików do repozytorium, aby pokazać bardzo ciekawą funkcję Gita. Dodaj plik repo.rb z biblioteki Grit na której wcześniej pracowaliśmy - ma on około 12 tysięcy znaków:

<!-- Git compresses the contents of these files with zlib, and you’re not storing much, so all these files collectively take up only 925 bytes. You’ll add some larger content to the repository to demonstrate an interesting feature of Git. Add the repo.rb file from the Grit library you worked with earlier — this is about a 12K source code file: -->

    $ curl -L https://raw.github.com/mojombo/grit/master/lib/grit/repo.rb > repo.rb
    $ git add repo.rb
    $ git commit -m 'added repo.rb'
    [master 484a592] added repo.rb
     3 files changed, 459 insertions(+), 2 deletions(-)
     delete mode 100644 bak/test.txt
     create mode 100644 repo.rb
     rewrite test.txt (100%)

Jak spojrzysz na wynikowe drzewo, zobaczysz jaką sumę SHA-1 plik repo.rb otrzymał:

<!-- If you look at the resulting tree, you can see the SHA-1 value your repo.rb file got for the blob object: -->

    $ git cat-file -p master^{tree}
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
    100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
    100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Następnie możesz sprawdzić ile miejsca zajmuje on na dysku:

<!-- You can then check how big is that object on your disk: -->

    $ du -b .git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e
    4102    .git/objects/9b/c1dc421dcd51b4ac296e3e5b6e2a99cf44391e

Teraz, zmodyfikujmy trochę ten plik i sprawdźmy co się stanie:

<!-- Now, modify that file a little, and see what happens: -->

    $ echo '# testing' >> repo.rb 
    $ git commit -am 'modified repo a bit'
    [master ab1afef] modified repo a bit
     1 files changed, 1 insertions(+), 0 deletions(-)

Sprawdź ponownie wynikowe drzewo projektu, a zobaczysz coś interesującego:

<!-- Check the tree created by that commit, and you see something interesting: -->

    $ git cat-file -p master^{tree}
    100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
    100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
    100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Obiekt blog jest teraz zypełnie inny, co oznacza, że pomimo tego że dodałeś tylko jedną linię na końcu pliku który miał 400 linii, Git zapisał całą nową zawartość jako nowy obiekt:

<!-- The blob is now a different blob, which means that although you added only a single line to the end of a 400-line file, Git stored that new content as a completely new object: -->

    $ du -b .git/objects/05/408d195263d853f09dca71d55116663690c27c
    4109    .git/objects/05/408d195263d853f09dca71d55116663690c27c

Masz teraz dwa prawie takie same obiekty zajmujące 4kb na dysku. Czy nie byłoby fajnie, gdyby Git mógł przechowywać tylko jeden z nich, a drugi tylko jako różnicę między nim a pierwszym?

<!-- You have two nearly identical 4K objects on your disk. Wouldn’t it be nice if Git could store one of them in full but then the second object only as the delta between it and the first? -->

Okazuje się że może. Początkowym formatem w jakim Git przechowuje obiekty na dysku jest tak zwany luźny format. Jednak, czasami Git pakuje kilka obiektów w pojedynczy plik binarny  określany jako "packfile", aby zmniejszyć użycie przestrzeni dyskowej i przez to być bardziej wydajnym. Git wykona to, jeżeli masz dużą ilość luźnych obiektów, jeżeli uruchomisz komendę `git gc`, lub jeżeli wypchniesz dane na zdalny serwer. Aby zobaczyć jak to wygląda, możesz ręcznie zmusić Gita aby spakował te obiekty, za pomocą wywołania komendy `git gc`:

<!-- It turns out that it can. The initial format in which Git saves objects on disk is called a loose object format. However, occasionally Git packs up several of these objects into a single binary file called a packfile in order to save space and be more efficient. Git does this if you have too many loose objects around, if you run the `git gc` command manually, or if you push to a remote server. To see what happens, you can manually ask Git to pack up the objects by calling the `git gc` command: -->

    $ git gc
    Counting objects: 17, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (13/13), done.
    Writing objects: 100% (17/17), done.
    Total 17 (delta 1), reused 10 (delta 0)

Jak spojrzysz na katalog "objects", zauważysz że większość Twoich obiektów zniknęła i pojawiła się para nowych plików:

<!-- If you look in your objects directory, you’ll find that most of your objects are gone, and a new pair of files has appeared: -->

    $ find .git/objects -type f
    .git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
    .git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
    .git/objects/info/packs
    .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
    .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

Obiekty blob które pozostały, to obiekty które nie wskazywały na żaden obiekt commit - w tym przypadku, przykładowe obiekty blob "what is up, doc?" oraz "test content", które zostały stworzone wcześniej. Ponieważ nie zostały one nigdy powiązane z żadnym commitem, Git uznał że nie są z niczym powiązane i nie włączył ich do żadnego pliku packfile.

<!-- The objects that remain are the blobs that aren’t pointed to by any commit — in this case, the "what is up, doc?" example and the "test content" example blobs you created earlier. Because you never added them to any commits, they’re considered dangling and aren’t packed up in your new packfile. -->

Kolejne nowe pliki to plik packfile oraz indeks. Plik packfile to pojedynczy plik, zawierający zawartość wszystkich obiektów które zostały usunięte. Plik indeks zawiera informacje o tym, w którym miejscu w pliku packfile znajduje się konkretny obiekt. Co jest ciekawe, to to, że przed uruchomieniem `gc` obiekty na dysku zajmowały łącznie około 8K, a nowy plik packfile tylko 4K. Przez spakowanie obiektów, zmniejszyłeś o połowę ilość zajmowanego miejsca.

<!-- The other files are your new packfile and an index. The packfile is a single file containing the contents of all the objects that were removed from your filesystem. The index is a file that contains offsets into that packfile so you can quickly seek to a specific object. What is cool is that although the objects on disk before you ran the `gc` were collectively about 8K in size, the new packfile is only 4K. You’ve halved your disk usage by packing your objects. -->

W jaki sposób Git to robi? Gdy Git pakuje obiekty, szuka plików które pod względem nazwy pliku i rozmiaru są podobne, i zachowuje tylko różnicę między wersjami. Możesz obejrzeć zawartość pliku packfile i zobaczyć co Git zrobił aby ograniczyć zużycie przestrzeni dyskowej. Komenda `git verify-pack` pozwala na podgląd tego, co zostało spakowane:

<!-- How does Git do this? When Git packs objects, it looks for files that are named and sized similarly, and stores just the deltas from one version of the file to the next. You can look into the packfile and see what Git did to save space. The `git verify-pack` plumbing command allows you to see what was packed up: -->

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

W tym przypadku, obiekt blob `9bc1d`, co możesz pamiętać był pierwszą wersją pliku repo.rb, oraz jest on powiązany z obiektem blob `05408`, który był drugą wersją tego pliku. Trzecia kolumna w wyniku pokazuje rozmiar zawartości obiektu, możesz więc zobaczyć, że zawartość `05408` zajmuje 12K, ale `9bc1d` tylko 7 bajtów. Interesujące jest również to, że to druga wersja pliku została zachowana bez zmian, a poprzednia wersja jest różnicą zmian w stosunku do niej - dzieje się tak dlatego, że najczęściej potrzebujesz szybko dostać się do najnowszej wersji pliku.

<!-- Here, the `9bc1d` blob, which if you remember was the first version of your repo.rb file, is referencing the `05408` blob, which was the second version of the file. The third column in the output is the size of the object’s content, so you can see that the content of `05408` takes up 12K, but that of `9bc1d` only takes up 7 bytes. What is also interesting is that the second version of the file is the one that is stored intact, whereas the original version is stored as a delta — this is because you’re most likely to need faster access to the most recent version of the file. -->

Bardzo fajną rzeczą z tym związaną jest to, że te pliki mogą być przepakowane w każdej chwili. Git czasami przepakuje bazę danych automatycznie, zawsze starając się aby zachować jak najwięcej miejsca. Możesz również ręcznie przepakować te pliki, wywołując w dowolnym momencie komendę `git gc`.

<!-- The really nice thing about this is that it can be repacked at any time. Git will occasionally repack your database automatically, always trying to save more space. You can also manually repack at any time by running `git gc` by hand. -->

## Refspec ##

<!-- ## The Refspec ## -->

W trakcie czytania tej książki, używałeś prostych mapowań ze zdalnych gałęzi do lokalnych referencji; jednak mogą one być znaczniej bardziej złożone.
Załóżmy, że dodajesz zdalne repozytorium w taki sposób:

<!-- Throughout this book, you’ve used simple mappings from remote branches to local references; but they can be more complex.
Suppose you add a remote like this: -->

    $ git remote add origin git@github.com:schacon/simplegit-progit.git

Doda to kolejną sekcję w pliku `.git/config`, określającą nazwę zdalnego repozytorium (`origin`), adres URL tego repozytorium, oraz refspec do pobierania:

<!-- It adds a section to your `.git/config` file, specifying the name of the remote (`origin`), the URL of the remote repository, and the refspec for fetching: -->

    [remote "origin"]
           url = git@github.com:schacon/simplegit-progit.git
           fetch = +refs/heads/*:refs/remotes/origin/*

Refspec składa się z opcjonalnego znaku `+`, oraz wskazania ścieżki źródłowej i docelowej `<src>:<dst>`, gdzie `<src>` wskazuje referencję na zewnętrznym serwerze, a `<dst>` jest miejscem, w którym te referencje będą zapisywane lokalnie. Znak `+` wskazuje Gitowi, aby wykonywał aktualizację nawet wtedy, gdy ta referencja nie jest zwykłym przesunięciem (ang. fast-forward).

<!-- The format of the refspec is an optional `+`, followed by `<src>:<dst>`, where `<src>` is the pattern for references on the remote side and `<dst>` is where those references will be written locally. The `+` tells Git to update the reference even if it isn’t a fast-forward. -->

W zwyczajnym przypadku, jest to zapisywane automatycznie przez komendę `git remote add`, Git pobiera wszystkie referencje z `refs/heads/` na serwerze i zapisuje je do `refs/remotes/origin/` lokalnie. Więc, jeżeli istnieje gałąź `master` na serwerze, możesz uzyskać dostęp do logów tej gałęzi poprzez

<!-- In the default case that is automatically written by a `git remote add` command, Git fetches all the references under `refs/heads/` on the server and writes them to `refs/remotes/origin/` locally. So, if there is a `master` branch on the server, you can access the log of that branch locally via -->

    $ git log origin/master
    $ git log remotes/origin/master
    $ git log refs/remotes/origin/master

Wszystkie te komendy są równoważne, ponieważ Git rozwinie je wszystkie do `refs/remotes/origin/master`.

<!-- They’re all equivalent, because Git expands each of them to `refs/remotes/origin/master`. -->

Jeżeli chciałbyś, aby Git pobierał za każdym razem tylko gałąź `master`, a nie wszystkie inne gałęzie na zdalnym serwerze, możesz zmienić linię fetch na

<!-- If you want Git instead to pull down only the `master` branch each time, and not every other branch on the remote server, you can change the fetch line to -->

    fetch = +refs/heads/master:refs/remotes/origin/master

Jest to po prostu domyślna definicja refspec używana przez komendę `git fetch` podczas pobierania danych ze zdalnego repozytorium. Jeżeli chcesz wykonać coś jednorazowo, możesz podać definicję refspec również z linii komend. Aby pobrać gałąź `master` z zdalnego serwera, do `origin/mymaster` możesz uruchomić

<!-- This is just the default refspec for `git fetch` for that remote. If you want to do something one time, you can specify the refspec on the command line, too. To pull the `master` branch on the remote down to `origin/mymaster` locally, you can run -->

    $ git fetch origin master:refs/remotes/origin/mymaster

Możesz również ustawić kilka refspec. Z linii komend, możesz pobrać kilka gałęzi za pomocą:

<!-- You can also specify multiple refspecs. On the command line, you can pull down several branches like so: -->

    $ git fetch origin master:refs/remotes/origin/mymaster \
       topic:refs/remotes/origin/topic
    From git@github.com:schacon/simplegit
     ! [rejected]        master     -> origin/mymaster  (non fast forward)
     * [new branch]      topic      -> origin/topic

W tym wypadku, pobieranie gałęzi master zostało odrzucone, ponieważ nie była to gałąź fast-forward (tzn. nie było możliwe wykonanie prostego przesunięcia w celu włączenia zmian). Możesz to zmienić, poprzez ustawienie znaku `+` na początku definicji refspec.

<!-- In this case, the  master branch pull was rejected because it wasn’t a fast-forward reference. You can override that by specifying the `+` in front of the refspec. -->

Możesz również ustawić wiele definicji refspec w pliku konfiguracyjnym. Jeżeli zawsze chcesz pobierać gałęzie master i experiment, dodaj dwie linie:

<!-- You can also specify multiple refspecs for fetching in your configuration file. If you want to always fetch the master and experiment branches, add two lines: -->

    [remote "origin"]
           url = git@github.com:schacon/simplegit-progit.git
           fetch = +refs/heads/master:refs/remotes/origin/master
           fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Nie możesz użyć masek na ścieżkach, więc takie ustawienie będzie błędne:

<!-- You can’t use partial globs in the pattern, so this would be invalid: -->

    fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Możesz jednak użyć przestrzeni nazw aby osiągnąć podobny efekt. Jeżeli masz zespół QA, który wypycha nowe gałęzie, a Ty chcesz pobrać tylko gałąź master oraz wszystkie gałęzie stworzone przez zespół QA, możesz wpisać w pliku konfiguracyjnym coś takiego:

<!-- However, you can use namespacing to accomplish something like that. If you have a QA team that pushes a series of branches, and you want to get the master branch and any of the QA team’s branches but nothing else, you can use a config section like this: -->

    [remote "origin"]
           url = git@github.com:schacon/simplegit-progit.git
           fetch = +refs/heads/master:refs/remotes/origin/master
           fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

Jeżeli masz bardziej złożony sposób współpracy, w którym zespół QA wypycha gałęzie, programiści wypychają gałęzie, oraz zespół integrujący również wypycha oraz współpracuje ze zdalnymi gałęziami, możesz stworzyć dla każdego z nich przestrzenie nazw w ten sposób. 

<!-- If you have a complex workflow process that has a QA team pushing branches, developers pushing branches, and integration teams pushing and collaborating on remote branches, you can namespace them easily this way. -->

### Wypychanie Refspecs ###

<!-- ### Pushing Refspecs ### -->

Fajnie, że w tym sposobem możesz pobrać referencje z konkretnych referencji, ale w jaki sposób zespół QA ma wstawiać swoje gałęzie do przestrzeni `qa/` w pierwszej kolejności? Możesz to osiągnąć, poprzez użycie refspec dla komendy push.

<!-- It’s nice that you can fetch namespaced references that way, but how does the QA team get their branches into a `qa/` namespace in the first place? You accomplish that by using refspecs to push. -->

Jeżeli zespół QA chce wypychać swoją gałąź `master` do `qa/master` na zdalnym serwerze, mogą oni uruchomić

<!-- If the QA team wants to push their `master` branch to `qa/master` on the remote server, they can run -->

    $ git push origin master:refs/heads/qa/master

Jeżeli zechcą, aby Git robił to automatycznie za każdym razem po uruchomieniu `git push origin`, mogą dodać definicję `push` do swojego pliku konfiguracyjnego:

<!-- If they want Git to do that automatically each time they run `git push origin`, they can add a `push` value to their config file: -->

    [remote "origin"]
           url = git@github.com:schacon/simplegit-progit.git
           fetch = +refs/heads/*:refs/remotes/origin/*
           push = refs/heads/master:refs/heads/qa/master

I znowu, to spowoduje, że komenda `git push origin` będzie domyślnie wypychała lokalną gałąź `master` do zdalnej `qa/master`.

<!-- Again, this will cause a `git push origin` to push the local `master` branch to the remote `qa/master` branch by default. -->

### Usuwanie referencji ###

<!-- ### Deleting References ### -->

Możesz również używać definicji refspec do usuwania referencji ze zdalnego serwera, poprzez uruchomienie komendy podobnej do:

<!-- You can also use the refspec to delete references from the remote server by running something like this: -->

    $ git push origin :topic

Ponieważ refspec składa się z `<src>:<dst>`, przez opuszczenie części `<src>`, wskazujesz aby stworzyć nową pustą gałąź tematyczną, co ją kasuje.

<!-- Because the refspec is `<src>:<dst>`, by leaving off the `<src>` part, this basically says to make the topic branch on the remote nothing, which deletes it. -->

## Protokoły transferu ##

<!-- ## Transfer Protocols ## -->

Git może przesyłać dane między repozytoriami na dwa główne sposoby: poprzez protokół HTTP oraz poprzez tak zwane inteligentne protokoły, używane transportach `file://`, `ssh://` oraz `git://`. Ten rodział szybko pokaże w jaki sposób te protokoły działają.

<!-- Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate. -->

### Protokół prosty ###

<!-- ### The Dumb Protocol ### -->

Transfer danych za pomocą protokołu HTTP jest często określany jako transfer prosty, ponieważ do jego działania nie jest wymagana obsługa Git na serwerze. Podczas pobierania danych za pomocą komendy "fetch", wykonywane są kolejno zapytania GET, z których program kliencki może odnaleźć strukturę repozytorium Git. Prześledźmy proces `http-fetch` dla biblioteki simplegit:

<!-- Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library: -->

    $ git clone http://github.com/schacon/simplegit-progit.git

Pierwszą rzeczą jaką wykonuje ta komenda, jest pobranie pliku `info/refs`. Plik ten jest zapisywany przez komendę `update-server-info`, dlatego też musisz włączyć komendę `post-receive`, aby przesyłanie danych przez HTTP działało poprawnie:

<!-- The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly: -->

    => GET info/refs
    ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Masz teraz listę zdalnych referencji oraz ich sumy SHA. Następnie sprawdzasz co znajduje się w HEAD, tak aby było wiadomo jaką gałąź pobrać po zakończeniu:

<!-- Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished: -->

    => GET HEAD
    ref: refs/heads/master

Musisz pobrać gałąź `master` po ukończeniu całego procesu.
W tym momencie możesz rozpocząć proces odnajdowania struktury repozytorium. Elementem początkowym jest commit `ca82a6`, który zobaczyłeś w pliku `info/refs`, pobierz go jako pierwszego:

<!-- You need to check out the `master` branch when you’ve completed the process.
At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that: -->

    => GET objects/ca/82a6dff817ec66f44342007202690a93763949
    (179 bytes of binary data)

Otrzymujesz w odpowiedzi obiekt - pobrany z serwera obiekt jest w luźnym formacie i został pobrany poprzez zapytanie HTTP GET. Możesz rozpakować ten plik, usunąć nagłówki i odczytać jego zawartość:

<!-- You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content: -->

    $ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
    tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
    parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    author Scott Chacon <schacon@gmail.com> 1205815931 -0700
    committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

    changed the version number

W następnej kolejności masz dwa obiekty do pobrania - `cfda3b`, który jest obiektem tree z zawartością na którą wskazuje pobrany commit; oraz `085bb3`, który jest poprzednim commitem:

<!-- Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit: -->

    => GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    (179 bytes of data)

Otrzymałeś więc kolejny obiekt commit. Pobierz zawartość obiektu tree:

<!-- That gives you your next commit object. Grab the tree object: -->

    => GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
    (404 - Not Found)

Oops - wygląda na to, że obiekt tree nie jest w luźnym formacie na serwerze, dlatego otrzymałeś odpowiedź 404. Przyczyn takiego stanu rzeczy może być kilka - obiekt może być w alternatywnym repozytorium, lub może być w pliku packfile w tym samym repozytorium. Git najpierw sprawdza czy są jakieś alternatywne repozytoria dodane:

<!-- Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first: -->

    => GET objects/info/http-alternates
    (empty file)

Jeżeli zwrócona zostanie lista alternatywnych adresów URL, Git sprawdzi czy istnieją w nich szukane pliki w luźnym formacie lub spakowane pliki packfile - jest to bardzo fajny mechanizm umożliwiający współdzielenie plików dla projektów które rozwidlają się (ang. fork) jeden od drugiego. Jednak, ze względu na to, że nie ma żadnych alternatywnych plików w tym przykładzie, szukany obiekt musi być w spakowanym pliku packfile. Aby zobaczyć jakie pliki packfile są dostępne na serwerze, musisz pobrać plik `objects/info/packs` zawierający ich listę (ten plik jest również tworzony przez `update-server-info`):

<!-- If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`): -->

    => GET objects/info/packs
    P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Jest tylko jeden plik packfile na serwerze, więc szukany obiekt jest na pewno w nim, sprawdź jednak plik indeks aby mieć pewność. Jest to również przydatne, gdy masz wiele plików packfile na serwerze, tak abyś mógł zobaczyć który z nich zawiera obiekt którego szukasz:

<!-- There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need: -->

    => GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
    (4k of binary data)

Teraz, gdy pobrałeś już indeks pliku packfile, możesz zobaczyć jakie obiekty się w nim znajdują - ponieważ zawiera on listę sum SHA obiektów oraz informacje o tym w którym miejscu w pliku packfile ten obiekt się znajduje. Twój obiekt w nim jest, pobierz więc cały plik packfile:

<!-- Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile: -->

    => GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
    (13k of binary data)

Masz już obiekt tree, możesz więc kontynuować przechodzenie przez wszystkie zmiany. Wszystkie one zawarte są również w pliku packfile który właśnie pobrałeś, nie musisz więc wykonywać żadnych dodatkowych zapytań do serwera. Git pobierze kopię roboczą z gałęzi `master`, na którą wskazywała referencja pobrana z HEAD na początku całego procesu.

<!-- You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning. -->

Wynik działania całego procesu wygląda tak:

<!-- The entire output of this process looks like this: -->

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

### Protokół Inteligentny ###

<!-- ### The Smart Protocol ### -->

Metoda pobierania za pomocą HTTP jest prosta, ale nieefektywna. Używanie protokołów inteligentnych jest znacznie częstszym sposobem do transferu danych. Te protokołu posiadają uruchomiony program na drugim końcu połączenia, który zna działanie Gita - może on odczytywać lokalne dane, oraz może wygenerować dane dla konkretnego klienta na podstawie tego jakie informacje on już posiada. Są dwa rodzaje procesów do przesyłania danych: para procesów do wgrywania danych, oraz para do pobierania.

<!-- The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data. -->

#### Wgrywanie Danych ####

<!-- #### Uploading Data #### -->

Aby wgrać dane do zdalnego repozytorium, Git używa procesów `send-pack` oraz `receive-pack`. Proces `send-pack` uruchomiony jest po stronie klienta i łączy się do procesu `receive-pack` uruchomionego na zdalnym serwerze.

<!-- To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side. -->

Na przykład, załóżmy że uruchamiasz `git push origin master` w swoim projekcie, a `origin` jest zdefiniowany jako URL używający protokołu ssh. Git uruchamia proces `send-pack`, który zainicjuje połączenie przez SSH do Twojego serwera. Uruchamia on komendę na zdalnym serwerze przez SSH, podobną do:

<!-- For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this: -->

    $ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
    005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
    003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
    0000

Komenda `git-receive-pack` od razu odpowiada jedną linią dla każdej referencji którą aktualnie zawiera - w tym przypadku, tylko gałąź `master` oraz jej SHA. Pierwsza linia zawiera również listę funkcji serwera (tutaj `report-status` i `delete-refs`).

<!-- The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`). -->

Każda linia rozpoczyna się 4-bajtową wartością hex wskazującą na to, jak długa jest reszta linii. Pierwsza linia rozpoczyna się 005b, co daje 91 w hex, co oznacza że 91 bajtów pozostało w tej linii. Następna linia rozpoczyna się od 003e, czyli 62, odczytujesz więc pozostałe 62 bajty. Kolejna linia to 0000, oznaczająca że serwer zakończył listowanie referencji.

<!-- Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing. -->

Teraz, gdy zna on już stan który jest na serwerze, Twój proces `send-pack` ustala które z posiadanych commitów nie istnieją na serwerze. Dla każdej referencji która zostanie zaktualizowana podczas tego pusha, proces `send-pack` przekazuje `receive-pack` te informacje. Na przykład, jeżeli aktualizujesz gałąź `master` oraz dodajesz gałąź `experiment`, odpowiedź `send-pack` może wyglądać tak:

<!-- Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this: -->

    0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
    00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
    0000

Wartość SHA-1 składająca się z samych '0' oznacza że nic nie było wcześniej - ponieważ dodajesz referencję experiment. Jeżeli usuwasz referencję, zobaczyć sytuację odwrotną: same zera po prawej stronie.

<!-- The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side. -->

Git wysyła linię dla każdej referencji którą aktualizujesz z starą sumą SHA, nową sumą SHA, oraz referencję. Pierwsza linia zawiera również funkcje obsługiwane prze klienta. Następnie, program kliencki wysyła plik packfile zawierający wszystkie obiekty których nie ma na serwerze. Na końcu, serwer wysyła odpowiedź wskazująca na poprawne lub błędne zakończenie: 

<!-- Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication: -->

    000Aunpack ok

#### Pobieranie Danych ####

<!-- #### Downloading Data #### -->

Podczas pobierania danych, procesy `fetch-pack` oraz `upload-pack` są używane. Po stronie klienta uruchamiany jest proces `fetch-pack`, łączący się do `upload-pack` na drugim końcu, w celu ustalenia które dane mają być pobrane.

<!-- When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down. -->

Istnieją różne sposoby na zainicjowanie procesu `upload-pack` na zdalnym repozytorium. Możesz uruchomić przez SSH, w sposób podobny do procesu `receive-pack`. Możesz również zainicjować ten proces przez demona Git, który domyślnie nasłuchuje na serwerze na porcie 9418. Proces `fetch-pack` wysyła dane, które wyglądają tak jak te, po połączeniu:

<!-- There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting: -->

    003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Rozpoczyna się ona 4 bajtami wskazującymi na to, ile danych będzie przesłanych, następnie komenda do uruchomienia zakończona znakiem null, a następnie nazwa domenowa serwera zakończona końcowym znakiem null. Demon Git sprawdza czy komenda może zostać uruchomiona, oraz czy repozytorium istnieje i ma publiczne uprawnienia. Jeżeli wszystko jest poprawnie, uruchamia proces `upload-pack` i przekazuje do niego zapytanie.

<!-- It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it. -->

jeżeli wykonujesz komendę fetch przez SSH, `fetch-pack` uruchamia komendę podobną do:

<!-- If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this: -->

    $ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

W każdym z tym przypadków, po połączeniu `fetch-pack`, `upload-pack` zwraca wyniki podobny do:

<!-- In either case, after `fetch-pack` connects, `upload-pack` sends back something like this: -->

    0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
      side-band side-band-64k ofs-delta shallow no-progress include-tag
    003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
    003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
    0000

jest to bardzo podobna odpowiedź to tej którą zwrócił `receive-pack`, ale z innymi obsługiwanymi funkcjami. Dodatkowo, zwracana jest referencja HEAD, tak aby klient wiedział co ma pobrać w przypadku klonowania repozytorium.

<!-- This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone. -->

W tym momencie, proces `fetch-pack` sprawdza jakie obiekty posiada i wysyła odpowiedź z obiektami które potrzebuje za pomocą "want" oraz sumy SHA. Wysyła informację o tym jakie obiekty już posiada za pomocą "have" oraz SHA. Na końcu listy, wypisuje "done", aby proces `upload-pack` wiedział że ma rozpocząć wysyłanie spakowanych plików packfile z danymi które są potrzebne:

<!-- At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs: -->

    0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
    0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    0000
    0009done

To są bardzo proste przykłady protokołów przesyłania danych. W bardziej skomplikowanych, program kliencki wspiera funkcje `multi_pack` lub `side-band`; ale ten przykład pokazuje Ci podstawowe działanie inteligentnych protokołów.

<!-- That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes. -->

## Konserwacja i Odzyskiwanie Danych ##

<!-- ## Maintenance and Data Recovery ## -->

Czasami będziesz musiał zrobić jakieś porządki - sprawić, aby repozytorium zajmowało mniej miejsca, oczyścić zaimportowane repozytorium, lub odtworzyć utracone zmiany. Ten rozdział zawiera opis postępowania w tych scenariuszach.

<!-- Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios. -->

### Konserwacja ###

<!-- ### Maintenance ### -->

Sporadycznie Git uruchamia automatycznie komendę nazywaną "auto gc". Najczęściej ta komenda nic nie robi. Jednak, jeżeli istnieje za dużo luźnych obiektów (obiektów które nie są w plikach packfile), lub za dużo plików packfile, Git uruchamia pełną komendę `git gc`. Komenda `gc` (od ang. garbage collect) wykonuje różne operacje: gromadzi ona wszystkie luźne obiekty i umieszcza je w plikach packfile, łączy pliki packfile w jeden duży, oraz usuwa obiekty które nie są osiągalne przez żaden z commitów i są starsze niż kilka miesięcy.

<!-- Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old. -->

Możesz uruchomić "auto gc" ręcznie w ten sposób:

<!-- You can run auto gc manually as follows: -->

    $ git gc --auto

I znowu, ona generalnie nic nie robi. Musisz mieć około 7000 luźnych obiektów, lub więcej niż 50 plików packfile, aby Git odpalił pełną komendę gc. Możesz zmienić te limity za pomocą ustawień konfiguracyjnych `gc.auto` oraz `gc.autopacklimit`.

<!-- Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively. -->

Inną rzeczą którą komenda `gc` zrobi, jest spakowanie referencji do pojedynczego pliku. Załóżmy, że Twoje repozytorium zawiera następujące gałęzie i tagi:

<!-- The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags: -->

    $ find .git/refs -type f
    .git/refs/heads/experiment
    .git/refs/heads/master
    .git/refs/tags/v1.0
    .git/refs/tags/v1.1

jeżeli uruchomisz `git gc`, nie będziesz miał już tych plików w katalogu `refs`. Git przeniesie je, w celu poprawienia wydajności do pliku `.git/packed-refs`, który wygląda tak:

<!-- If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this: -->

    $ cat .git/packed-refs
    # pack-refs with: peeled
    cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
    ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
    cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
    9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
    ^1a410efbd13591db07496601ebc7a059dd55cfe9

Jeżeli zaktualizujesz referencje, Git nie będzie zmieniał tego pliku, ale zamiast tego stworzy nowy plik w `refs/heads`. Aby pobrać właściwą sumę SHA dla danej referencji, Git sprawdzi czy istnieje ona w katalogu `refs`, a następnie sprawdzi plik `packed-refs`. Jeżeli nie możesz znaleźć referencji w katalogu `refs`, jest ona prawdopodobnie w pliku `packed-refs`.

<!-- If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file. -->

Zauważ, że ostatnia linia w tym pliku zaczyna się od `^`. Oznacza to, że dana etykieta jest etykietą opisaną, a ta linia jest commit-em na który on wskazuje.

<!-- Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to. -->

### Odzyskiwanie Danych ###

<!-- ### Data Recovery ### -->

W pewnym momencie swojej pracy z Git, możesz czasami przez przypadek stracić commit. Zazwyczaj dzieje się tak dlatego, ponieważ wymusisz usunięcie gałęzi która miała w sobie zmiany, a okazuje się że jednak ją potrzebowałeś; lub wykonujesz na gałęzi hard-reset, porzucając zmiany które teraz potrzebujesz. Zakładając że tak się stało, w jaki sposób możesz odzyskać swoje zmiany?

<!-- At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back? -->

Mamy tutaj przykład, na którym zobaczymy odzyskiwanie danych z testowego repozytorium na którym wykonano hard-reset na gałęzi master. Na początek, zobaczmy jak wygląda repozytorium w takiej sytuacji:

<!-- Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point: -->

    $ git log --pretty=oneline
    ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
    484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Teraz cofnij gałąź `master` do środkowej zmiany:

<!-- Now, move the `master` branch back to the middle commit: -->

    $ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
    HEAD is now at 1a410ef third commit
    $ git log --pretty=oneline
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

W ten sposób, skutecznie utraciłeś dwa najnowsze commity - nie masz gałęzi z której można by się dostać do nich. Musisz znaleźć najnowszą sumę SHA, a potem dodać gałąź wskazującą na nią. Najtrudniejsze jest znalezienie ostatniej sumy SHA - przecież nie zapamiętałeś jej, prawda?

<!-- You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right? -->

Często, najszybszym sposobem jest użycie narzędzia `git reflog`. W czasie pracy, Git w tle zapisuje na co wskazuje HEAD po każdej zmianie. Za każdym razem gdy wykonujesz commit lub zmieniasz gałęzie, reflog jest aktualizowany. Reflog jest również aktualizowany przez komendę `git update-ref`, co jest kolejnym argumentem za tym, aby jej używać zamiast zapisywać bezpośrednio wartości SHA do plików ref, tak jak zostało to opisane wcześniej w sekcji "Referencje w Git". Możesz zobaczyć na jakim etapie był projekt w każdym momencie za pomocą komendy `git reflog`:

<!-- Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`: -->

    $ git reflog
    1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
    ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Widzimy tutaj dwa commity które pobraliśmy, jednak nie mamy za dużo informacji. Aby zobaczyć te same informacje w bardziej użytecznej formie, możemy uruchomić `git log -g`, która pokaże normalny wynik działania komendy log dla refloga:

<!-- Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog. -->

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

Wygląda na to, że dolny commit to jeden z tych które utraciłeś, możesz go odzyskać przez stworzenie nowej gałęzi wskazującej na niego. Na przykład, możesz dodać gałąź `recover-branch` wskazującą na ten commit (ab1afef):

<!-- It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef): -->

    $ git branch recover-branch ab1afef
    $ git log --pretty=oneline recover-branch
    ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
    484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
    1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
    cac0cab538b970a37ea1e769cbbde608743bc96d second commit
    fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Świetnie - masz teraz gałąź `recover-branch`, która wskazuje na miejsce w którym był `master`, pozwalając tym samym na dostęp do pierwszych dwóch commitów. 
Następnie, załóżmy że utracone zmiany z jakiegoś powodu nie były w reflogu - możesz to zasymulować poprzez usunięcie `recover-branch` i usunięcie refloga. Teraz pierwsze dwa commity nie są dostępne w żaden sposób:

<!-- Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again.
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything: -->

    $ git branch -D recover-branch
    $ rm -Rf .git/logs/

Ponieważ dane reflog są przechowywane w katalogu `.git/logs/`, w rzeczywistości nie masz refloga. W jaki sposób odtworzyć ten commit w tym momencie? Jednym ze sposobów jest użycie narzędzia `git fsck`, które sprawdza zawartość bazy pod względem integralności danych. Jeżeli uruchomisz go z opcją `--full`, pokaże on wszystkie obiekty do których nie da się dotrzeć przez inne:

<!-- Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `-\-full` option, it shows you all objects that aren’t pointed to by another object: -->

    $ git fsck --full
    dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
    dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
    dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
    dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

W tym przypadku, możesz zobaczyć brakujący commit oznaczony jako opuszczony (ang. dangling). Możesz odtworzyć go w ten sam sposób, poprzez dodanie gałęzi wskazującej na jego SHA.

<!-- In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA. -->

### Usuwanie obiektów ###

<!-- ### Removing Objects ### -->

Można powiedzieć dużo dobrego o Gitcie, ale jedną z funkcjonalności która może powodować problemy jest fakt, że `git clone` pobiera całą historię projektu, włącznie z każdą wersją wszystkich plików. Jest to dobre rozwiązanie, jeżeli całość to kod źródłowy, ponieważ Git został przygotowany do tego aby efektywnie kompresować takie dane. Jednak, jeżeli w jakimś momencie trwania projektu, ktoś dodał pojedynczy duży plik, podczas klonowania repozytorium zawsze będzie on pobierany, nawet jeżeli został usunięty z projektu w następnym commicie. Ze względu na to, że można do niego dostać się przez historię projektu, zawsze tam będzie.

<!-- There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there. -->

Może to być dużym problemem podczas konwersji repozytoriów Subversion lub Perforce do Gita. Ponieważ nie pobierasz w nich całej historii projektu, dodanie tak dużego pliku będzie powodowało pewne konsekwencje. Jeżeli wykonałeś import z innego systemu lub zobaczyłeś, że Twoje repozytorium jest dużo większej niż być powinno, poniżej prezentuję sposób na usunięcie dużych obiektów.

<!-- This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects. -->

Ale uwaga: ta technika działa destrukcyjnie na Twoją historię zmian. Nadpisuje ona każdy obiekt, począwszy od najwcześniejszego który trzeba zmodyfikować aby usunąć odwołanie do pliku. Jeżeli wykonasz to od razu po zaimportowaniu, zanim ktokolwiek rozpoczął pracę bazującą na nich, wszystko będzie w porządku - w przeciwnym wypadku, będziesz musiał poinformować wszystkich współpracowników o tym, że muszą wykonać "rebase" na nowe commity.

<!-- Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits. -->

W celach demonstracyjnych, dodasz duży plik do swojego testowego repozytorium, usuniesz go w kolejnym commicie, odszukasz go i następnie usuniesz na stałe z repozytorium. Najpierw dodaj duży plik do repozytorium:

<!-- To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history: -->

    $ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
    $ git add git.tbz2
    $ git commit -am 'added git tarball'
    [master 6df7640] added git tarball
     1 files changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 git.tbz2

Oops - nie chciałeś dodać tego dużego pliku do projekt. Najlepiej usuń go:

<!-- Oops — you didn’t want to add a huge tarball to your project. Better get rid of it: -->

    $ git rm git.tbz2
    rm 'git.tbz2'
    $ git commit -m 'oops - removed large tarball'
    [master da3f30d] oops - removed large tarball
     1 files changed, 0 insertions(+), 0 deletions(-)
     delete mode 100644 git.tbz2

Teraz, uruchom `gc` na bazie danych i zobacz jak dużo miejsca jest zajmowane:

<!-- Now, `gc` your database and see how much space you’re using: -->

    $ git gc
    Counting objects: 21, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (16/16), done.
    Writing objects: 100% (21/21), done.
    Total 21 (delta 3), reused 15 (delta 1)

Możesz uruchomić komendę `count-objects`, aby szybko zobaczyć jak dużo miejsca jest zajmowane:

<!-- You can run the `count-objects` command to quickly see how much space you’re using: -->

    $ git count-objects -v
    count: 4
    size: 16
    in-pack: 21
    packs: 1
    size-pack: 2016
    prune-packable: 0
    garbage: 0

Wpis `size-pack` pokazuje wielkość plików packfile wyrażonych w kilobajtach, więc używasz 2MB. Przed ostatnim commitem, używałeś blisko 2K - a więc jasno widać, że usunięcie pliku w poprzednim commitcie nie usunęło go z historii. Za każdym razem, gdy ktoś sklonuje to repozytorium, będzie musiał pobrać całe 2MB aby pobrać ten malutki projekt, tylko dlatego że pochopnie dodałeś duży plik. Naprawmy to.

<!-- The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it. -->

Najpierw będzie musiał go znaleźć. W naszym wypadku, wiesz jaki plik to był. Ale załóżmy że nie wiesz; w jaki sposób dowiesz się jaki plik lub pliki zajmują tyle miejsca? Po uruchomieniu `git gc`, wszystkie obiekty są w plikach packfile; ale możesz zidentyfikować duże obiekty przez uruchomienie komendy `git verify-pack` i posortowanie wyniku po trzeciej kolumnie, oznaczającej rozmiar pliku. Możesz również przekazać wynik do komendy `tail` ponieważ jesteś zainteresowany tylko kilkoma największymi plikami:

<!-- First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files: -->

    $ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
    e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
    05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
    7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

Duży obiekt jest na samym dole: 2MB. Aby dowiedzieć się jaki to jest plik, użyjesz komendy `rev-list`, której miałeś okazję już poznać w rozdziale 7. Jeżeli przekażesz opcję `--objects` do `rev-list`, w wyniku pokazane zostaną sumy SHA commitów oraz obiektów blob z przyporządkowanymi do nich nazwami plików. Możesz użyć tej komendy, aby odnaleźć nazwę obiektu blob:

<!-- The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `-\-objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name: -->

    $ git rev-list --objects --all | grep 7a9eb2fb
    7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Teraz, musisz usunąć ten plik ze wszystkich starszych rewizji. W łaty sposób możesz zobaczyć jakie commity modyfikowały ten plik:

<!-- Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file: -->

    $ git log --pretty=oneline --branches -- git.tbz2
    da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
    6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Musisz nadpisać wszystkie commity starsze niż `6df76`, aby w pełni usunąć ten plik z historii projektu w Git. Aby to zrobić, użyjesz komendy `filter-branch`, poznanej w rozdziale 6.

<!-- You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6: -->

    $ git filter-branch --index-filter \
       'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
    Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
    Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
    Ref 'refs/heads/master' was rewritten

Opcja `--index-filter` jest podobna do opcji `--tree-filter` opisanej w rozdziale 6, z tą różnicą, że zamiast przekazywać komendę, która modyfikuje pobrane pliki na dysku, modyfikuje przechowalnię lub indeks za każdym razem. Zamiast usuwać konkretny plik za pomocą `rm file`, musisz usunąć go za pomocą `git rm --cached` - musisz usunąć go z indeksu, nie z dysku. Powodem do takiego zachowania jest prędkość - ponieważ Git nie musi pobrać każdej rewizji na dysk przed uruchomieniem filtra, cały proces może być dużo szybszy. Możesz osiągnąć taki sam efekt za pomocą `--tree-filter`, jeżeli chcesz. Opcja `--ignore-unmatch` do `git rm` wskazuje, aby nie pokazywać błędu w przypadku, gdy szukana ścieżka nie istnieje. Na koniec, wskazujesz `filter-branch`, aby przepisana została historia począwszy od `6df7640`, ponieważ wiesz że właśnie tam problem powstał. W przeciwnym razie, rozpocznie ona działanie od początku i przez to będzie trwała niepotrzebnie dłużej.

<!-- The `-\-index-filter` option is similar to the `-\-tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm -\-cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `-\-tree-filter` if you want. The `-\-ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer. -->

Twoja historia nie zawiera już odwołań do tego pliku. Ale reflog i nowe referencje które zostały dodane, wtedy gdy uruchomiłeś `filter-branch` w `.git/refs/original` nadal tak, musisz więc je usunąć i przepakować bazę danych. Musisz pozbyć się wszystkiego co wskazuje na te stare commity przed przepakowaniem:

<!-- Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack: -->

    $ rm -Rf .git/refs/original
    $ rm -Rf .git/logs/
    $ git gc
    Counting objects: 19, done.
    Delta compression using 2 threads.
    Compressing objects: 100% (14/14), done.
    Writing objects: 100% (19/19), done.
    Total 19 (delta 3), reused 16 (delta 1)

Zobaczmy ile miejsce udało się zaoszczędzić.

<!-- Let’s see how much space you saved. -->

    $ git count-objects -v
    count: 8
    size: 2040
    in-pack: 19
    packs: 1
    size-pack: 7
    prune-packable: 0
    garbage: 0

Wielkość spakowanego repozytorium to teraz 7K, co jest dużo lepszym wynikiem niż 2MB. Możesz odczytać z wartości "size", że ten duży obiekt nadal znajduje się w repozytorium, nie został więc całkowicie usunięty; jednak co najważniejsze, nie będzie już przesyłany podczas wykonywania push lub klonowania. Jeżeli mocno chcesz, możesz usunąć ten obiekt całkowicie przez uruchomienie komendy `git prune --expire`.

<!-- The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune -\-expire`. -->

## Podsumowanie ##

<!-- ## Summary ## -->

Powinieneś już dość dobrze wiedzieć co Git robi w tle, oraz w pewnym stopniu, w jaki sposób jest to zaimplementowane. Ten rozdział objął kilka niskopoziomowych komend - typu plumbing, komend które są działają na niższym poziomie i są prostsze niż komendy normalnie dostępne dla użytkownika i opisane w pozostałej części książki. Zrozumienie w jaki sposób Git działa powinno ułatwić Ci pisanie własnych komend i skryptów, ułatwiając tym samym pracę.

<!-- You should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helping scripts to make your specific workflow work for you. -->

Git jako system plików ukierunkowany na treść jest bardzo potężnym narzędziem, które może robić znacznie więcej niż tylko zadania związane z kontrolą wersji. Mam nadzieję, że użyjesz tej nowo nabytej wiedzy o wewnętrznych mechanizmach Gita podczas implementacji swojej własnej aplikacji i będziesz czuł się komfortowo podczas używania go w sposób bardziej zaawansowany.

<!-- Git as a content-addressable filesystem is a very powerful tool that you can easily use as more than just a VCS. I hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways. -->

