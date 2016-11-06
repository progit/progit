<!--# Git Tools #-->
# Git Tools #

<!--By now, you’ve learned most of the day-to-day commands and workflows that you need to manage or maintain a Git repository for your source code control. You’ve accomplished the basic tasks of tracking and committing files, and you’ve harnessed the power of the staging area and lightweight topic branching and merging.-->

Bis hierher hast Du die meisten täglichen Kommandos und Arbeitsweisen gelernt, die Du brauchst um ein Git-Repository für Deine Quellcode-Kontrolle, zu benutzen. Du hast die grundlegenden Aufgaben des Nachverfolgens und Eincheckens von Dateien gemeistert und Du hast von der Macht der Staging-Area, des Branching und des Mergens Gebrauch gemacht.

<!--Now you’ll explore a number of very powerful things that Git can do that you may not necessarily use on a day-to-day basis but that you may need at some point.-->

Als Nächstes werden wir einige sehr mächtige Werkzeuge besprechen, die Dir Git zur Verfügung stellt. Du wirst zwar nicht unbedingt jeden Tag verwenden, aber mit Sicherheit an einem bestimmten Punkt gut brauchen können.

<!--## Revision Selection ##-->
## Revision Auswahl ##

<!--Git allows you to specify specific commits or a range of commits in several ways. They aren’t necessarily obvious but are helpful to know.-->

Git erlaubt Dir, Commits auf verschiedenste Art und Weise auszuwählen. Diese sind nicht immer offensichtlich, aber es ist hilfreich diese zu kennen.

<!--### Single Revisions ###-->
### Einzelne Revisionen ###

<!--You can obviously refer to a commit by the SHA-1 hash that it’s given, but there are more human-friendly ways to refer to commits as well. This section outlines the various ways you can refer to a single commit.-->

Du kannst offensichtlich mithilfe des SHA-1-Hashes einen Commit auswählen, aber es gibt auch menschenfreundlichere Methoden, auf einen Commit zu verweisen. Dieser Bereich skizziert die verschiedenen Wege, die man gehen kann, um sich auf ein einzelnen Commit zu beziehen.

<!--### Short SHA ###-->
### Abgekürztes SHA ###

<!--Git is smart enough to figure out what commit you meant to type if you provide the first few characters, as long as your partial SHA-1 is at least four characters long and unambiguous — that is, only one object in the current repository begins with that partial SHA-1.-->

Git ist intelligent genug, den richtigen Commit herauszufinden, wenn man nur die ersten paar Zeichen angibt, aber nur unter der Bedingung, dass der SHA-1-Hash mindestens vier Zeichen lang und einzigartig ist — das bedeutet, dass es nur ein Objekt im derzeitigen Repository gibt, das mit diesem bestimmten SHA-1-Hash beginnt.

<!--For example, to see a specific commit, suppose you run a `git log` command and identify the commit where you added certain functionality:-->

Um zum Beispiel einen bestimmten Commit zu sehen, kann man das `git log` Kommando ausführen und den Commit identifizieren, indem man eine bestimmte Funktionalität hinzugefügt hat:

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

<!--In this case, choose `1c002dd....` If you `git show` that commit, the following commands are equivalent (assuming the shorter versions are unambiguous):-->

In diesem Fall wählt man `1c002dd....`, wenn man diesen Commit mit `git show` anzeigen lassen will, die folgenden Kommandos sind äquivalent (vorausgesetzt die verkürzte Version ist einzigartig):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

<!--Git can figure out a short, unique abbreviation for your SHA-1 values. If you pass `-\-abbrev-commit` to the `git log` command, the output will use shorter values but keep them unique; it defaults to using seven characters but makes them longer if necessary to keep the SHA-1 unambiguous:-->

Git kann auch selber eine Kurzform für Deine einzigartigen SHA-1-Werte erzeugen. Wenn Du `--abbrev-commit` dem `git log` Kommando übergibst, wird es den kürzeren Wert benutzen, diesen aber einzigartig halten; die Standardeinstellung sind sieben Zeichen, aber es werden automatisch mehr benutzt, wenn dies nötig ist, um den SHA-1-Hash eindeutig zu bezeichnen.

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

<!--Generally, eight to ten characters are more than enough to be unique within a project. One of the largest Git projects, the Linux kernel, is beginning to need 12 characters out of the possible 40 to stay unique.-->

Generell kann man sagen, dass acht bis zehn Zeichen mehr als ausreichend in einem Projekt sind, um eindeutig zu bleiben. Eines der größten Git-Projekte, der Linux-Kernel, fängt langsam an 12 von maximal 40 Zeichen zu nutzen, um eindeutig zu bleiben.

<!--### A SHORT NOTE ABOUT SHA-1 ###-->
### Ein kurzer Hinweis zu SHA-1 ###

<!--A lot of people become concerned at some point that they will, by random happenstance, have two objects in their repository that hash to the same SHA-1 value. What then?-->

Eine Menge Leute machen sich Sorgen, dass ab einem zufälligen Punkt zwei Objekte im Repository vorhanden sind, die den gleichen SHA-1-Hashwert haben. Was dann?

<!--If you do happen to commit an object that hashes to the same SHA-1 value as a previous object in your repository, Git will see the previous object already in your Git database and assume it was already written. If you try to check out that object again at some point, you’ll always get the data of the first object.-->

Wenn es passiert, dass bei einem Commit, ein Objekt mit dem gleichen SHA-1-Hashwert im Repository vorhanden ist, wird Git sehen, dass das vorherige Objekt bereits in der Datenbank vorhanden ist und davon ausgehen, dass es bereits geschrieben wurde. Wenn Du versuchst, das Objekt später wieder auszuchecken, wirst Du immer die Daten des ersten Objekts bekommen.

<!--However, you should be aware of how ridiculously unlikely this scenario is. The SHA-1 digest is 20 bytes or 160 bits. The number of randomly hashed objects needed to ensure a 50% probability of a single collision is about 2^80 (the formula for determining collision probability is `p = (n(n-1)/2) * (1/2^160)`). 2^80 is 1.2 x 10^24 or 1 million billion billion. That’s 1,200 times the number of grains of sand on the earth.-->

Allerdings solltest Du Dir bewusst machen, wie unglaublich unwahrscheinlich dieses Szenario ist. Die Länge des SHA-1-Hashs beträgt 20 Bytes oder 160 Bits. Die Anzahl der Objekte, die benötigt werden, um eine 50% Chance einer Kollision zu haben, beträgt ungefähr 2^80 (die Formel zum Berechnen der Kollisionswahrscheinlichkeit lautet `p = (n(n-1)/2) * (1/2^160)`). 2^80 ist somit 1.2 x 10^24 oder eine Trilliarde. Das ist 1200 Mal so viel, wie es Sandkörner auf der Erde gibt.

<!--Here’s an example to give you an idea of what it would take to get a SHA-1 collision. If all 6.5 billion humans on Earth were programming, and every second, each one was producing code that was the equivalent of the entire Linux kernel history (1 million Git objects) and pushing it into one enormous Git repository, it would take 5 years until that repository contained enough objects to have a 50% probability of a single SHA-1 object collision. A higher probability exists that every member of your programming team will be attacked and killed by wolves in unrelated incidents on the same night.-->

Hier ist ein Beispiel, das Dir eine Vorstellung davon gibt, was nötig ist, um in SHA-1 eine Kollision zu bekommen. Wenn alle 6,5 Milliarden Menschen auf der Erde programmieren würden und jeder jede Sekunde Code schreiben würde, der der gesamten Geschichte des Linux-Kernels (1 Million Git-Objekte) entspricht, und diesen dann in ein gigantisches Git-Repository übertragen würde, würde es fünf Jahre dauern, bis das Repository genügend Objekte hätte, um eine 50% Wahrscheinlichkeit für eine einzige SHA-1-Kollision aufzuweisen. Es ist wahrscheinlicher, dass jedes Mitglied Deines Programmierer-Teams, unabhängig voneinander, in einer Nacht von Wölfen angegriffen und getötet wird.

<!--### Branch References ###-->
### Branch-Referenzen ###

<!--The most straightforward way to specify a commit requires that it have a branch reference pointed at it. Then, you can use a branch name in any Git command that expects a commit object or SHA-1 value. For instance, if you want to show the last commit object on a branch, the following commands are equivalent, assuming that the `topic1` branch points to `ca82a6d`:-->

Am direktesten kannst Du einen Commit spezifizieren, wenn eine Branch-Referenz direkt auf ihn zeigt. In dem Fall kannst Du in allen Git-Befehlen, die ein Commit-Objekt oder einen SHA-1-Wert erwarten, stattdessen den Branch-Namen verwenden. Wenn Du z.B. den letzten Commit in einem Branch sehen willst, sind die folgenden Befehle äquivalent (vorausgesetzt der `topic1` Branch zeigt auf den Commit `ca82a6d`):

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

<!--If you want to see which specific SHA a branch points to, or if you want to see what any of these examples boils down to in terms of SHAs, you can use a Git plumbing tool called `rev-parse`. You can see Chapter 9 for more information about plumbing tools; basically, `rev-parse` exists for lower-level operations and isn’t designed to be used in day-to-day operations. However, it can be helpful sometimes when you need to see what’s really going on. Here you can run `rev-parse` on your branch.-->

Wenn Du sehen willst, auf welchen SHA-1-Wert ein Branch zeigt, oder wie unsere Beispiele intern in SHA-1-Werte übersetzt aussähen, kannst Du den Git-Plumbing-Befehl `rev-parse` verwenden. In Kapitel 9 werden wir genauer auf Plumbing-Befehle eingehen. Kurz gesagt ist `rev-parse` als eine Low-Level-Operation gedacht und nicht dafür, im tagtäglichen Gebrauch eingesetzt zu werden. Aber es kann manchmal hilfreich sein, wenn man wissen muss, was unter der Haube vor sich geht:

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

<!--### RefLog Shortnames ###-->
### RefLog Kurznamen ###

<!--One of the things Git does in the background while you’re working away is keep a reflog — a log of where your HEAD and branch references have been for the last few months.-->

Eine andere Sache, die während Deiner täglichen Arbeit im Hintergrund passiert ist, dass Git ein sogenanntes Reflog führt, d.h. ein Log darüber, wohin Deine HEAD- und Branch-Referenzen in den letzten Monaten jeweils gezeigt haben.

<!--You can see your reflog by using `git reflog`:-->

Du kannst das Reflog mit `git reflog` anzeigen:

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

<!--Every time your branch tip is updated for any reason, Git stores that information for you in this temporary history. And you can specify older commits with this data, as well. If you want to see the fifth prior value of the HEAD of your repository, you can use the `@{n}` reference that you see in the reflog output:-->

Immer dann, wenn ein Branch in irgendeiner Weise aktualisiert wird oder Du den aktuellen Branch wechselst, speichert Git diese Information ebenso im Reflog wie Commits und anderen Informationen. Wenn Du wissen willst, welches der fünfte Wert vor dem HEAD war, kannst Du die `@{n}` Referenz angeben, die Du in Reflog-Ausgabe sehen kannst:

	$ git show HEAD@{5}

<!--You can also use this syntax to see where a branch was some specific amount of time ago. For instance, to see where your `master` branch was yesterday, you can type-->

Außerdem kannst Du dieselbe Syntax verwenden, um eine Zeitspanne anzugeben. Um z.B. zu sehen, wo Dein `master` Branch gestern war, kannst Du eingeben:

	$ git show master@{yesterday}

<!--That shows you where the branch tip was yesterday. This technique only works for data that’s still in your reflog, so you can’t use it to look for commits older than a few months.-->

Das zeigt Dir, wo der `master` Branch gestern war. Diese Technik funktioniert nur mit Daten, die noch im Reflog sind, d.h. man kann sie nicht für Commits verwenden, die ein älter sind als ein paar Monate.

<!--To see reflog information formatted like the `git log` output, you can run `git log -g`:-->

Um Reflog Informationen in einem Format wie in `git log` anzeigen, kannst Du `git log -g` verwenden:

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

<!--It’s important to note that the reflog information is strictly local — it’s a log of what you’ve done in your repository. The references won’t be the same on someone else’s copy of the repository; and right after you initially clone a repository, you’ll have an empty reflog, as no activity has occurred yet in your repository. Running `git show HEAD@{2.months.ago}` will work only if you cloned the project at least two months ago — if you cloned it five minutes ago, you’ll get no results.-->

