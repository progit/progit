<!--# Git and Other Systems #-->
# Git und andere Versionsverwaltungen #

<!--The world isn’t perfect. Usually, you can’t immediately switch every project you come in contact with to Git. Sometimes you’re stuck on a project using another VCS, and many times that system is Subversion. You’ll spend the first part of this chapter learning about `git svn`, the bidirectional Subversion gateway tool in Git.-->

Leider ist die Welt nicht perfekt. Normalerweise kannst Du nicht bei jedem Deiner Projekte sofort auf Git umsteigen. Manchmal musst Du in einem Deiner Projekte irgendeine andere Versionsverwaltung nutzen, ziemlich oft ist das Subversion. Im ersten Teil dieses Kapitels werden wir das bidirektionale Gateway zwischen Git und Subversion kennenlernen: `git svn`.

<!--At some point, you may want to convert your existing project to Git. The second part of this chapter covers how to migrate your project into Git: first from Subversion, then from Perforce, and finally via a custom import script for a nonstandard importing case.-->

Manchmal kommst Du an den Zeitpunkt, zu dem Du ein bestehendes Projekt zu Git konvertieren willst. Der zweite Teil dieses Kapitels zeigt Dir, wie Du Dein Projekt zu Git migrieren kannst. Zunächst behandeln wir Subversion, dann Perforce und zum Schluss verwenden wir ein angepasstes Import-Skript, um einen nicht standard-mäßigen Import abzudecken.

<!--## Git and Subversion ##-->
## Git und Subversion ##

<!--Currently, the majority of open source development projects and a large number of corporate projects use Subversion to manage their source code. It’s the most popular open source VCS and has been around for nearly a decade. It’s also very similar in many ways to CVS, which was the big boy of the source-control world before that.-->

Gegenwärtig verwenden die meisten Open-Source-Entwicklungsprojekte und eine große Anzahl von Projekten in Unternehmen Subversion, um ihren Quellcode zu verwalten. Es ist die populärste Open-Source-Versionsverwaltung und wird seit fast einem Jahrzehnt eingesetzt. In vielen Bereichen ähnelt es CVS, das vorher der König der Versionsverwaltungen war.

<!--One of Git’s great features is a bidirectional bridge to Subversion called `git svn`. This tool allows you to use Git as a valid client to a Subversion server, so you can use all the local features of Git and then push to a Subversion server as if you were using Subversion locally. This means you can do local branching and merging, use the staging area, use rebasing and cherry-picking, and so on, while your collaborators continue to work in their dark and ancient ways. It’s a good way to sneak Git into the corporate environment and help your fellow developers become more efficient while you lobby to get the infrastructure changed to support Git fully. The Subversion bridge is the gateway drug to the DVCS world.-->

Eines der großartigen Features von Git ist die bi-direktionale Brücke zu Subversion: `git svn`. Dieses Tool ermöglicht es, Git als ganz normalen Client für einen Subversion-Server zu benutzen, sodass Du alle lokalen Features von Git nutzen kannst und Deine Änderungen dann auf einen Subversion-Server pushen kannst, so als ob Du Subversion lokal nutzen würdest. Das bedeutet, dass Du lokale Branches anlegen kannst, mergen, die staging area, rebasing, cherry-picking etc. verwenden, während Deine Kollegen weiterhin auf ihre angestaubte Art und Weise arbeiten. Das ist eine gute Gelegenheit, um Git in einem Unternehmen einzuführen und Deinen Entwickler-Kollegen dabei zu helfen, effizienter zu werden während Du an der Unterstützung arbeitest, die Infrastruktur so umzubauen, dass Git voll unterstützt wird. Die Subversion-Bridge von Git ist quasi die Einstiegsdroge in die Welt der verteilten Versionsverwaltungssysteme (distributed version control systems, DVCS).

<!--### git svn ###-->
### git svn ###

<!--The base command in Git for all the Subversion bridging commands is `git svn`. You preface everything with that. It takes quite a few commands, so you’ll learn about the common ones while going through a few small workflows.-->

Das Haupt-Kommando in Git für alle Kommandos der Subversion Bridge ist `git svn`. Dieser Befehl wird allen anderen vorangestellt. Er kennt zahlreiche Optionen, daher werden wir jetzt die gebräuchlichsten zusammen anhand von ein paar Beispielen durchspielen.

<!--It’s important to note that when you’re using `git svn`, you’re interacting with Subversion, which is a system that is far less sophisticated than Git. Although you can easily do local branching and merging, it’s generally best to keep your history as linear as possible by rebasing your work and avoiding doing things like simultaneously interacting with a Git remote repository.-->

Es ist wichtig, dass Du im Hinterkopf behältst, dass Du mit dem Befehl `git svn` mit Subversion interagierst, einem System, das nicht ganz so fortschrittlich ist wie Git. Obwohl Du auch dort ganz einfach Branches erstellen und wieder zusammenführen kannst, ist es üblicherweise am einfachsten, wenn Du die History so geradlinig wie möglich gestaltest, indem Du ein rebase für Deine Arbeit durchfürst und es vermeidest, zum Beispiel mit einem entfernten Git-Repository zu interagieren.

<!--Don’t rewrite your history and try to push again, and don’t push to a parallel Git repository to collaborate with fellow Git developers at the same time. Subversion can have only a single linear history, and confusing it is very easy. If you’re working with a team, and some are using SVN and others are using Git, make sure everyone is using the SVN server to collaborate — doing so will make your life easier.-->

Du solltest auf keinen Fall Deine History neu schreiben und dann versuchen, die Änderungen zu publizieren. Bitte schicke Deine Änderungen auch nicht zeitgleich dazu an ein anderes Git-Repository, in dem Du mit Deinen Kollegen zusammenarbeitest, die bereits Git nutzen. Subversion kennt nur eine einzige lineare History für das gesamte Repository und da kommt man schnell mal durcheinander. Wenn Du in einem Team arbeitest, in dem manche Deiner Kollegen SVN und andere schon Git nutzen, dann solltest Du sicherstellen, dass Ihr alle einen SVN-Server zur Zusammenarbeit nutzt, das macht Dein Leben deutlich einfacher.

<!--### Setting Up ###-->
### Installation ###

<!--To demonstrate this functionality, you need a typical SVN repository that you have write access to. If you want to copy these examples, you’ll have to make a writeable copy of my test repository. In order to do that easily, you can use a tool called `svnsync` that comes with more recent versions of Subversion — it should be distributed with at least 1.4. For these tests, I created a new Subversion repository on Google code that was a partial copy of the `protobuf` project, which is a tool that encodes structured data for network transmission.-->

Um dieses Feature zu demonstrieren, brauchst Du zunächst ein typisches SVN-Repository, in dem Du Schreibzugriff hast. Wenn Du die folgenden Beispiele selbst ausprobieren willst, brauchst Du eine beschreibbare Kopie meines Test-Repositories. Das geht ganz einfach mit einem kleinen Tool namens `svnsync`, das mit den letzten Subversion-Versionen (ab Version 1.4) mitgeliefert wird. Für diese Test habe ich ein neues Subversion Repository auf Google Code angelegt, das einen Teil aus dem `protobuf`-Projekts kopiert, einem Tool, das Datenstrukturen für die Übertragung über ein Netzwerk umwandelt.

<!--To follow along, you first need to create a new local Subversion repository:-->

Zunächst einmal musst Du ein neues lokales Subversion-Repository anlegen:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

<!--Then, enable all users to change revprops — the easy way is to add a pre-revprop-change script that always exits 0:-->

Anschließend gibst Du allen Usern die Möglichkeit, die revprops zu ändern. Am einfachsten geht das, indem wir ein pre-revprop-change Skript erstellen, das immer 0 zurückgibt:

	$ cat /tmp/test-svn/hooks/pre-revprop-change
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

<!--You can now sync this project to your local machine by calling `svnsync init` with the to and from repositories.-->

