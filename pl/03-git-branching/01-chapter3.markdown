# Gałęzie Gita #

Prawie każdy system kontroli wersji posiada wsparcie dla gałęzi. Rozgałęzienie oznacza odbicie od głównego pnia linii rozwoju i kontynuację pracy bez wprowadzania tam bałaganu. W wielu narzędziach kontroli wersji jest to proces dość kosztowny, często wymagający utworzenia nowej kopii katalogu z kodem, co w przypadku dużych projektów może zająć sporo czasu.

Niektórzy uważają model gałęzi Gita za jego „killer feature” i z całą pewnością wyróżnia go spośród innych narzędzi tego typu. Co w nim specjalnego? Sposób, w jaki Git obsługuje gałęzie, jest niesamowicie lekki, przez co tworzenie nowych gałęzi jest niemalże natychmiastowe, a przełączanie się pomiędzy nimi trwa niewiele dłużej. W odróżnieniu od wielu innych systemów, Git zachęca do częstego rozgałęziania i scalania projektu, nawet kilkukrotnie w ciągu jednego dnia. Zrozumienie i opanowanie tego wyjątkowego i potężnego mechanizmu może dosłownie zmienić sposób, w jaki pracujesz.

## Czym jest gałąź ##

Żeby naprawdę zrozumieć sposób, w jaki Git obsługuje gałęzie, trzeba cofnąć się o krok i przyjrzeć temu, w jaki sposób Git przechowuje dane. Jak może pamiętasz z Rozdziału 1., Git nie przechowuje danych jako serii zmian i różnic, ale jako zestaw migawek.

Kiedy zatwierdzasz zmiany w Gicie, ten zapisuje obiekt zmian (commit), który z kolei zawiera wskaźnik na migawkę zawartości, która w danej chwili znajduje się w poczekalni, metadane autora i opisu oraz zero lub więcej wskaźników na zmiany, które były bezpośrednimi rodzicami zmiany właśnie zatwierdzanej: brak rodziców w przypadku pierwszej, jeden w przypadku zwykłej, oraz kilka w przypadku zmiany powstałej wskutek scalenia dwóch lub więcej gałęzi.

Aby lepiej to zobrazować, załóżmy, że posiadasz katalog zawierający trzy pliki, które umieszczasz w poczekalni, a następnie zatwierdzasz zmiany. Umieszczenie w poczekalni plików powoduje wyliczenie sumy kontrolnej każdego z nich (skrótu SHA-1 wspomnianego w Rozdziale 1.), zapisanie wersji plików w repozytorium (Git nazywa je blobami) i dodanie sumy kontrolnej do poczekalni:

	$ git add README test.rb LICENSE
	$ git commit -m 'Początkowa wersja mojego projektu'

Kiedy zatwierdzasz zmiany przez uruchomienie polecenia `git commit`, Git liczy sumę kontrolną każdego podkatalogu (w tym wypadku tylko głównego katalogu projektu) i zapisuje te trzy obiekty w repozytorium. Następnie tworzy obiekt zestawu zmian (commit), zawierający metadane oraz wskaźnik na główne drzewo projektu, co w razie potrzeby umożliwi odtworzenie całej migawki.

Teraz repozytorium Gita zawiera już 5 obiektów: jeden blob dla zawartości każdego z trzech plików, jedno drzewo opisujące zawartość katalogu i określające, które pliki przechowywane są w których blobach, oraz jeden zestaw zmian ze wskaźnikiem na owo drzewo i wszystkimi metadanymi. Jeśli chodzi o ideę, dane w repozytorium Gita wyglądają jak na Rysunku 3-1.

Insert 18333fig0301.png 
Rysunek 3-1. Dane repozytorium z jedną zatwierdzoną zmianą.

Jeśli dokonasz zmian i je również zatwierdzisz, kolejne zatwierdzenie zachowa wskaźnik do zestawu zmian, który został utworzony bezpośrednio przed właśnie dodawanym. Po dwóch kolejnych zatwierdzeniach, Twoja historia może wyglądać podobnie do przedstawionej na Rysunku 3-2:

Insert 18333fig0302.png 
Rysunek 3-2. Dane Gita dla wielu zestawów zmian.

Gałąź w Gicie jest po prostu lekkim, przesuwalnym wskaźnikiem na któryś z owych zestawów zmian. Domyślna nazwa gałęzi Gita to master. Kiedy zatwierdzasz pierwsze zmiany, otrzymujesz gałąź master, która wskazuje na ostatni zatwierdzony przez Ciebie zestaw. Z każdym zatwierdzeniem automatycznie przesuwa się ona do przodu.

Insert 18333fig0303.png 
Rysunek 3-3. Gałąź wskazująca na dane zestawu zmian w historii.

Co się stanie, jeśli utworzysz nową gałąź? Cóż, utworzony zostanie nowy wskaźnik, który następnie będziesz mógł przesuwać. Powiedzmy, że tworzysz nową gałąź o nazwie testing. Zrobisz to za pomocą polecenia `git branch`:

	$ git branch testing

Polecenie to tworzy nowy wskaźnik na ten sam zestaw zmian, w którym aktualnie się znajdujesz (zobacz Rysunek 3-4).

Insert 18333fig0304.png 
Rysunek 3-4. Wiele gałęzi wskazujących na dane zestawów zmian w historii.

Skąd Git wie, na której gałęzi się aktualnie znajdujesz? Utrzymuje on specjalny wskaźnik o nazwie HEAD. Istotnym jest, że bardzo różni się on od koncepcji HEADa znanej z innych systemów kontroli wersji, do jakich mogłeś się już przyzwyczaić, na przykład Subversion czy CVS. W Gicie jest to wskaźnik na lokalną gałąź, na której właśnie się znajdujesz. W tym wypadku, wciąż jesteś na gałęzi master. Polecenie `git branch` utworzyło jedynie nową gałąź, ale nie przełączyło cię na nią (porównaj z Rysunkiem 3-5).

Insert 18333fig0305.png 
Rysunek 3-5. HEAD wskazuje na gałąź, na której się znajdujesz.

Aby przełączyć się na istniejącą gałąź, używasz polecenia `git checkout`. Przełączmy się zatem do nowo utworzonej gałęzi testing:

	$ git checkout testing

HEAD zostaje zmieniony tak, by wskazywać na gałąź testing (zobacz Rysunek 3-6).

Insert 18333fig0306.png
Rysunek 3-6. Po przełączaniu gałęzi, HEAD wskazuje inną gałąź.

Jakie ma to znaczenie? Zatwierdźmy nowe zmiany:

	$ vim test.rb
	$ git commit -a -m 'zmiana'

Rysunek 3-7 ilustruje wynik operacji.

Insert 18333fig0307.png 
Rysunek 3-7. Gałąź wskazywana przez HEAD przesuwa się naprzód po każdym zatwierdzeniu zmian.

