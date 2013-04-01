# Customizing Git #

Finora abbiamo quindi coperto le basi di come Git funzioni e come usarlo, abbiamo introdotto un numero di strumenti che Git fornisce per aiutarti ad utilizzarlo al meglio ed in modo efficiente. In questo capitolo spiegherò alcune delle operazioni che possono essere utilizzate per personalizzare il comportamento di Git introducendo molti settaggi ed il Hooks System. Tramite questi strumenti, è semplice fare in modo che Git lavori nel modo che tu, la tua azienda, o il tuo gruppo desiderate.

## Configurazione di Git ##

Come hai visto brevemente nel capitolo 1, si possono specificare delle impostazioni per Git tramite il comando `git config`. Una delle prime cose che hai fatto è stato impostare il tuo nome ed il tuo indirizzo e-mail:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Ora imparerai alcune delle opzioni più interessanti che si possono impostare in questa maniera per personalizzare l'utilizzo di Git.

Hai visto alcuni semplici dettagli di configurazione nel primo capitolo, ora li esamineremo ancora velocemente. Git utilizza una serie di files di configurazione per determinare comportamenti non standard che potresti desiderare. In primo luogo Git cercherà questi valori nel file `/etc/gitconfig`, il quale contiene valori per ogni utente e repository di sua proprietà presenti sul sitema. Se si passa l'opzione `--system` a `git config`, il programma leggerà e scriverà in modo specifico su questo file.

Successivamente Git controlla il file `~/.gitconfig`, che è specifico per ogni utente. Puoi fare in modo che Git legga e scriva su questo file utilizzando l'opzione `--global`.

Infine, Git controlla i valori di configurazione nel file di configurazione presente nella directory Git (`.git/config`) di qualsiasi repository che stai utilizzando. Questi valori sono specifici del singolo repository. Ongi livello sovrascrive i valori del livello precedente, per esempio i valori in `.git/config` battono quelli in `/etc/gitconfig`. Si può inoltre impostare questi valori modificando manualmente il file ed inserendo la corretta sintassi, tuttavia solitamente è più semplice eseguire il comando `git config`.

### Configurazione Base del Client ###

Le opzioni di configurazione riconosciute da Git si suddividono in due categorie: client-side e server-side. La maggioranza delle opzioni sono client-side—impostando le tue personali preferenze. Sono comunque disponibili molte opzioni, ne copriremo solo alcune che sono solitamente utilizzate o possono personalizzare il tuo ambiente di lavoro in modo significativo. Molte opzioni sono utili solo in casi limite che non esamineremo in questa sede. Nel caso tu voglia vedere una lista di tutte le opzioni che la tua versione di Git riconosce puoi eseguire il comando

	$ git config --help

La pagina del manuale per `git config` elenca tutte le opzioni disponibili aggiungendo qualche dettaglio.

#### core.editor ####

Di default, Git utilizza qualsiasi programma che tu abbia impostato come text editor, in alternativa sceglie l'editor Vi per creare e modificare commit tag e messaggi. Per cambiare l'impostazione standard, puoi utilizzare l'impostazione `core.editor`:

	$ git config --global core.editor emacs

Ora, non importa quale sia la variabile shell per l'editor, Git utilizzerà Emacs per modificare i messaggi.

#### commit.template ####

Se impostato verso il percorso di un file, Git utilizzerà questo file come messaggio di default per i tuoi commit. Ad esempio, supponiamo che tu abbia creato un file di template in `$HOME/.gitmessage.txt` in questo modo:

	subject line

	what happened

	[ticket: X]

Per comunicare a Git di utilizzare come messaggio di default il messaggio che compare nell'editor quando viene eseguito `git commit`, imposta il valore `commit.template` in questo modo:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

Il tuo editor si aprirà quindi in un modo simile a questo per la tua variabile metasintattica del messaggio di commit, ad ogni tuo commit:

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

Nel caso tu abbia una norma per il messaggio di commit, allora inserire un template per quella norma sul tuo sistema e configurare Git per utilizzarla di default può aiutare ad aumentare le possibilità che quella norma venga seguita regolarmente.

#### core.pager ####

