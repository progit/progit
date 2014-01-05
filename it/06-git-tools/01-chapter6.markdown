# Git Tools #

Finora hai imparato la la maggior parte dei comandi d’uso quotidiani e i workflow che potrebbero essere necessari a gestire e mantenere un repository per il controllo del codice sorgente con Git. Hai eseguito le attività di base per il tracciamento e la commit dei file, e hai sfruttato il potere della *staging area* e il *branch* (la ramificazione) e il *merge* di argomenti dall’impatto leggero.

Vedremo ora una serie di potenzialità di Git che potresti non usare quotidianamente, ma di cui potresti averne bisogno a un certo punto.

## Selezione della revisione ##

Git ti permette di specificare una o più *commit* in diversi modi. Non sono sempre ovvi, ma è utile conoscerli.

### Singole versioni ###

Puoi fare riferimento a una singola commit usando l’hash SHA-1 attribuito, ma ci sono altri metodi più amichevoli per fare riferimento a una *commit*. Questa sezione delinea i modi con cui ci si può riferire a una singolo commit.

### SHA breve ###

Git è abbastanza intelligente da capire a quale *commit* ti riferisci scrivi i primi caratteri purché il codice SHA-1 sia di almeno quattro caratteri e sia univoco, ovvero che un solo oggetti nel *repository* attuale inizi con quel SHA-1.

Per vedere per esempio una *commit*  specifica, immaginiamo di eseguire 'git log' e venga identificata una *commit* dove sono state aggiunte determinate funzionalità:

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

In questo caso scegliamo '1c002dd....'. Se vuoi eseguire 'git show' su quella *commit*, i seguenti comandi sono equivalenti (assumendo che le versioni più brevi siano univoche):            

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git riesce a capire un valore SHA-1 intero da uno corto, abbreviato. Se usi l’opzione '--abbrev-commit' col comando 'git-log', l'*output* userà valori più corti ma garantirà che siano unici: di default usa sette caratteri ma ne userà di più se sarà necessario per mantenere l’univocità del valore SHA-1:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Da otto a dieci caratteri sono, generalmente, più che sufficienti per essere
univoci all'interno di un progetto. Uno dei progetti Git più grandi, il kernel di Linux, inizia a necessitare 12 caratteri, dei 40 possibili, per essere univoco.

### Una breve nota su SHA-1 ###

Arriva un momento in cui molte persone si preoccupano che possano avere, per puro caso, due oggetti nel proprio *repository* che abbiano lo stesso hash SHA-1. E allora?

Se capita di fare la *commit* di un oggetto a che abbia lo stesso SHA-1 di un oggetto
già presente nel tuo *repository*, Git vedrà l’oggetto precedente già nel database di Git e lo riterrà già scritto. Se successivamente proverai a fare il checkout di quest’ultimo oggetto, otterrai sempre i dati del primo oggetto.

