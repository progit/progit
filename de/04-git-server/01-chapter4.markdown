<!--# Git on the Server #-->
# Git auf dem Server #

<!--At this point, you should be able to do most of the day-to-day tasks for which you’ll be using Git. However, in order to do any collaboration in Git, you’ll need to have a remote Git repository. Although you can technically push changes to and pull changes from individuals’ repositories, doing so is discouraged because you can fairly easily confuse what they’re working on if you’re not careful. Furthermore, you want your collaborators to be able to access the repository even if your computer is offline — having a more reliable common repository is often useful. Therefore, the preferred method for collaborating with someone is to set up an intermediate repository that you both have access to, and push to and pull from that. We’ll refer to this repository as a "Git server"; but you’ll notice that it generally takes a tiny amount of resources to host a Git repository, so you’ll rarely need to use an entire server for it.-->

Zum jetzigen Zeitpunkt solltest Du in der Lage sein, die am häufigsten wiederkehrenden Aufgaben mit Git zu lösen. Um eine Zusammenarbeit zu ermöglichen solltest Du jedoch darüber nachdenken, ein externes Repository zur Verfügung stellen. Wenngleich es technisch möglich ist, direkt mit Repositories Anderer zu arbeiten und Änderungen dorthin zu pushen oder von dort zu holen, ist dieses Vorgehen verpöhnt, da es sehr leicht die Arbeit Anderer durcheinander zu bringen. Wenn man nicht vorsichtig ist, verliert man schnell den Überblick darüber wer woran arbeitet. Des weiteren erfordert der direkte Umgang mit Git Repositories, dass diese permanent verfügbar sind. Ein Repository auf dem eigenen Computer ist nur dann für alle Mitentwickler erreichbar, wenn der Computer läuft. Es macht deshalb Sinn, ein zentrales und zuverlässig erreichbares Repository einzurichten. Wir werden dieses Repository im Folgenden als „Git Server“ bezeichnen. Es sollte jedoch schnell klar werden, dass nur minimale Ressourcen notwendig sind, um Git Repositories zu hosten. In den seltensten Fällen ist ein dedizierter Server dafür notwendig.

<!--Running a Git server is simple. First, you choose which protocols you want your server to communicate with. The first section of this chapter will cover the available protocols and the pros and cons of each. The next sections will explain some typical setups using those protocols and how to get your server running with them. Last, we’ll go over a few hosted options, if you don’t mind hosting your code on someone else’s server and don’t want to go through the hassle of setting up and maintaining your own server.-->

Einen Git Server zu betreiben ist einfach. Die erste Entscheidung, die zu treffen ist, ist die des zu verwendenden Protokolls zur Kommunikation mit dem Server. Der erste Teil dieses Kapitels wird deshalb die zur Verfügung stehenden Protokolle und ihre Vor- und Nachteile beschreiben. Darüber hinaus werden einige typische Konfigurationen zum Betreiben eines Git Servers vorgestellt. Falls keine Bedenken bestehen, Code von externen Anbietern hosten zu lassen, werden zuletzt ein paar Optionen für gehostete Git Repositories aufgezeigt. Dies erspart die Mehrarbeit der Einrichtung und Wartung eines eigenen Git Servers.

<!--If you have no interest in running your own server, you can skip to the last section of the chapter to see some options for setting up a hosted account and then move on to the next chapter, where we discuss the various ins and outs of working in a distributed source control environment.-->

Wenn Du kein Interesse am Betreiben eines eigenen Servers hast, kannst Du zum letzten Absatz des Kapitels springen, um ein paar Möglichkeiten zum Einrichten eines gehosteten Accounts zu sehen. Im nächsten Kapitel diskutieren wir verschiedene Vor- und Nachteile vom Arbeiten in einer verteilten Quellcode-Kontroll-Umgebung.

<!--A remote repository is generally a _bare repository_ — a Git repository that has no working directory. Because the repository is only used as a collaboration point, there is no reason to have a snapshot checked out on disk; it’s just the Git data. In the simplest terms, a bare repository is the contents of your project’s `.git` directory and nothing else.-->

Ein externes Repository ist im Allgemeinen ein _einfaches Repository_ – ein Git Repository ohne Arbeitsverzeichnis. Weil das Repository nur als Zusammenarbeitspunkt genutzt wird, gibt es keinen Grund, einen Schnappschuss ausgecheckt auf der Festplatte zu haben; es sind nur die Git Daten. Mit einfachen Begriffen, ein einfaches Repository ist der Inhalt von Deinem `.git` Verzeichnis in Deinem Projekt und nichts anderes.

<!--## The Protocols ##-->
## Die Protokolle ##

<!--Git can use four major network protocols to transfer data: Local, Secure Shell (SSH), Git, and HTTP. Here we’ll discuss what they are and in what basic circumstances you would want (or not want) to use them.-->

Git kann vier wichtige Netzwerk Protokolle zum Datentransfer benutzen: Lokal, Secure Shell (SSH), Git und HTTP. Hier wollen wir diskutieren, was diese Protokolle sind und unter welchen grundlegenden Gegebenheiten Du sie benutzen möchtest (oder auch nicht).

<!--It’s important to note that with the exception of the HTTP protocols, all of these require Git to be installed and working on the server.-->

Es ist wichtig zu beachten, dass alle Protokolle mit Ausnahme von HTTP eine funktionierende Git Installation auf dem Server benötigen.

<!--### Local Protocol ###-->
### Lokales Protokoll ###

<!--The most basic is the _Local protocol_, in which the remote repository is in another directory on disk. This is often used if everyone on your team has access to a shared filesystem such as an NFS mount, or in the less likely case that everyone logs in to the same computer. The latter wouldn’t be ideal, because all your code repository instances would reside on the same computer, making a catastrophic loss much more likely.-->

Am einfachsten ist das _Lokale Protokoll_, wobei das externe Repository in einem anderen Verzeichnis auf der Festplatte ist. Das wird oft genutzt, wenn jeder aus Deinem Team Zugriff zu einem gemeinsamen Dateisystem hat, zum Beispiel ein eingebundenes NFS, oder im unwahrscheinlicheren Fall jeder loggt sich auf bei dem gleichen Computer ein. Das letztere ist nicht ideal, weil alle Code Repository Instanzen auf dem selben Computer wären, ein katastrophaler Verlust wäre wahrscheinlicher.

<!--If you have a shared mounted filesystem, then you can clone, push to, and pull from a local file-based repository. To clone a repository like this or to add one as a remote to an existing project, use the path to the repository as the URL. For example, to clone a local repository, you can run something like this:-->

Wenn Du ein gemeinsames Dateisystem eingebunden hast, kannst Du von einem lokalen Datei-basiertem Repository clonen, pushen und pullen. Um ein Repository wie dieses zu clonen, oder ein externes zu einem bestehenden Projekt hinzuzufügen, benutze den Pfad zu dem Repository als URL. Um zum Beispiel ein lokales Repository zu clonen kannst Du einen Befehl wie diesen nutzen:

	$ git clone /opt/git/project.git

<!--Or you can do this:-->

Oder Du kannst das machen:

	$ git clone file:///opt/git/project.git

<!--Git operates slightly differently if you explicitly specify `file://` at the beginning of the URL. If you just specify the path, and the source and the destination are on the same filesystem, Git tries to hardlink the objects it needs. If they are not on the same filesystem, it will copy the objects it needs using the system's standard copying functionality. If you specify `file://`, Git fires up the processes that it normally uses to transfer data over a network which is generally a lot less efficient method of transferring the data. The main reason to specify the `file://` prefix is if you want a clean copy of the repository with extraneous references or objects left out — generally after an import from another version-control system or something similar (see Chapter 9 for maintenance tasks). We’ll use the normal path here because doing so is almost always faster.-->

Git arbeitet etwas anders, wenn Du am Anfang der URL ausdrücklich `file://` angibst. Wenn Du nur den Pfad angibst, und sowohl die Quelle, als auch das Ziel sich auf dem selben Dateisystem befinden, versucht Git harte Links zu benutzen. Wenn sie sich nicht auf dem selben Dateisystem befinden, kopiert Git die benötigten Objekte mit Hilfe der Standardkopierfunktion des jeweiligen Betriebssystems. Wenn Du `file://` angibst, startet Git den Prozess, den es normalerweise zum Übertragen von Daten über ein Netzwerk verwendet, dass ist gewöhnlich eine wesentlich ineffizientere Methode zum Übertragen der Daten. Der Hauptgrund das `file://`-Präfix anzugeben ist eine saubere Kopie von dem Repository mit fremden Referenzen oder fehlenden Objekten – generell nach einem Import von einem anderen Versionskontrollsystem oder etwas ähnliches (siehe Kapitel 9 für Wartungsarbeiten). Wir benutzen hier den normalen Pfad, weil das fast immer schneller ist.

<!--To add a local repository to an existing Git project, you can run something like this:-->

Um ein lokales Repository zu einem existierenden Git Projekt hinzuzufügen, kannst Du einen Befehl wie diesen ausführen:

	$ git remote add local_proj /opt/git/project.git

<!--Then, you can push to and pull from that remote as though you were doing so over a network.-->

Dann kannst Du zu diesem externen Repository pushen und davon pullen, als würdest Du das über ein Netzwerk machen.

<!--#### The Pros ####-->
#### Die Vorteile ####

<!--The pros of file-based repositories are that they’re simple and they use existing file permissions and network access. If you already have a shared filesystem to which your whole team has access, setting up a repository is very easy. You stick the bare repository copy somewhere everyone has shared access to and set the read/write permissions as you would for any other shared directory. We’ll discuss how to export a bare repository copy for this purpose in the next section, “Getting Git on a Server.”-->

Die Vorteile von Datei-basierten Repositories sind die Einfachheit und das Nutzen bereits bestehender Datei-Berechtigungen und bestehendem Netzwerk-Zugriff. Wenn Du bereits ein gemeinsames Dateisystem hast, zu dem das gesamte Team Zugriff hat, ist das Einrichten eines Repositories sehr einfach. Du exportierst eine Kopie des einfachen Repositories dahin, wo jeder gemeinsamen Zugriff hat und stellst die Lese- und Schreibberechtigungen wie bei jedem anderem gemeinsamen Verzeichnis ein. Wir werden im nächsten Abschnitt „Git auf einen Server bekommen“ diskutieren, wie man die Kopie eines einfachen Repositories für diesen Zweck exportiert.

<!--This is also a nice option for quickly grabbing work from someone else’s working repository. If you and a co-worker are working on the same project and they want you to check something out, running a command like `git pull /home/john/project` is often easier than them pushing to a remote server and you pulling down.-->

Dies ist auch eine nette Möglichkeit zum schnellen Abholen von Änderungen aus dem Arbeitsverzeichnis von jemand anderem. Wenn Du und ein Kollege an dem gleichen Projekt arbeitet und ihr wollt etwas auschecken, dann ein Befehl wie `git pull /home/john/project` ist oft einfacher als das pushen zu einem externen Server und das pullen zurück.

<!--#### The Cons ####-->
#### Die Nachteile ####

<!--The cons of this method are that shared access is generally more difficult to set up and reach from multiple locations than basic network access. If you want to push from your laptop when you’re at home, you have to mount the remote disk, which can be difficult and slow compared to network-based access.-->

Die Nachteile von dieser Methode sind, dass ein gemeinsamer Zugriff im allgemeinen schwieriger einrichten ist und der Zugriff von mehreren Orten ist schwieriger als einfacher Netzwerk Zugriff. Wenn Du von Deinem Laptop zuhause pushen möchtest, musst Du eine entfernte Festplatte einbinden. Das kann schwierig und langsam sein, verglichen mit netzwerk-basiertem Zugriff.

<!--It’s also important to mention that this isn’t necessarily the fastest option if you’re using a shared mount of some kind. A local repository is fast only if you have fast access to the data. A repository on NFS is often slower than the repository over SSH on the same server, allowing Git to run off local disks on each system.-->

Es ist auch wichtig zu erwähnen, dass dies nicht unbedingt die schnellste Möglichkeit ist, wenn Du ein gemeinsames Dateisystem oder ähnliches hast. Ein lokales Repository ist nur dann schnell, wenn Du schnellen Zugriff auf die Daten hast. Ein NFS-basiertes Repository ist oftmals langsamer als ein Repository über SSH auf dem gleichen Server, weil Git über SSH auf jedem System auf den lokalen Festplatten arbeitet.

<!--### The SSH Protocol ###-->
### Das SSH Protokoll ###

<!--Probably the most common transport protocol for Git is SSH. This is because SSH access to servers is already set up in most places — and if it isn’t, it’s easy to do. SSH is also the only network-based protocol that you can easily read from and write to. The other two network protocols (HTTP and Git) are generally read-only, so even if you have them available for the unwashed masses, you still need SSH for your own write commands. SSH is also an authenticated network protocol; and because it’s ubiquitous, it’s generally easy to set up and use.-->

Das vermutlich gebräuchlichste Transport-Protokoll für Git ist SSH. Das hat den Grund, dass der SSH-Zugriff an den meisten Orten bereits eingerichtet ist – und wenn das nicht der Fall ist, einfach zu machen ist. SSH ist außerdem das einzige netzwerk-basierte Protokoll von dem man einfach lesen und darauf schreiben kann. Die beiden anderen Netzwerk-Protokolle (HTTP und Git) sind nur lesbar. Auch wenn sie für die breite Masse sind, brauchst Du trotzdem SSH für Deine Schreib-Befehle. SSH ist auch ein authentifiziertes Netzwerk-Protokoll, und weil es universell ist, ist es im Allgemeinen einfach einzurichten und zu benutzen.

<!--To clone a Git repository over SSH, you can specify ssh:// URL like this:-->

Um ein Git Repository über SSH zu clonen, kannst Du eine ssh:// URL angeben:

	$ git clone ssh://user@server/project.git

<!--Or you can use the shorter scp-like syntax for SSH protocol:-->

Oder Du kannst auch kein Protokoll angeben – Git nimmt SSH an, wenn Du nicht eindeutig bist:

	$ git clone user@server:project.git

