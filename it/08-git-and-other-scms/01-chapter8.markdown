# Git e altri sistemi #

Il mondo non è perfetto. Solitamente, non si può spostare immediatamente ogni progetto
con cui si è in contatto a Git. A volte si è bloccati su un progetto che usa un altro
VCS, la maggior parte delle volte Subversion. Si passerà la prima parte di questo
capitolo ad imparare `git svn`, lo strumento di interfaccia bidirezionale di Git.

A un certo punto, si potrebbe voler convertire un progetto esistente a Git. La seconda
parte di questo capitolo copre la migrazione di un progetto a Git: prima da
Subversion, poi da Perforce e infine tramite uno script di importazione personalizzato
per un caso di importazione non standard.

## Git e Subversion ##

Attualmente, la maggior parte dei progetti di sviluppo open source e un gran numero
di progetti aziendali usano Subversion per la gestione del loro codice sorgente.
È il VCS open source più popolare ed è in giro da quasi un decennio. È anche molto
simile in molti aspetti a CVS, che è stato il più usato controllo per i sorgenti
prima di lui.

Una delle grandi caratteristiche di Git è il ponte bidirezionale per Subversion,
chiamato `git svn`. Questo strumento consente di usare Git come client di un server
Subversion, in modo da poter usare tutte le caratteristiche locale di Git e poi
inviare al server Subversion, come se si usasse Subversion localmente. Questo
vuol dire che si possono fare branch e merge in locale, usare l'area di stage, usare
il rebase e il cherry-pick, ecc.m mentre gli altri collaboratori continuano a
lavorare nei loro modi oscuri e antichi. È un buon modo per introdurre Git in
un ambiente aziendale e aiutare i compagni sviluppatori a diventare più efficienti,
mentre si cerca di convincere l'azienda a cambiare infrastruttura per supportare
pienamente Git. Il ponte Subversion è la droga delle interfacce nel mondo dei DVCS.

### git svn ###

Il comando di base in Git per tutti i comandi ponte verso Subversion è `git svn`.
Basta far precedere ogni comando con questo. Bastano pochi comandi per imparare
quelli comuni, durante i primi flussi di lavoro. È importante notare che, quando si usa
`git svn`, si sta interagendo con Subversion, che è un sistema molto meno
sofisticato di Git. Sebbene si possano fare facilmente branch e merge locali, in
genere è meglio tenere la propria history più lineare possibile, riorganizzando
il proprio lavoro ed evitando cose che interagiscono contemporaneamente con un
repository remoto Git.

Non provare riscrivere la propria history e fare di nuovo push, non fare push verso
un repository Git parallelo per collaborare con sviluppatori Git nello stesso tempo.
Subversion può avere solo una singola history lineare e confondersi è molto facile.
Se si lavora in una squadra e alcuni usano SVN e altri Git, assicurarsi che
ognuno usi il server SVN per collaborare, in modo da semplificarsi la vita.

### Impostazioni ###

Per dimostrare questa funzionalità, occorre un tipo repository SVN a cui si ha accesso
in scrittura. Se si vogliono copiare questi esempi, serve creare una copia scrivibile
del mio repository di test. Per poterlo fare facilmente, si può usare uno strumento
chiamato `svnsync`, distribuito con le versioni recenti di Subversion, almeno dalla
1.4. Per questi test, ho creato su Google code un nuovo repository Subversion, che è
la copia parziale del progetto `protobuf`, che è uno strumento di codifica di dati
strutturati per trasmissioni di rete.

Per proseguire, occorre prima creare un nuovo repository Subversion locale:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Quindi, abilitare tutti gli utenti a cambiare revprops, il modo più facile è
aggiungere uno script pre-revprop-change che esca sempre con 0:

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Si può ora sincronizzare questo progetto con la proprima macchina locale, richiamando
`svnsync init` con i repository sorgente e destinazione.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

Quest inizializza le proprietà per eseguire la sincronizzazione. Si può ora fare un
clone del codice, eseguendo

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Sebbene questa operazione possa impiegare solo pochi minuti, se si prova a copiare il
repository originale in un altro repository remoto, invece che su uno locale, il
processo impiegherà quasi un'ora, anche se ci sono meno di 100 commit. Subversion deve
fare il clone di una revisione alla volte e poi fare il push in un altro repository:
è altamente inefficiente, ma è l'unico modo per farlo.

### Cominciare ###

Ora che sia un repository Subversion a cui si ha accesso, si può fare un tipico flusso
di lavoro. Si inizierà con il comando `git svn clone`, ceh importa un intero repository
Subversion in un repository locale Git. Si ricordi che, se si sta importando da un vero
repository Subversion, occorre sostituire `file:///tmp/test-svn` con l'URL del
repository Subversion:

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

