# Git Branching #

Nahezu jedes VCS unterstützt eine Form von Branching. Branching bedeutet, dass du von der Hauptentwicklungslinie abzweigst und unabhängig von dem Hauptzweig weiterarbeitest. Bei vielen VCS ist das ein umständlicher und komplizierter Prozess. Nicht selten ist es notwendig, dass eine Kopie des kompletten Arbeitsverzeichnisses erstellt werden muss, was bei grossen Projekten eine ganze Weile dauern kann.

Manche Leute bezeichnen Gits Branching-Modell als dessen "Killer-Feature", was Git zweifellos von dem Rest der VCS-Community abhebt. Aber was macht es so besonders? Git behandelt Branches unglaublich mühelos, führt Branch-Operationen annähernd verzugslos aus und kann genauso schnell zwischen den Entwicklungs-Zweigen hin- und herschalten. Im Gegensatz zu anderen VCS ermutigt Git zu einer Arbeitsweise mit häufigem Branching und Merging - oft mehrmals am Tag. Die Branching-Funktion zu verstehen und zu meistern gibt dir ein mächtiges und einmaliges Werkzeug an die Hand und kann deine Art zu entwickeln buchstäblich verändern.

## Was ist ein Branch? ##

Um wirklich zu verstehen wie Git Branching durchführt, müssen wir einen Schritt zurück gehen und untersuchen wie Git die Daten speichert. Wie du dich vielleicht noch an Kapitel 1 erinnerst, speichert Git seine Daten nicht als Serie von Änderungen oder Unterschieden, sondern als Serie von Schnappschüssen.

Wenn du in Git committest, speichert Git ein sogenanntes Commit-Objekt. Dieses enthält einen Zeiger zu dem Schnappschuss mit den Objekten der Staging-Area, dem Autor, den Commit-Metadaten und einem Zeiger zu den direkten Eltern des Commits. Ein initialer Commit hat keine Eltern-Commits, ein normaler Commit stammt von einem Eltern-Commit ab und ein Merge-Commit, welcher aus einer Zussammenführung von zwei oder mehr Branches resultiert, besitzt stammt von ebenso vielen Eltern-Commits ab.

Um das zu verdeutlichen, lass uns annehmen, du hast ein Verzeichnis mit drei Dateien, die du alle zu der Staging-Area hinzufügst und in einem Commit verpackst. Durch das "Stagen" der Dateien erzeugt Git für jede Datei eine Prüfsumme (der SHA-1 Hash, den wir in Kapitel 1 erwähnt haben), speichert diese Version der Datei im Git-Repository (Git referenziert auf diese als Blobs) und fügt die Prüfsumme der Staging-Area hinzu:

	$ git add README test.rb LICENSE2
	$ git commit -m 'initial commit of my project'

Wenn du einen Commit mit dem Kommando `git commit` erstellst, erzeugt Git für jedes Unterverzeichnis eine Pürfsumme (in diesem Fall nur für das Root-Verzeichnis) und speichert diese drei Objekte im Git Repository. Git erzeugt dann ein Commit Objekt, das die Metadaten und den Pointer zur Wurzel des Projektbaums, um bei Bedarf den Snapshot erneut erzeugen zu können.

Dein Git-Repository enthält nun fünf Objekte: einen Blob für den Inhalt jeder der drei Dateien, einen Baum, der den Inhalt des Verzeichnisses auflistet und spezifiziert welcher Dateiname zu welchem Blob gehört, sowie einen Pointer, der auf die Wurzel des Projektbaumes und die Metadaten des Commits verweist. Prinzipiell können deine Daten im Git Repository wie in Abbildung 3-1 aussehen.

Insert 18333fig0301.png 
Abbildung 3-1. Repository-Daten eines einzelnen Commits

Wenn du erneut etwas änderst und wieder einen Commit machst, wird dieses einen Zeiger speichern, der auf den Vorhergehenden verweist. Nach zwei weiteren Commits könnte die Historie wie in Abbildung 3-2 aussehen.

Insert 18333fig0302.png 
Abbildung 3-2. Git Objektdaten für mehrere Commits 

Eine Branch in Git ist nichts anderes als ein simpler Zeiger auf einen dieser Commits. Der Standardname eines Git-Branches lautet `master`. Mit dem initialen Commit erhältst du einen `master`-Branch, der auf deinen letzten Commit zeigt. Mit jedem Commit wird bewegt er sich automatisch vorwärts.

Insert 18333fig0303.png 
Abbildung 3-3. Branch-Pointer in den Commit-Verlauf

Was passiert, wenn du einen neuen Branch erstellst? Nun, zunächst wird ein neuer Zeiger erstellt. Sagen wir, du erstellst einen neuen Branch mit dem Namen `testing`. Das machst du mit dem `git branch` Befehl:

	$ git branch testing

Dies erzeugt einen neuen Pointer auf den gleichen Commit, auf dem du gerade arbeitest (Abbildung 3-4).

Insert 18333fig0304.png 
Abbildung 3-4. Mehrere Branches zeigen in den Commit-Verlauf

Woher weiß Git, welche Branch du momentan verwendest? Dafür gibt es einen speziellen Zeiger mit dem Namen "HEAD". Berücksichtige, dass dieses Konzept sich grundsätzlich von anderen HEAD-Konzepten anderer VCS, wie Subversion oder CVS, unterscheidet. Bei Git handelt es sich um einen Zeiger deines aktuellen lokalen Branches. In dem Fall bist du immer noch auf der `master`-Branch. Das `git branch` Kommando hat nur einen neuen Branch erstellt, aber nicht zu diesem gewechselt (Abbildung 3-5).

Insert 18333fig0305.png 
Abbildung 3-5. Der HEAD-Zeiger verweist auf deinen aktuellen Branch

Um zu einem anderen Branch zu wechseln, benutze das Kommando `git checkout`. Lass uns nun zu unserem neuen `testing`-Branch wechseln:

	$ git checkout testing

Das lässt HEAD neuerdings auf den "testing"-Branch verweisen (siehe auch Abbildung 3-6).
This moves HEAD to point to the testing branch (see Figure 3-6).

Insert 18333fig0306.png
Abbildung 3-6. Wenn du den Branch wechselst, zeigt HEAD auf einen neuen Zweig.

Und was bedeutet das? Ok, lass uns noch einen weiteren Commit machen:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Abbildung 3-7 verdeutlich das Ergebnis.

Insert 18333fig0307.png 
Abbildung 3-7. Der HEAD-Zeiger schreitet mit jedem weiteren Commit voran.

