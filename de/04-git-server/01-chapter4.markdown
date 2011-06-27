# Git on the Server #
# Git auf dem Server #

At this point, you should be able to do most of the day-to-day tasks for which you’ll be using Git. However, in order to do any collaboration in Git, you’ll need to have a remote Git repository. Although you can technically push changes to and pull changes from individuals’ repositories, doing so is discouraged because you can fairly easily confuse what they’re working on if you’re not careful. Furthermore, you want your collaborators to be able to access the repository even if your computer is offline — having a more reliable common repository is often useful. Therefore, the preferred method for collaborating with someone is to set up an intermediate repository that you both have access to, and push to and pull from that. We’ll refer to this repository as a "Git server"; but you’ll notice that it generally takes a tiny amount of resources to host a Git repository, so you’ll rarely need to use an entire server for it.

Zum jetzigen Zeitpunkt solltest du in der Lage sein, die am häufigsten wiederkehrenden Aufgaben mit Git zu lösen. Um Zusammenarbeit zu ermöglichen solltest du jedoch darüber nachdenken, ein externes Repository zur Verfügung stellen. Wenngleich es technisch ohne Weiteres möglich ist, direkt mit Repositories Anderer zu arbeiten und Änderungen dorthin zu pushen oder von dort zu holen, macht es dieses Vorgehen zu leicht Verwirrung zu stiften. Wenn man nicht vorsichtig ist, verliert man schnell den Überblick darüber wer woran arbeitet. Des weiteren erfordert der direkte Umgang mit Git Repositories, dass diese permanent verfügbar sind. Ein Repository auf dem eigenen Computer ist nur dann für alle Mitentwickler erreichbar, wenn der Computer läuft. Es macht deshalb Sinn, ein zentrales und zuverlässig erreichbares Repository einzurichten. Wir werden dieses Repository im Folgenden als "Git Server" bezeichnen. Es sollte jedoch schnell klar werden, dass nur minimale Ressourcen notwendig sind, um Git Repositories zu hosten. In den seltensten Fällen ist ein dedizierter Server dafür notwendig.

Running a Git server is simple. First, you choose which protocols you want your server to communicate with. The first section of this chapter will cover the available protocols and the pros and cons of each. The next sections will explain some typical setups using those protocols and how to get your server running with them. Last, we’ll go over a few hosted options, if you don’t mind hosting your code on someone else’s server and don’t want to go through the hassle of setting up and maintaining your own server.

Einen Git Server zu betreiben ist einfach. Die erste Entscheidung, die zu treffen ist, ist die des zu verwendenden Protokolls zur Kommunikation mit dem Server. Der erste Teil dieses Kapitels wird deshalb die zur Verfügung stehenden Protokolle und ihre Vor und Nachteile beschreiben. Darüber hinaus werden einige typische Konfigurationen zum Betreiben eines Git Servers vorgestellt. Für den Fall, dass keine Bedenken bestehen, Code von externen Anbietern hosten zu lassen, werden zuletzt ein paar Optionen für gehostete Git Repositories gezeigt. Dies erspart die Mehrarbeit der Einrichtung und Wartung eines eigenen Git Servers.

If you have no interest in running your own server, you can skip to the last section of the chapter to see some options for setting up a hosted account and then move on to the next chapter, where we discuss the various ins and outs of working in a distributed source control environment.

Wenn du kein Interesse am Betreiben eines eigenen Servers hast, kannst du zum letzten Absatz des Kapitels springen, um ein paar Möglichkeiten zum Einrichten eines gehosteten Accounts zu sehen. Im nächsten Kapitel diskutieren wir verschiedene Vorteile und Nachteile vom Arbeiten in einer verteilten Quellcode-Kontroll-Umgebung.

A remote repository is generally a _bare repository_ — a Git repository that has no working directory. Because the repository is only used as a collaboration point, there is no reason to have a snapshot checked out on disk; it’s just the Git data. In the simplest terms, a bare repository is the contents of your project’s `.git` directory and nothing else.

Ein externes Repository ist im Allgemeinen ein _einfaches Repository_ - ein Git Repository ohne Arbeitsverzeichnis. Weil das Repository nur als Zusammenarbeitspunkt genutzt wird, gibt es keinen Grund, einen Schnappschuss ausgecheckt auf der Festplatte zu haben; es sind nur die Git Daten. Mit einfachen Begriffen, ein einfaches Repository ist der Inhalt von deinem `.git` Verzeichnis in deinem Projekt und nichts anderes.

## The Protocols ##
## Die Protokolle ##

Git can use four major network protocols to transfer data: Local, Secure Shell (SSH), Git, and HTTP. Here we’ll discuss what they are and in what basic circumstances you would want (or not want) to use them.

Git kann vier wichtige Netzwerk Protokolle zum Datentransfer benutzen: Lokal, Secure Shell (SSH), Git und HTTP. Hier wollen wir diskutieren, was diese Protokolle sind und unter welchen grundlegenden Gegebenheiten du sie benutzen möchtest (oder auch nicht).

It’s important to note that with the exception of the HTTP protocols, all of these require Git to be installed and working on the server.

Es ist wichtig zu beachten, dass alle Protokolle mit Ausnahme von HTTP eine funktionierende Git Installation auf dem Server benötigen.

### Local Protocol ###
### Lokales Protokoll ###

The most basic is the _Local protocol_, in which the remote repository is in another directory on disk. This is often used if everyone on your team has access to a shared filesystem such as an NFS mount, or in the less likely case that everyone logs in to the same computer. The latter wouldn’t be ideal, because all your code repository instances would reside on the same computer, making a catastrophic loss much more likely.

Am einfachsten ist das _Lokale Protokoll_, wobei das externe Repository in einem anderen Verzeichnis auf der Festplatte ist. Das wird oft genutzt, wenn jeder aus deinem Team Zugriff zu einem gemeinsamen Dateisystem hat, zum Beispiel ein eingebundenes NFS, oder im unwahrscheinlicheren Fall jeder loggt sich auf bei dem gleichen Computer ein. Das letztere ist nicht ideal, weil alle Code Repository Instanzen auf dem selben Computer wären, ein katastrophaler Verlust wäre wahrscheinlicher.

If you have a shared mounted filesystem, then you can clone, push to, and pull from a local file-based repository. To clone a repository like this or to add one as a remote to an existing project, use the path to the repository as the URL. For example, to clone a local repository, you can run something like this:

Wenn du ein gemeinsames Dateisystem eingebunden hast, kannst du von einem lokalen Datei-basiertem Repository clonen, pushen und pullen. Um ein Repository wie dieses zu clonen, oder ein externes zu einem bestehenden Projekt hinzuzufügen, benutze den Pfad zu dem Repository als URL. Um zum Beispiel ein lokales Repository zu clonen kannst du einen Befehl wie diesen nutzen:

	$ git clone /opt/git/project.git

Or you can do this:

Oder du kannst das machen:

	$ git clone file:///opt/git/project.git

Git operates slightly differently if you explicitly specify `file://` at the beginning of the URL. If you just specify the path, Git tries to use hardlinks or directly copy the files it needs. If you specify `file://`, Git fires up the processes that it normally uses to transfer data over a network which is generally a lot less efficient method of transferring the data. The main reason to specify the `file://` prefix is if you want a clean copy of the repository with extraneous references or objects left out — generally after an import from another version-control system or something similar (see Chapter 9 for maintenance tasks). We’ll use the normal path here because doing so is almost always faster.

