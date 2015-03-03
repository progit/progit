<!--# Git Branching #-->
# Git Branching #

<!--Nearly every VCS has some form of branching support. Branching means you diverge from the main line of development and continue to do work without messing with that main line. In many VCS tools, this is a somewhat expensive process, often requiring you to create a new copy of your source code directory, which can take a long time for large projects.-->

Nahezu jedes VCS unterstützt eine Form von Branching. Branching bedeutet, dass Du von der Hauptentwicklungslinie abzweigst und unabhängig vom Hauptzweig weiterarbeitest. Bei vielen VCS ist das ein ziemlch aufwendiger Prozess, welcher häufig erfordert, eine Kopie des kompletten Arbeitsverzeichnisses zu erstellen, was bei großen Projekten eine ganze Weile dauern kann.

<!--Some people refer to the branching model in Git as its “killer feature”  , and it certainly sets Git apart in the VCS community. Why is it so special? The way Git branches is incredibly lightweight, making branching operations nearly instantaneous and switching back and forth between branches generally just as fast. Unlike many other VCSs, Git encourages a workflow that branches and merges often, even multiple times in a day. Understanding and mastering this feature gives you a powerful and unique tool and can literally change the way that you develop.-->

Manche Leute bezeichnen Gits Branching-Modell als dessen „Killer-Feature“, was Git zweifellos von dem Rest der VCS-Community abhebt. Was ist das Besondere daran? Die Art und Weise, wie Git Branches behandelt, ist unglaublich leichtgewichtig, wodurch Branch-Operationen nahezu verzögerungsfrei ausgeführt werden und auch das Hin- und Herschalten zwischen einzelnen Entwicklungszweigen im allgemeinen genauso schnell abläuft. Im Gegensatz zu anderen VCS ermutigt Git zu einer Arbeitsweise mit häufigem Branching und Merging – oft mehrmals am Tag. Wenn Du diese Funktion vertstehst und beherrschst, besitzt Du ein mächtiges und einmaliges Werkzeug, welches Deine Art zu entwickeln buchstäblich verändern.

<!--## What a Branch Is ##-->
## Was ist ein Branch? ##

<!--To really understand the way Git does branching, we need to take a step back and examine how Git stores its data. As you may remember from Chapter 1, Git doesn’t store data as a series of changesets or deltas, but instead as a series of snapshots.-->

Um wirklich zu verstehen, wie Git Branching durchführt, müssen wir einen Schritt zurück gehen und untersuchen, wie Git die Daten speichert. Wie Du Dich vielleicht noch an Kapitel 1 erinnerst, speichert Git seine Daten nicht als Serie von Änderungen oder Unterschieden, sondern als Serie von Schnappschüssen.

<!--When you commit in Git, Git stores a commit object that contains a pointer to the snapshot of the content you staged, the author and message metadata, and zero or more pointers to the commit or commits that were the direct parents of this commit: zero parents for the first commit, one parent for a normal commit, and multiple parents for a commit that results from a merge of two or more branches.-->

Wenn Du in Git committest, speichert Git ein sogenanntes Commit-Objekt. Dieses enthält einen Zeiger zu dem Schnappschuss mit den Objekten der Staging-Area, dem Autor, den Commit-Metadaten und einem Zeiger zu den direkten Eltern des Commits. Ein initialer Commit hat keine Eltern-Commits, ein normaler Commit stammt von einem Eltern-Commit ab und ein Merge-Commit, welcher aus einer Zusammenführung von zwei oder mehr Branches resultiert, besitzt ebenso viele Eltern-Commits.

<!--To visualize this, let’s assume that you have a directory containing three files, and you stage them all and commit. Staging the files checksums each one (the SHA-1 hash we mentioned in Chapter 1), stores that version of the file in the Git repository (Git refers to them as blobs), and adds that checksum to the staging area:-->

Um das zu verdeutlichen, lass uns annehmen, Du hast ein Verzeichnis mit drei Dateien, die Du alle zu der Staging-Area hinzufügst und in einem Commit verpackst. Durch das Stagen der Dateien erzeugt Git für jede Datei eine Prüfsumme (der SHA-1 Hash, den wir in Kapitel 1 erwähnt haben), speichert diese Version der Datei im Git-Repository (Git referenziert auf diese als Blobs) und fügt die Prüfsumme der Staging-Area hinzu:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

<!--Running `git commit` checksums all project directories and stores them as `tree` objects in the Git repository. Git then creates a `commit` object that has the metadata and a pointer to the root project `tree` object so it can re-create that snapshot when needed.-->

Wenn Du einen Commit mit der Anweisung `git commit` erstellst, erzeugt Git für jedes Projektverzeichnis eine Prüfsumme und speichert diese als sogenanntes `tree`-Objekt im Git Repository. Git erzeugt dann ein Commit Objekt, das die Metadaten und den Zeiger zum `tree`-Objekt des Wurzelverzeichnis enthält, um bei Bedarf den Snapshot erneut erzeugen zu können.

<!--Your Git repository now contains five objects: one blob for the contents of each of your three files, one tree that lists the contents of the directory and specifies which file names are stored as which blobs, and one commit with the pointer to that root tree and all the commit metadata. Conceptually, the data in your Git repository looks something like Figure 3-1.-->

Dein Git-Repository enthält nun fünf Objekte: einen Blob für den Inhalt von jeder der drei Dateien, einen Baum, der den Inhalt des Verzeichnisses auflistet und spezifiziert, welcher Dateiname zu welchem Blob gehört, sowie einen Zeiger, der auf die Wurzel des Projektbaumes und die Metadaten des Commits verweist. Prinzipiell sehen Deine Daten im Git Repository wie in Abbildung 3-1 aus.

<!--Figure 3-1. Single commit repository data.-->

Insert 18333fig0301.png
Abbildung 3-1. Repository-Daten eines einzelnen Commits.

<!--If you make some changes and commit again, the next commit stores a pointer to the commit that came immediately before it. After two more commits, your history might look something like Figure 3-2.-->

Wenn Du erneut etwas änderst und wieder einen Commit machst, wird dieser einen Zeiger enthalten, der auf den Vorhergehenden verweist. Nach zwei weiteren Commits könnte die Historie wie in Abbildung 3-2 aussehen.

<!--Figure 3-2. Git object data for multiple commits.-->

Insert 18333fig0302.png
Abbildung 3-2. Git Objektdaten für mehrere Commits.

<!--A branch in Git is simply a lightweight movable pointer to one of these commits. The default branch name in Git is master. As you initially make commits, you’re given a `master` branch that points to the last commit you made. Every time you commit, it moves forward automatically.-->

Ein Branch in Git ist nichts anderes als ein simpler Zeiger auf einen dieser Commits. Der Standardname eines Git-Branches lautet `master`. Mit dem initialen Commit erhältst Du einen `master`-Branch, der auf Deinen letzten Commit zeigt. Mit jedem Commit bewegt er sich automatisch vorwärts.

<!--Figure 3-3. Branch pointing into the commit data’s history.-->

Insert 18333fig0303.png
Abbildung 3-3. Branch, der auf einen Commit in der Historie zeigt.

<!--What happens if you create a new branch? Well, doing so creates a new pointer for you to move around. Let’s say you create a new branch called testing. You do this with the `git branch` command:-->

Was passiert, wenn Du einen neuen Branch erstellst? Nun, zunächst wird ein neuer Zeiger erstellt. Sagen wir, Du erstellst einen neuen Branch mit dem Namen `testing`. Das machst Du mit der Anweisung `git branch`:

	$ git branch testing

<!--This creates a new pointer at the same commit you’re currently on (see Figure 3-4).-->

Dies erzeugt einen neuen Zeiger, der auf den gleichen Commit zeigt, auf dem Du gerade arbeitest (siehe Abbildung 3-4).

<!--Figure 3-4. Multiple branches pointing into the commit’s data history.-->

Insert 18333fig0304.png
Abbildung 3-4. Mehrere Branches zeigen in den Commit-Verlauf

<!--How does Git know what branch you’re currently on? It keeps a special pointer called HEAD. Note that this is a lot different than the concept of HEAD in other VCSs you may be used to, such as Subversion or CVS. In Git, this is a pointer to the local branch you’re currently on. In this case, you’re still on master. The git branch command only created a new branch — it didn’t switch to that branch (see Figure 3-5).-->

Woher weiß Git, welchen Branch Du momentan verwendest? Dafür gibt es einen speziellen Zeiger mit dem Namen HEAD. Berücksichtige, dass dieses Konzept sich grundsätzlich von anderen HEAD-Konzepten anderer VCS, wie Subversion oder CVS, unterscheidet. Bei Git handelt es sich bei HEAD um einen Zeiger, der auf Deinen aktuellen lokalen Branch zeigt. In dem Fall bist Du aber immer noch auf dem `master`-Branch. Die Anweisung `git branch` hat nur einen neuen Branch erstellt, aber nicht zu diesem gewechselt (siehe Abbildung 3-5).

<!--Figure 3-5. HEAD file pointing to the branch you’re on.-->

Insert 18333fig0305.png
Abbildung 3-5. Der HEAD-Zeiger verweist auf Deinen aktuellen Branch.

<!--To switch to an existing branch, you run the `git checkout` command. Let’s switch to the new testing branch:-->

Um zu einem anderen Branch zu wechseln, benutze die Anweisung `git checkout`. Lass uns nun zu unserem neuen Branch `testing` wechseln:

	$ git checkout testing

<!--This moves HEAD to point to the testing branch (see Figure 3-6).-->

Das lässt HEAD neuerdings auf den Branch „testing“ verweisen (siehe Abbildung 3-6).

<!--Figure 3-6. HEAD points to another branch when you switch branches.-->

Insert 18333fig0306.png
Abbildung 3-6. Wenn Du den Branch wechselst, zeigt HEAD auf einen neuen Zweig.

<!--What is the significance of that? Well, let’s do another commit:-->

Und was bedeutet das? Ok, lass uns noch einen weiteren Commit machen:

	$ vim test.rb
	$ git commit -a -m 'made a change'

