# Strumenti di Git #

Finora hai imparato la maggior parte dei comandi d’uso quotidiani e i flussi di lavoro che devi conoscere per gestire o mantenere un repository Git per i tuoi sorgenti. Hai eseguito le attività di base per tracciare e committare i file, hai sfruttato il potere dell' *area di assemblamento* e le diramazioni (*branch*) e le unioni (*merge*) leggere.

Ora vedremo una serie di cose molto potenti di Git che potresti non usare quotidianamente, ma di cui a un certo punto potresti averne bisogno.

## Selezione della revisione ##

Git ti permette di specificare una o più *commit* in diversi modi. Non sono sempre ovvi, ma è utile conoscerli.

### Singole versioni ###

Puoi fare riferimento a una singola commit usando l’hash SHA-1 attribuito, ma ci sono altri metodi più amichevoli per fare riferimento a una *commit*. Questa sezione delinea i modi con cui ci si può riferire a una singolo commit.

### SHA breve ###

Git è abbastanza intelligente da capire a quale *commit* ti riferisci se scrivi i primi caratteri purché il codice SHA-1 sia di almeno quattro caratteri e sia univoco: ovvero che uno solo degli oggetti nel *repository* inizi con quel SHA-1.

Per vedere per esempio una specifica *commit*, immagina di eseguire 'git log' e trovi la *commit* dove sono state aggiunte determinate funzionalità:

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

In questo caso scegli '1c002dd....'. Se vuoi eseguire 'git show' su quella *commit*, i seguenti comandi sono equivalenti (assumendo che le versioni più brevi siano univoche):            

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git riesce a capire un valore SHA-1 intero da uno corto, abbreviato. Se usi l’opzione '--abbrev-commit' col comando 'git-log', l'*output* userà valori più corti ma garantirà che siano unici: di default usa sette caratteri ma ne userà di più se sarà necessario per mantenere l’univocità del valore SHA-1:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Da otto a dieci caratteri sono, generalmente, più che sufficienti per essere univoci all'interno di un progetto. Uno dei progetti Git più grandi, il kernel di Linux, inizia a necessitare 12 caratteri, dei 40 possibili, per essere univoco.

### Una breve nota su SHA-1 ###

Molte persone si preoccupa che a un certo punto, in modo del tutto casuale, ci possano essere due oggetti nel tuo *repository* che abbiano lo stesso SHA-1. Cosa succederebbe?

Se dovessi committare un oggetto che abbia lo stesso hash SHA-1 di un altro oggetto che sia già nel tuo repository, Git troverà l'altro oggetto già nel database di Git e lo considererà già scritto. Se in seguito vorrai scaricare quest'ultimo ogetto, otterrai sempre le informazioni del più vecchio.

Dovresti comunque essere consapevole che questo sia uno scenario molto improbabile. Il codice SHA-1 è di 20 bytes o 160 bits. Il numero di oggetti casuali necessari perché ci sia la probabilità del 50% di una singola collisione è di circa 2^80 (la formula per determinare la probabilità di collisione è `p = (n(n-1)/2) * (1/2^160)`). 2^80 è 1.2 x 10^24 ovvero 1 milione di miliardi di miliardi. È 1.200 volte il numero di granelli di sabbia sulla terra.

Ecco un esempio per dare un'idea di cosa ci vorrebbe per ottenere una collisione SHA-1. Se tutti i 6.5 miliardi di esseri umani sulla Terra programmassero e, ogni secondo, ognuno scrivesse codice che sia equivalente all'intera cronologia del kernel Linux (1 milione di oggetti Git) e ne facesse la push su un enorme *repository* Git, ci vorrebbero 5 anni per contenere abbastanza oggetti in quel *repository* per avere il 50% di possibilità di una singola collisione di oggetti SHA-1. Esiste una probabilità più alta che ogni membro del tuo gruppo di sviluppo, in incidenti non correlati venga attaccato e ucciso da dei lupi nella stessa notte.

### Riferimenti alle diramazioni ###

Il modo più diretto per specificare una *commit* è avere una diramazione (*branch* in inglese) che vi faccia riferimento, che ti permetterebbe di usare il nome della diramazione in qualsiasi comando Git che richieda un oggetto *commit* o un valore SHA-1. Se per esempio vuoi vedere l'ultima *commit* di una diramazione, i comandi seguenti sono equivalenti (supponendo che la diramazione 'topic1' punti a 'ca82a6d'):

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Se vuoi vedere a quale SHA specifico punti una diramazione, o se vuoi vedere a quali SHA puntino questi esempi, puoi usare il comando 'rev-parse' di Git, che fa parte dei comandi sottotraccia (*plumbing* in inglese) . Nel Capitolo 9 trovi maggiori informazioni sui comandi sottotraccia ma, brevemente, 'rev-parse' esiste per operazioni di basso livello e non è concepito per essere usato nelle operazioni quotidiane. Può comunque essere d'aiuto quando hai bisogno di vedere cosa sta succedendo davvero. Qui puoi quindi eseguire 'rev-parse' sulla tua diramazione.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### Nomi brevi dei riferimenti ###

Una delle cose che Git fa dietro le quinte è aggiornare il registro dei riferimenti (*reflog* in inglese), che registra la posizione dei tuoi riferimenti HEAD e delle diramazione su cui hai lavorato negli ulti mesi.

