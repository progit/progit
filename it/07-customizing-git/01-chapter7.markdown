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