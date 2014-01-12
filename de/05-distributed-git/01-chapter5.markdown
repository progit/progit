<!--# Distributed Git #-->
# Distribuierte Arbeit mit Git (xxx) #

<!--Now that you have a remote Git repository set up as a point for all the developers to share their code, and you’re familiar with basic Git commands in a local workflow, you’ll look at how to utilize some of the distributed workflows that Git affords you.-->

Du hast jetzt ein externes Repository aufgesetzt, sodass alle Mitglieder des Teams ihren Code zur Verfügung stellen können, und Du hast Dich mit den wesentlichen Git Befehlen für die Arbeit in einem lokalen Repository vertraut gemacht. Als nächstes werden wir uns einige Arbeitsabläufe für distribuierte Repositories ansehen, die Git Dir ermöglicht.

<!--In this chapter, you’ll see how to work with Git in a distributed environment as a contributor and an integrator. That is, you’ll learn how to contribute code successfully to a project and make it as easy on you and the project maintainer as possible, and also how to maintain a project successfully with a number of developers contributing.-->

In diesem Kapitel wirst Du lernen, wie Du in einer distribuierten Umgebung als Entwickler Code zu einem Projekt beisteuern, als für Verantwortlicher Code von anderen ins Projekt übernehmen kannst und wie Du das so gestalten kannst, dass es in einem Projekt mit einer großen Anzahl von Entwicklern für alle Beteiligten möglichst einfach ist.

<!--## Distributed Workflows ##-->
## Distribuierte Workflows ##

<!--Unlike Centralized Version Control Systems (CVCSs), the distributed nature of Git allows you to be far more flexible in how developers collaborate on projects. In centralized systems, every developer is a node working more or less equally on a central hub. In Git, however, every developer is potentially both a node and a hub — that is, every developer can both contribute code to other repositories and maintain a public repository on which others can base their work and which they can contribute to. This opens a vast range of workflow possibilities for your project and/or your team, so I’ll cover a few common paradigms that take advantage of this flexibility. I’ll go over the strengths and possible weaknesses of each design; you can choose a single one to use, or you can mix and match features from each.-->

Anders als in zentralisierten Versionskontrollsystemen (CVCS) ermöglicht die Distribuiertheit von Git eine sehr viel flexiblere Zusammenarbeit von Entwicklern. In zentralisierten Systemen fungieren alle Beteiligten als gleichwertige Netzknoten, die in mehr oder weniger der gleichen Weise am zentralen Knotenpunkt (dem zentralen Repository) arbeiten. In Git dagegen ist jeder Beteiligten selbst potentiell zentraler Knotenpunkt. D.h. jeder Entwickler kann sowohl Code zu anderen Repositories beitragen und ein öffentliches Repository zur Verfügung stellen, an dem wiederum andere mitarbeiten. Das ermöglicht eine riesige Anzahl von Möglichkeiten, Arbeitsabläufe zu gestalten, die auf das jeweilige Projekt und/oder Team perfekt zugeschnitten sind. Wir werden auf einige übliche Paradigmen, die diese Flexibilität nutzen, und deren Vor- und Nachteile eingehen. Du kannst daraus ein Modell auswählen, oder Du kannst sie miteinander kombinieren, um sie an Deine eigenen Erfordernisse anzupassen.

<!--### Centralized Workflow ###-->
### Zentralisierter Workflow ###

<!--In centralized systems, there is generally a single collaboration model—the centralized workflow. One central hub, or repository, can accept code, and everyone synchronizes their work to it. A number of developers are nodes — consumers of that hub — and synchronize to that one place (see Figure 5-1).-->

In einem zentralisierten System gibt es grob gesagt ein einziges Modell der Zusammenarbeit. Ein zentraler Knotenpunkt (oder Repository) kann Code von anderen akzeptieren und übernehmen, und alle Beteiligten synchronisieren ihre Arbeit damit. Entwickler fungieren als Knoten, die ihre Arbeit an diesem einen, zentralen Punkt synchronisieren (siehe Bild 5-1).

<!--Figure 5-1. Centralized workflow.-->

Insert 18333fig0501.png
Bild 5-1. Zentralisierter Workflow

<!--This means that if two developers clone from the hub and both make changes, the first developer to push their changes back up can do so with no problems. The second developer must merge in the first one’s work before pushing changes up, so as not to overwrite the first developer’s changes. This concept is true in Git as it is in Subversion (or any CVCS), and this model works perfectly in Git.-->

Das heißt: wenn zwei Entwickler Code aus dem zentralen Repository abholen und beide Änderungen vornehmen, dann kann der erste Entwickler seine Änderungen ohne Probleme im zentralen Repository abliefern. Der zweite Entwickler muss sie zunächst mit den Änderungen des ersten Entwicklers zusammenführen, damit er dessen Arbeit nicht überschreibt. Dieses Konzept trifft sowohl auf Git als auch auf Subversion (und jedes andere CVCS) zu, und es funktioniert in Git perfekt.

<!--If you have a small team or are already comfortable with a centralized workflow in your company or team, you can easily continue using that workflow with Git. Simply set up a single repository, and give everyone on your team push access; Git won’t let users overwrite each other. If one developer clones, makes changes, and then tries to push their changes while another developer has pushed in the meantime, the server will reject that developer’s changes. They will be told that they’re trying to push non-fast-forward changes and that they won’t be able to do so until they fetch and merge.-->
<!--This workflow is attractive to a lot of people because it’s a paradigm that many are familiar and comfortable with.-->

In einem kleinen Team oder einem Team, das mit einem zentralisierten Workflow zufrieden ist, kann man diesen Workflow ohne weiteres mit Git realisieren. Man setzt einfach ein einziges Repository auf und gibt jedem im Team Schreibzugriff („push access“). Git sorgt dann dafür, dass niemand die Arbeit von anderen überschreiben kann. Wenn ein Entwickler das Repository klont, Änderungen vornimmt und dann versucht ins zentrale Repository zu pushen, obwohl jemand anders in der Zwischenzeit Änderungen gepusht hat, dann wird der Server das zurückweisen. Dem Entwickler wird dann mitgeteilt, dass er versucht hat, sogeannte „non-fast-forward“ Änderungen hochzuladen und dass er zuvor die Änderungen des anderen Entwicklers herunterladen und mit seinen zusammenführen muss. Viele Leute mögen diesen Arbeitsablauf, weil sie mit dem Paradigma bereits vertraut sind und sich damit wohl fühlen.


<!--### Integration-Manager Workflow ###-->
### Integration-Manager Workflow ###

<!--Because Git allows you to have multiple remote repositories, it’s possible to have a workflow where each developer has write access to their own public repository and read access to everyone else’s. This scenario often includes a canonical repository that represents the "official" project. To contribute to that project, you create your own public clone of the project and push your changes to it. Then, you can send a request to the maintainer of the main project to pull in your changes. They can add your repository as a remote, test your changes locally, merge them into their branch, and push back to their repository. The process works as follow (see Figure 5-2):-->

Weil Git ermöglicht, eine Vielzahl von externen Repositories zu betreiben, ist es außerdem möglich, einen Arbeitsprozess zu gestalten, in dem jeder Entwickler Schreibzugriff auf sein eigenes öffentliches Repository hat, aber nur Lesezugriff auf die Repositories von allen anderen Beteiligten. In diesem Szenario stellt jedes Repository ein eigenes „offizielles“ Projekt dar. Um zu einem solchen distribuierten Projekt Änderungen beizusteuern, kannst Du einen eigenen, öffentlichen Klon des Projektes anlegen und Deine Änderungen dort publizieren. Anschließend kannst Du den Betreiber des Haupt-Repositories bitten, Deine Änderungen in sein Repository zu übernehmen. Er kann dann Dein Repository als ein externes Repository auf seinem Rechner einrichten, Deine Änderungen lokal testen, sie in einen seiner Branches (z.B. master) mergen und dann in sein öffentliches Repository pushen. Dieser Prozess läuft wie folgt ab (siehe Bild 5-2):

<!--1. The project maintainer pushes to their public repository.-->
<!--2. A contributor clones that repository and makes changes.-->
<!--3. The contributor pushes to their own public copy.-->
<!--4. The contributor sends the maintainer an e-mail asking them to pull changes.-->
<!--5. The maintainer adds the contributor’s repo as a remote and merges locally.-->
<!--6. The maintainer pushes merged changes to the main repository.-->

1.  Der Projekt Betreiber pusht in ein öffentliches Repository.
2.  Ein Mitarbeiter klont das Repository und nimmt Änderungen daran vor.
3.  Der Mitarbeiter pusht diese in sein eigenes öffentliches Repository.
4.  Der Mitarbeiter schickt dem Betreiber eine E-Mail und bittet darum, die Änderungen zu übernehmen.
5.  Der Betreiber richtet das Repository des Mitarbeiters als ein externes Repository ein und führt die Änderungen mit einem seiner eigenen Branches zusammen.
6.  Der Betreiber pusht die zusammengeführten Änderungen in sein öffentliches Repository.

<!--Figure 5-2. Integration-manager workflow.-->

Insert 18333fig0502.png
Bild 5-2. Integration-Manager Workflow

<!--This is a very common workflow with sites like GitHub, where it’s easy to fork a project and push your changes into your fork for everyone to see. One of the main advantages of this approach is that you can continue to work, and the maintainer of the main repository can pull in your changes at any time. Contributors don’t have to wait for the project to incorporate their changes — each party can work at their own pace.-->

Dies ist ein weit verbreiteter Arbeitsablauf wie ihn z.B. auch GitHub ermöglicht, wo man ein Projekt auf sehr einfache Weise forken und seine Änderungen in seinen eigenen Fork pushen kann, um sie anderen zur Verfügung zu stellen. Einer der Hauptvorteile dieser Vorgehensweise ist, dass man an seinem Fork jederzeit weiterarbeiten, der Betreiber des Projektes Änderungen aber auch jederzeit übernehmen kann. Mitarbieter müssen nicht darauf warten, dass der Betreiber Änderungen übernimmt – und jeder Beteiligte kann in seinem eigenen Rhythmus und Tempo arbeiten.

<!--### Dictator and Lieutenants Workflow ###-->
### Diktator und Leutnants Workflow ###

<!--This is a variant of a multiple-repository workflow. It’s generally used by huge projects with hundreds of collaborators; one famous example is the Linux kernel. Various integration managers are in charge of certain parts of the repository; they’re called lieutenants. All the lieutenants have one integration manager known as the benevolent dictator. The benevolent dictator’s repository serves as the reference repository from which all the collaborators need to pull. The process works like this (see Figure 5-3):-->

Dies ist Variante eines Workflows mit zahlreichen Repositories, die normalerweise von sehr großen Projekten mit hunderten von Mitarbeitern verwendet wird. Das bekannteste Beispiel ist wahrscheinlich der Linux Kernel. In diesem Projekt sind zahlreiche Integration Manager, die „Leutnants“, für verschiedene Bereiche des Repositories zuständig. Für sämtliche Leutnants gibt es wiederum einen Integration Manager, der als der „wohlwollende Diktator“ („benevolent dictator“) bezeichnet wird. Das Repository des wohlwollenden Diktators fungiert als das Referenz-Repository aus dem alle Beteiligten ihre eigenen Repositories aktualisieren müssen. Dieser Prozess funktioniert also wie folgt (siehe Bild 5-3)

<!--1. Regular developers work on their topic branch and rebase their work on top of master. The master branch is that of the dictator.-->
<!--2. Lieutenants merge the developers’ topic branches into their master branch.-->
<!--3. The dictator merges the lieutenants’ master branches into the dictator’s master branch.-->
<!--4. The dictator pushes their master to the reference repository so the other developers can rebase on it.-->

1.  Normale Entwickler arbeiten in ihren Arbeitsbranches (xxx) und rebasen (xxx) ihre Änderungen auf der Basis des Master Branches. Der Master Branch ist derjenige des Diktators.
2.  Die Leutnants mergen die Arbeitsbranches der Entwickler in ihre Master Branches.
3.  Der Diktator merged die Master Branches der Leutnants mit seinem eigenen Master Branch zusammen.
4.  Der Diktator pusht seinen Master Branch ins Referenz-Repository, sodass alle ihre Arbeit wiederum damit synchronisieren (rebasen) können.

<!--Figure 5-3. Benevolent dictator workflow.-->

Insert 18333fig0503.png
Bild 5-3. Wohlwollender Diktator Workflow

<!--This kind of workflow isn’t common but can be useful in very big projects or in highly hierarchical environments, as it allows the project leader (the dictator) to delegate much of the work and collect large subsets of code at multiple points before integrating them.-->

