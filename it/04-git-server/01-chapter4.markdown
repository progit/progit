# Git sul server #

A questo punto, dovresti essere in grado di fare la maggior parte delle operazioni quotidiane che si fanno con Git. Tuttavia, per avere una qualsiasi collaborazione in Git, devi avere un repository remoto Git. Anche se puoi tecnicamente inviare e scaricare modifiche da repository individuali, procedere in questo modo è sconsigliato, perché se non si sta attenti, ci si può confondere abbastanza facilmente riguardo a quello su cui si sta lavorando. Inoltre, se vuoi che i tuoi collaboratori siano in grado di accedere al repository anche se non sei in linea — avere un repository comune più affidabile è spesso utile. Pertanto, il metodo preferito per collaborare con qualcuno, è quello di creare un repository intermedio a cui entrambi avete accesso per inviare e scaricare dati. Faremo riferimento a questo repository come un "server Git"; vedrai che in genere ospitare un repository Git ha bisogno di una piccola quantità di risorse, quindi raramente c'è bisogno di usare un intero server per esso.

Avviare un server Git è semplice. In primo luogo, si sceglie quali protocolli si desidera utilizzare per comunicare con il server. La prima sezione di questo capitolo descriverà i protocolli disponibili con i pro e i contro di ciascuno. La sezione seguente spiegherà alcune impostazioni tipiche nell'utilizzo di questi protocolli e come utilizzarle nel proprio server. Infine, se non si hanno problemi ad ospitare il proprio codice su un server esterno e se non si vuole dedicare del tempo alla creazione e al mantenimento di un proprio server, si prenderà in considerazione qualche opzione per l'hosting.

Se non si ha interesse a gestire il proprio server, è possibile passare all'ultima sezione del capitolo per vedere alcune opzioni per la creazione di un account hosting e poi saltare al capitolo successivo, dove si discutono i flussi in ingresso e uscita in un ambiente distribuito per il controllo del codice sorgente. 

Un repository remoto è in genere un _bare repository_ — cioè un repository Git che non ha la cartella di lavoro. Dato che il repository viene usato solo come un punto di collaborazione, non c'è ragione di avere uno snapshot estratto dal disco; sono solo dati di Git. In termini più semplici, un repository nudo è il contenuto della directory `.git` del progetto e nient'altro.

## I protocolli ##

Git può utilizzare i maggiori quattro protocolli di rete per trasferire i dati: Local, Secure Shell (SSH), Git e HTTP. Qui vedremo cosa sono e in quali circostanze di base si vogliono (o non si vogliono) usare.

E' importante notare che, ad eccezione dei protocolli HTTP, tutti questi richiedono che Git sia installato e funzionante sul server.

### Il protocollo Local ###

Quello più semplice è il _protocollo locale_ (Local protocol), in cui il repository remoto è in un'altra directory sul disco. Questo è spesso utilizzato se ciascuno nel tuo team ha un accesso ad un file system condiviso come NFS, o nel caso meno probabile tutti accedano allo stesso computer. Quest'ultimo caso non è l'ideale, perché tutte le istanze del codice nel repository risiederebbero sullo stesso computer, facendo diventare molto più probabile una perdita catastrofica dei dati.

Se disponi di un filesystem montato in comune, allora si può clonare, fare un push e un pull da un repository locale basato su file. Per clonare un repository come questo o per aggiungerne uno da remoto per un progetto esistente, utilizza il percorso al repository come URL. Ad esempio, per clonare un repository locale, è possibile eseguire qualcosa di simile a questo:

	$ git clone /opt/git/project.git

O questo:

	$ git clone file:///opt/git/project.git

Git funziona in modo leggermente diverso se si specifica esplicitamente `file://` all'inizio dell'URL. Se si specifica il percorso, Git tenta di utilizzare gli hardlink o copia direttamente i file necessari. Se specifichi `file://`, Git abilita i processi che normalmente si usano per trasferire i dati su una rete che sono generalmente un metodo molto meno efficace per il trasferimento dei dati. La ragione principale per specificare il prefisso `file://`  è quella in cui si desidera una copia pulita del repository senza riferimenti od oggetti estranei — in genere dopo l'importazione da un altro sistema di controllo di versione o qualcosa di simile (vedi il Capitolo 9 relativo ai task per la manutenzione). Qui useremo il percorso normale, perché così facendo è quasi sempre più veloce.

Per aggiungere un repository locale a un progetto Git esistente, puoi eseguire qualcosa di simile a questo:

	$ git remote add local_proj /opt/git/project.git

Quindi, puoi fare eseguire i push e i pull da remoto come se si stesse lavorando su una rete.

#### I Pro ####

I pro dei repository basati su file sono che sono semplici e che utilizzano i permessi sui file e l'accesso alla rete già esistenti. Se hai già un filesystem condiviso a cui l'intero team ha accesso, la creazione di un repository è molto facile. Si mette la copia nuda del repository da qualche parte dove tutti hanno un accesso condiviso e si impostano i permessi di lettura/scrittura, come se si facesse per qualsiasi directory condivisa. Proprio per questo scopo vedremo come esportare una copia nuda del repository nella prossima sezione, "Installare Git su un server."

Questa è anche una interessante possibilità per recuperare rapidamente il lavoro dal repository di qualcun altro. Se tu e un tuo collega state lavorando allo stesso progetto e volete recuperare qualcosa da fuori, lanciare un comando tipo `git pull /home/john/project` è spesso più facile che inviare prima su un server remoto e poi scaricarlo.

#### I Contro ####

Il contro di questo metodo è che l'accesso condiviso è generalmente più difficile da impostare e da raggiungere da più postazioni rispetto ad un normale accesso di rete. Se vuoi fare un push dal computer quando sei a casa, devi montare il disco remoto, e può essere difficile e lento rispetto ad un accesso di rete.

E' anche importante ricordare che questa non è necessariamente l'opzione più veloce, se utilizzi un mount condiviso di qualche tipo. Un repository locale è veloce solo se si dispone di un accesso veloce ai dati. Un repository su NFS è spesso più lento di un repository via SSH sullo stesso server, permettendo a Git di andare con dischi locali su ogni sistema.

### Il protocollo SSH ###

Probabilmente il protocollo più utilizzato per Git è SSH. Questo perché un accesso via SSH ad un server è già impostato in molti posti — e se non c'è, è facile crearlo. SSH inoltre è l'unico protocollo di rete in cui puoi facilmente leggere e scrivere. Gli altri due protocolli (HTTP e Git) sono generalmente solo di lettura, quindi se li hai a disposizione per la massa, hai comunque bisogno di SSH per i tuoi comandi di scrittura. SSH è inoltre un protocollo di rete con autenticazione; e dato che è ubiquitario, è generalmente facile da configurare e usare.

Per clonare un repository Git via SSH, puoi specificare un URL ssh:// come questo:

	$ git clone ssh://user@server:project.git

O non specificare proprio il protocollo — Git utilizza SSH non lo specifichi:
	
	$ git clone user@server:project.git

Puoi anche non specificare l'utente, e Git utilizzerà l'utente con il quale sei ora connesso.

#### I Pro ####

I pro nell'usare SSH sono tanti. Primo, se vuoi avere un'autenticazione con l'accesso in scrittura al tuo repository su una rete devi usarlo. Secondo, SSH è relativamente semplice da impostare — il demone SSH è ovunque, molti amministratori di rete hanno esperienza con lui e molte distribuzioni di OS sono impostate con lui o hanno dei strumenti per amministrarlo. Poi, l'accesso via SSH è sicuro — tutti i dati trasferiti sono criptati ed autenticati. Infine, come i protocolli Git e Local, SSH è efficiente, rende i dati il più compressi possibili prima di trasferirli.

#### I contro ####

L'aspetto negativo di SSH è che non puoi dare accesso anonimo al tuo repository tramite lui. Le persone devono avere un accesso alla macchina tramite SSH, anche per la sola lettura, ciò rende SSH poco appetibile per i progetti open source. Se lo stai usando solo con la rete della tua azienda, SSH può essere l'unico protocollo con cui avrai a che fare. Se vuoi fornire un accesso anonimo di sola lettura al tuo progetto, devi impostare un SSH per i tuoi push ma qualcos'altro per per permettere ad altri di fare il pull.

