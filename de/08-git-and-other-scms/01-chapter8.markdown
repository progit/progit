# Git und andere Versionsverwaltungen #

Leider ist die Welt nicht perfekt. Normalerweise kannst Du nicht bei jedem Deiner Projekt sofort auf Git umsteigen. Manchmal musst Du in einem Deiner Projekte irgendeine andere Versionsverwaltung nutzen, ziemlich oft ist das Subversion. Im ersten Teil dieses Kapitels werden wir das bidirektionale Gateway zwischen Git und Subversion kennezulernen: `git svn`.

Manchmal kommst Du an den Zeitpunkt, zu dem Du ein bestehendes Projekt zu Git konvertieren willst. Der zweite Teil dieses Kapitels zeigt Dir, wie Du Dein Projekt zu Git migrieren kannst. Zunächst behandeln wir Subversion, dann Perforce und zum Schluss verwenden wir ein angepasstes Import-Skript, um einen nicht standard-mäßigen Import abzudecken.

## Git und Subversion ##

Gegenwärtig verwenden die meisten Open Source Entwicklungsprojekte und eine große Anzahl von Projekten in Unternehmen Subversion, um ihren Quellcode zu verwalten. Es ist die populärste Open Source Versionsverwaltung und wird seit fast einem Jahrzehnt eingesetzt. In vielen Bereichen ähnelt es CVS, das vorher der König der Versionsverwaltungen war.

Eines der großartigen Features von Git ist die bi-direktionale Brücke zu Subversion: `git svn`. Diese Tool ermöglicht es, Git als ganz normalen Client für einen Subversion-Server zu benutzen, so dass Du alle lokalen Features von Git nutzen kanns und Deine Änderungen dann auf einen Subversion-Server pushen kannst, so als ob Du Subversion lokal nutzen würdest. Das bedeutet, dass Du lokale Branches anlegen kannst, mergen, die staging area, rebasing, cherry-picking etc. verwenden, während Deine Kollegen weiterhin aus ihre angestaubte Art und Weise arbeiten. Das ist eine gute Gelegenheit, um Git in einem Unternehmen einzuführen und Deinen Entwickler-Kollegen dabei zu helfen, effizienter zu werden während Du an der Unterstützung arbeitest, die Infrastruktur so umzubauen, dass Git voll unterstützt wird. Die Subversion-Bridge von Git ist quasi die Einstiegsdroge in die Welt der verteilten Versionsverwaltungssysteme (distributed version control systems, DVCS).

### git svn ###

Das Haupt-Kommando in Git für alle Kommandos der Subversion Bridge ist `git svn`. Dieser Befehl wird allen anderen vorangestellt. Er kennt zahlreiche Optionen, daher werde wir jetzt die gebräuchlichsten zusammen anhand von ein paar Beispielen durchspielen.

Es ist wichtig, dass Du im Hinterkopf behältst, dass Du mit dem `git svn` Befehl mit Subversion interagierst, eine System, dass nicht ganz so fortschrittlich ist wie Git. Obwohl Du auch dort ganz einfach Branches erstellen und wieder zusammenführen kannst, ist es üblicherweise am einfachsten, wenn Du die History so geradlinig wie möglich gestaltest, indem Du ein rebase für Deine Arbeit durchfürst und es vermeidest, zum Beispiel mit einem entfernten Git-Repository zu interagieren.

Du solltest auf keinen Fall Deine History neu schreiben und dann versuchen, die Änderungen zu publizieren. Bitte schick Deine Änderungen auch nicht zeitgleich dazu an ein anderes Git-Repository, in dem Du mit Deinen Kollegen zusammenarbeitest, die bereits Git nutzen. Subversion kennt nur eine einzige lineare History für das gesamte Repository und da kommt man schnell mal durcheinander. Wenn Du in einem Team arbeitest, in dem manche Deiner Kollegen SVN und andere schon Git nutzen, dann solltest Du sicherstellen, dass Ihr alle einen SVN-Server zur Zusammenarbeit nutzt, das macht Dein Leben deutlich einfacher.

### Installation ###