<!--You can also not specify a user, and Git assumes the user you’re currently logged in as.-->

Du kannst auch keinen Benutzer angeben, und Git nimmt den Benutzer an, als der Du gerade eingeloggt bist.

<!--#### The Pros ####-->
#### Die Vorteile ####

<!--The pros of using SSH are many. First, you basically have to use it if you want authenticated write access to your repository over a network. Second, SSH is relatively easy to set up — SSH daemons are commonplace, many network admins have experience with them, and many OS distributions are set up with them or have tools to manage them. Next, access over SSH is secure — all data transfer is encrypted and authenticated. Last, like the Git and Local protocols, SSH is efficient, making the data as compact as possible before transferring it.-->

Die Vorteile von SSH sind vielseitig. Erstens, grundlegend musst Du es benutzen, wenn Du authentifizierten Schreib-Zugriff auf Dein Repository über ein Netzwerk haben möchtest. Zweitens, SSH ist relativ einfach einzurichten – SSH-Dämonen sind alltäglich, viele Netzwerk-Administratoren haben Erfahrungen mit ihnen und viele Betriebssysteme sind mit ihnen eingerichtet oder haben Werkzeuge um sie zu verwalten. Als nächstes, Zugriff über SSH ist sicher – der gesamte Daten-Transfer ist verschlüsselt und authentifiziert. Als letztes, wie Git und die lokalen Protokolle, SSH ist effizient, es macht die Daten so kompakt wie möglich bevor es die Daten überträgt.

<!--#### The Cons ####-->
#### Die Nachteile ####

<!--The negative aspect of SSH is that you can’t serve anonymous access of your repository over it. People must have access to your machine over SSH to access it, even in a read-only capacity, which doesn’t make SSH access conducive to open source projects. If you’re using it only within your corporate network, SSH may be the only protocol you need to deal with. If you want to allow anonymous read-only access to your projects, you’ll have to set up SSH for you to push over but something else for others to pull over.-->

Die negative Seite von SSH ist, dass Du Deine Repositories nicht anonym darüber anbieten kannst. Die Leute müssen Zugriff auf Deine Maschine über SSH haben um zuzugreifen, auch mit einem Nur-Lese-Zugriff, was SSH nicht zuträglich zu Open-Source-Projekten macht. Wenn Du es nur innerhalb von Deinem Firmen-Netzwerk benutzt, SSH ist vielleicht das einzige Protokoll mit dem Du arbeiten musst. Wenn Du anonymen Nur-Lese-Zugriff zu Deinen Projekten erlauben willst, musst Du SSH für Dich einsetzen um zu pushen, aber ein anderes Protokoll für andere um zu pullen.

<!--### The Git Protocol ###-->
### Das Git Protokoll ###

<!--Next is the Git protocol. This is a special daemon that comes packaged with Git; it listens on a dedicated port (9418) that provides a service similar to the SSH protocol, but with absolutely no authentication. In order for a repository to be served over the Git protocol, you must create the `git-daemon-export-ok` file — the daemon won’t serve a repository without that file in it — but other than that there is no security. Either the Git repository is available for everyone to clone or it isn’t. This means that there is generally no pushing over this protocol. You can enable push access; but given the lack of authentication, if you turn on push access, anyone on the internet who finds your project’s URL could push to your project. Suffice it to say that this is rare.-->

Als nächstes kommt das Git Protokoll. Das ist ein spezieller Dämon, der zusammen mit Git kommt. Er horcht auf einem bestimmten Port (9418), dieser Service ist vergleichbar mit dem SSH-Protokoll, aber ohne jegliche Authentifizierung. Um ein Repository über das Git Protokoll, musst Du die `git-daemon-export-ok` Datei erstellen – der Dämon bietet kein Repository ohne die Datei darin an – außer dieser Datei gibt es keine Sicherheit. Entweder das Git Repository ist für jeden zum Clonen verfügbar oder halt nicht. Das bedeutet, dass dieses Protokoll generell kein push anbietet. Du kannst push-Zugriff aktivieren; aber ohne Authentifizierung, wenn Du den push-Zugriff aktivierst, kann jeder im Internet, der Deine Projekt-URL findet, zu Deinem Projekt pushen. Ausreichend zu sagen, dass das selten ist.

<!--#### The Pros ####-->
#### Die Vorteile ####

<!--The Git protocol is the fastest transfer protocol available. If you’re serving a lot of traffic for a public project or serving a very large project that doesn’t require user authentication for read access, it’s likely that you’ll want to set up a Git daemon to serve your project. It uses the same data-transfer mechanism as the SSH protocol but without the encryption and authentication overhead.-->

Das Git Protokoll ist das schnellste verfügbare Transfer Protokoll. Wenn Du viel Traffic für ein öffentliches Projekt hast oder ein sehr großes Projekt hast, dass keine Benutzer-Authentifizierung für den Lese-Zugriff voraussetzt, es ist üblich einen Git Dämon einzurichten, der Dein Projekt serviert. Er benutzt den selben Daten-Transfer Mechanismus wie das SSH-Protokoll, aber ohne den Entschlüsselungs- und Authentifizierungs-Overhead.

<!--#### The Cons ####-->
#### Die Nachteile ####

<!--The downside of the Git protocol is the lack of authentication. It’s generally undesirable for the Git protocol to be the only access to your project. Generally, you’ll pair it with SSH access for the few developers who have push (write) access and have everyone else use `git://` for read-only access.-->
<!--It’s also probably the most difficult protocol to set up. It must run its own daemon, which is custom — we’ll look at setting one up in the “Gitosis” section of this chapter — it requires `xinetd` configuration or the like, which isn’t always a walk in the park. It also requires firewall access to port 9418, which isn’t a standard port that corporate firewalls always allow. Behind big corporate firewalls, this obscure port is commonly blocked.-->

Die Negativseite des Git Protokoll ist das Fehlen der Authentifizierung. Es ist generell unerwünscht, dass das Git Protokoll der einzige Zugang zu dem Projekt ist. Im Allgemeinen willst Du es mit SSH-Zugriff für die Entwickler paaren, die push (Schreib) Zugriff haben und jeder andere benutzt `git://` für Nur-Lese-Zugriff.
Es ist vielleicht auch das das schwierigste Protokoll beim Einrichten. Es muss ein eigener Dämon laufen, welcher Git-spezifisch ist – wir wollen im „Gitosis“-Abschnitt in diesem Kapitel schauen, wie man einen einrichtet – es setzt eine `xinetd`-Konfiguration oder ähnliches voraus, das ist nicht immer ein Spaziergang. Es setzt auch einen Firewall-Zugriff auf den Port 9418 voraus, das ist kein Standard-Port, den Firmen-Firewalls immer erlauben. Hinter einer großen Firmen-Firewall ist dieser unklare Port häufig gesperrt.

<!--### The HTTP/S Protocol ###-->
### Das HTTP/S Protokoll ###

<!--Last we have the HTTP protocol. The beauty of the HTTP or HTTPS protocol is the simplicity of setting it up. Basically, all you have to do is put the bare Git repository under your HTTP document root and set up a specific `post-update` hook, and you’re done (See Chapter 7 for details on Git hooks). At that point, anyone who can access the web server under which you put the repository can also clone your repository. To allow read access to your repository over HTTP, do something like this:-->

Als letztes haben wir das HTTP Protokoll. Das Schöne am HTTP bzw. HTTPS Protokoll ist die Einfachheit des Einrichtens. Im Grunde musst Du nur das einfach Git Repository in Dein HTTP Hauptverzeichnis legen und einen speziellen `post-update` hook (xxx) einrichten und schon bist Du fertig (siehe Kapitel 7 für Details zu Git hooks (xxx)). Jetzt kann jeder, der auf den Web-Server mit dem Repository zugreifen kann, das Repository clonen. Um Lese-Zugriff auf das Repository über HTTP zu erlauben, führe die folgenden Befehle aus:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

<!--That’s all. The `post-update` hook that comes with Git by default runs the appropriate command (`git update-server-info`) to make HTTP fetching and cloning work properly. This command is run when you push to this repository over SSH; then, other people can clone via something like-->

Das ist alles. Der `post-update` hook (xxx) der standardmäßig zusammen mit Git kommt führt den richtigen Befehl aus (`git update-server-info`), damit der HTTP-Server das Repository richtig abruft und klont. Dieser Befehl läuft, wenn Du zu diesem Repository per SSH pusht, andere Leute können dann clonen mit dem Befehl

	$ git clone http://example.com/gitproject.git

<!--In this particular case, we’re using the `/var/www/htdocs` path that is common for Apache setups, but you can use any static web server — just put the bare repository in its path. The Git data is served as basic static files (see Chapter 9 for details about exactly how it’s served).-->

In diesem besonderen Fall benutzen Dir den `/var/www/htdocs`-Pfad, der typisch für Apache-Setups ist, aber Du kannst jeden statischen Web-Server benutzen – nur das einfache Repository in den richtigen Ordner legen. Die Git-Daten werden als einfache statische Dateien serviert (siehe Kapitel 9 für Details, wie es genau serviert wird).