Das ist interessant, denn dein `testing`-Branch hat sich jetzt voranbewegt und der `master`-Branch zeigt immernoch auf seinen letzten Commit. Den Commit, den du zuletzt bearbeitet hattest, bevor du mit `git checkout` den aktuellen Zweig gewechselt hast. Lass uns zurück zu dem `master`-Branch wechseln:

	$ git checkout master

Abbildung 3-8 zeigt das Ergebnis.

Insert 18333fig0308.png 
Abbildung 3-8. HEAD bewegt sich nach einem "checkout" zu einem anderen Branch.


Das Kommando zwei Dinge veranlasst. Zum Einen bewegt es den HEAD-Zeiger zurück zum `master`-Branch, zum Anderen setzt es alle Dateien im Arbeitsverzeichnis auf den Bearbeitungsstand des letzte Commits in diesem Zweig zurück. Das bedeutet aber auch, dass nun alle Änderungen am Projekt vollkommen unabhängig von älteren Projekt-Versionen erfolgen. Kurz gesagt werden alle Änderungen aus dem `testing`-Zweig vorübergehend rückgängig gemacht und du hast die Möglichkeit einen vollkommen neuen Weg in der Entwicklung einzuschlagen.

Lass uns ein paar Änderungen machen und mit einem Commit festhalten:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Nun verzweigen sich die Projektverläufe (siehe Abbildung 3-9). Du hast einen Branch erstellt und zu ihm gewechselt, ein bisschen gearbeitet, bist zum zu deinem Haupt-Zweig zurückgekehrt und hast da was ganz anderes gemacht. Beide Arbeiten existieren vollständig unabhängig voneinander in zwei unterschiedlichen Branches. Du kannst beliebig zwischen den beiden Zweigen wechseln und sie zusammenführen, wenn du meinst es wäre soweit. Und das alles hast du mit simplen `branch` und `checkout`-Befehlen vollbracht.


Insert 18333fig0309.png 
Abbildung 3-9. Die Branch-Historie läuft auseinander.

Eine Branch in Git ist eine einfache Datei, die nur die 40 Zeichen lange SHA-1 Prüfsumme des Commits enthält, auf das sie zeigt. Es kostet nicht viel, Branches zu erstellen und zu zerstören. Das Erstellen einer Branch ist der einfache und schnelle Weg, 41 Bytes in eine Datei zu schreiben (40 Zeichen für die Prüdsumme und ein Zeilenumbruch).

Branches können in Git spielend erstellt und entfernt werden, da sie nur kleine Dateien sind, die eine 40 Zeichen lange SHA-1 Prüfsumme der Commits enthalten, auf die sie verweisen. Einen neuen Zweig zu erstellen erzeugt ebenso viel Aufwand wie das Schreiben einer 41 Byte großen Datei (40 Zeichen und einen Zeilenumbruch).

Das steht im krassen Gegensatz zu dem Weg, den die meisten andere VCS Tools beim Thema Branching einschlagen. Diese kopieren oftmals jeden neuen Entwicklungszweig in ein weiteres Verzeichnis, was - je nach Projektgröße - mehrere Minuten in Anspruch nehmen kann, wohingegen Git diese Aufgabe sofort erledigt. Da wir ausserdem immer den Ursprungs-Commit aufzeichnen, lässt sich problemlos eine gemeinsame Basis für eine Zusammenführung finden und umsetzen. Diese Eigenschaft soll Entwickler ermutigen Entwicklungszweige häufig zu erstellen und zu nutzen.

Lass uns mal sehen, warum du das machen solltest.

## Einfaches Branching und Merging ##

## Basic Branching and Merging ##

Lass uns das Ganze an einem Beispiel durchgehen, dessen Workflow zum Thema Branching und Zusammenführen du im echten Leben verwenden kannst. Folge einfach diesen Schritten:

1.	Arbeite an einer Webseite.
2.	Erstell einen Branch für irgendeine neue Geschichte, an der du arbeitest.
3.	Arbeite in dem Branch.

In diesem Augenblick kommt ein Anruf, dass ein kritisches Problem aufgetreten ist und sofort gelöst werden muss. Du machst folgendes:

1.	Geh zurück zu deinem "Produktiv"-Zweig.
2.	Erstelle eine Branch für den Hotfix.
3.	Nach dem Testen führst du den Hotfix-Branch mit dem "Produktiv"-Branch zusammen.
4.	Schalte wieder auf deine alte Arbeit zurück und werkel weiter.

### Branching Grundlagen ###

Sagen wir, du arbeitest an deinem Projekt und hast bereits einige Commits durchgeführt (siehe Abbildung 3-10).

Insert 18333fig0310.png 
Abbildung 3-10. Eine kurze, einfache Commit-Historie

Du hast dich dafür entschieden an dem Issue #53, des Issue-Trackers XY, zu arbeiten. Um eines klarzustellen, Git ist an kein Issue-Tracking-System gebunden. Da der Issue #53 allerdings ein Schwerpunktthema betrifft, wirst du einen neuen Branch erstellen um daran zu arbeiten. Um in einem Arbeitsschritt einen neuen Branch zu erstellen und zu aktivieren kannst du das Kommando `git checkout` mit der Option `-b` verwenden:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Das ist die Kurzform von

	$ git branch iss53
	$ git checkout iss53

Abbildung 3-11 verdeutlicht das Ergebnis.

Insert 18333fig0311.png 
Abbildung 3-11. Erstellung eines neuen Branch-Zeigers

