# Narzędzia Gita #

<!-- # Git Tools # -->

Do tej chwili poznałeś większość komend potrzebnych do codziennej pracy, oraz do prowadzenia repozytorium ze swoim kodem. Wykonywałeś podstawowe zadania dotyczące śledzenia i wprowadzania zmian, oraz wykorzystywałeś przechowalnię, jak również rozgałęzianie oraz łączenie różnych gałęzi.

<!--  By now, you’ve learned most of the day-to-day commands and workflows that you need to manage or maintain a Git repository for your source code control. You’ve accomplished the basic tasks of tracking and committing files, and you’ve harnessed the power of the staging area and lightweight topic branching and merging. -->

Teraz dowiesz się o kolejnych rzeczach, które Git ma do zaoferowania, z których być może nie będziesz korzystał codziennie, ale które z pewnością będą przydatne.

<!-- Now you’ll explore a number of very powerful things that Git can do that you may not necessarily use on a day-to-day basis but that you may need at some point. -->

## Wskazywanie rewizji ##

<!-- ## Revision Selection ## -->

Git umożliwia wskazanie konkretnej zmiany lub zakresu zmian na kilka sposobów. Nie koniecznie są one oczywiste, ale na pewno są warte uwagi.

<!-- Git allows you to specify specific commits or a range of commits in several ways. They aren’t necessarily obvious but are helpful to know. -->

### Pojedyncze rewizje ###

Jak wiesz, możesz odwoływać się do pojedynczej zmiany poprzez skrót SHA-1, istnieją jednak bardziej przyjazne sposoby. Ta sekcja opisuje kilka z nich.

<!-- You can obviously refer to a commit by the SHA-1 hash that it’s given, but there are more human-friendly ways to refer to commits as well. This section outlines the various ways you can refer to a single commit. -->

### Krótki SHA ###

Git jest na tyle inteligentny, że potrafi domyśleć się o którą zmianę Ci chodziło po dodaniu zaledwie kilku znaków, o ile ta część sumy SHA-1 ma przynajmniej 4 znaki i jest unikalna, co oznacza, że istnieje tylko jeden obiekt w repozytorium, który od nich się zaczyna.

<!-- Git is smart enough to figure out what commit you meant to type if you provide the first few characters, as long as your partial SHA-1 is at least four characters long and unambiguous — that is, only one object in the current repository begins with that partial SHA-1. -->

Dla przykładu, aby zobaczyć konkretną zmianę, uruchamiasz komendę `git log` i wybierasz zmianę w której dodałeś jakąś funkcjonalność:

<!-- For example, to see a specific commit, suppose you run a `git log` command and identify the commit where you added certain functionality: -->

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

W tej sytuacji, wybierasz `1c002dd....` Jeżeli chcesz wykonać na nim `git show`, każda z poniższych komend da identyczny efekt (zakładając, że krótsze wersje są jednoznaczne):

<!-- In this case, choose `1c002dd....` If you `git show` that commit, the following commands are equivalent (assuming the shorter versions are unambiguous): -->

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d


Git może sam odnaleźć unikalne występowania wartości SHA-1. Jeżeli przekażesz parametr `--abbrev-commit` do komendy `git log`, jej wynik pokaże krótsze wartości SHA-1, przy zachowaniu ich unikalności; domyślnie stosuje długość 7 znaków, ale może ją zwiększyć, aby zachować unikalność sum kontrolnych:

<!-- Git can figure out a short, unique abbreviation for your SHA-1 values. If you pass `-\-abbrev-commit` to the `git log` command, the output will use shorter values but keep them unique; it defaults to using seven characters but makes them longer if necessary to keep the SHA-1 unambiguous: -->

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Generalnie, 8 do 10 znaków to wystarczająca ilość, aby mieć unikalne wartości w projekcie. Jeden z największych projektów korzystających z Gita, jądro systemu linux, zaczyna używać 12 znaków z dostępnych 40. 

<!-- Generally, eight to ten characters are more than enough to be unique within a project. One of the largest Git projects, the Linux kernel, is beginning to need 12 characters out of the possible 40 to stay unique. -->

### KRÓTKA UWAGA NA TEMAT SHA-1 ###

<!-- ### A SHORT NOTE ABOUT SHA-1 ### -->

Duża ilość osób zaniepokoiła się, gdy ze względu na jakiś szczęśliwy przypadek, mieli w swoim repozytorium dwa różne obiekty posiadające tą samą wartość SHA-1.

<!-- A lot of people become concerned at some point that they will, by random happenstance, have two objects in their repository that hash to the same SHA-1 value. What then? -->

Jeżeli zdarzy Ci się zapisać obiekt który ma sumę kontrolną SHA-1 taką samą jak inny obiekt będący już w repozytorium, Git zauważy, że obiekt taki już istnieje i założy, że został on już zapisany. Jeżeli spróbujesz pobrać jego zawartość, zawsze otrzymasz dane pierwszego obiektu.

<!-- If you do happen to commit an object that hashes to the same SHA-1 value as a previous object in your repository, Git will see the previous object already in your Git database and assume it was already written. If you try to check out that object again at some point, you’ll always get the data of the first object. -->

Powinieneś wiedzieć jednak, że taki scenariusz jest strasznie rzadki. Skrót SHA-1 ma długość 20 bajtów lub 160 bitów. Ilość losowych obiektów potrzebnych do zapewnienia 50% prawdopodobieństwa kolizji to około 2^80 (wzór na obliczenie prawdopodobieństwa kolizji to `p = (n(n-1)/2) * (1/2^160)`). 2^80 to 1.2 x 10^24 lub 1 milion miliardów miliardów. Jest to około 1200 razy ilość ziarenek piasku na kuli ziemskiej.

<!--However, you should be aware of how ridiculously unlikely this scenario is. The SHA-1 digest is 20 bytes or 160 bits. The number of randomly hashed objects needed to ensure a 50% probability of a single collision is about 2^80 (the formula for determining collision probability is `p = (n(n-1)/2) * (1/2^160)`). 2^80 is 1.2 x 10^24 or 1 million billion billion. That’s 1,200 times the number of grains of sand on the earth. -->

Weźmy przykład, aby zaprezentować Ci jak trudne jest wygenerowanie kolizji SHA-1. Jeżeli wszyscy z 6,5 miliarda osób na ziemi byłaby programistami i w każdej sekundzie, każdy z nich tworzyłby kod wielkości całego jądra Linuksa (1 milion obiektów Gita) i wgrywał go do ogromnego repozytorium Gita, zajęłoby około 5 lat, zanim w repozytorium byłoby tyle obiektów, aby mieć pewność 50% wystąpienia kolizji. Istnieje większe prawdopodobieństwo, że każdy z członków Twojego zespołu programistycznego zostanie zaatakowany i zabity przez wilki, w nie związanych ze sobą zdarzeniach, w ciągu tej samej nocy. 

<!-- Here’s an example to give you an idea of what it would take to get a SHA-1 collision. If all 6.5 billion humans on Earth were programming, and every second, each one was producing code that was the equivalent of the entire Linux kernel history (1 million Git objects) and pushing it into one enormous Git repository, it would take 5 years until that repository contained enough objects to have a 50% probability of a single SHA-1 object collision. A higher probability exists that every member of your programming team will be attacked and killed by wolves in unrelated incidents on the same night. -->

### Odniesienie do gałęzi ###

<!-- ### Branch References ### -->

Najprostszym sposobem na wskazanie konkretnej zmiany, jest stworzenie odniesienia do gałęzi wskazującej na nią. Następnie, będziesz mógł używać nazwy gałęzi we wszystkich komendach Gita które przyjmują jako parametr obiekt lub wartość SHA-1. Na przykład, jeżeli chcesz pokazać ostatni zmieniony obiekt w gałęzi, podane niżej komendy są identyczne, przy założeniu, że `topic1` wskazuje na `ca82a6d`:

<!-- The most straightforward way to specify a commit requires that it have a branch reference pointed at it. Then, you can use a branch name in any Git command that expects a commit object or SHA-1 value. For instance, if you want to show the last commit object on a branch, the following commands are equivalent, assuming that the `topic1` branch points to `ca82a6d`: -->

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Jeżeli chciałbyś zobaczyć, na jaką sumę SHA-1 wskazuje dana gałąź, lub jeżeli chcesz zobaczyć na jaką sumę SHA-1 każdy z tych przykładów się rozwiązuje, możesz użyć komendy `rev-parse`. Możesz zobaczyć również rozdział 9, aby dowiedzieć się o tym narzędziu więcej; ale, `rev-parse` wykonuje operacje niskopoziomowo i nie jest stworzony do codziennej pracy. Jednakże potrafi być czasami przydatny, jeżeli musisz zobaczyć co tak naprawdę się dzieje. Możesz teraz wywołać `rev-parse` na swojej gałęzi.

<!-- If you want to see which specific SHA a branch points to, or if you want to see what any of these examples boils down to in terms of SHAs, you can use a Git plumbing tool called `rev-parse`. You can see Chapter 9 for more information about plumbing tools; basically, `rev-parse` exists for lower-level operations and isn’t designed to be used in day-to-day operations. However, it can be helpful sometimes when you need to see what’s really going on. Here you can run `rev-parse` on your branch. -->

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### Skróty do RefLog ###

<!-- ### RefLog Shortnames ### -->

Jedną z rzeczy które Git robi w tle w czasie Twojej pracy, jest utrzymywanie reflog-a - zapisanych informacji o tym, jak wyglądały odwołania HEAD-a i innych gałęzi w ciągu ostatnich miesięcy.

<!-- One of the things Git does in the background while you’re working away is keep a reflog — a log of where your HEAD and branch references have been for the last few months. -->

Możesz zobaczyć reflog-a za pomocą komendy `git reflog`:

<!-- You can see your reflog by using `git reflog`: -->

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Za każdym razem, gdy Twoja gałąź się przesuwa, Git przechowuje tą informację w tej tymczasowej historii. Za jej pomocą, możesz wskazać również starsze zmiany. Jeżeli chcesz zobaczyć zawartość HEAD-a sprzed 5 zmian, możesz użyć odwołania `@{n}`, które widać w wyniku komendy reflog: 

<!-- Every time your branch tip is updated for any reason, Git stores that information for you in this temporary history. And you can specify older commits with this data, as well. If you want to see the fifth prior value of the HEAD of your repository, you can use the `@{n}` reference that you see in the reflog output: -->

	$ git show HEAD@{5}

Możesz również użyć tej składni, aby dowiedzieć się, jak wyglądała dana gałąź jakiś czas temu. Na przykład, aby zobaczyć gdzie była gałąź `master` wczoraj, możesz wywołać

<!-- You can also use this syntax to see where a branch was some specific amount of time ago. For instance, to see where your `master` branch was yesterday, you can type -->

	$ git show master@{yesterday}