Diese Art Workflow ist nicht unbedingt weit verbreitet, aber für große Projekte oder Projekte mit strikten hierarchischen Rollen sehr nützlich, weil der Projektleiter (der Diktator) Arbeit in großem Umfang delegieren und ganze Teilbereiche von Code von verschiedenen Endpunkten zusammensammeln und integrieren kann.

<!--These are some commonly used workflows that are possible with a distributed system like Git, but you can see that many variations are possible to suit your particular real-world workflow. Now that you can (I hope) determine which workflow combination may work for you, I’ll cover some more specific examples of how to accomplish the main roles that make up the different flows.-->

Wir haben jetzt einige übliche Workflows besprochen, die in einem distribuierten System wie Git möglich sind. Natürlich kann man sie mannigfaltig abwandeln und miteinander kombinieren, um sie an ein spezielles reales Projekt und Team anzupassen. Nachdem Du jetzt hoffentlich in der Lage bist, Dir einen Workflow vorzustellen, der für Dich selbst Sinn macht, gehen wir auf einige etwas spezifischere Beispiele ein und darauf, wie man die verschiedenen Rollen umsetzen kann, die die Workflows ausmachen.

<!--## Contributing to a Project ##-->
## An einem Projekt mitarbeiten ##

<!--You know what the different workflows are, and you should have a pretty good grasp of fundamental Git usage. In this section, you’ll learn about a few common patterns for contributing to a project.-->

Du kennst jetzt einige grundlegende Workflow Varianten, und Du solltest ein gutes Verständnis im Umgang mit grundlegenden Git Befehlen haben. In diesem Abschnitt lernst Du wie Du an einem Projekt mitzuarbeiten kannst.

<!--The main difficulty with describing this process is that there are a huge number of variations on how it’s done. Because Git is very flexible, people can and do work together many ways, and it’s problematic to describe how you should contribute to a project — every project is a bit different. Some of the variables involved are active contributor size, chosen workflow, your commit access, and possibly the external contribution method.-->

Diesen Prozess zu beschreiben ist nicht leicht, weil es so viele Variationen gibt. Git ist so unheimlich flexibel, dass Leute auf vielen unterschiedlichen Wegen zusammenarbeiten können, und es ist problematisch, zu erklären, wie Du arbeiten _solltest_, weil jedes Projekt ein bisschen anders ist. Zu den Variablen gehören: die Anzahl der aktiven Mitarbeiter, der Workflow des Projektes, Deine Commit Rechte und möglicherweise eine vorgeschriebene, externe Methode, Änderungen einzureichen.

<!--The first variable is active contributor size. How many users are actively contributing code to this project, and how often? In many instances, you’ll have two or three developers with a few commits a day, or possibly less for somewhat dormant projects. For really large companies or projects, the number of developers could be in the thousands, with dozens or even hundreds of patches coming in each day. This is important because with more and more developers, you run into more issues with making sure your code applies cleanly or can be easily merged. Changes you submit may be rendered obsolete or severely broken by work that is merged in while you were working or while your changes were waiting to be approved or applied. How can you keep your code consistently up to date and your patches valid?-->

Wie viele Mitarbeiter tragen aktive Code zum Projekt bei? Und wie oft? In vielen Fällen findest Du zwei oder drei Entwickler, die täglich einige Commits anlegen, möglicherweise weniger in eher (xxx dormant xxx) Projekten. In wirklich großen Unternehmen oder Projekten können tausende Entwickler involviert sein und täglich dutzende oder sogar hunderte von Patches produzieren. Mit so vielen Mitarbeitern ist es aufwendiger, sicher zu stellen, dass Änderungen sauber mit der Codebase zusammengeführt werden können. Deine Änderungen könnten sich als überflüssig oder dysfunktional (xxx) erweisen, nachdem andere Änderungen übernommen wurden, seit Du angefangen hast, an Deinen eigenen zu arbeiten oder während sie darauf warteten, geprüft und eingefügt (xxx) zu werden.

<!--The next variable is the workflow in use for the project. Is it centralized, with each developer having equal write access to the main codeline? Does the project have a maintainer or integration manager who checks all the patches? Are all the patches peer-reviewed and approved? Are you involved in that process? Is a lieutenant system in place, and do you have to submit your work to them first?-->

Die nächste Variable ist der Workflow, der in diesem Projekt besteht. Ist es ein zentralisierter Workflow, in dem jeder Entwickler Schreibzugriff auf die Hauptentwicklungslinie hat? Hat das Projekt einen Leiter oder Integration Manager, der alle Patches prüft? Werden die Patches durch eine bestimmte Gruppe oder öffentlich, z.B. durch die Community, geprüft? Nimmst Du selbst an diesem Prozess teil? Gibt es ein Leutnant System, in dem Du Deine Arbeit zunächst an einen Leutnant übergibst?

<!--The next issue is your commit access. The workflow required in order to contribute to a project is much different if you have write access to the project than if you don’t. If you don’t have write access, how does the project prefer to accept contributed work? Does it even have a policy? How much work are you contributing at a time? How often do you contribute?-->

Eine weitere Frage ist, welche Commit Rechte Du hast. Wenn Du Schreibrechte hast, sieht der Arbeitsablauf, mit dem Du Änderungen beisteuern kannst, natürlich völlig anders aus, als wenn Du nur Leserechte hast. Und in letzterem Fall: in welcher Form werden Änderungen in diesem Projekt akzeptiert? Gibt es dafür überhaupt eine Richtlinie? Wie umfangreich sind die Änderungen, die Du jeweils beisteuerst? Und wie oft tust Du das?

<!--All these questions can affect how you contribute effectively to a project and what workflows are preferred or available to you. I’ll cover aspects of each of these in a series of use cases, moving from simple to more complex; you should be able to construct the specific workflows you need in practice from these examples.-->

Die Antworten auf diese Fragen können maßgeblich beeinflussen, wie Du effektiv an einem Projekt mitarbeiten kannst und welche Workflows Du zur Auswahl hast. Wir werden verschiedene Aspekte davon in einer Reihe von Fallbeispielen besprechen, wobei wir mit simplen Beispielen anfangen und später komplexere Szenarios besprechen. Du wirst hoffentlich in der Lage sein, aus diesen Beispielen einen eigenen Workflow zu konstruieren, der Deinen Anforderungen entspricht.

<!--### Commit Guidelines ###-->
### Commit Richtlinien ###

<!--Before you start looking at the specific use cases, here’s a quick note about commit messages. Having a good guideline for creating commits and sticking to it makes working with Git and collaborating with others a lot easier. The Git project provides a document that lays out a number of good tips for creating commits from which to submit patches — you can read it in the Git source code in the `Documentation/SubmittingPatches` file.-->

Bevor wir uns verschiedene konkrete Fallbeispiele ansehen, einige kurze Anmerkungen über Commit Meldungen. Gute Richtlinien für Commit Meldungen zu haben und sich danach zu richten, macht die Zusammenarbeit mit anderen und die Arbeit mit Git selbst sehr viel einfacher. Im Git Projekt gibt es ein Dokument mit einer Reihe nützlicher Tipps für das Anlegen von Commits, aus denen man Patches erzeugen will. Schaue im Git Quellcode nach der Datei `Documentation/SubmittingPatches`.

<!--First, you don’t want to submit any whitespace errors. Git provides an easy way to check for this — before you commit, run `git diff -\-check`, which identifies possible whitespace errors and lists them for you. Here is an example, where I’ve replaced a red terminal color with `X`s:-->

Zunächst einmal solltest Du keine Whitespace Fehler (xxx) comitten:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

<!--If you run that command before committing, you can tell if you’re about to commit whitespace issues that may annoy other developers.-->

Wenn Du diesen Befehl ausführst, bevor Du einen Commit anlegst, warnt er dich, falls in Deinen Änderungen Whitespace Probleme vorliegen, die andere Entwickler ärgern könnten.

<!--Next, try to make each commit a logically separate changeset. If you can, try to make your changes digestible — don’t code for a whole weekend on five different issues and then submit them all as one massive commit on Monday. Even if you don’t commit during the weekend, use the staging area on Monday to split your work into at least one commit per issue, with a useful message per commit. If some of the changes modify the same file, try to use `git add -\-patch` to partially stage files (covered in detail in Chapter 6). The project snapshot at the tip of the branch is identical whether you do one commit or five, as long as all the changes are added at some point, so try to make things easier on your fellow developers when they have to review your changes. This approach also makes it easier to pull out or revert one of the changesets if you need to later. Chapter 6 describes a number of useful Git tricks for rewriting history and interactively staging files — use these tools to help craft a clean and understandable history.-->

Versuche außerdem, Deine Änderungen in logisch zusammenhängende Einheiten zu gruppieren. Wenn möglich, versuche Commits möglichst leichtverständlich (xxx) zu gestalten: arbeite nicht ein ganzes Wochenende lang an fünf verschiedenen Problemen und committe sie dann am Montag als einen einzigen, riesigen Commit. Selbst wenn Du am Wochenende keine Commits angelegt hast, verwende die Staging Area, um Deine Änderungen auf mehrere Commits aufzuteilen, jeweils mit einer verständlichen Meldung. Wenn einige Änderungen dieselbe Datei betreffen, probiere sie mit `git add --patch` nur teilweise zur Staging Area hinzuzufügen (das werden wir in Kapitel 6 noch im Detail besprechen). Der Projekt Snapshot wird am Ende derselbe sein, ob Du nun einen einzigen großen oder mehrere kleine Commits anlegst, daher versuche, es anderen Entwickler zu erleichtern machen, Deine Änderungen zu verstehen. Auf diese Weise machst Du es auch einfacher, einzelne Änderungen später herauszunehmen oder rückgängig zu machen. Kapitel 6 beschreibt eine Reihe nützlicher Git Tricks, die hilfreich sind, um die Historie umzuschreiben oder interaktiv Dateien zur Staging Area hinzuzufügen. Verwende diese Hilfsmittel, um eine sauber und leicht verständliche Historie von Änderungen aufzubauen.

<!--The last thing to keep in mind is the commit message. Getting in the habit of creating quality commit messages makes using and collaborating with Git a lot easier. As a general rule, your messages should start with a single line that’s no more than about 50 characters and that describes the changeset concisely, followed by a blank line, followed by a more detailed explanation. The Git project requires that the more detailed explanation include your motivation for the change and contrast its implementation with previous behavior — this is a good guideline to follow. It’s also a good idea to use the imperative present tense in these messages. In other words, use commands. Instead of "I added tests for" or "Adding tests for," use "Add tests for."-->
<!--Here is a template originally written by Tim Pope at tpope.net:-->

Ein weitere Sache, der Du ein bisschen Aufmerksamkeit schenken solltest, ist die Commit Meldung selbst. Wenn man sich angewöhnt, aussagekräftige und hochwertige Commit Meldungen zu schreiben, macht man sich selbst und anderen das Leben erheblich einfacher. Im allgemeinen sollte eine Commit Meldung mit einer einzelnen Zeile anfangen, die nicht länger als 50 Zeichen sein sollte. Dann sollte eine leere Zeile folgen und schließlich eine ausführlichere Beschreibung der Änderungen.

	Short (50 chars or less) summary of changes

	More detailed explanatory text, if necessary.  Wrap it to about 72
	characters or so.  In some contexts, the first line is treated as the
	subject of an email and the rest of the text as the body.  The blank
	line separating the summary from the body is critical (unless you omit
	the body entirely); tools like rebase can get confused if you run the
	two together.

	Further paragraphs come after blank lines.

	 - Bullet points are okay, too

	 - Typically a hyphen or asterisk is used for the bullet, preceded by a
	   single space, with blank lines in between, but conventions vary here

<!--If all your commit messages look like this, things will be a lot easier for you and the developers you work with. The Git project has well-formatted commit messages — I encourage you to run `git log -\-no-merges` there to see what a nicely formatted project-commit history looks like.-->

Wenn Du Deine Commit Meldungen in dieser Weise formatierst, kannst Du Dir und anderen eine Menge Ärger ersparen. Das Git Projekt selbst hat wohl-formatierte Commit Meldungen. Wir empfehlen, einmal `git log --no-merges` in diesem Repository auszuführen, um einen Eindruck zu erhalten, wie eine gute Commit History eines Projektes aussehen kann.

<!--In the following examples, and throughout most of this book, for the sake of brevity I don’t format messages nicely like this; instead, I use the `-m` option to `git commit`. Do as I say, not as I do.-->

In den folgenden Beispielen hier und fast überall in diesem Buch verwende ich keine derartigen, schön formatierten Meldungen. Stattdessen verwende ich die `-m` Option zusammen mit `git commit`. Also folge meinen Worten, nicht meinem Beispiel.

<!--### Private Small Team ###-->
### Kleine Teams ###

<!--The simplest setup you’re likely to encounter is a private project with one or two other developers. By private, I mean closed source — not read-accessible to the outside world. You and the other developers all have push access to the repository.-->

