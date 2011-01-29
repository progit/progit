# Per iniziare #

Questo capitolo spiegherà come iniziare ad usare Git.  Inizieremo con una introduzione sugli strumenti di controllo della versione,  per poi passare a come far funzionare Git sul proprio sistema  ed infine come configurarlo per lavorarci.  Alla fine di questo capitolo, si dovrebbe capire a cosa serve Git, perché lo si dovrebbe usare ed essere pronti per usarlo.

## Il Controlo di Versione ##

Cos'è il controllo di versione, e perché si dovrebbe usare? Il controllo di versione è un sistema che registra i cambiamenti di un file o di una serie di file nel tempo così si può richiamare una versione specifica successivamente. Per gli esempi in questo libro useremo i file del codice sorgente di un software per controllarne la versione, anche se in realtà si può fare con qualsiasi tipo di file sul computer.

Se sei un grafico o un webdesigner e vuoi tenere tutte le versioni di un'immagine o di un layout (e sicuramente lo vorrai fare), un Version Control System (VCS) è una cosa saggia da usare. Ti permette di ripristinare i file allo stato precedente, ripristinare l'intero progetto allo stato precedente, comparare i cambiamenti nel tempo, vedere chi ha modificato cosa che può aver causato un problema, chi ha introdotto un problema e quando, e altro. Usando un VCS generalmente significa che se si fanno dei pasticci o si perdono dei file, si possono facilmente ripristinare. In aggiunta si ottiene tutto questo con un piccolo dispendio di risorse.

### Sistema di Controllo di Versione locale ###

Un metodo di controllo di versione scelto da molte persone è di copiare i file in un'altra directory (magari una directory nominata con la data, se sono intelligenti). Questo approccio è molto comune perché è semplice, ma è anche incredibilmente soggetto ad errori. E' facile dimenticare in quale directory ci si trova e accidentalmente scrivere sul file sbagliato o copiare i file che non si intendevano copiare.

Per far fronte a questo problema, i programmatori svilupparono VCS locali che avevano un semplice database che manteneva tutti i cambiamenti dei file sotto controllo di revisione (vedi Figura 1-1).

Insert 18333fig0101.png 
Figure 1-1. Diagramma di controllo di versione locale.

Uno dei più popolari strumenti VCS era un sistema chiamato rcs, che è ancora oggi distribuito con alcuni computer. Anche il popolare sistema operativo Mac OS X include il comando rcs quando si installano gli Strumenti di Sviluppo. Semplicemente questo strumento funziona mantenendo una serie di patch (che sono le differenze fra i file) da un cambiamento ad un altro in un formato specifico sul disco; esso può poi ricreare qualsiasi file come se fosse quel file in un determinato momento aggiungendo tutte le patch.

### Sistemi di Controllo di Versione Centralizzati ###

Il problema successivo in cui incorsero le persone è che queste hanno bisogno di collaborare con altri sviluppatori su altri sistemi. Per far fronte a questo problema, vennero sviluppati sistemi di controllo di versione centralizzati (Centralized Version Control Systems, CVCS). Questi sistemi, come CVS, Subversion e Perforce, hanno un singolo server che contiene tutte le versioni dei file e un numero di utenti che controllano i file dalla centrale. Per alcuni anni, questo fu lo standard per il controllo di versione (vedi Figura 1-2).

Insert 18333fig0102.png 
Figure 1-2. Diagramma controllo di versione centralizzato.

Questo sistema offre alcuni vantaggi, specialmente rispetto al VCS locale.  Per esempio, chiunque può sapere, fino ad un certo punto, cosa fa qualsiasi altra persona nel progetto. Gli amministratori possono controllare, attraverso una configurazione, chi può fare cosa; ed è molto più facile amministrare un CVCS che un database locale per ogni client.

Tuttavia, questa configurazione ha alcuni gravi lati negativi. La più ovvia è il singolo punto di cedimento che il server centralizzato rappresenta. Se questo va giù per un'ora, durante questo periodo nessuno può collaborare o salvare le modifiche di versione di qualsiasi cosa su cui sta lavorando. Se il disco rigido del database centrale si danneggia, e non sono state effettuate copie di backup, si perde tutta la storia del progetto, ad eccezione di singoli snapshot (istantanee) fatte dalle persone sulla loro macchina locale. Anche i sistemi locali di VCS soffrono di questo problema-ogni volta che si ha tutta la storia del progetto in un unico posto, si rischia di perdere tutto.

