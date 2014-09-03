<!--# Getting Started #-->
# Los geht’s #

<!--This chapter will be about getting started with Git.  We will begin at the beginning by explaining some background on version control tools, then move on to how to get Git running on your system and finally how to get it setup to start working with.  At the end of this chapter you should understand why Git is around, why you should use it and you should be all setup to do so.-->

In diesem Kapitel wird es darum gehen, wie man mit Git loslegen kann. Wir werden erläutern, wozu Versionskontrollsysteme gut sind, wie man Git auf verschiedenen Systemen installieren und konfigurieren kann, sodass man in der Lage ist, mit der Arbeit anzufangen. Am Ende dieses Kapitels solltest Du verstehen, wozu Git gut ist, weshalb Du es verwenden solltest und wie Du damit loslegen kannst.

<!--## About Version Control ##-->
## Wozu Versionskontrolle? ##

<!--What is version control, and why should you care? Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later. Even though the examples in this book show software source code as the files under version control, in reality any type of file on a computer can be placed under version control.-->

Was ist  die Versionskontrolle, und warum solltest Du Dich dafür interessieren? Versionskontrollsysteme (VCS) protokollieren Änderungen an einer Datei oder einer Anzahl von Dateien über die Zeit hinweg, so dass man zu jedem Zeitpunkt auf Versionen und Änderungen zugreifen kann. Die Beispiele in diesem Buch verwenden Software Quellcode, tatsächlich aber kannst Du Änderungen an praktisch jeder Art von Datei per Versionskontrolle nachverfolgen.

<!--If you are a graphic or web designer and want to keep every version of an image or layout (which you certainly would), it is very wise to use a Version Control System (VCS). A VCS allows you to: revert files back to a previous state, revert the entire project back to a previous state, review changes made over time, see who last modified something that might be causing a problem, who introduced an issue and when, and more. Using a VCS also means that if you screw things up or lose files, you can generally recover easily. In addition, you get all this for very little overhead.-->

Als ein Grafik- oder Webdesigner zum Beispiel willst Du in der Lage sein, jede Version eines Bildes oder Layouts zurückverfolgen zu können. Es wäre daher sehr ratsam, ein Versionskontrollsystem zu verwenden. Ein solches System erlaubt Dir, einzelne Dateien oder auch ein ganzes Projekt in einen früheren Zustand zurückzuversetzen, nachzuvollziehen, wer zuletzt welche Änderungen vorgenommen hat, die möglicherweise Probleme verursachen, wer eine Änderung ursprünglich vorgenommen hat usw. Ein Versionskontrollsystem für Deine Arbeit zu verwenden, versetzt Dich in die Lage jederzeit zu einem vorherigen, funktionierenden Zustand zurückzugehen, wenn Du vielleicht Mist gebaut oder aus irgendeinem Grunde Dateien verloren hast. All diese Vorteile erhältst Du für einen nur sehr geringen, zusätzlichen Aufwand.

<!--### Local Version Control Systems ###-->
### Lokale Versionskontrollsysteme ###

<!--Many people’s version-control method of choice is to copy files into another directory (perhaps a time-stamped directory, if they’re clever). This approach is very common because it is so simple, but it is also incredibly error prone. It is easy to forget which directory you’re in and accidentally write to the wrong file or copy over files you don’t mean to.-->

Viele Leute kontrollieren Versionen ihrer Arbeit, indem sie einfach Dateien in ein anderes Verzeichnis kopieren (wenn sie clever sind: ein Verzeichnis mit einem Zeitstempel im Namen). Diese Vorgehensweise ist üblich, weil sie so einfach ist. Aber sie ist auch unglaublich fehleranfällig. Man vergisst sehr leicht, in welchem Verzeichnis man sich gerade befindet und kopiert die falschen Dateien oder überschreibt Dateien, die man eigentlich nicht überschreiben wollte.

<!--To deal with this issue, programmers long ago developed local VCSs that had a simple database that kept all the changes to files under revision control (see Figure 1-1).-->

Um diese Arbeit zu erleichtern und sicherer zu machen, haben Programmierer vor langer Zeit Versionskontrollsysteme entwickelt, die alle Änderungen an allen relevanten Dateien in einer lokalen Datenbank verfolgten (siehe Bild 1-1).

<!--Figure 1-1. Local version control diagram.-->

Insert 18333fig0101.png
Bild 1-1. Diagramm: Lokale Versionskontrolle

<!--One of the more popular VCS tools was a system called rcs, which is still distributed with many computers today. Even the popular Mac OS X operating system includes the rcs command when you install the Developer Tools. This tool basically works by keeping patch sets (that is, the differences between files) from one revision to another in a special format on disk; it can then recreate what any file looked like at any point in time by adding up all the patches.-->

