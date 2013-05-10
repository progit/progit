<!--# Customizing Git #-->
# Git individuell einrichten #

<!--So far, I’ve covered the basics of how Git works and how to use it, and I’ve introduced a number of tools that Git provides to help you use it easily and efficiently. In this chapter, I’ll go through some operations that you can use to make Git operate in a more customized fashion by introducing several important configuration settings and the hooks system. With these tools, it’s easy to get Git to work exactly the way you, your company, or your group needs it to.-->

Ich habe nun die grundlegende Funktionsweise und die Benutzung von Git besprochen. Weiterhin habe ich einige Werkzeuge von Git präsentiert, die dem Benutzer ein einfaches und effizientes Arbeiten ermöglichen. In diesem Kapitel werde ich nun auf einige Operationen eingehen, die Du benutzen kannst um die Funktionsweise von Git Deinen persönlichen Bedürfnissen anzupassen. Dazu führe ich einige wichtige Konfigurationseinstellungen ein, sowie verschiedene Einschubmethoden, auch Hooks genannt. Mit diesen Mitteln kann man Git leicht anpassen, so dass es genau Deinen Ansprüchen, des Unternehmens oder des Teams entspricht.

<!--## Git Configuration ##-->
## Git Konfiguration ##

<!--As you briefly saw in the Chapter 1, you can specify Git configuration settings with the `git config` command. One of the first things you did was set up your name and e-mail address:-->

Wie in Kapitel 1 schon kurz beschrieben, kann man die Konfiguration von Git mit Hilfe des Befehls `git config` steuern. Einer Deiner ersten Aktionen war es, Deinen Namen und E-Mail Adresse anzugeben:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

<!--Now you’ll learn a few of the more interesting options that you can set in this manner to customize your Git usage.-->

Jetzt wirst Du einige weitere, interessantere Optionen kennenlernen, die Du auf gleiche Art und Weise einsetzen kannst, um Git Deiner Arbeitsumgebung anzupassen.

<!--You saw some simple Git configuration details in the first chapter, but I’ll go over them again quickly here. Git uses a series of configuration files to determine non-default behavior that you may want. The first place Git looks for these values is in an `/etc/gitconfig` file, which contains values for every user on the system and all of their repositories. If you pass the option `-\-system` to `git config`, it reads and writes from this file specifically.-->

In Kapitel 1 hast Du bereits Deine ersten Erfahrungen mit einigen einfachen Einstellparametern von Git gemacht, aber ich möchte sie hier noch einmal kurz wiederholen. Git verwendet eine Reihe von Konfigurationsdateien, um Deine persönliche Einstellungen, welche von den Standard-Einstellungen abweichen, festzuhalten. Zu aller erst prüft Git die Einstellungen in der Datei `/etc/gitconfig`. Diese Datei enthält Werte, welche für alle Benutzer des Systems und deren Repositorys gelten. Wenn Du `git config` mit der Option `--system` benutzt, liest und schreibt Git von genau dieser Datei.

<!--The next place Git looks is the `~/.gitconfig` file, which is specific to each user. You can make Git read and write to this file by passing the `-\-global` option.-->

Als nächstes prüft Git die Datei `~/.gitconfig`, welche nur für den jeweiligen Benutzer gilt. Damit Git diese Datei zum Lesen und Schreiben nutzt, kannst Du die Option `--global` angeben.

<!--Finally, Git looks for configuration values in the config file in the Git directory (`.git/config`) of whatever repository you’re currently using. These values are specific to that single repository. Each level overwrites values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`, for instance. You can also set these values by manually editing the file and inserting the correct syntax, but it’s generally easier to run the `git config` command.-->

Als Letztes sucht Git in der Konfigurationsdatei im Git Verzeichnis des gerade verwendeten Repositorys (`.git/config`). Die dort enthaltenen Parameter sind nur für dieses einzelne Repository gültig. Jede der erwähnten Ebenen überschreibt die vorhergehende. Das bedeutet, dass z.B. die Einstellungen in der Datei `/etc/gitconfig` von den Einstellungen in der Datei `.git/config` überschrieben werden. Du kannst alle Parameter auch durch manuelles Editieren der jeweiligen Datei setzen bzw. verändern (vorausgesetzt Du verwendest die richtige Syntax). In der Regel ist es aber einfacher den Befehl `git config` zu verwenden.

<!--### Basic Client Configuration ###-->
### Grundlegende Client Konfiguration ###

<!--The configuration options recognized by Git fall into two categories: client side and server side. The majority of the options are client side—configuring your personal working preferences. Although tons of options are available, I’ll only cover the few that either are commonly used or can significantly affect your workflow. Many options are useful only in edge cases that I won’t go over here. If you want to see a list of all the options your version of Git recognizes, you can run-->

Einstellparameter in Git lassen sich in zwei Kategorien aufteilen: Parameter für die Client-Konfiguration und für die Server-Konfiguration. Der Großteil der Einstellungen bezieht sich auf den Client - zur Konfiguration Deines persönlichen Arbeitsablaufs. Auch wenn es eine große Anzahl an Einstellmöglichkeiten gibt, werde ich nur die wenigen besprechen, die sehr gebräuchlich sind oder Deine Arbeitsweise bedeutend beeinflussen können. Viele Optionen sind nur für Spezialfälle interessant, auf die ich hier aber nicht weiter eingehen möchte. Falls Du eine Liste aller Optionen haben willst, kannst Du folgenden Befehl ausführen:

	$ git config --help

<!--The manual page for `git config` lists all the available options in quite a bit of detail.-->

Die Hilfeseite zu `git config` listet alle verfügbaren Optionen sehr detailliert auf.

<!--#### core.editor ####-->
#### core.editor ####

<!--By default, Git uses whatever you’ve set as your default text editor or else falls back to the Vi editor to create and edit your commit and tag messages. To change that default to something else, you can use the `core.editor` setting:-->

In der Grundeinstellung benutzt Git Deinen Standard Texteditor oder greift auf den Vi Editor zurück, um Deine Commit und Tag Nachrichten zu erstellen und zu bearbeiten. Um einen andern Editor als Standard einzurichten kannst Du die Option `core.editor` nutzen:

	$ git config --global core.editor emacs

<!--Now, no matter what is set as your default shell editor variable, Git will fire up Emacs to edit messages.-->

Ab jetzt wird Git immer Emacs starten um Nachrichten zu editieren, unabhängig davon welcher Standard Shell-Editor gesetzt ist.

<!--#### commit.template ####-->
#### commit.template ####

<!--If you set this to the path of a file on your system, Git will use that file as the default message when you commit. For instance, suppose you create a template file at `$HOME/.gitmessage.txt` that looks like this:-->

Wenn Du diese Einstellung auf einen Pfad zu einer Datei auf Deinem System einstellst, wird Git den Inhalt dieser Datei als Standard Commit Nachricht verwenden. Nehmen wir zum Beispiel an, Du erstellst eine Vorlage unter dem Namen `$HOME/.gitmessage.txt`, die den folgenden Inhalt hat:

	subject line

	what happened

	[ticket: X]

<!--To tell Git to use it as the default message that appears in your editor when you run `git commit`, set the `commit.template` configuration value:-->

Damit Git diese Datei als Standard Nachricht benutzt, die in Deinem Editor erscheint, wenn Du `git commit` aufrufst, richte die Option `commit.template` ein:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

<!--Then, your editor will open to something like this for your placeholder commit message when you commit:-->

Wenn Du dann das nächste Mal einen Commit durchführst, wird Dein Editor mit etwa der folgenden Nachricht starten:

	subject line

	what happened

	[ticket: X]
	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	# modified:   lib/test.rb
	#
	~
	~
	".git/COMMIT_EDITMSG" 14L, 297C

<!--If you have a commit-message policy in place, then putting a template for that policy on your system and configuring Git to use it by default can help increase the chance of that policy being followed regularly.-->

Falls eine Richtlinie für Commit Nachrichten existiert, solltest Du Git so konfigurieren, dass eine Vorlage davon bei einem Commit geladen wird. Dies erhöht die Chance, dass diese Richtlinie auch eingehalten wird.

<!--#### core.pager ####-->
#### core.pager ####

<!--The core.pager setting determines what pager is used when Git pages output such as `log` and `diff`. You can set it to `more` or to your favorite pager (by default, it’s `less`), or you can turn it off by setting it to a blank string:-->

Die Einstellung `core.pager` legt fest, welche Anwendung zur Seitenanzeige benutzt wird, wenn Git Text ausgibt, wie zum Beispiel bei `log` und `diff`. Du kannst es auch auf `more` oder eine andere Seitenanzeige Deiner Wahl (der Standard ist `less`) einstellen, oder Du kannst es mittels eines leeren Strings ganz ausschalten:

	$ git config --global core.pager ''

<!--If you run that, Git will page the entire output of all commands, no matter how long it is.-->

Wenn Du dies ausführst, wird Git immer die komplette Ausgabe aller Befehle anzeigen, egal wie lange sie ist. 

<!--user.signingkey ####-->
#### user.signingkey ####

<!--If you’re making signed annotated tags (as discussed in Chapter 2), setting your GPG signing key as a configuration setting makes things easier. Set your key ID like so:-->

Falls Du signierte kommentierte Tags erstellst (wie in Kapitel 2 beschrieben), so macht es die Arbeit leichter, wenn Du Deinen GPG Signierschlüssel in Git festlegst. Du kannst Deine Schlüssel ID wie folgt festlegen:

	$ git config --global user.signingkey <gpg-key-id>

<!--Now, you can sign tags without having to specify your key every time with the `git tag` command:-->

Beim Signieren von Tags mit Hilfe von `git tag` musst Du Deinen Schlüssel jetzt nicht mehr angeben. Es reicht folgendes auszuführen:

	$ git tag -s <tag-name>

<!--#### core.excludesfile ####-->
#### core.excludesfile ####

<!--You can put patterns in your project’s `.gitignore` file to have Git not see them as untracked files or try to stage them when you run `git add` on them, as discussed in Chapter 2. However, if you want another file outside of your project to hold those values or have extra values, you can tell Git where that file is with the `core.excludesfile` setting. Simply set it to the path of a file that has content similar to what a `.gitignore` file would have.-->

In Kapitel 2 habe ich bereits beschrieben, wie Du mit Hilfe der projektspezifischen `.gitignore` Datei Git dazu bringst, bestimmte Dateien nicht weiter zu verfolgen beziehungsweise zu stagen, wenn Du den Befehl `git add` verwendest. Falls Du jedoch eine weitere Datei außerhalb Deines Projekts verwenden willst, die diese Werte enthält oder zusätzliche Muster definiert, dann kannst Du Git mit der Option `core.excludesfile` mitteilen, wo sich diese Datei befindet. Trage hier einfach den Pfad zu einer Datei ein, welche entsprechend einer `.gitignore` Datei aufgebaut ist.

<!--#### help.autocorrect ####-->
#### help.autocorrect ####

<!--This option is available only in Git 1.6.1 and later. If you mistype a command in Git 1.6, it shows you something like this:-->

Diese Option ist in Git ab Version 1.6.1 verfügbar. Wenn Du in Git 1.6 einen Befehl falsch schreibst, bekommst Du eine Meldung wie diese:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

<!--If you set `help.autocorrect` to 1, Git will automatically run the command if it has only one match under this scenario.-->

Wenn Du die Option `help.autocorrect` auf 1 setzt, wird Git automatisch den entsprechenden Befehl ausführen, falls es in dieser Situation die einzige passende Alternative ist.
 
<!--### Colors in Git ###-->
### Farben in Git ###

<!--Git can color its output to your terminal, which can help you visually parse the output quickly and easily. A number of options can help you set the coloring to your preference.-->

Git kann für die Textanzeige im Terminal Farben benutzen, die Dir helfen können, die Ausgabe schnell und einfach zu begreifen. Mit einer Vielzahl von Optionen kannst Du die Farben an Deine Vorlieben anpassen.

<!--#### color.ui ####-->
#### color.ui ####

<!--Git automatically colors most of its output if you ask it to. You can get very specific about what you want colored and how; but to turn on all the default terminal coloring, set `color.ui` to true:-->

Wenn Du Git entsprechend konfigurierst, wird es den Großteil der Ausgaben automatisch farblich darstellen. Du kannst sehr detailliert einstellen, wie und welche Farben verwendet werden sollen, aber um die Standard-Terminalfarben zu aktivieren musst Du `color.ui` auf 'true' setzen:

	$ git config --global color.ui true

<!--When that value is set, Git colors its output if the output goes to a terminal. Other possible settings are false, which never colors the output, and always, which sets colors all the time, even if you’re redirecting Git commands to a file or piping them to another command. This setting was added in Git version 1.5.5; if you have an older version, you’ll have to specify all the color settings individually.-->

Wenn dieser Wert gesetzt wurde, benutzt Git für seine Ausgaben Farben, sofern diese zu einem Terminal geleitet werden. Weitere mögliche Einstellungen sind 'false', wodurch alle Farben deaktiviert werden, sowie 'always', wodurch Farben immer aktiviert sind, selbst wenn Du Git Befehle in eine Datei oder über eine Pipe zu einem anderen Befehl umleitest. Diese Option wurde in Git 1.5.5 hinzugefügt. Solltest Du eine ältere Git Version benutzen, so musst Du alle Farbeinstellungen einzeln vornehmen.

<!--You’ll rarely want `color.ui = always`. In most scenarios, if you want color codes in your redirected output, you can instead pass a `-\-color` flag to the Git command to force it to use color codes. The `color.ui = true` setting is almost always what you’ll want to use.-->

Du wirst selten die Einstellung `color.ui = always` benötigen. In den meisten Fällen in denen Du in Deiner umgeleiteten Ausgabe Farben haben willst, kannst Du stattdessen die Option `--color` in der Kommandozeile benutzen. Damit weist Du Git an, die Farbkodierung für die Ausgabe zu verwenden. Die Einstellung `color.ui = true` sollte aber in den meisten Fällen Deinen Anforderungen genügen.

<!--#### `color.*` ####-->
#### `color.*` ####

<!--If you want to be more specific about which commands are colored and how, or you have an older version, Git provides verb-specific coloring settings. Each of these can be set to `true`, `false`, or `always`:-->

Falls Du im Detail einstellen willst, welche Befehle wie gefärbt werden, oder wenn Du eine ältere Version benutzt, dann stellt Git Verb-spezifische Farbeinstellungen zur Verfügung. Jede dieser Optionen kann auf `true`, `false`, oder `always` eingestellt werden:

	color.branch
	color.diff
	color.interactive
	color.status

<!--In addition, each of these has subsettings you can use to set specific colors for parts of the output, if you want to override each color. For example, to set the meta information in your diff output to blue foreground, black background, and bold text, you can run-->

Zusätzlich hat jede dieser Einstellungen Unteroptionen, die Du benutzen kannst, um die Farbe für einzelne Teile der Ausgabe festzulegen. Um zum Beispiel die Meta Informationen in Deiner Diff Ausgabe mit blauem, fettem Text auf schwarzem Hintergrund darzustellen, kannst Du folgenden Befehl verwenden:

	$ git config --global color.diff.meta "blue black bold"

<!--You can set the color to any of the following values: normal, black, red, green, yellow, blue, magenta, cyan, or white. If you want an attribute like bold in the previous example, you can choose from bold, dim, ul, blink, and reverse.-->

Du kannst als Farben jeden der folgenden Werte verwenden: `normal`, `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, oder `white`. Falls Du ein Attribut wie z.B. die Fettschrift aus dem vorigen Beispiel verwenden willst, stehen dir folgende Werte zur Auswahl: `bold`, `dim`, `ul`, `blink`, und `reverse`.