Git arbeitet etwas anders, wenn du am Anfang der URL ausdrücklich `file://` angibst. Wenn du nur den Pfad angibst, versucht Git harte Links zu benutzen oder Git kopiert direkt die benötigten Dateien. Wenn du `file://` angibst, startet Git den Prozess, den es normalerweise zum Übertragen von Daten über ein Netzwerk verwendet, dass ist gewöhnlich eine wesentlich ineffizientere Methode zum Übertragen der Daten. Der Hauptgrund das `file://`-Präfix anzugeben ist eine saubere Kopie von dem Repository mit fremden Referenzen oder fehlenden Objekten - generell nach einem Import von einem anderen Versionskontrollsystem oder etwas ähnliches (siehe Kapitel 9 für Wartungsarbeiten). Wir benutzen hier den normalen Pfad, weil das fast immer schneller ist.

To add a local repository to an existing Git project, you can run something like this:

Um ein lokales Repository zu einem existierenden Git Projekt hinzuzufügen, kannst du einen Befehl wie diesen ausführen:

	$ git remote add local_proj /opt/git/project.git

Then, you can push to and pull from that remote as though you were doing so over a network.

Dann kannst du von einem externen Repository pushen und pullen, obwohl du das über ein Netzwerk machst.

#### The Pros ####
#### Die Vorteile ####

The pros of file-based repositories are that they’re simple and they use existing file permissions and network access. If you already have a shared filesystem to which your whole team has access, setting up a repository is very easy. You stick the bare repository copy somewhere everyone has shared access to and set the read/write permissions as you would for any other shared directory. We’ll discuss how to export a bare repository copy for this purpose in the next section, “Getting Git on a Server.”

Die Vorteile von Datei-basierten Repositories sind die Einfachheit und sie nutzen bestehende Datei-Berechtigungen und den bestehenden Netzwerk-Zugriff. Wenn du bereits ein gemeinsames Dateisystem hast, zu dem das gesamte Team Zugriff hat, ist das Einrichten eines Repositories sehr einfach. Du extrahierst die Kopie des einfachen Repositories dahin, wo jeder gemeinsamen Zugriff hat und stellst die Lese- und Schreibberechtigungen wie bei jedem anderem gemeinsamen Verzeichnis ein. Wir werden im nächsten Abschnitt “Git auf einen Server bekommen.” diskutieren, wie man die Kopie eines einfachen Repositories für diesen Zweck exportiert.

This is also a nice option for quickly grabbing work from someone else’s working repository. If you and a co-worker are working on the same project and they want you to check something out, running a command like `git pull /home/john/project` is often easier than them pushing to a remote server and you pulling down.

Dies ist auch eine nette Möglichkeit zum Schnellen besorgen von Arbeit aus dem Arbeitsverzeichnis von jemand anderem. Wenn du und ein Kollege an dem gleichen Projekt arbeitet und ihr wollt etwas auschecken, ein Befehl wie `git pull /home/john/project` ist oft einfacher als das pushen zu einem externen Server und das pullen zurück.

#### The Cons ####
#### Die Nachteile ####

The cons of this method are that shared access is generally more difficult to set up and reach from multiple locations than basic network access. If you want to push from your laptop when you’re at home, you have to mount the remote disk, which can be difficult and slow compared to network-based access.

Die Nachteile von dieser Methode sind, dass gemeinsamer Zugriff im Allgemeinen schwieriger einrichten ist und der Zugriff von mehreren Orten ist schwieriger als einfacher Netzwerk Zugriff. Wenn du von deinem Laptop zuhause pushen möchtest, musst du eine entfernte Festplatte einbinden. Das kann schwierig und langsam sein, verglichen mit Netzwerk-basiertem Zugriff.

It’s also important to mention that this isn’t necessarily the fastest option if you’re using a shared mount of some kind. A local repository is fast only if you have fast access to the data. A repository on NFS is often slower than the repository over SSH on the same server, allowing Git to run off local disks on each system.

Es ist auch wichtig zu erwähnen, dass dies nicht unbedingt die schnellste Möglichkeit ist, wenn du ein gemeinsames Dateisystem oder ähnliches hast. Ein lokales Repository ist nur dann schnell, wenn du schnellen Zugriff auf die Daten hast. Ein NFS-basiertes Repository ist oftmals langsamer als ein Repository über SSH auf dem gleichen Server, weil Git über SSH auf jedem System auf den lokalen Festplatten arbeitet.

### The SSH Protocol ###
### Das SSH Protokoll ###

Probably the most common transport protocol for Git is SSH. This is because SSH access to servers is already set up in most places — and if it isn’t, it’s easy to do. SSH is also the only network-based protocol that you can easily read from and write to. The other two network protocols (HTTP and Git) are generally read-only, so even if you have them available for the unwashed masses, you still need SSH for your own write commands. SSH is also an authenticated network protocol; and because it’s ubiquitous, it’s generally easy to set up and use.

Das vermutlich gebräuchlichste Transport-Protokoll für Git ist SSH. Das hat den Grund, weil der SSH-Zugriff an den meisten Orten bereits eingerichtet ist - und wenn das nicht der Fall ist, ist es einfach zu machen. SSH ist außerdem das einzige Netzwerk-basierte Protokoll von dem man einfach lesen und darauf schreiben kann. Die beiden anderen Netzwerk-Protokolle (HTTP und Git) sind nur lesbar. Auch wenn sie für die breite Masse sind, brauchst du trotzdem SSH für deine Schreib-Befehle. SSH ist auch ein authentifiziertes Netzwerk-Protokoll, und weil es universell ist, ist es im Allgemeinen einfach einzurichten und zu benutzen. 

To clone a Git repository over SSH, you can specify ssh:// URL like this:

Um ein Git Repository über SSH zu clonen, kannst du eine ssh:// URL angeben:

	$ git clone ssh://user@server:project.git

Or you can not specify a protocol — Git assumes SSH if you aren’t explicit:

Oder du kannst auch kein Protokoll angeben - Git nimmt SSH an, wenn du nicht eindeutig bist:
	
	$ git clone user@server:project.git

You can also not specify a user, and Git assumes the user you’re currently logged in as.

Du kannst auch keinen Benutzer angeben, und Git nimmt den Benutzer an, als der du gerade eingeloggt bist.

#### The Pros ####

#### Die Vorteile ####

The pros of using SSH are many. First, you basically have to use it if you want authenticated write access to your repository over a network. Second, SSH is relatively easy to set up — SSH daemons are commonplace, many network admins have experience with them, and many OS distributions are set up with them or have tools to manage them. Next, access over SSH is secure — all data transfer is encrypted and authenticated. Last, like the Git and Local protocols, SSH is efficient, making the data as compact as possible before transferring it.

Die Vorteile von SSH sind vielseitig. Erstens, grundlegend musst du es benutzen, wenn du authentifizierten Schreib-Zugriff auf dein Repository über ein Netzwerk haben möchtest. Zweitens, SSH ist relativ einfach einzurichten - SSH-Dämonen sind alltäglich, viele Netzwerk-Administratoren haben Erfahrungen mit ihnen und viele Betriebssysteme sind mit ihnen eingerichtet oder haben Tools um sie zu verwalten. Als nächstes, Zugriff über SSH ist sicher - der gesamte Daten-Transfer ist verschlüsselt und authentifiziert. Als letztes, wie Git und die Lokalen Protokolle, SSH ist effizient, es macht die Daten so kompakt wie möglich bevor es die Daten überträgt.