### Il protocollo Git ###

Poi c'è il protocollo Git. Questo è un demone speciale che è incluso nel pacchetto Git; è in ascolto su una porta dedicata (9418) e fornisce un servizio simile al protocollo SSH, ma assolutamente senza autenticazione. Per permettere ad un repository di essere servito tramite il protocollo Git, devi creare un file `git-export-daemon-ok` — il demone non serve il repository senza l'inserimento di questo file — altrimenti non ci sarebbe sicurezza. O il repository Git è disponibile per chiunque voglia copiarlo o altrimenti niente. Questo significa che generalmente non si fa il push tramite questo protocollo. Puoi abilitare l'accesso al push; ma data la mancanza di autenticazione, se abiliti l'accesso di scrittura, chiunque trovi su internet l'URL al progetto può fare il push. E' sufficiente dire che questo è raro.

#### I pro ####

Il protocollo Git è il protocollo disponibile più veloce. Se hai un grande traffico per un tuo progetto pubblico o hai un progetto molto grande che non richiede un'autenticazione per l'accesso in lettura, è esattamente quello che ciò che vorrai impostare per un demone Git per fornire il progetto. Usa lo stesso meccanismo di trasferimento dei dati del protocollo SSH ma senza criptazione e autenticazione.

#### I contro ####

Il rovescio della medaglia è che al protocollo Git manca l'autenticazione.  E' generalmente non desiderabile avere l'accesso al progetto solo tramite il protocollo Git. Generalmente, si utilizzano insieme un accesso SSH per gli sviluppatori che hanno permessi di scrittura e per tutti gli altri si usa l'accesso in sola lettura `git://`.
Inoltre è probabilmente il protocollo più difficile da configurare. Deve avviare un proprio demone, che è personale — vedremo le impostazioni nella sezione “Gitosis” di questo capitolo — richiede la configurazione di `xinetd` o simili, che non è una passeggiata. Inoltre richiede un accesso tramite il firewall alla porta 9418, che non è una porta standard che i firewall delle aziende permettono di usare. Un firewall di una grande azienda spesso blocca questa porta.

### Il protocollo HTTP/S ###

Infine abbiamo il protocollo HTTP. Il bello del protocollo HTTP o HTTPS è la semplicità nel configurarlo. Fondamentalmente, tutto quello che devi fare è mettere solo il repository Git sulla document root HTTP ed impostare uno specifico gancio `post-update` ed il gioco è fatto (vedi il Capitolo 7 per i dettagli sugli agganci Git). A questo punto, chiunque in grado di accedere al server web sotto cui hai messo il repository può clonare il repository. Per permettere l'accesso in lettura al repository via HTTP, fai una cosa simile:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Questo è quanto. L'aggancio `post-update` che è messo assieme a Git di default avvia il comando appropriato (`git update-server-info`) per far lavorare correttamente il prelievo e la clonazione HTTP. Questo comando è avviato quando lanci un push al tuo repository via SSH; poi, possono clonarlo con una cosa simile:

	$ git clone http://example.com/gitproject.git

In questo caso particolare, stiamo usando il path `/var/www/htdocs` che è comunemente presente nelle installazioni di Apache, ma puoi usare un qualsiasi altro server web — basta mettere la base del repository nella path. I dati di Git sono forniti come file statici (vedi Capitolo 9 per dettagli su come sono esattamente forniti).

E' anche possibile fare il push con Git via HTTP, la tecnica non è molto utilizzata e richiede di impostare un complesso WebDAV. Dato che è raramente utilizzato, non lo vedremo in questo libro. Se sei interessato nel fare il push tramite protocollo HTTP, puoi leggere qualcosa su come preparare un repository qui `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. Una cosa carina per fare il push con Git via HTTP è utilizzare un server WebDAV, senza alcune specifiche funzionalità di Git; così, puoi usare questa funzionalità se il tuo hosting web fornisce un supporto WebDAV per scrivere aggiornamenti al tuo sito web.

#### I pro ####

Il bello di usare il protocollo HTTP è che è facile da configurare. Con pochi comandi si può dare facilmente al mondo un accesso in lettura al tuo repository Git. Porta via solo pochi minuti. Inoltre il protocollo HTTP non richiede tante risorse al tuo server. Perché in genere è utilizzato un server statico HTTP per fornire i dati, un server Apache in media può servire migliaia di file al secondo — è difficile sovraccaricare anche un piccolo server.

Puoi anche fornire un accesso in sola lettura via HTTPS, il che significa che puoi criptare il contenuto trasferito; o puoi arrivare al punto di rendere un certificato SSL specifico per i client. Generalmente, se andrai a fare queste cose, è più facile usare una chiave SSH pubblica; ma potrebbe essere una soluzione migliore usare un certificato SSL firmato o un altro tipo di autenticazione HTTP per un accesso in lettura via HTTPS.

Un'altra cosa carina è che l'HTTP è un protocollo comunissimo che i firewall delle aziende in genere configurano per permettere il traffico tramite la sua porta.

#### I contro ####

L'altra faccia della medaglia nel fornire il tuo repository via HTTP è che è relativamente inefficiente per il client. In genere porta via molto tempo per clonare o scaricare dal repository, e si ha spesso un sovraccarico della rete tramite il trasferimento di volumi via HTTP rispetto ad altri protocolli di rete. Perché abbastanza intelligente come trasferire solo i dati di cui hai bisogno — non c'è un lavoro dinamico dalla parte del server in questa transazione — il protocollo HTTP viene a volte chiamato protocollo _dumb_. Per maggiori informazioni sulle differenze nell'efficienza tra il protocollo HTTP e gli altri, vedi il Capitolo 9.

## Avere Git su un Server ##

Per inizializzare un qualsiasi server Git, devi esportare un repository esistente in un nuovo repository di soli dati — cioè un repository che non contiene la directory di lavoro. Questo è generalmente molto semplice da fare.
Per clonare il tuo repository per creare un nuovo repository di soli dati, devi avviare il comando clone con l'opzione `--bare`. Convenzionalmente, un repository di soli dati in finisce in `.git`, ad esempio:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

L'output di questo comando confonde un pochino. Fondamentalmente `clone` è un `git init` e non un `git fetch`, abbiamo visto alcuni output nella parte su `git init` nel creare una directory vuota. L'oggetto attuale di trasferimento non da output, ma funziona. Ora dovresti avere una copia della directory dei dati di Git nella directory `my_project.git`.

La stessa cosa la si può ottenere con

	$ cp -Rf my_project/.git my_project.git

Ci sono solo poche differenze nel file di configurazione; ma per tua conoscenza, questo copia le stesse cose. Lui prende il repository Git da solo, senza la directory di lavoro e crea una directory specifica per i soli dati.

### Mettere il repository di soli dati su un server ###

Ora che hai la copia dei soli dati del tuo repository, tutto quello che devi fare è mettere su un server e configurare il protocollo. Diciamo che hai impostato un server chiamato `git.example.com` su cui hai anche un accesso SSH e vuoi salvare tutti i tuoi repository Git nella directory `/opt/git`. Puoi impostare il tuo nuovo repository copiandoci sopra i dati del repository:

	$ scp -r my_project.git user@git.example.com:/opt/git

A questo punto, gli altri utenti che hanno un accesso SSH allo stesso server con i permessi di sola lettura nella directory `/opt/git` possono clonare il repository lanciando

	$ git clone user@git.example.com:/opt/git/my_project.git

Se gli utenti che entrano in SSH su un server e hanno l'accesso in scrittura alla directory `/opt/git/my_project.git`, avranno automaticamente la possibilità di inviare push. Git automaticamente aggiungere i permessi di scrittura al gruppo al repository se darai il comando `git init` con l'opzione `--shared`.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Hai visto quanto è semplice creare un repository Git, creare una versione di soli dati e posizionarlo su un server dove tu e i tuoi collaboratori avete un accesso SSH. Ora siete pronti per collaborare sullo stesso progetto.

