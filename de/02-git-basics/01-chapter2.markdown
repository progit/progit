# Git Grundlagen #

Wenn Du nur ein einziges Kapitel aus diesem Buch lesen willst, um mit Git loslegen zu können, dann lies dieses hier. Wir werden hier auf die grundlegenden Git Befehle eingehen, die du für den größten Teil deiner täglichen Arbeit mit Git brauchst. Am Ende des Kapitels solltest du in der Lage sein, ein neues Repository anzulegen und zu konfigurieren, Dateien zur Versionskontrolle hinzuzufügen und wieder aus ihr zu entfernen, Änderungen in der Staging Area für einen Commit vorzumerken und schließlich einen Commit durchzuführen. Wir werden außerdem besprechen, wie du Git so konfigurieren kannst, dass es bestimmte Dateien und Dateimuster ignoriert, wie du Fehler schnell und einfach rückgängig machen, wie du die Historie deines Projektes durchsuchen und Änderungen zwischen bestimmten Commits nachschlagen, und wie du in externe Repositorys herauf- und von dort herunterladen kannst.

## Ein Git Repository anlegen ##

Es gibt grundsätzlich zwei Möglichkeiten, ein Git Repository auf dem eigenen Rechner anzulegen. Erstens kann man ein existierendes Projekt oder Verzeichnis in ein neues Git Repository importieren. Zweitens kann man ein existierendes Repository von einem anderen Rechner, der als Server fungiert, auf den eigenen Rechner klonen.

### Ein existierendes Verzeichnis als Git Repository initialisieren ###

Wenn du künftige Änderungen an einem bestehenden Projekt auf Deinem Rechner mit Git versionieren und nachverfolgen willst, kannst du dazu einfach in das jeweilige Verzeichnis gehen und diesen Befehl ausführen:

	$ git init

Das erzeugt ein Unterverzeichnis `.git`, in dem alle relevanten Git Repository Dateien enthalten sind, also ein Git Repository Grundgerüst. Zu diesem Zeitpunkt werden noch keine Dateien in Git versioniert. (In Kapitel 9 werden wir genauer darauf eingehen, welche Dateien im .git Verzeichnis enthalten sind und was ihre Aufgabe ist.)

Wenn in deinem Projekt bereits Dateien vorhanden sind (und es sich nicht nur um ein leeres Verzeichnis handelt), willst du diese vermutlich zur Versionskontrolle hinzufügen, damit Änderungen daran künftig nachverfolgbar sind. Dazu kannst du die folgenden Git Befehle ausführen, die Dateien zur Versionskontrolle hinzufügen und anschließend einen ersten Commit anlegen:

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

Wir werden gleich noch einmal genauer auf diese Befehle eingehen. Im Moment ist nur wichtig zu verstehen, dass du jetzt ein Git Repository erzeugt und einen ersten Commit angelegt hast.

### Ein existierendes Repository klonen ###

Wenn du eine Kopie eines existierenden Git Repositorys anlegen willst - z.B. um an einem Projekt mitzuarbeiten - dann kannst du dazu den Befehl `git clone` verwenden. Wenn du schon mit anderen VCS Sytemen wie Subversion gearbeitet hast, wird dir auffallen, dass der Befehl `clone` heißt und nicht `checkout`. Dies ist ein wichtiger Unterschied, den du verstehen solltest. Git lädt eine Kopie fast aller Daten, die sich im existierenden Repository befinden, auf deinen Rechner. Mit `git clone` wird jede einzelne Version jeder einzelnen Datei in der Historie des Repositorys heruntergeladen. Wenn ein Repository auf einem Server einmal beschädigt wird (z.B. weil die Festplatte beschädigt wird), kann man tatsächlich jeden beliebigen Klon des Repositorys verwenden, um das Repository auf dem Server wieder in dem Zustand wieder herzustellen, in dem es sich befand, als es geklont wurde. (Es kann passieren, dass man einige auf dem Server vorhandenen Hooks verliert, aber alle versionierten Daten bleiben erhalten. In Kapitel 4 gehen wir darauf noch einmal genauer ein.)

Du kannst ein Repository mit dem Befehl `git clone [url]` klonen. Um beispielsweise das Repository der Ruby Git Bibliothek Grit zu klonen, führst du den folgenden Befehl aus:

	$ git clone git://github.com/schacon/grit.git

Git legt dann ein Verzeichnis `grit` an, initialisiert ein `.git` Verzeichnis darin, lädt alle Daten des Repositorys herunter, und checkt eine Arbeitskopie der letzten Version aus. Wenn Du in das neue `grit` Verzeichnis wechselst, findest du dort die in diesem Projekt enthaltenen Dateien und kannst sie benutzen oder bearbeiten. Wenn du das Repository in ein Verzeichnis mit einem anderen Namen als `grit` klonen willst, kannst du das wie folgt angeben:

	$ git clone git://github.com/schacon/grit.git mygrit

Dieser Befehl tut das gleiche wie der vorhergehende, aber das Zielverzeichnis ist diesmal `mygrit`.

Git unterstützt eine Reihe unterschiedlicher Übertragungsprotokolle. Das vorhergehende Beispiel verwendet das `git://` Protokoll, aber du wirst auch `http(s)://` oder `user@server:/path.git` finden, die das SSH Protokoll verwenden. In Kapitel 4 gehen wir auf die verfügbaren Optionen (und deren Vor- und Nachteile) ein, die ein Server hat, um Zugriff auf ein Git Repository zu erlauben.

## Änderungen am Repository nachverfolgen ##

Du hast jetzt ein voll funktionsfähiges Git Repository und eine Arbeitskopie des Projekts ist in deinem Verzeichnis ausgecheckt. Du kannst nun die Dateien im Projekt bearbeiten. Immer wenn dein Projekt einen Zustand erreicht hat, den du festhalten willst, musst du diese Änderungen einchecken.

Jede Datei in deinem Arbeitsverzeichnis kann sich in einem von zwei Zuständen befinden: Änderungen werden verfolgt (engl. tracked) oder nicht (engl. untracked). Alle Dateien, die sich im letzten Snapshot (Commit) befanden, werden in der Versionskontrolle verfolgt. Sie können entweder unverändert (engl. unmodified), modifiziert (engl. modified) oder für den nächsten Commit markiert (engl. staged) sein. Alle anderen Dateien in deinem Arbeitsverzeichnis dagegen sind nicht versioniert: das sind all diejenigen Dateien, die nicht schon im letzten Snapshot enthalten waren und die sich nicht in der Staging Area befinden. Wenn Du ein Repository gerade geklont hast, sind alle Dateien versioniert und unverändert - du hast sie gerade ausgecheckt aber noch nichts verändert.

Sobald du versionierte Dateien bearbeitest, wird Git sie als modifiziert erkennen, weil du sie seit dem letzten Commit geändert hast. Du merkst diese geänderten Dateien für den nächsten Commit vor (d.h. du fügst sie zur Staging Area hinzu bzw. du stagest sie), legst aus allen markierten Änderungen einen Commit an und der Vorgang beginnt von vorn. Bild 2-1 stellt diesen Zyklus dar:

Insert 18333fig0201.png
Bild 2-1. Zyklus der Grundzustände deiner Dateien

### Den Zustand deiner Dateien prüfen ###

Das wichtigste Hilfsmittel, um den Zustand zu überprüfen, in dem sich die Dateien in deinem Repository gerade befinden, ist der Befehl `git status`. Wenn du diesen Befehl ausführst, unmittelbar nachdem du ein Repository geklont hast, solltest du in etwa Folgendes sehen:

	$ git status
	# On branch master
	nothing to commit (working directory clean)

