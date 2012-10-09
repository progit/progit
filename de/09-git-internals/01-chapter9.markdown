# Git Internals #

# Git Internas #

You may have skipped to this chapter from a previous chapter, or you may have gotten here after reading the rest of the book — in either case, this is where you’ll go over the inner workings and implementation of Git. I found that learning this information was fundamentally important to understanding how useful and powerful Git is, but others have argued to me that it can be confusing and unnecessarily complex for beginners. Thus, I’ve made this discussion the last chapter in the book so you could read it early or later in your learning process. I leave it up to you to decide.

Möglicherweise hast du dieses Kapitel hier direkt aufgeschlagen, vorherige Kapitel ausgelassen, oder bist hierher gelangt, nachdem du alle vorherigen Kapitel gelesen hast. Wie auch immer, in diesem Kapitel wirst du mit mit den internen (xxx) und der Implementation von Git befassen. Meine eigene Erfahrung damit, diese Dinge zu lernen, war daß sie unerläßlich ist, um zu verstehen, wie unheimlich mächtig und flexibel Git ist. Allerdings gibt es Leute, die der Ansicht sind, daß sie auch verwirrend und unnötig komplex für Anfänger sein könne. Deshalb habe ich mich entschieden, dieses Kapitel an das Ende des Buches zu verlegen. Du kannst es, ganz wie es dir beliebt, früher oder später einschieben.

Now that you’re here, let’s get started. First, if it isn’t yet clear, Git is fundamentally a content-addressable filesystem with a VCS user interface written on top of it. You’ll learn more about what this means in a bit.

Laß uns also loslegen. Zunächst will ich betonen, falls das bisher noch nicht klargeworden ist, daß Git im seinen Grundzügen ein Dateisystem ist, dessen Inhalte addressierbar sind (xxx content-addressable filesystem ??? xxx) und auf dem ein VCS Interface sitzt. Wir werden gleich genauer darauf eingehen, was das heißt. 

In the early days of Git (mostly pre 1.5), the user interface was much more complex because it emphasized this filesystem rather than a polished VCS. In the last few years, the UI has been refined until it’s as clean and easy to use as any system out there; but often, the stereotype lingers about the early Git UI that was complex and difficult to learn.

In den frühen Tagen von Git (d.h. vor der Version 1.5.) war das Interface sehr viel komplexer, weil es diese Dateisystem Eigenschaften stark betonte - im Gegensatz zu einem ausgearbeiteten VCS. In den letzten Jahren wurde das Interface dann stückweise verbessert und verfeinert, so daß es heute so einfach verständlich und einfach zu verwenden ist, wie alle möglichen vergleichbaren Systeme, die es gibt. Allerdings besteht scheinbar weiterhin das Vorurteil, daß das Git Interface komplex und schwer zu erlernen sei.

The content-addressable filesystem layer is amazingly cool, so I’ll cover that first in this chapter; then, you’ll learn about the transport mechanisms and the repository maintenance tasks that you may eventually have to deal with.

Die Dateisystem Ebene ist erstaunlich cool, weshalb ich in diesem Kapitel zuerst darauf eingehen werde. Als nächstes lernst du etwas über die Transport Mechanismen und Repository Wartungsaufgaben, mit denen du möglicherweise irgendwann zu tun bekommen wirst.

## Plumbing and Porcelain ##

## Plumbing und Porcelain ##

This book covers how to use Git with 30 or so verbs such as `checkout`, `branch`, `remote`, and so on. But because Git was initially a toolkit for a VCS rather than a full user-friendly VCS, it has a bunch of verbs that do low-level work and were designed to be chained together UNIX style or called from scripts. These commands are generally referred to as "plumbing" commands, and the more user-friendly commands are called "porcelain" commands.

In diesem Buch haben wir Git besprochen, indem wir vielleicht 30 Befehle wie `checkout`, `branch`, `remote` und so weiter verwendet haben. Weil Git aber ursprünglich als ein Werkzeugkasten konzipiert war, un nicht so sehr als ein komplettes, anwenderfreundliches VCS, gibt es auch eine Reihe von Befehlen, die ihre Arbeit auf einer sehr viel grundlegenderen Ebene verrichten. Viele davon sind ursprünglich entwickelt worden, um als UNIX Befehle miteinander verkettet zu werden oder aus Scripten heraus aufgerufen zu werden. Diese Befehle werden oft als "plumbing" (xxx) Befehle zusammengefaßt, während die eher anwenderfreundlichen Befehle "porcelain" (d.h. Porzellan) genannt werden. 

The book’s first eight chapters deal almost exclusively with porcelain commands. But in this chapter, you’ll be dealing mostly with the lower-level plumbing commands, because they give you access to the inner workings of Git and help demonstrate how and why Git does what it does. These commands aren’t meant to be used manually on the command line, but rather to be used as building blocks for new tools and custom scripts.

Die ersten acht Kapitel dieses Buches haben sich fast ausschließlich mit "porcelain" Befehlen befaßt. In diesem Kapitel gehen wir dagegen auf die zugrundeliegenden "plumbing" Befehle ein, u.a. weil sie dir den Zugriff auf Git's innere Abläufe ermöglichen, und weil sie dabei helfen, zu verstehen, warum Git tut, was es tut. Diese Befehle sind nicht unbedingt dazu bestimmt direkt (xxx on the command line xxx) ausgeführt zu werden, sondern sind als Bausteine für Werkzeuge und Scripts gemeint.

When you run `git init` in a new or existing directory, Git creates the `.git` directory, which is where almost everything that Git stores and manipulates is located. If you want to back up or clone your repository, copying this single directory elsewhere gives you nearly everything you need. This entire chapter basically deals with the stuff in this directory. Here’s what it looks like:

Wenn du `git init` in einem neuen oder bereits bestehenden Verzeichnis ausführst, erzeugt Git das `.git` Verzeichnis, das fast alle Dateien enthält, die Git intern speichert und ändert. Wenn du eine Sicherheitskopie deines Repositories anlegen oder es duplizieren willst, dann reicht aus, dieses Verzeichnis zu kopieren. Dieses ganze Kapitel handelt praktisch nur von den Inhalten dieses Verzeichnisses - die so aussehen:

	$ ls 
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

You may see some other files in there, but this is a fresh `git init` repository — it’s what you see by default. The `branches` directory isn’t used by newer Git versions, and the `description` file is only used by the GitWeb program, so don’t worry about those. The `config` file contains your project-specific configuration options, and the `info` directory keeps a global exclude file for ignored patterns that you don’t want to track in a .gitignore file. The `hooks` directory contains your client- or server-side hook scripts, which are discussed in detail in Chapter 6.

Möglicherweise findest du darin weitere Dateien. Obiges stammt aus einem mit `git init` neuangelegten Repository - das sind also die Standardinhalte. Der Ordner `branches` wird von neueren Git Versionen nicht mehr verwendet, und die Datei `descriptions` wird nur vom Programm GitWeb benötigt. Du kannst sie also ignorieren. Die Datei `config` enthält deine Projekt-spezifischen Konfigurationsoptionen, und im Ordner `info` befindet sich eine Datei, die globale Dateiausschlußpatterns (xxx) enthält, die du nicht in jeder .gitignore Datei neu spezifizieren willst. Das `hooks` Verzeichnis enthält die client- oder serverseitigen Hook Scripte, die wir in Kapitel 6 besprochen haben.

This leaves four important entries: the `HEAD` and `index` files and the `objects` and `refs` directories. These are the core parts of Git. The `objects` directory stores all the content for your database, the `refs` directory stores pointers into commit objects in that data (branches), the `HEAD` file points to the branch you currently have checked out, and the `index` file is where Git stores your staging area information. You’ll now look at each of these sections in detail to see how Git operates.

Damit bleiben vier wichtige Einträge übrig: die Dateien `HEAD` und `index` und die Verzeichnisse `objects` und `refs`. Dies sind die Kernkomponenten eines Git Repositories: Im `objects` Verzeichnis befinden sich die Inhalte der Datenbank. Das `refs` Verzeichnis enthält Referenzen auf Commit Objekte (Branches) in dieser Datenbank. Die Datei `HEAD` zeigt auf denjeningen Branch, den du gegenwärtig ausgecheckt hast, und in der Datei `index` verwaltet Git die Informationen der Staging Area. Wir werden auf diese Elemente jetzt im einzelnen darauf eingehen, so daß du nachvollziehen kannst, wie Git intern arbeitet.

## Git Objects ##

## Git Objekte ##

Git is a content-addressable filesystem. Great. What does that mean?
It means that at the core of Git is a simple key-value data store. You can insert any kind of content into it, and it will give you back a key that you can use to retrieve the content again at any time. To demonstrate, you can use the plumbing command `hash-object`, which takes some data, stores it in your `.git` directory, and gives you back the key the data is stored as. First, you initialize a new Git repository and verify that there is nothing in the `objects` directory:

Git ist ein Dateisystem, das Inhalte addressieren kann. Prima. Aber was heißt das? Es bedeutet, daß Git im Kern nichts anderes ist als ein einfacher Key-Value-Store ("Schlüssel-Wert-Speicher"). Du kannst darin jede Art von Inhalt ablegen und Git wird einen Schlüssel dafür zurückgeben, den du dann verwenden kannst, um diesen Inhalt jederzeit nachzuschlagen. Um das auszuprobieren, kannst du den Plumbing Befehl `hash-object` verwenden. Dieser nimmt einen Inhalt an, speichert ihn in deinem `.git` Verzeichnis und gibt dir den Schlüssel zurück, unter dem der Inhalt gespeichert wurde. Dazu initialisierst du als erstes ein neues Git Repository und verifizierst, daß das `objects` Verzeichnis leer ist:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

Git has initialized the `objects` directory and created `pack` and `info` subdirectories in it, but there are no regular files. Now, store some text in your Git database:

Git hat also ein Verzeichnis `objects` und darin die `pack` und `info` Unterverzeichnisse angelegt, bisher aber keine weiteren Dateien. Als nächsten speichern wir einen Text in dieser Git Datenbank:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