Eines der populärsten Versionskontrollsysteme war rcs, und es wird heute immer noch mit vielen Computern ausgeliefert. Z.B. umfasst auch das Betriebssystem Mac OS X den Befehl rcs, wenn Du die Developer Tools installierst. Dieser Befehl arbeitet nach dem Prinzip, dass er für jede Änderung einen Patch (d.h. eine Kodierung der Unterschiede, die eine Änderung an einer oder mehreren Dateien umfasst) in einem speziellen Format in einer Datei auf der Festplatte speichert.

<!--### Centralized Version Control Systems ###-->
### Zentralisierte Versionskontrollsysteme ###

<!--The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems, such as CVS, Subversion, and Perforce, have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control (see Figure 1-2).-->

Das nächste Problem, mit dem Programmierer sich dann konfrontiert sahen, bestand in der Zusammenarbeit mit anderen: Änderungen an dem gleichen Projekt mussten auf verschiedenen Computern, möglicherweise verschiedenen Betriebssystemen vorgenommen werden können. Um dieses Problem zu lösen, wurden Zentralisierte Versionskontrollsysteme (CVCS) entwickelt. Diese Systeme, beispielsweise CVS, Subversion und Perforce, basieren auf einem zentralen Server, der alle versionierten Dateien verwaltet. Wer an diesen Dateien arbeiten will, kann sie von diesem Server abholen („check out“ xxx), auf seinem eigenen Computer bearbeiten und dann wieder auf dem Server abliefern. Diese Art von System war über viele Jahre hinweg der Standard für Versionskontrollsysteme (siehe Bild 1-2).

<!--Figure 1-2. Centralized version control diagram.-->

Insert 18333fig0102.png
Bild 1-2. Diagramm: Zentralisierte Versionskontrollsysteme

<!--This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client.-->

Dieser Aufbau hat viele Vorteile gegenüber Lokalen Versionskontrollsystemen. Zum Beispiel weiß jeder mehr oder weniger genau darüber Bescheid, was andere, an einem Projekt Beteiligte gerade tun. Administratoren haben die Möglichkeit, detailliert festzulegen, wer was tun kann. Und es ist sehr viel einfacher, ein CVCS zu administrieren als lokale Datenbanken auf jedem einzelnen Anwenderrechner zu verwalten.

<!--However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything—the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCS systems suffer from this same problem—whenever you have the entire history of the project in a single place, you risk losing everything.-->

Allerdings hat dieser Aufbau auch einige erhebliche Nachteile. Der offensichtlichste Nachteil ist der „Single Point of Failure“, den der zentralisierte Server darstellt. Wenn dieser Server für nur eine Stunde nicht verfügbar ist, dann kann in dieser Stunde niemand in irgendeiner Form mit anderen arbeiten oder versionierte Änderungen an den Dateien speichern, an denen sie momentan arbeiten. Wenn die auf dem zentralen Server verwendete Festplatte beschädigt wird und keine Sicherheitskopien erstellt wurden, dann sind all diese Daten unwiederbringlich verloren – die komplette Historie des Projektes, abgesehen natürlich von dem jeweiligen Zustand, den Mitarbeiter gerade zufällig auf ihrem Rechner haben. Lokale Versionskontrollsysteme haben natürlich dasselbe Problem: wenn man die Historie eines Projektes an einer einzigen, zentralen Stelle verwaltet, riskiert man, sie vollständig zu verlieren, wenn irgendetwas an dieser zentralen Stelle ernsthaft schief läuft.

<!--### Distributed Version Control Systems ###-->
### Verteilte Versionskontrollsysteme ###

<!--This is where Distributed Version Control Systems (DVCSs) step in. In a DVCS (such as Git, Mercurial, Bazaar or Darcs), clients don’t just check out the latest snapshot of the files: they fully mirror the repository. Thus if any server dies, and these systems were collaborating via it, any of the client repositories can be copied back up to the server to restore it. Every checkout is really a full backup of all the data (see Figure 1-3).-->

Und an dieser Stelle kommen verteilte Versionskontrollsysteme (DVCS) ins Spiel. In einem DVCS (wie z.B. Git, Mercurial, Bazaar oder Darcs) erhalten Anwender nicht einfach den jeweils letzten Snapshot des Projektes von einem Server: sie erhalten statt dessen eine vollständige Kopie des Repositories. Auf diese Weise kann, wenn ein Server beschädigt wird, jedes beliebige Repository von jedem beliebigen Anwenderrechner zurück kopiert werden und der Server so wieder hergestellt werden.

<!--Figure 1-3. Distributed version control diagram.-->

Insert 18333fig0103.png
Bild 1-3. Diagramm: Distribuierte Versionskontrolle

<!--Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.-->