Man sagt auch, du hast ein sauberes Arbeitsverzeichnis. Mit anderen Worten, es gibt keine Dateien, die unter Versionskontrolle stehen und seit dem letzten Commit geändert wurden - andernfalls würden sie hier aufgelistet werden. Außerdem teilt dir der Befehl mit, in welchem Branch du dich befindest. In diesem Beispiel ist dies der Branch `master`. Mach dir darüber im Moment keine Gedanken, wir werden im nächsten Kapitel auf Branches detailliert eingehen.

Sagen wir du fügst eine neue `README` Datei zu deinem Projekt hinzu. Wenn die Datei zuvor nicht existiert hat und du jetzt `git status` ausführst, zeigt Git die bisher nicht versionierte Datei wie folgt an:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Alle Dateien, die in der Sektion "Untracked files" aufgelistet werden, sind Dateien, die bisher nocht nicht versioniert sind. Dort wird jetzt auch die Datei `README` angezeigt. Mit anderen Worten, die Datei `README` wird in diesem Bereich gelistet, weil sie im letzen Snapshot (Commit) von Git nicht enthalten ist. Git nimmt eine solche Datei nicht automatisch in die Versionskontrolle auf, sondern man muss Git dazu ausdrücklich auffordern. Ansonsten würden generierte Binärdateien oder andere Dateien, die du nicht in deinem Repository haben willst, automatisch hinzugefügt werden. Das möchte man in den meisten Fällen vermeiden. Jetzt wollen wir aber Änderungen an der Datei `README` verfolgen und fügen sie deshalb zur Versionskontrolle hinzu.

### Neue Dateien zur Versionskontrolle hinzufügen ###

Um eine neue Datei zur Versionskontrolle hinzuzufügen, verwendest du den Befehl `git add`. Für deine neue `README` Datei kannst du ihn wie folgt ausführen:

	$ git add README

Wenn du den `git status` Befehl erneut ausführst, siehst du, dass sich deine `README` Datei jetzt unter Versionskontrolle befindet und für den nächsten Commit vorgemerkt ist (gestaged ist):

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Dass die Datei für den nächsten Commit vorgemerkt ist, siehst du daran, dass sie in der Sektion "Changes to be committed" aufgelistet ist. Wenn du jetzt einen Commit anlegst, wird der Snapshot den Zustand der Datei beinhalten, den sie zum Zeitpunkt des Befehls `git add` hatte. Du erinnerst dich daran, dass du, als du vorhin `git init` ausgeführt hast, anschließend `git add` ausgeführt hast: an dieser Stelle hast du die Dateien in deinem Verzeichnis der Versionskontrolle hinzugefügt. Der `git add` Befehl akzeptiert einen Pfadnamen einer Datei oder eines Verzeichnisses. Wenn du ein Verzeichnis angibst, fügt `git add` alle Dateien in diesem Verzeichnis und allen Unterverzeichnissen rekursiv hinzu.

### Geänderte Dateien stagen ###

Ändern wir also eine Datei, die sich in Versionskontrolle befindet. Wenn du eine bereits versionierte Datei `benchmarks.rb` änderst und den `git status` Befehl ausführst, erhältst du folgendes:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Die Datei `benchmarks.rb` erscheint in der Sektion "Changed but not updated" - d.h., dass eine versionierte Datei im Arbeitsverzeichnis verändert worden ist, aber noch nicht für den Commit vorgemerkt wurde. Um sie vorzumerken, führst du den Befehl `git add` aus. (`git add` wird zu verschiedenen Zwecken eingesetzt. Man verwendet ihn, um neue Dateien zur Versionskontrolle hinzuzufügen, Dateien für einen Commit zu markieren und verschiedene andere Dinge - beispielsweise, einen Konflikt aus einem Merge als aufgelöst zu kennzeichnen.)

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Beide Dateien sind nun für den nächsten Commit vorgemerkt. Nehmen wir an, du willst jetzt aber noch eine weitere Änderung an der Datei `benchmarks.rb` vornehmen, bevor du den Commit tatsächlich anlegst. Du öffnest die Datei und änderst sie. Jetzt könntest du den Commit anlegen. Aber zuvor führen wir noch mal `git status` aus:

	$ vim benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Huch, was ist das? Jetzt wird `benchmarks.rb` sowohl in der Staging Area als auch als geändert aufgelistet. Die Erklärung dafür ist, dass Git eine Datei in exakt dem Zustand für den Commit vormerkt, in dem sie sich befindet, wenn du den Befehl `git add` ausführst. Wenn du den Commit jetzt anlegst, wird die Version der Datei `benchmarks.rb` diejenigen Inhalte haben, die sie hatte, als du `git add` zuletzt ausgeführt hast - nicht diejenigen, die sie in dem Moment hat, wenn du den Commit anlegst. Wenn du stattdessen die gegenwärtige Version im Commit haben willst, kannst du einfach erneut `git add` ausführen:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Dateien ignorieren ###

Du wirst in der Regel eine Reihe von Dateien in deinem Projektverzeichnis haben, die du nicht versionieren oder im Repository haben willst, wie z.B. automatisch generierte Dateien, wie Logdateien oder Dateien, die dein Build-System erzeugt. In solchen Fällen kannst du in einer Datei alle Dateien oder Dateimuster angeben, die du ignorieren willst.

	$ cat .gitignore
	*.[oa]
	*~

Die erste Zeile weist Git an, alle Dateien zu ignorieren, die mit einem `.o` oder `.a` enden (also Objekt- und Archiv-Dateien, die von deinem Build-System erzeugt werden). Die zweite Zeile bewirkt, dass alle Dateien ignoriert werden, die mit einer Tilde (`~`) enden. Viele Texteditoren speichern ihre temporären Dateien auf diese Weise, wie bespielsweise Emacs. Du kannst außerdem Verzeichnisse wie `log`, `tmp` oder `pid` hinzufügen, automatisch erzeugte Dokumentation, und so weiter. Es ist normalerweise empfehlenswert, eine `.gitignore` Datei anzulegen, bevor man mit der eigentlichen Arbeit anfängt, damit man nicht versehentlich Dateien ins Repository hinzufügt, die man dort nicht wirklich haben will.

Die Regeln für Einträge in der `.gitignore` Datei sind:

*	Leere Zeilen oder Zeilen, die mit `#` beginnen, werden ignoriert.
*	Standard `glob` Muster funktionieren.
*	Du kannst ein Muster mit einem Schrägstrich (`/`) abschließen, um ein Verzeichnis zu deklarieren.
*	Du kannst ein Muster negieren, indem du ein Ausrufezeichen (`!`) voranstellst.

Glob Muster sind vereinfachte reguläre Ausdrücke, die von der Shell verwendet werden. Ein Stern (`*`) bezeichnet "kein oder mehrere Zeichen"; `[abc]` bezeichnet eines der in den eckigen Klammern angegebenen Zeichen (in diesem Fall also `a`, `b` oder `c`); ein Fragezeichen (`?`) bezeichnet ein beliebiges, einzelnes Zeichen; und eckige Klammern mit Zeichen, die von einem Bindestrich getrennt werden (`[0-9]`) bezeichnen ein Zeichen aus der jeweiligen Menge von Zeichen (in diesem Fall also aus der Menge der Zeichen von 0 bis 9).