L'impostazione core.pager determina quale pager venga utilizzato quando Git pagina l'output come `log` e `diff`. Puoi impostarlo a `more` o al tuo pager preferito (di default è `less`), in alternativa puoi disattivarlo impostandolo ad una stringa vuota:

	$ git config --global core.pager ''

Nel caso tu lo esegua, Git paginerà l'output di ogni comando, non importa quanto esso sia lungo.

#### user.signingkey ####

Nel caso tu voglia firmare i tags (come discusso nel Capitolo 2), impostare la tua chiave GPG nelle impostazioni rende le cose più semplici. Imposta l'ID della tua chiave in questo modo:

	$ git config --global user.signingkey <gpg-key-id>

Ora, puoi firmare i tags senza dover specificare la tua chiave ogni volta con il comando `git tag`:

	$ git tag -s <tag-name>

#### core.excludesfile ####

Puoi inserire patterns nel file `.gitignore` del tuo progetto per fare in modo che Git non li veda come untracked files o provi a farne uno stage all'esecuzione del comando `git add` su di loro, come visto nel Capitolo 2. Comunque, se vuoi che un altro file all'esterno del tuo progetto gestisca questi valori o abbia valori extra, puoi informare Git della posizione del file tramite il parametro `core.excludesfile`. Impostalo semplicemente sul percorso del file che ha un contenuto simile a quello che avrebbe un file `.gitignore`.

#### help.autocorrect ####

Questa opzione è disponibile solo in Git 1.6.1 e successivi. Se digiti in modo errato un comando in Git 1.6, ti mostrerà qualcosa del genere:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Se imposti `help.autocorrect` a 1, Git automaticamente eseguirà il comando nel caso in cui corrisponda ad un solo match.

### Colors in Git ###

Git può rendere i suoi messaggi colorati nel tuo terminale, in questo modo può aiutarti a capire velocemente e facilmente l'output. Un numero di opzioni può aiutarti ad impostare le preferenze nei colori.

#### color.ui ####

Git colora automaticamente la maggior parte dei suoi output se richiesto. Si possono fare richieste molto specifiche su cosa si vuole che sia colorato e come; per attivare tutti i colori di default nel terminale basta impostare `color.ui` a true:

	$ git config --global color.ui true

Una volta impostato il valore, Git colorerà il suo output se esso è indirizzato ad un terminale. Altre possibili impostazioni sono false, che non permette mai di colorare l'output, ed always, che imposta i colori sempre, anche se l'output è reindirizzato ad un file o ad un altro comando tramite pipe. Questa impostazione è stata aggiunta a Git nella versione 1.5.5; se possiedi una versione più vecchia dovrai impostare tutti i settaggi per i colori individualmente.

Raramente è desiderabile impostare `color.ui = always`. Nella maggior parte dei casi, se vuoi codice colorato in un output reindirizzato puoi invocare il comando con il flag `--color` in modo da forzare l'uso del colore. L'opzione tipicamente usata è `color.ui = true`.

#### `color.*` ####

Nel caso in cui si desideri una configurazione più specifica su quali comandi sono colorati e come, o si abbia una versione meno recente, Git fornisce impostazioni di colorazione verb-specific. Ognuna di esse può essere impostata a `true`, `false` oppure `always`:

	color.branch
	color.diff
	color.interactive
	color.status

In aggiunta, ognuna di queste ha sottoimpostazioni che possono essere utilizzate per impostare colori specifici per le parti dell'output, nel caso si voglia sovrascrivere ogni colore. Per esempio, per impostare la meta informazione nell'output di diff che indichi di usare blu per il testo, nero per lo sfondo e testo in grassetto, puoi eseguire il comando:

	$ git config --global color.diff.meta "blue black bold"

Il colore può essere impostato di ognuno dei seguenti valori: normal, black, red, green, yellow, blue, magenta, cyan, oppure white. Per quanto riguarda gli attributi, come bold nell'esempio precedente, puoi scegliere tra from bold, dim, ul, blink, e reverse.

Per queste sotto-configurazioni puoi guardare la pagina di manuale di `git config`.

### Strumenti Esterni per Merge e Diff ###