<!--See the `git config` manpage for all the subsettings you can configure, if you want to do that.-->

Auf der Manpage zu `git config` findest Du eine Liste aller Unteroptionen, die Du konfigurieren kannst.

<!--### External Merge and Diff Tools ###-->
### Externe Merge- und Diff-Werzeuge ###

<!--Although Git has an internal implementation of diff, which is what you’ve been using, you can set up an external tool instead. You can also set up a graphical merge conflict-resolution tool instead of having to resolve conflicts manually. I’ll demonstrate setting up the Perforce Visual Merge Tool (P4Merge) to do your diffs and merge resolutions, because it’s a nice graphical tool and it’s free.-->

Bisher hast Du die in Git integrierte Implementierung von diff benutzt, aber Du kannst stattdessen auch eine externe Anwendung verwenden. Du kannst ebenso ein grafisches Merge-Werkzeug zur Auflösung von Konflikten einsetzen, statt diese manuell zu lösen. Ich werde demonstrieren, wie man das grafische Merge-Werkzeug von Perforce (P4Merge) konfiguriert, um Diffs und Merges zu bearbeiten. Ich habe P4Merge gewählt, da es ein freies und gutes grafisches Werkzeug ist.

<!--If you want to try this out, P4Merge works on all major platforms, so you should be able to do so. I’ll use path names in the examples that work on Mac and Linux systems; for Windows, you’ll have to change `/usr/local/bin` to an executable path in your environment.-->

Da P4Merge für die üblichen Plattformen verfügbar ist, sollte es kein Problem sein, es einmal auszuprobieren. In den Beispielen werde ich Pfadnamen nutzen, die auf Mac- und Linux-System funktionieren. Die Windows Benutzer müssen `/usr/local/bin` durch einen Pfad ersetzen, der in der Umgebungsvariable `PATH` gelistet ist.

<!--You can download P4Merge here:-->

Du kannst P4Merge hier herunterladen:

	http://www.perforce.com/perforce/downloads/component.html

<!--To begin, you’ll set up external wrapper scripts to run your commands. I’ll use the Mac path for the executable; in other systems, it will be where your `p4merge` binary is installed. Set up a merge wrapper script named `extMerge` that calls your binary with all the arguments provided:-->

Als erstes solltest Du einige Wrapper Skripte erstellen um Deine Befehle auszuführen. Ich verwende hier die Pfade, die für einen Mac gelten. Auf anderen Systemen muss der Pfad zur ausführbaren Datei von P4Merge entsprechend angepasst werden. Mit den folgenden Befehlen erzeugen wir ein Skript mit dem Namen `extMerge`, welches die Anwendung mit allen angegebenen Argumenten aufruft:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

<!--The diff wrapper checks to make sure seven arguments are provided and passes two of them to your merge script. By default, Git passes the following arguments to the diff program:-->

Das Wrapper Skript für den Diff Befehl stellt sicher, dass es mit sieben Parametern aufgerufen wird und leitet zwei von diesen an das Merge Skript weiter. Standardmäßig übergibt Git die folgenden Argumente an das Diff-Werkzeug:

	path old-file old-hex old-mode new-file new-hex new-mode

<!--Because you only want the `old-file` and `new-file` arguments, you use the wrapper script to pass the ones you need.-->

Da nur die Parameter `old-file` und `new-file` benötigt werden, verwenden wir das Wrapper Skript um nur die notwendigen Parameter weiterzugeben.

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

<!--You also need to make sure these tools are executable:-->

Außerdem muss sichergestellt werden, dass die Skripte ausführbar sind::

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

<!--Now you can set up your config file to use your custom merge resolution and diff tools. This takes a number of custom settings: `merge.tool` to tell Git what strategy to use, `mergetool.*.cmd` to specify how to run the command, `mergetool.trustExitCode` to tell Git if the exit code of that program indicates a successful merge resolution or not, and `diff.external` to tell Git what command to run for diffs. So, you can either run four config commands-->

Jetzt kannst Du Git so konfigurieren, dass es Deine persönlichen Merge- und Diff-Werkzeuge benutzt. Dazu sind einige weitere Einstellungen nötig: `merge.tool`, um die von Git verwendete Merge Strategie festzulegen, `mergetool.*.cmd`, um festzulegen, wie der Befehl auszuführen ist, `mergetool.trustExitCode`, damit Git weiß, ob der Exit-Code des Programms eine erfolgreiche Merge Auflösung anzeigt oder nicht, und `diff.external`, um einzustellen welches Diff Kommando Git benutzen soll. Du kannst also entweder die vier folgenden Befehle ausführen

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

<!--or you can edit your `~/.gitconfig` file to add these lines:-->

oder Du bearbeitest Deine `~/.gitconfig` Datei und fügst dort folgende Zeilen hinzu:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

<!--After all this is set, if you run diff commands such as this:-->

Nach Setzen dieser Einstellungen und beim Ausführen eines Diff Befehls wie den folgenden: 

	$ git diff 32d1776b1^ 32d1776b1

<!--Instead of getting the diff output on the command line, Git fires up P4Merge, which looks something like Figure 7-1.-->

wird Git P4Merge starten, anstatt den Vergleich in der Kommandozeile auszugeben. Abbildung 7-1 zeigt hierzu ein Beispiel.

<!--Figure 7-1. P4Merge.-->

Insert 18333fig0701.png
Abbildung 7-1. P4Merge

<!--If you try to merge two branches and subsequently have merge conflicts, you can run the command `git mergetool`; it starts P4Merge to let you resolve the conflicts through that GUI tool.-->

Wenn Du versuchst zwei Branches zu mergen und dabei Merge Konflikte auftreten, kannst Du den Befehl `git mergetool` ausführen. Das Kommando startet P4Merge und erlaubt es Dir, die Konflikte mit Hilfe des grafischen Werkzeugs aufzulösen.

<!--The nice thing about this wrapper setup is that you can change your diff and merge tools easily. For example, to change your `extDiff` and `extMerge` tools to run the KDiff3 tool instead, all you have to do is edit your `extMerge` file:-->

Das Tolle an dem Wrapper Ansatz ist, dass Du Deine Diff- und Merge-Werkzeuge sehr leicht wechseln kannst. Wenn Du zum Beispiel für `extDiff` und `extMerge` statt P4Merge, KDiff3 verwenden willst, musst Du lediglich Dein Wrapper Skript `extMerge` anpassen:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

<!--Now, Git will use the KDiff3 tool for diff viewing and merge conflict resolution.-->

Ab jetzt verwendet Git KDiff3 zur Anzeige von Diffs und zur Auflösung von Merge Konflikten.

<!--Git comes preset to use a number of other merge-resolution tools without your having to set up the cmd configuration. You can set your merge tool to kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, or gvimdiff. If you’re not interested in using KDiff3 for diff but rather want to use it just for merge resolution, and the kdiff3 command is in your path, then you can run-->

Git wird bereits mit Standard-Einstellungen für verschiedene Merge-Auflösungswerkzeuge ausgeliefert, so dass Du diese nicht extra konfigurieren musst. Als Merge-Werkzeug kann Du kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff oder gvimdiff einstellen. Wenn Du KDiff3 nur zum Auflösen von Konflikten und nicht für einen Diff verwenden willst, kannst Du den folgenden Befehl ausführen (vorausgesetzt KDiff3 befindet sich im Standard-Pfad):

	$ git config --global merge.tool kdiff3

<!--If you run this instead of setting up the `extMerge` and `extDiff` files, Git will use KDiff3 for merge resolution and the normal Git diff tool for diffs.-->

Wenn Du diesen Befehl ausführst, anstatt die `extMerge` und `extDiff` Skripte zu erstellen, dann wird Git KDiff3 zum Auflösen von Merge Konflikten verwenden. Für einen Vergleich verwendet Git weiterhin das integrierte Diff-Werkzeug.

<!--### Formatting and Whitespace ###-->
### Formatierungen und Leerzeichen ###

<!--Formatting and whitespace issues are some of the more frustrating and subtle problems that many developers encounter when collaborating, especially cross-platform. It’s very easy for patches or other collaborated work to introduce subtle whitespace changes because editors silently introduce them or Windows programmers add carriage returns at the end of lines they touch in cross-platform projects. Git has a few configuration options to help with these issues.-->