Das einfachste Setup, mit dem Du zu tun haben wirst, ist ein privates Projekt mit ein oder zwei Entwicklern. Mit „privat“ meine ich, dass es „closed source“, d.h. nicht lesbar für Dritte ist. Alle beteiligten Entwickler haben Schreibzugriff auf das Repository.

<!--In this environment, you can follow a workflow similar to what you might do when using Subversion or another centralized system. You still get the advantages of things like offline committing and vastly simpler branching and merging, but the workflow can be very similar; the main difference is that merges happen client-side rather than on the server at commit time.-->
<!--Let’s see what it might look like when two developers start to work together with a shared repository. The first developer, John, clones the repository, makes a change, and commits locally. (I’m replacing the protocol messages with `...` in these examples to shorten them somewhat.)-->

In einer solchen Umgebung kann man einen ähnlichen Workflow verwenden, wie für Subversion oder ein anderes zentralisiertes System. Du hast dann immer noch Vorteile wie, dass Du offline committen kannst und dass Branching und Merging so unglaublich einfach ist. Der Hauptunterschied ist, dass Merges auf der Client Seite stattfinden und nicht, wenn man committet, auf dem Server. Schauen wir uns an, wie die Arbeit von zwei Entwicklern in einem gemeinsamen Repository abläuft. Der erste Entwickler, John, klont das Repository, nimmt eine Änderung vor und comittet auf seinem Rechner. (Wir kürzen die Beispiele etwas ab und ersetzen die hierfür irrelevanten Protokoll Meldungen mit `xxx`.)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

<!--The second developer, Jessica, does the same thing — clones the repository and commits a change:-->

Der zweite Entwickler, Jessica, tut das gleiche. Sie klont das Repository und committet eine Änderung:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

<!--Now, Jessica pushes her work up to the server:-->

Jetzt lädt Jessica ihre Arbeit mit `git push` auf den Server:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

<!--John tries to push his change up, too:-->

John versucht, das selbe zu tun:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

<!--John isn’t allowed to push because Jessica has pushed in the meantime. This is especially important to understand if you’re used to Subversion, because you’ll notice that the two developers didn’t edit the same file. Although Subversion automatically does such a merge on the server if different files are edited, in Git you must merge the commits locally. John has to fetch Jessica’s changes and merge them in before he will be allowed to push:-->

John darf seine Änderung nicht pushen, weil Jessica in der Zwischenzeit gepushed hat. Dies ist ein Unterschied zu Subversion: wie Du siehst, haben die beiden Entwickler nicht dieselbe Datei bearbeitet. Während Subversion automatisch merged, wenn lediglich verschiedene Dateien bearbeitet wurden, muss man Commits in Git lokal mergen. John muss also Jessicas Änderungen herunterladen und mergen, bevor er dann selbst pushen darf:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

<!--At this point, John’s local repository looks something like Figure 5-4.-->

Zu diesem Zeitpunkt sieht Johns lokales Repository jetzt aus wie in Bild 5-4.

<!--Figure 5-4. John’s initial repository.-->

Insert 18333fig0504.png
Bild 5-4. Johns ursprüngliches Repository

<!--John has a reference to the changes Jessica pushed up, but he has to merge them into his own work before he is allowed to push:-->

John hat eine Referenz auf Jessicas Änderungen, aber er muss sie mit seinen eigenen Änderungen mergen, bevor er auf den Server pushen darf:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

<!--The merge goes smoothly — John’s commit history now looks like Figure 5-5.-->

Der Merge verläuft glatt: Johns Commit Historie sieht jetzt aus wie in Bild 5-5.

<!--Figure 5-5. John’s repository after merging origin/master.-->

Insert 18333fig0505.png
Johns Repository nach dem Merge mit origin/master

<!--Now, John can test his code to make sure it still works properly, and then he can push his new merged work up to the server:-->

John sollte seinen Code jetzt testen, um sicher zu stellen, dass alles weiterhin funktioniert. Dann kann er seine Arbeit auf den Server pushen:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

<!--Finally, John’s commit history looks like Figure 5-6.-->

Johns Commit Historie sieht schließlich aus wie in Bild 5-6.

<!--Figure 5-6. John’s history after pushing to the origin server.-->

Insert 18333fig0506.png
Johns Commit Historie nach dem pushen auf den origin Server

<!--In the meantime, Jessica has been working on a topic branch. She’s created a topic branch called `issue54` and done three commits on that branch. She hasn’t fetched John’s changes yet, so her commit history looks like Figure 5-7.-->

In der Zwischenzeit hat Jessica auf einem Topic Branch (xxx) gearbeitet. Sie hat einen Topic Branch mit dem Namen `issue54` und darin drei Commits angelegt. Sie hat Johns Änderungen bisher noch nicht herunter geladen, sodass ihre Commit Historie jetzt so aussieht wie in Bild 5-7.

<!--Figure 5-7. Jessica’s initial commit history.-->

Insert 18333fig0507.png
Bild 5-7. Jessicas ursprüngliche Commit Historie

<!--Jessica wants to sync up with John, so she fetches:-->

Jessica will ihre Arbeit jetzt mit John synchronisieren. Also lädt sie seine Änderungen herunter:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

<!--That pulls down the work John has pushed up in the meantime. Jessica’s history now looks like Figure 5-8.-->

Das lädt die Änderungen, die John in der Zwischenzeit hochgeladen hat. Jessicas Historie entspricht jetzt Bild 5-8.

<!--Figure 5-8. Jessica’s history after fetching John’s changes.-->

Insert 18333fig0508.png
Bild 5-8. Jessicas Historie nachdem sie Johns Änderungen geladen hat

<!--Jessica thinks her topic branch is ready, but she wants to know what she has to merge her work into so that she can push. She runs `git log` to find out:-->

Jessica hat die Arbeit in ihrem Topic Branch abgeschlossen, aber sie will wissen, welche neuen Änderungen es gibt, mit denen sie ihre eigenen mergen muss.

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

<!--Now, Jessica can merge her topic work into her `master` branch, merge John’s work (`origin/master`) into her `master` branch, and then push back to the server again. First, she switches back to her `master` branch to integrate all this work:-->

Jetzt kann Jessica zunächst ihren Topic Branch `issue54` in ihren `master` Branch mergen, dann Johns Änderungen aus `origin/master` in ihren `master` Branch mergen und schließlich das Resultat auf den `origin` Server pushen. Als erstes wechselt sie zurück auf ihren `master` Branch:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

<!--She can merge either `origin/master` or `issue54` first — they’re both upstream, so the order doesn’t matter. The end snapshot should be identical no matter which order she chooses; only the history will be slightly different. She chooses to merge in `issue54` first:-->

Sie kann jetzt entweder `origin/master` oder `issue54` zuerst mergen – sie sind beide „upstream“ (xxx). Der resultierende Snapshot wäre identisch, egal in welcher Reihenfolge sie beide Branches in ihren `master` Branch merged, lediglich die Historie würde natürlich minimal anders aussehen. Jessica entscheidet sich, `issue54` zuerst zu mergen:

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

<!--No problems occur; as you can see, it was a simple fast-forward. Now Jessica merges in John’s work (`origin/master`):-->

Das ging glatt, wie Du siehst, war es ein einfacher „fast-forward“ Merge. Als nächstes merged Jessica Johns Änderungen aus `origin/master`:

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

<!--Everything merges cleanly, and Jessica’s history looks like Figure 5-9.-->

Auch hier treten keine Konflikte auf. Jessicas Historie sieht jetzt wie folgt aus (Bild 5-9).

<!--Figure 5-9. Jessica’s history after merging John’s changes.-->

Insert 18333fig0509.png
Bild 5-9. Jessicas Historie nach dem Merge mit Johns Änderungen

<!--Now `origin/master` is reachable from Jessica’s `master` branch, so she should be able to successfully push (assuming John hasn’t pushed again in the meantime):-->

`origin/master` ist jetzt in Jessicas `master` Branch enthalten (xxx reachable xxx), sodass sie in der Lage sein sollte, auf den `origin` Server zu pushen (vorausgesetzt, John hat zwischenzeitlich nicht gepusht):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

<!--Each developer has committed a few times and merged each other’s work successfully; see Figure 5-10.-->

Beide Entwickler haben jetzt einige Male committed und die Arbeit des jeweils anderen erfolgreich mit ihrer eigenen zusammengeführt.

<!--Figure 5-10. Jessica’s history after pushing all changes back to the server.-->

Insert 18333fig0510.png
Bild 5-10. Jessicas Historie nachdem sie sämtliche Änderungen auf den Server gepusht hat

<!--That is one of the simplest workflows. You work for a while, generally in a topic branch, and merge into your `master` branch when it’s ready to be integrated. When you want to share that work, you merge it into your own `master` branch, then fetch and merge `origin/master` if it has changed, and finally push to the `master` branch on the server. The general sequence is something like that shown in Figure 5-11.-->

Dies ist eine der simpelsten Workflow Varianten. Du arbeitest eine Weile, normalerweise in einem Topic Branch, und mergst in Deinen `master` Branch, wenn Du fertig bist. Wenn Du Deine Änderungen anderen zur Verfügung stellen willst, holst Du den aktuellen `origin/master` Branch, mergst Deinen `master` Branch damit und pushst das ganze zurück auf den `origin` Server. Der Ablauf sieht in etwa wie folgt aus (Bild 5-11).

<!--Figure 5-11. General sequence of events for a simple multiple-developer Git workflow.-->

Insert 18333fig0511.png
Bild 5-11. Ablauf eines einfachen Workflows für mehrere Entwickler

<!--### Private Managed Team ###-->
### Teil-Teams mit Integration Manager ###

<!--In this next scenario, you’ll look at contributor roles in a larger private group. You’ll learn how to work in an environment where small groups collaborate on features and then those team-based contributions are integrated by another party.-->

Im folgenden Szenario sehen wir uns die Rollen von Mitarbeitern in einem größeren, nicht öffentlich arbeitenden Team an. Du wirst sehen, wie man in einer Umgebung arbeiten kann, in der kleine Gruppen (z.B. an einzelnen Features) zusammenarbeiten und ihre Ergebnisse dann von einer weiteren Gruppe in die Hauptentwicklungslinie integriert werden.

<!--Let’s say that John and Jessica are working together on one feature, while Jessica and Josie are working on a second. In this case, the company is using a type of integration-manager workflow where the work of the individual groups is integrated only by certain engineers, and the `master` branch of the main repo can be updated only by those engineers. In this scenario, all work is done in team-based branches and pulled together by the integrators later.-->

Sagen wir John und Jessica arbeiten gemeinsam an einem Feature, während Jessica und Josie an einem anderen arbeiten. Das Unternehmen verwendet einen Integration-Manager Workflow, in dem die Arbeit der verschiedenen Gruppen von anderen Mitarbeitern zentral integriert werden – und der `master` Branch nur von diesen letzteren geschrieben werden kann. In diesem Szenario wird sämtliche Arbeit von den Teams in Branches erledigt und dann von den Integration-Manangern zusammengeführt.

<!--Let’s follow Jessica’s workflow as she works on her two features, collaborating in parallel with two different developers in this environment. Assuming she already has her repository cloned, she decides to work on `featureA` first. She creates a new branch for the feature and does some work on it there:-->

Schauen wir uns Jessicas Workflow an, während sie mit jeweils verschiedenen Entwicklern parallel an zwei Features arbeitet. Nehmen wir an, sie hat das Repository bereits geklont und will zuerst an `featureA` arbeiten. Sie legt einen neuen Branch für das Feature an und fängt an, daran zu arbeiten:

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

<!--At this point, she needs to share her work with John, so she pushes her `featureA` branch commits up to the server. Jessica doesn’t have push access to the `master` branch — only the integrators do — so she has to push to another branch in order to collaborate with John:-->

Jetzt will sie ihre Arbeit John zur Verfügung stellen, der am gleichen Feature arbeiten will, und pusht dazu ihre Commits in ihrem `featureA` Branch auf den Server. Jessica hat keinen Schreibzugriff auf den `master` Branch – den haben nur die Integration Manager – also pusht sie ihren Feature Branch, der nur der Zusammenarbeit mit John dient:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

<!--Jessica e-mails John to tell him that she’s pushed some work into a branch named `featureA` and he can look at it now. While she waits for feedback from John, Jessica decides to start working on `featureB` with Josie. To begin, she starts a new feature branch, basing it off the server’s `master` branch:-->

Jessica schickt John eine E-Mail und lässt ihn wissen, dass sie ihre Arbeit in einen Branch `featureA` hochgeladen hat. Während sie jetzt auf Feedback von John wartet, kann Jessica anfangen, an `featureB` zuarbeiten – diesmal gemeinsam mit Josie. Also legt sie einen neuen Feature Branch an, der auf dem gegenwärtigen `master` Branch des `origin` Servers basiert:

	# Jessica's Machine
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