Inoltre Git ha un'implementazione interna di diff, che è quella che stai utilizzando, puoi impostare, in alternativa, uno strumento esterno. Puoi anche impostare uno strumento per la risoluzione dei conflitti di merge invece di doverli risolvere a mano. Dimostrerò come impostare il Perforce Visual Merge Tool (P4Merge) per gestire i diff ed i merge, perché è uno strumento grafico carino e gratuito.

Se vuoi provarlo, P4Merge funziona su tutte le maggiori piattaforme, quindi dovresti riuscirci. Negli esempi utilizzerò nomi di percorso che funzionano su sistemi Mac e Linux; per quanto riguarda Windows, dovrai cambiare `/usr/local/bin` con il percorso dell'eseguibile nel tuo ambiente.

Puoi scarucare P4Merge qua:

	http://www.perforce.com/perforce/downloads/component.html

Per iniziare dovrai impostare scripts esterni di wrapping per eseguire i tuoi comandi. Utilizzerò il percorso relativo a Mac per l'eseguibile; in altri sistemi, sarà dove è posizionato il binario `p4merge`. Imposta uno script per il wrapping del merge chiamato `extMerge` che chiami il binario con tutti gli argomenti necessari:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

Il wrapper per il diff controlla di assicurarsi che siano provveduti e passati sette argomenti: due per lo script di merge. Di default, Git passa i seguenti argomenti al programma di diff:

	path old-file old-hex old-mode new-file new-hex new-mode

Visto che vuoi solamente gli argomenti `old-file` e `new-file`, puoi notare che lo script di wrapping passa quelli di cui hai bisogno.

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Hai anche bisogno di assicurarti che questi strumenti siano eseguibili:

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

Ora puoi impostare il tuo file di configurazione per utilizzare gli strumenti personalizzati per diff e merge resolution. Questo richiede un certo numero di impostazioni personalizzate: `merge.tool` per comunicare a Git che strategia utilizzare, `mergetool.*.cmd` per specificare come eseguire i comandi, `mergetool.trustExitCode` per comunicare a Git se il codice di uscita del programma indichi o meno una risoluzione del merge andata a buon fine, e `diff.external` per comunicare a Git quale comando eseguire per i diffs. Quindi, puoi eseguire quattro comandi di configurazione:

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

in alternativa puoi modificate il file `~/.gitconfig` aggiungendo queste linee:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

Dopo aver impostato tutto ciò, se vengono eseguiti comandi diff come questo:

	$ git diff 32d1776b1^ 32d1776b1

Invece di visualizzare l'output del diff sulla linea di comando, Git eseguirà P4Merge che assomiglia alla Figura 7-1.

Insert 18333fig0701.png
Figura 7-1. P4Merge.

Se provi ad unire due rami e ne derivano dei conflitti, puoi eseguire il comando `git mergetool`; esegue P4Merge permettendoti di risolvere i conflitti tramite uno strumento con interfaccia grafica.

Una cosa simpatica riguardo questa configurazione con wrapper è che puoi cambiare gli strumenti di diff e merge in modo semplice. Ad esempio, per cambiare `extDiff` e `extMerge` in modo che eseguano lo strumento KDiff3, tutto ciò che devi fare è modificare il file `extMerge`:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

Ora, Git utilizzerà lo strumento KDiff3 per mostrare i diff e per la risoluzione di conflitti di merge.

Git è preconfigurato per utilizzare un numero di strumenti per la risoluzione di merge senza dover impostare una configurazione a linea di comando. Puoi impostare come mergetool: kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, o gvimdiff. Nel caso tu non sia interessato ad utilizzare KDiff3 per i diff ma comunque tu voglia usarlo per la risoluzione del merge ed il comando kdiff3 è nel tuo path, puoi eseguire:

	$ git config --global merge.tool kdiff3

Se esegui questo invece di impostare i files `extMerge` ed `extDiff`, Git utilizzerà KDiff3 per la risoluzione dei merge e lo strumento standard per i diffs.

### Formattazione e Whitespace ###