The `-w` tells `hash-object` to store the object; otherwise, the command simply tells you what the key would be. `--stdin` tells the command to read the content from stdin; if you don’t specify this, `hash-object` expects the path to a file. The output from the command is a 40-character checksum hash. This is the SHA-1 hash — a checksum of the content you’re storing plus a header, which you’ll learn about in a bit. Now you can see how Git has stored your data:

Die Option `-w` weist `git hash-object` an, das Objekt zu speichern. Andernfalls würde dir der Befehl lediglich den Schlüssel mitteilen. `--stdin` weist den Befehl an, den Inhalt von aus der Standardeingabe zu lesen. Wenn du diese Option wegläßt, erwartet der Befehl zusätzlich einen Dateipfad. Die Ausgabe ist eine 40 Zeichen langer SHA-1 Hash, der eine Prüfsumme des gespeicherten Inhaltes darstellt (wir gehen auf diese Hashes gleich noch genauer ein). Git hat jetzt außerdem eine neue Datei in der Datenbank angelegt:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

You can see a file in the `objects` directory. This is how Git stores the content initially — as a single file per piece of content, named with the SHA-1 checksum of the content and its header. The subdirectory is named with the first 2 characters of the SHA, and the filename is the remaining 38 characters.

D.h., im `objects` Verzeichnis befindet sich genau eine Datei. Auf diese Weise Git speichert Inhalte (xxx wieso initially? xxx): in jeweils einer Datei pro Inhalt, referenziert durch den SHA-1 Hash des Inhaltes und seines Headers (xxx Kopfdaten? xxx). Der Name des Unterverzeichnis `d6` sind die ersten zwei Zeichen des SHA-1 Hashes und der Dateiname die verbleibenden 38 Zeichen.

You can pull the content back out of Git with the `cat-file` command. This command is sort of a Swiss army knife for inspecting Git objects. Passing `-p` to it instructs the `cat-file` command to figure out the type of content and display it nicely for you:

Mit dem Befehl `git cat-file` kannst du den jeweiligen Inhalt nachschlagen. Dieser Befehl ist so etwas wie ein Schweizer Taschenmesser, wenn es um Objekte in der Git Datenbank geht. Wenn du die Option `-p` übergibst, versucht `git cat-file`, die Art des Inhaltes (z.B. den Dateitypen xxx) herauszufinden und die Anzeige entsprechend lesbar zu formatieren:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Now, you can add content to Git and pull it back out again. You can also do this with content in files. For example, you can do some simple version control on a file. First, create a new file and save its contents in your database:

Auf diese Weise kannst du also Inhalte zur Datenbank hinzufügen und von dort wieder nachschlagen. Wenn du beispielsweise eine einzelne Datei versionskontrollieren willst, kannst du zunächst die Datei anlegen und den Inhalt in der Datenbank speichern:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

Then, write some new content to the file, and save it again:

Dann kannst du Änderungen vornehmen und die Datei erneut speichern:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Your database contains the two new versions of the file as well as the first content you stored there:

Die Datenbank enthält jetzt zwei weitere Versionen der Datei neben dem ursprünglich gespeicherten Inhalt (xxx):

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Now you can revert the file back to the first version

Jetzt kannst du die erste Version der Datei mit folgendem Befehl wieder herstellen:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

or the second version:

Oder die zweite Version:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

But remembering the SHA-1 key for each version of your file isn’t practical; plus, you aren’t storing the filename in your system — just the content. This object type is called a blob. You can have Git tell you the object type of any object in Git, given its SHA-1 key, with `cat-file -t`:

Sich den SHA-1 Hash für jede Version merken zu müssen, ist allerdings nicht sonderlich praktisch. Außerdem speicherst du nicht den Dateinamen in der Datenbank, sondern lediglich den Inhalt der Datei. Ein solcher Objekttyp wird als "Blob" bezeichnet. Mit `git cat-file -t` kannst du Git nach dem Typ eines Objektes in der Datenbank fragen:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Tree Objects ###

### Baum Objekte ###

The next type you’ll look at is the tree object, which solves the problem of storing the filename and also allows you to store a group of files together. Git stores content in a manner similar to a UNIX filesystem, but a bit simplified. All the content is stored as tree and blob objects, with trees corresponding to UNIX directory entries and blobs corresponding more or less to inodes or file contents. A single tree object contains one or more tree entries, each of which contains a SHA-1 pointer to a blob or subtree with its associated mode, type, and filename. For example, the most recent tree in the simplegit project may look something like this:

Als nächstes schauen wir uns den Objekttyp "Tree" (Baum) an, der es ermöglicht, Dateinamen zu speichern und Dateien zu gruppieren. Git speichert Inhalte in einer ähnlichen Weise wie das UNIX Dateisystem, allerdings ein bißchen vereinfacht. Sie werden als Tree und Blob Objekte abgelegt, wobei die Trees mit UNIX Verzeichnis Einträgen korrespondieren und Blobs mehr oder weniger mit den inode Einträgen bzw. Datei Inhalten. Ein einzelnes Baum Objekt enthält einen oder mehrere Einträge, von denen jeder ein SHA-1 Hash ist, der wiederum einen Blob oder einen Untertree referenziert. Jeder dieser Einträge verfügt außerdem über einen Modus, Typ und Dateinamen. Beispielsweise sieht das aktuelle Tree Objekt im simplegit Projekt möglicherweise so aus:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

The `master^{tree}` syntax specifies the tree object that is pointed to by the last commit on your `master` branch. Notice that the `lib` subdirectory isn’t a blob but a pointer to another tree:

Die `master^{tree}` Syntax spezifiziert, daß wir an dem Tree Objekt interessiert sind, auf das der letzte Commit des `master` Branches zeigt. Beachte, daß das `lib` Unterverzeichnis nicht auf ein Blob, sondern wiederum auf einen weiteren Baum zeigt.

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Conceptually, the data that Git is storing is something like Figure 9-1.

Git speichert Daten also, konzeptuell gesehen, in etwa wie in Bild 9-1 dargestellt.

Insert 18333fig0901.png 
Figure 9-1. Simple version of the Git data model.

Bild 9-1. Vereinfachte Darstellung des Git Datenmodels.

You can create your own tree. Git normally creates a tree by taking the state of your staging area or index and writing a tree object from it. So, to create a tree object, you first have to set up an index by staging some files. To create an index with a single entry — the first version of your text.txt file — you can use the plumbing command `update-index`. You use this command to artificially add the earlier version of the test.txt file to a new staging area. You must pass it the `--add` option because the file doesn’t yet exist in your staging area (you don’t even have a staging area set up yet) and `--cacheinfo` because the file you’re adding isn’t in your directory but is in your database. Then, you specify the mode, SHA-1, and filename:

Du kannst auch deine eigenen Tree Objekte anlegen. Git erzeugt Trees normalerweise, indem es die Inhalte der Staging Area nimmt und als ein Tree Objekt speichert. D.h., um ein Tree Objekt anzulegen, mußt du zunächst einen Index (d.h. eine Staging Area) erzeugen, indem du einige Dateien hinzufügst. Um einen einzelnen Eintrag in den Index zu schreiben - z.B. die erste version der test.txt Datei - kannst du den Plumbing Befehl `git update-index` verwenden, der eine frühere Version dieser Datei künstlich zu einer neuen Staging Area hinzufügt. Du mußt ihm die `--add` Option übergeben, weil die Datei bisher noch nicht in der Staging Area enthalten ist (du hast ja bisher noch überhaupt keine Staging Area aufgesetzt), und die `--cacheinfo` Option, weil du eine Datei hinzufügst, die sich nicht in deinem Arbeitsverzeichnis befindet (xxx hu? xxx), sondern in der Datenbank. Du gibst außerdem den Modus, SHA-1 Hash und den Dateinamen an:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

In this case, you’re specifying a mode of `100644`, which means it’s a normal file. Other options are `100755`, which means it’s an executable file; and `120000`, which specifies a symbolic link. The mode is taken from normal UNIX modes but is much less flexible — these three modes are the only ones that are valid for files (blobs) in Git (although other modes are used for directories and submodules).

In diesem Fall gibst du als Modus `100644` an, was bedeutet, daß es sich um eine normale Date handelt. Eine ausführbare Datei wäre dagegen `100755` und ein symbolischer Link `120000`. Der Modus entspricht normalen UNIX Datei Modi, ist aber weniger flexibel. Die drei genannten Modi sind die einzigen, die in in Git für Dateien (blobs) verwendet werden (es gibt allerdings noch weitere Modi für Verzeichnisse und Submodule xxx).

Now, you can use the `write-tree` command to write the staging area out to a tree object. No `-w` option is needed — calling `write-tree` automatically creates a tree object from the state of the index if that tree doesn’t yet exist:

Jetzt kannst du den Befehl `git write-tree` verwenden, um die Staging Area als Tree Objekt zu schreiben. Dazu brauchst du die `-w` Option nicht angeben - `git write-tree` schreibt automatisch ein Tree Objekt für Einträge der Staging Area, für die es noch keinen Tree gibt:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

You can also verify that this is a tree object:

Um zu überprüfen, daß es wirklich ein Tree Objekt gibt:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

You’ll now create a new tree with the second version of test.txt and a new file as well:

Jetzt erzeugen wir einen neuen Tree mit der zweiten Version der test.txt Datei sowie eine neue Datei:

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

Your staging area now has the new version of test.txt as well as the new file new.txt. Write out that tree (recording the state of the staging area or index to a tree object) and see what it looks like:

Die Staging Area enthält jetzt eine neue Version der test.txt Datei sowie die neue Datei new.txt. Speichern wir diesen Tree (d.h. den gegenwärtigen Status der Staging Area bzw. des Index als Tree Objekt) und schauen ihn uns an:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Notice that this tree has both file entries and also that the test.txt SHA is the "version 2" SHA from earlier (`1f7a7a`). Just for fun, you’ll add the first tree as a subdirectory into this one. You can read trees into your staging area by calling `read-tree`. In this case, you can read an existing tree into your staging area as a subtree by using the `--prefix` option to `read-tree`:

Beachte, daß das Tree Objekt zwei Datei Einträge hat und daß der SHA-1 Hash der test.txt Datei noch derselbe "Version 2" Hash ist wie zuvor (`1f7a7a`). Fügen wir jetzt den ersten Tree als ein Unterverzeichnis is diesem hier ein. Du kannst einen Tree mit `git read-tree` in die Staging Area einlesen. In diesem Fall können wir einen bereits existierenden Tree als einen Untertree zur Staging Area hinzufügen, indem wir die `--prefix` Option verwenden:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

If you created a working directory from the new tree you just wrote, you would get the two files in the top level of the working directory and a subdirectory named `bak` that contained the first version of the test.txt file. You can think of the data that Git contains for these structures as being like Figure 9-2.

Wenn du ein Arbeitsverzeichnis aus diesem neuen Tree Objekt auschecken würdest, würdest du zwei Dateien im Hauptverzeichnis und ein Unterverzeichnis mit dem Namen `bak` erhalten, in dem sich die erste Version der Datei test.txt befindet. Du kannst dir die Daten, die Git für diese Strukturen speichert, in etwa wie in Bild 9-2 vorstellen.

Insert 18333fig0902.png 
Figure 9-2. The content structure of your current Git data.

Bild 9-2. Die Datenstruktur des gegenwärtigen Git Repositories.

### Commit Objects ###

### Objekte committen ###

You have three trees that specify the different snapshots of your project that you want to track, but the earlier problem remains: you must remember all three SHA-1 values in order to recall the snapshots. You also don’t have any information about who saved the snapshots, when they were saved, or why they were saved. This is the basic information that the commit object stores for you.

Du hast jetzt drei Trees, die verschiedene Snapshots deines Projektes spezifizieren (xxx), die du nachverfolgen willst. Das ursprüngliche Problem besteht aber weiterhin: du mußt alle drei SHA-1 Hash Werte erinnern, um wieder an die Snapshots zu kommen. Ebenso fehlen dir die Informationen darüber, wer die Snapshots gespeichert hat, wann sie gespeichert wurden und warum. Dies sind die drei Hauptinformationen, die ein Commit Objekt für uns speichert.

To create a commit object, you call `commit-tree` and specify a single tree SHA-1 and which commit objects, if any, directly preceded it. Start with the first tree you wrote:

Um ein Commit Objekt anzulegen, verwendest du den Befehl `git commit-tree`, spezifizierst einen einzelnen Tree SHA-1 Hash und welche Commit Objekte (sofern vorhanden) die direkten Vorgänger sind. Fangen wir damit an, den ersten Tree, den du angelegt hast, zu committen:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Now you can look at your new commit object with `cat-file`:

Du kannst diesen Commit jetzt mit `git cat-file` nachschlagen:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

The format for a commit object is simple: it specifies the top-level tree for the snapshot of the project at that point; the author/committer information pulled from your `user.name` and `user.email` configuration settings, with the current timestamp; a blank line, and then the commit message.

Das Format für ein Commit Objekt ist einfach: es besteht aus dem toplevel Tree für den Snapshot des Projektes zum gegebenen Zeitpunkt, die Autor und ggf. Committer Information (jeweils entsprechend deiner `user.name` und `user.email` Konfiguration) und dem Timestamp. Dann folgen eine leere Zeile und die Commit Meldung.

Next, you’ll write the other two commit objects, each referencing the commit that came directly before it:

Als nächstes speichern wir die beiden anderen Commit Objekte und referenzieren jeweils den vorhergehenden Commit:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Each of the three commit objects points to one of the three snapshot trees you created. Oddly enough, you have a real Git history now that you can view with the `git log` command, if you run it on the last commit SHA-1:

Jedes der drei Commit Objekte zeigt auf einen der drei Snapshopt Trees, die du zuvor gespeichert hattest. Es mag dich überraschen, aber du hast jetzt bereits eine vollständige Git Historie, die du mit dem `git log` inspizieren kannst, indem du den letzten Commit SHA-1 Hash angibst:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Amazing. You’ve just done the low-level operations to build up a Git history without using any of the front ends. This is essentially what Git does when you run the `git add` and `git commit` commands — it stores blobs for the files that have changed, updates the index, writes out trees, and writes commit objects that reference the top-level trees and the commits that came immediately before them. These three main Git objects — the blob, the tree, and the commit — are initially stored as separate files in your `.git/objects` directory. Here are all the objects in the example directory now, commented with what they store:

Fantastisch, oder? Du hast jetzt sämtliche low-level Operationen durchgeführt, die eine vollständige Git Historie aufbauen, ohne aber irgendwelche Git Frontend Befehle (xxx) zu verwenden. Im wesentlichen ist das derselbe Prozeß, der im Hintergrund stattfindet, wenn du die Befehle `git add` und `git commit` ausführst. Sie speichern Blobs für die Dateien, die du hinzugefügt oder geändert hast, aktualisieren den Index (d.h. die Staging Area), speichern Trees und legen Commit Objekte an, die die toplevel Trees und Commits referenzieren, die ihnen unmittelbar vorhergingen. Diese drei Hauptobjekte - Blob, Tree und Commit - werden zunächst als separate Dateien im `.git/objects` Verzeichnis gespeichert. Hier ist eine Liste aller Objekte, die sich in unserem Beispiel Repository jetzt in der Datenbank befinden - jeweils mit einem Kommentar darüber, was sie speichern:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

If you follow all the internal pointers, you get an object graph something like Figure 9-3.

Wenn man all diese Zeiger auflöst, erhält man einen Objekt Graphen wie den folgenden (Bild 9-3).

Insert 18333fig0903.png 
Figure 9-3. All the objects in your Git directory.

Bild 9-3. Die Objekte im Beispielrepository.

### Object Storage ###

### Objekt Speicher ###

I mentioned earlier that a header is stored with the content. Let’s take a minute to look at how Git stores its objects. You’ll see how to store a blob object — in this case, the string "what is up, doc?" — interactively in the Ruby scripting language. You can start up interactive Ruby mode with the `irb` command:

Wir haben kurz erwähnt, daß zusammen mit einem Inhalt ein Header gespeichert wird. Schauen wir uns also genauer an, wie genau Git Objekte speichert. Du wirst sehen, wie ein Blob Objekt - in diesem Fall der String "what is up, doc?" (xxx übersetzen? xxx) gespeichert wird. Dazu nuten wir den interaktiven Ruby Modus, den du mit dem `irb` Befehl starten kannst:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git constructs a header that starts with the type of the object, in this case a blob. Then, it adds a space followed by the size of the content and finally a null byte:

Git erzeugt einen Header, der mit dem Objekt Typ beginnt, in diesem Fall ist das ein Blob. Dann folgt ein Leerzeichen, die Anzahl der Zeichen des Inhalts und schließlich ein Nullbyte.

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git concatenates the header and the original content and then calculates the SHA-1 checksum of that new content. You can calculate the SHA-1 value of a string in Ruby by including the SHA1 digest library with the `require` command and then calling `Digest::SHA1.hexdigest()` with the string:

Git fügt diesen Header mit dem ursprünglichen Inhalt zusammen und kalkuliert aus dem Ergebnis die SHA-1 Prüfsumme (Hash). Du kannst einen SHA-1 Hash in Ruby berechnen, indem du die SHA1 digest Bibliothek mit `require` einbindest und dann `Digest::SHA1.hexdigest()` mit dem String ausführst:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git compresses the new content with zlib, which you can do in Ruby with the zlib library. First, you need to require the library and then run `Zlib::Deflate.deflate()` on the content:

Git komprimiert den neuen Inhalt (d.h. inklusive des Headers) mit zlib. In Ruby kannst du dazu die zlib Bibliothek verwenden, indem du wiederum zuerst die Bibliothek mit `require` einbindest und dann `Zlib::Deflate.deflate()` mit dem Inhalt aufrufst:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Finally, you’ll write your zlib-deflated content to an object on disk. You’ll determine the path of the object you want to write out (the first two characters of the SHA-1 value being the subdirectory name, and the last 38 characters being the filename within that directory). In Ruby, you can use the `FileUtils.mkdir_p()` function to create the subdirectory if it doesn’t exist. Then, open the file with `File.open()` and write out the previously zlib-compressed content to the file with a `write()` call on the resulting file handle:

Schließlich schreibst du den zlib-komprimierten Inhalt in eine Datei auf der Festplatte. Dazu bestimmst du den Pfad, an den die Datei gespeichert wird (die ersten beiden Zeichen für das Unterverzeichnis und die verbleibenden 38 Zeichen für den Dateinamen). In Ruby kannst du die Funktion `FileUtils.mkdir_p()` verwenden, um Unterverzeichnisse anzulegen, die noch nicht existieren. Dann öffnest die Datei mit `File.open()` und schreibst den komprimierten Inhalt mit `write()` in die Datei:

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

That’s it — you’ve created a valid Git blob object. All Git objects are stored the same way, just with different types — instead of the string blob, the header will begin with commit or tree. Also, although the blob content can be nearly anything, the commit and tree content are very specifically formatted.

Das ist alles - du hast jetzt ein valides Git Blob Objekt geschrieben. Git Objekte werden immer in dieser Weise gespeichert, lediglich mit verschiedenen Typen, d.h. anstelle des Strings "blob" wird der Header mit "commit" oder "tree" anfangen. Außerdem sind Commit und Tree Inhalte auf eine sehr spezifische Weise formatiert, während Blobs beliebige Inhalte sein können.

## Git References ##

## Git Referenzen ##

You can run something like `git log 1a410e` to look through your whole history, but you still have to remember that `1a410e` is the last commit in order to walk that history to find all those objects. You need a file in which you can store the SHA-1 value under a simple name so you can use that pointer rather than the raw SHA-1 value.

Du kannst Befehle wie `git log 1a410e` ausführen, um die Commit Historie zu inspizieren, aber dazu mußt du dir jeweils merken, daß `1a410e` der jeweils letzte Commit ist. Um diese SHA-1 Hashes mit einfacheren, verständlichen Namen zu referenzieren, verwendet Git weitere Dateien, in denen die Namen für Hashes gespeichert sind.

