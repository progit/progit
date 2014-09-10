# I comandi interni di Git #

Forse sei saltato a questo capitolo da uno precedente, o dopo aver letto il resto del libro. In ogni caso qui approfondiremo il funzionamento interno e l'implementazione di Git. Ho pensato che queste informazioni fossero fondamentali per capire quanto Git fosse utile e potente, ma qualcuno ha argomentato che queste potessero essere complesse e non necessariamente utili per i principianti.
Per questo motivo ho deciso di includere queste informazioni nell'ultimo capitolo del libro di modo che la possa leggere nella fase dell'apprendimento che ritieni più opportuna. Lascio a te la scelta.

Dato che sei qui, possiamo partire. Per prima cosa, se non è ancora chiaro, Git è fondamentalmente un filesystem indirizzabile per contenuto sul quale si appoggia una interfaccia utente VCS. Tra breve imparerai meglio cosa significhi.

Nelle prime versioni di Git (principalmente pre 1.5) l'interfaccia utente era molto più complessa perché veniva privilegiato il filesystem rispetto ad avere un VCS pulito. Negli ultimi anni l'interfaccia utente è stata rifinita fino a diventare chiara e facile da usare come gli altri sistemi disponibili, ma è rimasto lo stereotipo che l'interfaccia di Git sia complessa e difficile da capire.

Il filesystem indirizzabile per contenuto è veramente formidabile, quindi in questo capitolo inizierò parlandone. Imparerai quindi il meccanismo di trasporto e le attività per la manutenzione del repository con le potresti dover aver a che fare.

## Impianto e sanitari (*Plumbing* e *Porcelain*) ##

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

	    terza commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    seconda commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    prima commit

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
	1a410efbd13591db07496601ebc7a059dd55cfe9 terza commit
	cac0cab538b970a37ea1e769cbbde608743bc96d seconda commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d prima commit

Questo però non ti incoraggia a modificare direttamente i file di riferimento. Git fornisce un comando sicuro per farlo se vuoi aggiornare un riferimento, chiamato `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Questo è quello che si definisce branch in Git: un semplice puntatore o riferimento all’intestazione di un flusso di lavoro. Per creare un branch con la seconda commit, così:

	$ git update-ref refs/heads/test cac0ca

Il tuo branch conterrà solo il lavoro da quella commit in poi:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d seconda commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d prima commit

Ora, il tuo database Git assomiglia concettualmente alla Figura 9-4.

Insert 18333fig0904.png 
Figura 9-4. La directory degli oggetti Git directory con inclusi i riferimenti branch e head.

Quando esegui comandi come `git branch (branchname)`, Git in realtà esegue il comando `update-ref` per aggiungere lo SHA-1 dell'ultima commit del branch nel quale siete, in qualsiasi nuovo riferimento vogliate creare.

Se Git non trova un riferimento nella directory `refs` lo cercherà nel file `.git/packed-refs`, che contiene coppie di percorsi con i relativi SHA-1. Per esempio:

    52d771167707552d8e2a50f602c669e2ad135722 refs/tags/v1.0.1

Questo file esiste per motivi di prestazioni, perché, per riferimenti che non cambiano spesso, è molto più efficiente avere un unico file, piuttosto che tanti piccolissimi. Puoi far comprimere a Git i riferimenti in questo file con il comando `git pack-refs`.

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

	$ curl -L http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m ‘aggiunto repo.rb'
	[master 484a592] aggiunto repo.rb
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
	$ git commit -am 'modificato un poco il repository'
	[master ab1afef] modificato un poco il repository
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

Git come ci riesce? Quando Git comprime gli oggetti, cerca prima i file che hanno lo stesso nome e dimensioni simili, e memorizza solo le differenze tra i singoli file. Puoi controllare dentro il pacchetto e vedere cos’ha fatto Git per risparmiare spazio. Il comando *plumbing* `git verify-pack` ti permette di vedere cos’è stato compresso:

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

## Protocolli di trasferimento ##

Git può trasferire i dati tra i repository principalmente in due modi: attraverso l’HTTP e i c.d. protocolli intelligenti come usati da `file://`, `ssh://`, e `git://`. Questa sezione mostra rapidamente come funzionano questi protocolli.