#### The Cons ####

#### Die Nachteile ####

The negative aspect of SSH is that you can’t serve anonymous access of your repository over it. People must have access to your machine over SSH to access it, even in a read-only capacity, which doesn’t make SSH access conducive to open source projects. If you’re using it only within your corporate network, SSH may be the only protocol you need to deal with. If you want to allow anonymous read-only access to your projects, you’ll have to set up SSH for you to push over but something else for others to pull over.

Die negative Seite von SSH ist, dass du deine Repositories nicht anonym darüber anbieten kannst. Die Leute müssen Zugriff auf deine Maschine über SSH haben um zuzugreifen, auch mit einem Nur-Lese-Zugriff, was SSH nicht zuträglich zu Open-Source-Projekten macht. Wenn du es nur innerhalb von deinem Firmen-Netzwerk benutzt, SSH ist vielleicht das einzige Protokoll mit dem du arbeiten musst. Wenn du anonymen Nur-Lese-Zugriff zu deinen Projekten erlauben willst, musst du SSH für dich einsetzen um zu pushen, aber ein anderes Protokoll für andere um zu pullen.

### The Git Protocol ###

### Das Git Protokoll ###

Next is the Git protocol. This is a special daemon that comes packaged with Git; it listens on a dedicated port (9418) that provides a service similar to the SSH protocol, but with absolutely no authentication. In order for a repository to be served over the Git protocol, you must create the `git-export-daemon-ok` file — the daemon won’t serve a repository without that file in it — but other than that there is no security. Either the Git repository is available for everyone to clone or it isn’t. This means that there is generally no pushing over this protocol. You can enable push access; but given the lack of authentication, if you turn on push access, anyone on the internet who finds your project’s URL could push to your project. Suffice it to say that this is rare.

Als nächstes kommt das Git Protokoll. Das ist ein spezieller Dämon, der zusammen mit Git kommt. Er horcht auf einem bestimmten Port (9418), dieser Service ist vergleichbar mit dem SSH-Protokoll, aber ohne jegliche Authentifizierung. Um ein Repository über das Git Protokoll, musst du die `gitk-export-daemon-ok` Datei erstellen - der Dämon bietet kein Repository ohne die Datei darin an - außer dieser Datei gibt es keine Sicherheit. Entweder das Git Repository ist für jeden zum Clonen verfügbar oder halt nicht. Das bedeutet, dass dieses Protokoll generell kein push anbietet. Du kannst push-Zugriff aktivieren; aber ohne Authentifizierung, wenn du den push-Zugriff aktivierst, kann jeder im Internet, der deine Projekt-URL findet, zu deinem Projekt pushen. Ausreichend zu sagen, dass das selten ist.

#### The Pros ####

#### Die Vorteile ####

The Git protocol is the fastest transfer protocol available. If you’re serving a lot of traffic for a public project or serving a very large project that doesn’t require user authentication for read access, it’s likely that you’ll want to set up a Git daemon to serve your project. It uses the same data-transfer mechanism as the SSH protocol but without the encryption and authentication overhead.

Das Git Protokoll ist das schnellste verfügbare Transfer Protokoll. Wenn du viel Traffic für ein öffentliches Projekt hast oder ein sehr großes Projekt hast, dass keine Benutzer-Authentifizierung für den Lese-Zugriff voraussetzt, es ist üblich einen Git Dämon einzurichten, der dein Projekt serviert. Er benutzt den selben Daten-Transfer Mechanismus wie das SSH-Protokoll, aber ohne den Entschlüsselungs- und Authentifizierungs-Overhead.

#### The Cons ####

#### Die Nachteile ####

The downside of the Git protocol is the lack of authentication. It’s generally undesirable for the Git protocol to be the only access to your project. Generally, you’ll pair it with SSH access for the few developers who have push (write) access and have everyone else use `git://` for read-only access.
It’s also probably the most difficult protocol to set up. It must run its own daemon, which is custom — we’ll look at setting one up in the “Gitosis” section of this chapter — it requires `xinetd` configuration or the like, which isn’t always a walk in the park. It also requires firewall access to port 9418, which isn’t a standard port that corporate firewalls always allow. Behind big corporate firewalls, this obscure port is commonly blocked.

Die Unterseite von dem Git Protokoll ist das fehlen der Authentifizierung. Es ist generell unerwünscht, dass das Git Protokoll der einzige Zugang zu dem Projekt ist. Im Allgemeinen willst du es mit SSH-Zugriff für die Entwickler paaren, die push (Schreib) Zugriff haben und jeder andere benutzt `git://` für Nur-Lese-Zugriff.
Es ist vielleicht auch das das schwierigste Protokoll beim Einrichten. Es muss ein eigener Dämon laufen, welcher Git-spezifisch ist - wir wollen im “Gitosis”-Abschnitt in diesem Kapitel schauen, wie man einen einrichtet - es setzt eine `xinetd`-Konfiguration oder ähnliches voraus, das ist nicht immer wie ein Spaziergang im Park. Es setzt auch einen Firewall-Zugriff auf den Port 9418 voraus, das ist kein Standard-Port, den Firmen-Firewalls immer erlauben. Hinter einer großen Firmen-Firewall ist dieser unklare Port häufig gesperrt.

### The HTTP/S Protocol ###

### Das HTTP/S Protokoll ###

Last we have the HTTP protocol. The beauty of the HTTP or HTTPS protocol is the simplicity of setting it up. Basically, all you have to do is put the bare Git repository under your HTTP document root and set up a specific `post-update` hook, and you’re done (See Chapter 7 for details on Git hooks). At that point, anyone who can access the web server under which you put the repository can also clone your repository. To allow read access to your repository over HTTP, do something like this:

Als letztes haben wir das HTTP Protokoll. Das Schöne am HTTP bzw. HTTPS Protokoll ist die Einfachheit des Einrichtens. Im Grunde musst du nur das einfach Git Repository in dein HTTP Hauptverzeichnis legen und einen speziellen `post-update` hook (xxx) einrichten und schon bist du fertig (siehe Kapitel 7 für Details zu Git hooks (xxx)). Jetzt kann jeder, der auf den Web-Server mit dem Repository zugreifen kann, das Repository clonen. Um Lese-Zugriff auf das Repository über HTTP zu erlauben, führe die folgenden Befehle aus:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

That’s all. The `post-update` hook that comes with Git by default runs the appropriate command (`git update-server-info`) to make HTTP fetching and cloning work properly. This command is run when you push to this repository over SSH; then, other people can clone via something like

Das ist alles. Der `post-update` hook (xxx) der Standardmäßig zusammen mit Git kommt führt den richtigen Befehl aus (`git update-server-info`), damit der HTTP-Server das Repository richtig abruft und klont. Dieser Befehl läuft, wenn du zu diesem Repository per SSH pusht, andere Leute können dann clonen mit dem Befehl

	$ git clone http://example.com/gitproject.git

In this particular case, we’re using the `/var/www/htdocs` path that is common for Apache setups, but you can use any static web server — just put the bare repository in its path. The Git data is served as basic static files (see Chapter 9 for details about exactly how it’s served).

In diesem besonderen Fall benutzen dir den `/var/www/htdocs`-Pfad, der typisch für Apache-Setups ist, aber du kannst jeden statischen Web-Server benutzen - nur das einfache Repository in den richtigen Ordner legen. Die Git-Daten werden als einfache statische Dateien serviert (siehe Kapitel 9 für Details, wie es genau serviert wird).