Hier ist ein weiteres Beispiel für eine `.gitignore` Datei:

	# ein Kommentar - dieser wird ignoriert
	*.a       # ignoriert alle Dateien, die mit .a enden
	!lib.a    # nicht aber lib.a Dateien (obwohl obige Zeile *.a ignoriert)
	/TODO     # ignoriert eine TODO Datei nur im Wurzelverzeichnis, nicht aber
	          # in Unterverzeichnissen
	build/    # ignoriert alle Dateien im build/ Verzeichnis
	doc/*.txt # ignoriert doc/notes.txt, aber nicht doc/server/arch.txt

### Die Änderungen in der Staging Area durchsehen ###

Wenn dir die Ausgabe des Befehl `git status` nicht aussagekräftig genug ist, weil du exakt wissen willst, was sich geändert hat - und nicht lediglich, welche Dateien überhaupt geändert wurden - kannst du den `git diff` Befehl verwenden. Wir werden `git diff` später noch einmal im Detail besprechen, aber du wirst diesen Befehl in der Regel verwenden wollen, um eine der folgenden, zwei Fragen zu beantworten: Was hast du geändert, aber noch nicht für einen Commit vorgemerkt? Und welche Änderungen hast du für einen Commit bereits vorgemerkt? Während `git status` diese Fragen nur mit Dateinamen beantwortet, zeigt dir `git diff` exakt an, welche Zeilen hinzugefügt, geändert und entfernt wurden. Dies entspricht gewissermaßen einem Patch.

Nehmen wir an, du hast die Datei `README` geändert und für einen Commit in der Staging Area vorgemerkt. Dann änderst du außerdem die Datei `benchmarks.rb`, fügst sie aber noch nicht zur Staging Area hinzu. Wenn du den `git status` Befehl ausführst, zeigt er dir in etwa Folgendes an:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Um festzustellen, welche Änderungen du bisher nicht gestaged hast, führe `git diff` ohne irgendwelche weiteren Argumente aus:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

Dieser Befehl vergleicht die Inhalte deines Arbeitsverzeichnisses mit den Inhalten deiner Staging Area. Das Ergebnis zeigt dir die Änderungen, die du an Dateien im Arbeitsverzeichnis vorgenommen, aber noch nicht für den nächsten Commit vorgemerkt hast.

Wenn du sehen willst, welche Änderungen in der Staging Area und somit für den nächsten Commit vorgesehen sind, kannst du `git diff --cached` verwenden. (Ab der Version Git 1.6.1 kannst du außerdem `git diff --staged` verwenden, was vielleicht leichter zu merken ist.) Dieser Befehl vergleicht die Inhalte der Staging Area mit dem letzten Commit:

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

Es ist wichtig, im Kopf zu behalten, dass `git diff` nicht alle Änderungen seit dem letzten Commit anzeigt - es zeigt lediglich diejenigen Änderungen an, die noch nicht in der Staging Area sind. Das kann verwirrend sein: wenn du all deine Änderungen bereits für einen Commit vorgemerkt hast, zeigt `git diff` überhaupt nichts an.

Ein anderes Beispiel. Wenn du Änderungen an der Datei `benchmarks.rb` bereits zur Staging Area hinzugefügt hast und sie dann anschließend noch mal änderst, kannst du `git diff` verwenden, um diese letzten Änderungen anzuzeigen, die noch nicht in der Staging Area sind:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#

Jetzt kannst du `git diff` verwenden, um zu sehen, was noch nicht für den nächsten Commit vorgesehen ist:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

und `git diff --cached', um zu sehen, was für den nächsten Commit vorgesehen ist:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### Einen Commit erzeugen ###

Nachdem du jetzt alle Änderungen, die du im nächsten Commit haben willst, in deiner Staging Area gesammelt hast, kannst du den Commit anlegen. Denke daran, dass Änderungen, die nicht in der Staging Area sind (also alle Änderungen, die du vorgenommen hast, seit du zuletzt `git add` ausgeführt hast), auch nicht in den Commit aufgenommen werden. Sie werden ganz einfach weiterhin als geänderte Dateien im Arbeitsverzeichnis verbleiben. In unserem Beispiel haben wir gesehen, dass alle Änderungen vorgemerkt waren, als wir zuletzt `git status` ausgeführt haben, also können wir den Commit jetzt anlegen. Das geht am einfachsten mit dem Befehl:

	$ git commit

Wenn du diesen Befehl ausführst, wird Git den Texteditor deiner Wahl starten. (D.h. denjenigen Texteditor, der durch die `$EDITOR` Variable deiner Shell angegeben wird - normalerweise ist das vim oder emacs, aber du kannst jeden Editor deiner Wahl angeben. Wie in Kapitel 1 besprochen, kannst du dazu `git config --global core.editor` verwenden.)

Der Editor zeigt in etwa folgenden Text an (dies ist ein Beispiel mit vim):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Du siehst, dass die vorausgefüllte Commit Meldung die Ausgabe des letzten `git status` Befehls als einen Kommentar und darüber eine leere Zeile enthält. Du kannst die Kommentare entfernen und deine eigene Meldung einfügen. Oder du kannst sie stehen lassen, damit du siehst, was im Commit enthalten sein wird. (Um die Änderungen noch detaillierter sehen zu können, kannst du den Befehl `git commit` mit der Option `-v` verwenden. Das fügt zusätzlich das Diff deiner Änderungen im Editor ein, so dass du exakt sehen kannst, was sich im Commit befindet.) Wenn du den Texteditor beendest, erzeugt Git den Commit mit der gegebenen Meldung (d.h., ohne den Kommentar und das Diff).

Alternativ kannst du die Commit Meldung direkt mit dem Befehl `git commit` angeben, indem du die Option `-m` wie folgt verwendest:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Du hast jetzt deinen ersten Commit angelegt! Git zeigt dir als Rückmeldung einige Details über den neu angelegten Commit an: in welchem Branch er sich befindet (master), welche SHA-1 Checksumme er hat (`463dc4f`, in diesem Fall nur die Kurzform), wie viele Dateien geändert wurden und eine Zusammenfassung über die insgesamt neu hinzugefügten und entfernten Zeilen in diesem Commit.

Denke daran, dass jeder neue Commit denjenigen Snapshot aufzeichnet, den du in der Staging Area vorbereitet hattest. Änderungen, die nicht in der Staging Area waren, werden weiterhin als modifizierte Dateien im Arbeitsverzeichnis vorliegen. Jedes Mal wenn du einen Commit anlegst, zeichnest du einen Snapshot Deines Projektes auf, zu dem du zurückkehren oder mit dem du spätere Änderungen vergleichen kannst.

### Die Staging Area überspringen ###

Obwohl die Staging Area unglaublich nützlich ist, um genau diejenigen Commits anzulegen, die du in deiner Projekt Historie haben willst, ist sie manchmal auch ein bißchen umständlich. Git stellt dir deshalb eine Alternative zur Verfügung, mit der du die Staging Area überspringen kannst. Wenn du den Befehl `git commit` mit der Option `-a` ausführst, übernimmt Git automatisch alle Änderungen an dejenigen Dateien, die sich bereits unter Versionskontrolle befinden, in den Commit - so dass du auf diese Weise den Schritt `git add` weglassen kannst:

	$ git status
	# On branch master
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Beachte, dass du in diesem Fall `git add` zuvor noch nicht ausgeführt hast, die Änderungen an `benchmarks.rb` aber dennoch in den Commit übernommen werden.

### Dateien entfernen ###

Um eine Datei aus der Git Versionskontrolle zu entfernen, muss diese von den verfolgten Dateien (genauer, aus der Staging Area) entfernt werden und dann mit einem Commit bestätigt werden. Der Befehl `git rm` tut genau das - und löscht die Datei außerdem aus dem Arbeitsverzeichnis, so dass sie dort nicht unbeabsichtigt (als eine nun unversionierte Datei) liegen bleibt.

Wenn du einfach nur eine Datei aus dem Arbeitsverzeichnis löschst, wird sie in der Sektion "Changed but not updated" angezeigt, wenn du `git status` ausführst:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Wenn du jetzt `git rm` ausführst, wird diese Änderung für den nächsten Commit in der Staging Area vorgemerkt:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

Nach dem nächsten Anlegen eines Commits, wird die Datei nicht mehr im Arbeitsverzeichnis liegen und sich nicht länger unter Versionskontrolle befinden. Wenn du die Datei zuvor geändert und diese Änderung bereits zur Staging Area hinzugefügt hattest, musst du die Option `-f` verwenden, um zu erzwingen, dass sie gelöscht wird. Dies ist eine Sicherheitsmaßnahme, um zu vermeiden, dass du versehentlich Daten löschst, die sich bisher noch nicht als Commit Snapshot in der Historie deines Projektes befinden - und deshalb auch nicht wiederhergestellt werden können.

Ein anderer Anwendungsfall für `git rm` ist, dass du eine Datei in deinem Arbeitsverzeichnis behalten, aber aus der Staging Area nehmen willst. In anderen Worten, du willst die Datei nicht löschen, sondern aus der Versionskontrolle nehmen. Das könnte zum Beispiel der Fall sein, wenn du vergessen hattest, eine Datei in `.gitignore` anzugeben und sie versehentlich zur Versionskontrolle hinzugefügt hast, beispielsweise eine große Logdatei oder eine Reihe kompilierter `.a` Dateien. Hierzu kannst du dann die `--cached` Option verwenden:

	$ git rm --cached readme.txt

Der `git rm` Befehl akzeptiert Dateien, Verzeichnisse und `glob` Dateimuster. D.h., du kannst z.B. folgendes tun:

	$ git rm log/\*.log

Beachte den Backslash (`\`) vor dem Stern (`*`). Er ist nötig, weil Git Dateinamen zusätzlich zur Dateinamen-Expansion deiner Shell selbst vervollständigt. D.h., dieser Befehl entfernt alle Dateien, die die Erweiterung `.log` haben und sich im `/log` Verzeichnis befinden. Ein anderes Beispiel ist:

	$ git rm \*~

Dieser Befehl entfernt alle Dateien, die mit einer Tilde (`~`) aufhören.

### Dateien verschieben ###

Anders als andere VCS Systeme verfolgt Git nicht explizit, ob Dateien verschoben werden. Wenn du eine Datei umbenennst, werden darüber keine Metadaten in der Historie gespeichert. Stattdessen ist Git schlau genug, solche Dinge im Nachhinein zu erkennen. Wir werden uns damit später noch befassen.

Es ist allerdings ein bißchen verwirrend, dass Git trotzdem einen `git mv` Befehl kennt. Wenn du eine Datei umbenennen willst, kannst du folgendes tun:

	$ git mv file_from file_to

Das funktioniert einwandfrei. Wenn du diesen Befehl ausführst und danach den `git status` ausführst, zeigt Git an, dass die Datei umbenannt wurde:

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

Allerdings kannst du ganauso folgendes tun:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git ist clever genug, selbst herauszufinden, dass du die Datei umbenannt hast. Du brauchst dies also nicht explizit mit dem `git mv` Befehl zu tun. Der einzige Unterschied ist, dass du mit `git mv` nur einen Befehl, nicht drei, ausführen musst - das ist natürlich etwas bequemer. Darüberhinaus kannst du aber Dateien auf jede beliebige Art und Weise extern umbenennen und dann später `git add` bzw. `git rm` verwenden, wenn du einen Commit zusammenstellst.

## Die Commit Historie anzeigen ##

Nachdem du einige Commits angelegt oder ein bestehendes Repository geklont hast, willst du vielleicht wissen, welche Änderungen zuletzt vorgenommen wurden. Der grundlegende und mächtige Befehl, mit dem du das tun kannst, ist `git log`.

Die folgende Beispiele beziehen sich auf ein sehr simples Repository mit dem Namen "simplegit", das ich oft für Demonstationszwecke verwende:

	git clone git://github.com/schacon/simplegit-progit.git

Wenn du in diesem Projekt `git log` ausführst, solltest du eine Ausgabe wie die folgende sehen:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

Der Befehl `git log` listet die Historie der Commits eines Projekts in umgekehrter chronologischer Reihenfolge auf, wenn man ihn ohne weitere Argumente ausführt, d.h. die letzten Commits stehen oben. Wie du sehen kannst wird jeder Commit mit seiner SHA-1 Checksumme, Namen und E-Mail Adresse des Autors, dem Datum und der Commit Meldung aufgelistet.

Für den Befehl `git log` gibt es eine riesige Anzahl von Optionen, mit denen man sehr genau eingrenzen kann, wonach man in einer Historie sucht. Schauen wir uns also einige der am häufigsten verwendeten Optionen an.

Eine sehr nützliche Option ist `-p`. Sie zeigt die Änderungen an, die in einem Commit enthalten sind. Du kannst außerdem -2 angeben, wodurch nur die letzten beiden Einträge angezeigt werden:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,7 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

Diese Option zeigt also im Prinzip die gleiche Information wie zuvor, aber zusätzlich zu jedem Eintrag ein Diff. Das ist nützlich, um einen Code Review zu machen oder eben mal eine Reihe von Commits durchzuschauen, die ein Mitarbeiter angelegt hat. Außerdem gibt es verschiedene Optionen, die nützlich sind, um Dinge zusammenzufassen. Beispielsweise kannst du eine kurze Statistik über jeden Commit mit der Option `--stat` anzeigen lassen:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

Die `--stat` Option zeigt unterhalb jedes Commits eine kurze Statistik über die jeweiligen Änderungen an: welche Dateien geändert wurden und wieviele Zeilen insgesamt hinzugefügt oder entfernt wurden. Eine weitere nützliche Option ist `--pretty`. Diese Option ändert das Format der Ausgabe und es gibt eine Anzahl mitgelieferter Formate. Das `oneline` Format listet jeden Commit in einer einzigen Zeile, was nützlich ist, wenn du eine große Anzahl von Commits durchsuchen willst. Die `short`, `full` und `fuller` Formate zeigen die Commits in ähnlicher Form an, aber mit jeweils mehr oder weniger Informationen.

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

Eines der interessantesten Formate ist `format`, das dir erlaubt, dein eigenes Format zu verwenden. Dies ist inbesondere nützlich, wenn du die Ausgabe in ein anderes Programm einlesen willst (da du das Format explizit angibst, kannst du sicher sein, dass es sich nicht ändert, wenn du Git auf eine neuere Version aktualisierst):

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tabelle 2-1 zeigt einige nützliche Optionen, die von `format` akzeptiert werden:

	Option	Beschreibung
	%H	Commit Hash
	%h	Abgekürzter Commit Hash
	%T	Baum Hash
	%t	Abgekürzter Baum Hash
	%P	Eltern Hashs
	%p	Abgekürzte Eltern Hashs
	%an	Autor Name
	%ae	Autor E-Mail
	%ad	Autor Datum (format akzeptiert eine –-date= Option)
	%ar	Autor Datum, relativ
	%cn	Committer Name
	%ce	Committer E-Mail
	%cd	Committer Datum
	%cr	Committer Datum, relativ
	%s	Betreff

Du fragst dich vielleicht, was der Unterschied zwischen Autor und Committer ist. Der Autor ist diejenige Person, die eine Änderung ursprünglich vorgenommen hat. Der Committer dagegen ist diejenige Person, die den Commit angelegt hat. D.h., wenn du einen Patch an ein Projekt Team schickst und eines der Team Mitglieder den Patch akzeptiert und verwendet, wird beiden Anerkennung gezollt - sowohl dir als Autor als auch dem Teammitglied als Comitter. Wir werden auf diese Unterschiedung in Kapitel 5 noch einmal genauer eingehen.

Die `oneline` und `format` Optionen können außerdem zusammen mit einer weiteren Option `--graph` verwendet werden. Diese Option fügt einen netten kleinen ASCII Graphen hinzu, der die Branch- und Merge-Historie des Projektes anzeigt. Das kannst du z.B. in deinem Klon des Grit Projekt Repositorys sehen:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

Das sind nur einige eher simple Format Optionen für die Ausgabe von `git log` - es gibt sehr viel mehr davon. Tabelle 2-2 listet diejenigen Optionen auf, die wir bisher besprochen haben, und einige weitere, die besonders nützlich sind:

	Option	Beschreibung
	-p	Zeigt den Patch, der einem Commit entspricht.
	--stat	Zeigt Statistiken über die in einem Commit geänderten Dateien und eingefügten/entfernten Zeilen.
	--shortstat	Zeigt nur die Kurzstatistik über eingefügte/entfernte Zeilen aus der `--stat` Option.
	--name-only	Zeigt die Liste der geänderte Dateien nach der Commit Information.
	--name-status	Zeigt die Liste der Dateien mit der hinzugefügt/geändert/entfernt Statistik.
	--abbrev-commit	Zeigt nur die ersten Zeichen einer SHA-1 Checksumme, nicht alle 40.
	--relative-date	Zeigt das Datum in relativem Format (z.B. "2 weeks ago"), nicht als vollständiges Datumsformat.
	--graph	Zeigt einen ASCII Graphen der Branch- und Merge-Historie neben der Ausgabe.
	--pretty	Zeigt Commits in einem alternativen Format. Gültige Optionen sind: oneline, short, full, fuller und format (mit dem du dein eigenes Format spezifizieren kannst)

### Log Daten filtern ###
	
Zusätzlich zu den Formatierungsoptionen für die Ausgabe, akzeptiert `git log` eine Reihe nützlicher Optionen, um die Anzahl der ausgegebenen Commits einzuschränken. Eine solche Option haben wir bereits verwendet: die `-2` Option, die bewirkt, dass nur die letzten beiden Commits angezeigt werden. D.h., du kannst `-<n>` verwenden, wobei `n` irgendeine ganze Zahl sein kann. Im Alltag wirst du diese Option vermutlich nicht sehr oft verwenden, weil Git die Ausgabe standardmäßig formatiert, so dass nur jeweils eine Seite anzeigt.

Darüber hinaus gibt es noch die hilfreichen Optionen `--since` und `--until`, welche die Ausgabe auf Basis der Zeitangaben eingrenzen. Beispielsweise gibt der folgende Befehl eine Liste aller Commits aus, die in den letzten zwei Wochen angelegt wurden:

	$ git log --since=2.weeks

Das funktioniert mit einer Reihe von Formaten. Git akzeptiert sowohl ein vollständiges Datum ("2008-01-15") oder ein relatives Datum wie "2 years 1 day 3 minutes ago".

Du kannst außerdem die Liste der Commits nach Suchkriterien filtern. Die `--author` Option erlaubt, nach einem bestimmten Autor zu suchen, und die `--grep` Option nach Stichworten in den Commit Meldungen. (Wenn du sowohl nach dem Autor als auch nach Stichworten suchen willst, musst du zusätzlich `--all-match` angeben - andernfalls zeigt der Befehl alle Commits, die entweder das eine oder das andere Kriterium erfüllen.)

Eine letzte sehr nützliche Option, die von `git log` akzeptiert wird, ist ein Pfad. Wenn du einen Verzeichnis- oder Dateinamen angibst, kannst du die Ausgabe auf Commits einschränken, die sich auf die jeweiligen Verzeichnisse oder Dateien beziehen. Der Pfad muss als letztes angegeben und mit einem doppelten Bindestrich (`--`) von den Optionen getrennt werden.

Tabelle 2-3 zeigt die besprochenen und einige weitere, übliche Optionen:

	Option	Beschreibung
	-(n)	Begrenzt die Ausgabe auf die letzten n commits
	--since, --after	Zeigt nur Commits, die nach dem angegebenen Datum angelegt wurden.
	--until, --before	Zeigt nur Commits, die vor dem angegebenen Datum angelegt wurden.
	--author	Zeigt nur Commits, die von dem angegebenen Autor vorgenommen wurden.
	--committer	Zeigt nur Commits, die von dem angegebenen Committer angelegt wurden.

Um beispielweise alle Commits aus der Git Quelltext Historie anzuzeigen, die alle der folgende Bedinungen erfüllen:

* Autor des Commits ist Junio Hamano
* Commit Datum Oktober 2008
* Commits, welche Änderungen im Testverzeichnis beinhalten
* Commits, welche keine Merges sind

kannst du folgenden Befehl verwenden:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Aus etwa 20.000 Commits in der Git Quellcode Historie, filtert dieser Befehl gerade einmal 6 Commits heraus, die diesen Kriterien entsprechen.

### Grafische Darstellung der Historie###

Wenn dir eine grafische Anzeige der Commit Historie lieber ist, kannst du das Tcl/Tk Programm `gitk`, welches mit Git ausgeliefert wird, ausprobieren. `gitk` ist im wesentlichen eine grafische Version von `git log` und akzeptiert fast alle Filteroptionen, die `git log` auch akzeptiert. Wenn du `gitk` in einem Projekt ausführst, siehst du etwa folgende Ausgabe:

Insert 18333fig0202.png
Bild 2-2. Die gitk Oberfläche

Die Commit Historie wird in der oberen Hälfte des Fensters dargestellt. Daneben ein Graph, der die Branches und Merges zeigt. Nach Auswahl eines Commits, zeigt die Vergleichsanzeige in der unteren Hälfte des Fensters die jeweiligen Änderungen in diesem Commit.

## Änderungen rückgängig machen ##

Es kommt immer wieder mal vor, dass du Änderungen rückgängig machen willst. Im Folgenden gehen wir auf einige grundlegende Möglichkeiten dazu ein. Sei allerdings vorsichtig damit, denn du kannst nicht immer alles wieder herstellen, was du rückgängig gemacht hast. Dies ist eine der wenigen Situationen in Git, in denen man Daten verlieren kann, wenn man etwas falsch macht.

### Den letzten Commit ändern ###

Manchmal hat man einen Commit zu früh angelegt und möglicherweise vergessen, einige Dateien hinzuzufügen, oder eine falsche Commit Meldung verwendet. Wenn du den letzten Commit korrigieren willst, kannst du dazu `git commit` zusammen mit der `--amend` Option verwenden:

	$ git commit --amend

Dieser Befehl verwendet deine Staging Area für den Commit. Wenn du seit dem letzten Commit keine Änderungen vorgenommen hast (z.B. wenn du den Befehl unmittelbar nach einem Commit ausführst), wird der Snapshot exakt genauso aussehen wie der vorherige - alles, was du dann änderst, ist die Commit Meldung.

Der Texteditor startet wie üblich, aber diesmal enthält er bereits die Meldung aus dem vorherigen Commit. Du kannst diese Meldung wie gewohnt bearbeiten, speichern und die vorherige Meldung dadurch überschreiben.

Wenn du beispielsweise einen Commit angelegt hast und dann feststellst, dass du zuvor vergessen hast, die Änderungen in einer bestimmten Datei zur Staging Area hinzuzufügen, kannst du folgendes tun:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Diese drei Befehle legen einen einzigen neuen Commit an - der letzte Befehl ersetzt dabei das Ergebnis des ersten Befehls.

### Änderungen aus der Staging Area entfernen ###

Die nächsten zwei Abschnitte gehen darauf ein, wie du Änderungen in der Staging Area und dem Arbeitsverzeichnis verwalten kannst. Praktischerweise liefert dir der Befehl `git status`, den du verwendest, um den Status dieser beiden Bereiche zu überprüfen, zugleich auch einen Hinweis dafür, wie du Änderungen rückgängig machen kanst. Nehmen wir beispielsweise an, du hast zwei Dateien geändert und willst sie als zwei seperate Commits anlegen, du hast aber versehentlich `git add *` ausgeführt und damit beide zur Staging Area hinzugefügt. Wie kannst du jetzt eine der beiden Änderungen wieder aus der Staging Area nehmen? `git status` gibt dir einen Hinweis:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Direkt unter der Zeile "Changes to be committed" findest du den Hinweis "use `git reset HEAD <file>...` to unstage", d.h. "aus der Staging Area zu entfernen". Wir verwenden nun also diesen Befehl, um die Änderungen an der Datei `benchmarks.rb` aus der Staging Area zu nehmen:

	$ git reset HEAD benchmarks.rb
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Der Befehl liest sich zunächst vielleicht etwas merkwürdig, aber wie du siehst, funktioniert er. Die Datei benchmarks.rb ist weiterhin modifiziert, befindet sich aber nicht mehr in der Staging Area.

### Eine Änderung an einer Datei rückgängig machen ###

Was aber, wenn du die Änderungen an der Datei `benchmarks.rb` überhaupt nicht beibehalten willst? D.h., wenn du sie in den Zustand zurückversetzen willst, in dem sie sich befand, als du den letzten Commit angelegt hast (oder das Repository geklont hast). Das ist einfach, und glücklicherweise zeigt der `git status` Befehl ebenfalls bereits einen Hinweis dafür an. Die obige Ausgabe enthält den folgenden Text:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Das sagt ziemlich klar, was wir zu tun haben um die Änderungen an der Datei zu verwerfen (genauer gesagt, Git tut dies seit der Version 1.6.1 - wenn du eine ältere Version hast, empfehlen wir dir, sie zu aktualisieren). Wir führen den vorgeschlagenen Befehl also aus:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Die Änderung wurde also rückgängig gemacht: sie taucht nicht mehr in der Liste der geänderten Dateien auf. Sei dir bewußt, dass dieser Befehl potentiell gefährlich ist, da er Änderungen an einer Datei vollständig verwirft. Es ist also ratsam, ihn nur dann zu verwenden, wenn du dir absolut sicher bist, dass du die Änderungen nicht mehr brauchst. Für Situationen, in denen Du eine Änderung lediglich vorläufig aus dem Weg räumen willst, werden wir im nächsten Kapitel noch auf Stashing und Branching eingehen - die dazu besser geeignet sind.

Beachte, dass alles was jemals in einem Commit in Git enthalten war, fast immer wieder hergestellt werden kann. Selbst Commits, die sich in gelöschten Branches befanden, oder Commits, die mit einem `--amend` Commit überschrieben wurden, können wieder hergestellt werden (siehe Kapitel 9 für Datenrettung). Allerdings wirst du Änderungen, die es nie in einen Commit geschafft haben, wahrscheinlich auch nie wieder bekommen können.

## Mit externen Repositorys arbeiten ##

Um mit anderen via Git zusammenarbeiten zu können, musst du wissen, wie du auf externe (engl. "remote") Repositorys zugreifen kannst. Remote Repositorys sind Versionen deines Projektes, die im Internet oder irgendwo in einem anderen Netzwerk gespeichert sind. Du kannst mehrere solcher Repositorys haben und du kannst jedes davon entweder nur lesen oder lesen und schreiben. Mit anderen via Git zusammenzuarbeiten impliziert, solche Repositorys zu verwalten und Daten aus ihnen herunter- oder heraufzuladen, um deine Arbeit für andere verfügbar zu machen. Um Remote Repositorys zu verwalten, muss man wissen, wie man sie anlegt und wieder entfernt, wenn sie nicht mehr verwendet werden, wie man externe Branches verwalten und nachverfolgen kann, und mehr. In diesem Kapitel werden wir auf diese Aufgaben eingehen.

### Remote Repositorys anzeigen ###

Der `git remote` Befehl zeigt dir an, welche externen Server du für dein Projekt lokal konfiguriert hast, und listet die Kurzbezeichnungen für jedes Remote Repository auf. Wenn du ein Repository geklont hast, solltest du mindestens `origin` sehen - welches der Standardname ist, den Git für denjenigen Server vergibt, von dem Du geklont hast:

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote
	origin

Du kannst außerdem die Option `-v` verwenden, was für jeden Kurznamen auch die jeweilige URL anzeigt, die Git gespeichert hat:

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

Wenn du mehr als ein Remote Repository konfiguriert hast, zeigt der Befehl alle an. Für mein eigenes Grit Repository sieht das beispielsweise wie folgt aus:

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

D.h., mein lokales Repository kennt die Repositorys von all diesen Leuten und ich kann ihre Beiträge zu meinem Projekt ganz einfach herunterladen und zum Projekt hinzufügen.

### Remote Repositorys hinzufügen ###

Ich habe in vorangegangenen Kapiteln schon Beispiele dafür aufgezeigt, wie man ein Remote Repository hinzufügen kann, aber ich will noch einmal darauf eingehen. Um ein neues Remote Repository mit einem Kurznamen hinzuzufügen, den du dir leicht merken kannst, führst du den Befehl `git remote add [shortname] [url]` aus:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Jetzt kannst du den Namen `pb` anstelle der vollständingen URL in verschiedenen Befehlen verwenden. Wenn du bespielsweise alle Informationen, die in Paul's, aber noch nicht in deinem eigenen Repository verfügbar sind, herunterladen willst, kannst du den Befehl `git fetch pb` verwenden:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul's master Branch ist jetzt lokal auf deinem Rechner als `pb/master` verfügbar - du kannst ihn mit einem deiner eigenen Branches zusammenführen oder auf einen lokalen Branch wechseln, um damit zu arbeiten.

### Änderungen aus Remote Repositorys herunterladen und herunterladen inkl. zusammenführen ###

Wie du gerade gesehen hast, kannst du Daten aus Remote Repositorys herunterladen, indem du den folgenden Befehl verwendest:

	$ git fetch [remote-name]

Dieser Befehl lädt alle Daten aus dem Remote Repository herunter, die noch nicht auf deinem Rechner verfügbar sind. Danach kennt dein eigenes Repository Verweise auf alle Branches in dem Remote Repository, die du jederzeit mit deinen eigenen Branches zusammenführen oder durchschauen kannst. (Wir werden in Kapitel 3 detaillierter darauf eingehen, was genau Branches sind.)

Wenn du ein Repository geklont hast, legt der Befehl automatisch einen Verweis auf dieses Repository unter dem Namen `origin` an. D.h. `git fetch origin` lädt alle Neuigkeiten herunter, die in dem Remote Repository von anderen hinzugefügt wurden, seit du es geklont hast (oder zuletzt `git fetch` ausgeführt hast). Es ist wichtig, zu verstehen, dass der `git fetch` Befehl Daten lediglich in dein lokales Repository lädt. Er führt sich mit deinen eigenen Commits in keiner Weise zusammen (mergt) oder modifiziert, woran du gerade arbeitest. D.h. du musst die heruntergeladenen Änderungen anschließend selbst manuell mit deinen eigenen zusammeführen, wenn du das willst.

Wenn du allerdings einen Branch so aufgesetzt hast, dass er einem Remote Branch "folgt" (also einen "Tracking Branch", wir werden im nächsten Abschnitt und in Kapitel 3 noch genauer darauf eingehen), dann kannst du den Befehl `git pull` verwenden, um automatisch neue Daten herunterzuladen und den externen Branch gleichzeitig mit dem aktuellen, lokalen Branch zusammenzuführen. Das ist oft die bequemere Arbeitsweise. `git clone` setzt deinen lokalen master Branch deshalb standardmäßig so auf, dass er dem Remote master Branch des geklonten Repositorys folgt (sofern das Remote Repository einen master Branch hat). Wenn du dann `git pull` ausführst, wird Git die neuen Commits aus dem externen Repository holen und versuchen, sie automatisch mit dem Code zusammenzuführen, an dem du gerade arbeitest.

### Änderungen in ein Remote Repository hochladen ###

Wenn du mit deinem Projekt an einen Punkt gekommen bist, an dem du es anderen zur Verfügung stellen willst, kannst du deine Änderungen in ein gemeinsam genutztes Repository hochladen (engl. "push"). Der Befehl dafür ist einfach: `git push [remote-name] [branch-name]`. Wenn du deinen master Branch auf den `origin` Server hochladen willst (noch einmal, wenn du ein Repository klonst, setzt Git diesen Namen automatisch für dich), dann kannst du diesen Befehl verwenden:

	$ git push origin master

Das funktioniert nur dann, wenn du Schreibrechte für das jeweilige Repository besitzt und niemand anders in der Zwischenzeit irgendwelche Änderungen hochgeladen hat. Wenn zwei Leute ein Repository zur gleichen Zeit klonen, dann zuerst der eine seine Änderungen hochlädt und der zweite anschließend versucht, das gleiche zu tun, dann wird sein Versuch korrekterweise abgewiesen. In dieser Situation muss man neue Änderungen zunächst herunterladen und mit seinen eigenen zusammenführen, um sie dann erst hochzuladen. In Kapitel 3 gehen wir noch einmal ausführlicher darauf ein.

### Ein Remote Repository durchstöbern ###

Wenn du etwas über ein bestimmtes Remote Repository wissen willst, kannst du den Befehl `git remote show [remote-name]` verwenden. Wenn du diesen Befehl mit dem entsprechenden Kurznamen, z.B. `origin` verwendest, erhältst du etwa folgende Ausgabe:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Das zeigt dir die URL für das Remote Repository, die Information welche Branches verfolgt werden und welcher Branch aus dem Remote Repository mit deinem eigenen Master zusammengeführt wird, wenn du `git pull` ausführst. 

Dies ist ein eher einfaches Beispiel, das dir früher oder später so ähnlich über den Weg laufen wird. Wenn du Git aber täglich verwendest, erhältst du mit `git remote show` sehr viel mehr Informationen:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

Dieser Befehl zeigt, welcher Branch automatisch hochgeladen werden wird, wenn du `git push` auf bestimmten Branches ausführst. Er zeigt außerdem, welche Branches es im Remote Repository gibt, die du selbst noch nicht hast, welche Branches dort gelöscht wurden, und Branches, die automatisch mit lokalen Branches zusammengeführt werden, wenn du `git pull` ausführst.

### Verweise auf externe Repositorys löschen und umbenennen ###

Wenn du eine Referenz auf ein Remote Repository umbenennen willst, kannst du in neueren Git Versionen den Befehl `git remote rename` verwenden, um den Kurznamen zu ändern. Wenn du beispielsweise `pb` in `paul` umbenennen willst, lautet der Befehl:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Beachte dabei, dass dies deine Branch Namen für Remote Branches ebenfalls ändert. Der Branch, der zuvor mit `pb/master` referenziert werden konnte, heißt jetzt `paul/master`.

Wenn du eine Referenz aus irgendeinem Grund entfernen willst (z.B. weil du den Server umgezogen hast oder einen bestimmten Mirror nicht länger verwendest, oder weil jemand vielleicht nicht länger mitarbeitet), kannst du `git remote rm` verwenden:

	$ git remote rm paul
	$ git remote
	origin

## Tags ##

Wie die meisten anderen VCS kann Git bestimmte Punkte in der Historie als besonders wichtig markieren, also taggen. Normalerweise verwendet man diese Funktionalität, um Release Versionen zu markieren (z.B. v1.0). In diesem Abschnitt gehen wir darauf ein, wie du vorhandene Tags anzeigen und neue Tags erstellen kannst, und worin die Unterschiede zwischen verschiedenen Typen von Tags bestehen.

### Vorhandene Tags anzeigen ###

Um die in einem Repository vorhandenen Tags anzuzeigen, kannst du den Befehl `git tag` ohne irgendwelche weiteren Optionen verwenden:

	$ git tag
	v0.1
	v1.3

Dieser Befehl listet die Tags in alphabetischer Reihenfolge auf. Die Reihenfolge ist aber eigentlich nicht so wichtig.

Du kannst auch nach Tags mit einem bestimmten Muster suchen. Das Git Quellcode Repository enthält beispielsweise mehr als 240 Tags. Wenn du nur an denjenigen interessiert bist, die zur Version 1.4.2 gehören, kannst du folgendes tun:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Neue Tags anlegen ###

Git kennt im wesentlichen zwei Typen von Tags: einfache (engl. lightweight) und kommentierte (engl. "annotated") Tags. Ein einfacher Tag ist wie ein Branch, der sich niemals ändert - es ist lediglich ein Zeiger auf einen bestimmten Commit. Kommentierte Tags dagegen werden als vollwertige Objekte in der Git Datenbank gespeichert. Sie haben eine Checksumme, beinhalten Namen und E-Mail Adresse desjenigen, der den Tag angelegt hat, das jeweilige Datum sowie eine Meldung. Sie können überdies mit GNU Privacy Guard (GPG) signiert und verifiziert werden. Generell empfiehlt sich deshalb, kommentierte Tags anzulegen. Wenn man aber aus irgendeinem Grund einen temporären Tag anlegen will, für den all diese zusätzlichen Informationen nicht nötig sind, dann kann man auf einfache Tags zurückgreifen.

### Kommentierte Tags ###

Einen kommentierten Tag legst du an, indem du dem `git tag` Befehl die Option `-a` übergibst:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

Die Option `-m` gibt dabei wiederum die Meldung an, die zum Tag hinzugefügt wird. Wenn du keine Meldung angibst, startet Git wie üblich deinen Editor, so dass du eine Meldung eingeben kannst.

`git show` zeigt dir dann folgenden Tag Daten zusammen mit dem jeweiligen Commit, auf den der Tag verweist:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Die Ausgabe listet also zunächst die Informationen über denjenigen, der den Tag angelegt hat, sowie die Tag Meldung und dann die Commit Informationen selbst.

### Signierte Tags ###

Wenn du einen privaten GPG Schlüssel hast, kannst du deine Tags zusätzlich mit GPG signieren. Dazu verwendest du einfach die Option `-s` anstelle von `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Wenn du jetzt `git show` auf diesen Tag anwendest, siehst du, dass der Tag deine GPG Signatur hinterlegt hat:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Darauf, wie du signierte Tags verifizieren kannst, werden wir gleich noch eingehen.

### Einfache Tags ###

Einfache Tags sind die zweite Form von Tags, die Git kennt. Für einen einfachen Tag wird im wesentlichen die jeweilige Commit Prüfsumme, und sonst keine andere Information, in einer Datei gespeichert. Um einen einfachen Tag anzulegen, verwendest du einfach keine der drei Optionen `-a`, `-s` und `-m`:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Wenn du jetzt `git show` auf den Tag ausführst, siehst du keine der zusätzlichen Tag Informationen. Der Befehl zeigt einfach den jeweiligen Commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Tags verifizieren ###

Um einen signierten Tag zu verifizieren, kannst du `git tag -v [Tag Name]` verwenden. Dieser Befehl verwendet GPG, um die Signatur mit Hilfe des öffentlichen Schlüssels des Signierenden zu verifizieren - weshalb du diesen Schlüssel in deinem Schlüsselbund haben musst:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

Wenn du den öffentlichen Schlüssel des Signierenden nicht in deinem Schlüsselbund hast, wirst du statt dessen eine Meldung sehen wie:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Nachträglich taggen ###

Du kannst Commits jederzeit taggen, auch lange Zeit nachdem sie angelegt wurden. Nehmen wir an, deine Commit Historie sieht wie folgt aus:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Nehmen wir außerdem an, dass du vergessen hast, Version v1.2 des Projekts zu taggen und dass dies der Commit "updated rakefile" gewesen ist. Du kannst diesen jetzt im Nachhinein taggen, indem du die Checksumme des Commits (oder einen Teil davon) am Ende des Befehls angibst:

	$ git tag -a v1.2 9fceb02

Du siehst jetzt, dass du einen Tag für den Commit angelegt hast:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Tags veröffentlichen ###

Der `git push` Befehl lädt Tags nicht von sich aus auf externe Server. Stattdessen muss Du Tags explizit auf einen externen Server hochladen, nachdem du sie angelegt hast. Der Vorgang ist derselbe wie mit Branches: du kannst den Befehl `git push origin [tagname]` verwenden.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Wenn du viele Tags auf einmal hochladen willst, kannst du dem `git push` Befehl außerdem die `--tags` Option übergeben und auf diese Weise sämtliche Tags auf dem Remote Server veröffentlichen, die dort noch nicht bekannt sind.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Wenn jetzt jemand anderes das Repository klont oder von dort aktualisiert, wird er all diese Tags ebenfalls erhalten.

## Tipps und Tricks ###

Bevor wir zum Ende dieses Grundlagenkapitels kommen, möchten wir noch einige Tipps und Tricks vorstellen, die dir den Umgang mit Git ein bißchen vereinfachen können. Du kannst Git natürlich einsetzen, ohne diese Tipps anzuwenden, und wir werden später in diesem Buch auch nicht darauf Bezug nehmen oder sie voraussetzen. Aber wir finden, du solltest sie kennen, weil sie einfach nützlich sind.

### Auto-Vervollständigung ###

Wenn du die Bash Shell verwendest, dann kannst du ein Skript für die Git Auto-Vervollständigung einbinden. Ein solches Skript wird mit Git zusammen ausgeliefert. Wenn du den Git Quellcode heruntergeladen hast, findest du im Verzeichnis `contrib/completion` die Datei `git-completion.bash`. Kopiere diese Datei in dein Home Verzeichnis  und füge die folgende Zeile in deine `.bashrc` Datei hinzu:

	source ~/.git-completion.bash

Wenn du Git Auto-Vervollständigung für alle Benutzer deines Rechners aufsetzen willst, kopiere das Skript in das Verzeichnis `/opt/local/etc/bash_completion.d` (auf Mac OS X Systemen) bzw. `/etc/bash_completion.d/` (auf Linux Systemen). Bash sucht in diesem Verzeichnis nach Erweiterungen für die Autovervollständigung und lädt sie automatisch.

Auf Windows Systemen sollte die Autovervollständigung bereits aktiv sein, wenn du die Git Bash aus dem msysGit Paket verwendest.

Während du einen Git Befehl eintippst, kannst du die Tab Taste drücken und du erhälst eine Auswahl von Vorschlägen, aus denen du auswählen kannst:

	$ git co<tab><tab>
	commit config

D.h., wenn du `git co` schreibst und dann die Tab Taste zwei Mal drückst, erhältst du die Vorschläge `commit` und `config`. Wenn du Tab nur ein Mal drückst, vervollständigt den Befehl deine Eingabe direkt zu `git commit`.

Das funktioniert auch mit Optionen - was oftmals noch hilfreicher ist. Wenn du beispielsweise `git log` verwenden willst und dich nicht an eine bestimmte Option erinnern kannst, schreibst du einfach den Befehl und drückst die Tab Taste, um die Optionen anzuzeigen:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Du musst also nicht dauernd die Dokumentation zu Rate ziehen und erspart dir somit etwas Zeit. Ein toller Trick, nicht wahr?

### Git Aliase ###

Git versucht nicht, zu erraten, welchen Befehl du verwenden willst, wenn du ihn nur teilweise eingibst. Wenn du lange Befehle nicht immer wieder eintippen willst, kannst du mit `git config` auf einfache Weise Aliase definieren. Hier einige Beispiele, die du vielleicht nützlich findest:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Das heißt, dass du z.B. einfach `git ci` anstelle von `git commit` schreiben kannst. Wenn du Git oft verwendest, werden dir sicher weitere Befehle begegnen, die du sehr oft nutzt. In diesem Fall zögere nicht, weitere Aliase zu definieren.

Diese Technik kann auch dabei helfen, Git Befehle zu definieren, von denen du denkst, es sollte sie geben:

	$ git config --global alias.unstage 'reset HEAD --'

Das bewirkt, dass die beiden folgenden Befehle äquivalent sind:

	$ git unstage fileA
	$ git reset HEAD fileA

Unser neuer Alias ist wahrscheinlich aussagekräftiger, oder? Ein weiterer, typischer Alias ist der `last` Befehl:

	$ git config --global alias.last 'log -1 HEAD'

Auf diese Weise kannst Du leicht den letzten Commit nachschlagen:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Wie du dir denken kannst, ersetzt Git ganz einfach den Alias mit dem jeweiligen Befehl, für den er definiert ist. Wenn du allerdings einen externen Befehl anstelle eines Git Subbefehls ausführen willst, kannst du den Befehl mit einem Auführungszeichen (`!`) am Anfang kennzeichnen. Das ist in der Regel nützlich, wenn du deine eigenen Hilfsmittel schreibst, um Git zu erweitern. Wir können das demonstrieren, indem wir `git visual` als `gitk` definieren:

	$ git config --global alias.visual "!gitk"

## Zusammenfassung ##


Du solltest jetzt in der Lage sein, die wichtigsten Git Befehle einzusetzen und Repositorys neu zu erzeugen und zu klonen, Änderungen vorzunehmen und zur Staging Area hinzuzufügen, Commits anzulegen und die Historie aller Commits in einem Repository zu durchsuchen. Als nächstes werden wir auf ein herausragendes Feature von Git eingehen: das Branch Konzept.