Co pokaże Ci, na jakim etapie znajdowała się ta gałąź wczoraj. Ta technika zadziała tylko dla danych które są jeszcze w Twoim reflog-u, nie możesz więc jej użyć do sprawdzenia zmian starszych niż kilka miesięcy.

<!-- That shows you where the branch tip was yesterday. This technique only works for data that’s still in your reflog, so you can’t use it to look for commits older than a few months. -->

Aby zobaczyć wynik reflog-a w formacie podobnym do wyniku `git log`, możesz uruchomić `git log -g`:

<!-- To see reflog information formatted like the `git log` output, you can run `git log -g`: -->

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

Należy zaznaczyć, że informacje z reflog-a są wyłącznie lokalne - jest to zapis zmian które wprowadzałeś w swoim repozytorium. Referencje nie będą takie same na kopii repozytorium u kogoś innego; a od razu po pierwszym sklonowaniu repozytorium, będziesz miał pusty reflog, ze względu na to, że żadna aktywność nie została wykonana. Uruchomienie `git show HEAD{2.months.ago}` zadziała tylko wówczas, gdy sklonowałeś swoje repozytorium przynajmniej dwa miesiące temu - jeżeli sklonowałeś je pięć minut temu, otrzymasz pusty wynik.

<!-- It’s important to note that the reflog information is strictly local — it’s a log of what you’ve done in your repository. The references won’t be the same on someone else’s copy of the repository; and right after you initially clone a repository, you’ll have an empty reflog, as no activity has occurred yet in your repository. Running `git show HEAD@{2.months.ago}` will work only if you cloned the project at least two months ago — if you cloned it five minutes ago, you’ll get no results. -->


### Referencje przodków ###

<!-- ### Ancestry References ### -->

Innym często używanym sposobem na wskazanie konkretnego commit-a jest wskazanie przodka. Jeżeli umieścisz znak `^` na końcu referencji, Git rozwinie to do rodzica tego commit-a. Załóżmy, że spojrzałeś na historię zmian w swoim projekcie:

<!-- The other main way to specify a commit is via its ancestry. If you place a `^` at the end of a reference, Git resolves it to mean the parent of that commit.
Suppose you look at the history of your project: -->

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Następne, możesz zobaczyć poprzednią zmianę, poprzez użycie `HEAD^`, co oznacza "rodzic HEAD-a":

<!-- Then, you can see the previous commit by specifying `HEAD^`, which means "the parent of HEAD": -->

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Możesz również określić liczbę po `^` - na przykład, `d921970^2` oznacza "drugi rodzic d921970". Taka składnia jest użyteczna podczas łączenia zmian, które mają więcej niż jednego rodzica. Pierwszym rodzicem jest gałąź na której byłeś podczas łączenia zmian, a drugim jest zmiana w gałęzi którą łączyłeś:

<!-- You can also specify a number after the `^` — for example, `d921970^2` means "the second parent of d921970." This syntax is only useful for merge commits, which have more than one parent. The first parent is the branch you were on when you merged, and the second is the commit on the branch that you merged in: -->

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

Kolejnym wskaźnikiem przodka jest `~`. On również wskazuje na pierwszego rodzica, więc `HEAD~` i `HEAD^` są równoznaczne. Różnica zaczyna być widoczna po sprecyzowaniu liczby. `HEAD~2` oznacza "pierwszy rodzic pierwszego rodzica", lub inaczej "dziadek" - przemierza to pierwszych rodziców ilość razy którą wskażesz. Na przykład, w historii pokazanej wcześniej, `HEAD~3` będzie:

<!-- The other main ancestry specification is the `~`. This also refers to the first parent, so `HEAD~` and `HEAD^` are equivalent. The difference becomes apparent when you specify a number. `HEAD~2` means "the first parent of the first parent," or "the grandparent" — it traverses the first parents the number of times you specify. For example, in the history listed earlier, `HEAD~3` would be -->

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Może to być również zapisane jako `HEAD^^^`, co znowu daje pierwszego rodzica, pierwszego rodzica, pierwszego rodzica:

<!-- This can also be written `HEAD^^^`, which again is the first parent of the first parent of the first parent: -->

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Możesz również łączyć obie składnie - możesz dostać drugiego rodzica poprzedniej referencji (zakładając że było to łączenie zmian) przy użyciu `HEAD~3^2`, i tak dalej.

<!-- You can also combine these syntaxes — you can get the second parent of the previous reference (assuming it was a merge commit) by using `HEAD~3^2`, and so on. -->

### Zakresy zmian ###

<!-- ### Commit Ranges ### -->

Teraz gdy możesz już wskazywać pojedyncze zmiany, sprawdźmy jak wskazać ich zakres. Jest to szczególnie przydatne podczas zarządzania gałęziami - w sytuacji, gdy masz dużą ilość gałęzi, możesz użyć wskaźnika zakresu zmian, aby odpowiedzieć na pytanie, w stylu "Jakie są zmiany na obecnej gałęzi, których jeszcze nie włączyłem do gałęzi głównej?"

<!-- Now that you can specify individual commits, let’s see how to specify ranges of commits. This is particularly useful for managing your branches — if you have a lot of branches, you can use range specifications to answer questions such as, "What work is on this branch that I haven’t yet merged into my main branch?" -->

#### Podwójna kropka ###

<!-- #### Double Dot #### -->

Najczęściej używaną składnią wskazywania zakresu zmian jest podwójna kropka. Mówi ona Gitowi, aby rozwinął zakres zmian które są osiągalne z pierwszego commitu, ale nie są z drugiego. Na przykład, załóżmy że masz historię zmian która wygląda tak jak na rysunku 6-1.

<!-- The most common range specification is the double-dot syntax. This basically asks Git to resolve a range of commits that are reachable from one commit but aren’t reachable from another. For example, say you have a commit history that looks like Figure 6-1. -->

Insert 18333fig0601.png
Rysunek 6-1. Przykładowa historia dla wskazania zakresu zmian.

<!-- Figure 6-1. Example history for range selection. -->

Chcesz zobaczyć co z tego co znajduje się w Twojej gałęzi "experiment" nie zostało jeszcze włączone do gałęzi "master". Możesz poprosić Gita, aby pokazał Ci logi z informacjami o tych zmianach przy pomocy `master..experiment` - co oznacza "wszystkie zmiany dostępne z experiment które nie są dostępne przez master". Dla zachowania zwięzłości i przejrzystości w tych przykładach, użyję liter ze zmian znajdujących się na wykresie zamiast pełnego wyniku komendy, w kolejności w jakiej się pokażą:

<!-- You want to see what is in your experiment branch that hasn’t yet been merged into your master branch. You can ask Git to show you a log of just those commits with `master..experiment` — that means "all commits reachable by experiment that aren’t reachable by master." For the sake of brevity and clarity in these examples, I’ll use the letters of the commit objects from the diagram in place of the actual log output in the order that they would display: -->


	$ git log master..experiment
	D
	C

Jeżeli, z drugiej strony, chcesz zobaczyć odwrotne działanie - wszystkie zmiany z `master` których nie ma w `experiment` - możesz odwrócić nazwy gałęzi. `experiment..master` pokaże wszystko to z `master`, co nie jest dostępne z `experiment`:

<!-- If, on the other hand, you want to see the opposite — all commits in `master` that aren’t in `experiment` — you can reverse the branch names. `experiment..master` shows you everything in `master` not reachable from `experiment`: -->

	$ git log experiment..master
	F
	E

Jest to przydatne, jeżeli zamierzasz utrzymywać gałąź `experiment` zaktualizowaną, oraz przeglądać co będziesz integrował. Innym bardzo często używanym przykładem użycia tej składni jest sprawdzenie, co zamierzasz wypchnąć do zdalnego repozytorium:
 
<!-- This is useful if you want to keep the `experiment` branch up to date and preview what you’re about to merge in. Another very frequent use of this syntax is to see what you’re about to push to a remote: -->

	$ git log origin/master..HEAD

Ta komenda pokaże wszystkie zmiany z Twojej obecnej gałęzi, których nie ma w zdalnej gałęzi `master` w repozytorium. Jeżeli uruchomisz `git push`, a Twoja obecna gałąź śledzi `origin/master`, zmiany pokazane przez `git log origin/master..HEAD` to te, które będą wysłane na serwer.
Możesz również pominąć jedną ze stron tej składni, aby Git założył HEAD. Dla przykładu, możesz otrzymać takie same wyniki jak w poprzednim przykładzie wywołując `git log origin/master..` - Git wstawi HEAD jeżeli jednej ze stron brakuje.

<!-- This command shows you any commits in your current branch that aren’t in the `master` branch on your `origin` remote. If you run a `git push` and your current branch is tracking `origin/master`, the commits listed by `git log origin/master..HEAD` are the commits that will be transferred to the server.
You can also leave off one side of the syntax to have Git assume HEAD. For example, you can get the same results as in the previous example by typing `git log origin/master..` — Git substitutes HEAD if one side is missing. -->

#### Wielokrotne punkty ####

<!-- #### Multiple Points #### -->

Składnie z dwiema kropkami jest użyteczna jako skrót; ale możesz chcieć wskazać więcej niż dwie gałęzie, jak na przykład zobaczenie które zmiany są w obojętnie której z gałęzi, ale nie są w gałęzi w której się obecnie znajdujesz. Git pozwala Ci na zrobienie tego poprzez użycie znaku `^`, lub opcji `--not` podanej przed referencją z której nie chcesz widzieć zmian. Dlatego też, te trzy komendy są równoznaczne:

<!-- The double-dot syntax is useful as a shorthand; but perhaps you want to specify more than two branches to indicate your revision, such as seeing what commits are in any of several branches that aren’t in the branch you’re currently on. Git allows you to do this by using either the `^` character or `-\-not` before any reference from which you don’t want to see reachable commits. Thus these three commands are equivalent: -->

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Jest to bardzo fajne, ponieważ przy użyciu tej składni możesz wskazać więcej niż dwie referencje w swoim zapytaniu, czego nie możesz osiągnąć przy pomocy składni z dwiema kropkami. Dla przykładu, jeżeli chcesz zobaczyć zmiany które są dostępne z `refA` lub `refB`, ale nie z `refC`, możesz użyć:

<!-- This is nice because with this syntax you can specify more than two references in your query, which you cannot do with the double-dot syntax. For instance, if you want to see all commits that are reachable from `refA` or `refB` but not from `refC`, you can type one of these: -->

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Tworzy to bardzo użyteczną składnię zapytań, która powinna Ci pomóc dowiedzieć się, co jest w Twoich gałęziach.

<!-- This makes for a very powerful revision query system that should help you figure out what is in your branches. -->

#### Potrójna kropka ####

<!-- #### Triple Dot #### -->