Questo esegue l'equivalente di due comandi, `git svn init` seguito da `git svn fetch`,
sull'URL fornito. Potrebbe volerci un po' di tempo. Il progetto di test ha solo circa
75 commit e la base di codice non è così grossa, quindi servono solo pochi minuti.
Tuttavia, Git deve fare check di ogni versione, una alla volta, e fare commit di
ognuna di esse individualmente. Per un progetto con centinaia di migliaia di commit,
potrebbero volerci delle ore o anche dei giorni per finire.

La parte `-T trunk -b branches -t tags` dice a Git che questo repository Subversion
segue le convenzioni di base per branch e tag. Se si danno nomi diversi a trunk, branches
o tags, si possono cambiare queste opzioni. Essendo molto comune, si può sostituire
tutta questa parte con `-s`, che sta per standard e implica tutte le opzioni viste.
Il comando seguente è equivalente:

	$ git svn clone file:///tmp/test-svn -s

A questo punto, si dovrebbe avere un repository Git valido, che ha importato i propri
branch e tag:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

È importante notare come questo strumento introduca dei namespace remoti differenti.
Quando si fa un normale clon di un repository Git, si prendono tutti i branch di quel
server remoto disponibili locamente come qualcosa tipo `origin/[branch]`, con un
namespace che dipende dal nome remoto. Tuttavia, `git svn` presume che non si vogliano
avere remoti multipli e salva tutti i suoi riferimenti per puntare al server remoto
senza namespace. Si può usare il comando `show-ref` per cercare tutti i nomi dei
riferimenti:

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

Si hanno due serer remoti: uno chiamato `gitserver` con un branch `master`, l'altro
chiamato `origin` con due branch, `master` e `testing`. 

Si noti come nell'esempio dei riferimenti remoti importati da `git svn` i tag siano
aggiunti come branch remoti, non come veri tag di Git. L'importazionoe da Subversion
appare come se avesse dei tag remoti con nome, con dei branch all'interno.

### Commit verso Subversion ###

Ora che si ha un repository funzionante, si può lavorare un po' sul progetto e
inviare i propri commit, usando effettivamente Git come un client SVN. Se si modifica
un file e si fa un commit, si ha un commit che esiste localmente in Git, ma non
nel server Subversion:

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

Successivamente, occorre inviare le modifiche. Si noti come questo cambi il modo in cui
si lavora con Subversion: si possono fare vari commmit offline e poi inviarli tutti
insieme al server Subversion. Per inviare al server Subversion, eseguire il comando
`git svn dcommit`:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Il comando prende tutti i commit fatti, esegue un commit verso Subversion per ciascuno
di essi e quindi riscrive il commit locale di Git per includere un identificatore
univoco. Questo è imporatnte, perché vuol dire che tutti i checksum SHA-1 dei propri
commit cambiano. In parte per questa ragione, lavorare on versioni remote basate su Git
dei propri progetti contemporaneamente con un server Subversion non è una buona idea.
Se si da un'occhiata all'ultimo commit, si potrà vedere il nuovo `git-svn-id` aggiunto:

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Si noti che il checksum SHA che originariamente iniziava con `97031e5`, ora inizia con
`938b1a5`. Se si vuole inviare sia a un server Git che a un server Subversion, occorre
farlo prima al server Subversion (`dcommit`), poiché questa azione cambia i dati di
commit.

### Aggiornare ###

Se si lavora con altri sviluppatori, ad un certo punto uno di essi farà push, quindi gli
altri proveranno a fare push di una modifica che andrà in conflitto. Questa modifica
sarà rigettata, finché non si fa un merge. Con `git svn`, sarà una cosa del genere:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Per risolvere questa situazione, si può eseguire `git svn rebase`, che fa un pull dal
server di ogni modifica che ancora non si ha e ribasa ogni lavoro che su quello che c'è
sul server:

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

Ora, tutto il proprio lavoro è basato sul server Subversion, quindi si può fare `dcommit`
senza problemi:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

È importante ricordare che, diversamente da Git, che richiede di fare un merge del
lavoro remoto che non si ha ancora in locale prima di fare push, `git svn` consente di
farlo solo se le modifiche sono in conflitto. Se qualcun altro fa push di una modifica
ad un file e poi si fa un push di una modifica ad un altro file, il proprio `dcommit`
funzionerà:

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

Questo è importante da ricordare, perché il risultato è uno stato del progetto che non
esiste su alcun computer su cui si è fatto push. Se le modifiche sono incompatibili ma
non in conflitto, si possono avere difficoltà a diagnosticare. Questo differisce dall'uso
di un server Git: in Git, si può testare in pieno lo stato del proprio client prima della
pubblicazione, mentre in SVN non si può mai essere certi che lo stato immediatamente prima
del commit e quello dopo siano identici.