To interesujące, bo teraz Twoja gałąź testing przesunęła się do przodu, jednak gałąź master ciągle wskazuje ten sam zestaw zmian, co w momencie użycia `git checkout` do zmiany aktywnej gałęzi. Przełączmy się zatem z powrotem na gałąź master:

	$ git checkout master

Rysunek 3-8 pokazuje wynik.

Insert 18333fig0308.png 
Rysunek 3-8. Po wykonaniu `checkout`, HEAD przesuwa się na inną gałąź.

Polecenie dokonało dwóch rzeczy. Przesunęło wskaźnik HEAD z powrotem na gałąź master i przywróciło pliki w katalogu roboczym do stanu z migawki, na którą wskazuje master. Oznacza to również, że zmiany, które od tej pory wprowadzisz, będą rozwidlały się od starszej wersji projektu. W gruncie rzeczy cofa to tymczasowo pracę, jaką wykonałeś na gałęzi testing, byś mógł z dalszymi zmianami pójść w innym kierunku.

Wykonajmy teraz kilka zmian i zatwierdźmy je:

	$ vim test.rb
	$ git commit -a -m 'inna zmiana'

Teraz historia Twojego projektu została rozszczepiona (porównaj Rysunek 3-9). Stworzyłeś i przełączyłeś się na gałąź, wykonałeś na niej pracę, a następnie powróciłeś na gałąź główną i wykonałeś inną pracę. Oba zestawy zmian są od siebie odizolowane w odrębnych gałęziach: możesz przełączać się pomiędzy nimi oraz scalić je razem, kiedy będziesz na to gotowy. A wszystko to wykonałeś za pomocą dwóch prostych poleceń `branch` i `checkout`.

Insert 18333fig0309.png 
Rysunek 3-9. Rozwidlona historia gałęzi.

Ponieważ gałęzie w Gicie są tak naprawdę prostymi plikami, zawierającymi 40 znaków sumy kontrolnej SHA-1 zestawu zmian, na który wskazują, są one bardzo tanie w tworzeniu i usuwaniu. Stworzenie nowej gałęzi zajmuje dokładnie tyle czasu, co zapisanie 41 bajtów w pliku (40 znaków + znak nowej linii).

Wyraźnie kontrastuje to ze sposobem, w jaki gałęzie obsługuje większość narzędzi do kontroli wersji, gdzie z reguły w grę wchodzi kopiowanie wszystkich plików projektu do osobnego katalogu. Może to trwać kilkanaście sekund czy nawet minut, w zależności od rozmiarów projektu, podczas gdy w Gicie jest zawsze natychmiastowe. Co więcej, ponieważ wraz z każdym zestawem zmian zapamiętujemy jego rodziców, odnalezienie wspólnej bazy przed scaleniem jest automatycznie wykonywane za nas i samo w sobie jest niezwykle proste. Możliwości te pomagają zachęcić deweloperów do częstego tworzenia i wykorzystywania gałęzi.

Zobaczmy, dlaczego ty też powinieneś.

## Podstawy rozgałęziania i scalania ##

Zajmijmy się prostym przykładem rozgałęziania i scalania używając schematu, jakiego mógłbyś użyć w rzeczywistej pracy. W tym celu wykonasz następujące czynności:

1. Wykonasz pracę nad stroną internetową.
2. Stworzysz gałąź dla nowej funkcji, nad którą pracujesz.
3. Wykonasz jakąś pracę w tej gałęzi.

Na tym etapie otrzymasz telefon, że inny problem jest obecnie priorytetem i potrzeba błyskawicznej poprawki. Oto, co robisz:

1. Powrócisz na gałąź produkcyjną.
2. Stworzysz nową gałąź, by dodać tam poprawkę.
3. Po przetestowaniu, scalisz gałąź z poprawką i wypchniesz zmiany na serwer produkcyjny.
4. Przełączysz się na powrót do gałęzi z nową funkcją i będziesz kontynuować pracę.

### Podstawy rozgałęziania ###

Na początek załóżmy, że pracujesz nad swoim projektem i masz już zatwierdzonych kilka zestawów zmian (patrz Rysunek 3-10).

Insert 18333fig0310.png 
Rysunek 3-10. Krótka i prosta historia zmian.

Zdecydowałeś się zająć problemem #53 z systemu śledzenia zgłoszeń, którego używa Twoja firma, czymkolwiek by on nie był. Dla ścisłości, Git nie jest powiązany z żadnym konkretnym systemem tego typu; tym niemniej ponieważ problem #53 to dość konkretny temat, utworzysz nową gałąź by się nim zająć. Aby utworzyć gałąź i jednocześnie się na nią przełączyć, możesz wykonać polecenie `git checkout` z przełącznikiem `-b`:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Jest to krótsza wersja:

	$ git branch iss53
	$ git checkout iss53

Rysunek 3-11 pokazuje wynik.

Insert 18333fig0311.png 
Rysunek 3-11. Tworzenie wskaźnika nowej gałęzi.

Pracujesz nad swoim serwisem WWW i zatwierdzasz kolejne zmiany. Każdorazowo naprzód przesuwa się także gałąź `iss53`, ponieważ jest aktywna (to znaczy, że wskazuje na nią wskaźnik HEAD; patrz Rysunek 2-12):

	$ vim index.html
	$ git commit -a -m 'nowa stopka [#53]'

Insert 18333fig0312.png 
Rysunek 3-12. Gałąź iss53 przesunęła się do przodu wraz z postępami w Twojej pracy.

Teraz właśnie otrzymujesz telefon, że na stronie wykryto błąd i musisz go natychmiast poprawić. Z Gitem nie musisz wprowadzać poprawki razem ze zmianami wykonanymi w ramach pracy nad `iss35`. Co więcej, nie będzie cię również kosztować wiele wysiłku przywrócenie katalogu roboczego do stanu sprzed tych zmian, tak, by nanieść poprawki na kod, który używany jest na serwerze produkcyjnym. Wszystko, co musisz teraz zrobić, to przełączyć się z powrotem na gałąź master.

Jednakże, nim to zrobisz, zauważ, że, jeśli Twój katalog roboczy lub poczekalnia zawierają niezatwierdzone zmiany, które są w konflikcie z gałęzią, do której chcesz się teraz przełączyć, Git nie pozwoli ci zmienić gałęzi. Przed przełączeniem gałęzi najlepiej jest doprowadzić katalog roboczy do czystego stanu. Istnieją sposoby pozwalające obejść to ograniczenie (mianowicie schowek oraz poprawianie zatwierdzonych już zmian) i zajmiemy się nimi później. Póki co zatwierdziłeś wszystkie swoje zmiany, więc możesz przełączyć się na swoją gałąź master:

	$ git checkout master
	Switched to branch "master"