Darüber hinaus können derartige Systeme hervorragend mit verschiedenen externen („remote“) Repositories umgehen, sodass man mit verschiedenen Gruppen von Leuten simultan in verschiedenen Weisen zusammenarbeiten kann. Das macht es möglich, verschiedene Arten von Arbeitsabläufen (wie Hierarchien) zu integrieren, was mit zentralisierten Systemen nicht möglich ist.

<!--## A Short History of Git ##-->
## Die Geschichte von Git ##

<!--As with many great things in life, Git began with a bit of creative destruction and fiery controversy. The Linux kernel is an open source software project of fairly large scope. For most of the lifetime of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS system called BitKeeper.-->

Wie viele großartige Dinge im Leben entstand Git aus kreativem Chaos und hitziger Diskussion. Der Linux Kernel ist ein Open Source Software Projekt von erheblichem Umfang. Während der gesamten Entwicklungszeit des Linux Kernels von 1991 bis 2002 wurden Änderungen an der Software in Form von Patches (d.h. Änderungen an bestehendem Code) und archivierten Dateien herumgereicht. 2002 began man dann, ein proprietäres DVCS System mit dem Namen „Bitkeeper“ zu verwenden.

<!--In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. Some of the goals of the new system were as follows:-->

2005 ging die Beziehung zwischen der Community, die den Linux Kernel entwickelte, und des kommerziell ausgerichteten Unternehmens, das BitKeeper entwickelte, kaputt. Die zuvor ausgesprochene Erlaubnis, BitKeeper kostenlos zu verwenden, wurde widerrufen. Dies war für die Linux Entwickler Community (und besonders für Linus Torvald, der Erfinder von Linux) der Auslöser dafür, ein eigenes Tool zu entwickeln, das auf den Erfahrungen mit BitKeeper basierte. Ziele des neuen Systems waren unter anderem:

<!--*	Speed-->
<!--*	Simple design-->
<!--*	Strong support for non-linear development (thousands of parallel branches)-->
<!--*	Fully distributed-->
<!--*	Able to handle large projects like the Linux kernel efficiently (speed and data size)-->

* Geschwindigkeit
* Einfaches Design
* Gute Unterstützung von nicht-linearer Entwicklung (tausende paralleler Branches, d.h. verschiedener Verzweigungen der Versionen)
* Vollständig verteilt
* Fähig, große Projekte wie den Linux Kernel effektiv zu verwalten (Geschwindigkeit und Datenumfang)

<!--Since its birth in 2005, Git has evolved and matured to be easy to use and yet retain these initial qualities. It’s incredibly fast, it’s very efficient with large projects, and it has an incredible branching system for non-linear development (See Chapter 3).-->

Seit seiner Geburt 2005 entwickelte sich Git kontinuierlich weiter und reifte zu einem System heran, das einfach zu bedienen ist, die ursprünglichen Ziele dabei aber weiter beibehält. Es ist unglaublich schnell, äußerst effizient, wenn es um große Projekte geht, und es hat ein fantastisches Branching Konzept für nicht-lineare Entwicklung (mehr dazu in Kapitel 3).

<!--## Git Basics ##-->
## Git Grundlagen ##

<!--So, what is Git in a nutshell? This is an important section to absorb, because if you understand what Git is and the fundamentals of how it works, then using Git effectively will probably be much easier for you. As you learn Git, try to clear your mind of the things you may know about other VCSs, such as Subversion and Perforce; doing so will help you avoid subtle confusion when using the tool. Git stores and thinks about information much differently than these other systems, even though the user interface is fairly similar; understanding those differences will help prevent you from becoming confused while using it.-->

Was also ist Git, in kurzen Worten? Es ist wichtig, den folgenden Abschnitt zu verstehen, in dem es um die grundlegenden Konzepte von Git geht. Das wird Dich in die Lage versetzen, Git einfacher und effektiver anzuwenden. Versuche Dein vorhandenes Wissen über andere Versionskontrollsysteme, wie Subversion oder Perforce, zu ignorieren, während Du Git kennen lernst. Git speichert und konzipiert Information anders als andere Systeme, auch wenn das Interface relativ ähnlich wirkt. Diese Unterschiede zu verstehen wird Dir helfen, Verwirrung bei der Anwendung von Git zu vermeiden.

<!--### Snapshots, Not Differences ###-->
### Snapshots, nicht Diffs ###

<!--The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4.-->

Der Hauptunterschied zwischen Git und anderen Versionskontrollsystemen (auch Subversion und vergleichbaren Systemen) besteht in der Art und Weise wie Git Daten betrachtet. Die meisten anderen Systeme speichern Information als eine fortlaufende Liste von Änderungen an Dateien („Diffs“). Diese Systeme (CVS, Subversion, Perforce, Bazaar usw.) betrachten die Informationen, die sie verwalten, als eine Menge von Dateien und die Änderungen, die über die Zeit hinweg an einzelnen Dateien vorgenommen werden. (Siehe Bild 1-4.)