It’s possible to make Git push over HTTP as well, although that technique isn’t as widely used and requires you to set up complex WebDAV requirements. Because it’s rarely used, we won’t cover it in this book. If you’re interested in using the HTTP-push protocols, you can read about preparing a repository for this purpose at `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. One nice thing about making Git push over HTTP is that you can use any WebDAV server, without specific Git features; so, you can use this functionality if your web-hosting provider supports WebDAV for writing updates to your web site.

Es ist möglich, Git-Daten auch über HTTP zu pushen, trotzdem wird diese Technik nicht oft eingesetzt und es setzt komplexe WebDAV-Anforderungen voraus. Weil es selten genutzt wird, werden wir das nicht in diesem Buch behandeln. Wenn du Interesse am HTTP-Push-Protokoll hast, kannst du das Einrichten unter `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` nachlesen. Eine Schöne Sache über Git-Push über HTTP ist, dass du jeden WebDAV-Server benutzen kannst, ohne spezifische Git-Features; also kannst du diese Funktionalität nutzen, wenn dein Web-Hosting-Provider WebDAV unterstützt, um Änderungen auf deine Webseite zu schreiben.

#### The Pros ####

#### Die Vorteile ####

The upside of using the HTTP protocol is that it’s easy to set up. Running the handful of required commands gives you a simple way to give the world read access to your Git repository. It takes only a few minutes to do. The HTTP protocol also isn’t very resource intensive on your server. Because it generally uses a static HTTP server to serve all the data, a normal Apache server can serve thousands of files per second on average — it’s difficult to overload even a small server.

Die Oberseite beim Benutzen des HTTP-Protokolls ist, dass es einfach einzurichten ist. Das Ausführen von einer Handvoll notwendiger Befehle ist ein einfacher Weg, um der Welt Lese-Zugriff auf dein Git-Repository zu geben. Es braucht nur ein paar Minuten. Das HTTP Protokoll braucht auch nicht viele Ressourcen auf deinem Server. Es braucht generell nur einen statischen Server braucht um die Daten zu servieren. Ein normaler Apache-Server kann Tausende von Dateien pro Sekunde servieren - es ist schwierig selbst einen kleinen Server zu überlasten.

You can also serve your repositories read-only over HTTPS, which means you can encrypt the content transfer; or you can go so far as to make the clients use specific signed SSL certificates. Generally, if you’re going to these lengths, it’s easier to use SSH public keys; but it may be a better solution in your specific case to use signed SSL certificates or other HTTP-based authentication methods for read-only access over HTTPS.

Du kannst deine Repositories auch als Nur-Lese-Repositories über HTTPS servieren, du kannst also den Daten-Transfer verschlüsseln. Oder du kannst so weit gehen, dass die Clients spezifische signierte SSL-Zertifikate benutzen. Im Allgemeinen, wenn du soweit gehst, ist es einfacher, öffentliche SSH-Schlüssel zu benutzen; aber es ist vielleicht für deinen Fall eine bessere Lösung, signierte SSL-Zertifikate zu benutzen oder andere HTTP-basierte Authentifizierungs-Methoden für Nur-Lese-Zugriff über HTTPS zu benutzen.

Another nice thing is that HTTP is such a commonly used protocol that corporate firewalls are often set up to allow traffic through this port.

Eine andere schöne Sache ist, dass HTTP so oft genutzt wird, dass Firmen-Firewalls oft Traffic über den HTTP-Port erlauben.

#### The Cons ####

#### Die Nachteile ####

The downside of serving your repository over HTTP is that it’s relatively inefficient for the client. It generally takes a lot longer to clone or fetch from the repository, and you often have a lot more network overhead and transfer volume over HTTP than with any of the other network protocols. Because it’s not as intelligent about transferring only the data you need — there is no dynamic work on the part of the server in these transactions — the HTTP protocol is often referred to as a _dumb_ protocol. For more information about the differences in efficiency between the HTTP protocol and the other protocols, see Chapter 9.

Die Unterseite vom Servieren von deinem Repository über HTTP ist, dass es recht ineffizient für den Client ist. Es braucht im Allgemeinen länger zu clonen oder Daten vom Repository zu holen und du hast oft wesentlich mehr Netzwerk-Overhead und Transfer-Volumen als mit jedem anderen Netzwerk Protokoll. Weil es nicht so intelligent beim Daten-Transfer ist, um nur die benötigten Daten zu übertragen - es gibt keine dynamische Arbeit auf dem Server bei diesen Aktionen - das HTTP Protokoll wird oft als _dummes_ Protokoll bezeichnet. Für mehr Informationen über die Unterschiede bei der Effizienz zwischen dem HTTP Protokoll und den anderen Protokollen: siehe Kapitel 9.

## Getting Git on a Server ##

## Git auf einen Server bekommen ##

In order to initially set up any Git server, you have to export an existing repository into a new bare repository — a repository that doesn’t contain a working directory. This is generally straightforward to do.
In order to clone your repository to create a new bare repository, you run the clone command with the `--bare` option. By convention, bare repository directories end in `.git`, like so:

Um zunächst einen beliebigen Git Server einzurichten, musst du ein existierendes Repository in ein neues einfaches Repository exportieren - ein Repository, dass kein Arbeitsverzeichnis enthält. Das ist im Allgemeinen einfach zu erledigen.
Um zunächst dein Repository zu klonen, um ein neues einfaches Repository anzulegen, führst du den Klonen-Befehl mit der `--bare` Option aus. Per Konvention haben einfache Repository Verzeichnisse die Endung `.git`, wie hier:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

The output for this command is a little confusing. Since `clone` is basically a `git init` then a `git fetch`, we see some output from the `git init` part, which creates an empty directory. The actual object transfer gives no output, but it does happen. You should now have a copy of the Git directory data in your `my_project.git` directory.

Die Ausgabe für diesen Befehl ist etwas verwirrend. Weil `clone` im Grunde ein `git init` und ein `git fetch` ist, sehen wir eine Ausgabe vom `git init`-Teil, der ein leeres Verzeichnis anlegt. Die eigentliche Objekt-Übertragung erzeugt keine Ausgabe, aber sie findet statt. Du solltest jetzt eine Kopie von den Git-Verzeichnis Daten in deinem `my_project.git` Verzeichnis haben.

This is roughly equivalent to something like

Dies ist entsprechend zu etwas wie

	$ cp -Rf my_project/.git my_project.git

There are a couple of minor differences in the configuration file; but for your purpose, this is close to the same thing. It takes the Git repository by itself, without a working directory, and creates a directory specifically for it alone.

Es gibt ein paar kleine Unterschiede in der Konfigurationsdatei, aber für deine Zwecke ist es nahezu dasselbe. Es nimmt das Git-Repository von selbst, ohne einem Arbeitsverzeichnis, und erzeugt ein Verzeichnis speziell für sich allein.

### Putting the Bare Repository on a Server ###

### Inbetriebnahme des einfachen Repository auf einem Server ###

Now that you have a bare copy of your repository, all you need to do is put it on a server and set up your protocols. Let’s say you’ve set up a server called `git.example.com` that you have SSH access to, and you want to store all your Git repositories under the `/opt/git` directory. You can set up your new repository by copying your bare repository over:

Da du jetzt eine einfache Kopie deines Repository hast, ist alles was du tun musst das Aufsetzen auf einem Server und das Einrichten deiner Protokolle. Angenommen, du hast einen Server mit dem Namen `git.example.com`, zu dem du SSH-Zugang hast, und du möchtest alle deine Git Repositories im Verzeichnis `/opt/git` speichern. Du kannst dein neues Repository einrichten, indem du dein einfaches Repository dorthin kopierst:

	$ scp -r my_project.git user@git.example.com:/opt/git

At this point, other users who have SSH access to the same server which has read-access to the `/opt/git` directory can clone your repository by running

An diesem Punkt können andere Benutzer, die SSH-Zugang zu dem gleichen Server und Lesezugriff auf das `/opt/git` Verzeichnis haben, dein Repository klonen:

	$ git clone user@git.example.com:/opt/git/my_project.git

If a user SSHs into a server and has write access to the `/opt/git/my_project.git` directory, they will also automatically have push access.  Git will automatically add group write permissions to a repository properly if you run the `git init` command with the `--shared` option.

Wenn sich ein Benutzer per SSH mit dem Server verbindet und Schreibzugriff zu dem Verzeichnis `/opt/git/my_project.git` hat, wird er automatisch auch Push-Zugriff haben. Git wird automatisch die richtigen Gruppenschreibrechte zu einem Repository hinzufügen, wenn du den `git init` Befehl mit der `--shared` Option ausführst:

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

You see how easy it is to take a Git repository, create a bare version, and place it on a server to which you and your collaborators have SSH access. Now you’re ready to collaborate on the same project.

Du siehst wie einfach es ist ein Git Repository zu nehmen, eine einfache Version zu erzeugen, es auf einen Server zu platzieren zu dem du und deine Mitarbeiter SSH-Zugriff haben.

It’s important to note that this is literally all you need to do to run a useful Git server to which several people have access — just add SSH-able accounts on a server, and stick a bare repository somewhere that all those users have read and write access to. You’re ready to go — nothing else needed.

Es ist wichtig zu beachten, dass dies wortwörtlich alles ist, was du tun musst, um einen nützlichen Git-Server laufen zu lassen, zu dem mehrere Personen Zugriff haben - füge auf dem Server einfach SSH-fähige Konten und irgendwo ein einfaches Repository hinzu, zu dem alle Benutzer Schreib- und Lesezugriff haben.

In the next few sections, you’ll see how to expand to more sophisticated setups. This discussion will include not having to create user accounts for each user, adding public read access to repositories, setting up web UIs, using the Gitosis tool, and more. However, keep in mind that to collaborate with a couple of people on a private project, all you _need_ is an SSH server and a bare repository.

In den nächsten Abschnitten wirst du sehen, wie man auf anspruchsvollere Konfigurationen erweitert. Diese Diskussion wird beinhalten nicht Benutzerkonten für jeden Benutzer hinzufügen zu müssen, öffentlichen Lese-Zugriff auf Repositories hinzuzufügen, die Einrichtung von Web-UIs, die Benutzung des Gitosis-Tools und weiteres. Aber denke daran, zur Zusammenarbeit mit ein paar Personen an einem privaten Projekt, ist alles was du _brauchst_ ein SSH-Server und ein einfaches Repository.

### Small Setups ###

### Kleine Konfigurationen ###

If you’re a small outfit or are just trying out Git in your organization and have only a few developers, things can be simple for you. One of the most complicated aspects of setting up a Git server is user management. If you want some repositories to be read-only to certain users and read/write to others, access and permissions can be a bit difficult to arrange.

Wenn du eine kleine Ausrüstung hast oder Git gerade in deinem Unternehmen ausprobierst und nur ein paar Entwickler hast, sind die Dinge einfach für dich. Einer der kompliziertesten Aspekte der Einrichtung eines Git-Servers ist die Benutzerverwaltung. Wenn einige Repositories für bestimmte Benutzer nur lesend zugänglich sein sollen und andere Benutzer Lese/Schreib-Zugriff haben sollen, können Zugriff und Berechtigungen ein bisschen schwierig zu organisieren sein.

#### SSH Access ####

#### SSH-Zugriff ####

If you already have a server to which all your developers have SSH access, it’s generally easiest to set up your first repository there, because you have to do almost no work (as we covered in the last section). If you want more complex access control type permissions on your repositories, you can handle them with the normal filesystem permissions of the operating system your server runs.

Wenn du bereits einen Server hast, zu dem alle Entwickler SSH-Zugriff haben, ist es generell einfach, dein erstes Repository einzurichten, weil du fast keine Arbeit zu erledigen hast (wie wir im letzen Abschnitt abgedeckt haben). Wenn du komplexere Zugriffskontroll-Berechtigungen auf deine Repositories willst, kannst du diese mit normalen Dateisystem-Berechtigungen des Betriebssystems deines Servers bewältigen.

If you want to place your repositories on a server that doesn’t have accounts for everyone on your team whom you want to have write access, then you must set up SSH access for them. We assume that if you have a server with which to do this, you already have an SSH server installed, and that’s how you’re accessing the server.

Wenn du deine Repositories auf einem Server platzieren möchtest, der keine Accounts für jeden aus deinem Team hat, der Schreibzugriff haben soll, dann musst du SSH-Zugriff für diese Personen einrichten. Wir nehmen an, wenn du einen Server hast, mit welchem du dies tun möchtest, du bereits einen SSH-Server installiert hast und so greifst du auf den Server zu.

There are a few ways you can give access to everyone on your team. The first is to set up accounts for everybody, which is straightforward but can be cumbersome. You may not want to run `adduser` and set temporary passwords for every user.

Es gibt ein paar Wege allen Mitgliedern deines Teams Zugriff zu geben. Der erste ist einen Account für jeden einzurichten, was unkompliziert aber mühsam sein kann. Du möchtest vielleicht nicht für jeden Benutzer `adduser` ausführen und ein temporäres Passwort setzen.

A second method is to create a single 'git' user on the machine, ask every user who is to have write access to send you an SSH public key, and add that key to the `~/.ssh/authorized_keys` file of your new 'git' user. At that point, everyone will be able to access that machine via the 'git' user. This doesn’t affect the commit data in any way — the SSH user you connect as doesn’t affect the commits you’ve recorded.

Eine zweite Methode ist, einen einzigen 'git'-Benutzer auf der Maschine zu erstellen und jeden Benutzer, der Schreibzugriff haben soll, nach einem öffentliche SSH-Schlüssel zu fragen und diesen Schlüssel zu der `~/.ssh/authorized_keys`-Datei deines neuen 'git' Benutzers hinzuzufügen. Das beeinflusst die Commit-Daten in keiner Weise - der SSH-Benutzer, mit dem du dich verbindest, beeinflusst die von dir aufgezeichneten Commits nicht.

Another way to do it is to have your SSH server authenticate from an LDAP server or some other centralized authentication source that you may already have set up. As long as each user can get shell access on the machine, any SSH authentication mechanism you can think of should work.

Ein anderer Weg ist, einen LDAP-Server zur Authentifizierung zu benutzen oder eine andere zentrale Authentifizierungsquelle, die du vielleicht bereits eingerichtet hast. Solange jeder Benutzer Shell-Zugriff zu der Maschine hat, sollte jede SSH-Authentifizierungsmethode funktionieren, die du dir vorstellen kannst.

## Generating Your SSH Public Key ##

## Generiere deinen öffentlichen SSH-Schlüssel ##

That being said, many Git servers authenticate using SSH public keys. In order to provide a public key, each user in your system must generate one if they don’t already have one. This process is similar across all operating systems.
First, you should check to make sure you don’t already have a key. By default, a user’s SSH keys are stored in that user’s `~/.ssh` directory. You can easily check to see if you have a key already by going to that directory and listing the contents:

Darüber hinaus benutzen viele Git-Server öffentliche SSH-Schlüssel zur Authentifizierung. Um einen öffentlichen Schlüssel bereitzustellen muss jeder Benutzer deines Systems einen solchen Schlüssel generieren, falls sie noch keinen haben. Dieser Prozess ist bei allen Betriebssystemen ähnlich.
Als erstes solltest du überprüfen, ob du nicht schon einen Schlüssel hast. Standardmäßig werden die SSH-Schlüssel der Benutzer in ihrem `~/.ssh`-Verzeichnis gespeichert. Du kannst einfach überprüfen, ob du einen Schlüssel hast, indem du in das Verzeichnis gehst und den Inhalt auflistest:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

You’re looking for a pair of files named something and something.pub, where the something is usually `id_dsa` or `id_rsa`. The `.pub` file is your public key, and the other file is your private key. If you don’t have these files (or you don’t even have a `.ssh` directory), you can create them by running a program called `ssh-keygen`, which is provided with the SSH package on Linux/Mac systems and comes with the MSysGit package on Windows:

Du suchst nach Paar Dateien namens `irgendetwas` und `irgendetwas.pub`, die Datei `irgendetwas` heißt normalerweise `id_dsa` oder `id_rsa`. Die `.pub`-Datei ist dein öffentlicher Schlüssel und die andere Datei ist dein privater Schlüssel. Wenn du diese Dateien nicht hast (oder gar kein `.ssh`-Verzeichnis hast), kannst du sie mit dem Ausführen des Programms `ssh-keygen` erzeugen. Das Programm wird mit dem SSH-Paket auf Linux/Mac-Systemen mitgeliefert und kommt mit dem MSysGit-Paket unter Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

First it confirms where you want to save the key (`.ssh/id_rsa`), and then it asks twice for a passphrase, which you can leave empty if you don’t want to type a password when you use the key.

Zunächst wird bestätigt, wo du den Schlüssel speichern möchtest (`.ssh/id_rsa`) und dann wird zweimal nach der Passphrase gefragt, die du leer lassen kannst, wenn du kein Passwort bei der Benutzung des Schlüssels eintippen möchtest.

Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). All they have to do is copy the contents of the `.pub` file and e-mail it. The public keys look something like this:

Jeder Benutzer der dies macht, muss seinen öffentlichen Schlüssel an sich senden oder wer auch immer den Git-Server administriert (angenommen du benutzt eine SSH-Server Konfiguration, die öffentliche Schlüssel benötigt). Alles was die Benutzer tun müssen ist, den Inhalt der `.pub`-Datei zu kopieren und an dich per E-Mail zu schicken. Der öffentliche Schlüssel sieht etwa wie folgt aus:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

For a more in-depth tutorial on creating an SSH key on multiple operating systems, see the GitHub guide on SSH keys at `http://github.com/guides/providing-your-ssh-key`.