In Git, these are called "references" or "refs"; you can find the files that contain the SHA-1 values in the `.git/refs` directory. In the current project, this directory contains no files, but it does contain a simple structure:

Diese Namen werden in Git intern als "references" oder "refs" bezeichnet. Du kannst diese Dateien, die SHA-1 Hashes enthalten, im `.git/refs` Verzeichnis finden. In unserem gegenwärtigen Projekt enthält dieses Verzeichnis noch keine Dateien, aber eine simple Verzeichnisstruktur:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

To create a new reference that will help you remember where your latest commit is, you can technically do something as simple as this:

Um jetzt eine neue Referenz anzulegen, die dir dabei hilft, dich zu erinnern, wo sich dein letzten Commit befindet, könntest du, technisch gesehen, folgendes tun:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Now, you can use the head reference you just created instead of the SHA-1 value in your Git commands:

Jetzt kannst du diese "head" Referenz anstelle des SHA-1 Wertes in allen möglichen Git Befehlen verwenden:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You aren’t encouraged to directly edit the reference files. Git provides a safer command to do this if you want to update a reference called `update-ref`:

Allerdings ist es nicht empfehlenswert, die Referenz Dateien direkt zu bearbeiten. Git stellt einen sichereren Befehl dafür zur Verfügung, den Befehl `git update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

That’s basically what a branch in Git is: a simple pointer or reference to the head of a line of work. To create a branch back at the second commit, you can do this:

Im Prinzip ist das alles, was einen Branch in Git ausmacht: ein simpler Zeiger oder eine Referenz auf den jeweiligen Kopf (xxx head xxx) einer Serie von Commits (xxx ??? xxx). Um einen neuen Branch anzulegen, der vom zweiten Commit aus verzweigt, kannst du folgendes tun:

	$ git update-ref refs/heads/test cac0ca

Your branch will contain only work from that commit down:

Dein Branch beginnt jetzt beim zweiten Commit:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, your Git database conceptually looks something like Figure 9-4.

Die Git Datenbank unseres Beispielrepositories ist jetzt wie folgt strukturiert:

Insert 18333fig0904.png 
Figure 9-4. Git directory objects with branch head references included.

Bild 9-4. Git Verzeichnis Objekte mit Branch Head Referenzen.

When you run commands like `git branch (branchname)`, Git basically runs that `update-ref` command to add the SHA-1 of the last commit of the branch you’re on into whatever new reference you want to create.

Wenn du Befehle wie `git branch (branchname)` verwendest, führt Git intern im wesentlichen den `update-ref` Befehl aus, um den SHA-1 Hash des letzten Commits des jeweils gegenwärtigen Branches mit dem gegebenen Namen zu referenzieren.

### The HEAD ###

### Der HEAD ###

The question now is, when you run `git branch (branchname)`, how does Git know the SHA-1 of the last commit? The answer is the HEAD file. The HEAD file is a symbolic reference to the branch you’re currently on. By symbolic reference, I mean that unlike a normal reference, it doesn’t generally contain a SHA-1 value but rather a pointer to another reference. If you look at the file, you’ll normally see something like this:

Die Frage ist jetzt: wenn du `git branch (branchname)` ausführst, woher weiß Git den SHA-1 des letzten Commits? Die Antwort ist: aus der HEAD Datei. Diese Datei ist eine symbolische Referenz auf den jeweiligen Branch, auf dem du dich gerade befindest. Mit "symbolischer Referenz" meine ich, daß sie (anders als eine "normale" Referenz) keinen SHA-1 Hash enthält, sondern statt dessen auf eine andere Referenz zeigt. Wenn Du die HEAD Datei ansiehst, findest du normalerweise etwas wie:

	$ cat .git/HEAD 
	ref: refs/heads/master

If you run `git checkout test`, Git updates the file to look like this:

Wenn du jetzt `git checkout test` ausführst, wird Git die Datei aktualisieren, so daß sie so aussieht:

	$ cat .git/HEAD 
	ref: refs/heads/test

When you run `git commit`, it creates the commit object, specifying the parent of that commit object to be whatever SHA-1 value the reference in HEAD points to.

Wenn du `git commit` ausführst, erzeugt Git das Commit Objekt und verwendet als Parent des Commit Objektes den jeweiligen Wert der Referenz auf die HEAD zeigt.

You can also manually edit this file, but again a safer command exists to do so: `symbolic-ref`. You can read the value of your HEAD via this command:

Du kannst diese Datei manuell bearbeiten, aber es Git verfügt wiederum über einen sichereren Befehl, um das zu tun: `git symbolic-ref`. Du kannst den Wert des HEAD mit Hilfe des folgenden Befehls lesen:

	$ git symbolic-ref HEAD
	refs/heads/master

You can also set the value of HEAD:

Und so kannst du ihn setzen:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

You can’t set a symbolic reference outside of the refs style:

Du kannst den Befehl allerdings nicht verwenden, um eine Referenz außerhalb von `refs` zu setzen:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Tags ###

### Tags ###

You’ve just gone over Git’s three main object types, but there is a fourth. The tag object is very much like a commit object — it contains a tagger, a date, a message, and a pointer. The main difference is that a tag object points to a commit rather than a tree. It’s like a branch reference, but it never moves — it always points to the same commit but gives it a friendlier name.

Wir haben jetzt Gits drei Haupt Objekttypen besprochen, aber es gibt noch einen vierten. Das Tag Objekt ist dem Commit Objekt sehr ähnlich: es enthält einen Tagger (xxx), ein Datum, eine Meldung und eine Referenz auf ein anderes Objekt. Der Hauptunterschied besteht darin, daß ein Tag Objekt auf einen Commit zeigt und nicht auf einen Tree. Ein Tag ist in dieser Hinsicht also ähnlich einem Branch, aber er bewegt sich nie, sondern zeigt immer auf denselben Commit und gibt ihm damit einen netteren Namen.

As discussed in Chapter 2, there are two types of tags: annotated and lightweight. You can make a lightweight tag by running something like this:

Wie wir schon in Kapitel 2 besprochen haben, gibt es zwei Typen von Tags: "annotierte" und "einfache". Du kannst einen einfachen Tag wie folgt anlegen:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

That is all a lightweight tag is — a branch that never moves. An annotated tag is more complex, however. If you create an annotated tag, Git creates a tag object and then writes a reference to point to it rather than directly to the commit. You can see this by creating an annotated tag (`-a` specifies that it’s an annotated tag):

Das ist alles, woraus ein einfacher Tag besteht: einem Branch, der sich nie bewegt. Ein annotierter Tag ist komplexer. Wenn du einen annotierten Tag anlegst, erzeugt Git ein Tag Objekt und speichert eine Referenz, die darauf zeigt, statt direkt auf den Commit zu zeigen. Du kannst das sehen, wenn du einen annotierten Tag anlegst (`-a` bewirkt, daß wir einen annotierten Tag erhalten):

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 –m 'test tag'

Here’s the object SHA-1 value it created:

Das erzeugt den folgenden Objekt SHA-1 Hash:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Now, run the `cat-file` command on that SHA-1 value:

Jetzt wendest du den `git cat-file` Befehl auf diesen SHA-1 Hash an:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Notice that the object entry points to the commit SHA-1 value that you tagged. Also notice that it doesn’t need to point to a commit; you can tag any Git object. In the Git source code, for example, the maintainer has added their GPG public key as a blob object and then tagged it. You can view the public key by running

Beachte, daß der der `object` Wert auf den commit SHA-1 zeigt, den du getaggt hast, und daß die `tags/v1.1` Referenz nicht direkt auf den Commit zeigt, sondern auf das Tag Objekt. In Git kannst du jedes beliebige Objekt taggen. Im Git Quellcode z.B. befindet sich der öffentliche GPG Schlüssel des Projektbetreibers als ein Blob Objekt, sowie ein Tag, der darauf zeigt. Auf diese Weise kannst den Schlüssel so anzeigen, indem du den folgenden Befehl im Git Quellcode Repository ausführst:

	$ git cat-file blob junio-gpg-pub

in the Git source code. The Linux kernel also has a non-commit-pointing tag object — the first tag created points to the initial tree of the import of the source code.

Der Linux Kernel hat also ein Tag Objekt, das nicht auf einen Commit zeigt - der erste Tag (xxx) zeigt auf den ursprünglichen Tree mit dem Import des Quellcodes (xxx what? xxx).

### Remotes ###

### Externe Referenzen ###

The third type of reference that you’ll see is a remote reference. If you add a remote and push to it, Git stores the value you last pushed to that remote for each branch in the `refs/remotes` directory. For instance, you can add a remote called `origin` and push your `master` branch to it:

Der dritte Referenztyp ist die externe Referenz ("remote reference"). Wenn du einen externen Server ("remote") definierst und dorthin pushst, merkt sich Git den zuletzt gepushten Commit für jeden Branch im `refs/remotes` Verzeichnis. Bespielsweise fügst du einen externen Server `origin` hinzu und pushst deinen `master` Branch dorthin:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Then, you can see what the `master` branch on the `origin` remote was the last time you communicated with the server, by checking the `refs/remotes/origin/master` file:

Dann kannst du herausfinden, in welchem Zustand sich der `master` Branch auf dem `origin` Server zuletzt befand (d.h. als du das letzte Mal mit ihm kommuniziert hast), indem du die Datei `refs/remotes/origin/master` anschaust:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Remote references differ from branches (`refs/heads` references) mainly in that they can’t be checked out. Git moves them around as bookmarks to the last known state of where those branches were on those servers.

Externe Referenzen unterscheiden sich von Branches (`refs/heads`) hauptsächlich dadurch, daß man sie nicht auschecken kann. Git verwendet sie quasi als Lesezeichen für den zuletzt bekannten Status, in dem sich die Branches auf externen Servern jeweils befanden.

## Packfiles ##

## xxx ##

Let’s go back to the objects database for your test Git repository. At this point, you have 11 objects — 4 blobs, 3 trees, 3 commits, and 1 tag:

Kommen wir noch einmal auf die Objekt Datenbank zurück, die du für dein Test Git Repository angelegt hast. Im Moment müßtest du 11 Objekte haben: 4 Blobs, 3 Trees, 3 Commits und 1 Tag:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git compresses the contents of these files with zlib, and you’re not storing much, so all these files collectively take up only 925 bytes. You’ll add some larger content to the repository to demonstrate an interesting feature of Git. Add the repo.rb file from the Grit library you worked with earlier — this is about a 12K source code file:

Git komprimiert die Inhalte dieser Dateien mit zlib und du hast nicht sonderlich viele davon, so daß die Gesamtgröße der Dateien gerade mal 925 Bytes beträgt. Wir wollen ein anderes interessantes Feature von Git demonstrieren, und dazu müssen wir eine größere Datei hinzufügen, z.B. die `repo.rb` Datei aus dem Grit Repository, das du schon verwendet hast. Diese Datei ist eine etwa 12K große Quellcode Datei:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

If you look at the resulting tree, you can see the SHA-1 value your repo.rb file got for the blob object:

Wenn du dir den resultierenden Tree anschaust, findest du den SHA-1 Hash, den die Datei `repo.rb` für das Blob Objekt erhalten hat:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

You can then use `git cat-file` to see how big that object is:

Jetzt kannst du mit `git cat-file` sehen, wie groß das Objekt ist:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Now, modify that file a little, and see what happens:

Als nächste ändern wir die Datei ein bißchen, um zu sehen, was passiert:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Check the tree created by that commit, and you see something interesting:

Wenn du jetzt den Tree anschaust, der durch den Commit angelegt wurde, findest du etwas Interessantes:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

The blob is now a different blob, which means that although you added only a single line to the end of a 400-line file, Git stored that new content as a completely new object:

Das Blob ist ein anderes, d.h. obwohl du lediglich eine einzige Zeile an das Ende einer 400 Zeilen langen Datei angehängt hast, speichert Git den Inhalt jetzt als ein ganz neues Objekt:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

You have two nearly identical 12K objects on your disk. Wouldn’t it be nice if Git could store one of them in full but then the second object only as the delta between it and the first?

Du hast jetzt zwei fast identische 12K große Objekte auf deiner Festplatte. Wäre es nicht besser, wenn Git nur das erste vollständig und das zweite lediglich als ein Delta zwischen dem ersten und dem zweiten speichern würde?

It turns out that it can. The initial format in which Git saves objects on disk is called a loose object format. However, occasionally Git packs up several of these objects into a single binary file called a packfile in order to save space and be more efficient. Git does this if you have too many loose objects around, if you run the `git gc` command manually, or if you push to a remote server. To see what happens, you can manually ask Git to pack up the objects by calling the `git gc` command:

Tatsächlich kann Git das. Das ursprüngliche Format, in dem Git Objekte in der Datenbank speichert wird als "freies Objekt Format" ("loose object format") bezeichnet. Hin und wieder packt Git allerdings eine Reihe solcher Objekte in eine einzige binäre Datei zusammen, um Platz zu sparen und effizienter zu arbeiten. Eine solche Datei wird als "packfile" bezeichnet. Git tut das immer dann, wenn zu viele freie Objekte vorhanden sind, wenn du den Befehl `git gc` manuell ausführst oder wenn du auf einen externen Server pushst. Schauen wir uns also an, was passiert, wenn wir manuell `git gc` ausführen:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

If you look in your objects directory, you’ll find that most of your objects are gone, and a new pair of files has appeared:

Wenn du das Objekt Verzeichnis anschaust, siehst du, daß die meisten Objekte jetzt fehlen und daß stattdessen zwei neue Objekte aufgetaucht sind:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

The objects that remain are the blobs that aren’t pointed to by any commit — in this case, the "what is up, doc?" example and the "test content" example blobs you created earlier. Because you never added them to any commits, they’re considered dangling and aren’t packed up in your new packfile.

Die verbleibenden Objekte sind diejenigen Blobs, die nicht von irgendeinem Commit referenziert werden - in diesem Fall sind das die "what is up, doc?" und "test content" Beispielblobs, die wir zuvor gespeichert hatten: weil wir sie nie zu irgendeinem Commit hinzugefügt haben, werden sie als "dangling" (xxx) betrachtet und nicht im Packfile zusammengepackt.

The other files are your new packfile and an index. The packfile is a single file containing the contents of all the objects that were removed from your filesystem. The index is a file that contains offsets into that packfile so you can quickly seek to a specific object. What is cool is that although the objects on disk before you ran the `gc` were collectively about 12K in size, the new packfile is only 6K. You’ve halved your disk usage by packing your objects.

Die beiden neuen Dateien sind das Packfile und ein Index. Das Packfile ist eine einzelne Datei, die die Inhalte all der Dateien umfaßt, die jetzt aus dem Dateisystem entfernt worden sind. Der Index ist eine Datei, die auf Positionen von Objekten im Packfile zeigt, so daß Git schneller nach einem bestimmten Objekt suchen kann. Obwohl diese Objekte auf der Festplatte ingesamt 12K groß waren, bevor du `git gc` ausgeführt hast, ist das Packfile jetzt nur 6K groß. D.h., du hast den Platzverbrauch dadurch um die Hälfte reduziert. Toll, oder?

How does Git do this? When Git packs objects, it looks for files that are named and sized similarly, and stores just the deltas from one version of the file to the next. You can look into the packfile and see what Git did to save space. The `git verify-pack` plumbing command allows you to see what was packed up:

Wie stellt Git das genau an? Wenn Git Objekte zusammen packt, sucht es nach Dateien, die ähnlich benannt und ähnlich groß sind, und speichert dann lediglich Deltas von einer Version zur nächsten. Du kannst ein Packfile inspizieren, um zu sehen, wie Git die Objekte gepackt hat. Der Plumbing Befehl `git verify-pack` macht das möglich:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1
	05408d195263d853f09dca71d55116663690c27c \
	  ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Here, the `9bc1d` blob, which if you remember was the first version of your repo.rb file, is referencing the `05408` blob, which was the second version of the file. The third column in the output is the size of the object in the pack, so you can see that `05408` takes up 12K of the file but that `9bc1d` only takes up 7 bytes. What is also interesting is that the second version of the file is the one that is stored intact, whereas the original version is stored as a delta — this is because you’re most likely to need faster access to the most recent version of the file.

Du erinnerst dich, daß der `9bc1d` Blob die erste Version der `repo.rb` Datei ist. Dieser Blob referenziert jetzt den `05408` Blob, der die zweite Version der Datei ist. Die dritte Spalte der Ausgabe ist die Größe des Objektes im Packfile. Wir können also sehen, daß `05408` 12K in Anspruch nimmt, `9bc1d` aber nur 7 Bytes. Das bedeutet also, daß die zweite Version diejenige ist, die vollständig, während die ursprüngliche, erste Version als Delta gespeichert wird! Der Grund dafür ist, daß du höchstwahrscheinlich einen schnelleren Zugriff auf die jeweils neuesten Dateien brauchst.

The really nice thing about this is that it can be repacked at any time. Git will occasionally repack your database automatically, always trying to save more space. You can also manually repack at any time by running `git gc` by hand.

Außerdem ist toll, daß ein Repository jederzeit neu gepackt werden kann. Git macht das gelegentlich automatisch, um weniger Platz für die Datenbank zu verbrauchen. Du kannst sie aber auch jederzeit manuell mit `git gc` packen.

## The Refspec ##

## Die Refspec ##

Throughout this book, you’ve used simple mappings from remote branches to local references; but they can be more complex.
Suppose you add a remote like this:

In diesem Buch haben wir bisher einfache Mappings von externen Branches auf lokale Referenzen verwendet. Sie können aber auch durchaus komplex sein. Nehmen wir an, du hast ein externes Repository wie folgt definiert:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

It adds a section to your `.git/config` file, specifying the name of the remote (`origin`), the URL of the remote repository, and the refspec for fetching:

Das fügt eine Sektion in deine `.git/config` Datei hinzu, die deinen lokalen Namen des externen Repositories (`origin`), dessen URL und die Refspec spezifiziert, mit der neue Daten heruntergeladen werden.

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

The format of the refspec is an optional `+`, followed by `<src>:<dst>`, where `<src>` is the pattern for references on the remote side and `<dst>` is where those references will be written locally. The `+` tells Git to update the reference even if it isn’t a fast-forward.
	
Das Format der Refspec besteht aus einem optionalen `+` gefolgt von `<quelle>:<ziel>`, wobei `<quelle>` ein Pattern für Referenzen auf der Remote Seite ist, und `<ziel>` angibt, wohin diese Referenzen lokal geschrieben werden. Das `+` weist Git an, die Referenz zu mergen, wenn sie nicht mit einem fast-forward aktualisiert werden kann.

In the default case that is automatically written by a `git remote add` command, Git fetches all the references under `refs/heads/` on the server and writes them to `refs/remotes/origin/` locally. So, if there is a `master` branch on the server, you can access the log of that branch locally via

Der Standard, der von `git remote add` automatisch eingerichtet wird, besteht darin, daß Git austomatisch alle Referenzen unter `refs/heads/` vom Server holt und sie lokal nach `refs/remotes/origin` speichert. D.h., wenn es auf dem Server einen `master` Branch gibt, kannst du auf das Log dieses Branches wie folgt zugreifen:

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

They’re all equivalent, because Git expands each of them to `refs/remotes/origin/master`.

Diese Varianten sind allesamt äquivalent, weil Git sie jeweils zu `refs/remotes/origin/master` vervollständigt.

If you want Git instead to pull down only the `master` branch each time, and not every other branch on the remote server, you can change the fetch line to

Wenn du statt dessen willst, daß Git jeweils nur den `master` Branch herunterlädt und andere Branches auf dem Server ignoriert, kannst du die `fetch` Zeile wie folgt ändern:

	fetch = +refs/heads/master:refs/remotes/origin/master

This is just the default refspec for `git fetch` for that remote. If you want to do something one time, you can specify the refspec on the command line, too. To pull the `master` branch on the remote down to `origin/mymaster` locally, you can run

Dies ist allerdings lediglich der Default Refspec Wert und du kannst ihn auf der Kommandozeile jederzeit überschreiben. Z.B. um nur `master` branch vom Server lokal als `origin/mymaster` zu speichern, kannst du folgendes ausführen:

	$ git fetch origin master:refs/remotes/origin/mymaster

You can also specify multiple refspecs. On the command line, you can pull down several branches like so:

Du kannst auch mehrere Refspecs gleichzeitig spezifizieren. Z.B.:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In this case, the  master branch pull was rejected because it wasn’t a fast-forward reference. You can override that by specifying the `+` in front of the refspec.

I diesem Fall wurde ein Pull zurückgewiesen (xxx ist das nicht nur ein fetch? xxx), weil der Branch nicht mit einem simplen fast-forward aktualisiert werden konnte. Du kannst einen Merge erzwingen, indem du der Refspec ein `+` voranstellst.

You can also specify multiple refspecs for fetching in your configuration file. If you want to always fetch the master and experiment branches, add two lines:

Du kannst außerdem natürlich auch mehrere Refspecs in deiner Konfiguration spezifizieren. Wenn du z.B. immer die `master` und `experiment` Branches holen willst, fügst du die folgenden Zeilen hinzu:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

You can’t use partial globs in the pattern, so this would be invalid:

Du kannst keine partiellen Glob Patterns verwenden, d.h. folgendes wäre ungültig:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

However, you can use namespacing to accomplish something like that. If you have a QA team that pushes a series of branches, and you want to get the master branch and any of the QA team’s branches but nothing else, you can use a config section like this:

Allerdings kannst du Namensräume verwenden, um etwas ähnliches zu erreichen. Nehmen wir an, du hast ein QA Team, das regelmäßig verschiedene Branches pusht, und du willst nun den master Branch und sämtliche Branches des QA Teams, aber keine anderen Branches haben. Dann kannst du eine Config Sektion wie die folgende verwenden:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

If you have a complex workflow process that has a QA team pushing branches, developers pushing branches, and integration teams pushing and collaborating on remote branches, you can namespace them easily this way.

In einem großen Team mit einem komplexen Workflow, in dem ein QA Team, Entwickler und ein Integrations Team jeweils eigene Branches pushen, kann man auf diese Weise Branches einfach in Namensräume einteilen.

### Pushing Refspecs ###

### Refspecs pushen ###

It’s nice that you can fetch namespaced references that way, but how does the QA team get their branches into a `qa/` namespace in the first place? You accomplish that by using refspecs to push.

Wie aber legt das QA Team die Branches im `qa/` Namensraum ab? Das geht, indem man mit einer Refspec pusht.

If the QA team wants to push their `master` branch to `qa/master` on the remote server, they can run

Wenn das QA Team seinen `master` Branch in einem externen Repository als `qa/master` speichern will, kann es das wie folgt tun:

	$ git push origin master:refs/heads/qa/master

If they want Git to do that automatically each time they run `git push origin`, they can add a `push` value to their config file:

Um Git so zu konfigurieren, daß diese Refspec jedes mal automatisch für `git push origin` verwendet wird, kann man den `push` Wert in der Config Datei setzen:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Again, this will cause a `git push origin` to push the local `master` branch to the remote `qa/master` branch by default.

Auf diese Weise wird `git push origin` den lokalen Branch `master` als `qa/master` auf dem `origin` Server speichern.

### Deleting References ###

### Referenzen löschen ###

You can also use the refspec to delete references from the remote server by running something like this:

Man kann Refspecs außerdem verwenden, um Referenzen aus einem externen Repository zu löschen:

	$ git push origin :topic

Because the refspec is `<src>:<dst>`, by leaving off the `<src>` part, this basically says to make the topic branch on the remote nothing, which deletes it. 

Das Refspec Format ist `<quelle>:<ziel>`. Wenn man den `<ziel>` Teil wegläßt, dann heißt das im obigen Beispiel, daß man den `topic` Branch auf dem `origin` Server auf "nichts" setzt, d.h. also löscht.

## Transfer Protocols ##

## Transfer Protokolle ##

Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate.

Git kann Daten zwischen zwei Repositories im wesentlichen auf zwei Arten transportieren: über HTTP und über sogenannte smarte Protokolle, die mit `file://`, `ssh://` und `git://` verwendet werden. Die folgende Sektion gibt einen kurzen Überblick über diese Protokolle und wie sie funktionieren.

