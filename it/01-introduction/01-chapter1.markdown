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

Come per molte grandi cose della vita, Git è nato con un po' di distruzione creativa e polemiche infuocate. Il kernel di Linux è un progetto software open source di grande portata. Per buona parte del tempo (1991-2002) della manutenzione del kernel Linux le modifiche al software venivano passate sotto forma di patch e file compressi. Nel 2002, il progetto del kernel Linux iniziò ad utilizzare un sistema DVCS proprietario chiamato BitKeeper.

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

Questa è una distinzione importante tra Git e pressocché tutti gli altri VCS. Git riconsidera quasi tutti gli aspetti del controllo di versione che la maggior parte degli altri sistemi ha copiato dalle generazioni precedenti. Questo rende Git più simile a un mini filesystem con a disposizione strumenti incredibilmente potenti che un semplice VCS. Esploreremo alcuni benefici che ottieni pensando in questo modo ai tuoi dati e vedremo le ramificazioni (i _branch_) in Git nel Capitolo 3.

### Quasi Tutte le Operazioni Sono Locali ###

La maggior parte delle operazioni in Git, necessitano solo di file e risorse locali per operare — generalmente non occorrono informazioni da altri computer della rete. Se sei abituato ad un CVCS in cui la maggior parte delle operazioni sono soggette alle latenze di rete, questo aspetto di Git ti farà pensare che gli Dei della velocità abbiano benedetto Git con poteri soprannaturali. Poiché hai l'intera storia del progetto sul tuo disco locale, molte operazioni sembrano quasi istantanee.

Per esempio, per navigare la storia di un progetto, Git non ha bisogno di connettersi al server per scaricarla e per poi mostrarla: la legge direttamente dal tuo database locale. Questo significa che puoi vedere la storia del progetto quasi istantaneamente. Se vuoi vedere le modifiche introdotte tra la versione corrente e la versione di un mese fa di un file, Git può accedere al file com'era un mese fa e calcolare le differenze localmente, invece di dover chiedere a un server remoto di farlo o di scaricare dal server remoto una versione precedente del file, per poi farlo in locale.

Questo significa anche che sono pochissime le cose che non puoi fare se sei offline o non sei connesso alla VPN. Se sei in aereo o sul treno e vuoi fare un po' di lavoro, puoi committare tranquillamente in attesa di essere di nuovo connesso per fare l'upload. Se vai a casa e il tuo client VPN non funziona correttamente, puoi lavorare ugualmente. In molti altri sistemi questo è impossibile o molto penoso. Con Perforce, per esempio, puoi fare ben poco se non sei connesso al server; e con Subversion e CVS, puoi modificare i file, ma non puoi inviare le modifiche al tuo database (perché il database è offline). Tutto ciò potrebbe non sembrarti una gran cosa, ma potrebbe sorprenderti quanta differenza possa fare.

### Git Ha Integrità ###

Qualsiasi cosa in Git è controllata, tramite checksum, prima di essere salvata ed è referenziata da un checksum. Questo significa che è impossibile cambiare il contenuto di qualsiasi file o directory senza che Git lo sappia. Questa è una funzionalità interna di basso livello di Git ed è intrinseco della sua filosofia. Non può capitare che delle informazioni in transito si perdano o che un file si corrompa senza che Git non sia in grado di accorgersene.

Il meccanismo che Git usa per fare questo checksum è un hash chiamato SHA-1. Si tratta di una stringa di 40-caratteri, composta da caratteri esadecimali (0–9 ed a–f) e calcolata in base al contenuto di file o della struttura della directory in Git. Un hash SHA-1 assomiglia a qualcosa come:

	24b9da6552252987aa493b52f8696cd6d3b00373

Vedrai questi hash dappertutto in Git perché li usa tantissimo. Infatti Git salva qualsiasi cosa nel suo database, e il riferimento ad un file non è basato sul nome del file, ma sull'hash del suo contenuto.

### Git Generalmente Aggiunge Solo Dati ###

Quasi tutte le azioni in Git aggiungono dati al database di Git. È piuttosto difficile fare qualcosa che non sia annullabile o che cancelli i dati in una qualche maniera. Come negli altri VCS, puoi perdere o fare confusione con le modifiche che non hai ancora committato, ma dopo aver committato uno snapshot in Git, è veramente difficile perderle, specialmente se regolarmente fai il push del tuo database su un altro repository.

Questo rende piaceole l'uso di Git perché sappiamo che possiamo sperimentare senza il pericolo di causare danni pesanti. Per un maggior approfondimento su come Git salvi i dati e come tu possa recuperare quelli che sembrino persi, consulta il Capitolo 9.

### I Tre Stati ###

Ora, presta attenzione. La prima cosa da ricordare sempre di Git se vuoi affrontare al meglio il processo di apprendimento è che i tuoi file in Git possono essere in tre stati: _committed_ (committati), _modified_ (modificati) e _staged_ (in stage). Committato significa che il file è al sicuro nel database locale. Modificato significa che il file è stato modificato, ma non è ancora stato committato nel database. In stage significa che hai contrassegnato un file, modificato nella versione corrente, perché venga inserito nello snapshot alla prossima commit.