Ostatnią z głównych składni zakresu jest składnia z trzema kropkami, która wskazuje na wszystkie zmiany które są dostępne z jednej z dwóch referencji, ale nie z obu. Spójrz ponownie na przykład z historią zmian na rysunku 6-1. 
Jeżeli chcesz zobaczyć co jest zmienione w `master` lub `experiment`, poza wspólnymi, możesz uruchomić

<!-- The last major range-selection syntax is the triple-dot syntax, which specifies all the commits that are reachable by either of two references but not by both of them. Look back at the example commit history in Figure 6-1.
If you want to see what is in `master` or `experiment` but not any common references, you can run -->

	$ git log master...experiment
	F
	E
	D
	C

Ponownie, otrzymasz normalny wynik `log`, ale pokazujący tylko informacje o czterech zmianach, występujących w normalnej kolejności.

<!-- Again, this gives you normal `log` output but shows you only the commit information for those four commits, appearing in the traditional commit date ordering. -->

Często używaną opcją do komendy `log` jest `--left-right`, która pokazuje po której stronie każda zmiana występuje. Pozwala to na uzyskanie użyteczniejszych informacji:

<!-- A common switch to use with the `log` command in this case is `-\-left-right`, which shows you which side of the range each commit is in. This helps make the data more useful: -->

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Przy pomocy tych narzędzi, możesz dużo łatwiej wskazać którą zmianę lub zmiany chcesz zobaczyć.

<!-- With these tools, you can much more easily let Git know what commit or commits you want to inspect. -->

## Interaktywne używanie przechowali ##

<!-- ## Interactive Staging ## -->

Git dostarcza kilku skryptów, które ułatwiają wykonywanie zadań z linii poleceń. Zobaczysz tutaj parę interaktywnych komend, które pomogą Ci z łatwością dopracować commity, aby zawierały tylko pewnie kombinacje i części plików. Narzędzia te są bardzo przydatne w sytuacji, gdy zmieniasz kilka plików i następnie decydujesz, że chciałbyś, aby te zmiany były w kilku mniejszych commitach, zamiast w jednym dużym. W ten sposób możesz mieć pewność, że Twoje commity są logicznie oddzielnymi zestawami zmian i mogą być łatwiej zweryfikowane przez innych programistów pracujących z Tobą.
Jeżeli uruchomisz `git add` z opcją `-i` lub `-interactive`, Git wejdzie w tryb interaktywny, pokazując coś podobnego do:

<!-- Git comes with a couple of scripts that make some command-line tasks easier. Here, you’ll look at a few interactive commands that can help you easily craft your commits to include only certain combinations and parts of files. These tools are very helpful if you modify a bunch of files and then decide that you want those changes to be in several focused commits rather than one big messy commit. This way, you can make sure your commits are logically separate changesets and can be easily reviewed by the developers working with you.
If you run `git add` with the `-i` or `-\-interactive` option, Git goes into an interactive shell mode, displaying something like this: -->

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

Możesz zauważyć, że ta komenda pokazuje zupełnie inny obraz przechowalni - właściwie są to te same informacje które możesz otrzymać przy pomocy `git status`, ale w bardziej zwięzłej formie. Listuje ona zmiany które dodałeś do przechowalni po lewej stronie, oraz te które nie są w niej jeszcze po prawej.

<!-- You can see that this command shows you a much different view of your staging area — basically the same information you get with `git status` but a bit more succinct and informative. It lists the changes you’ve staged on the left and unstaged changes on the right. -->

Po nich pokazana jest sekcja komend. Możesz w niej zrobić kilka rzeczy takich jak dodanie plików do przechowalni, usunięcie z niej, dodanie do przechowalni części plików, dodanie nieśledzonych plików, czy otrzymanie różnicy między tym co jest w przechowalni.

<!-- After this comes a Commands section. Here you can do a number of things, including staging files, unstaging files, staging parts of files, adding untracked files, and seeing diffs of what has been staged. -->

### Dodawanie i usuwanie plików z przechowalni ###

<!-- ### Staging and Unstaging Files ### -->

Jeżeli naciśniesz `2` lub `u` w linii `What now>`, skrypt dopyta Cię o to, które pliki chcesz dodać do przechowalni:

<!-- If you type `2` or `u` at the `What now>` prompt, the script prompts you for which files you want to stage: -->

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Aby dodać pliki TODO i index.html do przechowalni, możesz wpisać numery: 

<!-- To stage the TODO and index.html files, you can type the numbers: -->

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Znak `*` obok każdego pliku, oznacza że plik ten będzie dodany do przechowalni. Jeżeli naciśniesz Enter, bez wpisywania niczego w `Update>>`, Git weźmie wszystkie zaznaczone pliki i doda je do przechowalni:

<!-- The `*` next to each file means the file is selected to be staged. If you press Enter after typing nothing at the `Update>>` prompt, Git takes anything selected and stages it for you: -->

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

Teraz możesz zauważyć, że pliki TODO i index.html są w przechowalni, a plik simplegit.rb nie. Jeżeli chcesz usunąć plik TODO z przechowalni, musisz użyć opcji `3` lub `r` (cofnij, od ang. revert):

<!-- Now you can see that the TODO and index.html files are staged and the simplegit.rb file is still unstaged. If you want to unstage the TODO file at this point, you use the `3` or `r` (for revert) option: -->

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


Spójrz ponownie na status Gita, zobaczysz teraz, że usunąłeś z poczekalni plik TODO:

<!-- Looking at your Git status again, you can see that you’ve unstaged the TODO file: -->

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Aby zobaczyć porównanie tego co jest w przechowalni, możesz użyć komendy `6` lub `d` (ang. diff). Pokaże ona listę plików, które możesz wybrać aby zobaczyć wprowadzone zmiany. Jest to podobne do działania komendy `git diff --cached`:

<!-- To see the diff of what you’ve staged, you can use the `6` or `d` (for diff) command. It shows you a list of your staged files, and you can select the ones for which you would like to see the staged diff. This is much like specifying `git diff -\-cached` on the command line: -->

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

Przy użyciu tych prostych komend, możesz używać trybu interaktywnego do łatwiejszej obsługi przechowalni.

<!-- With these basic commands, you can use the interactive add mode to deal with your staging area a little more easily. -->

### Dodawanie łat do przechowalni ###

<!-- ### Staging Patches ### -->

Dla Gita możliwe jest również, aby dodać do przechowalni tylko część plików, a nie całość. Na przykład, jeżeli zrobisz dwie zmiany w swoim pliku simplegit.rb, ale chcesz dodać do przechowalni tylko jedną z nich, a drugą nie. Z interaktywnej linii poleceń, wybierz `5` lub `p` (ang. patch). Git zapyta Cię, które pliki chciałbyś tylko w części dodać do przechowalni; następnie dla każdego zaznaczonego pliku, wyświetli kawałek różnicy na plikach i zapyta czy chcesz je dodać do przechowalni po kolei: 

<!-- It’s also possible for Git to stage certain parts of files and not the rest. For example, if you make two changes to your simplegit.rb file and want to stage one of them and not the other, doing so is very easy in Git. From the interactive prompt, type `5` or `p` (for patch). Git will ask you which files you would like to partially stage; then, for each section of the selected files, it will display hunks of the file diff and ask if you would like to stage them, one by one: -->

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

Masz teraz dużą ilość opcji. Pisząc `?` otrzymasz listę rzeczy które możesz zrobić:

<!-- You have a lot of options at this point. Typing `?` shows a list of what you can do: -->

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

Zazwyczaj, będziesz wybierał `y` lub `n` jeżeli chcesz dodać do przechowalni dany kawałek, ale zapisanie wszystkich które chcesz dodać do przechowalni w plikach, lub pominięcie decyzji również może być przydatne. Jeżeli dodasz część pliku do przechowalni, a pozostałej części nie, wynik komendy status będzie podobny do:

<!-- Generally, you’ll type `y` or `n` if you want to stage each hunk, but staging all of them in certain files or skipping a hunk decision until later can be helpful too. If you stage one part of the file and leave another part unstaged, your status output will look like this: -->

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

Wynik komendy status dla pliku simplegit.rb jest interesujący. Pokazuje on, że kilka linii jest dodanych do przechowalni, a kilka nie. Masz plik, który jest tylko w części w przechowalni. W tym momencie, możesz zakończyć działanie trybu interaktywnego i uruchomić `git commit` w celu zatwierdzenia zmian.

<!-- The status of the simplegit.rb file is interesting. It shows you that a couple of lines are staged and a couple are unstaged. You’ve partially staged this file. At this point, you can exit the interactive adding script and run `git commit` to commit the partially staged files. -->

Wreszcie, nie musisz być w trybie interaktywnym aby dodać część pliku do przechowalni - możesz wywołać to samo menu, poprzez uruchomienie `git add -p` lub `git add --patch` z linii komend.

<!-- Finally, you don’t need to be in interactive add mode to do the partial-file staging — you can start the same script by using `git add -p` or `git add -\-patch` on the command line. -->

## Schowek ##

<!-- ## Stashing ## -->

Często, gdy pracujesz nad jakąś częścią swojego projektu i są w nim wprowadzone zmiany, chciałbyś przełączyć się na inną gałąź, aby popracować nad inną funkcjonalnością. Problem w tym, że nie chcesz commitować zmian które są tylko częściowo wprowadzone, tylko po to abyś mógł do nich wrócić później. Rozwiązaniem tego problemu jest komenda `git stash`. 

<!-- Often, when you’ve been working on part of your project, things are in a messy state and you want to switch branches for a bit to work on something else. The problem is, you don’t want to do a commit of half-done work just so you can get back to this point later. The answer to this issue is the `git stash` command. -->

Podczas dodawania do schowka, pobrane zostaną zmiany które są w obecnym katalogu - czyli pliki które są śledzone i zostały zmodyfikowane oraz dodane do przechowalni - i zapisane zostaną w nim, tak aby mogły być ponownie użyte w dowolnym momencie.

<!-- Stashing takes the dirty state of your working directory — that is, your modified tracked files and staged changes — and saves it on a stack of unfinished changes that you can reapply at any time. -->


### Zapisywanie Twojej pracy w schowku ###

<!-- ### Stashing Your Work ### -->

W celu zaprezentowania jak to działa, w projekcie nad którym obecnie pracujesz, wprowadzisz zmiany w kilku plikach i dodasz jeden z nich do przechowalni. Jeżeli uruchomisz komendę `git status`, zobaczysz następujący wynik:

<!-- To demonstrate, you’ll go into your project and start working on a couple of files and possibly stage one of the changes. If you run `git status`, you can see your dirty state: -->

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

Teraz chcesz zmienić gałęzie, ale nie chcesz commitować tego nad czym pracowałeś do tej pory, więc dodasz te zmiany do przechowalni. Aby zapisać je w przechowalni, uruchom `git stash`:

<!-- Now you want to switch branches, but you don’t want to commit what you’ve been working on yet; so you’ll stash the changes. To push a new stash onto your stack, run `git stash`: -->

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Twój katalog roboczy jest teraz w stanie niezmienionym:

<!-- Your working directory is clean: -->

	$ git status
	# On branch master
	nothing to commit, working directory clean

W tej chwili, możesz bez problemu przejść na inną gałąź i rozpocząć pracę nad innymi zmianami; Twoje poprzednie modyfikacje zapisane są w przechowalni. Aby zobaczyć listę zapisanych zmian w przechowalni, użyj komendy `git stash list`: 

<!-- At this point, you can easily switch branches and do work elsewhere; your changes are stored on your stack. To see which stashes you’ve stored, you can use `git stash list`: -->

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

W powyższym przykładzie, dwie poprzednie zmiany również zostały zapisane, masz więc dostęp do łącznie trzech. Możesz ponownie nałożyć tą którą ostatnio stworzyłeś, przy użyciu komendy widocznej w tekście pomocy do komendy stash: `git stash apply`. Jeżeli chcesz nałożyć jedną ze starszych zmian, wskazujesz ją poprzez nazwę w taki sposób: `git stash apply stash@{2}`. Jeżeli nie podasz nazwy, Git założy najnowszą i spróbuje ją zintegrować:

<!-- In this case, two stashes were done previously, so you have access to three different stashed works. You can reapply the one you just stashed by using the command shown in the help output of the original stash command: `git stash apply`. If you want to apply one of the older stashes, you can specify it by naming it, like this: `git stash apply stash@{2}`. If you don’t specify a stash, Git assumes the most recent stash and tries to apply it: -->

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Możesz zauważyć, że Git zmodyfikował pliki które nie były zatwierdzone w czasie zapisywania w schowku. W tej sytuacji, miałeś niezmodyfikowany katalog roboczy, w chwili, gdy próbowałeś zaaplikować zmiany ze schowka na tą samą gałąź na której je stworzyłeś; jednak nie musisz mieć niezmodyfikowanego katalogu, ani nie musisz pracować na tej samej gałęzi, aby poprawnie zaaplikować zmiany ze schowka. Możesz zapisać w ten sposób zmiany w jednej gałęzi, zmienić gałąź na inną i spróbować nałożyć je. Możesz również mieć wprowadzone zmiany i zmodyfikowane pliki w czasie, gdy będziesz próbował nałożyć zmiany - Git pozwoli Ci na rozwiązanie ewentualnych konfliktów, jeżeli zmiany nie będą mogły się czysto połączyć.

<!-- You can see that Git re-modifies the files you uncommitted when you saved the stash. In this case, you had a clean working directory when you tried to apply the stash, and you tried to apply it on the same branch you saved it from; but having a clean working directory and applying it on the same branch aren’t necessary to successfully apply a stash. You can save a stash on one branch, switch to another branch later, and try to reapply the changes. You can also have modified and uncommitted files in your working directory when you apply a stash — Git gives you merge conflicts if anything no longer applies cleanly. -->

Zmiany na Twoich plikach zostały ponownie nałożone, ale plik który poprzednio był w przechowalni, teraz nie jest. Aby go dodać, musisz uruchomić `git stash apply` z parametrem `--index`, w celu ponownego dodania zmian do przechowalni. Jeżeli uruchomiłeś ją, otrzymasz w wyniku oryginalny stan:

<!-- The changes to your files were reapplied, but the file you staged before wasn’t restaged. To do that, you must run the `git stash apply` command with a `-\-index` option to tell the command to try to reapply the staged changes. If you had run that instead, you’d have gotten back to your original position: -->

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

Opcja "apply" próbuje tylko zintegrować zapisane zmiany - będziesz nadal miał je na liście zmian w schowku. Aby je usunąć, uruchom `git stash drop` z nazwą zmiany którą chcesz usunąć:

<!-- The apply option only tries to apply the stashed work — you continue to have it on your stack. To remove it, you can run `git stash drop` with the name of the stash to remove: -->

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Możesz również uruchomić `git stash pop`, aby nałożyć ostatnio zapisane zmiany ze schowka, a następnie usunąć je z listy zmian.

<!-- You can also run `git stash pop` to apply the stash and then immediately drop it from your stack. -->

### Cofanie zmian nałożonych ze schowka ###

<!-- ### Un-applying a Stash ### -->

Może się zdarzyć sytuacja, w której nałożysz zmiany ze schowka, wprowadzisz jakieś inne zmiany, aby potem zechcesz cofnąć zmiany które zostały wprowadzone ze schowka. Git nie udostępnia komendy `git unapply`, ale można to osiągnąć poprzez pobranie wprowadzonych zmian i nałożenie ich w od tyłu:

<!-- In some use case scenarios you might want to apply stashed changes, do some work, but then un-apply those changes that originally came from the stash. Git does not provide such a `stash unapply` command, but it is possible to achieve the effect by simply retrieving the patch associated with a stash and applying it in reverse: -->

    $ git stash show -p stash@{0} | git apply -R

Ponownie, jeżeli nie wskażesz schowka, Git założy najnowszy:

<!-- Again, if you don’t specify a stash, Git assumes the most recent stash: -->

    $ git stash show -p | git apply -R

Możesz chcieć stworzyć alias i dodać komendę `stash-unapply` do Gita. Na przykład tak:

<!-- You may want to create an alias and effectively add a `stash-unapply` command to your git. For example: -->

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply


### Tworzenie gałęzi ze schowka ###

<!-- ### Creating a Branch from a Stash ### -->

Jeżeli zapiszesz w schowku zmiany, zostawisz je na jakiś czas i będziesz kontynuował pracę na tej samej gałęzi, możesz napotkać problem z ich ponownym nałożeniem. Jeżeli nakładane zmiany, będą dotyczyły plików które zdążyłeś zmienić dojdzie do konfliktu, który będziesz musiał ręcznie rozwiązać. Jeżeli chcesz poznać łatwiejszy sposób na sprawdzenie zmian ze schowka, uruchom `git stash branch`, komenda ta stworzy nową gałąź, pobierze ostatnią wersję plików, nałoży zmiany ze schowka, oraz usunie zapisany schowek jeżeli wszystko odbędzie się bez problemów:

<!-- If you stash some work, leave it there for a while, and continue on the branch from which you stashed the work, you may have a problem reapplying the work. If the apply tries to modify a file that you’ve since modified, you’ll get a merge conflict and will have to try to resolve it. If you want an easier way to test the stashed changes again, you can run `git stash branch`, which creates a new branch for you, checks out the commit you were on when you stashed your work, reapplies your work there, and then drops the stash if it applies successfully: -->

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

Jest to bardzo pomocny skrót do odzyskiwania zapisanych w schowku zmian i kontynuowania pracy w nowej gałęzi.

<!-- This is a nice shortcut to recover stashed work easily and work on it in a new branch. -->


## Przepisywanie Historii ##

<!-- ## Rewriting History ## -->

Często, pracując z Gitem możesz chcieć zmienić historię commitów z jakiegoś powodu. Jedną z najlepszych rzeczy w Gitcie jest to, że pozwala on podejmować decyzję w ostatnim możliwym momencie. Możesz zdecydować które pliki idą w których commitach, dokładnie przed commitem przy użyciu przechowalni, możesz zdecydować że nie chciałeś nad czymś teraz pracować przy pomocy schowka, możesz również nadpisać commity które już wprowadziłeś, tak aby wyglądały inaczej. Możesz w ten sposób zmienić kolejność commitów, treść komentarza lub zawartość plików, złączyć lub rozdzielić commity, lub je w całości usunąć - wszystko zanim podzielisz się swoją pracą z innymi.

<!-- Many times, when working with Git, you may want to revise your commit history for some reason. One of the great things about Git is that it allows you to make decisions at the last possible moment. You can decide what files go into which commits right before you commit with the staging area, you can decide that you didn’t mean to be working on something yet with the stash command, and you can rewrite commits that already happened so they look like they happened in a different way. This can involve changing the order of the commits, changing messages or modifying files in a commit, squashing together or splitting apart commits, or removing commits entirely — all before you share your work with others. -->

W tej sekcji, dowiesz się jak wykonać te zadania, tak abyś mógł zorganizować historię commitów w taki sposób w jaki chcesz, przed podzieleniem się tymi zmianami z innymi.

<!-- In this section, you’ll cover how to accomplish these very useful tasks so that you can make your commit history look the way you want before you share it with others. -->

### Zmienianie ostatniego commita ###

<!-- ### Changing the Last Commit ### -->

Zmienianie ostatniego commita jest chyba najczęstszą rzeczą którą będziesz robił. Często chcesz zrobić jedną z dwóch rzeczy: zmienić treść komentarza, lub zawartość migawki którą właśnie stworzyłeś, poprzez dodanie, zmianę lub usunięcie plików.

<!-- Changing your last commit is probably the most common rewriting of history that you’ll do. You’ll often want to do two basic things to your last commit: change the commit message, or change the snapshot you just recorded by adding, changing and removing files. -->

Jeżeli chcesz zmienić tylko treść ostatniego komentarza, najprościej wykonać:

<!-- If you only want to modify your last commit message, it’s very simple: -->

	$ git commit --amend

Ta komenda uruchomi edytor tekstowy, który będzie zawierał Twój ostatni komentarz gotowy do wprowadzenia zmian. Kiedy zapiszesz i zamkniesz edytor, nowy tekst komentarza nadpisze poprzedni, stając się tym samym Twoim nowym ostatnim commitem.

<!-- That drops you into your text editor, which has your last commit message in it, ready for you to modify the message. When you save and close the editor, the editor writes a new commit containing that message and makes it your new last commit. -->

Jeżeli wykonałeś komendę "commit", a potem chcesz zmienić ostatnio zapisaną migawkę przez dodanie lub zmianę plików, być może dlatego że zapomniałeś dodać plik który stworzyłeś, cały proces działa bardzo podobnie. Dodajesz do przechowalni zmiany lub pliki poprzez wykonanie komendy `git add` na nich, lub `git rm` na jakimś pliku, a następnie uruchamiasz komendę `git commit --ammend`, która pobiera obecną zawartość przechowalni i robi z niej nową migawkę do commitu.

<!-- If you’ve committed and then you want to change the snapshot you committed by adding or changing files, possibly because you forgot to add a newly created file when you originally committed, the process works basically the same way. You stage the changes you want by editing a file and running `git add` on it or `git rm` to a tracked file, and the subsequent `git commit -\-amend` takes your current staging area and makes it the snapshot for the new commit. -->

Musisz być ostrożny z tymi zmianami, ponieważ wykonywanie komendy "ammend", zmienia sumę SHA-1 dla commitu. Działa to podobnie do bardzo małej zmiany bazy (and. rebase) - nie wykonuj komendy "amend" na ostatnim commicie, jeżeli zdążyłeś go już udostępnić innym.

