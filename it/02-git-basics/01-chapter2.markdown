# Basi di Git #

Se puoi leggere solo un capitolo per capire l'uso di Git, questo fa per te.  Questo capitolo illustra tutti i comandi base per fare la stragrande maggioranza delle cose impiegando al meglio il tuo tempo con Git. Alla fine del capitolo, dovresti essere in grado di configurare ed inizializzare un repository, avviare e fermare il tracciamento dei file e mettere in stage o eseguire il commit dei cambiamenti. Vedremo come impostare Git per ignorare certi file o pattern di file, come correggere gli errori velocemente e facilmente, come navigare nella storia del tuo progetto e vedere i cambiamenti tra i vari commit e come fare il push ed il pull da repository remoti.

## Ottenere un repository Git ##

Puoi creare un progetto Git usando due approcci principali. Il primo prende un progetto esistente o una directory e la importa in Git. Il secondo clona un repository Git esistente da un altro server.

### Inizializzare un repository in una directory esistente ###

Se stai iniziando a tracciare un progetto esistente con Git, devi posizionarti nella directory del progetto e digitare:

	$ git init

Questo creerà una nuova sottodirectory chiamata .git che conterrà tutti i file necessari per il repository — uno scheletro del repository Git. A questo punto, niente del tuo progetto è tracciato ancora. (Vedi il Capitolo 9 per avere maggiori informazioni esatte sui file che sono contenuti nella directory `.git` che hai appena creato.)

Se vuoi iniziare a tracciare i file esistenti (al contrario di una directory vuota), dovresti iniziare a monitorare questi file eseguendo un commit iniziale. Lo puoi fare con pochi comandi che specificano quali file vuoi controllare, seguiti da un commit: 

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

Vedremo in seguito velocemente cosa fanno questi comandi. A questo punto hai un repository Git con dei file tracciati ed un commit iniziale.

### Clonare un repository esistente ###

Se vuoi avere la copia di un repository Git esistente — per esempio, un progetto a cui vuoi contribuire — il comando di cui hai bisogno è git clone. Se hai familiarità con altri sistemi VCS come Subversion, noterai che il comando è clone e non checkout. Questa è una distinzione importante — Git riceve una copia di circa tutti i dati che un server possiede. Ogni versione di ogni file della storia del progetto sono scaricate quando lanci `git clone`. Infatti, se il disco del tuo server è corrotto, puoi usare qualsiasi clonazione di qualsiasi client per ripristinare il server allo stato in cui era quando è stato clonato (puoi perdere alcuni agganci server, ma tutte le versioni dei dati saranno presenti — vedi il Capitolo 4 per maggiori dettagli).

Clona un repository con `git clone [url]`. Per esempio, se vuoi clonare la libreria Ruby Git chiamata Grit, puoi farlo così:

	$ git clone git://github.com/schacon/grit.git

Questo comando crea un directory "grit", inizializza una directory `.git` dentro di essa, scarica tutti i dati per questo repository ed imposta la copia di lavoro dell'ultima versione. Se entri nella nuova directory `grit`, vedrai i file del progetto, pronti per essere modificati o usati.  Se vuoi clonare il repository in una directory con un nome diverso da grit, puoi specificarlo come opzione successiva al comando da terminale:

	$ git clone git://github.com/schacon/grit.git mygrit

Questo comando fa la stessa cosa del precedente, ma la directory di destinazione è chiamata mygrit.

Git può usare differenti protocolli di trasferimento. L'esempio precedente usa il protocollo `git://`, ma puoi anche vedere `http(s)://` o `user@server:/path.git`, che usa il protocollo di trasferimento SSH. Il Capitolo 4 introdurrà tutte le opzioni disponibili che il server può impostare per farti accedere al repository Git ed i pro e i contro di ognuna.

## Registrare i cambiamenti al repository ##

In buona fede hai copiato un repository Git e hai la copia di lavoro dei file di questo progetto. Ora puoi apportare alcune modifiche ed inviare gli snapshots di questi cambiamenti nel tuo repository ogni volta che il progetto raggiunge uno stato che vuoi registrare.

Ricorda che ogni file nella tua directory di lavoro è in una dei due stati seguenti: tracciato o non tracciato. I file tracciati sono i file presenti nell'ultimo snapshot; possono essere non modificati, modificati o parcheggiati (stage). I file non tracciati sono tutti gli altri - qualsiasi file nella tua directory di lavoro che non è presente nel tuo ultimo snapshot o nella tua area di staging. Quando cloni per la prima volta un repository, tutti i tuoi file sono tracciati e non modificati perché li hai appena prelevati e non hai modificato ancora niente.

Quando modifichi i file, Git li vede come cambiati, perché li hai modificati rispetto all'ultimo commit. Parcheggi questi file e poi esegui il commit di tutti i cambiamenti presenti nell'area di stage, ed il ciclo si ripete. Questo ciclo di vita è illustrato nella Figura 2-1.

Insert 18333fig0201.png
Figure 2-1. Il ciclo di vita dello stato dei tuoi file.

### Controlla lo stato dei tuoi file ###

Lo strumento principale che userai per determinare quali file sono in un certo stato è il comando git status. Se lanci questo comando direttamente dopo aver fatto una clonazione, dovresti vedere qualcosa di simile a:

	$ git status
	# On branch master
	nothing to commit (working directory clean)

Questo significa che hai una directory di lavoro pulita — in altre parole, non c'è traccia di file modificati. Git inoltre non vede altri file non tracciati, altrimenti sarebbero elencati qui. Infine, il comando ci dice in quale ramo (branch) si è. Per ora, è sempre il master, che è il predefinito; non preoccuparti ora di questo. Il prossimo capitolo tratterà delle ramificazioni e dei riferimenti nel dettagli.