Jetzt kannst Du dieses Projekt auf Deinen lokalen Rechner mit einem Aufruf von `svnsync init` synchronisieren. Als Optionen gibst Du das Ziel- und das Quell-Repository an.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/

<!--This sets up the properties to run the sync. You can then clone the code by running-->

Das richtet die Properties ein, um die Synchronisierung laufen zu lassen. Nun kannst Du den Code klonen:

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

<!--Although this operation may take only a few minutes, if you try to copy the original repository to another remote repository instead of a local one, the process will take nearly an hour, even though there are fewer than 100 commits. Subversion has to clone one revision at a time and then push it back into another repository — it’s ridiculously inefficient, but it’s the only easy way to do this.-->

Obwohl diese Operation möglicherweise nur ein paar wenige Minuten in Anspruch nimmt, wird das Kopieren des Quell-Repositories von einem entfernten Repository in ein lokales fast eine Stunde dauern, auch wenn weniger als 100 Commits getätigt wurden. Subversion muss jede Revision einzeln klonen und sie dann in ein anderes Repository schieben – das ist zwar ziemlich ineffizient, aber für uns der einfachste Weg.

<!--### Getting Started ###-->
### Die ersten Schritte (Getting Started) ###

<!--Now that you have a Subversion repository to which you have write access, you can go through a typical workflow. You’ll start with the `git svn clone` command, which imports an entire Subversion repository into a local Git repository. Remember that if you’re importing from a real hosted Subversion repository, you should replace the `file:///tmp/test-svn` here with the URL of your Subversion repository:-->

Jetzt, da wir ein beschreibbares Subversion Repository haben, können wir mit einem typischen Workflow loslegen. Du beginnst mit dem `git svn clone`Kommando, das ein komplettes Subversion-Repository in ein lokales Git-Repository importiert. Denk daran, dass Du `file:///tmp/test-svn` im folgenden Beispiel mit der URL Deines eigenen Subversion-Repositorys ersetzt, wenn Du den Import für ein real existierendes Subversion-Repository durchführen willst.

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

<!--This runs the equivalent of two commands — `git svn init` followed by `git svn fetch` — on the URL you provide. This can take a while. The test project has only about 75 commits and the codebase isn’t that big, so it takes just a few minutes. However, Git has to check out each version, one at a time, and commit it individually. For a project with hundreds or thousands of commits, this can literally take hours or even days to finish.-->

Hier werden für die angegebene URL eigentlich zwei Befehle ausgeführt, `git svn init` und anschließend `git svn fetch`. Das kann auch eine Weile dauern. Das Testprojekt hat nur etwa 75 Commits und die Codebase ist nicht so groß, daher benötigen wir nur ein paar Minuten. Da Git aber jede Version einzeln auschecken muss, kann es unter Umständen Stunden oder gar Tage dauern, bis die Ausführung des Befehls fertig ist.

<!--The `-T trunk -b branches -t tags` part tells Git that this Subversion repository follows the basic branching and tagging conventions. If you name your trunk, branches, or tags differently, you can change these options. Because this is so common, you can replace this entire part with `-s`, which means standard layout and implies all those options. The following command is equivalent:-->

Die Parameter `-T trunk -b branches -t tags` teilen Git mit, dass das Subversion-Repository den normalen Konventionen bezüglich Branching und Tagging folgt. Wenn Du Deinen Trunk, Deine Branches oder Deine Tags anders benannt hast, kannst Du diese hier anpassen. Da die Angabe aus dem Beispiel für die meisten Repositories gängig ist, kannst Du das ganze auch mit `-s` abkürzen. Diese Option steht für das Standard-Repository-Layount und umfasst die oben genannten Parameter. Der folgende Befehl ist äquivalent zum zuvor genannten:

	$ git svn clone file:///tmp/test-svn -s

<!--At this point, you should have a valid Git repository that has imported your branches and tags:-->

Jetzt solltest Du ein Git-Repository erzeugt haben, in das Deine Branches und Tags übernommen wurden:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

<!--It’s important to note how this tool namespaces your remote references differently. When you’re cloning a normal Git repository, you get all the branches on that remote server available locally as something like `origin/[branch]` - namespaced by the name of the remote. However, `git svn` assumes that you won’t have multiple remotes and saves all its references to points on the remote server with no namespacing. You can use the Git plumbing command `show-ref` to look at all your full reference names:-->

An dieser Stelle soll die wichtige Anmerkung nicht fehlen, dass dieses Tool die Namespaces Deiner entfernten Referenzen unterschiedlich behandelt. Wenn Du ein normales Git-Repository klonst, werden alle Branches auf jenem entfernten Server für Dich lokal verfügbar gemacht, zum Beispiel als `origin/[branch]`, der Namespace entspricht dem Namen des entfernten Branches. `git svn` get allerdings davon aus, dass es nicht mehrere entfernte Repositorys gibt und speichert daher seie Referenzen auf die Bereiche entfernter Server ohne Namespaces. Du kannst das Git-Kommando `show-ref` verwenden, um Dir die vollständigen Namen aller Referenzen anzeigen zu lassen:

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

<!--A normal Git repository looks more like this:-->

Ein normales Git-Repository sieht dagegen eher so aus:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

<!--You have two remote servers: one named `gitserver` with a `master` branch; and another named `origin` with two branches, `master` and `testing`.-->

Du hast zwei entfernte Server: einen, der `gitserver` heißt und einen `master`-Branch beinhaltet, und einen weiteren, der `origin` heißt und zwei Branches (`master` und `testing`) enthält.

<!--Notice how in the example of remote references imported from `git svn`, tags are added as remote branches, not as real Git tags. Your Subversion import looks like it has a remote named tags with branches under it.-->

Hast Du bemerkt, dass die entfernten Referenzen, die von `git svn` im Beispiel importiert wurden, nicht als echte Git-Tags importiert wurden, sondern als entfernte Branches? Dein Subversion-Import sieht aus als besäße er einen eigenen Remote-Bereich namens `tags` und unterhalb davon einzelne Branches.

<!--### Committing Back to Subversion ###-->
### Änderungen ins Subversion-Repository committen ###

<!--Now that you have a working repository, you can do some work on the project and push your commits back upstream, using Git effectively as a SVN client. If you edit one of the files and commit it, you have a commit that exists in Git locally that doesn’t exist on the Subversion server:-->

Mit unserem funktionierenden Repository können wir nun am Projekt arbeiten und unsere Änderungen commiten; dabei nutzen wir Git als SVN-Client. Wenn Du eine der Dateien bearbeitest und sie commitest, hast Du lokal einen Commit in Git, der auf dem Subversion-Server (noch) nicht vorhanden ist:

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

<!--Next, you need to push your change upstream. Notice how this changes the way you work with Subversion — you can do several commits offline and then push them all at once to the Subversion server. To push to a Subversion server, you run the `git svn dcommit` command:-->

Als nächsten Schritt wirst Du Deine Änderungen einchecken wollen. Dein Umgang mit Subversion wird sich dabei verändern -- Du kannst eine Vielzahl an Commits lokal durchführen und dann alle zusammen an den Subversion-Server schicken. Um Deine Änderungen auf den Subversion-Server zu pushen, verwendest Du das `git svn dcommit` Kommando:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

<!--This takes all the commits you’ve made on top of the Subversion server code, does a Subversion commit for each, and then rewrites your local Git commit to include a unique identifier. This is important because it means that all the SHA-1 checksums for your commits change. Partly for this reason, working with Git-based remote versions of your projects concurrently with a Subversion server isn’t a good idea. If you look at the last commit, you can see the new `git-svn-id` that was added:-->

Das bündelt alle Commits, die Du auf Basis des Codes im Subversion-Server durchgeführt hast und und führt für jede Änderung ein Subversion-Commit durch. Anschließend werden Deine lokalen Git-Commits angepasst und jeder von ihnen bekommt einen eindeutigen Identifier. Das bedeutet, dass alle SHA-1 Checksums Deiner Commits verändert werden. Dies ist einer der Gründe, warum das Arbeiten mit Git-basierten entfernten Versionen Deines Projekts und zeitgleich mit einem Subversion-Server keine gute Idee ist. Wenn Du Dir den letzten Commit ansiehst, wirst Du feststellen, dass eine neue `git-svn-id` hinzugefügt wurde.

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