### Il protocollo muto ###

Il trasferimento di Git attraverso l’HTTP viene spesso anche definito come protocollo muto perché non richiede di eseguire nessun codice specifico di Git durante il processo di trasferimento. Il processo per prendere gli aggiornamenti consiste in una serie di richieste GET, con il client che presuppone la struttura del repository Git sul server. Seguiamo il processo `http-fetch` per la libreria simplegit:

	$ git clone http://github.com/schacon/simplegit-progit.git

La prima cosa che fa questo comando è scaricare il file `info/refs` che viene scritto dal comando `update-server-info`, che è il motivo per cui hai bisogno di abilitare l’hook `post-receive` perché il trasferimento su HTTP funzioni bene:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Ora hai una lista dei riferimenti remoti e dei vari hash SHA e cerchi quindi a cosa fa riferimento l’HEAD per sapere di cosa devi fare il check out quando avrai finito:

	=> GET HEAD
	ref: refs/heads/master

Dovrai quindi fare il check out del `master` quando avrai finito di scaricare tutto.
A questo punto sei pronti per iniziare il processo. Poiché il tuo punto di partenza è la commit `ca82a6`, che abbiamo trovato nel file `info/refs`, inizierai scaricandola così:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

Riceverai un oggetto, che sul server è in formato sciolto, attraverso una richiesta GET del protocollo HTTP. Puoi decomprimere l’oggetto con zlib, rimuovere l’intestazione e vedere il contenuto della commit:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Ora hai altri due oggetti da scaricare: `cfda3b`, che è l’albero a cui fa riferimento la commit che abbiamo appena scaricato, e `085bb3`, che è la commit precedente:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

Che ti restituisce il seguente oggetto commit e scarica l’albero:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Non trovato)

Oops: sembra che l’oggetto sul server non sia in formato sciolto, e per questo hai ricevuto un errore 404. Ci sono un paio di ragioni per cui questo possa accadere: l’oggetto potrebbe essere in un altro repository o potrebbe essere in un pacchetto (*packfile*). Git cerca prima la lista dei repository alternativi:

	=> GET objects/info/http-alternates
	(file vuoto)

