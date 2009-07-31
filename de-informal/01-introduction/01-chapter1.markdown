# Los geht's #

Dieses Kapitel führt in das Arbeiten mit Git ein. Wir werden zuerst ein bisschen Hintergrundwissen über Versionskontrollsysteme erklären, und dann mit der Installation und initialen Konfiguration von Git fortfahren. Am Ende des Kapitels solltest Du verstehen warum es Git gibt, und warum du es benutzen solltest - und du solltest in der Lage sein loszulegen.

## Über Versionskontrolle ##

Was ist Versionskontrolle, und warum sollte es dich Interessieren? Versionskontrolle ist ein Überbegriff für Systeme die Änderungen an Dateien oder an einem ganzen Set von Dateien während eines Bearbeitungszeitraumes archivieren - so dass man bestimmte Versionen später wiederherstellen kann. Für die Beispiele in diesem Buch wirst Du dies mit Software-Sourcecode tun, in der Realität geht das aber mit fast allen Dateien auf einem Computer.

Wenn Du ein Grafiker oder Webdesigner bist, und du möchtest jede Version von einem Bild oder Layout speichern (Du möchtest das wirklich!), ist ein Versionskontrollsystem (VCS - Version Control System) das Werkzeug deiner Wahl. Es erlaubt dir Änderungen an Dateien rückgängig zu machen, das komplette Projekt in einen früheren Zustand zu versetzen, Änderungen zu vergleichen, herauszufinden wer zuletzt eine Änderung gemacht hat die vermutlich ein Problem verursacht hat, zu sehen wer wann ein bestimmtes Thema bearbeitet hat, und vieles mehr. Wenn Du ein Versionskontrollsystem benutzt, bedeutet es aber vor allem, dass du, wenn du (oder jemand anderes) Mist baust, leicht einen früheren Zustand wiederherstellen kannst. Und das bekommst Du meist ohne zusätzlichen nennenswerten Mehraufwand.

### Lokale Versionskontrollsysteme ###

Viele Leute versionieren ihre Projekte und Dateien indem sie Kopien in andere Verzeichnisse (die zum Beispiel nach dem Datum oder Uhrzeit benannt sind) kopieren. Dieser Ansatz ist weitverbreitet, weil er so schön einfach ist - aber er ist auch unglaublich Fehleranfällig. Es ist einfach zu Vergessen in welchem Verzeichnis man gerade arbeitet und aus Versehen die falsche Datei zu speichern oder beim kopieren Dateien zu überschreiben, bei denen man dies nicht wollte.

Um diesen Problemen vorzubeugen haben findige Programmierer schon vor langer Zeit lokal arbeitende Versionskontrollsysteme entwickelt, die in einer einfachen Datenbank alle Änderungen speicherten (siehe Bild 1-1).

Insert 1833ig0101.png
Bild 1-1. Lokale Versionskontrollsysteme

Eines der populäreren lokalen Versionskontrollsystem ist RCS, welches auch heute noch auf vielen Computern mitgeliefert wird. Sogar das beliebte Mac OS X Betriebssystem stellt das rcs-Kommando mit der Installation der Developer Tools bereit. RCS funktioniert hauptsächlich indem es "Patch Sets" (die Unterschiede zwischen Dateien) von einer Änderung zur anderen in einem speziellen Format speichert. Es kann auf Basis dieser Daten jede Version zu jeder Zeit im Änderungsprozess wiederherstellen, indem es alle Patches nacheinander anwendet.

### Zentralisierte Versionskontrollsysteme ###

Das nächste größere Problem auf das Entwickler für Gewöhnlich stoßen, ist dass sie mit anderen Programmierern auf anderen Computersystemen zusammenarbeiten müssen. Um dieses Problem zu lösen wurden Zentralisierte Versionskontrollsysteme (CVCS - Centralized Version Control Systems) entwickelt. Diese Systeme, wie zum Beispiel CVS, Subversion und Perforce, haben einen einzigen Server der alle versionierten Dateien speichert. Alle Mitarbeiter müssen mit dem Repository auf diesem Server arbeiten, sie checken ihre Änderungen dort ein und holen sich die Änderungen ihrer Kollegen von dort ab. Dies war für viele Jahre der Standard für Versionskontrollsysteme (siehe Bild 1-2).