<!-- You need to be careful with this technique because amending changes the SHA-1 of the commit. It’s like a very small rebase — don’t amend your last commit if you’ve already pushed it. -->

### Zmiana kilku komentarzy jednocześnie ###

<!-- ### Changing Multiple Commit Messages ### -->

Aby zmienić zapisaną zmianę która jest głębiej w historii, musisz użyć bardziej zaawansowanych narzędzi. Git nie posiada narzędzia do modyfikowania historii, ale możesz użyć komendy "rebase", aby zmienić bazę kilku commitów do HEAD z których się wywodzą, zamiast przenosić je do innej. Przy pomocy interaktywnej komendy rebase, możesz zatrzymać się przy każdym commicie przeznaczonym do zmiany i zmienić treść komentarza, dodać pliki, lub cokolwiek zechcesz. Możesz uruchomić komendę "rebase" w trybie interaktywnym poprzez dodanie opcji `-i` do `git rebase`. Musisz wskazać jak daleko chcesz nadpisać zmiany, poprzez wskazanie do którego commitu zmienić bazę.

<!-- To modify a commit that is farther back in your history, you must move to more complex tools. Git doesn’t have a modify-history tool, but you can use the rebase tool to rebase a series of commits onto the HEAD they were originally based on instead of moving them to another one. With the interactive rebase tool, you can then stop after each commit you want to modify and change the message, add files, or do whatever you wish. You can run rebase interactively by adding the `-i` option to `git rebase`. You must indicate how far back you want to rewrite commits by telling the command which commit to rebase onto. -->

Na przykład, jeżeli chcesz zmienić 3 ostatnie komentarze, albo jakikolwiek z nich, podajesz jako argument do komendy `git rebase -i` rodzica ostatniego commita który chcesz zmienić, np. `HEAD~2^` lub `HEAD~3`. Łatwiejsze do zapamiętania może być `~3`, ponieważ próbujesz zmienić ostatnie trzy commity; ale zwróć uwagę na to, że tak naprawdę określiłeś cztery ostatnie commity, rodzica ostatniej zmiany którą chcesz zmienić: 

<!--  For example, if you want to change the last three commit messages, or any of the commit messages in that group, you supply as an argument to `git rebase -i` the parent of the last commit you want to edit, which is `HEAD~2^` or `HEAD~3`. It may be easier to remember the `~3` because you’re trying to edit the last three commits; but keep in mind that you’re actually designating four commits ago, the parent of the last commit you want to edit: -->

	$ git rebase -i HEAD~3

Postaraj się zapamiętać, że jest to komenda zmiany bazy - każdy commit znajdujący się w zakresie `HEAD~3..HEAD` będzie przepisany, bez względu na to, czy zmienisz treść komentarza czy nie. Nie zawieraj commitów które zdążyłeś już wgrać na centralny serwer - takie działanie będzie powodowało zamieszanie dla innych programistów, poprzez dostarczenie alternatywnej wersji tej samej zmiany.

<!-- Remember again that this is a rebasing command — every commit included in the range `HEAD~3..HEAD` will be rewritten, whether you change the message or not. Don’t include any commit you’ve already pushed to a central server — doing so will confuse other developers by providing an alternate version of the same change. -->

Uruchomienie tej komendy da Ci listę commitów w edytorze tekstowym, podobną do tej:

<!-- Running this command gives you a list of commits in your text editor that looks something like this: -->

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Warto zaznaczyć, że te zmiany są wypisane w odwrotnej kolejności, w stosunku do tej, którą widzisz po wydaniu komendy `log`. Jeżeli uruchomisz `log`, zobaczysz coś podobnego do:

<!-- It’s important to note that these commits are listed in the opposite order than you normally see them using the `log` command. If you run a `log`, you see something like this: -->

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Zauważ odwrotną kolejność. Interaktywny tryb "rebase" udostępnia Ci skrypt który będzie uruchamiany. Rozpocznie on działanie od zmiany, którą wskazałeś w linii komend (`HEAD~3`) i odtworzy zmiany wprowadzanie przez każdy z commitów od góry do dołu. Listuje najstarszy na górze, zamiast najnowszego, ponieważ będzie to pierwszy który zostanie odtworzony. 

<!-- Notice the reverse order. The interactive rebase gives you a script that it’s going to run. It will start at the commit you specify on the command line (`HEAD~3`) and replay the changes introduced in each of these commits from top to bottom. It lists the oldest at the top, rather than the newest, because that’s the first one it will replay. -->

Trzeba zmienić skrypt, aby ten zatrzymał się na zmianie którą chcesz wyedytować. Aby to zrobić, zmień słowo "pick" na "edit" przy każdym commicie po którym skrypt ma się zatrzymać. Dla przykładu, aby zmienić tylko trzecią treść komentarza, zmieniasz plik aby wygląda tak jak ten:

<!-- You need to edit the script so that it stops at the commit you want to edit. To do so, change the word pick to the word edit for each of the commits you want the script to stop after. For example, to modify only the third commit message, you change the file to look like this: -->

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Kiedy zapiszesz zmiany i wyjdziesz z edytora, Git cofnie Cię do ostatniego commita w liście i pokaże linię komend z następującym komunikatem:

<!-- When you save and exit the editor, Git rewinds you back to the last commit in that list and drops you on the command line with the following message: -->

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Te instrukcje mówią dokładnie co zrobić. Napisz

<!-- These instructions tell you exactly what to do. Type -->

	$ git commit --amend

Zmień treść komentarza i zamknij edytor. Następnie uruchom

<!-- Change the commit message, and exit the editor. Then, run -->

	$ git rebase --continue

Ta komenda nałoży dwie pozostałe zmiany automatycznie i po wszystkim. Jeżeli zmienisz "pick" na "edit" w większej liczbie linii, możesz powtórzyć te kroki dla każdego commita który zmieniasz. Za każdym razem Git zatrzyma się, pozwoli Ci nadpisać treść za pomocą komendy "amend" i przejdzie dalej jak skończysz.

<!-- This command will apply the other two commits automatically, and then you’re done. If you change pick to edit on more lines, you can repeat these steps for each commit you change to edit. Each time, Git will stop, let you amend the commit, and continue when you’re finished. -->

### Zmiana kolejności commitów ###

<!-- ### Reordering Commits ### -->

Możesz również użyć interaktywnego trybu "rebase" aby zmienić kolejność lub usunąć commity w całości. Jeżeli chcesz usunąć zmianę opisaną jako "added cat-file", oraz zmienić kolejność w jakiej pozostałe dwie zmiany zostały wprowadzone, możesz zmienić zawartość skryptu rebase z takiego

<!-- You can also use interactive rebases to reorder or remove commits entirely. If you want to remove the "added cat-file" commit and change the order in which the other two commits are introduced, you can change the rebase script from this -->

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

na taki:

<!-- to this: -->

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Kiedy zapiszesz zmiany i wyjdziesz z edytora, Git cofnie gałąź do rodzica tych commitów, nałoży `310154e` i potem `f7f3f6d`, a następnie się zatrzyma. W efekcie zmieniłeś kolejność tych commitów i usunąłeś "added cat-file" kompletnie.

<!-- When you save and exit the editor, Git rewinds your branch to the parent of these commits, applies `310154e` and then `f7f3f6d`, and then stops. You effectively change the order of those commits and remove the "added cat-file" commit completely. -->

### Łączenie commitów ###

<!-- ### Squashing Commits ### -->

Możliwe jest również pobranie kilku commitów i połączenie ich w jeden za pomocą interaktywnego trybu rebase. Skrypt ten pokazuje pomocne instrukcje w treści rebase:

<!-- It’s also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool. The script puts helpful instructions in the rebase message:-->

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Jeżeli zamiast "pick" lub "edit", użyjesz "squash", Git nałoży obie te zmiany i tą znajdującą się przed nimi, i pozwoli Ci na scalenie treści komentarzy ze sobą. Więc, jeżeli chcesz zrobić jeden commit z tych trzech, robisz skrypt wyglądający tak jak ten:

<!-- If, instead of "pick" or "edit", you specify "squash", Git applies both that change and the change directly before it and makes you merge the commit messages together. So, if you want to make a single commit from these three commits, you make the script look like this: -->

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Kiedy zapiszesz zmiany i opuścisz edytor, Git nałoży wszystkie trzy i przejdzie ponownie do edytora, tak abyś mógł połączyć treści komentarzy:

<!-- When you save and exit the editor, Git applies all three changes and then puts you back into the editor to merge the three commit messages: -->

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Kiedy to zapiszesz, otrzymasz jeden commit, który wprowadza zmiany ze wszystkich trzech poprzednich.

<!-- When you save that, you have a single commit that introduces the changes of all three previous commits. -->

### Rozdzielanie commitów ###

<!-- ### Splitting a Commit ### -->

Rozdzielanie commitu cofa jego nałożenie, a następnie część po części dodaje do przechowalni i commituje, tyle razy ile chcesz otrzymać commitów. Na przykład, załóżmy że chcesz podzielić środkową zmianę ze swoich trzech. Zamiast zmiany "updated README formatting and added blame", chcesz otrzymać dwie: "updated README formatting" dla pierwszego, oraz "added blame" dla drugiego. Możesz to zrobić za pomocą komendy `rebase -i` i skryptu w którym zmienisz instrukcję przy commicie na "edit":

<!-- Splitting a commit undoes a commit and then partially stages and commits as many times as commits you want to end up with. For example, suppose you want to split the middle commit of your three commits. Instead of "updated README formatting and added blame", you want to split it into two commits: "updated README formatting" for the first, and "added blame" for the second. You can do that in the `rebase -i` script by changing the instruction on the commit you want to split to "edit": -->

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Kiedy zapiszesz zmiany i wyjdziesz z edytora, Git cofnie się do rodzica pierwszego commita z listy, nałoży pierwszą zmianę (`f7f3f6d`), nałoży kolejną (`310154e`) i uruchomi konsolę. Tam możesz zrobić "reset" na kolejnym commicie za pomocą `git reset HEAD^`, co w efekcie cofnie zmiany i zostawi zmodyfikowane pliki poza przechowalnią. Teraz możesz wskazać zmiany które zostały zresetowane i utworzyć kilka osobnych commitów z nich. Po prostu dodaj do przechowalni i zapisz zmiany, do czasu aż będziesz miał kilka commitów, a następnie uruchom `git rebase --continue` gdy skończysz:

<!-- When you save and exit the editor, Git rewinds to the parent of the first commit in your list, applies the first commit (`f7f3f6d`), applies the second (`310154e`), and drops you to the console. There, you can do a mixed reset of that commit with `git reset HEAD^`, which effectively undoes that commit and leaves the modified files unstaged. Now you can take the changes that have been reset, and create multiple commits out of them. Simply stage and commit files until you have several commits, and run `git rebase -\-continue` when you’re done: -->

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git nałoży ostatnią zmianę w skrypcie (`a5f4a0d`), a historia będzie wyglądała tak:

<!-- Git applies the last commit (`a5f4a0d`) in the script, and your history looks like this: -->

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Ponownie warto zaznaczyć, że ta operacja zmienia sumy SHA wszystkich commitów z listy, upewnij się więc, że żadnego z tych commitów nie wypchnąłeś i nie udostępniłeś w wspólnym repozytorium.

<!-- Once again, this changes the SHAs of all the commits in your list, so make sure no commit shows up in that list that you’ve already pushed to a shared repository. -->

### Zabójcza opcja: filter-branch ###

<!-- ### The Nuclear Option: filter-branch ### -->

Istnieje jeszcze jedna opcja umożliwiająca nadpisanie historii, której możesz użyć, gdy chcesz nadpisać większą liczbę commitów w sposób który można oprogramować - przykładem tego może być zmiana Twojego adresu e-mail lub usunięcie pliku z każdego commita. Komenda ta to `filter-branch` i może ona zmodyfikować duże części Twojej historii, nie powinieneś jej prawdopodobnie używać, chyba że Twój projekt nie jest publiczny i inne osoby nie mają zmian bazujących na commitach które zamierzasz zmienić. Może oba być jednak przydatna. Nauczysz się kilku częstych przypadków użycia i zobaczysz co może ta komenda. 

<!-- There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit. The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite. However, it can be very useful. You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of. -->

#### Usuwanie pliku z każdego commita ####

<!-- #### Removing a File from Every Commit #### -->

To często występująca sytuacja. Ktoś niechcący zapisać duży plik za pomocą pochopnie wydanej komendy `git add .`, a Ty chcesz usunąć ten plik z każdego commita. Być może przez pomyłkę zapisałeś plik zawierający hasła, a chcesz upublicznić swój projekt. Komenda `filter-branch` jest tą, którą prawdopodobnie będziesz chciał użyć, aby obrobić całą historię zmian. Aby usunąć plik nazywający się paddwords.txt z całej Twojej historii w projekcie, możesz użyć opcji `--tree-filter` dodanej do `filter-branch`:

<!-- This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your project open source. `filter-branch` is the tool you probably want to use to scrub your entire history. To remove a file named passwords.txt from your entire history, you can use the `-\-tree-filter` option to `filter-branch`: -->

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

Opcja `--tree-filter` umożliwia wykonanie jakiejś komendy po każdej zmianie i następnie ponownie zapisuje wynik. W tym przypadku, usuwasz plik passwords.txt z każdej migawki, bez względu na to czy on istnieje czy nie. Jeżeli chcesz usunąć wszystkie niechcący dodane kopie zapasowe plików stworzone przez edytor, możesz uruchomić coś podobnego do `git filter-branch --tree-filter "find * -type f -name '*~' -delete" HEAD`.

<!-- The `-\-tree-filter` option runs the specified command after each checkout of the project and then recommits the results. In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch -\-tree-filter "rm -f *~" HEAD`. -->

Będziesz mógł obserwować jak Git nadpisuje strukturę projektu i zmiany, a następnie przesuwa wskaźnik gałęzi. Jest to generalnie całkiem dobrym pomysłem, aby wykonać to na testowej gałęzi, a następnie zresetować na twardo (ang. hard reset) gałąź master, po tym jak stwierdzisz że wynik jest tym czego oczekiwałeś. Aby uruchomić `filter-branch` an wszystkich gałęziach, dodajesz opcję `--all`.

<!-- You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end. It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want. To run `filter-branch` on all your branches, you can pass `-\-all` to the command. -->

#### Wskazywanie podkatalogu jako katalogu głównego ####

<!-- #### Making a Subdirectory the New Root #### -->

Założymy że zaimportowałeś projekt z innego systemu kontroli wersji, zawierającego niepotrzebne podkatalogu (trunk, tags, itd). Jeżeli chcesz, aby katalog `trunk` był nowym głównym katalogiem dla wszystkich commitów, komenda `filter-branch` również to umożliwi:

<!-- Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on). If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too: -->

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Teraz Twoim nowym katalogiem głównym w projekcie, jest to, na co wskazywał podkatalog `trunk`. Git również automatycznie usunie commity, które nie dotyczyły podkatalogu.

<!-- Now your new project root is what was in the `trunk` subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory. -->

#### Zmienianie adresu e-mail globalnie ####

<!-- #### Changing E-Mail Addresses Globally #### -->

Innym częstym przypadkiem jest ten, w którym zapomniałeś uruchomić `git config` aby ustawić imię i adres e-mail przed rozpoczęciem prac, lub chcesz udostępnić projekt jako open-source i zmienić swój adres e-mail na adres prywatny. W każdym przypadku, możesz zmienić adres e-mail w wielu commitach również za pomocą `filter-branch`. Musisz uważać, aby zmienić adresy e-mail które należą do Ciebie, użyjesz więc `--commit-filter`:

<!-- Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address. In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well. You need to be careful to change only the e-mail addresses that are yours, so you use `-\-commit-filter`: -->

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

To obrobi i nadpisze każdy commit, aby zawierał Twój nowy adres. Ze względu na to, że commity zawierają sumę SHA-1 swoich rodziców, ta komenda zmieni wszystkie sumy SHA-1 dla commitów z historii, a nie tylko tych które zawierały zmieniany adres.

<!-- This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address. -->

## Debugowanie z Gitem ##

<!-- ## Debugging with Git ## -->

Git udostępnia również kilka narzędzi, które pomogą Ci znaleźć przyczyny problemów w projekcie. Ponieważ Git został zaprojektowany do działania z projektami niemal każdej wielkości, te narzędzia są całkiem podstawowe, ale często pomogą Ci znaleźć błąd, lub sprawcę kiedy sprawy nie idą po Twojej myśli. 

<!-- Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong. -->

### Adnotacje plików ###

<!-- ### File Annotation ### -->

Jeżeli namierzasz błąd w swoim kodzie i chcesz wiedzieć kiedy został on wprowadzony i z jakiego powodu, adnotacje do plików są często najlepszym z narzędzi. Pokazuje ona który commit był tym który jako ostatni modyfikował dany każdą z linii w pliku. Jeżeli więc, zobaczysz że jakaś metoda w Twoim kodzie jest błędna, możesz zobaczyć adnotacje związane z tym plikiem za pomocą `git blame` i otrzymać wynik z listą osób które jako ostatnie modyfikowały daną linię. Ten przykład używa opcji `-L`, aby ograniczyć wynik do linii od 12 do 22:

<!-- If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22: -->

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

Zauważ, że pierwszym polem jest częściowa suma SHA-1 commitu który jako ostatni modyfikował daną linię. Następne dwie wartości zostały pobrane z commita - nazwa autora i data - możesz więc z łatwością zobaczyć kto i kiedy modyfikował daną linię. Po tym pokazany jest numer linii i zawartość pliku. Zauważ również że commit `^4832fe2` oznacza linie które były w pierwotnym pliku. Ten commit to ten, który dodał jako pierwszy ten plik do projektu, a te linie nie zostały zmienione od tego czasu. Jest to troszkę mylące, ponieważ do teraz widziałeś przynajmniej trzy różne sposoby w jakich Git używa znaku `^` do zmiany sumy SHA, ale tutaj właśnie to to oznacza.

<!-- Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here. -->

Inną świetną rzeczą w Gitcie jest to, że nie śledzi on zmian nazw plików jawnie. Zapisuje migawkę i następnie próbuje znaleźć pliki którym zmieniono nazwy. Interesujące jest również to, że możesz poprosić go, aby znalazł wszystkie zmiany nazw. Jeżeli dodasz opcję `-C` do `git blame`, Git przeanalizuje plik i spróbuje znaleźć z jakiego pliku dana linia pochodzi, jeżeli miał on skopiowany z innego miejsca. Ostatnio przepisywałem plik `GITServerHandler.m` do kilku osobnych plików, z których jednym był `GITPackUpload.m`. Wykonując "blame" na `GITPackUpload.m` z opcją `-C`, mogłem zobaczyć skąd pochodziły poszczególne części kodu:

<!-- Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from: -->

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

Jest to bardzo pomocne. Normalnie otrzymasz jako commit źródłowy, commit z którego kopiowałeś plik, ponieważ była to pierwsza chwila w której zmieniałeś linie w nim. Git pokazuje oryginalny commit w którym stworzyłeś te linie, nawet jeżeli było to w innym pliku. 

<!-- This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file. -->

### Szukanie binarne ###

<!-- ### Binary Search ### -->

Adnotacje w pliku są pomocne w sytuacji, gdy wiesz od czego zacząć. Jeżeli nie wiesz co psuje, a było wprowadzonych kilkadziesiąt lub kilkaset zmian, od momentu gdy miałeś pewność z kod działał prawidłowo, z pewnością spojrzysz na `git bisect` po pomoc. Komenda `bisect` wykonuje binarne szukanie przez Twoją historię commitów, aby pomóc Ci zidentyfikować tak szybko jak się da, który commit wprowadził błąd.

<!-- Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue. -->

Załóżmy, że właśnie wypchnąłeś wersję swojego kodu na środowisko produkcyjne i dostajesz zgłoszenia błędu, który nie występował w Twoim środowisku testowym, a na dodatek, nie wiesz czemu kod tak się zachowuje. Wracasz do weryfikacji kodu i okazuje się że możesz odtworzyć błąd, ale nie wiesz dlaczego tak się dzieje. Możesz wykonać komendę `bisect`, aby się dowiedzieć. Na początek uruchamiasz `git bisect start` aby rozpocząć, a potem `git bisect bad` aby powiedzieć systemowi że obecny commit na którym się znajdujesz jest popsuty. Następnie, wskazujesz kiedy ostatnia znana poprawna wersja była, przy użyciu `git bisect good [poprawna_wersja]`:

<!-- Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`: -->

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git zobaczył, że 12 zmian było wprowadzonych między commitem który uznałeś za ostatnio poprawny (v1.0), a obecną błędnie działającą wersję i pobrał środkową wersję za Ciebie. W tym momencie, możesz uruchomić ponownie test aby sprawdzić, czy błąd występuje nadal. Jeżeli występuje, oznacza to, że błąd został wprowadzony gdzieś przed tym środkowym commitem; jeżeli nie, to problem został wprowadzony gdzieś po nim. Okazuje się, że błąd już nie występuje, więc pokazujesz to Gitowi poprzez komendę `git bisect good` i kontynuujesz dalej:

<!-- Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey: -->

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Teraz jest na innym commicie, w połowie drogi między tym który właśnie przetestowałeś, a tym oznaczonym jako zły. Uruchamiasz swój test ponownie i widzisz, że obecna wersja zawiera błąd, więc wskazujesz to Gitowi za pomocą `git bisect bad`:

<!-- Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`: -->

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Ten commit jest dobry, więc teraz Git ma wszystkie informacje aby stwierdzić w którym miejscu błąd został wprowadzony. Pokazuje Ci sumę SHA-1 pierwszego błędnego commita, oraz trochę informacji z nim związanych, jak również listę plików które zostały zmodyfikowane, tak abyś mógł zidentyfikować co się stało że błąd został wprowadzony:

<!-- This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug: -->

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Kiedy skończysz, powinieneś uruchomić `git bisect reset`, aby zresetować swój HEAD do stanu w którym zacząłeś, lub inaczej skończysz z dziwnym stanem kodu: 

<!-- When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state: -->

	$ git bisect reset

Jest to potężne narzędzie, które pomoże Ci sprawdzić setki zmian, w poszukiwaniu wprowadzonego błędu w ciągu minut. W rzeczywistości, jeżeli masz skrypt który zwraca wartość 0 jeżeli projekt działa (good) poprawnie, oraz wartość inną niż 0 jeżeli projekt nie działa (bad), możesz w całości zautomatyzować komendę `git bisect`. Na początek, wskazujesz zakres na którym będzie działał, poprzez wskazanie znanych błędnych i działających commitów. Możesz to zrobić, poprzez wypisanie ich za pomocą komendy `bisect start`, podając znany błędny commit jako pierwszy i znany działający jako drugi:

<!-- This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second: -->

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Robiąc w ten sposób, uruchomiony zostanie skrypt `test-error.sh` na każdym commitcie, do czasu aż Git znajdzie pierwszy błędy commit. Możesz również uruchomić coś komendy podobne do `make` lub `make tests` lub jakiekolwiek które uruchomią zautomatyzowane testy za Ciebie.

<!-- Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you. -->

## Moduły zależne ##

<!-- ## Submodules ## -->

Często podczas pracy na jednym projektem, musisz włączyć inny projekt do niego. Być może będzie to biblioteka stworzona przez innych programistów, lub część projektu rozwijana niezależnie, którą można użyć w kilku innych projektach. W takiej sytuacji powstaje problem: chcesz nadal traktować te projekty jako oddzielne, ale mieć możliwość użycia jednego z nich w drugim.

<!-- It often happens that while working on one project, you need to use another project from within it. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other. -->

Sprawdźmy przykład. Załóżmy, że tworzysz stronę wykorzystującą kanały RSS/Atom. Jednak zamiast stworzenia własnego kodu który będzie się tym zajmował, decydujesz się na użycie zewnętrznej biblioteki. Będziesz musiał zainstalować ją z pakietu dostarczonego przez CPAN lub pakietu Ruby gem, lub skopiować jej kod źródłowy do swojego projektu. Problem z włączaniem biblioteki z zewnętrznego pakietu jest taki, że ciężko jest dostosować ją w jakikolwiek sposób oraz ciężko wdrożyć, ponieważ każdy użytkownik ma musi mieć taką bibliotekę zainstalowaną. Problem z włączaniem kodu biblioteki do własnego repozytorium jest taki, że po wprowadzeniu w niej jakichkolwiek zmian ciężko jest je włączyć, gdy kod biblioteki rozwinął się.

<!-- Here’s an example. Suppose you’re developing a web site and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available. -->

Git rozwiązuje te problemy przez użycie modułów zależnych. Pozwalają one na trzymanie repozytorium Gita w podkatalogu znajdującym się w innym repozytorium. Pozwala to na sklonowanie repozytorium do swojego projektu i utrzymywanie zmian niezależnie. 

<!-- Git addresses this issue using submodules. Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate. -->

### Rozpoczęcie prac z modułami zależnymi ###

<!-- ### Starting with Submodules ### -->

Załóżmy, że chcesz dodać bibliotekę Rack (biblioteka obsługująca serwer stron www napisana w Ruby) do swojego projektu, być może wprowadzić jakieś własne zmiany, ale nadal chcesz włączać zmiany wprowadzane w jej oryginalnym repozytorium. Pierwszą rzeczą jaką powinieneś zrobić jest sklonowanie zewnętrznego repozytorium do własnego podkatalogu. Dodajesz zewnętrzne projekty jako moduły zależne, za pomocą komendy `git submodule add`:

<!-- Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes. The first thing you should do is clone the external repository into your subdirectory. You add external projects as submodules with the `git submodule add` command: -->

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Masz teraz projekt Rack w podkatalogu o nazwie `rack`, który znajduje się w Twoim projekcie. Możesz przejść do tego podkatalogu, wprowadzić zmiany, dodać swoje własne zdalne repozytorium do którego będziesz mógł wypychać zmiany, pobierać i włączać zmiany z oryginalnego repozytorium, itd. Jeżeli uruchomisz komendę `git status` zaraz po dodaniu modułu, zobaczysz dwie rzeczy:

<!-- Now you have the Rack project under a subdirectory named `rack` within your project. You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more. If you run `git status` right after you add the submodule, you see two things: -->

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#


Po pierwsze zobaczysz plik `.gitmodules`. Jest to plik konfiguracyjny, który przechowuje mapowania pomiędzy adresami URL projektów i lokalnymi podkatalogami do których je pobrałeś:

<!-- First you notice the `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into: -->

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

Jeżeli masz więcej modułów zależnych, będziesz miał więcej wpisów w tym pliku. Warto zaznaczysz, że ten plik jest również obsługiwany przez system kontroli wersji razem z innymi plikami, podobnie do `.gitignore`. Jest wypychany i pobierany razem z resztą projektu. Z niego inne osoby pobierające ten projekt dowiedzą sie skąd pobrać dodatkowe moduły. 

<!-- If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file. It’s pushed and pulled with the rest of your project. This is how other people who clone this project know where to get the submodule projects from. -->

Inny wynik komendy `git status` ma katalog rack. Jeżeli uruchomisz `git diff` na nim, zobaczysz coś interesującego:

<!-- The other listing in the `git status` output is the rack entry. If you run `git diff` on that, you see something interesting: -->

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Chociaż `rack` jest podkatalogiem w Twoim katalogu roboczym, Git widzi go jako moduł zależny i nie śledzi jego zawartości, jeżeli nie jesteś w tym katalogu. Zamiast tego, Git śledzi każdy commit z tego repozytorium. Kiedy zrobisz jakieś zmiany i wykonasz na nich commit w tym podkatalogu, projekt główny 

<!-- Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory. Instead, Git records it as a particular commit from that repository. When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly. -->

Ważnym jest, aby wskazać, że moduły zależne: zapisujesz dokładnie na jakimś etapie rozwoju (na dokładnym commicie). Nie możesz dodać modułu zależnego, który będzie wskazywał na gałąź `master` lub jakąś inną symboliczne odniesienie.

<!-- This is an important point with submodules: you record them as the exact commit they’re at. You can’t record a submodule at `master` or some other symbolic reference. -->

Jak commitujesz, zobaczysz coś podobnego do:

<!-- When you commit, you see something like this: -->

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Zauważ tryb 160000 dla wpisu dotyczącego rack. Jest to specjalny tryb w Gitcie, który oznacza tyle, że zapisujesz commmit jako wpis dotyczący katalogu, a nie podkatalogu czy pliku. 

<!-- Notice the 160000 mode for the rack entry. That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file. -->

Możesz traktować katalog `rack` jako oddzielny projekt i od czasu do czasu aktualizować jego zawartość do ostatniej zmiany w nim. Wszystkie komendy Gita działają niezależnie w każdym z dwóch katalogów:

<!-- You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject. All the Git commands work independently in the two directories: -->

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


### Klonowanie projektu z modułami zależnymi ###

<!-- ### Cloning a Project with Submodules ### -->

Sklonujesz tym razem projekt, który ma sobie moduł zależny. Kiedy pobierzesz taki projekt, otrzymasz katalogi które zawierają moduły zależne, ale nie będzie w nich żadnych plików: 

<!-- Here you’ll clone a project with a submodule in it. When you receive such a project, you get the directories that contain submodules, but none of the files yet: -->

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

Powstał katalog `rack`, ale pusty. Musisz uruchomić dwie komendy: `git submodule init`, aby zainicjować lokalny plik konfiguracyjny, oraz `git submodule update`, aby pobrać wszystkie dane z tego projektu i nałożyć zmiany dotyczące tego modułu z projektu głównego:

<!-- The `rack` directory is there, but empty. You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject: -->

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

Teraz Twój podkatalog `rack` jest w dokładnie takim samym stanie w jakim był, gdy commitowałeś go wcześniej. Jeżeli inny programista zrobi zmiany w kodzie rack i zapisze je, a Ty pobierzesz je i włączysz, otrzymasz dziwny wynik:

<!-- Now your `rack` subdirectory is at the exact state it was in when you committed earlier. If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd: -->

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

Włączyłeś zmiany które były po prostu przesunięciem wskaźnika ostatniej wersji dla tego modułu; jednak kod nie został zaktualizowany, więc wygląda to trochę tak, jakbyś miał niespójne dane w swoim katalogu roboczym:

<!-- You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory: -->

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Dzieje się tak dlatego, ponieważ wskaźnik który masz dla modułu zależnego, nie istnieje w jego katalogu. Aby to poprawić, musisz uruchomić `git submodule update` ponownie:

<!-- This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory. To fix this, you must run `git submodule update` again: -->

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

Musisz wykonywać tę komendę, za każdym razem gdy ściągniesz zmiany z modułu do swojego projektu. Trochę to dziwne, ale działa.

<!-- You have to do this every time you pull down a submodule change in the main project. It’s strange, but it works. -->

Często zdarza się natrafić na problem związany z tym, że programista wprowadza zmiany lokalnie w jakimś module, ale nie wypycha ich na publiczny serwer. Następnie commituje on wskaźnik do tej nie publicznej zmiany i wypycha do głównego projektu. Kiedy inni programiści będą chcieli uruchomić `git submodule update`, komenda ta nie będzie mogła znaleźć commita na który zmiana wskazuje, ponieważ istnieje ona tylko na komputerze tamtego programisty. Jeżeli tak się stanie, zobaczysz błąd podobny do:

<!-- One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server. Then, they commit a pointer to that non-public state and push up the superproject. When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system. If that happens, you see an error like this: -->

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Musisz dojść do tego, kto ostatnio zmieniał ten moduł: 

<!-- You have to see who last changed the submodule: -->

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

W takiej sytuacji piszesz do niego e-mail i mówisz mu co o tym sądzisz.

<!-- Then, you e-mail that guy and yell at him. -->

### Superprojekty ###

<!-- ### Superprojects ### -->

Czasami, programiści chcą pobrać tylko część podkatalogów z dużego projektu, w zależności czym ich zespół się zajmuje. Jest to częste, jeżeli używałeś CVS lub Subversion, gdzie miałeś zdefiniowany moduł lub kolekcję podkatalogów i chciałbyś trzymać się tego sposobu pracy.