Puoi consultare il registro con il comando 'git reflog':

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

Ogni volta che una diramazione viene aggiornata per qualsiasi ragione, Git memorizza questa informazione in questa cronologia temporanea. E puoi anche specificare *commit* più vecchie. Se vuoi vedere la cronologia a partire dalla quintultima commit a partire dalla *HEAD* del tuo *repository*, puoi usare il riferimento '@{n}' che vedi nel *output* del registro:

	$ git show HEAD@{5}

Puoi anche usare questa sintassi per vedere dov'era una diramazione a una certa data. Se vuoi vedere, per esempio, dov'era ieri la diramazione 'master' puoi scrivere:

	$ git show master@{yesterday}

Che mostra dov'era ieri la diramazione. Questa tecnica funziona solo per i dati che sono ancora nel registri e non puoi quindi usarla per vedere *commit* più vecchie di qualche mese.

Per vedere le informazioni del registro formattate come l’output di `git log`, puoi eseguire il comando `git log -g`:

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

E' importante notare che l'informazione del registro è solamente locale: è un registro di ciò che hai fatto nel tuo *repository*. I riferimenti non saranno uguali sui cloni degli altri. Appena dopo aver clonato un *repository* il tuo registro sarà vuoto perché non è successo ancora nulla nel tuo *repository*. Potrai eseguire 'git show HEAD@{2.months.ago}' solo se hai clonato il progetto almeno due mesi fa: se è stato clonato cinque minuti fa non otterrai nessun risultato.

### Riferimenti ancestrali ###

L'altro modo principale per specificare una *commit* è attraverso i suoi ascendenti. Se metti un `^` alla fine di un riferimento, Git lo risolve interpretandolo come il padre padre di quella determinata *commit*.
Immagina di vedere la cronologia del tuo progetto:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Puoi quindi vedere la *commit* precedente specificando `HEAD^`, che significa "l'ascendente di HEAD":

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Puoi specificare anche un numero dopo la `^`: per esempio `d921970^2` significa "il secondo ascendente di d921870." Questa sintassi è utile solo per incorporare delle *commit* che hanno più di un ascendente. Il primo ascendente è la diramazione dove ti trovi al momento dell'incorporamento, e il secondo è la *commit* sulla diramazione da cui hai fatto l'incorporamento:

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

Un altro modo di specificare un riferimento ancestrale è la `~`. Questo si riferisce anche al primo ascendente, quindi `HEAD~` e `HEAD^` sono equivalenti. La differenza diventa evidente quando specifichi un numero. `HEAD~2` significa "il primo ascendente del primo ascendente", o "il nonno”: attraversa i primi ascendenti il numero di volte specificato. Per esempio, nella cronologia precedente, `HEAD~3` sarebbe

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Che può essere scritto anche come `HEAD^^^` che, di nuovo, è sempre il primo genitore del primo genitore del primo genitore:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

