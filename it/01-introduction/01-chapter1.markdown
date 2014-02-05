# Per Iniziare #

Questo capitolo spiegherà come iniziare ad usare Git. Inizieremo con una introduzione sugli strumenti per il controllo delle versioni,  per poi passare a come far funzionare Git sul proprio sistema e quindi come configurarlo per lavorarci. Alla fine di questo capitolo, dovresti capire a cosa serve Git, perché dovresti usarlo e dovresti essere pronto ad usarlo.

## Il Controllo di Versione ##

Cos'è il controllo di versione, e perché dovresti usarlo? Il controllo di versione è un sistema che registra, nel tempo, i cambiamenti ad un file o ad una serie di file, così da poter richiamare una specifica versione in un secondo momento. Sebbene gli esempi di questo libro usino i sorgenti di un software per controllarne la versione, qualsiasi file di un computer può essere posto sotto controllo di versione.

Se sei un grafico o un webdesigner e vuoi tenere tutte le versioni di un'immagine o di un layout (e sicuramente lo vorrai fare), sarebbe saggio usare un Sistema per il Controllo di Versione (_Version Control System_ - VCS). Un VCS ti permette di ripristinare i file ad una versione precedente, ripristinare l'intero progetto a uno stato precedente, revisionare le modifiche fatte nel tempo, vedere chi ha cambiato qualcosa che può aver causato un problema, chi ha introdotto un problema e quando, e molto altro ancora. Usare un VCS significa anche che se fai un pasticcio o perdi qualche file, puoi facilmente recuperare la situazione. E ottieni tutto questo con poca fatica.

### Sistema di Controllo di Versione Locale ###

Molte persone gestiscono le diverse versioni copiando i file in un'altra directory (magari una directory denominata con la data, se sono furbi). Questo approccio è molto comune perché è molto semplice, ma è anche incredibilmente soggetto ad errori. É facile dimenticare in quale directory sei e modificare il file sbagliato o copiare dei file che non intendevi copiare.

Per far fronte a questo problema, i programmatori svilupparono VCS locali che avevano un database semplice che manteneva tutti i cambiamenti dei file sotto controllo di revisione (vedi Figura 1-1).

Insert 18333fig0101.png 
Figura 1-1. Diagramma di controllo di un sistema locale.

Uno dei più popolari strumenti VCS era un sistema chiamato rcs, che è ancora oggi distribuito con molti computer. Anche il popolare sistema operativo Mac OS X include il comando rcs quando si installano gli Strumenti di Sviluppo. Questo strumento funziona salvando sul disco una serie di patch (ovvero le differenze tra i file) tra una versione e l'altra, in un formato specifico; può quindi ricreare lo stato di qualsiasi file in qualsiasi momento determinato momento, aggiungendo le varie patch.

### Sistemi di Controllo di Versione Centralizzati ###

Successivamente queste persone dovettero affrontare il problema del collaborare con altri sviluppatori su altri sistemi. Per far fronte a questo problema, vennero sviluppati sistemi di controllo di versione centralizzati (_Centralized Version Control Systems_ - CVCS). Questi sistemi, come CVS, Subversion e Perforce, hanno un unico server che contiene tutte le versioni dei file e un numero di utenti che scaricano i file dal server centrale. Questo è stato lo standard del controllo di versione per molti anni (vedi Figura 1-2).

Insert 18333fig0102.png 
Figura 1-2. Diagramma controllo di versione centralizzato.

Questa impostazione offre molti vantaggi, specialmente rispetto ai VCS locali.  Per esempio, chiunque sa, con una certa approssimazione, cosa stia facendo un'altra persona del progetto. Gli amministratori hanno un controllo preciso su chi può fare cosa, ed è molto più facile amministrare un CVCS che un database locale su ogni client.