<!--Now, Jessica makes a couple of commits on the `featureB` branch:-->

Jetzt legt Jessica eine Reihe von Commits im `featureB` Branch an:

	$ vim lib/simplegit.rb
	$ git commit -am 'made the ls-tree function recursive'
	[featureB e5b0fdc] made the ls-tree function recursive
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'add ls-files'
	[featureB 8512791] add ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

<!--Jessica’s repository looks like Figure 5-12.-->

Jessicas Repository entspricht jetzt Bild 5-12.

<!--Figure 5-12. Jessica’s initial commit history.-->

Insert 18333fig0512.png
Bild 5-12. Jessicas ursprüngliche Commit Historie

<!--She’s ready to push up her work, but gets an e-mail from Josie that a branch with some initial work on it was already pushed to the server as `featureBee`. Jessica first needs to merge those changes in with her own before she can push to the server. She can then fetch Josie’s changes down with `git fetch`:-->

Jessica könnte ihre Arbeit jetzt hochladen, aber sie hat eine E-Mail von Josie erhalten, dass sie bereits einen Feature Branch `featureBee` für dasselbe Feature auf dem Server angelegt hat. Jessica muss also erst ihre eigenen Änderungen mit diesem Branch mergen und dann dorthin pushen. Sie lädt also Josies Änderungen mit `git fetch` herunter:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

<!--Jessica can now merge this into the work she did with `git merge`:-->

Jessica kann ihre eigene Arbeit jetzt mit diesen Änderungen zusammenführen:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

<!--There is a bit of a problem — she needs to push the merged work in her `featureB` branch to the `featureBee` branch on the server. She can do so by specifying the local branch followed by a colon (:) followed by the remote branch to the `git push` command:-->

Es gibt jetzt ein kleines Problem. Jessica muss die zusammengeführten Änderungen in ihrem `featureB` Branch in den `featureBee` Branch auf dem Server pushen. Das kann sie tun, indem sie sowohl den Namen ihres lokalen Branches als auch des externen Branches angibt, und zwar mit einem Doppelpunkt getrennt:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

<!--This is called a _refspec_. See Chapter 9 for a more detailed discussion of Git refspecs and different things you can do with them.-->

Das nennt man eine _Refspec_. In Kapitel 9 gehen wir detailliert auf Git Refspecs ein und darauf, was man noch mit ihnen machen kann.

<!--Next, John e-mails Jessica to say he’s pushed some changes to the `featureA` branch and ask her to verify them. She runs a `git fetch` to pull down those changes:-->

Als nächstes schickt John Jessica eine E-Mail. Er schreibt, dass er einige Änderungen in den `featureA` Branch gepusht hat, und bittet sie, diese zu prüfen. Sie führt also `git fetch` aus, um die Änderungen herunter zu laden:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

<!--Then, she can see what has been changed with `git log`:-->

Danach kann sie die neuen Änderungen mit `git log` auflisten:

	$ git log origin/featureA ^featureA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    changed log output to 30 from 25

<!--Finally, she merges John’s work into her own `featureA` branch:-->

Schließlich aktualisiert sie ihren eigenen `featureA` Branch mit Johns Änderungen:

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

<!--Jessica wants to tweak something, so she commits again and then pushes this back up to the server:-->

Jessica will eine kleine Änderung vornehmen. Also comittet sie und pusht den neuen Commit auf den Server:

	$ git commit -am 'small tweak'
	[featureA 774b3ed] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..774b3ed  featureA -> featureA

<!--Jessica’s commit history now looks something like Figure 5-13.-->

Jessicas Commit Historie sieht jetzt wie folgt aus (Bild 5-13).

<!--Figure 5-13. Jessica’s history after committing on a feature branch.-->

Insert 18333fig0513.png
Bild 5-13. Jessicas Historie mit dem neuen Commit im Feature Branch

<!--Jessica, Josie, and John inform the integrators that the `featureA` and `featureBee` branches on the server are ready for integration into the mainline. After they integrate these branches into the mainline, a fetch will bring down the new merge commits, making the commit history look like Figure 5-14.-->

Jessica, Josie und John informieren jetzt ihre Integration Manager, dass die Ändeurngen in den Branches `featureA` und `featureBee` fertig sind und in die Hauptlinie in `master` übernommen werden können. Nachdem das geschehen ist, wird `git fetch` die neuen Merge Commits herunter laden und die Commit Historie in etwa wie folgt aussehen (Bild 5-14):

<!--Figure 5-14. Jessica’s history after merging both her topic branches.-->

Insert 18333fig0514.png
Bild 5-14. Jessicas Historie nachdem beide Feature Branches gemerged wurden

<!--Many groups switch to Git because of this ability to have multiple teams working in parallel, merging the different lines of work late in the process. The ability of smaller subgroups of a team to collaborate via remote branches without necessarily having to involve or impede the entire team is a huge benefit of Git. The sequence for the workflow you saw here is something like Figure 5-15.-->

Viele Teams wechseln zu Git, weil es auf einfache Weise ermöglicht, verschiedene Teams parallel an verschiedenen Entwicklungslinien zu arbeiten, die erst später im Prozess integriert werden. Ein riesiger Vorteil von Git besteht darin, dass man in kleinen Teilgruppen über externe Branches zusammenarbeiten kann, ohne dass dazu notwendig wäre, das gesamte Team zu involvieren und möglicherweise aufzuhalten. Der Ablauf dieser Art von Workflow kann wie folgt dargestellt werden (Bild 5-15).

<!--Figure 5-15. Basic sequence of this managed-team workflow.-->

Insert 18333fig0515.png
Bild 5-15. Workflow mit Teil-Teams und Integration Manager

<!--### Public Small Project ###-->
### Kleine, öffentliche Projekte ###

<!--Contributing to public projects is a bit different. Because you don’t have the permissions to directly update branches on the project, you have to get the work to the maintainers some other way. This first example describes contributing via forking on Git hosts that support easy forking. The repo.or.cz and GitHub hosting sites both support this, and many project maintainers expect this style of contribution. The next section deals with projects that prefer to accept contributed patches via e-mail.-->

An öffentlichen Projekten mitzuarbeiten funktioniert ein bisschen anders. Weil man normalerweise keinen Schreibzugriff auf das öffentliche Repository des Projektes hat, muss man mit den Betreibern in anderer Form zusammenarbeiten. Unser erstes Beispiel beschreibt, wie man zu Projekten auf Git Hosts beitragen kann, die es erlauben Forks eines Projektes anzulegen. Z.B. unterstützen die Git Hosting Seiten repo.or.cz und GitHub dieses Feature – und viele Projekt Betreiber akzeptieren Änderungen in dieser Form. Das nächste Beispiel geht dann darauf ein, wie man mit Projekten arbeiten kann, die es bevorzugen, Patches per E-Mail zu erhalten (xxx oder Ticket Tracker, wie z.B. Rails xxx).

<!--First, you’ll probably want to clone the main repository, create a topic branch for the patch or patch series you’re planning to contribute, and do your work there. The sequence looks basically like this:-->

Zunächst wirst vermutlich das Hauptrepository klonen, einen Topic Branch für Deinen Patch anlegen und dann darin arbeiten. Der Prozess sieht dann in etwa so aus:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

<!--You may want to use `rebase -i` to squash your work down to a single commit, or rearrange the work in the commits to make the patch easier for the maintainer to review — see Chapter 6 for more information about interactive rebasing.-->

Es ist wahrscheinlich sinnvoll, `git rebase -i` zu verwenden, um die verschiedenen Commits zu einem einzigen zusammen zu packen („squash“, quetschen) oder um sie in anderer Weise neu zu arrangieren, sodass es für die Projekt Betreiber leichter ist, die Änderungen nach zu vollziehen. In Kapitel 6 gehen wir ausführlicher auf das interaktive `rebase -i` ein.

<!--When your branch work is finished and you’re ready to contribute it back to the maintainers, go to the original project page and click the "Fork" button, creating your own writable fork of the project. You then need to add in this new repository URL as a second remote, in this case named `myfork`:-->

Wenn Dein Branch fertig ist und Du Deine Arbeit den Projekt Betreibern zur Verfügung stellen willst, gehst Du auf die Projekt Seite und klickst auf den „Fork“ Button. Dadurch legst Du Deinen eigenen Fork des Projektes an, in den Du dann schreiben kannst. Die Repository URL dieses Forks musst Du dann als ein zweites, externes Repository („remote“) einrichten. In unserem Beispiel verwenden wir den Namen `myfork`:

	$ git remote add myfork (url)

<!--You need to push your work up to it. It’s easiest to push the remote branch you’re working on up to your repository, rather than merging into your master branch and pushing that up. The reason is that if the work isn’t accepted or is cherry picked, you don’t have to rewind your master branch. If the maintainers merge, rebase, or cherry-pick your work, you’ll eventually get it back via pulling from their repository anyhow:-->

Jetzt kannst Du Deine Änderungen dorthin hochladen. Am besten tust Du das, indem Du Deinen Topic Branch hochlädst (statt ihn in Deinen `master` Branch zu mergen und den dann hochzuladen). Dies deshalb, weil Du, wenn Deine Änderungen nicht akzeptiert werden, Deinen eigenen `master` Branch nicht zurücksetzen musst. Wenn die Projekt Betreiber Deine Änderungen mergen, rebasen oder cherry-picken, landen sie schließlich ohnehin in Deinem `master` Branch.

	$ git push myfork featureA

<!--When your work has been pushed up to your fork, you need to notify the maintainer. This is often called a pull request, and you can either generate it via the website — GitHub has a "pull request" button that automatically messages the maintainer — or run the `git request-pull` command and e-mail the output to the project maintainer manually.-->

Nachdem Du Deine Arbeit in Deinen Fork hochgeladen hast, musst Du die Projekt Betreiber benachrichtigen. Dies wird oft als „pull request“ bezeichnet. Du kannst ihn entweder direkt über die Webseite schicken (GitHub hat dazu einen „pull request“ Button) oder den Git Befehl `git request-pull` verwenden und manuell eine E-Mail an die Projekt Betreiber schicken.

<!--The `request-pull` command takes the base branch into which you want your topic branch pulled and the Git repository URL you want them to pull from, and outputs a summary of all the changes you’re asking to be pulled in. For instance, if Jessica wants to send John a pull request, and she’s done two commits on the topic branch she just pushed up, she can run this:-->

Der `request-pull` Befehl vergleicht denjenigen Branch, für den Deine Änderungen gedacht sind, mit Deinem Topic Branch und gibt eine Übersicht der Änderungen aus. Wenn Jessica zwei Änderungen in einem Topic Branch hat und nun John einen pull request schicken will, kann sie folgendes tun:

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

<!--The output can be sent to the maintainer—it tells them where the work was branched from, summarizes the commits, and tells where to pull this work from.-->

Die Ausgabe kann an den Projekt Betreiber geschickt werden – sie sagt klar, auf welchem Branch die Arbeit basiert, gibt eine Zusammenfassung der Änderungen und gibt an, aus welchem Fork oder Repository man die Änderungen herunterladen kann.

<!--On a project for which you’re not the maintainer, it’s generally easier to have a branch like `master` always track `origin/master` and to do your work in topic branches that you can easily discard if they’re rejected.  Having work themes isolated into topic branches also makes it easier for you to rebase your work if the tip of the main repository has moved in the meantime and your commits no longer apply cleanly. For example, if you want to submit a second topic of work to the project, don’t continue working on the topic branch you just pushed up — start over from the main repository’s `master` branch:-->

Wenn Du nicht selbst Betreiber eines bestimmten Projektes bist, ist es im Allgemeinen einfacher, einen Branch `master` immer dem `origin/master` Branch tracken (xxx folgen) zu lassen und eigene Änderungen in Topic Branches vorzunehmen, die man leicht wieder löschen kann, wenn sie nicht akzeptiert werden. Wenn Du Aspekte Deiner Arbeit in Topic Branches isolierst, kannst Du sie außerdem recht leicht auf den letzten Stand des Hauptrepositories rebasen, falls das Hauptrepository in der Zwischenzeit weiter entwickelt wurde und Deine Commits nicht mehr sauber passen. Wenn Du beispielsweise an einem anderen Patch für das Projekt arbeiten willst, verwende dazu nicht weiter den gleichen Topic Branch, den Du gerade in Deinen Fork hochgeladen hast. Lege statt dessen einen neuen Topic Branch an, der wiederum auf dem `master` Branch des Hauptrepositories basiert.

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

<!--Now, each of your topics is contained within a silo — similar to a patch queue — that you can rewrite, rebase, and modify without the topics interfering or interdepending on each other as in Figure 5-16.-->

