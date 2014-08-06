# Git e altri sistemi #

Il mondo non è perfetto. Normalmente non è possibile spostare ogni progetto con cui si ha a che fare su Git. A volte si è bloccati su un progetto che usa un altro VCS, la maggior parte delle volte Subversion. Nella prima parte di questo capitolo impareremo ad usare `git svn`, l'interfaccia bidirezionale di Subversion in Git.

In un certo momento potresti voler convertire un progetto esistente a Git. La seconda parte di questo capitolo spiega copre migrare il progetto a Git. Prima da Subversion, poi da Perforce e infine tramite uno script di importazione personalizzato per i casi non standard.

## Git e Subversion ##

Attualmente la maggior parte dei progetti di sviluppo open source e un gran numero di progetti aziendali usano Subversion per la gestione del loro codice sorgente. Subversion è il VCS open source più popolare ed è in uso da quasi un decennio. In molteplici aspetti è molto simile a CVS, che è stato lo strumento più usato per il controllo dei sorgenti prima di Subversion.

Una delle grandi caratteristiche di Git è il ponte bidirezionale per Subversion, chiamato `git svn`. Questo strumento consente di usare Git come client di un server Subversion, in modo da poter usare tutte le caratteristiche locale di Git e poi inviarle al server Subversion, come se si usasse Subversion localmente. Questo vuol dire che si possono fare branch e merge in locale, usare l'area di stage, usare il rebase e il cherry-pick, ecc. mentre gli altri collaboratori continuano a lavorare con i loro metodi oscuri e antichi. È un buon modo per introdurre Git in un ambiente aziendale e aiutare gli altri sviluppatori a diventare più efficienti, mentre si cerca di convincere l'azienda a cambiare l'infrastruttura per supportare pienamente Git. Il ponte per Subversion è la droga delle interfacce nel mondo dei DVCS.

### git svn ###

Il comando di base in Git per tutti i comandi del ponte per Subversion è `git svn` e basta usarlo come prefisso per ogni altro comando. Basteranno pochi  comandi durante i primi flussi di lavoro per imparare quelli più comuni.

È importante notare che, quando si usa `git svn`, si sta interagendo con Subversion, che è un sistema molto meno sofisticato di Git. Sebbene si possano fare facilmente branch e merge locali, in genere è meglio tenere la propria cronologia più lineare possibile, riorganizzando il proprio lavoro ed evitare di interagire contemporaneamente con un repository Git remoto.

Non provare a riscrivere la propria cronologia e fare di nuovo push, e non fare un push verso un repository Git parallelo per collaborare contemporaneamente con altri sviluppatori Git.
Subversion può avere solo una singola cronologia lineare e confonderlo è molto facile.
Se lavori in un gruppo in cui alcuni usano SVN e altri Git, assicurati che tutti usino il server SVN per collaborare, in modo da semplificarvi la vita.

### Impostazioni ###

Per dimostrare queste funzionalità, occorre un repository SVN a cui si abbia accesso in scrittura. Se vuoi riprodurre questi questi esempi, hai bisogno di una copia scrivibile del mio repository di test. Per farlo facilmente, puoi usare uno strumento chiamato `svnsync`, distribuito con le versioni recenti di Subversion, almeno dalla 1.4 in poi. Per questi test, ho creato su Google code un nuovo repository Subversion con la copia parziale del progetto `protobuf`, che è uno strumento di codifica di dati strutturati per trasmissioni di rete.

Per proseguire, occorre prima di tutto creare un nuovo repository Subversion locale:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Quindi, abilitare tutti gli utenti a cambiare revprops, il modo più facile è aggiungere uno script pre-revprop-change che restituisca sempre il codice "0":

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Si può ora sincronizzare questo progetto con la proprima macchina locale, usando `svnsync init` con i repository sorgente e destinazione.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

Questo definisce le proprietà per eseguire la sincronizzazione. Ora puoi fare un clone del codice, con i comandi seguenti:

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Sebbene questa operazione possa impiegare solo pochi minuti, se si prova a copiare il repository originale in un altro repository remoto, invece che su uno locale, il processo impiegherà quasi un'ora, anche se ci sono meno di 100 commit. Subversion deve fare il clone di una revisione alla volte e poi fare il push in un altro repository: è altamente inefficiente, ma è l'unico modo per farlo.

