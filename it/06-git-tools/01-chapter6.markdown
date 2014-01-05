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

L'altro elenco in stato git uscita `` è la voce rack. Se si esegue `git diff` su questo, si vede qualcosa di interessante:

Sebbene `rack` sia una directory della tua directory di lavoro, Git lo vede come un modulo e non tiene traccia del suo contenuto quando non sei in quella directory. Git invece lo memorizza come una commit particolare da quel repository. Quando committi delle modifiche in quella directory, il super-project nota che l’HEAD è cambiato e registra la commit esatta dove sei; In questo modo, quando altri clonano questo progetto, possono ricreare esattamente l'ambiente.

Questo è un punto importante con i moduli: li memorizzi come la ‘commit esatta dove sono. Non puoi memorizzare un modulo su `master` o qualche altro riferimento simbolico.

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

### Issues with Submodules ###

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

Ora vuoi inviare il progetto Rack nel tuo progetto `master` come una sottodirectory e in Git puoi farlo con `git read-tree`. Conoscerai meglio `read-tree` e i suoi amici nel Capitolo 9, ma per ora sappi che legge la radice di un branch nella tua area di staging della tua directory di lavoro. Sei appena ritornato nel tuo branch `master` e hai scaricato il branch `rack` nella directory `rack` del branch `master` del tuo progetto principale:

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