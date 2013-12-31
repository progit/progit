# I comandi interni di Git #

Forse sei saltato a questo capitolo da uno precedente, o dopo aver letto il resto del libro. In ogni caso qui approfondiremo il funzionamento interno e l'implementazione di Git. Ho pensato che queste informazioni fossero fondamentali per capire quanto Git fosse utile e potente, ma qualcuno ha argomentato che queste potessero essere complesse e non necessariamente utili per i principianti.
Per questo motivo ho deciso di includere queste informazioni nell'ultimo capitolo del libro di modo che la possa leggere nella fase dell'apprendimento che ritieni più opportuna. Lascio a te la scelta.

Dato che sei qui, possiamo partire. Per prima cosa, se non è ancora chiaro, Git è fondamentalmente un filesystem indirizzabile per contenuto sul quale si appoggia una interfaccia utente VCS. Tra breve imparerai meglio cosa significhi.

Nelle prime versioni di Git (principalmente pre 1.5) l'interfaccia utente era molto più complessa perché veniva privilegiato il filesystem rispetto ad avere un VCS pulito. Negli ultimi anni l'interfaccia utente è stata rifinita fino a diventare chiara e facile da usare come gli altri sistemi disponibili, ma è rimasto lo stereotipo che l'interfaccia di Git sia complessa e difficile da capire.

Il filesystem indirizzabile per contenuto è veramente formidabile, quindi in questo capitolo inizierò parlandone. Imparerai quindi il meccanismo di trasporto e le attività per la manutenzione del repository con le potresti dover aver a che fare.

## Impianto e sanitari ##

Questo libro parla di come usare Git utilizzando più di 30 termini come `checkout`, `branch`, `remote` e così via. Poiché Git è stato inizialmente sviluppato come un insieme di strumenti per un VCS, piuttosto che un completo VCS user-friendly, ha un mucchio di termini per fare lavori di basso livello e progettati per essere concatenati insieme nello stile UNIX o invocati da script. Di solito ci si riferisce a questi comandi come "plumbing" (impianto), mentre i comandi più user-friendly sono detti comandi "porcelain" (sanitari).

I primi otto capitoli del libro hanno a che fare quasi esclusivamente con comandi *porcelain*. In questo capitolo vedremo invece i comandi *plumbing* di basso livello, perché permettono di accedere al funzionamento interno di Git ed aiutano a dimostrare come e perché Git fa quello che fa. Questi comandi non sono pensati per essere lanciati manualmente dalla linea di comando ma sono da considerare piuttosto come mattoni con i quali costruire nuovi strumenti e script personalizzati.

Eseguendo `git init` in una directory nuova o esistente Git provvederà a creare la directory `.git` che contiene praticamente tutto ciò di cui ha bisogno Git. Se vuoi fare un backup o un clone del tuo repository ti basta copiare questa directory da qualche altra parte per avere praticamente tutto quello che ti serve. Tutto questo capitolo tratta il contenuto di questa directory. La sua struttura di default è la seguente:

	$ ls 
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

Potresti trovare altri file, ma quello che vedi sopra è il risultato di `git init` appena eseguito. La directory `branches` non è utilizzata dalle versioni più recenti di Git e il file `description` è utilizzato solamente dal programma GitWeb, quindi puoi pure ignorarli.
Il file `config` contiene le configurazioni specifiche per il progetto e la directory `info` mantiene 
un file di exclude globale per ignorare i pattern dei quali non volete tenere traccia un in file .gitignore. La directory `hooks` contiene i tuoi script di hook client/server, che vengono discussi in dettaglio nel capitolo 7.

Non abbiamo ancora parlato di quattro cose importanti: i file `HEAD` e `index` e le directory `objects` e `refs`, che fanno parte del nucleo di Git. La directory `objects` contiene tutto il contenuto del tuo database, la directory `refs` contiene i puntatori agli oggetti delle commit nei diversi branch, il file `HEAD` punta al branch di cui hai fatto il checkout e nel file `index` Git registra la informazioni della tua area di staging. Vedremo in dettaglio ognuna di queste sezioni per capire come opera Git.