Bei der Zusammenarbeit mit anderen Entwicklern sind Probleme mit Formatierungen und Leerzeichen einige der frustrierendsten und heikelsten Themen denen viele Entwickler begegnen, vor allem bei plattformübergreifenden Projekten. Es kann sehr leicht passieren, dass durch Patches oder andere gemeinsame Arbeit fast unmerklich Leerzeichen Änderungen eingeführt werden, z.B. weil ein Editor sie stillschweigend einfügt. Beim Programmieren unter Windows können durch Änderungen an einer Zeile auch leicht Wagenrückläufe (CR) am Zeilenende eingefügt werden (relevant bei plattformübergreifenden Projekten). Git kann mit ein paar Einstellungen hierbei unterstützend eingreifen.

<!--#### core.autocrlf ####-->
#### core.autocrlf ####

<!--If you’re programming on Windows or using another system but working with people who are programming on Windows, you’ll probably run into line-ending issues at some point. This is because Windows uses both a carriage-return character and a linefeed character for newlines in its files, whereas Mac and Linux systems use only the linefeed character. This is a subtle but incredibly annoying fact of cross-platform work.-->

Falls Du unter Windows programmierst oder ein anderes System benutzt und mit anderen zusammenarbeitest, die unter Windows programmieren, wirst Du sehr wahrscheinlich irgendwann Problemen mit Zeilenenden begegnen. Dies liegt daran, dass Windows sowohl ein CR Zeichen, als auch ein LF Zeichen zum Signalisieren einer neuen Zeile in Dateien verwendet. Mac und Linux nutzen stattdessen nur ein LF Zeichen (Mac OS bis Version 9 verwendet ein einzelnes CR Zeichen). Dies ist eine kleine, aber extrem störende Tatsache beim Arbeiten über Plattformgrenzen hinweg.

<!--Git can handle this by auto-converting CRLF line endings into LF when you commit, and vice versa when it checks out code onto your filesystem. You can turn on this functionality with the `core.autocrlf` setting. If you’re on a Windows machine, set it to `true` — this converts LF endings into CRLF when you check out code:-->

Git kann dies vermeiden, indem es CRLF am Zeilenende automatisch zu LF konvertiert, wenn Du ein Commit durchführst, und umgekehrt wenn es Code in Dein lokales Dateisystem auscheckt. Du kannst diese Funktionalität mittels der Option `core.autocrlf` aktivieren. Falls Du auf einem Windows System arbeitest, setze sie auf `true` — dies konvertiert LF zu CRLF, wenn Du Code auscheckst:

	$ git config --global core.autocrlf true

<!--If you’re on a Linux or Mac system that uses LF line endings, then you don’t want Git to automatically convert them when you check out files; however, if a file with CRLF endings accidentally gets introduced, then you may want Git to fix it. You can tell Git to convert CRLF to LF on commit but not the other way around by setting `core.autocrlf` to input:-->

Falls Du auf einem Linux oder Mac System arbeitest, welches LF Zeilenenden verwendet, dann soll Git keine Datei automatisch konvertieren, wenn sie ausgecheckt wird. Wenn allerdings versehentlich eine Datei mit CRLF in das Repository eingeführt wurde, dann möchtest Du vielleicht, dass Git dies automatisch für Dich repariert. Wenn Du den Parameter `core.autocrlf` auf input setzt, wird Git bei einem Commit automatisch CRLF in LF umwandeln. Allerdings nicht in die andere Richtung bei einem Checkout:

	$ git config --global core.autocrlf input

<!--This setup should leave you with CRLF endings in Windows checkouts but LF endings on Mac and Linux systems and in the repository.-->

Mit dieser Einstellung solltest Du CRLF Zeilenenden in unter Windows ausgecheckten Dateien haben und LF Zeilenenden auf Mac und Linux Sytemen und im Repository.

<!--If you’re a Windows programmer doing a Windows-only project, then you can turn off this functionality, recording the carriage returns in the repository by setting the config value to `false`:-->

Falls Du ein Windows Programmierer bist und an einem Projekt arbeitest, welches nur unter Windows entwickelt wird, dann kannst Du diese Funktionalität auch deaktivieren. In diesem Fall werden Zeilenenden mit CRLF im Repository gespeichert. Dazu setzt Du die Option auf `false`:

	$ git config --global core.autocrlf false

<!--#### core.whitespace ####-->
#### core.whitespace ####

<!--Git comes preset to detect and fix some whitespace issues. It can look for four primary whitespace issues — two are enabled by default and can be turned off, and two aren’t enabled by default but can be activated.-->

Git ist so voreingestellt, dass es einige Leerzeichen Probleme erkennen und beheben kann. Es kann nach vier grundlegenden Problemen mit Leerzeichen suchen — Zwei davon sind standardmässig aktiviert und können deaktiviert werden. Die anderen beiden sind inaktiv, können aber aktiviert werden.

<!--The two that are turned on by default are `trailing-space`, which looks for spaces at the end of a line, and `space-before-tab`, which looks for spaces before tabs at the beginning of a line.-->

Die zwei standardmäßig aktiven Optionen sind `trailing-space`, das nach Leerzeichen am Ende einer Zeile sucht, und `space-before-tab`, das nach Leerzeichen vor Tabulatoren am Anfang einer Zeile sucht.

<!--The two that are disabled by default but can be turned on are `indent-with-non-tab`, which looks for lines that begin with eight or more spaces instead of tabs, and `cr-at-eol`, which tells Git that carriage returns at the end of lines are OK.-->

Die beiden aktivierbaren, aber normalerweise deaktivierten Optionen sind `indent-with-non-tab`, welches nach Zeilen sucht, die mit acht oder mehr Leerzeichen anstelle von Tabulatoren beginnen, und `cr-at-eol`, wodurch Git angewiesen wird, dass CR Zeichen am Zeilenende in Ordnung sind.

<!--You can tell Git which of these you want enabled by setting `core.whitespace` to the values you want on or off, separated by commas. You can disable settings by either leaving them out of the setting string or prepending a `-` in front of the value. For example, if you want all but `cr-at-eol` to be set, you can do this:-->

Du kannst Git mitteilen, welche dieser Optionen es aktivieren soll, indem Du `core.whitespace` auf die Werte setzt, die Du an- oder abgeschaltet haben möchtest. Die jeweiligen Werte werden mit einem Komma getrennt. Du kannst Optionen deaktivieren, indem Du sie entweder aus der Parameterliste entfernst, oder ihnen ein `-` Zeichen voranstellst. Wenn Du zum Beispiel alle Optionen außer `cr-at-eol` aktivieren willst, kannst Du folgenden Befehl ausführen:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

<!--Git will detect these issues when you run a `git diff` command and try to color them so you can possibly fix them before you commit. It will also use these values to help you when you apply patches with `git apply`. When you’re applying patches, you can ask Git to warn you if it’s applying patches with the specified whitespace issues:-->

Git wird die möglichen Problemstellen erkennen, wenn Du den `git diff` Befehl ausführst, und es wird versuchen, sie farblich hervorzuheben, damit Du sie vor einem Commit beheben kannst. Git wird diese Einstellungen auch benutzen, um Dir zu helfen, wenn Du mit `git apply` Patches anwendest. Wenn Du Patches anwendest, kannst Du Git anweisen eine Warnung auszugeben, falls es beim Patchen die spezifizierten Leerzeichenprobleme erkennt:

	$ git apply --whitespace=warn <patch>

<!--Or you can have Git try to automatically fix the issue before applying the patch:-->

Oder Du kannst Git versuchen lassen, diese Probleme automatisch zu beheben, bevor es den Patch anwendet:

	$ git apply --whitespace=fix <patch>

<!--These options apply to the `git rebase` command as well. If you’ve committed whitespace issues but haven’t yet pushed upstream, you can run a `rebase` with the `-\-whitespace=fix` option to have Git automatically fix whitespace issues as it’s rewriting the patches.-->

Diese Optionen gelten auch für den Rebase Befehl. Falls Du einen Commit gemacht hast, der problematische Leerzeichen enthält, aber Du die Änderungen noch nicht auf den Server gepusht hast, kannst Du ein `rebase` mit dem Parameter `--whitespace=fix` ausführen. Damit behebt Git automatisch die Leerzeichenfehler während des Rebase-Vorgangs.

<!--### Server Configuration ###-->
### Server Konfiguration ###

<!--Not nearly as many configuration options are available for the server side of Git, but there are a few interesting ones you may want to take note of.-->

Es gibt nicht annähernd so viele Konfigurationsmöglichkeiten für die Serverfunktionalitäten von Git, aber es gibt dabei einige interessante Parameter, die Du dir anschauen solltest.

<!--#### receive.fsckObjects ####-->
#### receive.fsckObjects ####

<!--By default, Git doesn’t check for consistency all the objects it receives during a push. Although Git can check to make sure each object still matches its SHA-1 checksum and points to valid objects, it doesn’t do that by default on every push. This is a relatively expensive operation and may add a lot of time to each push, depending on the size of the repository or the push. If you want Git to check object consistency on every push, you can force it to do so by setting `receive.fsckObjects` to true:-->

Die Objekte, die Git durch einen Push empfängt, werden von Haus aus nicht auf Konsistenz geprüft. Auch wenn Git sicherstellen kann, dass jedes Objekt mit dessen SHA-1 Checksumme übereinstimmt und auf gültige Objekte verweist, so wird dies standardmäßig nicht bei jedem Push durchgeführt. Das ist eine aufwändige Operation und kann abhängig von der Größe des Repositorys oder dem Push eine Menge Zeit kosten. Wenn Du die Objektkonsistenz bei jedem Push durch Git prüfen lassen willst, so kannst Du das erzwingen, indem Du `receive.fsckObjects` auf 'true' setzt:

	$ git config --system receive.fsckObjects true

<!--Now, Git will check the integrity of your repository before each push is accepted to make sure faulty clients aren’t introducing corrupt data.-->

Ab jetzt prüft Git die Integrität des Repositorys bevor der Push akzeptiert wird. Damit ist sichergestellt, dass kein Client korrupte Daten einspeist.

<!--#### receive.denyNonFastForwards ####-->
#### receive.denyNonFastForwards ####

<!--If you rebase commits that you’ve already pushed and then try to push again, or otherwise try to push a commit to a remote branch that doesn’t contain the commit that the remote branch currently points to, you’ll be denied. This is generally good policy; but in the case of the rebase, you may determine that you know what you’re doing and can force-update the remote branch with a `-f` flag to your push command.-->

Falls Du auf Commits, die bereits gepusht sind, einen Rebase anwendest, und diese dann versuchst zu pushen, wird Git dies mit einer Fehlermeldung zurückweisen. Wenn der Remote Branch auf einen Commit zeigt, welcher nicht in Deinem lokalen Branch enthalten ist und Du versuchst diesen Branch zu pushen, wird sich Git genau gleich verhalten und den Push verweigern. Das ist in den meisten Fällen eine gute Richtlinie, aber im Falle eines Rebase ist eventuell ein anderes Verhalten gewünscht (vorausgesetzt Du weißt was Du tust). Dann kannst Du den Push auch erzwingen, indem Du den Parameter `-f` zu dem Push Kommando hinzufügst.

<!--To disable the ability to force-update remote branches to non-fast-forward references, set `receive.denyNonFastForwards`:-->

Aktualisierungen auf dem Remote Branch, welche nicht einem Fast-Forward entsprechen können durch Setzen des Parameters `receive.denyNonFastForward` auf den Wert 'true' deaktiviert werden:

	$ git config --system receive.denyNonFastForwards true

<!--The other way you can do this is via server-side receive hooks, which I’ll cover in a bit. That approach lets you do more complex things like deny non-fast-forwards to a certain subset of users.-->

Eine andere Möglichkeit ist die Einrichtung von serverseitigen Hooks, die ich etwas später noch beschreiben werde. Dieser Ansatz erlaubt noch komplexere Szenarien. Man kann z.B. die Pushes, welche nicht einem Fast-Forward entsprechen nur für bestimmte Benutzergruppen verweigern.

<!--#### receive.denyDeletes ####-->
#### receive.denyDeletes ####

<!--One of the workarounds to the `denyNonFastForwards` policy is for the user to delete the branch and then push it back up with the new reference. In newer versions of Git (beginning with version 1.6.1), you can set `receive.denyDeletes` to true:-->