È anche possibile combinare queste sintassi: puoi prendere il secondo genitore del riferimento precedente (assumendo che si tratti di una commit d'incorporamento) usando `HEAD~3^2`, e così via.

### Intervalli di commit ###

Ora che sai come specificare singole commit, vediamo come specificare intervalli di commit. Ciò è particolarmente utile per gestire le tue diramazioni: se ne hai molte puoi usare gli intervalli per rispondere a domande come “cosa c’è in questa diramazione che non ho ancora incorporato?”

#### Due punti ####

Il modo più comune per specificare un intervallo è con i due punti che, praticamente, chiede a Git di risolvere l’intervallo tra commit che sia raggiungibile da una commit, ma non dall’altra. Immaginiamo di avere la cronologia dell’immagine 6-1

Insert 18333fig0601.png
Figure 6-1. Esempio di cronologia per la selezione di intervalli.

Vuoi vedere cosa sia nella tua diramazione sperimentale che non sia ancora stato incorporato nella master: puoi chiedere a Git di mostrarti solo il registro delle commit con `master..experiment`: questo significa “tutte le commit raggiungibili da experiment che non lo siano da master”. Affinché questi esempi siano sintetici ma chiari, invece del registro effettivo di Git, userò le lettere degli oggetti commit del diagramma:

	$ git log master..experiment
	D
	C

Se volessi invece vedere il contrario, ovvero tutte le commit in `master` che non siano in `experiment`, puoi invertire i nomi dei branch: `experiment..master` ti mostra tutto ciò che è in `master` e che non sia raggiungibile da `experiment`:

	$ git log experiment..master
	F
	E

Questo è utile se vuoi mantenere aggiornata la diramazione `experiment` e sapere cosa stai per incorporare. Un’altro caso in cui si usa spesso questa sintassi è quando stai per condividere delle commit verso un repository remoto:

	$ git log origin/master..HEAD

Questo comando mostra tutte le commit della tua diramazione che non sono in quella `master` del tuo repository remoto `origin`. Se esegui `git push` quando la tua diramazione attuale è associata a `origin/master`, le commit elencate da `git log origin/master..HEAD` saranno quelle che saranno inviate al server.
Puoi anche omettere una delle parti della sintassi, e Git assumerà che sia HEAD. Per esempio puoi ottenere lo stesso risultato dell’esempio precedente scrivendo `git log origin/master..`: Git sostituisce la parte mancante con HEAD.

#### Punti multipli ####

La sintassi dei due punti è utile come la stenografia, ma potresti voler specificare più di due branch per indicare la tua revisione, per vedere le commit che sono nelle varie diramazioni che non siano in quella attuale. Git ti permette di farlo sia con `^` che con l’opzione `--not` prima di ciascun riferimento del quale vuoi vedere le commit raggiungibili. Quindi questi tre comandi sono equivalenti:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Questo è interessante, perché con questa sintassi puoi specificare più di due riferimenti nella tua richiesta, cosa che non puoi fare con i due punti. Se per esempio vuoi vedere tutte le commit che siano raggiungibili da `refA` o da `refB` ma non da `refC` puoi usare una delle seguenti alternative:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Questo produce un sistema di revisione molto potente che dovrebbe aiutarti a capire cosa c’è nelle tue diramazioni.

#### Tre punti ####

L’ultima sintassi per la selezione di intervalli è quella dei tre punti, che indica tutte le commit raggiungibili da uno qualsiasi dei riferimenti ma non da entrambi. Rivedi la cronologia delle commit nella Figura 6-1.
Se vuoi vedere cosa ci sia nel `master` o in `experiment` ma non i riferimenti comuni, puoi eseguire

	$ git log master...experiment
	F
	E
	D
	C

Che ti mostra l’output normale del `log` mostrando solo le informazioni di quelle quattro commit nell'ordinamento cronologico normale.

Un'opzione comunemente usata in questi casi con il comando `log` è il parametro `--left-right`, che mostra da che lato dell'intervallo si trovi ciascuna commit dell’intervallo selezionato, che rende le informazioni molto più utili:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Con questi strumenti puoi dire facilmente a Git quale o quali commit vuoi ispezionare.

## Assemblaggio interattivo ##

Git viene distribuito con un paio di script che rendono più semplice l'uso della riga di comando. In questo capitolo vedremo alcuni comandi interattivi che possono aiutarti a modellare le tue commit perché includano solo determinate combinazioni di parti dei file. Questi strumenti sono molto utili se modifichi molti file tutti assieme e poi decidi che vuoi distribuire le modifiche in più commit puntuali, piuttosto che un'unica grossa commit confusa. In questo modo puoi fare che le tue commit separino logicamente le tue modifiche e possano essere facilmente revisionate dagli altri sviluppatori con cui lavori.
Se esegui `git add` con le opzioni `-i` o `--interactive`, Git entrerà nella modalità interattiva, mostrandoti qualcosa del genere:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

Come vedi, questo comando mostra una vista della tua area di assemblaggio molto diversa: sono le stesse informazioni che otterà con il comando `git status`, ma in maniera più succinta e con più informazioni. Sulla sinistra mostra le modifiche che stai assemblando e quelle non ancora assemblate sulla destra.

Dopo questa sezione c'è quella dei Comandi. Qui puoi fare una serie di cose, incluso assemblare file, disassemblarli, assemblare alcune parti dei file, aggiungere file non ancora tracciati e vedere le differenze con ciò che è già stato assemblato.

### Assemblare e disassemblare file ###

Se digiti `2` o `u` alla richiesta `What now>`, lo script ti chiederà quale file vuoi assemblare:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Per assemblare i file TODO e index.html, puoi digitare i numeri:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

L'asterisco (`*`) vicino a ogni file, significa che è stato selezionato per essere assemblato. Se premi INVIO alla richiesta `Update>>`, Git assembla tutto ciò che è stato selezionato:

	Update>>
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Ora puoi vedere che i file TODO e index.html sono assemblati e simplegit.rb non lo è ancora. Se ora vuoi disassemblare il file TODO, devi digitare `3` o `r` (come `revert` - annullare):

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

Rivedendo lo stato di Git, puoi vedere che hai disassemblato il file TODO:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Per vedere le differenze di ciò che hai assemblato puoi digitare `6` o `d` (come differenza). Ti mostrerà un elenco dei tuoi file assemblati, e potrai selezionare quelli di cui vuoi vedere le modifiche assemblate. Questo fa la stessa cosa del comando `git diff --cached`:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

Con questi comandi elementari puoi usare la modalità interattiva per interaggire un po' più facilmente con l'area di assemblagio.

### Assemblare i pezzi ###

Git può anche assemblare solo alcune parti di un file e non il resto. Se per esempio fai due modifiche al tuo simplegit.rb file e vuoi assemblarne solo una, con Git puoi farlo molto semplicemente. Al `prompt` digita `5` o `p` (come pezzo, `patch` ndt). Git ti chiederà quali file vuoi assemblare parzialmente e, per ciascuna sezione dei file selezionati, mostrerà blocchi di differenze chiedendoti se vuoi assemblarle, una per una:

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]?

A questo punto hai molte opzioni. Digitando `?` vedrai la lista di ciò che puoi fare:

	Assemblare questo blocco [y,n,a,d,/,j,J,g,e,?]? ?
	y - assembla questo blocco
	n - non assemblare questo blocco
	a - assembla questo blocco e tutti gli altri rimanenti nel file
	d - non assemblare questo blocco né gli altri rimanenti nel file
	g - seleziona un blocco per continuare
	/ - cerca un blocco con una regex
	j - salta questo blocco e vedi il successivo saltato
	J - salta questo blocco e vedi il prossimo blocco
	k - salta questo blocco e vedi il precedente saltato
	K - salta questo blocco e vedi il blocco precedente
	s - dividi il blocco attuale in blocchi più piccoli
	e - modifica manualmente il blocco attuale
	? - mostra l'aiuto