Es ist wichtig zu verstehen, dass das Reflog ausschließlich lokale Daten enthält. Es ist ein Log darüber, was Du in Deinem Repository getan hast, und es ist nie dasselbe wie in einem anderen Klon des selben Repositorys. Direkt nachdem Du ein Repository geklont hast, ist das Reflog leer, weil noch keine weitere Aktivität stattgefunden hat. `git show HEAD@{2.months.ago}` funktioniert nur dann, wenn das Projekt mindestens zwei Monate alt ist – wenn Du es vor fünf Minuten erst geklont hast, erhältst Du keine Ergebnisse.

<!--### Ancestry References ###-->
### Vorfahren Referenzen ###

<!--The other main way to specify a commit is via its ancestry. If you place a `^` at the end of a reference, Git resolves it to mean the parent of that commit.
Suppose you look at the history of your project:-->

Außerdem kann man Commits über ihre Vorfahren spezifizieren. Wenn Du ein `^` ans Ende einer Referenz setzt, schlägt Git den direkten Vorfahren dieses Commits nach. Nehmen wir an, Deine Historie sieht so aus:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

<!--Then, you can see the previous commit by specifying `HEAD^`, which means "the parent of HEAD":-->

Du kannst jetzt den vorletzten Commit mit `HEAD^` referenzieren, d.h. „den direkten Vorfahren von HEAD“.

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

<!--You can also specify a number after the `^` — for example, `d921970^2` means "the second parent of d921970." This syntax is only useful for merge commits, which have more than one parent. The first parent is the branch you were on when you merged, and the second is the commit on the branch that you merged in:-->

Außerdem kannst Du nach dem `^` eine Zahl angeben. Beispielsweise heißt `d921970^2`: „der zweite Vorfahr von d921970“. Diese Syntax ist allerdings nur für Merge Commits nützlich, die mehr als einen Vorfahren haben. Der erste Vorfahr ist der Branch, auf dem Du Dich beim Merge befandest, der zweite ist der Commit auf dem Branch, den Du gemergt hast.

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

<!--The other main ancestry specification is the `~`. This also refers to the first parent, so `HEAD~` and `HEAD^` are equivalent. The difference becomes apparent when you specify a number. `HEAD~2` means "the first parent of the first parent," or "the grandparent" — it traverses the first parents the number of times you specify. For example, in the history listed earlier, `HEAD~3` would be-->

Eine andere Vorfahren-Spezifikation ist `~`. Dies bezieht sich ebenfalls auf den ersten Vorfahren, d.h. `HEAD~` und `HEAD^` sind äquivalent. Einen Unterschied macht es allerdings, wenn Du außerdem eine Zahl angibst. `HEAD~2` bedeutet z.B. „der Vorfahr des Vorfahren von HEAD“ oder „der n-te Vorfahr von HEAD“. Beispielsweise würde `HEAD~3` in der obigen Historie auf den folgenden Commit zeigen:

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

<!--This can also be written `HEAD^^^`, which again is the first parent of the first parent of the first parent:-->

Dasselbe kannst Du mit `HEAD^^^` angeben, was wiederum den „Vorfahren des Vorfahren des Vorfahren“ referenziert:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

<!--You can also combine these syntaxes — you can get the second parent of the previous reference (assuming it was a merge commit) by using `HEAD~3^2`, and so on.-->

Du kannst diese Schreibweisen auch kombinieren und z.B. auf den zweiten Vorfahren der obigen Referenz mit `HEAD~3^2` zugreifen.

<!--### Commit Ranges ###-->
### Commit Reihen ###

<!--Now that you can specify individual commits, let’s see how to specify ranges of commits. This is particularly useful for managing your branches — if you have a lot of branches, you can use range specifications to answer questions such as, "What work is on this branch that I haven’t yet merged into my main branch?"-->

Nachdem Du jetzt einzelne Commits spezifizieren kannst, schauen wir uns an, wie man auf Commit-Reihen zugreift. Dies ist vor allem nützlich, um Branches zu verwalten, z.B. wenn man viele Branches hat und solche Fragen beantworten will wie „Welche Änderungen befinden sich in diesem Branch, die ich noch nicht in meinen Hauptbranch gemergt habe?“.

<!--#### Double Dot ####-->
#### Zwei-Punkte-Syntax ####

<!--The most common range specification is the double-dot syntax. This basically asks Git to resolve a range of commits that are reachable from one commit but aren’t reachable from another. For example, say you have a commit history that looks like Figure 6-1.-->

Die gängigste Weise, Commit-Reihen anzugeben, ist die Zwei-Punkte-Notation. Allgemein gesagt liefert Git damit eine Reihe von Commits, die von dem einem Commit aus erreichbar sind, allerdings nicht von dem anderen aus. Nehmen wir z.B. an, Du hättest eine Commit-Historie wie die folgende (Bild 6-1).

<!--Figure 6-1. Example history for range selection.-->

Insert 18333fig0601.png

<!--You want to see what is in your experiment branch that hasn’t yet been merged into your master branch. You can ask Git to show you a log of just those commits with `master..experiment` — that means "all commits reachable by experiment that aren’t reachable by master." For the sake of brevity and clarity in these examples, I’ll use the letters of the commit objects from the diagram in place of the actual log output in the order that they would display:-->

Du willst jetzt herausfinden, welche Änderungen in Deinem `experiment`-Branch sind, die noch nicht in den `master`-Branch gemergt wurden. Dann kannst Du ein Log dieser Commits mit `master..experiment` anzeigen, d.h. „alle Commits, die von `experiment` aus erreichbar sind, aber nicht von `master`“. Um die folgenden Beispiele ein bisschen abzukürzen und deutlicher zu machen, verwende ich für die Commit-Objekte die Buchstaben aus dem Diagramm anstelle der tatsächlichen Log Ausgabe:

	$ git log master..experiment
	D
	C

<!--If, on the other hand, you want to see the opposite — all commits in `master` that aren’t in `experiment` — you can reverse the branch names. `experiment..master` shows you everything in `master` not reachable from `experiment`:-->

Wenn Du allerdings – anders herum – diejenigen Commits anzeigen willst, die in `master`, aber noch nicht in `experiment` sind, kannst Du die Branch-Namen umdrehen: `experiment..master` zeigt „alles in `master`, das nicht in `experiment` enthalten ist“.

	$ git log experiment..master
	F
	E

<!--This is useful if you want to keep the `experiment` branch up to date and preview what you’re about to merge in. Another very frequent use of this syntax is to see what you’re about to push to a remote:-->

Dies ist nützlich, wenn Du vorhast, den `experiment`-Branch zu aktualisieren, und anzeigen willst, was Du dazu mergen wirst. Oder wenn Du vorhast, in ein Remote-Repository zu pushen und sehen willst, welche Commits betroffen sind:

	$ git log origin/master..HEAD

<!--This command shows you any commits in your current branch that aren’t in the `master` branch on your `origin` remote. If you run a `git push` and your current branch is tracking `origin/master`, the commits listed by `git log origin/master..HEAD` are the commits that will be transferred to the server.-->
<!--You can also leave off one side of the syntax to have Git assume HEAD. For example, you can get the same results as in the previous example by typing `git log origin/master..` — Git substitutes HEAD if one side is missing.-->

Dieser Befehl zeigt Dir alle Commits im gegenwärtigen, lokalen Branch, die noch nicht im `master`-Branch des `origin` Repositorys sind. D.h., der Befehl listet diejenigen Commits auf, die auf den Server transferiert würden, wenn Du `git push` benutzt und der aktuelle Branch `origin/master` trackt. Du kannst mit dieser Syntax außerdem eine Seite der beiden Punkte leer lassen. Git nimmt dann an, Du meinst an dieser Stelle HEAD. Z.B. kannst Du dieselben Commits wie im vorherigen Beispiel auch mit `git log origin/master..` anzeigen lassen. Git fügt dann HEAD auf der rechten Seite ein.

<!--#### Multiple Points ####-->
#### Mehrere Bezugspunkte ####

<!--The double-dot syntax is useful as a shorthand; but perhaps you want to specify more than two branches to indicate your revision, such as seeing what commits are in any of several branches that aren’t in the branch you’re currently on. Git allows you to do this by using either the `^` character or `-\-not` before any reference from which you don’t want to see reachable commits. Thus these three commands are equivalent:-->

Die Zwei-Punkte-Syntax ist eine nützliche Abkürzung, aber möglicherweise willst Du mehr als nur zwei Branches angeben, um z.B. herauszufinden, welche Commits in einem beliebigen anderen Branch enthalten sind, ausgenommen in demjenigen, auf dem Du Dich gerade befindest. Dazu kannst Du in Git das `^` Zeichen oder `--not` verwenden, um Commits auszuschließen, die von den angegebenen Referenzen aus erreichbar sind. D.h., die folgenden drei Befehle sind äquivalent:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

<!--This is nice because with this syntax you can specify more than two references in your query, which you cannot do with the double-dot syntax. For instance, if you want to see all commits that are reachable from `refA` or `refB` but not from `refC`, you can type one of these:-->

Das ist praktisch, weil Du auf diese Weise mehr als nur zwei Referenzen angeben kannst, was mit der Zwei-Punkte-Notation nicht geht. Wenn Du beispielsweise alle Commits sehen willst, die von `refA` oder `refB` erreichbar sind, nicht aber von `refC`, dann kannst Du folgende (äquivalente) Befehle benutzen:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

<!--This makes for a very powerful revision query system that should help you figure out what is in your branches.-->

Damit hast Du ein sehr mächtiges System von Abfragen zur Verfügung, mit denen Du herausfinden kannst, was in welchen Deiner Branches enthalten ist.

<!--#### Triple Dot ####-->
#### Drei-Punkte-Syntax ####

<!--The last major range-selection syntax is the triple-dot syntax, which specifies all the commits that are reachable by either of two references but not by both of them. Look back at the example commit history in Figure 6-1.-->
<!--If you want to see what is in `master` or `experiment` but not any common references, you can run-->

Die letzte wichtige Syntax, mit der man Commit-Reihen spezifizieren kann, ist die Drei-Punkte-Syntax, die alle Commits anzeigt, die in einer der beiden Referenzen enthalten sind, aber nicht in beiden. Schau Dir noch mal die Commit Historie in Bild 6-1 an. Wenn Du diejenigen Commits anzeigen willst, die in den `master`- und `experiment`-Branches, nicht aber in beiden Branches gleichzeitig enthalten sind, dann kannst Du folgendes tun:

	$ git log master...experiment
	F
	E
	D
	C

<!--Again, this gives you normal `log` output but shows you only the commit information for those four commits, appearing in the traditional commit date ordering.-->

Dies gibt Dir wiederum ein normale `log` Ausgabe, aber zeigt nur die Informationen dieser vier Commits – wie üblich sortiert nach dem Commit-Datum.

<!--A common switch to use with the `log` command in this case is `-\-left-right`, which shows you which side of the range each commit is in. This helps make the data more useful:-->

Eine nützliche Option für den `log` Befehl ist in diesem Fall `--left-right`. Sie zeigt Dir an, in welchem der beiden Branches der jeweilige Commit enthalten ist, sodass die Ausgabe noch nützlicher ist:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

<!--With these tools, you can much more easily let Git know what commit or commits you want to inspect.-->

Mit diesen Hilfsmitteln kannst Du noch einfacher und genauer angeben, welche Commits Du nachschlagen willst.

<!--## Interactive Staging ##-->
## Interaktives Stagen ##

<!--Git comes with a couple of scripts that make some command-line tasks easier. Here, you’ll look at a few interactive commands that can help you easily craft your commits to include only certain combinations and parts of files. These tools are very helpful if you modify a bunch of files and then decide that you want those changes to be in several focused commits rather than one big messy commit. This way, you can make sure your commits are logically separate changesets and can be easily reviewed by the developers working with you.-->
<!--If you run `git add` with the `-i` or `-\-interactive` option, Git goes into an interactive shell mode, displaying something like this:-->

Git umfasst eine Reihe von Skripten, die so manche Aufgabe auf der Kommandozeile leichter machen. Im Folgenden schauen wir uns einige interaktive Befehle an, die dabei hilfreich sein können, wenn man Änderungen in vielen Dateien vorgenommen hat, aber nur einige Änderungen gezielt committen will – nicht alles auf einmal in einem riesigen Commit. Auf diese Weise kann man Commits logisch gruppieren und macht es anderen Entwicklern damit leichter, sie zu verstehen. Wenn Du `git add` mit der `-i` oder `--interactive` Option verwendest, geht Git in einen interaktiven Shell-Modus, der in etwa wie folgt aussieht:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

<!--You can see that this command shows you a much different view of your staging area — basically the same information you get with `git status` but a bit more succinct and informative. It lists the changes you’ve staged on the left and unstaged changes on the right.-->