<!--It’s possible to make Git push over HTTP as well, although that technique isn’t as widely used and requires you to set up complex WebDAV requirements. Because it’s rarely used, we won’t cover it in this book. If you’re interested in using the HTTP-push protocols, you can read about preparing a repository for this purpose at `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. One nice thing about making Git push over HTTP is that you can use any WebDAV server, without specific Git features; so, you can use this functionality if your web-hosting provider supports WebDAV for writing updates to your web site.-->

Es ist möglich, Git-Daten auch über HTTP zu pushen, trotzdem wird diese Technik nicht oft eingesetzt und es setzt komplexe WebDAV-Anforderungen voraus. Weil es selten genutzt wird, werden wir das nicht in diesem Buch behandeln. Wenn Du Interesse am HTTP-Push-Protokoll hast, kannst Du das Einrichten unter `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` nachlesen. Eine Schöne Sache über Git-Push über HTTP ist, dass Du jeden WebDAV-Server benutzen kannst, ohne spezifische Git-Features; also kannst Du diese Funktionalität nutzen, wenn Dein Web-Hosting-Provider WebDAV unterstützt, um Änderungen auf Deine Webseite zu schreiben.

<!--#### The Pros ####-->
#### Die Vorteile ####

<!--The upside of using the HTTP protocol is that it’s easy to set up. Running the handful of required commands gives you a simple way to give the world read access to your Git repository. It takes only a few minutes to do. The HTTP protocol also isn’t very resource intensive on your server. Because it generally uses a static HTTP server to serve all the data, a normal Apache server can serve thousands of files per second on average — it’s difficult to overload even a small server.-->

Die Positivseite beim Benutzen des HTTP-Protokolls ist, dass es einfach einzurichten ist. Das Ausführen von einer Handvoll notwendiger Befehle ist ein einfacher Weg, um der Welt Lese-Zugriff auf Dein Git-Repository zu geben. Es braucht nur ein paar Minuten. Das HTTP Protokoll benötigt auch nicht viele Ressourcen auf Deinem Server. Es braucht generell nur einen statischen Server um die Daten zu auszuliefern. Ein normaler Apache-Server kann Tausende von Dateien pro Sekunde servieren – es ist schwierig selbst einen kleinen Server zu überlasten.

<!--You can also serve your repositories read-only over HTTPS, which means you can encrypt the content transfer; or you can go so far as to make the clients use specific signed SSL certificates. Generally, if you’re going to these lengths, it’s easier to use SSH public keys; but it may be a better solution in your specific case to use signed SSL certificates or other HTTP-based authentication methods for read-only access over HTTPS.-->

Du kannst Deine Repositories auch als Nur-Lese-Repositories über HTTPS servieren, Du kannst also den Daten-Transfer verschlüsseln. Oder Du kannst so weit gehen, dass die Clients spezifische signierte SSL-Zertifikate benutzen. Im Allgemeinen, wenn Du soweit gehst, ist es einfacher öffentliche SSH-Schlüssel zu benutzen; aber es ist vielleicht für Deinen Fall eine bessere Lösung, signierte SSL-Zertifikate zu benutzen oder andere HTTP-basierte Authentifizierungs-Methoden für Nur-Lese-Zugriff über HTTPS zu benutzen.

<!--Another nice thing is that HTTP is such a commonly used protocol that corporate firewalls are often set up to allow traffic through this port.-->

Eine andere schöne Sache ist, dass HTTP so oft genutzt wird, dass Firmen-Firewalls oft Traffic über den HTTP-Port erlauben.

<!--#### The Cons ####-->
#### Die Nachteile ####

<!--The downside of serving your repository over HTTP is that it’s relatively inefficient for the client. It generally takes a lot longer to clone or fetch from the repository, and you often have a lot more network overhead and transfer volume over HTTP than with any of the other network protocols. Because it’s not as intelligent about transferring only the data you need — there is no dynamic work on the part of the server in these transactions — the HTTP protocol is often referred to as a _dumb_ protocol. For more information about the differences in efficiency between the HTTP protocol and the other protocols, see Chapter 9.-->

Die Unterseite vom Servieren von Deinem Repository über HTTP ist, dass es recht ineffizient für den Client ist. Es braucht im Allgemeinen länger zu clonen oder Daten vom Repository zu holen und Du hast oft wesentlich mehr Netzwerk-Overhead und Transfer-Volumen als mit jedem anderen Netzwerk Protokoll. Weil es nicht so intelligent beim Daten-Transfer ist, um nur die benötigten Daten zu übertragen – es gibt keine dynamische Arbeit auf dem Server bei diesen Aktionen – das HTTP Protokoll wird oft als _dummes_ Protokoll bezeichnet. Für mehr Informationen über die Unterschiede bei der Effizienz zwischen dem HTTP Protokoll und den anderen Protokollen: siehe Kapitel 9.

<!--## Getting Git on a Server ##-->
## Git auf einen Server bekommen ##

<!--In order to initially set up any Git server, you have to export an existing repository into a new bare repository — a repository that doesn’t contain a working directory. This is generally straightforward to do.-->
<!--In order to clone your repository to create a new bare repository, you run the clone command with the `-\-bare` option. By convention, bare repository directories end in `.git`, like so:-->

Um zunächst einen beliebigen Git Server einzurichten, musst Du ein existierendes Repository in ein neues einfaches Repository exportieren – ein Repository, dass kein Arbeitsverzeichnis enthält. Das ist im Allgemeinen einfach zu erledigen.
Um zunächst Dein Repository zu klonen, um ein neues einfaches Repository anzulegen, führst Du den Klonen-Befehl mit der `--bare` Option aus. Per Konvention haben einfache Repository Verzeichnisse die Endung `.git`, wie hier:

	$ git clone --bare my_project my_project.git
	Cloning into bare repository 'my_project.git'...
	done.

<!--The output for this command is a little confusing. Since `clone` is basically a `git init` then a `git fetch`, we see some output from the `git init` part, which creates an empty directory. The actual object transfer gives no output, but it does happen. You should now have a copy of the Git directory data in your `my_project.git` directory.-->

Die Ausgabe für diesen Befehl ist etwas verwirrend. Weil `clone` im Grunde ein `git init` und ein `git fetch` ist, sehen wir eine Ausgabe vom `git init`-Teil, der ein leeres Verzeichnis anlegt. Die eigentliche Objekt-Übertragung erzeugt keine Ausgabe, aber sie findet statt. Du solltest jetzt eine Kopie von den Git-Verzeichnis Daten in Deinem `my_project.git` Verzeichnis haben.

<!--This is roughly equivalent to something like-->

Dies ist entsprechend zu etwas wie

	$ cp -Rf my_project/.git my_project.git

<!--There are a couple of minor differences in the configuration file; but for your purpose, this is close to the same thing. It takes the Git repository by itself, without a working directory, and creates a directory specifically for it alone.-->

Es gibt ein paar kleine Unterschiede in der Konfigurationsdatei, aber für Deine Zwecke ist es nahezu dasselbe. Es nimmt das Git-Repository selbst, ohne ein Arbeitsverzeichnis, und erzeugt ein Verzeichnis speziell für es allein.

<!--### Putting the Bare Repository on a Server ###-->
### Inbetriebnahme des einfachen Repository auf einem Server ###

<!--Now that you have a bare copy of your repository, all you need to do is put it on a server and set up your protocols. Let’s say you’ve set up a server called `git.example.com` that you have SSH access to, and you want to store all your Git repositories under the `/opt/git` directory. You can set up your new repository by copying your bare repository over:-->

Jetzt da Du eine einfache Kopie Deines Repository hast, ist alles was Du tun musst das Aufsetzen auf einem Server und das Einrichten Deiner Protokolle. Angenommen, Du hast einen Server mit dem Namen `git.example.com`, zu dem Du SSH-Zugang hast, und Du möchtest alle Deine Git Repositories im Verzeichnis `/opt/git` speichern. Du kannst Dein neues Repository einrichten, indem Du Dein einfaches Repository dorthin kopierst:

	$ scp -r my_project.git user@git.example.com:/opt/git

<!--At this point, other users who have SSH access to the same server which has read-access to the `/opt/git` directory can clone your repository by running-->

An diesem Punkt können andere Benutzer, die SSH-Zugang zu dem gleichen Server und Lesezugriff auf das `/opt/git` Verzeichnis haben, Dein Repository klonen:

	$ git clone user@git.example.com:/opt/git/my_project.git

<!--If a user SSHs into a server and has write access to the `/opt/git/my_project.git` directory, they will also automatically have push access.  Git will automatically add group write permissions to a repository properly if you run the `git init` command with the `-\-shared` option.-->

Wenn sich ein Benutzer per SSH mit dem Server verbindet und Schreibzugriff zu dem Verzeichnis `/opt/git/my_project.git` hat, wird er automatisch auch Push-Zugriff haben. Git wird automatisch die richtigen Gruppenschreibrechte zu einem Repository hinzufügen, wenn Du den `git init` Befehl mit der `--shared` Option ausführst:

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

<!--You see how easy it is to take a Git repository, create a bare version, and place it on a server to which you and your collaborators have SSH access. Now you’re ready to collaborate on the same project.-->

Du siehst wie einfach es ist ein Git Repository zu nehmen, eine einfache Version zu erzeugen, es auf einen Server zu platzieren zu dem Du und Deine Mitarbeiter SSH-Zugriff haben.

<!--It’s important to note that this is literally all you need to do to run a useful Git server to which several people have access — just add SSH-able accounts on a server, and stick a bare repository somewhere that all those users have read and write access to. You’re ready to go — nothing else needed.-->

Es ist wichtig zu beachten, dass dies wortwörtlich alles ist, was Du tun musst, um einen nützlichen Git-Server laufen zu lassen, zu dem mehrere Personen Zugriff haben – füge auf dem Server einfach SSH-fähige Konten und irgendwo ein einfaches Repository hinzu, zu dem alle Benutzer Schreib- und Lesezugriff haben.

<!--In the next few sections, you’ll see how to expand to more sophisticated setups. This discussion will include not having to create user accounts for each user, adding public read access to repositories, setting up web UIs, using the Gitosis tool, and more. However, keep in mind that to collaborate with a couple of people on a private project, all you _need_ is an SSH server and a bare repository.-->

In den nächsten Abschnitten wirst Du sehen, wie man auf anspruchsvollere Konfigurationen erweitert. Diese Diskussion wird beinhalten nicht Benutzerkonten für jeden Benutzer hinzufügen zu müssen, öffentlichen Lese-Zugriff auf Repositories hinzuzufügen, die Einrichtung von Web-UIs, die Benutzung des Gitosis-Tools und weiteres. Aber denke daran, zur Zusammenarbeit mit ein paar Personen an einem privaten Projekt, ist alles was Du _brauchst_ ein SSH-Server und ein einfaches Repository.

<!--### Small Setups ###-->
### Kleine Konfigurationen ###

<!--If you’re a small outfit or are just trying out Git in your organization and have only a few developers, things can be simple for you. One of the most complicated aspects of setting up a Git server is user management. If you want some repositories to be read-only to certain users and read/write to others, access and permissions can be a bit difficult to arrange.-->

Wenn Du eine kleine Ausrüstung hast oder Git gerade in Deinem Unternehmen ausprobierst und nur ein paar Entwickler hast, sind die Dinge einfach für dich. Einer der kompliziertesten Aspekte der Einrichtung eines Git-Servers ist die Benutzerverwaltung. Wenn einige Repositories für bestimmte Benutzer nur lesend zugänglich sein sollen und andere Benutzer Lese/Schreib-Zugriff haben sollen, können Zugriff und Berechtigungen ein bisschen schwierig zu organisieren sein.

<!--#### SSH Access ####-->
#### SSH-Zugriff ####

<!--If you already have a server to which all your developers have SSH access, it’s generally easiest to set up your first repository there, because you have to do almost no work (as we covered in the last section). If you want more complex access control type permissions on your repositories, you can handle them with the normal filesystem permissions of the operating system your server runs.-->

Wenn Du bereits einen Server hast, zu dem alle Entwickler SSH-Zugriff haben, ist es generell einfach, Dein erstes Repository einzurichten, weil Du fast keine Arbeit zu erledigen hast (wie wir im letzen Abschnitt abgedeckt haben). Wenn Du komplexere Zugriffskontroll-Berechtigungen auf Deine Repositories willst, kannst Du diese mit normalen Dateisystem-Berechtigungen des Betriebssystems Deines Servers bewältigen.

<!--If you want to place your repositories on a server that doesn’t have accounts for everyone on your team whom you want to have write access, then you must set up SSH access for them. We assume that if you have a server with which to do this, you already have an SSH server installed, and that’s how you’re accessing the server.-->

Wenn Du Deine Repositories auf einem Server platzieren möchtest, der keine Accounts für jeden aus Deinem Team hat, der Schreibzugriff haben soll, dann musst Du SSH-Zugriff für diese Personen einrichten. Wir nehmen an, wenn Du einen Server hast, mit welchem Du dies tun möchtest, Du bereits einen SSH-Server installiert hast und so greifst Du auf den Server zu.

<!--There are a few ways you can give access to everyone on your team. The first is to set up accounts for everybody, which is straightforward but can be cumbersome. You may not want to run `adduser` and set temporary passwords for every user.-->

Es gibt ein paar Wege allen Mitgliedern Deines Teams Zugriff zu geben. Der erste ist einen Account für jeden einzurichten, was unkompliziert aber mühsam sein kann. Du möchtest vielleicht nicht für jeden Benutzer `adduser` ausführen und ein temporäres Passwort setzen.

<!--A second method is to create a single 'git' user on the machine, ask every user who is to have write access to send you an SSH public key, and add that key to the `~/.ssh/authorized_keys` file of your new 'git' user. At that point, everyone will be able to access that machine via the 'git' user. This doesn’t affect the commit data in any way — the SSH user you connect as doesn’t affect the commits you’ve recorded.-->

Eine zweite Methode ist, einen einzigen ‚git‘-Benutzer auf der Maschine zu erstellen und jeden Benutzer, der Schreibzugriff haben soll, nach einem öffentliche SSH-Schlüssel zu fragen und diesen Schlüssel zu der `~/.ssh/authorized_keys`-Datei Deines neuen ‚git‘ Benutzers hinzuzufügen. Das beeinflusst die Commit-Daten in keiner Weise – der SSH-Benutzer, mit dem Du Dich verbindest, beeinflusst die von Dir aufgezeichneten Commits nicht.

<!--Another way to do it is to have your SSH server authenticate from an LDAP server or some other centralized authentication source that you may already have set up. As long as each user can get shell access on the machine, any SSH authentication mechanism you can think of should work.-->

Ein anderer Weg ist, einen LDAP-Server zur Authentifizierung zu benutzen oder eine andere zentrale Authentifizierungsquelle, die Du vielleicht bereits eingerichtet hast. Solange jeder Benutzer Shell-Zugriff zu der Maschine hat, sollte jede SSH-Authentifizierungsmethode funktionieren, die Du Dir vorstellen kannst.

<!--## Generating Your SSH Public Key ##-->
## Generiere Deinen öffentlichen SSH-Schlüssel ##

<!--That being said, many Git servers authenticate using SSH public keys. In order to provide a public key, each user in your system must generate one if they don’t already have one. This process is similar across all operating systems.-->
<!--First, you should check to make sure you don’t already have a key. By default, a user’s SSH keys are stored in that user’s `~/.ssh` directory. You can easily check to see if you have a key already by going to that directory and listing the contents:-->

Darüber hinaus benutzen viele Git-Server öffentliche SSH-Schlüssel zur Authentifizierung. Um einen öffentlichen Schlüssel bereitzustellen muss jeder Benutzer Deines Systems einen solchen Schlüssel generieren, falls sie noch keinen haben. Dieser Prozess ist bei allen Betriebssystemen ähnlich.
Als erstes solltest Du überprüfen, ob Du nicht schon einen Schlüssel hast. Standardmäßig werden die SSH-Schlüssel der Benutzer in ihrem `~/.ssh`-Verzeichnis gespeichert. Du kannst einfach überprüfen, ob Du einen Schlüssel hast, indem Du in das Verzeichnis gehst und den Inhalt auflistest:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

<!--You’re looking for a pair of files named something and something.pub, where the something is usually `id_dsa` or `id_rsa`. The `.pub` file is your public key, and the other file is your private key. If you don’t have these files (or you don’t even have a `.ssh` directory), you can create them by running a program called `ssh-keygen`, which is provided with the SSH package on Linux/Mac systems and comes with the MSysGit package on Windows:-->

Du suchst nach einem Dateienpaar namens `irgendetwas` und `irgendetwas.pub`, die Datei `irgendetwas` heißt normalerweise `id_dsa` oder `id_rsa`. Die `.pub`-Datei ist Dein öffentlicher Schlüssel, und die andere Datei ist Dein privater Schlüssel. Wenn Du diese Dateien nicht hast (oder gar kein `.ssh`-Verzeichnis hast), kannst Du sie mit dem Ausführen des Programms `ssh-keygen` erzeugen. Das Programm wird mit dem SSH-Paket auf Linux/Mac-Systemen mitgeliefert und kommt mit dem MSysGit-Paket unter Windows:

	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

<!--First it confirms where you want to save the key (`.ssh/id_rsa`), and then it asks twice for a passphrase, which you can leave empty if you don’t want to type a password when you use the key.-->

Zunächst wird bestätigt, wo Du den Schlüssel speichern möchtest (`.ssh/id_rsa`) und dann wird zweimal nach der Passphrase gefragt, die Du leer lassen kannst, wenn Du kein Passwort bei der Benutzung des Schlüssels eintippen möchtest.

<!--Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). All they have to do is copy the contents of the `.pub` file and e-mail it. The public keys look something like this:-->

Jeder Benutzer der dies macht, muss seinen öffentlichen Schlüssel an sich senden oder wer auch immer den Git-Server administriert (angenommen Du benutzt eine SSH-Server Konfiguration, die öffentliche Schlüssel benötigt). Alles was die Benutzer tun müssen ist, den Inhalt der `.pub`-Datei zu kopieren und an Dich per E-Mail zu schicken. Der öffentliche Schlüssel sieht etwa wie folgt aus:

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

<!--For a more in-depth tutorial on creating an SSH key on multiple operating systems, see the GitHub guide on SSH keys at `http://github.com/guides/providing-your-ssh-key`.-->

Eine detailliertere Anleitung zur Erstellung eines SSH-Schlüssels unter den verschiedenen Betriebssystemen ist der GitHub-Leitfaden für SSH-Schlüssel unter `http://github.com/guides/providing-your-ssh-key`.

<!--## Setting Up the Server ##-->
## Einrichten des Servers ##

<!--Let’s walk through setting up SSH access on the server side. In this example, you’ll use the `authorized_keys` method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a `.ssh` directory for that user.-->

Nun kommen wir zur Einrichtung des SSH-Zugangs auf der Server-Seite. In diesem Beispiel verwendest Du die `authorized_keys`-Methode zur Authentifizierung der Benutzer. Wir nehmen auch an, dass Du eine gebräuchliche Linux-Distribution wie Ubuntu verwendest. Zuerst erstellst Du den Benutzer ‚git‘ und ein `.ssh`-Verzeichnis für diesen Benutzer.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