Deine Arbeit an den verschiedenen Patches sind jetzt in Deine Topic Branches isoliert – ähnlich wie in einer Patch Queue – sodass Du die einzelnen Topic Branches neu schreiben, rebasen und ändern kannst, ohne dass sie mit einander in Konflikt geraten (siehe Bild 5-16).

<!--Figure 5-16. Initial commit history with featureB work.-->

Insert 18333fig0516.png
Bild 5-16. Ursprüngliche Commit Historie mit dem `featureB` Branch

<!--Let’s say the project maintainer has pulled in a bunch of other patches and tried your first branch, but it no longer cleanly merges. In this case, you can try to rebase that branch on top of `origin/master`, resolve the conflicts for the maintainer, and then resubmit your changes:-->

Sagen wir, der Projekt Betreiber hat eine Reihe von Änderungen Dritter in das Projekt übernommen und Deine eigenen Änderungen lassen sich jetzt nicht mehr sauber mergen. In diesem Fall kannst Du Deine Änderungen auf dem neuen Stand des `origin/master` Branches rebasen, Konflikte beheben und Deine Arbeit erneut einreichen:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push -f myfork featureA

<!--This rewrites your history to now look like Figure 5-17.-->

Das schreibt Deine Commit Historie neu, sodass sie jetzt so aussieht (Bild 5-17):

<!--Figure 5-17. Commit history after featureA work.-->

Insert 18333fig0517.png
Bild 5-17. Commit Historie nach dem rebase von `featureA`

<!--Because you rebased the branch, you have to specify the `-f` to your push command in order to be able to replace the `featureA` branch on the server with a commit that isn’t a descendant of it. An alternative would be to push this new work to a different branch on the server (perhaps called `featureAv2`).-->

Weil Du den Branch rebased hast, musst Du die Option `-f` verwenden, um den `featureA` Branch auf dem Server zu ersetzen, denn Du hast die Commit Historie umgeschrieben und nun ist ein Commit enthalten, von dem der gegenwärtig letzte Commit des externen Branches nicht abstammt. Eine Alternative dazu wäre, den Branch jetzt in einen neuen externen Branch zu pushen, z.B. `featureAv2`.

<!--Let’s look at one more possible scenario: the maintainer has looked at work in your second branch and likes the concept but would like you to change an implementation detail. You’ll also take this opportunity to move the work to be based off the project’s current `master` branch. You start a new branch based off the current `origin/master` branch, squash the `featureB` changes there, resolve any conflicts, make the implementation change, and then push that up as a new branch:-->

Schauen wir uns noch ein anderes Szenario an: der Projekt Betreiber hat sich Deine Arbeit angesehen und will die Änderungen übernehmen, aber er bittet dich, noch eine Kleinigkeit an der Implementierung zu ändern. Du willst die Gelegenheit außerdem nutzen, um Deine Änderungen neu auf den gegenwärtigen `master` Branch des Projektes zu basieren. Du legst dazu einen neuen Branch von `origin/master` an, übernimmst Deine Änderungen dahin, löst ggf. Konflikte auf, nimmst die angeforderte Änderung an der Implementierung vor und lädst die Änderungen auf den Server:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

<!--The `-\-squash` option takes all the work on the merged branch and squashes it into one non-merge commit on top of the branch you’re on. The `-\-no-commit` option tells Git not to automatically record a commit. This allows you to introduce all the changes from another branch and then make more changes before recording the new commit.-->

Die `--squash` Option bewirkt, dass alle Änderungen des Merge Branches (`featureB`) übernommen werden, ohne aber dass zusätzlich ein Merge Commit angelegt wird. Die `--no-commit` Option instruiert Git außerdem, nicht automatisch einen Commit anzulegen. Das erlaubt dir, sämtliche Änderungen aus dem anderen Branch zu übernehmen und dann weitere Änderungen vorzunehmen, bevor Du das Ganze dann in einem neuen Commit speicherst.

<!--Now you can send the maintainer a message that you’ve made the requested changes and they can find those changes in your `featureBv2` branch (see Figure 5-18).-->

Jetzt kannst Du dem Projekt Betreiber eine Nachricht schicken, dass Du die angeforderte Änderung vorgenommen hast und dass er Deine Arbeit in Deinem `featureBv2` Branch finden kann (siehe Bild 5-18).

<!--Figure 5-18. Commit history after featureBv2 work.-->

Insert 18333fig0518.png
Bild 5-18. Commit Historie mit dem neuen `featureBv2` Branch

<!--### Public Large Project ###-->
### Große öffentliche Projekte ###

<!--Many larger projects have established procedures for accepting patches — you’ll need to check the specific rules for each project, because they will differ. However, many larger public projects accept patches via a developer mailing list, so I’ll go over an example of that now.-->

Viele große Projekte haben einen etablierten Prozess, nach dem sie vorgehen, wenn es darum geht, Patches zu akzeptieren. Du musst Dich mit den jeweiligen Regeln vertraut machen, die in jedem Projekt ein bisschen anders sind. Allerdings akzeptieren viele große Projekte Patches per E-Mail über eine Entwickler Mailingliste (xxx oder einen Bugtracker, wie Rails xxx). Deshalb gehen wir auf dieses Beispiel als nächstes ein.

<!--The workflow is similar to the previous use case — you create topic branches for each patch series you work on. The difference is how you submit them to the project. Instead of forking the project and pushing to your own writable version, you generate e-mail versions of each commit series and e-mail them to the developer mailing list:-->

Der Workflow ist ähnlich wie im vorherigen Szenario. Du legst für jeden Patch oder jede Patch Serie einen Topic Branch an, in dem Du arbeitest. Der Unterschied besteht dann darin, auf welchem Wege Du die Änderungen an das Projekt schickst. Statt das Projekt zu forken und Änderungen in Deinen Fork hochzuladen, erzeugst Du eine E-Mail Version Deiner Commits und schickst sie als Patch an die Entwickler Mailingliste.

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

<!--Now you have two commits that you want to send to the mailing list. You use `git format-patch` to generate the mbox-formatted files that you can e-mail to the list — it turns each commit into an e-mail message with the first line of the commit message as the subject and the rest of the message plus the patch that the commit introduces as the body. The nice thing about this is that applying a patch from an e-mail generated with `format-patch` preserves all the commit information properly, as you’ll see more of in the next section when you apply these patches:-->

Jetzt hast Du zwei Commits, die Du an die Mailingliste schicken willst. Du kannst den Befehl `git format-patch` verwenden, um aus diesen Commits Dateien zu erzeugen, die im mbox-Format formatiert sind und die Du per E-Mail verschicken kannst. Dieser Befehl macht aus jedem Commit eine E-Mail Datei. Die erste Zeile der Commit Meldung wird zum Betreff der E-Mail und der Rest der Commit Meldung sowie der Patch des Commits selbst wird zum Text der E-Mail. Das schöne daran ist, dass wenn man einen auf diese Weise erzeugten Patch benutzt, dann bleiben alle Commit Informationen erhalten. Du kannst das in den nächsten Beispielen sehen:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

<!--The `format-patch` command prints out the names of the patch files it creates. The `-M` switch tells Git to look for renames. The files end up looking like this:-->

Der Befehl `git format-patch` zeigt Dir die Namen der Patch Dateien an, die er erzeugt hat. (Die `-M` option weist Git an, nach umbenannten Dateien Ausschau zu halten.) Die Dateien sehen dann so aus:

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

<!--You can also edit these patch files to add more information for the e-mail list that you don’t want to show up in the commit message. If you add text between the `-\-\-` line and the beginning of the patch (the `lib/simplegit.rb` line), then developers can read it; but applying the patch excludes it.-->

Du kannst diese Patch Dateien anschließend bearbeiten, z.B. um weitere Informationen für die Mailingliste hinzuzufügen, die Du nicht in der Commit Meldung haben willst. Wenn Du zusätzlichen Text zwischen der `---` Zeile und dem Anfang des Patches (der Zeile `lib/simplegit.rb` in diesem Fall), dann ist er für den Leser sichtbar, aber Git wird ihn ignorieren, wenn man den Patch verwendet.

<!--To e-mail this to a mailing list, you can either paste the file into your e-mail program or send it via a command-line program. Pasting the text often causes formatting issues, especially with "smarter" clients that don’t preserve newlines and other whitespace appropriately. Luckily, Git provides a tool to help you send properly formatted patches via IMAP, which may be easier for you. I’ll demonstrate how to send a patch via Gmail, which happens to be the e-mail agent I use; you can read detailed instructions for a number of mail programs at the end of the aforementioned `Documentation/SubmittingPatches` file in the Git source code.-->

Um das jetzt an die Mailingliste zu schicken, kannst Du entweder die Datei per copy-and-paste in Dein E-Mail Programm kopieren, als Anhang an eine E-Mail anhängen oder Du kannst die Dateien mit einem Befehlszeilen Programm direkt verschicken. Patches zu kopieren verursacht oft Formatierungsprobleme – insbesondere mit „smarten“ E-Mail Clients, die die Dinge umformatieren, die man einfügt. Zum Glück bringt Git aber ein Tool mit, mit dem man Patches in ihrer korrekten Formatierung über IMAP verschicken kann. In folgendem Beispiel zeige ich, wie man Patches über Gmail verschicken kann, welches der E-Mail Client ist, den ich selbst verwende. Darüberhinaus findest Du ausführliche Beschreibungen für zahlreiche E-Mail Programme am Ende der schon erwähnten Datei `Documentation/SubmittingPatches` im Git Quellcode.

<!--First, you need to set up the imap section in your `~/.gitconfig` file. You can set each value separately with a series of `git config` commands, or you can add them manually; but in the end, your config file should look something like this:-->

Zunächst musst Du die IMAP Sektion in Deiner `~/.gitconfig` Datei ausfüllen. Du kannst jeden Wert separat mit dem Befehl `git config` eingeben oder Du kannst die Datei öffnen und sie manuell eingeben. Im Endeffekt sollte Deine `~/.gitconfig` Datei in etwa so aussehen:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

<!--If your IMAP server doesn’t use SSL, the last two lines probably aren’t necessary, and the host value will be `imap://` instead of `imaps://`.-->
<!--When that is set up, you can use `git imap-send` to place the patch series in the Drafts folder of the specified IMAP server:-->

Wenn Dein IMAP Server kein SSL verwendet, kannst Du die letzten beiden Zeilen wahrscheinlich weglassen und der `host` dürfte mit `imap://` und nicht `imaps://` beginnen. Wenn Du diese Einstellungen konfiguriert hast, kannst Du `git imap-send` verwenden, um Deine Patches in den Entwurfsordner des angegebenen IMAP Servers zu kopieren:

	$ cat *.patch |git imap-send
	Resolving imap.gmail.com... ok
	Connecting to [74.125.142.109]:993... ok
	Logging in...
	sending 2 messages
	100% (2/2) done

<!--At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off.-->

Jetzt kannst Du in Deinen Entwürfe-Ordner wechseln, die Mailingliste an die Du den Patch senden möchtest im An-Feld setzen, vielleicht noch den Maintainer oder die verantwortliche Person in das CC-Feld einfügen und dann das Ganze losschicken.

<!--You can also send the patches through an SMTP server. As before, you can set each value separately with a series of `git config` commands, or you can add them manually in the sendemail section in your `~/.gitconfig` file:-->

Man kann Patches auch über einen SMTP-Server schicken. Wie im letzen Beispiel, kann man auch hier jeden einzelnen Wert mit einer Reihe von `git config` Kommandos setzen. Oder aber Du änderst die Sektion sendemail in Deiner `~/.gitconfig` Datei manuell:

	[sendemail]
	  smtpencryption = tls
	  smtpserver = smtp.gmail.com
	  smtpuser = user@gmail.com
	  smtpserverport = 587

<!--After this is done, you can use `git send-email` to send your patches:-->

Nach der Änderungen kannst Du mit `git send-email` die Patches abschicken:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

<!--Then, Git spits out a bunch of log information looking something like this for each patch you’re sending:-->

Git gibt dann für jeden Patch, den Du verschickst, ein paar Log Informationen aus, die in etwa so aussehen:

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

<!--At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off.-->

Jetzt solltest Du in den Entwurfsordner Deines E-Mail Clients gehen, als Empfänger Adresse die jeweilige Mailingliste angeben, möglicherweise ein CC an den Projektbetreiber oder einen anderen Verantwortlichen setzen und die E-Mail dann verschicken können.

<!--### Summary ###-->
### Zusammenfassung ###

<!--This section has covered a number of common workflows for dealing with several very different types of Git projects you’re likely to encounter and introduced a couple of new tools to help you manage this process. Next, you’ll see how to work the other side of the coin: maintaining a Git project. You’ll learn how to be a benevolent dictator or integration manager.-->