E' importante notare che questo è letteralmente tutto ciò di cui hai bisogno per avviare un server Git dove vari utenti hanno accesso — semplicemente aggiungi un account SSH sul server e metti un repository di dati da qualche parte dove i tuoi utenti hanno un accesso in lettura e anche in scrittura. Sei pronto per procedere — non hai bisogno di niente altro.

Nella prossima sezione, vedrai come espandere un'installazione più sofisticata. Questa discussione includerà non solo la creazione di account utenti per ogni utente, l'aggiunta di un accesso in lettura pubblico ai repository, configurare delle interfaccie web, usare Gitosis ma molto altro. Comunque, tieni in mente che per collaborare con altre persone su un progetto privato, tutto quello di cui hai bisogno è un server SSH e i dati del repository.

### Configurazione base ###

Se hai poche risorse stai provando Git nella tua organizzazione e hai pochi utenti, le cose sono semplici. Una delle cose più complicate di configurazione di un server Git è l'amministrazione degli utenti. Se vuoi alcuni repositori in sola lettura per alcuni utenti e l'accesso in lettura e scrittura per altri, accessi e permessi possono essere un po' complicati da configurare.

#### Accesso SSH ####

Se hai già un server dove tutti i tuoi sviluppatori hanno un accesso SSH, è generalmente facile impostare qui il tuo primo repository, perché la gran parte del lavoro è già stato fatto (come abbiamo visto nell'ultima sezione). Se vuoi un controllo sugli accessi e suoi permessi più articolato sul tuo repository, puoi ottenerli con i normali permessi del filesystem del sistema operativo del server che stai utilizzando.

Se vuoi mettere il tuo repository su un server che non ha account per ciascun utente del tuo team e vuoi l'accesso in scrittura per alcuni, allora devi impostare un accesso SSH. Se assumiamo che già hai un server che fa questo, hai già un server SSH installato, questo diventerà il sistema di accesso.

Ci sono vari modi con cui puoi dare accesso a tutto il tuo team. Il primo è impostare degli account per ognuno, è semplice ma porta via molto tempo. Probabilmente non hai voglia di lanciare `adduser` ed impostare una password temporanea per ciascun utente.

Un secondo metodo è creare un singolo utente 'git' sulla macchina, chiedendo a ciascun utente che deve avere l'accesso in scrittura di inviarti la loro chiave pubblica SSH e dunque aggiungere questa chiave nel file `~/.ssh/authorized_keys` del tuo nuovo utente 'git'. A questo punto, tutti hanno la possibilità di accedere alla macchina tramite l'utente 'git'. Questo non tocca in alcun modo i commit dei dati — l'utente SSH che si connette non modifica i commit che sono già stati registrati.

Un altro modo è avere un'autenticazione al tuo server SSH via server LDAP o un altro sistema centralizzato di autenticazione che hai già configurato. Così ogni utente può avere un accesso shell sulla macchina, qualsiasi meccanismo di autenticazione SSH a cui puoi pensare dovrebbe funzionare.

## Generare la propria chiave pubblica SSH ##

Come detto precedentemente, molti server Git usano l'autenticazione con la chiave pubblica SSH. Per poter avere una chiave pubblica, ogni utente del tuo sistema deve generarne una se già non la possiede. Questo processo è simile per tutti i sistemi operativi.
Primo, devi controllare di non avere già una chiave. Di base, le chiavi SSH degli utenti sono salvate nella directory `~/.ssh`. Puoi facilmente controllare spostandoti nella directory e controllandone il contenuto:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Devi cercare una coppia di chiavi dal nome simile a qualcosa e qualcosa.pub, dove quel qualcosa in genere è `id_dsa` o `id_rsa`. Il file `.pub` è la tua chiave pubblica e l'altro file è la chiave privata. Se non hai questi file (o non hai una directory `.ssh`), puoi crearle avviando un programma chiamato `ssh-keygen`, che è fornito assieme al pacchetto SSH sui sistemi Linux/Mac ed è fornito dal pacchetto MSysGit su Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Prima chiede la conferma dove vuoi salvare la chiave (`.ssh/id_rsa`) e poi chiede due volte la passphrase, che puoi lasciare vuota se non vuoi inserire una password quando usi la chiave.

Ora, ogni utente che ha fatto questo deve inviare la propria chiave pubblica a te o a chi amministra il server Git (assumiamo che tu stai usando un server SSH impostato in modo da richiedere le chiavi pubbliche). Tutto quello che devono fare è copiare il contenuto del file `.pub` ed inviarlo via e-mail. La chiave pubblica è qualcosa di simile a questo:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Per una guida più specifica sulla creazione di una chiave SSH su sistemi operativi multipli, vedi la guida GitHub sulle chiavi SSH `http://github.com/guides/providing-your-ssh-key`.

## Configurare il server ##

Ora vediamo come configurare un accesso SSH lato server. In questo esempio, utilizzeremo il metodo `authorized_keys` per autenticare gli utenti. Assumiamo anche che stai utilizzando una distribuzione standard di Linux come Ubuntu. Prima, crea un utente 'git' e una directory `.ssh` per questo utente.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Poi, devi aggiungere alcune chiavi SSH pubbliche degli sviluppatori nel file `authorized_keys` di questo utente. Diciamo che hai ricevuto un po' di chiavi via email e le hai salvate in file temporanei. Ricorda che le chiavi pubbliche assomigliano a qualcosa tipo:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Devi solo aggiungerle al tuo file `authorized_keys`:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Ora, puoi impostare un repository vuoto avviando `git init` con l'opzione `--bare`, che inizializza il repository senza la directory di lavoro:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Poi, John, Josie o Jessica possono inviare la prima versione del loro progetto nel repository aggiungendolo come ramo remoto e di push. Nota che qualcuno deve accedere via shell alla macchina e creare un repository base ogni volta che si vuole aggiungere un progetto. Usiamo il nome `gitserver` per il server dove hai impostato il tuo utente 'git' ed il repository. Se lo stai usando nella rete interna e hai impostato un DNS con il punto `gitserver` per puntare a questo server, allora puoi usare il comando:

	# sul computer di Johns
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

A questo punto, gli altri possono clonare e fare i push dei cambiamenti molto facilmente:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Con questo metodo puoi avere velocemente un server Git con permessi di lettura e scrittura che serve molti sviluppatori.

Una precauzione extra, puoi restringere facilmente l'utente 'git' alle sole attività Git con uno strumento shell di limitazione chiamato `git-shell` che è fornito con Git. Se lo imposti come login shell per il tuo utente 'git', allora l'utente 'git' non avrà un accesso shell normale al tuo server. Per fare questo, specifica `git-shell` invece di bash o csh per il login shell del tuo utente. Per farlo, devi modificare il tuo file `/etc/passwd`:

	$ sudo vim /etc/passwd

Alla fine dovresti trovare una linea simile a questa:

	git:x:1000:1000::/home/git:/bin/sh

Modifica `/bin/sh` in `/usr/bin/git-shell` (o lancia `which git-shell` per vedere dove è installato). La linea deve assomigliare a:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Ora, l'utente 'git' può solamente usare la connessione SSH per inviare e scaricare i repository Git e non può accedere all shell della macchina. Se provi vedrai il rigetto dell'autenticazione:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Accesso pubblico ##

E se vuoi un accesso in lettura anonimo al tuo progetto? Probabilmente invece di ospitare un progetto privato interno, vuoi ospitare un progetto open source. O magari hai un gruppo di server automatizzati o server in continua integrazione che cambiano, e non vuoi generare chiavi SSH tutte le volte — vuoi solamente dare un semplice accesso anonimo in lettura.

Probabilmente il modo più semplice per una piccola installazione è avviare un server web statico con il suo document root dove si trovano i repository Git, e poi abilitare l'ancora `post-update` che abbiamo visto nella prima sezione di questo capitolo. Partiamo dall'esempio precedente. Diciamo che hai i tuoi repository nella directory `/opt/git`, ed un server Apache sulla macchina. Ancora, puoi usare un qualsiasi server web per questo; ma come esempio, vediamo alcune configurazioni basi di Apache che ti dovrebbero dare una idea di cosa hai bisogno.

Prima devi abilitare l'ancora:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Se stai usando una versione di Git precedente alla 1.6, il comando `mv` non è necessario — Git ha iniziato a nominare gli esempi di ancore solo recentemente con l'estensione .sample.

Cosa fa quest'ancora `post-update`? Fondamentalmente una cosa del genere:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Questo significa che quando fai un push al server via SSH, Git automaticamente avvia questo comando per aggiornare i file necessari per essere scaricati via HTTP.

Poi, hai bisogno di aggiungere una voce VirtualHost alla configurazione del tuo Apache con la document root che è la directory dei tuoi progetti Git. Qui, assumiamo che hai un DNS asteriscato impostato per inviare `*.gitserver` ad ogni box che stai usando:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Devi inoltre impostare il gruppo utente Unix alle directory `/opt/git` in `www-data` così il tuo server web può avere un accesso di lettura ai repository, perché l'istanza Apache lancia lo script CGI (di default) quando è eseguito come questo utente:

	$ chgrp -R www-data /opt/git

Quando riavvii Apache, dovresti essere in grado di clonare i tuoi repository presenti in questa directory specificando l'URL del tuo progetto:

	$ git clone http://git.gitserver/project.git

In questo modo, puoi impostare  in pochi minuti un accesso in lettura HTTP per ogni progetto per un numero indefinito di utenti. Un'altra opzione semplice per un accesso pubblico senza autenticazione è avviare un demone Git, ovviamente questo richiede l'avvio di un processo - vedremo questa opzione nelle prossime sezioni, se preferisci questa cosa.

## GitWeb ##

Ora che hai un accesso base in lettura e scrittura e sola lettura al tuo progetto, puoi configurare un visualizzatore web base. Git è rilasciato con uno script CGI chiamato GitWeb che è comunemente utilizzato per questo. Puoi vedere GitWeb in uso su siti come `http://git.kernel.org` (vedi Figura 4-1).

Insert 18333fig0401.png 
Figura 4-1. Interfaccia web di GitWeb.

Se vuoi verificare come GitWeb presenta il tuo progetto, Git è dotato di un comando per avviare un'istanza temporanea se hai un server leggero sul sistema come `lighttpd` o `webrick`. Su macchine Linux, `lighttpd` è spesso installato, quindi dovresti essere in grado di farlo funzionare con `git instaweb` nella directory del progetto. Se stai usando un Mac, Leopard viene fornito con preinstallato Ruby, così `webrick` è la soluzione migliore. Per avviare `instaweb` senza un server lighttpd, lo puoi lanciare con l'opzione `--httpd`.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Questo avvia un server HTTPD sulla porta 1234 e automaticamente avvia un browser web che apre questa pagina. E' davvero molto semplice. Quando hai fatto e vuoi chiudere il server, puoi usare lo stesso comando con l'opzione `--stop`:

	$ git instaweb --httpd=webrick --stop

Se vuoi lanciare l'interfaccia web continua sul tuo server per il tuo team o per un progetto open source devi fare hosting, avrai bisogno di impostare lo script CGI per essere servito dal tuo normale server web. Alcune distribuzioni Linux hanno un pacchetto `gitweb` che probabilmente sei in grado di installare via `apt` o `yum`, così potrai provare questo prima. Ora vedremo molto velocemente come installare manualmente GitWeb. Prima, hai bisogno di ottenere il codice sorgente di Git, in cui è presente GitWeb, e generare uno script CGI personalizzato:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Nota che devi dire al comando dove trovare i tuoi repository Git con la variabile `GITWEB_PROJECTROOT`. Ora hai bisogno di impostare Apache per usare il CGI per questo script, aggiungendo un VirtualHost:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

Ancora, GitWeb può essere utilizzato con qualsiasi server web che supporta CGI; se preferisci usare qualcos'altro, non dovresti avere difficoltà nella configurazione. A questo punto, dovresti essere ingrado di vedere in `http://gitserver/` i tui repository online, e puoi usare `http://git.gitserver/` per clonare e controllare i tuoi repository via HTTP.

## Gitosis ##

Mantenere tutte le chiavi pubbliche degli utenti nel file `authorized_keys` funziona bene per un pochino. Quando hai centinaia di utenti, è molto più difficile amministrare questo processo. Devi collegarti al server ogni volta, e non c'è un controllo degli accessi — ognuno nei file ha un accesso in lettura e scrittura ad ogni progetto.

A questo punto, potresti voler passare ad un software maggiormente utilizzato chiamato Gitosis. Gitosis è fondamentalmente una serie di script che aiutano ad amministrare il file `authorized_keys` esattamente come implementare un sistema di controllo degli accessi. La parte davvero interessante è che l'UI di questo strumento per aggiungere utenti e determinare gli accessi non è un'interfaccia web ma uno speciale repository Git. Puoi impostare le informazioni in questo progetto; e poi inviarle, Gitosis riconfigura il server basandosi su di esse, è fantastico.

Installare Gitosis non è un'operazione proprio semplice, ma non è così tanto difficile. E' facilissimo usarlo su un server Linux — questo esempio usa un server Ubuntu 8.10.

Gitosis richiede alcuni strumenti Python, così prima devi installare i pacchetti di setup Python, che Ubuntu fornisce tramite python-setuptools:

	$ apt-get install python-setuptools

Poi, puoi clonare ed installare Gitosis dal progetto principale:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Questo installerà una serie di eseguibili che Gitosis utilizzerà. Poi, Gitosis vuole i suoi repository in `/home/git`, che va bene. Ma hai già impostato i tuoi repository in `/opt/git`, così invece di riconfigurare tutto, puoi creare un link simbolico:

	$ ln -s /opt/git /home/git/repositories

Gitosis amministrerà le chiavi per te, così dovrai rimuovere il file corrente, ri-aggiungere le chiavi successivamente e permettere a Gitosis il controllo automatico del file `authorized_keys`. Per ora, spostiamo `authorized_keys` così:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Poi devi reimpostare la shell del tuo utente 'git', se l'hai cambiato con il comandi `git-shell`. Le persone non sono ora in grado di fare il login, ma Gitosis controllerà questa cosa per te. Così, modifica questa linea nel tuo file `/etc/passwd`

	git:x:1000:1000::/home/git:/usr/bin/git-shell

in questa:

	git:x:1000:1000::/home/git:/bin/sh

Ora è tempo di inizializzare Gitosis. Puoi farlo avviando il comando `gitosis-init` con la tua chiave pubblica personale. Se la tua chiave pubblica non è sul server, devi copiarla:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Questo permetterà all'utente con questa chiave di modificare il repository Git principale che controlla la configurazione di Gitosis. Poi, devi manualmente impostare il bit di esecuzione nello script `post-update` per il tuo nuovo repository di controllo.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Sei pronto per partire. Se hai configurato correttamente, puoi provare ad entrare via SSH nel tuo server come utente che ha aggiunto la chiave pubblica iniziale in Gitosis. Dovresti vedere qualcosa di simile a:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Questo significa che Gitosis ti riconosce ma ti butta fuori perché stai cercando di fare un qualcosa che non è un comando Git. Allora, diamo un comando Git — cloniamo il repository di controllo Gitosis:

	# sul tuo computer locale
	$ git clone git@gitserver:gitosis-admin.git

Ora hai una directory chiamata `gitosis-admin`, formata da due parti principali:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Il file `gitosis.conf` è il file di controllo in cui specifichi gli utenti, i repository e i permessi. La directory `keydir` è dove salvi le chiavi pubbliche di tutti gli utenti che hanno un qualsiasi accesso al repository — un file per utente. Il nome del file in `keydir` (dell'esempio precedente, `scott.pub`) è differente per te — Gitosis prende questo nome dalla descrizione alla fine della chiave pubblica che hai importato con lo script `gitosis-init`.

Se guardi nel file `gitosis.conf`, dovrebbe essere solo specificata l'informazione sul progetto `gitosis-admin` che hai già clonato:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Mostra che l'utente 'scott' — l'utente che ha inizializzato Gitosis con la sua chiave pubblica — è l'unico che ha l'accesso al progetto `gitosis-admin`.

Ora, aggiungiamo un nuovo progetto. Aggiungi una nuova sezione chiamata `mobile` dove elenchi gli sviluppatori del gruppo mobile ed i progetti in cui questi sviluppatori hanno bisogno dell'accesso. In quanto 'scott' è l'unico utente nel sistema al momento, aggiungerai solo lui come membro, creerai un nuovo progetto chiamato `iphone_project` su cui partire:

	[group mobile]
	writable = iphone_project
	members = scott

Ogni volta che fai una modifica al progetto `gitosis-admin`, devi fare un commit dei cambiamenti ed un push sul server in modo che abbiano effetto.

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

Puoi ora fare il tuo push al nuovo progetto `iphone_project` aggiungendo il tuo server come sorgente remota alla tua versione locale del progetto. Non hai bisogno di creare manualmente un repository base per nuovi progetti sul server — Gitosis li crea automaticamente quando vede il loro primo push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Nota che non devi specificare la path (infatti, se lo si fa non funziona), basta solamente la colonna e poi il nome del progetto — Gitosis farà il resto.

Se vuoi lavorare sul progetto con i tuoi amici, devi ri-aggiungere le chiavi pubbliche. Ma invece di aggiungerle manualmente nel file `~/.ssh/authorized_keys` sul server, le devi aggiungere, un file per volta, nella directory `keydir`. Come nomini queste chiavi determinerà come fai riferimento agli utenti nel file `gitosis.conf`. Ri-aggiungiamo le chiavi pubbliche per John, Josie e Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Ora puoi aggiungerli al tuo team 'mobile' così avranno accesso in lettura e scrittura a `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Dopo che hai fatto il commit ed il push delle modifiche, tutti e quattro gli utenti saranno in grado di leggere e scrivere nel progetto.

Gitosis ha un semplice controllo dell'accesso. Se vuoi che John abbia solo un accesso in lettura al progetto, devi fare così:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Ora John può clonare il progetto ed ottenere gli aggiornamenti, ma Gitosis non gli permetterà di inviarli al progetto. Puoi creare tutti i gruppi che vuoi, ognuno contiene gruppi di utenti e progetti differenti. Puoi anche specificare un altro gruppo con i membri di un altro (usando `@` come prefisso), per ereditarli automaticamente:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Se hai un qualsiasi dubbio, può essere utile aggiungere `loglevel=DEBUG` nell sezione `[gitosis]`. Se hai perso l'accesso alla scrittura perché hai inviato una configurazione sbagliata, puoi risolvere la cosa manualmente sul server `/home/git/.gitosis.conf` — il file da dove Gitosis legge le informazioni. Un push al progetto prende il file `gitosis.conf` che hai appena inviato e lo posiziona li. Se modifichi questo file manualmente, rimarrà come lo hai lasciato fino al prossimo push andato a termine nel progetto `gitosis-admin`.

## Gitolite ##

Nota: l'ultima copia di questa sezione del libro ProGit è sempre disponibile nella [documentazione di gitolite][gldpg]. L'autore inoltre vuole modestamente far sapere che questa sezione è accurata e *può* (se non *deve*) essere usata per installare gitolite senza leggere altra documentazione, per necessità non è completa e non può sostituire completamente l'enorme quantità di documentazione che è fornita con gitolite.

[gldpg]: http://github.com/sitaramc/gitolite/blob/pu/doc/progit-article.mkd

Git ha iniziato a diventare davvero popolare nelle grandi aziende, che tendono ad avere alcune richieste in più in termini di accesso di controllo. Gitolite è stato inizialmente creato per venire incontro a queste richieste, ma è ugualmente utile nel mondo open source: il controllo degli accessi del Fedora Project al loro repository per la manutenzione dei pacchetti (sono più di 10,000!) usano gitolite e probabilmente è l'installazione più grande di gitolite esistente.

Gitolite permette di specificare non solo i permessi per un repository, ma anche per le branche o i tag di ogni repository. Così si può specificare che certe persone (o gruppi di persone) possono fare il push solo su alcune "refs" (rami o tag) ma non su altri.

### Installazione ###

Installare Gitolite è davvero molto semplice, anche se non hai letto tutta la documentazione con cui è rilasciato. Quello di cui hai bisogno è un account su un server Unix o simile; varie versioni di Linux e Solaris 10 sono state testate. Non hai bisogno di un accesso root, assumiamo git, perl ed un server ssh compatibile con openssh sono già installati. Nell'esempio di seguito, utilizzeremo l'account `gitolite` sull'host chiamato `gitserver`.

Gitolite è qualche cosa di inusuale rispetto ai conosciuti software "server" -- l'accesso è via ssh, e ogni userid sul server è potenzialmente un "host gitolite". Come risultato, c'è una idea di "installazione" software e poi la "configurazione" di un utente come "host gitolite".

Gitolite ha 4 metodi di installazione. Chi usa Fedora o Debian può ottenere un RPM o un DEB ed installare questi. Chi ha un accesso root può installarli manualmente. Con questi due metodi, qualsiasi utente sul sistema può diventare un "host gitolite".

Chi non ha un accesso root può installarlo con il suo userid. E alla fine, gitolite può essere installato avviando lo script *sulla postazione di lavoro*, da una shell bash. (Anche con la bash fornita con msysgit, se te lo stavi chiedendo.)

Descriviamo quest'ultimo metodo in questo articolo; per gli altri metodi vedi la documentazione.

Si inizia ottenendo una chiave pubblica per l'accesso al server, così puoi fare il login dalla tua postazione di lavoro sul server senza dover inserire password. Il seguente metodo funziona su Linux; per altri sistemi operativi dovresti farlo manualmente. Assumiamo che hai già una coppia di chiavi generata tramite `ssh-keygen`.

	$ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

Questo ti chiederà la password per il tuo account gitolite, e poi imposterà la tua chiave pubblica. Questo è **essenziale** per lo script di installazione, per cui controlla di poter avviare comandi senza dover inserire password:

	$ ssh gitolite@gitserver pwd
	/home/gitolite

Poi, clona Gitolite dal progetto principale e lancia lo script "easy install" (il terzo argomento è il tuo nome se vuoi che appaia nel tuo repository gitolite-admin):

	$ git clone git://github.com/sitaramc/gitolite
	$ cd gitolite/src
	$ ./gl-easy-install -q gitolite gitserver sitaram

E ora è tutto fatto! Gitolite è installato sul server, e ora hai un nuovo repository chiamato `gitolite-admin` nella home directory della tua postazione di lavoro. Sei controllare le impostazioni di gitolite facendo cambiamenti al repository ed poi inviandole con il push.

L'ultimo comando produce una serie di output, che sono interessanti da leggere. Inoltre, la prima volta che lo lanci, una nuova coppia di chiavi è creata; devi scegliere una passphrase o non inserire niente. Il perché una seconda coppia di chiavi è necessaria, è spiegato nella documentazione "ssh troubleshooting" fornita con Gitolite. (Hey la documentazione serve per *per qualcosa*!)

I repo chiamati `gitolite-admin` e `testing` sono creati sul server di default. Se vuoi clonarli entrambi (da un account che ha un accesso alla console SSH all'account gitolite via *authorized_keys*), digita:

	$ git clone gitolite:gitolite-admin
	$ git clone gitolite:testing
	
Per clonare gli stessi repo da un altro account:

	$ git clone gitolite@servername:gitolite-admin
	$ git clone gitolite@servername:testing


### Personalizzare l'installazione ###

Mentre di base, l'installazione veloce va bene per la maggior parte delle persone, ci sono alcuni modi per personalizzare l'installazione se ne hai bisogno. Se ometti l'argomento `-q`, farai l'installazione in modalità "verbosa" -- informazioni dettagliate su come procede l'installazione ad ogni passaggio. La modalità verbosa inoltre ti permette di cambiare certi parametri lato server, come la posizione dei repository attuali, modificando un file "rc" che il server usa. Questo file "rc" è ben commentato così dovresti essere in grado di fare qualsiasi modifica di cui hai bisogno, salvalo e continua. Questo file inoltre contiene varie impostazioni che puoi modificare per abilitare o disabilitare qualche funzionalità avanzata di gitolite.

### File di configurazione e regole per il controllo dell'accesso ###

Una volta che l'installazione è fatta, puoi spostarti nel repository `gitolite-admin` (posizionato nella tua directory HOME) e girarti intorno per vedere cosa c'è:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/sitaram.pub
	$ cat conf/gitolite.conf
	#gitolite conf
	# please see conf/example.conf for details on syntax and features

	repo gitolite-admin
	    RW+                 = sitaram

	repo testing
	    RW+                 = @all

Nota che "sitearam" (l'ultimo argomento del comando `gl-easy-install` dato priam) ha i permessi in lettura e scrittura sul repository `gitolite-admin` esattamente come il file della chiave pubblica con lo stesso nome.

La sintassi del file di configurazione per gitolite è ben documentato in `conf/example.conf`, così citiamo solo alcune cose importanti qui.

Puoi raggruppare utenti o i repo per convenienza. Il nome del gruppo è come una macro; quando le definisci, non importa nemmeno se sono progetti o utenti; la distinzione è fatta solamente quando tu *usi* la "macro".

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott     # Adams, not Chacon, sorry :)
	@interns        = ashok     # get the spelling right, Scott!
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

Puoi controllare i permessi del livello "ref". Nel seguente esempio, gli interni possono solo fare il push al ramo "int". Gli ingegneri possono fare il push ad ogni branca cha inizia con "eng-", e i tag che iniziano con "rc" e finiscono con un numero. E gli amministratori possono fare tutto (incluso il rewind) per ogni ref.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

L'espressione dopo `RW` o `RW+` è una espressione regolare (regex) che il nome di riferimento (ref) che viene inviato è controllato nuovamente. Così la chiameremo "refex"! Certamente, una refex può essere più complessa di quella mostrata, quindi non strafare se non sei pratico con le regex perl.

Inoltre, come avrai supposto, i prefissi Gitolite `refs/heads/` sono convenienze sintattiche se la refex non inizia con `refs/`.

Una funzione importante nella sintassi di configurazione è che tutte le regole per un repository non necessariamente devono essere in un unico posto. Puoi tenere tutte le regole comuni insieme, come le regole per tutti `oss_repos` mostrati di seguito, e poi aggiungere specifiche regole per specifici casi successivamente, come segue:

	repo gitolite
	    RW+                     = sitaram

Questa regola è già stata aggiunta nella serie delle regole per il repository `gitolite`.

A questo punto sarai meravigliato nel vedere come le regole di controllo degli accessi sono impostate, le vediamo brevemente.

Ci sono due livelli di controllo degli accessi in gitolite. Il primo è a livello di repository; se hai un accesso in lettora (o scrittura) a *qualsiasi* ref del repository, allora hai accesso in lettura (o scrittura) al repository.

Il secondo livello, applica gli accessi di sola "scrittura", è per i rami o i tag del repository. Il nome utente, il cui accesso è tentato (`W` o `+`), e il refname in fase di aggiornamento è noto. Le regole dell'accesso sono impostate in ordine di apparizione nel file di configurazione, per cercare un controllo per questa combinazione (ma ricorda che il refname è una espressione regolare, non una semplice stringa). Se un controllo è stato trovato, il push avviene. Tutto il resto non ha alcun tipo di accesso.

### Controllo avanzato degli accessi con le regole "deny" ###

Finora abbiamo visto solo i permessi essere `R`, `RW` o`RW+`. Ovviamente, gitolite permette altri permessi: `-`, che sta per "deny". Questo ti da molto più potere, a scapito di una certa complessità, perché non è l'*unico* modo per negare l'accesso, quindi *l'ordine delle regole ora torna*!

Diciamo, nella situazione seguente, vogliamo gli ingegneri in grado di fare il rewind di ogni branca *eccetto* master ed integ. Qui vediamo come:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Ancora, devi semplicemente seguire le regole da cima a fondo fino a quando non inserisci una corrispondenza per il tipo di accesso, o di negazione. Un push non-rewind non corrisponde alla prima regola, scende alla seconda, ed è quindi negato. Qualsiasi push (rewind o non-rewind) ad un refs diverso da master o integ non corrisponde alle prime due regole comunque, e la terza regola lo permette.

### Push ristretti dalla modifica dei file ###

In aggiunta alle restrizioni per il push a specifici rami, puoi restringere ulteriormente a quali file sono permesse le modifiche. Per esempio, probabilmente il Makefile (o altri programmi) non dovrebbe essere modificato da nessuno, perché molte cose dipende da esso e potrebbero esserci problemi se le modifiche non sono fatte *correttamente*. Puoi dire a gitolite:

    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

Questa funzione molto potente è documentata in `conf/example.conf`.

### Rami personali ###

Gitolite ha anche una funzionalità che è chiamata "personal banches" (rami personalizzati, o anche "personal branch namespace") che è molto utile in un ambiente aziendale.

Moltissimo codice nel mondo git è scambiato per mezzo di richieste "please pull". In un ambiente aziendale, comunque, un accesso non autenticato è un no-no, e una macchina di sviluppo non può fare autenticazioni, così devi inviare al server centrale e poi chiedere a qualcuno di scaricarsi le modifiche.

Questo normalmente causa lo stesso disordine nel ramo come in un VCS centralizzato, oltre ad impostare le autorizzazioni di routine per l'amministratore.

Gitolite ti permette di definire un namespace di prefisso "personale" e "nuovo" per ogni sviluppatore (per esempio, `refs/personal/<devname>/*`); vedi la sezione "personal branches" in `doc/3-faq-tips-etc.mkd` per i dettagli.

### repository "wildcard" ###

Gitolite ti permette di specificare repository con il wildcard (attualmente espressioni regolari perl), come, per esempio `assignments/s[0-9][0-9]/a[0-9][0-9]`, per prendere un esempio casuale. Questa p una funzione *molto* potente, che è stata abilitata impostando `$GL_WILDREPOS = 1;` nel file rc. Ti permette di assegnare un nuovo modo di permesso ("C") per permettere agli utenti di creare repository basati su questo pattern, assegnando automaticamente il proprietario allo specifico utente che lo ha creato, permettendogli di prendere mano ai permessi di R e RW per gli altri utenti di collaborazione, etc. Questa funzionalità è documentata in `doc/4-wildcard-repositories.mkd`.

### Altre funzionalità ###

Concludiamo questa discussione con un elenco di altre funzioni, ognuna delle quali, e molte altre, sono descritte molto bene nelle "faq, suggerimenti, ecc" e altra documentazione.

**Logging**: Gitolite fa il log di tutti gli accessi riusciti. Se hai dato tranquillamente il permesso di rewind (`RW+`) alle persone qualcuno ha spazzato via il "master", il log è un salvavita per ritrovare lo SHA di chi ha fatto il casino.

**Git al di fuori del PATH normale**: Un'altra funzionalità estremamente utile in gitolite è supportare l'installazione di git al di fuori del normale `$PATH` (questo è molto più comune di quanto tu possa pensare; alcune aziende o alcuni fornitori di servizio rifiutano di installarlo a livello di sistema e devi metterlo nelle tue directory). Normalmente, sei spinto ad utilizzare git nel *lato client* invece di questa localizzazione non standard dei binari git. Con gitolite, semplicemente scegli l'installazione verbosa ed imposta il `$GIT_PATH` nei file "rc". Nessuna modifica lato client è necessaria per questo :-)

**Diritti di accesso riportati**: Un'altra funzione conveniente è quando provi ad entrare via ssh sul server. Gitolite ti mostrerà a quali repo hai accesso, e che tipo di accesso hai. Ecco un esempio:

        hello sitaram, the gitolite version here is v1.5.4-19-ga3397d4
        the gitolite config gives you the following access:
             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Delega**: Per un'istallazione davvero grande, puoi delegare la responsabilità di alcuni gruppi di repository a varie persone e dare a loro l'amministrazione di questi pezzi in modo indipendente. Questo riduce il carico dell'amministrazione centrale, ed elimina questo collo di bottiglia. Questa funzione ha la sua documentazione in un file nella directory `doc/`.

**Supporto gitweb**: Gitolite supporta il gitweb in vari modi. Puoi specificare quali repo sono visibili via gitweb. Puoi impostare il "proprietario" e la "descrizione" per gitweb dal file di configurazione di gitolite. Gitweb ha un meccanismo per implementare gli accessi basati sull'autenticazione HTTP, così puoi usare il file di configurazione "compilato" che gitolite produce, che significa lo stesso controllo degli accessi (per la lettura) applicati a gitweb e gitolite.

**Mirroring**: Gitolite può aiutarti a mantenere mirror multipli, e spostarti fra di loro facilmente se il server primario è caduto.

## Demone Git ##

Per un accesso pubblico, senza autenticazione al tuo progetto, puoi muoverti dal vecchio protocollo HTTP ed iniziare ad usare il protocollo Git. Il motivo principale è la velocità. Il protocollo Git è più efficiente e veloce del protocollo HTTP, quindi usarlo salverà tempo agli utenti.

Questo è solo per un accesso senza autenticazione in sola lettura. Se stai lo stai usando su un server al di fuori del tuo firewall, dovrebbe essere usato solamente per progetti che hanno una visibilità pubblica al mondo. Se il server che stai usando è all'interno del tuo firewall, lo puoi usare per i progetti con un gran numero di persone o computer (integrazione continua o sostituzioni server) con accesso in sola lettura, quando non vuoi aggiungere una chiave SSH a ciascuno.

In ogni caso, il protocollo Git è relativamente facile da impostare. Fondamentalmente, devi lanciare il comando in modo da renderlo un demone:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` permette al server di riavviarsi senza aspettare che la vecchia connessione concluda, l'opzione `--base-path` permette alle persone di clonare il progetto senza specificare l'intera path, e la path alla fine dice al demone Git dove cercare i repository da esportare. Se stai utilizzando un firewall, devi premettere l'accesso alla porta 9418 della macchina che hai configurato.

Puoi creare il demone di questo processo in vari modi, in dipendenza del sistema operativo che usi. Su una macchina Ubuntu, usa uno script Upstart. Così, nel seguente file

	/etc/event.d/local-git-daemon

devi mettere questo script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Per motivi di sicurezza, è strettamente raccomandato avere questo demone avviato come utente con permessi di sola lettura al repository — puoi farlo facilmente creando un nuovo utente 'git-ro' e lanciando il demone con questo. Per semplicità lo lanciamo con lo stesso utente 'git' che usa Gitosis.

Quando riavvi la macchina, il tuo demone Git inizierà automaticamente e si riavvierà se cade. Per averlo in funziona senza dover fare il reboot, puoi lanciare questo:

	initctl start local-git-daemon

su altri sistemi, potresti usare `xinetd`, uno script nel tuo sistema `sysvinit', o altro — insomma un comando che lancia il demone e lo controlla in qualche modo.

Poi, devi dire al tuo server Gitosis quali repository hanno un accesso al server Git senza autenticazione. Se aggiungi una sezione per ogni repository, puoi specificarla da quale demone Git è permessa la lettura. Se vuoi permettere un accesso al protocollo Git al progetto del tuo iphone, puoi aggiungere alla fine del file `gitosis.conf`:

	[repo iphone_project]
	daemon = yes

Quando questo è inviato, il tuo demone dovrebbe iniziare a servire le richieste per il progetto a chiunque abbia un accesso alla porta 9418 del tuo server.

Se decidi di non usare Gitosis, ma vuoi configurare un demone Git, devi avviare quanto segue su ogni singolo progetto che il demone Git deve servire:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

La presenza di questo file dice a Git che è OK per essere servito senza autenticazione.

Gitosis può inoltre controllare quali progetti mostrano GitWeb. Primo, devi aggiungere qualcosa al file `/etc/gitweb.conf`:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Puoi controllare quali progetti GitWeb possono essere visti dagli utenti via browser aggiungendo o rimuovendo impostazioni `gitweb` nel file di configurazione Gitosis. Per l'istanza, se vuoi che il progetto iphone sia visto con GitWeb, devi impostare il `repo` come segue:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Ora, se fai il commit ed il push del progetto, GitWeb automaticamente inizierà a far vedere il progetto iphone.

## Hosted Git ##

Se non vuoi svolgere tutto il lavoro di configurazione di un tuo server Git, hai varie opzioni per ospitare i tuoi progetti Git su un sito esterno e dedicato. Fare questo offre un numero di vantaggi: un sito di hosting è generalmente veloce da configurare ed è facile avviare un progetto su questo, e non sono necessari spese di mantenimento o controllo del server. Se imposti e avvi il tuo server interno, puoi comunque voler utilizzare un hosting pubblico per i progetti a codice aperto — è generalmente più facile per una comunità open source trovarti ed aiutarti.

In questi giorni, hai un'enorme quantità di opzioni di hosting tra cui scegliere, ognuna con differenti vantaggi e svantaggi. Per vedere una lista aggiornata, controlla la pagina GitHosting sul wiki principale di Git:

	http://git.or.cz/gitwiki/GitHosting

Dato che non possiamo vederli tutti, e dato che lavoro principalmente su uno di questi, in questa sezione vedremo come impostare un account e creare un nuovo progetto su GitHub. Questo ti darà una idea di come ti coinvolge.

GitHub è da molto tempo il più grande hosting Git di progetti open source ed è anche uno dei pochi che offre sia un hosting pubblico sia privato così puoi mantenere il tuo codice open source o il codice commerciale privato nello stesso posto. Infatti, infatti usiamo GitHub per collaborare a questo libro.

### GitHub ###

GitHub è molto differente nel namespace che usa per i progetti rispetto agli altri siti di hosting di codice. Invece di essere principalmente basato sul progetto, GitHub è utente centrico. Questo significa che quando metto il mio progetto `grit` su GitHub, non troverai `github.com/grit` ma invece lo trovi in `github.com/shacon/grit`. Non c'è una canonica versione di un progetto, ciò permette ad un progetto di essere mosso da un utente ad un altro senza soluzione di continuità se il primo autore abbandona il progetto.

GitHub è inoltre una organizzazione commerciale che carica gli account che mantengono repository privati, ma chiunque può avere un account libero per ospitare qualsiasi progetto open source come preferisce. Vedremo velocemente come ottenere questo.

### Impostare un account utente ###

La prima cosa di cui hai bisogno è impostare un account utente gratuito. Se visiti la pagina "Pricing and Signup" all'inidirizzo `http://github.com/plans` e fai click sul bottone "Sign Up" per un account gratuito (vedi figura 4-2), entrerai nella pagina di iscrizione.

Insert 18333fig0402.png
Figura 4-2. La pagina dei piani di GitHub.

Qui devi scegliere un nome utente che non è già stato scelto nel sistema ed inserire un indirizzo e-mail che verrà associato all'account e una password (vedi Figura 4-3).

Insert 18333fig0403.png 
Figura 4-3. Il form di iscrizione di GitHub.

Se ne hai una, è buona cosa aggiungere la propria chiave pubblica SSH. Abbiamo già visto come generare una nuova chiave, nella sezione "Impostazioni base". Prendi il contenuto della chiave pubblica della tua coppia di chiavi, ed incollala nel box SSH Public Key. Facendo click sul link "explain ssh keys" otterrai le istruzioni dettagliate su come fare questa cosa sui maggiori sistemi operativi.
Fai click sul bottone "I agree, sign me up" per vedere il tuo nuovo pannello utente (vedi Figura 4-4).

Insert 18333fig0404.png 
Figura 4-4. Pannello utente GitHub.

Poi puoi creare un nuovo repository.

### Creare un nuovo repository ###

Inizia facendo click sul link "create a new one" nel pannello del tuo utente. Vedrai il form per creare un nuovo repository (vedi Figura 4-5).

Insert 18333fig0405.png 
Figura 4-5. Creare un nuovo repository GitHub.

Tutto quello che devi fare è fornire un nome del progetto, ma puoi aggiungere anche una descrizione. Quando questo è fatto, fai click sul bottone "Create Repository". Ora hai un nuovo repository su GitHub (vedi Figura 4-6).

Insert 18333fig0406.png 
Figura 4-6. Informazioni del progetto su GitHub.

Se non hai ancora nessun codice, GitHub ti mostrerà le istruzione su come creare un nuovo progetto, inviare un progetto Git esistente, o importare un progetto da un altro repository Subversion pubblico (vedi Figura 4-7).

Insert 18333fig0407.png 
Figura 4-7. Istruzioni per un nuovo repository.

Queste istruzioni sono simili a quello che già avevamo fatto precedentemente. Per inizializzare un progetto se non è già un progetto Git, devi usare

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Quando hai un repository Git locale, aggiungi GitHub come remoto ed invia il tuo ramo master:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Ora il tuo progetto è ospitato su GitHub, e puoi fornire l'URL a chiunque tu voglia per condividere il progetto. In questo caso, è http://github.com/testinguser/iphone_project` . Puoi inoltre vedere dalla parte superiore di ogni pagina del progetto che hai due URL Git (vedi Figura 4-8).

Insert 18333fig0408.png 
Figura 4-8. Parte superiore del progetto con un URL pubblico ed uno URL privato.

L'URL per la clonazione pubblica è pubblico, è un URL Git di sola lettura con cui chiunque può clonare il progetto. Sentiti libero di dare questo URL ed inserirlo sul tuo sito web o dove preferisci.

Il tuo URL per la clonazione è basato su SSH ed è per la lettura e la scrittura e vuoi scriverci o leggerci solamente se ti sei connesso con la tua chiave SSH privata associata alla chiave pubblica che hai caricato per il tuo utente. Quando altri utenti visitano la pagina del tuo progetto, vedranno solamente l'URL pubblico.

### Importare da Subversion ###

Se hai un progetto pubblico esistente su Subversion che vuoi importare in Git, GitHub può farlo per te. Alla fine della pagina delle istruzioni c'è un link per l'importazione di un Subversion. Se fai click su di esso, vedrai un form con le informazioni per il processo di importazione ed un campo dove incollare l'URL del tuo progetto Subversion pubblico (vedi Figura 4-9).

Insert 18333fig0409.png 
Figura 4-9. Interfaccia importazione Subversion.

Se il tuo progetto è molto grande, non standard, o privato, questo processo probabilmente non funzionerà. Nel Capitolo 7, vedrai come fare importazioni più complicate manualmente.

### Aggiungere collaboratori ###

Aggiungiamo il resto del team. Se John, Joise e Jessica hanno sottoscritto un account su GitHub e vuoi dare loro un accesso per il push al tuo progetto, puoi aggiungerli al tuo progetto come collaboratori. Facendo questo gli dai il permesso di fare il push tramite le loro chiavi pubbliche.

Fai click sul bottone "edit" nella parte superiore della pagina del progetto o nel tab Admin all'inizio del progetto per vedere la pagina di Admin del tuo progetto GitHub (vedi Figura 4-10).

Insert 18333fig0410.png 
Figura 4-10. Pagina amministrazione GitHub.

Per dare ad un altro utente l'accesso in scrittura al tuo progetto, fai click sul link “Add another collaborator”. Un nuovo box di testo apparirà, in cui puoi inserire il nome utente. Quando scrivi, un pop up di aiuto, ti mostrerà i nomi utenti possibili. Quando hai trovato l'utente corretto, fai click sul bottone Add per aggiungerlo come collaboratore del progetto (vedi Figura 4-11).

Insert 18333fig0411.png 
Figura 4-11. Aggiungere un collaboratore al tuo progetto.

Quando hai finito di aggiungere collaboratori, dovresti vedere una lista di questi nel box dei collaboratori del repository (vedi Figura 4-12).

Insert 18333fig0412.png 
Figura 4-12. Una lista di collaboratori al tuo progetto.

Se hai bisogno di revocare l'accesso a qualcuno, puoi fare click sul link "revoke", ed il loro accesso al push è rimosso. Per progetti futuri, puoi anche copiare il gruppo dei collaboratori copiando i permessi di un progetto esistente.

### Il tuo progetto ###

Dopo che hai fatto il push del tuo progetto o hai fatto l'importazione da Subversion, hai la pagina del progetto principale che assomiglia alla Figura 4-13.

Insert 18333fig0413.png 
Figura 4-13. La pagina principale del progetto su GitHub.

Quando le persone visiteranno il tuo progetto, vedranno questa pagina. Essa contiene i tab per differenti aspetti del progetto. Il tab dei commit mostra una lista dei commit in ordine cronologico inversi, simile all'output del comando `git log`. Il tab network mostra tutte le persone che hanno eseguito il fork del progetto e hanno contribuito ad esso. Il tab download permette di caricare il binario del progetto e di avere il link alla versione tarball o zip di ogni punto del progetto con un tag. Il tab Wiki fornisce un wiki dove puoi scrivere la documentazione o altre informazioni sul progetto. Il tab grafico ha mostra alcuni contributi e statistiche sul progetto. Il tab sorgente è la pagina principale del progetto e visualizza la directory principale e automaticamente legge il file di README mostrandolo di sotto, se ne hai uno. Questo tab mostra anche le informazioni degli ultimi commit.

### Fare il fork dei progetti ###

Se vuoi contribuire ad un progetto esistente a cui non hai un accesso per il push, GitHub incoraggia il fork del progetto. Quando vai sulla pagina di un progetto che credi interessante e vuoi lavorarci un po' su, puoi fare click sul bottone "fork" nella parte superiore del progetto per avere una copia su GitHub nel tuo utente a cui puoi inviare le modifiche.

In questo modo, i progetti non devono preoccuparsi di aggiungere utenti come collaboratori per dare loro accesso come push. Le persone possono fare il fork del progetto e fare il push a questo, ed il progetto principale può scaricare questi cambiamenti aggiungendoli come sorgenti remote e fondendo il loro lavoro.

Per fare il fork di un progetto, visita la pagina del progetto (in questo caso, mojombo/chronic) e fai click sul bottone "fork" in alto (vedi Figura 4-14).

Insert 18333fig0414.png 
Figura 4-14. Ottenere una copia scrivibile di un qualsiasi repository facendo click sul bottone "fork".

Dopo qualche secondo, otterrai la pagina del tuo nuovo repository, che indica che questo progetto è un fork di un altro (vedi Figura 4-15).

Insert 18333fig0415.png 
Figura 4-15. Il tuo fork di un progetto.

### Riassunto GitHub ###

Questo è quanto su GitHub, ma è importante notare quanto è veloce fare tutto questo. Puoi creare un account, aggiungere un nuovo progetto, e inviare un push a questo in pochi minuti. Se il tuo progetto è open source, puoi avere un'ampia comunità di sviluppatori che possono vedere nel tuo progetto e fare un fork di questo ed aiutarti. Ed infine, questo è un modo per iniziare ad usare Git ed imparare ad usarlo velocemente.

## Riassunto ##

Hai varie opzioni per ottenere un repository Git e poter dunque collaborare con altri o condividere il tuo lavoro.

Utilizzare il proprio server ti permette di avere molto controllo e ti permette di avere un tuo firewall, ma un server del genere richiede un certa quantità del tuo tempo per essere impostato e mantenuto. Se metti i tuoi dati su un servizio di hosting, è facile da configurare e mantenere; comunque, puoi mantenere il tuo codice su altri server, e alcune aziende non lo permettono.

E' davvero molto difficile dire quale soluzione o combinazione di soluzione è davvero appropriata per te e la tua azienda.
