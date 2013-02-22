# Los geht's #

In diesem Kapitel wird es darum gehen, wie man mit Git loslegen kann. Wir werden erläutern, wozu Versionskontrollsysteme gut sind, wie man Git auf verschiedenen Systemen installieren und konfigurieren kann, so dass man in der Lage ist, mit der Arbeit anzufangen. Am Ende dieses Kapitels solltest Du verstehen, wozu Git gut ist, weshalb Du es verwenden solltest und wie Du damit loslegen kannst.

## Wozu Versionskontrolle? ##

Was ist Versionskontrolle, und warum solltest Du dich dafür interessieren? Versionskontrollsysteme (VCS) protokollieren Änderungen an einer Datei oder einer Anzahl von Dateien über die Zeit hinweg, so dass man zu jedem Zeitpunkt auf Versionen und Änderungen zugreifen kann. Die Beispiele in diesem Buch verwenden Software Quellcode, tatsächlich aber kannst Du Änderungen an praktisch jeder Art von Datei per Versionskontrolle nachverfolgen.

Als ein Grafik- oder Webdesigner zum Beispiel willst Du in der Lage sein, jede Version eines Bildes oder Layouts zurückverfolgen zu können. Es wäre daher sehr ratsam, ein Versionskontrollsystem zu verwenden. Ein solches System erlaubt Dir, einzelne Dateien oder auch ein ganzes Projekt in einen früheren Zustand zurückzuversetzen, nachzuvollziehen, wer zuletzt welche Änderungen vorgenommen hat, die möglicherweise Probleme verursachen, wer eine Änderung ursprünglich vorgenommen hat usw. Ein Versionskontrollsystem für Deine Arbeit zu verwenden, versetzt dich in die Lage jederzeit zu einem vorherigen, funktionierenden Zustand zurückzugehen, wenn Du vielleicht Mist gebaut oder aus irgendeinem Grunde Dateien verloren hast. All diese Vorteile erhältst Du für einen nur sehr geringen, zusätzlichen Aufwand.

### Lokale Versionskontrollsysteme ###

Viele Leute kontrollieren Versionen ihrer Arbeit, indem sie einfach Dateien in ein anderes Verzeichnis kopieren (wenn sie clever sind: ein Verzeichnis mit einem Zeitstempel im Namen). Diese Vorgehensweise ist üblich, weil sie so einfach ist. Aber sie ist auch unglaublich fehleranfällig. Man vergisst sehr leicht, in welchem Verzeichnis man sich gerade befindet und kopiert die falschen Dateien oder überschreibt Dateien, die man eigentlich nicht überschreiben wollte.

Um diese Arbeit zu erleichtern und sicherer zu machen, haben Programmierer vor langer Zeit Versionskontrollsysteme entwickelt, die alle Änderungen an allen relevanten Dateien in einer lokalen Datenbank verfolgten (siehe Bild 1-1).

Insert 18333fig0101.png
Bild 1-1. Diagramm: Lokale Versionskontrolle

Eines der populärsten Versionskontrollsysteme war rcs, und es wird heute immer noch mit vielen Computern ausgeliefert. Z.B. umfasst auch das Betriebssystem Mac OS X den Befehl rcs, wenn Du die Developer Tools installierst. Dieser Befehl arbeitet nach dem Prinzip, dass er für jede Änderung einen Patch (d.h. eine Kodierung der Unterschiede, die eine Änderung an einer oder mehreren Dateien umfasst) in einem speziellen Format in einer Datei auf der Festplatte speichert.

### Zentralisierte Versionskontrollsysteme ###

Das nächste Problem, mit dem Programmierer sich dann konfrontiert sahen, bestand in der Zusammenarbeit mit anderen: Änderungen an dem gleichen Projekt mussten auf verschiedenen Computern, möglicherweise verschiedenen Betriebssystemen vorgenommen werden können. Um dieses Problem zu lösen, wurden Zentralisierte Versionskontrollsysteme (CVCS) entwickelt. Diese Systeme, beispielsweise CVS, Subversion und Perforce, basieren auf einem zentralen Server, der alle versionierten Dateien verwaltet. Wer an diesen Dateien arbeiten will, kann sie von diesem Server abholen ("check out" xxx), auf seinem eigenen Computer bearbeiten und dann wieder auf dem Server abliefern. Diese Art von System war über viele Jahre hinweg der Standard für Versionskontrollsysteme (siehe Bild 1-2).

