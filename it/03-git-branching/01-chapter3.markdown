# Git Branching #

Praticamente ogni VCS ha un suo modo di supportare il branching. Branching significa distanziarsi dal flusso principale di sviluppo continuando a lavorare senza correre il rischio di fare pasticci sul flusso principale. In molti strumenti VCS questo è un processo in alcuni termini costoso, spesso richiede la creazione di una nuova copia della directory del codice sorgente che in grandi progetti può richiedere molto tempo.

Molte persone fanno riferimento al modello di branching di Git per indicare la "killer feature", e questo certamente separa Git dagli altri VCS. Perchè è così speciale? Git crea branch in modo incredibilmente semplice e leggero, permettendo operazioni di branching praticamente istantanee come lo sono anche i passaggi da un branch ad un altro. Diversamente da molti altri VCS, Git incoraggia un workflow che sfrutta branch e merge frequentemente, anche molte volte al giorno. Capire e padroneggiare questa funzionalità mette a disposizione uno strumento potente ed unico e può letteralmente modificare il modo in cui si lavora.

## Che cos'è un Branch ##

Per capire veramente il modo con cui Git fa il branching, dobbiamo fare un passo indietro ed esaminare come Git memorizza le sue informazioni. Come puoi ricordare dal capitolo 1, Git non memorizza i dati come una serie di cambiamenti o delta, ma come una serie di istantanee (snapshot).

Quando esegui un commit in Git, Git memorizza un oggetto commit che contiene un riferimento alla snapshot del contenuto che hai inserito, i metadata dell'autore e del messaggio, e zero o più riferimenti al commit (o ai commit) che erano i diretti genitori di questo commit: nessun genitore per il primo commit, un genitore per un commit normale, genitori multipli per un commit che è il risultato di un merge di due o più branches.