Si dovrebbe sempre eseguire questo comando per fare pull delle modifiche dal server
Subversion, anche se non si è pronti a fare commit. Si può eseguire `git svn fetch` per
recuperare i nuovi dati, ma `git svn rebase` analizza e aggiorna i propri commit locali.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Eseguendo `git svn rebase` una volta ogni tanto assicura che il proprio codice sia sempre
aggiornato. Tuttavia, occorre assicurarsi che la propria cartella di lavoro sia pulita
quando si fa l'esecuzione. Se si hanno modifiche locali, si deve o mettere al sicuro il
proprio lavoro o fare un commit temporaneo, prima di eseguire `git svn rebase`; in caso
contario, il comando si fermerà se vede che il rebase risulterà in un conflitto di merge.

### Problemi con i branch Git ###

Quando ci si trova a proprio agio con il flusso di lavoro di Git, probabilmente si
vorranno creare dei branch, lavorare su di essi, quindi farne un merge. Se si sta
facendo push verso un server Subversion tramite git svn, si potrebbe voler ribasare
il proprio lavoro su un singolo branch ogni volta, invece di fare merge di branch
insieme. La ragione per preferire il rebase è che Subversion ha una cronologia lineare e
non tratta i merge nello stesso modo di Git, quindi git svn segue solo il primo
genitore, quando converte gli snapshot in commit di Subversion.

Ipotizziamo che la cronologia sia come la seguente: si è creato un branc `experiment`,
sono stati fatti due commit e quindi un merge in `master`. Quando si esegue `dcommit`,
si vedrà un output come questo:

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

L'esecuzione di `dcommit` su un branch che ha una cronologia con dei merge funziona bene,
ma quando si guarda nella cronologia del progetto Git, nessuno dei commit fatti sul
branch `experiment` è stato eseguito; invece, tutte queste modifiche appaiono nella
versione SVN del singolo commit di merge.

Quando qualcun altro clona questo lavoro, tutto quello che vedrà è il commit del merge
con tutto il lavoro spremuto dentro; non vedranno i dati dei commit, da dove vengano
o quando siano stati eseguiti i commit.

### Branch Subversion ###

I branch in Subversion non sono la stessa cosa dei branch in Git; si può evitare di
usarli troppo, che forse è la cosa migliore. Tuttavia, si possono creare branch e farne
commit in Subversion usando git svn.

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

Questo equivale al comando `svn copy trunk branches/opera` in Subversion e opera sul
server Subversion. È importante notare che non esegue check out in quel branch; se si
fa commit a questo punto, il commit andrà nel `trunk` del server, non in `opera`.

### Cambiare il branch attivo ###

Git riesce capire in quale branch vanno i propri dcommit, cercando informazioni in
ognuno dei proprio branch nella cronologia di Subversion: se ne dovrebbe avere solo uno,
quello con `git-svn-id` nella cronologia del proprio ramo corrente.

Se si vuole lavorare contemporaneamente su più branch, si possono impostare i branch locali
per fare `dcommit` su specifici rami di Subversion, iniziandoli al commit di Subversion
importato per quel branch. Se si vuole un branch `opera` su cui lavorare separatamente,
si può eseguire

	$ git branch opera remotes/opera

Ora, se si vuole fare un merge del branch `opera` in `trunk` (il proprio branch `master`),
si può farlo con un normale `git merge`. Ma si deve fornire un messaggio di commit
descrittivo (usando `-m`) o il merge dirà solo "Merge branch opera", invece di qualcosa
di utile.

Si ricordi che, sebbene si usi `git merge` per eseguire questa operazione e il merge
probabilmente sarà più facile di quanto sarebbe stato in Subversion (perché Git
individua automaticamente la base di merge appropriata), questo non è un normale commit
di merge di Git. Occorre fare push di questi dati a un server Subversion che possa
gestire un commit che tracci più di un genitore; quindi, dopo aver fatto push, sembrerà
un singolo commit che ha schiacciato tutto il lavoro di un altro branch in un singolo
commit. Dopo aver fatto il merge in un branch in un altro, non si può tornare indietro
facilmente e continuare a lavorare su quel branch, come si farebbe normalmente in Git.
Il comando `dcommit` che è stato eseguito cancella ogni informazione sui branch dei quali
sia stato fatto il merge, quindi i seguenti calcoli basati su merge saranno errati:
dcommit rende il risultato di `git merge` come se si fosse eseguito `git merge --squash`.
Sfortunatamente, non c'è un buon modo per evitare tale situazione: Subversion non può
memorizzare questa informazioni, quindi si resterà sempre danneggiati dalle sue
limitazioni, finché lo si userà come server. Per evitare problemi, si dovrebbe
cancellare il branch locale (in questo caso, `opera`) dopo aver fatto il merge nel trunk.

TODO da finire....
