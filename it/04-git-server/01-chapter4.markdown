# Git sul server #

A questo punto, si dovrebbe essere in grado di fare la maggior parte dei compiti quotidiani che si devono fare con Git. Tuttavia, al fine di fare una qualsiasi collaborazione in Git, bisogna avere un repository remoto Git. Anche se è possibile tecnicamente spingere modifiche e tirare le modifiche da repository individuali, procedere in questo modo è sconsigliato, perché se non si sta attenti, ci si può confondere abbastanza facilmente riguardo a quello su cui si sta lavorando. Inoltre, si vuole che i collaboratori siano in grado di accedere al repository, anche se il computer non è in linea - avere un repository comune più affidabile spesso è utile. Pertanto, il metodo preferito per collaborare con qualcuno, è quello di creare un repository intermedio a cui avere accesso entrambi e spingere e tirare da questo. Si farà riferimento a questo repository come un "server Git"; ma si noterà che in genere ospitare un repository Git ha bisogno di una piccola quantità di risorse, quindi raramente c'è bisogno di usare un intero server per esso.

Avviare un server Git è semplice. In primo luogo, si sceglie quali protocolli si desidera utilizzare per comunicare con il server. La prima sezione di questo capitolo descriverà i protocolli disponibili con i pro e i contro di ciascuno. La sezione seguente spiegherà alcune impostazioni tipiche nell'utilizzo di questi protocolli e come utilizzarle nel proprio server. Infine, se non si hanno problemi a fare ospitare il proprio codice su un server di qualcun altro e se si vuole dedicare del tempo alla creazione e al mantenimento di un proprio server, si prenderà in considerazione qualche opzione per l'hosting.

Se non si ha interesse a gestire il proprio server, è possibile passare all'ultima sezione del capitolo per vedere alcune opzioni per la creazione di un account hosting e poi saltare al capitolo successivo, dove si discutono i flussi in ingresso e uscita in un ambiente distribuito per il controllo del codice sorgente. 

Un repository remoto è in genere un _bare repository_ cioè un repository Git che non ha la cartella di lavoro. Essendo che il repository viene utilizzato solo come un punto di collaborazione, non c'è ragione di avere uno snapshot estratto dal disco, ma solo i dati Git. In termini più semplici, un repository nudo è il contenuto della cartella `.git` del progetto e nient'altro.

## I protocolli ##

Git può utilizzare quattro importanti protocolli di rete per trasferire i dati: locale, Secure Shell (SSH), Git, e HTTP. Qui vedremo cosa sono e in quali circostanze di base si vuole (o non si vuole) usarli.

E' importante notare che, ad eccezione dei protocolli HTTP, tutti questi richiedono che Git sia installato e funzionante sul server.

### Il protocollo locale ###

Quello più semplice è il _protocollo locale_, in cui il repository remoto è in un'altra cartella sul disco. Questo è spesso utilizzato se ciascuno nel team ha accesso a un file system condiviso come l'NFS, o, nel caso meno probabile tutti accedano allo stesso computer. Quest'ultimo caso non è l'ideale, perché tutte le istanze del codice nel repository risiederebbero sullo stesso computer, facendo diventare molto più probabile una perdita catastrofica dei dati.

Se si dispone di un filesystem montato in comune, allora si può clonare, fare un push, e un pull da un repository locale basato su file. Per clonare un repository come questo o per aggiungerne uno da remoto per un progetto esistente, utilizzare il percorso al repository come URL. Ad esempio, per clonare un repository locale, è possibile eseguire qualcosa di simile a questo:

	$ git clone /opt/git/project.git

O questo:

	$ git clone file:///opt/git/project.git

Git funziona in modo leggermente diverso se si specifica esplicitamente `file://` all'inizio dell'URL. Se si specifica il percorso, Git tenta di utilizzare hardlink o copia direttamente i file necessari. Se si specifica file://`, Git abilita i processi che utilizza normalmente per trasferire i dati su una rete, il che è generalmente un metodo molto meno efficace per il trasferimento dei dati. La ragione principale per specificare il prefisso `file://`  è quella in cui si desidera una copia pulita del repository, lasciando fuori riferimenti estranei o oggetti - in genere dopo l'importazione da un altro sistema di controllo della versione o qualcosa di simile (si veda il Capitolo 9 relativo ai task per la manutenzione). Qui verrà usato il percorso normale, perché così facendo è quasi sempre più veloce.