Per immaginare questo, presumi di avere una cartella che contiene tre file, li inserisci nell'area di stage ed esegui il commit. Inserendoli nell'area di stage, ad ogni file va aggiunta la checksum (l'hash SHA-1 che abbiamo menzionato nel Capitolo 1), memorizza la versione del file nella repository di Git (Git si riferisce ad essa come blobs), e aggiunge la checksum all'area di stage:

  $ git add README test.rb LICENSE
	$ git commit -m 'commit iniziale del mio progetto'

Quando crei il commit eseguendo `git commit`, Git esegue il checksum per ogni sottocartella (in questo caso, solo la cartella radice (root) del progetto) e salva questi tre oggetti nel repository di Git. Dopo Git crea un oggetto commit che ha i metadata e un puntatore alla radice del progetto in modo che possa ricreare questo snapshot quando necessario.

La tua repository Git ora contiene 5 oggetti: un blob per il contenuto di ognuno dei tuoi tre file, un albero che elenca il contenuto della cartella e specifica quali nomi di file sono memorizzati come blobs, e un commit con il riferimento alla cartella radice e a tutti i metadata del commit. Concettualmente i dati nella tua repository di Git dovrebbero essere organizzato in modo simile alla Figura 3.1:

Insert 18333fig0301.png 
Figura 3-1. Dati di una repository di un singolo commit.

Se fai qualche cambiamento ed esegui nuovamente il commit, il successivo commit memorizza un puntatore al commit che viene immediatamente prima di esso. Dopo due o più commit, la tua storia potrebbe assomigliare a quella della Figura 3-2.

Insert 18333fig0302.png 
Figura 3-2. Dati di un oggetto Git per commit multipli.

Un branch  in Git è semplicemente un leggero puntatore mobile verso uno di questi commit. Il nome del branch di default in Git è master. Iniziando a fare dei commit, ti verrà dato un branch master che punta all'ultimo commit che hai effettuato. Ogni volta che esegui un commit, esso si muove in avanti automaticamente.

Insert 18333fig0303.png 
Figura 3-3. Il branch punta alla storia delle informazioni del commit.

Cosa succede se crei uno nuovo branch? Beh, in questo modo crei un nuovo puntatore per te che si muove. Diciamo che crei un nuovo branch di nome testing. Fai questo con il comando `git branch`

  $ git branch testing

Questo crea un nuovo puntatore allo stesso commit sul quale sei (guarda la Figura 3-4).

Insert 18333fig0304.png 
Figura 3-4. Branch multipli puntano alla storia delle informazioni del commit.

Come fa Git a sapere su quale branch sei attualmente? Esso mantiene uno speciale puntatore chiamato HEAD. Nota che questo è molto differente dal concetto di HEAD in altri VCS che potresti aver usato, come Subversion o CVS. In Git, questo è un puntatore al branch locale sul quale sei attualmente. In questo caso, sei ancora sul master. Il comando `git branch` crea soltanto un nuovo branch - non ti sposta su questo branch (guarda la Figura 3-5).

Insert 18333fig0305.png 
Figura 3-5. L'HEAD del file punta sul branch sul quale sei.

Per spostarti su un branch esistente, esegui il comando `git checkout`. Spostiamoci sul nuovo branch testing:

  $ git checkout testing

Questo sposta l'HEAD, facendolo puntare sul branch testing (guarda la Figura 3-6).

Insert 18333fig0306.png
Figura 3-6. L'HEAD punta ad un altro branch quando sposti i branch.

Cosa significa? Beh, facciamo un altro commit:

  $ vim test.rb
	$ git commit -a -m 'made a change'

La Figura 3-7 illustra il risultato.

Insert 18333fig0307.png 
Figura 3-7. Il branch al quale punta l'HEAD si muove in avanti per ogni commit.

Questo è interessante, perchè ora il tuo branch testing si è mosso in avanti, ma il branch master punta ancora al commit sul quale eri quando hai eseguito `git checkout` per cambiare branch. Spostiamoci nuovamente al branch master:

  $ git checkout master

La Figura 3-8 mostra il risultato:

Insert 18333fig0308.png 
Figura 3-8. L'HEAD si muove in un altro branch con il checkout.

Questo comando ha fatto due cose. Ha spostato il puntatore dell'HEAD nuovamente sul branch master, e ha ripristinato i file nella tua cartella di lavoro allo snapshot al quale il master punta. Questo significa anche che i cambiamenti che fai da questo punto in poi si discosteranno da una più vecchia versione del progetto. Essenzialmente questo riavvolge il lavoro che hai fatto provvisoriamente nel tuo branch testing in modo che tu possa andare in una direzione differente.

Facciamo alcune modifiche ed eseguiamo nuovamente il commit:

  $ vim test.rb
	$ git commit -a -m 'apportate altre modifiche'

Ora la storia del tuo progetto si è discostata (guarda la Figura 3.9). Hai creato e ti sei spostato su un branch, hai fatto un po' di lavoro su di esso, e dopo esserti spostato nuovamente al tuo branch principale hai fatto altro lavoro. Questi due cambiamenti sono isolati in branch separati: puoi spostarti indietro o avanti tra i branch e fonderli insieme quando sei pronto. E hai fatto tutto questo con i semplici comandi `branch` e  `checkout`.

Insert 18333fig0309.png 
Figura 3-9. La storia dei branch sono divergenti.

Dato che un branch in Git è in realtà un semplice file che contiene i 40 caratteri del checksum della codifica SHA-1 del commit a cui punta, i branch sono economici da creare e distruggere. Creare un nuovo branch è veloce è semplice come scrivere 41 byte in un file (40 caratteri e una nuova linea (newline)).

Questo è in netto contrasto con la maggior parte degli strumenti branch dei VCS, che coinvolge la copia di tutti i file del progetto in una seconda cartella. Questo può impiegare parecchi secondi o addirittura minuti, in base alla grandezza del progetto, mentre in Git il processo è sempre istantaneo. Inoltre, poichè stiamo registrando i genitori quando eseguiamo il commit, trovare una base adeguata per il merge è automaticamente fatto per noi ed è veramente facile farlo. Queste caratteristiche aiutano ad incoraggiare gli sviluppatori a creare ed utilizzare i branch spesso.

Vediamo perchè dovreste farlo.

## Operazioni di base di Branch e Merge ##

Facciamo un semplice esempio di branch e merge che si potrebbe utilizzare nel mondo reale. Segui questi passi:

1. Lavora su un sito web.
2. Crea un branch per un nuovo lavoro sul quale stai lavorando.
3. Fai qualche lavoro in questo branch.

A questo punto, ricevi una chiamata, venendo a conoscenza che un altro problema è critico e avrai bisogno di fixarlo. Farai le seguenti operazioni:

1. Tornerai al branch di produzione (il principale).
2. Creerai un branch per aggiungere l'hotfix.
3. Dopo averlo testato, farai un'operazione di merge con il branch, e lo inserirai nella produzione.
4. Tornerai al tuo vecchio lavoro e continuerai a lavorare.

### Operazione di base di Branch ###

Per prima cosa, diciamo che si sta lavorando sul progetto e hai già effettuato un paio di commit (guarda la Figura 3-10).

Insert 18333fig0310.png 
Figura 3-10. Una piccola e semplice storia del commit.

Hai deciso che lavorerai sul problema#53 in base a qualsiasi sistema di tracciamento dei problemi che la vostra azienda utilizza. Per essere chiari, Git non è legato a qualche particolare sistema di tracciamento dei problemi; ma poichè il problema#53 è un argomento mirato sul quale vuoi lavorare, creerai un nuovo branch nel quale poter lavorare. Per creare un branch e spostarti in esso nello stesso tempo, puoi eseguire il comando `git checkout` con l'opzione `-b`:

	$ git checkout -b prob53
	Switched to a new branch "prob53"

Questa è una scorciatoia per:

	$ git branch prob53
	$ git checkout prob53

La Figura 3-11 illustra il risultato.

Insert 18333fig0311.png 
Figure 3-11. Crea un nuovo puntatore del branch.

Lavori sul tuo sito web ed esegui alcuni commit. Facendo questo muovi il branch `prob53` in avanti, perchè lo hai controllato (cioè, il tuo HEAD sta puntando su di esso; guarda la Figura 3-12):

	$ vim index.html
	$ git commit -a -m 'aggiunto un nuovo footer [problema 53]'

Insert 18333fig0312.png 
Figure 3-12. Il branch prob53 è stato spostato in avanti con il tuo lavoro.

Ora ricevi una chiamata con la quale vieni a conoscenza che c'è un problema con il sito web, ed è necessario risolverlo immediatamente. Con Git non avrai bisogno di inserire il fix insieme ai cambiamenti che hai fatto con il `prob53`, e non hai bisogno di sforzarti molto per tornare a questi cambiamenti, prima di poter lavorare su come applicare il fix a ciò che è in produzione. Tutto ciò che devi fare è tornare al branch master:

Comunque prima di fare questo, nota che se la tua cartella di lavoro o la tua area di staging ha dei cambiamenti che non sono stati inseriti in un commit che vanno in conflitto con il branch che stai controllando, Git non ti farà cambiare il branch. È meglio avere uno stato di lavoro pulito quando cambi il branch. Ci sono modi per evitare questo (ovvero l'operazione di stash ed eseguire il commit sulle modifiche) che vedremo in seguito. Per ora, farai il commit per tutte le tue modifiche, così potrai tornare indietro al tuo branch master:

	$ git checkout master
	Switched to branch "master"

A questo punto, la tua cartella di lavoro del progetto è esattamente com'era prima che iniziassi a lavorare sul problema #53, e potrai concentrarti sul tuo hotfix. Questo è un punto importante da ricordare: Git resetta la tua cartella di lavoro facendola diventare come lo snapshot del commit del branch che ti interessa. Esso aggiunge, rimuove, e modifica i file automaticamente assicurandosi che la tua copia di lavoro del branch sia come lo era dopo l'ultimo commit.

Dopo, avrai un hotfix da effettuare. Creiamo un branch hotfix sul quale lavorare finchè non sarà completato (guarda la Figura 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fissato l'indirizzo e-mail errato'
	[hotfix]: created 3a0874c: "fissato l'indirizzo e-mail errato"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figure 3-13. Il branch hotfix è indietro rispetto al tuo branch master.

Potrai eseguire i tuoi test, assicurati che l'hotfix sia come lo vuoi, ed effettua il merge con il tuo branch master per inserirlo nella produzione. Effettui questo con il comando `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)
	 
Noterai la frase "Fast forward" nel merge. Dato che il commit a cui punta il branch si è unito direttamente a monte del commit sul quale sei, Git sposta il puntatore in avanti. Per dirlo in un altro modo, quando provi ad effettuare il merge tra un commit e un commit che può esere raggiunto seguendo la storia del primo commit, Git semplifica le cose muovendo il puntatore in avanti perchè non c'è un lavoro divergente per effettuare il merge - questo è chiamato "fast forward".

Le tue modifiche sono ora nello snapshot del commit a cui punta il branch `master`, ed è possibile distribuire la modifica (Figura 3-14).

Insert 18333fig0314.png 
Figure 3-14. Il tuo branch master punta allo stesso punto del tuo branch hotfix dopo il merge.

Dopo che il tuo super importante fix è distribuito, sei pronto per tornare al lavoro che stavi facendo prima di essere interrotto. Comunque, prima eliminerai il branch `hotfix`, perchè non ne avrai più bisogno - il `master` punta allo stesso punto. Puoi cancellarlo con l'opzione `d` del comando `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Ora puoi tornare al branch del problema #53 e continuare a lavorare su di esso (guarda la Figura 3-15):

	$ git checkout prob53
	Switched to branch "prob53"
	$ vim index.html
	$ git commit -a -m 'Finito il nuovo footer [problema 53]'
	[iss53]: created ad82d7a: "Finito il nuovo footer [problema 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)


Insert 18333fig0315.png 
Figure 3-15. Il tuo branch prob53 può muoversi avanti indipendentemente.

Vale la pena notare che il lavoro che hai fatto nel tuo branch hotfix non è contenuto nel file del tuo ramo `prob53`. Se hai bisogno di inserirlo, puoi fare il merge tra il branch `master` e il tuo branch `prob53` eseguendo `git merge master`, o puoi aspettare di integrare queste modifiche finchè non deciderai di unire il branch `prob53` all'interno del branch `master`.