Generalmente digiterai `y` o `n` se vuoi assemblare tutti i blocchi, ma assemblare tutti quelli di un file o saltarne qualcuno per decidere in un secondo momento può essere molto prezioso. Se assembli solo alcuni blocchi di un file ma non gli altri, lo stato del tuo repository sarà così:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

È interessante lo stato di simplegit.rb, dove alcune righe sono assemblate ma non le altre. Hai assemblato parzialmente questo file. A questo punto puoi uscire dall'area interattiva ed eseguire `git commit` per committare la parte di file assemblata.

Non devi essere nell'area interattiva per assemblare solo una parte di un file: puoi avviare lo stesso script dalla riga di comando con `git add -p` o `git add --patch`.

## Accantonare ##

Spesso, mentre stai lavorando ad una parte del tuo progetto, le cose possono essere in uno stato confusionario e tu vuoi passare a un'altra ramificazione per lavorare per un po' a qualcosa di diverso. Il problema è che non vuoi committare qualcosa fatta a metà per poi tornarci in un secondo momento. La risposta a questo problema è il comando `git stash`.

Questo comando prende tutte le modifiche della tua cartella di lavoro — cioè tutti i file tracciati che hai modificato e le modifiche assemblate — e le accantona in una pila di modifiche incomplete che puoi riapplicare in qualsiasi momento.

### Accantona il tuo lavoro ###

Per dimostrare come funziona, vai nella cartella del tuo progetto e modifica un paio di file e assemblane alcuni. Se esegui `git status`, puoi vederne lo stato "sporco":

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Ora vuoi passare a un'altra diramazione, ma non vuoi ancora committare il tuo lavoro perché non è ancora pronto; accantona quindi le tue modifiche. Per aggiungere un nuovo livello alla pila devi eseguire `git stash`:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

La tua cartella di lavoro ora è pulita:

	$ git status
	# On branch master
	nothing to commit, working directory clean

A questo punto puoi passare facilmente a un'altra diramazione e lavorare ad altro; le tue modifiche sono salvate nella tua pila di accantonamento. Per vedere cosa c'è nella tua pila usa `git stash list`:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

In questo caso hai due accantonamenti precedenti, e hai così accesso a tre lavori differenti accantonati. Puoi riapplicare quello che hai appena accantonato usando il comando mostrato nell'output d'aiuto del comando che hai usato quanto hai accantonato le tue modifiche: `git stash apply`. Se vuoi applicare uno degli accantonamenti precedenti, puoi specificarlo usandone il nome così: `git stash apply stash@{2}`. Se non specifiche un accantonamento Git suppone che ti riferisca all'ultimo e prova ad applicarlo:

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Puoi vedere che Git ha rimodificato i file che aveva rimosso quando hai salvato l'accantonamento. In questo caso avevi una cartella di lavoro pulita quando provasti ad applicare l'accantonamento e stai provando a riappricarlo alla stessa ramificazione da cui l'avevi salvato; ma non è necessario avere una cartella pulita per applicare un accantonamento né che sia la stessa ramificazione. Puoi salvare un accantonamento da una ramificazione, passare a un'altra e applicare le modifiche accantonate. Nella tua cartella puoi anche avere modifiche non ancora committate quando applichi un accantonamento: Git ti darà un conflitto d'incorporamento nel caso che qualcosa non si possa applicare senza problemi.

Le modifiche vengono riapplicate ai tuoi file, ma quello che avevi assemblato ora non lo sono. Per farlo devi eseguire il comando `git stash apply` con il parametro `--index` perché provi a riapplicare le modifiche assemblate. Se lo avessi fatto ti saresti trovato nella stessa posizione originale:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

L'opzione `apply` prova solo ad applicare le modifiche assemblate: continua per averle nel tuo accantonamento. Per cancellare l'accantonamento devi eseguire `git stash drop` con il nome dell'accantonamento da rimuovere:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Puoi eseguire anche `git stash pop` per applicare l'accantonamento e cancellare immediatamente dopo.

### Annullare una modifica accantonata ###

In alcuni scenari potresti voler applicare delle modifiche accantonate, fare dell'altro lavoro e successivamente voler rimuovere le modifiche che venivano dall'accantonamento. Git non ha un comando `stash unapply`, ma è possibile ottenere lo stesso risultato richiamando la modifica associata all'accantonamento e applicarla al contrario:

    $ git stash show -p stash@{0} | git apply -R

Di nuovo, se non specifichi un accantonamento, Git assume che sia l'ultimo:

    $ git stash show -p | git apply -R

Puoi voler creare un alias per avere un comando `stash-unapply` nel tuo Git. Per esempio:

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

### Creare una diramazione da un accantonamento ###