Questo ci porta alle tre sezioni principali di un progetto Git: la directory di Git, la directory di lavoro e l'area di stage.

Insert 18333fig0106.png 
Figura 1-6. Directory di lavoro, area di stage e directory di Git.

La directory di Git è dove Git salva i metadati e il database degli oggetti del tuo progetto. Questa è la parte più importante di Git, ed è ciò che viene copiato quando si clona un repository da un altro computer.

La directory di lavoro è un checkout di una versione specifica del progetto. Questi file vengono estratti dal database compresso nella directory di Git, e salvati sul disco per essere usati o modificati.

L'area di stage è un file, contenuto generalmente nella directory di Git, con tutte le informazioni riguardanti la tua prossima commit. A volte viene indicato anche come 'indice', ma lo standard è definirlo come 'area di stage' (area di sosta, ndt).

Il flusso di lavoro (_workflow_) di base in Git funziona così:

1. Modifica i file nella tua directory di lavoro
2. Fanne lo stage, aggiungendone le istantanee all'area di stage
3. Committa, ovvero salva i file nell'area di stage in un'istantanea (_snapshot_) permanente nella tua directory di Git.

Se una particolare versione di un file è nella directory git, viene considerata già committata. Se il file è stato modificato, ma è stato aggiunto all'area di staging, è _in stage_. E se è stato modificato da quando è stata estratto, ma non è _in stage_, è modificato.  Nel Capitolo 2, imparerai di più su questi stati e come trarne vantaggio o saltare la parte di staging.

## Installare Git ##

Incominciamo ad usare un po' di Git! Per prima cosa devi installarlo. Puoi ottenere Git in diversi modi; i principali due sono: installarlo dai sorgenti o installarlo da un pacchetto pre-esistente per la tua piattaforma.

### Installare da Sorgenti ###

Se puoi, generalmente è vantaggioso installare Git dai sorgenti perché avrai la versione più recente. Ogni versione di Git tende ad includere utili miglioramenti all'interfaccia utente e avere quindi l'ultima versione disponibile è spesso la scelta migliore, se hai familiarità con la compilazione dei sorgenti. Inoltre capita anche, che molte distribuzioni Linux usino pacchetti molto vecchi; perciò, se non stai usando una distro aggiornata o dei backport, l'installazione da sorgente può essere la cosa migliore da fare.

Per installare Git, hai bisogno delle librerie da cui dipende Git che sono: curl, zlib, openssl, expat e libiconv. Per esempio, se sei su un sistema che usa yum (come Fedora), o apt-get (come nei sistemi Debian), puoi usare uno dei seguenti comandi per installare tutte le dipendenze:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
Quando avrai tutte le dipendenze necessarie, puoi proseguire ed andare a recuperare l'ultimo snapshot dal sito web di Git:

	http://git-scm.com/download
	
Poi, compilalo ed installalo:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Dopo aver fatto questo, puoi scaricare gli aggiornamenti di Git con lo stesso Git:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installare su Linux ###

Se vuoi installare Git su Linux, tramite una installazione da binario, generalmente puoi farlo con lo strumento base di amministrazione dei pacchetti della tua distribuzione. Se usi Fedora, puoi usare yum:

	$ yum install git

O, se usi una distribuzione basata su Debian (come Ubuntu) prova apt-get:

	$ apt-get install git

### Installazione su Mac ###