Wir haben jetzt eine Reihe von Workflows besprochen, die für jeweils sehr verschiedene Arten von Projekten üblich sind und denen Du vermutlich begegnen wirst. Wir haben außerdem einige neue Tools besprochen, die dabei hilfreich sind, diese Workflows umzusetzen. Als nächstes werden wir auf die andere Seite dieser Medaille eingehen: wie Du selbst ein Git Projekt betreiben kannst. Du wirst lernen, wie Du als „wohlwollender Diktator“ oder als Integration Manager arbeiten kannst.

<!--## Maintaining a Project ##-->
## Ein Projekt betreiben ##

<!--In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run.-->

Neben dem Wissen, das Du brauchst, um zu einem bestehenden Projekt Änderungen beizutragen, wirst Du vermutlich wissen wollen, wie Du selbst ein Projekt betreiben kannst. Dazu willst Du Patches akzeptieren und anwenden, die per `git format-patch` erzeugt und Dir per E-Mail geschickt wurden. Oder Du willst Änderungen aus externen Branches übernehmen, die Du zu Deinem Projekt hinzugefügt hast. Ob Du nun für das Hauptrepository verantwortlich bist oder ob Du dabei helfen willst, Patches zu verifizieren und zu bestätigen – in beiden Fällen musst Du wissen, wie Du Änderungen in einer Weise übernehmen kannst, die für andere Mitarbeiter nachvollziehbar und für Dich selbst tragbar ist.

<!--### Working in Topic Branches ###-->
### In Topic Branches arbeiten ###

<!--When you’re thinking of integrating new work, it’s generally a good idea to try it out in a topic branch — a temporary branch specifically made to try out that new work. This way, it’s easy to tweak a patch individually and leave it if it’s not working until you have time to come back to it. If you create a simple branch name based on the theme of the work you’re going to try, such as `ruby_client` or something similarly descriptive, you can easily remember it if you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these branches as well — such as `sc/ruby_client`, where `sc` is short for the person who contributed the work.-->
<!--As you’ll remember, you can create the branch based off your master branch like this:-->

Wenn Du Änderungen von anderen übernehmen willst, ist normalerweise eine gute Idee, sie in einem Topic Branch auszuprobieren – d.h., einem temporären Branch, dessen Zweck nur darin besteht, die jeweiligen Änderungen auszuprobieren. Auf diese Weise ist es einfach, Patches ggf. anzupassen oder sie im Zweifelsfall im Topic Branch liegen zu lassen, wenn sie nicht funktionieren und Du im Moment nicht die Zeit hast, Dich weiter damit zu befassen. Es ist empfehlenswert, Topic Branches Namen zu geben, die gut kommunizieren, worum es sich bei den jeweiligen Änderungen dreht, wie z.B. `ruby_client` oder etwas ähnlich aussagekräftiges, das Dir hilft, Dich daran zu erinnern. Der Projekt Betreiber des Git Projektes selbst vergibt Namensräume für solche Branches – wie z.B. `sc/ruby_client`, wobei `sc` ein Kürzel für den jeweiligen Autor des Patches ist. Wie Du inzwischen weißt, kannst Du einen neuen Branch, der auf dem gegenwärtigen `master` Branch basiert, wie folgt erzeugen (xxx falsch, das stimmt nur, wenn `master` der aktuelle Branch ist xxx):

	$ git branch sc/ruby_client master

<!--Or, if you want to also switch to it immediately, you can use the `checkout -b` command:-->

Oder, wenn außerdem direkt zu dem neuen Branch wechseln willst, kannst Du die `-b` für den `git checkout` Befehl verwenden:

	$ git checkout -b sc/ruby_client master

<!--Now you’re ready to add your contributed work into this topic branch and determine if you want to merge it into your longer-term branches.-->

Nachdem Du jetzt einen Topic Branch angelegt hast, kannst Du die Änderungen zu diesem Branch hinzufügen, um herauszufinden, ob Du sie dauerhaft in einen offiziellen Branch übernehmen willst.

<!--### Applying Patches from E-mail ###-->
### Patches aus E-Mails verwenden ###

<!--If you receive a patch over e-mail that you need to integrate into your project, you need to apply the patch in your topic branch to evaluate it. There are two ways to apply an e-mailed patch: with `git apply` or with `git am`.-->

Wenn Du einen Patch, den Du auf Dein Projekt anwenden willst, per E-Mail erhältst, gibt es zwei Möglichkeiten, das zu tun: `git apply` und `git am`.

<!--#### Applying a Patch with apply ####-->
#### Einen Patch verwenden: git apply ####

<!--If you received the patch from someone who generated it with the `git diff` or a Unix `diff` command, you can apply it with the `git apply` command. Assuming you saved the patch at `/tmp/patch-ruby-client.patch`, you can apply the patch like this:-->

Wenn der Patch mit `git diff` oder dem Unix Befehl `diff` erzeugt wurde, dann kannst Du ihn mit dem Befehl `git apply` anwenden. Nehmen wir an, Du hast den Patch nach `/tmp/patch-ruby-client.patch` gespeichert. Dann kannst Du ihn wie folgt verwenden:

	$ git apply /tmp/patch-ruby-client.patch

<!--This modifies the files in your working directory. It’s almost identical to running a `patch -p1` command to apply the patch, although it’s more paranoid and accepts fewer fuzzy matches than patch. It also handles file adds, deletes, and renames if they’re described in the `git diff` format, which `patch` won’t do. Finally, `git apply` is an "apply all or abort all" model where either everything is applied or nothing is, whereas `patch` can partially apply patchfiles, leaving your working directory in a weird state. `git apply` is overall much more paranoid than `patch`. It won’t create a commit for you — after running it, you must stage and commit the changes introduced manually.-->

Das ändert die Dateien in Deinem Git Arbeitsverzeichnis. Das ist fast das selbe wie wenn Du den Unix Befehl `patch -p1` verwendest. Der Git Befehl ist aber paranoider und akzeptiert nicht so viele unklare Übereinstimmungen. Außerdem kann er mit neu hinzugefügten, gelöschten und umbenannten Dateien umgehen, was der Unix Befehl `patch` nicht kann. Schließlich ist `git apply` ein „alles oder nichts“ Befehl, der entweder alle Änderungen übernimmt oder gar keine (wenn bei einem etwas schief geht), während `patch` Änderungen auch teilweise übernimmt, sodass er Dein Arbeitsverzeichnis gegebenenfalls in einem unbrauchbaren Zustand hinterlässt. `git apply` ist also insgesamt strenger als `patch`. Es legt im übrigen keinen Commit für Dich an. Nachdem Du `git apply` ausgeführt hast, musst Du die Änderungen manuell zur Staging Area hinzufügen und comitten.

<!--You can also use git apply to see if a patch applies cleanly before you try actually applying it — you can run `git apply -\-check` with the patch:-->

Du kannst `git apply --check` verwenden, um zu testen, ob der Patch sauber anwendbar wäre:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

<!--If there is no output, then the patch should apply cleanly. This command also exits with a non-zero status if the check fails, so you can use it in scripts if you want.-->

Wenn dieser Befehl nichts ausgibt, sollte der Befehl sauber anwendbar sein.

<!--#### Applying a Patch with am ####-->
#### Einen Patch verwenden: git am ####

<!--If the contributor is a Git user and was good enough to use the `format-patch` command to generate their patch, then your job is easier because the patch contains author information and a commit message for you. If you can, encourage your contributors to use `format-patch` instead of `diff` to generate patches for you. You should only have to use `git apply` for legacy patches and things like that.-->

Wenn der Autor des Patches selbst mit Git arbeitet, kann er Dir das Leben leichter machen, indem er `git format-patch` verwender, um seinen Patch zu erzeugen: der Patch wird dann die Commit Informationen über den Autor sowie die Commit Meldung enthalten. Es ist also empfehlenswert, Entwickler darum zu bitten und zu ermutigen, `git format-patch` statt `git diff` zu verwenden. Du wirst dann `git apply` nur sehr selten anwenden müssen (xxx legacy patches ??? xxx)

<!--To apply a patch generated by `format-patch`, you use `git am`. Technically, `git am` is built to read an mbox file, which is a simple, plain-text format for storing one or more e-mail messages in one text file. It looks something like this:-->

Um einen Patch zu verwenden, der mit `git format-patch` erzeugt wurde, benutzt Du den Befehl `git am`. Technisch gesehen ist `git am` ein Befehl, der eine mbox Datei lesen kann, d.h. eine einfache Nur-Text-Datei, die eine oder mehrere E-Mails enthalten kann. Eine solche Datei sieht in etwa wie folgt aus:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

<!--This is the beginning of the output of the format-patch command that you saw in the previous section. This is also a valid mbox e-mail format. If someone has e-mailed you the patch properly using git send-email, and you download that into an mbox format, then you can point git am to that mbox file, and it will start applying all the patches it sees. If you run a mail client that can save several e-mails out in mbox format, you can save entire patch series into a file and then use git am to apply them one at a time.-->

Das ist der Anfang der Ausgabe des `git format-patch` Befehls, die Du im vorherigen Abschnitt gesehen hast – und außerdem valides mbox E-Mail Format. Wenn Du eine solche Datei im mbox Format erhalten hast und der Absender `git send-email` korrekt verwendet hat, kannst Du `git am` mit der Datei verwenden und alle darin enthaltenen Patches werden auf Dein Projekt angewendet. Wenn Du einen E-Mail Client verwendest, der mehrere E-Mails im mbox Format in einer Datei speichern oder exportieren kann, kannst Du auch eine ganze Reihe von Patches in eine einzige Datei speichern und dann `git am` verwenden, um sie nacheinander anzuwenden.

<!--However, if someone uploaded a patch file generated via `format-patch` to a ticketing system or something similar, you can save the file locally and then pass that file saved on your disk to `git am` to apply it:-->

Wenn jemand einen Patch, der mit `git format-patch` erzeugt wurde, in einem Ticketsystem oder ähnlichem abgelegt hat, kannst Du die Datei lokal speichern und dann ebenfalls `git am` ausführen, um den Patch anzuwenden:

	$ git am 0001-limit-log-function.patch
	Applying: add limit to log function

<!--You can see that it applied cleanly and automatically created the new commit for you. The author information is taken from the e-mail’s `From` and `Date` headers, and the message of the commit is taken from the `Subject` and body (before the patch) of the e-mail. For example, if this patch was applied from the mbox example I just showed, the commit generated would look something like this:-->

Der Patch passte sauber auf die Codebase und hat automatisch einen neuen Commit angelegt. Die Autor Information wurde aus den `From` und `Date` Headern der E-Mail übernommen und die Commit Meldung aus dem Subject und Body der E-Mail. Wenn der Patch z.B. aus dem mbox Beispiel von oben stammt, sieht der resultierende Commit wie folgt aus:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

<!--The `Commit` information indicates the person who applied the patch and the time it was applied. The `Author` information is the individual who originally created the patch and when it was originally created.-->

Das `Commit` Feld zeigt den Namen desjenigen, der den Patch angewendet hat und `CommitDate` das jeweilige Datum und Uhrzeit. Die Felder `Author` und `AuthorDate` geben an, wer den Commit wann angelegt hat.

<!--But it’s possible that the patch won’t apply cleanly. Perhaps your main branch has diverged too far from the branch the patch was built from, or the patch depends on another patch you haven’t applied yet. In that case, the `git am` process will fail and ask you what you want to do:-->

Es ist allerdings möglich, dass der Patch nicht sauber auf den gegenwärtigen Code passt. Möglicherweise unterscheidet sich der jeweilige Branch inzwischen erheblich von dem Zustand, in dem er sich befand, als die in dem Patch enthaltenen Änderungen geschrieben wurden. In dem Fall wird `git am` fehlschlagen und Dir mitteilen, was zu tun ist:

	$ git am 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

<!--This command puts conflict markers in any files it has issues with, much like a conflicted merge or rebase operation. You solve this issue much the same way — edit the file to resolve the conflict, stage the new file, and then run `git am -\-resolved` to continue to the next patch:-->

Der Befehl fügt Konfliktmarkierungen in allen problematischen Dateien ein, so wie bei einem konfligierenden Merge oder Rebase. Und Du kannst den Konflikt in der selben Weise beheben: die Datei bearbeiten, die Änderungen zur Staging Area hinzufügen und dann `git am --resolved` ausführen, um mit dem jeweils nächsten Patch (falls vorhanden) fortzufahren.

	$ (fix the file)
	$ git add ticgit.gemspec
	$ git am --resolved
	Applying: seeing if this helps the gem

<!--If you want Git to try a bit more intelligently to resolve the conflict, you can pass a `-3` option to it, which makes Git attempt a three-way merge. This option isn’t on by default because it doesn’t work if the commit the patch says it was based on isn’t in your repository. If you do have that commit — if the patch was based on a public commit — then the `-3` option is generally much smarter about applying a conflicting patch:-->