Se accantoni del lavoro e lo lasci lì mentre continui a lavorare per un po' nella diramazione da cui hai creato l'accantonamento, potresti avere dei problemi a riapplicarlo. Se l'applicazione prova a modificare un file che avevi modificato successivamente, otterrai un conflitto d'incorporazione e dovrai risolverlo. Se vuoi un modo facile per ritestare le modifiche accantonate, puoi eseguire il comando `git stash branch`, che crea una diramazione, scarica la commit dov'eri quando hai accantonato il tuo lavoro, lo riapplica e, se ci riesce senza problemi, cancella l'accantonamento:

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Questa è una bella accorciatoioa per recuperare il lavoro accantonato e lavorarci in una nuova diramazione.

## Riscrivere la storia ##

Molto spesso, lavorando con Git, you may want to revise your commit history for some reason. One of the great things about Git is that it allows you to make decisions at the last possible moment. You can decide what files go into which commits right before you commit with the staging area, you can decide that you didn’t mean to be working on something yet with the stash command, and you can rewrite commits that already happened so they look like they happened in a different way. This can involve changing the order of the commits, changing messages or modifying files in a commit, squashing together or splitting apart commits, or removing commits entirely — all before you share your work with others.

In this section, you’ll cover how to accomplish these very useful tasks so that you can make your commit history look the way you want before you share it with others.
<!-- da tradurre fino a riga 840 -->
### Changing the Last Commit ###

Changing your last commit is probably the most common rewriting of history that you’ll do. You’ll often want to do two basic things to your last commit: change the commit message, or change the snapshot you just recorded by adding, changing and removing files.

If you only want to modify your last commit message, it’s very simple:

	$ git commit --amend

That drops you into your text editor, which has your last commit message in it, ready for you to modify the message. When you save and close the editor, the editor writes a new commit containing that message and makes it your new last commit.

If you’ve committed and then you want to change the snapshot you committed by adding or changing files, possibly because you forgot to add a newly created file when you originally committed, the process works basically the same way. You stage the changes you want by editing a file and running `git add` on it or `git rm` to a tracked file, and the subsequent `git commit --amend` takes your current staging area and makes it the snapshot for the new commit.

You need to be careful with this technique because amending changes the SHA-1 of the commit. It’s like a very small rebase — don’t amend your last commit if you’ve already pushed it.

### Changing Multiple Commit Messages ###

To modify a commit that is farther back in your history, you must move to more complex tools. Git doesn’t have a modify-history tool, but you can use the rebase tool to rebase a series of commits onto the HEAD they were originally based on instead of moving them to another one. With the interactive rebase tool, you can then stop after each commit you want to modify and change the message, add files, or do whatever you wish. You can run rebase interactively by adding the `-i` option to `git rebase`. You must indicate how far back you want to rewrite commits by telling the command which commit to rebase onto.

For example, if you want to change the last three commit messages, or any of the commit messages in that group, you supply as an argument to `git rebase -i` the parent of the last commit you want to edit, which is `HEAD~2^` or `HEAD~3`. It may be easier to remember the `~3` because you’re trying to edit the last three commits; but keep in mind that you’re actually designating four commits ago, the parent of the last commit you want to edit:

	$ git rebase -i HEAD~3

Remember again that this is a rebasing command — every commit included in the range `HEAD~3..HEAD` will be rewritten, whether you change the message or not. Don’t include any commit you’ve already pushed to a central server — doing so will confuse other developers by providing an alternate version of the same change.

Running this command gives you a list of commits in your text editor that looks something like this:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

It’s important to note that these commits are listed in the opposite order than you normally see them using the `log` command. If you run a `log`, you see something like this:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Notice the reverse order. The interactive rebase gives you a script that it’s going to run. It will start at the commit you specify on the command line (`HEAD~3`) and replay the changes introduced in each of these commits from top to bottom. It lists the oldest at the top, rather than the newest, because that’s the first one it will replay.

You need to edit the script so that it stops at the commit you want to edit. To do so, change the word pick to the word edit for each of the commits you want the script to stop after. For example, to modify only the third commit message, you change the file to look like this:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

When you save and exit the editor, Git rewinds you back to the last commit in that list and drops you on the command line with the following message:

<!-- This is actually weird, as the SHA-1 of 7482e0d is not present in the list, 
nor is the commit message. Please review 
-->

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

These instructions tell you exactly what to do. Type

	$ git commit --amend

Change the commit message, and exit the editor. Then, run

	$ git rebase --continue

This command will apply the other two commits automatically, and then you’re done. If you change pick to edit on more lines, you can repeat these steps for each commit you change to edit. Each time, Git will stop, let you amend the commit, and continue when you’re finished.

### Reordering Commits ###

You can also use interactive rebases to reorder or remove commits entirely. If you want to remove the "added cat-file" commit and change the order in which the other two commits are introduced, you can change the rebase script from this

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

to this:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

When you save and exit the editor, Git rewinds your branch to the parent of these commits, applies `310154e` and then `f7f3f6d`, and then stops. You effectively change the order of those commits and remove the "added cat-file" commit completely.

### Squashing Commits ###

It’s also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool. The script puts helpful instructions in the rebase message:

	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

If, instead of "pick" or "edit", you specify "squash", Git applies both that change and the change directly before it and makes you merge the commit messages together. So, if you want to make a single commit from these three commits, you make the script look like this:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