Du arbeitest an deiner Web-Seite und machst ein paar Commits. Das bewegt den `iss53`-Branch vorwärts, da du ihn ausgebucht hast (das heißt, dass dein HEAD-Zeiger darauf verweist; siehe Abbildung 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Abbildung 3-12. Der `iss53`-Branch hat mit deiner Arbeit Schritt gehalten.

Nun bekommst du einen Anruf, in dem dir mitgeteilt wird, dass es ein Problem mit der Internet-Seite gibt, das du umgehend beheben sollst. Mit Git musst du deine Fehlerkorrektur nicht zusammen mit den `iss53`-Änderungen einbringen. Und du musst keine Zeit damit verschwenden deine bisherigen Änderungen rückgängig zu machen, bevor du mit der Fehlerbehebung an der Produktionsumgebung beginnen kannst. Alles was du tun musst, ist zu deinem MASTER-Branch wechseln.

Beachte jedoch, dass dich Git den Branch nur wechseln lässt, wenn bisherige Änderungen in deinem Arbeitsverzeichnis oder deiner Staging-Area nicht in Konflikt mit dem Zweig stehen, zu dem du nun wechseln möchtest. Am besten es liegt ein sauberer Status vor wenn man den Branch wechselt. Wir werden uns später mit Wegen befassen, dieses Verhalten zu umgehen (namentlich "Stashing" und "Commit Ammending"). Vorerst aber hast du deine Änderungen bereits comitted, sodass du zu deinem MASTER-Branch zurückwechseln kannst.

	$ git checkout master
	Switched to branch "master"

Zu diesem Zeitpunkt befindet sich das Arbeitsverzeichnis des Projektes in exakt dem gleichen Zustand, in dem es sich befand, als du mit der Arbeit an Issue #53 begonnen hast und du kannst dich direkt auf deinen Hotfix konzentrieren. Dies ist ein wichtiger Moment um sich vor Augen zu halten, dass Git dein Arbeitsverzeichnis auf den Zustand des Commits, auf den dieser Branch zeigt, zurücksetzt. Es erstellt, entfernt und verändert Dateien automatisch, um sicherzustellen, dass deine Arbeitskopie haargenau so aussieht wie der Zweig nach deinem letzten Commit.

Nun hast du einen Hotfix zu erstellen. Lass uns dazu einen Hotfix-Branch erstellen, an dem du bis zu dessen Fertigstellung arbeitest (siehe Abbildung 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png
Abbildung 3-13. Der Hotfix-Branch basiert auf dem zurückliegenden Master-Branch.

Mach deine Tests, stell sicher das sich der Hotfix verhält wie erwartet und führe ihn mit dem Master-Branch zusammen, um ihn in die Produktionsumgebung zu integrieren. Das machst du mit dem `git merge`-Kommando:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Du wirst die Mitteilung "Fast Forward" während des Zusammenführens bemerken. Da der neue Commit direkt von dem ursprünglichen Commit, auf den sich der nun eingebrachte Zweig bezieht, abstammt, bewegt Git einfach den Zeiger weiter. Mit anderen Worten kann Git den neuen Commit, durch verfolgen der Commitabfolge, direkt erreichen, dann bewegt es ausschließlich den Branch-Zeiger. Zu einer tatsächlichen Kombination der Commits besteht ja kein Anlass. Dieses Vorgehen wird "Fast Forward" genannt.

Deine Modifikationen befinden sich nun als Schnappschuss in dem Commit, auf den der `master`-Branch zeigt, diese lassen sich nun veröffentlichen (siehe Abbildung 3-14).

Insert 18333fig0314.png
Abbildung 3-14. Der Master-Branch zeigt nach der Zusammenführung auf den gleichen Commit wie der Hotfix-Branch.

Nachdem dein superwichtiger Hotfix veröffentlicht wurde, kannst du dich wieder deiner ursprünglichen Arbeit zuwenden. Vorher wird sich allerdings des nun nutzlosen Hotfix-Zweiges entledigt, schließlich zeigt der Master-Branch ebenfalls auf die aktuelle Version. Du kannst ihn mit der `-d`-Option von `git branch` entfernen:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Nun kannst du zu deinem Issue #53-Branch zurückwechseln und mit deiner Arbeit fortfahren (Abbildung 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Abbildung 3-15. Dein `iss53`-Branch kann sich unabhängig weiterentwickeln.

An dieser Stelle ist anzumerken, dass die Änderungen an dem `hotfix`-Branch nicht in deinen `iss53`-Zweig eingeflossen sind. Falls nötig kannst du den `master`-Branch allerdings mit dem Kommando `git merge master` mit deinem Zweig kombinieren. Oder du wartest, bis du den `iss53`-Branch später in den Master-Zweig zurückführst.

### Die Grundlagen des Zusammenführens (Mergen) ###

Angenommen du entscheidest dich, dass deine Arbeit an issue #53 getan ist und du diese mit der `master` Branch zusammenführen möchtest. Das passiert, indem du ein `merge` in die `iss53` Branch machst, ähnlich dem `merge` mit der `hotfix` Branch von vorhin. Alles was du machen musst, ist ein `checkout` der Branch, in die du das `merge` machen willst und das Ausführen des Kommandos `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Das sieht ein bisschen anders aus als das `hotfix merge` von vorhin. Hier läuft deine Entwicklungshistorie auseinander. Ein `commit` auf deine Arbeits-Branch ist kein direkter Nachfolger der Branch in die du das `merge` gemacht hast, Git hat da einiges zu tun, es macht einen 3-Wege `merge`: es geht von den beiden `snapshots` der Branches und dem allgemeinen Nachfolger der beiden aus. Abbildung 3-16 zeigt die drei `snapshots`, die Git in diesem Fall für das `merge` verwendet.

Insert 18333fig0316.png 
Abbildung 3-16. Git ermittelt automatisch die beste Nachfolgebasis für die Branchzusammenführung.

Anstatt einfach den 'pointer' weiterzubewegen, erstellt Git einen neuen `snapshot`, der aus dem 3-Wege 'merge' resultiert und erzeugt einen neuen 'commit', der darauf verweist (siehe Abbildung 3-17). Dies wird auch als 'merge commit' bezeichnet und ist ein Spezialfall, weil es mehr als nur ein Elternteil hat.

Es ist wichtig herauszustellen, dass Git den besten Nachfolger für die 'merge' Basis ermittelt, denn hierin unterscheidet es sich von CVS und Subversion (vor Version 1.5), wo der Entwickler die 'merge' Basis selbst ermitteln muss. Damit wird das Zusammenführen in Git um einiges leichter, als in anderen Systemen.

Insert 18333fig0317.png 
Abbildung 3-17. Git erstellt automatisch ein 'commit', dass die zusammengeführte Arbeit enthält.

Jetzt da wir die Arbeit zusammengeführt haben, ist der `iss53`-Branch nicht mehr notwendig. Du kansst ihn löschen und das Ticket im Ticket-Tracking-System schliessen.

	$ git branch -d iss53

### Grundlegende Merge-Konflikte ###

Gelegentlich verläuft der Prozess nicht ganz so glatt. Wenn du an den selben Stellen in den selben Dateien unterschiedlicher Branches etwas geändert hast, kann Git diese nicht sauber zusammenführen. Wenn dein Fix an 'issue #53' die selbe Stelle in einer Datei verändert hat, die du auch mit `hotfix` angefasst hast, wirst du einen 'merge'-Konflikt erhalten, der ungefähr so aussehen könnte:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git hat hier keinen 'merge commit' erstellt. Es hat den Prozess gestoppt, damit du den Konflikt beseitigen kannst. Wenn du sehen willst, welche Dateien 'unmerged' aufgrund eines 'merge' Konflikts sind, benutze einfach `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Alles, was einen 'merge' Konflikt aufweist und nicht gelöst werden konnte, wird als 'unmerged' aufgeführt. Git fügt den betroffenen Dateien Standard-Konfliktlösungsmarker hinzu, so dass du diese öffnen und den Konflikt manuell lösen kannst. Deine Datei enthält einen Bereich, der so aussehen könnte:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Das heisst, die Version in HEAD (deines 'master'-Branches, denn der wurde per 'checkout' aktiviert als du das 'merge' gemacht hast) ist der obere Teil des Blocks (alles oberhalb von '======='), und die Version aus dem `iss53`-Branch sieht wie der darunter befindliche Teil aus. Um den Konflikt zu lösen, musst du dich entweder für einen der beiden Teile entscheiden oder du ersetzt den Teil komplett:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Diese Lösung hat von beiden Teilen etwas und ich habe die Zeilen mit `<<<<<<<`, `=======`, und `>>>>>>>` komplett gelöscht. Nachdem du alle problematischen Bereiche, in allen durch den Konflikt betroffenen Dateien, beseitigt hast, führe einfach `git add` für alle betroffenen Dateien aus und markieren sie damit als bereinigt. Dieses 'staging' der Dateien markiert sie für Git als bereinigt.
Wenn du ein grafischen Tool zur Bereinigung benutzen willst, dann verwende `git mergetool`. Das welches ein passendes grafisches 'merge'-Tool startet und dich durch die Konfliktbereiche führt:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Wenn du ein anderes Tool anstelle des Standardwerkzeug für ein 'merge' verwenden möchtest (Git verwendet in meinem Fall `opendiff`, da ich auf einem Mac arbeite), dann kannst du alle unterstützten Werkzeuge oben - neben "merge tool candidates" - aufgelistet sehen. Tippe einfach den Namen deines gewünschten Werkzeugs ein. In Kapitel 7 besprechen wir, wie du diesen Standardwert in deiner Umgebung dauerhaft ändern kannst.

Wenn du das 'merge' Werkzeug beendest, fragt dich Git, ob das Zusammenführen erfolgreich war. Wenn du mit 'Ja' antwortest, wird das Skript diese Dateien als gelöst markieren.

Du kannst `git status` erneut ausführen, um zu sehen, ob alle Konflikte gelöst sind:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Wenn du zufrieden bist und du geprüft hast, dass alle Konflikte beseitigt wurden, kannst du `git commit` ausführen um den 'merge commit' abzuschliessen. Die Standardbeschreibung für diese Art 'commit' sieht wie folgt aus:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Wenn du glaubst für zukünftige Betrachter des Commits könnte interessant sein warum du getan hast, was du getan hast, dann kannst du der Commit-Beschreibung noch zusätzliche Informationen hinzufügen - sofern das nicht trivial erscheint.

## Branch Management ##

Du weißt jetzt, wie du Branches erstellen, mergen und löschen kannst. Wir schauen uns jetzt noch ein paar recht nützliche Tools für die Arbeit mit Branches an.

Das Kommando `git branch` kann mehr, als nur Branches zu erstellen oder zu löschen. Wenn du es ohne weitere Argumente ausführst, wird es dir eine Liste mit deinen aktuellen Branches anzeigen:

	$ git branch
	  iss53
	* master
	  testing

Das `*` vor dem `master`-Branch bedeutet, dass dies der gerade ausgecheckte Branch ist. Wenn du also jetzt einen Commit erzeugst, wird dieser in den `master`-Branch gehen. Du kannst dir mit `git branch -v` ganz schnell für jeden Branch den letzten Commit anzeigen lassen:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Mit einer weiteren nützlichen Option kannst du herausfinden, in welchem Zustand deine Branches sind: welche der Branches wurden bereits in den aktuellen Branch gemergt und welche wurden es nicht. Die Optionen heißen `--merged` und `--no-merged` und sind seit Version 1.5.6 in Git dabei. Um herauszufinden, welche Branches schon in den aktuell ausgecheckten gemergt wurden, kannst du einfach `git branch --merged` aufrufen:

	$ git branch --merged
	  iss53
	* master

Da du den Branch `iss53` schon gemergt hast, siehst du ihn in dieser Liste. Alle Branches in dieser Liste, welchen kein `*` voransteht, können ohne Datenverlust mit `git branch -d` gelöscht werden, da sie ja bereits gemergt wurden.

Um alle Branches zu sehen, welche noch nicht gemergte Änderungen enthalten, kannst du `git branch --no-merged` aufrufen:

	$ git branch --no-merged
	  testing

Die Liste zeigt dir den anderen Branch. Er enthält Arbeit, die noch nicht gemergt wurde. Der Versuch, den Branch mit `git branch -d` zu löschen schlägt fehl:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run `git branch -D testing`.

Wenn du den Branch trotzdem löschen willst - und damit alle Änderungen dieses Branches verlieren - kannst du das mit `git branch -D testing` machen.

## Branching Workflows ##

Jetzt da du die Grundlagen von 'branching' und 'merging' kennst, fragst du dich sicher, was du damit anfangen kannst. In diesem Abschnitt werden wir uns typische Workflows anschauen, die dieses leichtgewichtige 'branching' möglich macht. Und du kannst dann entscheiden, ob du es in deinem eigene Entwicklungszyklus verwenden willst.

### Langfristige Branches ###

Da Git das einfachen 3-Wege-'merge' verwendet, ist häufiges Zusammenführen von einer Branch in eine andere über einen langen Zeitraum generell einfach zu bewerkstelligen. Das heisst, du kann mehrere Branches haben, die alle offen sind und auf unterschiedlichen Ebenen deines Entwicklungszyklus verwendung finden, und diese regelmäßig ineinander zusammenführen.

Viele Git Entwickler verfolgen mit ihrem Workflow den Ansatz nur den stabilen Code in dem `master`-Branch zu halten - möglicherweise auch nur Code, der released wurde oder werden kann. Sie betreiben parallel einen anderen Branch zum Arbeiten oder Testen. Wenn dieser paralelle Zweig einen stabilen Status erreicht, kann er mit dem `master`-Branch zusammengeführt werden. Dies findet bei Themen bezogenen Branches (kurzfristigen Branches, wie der zuvor genante `iss53`-Branch) Anwendung, um sicherzustellen, dass dieser die Tests besteht und keine Fehler verursacht.

In Realität reden wir über sich bewegende Zeiger, die den Commit-Verlauf weiterwandern. Die stabilen Branches liegen unten und die bleeding-edge Branches weiter oben in der Zeitlinie (siehe Abbildung 3-18).

Insert 18333fig0318.png 
Abbildung 3-18. Stabilere Branches sind generell weiter unten im Entwicklungsverlauf.

Es ist leichter sich die verschiedenen Branches als Arbeitsdepots vorzustellen, in denen Sätze von Commits in stabilere Depots aufsteigen, sobald sie ausreichend getestet wurden (siehe Abbildung 3-19).

Insert 18333fig0319.png 
Abbildung 3-19. Es könnte hilfreich sein, sich die Branches als Depots vorzustellen.

Das lässt sich für beliebig viele Stabilitätsabstufungen umsetzen. Manche größeren Projekte haben auch einen `proposed` (Vorgeschlagen) oder `pu` (proposed updates - vorgeschlagene Updates) Zweig mit Branches die vielleicht noch nicht bereit sind in den `next`- oder `master`-Branch integriert zu werden. Die Idee dahinter ist, dass deine Branches verschiedene Stabilitätsabstufungen repräsentieren. Sobald sie eine stabilere Stufe erreichen, werden sie in den nächsthöheren Branch vereinigt.

Nochmal, langfristig verschiedene Branches paralell laufen zu lassen ist nicht notwendig, aber oft hilfreich. Insbesondere wenn man es mit sehr großen oder komplexen Projekten zu tun hat.

### Themen-Branches ###

Themen-Branches sind in jedem Projekt nützlich, egal bei welcher Größe. Ein Themen-Branch ist ein kurzlebiger Zweig der für eine spezielle Aufgabe oder ähnliche Arbeiten erstellt und benutzt wird. Das ist vielleicht etwas was du noch nie zuvor mit einem Versionierungssystem gemacht hast, weil es normalerweise zu aufwändig und mühsam ist Branches zu erstellen und zusammenzuführen. Mit Git ist es allerdings vollkommen geläufig mehrmals am Tag Branches zu erstellen, an ihnen zu arbeiten, sie zusammenzuführen und sie anschließend wieder zu löschen.

Du hast das im letzten Abschnitt an den von dir erstellten `iss53`- und `hotfix`-Branches gesehen. Du hast mehrere Commits auf sie angewendet und sie unmittelbar nach Zusammenführung mit deinem Hauptzweig gelöscht. Diese Technik erlaubt es dir schnell und vollständig den Kontext zu wechseln. Da deine Arbeit in verschiedene Depots aufgeteilt ist, in denen alle Änderungen unter die Thematik dieses Branches fallen, ist es leichter nachzuvollziehen was bei Code-Überprüfungen und ähnlichem geschehen ist.

Stell dir du arbeitest ein bisschen (in `master`), erstellst mal eben einen Branch für einen Fehler (`iss91`), arbeitest an dem für eine Weile, erstellst einen zweiten Branch um eine andere Problemlösung für den selben Fehler auszuprobieren (`iss91v2`), wechselst zurück zu deinem MASTER-Branch, arbeitest dort ein bisschen und machst dann einen neuen Branch für etwas, wovon du nicht weißt ob's eine gute Idee ist (`dumbidea`-Branch). Dein Commit-Verlauf wird wie in Abbildung 3-20 aussehen.

Insert 18333fig0320.png 
Abbildung 3-20. Dein Commit-Verlauf mit verschiedenen Themen-Branches.

Nun, sagen wir du hast dich entschieden die zweite Lösung des Fehlers (`iss91v2`) zu bevorzugen, außerdem hast den `dumbidea`-Branch deinen Mitarbeitern gezeigt und es hat sich herausgestellt das er genial ist. Du kannst also den ursprünglichen `iss91`-Branch (unter Verlust der Commits C5 und C6) wegschmeißen und die anderen Beiden vereinen. Dein Verlauf sieht dann aus wie in Abbildung 3-21.

Insert 18333fig0321.png
Abbildung 3-21. Dein Verlauf nach Zusammenführung von `dumbidea` und `iss91v2`.

Es ist wichtig sich daran zu erinnern, dass alle diese Branches nur lokal existieren. Wenn du Verzweigungen schaffst (branchst) und wieder zusammenführst (mergest), findet dies nur in deinem Git-Repository statt - es findet keine Server-Kommunikation statt.

## Externe Branches ##

Externe (Remote) Branches sind Referenzen auf den Zustand der Branches in deinen externen Repositorys. Es sind lokale Branches die du nicht verändern kannst, sie werden automatisch verändert wann immer du eine Netzwerkoperation durchführst. Externe Branches verhalten sich wie Lesezeichen, um dich daran zu erinnern an welcher Position sich die Branches in deinen externen Repositories befanden, als du dich zuletzt mit ihnen verbunden hattest.

Externe Branches besitzen die Schreibweise `(Repository)/(Branch)`. Wenn du beispielsweise wissen möchtest wie der `master`-Branch in deinem `origin`-Repository ausgesehen hat, als du zuletzt Kontakt mit ihm hattest, dann würdest du den `origin/master`-Branch überprüfen. Wenn du mit einem Mitarbeiter an einer Fehlerbehebung gearbeitet hast, und dieser bereits einen `iss53`-Branch hochgeladen hat, besitzt du möglicherweise deinen eigenen lokalen `iss53`-Branch. Der Branch auf dem Server würde allerdings auf den Commit von `origin/iss53` zeigen.

Das kann ein wenig verwirrend sein, lass uns also ein Besipiel betrachten. Nehmen wir an du hättest in deinem Netzwerk einen Git-Server mit der Adresse `git.ourcompany.com`. Wenn du von ihm klonst, nennt Git ihn automatisch `origin` für dich, lädt all seine Daten herunter, erstellt einen Zeiger an die Stelle wo sein `master`-Branch ist und benennt es lokal `origin/master`; und er ist unveränderbar für dich. Git gibt dir auch einen eigenen `master`-Branch mit der gleichen Ausgangsposition wie origins `master`-Branch, damit du einen Punkt für den Beginn deiner Arbeiten hast (siehe Abbildung 3-22).

Insert 18333fig0322.png
Abbildung 3-22. Ein 'git clone' gibt dir deinen eigenen `master`-Branch und `origin/master`, welcher auf origins 'master'-Branch zeigt.

Wenn du ein wenig an deinem lokalen `master`-Branch arbeitest und unterdessen jemand etwas zu `git.ourcompany.com` herauflädt, verändert er damit dessen `master`-Branch und eure Arbeitsverläufe entwickeln sich unterschiedlich. Indess bewegt sich dein `origin/master`-Zeiger nicht, solange du keinen Kontakt mit deinem `origin`-Server aufnimmst (siehe Abbildung 3-23).

Insert 18333fig0323.png 
Abbildung 3-23. Lokales Arbeiten, während jemand auf deinen externen Server hochlädt, lässt jeden Änderungsverlauf unterschiedlich weiterentwickeln.

Um deine Arbeit abzugleichen, führe ein `git fetch origin`-Kommando aus. Das Kommando schlägt nach welcher Server `orgin` ist (in diesem Fall `git.ourcompany.com`), holt alle Daten die dir bisher fehlen und aktualisiert deine lokale Datenbank, indem es deinen `orgin/master`-Zeiger auf seine neue aktuellere Position bewegt (siehe Abbildung 3-24).

Insert 18333fig0324.png 
Abbildung 3-24. Das `git fetch`-Kommando aktualisiert deine externen Referenzen.

Um zu demonstrieren wie Branches auf verschiedenen Remote-Servern aussehen, stellen wir uns vor, dass du einen weiteren internen Git-Server besitzt, welcher nur von einem deiner Sprint-Teams zur Entwicklung genutzt wird. Diesen Server erreichen wir unter `git.team1.ourcompany.com`. Du kannst ihn, mit dem Git-Kommando `git remote add` - wie in Kapitel 2 beschrieben, deinem derzeitigen Arbeitsprojekt als weiteren Quell-Server hinzufügen. Gib dem Remote-Server den Namen `teamone`, welcher nun als Synonym für die ausgeschriebene Internetadresse dient (siehe Abbildung 3-25).

Insert 18333fig0325.png
Abbildung 3-25. Einen weiteren Server als Quelle hinzufügen.

Nun kannst du einfach `git fetch teamone` ausführen um alles vom Server zu holen was du noch nicht hast. Da der Datenbestand auf dem Teamserver einen Teil der Informationen auf deinem `origin`-Server ist, holt Git keine Daten, erstellt allerdings einen Remote-Branch namens `teamone/master`, der auf den gleichen Commit wie `teamone`s `master`-Branch zeigt (siehe Abbildung 3-26).

Insert 18333fig0326.png 
Abbildung 3-26. Du bekommst eine lokale Referenz auf `teamone`s `master`-Branch.

### Hochladen ###

Wenn du einen Branch mit der Welt teilen möchtest, musst du ihn auf einen externen Server laden, auf dem du Schreibrechte besitzt. Deine lokalen Zweige werden nicht automatisch mit den Remote-Servern synchronisiert wenn du etwas änderst - du musst die zu veröffentlichenden Branches explizit hochladen (pushen). Auf diesem Weg kannst du an privaten Zweigen arbeiten die du nicht veröffentlichen möchtest, und nur die Themen-Branches replizieren an denen du gemeinsam mit anderen entwickeln möchtest.

Wenn du einen Zweig namens `serverfix` besitzt, an dem du mit anderen arbeiten möchtest, dann kannst du diesen auf dieselbe Weise hochladen wie deinen ersten Branch. Führe `git push (remote) (branch)` aus:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Hierbei handelt es sich um eine Abkürzung. Git erweitert die `serverfix`-Branchbezeichnung automatisch zu `refs/heads/serverfix:refs/heads/serverfix`, was soviel bedeutet wie “Nimm meinen lokalen `serverfix`-Branch und aktualisiere damit den `serverfix`-Branch auf meinem externen Server”. Wir werden den `refs/heads/`-Teil in Kapitel 9 noch näher beleuchten, du kannst ihn aber in der Regel weglassen. Du kannst auch `git push origin serverfix:serverfix` ausführen, was das gleiche bewirkt - es bedeutet “Nimm meinen `serverfix` und mach ihn zum externen `serverfix`”. Du kannst dieses Format auch benutzen um einen lokalen Zweig in einen externen Branch mit anderem Namen zu laden. Wenn du ihn auf dem externen Server nicht `serverfix` nennen möchtest, könntest du stattdessen `git push origin serverfix:awesomebranch` ausführen um deinen lokalen `serverfix`-Branch in den `awesomebranch`-Zweig in deinem externen Projekt zu laden. 

Das nächste Mal wenn einer deiner Mitarbeiter den aktuellen Status des Git-Projektes vom Server abruft, wird er eine Referenz, auf den externen Branch `origin/serverfix`, unter dem Namen `serverfix` erhalten:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Es ist wichtig festzuhalten, dass du mit Abrufen eines neuen externen Branches nicht automatisch eine lokale, bearbeitbare Kopie derselben erhältst. Mit anderen Worten, in diesem Fall bekommst du keinen neuen `serverfix`-Branch - sondern nur einen `origin/serverfix`-Zeiger den du nicht verändern kannst.

Um diese referenzierte Arbeit mit deinem derzeitigen Arbeitsbranch zusammenzuführen kannst du `git merge origin/serverfix` ausführen. Wenn du allerdings deine eigene Arbeitskopie des `serverfix`-Branches erstellen möchtest, dann kannst du diesen auf Grundlage des externen Zweiges erstellen:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Dies erstellt dir einen lokalen bearbeitbaren Branch mit der Grundlage des `origin/serverfix`-Zweiges.

### Tracking Branches ###

Das Auschecken eines lokalen Branches von einem Remote-Branch erzeugt automatisch einen sogenannten _Tracking-Branch_. Tracking Branches sind lokale Branches mit einer direkten Beziehung zu dem Remote-Zweig. Wenn du dich in einem Tracking-Branch befindest und `git push` eingibst, weiß Git automatisch zu welchem Server und Repository es Pushen soll. Ebenso führt `git pull` in einem dieser Branches dazu, dass alle entfernten Referenzen gefetched und automatisch in den Zweig gemerged werden.

Wenn du ein Repository klonst, wird automatisch ein `master`-Branch erzeugt, welcher `origin/master` verfolgt. Deshalb können `git push` und `git pull` ohne weitere Argumente aufgerufen werden. Du kannst natürlich auch eigene Tracking-Branches erzeugen - welche die nicht Zweige auf `origin` und dessen `master`-Branch verfolgen. Der einfachste Fall ist das bereits gesehene Beispiel in welchem du `git checkout -b [branch] [remotename]/[branch]` ausführst. Mit der Git-Version 1.6.2 oder später kannst du auch die `--track`-Kurzvariante nutzen:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Um einen lokalen Branch mit einem anderem Namen als der Remote-Branch, kannst du einfach die erste Varianten mit einem neuen lokalen Branch-Namen:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Nun wird dein lokaler Branch `sf` automatisch push und pull auf `origin/serverfix` durchführen.

### Löschen entfernter Branches ###

Stellen wir uns du bist fertig mit deinem Remote-Branch - sagen wir deine Mitarbeiter und du, Ihr seid fertig mit einer neuen Funktion und habt sie in den entfernten `master`-Branch (oder in welchem Zweig Ihr sonst den stabilen Code ablegt) gemerged. Du kannst einen Remote-Branch mit der unlogischen Syntax `git push [remotename] :[branch]` löschen. Wenn du deinen `serverfix`-Branch vom Server löschen möchtest, führe folgendes aus:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. Kein Zweig mehr auf deinem Server. Du möchtest dir diese Seite vielleicht markieren, weil du dieses Kommando noch benötigen wirst und man leicht dessen Syntax vergisst. Ein Weg sich an dieses Kommando zu erinnern führt über die `git push [remotename] [localbranch]:[remotebranch]`-Snytax, welche wir bereits behandelt haben. Wenn du den `[localbranch]`-Teil weglässt, dann sagst du einfach "Nimm nichts von meiner Seite und mach es zu `[remotebranch]`".

## Rebasing ##

Es gibt in Git zwei Wege um Änderungen von einem Branch in einen anderen zu überführen: das `merge` und das `rebase`-Kommando. In diesem Abschnitt wirst du kennenlernen was Rebasing ist, wie du es anwendest, warum es ein verdammt abgefahrenes Werkzeug ist und wann du es lieber nicht einsetzen möchtest.

### Der einfache Rebase ###

Wenn du zu einem früheren Beispiel aus dem Merge-Kapitel zurückkehrst (siehe Abbildung 3-27), wirst du sehen, dass du deine Arbeit auf zwei unterschiedliche Branches aufgeteilt hast.

Insert 18333fig0327.png
Abbildung 3-27. Deine initiale Commit-Historie zum Zeitpunkt der Aufteilung.

Der einfachste Weg um Zweige zusammenzuführen ist, wie bereits behandelt, das `merge`-Kommando. Es produziert einen Drei-Wege-Merge zwischen den beiden letzten Branch-Zuständen (C3 und C4) und ihrem wahrscheinlichsten Vorgänger (C2). Es produziert seinerseits einen Schnappschuss des Projektes (und einen Commit), wie in Abbildung 3-28 dargestellt.

Insert 18333fig0328.png
Abbildung 3-28. Das Zusammenführen eines Branches um die verschiedenen Arbeitsfortschritte zu integrieren.

Wie auch immer, es gibt noch einen anderen Weg: du kannst den Patch der Änderungen - den wir in C3 eingeführt haben -  über C4 anwenden. Dieses Vorgehen nennt man in Git _rebasing_. Mit dem `rebase`-Kommando kannst du alle Änderungen die auf einem Branch angewendet wurden auf einen anderen Branch erneut anwenden.

In unserem Beispiel würdest du folgendes ausführen:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command 

Dies funktioniert, indem Git zu dem gemeinsamen/allgemeinen Vorfahren [gemeinsamer Vorfahr oder der Ursprung der beiden Branches?] der beiden Branches (des Zweiges auf dem du arbeitest und des Zweiges auf den du _rebasen_ möchtest) geht, die Differenzen jedes Commits des aktuellen Branches ermittelt und temporär in einer Datei ablegt. Danach wird der aktuelle Branch auf den Schnittpunkt der beiden Zweige zurückgesetzt und alle zwischengespeicherte Commits nacheinander auf Zielbranch angewendet. Die Abbildung 3-29 bildet diesen Prozess ab.

Insert 18333fig0329.png
Abbildung 3-29. Rebasen der Änderungen durch C3 auf den Zweig C4.

An diesem Punkt kannst du zurück zum Master-Branch wechseln und einen fast-forward Merge durchführen (siehe Abbildung 3-30).

Insert 18333fig0330.png
Abbildung 3-30. Fast-forward des Master-Branches.

Nun ist der Schnappschuss, auf den C3 zeigt, exakt der gleiche, wie der auf den C5 in dem Merge-Beispiel gezeigt hat. Bei dieser Zusammenführung entsteht kein unterschiedliches Produkt, durch Rebasing ensteht allerdings ein sauberer Verlauf. Bei genauerer Betrachtung der Historie, entpuppt sich der Rebased-Branch als linearer Verlauf - es scheint als sei die ganze Arbeit in einer Serie entstanden, auch wenn sie in Wirklichkeit parallel stattfand.

Du wirst das häufig anwenden um sicherzustellen, dass sich deine Commits sauber in einen Remote-Branch integrieren - möglicherweise in einem Projekt bei dem du dich beteiligen möchtest, du jedoch nicht der Verantwortliche bist. In diesem Fall würdest du deine Arbeiten in einem eigenen Branch erledigen und im Anschluss deine Änderungen auf `origin/master` rebasen. Dann hätte der Verantwortliche nämliche keinen Aufwand mit der Integration - nur einen Fast-Forward oder eine saubere Integration (= Rebase?).

Beachte, dass der Schnappschuss nach dem letzten Commit, ob es der letzte der Rebase-Commits nach einem Rebase oder der finale Merge-Commit nach einem Merge ist, exakt gleich ist. Sie unterscheiden sich nur in ihrem Verlauf. Rebasing wiederholt einfach die Änderungen einer Arbeitslinie auf einer anderen, in der Reihenfolge in der sie entstanden sind. Im Gegensatz hierzu nimmt Merging die beiden Endpunkte der Arbeitslinien und führt diese zusammen.

### Mehr interessante Rebases ###

Du kannst deinen Rebase auch auf einem anderen Branch als dem Rebase-Branch anwenden lassen. Nimm zum Beispiel den Verlauf in Abbildung 3-31. Du hattest einen Themen-Branch (`server`) eröffnet um ein paar serverseitige Funktionalitäten zu deinem Projekt hinzuzufügen und einen Commit gemacht. Dann hast du einen weiteren Branch abgezweigt um clientseitige Änderungen (`client`) vorzunehmen und dort ein paarmal committed. Zum Schluss hast du wieder zu deinem Server-Branch gewechselt und ein paar weitere Commits gebaut.

Insert 18333fig0331.png
Abbildung 3-31. Ein Verlauf mit einem Themen-Branch basierend auf einem weiteren Themen-Branch.

Stell dir vor du entscheidest dich deine clientseitigen Änderungen für einen Release in die Hauptlinie zu mergen, die serverseitigen Änderungen möchtest du aber noch zurückhalten bis sie besser getestet wurden. Du kannst einfach die Änderungen am Client, die den Server nicht betreffen, (C8 und C9) mit der `--onto`-Option von `git rebase` erneut auf den Master-Branch anwenden:

	$ git rebase --onto master server client

Das bedeutet einfach “Checke den Client-Branch aus, finde die Patches heraus die auf dem gemeinsamen Vorfahr der `client`- und `server`-Branches basieren und wende sie erneut auf dem `master`-Branch an.” Das ist ein bisschen komplex aber das Ergebnis - wie in Abbildung 3-32 - ist richtig cool.

Insert 18333fig0332.png
Abbildung 3-32. Rebasing eines Themen-Branches von einem anderen Themen-Branch.

Jetzt kannst du deinen Master-Branch fast-forwarden (siehe Abbildung 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
Abbildung 3-33. Fast-forwarding deines Master-Branches um die Client-Branch-Änderungen zu integrieren.

Lass uns annehmen, du entscheidest dich deinen Server-Branch ebenfalls einzupflegen. Du kannst den Server-Branch auf den Master-Branch rebasen ohne diesen vorher auschecken zu müssen, indem du das Kommando `git rebase [Basis-Branch] [Themen-Branch]` ausführst. Es macht für dich den Checkout des Themen-Branches (in diesem Fall `server`) und wiederholt ihn auf dem Basis-Branch (`master`):

	$ git rebase master server

Das wiederholt deine `server`-Arbeit auf der Basis der `server`-Arbeit, wie in Abbildung 3-34 ersichtlich.

Insert 18333fig0334.png
Abbildung 3-34. Rebasing deines Server-Branches auf deinen Master-Branch.

Dann kannst du den Basis-Branch (`master`) fast-forwarden:

	$ git checkout master
	$ git merge server

Du kannst den `client`- und `server`-Branch nun entfernen, da du die ganze Arbeit bereits integriert wurde und Sie nicht mehr benötigst. Du hinterlässt den Verlauf für den ganzen Prozess wie in Abbildung 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
Abbildung 3-35: Endgültiger Commit-Verlauf.

### Die Gefahren des Rebasings ###

Ahh, aber der ganze Spaß mit dem Rebasing kommt nicht ohne seine Schattenseiten, welche in einer einzigen Zeile zusammengefasst werden können:

**Rebase keine Commits die du in ein öffentliches Repository hochgeladen hast.**

Wenn du diesem Ratschlag folgst ist alles in ordnung. Falls nicht werden die Leute dich hassen und du wirst von deinen Freunden und deiner Familie verachtet.

Wenn du Zeug rebased, hebst du bestehende Commits auf und erstellst stattdessen welche, die zwar ähnlich aber unterschiedlich sind. Wenn du Commits irgendwohin hochlädst und andere ziehen sich diese herunter und nehmen sie als Grundlage für ihre Arbeit, dann müssen deine Mitwirkenden ihre Arbeit jedesmal re-mergen, sobald du deine Commits mit einem `git rebase` überschreibst und verteilst. Und richtig chaotisch wird's wenn du versuchst deren Arbeit in deine Commits zu integrieren.

Lass uns mal ein Beispiel betrachten wie das Rebasen veröfentlichter Arbeit Probleme verursachen kann. Angenommen du klonst von einem zentralen Server und werkelst ein bisschen daran rum. Dein Commit-Verlauf sieht wie in Abbildung 3-36 aus.

Insert 18333fig0336.png
Abbildung 3-36. Klon ein Repository und baue etwas darauf auf.

Ein anderer arbeitet unterdessen weiter, macht einen Merge und lädt seine Arbeit auf den zentralen Server. Du fetchst die Änderungen und mergest den neuen Remote-Branch in deine Arbeit, sodass dein Verlauf wie in Abbildung 3-37 aussieht.

Insert 18333fig0337.png
Abbildung 3-37. Fetche mehrere Commits und merge sie in deine Arbeit.

Als nächstes entscheidet sich die Person, welche den Merge hochgeladen hat diesen rückgängig zu machen und stattdessen die Commits zu rebasen. Sie macht einen `git push --force` um den Verlauf auf dem Server zu überschreiben. Du lädst dir das Ganze dann mit den neuen Commits herunter.

Insert 18333fig0338.png
Abbildung 3-38. Jemand pusht rebased Commits und verwirft damit Commitd auf denen deine Arbeit basiert.

Nun musst du seine Arbeit erneut in deine Arbeitslinie mergen, obwohl du das bereits einmal gemacht hast. Rebasing ändert die SHA-1-Hashes der Commits, weshalb sie für Git wie neue Commits aussehen. In Wirklichkeit hast du die C4-Arbeit bereits in deinem Verlauf (siehe Abbildung 3-39).

Insert 18333fig0339.png
Abbildung 3-39. Du mergst die gleiche Arbeit nochmals in einen neuen Merge-Commit.

Irgendwann musst du seine Arbeit einmergen, damit du auch zukünftig mit dem anderen Entwickler zusammenarbeiten kannst. Danach wird dein Commit-Verlauf sowohl den C4 als auch den C4'-Commit enthalten, weche zwar verschiedene SHA-1-Hashes besitzen aber die gleichen Änderungen und die gleiche Commit-Beschreibung enthalten. Wenn du so einen Verluaf mit `git log` betrachtest, wirst immer zwei Commits des gleichen Autors, zur gleichen Zeit und mit der gleichen Commit-Nachricht sehen. Was ganz schön verwirrend ist. Wenn du diesen Verlauf außerdem auf den Server hochlädst, wirst du dort alle rebasierten Commits einführen, was auch noch andere verwirren kann.

Wenn du rebasing als Weg behandelst um aufzuräumen und mit Commits zu arbeiten, bevor du sie hochlädst und wenn du nur Commits rebased die noch nie publiziert wurden, dann fährst du goldrichtig. Wenn du Commits rebased die bereits veröffentlicht wurden und Leute vielleicht schon ihre Arbeit darauf aufgebaut haben, dann bist du vielleicht für frustrierenden Ärger verantwortlich.

## Zusammenfassung ##

Wir haben einfaches Branching und Merging mit Git behandelt. Du solltest nun gut damit zurecht kommen Branches zu erstellen, zwischen Branches zu wechseln und lokale Branches mit einem Merge zusammenzuführen. Ausserdem solltest du in der Lage sein deine Branches zu veröffentlichen indem du sie auf einen zentralen Server lädst, mit anderen auf öffentlichen Branches zusammenzuarbeiten und deine Branches zu rebasen bevor sie veröffentlicht werden.