## Gli oggetti di Git ##

Git è un filesystem indirizzabile per contenuto. Magnifico, ma che cosa significa? Significa che il nucleo di Git è un semplice database chiave-valore. Puoi inserire qualsiasi tipo di contenuto
al suo interno, e ti verrà restituita una chiave che potrai usare per recuperare quel contenuto in qualsiasi momento, quando vorrai. Come dimostrazione puoi usare il comando *plumbing* `hash-object` che accetta dei dati, li salva nella vostra directory `.git` e restituisce la chiave associata ai dati salvati. Per prima cosa create un nuovo repository Git e verificate che la directory `objects` non contenga nulla:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

Git ha creato la directory `objects` e, al suo interno, le subdirectory `pack` e `info`, ma non ci sono file. Ora inseriamo del testo nel tuo database di Git:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

L’opzione `-w` dice a `hash-object` di salvare l'oggetto: se la omettessimo il comando restituirebbe semplicemente quale chiave verrebbe associata all’oggetto. `--stdin` dice al comando di leggere il contenuto dallo standard input: se non lo specifichi `hash-object` si aspetta il percorso di un file. L'output del comando è un checksum di 40 caratteri. Questo è un hash SHA-1, un checksum del contenuto che viene salvato con la sua intestazione, ma questo lo vedremo fra poco. Ora vediamo come Git ha salvato i tuoi dati:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Ora troverai un file nella directory `objects`. Questo è il modo in cui Git salva inizialmente il contenuto: un singolo file per ogni porzione di contenuto, con il nome del checksum SHA-1 del contenuto e del suo header. I primi 2 caratteri dello SHA sono il nome della subdirectory, mentre gli altri 38 sono il nome del file.

Puoi estrarre il contenuto memorizzato in Git con il comando `cat-file`. Questo comando è una specie di coltellino svizzero per ispezionare gli oggetti Git. Usandolo con l’opzione `-p` è possibile dire al comando `cat-file` d’interpretare il tipo di contenuto e mostrartelo in un modo più elegante: 

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Ora puoi aggiungere dell’altro contenuto a Git ed estrarlo nuovamente. Lo puoi possibile far anche con il contenuto dei file. Puoi, per esempio, implementare un semplice controllo di versione di un file. Come prima cosa crea un nuovo file e salva il suo contenuto nel database:

	$ echo 'versione 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

Quindi scrivi un nuovo contenuto nel file e risalvalo:

	$ echo 'versione 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Il tuo database conterrà le due nuove versioni del file così come il primo contenuto che avevi già salvato:

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Ora puoi riportare il file alla prima versione:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	versione 1

o alla seconda:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	versione 2

Ricordare la chiave SHA-1 di ogni versione del tuo file non è per niente pratico e, come hai visto, non viene salvato nemmeno il nome del file, ma solo il suo contenuto. Questo tipo di oggetto a chiamato blob. Puoi fare in modo che Git ti restituisca il tipo di ciascun oggetto conservato al suo interno, data la sua chiave SHA-1, con `cat-file -t`:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### L’albero degli oggetti ###

Il prossimo argomento che guarderemo è l'albero degli oggetti, che risolve il problema del salvataggio del nome del file e ci permette di salvare un gruppo di file contemporaneamente. Git salva il contenuto in modo simile ad un filesystem UNIX, ma un po’ più semplificato. Tutto il suo contenuto è salvato come albero o blob, dove gli alberi corrispondono alle directory UNIX e i blob corrispondono 
più o meno agli inode o ai contenuti dei file. Un singolo albero contiene una o più voci, ognuna delle quali contiene un puntatore SHA-1 a un blob o a un altro con i suoi modi, tipi e nomi. Ad esempio, l'albero più recente nel progetto simplegit potrebbe assomigliare a questo:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