Wie Du siehst, zeigt dieser Befehl eine andere Ansicht der Staging-Area an – im Wesentlichen also die Information, die Du auch mit `git status` erhältst, aber anders formatiert, kurz und knapp, und informativer. Sie listet alle Änderungen, die in der Staging-Area enthalten sind, auf der linken Seite, und alle anderen Änderungen auf der rechten Seite.

<!--After this comes a Commands section. Here you can do a number of things, including staging files, unstaging files, staging parts of files, adding untracked files, and seeing diffs of what has been staged.-->

Danach folgt eine Liste von Befehlen wie, u.a., Dateien ganz oder teilweise stagen und unstagen, nicht versionskontrollierte Dateien hinzufügen, Diffs der gestageten Änderungen anzeigen etc.

<!--### Staging and Unstaging Files ###-->
### Hinzufügen und Enfernen von Dateien aus der Staging-Area ###

<!--If you type `2` or `u` at the `What now>` prompt, the script prompts you for which files you want to stage:-->

Wenn Du am `What now>` Prompt `2` oder `u` eingibst, wirst Du als Nächstes gefragt, welche Dateien Du stagen willst:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

<!--To stage the TODO and index.html files, you can type the numbers:-->

Um z.B. die TODO und index.html Dateien zu stagen, gibst Du die jeweiligen Zahlen ein:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

<!--The `*` next to each file means the file is selected to be staged. If you press Enter after typing nothing at the `Update>>` prompt, Git takes anything selected and stages it for you:-->

Das `*` neben den Dateinamen bedeutet, dass die Datei ausgewählt ist und zur Staging-Area hinzugefügt werden wird, sobald Du (bei einem sonst leeren `Update>>` Prompt) Enter drückst:

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

<!--Now you can see that the TODO and index.html files are staged and the simplegit.rb file is still unstaged. If you want to unstage the TODO file at this point, you use the `3` or `r` (for revert) option:-->

Du kannst sehen, dass die TODO und index.html Dateien jetzt gestaget sind, während simplegit.rb immer noch ungestaget ist. Wenn Du die TODO unstagen willst, kannst Du die Option `3` oder `r` (für revert) nutzen:

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

<!--Looking at your Git status again, you can see that you’ve unstaged the TODO file:-->

Wenn Du wiederum Deinen Git-Status ansiehst, kannst Du sehen, dass Du die TODO ungestaget hast.

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

<!--To see the diff of what you’ve staged, you can use the `6` or `d` (for diff) command. It shows you a list of your staged files, and you can select the ones for which you would like to see the staged diff. This is much like specifying `git diff -\-cached` on the command line:-->

Um einen Diff dessen zu sehen, das Du gestaget hast, kannst Du den Befehl `6` oder `d` (für diff) nutzen. Dieser zeigt Dir eine Liste der gestageten Dateien, und Du kannst diejenigen auswählen, von denen Du den gestageten Diff sehen willst. Dies ähnelt sehr dem Befehl `git diff --cached` auf der Kommandozeile.

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

<!--With these basic commands, you can use the interactive add mode to deal with your staging area a little more easily.-->

Mit diesen grundlegenden Befehlen kannst Du den interaktiven Hinzufüge-Modus nutzen, um Dir den Umgang mit Deiner Staging-Area etwas zu erleichtern.

<!--### Staging Patches ###-->
### Patches stagen ###

<!--It’s also possible for Git to stage certain parts of files and not the rest. For example, if you make two changes to your simplegit.rb file and want to stage one of them and not the other, doing so is very easy in Git. From the interactive prompt, type `5` or `p` (for patch). Git will ask you which files you would like to partially stage; then, for each section of the selected files, it will display hunks of the file diff and ask if you would like to stage them, one by one:-->

Es ist für Git auch möglich, bestimmte Teile einer Datei zu stagen und nicht den Rest. Wenn Du z.B. zwei Veränderungen an der simplegit.rb machst und eine davon stagen willst und die andere nicht, ist dies sehr einfach in Git möglich. Wähle `5` oder `p` (für patch) auf dem interaktiven Prompt. Git wird Dich fragen, welche Dateien Du teilweise stagen willst; dann wird es für jeden Abschnitt der gewählten Dateien Diff-Ausschnitte ausgeben und Dich jeweils einzeln fragen, ob Du sie stagen willst.

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

<!--You have a lot of options at this point. Typing `?` shows a list of what you can do:-->

Du hast an diesem Punkt viele Optionen. Tippe `?` ein, um eine Liste der Möglichkeiten zu bekommen:

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

<!--Generally, you’ll type `y` or `n` if you want to stage each hunk, but staging all of them in certain files or skipping a hunk decision until later can be helpful too. If you stage one part of the file and leave another part unstaged, your status output will look like this:-->

Im Allgemeinen, wirst Du `y` oder `n` nutzen, wenn Du jeden Ausschnitt stagen willst, aber alle Ausschnitte in bestimmten Dateien zu stagen oder die Entscheidung für einen Ausschnitt auf später zu verschieben kann auch sehr hilfreich sein. Wenn Du nur einen Teil der Datei stagest und den anderen ungestaget lässt, sieht Deine Status-Ausgabe in etwa so aus:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

<!--The status of the simplegit.rb file is interesting. It shows you that a couple of lines are staged and a couple are unstaged. You’ve partially staged this file. At this point, you can exit the interactive adding script and run `git commit` to commit the partially staged files.-->

Der Status der simplegit.rb ist interessant. Er zeigt Dir, dass ein paar Zeilen gestaget und ein paar ungestaget sind. Du hast diese Datei teilweise gestaget. An dieser Stelle kannst Du das interaktive Hinzufüge-Skript verlassen und `git commit` ausführen, um die teilweise gestageten Dateien zu commiten.

<!--Finally, you don’t need to be in interactive add mode to do the partial-file staging — you can start the same script by using `git add -p` or `git add -\-patch` on the command line.-->

Letztendlich musst Du nicht den interaktiven Hinzufüge-Modus nutzen, um Dateien teilweise zu stagen – Du kannst das gleiche Skript starten, indem Du `git add -p` oder `git add --patch` auf der Kommandozeile eingibst.

<!--## Stashing ##-->
## Stashen ##

<!--Often, when you’ve been working on part of your project, things are in a messy state and you want to switch branches for a bit to work on something else. The problem is, you don’t want to do a commit of half-done work just so you can get back to this point later. The answer to this issue is the `git stash` command.-->

Während man an einer bestimmten Funktion eines Projekts arbeitet, ist es oft so, dass man den Branch wechseln will, weil man an etwas anderem weiterarbeiten will. Meist ist dann auch das Arbeitsverzeichnis in einem chaotischen Zustand, da die Funktion noch nicht fertiggestellt ist. Das Problem dabei ist, dass Du Deine halbfertige Arbeit dann auch nicht committen möchtest, um später daran weiter arbeiten zu können. Die Lösung dieses Problems bietet der `git stash` Befehl.

<!--Stashing takes the dirty state of your working directory — that is, your modified tracked files and staged changes — and saves it on a stack of unfinished changes that you can reapply at any time.-->

Beim Stashen werden die aus Deinem Arbeitsverzeichnis noch nicht committeten Änderungen – also Deine geänderten beobachteten Dateien und die in der Staging-Area enthaltenen Dateien – in einem Stack voller unfertiger Änderungen gespeichert. Diese kannst Du dann jederzeit wieder vom Stack holen und auf Dein Arbeitsverzeichnis anwenden.

<!--### Stashing Your Work ###-->
### Stash verwenden ###

<!--To demonstrate, you’ll go into your project and start working on a couple of files and possibly stage one of the changes. If you run `git status`, you can see your dirty state:-->

Um dies zu demonstrieren, gehst Du in Dein Projekt und beginnst an ein paar Dateien zu arbeiten und merkst ein paar dieser Änderungen in der Staging-Area vor. Wenn Du den Befehl `git status` ausführst, siehst Du, dass sich einige Dateien seit dem letzen Commit verändert haben.

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

<!--Now you want to switch branches, but you don’t want to commit what you’ve been working on yet; so you’ll stash the changes. To push a new stash onto your stack, run `git stash`:-->

Jetzt kommt der Zeitpunkt, an dem Du den aktuellen Branch wechseln möchtest. Allerdings willst Du den aktuellen Zustand auch nicht committen, da Deine Arbeit noch nicht ganz fertiggestellt ist. Darum legst Du Deine Änderungen jetzt in einem Stash ab. Um diesen neuen Stash auf dem Stack abzulegen, verwendest Du den Befehl `git stash`:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

<!--Your working directory is clean:-->

In Deinem Arbeitsverzeichnis befinden sich jetzt keine geänderten Dateien mehr und die Staging-Area ist auch leer:

	$ git status
	# On branch master
	nothing to commit, working directory clean

<!--At this point, you can easily switch branches and do work elsewhere; your changes are stored on your stack. To see which stashes you’ve stored, you can use `git stash list`:-->

In diesem Zustand, kannst Du in beliebig andere Branches wechseln und an etwas anderem weiterarbeiten. Deine Änderungen sind alle in einem Stack gesichert. Um eine Übersicht, der bereits gestashten Änderungen anzusehen, kannst Du den Befehl `git stash list` verwenden:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

<!--In this case, two stashes were done previously, so you have access to three different stashed works. You can reapply the one you just stashed by using the command shown in the help output of the original stash command: `git stash apply`. If you want to apply one of the older stashes, you can specify it by naming it, like this: `git stash apply stash@{2}`. If you don’t specify a stash, Git assumes the most recent stash and tries to apply it:-->

In diesem Beispiel waren bereits zwei Stashes auf dem Stack vorhanden. Sie wurden zu einem früheren Zeitpunkt gespeichert. Dir stehen jetzt also drei verschiedene Stashes auf dem Stack zur Verfügung. Mit dem Befehl `git stash apply` kannst Du die zuletzt gestashten Änderungen in Deinem Arbeitsverzeichnis wiederherstellen. Git zeigt diesen Befehlsaufruf auch bei Ausführen des Befehls `git stash` als Hilfestellung an. Wenn Du einen der älteren Stashes auf Dein Arbeitsverzeichnis anwenden willst, kannst Du den entsprechenden Stashnamen an den Befehl anhängen: `git stash apply stash@{2}`. Wie Du bereits gesehen hast, verwendet Git die zuletzt gestashten Änderungen und versucht diese im Arbeitsverzeichnis wiederherzustellen, wenn der Stashname nicht angegeben wird:

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

<!--You can see that Git re-modifies the files you uncommitted when you saved the stash. In this case, you had a clean working directory when you tried to apply the stash, and you tried to apply it on the same branch you saved it from; but having a clean working directory and applying it on the same branch aren’t necessary to successfully apply a stash. You can save a stash on one branch, switch to another branch later, and try to reapply the changes. You can also have modified and uncommitted files in your working directory when you apply a stash — Git gives you merge conflicts if anything no longer applies cleanly.-->

Wie Du sehen kannst, stellt Git die Dateien wieder her, die Du in einem Stash gespeichert hast. In dem Beispiel war Dein Arbeitsverzeichnis in einem sauberen Zustand, als Du versucht hast, den Stash zurückzuladen. Ebenso wurde der Stash auf dem gleichen Branch angewandt, der auch beim Stashen der Änderungen ausgecheckt war. Aber es ist nicht zwingend notwendig, dass der gleiche Branch verwendet wird und dass das Arbeitsverzeichnis in einem sauberen Zustand ist, wenn ein Stash zurückgeladen wird. Du kannst die Änderungen in einem Stash ablegen, zu einem anderen Branch wechseln und die Änderungen in diesem neuen Branch wiederherstellen. Es können auch geänderte oder gestagte Dateien im Arbeitsverzeichnis vorhanden sein, während ein Stash zurückgeladen wird. Können die Änderungen nicht ordnungsgemäß zurückgeladen werden, zeigt Git einen entsprechenden Merge-Konflikt an.

<!--The changes to your files were reapplied, but the file you staged before wasn’t restaged. To do that, you must run the `git stash apply` command with a `-\-index` option to tell the command to try to reapply the staged changes. If you had run that instead, you’d have gotten back to your original position:-->

Die Änderungen an den Dateien wurden in Deinem Arbeitsverzeichnis wiederhergestellt. Allerdings ist die Datei, die beim Stashen in der Staging-Area vorhanden war, nicht automatisch wieder in die Staging-Area gewandert. Wenn Du die Option `--index` an den Befehl `git stash apply` anhängst, wird Git versuchen, die Dateien wieder zu stagen. Wenn Du diesen Befehl angewandt hättest, wäre Dein Arbeitsverzeichnis und Deine Staging-Area im exakt gleichen Zustand, wie vor dem Stashen:

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