### The Dumb Protocol ###

### Das dumme Protokoll ###

Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library:

Git's HTTP Transfer Protokoll wird oft auch als "dummes" Protokoll bezeichnet, weil es auf der Server Seite keinen Git-spezifischen Code benötigt. Der `fetch` Prozeß besteht aus einer Reihe von GET Requests, für die der Client Vorannahmen über das Layout des Git Repositories auf dem Server machen kann. Schauen wir uns den `http-fetch` Prozeß der `simplegit` Bibliothek an:

	$ git clone http://github.com/schacon/simplegit-progit.git

The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly:

Der Befehl lädt zunächst die `info/refs` Datei herunter. Diese Datei wird vom `update-server-info` Befehl geschrieben, den man als einen `post-receive` Hook einrichten muß, damit das HTTP Protokoll richtig funktionieren kann.

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished:

Jetzt hat man eine Liste aller Referenzen und SHAs in diesem Repository. Als nächstes schaut man die HEAD Referenz nach, um zu wissen, was ausgecheckt werden muß:

	=> GET HEAD
	ref: refs/heads/master

You need to check out the `master` branch when you’ve completed the process. 

D.h., wenn wir mit dem Prozeß fertig sind, wir müssen den `master` Branch auschecken.

At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that:

Wir können jetzt loslegen. Weil wir in der `info/refs` Datei der Commit `ca82a6` angegeben ist, fangen wir damit an, dieses Objekt herunter zu laden:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content:

Wir erhalten also ein Objekt zurück. Dieses Objekt ist im losen Format auf dem Server gespeichert, und wir haben es über einen statischen HTTP GET Request herunter geladen. Jetzt können wir es mit zlib dekomprimieren, den Header entfernen und den Inhalt des Commits durchsehen:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit:

Als nächstes brauchen wir also zwei weitere Objekte: `cfda3b`, welches der Tree der Inhalte dieses Commits ist, und `085bb3`, den Commit Parent:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

That gives you your next commit object. Grab the tree object:

Das gibt uns das nächste Commit Objekt. Versuchen wir, das Tree Objekt zu holen:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first:

Huch. Es sieht so aus als ob der Tree nicht im losen Format auf dem Server gespeichert ist, weshalb wir einen 404 Response ("Not found") erhalten. Dafür kann es verschiedene Gründe geben. Das Objekt könnte in einem anderen, alternativen Repository liegen, oder es könnte sich in einem Packfile befinden. Git sucht deshalb zunächst nach alternativen Repositories:

	=> GET objects/info/http-alternates
	(empty file)

	=> GET objects/info/http-alternates
	(leere Datei)

If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`):

Wenn wir hier eine Liste alternativer URLs erhalten, schaut Git dort nach losen Dateien und Packfiles. Auf diese Weise können Repositories, die Forks von anderen Repositories sind, mit diesen Objekte im Dateisystem teilen. In unserem Fall sind allerdings keine Alternativen vorhanden, weshalb sich das gesuchte Objekt in einem Packfile befinden muß. Um die vorhandenen Packfiles nachzuschlagen, holt Git die `objects/info/packs` Datei, die eine entsprechende Auflistung enthält (und ebenfalls mit `update-server-info` erzeugt wird)

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need:

Es gibt nur ein einziges Packfile auf dem Server, weshalb sich unser Objekt darin befinden muß. Aber wir prüfen die Index Datei, um sicher zu sein. Gäbe es mehrere Packfiles auf dem Server, könnten wir auf diese Weise herausfinden, welches Packfile das gesuchte Objekt enthält:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k binäre Daten)

Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile:

Nachdem wir jetzt den Packfile Index haben, können wir prüfen, ob sich unser Objekt darin befindet: der Index enthält eine Liste der SHA Hashes der Objekte, die sich im Packfile befinden und die jeweiligen Offsets dieser Objekte. Unser Objekt ist vorhanden, also laden wir das Packfile herunter:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k binäre Daten)

You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning.

Du hast jetzt das Tree Objekt, also kannst du jetzt damit fortfahren, über die Commits zu iterieren. Sie sind in unserem Fall allesamt in dem Packfile enthalten, das du gerade heruntergeladen hast.

The entire output of this process looks like this:

Die Ausgabe des ganzen Vorgangs sieht dann in etwa so aus:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### The Smart Protocol ###

### Das Smart Protokoll (xxx) ####

The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data.

Die HTTP Methode ist simpel, aber sie ist auch ein bißchen ineffizient. Deshalb ist es üblicher, ein smartes Protokoll für den Datentransfer zu verwenden. Diese Protokolle umfassen serverseitige Prozesse, die Wissen über Git besitzen. Sie können lokale Daten lesen und herausfinden, was auf dem Client schon vorhanden ist oder fehlt und darauf zugeschnitten Daten generieren. Es gibt zwei Sets von Prozessen für den Datentransfer: ein Paar für den Upload und ein Paar für den Download von Daten.

#### Uploading Data ####

#### Daten hochladen ####

To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side.

Um Daten an einen serverseitigen Prozeß zu schicken, verwendet Git die `send-pack` und `receive-pack` Prozesse. Der `send-pack` Prozeß läuft auf dem Client und verbindet sich mit einem `receive-pack` Prozeß auf dem Server.

For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this:

Nehmen wir z.B. an du führst `git push origin master` in deinem Projekt aus und `origin` ist als eine URL mit SSH Protokoll definiert. Git startet dann einen `send-pack` Prozeß, der eine SSH Verbindung zum Server initiiert. Dieser versucht, via SSH auf dem Server einen Befehl wie den folgenden auszuführen:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`).