La sintassi `master^{tree}` indica che l’ultima commit sul tuo branch ‘master’ punta a questo albero.
Nota che la directory `lib` non è un blob ma un puntatore a un altro albero:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Concettualmente, i dati che vengono salvati da Git sono simili a quelli in Figura 9-1.

Insert 18333fig0901.png 
Figura 9-1. Versione semplificata del modello dei dati di Git.

Puoi creare il tuo albero come vuoi. Git normalmente crea un albero partendo dallo stato della tua area di staging o dall’indice e scrive albero partendo da lì. Quindi, per creare un albero devi prima creare un indice mettendo in staging alcuni file. Per creare un indice con una singola voce - la prima versione del tuo test.txt - puoi usare il comando *plumbing* `update-index`. Usando questo 
comando aggiungi artificialmente la versione precedente del file test.txt a una nuova area di staging.
Devi usare l'opzione `--add` perché il file non esiste ancora nella tua area di staging (e in effetti ancora non hai nemmeno un'area di staging) e l'opzione `--cacheinfo` perché il file che stai aggiungendo non è nella tua directory ma nel tuo database. Per finire, specifica il modo l’hash SHA-1 e il nome del file:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

In questo caso, stai specificando il modo `100644` che significa che si tratta di un file normale.
Altre opzioni sono `100755` (che significa che il file è eseguibile) e `120000` (che specifica un link simbolico). Il modo è preso dai modi normali di UNIX, ma è molto meno flessibile: questi tre sono gli unici validi per i file (blob) in Git (anche se ci sono altri modi utilizzati per le directory ed i sottomoduli).

Ora puoi usare il comando `write-tree` per creare l'area di staging da un albero. L'opzione `-w`
non è necessaria, perché l'esecuzione di `write-tree` crea automaticamente un oggetto albero a partire dallo stato dell'indice se l’albero ancora non esiste:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Puoi anche verificare che si tratta di un oggetto albero:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Ora creerai un nuovo albero con la seconda versione di test.txt e un nuovo file:

	$ echo ‘nuovo file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 


La tua area di staging ora contiene la nuova versione di test.txt così come il nuovo file new.txt
Scrivete l'albero (registrando lo stato dell'area di staging o indice in un oggetto albero) e osservate a cosa assomiglia

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Nota che questo albero ha entrambe le voci e anche che l’hash SHA di test.txt è lo stesso SHA della precedente "versione 2" (`1f7a7a`). Solo per divertimento, aggiungi il primo albero come subdirectory di questo attuale. Puoi vedere gli alberi nella tua area di staging eseguendo `read-tree`. Potrai vedere un albero esistente nella tua area di staging come sotto-albero con l'opzione `--prefix` di `read-tree`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Se hai creato una directory di lavoro dal nuovo albero che hai appena scritto, otterrai i due file nel primo livello della directory e una sotto-directory chiamata `bak`, che contiene la prima versione del file test.txt. Puoi pensare ai dati contenuti da Git per questa strutture come quelli della Figura 9-2.

Insert 18333fig0902.png 
Figura 9-2. La struttura dei contenuti per i vostri dati di Git.

### Oggetti Commit ###

A questo punto avrai tre alberi che specificano le diverse istantanee (snapshot) del tuo progetto delle quali vuoi tenere traccia, ma rimane il problema iniziale: devi ricordare tutti e tre gli hash SHA-1 per poter recuperare le istantanee. Inoltre non hai nessuna informazione su chi ha salvato le istantanee, né quando le hai salvate né tantomeno perché. Queste sono le informazioni che gli oggetti commit registrano per te.

Per creare un oggetto commit esegui `commit-tree` specificando un singolo albero SHA-1 e, se esiste, qual’è la commit immediatamente precedente. Comincia con il primo albero che hai scritto:

	$ echo 'prima commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Ora puoi analizzare il tuo nuovo oggetto commit con `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	prima commit

Il formato di un oggetto commit è semplice: specifica l'albero di primo livello per l’istantanea del progetto in quel dato punto, mentre le informazioni sull’autore delle modifiche o della commit vengono estratte dalle tue impostazioni `user.name` e `user.email` con il timestamp corrente, una linea vuota ed infine il messaggio di commit.

