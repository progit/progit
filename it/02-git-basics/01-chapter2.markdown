# Basi di Git #

Se puoi leggere un solo capitolo per imparare Git, leggi questo.  Questo capitolo illustra tutti i comandi base di cui hai bisogno per la stragrande maggioranza delle cose che farai con Git. Alla fine del capitolo sarai in grado di configurare e creare un repository, iniziare e interrompere il tracciamento dei file e mettere in stage e committare le modifiche. Vedremo come impostare Git per ignorare certi file o pattern, come annullare velocemente e facilmente gli errori, come navigare la cronologia del tuo progetto e vedere le modifiche tra le varie commit e come fare il push ed il pull da repository remoti.

## Repository Git ##

Puoi creare un progetto Git principalmente con due approcci. Il primo prende un progetto esistente o una directory e la importa in Git. Il secondo clona un repository Git esistente, su un altro server.

### Creare un repository in una directory preesistente ###

Se vuoi iniziare a tenere traccia con Git di un progetto esistente, devi andare nella directory del progetto e digitare:

	$ git init

Questo creerà una nuova sottodirectory chiamata `.git` che conterrà tutti i file necessari per il tuo repository, una struttura del repository Git. A questo punto non è ancora stato tracciato niente del tuo progetto. (Vedi il *Capitolo 9* per sapere quali file sono contenuti nella directory `.git` che hai appena creato.)

Se vuoi iniziare a tracciare i file esistenti (a differenza di una directory vuota), dovresti iniziare a monitorare questi file con una commit iniziale. Lo puoi fare con pochi `git add`, che specificano quali file vuoi tracciare, seguiti da una commit: 

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

Tra un minuto vedremo cosa fanno questi comandi. A questo punto hai un repository Git con dei file tracciati e una commit iniziale.

### Clonare un Repository Esistente ###

Se vuoi copiare un repository Git esistente — per esempio, un progetto a cui vuoi contribuire — il comando di cui hai bisogno è `git clone`. Se hai familiarità con altri sistemi VCS come Subversion, noterai che il comando è `clone` e non `checkout`. Questa è una distinzione importante: Git riceve una copia di quasi tutti i dati che sono sul server. Quando esegui `git clone` vengono scaricate tutte le versioni di ciascun file della cronologia del progetto. Infatti, se si danneggiasse il disco del tuo server, potresti usare qualsiasi clone di qualsiasi client per ripristinare il server allo stato in cui era quando è stato clonato (potresti perdere alcuni `hooks` lato-server, ma tutte le versioni dei dati saranno presenti: vedi il *Capitolo 4* per maggiori dettagli).

Cloni un repository con `git clone [url]`. Per esempio, se vuoi clonare la libreria Ruby Git chiamata Grit, puoi farlo così:

	$ git clone git://github.com/schacon/grit.git

Questo comando crea un directory "grit", dentro di questa inizializza una directory `.git`, scarica tutti i dati del repository e fa il checkout dell'ultima versione per poterci lavorare su. Se vai nella nuova directory `grit`, vedrai i file del progetto, pronti per essere modificati o usati. Se vuoi clonare il repository in una directory con un nome diverso da grit, puoi specificarlo sulla riga di comando:

	$ git clone git://github.com/schacon/grit.git mygrit

Questo comando fa la stessa cosa del precedente, ma la directory di destinazione è chiamata `mygrit`.

Git può usare differenti protocolli di trasferimento. L'esempio precedente usa il protocollo `git://`, ma puoi anche vedere `http(s)://` o `user@server:/path.git`, che usa il protocollo di trasferimento SSH. Il *Capitolo 4* introdurrà tutte le opzioni che un server può rendere disponibili per l'accesso al repository Git e i pro e i contro di ciascuna.

## Salvare le modifiche sul repository ##

Hai clonato un vero repository Git e hai la copia di lavoro dei file del progetto. Ora puoi fare qualche modifica e inviare gli snapshots di queste al tuo repository ogni volta che il progetto raggiunga uno stato che vuoi salvare.

Ricorda che ogni file della tua directory di lavoro può essere in uno dei due stati seguenti: *tracked* (tracciato, ndt.) o *untracked* (non tracciato, ndt.). I file *tracked* sono già presenti nell'ultimo snapshot; possono quindi essere *unmodified* (non modificati, ndt.), *modified* (modificati, ndt.) o *staged*. I file *untracked* sono tutti gli altri: qualsiasi file nella tua directory di lavoro che non è presente nell'ultimo snapshot o nella tua area di stage. Quando cloni per la prima volta un repository, tutti i tuoi file sono tracciati e non modificati perché li hai appena prelevati e non hai modificato ancora niente.

Quando editi dei file, Git li vede come modificati, perché sono cambiati rispetto all'ultima commit. Metti nell'area di stage i file modificati e poi fai la commit di tutto ciò che è in quest'area, e quindi il ciclo si ripete. Questo ciclo di vita è illustrato nella Figura 2-1.

Insert 18333fig0201.png
Figura 2-1. Il ciclo di vita dello stato dei tuoi file.

### Controlla lo stato dei tuoi file ###