<!--Notice that the SHA checksum that originally started with `97031e5` when you committed now begins with `938b1a5`. If you want to push to both a Git server and a Subversion server, you have to push (`dcommit`) to the Subversion server first, because that action changes your commit data.-->

Die SHA-Checksum Deines ursprünglichen Commits begann mit `97031e5`, jetzt fängt sie mit `938b1a5` an. Wenn Du zugleich auf einen Git- und einen Subversion-Server pushen willst, solltest Du zunächst an den Subversion-Server pushen (`dcommit`), da diese Aktion Deine Commit-Daten verändert.

<!--### Pulling in New Changes ###-->
### Änderungen ins lokale Repository übernehmen ###

<!--If you’re working with other developers, then at some point one of you will push, and then the other one will try to push a change that conflicts. That change will be rejected until you merge in their work. In `git svn`, it looks like this:-->

Wenn Du mit anderen Entwicklern zusammenarbeitest, wirst Du irgendwann an den Punkt gelangen an dem einer von Euch Änderungen ins Repository pusht und jemand anderes versuchen wird, ebenfalls seine Änderungen zu pushen und damit einen Konflikt erzeugt. Diese Änderung wird solange zurückgewiesen bis Du die Arbeit des anderen Entwicklers mergt. Mit `git svn` sieht das so aus:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

<!--To resolve this situation, you can run `git svn rebase`, which pulls down any changes on the server that you don’t have yet and rebases any work you have on top of what is on the server:-->

Um diese Situation zu lösen, kannst Du `git svn rebase` laufen lassen. Das zieht alle Änderungen vom Server, die Dir noch fehlen und führt ein rebase Deiner lokalen Kopie durch (auf Basis dessen, was auf dem Server vorhanden ist).

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

<!--Now, all your work is on top of what is on the Subversion server, so you can successfully `dcommit`:-->

Jetzt sind alle Deine Arbeiten auf der gleichen Ebene wie die auf dem Subversion-Server und nun kannst Du erfolgreich ein `dcommit` absetzen:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

<!--It’s important to remember that unlike Git, which requires you to merge upstream work you don’t yet have locally before you can push, `git svn` makes you do that only if the changes conflict. If someone else pushes a change to one file and then you push a change to another file, your `dcommit` will work fine:-->

Es ist wichtig, im Hinterkopf zu behalten, dass `git svn` sich an dieser Stelle anders als Git verhält. Git erwartet von Dir, dass Du upstream-Arbeiten, die Du lokal noch nicht hast, zunächst mergst, bevor Du pushen kannst. Dieses Vorgehen ist bei `git svn` nur nötig, wenn es Konflikte bei den Änderungen gibt. Wenn jemand anderes eine geänderte Datei gepusht hat und Du eine andere geänderte Datei pushst, wird Dein `dcommit` problemlos funktionieren:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

<!--This is important to remember, because the outcome is a project state that didn’t exist on either of your computers when you pushed. If the changes are incompatible but don’t conflict, you may get issues that are difficult to diagnose. This is different than using a Git server — in Git, you can fully test the state on your client system before publishing it, whereas in SVN, you can’t ever be certain that the states immediately before commit and after commit are identical.-->

Das ist darum wichtig, weil der daraus resultierende Projekt-Status auf keinem der Computer existierte als Du die Änderungen gepusht hast. Wenn die Änderungen nicht zueinander kompatibel sind aber keinen Konflikt ergeben, wirst Du Probleme bekommen, die schwer zu diagnostizieren sind. Das ist der Unterschied zu einem Git-Server — mit Git kannst Du den Zustand Deines Client-Systems komplett testen bevor Du ihn veröffentlichst, während Du bei Subversion nie sicher sein kannst, dass der Zustand direkt vor und direkt nach dem Commit identisch sind.

<!--You should also run this command to pull in changes from the Subversion server, even if you’re not ready to commit yourself. You can run `git svn fetch` to grab the new data, but `git svn rebase` does the fetch and then updates your local commits.-->

Du solltest Dieses Kommando auch ausführen um Änderungen vom Subversion-Server zu ziehen, selbst wenn Du noch nicht so weit bist, einen Commit durchzuführen. Du kannst `git svn fetch` ausführen um die neuen Daten zu besorgen aber `git svn rebase` zieht die Daten ebenfalls und aktualisiert Deine lokalen Commits.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

<!--Running `git svn rebase` every once in a while makes sure your code is always up to date. You need to be sure your working directory is clean when you run this, though. If you have local changes, you must either stash your work or temporarily commit it before running `git svn rebase` — otherwise, the command will stop if it sees that the rebase will result in a merge conflict.-->

Wenn Du `git svn rebase`ab und an ausführst, stellst Du sicher, dass Dein Code immer up-to-date ist. Du musst Dir aber sicher sein, dass Dein Arbeitsverzeichnis „sauber“ ist, bevor Du den Befehl ausführst. Wenn Du lokale Änderungen hast, musst Du Deine Arbeit vor dem `git svn rebase` entweder stashen oder temporär commiten. Anderenfalls wird die Ausführung des Befehls angehalten, wenn das Rebase in einem Merge-Konflikt enden würde.

<!--### Git Branching Issues ###-->
### Probleme beim Benutzen von Branches ###

<!--When you’ve become comfortable with a Git workflow, you’ll likely create topic branches, do work on them, and then merge them in. If you’re pushing to a Subversion server via git svn, you may want to rebase your work onto a single branch each time instead of merging branches together. The reason to prefer rebasing is that Subversion has a linear history and doesn’t deal with merges like Git does, so git svn follows only the first parent when converting the snapshots into Subversion commits.-->

Wenn Du Dich an den Git-Workflow gewöhnt hast, wirst Du höchstwahrscheinlich Zweige für Deine Arbeitspakete anlegen, mit ihnen arbeiten und sie anschließend wieder mergen. Wenn Du mit `git svn` auf einen Subversion-Server pushst, führst Du am besten eine Rebase-Operation in einen einzigen Zweig durch anstatt alle Zweige zusammenzufügen. Der Grund dafür, das Rebase zu bevorzugen, liegt darin, dass Subversion eine lineare Historie hat und mit dem Merge-Operationen nicht wie Git es tut. Daher folgt `git svn` nur dem ersten Elternelement, wenn es Snapshots in Subversion-Commits umwandelt.

<!--Suppose your history looks like the following: you created an `experiment` branch, did two commits, and then merged them back into `master`. When you `dcommit`, you see output like this:-->

Angenommen, Deine Historie sieht wie folgt aus: Du hast einen Zweig mit dem Namen `experiment` angelegt, zwei Commits durchgeführt und diese dann anschließen mit `master`zusammengeführt. Führst Du nun ein `dcommit` durch, sieht die Ausgabe wie folgt aus:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

<!--Running `dcommit` on a branch with merged history works fine, except that when you look at your Git project history, it hasn’t rewritten either of the commits you made on the `experiment` branch — instead, all those changes appear in the SVN version of the single merge commit.-->

Das Ausführen von `dcommit` in einem Zweig mit zusammengeführter Historie funktioniert wunderbar, mit der folgenden Ausnahme: wenn Du Deinen Git-Projekthistorie anschaust, wurden die Commits, die Du im `experiment`-Zweig gemacht hast, nicht neu geschrieben — stattdessen tauchen alle diese Änderungen in der SVN-Version des einzelnen Merge-Commits auf.

<!--When someone else clones that work, all they see is the merge commit with all the work squashed into it; they don’t see the commit data about where it came from or when it was committed.-->

Wenn nun jemand anderes Deine Arbeit klont, ist alles, was er oder sie sieht, der Merge-Commit mit all Deinen Änderungen insgesamt; die Daten zu den einzelnen Commits (den Urpsrung und die Zeit, wann die Commits stattfanden) sehen sie nicht.