Scriviamo gli altri due oggetti commit, ognuno dei quali fa riferimento alla commit che le hanno preceduti:

	$ echo 'seconda commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo ‘terza commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Ognuno dei tre oggetti commit punta ad uno dei tre alberi delle istantanee che hai creato.
Ora hai una vera e propria cronologia di Git che puoi consultare con il comando `git log`, se lo esegui con l’hash SHA-1 dell'ultima commit vedrai:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Fantastico. Hai appena eseguito tutte le operazioni di basso livello per costruire una cronologia di Git senza utilizzare nessuno dei comandi del front end. Questo è essenzialmente quello che Git fa quando esegui i comandi `git add` e `git commit`: salva i blob per i file che sono cambiati, aggiorna l'indice, scrive gli alberi e scrive gli oggetti commit che fanno riferimento agli alberi di primo livello e le commit immediatamente precedenti a questi. Questi tre oggetti Git principali (il blob, l'albero, e la commit) sono inizialmente salvati come file separati nella tua directory `.git/objects`. Di seguito puoi vedere tutti gli oggetti nella directory di esempio, commentati con quello che contengono:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Se segui tutti i puntatori interni otterrai un grafico degli oggetti simile a quelli in Figura 9-3.

Insert 18333fig0903.png 
Figura 9-3. Tutti gli oggetti nella tua directory Git.

### Il salvataggio degli oggetti ###

In precedenza ho menzionato il fatto che insieme al contenuto viene salvato anche una intestazione. Prendiamoci un minuto per capire come Git salva i propri oggetti. Vedremo come salvare un oggetto blob - in questo caso la stringa "what is up, doc?" - interattivamente con il linguaggio di scripting Ruby. Potete lanciare Ruby in modalità interattiva con il comando `irb`:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git costruisce una intestazione che comincia con il tipo dell'oggetto, in questo caso un blob, aggiunge uno spazio seguito dalla dimensione del contenuto ed infine da un null byte:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git concatena l’intestazione e il contenuto originale e calcola il checksum SHA-1 del risultato. Puoi calcolare lo SHA-1 di una stringa in Ruby includendo la libreria SHA1 digest con il comando `require` e invocando `Digest::SHA1.hexdigest()`:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git comprime il nuovo contenuto con zlib, cosa che potete fare in Ruby con la libreria zlib.
Prima avrai bisogno di includere la libreria ed invocare `Zlib::Deflate.deflate()` sul contenuto:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Infine, scrivi il contenuto zlib-deflated in un oggetto sul disco. Determinerai il percorso dell'oggetto che vuoi scrivere (i primi due caratteri dello SHA-1 sono il nome della subdirectory e gli ultimi 38 caratteri sono il nome del file contenuto in quella directory). In Ruby puoi usare la funzione `FileUtils.mkdir_p()` per creare la subdirectory, se questa non esiste. Apri di seguito il file con `File.open()` e scrivi nel file il contenuto ottenuto in precedenza, chiamando
`write()` sul file handler risultante:

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

Questo è tutto - hai creato un oggetto Git valido di tipo blob. Tutti gli oggetti Git sono salvati nello stesso modo, solo con tipi differenti. Invece della stringa blob, l’intestazione comincerà con commit o tree. Inoltre, sebbene il contenuto del blob può essere praticamente qualsiasi cosa, i contenuti commit e tree sono formattati in modo molto dettagliato.

## I riferimenti di Git ##

Puoi eseguire un comando come `git log 1a410e` per vedere la cronologia completa, ma devi
comunque ricordarti che quel `1a410e` è l'ultima commit, per poter essere in grado di vedere la cronologia e trovare quegli oggetti. Hai bisogno di un file nel quale potete salvare il valore dello SHA-1 attribuendogli un semplice nome in modo da poter usare quel nome al posto del valore SHA-1 grezzo.

In Git questi sono chiamati "riferimenti" o "refs”: puoi trovare i file che contengono gli hash SHA-1
nella directory `.git/refs`. Nel nostro progetto questa directory non contiene files ma una semplice struttura:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Per creare un nuovo riferimento che ti aiuterà a ricordare dov'è la tua ultima commit, tecnicamente puoi una cosa molto semplice come questo:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Ora puoi usare il riferimento appena creato al posto del valore SHA-1 nei tuoi comandi Git:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Questo però non ti incoraggia a modificare direttamente i file di riferimento. Git fornisce un comando sicuro per farlo se vuoi aggiornare un riferimento, chiamato `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Questo è quello che si definisce branch in Git: un semplice puntatore o riferimento all’intestazione di un flusso di lavoro. Per creare un branch con la seconda commit, così:

	$ git update-ref refs/heads/test cac0ca

Il tuo branch conterrà solo il lavoro da quella commit in poi:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Ora, il tuo database Git assomiglia concettualmente alla Figura 9-4.

Insert 18333fig0904.png 
Figura 9-4. La directory degli oggetti Git directory con inclusi i riferimenti branch e head.

Quando esegui comandi come `git branch (branchname)`, Git in realtà esegue il comando `update-ref` per
aggiungere lo SHA-1 dell'ultima commit del branch nel quale siete, in qualsiasi nuovo riferimento vogliate creare.

### Intestazione ###

La questione ora è questa: quando esegui `git branch (branchname)`, come fa Git a conoscere lo SHA-1 dell'ultima commit?  La risposta è nel file HEAD. Il file HEAD è un riferimento simbolico al branch corrente. Per riferimento simbolico intendo che, a differenza di un normale riferimento, normalmente non contiene un valore SHA-1 quanto piuttosto un puntatore a un altro riferimento. Se esamini il file vedrai qualcosa come questa:

	$ cat .git/HEAD 
	ref: refs/heads/master

Se esegui `git checkout test`, Git aggiorna il file così:

	$ cat .git/HEAD 
	ref: refs/heads/test

Quando esegui `git commit`, questo crea l'oggetto commit specificando il padre dell'oggetto commit in modo che sia un hash SHA-1 a cui fa riferimento l’HEAD.

Puoi modificare manualmente questo file, ma, di nuovo, esiste un comando più sicuro per farlo: `symbolic-ref`. Puoi leggere il valore del tuo HEAD tramite questo comando:

	$ git symbolic-ref HEAD
	refs/heads/master

Puoi anche impostare il valore di HEAD:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

Non puoi impostare un riferimento simbolico al di fuori dei refs:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Tag ###

Hai appena visto i tre tipi principali di oggetti in Git, ma ce n'è anche un quarto. L'oggetto tag è molto simile a un oggetto commit: contiene un tag, una data, un messaggio ed un puntatore. La differenza principale sta nel fatto che un tag punta a una commit piuttosto che a un albero. E' come un riferimento a un branch, ma non si muove mai: punta sempre alla stessa commit e gli da un nome più amichevole.

Come discusso nel Capitolo 2, ci sono due tipi di tag: annotati (*annotated*) e leggeri (*lightweight*). Puoi creare un tag *lightweight* eseguendo un comando come questo:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Questo è tag *lightweight*: un branch che non si muove mai. Un tag annotato è però più complesso. Se crei un tag annotato, Git crea un oggetto tag e scrive un riferimento a cui puntare, piuttosto di puntare direttamente alla commit. Puoi vederlo creando un tag annotato (`-a` specifica che si tratta di un tag annotato):

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 –m 'test tag'

Questo è il valore SHA-1 dell'oggetto creato:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Ora, esegui il comando `cat-file` su questo hash SHA-1:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Noterai che l'oggetto punta all’hash SHA-1 della commit che hai taggato. Nota anche che non ha bisogno di puntare ad una commit: puoi taggare qualsiasi oggetto di Git. Nei sorgenti di Git, per esempio, il mantenitore ha aggiunto la sua chiave pubblica GPG come oggetto blob e lo ha taggato. Puoi vedere la chiave pubblica eseguendo

	$ git cat-file blob junio-gpg-pub

nei sorgenti di Git. Anche il kernel di Linux ha un oggetto tag che non punta ad una commit: il primo tag creato punta all'albero iniziale dell'import dei sorgenti.

### Riferimenti remoti ###

Il terzo tipo di riferimento che vedremo è il riferimento remoto. Se aggiungi un repository remoto e poi fai una push, Git salva il valore del quale avete fatto la push, per ogni branch, nella directory `refs/remotes`. Puoi per esempio aggiungere un repository remote di nome `origin`e fare la push del tuo branch `master`:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

E puoi vedere quale era il branch `master` del repository remoto `origin` l'ultima volta che hai comunicato con il server esaminando il file `refs/remotes/origin/master`:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

I riferimenti remoti differiscono dai branch (riferimenti in `refs/heads`) principalmente per il fatto
che non è possibile fare il checkout di quest'ultimi. Git li sposta come segnalibri affinché corrispondano all'ultimo stato conosciuto di quei branch sul server.

## Pacchetti di file ##

Torniamo agli oggetti del database per il tuo repository Git di test. A questo punto hai 11 oggetti: 4 blob, 3 tree, 3 commit, e 1 tag:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git comprime il contenuto di questi file con zlib e, poiché non stai memorizzando molte cose, complessivamente tutti questi file occupano solo 925 bytes. Aggiungeremo al repository del contenuto più pesante per dimostrare un’interessante caratteristica di Git. Aggiungi il file repo.rb dalla libreria Grit che abbiamo visto prima: sono circa 12K di sorgenti:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Se guardi l’albero dopo questa nuova commit, vedrai l’hash SHA-1 che l’oggetto blob per repo.rb:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Puoi quindi usare `git cat-file` per vedere le dimensioni dell’oggetto:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Modifica un po’ il file e guarda che succede:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Verificando l’albero risultate da questa commit vedrai qualcosa d’interessante:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Il blob è un oggetto differente, cioè, nonostante tu abbia aggiunto una sola riga alla fine di un file da 400 righe, Git memorizza il nuovo contenuto come un oggetto completamente nuovo:

	$ du -b .git/objects/05/408d195263d853f09dca71d55116663690c27c
	4109	.git/objects/05/408d195263d853f09dca71d55116663690c27c

Ora hai sul disco due oggetti quasi identici da 4K. Non sarebbe carino se Git potesse memorizzarne solo una per intero e del secondo solo la differenza col primo?

In effetti può farlo. Il formato iniziale con cui Git salva l’oggetto sul disco con un formato cosiddetto sciolto (*loose*). Però, occasionalmente, Git compatta molti di questi oggetti in un singolo file binario detto “pacchetto di file” (*packfile*) per risparmiare spazio ed essere più efficiente. Git lo fa se hai molti oggetti sciolti sparpagliati, se esegui il comando `git gc` o se fai la push verso un server remoto. Puoi farlo manualmente, per vedere cosa succede, eseguendo il comando `git gc`, che forza Git a comprimere gli oggetti:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

Se consulti la directory degli oggetti, vedrai che molti dei tuoi oggetti sono scomparsi, ma ne sono apparsi un paio nuovo:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

Gli oggetti rimanenti sono i blob che non puntano a nessuna commit: in questo caso gli esempi "what is up, doc?" e "test content" creati precedentemente. Poiché non li abbiamo ancora aggiunti a nessuna commit, vengono considerati Because you never added them to any commits, they’re considered dondolanti (*dangling*) e non sono compressi nei pacchetto appena creato.

I nuovi file sono il pacchetto e un indice. Il pacchetto è un singolo file contenente tutti gli altri oggetti che sono stati rimossi dal filesystem. L’indice è un file che contiene gli offset degli oggetti contenuti nel pacchetto per trovare velocemente un oggetto specifico. La cosa interessante è che, sebbene gli oggetti occupassero 12K sul disco prima dell’esecuzione di `gc`, il nuovo pacchetto è di soli 6K. Hai dimezzato lo spazio usato sul disco comprimendo gli oggetti.

Come Git ci riesce? Quando Git comprime gli oggetti, cerca prima i file che hanno lo stesso nome e dimensioni simili, e memorizza solo le differenze tra i singoli file. Puoi controllare dentro il pacchetto e vedere cos’ha fatto Git per risparmiare spazio. Il comando *plumbing* `git verify-pack` ti permette di vedere cos’è stato compresso:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1 \
	  05408d195263d853f09dca71d55116663690c27c
	ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Dove il blob `9bc1d`, che ricorderai era la prima versione del file repo.rb, è referenziato dal blob `05408`, che era la seconda versione. La terza colonna indica la dimensione degli oggetti nel pacchetto, e puoi vedere che `05408` occupa 12K, ma `9bc1d` solo 7 bytes. Un’altra cosa interessante è che la seconda versione del file è quella che è stata memorizzata intatta, mentre della versione originale è stato memorizzata solo il delta: questo perché è molto più probabile che avrai bisogno di accedere più velocemente alla versione più recente di un file.

La cosa ancora più interessante è che può essere ricompresso in qualsiasi momento. Git ricomprime automaticamente il tuo database cercando sempre di risparmiare spazio. Puoi comunque ricomprimere il tuo database manualmente in qualsiasi momento, eseguendo il comando `git gc`.

## Le specifiche di riferimento (*refspec*) ##

In questo libro abbiamo sempre usato delle semplici mappature, dai branch remoti ai riferimenti locali, ma possono essere anche molto più complessi.
Immagina di aggiungere un repository remoto:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

Questo aggiunge una sezione al tuo `.git/config` specificando, del repository remoto, il nome (`origin`), l’URL e le specifiche di riferimento per ottenere le modifiche remote:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Il formato delle specifiche di riferimento è un `+` (opzionale) seguito da `<src>:<dst>`, dove `<src>` è lo schema per i riferimenti remoti e `<dst>` per gli stessi salvati in locale. Il `+` dice a Git di aggiornare i riferimenti anche se non si tratta di un avanti-veloce (*fast-forward*).

Nel caso predefinito, che viene scritto da git quando si usa il comando `git remote add`, Git recupera tutti i riferimenti sul server di `refs/heads/` e li scrive localmente in `refs/remotes/origin/`. Quindi, se hai un branch `master` sul server, puoi accedere localmente al log di questo branch così:

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Sono tutti equivalenti perché Git li espande tutti a `refs/remotes/origin/master`.

Se vuoi, invece di scaricare tutti i branch dal server, Git può scaricare solo il `master` cambiando la riga del fetch così

	fetch = +refs/heads/master:refs/remotes/origin/master

Questa è la specifica di riferimento predefinito per questo repository remoto quando si esegue il comando `git fetch`. Se vuoi fare qualcosa una sola volta, puoi sempre specificare le specifiche di riferimento alla riga di comando. Per fare un *pull* del `master` sul repository remoto dal branch locale `origin/mymaster`, puoi eseguire

	$ git fetch origin master:refs/remotes/origin/mymaster

Puoi anche specificare più specifiche di riferimento alla riga di comando, per fare una *pull* di più branch allo stesso tempo:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In questo caso la *pull* verso il master è stata rifiutata perché non era un riferimento *fast-forward*. Puoi modificare questo comportamento aggiungendo un `+` prima delle specifiche di riferimento.

Puoi anche specificare più specifiche di riferimento nel tuo file di configurazione. Se vuoi prendere sempre il master e il branch sperimentale puoi aggiungere queste due righe:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Non puoi usare schemi parziali, e quindi l’impostazione seguente non è valida:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Ma puoi usare la nomenclatura per ottenere lo stesso risultato. Se hai un gruppo di QA che faccia la *push* di una serie di branch e tu vuoi prendere il master e qualsiasi branch del gruppo di QA e nient’altro, puoi usare questa configurazione:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

Se hai un flusso di lavoro complesso, dove il gruppo di QA e gli sviluppatori fanno la *push* di branch e il gruppo d’integrazione che fa la push e collabora su branch remoti, puoi enumerarli facilmente come abbiamo appena visto.

### Le push con le specifiche di riferimento ###

È bello che tu possa nominare i riferimenti in questo modo, ma come fanno, in primo luogo, i membri del gruppo di QA a mettere i loro branch in `qa/`? Puoi farlo usando le specifiche di riferimento anche per la *push*.

Se il gruppo di QA vuole fare la *push* del loro `master` in `qa/master` sul server remoto, possono eseguire

	$ git push origin master:refs/heads/qa/master

Se vogliono che Git lo faccia automaticamente ogni volta che eseguano `git push origin` basta che aggiungano una riga `push` al loro file di configurazione:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Questo fa si che eseguendo `git push origin`, Git faccia sempre una *push* del `master` locale in `qa/master` del server remoto.

### Eliminare i riferimenti ###

Puoi usare le specifiche di riferimento anche per eliminare dei riferimenti ai server remoti:

	$ git push origin :topic

Poiché il formato delle specifiche è `<src>:<dst>`, omettendo la parte `<src>` è come dire che il branch remoto è “niente” e quindi lo si cancella.

## Transfer Protocols ##

Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate.

### The Dumb Protocol ###

Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library:

	$ git clone http://github.com/schacon/simplegit-progit.git

The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished:

	=> GET HEAD
	ref: refs/heads/master

You need to check out the `master` branch when you’ve completed the process.
At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

That gives you your next commit object. Grab the tree object:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first:

	=> GET objects/info/http-alternates
	(empty file)

If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning.

The entire output of this process looks like this:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### The Smart Protocol ###

The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data.

#### Uploading Data ####

To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side.

For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`).

Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing.

Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side.

Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication:

	000Aunpack ok

#### Downloading Data ####

When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down.

There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it.

If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In either case, after `fetch-pack` connects, `upload-pack` sends back something like this:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone.

At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes.

## Maintenance and Data Recovery ##

Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios.

### Maintenance ###

Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old.

You can run auto gc manually as follows:

	$ git gc --auto

Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively.

The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this:

	$ cat .git/packed-refs
	# pack-refs with: peeled
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file.

Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to.

### Data Recovery ###

At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back?

Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, move the `master` branch back to the middle commit:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right?

Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog.

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again.
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything:

	$ git branch -D recover-branch
	$ rm -Rf .git/logs/

Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `--full` option, it shows you all objects that aren’t pointed to by another object:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA.

### Removing Objects ###

There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there.

This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects.

Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits.

To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — you didn’t want to add a huge tarball to your project. Better get rid of it:

	$ git rm git.tbz2
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Now, `gc` your database and see how much space you’re using:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

You can run the `count-objects` command to quickly see how much space you’re using:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it.

First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `--objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file:

	$ git log --pretty=oneline --branches -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

The `--index-filter` option is similar to the `--tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm --cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `--tree-filter` if you want. The `--ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer.

Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Let’s see how much space you saved.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune --expire`.

## Sommario ##

A questo punto dovresti avere una discreta conoscenza di quello che Git faccia in background e anche un’infarinatura su come è implementato. Questo capitolo ha descritto alcuni comandi *plumbing*: comandi che sono più a basso livello e più semplici dei comandi *porcelain* che hai imparato nel resto del libro. Capire come funziona Git a basso livello dovrebbe renderti più facile comprendere perché sta facendo qualcosa in quel modo, ma anche permetterti di scrivere i tuoi strumenti/script per far funzionare meglio il flusso di lavoro cui sei abituato.

Git, come filesystem indirizzabile per contenuto, è uno strumento molto potente e puoi facilmente usarlo anche per altro che non sia solo uno strumento di gestione dei sorgenti (VCS). Spero che tu possa usare la tua ritrovata conoscenza degli strumenti interni di Git per implementare una tua bellissima applicazione con questa tecnologia e trovarti a tuo agio nell’uso avanzato di Git.