Der `git-receive-pack` Befehl antwortet dann mit jeweils einer Zeile pro Referenz, die er kennt - in diesem Fall sind das lediglich der `master` Branch und dessen SHA. Die erste Zeile listet außerdem Features, die der Server beherrscht (in unserem Fall `report-status` und `delete-refs`).

Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing.

Jede Zeile beginnt mit einem 4 Byte Hexadezimalzahl Wert, der angibt, wie lang der Rest der Zeile ist. Die erste Zeile beginnt mit 005b, d.h. dezimal 91. ALso ist der Rest der Zeile 91 Zeichen lang. Die nächste Zeile fängt mit 003e an, also dezimal 62. Die letzte Zeile ist 0000, was das Ende der Liste anzeigt.

Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this:

Nachdem dein `send-pack` Prozeß jetzt den Zustand des Servers kennt, kann er als nächstes evaluieren, welche Commits lokal, aber nicht auf dem Server vorhanden sind. der `send-pack` Prozeß schickt diese Information für jede Referenz, auf die sich der `push` Befehl bezieht, an den `receive-pack` Prozeß. Wenn du beispielsweise den `master` Branch aktualisierst und einen `experiment` Branch hinzufügst, dann könnte die Antwort auf `send-pack` so aussehen:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side.

Der SHA-1 Wert, der nur aus Nullen besteht, heißt, daß dort zuvor nichts war: du fügst die `experiment` Referenz ja neu hinzu. Würdest du eine Referenz löschen, würdest du das Gegenteil sehen: nur Nullen auf der rechten Seite (xxx hu? wo ist die rechte seite? xxx)

Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication:

Pro Referenz, die du aktualisierst, schickt Git eine Zeile mit dem alten SHA, dem neuen SHA und der jeweiligen Referenz, die aktualisiert wird. Die erste Zeile listet zudem die Server Features. Als nächstes lädt der Client ein Packfile aller Objekte hoch, die der Server noch nicht kennt. Abschließend antwortet der Server mit einer Erfolgs- oder Fehlermeldung:

	000Aunpack ok

#### Downloading Data ####

#### Downloading Data ####

When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down.

Wenn du Daten herunterlädst, sind daran die `fetch-pack` und `upload-pack` Prozesse beteiligt. Der Client startet einen `fetch-pack` Prozeß, der sich mit einem `upload-pack` Prozeß auf dem Server verbindet, um auszuhandeln, welche Daten heruntergeladen werden sollen.

There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting:

Es gibt verschiedene Möglichkeiten, den `upload-pack` Prozeß auf dem Server zu starten: einerseits via SSH auf die gleiche Weise wie den `receive-pack` Prozeß. Und adnererseits über den Git Daemon, der standardmäßig auf dem Server auf dem Port 9418 läuft. Der `fetch-pack` Prozeß schickt etwa folgendes an den Daemon:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it.

Diese Zeile beginnt wiederum mit 4 Bytes, die angeben, wieviel Daten folgen. Dann kommt der auszuführende Befehl und ein Null Byte, und schließlich der Hostname des Servers und ein weiteres Null Byte. Der Git Daemon prüft, ob der Befehl ausgeführt werden kann, das Repository existiert und Schreibzugriff erlaubt. Wenn alles stimmt, startet er den `upload-pack` Prozeß und gibt den Request dorthin weiter.

If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this:

Wenn du den `fetch` Befehl über SSH verwendest, führt `fetch-pack` statt dessen etwas aus wie:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In either case, after `fetch-pack` connects, `upload-pack` sends back something like this:

In beiden Fällen wird, nachdem `fetch-pack` verbunden ist, `upload-pack` eine Antwort wie die folgende zurück schicken:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone.

Die Antwort ähnelt der, mit der `receive-pack` antwortet, aber die aufgelisteten Features sind andere. Zusätzlich wird die HEAD Referenz mitgeschickt, so daß der Client weiß, was er auschecken muß, falls es sich um einen Clone handelt.

At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs:

Der `fetch-pack` Prozeß inspiziert jetzt die vorhandenen Objekte und antwortet mit einer Liste von Objekten, wobei er das Schlüsselwort "want" für Objekte verwendet, die benötigt werden, und "have" für Objekte, die bereits vorhanden sind. Am Ende der Liste folgt das Schlüsselwort "done". Der `upload-pack` Prozeß schickt dann ein Packfile mit allen benötigten Objekten:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes.

Das ist ein sehr einfaches Beispiel. In komplexeren Fällen unterstützt der Client die `multi_ack` oder `side-band` Features. Aber obiges Beispiel verdeutlicht den grundlegenden Request-Response Zyklus der Smart Protokoll Prozesse.

## Maintenance and Data Recovery ##

## Wartung und Datenwiederherstellung ##

Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios.

Gelegentlich will man ein bißchen aufräumen - ein Repository verdichten, ein importiertes Repository entfernen (xxx) oder verloren gegangene Daten wieder herstellen. Dieses Kapitel wird sich mit einigen derartigen Szenarien befassen.

### Maintenance ###

### Wartung ###

Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old.

Git führt den Befehl `auto gc` hin und wieder automatisch aus. In den meisten Fällen tut dieser Befehl nichts. Wenn allerdings zu viele lose Objekte (d.h. Objekte, die nicht in einem Packfile gepackt sind) oder zu viele einzelne Packfiles vorhanden sind, führt Git den Befehl `git gc` aus. `gc` steht für "Garbage Collection". Dieser Befehl führt eine Reihe von Aufgaben durch: er sammelt die losen Objekte und packt sie in ein Packfile, er führt einzelne Packfiles zu einem einzigen, großen Packfile zusammen, und er entfernt Objekte, die mit keinem Commit erreichbar und einige Monate alt sind.

You can run auto gc manually as follows:

Du kannst `auto gc` wie folgt manuell ausführen:

	$ git gc --auto

Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively.

Wie schon erwähnt tut dies normalerweise gar nichts. Es müssen sich etwa 7.000 lose Objekte oder mehr als 50 Packfiles angesammelt haben, bevor Git tatsächlich die Garbage Collection startet. Du kannst diese Werte mit Hilfe der `gc.auto` bzw. `gc.autopacklimit` Konfigurationsvariablen manuell setzen.

The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags:

`gc` packt außerdem Referenzen in eine einzige Datei zusammen. Nehmen wir an, dein Repository enthält die folgenden Branches und Tags:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this:

Nachdem du `git gc` ausgeführt hast, werden diese Dateien um der Effizienz willen aus dem `refs` Verzeichnis entfernt und in eine Datei `.git/packed-refs` verschoben, die dann wie folgt aussieht:

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file.

Wenn du eine Referenz bearbeitest, läßt Git diese Datei unverändert und schreibt statt dessen eine neue Datei nach `refs/heads`. Um einen SHA für eine Referenz nachzuschlagen, schaut Git zunächst im `refs` Verzeichnis und danach erst in der `packed-refs` Datei nach, falls nötig. Wenn eine Referenz also nicht im `refs` Verzeichnis liegt, befindet sie sich wahrscheinlich in `packed-refs` Datei.

Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to.

Beachte, daß die letzte Zeile der Datei mit `^` anfängt. Das bedeutet, daß der Tag darüber ein annotierter Tag ist und diese Zeile zeigt den Commit, auf den der annotierte Tag zeigt.

### Data Recovery ###

### Daten Wiederherstellung ###

At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back?

Irgendwann wird es vielleicht mal vorkommen, daß du während der Arbeit mit Git einen Commit verlierst. Normalerweise passiert das, wenn du versehentlich einen Branch löschst, an dem du gearbeitet hattest und den du noch brauchst. Oder du führst `git reset --hard` aus und stellst fest, daß du einige der Commits noch brauchst. Nehmen wir an, du steckst in einer solchen Situation - wie kannst du deine Commits wieder herstellen?

Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point:

Das folgende Beispiel setzt zuerst den `master` Branch auf einen älteren Commit zurück und stellt die verlorenen Commits dann wieder her. Zunächst schauen wir uns den gegenwärtigen Zustand des Repositories an:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, move the `master` branch back to the middle commit:

Jetzt setzen wir den `master` Branch zurück auf den mittleren Commit.

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right?