<!--The apply option only tries to apply the stashed work — you continue to have it on your stack. To remove it, you can run `git stash drop` with the name of the stash to remove:-->

Mit der Option `apply` wird nur versucht die Änderungen wiederherzustellen. Der Stash an sich bleibt weiterhin auf dem Stack vorhanden. Um diesen zu entfernen, kannst Du den Befehl `git stash drop` zusammen mit dem Namen des Stashes anwenden:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

<!--You can also run `git stash pop` to apply the stash and then immediately drop it from your stack.-->

Um den Stash zurückzuführen und gleichzeitig vom Stack zu entfernen, kann der Befehl `git stash pop` verwendet werden.

<!--### Un-applying a Stash ###-->
### Zurückgeführten Stash wieder rückgängig machen ###

<!--In some use case scenarios you might want to apply stashed changes, do some work, but then un-apply those changes that originally came from the stash. Git does not provide such a `stash unapply` command, but it is possible to achieve the effect by simply retrieving the patch associated with a stash and applying it in reverse:-->

Stellen wir uns folgendes Szenario vor: Du wendest die Änderungen eines Stashes wieder auf das Arbeitsverzeichnis an und änderst danach noch ein paar Dateien von Hand. Jetzt möchtest Du die Änderungen, die vom Stash her rühren, aber wieder rückgängig machen. Git besitzt kein Feature, welches dies möglich macht. Allerdings kann man den gleichen Effekt erzeugen, indem man vom betreffenden Stash einen Patch erzeugt und diesen mit der Option `-R` wieder anwendet (Patch rückwärts anwenden).

    $ git stash show -p stash@{0} | git apply -R

<!--Again, if you don’t specify a stash, Git assumes the most recent stash:-->

An dieser Stelle noch einmal der Hinweis, dass Git den zuletzt erstellten Stash verwendet, wenn kein Stashname angegeben wird:

    $ git stash show -p | git apply -R

<!--You may want to create an alias and effectively add a `stash-unapply` command to your Git. For example:-->

Wenn Du dieses Feature öfters benötigst, ist es wahrscheinlich sinnvoll, einen Alias `stash-unapply` in Git dafür anzulegen:

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

<!--### Creating a Branch from a Stash ###-->
### Branch auf Basis eines Stashes erzeugen ###

<!--If you stash some work, leave it there for a while, and continue on the branch from which you stashed the work, you may have a problem reapplying the work. If the apply tries to modify a file that you’ve since modified, you’ll get a merge conflict and will have to try to resolve it. If you want an easier way to test the stashed changes again, you can run `git stash branch`, which creates a new branch for you, checks out the commit you were on when you stashed your work, reapplies your work there, and then drops the stash if it applies successfully:-->

Wenn Du einen Teil Deiner Arbeit in einem Stash ablegst, dort eine Weile liegen lässt und danach Deine Arbeit an dem Branch fortsetzt, der auch für den Stash verwendet wurde, hast Du vielleicht später Probleme beim Zurückführen des Stashes. Wenn beim Anwenden des Stashes Dateien modifiziert werden sollen, die Du im bisherigen Verlauf bereits geänderst hast, werden Merge-Konflikte auftreten, die Du manuell auflösen musst. Wenn Du nach einer einfachen Möglichkeit suchst, die gestashten Änderungen separat zu testen, kannst Du den Befehl `git stash branch` verwenden. Dieser Befehl erzeugt einen neuen Branch, checkt den Commit aus, auf dessen Basis der Stash erstellt wurde, und führt den Stash wieder in das Arbeitsverzeichnis zurück. Wenn dabei kein Fehler auftritt, wird der Stash automatisch gelöscht:

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

<!--This is a nice shortcut to recover stashed work easily and work on it in a new branch.-->

Damit ist es auf einfache Art und Weise möglich, die gestashten Änderungen in einem neuen Branch wiederherzustellen und daran weiterzuarbeiten.

<!--## Rewriting History ##-->
## Änderungshistorie verändern ##

<!--Many times, when working with Git, you may want to revise your commit history for some reason. One of the great things about Git is that it allows you to make decisions at the last possible moment. You can decide what files go into which commits right before you commit with the staging area, you can decide that you didn’t mean to be working on something yet with the stash command, and you can rewrite commits that already happened so they look like they happened in a different way. This can involve changing the order of the commits, changing messages or modifying files in a commit, squashing together or splitting apart commits, or removing commits entirely — all before you share your work with others.-->

Beim Arbeiten mit Git kommt es häufig vor, dass man seine Commit-Historie aus irgendeinem Grund noch einmal ändern möchte. Und das Tolle an Git ist, dass es Dir die Möglichkeit bietet, Entscheidungen erst im allerletzten Moment zu treffen. Zum Beispiel bietet Dir Git mit Hilfe der Staging-Area die Möglichkeit, alle Dateien zu sammeln und kurz vor einem Commit zu entscheiden, welche Daten alle in einen Commit wandern sollen. Du kannst auch Deine Dateien, die sich geändert haben, aber noch nicht ins Repository eingepflegt werden sollen, mit dem Stash-Kommando in einem Zwischenspeicher ablegen. Außerdem kannst Du bereits verfasste Commits nachträglich noch einmal ändern, sodass sich die Historie so ändert, als wäre sie ganz anders vorangeschritten. Das kann man zum Beispiel durch Änderung der Reihenfolge der Commits, durch Ändern von Commit-Nachrichten, durch Modifikationen an Dateien innerhalb eines Commits, durch Zusammenfügen zweier Commits zu einem Commit oder durch Löschen eines Commits erreichen. Und das Besondere daran: Das alles, bevor Du Deine Arbeit mit anderen teilst und veröffentlichst.

<!--In this section, you’ll cover how to accomplish these very useful tasks so that you can make your commit history look the way you want before you share it with others.-->

In diesem Kapitel werden wir die nützlichen Arbeitsschritte besprechen, die Dir helfen, Deine Commit-Historie Deinen Wünschen entsprechend zu gestalten, sodass Du Dein Ergebnis danach mit anderen teilen kannst und es damit Deinem gewünschten Ergebnis entspricht.

<!--### Changing the Last Commit ###-->
### Ändern des letzten Commits ###

<!--Changing your last commit is probably the most common rewriting of history that you’ll do. You’ll often want to do two basic things to your last commit: change the commit message, or change the snapshot you just recorded by adding, changing and removing files.-->

Am häufigsten möchte man wahrscheinlich seinen letzten durchgeführten Commit noch einmal nachträglich ändern. Meist sind es zwei Dinge, die man verändern möchte: Änderung der eingegebenen Commit-Nachricht oder den eigentlichen Inhalt des Schnappschusses durch Hinzufügen, Ändern oder Löschen von Dateien.

<!--If you only want to modify your last commit message, it’s very simple:-->

Die letzte Commit-Nachricht noch einmal zu ändern ist sehr einfach:

	$ git commit --amend

<!--That drops you into your text editor, which has your last commit message in it, ready for you to modify the message. When you save and close the editor, the editor writes a new commit containing that message and makes it your new last commit.-->

Nach Eingabe dieses Befehls wird der Texteditor mit dem Inhalt der letzten Commit-Nachricht geöffnet. Jetzt hat man Gelegenheit diesen Text zu ändern. Nach dem Speichern und Schließen des Editors, wird die Commit-Nachricht des letzten Commits entsprechend angepasst. Der alte Commit ist dadurch nicht mehr vorhanden und Du erhältst einen neuen Commit mit dem gleichen Inhalt und Deiner neuen Commit-Nachricht.

<!--If you’ve committed and then you want to change the snapshot you committed by adding or changing files, possibly because you forgot to add a newly created file when you originally committed, the process works basically the same way. You stage the changes you want by editing a file and running `git add` on it or `git rm` to a tracked file, and the subsequent `git commit -\-amend` takes your current staging area and makes it the snapshot for the new commit.-->

Wenn Du Deine Änderungen bereits eingecheckt hast und den Schnappschuss nachträglich durch Hinzufügen oder Ändern von Dateien noch einmal ändern möchtest, läuft das im Prinzip auf die gleiche Art und Weise ab. Meist kommt so etwas vor, weil man vergessen hat, eine neu erstellte Datei zu stagen. Wenn so etwas passiert, kannst Du Folgendes machen: Führe Deine gewünschte Änderungen durch Ändern oder Hinzufügen einer Datei aus und stage dieses Ergebnis mit dem Befehl `git add`. Alternativ kannst Du auch mit dem Befehl `git rm` eine Datei aus dem Repository entfernen. Wenn die Staging-Area Dein gewünschtes Ergebnis enthält, führst Du einfach den Befehl  `git commit --amend` aus. Der neue Commit enthält nun die Änderungen aus dem alten Commit plus die Änderungen aus Deiner Staging-Area.

<!--You need to be careful with this technique because amending changes the SHA-1 of the commit. It’s like a very small rebase — don’t amend your last commit if you’ve already pushed it.-->

Mit dem Befehl `--amend` sollte man vorsichtig umgehen, weil sich mit jeder nachträglichen Modifikation eines Commits auch die SHA-1-Prüfsumme ändert. Das Ändern des letzten Commits hat ein ähnliches Verhalten wie das Durchführen eines Rebase-Befehls. Deshalb sollte man einen Commit niemals nachträglich anpassen, wenn dieser bereits veröffentlicht wurde.

<!--### Changing Multiple Commit Messages ###-->
### Änderung von mehreren Commit-Nachrichten ###

<!--To modify a commit that is farther back in your history, you must move to more complex tools. Git doesn’t have a modify-history tool, but you can use the rebase tool to rebase a series of commits onto the HEAD they were originally based on instead of moving them to another one. With the interactive rebase tool, you can then stop after each commit you want to modify and change the message, add files, or do whatever you wish. You can run rebase interactively by adding the `-i` option to `git rebase`. You must indicate how far back you want to rewrite commits by telling the command which commit to rebase onto.-->

Um einen Commit, der etwas weiter in der Historie zurückliegt, zu ändern, hilft einem der Befehl `--amend` nicht weiter. Man benötigt dazu ein etwas mächtigeres und komplexeres Werkzeug. Für diese Aufgabe kann man den Rebase-Befehl, den wir bereits kennengelernt haben, auf eine etwas andere Art und Weise nutzen. Anstatt den Rebase auf einen HEAD eines anderen Commits auszuführen, führt man den Rebase auf genau dem gleichen Commit aus, auf dem er bereits basiert. Dazu müssen wir nur den interaktiven Modus des Rebase-Befehls nutzen. Dieser bietet einem die Möglichkeit bei jedem Commit, der geändert werden soll, zu stoppen. Dann kann man seine Änderungen an den Dateien oder an der Commit-Nachricht entsprechend einpflegen und mit dem nächsten Commit fortfahren. Um einen interaktiven Rebase durchzuführen, muss man die Option `-i` an den Befehl `git rebase` anhängen. Außerdem musst Du natürlich bestimmen, wie viele Commits Du ändern möchtest. Dazu musst Du den Commit angeben, auf welchem der Rebase basieren soll.

<!--For example, if you want to change the last three commit messages, or any of the commit messages in that group, you supply as an argument to `git rebase -i` the parent of the last commit you want to edit, which is `HEAD~2^` or `HEAD~3`. It may be easier to remember the `~3` because you’re trying to edit the last three commits; but keep in mind that you’re actually designating four commits ago, the parent of the last commit you want to edit:-->

Wenn Du zum Beispiel die letzten drei, oder eine oder mehrere der letzten drei Commit-Nachrichten ändern möchtest, musst Du zusätzlich zu dem Befehl `git rebase -i` den übergeordneten Commit (also dem Commit, der in der Historie genau ein Commit zurückliegt) des letzten Commits, den Du ändern möchtest, angeben. Bei drei Commit-Nachrichten müsste das Argument also `HEAD~2^` beziehungsweise `HEAD~3` lauten. Wahrscheinlich fällt es Dir leichter das Argument `~3` zu merken, weil Du ja schließlich auf die letzten drei Einträge verweisen möchtest. Du solltest Dir aber bewusst sein, dass Du auf den viertältesten Commit verweisen musst, also den übergeordneten Commit, den Du ändern möchtest.

	$ git rebase -i HEAD~3

<!--Remember again that this is a rebasing command — every commit included in the range `HEAD~3..HEAD` will be rewritten, whether you change the message or not. Don’t include any commit you’ve already pushed to a central server — doing so will confuse other developers by providing an alternate version of the same change.-->