<!--Figure 1-4. Other systems tend to store data as changes to a base version of each file.-->

Insert 18333fig0104.png
Bild 1-4. Andere Systeme speichern Daten als Änderungen an einzelnen Dateien einer Datenbasis

<!--Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5.-->

Git sieht Daten nicht in dieser Weise. Stattdessen betrachtet Git seine Daten eher als eine Reihe von Snapshots eines Mini-Dateisystems. Jedes Mal, wenn Du committest (d.h. den gegenwärtigen Status Deines Projektes als eine Version in Git speicherst), sichert Git den Zustand sämtlicher Dateien in diesem Moment („Snapshot“) und speichert eine Referenz auf diesen Snapshot. Um dies möglichst effizient und schnell tun zu können, kopiert Git unveränderte Dateien nicht, sondern legt lediglich eine Verknüpfung zu der vorherigen Version der Datei an. Git betrachtet Daten also wie in Bild 1-5 dargestellt.

<!--Figure 1-5. Git stores data as snapshots of the project over time.-->

Insert 18333fig0105.png
Bild 1-5. Git speichert Daten als eine Historie von Snapshots des Projektes.

<!--This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.-->

Dies ist ein wichtiger Unterschied zwischen Git und praktisch allen anderen Versionskontrollsystemen. In Git wurden daher fast alle Aspekte der Versionskontrolle neu überdacht, die in anderen Systemen mehr oder weniger von ihren jeweiligen Vorgängergeneration übernommen worden waren. Git arbeitet im Großen und Ganzen eher wie ein (mit einigen unglaublich mächtigen Werkezeugen ausgerüstetes) Mini-Dateisystem, als wie ein gängiges Versionskontrollsystem. Auf einige der Vorteile, die es mit sich bringt, Daten in dieser Weise zu betrachten, werden wir in Kapitel 3 eingehen, wenn wir das Git Branching Konzept diskutieren.

<!--### Nearly Every Operation Is Local ###-->
### Fast jede Operation ist lokal ###

<!--Most operations in Git only need local files and resources to operate — generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.-->

Die meisten Operationen in Git benötigen nur die lokalen Dateien und Ressourcen auf Deinem Rechner, um zu funktionieren. D.h. im Allgemeinen werden keine Informationen von einem anderen Rechner im Netzwerk benötigt. Wenn Du mit einem CVCS gearbeitet hast, das für die meisten Operationen einen Network Latency Overhead (also Wartezeiten, die das Netzwerk benötigt werden) hat, dann wirst Du den Eindruck haben, dass die Götter der Geschwindigkeit Git mit unaussprechlichen Fähigkeiten ausgestattet haben. Weil man die vollständige Historie lokal auf dem Rechner hat, werden die allermeisten Operationen ohne jede Verzögerung ausgeführt und sind sehr schnell.

<!--For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.-->

Um beispielsweise die Historie des Projektes zu durchsuchen, braucht Git sie nicht von einem externen Server zu holen – es liest sie einfach aus der lokalen Datenbank. Das heißt, Du siehst die vollständige Projekthistorie ohne jede Verzögerung. Wenn Du sehen willst, worin sich die aktuelle Version einer Datei von einer Version von vor einem Monat unterscheidet, dann kann Git diese Versionen lokal nachschlagen und ihre Unterschiede lokal bestimmen. Es braucht dazu keinen externen Server – weder um Dateien dort nachzuschlagen, noch um Unterschiede dort bestimmen zu lassen.

<!--This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.-->

Dies bedeutet natürlich außerdem, dass es fast nichts gibt, was Du nicht tun kannst, bloß weil Du gerade offline bist oder keinen Zugriff auf ein VPN hast. Wenn Du im Flugzeug oder Zug ein wenig arbeiten willst, kannst Du problemlos Deine Arbeit committen und Deine Arbeit erst auf den Server pushen (hochladen), wenn Du wieder mit dem Internet verbunden bist. Wenn Du zu Hause bist aber nicht auf das VPN zugreifen kannst, kannst Du dennoch arbeiten. Perforce z.B. erlaubt Dir dagegen nicht sonderlich viel zu tun, solange Du nicht mit dem Server verbunden bist. Und in Subversion und CVS kannst Du Dateien zwar ändern, die Änderungen aber nicht in der Datenbank sichern (weil die Datenbank offline ist). Das mag auf den ersten Blick nicht nach einem großen Problem aussehen, aber Du wirst überrascht sein, was für einen großen Unterschied das ausmachen kann.