Wenn Du willst, dass Git versucht, einen Konflikt etwas intelligenter zu lösen, kannst Du die `-3` Option angeben, sodass Git einen 3-Wege-Merge versucht. Dies ist deshalb nicht der Standard, weil ein 3-Wege-Merge nicht funktioniert, wenn der Commit, auf dem der Patch basiert, nicht Teil Deines Repositories ist. Wenn Du den Commit allerdings in Deiner Historie hast, d.h. wenn der Patch auf einem öffentlichen Commit basiert, dann ist die `-3` Option oft die bessere Variante, um einen konfligierenden Patch anzuwenden:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

<!--In this case, I was trying to apply a patch I had already applied. Without the `-3` option, it looks like a conflict.-->

In diesem Fall habe ich versucht, einen Patch anzuwenden, der ich bereits zuvor angewendet hatte. Ohne die `-3` Option würde ich einen Konflikt erhalten.

<!--If you’re applying a number of patches from an mbox, you can also run the `am` command in interactive mode, which stops at each patch it finds and asks if you want to apply it:-->

Wenn Du eine Reihe von Patches aus einer Datei im mbox Format anwendest, kannst Du außerdem den `git am` Befehl in einem interaktiven Modus ausführen. In diesem Modus hält Git bei jedem Patch an und fragt Dich jeweils, ob Du den Patch anwenden willst:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

<!--This is nice if you have a number of patches saved, because you can view the patch first if you don’t remember what it is, or not apply the patch if you’ve already done so.-->

Das ist praktisch, wenn Du eine ganze Reihe von Patches in einer Datei hast. Du kannst jeweils Patches anzeigen, an die Du Dich nicht erinnern kannst, oder Patches auslassen, z.B. weil Du sie schon zuvor angewendet hattest.

<!--When all the patches for your topic are applied and committed into your branch, you can choose whether and how to integrate them into a longer-running branch.-->

Nachdem Du alle Patches in Deinem Topic Branch angewendet hast, kannst Du die Änderungen durchsehen, testen und entscheiden, ob Du sie in einen dauerhaft bestehenden Branch übernehmen willst.

<!--### Checking Out Remote Branches ###-->
### Checking Out Remote Branches ###

<!--If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and then sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and do merges locally.-->

Möglicherweise kommen die Änderungen aber nicht als Patch sondern von einem Git Anwender, der sein eigenes Repository aufgesetzt hat, seine Änderungen dorthin hochgeladen und Dir dann die URL des Repositories und den Namen des Branches geschickt hat. In diesem Fall kannst Du das Repository als ein „remote“ (externes Repository) hinzufügen und die Änderungen lokal mergen.

<!--For instance, if Jessica sends you an e-mail saying that she has a great new feature in the `ruby-client` branch of her repository, you can test it by adding the remote and checking out that branch locally:-->

Wenn Dir z.B. Jessica eine E-Mail schickt und mitteilt, dass sie ein großartiges, neues Feature im `ruby-client` Branch ihres Repositories hat, dann kannst Du das Feature testen, indem Du das Repository als externes Repository Deines Projektes konfigurieren und den Branch lokal auscheckst:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

<!--If she e-mails you again later with another branch containing another great feature, you can fetch and check out because you already have the remote setup.-->

Wenn sie Dir später erneut eine E-Mail mit einem anderen Branch schickt, der ein anderes, großartiges Feature enthält, dann kannst Du diesen Branch direkt herunterladen und auschecken, weil Du das externe Repository noch konfiguriert hast.

<!--This is most useful if you’re working with a person consistently. If someone only has a single patch to contribute once in a while, then accepting it over e-mail may be less time consuming than requiring everyone to run their own server and having to continually add and remove remotes to get a few patches. You’re also unlikely to want to have hundreds of remotes, each for someone who contributes only a patch or two. However, scripts and hosted services may make this easier — it depends largely on how you develop and how your contributors develop.-->

Dies ist insbesondere nützlich, wenn Du mit jemandem regelmäßig zusammen arbeitest. Wenn jemand lediglich gelegentlich einen einzelnen Patch beiträgt, dann ist es wahrscheinlich weniger aufwendig, ihn per E-Mail zu akzeptieren, als von jedem zu erwarten, einen eigenen Server zu betreiben, und selbst ständig externe Repositories hinzuzufügen und zu entfernen. Du wirst kaum hunderte von externen Repositories verwalten wollen, nur um von jedem ein paar Änderungen zu erhalten. Auf der anderen Seite erleichtern Dir Scripts und Hosted Services diesen Prozess. Es hängt also alles davon ab, wie Du selbst und wie Deine Mitarbeiter entwickeln.

<!--The other advantage of this approach is that you get the history of the commits as well. Although you may have legitimate merge issues, you know where in your history their work is based; a proper three-way merge is the default rather than having to supply a `-3` and hope the patch was generated off a public commit to which you have access.-->

Wenn Du mit jemandem nicht regelmäßig zusammen arbeitest, aber trotzdem aus ihrem Repository mergen willst, dann kannst Du dem `git pull` Befehl die URL ihres externen Repositories übergeben. Das lädt den entsprechenden Branch einmalig herunter und merged ihn in Deinen aktuellen Branch, ohne aber die externe URL als eine Referenz zu speichern:

<!--If you aren’t working with a person consistently but still want to pull from them in this way, you can provide the URL of the remote repository to the `git pull` command. This does a one-time pull and doesn’t save the URL as a remote reference:-->

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

<!--### Determining What Is Introduced ###-->
### Neuigkeiten durchsehen ###

<!--Now you have a topic branch that contains contributed work. At this point, you can determine what you’d like to do with it. This section revisits a couple of commands so you can see how you can use them to review exactly what you’ll be introducing if you merge this into your main branch.-->

Du hast jetzt einen Topic Branch, der die neuen Änderungen enthält, und kannst jetzt herausfinden, was Du damit anfangen willst. In diesem Abschnitt gehen wir noch mal auf einige Befehle ein, die nützlich sind, um herauszufinden, welche Änderungen Du übernehmen würdest, wenn Du den Topic Branch in Deinen Hauptbranch mergest.

<!--It’s often helpful to get a review of all the commits that are in this branch but that aren’t in your master branch. You can exclude commits in the master branch by adding the `-\-not` option before the branch name. For example, if your contributor sends you two patches and you create a branch called `contrib` and applied those patches there, you can run this:-->

Es ist in der Regel hilfreich, sich Commits anzusehen, die sich in diesem Branch, nicht aber im `master` Branch befinden. Du kannst Commits aus dem `master` Branch ausschließen, indem Du die `--not` Option verwendest. Wenn Du beispielsweise zwei neue Commits erhalten und sie in einen Topic Branch `contrib` übernommen hast, kannst Du folgendes tun:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

<!--To see what changes each commit introduces, remember that you can pass the `-p` option to `git log` and it will append the diff introduced to each commit.-->

Wie Du schon gelernt hast, kannst Du außerdem die Option `-p` verwenden, um zu sehen, welche Diffs die Commits enthalten.

<!--To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to use a weird trick to get the correct results. You may think to run this:-->

Wenn Du ein vollständiges Diff aller Änderungen sehen willst, die Dein Topic Branch gegenüber z.B. dem `master` Branch enthält, brauchst Du einen Trick. Möglicherweise würdest Du zuerst das hier ausprobieren:

	$ git diff master

<!--This command gives you a diff, but it may be misleading. If your `master` branch has moved forward since you created the topic branch from it, then you’ll get seemingly strange results. This happens because Git directly compares the snapshots of the last commit of the topic branch you’re on and the snapshot of the last commit on the `master` branch. For example, if you’ve added a line in a file on the `master` branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.-->

Der Befehl gibt Dir ein Diff aus, kann aber irreführend sein. Wenn im `master` Branch Änderungen committed wurden, seit der Branch angelegt wurde, erhältst Du scheinbar merkwürdige Ergebnisse. Das liegt daran, dass Git den Snapshot des letzten Commits des Topic Branches, in dem Du Dich momentan befindest, mit dem letzten Commit des `master` Branches vergleicht. Wenn Du beispielsweise eine Zeile in einer Datei im `master` branch hinzugefügt hast, scheint der direkte Vergleich auszusagen, dass diese Zeile im Topic Branch entfernt wurde.

<!--If `master` is a direct ancestor of your topic branch, this isn’t a problem; but if the two histories have diverged, the diff will look like you’re adding all the new stuff in your topic branch and removing everything unique to the `master` branch.-->

Wenn `master` ein direkter Vorfahr Deines Topic Branches ist, ist das kein Problem. Aber wenn sich die beiden Historien auseinander bewegt (xxx) haben, dann scheint das Diff auszusagen, dass Du alle Neuigkeiten im Topic Branch hinzufügst und alle Neuigkeiten im `master` Branch entfernst.

<!--What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.-->

Was Du aber eigentlich wissen willst, ist welche Änderungen der Topic Branch hinzugefügt hat, d.h. die Änderungen, die Du in den `master` Branch neu einführen würdest, wenn Du den Topic Branch mergest. Dieses Ergebnis erhältst Du, wenn Du den letzten Commit im Topic Branch mit dem letzten Commit vergleichst, den der Topic Branch mit `master` gemeinsam hat.

<!--Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it:-->

Technisch gesehen könntest Du den letzten gemeinsamen Commit explizit erfragen und dann ein Diff darauf ausführen:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db

<!--However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch:-->

Das ist natürlich nicht sonderlich bequem, weshalb Git eine Kurzform dafür definiert: die triple-dot Syntax (xxx). Im Context des `git diff` Befehls bewirkt dies, dass Du ein Diff erhältst, das den letzten gemeinsamen Commit der Histories beider angegebener Branches mit dem letzten Commit des zuletzt angegebenen Branches vergleicht:

	$ git diff master...contrib

<!--This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember.-->

Dieser Befehl zeigt Dir diejenigen Änderungen, die im Topic Branch eingeführt wurden, die aber noch nicht in `master` enthalten sind.

<!--### Integrating Contributed Work ###-->
### Beiträge anderer integrieren ###

<!--When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them.-->

Sobald Du die Änderungen in Deinem Topic Branch in einen dauerhafteren Branch übernehmen willst, fragt sich, wie Du das anstellen kannst. Und welchen generellen Workflow willst Du verwenden, um das Projekt zu pflegen? Wir werden eine Reihe von Möglichkeiten besprechen, die Dir zur Verfügung stehen.

<!--#### Merging Workflows ####-->
#### Merge Workflows ####

<!--One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20.-->

Eine einfache Möglichkeit besteht darin, Deine Arbeit einfach in den `master` Branch zu mergen. In diesem Workflow hast Du einen `master` Branch, der eine stabilen Code beinhaltet. Wenn Du Änderungen in einem Topic Branch hast, die von Dir selbst oder jemand anderem geschrieben und die verifiziert sind, dann mergest Du diesen Topic Branch in den `master` Branch, löschst den Topic Branch und fährst mit diesem Prozess so fort. Wenn es ein Repository mit zwei Branches gibt, die `ruby_client` und `php_client` heißen (wie in Bild 5-19), und Du mergest `ruby_client` zuerst und `php_client` danach, dann wird die Historie danach aussehen wie im Bild 5-20.

<!--Figure 5-19. History with several topic branches.-->

Insert 18333fig0519.png
Bild 5-19. Historie mit verschiedenen Topic Branches

<!--Figure 5-20. After a topic branch merge.-->

Insert 18333fig0520.png
Bild 5-20. Nach dem Merge mit verschiedenen Topic Branches

<!--That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects.-->

Dies ist vermutlich der einfachste, mögliche Workflow. Er ist allerdings für große Repositories oder Projekte manchmal problematisch.

<!--If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23).-->

Wenn Du mehr Entwickler oder ein größeres Projekt hast, wirst Du in der Regel einen Merge Zyklus mit mindestens zwei Phasen verwenden wollen. In einem solchen Workflow hast Du dann zwei dauerhafte Branches, z.B. `master` und `develop`, wobei `master` ausschließlich sehr stabile Releases enthält und neuer Code im `develop` Branch integriert wird. Jedes Mal, wenn Du einen neuen Topic Branch mergen willst, mergest Du ihn nach `develop` (Bild 5-22). Und nur dann, wenn Du einen Release taggen willst, führst Du ein fast-forward (xxx) it `master` bis zum gegenwärtigen, nun stabilen Status des `develop` Branch durch.

<!--Figure 5-21. Before a topic branch merge.-->

Insert 18333fig0521.png
Bild 5-21. Vor dem Topic Branch Merge

<!--Figure 5-22. After a topic branch merge.-->

Insert 18333fig0522.png
Bild 5-22. Nach dem Topic Branch Merge