<!--Figure 3-7 illustrates the result.-->

Abbildung 3-7 verdeutlicht das Ergebnis.

<!--Figure 3-7. The branch that HEAD points to moves forward with each commit.-->

Insert 18333fig0307.png
Abbildung 3-7. Der HEAD-Zeiger schreitet mit jedem weiteren Commit voran.

<!--This is interesting, because now your testing branch has moved forward, but your `master` branch still points to the commit you were on when you ran `git checkout` to switch branches. Let’s switch back to the `master` branch:-->

Das ist interessant, denn Dein Branch `testing` hat sich jetzt voranbewegt, während Dein `master`-Branch immer noch auf den Commit zeigt, welchen Du bearbeitet hast, bevor Du mit `git checkout` den aktuellen Zweig gewechselt hast. Lass uns zurück zu dem `master`-Branch wechseln:

	$ git checkout master

<!--Figure 3-8 shows the result.-->

Abbildung 3-8 zeigt das Ergebnis.

<!--Figure 3-8. HEAD moves to another branch on a checkout.-->

Insert 18333fig0308.png
Abbildung 3-8. HEAD zeigt nach einem Checkout auf einen anderen Branch.

<!--That command did two things. It moved the HEAD pointer back to point to the `master` branch, and it reverted the files in your working directory back to the snapshot that `master` points to. This also means the changes you make from this point forward will diverge from an older version of the project. It essentially rewinds the work you’ve done in your testing branch temporarily so you can go in a different direction.-->

Diese Anweisung hat zwei Dinge veranlasst. Zum einen bewegt es den HEAD-Zeiger zurück zum `master`-Branch, zum anderen setzt es alle Dateien im Arbeitsverzeichnis auf den Bearbeitungsstand des letzten Commits in diesem Zweig zurück. Das bedeutet aber auch, dass nun alle Änderungen am Projekt vollkommen unabhängig von älteren Projektversionen erfolgen. Kurz gesagt, werden alle Änderungen aus dem `testing`-Zweig vorübergehend rückgängig gemacht und Du hast die Möglichkeit, einen vollkommen neuen Weg in der Entwicklung einzuschlagen.

<!--Let’s make a few changes and commit again:-->

Lass uns ein paar Änderungen machen und mit einem Commit festhalten:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

<!--Now your project history has diverged (see Figure 3-9). You created and switched to a branch, did some work on it, and then switched back to your main branch and did other work. Both of those changes are isolated in separate branches: you can switch back and forth between the branches and merge them together when you’re ready. And you did all that with simple `branch` and `checkout` commands.-->

Nun verzweigen sich die Projektverläufe (siehe Abbildung 3-9). Du hast einen Branch erstellt und zu ihm gewechselt, hast ein bisschen gearbeitet, bist zu Deinem Haupt-Zweig zurückgekehrt und hast da was ganz anderes gemacht. Beide Arbeiten existieren vollständig unabhängig voneinander in zwei unterschiedlichen Branches. Du kannst beliebig zwischen den beiden Zweigen wechseln und sie zusammenführen, wenn Du meinst, es wäre soweit. Und das alles hast Du mit simplen `branch` und `checkout`-Anweisungen vollbracht.

<!--Figure 3-9. The branch histories have diverged.-->

Insert 18333fig0309.png
Abbildung 3-9. Die Historie läuft auseinander.

<!--Because a branch in Git is in actuality a simple file that contains the 40 character SHA-1 checksum of the commit it points to, branches are cheap to create and destroy. Creating a new branch is as quick and simple as writing 41 bytes to a file (40 characters and a newline).-->

Branches können in Git spielend erstellt und entfernt werden, da sie nur kleine Dateien sind, die eine 40 Zeichen lange SHA-1 Prüfsumme der Commits enthalten, auf die sie verweisen. Einen neuen Zweig zu erstellen, erzeugt ebenso viel Aufwand wie das Schreiben einer 41 Byte großen Datei (40 Zeichen und einen Zeilenumbruch).

<!--This is in sharp contrast to the way most VCS tools branch, which involves copying all of the project’s files into a second directory. This can take several seconds or even minutes, depending on the size of the project, whereas in Git the process is always instantaneous. Also, because we’re recording the parents when we commit, finding a proper merge base for merging is automatically done for us and is generally very easy to do. These features help encourage developers to create and use branches often.-->

Das steht im krassen Gegensatz zu dem Weg, den die meisten andere VCS Tools beim Thema Branching einschlagen. Diese kopieren oftmals jeden neuen Entwicklungszweig in ein weiteres Verzeichnis, was – je nach Projektgröße – mehrere Minuten in Anspruch nehmen kann, wohingegen Git diese Aufgabe sofort erledigt. Da wir außerdem immer den Ursprungs-Commit festhalten, lässt sich problemlos eine gemeinsame Basis für eine Zusammenführung finden und umsetzen. Diese Eigenschaft soll Entwickler ermutigen Entwicklungszweige häufig zu erstellen und zu nutzen.

<!--Let’s see why you should do so.-->

Lass uns mal sehen, warum Du das machen solltest.

<!--## Basic Branching and Merging ##-->
## Einfaches Branching und Merging ##

<!--Let’s go through a simple example of branching and merging with a workflow that you might use in the real world. You’ll follow these steps:-->

Lass uns das Ganze an einem Beispiel durchgehen, dessen Workflow zum Thema Branching und Zusammenführen Du im echten Leben verwenden kannst. Folge einfach diesen Schritten:

<!--1. Do work on a web site.-->
<!--2. Create a branch for a new story you’re working on.-->
<!--3. Do some work in that branch.-->

1. Arbeite an einer Webseite.
2. Erstelle einen Branch für irgendeine neue Geschichte, an der Du arbeitest.
3. Arbeite in dem Branch.

<!--At this stage, you’ll receive a call that another issue is critical and you need a hotfix. You’ll do the following:-->

In diesem Augenblick kommt ein Anruf, dass ein kritisches Problem aufgetreten ist und sofort gelöst werden muss. Du machst folgendes:

<!--1. Switch back to your production branch.-->
<!--2. Create a branch to add the hotfix.-->
<!--3. After it’s tested, merge the hotfix branch, and push to production.-->
<!--4. Switch back to your original story and continue working.-->

1. Schalte zurück zu Deinem „Produktiv“-Zweig.
2. Erstelle einen Branch für den Hotfix.
3. Nach dem Testen führst Du den Hotfix-Branch mit dem „Produktiv“-Branch zusammen.
4. Schalte wieder auf Deine alte Arbeit zurück und werkel weiter.

<!--### Basic Branching ###-->
### Branching Grundlagen ###

<!--First, let’s say you’re working on your project and have a couple of commits already (see Figure 3-10).-->

Sagen wir, Du arbeitest an Deinem Projekt und hast bereits einige Commits durchgeführt (siehe Abbildung 3-10).

<!--Figure 3-10. A short and simple commit history.-->

Insert 18333fig0310.png
Abbildung 3-10. Eine kurze, einfache Commit-Historie

<!--You’ve decided that you’re going to work on issue #53 in whatever issue-tracking system your company uses. To be clear, Git isn’t tied into any particular issue-tracking system; but because issue #53 is a focused topic that you want to work on, you’ll create a new branch in which to work. To create a branch and switch to it at the same time, you can run the `git checkout` command with the `-b` switch:-->

Du hast Dich dafür entschieden, am Issue #53 des Issue-Trackers XY zu arbeiten. Um eines klarzustellen, Git ist an kein Issue-Tracking-System gebunden. Da der Issue #53 allerdings ein Schwerpunktthema betrifft, wirst Du einen neuen Branch erstellen, um daran zu arbeiten. Um in einem Arbeitsschritt einen neuen Branch zu erstellen und zu aktivieren, kannst Du die Anweisung `git checkout` mit der Option `-b` verwenden:

	$ git checkout -b iss53
	Switched to a new branch 'iss53'

<!--This is shorthand for:-->

Das ist die Kurzform von

	$ git branch iss53
	$ git checkout iss53

<!--Figure 3-11 illustrates the result.-->

Abbildung 3-11 verdeutlicht das Ergebnis.

<!--Figure 3-11. Creating a new branch pointer.-->

Insert 18333fig0311.png
Abbildung 3-11. Erstellung eines neuen Branch-Zeigers

<!--You work on your web site and do some commits. Doing so moves the `iss53` branch forward, because you have it checked out (that is, your HEAD is pointing to it; see Figure 3-12):-->