Es ist möglich die Option `denyNonFastForwards` zu umgehen, indem man den Remote Branch zuerst löscht und dann mit einer neuen Referenz pusht. In neueren Versionen von Git (ab Version 1.6.1) kann man den Parameter  `receive.denyDeletes` auf 'true' setzen:

	$ git config --system receive.denyDeletes true

<!--This denies branch and tag deletion over a push across the board — no user can do it. To remove remote branches, you must remove the ref files from the server manually. There are also more interesting ways to do this on a per-user basis via ACLs, as you’ll learn at the end of this chapter.-->

Dies verbietet grundsätzlich jedem Benutzer das Löschen eines Branches oder Tags. Um einen Remote Branch zu löschen müssen die ref Dateien manuell vom Server entfernt werden. Es gibt aber auch noch andere interessantere Wege dies auf Benutzerbasis über Zugriffssteuerungslisten (ACL) durchzuführen. Ich werde dies am Ende dieses Kapitel noch vorstellen.

<!--## Git Attributes ##-->
## Git Attribute ##

<!--Some of these settings can also be specified for a path, so that Git applies those settings only for a subdirectory or subset of files. These path-specific settings are called Git attributes and are set either in a `.gitattributes` file in one of your directories (normally the root of your project) or in the `.git/info/attributes` file if you don’t want the attributes file committed with your project.-->

Einige dieser Einstellungen können auch auf bestimmte Pfade eingeschränkt werden, so dass sie nur fuer bestimmte Unterverzeichnisse oder Untergruppen von Dateien gueltig sind. Diese Einstellungen werden Git Attribute genannt und werden entweder in `.gitattributes` in einem der Projektverzeichnisse eingerichtet (ueblicherweise im Rootverzeichnis Deines Projektes), oder in der `.git/info/attributes` Datei, wenn Du nicht möchtest, dass die Attribute mit Deinem Projekt comitted werden.

<!--Using attributes, you can do things like specify separate merge strategies for individual files or directories in your project, tell Git how to diff non-text files, or have Git filter content before you check it into or out of Git. In this section, you’ll learn about some of the attributes you can set on your paths in your Git project and see a few examples of using this feature in practice.-->

Mit Hilfe von Attributen kannst Du Einstellungen vornehmen wie zum Beispiel verschiedene Merge Strategien fuer einzelne Dateien oder Verzeichnisse in Deinem Projekt spezifizieren, Git anweisen wie es ein Diff mit Nicht-Textdateien ausfuehren soll, oder wie Git Inhalte filtern soll bevor Du sie ein- oder auscheckst. In diesem Abschnitt wirst Du einige der Attribute kennenlernen, die Du in Deinen Git Projektpfaden einstellen kannst, sowie einige Beispiele wie diese Eigenschaften in der Praxis angewandt werden können.

<!--### Binary Files ###-->
### Binärdateien ###

<!--One cool trick for which you can use Git attributes is telling Git which files are binary (in cases it otherwise may not be able to figure out) and giving Git special instructions about how to handle those files. For instance, some text files may be machine generated and not diffable, whereas some binary files can be diffed — you’ll see how to tell Git which is which.-->

Ein nuetzlicher Trick den die Git Attribute erlauben ist Git mitzuteilen, welche Dateien Binär sind (fuer den Fall dass Git nicht in der Lag ist, das selbst festzustellen), und Git spezielle Anweisungen zu geben, wie diese Dateien behandelt werden sollen. Zum Beispiel können gewisse Textdateien Computergeneriert und damit nicht diff-bar sein, und umgekehrt können manche Binärdateien diff-bar sein — Du wirst sehen wie Du Git sagst welche Datei welche ist.

<!--#### Identifying Binary Files ####-->
#### Binärdateien erkennen ####

<!--Some files look like text files but for all intents and purposes are to be treated as binary data. For instance, Xcode projects on the Mac contain a file that ends in `.pbxproj`, which is basically a JSON (plain text javascript data format) dataset written out to disk by the IDE that records your build settings and so on. Although it’s technically a text file, because it’s all ASCII, you don’t want to treat it as such because it’s really a lightweight database — you can’t merge the contents if two people changed it, and diffs generally aren’t helpful. The file is meant to be consumed by a machine. In essence, you want to treat it like a binary file.-->

Einige Dateien sehen aus wie Textdateien, aber streng genommen als Binärdateien behandelt werden sollten. So enthalten zum Beispiel Xcode Projekte auf dem Mac eine Datei mit der Endung `.pbxproj`, die eigentlich nur ein JSON (ein Klartext Javascript Dateiformat) Datensatz ist, der von der IDE gespeichert wird und Deine Build Einstellungen und ähnliches enthält. Selbst wenn es technisch gesehen eine Textdatei ist, da sie komplett ASCII ist, willst Du sie nicht wirklich als solche behandeln, denn es ist eigentlich eine minimalistische Datenbank — man kann mit den Inhalten kein Merge ausfuehren, wenn zwei Leute die Datei geändert haben, und ein Diff ist selten hilfreich. Die Datei ist fuer die Verarbeitung durch den Computer gedacht. Kurz gesagt, Du willst sie als Binärdatei behandeln.

<!--To tell Git to treat all `pbxproj` files as binary data, add the following line to your `.gitattributes` file:-->

Um Git anzuweisen alle `pbxproj` Dateien als Binärdateien zu behandeln, fuege die folgende Zeile zu Deiner `.gitattributes` Datei hinzu:

	*.pbxproj -crlf -diff

<!--Now, Git won’t try to convert or fix CRLF issues; nor will it try to compute or print a diff for changes in this file when you run git show or git diff on your project. In the 1.6 series of Git, you can also use a macro that is provided that means `-crlf -diff`:-->

Jetzt wird Git nicht mehr versuchen CRLF Probleme zu ändern oder zu reparieren; es wird auch keine Dateiunterschiede ermitteln oder ausgeben, wenn Du ein 'git show' oder 'git diff' fuer Dein Projekt ausfuehrst. In den 1.6er Versionen von Git steht auch ein Makro zur Verfuegung, das dem `-crlf -diff` entspricht:

	*.pbxproj binary

<!--#### Diffing Binary Files ####-->
#### Diff bei Binärdateien ####

<!--In the 1.6 series of Git, you can use the Git attributes functionality to effectively diff binary files. You do this by telling Git how to convert your binary data to a text format that can be compared via the normal diff.-->

Bei 1.6er Versionen von Git ist es möglich, die Funktionalität von Git Attributen zu benutzen, um mit Diff effektiv Unterschiede zwischen Binärdateien zu inspizieren. Du kannst das erreichen, indem Du Git anweist, wie Deine Binärdaten in ein Textformat konvertiert werden können, das dann mittels normalem Diff verglichen werden kann.

<!--##### MS Word files #####-->
##### MS Word files #####

<!--Because this is a pretty cool and not widely known feature, I’ll go over a few examples. First, you’ll use this technique to solve one of the most annoying problems known to humanity: version-controlling Word documents. Everyone knows that Word is the most horrific editor around; but, oddly, everyone uses it. If you want to version-control Word documents, you can stick them in a Git repository and commit every once in a while; but what good does that do? If you run `git diff` normally, you only see something like this:-->

Da das eine ziemlich praktische und nicht sehr bekannte Funktionalität ist, werde ich einige Beispiele besprechen. Als erstes wirst Du diese Technik benutzen, um eines der lästigsten Probleme der Menschheit zu lösen: Versionskontrolle von Word Dokumenten. Jeder weiss, dass Word der schrecklichste Editor ist, den es gibt; aber komischerweise benutzt ihn jeder. Wenn Du eine Versionskontrolle fuer Word Dokumente willst, kannst Du sie einfach in ein Git Repository packen und ab und zu ein Commit machen; aber wozu ist das nuetzlich? Wenn Du ein normales `git diff` ausfuehrst, wirst Du eine ähnliche Ausgabe wie diese sehen:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

<!--You can’t directly compare two versions unless you check them out and scan them manually, right? It turns out you can do this fairly well using Git attributes. Put the following line in your `.gitattributes` file:-->

Du kannst zwei Versionen nicht direkt vergleichen, ausser Du checkst sie aus und pruefst sie manuell, richtig? Es stellt sich heraus, dass dies recht gut mittels Git Attributen möglich ist. Fuege diese Zeile in Deine `.gitattributes` Datei ein:

	*.doc diff=word

<!--This tells Git that any file that matches this pattern (.doc) should use the "word" filter when you try to view a diff that contains changes. What is the "word" filter? You have to set it up. Here you’ll configure Git to use the `strings` program to convert Word documents into readable text files, which it will then diff properly:-->

Dies weist Git an, dass auf jede Datei, die diesem Dateimuster (.doc) entspricht, ein "word" filter angewandt werden soll, wenn Du versuchst, ein Diff mit Dateiunterschieden anzusehen. Was ist nun der "word" Filter? Den musst Du nun einstellen. Hier wirst Du Git so konfigurieren, dass es das `strings` Programm zur Konvertierung von Word Dokumenten benutzt, um sie in lesbare Textdateien umzuwandeln, die Diff vernuenftig behandeln kann:

	$ git config diff.word.textconv strings

<!--This command adds a section to your `.git/config` that looks like this:-->

	[diff "word"]
		textconv = strings

<!--Side note: There are different kinds of `.doc` files. Some use an UTF-16 encoding or other "codepages" and `strings` won’t find anything useful in there. Your mileage may vary.-->

<!--Now Git knows that if it tries to do a diff between two snapshots, and any of the files end in `.doc`, it should run those files through the "word" filter, which is defined as the `strings` program. This effectively makes nice text-based versions of your Word files before attempting to diff them.-->

Jetzt weiss Git, dass es Dateien mit der Endung `.doc`, wenn es ein Diff zwischen zwei Schnappschuessen versucht, durch den "word" Filter schicken soll, welcher durch das `strings` Programm definiert ist. Das erzeugt praktisch gut lesbare Textversionen Deiner Word Dateien bevor ein Diff mit ihnen versucht wird.

<!--Here’s an example. I put Chapter 1 of this book into Git, added some text to a paragraph, and saved the document. Then, I ran `git diff` to see what changed:-->

Hier ist ein Beispiel. Ich habe Kapitel 1 des Buches in Git eingefuegt, dann etwas Text zu einem Absatz hinzugefuegt und das Dokument gespeichert. Dann fuehre ich `git diff` aus, um zu sehen, was geändert wurde:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
	 re going to cover how to get it and set it up for the first time if you don
	 t already have it on your system.
	 In Chapter Two we will go over basic Git usage - how to use Git for the 80%
	-s going on, modify stuff and contribute changes. If the book spontaneously
	+s going on, modify stuff and contribute changes. If the book spontaneously
	+Let's see if this works.

<!--Git successfully and succinctly tells me that I added the string "Let’s see if this works", which is correct. It’s not perfect — it adds a bunch of random stuff at the end — but it certainly works. If you can find or write a Word-to-plain-text converter that works well enough, that solution will likely be incredibly effective. However, `strings` is available on most Mac and Linux systems, so it may be a good first try to do this with many binary formats.-->

Git war erfolgrweich und zeigt nun kurz und buendig an, dass Ich den Text "Let's see if this works" hinzugefuegt habe, was korrekt ist. Es ist nicht perfekt, es wird etwas zufälliger Kram am Ende angefuegt — aber es funktioniert auf jeden Fall. Falls Du einen guten Word-nach-Text Konverter findest oder schreibst, dann ist diese Lösung wahrscheinlich aeusserst effektiv. Fuer den Anfang sollte allerdings `strings` fuer die meisten Binärformate ausreichend sein, vor allem da es auf den meisten Mac und Linux Systemen läuft. 

<!--##### OpenDocument Text files #####-->
##### OpenDocument Text files #####

<!--The same approach that we used for MS Word files (`*.doc`) can be used for OpenDocument Text files (`*.odt`) created by OpenOffice.org.-->

<!--Add the following line to your `.gitattributes` file:-->

	*.odt diff=odt