Questa configurazione ha tuttavia alcune gravi controindicazioni. La più ovvia è che il server centralizzato rappresenta il singolo punto di rottura del sistema. Se questo va giù per un'ora, in quel periodo nessuno può collaborare o salvare una nuova versione di qualsiasi cosa su cui sta lavorando. Se il disco rigido del database centrale si danneggia, e non ci sono i backup, perdi assolutamente tutto: tutta la storia del progetto ad eccezione dei singoli snapshot (istantanee) che le persone possono avere in locale sulle loro macchine. Anche i sistemi locali di VCS soffrono di questo problema: ogni volta che tutta la storia del progetto è in un unico posto, si rischia di perdere tutto.

### Sistemi di Controllo di Versione Distribuiti ###

E qui entrano in gioco i Sistemi di Controllo di Versione Distribuiti (_Distributed Version Control Systems_ - DVCS). In un DVCS (come Git, Mercurial, Bazaar o Darcs), i client non solo controllano lo _snapshot_ più recente dei file, ma fanno una copia completa del repository. In questo modo se un server morisse e i sistemi interagiscono tramite il DVCS, il repository di un qualsiasi client può essere copiato sul server per ripristinarlo. Ogni checkout è un backup completo di tutti i dati (vedi Figura 1-3).

Insert 18333fig0103.png 
Figura 1-3. Diagramma del controllo di versione distribuito.

Inoltre, molti di questi sistemi trattano bene l'avere più repository remoti su cui poter lavorare, così puoi collaborare con gruppi differenti di persone in modi differenti, simultaneamente sullo stesso progetto. Questo ti permette di impostare diversi tipi di flussi di lavoro che non sono possibili in sistemi centralizzati, come i modelli gerarchici.

## Una Breve Storia di Git ##

Come per molte grandi cose della vita, Git è nato con un po' di distruzione creativa e polemiche infuocate. Il kernel di Linux è un progetto software open source di grande portata abbastanza. Per buona parte del tempo (1991-2002) della manutenzione del kernel Linux le modifiche al software venivano passate sotto forma di patch e file compressi. Nel 2002, il progetto del kernel Linux iniziò ad utilizzare un sistema DVCS proprietario chiamato BitKeeper.

Nel 2005 il rapporto tra la comunità che sviluppa il kernel Linux e la società commerciale che aveva sviluppato BitKeeper si ruppe, e fu revocato l'uso gratuito di BitKeeper. Ciò indusse la comunità di sviluppo di Linux (e in particolare Linus Torvalds, il creatore di Linux) a sviluppare uno strumento proprio, basandosi su alcune delle lezioni apprese durante l'utilizzo di BitKeeper. Alcuni degli obiettivi del nuovo sistema erano i seguenti:

*	Velocità
*	Design semplice
*	Ottimo supporto allo sviluppo non-lineare (migliaia di rami paralleli)
*	Completamente distribuito
*	Capacità di gestire, in modo efficiente (velocità e dimensione dei dati), grandi progetti come il kernel Linux

Fin dalla sua nascita nel 2005 Git si è evoluto e maturato per essere facile da usare e tuttora mantiene le sue qualità iniziali. È incredibilmente veloce, è molto efficiente con progetti grandi e ha un incredibile sistema di ramificazioni, per lo sviluppo non lineare (Vedi Capitolo 3).

## Basi di Git ##

Quindi, cos'è Git in poche parole? Questa è una sezione importante da comprendere, perché se capisci che cos'è Git e gli elementi fondamentali di come funziona, allora sarà probabilmente molto più facile per te usare efficacemente Git. Mentre impari Git, cerca di liberare la tua mente dalle cose che eventualmente già conosci di altri VCS come Subversion e Perforce; ciò ti aiuterà a evitare di far confusione utilizzando lo strumento. Git immagazzina e tratta le informazioni in modo molto diverso dagli altri sistemi, anche se l'interfaccia utente è abbastanza simile; comprendere queste differenze aiuta a prevenire di sentirsi confusi mentre lo si usa.

### Istantanee, non Differenze ###

