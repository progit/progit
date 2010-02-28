# Git Tools #

Fin'ora sono stati imparati la maggior parte dei comandi giornalieri a i
workflow che potrebbero essere necessari a gestire e mantenere un repository Git
per il controllo del codice sorgente.
Sono state compiute le attività di base per il tracciamento e il commit dei
file, ed è stato sfruttato il potere della *staging area* e argomenti leggeri il
*branching* (ramificazione) e il *merge*.

Ora verrà esplorato un numero di cose veramente potenti che Git può fare che non
vengono necessariamente usate di base quotidianamente ma che potrebbero servire
ad un certo punto.

## Selezione della revisione ##

Git permette di specificare determinati *commit* o una serie di *commit* in
diversi modi.
Non sono necessariamente evidenti ma può essere d'aiuto conoscerli.

### Singola revisione ###

E' possibile ovviamente riferirsi a un *commit* tramite l'hash SHA-1 che viene
dato, ma ci sono modi più alla portata degli umani per riferirsi ai *commit*.
Questa sezione delinea i diversi modi con cui ci si può riferire ad un singolo
commit.

### SHA breve ###

Git è abbastanza intelligente da capire a quale *commit* ci si riferisce se si
fornisce i primi caratteri, purché il codice SHA-1 sia di almeno quattro
caratteri e univoco - solo un oggetto nel *repository* corrente inizia con quel
SHA-1 parziale.

Per esempio, per vedere uno specifico *commit*, supponiamo che venga eseguito un
comando 'git log' e venga identificato un *commit* dove sono state aggiunte
certe funzionalità:

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

In questo caso, scegliamo '1c002dd....' Se viene eseguito 'git show' su quel
*commit*, i seguenti comandi sono equivalenti (assumendo che le versioni più
corte siano univoche):            

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git riesce a capire una corta, univoca abbreviazione del valore SHA-1. Se viene
passato '--abbrev-commit' al comando 'git-log', l'*output* userà valori più
corti ma li manterrà unici; in maniera predefinita utilizza sette caratteri ma
se necessario ne userà di più per mantenere il codice SHA-1 univoco:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Generalmente, da otto a dieci caratteri sono più che sufficienti per essere
univoci all'interno di un progetto.
Uno dei progetti Git più grandi, il kernel Linux, inizia a necessitare 12
caratteri, dei 40 possibili, per rimanere univoco.

### Una breve nota su SHA-1 ###

Un sacco di gente si preoccupa ad un certo punto che, per una qualche casualità,
potrebbe avere due oggetti nel proprio *repository* che abbiano lo stesso hash
SHA-1. Cosa accadrebbe a quel punto?

Se capita di fare il *commit* di un oggetto che ha lo stesso SHA-1 di un oggetto
precedente nel proprio *repository*, Git noterà il precedente oggetto già
presente nel database Git e lo riterrà già scritto.
Provando ad ottenere informazioni su quell'oggetto nuovamente ad un certo punto,
verranno sempre restituiti i dati del primo oggetto.