Um dieses Feature zu demonstrieren, brauchst Du zunächst ein typisches SVN-Repository, in dem Du Schreibzugriff hast. Wenn Du die folgenden Beispiele selbst ausprobieren willst, brauchst Du eine beschreibbare Kopie meines Test-Repositories. Das geht ganz einfach mit einem kleinen Tool namens `svnsync`, das mit den letzten Subversion-Versionen (ab Version 1.4) mitgeliefert wird. Für diese Test habe ich ein neues Subversion Repository auf Google Code angelegt, das einen Teil aus dem `protobuf`-Projekts kopiert, einem Tool, das Datenstrukturen für die Übertragung über ein Netzwerk umwandelt.

Zunächst einmal musst Du ein neues lokales Subversion-Repository anlegen:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Anschließend gibst Du allen Usern die Möglichkeit, die revprops zu ändern. Am einfachsten geht das, indem wir ein pre-revprop-change Skript erstellen, das immer 0 zurückgibt:

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Jetzt kannst Du dieses Projekt auf Deinen lokalen Rechner mit einem Aufruf von `svnsync init` synchronisieren. Als Optionen gibst Du das Ziel- und das Quell-Repository an.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

Das richtet die Properties ein, um die Synchronisierung laufen zu lassen. Nun kannst Du den Code klonen:

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Obwohl diese Operation möglicherweise nur ein paar wenige Minuten in Anspruch nimmt, wird das Kopieren des Quell-Repositories von einem entfernten Repository in ein lokales fast eine Stunde dauern, auch wenn weniger als 100 Commits getätigt wurden. Subversion muss jede Revision einzeln klonen und sie dann in ein anderes Repository schieben - das ist zwar ziemlich ineffizient, aber für uns der einfachste Weg.

### Die ersten Schritte ###

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

Hier werden für die angegebene URL eigentlich zwei Befehle ausgeführt, `git svn init` und anschließend `git svn fetch`. Das kann auch eine Weile dauern. Das Testprojekt hat nur etwa 75 Commits und die Codebase ist nicht so groß, daher benötigen wir nur ein paar Minuten. Da Git aber jede Version einzeln auschecken muss, kann es unter Umständen Stunden oder gar Tage dauern, bis die Ausführung des Befehls fertig ist.

Die Parameter `-T trunk -b branches -t tags` teilen Git mit, dass das Subversion-Repository den normalen Konventionen bezüglich Branching und Tagging folgt. Wenn Du Deinen Trunk, Deine Branches oder Deine Tags anders benannt hast, kannst Du diese hier anpassen. Da die Angabe aus dem Beispiel für die meisten Repositories gängig ist, kannst Du das ganze auch mit `-s` abkürzen. Diese Option steht für das Standard-Repository-Layount und umfasst die oben genannten Parameter. Der folgende Befehl ist äquivalent zum zuvor genannten:

	$ git svn clone file:///tmp/test-svn -s

Jetzt solltest Du ein Git-Repository erzeugt haben, in das Deine Branches und Tags übernommen wurden: 

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

An dieser Stelle soll die wichtige Anmerkung nicht fehlen, dass dieses Tool die Namespaces Deiner entfernten Referenzen unterschiedlich behandelt. Wenn Du ein normales Git-Repository klonst, werden alle Branches auf jenem entfernten Server für Dich lokal verfügbar gemacht, zum Beispiel als `origin/[branch]`, der Namespace entspricht dem Namen des entfernten Branches. `git svn` get allerdings davon aus, dass es nicht mehrere entfernte Repositorys gibt und speichert daher seie Referenzen auf die Bereiche entfernter Server ohne Namespaces. Du kannst das Git-Kommando `show-ref` verwenden, um Dir die vollständigen Namen aller Referenzen anzeigen zu lassen:

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

Ein normales Git-Repository sieht dagegen eher so aus:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

Du hast zwei entfernte Server: einen, der `gitserver` heißt und einen `master`-Branch beinhaltet, und einen weiteren, der `origin` heißt und zwei Branches (`master` und `testing`) enthält.

Hast Du bemerkt, dass die entfernten Referenzen, die von `git svn` im Beispiel importiert wurden, nicht als echte Git-Tags importiert wurden, sondern als entfernte Branches? Dein Subversion-Import sieht aus als besäße er einen eigenen Remote-Bereich namens `tags` und unterhalb davon einzelne Branches.