La principale differenza tra Git e gli altri VCS (inclusi Subversion e compagni), è come Git considera i suoi dati. Concettualmente la maggior parte degli altri sistemi salvano l'informazione come una lista di modifiche ai file. Questi sistemi (CVS, Subversion, Perforce, Bazaar e così via), considerano le informazioni che mantengono come un insieme di file, con le relative modifiche fatte ai file nel tempo, come illustrato in Figura 1-4.

Insert 18333fig0104.png 
Figura 1-4. Gli altri sistemi tendono ad immagazzinare i dati come cambiamenti alla versione base di ogni file.

Git non considera i dati né li registra in questo modo. Git considera i propri dati più come una serie di istantanee (_snapshot_) di un mini filesystem.  Ogni volta che committi, o salvi lo stato del tuo progetto in Git, fondamentalmente lui fa un'immagine di tutti i file in quel momento, salvando un riferimento allo _snapshot_. Per essere efficiente, se alcuni file non sono cambiati, Git non li risalva, ma crea semplicemente un collegamento al file precedente già salvato. Git considera i propri dati più come in Figura 1-5.

Insert 18333fig0105.png 
Figura 1-5.  Git immagazzina i dati come snapshot del progetto nel tempo.

Questa è una distinzione importante tra Git e pressocché tutti gli altri VCS. Git riconsidera quasi tutti gli aspetti del controllo di versione che la maggior parte degli altri sistemi ha copiato dalle generazioni precedenti. Questo rende Git più simile a un mini filesystem con a dispoizione strumenti incredibilmente potenti che un semplice VCS. Esploreremo alcuni benefici che ottieni pensando in questo modo ai tuoi dati vedremo le ramificazioni (i _branch_) in Git nel Capitolo 3.

### Quasi Tutte le Operazioni Sono Locali ###

La maggior parte delle operazioni in Git, necessitano solo di file e risorse locali per operare — generalmente non occorrono informazioni da altri computer della rete. Se sei abituato ad un CVCS in cui la maggior parte delle operazioni sono soggette alle latenze di rete, questo aspetto di Git ti farà pensare che gli Dei della velocità abbiano benedetto Git con poteri soprannaturali. Poiché hai l'intera storia del progetto sul tuo disco locale, molte operazioni sembrano quasi istantanee.

Per esempio, per scorrere la storia di un progetto, Git non ha bisogno di connettersi al server per scaricarla e per poi visualizzarla — la legge direttamente dal database locale. Questo significa che puoi vedere la storia del progetto quasi istantaneamente. Se vuoi vedere i cambiamenti introdotti tra la versione corrente di un file e la versione di un mese fa, Git può consultare il file di un mese fa e calcolare localmente le differenze, invece di richiedere di farlo ad un server remoto o di estrarre una precedente versione del file dal server remoto, per poi farlo in locale.

Questo significa anche che sono minime le cose che non si possono fare se si è offline o non connesso alla VPN. Se sei in aereo o sul treno e vuoi fare un po' di lavoro, puoi eseguire tranquillamente il commit, anche se non sei connesso alla rete per fare l'upload. Se tornando a casa, trovi che il tuo client VPN non funziona correttamente, puoi comunque lavorare. In molti altri sistemi, fare questo è quasi impossibile o penoso. Con Perforce, per esempio, puoi fare ben poco se non sei connesso al server; e con Subversion e CVS, puoi modificare i file, ma non puoi inviare i cambiamenti al tuo database (perché il database è offline). Tutto ciò non ti può sembrare una gran cosa, tuttavia potresti rimanere di stucco dalla differenza che Git può fare.

### Git Ha Integrità ###

Qualsiasi cosa in Git è controllata, tramite checksum, prima di essere salvata ed è referenziata da un checksum. Questo significa che è impossibile cambiare il contenuto di qualsiasi file o directory senza che Git lo sappia. Questa è una funzionalità interna di Git al più basso livello ed è intrinseco nella sua filosofia. Non puoi perdere informazioni nel transito o avere corruzioni di file senza che Git non sia in grado di accorgersene.