<!--### Git Has Integrity ###-->
### Git stellt Integrität sicher ###

<!--Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.-->

In Git werden Änderungen in Checksummen umgerechnet, bevor sie gespeichert werden. Anschließend werden sie mit dieser Checksumme referenziert. Das macht es unmöglich, dass sich die Inhalte von Dateien oder Verzeichnissen ändern, ohne dass Git das mitbekommt. Git basiert auf dieser Funktionalität und sie ist ein integraler Teil von Gits Philosophie. Man kann Informationen deshalb z.B. nicht während der Übermittlung verlieren oder unwissentlich beschädigte Dateien verwenden, ohne dass Git in der Lage wäre, dies festzustellen.

<!--The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:-->

Der Mechanismus, den Git verwendet, um diese Checksummen zu erstellen, heißt SHA-1 Hash. Eine solche Checksumme ist eine 40 Zeichen lange Zeichenkette, die aus hexadezimalen Zeichen besteht und diese wird von Git aus den Inhalten einer Datei oder Verzeichnisstruktur kalkuliert. Ein SHA-1 Hash sieht wie folgt aus:

	24b9da6552252987aa493b52f8696cd6d3b00373

<!--You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.-->

Dir werden solche Hash Werte überall in Git begegnen, weil es sie so ausgiebig benutzt. Tatsächlich speichert und referenziert Git Informationen über Dateien in der Datenbank nicht nach ihren Dateinamen sondern nach den Hash Werten ihrer Inhalte.

<!--### Git Generally Only Adds Data ###-->
### Git verwaltet fast ausschließlich Daten ###

<!--When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.-->

Fast alle Operationen, die Du in der täglichen Arbeit mit Git verwendest, fügen Daten jeweils nur zur internen Git Datenbank hinzu. Deshalb ist es sehr schwer, das System dazu zu bewegen, irgendetwas zu tun, das nicht wieder rückgängig zu machen ist, oder dazu, Daten in irgendeiner Form zu löschen. In jedem anderen VCS ist es leicht, Änderungen, die man noch nicht gespeichert hat, zu verlieren oder unbrauchbar zu machen. In Git dagegen ist es schwierig, einen einmal gespeicherten Snapshot zu verlieren, insbesondere wenn man regelmäßig in ein anderes Repository pusht.

<!--This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see Chapter 9.-->

U.a. deshalb macht es so viel Spaß, mit Git zu arbeiten. Man kann mit Änderungen experimentieren, ohne befürchten zu müssen, irgendetwas zu zerstören oder durcheinander zu bringen. Einen tieferen Einblick in die Art, wie Git Daten speichert und wie man Daten, die scheinbar verloren sind, wieder herstellen kann, wird Kapitel 9 gewähren.

<!--### The Three States ###-->
### Die drei Zustände ###

<!--Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.-->

Jetzt aufgepasst. Es folgt die wichtigste Information, die Du Dir merken musst, wenn Du Git kennen lernen willst und Fallstricke vermeiden willst. Git definiert drei Haupt-Zustände, in denen sich eine Datei befinden kann: committed, modified („geändert“) und staged („vorgemerkt“). „Committed“ bedeutet, dass die Daten in der lokalen Datenbank gesichert sind. „Modified“ bedeutet, dass die Datei geändert, diese Änderung aber noch nicht committed wurde. „Staged“ bedeutet, dass Du eine geänderte Datei in ihrem gegenwärtigen Zustand für den nächsten Commit vorgemerkt hast.

<!--This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.-->

Das führt uns zu den drei Hauptbereichen eines Git Projektes: das Git Verzeichnis, das Arbeitsverzeichnis und die Staging Area.

<!--Figure 1-6. Working directory, staging area, and git directory.-->

Insert 18333fig0106.png
Bild 1-6. Arbeitsverzeichnis, Staging Area (xxx) und Git Verzeichnis

<!--The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.-->

Das Git Verzeichnis ist der Ort, an dem Git Metadaten und die lokale Datenbank für Dein Projekt speichert. Dies ist der wichtigste Teil von Git, und dieser Teil wird kopiert, wenn Du ein Repository von einem anderen Rechner klonst.

<!--The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.-->

Dein Arbeitsverzeichnis ist ein Checkout („Abbild“ xxx) einer spezifischen Version des Projektes. Diese Dateien werden aus der komprimierten Datenbank geholt und auf der Festplatte in einer Form gespeichert, die Du bearbeiten und modifizieren kannst.

<!--The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.-->

Die Staging Area ist einfach eine Datei (normalerweise im Git Verzeichnis), in der vorgemerkt wird, welche Änderungen Dein nächster Commit umfassen soll. Sie wird manchmal auch als „Index“ bezeichnet, aber der Begriff „Staging Area“ ist der gängigere.