<!--Now set up the `odt` diff filter in `.git/config`:-->

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

<!--OpenDocument files are actually zip’ped directories containing multiple files (the content in an XML format, stylesheets, images, etc.). We’ll need to write a script to extract the content and return it as plain text. Create a file `/usr/local/bin/odt-to-txt` (you are free to put it into a different directory) with the following content:-->

	#! /usr/bin/env perl
	# Simplistic OpenDocument Text (.odt) to plain text converter.
	# Author: Philipp Kempgen

	if (! defined($ARGV[0])) {
		print STDERR "No filename given!\n";
		print STDERR "Usage: $0 filename\n";
		exit 1;
	}

	my $content = '';
	open my $fh, '-|', 'unzip', '-qq', '-p', $ARGV[0], 'content.xml' or die $!;
	{
		local $/ = undef;  # slurp mode
		$content = <$fh>;
	}
	close $fh;
	$_ = $content;
	s/<text:span\b[^>]*>//g;           # remove spans
	s/<text:h\b[^>]*>/\n\n*****  /g;   # headers
	s/<text:list-item\b[^>]*>\s*<text:p\b[^>]*>/\n    --  /g;  # list items
	s/<text:list\b[^>]*>/\n\n/g;       # lists
	s/<text:p\b[^>]*>/\n  /g;          # paragraphs
	s/<[^>]+>//g;                      # remove all XML tags
	s/\n{2,}/\n\n/g;                   # remove multiple blank lines
	s/\A\n+//;                         # remove leading blank lines
	print "\n", $_, "\n\n";

<!--And make it executable-->

	chmod +x /usr/local/bin/odt-to-txt

<!--Now `git diff` will be able to tell you what changed in `.odt` files.-->

<!--##### Image files #####-->
##### Image files #####

<!--Another interesting problem you can solve this way involves diffing image files. One way to do this is to run PNG files through a filter that extracts their EXIF information — metadata that is recorded with most image formats. If you download and install the `exiftool` program, you can use it to convert your images into text about the metadata, so at least the diff will show you a textual representation of any changes that happened:-->

Ein weiteres interessantes Problem, dass man auf diese Weise lösen kann sind Dateiunterschiede bei Bilddaten. Eine Möglichkeit dies zu tun  ist es, JPEG Dateien durch einen Filter zu schicken, der ihre EXIF Informationen extrahiert — Metainformationen die bei den meisten Bildformaten mitgefuehrt wird. Wenn Du das Programm `exiftool` herunterlädst und installierst, dann kannst Du es benutzen, um Deine Bilder in einen Text mit diesen Metainformationen umzuwandeln, so dass ein Diff Dir zumindest eine textuelle Repräsentation aller Veränderungen an der Datei anzeigt:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

<!--If you replace an image in your project and run `git diff`, you see something like this:-->

Wenn Du nun ein Bild in Deinem Projekt ersetzt und `git diff` ausfuehrst, wirst Du etwas wie dies hier sehen:

	diff --git a/image.png b/image.png
	index 88839c4..4afcb7c 100644
	--- a/image.png
	+++ b/image.png
	@@ -1,12 +1,12 @@
	 ExifTool Version Number         : 7.74
	-File Size                       : 70 kB
	-File Modification Date/Time     : 2009:04:17 10:12:35-07:00
	+File Size                       : 94 kB
	+File Modification Date/Time     : 2009:04:21 07:02:43-07:00
	 File Type                       : PNG
	 MIME Type                       : image/png
	-Image Width                     : 1058
	-Image Height                    : 889
	+Image Width                     : 1056
	+Image Height                    : 827
	 Bit Depth                       : 8
	 Color Type                      : RGB with Alpha

<!--You can easily see that the file size and image dimensions have both changed.-->

Man sieht direkt, dass sowohl Dateigrösse als auch die Bilddimensionen verändert wurden.

<!--### Keyword Expansion ###-->
### Schluesselworte Erweitern ###

<!--SVN- or CVS-style keyword expansion is often requested by developers used to those systems. The main problem with this in Git is that you can’t modify a file with information about the commit after you’ve committed, because Git checksums the file first. However, you can inject text into a file when it’s checked out and remove it again before it’s added to a commit. Git attributes offers you two ways to do this.-->

Entwickler, die an SVN- oder CVS-ähnliche Systeme gewoehnt sind, fragen oft nach der Möglichkeit Schluesselwoerter zu erweitern oder zu ersetzen. Das grösste Problem hierbei ist bei Git, dass eine Datei nach einem Commit nicht mehr mit Informationen ueber den Commit verändert werden kann, da Git bereits vorher die Pruefsumme berechnet. Allerdings kann man Text in eine Datei einfuegen, wenn sie ausgecheckt wird, und diesen Text wieder entfernen, bevor sie zu einem Commit hinzugefuegt wird. Git Attribute bieten hierfuer zwei Möglichkeiten an. 

<!--First, you can inject the SHA-1 checksum of a blob into an `$Id$` field in the file automatically. If you set this attribute on a file or set of files, then the next time you check out that branch, Git will replace that field with the SHA-1 of the blob. It’s important to notice that it isn’t the SHA of the commit, but of the blob itself:-->

Zunächst kannst Du die SHA-1 Pruefsumme eines Blobs automatisch in ein `$Id$` Feld einer Datei einfuegen. Wenn Du dieses Attribute fuer eine Datei oder eine Gruppe von Dateien einstellst, wird Git dieses Feld beim nächsten Checkout dieses Branches mit dem SHA-1 Wert dieses Blobs ersetzen. Hierbei ist es wichtig zu beachten, dass es der SHA des Blobs selbst ist, und nicht der des Commits:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

<!--The next time you check out this file, Git injects the SHA of the blob:-->

Wenn Du diese Datei das nächste Mal auscheckst wird Git den SHA Wert des Blobs einfuegen:

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

<!--However, that result is of limited use. If you’ve used keyword substitution in CVS or Subversion, you can include a datestamp — the SHA isn’t all that helpful, because it’s fairly random and you can’t tell if one SHA is older or newer than another.-->

Allerdings ist das Ergebnis nur mässig nuetzlich. Falls Du schon mal Schluesselwort-Ersetzen in CVS oder Subversion benutzt hast weisst Du, dass man dort auch Zeit und Datum einfuegen kann — der SHA Wert ist nicht sehr hilfreich, da er recht zufällig ist, und man nicht feststellen kann, ob er neuer oder älter ist als ein anderer.

<!--It turns out that you can write your own filters for doing substitutions in files on commit/checkout. These are the "clean" and "smudge" filters. In the `.gitattributes` file, you can set a filter for particular paths and then set up scripts that will process files just before they’re checked out ("smudge", see Figure 7-2) and just before they’re committed ("clean", see Figure 7-3). These filters can be set to do all sorts of fun things.-->

Wie sich herausstellt kann man aber seine eigenen Filter schreiben, um bei Commits oder Checkouts Schluesselworter in Dateien bei zu ersetzen. In der `.gitattributes` Datei kann man einen Filter fuer bestimmte Pfade angeben und dann Skripte einrichten, die Dateien kurz vor einem Checkout ("smudge", siehe Abbildung 7-2) und kurz vor einem Commit ("clean", siehe Abbildung 7-3) modifizieren. Diese Filter können eingerichtet werden, um alle möglichen witzigen Dinge zu machen.

<!--Figure 7-2. The “smudge” filter is run on checkout.-->

Insert 18333fig0702.png
Abbildung 7-2. Der "smudge" Filter wird beim Checkout ausgefuehrt.

<!--Figure 7-3. The “clean” filter is run when files are staged.-->

Insert 18333fig0703.png
Abbildung 7-3. Der "clean" Filter wird beim Transfer in den Stage Bereich ausgefuehrt.

<!--The original commit message for this functionality gives a simple example of running all your C source code through the `indent` program before committing. You can set it up by setting the filter attribute in your `.gitattributes` file to filter `*.c` files with the "indent" filter:-->

Die Beschreibung des ersten Commits dieser Funktionalität enthält ein einfaches Beispiel, wie man all seinen C Quellcode vom `indent` Programm pruefen lassen kann, bevor ein Commit gemacht wird. Du kannst dies einrichten, indem Du das entsprechende Filterattribut in der `.gitattributes` Datei auflistest, damit `*.c` Detaien mit dem "indent" Programm gefiltert werden:

	*.c     filter=indent

<!--Then, tell Git what the "indent" filter does on smudge and clean:-->

Dann muss Git noch gesagt werden, was der "indent" Filter bei "smudge" und "clean" zu tun hat:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

<!--In this case, when you commit files that match `*.c`, Git will run them through the indent program before it commits them and then run them through the `cat` program before it checks them back out onto disk. The `cat` program is basically a no-op: it spits out the same data that it gets in. This combination effectively filters all C source code files through `indent` before committing.-->

In diesem Fall wird Git, wenn ein Commit Dateien umfasst, die dem Muster `*.c` entsprechen, diese Dateien durch das "indent" Programm schicken, bevor es den Commit ausfuehrst. Werden sie wieder auf die lokale Platte ausgecheckt, so schickt Git sie durch das `cat` Programm. `cat` ist im Grunde genommen eine Null-Operation: es gibt genau die Daten wieder aus, die hereinkommen. Was diese Kombination also tatsächlich bewirkt, ist alle C Quellcode Dateien vor einem Commit durch den `indent` Filter schicken.

<!--Another interesting example gets `$Date$` keyword expansion, RCS style. To do this properly, you need a small script that takes a filename, figures out the last commit date for this project, and inserts the date into the file. Here is a small Ruby script that does that:-->

Ein weiteres interessantes Beispiel ermöglicht `$Date` Schluesselwort Erweiterung im Stile von RCS. Damit das vernuenftig klappt brauchst Du ein kleines Skript, das einen Dateinamen akzeptiert, das Datum des letzten Commit dieses Projektes ermittelt, und dann dieses Datum in die Datei einfuegt. Hier ist ein kleines Ruby Skript, das ddas macht:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

<!--All the script does is get the latest commit date from the `git log` command, stick that into any `$Date$` strings it sees in stdin, and print the results — it should be simple to do in whatever language you’re most comfortable in. You can name this file `expand_date` and put it in your path. Now, you need to set up a filter in Git (call it `dater`) and tell it to use your `expand_date` filter to smudge the files on checkout. You’ll use a Perl expression to clean that up on commit:-->

Alles was das Skript macht ist das letzte Commit Datum mittels des `git log` Befehls zu ermitteln, jede `$Date` Zeichenfolge die es per stdin erhält durch diese Information ersetzen und das Ergebnis ausgeben — es sollte einfach zu implementieren sein, welche Programmiersprache Du auch immer bevorzugst. Du kannst diese Datei `expand_date` nennen und in Deinem Suchpfad ablegen. Jetzt musst Du noch einen Filter in Git einrichten (nennen wir ihn `dater`) und so einstellen, dass Dein `expand_date` Filterskript benutzt wird, um Dateien beim Checkout zu modifizieren. Zum Säubern der Dateien wird ein Perl Ausdruck beim Commit benutzt:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

<!--This Perl snippet strips out anything it sees in a `$Date$` string, to get back to where you started. Now that your filter is ready, you can test it by setting up a file with your `$Date$` keyword and then setting up a Git attribute for that file that engages the new filter:-->

Dieser Perl Schnipsel entfernt alles, was er in einer `$Date$` Zeichenfolge findet, um wieder zum Ursprungszustand zurueckzukehren. Jetz wo der Filter fertig ist kannst Du ihn testen, indem Du eine Datei mit Deinem `$Date$` Schluesselwort erstellst und ein Git Attribut fuer diese Datei einrichtest, das den neuen Filter ausfuehrt:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

<!--If you commit those changes and check out the file again, you see the keyword properly substituted:-->

Wenn Du nun ein Commit mit diesen Änderungen machst und dann die Datei wieder auscheckst, wirst Du sehen, dass das Schluesselwort korrekt ersetzt wurde:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