Il meccanismo che Git usa per fare questo checksum, è un hash, denominato SHA-1. Si tratta di una stringa di 40-caratteri, composta da caratteri esadecimali (0–9 ed a–f) e calcolata in base al contenuto di file o della struttura della directory in Git. Un hash SHA-1 assomiglia a qualcosa come:

	24b9da6552252987aa493b52f8696cd6d3b00373

in Git, questi valori di hash si vedono dappertutto, perché Git li usa tantissimo. Infatti, Git immagazzina ogni cosa, nel proprio database indirizzabile, non per nome di file, ma per il valore di hash del suo contenuto.

### Git Generalmente Aggiunge Solo Dati ###

Quando si fanno delle azioni in Git, quasi tutte aggiungono solo dati al database di Git. E' piuttosto difficile che si porti il sistema a fare qualcosa che non sia annullabile o a cancellare i dati in una qualche maniera. Come in altri VCS, si possono perdere o confondere le modifiche, di cui non si è ancora fatto il commit; ma dopo aver fatto il commit di uno snapshot in Git, è veramente difficile perderle, specialmente se si esegue regolarmente, il push del proprio database su di un altro repository.

Questo rende l'uso di Git un piacere perché sappiamo che possiamo sperimentare senza il pericolo di perdere seriamente le cose. Per un maggior approfondimento su come Git salva i dati e come puoi recuperare i dati che sembrano persi, vedi "Sotto il Cofano" nel Capitolo 9.

### I Tre Stati ###

Ora, presta attenzione. Questa è la prima cosa da ricordare su Git se si vuole affrontare al meglio il processo di apprendimento. Git ha tre stati principali, in cui possono risiedere i file: committed, modified e staged. Committed significa che il file è immagazzinato al sicuro, nel database locale. Modified significa che il file è stato modificato, ma non è stato ancora eseguito il commit nel proprio database. Staged significa che un file modificato nella versione corrente, è stato contrassegnato per essere inserito nello snapshot, al commit successivo.

Questo ci conduce alle tre sezioni principali di un progetto Git: la directory di Git, la directory di lavoro e l'area di stage.

Insert 18333fig0106.png 
Figura 1-6. Directory di lavoro, area di stage e directory di Git.

La directory di Git è il luogo dove Git salva i metadati ed il database degli oggetti di un progetto. Questa è la parte più importante di Git, ed è ciò che viene copiato quando si clona un repository da un altro computer.

La directory di lavoro è un singolo checkout di una versione del progetto. Questi file sono estratti dal database compresso, nella directory di Git, e posizionati nel disco per essere usati o modificati.

L'area di stage è un semplice file, generalmente contenuto nella directory di Git, contenente le informazioni riguardanti il commit successivo. Qualche volta viene indicato come l'indice, ma sta diventando d'uso comune riferirsi ad essa, come all'area di stage (sosta, ndt).

Il flusso base di lavoro in Git, funziona come segue:

1. Modifica i file nella directory di lavoro
2. Esegui l'operazione di stage dei file, per aggiungere i relativi snapshot all'area di stage
3. Esegui il commit, per immagazzinare permanentemente nella directory di Git, lo snapshot relativo, una volta presi i file nell'area di stage

Se una versione particolare di un file è nella directory git, sarà considerata già affidata. Se il file è stato modificato, ma è stato aggiunto all'area di staging, è in sosta. E se è stato modificato da quando è stata controllato, ma non è stato messo in sosta, sarà modificato.  Nel Capitolo 2, imparerai di più su questi stati e come trarne vantaggio da essi o saltare interamente la parte di staging.

## Installare Git ##

Incominciamo ad usare un po' di Git! Per prima cosa — occorre installarlo. Puoi ottenere Git in diversi modi; i due principali sono: installarlo dai sorgenti o installarlo da un pacchetto pre-esistente per la tua piattaforma.