<!--Next, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:-->

Als nächstes ist es nötig, einige öffentliche SSH-Schlüssel der Entwickler zu der `authorized_keys`-Datei des Benutzers hinzuzufügen. Nehmen wir an, dass Du ein paar Schlüssel per E-Mail empfangen hast und diese in temporären Dateien gespeichert hast. Die öffentlichen Schlüssel sehen wieder etwa wie folgt aus:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

<!--You just append them to your `authorized_keys` file:-->

Du hängst sie einfach an Deine `authorized_keys`-Datei an:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

<!--Now, you can set up an empty repository for them by running `git init` with the `-\-bare` option, which initializes the repository without a working directory:-->

Jetzt kannst Du einen leeren Ordner für sie anlegen, indem Du den Befehl `git init` mit der Option `--bare` ausführst. Damit wird ein Repository ohne ein Arbeitsverzeichnis erzeugt.

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

<!--Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:-->

Dann können John, Josie oder Jessica die erste Version ihres Projektes in das Repository hochladen, indem sie es als externes Repository hinzufügen und einen Branch hochladen. Beachte, dass sich bei jeder Projekterstellung jemand mit der Maschine auf eine Shell verbinden muss, um ein einfaches Repository zu erzeugen. Lass uns `gitserver` als Hostnamen des Servers verwenden, auf dem Du den Benutzer ‚git‘ und das Repository eingerichtet hast. Wenn Du den Server intern betreibst und das DNS so eingerichtet hast, dass `gitserver` auf den Server zeigt, dann kannst Du die Befehle ziemlich wie hier benutzen:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

<!--At this point, the others can clone it down and push changes back up just as easily:-->

An diesem Punkt können die anderen das Repository klonen und Änderungen ebenso leicht hochladen:

	$ git clone git@gitserver:/opt/git/project.git
	$ cd project
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

<!--With this method, you can quickly get a read/write Git server up and running for a handful of developers.-->

Mit dieser Methode kannst Du schnell für eine Handvoll Entwickler einen Lese/Schreib Git-Server zum Laufen bekommen.

<!--As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:-->

Als zusätzliche Vorsichtsmaßnahme kannst Du den Benutzer ‚git‘ so beschränken, dass er nur Git-Aktivitäten mit einem limitierten Shell-Tool namens `git-shell` ausführen kann, dass mit Git kommt. Wenn Du das als Login-Shell des ‚git‘-Benutzers einrichtest, dann hat der Benutzer ‚git‘ keinen normalen Shell-Zugriff auf den Server. Zur Benutzung bestimme `git-shell` anstatt von bash oder csh als Login-Shell Deines Benutzers. Um das zu tun wirst Du wahrscheinlich Deine `/etc/passwd` editieren:

	$ sudo vim /etc/passwd

<!--At the bottom, you should find a line that looks something like this:-->

Am Ende solltest Du eine Zeile finden, die in etwa so aussieht:

	git:x:1000:1000::/home/git:/bin/sh

<!--Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). The line should look something like this:-->

Ändere `/bin/sh` zu `/usr/bin/git-shell` (oder führe `which git-shell` aus, um zu sehen, wo es installiert ist). Die Zeile sollte in etwa so aussehen:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

<!--Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:-->

Jetzt kann der ‚git‘-Benutzer die SSH-Verbindung nur noch verwenden, um Git-Repositories hochzuladen und herunterzuladen. Der Benutzer kann sich nicht mehr per Shell zur Maschine verbinden. Wenn Du es versuchst, siehst Du eine Login-Ablehnung wie diese:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

<!--## Public Access ##-->
## Öffentlicher Zugang ##

<!--What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.-->

Was ist, wenn Du anonymen Lese-Zugriff zu Deinem Projekt ermöglichen möchtest? Vielleicht möchtest Du ein Open-Source Projekt, anstatt einem privaten, nicht öffentlichen Projekt hosten. Oder Du hast ein paar automatisierte Build-Server oder Continuous Integration Server, die ständig wechseln, und Du möchtest für diese nicht dauernd neue SSH-Schlüssel generieren. Dann wäre es doch schön, wenn ein anonymer Lese-Zugriff zu Deinem Projekt möglich wäre.

<!--Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.-->

Der wahrscheinlich einfachste Weg für kleinere Konfigurationen ist, einen Webserver, in dessen Basisverzeichnis die Git Repositorys liegen, laufen zu lassen und den `post-update` Hook, den wir im ersten Abschnitt dieses Kapitels erwähnt haben, zu aktivieren. Gehen wir vom vorherigen Beispiel aus. Sagen wir, Du hast Deine Repositorys im Verzeichnis `/opt/git` und ein Apache-Server läuft auf Deiner Maschine. Du kannst dafür jeden beliebigen Webserver benutzen, aber in diesem Beispiel demonstrieren wir das Ganze an Hand einer Apache Basis-Konfiguration. Dies sollte Dir eine Vorstellung geben, wie Du es mit dem Webserver Deiner Wahl umsetzen kannst.

<!--First you need to enable the hook:-->

Zuerst musst Du den Hook aktivieren:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

<!--If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently.-->

Wenn Du eine ältere Git Version als 1.6 benutzt, brauchst Du den `mv`-Befehl nicht auszuführen. Das Namensschema mit der .sample Endung wurde erst bei den neueren Git Versionen eingeführt.

<!--What does this `post-update` hook do? It looks basically like this:-->

Welche Aufgabe hat der `post-update` Hook? Er enthält in etwa folgendes:

	$ cat .git/hooks/post-update
	#!/bin/sh
	#
	# An example hook script to prepare a packed repository for use over
	# dumb transports.
	#
	# To enable this hook, rename this file to "post-update".
	#
	
	exec git-update-server-info

<!--This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.-->

Wenn Du via SSH etwas auf den Server hochlädst, wird Git den Befehl `git-update-server-info` ausführen. Dieser Befehl aktualisiert alle Dateien, die benötigt werden, damit das Repository über HTTP geholt (fetch) beziehungsweise geklont werden kann.

<!--Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:-->

Als nächstes musst Du einen VirtualHost Eintrag zu Deiner Apache-Konfiguration hinzufügen. Das dort angegebene DocumentRoot Verzeichnis muss mit dem Basisverzeichnis Deiner Git Projekte übereinstimmen. In diesem Beispiel gehen wir davon aus, dass ein Wildcard-DNS Eintrag besteht, der dafür sorgt, dass `*.gitserver` auf den Server zeigt, auf dem das Ganze hier läuft:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

<!--You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:-->

Da die Apache-Instanz, die das CGI-Skript ausführt, standardmäßig unter dem Benutzer `www-data` läuft, musst Du auch die Unix Eigentümer-Gruppe des Verzeichnisses `/opt/git` auf `www-data` setzen. Ansonsten kann Dein Webserver die Repositorys nicht lesen:

	$ chgrp -R www-data /opt/git

<!--When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:-->

Nach einem Neustart des Apache, solltest Du in der Lage sein, Deine Repositorys innerhalb diesem Verzeichnis zu klonen, indem Du die URL für das jeweilige Projekt angibst.

	$ git clone http://git.gitserver/project.git

<!--This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.-->

Auf diese Art und Weise kannst Du in wenigen Minuten einen HTTP-basierten Lese-Zugriff auf all Deine Projekte für eine große Anzahl von Benutzern ermöglichen. Ein Git Daemon ist eine andere einfache Möglichkeit für einen öffentlichen Zugang. Wenn Du diese Methode bevorzugst, solltest Du Dir den nächsten Abschnitt unbedingt anschauen.

<!--## GitWeb ##-->
## GitWeb ##

<!--Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).-->

Da Du jetzt sowohl einen einfachen Lese- und Schreibzugriff, als auch einen schreibgeschützten Zugang auf Dein Projekt hast, wird es jetzt Zeit eine simple webbasierte Visualisierung dafür einzurichten. Git wird mit einem CGI-Skript namens GitWeb ausgeliefert, welches für diese Aufgabe häufig verwendet wird. Auf Seiten, wie zum Beispiel `http://git.kernel.org`, kannst Du Dir GitWeb in Aktion anschauen (siehe Abbildung 4-1).

<!--Figure 4-1. The GitWeb web-based user interface.-->

Insert 18333fig0401.png
Abbildung 4-1. Die webbasierte Benutzeroberfläche von GitWeb.

<!--If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `-\-httpd` option.-->

Wenn Du Dir anschauen möchtest, wie GitWeb bei Deinem Projekt ausschauen würde, gibt es dafür eine einfache Möglichkeit. Wenn Du einen einfachen Webserver wie `lighttpd` or `webrick` auf Deinem Server installiert hast, kannst Du mit einem in Git integrierten Kommando eine temporäre Instanz von GitWeb starten. Da `lighttpd` auf vielen Linux Rechnern bereits installiert ist, kannst Du versuchen ihn zum Laufen zu bringen, indem Du das Kommando  `git instaweb` in Deinem Projektverzeichnis ausführst. Bei Mac OS X 10.5 alias Leopard ist Ruby bereits vorinstalliert. Falls Du also einen Mac verwendest, solltest Du es mal mit `webrick` versuchen. Um `instaweb` mit einem anderen Webserver als `lighthttpd` zu starten, kannst Du an den Befehl die Option `--httpd` anhängen.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

<!--That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `-\-stop` option:-->

Dadurch wird auf dem Port 1234 ein HTPPD Server gestartet. Gleichzeitig wird automatisch Dein Webbrowser mit der entsprechenden Seite geöffnet. Das Ganze gestaltet sich also ziemlich einfach. Wenn Du dann fertig bist und den Server wieder beenden willst, kannst Du das gleiche Kommando mit der Option `--stop` ausführen:

	$ git instaweb --httpd=webrick --stop

<!--If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:-->

Wenn Du das Web Interface für Dein Team oder ein von Dir gehostetes Open-Source Projekt dauerhaft zur Verfügung stellen willst, musst Du das CGI-Skript so einrichten, dass es von Deinem normalen Webserver zur Verfügung gestellt werden kann. Bei manchen Linux Distributionen ist ein `gitweb` Paket enthalten, welches Du via `apt` oder `yum` installieren kannst. Vielleicht probierst Du das einfach mal zuerst aus. Wir werden hier nämlich die manuelle Installation von GitWeb nur kurz überfliegen. Zum Starten benötigst Du den Git Quellcode. Dort ist GitWeb enthalten und Du kannst damit Dein angepasstest CGI-Skript erstellen:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb
	$ sudo cp -Rf gitweb /var/www/

<!--Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:-->

Bitte beachte, dass Du dem Kommando angeben musst, wo sich Deine Git Repositorys befinden. Dazu wird die `GITWEB_PROJECTROOT` Variable verwendet. Jetzt musst Du den Apache noch so konfigurieren, dass er CGI für das Skript verwendet. Dazu kannst Du einen VirtualHost einrichten:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

<!--Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.-->

Ich möchte Dich noch einmal darauf hinweisen, dass GitWeb prinzipiell mit jedem CGI-fähigen Webserver funktioniert. Wenn Du einen anderen Webserver bevorzugst, sollte es also kein Problem sein, GitWeb dafür einzurichten. Nach einem Neustart Deines Apache solltest Du jetzt in der Lage sein, Deine Repositorys über die Adresse `http://gitserver/` in GitWeb anzuschauen. Gleichzeitig kannst Du über `http://git.gitserver` Deine Repositorys per HTTP klonen und abholen (im Sinne eines Fetch).

<!--## Gitosis ##-->
## Gitosis ##

<!--Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.-->

Das manuelle Verwalten der öffentlichen Benutzerschlüssel in der Datei `authorized_keys` ist auf Dauer nicht sinnvoll. Wenn Du hunderte von Benutzer verwalten musst, wird dieser Prozess noch viel schwieriger und macht keinen Spaß mehr. Du musst jedes mal über die Shell auf Deinen Server zugreifen und es gibt auch keine Zugriffsberechtigungen. Jeder der in der `authorized_keys` Datei eingetragen ist, hat auf jedes Projekt Lese- und Schreibzugriff.

<!--At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.-->

Vielleicht ist es deshalb sinnvoll, dass Du Dich mit dem weit verbreiteten Projekt Gitosis beschäftigst. Gitosis ist im Grunde eine Sammlung von Skripts, die Dir dabei helfen, sowohl die Datei `authorized_keys` zu verwalten, als auch ein paar einfache Zugriffsberechtigungen zu setzen. Das wirklich interessante an diesem Werkzeug ist es, dass die Benutzeroberfläche zum Hinzufügen von Benutzern oder Setzen von Berechtigungen, kein Web Interface ist, sondern ein spezielles Git Repository. Die ganzen Informationen werden in diesem Projekt verwaltet und sobald dieses gepusht wird, konfiguriert Gitosis den Server auf Basis dieser Daten entsprechend um. Das ist ziemlich cool, oder?

<!--Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.-->

Die Installation von Gitosis ist nicht einfach, aber auf jeden Fall machbar. Am einfachsten gestaltet sich die Installation auf einem Linux Server. In unserem Beispiel verwenden wir dafür einen Standard Ubuntu Server in der Version 8.10.

<!--Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:-->

Gitosis setzt einige Python Werkzeuge voraus. Deshalb solltest Du zuerst das Python Setuptools Paket installieren. Unter Ubuntu wird es als python-setuptools zur Verfügung gestellt:

	$ apt-get install python-setuptools

<!--Next, you clone and install Gitosis from the project’s main site:-->

Danach klonst Du Gitosis von der offiziellen Projektseite und installierst es:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

<!--That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:-->

Einige ausführbare Dateien, welche von Gitosis benötigt werden, werden mit dem Skript installiert. Außerdem will Gitosis seine Repositorys im Verzeichnis `/home/git` ablegen. Das ist auch ok so. Allerdings liegen unsere Repositorys bereits im Verzeichnis `/opt/git`, aber anstatt alles umzukonfigurieren, erstellst Du einfach eine symbolische Verknüpfung (symlink):

	$ ln -s /opt/git /home/git/repositories