### Cominciare ###

Ora che si ha accesso a un repository Subversion, ci si può esercitare con un tipico flusso di lavoro. Si inizierà con il comando `git svn clone`, che importa un intero repository Subversion in un repository locale Git. Si ricordi che, se si sta importando da un vero repository Subversion, occorre sostituire `file:///tmp/test-svn` con l'URL del repository Subversion:

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

Questo esegue l'equivalente di due comandi, `git svn init` seguito da `git svn fetch`, con l'URL fornito. Potrebbe volerci un po' di tempo. Il progetto di test ha solo circa 75 commit e il codice non è così grossa, quindi servono solo pochi minuti. Tuttavia, Git deve fare checkout di ogni singola versione, una alla volta, e fare commit di ognuna di esse individualmente. Per un progetto con centinaia di migliaia di commit, potrebbero volerci delle ore o anche dei giorni per finire.

La parte `-T trunk -b branches -t tags` dice a Git che questo repository Subversion segue le convenzioni predefinite per branch e tag. Se si hanno nomi diversi per trunk, branches o tags, puoi cambiare queste opzioni. Essendo una configurazione molto comune, si può sostituire tutta questa parte con `-s`, che sta per standard e implica tutte le opzioni viste. Il comando seguente è equivalente:

	$ git svn clone file:///tmp/test-svn -s

A questo punto, si dovrebbe avere un repository Git valido, che ha importato i propri branch e tag:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

È importante notare come questo strumento introduca dei namespace remoti differenti. Quando si fa un normale clon di un repository Git, si prendono tutti i branch di quel server remoto disponibili locamente con qualcosa come `origin/[branch]`, con un namespace che dipende dal nome remoto. Tuttavia, `git svn` presume che non si vogliano avere remoti multipli e salva tutti i suoi riferimenti per puntare al server remoto senza namespace. Si può usare il comando `show-ref` per cercare tutti i nomi dei riferimenti:

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

Un tipico repository Git assomiglia di più a questo:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

dove ci sono due serer remoti: uno chiamato `gitserver` con un branch `master`, l'altro chiamato `origin` con due branch, `master` e `testing`. 

Si noti come, nell'esempio dei riferimenti remoti importati da `git svn`, i tag sono aggiunti come branch remoti, non come veri tag di Git. L'importazionoe da Subversion appare come se avesse dei tag remoti con nome, con dei branch all'interno.

### Commit verso Subversion ###

Ora che abbiamo un repository funzionante, possiamo lavorare un po' sul progetto e inviare le nostre commit, usando effettivamente Git come un client SVN. Se si modifica un file e si fa una commit, si ha una commit che esiste localmente in Git, ma non nel server Subversion:

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

Dobbiamo quindi inviare le modifiche. Nota come questo cambia il modo in cui lavoriamo con Subversion: si possono fare varie commmit offline e poi inviarle tutte insieme al server Subversion. Per inviarle al server Subversion, eseguiamo il comando `git svn dcommit`:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Il comando prende tutte le commit fatte ed esegue una commit verso Subversion per ciascuna di essi e quindi riscrive la commit locale di Git per includere un identificatore univoco. Questo è importante, perché vuol dire che tutti i checksum SHA-1 delle proprie commit cambiano. Anche per questa ragione, lavorare on versioni remote basate su Git dei propri progetti assieme con un server Subversion non è una buona idea. Se dai un'occhiata all'ultimo commit, vedrai il nuovo `git-svn-id` aggiunto:

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Si noti che il checksum SHA che originariamente iniziava con `97031e5`, ora inizia con `938b1a5`. Se vuoi inviare le tue commit sia a un server Git che a un server Subversion, occorre farlo prima al server Subversion (`dcommit`), perché questa azione cambia i dati di commit.

### Aggiornare ###