Ora diciamo che hai aggiunto un nuovo file al tuo progetto, un semplice file README. Se il file non esisteva prima, e lanci `git status`, vedrai il tuo file non tracciato come segue:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Puoi vedere che il tuo nuovo file README non è tracciato, perché è sotto al titolo "Untracked files" nell'output degli stati. Untracked fondamentalmente significa che Git vede un file che non avevi nel precedente snapshot (commit); Git non inizierà ad includerlo negli snapshot dei tuoi commit fino a quando tu non glielo dirai esplicitamente. Si comporta così per evitare che tu accidentalmente includa file binari generati o qualsiasi altro tipo di file che non vuoi sia incluso. Se vuoi includere il file README, continua con il tracciamento dei file.

### Tracciare nuovi file ###

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

### Parcheggiare file modificati ###

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

Entrambi i file sono parcheggiati ed entreranno nel prossimo commit. A questo punto, supponendo che tu ti sia ricordato di una piccola modifica da fare a benchmarks.rb prima di fare il commit. Apri nuovamente il file ed esegui la modifica, e ora sei pronto per il commit. Come sempre, lanci `git status` ancora una volta:

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

### Ignorare file ###

Spesso, si ha una classe di file che non si vuole automaticamente aggiungere o far vedere come file non tracciati a Git. Ci sono generalmente alcuni file generati automaticamente come i file di log o i file prodotti dalla creazione di un sistema. In questi casi, puoi creare un file chiamato .gitignore con una lista di pattern corrispondente ad essi. Questo è un esempio di file .gitignore:

	$ cat .gitignore
	*.[oa]
	*~

La prima linea dice a Git di ignorare qualsiasi file che finisce con .o o .a — file di oggetti o archivi che possono essere il prodotto di una compilazione del tuo codice. La seconda linea dice a Git di ignorare tutti i file che finiscono con la tilde (`~`), che è usata da alcuni editor di testo come Emacs per marcare i file temporanei. Puoi anche includere directory di log, tmp o pid; documentazioni generate automaticamente; e così via. Imposta un file .gitignore prima di di procedere è generalmente una buona idea, così si evita il rischio di eseguire accidentalmente dei commit dei file che non vuoi nel tuo repository Git.

Le regole per i pattern che puoi mettere nel file .gitignore sono le seguenti:

*	Linee nere o linee che iniziano con # sono ignorate.
*	Standard glob pattern funziona.
*	Puoi terminare i pattern con un diviso (`/`) per specificare una directory.
*	Puoi negare un pattern aggiungendo all'inizio il punto di esclamazione (`!`).

I glob pattern sono semplicemente espressioni regolari usate dalla shell.  Un asterisco (`*`) corrisponde a zero o più caratteri; `[abc]` corrispondente ad ogni carattere all'interno delle parentesi (in questo caso a, b, o c); il punto di domanda (`?`) corrispondente ad un singolo carattere; ed i caratteri all'interno delle parentesi quadre separati dal segno meno (`[0-9]`) corrispondono ad ogni carattere all'interno del range impostato (in questo caso da 0 a 9).