Eine detailliertere Anleitung zur Erstellung eines SSH-Schlüssels unter den verschiedenen Betriebssystemen ist der GitHub-Leitfaden für SSH-Schlüssel unter `http://github.com/guides/providing-your-ssh-key`.

## Setting Up the Server ##

## Einrichten des Servers ##

Let’s walk through setting up SSH access on the server side. In this example, you’ll use the `authorized_keys` method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a `.ssh` directory for that user.

Nun kommen wir zur Einrichtung des SSH-Zugangs auf der Server-Seite. In diesem Beispiel verwendest du die `authorized_keys`-Methode zur Authentifizierung der Benutzer. Wir nehmen auch an, dass du eine gebräuchliche Linux-Distribution wie Ubuntu verwendest. Zuerst erstellst du den Benutzer 'git' und ein `.ssh`-Verzeichnis für diesen Benutzer.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Next, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:

Als nächstes ist es nötig, einige öffentliche SSH-Schlüssel der Entwickler zu der `authorized_keys`-Datei des Benutzers hinzuzufügen. Nehmen wir an, dass du ein paar Schlüssel per E-Mail empfangen hast und diese in temporären Dateien gespeichert hast. Die öffentlichen Schlüssel sehen wieder etwa wie folgt aus:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

You just append them to your `authorized_keys` file:

Du hängst sie einfach an deine `authorized_keys`-Datei an:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Now, you can set up an empty repository for them by running `git init` with the `--bare` option, which initializes the repository without a working directory:

Jetzt kannst du einen leeren Ordner für sie anlegen, indem du den Befehl `git init` mit der Option `--bare` ausführst. Damit wird ein Repository ohne ein Arbeitsverzeichnis erzeugt.

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:

Dann können John, Josie oder Jessica die erste Version ihres Projektes in das Repository hochladen, indem sie es als externes Repository hinzufügen und einen Branch hochladen. Beachte, dass sich bei jeder Projekterstellung jemand mit der Maschine auf eine Shell verbinden muss, um ein einfaches Repository zu erzeugen. Lass uns `gitserver` als Hostnamen des Servers verwenden, auf dem du den Benutzer 'git' und das Repository eingerichtet hast. Wenn du den Server intern betreibst und das DNS so eingerichtet hast, dass `gitserver` auf den Server zeigt, dann kannst du die Befehle ziemlich wie hier benutzen:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

At this point, the others can clone it down and push changes back up just as easily:

An diesem Punkt können die anderen das Repository klonen und Änderungen ebenso leicht hochladen:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

With this method, you can quickly get a read/write Git server up and running for a handful of developers.

Mit dieser Methode kannst du schnell für eine Handvoll Entwickler einen Lese/Schreib Git-Server zum Laufen bekommen.

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:

Als zusätzliche Vorsichtsmaßnahme kannst du den Benutzer 'git' so beschränken, dass er nur Git-Aktivitäten mit einem limitierten Shell-Tool namens `git-shell` ausführen kann, dass mit Git kommt. Wenn du das als Login-Shell des 'git'-Benutzers einrichtest, dann hat der Benutzer 'git' keinen normalen Shell-Zugriff auf den Server. Zur Benutzung bestimme `git-shell` anstatt von bash oder csh als Login-Shell deines Benutzers. Um das zu tun wirst du wahrscheinlich deine `/etc/passwd` editieren:

	$ sudo vim /etc/passwd

At the bottom, you should find a line that looks something like this:

Am Ende solltest du eine Zeile finden, die in etwa so aussieht:

	git:x:1000:1000::/home/git:/bin/sh

Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). The line should look something like this:

Ändere `/bin/sh` zu `/usr/bin/git-shell` (oder führe `which git-shell` aus, um zu sehen, wo es installiert ist). Die Zeile sollte in etwa so aussehen:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

Jetzt kann der 'git'-Benutzer die SSH-Verbindung nur noch verwenden, um Git-Repositories hochzuladen und herunterzuladen. Der Benutzer kann sich nicht mehr per Shell zur Maschine verbinden. Wenn du es versuchst, siehst du eine Login-Ablehnung wie diese:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Public Access ##

## Öffentlicher Zugang ##

What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Was ist, wenn du anonymen Lese-Zugriff zu deinem Projekt möchtest? Vielleicht möchtest du ein Open-Source-Projekt anstatt einem internen, privaten Projekt hosten. Oder du hast ein paar automatisierte Build-Server oder einen kontinuierlichen Integrationsserver, der sich oft verändert (xxx), und du möchtest nicht die ganze Zeit SSH-Schlüssel generieren - du willst nur einen einfachen anonymen Lese-Zugriff hinzufügen.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