Es ist wichtig, dass Du Dir bewusst bist, dass mit diesem Rebase-Befehl jeder Commit im Bereich `HEAD~3..HEAD` geändert wird, unabhängig davon, ob Du die Commit-Nachricht beziehungsweise den Schnappschuss änderst oder nicht. Der Rebase-Befehl sollte nie einen Commit beinhalten, der bereits an einen zentralen Server gepusht worden ist.
Hältst Du Dich nicht daran, werden sich andere Entwickler über Dich ärgern oder wundern, weil es jetzt eine alternative Version der gleichen Änderung gibt.

<!--Running this command gives you a list of commits in your text editor that looks something like this:-->

Wenn Du den Befehl ausführst, erhältst Du eine Reihe von Commits in Deinem Texteditor. Das könnte in etwa folgendermaßen aussehen:

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

<!--It’s important to note that these commits are listed in the opposite order than you normally see them using the `log` command. If you run a `log`, you see something like this:-->

Vielleicht ist es Dir schon aufgefallen, die Commits werden genau in der umgekehrten Reihenfolge dargestellt, wie sie der `log` Befehl ausgegeben hätte. Wenn Du also den Befehl `log` ausführst, erhält man in etwa die folgende Ausgabe:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

<!--Notice the reverse order. The interactive rebase gives you a script that it’s going to run. It will start at the commit you specify on the command line (`HEAD~3`) and replay the changes introduced in each of these commits from top to bottom. It lists the oldest at the top, rather than the newest, because that’s the first one it will replay.-->

Siehst Du den Unterschied? Es ist genau die umgekehrte Reihenfolge. Ein interaktiver Rebase wird nach einem festen Schema, einer Art Skript, durchgeführt und der Texteditor zeigt Dir an, wie dieses Skript genau ablaufen wird. Der Rebase startet bei dem Commit, der in der Kommandozeile angegeben wird (`HEAD~3`) und führt die Änderungen, die durch jeden Commit hinzukommen, von oben nach unten aus. Das bedeutet, dass anstatt des neuesten, der älteste Commit ganz oben steht, weil dieser der erste Commit ist, der bearbeitet wird.

<!--You need to edit the script so that it stops at the commit you want to edit. To do so, change the word pick to the word edit for each of the commits you want the script to stop after. For example, to modify only the third commit message, you change the file to look like this:-->

Du musst das Skript so anpassen, dass es an jedem Commit anhält, den Du ändern möchtest. Dazu musst Du bei jedem Commit, an dem das Skript anhalten soll, das Wort „pick“ mit dem Wort „edit“ ersetzen. Um zum Beispiel die drittälteste Commit-Nachricht zu ändern, müssen die Änderungen am Skript in etwa folgendermaßen aussehen:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

<!--When you save and exit the editor, Git rewinds you back to the last commit in that list and drops you on the command line with the following message:-->

Nachdem Du das Skript gespeichert und den Editor beendet hast, setzt Git nun alle Änderungen bis zum letzten Commit der Liste zurück und zeigt danach in der Kommandozeile in etwa Folgendes an:

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

<!--These instructions tell you exactly what to do. Type-->

Diese Anweisungen zeigen Dir sehr genau, was Du zu tun hast. Gib also den folgenden Befehl ein:

	$ git commit --amend

<!--Change the commit message, and exit the editor. Then, run-->

Im sich öffnenden Texteditor kannst Du jetzt die Commit-Nachricht ändern und danch wieder schließen. Danach führst Du folgenden Befehl aus:

	$ git rebase --continue

<!--This command will apply the other two commits automatically, and then you’re done. If you change pick to edit on more lines, you can repeat these steps for each commit you change to edit. Each time, Git will stop, let you amend the commit, and continue when you’re finished.-->

Der letzte Befehl speichert die letzten beiden Commits automatisch im Repository und der Rebase ist danach abgeschlossen. Wenn Du in einer weiteren Zeile „pick“ mit „edit“ ersetzt hast, kannst Du die oben dargestellten Schritte entsprechend noch einmal ausführen. Git wird nach jedem Commit anhalten und Dir die Möglichkeit bieten, den Commit anzupassen. Danach kannst Du Git auffordern, den Rebase fortzusetzen (`git rebase --continue`).

<!--### Reordering Commits ###-->
### Reihenfolge von Commits verändern ###

<!--You can also use interactive rebases to reorder or remove commits entirely. If you want to remove the "added cat-file" commit and change the order in which the other two commits are introduced, you can change the rebase script from this-->

Mit einem interaktiven Rebase kannst Du ebenso die Reihenfolge von Commits ändern oder sogar komplette Commits löschen. Um den Commit „added cat-file“ zu löschen und die Reihenfolge der beiden anderen Commits zu ändern, kannst Du das vorhandene Skript

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

<!--to this:-->

folgendermaßen ändern:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

<!--When you save and exit the editor, Git rewinds your branch to the parent of these commits, applies `310154e` and then `f7f3f6d`, and then stops. You effectively change the order of those commits and remove the "added cat-file" commit completely.-->

Nach dem Speichern und Verlassen des Editors, setzt Git nun alle Änderungen bis zum letzten Commit der Liste zurück, speichert den Commit `310154e`, danach den Commit `310154e` und beendet danach den Rebase. Das Ergebnis: Der Commit „added cat-file“ ist aus der Historie verschwunden und die Reihenfolge der beiden restlichen Commits ist getauscht.

<!--### Squashing Commits ###-->
### Mehrere Commits zusammenfassen ###

<!--It’s also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool. The script puts helpful instructions in the rebase message:-->

Man kann mit einem interaktiven Rebase auch mehrere Commits zu einem einzelnen Commit zusammenfassen. Im Skript der Rebase-Nachricht steht eine Anleitung, wie Du dazu vorgehen musst:

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

<!--If, instead of "pick" or "edit", you specify "squash", Git applies both that change and the change directly before it and makes you merge the commit messages together. So, if you want to make a single commit from these three commits, you make the script look like this:-->

Wenn Du statt „pick“ oder „edit“, den Befehl „squash“ angibst, führt Git beide Commits zu einem gemeinsamen Commit zusammen und bietet Dir die Möglichkeit, die Commit-Nachricht ebenso entsprechend zu verheiraten. Wenn Du also aus den drei Commits einen einzelnen Commit machen willst, muss Dein Skript folgendermaßen aufgebaut sein:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

<!--When you save and exit the editor, Git applies all three changes and then puts you back into the editor to merge the three commit messages:-->

Nach dem Speichern und Beenden des Editors, führt Git alle drei Änderungen zu einem einzelnen Commit zusammen und öffnet einen Texteditor, der alle drei Commit-Nachrichten enthält:


	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

<!--When you save that, you have a single commit that introduces the changes of all three previous commits.-->

Du kannst nun die Commit-Nachricht entsprechend anpassen oder auch entsprechend dem vorgeschlagenen Ergebnis belassen. Wenn Du die Commit-Nachricht speicherst, hast Du danach nur noch einen einzelnen Commit, der die letzten drei Commits beinhaltet, in Deiner Historie.

<!--### Splitting a Commit ###-->
### Aufsplitten eines einzelnen Commits ###

<!--Splitting a commit undoes a commit and then partially stages and commits as many times as commits you want to end up with. For example, suppose you want to split the middle commit of your three commits. Instead of "updated README formatting and added blame", you want to split it into two commits: "updated README formatting" for the first, and "added blame" for the second. You can do that in the `rebase -i` script by changing the instruction on the commit you want to split to "edit":-->

Man kann mit Git einen einzelnen Commit auch aufsplitten. Das bedeutet, man setzt den ursprünglichen Commit zurück, fügt dann einen Teil der Änderungen zur Staging-Area hinzu und checkt das Ergebnis ein. Dies kann man unbegrenzt oft wiederholen und so einen einzelnen Commit in mehrere Commits aufteilen. Nehmen wir an, wir möchten den mittleren der beiden Commits aufteilen. Anstatt „updated README formatting and added blame“, möchten wir den Commit in folgende beiden Commits aufteilen: „updated README formatting“ soll das Thema des ersten Commits und „added blame“ soll das Thema des zweiten Commits sein. Dazu kannst Du das angezeigte Skript, welches Dir der Befehl `rebase -i` erzeugt, folgendermaßen anpassen:

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

<!--When you save and exit the editor, Git rewinds to the parent of the first commit in your list, applies the first commit (`f7f3f6d`), applies the second (`310154e`), and drops you to the console. There, you can do a mixed reset of that commit with `git reset HEAD^`, which effectively undoes that commit and leaves the modified files unstaged. Now you can take the changes that have been reset, and create multiple commits out of them. Simply stage and commit files until you have several commits, and run `git rebase -\-continue` when you’re done:-->

Nach dem Speichern und Schließen des Editors, setzt Git die Änderungen entsprechend zurück und wendet den ersten (`f7f3f6d`) und zweiten (`310154e`) Commit an und wechselt danach zurück zur Kommandozeile. Jetzt hast Du die Möglichkeit den letzten Commit zurückzusetzen, ohne dass die Änderungen im Arbeitsverzeichnis zurückgesetzt werden. Das heißt, der Commit im Repository wird gelöscht, aber Deine Änderungen im Arbeitsverzeichnis gehen nicht verloren. Um dies durchzuführen, kannst Du den Befehl `git reset HEAD^` verwenden. Jetzt kannst Du die gewünschten Änderungen für den ersten Commit zur Staging-Area hinzufügen und danach einchecken. Diesen Vorgang kannst Du beliebig wiederholen, bis alle Änderungen eingecheckt sind. Wenn Du fertig bist, kannst Du den Rebase mit `git rebase --continue` fortsetzen beziehungsweise abschließen:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

<!--Git applies the last commit (`a5f4a0d`) in the script, and your history looks like this:-->

Git speichert dazu den letzten Commit (`a5f4a0d`) aus dem Skript im Repository. Das Resultat sieht in etwa folgendermaßen aus:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

<!--Once again, this changes the SHAs of all the commits in your list, so make sure no commit shows up in that list that you’ve already pushed to a shared repository.-->

Ich möchte Dich noch einmal darauf hinweisen, dass jede SHA-Prüfsumme von allen Commits aus der Liste geändert werden. Bitte stell also sicher, dass diese Commits in keinem öffentlichen Repository verfügbar sind.

<!--### The Nuclear Option: filter-branch ###-->
### Hol den Vorschlaghammer raus: filter-branch ###

<!--There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit. The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite. However, it can be very useful. You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of.-->

Es gibt noch eine weitere Möglichkeit, wie man die Historie nach seinen Wünschen anpassen kann. Diese wird oft angewandt, wenn man eine große Zahl von Commits automatisiert mit Hilfe eines Skripts anpassen will. Zum Beispiel kann man damit die E-Mail-Adresse in jedem Commit ändern oder auch eine Datei aus jedem Commit entfernen. Das Werkzeug dazu heißt `filter-branch`. Damit kann man einen riesigen Teil der Historie ändern. Man sollte diesen Befehl also nur verwenden, wenn das Projekt noch nicht weit verbreitet ist, oder andere Personen noch nicht damit begonnen haben an dem Projekt zu arbeiten (also auf Basis der bisherigen Historie neue Branches mit Commits erstellt wurden). Trotzdem kann dieses Werkzeug sehr nützlich sein. Ich möchte hier ein paar der Möglichkeiten dieses Werkzeugs vorstellen.

<!--#### Removing a File from Every Commit ####-->
#### Löschen einer Datei aus jedem Commit ####

<!--This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your project open source. `filter-branch` is the tool you probably want to use to scrub your entire history. To remove a file named passwords.txt from your entire history, you can use the `-\-tree-filter` option to `filter-branch`:-->

Dieses Szenario tritt sogar relativ häufig auf. Nehmen wir einmal an, jemand fügt gedankenlos eine große binäre Datei mit `git add .` zum Repository dazu und diese soll aber in keinem der Commits enthalten sein. Oder Du hast aus Versehen eine Datei, welche ein Passwort enthält, zum Repository hinzugefügt und möchtest dieses Repository nun veröffentlichen. `filter-branch` ist dann das Werkzeug Deiner Wahl, um die komplette Historie umzukrempeln. Um eine Datei mit dem Namen „passwords.txt“ aus der kompletten Historie zu löschen, kannst Du die Option `--tree-filter` verwenden:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

