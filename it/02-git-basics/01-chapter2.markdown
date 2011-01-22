# Basi di Git #

Se puoi leggere solo un capitolo per capire l'uso di Git, questo fa per te.  Questo capitolo illustra tutti i comandi base per fare la stragrande maggioranza delle cose impiegando al meglio il tuo tempo con Git. Alla fine del capitolo, dovresti essere in grado di configurare ed inizializzare un repository, avviare e fermare il tracciamento dei file e mettere in stage o eseguire il commit dei cambiamenti. Vedremo come impostare Git per ignorare certi file o pattern di file, come correggere gli errori velocemente e facilmente, come navigare nella storia del tuo progetto e vedere i cambiamenti tra i vari commit e come fare il push ed il pull da repository remoti.

## Ottenere un Repository Git ##

Puoi creare un progetto Git usando due approcci principali. Il primo prende un progetto esistente o una directory e la importa in Git. Il secondo clona un repository Git esistente da un altro server.

### Inizializzare un Repository in una Directory Esistente ###

Se stai iniziando a tracciare un progetto esistente con Git, devi posizionarti nella directory del progetto e digitare:

	$ git init

Questo creerà una nuova sottodirectory chiamata .git che conterrà tutti i file necessari per il repository — uno scheletro del repository Git. A questo punto, niente del tuo progetto è tracciato ancora. (Vedi il Capitolo 9 per avere maggiori informazioni esatte sui file che sono contenuti nella directory `.git` che hai appena creato.)

Se vuoi iniziare a tracciare i file esistenti (al contrario di una
directory vuota), dovresti iniziare a monitorare questi file
eseguendo un commit iniziale. Lo puoi fare con pochi comandi che
specificano quali file vuoi controllare, seguiti dal un commit: 

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

Vedremo in seguito velocemente cosa fanno questi comandi. A questo punto hai un repository Git con dei file tracciati ed un commit iniziale.

### Clonare un Repository Esistente ###

Se vuoi avere la copia di un repository Git esistente — per esempio, un progetto a cui vuoi contribuire — il comando di cui hai bisogno è git clone. Se hai famigliarità con altri sistemi VCS come Subversion, noterai che il comando è clone e non checkout. Questa è una distinzione importante — Git riceve una copia di circa tutti i dati che un server possiede. Ogni versione di ogni file della storia del progetto sono scaricate quando lanci `git clone`. Infatti, se il disco del tuo server è corrotto, puoi usare qualsiasi clonazione di qualsiasi client per ripristinare il server allo stato in cui era quando è stato clonato (puoi perdere alcuni agganci server, ma tutte le versioni dei dati saranno presenti — vedi il Capitolo 4 per maggiori dettagli).

Clona un repository con `git clone [url]`. Per esempio, se vuoi clonare la libreria Ruby Git chiamata Grit, puoi farlo così:

	$ git clone git://github.com/schacon/grit.git mygrit

Questo comando crea un directory "grit", inizializza una directory `.git` dentro di essa, scarica tutti i dati per questo repository ed imposta la copia di lavoro dell'ultima versione. Se entri nella nuova directory `grit`, vedrai i file del progetto, pronti per essere modificati o usati.  Se vuoi clonare il repository in una directory con un nome diverso da grit, puoi specificarlo come opzione successiva al comando da terminale:

	$ git clone git://github.com/schacon/grit.git mygrit

Questo comando fa la stessa cosa del precedente, ma la directory di destinazione è chiamata mygrit.

Git può usare differenti protocolli di trasferimento. L'esempio precedente usa il protocollo `git://`, ma puoi anche vedere `http(s)://` o `user@server:/path.git`, che usa il protocollo di trasferimento SSH. Il Capitolo 4 introdurrà tutte le opzioni disponibili che il server può impostare per farti accedere al repository Git ed i pro e i contro di ognuna.

## Registrare i Cambiamenti al Repository ##

In buona fede hai copiato un repository Git e hai la copia di lavoro dei file di questo progetto. Ora puoi apportare alcune modifiche ed inviare gli snapshots di questi cambiamenti nel tuo repository ogni volta che il progetto raggiunge uno stato che vuoi registrare.

Ricorda che ogni file nella tua directory di lavoro è in una dei due stati seguenti: tracciato o non tracciato. I file tracciati sono sono i file presenti nell'ultimo snapshot; possono essere non modificati, modificati o parcheggiati (stage). I file non tracciati sono tutti gli altri - qualsiasi file nella tua directory di lavoro che non è presente nel tuo ultimo snapshot o nella tua area di staging. Quando cloni per la prima volta un repository, tutti i tuoi file sono tracciati e non modificati perché li hai appena prelevati e non hai modificato ancora niente.