<!--### Subversion Branching ###-->
### Subversion-Zweige ###

<!--Branching in Subversion isn’t the same as branching in Git; if you can avoid using it much, that’s probably best. However, you can create and commit to branches in Subversion using git svn.-->

Das Arbeiten mit Zweigen in Subversion ist nicht das gleiche wie mit Zweigen in Git arbeiten; es ist wohl das beste, wenn Du es vermeiden kannst, viel damit zu arbeiten. Dennoch kannst Du mit `git svn` Zweige in Subversion anlegen und Commits darin durchführen.

<!--#### Creating a New SVN Branch ####-->
#### Einen neuen SVN-Zweig anlegen ####

<!--To create a new branch in Subversion, you run `git svn branch [branchname]`:-->

Um einen neuen Zweig in Subversion anzulegen, führst Du `git svn branch [branchname]` aus:

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

<!--This does the equivalent of the `svn copy trunk branches/opera` command in Subversion and operates on the Subversion server. It’s important to note that it doesn’t check you out into that branch; if you commit at this point, that commit will go to `trunk` on the server, not `opera`.-->

Dieser Befehl macht genau das gleiche wie das `svn copy trunk branches/opera`-Kommando in Subversion und arbeitet auf dem Subversion-Server. Wichtig hierbei ist, dass Du mit Deiner Arbeit nicht automatisch in diesen Zweig wechselst: wenn Du zu diesem Zeitpunkt einen Commit durchführst, wird dieser in `trunk` auf dem Server landen, nicht im `opera`-Zweig.

<!--### Switching Active Branches ###-->
### Den aktiven Zweig wechseln ###

<!--Git figures out what branch your dcommits go to by looking for the tip of any of your Subversion branches in your history — you should have only one, and it should be the last one with a `git-svn-id` in your current branch history.-->

Git findet heraus, in welchem Zweig Deine `dcommits` abgelegt werden, indem es den tip jedes Subversion-Zweiges in Deiner Historie untersucht — Du solltest nur einen einzigen haben und es sollte der letzte mit einer `git-svn-id` in der aktuellen Historie des Zweiges sein.

<!--If you want to work on more than one branch simultaneously, you can set up local branches to `dcommit` to specific Subversion branches by starting them at the imported Subversion commit for that branch. If you want an `opera` branch that you can work on separately, you can run-->

Wenn Du gleichzeitig mit mehr als einem Zweig arbeiten willst, kannst Du lokale Zweige derart anlegen, dass ein `dcommit` für sie in bestimmte Subversion-Zweige durchgeführt wird. Dazu startest Du diese beim importierten Subversion-Commit für diesen Zweig. Wenn Du einen `opera`-Zweig haben willst, an dem Du separat arbeiten kannst, führst Du

	$ git branch opera remotes/opera

<!--Now, if you want to merge your `opera` branch into `trunk` (your `master` branch), you can do so with a normal `git merge`. But you need to provide a descriptive commit message (via `-m`), or the merge will say "Merge branch opera" instead of something useful.-->

aus. Wenn Du jetzt Deinen `opera`-Zweig in `trunk` (Deinen `master`-Zweig) zusammenführen willst , kannst Du das mit einem normalen `git merge` machen. Du solltest allerdings eine aussagekräftige Commit-Beschreibung angeben (mit `-m`) oder sie wird statt etwas Sinnvollem „Merge branch opera“ lauten.

<!--Remember that although you’re using `git merge` to do this operation, and the merge likely will be much easier than it would be in Subversion (because Git will automatically detect the appropriate merge base for you), this isn’t a normal Git merge commit. You have to push this data back to a Subversion server that can’t handle a commit that tracks more than one parent; so, after you push it up, it will look like a single commit that squashed in all the work of another branch under a single commit. After you merge one branch into another, you can’t easily go back and continue working on that branch, as you normally can in Git. The `dcommit` command that you run erases any information that says what branch was merged in, so subsequent merge-base calculations will be wrong — the dcommit makes your `git merge` result look like you ran `git merge -\-squash`. Unfortunately, there’s no good way to avoid this situation — Subversion can’t store this information, so you’ll always be crippled by its limitations while you’re using it as your server. To avoid issues, you should delete the local branch (in this case, `opera`) after you merge it into trunk.-->