Insert 18333fig0102.png
Bild 1-2. Diagramm: Zentralisierte Versionskontrollsysteme

Dieser Aufbau hat viele Vorteile gegenüber Lokalen Versionskontrollsystemen. Zum Beispiel weiß jeder mehr oder weniger genau darüber Bescheid, was andere, an einem Projekt Beteiligte gerade tun. Administratoren haben die Möglichkeit, detailliert festzulegen, wer was tun kann. Und es ist sehr viel einfacher, ein CVCS zu administrieren als lokalen Datenbanken auf jedem einzelnen Anwenderrechner zu verwalten.

Allerdings hat dieser Aufbau auch einige erhebliche Nachteile. Der offensichtlichste Nachteil ist der "Single Point of Failure", den der zentralisierte Server darstellt. Wenn dieser Server für nur eine Stunde nicht verfügbar ist, dann kann in dieser Stunde niemand in irgendeiner Form mit anderen arbeiten oder versionierte Änderungen an den Dateien speichern, an denen sie momentan arbeiten. Wenn die auf dem zentralen Server verwendete Festplatte beschädigt wird und keine Sicherheitskopien erstellt wurden, dann sind all diese Daten unwiederbringlich verloren - die komplette Historie des Projektes, abgesehen natürlich von dem jeweiligen Zustand, den Mitarbeiter gerade zufällig auf ihrem Rechner haben. Lokale Versionskontrollsysteme haben natürlich dasselbe Problem: wenn man die Historie eines Projektes an einer einzigen, zentralen Stelle verwaltet, riskiert man, sie vollständig zu verlieren, wenn irgendetwas an dieser zentralen Stelle ersthaft schief läuft.

### Verteilte Versionskontrollsysteme ###

Und an dieser Stelle kommen verteilte Versionskontrollsysteme (DVCS) ins Spiel. In einem DVCS (wie z.B. Git, Mercurial, Bazaar oder Darcs) erhalten Anwender nicht einfach den jeweils letzten Snapshot des Projektes von einem Server: sie erhalten statt dessen eine vollständige Kopie des Repositories. Auf diese Weise kann, wenn ein Server beschädigt wird, jedes beliebige Repository von jedem beliebigen Anwenderrechner zurück kopiert und der Server so wieder hergestellt werden.

Insert 18333fig0103.png
Bild 1-3. Diagramm: Distribuierte Versionskontrolle

Darüber hinaus können derartige Systeme hervorragend mit verschiedenen externen ("remote") Repositories umgehen, so dass man mit verschiedenen Gruppen von Leuten simultan in verschiedenen Weisen zusammenarbeiten kann. Das macht es möglich, verschiedene Arten von Arbeitsabläufen (wie Hierarchien) zu integrieren, was mit zentralisierten Systemen nicht möglich ist.

## Die Geschichte von Git ##

Wie viele großartige Dinge im Leben entstand Git aus kreativem Chaos und hitziger Diskussion. Der Linux Kernel ist ein Open Source Software Projekt von erheblichem Umfang. Während der gesamten Entwicklungszeit des Linux Kernels von 1991 bis 2002 wurden Änderungen an der Software in Form von Patches (d.h. Änderungen an bestehendem Code) und archivierten Dateien herumgereicht. 2002 began man dann, ein proprietäres DVCS System mit dem Namen "Bitkeeper" zu verwenden.

2005 ging die Beziehung zwischen der Community, die den Linux Kernel entwickelte, und des kommerziell ausgerichteten Unternehmens, das BitKeeper entwickelte, dann in die Brüche. Die zuvor ausgesprochene Erlaubnis, BitKeeper kostenlos zu verwenden, wurde widerrufen. Dies war für die Linux Entwickler Community der Auslöser dafür, ein eigenes Tool zu entwickeln, das auf den Erfahrungen mit BitKeeper basierte. Ziele des neuen Systems waren unter anderem:

* Geschwindigkeit
* Einfaches Design
* Gute Unterstützung von nicht-linearer Entwicklung (tausende paralleler Branches, d.h. verschiedener Verzweigungen der Versionen)
* Vollständig verteilt
* Fähig, große Projekte wie den Linux Kernel effektiv zu verwalten (Geschwindigkeit und Datenumfang)

Seit seiner Geburt 2005 entwickelte sich Git kontinuierlich weiter und reifte zu einem System heran, das einfach zu bedienen ist, die ursprünglichen Ziele dabei aber weiter beibehält. Es ist unglaublich schnell, äußerst effizient, wenn es um große Projekte geht, und es hat ein fantastisches Branching Konzept für nicht-lineare Entwicklung (mehr dazu in Kapitel 3).

## Git Grundlagen ##

Was also ist Git, in kurzen Worten? Es ist wichtig, den folgenden Abschnitt zu verstehen, in dem es um die grundlegenden Konzepte von Git geht. Das wird dich in die Lage versetzen, Git einfacher und effektiver anzuwenden. Versuche dein vorhandenes Wissen über andere Versionskontrollsysteme, wie Subversion oder Perforce, zu ignorieren, während Du Git lernst. Git speichert und konzipiert Information anders als andere Systeme, auch wenn das Interface relativ ähnlich wirkt. Diese Unterschiede zu verstehen wird dir helfen, Verwirrung bei der Anwendung von Git zu vermeiden.

### Snapshots, nicht Diffs ###

Der Hauptunterschied zwischen Git und anderen Versionskontrollsystemen (auch Subversion und vergleichbaren Systemen) besteht in der Art und Weise wie Git Daten betrachtet. Die meisten anderen Systeme speichern Information als eine fortlaufende Liste von Änderungen an Dateien ("Diffs"). Diese Systeme (CVS, Subversion, Perforce, Bazaar usw.) betrachten die Informationen, die sie verwalten, als eine Menge von Dateien und die Änderungen, die über die Zeit hinweg an einzelnen Dateien vorgenommen werden. (Siehe Bild 1-4.)

Insert 18333fig0104.png
Bild 1-4. Andere Systeme speichern Daten als Änderungen an einzelnen Dateien einer Datenbasis

Git sieht Daten nicht in dieser Weise. Stattdessen betrachtet Git seine Daten eher als eine Reihe von Snapshots eines Mini-Dateisystems. Jedes Mal, wenn Du committest (d.h. den gegenwärtigen Status deines Projektes als eine Version in Git speicherst), sichert Git den Zustand sämtlicher Dateien in diesem Moment ("Snapshot") und speichert eine Referenz auf diesen Snapshot. Um dies möglichst effizient und schnell tun zu können, kopiert Git unveränderte Dateien nicht, sondern legt lediglich eine Verknüpfung zu der vorherigen Version der Datei an. Git betrachtet Daten also wie in Bild 1-5 dargestellt.

Insert 18333fig0105.png
Bild 1-5. Git speichert Daten als eine Historie von Snapshots des Projektes.

Dies ist ein wichtiger Unterschied zwischen Git und praktisch allen anderen Versionskontrollsystemen. In Git wurden daher fast alle Aspekte der Versionskontrolle neu überdacht, die in anderen Systemen mehr oder weniger von ihren jeweiligen Vorgängergeneration übernommen worden waren. Git arbeitet im Großen und Ganzen eher wie ein (mit einigen unglaublich mächtigen Werkezeugen ausgerüstetes) Mini-Dateisystem, als wie ein gängiges Versionskontrollsystem. Auf einige der Vorteile, die es mit sich bringt, Daten in dieser Weise zu betrachten, werden wir in Kapitel 3 eingehen, wenn wir das Git Branching Konzept diskutieren.

### Fast jede Operation ist lokal ###