Se lavori con altri sviluppatori, ad un certo punto qualcuno di loro farà una push, e quando qualcun altro proverà a fare il push di una modifica, questa andrà in conflitto. Questa modifica sarà rigettata, finché non si fa un merge. Con `git svn`, sarà una cosa del genere:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Per risolvere questa situazione, puoi eseguire `git svn rebase`, che fa un pull dal server di ogni modifica che ancora non hai in locale e rimette ogni tua modifica su quello che c'è sul server:

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

Ora, tutto il proprio lavoro si basa sul server Subversion, quindi si può fare `dcommit` senza problemi:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

È importante ricordare che, diversamente da Git che richiede di fare un merge del lavoro remoto che non si ha ancora in locale prima di fare push, `git svn` consente di farlo solo se le modifiche sono in conflitto. Se qualcun altro fa il push di una modifica ad un file e poi si fa un push di una modifica ad un altro file, il proprio `dcommit` funzionerà:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

Questo è importante da ricordare, perché il risultato è uno stato del progetto che non esiste su nessun computer e, se le modifiche sono incompatibili ma non in conflitto, si possono avere problemi la cui origine è difficile da diagnosticare. Questo non succede quando si usaun server Git: in Git, si può testare completamente lo stato del progetto sulla propria macchina prima della pubblicazione, mentre in SVN non si può mai essere certi che lo stato immediatamente prima del commit e quello dopo siano identici.

Si dovrebbe eseguire sempre questo comando per fare pull delle modifiche dal server Subversion, anche se non si è pronti a fare commit. Si può eseguire `git svn fetch` per recuperare i nuovi dati, ma `git svn rebase` analizza e aggiorna i propri commit locali.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Eseguendo `git svn rebase` ogni tanto, assicura che il proprio codice sia sempre aggiornato. Tuttavia occorre assicurarsi che la propria cartella di lavoro sia pulita quando si esegue questo comando. Se si hanno modifiche locali, prima di eseguire `git svn rebase`, si deve mettere il proprio lavoro al sicuro o fare una commit temporanea o l'esecuzione si bloccherà se trova che il rebase creerà un conflitto nell'unione delle versioni.

### Problemi con i branch Git ###

Quando ci si trova a proprio agio con il flusso di lavoro di Git, probabilmente si vorranno creare dei branch, lavorare su di essi, quindi farne un merge. Se si sta facendo push verso un server Subversion tramite git svn, si potrebbe voler ribasare il proprio lavoro su un singolo branch di volta in volta, invece di fare il merge dei branch. La ragione per preferire il rebase è che Subversion ha una cronologia lineare e non tratta i merge nello stesso modo di Git, quindi 'git svn' segue solo il primo genitore, quando converte gli snapshot in commit di Subversion.

Ipotizziamo che la cronologia sia come la seguente: si è creato un branch `experiment`, e si sono fatte due commit e quindi un merge in `master`. Quando si esegue `dcommit`, si vedrà un output come questo:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

L'esecuzione di `dcommit` su un branch che ha una cronologia con dei merge funziona bene, ma quando si guarda nella cronologia del progetto Git, nessuno dei commit fatti sul branch `experiment` è stato eseguito; invece, tutte queste modifiche appaiono nella versione SVN del singolo commit di merge.

Quando qualcun altro clona questo lavoro, tutto quello che vedrà è il commit del merge con tutto il lavoro compresso ma non vedranno i dati delle singole commit né quando siano state eseguite.

### Branch Subversion ###

I branch in Subversion non sono la stessa cosa dei branch in Git; se si può evitare di usarli spesso è la cosa migliore. Si possono comunque creare branch e farne commit in Subversion usando git svn.

#### Creare un nuovo branch SVN ####

Per creare un nuovo branch in Subversion, eseguire `git svn branch [nome del branch]`:

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

Questo equivale al comando `svn copy trunk branches/opera` di Subversion e opera sul server Subversion. È importante notare che non esegue il check out in quel branch e se si fa commit a questo punto, il commit andrà nel `trunk` del server, non in `opera`.

### Cambiare il branch attivo ###