### Sistemi di Controllo di Versione Distribuiti ###
Qui è dove entrano in gioco Sistemi di Controllo di Versione Distribuiti (Distributed Version Control Systems, DVCS). In un DVCS (come Git, Mercurial, Bazaar o Darcs), i client non solo possono avere tutti gli ultimi snapshot dei file: essi sono la copia completa del repository. Così, se un qualsiasi server muore, e questi sistemi collaborando tramite esso, qualsiasi repository di un client può essere copiato sul server per ripristinarlo. Ogni archivio è in realtà un backup completo di tutti i dati (vedi Figura 1-3).

Insert 18333fig0103.png 
Figure 1-3. Diagramma controllo di versione distribuito.

Inoltre, molti di questi sistemi trattano abbastanza bene l'avere più repository remoti su cui poter lavorare, così si può collaborare con gruppi differenti di persone in modi differenti simultaneamente sullo stesso progetto. Questo ti permette di impostare diversi tipi di flussi di lavoro che non sono possibili in sistemi centralizzati, come i modelli gerarchici.

## Una breve storia di Git ##

Come per molte grandi cose nella vita, Git è iniziato con un po' di distruzione creativa e polemiche di fuoco. Il kernel Linux è un progetto software open source di una certa importanza. Per la maggior parte della durata della manutenzione del kernel Linux (1991-2002), le modifiche al software erano passate sotto forma di patch e archivi. Nel 2002, il progetto del kernel di Linux iniziò ad
utilizzare un sistema proprietario chiamato DVCS BitKeeper.

Nel 2005, il rapporto tra la comunità che ha sviluppato il kernel Linux e la società commerciale che ha sviluppato BitKeeper si ruppe, e l'uso gratuito di questo strumento fu revocato. Ciò ha indotto la comunità di sviluppo di Linux (e in particolare Linus Torvalds, il creatore di Linux) a sviluppare il proprio strumento, basandosi su alcune delle lezioni apprese durante l'utilizzo di BitKeeper. Alcuni degli obiettivi del nuovo sistema sono i seguenti:

*	Velocità
*	Design semplice
*	Importante supporto allo sviluppo non-lineare (migliaia di rami paralleli)
*	Completamente distribuito
*	Capace di gestire progetti grandi come il kernel Linux in modo efficiente (velocità e dimensione dei dati)

Fin dalla sua nascita nel 2005, Git si è evoluto ed è maturato per essere facile da usare mantenendo queste qualità iniziali. E' incredibilmente veloce, è molto efficiente con grandi progetti, ed ha un incredibile sistema di branching (rami) per lo sviluppo non lineare (Vedi Capitolo 3).

## Basi di Git ##

Quindi, cos'è Git in poche parole? Questa è una sezione importante da assorbire, perché se si capisce che cos'è Git e gli elementi fondamentali di come funziona, usare Git efficacemente sarà probabilmente molto più facile per te. Mentre si impara Git, cercare di liberare la mente delle cose che si possono conoscere altri VCS, come Subversion e Perforce; così facendo ti aiuterai ad evitare confusione quando si utilizza lo strumento. Git immagazzina e pensa alle informazioni in modo diverso da altri sistemi, anche se l'interfaccia utente è abbastanza simile; capire queste differenze aiuterà a prevenire confusione mentre lo si userà.

### Snapshot, No Differenze ###

La maggiore differenza tra Git e gli altri VCS (Subversion e amici inclusi) è il modo in cui Git pensa ai dati. Concettualmente, la maggior parte degli altri sistemi salvano le informazioni come una lista di file basati sui cambiamenti. Questi sistemi (CVS, Subversion, Perforce, Bazaar e così via) pensano alle informazioni da mantenere come una serie di file e modifiche fatte ad ogni file nel tempo, come illustrato in Figura 1-4.

Insert 18333fig0104.png 
Figure 1-4. Altri sistemi tendono ad immagazzinare i dati come cambiamenti alla versione base di ogni file.

Git non pensa ad immagazzinare i dati in questo modo. Invece, Git pensa ai dati più come una serie di istantanee (snapshot) di un mini filesystem.  Ogni volta che si fa un commit, o si salva lo stato del proprio progetto in Git, fondamentalmente fa un'immagine di tutti i tuoi file di quel momento e salva una referenza nello snapshot. Per essere efficiente, se i file non sono cambiati, Git non immagazzina i file nuovamente-semplicemente li collega alla versione precedente dell'identico file che è stata già salvata. Git pensa ai dati più come in Figura 1-5.

