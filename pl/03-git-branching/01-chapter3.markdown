# Gałęzie Gita #

Prawie każdy system kontroli wersji obsługuje jakąś odmianę gałęzi. Rozgałęzienie oznacza odbicie od głównego pnia linii rozwoju i kontynuację pracy bez wprowadzania tam bałaganu. W wielu narzędziach kontroli wersji jest to proces dość kosztowny, często wymagający utworzenia nowej kopii katalogu z kodem, co w przypadku dużych projektów może zająć sporo czasu.

Niektórzy uważają model gałęzi Gita za jego „killer feature” i z całą pewnością wyróżnia go spośród innych narzędzi tego typu. Co w nim specjalnego? Sposób w jaki Git obsługuje gałęzie jest niesamowicie lekki, przez co tworzenie nowych gałęzi jest niemalże natychmiastowe, a przełączanie się pomiędzy nimi trwa niewiele dłużej. W odróżnieniu od wielu innych, Git zachęca do częstego rozgałęziania i  scalania projektu, nawet kilkukrotnie w ciągu jednego dnia. Zrozumienie i opanowanie tego wyjątkowego i potężnego mechanizmu może dosłownie zmienić sposób, w jaki pracujesz.

## Czym jest gałąź ##

Żeby naprawdę zrozumieć sposób, w jaki Git obsługuje gałęzie, trzeba cofnąć się o krok i przyjrzeć temu, w jaki sposób Git przechowuje dane. Jak może pamiętasz z Rozdziału 1., Git nie przechowuje danych jako serii zmian i różnic, ale jako zestaw migawek.

Kiedy zatwierdzasz zmiany w Gicie, ten zapisuje obiekt zmian, który z kolei zawiera wskaźnik na migawkę umieszczonej w poczekalni zawartości, metadane autora i opisu oraz zero lub więcej wskaźników na zmiany, które były bezpośrednimi rodzicami właśnie zatwierdzanej: brak rodziców w przypadki pierwszej, jeden w przypadku zwykłej, oraz kilka w przypadku zmiany powstałej wskutek scalenia dwóch lub więcej gałęzi.

Aby pokazać to lepiej, załóżmy, że posiadasz katalog zawierający trzy pliki, które umieszczasz w poczekalni, a następnie zatwierdzasz zmiany. Umieszczenie w poczekalni plików powoduje wyliczenie sumy kontrolnej każdego z nich (skrótu SHA-1 wspomnianego w Rozdziale 1.), zapisanie wersji plików w repozytorium (Git nazywa je blobami) i dodanie sumy kontrolnej do poczekalni:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Kiedy zatwierdzasz zmiany przez uruchomienie polecenia `git commit`, Git liczy sumę kontrolną każdego podkatalogu (w tym wypadku tylko głównego katalogu projektu) i zapisuje te trzy obiekty w repozytorium. Następnie tworzy obiekt zestawu zmian, zawierający metadane oraz wskaźnik na główne drzewo projektu, co w razie potrzeby umożliwi odtworzenie całej migawki.

Teraz repozytorium Gita zawiera już 5 obiektów: jeden blob dla zawartości każdego z trzech plików, jedno drzewo opisujące zawartość katalogu i określające, które pliki przechowywane są w których blobach, oraz jeden zestaw zmian ze wskaźnikiem na owo drzewo i wszystkimi metadanymi. Jeśli chodzi o ideę, dane w repozytorium Gita wyglądają jak na Rycinie 3-1.

Insert 18333fig0301.png 
Rycina 3-1. Dane repozytorium z jedną zatwierdzoną zmianą.

Jeśli dokonasz zmian i je również zatwierdzisz, kolejne zatwierdzenie zachowa wskaźnik do zestawu zmian, który został utworzony bezpośrednio przed właśnie dodawanym. Po dwóch kolejnych zatwierdzeniach, twoja historia może wyglądać podobnie do przedstawionej na Rycinie 3-2:

Insert 18333fig0302.png 
Rycina 3-2. Dane Gita dla wielu zestawów zmian.

Gałąź w Gicie jest po prostu lekkim, przesuwalnym wskaźnikiem na któryś z owych zestawów zmian. Domyślna nazwa gałęzi Gita to master. Kiedy zatwierdzasz pierwsze zmiany, otrzymujesz gałąź master, która wskazuje na ostatni zatwierdzony przez ciebie zestaw. Z każdym zatwierdzeniem automatycznie przesuwa się ona do przodu.

Insert 18333fig0303.png 
Rycina 3-3. Gałąź wskazująca na dane zestawu zmian w historii.

Co się stanie, jeśli utworzysz nową gałąź? Cóż, utworzony zostanie nowy wskaźnik, który następnie będziesz mógł przesuwać. Powiedzmy, że tworzysz nową gałąź o nazwie testing. Zrobisz to za pomocą polecenia `git branch`:

	$ git branch testing

Polecenie to tworzy nowy wskaźnik na ten sam zestaw zmian, w którym aktualnie się znajdujesz (zobacz Rycinę 3-4).

Insert 18333fig0304.png 
Rycina 3-4. Wiele gałęzi wskazujących na dane zestawów zmian w historii.

Skąd Git wie, na której gałęzi się aktualnie znajdujesz? Utrzymuje on specjalny wskaźnik o nazwie HEAD. Istotnym jest, że bardzo różni się on od koncepcji HEADa w innych systemach kontroli wersji, do jakich mogłeś się już przyzwyczaić, na przykład Subversion czy CVS. W Gicie jest to wskaźnik na lokalną gałąź, na której właśnie się znajdujesz. W tym wypadku, wciąż jesteś na gałęzi master. Polecenie `git branch` utworzyło jedynie nową gałąź, nie przełączyło cię na nią (porównaj z Ryciną 3-5).

Insert 18333fig0305.png 
Figure 3-5. HEAD wskazuje na gałąź, na której jesteś.

Aby przełączyć się na istniejącą gałąź, używasz polecenia `git checkout`. Przełączmy się zatem do nowoutworzonej gałęzi testing:

	$ git checkout testing

HEAD zostaje przesunięty tak, by wskazywać na gałąź testing (zobacz Rycinę 3-6).

Insert 18333fig0306.png
Figure 3-6. Po przełączaniu gałęzi HEAD wskazuje inną gałąź.

Jakie ma to znaczenie? Zatwierdźmy zmiany raz jeszcze:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Rycina 3-7 ilustruje wynik operacji.

Insert 18333fig0307.png 
Rycina 3-7. Gałąź wskazywana przez HEAD przesuwa się naprzód po każdym zatwierdzeniu zmian.

To interesujące, bo teraz twoja gałąź testing przesunęła się do przodu, jednak gałąź master ciągle wskazuje ten sam zestaw zmian, co w momencie użycia `git checkout` do zmiany aktywnej gałęzi. Przełączmy się zatem z powrotem na gałąź master:

	$ git checkout master

Rycina 3-8 pokazuje wynik.

Insert 18333fig0308.png 
Rycina 3-8. Po wykonaniu `checkout`, HEAD przesuwa się na inną gałąź.