Die meisten Operationen in Git benötigen nur die lokalen Dateien und Ressourcen auf deinem Rechner, um zu funktionieren. D.h. im Allgemeinen werden keine Informationen von einem anderen Rechner im Netzwerk benötigt. Wenn Du mit einem CVCS gearbeitet hast, das für die meisten Operationen einen Netzwerk Latency Overhead (also Wartezeiten, die das Netzwerk benötigt werden) hat, dann wirst Du den Eindruck haben, dass die Götter der Geschwindigkeit Git mit unaussprechlichen Fähigkeiten ausgestattet haben. Weil man die vollständige Historie lokal auf dem Rechner hat, werden die allermeisten Operationen ohne jede Verzögerung ausgeführt und sind sehr schnell.

Um beispielsweise die Historie des Projektes zu durchsuchen, braucht Git sie nicht von einem externen Server zu holen - es liest sie einfach aus der lokalen Datenbank. Das heißt, Du siehst die vollständige Projekthistorie ohne jede Verzögerung. Wenn Du sehen willst, worin sich die aktuelle Version einer Datei von einer Version von vor einem Monat unterscheidet, dann kann Git diese Versionen lokal nachschlagen und ihre Unterschiede lokal bestimmen. Es braucht dazu keinen externen Server - weder um Dateien dort nachzuschlagen, noch um Unterschiede dort bestimmen zu lassen.

Dies bedeutet natürlich außerdem, dass es fast nichts gibt, was Du nicht tun kannst, bloß weil Du gerade offline bist oder keinen Zugriff auf ein VPN hast. Wenn Du im Flugzeug oder Zug ein wenig arbeiten willst, kannst Du problemlos deine Arbeit committen und deine Arbeit erst auf den Server pushen (hochladen), wenn Du wieder mit einem Netzwerk verbunden bist. Wenn Du zu Hause bist aber nicht auf das VPN zugreifen kannst, kannst Du dennoch arbeiten. Perforce z.B. erlaubt dir dagegen nicht sonderlich viel zu tun, solange Du nicht mit dem Server verbunden bist. Und in Subversion und CVS kannst Du Dateien zwar ändern, die Änderungen aber nicht in der Datenbank sichern (weil die Datenbank offline ist). Das mag auf den ersten Blick nicht nach einem großen Problem aussehen, aber Du wirst überrascht sein, was für einen großen Unterschied das ausmachen kann.

### Git stellt Integrität sicher ###

In Git werden Änderungen in Checksummen umgerechnet, bevor sie gespeichert werden. Anschließend werden sie mit dieser Checksumme referenziert. Das macht es unmöglich, dass sich die Inhalte von Dateien oder Verzeichnissen ändern, ohne dass Git das mitbekommt. Git basiert auf dieser Funktionalität und sie ist ein integraler Teil von Gits Philosophie. Man kann Informationen deshalb z.B. nicht während der Übermittlung verlieren oder unwissentlich beschädigte Dateien verwenden, ohne dass Git in der Lage wäre, dies festzustellen.

Der Mechanismus, den Git verwendet, um diese Checksummen zu erstellen, heißt SHA-1 Hash. Eine solche Checksumme ist eine 40 Zeichen lange Zeichenkette, die aus hexadezimalen Zeichen besteht und diese wird von Git aus den Inhalten einer Datei oder Verzeichnisstruktur kalkuliert. Ein SHA-1 Hash sieht wie folgt aus:

	24b9da6552252987aa493b52f8696cd6d3b00373

Dir werden solche Hash Werte überall in Git begegnen, weil es sie so ausgiebig benutzt. Tatsächlich speichert und referenziert Git Informationen über Dateien in der Datenbank nicht nach ihren Dateinamen sondern nach den Hash Werten ihrer Inhalte.

### Git verwaltet fast ausschließlich Daten ###

Fast alle Operationen, die Du in der täglichen Arbeit mit Git verwendest, fügen Daten jeweils nur zur internen Git Datenbank hinzu. Deshalb ist es sehr schwer, das System dazu zu bewegen, irgendetwas zu tun, das nicht wieder rückgängig zu machen ist, oder dazu, Daten in irgendeiner Form zu löschen. In jedem anderen VCS ist es leicht, Änderungen, die man noch nicht gespeichert hat, zu verlieren oder unbrauchbar zu machen. In Git dagegen ist es schwierig, einen einmal gespeicherten Snapshot zu verlieren, insbesondere wenn man regelmäßig in ein anderes Repository pusht.