I problemdi di formattazione e di whitespaces sono tra i più frustranti ed insidiosi che molti sviluppatori incontrano quando collaborano, specialmente in cross-platform. È molto semplice per patches o altri lavori in collaborazione inserire astrusi cambiamenti whitespace perché gli editor li introducono impercettibilmente o programmatori Windows aggiungono carriage-return al termine delle righe che modificano in progetti cross-platform. Git ha alcune opzioni di configurazione per aiutare con questi problemi.

#### core.autocrlf ####

Nel caso tu stia programmando su Windows o utilizzando un altro sistema ma comunque qualcuno nel tuo gruppo utilizza Windows, probabilmente avrai problemi di line-editing ad un certo punto. Questo è dovuto al fatto che Windows utilizza sia caratteri carriage-return che linefeed per andare a capo nei suoi files, mentre i sistemi Mac e Linux utilizzano solo caratteri linefeed. Questo è un insidioso ed incredibilmente fastidioso problema del lavoro cross-platform.

Git può gestire questo convertendo in modo automatico righe CRLF in LF al momento del commit, vice versa quando estrae codice nel filesystem. Puoi attivare questa funzionalità tramite l'opzione `core.autocrlf`. Nel caso tu sia su una macchina windows impostalo a `true` — questo converte le terminazioni LF in CRLF nel momento in cui il codice viene estratto:

	$ git config --global core.autocrlf true

Nel caso tu sia su un sistema Linux o Mac che utilizza terminazioni LF, allora non vuoi che Git converta automaticamente all'estrazione dei files; comunque, se un file con terminazioni CRLF viene accidentalmente introdotto, allora potresti desiderare che Git lo ripari. Puoi comunicare a Git di convertire CRLF in LF nei commit ma un'altra via è impostare `core.autocrlf` in input:

	$ git config --global core.autocrlf input

Questa configurazione dovrebbe lasciare le terminazioni CRLF nei checkouts Windows e terminazioni LF nei sistemi Mac e Linux e nei repository.

Nel caso tu sia un programmatore Windows che lavora solo con progetti Windows, allora puoi disattivare questa funzionalità, inviando carriage-returns sul repository impostando il valore di configurazione a `false`:

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git è preimpostato per trovare e riparare i problemi di whitespace. Può cercare i quattro principali problemi di whitespace — due sono abilitati di default e possono essere disattivati, altri due non sono abilitati di default e possono essere attivati.

I due che sono attivi di default sono `trailing-space`, che cerca spazi alla fine della riga, e `space-before-tab`, che cerca spazi prima di tablature all'inizio della riga.

I due che sono disattivi di default ma possono essere attivati sono `indent-with-non-tab`, che cerca righe che iniziano con otto o più spazi invece di tablature, e `cr-at-eol`, che comunica a Git che i carriage returns alla fine delle righe sono OK.

Puoi comunicare a Git quale di questi vuoi abilitare impostando `core.whitespaces` al valore desiderato o off, separati da virgole. Puoi disabilitare le impostazioni sia lasciando l'impostazione fuori, sia antecedento un `-` all'inizio del valore. Ad esempio, se vuoi tutto attivato a parte `cr-at-eol`, puoi eseguire questo comando:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Git controllerà questi problemi quando viene eseguito un comando `git diff` e provi a colorarli in modo che si possa ripararli prima del commit. Utilizzerà anche questi valori per aiutarti quando applichi pathces tramite `git apply`. Quando stai applicando patches, puoi chiedere a Git di informarti se stai applicando patches con i problemi di whitespace specificati:

	$ git apply --whitespace=warn <patch>

Oppure puoi fare in modo che Git provi automaticamente a riparare i problemi prima di applicare la patch:

	$ git apply --whitespace=fix <patch>

Queste opzioni vengono applicate anche al comando `git rebase`. Se hai fatto commit con problemi di whitespace ma non ne hai fatto push in upstream, puoi eseguire un `rebase` con l'opzione `--whitespace=fix` per permettere a Git di riparare automaticamente i problemi di whitespace riscrivendo le patches.

### Server Configuration ###

Non sono disponibili molte opzioni per quanto riguarda la parte server di Git, ma alcune sono interessanti se vuoi prenderne nota.

#### receive.fsckObjects ####

