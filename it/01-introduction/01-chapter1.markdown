# Per iniziare #

Questo capitolo spiegherà come iniziare ad usare Git.  Inizieremo con una introduzione sugli strumenti di controllo della versione,  per poi passare a come far funzionare Git sul proprio sistema  ed infine come configurarlo per lavorarci.  Alla fine di questo capitolo, si dovrebbe capire a cosa serve Git, perché lo si dovrebbe usare ed essere pronti per usarlo.

## Il Controllo di Versione ##

Cos'è il controllo di versione, e perché si dovrebbe usare? Il controllo di versione è un sistema che registra i cambiamenti ad un file o ad una serie di file nel tempo, così da poter richiamare una versione specifica successivamente. Per gli esempi in questo libro, useremo i file del codice sorgente di un software per controllarne la versione, anche se in realtà si può fare con quasi ogni tipo di file sul computer.

Se sei un grafico o un webdesigner e vuoi tenere tutte le versioni di un'immagine o di un layout (e sicuramente lo vorrai fare), un Version Control System (VCS) è una cosa saggia da usare. Ti permette di ripristinare i file ad uno stato precedente, ripristinare l'intero progetto ad uno stato precedente, comparare i cambiamenti nel tempo, vedere chi ha modificato cosa che può aver causato un problema, chi ha introdotto un problema e quando, e altro ancora. Usare un VCS, in generale, significa che se si fanno dei pasticci o si perdono dei file, si possono facilmente ripristinare. In aggiunta, si ottiene tutto questo con un piccolo dispendio di risorse.

### Sistema di Controllo di Versione locale ###

Il metodo di controllo di versione scelto da molte persone è di copiare i file in un'altra directory (magari una directory denominata con la data, se sono furbi). Questo approccio è molto comune perché è molto semplice, ma è anche incredibilmente soggetto ad errori. E' facile dimenticarsi la directory in cui ci si trova e accidentalmente scrivere sul file sbagliato o copiare i file che non si intendevano copiare.

Per far fronte a questo problema, i programmatori svilupparono VCS locali che avevano un semplice database che manteneva tutti i cambiamenti dei file sotto controllo di revisione (vedi Figura 1-1).

Insert 18333fig0101.png 
Figura 1-1. Diagramma di controllo di versione locale.

Uno dei più popolari strumenti VCS era un sistema chiamato rcs, che è ancora oggi distribuito con alcuni computer. Anche il popolare sistema operativo Mac OS X include il comando rcs quando si installano gli Strumenti di Sviluppo. Semplicemente questo strumento funziona mantenendo una serie di patch (che sono le differenze fra i file) da un cambiamento ad un altro in un formato specifico sul disco; esso può poi ricreare qualsiasi file come se fosse quel file in un determinato momento aggiungendo tutte le patch.

### Sistemi di Controllo di Versione Centralizzati ###

Il problema successivo in cui incorsero le persone è che queste hanno bisogno di collaborare con altri sviluppatori su altri sistemi. Per far fronte a questo problema, vennero sviluppati sistemi di controllo di versione centralizzati (Centralized Version Control Systems, CVCS). Questi sistemi, come CVS, Subversion e Perforce, hanno un singolo server che contiene tutte le versioni dei file e un numero di utenti che controllano i file dalla centrale. Per alcuni anni, questo fu lo standard per il controllo di versione (vedi Figura 1-2).

Insert 18333fig0102.png 
Figura 1-2. Diagramma controllo di versione centralizzato.

Questa impostazione offre molti vantaggi, specialmente rispetto ai VCS locali.  Per esempio, chiunque sa, ad un certo livello, cosa stia facendo un'altra persona nel progetto. Gli amministratori hanno un controllo preciso su chi può fare cosa; ed è molto più facile amministrare un tale CVCS che un database locale su ogni client.

Tuttavia, questa configurazione ha alcuni gravi lati negativi. La più ovvia è il singolo punto di cedimento che il server centralizzato rappresenta. Se questo va giù per un'ora, durante questo periodo nessuno può collaborare o salvare le modifiche di versione di qualsiasi cosa su cui sta lavorando. Se il disco rigido del database centrale si danneggia, e non sono state effettuate copie di backup, si perde tutta la storia del progetto, ad eccezione di singoli snapshot (istantanee) fatte dalle persone sulla loro macchina locale. Anche i sistemi locali di VCS soffrono di questo problema-ogni volta che si ha tutta la storia del progetto in un unico posto, si rischia di perdere tutto.