Quando modifichi i file, Git li vede come cambiati, perché li hai
modificati rispetto all'ultimo commit. Parcheggi questi file e poi esegui
il commit di tutti i cambiamenti presenti nell'area di stage, ed il ciclo
si ripete. Questo ciclo di vita è illustrato nella Figura 2-1.

Insert 18333fig0201.png
Figure 2-1. Il ciclo di vita dello stato dei tuoi file.

### Controlla lo Stato dei Tuoi File ###

Lo strumento principale che userai per determinare quali file sono in un
certo stato è il comando git status. Se lanci questo comando direttamente
dopo aver fatto una clonazione, dovresti vedere qualcosa di simile a:

	$ git status
	# On branch master
	nothing to commit (working directory clean)

Questo significa che hai una directory di lavoro pulita — in altre parole, non c'è traccia di file modificati. Git inoltre non vede altri file non tracciati, altrimenti sarebbero elencati qui. Infine, il comando ci dice in quale ramo (branch) si è. Per ora, è sempre il master, che è il predefinito; non preoccuparti ora di questo. Il prossimo capitolo tratterà delle ramificazioni e dei riferimenti nel dettagli.

Ora diciamo che hai aggiunto un nuovo file al tuo progetto, un semplice
file README. Se il file non esisteva prima, e lanci `git status`, vedrai il
tuo file non tracciato come segue:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Puoi vedere che il tuo nuovo file README non è tracciato, perché è sotto al titolo "Untracked files" nell'output degli stati. Untracked fondamentalmente significa che Git vede un file che non avevi nel precedente snapshot (commit); Git non inizierà ad includerlo negli snapshot dei tuoi commit fino a quando tu non glielo dirai esplicitamente. Si comporta così per evitare che tu accidentalmente includa file binari generati o qualsiasi altro tipo di file che non vuoi sia incluso. Se vuoi includere il file README, continua con il tracciamento dei file.

### Tracciare nuovi File ###

Per iniziare a tracciare un nuovo file, usa il comando `git add`. Per tracciare il file README, lancia questo comando:

	$ git add README

Se lanci nuovamente il comando di stato, puoi vedere il tuo file README tracciato e parcheggiato:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#


Ti dice che è parcheggiato (in stage) perché è sotto al titolo "Changes to be committed". Se fai ora il commit, la versione del file al momento in cui hai lanciato git add sarà quella che troverai nella storia dello snapshot.  Ti ricordo che precedentemente è stato lanciato git init, poi hai dovuto lanciare git add (files) — che era l'inizio per tracciare i file nella tua directory. Il comando git add prende il nome del path di ogni file o directory; se è una directory, il comando aggiunge tutti i file in quella directory ricorsivamente.

### Parcheggiare File Modificati ###

Ora modifichiamo un file che è già stato tracciato. Se modifichi un file precedentemente tracciato chiamato `benchmarks.rb` e poi avvii nuovamente il comando `status`, otterrai qualcosa di simile a:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Il file benchmarks.rb appare sotto la sezione chiamata "Changed but not updated" — che significa che un file che è tracciato è stato modificato nella directory di lavoro ma non ancora messo in stage (parcheggiato). Per parcheggiarlo, avvia il comando `git add` (è un comando multifunzione — è usato per iniziare a tracciare nuovi file, per parcheggiare i file e per fare altre cose come eseguire la fusione dei file che entrano in conflitto dopo che sono stati risolti). Avvia dunque `git add` per parcheggiare ora il file benchmarks.rb, e avvia nuovamente `git status`:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Entrambi i file sono parcheggiati ed entreranno nel prossimo commit. A
questo punto, supponendo che tu ti sia ricordato di una piccola modifica da fare a benchmarks.rb prima di fare il commit. Apri nuovamente il file ed esegui la modifica, e ora sei pronto per il commit. Come sempre, lanci `git status` ancora una volta:

	$ vim benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Che succede? Ora benchmarks.rb è elencato sia in stage che non. Come è possibile? E' saltato fuori che Git ha parcheggiato il file esattamente come se tu avessi avviato il comando git add. Se esegui ora il commit, la versione di benchmarks.rb che verrà inviata nel commit sarà come quella di quando tu hai lanciato il comando git add, non la versione del file che appare nella tua directory di lavoro quando lanci git commit. Se modifichi un file dopo che hai lanciato `git add`, devi nuovamente avviare `git add` per parcheggiare l'ultima versione del file:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Ingorare File ###