Ci sono due metodi per installare facilmente Git su Mac. Il più semplice è usare l'installazione l'installer grafico di Git, che puoi scaricare da SourceForge (vedi Figura 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png 
Figura 1-7. Installer di Git per OS X.

La prima alternativa è usando MacPorts (`http://www.macports.org`). Se hai già installato MacPorts puoi installare Git con:

	$ sudo port install git +svn +doc +bash_completion +gitweb

Non ti occorre aggiungere tutti i pacchetti extra, ma probabilmente vorrai includere +svn, nel caso tu debba usare Git con i repository di Subversion (vedi Capitolo 8).

La seconda alternativa è Homebrew (`http://brew.sh/`). Se hai già installato Homebrew puoi installare Git con:

	$ brew install git

### Installare su Windows ###

Installare Git su Windows è davvero facile. Il progetto msysGit ha una delle procedure di installazione più facili. Semplicemente scarica l'eseguibile dalla pagina di GitHub e lancialo:

	http://msysgit.github.io/

Una volta installato avrai a disposizione sia la versione da riga di comando (incluso un client SSH ti servirà in seguito) sia l'interfaccia grafica (_GUI_) standard.

Nota sull'uso su Windows: dovresti usare Git con la shell msysGit fornita (stile Unix) perché permette di usare le complesse linee di comando di questo libro. Se hai bisogno, per qualche ragione, di usare la shell nativa di Windows / la console a linea di comando, devi usare le doppie virgolette invece delle virgolette singole (per i parametri con che contengono spazi) e devi virgolettare i parametri che terminano con l'accento circonflesso (^) se questi sono al termine della linea, poiché in Windows è uno dei simboli di proseguimento.

## Prima Configurazione di Git ##

Ora che hai Git sul tuo sistema vorrai fare un paio di cose per personalizzare l'ambiente di Git. Devi farle solo una volta: rimarrano invariate anche dopo un aggiornamento. Puoi comunque cambiarle in ogni momento, rieseguendo i comandi.

Git viene con uno strumento che si chiama 'git config' che ti permetterà d'impostare e conoscere le variabili di configurazione che controllano ogni aspetto di come appare Git e come opera. Queste variabili possono essere salvate in tre posti differenti:

*	`/etc/gitconfig`: Contiene i valori per ogni utente sul sistema e per tutti i loro repository. Se passi l'opzione` --system` a `git config`, lui legge e scrive da questo file specifico. 
*	`~/.gitconfig`: Specifico per il tuo utente. Puoi far leggere e scrivere a Git questo file passando l'opzione `--global`. 
*	file di configurazione nella directory git (cioè `.git/config`) di qualsiasi repository che si stia usando. È Specifico di quel singolo repository. Ogni livello sovrascrive i valori del precedente, così che i valori in `.git/config` vincono su quelli in `/etc/gitconfig`.

Su Windows Git cerca il file `.gitconfig` nella directory `$HOME` (`%USERPROFILE%` in Windows), che per la maggior parte delle persone è `C:\Documents and Settings\$USER` o `C:\Users\$USER`, dipendendo dalla versione (`$USER` è `%USERNAME%` in Windows). Controlla comunque anche /etc/gitconfig, sebbene sia relativo alla root di MSys, che è dove hai deciso di installare Git in Windows quando si lancia l'installazione.

### La tua Identità ###

La prima cosa che occorrerebbe fare quando installi Git è impostare il tuo nome utente e il tuo indirizzo e-mail. Questo è importante perché ogni commit di Git usa queste informazioni che vengono incapsulate nelle tue commit:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Con l'opzione `--global` dovrai farlo solo una volta, dopo di che Git userà sempre queste informazioni per qualsiasi operazione fatta sul sistema. Se vuoi sovrascriverle con un nome o una e-mail diversi per progetti specifici potrai eseguire il comando senza l'opzione `--global`stando in uno di quei progetti.

### Il tuo Editor ###

Ora che hai configurato la tua identità, puoi configurare il tuo editor di testo predefinito, che verrà usato quando Git avrà bisogno che scriva un messaggio. Per impostazione predefinita Git usa l'editor di testo predefinito del sistema, che generalmente è Vi o Vim. Se vuoi usarne uno diverso, come Emacs, potrai eseguire:

	$ git config --global core.editor emacs
	
### Il tuo Diff ###

Un'altra opzione utile che potresti voler configurare, è lo strumento diff predefinito, da usare per risolvere i conflitti di _merge_ (unione, ndt). Per usare vimdiff, potrai eseguire:

	$ git config --global merge.tool vimdiff

Git accetta kdeff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge e opendiff, come strumenti di merge validi. Puoi anche definire uno personalizzato: vedi il Capitolo 7 per maggiori informazioni su come farlo.

### Controlla le tue impostazioni ###

Per controllare le tue impostazioni puoi usare il comando `git config --list` che elenca tutte le impostazioni attuali di Git:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Potresti vedere più volte la stessa chiave perché Git legge la stessa chiave da file differenti (`/etc/gitconfig` e `~/.gitconfig`, per esempio). In questo caso, Git usa l'ultimo valore per ogni chiave unica che trova.

Puoi anche controllare quale sia il valore di una chiave specifica digitando `git config {key}`:

	$ git config user.name
	Scott Chacon

## Ottieni aiuto ##

Se dovessi avere bisogno di aiuto durante l'uso di Git, ci sono tre modi per vedere le pagine del manuale (_manpage_) per ogni comando di Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Per esempio, puoi consultare la pagina del manuale per il comando config digitanto

	$ git help config

Questi comandi sono utili perché puoi accedervi dappertutto, anche quando sei offline.
Se il manuale e questo libro non fossero sufficienti e avessi bisogno dell'aiuto di una persona, puoi provare i canali `#git` o `#github` sul server IRC di Freenode (irc.freenode.com). Questi canali sono frequentati regolarmente da centinaia di persone che conoscono molto bene Git e spesso sono disponibili per dare una mano.

## Sommario ##

Dovresti avere le basi per capire cos'è Git e com'è diverso dai CVCS che potresti aver usato. Dovresti avere già una versione funzionante di Git sul tuo sistema che è configurata con i tuoi dati. È ora tempo di imparare alcune delle basi di Git.