U.a. deshalb macht es so viel Spaß, mit Git zu arbeiten. Man kann mit Änderungen experimentieren, ohne befürchten zu müssen, irgendetwas zu zerstören oder durcheinander zu bringen. Einen tieferen Einblick in die Art, wie Git Daten speichert und wie man Daten, die scheinbar verloren sind, wieder herstellen kann, wird Kapitel 9 gewähren.

### Die drei Zustände ###

Jetzt aufgepasst. Es folgt die wichtigste Information, die Du dir merken mußt, wenn Du Git lernen und Fallstricke vermeiden willst. Git definiert drei Haupt-Zustände, in denen sich eine Datei befinden kann: committed, modified ("geändert") und staged ("vorgemerkt"). "Committed" bedeutet, dass die Daten in der lokalen Datenbank gesichert sind. "Modified" bedeutet, dass die Datei geändert, diese Änderung aber noch nicht committed wurde. "Staged" bedeutet, dass Du eine geänderte Datei in ihrem gegenwärtigen Zustand für den nächsten Commit vorgemerkt hast.

Das führt uns zu den drei Hauptbereichen eines Git Projektes: das Git Verzeichnis, das Arbeitsverzeichnis und die Staging Area.

Insert 18333fig0106.png
Bild 1-6. Arbeitsverzeichnis, Staging Area (xxx) und Git Verzeichnis

Das Git Verzeichnis ist der Ort, an dem Git Metadaten und die lokale Datenbank für dein Projekt speichert. Dies ist der wichtigste Teil von Git, und dieser Teil wird kopiert, wenn Du ein Repository von einem anderen Rechner klonst.

Dein Arbeitsverzeichnis ist ein Checkout ("Abbild" xxx) einer spezifischen Version des Projektes. Diese Dateien werden aus der komprimierten Datenbank geholt und auf der Festplatte in einer Form gespeichert, die Du bearbeiten und modifizieren kannst.

Die Staging Area ist einfach eine Datei (normalerweise im Git Verzeichnis), in der vorgemerkt wird, welche Änderungen dein nächster Commit umfassen soll. Sie wird manchmal auch als "Index" bezeichnet, aber der Begriff "Staging Area" ist der gängigere.

Der grundlegend Git Arbeitsprozess sieht in etwa so aus:

1. Du bearbeitest Dateien in deinem Arbeitsverzeichnis.
2. Du markierst Dateien für den nächsten Commit, indem Du Snapshots zur Staging Area hinzufügst.
3. Du legst den Commit an, wodurch die in der Staging Area vorgemerkten Snapshots dauerhaft im Git Verzeichnis (d.h. der lokalen Datenbank) gespeichert werden.

Wenn eine bestimmte Version einer Datei im Git Verzeichnis liegt, gilt sie als "committed". Wenn sie geändert und in der Staging Area vorgemerkt ist, gilt sie als "staged". Und wenn sie geändert, aber noch nicht zur Staging Area hinzugefügt wurde, gilt sie als "modified". In Kapitel 2 wirst Du mehr über diese Zustände lernen und darüber, wie Du sie sinnvoll einsetzen und wie Du den Zwischenschritt der Staging Area auch einfach überspringen kannst.

## Git installieren ##

Laß uns damit anfangen, Git tatsächlich zu verwenden. Der erste Schritt besteht natürlich darin, Git zu installieren und das kann, wie üblich, auf unterschiedliche Weisen geschehen. Die beiden wichtigsten bestehen darin, entweder den Quellcode herunterzuladen und selbst zu kompilieren oder ein fertiges Paket für dein Betriebssystem zu installieren.

### Vom Quellcode aus installieren ###

Wenn es dir möglich ist, empfehlen wir, Git vom Quellcode aus zu installieren, weil Du die jeweils neueste Version erhältst. In der Regel bringt jede Version nützliche Verbesserungen (z.B. am Interface), so dass es sich lohnt die jeweils neueste Version zu verwenden - sofern Du natürlich damit klarkommst, Software aus dem Quellcode zu kompilieren. Viele Linux Distributionen umfassen sehr alte Git Versionen. Wenn Du also keine sehr aktuelle Distribution oder Backports (xxx) verwendest, empfehlen wir, diesen Weg in Erwägung ziehen.