Polecenie dokonało dwóch rzeczy. Przesunęło wskaźnik HEAD z powrotem na gałąź master i przywróciło pliki w katalogu roboczym do stanu z migawki, na którą wskazuje master. Oznacza to również, że zmiany, które od tej pory wprowadzisz, będą rozwidlały się od starszej wersji projektu. W gruncie rzeczy cofa to tymczasowo pracę, jaką wykonałeś na gałęzi testing, byś mógł z dalszymi zmianami pójść w innym kierunku.

Wykonajmy teraz kilka zmian i zatwierdźmy je:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Teraz historia twojego projektu została rozszczepiona (porównaj Rycinę 3-9). Stworzyłeś i przełączyłeś się na gałąź, wykonałeś na niej pracę, a następnie powróciłeś na gałąź główną i wykonałeś inną pracę. Oba zestawy zmian są od siebie odizolowane w odrębnych gałęziach: możesz przełączać się pomiędzy nimi oraz scalić je razem, kiedy będziesz na to gotowy. A wszystko to wykonałeś za pomocą dwóch prostych poleceń `branch` i `checkout`. 

Insert 18333fig0309.png 
Rycina 3-9. Rozwidlona historia gałęzi.

Ponieważ gałęzie w Gicie są tak naprawdę prostymi plikami, zawierającymi 40 znaków sumy kontrolnej SHA-1 zestawu zmian, na który wskazują, są one bardzo tanie w tworzeniu i usuwaniu. Stworzenie nowej gałęzi zajmuje dokładnie tyle czasu, co zapisanie 41 bajtów w pliku (40 znaków + znak nowej linii).

Wyraźnie kontrastuje to ze sposobem, w jaki gałęzie obsługuje większość narzędzi do kontroli wersji, gdzie z reguły w grę wchodzi kopiowanie wszystkich plików projektu do osobnego katalogu. Może to trwać kilkanaście sekund czy nawet minut, w zależności od rozmiarów projektu, podczas gdy w Gicie jest zawsze natychmiastowe. Co więcej, ponieważ wraz z każdym zestawem zmian zapamiętujemy jego rodziców, odnalezienie wspólnej bazy przed scaleniem jest automatycznie wykonywane za nas i samo w sobie jest niezwykle proste. Możliwości te pomagają zachęcić deweloperów do częstego tworzenia i używania gałęzi.

Zobaczmy, dlaczego ty też powinieneś.

## Podstawy rozgałęziania i scalania ##

Zajmijmy się prostym przykładem rozgałęziania i scalania używając schematu, jakiego mógłbyś użyć w rzeczywistej pracy. W tym celu wykonasz następujące czynności:

1.	Wykonasz pracę nad stroną internetową.
2.	Stworzysz gałąź dla nowego artykułu, nad którym pracujesz.
3.	Wykonasz jakąś pracę w tej gałęzi.

Na tym etapie otrzymasz telefon, że inny problem jest obecnie priorytetem i potrzeba błyskawicznej poprawki. Oto, co robisz:

1.	Powrócisz na gałąź produkcyjną.
2.	Stworzysz nową gałąź, by dodać tam poprawkę.
3.	Po przetestowaniu, scalisz gałąź z poprawką i wypchniesz zmiany na serwer produkcyjny.
4.	Przełączysz się na powrót do swojego artykułu i będziesz kontynuować pracę.

### Podstawy rozgałęziania ###

Na początek załóżmy, że pracujesz nad swoim projektem i masz już zatwierdzonych kilka zestawów zmian (porównaj Rycinę 3-10).

Insert 18333fig0310.png 
Rycina 3-10. Krótka i prosta historia zmian.

Zdecydowałeś się zająć problemem #53 z systemu śledzenia zgłoszeń, którego używa twoja firma, czymkolwiek by on nie był. Dla ścisłości, Git nie jest powiązany z żadnym konkretnym systemem tego typu; tym niemniej ponieważ problem #53 to dość wąski temat, utworzysz nową gałąź do pracy. Aby utworzyć gałąź i jednocześnie się na nią przełączyć, możesz uruchomić `git checkout` z przełącznikiem `-b`:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Jest to krótsza wersja:

	$ git branch iss53
	$ git checkout iss53

Rycina 3-11 pokazuje wynik.

Insert 18333fig0311.png 
Rycina 3-11. Tworzenie wskaźnika nowej gałęzi.