### Sistemi di Controllo di Versione Distribuiti ###

E qui entrano in gioco i Sistemi di Controllo di Versione Distribuiti (Distributed Version Control Systems o DVCS). In un DVCS (come Git, Mercurial, Bazaar o Darcs), i client non solo controllano il recente snapshot dei file: essi fanno una copia completa del repository. In tal modo, se si blocca un server ed i sistemi interagiscono tramite un DVCS, un qualsiasi repository di client può essere copiato sul server e quindi ripristinarlo. Ogni checkout, in realtà, è un backup completo di tutti i dati (vedi Figura 1-3).

Insert 18333fig0103.png 
Figura 1-3. Diagramma controllo di versione distribuito.

Inoltre, molti di questi sistemi trattano abbastanza bene l'avere più repository remoti su cui poter lavorare, così si può collaborare con gruppi differenti di persone in modi differenti simultaneamente sullo stesso progetto. Questo ti permette di impostare diversi tipi di flussi di lavoro che non sono possibili in sistemi centralizzati, come i modelli gerarchici.

## Una breve storia di Git ##

Come per molte grandi cose nella vita, Git è iniziato con un po' di distruzione creativa e polemiche di fuoco. Il kernel di Linux è un progetto software open source di portata abbastanza ampia. Per la manutenzione del kernel Linux, per diverso tempo (1991-2002), le modifiche al software venivano passate sotto forma di patch e file d'archivio. Nel 2002, il progetto del kernel di Linux iniziò ad utilizzare un sistema proprietario chiamato DVCS BitKeeper.

Nel 2005, il rapporto tra la comunità che ha sviluppato il kernel Linux e la società commerciale che ha sviluppato BitKeeper si ruppe, e l'uso gratuito di questo strumento fu revocato. Ciò ha indotto la comunità di sviluppo di Linux (e in particolare Linus Torvalds, il creatore di Linux) a sviluppare il proprio strumento, basandosi su alcune delle lezioni apprese durante l'utilizzo di BitKeeper. Alcuni degli obiettivi del nuovo sistema sono i seguenti:

*	Velocità
*	Design semplice
*	Forte supporto allo sviluppo non-lineare (migliaia di rami paralleli)
*	Completamente distribuito
*	Capacità di gestire, in modo efficiente (velocità e dimensione dei dati), grandi progetti come il kernel Linux

Fin dalla sua nascita nel 2005, Git si è evoluto e maturato per essere facile da usare e tuttora mantiene le sue qualità iniziali. E' incredibilmente veloce, è molto efficiente con grandi progetti, ed ha un incredibile sistema di branching (rami), per lo sviluppo non lineare (Vedi Capitolo 3).

## Basi di Git ##

Quindi, cos'è Git in poche parole? Questa è una sezione importante da assorbire, perché se si comprende che cosa è Git e gli elementi fondamentali di come funziona, allora probabilmente, sarà molto più facile per te usare Git efficacemente. Mentre impari Git, cerca di liberare la mente dalle cose che eventualmente conosci su altri VCS, come Subversion e Perforce; ciò ti aiuterà ad evitare di far confusione utilizzando lo strumento. Git immagazzina e tratta le informazioni in modo diverso dagli altri sistemi, anche se l'interfaccia utente è abbastanza simile; comprendere queste differenze aiuta a prevenire di sentirsi confusi, mentre lo si usa.

### Snapshot, non Differenze ###

La principale differenza tra Git e gli altri VCS (Subversion e compagnia), è il modo in cui Git considera i suoi dati. Concettualmente, la maggior parte degli altri sistemi salvano l'informazione come una lista di cambiamenti  apportati ai file. Questi sistemi (CVS, Subversion, Perforce, Bazaar e così via), considerano le informazioni che essi mantengono come un insieme di file, con le relative modifiche fatte ai file, nel tempo, come illustrato in Figura 1-4.

Insert 18333fig0104.png 
Figura 1-4. Gli altri sistemi tendono ad immagazzinare i dati come cambiamenti alla versione base di ogni file.