Ad ogni modo, è necessario essere consapevoli di quanto sia ridicolmente improbabile
questo scenario. Il codice SHA-1 è di 20 bytes o 160 bits. Il numero di oggetti casuali necessari perché ci sia la probabilità del 50% di una singola collisione è di circa 2^80 (la formula per determinare la probabilità di collisione è `p = (n(n-1)/2) * (1/2^160))`. 2^80 è 1.2 x 10^24 ovvero un milione di miliardi di miliardi. È 1.200 volte il numero di granelli di sabbia sulla terra.

Ecco un esempio per dare un'idea di cosa ci vorrebbe per ottenere una collisione
SHA-1. Se tutti i 6.5 miliardi di esseri umani sulla Terra programmassero e, ogni secondo, ognuno scrivesse codice che fosse equivalente all'intera cronologia del kernel Linux (1 milione di oggetti Git) e ne facesse la push su un enorme *repository* Git, ci vorrebbero 5 anni per contenere abbastanza oggetti in quel *repository* per avere il 50% di possibilità di una singola collisione di oggetti SHA-1. Esiste una probabilità più alta che ogni membro del tuo gruppo di sviluppo, per pura coincidenza, venga attaccato e ucciso da dei lupi nella stessa notte.

### Riferimenti ai *branch* ###

Il modo più diretto per specificare una *commit* è avere un *branch* che vi faccia riferimento, che ti permetterebbe di usare il nome del *branch* in qualsiasi comando Git che richieda un oggetto *commit* o un valore SHA-1. Se vuoi, per esempio, mostrare l'ultima *commit* di un *branch*, i seguenti comandi sono equivalenti, supponendo che il *branch* 'topic1' punti a 'ca82a6d':

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Se vuoi vedere a quale SHA specifico punti un *branch*, o se vuoi vedere a quale SHA puntino questi esempi, puoi usare il comando 'rev-parse' di Git, che fa parte dei comandi *plumbing* . Nel Capitolo 9 trovi maggiori informazioni sui comandi *plumbing*: brevemente, 'rev-parse' esiste per operazioni di basso livello e non è concepito per essere usato nelle operazioni quotidiane. Può Comunque essere d'aiuto quando hai bisogno di vedere cosa sta succedendo. Puoi quindi eseguire 'rev-parse' su tuo *branch*.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### Nomi brevi di RefLog ###

Una delle cose che Git fa dietro le quinte è aggiornare il file reflog, che memorizza silenziosamente la posizione negli ultimi mesi del tuo HEAD e dei riferimenti ai tuoi branch , ogni volta che li cambi.

Puoi consultare il reflog con il comando 'git reflog':

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Ogni volta che un *branch* viene aggiornato per qualsiasi ragione, Git memorizza questa informazione in questa cronologia temporanea. E puoi anche specificare *commit* più vecchie. Se vuoi vedere la cronologia a partire dalla quinta commit più vecchia a partire dalla *HEAD* del tuo *repository*, puoi usare il riferimento '@{n}' che vedi nel *output* di reflog:

	$ git show HEAD@{5}

Puoi usare usare questa sintassi anche per vedere dove era un *branch* a una certa data. Se vuoi vedere, per esempio, dov'era il 'master' *branch* ieri, puoi scrivere:

	$ git show master@{yesterday}

Questo mostra dove era il *branch* ieri. Questa tecnica funziona solo per i dati
che sono ancora nel *reflog* e non puoi quindi usarla per vedere *commit* più
vecchie di qualche mese.

Per vedere le informazioni del *reflog* formattate come l’output di '*git log*', puoi
eseguire il comando 'git log -g':

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

E' importante notare che l'informazione del *reflog* è strettamente locale: è un log di cosa hai fatto nel tuo *repository*. I riferimenti non saranno uguali sui cloni degli altri. Appena dopo aver clonato un *repository* il tuo reflog sarà vuoto perché ancora non hai svolto nessuna attività sul tuo *repository*. Eseguendo 'git show HEAD@{2.months.ago}' funzionerà solo se hai clonato il progetto almeno due mesi fa: se è stato clonato cinque minuti fa non otterrai nessun risultato.

### Riferimenti ancestrali ###

L'altro modo principale per specificare una *commit* è attraverso i suoi ascendenti. Se metti un `^` alla fine di un riferimento, Git lo risolve interpretandolo come il padre
padre di quella determinata *commit*. Immagina di guardare la cronologia del tuo progetto:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\  
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/  
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Puoi quindi vedere la *commit* precedente specificando `HEAD^`, che significa "il genitore di HEAD":

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Puoi anche specificare un numero dopo `^`: per esempio `d921970^2` significa
"il secondo genitore di d921870." Questa sintassi è utile solo per fare il *merge* di
*commit* che hanno più di un genitore. Il primo genitore è il *branch* dove ti trovi al momento del *merge*, e il secondo è la *commit* sul *branch* da cui hai fatto il *merge*:

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

Un altro modo riferimento ancestrale è `~`. Questo si riferisce anche al genitore, quindi `HEAD~` e `HEAD^` sono equivalenti. La differenza si nota quando specifichi un numero. `HEAD~2` significa "il genitore del genitore", o "il nonno”: attraversa i primi genitori il numero di volte che specifichi. Per esempio, nella
cronologia precedente, `HEAD~3` sarebbe

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Che può anche essere scritto come `HEAD^^^` che, di nuovo, è sempre il genitore del genitore del genitore:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

È anche possibile combinare queste sintassi: puoi prendere il nonno del riferimento precedente (assumendo che si tratti di una commit di *merge*) usando `HEAD~3^2`, e così via.

### Intervalli di Commit ###

Ora che sai come specificare delle commit singole, vediamo come specificare intervalli di commit. Ciò è particolarmente utile per gestire i tuoi branch: se hai molti branch puoi usare gli intervalli per rispondere a domande come “cosa c’è nel tuo branch di cui io non ho ancora fatto il merge?”

#### Due punti ####

Il modo più comune per specificare un intervallo è con i due punti che, praticamente, chiedono a Git di risolvere l’intervallo tra commit che sia raggiungibile da una commit, ma che non sia raggiungibile dall’altra. Per esempio, immaginiamo di avere una cronologia come nell’immagine 6-1

Insert 18333fig0601.png
Figure 6-1. Esempio di cronologia per selezione di intervalli.

Vuoi vedere cosa sia nel tuo branch sperimentale che non sia ancora stato incluso nel branch master: puoi chiedere a Git di mostrarti il log esclusivamente di quelle commit con `master..experiment`: questo significa “tutte le commit raggiungibili da experiment che non siano raggiungibili da master”. Affinché questi esempi siano sintetici ma chiari, invece del log effettivamente scritto da Git, userò le lettere degli oggetti commit del diagramma:

	$ git log master..experiment
	D
	C

Se, invece vuoi vedere il contrario, ovvero tutte le commit in `master` che non siano in `experiment`, puoi invertire i nomi dei branch: `experiment..master` ti mostra tutto ciò che è in `master` e che non sia raggiungibile da `experiment`:

	$ git log experiment..master
	F
	E

Questo è utile se vuoi mantenere il branch `experiment` aggiornato e sapere di cosa stai per fare il merge. Un’altro caso in cui si usa spesso questa sintassi è quando stai per fare una push verso un repository remoto:

	$ git log origin/master..HEAD

Questo comando mostra tutte le commit nel tuo branch che non sono nel branch `master` del tuo repository remoto `origin`. Se esegui `git push` quando il tuo branch è associato a `origin/master`, le commit elencate da `git log origin/master..HEAD` saranno le commit che saranno inviate al server.
Puoi anche omettere una delle parti della sintassi, e Git assumerà che sia HEAD. Puoi per esempio ottenere lo stesso risultato dell’esempio precedente scrivendo `git log origin/master..`: Git sostituisce la parte mancante con HEAD.

#### Punti multipli ####

La sintassi dei due punti è utile come la stenografia, ma potresti voler specificare più di due branch, così come vedere le commit che sono nei vari branch e che non sono nel tuo branch attuale. Git ti permette di farlo sia con il carattere `^` che con l’opzione `--not` prima di ciascun riferimento del quale vuoi vedere le commit non raggiungibili. Quindi questi tre comandi sono equivalenti:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Questo è interessante, perché con questa sintassi puoi specificare più di due riferimenti nella tua query, cosa che non puoi fare con i due punti. Se per esempio vuoi vedere tutte le commit che siano raggiungibili da `refA` o da `refB` ma non da `refC` puoi usare una delle seguenti alternative:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Questo la rende un sistema potente di query di revisione che dovrebbe aiutarti a capire cosa c’è nei tuo branch.

#### Tre punti ####

L’ultima sintassi per la selezione di intervalli è quella dei tre punti che indica tutte le commit raggiungibili da ciascuno dei riferimenti ma non da entrambi. Rivedi la cronologia delle commit nella Figura 6-1.
Se vuoi vedere cosa sia in `master` o in `experiment` ma non i riferimenti comuni puoi eseguire questo comando

	$ git log master...experiment
	F
	E
	D
	C

Che ti mostra l’output normale del *log*, ma solo con le informazioni di quelle quattro commit nel solito ordinamento cronologico.

In questo è comune usare il parametro `--left-right` con il comando `log`, che mostra da che parte è la commit nell’intervallo selezionato, che rende i dati molto più utili:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Con questi strumenti puoi dire facilmente a Git quale o quali commit vuoi ispezionare.

## Moduli ##

Capita spesso che, mentre stai lavorando a un progetto, debba includerne un altro. Potrebbe essere una libreria sviluppata da terze parti o che tu stai sviluppando separatamente e lo stai usando in vari super-progetti. In questi casi si pone un problema comune: si vuole essere in grado di trattare i due progetti separatamente ma essere tuttavia in grado di utilizzarne uno all'interno dell'altro.

Vediamo un esempio. Immagina di stare sviluppando un sito web creando dei feed Atom e, invece di scrivere da zero il codice per generare il contenuto Atom, decidi di utilizzare una libreria. Molto probabilmente dovrai includere del codice da una libreria condivisa come un’installazione di CPAN o una gem di Ruby, o copiare il sorgente nel tuo progetto. Il problema dell’includere la libreria è che è difficile personalizzarla e spesso più difficile da distribuire, perché è necessario assicurarsi che ogni client abbia a disposizione quella libreria. Il problema di includere il codice nel tuo progetto è che è difficile incorporare le modifiche eventualmente fatte nel progetto iniziale quando questo venisse aggiornato.

Git risolve questo problema utilizzando i moduli. I moduli consentono di avere un repository Git come una directory di un altro repository Git, che ti permette di clonare un altro repository nel tuo progetto e mantenere le commit separate.