<!--You can see how powerful this technique can be for customized applications. You have to be careful, though, because the `.gitattributes` file is committed and passed around with the project but the driver (in this case, `dater`) isn’t; so, it won’t work everywhere. When you design these filters, they should be able to fail gracefully and have the project still work properly.-->

Du siehst wie mächtig diese Technik fuer personalisierte Anwendungen sein kann. Du solltest allerdings vorsichtig sein, da die `.gitattributes` Datei ebenfalls in Git abgelegt ist und an alle Benutzer weitergegeben wird, aber Dein Filterskript (in diesem Fall `dater`) ist es nicht; also wird er nicht ueberall funktionieren. Wenn Du diese Filter entwickelst, sollte es möglich sein, dass sie ohne Fehler fehlschlagen, so dass das Projekt weiterhin korrekt funktioniert.

<!--### Exporting Your Repository ###-->
### Exportieren Deines Repositories ###

<!--Git attribute data also allows you to do some interesting things when exporting an archive of your project.-->

Git Attribute erlauben auch einige interessante Dinge, wenn Du Dein Projekt in ein Archiv exportierst.

<!--#### export-ignore ####-->
#### export-ignore ####

<!--You can tell Git not to export certain files or directories when generating an archive. If there is a subdirectory or file that you don’t want to include in your archive file but that you do want checked into your project, you can determine those files via the `export-ignore` attribute.-->

Du kannst Git anweisen gewisse Dateien oder Verzeichnisse nicht zu exportieren, wenn es ein Archiv erzeugt. Falls es Unterverzeichnisse oder Dateien gibt, die Du nicht in Deiner Archivdatei haben willst, aber in Deinem Projektrepository, so kannst Du diese Datein mit Hilfe des `export-ignore` Attributes bestimmen.

<!--For example, say you have some test files in a `test/` subdirectory, and it doesn’t make sense to include them in the tarball export of your project. You can add the following line to your Git attributes file:-->

Nehmen wir zum Beispiel an, Du hast einige Testdateien in einem `test/` Unterverzeichnis und es macht keinen Sinn, dass sie in einen exportierten Tarball Deines Projektes aufgenommen werden. Du kannst die folgende Zeile in Deine Git Attributdatei einfuegen:

	test/ export-ignore

<!--Now, when you run git archive to create a tarball of your project, that directory won’t be included in the archive.-->

Wenn Du jetzt "git archive" ausfuehrst, um einen Tarball Deines Projektes zu erstellen, wird das Verzeichnis nicht mit in das Archiv aufgenommen.

<!--#### export-subst ####-->
#### export-subst ####

<!--Another thing you can do for your archives is some simple keyword substitution. Git lets you put the string `$Format:$` in any file with any of the `-\-pretty=format` formatting shortcodes, many of which you saw in Chapter 2. For instance, if you want to include a file named `LAST_COMMIT` in your project, and the last commit date was automatically injected into it when `git archive` ran, you can set up the file like this:-->

Eine weitere Möglichkeit Archive zu modifizieren ist einfaches Ersetzen von Schluesselwörtern. Git erlaubt die Zeichenfolge `$Format:$` in jeder Datei mit allen Formatierungskuerzeln des Parameters `--pretty=format`, von denen Du bereits in Kapitel 2 einige kennengelernt hast. Wenn Du zum Beispiel eine Datei namens `LAST_COMMIT` zu Deinem Projekt hinzufuegen willst, und das Datum des Commis bei einem it archive in die Datei eingefuegt werden soll, so kannst Du die Datei wie folgt einrichten:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

<!--When you run `git archive`, the contents of that file when people open the archive file will look like this:-->

Wenn Du ein `git archive` ausfuehrst, dann wird die Datei ungefähr so aussehen, wenn jemand das Archiv öffnet:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

<!--### Merge Strategies ###-->
### Merge Strategien ###

<!--You can also use Git attributes to tell Git to use different merge strategies for specific files in your project. One very useful option is to tell Git to not try to merge specific files when they have conflicts, but rather to use your side of the merge over someone else’s.-->

Du kannst Git auch anweisen verschiedene Regeln fuer das Zusammenfuehren bestimmter Dateien in Deinem Projekt zu verwenden. Eine besonders nuetzliche Option ist es, Git so einzustellen, dass es bei bestimmten Dateien kein Zusammenfuehren von Konfliktstellen versucht, sondern Deine Seite des Merge der anderen Seite vorzieht.

<!--This is helpful if a branch in your project has diverged or is specialized, but you want to be able to merge changes back in from it, and you want to ignore certain files. Say you have a database settings file called database.xml that is different in two branches, and you want to merge in your other branch without messing up the database file. You can set up an attribute like this:-->

Dies ist hilfreich, falls ein Zweig Deines Projektes abgewichen oder spezialisiert ist, aber Du weiterhin in der Lage sein willst, Änderungen daran zurueckzufuehren, und dabei gewisse Dateien zu ignorieren. Nehmen wir an Du hast eine Konfigurationsdatei einer Datenbank namens database.xml, das sich in zwei Zweigen unterschiedlich ist, und Du möchtest ein Merge von dem anderen Zweig machen, ohne die Datenbankdatei unbrauchbar zu machen. Dann kannst Du etwa folgendes Attribut einrichten:

	database.xml merge=ours

<!--If you merge in the other branch, instead of having merge conflicts with the database.xml file, you see something like this:-->

Wenn Du ein Merge des anderen Zweiges machst, wirst Du statt Merge-Konflikten der Datei database.xml eher folgendes sehen:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

<!--In this case, database.xml stays at whatever version you originally had.-->

In diesem Fall bleibt database.xml in der Version, die Du urspruenglich hattest.

<!--## Git Hooks ##-->
## Git Hooks ##

<!--Like many other Version Control Systems, Git has a way to fire off custom scripts when certain important actions occur. There are two groups of these hooks: client side and server side. The client-side hooks are for client operations such as committing and merging. The server-side hooks are for Git server operations such as receiving pushed commits. You can use these hooks for all sorts of reasons, and you’ll learn about a few of them here.-->

Genau wie viele andere Versionskontrollsysteme gibt es auch bei Git die Möglichkeit eigene Skripte zu starten, wenn bestimmte wichtige Ereignisse eintreten. Es gibt zwei Gruppen dieser Schnittstellen, allgemein "Hook" genannt: auf Seiten des Clients und des Servers. Die Client-seitigen Hooks dienen Operationen bei einem Client, zum Beispiel bei Commits oder Merges. Die Server-seitigen Hooks dienen Git Server Operationen wie den Empfang von hochgeladenen Commits. Ma kann diese Schnittstellen aus diversen Gruenden benutzen, und einige davon wirst Du hier kennenlernen.

<!--### Installing a Hook ###-->
### Installieren eines Hooks ###

<!--The hooks are all stored in the `hooks` subdirectory of the Git directory. In most projects, that’s `.git/hooks`. By default, Git populates this directory with a bunch of example scripts, many of which are useful by themselves; but they also document the input values of each script. All the examples are written as shell scripts, with some Perl thrown in, but any properly named executable scripts will work fine — you can write them in Ruby or Python or what have you. For post-1.6 versions of Git, these example hook files end with .sample; you’ll need to rename them. For pre-1.6 versions of Git, the example files are named properly but are not executable.-->

Sämtliche Hooks werden im `hooks` Unterverzeichnis des Git Verzeichnisses gespeichert. In den meisten Projekten wird das `.git/hooks` sein. Git fuellt dieses Verzeichnis standardmässig mit Beispielskripten, von denen einige unverändert bereits nuetzlich sind; aber sie dokumentieren ausserdem die Eingabewerte jedes Skriptes. Alle Beispiele sind als Shellskripte mit etwas Perl hier und da geschrieben, aber jedes passend benannte Skript wird funktionieren — Du kannst sie in Ruby der Python schreiben, oder was immer Du bevorzugst. Bei Git Versionen nach 1.6 haben diese Beispieldateien die Endung .sample; sie muessen umbenannt werden. Bei Versionen vor 1.6 sind die Beispieldateien korrekt benannt, aber nicht ausfuehrbar.

<!--To enable a hook script, put a file in the `hooks` subdirectory of your Git directory that is named appropriately and is executable. From that point forward, it should be called. I’ll cover most of the major hook filenames here.-->

Um ein Hook-Skript zu aktivieren, speichere eine entsprechend benannte und ausfuehrbare Datei im `hooks` Unterverzeichnis Deines Git Verzeichnisses. Von diesem Augenblick an sollte es ausgefuehrt werden. Ich werde hier die meisten der wichtigen Hook Dateinamen besprechen.

<!--### Client-Side Hooks ###-->
### Client-seitige Hooks ###

<!--There are a lot of client-side hooks. This section splits them into committing-workflow hooks, e-mail-workflow scripts, and the rest of the client-side scripts.-->

Es gibt eine Menge Hooks auf Seiten des Clients. Dieser Abschnitt teilt sie in Hooks fuer einen Commit-Arbeitsablauf, Skripte bezogen auf e-Mail und den Rest der Client-seitigen Skripte.

<!--#### Committing-Workflow Hooks ####-->
#### Hooks fuer einen Commit Arbeitsablauf ####

<!--The first four hooks have to do with the committing process. The `pre-commit` hook is run first, before you even type in a commit message. It’s used to inspect the snapshot that’s about to be committed, to see if you’ve forgotten something, to make sure tests run, or to examine whatever you need to inspect in the code. Exiting non-zero from this hook aborts the commit, although you can bypass it with `git commit -\-no-verify`. You can do things like check for code style (run lint or something equivalent), check for trailing whitespace (the default hook does exactly that), or check for appropriate documentation on new methods.-->

Die ersten vier Hooks hängen mit dem Commit Prozess zusammen. Der `pre-commit` Hook wird zuerst ausgefuehrt, schon bevor Du die Commit Nachricht eingegeben hast. Es wird benutzt, um den Snapshot zu pruefen, der den Commit ausmacht, um festzustellen ob Du etwas vergessen hast, um sicherzustellen das Tests ausgefuehrt wurden, oder um den Code zu inspizieren, aus welchem Grunde Du ihn auch untersuchen willst. Wenn das entsprechende Skript einen Wert ungleich Null zurueckgibt, wird der Commit abgebrochen, aber es kann mit `git commit --no-verify` umgangen werden. Du kannst Dinge machen wie den Code Stil untersuchen (lint ausfuehren oder etwas entsprechendes), auf Leerzeichen am Zeilenende pruefen (der Standard-Hook macht genau das), oder bei neuen Methoden nach entsprechender Dokumentation suchen.

<!--The `prepare-commit-msg` hook is run before the commit message editor is fired up but after the default message is created. It lets you edit the default message before the commit author sees it. This hook takes a few options: the path to the file that holds the commit message so far, the type of commit, and the commit SHA-1 if this is an amended commit. This hook generally isn’t useful for normal commits; rather, it’s good for commits where the default message is auto-generated, such as templated commit messages, merge commits, squashed commits, and amended commits. You may use it in conjunction with a commit template to programmatically insert information.-->

Der `prepare-commit-msg` Hook wird ausgefuehrt, bevor der Editor fuer die Commit Nachricht geöffnet wird, aber nachdem die Standardnachricht erstellt wurde. Er erlaubt es die Standardnachricht zu modifizieren, bevor der Autor des Commits sie sieht. Dieser Hook akzeptiert diverse Optionen: den Pfad der Datei, die die bisherige Commit Nachricht enthält, den Typ des Commit und den SHA-1 Hash des Commit, falls es sich um ein Korrektur-Commit handelt. Dieser Hook ist ueblicherweise nicht sehr nuetzlich bei normalen Commits; er ist eher fuer solche Commits gedacht, bei denen die Standardnachricht automatisch generiert wird, wie zum Beispiel vorlagenbasierte Commit Nachrichten, Commits nach einem Merge, komprimierte Commits und Korrektur-Commits. Du kannst diesen Hook mit einer Commit Vorlage kombinieren, um programmatisch Informationen einzufuegen.

<!--The `commit-msg` hook takes one parameter, which again is the path to a temporary file that contains the current commit message. If this script exits non-zero, Git aborts the commit process, so you can use it to validate your project state or commit message before allowing a commit to go through. In the last section of this chapter, I’ll demonstrate using this hook to check that your commit message is conformant to a required pattern.-->