Insert 18333fig0105.png 
Figure 1-5.  Git immagazzina i dati come snapshot del progetto nel tempo.

Questa è una distinzione importante tra Git e gli altri VCS. Git riconsidera tutti gli aspetti del controllo di versione mentre la maggior parte degli altri sistemi copiano dalle precedenti generazioni. Questo fa di Git più un qualche cosa di simile ad un mini filesystem con alcuni incredibili e potenti strumenti costruiti su di esso, invece che un semplice VCS. Esploreremo alcuni benefici che potrai avere immaginando i tuoi dati in questo modo quando vedremo il branching (le ramificazioni) con Git nel Capitolo 3.

### Circa Tutte le Operazioni Sono Locali ###

La maggior parte delle operazioni in Git necessitano solo di file e risorse locali per operare — generalmente nessuna informazione è necessaria da un altro computer sulla propria rete. Se sei abituato ad un CVCS in cui la maggior parte delle operazioni sono soggette al tempo di latenza della rete, questo aspetto di Git vi farà pensare che gli dei della velocità hanno benedetto Git con poteri soprannaturali. Perché hai l'intera storia del progetto li, sul disco locale, la maggior parte delle operazioni sembrano quasi istantanee.

Per esempio, per vedere la storia di un progetto, Git non ha bisogno di connettersi ad un server per averla e poi visualizzarla—semplicemente legge direttamente dal database locale. Questo significa che puoi vedere la storia del progetto quasi istantaneamente. Se vuoi vedere i cambiamenti introdotti tra la versione corrente di un file e la versione di un mese fa, Git può consultare il file di un mese fa e fare il calcolo delle differenze, invece di dover domandare ad un server remoto di fare questo o tirare fuori una versione vecchia del file dal server remoto per farlo in locale.

Questo significa anche che ci sono poche cose che non puoi fare se sei offline o non connesso alla VPN. Se sei su un aereoplano o sul treno e vuoi lavorare un po', puoi eseguire il commit felicemente fin quando non sei connesso ad una rete per fare l'upload. Se sei a casa e il tuo client VPN non funziona correttamente, puoi comunque lavorare. In qualsiasi altro sistema, fare questo è impossibile o penoso. Nelle performance, per esempio, non puoi fare molto quando non c'è una connessione al server; e in Subversion e CVS, puoi modificare i file, ma non puoi inviare i cambiamenti al database (perché il tuo database è offline). Questo può non sembrare un grande vantaggio, ma sarai sorpreso di che grande differenza possa fare.

### Git Mantiene l'Integrità ###

Qualsiasi cosa in Git è controllata, tramite checksum, prima di essere salvata ed è referenziata da un checksum. Questo significa che è impossibile cambiare il contenuto di qualsiasi file o directory senza che Git lo sappia. Questa è una funzionalità interna di Git al più basso livello ed è intrinseco nella sua filosofia. Non puoi perdere informazioni nel transito o avere corruzioni di file senza che Git non sia in grado di accorgersene.

Il meccanismo tramite che Git usa per il checksum è chiamato hash SHA-1.  Questa è una stringa di 40-caratteri composta da caratteri esadecimali (0–9 e a–f) e calcolata in base al contenuto di un file o della struttura di una directory in Git. Un hash SHA-1 assomiglia a qualcosa come questo:

	24b9da6552252987aa493b52f8696cd6d3b00373

Puoi vedere i valori dell'hash in ogni posto con Git perché li usa tantissimo. Infatti, Git immagazzina tutto non in base al nome del file ma nel database Git indirizzabile dal valore dell'hash del suo contenuto.

### Git Generalmente Aggiunge Solo Dati ###

Quando fai delle azioni in Git, quasi tutte aggiungono dati al database Git. E' veramente difficile avere il sistema che non cancelli niente o che cancelli i dati in qualsiasi modo. Come in qualsiasi VCS, tu puoi perdere o incasinare le modifiche che non si sono ancora inviate; ma dopo il commit di uno snapshot in Git, è veramente difficile perderle, specialmente se si esegue un push del proprio database su un altro repository.

Questo rende l'uso di Git un piacere perché sappiamo che possiamo sperimentare senza il pericolo di perdere seriamente le cose. Per un maggior approfondimento su come Git salva i dati e come puoi recuperare i dati che sembrano persi, vedi "Sotto il Cofano" nel Capitolo 9.

### I Tre Stati ###

