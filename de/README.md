[![Build-Status](https://secure.travis-ci.org/progit-de/progit.png?branch=master)](https://travis-ci.org/progit-de/progit)

# Deutsche Übersetzung #

Die deutsche Übersetzung wird im Repository progit-de/progit verwaltet. Wenn Du an der deutschen Übersetzung mitarbeiten willst, dann melde Dich am besten bei uns. Du kannst dazu einen Issue im Repository progit-de/progit erzeugen. Wir werden Dir dann einen Vorschlag machen, wie Du uns am besten helfen kannst. Der Workflow an sich ist unter Workflow beschrieben. Ein Status der Übersetzung der jeweiligen Kapitel findest Du unter "Status der Übersetzung".

Du kannst auch sofort mit der Übersetzung beginnen, allerdings besteht dann das Risiko, dass ein Kapitel doppelt übersetzt oder überarbeitet wird. Eventuell war Deine Arbeit dann umsonst.

## Workflow ##

Um am Projekt mitzuarbeiten, erstellst Du am besten erst einmal ein Fork des Repositorys progit-de/progit unter Deinem Account ("Fork this repo" Button).

In diesem Projekt kannst Du Dich nun austoben und Deinen Beitrag zur Übersetzung leisten.

Beispielhaftes Vorgehen:

	git clone git@github.com:deinname/progit.git

	# Trage das deutsche Repository ebenso als Remote ein
	git remote add progit-de git@github.com:progit-de/progit.git

	# Lokalen Branch anlegen und daran arbeiten
	git checkout -b Chapter71
	git commit -m "[de] Fix headings in chapter 7.1"

	# Wenn Deine Arbeit in sich abgeschlossen ist, kannst Du die Ergebnisse pushen.
	# Vor einem Push solltest Du allerdings prüfen, ob sich zwischenzeitlich
	# das Repository git@github.com:progit-de/progit.git aktualisiert hat.
	git fetch progit-de

	# Falls es sich aktualisiert hat, führe einen Rebase aus und
	# behebe die ggf. aufgetretenden Konflikte
	git rebase progit-de/next

	# Pushe Deine Ergebnisse in Dein Github Repository
	git push origin

Informiere uns jetzt mit einem Pull Request unter Github, dass Dein Branch fertiggestellt und bereit zum mergen ist.

Wir werden dann Dein Ergebnis prüfen bzw. ein weiterer Helfer wird Dein Ergebnis reviewen. Das kann dazu führen, dass Du Deine Übersetzung noch überarbeiten musst. Siehe das Review als positive Hilfestellung damit das Ergebnis insgesamt besser wird und nimm die Kritik nicht negativ auf. Danach werden wir Deine Arbeit übernehmen und schließlich in den Hauptzweig unter progit/progit einpflegen.

### Commit Nachrichten ###

Die Commit Nachrichten beginnen mit einem vorangestellten [de], dann ein Leerzeichen und dann die eigentliche Commit Nachricht. Dann eine leere Zeile und eine erweiterte Beschreibung bzw. eine Beschreibung warum der Commit durchgeführt wurde.

Beispiel:

	[de] Remove comment for Figure 7-1 because it is shown on git-scm.com

	- Bla bla blub

## Vorgaben für das Übersetzen ##

### Allgemein ###

* Falls Du einen Abschnitt übersetzen willst, der noch nicht übersetzt wurde, so kopiere den aktuellen englischen Text in die deutsche Übersetzung. Setze um den englischen Text die Kommentarzeichen: <!--This is the english original text.-->. Bitte beachte, dass in Kommentaren die Folge "--" (ohne Anführungszeichen) nicht vorkommen darf. Falls diese im englischen Orginal enthalten ist, so trenne die zwei Minus durch ein Leerzeichen. Andernfalls wird der Kommentar bei den zwei Minus beendet.

* Falls Du einen Abschnitt überarbeiten willst, so aktualisiere zu erst den englischen Text in der deutschen Übersetzung. Der englische Text sollte immer als Kommentar enthalten sein. Falls nicht, so füge ihn bitte ein (siehe oben). Danach kannst Du die eigentliche Überarbeitung starten.

* Der englische Orginaltext ist immer über jedem deutschen Absatz als Kommentar eingefügt. Jeder Abschnitt inklusive Überschrift muss als englischer Orginaltext als Kommentar enthalten sein. Eingerückte Code-Zeilen oder Git Befehle werden nicht übersetzt und nicht zusätzlich als Kommentar ausgeführt.

### Rechtschreibung und Grammatik ###

* Der Leser wird mit "Du" angesprochen und das "Du" wird auch groß geschrieben. Bitte beachte dies auch bei Possessivpronomen, wie z.B. Dein, Deine. Siehe hierzu auch http://www.duden.de/sprachwissen/sprachratgeber/gross-oder-kleinschreibung-von--em-du-du--em--und--em-ihr-ihr--em--1

* Bei englischen Nomen, die auf "y" enden, wird beim Plural nur ein einzelnes "s" angehängt (kein ies). Siehe hierzu auch http://www.duden.de/sprachwissen/sprachratgeber/crashkurs--in-25-schritten-zur-neuen-rechtschreibung

#### Schreibweise von verschiedenen Git-Begriffen ####

##### A - D #####

* Branch (Plural: Branches)
* Branch-Name
* Branch-Referenz (Plural: Branch-Referenzen)
* Commit
* Commit-Datum
* Commit-ID
* Commit-Objekt (Plural: Commit-Objekte)
* Commit-Nachricht
* Drei-Punkte-Syntax

##### E - H #####

* Git-Repository
* HEAD
* HEAD-Referenz

##### I - Q #####

* der Klon (Plural: Klone)
* Low-Level-Operation

##### R - T #####

* Reflog-Ausgabe
* Remote-Repository
* Repository (Plural: Repositorys)
* SHA-1
* SHA-1-Hash (Genitiv: SHA-1-Hashes)
* SHA-1-Hashwert (Plural: SHA-1-Hashwerte)
* SHA-1-Prüfsumme
* SHA-1-Wert
* stagen (gestaget, ungestaget)
* Staging-Area
* Stash
* stashen

##### U - Z #####

* Zwei-Punkte-Syntax

### Übersetzung von Git spezifischen Begriffen ###

Wir versuchen die englischen Fachbegriffe, die in der Welt von Git existieren, zu benutzen. Zusätzlich versuchen wir aber immer, dass ein neu eingeführter Git-spezifischer Begriff, auch auf Deutsch erklärt wird.
Wir bevorzugen die englischen Fachbegriffe, da sie in zahlreichen Befehlen und Ausgaben von Git verwendet werden.

## Status der Übersetzung ##

Bitte den Status nicht aktualisieren. Dies übernimmt ein Maintainer.

<table>
<tr>
<td><b>Kapitel</b></td>
<td><b>Übersetzung vorhanden</b></td>
<td><b>Englischer Orginaltext vorhanden</b></td>
<td><b>Englischer Orginaltext in Kommentaren vorhanden</b></td>
<td><b>Status</b></td>
</tr>
<tr>
<td>1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>1.7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>2.8</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>3.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>3.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>3.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>3.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>3.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>3.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>3.7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Teilweise Übersetzung doppelt, Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="red">Rechtschreibfehler oder Grammatikfehler</td>
</tr>
<tr>
<td>4.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.8</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.9</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.10</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>4.11</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>5.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>5.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>5.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>5.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.7</td>
<td>Nein</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>6.8</td>
<td>Nein</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>7.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>7.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>7.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>7.4</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>7.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="yellow">Review notwendig</td>
</tr>
<tr>
<td>8</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>8.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>8.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Fast vollständig übersetzt. Aktualisierung notwendig.</td>
</tr>
<tr>
<td>8.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.1</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.2</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.3</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.4</td>
<td>Teilweise</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.5</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.6</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.7</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>9.8</td>
<td>Ja</td>
<td>Nein</td>
<td>Ja</td>
<td bgcolor="green">Ok</td>
</tr>
<tr>
<td>Index of Commands</td>
<td>Nein</td>
<td>Nein</td>
<td>Nein</td>
<td bgcolor="yellow">Übersetzung fehlt</td>
</tr>
</table>