<!--Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:-->

Gitosis wird Deine Schlüssel für Dich verwalten. Deshalb musst Du die bereits vorhandene Datei `authorized_keys` entfernen, die Schlüssel später wieder hinzufügen und Gitosis die automatisierte Verarbeitung dieser Datei überlassen. Zuerst musst Du also die Datei `authorized_keys` aus dem Weg räumen:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

<!--Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file-->

Wenn Du für den Benutzer ‚git‘ die Shell auf die `git-shell` gesetzt hast (siehe Kapitel 4.4), musst Du die normale Shell für diesen Benutzer wieder aktivieren. Den Benutzern wird es danach immer noch nicht möglich sein sich einzuloggen, dafür sorgt Gitosis. Ändere also in Deiner `/etc/passwd` die Zeile

	git:x:1000:1000::/home/git:/usr/bin/git-shell

<!--back to this:-->

zurück in folgendes:

	git:x:1000:1000::/home/git:/bin/sh

<!--Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:-->

Jetzt wird es Zeit Gitosis zu initialisieren. Dafür musst Du das Kommando `gitosis-init` mit Deinem öffentlichen Schlüssel ausführen. Wenn sich Dein öffentlicher Schlüssel nicht auf dem Server befindet, musst Du ihn vorher dorthin kopieren:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

<!--This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.-->

Dem Benutzer, mit dem hier angegeben Schlüssel, ist es jetzt möglich, das Git Repository, mit dem Gitosis konfiguriert wird, zu modifizieren. Als nächstes musst Du manuell das Execute-Bit für das Skript `post-update` in Deinem neuen „Verwaltungs“-Repository setzen.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

<!--You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:-->

Jetzt kann es losgehen. Wenn Du alles richtig eingerichtet hast, kannst Du jetzt versuchen Dich über SSH einzuloggen. Du musst dafür den Benutzer verwenden, dem der öffentliche Schlüssel gehört, den Du in den vorherigen Schritten hinzugefügt hast. Du solltest dann in etwa folgende Ausgabe erhalten:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	ERROR:gitosis.serve.main:Need SSH_ORIGINAL_COMMAND in environment.
	  Connection to gitserver closed.

<!--That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:-->

Das bedeutet das Gitosis Dich als Benutzer kennt, aber Dich ausschließt, weil Du nicht versuchst ein Git Kommando auszuführen. Lass uns also ein Git Kommando ausprobieren. Wir klonen dazu das Verwaltungsrepository von Gitosis:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

<!--Now you have a directory named `gitosis-admin`, which has two major parts:-->

Jetzt hast Du auf Deinem Rechner ein Verzeichnis mit dem Namen `gitosis-admin`. Dieses besteht aus hauptsächlich zwei Teilen:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

<!--The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.-->

Mit Hilfe der Datei `gitosis.conf` kannst Du die Benutzer, Repositorys und die Zugriffsrechte festlegen. Im Verzeichnis `keydir` werden alle öffentlichen Schlüssel der Benutzer abgelegt, die einen Zugriff auf Deine Repositorys haben sollen und zwar für jeden Benutzer eine einzelne Datei. Der Name der Datei, die sich jetzt bereits im `keydir` Verzeichnis befindet (in diesem Beispiel ist es `scott.pub`), wird bei Dir anders lauten. Die Beschreibung, die sich am Ende des öffentlichen Schlüssels befindet, der beim initialen Import mit dem Skript `gitosis-init` angegeben wurde, wird von Gitosis als Dateiname verwendet.

<!--If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:-->

Wenn Du Dir die Datei `gitosis.conf` anschaust, sollten lediglich Daten für das Projekt `gitosis-admin` enthalten sein. `gitosis-admin` ist das Projekt, welches Du gerade geklont hast.

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	members = scott
	writable = gitosis-admin

<!--It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.-->

In dieser Datei wird Dir angezeigt, dass nur der Benutzer ‚scott‘ — das ist der Anwender mit dessen öffentlichen Schlüssel Gitosis initialisiert wurde — Zugriff auf das Projekt `gitosis-admin` hat.

<!--Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:-->

Lass uns jetzt für Dich ein neues Projekt hinzufügen. Dazu fügen wir eine neue Sektion mit dem Namen `mobile` hinzu, in der wir alle Teammitglieder aus dem „Mobile“-Team und alle Repositorys, die von Ihnen benötigt werden, auflisten. Da ‚scott‘ bisher der einzige Benutzer im System ist, werden wir ihn als einziges Teammitglied hinzufügen. Das erste von uns erzeugte Projekt mit dem wir anfangen, nennt sich `iphone_project`:

	[group mobile]
	members = scott
	writable = iphone_project

<!--Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:-->

Immer wenn Du Änderungen im Projekt `gitosis-admin` durchführst, musst Du diese Änderungen auch einchecken und auf den Server pushen, damit diese auch eine Wirkung zeigen:

	$ git commit -am 'add iphone_project and mobile group'
	[master 8962da8] add iphone_project and mobile group
	 1 file changed, 4 insertions(+)
	$ git push origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 272 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:gitosis-admin.git
	   fb27aec..8962da8  master -> master

<!--You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:-->

Du kannst Deinen ersten Push für das neue Projekt `iphone_project` ausführen, indem Du Deinen Server als Remote zu Deinem lokalen Repository hinzufügst und dann auf diesen pushst. Ab jetzt musst Du auf Deinem Server nicht mehr manuell ein Bare Repository für neue Projekte erstellen. Gitosis übernimmt diese Aufgabe für Dich, sobald es den ersten Push erhält:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

<!--Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.-->

Beachte, dass Du den Pfad nicht angeben musst (es ist sogar so, wenn Du ihn angibst, wird es nicht funktionieren). Gib lediglich ein Doppelpunkt gefolgt vom Namen des Projekts an. Das reicht Gitosis aus, um den richtigen Pfad für Dich zu finden.

<!--You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:-->

Da Du an diesem Projekt nicht alleine, sondern mit Deinen Freunden, arbeiten willst, musst Du deren öffentliche Schlüssel wieder hinzufügen. Aber anstatt diese manuell in der Datei `~/.ssh/authorized_keys` auf Deinem Server einzutragen, fügst Du jeden Schlüssel als einzelne Datei in das Verzeichnis `keydir` hinzu. Der Name der Dateien entspricht den gleichen Namen, auf die Du in der Datei `gitosis.conf` referenzierst. Lass uns für John, Josie und Jessica die öffentlichen Schlüssel hinzufügen:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

<!--Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:-->

Damit diese Personen Lese- und Schreibzugriff auf das Projekt `iphone_project` haben, musst Du sie dem ‚mobile‘-Team hinzufügen:

	[group mobile]
	members = scott john josie jessica
	writable = iphone_project

<!--After you commit and push that change, all four users will be able to read from and write to that project.-->

Nachdem Du diese Änderung commitet und gepusht hast, können alle vier Benutzer dieses Projekt lesen und schreiben.

<!--Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:-->

Mit Gitosis kann man auch einfache Zugriffsberechtigungen setzen. Wenn John nur Lesezugriff zum Projekt haben soll, dann kannst Du stattdessen folgendes angeben:

	[group mobile]
	members = scott josie jessica
	writable = iphone_project

	[group mobile_ro]
	members = john
	readonly = iphone_project

<!--Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:-->

Mit dieser Konfiguration kann John das Projekt klonen und kann neue Stände herunterladen, aber Gitosis wird jeden Push von ihm ablehnen. Du kannst beliebig viele Gruppen angeben, die jeweils unterschiedliche Benutzer und Projekte enthalten. Ebenso ist es möglich eine andere Gruppe als Mitglied hinzuzufügen damit deren Teammitglieder automatisch miteinbezogen werden. Dazu musst Du bei der Gruppe `@` als Präfix angeben:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	members   = @mobile_committers
	writable  = iphone_project

	[group mobile_2]
	members   = @mobile_committers john
	writable  = another_iphone_project

<!--If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.-->

Solltest Du Probleme mit Gitosis haben, hilft es Dir vielleicht, wenn Du den Eintrag `loglevel=DEBUG` in der Sektion `[gitosis]` hinzufügst. Wenn Du keinen Push auf das Verwaltungsrepository ausführen kannst und Du Dich damit ausgeschlossen hast, kannst Du die Konfiguration unter `/home/git/.gitosis.conf` manuell bearbeiten. Diese Datei verwendet Gitosis als Konfigurationsdatei. Bei einem Push wird diese durch die im Verwaltungsrepository enthaltene Datei ersetzt. Wenn Du diese Datei also manuell änderst, bleibt diese bis zum nächsten erfolgreichen Push auf das Projekt `gitosis-admin` bestehen.

<!--## Gitolite ##-->
## Gitolite ##

<!--This section serves as a quick introduction to Gitolite, and provides basic installation and setup instructions.  It cannot, however, replace the enormous amount of [documentation][gltoc] that Gitolite comes with.  There may also be occasional changes to this section itself, so you may also want to look at the latest version [here][gldpg].-->

In diesem Abschnitt werde ich einen kurzen Einblick in Gitolite geben und die Basisinstallation und Konfiguration besprechen. Jedoch kann meine kurze Einführung nicht die ausführliche [Dokumentation][gltoc], die Gitolite bietet, ersetzen. Es könnte sein, dass es gelegentlich Änderungen an diesem Abschnitt gibt, deshalb solltest Du auch einen Blick auf die [aktuellste Version][gldpg] wagen.

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

<!--Gitolite is an authorization layer on top of Git, relying on `sshd` or `httpd` for authentication.  (Recap: authentication is identifying who the user is, authorization is deciding if he is allowed to do what he is attempting to).-->

Gitolite ist als Schicht für die Zugriffsberechtigung oberhalb von Git angeordnet und verwendet `sshd` oder `httpd`  zur Authentifikation. (Kurze Wiederholung: Bei der Authentifizierung wird der Benutzer identifiziert und die Zugriffsberechtigung entscheidet, ob der Benutzer die gewünschte Operation ausführen darf oder nicht).

<!--Gitolite allows you to specify permissions not just by repository, but also by branch or tag names within each repository.  That is, you can specify that certain people (or groups of people) can only push certain "refs" (branches or tags) but not others.-->

Gitolite ermöglicht es Dir die Berechtigungen auf Repository Ebene festzulegen, erlaubt aber zusätzlich auch die Berechtigung auf Ebene von Branches oder Tags innerhalb eines Repositorys zu definieren. Das bedeutet also, dass Du festlegen kannst, dass bestimmte Leute (oder eine Gruppe von Leuten) nur bestimmte „refs“ (Branches oder Tags) pushen können, andere Personen sollen das wiederum nicht können.

<!--### Installing ###-->
### Installation ###

<!--Installing Gitolite is very easy, even if you don’t read the extensive documentation that comes with it.  You need an account on a Unix server of some kind.  You do not need root access, assuming Git, Perl, and an OpenSSH compatible SSH server are already installed.  In the examples below, we will use the `git` account on a host called `gitserver`.-->

Auch ohne Studium der ausführlichen Dokumentation, die Gitolite beiliegt, gestaltet sich die Installtion sehr einfach. Du benötigst dazu einen Account auf irgendeiner Art von Unix Server. Du brauchst keine Root-Rechte, vorausgesetzt Git, Perl und ein OpenSSH kompatibler SSH Server sind bereits installiert. In unserem Beispiel verwenden wir den Benutzer `git` auf einem Host mit dem Namen `gitserver`.

<!--Gitolite is somewhat unusual as far as "server" software goes — access is via SSH, and so every userid on the server is a potential "gitolite host".  We will describe the simplest install method in this article; for the other methods please see the documentation.-->

Gitolite ist in Bezug auf „Server“-Software ein wenig ungewöhnlich — der Zugriff erfolgt per SSH und somit ist jede auf dem Server vorhandene User-Id ein potentieller „gitolite host“. In unserem Beispiel werden wir die einfachste Methode der Installation beschreiben. Die anderen Möglichkeiten können der Dokumentation entnommen werden.