Behalte im Hinterkopf, dass dieses Vorgehen kein normaler Git-Merge-Commit ist, auch wenn Du den `git merge`-Befehl verwendes und das Zusammenführen wahrscheinlich wesentlich einfacher ist als es in Subversion gewesen wäre (weil Git automatisch die passende Basis für das Zusammenführen der Zweige für Dich herausfindet=. Du musst diese Daten  zurück auf den Subversion-Server schieben, der nicht mit Commits umgehen kann, die mehr als ein Elternelement haben; all Deine Änderungen aus einem anderen Zweig werden in diesem einen Commit zusammengepresst, wenn Du die Änderungen hochschiebst. Nachdem Du einen Zweig mit einem anderen zusammengefügt hast, kannst Du nicht einfach zurückgehen und mit der Arbeit an diesem Zweig weitermachen, wie Du das normalerweise in Git machen würdest. Wenn Du das `dcommit`-Kommando ausführst, löscht es jegliche Information darüber, welcher Zweig hier hineingefügt wurde und als Folge dessen werden künftige merge-base-Berechnungen falsche sein — die `dcommit`-Operation lässt Dein `git merge`-Ergebnis so aussehen als ob Du `git merge --squash` verwendet hättest.
Unglücklicherweise gibt es kein ideales Mittel, diese Situation zu vermeiden — Subversion kann diese Information einfach nicht speichern, daher wirst Du immer unter seinen beschränkten Möglichkeiten zu leiden haben, so lange Du es als Server verwendest. Um diese Probleme zu vermeiden, solltest Du den lokalen Zweig (in unserem Beispiel `opera`) löschen, nachdem Du ihn mit dem `trunk` zusammengeführt hast.

<!--### Subversion Commands ###-->
### Subversion Befehle ###

<!--The `git svn` toolset provides a number of commands to help ease the transition to Git by providing some functionality that’s similar to what you had in Subversion. Here are a few commands that give you what Subversion used to.-->

Das `git svn`-Werkzeug bietet eine ganze Reihe von Befehlen an, die Dir helfen, den Übergang zu Git zu vereinfachen, indem sie einige Funktionen bereitstellen, die jeden ähneln, die Du bereits in Subversion kanntest. Hier sind ein paar Befehle, die Dir solche Funktionen bereitstellen wie das Subversion früher für Dich tat:

<!--#### SVN Style History ####-->
#### Historie im SVN-Stil ####

<!--If you’re used to Subversion and want to see your history in SVN output style, you can run `git svn log` to view your commit history in SVN formatting:-->

Wenn Du an Subversion gewöhnt bist und Deine Historie so sehen möchtest, wie SVN sie ausgeben würde, kannst Du `git svn log` ausführen, um Deine Commit-Historie in der SVN-Formatierung anzusehen:

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines

	updated the changelog

<!--You should know two important things about `git svn log`. First, it works offline, unlike the real `svn log` command, which asks the Subversion server for the data. Second, it only shows you commits that have been committed up to the Subversion server. Local Git commits that you haven’t dcommited don’t show up; neither do commits that people have made to the Subversion server in the meantime. It’s more like the last known state of the commits on the Subversion server.-->

Du solltest zwei wichtige Dinge über `git svn log` wissen. Erstens: es arbeitet offline, im Gegensatz zum echten `svn log`-Befehl, der den Subversion-Server nach den Daten fragt. Zweitens: es zeigt Dir nur Commits an, die auf den Subversion-Server committet wurden. Lokale Git-Commits die Du nicht mit `dcommit` bestätigt hast, werden nicht aufgeführt, genausowenig wie Commits, die andere in der Zwischenzeit auf dem Subversion-Server gemacht haben. Die Ausgabe zeigt Dir eher den letzten bekannten Zustand der Commits auf dem Subversion-Server.

<!--#### SVN Annotation ####-->
#### SVN Vermerke (SVN Annotation) ####

<!--Much as the `git svn log` command simulates the `svn log` command offline, you can get the equivalent of `svn annotate` by running `git svn blame [FILE]`. The output looks like this:-->

Genauso wie das Kommando `git svn log` den `svn log`-Befehl offline simuliert kannst Du das Pendant zu `svn annotate` mit dem Befehl `git svn blame [FILE]` ausführen. Die Ausgabe sieht so aus:

	$ git svn blame README.txt
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal
	79    schacon Committing in git-svn.
	78    schacon
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal

<!--Again, it doesn’t show commits that you did locally in Git or that have been pushed to Subversion in the meantime.-->

Auch dieser Befehl zeigt die Commits nicht an, die Du lokal getätigt hast, genauso wenig wie jene, die in der Zwischenzeit zum Subversion-Server übertragen wurden.

<!--#### SVN Server Information ####-->
#### SVN-Server-Informationen ####

<!--You can also get the same sort of information that `svn info` gives you by running `git svn info`:-->

Die selben Informationen wie bei `svn info` bekommst Du, wenn Du `git svn info` ausführst:

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

<!--This is like `blame` and `log` in that it runs offline and is up to date only as of the last time you communicated with the Subversion server.-->

Genauso wie `blame` und `log` läuft die Ausführung dieses Befehls offline ab und ist nur so aktuell wie zu dem Zeitpunkt, zu dem Du das letzte Mal mit dem Subversion-Server verbunden warst.

<!--#### Ignoring What Subversion Ignores ####-->
#### Ignorieren, was Subversion ignoriert ####

<!--If you clone a Subversion repository that has `svn:ignore` properties set anywhere, you’ll likely want to set corresponding `.gitignore` files so you don’t accidentally commit files that you shouldn’t. `git svn` has two commands to help with this issue. The first is `git svn create-ignore`, which automatically creates corresponding `.gitignore` files for you so your next commit can include them.-->

Wenn Du ein Subversion-Repository klonst, das irgendwo `svn:ignore` Eigenschaften definiert hat, wirst Du die `.gitignore`-Dateien wahrscheinlich entsprechend setzen, damit Du nicht aus Versehen Dateien committest, bei denen Du das besser nicht tun solltest. `git svn` kennt zwei Befehle, um Dir bei diesem Problem zu helfen. Der erste ist `git svn create-ignore`, der automatisch entsprechende `.gitignore`-Dateien für Dich anlegt, sodass Dein nächster Commit diese beinhalten kann.

<!--The second command is `git svn show-ignore`, which prints to stdout the lines you need to put in a `.gitignore` file so you can redirect the output into your project exclude file:-->

Der zweite Befehl ist `git svn show-ignore`, der Dir diejenigen Zeilen auf stdout ausgibt, die Du in eine `.gitignore`-Datei einfügen musst. So kannst Du die Ausgabe des Befehls direkt in die Ausnahmedatei umleiten:

	$ git svn show-ignore > .git/info/exclude

<!--That way, you don’t litter the project with `.gitignore` files. This is a good option if you’re the only Git user on a Subversion team, and your teammates don’t want `.gitignore` files in the project.-->

Auf diese Weise müllst Du Dein Projekt nicht mit `.gitignore`-Dateien zu. Das ist eine gute Wahl wenn Du der einzige Git-Benutzer in Deinem Team bist (alle anderen benutzen Subversion) und Deine Kollegen keine `.gitignore`-Dateien im Projekt haben wollen.

<!--### Git-Svn Summary ###-->
### Zusammenfassung von Git-Svn ###

<!--The `git svn` tools are useful if you’re stuck with a Subversion server for now or are otherwise in a development environment that necessitates running a Subversion server. You should consider it crippled Git, however, or you’ll hit issues in translation that may confuse you and your collaborators. To stay out of trouble, try to follow these guidelines:-->

Die `git svn`-Werkzeuge sind sehr nützlich, wenn Du derzeit (noch) an einen Subversion-Server gebunden bist oder Dich anderweitig in einer Entwicklungsumgebung befindest, die nicht auf einen Subversion-Server verzichten kann. Wie auch immer: Du solltest es als eine Art gestutztes Git ansehen. Anderenfalls läufst Du Gefahr, Dich und Deine Kollegen durcheinander zu bringen. Um dieses Kliff zu umschiffen, solltest Du folgende Richtlinien befolgen:

<!--* Keep a linear Git history that doesn’t contain merge commits made by `git merge`. Rebase any work you do outside of your mainline branch back onto it; don’t merge it in.-->
<!--* Don’t set up and collaborate on a separate Git server. Possibly have one to speed up clones for new developers, but don’t push anything to it that doesn’t have a `git-svn-id` entry. You may even want to add a `pre-receive` hook that checks each commit message for a `git-svn-id` and rejects pushes that contain commits without it.-->

* Versuch, eine „geradlinige“ Git-Historie zu führen, die keine von `git merge` durchgeführten Merges enthält. Alle Arbeiten, die Du außerhalb des Hauptzweiges durchführst, solltest Du mit `rebase` in ihn aufnehmen anstatt sie zu mit `merge` zusammenzuführen.
* Setz keinen zusätzlichen, externen Git-Server auf, mit dem Du arbeiten möchtest. Du kannst einen aufsetzen um die Klone für neue Entwickler zu beschleunigen, aber Du solltest keine Änderungen dorthin pushen, die keine `git-svn-id`-Einträge haben. Du solltest vielleicht sogar darüber nachdenken, einen `pre-receive`-Hook einzusetzen, der jede Commit-Nachricht auf eine `git-svn-id` prüft und bestimmte Pushes ablehnt, bei denen diese IDs fehlt.

<!--If you follow those guidelines, working with a Subversion server can be more bearable. However, if it’s possible to move to a real Git server, doing so can gain your team a lot more.-->

Wenn Du diese Ratschläge befolgst, werden sie die Arbeit mit dem Subversion-Server erträglich machen. Wenn es Dir irgendwie möglich ist, solltest Du trotzdem zu einem echten Git-Server umziehen, denn davon profitiert Dein Team wesentlich deutlicher.

<!--## Migrating to Git ##-->
## Zu Git umziehen ##

<!--If you have an existing codebase in another VCS but you’ve decided to start using Git, you must migrate your project one way or another. This section goes over some importers that are included with Git for common systems and then demonstrates how to develop your own custom importer.-->

Wenn Du bereits Quellcode in einer anderen Versionsverwaltung abgelegt hast, aber Dich nun entschieden hast, von nun an Git zu benutzen, musst Du Dein Projekt so oder so umziehen. Für geläufige Systeme bringt Git einige Importer mit. Anschließend lernen wir, wie Du Deinen eigenen, angepassten Importer entwickeln kann. All das wird im folgenden Abschnitt behandelt.

<!--### Importing ###-->
### Import ###

<!--You’ll learn how to import data from two of the bigger professionally used SCM systems — Subversion and Perforce — both because they make up the majority of users I hear of who are currently switching, and because high-quality tools for both systems are distributed with Git.-->

Jetzt ist es an der Zeit zu lernen, wie Du Daten aus zwei der am meisten benutzten (professionellen) SCM-Systeme importieren kannst: Subversion und Perforce. Ein Großteil der Benutzer, die gegenwärtig zu Git umziehen, arbeiten mit einem von diesen beiden Systemen. Außerdem liefert Git für beide jeweils hochprofessionelle Werkzeuge für den Import mit.

<!--### Subversion ###-->
### Subversion ###

<!--If you read the previous section about using `git svn`, you can easily use those instructions to `git svn clone` a repository; then, stop using the Subversion server, push to a new Git server, and start using that. If you want the history, you can accomplish that as quickly as you can pull the data out of the Subversion server (which may take a while).-->

Wenn Du die letzten Abschnitte über `git svn` gelesen hast, kannst Du diese Anleitungen ganz einfach benutzen um mit `git svn clone` ein Repository zu klonen. Anschließend stoppst den Subversion-Server, führst einen Push auf den neuen Git-Server durch und beginnst ihn zu benutzen. Wenn Du an die Historie ran willst, kannst Du das genausoschnell erreichen als ob Du die Daten aus dem Subversion-Server beziehen würdest (was eine Weile dauern könnte).

<!--However, the import isn’t perfect; and because it will take so long, you may as well do it right. The first problem is the author information. In Subversion, each person committing has a user on the system who is recorded in the commit information. The examples in the previous section show `schacon` in some places, such as the `blame` output and the `git svn log`. If you want to map this to better Git author data, you need a mapping from the Subversion users to the Git authors. Create a file called `users.txt` that has this mapping in a format like this:-->

Trotzdem ist der Import nicht perfekt. Und weil das ziemlich lange dauern wird, kannst Du es auch gleich richtig machen. Das erste Problem sind die Informationen über die Autoren. In Subversion besitzt jede Person, die mit dem System arbeitet, einen eigenen User-Account, der in den Commit-Informationen aufgezeichnet wird. Die Beispiele in den vorherigen Abschnitten zeigten dafür manchmal `schacon` an, wie beispielsweise bei der Ausgabe von `blame` und bei `git svn log`. Wenn Du dies näher an die Autoren-Daten von Git binden willst, musst Du Mapping-Informationen für die Subversion-Benutzer und die Git-Autoren anlegen. Erstelle eine Datei mit dem Namen `users.txt`, die folgendes Mapping-Format verwendet:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

<!--To get a list of the author names that SVN uses, you can run this:-->

Um eine Liste der Namen der Autoren bekommen, die SVN benutzen, kannst Du folgendes Kommando ausführen:

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

<!--That gives you the log output in XML format — you can look for the authors, create a unique list, and then strip out the XML. (Obviously this only works on a machine with `grep`, `sort`, and `perl` installed.) Then, redirect that output into your users.txt file so you can add the equivalent Git user data next to each entry.-->

Dies erzeugt Dir die Log-Ausgabe im XML-Format — Du suchst damit nach den Autoren, erzeugst eine Liste ohne doppelte Einträge und wirfst anschließend das überflüssige XML weg. Leite anschließend die Ausgabe in die Datei `users.txt` um, sodass Du jedem Eintrag den entsprechenden Git-Benutzer zuordnen kannst.

<!--You can provide this file to `git svn` to help it map the author data more accurately. You can also tell `git svn` not to include the metadata that Subversion normally imports, by passing `-\-no-metadata` to the `clone` or `init` command. This makes your `import` command look like this:-->

Du kannst diese Datei dann `git svn` zur Verfügung stellen um das Tool dabei zu unterstützen, die Autoreninformationen besser zu mappen. Du kannst `git svn` ebenfalls mitteilen, dass es die Metadaten nicht einbeziehen soll, die Subversion normalerweise importiert, indem Du dem `clone` oder `init` Kommando die `--no-metadata`-Option mitgibst.

	$ git svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

<!--Now you should have a nicer Subversion import in your `my_project` directory. Instead of commits that look like this-->

Jetzt solltest Du einen hübscheren Subversion-Import in Deinem `my_project`-Verzeichnis haben. Statt eines Commit, die so aussehen:

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

<!--they look like this:-->

sehen sie jetzt so aus:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

<!--Not only does the Author field look a lot better, but the `git-svn-id` is no longer there, either.-->

Nicht nur das Autoren-Feld sieht jetzt wesentlich besser aus. Auch die `git-svn-id` wird jetzt nicht mehr gebraucht.

<!--You need to do a bit of `post-import` cleanup. For one thing, you should clean up the weird references that `git svn` set up. First you’ll move the tags so they’re actual tags rather than strange remote branches, and then you’ll move the rest of the branches so they’re local.-->

Nach dem Import musst Du noch ein wenig aufräumen. Dafür solltest Du all die merkwürdigen Referenzen säubern, die `git svn` angelegt hat. Zuerst verschiebst Du die Tags, damit sie tatsächliche Git-Tags sind statt merkwürdigen Remote-Zweigen. Anschließend verschieben wir den Rest der Zweige, sodass sie lokale Zweige werden.

<!--To move the tags to be proper Git tags, run-->

Um die Tags so zu verschieben, dass sie echte Git-Tags werden, führst Du folgenden Befehl aus:

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname"; done

<!--This takes the references that were remote branches that started with `tag/` and makes them real (lightweight) tags.-->

Das nimmt die Referenzen, die vorher Remote-Zweige waren, die mit `tag/` begonnen haben und macht aus ihnen echte (leichtgewichtige) Tags.

<!--Next, move the rest of the references under `refs/remotes` to be local branches:-->

Als nächstes verschieben wir den Rest der Referenzen aus `refs/remotes` und machen lokale Zweige daraus:

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname"; done

<!--Now all the old branches are real Git branches and all the old tags are real Git tags. The last thing to do is add your new Git server as a remote and push to it. Here is an example of adding your server as a remote:-->

Jetzt sind alle alten Zweige richtige Git-Zweige geworden und alle alten Tags sind echte Git-Tags. Als letztes müssen wir den neuen Git-Server noch als entfernten Server einrichten und unsere Änderungen zu ihm pushen. Da wir alle Zweige und Tags einbeziehen wollen, kannst Du diesen Befehl verwenden:

	$ git remote add origin git@my-git-server:myrepository.git

<!--Because you want all your branches and tags to go up, you can now run this:-->

	$ git push origin --all
	$ git push origin --tags

<!--All your branches and tags should be on your new Git server in a nice, clean import.-->

All Deine Zweige und Tags sollten jetzt in Deinem neuen Git-Server in einem schicken, sauberen Import vorhanden sein.

<!--### Perforce ###-->
### Perforce ###

<!--The next system you’ll look at importing from is Perforce. A Perforce importer is also distributed with Git. If you have a version of Git earlier than 1.7.11, then the importer is only available in the `contrib` section of the source code. In that case you must get the Git source code, which you can download from git.kernel.org:-->

Das nächste System, dass wir zum Importieren anschauen werden, ist Perforce. Ein Import-Werkzeug für Perforce wird ebenfalls mit Git mitgeliefert, allerdings nur im `contrib`-Bereich des Quellcodes — es ist nicht wie `git svn` standardmäßig verfügbar. Um es auszuführen, musst Du den Git-Quellcode von `git.kernel.org` herunterladen:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

<!--In this `fast-import` directory, you should find an executable Python script named `git-p4`. You must have Python and the `p4` tool installed on your machine for this import to work. For example, you’ll import the Jam project from the Perforce Public Depot. To set up your client, you must export the P4PORT environment variable to point to the Perforce depot:-->

In diesem `fast-import` Verzeichnis wirst Du ein ausführbares Python-Skript mit dem Namen `git-p4` finden. Du musst Python sowie das `p4`-Werkzeug auf Deiner Maschine installiert haben, damit der Import klappt. Als Beispiel werden wir das Jam-Projekt aus dem Perforce Public Depot verwenden. Um den Client einzurichten, musst Du die P4PORT-Umgebungsvariable exportieren und sie auf das Perforce-Depot einstellen:

	$ export P4PORT=public.perforce.com:1666

<!--Run the `git-p4 clone` command to import the Jam project from the Perforce server, supplying the depot and project path and the path into which you want to import the project:-->

Führe den `git-p4 clone`-Befehl aus, um das Jam-Projekt aus dem Perforce-Server zu importieren. Dazu gibst Du den Depot- und Projekt-Pfad sowie den Pfad an, in den Du das Projekt importieren willst:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

<!--If you go to the `/opt/p4import` directory and run `git log`, you can see your imported work:-->

Wenn Du zum `/opt/p4import`-Verzeichnis wechselst und dann `git log` ausführst, kannst Du sehen, dass Dein Import funktioniert hat:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

<!--You can see the `git-p4` identifier in each commit. It’s fine to keep that identifier there, in case you need to reference the Perforce change number later. However, if you’d like to remove the identifier, now is the time to do so — before you start doing work on the new repository. You can use `git filter-branch` to remove the identifier strings en masse:-->

Du kannst die `git-p4`-ID bei jedem Commit sehen. Es ist OK, diese ID hier zu behalten, falls Du später noch mal einen Bezug zu der Perforce-Änderung herstellen musst. Falls Du die ID entfernen willst, ist jetzt Zeit dazu — bevor Du mit der Arbeit an dem neuen Repository beginnst. Du kannst `git filter-branch` benutzen um all die IDs zu entfernen:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

<!--If you run `git log`, you can see that all the SHA-1 checksums for the commits have changed, but the `git-p4` strings are no longer in the commit messages:-->

Wenn Du `git log` ausführst, kannst Du alle SHA1-Prüfsummen für jene Commits sehen, die sich geändert haben, aber die `git-p4`-Zeichenketten sind nicht mehr in den Commit-Nachrichten vorhanden.

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

<!--Your import is ready to push up to your new Git server.-->

Dein Import ist jetzt so weit, dass Du ihn auf den neuen Git-Server pushen kannst.

<!--### A Custom Importer ###-->
### Ein Import-Tool im Eigenbau ###

<!--If your system isn’t Subversion or Perforce, you should look for an importer online — quality importers are available for CVS, Clear Case, Visual Source Safe, even a directory of archives. If none of these tools works for you, you have a rarer tool, or you otherwise need a more custom importing process, you should use `git fast-import`. This command reads simple instructions from stdin to write specific Git data. It’s much easier to create Git objects this way than to run the raw Git commands or try to write the raw objects (see Chapter 9 for more information). This way, you can write an import script that reads the necessary information out of the system you’re importing from and prints straightforward instructions to stdout. You can then run this program and pipe its output through `git fast-import`.-->

Wenn die Versionsverwaltung, die Du verwendest, nicht Subversion oder Perforce ist, solltest Du zunächst einmal online nach einem Import-Tool suchen — gute Import-Tools sind für CVS, Clear Case, Visual Source Sage und sogar für ein Verzeichnis mit Archiven verfügbar. Wenn für Deinen Anwendungsfall keines dieser Werkzeuge passt, Du eine fast schon ausgestorbene Versionsverwaltung verwendest oder Du aus irgendeinem anderen Grund ein angepassteres Vorgehen brauchst, dann solltest Du `git fast-import` verwenden. Dieser Befehl nimmt einfache Anweisungen von `stdin` entgegen um entsprechende Git-Daten zu schreiben. Es ist viel einfacher Git-Objekte auf diese Art zu erzeugen als die blanken Git-Kommandos zu verwenden oder zu versuchen, die Roh-Objekte zu schreiben (weitere Informationen findest Du in Kapitel 9).

<!--To quickly demonstrate, you’ll write a simple importer. Suppose you work in current, you back up your project by occasionally copying the directory into a time-stamped `back_YYYY_MM_DD` backup directory, and you want to import this into Git. Your directory structure looks like this:-->

Um das kurz zu zeigen, schreiben wir einen einfachen Importer. Nehmen wir an, Du arbeitest im Verzeichnis `current` und führst ab und an ein Backup durch, indem Du dieses Verzeichnis in ein Backup-Verzeichnis kopierst und ihm einen anderen Namen mit einem Zeitstempel, z. B. `back_YYYY_MM_DD`, verpasst. Diese Struktur wollen wir jetzt in Git importieren. Dein Verzeichnis sieht also so aus:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

<!--In order to import a Git directory, you need to review how Git stores its data. As you may remember, Git is fundamentally a linked list of commit objects that point to a snapshot of content. All you have to do is tell `fast-import` what the content snapshots are, what commit data points to them, and the order they go in. Your strategy will be to go through the snapshots one at a time and create commits with the contents of each directory, linking each commit back to the previous one.-->

Damit wir ein Git-Verzeichnis importieren können, müssen wir uns zunächst noch einmal anschauen, wie Git seine Daten speichert. Wie Du Dich vielleicht erinnerst, ist Git im Grundsatz eine verlinkte Liste von Commit-Objekten die auf eine Momentaufnahme (Snapshots) des Inhalts zeigt. Jetzt musst Du nur noch `fast-import` mitteilen, was dieses Snapshots sind, welche Commit-Daten zu ihnen zeigen und die Reihenfolge, in die sie gehören. Deine Strategie wir es sein, einen nach dem anderen durch die Snapshots zu gehen und Commits mit dem Inhalt eines jeden Verzeichnisses zu erzeigen und jeden dieser Commits anschließend mit dem vorherigen zu verknüpfen.

<!--As you did in the "An Example Git Enforced Policy" section of Chapter 7, we’ll write this in Ruby, because it’s what I generally work with and it tends to be easy to read. You can write this example pretty easily in anything you’re familiar with — it just needs to print the appropriate information to stdout. And, if you are running on Windows, this means you’ll need to take special care to not introduce carriage returns at the end your lines — git fast-import is very particular about just wanting line feeds (LF) not the carriage return line feeds (CRLF) that Windows uses.-->

Wie wir das schon im Abschnitt „(...)“ in Kapitel 7 getan haben, programmieren wir diese Lösung in Ruby, weil es die Sprache ist, mit der ich normalerweise arbeite und weil sie recht einfach zu lesen ist. Du kannst das Beispiel in so ziemlich jeder Sprache schreiben, mit der Du vertraut bist — es muss nur die passenden Informationen nach `stdout` schreiben.

<!--To begin, you’ll change into the target directory and identify every subdirectory, each of which is a snapshot that you want to import as a commit. You’ll change into each subdirectory and print the commands necessary to export it. Your basic main loop looks like this:-->

Zu Beginn musst Du in das Zielverzeichnis wechseln und jedes Unterverzeichnis identifizieren, das ein Snapshot ist, den Du als Commit importieren willst. Du wirst in jedes dieser Unterverzeichnisse wechseln und den entsprechenden Befehl auszugeben um es zu exportieren. Deine Schleife wird etwa so aussehen:

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

<!--You run `print_export` inside each directory, which takes the manifest and mark of the previous snapshot and returns the manifest and mark of this one; that way, you can link them properly. "Mark" is the `fast-import` term for an identifier you give to a commit; as you create commits, you give each one a mark that you can use to link to it from other commits. So, the first thing to do in your `print_export` method is generate a mark from the directory name:-->

Du führst `print_export` für jedes Verzeichnis aus. Das nimmt das Manifest und die Markierung des letzten Snapshots entgegen und gibt das Manifest und die Markierung des aktuellen zurück; auf diese Weise kannst Du sie passend verlinken. „Mark“ ist der `fast-import`-Begriff für eine ID, die Du einem Commit gibst. Während Du Commits anlegst, verpasst Du jedem einzelnen eine Markierung, die Du benutzen kannst, um von anderen Commits zu ihm zu linken. Daher ist das erste, was Deine `print_export`-Methode macht, eine Markierung aus dem Verzeichnisnamen zu erstellen:

	mark = convert_dir_to_mark(dir)

<!--You’ll do this by creating an array of directories and using the index value as the mark, because a mark must be an integer. Your method looks like this:-->

Das erreichst Du, indem Du ein Array von Verzeichnissen anlegst und den Index-Wert als Markierung verwendest (eine Markierung muss vom Typ `integer` sein). Deine Methode sieht so aus:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

<!--Now that you have an integer representation of your commit, you need a date for the commit metadata. Because the date is expressed in the name of the directory, you’ll parse it out. The next line in your `print_export` file is-->

Jetzt hast Du eine `integer`-Repräsentation Deines Commits und brauchst nur noch ein Datum für die Commit-Metadaten. Da das Datum im Verzeichnisnamen enthalten ist, parsen wir es einfach daraus. Die nächste Zeile in Deiner `print_export`-Datei lautet

	date = convert_dir_to_date(dir)

<!--where `convert_dir_to_date` is defined as-->

wobei `convert_dir_to_date` so definiert ist:

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

<!--That returns an integer value for the date of each directory. The last piece of meta-information you need for each commit is the committer data, which you hardcode in a global variable:-->

Die Funktion gibt einen Integer-Wert für das Datum eines jeden Verzeichnisses zurück. Das letzte Stück Meta-Information, das wir noch für jeden Commit brauchen, sind die Commit-Daten des Autors, die wir in eine globale Variable packen:

	$author = 'Scott Chacon <schacon@example.com>'

<!--Now you’re ready to begin printing out the commit data for your importer. The initial information states that you’re defining a commit object and what branch it’s on, followed by the mark you’ve generated, the committer information and commit message, and then the previous commit, if any. The code looks like this:-->

Jetzt können wir damit beginnen, die Commit-Daten für den Importer auszugeben. Die ursprüngliche Information gibt an, dass Du ein Commit-Objekt definierst und zu welchem Branch es gehört, gefolgt von der Markierung, die Du angelegt hast, der Committer-Information und der Commit-Nachricht und schließlich der ID des vorhergehenden Commits, falls dieser existiert. Der Code sieht wie folgt aus:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

You hardcode the time zone (-0700) because doing so is easy. If you’re importing from another system, you must specify the time zone as an offset.
The commit message must be expressed in a special format:

	data (size)\n(contents)

The format consists of the word data, the size of the data to be read, a newline, and finally the data. Because you need to use the same format to specify the file contents later, you create a helper method, `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

<!--All that’s left is to specify the file contents for each snapshot. This is easy, because you have each one in a directory — you can print out the `deleteall` command followed by the contents of each file in the directory. Git will then record each snapshot appropriately:-->

Alles, was jetzt noch übrig bleibt, ist das Feststellen des Dateiinhalts eines jeden Snapshots. Das ist einfach, weil Du jeden davon in einem Verzeichnis hast — Du kannst das `deleteall`-Kommando ausgeben, gefolgt von den Inhalten einer jeden Datei in dem Verzeichnis. Git wird dann jeden Snapshot entsprechend aufzeichnen:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

<!--Note:	Because many systems think of their revisions as changes from one commit to another, fast-import can also take commands with each commit to specify which files have been added, removed, or modified and what the new contents are. You could calculate the differences between snapshots and provide only this data, but doing so is more complex — you may as well give Git all the data and let it figure it out. If this is better suited to your data, check the `fast-import` man page for details about how to provide your data in this manner.-->

Anmerkung:	Da viele Systeme ihre Revisionen als Änderungen von einem Commit zu einem anderen betrachten, kann `fast-import` auch mit jedem Commit Kommandos entgegennehmen, die angeben, welche Dateien geändert, entfernt oder verändert wurden und was der neue Inhalt ist. Wir könnten die Unterschiede zwischen den Snapshots berechnen und nur diese Daten bereitstellen, aber das zu tun ist komplizierter — Du kannst Git auch einfach alle Daten füttern und es kümmert sich dann darum. Wenn dieses Vorgehen eher zu Deinen Daten passt, schau Dir die `fast-import` man-Seite an, um Details darüber zu erfahren, wie diese Daten dafür bereitgestellt werden müssen.

<!--The format for listing the new file contents or specifying a modified file with the new contents is as follows:-->

Das Format, in dem die Inhalte einer neuen Datei oder in eine geänderte Datei mit ihrem neuen Inhalt angegeben werden, sieht wie folgt aus:

	M 644 inline path/to/file
	data (size)
	(file contents)

<!--Here, 644 is the mode (if you have executable files, you need to detect and specify 755 instead), and inline says you’ll list the contents immediately after this line. Your `inline_data` method looks like this:-->

In diesem Beispiel ist 644 der Datei-Modus (wenn Du ausführbare Dateien hast, wirst Du möglicherweise 755 sehen bzw. einstellen), und inline gibt an, dass Du die Inhalte direkt im Anschluss an diese Zeile aufführen wirst. Deine `inline_data`-Methode sieht so aus:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

<!--You reuse the `export_data` method you defined earlier, because it’s the same as the way you specified your commit message data.-->

Du kannst die `export_data`-Methode, die Du vorher definiert hast, wiederverwenden, da wir das auf die gleiche Weise lösen, wie wir die Daten für die Commit-Nachrichten aufbereitet haben.

<!--The last thing you need to do is to return the current mark so it can be passed to the next iteration:-->

Das letzte, das wir jetzt noch machen müssen, ist, die gegenwärtige Marke zurückzugeben, damit sie an den nächsten Durchlauf übergeben werden kann.

	return mark

<!--NOTE: If you are running on Windows you’ll need to make sure that you add one extra step. As mentioned before, Windows uses CRLF for new line characters while git fast-import expects only LF. To get around this problem and make git fast-import happy, you need to tell ruby to use LF instead of CRLF:-->

	$stdout.binmode

<!--That’s it. If you run this script, you’ll get content that looks something like this:-->

Das ist alles. Wenn Du diese Skript laufen lässt, wirst Du eine Ausgabe erhalten, die etwa wie folgt aussieht:

	$ ruby import.rb /opt/import_from
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

<!--To run the importer, pipe this output through `git fast-import` while in the Git repository you want to import into. You can create a new directory and then run `git init` in it for a starting point, and then run your script:-->

Um den Importer zu starten, leite die Ausgabe durch eine Pipe zu `git fast-import` weiter — während Du im Git Verzeichnis befindest, in das Du importieren willst. Zum Anfang kannst Du ein neues Verzeichnis anlegen, darin `git init` laufen lassen und anschließend das Skript starten:

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

<!--As you can see, when it completes successfully, it gives you a bunch of statistics about what it accomplished. In this case, you imported 18 objects total for 5 commits into 1 branch. Now, you can run `git log` to see your new history:-->

Wie Du sehen kannst, werden Dir eine Menge Statistiken über den erreichten Erfolg angezeigt. In diesem Beispiel haben wir insgesamt 18 Objekte für 5 Commits in einen Zweig importiert. Jetzt kannst Du `git log` ausführen, um die neue History einzusehen:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

<!--There you go — a nice, clean Git repository. It’s important to note that nothing is checked out — you don’t have any files in your working directory at first. To get them, you must reset your branch to where `master` is now:-->

Na also — jetzt haben wir ein schickes, sauberes Git-Repository. Dabei ist es wichtig, dass noch nichts ausgecheckt ist — zu Beginn hast Du keinerlei Dateien in Deinem Arbeitsverzeichnis. Um an sie heran zu kommen, musst Du Deinen Zweig dahin zurücksetzen, wo sich `master` gerade befindet:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

<!--You can do a lot more with the `fast-import` tool — handle different modes, binary data, multiple branches and merging, tags, progress indicators, and more. A number of examples of more complex scenarios are available in the `contrib/fast-import` directory of the Git source code; one of the better ones is the `git-p4` script I just covered.-->

Du kannst noch eine ganze Menge mehr mit dem `fast-import`-Tool anstellen — es kann verschiedene Modi behandeln, Binärdaten, mehrere Zweige sowie Merges, Tags, Fortschrittsbalken und mehr. Eine Reihe von Beispielen komplexerer Szenarios werden im `contrib/fast-import`-Verzeichnis des Git-Quellcodes bereitgestellt; eines der besseren ist das `git-p4` -Skript, das ich gerade behandelt habe.

<!--## Summary ##-->
## Zusammenfassung ##

<!--You should feel comfortable using Git with Subversion or importing nearly any existing repository into a new Git one without losing data. The next chapter will cover the raw internals of Git so you can craft every single byte, if need be.-->

Du solltest Dich jetzt ausreichend sicher fühlen im Umgang mit Git und Subversion bzw. mit dem Import von nahezu jedem existierenden Repository in ein neues Git-Repository, ohne Daten zu verlieren. Das nächste Kapitel wird die Interna von Git behandeln, damit Du jedes einzelne Byte bearbeiten kannst, falls es nötig sein sollte.