Du hast damit die oberen beiden Commits verloren, d.h. es gibt keinen Branch mehr, von dem aus diese Commits erreichbar wären. Um sie wieder herzustellen kannst du einen neuen Branch anlegen, der auf den SHA Hash des obersten (letzten) Commits zeigt. Der Trick besteht darin, diesen letzten Commit Hash heraus zu finden. Es ist ja nicht so, daß du dir jederzeit all die Hashes merken könntest, oder?

Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`:

In der Regel ist der schnellste Weg, solche Hashes zu finden, der Befehl `git reflog`. Während du mit Git arbeitest, macht Git im Stillen fortlaufende Notizen darüber, was HEAD ist. Jedes Mal, wenn du einen Commit anlegst oder den Branch wechselst, wird das "Reflog" aktualisiert. Das Reflog wird außerdem vom Befehl `git update-ref` verwendet - ein weiterer guter Grund, nicht statt dessen einfach den SHA Wert in eine Referenz Datei zu schreiben (wie wir das in der Sektion "Git Referenzen" zuvor in diesem Kapitel besprochen haben). Du kannst also jederzeit nachschlagen, woran du jeweils gearbeitet hast, indem du den Befehl `git reflog` verwendest:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog.

Das zeigt also die beiden verloren gegangenen Commits an, die wir zuvor ausgecheckt hatten. Allerdings zeigt es auch nicht viel mehr Information. Um das Reflog in einer anderen, etwas nützlicheren Weise anzuzeigen, kannst du `git log -g` verwenden. Das gibt das Reflog im gewohnten Log Format aus:

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef):

Es sieht also so aus, als sei der untere Commit derjenige, den du verloren hast, aber noch brauchst. Du kannst ihn jetzt wieder herstellen, indem du einen neuen Branch erstellst, der auf diesen Commit zeigt. Beispielsweise kannst du einen Branch `recover-branch` anlegen, der auf den Commit `ab1afef` zeigt:

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again. 
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything:

Sehr gut. Du hast jetzt einen neuen Branch `recover-branch`, der diejenigen Commits enthält, die sich zuvor in deinem `master` Branch befanden. Damit hast du wieder Zugriff auf die beiden verloren gegangenen Commits. Als nächstes nehmen wir aber außerdem an, daß diese verlorenen Commits aus irgendeinem Grunde nicht im Reflog enthalten sind - du kannst das z.B. simulieren, indem du den Branch `recover-branch` und das Reflog löschst. Damit sind die beiden Commits jetzt von nirgendwo her mehr erreichbar:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `--full` option, it shows you all objects that aren’t pointed to by another object:

Das Reflog wird im Verzeichnis `.git/logs/` aufbewahrt, d.h. du hast nun faktisch kein Reflog mehr. Wie kann man einen Commit jetzt noch wieder herstellen? Eine Möglichkeit dazu ist der Befehl `git fsck`, der die Git Datenbank Integrität prüft. Wenn du den Befehl mit der Option `--full` ausführst, zeigt er alle Objekte an, auf die nicht von einem anderen Objekt verwiesen wird:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA.

In diesem Fall findest du den verlorenen Commit nach dem (xxx dangling xxx) Commit. Du kannst ihn dann auf die selbe Weise wieder herstellen wie zuvor, indem du einen Branch erstellst, der auf diesen Commit Hash zeigt.

### Removing Objects ###

### Objekte entfernen ###

There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there.

Git ist in vielerlei Hinsicht unschlagbar, aber es gibt auch Features, die Probleme verursachen können. Ein solches Problem kann darin bestehen, daß `git clone` die vollständige Historie eines Projektes herunter lädt, d.h. jede einzelne Version jeder einzelnen Datei. Das ist eine feine Sache, solange es sich um Quellcode handelt, den Git ist darauf optimiert, diese Art von Daten effizient zu komprimieren. Wenn allerdings irgendwann einmal eine einzelne, sehr große Datei zur Versionskontrolle hinzugefügt wurde, wird jeder Clone dieses Repositories diese Datei gezwungenermaßen herunter laden müssen - auch dann, wenn die Datei inzwischen aus dem Repository entfernt würde. Weil sie über die Historie erreichbar ist, muß die Datei vorhanden sein.

This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects.

Hierin kann ein großes Problem bestehen, wenn du Subversion oder Perforce Repositories nach Git konvertierst. Weil du in diesen Systemen nicht die gesamte Historie herunter lädst, kann diese Art von (xxx addition??? hu? xxx) einige unangenehme Konsequenzen haben. Wenn du dein Repository aus einem anderen System importiert hast oder aus irgendeinem anderen Grunde findest, daß es sehr viel größer ist als es eigentlich sein sollte, kannst du große Objekte wie folgt suchen und entfernen.

Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits.

Sei dir allerdings bewußt, daß diese Technik die Commit Historie zerstört. Sie schreibt angefangen beim ursprünglichen Tree jedes einzelne Commit Objekt neu, um die jeweilige, große Datei zu entfernen. Wenn du das direkt nach einem Import tust, d.h. bevor jemand angefangen hat, auf der Basis eines Commits zu arbeiten, ist das in Ordnung - andernfalls müssen alle Mitarbeiter ihre Arbeit auf deinen Commit rebasen.

To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history:

Um das zu demonstrieren, werden wir eine große Datei zu deinem Test Repository hinzufügen, sie dann im nächsten Commit löschen, in der Datenbank nachschlagen und sie schließlich dauerhaft aus dem Repository entfernen. Als erstes committe also eine große Datei in dein Repository:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — you didn’t want to add a huge tarball to your project. Better get rid of it:

Oha. Du wolltest keinen dermaßen großen Tarball in deinem Projekt. Am besten löschen wir es gleich wieder:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Now, `gc` your database and see how much space you’re using:

Jetzt lassen wir die Garbage Collection über die Datenbank laufen und sehen, wieviel Platz sie braucht:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

You can run the `count-objects` command to quickly see how much space you’re using:

Du kannst auch den `count-objects` Befehl laufen lassen, um einen schnellen Überblick darüber zu erhalten, wieviel Platz das Repository einnimmt:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it.

Der `size-pack` Eintrag zeigt die Größe der Packfiles in Kilobytes, d.h. dein Repository braucht 2 MB. Vor dem letzten Commit lag dieser Wert eher bei 2 KB. D.h., die Datei wurde im letzten Commit eindeutig nicht aus der History entfernt. Jedes Mal, wenn jemand künftig dieses sehr kleine Repository clont, wird er die 2 MB mit herunterladen müssen - nur weil wir versehentlich diese große Datei hinzugefügt hatten. Also versuchen wir, sie endgültig los zu werden.

First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files:

Zunächst mal müssen wir sie finden. In diesem Fall wissen wir bereits, um welche Datei es sich handelt. Aber nehmen wir an, wir wüßten es nicht. Wie würdest du herausfinden, welche Datei (oder welche Dateien) so viel Platz verbrauchen? Wenn du `git gc` laufen gelassen hast, werden sich alle Objekte in einem Packfile befinden. Du kannst dann große Objekte identifizieren, indem du einen weiteren Plumbing Befehl, nämlich `git verify-pack` ausführst und nach dem dritten Feld der Ausgabe sortierst, d.h. der Dateigröße. Du kannst sie außerdem durch den `tail` Befehl leiten, denn du bist ja nur an den wenigen größten Objekten interessiert:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `--objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name:

Das größte Objekt ist ganz klar das letzte: es ist 2 MB groß. Um herauszufinden, welche Datei das ist, kannst du den `rev-list` Befehl verwenden, den wir in Kapitel 7 schon einmal kurz verwendet haben. Wenn du die Optionen `--objects` und `rev-list` verwendest, werden alle Commit und Blob SHAs mit den jeweiligen Dateipfaden aufgelistet, die mit ihnen assoziiert sind. Auf diese Weise kannst du den Namen des Blobs finden:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file:

Du mußt diese Datei jetzt aus allen Trees entfernen, in denen er sich befindet. Du kannst leicht herausfinden, welche Commits diese Datei verändert haben:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6:

Es geht also darum, alle Commits angefangen bei `6df76` neu zu schreiben, so daß der Tarball nicht mehr in deiner Git Historie enthalten ist. Um das zu erreichen, verwendest du den Befehl `git filter-branch`, den wir schon mal in Kapitel 6 verwendet haben:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

The `--index-filter` option is similar to the `--tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm --cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `--tree-filter` if you want. The `--ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer.

Die `--index-filter` Option ist ähnlich der `--tree-filter` Option aus Kapitel 6. Allerdings übergibt man in diesem Fall nicht einen Befehl, der die Dateien verändert, die sich jeweils ausgecheckt auf der Festplatte befinden. Statt dessen verändert man jeweils die Staging Area bzw. den Index. Statt eine bestimmte Datei mit z.B: `rm file` zu entfernen, müssen wir also `git rm --cached` verwenden - denn wir wollen sie aus dem Index, nicht von der Festplatte löschen. Der Grund dafür ist einfach Geschwindigkeit: Git braucht nicht jede einzelne Revision auf die Festplatte auszuchecken, um den Filter anzuwenden. Auf diese Weise läuft der ganze Prozeß sehr viel schneller. Man kann dieselbe Aufgabe aber auch mit `--tree-filter` erledigen, wenn man will. Die Option `--ignore-match` weist Git an, nicht mit einer Fehlermeldung abzubrechen, wenn die Datei, die wir löschen wollen, nicht vorhanden ist. Außerdem teilen wir `filter-branch` mit, die Historie nur von dem Commit `6df7640` an umzuschreiben. Andernfalls würde der Befehl von ganz vorn beginnen und unnötig länger brauchen.

Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack:

Deine Historie enthält jetzt nicht länger eine Referenz auf diese Datei. Dein Reflog und ein neues Set an Referenzen, die Git unter `.git/refs/original` angelegt hat, als du `filter-branch` ausgeführt hast, tun das allerdings immer noch - also entfernen wir sie von dort und packen das Repository erneut. Bevor du packst, mußt du zuerst alles entfernen, was noch Referenzen auf das alte Objekt enthält:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Let’s see how much space you saved.

Prüfen wir also, wieviel Platz wir damit eingespart haben:

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune --expire`.

Das gepackte Repository umfaßt jetzt nur noch 7K - sehr viel besser als die vorherigen 2MB. Du kannst an dem Wert `size` erkennen, daß sich die große Datei selbst jetzt immer noch in deinen loosen Objekten befindet. Aber sie wird bei einem `git push` oder anschließenden `git clone` nicht übermittelt werden - und das war unser Ziel. Wenn du das wirklich willst, kannst du sie jetzt vollständig und endgültig mit `git prune --expire` aus deinem Repository löschen.

## Summary ##

## Zusammenfassung ##

You should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helping scripts to make your specific workflow work for you.

Du solltest jetzt ein gutes Verständnis davon haben, was Git im Hintergrund tut, und in einem gewissen Maße auch davon, wie es implementiert ist. In diesem Kapitel haben wir eine Reihe von Plumbing Befehlen besprochen, als Befehlen, die grundlegender und einfacher als die Porzellan Befehle sind, um die es im restlichen Buch ging. Dieses Verständnis sollte dir helfen, zu verstehen, warum Git tut, was es tut - und natürlich auch dabei, deine eigenen Werkzeuge und Hilfsskripte zu schreiben, um einen bestimmten Workflow für dich anzupassen.

Git as a content-addressable filesystem is a very powerful tool that you can easily use as more than just a VCS. I hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways.

Git als ein Dateisystem, das Inhalte addressieren kann, ist ein äußerst mächtiges Werkzeug, das du leicht als mehr als "nur" als  (xxx) ein VCS einsetzen kannst. Ich hoffe, du kannst dein neugewonnenes Wissen der Git Interna nutzen, um deine eigene tolle Anwendung dieser Technologie zu implementieren und dich wohler damit zu fühlen, Git auch in fortgeschrittener Weise zu benutzen.