<!--The `-\-tree-filter` option runs the specified command after each checkout of the project and then recommits the results. In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch -\-tree-filter "rm -f *~" HEAD`.-->

Die Option `--tree-filer` führt den nachfolgenden Befehl nach jedem Auschecken eines Commits des Projekts aus und checkt danach das Ergebnis wieder ein. In diesem Beispiel wird die Datei „passwords.txt“ aus jedem Schnappschuss entfernt, unabhängig davon, ob sie existiert oder nicht. Ein anderes Beispiel wäre es, alle Backup-Dateien eines Texteditors aus dem Repository zu löschen. Dazu kann man in etwa den Befehl `git filter-branch -\-tree-filter "rm -f *~" HEAD` ausführen.

<!--You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end. It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want. To run `filter-branch` on all your branches, you can pass `-\-all` to the command.-->

Git informiert Dich über den Fortschritt dieses Vorgangs und Du siehst, wie jeder Commit angepasst wird und der Zeiger auf den Branch auf den letzten Commit gesetzt wird. Es ist empfehlenswert, diesen Befehl in einem Testzweig durchzuführen. Wenn das Ergebnis, wie gewünscht ausfällt, kann man danach den Branch master auf diesen Testzweig setzen. Wenn man an den Befehl `filter-branch` die Option `--all` anfügt, führt Git diesen Vorgang für jeden vorhandenen Zweig aus.

<!--#### Making a Subdirectory the New Root ####-->
#### Aus einem Unterverzeichnis das neue Wurzelverzeichnis machen ####

<!--Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on). If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too:-->

Wenn man zum Beispiel ein Projekt aus einem anderen Versionskontrollwerkzeug in Git importiert, gibt es dort oft Verzeichnisse, die in Git nicht relevant sind, zum Beispiel trunk, tags, usw.. Wenn man also das Unterverzeichnis `trunk` das neue Wurzelverzeichnis machen will, kann man dies mit Hilfe von `filter-branch` umsetzen:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

<!--Now your new project root is what was in the `trunk` subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory.-->

Nach der Ausführung dieses Befehls ist das „trunk“ Verzeichnis das neue Arbeitsverzeichnis. Bei diesem Vorgang entfernt Git außerdem alle Commits, die nicht eine Änderung des „trunk“-Verzeichnisses beinhalten.

<!--#### Changing E-Mail Addresses Globally ####-->
#### E-Mail Adresse in jedem Commit ändern ####

<!--Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address. In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well. You need to be careful to change only the e-mail addresses that are yours, so you use `-\-commit-filter`:-->

Verflixt, es ist schon wieder passiert. Du hast vergessen, den Befehl `git config` auszuführen und Deinen Namen und E-Mail-Adresse zu setzen, bevor Du mit der Arbeit begonnen hast. Mit `filter-branch` kann man diesen Fehler einfach beheben. Man sollte nur darauf achten, dass man nur seine eigene E-Mail-Adresse ändert. Deshalb verwenden wir die Option `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

<!--This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address.-->

Dieser Befehl durchforstet das Repository und ersetzt in jedem Commit, dessen E-Mail-Adresse des Autors „schacon@localhost“ lautet, mit der neuen E-Mail-Adresse „schacon@example.com“. Zusätzlich wird der Name des Autors geändert, falls dieser nicht vorher schon „Scott Chacon“ war. Auf Grund der Architektur, dass in Git in jedem Commit die SHA1-Prüfsumme des Vorgänger-Commits enthalten ist, ändert dieser Befehl jeden Commit in Deiner Historie. Die SHA1-Prüfsumme wird sich auch in allen Commits, die nicht die angegebene E-Mail-Adresse enthalten, verändern.

<!--## Debugging with Git ##-->
## Mit Hilfe von Git debuggen ##

<!--Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.-->

Git bietet auch ein paar Werkzeuge, die den Debug-Vorgang bei einem Projekt unterstützen. Da Git so aufgebaut ist, dass es für nahezu jedes Projekt eingesetzt werden kann, sind diese Werkzeuge sehr generisch gehalten. Wenn gewisse Dinge schief laufen, können Dir aber diese Tools oft helfen, den Bug oder den Übeltäter zu finden.

<!--### File Annotation ###-->
### Datei Annotation ###

<!--If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22:-->

Wenn Du nach einem Bug in Deinem Code suchst und gerne wissen willst, wann und warum dieser zum ersten Mal auftrat, dann kann Dir das Werkzeug Datei-Annotation (engl. File Annotation) sicher weiterhelfen. Es kann Dir anzeigen, in welchem Commit die jeweilige Zeile einer Datei zuletzt geändert wurde. Wenn Du also feststellst, dass eine Methode beziehungsweise eine Funktion in Deinem Code nicht mehr das gewünschte Resultat liefert, kannst Du Dir die Datei mit `git blame` genauer ansehen. Nach Aufruf des Befehls zeigt Git Dir an, welche Zeile von welcher Person als letztes geändert wurde, inklusive Datum. Das folgende Beispiel verwendet die Option `-L`, um die Ausgabe auf die Zeilen 12 bis 22 einzuschränken:

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

<!--Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.-->

In der ersten Spalte wird die Kurzform der SHA1-Prüfsumme des Commits angezeigt, in welchem diese Zeile zuletzt verändert wurde. Die nächsten beiden Spalten weisen auf den Autor des Commits und wann dieser verfasst wurde, hin. Auf diese Weise kannst Du leicht bestimmen, wer die jeweilige Zeile geändert hat und wann dies durchgeführt wurde. In den nächsten Spalten wird die Zeilennummer und der Inhalt der Zeile angezeigt. Die Zeilen mit der SHA-1-Prüfsumme `^4832fe2` weisen darauf hin, dass diese bereits im ersten Commit vorhanden waren. Das ist also der Commit, in dem die Datei „simplegit.rb“ zum Repository hinzugefügt wurde und die Zeilen deuten damit darauf hin, dass diese bisher nie geändert wurden. Das ist für Dich wahrscheinlich ein bisschen verwirrend, denn nun kennst Du bereits drei Möglichkeiten, wie Git mit dem Zeichen `^` einer SHA-Prüfsumme eine neue Bedeutung gibt. Aber in Zusammenhang mit  `git blame` weist das Zeichen auf den eben geschilderten Sachverhalt hin.

<!--Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:-->

Eine weitere herausragende Eigenschaft von Git ist die Tatsache, dass es nicht per se das Umbenennen von Dateien verfolgt. Git speichert immer den jeweiligen Schnappschuss des Dateisystems und versucht erst danach zu bestimmen, welche Dateien umbenannt wurden. Das bietet Dir zum Beispiel die Möglichkeit herauszufinden, wie Code innerhalb des Repositorys hin und her verschoben wurde. Wenn Du also die Option `-C` an `git blame` anfügst, analysiert Git die angegebene Datei und versucht herauszufinden, ob und von wo bestimmte Codezeilen herkopiert wurden. Vor kurzem habe ich ein Refactoring an einer Datei mit dem Namen `GITServerHandler.m` durchgeführt. Dabei habe ich diese Datei in mehrere Dateien aufgeteilt, eine davon war `GITPackUpload.m`. Wenn ich jetzt `git blame` mit der Option `-C` auf die Datei `GITPackUpload.m` ausführe, erhalte ich eine Ausgabe mit den Codezeilen, von denen das Ergebnis ursprünglich stammt:

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

<!--This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file.-->

Das ist enorm hilfreich. Für gewöhnlich erhältst Du damit als ursprünglichen Commit, den Commit, von welchem der Code kopiert wurde, da dies der Zeitpunkt war, bei dem diese Zeilen zum ersten Mal angefasst wurden. Git zeigt Dir den ursprünglichen Commit, in dem Du die Zeilen verfasst hast, sogar an, wenn es sich dabei um eine andere Datei handelt.

<!--### Binary Search ###-->
### Das Bisect Werkzeug – Binäre Suche###

<!--Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.-->

`git blame` kann Dir sehr weiterhelfen, wenn Du bereits weißt, an welcher Stelle das Problem liegt. Wenn Du aber nicht weißt, warum gewisse Dinge schief laufen, und es gibt inzwischen Dutzende oder Hunderte von Commits seit dem letzten funktionierenden Stand, dann solltest Du `git bisect` als Hilfestellung verwenden. Der `bisect` Befehl führt eine binäre Suche durch die Commit-Historie durch und hilft Dir auf schnelle Art und Weise die Commits zu bestimmen, die eventuell für das Problem verantwortlich sind.

<!--Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:-->

Nehmen wir zum Beispiel an, dass Du gerade eben Deinen Code in einer Produktivumgebung veröffentlicht hast und auf einmal bekommst Du zahlreiche Fehlerberichte über Probleme, die in Deiner Entwicklungsumgebung nicht aufgetreten sind. Du kannst Dir auch keinen Reim darauf bilden, warum der Code so reagiert. Nachdem Du Dich noch einmal näher mit Deinem Code beschäftigt hast, stellst Du fest, dass Du die Fehlerwirkung reproduzieren kannst, aber Dir ist es immer noch ein Rätsel, was genau schief läuft. Wenn Du vor einem solchen Problem stehst, hilft Dir es bestimmt, wenn Du die Historie in mehrere Teile aufspaltest (engl. bisect: halbieren, zweiteilen). Als erstes startest Du mit dem Befehl `git bisect start`. Danach gibst Du mit dem Befehl `git bisect bad` an, dass der derzeit ausgecheckte Commit den Fehler aufweist. Jetzt braucht Git noch die Information, in welchem Commit das Problem noch nicht aufgetreten ist. Dazu verwendest Du den Befehl `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

<!--Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:-->

Nach Ausführen des letzten Befehls, zeigt Git Dir als Erstes an, dass in etwa 12 Commits zwischen der letzten guten Revision (v1.0) und der aktuellen, fehlerhaften Revision liegen. Auf Basis dieser Information hat Git Dir den mittleren Commit ausgecheckt. Jetzt hast Du die Möglichkeit Deine Tests auf Basis des ausgecheckten Stands durchzuführen, um herauszufinden, ob in diesem Commit der Fehler bereits bestand. Wenn der Fehler hier bereits auftritt, dann wurde er in diesem oder in einem der früheren Commits eingefügt. Wenn der Fehler hier noch nicht auftritt, dann wurde er in einem der späteren Commits eingeschleppt. In unserem Beispiel nehmen wir an, dass in diesem Commit der Fehler noch nicht bestand. Das geben wir mit dem Befehl `git bisect good` an und fahren fort:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

<!--Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:-->

Git hat Dir jetzt einen weiteren Commit ausgecheckt, und zwar wieder den mittleren Commit zwischen dem letzten Stand im Repository und dem mittleren Commit aus der letzten Runde. Hier nehmen wir an, dass Du nach Deinen durchgeführten Tests feststellst, dass in diesem Commit der Fehler bereits vorhanden ist. Das müssen wir Git über `git bisect bad` mitteilen:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

<!--This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:-->

Git checkt wieder den nächsten mittleren Commit aus und wir stellen fest, dass dieser in Ordnung ist. Ab jetzt hat Git alle notwendigen Informationen um festzustellen, in welchem Commit der Fehler eingebaut wurde. Git zeigt Dir dazu die SHA-1-Prüfsumme des ersten fehlerhaften Commits an. Zusätzlich gibt es noch weitere Commit-Informationen und welche Dateien in diesem Commit geändert wurden, an. Das sollte Dir nun helfen, den Fehler näher zu bestimmen:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

<!--When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:-->

Wenn Du fertig mit der Fehlersuche bist, solltest Du den Befehl `git bisect reset` ausführen. Dies checkt den ursprünglichen Stand aus, den Du ausgecheckt hattest, bevor Du mit der Fehlersuche begonnen hast:

	$ git bisect reset

<!--This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:-->

Wie Du vielleicht gesehen hast, ist dieser Befehl ein mächtiges Werkzeug, um Hunderte von Commits auf schnelle Art und Weise nach einem bestimmten Fehler zu durchsuchen. Besonders nützlich ist es, wenn Du ein Skript hast, welches mit dem Fehlercode Null beendet, wenn das Projekt in Ordnung ist und mit einem Fehlercode größer Null, wenn das Projekt Fehler enthält. Wenn Dir ein solches Skript zur Verfügung steht, kannst Du den bisher manuell durchgeführten Vorgang auch automatisieren. Wie im vorigen Beispiel musst Du Git den zuletzt fehlerfreien Commit und den fehlerhaften Commit angeben. Als verkürzte Schreibweise kannst Du an den Befehl `bisect start` den fehlerhaften und den fehlerfreien Commit angeben:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

<!--Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.-->

Wenn Du die untere, genannte Zeile ausführst, führt Git automatisch nach jedem Auscheckvorgang das Skript `test-error.sh` aus und zwar solange bis es den Commit findet, der als erstes ein fehlerhaftes Ergebnis liefert. Statt eines Skripts kannst Du natürlich auch `make` oder `make tests` oder eine beliebige, andere Testumgebung starten.

<!--## Submodules ##-->
## Submodule ##

<!--It often happens that while working on one project, you need to use another project from within it. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.-->

Oft möchte man während der Arbeit an einem Projekt ein weiteres Projekt darin einbinden und verwenden. Das kann zum Beispiel eine Bibliothek von einer anderen Firma oder vielleicht auch eine selbstentwickelte Bibliothek sein. In einem solchen Szenario tritt dann meistens folgendes Problem auf: Die zwei Projekte sollen unabhängig voneinander entwickelt werden können, aber trotzdem soll es möglich sein, das eine Projekt im anderen zu verwenden.

<!--Here’s an example. Suppose you’re developing a web site and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.-->

Dazu ein Beispiel. Nehmen wir an, Du entwickelst gerade eine Webseite, die unter anderem einen Atom-Feed zur Verfügung stellen soll. Anstatt den notwendigen Code zur Auslieferung des Atom-Feeds selber zu schreiben, entscheidest Du Dich für eine geeignete Bibliothek. Dann wirst Du wahrscheinlich den Code in Dein Projekt einbinden müssen, zum Beispiel durch eine CPAN-Installation oder ein Ruby-Gem oder durch Kopieren des Quellcodes in das Arbeitsverzeichnis Deines Projekts. Das Problem beim Einbinden einer Bibliothek ist, dass es schwierig ist, diese an die eigene Bedürfnisse anzupassen. Noch schwieriger gestaltet sich dann die Veröffentlichung des Projekts, da man sicherstellen muss, dass jeder der die Software verwendet, auf die Bibliothek zugreifen kann. Wenn man die Bibliothek im eigenen Projekt projektspezifisch anpasst, hat man meist ein Problem, wenn man eine neue Version der Bibliothek einspielen will.

<!--Git addresses this issue using submodules. Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.-->

Git löst dieses Problem mit Hilfe von Submodulen. Mit Hilfe von Submodulen kann man innerhalb eines Git-Repositorys ein weiteres Git-Repository in einem Unterverzeichnis verwalten. Daraus entsteht der Vorteil, dass man ein anderes Repository in das eigene Projekt klonen kann und die Commits der jeweiligen Projekte trennen kann.

<!--### Starting with Submodules ###-->
### Die ersten Schritte mit Submodulen ###

<!--Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes. The first thing you should do is clone the external repository into your subdirectory. You add external projects as submodules with the `git submodule add` command:-->

Nehmen wir einmal an, dass Du die Rack-Bibliothek (eine Ruby-Gateway-Schnittstelle für Webserver) zu Deinem Projekt hinzufügen willst. Dabei möchtest Du Deine eigenen Änderungen an dieser Bibliothek nachverfolgen, aber auch weiterhin Änderungen von den Rack-Bibliothek-Entwicklern verwalten und zusammenmergen. Das erste was Du dazu tun musst, ist das Repository der Rack Bibliothek in ein Unterverzeichnis Deines Projekts zu klonen. Diesen Vorgang kannst Du mit Hilfe des Befehls `git submodule add` ausführen:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

<!--Now you have the Rack project under a subdirectory named `rack` within your project. You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more. If you run `git status` right after you add the submodule, you see two things:-->

Innerhalb Deines Projekts befindet sich nun im Unterverzeichnis `rack` das komplette Rack-Projekt. Man kann jetzt in diesem Verzeichnis Änderungen vornehmen und ein eigenes Remote-Repository mit Schreibrechten, zu welchem man pushen kann, hinzufügen. Ebenso ist es möglich, Änderungen von den Rack-Entwicklern in sein Repository zu laden und diese mit den eigenen Ergebnissen zu mergen. Im Prinzip kann man innerhalb eines Submoduls die gleichen Vorgänge, wie in einem normalen Repository ausführen. Vorher müssen wir aber noch ein paar weitere Dinge zu Submodulen besprechen. Wenn Du gleich nach dem Hinzufügen des Submoduls, den Befehl `git status` ausführst, wirst Du gleich zwei Dinge bemerken:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

<!--First you notice the `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:-->