Der wahrscheinlich einfachste Weg für kleinere Konfigurationen ist, einen statischen Web-Server laufen zu lassen, mit dem gleichen Dokumenten-Basisverzeichnis wie deinen Git-Repositories. Dann aktivierst du den `post-update` hook (xxx), den wir im ersten Abschnitt dieses Kapitels erwähnt haben. Gehen wir vom vorherigen Beispiel aus. Sagen wir, du hast deine Repositories im Verzeichnis `/opt/git` und ein Apache-Server läuft auf deiner Maschine. Du kannst einen beliebigen Web-Server dafür benutzen. Aber als Beispiel zeigen wir einige grundlegende Apache-Konfigurationen, die dir eine Vorstellung geben sollten, was du vielleicht brauchst.

First you need to enable the hook:

Zuerst musst den den hook (xxx) aktivieren:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently. 

Wenn du eine Git-Version früher als 1.6 benutzt ist der `mv`-Befehl nicht notwendig - Git begann die Benennung der hooks (xxx) mit der .sample postfix (xxx) erst vor kurzem.

What does this `post-update` hook do? It looks basically like this:

Was macht dieser `post-update` hook (xxx)? Es sieht im Grunde so aus:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.

Wenn du etwas auf den Server hochlädst, wird Git diesen Befehl ausführen, um die nötigen Dateien für das HTTP fetching (xxx) zu aktualisieren.

Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

Als nächstes musst du einen VirtualHost-Eintrag zu deiner Apache-Konfiguration hinzufügen. Das Basisverzeichnis des Web-Servers muss mit dem Basisverzeichnis deiner Git-Projekte übereinstimmen. Hier nehmen wir an, dass du einen Wildcard-DNS eingerichtet hast, um `*.gitserver` zu dem Server zu senden, den du verwendest, um all dies laufen zu lassen:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:

Du musst auch die Unix-Benutzergruppe des Verzeichnisses `/opt/git` auf `www-data` setzen, sodass dein Web-Server die Repositories lesen kann, weil die Apache-Instanz, die das CGI-Skript ausführt, als dieser Benutzer läuft.

	$ chgrp -R www-data /opt/git

When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:

Wenn du Apache neu startest solltest du in der Lage sein, deine Repositories in dem Verzeichnis zu klonen, indem du die URL für dein Projekt angibst.

	$ git clone http://git.gitserver/project.git

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

So kannst du HTTP-basierte Lese-Zugänge zu allen deinen Projekte für eine angemessene Anzahl von Benutzern in ein paar Minuten einrichten. Eine andere einfache Möglichkeit für öffentlichen nicht-authentifizierten Zugriff ist, einen Git-Dämonen zu starten. Das erfordert jedoch, dass du den Prozess dämonisierst - wir behandeln diese Option im nächsten Abschnitt, wenn du diesen Weg bevorzugst.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. The GitWeb web-based user interface.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

	$ git instaweb --httpd=webrick --stop

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

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

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

	$ apt-get install python-setuptools

Next, you clone and install Gitosis from the project’s main site:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

	$ ln -s /opt/git /home/git/repositories

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

	git:x:1000:1000::/home/git:/usr/bin/git-shell

back to this:

	git:x:1000:1000::/home/git:/bin/sh

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Now you have a directory named `gitosis-admin`, which has two major parts:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

	[group mobile]
	writable = iphone_project
	members = scott

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

After you commit and push that change, all four users will be able to read from and write to that project.

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

## Gitolite ##

Note: the latest copy of this section of the ProGit book is always available within the [gitolite documentation][gldpg].  The author would also like to humbly state that, while this section is accurate, and *can* (and often *has*) been used to install gitolite without reading any other documentation, it is of necessity not complete, and cannot completely replace the enormous amount of documentation that gitolite comes with.

[gldpg]: http://github.com/sitaramc/gitolite/blob/pu/doc/progit-article.mkd

Git has started to become very popular in corporate environments, which tend to have some additional requirements in terms of access control.  Gitolite was originally created to help with those requirements, but it turns out that it's equally useful in the open source world: the Fedora Project controls access to their package management repositories (over 10,000 of them!) using gitolite, and this is probably the largest gitolite installation anywhere too.

Gitolite allows you to specify permissions not just by repository, but also by branch or tag names within each repository.  That is, you can specify that certain people (or groups of people) can only push certain "refs" (branches or tags) but not others.

### Installing ###

Installing Gitolite is very easy, even if you don't read the extensive documentation that comes with it.  You need an account on a Unix server of some kind (various Linux flavours, and Solaris 10, have been tested), with git, perl, and an openssh compatible ssh server installed.  In the examples below, we will use the `gitolite` account on a host called `gitserver`.

Gitolite is somewhat unusual as far as "server" software goes -- access is via ssh, and so every userid on the server is a potential "gitolite host".  As a result, there is a notion of "installing" the software itself, and then "setting up" a user as a "gitolite host".

Gitolite has 4 methods of installation.  People using Fedora or Debian systems can obtain an RPM or a DEB and install that.  People with root access can install it manually.  In these two methods, any user on the system can then become a "gitolite host".