Ad ogni modo, è necessario essere consapevoli di quanto ridicolmente improbabile
sia questo scenario. Il codice SHA-1 riassunto è di 20 bytes o 160 bits. Il
numero casuale di oggetti necessari per assicurare un 50% di una singola
collisione è di circa 2^80 (la formula per determinare la probabilità di
collisione è `p = (n(n-1)/2) * (1/2^160))`. 2^80 è 1.2 x 10^24 o un milione di
miliardi di miliardi. E' 1,200 volte il numero di granelli di sabbia sulla
terra.

Ecco un esempio per dare un'idea di cosa ci vorrebbe per ottenere una collisione
SHA-1. Se tutti i 6.5 miliardi di esseri umani sulla Terra stessero
programmando, e ogni secondo, ognuno stesse producendo codice che fosse
equivalente all'intera storia del kernel Linux (1 milione di oggetti Git) e se
lo stesse caricando su un enorme *repository* Git, ci vorrebbero 5 anni per
contenere abbastanza oggetti in quel *repository* da avere il 50% di possibilità
di una singola collisione di oggetti SHA-1. Esiste una probabilità più alta che
ogni membro del team venga attaccato e ucciso dai lupi in situazioni
indipendenti durante la stessa notte.

### Riferimenti al *branch* ###

La strada più diretta per specificare un *commit* richiede che punti ad un
riferimento di un *branch*. A quel punto potrebbe essere usato il nome del
*branch* in qualsiasi comando Git che richiede un oggetto *commit* o un valore
SHA-1. Per esempio, se si vuole mostrare l'ultimo oggetto *commit* di un
*branch*, i seguenti comandi sono equivalenti, ammesso che il *branch* 'topic1'
punti a 'ca82a6d':

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Se si vuole vedere a quale specifico SHA un *branch* punta, o se si vuole vedere
a cosa si riduce ognuno di questi esempi in termini di SHA, si può usare un
*plumbing tool* di Git chiamato 'rev-parse'. Nel Capitolo 9 ci sono più informazioni
sui *plumbing tool*; sostanzialmente, 'rev-parse' esiste per operazioni di basso
livello e non è concepito per essere usato in operazioni quotidiane. Comunque,
può essere d'aiuto a volte quanto c'è bisogno di vedere cosa succede realmente.
A quel punto si può lanciare 'rev-parse' sul proprio *branch*.

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### RefLog ###

Una delle cose che Git fa mentre si lavora è tenere un reflog - un log sui
riferimenti di *HEAD* e *branch* degli ultimi mesi.

E' possibile vedere il reflog usando il comando 'git reflog':

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Ogni volta che il *branch* è aggiornato, Git registra l'informazione in questa
lista temporanea. Si possono specificare anche *commit* più vecchi. Se si vuole
vedere il quinto valore precedente della *HEAD* del proprio *repository*, si può
usare il riferimento '@{n}' che si vede nel *output* di reflog:

	$ git show HEAD@{5}

Si può anche usare questa sintassi per vedere dove era un *branch* una certa
quantità di tempo fa. Per esempio, per vedere dov'era il 'master' *branch* ieri,
si può scrivere:

	$ git show master@{yesterday}

Questo mostra dove era il *branch* ieri. Questa tecnica funziona solo per i dati
che sono ancora nel *reflog*, non è possibile usarla per vedere *commit* più
vecchi di qualche mese.

Per vedere le informazioni del *reflog* formattate come il '*git log*', si può
lanciare il comando 'git log -g':

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

E' importante notare che l'informazione del *reflog* è strettamente locale - è
un log di cosa è stato fatto nel proprio *repository*. I riferimenti non saranno
uguali nella copia del *repository* tenuta da qualcun altro.
Lanciare 'git show HEAD@{2.months-ago}' funzionerà solo se il progetto è stato
clonato almeno due mesi fa - se è stato clonato cinque minuti prima non verrà
restituito alcun risultato.

### Riferimenti di discendenza ###

L'altro modo per specificare un *commit* è attraverso la sua discendenza. Se
viene posizionato un `^` alla fine di un riferimento, Git lo interpreta come il
genitore di quel determinato *commit*.
Supponiamo che si guardi la lista delle modifiche effettuate nel progetto:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\  
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/  
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

E' possibile vedere il precedente *commit* specificando `HEAD^`, che significa
"il genitore di HEAD":

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Si può anche specificare un numero dopo `^` - per esempio, `d921970^2` significa
"il secondo genitore di d921870." Questa sintassi è utile per fare il *merge* di
*commit* che hanno più di un genitore.
Il primo genitore è il *branch* dove ci si trova al momento del *merge*, e il
secondo è il *commit* sul *branch* di cui è stato fatto il *merge*:

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

Un altro modo per specificare la discendenza è `~`. Anche questo si riferisce al
primo genitore, quindi `HEAD~` e `HEAD^` sono equivalenti. La differenza si nota
quando viene specificato un numero.
`HEAD~2` significa "il primo genitore del primo genitore", o "il nonno" -
attraversa i primi genitori il numero di volte specificato. Per esempio, nella
lista mostrata precedentemente, `HEAD~3` sarebbe

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Potrebbe essere anche scritto come `HEAD^^^`, che è sempre il primo genitore del
primo genitore del primo genitore:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

E' possibile anche combinare queste sintassi - si può prendere il secondo
genitore del precedente riferimento (assumendo che si tratti di un *merge
commit*) usando `HEAD~3^2`, e così via.            