Lo strumento principale che userai per determinare lo stato dei tuoi file è il comando `git status`. Se esegui questo comando appena dopo un clone, dovresti vedere qualcosa di simile:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Questo significa che hai una directory di lavoro pulita, ovvero che nessuno dei file tracciati è stato modificato. Inoltre Git non ha trovato nessun file non ancora tracciato, altrimenti sarebbero elencati qui. In aggiunta il comando indica anche in quale ramo sei. Per ora, è sempre `master`, che è il predefinito; non preoccupartene per ora. Il prossimo capitolo tratterà in dettagli dei `branch` (ramificazioni) e dei riferimenti.

Immagina di aver aggiunto un nuovo file al tuo progetto, un semplice README. Se il file non esisteva e lanci `git status`, vedrai così il file non tracciato:

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)
	
	        README

	nothing added to commit but untracked files present (use "git add" to track)

Puoi vedere che il nuovo file README non è tracciato poiché nell'output è nella sezione dal titolo "Untracked files". `Untracked` significa che Git vede un file che non avevi nello `snapshot` precedente (commit); Git non lo includerà negli snapshot delle tuoe commit fino a quando non glielo dirai esplicitamente. Fa così per evitare che includa accidentalmente dei file binari generati o qualsiasi altro tipo di file che non intendi includere. Se vuoi includere il  README, iniziamo a tracciarlo.

### Tracciare Nuovi File ###

Per iniziare a tracciare un nuovo file, si usa il comando `git add`. Per tracciare il file `README`, usa questo comando:

	$ git add README

Se lanci nuovamente il comando per lo stato, puoi vedere il tuo file `README` ora è tracciato e nell'area si `stage`:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	

Sai che è nell'area di `stage` perché è nella sezione "Changes to be committed". Se a questo punto fai commit, la versione del file com'era quando hai lanciato `git add` sarà quella che troverai nella cronologia dello snapshot. Ricorderai che quando prima hai eseguito `git init`, poi hai dovuto lanciare `git add (file)`, che era necessario per iniziare a tracciare i file nella tua directory. Il comando `git add` accetta il nome del percorso di un file o una directory; se è una directory, il comando aggiunge ricorsivamente tutti i file in quella directory.

### Fare lo stage dei file modificati ###

Modifichiamo un file che è già tracciato. Se modifichi un file tracciato chiamato `benchmarks.rb` e poi esegui il comando `status`, otterrai qualcosa di simile a:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Il file benchmarks.rb appare nella sezione chiamata "Changes not staged for commit" — che significa che un file tracciato è stato modificato nella directory di lavoro ma non è ancora nello stage. Per farlo, esegui il comando `git add` (è un comando multifunzione — lo usi per iniziare a tracciare nuovi file, per fare lo stage dei file e per fare altre cose segnare come risolti i conflitti causati da un `merge`). Esegui `git add` per mettere in `stage` il file benchmarks.rb, e riesegui `git status`:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

Entrambi i file sono nello `stage` e staranno nella prossima commit. A questo punto, immagina che ti sia ricordato di una piccola modifica da fare in 'benchmarks.rb' prima della commit. Riapri il file e fai la modifica: ora sei pronto per la commit. Come sempre, esegui `git status` di nuovo:

	$ vim benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Cos'è successo? Ora `benchmarks.rb` è elencato sia dentro che fuori lo `stage`. Come è possibile? È saltato fuori che Git ha messo in `stage` il file esattamente com'era quando hai eseguito `git add`. Se committi ora, la versione di `benchmarks.rb` che verrà committata sarà quella che avevi quando hai eseguito il `git add`, non la versione del file che trovi nella directory di lavoro quando esegui `git commit`. Se modifichi un file dopo che hai eseguito `git add`, ridevi eseguire `git add` per mettere nello `stage` l'ultima versione del file:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

### Ignorare File ###

Spesso hai un tipo di file che non vuoi che Git li aggiunga automaticamente e nemmeno te li mostri come tracciati. Generalmente si tratta di file generati automaticamente, come i log o quelli prodotti dal tuoi sistema di `build`. In questi casi puoi creare un file chiamato `.gitignore` con la lista di pattern dei file che vuoi ignorare. Questo è un `.gitignore` d'esempio:

	$ cat .gitignore
	*.[oa]
	*~

La prima riga dice a Git di ignorare qualsiasi file che finisce in `.o` o `.a` — file di oggetti o archivi che possono essere il prodotto di una compilazione del tuo codice. La seconda riga dice a Git di ignorare tutti i file che finiscono con tilde (`~`), che è usata da alcuni editor di testo come Emacs per marcare i file temporanei. Puoi anche includere le directory `log`, `tmp` o `pid`, documenti generati automaticamente e così via. Definire un file `.gitignore` prima di iniziare generalmente è una buona idea, così eviti il rischio di committare accidentalmente dei file che non vuoi nel tuo repository Git.

Queste sono le regole per i pattern che puoi usare in `.gitignore`:

*	Le righe vuote o che inizino con `#` vengono ignorate.
*	Gli standard `glob pattern` funzionano (http://it.wikipedia.org/wiki/Glob_pattern, ndt).
*	Puoi terminare i pattern con uno slash (`/`) per indicare una directory.
*	Puoi negare un pattern facendolo iniziare con un punto esclamativo (`!`).

I `glob pattern` sono come espressioni regolari semplificate, usate dalla shell. L'asterisco (`*`) corrisponde a zero o più caratteri; `[abc]` corrisponde a ogni carattere all'interno delle parentesi (in questo caso `a`, `b`, o `c`); il punto interrogativo (`?`) corrisponden ad un carattere singolo; e i caratteri all'interno delle parentesi quadre separati dal segno meno (`[0-9]`) corrispondono ad ogni carattere all'interno dell'intervallo (in questo caso da 0 a 9).

Questo è un altro esempio di file .gitignore:

	# un commento - questo è ignorato
	# escludi i file .a
	*.a
	# ma traccia lib.a, sebbene su tu stia ignorando tutti i file `.a`
	!lib.a
	# ignora solo il TODO nella root, e non subdir/TODO
	/TODO
	# ignora tutti i file nella directory build/
	build/
	# ignora doc/note.txt, ma non doc/server/arch.txt
	doc/*.txt
	# ignora tutti i file .txt nella directory doc/
	doc/**/*.txt

Il pattern `**/` è disponibile in Git dalla version 1.8.2.

### Mostra le modifiche dentro e fuori lo `stage` ###

Se `git status` è troppo vago per te - vuoi sapere cos'è stato effettivamente modificato e non solo quali file — puoi usare il comando `git diff`. Tratteremo più avanti `git diff` con maggior dettaglio, ma probabilmente lo userai molto spesso per rispondere a queste due domande: Cos'è che hai modificato ma non è ancora in `stage`? E cos'hai nello `stage` che non hai ancora committato? Sebbene `git status` risponda a queste domande in modo generico, `git diff` mostra le righe effettivamente aggiunte e rimosse — la patch così com'è.

Supponiamo che tu habbia modificato nuovamente `README` e `benchmarks.rb` ma messo nello `stage` solo il primo. Se esegui il comando `status`, vedrai qualcosa come questo:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Per vedere cosa hai modificato, ma non ancora nello `stage`, digita `git diff` senza altri argomenti:

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

Questo comando confronta cosa c'è nella tua directory di lavoro con quello che c'è nella tua area di `stage`. Il risultato mostra le tue modifiche che ancora non hai messo nello `stage`.

Se vuoi vedere cosa c'è nello `stage` e che farà parte della prossima commit, puoi usare `git diff --cached`. (Da Git 1.6.1 in poi, puoi usare anche `git diff --staged`, che dovrebbe essere più facile da ricordare). Questo comando confronta le modifiche che hai nell'area di `stage` e la tua ultima commit:

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

È importante notare che `git diff` di per se non visualizza tutte le modifiche fatte dall'ultima commit, ma solo quelle che non sono ancora in `stage`. Questo può confondere, perché se hai messo in `stage` tutte le tue modifiche, `git diff` non mostrereà nulla.

Ecco un altro esempio, se metti in `stage` il file `benchmarks.rb` e lo modifichi, puoi usare `git diff` per vedere quali modifiche al file sono in stage e i quali non ancora:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

Puoi quindi usare `git diff` per vedere cosa non è ancora in `stage`

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

e `git diff --cached` per vedere cos'è già in `stage`:

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

### Committa le tue modifiche ###

Ora che la tua area di stage è configurata come vuoi, puoi fare la commit delle tue modifiche. Ricorda che tutto ciò che non è in `stage` — qualsiasi file che hai creato o modificato per cui non hai fatto `git add` — non sarà nella commit. Rimarranno come file modificati sul tuo disco.
In questo caso, l'ultima volta che hai eseguito `git status`, hai visto che tutto era in `stage`, così sei pronto a committare le tue modifiche. Il modo più semplice per farlo è eseguire `git commit`:

	$ git commit

Facendolo lanci il tuo editor predefinito. (Questo è impostato nella tua shell con la variabile di ambiente `$EDITOR` — generalmente vim o emacs, sebbene tu possa configurarlo con qualsiasi altro editor, usando il comando `git config --global core.editor` come hai visto nel *Capitolo 1*).

L'editor visualizzerà il testo (questo è un esempio della schermata di Vim):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#       new file:   README
	#       modified:   benchmarks.rb
	#
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Come vedi, il messaggio predefinito della commit contiene l'ultimo output del comando `git status`, commentato, e la prima riga in alto è vuota. Puoi rimuovere questi commenti e inserire il tuo messaggio di commit, o puoi lasciarli così per aiutarti a ricordare cosa stai committando. (Per una nota ancora più esplicita puoi usare l'opzione `-v` a `git commit`. Facendo saranno nel commento saranno inserite anche le modifiche stesse, così che tu possa vedere esattamente cosa hai fatto). Quando esci dall'editor, Git crea la tuo commit con un messaggio (rimuovendo commenti ed eventuali diff).

In alternativa, puoi inserire il messaggio per la tua commit alla riga di comando della `commit` specificando l'opzione -m, come segue:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

Hai creato la tua prima commit! Puoi vedere che la commit restituisce alcune informazioni su se stessa: su quale `branch` (ramo, ndt) hai fatto la commit (`master`), quale checksum SHA-1 ha la commit (`463dc4f`), quanti file sono stati modificati e le statistiche sulle righe aggiunte e rimosse con la commit.