People without root access can install it within their own userids.  And finally, gitolite can be installed by running a script *on the workstation*, from a bash shell.  (Even the bash that comes with msysgit will do, in case you're wondering.)

We will describe this last method in this article; for the other methods please see the documentation.

You start by obtaining public key based access to your server, so that you can log in from your workstation to the server without getting a password prompt.  The following method works on Linux; for other workstation OSs you may have to do this manually.  We assume you already had a key pair generated using `ssh-keygen`.

	$ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

This will ask you for the password to the gitolite account, and then set up public key access.  This is **essential** for the install script, so check to make sure you can run a command without getting a password prompt:

	$ ssh gitolite@gitserver pwd
	/home/gitolite

Next, you clone Gitolite from the project's main site and run the "easy install" script (the third argument is your name as you would like it to appear in the resulting gitolite-admin repository):

	$ git clone git://github.com/sitaramc/gitolite
	$ cd gitolite/src
	$ ./gl-easy-install -q gitolite gitserver sitaram

And you're done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in the home directory of your workstation.  You administer your gitolite setup by making changes to this repository and pushing.

That last command does produce a fair amount of output, which might be interesting to read.  Also, the first time you run this, a new keypair is created; you will have to choose a passphrase or hit enter for none.  Why a second keypair is needed, and how it is used, is explained in the "ssh troubleshooting" document that comes with Gitolite.  (Hey the documentation has to be good for *something*!)

Repos named `gitolite-admin` and `testing` are created on the server by default. If you wish to clone either of these locally (from an account that has SSH console access to the gitolite account via *authorized_keys*), type:

  $ git clone gitolite:gitolite-admin
  $ git clone gitolite:testing

To clone these same repos from any other account:

  $ git clone gitolite@servername:gitolite-admin
  $ git clone gitolite@servername:testing


### Customising the Install ###

While the default, quick, install works for most people, there are some ways to customise the install if you need to.  Firstly, there are two other branches that you may be interested in installing, instead of "master".  The "wildrepos" branch allows you to specify repositories by wildcards (regular expressions) in the configuration file; an extremely powerful feature that we will not be covering in this article.  And if your server side git is older than 1.5.6 or so, you should use the "oldgits" branch.

Finally, if you omit the `-q` argument, you get a "verbose" mode install -- detailed information on what the install is doing at each step.  The verbose mode also allows you to change certain server-side parameters, such as the location of the actual repositories, by editing an "rc" file that the server uses.  This "rc" file is liberally commented so you should be able to make any changes you need quite easily, save it, and continue.

### Config File and Access Control Rules ###

Once the install is done, you switch to the `gitolite-admin` repository (placed in your HOME directory) and poke around to see what you got:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/sitaram.pub
	$ cat conf/gitolite.conf
	#gitolite conf
	# please see conf/example.conf for details on syntax and features

	repo gitolite-admin
	    RW+                 = sitaram

	repo testing
	    RW+                 = @all

Notice that "sitaram" (the last argument in the `gl-easy-install` command you gave earlier) has read-write permissions on the `gitolite-admin` repository as well as a public key file of the same name.

The config file syntax for gitolite is liberally documented in `conf/example.conf`, so we'll only mention some highlights here.

You can group users or repos for convenience.  The group names are just like macros; when defining them, it doesn't even matter whether they are projects or users; that distinction is only made when you *use* the "macro".

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott     # Adams, not Chacon, sorry :)
	@interns        = ashok     # get the spelling right, Scott!
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

You can control permissions at the "ref" level.  In the following example, interns can only push the "int" branch.  Engineers can push any branch whose name starts with "eng-", and tags that start with "rc" followed by a digit.  And the admins can do anything (including rewind) to any ref.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

The expression after the `RW` or `RW+` is a regular expression (regex) that the refname (ref) being pushed is matched against.  So we call it a "refex"!  Of course, a refex can be far more powerful than shown here, so don't overdo it if you're not comfortable with perl regexes.

Also, as you probably guessed, Gitolite prefixes `refs/heads/` as a syntactic convenience if the refex does not begin with `refs/`.

An important feature of the config file's syntax is that all the rules for a repository need not be in one place.  You can keep all the common stuff together, like the rules for all `oss_repos` shown above, then add specific rules for specific cases later on, like so:

	repo gitolite
	    RW+                     = sitaram

That rule will just get added to the ruleset for the `gitolite` repository.

At this point you might be wondering how the access control rules are actually applied, so let's go over that briefly.

There are two levels of access control in gitolite.  The first is at the repository level; if you have read (or write) access to *any* ref in the repository, then you have read (or write) access to the repository.

The second level, applicable only to "write" access, is by branch or tag within a repository.  The username, the access being attempted (`W` or `+`), and the refname being updated are known.  The access rules are checked in order of appearance in the config file, looking for a match for this combination (but remember that the refname is regex-matched, not merely string-matched).  If a match is found, the push succeeds.  A fallthrough results in access being denied.

### Advanced Access Control with "deny" rules ###

So far, we've only seen permissions to be one or `R`, `RW`, or `RW+`.  However, gitolite allows another permission: `-`, standing for "deny".  This gives you a lot more power, at the expense of some complexity, because now fallthrough is not the *only* way for access to be denied, so the *order of the rules now matters*!

Let us say, in the situation above, we want engineers to be able to rewind any branch *except* master and integ.  Here's how to do that:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Again, you simply follow the rules top down until you hit a match for your access mode, or a deny.  Non-rewind push to master or integ is allowed by the first rule.  A rewind push to those refs does not match the first rule, drops down to the second, and is therefore denied.  Any push (rewind or non-rewind) to refs other than master or integ won't match the first two rules anyway, and the third rule allows it.

### Restricting pushes by files changed ###

In addition to restricting what branches a user can push changes to, you can also restrict what files they are allowed to touch.  For example, perhaps the Makefile (or some other program) is really not supposed to be changed by just anyone, because a lot of things depend on it or would break if the changes are not done *just right*.  You can tell gitolite:

    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

This powerful feature is documented in `conf/example.conf`.

### Personal Branches ###

Gitolite also has a feature called "personal branches" (or rather, "personal branch namespace") that can be very useful in a corporate environment.

A lot of code exchange in the git world happens by "please pull" requests.  In a corporate environment, however, unauthenticated access is a no-no, and a developer workstation cannot do authentication, so you have to push to the central server and ask someone to pull from there.

This would normally cause the same branch name clutter as in a centralised VCS, plus setting up permissions for this becomes a chore for the admin.

Gitolite lets you define a "personal" or "scratch" namespace prefix for each developer (for example, `refs/personal/<devname>/*`); see the "personal branches" section in `doc/3-faq-tips-etc.mkd` for details.

### "Wildcard" repositories ###

Gitolite allows you to specify repositories with wildcards (actually perl regexes), like, for example `assignments/s[0-9][0-9]/a[0-9][0-9]`, to pick a random example.  This is a *very* powerful feature, which has to be enabled by setting `$GL_WILDREPOS = 1;` in the rc file.  It allows you to assign a new permission mode ("C") which allows users to create repositories based on such wild cards, automatically assigns ownership to the specific user who created it, allows him/her to hand out R and RW permissions to other users to collaborate, etc.  This feature is documented in `doc/4-wildcard-repositories.mkd`.

### Other Features ###

We'll round off this discussion with a sampling of other features, all of which, and many more, are described in great detail in the "faqs, tips, etc" and other documents.

**Logging**: Gitolite logs all successful accesses.  If you were somewhat relaxed about giving people rewind permissions (`RW+`) and some kid blew away "master", the log file is a life saver, in terms of easily and quickly finding the SHA that got hosed.

**Git outside normal PATH**: One extremely useful convenience feature in gitolite is support for git installed outside the normal `$PATH` (this is more common than you think; some corporate environments or even some hosting providers refuse to install things system-wide and you end up putting them in your own directories).  Normally, you are forced to make the *client-side* git aware of this non-standard location of the git binaries in some way.  With gitolite, just choose a verbose install and set `$GIT_PATH` in the "rc" files.  No client-side changes are required after that :-)

**Access rights reporting**: Another convenient feature is what happens when you try and just ssh to the server.  Gitolite shows you what repos you have access to, and what that access may be.  Here's an example:

        hello sitaram, the gitolite version here is v1.5.4-19-ga3397d4
        the gitolite config gives you the following access:
             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Delegation**: For really large installations, you can delegate responsibility for groups of repositories to various people and have them manage those pieces independently.  This reduces the load on the main admin, and makes him less of a bottleneck.  This feature has its own documentation file in the `doc/` directory.

**Gitweb support**: Gitolite supports gitweb in several ways.  You can specify which repos are visible via gitweb.  You can set the "owner" and "description" for gitweb from the gitolite config file.  Gitweb has a mechanism for you to implement access control based on HTTP authentication, so you can make it use the "compiled" config file that gitolite produces, which means the same access control rules (for read access) apply for gitweb and gitolite.

**Mirroring**: Gitolite can help you maintain multiple mirrors, and switch between them easily if the primary server goes down.

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories — you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

	[repo iphone_project]
	daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved. 

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page.

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Figure 4-3. The GitHub user signup form.

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Figure 4-4. The GitHub user dashboard.

Next you can create a new repository. 

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Figure 4-5. Creating a new repository on GitHub.

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Figure 4-6. GitHub project header information.

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instructions for a new repository.

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Figure 4-8. Project header with a public URL and a private URL.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Figure 4-9. Subversion importing interface.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Figure 4-10. GitHub administration page.

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adding a collaborator to your project.

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Figure 4-12. A list of collaborators on your project.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Figure 4-13. A GitHub main project page.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project.

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