<!--To begin, create a user called `git` on your server and login to this user.  Copy your SSH public key (a file called `~/.ssh/id_rsa.pub` if you did a plain `ssh-keygen` with all the defaults) from your workstation, renaming it to `<yourname>.pub` (we'll use `scott.pub` in our examples).  Then run these commands:-->

Zu Beginn legst Du auf Deinem Server einen Benutzer mit dem Namen `git` an und loggst Dich mit diesem ein. Danach kopierst Du Deinen öffentlichen SSH Schlüssel (die Datei lautet `~/.ssh/id_rsa.pub`, falls Du `ssh-keygen` mit den Standardoptionen ausgeführt hast) von Deiner Workstation auf den Server und nennst ihn entsprechend dem Schema `<yourname>.pub` um (in unserem Beispiel verwenden wir die Datei `scott.pub`). Danach führst Du die folgenden Kommandos aus:

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	    # assumes $HOME/bin exists and is in your $PATH
	$ gitolite setup -pk $HOME/scott.pub

<!--That last command creates new Git repository called `gitolite-admin` on the server.-->

Der letzte Befehl erzeugt ein neues Git Repository mit dem Namen `gitolite-admin` auf Deinem Server.

<!--Finally, back on your workstation, run `git clone git@gitserver:gitolite-admin`. And you’re done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in your workstation.  You administer your Gitolite setup by making changes to this repository and pushing.-->

Zum Abschluss musst Du auf Deiner Workstation den Befehl `git clone git@gitserver:gitolite-admin` ausführen. Jetzt bist Du im Prinzip fertig. Gitolite ist nun auf Deinem Server installiert und auf Deiner Workstation liegt das neue Repository `gitolite-admin` vor. Du kannst Gitolite nun administrieren, indem Du Änderungen an diesem Repository ausführst und zurück auf den Server pushst.

<!--### Customising the Install ###-->
### Benutzerdefinierte Installation ###

<!--While the default, quick, install works for most people, there are some ways to customise the install if you need to.  Some changes can be made simply by editing the rc file, but if that is not sufficient, there’s documentation on customising Gitolite.-->

Obwohl die schnelle Standardinstallation für die meisten Leute ausreicht, gibt es ein paar Möglichkeiten die Installation an Deine Gegebenheiten anzupassen, falls Du dies für nötig hältst. Teilweise reicht es, die rc Datei zu bearbeiten. Sollte das nicht ausreichen, gibt es genügend Dokumentation, die beschreibt, wie Gitolite angepasst werden kann.

<!--### Config File and Access Control Rules ###-->
### Konfigurationsdateien und Regeln für die Zugangskontrolle ###

<!--Once the install is done, you switch to the `gitolite-admin` clone you just made on your workstation, and poke around to see what you got:-->

Nachdem die Installation abgeschlossen ist, wechselst Du in den `gitolite-admin` Klon auf Deiner Workstation und stöberst dort am besten ein wenig herum:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/scott.pub
	$ cat conf/gitolite.conf

	repo gitolite-admin
	    RW+                 = scott

	repo testing
	    RW+                 = @all

<!--Notice that "scott" (the name of the pubkey in the `gitolite setup` command you used earlier) has read-write permissions on the `gitolite-admin` repository as well as a public key file of the same name.-->

Es ist wichtig anzumerken, dass „scott“ (das entspricht dem Name des öffentlichen Schlüssel, den Du beim Ausführen des `gitolite setup` Kommandos angegeben hast) Lese- und Schreibzugriff auf das `gitolite-admin` Repository hat. Zusätzlich existiert eine Datei mit dem gleichen Namen. Diese beinhaltet den öffentlichen Schlüssel.

<!--Adding users is easy.  To add a user called "alice", obtain her public key, name it `alice.pub`, and put it in the `keydir` directory of the clone of the `gitolite-admin` repo you just made on your workstation.  Add, commit, and push the change, and the user has been added.-->

Neue Benutzer hinzuzufügen gestaltet sich einfach. Um einen neuen Anwender mit dem Namen „alice“ hinzuzufügen, benötigst Du ihren öffentlichen Schlüssel. Diesen nennst Du in `alice.pub` um und legst ihn im Verzeichnis `keydir` Deines geklonten `gitolite-admin` Repositorys auf Deiner Workstation ab. Danach stagst Du die Änderungen, commitest diese und pushst sie auf den Server und voi­là, der Benutzer wurde hinzugefügt.

<!--The config file syntax for Gitolite is well documented, so we’ll only mention some highlights here.-->

Die Syntax der Gitolite Konfigurationsdateien ist gut dokumentiert, deshalb gehen wir hier nur auf die wichtigsten Details ein.

<!--You can group users or repos for convenience.  The group names are just like macros; when defining them, it doesn’t even matter whether they are projects or users; that distinction is only made when you *use* the "macro".-->

Einzelne Benutzer oder Repositorys können zur besseren Verwaltung zu Gruppen zusammengefasst werden. Die Gruppennamen verhalten sich wie Makros. Beim Anlegen ist es unabhängig, ob es sich um Projekte oder Benutzer handelt. Diese Festlegung wird erst getroffen, wenn diese „Makros“ verwendet werden.

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

<!--You can control permissions at the "ref" level.  In the following example, interns can only push the "int" branch.  Engineers can push any branch whose name starts with "eng-", and tags that start with "rc" followed by a digit.  And the admins can do anything (including rewind) to any ref.-->

Du kannst die Berechtigungen auf „ref“-Ebene (Branches und Tags) festlegen. Im folgenden Beispiel darf die Gruppe „interns“ nur auf den „int“ Branch pushen. Die Benutzer der Gruppe „engineers“ können jeden Branch pushen, der mit dem Prefix „eng-“ beginnt. Zusätzlich kann diese Gruppe jeden Tag, mit dem Namen „rc“, gefolgt von einer einzelnen Zahl, pushen. Die Benutzer der Gruppe „admins“ können jede Operation für jeden „ref“ durchführen (inklusive Rewind-Operationen).

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

<!--The expression after the `RW` or `RW+` is a regular expression (regex) that the refname (ref) being pushed is matched against.  So we call it a "refex"!  Of course, a refex can be far more powerful than shown here, so don’t overdo it if you’re not comfortable with Perl regexes.-->

Der Ausdruck hinter `RW` oder `RW+` ist ein regulärer Ausdruck (Regex), gegen den die Referenzen (ref), die gepusht werden, verglichen werden. Wir nennen das auch „Refex“. Mit einem solchen Refex hat man ein sehr mächtiges Werkzeug an der Hand und kann noch viel mehr machen, als hier aufgezeigt ist. Aus diesem Grund solltest Du es aber damit auch nicht übertreiben, wenn Du mit den regulären Ausdrücken aus Perl nicht vertraut bist.

<!--Also, as you probably guessed, Gitolite prefixes `refs/heads/` as a syntactic convenience if the refex does not begin with `refs/`.-->

Wie Du vielleicht bereits vermutest hast, stellt Gitolite den Ausdruck `refs/heads/` den Refex voran, wenn diese nicht mit `refs/` beginnen.

<!--An important feature of the config file’s syntax is that all the rules for a repository need not be in one place.  You can keep all the common stuff together, like the rules for all `oss_repos` shown above, then add specific rules for specific cases later on, like so:-->

Ein wichtige Eigenschaft der Syntax der Konfigurationsdatei ist, dass nicht alle Regeln für ein Repository an einer gemeinsamen Stelle festgehalten werden müssen. Du kannst die ganzen allgemeingültigen Dinge, wie zum Beispiel die oben gezeigten Regeln für alle `oss_repos`, an einer Stelle zusammenfassen und später dann spezifische Regeln für die einzelnen Fälle festlegen. Zum Beispiel folgendermaßen:

	repo gitolite
	    RW+                     = sitaram

<!--That rule will just get added to the ruleset for the `gitolite` repository.-->

Diese Regel gehört dann zum Regelsatz des `gitolite` Repository.

<!--At this point you might be wondering how the access control rules are actually applied, so let’s go over that briefly.-->

An dieser Stelle fragst Du Dich vielleicht, wie die Zugriffsregeln eigentlich angewandt werden. Lass uns das kurz anschauen.

<!--There are two levels of access control in Gitolite.  The first is at the repository level; if you have read (or write) access to *any* ref in the repository, then you have read (or write) access to the repository.-->

Es gibt zwei Ebenen für die Zugriffsberechtigung in Gitolite. Die erste befindet sich auf Repository Ebene. Wenn Du Lese- oder Schreifzugriff auf jede Ref in einem Repository hast, dann kannst Du damit das ganze Repository sowohl lesen, als auch schreiben.

<!--The second level, applicable only to "write" access, is by branch or tag within a repository.  The username, the access being attempted (`W` or `+`), and the refname being updated are known.  The access rules are checked in order of appearance in the config file, looking for a match for this combination (but remember that the refname is regex-matched, not merely string-matched).  If a match is found, the push succeeds.  A fallthrough results in access being denied.-->

Die zweite Ebene bezieht sich auf Branches oder Tags innerhalb eines Repositorys. Auf dieser Ebene kann allerdings nur der Schreibzugriff beschränkt werden. Der Benutzername, die Art des Zugriffs (`W` oder `+`) und der Refname, der aktualisiert wird, sind bekannt. Gitolite prüft, ob einer dieser Regeln auf diese Kombination zutrifft (hierbei ist allerdings zu beachten, dass der Refname mit dem regulären Ausdruck verglichen und kein eins zu eins String-Vergleich durchgeführt wird). Die Zugriffsregeln werden entsprechend der Reihenfolge innerhalb der Konfigurationsdatei abgearbeitet. Wenn eine Kombination zutrifft, kann der Push durchgeführt werden. Trifft keine zu, dann wird der Push verweigert.

<!--### Advanced Access Control with "deny" rules ###-->
### Erweiterte Zugriffsberechtigungen mit „deny“ Regeln ###

<!--So far, we’ve only seen permissions to be one of `R`, `RW`, or `RW+`.  However, Gitolite allows another permission: `-`, standing for "deny".  This gives you a lot more power, at the expense of some complexity, because now fallthrough is not the *only* way for access to be denied, so the *order of the rules now matters*!-->

Bis jetzt waren alle vorgestellten Berechtigungen entweder `R`, `RW`, oder `RW+`. Gitolite kennt aber noch eine weitere Berechtigung: `-`, welche für „deny“, also ablehnen steht. Dies gibt Dir noch viel mehr Möglichkeiten, allerdings auf Kosten der Komplexität, denn ab jetzt ist ein Falltrough nicht die einzige Möglichkeit, wie ein Zugriff auf das Repository abgelehnt wird. Das heißt, die Reihenfolge der aufgestellte Regeln, hat auch eine Bedeutung.

<!--Let us say, in the situation above, we want engineers to be able to rewind any branch *except* master and integ.  Here’s how to do that:-->

Nehmen wir mal an, dass bei unserem bekannten Beispiel, die Gruppe „engineers“ auf alle Branches, außer master und integ, Rewind-Rechte haben soll. Das können wir folgendermaßen erreichen:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

<!--Again, you simply follow the rules top down until you hit a match for your access mode, or a deny.  Non-rewind push to master or integ is allowed by the first rule.  A rewind push to those refs does not match the first rule, drops down to the second, and is therefore denied.  Any push (rewind or non-rewind) to refs other than master or integ won’t match the first two rules anyway, and the third rule allows it.-->

Noch einmal zur Wiederholung, man muss jede einzelne Regel von oben nach unten durchgehen und überprüfen, ob eine Regel auf den aktuellen Zugriffsmodus zutrifft oder ob eine Deny-Regel den Zugriff verhindert. Ein Push auf den Branch master oder integ, welcher nicht einem Rewind Push entspricht, wird durch die erste Regel erlaubt. Ein Rewind Push auf diese Refs trifft also auf die erste Regel nicht zu. Deshalb wird die zweite Regel geprüft und auf Grund der Deny-Regel wird der Push verweigert. Jeder Push (unabhängig, ob es sich um einen Rewind Push oder einen normalen Push handelt) auf eine Ref, welche nicht master oder integ entspricht, trifft nicht auf einer der beiden ersten Regeln zu, und wird damit auf Grund der dritten Regel erlaubt.

<!--### Restricting pushes by files changed ###-->
### Ein Push auf Basis von Dateiänderungen einschränken ###

<!--In addition to restricting what branches a user can push changes to, you can also restrict what files they are allowed to touch.  For example, perhaps the Makefile (or some other program) is really not supposed to be changed by just anyone, because a lot of things depend on it or would break if the changes are not done *just right*.  You can tell Gitolite:-->

Neben der Zugriffsbeschränkung auf Basis von Branches, kannst Du genauso verhindern, dass eine Änderung an einer bestimmten Datei gepusht wird. Beispielsweise ist ein Makefile (oder auch andere Programme) nicht dafür geeignet, dass es von jeder x-beliebiegen Person geändert wird. Meist hängen von so einem Makefile viele Dinge ab oder vieles könnte schief laufen, wenn die Änderungen an der Datei nicht korrekt durchgeführt werden würden. Du kannst deshalb Gitolite folgendermaßen konfigurieren:

    repo foo
        RW                      =   @junior_devs @senior_devs

        -   VREF/NAME/Makefile  =   @junior_devs

<!--User who are migrating from the older Gitolite should note that there is a significant change in behaviour with regard to this feature; please see the migration guide for details.-->

Alle Anwender von älteren Gitolite Versionen, die auf eine neue Gitolite Version wechseln, sollten darauf achten, dass sich die neue Version signifikant anders im Bezug auf dieses Feature verhält. Die Umstellungsanleitung (migration guide) weist hier auf weitere Details hin.

<!--### Personal Branches ###-->
### Personenbezogene Branches ###

<!--Gitolite also has a feature called "personal branches" (or rather, "personal branch namespace") that can be very useful in a corporate environment.-->

Gitolite bietet mit den „personal branches“ (genauer „personal branch namespace“) eine weitere Eigenschaft, die im Unternehmensumfeld sehr hilfreich sein kann.

<!--A lot of code exchange in the Git world happens by "please pull" requests.  In a corporate environment, however, unauthenticated access is a no-no, and a developer workstation cannot do authentication, so you have to push to the central server and ask someone to pull from there.-->

Jede Menge Codeänderungen in der Welt von Git passieren, weil jemand einen Pull-Request durchführt. Im Unternehmensumfeld ist ein anonymer Zugriff ein absolutes No-Go und oft kann eine Entwickler Workstation keine Authentifizierung bieten. Deshalb müssen die Änderungen an den zentralen Server gepusht werden und jemand anders muss diese von dort abholen.

<!--This would normally cause the same branch name clutter as in a centralised VCS, plus setting up permissions for this becomes a chore for the admin.-->

Dies würde normalerweise zu dem gleichen Branchnamen-Wirrwarr führen, wie es in zentralisierten Versionskontrollsystemen anzufinden ist. Außerdem wäre es für den Administrator äußerst lästig, die ganzen Berechtigungen dafür zu setzen.

<!--Gitolite lets you define a "personal" or "scratch" namespace prefix for each developer (for example, `refs/personal/<devname>/*`); please see the documentation for details.-->

Gitolite lässt die Definition eines „personal“ oder „scratch“ Namensraum für jeden einzelnen Entwickler zu (zum Beispiel: `refs/personal/<devname>/*`). Die Dokumentation enthält dazu weitere Details.

<!--### "Wildcard" repositories ###-->
### „Wildcard“ Repositorys ###

<!--Gitolite allows you to specify repositories with wildcards (actually Perl regexes), like, for example `assignments/s[0-9][0-9]/a[0-9][0-9]`, to pick a random example.  It also allows you to assign a new permission mode (`C`) which enables users to create repositories based on such wild cards, automatically assigns ownership to the specific user who created it, allows him/her to hand out `R` and `RW` permissions to other users to collaborate, etc.  Again, please see the documentation for details.-->

Mit Platzhaltern (eigentlich Perl reguläre Ausdrücke), wie zum Beispiel `assignments/s[0-9][0-9]/a[0-9][0-9]`, kannst Du in Gitolite auch Repositorys definieren. Außerdem bietet Gitolite eine neuen Berechtigungsmodus (`C`), welcher es den Benutzern ermöglicht, auf Basis dieser Platzhalter, Repositorys zu erzeugen. Dem Benutzer, der das Repository erzeugt hat, wird dieses automatisch zugewiesen, was es ihm oder ihr ermöglicht anderen Benutzern Lese- oder Schreibrechte (`R` und `RW`) zuzuweisen, damit diese zum Projekt beitragen können. Wieder möchte ich Dich darauf hinweisen, dass die Dokumentation weitere Details enthält.

<!--### Other Features ###-->
### Weitere Besonderheiten ###

<!--We’ll round off this discussion with a sampling of other features, all of which, and many more, are described in great detail in the documentation.-->

Ich möchte das Thema Gitolite abschließen, indem ich noch ein paar weitere Besonderheiten kurz anspreche. Diese und viele weitere Features von Gitolite werden ausführlich in der Dokumentation beschrieben.

<!--**Logging**: Gitolite logs all successful accesses.  If you were somewhat relaxed about giving people rewind permissions (`RW+`) and some kid blew away `master`, the log file is a life saver, in terms of easily and quickly finding the SHA that got hosed.-->

**Protokollierung**: Gitolite protokolliert alle Zugriffe, die erfolgreich waren. Wenn Du ein bisschen nachlässig bei der Vergabe von Rewind-Rechten (`RW+`) warst und irgendeiner der Personen mit Rewinde-Rechte dann den `master` zerstört, dann kann Dir die Protokolldatei eine Menge Arbeit ersparen, weil sie Dir hilft, leicht und schnell die SHA Prüfsumme zu finden, die dem Erdboden gleich gemacht wurde.

<!--**Access rights reporting**: Another convenient feature is what happens when you try and just ssh to the server.  Gitolite shows you what repos you have access to, and what that access may be.  Here’s an example:-->

**Zugriffsrechte herausfinden**: Ein anderes praktisches Merkmal von Gitolite lernst Du kennen, wenn Du versuchst Dich über SSH auf dem Server einzuloggen. Gitolite zeigt Dir dann alle Repositorys an, auf die Du Zugriff hast und welche Berechtigung Du für diese hast. Hierzu ein Beispiel:

        hello scott, this is git@git running gitolite3 v3.01-18-g9609868 on git 1.7.4.4

             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

<!--**Delegation**: For really large installations, you can delegate responsibility for groups of repositories to various people and have them manage those pieces independently.  This reduces the load on the main admin, and makes him less of a bottleneck.-->

**Administration aufteilen**: Bei richtig großen Installationen kannst Du die Verantwortlichkeit für verschiedene Gruppen von Repositorys an verschiedene Leute verteilen, damit diese die Repositorys unabhängig verwalten können. Das macht das Leben des Haupt-Administrator leichter und verhindert, dass er der Flaschenhals im System ist.

<!--**Mirroring**: Gitolite can help you maintain multiple mirrors, and switch between them easily if the primary server goes down.-->

**Spiegelung**: Gitolite kann Dir helfen verschiedene Mirrors (Spiegelserver) zu verwalten. Außerdem ist es damit einfach zwischen verschiedenen Mirrors zu wechseln, wenn der primäre Server offline ist.

<!--## Git Daemon ##-->
## Git Daemon ##

<!--For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.-->

Wenn Du anonymen, öffentlichen Lesezugriff für Deine Repositorys zur Verfügung stellen willst, solltest Du Dir mal das Git Protokoll, als Ersatz für das HTTP Protokoll anschauen. Der Hauptgrund dafür ist die Geschwindigkeit. Das Git Protokoll ist weitaus effizienter und deshalb viel schneller als das HTTP Protokoll. Wenn Du Deinen Anwendern Zeit ersparen willst, solltest Du es zur Verfügung stellen.

<!--Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.-->

Ich möchte Dich noch mal darauf hinweisen, dass das Git Protokoll nur für anonymen (also ohne Authentifizierung) Lesezugriff geeignet ist. Wenn Du einen öffentlichen Server betreibst, sollte das Git Protokoll nur für Projekte eingesetzt werden, die öffentlich für den Rest einsehbar sein sollen. Innerhalb Deines eigenen Netzwerks, welches mit einer Firewall abgeschottet ist, ist es sinnvoll, da Du mit dem Git Protokoll einer großen Anzahl von Benutzern und Computern (Continuous Integration oder Build-Server), Lesezugriff zur Verfügung stellen kannst, ohne dass Du für jeden einzelnen Nutzer ein SSH Schlüssel verwalten musst.

<!--In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:-->

Auf jeden Fall ist es sehr einfach das Git Protokoll einzurichten. Im Prinzip musst Du nur folgendes tun:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

<!--`-\-reuseaddr` allows the server to restart without waiting for old connections to time out, the `-\-base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.-->

Mit `--reuseaddr` teilst Du dem Server mit, dass ein Neustart sofort durchgeführt werden kann, ohne darauf zu warten, dass alte, offene Verbindungen mit einem Timeout abbrechen. Die Option `--base-path` erlaubt es den Nutzern, Projekte zu klonen, ohne den gesamten Pfad angeben zu müssen. Die Pfadangabe als letztes Argument gibt dem Daemon an, wo sich die zu exportierenden Repositorys befinden. Wenn Du eine Firewall eingerichtet hast, musst Du zusätzlich den Port 9418 freischalten.

<!--You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file-->

Du kannst den Hintergrunddienst für diesen Prozess auf verschiedene Art und Weise einrichten. Das ist natürlich abhängig vom verwendeten Betriebssystem. Auf einem Ubuntu System kannst Du dazu ein Upstart Skript verwenden. Zum Beispiel fügst Du in der folgenden Datei

	/etc/event.d/local-git-daemon

<!--you put this script:-->

das folgende Skript ein (Achtung: In neueren Ubuntu-Versionen lautet der Pfad /etc/init):

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

<!--For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories — you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.-->

Aus Sicherheitsgründen wird dringend empfohlen, dass dieser Daemon als Benutzer ausgeführt wird, welcher nur Lesezugriff auf die betreffenden Repositorys hat. Du stellst das auf einfache Art und Weise sicher, indem Du einen neuen Benutzer ‚git-ro‘ erstellst und den Daemon mit diesem ausführst. Einfachheitshalber verwenden wir hier den Benutzer ‚git‘, den wir auch schon für Gitosis verwendet haben.

<!--When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:-->

Nach einem Neustart des System wird der Git Daemon automatisch starten. Er startet ebenso neu, wenn er unerwartet beendet wird. Der Daemon kann auch ohne einen Neustart gestartet werden:

	initctl start local-git-daemon

<!--On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.-->

Auf anderen Systemen kannst Du `xinetd`, ein Skript in der `sysvinit`-Umgebung oder irgendetwas anderes verwenden. Du musst nur sicherstellen, dass der Befehl als Hintergrunddienst ausgeführt wird.

<!--Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for the `iphone_project`, you add this to the end of the `gitosis.conf` file:-->

Als nächstes musst Du dem Gitosis Server mitteilen, für welche Repositorys ein anonymer Zugriff über das Git Protokoll möglich sein soll. Für jedes einzelne Repository kannst Du individuell festlegen, ob der Git Daemon auf dieses Zugriff haben soll. Wenn Du beispielsweise das Git Protokoll für das Projekt `iphone_project` erlauben willst, kannst Du folgendes am Ende der Konfigurationsdatei `gitosis.conf` einfügen:

	[repo iphone_project]
	daemon = yes

<!--When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.-->

Nachdem Du dies eingecheckt und gepusht hast, sollte Dein im Hintergrund laufender Git Daemon die Anfragen aller Benutzer, die Zugriff auf den Port 9418 haben, bearbeiten.

<!--If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:-->

Wenn Du Dich gegen Gitosis entschieden hast, aber trotzdem dem Git Daemon verwenden willst, musst Du auf dem Server für jedes Projekt, welches der Git Daemon zur Verfügung stellen soll, folgendes ausführen:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

<!--The presence of that file tells Git that it’s OK to serve this project without authentication.-->

Wenn diese Datei existiert, erlaubt Git einen anonymen Lesezugriff auf dieses Projekt.

<!--Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:-->

In Gitosis kann man ebenso einstellen, welche Projekte in GitWeb dargestellt werden sollen. Dazu musst Du als erstes in etwa folgendes in die Konfigurationsdatei `/etc/gitweb.conf` einfügen:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

<!--You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the `iphone_project` to show up on GitWeb, you make the `repo` setting look like this:-->

Um für die einzelnen Projekte festzulegen, dass diese in GitWeb auftauchen, musst Du die Einstellung `gitweb` in der Gitosis Konfigurationsdatei festlegen. Wenn Du beispielsweise willst, dass das Repository `iphone_project` in GitWeb erscheint, muss die Einstellung `repo` in etwa folgendermaßen aussehen:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

<!--Now, if you commit and push the project, GitWeb will automatically start showing the `iphone_project`.-->

Das Projekt `iphone_projekt` wird automatisch in GitWeb angezeigt, sobald Du die Änderungen eingecheckt und auf den Server gepusht hast.

<!--## Hosted Git ##-->
## Git Hosting ##

<!--If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.-->

Wenn Du Dir die ganze Arbeit sparen willst, die beim Einrichten eines eigenen Git Servers so anfällt, kannst Du auch einen der vielen Hosting-Anbieter benutzen, um Deine Git Projekte zu verwalten. Wenn Du Dich für diese Option entscheidest, hat das gewisse Vorteile: Die Konfiguration bei den Hosting-Anbietern ist meist sehr schnell durchgeführt und Du kannst sofort mit Deinen Projekten loslegen. Zusätzlich ersparst Du Dir die Wartung und Überwachung Deines eigenen Servers. Auch wenn Du für Deine privaten oder firmeninternen Projekte einen eigenen Server betreibst, sind solche Hosting-Anbieter nützlich, da Du diese dann für Deine Open-Source Projekte verwenden kannst. Dadurch wirst Du innerhalb der Open-Source Community leichter gefunden und es ist einfacher Dir bei Deinen Projekten zu helfen.

<!--These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the following page:-->

Heutzutage stehen Dir viele Anbieter zur Auswahl. Jeder hat seine Vor- und Nachteile. Eine aktuelle Liste von Anbietern findest Du auf der folgenden Seite:

	https://git.wiki.kernel.org/index.php/GitHosting

<!--Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved.-->

Da wir nicht alle Anbieter vorstellen können und ich zufälligerweise bei einem der Anbieter, nämlich GitHub,  arbeite, werde ich in diesem Kapitel auf diese Plattform näher eingehen. Wir werden die Erstellung eines Accounts und die Erzeugung eines Projekts auf GitHub besprechen. Das sollte Dir einen leichten Einstieg in die Welt von GitHub ermöglichen.

<!--GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.-->

GitHub ist die mit Abstand größte Open-Source Git Hosting Plattform und bietet als einer der wenigen, sowohl öffentliche und private Hosting-Optionen. Das erlaubt es Dir, Deine Open-Source Projekte und proprietären Code in einer einzelnen Plattform zu verwalten. Sogar für dieses Buch haben wir GitHub benutzt, um gemeinsam unter Ausschluss der Öffentlichkeit daran zu arbeiten.

<!--### GitHub ###-->
### GitHub ###

<!--GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.-->

GitHub verwaltet und gruppiert Projekte ein wenig anders ein, als andere Code-Hosting Webseiten. GitHub fokussiert sich dabei nicht speziell auf die Projekte, sondern eher auf den Anwender. Dazu ein Beispiel. Wenn ich mein Projekt `grit` auf GitHub einstelle, dann findet man dieses nicht unter `github.com/grit`, sondern unter `github.com/schacon/grit`. Es gibt in diesem Sinne, keine in Stein gemeißelte Stelle an dem das Projekt verwaltet wird. Das bedeutet, man kann ein Projekt nahtlos von einem Benutzer zu einem anderen Benutzer übertragen, wenn dieser zum Beispiel das Projekt aufgibt.

<!--GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.-->

Wenn ein Anwender ein geschützes, nicht öffentliches Repository auf GitHub verwalten will, so muss er dafür bezahlen. Damit verdient die Firma GitHub ihr Geld. Aber die Verwaltung und Nutzung für Open-Source Projekte ist kostenlos. Die Anzahl der Projekte ist dabei nicht beschränkt. Der Nutzer muss dazu lediglich einen Account erstellen. Wie das geht, möchte ich hier kurz vorstellen.

<!--### Setting Up a User Account ###-->
## Einrichten eines Benutzeraccounts ###

<!--The first thing you need to do is set up a free user account. If you visit the "Plans and pricing" page at `https://github.com/pricing` and click the "Sign Up" button on the Free account (see Figure 4-2), you’re taken to the signup page.-->

Um loslegen zu können, musst Du Dir einen Benutzeraccount erstellen. Gib dazu die Adresse `https://github.com/pricing` in Deinem Browser ein und wähle den Button „Sign Up“ unter dem „Free account“-Bereich aus (siehe Abbildung 4-2). Danach wirst Du auf die Anmeldeseite weitergeleitet.

<!--Figure 4-2. The GitHub plan page.-->

Insert 18333fig0402.png
Abbildung 4-2. Die Angebotsseite von GitHub.

<!--Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).-->