Git riesce a capire in quale branch vanno i propri dcommit, cercando informazioni in ognuno dei propri branch nella cronologia di Subversion: se ne dovrebbe avere solo uno, quello che abbia `git-svn-id` nella cronologia del ramo corrente.

Se si vuole lavorare contemporaneamente su più branch, si possono impostare i branch locali per fare `dcommit` su specifici rami di Subversion, facendoli iniziare dal commit di Subversion importato per quel branch. Se si vuole un branch `opera` su cui lavorare separatamente, si può eseguire

	$ git branch opera remotes/opera

Ora, se si vuole fare un merge del branch `opera` in `trunk` (il proprio branch `master`), si può farlo con un normale `git merge`. Ma si deve fornire un messaggio di commit descrittivo (usando `-m`) o il merge dirà solo "Merge branch opera", invece di qualcosa di più utile.

Si ricordi che, sebbene si usi `git merge` per eseguire questa operazione, il merge probabilmente sarà più facile di quanto sarebbe stato in Subversion perché Git individua automaticamente la base di merge appropriata: questo non è una normale commit di un merge di Git. Occorre fare il push di questi dati a un server Subversion che possa gestire una commit che tracci più di un genitore; quindi, dopo aver fatto push, sembrerà
un singolo commit che ha compresso tutto il lavoro di un altro branch in un singolo commit. Dopo aver fatto il merge di un branch in un altro, non sarà possibile tornare indietro e continuare a lavorare su quel branch come si farebbe normalmente in Git. Il comando `dcommit` che è stato eseguito cancella ogni informazione sui branch dai quali si è fatto il merge, quindi i calcoli successivi, basati sul merge, saranno sbagliati:
dcommit rende il risultato di `git merge` come se si fosse eseguito `git merge --squash`. Sfortunatamente, non c'è un buon modo per evitare tale situazione: Subversion non può memorizzare questa informazioni, quindi si resterà sempre danneggiati dalle sue limitazioni finché lo si userà come server. Per evitare problemi, si dovrebbe cancellare il branch locale (in questo caso, `opera`) dopo aver fatto il merge nel trunk.

### Comandi Subversion ###

Il comando `git svn` fornisce una serie di comandi per facilitare la transizione a Git fornendo funzionalità simili a quelle disponibili in Subversion. Di seguito ci sono alcuni comandi che permettono di fare quello che eri abituato a fare con Subversion.

#### Cronologia con lo stile di SVN ####

Se sei abituato a Subversion e vuoi continuare a vedere la cronologia con lo stile di SVN, puoi eseguire `git svn log`:

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines

	updated the changelog

Devi sapere due cose importanti su `git svn log`. La prima è che lavora offline e non ha bisogno di una connessione, a differenza del comando `svn log` che richiede le informazioni al server Subversion. E la seconda è che mostra solo le commit che sono state inviate al server Subversion. Non appaiono né le commit locali che non sono ancora state inviate con il comando dcommit né quelle che altri abbiano nel frattempo inviato al server Subversion. È come fare un confronto con l'ultimo stato conosciuto sul server Subversion.

#### Annotazioni SVN ####

Così come il comando `git svn log` simula offline il comando `svn log`, è disponibilie l'equivalente di `svn annotate` eseguendo `git svn blame [FILE]`. L'output sarà simile al seguente:

	$ git svn blame README.txt
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal
	79    schacon Committing in git-svn.
	78    schacon
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal

Anche in questo caso, il comando non mostra le commit locali di Git né quelle che nel frattempo siano state inviate al server Subversion da altri.

#### Informazioni sul server SVN ####

Puoi ottenere le infommazioni disponibili con `svn info` eseguendo `git svn info`:

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

Come per `blame` e `log`, le informazioni vengono ricercate offline e sono aggiornate all'ultima volta che si è comunicato con il server Subversion.

Suggerimento: Se il tuo script di compilazione deve poter eseguire `svn info` è meglio porre un wrapper attorno a git.
Qui c'è un esempio per i tuoi esperimenti:

    #!/usr/bin/env bash

    if git rev-parse --git-dir > /dev/null 2>&1 && [[ $1 == "info" ]] ; then
      git svn info
    else 
      /usr/local/bin/svn "$@"
    fi