Ora, porta attenzione. Questa è la cosa principale da ricordare di Git se desideri affrontare al meglio il tuo processo di apprendimento. Git ha tre principali stati dove possono risiedere i tuoi file: committed, modified e staged. Committed significa che i dati sono salvati nel database locale.  Modified significa che hai modificato il file ma non hai ancora eseguito il commit nel tuo database. Staged significa che hai marcato una modifica ad un file nella versione corrente  di essere inserita al commit del successivo snapshot.

Questo ci conduce alle tre sezioni principali di un progetto Git: la directory Git, la directory di lavoro e l'area di staging.

Insert 18333fig0106.png 
Figure 1-6. Directory di lavoro, area di staging e directory git.

La directory Git è dove Git salva i metadati ed il database degli oggetti del tuo progetto. Questa è la parte più importante di Git ed è quella che viene copiata quando cloni un repository da un altro computer.

La directory di lavoro è un semplice checkout di una versione del progetto. Questi file sono tirati fuori dal database compresso nella directory Git e messi sul disco per te per essere usati o modificati.

L'area di staging è un semplice file, generalmente contenuta nella tua directory Git, che salva le informazioni su cosa andrà nel prossimo commit.  Può essere consultata come un indice, ma sta diventando uno standard riferirsi ad essa come l'area di sosta.

Il flusso base di lavoro di Git sarà qualcosa di simile a:

1.	Modifichi i file nella directory di lavoro.
2.	Fai lo staging dei file, aggiungi gli snapshot di questi nella tua area di sosta.
3.	Esegui un commit, che prenderà i file come sono nell'area di sosta e salverà questi snapshot permanentemente nella tua directory Git.

Se una versione particolare di un file è nella directory git, sarà considerata committed (già affidata/inviata). Se il file è stato modificato ma è stato aggiunta all'area di staging, è in sosta. E se è stato modificato da quando è stata controllato ma non è stato messo in sosta, sarà modificato.  Nel Capitolo 2, imparerai di più su questi stati e come trarne vantaggio da essi o saltare interamente la parte di staging.

## Installare Git ##

Ora entriamo nell'uso di Git. Per prima cosa—lo devi installare. Lo puoi ottenere in modi differenti; i due metodi principali sono o installarlo dai sorgenti o installarlo da un pacchetto preesistente per la tua piattaforma.

### Installazione da Sorgenti ###

Se puoi, è generalmente utile installare Git dai sorgenti, perchè puoi avere la versione più recente. Ogni versione di Git tende ad includere miglioramenti utili all'UI, così questo è il modo migliore per ottenere l'ultima versione se si ha familiarità con la compilazione. E' anche vero che molte distribuzioni Linux contengono pacchetti molto vecchi, così se sei su una distro molto datata e stai usando dei backports, l'installazione da sorgente può essere la cosa migliore da fare.

Per installare Git, hai bisogno delle seguenti librerie da cui Git dipende: curl, lib, openssl, expat e libiconv. Per esempio, se sei su un sistema che usa yum (come Fedora) o apt-get (come un sistema basato su Debian), puoi usare uno dei seguenti comandi per installare tutti i pacchetti di dipendenza:

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

Se vuoi installare Git su Linux tramite una installazione da binario, puoi generalmente farlo attraverso lo strumento base di amministrazione dei pacchetti della tua distribuzione. Se sei su Fedora, puoi usare yum:

	$ yum install git-core

O se sei su una distribuzione basata su Debian, come Ubuntu, prova apt-get:

	$ apt-get install git-core

### Installazione su Mac ###

Ci sono due modi facili per installare Git su Mac. Il più semplice è usare l'installatore grafico di Git, che puoi scaricare dalla pagina di Google Code (vedi Figura 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Installatore Git OS X.

Un altro metodo è installare Git via MacPorts (`http://www.macports.org`). Se hai MacPorts installato, installa Git con:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Non hai bisogno di aggiungere altri pacchetti aggiuntivi, ma probabilmente vorrai includere +svn nel caso tu voglia usare Git con i repository Subversion (vedi Capitolo 8).

### Installazione su Windows ###

Installare Git su Windows è davvero facile. Il progetto msysGit ha una delle procedure di installazione tra le più facili. Semplicemente scarica l'installatore exe dalla pagina di Google Code, e lancialo:

	http://code.google.com/p/msysgit

Dopo che è stato installato, hai a disposizione sia la versione da riga di comando (incluso un client SSH che sarà utile in seguito) sia una GUI standard.

## Prima configurazione di Git ##