<!--The basic Git workflow goes something like this:-->

Der grundlegend Git Arbeitsprozess sieht in etwa so aus:

<!--1. You modify files in your working directory.-->
<!--2. You stage the files, adding snapshots of them to your staging area.-->
<!--3. You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.-->

1. Du bearbeitest Dateien in Deinem Arbeitsverzeichnis.
2. Du markierst Dateien für den nächsten Commit, indem Du Snapshots zur Staging Area hinzufügst.
3. Du legst den Commit an, wodurch die in der Staging Area vorgemerkten Snapshots dauerhaft im Git Verzeichnis (d.h. der lokalen Datenbank) gespeichert werden.

<!--If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.-->

Wenn eine bestimmte Version einer Datei im Git Verzeichnis liegt, gilt sie als „committed“. Wenn sie geändert und in der Staging Area vorgemerkt ist, gilt sie als „staged“. Und wenn sie geändert, aber noch nicht zur Staging Area hinzugefügt wurde, gilt sie als „modified“. In Kapitel 2 wirst Du mehr über diese Zustände lernen und darüber, wie Du sie sinnvoll einsetzen und wie Du den Zwischenschritt der Staging Area auch einfach überspringen kannst.

<!--## Installing Git ##-->
## Git installieren ##

<!--Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the three major ones are to install it from source or to install an existing package for your platform.-->

Lass uns damit anfangen, Git tatsächlich zu verwenden. Der erste Schritt besteht natürlich darin, Git zu installieren und das kann, wie üblich, auf unterschiedliche Weisen geschehen. Die beiden wichtigsten bestehen darin, entweder den Quellcode herunterzuladen und selbst zu kompilieren oder ein fertiges Paket für Dein Betriebssystem zu installieren.

<!--### Installing from Source ###-->
### Vom Quellcode aus installieren ###

<!--If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.-->

Wenn es Dir möglich ist, empfehlen wir, Git vom Quellcode aus zu installieren, weil Du die jeweils neueste Version erhältst. In der Regel bringt jede Version nützliche Verbesserungen (z.B. am Interface), sodass es sich lohnt die jeweils neueste Version zu verwenden – sofern Du natürlich damit klarkommst, Software aus dem Quellcode zu kompilieren. Viele Linux Distributionen umfassen sehr alte Git Versionen. Wenn Du also keine sehr aktuelle Distribution oder Backports (xxx) verwendest, empfehlen wir, diesen Weg in Erwägung ziehen.

<!--To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:-->

Um Git zu installieren, benötigst Du die folgenden Bibliotheken, die von Git verwendet werden: curl, zlib, openssl, expat und libiconv. Wenn Dir auf Deinem System yum (z.B. auf Fedora) oder apt-get (z.B. auf Debian-basierten Systemen) zur Verfügung steht, kannst Du einen der folgenden Befehle verwenden, um diese Abhängigkeiten zu installieren:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ sudo apt-get install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

<!--When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:-->

Nachdem Du die genannten Bibliotheken installiert hast, besorge Dir die aktuelle Version des Git Quellcodes von der Git Webseite:

	http://git-scm.com/download

<!--Then, compile and install:-->

Danach kannst Du dann Git kompilieren und installieren:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

<!--After this is done, you can also get Git via Git itself for updates:-->

Von nun an kannst Du Git mit Hilfe von Git selbst aktualisieren:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

<!--### Installing on Linux ###-->
### Installation unter Linux ###

<!--If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:-->

Wenn Du Git unter Linux mit einem Installationsprogramm installieren willst, kannst Du das normalerweise mit dem Paketmanager tun, der von Deinem Betriebssystem verwendet wird. Unter Fedora zum Beispiel kannst Du yum verwenden:

	$ yum install git-core

<!--Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:-->

Auf einem Debian-basierten System wie Ubuntu steht Dir apt-get zur Verfügung:

	$ sudo apt-get install git

<!--### Installing on Mac ###-->
### Installation unter Mac OS X ###

<!--There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the SourceForge page (see Figure 1-7):-->

Auf einem Mac kann man Git auf zwei Arten installieren. Der einfachste ist, das grafische Git Installationsprogramm zu verwenden, den man von der SourceForge Webseite herunterladen kann (siehe Bild 1-7)

	http://sourceforge.net/projects/git-osx-installer/

<!--Figure 1-7. Git OS X installer.-->

Insert 18333fig0107.png
Bild 1-7. Git OS X Installationsprogramm

<!--The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via-->

Die andere Möglichkeit ist, Git via MacPorts (http://www.macports.org) zu installieren. Wenn Du MacPorts auf Deinem System hast, installiert der folgende Befehl Git:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

<!--You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).-->