Di default, Git non fa check di consistenza per tutti gli oggetti che riceve durante un push. Tuttavia Git può fare il check per assicurarsi che ogni oggetto corrisponda al suo checksum SHA-1 e punti ad un oggetto valido, non viene fatto di default ad ogni push. È un'operazione relativamente costosa e può aggiungere molto tempo ad ogni push, in dipendenza della dimensione del repository o del push. Se vuoi che Git esegua il check per la consistenza degli oggetti ad ogni push, puoi forzarlo impostando:

	$ git config --system receive.fsckObjects true

Ora, Git eseguirà un check di integrità del tuo repository prima che ogni push venga accettato, per assicurarsi che client difettosi non introducano dati corrotti.

#### receive.denyNonFastForwards ####

Se esegui rebase commits di cui hai già fatto push e poi provi nuovamente a farne un push, o altrimenti provi a fare push di un commit ad un ramo remoto che non contiene il commit a cui il ramo remoto punta, ti verrà proibito. Questa è una norma generalmente buona; tuttavia nel caso del rebase, potrebbe succedere che sai quello che stai facendo e puoi eseguire un force-update al branch remoto con un flag `-f` al comando push.

Per disabilitare la possibilità di eseguire force-update su rami remoti a riferimenti non-fast-forward, imposta `receive.denyNonFastForwards`:

	$ git config --system receive.denyNonFastForwards true

Un altro modo in cui puoi fare la stessa cosa è ricevere hooks via server-side, che copriremo tra poco. Questo approccio ti permette di eseguire azioni più complesse come impedire non-fast-forwards ad un certo sottoinsieme di utenti.

#### receive.denyDeletes ####

Uno dei workarounds che si possono fare alla norma `denyNonFastForwards` è che l'utente di cancelli il ramo e lo reinserisca con un nuovo riferimento. Nella nuova versione di Git (a partire dalla versione 1.6.1), puoi impostare `receive.denyDeletes` a true:

	$ git config --system receive.denyDeletes true

Questo nega branch e rimozione di tag su un push su tutta la linea — nessun utente può farlo. Per rimuovere rami remoti, devi rimuovere i files di riferimento dal server manualmente. Ci sono anche altri modi interessanti per farlo su una base per-user utilizzando le ACLs, come imparerai alla fine di questo capitolo.

## Attributi di Git ##

Alcune di queste impostazioni possono anche essere specificate per un percorso, per fare in modo che Git applichi queste impostazioni solo per una sottodirectory o un sottoinsieme di files. Queste opzioni path-specific sono chiamate attributi di Git e sono impostati nel file `.gitattributes` in una delle tue directories (normalmente nella radice del progetto) oppure nel file `.git/info/attributes` se non vuoi che venga fatto il commit del file degli attributi del tuo progetto.

Usando gli attributi, puoi fare cose come specificare strategie di merge separate per files individuali o directories nel tuo progetto, comunicare a Git come fare diff per files non di testo, oppure fare in modo che Git filtri il contenuto prima del check all'interno o all'esterno di Git. In questa sezione imparerai come impostare alcuni degli attributi sui tuoi percorsi, nel tuo progetto Git, e vedere alcuni esempi di come usare questa caratteristica nella pratica.

### Files Binari ###

Un trucco figo per il quale si possono usare gli attributi Git è comunicare a Git quali files siano binari (nel caso non sia capace di capirlo) e dargli istruzioni speciali riguardo a come gestire tali files. Per esempio, alcuni files di testo possono essere generati dalla macchina e non sottomissibili a diff, mentre altri files binari possono essere sottoposti a diff — vedremo come dire a Git cosa è cosa.

#### Identificare Files Binari ####

Alcuni files assomigliano a files di testo ma per il loro scopo vengono trattati come dati. Per esempio, i progetti Xcode di un Mac contengono un file che termina con `.pbxproj`, che è praticamente un dataset JSON (testo in chiaro nel formato javascript) scritto sul disco dall'IDE che registra i parametri di build e così via. Comunque tecnicamente è un file di testo, essendo tutto codice ASCII, non si vuole però trattarlo come tale perché è in realtà un leggero database — non è possibile eseguire un merge dei contenuti se due persone l'hanno modificato ed i diffs solitamente non sono d'aiuto. Il file è stato creato con lo scopo di essere usato dalla macchina. Infine lo si vuole trattare come un file binario.