Als erstes wird Dir die neue Datei `.gitmodules` auffallen. Das ist eine Konfigurationsdatei, welche die Zuordnung der URL des geklonten Projekts und dem lokalen Unterverzeichnis, in welches das Projekt geklont wurde, festlegt:

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

<!--If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file. It’s pushed and pulled with the rest of your project. This is how other people who clone this project know where to get the submodule projects from.-->

Wenn Du mehrere Submodule in einem Projekt verwaltest, werden auch mehrere Einträge in dieser Datei auftauchen. Dabei ist es wichtig zu wissen, dass diese Datei zusammen mit all den anderen Dateien aus Deinem Projekt, ebenso in die Versionskontrolle aufgenommen wird, ähnlich wie die Datei `.gitignore`. Die Datei wird so wie der Rest Deines Projekts gepusht und gepullt. Dadurch wissen andere Personen, die Dein Projekt klonen, von welchem Ort sie die Submodule erhalten können.

<!--The other listing in the `git status` output is the rack entry. If you run `git diff` on that, you see something interesting:-->

Die zweite Auffälligkeit bei der Ausgabe von `git status` ist der Eintrag rack. Wenn Du auf diesen Eintrag ein `git diff` durchführst, erhält man in etwa die folgende, interessante Ausgabe:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

<!--Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory. Instead, Git records it as a particular commit from that repository. When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly.-->

Obwohl `rack` ein Unterverzeichnis in Deinem Arbeitsverzeichnis ist, erkennt Git dieses Verzeichnis als Submodul und verfolgt die Änderungen innerhalb dieses Verzeichnisses nicht, wenn Git nicht innerhalb dieses Verzeichnisses aufgerufen wird. Stattdessen erfasst Git, welcher Commit in diesem Repository ausgecheckt ist. Wenn Du also Änderungen in diesem Unterverzeichnis durchführst und eincheckst, kann das Superprojekt erkennen, dass sich der aktuelle HEAD von diesem Projekt geändert hat. Das Superprojekt kann sich jetzt diesen Commit merken. Auf diese Art und Weise ist es möglich, den kompletten Zustand des Projekts mit allen Projekten, die als Submodul hinzugefügt wurden, zu reproduzieren. In der Git-Terminologie wird das Projekt, welches eines oder mehrere Submodule enthält, als Superprojekt bezeichnet.

<!--This is an important point with submodules: you record them as the exact commit they’re at. You can’t record a submodule at `master` or some other symbolic reference.-->

Dabei muss man sich folgender Eigenschaft bewusst sein: Git verwaltet den exakten Commit, der gerade ausgecheckt ist und nicht etwa den Branch oder eine andere Referenz. Git kann also zum Beispiel nicht speichern, dass der aktuelle Stand im Branch `master` enthalten ist.

<!--When you commit, you see something like this:-->

Wenn Du Dein Projekt das erste Mal eincheckst, erhältst Du in etwa folgende Ausgabe:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

<!--Notice the 160000 mode for the rack entry. That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file.-->

Der Mode 160000, der für den rack-Eintrag gilt, ist ein spezieller Mode in Git. Er bedeutet in etwa, dass man einen Commit als Verzeichnis-Eintrag in Git verwaltet und damit nicht wie normalerweise ein Verzeichnis oder eine Datei.

<!--You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject. All the Git commands work independently in the two directories:-->

Das Verzeichnis `rack` kann man wie ein separates Projekt behandeln und verwenden. Und von Zeit zur Zeit aktualisiert man auch das Superprojekt und speichert damit die letzte Commit-ID des Unterprojekts. Jedes Git-Kommando arbeitet unabhängig in einem der beiden Unterverzeichnisse:

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

<!--### Cloning a Project with Submodules ###-->
### Klonen eines Projekts mit den dazugehörigen Submodulen ###

<!--Here you’ll clone a project with a submodule in it. When you receive such a project, you get the directories that contain submodules, but none of the files yet:-->

Als nächstes klonen wir ein Projekt, welches ein Submodul verwendet. Wenn man ein solches Projekt klont, werden die entsprechenden Verzeichnisse, welche ein Submodul enthalten, erstellt. Allerdings enthalten diese Verzeichnisse noch keinen Inhalt:

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

<!--The `rack` directory is there, but empty. You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject:-->

Das Verzeichnis `rack` wurde zwar erzeugt, aber es ist leer. Deshalb musst Du zwei Dinge ausführen: `git submodule init`, damit wird die Datei für die lokale Konfiguration initialisiert. Und `git submodule update`, welches die gesamten Daten des Projekts von der im `.gitmodules` angegebenen Quelle holt und den entsprechenden Commit, welcher im Superprojekt hinterlegt ist, auscheckt:

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

<!--Now your `rack` subdirectory is at the exact state it was in when you committed earlier. If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd:-->

Nach Ausführung der beiden Befehle befindet sich das Verzeichnis `rack` in genau dem gleichen Zustand, wie wir es ursprünglich eingecheckt haben. Wenn ein anderer Entwickler Änderungen am Rack-Code durchführt, diese eincheckt und Du diese dann pullst und mergst, erhält man einen etwas seltsamen Zustand:

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

<!--You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory:-->

Der Merge, der gerade durchgeführt worden ist, ist eigentlich nur eine Aktualisierung des Zeigers auf einen neuen Commit des Submoduls. Der eigentliche Inhalt des Submodul-Verzeichnis wurde allerdings nicht aktualisiert. Das sieht dann so aus, als gäbe es noch nicht eingecheckte Dateien innerhalb Deines Arbeitsverzeichnis:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

<!--This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory. To fix this, you must run `git submodule update` again:-->

Dieser Zustand tritt auf, weil der Zeiger auf den Commit im Submodul derzeit nicht der Commit ist, welcher im Submodul ausgecheckt ist. Um dies zu beheben, muss man den Befehl `git submodule update` erneut ausführen:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

<!--You have to do this every time you pull down a submodule change in the main project. It’s strange, but it works.-->

Dieser Update muss jedes Mal ausgeführt werden, wenn man das Superprojekt pullt und dort ein Änderung in einem Submodul enthalten ist. Es ist vielleicht ein wenig merkwürdig, aber es funktioniert.

<!--One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server. Then, they commit a pointer to that non-public state and push up the superproject. When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system. If that happens, you see an error like this:-->

Häufig tritt beim Arbeiten mit Submodulen ein Problem bei folgendem Szenario auf: Ein Entwickler führt Änderungen in einem Submodul durch, checkt diese ein, vergisst aber diese Änderungen zum zentralen Server zu pushen. Wenn dann im Superprojekt die Änderung des Submoduls ebenso eingecheckt wird und dieses dann gepusht wird, tritt ein Problem auf. Wenn jetzt andere Entwickler den neuen Stand des Superprojekts holen und den Befehl `git submodule update` ausführen, erhalten sie eine Fehlermeldung, dass der entsprechend referenzierte Commit von dem Submodul nicht gefunden werden konnte. Das passiert weil dieser Commit bei dem zweiten Entwickler noch gar nicht existiert. Wenn ein solcher Fall auftritt, erhält man in etwa folgende Fehlermeldung:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

<!--You have to see who last changed the submodule:-->

Dann kann man allerdings herausfinden, wer zum letzten Mal eine Änderung eingecheckt hat:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

<!--Then, you e-mail that guy and yell at him.-->

Dann kannst Du diesem Entwickler eine E-Mail schreiben und ihn auf seinen Fehler aufmerksam machen.

<!--### Superprojects ###-->
### Superprojekte ###

<!--Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on. This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow.-->

In manchen großen Projekten möchten die Entwickler die Arbeit in verschiedenen Verzeichnissen aufteilen, sodass das jeweilige Team in diesen Verzeichnissen arbeiten kann. Man trifft diese Vorgehensweise häufig an, wenn ein Team gerade von CVS oder Subversion nach Git gewechselt hat, im alten System ein Modul oder eine Sammlung von solchen Unterverzeichnissen gebildet hat und diesen Arbeitsablauf weiterhin verwenden möchte.

<!--A good way to do this in Git is to make each of the subdirectories a separate Git repository and then create superproject Git repositories that contain multiple submodules. A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects.-->

In Git kann man diese Vorgehensweise gut abbilden, indem man für jedes Unterverzeichnis ein neues Git-Repository erzeugt. Zusätzlich kann man dann ein Superprojekt erzeugen und die ganzen Git-Repositorys als Submodul hinzufügen. Ein Vorteil dabei ist, dass man mit Hilfe von Tags und Branches im Superprojekt das Verhältnis der einzelnen Submodule zueinander festhalten kann.

<!--### Issues with Submodules ###-->
### Häufige Probleme mit Submodulen ###