<!--Figure 5-23. After a topic branch release.-->

Insert 18333fig0523.png
Bild 5-23. Nach dem Topic Branch Release

<!--This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.-->
<!--You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch.-->

Auf diese Weise kann jeder, der Dein Repository klont, auf einfache Weise Deinen aktuellen `master` Branch verwenden und ihn auf neue Releases aktualisieren. Oder er kann den `develop` Branch ausprobieren, in dem sich die jeweils letzten, brandneuen Änderungen befinden. Du kannst dieses Konzept noch weiterführen, indem Du einen `integrate` Branch pflegst, in den neue Änderungen jeweils integriert werden. Sobald der Code in diesem Branch stabil zu sein scheint und alle Tests durchlaufen (xxx), übernimmst Du die Änderungen in den `develop` Branch. Und wenn sie sich für eine Weile in der Praxis als stabil erwiesen haben, fast-forwardest (xxx) Du den `master` Branch.

<!--#### Large-Merging Workflows ####-->
#### Workflows für umfassende Merges ####

<!--The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together.-->

Das Git Projekt selbst hat view dauerhafte Branches: `master`, `next`, `pu` („proposed updates“, d.h. vorgeschlagene Änderungen) und `maint` („maintenance backports“, d.h. xxx Rückportierungen). Wenn neue Änderungen herein kommen, werden sie in Topic Branches im Projekt Repository gesammelt, ganz ähnlich wie wir gerade besprochen haben (siehe Bild 5-24). Dann wird evaluiert, ob die Änderungen sicher sind und übernommen werden sollen oder ob sie noch weiter bearbeitet werden müssen. Wenn sie übernommen werden sollen, werden sie in den Branch `next` gemerged und dieser Branch wird hochgeladen, sodass jeder ausprobieren kann, wie die neue Codebase funktioniert, nachdem die Änderungen miteinander integriert wurden.

<!--Figure 5-24. Managing a complex series of parallel contributed topic branches.-->

Insert 18333fig0524.png
Bild 5-24. Komplexe, parallel entwickelte Topic Branches verwalten

<!--If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25).-->

Wenn die Topic Branches noch weiter bearbeitet werden müssen, werden sie statt dessen in den `pu` Branch gemerged. Wenn sie dann stabil sind, werden sie erneut in `master` gemerged und aus denjenigen Änderungen neu aufgebaut, die sich in `next` befanden, es aber noch nicht bis in den `master` Branch geschafft haben (xxx wie jetzt?? xxx). D.h., `master` bewegt sich fast ständig, `next` wird gelegentlich rebased, und `pu` wird noch sehr viel häufiger rebased (siehe Bild 5-25).

<!--Figure 5-25. Merging contributed topic branches into long-term integration branches.-->

Insert 18333fig0525.png
Bild 5-25. Topic Branches in dauerhafte Integrationsbranches mergen

<!--When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions.-->

Wenn ein Topic Branch schließlich in `master` gemerged wird, wird er aus dem Repository gelöscht. Das Git Projekt hat außerdem einen `maint` Branch, der jeweils vom letzten Release verzweigt. In diesem Branch werden rückportierte Patches für den Fall gesammelt, dass ein Maintenance Release nötig ist. D.h., wenn Du das Git Projekt Repository klonst, findest Du vier Branches des Projektes in verschiedenen Stadien, die Du jeweils ausprobieren kannst, je nachdem wie hochaktuellen Code Du testen oder wie Du zu dem Projekt beitragen willst. Und der Projekt Betreiber hat auf diese Weise einen klar strukturierten Workflow, der es einfacher macht, neue Beiträge zu prüfen und zu verarbeiten.

<!--#### Rebasing and Cherry Picking Workflows ####-->
#### Rebase und Cherry Picking Workflows ####

<!--Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history.-->

Andere Betreiber bevorzugen, neue Änderungen auf der Basis ihres `master` Branches zu rebasen oder zu cherry-picken statt sie zu mergen, um auf diese Weise eine eher lineare Historie zu erhalten. Wenn Du Änderungen in einem Topic Branch hast, die Du integrieren willst, dann gehst Du in diesen Branch und führst den `rebase` Befehl aus, um diese Änderungen auf der Basis des gegenwärtigen `master` Branches (oder irgendeines anderen, stabileren Branches) neu zu schreiben. Wenn das glatt läuft, kannst Du den `master` Branch fast-forwarden (xxx) und erhältst so eine lineare Projekt Historie.

<!--The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26.-->

Eine andere Möglichkeit, Commits aus einem Branch in einen anderen zu übernehmen ist der `cherry-pick` Befehl. In Git ist dieser Befehl quasi ein rebase für einen einzelnen Commit. Er nimmt den Patch, der mit dem Commit eingeführt wurde, und versucht, diesen auf den Branch anzuwenden, in dem Du Dich gerade befindest. Das ist nützlich, wenn Du in einem Topic Branch eine Anzahl von Commits hast, aber lediglich einen davon übernehmen willst. Oder wenn Du überhaupt nur einen Commit im Topic Branch hast, diesen aber lieber cherry-picken willst, statt den ganzen Branch zu rebasen. Nehmen wir z.B. an, Du hast ein Projekt, das so aussieht wie in Bild 5-26.

<!--Figure 5-26. Example history before a cherry pick.-->

Insert 18333fig0526.png
Bild 5-26. Beispiel Historie vor einem cherry-pick

<!--If you want to pull commit `e43a6` into your master branch, you can run-->

Wenn Du den Commit `e43a6` in Deinen `master` Branch übernehmen willst, kannst Du folgendes ausführen:

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

<!--This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27.-->

Das wendet dieselben Änderungen, die in `e43a6` eingeführt wurden, auf den `master` Branch an, aber Du erhältst einen neuen Commit SHA-1 Hash, weil auch das Datum ein anderes ist. Jetzt sieht Deine Historie so aus:

<!--Figure 5-27. History after cherry-picking a commit on a topic branch.-->

Insert 18333fig0527.png
Bild 5-27. Historie nach dem cherry-pick eines Commits aus einem Topic Branch

<!--Now you can remove your topic branch and drop the commits you didn’t want to pull in.-->

Jetzt kannst Du den Topic Branch inklusive der ggf. darin enthaltenen Commits löschen, falls Du sie nicht noch übernehmen willst.

<!--### Tagging Your Releases ###-->
### Releases taggen ###

<!--When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this:-->

Wenn Du einen Release herausgeben willst, ist es empfehlenswert, einen Tag dafür anzulegen, sodass man den jeweiligen Zustand der Historie jederzeit leicht wiederherstellen kann. Wir sind bereits in Kapitel 2 auf Git Tags eingegangen. Wenn Du als Betreiber den neuen Tag signieren willst, könnte das wie folgt aussehen:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

<!--If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg -\-list-keys`:-->

Wenn Du Deine Tags signierst, könnte das Problem bestehen, dass Du den jeweiligen öffentlichen PGP key zur Verfügung stellen musst. Der Betreiber des Git Projektes löst das, in dem er den öffentlichen Schlüssel als Inhalt im Repository selbst zur Verfügung stellt und einen Tag hat, der direkt auf diesen Inhalt zeigt. Um das zu tun, musst Du zunächst herausfinden, welchen Schlüssel Du verwenden willst:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

<!--Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob:-->

Dann kannst Du den Schlüssel direkt in die Git Datenbank importieren, indem Du ihn aus GPG exportierst und die Ausgabe nach `git hash-object` weiterreichst. Das schreibt ein neues Objekt mit dem Schlüssel in die Git Datenbank und gibt Dir einen SHA-1 Hash zurück, der dieses Objekt referenziert:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

<!--Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you:-->

Nachdem Du jetzt den Schlüssel im Repository hast, kannst Du einen Tag für den SHA-1 Hash anlegen, den `git hash-object` zurückgegeben hat:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

<!--If you run `git push -\-tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG:-->

Wenn Du `git push --tags` ausführst, wird jetzt der `maintainer-pgp-pub` Tag auf den Server geladen, sodass jeder darauf zugreifen kann. Wenn jemand jetzt einen signierten Tag verifizieren will, kann er Deinen öffentlichen PGP Schlüssel direkt aus der Datenbank holen und in seinen Schlüsselbund importieren:

	$ git show maintainer-pgp-pub | gpg --import

<!--They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification.-->

Dieser Schlüssel kann anschließend für alle signierten Tages verwendet werden. Zusätzlich kannst Du Deinen Anwendern in der Tag Meldung erklären, wie sie signierte Tags mit diesem Schlüssel verifizieren können.

<!--### Generating a Build Number ###-->
### Eine Build Nummer generieren ###

<!--Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing:-->

Weil Git keine globalen Nummern wie `v123` kennt, die mit jedem Commit monoton hochgezählt werden, kannst Du, um einen leicht lesbaren Bezeichner für einen bestimmten Commit zu erhalten, den Befehl `git describe` auf diesen Befehl ausführen. Git erzeugt dann einen Bezeichner zurück, der den Namen des nächsten Tags enthält, der Anzahl der Commits seit diesem Tag und die ersten Zeichen des SHA-1 Hashs des Commits:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

<!--This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git -\-version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name.-->

Auf diese Weise kannst Du in einer Weise auf einen Commit oder Build verweisen, der für Andere leichter verständlich ist. Wenn Du z.B. Git selbst aus dem Quellcode kompilierst, der sich im Git Projekt Repository befindet, dann gibt `git --version` einen ähnlichen Bezeichner zurück. Wenn Du übrigens `git describe` auf einen Commit ausführst, den Du direkt getagged hast, dann erhältst Du statt dessen den Tag Namen.

<!--The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated.-->

Der `git describe` Befehl funktioniert mit kommentierten Tags besser (d.h. Tags, die mit dem `-a` oder `-s` Flag erzeugt wurden), sodass es sich empfiehlt, Release Tags auf diese Weise anzulegen, wenn man `git describe` verwenden will. Du kannst diese Bezeichner auch als Parameter für andere Git Befehle, z.B. `git checkout` oder `git show`, wobei Git allerdings lediglich auf den abgekürzten SHA-1 Hash am Ende achtet, sodass er möglicherweise nicht ewig gültig ist. Das Linux Kernel Projekt beispielsweise erhöhte die Anzahl der Zeichen in abgekürzten Hashes kürzlich von 8 auf 10, um die Eindeutigkeit von SHA-1 Hashes sicherzustellen. Ältere `git describe` Ausgaben wurden damit ungültig.

<!--### Preparing a Release ###-->
### Ein Release vorbereiten ###

<!--Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`:-->

Du willst jetzt ein Release herausgeben. Dazu willst Du u.a. ein Archiv mit dem letzten Snapshot Deines Codes erzeugen, damit ihn auch arme Seelen herunterladen können, die Git nicht verwenden. Der folgende Befehl hilft Dir dabei:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

<!--If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `-\-format=zip` option to `git archive`:-->

Das erzeugt einen Tarball, der den aktuellen Snapshot in Deinem Arbeitsverzeichnis enthält. Du kannst auf die gleiche Weise ein Zip Archiv erzeugen, indem Du `git archive` die `--format=zip` Option übergibst.

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

<!--You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people.-->

Du hast jetzt sowohl einen Tarball als auch ein Zip Archiv Deines Releases. Diese kannst Du z.B. auf Deiner Webseite publizieren oder auch per E-Mail verschicken.

<!--### The Shortlog ###-->
### Das Shortlog ###

<!--It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1:-->

Es wird Zeit, den Lesern der Mailingliste zu erklären, was es im Projekt Neues gibt. Der `git shortlog` Befehl ist eine Möglichkeit, schnell eine Art Changelog der Änderungen seit dem letzten Release auszugeben. Er fasst alle Commits in der angegebenen Zeitspanne zusammen. Der folgende Befehl z.B. erzeugt eine Zusammenfassung der Commits seit dem letzten Release, der als `v1.0.1` getagged wurde:

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

<!--You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list.-->

Du erhältst eine saubere Auflistung aller Commits seit `v1.0.1`, gruppiert nach Autor. Diese kannst Du z.B. an die Mailingliste schicken oder irgendwie anders publizieren.

<!--## Summary ##-->
## Zusammenfassung ##

<!--You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master.-->

Du solltest Dich jetzt einigermaßen vertraut damit fühlen, sowohl Beiträge bei einem bestehenden Projekt einzureichen als auch selbst ein eigenes Projekt zu betreiben und Beiträge anderer zu integrieren. Herzlichen Glückwunsch, Du bist jetzt ein erfolgreicher Git Entwickler! (xxx hä? xxx) Im nächsten Kapitel wirst Du weitere mächtige Git Werkzeuge und Tipps dafür kennenlernen, mit komplexen Situationen umzugehen – die einen wahren Git Meister aus Dir werden. (xxx aha? xxx)
