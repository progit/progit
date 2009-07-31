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