Ora che hai Git sul tuo sistema, vorrai fare un po' di cose per configurare il tuo ambiente Git. Le dovrai fare solo una volta; rimarranno tali anche dopo gli aggiornamenti. Puoi comunque cambiarle in ogni momento avviando gli stessi comandi nuovamente.

Git è rilasciato con uno strumento che si chiama git config che ti permetterà di ottenere ed impostare le variabili di configurazione che controllano ogni aspetto delle operazioni e del look di Git. Queste variabili possono essere salvate in tre posti differenti:

*	file `/etc/gitconfig`: Contiene i valori per ogni utente sul sistema e per tutti i loro repository. Se si passa l'opzione` --system` a `git config`, lui legge e scrive da questo specifico file. 
*	file `~/.gitconfig`: Specifico per il tuo utente. Puoi far leggere e scrivere a Git questo file passando l'opzione `--global`. 
*	file di configurazione nella directory git (che è, `.git/config`) di ogni repository che si sta usando: Specifico per ogni singolo repository. Ogni livello sovrascrive i valori del livello precedente, così i valori in `.git/config` vincono su quelli in `/etc/gitconfig`.

Sui sistemi Windows, Git cerca il file `.gitconfig` nella directory `$HOME` (`C:\Documents and Settings\$USER` per la maggior parte delle persone). Inoltre per quanto riguarda /etc/gitconfig, sarà relativo alla radice di MSys, che è in dipendenza a dove si vorrà installare Git sul sistema Windows quando si lancia l'installazione.

### La tua identità ###

La prima cosa che dovresti fare quando installi Git è di impostare il tuo nome utente e l'indirizzo e-mail. Questo è importante perché ad ogni commit Git usa queste informazioni, ed è immutabilmente impresso nei commit che si fanno girare:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Ancora, avrai bisogno di fare queste cose solo una volta se passi l'opzione `--global`, perché poi Git userà sempre queste informazioni per qualsiasi cosa che farai sul tuo sistema. Se vuoi sovrascriverle con un nome o una e-mail per uno specifico progetto, puoi avviare il comando senza l'opzione `--global` quando sarai in quel progetto.

### Il Tuo Editor ###

Ora che la tua identità è configurata, puoi configurare l'editor di testo predefinito che sarà usato quando Git avrà bisogno di inserire i messaggi. Di default, Git usa il tuo editor di testo predefinito del tuo sistema, che generalmente è Vi o Vim. Se vuoi usare un editor di testo differente, come Emacs, puoi fare come segue:

	$ git config --global core.editor emacs
	
### Il tuo strumento per il Diff ###

Un'altra opzione utile, che vorrai configurare, è lo strumento predefinito diff da usare per risolvere i conflitti con le unioni. Per dire che vuoi usare vimdiff:

	$ git config --global merge.tool vimdiff

Git accetta kdeff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge e opendiff come strumenti validi di fusioni. Puoi inoltre impostare uno strumento personalizzato; vedi il Capitolo 7 per maggiori informazioni su come farlo.

### Controllare le proprie impostazioni ###

Se vuoi controllare le tue impostazioni, puoi usare il comando `git config --list` per avere una vista di tutte le impostazioni di Git trovate in questo punto:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Puoi vedere la stessa chiave più volte, perché Git legge da file differenti (`/etc/gitconfig` e `~/.gitconfig`, per esempio). In questo caso, Git usa l'ultimo valore per ogni chiave unica che vede.

Puoi inoltre controllare cosa Git pensa a proposito del valore di una singola chiave usando `git config {key}`:

	$ git config user.name
	Scott Chacon

## Ottenere Aiuto ##

Se dovessi avere bisogno di aiuto durante l'uso di Git, ci sono tre modi per vedere le pagine del manuale (manpage) di aiuto per ogni comando di Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Per esempio, puoi avere la manpage di aiuto per il comando config lanciando

	$ git help config

Questi comandi sono carini perché puoi accedere ad essi in qualsiasi luogo, anche offline.
Se il manpage e questo libro non sono sufficienti e hai bisogno di un aiuto più personale, puoi provare il canale `#git` o `#github` sul server IRC di Freenode (irc.freenode.com). Questi canali sono regolarmente frequentati da centinaia di persone che conoscono molto bene Git e saranno davvero felici di aiutarti.

## Riassumento ##

Dovresti avere le basi per capire cos'è Git e come è differente dai CVCS che puoi aver usato. Dovresti anche avere una versione funzionante di Git sul tuo sistema che è configurata con la tua personale identità. E' ora tempo di imparare qualcosa di base di Git.