Du brauchst die optionalen Features natürlich nicht mit zu installieren, aber es macht Sinn `+svn` zu verwenden, falls Du jemals Git mit einem Subversion Repository verwenden willst.

<!--Homebrew (`http://brew.sh/`) is another alternative to install Git. If you have Homebrew installed, install Git via

	$ brew install git

-->

Alternativ kann man Git auch über Homebrew (`http://brew.sh/`) installieren. Hast Du Homebrew bereits, kannst Du Git einfach über den folgenden Befehl installieren:

	$ brew install git

<!--### Installing on Windows ###-->
### Installation unter Windows ###

<!--Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the GitHub page, and run it:-->

Das msysGit Projekt macht die Installation von Git unter Windows sehr einfach. Lade einfach das Installationsprogramm für Windows von der GitHub Webseite herunter und führe es aus:

	http://msysgit.github.com/

<!--After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.-->

Danach hast Du sowohl eine Kommandozeilenversion (inklusive eines SSH Clients, der sich später noch als nützlich erweisen wird) als auch die Standard GUI installiert.

<!--Note on Windows usage: you should use Git with the provided msysGit shell (Unix style), it allows to use the complex lines of command given in this book. If you need, for some reason, to use the native Windows shell / command line console, you have to use double quotes instead of simple quotes (for parameters with spaces in them) and you must quote the parameters ending with the circumflex accent (^) if they are last on the line, as it is a continuation symbol in Windows.-->

Hinweis für Windows Benutzer: Du solltest Git mit der in msysGit enthaltenen Shell (Unix Style) ausführen. Dies erlaubt es Dir auch die komplexen Kommandozeilenbefehle aus diesem Buch auszuführen. Wenn Du aus irgendeinem Grund die native Windows Shell, also die Eingabeaufforderung, verwenden musst, müssen Gänsefüßchen, statt einzelnen Anführungszeichen verwendet werden (für Parameter, die ein Leerzeichen enthalten). Außerdem müssen alle Parameter, die mit einem Zirkumflex (^) enden und am Ende einer Zeile stehen, mit Gänsefüßchen umschlossen werden. Der Zirkumflex am Ende einer Zeile teilt Windows sonst mit, dass diese Zeile noch nicht beendet ist und in der nächsten Zeile fortgesetzt werden soll.

<!--## First-Time Git Setup ##-->
## Git konfigurieren ##

<!--Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.-->

Nachdem Du jetzt Git auf Deinem System installiert hast, solltest Du Deine Git Konfiguration anpassen. Das brauchst Du nur einmal zu tun, die Konfiguration bleibt auch bestehen, wenn Du Git auf eine neuere Version aktualisierst. Du kannst sie jederzeit ändern, indem Du die folgenden Befehle einfach noch einmal ausführst.

<!--Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:-->

Git umfasst das Werkzeug `git config`, das Dir erlaubt, Konfigurationswerte zu verändern. Auf diese Weise kannst Du anpassen, wie Git aussieht und arbeitet. Diese Werte sind an drei verschiedenen Orten gespeichert:

<!--*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` -\-system` to `git config`, it reads and writes from this file specifically.-->
<!--*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `-\-global` option.-->
<!--*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.-->

* Die Datei `/etc/gitconfig` enthält Werte, die für jeden Anwender des Systems und all ihre Projekte gelten. Wenn Du `git config` mit der Option `--system` verwendest, wird diese Datei verwendet.
* Die Werte in der Datei `~/.gitconfig` gelten ausschließlich für Dich und all Deine Projekte. Wenn Du `git config` mit der Option `--global` verwendest, wird diese Datei verwendet.
* Die Datei `.git/config` im Git Verzeichnis eines Projektes enthält Werte, die nur für das jeweilige Projekt gelten. Diese Dateien überschreiben Werte aus den jeweils vorhergehenden Dateien in dieser Reihenfolge. D.h. Werte in beispielsweise `.git/config` überschreiben diejenigen in `/etc/gitconfig`.

<!--On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`%USERPROFILE%` in Windows’ environment), which is `C:\Documents and Settings\$USER` or `C:\Users\$USER` for most people, depending on version (`$USER` is `%USERNAME%` in Windows’ environment). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.-->

Auf Windows Systemen sucht Git nach der `.gitconfig` Datei im `$HOME` Verzeichnis (für die meisten Leute ist das das Verzeichnis `C:\Dokumente und Einstellungen\$USER`). Es schaut auch immer nach `/etc/gitconfig`, auch wenn dieses relativ zu dem MSys Wurzelverzeichnis ist, welches das ist, wohin Du Git bei der Installation in Windows installiert hast.

<!--### Your Identity ###-->
### Deine Identität ###

<!--The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:-->