Du arbeitest an Deiner Web-Seite und machst ein paar Commits. Das bewegt den `iss53`-Branch vorwärts, da Du ihn ausgebucht hast (das heißt, dass Dein HEAD-Zeiger darauf verweist; siehe Abbildung 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

<!--Figure 3-12. The iss53 branch has moved forward with your work.-->

Insert 18333fig0312.png
Abbildung 3-12. Der `iss53`-Branch hat mit Deiner Arbeit Schritt gehalten.

<!--Now you get the call that there is an issue with the web site, and you need to fix it immediately. With Git, you don’t have to deploy your fix along with the `iss53` changes you’ve made, and you don’t have to put a lot of effort into reverting those changes before you can work on applying your fix to what is in production. All you have to do is switch back to your master branch.-->

Nun bekommst Du einen Anruf, in dem Dir mitgeteilt wird, dass es ein Problem mit der Internet-Seite gibt, das Du umgehend beheben sollst. Bei Git musst Du Deine Fehlerkorrektur nicht zusammen mit den `iss53`-Änderungen einbringen. Und Du musst keine Zeit damit verschwenden, Deine bisherigen Änderungen rückgängig zu machen, bevor Du mit der Fehlerbehebung an der Produktionsumgebung beginnen kannst. Alles, was Du tun musst, ist, zu Deinem master-Branch wechseln.

<!--However, before you do that, note that if your working directory or staging area has uncommitted changes that conflict with the branch you’re checking out, Git won’t let you switch branches. It’s best to have a clean working state when you switch branches. There are ways to get around this (namely, stashing and commit amending) that we’ll cover later. For now, you’ve committed all your changes, so you can switch back to your master branch:-->

Beachte jedoch, dass Dich Git den Branch nur wechseln lässt, wenn bisherige Änderungen in Deinem Arbeitsverzeichnis oder Deiner Staging-Area nicht in Konflikt mit dem Zweig stehen, zu dem Du nun wechseln möchtest. Am besten ist es, wenn ein sauberer Arbeitsstand vorliegt, wenn man den Branch wechselt. Wir werden uns später mit Wegen befassen, dieses Verhalten zu umgehen (namentlich „Stashing“ und „Commit Ammending“). Vorerst aber hast Du Deine Änderungen bereits comitted, sodass Du zu Deinem master-Branch zurückwechseln kannst.

	$ git checkout master
	Switched to branch 'master'

<!--At this point, your project working directory is exactly the way it was before you started working on issue #53, and you can concentrate on your hotfix. This is an important point to remember: Git resets your working directory to look like the snapshot of the commit that the branch you check out points to. It adds, removes, and modifies files automatically to make sure your working copy is what the branch looked like on your last commit to it.-->

Zu diesem Zeitpunkt befindet sich das Arbeitsverzeichnis des Projektes in exakt dem gleichen Zustand, in dem es sich befand, als Du mit der Arbeit an Issue #53 begonnen hast und Du kannst Dich direkt auf Deinen Hotfix konzentrieren. Dies ist ein wichtiger Moment, um sich vor Augen zu halten, dass Git Dein Arbeitsverzeichnis auf den Zustand des Commits, auf den dieser Branch zeigt, zurücksetzt. Es erstellt, entfernt und verändert Dateien automatisch, um sicherzustellen, dass Deine Arbeitskopie haargenau so aussieht wie der Zweig nach Deinem letzten Commit.

<!--Next, you have a hotfix to make. Let’s create a hotfix branch on which to work until it’s completed (see Figure 3-13):-->

Nun hast Du einen Hotfix zu erstellen. Lass uns dazu einen hotfix-Branch erstellen, an dem Du bis zu dessen Fertigstellung arbeitest (siehe Abbildung 3-13):

	$ git checkout -b hotfix
	Switched to a new branch 'hotfix'
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix 3a0874c] fixed the broken email address
	 1 files changed, 1 deletion(-)

<!--Figure 3-13. hotfix branch based back at your master branch point.-->

Insert 18333fig0313.png
Abbildung 3-13. Der hotfix-Branch basiert auf dem zurückliegenden master-Branch.

<!--You can run your tests, make sure the hotfix is what you want, and merge it back into your master branch to deploy to production. You do this with the `git merge` command:-->