Um Git zu installieren, benötigst Du die folgenden Bibliotheken, die von Git verwendet werden: curl, zlib, openssl, expat und libiconv. Wenn Dir auf deinem System yum (z.B. auf Fedora) oder apt-get (z.B. auf Debian-basierten Systemen) zur Verfügung steht, kannst Du einen der folgenden Befehle verwenden, um diese Abhängigkeiten zu installieren:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

Nachdem Du die genannten Bibliotheken installiert hast, besorge dir die aktuelle Version des Git Quellcodes von der Git Webseite:

	http://git-scm.com/download

Danach kannst Du dann Git kompilieren und installieren:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Von nun an kannst Du Git mit Hilfe von Git selbst aktualisieren:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Installation unter Linux ###

Wenn Du Git unter Linux mit einem Installationsprogramm installieren willst, kannst Du das normalerweise mit dem Paketmanager tun, der von deinem Betriebssystem verwendet wird. Unter Fedora zum Beispiel kannst Du yum verwenden:

	$ yum install git-core

Auf einem Debian-basierten System wie Ubuntu steht dir apt-get zur Verfügung:

	$ apt-get install git

### Installation unter Mac OS X ###

Auf einem Mac kann man Git auf zwei Arten installieren. Der einfachste ist, das grafische Git Installationsprogramm zu verwenden, den man von der Google Code Webseite herunterladen kann (siehe Bild 1-7)

http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png
Bild 1-7. Git OS X Installationsprogramm