<!-- Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on. This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow. -->

Można to łatwo osiągnąć w Gitcie, tworząc dla każdego podkatalogu osobne repozytorium Gita, a następnie tworząc superprojekt który zawiera różne moduły. Zyskiem z takiego podejścia jest to, że możesz dokładniej określić zależności między projektami za pomocą tagów i gałęzi w superprojekcie.

<!-- A good way to do this in Git is to make each of the subdirectories a separate Git repository and then create superproject Git repositories that contain multiple submodules. A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects. -->

### Problemy z modułami zależnymi ###

<!-- ### Issues with Submodules ### -->

Używanie modułów zależnych wiąże się również z pewnymi problemami. Po pierwsze musisz być ostrożny podczas pracy w katalogu modułu. Kiedy uruchamiasz komendę `git submodule update`, sprawdza ona konkretną wersję projektu, ale nie w gałęzi. Nazywane to jest posiadaniem odłączonego HEADa - co oznacza, że HEAD wskazuje bezpośrednio na commit, a nie na symboliczną referencję. Problem w tym, że zazwyczaj nie chcesz pracować w takim środowisku, bo łatwo o utratę zmian. Jeżeli zrobisz po raz pierwszy `submodule update`, wprowadzisz zmiany w tym module bez tworzenia nowej gałęzi do tego, i potem ponownie uruchomisz `git submodule update` z poziomu projektu głównego bez commitowania ich, Git nadpisze te zmiany bez żadnej informacji zwrotnej. Technicznie rzecz biorąc nie stracisz swoich zmian, ale nie będziesz miał gałęzi która wskazuje na nie, będzie więc trudno je odzyskać.

<!-- Using submodules isn’t without hiccups, however. First, you must be relatively careful when working in the submodule directory. When you run `git submodule update`, it checks out the specific version of the project, but not within a branch. This is called having a detached HEAD — it means the HEAD file points directly to a commit, not to a symbolic reference. The issue is that you generally don’t want to work in a detached HEAD environment, because it’s easy to lose changes. If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.  Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieve. -->

Aby uniknąć tego problemu, stwórz gałąź gdy pracujesz w katalogu modułu za pomocą `git checkout -b work` lub podobnej komendy. Kiedy zrobisz aktualizację modułu kolejny raz, cofnie on Twoje zmiany, ale przynajmniej masz wskaźnik dzięki któremu możesz do nich dotrzeć. 

<!-- To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent. When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to. -->

Przełączanie gałęzi które mają w sobie moduły zależne może również być kłopotliwe. Gdy stworzysz nową gałąź, dodanie w niej moduł, a następnie przełączysz się z powrotem na gałąź która nie zawiera tego modułu, będziesz miał nadal katalog w którym jest moduł, ale nie będzie on śledzony:

<!-- Switching branches with submodules in them can also be tricky. If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory: -->

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

Musisz albo przenieść go gdzieś lub usunąć, będziesz musiał ponownie go sklonować po przełączeniu 

<!-- You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up. -->

Ostatnim głównym problemem z którym ludzie się spotykają, jest sytuacja w której, chcemy przejść z podkatalogów na moduły zależne. Jeżeli miałeś dodane pliki w swoim projekcie, a następnie chciałbyś przenieść część z nich do osobnego modułu, musisz być ostrożny bo inaczej Git będzie sprawiał kłopoty. Załóżmy że masz pliki związane z rack w podkatalogu swojego projektu i chcesz przenieść je do osobnego modułu. Jeżeli usuniesz ten podkatalog i uruchomisz `submodule add`, Git pokaże błąd:

<!-- The last main caveat that many people run into involves switching from subdirectories to submodules. If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you. Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule. If you delete the subdirectory and then run `submodule add`, Git yells at you: -->

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Musisz najpierw usunąć z przechowalni katalog `rack`. Następnie możesz dodać moduł:

<!-- You have to unstage the `rack` directory first. Then you can add the submodule: -->

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Teraz załóżmy że zrobiłeś to w gałęzi. Jeżeli spróbujesz przełączyć się ponownie na gałąź w której te pliki znajdują się w projekcie a nie w module zależnym - otrzymasz błąd:

<!-- Now suppose you did that in a branch. If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error: -->

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Musisz przenieść gdzieś katalogu modułu `rack`, zanim będziesz mógł zmienić na gałąź która go nie ma:

<!-- You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it: -->

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Potem, gdy przełączysz się z powrotem, otrzymasz pusty katalog `rack`. Musisz albo uruchomić `git submodule update` w celu ponownego pobrania, lub przenieść katalog `/tmp/rack` z powrotem do pustego katalogu.

<!-- Then, when you switch back, you get an empty `rack` directory. You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory. -->


## Włączanie innych projektów ##

<!-- ## Subtree Merging ## -->

Teraz, gdy znasz już trudności związane z modułami zależnymi, spójrzmy na alternatywny sposób rozwiązania tego problemu. Kiedy Git ma włączyć zmiany, najpierw sprawdza jakie zmiany ma włączyć, a następnie wybiera najlepszą strategię do wykonania tego zadania. Jeżeli łączysz dwie gałęzie, Git użyje strategii _rekurencyjnej_. Jeżeli łączysz więcej niż dwie gałęzie, Git wybierze strategię _ośmiornicy_. Te strategie są automatycznie wybierane za Ciebie, ponieważ rekurencyjna strategia może obsłużyć sytuacje łączenia trójstronnego - na przykład, w przypadku więcej niż jednego wspólnego przodka - ale może obsłużyć tylko łączenie dwóch gałęzi. Strategia ośmiornicy może obsłużyć większą ilość gałęzi, ale jest bardziej ostrożna, aby uniknąć trudnych do rozwiązania konfliktów, dlatego jest domyślną strategią w przypadku gdy łączysz więcej niż dwie gałęzie.

<!-- Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a _recursive_ strategy. If you’re merging more than two branches, Git picks the _octopus_ strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches. -->

Natomiast, są również inne strategie które możesz wybrać. Jedną z nich jest łączenie _subtree_ i możesz go używać z podprojektami. Zobaczysz tutaj jak włączyć do projektu projekt rack opisany w poprzedniej sekcji, ale przy użyciu łączenia _subtree_.

<!-- However, there are other strategies you can choose as well. One of them is the _subtree_ merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead. -->

W zamyśle, łącznie "subtree" jest wtedy, gdy masz dwa projekty w których jeden mapuje się do podkatalogu w drugim i na odwrót. Kiedy użyjesz łączenia "subtree", Git jest na tyle mądry, aby dowiedzieć się, że jeden z nich jest włączany do drugiego i odpowiednio jest złączyć - jest to całkiem ciekawe. 

<!-- The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing. -->

Najpierw dodajesz aplikację Rack do swojego projektu. Dodajesz projekt Rack, jako zdalny i następnie pobierasz go do dedykowanej gałęzi.

<!-- You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch: -->

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

Masz teraz zawartość projektu Rack w gałęzi `rack_branch`, a swój projekt w gałęzi `master`. Jeżeli pobierzesz najpierw jedną, a potem drugą gałąź, zobaczysz że mają one inną zawartość:

<!-- Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch. If you check out one and then the other, you can see that they have different project roots: -->

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Chcesz jednak, pobrać projekt Rack do swojej gałęzi `master` jako podkatalog. Możesz to zrobić, za pomocą komendy Gita `git read-tree`. Dowiesz się więcej na temat komendy `read-tree` i jej podobnych w rozdziale 9, ale na teraz wiedz, że odczytuje ona drzewo projektu w jednej gałęzi i włącza je do obecnego katalogu i przechowalni. Ponownie zmieniasz gałąź na `master` i pobierasz gałąź `rack_branch` do podkatalogu `rack` w gałęzi `master` w projekcie:

<!-- You want to pull the Rack project into your `master` project as a subdirectory. You can do that in Git with `git read-tree`. You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project: -->

	$ git read-tree --prefix=rack/ -u rack_branch

Kiedy wykonasz commit, będzie wyglądało że masz wszystkie pliki Rack w podkatalogu - tak jakbyś skopiował je z spakowanego archiwum. To co jest interesujące, to to, że możesz bardzo łatwo włączać zmiany z jednej gałęzi do drugiej. Więc, jeżeli projekt Rack zostanie zaktualizowany, możesz pobrać te zmiany poprzez przełączenie się na gałąź i wydanie komend:

<!-- When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling: -->

	$ git checkout rack_branch
	$ git pull

Następnie, możesz włączyć te zmiany do swojej gałęzi master. Możesz użyć `git merge -s subtree` i ta zadziała poprawnie; ale Git również połączy historię zmian ze sobą, czego prawdopodobnie nie chcesz. Aby pobrać zmiany i samemu wypełnił treść komentarza, użyj opcji `--squash` oraz `--no-commit` do opcji `-s subtree`:

<!-- Then, you can merge those changes back into your master branch. You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the `-\-squash` and `-\-no-commit` options as well as the `-s subtree` strategy option: -->

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Wszystkie zmiany z Twojego projektu Rack są włączone i gotowe do zatwierdzenia lokalnie. Możesz zrobić to również na odwrót - wprowadź zmiany w podkatalogu `rack` w gałęzi master, a potem włącz je do gałęzi `rack_branch`, aby wysłać je do opiekunów projektu.

<!-- All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream. -->

Aby zobaczyć różnicę w zmianach które masz w swoim podkatalogu `rack` i gałęzi `rack_branch` - aby zobaczyć czy trzeba je włączyć - nie możesz użyć normalnie komendy `diff`. Zamiast tego musisz użyć komendy `git diff-tree` z nazwą gałęzi do której chcesz przywrównać kod:

<!-- To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command. Instead, you must run `git diff-tree` with the branch you want to compare to: -->

	$ git diff-tree -p rack_branch

Lub, aby porównać zawartość Twojego podkatalogu `rack` z tym co jak wyglądała gałąź `master` na serwerze w momencie, gdy ją pobierałeś możesz uruchomić

<!-- Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run -->

	$ git diff-tree -p rack_remote/master

## Podsumowanie ##
<!-- ## Summary ## -->

Poznałeś kilka zaawansowanych narzędzi, które umożliwią Ci łatwiejsze manipulowanie swoimi commitami i przechowalnią. Kiedy zauważysz jakieś problemy, powinieneś już móc dowiedzieć się który commit je wprowadził, kiedy i przez kogo. Jeżeli chcesz używać modułów zależnych w swoim projekcie, poznałeś kilka sposobów w jaki sposób to osiągnąć. Na tym etapie, powinieneś potrafić zrobić większość rzeczy w Gitcie, których będziesz potrzebował w codziennej pracy, bez niepotrzebnego stresu.

<!-- You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely. When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom. If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs. At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so. -->