Der `commit-msg` Hook akzeptiert einen Parameter, der wiederum ein Pfad zu der temporären Datei ist, die die momentane Commit Nachricht enthält. Falls dieses Skript nicht Null zurueckgibt, so wird der Commit abgebrochen, somit kannst Du die Gueltigkeit des Projekstatus oder die Commit Nachricht pruefen, bevor ein Commit akzeptiert wird. Im letzten Abschnitt dieses Kapitels werde ich beschreiben, wie man diesen Hook benutzt, um sicherzustellen, dass Commit Nachrichten einem bestimmten Muster entsprechen.

<!--After the entire commit process is completed, the `post-commit` hook runs. It doesn’t take any parameters, but you can easily get the last commit by running `git log -1 HEAD`. Generally, this script is used for notification or something similar.-->

Wenn der komplette Commit Process beendet ist, wird der `post-commit` Hook ausgefuehrt. Er akzeptiert keine Parameter, aber Du kannst den letzten Commit einfach mit dem Befehl `git log -1 HEAD` abfragen. Dieses Skript wird ueblicherweise fuer Benachrichtigungen oder ähnliches benutzt.

<!--The committing-workflow client-side scripts can be used in just about any workflow. They’re often used to enforce certain policies, although it’s important to note that these scripts aren’t transferred during a clone. You can enforce policy on the server side to reject pushes of commits that don’t conform to some policy, but it’s entirely up to the developer to use these scripts on the client side. So, these are scripts to help developers, and they must be set up and maintained by them, although they can be overridden or modified by them at any time.-->

Diese Client-seitigen Skripte fuer den Commit Arbeitsablauf können auch fuer so ziemlich jeden anderen Arbeitsablauf verwendet werden. Sie werden oft benutzt, um bestimmte Regeln zu erzwingen, wobei es wichtig ist zu wissen, dass diese Skripte bei einem Klonen nicht mit uebertragen werden. Du kannst auf Seiten des Servers Regeln erzwingen, die hochgeladene Commits ablehnen, die nicht gewissen Prinzipien entsprechen, aber der Benutzer selbst entscheidet allein, ob er diese Skripte auf der Client Seite benutzt. Dies sind also Skripte, die den Entwicklern  helfen sollen, und sie muessen von ihnen erstellt und gepflegt werden, und sie können von ihnen jederzeit verändert oder uebergangen werden.

<!--#### E-mail Workflow Hooks ####-->
#### Hooks fuer E-mail Arbeitsablauf ####

<!--You can set up three client-side hooks for an e-mail-based workflow. They’re all invoked by the `git am` command, so if you aren’t using that command in your workflow, you can safely skip to the next section. If you’re taking patches over e-mail prepared by `git format-patch`, then some of these may be helpful to you.-->

Fuer einen e-Mail basierten Arbeitsablauf kannst Du drei Client-seitige Hooks einrichten. Sie werden alle mit dem Befehl `git am` aufgerufen, wenn Du diesen Befehl also in Deinem normalen Arbeitsablauf nicht verwendest, kannst Du zum nächsten Abschnitt springen. Falls Du Patches per e-Mail erhältst, die mit `git format-patch` erstellt wurden, könnten trotzdem einige dieser Skripte fuer Dich nuetzich sein.

<!--The first hook that is run is `applypatch-msg`. It takes a single argument: the name of the temporary file that contains the proposed commit message. Git aborts the patch if this script exits non-zero. You can use this to make sure a commit message is properly formatted or to normalize the message by having the script edit it in place.-->

Der erste Hook, der ausgefuehrt wird is `applypatch-msg`. Er akzeptiert genau einen Parameter: den Namen der temporären Datei, die die vorgegebene Commit Nachricht enthält. Git bricht den Patch ab, falls dieses Skript nicht Null zurueckgibt. Du kannst dies benutzen um sicherzustellen, dass die Commit Nachricht richtig formatiert ist, oder um die Nachricht zu standardisieren, indem das Skript sie direkt editiert.

<!--The next hook to run when applying patches via `git am` is `pre-applypatch`. It takes no arguments and is run after the patch is applied, so you can use it to inspect the snapshot before making the commit. You can run tests or otherwise inspect the working tree with this script. If something is missing or the tests don’t pass, exiting non-zero also aborts the `git am` script without committing the patch.-->

Der nächste Hook, der beim Patchen vie `gti am` ausgefuehrt wird ist `pre-applypatch`. Er benötigt keine Parameter und wird direkt nach Anwendung des Patches ausgefuehrt, somit kannst Du damit einen Schnappschuss des Projektes direkt vor einem Commit inspizieren. Du kannst mit diesem Skript Tests ablaufen lassen oder das Arbeitsverzeichnis anderweitig untersuchen. Falls etwas fehlt oder ein Test fehlschlägt, sorgt eine Beenden des Skriptes mit einem Wert anders als Null ebenfalls fuer das Abbrechen des `git am` Skriptes, ohne Commit des Patches.

<!--The last hook to run during a `git am` operation is `post-applypatch`. You can use it to notify a group or the author of the patch you pulled in that you’ve done so. You can’t stop the patching process with this script.-->

Der letzte Hook, der währen des `git am` Operation ausgefuehrt wird ist `post-applypatch`. Du kannst dies verwenden, um eine Benutzergruppe oder den Autoren des Patches darueber zu informieren, dass der Patch angewendet wurde. Du kannst das Patchen mit diesem Skript nicht mehr abbrechen. 

<!--#### Other Client Hooks ####-->
#### Andere Hooks fuer den Client ####

<!--The `pre-rebase` hook runs before you rebase anything and can halt the process by exiting non-zero. You can use this hook to disallow rebasing any commits that have already been pushed. The example `pre-rebase` hook that Git installs does this, although it assumes that next is the name of the branch you publish. You’ll likely need to change that to whatever your stable, published branch is.-->

Der `pre-rebase` Hook wird ausgefuehrt, bevor ein Rebase irgendetwas verändert, und er kann den Prozess durch einen Exit-Wert ungleich Null abbrechen. Du kannst diesen Hook benutzen, um zu verhindern, dass bereits hochgeladene Commits auf einen anderen Branch umbasiert werden. Der von Git installierte Beispiel-Hook fuer `pre-rebase`macht genau das, allerdings nimmt dieser an, dass der Name des veröffentlichten Branches 'next' ist. Du wirst das wahrscheinlich in den Namen umändern muessen, der Deinem stabilen, öffentlichen Branch entspricht.

<!--After you run a successful `git checkout`, the `post-checkout` hook runs; you can use it to set up your working directory properly for your project environment. This may mean moving in large binary files that you don’t want source controlled, auto-generating documentation, or something along those lines.-->

Nach jedem erfolgreichen `git-checkout` wird der `post-checkout` Hook ausgefuehrt; Du kannst ihn benutzen, um Dein Arbeitsverzeichnis korrekt fuer Deine Arbeitsumgebung einzurichten. Das kann das hinzukopieren grosser Binärdateien bedeuten, die Du nicht unter Versionskontrolle stellen möchtest, das automatische Generieren von Dokumentation, oder entsprechend ähnliche Aktionen.

<!--Finally, the `post-merge` hook runs after a successful `merge` command. You can use it to restore data in the working tree that Git can’t track, such as permissions data. This hook can likewise validate the presence of files external to Git control that you may want copied in when the working tree changes.-->

Abschliessend wird noch der `post-merge` Hook nach einem erfolgreichen `merge` ausgefuehrt. Du kannst diesen benutzen, um Daten in Deinem Arbeitsverzeichnis wiederherzustellen, die Git nicht verfolgen kann, wie zum Beispiel Berechtigungsdaten. Dieser Hook kann genauso auch zur Bestätigung des Vorhandenseins von Dateien ausserhalb der Git Kontrolle dienen, die Du eventuell hinzukopieren möchtest, wenn das Arbeitsverzeichnis verändert worden ist. 

<!--### Server-Side Hooks ###-->
### Serverseitige Hooks ###

<!--In addition to the client-side hooks, you can use a couple of important server-side hooks as a system administrator to enforce nearly any kind of policy for your project. These scripts run before and after pushes to the server. The pre hooks can exit non-zero at any time to reject the push as well as print an error message back to the client; you can set up a push policy that’s as complex as you wish.-->

Neben den Client-seitigen Hooks kannst Du als System Administrator noch einige wichtige Hooks auf Seiten des Servers einsetzen, um so ziemlich jede Art von Richtlinie fuer Dein Projekt zu erzwingen. Diese Skripte werden ausgefuehrt bevor und nachdem Daten auf den Server hochgeladen wurden. Die vorgelagerten Hooks können jederzeit mit einem Ruckgabewert ungleich Null abbrechen und somit das Hochladen verweigern und dem Client eine Fehlermeldung zurueckliefern; eine von Dir eingerichtete Push-Richtlinie kann so komplex sein, wie Du willst.

<!--#### pre-receive and post-receive ####-->
#### pre-receive und post-receive ####

<!--The first script to run when handling a push from a client is `pre-receive`. It takes a list of references that are being pushed from stdin; if it exits non-zero, none of them are accepted. You can use this hook to do things like make sure none of the updated references are non-fast-forwards; or to check that the user doing the pushing has create, delete, or push access or access to push updates to all the files they’re modifying with the push.-->

Das erste Skript, dass ausgefuehrt wird, wenn ein Push von einem Client empfangen wird ist `pre-receive`. Es akzeptiert eine Liste von Referenzen, die ueber 'stdin' hochgeladen werden; wird es mit einem Wert ungleich Null beendet, so wird keine von ihnen akzeptiert. Du kannst diesen Hook benutzen, um sicherzustellen, dass keine der aktualisierten Referenzen Nicht-'fast-forwards' sind; oder um zu pruefen, dass der hochladende Benutzer die Berechtigung zum Erstellen, Löschen oder Hochladen hat, oder die Berechtigung Aktualisierungen fuer alle Dateien hochzuladen, die er mit dem Push verändert.

<!--The `post-receive` hook runs after the entire process is completed and can be used to update other services or notify users. It takes the same stdin data as the `pre-receive` hook. Examples include e-mailing a list, notifying a continuous integration server, or updating a ticket-tracking system — you can even parse the commit messages to see if any tickets need to be opened, modified, or closed. This script can’t stop the push process, but the client doesn’t disconnect until it has completed; so, be careful when you try to do anything that may take a long time.-->

Der `post-receive` Hook läuft ab, nachdem der komplette Prozess abgeschlossen ist und aktualisieren anderer Dienste oder zum Benachrichtigen von Benutzern verwendet werden. Er erwartet die gleichen 'stdin' Daten wie `pre-receive`. Beispiele umfassen das Versenden von e-Mails an eine Liste, Benachtichtigen eines durchgehenden Integrations-Servers, oder das Aktualisieren eines Ticket oder Fehler-Verfolgungssystems.

<!--#### update ####-->
#### update ####

<!--The update script is very similar to the `pre-receive` script, except that it’s run once for each branch the pusher is trying to update. If the pusher is trying to push to multiple branches, `pre-receive` runs only once, whereas update runs once per branch they’re pushing to. Instead of reading from stdin, this script takes three arguments: the name of the reference (branch), the SHA-1 that reference pointed to before the push, and the SHA-1 the user is trying to push. If the update script exits non-zero, only that reference is rejected; other references can still be updated.-->

<!--## An Example Git-Enforced Policy ##-->

<!--In this section, you’ll use what you’ve learned to establish a Git workflow that checks for a custom commit message format, enforces fast-forward-only pushes, and allows only certain users to modify certain subdirectories in a project. You’ll build client scripts that help the developer know if their push will be rejected and server scripts that actually enforce the policies.-->

<!--I used Ruby to write these, both because it’s my preferred scripting language and because I feel it’s the most pseudocode-looking of the scripting languages; thus you should be able to roughly follow the code even if you don’t use Ruby. However, any language will work fine. All the sample hook scripts distributed with Git are in either Perl or Bash scripting, so you can also see plenty of examples of hooks in those languages by looking at the samples.-->