<!--Using submodules isn’t without hiccups, however. First, you must be relatively careful when working in the submodule directory. When you run `git submodule update`, it checks out the specific version of the project, but not within a branch. This is called having a detached HEAD — it means the HEAD file points directly to a commit, not to a symbolic reference. The issue is that you generally don’t want to work in a detached HEAD environment, because it’s easy to lose changes. If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.  Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieve.-->

Die Arbeit mit Submodulen verläuft jedoch nicht immer reibungslos. Man muss verhältnismäßig gut aufpassen, wenn man in einem Submodul-Verzeichnis arbeitet. Wenn man nämlich den Befehl `git submodule update` ausführt, checkt Git den entsprechenden Zustand des Commits aus, aber checkt dabei keinen Branch aus. Diesen Zustand nennt man auch `detached HEAD`. Das bedeutet, dass die Datei HEAD direkt auf einen Commit zeigt und nicht, wie sonst üblich, auf eine symbolische Referenz, also zum Beispiel auf einen Branch. Das Problem dabei ist, dass man normalerweise in einem solchen Zustand nicht weiterarbeiten möchte, weil es sehr leicht vorkommen kann, dass Änderungen verloren gehen. Wenn man also den Befehl `git submodule update` aufruft, dann einen Commit in dem entsprechenden Submodul-Verzeichnis ausführt, ohne davor einen Branch auszuchecken, und dann noch einmal `git submodule update` im Superprojekt aufruft, ohne dass man die Änderungen im Submodul im Superprojekt eingecheckt hat, verliert man die ganzen Änderungen, ohne dass Git einen darauf vorher hinweist. Tatsächlich ist es so, dass die Änderungen nicht verloren gehen, aber es gibt keinen Branch, der auf die entsprechenden Commits hinzeigt, und damit kann es schwierig werden, die entsprechenden Commits wiederherzustellen beziehungsweise sichtbar zu machen.

<!--To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent. When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to.-->

Um dieses Problem zu vermeiden, sollte man also immer in dem Submodul-Verzeichnis einen neuen Branch mit `git checkout -b work` oder auf eine andere Art und Weise erzeugen. Wenn man dann wieder das Aktualisieren des Submoduls ausführt, wird Git wieder den ursprünglichen Commit auschecken, allerdings hat man jetzt mit dem Branch einen Zeiger auf die neuen Commits und man kann sie leicht wieder auschecken.

<!--Switching branches with submodules in them can also be tricky. If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory:-->

Wenn ein Projekt ein Submodul enthält und man im Superprojekt zwischen einzelnen Branches hin und her wechseln möchte, kann sich das manchmal auch schwierig gestalten. Wenn man zum Beispiel einen neuen Branch erzeugt, in diesem dann ein Submodul hinzufügt und dann wieder in den ursprünglichen Branch, welcher das Submodul noch nicht enthält, zurückwechselt, hat man im Arbeitsverzeichnis immer noch das Submodul-Verzeichnis, welches auch so dargestellt wird, als ob es von Git noch nicht verfolgt wird:

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

<!--You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up.-->

In diesem Fall muss man das Verzeichnis entweder an einen anderen Ort verschieben oder löschen. Im letzteren Fall muss man aber wieder das Submodul komplett klonen, wenn man in den anderen Zweig zurückwechselt. Außerdem kann man dabei lokale Änderungen zunichte machen oder Zweige, welche man noch nicht gepusht hat, verlieren.

<!--The last main caveat that many people run into involves switching from subdirectories to submodules. If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you. Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule. If you delete the subdirectory and then run `submodule add`, Git yells at you:-->

Die letzte Falle, in die viele Leute tappen, tritt auf, wenn man bereits vorhandene Verzeichnisse in Submodule umwandeln will. Wenn man also Dateien, die bereits von Git verwaltet werden, entfernen und in ein entsprechendes Submodul verschieben möchte, muss man vorsichtig sein. Ansonsten können schwer zu behebende Probleme mit Git auftreten. Nehmen wir zum Beispiel an, dass Du die Dateien vom Rack-Projekt in ein Unterverzeichnis Deines Projekts abgelegt hast und diese jetzt aber in ein Submodul verschieben möchtest. Wenn Du das Unterverzeichnis einfach löschst und dann den Befehl `submodule add` ausführst, zeigt Dir Git folgende Fehlermeldung an:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

<!--You have to unstage the `rack` directory first. Then you can add the submodule:-->

Man muss dann das Verzeichnis `rack` erst aus der Staging-Area entfernen. Danach kann man dann das Submodul erzeugen:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

<!--Now suppose you did that in a branch. If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error:-->

Wenn wir jetzt annehmen, dass Du diesen Vorgang innerhalb eines Zweigs durchgeführt hast und jetzt auf einen anderen Zweig, in dem das Submodul noch nicht existiert hat und damit die Dateien noch ganz normal im Repository enthalten waren, wechselst, erhält Du folgenden Fehler:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

<!--You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it:-->

Dann musst Du das Submodul-Verzeichnis `rack` an einen anderen Ort verschieben, bevor Du diesen Branch auschecken kannst:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

<!--Then, when you switch back, you get an empty `rack` directory. You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory.-->

Wenn man dann wieder in den Zweig mit dem Submodul zurückwechseln will, erhält man ein leeres Verzeichnis `rack`. Um dieses zu befüllen, kannst Du entweder `git submodule update` ausführen oder Du kannst Deine Kopie von `/tmp/rack` wieder an den ursprünglichen Ort wiederherstellen.

<!--## Subtree Merging ##-->
## Subtree Merging ##

<!--Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a _recursive_ strategy. If you’re merging more than two branches, Git picks the _octopus_ strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.-->

Nachdem wir neben den Vor- und Nachteilen beim Arbeiten mit Submodulen kennengelernt haben, möchte ich jetzt noch eine alternative Lösung zeigen, wie man ähnliche Probleme lösen kann. Wenn Git etwas zusammenführt, also mergt, analysiert es die Teile, die es mergen muss. Auf Basis dieser Analyse entscheidet Git sich für eine geeignete Merging-Methode. Wenn man zwei Branches mergt, dann verwendet Git automatisch die sogenannte Recursive-Strategie. Wenn man mehr als zwei Branches mergt, verwendet Git die sogenannte Octopus-Strategie. Diese Strategien werden automatisch für Dich gewählt, weil die Recursive-Strategie normalerweise sehr gut geeignet ist, um einen Drei-Wege-Merge (engl. three-way merge) durchzuführen — zum Beispiel, wenn es mehr als einen gemeinsamen Vorgänger-Commit gibt — aber der Drei-Wege-Merge ist nur für das Mergen von zwei Branches geeignet. Die Octopus-Merge-Strategie kann mehrere Branches zusammenführen, aber es wird dabei vorsichtiger vorgegangen, um schwierig aufzulösende Konflikte zu vermeiden. Aus diesem Grund wird diese Strategie standardmäßig verwendet, wenn man mehr als zwei Branches zusammenführen möchte.

<!--However, there are other strategies you can choose as well. One of them is the _subtree_ merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.-->

Es gibt jedoch noch weitere Strategien, die man verwenden kann. Einer dieser Strategien ist der sogenannte Subtree-Merge. Dies kann verwendet werden, um unser Problem mit Unterprojekten zu lösen. Ich möchte Dir im Folgenden aufzeigen, wie man das Rack-Projekt aus dem letzten Kapitel einbindet und dabei den Subtree-Merge anstatt der Submodule verwendet.

<!--The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.-->

Das Prinzip, das hinter einem Subtree-Merge steckt, ist, dass man zwei Projekte hat und eines der Projekte wird in ein Unterverzeichnis des anderen Projekts abgebildet. Wenn man ein Subtree-Merge ausführt, ist Git schlau genug, um zu erkennen, dass ein Projekt ein Abbild von einem anderen Projekt ist und es kann den Merge in geeigneter Weise durchführen — das ist wirklich sehr erstaunlich.

<!--You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch:-->

Als erstes musst Du dazu die Rack-Applikation zu Deinem Projekt hinzufügen. Dazu fügst Du das Rack-Projekt als neues Remote-Repository in Deinem Projekt hinzu und checkst dieses in einem separaten Branch aus:

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

<!--Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch. If you check out one and then the other, you can see that they have different project roots:-->

Nach der Ausführung der drei Befehle befindet sich das Rack-Projekt in Deinem Branch `rack_branch` und Dein eigenes Projekt liegt weiterhin im Branch `master`. Wenn man jetzt den jeweiligen Zweig auscheckt, sieht man die unterschiedlichen Inhalte im Wurzelverzeichnis:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

<!--You want to pull the Rack project into your `master` project as a subdirectory. You can do that in Git with `git read-tree`. You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project:-->

Jetzt möchten wir das Rack-Projekt in Deinen Branch `master` als Unterverzeichnis hinzufügen. Dies kann man in Git mit dem Befehl `git read-tree` durchführen. In Kapitel 9 werde ich den Befehl `read-tree` und dessen verwandte Befehle näher erläutern. Hier möchte ich nur erklären, dass der Befehl das Wurzelverzeichnis eines Branches in die aktuelle Staging-Area und in das Arbeitsverzeichnis packt. Damit hast Du jetzt zu Deinem Branch `master` zurückgewechselt, den Inhalt des Branches `rack_branch` in das Unterverzeichnis `rack` im Branch `master` Deines Projekts hinterlegt:

	$ git read-tree --prefix=rack/ -u rack_branch

<!--When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:-->

Wenn Du jetzt einen Commit ausführst, erscheint es einem so, als ob die ganzen Dateien aus dem Rack-Projekt in diesem Unterverzeichnis liegen — als ob man das Projekt aus einem Tarball-Container hineinkopiert hätte. Das Besondere ist jetzt aber, dass man Änderungen zwischen den verschiedenen Branches jetzt einfach zusammenführen kann. Das bedeutet, wenn das Rack-Projekt aktualisiert wird, kann man sich diese Änderungen einfach holen, indem man in diesen Branch wechselt und dort einen Pull durchführt:

	$ git checkout rack_branch
	$ git pull

<!--Then, you can merge those changes back into your master branch. You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the `-\-squash` and `-\-no-commit` options as well as the `-s subtree` strategy option:-->

Danach kann man diese Änderungen wieder in den Branch master mergen. Wenn man den Befehl `git merge -s subtree` verwendet, sollte dies einwandfrei funktionieren. Allerdings wird Git bei Ausführen dieses Befehls auch die jeweilige Historie mergen, was Du wahrscheinlich nicht haben möchtest. Um nun die Änderungen zu holen und eine entsprechende Commit-Nachricht vorzubereiten, hängt man einfach `--squash`, `--no-commit` und natürlich `-s subtree` als Option an:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

<!--All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream.-->

Die ganzen Änderungen des Rack-Projekts wurden nun zusammengeführt, Du musst jetzt nur noch einen entsprechenden Commit durchführen. Man kann aber auch genau das Gegenteil machen: Man führt Änderungen im Unterverzeichnis `rack` des Branches master aus und mergt diese dann später in den Zweig `rack_branch`. Diesen kann man dann den Entwicklern des Rack-Projekts zur Verfügung stellen.

<!--To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command. Instead, you must run `git diff-tree` with the branch you want to compare to:-->

Um die Unterschiede zwischen dem Inhalt in Deinem Verzeichnis `rack` und dem Code im Zweig `rack_branch` anzuzeigen, kann man keinen normalen Vergleich mit `diff` durchführen. Man muss stattdessen den Befehl `git diff-tree` verwenden und als Argument den zu vergleichenden Branch angeben:

	$ git diff-tree -p rack_branch

<!--Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run-->

Um Dein Verzeichnis `rack` mit dem letzten Stand des Branches `master` auf dem Server zu vergleichen, kannst Du folgenden Befehl verwenden:

	$ git diff-tree -p rack_remote/master

<!--## Summary ##-->
## Zusammenfassung ##

<!--You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely. When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom. If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs. At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so.-->

In diesem Kapitel hast Du viele ausgeklügelte Werkzeuge kennengelernt, die es Dir ermöglichen, Commits und die Staging-Area nach Deinen Vorstellungen zu beeinflussen. Wenn ein Problem in Deinem Projekt auftaucht, solltest Du jetzt leicht bestimmen können, welcher Commit den Fehler verursacht hat, sowie wann und von wem der Fehler begangen wurde. Wenn Du andere Projekte in Deinem Projekt verwenden möchtest, hast Du jetzt mehrere Möglichkeiten kennengelernt, wie Du dies handhaben kannst. An dieser Stelle solltest Du jetzt in der Lage sein, die meisten Dinge, die Du bei der täglichen Arbeit benötigst, in der Kommandozeile durchzuführen, ohne dass Dir dabei Schweißperlen auf der Stirn stehen.