#### Ignorare ciò che Subversion ignora ####

Se cloni un repository Subversion che abbia definito delle proprietà `svn:ignore`, vorrai avere un file `.gitignore` con le stesse proprietà per evitare di committare qualcosa che non dovresti. `git svn` ha due comandi per aiutarti a risolvere questo problema. Il primo, `git svn create-ignore`, crea automaticamente i file `.gitignore`, in modo che la committ successiva li includa.

Il secondo, `git svn show-ignore`, mostra nella console le righe che devi includere nei tuoi file `.gitignore`, così che puoi redirigere l'output nel file exclude del tuo progetto:

	$ git svn show-ignore > .git/info/exclude

In questo modo non riempirai il progetto con i file `.gitignore`. Questa è una buona opzione se sei l'unico utente Git in un gruppo Subversion e i tuoi compagni non vogliono i file `.gitignore` nel progetto.

### Sommario Git-Svn ###

`git svn` è utile se sei temporaneamente costretto ad usare un server Subversion o sei in un ambiente dove è necessario usare un server Subversion. Dovresti considerarlo un Git handicappato o potresti sperimentare dei problemi nella transizione che potrebbero confondere te e i tuoi collaboratori. Per evitare problemi dovresti seguire queste regole:

* Mantieni una cronologia di Git il più lineare possibile in modo che non contenga commit di `git merge`. Riporta all'interno della linea principale di sviluppo qualsiasi cosa che abbia fatto al di fuori, senza fare merge.
* Non configurare un server Git separato per collaborare con altre persone. Potresti averne uno per velocizzare i cloni per i nuovi sviluppatori, ma non fare il push di niente che non abbia un `git-svn-id`. Potresti definire un hook `pre-receive` che verifichi che ogni commit abbia un `git-svn-id` e rifiuti le push che non ne abbiano uno.

Se segui queste linee guide, lavorare con un server Subversion sarà più sostenibile. Se ti sarà possibile spostarvi su un server Git reale il tuo gruppo ne beneficerà notevolmente.

## Migrare a Git ##

Se hai un repository esistente con i tuoi sorgenti su un altro VCS ma hai deciso di iniziare a usare Git, devi migrare il tuo progetto. Questa sezione descrive prima alcuni strumenti inclusi in Git per i sistemi più comuni e poi spiega come sviluppare un tuo strumento personalizzato per l'importazione.

### Importare ###

Imparerai ad importare i dati dai due principali sistemi professionali di SCM (Subversion e Perforce) sia perché rappresentano la maggioranza dei sistemi da cui gli utenti stanno migrando a Git, sia per l'alta qualità degli strumenti distribuiti con Git per entrambi i sistemi.

### Subversion ###