<!--### Server-Side Hook ###-->

<!--All the server-side work will go into the update file in your hooks directory. The update file runs once per branch being pushed and takes the reference being pushed to, the old revision where that branch was, and the new revision being pushed. You also have access to the user doing the pushing if the push is being run over SSH. If you’ve allowed everyone to connect with a single user (like "git") via public-key authentication, you may have to give that user a shell wrapper that determines which user is connecting based on the public key, and set an environment variable specifying that user. Here I assume the connecting user is in the `$USER` environment variable, so your update script begins by gathering all the information you need:-->

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

<!--Yes, I’m using global variables. Don’t judge me — it’s easier to demonstrate in this manner.-->

<!--#### Enforcing a Specific Commit-Message Format ####-->

<!--Your first challenge is to enforce that each commit message must adhere to a particular format. Just to have a target, assume that each message has to include a string that looks like "ref: 1234" because you want each commit to link to a work item in your ticketing system. You must look at each commit being pushed up, see if that string is in the commit message, and, if the string is absent from any of the commits, exit non-zero so the push is rejected.-->

<!--You can get a list of the SHA-1 values of all the commits that are being pushed by taking the `$newrev` and `$oldrev` values and passing them to a Git plumbing command called `git rev-list`. This is basically the `git log` command, but by default it prints out only the SHA-1 values and no other information. So, to get a list of all the commit SHAs introduced between one commit SHA and another, you can run something like this:-->

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

<!--You can take that output, loop through each of those commit SHAs, grab the message for it, and test that message against a regular expression that looks for a pattern.-->

<!--You have to figure out how to get the commit message from each of these commits to test. To get the raw commit data, you can use another plumbing command called `git cat-file`. I’ll go over all these plumbing commands in detail in Chapter 9; but for now, here’s what that command gives you:-->

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

<!--A simple way to get the commit message from a commit when you have the SHA-1 value is to go to the first blank line and take everything after that. You can do so with the `sed` command on Unix systems:-->

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

<!--You can use that incantation to grab the commit message from each commit that is trying to be pushed and exit if you see anything that doesn’t match. To exit the script and reject the push, exit non-zero. The whole method looks like this:-->

	$regex = /\[ref: (\d+)\]/

	# enforced custom commit message format
	def check_message_format
	  missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  missed_revs.each do |rev|
	    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
	    if !$regex.match(message)
	      puts "[POLICY] Your message is not formatted correctly"
	      exit 1
	    end
	  end
	end
	check_message_format

<!--Putting that in your `update` script will reject updates that contain commits that have messages that don’t adhere to your rule.-->

<!--#### Enforcing a User-Based ACL System ####-->

<!--Suppose you want to add a mechanism that uses an access control list (ACL) that specifies which users are allowed to push changes to which parts of your projects. Some people have full access, and others only have access to push changes to certain subdirectories or specific files. To enforce this, you’ll write those rules to a file named `acl` that lives in your bare Git repository on the server. You’ll have the `update` hook look at those rules, see what files are being introduced for all the commits being pushed, and determine whether the user doing the push has access to update all those files.-->

<!--The first thing you’ll do is write your ACL. Here you’ll use a format very much like the CVS ACL mechanism: it uses a series of lines, where the first field is `avail` or `unavail`, the next field is a comma-delimited list of the users to which the rule applies, and the last field is the path to which the rule applies (blank meaning open access). All of these fields are delimited by a pipe (`|`) character.-->

<!--In this case, you have a couple of administrators, some documentation writers with access to the `doc` directory, and one developer who only has access to the `lib` and `tests` directories, and your ACL file looks like this:-->

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

<!--You begin by reading this data into a structure that you can use. In this case, to keep the example simple, you’ll only enforce the `avail` directives. Here is a method that gives you an associative array where the key is the user name and the value is an array of paths to which the user has write access:-->

	def get_acl_access_data(acl_file)
	  # read in ACL data
	  acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
	  access = {}
	  acl_file.each do |line|
	    avail, users, path = line.split('|')
	    next unless avail == 'avail'
	    users.split(',').each do |user|
	      access[user] ||= []
	      access[user] << path
	    end
	  end
	  access
	end

<!--On the ACL file you looked at earlier, this `get_acl_access_data` method returns a data structure that looks like this:-->

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

<!--Now that you have the permissions sorted out, you need to determine what paths the commits being pushed have modified, so you can make sure the user who’s pushing has access to all of them.-->

<!--You can pretty easily see what files have been modified in a single commit with the `-\-name-only` option to the `git log` command (mentioned briefly in Chapter 2):-->

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

<!--If you use the ACL structure returned from the `get_acl_access_data` method and check it against the listed files in each of the commits, you can determine whether the user has access to push all of their commits:-->

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # see if anyone is trying to push something they can't
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path || # user has access to everything
	          (path.index(access_path) == 0) # access to this path
	          has_file_access = true
	        end
	      end
	      if !has_file_access
	        puts "[POLICY] You do not have access to push to #{path}"
	        exit 1
	      end
	    end
	  end
	end

	check_directory_perms

<!--Most of that should be easy to follow. You get a list of new commits being pushed to your server with `git rev-list`. Then, for each of those, you find which files are modified and make sure the user who’s pushing has access to all the paths being modified. One Rubyism that may not be clear is `path.index(access_path) == 0`, which is true if path begins with `access_path` — this ensures that `access_path` is not just in one of the allowed paths, but an allowed path begins with each accessed path.-->

<!--Now your users can’t push any commits with badly formed messages or with modified files outside of their designated paths.-->

<!--#### Enforcing Fast-Forward-Only Pushes ####-->

<!--The only thing left is to enforce fast-forward-only pushes. In Git versions 1.6 or newer, you can set the `receive.denyDeletes` and `receive.denyNonFastForwards` settings. But enforcing this with a hook will work in older versions of Git, and you can modify it to do so only for certain users or whatever else you come up with later.-->

<!--The logic for checking this is to see if any commits are reachable from the older revision that aren’t reachable from the newer one. If there are none, then it was a fast-forward push; otherwise, you deny it:-->

	# enforces fast-forward only pushes
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

<!--Everything is set up. If you run `chmod u+x .git/hooks/update`, which is the file into which you should have put all this code, and then try to push a non-fast-forward reference, you’ll get something like this:-->

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

<!--There are a couple of interesting things here. First, you see this where the hook starts running.-->

	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)

<!--Notice that you printed that out to stdout at the very beginning of your update script. It’s important to note that anything your script prints to stdout will be transferred to the client.-->

<!--The next thing you’ll notice is the error message.-->

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

<!--The first line was printed out by you, the other two were Git telling you that the update script exited non-zero and that is what is declining your push. Lastly, you have this:-->

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

<!--You’ll see a remote rejected message for each reference that your hook declined, and it tells you that it was declined specifically because of a hook failure.-->

<!--Furthermore, if the ref marker isn’t there in any of your commits, you’ll see the error message you’re printing out for that.-->

	[POLICY] Your message is not formatted correctly

<!--Or if someone tries to edit a file they don’t have access to and push a commit containing it, they will see something similar. For instance, if a documentation author tries to push a commit modifying something in the `lib` directory, they see-->

	[POLICY] You do not have access to push to lib/test.rb

<!--That’s all. From now on, as long as that `update` script is there and executable, your repository will never be rewound and will never have a commit message without your pattern in it, and your users will be sandboxed.-->

<!--### Client-Side Hooks ###-->

<!--The downside to this approach is the whining that will inevitably result when your users’ commit pushes are rejected. Having their carefully crafted work rejected at the last minute can be extremely frustrating and confusing; and furthermore, they will have to edit their history to correct it, which isn’t always for the faint of heart.-->

<!--The answer to this dilemma is to provide some client-side hooks that users can use to notify them when they’re doing something that the server is likely to reject. That way, they can correct any problems before committing and before those issues become more difficult to fix. Because hooks aren’t transferred with a clone of a project, you must distribute these scripts some other way and then have your users copy them to their `.git/hooks` directory and make them executable. You can distribute these hooks within the project or in a separate project, but there is no way to set them up automatically.-->

<!--To begin, you should check your commit message just before each commit is recorded, so you know the server won’t reject your changes due to badly formatted commit messages. To do this, you can add the `commit-msg` hook. If you have it read the message from the file passed as the first argument and compare that to the pattern, you can force Git to abort the commit if there is no match:-->

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

<!--If that script is in place (in `.git/hooks/commit-msg`) and executable, and you commit with a message that isn’t properly formatted, you see this:-->

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

<!--No commit was completed in that instance. However, if your message contains the proper pattern, Git allows you to commit:-->

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

<!--Next, you want to make sure you aren’t modifying files that are outside your ACL scope. If your project’s `.git` directory contains a copy of the ACL file you used previously, then the following `pre-commit` script will enforce those constraints for you:-->

	#!/usr/bin/env ruby

	$user    = ENV['USER']

	# [ insert acl_access_data method from above ]

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('.git/acl')

	  files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
	  files_modified.each do |path|
	    next if path.size == 0
	    has_file_access = false
	    access[$user].each do |access_path|
	    if !access_path || (path.index(access_path) == 0)
	      has_file_access = true
	    end
	    if !has_file_access
	      puts "[POLICY] You do not have access to push to #{path}"
	      exit 1
	    end
	  end
	end

	check_directory_perms

<!--This is roughly the same script as the server-side part, but with two important differences. First, the ACL file is in a different place, because this script runs from your working directory, not from your Git directory. You have to change the path to the ACL file from this-->

	access = get_acl_access_data('acl')

<!--to this:-->

	access = get_acl_access_data('.git/acl')

<!--The other important difference is the way you get a listing of the files that have been changed. Because the server-side method looks at the log of commits, and, at this point, the commit hasn’t been recorded yet, you must get your file listing from the staging area instead. Instead of-->

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

<!--you have to use-->

	files_modified = `git diff-index --cached --name-only HEAD`

<!--But those are the only two differences — otherwise, the script works the same way. One caveat is that it expects you to be running locally as the same user you push as to the remote machine. If that is different, you must set the `$user` variable manually.-->

<!--The last thing you have to do is check that you’re not trying to push non-fast-forwarded references, but that is a bit less common. To get a reference that isn’t a fast-forward, you either have to rebase past a commit you’ve already pushed up or try pushing a different local branch up to the same remote branch.-->

<!--Because the server will tell you that you can’t push a non-fast-forward anyway, and the hook prevents forced pushes, the only accidental thing you can try to catch is rebasing commits that have already been pushed.-->

<!--Here is an example pre-rebase script that checks for that. It gets a list of all the commits you’re about to rewrite and checks whether they exist in any of your remote references. If it sees one that is reachable from one of your remote references, it aborts the rebase:-->

	#!/usr/bin/env ruby

	base_branch = ARGV[0]
	if ARGV[1]
	  topic_branch = ARGV[1]
	else
	  topic_branch = "HEAD"
	end

	target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
	remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

	target_shas.each do |sha|
	  remote_refs.each do |remote_ref|
	    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
	    if shas_pushed.split("\n").include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

<!--This script uses a syntax that wasn’t covered in the Revision Selection section of Chapter 6. You get a list of commits that have already been pushed up by running this:-->

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

<!--The `SHA^@` syntax resolves to all the parents of that commit. You’re looking for any commit that is reachable from the last commit on the remote and that isn’t reachable from any parent of any of the SHAs you’re trying to push up — meaning it’s a fast-forward.-->

<!--The main drawback to this approach is that it can be very slow and is often unnecessary — if you don’t try to force the push with `-f`, the server will warn you and not accept the push. However, it’s an interesting exercise and can in theory help you avoid a rebase that you might later have to go back and fix.-->

<!--## Summary ##-->

<!--You’ve covered most of the major ways that you can customize your Git client and server to best fit your workflow and projects. You’ve learned about all sorts of configuration settings, file-based attributes, and event hooks, and you’ve built an example policy-enforcing server. You should now be able to make Git fit nearly any workflow you can dream up.-->