When you save and exit the editor, Git applies all three changes and then puts you back into the editor to merge the three commit messages:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

When you save that, you have a single commit that introduces the changes of all three previous commits.

### Splitting a Commit ###

Splitting a commit undoes a commit and then partially stages and commits as many times as commits you want to end up with. For example, suppose you want to split the middle commit of your three commits. Instead of "updated README formatting and added blame", you want to split it into two commits: "updated README formatting" for the first, and "added blame" for the second. You can do that in the `rebase -i` script by changing the instruction on the commit you want to split to "edit":

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

When you save and exit the editor, Git rewinds to the parent of the first commit in your list, applies the first commit (`f7f3f6d`), applies the second (`310154e`), and drops you to the console. There, you can do a mixed reset of that commit with `git reset HEAD^`, which effectively undoes that commit and leaves the modified files unstaged. Now you can take the changes that have been reset, and create multiple commits out of them. Simply stage and commit files until you have several commits, and run `git rebase --continue` when you’re done:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git applies the last commit (`a5f4a0d`) in the script, and your history looks like this:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Once again, this changes the SHAs of all the commits in your list, so make sure no commit shows up in that list that you’ve already pushed to a shared repository.

### The Nuclear Option: filter-branch ###

There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit.  The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite.  However, it can be very useful. You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of.

#### Removing a File from Every Commit ####

This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your project open source. `filter-branch` is the tool you probably want to use to scrub your entire history. To remove a file named passwords.txt from your entire history, you can use the `--tree-filter` option to `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

The `--tree-filter` option runs the specified command after each checkout of the project and then recommits the results. In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch --tree-filter "rm -f *~" HEAD`.

You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end. It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want. To run `filter-branch` on all your branches, you can pass `--all` to the command.

#### Making a Subdirectory the New Root ####

Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on). If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Now your new project root is what was in the `trunk` subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory.