Per comunicare a Git di trattare tutti i files `pbxproj` come files binari, bisogna aggiungere la riga seguente al file `.gitattributes`:

	*.pbxproj -crlf -diff

Ora Git non proverà più a convertire o sistemare i problemi CRLF; non proverà nemmeno a calcolare o stampare diff per i cambiamenti in questo file quando esegui git show o git diff sul progetto. Nella serie 1.6 di Git è fornita una macro che equivale ad utilizzare `-crlf -diff`:

	*.pbxproj binary

#### Diff di Files Binari ####

Nella serie 1.6 di Git, è possibile utilizzare funzionalità degli attributi Git per eseguire effettivamente diff di files binari. Questo può essere fatto comunicando a Git come convertire il file binario in formato testuale che possa essere comparato con un normale diff.

##### Files MS Word #####

Visto che questo è un metodo abbastanza figo e non molto conosciuto, lo analizzeremo con qualche esempio. Prima di tutto useremo questa tecnica per risolvere uno dei più fastidiosi problemi conosciuti dall'umanità: version-control per documenti Word. Ognuno sa che Word è il peggiore editor esistente; tuttavia, purtroppo, lo usano tutti. Se vogliamo eseguire il version-control per documenti Word, possiamo inserirli in un repository Git ed eseguire un commit ogni tanto; ma è un metodo così buono? Se eseguiamo `git diff` normalmente, vedremo solamente qualcosa del genere:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

Non possiamo confrontare direttamente due versioni a meno che non si estraggano e le si controlli a mano, giusto? Ne deriva che possiamo farlo meglio utilizzando gli attributi Git. Inseriamo la linea seguente nel file `.gitattributes`:

	*.doc diff=word

Questo comunica a Git che ogni file che corrisponde a questo pattern (.doc) deve utilizzare il filtro "word" nel caso si cerchi di visualizzarne un diff contenente modifiche. Cos'è il filtro "word"? Bisogna impostarlo. Ora configureremo Git per utilizzare il programma `strings` per convertire documenti Word in file di testo leggibili di cui possa fare un diff appropriato:

	$ git config diff.word.textconv strings

Questo comando aggiunge una sezione al file `.git/config` che assomiglia a questa:

	[diff "word"]
		textconv = strings

Nota bene: esistono diversi tipi di files `.doc`. Alcuni utilizzano codifica UTF-16 o altre "codepages" e `strings` non sarà in grado di trovare nulla di utile.

Ora Git è al corrente che se prova ad eseguire diff tra i due snapshot, e qualunque dei files termina in `.doc`, deve eseguire questi files tramite il filtro "word", che è definito come il programma `strings`. Questo li rende effettivamente delle simpatiche versioni di testo dei files Word prima di tentare di eseguire il diff.

Vediamo ora un esempio. Ho inserito il Capitolo 1 di questo libro all'interno di Git, aggiunto un po' di testo nel paragrafo, e salvato il documento. In seguito ho eseguito `git diff` per vederne i cambiamenti:

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

Git comunica in modo corretto e succinto che è stata aggiunta la stringa "Let’s see if this works", che è corretto. Non è perfetto — aggiunge un mucchio di altre cose alla fine — tuttavia certamente funziona. Se si vuole trovare o scrivere un convertitore Word-to-plain-text che lavori sufficientemente bene, la soluzione sarà incredibilmente efficace. Comunque, `strings` è disponibile per la maggior parte di sistemi Mac e Linux, quindi eseguirlo potrebbe essere una prima prova per molti files binari.

##### OpenDocument Text files #####

Lo stesso approccio usato per i file MS Word (`*.doc`) può essere utilizzato per i files di testo Opendocument (`*.odt`) creati da OpenOffice.org.

Agiungiamo la seguente riga al file `.gitattributes`:

	*.odt diff=odt

Ora impostiamo il filtro diff `odt` in `.git/config`:

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