Se hai letto la sezione precedente `git svn`, puoi facilmente usare quelle istruzioni per clonare un repository con `git svn clone` e smettere di usare il server Subversion, iniziando a usare il nuovo server Git facendo le push direttamente su quel server. Puoi ottenere la cronologia completa di SVN con una semplice pull dal server Subversion (che può però richiedere un po' di tempo).

L'importazione però non è perfetta, ma poiché ci vorrà del tempo la si può fare nel modo giusto. In Subversion, ogni persona che committa qualcosa ha un utente nel sistema, e questa informazione è registrata nella commit stessa. Gli esempi della sezione precedente mostrano in alcune parti `schacon`, come per gli output di `blame` e `git svn log`. Se vuoi mappare le informazioni degli utenti Subversion sugli autori in Git devi creare un file chiamato `users.txt` che esegue la mappatura secondo il formato seguente:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

Per ottenere la lista usata da SVN per gli autori puoi eseguire il comando seguente:

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

Che ti restituisce in output una lista in XML dove puoi cercare gli autori e crearne una lista univoca, eliminando il resto dell'XML (ovviamente questo comando funziona solo su una macchina che abbia installato `grep`, `sort` e `perl`) e quindi redigendo l'output nel file users.txt, così che puoi aggiungere le informazioni sugli autori per ogni commit.

Puoi fornire questo file a `git svn` per aiutarlo a mappare gli autori con maggiore precisione. Ma puoi anche dire a `git svn` di non includere i metadata che normalmente Subversion importa, con l'opzione `--no-metadata` ai comandi `clone` o `init`. Il che risulterà in un comando di `import` come il seguente:

	$ git svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Dovresti ora avere un import di Subversion, nella cartella `my_project`, più carino. Invece di avere delle commit che appaiono così

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

appariranno così:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Non solo il campo dell'autore avrà delle informazioni migliori, ma non ci sarà più nemmeno `git-svn-id`.

C'è bisogno di fare un po' di pulizia `post-import`. Da una parte dovrai eliminare i riferimenti strani che `git svn` crea. Prima di tutto dovrai spostare i tag in modo che siano davvero dei tag e non degli strani branch remoti, e poi sposterai il resto dei branch, così che siano locali e non appaiano più come remoti.

Per spostare i tag perché siano dei veri e propri tag di Git devi eseguire:

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname"; done

Questo comando prende i riferimenti ai branch remoti che inizino per `tag/` e li rende veri (lightweight) tags.

Quindi sposta il resto dei riferimenti sotto `refs/remotes` perché siano branch locali:

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname"; done

Ora tutti i branch precedenti sono veri branch di Git, e tutti i tag sono veri tag di Git. L'ultima cosa da fare è aggiungere il nuovo server Git come un server remoto e fare il push delle modifiche. Qui di seguito c'è l'esempio per definire il server come un server remoto:

	$ git remote add origin git@my-git-server:myrepository.git

Poiché vuoi che tutti i tuoi branch e i tag siano inviati al server, devi eseguire questi comandi:

	$ git push origin --all
	$ git push origin --tags

Ora tutti i tuoi branch e i tag dovrebbero essere sul tuo server Git, con una importazione pulita e funzionale.

### Perforce ###

Il successivo strumento analizzato è Perforce. Una importazione da Perforce viene anche distribuita con Git. Se stai usando una versione di Git precedente alla 1.7.11, lo strumento per l’importazione è disponibile esclusivamente nella sezione `contrib` dei sorgenti di Git. In questo caso dovrai ottenere i sorgenti di git che puoi scaricare da git.kernel.org:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

Nella directory `fast-import` dovresti trovare uno script Python chiamato `git-p4`. Dovrai avere Python e l’applicazione `p4` installati sulla tua macchina perché questa importazioni funzioni. Per esempio importeremo il progetto Jam dal repository pubblico di Perforce. Per configurare il tuo client, devi esportare la variabile ambientale P4PORT perché punti al Perforce Public Depot:

	$ export P4PORT=public.perforce.com:1666

Esegui quindi il comando `git-p4 clone` per importare il progetto Jam dal server di Perforce, fornendo i percorsi del repository, del progetto e della directory locale dove vuoi che venga importato il progetto:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

Se ora vai nella cartella `/opt/p4import` ed esegui `git log`, vedrai che la tua importazione è completa:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

Puoi vedere l’identification `git-p4` in ogni commit. Va bene mantenere questo identificativo nel caso servisse fare riferimento al numero di versione di Perforce in un secondo momento. Ma se vuoi rimuovere questo identification questo è il momento giusto per farlo, ovvero prima che iniziate a lavorare col nuovo repository. Per farlo puoi usare il comando `git filter-branch` per rimuovere le righe identificative in un solo passaggio:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

Se esegui ora il comando `git log` vedrai che i checksum SHA-1 per le commit sono cambiati, questo perché le stringhe di `git-p4` non ci sono più nei messaggi delle commit:

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

La tua importazione è ora pronta per essere inviata al server Git con una push.

### Un’importazione personalizzata ###

Se non usi né Subversion né Perforce dovresti cercare online se esista uno strumento d’importazione per il tuo sistema. Ce ne sono di buona qualità per CVS, Clear Case, Visual Source Safe e perfino per una directory di archivi. Se nessuno di questi strumenti funzionasse per il tuo caso significa che hai uno strumento abbastanza raro o se necessiti di una maggiore personalizzazione per l’importazione, dovresti usare `git fast-import`. Questo comando legge delle semplici istruzioni dallo standard input per scrivere dati di Git specifici. È molto più semplice creare degli oggetti di Git con questo strumento piuttosto che usare comandi raw di Git (v. Capitolo 9 per maggiori informazioni). In questo modo potrai scrivere uno script d’importazione che legga le informazioni necessarie dal sistema da cui vuoi importare i dati e le scriva sullo standard output, in modo che Git le legga attraverso `git fast-import`.

Per dimostrare velocemente quanto detto, scriveremo uno semplice script d’importazione. Supponiamo di lavorare in current e che di tanto in tanto fai il backup del progetto copiando la directory in una di backup con il timestamp nel nome (per esempio: `back_YYYY_MM_DD`), e vuoi importare il tutto in Git. La struttura delle tue directory sarà simile a questa:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

Per importare la directory in Git, devi rivedere come Git gestisce i suoi dati. Come ricorderai, Git è fondamentalmente una lista collegata di oggetti commit che puntano a una versione istantanea del progetto. Tutto quello che devi fare è dire a `fast-import` quali sono le istantanee, quale commit punta alle istantanee e il loro ordine. La strategia che adotteremo sarà andare da un’istantanea all’altra e creare tante commit con il contenuto di ciascuna directory, collegando ciascuna commit alla precedente.

Come hai fatto nell’esempio del Capitolo 7, scriveremo questo script in Ruby, perché è lo strumento con cui io generalmente lavoro e tende ad essere semplice da leggere. Puoi comunque scrivere questo esempio facilmente in qualsiasi linguaggio con cui tu abbia familiarità: deve solamente scrivere le informazioni corrette sullo standard output. Se lavori su Windows devi fare attenzione che non aggiunga un ritorno (CR) alla fine delle righe, perché `git fast-import` richiede specificatamente che ci sia solo un ritorno unix standard (LF) e non il ritorno a capo che usa Windows (CRLF).

Per iniziare, andiamo nella directory di destinazione e identifichiamo ciascuna subdirectory, ognuna contenente una istantanea di quello che vogliamo importare come una commit. Andrai in ciascuna subdirectory e stamperai i comandi necessari per esportarne il contenuto. Il tuo ciclo di base assomiglierà a questo::

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

Esegui `print_export` in ciascuna directory, che prende in input il manifesto e il contrassegno dell’istantanea precedente e restituisce in output il manifesto e il contrassegno di quella corrente. In questo modo si possono collegare facilmente. "Mark" (contrassegno) è una chiave identificativa che tu dai a ciascuna commit. Man mano che creerai commit, darai a ciascuna un nuovo contrassegno che userai per collegarla alle altre commit. La prima cosa quindi che dovrai fare nel tuo `print_export` sarà generare questo contrassegno dal nome della directory:

	mark = convert_dir_to_mark(dir)

Creerai un array di directory e userai l’indice di questo array, perché il contrassegno dev’essere un intero. Il tuo metodo sarà più o meno così::

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Ora che hai un intero a rappresentare ciascuna commit, hai bisogno di una data per il metadata della commit. Poiché la data è contenuta nel nome della directory ti basterà processarla.
La riga successiva del tuo `print_export` sarà quindi

	date = convert_dir_to_date(dir)

dove `convert_dir_to_date` è definito come

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

Questo restituisce un intero per la data di ciascuna directory. L’ultimo metadata di cui hai bisogno è il nome di chi ha eseguito la commit, che scriverai in una variabile globale:

	$author = 'Scott Chacon <schacon@example.com>'

Sei ora pronto per scrivere i dati delle commit per la tua importazione. L’informazione iniziale descrive che stai definendo una commit e a quale branch appartiene, seguita dal contrassegno che hai generato, le informazioni sull’autore e il messaggio della commit, infine la commit precedente, se esiste. Il codice assomiglierà a questo:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

Definisci hardcoded il fuso orario (-0700 nell’esempio) perché è più facile farlo così. Ma se stai importando i dati da un altro sistema dovrai specificare l’orario come differenza di ore.
Il messaggio della commit dovrà essere espresso in un formato particolare:

	data (size)\n(contents)

Il formato consiste nella parola “data”, la dimensione dei dati da leggere, un ritorno a capo e quindi i dati veri e propri. Poiché hai bisogno dello stesso formato per specificare anche il contenuto dei file, creeremo un metodo `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

Tutto ciò che manca è solo specificare i file contenuti in ciascuna istantanea. Questo è semplice perché ognuna è una directory, e puoi scrivere il comando `deleteall` seguito dal contenuto di ciascun file nella directory. Git registrerà ogni istantanea nel modo corretto:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

NB:	Poiché molti sistemi pensano le revisioni come cambiamenti tra una commit e l’altra, fast-import può anche prendere in input con ciascuna commit la descrizione di ciascun file aggiunto, rimosso o modificato e quale sia il contenuto attuale. Puoi calcolare tu stesso le differenze tra le varie istantanee e fornire queste informazioni, ma farlo è molto più complesso, e puoi così dare a Git tutte le informazioni e lasciare che Git ricavi quelle di cui ha bisogno. Se questo fosse il tuo caso, controlla la pagina man di `fast-import` per maggiori dettagli su come fornire queste informazioni in questo modo.

Il formato per l’elenco del contenuto aggiornato dei file o per specificare i file modificati con i contenuti aggiornati è quello seguente:

	M 644 inline path/to/file
	data (size)
	(file contents)

In questo caso 644 è il modo (devi individuare i file eseguibili ed usare invece il modo 755), e inline dice che indicherai il contenuto immediatamente dalla riga successiva. Il metodo `inline_data` sarà più o meno così:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

Puoi riusare il metodo `export_data` definito precedentemente perché l’output è lo stesso di quando abbiamo specificato le informazioni per la commit.

L’ultima cosa che dovrai fare è restituire il contrassegno attuale, così che possa essere passato all’iterazione seguente:

	return mark

NB: Se sei su Windows devi aggiungere un ulteriore passaggio. Come già specificato prima, Windows usa il ritorno CRLF mentre git fast-import si aspetta solo un LF. Per risolvere questo problema e fare felice git fast-import, dovrai dire a ruby di usare LF invece di CRLF:

	$stdout.binmode

Questo è tutto: se esegui questo script otterrai un output simile al seguente:

	$ ruby import.rb /opt/import_from
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

Per eseguire l’importazione, attacca (con pipe) questo output a `git fast-import` dal repository di Git in cui vuoi importare i dati. Puoi creare una nuova directory e quindi eseguire `git init` nella nuova directory per iniziare, e quindi eseguire il tuo script:

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

Come puoi vedere, quando l’importazione avviene con sussesso, restituisce una serie di statistiche sulle attività svolte con successo. In questo caso abbiamo importato complessivamente 18 oggetti in 5 commit su 1 branch. Puoi ora quindi eseguire `git log` per vedere la cronologia:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

E ora hai un repository Git pulito e ben strutturato. È importante notare che non c’è nessun file nella directory perché non è stato fatto nessun checkout. Per avere i file che ti aspetteresti di avere, devi resettare il tuo branch alla posizione attuale del `master`:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

Puoi fare un sacco di altre cose con lo strumento `fast-import`, come gestire modalità diverse, dati binari, branch multipli, fare il merge di branch e tag, aggiungere degli indicatori di avanzamento e molto ancora. Numerosi esempi per scenari più complessi sono disponibili nella directory `contrib/fast-import` dei sorgenti di Git. Il migliore è lo script `git-p4` di cui abbiamo parlato prima.

## Sommario ##

Dovresti trovarti a tuo agio usando Git con Subversion o importando praticamente qualsiasi repository esistente in un nuovo repository Git senza perdere dati. Il prossimo capitolo tratterà i comandi interni raw di Git, così che puoi manipolare ogni singolo byte, qualora necessario.