#### Changing E-Mail Addresses Globally ####

Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address. In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well. You need to be careful to change only the e-mail addresses that are yours, so you use `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address.

### The Very Fast Nuclear Option: Big Friendly Giant Repo Cleaner (BFG) ###

[Roberto Tyley](https://github.com/rtyley) has written a similar tool to `filter-branch` called the BFG. BFG cannot do as much as `filter-branch`, but it is _very_ fast and on a large repository this can make a big difference. If the change you want to make is in the scope of BFG capaility, and you have performance issues, then you should consider using it.

See the [BFG](http://rtyley.github.io/bfg-repo-cleaner/) website for details.

## Debugging with Git ##

Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.

### File Annotation ###

If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22:

	$ git blame -L 12,22 simplegit.rb
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.

Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:

	$ git blame -C -L 141,153 GITPackUpload.m
	f344f58d GITServerHandler.m (Scott 2009-01-04 141)
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file.

### Binary Search ###

Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.

Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:

	$ git bisect reset

This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.

## Moduli ##

Capita spesso che, mentre stai lavorando a un progetto, debba includerne un altro. Potrebbe essere una libreria sviluppata da terze parti o che tu stai sviluppando separatamente e lo stai usando in vari super-progetti. In questi casi si pone un problema comune: si vuole essere in grado di trattare i due progetti separatamente ma essere tuttavia in grado di utilizzarne uno all'interno dell'altro.

Vediamo un esempio. Immagina di stare sviluppando un sito web creando dei feed Atom e, invece di scrivere da zero il codice per generare il contenuto Atom, decidi di utilizzare una libreria. Molto probabilmente dovrai includere del codice da una libreria condivisa come un’installazione di CPAN o una gem di Ruby, o copiare il sorgente nel tuo progetto. Il problema dell’includere la libreria è che è difficile personalizzarla e spesso più difficile da distribuire, perché è necessario assicurarsi che ogni client abbia a disposizione quella libreria. Il problema di includere il codice nel tuo progetto è che è difficile incorporare le modifiche eventualmente fatte nel progetto iniziale quando questo venisse aggiornato.

Git risolve questo problema utilizzando i moduli. I moduli consentono di avere un repository Git come una directory di un altro repository Git, che ti permette di clonare un altro repository nel tuo progetto e mantenere le commit separate.

### Lavorare con i moduli ###

Si supponga di voler aggiungere la libreria Rack (un’interfaccia gateway per server web in Ruby) al progetto, mantenendo le tue modifiche alla libreria e continuando a integrare le modifiche fatte a monte alla libreria. La prima cosa da fare è clonare il repository esterno nella subdirectory: aggiungi i progetti esterni come moduli col comando `git modulo aggiungono`:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Ora, all'interno del tuo progetto, hai la directory `rack` che contiene il progetto Rack. Puoi andare in questa directory, fare le tue modifiche e aggiungere il tuo repository remoto per fare la push delle tue modifiche e prendere quelle disponibili, così come incorporare le modifiche del repository originale, e molto altro. Se esegui `git status` subito dopo aver aggiunto il modulo, vedrai due cose:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

Prima di tutto nota il file `.gitmodules`: è un file di configurazione che memorizza la mappatura tra l’URL del progetto e la directory locale dove lo hai scaricato:

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

Se hai più di un modulo, avrei più voci in questo file. È importante notare che anche questo file è versionato con tutti gli altri file, come il tuo `.gitignore` e viene trasferito con tutto il resto del tuo progetto. Questo è il modo in cui gli altri che clonano questo progetto sanno dove trovare i progetti dei moduli.

L'altro elenco in stato git uscita `git status` è la voce rack. Se si esegue `git diff` su questo, si vede qualcosa di interessante:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Sebbene `rack` sia una subdirectory della tua directory di lavoro, Git lo vede come un modulo e non tiene traccia del suo contenuto quando non sei in quella directory. Git invece lo memorizza come una commit particolare da quel repository. Quando committi delle modifiche in quella directory, il super-project nota che l’HEAD è cambiato e registra la commit esatta dove sei; In questo modo, quando altri clonano questo progetto, possono ricreare esattamente l'ambiente.

Questo è un punto importante con i moduli: li memorizzi come la commit esatta dove sono. Non puoi memorizzare un modulo su `master` o qualche altro riferimento simbolico.

Quando committi vedi una cosa simile:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Nota il modo 160000 di ogni voce di rack. Questo è un modo speciale di Git che significa che stai memorizzando una commit per una directory piuttosto che una subdirectory o un file.

Puoi trattare la directory `rack` come un progetto separato e puoi aggiornare occasionalmente il tuo super-project con un puntatore all’ultima commit del sotto-project. Tutti i comandi di Git lavorano indipendentemente nelle due directories:

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### Clonare un progetto con moduli ###

Cloneremo ora un progetto con dei moduli. Quando ne ricevi uno, avrai una directory che contiene i moduli, ma nessun file:

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

La directory `rack` c’è, ma è vuota. Devi eseguire due comandi: `git submodule init` per inizializzare il tuo file di configurazione locale e `git submodule update` per scaricare tutti i dati del progetto e scaricare le commit opportune elencate nel tuo super-progetto:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Ora la tua directory `rack` è nello stesso stato in cui era quando hai committal precedentemente. Se qualche altro sviluppatore facesse delle modifiche a rack e le committasse, quando tu scaricherai quel riferimento e lo integrerai nel tuo repository vedrai qualcosa di strano:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

Quello di cui hai fatto il merge è fondamentalmente un cambiamento al puntatore del tuo modulo, ma non aggiorna il codice nella directory del modulo e sembra quindi che la tua directory di lavoro sia in uno stato ‘sporco’:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Questo succede perché il tuo puntatore del modulo non è lo stesso della directory del modulo. Per correggerlo devi eseguire di nuovo `git submodule update` again:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

E devi farlo ogni volta che scarichi delle modifiche al modulo nel progetto principale: è strano, ma funziona.

Un problema comune si verifica quando uno sviluppatore fa delle modifiche in un modulo ma non le trasmette al server pubblico, ma committa il puntatore a questo stato quando fa la pusg del superproject. Quando altri sviluppatori provano ad eseguire `git submodule update`, il sistema del modulo non riesce a trovare la commit a cui fa riferimento perché esiste solo sul sistema del primo sviluppatore. Quando ciò accade, viene visualizzato un errore come questo:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Devi quindi vedere chi è stato l’ultimo a cambiare il modulo:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

e mandarmi un’email e cazziarlo.

### Super-progetto ###

A volte gli sviluppatori vogliono scaricare una combinazione di subdirectory di un progetto grande, a seconda del team in cui lavorano. Questo è comune se vieni da CVS o Subversion, dove hai definito un modulo o un insieme di subdirectory e vuoi mantenere questo tipo di flusso di lavoro.

Un buon modo per farlo in Git è quello di rendere ciascuna sottodirectory un repository Git separato e creare quindi un repository Git con il super-progetto che contenga più moduli. Un vantaggio di questo approccio è che puoi definire meglio i rapporti tra i progetti con tag e branch nei super-progetti.

### Problemi con i moduli ###

Usare i moduli può comunque presentare qualche intoppo. Prima di tutto devi fare molta attenzione quando lavori nella directory del modulo. Quando esegui `git submodule update`, viene fatto il checkout della versione specifica del progetto, ma non del branch. Questo viene detto “avere l’HEAD separato: significa che il file HEAD punta direttamente alla commit, e non un riferimento simbolico. Il problema è che generalmente non vuoi lavorare in un ambiente separato perché è facile perdere commit, e non un riferimento simbolico. Il problema è che generalmente non vuoi lavorare in un ambiente separato perché è facile perdere le tue modifiche. Se inizi col comando `submodule update` e poi fai una commit nella directory del modulo senza aver creato prima un branch per lavorarci e quindi esegui una `git submodule update` dal super-progetto senz’aver committato nel frattempo, Git sovrascriverà le tue modifiche senza dirti nulla.  Tecnicamente non hai perso il tuo lavoro, ma non avendo nessun branch che vi punti sarà difficile da recuperare.

Per evitare questo problema ti basta creare un branch quando lavori nella directory del modulo con `git checkout -b work` o qualcosa di equivalente. Quando successivamente aggiorni il modulo il tuo lavoro sarà di nuovo sovrascritto, ma avrai un puntatore per poterlo recuperare.

Cambiare branch in progetti con dei moduli può essere difficile. Se crei un nuovo branch, vi aggiungi un modulo e torni a un branch che non abbia il modulo, ti ritroverai la directory del modulo non ancora tracciata:

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

Devi rimuoverla o spostarla e in entrambi i casi dovrai riclonarla quando torni al branch precedente e puoi quindi perdere le modifiche locali o i branch di cui non hai ancora fatto una push.

L'ultima avvertimento riguarda il passaggio da subdirectory a moduli. Se stai versionando dei file tuo nel progetto e vuoi spostarli in un modulo, è necessario devi fare attenzione, altrimenti Git si arrabbierà. Supponi di avere i file di rack in una directory del tuo progetto e decidi di trasformarla in un modulo. Se elimini la directory ed esegui il comando `submodule add`, Git ti strillerà:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Devi prima rimuovere la directory `rack` dalla tua area di staging per poter quindi aggiungerla come modulo:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Immagina ora di averlo fatto in un branch. Se ora torni a un branch dove quei file sono ancora nell’albero corrente piuttosto che nel modulo vedrai questo errore:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.
	(errore: il file 'rack/AUTHORS' non è versionato e sarà sovrascritto)

Devi quindi spostare la directory del modulo `rack` prima di poter tornare al branch che non ce l’aveva:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Ora, quando tornerai indietro, troverai la directory `rack` vuota. Ora puoi eseguire `git submodule update` per ripopolarla o rispostare la directory `/tmp/rack` nella directory vuota.

## Subtree Merging ##

Ora che hai visto quali sono le difficoltà del sistema dei moduli vediamo un’alternativa per risolvere lo stesso problema. Quando Git fa dei merge vede prima quello di cui deve fare il merge e poi decide quale sia la strategia migliore da usare. Se stai facendo il merge due branch Git userà la strategia _ricorsiva_ (*recursive* in inglese). Se stai facendo il merge di più di due branch Git userà la strategia del polpo (*octopus* in inglese). Queste strategie sono scelte automaticamente, perché la strategia ricorsiva può gestire situazioni complesse di merge a tre vie (quando ci sono per esempio più antenati), ma può gestire solamente due branch alla volta. La strategia del polpo può gestire branch multipli ma agisce con più cautela per evitare conflitti difficili da risolvere, ed è quindi scelta come strategia predefinita se stai facendo il merge di più di due branch.

Ci sono comunque altre strategie tra cui scegliere. Una di questa è il merge *subtree* e la puoi usare per risolvere i problemi dei subprogetti. Vedremo ora come includere lo stesso rack come abbiamo fatto nella sezione precedente, usando però il merge subtree.

L’idea del merge subtree è che tu hai due progetti e uno di questi è mappato su una subdirectory dell’altro e viceversa. Quando specifichi il merge subtree Git è abbastanza intelligente da capire che uno è un albero dell’altro e farne il merge nel migliore dei modi: è piuttosto incredibile.

Aggiungi prima l’applicazione Rack al tuo progetto e aggiungi il progetto Rack come un riferimento remoto al tuo progetto, quindi fanne il checkout in un suo branch:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

Ora hai la root del progetto Rack nel tuo branch `rack_branch` e il tuo progetto nel branch `master`. Se scarichi prima uno e poi l’altro vedrai che avranno due progetti sorgenti:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Ora vuoi inviare il progetto Rack nel tuo progetto `master` come una sottodirectory e in Git puoi farlo con `git read-tree`. Conoscerai meglio `read-tree` e i suoi amici nel Capitolo 9, ma per ora sappi che legge la radice di un branch nella tua area di staging della tua directory di lavoro. Sei appena ritornato nel tuo branch `master` e hai scaricato il branch `rack_branch` nella directory `rack` del branch `master` del tuo progetto principale:

	$ git read-tree --prefix=rack/ -u rack_branch

Quando fai la commit sembra che tutti i file di Rack siano nella directory, come se li avessi copiati da un archivio. La cosa interessante è che può fare facilmente il merge da un branch all’altro, così che puoi importare gli aggiornamenti del progetto Rack passando a quel branch e facendo la pull:

	$ git checkout rack_branch
	$ git pull

Tutte le modifiche del progetto Rack project vengono incorporate e sono pronte per essere committate in locale. Puoi fare anche l’opposto: modificare la directory `rack` e poi fare il merge nel branch `rack_branch` per inviarlo al mantenitore o farne la push al server remoto.

Per fare un confronto tra quello che hai nella directory `rack` e il codice nel branch `rack_branch` (e vedere se devi fare un merge o meno) non puoi usare il normale comando `diff`: devi usare invece `git diff-tree` con il branch con cui vuoi fare il confronto:

	$ git diff-tree -p rack_branch

O confrontare quello che c’è nella directory `rack` con quello che c’era nel branch `master` l’ultima volta che l’hai scaricato, col comando

	$ git diff-tree -p rack_remote/master

## Sommario ##

Hai visto numerosi strumenti avanzati che ti permettono di manipolare le tue commit e la tua area di staging in modo più preciso. Quando incontrassi dei problemi dovresti essere facilmente in grado di capire quale commit li ha generati, quando e chi ne è l’autore. Se desideri usare dei sotto-progetti nel tuo progetto e hai appreso alcuni modi per soddisfare tali esigenze. A questo punto dovresti essere in grado di fare in Git la maggior parte delle cose sulla riga di comando di uso quotidiano, e sentirti a tuo agio facendole.