Questo è un altro esempio di file .gitignore:

	# un commento - questo è ignorato
	*.a       # no file .a
	!lib.a    # ma traccia lib.a, mentre vengono ignorati tutti i file .a come sopra
	/TODO     # ignora solamente il file TODO in root, non del tipo subdir/TODO
	build/    # ignora tutti i file nella directory build/
	doc/*.txt # ignora doc/note.txt, ma non doc/server/arch.txt

### Visualizza le tue modifiche parcheggiate e non ###

Se il comando `git status` è troppo vago per te — vorrai conoscere esattamente cosa hai modificato, non solamente i file che hai cambiato — puoi usare il comando `git diff`. Scopriremo in maggior dettaglio `git diff` più avanti; ma probabilmente lo userai più spesso per rispondere a queste due domande: Cosa hai modificato ma non ancora parcheggiato? E cosa hai parcheggiato e che sta per mettere nel commit? Certamente, `git status` risponde a queste domande in generale, `git diff` ti mostra le linee esatte aggiunte e rimosse — la patch, per così dire.

Nuovamente ti chiedo di modificare e parcheggiare il file README e poi modificare il file benchmarks.rb senza parcheggiarlo. Se lanci il comando `status`, vedrai nuovamente questo:

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

Per vedere cosa hai modificato ma non ancora parcheggiato, digita `git diff` senza altri argomenti:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

Questo comando compara cosa c'è nella tua directory di lavoro con quello che è nella tua area di stage. Il risultato ti dice i cambiamenti che hai fatto che non sono ancora stati parcheggiati.

Se vuoi vedere cosa hai parcheggiato e che sarà inviato con il tuo prossimo commit, puoi usare `git diff --cached`. (Nella versione 1.6.1 e successive di Git, puoi usare anche `git diff --staged`, che dovrebbe essere più facile da ricordare.) Questo comando compara i tuoi cambiamenti nell'area di stage ed il tuo ultimo commit:

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

E' importante notare che `git diff` di per se non visualizza tutti i cambiamenti fatti dal tuo ultimo commit — solo i cambiamenti che ancora non sono parcheggiati. Questo può confondere, perché se hai messo in stage tutte le tue modifiche, `git diff` non darà nessun output.

Per un altro esempio, se parcheggi il file benchmarks.rb e lo modifichi, puoi usare `git diff` per vedere i cambiamenti nel file che sono in stage e i cambiamenti che non sono parcheggiati:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#

Ora puoi usare `git diff` per vedere cosa non è ancora parcheggiato

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

e `git diff --cached` per vedere cosa hai parcheggiato precedentemente:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### Eseguire il commit delle tue modifiche ###

Ora la tua area di stage è impostata come volevi, puoi eseguire il commit delle tue modifiche. Ricorda che qualsiasi cosa che non è parcheggiata — qualsiasi file che hai creato o modificato e a cui non hai fatto `git add` — non andrà nel commit. Rimarranno come file modificati sul tuo disco.
In questo caso, l'ultima volta che hai lanciato `git status`, hai visto che tutto era parcheggiato, così sei pronto ad inviare le tue modifiche con un commit. Il modo più semplice per eseguire il commit è di digitare `git commit`:

	$ git commit

Facendo questo lanci l'editor che avevi scelto. (Questo è impostato nella tua shell dalla variabile di ambiente `$EDITOR` — generalmente vim o emacs, ovviamente puoi configurarlo con qualsiasi altro editor usando il comando `git config --global core.editor` come visto nel Capitolo 1).

L'editor visualizzerà il seguente testo (questo è un esempio della schermata di Vim):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Puoi vedere che il messaggio predefinito del commit contiene l'ultimo output del comando `git status`, commentato, e la prima riga in alto è vuota. Puoi rimuovere questi commenti ed inserire il tuo messaggio, o puoi lasciarli così per aiutarti a ricordare cosa hai inviato. (Per avere una nota di ricordo più esplicita puoi passare l'opzione `-v` a `git commit`. Facendo questo metterai la differenza del tuo ultimo cambiamento nell'editor così potrai vedere esattamente cosa hai fatto.) Quando esci dall'editor, Git crea il tuo commit con un messaggio (con il commento ed il diff spogliato).

In alternativa, puoi inserire il messaggio del tuo commit in linea con il comando `commit` specificando dopo di esso l'opzione -m, come segue:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Ora hai creato il tuo primo commit! Puoi vedere che il commit ha riportato alcune informazioni sull'operazione: che ramo hai inviato (al master), che checksum SHA-1 ha il commit (`463dc4f`), quanti file sono stati modificati e le statistiche sulle linee aggiunte e rimosse nel commit.

Ricorda che il commit registra lo snapshot che hai impostato nella tua area di staging. Qualsiasi cosa che non hai parcheggiato rimarrà come modificata; puoi fare un altro commit per aggiungere questi alla storia del progetto. Ogni volta che farai un commit, stai registrando una istantanea del tuo progetto che puoi ripristinare o comparare successivamente.

### Saltare l'area di staging ###

Anche se può essere estremamente utile per amministrare i commit esattamente come li vuoi, l'area di staging è molto più complessa di quanto tu possa averne bisogno nel lavoro normale. Se vuoi saltare l'area di parcheggio, Git fornisce una semplice scorciatoia. Passando l'opzione `-a` al comando `git commit` Git automaticamente parcheggia tutti i file che sono già stati tracciati facendo il commit, permettendoti di saltare la parte `git add`:

	$ git status
	# On branch master
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Nota come non hai bisogno, in questo caso, di lanciare `git add` sul file benchmarks.rb prima del commit.

### Rimuovere file ###

Per rimuovere un file con Git, hai bisogno di rimuoverlo dai file tracciati (più precisamente,  rimuoverlo dall'area di staging) e poi di fare il commit. Il comando `git rm` fa questo ed inoltre rimuove il file dalla tua directory di lavoro così non lo vedrai come un file non tracciato la prossima volta.

Se semplicemente rimuovi il file dalla directory di lavoro, sarà visto sotto l'area "Changed but not updated" (cioè, non parcheggiato) dell'output `git status`:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Poi, se lanci `git rm`, parcheggia il file rimosso:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

La prossima volta che fai il commit, il file se ne andrà e non sarà più tracciato. Se modifichi il file e lo aggiungi nuovamente all'indice, devi forzarne la rimozione con l'opzione `-f`. Questa è una caratteristica di sicurezza per prevenire la rimozione accidentale dei dati che non sono ancora stati registrati in uno snapshot e che non possono essere recuperati da Git.

Un'altra cosa utile che potresti voler fare è mantenere il file nel tuo albero di lavoro ma rimuoverlo dall'area di staging. In altre parole, vuoi mantenere il file sul tuo disco ma non vuoi che Git ne mantenga ancora traccia. Questo è particolarmente utile se ti dimentichi di aggiungere qualcosa al tuo file `.gitignore` ed accidentalmente lo aggiungi, come un lungo file di log od un gruppo di file `.a` compilati. Per fare questo, usa l'opzione `--cached`:

	$ git rm --cached readme.txt

Puoi passare file, directory o glob pattern di file al comando `git rm`. Questo significa che puoi fare cose come

	$ git rm log/\*.log

Nota la barra inversa (`\`) di fronte a `*`. Questo è necessario perché Git ha una sua espansione dei nomi di file in aggiunta all'espansione dei filename della tua shell. Questo comando rimuove tutti i file che hanno l'estensione `.log` nella directory `log/`. O puoi fare qualcosa di simile a:

	$ git rm \*~

Questo comando rimuove tutti i file che finiscono con `~`.

### Movimenti di file ###

A differenza di altri sistemi VCS, Git non traccia esplicitamente i movimenti di file. Se rinomini un file in Git, nessun metadata è immagazzinato in Git che ti dirà che hai rinominato il file. Come sempre, Git è abbastanza intelligente da capire il fatto — ci occuperemo di rilevare il movimento dei file dopo.

Perciò crea un pò di confusione il fatto che Git  abbia un comando `mv`. Se vuoi rinominare un file in Git, puoi lanciare qualcosa come

	$ git mv file_from file_to

e questo lavora bene. Infatti, se lanci qualcosa come questo e guardi lo stato, vedrai che Git considera il file rinominato:

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

Ovviamente, questo è equivalente a lanciare qualcosa come:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git capisce implicitamente che è stato rinominato, così non è un problema rinominare un file in questo modo o con il comando `mv`. L'unica reale differenza è che `mv` è un solo comando invece di tre — non è conveniente.  Più importante è che tu puoi usare qualsiasi strumento per rinominare un file, ed aggiungere/togliere poi prima di un commit.

## Vedere la storia dei commit ##

Dopo che hai creato un po' di commit, o se hai clonato un repository che contiene una storia di commit, probabilmente vuoi guardare indietro per vedere cosa è successo. Lo strumento base e più potente per farlo è il comando `git log`.

Questi esempi usano un progetto veramente semplice chiamato simplegit che è spesso usato per le dimostrazioni. Per ottenere il progetto, lancia:

	git clone git://github.com/schacon/simplegit-progit.git

Quando lanci `git log` in questo progetto, dovresti avere un output che assomiglia a questo:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

In modo predefinito, senza argomenti, `git log` mostra i commit fatti nel repository in ordine cronologico inverso. Così, il commit più recente è mostrato all'inizio. Come puoi vedere, questo comando elenca ogni commit con il suo codice SHA-1, il nome dell'autore e la sua e-mail, la data di scrittura ed il messaggio di invio.

Un enorme numero e varietà di opzioni da passare al comando `git log` sono disponibili per vedere esattamente cosa si sta cercando. Qui, vedremo alcune opzioni più usate.

Una delle opzioni più utili è `-p`, che mostra l'introduzione del diff di ogni commit. Puoi anche usare `-2`, che limita l'output solamente agli ultimi due ingressi: 

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,7 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

Questa opzione visualizza le stessi informazioni ma direttamente seguita dal diff di ogni voce. Questo è veramente utile per la revisione del codice o per navigare velocemente in cosa è successo durante una serie di commit che i collaboratori hanno eseguito.
Puoi anche usare una serie di opzioni di riassunto con `git log`. Per esempio, se vuoi vedere alcune statistiche brevi per ogni commit, puoi usare l'opzione `--stat`:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

Come puoi vedere, l'opzione `--stat` stampa sotto ogni voce di commit una lista dei file modificati, quanti file sono stati modificati, e quante linee in questi file sono state aggiunte o rimosse. Inoltre aggiunge un resoconto delle informazioni alla fine.
Un'altra opzione veramente utile è `--pretty`. Questa opzione modifica gli output di log per la formattazione rispetto a quella predefinita. Alcune opzioni pre-costruite sono pronte all'uso. L'opzione  `oneline` stampa ogni commit in una singola linea, che è utile se stai guardando una lunga serie di commit. In aggiunta le opzioni `sort`, `full` e `fuller` mostrano l'output pressapoco nello stesso modo ma con più o meno informazioni, rispettivamente:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

L'opzione più interessante è `format`, che ti permette di specificare la tua formattazione dell'output di log. Questa è specialmente utile quando stai generando un output da analizzare su una macchina —  perché specifichi in modo preciso il formato, sai che non cambierà con gli aggiornamenti di Git:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

La Tabella 2-1 elenca alcune delle opzioni più utili da usare.

	Opzione	Descrizione dell'output
	%H	Hash commit
	%h	Hash commit abbreviato
	%T	Hash tree
	%t	Hash tree abbreviato
	%P	Hash genitore
	%p	Hash genitore abbreviati
	%an	Nome autore
	%ae	E-mail autore
	%ad	Data autore (rispetta il formato dell'opzione –date= )
	%ar	Data autore, relativa
	%cn	Nome di chi ha fatto il commit
	%ce	E-mail di chi ha fatto il commit
	%cd	Data di chi ha fatto il commit
	%cr	Data di chi ha fatto il commit, relativa
	%s	Oggetto

Sarai sorpreso dalla differenza tra _author_ (l'autore) e _committer_ (chi ha eseguito il commit). L'autore è la persona che originariamente ha scritto il lavoro, mentre chi ha eseguito il commit è la persona che per ultima ha applicato il lavoro. Così, se invii una patch ad un progetto ed uno dei membri del progetto applica la patch, entrambi sarete riconosciuti — tu sei l'autore ed il membro del progetto chi ha eseguito il commit. Scopriremo meglio questa distinzione nel Capitolo 5.

Le opzioni oneline e format sono particolarmente utili con un'altra opzione `log` chiamata `--graph`. Questa opzione aggiunge un grafico ASCII carino che mostra le diramazioni e le unioni della storia, che possiamo vedere nella copia del repository del progetto Grit:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

Queste sono solo alcune opzioni semplici per la formattazione dell'output di `git log` — ce ne sono altri. La tabella 2-2 elenca le opzioni che abbiamo visto prima e altre opzioni comunemente usate che possono essere utili per cambiare l'output del comando log.

	Opzione	Descrizione
	-p	Mostra la patch introdotta per ogni commit.
	--stat	Mostra le statistiche per i file modificati in ogni commit.
	--shortstat	Mostra solo le linee cambiate/inserite/cancellate dal comando --stat.
	--name-only	Mostra la lista dei file modificati dopo le informazione del commit.
	--name-status	Mostra la lista dei file con le informazioni di aggiunte/modifiche/rimozioni.
	--abbrev-commit	Mostra solo i primi caratteri del codice checksum SHA-1 invece di tutti e 40.
	--relative-date	Mostra la data in un formato relativo (per esempio, "2 week ago", "2 settimane fa") invece di usare l'intero formato della data.
	--graph	Mostra un grafico ASCII dei rami e delle unioni della storia accando all'output di log.
	--pretty	Mostra i commit in un formato alternativo. L'opzione include oneline, short, full, fuller, e format (dove hai specificato la tua formattazione).

### Limitare l'output di Log ###

Oltre alle opzioni per la formattazione dell'output, git log accetta un numero di opzioni di limitazione — cioè, opzioni che ti permettono di vedere solo alcuni commit. Hai già visto una opzione del genere — l'opzione `-2`, che mostra solamente gli ultimi due commit. Infatti, puoi fare `-<n>`, dove `n` è un intero per vedere gli ultimi `n` commit. In realtà, non userai spesso questa possibilità, perché Git di base presenta tutti gli output tramite una pagina così vedrai solamente una pagina di log al momento.

Ovviamente, le opzioni di limitazione temporali come `--since` e `--until` sono molto utili. Per esempio, questo comando prende la lista dei commit fatti nelle ultime due settimane:

	$ git log --since=2.weeks

Questo comando funziona con molti formati —  puoi specificare una data (“2008-01-15”) o una data relativa come “2 years 1 day 3 minutes ago”.

Puoi inoltre filtrare l'elenco dei commit che corrispondono a dei criteri di ricerca. L'opzione `--author` ti permette di filtrare uno specifico autore e l'opzione `--grep` permette di cercare fra delle parole chiavi nei messaggi dei commit. (Nota che se vuoi specificare sia le opzioni author e grep, devi aggiungere `--all-match` o il comando ricercherà i commit sia di uno sia di quell'altro.)

L'ultima opzione di filtro veramente utile da passare a `git log` è path.  Se specifichi una directory o un nome di file, puoi limitare l'output del log ai commit che introducono modifiche a questi file. E' sempre l'ultima opzione fornita ed è generalmente preceduta dal doppio meno (`--`) per separare i path dalle opzioni.

Nella tabella 2-3 vediamo una lista di riferimento di queste e di altre opzioni comuni.

	Opzioni	Descrizione
	-(n)	Vedi solo gli ultimi n commit
	--since, --after	Limita ai commit fatti prima o dopo una data specificata.
	--until, --before	Limita ai commit fatti prima o fino ad una specifica data.
	--author	Visualizza solo i commit in cui l'autore corrisponde alla stringa specificata.
	--committer	Visualizza solo i commit dove chi ha eseguito il commit corrisponde alla stringa specificata.

Per esempio, se vuoi vedere quali commit modificano i file nella storia del codice sorgente di Git dove Junio Hamano ha eseguito i commit  e non sono stati unificati nel mese di Ottobre del 2008, puoi lanciare qualcosa di simile a:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Ci sono circa 20,000 commit nella storia del codice sorgente di git, questo comando mostra 6 righe corrispondenti ai termini di ricerca.

### Usare una GUI per visualizzare la storia ###

Se vuoi usare uno strumento più grafico per visualizzare la storia dei tuoi commit, puoi vedere un programma in Tck/Tk chiamato gitk che è distribuito con Git. Gitk è fondamentalmente uno strumento visuale come `git log`, e accetta circa tutte le opzioni di filtro che `git log` ha. Se digiti gitk dalla riga di comando del tuo progetto, dovresti vedere qualcosa di simile alla Figura 2-2.

Insert 18333fig0202.png
Figure 2-2. Il visualizzatore della storia gitk.

Puoi vedere la storia dei commit nella metà alta della finestra con un grafico genealogico. La finestra di diff nella metà inferiore mostra i cambiamenti introdotti ad ogni commit che selezioni.

## Annullare le cose ##

Ad ogni stadio potresti voler annullare qualcosa. Qui, vedremo alcuni strumenti fondamentali per annullare i cambiamenti che hai fatto.  Attenzione, perché non sempre puoi annullare alcuni annullamenti. Questa è una delle aree in Git dove puoi perdere qualche lavoro se sbagli.

### Modifica il tuo ultimo commit ###

Uno degli annullamenti comuni è quando invii troppo presto un commit e magari dimentichi di aggiungere alcuni file, o ti dimentichi di inserire un messaggio. Se provi nuovamente questo commit, puoi rilanciarlo con l'opzione `--amend`:

	$ git commit --amend

Questo commando prende la tua area di parcheggio e la usa per il commit. Se non hai fatto cambiamenti dal tuo ultimo commit (per esempio, lanci questo comando subito dopo il tuo commit precedente), allora il tuo snapshot sarà esattamente uguale e potrai cambiare il tuo messaggio di commit.

L'editor per il messaggio del commit apparirà, ma già contiene il messaggio del commit precedente. Puoi modificare il messaggio come sempre, ma sovrascriverà il commit precedente.

Come esempio, se fai il commit e poi realizzi di aver dimenticato un cambiamento nella tua area di stage di un file e vuoi aggiungerlo a questo commit, puoi farlo così:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Tutti e tre i comandi finisco in un singolo commit —  il secondo commit riscrive il risultato del primo.

### Disimpegnare un file parcheggiato ###

Le prossime due sezioni mostrano come gestire le modifiche della tua area di parcheggio (area di stage) e della directory di lavoro. La parte divertente è che il comando che usi per determinare lo stato di queste due aree ricorda come annullare i cambiamenti fatti. Per esempio, supponiamo che hai modificato due file e vuoi inviarli come modifiche separate, ma accidentalmente digiti `git add *` e li parcheggi entrambi. Come puoi disimpegnare uno dei due? Il comando `git status` ti ricorda:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Ora il testo sotto “Changes to be committed”, dice di usare `git reset HEAD <file>...` per annullare. Così, usa questo avviso per disimpegnare il file benchmarks.rb dal parcheggio:

	$ git reset HEAD benchmarks.rb
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Il comando è un po' strano, ma funziona. Il file benchmarks.rb è modificato ma non parcheggiato.

### Annullare la modifica ad un file ###

Come fare se hai realizzato che non vuoi più tenere le modifiche che hai fatto al file benchmarks.rv? Come puoi annullarle facilmente — ritornare a come era al tuo ultimo commit (o alla clonazione iniziale, o come lo avevi nella tua directory di lavoro)? Fortunatamente, `git status` ci dice come farlo. Nell'ultimo output di esempio, l'area di unstage (file non parcheggiati) assomiglia a:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Ci dice abbastanza esplicitamente come annullare le modifiche fatte (al limite, le nuove versioni di Git, 1.6.1 e successive, lo fanno —  se hai una versione più vecchia è raccomandato aggiornarla per avere queste funzioni utili). Vediamo cosa ci dice:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Puoi vedere come le modifiche sono state annullate. Dovresti inoltre realizzare che è un comando pericoloso: ogni cambiamento fatto al file è sparito — semplicemente hai copiato un altro file su di esso. Non usare mai questo comando a meno che non sai assolutamente cosa stai facendo. Se hai bisogno di riprenderlo in qualche modo, vai nei capitoli successivi sullo stashing e branching; queste sono generalmente le vie migliori da seguire.

Ricorda, qualsiasi cosa che è stata affidata a Git può essere recuperata. Tutti i commit che sono sui rami che sono stati cancellati o inviati con una sovra-scrizione tramite un commit `--amend` possono essere recuperati (vedi il Capitolo 9 per il recupero dei dati). Ovviamente, qualsiasi cosa che perdi e che non è stata affidata a Git non sarà più vista in futuro.

## Lavorare con sorgenti remote ##

Per essere in grado di collaborare con un qualsiasi progetto Git, hai bisogno di sapere come amministrare il tuo repository remoto. I repository remoti sono versioni di progetti che sono ospitati in Internet o su una rete da qualche parte. Puoi averne più di uno, molti dei quali possono essere di sola lettura o di scrittura e lettura per te. Collaborare con altri implica di sapere amministrare questi repository remoti e mettere e togliere i dati a e da questi quando hai necessità di condividerli per lavoro.
Amministrare repository remoti include il sapere aggiungere repository remoti, rimuovere quelli che non sono validi, amministrare vari rami remoti e definire quando sono tracciati o meno, e altro. In questa sezione, vedremo le tecniche di amministrazione remota.

### Visualizzare il sorgente remoto ###

Per vedere quale server remoto hai configurato, puoi lanciare il comando git remote. Questo elenca i soprannomi di ogni nodo specificato. Se hai clonato il tuo repository, dovresti al limite vedere origin —  che è il nome predefinito che Git da al server che hai clonato:

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote
	origin

Puoi anche specificare `-v`, che mostra l'URL che Git ha salvato per il soprannome:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

Se hai più di un repository remoto, il comando li elenca tutti. Per esempio, il mio repository Grit assomiglia a questo.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Questo significa che possiamo prendere i contributi da qualsiasi di questi utenti in modo facile. Ma nota che solo origin è un URL SSH, è l'unico dove posso fare il push (vedremo questa cosa nel Capitolo 4).

### Aggiungere un repository remoto ###

Ho menzionato e fornito alcune dimostrazioni, nelle sezioni precedenti, sull'aggiunta di repository remoti, ma qui scendo nello specifico. Per aggiungere un nuovo repository Git con un soprannome per riconoscerlo velocemente, avvia `git remote add [soprannome] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Ora puoi usare la stringa pb dalla linea di comando al posto dell'intero URL. Per esempio, se vuoi prelevare tutte le informazioni che Paul ha ma che ancora non hai nel tuo repository, puoi lanciare git fetch pb:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Il ramo master di Paul è accessibile localmente come `pb/master` —  puoi unirlo in uno dei tuoi rami, o puoi caricare un tuo ramo locale a questo punto per ispezionarlo.

### Prelevare ed attirare da sorgenti in remoto ###

Come già visto, per ottenere i dati da un progetto remoto, puoi farlo:

	$ git fetch [nome-remoto]

Il comando va sul progetto remoto e si tira giù tutti i dati dal progetto remoto che ancora non hai. Dopo aver fatto questo, dovresti avere tutti i riferimenti ai rami da questa sorgente remota, che poi potrai fondere o ispezionare in ogni momento. (Vedremo cosa sono i rami e come usarli in maggior dettaglio al Capitolo 3.)

Se hai clonato un repository, il comando automaticamente aggiunge un repository remoto sotto il nome origin. Così, `git fetch origin` preleva ogni lavoro che è stato inserito su quel server da quando hai fatto la clonazione (o dall'ultimo prelievo). E' importante notare che il comando fetch mette i dati nel tuo repository locale — non unisce automaticamente e non modifica alcun file su cui tu stai lavorando. Devi eseguire la fusione manualmente nel tuo lavoro, quando sei pronto.

Se hai un ramo impostato per tracciare un ramo remoto (vedi la prossima sezione e il Capitolo 3 per maggiori informazioni), puoi usare il comando `git pull` per prelevare automaticamente e poi fondere un ramo remoto nel ramo corrente. Questo è un modo più facile e comodo di lavorare; e in modo predefinito, il comando `git clone` automaticamente imposta il tuo ramo locale master per tracciare il ramo remoto master del server che hai clonato (assumendo che il sorgente remoto ha un ramo master). Lanciare `git pull` generalmente preleva i dati dal server di origine clonato e automaticamente prova a fondere il codice con il codice su cui stai lavorando.

### Buttare nel sorgente remoto ###

Quando hai il tuo progetto al punto che lo vuoi condividere, devi metterlo (fare il push) online (in upstream). Il comando per fare questo è semplice: `git push [nome-remoto] [nome-ramo]`. Se vuoi fare il push del tuo ramo master al tuo server `origin` (ancora, generalmente con la clonazione sono impostati entrambi questi nomi automaticamente), puoi lanciare il push per mettere il tuo lavoro sul server:

	$ git push origin master

Questo comando funziona solamente se hai fatto una clonazione da un server in cui hai i permessi di scrittura e se nessuno ha fatto un push nel mentre. Se tu o qualcuno clona un repository nello stesso momento e fanno il push in upstream, il tuo push verrà rigettato. Devi prima scaricare il loro lavoro ed incorporarlo nel tuo per poter inviare le tue modifiche. Vedi il Capitolo 3 per maggiori dettagli ed informazioni su come fare il push su server remoti.

### Ispezionare un sorgente remoto ###

Se vuoi vedere più informazioni su una sorgente remota in particolare, puoi usare il comando `git remote show [nome-remoto]`. Se lanci il comando con un soprannome particolare, come `origin`, avrai qualcosa di simile a questo:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Questo elenca tutti gli URL del repository remoto oltre che alle informazione sui rami tracciati. Il comando fortunatamente ti dirà che sei sul ramo principale e se lanci `git pull`, questo automaticamente unirà il ramo master sul server remoto dopo aver prelevato tutte le referenze remote. Inoltre elencherà le referenze che saranno scaricate.

Questo è un semplice esempio che potrai incontrare. Quando usi moltissimo Git, ovviamente, potrai vedere molte informazioni da `git remote show`:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

Questo comando mostra quale ramo è automaticamente caricato quando lanci `git push` su certe diramazioni. Inoltre ti mostrerà quali rami remoti sul server che ancora non possiedi, quali rami remoti possiedi e che saranno rimossi dal server, e le diramazioni che saranno automaticamente unite quando lancerai `git pull`.

### Rimuovere e rinominare sorgenti remote ###

Se vuoi rinominare una referenza, nelle nuove versioni di Git, puoi lanciare `git remote rename` per cambiare il soprannome di un sorgete remoto. Per esempio, se vuoi rinominare `pb` in `paul`, puoi farlo con `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Vale la pena ricordare che questo cambia anche i nomi dei rami remoti. Quello che prima era riferito a `pb/master` ora è `paul/master`.

Se vuoi rimuovere una referenza per una qualche ragione — hai spostato il server o non stai più usando un mirror particolare, o magari un collaboratore non collabora più — puoi usare `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

### Tagging ###

Come la maggior parte dei VCS, Git ha la possibilità di aggiungere dei tag, dei riferimenti, a dei punti specifici, che sono importanti, della storia. Generalmente, le persone usano questa funzionalità per marcare i punti di rilascio (v1.0, e così via). In questa sezione, imparerai come elencare i tag disponibili, come crearne di nuovi, e i differenti tipi di tag esistenti.

### Elencare i propri tag ###

Elencare i tag disponibili in Git è facilissimo. Semplicemente digita `git tag`:

	$ git tag
	v0.1
	v1.3

Questo comando elenca i tag in ordine alfabetico; l'ordine con il quale compaiono non è realmente importante.

Puoi inoltre cercare i tag con un pattern specifico. Il repo sorgente di Git, per esempio, contiene più di 240 tag. Se sei solo interessato a vedere quelli della serie 1.4.2, puoi lanciare:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creare tag ###

Git usa due principali tipi di tag: lightweight (semplificati) e annotated (commentati). Un tag lightweight è molto simile ad un ramo che non è cambiato —  è semplicemente un riferimento ad uno specifico commit. I tag annotated, tuttavia, sono salvati come oggetti nel database Git. Ne viene calcolato il checksum; contengono il nome, l'e-mail e la data di chi ha inserito il tag; hanno un messaggio; e possono essere firmati e verificati con GNU Privacy Guard (GPG). E' generalmente raccomandato creare tag annotated così puoi avere tutte queste informazioni; ma se vuoi temporaneamente inserire un tag e per qualche ragione non vuoi avere queste informazioni, i lightweight tag, o tag semplificati, sono ancora disponibili.

### Annotated tag (tag commentati) ###

Creare un tag annotated in Git è semplice. La via più facile è specificare `-a` quando si lancia il comando `tag`:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

`-m` specifica il messaggio, che è salvato con il tag. Se non specifichi un messaggio per i tag annotated, Git lancerà il tuo editor così potrai inserirlo.

Puoi vedere i dati del tag assieme al commit in cui è stato inserito il tag con il comando `git show`:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Questo mostra le informazioni di chi ha eseguito il tag, la data del commit del tag, ed il messaggio prima di mostrare le informazioni del commit.

### Firmare i tag ###

Puoi anche firmare i tuoi tag con GPG, assumendo che tu hai una chiave privata. Tutto quello che devi fare è usare `-s` invece di `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Se lanci `git show` su questo tag, potrai vedere la tua firma GPG in allegato ad essa:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

Più avanti, imparerai come verificare i tag firmati.

### Lightweight tag (tag semplici) ###

Un altro modo per marcare i commit è usare i tag lightweight. Questo è semplicemente fare il checksum del commit salvato in un file — nessun'altra informazione è mantenuta. Per creare un tag semplificato, non fornire l'opzione `-a`, `s` o `-m`:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

A questo punto, se lanci `git show` sul tag, non vedrai altre informazioni aggiuntive. Il comando semplicemente mostra il commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verificare i tag ###

Per verificare i tag firmati, usa `git tag -v [nome-tag]`. Questo comando usa la verifica GPG della firma. Avrai bisogno della chiave pubblica del firmatario nel tuo portachiavi affinché funzioni correttamente:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

Se non hai la chiave pubblica del firmatario, otterrai qualche cosa di simile a questo invece:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Inserire un tag successivamente ###

Puoi anche marcare con tag i commit che già sono stati inviati. Supponiamo che la storia dei tuoi commit è come questa: 

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Ora, supponiamo che ti sei dimenticato di mettere il tag v1.2 al tuo progetto, che è al commit "updated rakefile". Puoi aggiungerlo successivamente. Per marcare questo commit, devi specificare il checksum (o parte di esso) del commit alla fine del comando:

	$ git tag -a v1.2 9fceb02

Puoi vedere che hai marcato il commit:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Condividere i tag ###

Di base, il comando `git push` non trasferisce i tag sui server remoti. Devi esplicitamente inviare i tag da condividere con il server dopo averli creati. Questo processo è come condividere branche remote — puoi lanciare `git push origin [nometag]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Se hai molti tag che puoi inviare tutti assieme, puoi farlo usando l'opzione `--tags` del comando `git push`. Questo trasferirà tutti i tuoi tag sul server remoto che non sono ancora presenti.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Ora, quando qualcun altro clona o scarica dal tuo repository, avrà anche tutti i tuoi tag.

## Tips and Tricks ##

Prima di finire questo capitolo sulle basi di Git, ecco alcuni suggerimenti e trucchi per rendere l'esperienza nell'uso di Git più semplice, facile e familiare. Molte persone usano Git senza usare questi consigli e non vogliamo riferirci a loro o presumere di usarli successivamente nel libro; ma si dovrebbero conoscere.

### Auto completamento ###

Se usi una shell Bash, Git fornisce un piacevole script di auto completamento che può essere usato. Scarica il codice sorgente di Git, e guarda nella directory `contrib/completation`; dovrebbe esserci un file chiamato `git-completation.bash`. Copia questo file nella tua directory di home e aggiungila al tuo file `.bashrc`:

	source ~/.git-completion.bash

Se vuoi impostare Git per avere l'auto completamento della shell Bash per tutti gli utenti, copia lo script nella directory `/opt/local/etc/bash_completion.d` sui sistemi Mac o in `/etc/bash_completion.d/` sui sistemi Linux. Questa è una directory degli script che Bash automaticamente carica per fornire l'auto completamento da shell.

Se stai usando Windows con Git Bash, che è l'installazione di base per Git su Windows con msysGit, l'auto completamento dovrebbe essere preconfigurato.

Premi il tasto Tab quando stai scrivendo un comando Git, e dovresti avere una serie di suggerimenti da selezionare:

	$ git co<tab><tab>
	commit config

In questo caso, scrivendo git co a poi premendo il tasto Tab due volte compaiono i suggerimenti commit e config. Aggiungendo `m<tab>` si completa `git commit` automaticamente.

Questo funziona anche con le opzioni, cosa che forse è molto più utile. Per esempio, se si lancia il comando `git log` e non si ricorda una opzione, si può iniziare a pigiare il tasto Tab per vedere le corrispondenze:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Questo è un trucco davvero utile e permette di risparmiare molto tempo e lettura della documentazione.

### Alias con Git ###

Git non deduce il comando se si digita solo in parte. Se non si vuole scrivere l'intero testo di qualsiasi comando Git, puoi facilmente scegliere un alias per ogni comando, usando `git config`. Qui ci sono un po' di esempi su alcune configurazioni che potresti volere impostare:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Questo significa che, per esempio, invece di digitare `git commit`, hai solamente bisogno di scrivere `git ci`. Andando avanti con l'uso di Git, probabilmente ci saranno altri comandi che userai di frequente; in questi casi, non esitare a creare nuovi alias.

Questa tecnica può anche essere molto utile per creare comandi che pensi non esistono. Per esempio, per correggere un problema comune in cui si incorre quando si vuole disimpegnare un file dall'area di stage, puoi aggiungere il tuo alias unstage a Git:

	$ git config --global alias.unstage 'reset HEAD --'

Questo rende i seguenti due comandi equivalenti:

	$ git unstage fileA
	$ git reset HEAD fileA

Questo sembra più pulito. E' anche comodo aggiungere il comando `last`, come:

	$ git config --global alias.last 'log -1 HEAD'

In questo modo puoi vedere l'ultimo commit facilmente:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Git semplicemente sostituisce il nuovo comando con quello che corrisponde nell'alias. Magari, vuoi avviare un comando esterno, invece dei sotto comandi Git. In questo caso, devi avviare il comando con il carattere "!". Questo è utile se stai scrivendo i tuoi strumenti di lavoro con un repository Git. Per esempio creiamo un alias `git visual` per lanciare `gitk`:

	$ git config --global alias.visual "!gitk"

## Conclusione ##

A questo punto, sei in grado di fare tutte le operazioni di Git base in locale — creare o clonare un repository, fare delle modifiche, parcheggiare ed inviare queste modifiche, vedere la storia di tutti i cambiamenti del repository fatti. Nel prossimo capitolo, vedremo una caratteristica di Git da suicidio (la killer feature): il suo modello di ramificazione.