I files di tipo OpenDocument sono in effetti cartelle compresse contenenti files (contenuto in formato XML, fogli di stile, immagini...). Bisogna quindi scrivere uno script che estragga il contenuto e lo restituisca come semplice testo. Creiamo un file `/usr/local/bin/odt-to-txt` (o anche in una directory differente) con il seguente contenuto:

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

Rendiamolo eseguibile:

	chmod +x /usr/local/bin/odt-to-txt

Ora `git diff` sarà in grado di comunicare cosa è cambiato nei files `.odt`.


##### Immagini #####

Un altro problema interessante che puoi risolvere in questo modo è eseguire diff di immagini. Un modo per farlo è di elaborare i files PNG tramite un filtro che ne estragga le informazioni EXIF — metadati codificati nella maggior parte dei formati delle immagini. Se scarichiamo ed installiamo il programma `exiftool`, possiamo utilizzarlo per convertire le immagini in testo riguardante i metadati, quindi il diff mostrerà almeno una rappresentazione testuale di cosa è successo:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Se si rimpiazza un'immagine nel progetto e si esegue `git diff`, si ottiene qualcosa del genere:

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

Si può semplicemente vedere che la dimensione ed il peso dell'immagine sono entrambe cambiati.

### Keyword Expansion ###

Gli sviluppatori abituati a sistemi come CVS o SVN richiedono spesso una keyword expansion tipica di quei sistemi. Il problema maggiore con questo su Git è che non è possibile modificare un file con informazioni per il commit dopo aver eseguito il commit, perché Git esegue prima un check del file. Comunque, è possibile inserire testo all'interno del file quando viene estratto e rimuoverlo prima che venga aggiunto al commit. Gli attributi Git forniscono due modi per farlo.

Innanzitutto, è possibile inserire il checksum SHA-1 di una bolla in un campo `$Id$` del file in modo automatico. Se si imposta questo attributo in un file o insieme di files, allora la prossima volta verrà eseguito un check out di quel ramo, Git rimpiazzerà quel campo con lo SHA-1 della bolla. È importante notare che non è lo SHA del commit, ma della bolla stessa:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

La prossima volta che eseguiremo un check out di questo file, Git inserirà lo SHA della bolla:

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Comunque, questo risultato è di utilizzo limitato. Se hai usato la keyword substitution di CVS o Subversion, puoi includere un datastamp — lo SHA non è così utile, perché è un numero praticamente casuale e non puoi sapere se uno SHA sia o meno precedente di un altro.

Ne consegue che puoi scrivere i tuoi filtri per eseguire sostituzioni nei commit/checkout dei files. Questi sono i filtri "clean" e "smudge". Nel file `.gitattributes`, puoi impostare un filtro per un percorso particolare e quindi impostare gli scripts che processano files appena prima che ne venga eseguito un checkout ("smudge", vedi Figura 7-2) ed appena prima che ne venga eseguito un commit ("clean", vedi figura 7-3). Questi filtri possono essere impostati per fare tutte queste cose divertenti.

Insert 18333fig0702.png
Figura 7-2. Filtro “smudge” eseguito al checkout.

Insert 18333fig0703.png
Figura 7-3. Filtro “clean” eseguito quando viene fatto lo stage dei files.

Il messaggio originale di commit per questa funzionalità fornisce un semplice esempio dell'eseguire tutto il nostro codice C durante il programma `indent` prima del commit. Puoi impostarlo assegnando all'attributo filter in `.gitattributes` il compito di filtrare files `*.c` con il filtro "indent":

	*.c     filter=indent

Diciamo poi a Git cosa farà il filtro "indent" in smudge e clean:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

In questo caso, quando verranno fatti commit di files che corrispondono a `*.c`, Git li eseguirà attraverso il programma indent prima di farne commits e quindi passarli al programma `cat` prima di rifarne un check nel disco. Il programma `cat` è praticamente una non-operazione: restituisce gli stessi dati che riceve in ingresso. Questa combinazione effettivamente filtra tutto il codice C tramite `indent` prima del commit.