Ricorda che la commit registra lo snapshot che hai salvato nella tua area di `stage`. Qualsiasi cosa che non è nello `stage` rimarrà lì come modificata; puoi fare un'altra commit per aggiungerli alla cronologia del progetto. Ogni volta che fai una commit, stai salvando un'istantanea (`snapshot`) del tuo progetto che puoi ripristinare o confrontare in seguito.

### Saltare l'Area di Stage ###

Anche se può essere estremamente utile per amministrare i commit esattamente come li vuoi, l'area di stage è molto più complessa di quanto tu possa averne bisogno nel lavoro normale. Se vuoi saltare l'area di parcheggio, Git fornisce una semplice scorciatoia. Passando l'opzione `-a` al comando `git commit` Git automaticamente parcheggia tutti i file che sono già stati tracciati facendo il commit, permettendoti di saltare la parte `git add`:

	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Nota come non hai bisogno, in questo caso, di lanciare `git add` sul file benchmarks.rb prima del commit.

### Rimuovere File ###

Per rimuovere un file con Git, hai bisogno di rimuoverlo dai file tracciati (più precisamente,  rimuoverlo dall'area di stage) e poi di fare il commit. Il comando `git rm` fa questo ed inoltre rimuove il file dalla tua directory di lavoro così non lo vedrai come un file non tracciato la prossima volta.

Se semplicemente rimuovi il file dalla directory di lavoro, sarà visto sotto l'area "Changes not staged for commit" (cioè, _non parcheggiato_) dell'output `git status`:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
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

La prossima volta che fai il commit, il file se ne andrà e non sarà più tracciato. Se modifichi il file e già aggiunto all'indice, devi forzarne la rimozione con l'opzione `-f`. Questa è una caratteristica di sicurezza per prevenire la rimozione accidentale dei dati che non sono ancora stati registrati in uno snapshot e che non possono essere recuperati da Git.

Un'altra cosa utile che potresti voler fare è mantenere il file nel tuo albero di lavoro ma rimuoverlo dall'area di stage. In altre parole, vuoi mantenere il file sul tuo disco ma non vuoi che Git ne mantenga ancora traccia. Questo è particolarmente utile se ti dimentichi di aggiungere qualcosa al tuo file `.gitignore` ed accidentalmente lo aggiungi, come un lungo file di log od un gruppo di file `.a` compilati. Per fare questo, usa l'opzione `--cached`:

	$ git rm --cached readme.txt

Puoi passare file, directory o glob pattern di file al comando `git rm`. Questo significa che puoi fare cose come

	$ git rm log/\*.log

Nota la barra inversa (`\`) di fronte a `*`. Questo è necessario perché Git ha una sua espansione dei nomi di file in aggiunta all'espansione dei filename della tua shell. Questo comando rimuove tutti i file che hanno l'estensione `.log` nella directory `log/`. O puoi fare qualcosa di simile a:

	$ git rm \*~

Questo comando rimuove tutti i file che finiscono con `~`.

### Muovere File ###

A differenza di altri sistemi VCS, Git non traccia esplicitamente i movimenti di file. Se rinomini un file in Git, nessun metadato è immagazzinato in Git che ti dirà che hai rinominato il file. Tuttavia, Git è abbastanza intelligente da capirlo dopo che è avvenuto — ci occuperemo di rilevare il movimento dei file più tardi.

Perciò crea un po' di confusione il fatto che Git  abbia un comando `mv`. Se vuoi rinominare un file in Git, puoi lanciare qualcosa come

	$ git mv file_from file_to

e questo funziona bene. Infatti, se lanci qualcosa come questo e guardi lo stato, vedrai che Git considera il file rinominato:

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

Git capisce implicitamente che è stato rinominato, così non è un problema rinominare un file in questo modo o con il comando `mv`. L'unica reale differenza è che `mv` è un solo comando invece di tre — è un comando di convenienza.  Più importante è che tu puoi usare qualsiasi strumento per rinominare un file, ed aggiungere/togliere più tardi, prima di un commit.

## Vedere la Storia dei Commit ##

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

Questa opzione visualizza le stessi informazioni ma direttamente seguita dal diff di ogni voce. Questo è veramente utile per la revisione del codice o per sfogliare velocemente cosa è successo in una serie di commit che un collaboratore ha aggiunto.

Qualche volta è più semplice controllare i cambiamenti per parole piuttosto che per linee. Esiste un'opzione `--word-diff` disponibile in Git, che puoi aggiungere al comando `git log -p` per ottenere un word diff (differenza per parole, ndt) invece del normale diff linea per linea. Il formato Word diff è piuttosto inutile quando applicato al codice sorgente, ma diviene utile quando applicato a grandi file di testo, come libri o la tua dissertazione. Ecco un esempio:

	$ git log -U1 --word-diff
	commit da734f4151c0bf92798edd67fb571f86ab4179e6
	Author: Jed Hartman <jhartman@google.com>
	Date:   Tue Mar 19 18:00:35 2013 -0700

	    Added a missing "in" to a sentence.

	diff --git a/en/01-chapter2.markdown b/en/01-chapter2.markdown
	index 879e48c..a992ff3 100644
	--- a/en/01-chapter2.markdown
	+++ b/en/01-chapter2.markdown
	@@ -553,3 +553,3 @@ You may be wondering what the difference is

	This option adds a nice little ASCII graph showing your branch and merge history, which we can see {+in+} our copy of the Grit project repository:

Come puoi vedere, non ci sono linee aggiunte o rimosse in questo output come in un normale diff. Invece i cambiamenti sono mostrati sulla linea. Puoi vedere la parola racchiusa in `{+ +}` (parole rimosse sarebbe state mostrate come `[-removed-]`). Potresti anche volere ridurre le solite tre linee di contesto nell'output di diff a solo una linea, dato che il contesto è ora costituito da parole, non linee. Puoi farlo con `-U1` come abbiamo fatto nell'esempio qui sopra.

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

Sarai sorpreso dalla differenza tra _author_ (l'autore) e _committer_ (chi ha eseguito il commit). L'autore è la persona che ha scritto originariamente il lavoro, mentre chi ha eseguito il commit è la persona che per ultima ha applicato il lavoro. Così, se invii una patch ad un progetto ed uno dei membri del progetto applica la patch, entrambi sarete riconosciuti — tu come l'autore ed il membro del progetto come colui il quale ha eseguito il commit. Scopriremo meglio questa distinzione nel Capitolo 5.

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

Queste sono solo alcune opzioni semplici per la formattazione dell'output di `git log` — ce ne sono altre. La tabella 2-2 elenca le opzioni che abbiamo visto prima e altre opzioni comunemente usate che possono essere utili per cambiare l'output del comando log.

	Opzione	Descrizione
	-p	Mostra la patch introdotta per ogni commit.
	--word-diff	Mostra la patch nel formato word diff.
	--stat	Mostra le statistiche per i file modificati in ogni commit.
	--shortstat	Mostra solo le linee cambiate/inserite/cancellate dal comando --stat.
	--name-only	Mostra la lista dei file modificati dopo le informazione del commit.
	--name-status	Mostra la lista dei file con le informazioni di aggiunte/modifiche/rimozioni.
	--abbrev-commit	Mostra solo i primi caratteri del codice checksum SHA-1 invece di tutti e 40.
	--relative-date	Mostra la data in un formato relativo (per esempio, "2 week ago", "2 settimane fa") invece di usare l'intero formato della data.
	--graph	Mostra un grafico ASCII dei rami e delle unioni della storia accando all'output di log.
	--pretty	Mostra i commit in un formato alternativo. L'opzione include oneline, short, full, fuller, e format (dove hai specificato la tua formattazione).
	--oneline	Un'opzione di convenienza abbreviazione per `--pretty=oneline --abbrev-commit`.

### Limitare l'Output di Log ###

Oltre alle opzioni per la formattazione dell'output, git log accetta un numero di opzioni di limitazione — cioè, opzioni che ti permettono di vedere solo alcuni commit. Hai già visto una opzione del genere — l'opzione `-2`, che mostra solamente gli ultimi due commit. Infatti, puoi fare `-<n>`, dove `n` è un intero per vedere gli ultimi `n` commit. In realtà, non userai spesso questa possibilità, perché Git di base veicola tutti gli output attraverso un impaginatore così vedrai solamente una pagina di log alla volta.

Ovviamente, le opzioni di limitazione temporali come `--since` e `--until` sono molto utili. Per esempio, questo comando prende la lista dei commit fatti nelle ultime due settimane:

	$ git log --since=2.weeks

Questo comando funziona con molti formati —  puoi specificare una data (“2008-01-15”) o una data relativa come “2 years 1 day 3 minutes ago”.

Puoi inoltre filtrare l'elenco dei commit che corrispondono a dei criteri di ricerca. L'opzione `--author` ti permette di filtrare uno specifico autore e l'opzione `--grep` permette di cercare delle parole chiave nei messaggi dei commit. (Nota che se vuoi specificare sia le opzioni author e grep, devi aggiungere `--all-match` o il comando ricercherà i commit sia di uno sia di quell'altro.)

L'ultima opzione di filtro veramente utile da passare a `git log` è un percorso.  Se specifichi una directory o un nome di file, puoi limitare l'output del log ai commit che introducono modifiche a questi file. E' sempre l'ultima opzione fornita ed è generalmente preceduta dal doppio meno (`--`) per separare i path dalle opzioni.

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

### Usare una GUI per Visualizzare la Storia ###

Se vuoi usare uno strumento più grafico per visualizzare la storia dei tuoi commit, puoi vedere un programma in Tck/Tk chiamato gitk che è distribuito con Git. Gitk è fondamentalmente uno strumento visuale come `git log`, e accetta circa tutte le opzioni di filtro che `git log` ha. Se digiti gitk dalla riga di comando del tuo progetto, dovresti vedere qualcosa di simile alla Figura 2-2.

Insert 18333fig0202.png
Figura 2-2. Il visualizzatore della storia gitk.

Puoi vedere la storia dei commit nella metà alta della finestra con un grafico genealogico. La finestra di diff nella metà inferiore mostra i cambiamenti introdotti ad ogni commit che selezioni.

## Annullare le Cose ##

Ad ogni stadio potresti voler annullare qualcosa. Qui, vedremo alcuni strumenti fondamentali per annullare i cambiamenti che hai fatto. Attenzione, perché non sempre puoi invertire alcuni annullamenti. Questa è una delle aree in Git dove puoi perdere qualche lavoro se sbagli.

### Modificare il Tuo Ultimo Commit ###

Uno degli annullamenti comuni avviene quando invii troppo presto un commit e magari dimentichi di aggiungere alcuni file, o sbagli il messaggio di commit. Se vuoi provare nuovamente questo commit, puoi lanciare commit con l'opzione `--amend`:

	$ git commit --amend

Questo comando prende la tua area di stage e la usa per il commit. Se non hai fatto cambiamenti dal tuo ultimo commit (per esempio, lanci questo comando subito dopo il tuo commit precedente), allora il tuo snapshot sarà esattamente uguale e potrai cambiare il tuo messaggio di commit.

L'editor per il messaggio del commit apparirà, ma già contiene il messaggio del commit precedente. Puoi modificare il messaggio come sempre, ma sovrascriverà il commit precedente.

Come esempio, se fai il commit e poi realizzi di aver dimenticato un cambiamento nella tua area di stage di un file e vuoi aggiungerlo a questo commit, puoi farlo così:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Tutti e tre i comandi finisco in un singolo commit —  il secondo commit riscrive il risultato del primo.

### Disimpegnare un File Staged ###

Le prossime due sezioni mostrano come gestire le modifiche della tua area di stage e della directory di lavoro. La parte divertente è che il comando che usi per determinare lo stato di queste due aree ricorda come annullare i cambiamenti fatti. Per esempio, supponiamo che hai modificato due file e vuoi inviarli come modifiche separate, ma accidentalmente digiti `git add *` e li parcheggi entrambi. Come puoi disimpegnare uno dei due? Il comando `git status` ti ricorda:

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
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Il comando è un po' strano, ma funziona. Il file benchmarks.rb è modificato ma non parcheggiato.

### Annullare le Modifiche di un File Modificato ###

Come fare se hai realizzato che non vuoi più tenere le modifiche che hai fatto al file `benchmarks.rb`? Come puoi annullarle facilmente — ritornare a come era al tuo ultimo commit (o alla clonazione iniziale, o come lo avevi nella tua directory di lavoro)? Fortunatamente, `git status` ci dice come farlo. Nell'ultimo output di esempio, l'area di unstage (file non parcheggiati) assomiglia a:

	# Changes not staged for commit:
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

Puoi vedere come le modifiche sono state annullate. Dovresti inoltre realizzare che è un comando pericoloso: ogni cambiamento fatto al file è sparito — semplicemente hai copiato un altro file su di esso. Non usare mai questo comando a meno che non sai assolutamente che non vuoi il file. Se hai bisogno solamente di toglierlo di torno, vedremo ripostigli e ramificazioni nei capitoli successivi ; queste sono generalmente le vie migliori da seguire.

Ricorda, qualsiasi cosa che è stata affidata a Git può quasi sempre essere recuperata. Tutti i commit che erano su rami che sono stati cancellati o sovrascritti tramite un commit `--amend` possono essere recuperati (vedi il *Capitolo 9* per il recupero dei dati). Tuttavia, qualsiasi cosa che perdi e che non è stata affidata a Git probabilmente non sarà mai più visto.

## Lavorare con Sorgenti Remote ##

Per essere in grado di collaborare con un qualsiasi progetto Git, hai bisogno di sapere come amministrare il tuo repository remoto. I repository remoti sono versioni di progetti che sono ospitati in Internet o su una rete da qualche parte. Puoi averne più di uno, molti dei quali possono essere di sola lettura o di scrittura e lettura per te. Collaborare con altri implica di sapere amministrare questi repository remoti e mettere e togliere i dati a e da questi quando hai necessità di condividerli per lavoro.
Amministrare repository remoti include il sapere aggiungere repository remoti, rimuovere quelli che non sono validi, amministrare vari rami remoti e definire quando sono tracciati o meno, e altro. In questa sezione, vedremo le tecniche di amministrazione remota.

### Visualizzare la Sorgente Remota ###

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
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

Se hai più di un repository remoto, il comando li elenca tutti. Per esempio, il mio repository Grit assomiglia a questo.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Questo significa che possiamo prendere i contributi da qualsiasi di questi utenti in modo facile. Ma nota che solo origin è un URL SSH, è l'unico dove posso fare il push (vedremo questa cosa nel Capitolo 4).

### Aggiungere un Repository Remoto ###

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

### Prelevare e Trarre da Sorgenti in Remoto ###

Come già visto, per ottenere i dati da un progetto remoto, puoi farlo:

	$ git fetch [nome-remoto]

Il comando va sul progetto remoto e si tira giù tutti i dati dal progetto remoto che ancora non hai. Dopo aver fatto questo, dovresti avere tutti i riferimenti ai rami da questa sorgente remota, che poi potrai fondere o ispezionare in ogni momento. (Vedremo cosa sono i rami e come usarli in maggior dettaglio al *Capitolo 3*).

Se hai clonato un repository, il comando automaticamente aggiunge un repository remoto sotto il nome origin. Così, `git fetch origin` preleva ogni lavoro che è stato inserito su quel server da quando hai fatto la clonazione (o dall'ultimo prelievo). E' importante notare che il comando `fetch` mette i dati nel tuo repository locale — non unisce automaticamente e non modifica alcun file su cui tu stai lavorando. Devi eseguire la fusione manualmente nel tuo lavoro, quando sei pronto.

Se hai un ramo impostato per tracciare un ramo remoto (vedi la prossima sezione e il Capitolo 3 per maggiori informazioni), puoi usare il comando `git pull` per prelevare automaticamente e poi fondere un ramo remoto nel ramo corrente. Questo è un modo più facile e comodo di lavorare; e in modo predefinito, il comando `git clone` automaticamente imposta il tuo ramo locale master per tracciare il ramo remoto master del server che hai clonato (assumendo che il sorgente remoto abbia un ramo master). Lanciare `git pull` generalmente preleva i dati dal server di origine clonato e automaticamente prova a fondere il codice con il codice su cui stai lavorando.

### Inserire nella Sorgente Remota ###

Quando hai il tuo progetto al punto in cui lo vuoi condividere, devi inviarlo a monte (push upstream). Il comando per fare questo è semplice: `git push [nome-remoto] [nome-ramo]`. Se vuoi fare il push del tuo ramo master al tuo server `origin` (ancora, generalmente con la clonazione sono impostati entrambi questi nomi automaticamente), puoi lanciare il push per mettere il tuo lavoro sul server:

	$ git push origin master

Questo comando funziona solamente se hai fatto una clonazione da un server in cui hai i permessi di scrittura e se nessuno ha inviato dati nel mentre. Se tu e qualcun altro clonate un repository nello stesso momento ed essi inviano i dati, e poi tu invii i dati, il tuo invio verrà gustamente rifiutato. Devi prima scaricare il loro lavoro ed incorporarlo nel tuo per poter inviare le tue modifiche. Vedi il *Capitolo 3* per maggiori dettagli ed informazioni su come fare il push su server remoti.

### Ispezionare una Sorgente Remota ###

Se vuoi vedere più informazioni su di una sorgente remota in particolare, puoi usare il comando `git remote show [nome-remoto]`. Se lanci il comando con un soprannome particolare, come `origin`, avrai qualcosa di simile a questo:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Questo elenca tutti gli URL del repository remoto oltre che alle informazioni sui rami tracciati. Il comando utilmente ti dirà che sei sul ramo principale e se lanci `git pull`, questo automaticamente unirà il ramo master sul server remoto dopo aver prelevato tutte i riferimenti remoti. Inoltre elencherà i riferimenti che ha scaricato.

Questo è un semplice esempio che potrai incontrare. Quando usi moltissimo Git, tuttavia, potrai vedere molte più informazioni da `git remote show`:

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

### Rimuovere e Rinominare Sorgenti Remote ###

Se vuoi rinominare un riferimento, nelle nuove versioni di Git, puoi lanciare `git remote rename` per cambiare il soprannome di una sorgente remota. Per esempio, se vuoi rinominare `pb` in `paul`, puoi farlo con `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Vale la pena ricordare che questo cambia anche i nomi dei rami remoti. Quello che prima era riferito a `pb/master` ora è `paul/master`.

Se vuoi rimuovere un riferimento per una qualche ragione — hai spostato il server o non stai più usando un mirror particolare, o magari un collaboratore non collabora più — puoi usare `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

### Etichettare ###

Come la maggior parte dei VCS, Git ha la possibilità di contrassegnare (tag, ndt) dei punti specifici della storia come importanti. Generalmente, le persone usano questa funzionalità per marcare i punti di rilascio (v1.0, e così via). In questa sezione, imparerai come elencare le etichette disponibili, come crearne di nuove, ed i differenti tipi di etichette esistenti.

### Elencare le Proprie Etichette ###

Elencare le etichette disponibili in Git è facilissimo. Semplicemente digita `git tag`:

	$ git tag
	v0.1
	v1.3

Questo comando elenca le etichette in ordine alfabetico; l'ordine con il quale compaiono non è realmente importante.

Puoi inoltre cercare le etichette con uno schema specifico. Il repository sorgente di Git, per esempio, contiene più di 240 etichette. Se sei solo interessato a vedere quelli della serie 1.4.2, puoi lanciare:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creare Etichette ###

Git usa due principali tipi di etichette: lightweight (semplificate, ndt) e annotated (commentate, ndt). Un'etichetta lightweight è molto simile ad un ramo che non è cambiato —  è semplicemente un riferimento ad uno specifico commit. Le etichette annotated, tuttavia, sono salvate come oggetti nel database Git. Ne viene calcolato il checksum; contengono il nome, l'e-mail e la data di chi ha inserito l'etichetta; hanno un messaggio; e possono essere firmati e verificati con GNU Privacy Guard (GPG). É generalmente raccomandato creare etichette annotated così puoi avere tutte queste informazioni; ma se vuoi temporaneamente inserire un'etichetta e per qualche ragione non vuoi avere queste informazioni, le etichette lightweight sono ancora disponibili.

### Etichette Annotated ###

Creare un'etichetta annotated in Git è semplice. La via più facile è specificare `-a` quando si lancia il comando `tag`:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

`-m` specifica il messaggio, che è salvato con l'etichetta. Se non specifichi un messaggio per una etichetta annotated, Git lancerà il tuo editor così potrai inserirlo.

Puoi vedere i dati dell'etichetta assieme al commit in cui è stato inserito l'etichetta con il comando `git show`:

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

Questo mostra le informazioni di chi ha eseguito l'etichetta, la data del commit della stessa, ed il messaggio prima di mostrare le informazioni del commit.

### Firmare le Etichette ###

Puoi anche firmare le tue etichette con GPG, assumendo che tu abbia una chiave privata. Tutto quello che devi fare è usare `-s` invece di `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Se lanci `git show` su questa etichetta, potrai vedere la tua firma GPG in allegato ad essa:

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

Più avanti, imparerai come verificare le etichette firmate.

### Etichette Lightweight ###

Un altro modo per marcare i commit è usare le etichette lightweight. Questo è semplicemente fare il checksum del commit salvato in un file — nessun'altra informazione è mantenuta. Per creare un'etichetta semplificata, non fornire l'opzione `-a`, `s` o `-m`:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

A questo punto, se lanci `git show` sulla tua etichetta, non vedrai altre informazioni aggiuntive. Il comando semplicemente mostra il commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verificare le Etichette ###

Per verificarele etichetta firmate, usa `git tag -v [nome-tag]`. Questo comando usa la verifica GPG della firma. Avrai bisogno della chiave pubblica del firmatario nel tuo portachiavi affinché funzioni correttamente:

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

### Inserire una Etichetta Successivamente ###

Puoi anche etichettare i commit che hai già superato. Supponiamo che la storia dei tuoi commit sia come questa: 

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

Ora, supponiamo che ti sia dimenticato di mettere l'etichetta v1.2 al tuo progetto, che è al commit "updated rakefile". Puoi aggiungerlo successivamente. Per marcare questo commit, devi specificare il checksum (o parte di esso) del commit alla fine del comando:

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

### Condividere le Etichette ###

Di base, il comando `git push` non trasferisce le etichette sui server remoti. Devi esplicitamente inviare le etichette da condividere con il server dopo averle create. Questo processo è come condividere rami remoti — puoi lanciare `git push origin [nometag]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Se hai molte etichetta che vuoi inviare tutte assieme, puoi farlo usando l'opzione `--tags` del comando `git push`. Questo trasferirà tutti le tue etichette sul server remoto che non sono ancora presenti.

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

Ora, quando qualcun altro clona o scarica dal tuo repository, avrà anche tutti le tue etichette.

## Suggerimenti e Trucchi ##

Prima di finire questo capitolo sulle basi di Git, ecco alcuni suggerimenti e trucchi per rendere l'esperienza nell'uso di Git più semplice, facile e familiare. Molte persone usano Git senza usare questi suggerimenti e non ci riferiremo ad essi o presumeremo che tu li abbia usati successivamente nel libro; ma probabilmente dovresti sapere come realizzarli.

### Auto-Completamento ###

Se usi una shell Bash, Git fornisce un piacevole script di auto completamento che può essere usato. Scarica il codice sorgente di Git, e guarda nella directory `contrib/completation`; dovrebbe esserci un file chiamato `git-completation.bash`. Copia questo file nella tua directory di home e aggiungila al tuo file `.bashrc`:

	source ~/.git-completion.bash

Se vuoi impostare Git per avere l'auto completamento della shell Bash per tutti gli utenti, copia lo script nella directory `/opt/local/etc/bash_completion.d` sui sistemi Mac o in `/etc/bash_completion.d/` sui sistemi Linux. Questa è una directory degli script che Bash automaticamente carica per fornire l'auto completamento da shell.

Se stai usando Windows con Git Bash, che è l'installazione di base per Git su Windows con msysGit, l'auto completamento dovrebbe essere preconfigurato.

Premi il tasto Tab quando stai scrivendo un comando Git, e dovresti avere una serie di suggerimenti da selezionare:

	$ git co<tab><tab>
	commit config

In questo caso, scrivendo git co e poi premendo il tasto Tab due volte compaiono i suggerimenti commit e config. Aggiungendo `m<tab>` si completa `git commit` automaticamente.

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

Questa tecnica può anche essere molto utile per creare comandi che ritieni dovrebbero esistere. Per esempio, per correggere un problema comune in cui si incorre quando si vuole disimpegnare un file dall'area di stage, puoi aggiungere il tuo alias unstage a Git:

	$ git config --global alias.unstage 'reset HEAD --'

Questo rende i seguenti due comandi equivalenti:

	$ git unstage fileA
	$ git reset HEAD fileA

Questo sembra più pulito. É anche comodo aggiungere il comando `last`, come:

	$ git config --global alias.last 'log -1 HEAD'

In questo modo puoi vedere l'ultimo commit facilmente:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Git semplicemente sostituisce il nuovo comando con quello che corrisponde all'alias. Magari, vuoi avviare un comando esterno, invece dei sotto comandi Git. In questo caso, devi avviare il comando con il carattere "!". Questo è utile se stai scrivendo i tuoi strumenti di lavoro con un repository Git. Per esempio creiamo un alias `git visual` per lanciare `gitk`:

	$ git config --global alias.visual '!gitk'

## Riassunto ##

A questo punto, sei in grado di fare tutte le operazioni di Git base in locale — creare o clonare un repository, fare delle modifiche, parcheggiare ed inviare queste modifiche, vedere la storia di tutti i cambiamenti del repository fatti. Nel prossimo capitolo, vedremo una caratteristica vincente di Git: il suo modello di ramificazione.