Auf dieser Seite musst Du einen Nutzernamen auswählen, der bisher im System nicht vorhanden ist. Zusätzlich musst Du Deine E-Mail Adresse angeben, die mit Deinem Account verknüpft wird, und ein Passwort angeben (siehe Abbildung 4-3).

<!--Figure 4-3. The GitHub user signup form.-->

Insert 18333fig0403.png
Abbildung 4-3. Das Formular für die GitHub Benutzerregistrierung.

<!--If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.-->
<!--Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).-->

Wenn Du Deinen öffentlichen SSH Schlüssel zur Hand hast, kannst Du diesen auch gleich bei der Registrierung angeben. Die Vorgehensweise zum Generieren eines Schlüssels haben wir bereits im Kapitel 4.3 besprochen. Du musst den Inhalt der öffentlichen Schlüsseldatei kopieren und in das „SSH Public Key“ Formularfeld einfügen. Wenn Du auf den „explain ssh keys“ Link klickst, erhälst Du detailierte Anweisungen zum Ausführen dieses Vorgangs auf verschiedenen Betriebssystemen. Wenn Du auf den „I agree, sign me up“ Button drückst, landest Du in Deinem neuen Benutzer-Dashboard (siehe Abbildung 4-4).

<!--Figure 4-4. The GitHub user dashboard.-->