Pracujesz nad swoim serwisem i zatwierdzasz kolejne zmiany. Każdorazowo naprzód posuwa się także gałąź `iss53`, ponieważ jest aktywna (to znaczy, że wskazuje na nią wskaźnik HEAD; patrz Rycina 2-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Rycina 3-12. Gałąź iss53 przesunęła się do przodu wraz z postępami w twojej pracy.

Teraz właśnie otrzymujesz telefon, że na stronie wykryto błąd i musisz go natychmiast poprawić. Z Gitem nie musisz wprowadzać poprawki razem ze zmianami wykonanymi w ramach pracy na `iss35`. Co więcej, nie będzie cię również kosztować wiele wysiłku przywrócenie katalogu roboczego do stanu sprzed tych zmian, tak, by nanieść poprawki na kod, który używany jest na serwerze produkcyjnym. Wszystko co musisz teraz zrobić, to przełączyć się z powrotem na gałąź master.

Jednakże nim to zrobisz, zauważ, że jeśli twój katalog roboczy lub poczekalnia zawierają niezatwierdzone zmiany, które są w konflikcie z gałęzią, do której chcesz się teraz przełączyć, Git nie pozwoli ci zmienić gałęzi. Przed przełączeniem gałęzi najlepiej jest doprowadzić katalog roboczy do stanu czystości. Istnieją sposoby pozwalające obejść to ograniczenie (mianowicie schowek oraz poprawianie zatwierdzonych zmian) i zajmiemy się nimi później. Póki co, zatwierdziłeś wszystkie swoje zmiany, więc możesz przełączyć się na swoją gałąź master:

	$ git checkout master
	Switched to branch "master"

W tym momencie twój katalog roboczy projektu jest dokładnie w takim stanie, w jakim był zanim zacząłeś pracę nad problemem #53, więc możesz skoncentrować się na swojej poprawce. Jest to ważna informacja do zapamiętania: Git resetuje katalog roboczy, by wyglądał dokładnie jak migawka zestawu zmian wskazywanego przez aktywną gałąź.  Automatycznie dodaje, usuwa i modyfikuje pliki, by upewnić się, że kopia robocza wygląda tak, jak po ostatnich zatwierdzonych w niej zmianach.

Masz jednak teraz do wykonania ważną poprawkę. Stwórzmy zatem gałąź, na której będziesz pracował do momentu poprawienia błędu (patrz Rycina 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'poprawiony adres e-mail'
	[hotfix]: created 3a0874c: "poprawiony adres e-mail"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Rycina 3-13. Gałąź hotfix bazująca na gałęzi master.

Możesz uruchomić swoje testy, upewnić się, że poprawka w gałęzi hotfix jest tym, czego potrzebujesz i scalić ją na powrót z gałęzią master, by następnie przenieść zmiany na serwer produkcyjny. Robi się to poleceniem `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

W wynikach scalenia znajdziesz frazę „Fast forward”. Ponieważ zestaw zmian wskazywany przez scalaną gałąź był bezpośrednim rodzicem aktualnego zestawu zmian, Git przesuwa wskaźnik do przodu. Innymi słowy, jeśli próbujesz scalić zestaw zmian z innym, do którego dotrzeć można podążając wzdłuż historii tego pierwszego, Git upraszcza wszystko poprzez przesunięcie wskaźnika do przodu, ponieważ nie ma po drodze żadnych rozwidleń do scalenia — stąd nazwa „fast forward” („szybko do przodu”).

Twoja zmiana jest teraz częścią migawki zestawu zmian wskazywanego przez gałąź `master` i możesz zaktualizować kod na serwerze produkcyjnym (zobacz Rycinę 3-14).

Insert 18333fig0314.png 
Rycina 3-14. Po scaleniu twoja gałąź master wskazuje to samo miejsce, co gałąź hotfix.

Po tym, jak twoje niezwykle istotne poprawki trafią na serwer, jesteś gotowy powrócić do uprzednio przerwanej pracy. Najpierw jednak usuniesz gałąź hotfix, gdyż nie jest już ci potrzebna — gałąź `master` wskazuje to samo miejsce. Możesz ją usunąć używając opcji `-d` polecenia `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Teraz możesz przełączyć się z powrotem do gałęzi z rozpoczętą wcześniej pracą nad problemem #53 i kontynuować pracę (patrz Rycina 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'skonczona nowa stopka [zadanie 53]'
	[iss53]: created ad82d7a: "skonczona nowa stopka [zadanie 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Rycina 3-15. Twoja gałąź iss53 może przesuwać się do przodu niezależnie.

Warto tu zauważyć, że praca, jaką wykonałeś na gałęzi `hotfix` nie jest uwzględniona w plikach w gałęzi `iss53`. Jeśli jej potrzebujesz, możesz scalić gałąź `master` do gałęzi `iss53`, uruchamiając `git merge master`, możesz też zaczekać z integracją zmian na moment, kiedy zdecydujesz się przenieść zmiany z gałęzi `iss53` z powrotem do gałęzi `master`.

### Podstawy scalania ###

Załóżmy, że zdecydowałeś, że praca nad problemem #53 dobiegła końca i jest gotowa, by scalić ją do gałęzi `master`. Aby to zrobić, scalisz zmiany z gałęzi `iss53` tak samo, jak wcześniej zrobiłeś to z gałęzią `hotfix`. Wszystko, co musisz zrobić, to przełączyć się na gałąź, do której chcesz zmiany scalić, a następnie uruchomić polecenie `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Wygląda to odrobinę inaczej, niż w przypadku wcześniejszego scalenia gałęzi `hotfix`. W tym wypadku twoja historia rozwoju została rozszczepiona na wcześniejszym etapie. Ponieważ zestaw zmian z gałęzi, na której obecnie jesteś, nie jest bezpośrednim potomkiem gałęzi, którą scalasz, Git musi w końcu popracować. W tym przypadku Git przeprowadza scalenie scalenie trójstronne, używając dwóch migawek wskazywanych przez końcówki gałęzi oraz wspólnego przodka ich obu. Rycina 3-16 pokazuje trzy migawki, których w tym przypadku Git używa do scalania.

Insert 18333fig0316.png 
Rycina 3-16. Git automatycznie odnajduje najlepszego wspólnego przodka jako punkt wyjściowy do scalenia gałęzi.

Zamiast zwykłego przeniesienia wskaźnika gałęzi do przodu, Git tworzy nową migawkę, która jest wynikiem wspomnianego scalenia trójstronnego i automatycznie tworzy nowy zestaw zmian, na ową migawkę wskazujący (patrz Rycina 3-17). Określane jest to mianem zmiany scalającej, która jest o tyle wyjątkowa, że ma więcej niż jednego rodzica.

Warto zaznaczyć, że Git sam określa najlepszego wspólnego przodka do wykorzystania jako punkt wyjściowy scalenia; różni się to od zachowania CVS czy Subversion (przed wersją 1.5), gdzie deweloper scalający zmiany musi punkt wyjściowy scalenia znaleźć samodzielnie. Czyni to scalanie w Gicie znacznie łatwiejszym, niż w przypadku tych systemów.

Insert 18333fig0317.png 
Rycina 3-17. Git automatycznie tworzy nowy zestaw zmian zawierający scaloną pracę.

Teraz kiedy twoja praca jest już scalona, nie potrzebujesz dłużej gałęzi `iss53`. Możesz ją usunąć, a następnie ręcznie zamknąć zgłoszenie w swoim systemie śledzenia zadań:

	$ git branch -d iss53

### Podstawowe konflikty scalania ###

Od czasu do czasu proces scalania nie przechodzi tak gładko. Jeśli ten sam plik zmieniłeś w różny sposób w obu scalanych gałęziach, Git nie będzie w stanie scalić ich samodzielnie. Jeśli twoja poprawka problemu #53 zmieniła tę samą część pliku, co `hotfix`, podczas scalania otrzymasz komunikat o konflikcie, wyglądający jak poniżej:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git nie zatwierdził automatycznie zmiany scalającej. Wstrzymał on cały proces do czasu rozwiązania konfliktu przez ciebie. Jeśli chcesz zobaczyć, które pliki pozostałe niescalone w dowolnym momencie po wystąpieniu konfliktu, możesz uruchomić `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Cokolwiek spowodowało konflikty i nie zostało automatycznie rozstrzygnięte, jest tutaj wymienione jako „unmerged” (niescalone). Git dodaje do konfliktujących plików standardowe znaczniki rozwiązania konfliktu, więc możesz owe pliki otworzyć ręcznie i rozwiązać konflikty. Twój plik zawiera teraz sekcję, która wygląda mniej więcej tak:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Oznacza to, że wersja wskazywana przez HEAD (twoja gałąź master, ponieważ tam właśnie byłeś podczas uruchamiania polecenia scalania) znajduje się w górnej części bloku (wszystko powyżej `======`), a wersja z gałęzi `iss53` to wszystko poniżej. Aby rozwiązać konflikt, musisz wybrać jedną lub druga wersję albo własnoręcznie połączyć zawartość obu. Dla przykładu możesz rozwiązać konflikt, zastępując cały blok poniższą zawartością: 

	<div id="footer">
	please contact us at email.support@github.com
	</div>

To rozwiązanie ma po trochu z obu części, całkowicie usunąłem także linie `<<<<<<<`, `=======` i `>>>>>>>`. Po rozstrzygnięciu wszystkich takich sekcji w każdym z konfliktujących plików, uruchom `git add` na każdym z nich, aby oznaczyć go jako rozwiązany. Przesunięcie do poczekalni oznacza w Gicie rozwiązanie konfliktu.
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

Jeśli jesteś zadowolony i potwierdziłeś, że wszystkie konfliktujące pliki zostały umieszczone w poczekalni, możesz wpisać `git commit`, by tym samym zatwierdzić zestaw zmian scalających. Jego domyślny opis wygląda jak poniżej:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Możesz go zmodyfikować, dodając szczegółowy opis sposobu scalenia zmian, jeśli tylko uważasz, że będą pomocne innym, gdy przyjdzie im oglądać efekt scalenia w przyszłości — dlaczego zrobiłeś to w taki, a nie inny sposób, jeśli nie jest to oczywiste.

## Zarządzanie gałęziami ##

Teraz, kiedy już stworzyłeś, scaliłeś i usunąłeś pierwsze gałęzie, spójrzmy na dodatkowe narzędzia do zarządzania gałęziami, które przydadzą się, gdy będziesz już używać gałęzi w swojej codziennej pracy.

Polecenie `git branch` robi więcej, aniżeli tylko tworzenie i usuwanie gałęzi. Jeśli uruchomisz je bez argumentów, otrzymasz prostą listę bieżących gałęzi:

	$ git branch
	  iss53
	* master
	  testing

Zauważ znak `*`, którym poprzedzona została gałąź `master`: wskazuje on aktywną gałąź. Oznacza to, że jeżęli w tym momencie zatwierdzisz zmiany, wskaźnik gałęzi `master` zostanie przesunięty do przodu wraz z nowo zatwierdzonymi zmianami. Aby obejrzeć ostatni zatwierdzony zestaw zmian na każdej z gałęzi, możesz użyć polecenia `git branch -v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Kolejna przydatna opcja pozwalająca na sprawdzenie stanu gałęzi to przefiltrowanie tej listy na gałęzie, które już zostały lub jeszcze nie zostały scalone do aktywnej gałęzi. Przydatne opcje `--merged` i `--no-merged` służą właśnie do tego celu i są dostępne w Gicie począwszy od wersji 1.5.6. Aby zobaczyć, które gałęzie zostały już scalone z bieżącą, uruchom polecenie `git branch --merged`:

	$ git branch --merged
	  iss53
	* master

Ponieważ gałąź `iss53` została już scalona, znalazła się ona na twojej liście. Gałęzie znajdujące się na tej liście a niepoprzedzone znakiem `*` można właściwie bez większego ryzyka usunąć poleceniem `git branch -d`; wykonaną na nich praca została już scalona do innej gałęzi, więc niczego nie stracisz.

Aby zobaczyć wszystkie gałęzie zawierające pracę, której jeszcze nie nie scaliłeś, możesz uruchomić polecenie `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Pokazuje to twoją drugą gałąź. Ponieważ zawiera ona pracę, która nie została jeszcze scalona, próba usunięcia jej poleceniem `git branch -d` nie powiedzie się:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Jeśli naprawdę chcesz usunąć gałąź i stracić tę część pracy, możesz wymusić to opcją `-D` zgodnie z tym, co podpowiada wiadomość na ekranie.

## Sposoby pracy w gałęziami ##

Teraz, kiedy poznałeś już podstawy gałęzi i scalania, co ze zdobytą wiedzą możesz i co powinieneś zrobić? W tej części zajmiemy się typowymi schematami pracy, które stają się osiągalne dzięki tak lekkiemu modelowi gałęzi. Pozwoli ci to samemu zdecydować, czy warto stosować je w swoim cyklu rozwoju projektów.

### Gałęzie długodystansowe ###

Ponieważ Git używa prostego scalania trójstronnego, scalanie zmian z jednej gałęzi do drugiej kilkukrotnie w długim okresie czasu jest ogólnie łatwe. Oznacza to, że możesz utrzymywać kilka gałęzi, które są zawsze otwarte i których używasz dla różnych etapów w cyklu rozwoju; możesz scalać zmiany regularnie z jednych gałęzi do innych.

Wielu programistów pracuje z Gitem wykorzystując to podejście, trzymając jedynie stabilny kod w gałęzi `master` — możliwe, że jedynie kod, który został już albo w najbliższej przyszłości zostanie wydany. Równolegle utrzymują oni inną gałąź o nazwie `develop` lub `next`, na której pracują lub używają jej do testowania stabilności — zawarta w niej praca nie musi być zawsze stabilna, lecz po stabilizacji może być scalona do gałęzi `master`. Taką gałąź wykorzystuje się także do wciągania zmian z gałęzi tematycznych (gałęzi krótkodystansowych, takich jak wcześniejsza `iss53`), kiedy są gotowe, aby przetestować je i upewnić się, że nie wprowadzają nowych błędów.

W rzeczywistości mówimy o wskaźnikach przesuwających się w górę po zatwierdzanych przez ciebie zestawach zmian. Stabilne gałęzie znajdują się niżej w historii, a gałęzie robocze na jej szczycie (patrz Rycina 3-18).

Insert 18333fig0318.png 
Rycina 3-18. Stabilniejsze gałęzie z reguły znajdują się niżej w historii zmian.

Ogólnie łatwiej jest myśleć o nich jak o silosach na pracę, gdzie grupy zmian są promowane do stabilniejszych silosów kiedy już zostaną przetestowane (Rycina 3-19).

Insert 18333fig0319.png 
Rycina 3-19. Może być ci łatwiej myśleć o swoich gałęziach jak o silosach.

Możesz powielić ten schemat na kilka poziomów stabilności. Niektóre większe projekty posiadają dodatkowo gałąź `proposed` albo `pu` („proposed updates” — proponowane aktualizacje), scalającą gałęzie, które nie są jeszcze gotowe trafić do gałęzi `next` czy `master`. Zamysł jest taki, że twoje gałęzie reprezentują różne poziomy stabilności; kiedy osiągają wyższy stopień stabilności, są scalane do gałęzi powyżej.
Podobnie jak poprzednio, posiadanie takich długodystansowych gałęzi nie jest konieczne, ale często bardzo pomocne, zwłaszcza jeśli pracujesz przy dużych, złożonych projektach.

### Gałęzie tematyczne ###
### Topic Branches ###

Gałęzie tematyczne, dla odmiany, przydadzą się w każdym projekcie, niezależnie od jego rozmiarów. Gałąź tematyczna to gałąź krótkodystansowa, którą tworzysz i używasz w celu stworzenia pojedynczej funkcji lub podobnej pracy. Z całą pewnością nie jest to coś czego chciałbyś używać pracując z wieloma innymi systemami kontroli wersji, ponieważ scalanie i odbijanie nowych gałęzi jest w nich ogólnie mówiąc zbyt kosztowne. W Gicie tworzenie, praca wewnątrz jak i scalanie gałęzi kilkukrotnie w ciągu dnia jest powszechnie stosowane i naturalne.
Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and use for a single particular feature or related work. This is something you’ve likely never done with a VCS before because it’s generally too expensive to create and merge branches. But in Git it’s common to create, work on, merge, and delete branches several times a day.

Widziałeś to w poprzedniej sekcji kiedy pracowaliśmy z gałęziami `iss53` i `hotfix`. Stworzyłeś wewnątrz nich kilka rewizji po czym usunąłeś je zaraz po scaleniu zmian z gałęzią główną. Ta technika pozwala na szybkie i efektywne przełączanie kontekstu - ponieważ twój kod jest wyizolowany w osobnych silosach, w których wszystkie zmiany są związane z pracą do jakiej została stworzona gałąź, znacznie łatwiej jest połapać się w kodzie podczas recenzowania i temu podobnych. Możesz umieszczać tam swoje zmiany przez kilka minut, dni, miesięcy i scalać je dopiero kiedy są gotowe, bez znaczenia w jakiej kolejności zostały stworzone oraz w jaki sposób przebiegała praca nad nimi.
You saw this in the last section with the `iss53` and `hotfix` branches you created. You did a few commits on them and deleted them directly after merging them into your main branch. This technique allows you to context-switch quickly and completely — because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.

Rozważ przykład wykonywania pewnej pracy (na gałęzi głównej), odbicia gałęzi na konkretny problem (`iss91`), pracy na niej przez chwilę, odbicia drugiej gałęzi w celu wypróbowania innego sposobu rozwiązania tego samego problemu (`iss91v2`), powrotu do gałęzi głównej i pracy nim przez kolejną chwilę, a następnie odbicia tam kolejnej gałęzi do wykonania pracy co do której nie jesteś pewny czy jest dobrym pomysłem (gałąź `dumbidea`). Twoja historia rewizji będzie wygląda mniej więcej tak:
Consider an example of doing some work (on `master`), branching off for an issue (`iss91`), working on it for a bit, branching off the second branch to try another way of handling the same thing (`iss91v2`), going back to your master branch and working there for a while, and then branching off there to do some work that you’re not sure is a good idea (`dumbidea` branch). Your commit history will look something like Figure 3-20.

Insert 18333fig0320.png 
Rysunek 3-20. Twoja historia rewizji zawierająca kilka gałęzi tematycznych.
Figure 3-20. Your commit history with multiple topic branches.

Teraz, powiedzmy, że decydujesz się że najbardziej podoba ci się drugie rozwiązanie twojego problemu (`iss91v2`); zdecydowałeś się także pokazać gałąź `dumbidea` swoim współpracownikom i okazało się, że jest genialna. Możesz wyrzucić oryginalne rozwiązanie problemu znajdujące się w gałęzi `iss91` (tracąc rewizje C5 i C6) i scalić dwie pozostałe gałęzie. Twoja historia będzie wyglądać tak jak na Rysunku 3-21.
Now, let’s say you decide you like the second solution to your issue best (`iss91v2`); and you showed the `dumbidea` branch to your coworkers, and it turns out to be genius. You can throw away the original `iss91` branch (losing commits C5 and C6) and merge in the other two. Your history then looks like Figure 3-21.

Insert 18333fig0321.png 
Rysunek 3-21. Historia zmian po scaleniu gałęzi dumbidea i iss91v2.
Figure 3-21. Your history after merging in dumbidea and iss91v2.

Ważne żeby pamiętać robiąc to wszystko, że są to zupełnie lokalne gałęzie. Odbijając nowe gałęzie i scalając je później robisz to wyłącznie w ramach własnego repozytorium - bez jakiejkolwiek komunikacji z serwerem.
It’s important to remember when you’re doing all this that these branches are completely local. When you’re branching and merging, everything is being done only in your Git repository — no server communication is happening.

## Gałęzie zdalne ##
## Remote Branches ##

Zdalne gałęzie są odnośnikami do stanu gałęzi w zdalnym repozytorium. Są to lokalne gałęzie, których nie możesz przenosić; są one przenoszone automatycznie za każdym razem kiedy wykonujesz jakieś operacje zdalne[FIXME]. Zdalne gałęzie zachowują się jak zakładki przypominające ci gdzie znajdowały się gałęzie w twoim zdalnym repozytorium ostatnim razem kiedy się z nim łączyłeś.
Remote branches are references to the state of branches on your remote repositories. They’re local branches that you can’t move; they’re moved automatically whenever you do any network communication. Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.

Przybierają one następującą formę: `(nazwa_zdalnego_repo)/(gałąź). Na przykład, gdybyś chciał zobaczyć jak wygląda gałąź master w zdalnym repozytorium `origin` z chwili kiedy po raz ostatni się z nim komunikowałeś, musiałbyś sprawdzić gałąź `origin/master`. Jeśli na przykład pracowałeś nad zmianą wraz z partnerem który wypchnął gałąź `iss53`, możesz mieć lokalną gałąź `iss53`, ale gałąź na serwerze będzie wskazywała rewizję znajdującą się pod `origin/iss53`.
They take the form `(remote)/(branch)`. For instance, if you wanted to see what the `master` branch on your `origin` remote looked like as of the last time you communicated with it, you would check the `origin/master` branch. If you were working on an issue with a partner and they pushed up an `iss53` branch, you might have your own local `iss53` branch; but the branch on the server would point to the commit at `origin/iss53`.

Może być to nieco mylące, więc przyjrzyjmy się dokładniej przykładowi. Powiedzmy, że masz serwer Gita w swojej sieci pod adresem `git.ourcompany.com`. Po sklonowaniu go, Git automatycznie nazwie serwer jako `origin`, pobierze wszystkie dane, stworzy wskaźnik do miejsca gdzie znajduje się gałąź `master` i nazwie ją lokalnie `origin/master`; nie będziesz mógł jej przesunąć. Git da ci także do pracy twoją własną gałąź `master` zaczynającą się w tym samym miejscu co zdalna (zobacz Rysunek 3-22).
This may be a bit confusing, so let’s look at an example. Let’s say you have a Git server on your network at `git.ourcompany.com`. If you clone from this, Git automatically names it `origin` for you, pulls down all its data, creates a pointer to where its `master` branch is, and names it `origin/master` locally; and you can’t move it. Git also gives you your own `master` branch starting at the same place as origin’s `master` branch, so you have something to work from (see Figure 3-22).

Insert 18333fig0322.png
Rysunek 3-22. Po sklonowaniu otrzymasz własną gałąź główną oraz zdalną origin/master wskazującą na gałąź w zdalnym repozytorium.
Figure 3-22. A Git clone gives you your own master branch and origin/master pointing to origin’s master branch.

Jeśli wykonasz jakąś pracę na gałęzi głównej a w międzyczasie ktoś inny wypchnie zmiany na `git.ourcompany.com` i zaktualizuje jego gałąź główną, wówczas wasze historie przesuną się do przodu w różny sposób. Co więcej, dopóki nie skontaktujesz się z serwerem zdalnym, twój wskaźnik `origin/master` się nie przesunie (Rysunek 3-23).
If you do some work on your local master branch, and, in the meantime, someone else pushes to `git.ourcompany.com` and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your `origin/master` pointer doesn’t move (see Figure 3-23).

Insert 18333fig0323.png 
Rysunek 3-23. Kiedy pracujesz lokalnie wypchnięcie przez kogoś zmian na serwer powoduje, że obie historie zaczynają przesuwać się do przodu odmiennie.
Figure 3-23. Working locally and having someone push to your remote server makes each history move forward differently.

Aby zsynchronizować pracę uruchom polecenie `git fetch origin`. Zajrzy ono na serwer na który wskazuje skrót origin (w tym wypadku `git.ourcompany.com`), pobierze z niego wszystkie dane których jeszcze nie masz u siebie i zaktualizuje twoją lokalną bazę danych przesuwając jednocześnie wskaźnik `origin/master` do nowej, aktualniejszej pozycji (zobacz Rysunek 3-24).
To synchronize your work, you run a `git fetch origin` command. This command looks up which server origin is (in this case, it’s `git.ourcompany.com`), fetches any data from it that you don’t yet have, and updates your local database, moving your `origin/master` pointer to its new, more up-to-date position (see Figure 3-24).

Insert 18333fig0324.png 
Rysunek 3-24. Polecenie git fetch aktualizuje zdalne referencje.
Figure 3-24. The git fetch command updates your remote references.

Aby zaprezentować posiadanie kilku zdalnych serwerów oraz wygląd ich zdalnych gałęzi, załóżmy, że posiadasz jeszcze jeden wewnętrzny serwer Gita, który jest używany wyłącznie przez jeden z twoich zespołów sprinterskich. Jest to serwer dostępny pod adresem `git.team1.ourcompany.com`. Możesz go dodać do projektu nad którym pracujesz jako nowy zdalny odnośnik uruchamiając polecenie `git remote add` tak jak pokazaliśmy to w rozdziale 2. Nazwij go skrótem `teamone`, którego będziesz dalej używał zamiast pełnego adresu URL (rysunek 3-25).
To demonstrate having multiple remote servers and what remote branches for those remote projects look like, let’s assume you have another internal Git server that is used only for development by one of your sprint teams. This server is at `git.team1.ourcompany.com`. You can add it as a new remote reference to the project you’re currently working on by running the `git remote add` command as we covered in Chapter 2. Name this remote `teamone`, which will be your shortname for that whole URL (see Figure 3-25).

Insert 18333fig0325.png 
Rysunek 3-25. Dodanie kolejnego zdalnego serwera.
Figure 3-25. Adding another server as a remote.

Możesz teraz uruchomić polecenie `git fetch teamone` aby pobrać wszystko co znajduje się na serwerze a czego ty jeszcze nie masz lokalnie. Ponieważ serwer ten jest podzbiorem danych jakie zawiera serwer `origin`, Git nie pobiera niczego ale ustawia go jako zdalną gałąź `teamone/master` wskazującą na rewizję wykonaną w gałęzi `teamone` i jej gałęzi `master` (rysunek 3-26).
Now, you can run `git fetch teamone` to fetch everything server has that you don’t have yet. Because that server is a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (see Figure 3-26).

Insert 18333fig0326.png 
Rysunek 3-26. Dostajesz lokalny odnośnik do głównej gałęzi teamone.
Figure 3-26. You get a reference to teamone’s master branch position locally.

### Wypychanie zmian ###
### Pushing ###

Jeśli chcesz podzielić się swoją gałęzią ze światem musisz wypchnąć zmiany na zdalny serwer na którym masz prawa zapisu. Twoje lokalne gałęzie nie są automatycznie synchronizowane z serwerem na którym zapisujesz - musisz konkretnie wypchnąć zmiany z gałęzi, którą chcesz się podzielić. W ten sposób możesz używać prywatnych gałęzi do pracy, której nie chcesz dzielić, i wypychać jedynie gałęzie tematyczne w których chcesz brać udział.
When you want to share a branch with the world, you need to push it up to a remote that you have write access to. Your local branches aren’t automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share. That way, you can use private branches for work you don’t want to share, and push up only the topic branches you want to collaborate on.

Jeśli posiadasz gałąź o nazwie `serverfix` w której tworzeniu chcesz współuczestniczyć z innymi, możesz wypchnąć swoje zmiany w taki sam sposób jak wypychałeś je w przypadku pierwszej gałęzi. Uruchom `git push (skrót_do_zdalnego_repo) (gałąź)`:
If you have a branch named `serverfix` that you want to work on with others, you can push it up the same way you pushed your first branch. Run `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Jest to drobny skrót. Git automatycznie sam rozwija nazwę `serverfix` do pełnej `refs/heads/serverfix:refs/heads/serverfix`, co oznacza "Weź moją lokalną gałąź serverfix i wypchnij zmiany, aktualizując zdalną gałąź serverfix". Zajmiemy się w szczegółach częścią `refs/heads/` w rozdziale 9, ale ogólnie nie powinieneś się tym przejmować. Możesz także wykonać `git push origin serverfix:serverfix` co spowoduje taki sam efekt - dla Gita znaczy to "Weź moją gałąź serverfix i uaktualnij nią zdalną gałąź serverfix". Możesz używać tego formatu do wypychania lokalnych gałęzi do zdalnych o innej nazwie. Gdybyś nie chciał żeby gałąź na serwerze nazywała się `serverfix` mógłbyś uruchomić polecenie w formie `git push origin serverfix:innanazwagalezi` co spowodowałoby wypchnięcie gałęzi `serverfix` do `innanazwagalezi` w zdalnym projekcie.
This is a bit of a shortcut. Git automatically expands the `serverfix` branchname out to `refs/heads/serverfix:refs/heads/serverfix`, which means, “Take my serverfix local branch and push it to update the remote’s serverfix branch.” We’ll go over the `refs/heads/` part in detail in Chapter 9, but you can generally leave it off. You can also do `git push origin serverfix:serverfix`, which does the same thing — it says, “Take my serverfix and make it the remote’s serverfix.” You can use this format to push a local branch into a remote branch that is named differently. If you didn’t want it to be called `serverfix` on the remote, you could instead run `git push origin serverfix:awesomebranch` to push your local `serverfix` branch to the `awesomebranch` branch on the remote project.

Następnym razem kiedy twoi współpracownicy pobiorą dane z serwera uzyskają referencję do miejsca gdzie została zapisana twoja wersja `serverfix` pod zdalną gałęzią `origin/serverfix`:
The next time one of your collaborators fetches from the server, they will get a reference to where the server’s version of `serverfix` is under the remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Warto zauważyć, że kiedy podczas pobierania ściągasz nową, zdalną gałąź, nie uzyskujesz automatycznie lokalnej, edytowalnej jej wersji. Inaczej mówiąc, w tym przypadku, nie masz nowej gałęzi `serverfix` na której możesz do razu pracować - masz jedynie wskaźnik `origin/serverfix` którego nie można modyfikować.
It’s important to note that when you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. In other words, in this case, you don’t have a new `serverfix` branch — you only have an `origin/serverfix` pointer that you can’t modify.

Aby scalić pobraną pracę z bieżącą gałęzią roboczą uruchom polecenie `git merge origin/serverfix`. Jeśli chcesz własną gałąź `serverfix` na której będziesz mógł pracować dalej, możesz ją stworzyć bazują na zdalnej gałęzi w następujący sposób:
To merge this work into your current working branch, you can run `git merge origin/serverfix`. If you want your own `serverfix` branch that you can work on, you can base it off your remote branch:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Otrzymasz lokalną gałąź na której będziesz mógł rozpocząć pracę od momentu gdzie znajduje się ona w zdalnej gałązi `origin/serverfix`.
This gives you a local branch that you can work on that starts where `origin/serverfix` is.

### Gałęzie śledzące ###
### Tracking Branches ###

Przełączenie do lokalnej gałęzi ze zdalnej automatycznie tworzy coś co określa się jako _gałąź śledzącą_. Gałęzie śledzące są gałęziami lokalnymi, które posiadają bezpośrednią relację do gałęzi zdalnej. Jeśli znajdujesz się w gałęzi śledzącej po wpisaniu git push, Git automatycznie wie na który serwer i wypchnąć zmiany. Podobnie, uruchomienie `git pull` w jednej z takich gałęzi pobiera wszystkie dane ze zdalnej referencji i automatycznie scala je z odpowiednią gałęzią zdalną.
Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type git push, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.

Po sklonowaniu repozytorium, ogólnie mówiąc, automatycznie tworzona jest gałąź `master`, która śledzi `origin/master`. Z tego właśnie powodu `git push` i `git pull` działa prosto z pudełka, bez dodatkowych argumentów. Jednakże, możesz sobie ustawić inne gałęzie tak, żeby śledziły zdalne odpowiedniki. Prosty przypadek to przywołany już wcześniej przykład polecenia `git checkout -b [gałąź] [nazwa_zdalnego_repo]/[gałąź]`. Jeśli pracujesz z Gitem młodszym niż 1.6.2, możesz także użyć skrótu `--track`:
When you clone a repository, it generally automatically creates a `master` branch that tracks `origin/master`. That’s why `git push` and `git pull` work out of the box with no other arguments. However, you can set up other tracking branches if you wish — ones that don’t track branches on `origin` and don’t track the `master` branch. The simple case is the example you just saw, running `git checkout -b [branch] [remotename]/[branch]`. If you have Git version 1.6.2 or later, you can also use the `--track` shorthand:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Żeby ustawić lokalną gałąź z inną nazwą niż zdalna, możesz korzystać z pierwszej wersji polecenia podając własną nazwę:
To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Teraz twoja lokalna gałąź sf będzie pozawalała na automatyczne wypychanie zmian jak i ich pobieranie z origin/serverfix.
Now, your local branch sf will automatically push to and pull from origin/serverfix.

### Usuwanie zdalnych gałęzi ###
### Deleting Remote Branches ###

Załóżmy, że skończyłeś pracę ze zdalną gałęzią - powiedzmy, że ty i twoi współpracownicy zakończyliście pracę na nową funkcją i scaliliście zmiany ze zdalną gałęzią główną `master` (czy gdziekolwiek indziej, gdzie znajduje się stabilna wersja kodu). Możesz usunąć zdalną gałąź używając raczej niezbyt intuicyjnej składni `git push [remotename] :[gałąź]`. Aby np. usunąć z serwera gałąź `serverfix` uruchom polecenie:
Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. Nie ma już na serwerze tej gałęzi. Jeśli chcesz, zaznacz sobie tą stronę ponieważ będziesz potrzebował tego polecenia a najprawdopodobniej zapomnisz jego składnię. Polecenie to można spróbować zapamiętać przywołując składnię `git push [nazwa serwera] [gałąź lokalna]:[gałąź zdalna]`, którą omówiliśmy odrobinę wcześniej. Pozbywając się części [gałąź lokalna], mówisz mniej więcej "Weź nic z mojej strony i zrób z tego [gałąź zdalną]".
Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

## Zmiana bazy ##
## Rebasing ##

W Gitcie są dwa główne sposoby integrowania zmian z jednej do drugie gałęzi: scalanie `merge` oraz zmiana bazy - polecenie `rebase`. W tym rozdziale dowiesz się czym jest zmiana bazy, jak ją robić, dlaczego jest to tak świetne narzędzie i w jakich przypadkach nie będziesz chciał go użyć.
In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### Podstawowa zmiana bazy ###
### The Basic Rebase ###

Jeśli cofniesz się do poprzedniego przykładu z sekcji Scalanie (zobacz rysunek 3-27), zobaczysz, że rozszczepiłeś swoją pracę i wykonywałeś rewizje na dwóch różnych gałęziach.
If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png 
Rysunek 3-27. Początkowa historia po rozszczepieniu.
Figure 3-27. Your initial diverged commit history.

Najprostszym sposobem aby zintegrować gałęzie, jak już napisaliśmy, jest polecenie `merge`. Przeprowadza ono trójnożne scalanie pomiędzy dwoma ostatnimi migawkami gałęzi (C3 i C4) oraz ich najmłodszym wspólnym przodkiem (C2), tworząc nową migawkę (oraz rewizję), tak jak widać to na rysunku 3-28.
The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.

Insert 18333fig0328.png 
Rysunek 3-28. Scalanie gałęzi integrujące rozszczepioną historię zmian.
Figure 3-28. Merging a branch to integrate the diverged work history.

Jednakże, istnieje inny sposób: możesz stworzyć łatkę ze zmianami wprowadzonymi w C3 i zaaplikować ją na końcu C4. W Git-cie nazywa się to zmianą bazy lub _rebasing-iem_. Dzięki poleceniu `rebase`, możesz wziąć wszystkie zmiany, które zostały zatwierdzone w jednej gałęzi i odtworzyć je w innej.
However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

W tym wypadku, mógłbyś uruchomić następujące polecenie:
In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Polecenie to działa idąc do najmłodszego, wspólnego przodka obu gałęzi (tej w której się znajdujesz oraz tej do której robisz rebase), pobierając różnice opisujące kolejne zmiany (diff-y) wprowadzane przez kolejne rewizje w gałęzi w której się znajdujesz, zapisując je w tymczasowych plikach, następnie resetuje gałąź do tej samej rewizji do której wykonujesz operację rebase, po czym aplikuje po kolei zapisane zmiany (diff-y). Ilustruje to rysunek 3-29.
It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.

Insert 18333fig0329.png 
Rysunek 3-29. Zmiana bazy dla zmian wprowadzonych w C3 do C4.
Figure 3-29. Rebasing the change introduced in C3 onto C4.

W tym momencie, możesz wrócić do gałęzi `master` i scalić zmiany w prostej linii (co przesunie wksaźnik master na koniec) (rysunek 3-30).
At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).

Insert 18333fig0330.png 
Figure 3-30. Przesunięcie gałęzi master po operacji rebase.
Figure 3-30. Fast-forwarding the master branch.

Teraz migawka wskazywana przez C3 jest dokładnie taka sama jak ta na którą wskazuje C5 w przykładzie ze scalaniem. Nie ma różnicy w produkcie końcowym integracji. Rebasing tworzy jednak czystszą historię. Jeśli przejrzysz historię gałęzi o zmienionej bazie wygląda ona na liniową: wygląda jakby cała praca była wykonywana w seriach, nawet jeśli oryginalnie odbywała się równolegle.
Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Często będziesz chciał z tego skorzystać aby upewnić się, że rewizje czysto aplikują się do zdalnej gałęzi - być może w projekcie w którym próbujesz się udzielać a którego nie utrzymujesz ani nie prowadzisz. W takim wypadku, będziesz wykonywał swoją pracę we własnej gałęzi a następnie zmieniał jej bazę na `origin/master` jak tylko będziesz gotowy do wprowadzenia własnych poprawek do głównego projektu. W ten sposób, osoba utrzymująca projekt nie będzie musiała dodatkowo wykonywać integracji - jedynie prostolinijne scalenie lub czystą aplikacja zmian.
Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Zauważ, że migawka wskazywana przez ostateczną rewizję z jaką skończysz, bez znaczenia czy jest to ostatnia rebase-owana rewizja lub ostateczna rewizja scalająca po operacji scalania, jest to ta sama migawka - jedynie historia może się różnić. Zmiana bazy nanosi zmiany z jednej linii pracy do innej w kolejności w jakiej były one zgłaszane, w odróżnieniu od scalania, które bierze dwie końcówki i integruje je ze sobą.
Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### Ciekawsze zmiany baz ###
### More Interesting Rebases ###

Możesz także odtworzyć zmiany z operacji rebase na czymś innym niż gałąź w której zmieniasz bazę. Dla przykładu weź historię taką jak na rysunku 3-31. Odbiłeś gałąź tematyczną (`server`) żeby dodać nowe funkcje do kodu serwera w tym projekcie, po czym wykonałeś rewizję. Następnie odbiłeś gałąź żeby wykonać zmiany w kliencie (`client`) i kilkukrotnie zatwierdziłeś zmiany. Ostatecznie wróciłeś do gałęzi `server` i wykonałeś kolejne kilka rewizji.
You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
Figure 3-31. Historia z gałęzią tematyczną odbitą od innej gałęzi tematycznej.
Figure 3-31. A history with a topic branch off another topic branch.

Załóżmy, że zdecydowałeś się scalić zmiany w kliencie do kodu głównego, ale chcesz się jeszcze wstrzymać ze zmianami w serwerze dopóki nie zostaną one dokładniej przetestowane. Możesz wziąć zmiany w kodzie klienta, których nie ma w kodzie serwera (C8 i C9) i odtworzyć je na gałęzi głównej używając opcji `--onto` polecenia `git rebase`:
Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

Mówi to ni mniej ni więcej jak "Przełącz się do gałęzi klienta, wydedukuj łatki od wspólnego przodka gałęzi `client` i `server`, a następnie nanieś je na gałąź główną `master`. Jest to nieco skomplikowane, ale wynik, pokazany na rysunku 3-32, całkiem niezły.
This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
Rysunek 3-32. Zmiana bazy gałęzi tematycznej odbitej z innej gałęzi tematycznej.
Figure 3-32. Rebasing a topic branch off another topic branch.

Teraz możesz szybko przesunąć wskaźnik gałęzi głównej do przodu (rysunek 3-33):
Now you can fast-forward your master branch (see Figure 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Rysunek 3-33. Szybkie przesunięcie do przody gałęzi master dołączające zmiany z gałęzi klienta.
Figure 3-33. Fast-forwarding your master branch to include the client branch changes.

Powiedzmy, że zdecydujesz pobrać i scalić zmiany z gałęzi server. Możesz zmienić bazę gałęzi server na wskazywaną przez master bez konieczności przełączania się do niej używając `git rebase [gałąź bazowa] [gałąź tematyczna]` - w ten sposób zmiany z gałęzi `server` zostaną zaaplikowane do gałęzi bazowej `master`:
Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

Polecenie odtwarza zmiany z gałęzi `server` na gałęzi `master`, tak jak pokazuje to rysunek 3-34.
This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
Rysunek 3-34. Zmiana bazy gałęzi serwera na koniec gałęzi głównej.
Figure 3-34. Rebasing your server branch on top of your master branch.

Następnie możesz przesunąć gałąź bazową (`master`):
Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

Możesz teraz usunąć gałęzie `client` i `server` ponieważ cała praca jest już zintegrowana i więcej ich nie potrzebujesz, pozostawiając historię w stanie takim jaki obrazuje rysunek 3-35:
You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Rysunek 3-35. Ostateczna historia rewizji.
Figure 3-35. Final commit history.

### Zagrożenia operacji rebase ###
### The Perils of Rebasing ###

Błogosławieństwo jakim jest możliwość zmiany bazy nie jest pozbawiona oczywiście kolców. Można je podsumować pojedynczą linijką:
Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Nie zmieniaj bazy rewizji, które wypchnąłeś już do publicznego repozytorium.**
**Do not rebase commits that you have pushed to a public repository.**

Jeśli będziesz się stosował do tej reguły, wszystko będzie dobrze. W przeciwnym razie, ludzie cię znienawidzą a rodzina i przyjaciele zaczną omijać szerokim łukiem.
If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

Stosując operację rebase porzucasz istniejące rewizje i tworzysz nowe, które są podobne, ale inne. Wypychasz gdzieś swoje zmiany, inni je pobierają i scalają i pracują na nich a następnie nadpisujesz te zmiany poleceniem `git rebase` i wypychasz ponownie na serwer. Twoi współpracownicy będą musieli scalić swoją pracę raz jeszcze i zrobi się bałagan kiedy spróbujesz pobrać i scalić ich pracę z powrotem z twoją.
When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Spójrzmy na przykład pokazujący operacja zmiany bazy może spowodować problemy. Załóżmy, że sklonujesz repozytorium z centralnego serwera a następnie wykonasz bazując na tym nowe zmiany. Twoja historia rewizji wygląda tak jak na rysunku 3-36.
Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
Figure 3-36. Sklonowane repozytorium i bazująca na tym praca.
Figure 3-36. Clone a repository, and base some work on it.

Teraz ktoś inny wykonuje inna pracę, która obejmuje scalenie, i wypycha ją na centralny serwer. Pobierasz zmiany, scalasz nową, zdalną gałąź z własną pracą, w wyniku czego historia wygląda mniej więcej tak jak na rysunku 3-37.
Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
Rysunek 3-37. Pobranie kolejnych rewizji i scalenie ich z własną pracą.
Figure 3-37. Fetch more commits, and merge them into your work.

Następnie, osoba która wypchnęła scalone zmiany zdecydowała się wrócić i zmienić bazę swojej pracy; robi `git push --force` żeby zastąpić historię na serwerze. Następnie ty pobierasz dane z serwera ściągając nowe rewizje.
Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
Rysunek 3-38. Ktoś wypycha rewizje po operacji zmiany bazy, porzucając rewizje na których ty oparłeś swoją pracę.
Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

W tym momencie musisz raz jeszcze scalać tą pracę, pomimo, że już to wcześniej raz zrobiłeś. Operacja rebase zmienia sumy kontrolne SHA-1 tych rewizji więc dla Gita wyglądają one jak zupełnie nowe, pomimo, że w rzeczywistości masz już zmiany C4 w swojej historii (rysunek 3-39).
At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).

Insert 18333fig0339.png 
Rysunek 3-39. Scalasz tą samą pracę raz jeszcze tworząc nową rewizję scalającą.
Figure 3-39. You merge in the same work again into a new merge commit.

Musisz scalić swoją pracę w pewnym momencie tak żeby dotrzymywać kroku innemu programiście. Kiedy już to zrobisz twoja historia zmian będzie zawierać zarówno rewizje C4 jak i C4', które mają różne sumy SHA-1 ale wnoszą tą samą pracę i mają tą samą notkę. Jeśli uruchomisz `git log` dla takiej historii zobaczysz dwie rewizje mające tego samego autora, datę oraz notkę, co będzie mylące. Co więcej, jeśli wypchniesz tą historię z powrotem na serwer, raz jeszcze przedstawisz wszystkie rewizje powstałe w wyniku operacji rebase na serwerze centralnym, co może dalej zmylić i zdenerwować ludzi.
You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

Jeśli traktujesz zmianę bazy jako sposób na oczyszczanie historii i sposób pracy z rewizjami przed wypchnięciem ich na serwer oraz jeśli zmieniasz bazę tylko rewizjom, które nigdy wcześniej nie były dostępne publicznie, wówczas wszystko będzie w porządku. Jeśli zaczniesz zmieniać bazę rewizjom, które były już wcześniej publicznie dostępne, a ludzie mogą na nich bazować swoje zmiany, wówczas możesz wpaść w naprawdę frustrujące tarapaty.
If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## Podsumowanie ##
## Summary ##

Omówiliśmy podstawy odbijania gałęzi oraz scalania w Git-a. Powinieneś już z łatwością tworzyć gałęzie, przełączać się pomiędzy nimi i scalać zawarte w nich zmiany. Powinieneś także umieć współdzielić swoje gałęzie wypychając je na serwer, pracować z innymi w współdzielonych gałęziach oraz zmieniać bazę gałęziom zanim zostaną pokazane innym.
We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