Insert 18333fig0102.png
Bild 1-2. Zentralisierte Versionskontrolle

Dieses zentrale Setup bringt viele Vorteile mit sich, insbesondere gegenüber lokalen Versionskontrollsystemen. Zum Beispiel hat jeder einen ungefähren Überblick was alle anderen gerade am Projekt tun. Administratoren können sehr granular bestimmen was wer tun darf, und es ist um Welten einfacher ein CVCS zu administrieren als z.B. lokale Datenbanken auf allen Entwicklercomputern in den Griff zu bekommen.

Wie auch immer, dieses Setup bringt leider auch einige gewichtige Nachteile mit sich. Der am meisten offensichtliche ist der "Single Point of Failure", welchen der zentrale Server darstellt. Wenn dieser Server für eine Stunde nicht verfügbar ist, kann während dieser Zeit keiner seine Änderungen an Dateien speichern oder aktualisieren. Wenn die Festplatte des Servers über den Jordan geht und keine ordentlichen Backups existieren, verliert man die komplette Arbeit - bis auf die einzelnen Snapshots auf den Computern der Mitarbeiter; diese enthalten aber meist nicht die Versionshistorie des Projektes.

### Verteilte Versionskontrollsysteme ###

Hier kommen verteilte Versionskontrollsystem (Distributed Version Control Systems, DVCSs) ins Spiel. In einem DVCS (wie zum Beispiel Git, Mercurial, Bazaar oder Darcs), checken die Clients nicht nur den neuesten Stand der Dateien aus: Sie erstellen eine Kopie des kompletten Repositories inklusive der Versionshistorie. Wenn nun der Server, über den diese Systeme miteinander arbeiten, eine Fehlfunktion hat, kann jeder der Clients sein lokales Repository zurueckkopiert werden um den Server wiederherzustellen. Jeder checkout ist somit ein echtes, volles Backup aller Daten auf dem Server.

Insert 18333fig0103.png
Bild 1-3. Verteilte Versionskontrollsysteme.

Und das ist nicht alles: viele dieser Systeme kommen recht gut mit mehreren entfernten Repositories klar, auf diese Weise kann man mit verschiedenen Gruppen auf verschiedene Weise gleichzeitig zusammenarbeiten. Dies erlaubt verschiedene Workflows zu etablieren, die in zentralisierten Entwicklungsprozessen nicht möglich wären, wie zum Beispiel hierarchische Modelle.

## Eine kurzer geschichtlicher Überblick über die Entstehung von Git ##

Wie viele großartige Dinge im Leben begann die Entwicklung von Git mit einer Portion kreativer Zerstörung und kontroversen Diskussionen. Der Linux-Kernel ist ein Projekt mit ziemlich großen Ausmaßen. Den größten Teil der Linux Kernelentwicklung (1991-2002) wurden Änderungen am Quellcode als Patchsets und Dateiarchive durch die Welt gesendet. 2002 begann das Linux-Kernel Projekt ein proprietäres DVCS namens BitKeeper einzusetzen.

2005 verschlechterten sich die Beziehungen zwischen der Community die den Linux-Kernel entwickelte und der kommerziellen Firma die BitKeeper entwickelte, als BitKeeper nicht mehr kostenlos benutzt werden durfte. Dies veranlasste die Linux-Kernel Entwicklergemeinde (und im speziellen Linus Torvalds, der Urheber des Linux-Kernels) basierend auf den mit BitKeeper gemachten Erfahrungen ihr eigenes Werkzeug zu entwickeln. Einige der Ziele des neuen Systems waren:

*       Geschwindigkeit
*       einfaches Design
*       gute Unterstützung für nicht-lineare Entwicklung (tausende paralleler Entwicklungszweige
*       komplett Verteilt
*       Möglichkeit große Projekte wie das Linux-Kernelprojekt effizient in den Griff zu bekommen (Geschwindigkeit und Datenmenge)

Seit seinem Entstehen in 2005 hat sich Git weiterentwickelt und ist zu einem einfach benutzbarem System gereift, welches trotzdem diese initialen Zielsetzungen erfüllt. Es ist unglaublich schnell, sehr effizient bei großen Projekten, und es hat ein fantastisches Branching-System um mit mehreren Entwicklungszweigen nicht-linear entwickeln zu können (siehe Kapitel 3).