Un altro esempio interessante è la keyword expansion `$Date$`, in stile RCS. Per farlo in modo appropriato, bisogna avere un piccolo script che dato in ingresso il nome di un file ne capisca la data dell'ultimo commit, ed inserisca la data nel file. Ad esempio questo è un piccolo script Ruby che esegue il compito:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Lo script preleva la data dell'ultimo commit tramite il comando `git log`, lo allega ad ogni stringa `$Date$` che trova in stdin, stampa il risultato — dovrebbe essere semplice da fare in ogni linguaggio con cui siete pratici. Questo file può essere chiamato `expand_date` ed essere posizionato nel path. Ora bisogna impostare un filtro in Git (chiamato `dater`) e comunicare di utilizzare il filtro `expand_date` per eseguire uno smudge dei files in checkout. Utilizzeremo un'espressione Perl per pulirlo al commit:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Questo frammento di Perl toglie qualsiasi cosa veda nella stringa `$Date$`, per tornare al punto di partenza. Ora che il filtro è pronto, è possibile provarlo costruendo un file con la keyword `$Date$` e quindi impostare un attributo Git per il file che richiami il nuovo filtro:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

Se esegui un commit per questi cambiamenti e quindi fai un checkout del file, noterai che la keyword è stata sostituita:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Si può vedere quanto sia potente questa tecnica per applicazioni personalizzate. Bisogna però prestare attenzione, infatti del file `.gitattributes` viene eseguito un commit e viene distribuito insieme al progetto, tuttavia non si può dire la stessa cosa per quanto riguarda il driver (in questo caso, `dater`); quindi non funzionerà ovunque. Quando costruisci questi filtri, dovrebbero essere in grado di non fallire in modo drastico e permettere al progetto di continuare a funzionare in modo appropriato.

### Esportare il Repository ###

Gli attributi Git permettono inoltre di attuare operazioni interessanti quando si esporta un archivio del proprio progetto.

#### export-ignore ####

È possibile comunicare a Git di non esportare alcuni files o directories quando si genera un archivio. Nel caso ci sia una sottodirectory o file che non si vuole includere nell'archivio ma che si vuole comunque tenere nel progetto, è possibile determinare questi files tramite l'attributo `export-ignore`.

Per esempio, diciamo di avere dei files per i test in una sottodirectory `test/`, non avrebbe senso includerla in un tarball del progetto. È possibile aggiungere la seguente riga al file Git attributes:

	test/ export-ignore

Ora, quando verrà eseguito git archive per creare la tarball del progetto, la directory non sarà inclusa nell'archivio.

#### export-subst ####

Un'altra cosa che è possibile fare per gli archivi è qualche semplice keyword substitution. Git permette di inserire la stringa `$Format:$` in ogni file con uno qualsiasi degli shortcodes di formattazione `--pretty=format`, dei quali ne abbiamo visti alcuni nel Capitolo 2. Per esempio, nel caso si voglia includere un file chiamato `LAST_COMMIT` nel progetto, e l'ultima data di commit è stata inserita automaticamente al suo interno all'esecuzione di `git archive`, è possibile impostare il file in questo modo:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

All'esecuzione di `git archive`, il contenuto del file quando qualcuno aprirà l'archivio sarà di questo tipo:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge Strategies ###

È possibile inoltre utilizzare attributi Git per comunicare a Git di utilizzare differenti strategie di merge per files specifici nel progetto. Un opzione molto utile è comunicare a Git di non provare ad eseguire merge di files specifici quando sussistono conflitti, ma, invece, di la propria parte di merge sopra quella di qualcun altro.

Questo è utile se un ramo nel progetto presenta divergenze o è specializzato, ma si vuole essere in grado di fare merge dei cambiamenti su di esso, e si vogliono ignorare alcuni files. Diciamo di avere un database di opzioni chiamato database.xml che è differente in due rami, e si vuole eseguire un marge nell'altro ramo senza fare confusione all'interno del database. È possibile impostare un attributo in questo modo:

	database.xml merge=ours

Nel caso si voglia fare un merge nell'altro ramo, invece di avere conflitti di merge con il file database.xml, si noterà qualcosa di simile a:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In questo caso, database.xml rimarrà a qualsiasi versione si aveva in origine.