Git non considera i dati in questo modo né li immagazzina in questo modo. Invece, Git considera i propri dati più come una serie di istantanee (snapshot) di un mini filesystem.  Ogni volta che si fa un commit, o si salva lo stato del proprio progetto in Git, esso fondamentalmente fa un'immagine di tutti i file in quel momento, salvando un riferimento allo snapshot. Per essere efficiente, se alcuni file non sono cambiati, Git non li immagazzina nuovamente — semplicemente crea un collegamento agli stessi file, già immagazzinati, della versione precedente. Git considera i propri dati più come in Figura 1-5.

Insert 18333fig0105.png 
Figura 1-5.  Git immagazzina i dati come snapshot del progetto nel tempo.

Questa è una distinzione importante tra Git e gli altri VCS. Git riconsidera tutti gli aspetti del controllo di versione mentre la maggior parte degli altri sistemi copiano dalle precedenti generazioni. Questo fa di Git più un qualche cosa di simile ad un mini filesystem con alcuni incredibili e potenti strumenti costruiti su di esso, invece che un semplice VCS. Esploreremo alcuni benefici che potrai avere immaginando i tuoi dati in questo modo quando vedremo il branching (le ramificazioni) con Git nel Capitolo 3.

### Quasi tutte le operazioni sono locali ###

La maggior parte delle operazioni in Git, necessitano solo di file e risorse locali per operare — generalmente non occorrono informazioni da altri computer nella rete. Se si era abituati ad un CVCS, in cui la maggior parte delle operazioni erano soggette alle latenze di rete, questo aspetto di Git vi farà pensare che gli dei della velocità abbiano benedetto Git con poteri soprannaturali. Giacché l'intera storia del progetto sta qui, sul proprio disco locale, le operazioni sembrano quasi istantanee.

Per esempio, per scorrere la storia di un progetto, Git non ha bisogno di connettersi al server per scaricarla e per poi visualizzarla — la legge direttamente dal database locale. Questo significa che puoi vedere la storia del progetto quasi istantaneamente. Se vuoi vedere i cambiamenti introdotti tra la versione corrente di un file e la versione di un mese fa, Git può consultare il file di un mese fa e calcolare localmente le differenze, invece di richiedere di farlo ad un server remoto o di estrarre una precedente versione del file dal server remoto, per poi farlo in locale.

Questo significa anche che sono minime le cose che non si possono fare se si è offline o non connesso alla VPN. Se sei in aereo o sul treno e vuoi fare un po' di lavoro, puoi eseguire tranquillamente il commit, anche se non sei connesso alla rete per fare l'upload. Se tornando a casa, trovi che il tuo client VPN non funziona correttamente, puoi comunque lavorare. In molti altri sistemi, fare questo è quasi impossibile o penoso. Con Perforce, per esempio, puoi fare ben poco se non sei connesso al server; e con Subversion e CVS, puoi modificare i file, ma non puoi inviare i cambiamenti al tuo database (perché il database è offline). Tutto ciò non ti può sembrare una gran cosa, tuttavia potresti rimanere di stucco dalla differenza che Git può fare.

### Git ha Integrità ###

Qualsiasi cosa in Git è controllata, tramite checksum, prima di essere salvata ed è referenziata da un checksum. Questo significa che è impossibile cambiare il contenuto di qualsiasi file o directory senza che Git lo sappia. Questa è una funzionalità interna di Git al più basso livello ed è intrinseco nella sua filosofia. Non puoi perdere informazioni nel transito o avere corruzioni di file senza che Git non sia in grado di accorgersene.

Il meccanismo che Git usa per fare questo checksum, è un hash, denominato SHA-1. Si tratta di una stringa di 40-caratteri, composta da caratteri esadecimali (0–9 ed a–f) e calcolata in base al contenuto di file o della struttura di directory in Git. Un hash SHA-1 assomiglia a qualcosa come:

	24b9da6552252987aa493b52f8696cd6d3b00373

in Git, questi valori di hash si vedono dappertutto, perché Git li usa tantissimo. Infatti, Git immagazzina ogni cosa, nel proprio database indirizzabile, non per nome di file, ma per il valore di hash del suo contenuto.

### Git generalmente aggiunge solo dati ###

Quando si fanno delle azioni in Git, quasi tutte aggiungono solo dati al database di Git. E' piuttosto difficile che si porti il sistema a fare qualcosa che non sia annullabile o a cancellare i dati in una qualche maniera. Come in altri VCS, si possono perdere o confondere le modifiche, di cui non si è ancora fatto il commit; ma dopo aver fatto il commit di uno snapshot in Git, è veramente difficile perderle, specialmente se si esegue regolarmente, il push del proprio database sull'altro repository.