### Installare da Sorgenti ###

Se puoi, è generalmente vantaggioso installare Git dai sorgenti, perché così puoi usare la versione più recente. Ogni versione di Git, tende ad includere utili miglioramenti all'interfaccia utente, quindi, avere l'ultima versione disponibile è spesso la scelta migliore, se hai familiarità con la compilazione dei sorgenti. Inoltre capita anche, che molte distribuzioni Linux contengano pacchetti molto vecchi; perciò, se non stai usando una distro aggiornata o dei backport, l'installazione da sorgente può essere la cosa migliore da fare.

Per installare Git, hai bisogno delle seguenti librerie, da cui dipende Git: curl, zlib, openssl, expat e libiconv. Per esempio, se sei su un sistema che usa yum (come in Fedora), o apt-get (come nei sistemi Debian), puoi usare uno dei seguenti comandi per installare tutte le dipendenze:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
Quando avrai tutte le dipendenze necessarie, puoi proseguire ed andare a recuperare l'ultimo snapshot dal sito web di Git:

	http://git-scm.com/download
	
Poi, compilalo ed installalo:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Dopo aver fatto questo, puoi ottenere Git da Git stesso per gli aggiornamenti:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installare su Linux ###

Se vuoi installare Git su Linux, tramite una installazione da binario, generalmente, puoi farlo con lo strumento base di amministrazione-dei-pacchetti della tua distribuzione. Se sei su Fedora, puoi usare yum:

	$ yum install git-core

O se sei su una distribuzione basata su Debian, come Ubuntu, prova apt-get:

	$ apt-get install git

### Installazione su Mac ###

Ci sono due metodi per installare Git su Mac. Il più semplice è usare l'installatore grafico di Git, che puoi scaricare dalla pagina di Google Code (vedi Figura 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figura 1-7. Installatore di Git per SO X.

L'altro metodo è installare Git via MacPorts (`http://www.macports.org`). Se hai MacPorts installato, installa Git con:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Non ti occorre aggiungere tutti i pacchetti, ma evidentemente vorrai includere +svn, nel caso tu debba usare Git con i repository di Subversion (vedi Capitolo 8).

### Installare su Windows ###

Installare Git su Windows è davvero facile. Il progetto msysGit ha una delle procedure di installazione tra le più facili. Semplicemente scarica l'installatore eseguibile dalla pagina di GitHub, e lancialo:

	http://msysgit.github.com/

Una volta installato, hai a disposizione sia la versione da riga di comando (incluso un client SSH che sarà utile, in seguito) sia l'interfaccia grafica (GUI) standard.

Nota sull'uso su Windows: dovresti usare Git con la shell msysGit fornita (stile Unix), permette di usare complesse linee di comando date in questo libro. Se hai bisogno, per qualche ragione, di usare la shell nativa di Windows / la console a linea di comando, devi usare le doppie virgolette invece delle virgolette semplici (per i parametri con che contengono spazi) e devi virgolettare i parametri che terminano con l'accento circonflesso (^) se questi sono al termine della linea, poiché esso è un simbolo di proseguimento in Windows.

## Prima Configurazione di Git ##

Ora che hai Git sul tuo sistema, vorrai fare un paio di cose per personalizzare l'ambiente di Git. Ti occorre farle solo una volta; esse rimangono invariate anche dopo un aggiornamento. Comunque, puoi cambiarle, in ogni momento, eseguendo di nuovo questi comandi.

Git è rilasciato con uno strumento che si chiama git config che ti permetterà di ottenere ed impostare le variabili di configurazione che controllano ogni aspetto delle operazioni e del look di Git. Queste variabili possono essere salvate in tre posti differenti:

*	file `/etc/gitconfig`: Contiene i valori per ogni utente sul sistema e per tutti i loro repository. Se si passa l'opzione` --system` a `git config`, lui legge e scrive da questo specifico file. 
*	file `~/.gitconfig`: Specifico per il tuo utente. Puoi far leggere e scrivere a Git questo file passando l'opzione `--global`. 
*	file di configurazione nella directory git (che è `.git/config`) di ogni repository che si sta usando. Specifico per ogni singolo repository. Ogni livello sovrascrive i valori del livello precedente, così i valori in `.git/config` vincono su quelli in `/etc/gitconfig`.

Sui sistemi Windows, Git cerca il file `.gitconfig` nella directory `$HOME` (`C:\Documents and Settings\$USER` per la maggior parte delle persone). Inoltre per quanto riguarda /etc/gitconfig, sarà relativo alla radice di MSys, che dipende da dove si vorrà installare Git sul sistema Windows quando si lancia l'installazione.

### La Propria Identità ###

La prima cosa che occorrerebbe fare, quando si installa Git, è impostare il proprio nome utente e indirizzo e-mail. Ciò è importante, perché ogni commit di Git usa queste informazioni, che vengono incapsulate nei commit che si fanno:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Di nuovo, passando l'opzione `--global`, occorre fare ciò solo una volta, dopo di che Git userà sempre queste informazioni, per qualsiasi operazione fatta sul sistema. Se si vuole sovrascriverle con un nome o una e-mail per progetti specifici, basta eseguire il comando senza l'opzione `--global`, quando si è in uno di quei progetti.

### Il Proprio Editor ###

Ora che è configurata la propria identità, si può configurare l'editor di testo predefinito, da usare quando Git avrà bisogno di inserire un messaggio. Per impostazione predefinita, Git usa l'editor di testo predefinito del sistema, che generalmente è Vi o Vim. Se vuoi usare un editor di testo differente, come Emacs, puoi fare come segue:

	$ git config --global core.editor emacs
	
### Il Proprio Diff ###

Un'altra utile opzione, che si potrebbe voler configurare, è lo strumento diff, predefinito, da usare per risolvere i conflitti di merge (fusione, ndt). Per usare vimdiff:

	$ git config --global merge.tool vimdiff

Git accetta kdeff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge e opendiff, come strumenti validi di merge. E' anche possibile impostare uno strumento personalizzato; vedere il Capitolo 7, per maggiori informazioni su come farlo.

### Controllare le Impostazioni ###

Per controllare le proprie impostazioni, si può usare il comando `git config --list`, che elenca tutte le impostazioni di Git, fatte fino a questo punto:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

La stessa chiave può comparire più volte, perché Git legge la stessa chiave da file differenti (`/etc/gitconfig` e `~/.gitconfig`, per esempio). In questo caso, Git usa l'ultimo valore per ogni chiave unica che vede.

Per controllare quale sia il valore di una chiave, ritenuto da Git usare, `git config {key}`:

	$ git config user.name
	Scott Chacon

## Ottenere Aiuto ##

Se dovessi avere bisogno di aiuto durante l'uso di Git, ci sono tre modi per vedere le pagine del manuale di aiuto per ogni comando di Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Per esempio, puoi avere la pagina del manuale di aiuto, per il comando config, lanciando

	$ git help config

Questi comandi sono utili, perché puoi accedere ad essi da ogni dove, anche se sei offline.
Se il manuale e questo libro non sono sufficienti e hai bisogno di un aiuto più diretto da una persona, puoi provare i canali `#git` o `#github`, sul server IRC di Freenode (irc.freenode.com). Questi canali sono regolarmente frequentati da centinaia di persone che conoscono molto bene Git e saranno davvero felici di aiutarti.

## Riassunto ##

Dovresti avere le basi per capire cos'è Git e come è differente dai CVCS che puoi aver usato. Dovresti anche avere una versione funzionante di Git sul tuo sistema che è configurata con la tua personale identità. É ora tempo di imparare qualcosa delle basi di Git.