Insert 18333fig0404.png
Abbildung 4-4. Das GitHub Benutzer-Dashboard.

<!--Next you can create a new repository.-->

Im nächsten Schritt kannst Du ein neues Repository erzeugen.

<!--### Creating a New Repository ###-->
### Erzeugen eines neuen Repository ###

<!--Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).-->

Um ein neues Repository anzulegen, musst Du auf den „create a new one“-Link, welcher neben Deinen Repositorys auf dem Benutzer-Dashboard angezeigt wird, klicken. Du landest daraufhin im Formular zum Erzeugen eines neuen Repositorys (siehe Abbildung 4-5).

<!--Figure 4-5. Creating a new repository on GitHub.-->

Insert 18333fig0405.png
Abbildung 4-5. Erzeugen eines Repositorys auf GitHub.

<!--All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).-->

Im Prinzip musst Du nur einen Projektnamen und wenn Du es für nötig erachtest eine Beschreibung Deines Projekts angeben. Wenn das erledigt ist, kannst Du auf den „Create Repository“ Button klicken. Du hast soeben Dein erstes Repository auf GitHub erzeugt (siehe Abbildung 4-6).

<!--Figure 4-6. GitHub project header information.-->

Insert 18333fig0406.png
Abbildung 4-6. GitHub Projektinformationen.

<!--Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).-->

Da in dem Repository noch kein Code enthalten ist, gibt Dir GitHub ein paar Hinweise, wie Du ein neues Projekt anlegst, wie Du ein bereits vorhandes Git Projekt auf GitHub pusht oder wie man ein bestehendes Subversion Repository in GitHub importieren kann (siehe Abbildung 4-7).

<!--Figure 4-7. Instructions for a new repository.-->

Insert 18333fig0407.png
Abbildung 4-7. Anleitung zum Erzeugen eines neuen Repository.

<!--These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use-->

Die Hilfestellung entspricht der Vorgehensweise, die ich bereits in diesem Buch vorgestellt habe. Um ein neues Git Projekt in einem vorhandenen Verzeichnis anzulegen, kannst Du die folgenden Befehle verwenden:

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

<!--When you have a Git repository locally, add GitHub as a remote and push up your master branch:-->

Wenn Du bereits ein lokales Git Repository auf Deinem PC hast, kannst Du GitHub als zusätzlichen Remote hinzufügen und den master Branch pushen:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

<!--Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).-->

Das war es schon. Dein Projekt ist nun auf GitHub erreichbar. Du kannst jetzt die zugehörige URL an jeden weitergeben, den Du am Projekt teilhaben lassen willst. In unserem Beispiel lautet der Link hierfür `http://github.com/testinguser/iphone_project`. Im oberen Header-Bereich jeder Projektseite werden zwei verschiedene Git URLs angezeigt (siehe Abbildung 4-8).

<!--Figure 4-8. Project header with a public URL and a private URL.-->

Insert 18333fig0408.png
Abbildung 4-8. Projekt Header mit der Angabe der öffentlichen und privaten URL.

<!--The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.-->

Die „Public Clone URL“ ist eine öffentliche Git URL, die man zum Klonen des Projekts verwenden kann. Über diese URL kann lediglich lesend zugegriffen werden. Ein Schreibzugriff ist nicht möglich. Du kannst diese URL beliebig weiter verteilen und zum Beispiel auch auf Deiner Homepage oder einem anderen Medium veröffentlichen.

<!--The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.-->

Die „Your Clone URL“ ist eine auf SSH basierte URL, mit Hilfe derer, vom Projekt gelesen, als auch geschrieben werden kann. Diese URL kann aber nur der Anwender nutzen, der im Besitz des privaten Schlüssel ist, welcher zu dem öffentlichen Schlüssel gehört, der bei dem GitHub Benutzer für dieses Projekt hinterlegt ist (Du hast den öffentlichen Schlüssel bei der Registrierung Deines Accounts angegeben).. Dieser Link wird allerdings nur Dir angezeigt. Andere Benutzer, die Deine Projekte besuchen, können nur die „Public Clone URL“ sehen.

<!--### Importing from Subversion ###-->
### Import von Subversion ###

<!--If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).-->

Wenn Du bereits ein Subversion Projekt hast und dieses in Git importieren möchtest, kann GitHub Dir diese Aufgabe in vielen Fällen übernehmen. Am Ende der Seite mit den Hilfestellungen ist ein Link, der Dich auf die Seite mit dem Formular zum Importieren eines Subversion Projekts weiterleitet. Du musst in diesem Formular nur die URL des Subversion Projekts angeben (siehe Abbildung 4-9).

<!--Figure 4-9. Subversion importing interface.-->

Insert 18333fig0409.png
Abbildung 4-9. Import-Schnittstelle für Subversion Projekte.

<!--If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.-->

Wenn Dein Projekt sehr groß, nicht standardkonform oder nicht öffentlich einsehbar ist, kann es passieren das dieser Vorgang fehlschlägt. In Kapitel 7 liefere ich die Antwort, wie ein solcher Import, manuell durchgeführt werden kann.

<!--### Adding Collaborators ###-->
### Mitarbeiter hinzufügen ###

<!--Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.-->

Um gemeinsam an einem Projekt zu arbeiten, kannst Du auch andere Personen für das Projekt freischalten. Wenn Du willst das John, Josie und Jessica ebenso auf das Projekt pushen können, musst Du sie als Mitarbeiter für Dein Projekt freischalten. Voraussetzung hierfür ist natürlich, dass Sie alle einen GitHub Account besitzen. Nachdem Du sie zum Projekt hinzugefügt hast, können sie unter Verwendung ihrer öffentlichen Schlüssel auf das Projekt pushen.

<!--Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).-->

Klicke auf die „edit“-Schaltfläche in der Projektübersicht oder wähle den Admin-Tab im oberen Bereich Deines Projekts um zur Administrationsoberfläche zu gelangen (siehe Abbildung 4-10).

<!--Figure 4-10. GitHub administration page.-->

Insert 18333fig0410.png
Abbildung 4-10. GitHub Administrationsoberfläche.

<!--To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).-->

Um einem anderen Benutzer Schreibrechte zu Deinem Projekt zu gewähren, kannst Du auf den „Add another collaborator“-Link klicken. Daraufhin erscheint ein Eingabefeld, in welches Du die Benutzer eingeben kannst. Während des Tippens, erscheint ein kleines Popup, welches Benutzernamen anzeigt, die Deiner Eingabe entsprechen. Wenn Du den gewünschten Benutzer gefunden hast, kannst Du die „Add“-Schaltfläche betätigen, um diesen Benutzer als Mitarbeiter zu Deinem Projekt hinzuzufügen (siehe Abbildung 4-11).

<!--Figure 4-11. Adding a collaborator to your project.-->

Insert 18333fig0411.png
Abbildung 4-11. Ein Mitarbeiter zu Deinem Projekt hinzufügen.

<!--When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).-->

Wenn Du Dein Team fertig zusammengestellt hast, solltest Du eine Liste aller Mitarbeiter im „Repository Collaborators“-Bereich sehen (siehe Abbildung 4.12).

<!--Figure 4-12. A list of collaborators on your project.-->

Insert 18333fig0412.png
Abbildung 4-12. Übersicht über alle Mitarbeiter in Deinem Projekt.

<!--If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.-->

Wenn Du einer Person den Zugriff auf Dein Repository entziehen willst, kannst Du auf den „revoke“-Link klicken. Dadurch kann diese Person nicht mehr auf Dein Repository pushen. Für zukünftige Projekte kannst Du die Liste der Benutzer auch für andere Projekte übernehmen.

<!--### Your Project ###-->
### Dein Projekt ###

<!--After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.-->

Nachdem Du das erste mal auf das GitHub Repository gepusht hast oder es von Subversion importiert hast, sieht die Hauptseite Deines GitHub-Projekts entsprechend Abbildung 4-13 aus.

<!--Figure 4-13. A GitHub main project page.-->

Insert 18333fig0413.png
Abbildung 4-13. Beispiel einer Hauptseite eines GitHub-Projekts.

<!--When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.-->

Wenn andere Dein Projekt in GitHub aufrufen, sehen sie als erstes diese Hauptseite. Die verschiedenen Funktionen, die GitHub für ein Projekt unterstützt, sind in verschiedene Tabs aufgeteilt. Der „Commit“-Tab enthält eine Liste aller Commits in chronologischer Reihenfolge. Dabei steht der neueste Commit ganz oben. Eine ähnliche Liste erhälst Du, wenn Du den `git log` Befehl ausführst. Der „Network“-Tab zeigt alle Benutzer an, die ein Fork von Deinem Projekt erstellt haben und Ihren Teil zum Projekt beigetragen haben. Im „Download“-Tab kannst Du Binärdateien hochladen oder Zip-Archive beziehungsweise Tarballs zur Verfügung stellen, die einem bestimmten Tag Deines Projekts entsprechen. Im „Wiki“-Tab findest Du ein Wiki, welches Du zu Dokumentationszwecken verwenden kannst. Außerdem kannst Du dort andere Informationen über Dein Projekt der Welt mitteilen. Der „Graphs“-Tab stellt Dir eine grafische Übersicht zur Verfügung, die Dir anzeigt, wer und wann jemand etwas zu Deinem Projekt beigetragen hat. Außerdem enthält dieser Tab eine Projekt-Statistik. Der „Source“-Tab, welcher standardmäßig beim Aufruf Deines Projekts angezeigt wird, zeigt das oberste Verzeichnis Deines Repositorys an. Wenn Dein Projekt eine README-Datei enthält, wird der Inhalt dieser Datei unterhalb der Verzeichnisstruktur angezeigt. Zusätzlich zeigt dieser Tab eine Übersicht mit den letzten Commit-Informationen an.

<!--### Forking Projects ###-->
### Fork von einem Projekt erstellen ###

<!--If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.-->

Wenn Du an einem bereits vorhandenen Projekt mitarbeiten willst und Du zu diesem keine Schreibrechte hast, bietet Dir GitHub die Möglichkeit einen Fork von diesem Projekt zu erstellen. Wenn Du beim Stöbern durch GitHub bei einem interessanten Projekt landest und Du damit ein bisschen spielen willst, kannst Du die „Fork“-Schaltfläche im Projekt-Header auswählen. GitHub kopiert das gesamte Projekt in Deinen Benutzerbereich. Auf dieses kannst Du jetzt auch pushen.

<!--This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.-->

Dadurch das jeder, jedes Projekt kopieren kann, muss sich der Verwalter eines Projekts nicht darum kümmern, das jedem Mitarbeiter die entsprechenden Schreibrechte erhält. Man kann einfach einen Fork erstellen und auf diesen pushen. Der Verwalter des geforkten Projekts kann dieses neue Projekt als neuen Remote hinzufügen und die Änderungen davon holen. Dann kann er diese Änderungen in das Hauptprojekt mergen.

<!--To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).-->

Um einen Fork von einem Projekt zu erstellen, kannst Du die jeweilige Projektseite besuchen (in diesem Fall mojombo/chronic) und die „Fork“-Schaltfläche im oberen Bereich auswählen (siehe Abbildung 4-14).

<!--Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.-->

Insert 18333fig0414.png
Abbildung 4-14. Durch Betätigen der „Fork“-Schaltfläche erhält man eine Kopie eines Repositorys, auf welches man Schreibrechte hat.

<!--After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).-->

Nach ein paar Sekunden wirst Du zu der neuen Projektseite weitergeleitet. Dort siehst Du auch, dass dieses Projekt ein Fork eines anderen Projekts ist (siehe Abbildung 4-15).

<!--Figure 4-15. Your fork of a project.-->

Insert 18333fig0415.png
Abbildung 4-15. Dein Fork eines Projekts.

<!--### GitHub Summary ###-->
### GitHub Zusammenfassung ###

<!--That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.-->

Das war alles was ich über GitHub berichten möchte. Herausheben möchte ich aber, dass sich die Arbeit mit GitHub sehr einfach gestaltet. Innerhalb kürzester Zeit kannst Du Dir einen Account einrichten, ein neues Projekt hinzufügen und auf dieses pushen. Wenn Dein Projekt ein Open-Source Projekt ist und damit öffentlich einsehbar ist, steht Dir mit GitHub eine riesige Community mit zahlreichen Entwicklern zur Seite, die sich an Deinem Projekt beteiligen können, indem sie einen Fork erstellen. Vielleicht gelingt Dir mit GitHub der Einstieg in die Welt von Git noch einfacher.

<!--## Summary ##-->
## Zusammenfassung ##

<!--You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.-->

Es stehen Dir viele Möglichkeiten offen, ein Remote-Repository einzurichten, sodass Du mit anderen Entwicklern zusammenarbeiten kannst und Deine Arbeit anderen zur Verfügung stellen kannst.

<!--Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.-->

Wenn Du Deinen eigenen Server betreibst, stehen Dir natürlich alle Möglichkeiten offen und Du kannst ihn entsprechend Deiner Anforderungen konfigurieren. Denoch darf man den Zeitaufwand zum Aufsetzen und Warten des Servers nicht unterschätzen. Wenn Du Deine Repositorys bei einem Hosting-Anbieter verwaltest, hält sich der Aufwand für die Einrichtung und Wartung in Grenzen, allerdings vertraust Du Deine Daten auch einem fremden Anbieter an, was manche Firmen oder Organisationen untersagen.

<!--It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.-->

Es sollte Dir nicht schwerfallen eine passende Lösung für Dich, Deine Firma oder Deine Organisation zu finden.