Questo rende l'uso di Git un piacere perché sappiamo che possiamo sperimentare senza il pericolo di perdere seriamente le cose. Per un maggior approfondimento su come Git salva i dati e come puoi recuperare i dati che sembrano persi, vedi "Sotto il Cofano" nel Capitolo 9.

### I tre stati ###

Ora, prestare attenzione. Questa è la prima cosa da ricordare su Git se si vuole affrontare al meglio il processo di apprendimento. Git ha tre stati principali, in cui possono risiedere i file: committed, modified e staged. Committed significa che il file è immagazzinato al sicuro, nel database locale. Modified significa che il file è stato modificato, ma non è stato ancora eseguito il commit nel proprio database. Staged significa che un file modificato nella versione corrente, è stato contrassegnato per essere inserito nello snapshot, al commit successivo.

Questo ci conduce alle tre sezioni principali di un progetto Git: la directory di Git, la directory di lavoro e l'area di stage.

Insert 18333fig0106.png 
Figura 1-6. Directory di lavoro, area di stage e directory di Git.

La directory di Git è il luogo dove Git salva i metadati ed il database degli oggetti di un progetto. Questa è la parte più importante di Git, ed è ciò che viene copiato quando si clona un repository da un altro computer.

La directory di lavoro è un singolo checkout di una versione del progetto. Questi file sono estratti dal database compresso, nella directory di Git, e posizionati nel disco per essere usati o modificati.

L'area di stage è un semplice file, generalmente contenuto nella directory di Git, contenente le informazioni riguardanti il commit successivo. Qualche volta viene indicato come l'indice, ma sta diventando d'uso comune riferirsi ad essa, come all'area di stage (sosta).

Il flusso base di lavoro in Git, scorre come segue:

1.	Modificare i file nella directory di lavoro
2.	Eseguire l'operazione di stage dei file, per aggiungere i relativi snapshot all'area di stage
3.	Eseguire il commit, per immagazzinare permanentemente nella directory di Git, lo snapshot relativo, una volta presi i file nell'area di stage

Se una versione particolare di un file è nella directory git, sarà considerata committed (già affidata/inviata). Se il file è stato modificato ma è stato aggiunta all'area di staging, è in sosta. E se è stato modificato da quando è stata controllato ma non è stato messo in sosta, sarà modificato.  Nel Capitolo 2, imparerai di più su questi stati e come trarne vantaggio da essi o saltare interamente la parte di staging.

## Installare Git ##

Incominciamo ad usare un po' di Git! Per prima cosa — occorre installarlo. Puoi ottenere Git in diversi modi; i due principali sono, installarlo dai sorgenti o installarlo da un pacchetto pre-esistente per la tua piattaforma.

### Installazione da sorgenti ###

Se puoi, è generalmente vantaggioso installare Git dai sorgenti, perché così puoi usare la versione più recente. Ogni versione di Git, tende ad includere utili miglioramenti all'interfaccia utente, quindi, avere l'ultima versione disponibile è spesso la scelta migliore, se si ha familiarità con la compilazione dei sorgenti. Inoltre capita anche, che molte distribuzioni Linux contengano pacchetti molto vecchi; perciò, se non stai usando una distro aggiornata o dei backport, l'installazione da sorgente può essere la cosa migliore da fare.

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
	
### Installazione su Linux ###

Se vuoi installare Git su Linux, tramite una installazione da binario, generalmente, puoi farlo con lo strumento base di amministrazione-dei-pacchetti della tua distribuzione. Se sei su Fedora, puoi usare yum:

	$ yum install git-core

O se sei su una distribuzione basata su Debian, come Ubuntu, prova apt-get:

	$ apt-get install git-core

### Installazione su Mac ###

Ci sono due metodi per installare Git su Mac. Il più semplice è usare l'installatore grafico di Git, che puoi scaricare dalla pagina di Google Code (vedi Figura 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figura 1-7. Installatore di Git per SO X.

L'altro metodo è installare Git via MacPorts (`http://www.macports.org`). Se hai MacPorts installato, installa Git con:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Non ti occorre aggiungere tutti i pacchetti, ma evidentemente vorrai includere +svn, nel caso tu debba usare Git con i repository di Subversion (vedi Capitolo 8).

### Installazione su Windows ###