Du kannst Deine Tests durchführen und sicherstellen, dass der Hotfix seinen Zweck erfüllt und ihn dann mit dem master-Branch zusammenführen, um ihn in die Produktionsumgebung zu integrieren. Das machst Du mit der Anweisung `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast-forward
	 README | 1 -
	 1 file changed, 1 deletion(-)

<!--You’ll notice the phrase "Fast forward" in that merge. Because the commit pointed to by the branch you merged in was directly upstream of the commit you’re on, Git moves the pointer forward. To phrase that another way, when you try to merge one commit with a commit that can be reached by following the first commit’s history, Git simplifies things by moving the pointer forward because there is no divergent work to merge together — this is called a "fast forward".-->

Du wirst die Mitteilung „Fast Forward“ während des Zusammenführens bemerken. Da der neue Commit direkt von dem ursprünglichen Commit, auf den sich der nun eingebrachte Zweig bezieht, abstammt, bewegt Git einfach den Zeiger weiter. Mit anderen Worten kann Git den neuen Commit durch Verfolgen der Commitabfolge direkt erreichen, dann bewegt es ausschließlich den Branch-Zeiger. Zu einer tatsächlichen Kombination der Commits besteht ja kein Anlass. Dieses Vorgehen wird „Fast Forward“ genannt.

<!--Your change is now in the snapshot of the commit pointed to by the `master` branch, and you can deploy your change (see Figure 3-14).-->

Deine Modifikationen befinden sich nun als Schnappschuss in dem Commit, auf den der `master`-Branch zeigt, diese lassen sich nun veröffentlichen (siehe Abbildung 3-14).

<!--Figure 3-14. Your master branch points to the same place as your hotfix branch after the merge.-->

Insert 18333fig0314.png
Abbildung 3-14. Der master-Branch zeigt nach der Zusammenführung auf den gleichen Commit wie der hotfix-Branch.

<!--After your super-important fix is deployed, you’re ready to switch back to the work you were doing before you were interrupted. However, first you’ll delete the `hotfix` branch, because you no longer need it — the `master` branch points at the same place. You can delete it with the `-d` option to `git branch`:-->

Nachdem Dein superwichtiger Hotfix veröffentlicht wurde, kannst Du Dich wieder Deiner ursprünglichen Arbeit zuwenden. Vorher wird sich allerdings des nun nutzlosen hotfix-Zweiges entledigt, schließlich zeigt der master-Branch ebenfalls auf die aktuelle Version. Du kannst ihn mit der `-d`-Option von `git branch` entfernen:

	$ git branch -d hotfix
	Deleted branch hotfix (was 3a0874c).

<!--Now you can switch back to your work-in-progress branch on issue #53 and continue working on it (see Figure 3-15):-->

Nun kannst Du zu Deinem Issue #53-Branch zurückwechseln und mit Deiner Arbeit fortfahren (Abbildung 3-15):

	$ git checkout iss53
	Switched to branch 'iss53'
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53 ad82d7a] finished the new footer [issue 53]
	 1 file changed, 1 insertion(+)

<!--Figure 3-15. Your iss53 branch can move forward independently.-->

Insert 18333fig0315.png
Abbildung 3-15. Dein `iss53`-Branch kann sich unabhängig weiterentwickeln.

<!--It’s worth noting here that the work you did in your `hotfix` branch is not contained in the files in your `iss53` branch. If you need to pull it in, you can merge your `master` branch into your `iss53` branch by running `git merge master`, or you can wait to integrate those changes until you decide to pull the `iss53` branch back into `master` later.-->

An dieser Stelle ist anzumerken, dass die Änderungen an dem `hotfix`-Branch nicht in Deinen `iss53`-Branch eingeflossen sind. Falls nötig, kannst Du den `master`-Branch allerdings mit der Anweisung `git merge master` mit Deinem Branch kombinieren. Oder Du wartest, bis Du den `iss53`-Branch später in den `master`-Branch zurückführst.

<!--### Basic Merging ###-->

### Die Grundlagen des Zusammenführens (Mergen) ###

<!--Suppose you’ve decided that your issue #53 work is complete and ready to be merged into your `master` branch. In order to do that, you’ll merge in your `iss53` branch, much like you merged in your `hotfix` branch earlier. All you have to do is check out the branch you wish to merge into and then run the `git merge` command:-->

Angenommen, Du hast entschieden, dass Deine Arbeiten an issue #53 abgeschlossen sind und das Ganze soweit ist, dass es mit dem `master` Branch zusammengeführt werden kann. Um das zu erreichen, wirst Du Deinen `iss53` Branch in den `master` Branch einfließen lassen, genauso wie Du es mit dem `hotfix` Branch zuvor getan hast. Du musst nur mit der Anweisung `checkout` zum dem Branch zu wechseln, in welchen Du etwas einfließen lassen möchtest und dann die Anweisung `git merge` ausführen:

	$ git checkout master
	$ git merge iss53
	Auto-merging README
	Merge made by the 'recursive' strategy.
	 README | 1 +
	 1 file changed, 1 insertion(+)

<!--This looks a bit different than the `hotfix` merge you did earlier. In this case, your development history has diverged from some older point. Because the commit on the branch you’re on isn’t a direct ancestor of the branch you’re merging in, Git has to do some work. In this case, Git does a simple three-way merge, using the two snapshots pointed to by the branch tips and the common ancestor of the two. Figure 3-16 highlights the three snapshots that Git uses to do its merge in this case.-->

Das sieht ein bisschen anders aus als das `hotfix merge` von vorhin. Hier haben sich die Entwicklungsstränge schon zu einem früheren Zeitpunkt geteilt. Da der `commit` auf dem Branch, in dem Du Dich befindest, kein direkter Nachfolger von dem Branch ist, in den Du das `merge` machst, hat Git einiges zu tun. Dazu macht Git einen 3-Wege `merge`, wobei es die beiden Schnappschüsse verwendet, welche auf die Enden der Branches zeigen, und den gemeinsamen Vorfahren dieser beiden. Abbildung 3-16 zeigt die drei `snapshots`, die Git in diesem Fall für das `merge` verwendet.

<!--Figure 3-16. Git automatically identifies the best common-ancestor merge base for branch merging.-->

Insert 18333fig0316.png
Abbildung 3-16. Git erkennt automatisch den am besten geeigneten gemeinsamen Vorgänger für die Branchzusammenführung.

<!--Instead of just moving the branch pointer forward, Git creates a new snapshot that results from this three-way merge and automatically creates a new commit that points to it (see Figure 3-17). This is referred to as a merge commit and is special in that it has more than one parent.-->

Anstatt einfach den Zeiger vorwärts zu bewegen, erstellt Git einen neuen `snapshot`, der aus dem 3-Wege 'merge' resultiert und erzeugt automatisch einen neuen `commit`, der darauf verweist (siehe Abbildung 3-17). Dies wird auch als `merge commit` bezeichnet und ist ein Spezialfall, weil es mehr als nur einen Elternteil hat.

<!--It’s worth pointing out that Git determines the best common ancestor to use for its merge base; this is different than CVS or Subversion (before version 1.5), where the developer doing the merge has to figure out the best merge base for themselves. This makes merging a heck of a lot easier in Git than in these other systems.-->

Es ist wichtig herauszustellen, dass Git den am besten geeigneten gemeinsamen Vorgänger als Grundlage für das Zusammenführen bestimmt, denn hierin unterscheidet es sich von CVS und Subversion (vor Version 1.5), wo der Entwickler beim Zusammenführen die 'merge' Basis selbst ermitteln muss. In Git ist das Zusammenführen dadurch wesentlich einfacher, als in anderen Systemen.

<!--Figure 3-17. Git automatically creates a new commit object that contains the merged work.-->

Insert 18333fig0317.png
Abbildung 3-17. Git erstellt automatisch ein 'commit', dass die zusammengeführte Arbeit enthält.

<!--Now that your work is merged in, you have no further need for the `iss53` branch. You can delete it and then manually close the ticket in your ticket-tracking system:-->

Jetzt, da wir die Arbeit zusammengeführt haben, ist der `iss53`-Branch nicht mehr notwendig. Du kannst ihn löschen und das Ticket im Ticket-Tracking-System schließen.

	$ git branch -d iss53

<!--### Basic Merge Conflicts ###-->
### Grundlegende Merge-Konflikte ###

<!--Occasionally, this process doesn’t go smoothly. If you changed the same part of the same file differently in the two branches you’re merging together, Git won’t be able to merge them cleanly. If your fix for issue #53 modified the same part of a file as the `hotfix`, you’ll get a merge conflict that looks something like this:-->

Gelegentlich verläuft der Prozess nicht ganz so glatt. Wenn Du an den selben Stellen in den selben Dateien unterschiedlicher Branches etwas geändert hast, kann Git diese nicht sauber zusammenführen. Wenn Dein Fix an 'issue #53' die selbe Stelle in einer Datei verändert hat, die Du auch mit `hotfix` angefasst hast, wirst Du einen 'merge'-Konflikt erhalten, der ungefähr so aussehen könnte:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

<!--Git hasn’t automatically created a new merge commit. It has paused the process while you resolve the conflict. If you want to see which files are unmerged at any point after a merge conflict, you can run `git status`:-->

Git hat hier keinen 'merge commit' erstellt. Es hat den Prozess gestoppt, damit Du den Konflikt beseitigen kannst. Wenn Du sehen willst, welche Dateien 'unmerged' aufgrund eines 'merge' Konflikts sind, benutze einfach `git status`:

	$ git status
	On branch master
	You have unmerged paths.
	  (fix conflicts and run "git commit")

	Unmerged paths:
	  (use "git add <file>..." to mark resolution)

	        both modified:      index.html

	no changes added to commit (use "git add" and/or "git commit -a")

<!--Anything that has merge conflicts and hasn’t been resolved is listed as unmerged. Git adds standard conflict-resolution markers to the files that have conflicts, so you can open them manually and resolve those conflicts. Your file contains a section that looks something like this:-->

Alles, was einen 'merge' Konflikt aufweist und nicht gelöst werden konnte, wird als 'unmerged' aufgeführt. Git fügt den betroffenen Dateien Standard-Konfliktlösungsmarker hinzu, sodass Du diese öffnen und den Konflikt manuell lösen kannst. Deine Datei enthält einen Bereich, der so aussehen könnte:

	<<<<<<< HEAD
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53

<!--This means the version in HEAD (your master branch, because that was what you had checked out when you ran your merge command) is the top part of that block (everything above the `=======`), while the version in your `iss53` branch looks like everything in the bottom part. In order to resolve the conflict, you have to either choose one side or the other or merge the contents yourself. For instance, you might resolve this conflict by replacing the entire block with this:-->

Das heißt, die Version in HEAD (Deines 'master'-Branches, denn der wurde per 'checkout' aktiviert, als Du das 'merge' gemacht hast) ist der obere Teil des Blocks (alles oberhalb von '======='), und die Version aus dem `iss53`-Branch sieht wie der darunter befindliche Teil aus. Um den Konflikt zu lösen, musst Du Dich entweder für einen der beiden Teile entscheiden oder Du ersetzt den Teil komplett:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

<!--This resolution has a little of each section, and I’ve fully removed the `<<<<<<<`, `=======`, and `>>>>>>>` lines. After you’ve resolved each of these sections in each conflicted file, run `git add` on each file to mark it as resolved. Staging the file marks it as resolved in Git.-->
<!--If you want to use a graphical tool to resolve these issues, you can run `git mergetool`, which fires up an appropriate visual merge tool and walks you through the conflicts:-->

Diese Lösung hat von beiden Teilen etwas und ich habe die Zeilen mit `<<<<<<<`, `=======`, und `>>>>>>>` komplett gelöscht. Nachdem Du alle problematischen Bereiche in allen von dem Konflikt betroffenen Dateien beseitigt hast, führe einfach `git add` für alle betroffenen Dateien aus und markiere sie damit als bereinigt. Dieses 'staging' der Dateien markiert sie für Git als bereinigt.
Wenn Du ein grafisches Tool zur Bereinigung benutzen willst, dann verwende `git mergetool`, welches ein passendes grafisches 'merge'-Tool startet und Dich durch die Konfliktbereiche führt:

	$ git mergetool

	This message is displayed because 'merge.tool' is not configured.
	See 'git mergetool --tool-help' or 'git help config' for more details.
	'git mergetool' will now attempt to use one of the following tools:
	opendiff kdiff3 tkdiff xxdiff meld tortoisemerge gvimdiff diffuse diffmerge ecmerge p4merge araxis bc3 codecompare vimdiff emerge
	Merging:
	index.html

	Normal merge conflict for 'index.html':
	  {local}: modified file
	  {remote}: modified file
	Hit return to start merge resolution tool (opendiff):

<!--If you want to use a merge tool other than the default (Git chose `opendiff` for me in this case because I ran the command on a Mac), you can see all the supported tools listed at the top after “... one of the following tools:”. Type the name of the tool you’d rather use. In Chapter 7, we’ll discuss how you can change this default value for your environment.-->

Wenn Du ein anderes Tool anstelle des Standardwerkzeugs für ein 'merge' verwenden möchtest (Git verwendet in meinem Fall `opendiff`, da ich auf einem Mac arbeite), dann kannst Du alle unterstützten Werkzeuge oben – unter „one of the following tools“ – aufgelistet sehen. Tippe einfach den Namen Deines gewünschten Werkzeugs ein. In Kapitel 7 besprechen wir, wie Du diesen Standardwert in Deiner Umgebung dauerhaft ändern kannst.

<!--After you exit the merge tool, Git asks you if the merge was successful. If you tell the script that it was, it stages the file to mark it as resolved for you.-->

Wenn Du das 'merge' Werkzeug beendest, fragt Dich Git, ob das Zusammenführen erfolgreich war. Wenn Du mit 'Ja' antwortest, wird das Skript diese Dateien als gelöst markieren.

<!--You can run `git status` again to verify that all conflicts have been resolved:-->

Du kannst `git status` erneut ausführen, um zu sehen, ob alle Konflikte gelöst sind:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)

	        modified:   index.html


<!--If you’re happy with that, and you verify that everything that had conflicts has been staged, you can type `git commit` to finalize the merge commit. The commit message by default looks something like this:-->

Wenn Du zufrieden bist und Du geprüft hast, dass alle Konflikte beseitigt wurden, kannst Du `git commit` ausführen, um den 'merge commit' abzuschließen. Die Standardbeschreibung für diese Art 'commit' sieht wie folgt aus:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a merge.
	# If this is not correct, please remove the file
	#       .git/MERGE_HEAD
	# and try again.
	#

<!--You can modify that message with details about how you resolved the merge if you think it would be helpful to others looking at this merge in the future — why you did what you did, if it’s not obvious.-->

Wenn Du glaubst, für zukünftige Betrachter des Commits könnte es hilfreich sein zu erklären, warum Du getan hast, was Du getan hast, dann kannst Du der Commit-Beschreibung noch zusätzliche Informationen hinzufügen, falls es nicht offensichtlich ist.

<!--## Branch Management ##-->
## Branch Management ##

<!--Now that you’ve created, merged, and deleted some branches, let’s look at some branch-management tools that will come in handy when you begin using branches all the time.-->

Du weißt jetzt, wie Du Branches erstellen, zusammenfügen und löschen kannst. Wir schauen uns jetzt noch ein paar recht nützliche Tools für die Arbeit mit Branches an.

<!--The `git branch` command does more than just create and delete branches. If you run it with no arguments, you get a simple listing of your current branches:-->

Die Anweisung `git branch` kann mehr, als nur Branches zu erstellen oder zu löschen. Wenn Du es ohne weitere Argumente ausführst, wird es Dir eine Liste mit Deinen aktuellen Branches anzeigen:

	$ git branch
	  iss53
	* master
	  testing

<!--Notice the `*` character that prefixes the `master` branch: it indicates the branch that you currently have checked out. This means that if you commit at this point, the `master` branch will be moved forward with your new work. To see the last commit on each branch, you can run `git branch -v`:-->

Das `*` vor dem `master`-Branch bedeutet, dass dies der gerade ausgecheckte Branch ist. Wenn Du also jetzt einen Commit erzeugst, wird dieser in den `master`-Branch gehen. Du kannst Dir mit `git branch -v` ganz schnell für jeden Branch den letzten Commit anzeigen lassen:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

<!--Another useful option to figure out what state your branches are in is to filter this list to branches that you have or have not yet merged into the branch you’re currently on. There are useful `-\-merged` and `-\-no-merged` options available in Git for this purpose. To see which branches are already merged into the branch you’re on, you can run `git branch -\-merged`:-->

Mit einer weiteren nützlichen Option kannst Du herausfinden, in welchem Zustand Deine Branches sind: welche der Branches wurden bereits in den aktuellen Branch gemergt und welche wurden es nicht. Für diesen Zweck gibt es in Git die Optionen `--merged` und `--no-merged`. Um herauszufinden, welche Branches schon in den aktuell ausgecheckten gemergt wurden, kannst Du einfach `git branch --merged` aufrufen:

	$ git branch --merged
	  iss53
	* master

<!--Because you already merged in `iss53` earlier, you see it in your list. Branches on this list without the `*` in front of them are generally fine to delete with `git branch -d`; you’ve already incorporated their work into another branch, so you’re not going to lose anything.-->

Da Du den Branch `iss53` schon gemergt hast, siehst Du ihn in dieser Liste. Alle Branches in dieser Liste, welchen kein `*` voransteht, können ohne Datenverlust mit `git branch -d` gelöscht werden, da sie ja bereits gemergt wurden.

<!--To see all the branches that contain work you haven’t yet merged in, you can run `git branch -\-no-merged`:-->

Um alle Branches zu sehen, welche noch nicht gemergte Änderungen enthalten, kannst Du `git branch --no-merged` aufrufen:

	$ git branch --no-merged
	  testing

<!--This shows your other branch. Because it contains work that isn’t merged in yet, trying to delete it with `git branch -d` will fail:-->

Die Liste zeigt Dir den anderen Branch. Er enthält Arbeit, die noch nicht gemergt wurde. Der Versuch, den Branch mit `git branch -d` zu löschen schlägt fehl:

	$ git branch -d testing
	error: The branch 'testing' is not fully merged.
	If you are sure you want to delete it, run 'git branch -D testing'.

<!--If you really do want to delete the branch and lose that work, you can force it with `-D`, as the helpful message points out.-->

Wenn Du den Branch trotzdem löschen und damit alle Änderungen dieses Branches verlieren willst, kannst Du das mit `git branch -D testing` machen.

<!--## Branching Workflows ##-->
## Branching Workflows ##

<!--Now that you have the basics of branching and merging down, what can or should you do with them? In this section, we’ll cover some common workflows that this lightweight branching makes possible, so you can decide if you would like to incorporate it into your own development cycle.-->

Jetzt, da Du die Grundlagen von 'branching' und 'merging' kennst, fragst Du Dich sicher, was Du damit anfangen kannst. In diesem Abschnitt werden wir uns typische Workflows anschauen, die dieses leichtgewichtige 'branching' möglich macht. Und Du kannst dann entscheiden, ob Du es in Deinem eigenen Entwicklungszyklus verwenden willst.

<!--### Long-Running Branches ###-->
### Langfristige Branches ###

<!--Because Git uses a simple three-way merge, merging from one branch into another multiple times over a long period is generally easy to do. This means you can have several branches that are always open and that you use for different stages of your development cycle; you can merge regularly from some of them into others.-->

Da Git das einfache 3-Wege-'merge' verwendet, ist häufiges Zusammenführen von einem Branch in einen anderen über einen langen Zeitraum generell einfach zu bewerkstelligen. Das heißt, Du kannst mehrere Branches haben, die immer offen sind und die Du für unterschiedliche Stadien Deines Entwicklungszyklus verwendest, und Du kannst regelmäßig welche von diesen mit anderen zusammenführen.

<!--Many Git developers have a workflow that embraces this approach, such as having only code that is entirely stable in their `master` branch — possibly only code that has been or will be released. They have another parallel branch named develop or next that they work from or use to test stability — it isn’t necessarily always stable, but whenever it gets to a stable state, it can be merged into `master`. It’s used to pull in topic branches (short-lived branches, like your earlier `iss53` branch) when they’re ready, to make sure they pass all the tests and don’t introduce bugs.-->

Viele Git Entwickler verfolgen mit ihrem Workflow den Ansatz, nur den stabilen Code in dem `master`-Branch zu halten – möglicherweise auch nur Code, der released wurde oder werden kann. Sie betreiben parallel einen anderen Branch zum Arbeiten oder Testen. Wenn dieser parallele Zweig einen stabilen Status erreicht, kann er mit dem `master`-Branch zusammengeführt werden. Dies findet bei themenbezogenen Branches (kurzfristigen Branches, wie der zuvor genannte `iss53`-Branch) Anwendung, um sicherzustellen, dass dieser die Tests besteht und keine Fehler verursacht.

<!--In reality, we’re talking about pointers moving up the line of commits you’re making. The stable branches are farther down the line in your commit history, and the bleeding-edge branches are farther up the history (see Figure 3-18).-->

Eigentlich reden wir gerade über Zeiger, die in der Reihe Deiner Commits aufsteigen. Die stabilen Branches liegen weiter unten und die bleeding-edge Branches weiter oben in diesem Verlauf (siehe Abbildung 3-18).

<!--Figure 3-18. More stable branches are generally farther down the commit history.-->

Insert 18333fig0318.png
Abbildung 3-18. Stabilere Branches sind generell weiter unten im Entwicklungsverlauf.

<!--It’s generally easier to think about them as work silos, where sets of commits graduate to a more stable silo when they’re fully tested (see Figure 3-19).-->

Es ist leichter, sich die verschiedenen Branches als Arbeitsdepots vorzustellen, in denen Sätze von Commits in stabilere Depots aufsteigen, sobald sie ausreichend getestet wurden (siehe Abbildung 3-19).

<!--Figure 3-19. It may be helpful to think of your branches as silos.-->

Insert 18333fig0319.png
Abbildung 3-19. Es könnte hilfreich sein, sich die Branches als Depots vorzustellen.

<!--You can keep doing this for several levels of stability. Some larger projects also have a `proposed` or `pu` (proposed updates) branch that has integrated branches that may not be ready to go into the `next` or `master` branch. The idea is that your branches are at various levels of stability; when they reach a more stable level, they’re merged into the branch above them.-->
<!--Again, having multiple long-running branches isn’t necessary, but it’s often helpful, especially when you’re dealing with very large or complex projects.-->

Das lässt sich für beliebig viele Stabilitätsabstufungen umsetzen. Manche größeren Projekte haben auch einen `proposed` (vorgeschlagenen) oder `pu` (proposed updates – vorgeschlagene Updates) Zweig mit Branches, die vielleicht noch nicht bereit sind, in den `next`- oder `master`-Branch integriert zu werden. Die Idee dahinter ist, dass Deine Branches verschiedene Stabilitätsabstufungen repräsentieren. Sobald sie eine stabilere Stufe erreichen, werden sie mit dem nächsthöheren Branch zusammengeführt.

Nochmal, langfristig verschiedene Branches parallel laufen zu lassen, ist nicht notwendig, aber oft hilfreich,  insbesondere wenn man es mit sehr großen oder komplexen Projekten zu tun hat.

<!--### Topic Branches ###-->
### Themen-Branches ###

<!--Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and use for a single particular feature or related work. This is something you’ve likely never done with a VCS before because it’s generally too expensive to create and merge branches. But in Git it’s common to create, work on, merge, and delete branches several times a day.-->

Themen-Branches sind in jedem Projekt nützlich, egal bei welcher Größe. Ein Themen-Branch ist ein kurzlebiger Zweig, der für eine spezielle Aufgabe oder ähnliche Arbeiten erstellt und benutzt wird. Das ist vielleicht etwas, was Du noch nie zuvor mit einem Versionierungssystem gemacht hast, weil es normalerweise zu aufwändig und mühsam ist, Branches zu erstellen und zusammenzuführen. Mit Git ist es allerdings vollkommen geläufig, mehrmals am Tag Branches zu erstellen, an ihnen zu arbeiten, sie zusammenzuführen und sie anschließend wieder zu löschen.

<!--You saw this in the last section with the `iss53` and `hotfix` branches you created. You did a few commits on them and deleted them directly after merging them into your main branch. This technique allows you to context-switch quickly and completely — because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.-->

Du hast das im letzten Abschnitt an den von Dir erstellten `iss53`- und `hotfix`-Branches gesehen. Du hast mehrere Commits auf sie angewendet und sie unmittelbar nach Zusammenführung mit Deinem Hauptzweig gelöscht. Diese Technik erlaubt es Dir, schnell und vollständig den Kontext zu wechseln. Da Deine Arbeit in verschiedene Depots aufgeteilt ist, in denen alle Änderungen unter die Thematik dieses Branches fallen, ist es leichter nachzuvollziehen, was bei Code-Überprüfungen und ähnlichem geschehen ist. Du kannst die Änderungen darin für Minuten, Tage oder Monate aufbewahren und sie einfließen lassen, wenn diese fertig sind, ungeachtet der Reihenfolge, in welcher diese erstellt oder bearbeitet wurden.

<!--Consider an example of doing some work (on `master`), branching off for an issue (`iss91`), working on it for a bit, branching off the second branch to try another way of handling the same thing (`iss91v2`), going back to your master branch and working there for a while, and then branching off there to do some work that you’re not sure is a good idea (`dumbidea` branch). Your commit history will look something like Figure 3-20.-->

Stell Dir vor, Du arbeitest ein bisschen (in `master`), erstellst mal eben einen Branch für einen Fehler (`iss91`), arbeitest an dem für eine Weile, erstellst einen zweiten Branch, um eine andere Problemlösung für den selben Fehler auszuprobieren (`iss91v2`), wechselst zurück zu Deinem master-Branch, arbeitest dort ein bisschen und machst dann einen neuen Branch für etwas, wovon Du nicht weißt, ob es eine gute Idee ist (`dumbidea`-Branch). Dein Commit-Verlauf wird wie in Abbildung 3-20 aussehen.

<!--Figure 3-20. Your commit history with multiple topic branches.-->

Insert 18333fig0320.png
Abbildung 3-20. Dein Commit-Verlauf mit verschiedenen Themen-Branches.

<!--Now, let’s say you decide you like the second solution to your issue best (`iss91v2`); and you showed the `dumbidea` branch to your coworkers, and it turns out to be genius. You can throw away the original `iss91` branch (losing commits C5 and C6) and merge in the other two. Your history then looks like Figure 3-21.-->

Nun, sagen wir, Du hast Dich entschieden, die zweite Lösung des Fehlers (`iss91v2`) zu bevorzugen, außerdem hast den `dumbidea`-Branch Deinen Mitarbeitern gezeigt und es hat sich herausgestellt, dass er genial ist. Du kannst also den ursprünglichen `iss91`-Branch (unter Verlust der Commits C5 und C6) wegwerfen und die anderen beiden einfließen lassen. Dein Verlauf sieht dann aus wie in Abbildung 3-21.

<!--Figure 3-21. Your history after merging in dumbidea and iss91v2.-->

Insert 18333fig0321.png
Abbildung 3-21. Dein Verlauf nach Zusammenführung von `dumbidea` und `iss91v2`.

<!--It’s important to remember when you’re doing all this that these branches are completely local. When you’re branching and merging, everything is being done only in your Git repository — no server communication is happening.-->

Es ist wichtig, sich daran zu erinnern, dass alle diese Branches nur lokal existieren. Wenn Du Verzweigungen schaffst (branchst) und wieder zusammenführst (mergest), findet dies nur in Deinem Git-Repository statt – es findet keine Server-Kommunikation statt.

<!--## Remote Branches ##-->
## Externe Branches ##

<!--Remote branches are references to the state of branches on your remote repositories. They’re local branches that you can’t move; they’re moved automatically whenever you do any network communication. Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.-->

Externe (Remote) Branches sind Referenzen auf den Zustand der Branches in Deinen externen Repositorys. Sie sind lokale Branches, die Du nicht verändern kannst, sie werden automatisch verändert, wann immer Du eine Netzwerkoperation durchführst. Externe Branches verhalten sich wie Lesezeichen, um Dich daran zu erinnern, an welcher Position sich die Branches in Deinen externen Repositorys befanden, als Du Dich zum letzten Mal mit ihnen verbunden hattest.

<!--They take the form `(remote)/(branch)`. For instance, if you wanted to see what the `master` branch on your `origin` remote looked like as of the last time you communicated with it, you would check the `origin/master` branch. If you were working on an issue with a partner and they pushed up an `iss53` branch, you might have your own local `iss53` branch; but the branch on the server would point to the commit at `origin/iss53`.-->

Externe Branches besitzen die Schreibweise `(Repository)/(Branch)`. Wenn Du beispielsweise wissen möchtest, wie der `master`-Branch in Deinem `origin`-Repository ausgesehen hat, als Du zuletzt Kontakt mit ihm hattest, dann würdest Du den `origin/master`-Branch überprüfen. Wenn Du mit einem Mitarbeiter an einer Fehlerbehebung gearbeitet hast und dieser bereits einen `iss53`-Branch hochgeladen hat, besitzt Du möglicherweise Deinen eigenen lokalen `iss53`-Branch. Der Branch auf dem Server würde allerdings auf den Commit von `origin/iss53` zeigen.

<!--This may be a bit confusing, so let’s look at an example. Let’s say you have a Git server on your network at `git.ourcompany.com`. If you clone from this, Git automatically names it `origin` for you, pulls down all its data, creates a pointer to where its `master` branch is, and names it `origin/master` locally; and you can’t move it. Git also gives you your own `master` branch starting at the same place as origin’s `master` branch, so you have something to work from (see Figure 3-22).-->

Das kann ein wenig verwirrend sein, lass uns also ein Besipiel betrachten. Nehmen wir an, Du hättest in Deinem Netzwerk einen Git-Server mit der Adresse `git.ourcompany.com`. Wenn Du von diesem klonst, nennt Git ihn automatisch `origin` für Dich, lädt all seine Daten herunter, erstellt einen Zeiger zur der Stelle, wo sein `master`-Branch ist und benennt es lokal `origin/master`; und er ist unveränderbar für Dich. Git gibt Dir auch einen eigenen `master`-Branch mit der gleichen Ausgangsposition wie origins `master`-Branch, damit Du einen Punkt für den Beginn Deiner Arbeiten hast (siehe Abbildung 3-22).

<!--Figure 3-22. A Git clone gives you your own master branch and origin/master pointing to origin’s master branch.-->

Insert 18333fig0322.png
Abbildung 3-22. Ein 'git clone' gibt Dir Deinen eigenen `master`-Branch und `origin/master`, welcher auf origins 'master'-Branch zeigt.

<!--If you do some work on your local master branch, and, in the meantime, someone else pushes to `git.ourcompany.com` and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your `origin/master` pointer doesn’t move (see Figure 3-23).-->

Wenn Du ein wenig an Deinem lokalen `master`-Branch arbeitest und in der Zwischenzeit ein anderer etwas zu `git.ourcompany.com` herauflädt und damit den `master`-Branch auf dem externen Server aktualisiert, dann entwickeln sich Eure Arbeitsverläufe unterschiedlich. Außerdem bewegt sich Dein `origin/master`-Zeiger nicht, solange Du keinen Kontakt mit Deinem `origin`-Server aufnimmst (siehe Abbildung 3-23).

<!--Figure 3-23. Working locally and having someone push to your remote server makes each history move forward differently.-->

Insert 18333fig0323.png
Abbildung 3-23. Lokal zu arbeiten, während ein anderer auf Deinen externen Server hochlädt, führt zu unterschiedlichen Verläufen.

<!--To synchronize your work, you run a `git fetch origin` command. This command looks up which server origin is (in this case, it’s `git.ourcompany.com`), fetches any data from it that you don’t yet have, and updates your local database, moving your `origin/master` pointer to its new, more up-to-date position (see Figure 3-24).-->

Um Deine Arbeit abzugleichen, führe die Anweisung `git fetch origin` aus. Die Anweisung schlägt nach, welcher Server `orgin` ist (in diesem Fall `git.ourcompany.com`), holt alle Daten, die Dir bisher fehlen und aktualisiert Deine lokale Datenbank, indem es Deinen `orgin/master`-Zeiger auf seine neue aktuellere Position bewegt (siehe Abbildung 3-24).

<!--Figure 3-24. The git fetch command updates your remote references.-->

Insert 18333fig0324.png
Abbildung 3-24. Die Anweisung `git fetch` aktualisiert Deine externen Referenzen.

<!--To demonstrate having multiple remote servers and what remote branches for those remote projects look like, let’s assume you have another internal Git server that is used only for development by one of your sprint teams. This server is at `git.team1.ourcompany.com`. You can add it as a new remote reference to the project you’re currently working on by running the `git remote add` command as we covered in Chapter 2. Name this remote `teamone`, which will be your shortname for that whole URL (see Figure 3-25).-->

Um zu demonstrieren, wie Branches auf verschiedenen Remote-Servern aussehen, stellen wir uns vor, dass Du einen weiteren internen Git-Server besitzt, welcher nur von einem Deiner Sprint-Teams zur Entwicklung genutzt wird. Diesen Server erreichen wir unter `git.team1.ourcompany.com`. Du kannst ihn mit der Git-Anweisung `git remote add`, wie in Kapitel 2 beschrieben, Deinem derzeitigen Arbeitsprojekt als weiteren Quell-Server hinzufügen. Gib dem Remote-Server den Namen `teamone`, welcher nun als Synonym für die ausgeschriebene Internetadresse dient (siehe Abbildung 3-25).

<!--Figure 3-25. Adding another server as a remote.-->

Insert 18333fig0325.png
Abbildung 3-25. Einen weiteren Server als Quelle hinzufügen.

<!--Now, you can run `git fetch teamone` to fetch everything the remote `teamone` server has that you don’t have yet. Because that server has a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (see Figure 3-26).-->

Nun kannst Du einfach `git fetch teamone` ausführen, um alles vom Server zu holen, was Du noch nicht hast. Da der Datenbestand auf dem Teamserver ein Teil der Informationen auf Deinem `origin`-Server ist, holt Git keine Daten, erstellt allerdings einen Remote-Branch namens `teamone/master`, der auf den gleichen Commit wie `teamone`s `master`-Branch zeigt (siehe Abbildung 3-26).

<!--Figure 3-26. You get a reference to teamone’s master branch position locally.-->

Insert 18333fig0326.png
Abbildung 3-26. Du bekommst eine lokale Referenz auf `teamone`s `master`-Branch.

<!--### Pushing ###-->
### Hochladen ###

<!--When you want to share a branch with the world, you need to push it up to a remote that you have write access to. Your local branches aren’t automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share. That way, you can use private branches for work you don’t want to share, and push up only the topic branches you want to collaborate on.-->

Wenn Du einen Branch mit der Welt teilen möchtest, musst Du ihn auf einen externen Server laden, auf dem Du Schreibrechte besitzt. Deine lokalen Zweige werden nicht automatisch mit den Remote-Servern synchronisiert, wenn Du etwas änderst – Du musst die zu veröffentlichenden Branches explizit hochladen (pushen). Auf diesem Weg kannst Du an privaten Zweigen arbeiten, die Du nicht veröffentlichen möchtest, und nur die Themen-Branches replizieren, an denen Du gemeinsam mit anderen entwickeln möchtest.

<!--If you have a branch named `serverfix` that you want to work on with others, you can push it up the same way you pushed your first branch. Run `git push (remote) (branch)`:-->

Wenn Du einen Zweig namens `serverfix` besitzt, an dem Du mit anderen arbeiten möchtest, dann kannst Du diesen auf dieselbe Weise hochladen wie Deinen ersten Branch. Führe `git push (remote) (branch)` aus:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

<!--This is a bit of a shortcut. Git automatically expands the `serverfix` branchname out to `refs/heads/serverfix:refs/heads/serverfix`, which means, “Take my serverfix local branch and push it to update the remote’s serverfix branch.” We’ll go over the `refs/heads/` part in detail in Chapter 9, but you can generally leave it off. You can also do `git push origin serverfix:serverfix`, which does the same thing — it says, “Take my serverfix and make it the remote’s serverfix.” You can use this format to push a local branch into a remote branch that is named differently. If you didn’t want it to be called `serverfix` on the remote, you could instead run `git push origin serverfix:awesomebranch` to push your local `serverfix` branch to the `awesomebranch` branch on the remote project.-->

Hierbei handelt es sich um eine Abkürzung. Git erweitert die `serverfix`-Branchbezeichnung automatisch zu `refs/heads/serverfix:refs/heads/serverfix`, was soviel bedeutet wie “Nimm meinen lokalen `serverfix`-Branch und aktualisiere damit den `serverfix`-Branch auf meinem externen Server”. Wir werden den `refs/heads/`-Teil in Kapitel 9 noch näher beleuchten, Du kannst ihn aber in der Regel weglassen. Du kannst auch `git push origin serverfix:serverfix` ausführen, was das Gleiche bewirkt – es bedeutet “Nimm meinen `serverfix` und mach ihn zum externen `serverfix`”. Du kannst dieses Format auch benutzen, um einen lokalen Zweig in einen externen Branch mit anderem Namen zu laden. Wenn Du ihn auf dem externen Server nicht `serverfix` nennen möchtest, könntest Du stattdessen `git push origin serverfix:awesomebranch` ausführen, um Deinen lokalen `serverfix`-Branch in den `awesomebranch`-Zweig in Deinem externen Projekt zu laden.

<!--The next time one of your collaborators fetches from the server, they will get a reference to where the server’s version of `serverfix` is under the remote branch `origin/serverfix`:-->

Das nächste Mal, wenn einer Deiner Mitarbeiter den aktuellen Status des Git-Projektes vom Server abruft, wird er eine Referenz auf den externen Branch `origin/serverfix` unter dem Namen `serverfix` erhalten:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

<!--It’s important to note that when you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. In other words, in this case, you don’t have a new `serverfix` branch — you only have an `origin/serverfix` pointer that you can’t modify.-->

Es ist wichtig festzuhalten, dass Du mit Abrufen eines neuen externen Branches nicht automatisch eine lokale, bearbeitbare Kopie desselben erhältst. Mit anderen Worten, in diesem Fall bekommst Du keinen neuen `serverfix`-Branch – sondern nur einen `origin/serverfix`-Zeiger, den Du nicht verändern kannst.

<!--To merge this work into your current working branch, you can run `git merge origin/serverfix`. If you want your own `serverfix` branch that you can work on, you can base it off your remote branch:-->

Um diese referenzierte Arbeit mit Deinem derzeitigen Arbeitsbranch zusammenzuführen, kannst Du `git merge origin/serverfix` ausführen. Wenn Du allerdings Deine eigene Arbeitskopie des `serverfix`-Branches erstellen möchtest, dann kannst Du diesen auf Grundlage des externen Zweiges erstellen:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

<!--This gives you a local branch that you can work on that starts where `origin/serverfix` is.-->

Dies erstellt Dir einen lokalen bearbeitbaren Branch mit der Grundlage des `origin/serverfix`-Zweiges.

<!--### Tracking Branches ###-->
### Tracking Branches ###

<!--Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type `git push`, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.-->

Das Auschecken eines lokalen Branches von einem Remote-Branch erzeugt automatisch einen sogenannten _Tracking-Branch_. Tracking Branches sind lokale Branches mit einer direkten Beziehung zu dem Remote-Zweig. Wenn Du Dich in einem Tracking-Branch befindest und `git push` eingibst, weiß Git automatisch, zu welchem Server und Repository es pushen soll. Ebenso führt `git pull` in einem dieser Branches dazu, dass alle entfernten Referenzen gefetched und automatisch in den Zweig gemerged werden.

<!--When you clone a repository, it generally automatically creates a `master` branch that tracks `origin/master`. That’s why `git push` and `git pull` work out of the box with no other arguments. However, you can set up other tracking branches if you wish — ones that don’t track branches on `origin` and don’t track the `master` branch. The simple case is the example you just saw, running `git checkout -b [branch] [remotename]/[branch]`. If you have Git version 1.6.2 or later, you can also use the `-\-track` shorthand:-->

Wenn Du ein Repository klonst, wird automatisch ein `master`-Branch erzeugt, welcher `origin/master` verfolgt. Deshalb können `git push` und `git pull` ohne weitere Argumente aufgerufen werden. Du kannst natürlich auch eigene Tracking-Branches erzeugen – welche die nicht Zweige auf `origin` und dessen `master`-Branch verfolgen. Der einfachste Fall ist das bereits gesehene Beispiel, in welchem Du `git checkout -b [branch] [remotename]/[branch]` ausführst. Mit der Git-Version 1.6.2 oder später kannst Du auch die `--track`-Kurzvariante nutzen:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

<!--To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:-->

Um einen lokalen Branch zu erzeugen mit einem anderen Namen als dem des Remote-Branches, kannst Du einfach die erste Variante mit einem neuen lokalen Branch-Namen verwenden:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch serverfix from origin.
	Switched to a new branch 'sf'

<!--Now, your local branch `sf` will automatically push to and pull from `origin/serverfix`.-->

Nun wird Dein lokaler Branch `sf` automatisch push und pull auf `origin/serverfix` durchführen.

<!--### Deleting Remote Branches ###-->
### Löschen entfernter Branches ###

<!--Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:-->

Stellen wir uns vor, Du bist fertig mit Deinem Remote-Branch – sagen wir Deine Mitarbeiter und Du, Ihr seid fertig mit einer neuen Funktion und habt sie in den entfernten `master`-Branch (oder in welchem Zweig Ihr sonst den stabilen Code ablegt) gemerged. Dann kannst Du den Remote-Branch löschen, indem Du die recht stumpfsinnige Syntax `git push [remotename] :[branch]` benutzt. Wenn Du Deinen `serverfix`-Branch vom Server löschen möchtest, führe folgendes aus:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

<!--Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”-->

Boom. Kein Zweig mehr auf Deinem Server. Du möchtest Dir diese Seite vielleicht markieren, weil Du diese Anweisung noch benötigen wirst und man leicht deren Syntax vergisst. Ein Weg, sich an diese Anweisung zu erinnern, führt über die `git push [remotename] [localbranch]:[remotebranch]`-Snytax, welche wir bereits behandelt haben. Wenn Du den `[localbranch]`-Teil weglässt, dann sagst Du einfach „Nimm nichts von meiner Seite und mach es zu `[remotebranch]`“.

<!--## Rebasing ##-->
## Rebasing ##

<!--In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.-->

Es gibt in Git zwei Wege, um Änderungen von einem Branch in einen anderen zu überführen: `merge` und `rebase`. In diesem Abschnitt wirst Du erfahren, was Rebasing ist, wie Du es anwendest, warum es ein verdammt abgefahrenes Werkzeug ist und bei welchen Gelegenheiten Du es besser nicht einsetzen solltest.

<!--### The Basic Rebase ###-->
### Der einfache Rebase ###

<!--If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.-->

Wenn Du zu einem früheren Beispiel aus dem Merge-Kapitel zurückkehrst (siehe Abbildung 3-27), kannst Du sehen, dass Du Deine Arbeit aufgeteilt und Commits auf zwei unterschiedlichen Branches erstellt hast.

<!--Figure 3-27. Your initial diverged commit history.-->

Insert 18333fig0327.png
Abbildung 3-27. Deine initiale Commit-Historie zum Zeitpunkt der Aufteilung.

<!--The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.-->

Der einfachste Weg, um Zweige zusammenzuführen, ist, wie bereits behandelt, die `merge`-Anweisung. Sie führt einen Drei-Wege-Merge durch zwischen den beiden letzten Branch-Zuständen (C3 und C4) und dem letzen gemeinsamen Vorgänger (C2) der beiden, erstellt einen neuen Schnappschuss (und einen Commit), wie in Abbildung 3-28 dargestellt.

<!--Figure 3-28. Merging a branch to integrate the diverged work history.-->

Insert 18333fig0328.png
Abbildung 3-28. Zusammenführen von Branches, um die verschiedenen Arbeitsfortschritte zu integrieren.

<!--However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.-->

Allerdings gibt es noch einen anderen Weg: Du kannst den Patch der Änderungen, den wir in C3 eingeführt haben, nehmen und erneut anwenden auf C4. Dieses Vorgehen nennt man in Git _rebasing_. Mit der `rebase`-Anweisung kannst Du alle Änderungen, die an einem Branch vorgenommen wurden, auf einen anderen Branch erneut anwenden.

<!--In this example, you’d run the following:-->

In unserem Beispiel würdest Du folgendes ausführen:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

<!--It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.-->

Dies funktioniert, indem Git zum letzten gemeinsamen Vorfahren der beiden Branches (der, auf dem Du arbeitest, und jener, auf den Du _rebasen_ möchtest) geht, dann die Informationen zu den Änderungen (diffs) sammelt, welche seit dem bei jedem einzelen Commit des aktuellen Branches gemacht wurden, diese in temporären Dateien speichert, den aktuellen Branch auf den gleichen Commit setzt wie den Branch, auf den Du _rebasen_ möchtest und dann alle Änderungen erneut durchführt. Die Abbildung 3-29 bildet diesen Prozess ab.

<!--Figure 3-29. Rebasing the change introduced in C3 onto C4.-->

Insert 18333fig0329.png
Abbildung 3-29. Rebasen der in C3 durchgeführten Änderungen auf C4.

<!--At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).-->

An diesem Punkt kannst Du zurück zum Master-Branch wechseln und einen fast-forward Merge durchführen (siehe Abbildung 3-30).

<!--Figure 3-30. Fast-forwarding the master branch.-->

Insert 18333fig0330.png
Abbildung 3-30. Fast-forward des Master-Branches.

<!--Now, the snapshot pointed to by C3' is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.-->

Nun ist der Schnappschuss, auf den C3' zeigt, exakt der gleiche, wie der auf den C5 in dem Merge-Beispiel gezeigt hat. Bei dieser Zusammenführung entsteht kein unterschiedliches Produkt, durch Rebasing ensteht allerdings ein sauberer Verlauf. Bei genauerer Betrachtung der Historie entpuppt sich der Rebased-Branch als linearer Verlauf – es scheint, als sei die ganze Arbeit in einer Serie entstanden, auch wenn sie in Wirklichkeit parallel stattfand.

<!--Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.-->

Du wirst das häufig anwenden um sicherzustellen, dass sich Deine Commits sauber in einen Remote-Branch integrieren – möglicherweise in einem Projekt, bei dem Du Dich beteiligen möchtest, Du jedoch nicht der Verantwortliche bist. In diesem Fall würdest Du Deine Arbeiten in einem eigenen Branch erledigen und im Anschluss Deine Änderungen auf `origin/master` rebasen. Dann hätte der Verantwortliche nämlich keinen Aufwand mit der Integration – nur einen Fast-Forward oder eine saubere Integration (= Rebase?).

<!--Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.-->

Beachte, dass der Schnappschuss, welche auf den letzten Commit zeigt, ob es nun der letzte der Rebase-Commits nach einem Rebase oder der finale Merge-Commit nach einem Merge ist, der selbe Schnappschuss ist, nur der Verlauf ist ein anderer. Rebasing wiederholt einfach die Änderungen einer Arbeitslinie auf einer anderen in der Reihenfolge, in der sie entstanden sind. Im Gegensatz hierzu nimmt Merging die beiden Endpunkte der Arbeitslinien und führt diese zusammen.

<!--### More Interesting Rebases ###-->
### Mehr interessante Rebases ###

<!--You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.-->

Du kannst Deinen Rebase auch auf einem anderen Branch als dem Rebase-Branch anwenden lassen. Nimm zum Beispiel den Verlauf in Abbildung 3-31. Du hattest einen Themen-Branch (`server`) angelegt, um ein paar serverseitige Funktionalitäten zu Deinem Projekt hinzuzufügen, und hast dann einen Commit gemacht. Dann hast Du einen weiteren Branch abgezweigt, um clientseitige Änderungen (`client`) vorzunehmen und dort ein paarmal committed. Zum Schluss hast Du wieder zu Deinem Server-Branch gewechselt und ein paar weitere Commits gebaut.

<!--Figure 3-31. A history with a topic branch off another topic branch.-->

Insert 18333fig0331.png
Abbildung 3-31. Ein Verlauf mit einem Themen-Branch basierend auf einem weiteren Themen-Branch.

<!--Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `-\-onto` option of `git rebase`:-->

Angenommen, Du entscheidest Dich, Deine clientseitigen Änderungen für einen Release in die Hauptlinie zu mergen, während Du die serverseitigen Änderungen noch zurückhalten möchtest, bis sie besser getestet wurden. Du kannst einfach die Änderungen am Client, die den Server nicht betreffen, (C8 und C9) mit der `--onto`-Option von `git rebase` erneut auf den Master-Branch anwenden:

	$ git rebase --onto master server client

<!--This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.-->

Das bedeutet einfach, “Checke den Client-Branch aus, finde die Patches heraus, die auf dem gemeinsamen Vorfahr der `client`- und `server`-Branches basieren und wende sie erneut auf dem `master`-Branch an.” Das ist ein bisschen komplex, aber das Ergebnis – wie in Abbildung 3-32 – ist richtig cool.

<!--Figure 3-32. Rebasing a topic branch off another topic branch.-->

Insert 18333fig0332.png
Abbildung 3-32. Rebasing eines Themen-Branches von einem anderen Themen-Branch.

<!--Now you can fast-forward your master branch (see Figure 3-33):-->

Jetzt kannst Du Deinen Master-Branch fast-forwarden (siehe Abbildung 3-33):

	$ git checkout master
	$ git merge client

<!--Figure 3-33. Fast-forwarding your master branch to include the client branch changes.-->

Insert 18333fig0333.png
Abbildung 3-33. Fast-forwarding Deines Master-Branches um die Client-Branch-Änderungen zu integrieren.

<!--Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):-->

Lass uns annehmen, Du entscheidest Dich, Deinen Server-Branch ebenfalls einzupflegen. Du kannst den Server-Branch auf den Master-Branch rebasen, ohne diesen vorher auschecken zu müssen, indem Du die Anweisung `git rebase [Basis-Branch] [Themen-Branch]` ausführst. Sie macht für Dich den Checkout des Themen-Branches (in diesem Fall `server`) und wiederholt ihn auf dem Basis-Branch (`master`):

	$ git rebase master server

<!--This replays your `server` work on top of your `master` work, as shown in Figure 3-34.-->

Das wiederholt Deine `server`-Arbeit auf der Basis der `master`-Arbeit, wie in Abbildung 3-34 ersichtlich.

<!--Figure 3-34. Rebasing your server branch on top of your master branch.-->

Insert 18333fig0334.png
Abbildung 3-34. Rebasing Deines Server-Branches auf Deinen Master-Branch.

<!--Then, you can fast-forward the base branch (`master`):-->

Dann kannst Du den Basis-Branch (`master`) fast-forwarden:

	$ git checkout master
	$ git merge server

<!--You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:-->

Du kannst den `client`- und `server`-Branch nun entfernen, da Du die ganze Arbeit bereits integriert wurde und sie nicht mehr benötigst. Du hinterlässt den Verlauf für den ganzen Prozess wie in Abbildung 3-35:

	$ git branch -d client
	$ git branch -d server

<!--Figure 3-35. Final commit history.-->

Insert 18333fig0335.png
Abbildung 3-35: Endgültiger Commit-Verlauf.

<!--### The Perils of Rebasing ###-->
### Die Gefahren des Rebasings ###

<!--Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:-->

Ahh, aber der ganze Spaß mit dem Rebasing kommt nicht ohne seine Schattenseiten, welche in einer einzigen Zeile zusammengefasst werden können:

<!--**Do not rebase commits that you have pushed to a public repository.**-->

**Rebase keine Commits die Du in ein öffentliches Repository hochgeladen hast.**

<!--If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.-->

Wenn Du diesem Ratschlag folgst, ist alles in Ordnung. Falls nicht, werden die Leute Dich hassen und Du wirst von Deinen Freunden und Deiner Familie verachtet.

<!--When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.-->

Wenn Du Zeug rebased, hebst Du bestehende Commits auf und erstellst stattdessen welche, die zwar ähnlich aber unterschiedlich sind. Wenn Du Commits irgendwohin hochlädst und andere ziehen sich diese herunter und nehmen sie als Grundlage für ihre Arbeit, dann müssen Deine Mitwirkenden ihre Arbeit jedesmal re-mergen, sobald Du Deine Commits mit einem `git rebase` überschreibst und verteilst. Und richtig chaotisch wird es, wenn Du versuchst, deren Arbeit in Deine Commits zu integrieren.

<!--Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.-->

Lass uns mal ein Beispiel betrachten, wie das Rebasen veröffentlichter Arbeit Probleme verursachen kann. Angenommen, Du klonst von einem zentralen Server und werkelst ein bisschen daran rum. Dein Commit-Verlauf sieht wie in Abbildung 3-36 aus.

<!--Figure 3-36. Clone a repository, and base some work on it.-->

Insert 18333fig0336.png
Abbildung 3-36. Klone ein Repository und baue etwas darauf auf.

<!--Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.-->

Ein anderer arbeitet unterdessen weiter, macht einen Merge und lädt seine Arbeit auf den zentralen Server. Du fetchst die Änderungen und mergest den neuen Remote-Branch in Deine Arbeit, sodass Dein Verlauf wie in Abbildung 3-37 aussieht.

<!--Figure 3-37. Fetch more commits, and merge them into your work.-->

Insert 18333fig0337.png
Abbildung 3-37. Fetche mehrere Commits und merge sie in Deine Arbeit.

<!--Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push -\-force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.-->

Als nächstes entscheidet sich die Person, welche den Merge hochgeladen hat, diesen rückgängig zu machen und stattdessen die Commits zu rebasen. Sie macht einen `git push --force`, um den Verlauf auf dem Server zu überschreiben. Du lädst Dir das Ganze dann mit den neuen Commits herunter.

<!--Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.-->

Insert 18333fig0338.png
Abbildung 3-38. Jemand pusht rebased Commits und verwirft damit Commits, auf denen Deine Arbeit basiert.

<!--At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).-->

Nun musst Du seine Arbeit erneut in Deine Arbeitslinie mergen, obwohl Du das bereits einmal gemacht hast. Rebasing ändert die SHA-1-Hashes der Commits, weshalb sie für Git wie neue Commits aussehen. In Wirklichkeit hast Du die C4-Arbeit bereits in Deinem Verlauf (siehe Abbildung 3-39).

<!--Figure 3-39. You merge in the same work again into a new merge commit.-->

Insert 18333fig0339.png
Abbildung 3-39. Du mergst die gleiche Arbeit nochmals in einen neuen Merge-Commit.

<!--You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.-->

Irgendwann musst Du seine Arbeit mergen, damit Du auch zukünftig mit dem anderen Entwickler zusammenarbeiten kannst. Danach wird Dein Commit-Verlauf sowohl den C4 als auch den C4'-Commit enthalten, welche zwar verschiedene SHA-1-Hashes besitzen, aber die gleichen Änderungen und die gleiche Commit-Beschreibung enthalten. Wenn Du so einen Verlauf mit `git log` betrachtest, wirst Du immer zwei Commits des gleichen Autors, zur gleichen Zeit und mit der gleichen Commit-Nachricht sehen. Was ganz schön verwirrend sein wird. Wenn Du diesen Verlauf außerdem auf den Server hochlädst, wirst Du dort alle rebasierten Commits nochmals einführen, was die Leute noch mehr verwirren kann.

<!--If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.-->

Wenn Du rebasing als einen Weg getrachtest, um aufzuräumen und mit Commits zu arbeiten, bevor Du sie hochlädst und wenn Du rebase nur auf Commits anwendest, die noch nie öffentlich zugänglich waren, dann fährst Du goldrichtig. Wenn Du rebase auf Commits anwendest, die bereits veröffentlicht wurden und Leute vielleicht schon ihre Arbeit darauf aufgebaut haben, dann kannst Du Dich auf frustrierenden Ärger gefasst machen.

<!--## Summary ##-->
## Zusammenfassung ##

<!--We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.-->

Wir haben einfaches Branching und Merging mit Git behandelt. Du solltest nun gut damit zurecht kommen, Branches zu erstellen, zwischen Branches zu wechseln und lokale Branches mit einem Merge zusammenzuführen. Außerdem solltest Du in der Lage sein, Deine Branches zu veröffentlichen, indem Du sie auf einen zentralen Server lädst, mit anderen auf öffentlichen Branches zusammenzuarbeiten und Deine Branches zu rebasen, bevor sie veröffentlicht werden.