W tym momencie Twój katalog roboczy projektu jest dokładnie w takim stanie, w jakim był zanim zacząłeś pracę nad problemem #53, więc możesz skoncentrować się na swojej poprawce. Jest to ważna informacja do zapamiętania: Git resetuje katalog roboczy, by wyglądał dokładnie jak migawka zestawu zmian wskazywanego przez aktywną gałąź. Automatycznie dodaje, usuwa i modyfikuje pliki, by upewnić się, że kopia robocza wygląda tak, jak po ostatnich zatwierdzonych w niej zmianach.

Masz jednak teraz do wykonania ważną poprawkę. Stwórzmy zatem gałąź, na której będziesz pracował do momentu poprawienia błędu (patrz Rysunek 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'poprawiony adres e-mail'
	[hotfix]: created 3a0874c: "poprawiony adres e-mail"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Rysunek 3-13. Gałąź hotfix bazująca na gałęzi master.

Możesz uruchomić swoje testy, upewnić się, że poprawka w gałęzi hotfix jest tym, czego potrzebujesz i scalić ją na powrót z gałęzią master, by następnie przenieść zmiany na serwer produkcyjny. Robi się to poleceniem `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Rezultat polecenia scalenia zawiera frazę „Fast forward”. Ponieważ zestaw zmian wskazywany przez scalaną gałąź był bezpośrednim rodzicem aktualnego zestawu zmian, Git przesuwa wskaźnik do przodu. Innymi słowy, jeśli próbujesz scalić zestaw zmian z innym, do którego dotrzeć można podążając wzdłuż historii tego pierwszego, Git upraszcza wszystko poprzez przesunięcie wskaźnika do przodu, ponieważ nie ma po drodze żadnych rozwidleń do scalenia — stąd nazwa „fast forward” („przewijanie”).

Twoja zmiana jest teraz częścią migawki zestawu zmian wskazywanego przez gałąź `master` i możesz zaktualizować kod na serwerze produkcyjnym (zobacz Rysunek 3-14).

Insert 18333fig0314.png 
Rysunek 3-14. Po scaleniu Twoja gałąź master wskazuje to samo miejsce, co gałąź hotfix.

Po tym, jak Twoje niezwykle istotne poprawki trafią na serwer, jesteś gotowy powrócić do uprzednio przerwanej pracy. Najpierw jednak usuniesz gałąź hotfix, gdyż nie jest już ci potrzebna — gałąź `master` wskazuje to samo miejsce. Możesz ją usunąć używając opcji `-d` polecenia `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Teraz możesz przełączyć się z powrotem do gałęzi z rozpoczętą wcześniej pracą nad problemem #53 i kontynuować pracę (patrz Rysunek 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'skończona nowa stopka [#53]'
	[iss53]: created ad82d7a: "skończona nowa stopka [#53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Rysunek 3-15. Twoja gałąź iss53 może przesuwać się do przodu niezależnie.

Warto tu zauważyć, że praca, jaką wykonałeś na gałęzi `hotfix` nie jest uwzględniona w plikach w gałęzi `iss53`. Jeśli jej potrzebujesz, możesz scalić zmiany z gałęzi `master` do gałęzi `iss53`, uruchamiając `git merge master`, możesz też zaczekać z integracją zmian na moment, kiedy zdecydujesz się przenieść zmiany z gałęzi `iss53` z powrotem do gałęzi `master`.

### Podstawy scalania ###

Załóżmy, że zdecydowałeś, że praca nad problemem #53 dobiegła końca i jest gotowa, by scalić ją do gałęzi `master`. Aby to zrobić, scalisz zmiany z gałęzi `iss53` tak samo, jak wcześniej zrobiłeś to z gałęzią `hotfix`. Wszystko, co musisz zrobić, to przełączyć się na gałąź, do której chcesz zmiany scalić, a następnie uruchomić polecenie `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Wygląda to odrobinę inaczej, niż w przypadku wcześniejszego scalenia gałęzi `hotfix`. W tym wypadku Twoja historia rozwoju została rozszczepiona na wcześniejszym etapie. Ponieważ zestaw zmian z gałęzi, na której obecnie jesteś, nie jest bezpośrednim potomkiem gałęzi, którą scalasz, Git musi w końcu popracować. W tym przypadku Git przeprowadza scalenie trójstronne (ang. three-way merge), używając dwóch migawek wskazywanych przez końcówki gałęzi oraz ich wspólnego przodka. Rysunek 3-16 pokazuje trzy migawki, których w tym przypadku Git używa do scalania.

Insert 18333fig0316.png 
Rysunek 3-16. Git automatycznie odnajduje najlepszego wspólnego przodka, który będzie punktem wyjściowym do scalenia gałęzi.

Zamiast zwykłego przeniesienia wskaźnika gałęzi do przodu, Git tworzy nową migawkę, która jest wynikiem wspomnianego scalenia trójstronnego i automatycznie tworzy nowy zestaw zmian, wskazujący na ową migawkę (patrz Rysunek 3-17). Określane jest to mianem zmiany scalającej (ang. merge commit), która jest o tyle wyjątkowa, że posiada więcej niż jednego rodzica.

Warto zaznaczyć, że Git sam określa najlepszego wspólnego przodka do wykorzystania jako punkt wyjściowy scalenia; różni się to od zachowania CVS czy Subversion (przed wersją 1.5), gdzie osoba scalająca zmiany musi punkt wyjściowy scalania znaleźć samodzielnie. Czyni to scalanie w Gicie znacznie łatwiejszym, niż w przypadku tamtych systemów.

Insert 18333fig0317.png 
Rysunek 3-17. Git automatycznie tworzy nowy zestaw zmian zawierający scaloną pracę.

Teraz, kiedy Twoja praca jest już scalona, nie potrzebujesz dłużej gałęzi `iss53`. Możesz ją usunąć, a następnie ręcznie zamknąć zgłoszenie w swoim systemie śledzenia zadań:

	$ git branch -d iss53

### Podstawowe konflikty scalania ###

Od czasu do czasu proces scalania nie przebiega tak gładko. Jeśli ten sam plik zmieniłeś w różny sposób w obu scalanych gałęziach, Git nie będzie w stanie scalić ich samodzielnie. Jeśli Twoja poprawka problemu #53 zmieniła tę samą część pliku, co zmiana w gałęzi `hotfix`, podczas scalania otrzymasz komunikat o konflikcie, wyglądający jak poniżej:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git nie zatwierdził automatycznie zmiany scalającej. Wstrzymał on cały proces do czasu rozwiązania konfliktu przez Ciebie. Jeśli chcesz zobaczyć, które pliki pozostałe niescalone w dowolnym momencie po wystąpieniu konfliktu, możesz uruchomić `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Cokolwiek spowodowało konflikty i nie zostało automatycznie rozstrzygnięte, jest tutaj wymienione jako „unmerged” (niescalone). Git dodaje do problematycznych plików standardowe znaczniki rozwiązania konfliktu, możesz więc owe pliki otworzyć i samodzielnie rozwiązać konflikty. Twój plik zawiera teraz sekcję, która wygląda mniej więcej tak:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Oznacza to, że wersja wskazywana przez HEAD (Twoja gałąź master, ponieważ tam właśnie byłeś podczas uruchamiania polecenia scalania) znajduje się w górnej części bloku (wszystko powyżej `======`), a wersja z gałęzi `iss53` to wszystko poniżej. Aby rozwiązać konflikt, musisz wybrać jedną lub druga wersję albo własnoręcznie połączyć zawartość obu. Dla przykładu możesz rozwiązać konflikt, zastępując cały blok poniższą zawartością: 

	<div id="footer">
	please contact us at email.support@github.com
	</div>

To rozwiązanie ma po trochu z obu części, całkowicie usunąłem także linie `<<<<<<<`, `=======` i `>>>>>>>`. Po rozstrzygnięciu wszystkich takich sekcji w każdym z problematycznych plików, uruchom `git add` na każdym z nich, aby oznaczyć go jako rozwiązany. Przeniesienie do poczekalni oznacza w Gicie rozwiązanie konfliktu.
Jeśli chcesz do rozwiązania tych problemów użyć narzędzia graficznego, możesz wydać polecenie `git mergetool`. Uruchomi ono odpowiednie narzędzie graficzne, które przeprowadzi cię przez wszystkie konflikty:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Jeśli chcesz użyć narzędzia innego niż domyślne (Git w tym przypadku wybrał dla mnie `opendiff`, ponieważ pracuję na Maku), możesz zobaczyć wszystkie wspierane narzędzia wymienione na samej górze, zaraz za „merge tool candidates”. Wpisz nazwę narzędzia, którego wolałbyś użyć. W Rozdziale 7 dowiemy się, jak zmienić domyślną wartość dla twojego środowiska pracy.

Po opuszczeniu narzędzia do scalania, Git zapyta, czy wszystko przebiegło pomyślnie. Jeśli odpowiesz skryptowi, że tak właśnie było, plik zostanie umieszczony w poczekalni, by konflikt oznaczyć jako rozwiązany.

Możesz uruchomić polecenie `git status` ponownie, by upewnić się, że wszystkie konflikty zostały rozwiązane:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Jeśli jesteś zadowolony i potwierdziłeś, że wszystkie problematyczne pliki zostały umieszczone w poczekalni, możesz wpisać `git commit`, by tym samym zatwierdzić zestaw zmian scalających. Jego domyślny opis wygląda jak poniżej:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Możesz go zmodyfikować, dodając szczegółowy opis sposobu scalenia zmian, jeśli tylko uważasz, że taka informacja będzie pomocna innym, gdy przyjdzie im oglądać efekt scalenia w przyszłości — dlaczego zrobiłeś to w taki, a nie inny sposób, jeśli nie jest to oczywiste.

## Zarządzanie gałęziami ##

Teraz, kiedy już stworzyłeś, scaliłeś i usunąłeś pierwsze gałęzie, spójrzmy na dodatkowe narzędzia do zarządzania gałęziami, które przydadzą się, gdy będziesz już używać gałęzi w swojej codziennej pracy.

Polecenie `git branch` robi coś więcej, poza tworzeniem i usuwaniem gałęzi. Jeśli uruchomisz je bez argumentów, otrzymasz prostą listę istniejących gałęzi:

	$ git branch
	  iss53
	* master
	  testing

Zauważ znak `*`, którym poprzedzona została gałąź `master`: wskazuje on aktywną gałąź. Oznacza to, że jeżeli w tym momencie zatwierdzisz zmiany, wskaźnik gałęzi `master` zostanie przesunięty do przodu wraz z nowo zatwierdzonymi zmianami. Aby obejrzeć ostatni zatwierdzony zestaw zmian na każdej z gałęzi, możesz użyć polecenia `git branch -v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Kolejna przydatna opcja pozwalająca na sprawdzenie stanu gałęzi to przefiltrowanie tej listy w celu wyświetlenia gałęzi, które już zostały lub jeszcze nie zostały scalone do aktywnej gałęzi. Przydatne opcje `--merged` i `--no-merged` służą właśnie do tego celu i są dostępne w Gicie począwszy od wersji 1.5.6. Aby zobaczyć, które gałęzie zostały już scalone z bieżącą, uruchom polecenie `git branch --merged`:

	$ git branch --merged
	  iss53
	* master

Ponieważ gałąź `iss53` została już scalona, znalazła się ona na Twojej liście. Gałęzie znajdujące się na tej liście a niepoprzedzone znakiem `*` można właściwie bez większego ryzyka usunąć poleceniem `git branch -d`; wykonana na nich praca została już scalona do innej gałęzi, więc niczego nie stracisz.

Aby zobaczyć wszystkie gałęzie zawierające zmiany, których jeszcze nie scaliłeś, możesz uruchomić polecenie `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Pokazuje to Twoją drugą gałąź. Ponieważ zawiera ona zmiany, które nie zostały jeszcze scalone, próba usunięcia jej poleceniem `git branch -d` nie powiedzie się:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Jeśli naprawdę chcesz usunąć gałąź i stracić tę część pracy, możesz wymusić to opcją `-D` zgodnie z tym, co podpowiada komunikat na ekranie.

## Sposoby pracy z gałęziami ##

Teraz, kiedy poznałeś już podstawy gałęzi i scalania, co ze zdobytą wiedzą możesz i co powinieneś zrobić? W tej części zajmiemy się typowymi schematami pracy, które stają się dostępne dzięki tak lekkiemu modelowi gałęzi. Pozwoli ci to samemu zdecydować, czy warto stosować je w swoim cyklu rozwoju projektów.

### Gałęzie długodystansowe ###

Ponieważ Git używa prostego scalania trójstronnego, scalanie zmian z jednej gałęzi do drugiej kilkukrotnie w długim okresie czasu jest ogólnie łatwe. Oznacza to, że możesz utrzymywać kilka gałęzi, które są zawsze otwarte i których używasz dla różnych faz w cyklu rozwoju; możesz scalać zmiany regularnie z jednych gałęzi do innych.

Wielu programistów pracuje z Gitem wykorzystując to podejście, trzymając w gałęzi `master` jedynie stabilny kod — możliwe, że jedynie kod, który już został albo w najbliższej przyszłości zostanie wydany. Równolegle utrzymują oni inną gałąź o nazwie `develop` lub `next`, na której pracują lub używają jej do stabilizacji przyszłych wersji — zawarta w niej praca nie musi być zawsze stabilna, lecz po stabilizacji może być scalona do gałęzi `master`. Taką gałąź wykorzystuje się także do wciągania zmian z gałęzi tematycznych (gałęzi krótkodystansowych, takich jak wcześniejsza `iss53`), kiedy są gotowe, aby przetestować je i upewnić się, że nie wprowadzają nowych błędów.

W rzeczywistości mówimy o wskaźnikach przesuwających się w przód po zatwierdzanych przez Ciebie zestawach zmian. Stabilne gałęzie znajdują się wcześniej w historii, a gałęzie robocze na jej końcu (patrz Rysunek 3-18).

Insert 18333fig0318.png 
Rysunek 3-18. Stabilniejsze gałęzie z reguły znajdują się wcześniej w historii zmian.

Ogólnie łatwiej jest myśleć o nich jak o silosach na zmiany, gdzie grupy zmian są promowane do stabilniejszych silosów, kiedy już zostaną przetestowane (Rysunek 3-19).

Insert 18333fig0319.png 
Rysunek 3-19. Może być ci łatwiej myśleć o swoich gałęziach jak o silosach.

Możesz powielić ten schemat na kilka poziomów stabilności. Niektóre większe projekty posiadają dodatkowo gałąź `proposed` albo `pu` („proposed updates” — proponowane zmiany), scalającą gałęzie, które nie są jeszcze gotowe trafić do gałęzi `next` czy `master`. Zamysł jest taki, że twoje gałęzie reprezentują różne poziomy stabilności; kiedy osiągają wyższy stopień stabilności, są scalane do gałęzi powyżej.
Podobnie jak poprzednio, posiadanie takich długodystansowych gałęzi nie jest konieczne, ale często bardzo pomocne, zwłaszcza jeśli pracujesz przy dużych, złożonych projektach.

### Gałęzie tematyczne ###

Gałęzie tematyczne, dla odmiany, przydadzą się w każdym projekcie, niezależnie od jego rozmiarów. Gałąź tematyczna to gałąź krótkodystansowa, którą tworzysz i używasz w celu stworzenia pojedynczej funkcji lub innych tego rodzaju zmian. Z całą pewnością nie jest to coś czego chciałbyś używać pracując z wieloma innymi systemami kontroli wersji, ponieważ scalanie i tworzenie nowych gałęzi jest w nich ogólnie mówiąc zbyt kosztowne. W Gicie tworzenie, praca wewnątrz jak i scalanie gałęzi kilkukrotnie w ciągu dnia jest powszechnie stosowane i naturalne.

Widziałeś to w poprzedniej sekcji, kiedy pracowaliśmy z gałęziami `iss53` i `hotfix`. Stworzyłeś wewnątrz nich kilka rewizji, po czym usunąłeś je zaraz po scaleniu zmian z gałęzią główną. Ta technika pozwala na szybkie i efektywne przełączanie kontekstu - ponieważ Twój kod jest wyizolowany w osobnych silosach, w których wszystkie zmiany są związane z pracą do jakiej została stworzona gałąź, znacznie łatwiej jest połapać się w kodzie podczas jego przeglądu, recenzowania i temu podobnych. Możesz przechowywać tam swoje zmiany przez kilka minut, dni, miesięcy i scalać je dopiero kiedy są gotowe, bez znaczenia w jakiej kolejności zostały stworzone oraz w jaki sposób przebiegała praca nad nimi.

Rozważ przykład wykonywania pewnego zadania (na gałęzi głównej), stworzenia gałęzi w celu rozwiązania konkretnego problemu (`iss91`), pracy na niej przez chwilę, stworzenia drugiej gałęzi w celu wypróbowania innego sposobu rozwiązania tego samego problemu (`iss91v2`), powrotu do gałęzi głównej i pracy z nią przez kolejną chwilę, a następnie stworzenia tam kolejnej gałęzi do sprawdzenia pomysłu, co do którego nie jesteś pewny, czy ma on sens (gałąź `dumbidea`). Twoja historia rewizji będzie wygląda mniej więcej tak:

Insert 18333fig0320.png 
Rysunek 3-20. Twoja historia rewizji zawierająca kilka gałęzi tematycznych.

Teraz, powiedzmy, że decydujesz się, że najbardziej podoba ci się drugie rozwiązanie Twojego problemu (`iss91v2`); zdecydowałeś się także pokazać gałąź `dumbidea` swoim współpracownikom i okazało się, że pomysł jest genialny. Możesz wyrzucić oryginalne rozwiązanie problemu znajdujące się w gałęzi `iss91` (tracąc rewizje C5 i C6) i scalić dwie pozostałe gałęzie. Twoja historia będzie wyglądać tak, jak na Rysunku 3-21.

Insert 18333fig0321.png 
Rysunek 3-21. Historia zmian po scaleniu gałęzi dumbidea i iss91v2.

Ważne jest, żeby robiąc to wszystko pamiętać, że są to zupełnie lokalne gałęzie. Tworząc nowe gałęzie i scalając je później, robisz to wyłącznie w ramach własnego repozytorium - bez jakiejkolwiek komunikacji z serwerem.

## Gałęzie zdalne ##

Zdalne gałęzie są odnośnikami do stanu gałęzi w zdalnym repozytorium. Są to lokalne gałęzie, których nie można zmieniać; są one modyfikowane automatycznie za każdym razem, kiedy wykonujesz jakieś operacje zdalne. Zdalne gałęzie zachowują się jak zakładki przypominające ci, gdzie znajdowały się gałęzie w twoim zdalnym repozytorium ostatnim razem, kiedy się z nim łączyłeś.

Ich nazwy przybierają następującą formę: `(nazwa zdalnego repozytorium)/(nazwa gałęzi)`. Na przykład, gdybyś chciał zobaczyć, jak wygląda gałąź master w zdalnym repozytorium `origin` z chwili, kiedy po raz ostatni się z nim komunikowałeś, musiałbyś sprawdzić gałąź `origin/master`. Jeśli na przykład pracowałeś nad zmianą wraz z partnerem który wypchnął gałąź `iss53`, możesz mieć lokalną gałąź `iss53`, ale gałąź na serwerze będzie wskazywała rewizję znajdującą się pod `origin/iss53`.

Może być to nieco mylące, więc przyjrzyjmy się dokładniej przykładowi. Powiedzmy, że w swojej sieci masz serwer Git pod adresem `git.ourcompany.com`. Po sklonowaniu z niego repozytorium, Git automatycznie nazwie je jako `origin`, pobierze wszystkie dane, stworzy wskaźnik do miejsca gdzie znajduje się gałąź `master` i nazwie ją lokalnie `origin/master`; nie będziesz mógł jej przesuwać. Git da ci także do pracy Twoją własną gałąź `master` zaczynającą się w tym samym miejscu, co zdalna (zobacz Rysunek 3-22).

Insert 18333fig0322.png
Rysunek 3-22. Po sklonowaniu otrzymasz własną gałąź główną oraz zdalną origin/master wskazującą na gałąź w zdalnym repozytorium.

Jeśli wykonasz jakąś pracę na gałęzi głównej, a w międzyczasie ktoś inny wypchnie zmiany na `git.ourcompany.com` i zaktualizuje jego gałąź główną, wówczas wasze historie przesuną się do przodu w różny sposób. Co więcej, dopóki nie skontaktujesz się z serwerem zdalnym, Twój wskaźnik `origin/master` nie przesunie się (Rysunek 3-23).

Insert 18333fig0323.png 
Rysunek 3-23. Kiedy pracujesz lokalnie, wypchnięcie przez kogoś zmian na serwer powoduje, że obie historie zaczynają przesuwać się do przodu w odmienny sposób.

Aby zsynchronizować zmiany uruchom polecenie `git fetch origin`. Polecenie to zajrzy na serwer, na który wskazuje nazwa origin (w tym wypadku `git.ourcompany.com`), pobierze z niego wszystkie dane, których jeszcze nie masz u siebie, i zaktualizuje Twoją lokalną bazę danych przesuwając jednocześnie wskaźnik `origin/master` do nowej, aktualniejszej pozycji (zobacz Rysunek 3-24).

Insert 18333fig0324.png 
Rysunek 3-24. Polecenie git fetch aktualizuje zdalne referencje.

Aby zaprezentować fakt posiadania kilku zdalnych serwerów oraz stan ich zdalnych gałęzi, załóżmy, że posiadasz jeszcze jeden firmowy serwer Git, który jest używany wyłącznie przez jeden z twoich zespołów sprintowych. Jest to serwer dostępny pod adresem `git.team1.ourcompany.com`. Możesz go dodać do projektu, nad którym pracujesz, jako nowy zdalny odnośnik uruchamiając polecenie `git remote add` tak, jak pokazaliśmy to w rozdziale 2. Nazwij go `teamone`, dzięki czemu później będziesz używał tej nazwy zamiast pełnego adresu URL (rysunek 3-25).

Insert 18333fig0325.png 
Rysunek 3-25. Dodanie kolejnego zdalnego serwera.

Możesz teraz uruchomić polecenie `git fetch teamone` aby pobrać wszystko, co znajduje się na serwerze, a czego jeszcze nie posiadasz lokalnie. Ponieważ serwer ten zawiera podzbiór danych które zawiera serwer `origin`, Git nie pobiera niczego ale tworzy zdalną gałąź `teamone/master` wskazującą na rewizję dostępną w repozytorium `teamone` i jej gałęzi `master` (rysunek 3-26).

Insert 18333fig0326.png 
Rysunek 3-26. Dostajesz lokalny odnośnik do gałęzi master w repozytorium teamone.

### Wypychanie zmian ###

Jeśli chcesz podzielić się swoją gałęzią ze światem, musisz wypchnąć zmiany na zdalny serwer, na którym posiadasz prawa zapisu. twoje lokalne gałęzie nie są automatycznie synchronizowane z serwerem, na którym zapisujesz - musisz jawnie określić gałęzie, których zmianami chcesz się podzielić. W ten sposób możesz używać prywatnych gałęzi do pracy, której nie chcesz dzielić, i wypychać jedynie gałęzie tematyczne, w ramach których współpracujesz.

Jeśli posiadasz gałąź o nazwie `serverfix`, w której chcesz współpracować z innymi, możesz wypchnąć swoje zmiany w taki sam sposób jak wypychałeś je w przypadku pierwszej gałęzi. Uruchom `git push (nazwa zdalnego repozytorium) (nazwa gałęzi)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Posłużyłem się pewnym skrótem. Git automatycznie sam rozwija nazwę `serverfix` do pełnej `refs/heads/serverfix:refs/heads/serverfix`, co oznacza "Weź moją lokalną gałąź serverfix i wypchnij zmiany, aktualizując zdalną gałąź serverfix". Zajmiemy się szczegółowo częścią `refs/heads/` w rozdziale 9, ale ogólnie nie powinieneś się tym przejmować. Możesz także wykonać `git push origin serverfix:serverfix` co przyniesie ten sam efekt - dla Gita znaczy to "Weź moją gałąź serverfix i uaktualnij nią zdalną gałąź serverfix". Możesz używać tego formatu do wypychania lokalnych gałęzi do zdalnych o innej nazwie. Gdybyś nie chciał żeby gałąź na serwerze nazywała się `serverfix` mógłbyś uruchomić polecenie w formie `git push origin serverfix:innanazwagałęzi` co spowodowałoby wypchnięcie gałęzi `serverfix` do `innanazwagałęzi` w zdalnym repozytorium.

Następnym razem kiedy twoi współpracownicy pobiorą dane z serwera, uzyskają referencję do miejsca, w którym została zapisana Twoja wersja `serverfix` pod zdalną gałęzią `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Warto zauważyć, że kiedy podczas pobierania ściągasz nową, zdalną gałąź, nie uzyskujesz automatycznie lokalnej, edytowalnej jej wersji. Inaczej mówiąc, w tym przypadku, nie masz nowej gałęzi `serverfix` na której możesz do razu pracować - masz jedynie wskaźnik `origin/serverfix` którego nie można modyfikować.

Aby scalić pobraną pracę z bieżącą gałęzią roboczą uruchom polecenie `git merge origin/serverfix`. Jeśli potrzebujesz własnej gałęzi `serverfix` na której będziesz mógł pracować dalej, możesz ją stworzyć bazując na zdalnej gałęzi w następujący sposób:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Otrzymasz lokalną gałąź, w której będziesz mógł rozpocząć pracę od momentu, w którym znajduje się ona w zdalnej gałązi `origin/serverfix`.

### Gałęzie śledzące ###

Przełączenie do lokalnej gałęzi ze zdalnej automatycznie tworzy coś, co określa się jako _gałąź śledzącą_. Gałęzie śledzące są gałęziami lokalnymi, które posiadają bezpośrednią relację z gałęzią zdalną. Jeśli znajdujesz się w gałęzi śledzącej, po wpisaniu `git push` Git automatycznie wie, na który serwer wypchnąć zmiany. Podobnie uruchomienie `git pull` w jednej z takich gałęzi pobiera wszystkie dane i odnośniki ze zdalnego repozytorium i automatycznie scala zmiany z gałęzi zdalnej do odpowiedniej gałęzi zdalnej.

Po sklonowaniu repozytorium automatycznie tworzona jest gałąź `master`, która śledzi `origin/master`. Z tego właśnie powodu polecenia `git push` i `git pull` działają od razu, bez dodatkowych argumentów. Jednakże, możesz skonfigurować inne gałęzie tak, żeby śledziły zdalne odpowiedniki. Prosty przypadek to przywołany już wcześniej przykład polecenia `git checkout -b [gałąź] [nazwa zdalnego repozytorium]/[gałąź]`. Jeśli pracujesz z Gitem nowszym niż 1.6.2, możesz także użyć skrótu `--track`:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Żeby skonfigurować lokalną gałąź z inną nazwą niż zdalna, możesz korzystać z pierwszej wersji polecenia podając własną nazwę:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Teraz Twoja lokalna gałąź sf będzie pozawalała na automatyczne wypychanie zmian jak i ich pobieranie z origin/serverfix.

### Usuwanie zdalnych gałęzi ###

Załóżmy, że skończyłeś pracę ze zdalną gałęzią - powiedzmy, że ty i twoi współpracownicy zakończyliście pracę nad nową funkcją i scaliliście zmiany ze zdalną gałęzią główną `master` (czy gdziekolwiek indziej, gdzie znajduje się stabilna wersja kodu). Możesz usunąć zdalną gałąź używając raczej niezbyt intuicyjnej składni `git push [nazwa zdalnego repozytorium] :[gałąź]`. Aby np. usunąć z serwera gałąź `serverfix` uruchom polecenie:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Bum. Nie ma już na serwerze tej gałęzi. Jeśli chcesz, zaznacz sobie tę stronę, ponieważ będziesz potrzebował tego polecenia, a najprawdopodobniej zapomnisz jego składni. Polecenie to można spróbować zapamiętać przypominając sobie składnię `git push [nazwa zdalnego repozytorium] [gałąź lokalna]:[gałąź zdalna]`, którą omówiliśmy odrobinę wcześniej. Pozbywając się części [gałąź lokalna], mówisz mniej więcej "Weź nic z mojej strony i zrób z tego [gałąź zdalną]".

## Zmiana bazy ##

W Git istnieją dwa podstawowe sposoby integrowania zmian z jednej gałęzi do drugiej: scalanie (polecenie `merge`) oraz zmiana bazy (polecenie `rebase`). W tym rozdziale dowiesz się, czym jest zmiana bazy, jak ją przeprowadzić, dlaczego jest to świetne narzędzie i w jakich przypadkach lepiej się powstrzymać od jego wykorzystania.

### Typowa zmiana bazy ###

Jeśli cofniesz się do poprzedniego przykładu z sekcji Scalanie (patrz Rysunek 3-27), zobaczysz, że rozszczepiłeś swoją pracę i wykonywałeś zmiany w dwóch różnych gałęziach.

Insert 18333fig0327.png 
Rysunek 3-27. Początkowa historia po rozszczepieniu.

Najprostszym sposobem, aby zintegrować gałęzie - jak już napisaliśmy - jest polecenie `merge`. Przeprowadza ono trójstronne scalanie pomiędzy dwoma ostatnimi migawkami gałęzi (C3 i C4) oraz ich ostatnim wspólnym przodkiem (C2), tworząc nową migawkę (oraz rewizję), tak jak widać to na rysunku 3-28.

Insert 18333fig0328.png 
Rysunek 3-28. Scalanie gałęzi integrujące rozszczepioną historię zmian.

Jednakże istnieje inny sposób: możesz stworzyć łatkę ze zmianami wprowadzonymi w C3 i zaaplikować ją na rewizję C4. W Gicie nazywa się to zmianą bazy (ang. rebase). Dzięki poleceniu `rebase` możesz wziąć wszystkie zmiany, które zostały zatwierdzone w jednej gałęzi i zaaplikować je w innej.

W tym wypadku, mógłbyś uruchomić następujące polecenie:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Polecenie to działa przesuwając się do ostatniego wspólnego przodka obu gałęzi (tej w której się znajdujesz oraz tej *do* której robisz zmianę bazy), pobierając różnice opisujące kolejne zmiany (ang. diffs) wprowadzane przez kolejne rewizje w gałęzi w której się znajdujesz, zapisując je w tymczasowych plikach, następnie resetuje bieżącą gałąź do tej samej rewizji *do* której wykonujesz operację zmiany bazy, po czym aplikuje po kolei zapisane zmiany. Ilustruje to rysunek 3-29.

Insert 18333fig0329.png 
Rysunek 3-29. Zmiana bazy dla zmian wprowadzonych w C3 do C4.

W tym momencie możesz wrócić do gałęzi `master` i scalić zmiany wykonując proste przesunięcie wskaźnika (co przesunie wskaźnik master na koniec) (rysunek 3-30).

Insert 18333fig0330.png 
Rysunek 3-30. Przesunięcie gałęzi master po operacji zmiany bazy.

Teraz migawka wskazywana przez C3' jest dokładnie taka sama jak ta, na którą wskazuje C5 w przykładzie ze scalaniem. Nie ma różnicy w produkcie końcowym integracji. Zmiana bazy tworzy jednak czystszą historię. Jeśli przejrzysz historię gałęzi po operacji `rebase`, wygląda ona na liniową: wygląda jakby cała praca była wykonywana stopniowo, nawet jeśli oryginalnie odbywała się równolegle.

Warto korzystać z tej funkcji, by mieć pewność, że rewizje zaaplikują się w bezproblemowy sposób do zdalnej gałęzi - być może w projekcie w którym próbujesz się udzielać, a którym nie zarządzasz. W takim wypadku będziesz wykonywał swoją pracę we własnej gałęzi, a następnie zmieniał jej bazę na `origin/master`, jak tylko będziesz gotowy do przesłania własnych poprawek do głównego projektu. W ten sposób osoba utrzymująca projekt nie będzie musiała dodatkowo wykonywać integracji - jedynie prostolinijne scalenie lub czyste zastosowanie zmian.

Zauważ, że migawka wskazywana przez wynikową rewizję bez względu na to, czy jest to ostatnia rewizja po zmianie bazy lub ostatnia rewizja scalająca po operacji scalania, to taka sama migawka - różnica istnieje jedynie w historii. Zmiana bazy nanosi zmiany z jednej linii pracy do innej w kolejności, w jakiej były one wprowadzane, w odróżnieniu od scalania, które bierze dwie końcówki i integruje je ze sobą.

### Ciekawsze operacje zmiany bazy ###

Poleceniem `rebase` możesz także zastosować zmiany na innej gałęzi niż ta, której zmieniasz bazę. Dla przykładu - weź historię taką jak na rysunku 3-31. Utworzyłeś gałąź tematyczną (`server`), żeby dodać nowe funkcje do kodu serwerowego, po czym utworzyłeś rewizję. Następnie utworzyłeś gałąź, żeby wykonać zmiany w kliencie (`client`) i kilkukrotnie zatwierdziłeś zmiany. W końcu wróciłeś do gałęzi `server` i wykonałeś kilka kolejnych rewizji.

Insert 18333fig0331.png 
Rysunek 3-31. Historia z gałęzią tematyczną utworzoną na podstawie innej gałęzi tematycznej.

Załóżmy, że zdecydowałeś się scalić zmiany w kliencie do kodu głównego, ale chcesz się jeszcze wstrzymać ze zmianami po stronie serwera, dopóki nie zostaną one dokładniej przetestowane. Możesz wziąć zmiany w kodzie klienta, których nie ma w kodzie serwera (C8 i C9) i zastosować je na gałęzi głównej używając opcji `--onto` polecenia `git rebase`:

	$ git rebase --onto master server client

Oznacza to mniej więcej "Przełącz się do gałęzi klienta, określ zmiany wprowadzone od wspólnego przodka gałęzi `client` i `server`, a następnie nanieś te zmiany na gałąź główną `master`. Jest to nieco skomplikowane, ale wynik (pokazany na rysunku 3-32) całkiem niezły.

Insert 18333fig0332.png 
Rysunek 3-32. Zmiana bazy gałęzi tematycznej odbitej z innej gałęzi tematycznej.

Teraz możesz zwyczajnie przesunąć wskaźnik gałęzi głównej do przodu (rysunek 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Rysunek 3-33. Przesunięcie do przodu gałęzi master w celu uwzględnienia zmian z gałęzi klienta.

Powiedzmy, że zdecydujesz się pobrać i scalić zmiany z gałęzi `server`. Możesz zmienić bazę gałęzi `server` na wskazywaną przez `master` bez konieczności przełączania się do gałęzi `server` używając `git rebase [gałąź bazowa] [gałąź tematyczna]` - w ten sposób zmiany z gałęzi `server` zostaną zaaplikowane do gałęzi bazowej `master`:

	$ git rebase master server

Polecenie odtwarza zmiany z gałęzi `server` na gałęzi `master` tak, jak pokazuje to rysunek 3-34.

Insert 18333fig0334.png 
Rysunek 3-34. Zmiana bazy gałęzi `serwer` na koniec gałęzi głównej.

Następnie możesz przesunąć gałąź bazową (`master`):

	$ git checkout master
	$ git merge server

Możesz teraz usunąć gałęzie `client` i `server`, ponieważ cała praca jest już zintegrowana i więcej ich nie potrzebujesz pozostawiając historię w stanie takim, jaki obrazuje rysunek 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Rysunek 3-35. Ostateczna historia rewizji.

### Zagrożenia operacji zmiany bazy ###

Błogosławieństwo, jakie daje możliwość zmiany bazy, ma swoją mroczną stronę. Można ją podsumować jednym zdaniem:

**Nie zmieniaj bazy rewizji, które wypchnąłeś już do publicznego repozytorium.**

Jeśli będziesz się stosował do tej reguły, wszystko będzie dobrze. W przeciwnym razie ludzie cię znienawidzą, a rodzina i przyjaciele zaczną omijać szerokim łukiem.

Stosując operację zmiany bazy porzucasz istniejące rewizje i tworzysz nowe, które są podobne, ale inne. Wypychasz gdzieś swoje zmiany, inni je pobierają, scalają i pracują na nich, a następnie nadpisujesz te zmiany poleceniem `git rebase` i wypychasz ponownie na serwer. Twoi współpracownicy będą musieli scalić swoją pracę raz jeszcze i zrobi się bałagan, kiedy spróbujesz pobrać i scalić ich zmiany z powrotem z twoimi.

Spójrzmy na przykład obrazujący, jak operacja zmiany bazy może spowodować problemy. Załóżmy, że sklonujesz repozytorium z centralnego serwera, a następnie wykonasz bazując na tym nowe zmiany. Twoja historia rewizji wygląda tak jak na rysunku 3-36.

Insert 18333fig0336.png 
Rysunek 3-36. Sklonowane repozytorium i dokonane zmiany.

Teraz ktoś inny wykonuje inną pracę, która obejmuje scalenie, i wypycha ją na centralny serwer. Pobierasz zmiany, scalasz nową, zdalną gałąź z własną pracą, w wyniku czego historia wygląda mniej więcej tak, jak na rysunku 3-37.

Insert 18333fig0337.png 
Rysunek 3-37. Pobranie kolejnych rewizji i scalenie ich z własnymi zmianami.

Następnie osoba, która wypchnęła scalone zmiany, rozmyśliła się i zdecydowała zamiast scalenia zmienić bazę swoich zmian; wykonuje `git push --force`, żeby zastąpić historię na serwerze. Następnie ty pobierasz dane z serwera ściągając nowe rewizje.

Insert 18333fig0338.png 
Rysunek 3-38. Ktoś wypycha rewizje po operacji zmiany bazy porzucając rewizje, na których ty oparłeś swoje zmiany.

W tym momencie musisz raz jeszcze scalać tę pracę mimo tego, że już to wcześniej raz zrobiłeś. Operacja zmiany bazy zmienia sumy kontrolne SHA-1 tych rewizji, więc dla Gita wyglądają one jak zupełnie nowe, choć w rzeczywistości masz już zmiany wprowadzone w C4 w swojej historii (rysunek 3-39).

Insert 18333fig0339.png 
Rysunek 3-39. Scalasz tą samą pracę raz jeszcze tworząc nową rewizję scalającą.

Musisz scalić swoją pracę w pewnym momencie po to, żeby dotrzymywać kroku innym programistom. Kiedy już to zrobisz, Twoja historia zmian będzie zawierać zarówno rewizje C4 jak i C4', które mają różne sumy SHA-1, ale zawierają te same zmiany i mają ten sam komentarz. Jeśli uruchomisz `git log` dla takiej historii, zobaczysz dwie rewizje mające tego samego autora, datę oraz komentarz, co będzie mylące. Co więcej, jeśli wypchniesz tę historię z powrotem na serwer, raz jeszcze wprowadzisz wszystkie rewizje powstałe w wyniku operacji zmiany bazy na serwer centralny, co może dalej mylić i denerwować ludzi.

Jeśli traktujesz zmianę bazy jako sposób na porządkowanie historii i sposób pracy z rewizjami przed wypchnięciem ich na serwer oraz jeśli zmieniasz bazę tylko tym rewizjom, które nigdy wcześniej nie były dostępne publicznie, wówczas wszystko będzie w porządku. Jeśli zaczniesz zmieniać bazę rewizjom, które były już publicznie dostępne, a ludzie mogą na nich bazować swoje zmiany, wówczas możesz wpaść w naprawdę frustrujące tarapaty.

## Podsumowanie ##

Omówiliśmy podstawy tworzenia gałęzi oraz scalania w Git. Powinieneś już z łatwością tworzyć gałęzie, przełączać się pomiędzy nimi i scalać zawarte w nich zmiany. Powinieneś także umieć współdzielić swoje gałęzie wypychając je na serwer, pracować z innymi w współdzielonych gałęziach oraz zmieniać bazę gałęziom, zanim zostaną udostępnione innym.