Nachdem Du Git installiert hast, solltest Du als erstes Deinen Namen und Deine E-Mail Adresse konfigurieren. Das ist wichtig, weil Git diese Information für jeden Commit verwendet, den Du anlegst, und sie ist unveränderlich in Deine Commits eingebaut (xxx):

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

<!--Again, you need to do this only once if you pass the `-\-global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `-\-global` option when you’re in that project.-->

Du brauchst diese Konfiguration, wie schon erwähnt, nur einmal vorzunehmen, wenn Du die `--global` Option verwendest, weil Git diese Information dann für all Deine Projekte verwenden wird. Wenn Du sie für ein spezielles Projekt mit einem anderen Namen oder einer anderen E-Mail Adresse überschreiben willst, kannst Du dazu den Befehl ohne die `--global` Option innerhalb dieses Projektes ausführen.

<!--### Your Editor ###-->
### Dein Editor ###

<!--Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:-->

Nachdem Du Deine Identität jetzt konfiguriert hast, kannst Du einstellen, welchen Texteditor Git in Situationen verwenden soll, in denen Du eine Nachricht eingeben musst. Normalerweise verwendet Git den Standard-Texteditor Deines Systems – das ist üblicherweise Vi oder Vim. Wenn Du einen anderen Texteditor, z.B. Emacs, verwenden willst, kannst Du das wie folgt festlegen:

	$ git config --global core.editor emacs

<!--### Your Diff Tool ###-->
### Dein Diff Programm ###

<!--Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:-->

Eine andere nützliche Einstellung, die Du möglicherweise vornehmen willst, ist welches Diff Programm Git verwendet. Mit diesem Programm kannst Du Konflikte auflösen, die während der Arbeit mit Git manchmal auftreten. Wenn Du beispielsweise vimdiff verwenden willst, kannst Du das so festlegen:

	$ git config --global merge.tool vimdiff

<!--Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.-->

Git kann von Hause aus mit den folgenden Diff Programmen arbeiten: kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff. Außerdem kannst Du ein eigenes Programm aufsetzen. Wir werden in Kapitel 7 darauf eingehen, wie das geht.

<!--### Checking Your Settings ###-->
### Deine Einstellungen überprüfen ###

<!--If you want to check your settings, you can use the `git config -\-list` command to list all the settings Git can find at that point:-->

Wenn Du Deine Einstellungen überprüfen willst, kannst Du mit dem Befehl `git config --list` alle Einstellungen anzuzeigen, die Git an dieser Stelle (z.B. innerhalb eines bestimmten Projektes) bekannt sind:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

<!--You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.-->

Manche Variablen werden möglicherweise mehrfach aufgelistet, weil Git dieselbe Variable in verschiedenen Dateien (z.B. `/etc/gitconfig` und `~/.gitconfig`) findet. In diesem Fall verwendet Git dann den jeweils zuletzt aufgelisteten Wert.

<!--You can also check what Git thinks a specific key’s value is by typing `git config {key}`:-->

Außerdem kannst Du mit dem Befehl `git config {key}` prüfen, welchen Wert Git für einen bestimmten Variablennamen verwendet:

	$ git config user.name
	Scott Chacon

<!--## Getting Help ##-->
## Hilfe finden ##

<!--If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:-->

Falls Du jemals Hilfe in der Anwendung von Git benötigst, gibt es drei Möglichkeiten, die entsprechende Seite aus der Dokumentation (manpage) für jeden Git Befehl anzuzeigen:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

<!--For example, you can get the manpage help for the config command by running-->

Beispielsweise erhältst Du die Hilfeseite für den `git config` Befehl so:

	$ git help config

<!--These commands are nice because you can access them anywhere, even offline.-->
<!--If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.-->

Die „manpage“ Dokumentation ist nützlich, weil Du sie Dir jederzeit anzeigen lassen kannst, auch wenn Du offline bist. Wenn Dir die manpages und dieses Buch nicht ausreichen, kannst Du Deine Fragen auch in den Chaträumen `#git` oder `#github` auf dem Freenode IRC Server (irc.freenode.net) stellen. Diese Räume sind in der Regel sehr gut besucht. Normalerweise findet sich unter den hunderten von Anwendern, die oft sehr viel Erfahrung mit Git haben, irgendjemand, der Deine Fragen gern beantwortet.

<!--## Summary ##-->
## Zusammenfassung ##

<!--You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.-->

Du solltest jetzt ein grundlegendes Verständnis davon haben, was Git ist und wie es sich von anderen CVCS unterscheidet, die Du möglicherweise schon verwendet hast. Du solltest außerdem eine funktionierende Git Version auf Deinem Rechner installiert und konfiguriert haben. Jetzt wird es Zeit, einige Git Grundlagen zu besprechen.