E se questa restituisce una lista di URL alternativi, Git cerca sui repository elencati i file sciolti e i pacchetti: questo è un buon meccanismo per progetti che sono uno la biforcazione dell’altro per condividere gli oggetti sul disco. Poiché però nel nostro caso  non c’è nessun repository alternativo, l’oggetto che cerchiamo dev’essere in un pacchetto. Per sapere quali pacchetti sono disponibili sul server, devi scaricare il file `objects/info/packs`, che contiene la lista di tutti i pacchetti (questo file viene generato anche da `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Sul nostro server c’è un solo pacchetto, quindi il nostro oggetto è ovviamente lì, ma cercheremo l’indice per esserne sicuri. Questo è utile nel caso abbia più pacchetti sul server, così puoi scoprire quale pacchetto contiene l’oggetto di cui hai bisogno:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Ora che hai l’indice del pacchetto, puoi vedere quali oggetti contiene perché questo contiene tutti gli hash SHA degli oggetti contenuti nel pacchetto e gli offset degli oggetti. L’oggetto è lì e quindi scaricheremo l’intero pacchetto:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Hai tre oggetti albero e puoi quindi continuare a percorrere le commit. Sono tutte nello stesso pacchetto che hai appena scaricato, così non devi fare ulteriori richieste al tuo server. Git crea una copia di lavoro con un check out del branch `master` riferito dal puntatore HEAD che hai scaricato all’inizio.

L’intero output di questo processo appare così:

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

### Protocolli intelligenti ###

Usare l’HTTP è un metodo semplice ma inefficiente. È molto più comune usare i protocolli intelligenti per il trasferimento dei dati. Questi protocolli usano un processo sul server remoto che conosce Git intelligentemente: possono leggere i dati locali e capire quali dati sono già sul client e quali devono invece essere trasferiti e generare quindi un flusso di dati personalizzato. Ci sono due gruppi di processi per trasferire i dati: una coppia per inviarli e una per scaricarli.

#### Inviare dati ####

Per inviare dati a un server remoto, Git usa i processi `send-pack` e `receive-pack`. Il processo `send-pack` viene eseguito sul client e lo connette al processo `receive-pack` sul server remoto.

Diciamo, per esempio, che esegui il comando `git push origin master` nel tuo progetto, e `origin` è un URL che usa il protocollo SSH. Git avvia il processo `send-pack` che stabilisce una connessione al server con SSH e cerca di eseguire un comando sul server attraverso SSH:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Il comando `git-receive-pack` risponde immediatamente con una riga per ogni riferimento che memorizza (in questo caso solo il branch `master` e i suoi hash SHA). La prima riga indica anche quali sono le operazioni possibili sul server (nel nostro caso `report-status` e `delete-refs`).

Ogni riga inizia con un valore esadecimale da 4 byte che specifica la lunghezza del resto della riga. La nostra prima riga inizia con 005b, ovvero 91 in esadecimale, che significa che su questa riga restano altri 91 bytes. La riga successiva inizia con 003e, ovvero 62, e quindi leggerai gli altri 62 bytes. La riga successiva è 0000, che significa che la lista dei riferimenti sul server è finita.

Ora che conosce lo stato del server, il tuo processo `send-pack` determina quali commit hai in locale e quali no. Per ogni riferimento che verrà aggiornato con questa push, il processo `send-pack` invia le informazioni al processo `receive-pack`. Per esempio, se stai aggiornando il branch `master` e aggiungendo il branch `experiment`, la risposta del `send-pack` sarà più o meno così:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

L’hash SHA-1 di tutti '0' significa che prima non c’era niente, perché stiamo aggiungendo il riferimento al branch sperimentale. Se invece stai cancellando un riferimento, vedrai l’opposto: gli ‘0’ saranno sul lato destro.

Git invia una riga per ogni riferimento che si sta aggiornando con l’SHA precedente, il nuovo e il riferimento che si sta aggiornando. La prima riga indica anche le operazioni possibili sul client. Il client invia al server un pacchetto con tutti gli oggetti che non ci sono ancora sul server e il server conclude il trasferimento indicando che il trasferimento è andato a buon fine o è fallito):

	000Aunpack ok

#### Scaricare dati ####

Quando scarichi dei dati vengono invocati i processi `fetch-pack` e `upload-pack`. Il client avvia il processo `fetch-pack` che si connette al processo `upload-pack`, sul server remoto, per definire i dati che dovranno essere scaricati.

Ci sono diversi modi per avviare il processo `upload-pack` sul repository remote. Puoi eseguirlo con SSH, come abbiamo fatto per il processo `receive-pack`, ma puoi anche avviarlo con il demone Git, che si mette in ascolto sulla porta 9418. Una volta connesso, il processo `fetch-pack` invia al demone remoto una serie di dati che assomigliano a questi:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Inizia con 4 byte che indicano la quantità dei dati che seguiranno, quindi il comando da eseguire seguito da un byte *null* quindi il nome del server seguito da un altro byte *null*. Il demone Git verifica che il comando richiesto possa essere eseguito, che il repository esista e che sia accessibile pubblicamente. Se tutto va bene, avvia processo `upload-pack` e gli passa il controllo della request.

Se stai prendendo i dati con l’SSH, `fetch-pack` eseguirà qualcosa del genere:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In entrambi i casi, dopo la connessione di `fetch-pack`, `upload-pack` restituisce qualcosa del genere:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

Questa risposta è simile a quella di `receive-pack`, ma ha delle caratteristiche diverse. Invia, in aggiunta, il riferimento all’HEAD così che se si sta facendo un clone, il client sappia di cosa debba fare il checkout.

A questo punto il processo `fetch-pack` cerca quali oggetti ha già e risponde indicando gli oggetti di cui ha bisogno, inviando un "want" (voglio) e gli SHA che vuole. Invia anche gli hash degli oggetti che ha già, preceduti da "have" (ho). Alla fine di questa lista scrive "done" (fatto), per invitare il processo `upload-pack` a inviare il pacchetto con i dati di cui hai bisogno:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

Questo è il caso più semplice del protocollo di trasferimento. Nei casi più complessi il client supporta anche i metodi `multi_ack` o `side-band`, ma questo esempio mostra l’andirivieni dei processi del protocollo intelligente.

## Manutenzione e recupero dei dati ##

A volte può essere necessario fare un po’ di pulizia del repository per renderlo più compatto, per ripulire un repository importato o recuperare del lavoro che è andato perso. Questa sezione tratta alcuni di questi scenari.

### Manutenzione ###

Git, occasionalmente, esegue automaticamente il comando "auto gc". Il più delle volte questo comando non fa niente, ma se ci sono troppi oggetti sciolti (oggetti che non sono compressi in un pacchetto) o troppi pacchetti, Git esegue un vero e proprio `git gc`. `gc` sta per *garbage collect* (raccolta della spazzatura), e il comando fa una serie di cose:: raccoglie tutti gli oggetti sciolti e li compatta in un pacchetto, consolida i pacchetti in un pacchetto più grande e cancella gli oggetti che non sono raggiungibili da nessuna commit e siano più vecchi di qualche mese.

Puoi eseguire il comando “auto gc” così:

	$ git gc --auto

Questo, lo ripetiamo, generalmente non farà niente: dovrai avere circa 7.000 oggetti sciolti o più di 50 pacchetti perché Git esegua la garbage collection vera e propria. Puoi modificare questi limiti cambiando, rispettivamente, i valori di `gc.auto` e `gc.autopacklimit` delle tue configurazioni.

Un’altra cosa che fa `gc` è quella di impacchettare i tuoi riferimenti in un singolo file. Immagina che il tuo repository contenga i branch e i tag seguenti:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

Se esegui `git gc` non avrai più questi file nella directory `refs` perché Git li sposterà, in nome dell’efficienza, in un file chiamato `.git/packed-refs`, che apparirà così:

	$ cat .git/packed-refs
	# pack-refs with: peeled
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

Se aggiorni un riferimento, Git non modificherà questo file, ma scriverà un nuovo file nella directory `refs/heads`. Per conoscere l’hash SHA di uno specifico riferimento, Git controlla se è nella directory `refs` e poi nel file `packed-refs` se non lo trova. In ogni caso, se non trovi un riferimento nella directory `refs`, questo sarà probabilmente sarà nel file `packed-refs`.

Nota l’ultima riga del file, quella che inizia con un `^`. Questo indica che il tag immediatamente precedente è un tag annotato e che quella linea è la commit a cui punta il tag annotato.

### Recupero dei dati ###

Durante il tuo lavoro quotidiano può capitare che, accidentalmente, perda una commit. Questo generalmente succede quando forzi la cancellazione di un branch su cui hai lavorato e poi scopri di averne bisogno, o quando fai un hard-reset di un branch, abbandonando quindi delle commit da cui poi vorrai qualcosa. Ipotizzando che sia successo proprio questo: come fai a ripristinare le commit perse?

Qui c’è un esempio di un hard-resets del master nel tuo repository di test su una vecchia commit e recuperare poi le commit perse. Prima di tutto verifica lo stato del tuo repository:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modificato un poco il repository
	484a59275031909e19aadb7c92262719cfcdf19a aggiunto repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 terza commit
	cac0cab538b970a37ea1e769cbbde608743bc96d seconda commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d prima commit

Muovi ora il branch `master` a una commit centrale:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef terza commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 terza commit
	cac0cab538b970a37ea1e769cbbde608743bc96d seconda commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d prima commit

Così facendo hai perso le due commit più recenti: questa commit non sono più raggiungibili in nessun modo. Devi scoprire l’hash SHA dell’ultima commit e aggiungere quindi un branch che vi punti. Il trucco è trovare l’hash SHA dell’ultima commit: non è come lo ricordavi, vero?

Spesso il modo più veloce è usare `git reflog`. Mentre lavori Git memorizza silenziosamente lo stato del tuo HEAD ogni volta che lo cambi. Il reflog viene aggiornato ogni volta che fai una commit o cambi un branch. Il reflog viene aggiornato anche dal comando `git update-ref`, che è un’altra buona ragione per usarlo, invece di scrivere direttamente il valore dell’SHA nei tuoi file ref, come abbiamo visto nella sezione “I Riferimenti di Git" in questo stesso capitolo. Eseguendo `git reflog` puoi vedere dov’eri in qualsiasi dato momento:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Qui vediamo le due commit di cui abbiamo fatto il checkout, ma qui non ci sono poi tante informazioni. Per vedere le stesse informazioni, ma in una maniera più utile, possiamo eseguire il comando `git log -g`, che restituisce un output normale del tuo reflog.

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    terza commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modificato un poco il repository

It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modificato un poco il repository
	484a59275031909e19aadb7c92262719cfcdf19a aggiunto repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 terza commit
	cac0cab538b970a37ea1e769cbbde608743bc96d seconda commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d prima commit

Bello: ora sembra che tu abbia un branch chiamato `recover-branch` dov’era il tuo branch `master` precedentemente, rendendo nuovamente raggiungibili le due commit.
Immagina che le commit perse, per qualche ragione, non appaiano nel reflog: puoi simularlo cancellando il branch `recover-branch` e il reflog. Ora le due commit non sono più raggiungibili da niente:

	$ git branch -D recover-branch
	$ rm -Rf .git/logs/

Poiché i dati del reflog è conservato nella directory `.git/logs/`, ora effettivamente non hai nessun reflog. A questo punto come possiamo recuperare la commit? Uno dei modi è usare l’utility `git fsck`, che verifica l’integrità del database del tuo repository. Se lo esegui con l’opzione `--full` ti mostrerà tutti gli oggetti che non sono collegati a nessun altro oggetto:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In questo caso rivediamo la commit scomparsa dopo la *dangling commit* e la puoi recuperare creando un branch che punti  al suo SHA.

### Eliminare oggetti ###

Ci sono un sacco di grandi cose in Git, ma una delle caratteristiche che può creare qualche problemi è che la `git clone` scarica l’intera storia di un progetto, inclusa ciascuna versione di ciascun file. Questo va bene se sono tutti sorgenti perché Git è super ottimizzato per comprimere questi dati in modo molto efficiente. Se però qualcuno in qualche momento ha aggiunto un file molto grande, ogni clone scaricherà quel file grande, anche se poi quel file è stato cancellato da una commit successiva. Poiché è raggiungibile nella cronologia, resterà sempre lì.

Questo è un grosso problema se stai convertendo a Git dei repository da Subversion o Perforce, perché in quei sistemi questo tipo di aggiunte non crea dei grandi problemi, perché non scarichi l’intera cronologia. Se hai importato i sorgenti da un altro sistema o ti rendi conto che il tuo repository è molto più grande di quello che dovrebbe, di seguito scoprirai come eliminare gli oggetti di grandi dimensioni.

Fai attenzione: questa tecnica è distruttiva per la cronologia delle tue commit. Riscrive tutte le commit a partire dal primo albero che devi modificare per rimuovere il riferimento a quel file. Se lo fai subito dopo una importazione, prima che chiunque altro inizi a lavorarci, non c’è nessun problema, altrimenti dovrai avvisare tutti i collaboratori perché ribasino il loro lavoro sulle nuove commit.

Come dimostrazioni aggiungerai un file grande nel tuo repository di test, lo rimuoverai con la commit successiva, lo cercherai e lo rimuoverai permanentemente dal repository. Prima di tutto aggiungi un file grande alla cronologia del tuo repository:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops: non volevi aggiungere questo archivio così grande al tuo progetto. Meglio rimediare:

	$ git rm git.tbz2
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Esegui ora `gc` sul tuo database e guarda quanto spazio stai usando:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

Puoi eseguire anche il comando `count-objects` per vedere lo spazio che stai usando:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

Il valore di `size-pack` è la dimensione del packfiles in kilobytes e quindi stai usando 2MB mentre prima dell’ultima commit usavi circa 2K. Cancellando il file dell’ultima commit ovviamente non lo elimina dalla cronologia e ogni volta che qualcuno colmerà il repository, dovrà scaricare tutti i 2MB avere questo progettino, solamente perché hai aggiunto per errore questo file grande. Vediamo di risolverlo.

Prima di tutto devi trovare il file. In questo caso già sappiamo quale sia, ma supponiamo di non saperlo: come possiamo trovare quale file o quali file occupano tanto spazio? Se esegui `git gc` tutti gli oggetti saranno in un pacchetto e puoi trovare gli oggetti più grandi eseguendo un altro comando *plumbing*, `git verify-pack`, e ordinarli in base al terzo campo dell’output, che indica la dimensione. Puoi anche concatenarlo in *pipe* con `tail` perché siamo interessati solo agli file più grandi:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

L’oggetto grande è alla fine della lista: 2MB. Per scoprire di quale file si tratti useremo il comando `rev-list` che abbiamo già visto rapidamente nel Capitolo 7. Se usi l’opzione `--objects` a `rev-list`, elencherà tutti gli hash SHAs delle commit e dei blob SHAs che facciano riferimento al percorso del file. Puoi trovare il nome del blog così:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Ora dobbiamo rimuovere questo file da tutti gli alberi della cronologia. Puoi vedere facilmente quali commit hanno modificato questo file:

	$ git log --pretty=oneline --branches -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Ora, per rimuovere completamente questo file dalla cronologia di Git, devi riscrivere tutte le commit successive la `6df76` e per farlo useremo `filter-branch`, che hai già usato nel Capitolo 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

L’opzione `--index-filter` è simile alla `--tree-filter` usata nel Capitolo 6, ad eccezione del fatto che invece di passare un comando che modifichi i file sul disco, modifichi la tua area di staging o l’indice ad ogni iterazione. Piuttosto che rimuovere un file con qualcosa simile a `rm file` dovrai rimuoverlo con `git rm --cached`, perché devi rimuoverlo dall’indice e non dal disco. Il motivo per farlo in questo modo è che è più veloce, perché Git non deve fare il checkout di ciascuna versione prima di eseguire il tuo filtro, e quindi tutto il processo è molto più veloce. Se preferisci, puoi ottenere lo stesso risultato con `--tree-filter`. L’opzione `--ignore-unmatch` di `git rm` serve a far si che non venga generato un errore se il file che stai cercando di eliminare non c’è in quella versione. Puoi, infine chiedere a `filter-branch` di riscrivere la cronologia solo a partire dalla commit `6df7640`, perché già sappiamo che è lì che ha avuto inizio il problema. Altrimenti inizierebbe dall’inizio e sarebbe inutilmente più lento.

La tua cronologia ora non ha più alcun riferimento a quel file, ma lo fanno il tuo reflog e un nuovo gruppo di riferimenti che Git ha aggiunto quando hai eseguito `filter-branch` in `.git/refs/original`, e quindi devi rimuovere anche questi e ricomprimere il database. Ma devi correggere qualsiasi cosa che ancora punti a quelle vecchie commit, prima di ricompattare il repository:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Vediamo ora quanto spazio hai recuperato.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

Le dimensioni del repository compresso sono ora di 7K, che è molto meglio dei 2MB precedenti. Dalle dimensioni puoi vedere che l’oggetto è ancora presente tra gli oggetti sciolti, quindi non è ancora sparito, ma non verrà più trasferito quando farai una push o se qualcun altro farà un clone, che è la cosa più importante. Se vuoi comunque eliminare definitivamente l’oggetto potrai farlo eseguendo il comando `git prune --expire`.

## Sommario ##

A questo punto dovresti avere una discreta conoscenza di quello che Git faccia in background e anche un’infarinatura su come è implementato. Questo capitolo ha descritto alcuni comandi *plumbing*: comandi che sono più a basso livello e più semplici dei comandi *porcelain* che hai imparato nel resto del libro. Capire come funziona Git a basso livello dovrebbe renderti più facile comprendere perché sta facendo qualcosa in quel modo, ma anche permetterti di scrivere i tuoi strumenti/script per far funzionare meglio il flusso di lavoro cui sei abituato.

Git, come filesystem indirizzabile per contenuto, è uno strumento molto potente e puoi facilmente usarlo anche per altro che non sia solo uno strumento di gestione dei sorgenti (VCS). Spero che tu possa usare la tua ritrovata conoscenza degli strumenti interni di Git per implementare una tua bellissima applicazione con questa tecnologia e trovarti a tuo agio nell’uso avanzato di Git.