Die andere Möglichkeit ist, Git via MacPorts (http://www.macports.org) zu installieren. Wenn Du MacPorts auf deinem System hast, installiert der folgende Befehl Git:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Du brauchst die optionalen Features natürlich nicht mit zu installieren, aber es macht Sinn `+svn` zu verwenden, falls Du jemals Git mit einem Subversion Repository verwenden willst.

### Installation unter Windows ###

Das msysGit Projekt macht die Installation von Git unter Windows sehr einfach. Lade einfach das Installationsprogramm für Windows von der GitHub Webseite herunter und führe es aus:

	http://msysgit.github.com/

Danach hast Du sowohl eine Kommandozeilenversion (inklusive eines SSH Clients, der sich später noch als nützlich erweisen wird) als auch die Standard GUI installiert.

## Git konfigurieren ##

Nachdem Du jetzt Git auf deinem System installiert hast, solltest Du deine Git Konfiguration anpassen. Das brauchst Du nur einmal zu tun, die Konfiguration bleibt auch bestehen, wenn Du Git auf eine neuere Version aktualisierst. Du kannst sie jederzeit ändern, indem Du die folgenden Befehle einfach noch einmal ausführst.

Git umfasst das Werkzeug `git config`, das dir erlaubt, Konfigurationswerte zu verändern. Auf diese Weise kannst Du anpassen, wie Git aussieht und arbeitet. Diese Werte sind an drei verschiedenen Orten gespeichert:

* Die Datei `/etc/gitconfig` enthält Werte, die für jeden Anwender des Systems und all ihre Projekte gelten. Wenn Du `git config` mit der Option `--system` verwendest, wird diese Datei verwendet.
* Die Werte in der Datei `~/.gitconfig` gelten ausschließlich für dich und all deine Projekte. Wenn Du `git config` mit der Option `--global` verwendest, wird diese Datei verwendet.
* Die Datei `.git/config` im Git Verzeichnis eines Projektes enthält Werte, die nur für das jeweilige Projekt gelten. Diese Dateien überschreiben Werte aus den jeweils vorhergehenden Dateien in dieser Reihenfolge. D.h. Werte in beispielsweise `.git/config` überschreiben diejenigen in `/etc/gitconfig`.

Auf Windows Systemen sucht Git nach der `.gitconfig` Datei im `$HOME` Verzeichnis (für die meisten Leute ist das das Verzeichnis `C:\Dokumente und Einstellungen\$USER`). Git sucht außerdem auch nach dem Verzeichnis /etc/gitconfig, aber es sucht relativ demjenigen Verzeichnis, in dem Du Git mit Hilfe des Installers installiert hast.

### Deine Identität ###

Nachdem Du Git installiert hast, solltest Du als erstes deinen Namen und deine E-Mail Adresse konfigurieren. Das ist wichtig, weil Git diese Information für jeden Commit verwendet, den Du anlegst, und sie ist unveränderlich in deine Commits eingebaut (xxx):

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Du brauchst diese Konfiguration, wie schon erwähnt, nur einmal vorzunehmen, wenn Du die `--global` Option verwendest, weil Git diese Information dann für all deine Projekte verwenden wird. Wenn Du sie für ein spezielles Projekt mit einem anderen Namen oder einer anderen E-Mail Adresse überschreiben willst, kannst Du dazu den Befehl ohne die `--global` Option innerhalb dieses Projektes ausführen.

### Dein Editor ###

Nachdem Du deine Identität jetzt konfiguriert hast, kannst Du einstellen, welchen Texteditor Git in Situationen verwenden soll, in denen Du eine Nachricht eingeben mußt. Normalerweise verwendet Git den Standard-Texteditor deines Systems - das ist üblicherweise Vi oder Vim. Wenn Du einen anderen Texteditor, z.B. Emacs, verwenden willst, kannst Du das wie folgt festlegen:

	$ git config --global core.editor emacs

### Dein Diff Programm ###

Eine andere nützliche Einstellung, die Du möglicherweise vornehmen willst, ist welches Diff Programm Git verwendet. Mit diesem Programm kannst Du Konflikte auflösen, die während der Arbeit mit Git manchmal auftreten. Wenn Du beispielsweise vimdiff verwenden willst, kannst Du das so festlegen:

	$ git config --global merge.tool vimdiff

Git kann von Hause aus mit den folgenden Diff Programmen arbeiten: kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff. Außerdem kannst Du ein eigenes Programm aufsetzen. Wir werden in Kapitel 7 darauf eingehen, wie das geht.

### Deine Einstellungen überprüfen ###

Wenn Du deine Einstellungen überprüfen willst, kannst Du mit dem Befehl `git config --list` alle Einstellungen anzuzeigen, die Git an dieser Stelle (z.B. innerhalb eines bestimmten Projektes) bekannt sind:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Manche Variablen werden möglicherweise mehrfach aufgelistet, weil Git dieselbe Variable in verschiedenen Dateien (z.B. `/etc/gitconfig` und `~/.gitconfig`) findet. In diesem Fall verwendet Git dann den jeweils zuletzt aufgelisteten Wert.

Außerdem kannst Du mit dem Befehl `git config {key}` prüfen, welchen Wert Git für einen bestimmten Variablennamen verwendet:

	$ git config user.name
	Scott Chacon

## Hilfe finden ##

Falls Du jemals Hilfe in der Anwendung von Git benötigst, gibt es drei Möglichkeiten, die entsprechende Seite aus der Dokumentation (manpage) für jeden Git Befehl anzuzeigen:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Beispielsweise erhältst Du die Hilfeseite für den `git config` Befehl so:

	$ git help config

Die "manpage" Dokumentation ist nützlich, weil Du sie jederzeit anzeigen kannst, auch wenn Du offline bist. Wenn dir die manpages und dieses Buch nicht ausreichen, kannst Du deine Fragen auch in den Chaträumen `#git` oder `#github` auf dem Freenode IRC Server (irc.freenode.net) stellen. Diese Räume sind in der Regel sehr gut besucht. Normalerweise findet sich unter den hunderten von Anwendern, die oft sehr viel Erfahrung mit Git haben, irgendjemand, der deine Fragen gern beantwortet.

## Zusammenfassung ##

Du solltest jetzt ein grundlegendes Verständnis davon haben, was Git ist und wie es sich von anderen CVCS unterscheidet, die Du möglicherweise schon verwendet hast. Du solltest außerdem eine funktionierende Git Version auf deinem Rechner installiert und konfiguriert haben. Jetzt wird es Zeit, einige Git Grundlagen zu besprechen.