Installare Git su Windows è davvero facile. Il progetto msysGit ha una delle procedure di installazione tra le più facili. Semplicemente scarica l'installatore exe dalla pagina di Google Code, e lancialo:

	http://code.google.com/p/msysgit

Una volta installato, hai a disposizione sia la versione da riga di comando (incluso un client SSH che sarà utile, in seguito) sia l'interfaccia grafica (GUI) standard.

## Prima configurazione di Git ##

Ora che hai Git sul tuo sistema, vorrai fare un paio di cose per personalizzare l'ambiente di Git. Ti occorre farle solo una volta; esse rimangono invariate anche dopo un aggiornamento. Comunque, puoi cambiarle, in ogni momento, eseguendo di nuovo questi comandi.

Git è rilasciato con uno strumento che si chiama git config che ti permetterà di ottenere ed impostare le variabili di configurazione che controllano ogni aspetto delle operazioni e del look di Git. Queste variabili possono essere salvate in tre posti differenti:

*	file `/etc/gitconfig`: Contiene i valori per ogni utente sul sistema e per tutti i loro repository. Se si passa l'opzione` --system` a `git config`, lui legge e scrive da questo specifico file. 
*	file `~/.gitconfig`: Specifico per il tuo utente. Puoi far leggere e scrivere a Git questo file passando l'opzione `--global`. 
*	file di configurazione nella directory git (che è `.git/config`) di ogni repository che si sta usando. Specifico per ogni singolo repository. Ogni livello sovrascrive i valori del livello precedente, così i valori in `.git/config` vincono su quelli in `/etc/gitconfig`.

Sui sistemi Windows, Git cerca il file `.gitconfig` nella directory `$HOME` (`C:\Documents and Settings\$USER` per la maggior parte delle persone). Inoltre per quanto riguarda /etc/gitconfig, sarà relativo alla radice di MSys, che è in dipendenza a dove si vorrà installare Git sul sistema Windows quando si lancia l'installazione.

### La propria identità ###

La prima cosa che occorrerebbe fare, quando si installa Git, è impostare il proprio nome utente e indirizzo e-mail. Ciò è importante, perché ogni commit di Git usa queste informazioni, che vengono incapsulate nei commit che si fanno:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Di nuovo, passando l'opzione `--global`, occorre fare ciò solo una volta, dopo di che Git userà sempre queste informazioni, per qualsiasi operazione fatta sul sistema. Se si vuole sovrascriverle con un nome o una e-mail per progetti specifici, basta eseguire il comando senza l'opzione `--global`, quando si è in uno di quei progetti.

### Il proprio editor ###

Ora che è configurata la propria identità, si può configurare l'editor di testo predefinito, da usare quando Git avrà bisogno di inserire un messaggio. Per impostazione predefinita, Git usa l'editor di testo predefinito del sistema, che generalmente è Vi o Vim. Se vuoi usare un editor di testo differente, come Emacs, puoi fare come segue:

	$ git config --global core.editor emacs
	
### Il proprio Diff ###

Un'altra utile opzione, che si potrebbe voler configurare, è lo strumento diff, predefinito, da usare per risolvere i conflitti di merge (fusione). Per usare vimdiff:

	$ git config --global merge.tool vimdiff

Git accetta kdeff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge e opendiff, come strumenti validi di merge. E' anche possibile impostare uno strumento personalizzato; vedere il Capitolo 7, per maggiori informazioni su come farlo.

### Controllare le impostazioni ###

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

## Ottenere aiuto ##

Se dovessi avere bisogno di aiuto durante l'uso di Git, ci sono tre modi per vedere le pagine del manuale (manpage) di aiuto per ogni comando di Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Per esempio, puoi avere la manpage di aiuto, per il comando config, lanciando

	$ git help config

Questi comandi sono utili, perché puoi accedere ad essi da ogni dove, anche se sei offline.
Se il manpage e questo libro non sono sufficienti e hai bisogno di un aiuto più diretto da una persona, puoi provare i canali `#git` o `#github`, sul server IRC di Freenode (irc.freenode.com). Questi canali sono regolarmente frequentati da centinaia di persone che conoscono molto bene Git e saranno davvero felici di aiutarti.

## Riassumendo ##

Dovresti avere le basi per capire cos'è Git e come è differente dai CVCS che puoi aver usato. Dovresti anche avere una versione funzionante di Git sul tuo sistema che è configurata con la tua personale identità. E' ora tempo di imparare qualcosa di base di Git.
