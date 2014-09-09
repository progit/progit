# Diramazioni in Git #

Praticamente ogni VCS ha un suo modo di supportare le diramazioni. Diramazione significa divergere dal flusso principale di sviluppo continuando a lavorare senza correre il rischio senza pasticciare il flusso principale. In molti strumenti VCS questo è un processo per certi versi dispendioso, spesso richiede la creazione di una nuova copia della directory del codice sorgente che in grandi progetti può richiedere molto tempo.

Molte persone fanno riferimento al modello di diramazioni di Git indicandola come la “caratteristica vincente“, e questo certamente separa Git dagli altri VCS. Perché è così speciale? Git crea ramificazioni in modo incredibilmente semplice e leggero, permettendo operazioni di diramazione praticamente istantanee come lo sono anche i passaggi da un ramo ad un altro. Diversamente da molti altri VCS, Git incoraggia un metodo di lavoro che sfrutta le ramificazioni e le unioni frequentemente, anche molte volte al giorno. Capire e padroneggiare questa funzionalità mette a disposizione uno strumento potente ed unico e può letteralmente modificare il modo in cui si lavora.

## Cos'è un Ramo ##

Per capire realmente come Git sfrutta le diramazioni, dobbiamo tornare un attimo indietro ed esaminare come Git immagazzina i dati. Come ricorderai dal Capitolo 1, Git non salva i dati come una serie di cambiamenti o codifiche delta, ma come una serie di istantanee.

Quando fai un commit con Git, Git immagazzina un oggetto commit che contiene un puntatore all'istantanea del contenuto di ciò che hai parcheggiato, l'autore ed il messaggio, e zero o più puntatori al o ai commit che sono i diretti genitori del commit: zero genitori per il primo commit, un genitore per un commit normale, e più genitori per un commit che risulta da una fusione di due o più rami.

Per visualizzarli, assumiamo che tu abbia una directory con tre file, li parcheggi ed esegui il commit. Parcheggiando il checksum di ogni singolo file (abbiamo parlato dell'hash SHA-1 nel Capitolo 1), salviamo la versione del file nel repository Git (Git fa riferimento ad essi come blob), e aggiunge questi checksum all'area di staging, o di parcheggio:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Quando crei il commit lanciado `git commit`, Git calcola il checksum di ogni directory (in questo caso, solamente la directory radice del progetto) e salva questi tre oggetti nel repository Git. Git poi crea un commit dell'oggetto che ha i metadati ed un puntatore alla radice dell'albero del progetto in maniera da ricreare l'istantanea quando si vuole.

Il tuo repository Git ora contiene cinque oggetti: un blob per i contenuti di ogni singolo file nell'albero, un albero che elenca i contenuti della directory e specifica i nomi dei file che devono essere salvati come blob, e un commit con il puntatore alla radice dell'albero e a tutti i metadati del commit. Concettualmente, i dati nel tuo repository Git assomigliano alla Figura 3-1. 

Insert 18333fig0301.png 
Figura 3-1. Dati di un singolo commit nel repository.

Se fai dei cambiamenti ed esegui il commit nuovamente, il commit successivo immagazzinerà un puntatore al commit che lo precede. Dopo due o più invii, la tua storia assomiglierà a qualcosa di simile alla Figura 3-2.

Insert 18333fig0302.png 
Figura 3-2. Dati di Git per commit multipli.

In Git un ramo è semplicemente un puntatore ad uno di questi commit. Il nome del ramo principale in Git è master. Quando inizi a fare dei commit, li stai dando al ramo master che punterà all'ultimo commit che hai eseguito. Ogni volta che invierai un commit, lui si sposterà in avanti automaticamente.

Insert 18333fig0303.png 
Figura 3-3. Ramo che punta alla storia dei commit dei dati.

Cosa succede se crei un nuovo ramo? Beh, farlo crea un nuovo puntatore che tu puoi muovere. Diciamo che crei un ramo chiamato testing. Lo farai con il comando `git branch`:

	$ git branch testing

Questo creerà un nuovo puntatore al commit in cui tu ti trovi correntemente (vedi Figura 3-4).

Insert 18333fig0304.png 
Figura 3-4. Rami multipli che puntano alla storia dei commit dei dati.

Come fa Git a sapere in quale ramo ti trovi ora? Lui mantiene uno speciale puntatore chiamato HEAD. Nota che questo è differente dal concetto di HEAD di altri VCSs che potresti aver usato in passato, come Subversion o CVS. In Git, è un puntatore al ramo locale su cui ti trovi. In questo caso sei ancora sul ramo master. Il comando git branch ha solamente creato un nuovo ramo — non si è spostato in questo ramo (vedi Figura 3-5).

Insert 18333fig0305.png 
Figura 3-5. Il file HEAD punta al ramo in cui ti trovi ora.

Per spostarsi in un ramo preesistente, devi usare il comando `git checkout`. Dunque spostati nel ramo testing:

	$ git checkout testing

Questo sposterà il puntatore HEAD al ramo testing (vedi Figura 3-6).

Insert 18333fig0306.png
Figura 3-6. HEAD punta ad un altro ramo dopo che ti sei spostato.

Qual'è il significato di tutto questo? Beh, facciamo un altro commit:

	$ vim test.rb
	$ git commit -a -m 'made a change'

La Figura 3-7 illustra il risultato.

Insert 18333fig0307.png 
Figura 3-7. Il ramo a cui punta HEAD si muoverà avanti ad ogni commit.

Questo è interessante, perché ora il tuo ramo testing è stato spostato in avanti, ma il tuo ramo master punta ancora al commit in cui ti trovavi prima di spostarti di ramo con `git checkout`. Ora torna indietro al ramo master:

	$ git checkout master

La Figura 3-8 mostra il risultato.

Insert 18333fig0308.png 
Figura 3-8. HEAD si è spostato ad un altro ramo con un checkout.

Questo comando ha fatto due cose. Ha spostato il puntatore HEAD indietro per puntare al ramo master e ha riportato i file nella tua directory di lavoro allo stato in cui si trovavano in quel momento. Questo significa anche che i cambiamenti che farai da questo punto in poi saranno separati da una versione più vecchia del progetto. Essenzialmente riavvolge temporaneamente il lavoro che hai fatto nel tuo ramo testing così puoi muoverti in una direzione differente.

Fai ora un po' di modifiche ed esegui ancora un commit:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Ora la storia del tuo progetto è separata (vedi Figura 3-9). Hai creato e ti sei spostato in un ramo, hai fatto un lavoro in esso e poi sei tornato sul ramo principale e hai fatto dell'altro lavoro. Entrambi questi cambiamenti sono isolati in rami separati: puoi spostarti indietro o in avanti fra i rami e poi fonderli assieme quando sarai pronto. E puoi farlo semplicemente con i comandi `branch` e `checkout`.

Insert 18333fig0309.png 
Figura 3-9. Le storie dei rami sono separate.

Dato che un ramo in Git è semplicemente un file che contiene 40 caratteri di un checksum SHA-1 del commit al quale punta, i rami si possono creare e distruggere facilmente. Creare un nuovo ramo è semplice e veloce quanto scrivere 41 byte in un file (40 caratteri ed il fine riga).

Questo è in netto contrasto con il sistema utilizzato da molti altri VCS, che comporta la copia di tutti i file di un progetto in una seconda directory. Questo può richiedere diversi secondi o minuti, a seconda delle dimensioni del progetto, mentre in Git è un processo sempre istantaneo.  Inoltre, dato che registreremo i genitori dei commit, trovare la base adatta per la fusione è fatto automaticamente per noi ed è generalmente molto semplice da fare. Questa funzionalità aiuta ed incoraggia gli sviluppatori a creare e fare uso dei rami di sviluppo.

Andiamo a vedere perché dovresti usarli.

## Basi di Diramazione e Fusione ##

Ora vediamo un semplice esempio di diramazione e fusione in un flusso di lavoro che potresti seguire nella vita reale. Supponiamo questi passaggi:

1.	Lavori su un sito web.
2.	Crei un ramo per una nuova storia su cui stai lavorando.
3.	Fai un po' di lavoro in questo nuovo ramo.

A questo punto, ricevi una chiamata per un problema critico e hai bisogno subito di risolvere il problema. Farai in questo modo:

1.	Tornerai indietro nel tuo ramo di produzione.
2.	Creerai un ramo in cui aggiungere la soluzione.
3.	Dopo aver testato il tutto, unirai il ramo con la soluzione e lo metterai in produzione.
4.	Salterai indietro alla tua storia originaria e continuerai con il tuo lavoro.

### Basi di Diramazione ###

Primo, diciamo che stai lavorando sul tuo progetto e hai già un po' di commit (vedi Figura 3-10).

Insert 18333fig0310.png 
Figura 3-10. Una storia di commit corta e semplice.

Hai deciso che lavorerai alla richiesta #53 di un qualsiasi sistema di tracciamento dei problemi che la tua compagnia utilizza. Per essere chiari, Git non si allaccia a nessun particolare sistema di tracciamento; ma dato che il problema #53 è un argomento specifico su cui vuoi lavorare, creerai un nuovo ramo su cui lavorare. Per creare un ramo e spostarsi direttamente in esso, puoi lanciare il comando `git checkout` con `-b`:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Questa è la scorciatoia per:

	$ git branch iss53
	$ git checkout iss53

La Figura 3-11 illustra il risultato.

Insert 18333fig0311.png 
Figura 3-11. É stato creato un nuovo ramo.

Lavori sul tuo sito web e fai alcuni commit. Facendo questo muoverai il ramo `iss53` avanti, perché ti sei spostato in esso (infatti, il puntatore HEAD rimanda ad esso, vedi Figura 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Figura 3-12. Il ramo iss53 è stato spostato in avanti con il tuo lavoro.

Ora ricevi la telefonata che ti avverte c'è un problema con il sito web, e devi risolverlo immediatamente. Con Git, non devi fare un deploy della tua soluzione con i cambiamenti del ramo `iss53` e non devi fare alcuno sforzo per riavvolgere le modifiche che hai fatto prima di applicare il fix a quello che è in produzione. Tutto ciò che devi fare è spostarti nel ramo master.

Ovviamente, prima di fare questo, nota che se hai delle modifiche nella tua directory di lavoro o nell'area di parcheggio (staging) che vanno in conflitto con il ramo su cui ti vuoi spostare, Git non ti permetterà lo spostamento. E' meglio avere uno stato di lavoro pulito quando ci si sposta nei vari rami. Ci sono dei modi per aggirare questa cosa (cioè, riporre e modificare i commit) che vedremo in seguito. Per ora, ha inviato tutte le tue modifiche, così puoi spostarti nel ramo master:

	$ git checkout master
	Switched to branch "master"

A questo punto, la directory di lavoro del tuo progetto è esattamente come era prima che tu iniziassi a lavorare alla richiesta #53, e puoi concentrarti sulla soluzione al problema. Questo è un punto importante da ricordare: Git reimposta la tua directory di lavoro all'istantanea del commit a cui punta il checkout. Lui aggiunge, rimuove e modifica i file automaticamente per essere sicuro che la tua copia di lavoro sia identica al tuo ultimo commit in quel ramo.

Successivamente, hai un hotfix da creare. Crea un ramo hotfix su cui lavorare fin quando non è completo (vedi Figura 3-13): 

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figura 3-13. Ramo hotfix basato sul ramo master.

Puoi avviare il tuo test, essere sicuro che la tua soluzione sia ciò che vuoi ottenere, e fonderla nel ramo master per inserirla nella fase di produzione. Puoi fare questo con il comando `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Avrai notato la frase "Fast forward" nella fusione. Dato che il commit a cui puntava il ramo unito era direttamente a monte rispetto al commit in cui ci ti trovi, Git muove il puntatore in avanti. Per dirla in un altro modo, quando provi ad unire un commit con un commit che può essere portato al primo commit della storia, Git semplifica le cose muovendo il puntatore in avanti perché non c'è un lavoro differente da fondere insieme — questo sistema è chiamato "fast forward".

I tuoi cambiamenti sono ora nell'istantanea del commit che punta al ramo `master`, e puoi utilizzare la tua modifica (vedi Figura 3-14).

Insert 18333fig0314.png 
Figura 3-14. Il tuo ramo master punta allo stesso punto del ramo hotfix dopo l'unione.

Dopo che il tuo fix super-importante è disponibile, sei pronto per tornare al lavoro che stavi eseguendo precedentemente all'interruzione. Ovviamente, prima devi eliminare il ramo `hotfix`, perché non ne avrai più bisogno — il ramo `master` punta allo stesso posto. Puoi eliminarlo con l'opzione `-d` di `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Ora puoi tornare al tuo lavoro precedente sul problema #53 (vedi Figura 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Figura 3-15. Il ramo iss53 può andare avanti indipendentemente.

Non è un problema non avere il lavoro svolto nel ramo `hotfix` nei file del ramo `iss53`. Se hai bisogno di inserire le modifiche, puoi fondere il ramo `master` nel ramo `iss53` lanciando `git merge master`, o puoi aspettare di integrare queste modifiche quando deciderai ti inserire il ramo `iss53` nel ramo `master`.

### Basi di Fusione ###

Supponiamo tu abbia deciso che il lavoro sul problema #53 sia completo e pronto per la fusione con il ramo `master`. Per fare questo, unirai il ramo `iss53`, esattamente come la fusione precedente del ramo `hotfix`. Tutto ciò che devi fare è spostarti nel ramo in cui vuoi fare la fusione e lanciare il comando `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Il risultato è leggermente differente rispetto alla fusione precedente di `hotfix`. In questo caso, Git ha eseguito la fusione in tre punti, usando le due istantanee che puntano all'estremità del ramo e al progenitore comune dei due. La Figura 3-16 evidenza i tre snapshot che Git usa per fare la fusione di questo caso.

Insert 18333fig0316.png 
Figura 3-16. Git automaticamente identifica il miglior progenitore comune su cui basare la fusione dei rami.

Invece di muovere il puntatore del ramo in avanti, Git crea una nuova istantanea che risulta da questa fusione e automaticamente crea un nuovo commit che punta ad essa (vedi Figura 3-17). Questo si chiama commit di fusione ed è speciale perché ha più di un genitore.

Vale la pena sottolineare che Git determina il migliore progenitore comune da utilizzare per la sua unione di base, questo è diverso da CVS o Subversion (prima della versione 1.5), in cui lo sviluppatore facendo la fusione doveva capire la base migliore di unione. Questo rende la fusione dannatamente semplice rispetto ad altri sistemi.

Insert 18333fig0317.png 
Figura 3-17. Git automaticamente crea un nuovo commit che contiene la fusione dei lavori.

Ora che il tuo lavoro è fuso, non hai più bisogno del ramo `iss53`. Puoi eliminarlo e chiudere manualmente il ticket nel tuo sistema di tracciamento:

	$ git branch -d iss53

### Basi sui Conflitti di Fusione ###

Occasionalmente, questo processo non è così semplice. Se modifichi la stessa parte di uno stesso file in modo differente nei due rami che stai fondendo assieme, Git non è in grado di unirli in modo pulito. Se il tuo fix per il problema #53 modifica la stessa parte di un file di `hotfix`, avrai un conflitto di fusione che assomiglierà a qualcosa di simile a questo:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git non ha creato automaticamente un commit di fusione. Lui ferma il processo fino a quando non risolverai il conflitto. Se vuoi vedere quali file non sono stati fusi in qualsiasi punto dell'unione, puoi avviare `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Qualsiasi cosa che ha un conflitto di fusione e non è stato risolto è elencato come unmerged. Git aggiunge dei marcatori standard di conflitto-risoluzione ai file che hanno conflitti, così puoi aprirli manualmente e risolvere i conflitti. I tuoi file conterranno una sezione che assomiglierà a qualcosa tipo:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Questo significa che la versione in HEAD (del ramo principale, perché è dove ti sei spostato precedentemente quando hai avviato il comando di fusione) è la parte superiore del blocco (tutto quello che sta sopra a `=======`), mentre la versione nel ramo `iss53` sarà la parte sottostante. Per risolvere il conflitto, dovrai scegliere una parte o l'altra oppure fondere i contenuti di persona. Per esempio, puoi risolvere il conflitto sostituendo l'intero blocco con questo:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Questa soluzione ha un po' tutte le sezioni, e ho rimosso completamente le linee `<<<<<<<`, `=======` e `>>>>>>>`. Dopo che hai risolto ogni singola sezione di conflitto del file, avvia `git add` su ogni file per marcarlo come risolto. Mettere in stage il file è come marcarlo risolto in Git. 
Se vuoi usare uno strumento grafico per risolvere i problemi, puoi lanciare `git mergetool`, che avvierà uno strumento visuale di fusione appropriato e ti guiderà attraverso i conflitti: 

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Se vuoi usare uno strumento di fusione differente dal predefinito (Git usa `opendiff` in questo caso perché ho lanciato il comando su un Mac), puoi vedere tutti gli strumenti supportati all'inizio dopo “... one of the following tools:” (uno dei seguenti strumenti, ndt.). Scrivi il nome dello strumento che vorresti usare. Nel Capitolo 7, discuteremo su come puoi modificare i valori predefiniti del tuo ambiente.

Dopo che sei uscito dallo strumento di fusione, Git ti chiederà se la fusione è avvenuta con successo. Se gli dirai allo script che è così, parcheggerà i file in modo da segnarli come risolti per te.

Puoi avviare `git status` nuovamente per verificare che tutti i conflitti sono stati risolti:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Se sei soddisfatto di questo, e hai verificato che tutti i conflitti sono stati messi in stage, puoi dare `git commit` per terminare la fusione. Il messaggio del commit predefinito assomiglierà a qualcosa tipo:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Puoi modificare questo messaggio con i dettagli su come hai risolto la fusione se pensi possa tornare utile ad altri che vedranno questa unione in futuro — perché hai fatto quel che hai fatto, se non era ovvio.

## Amministrazione dei Rami ##

Ora che hai creato, fuso ed eliminato alcuni rami, diamo un'occhiata ad alcuni strumenti di amministrazione dei rami che risulteranno utili quando inizierai ad usare i rami di continuo.

Il comando `git branch` fa molto di più che creare ed eliminare rami. Se lo lanci senza argomenti, otterrai una semplice lista dei rami correnti:

	$ git branch
	  iss53
	* master
	  testing

Nota il carattere `*` che precede il ramo `master`: esso indica il ramo in cui ti trovi in questo momento. Significa che se esegui un commit a questo punto, il ramo `master` avanzerà con il tuo lavoro. Per vedere l'ultimo commit di ogni ramo, puoi lanciare `git branch -v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Un'altra opzione utile per vedere in che stato sono i tuoi rami è filtrare la lista dei rami stessi che hai e non hai ancora fuso nel ramo in cui ti trovi attualmente. Le opzioni utili `--merged` e `--no-merged` sono disponibili in Git dalla versione 1.5.6 per questo scopo. Per vedere quali rami sono già stati fusi nel ramo attuale, puoi lanciare `git branch --merged`:

	$ git branch --merged
	  iss53
	* master

Dato che già hai fuso precedentemente `iss53`, lo vedrai nella tua lista.  Rami in questa lista senza lo `*` davanti possono generalmente essere eliminati con `git branch -d`; hai già incorporato il loro lavoro in un altro ramo, quindi non perderai niente.

Per vedere tutti i rami che contengono un lavoro non ancora fuso nel ramo attuale, puoi lanciare `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Questo mostrerà gli altri tuoi rami. Dato che contengono lavoro che non è stato ancora fuso, cercare di eliminarle con `git branch -d` fallirà:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Se vuoi realmente cancellare questo ramo e perdere il lavoro svolto, puoi forzare la cosa con `-D`, come l'utile messaggio ti fa notare.

## Flusso di Lavoro con le Ramificazioni ##

Ora che hai le basi sui rami e sulle fusioni, cosa puoi o dovresti fare con loro? In questa sezione, vedremo il modo di lavorare comune che questo sistema leggero di ramificazioni rende possibile, così puoi decidere se incorporarlo nel tuo ciclo di sviluppo questo sistema di sviluppo.

### Rami di Lunga Durata ###

Dato che Git usa un sistema semplice di fusione a tre vie, unire un ramo con un altro più volte dopo un lungo periodo è generalmente facile da fare.  Questo significa che puoi avere molti rami che sono sempre aperti e che puoi usare per differenti fasi del tuo ciclo di sviluppo; puoi fare fusioni regolarmente da alcune di esse in altre.

Alcuni sviluppatori Git hanno un flusso di lavoro che abbraccia questo approccio, come avere un unico codice che è interamente stabile nel loro ramo `master` — possibilmente solo codice che è o sarà rilasciato. Essi hanno poi un altro ramo parallelo chiamato sviluppo o successivo su cui lavorano o usano per i test di stabilità — non necessariamente sempre stabile, ma ogni volta che è in uno stato stabile, può essere fuso in `master`. É usato per inserire rami a tema (rami di breve durata, come il precedente ramo `iss53`) nei rami principali quando sono pronti, per essere sicuri di aver passato tutti i test e non introdurre bug.

In realtà, stiamo parlando dello spostamento dei puntatori sulla linea dei commit eseguiti. I rami stabili saranno alla base della storia dei tuoi commit e i rami di sviluppo saranno al di sopra della storia (vedi Figura 3-18).

Insert 18333fig0318.png 
Figura 3-18. I rami più stabili sono generalmente all'inizio della storia dei commit.

É generalmente facile pensare come un sistema di silos, dove una serie di commit gradualmente vanno in un contenitore più stabile quando sono bene testati (vedi Figura 3-19).

Insert 18333fig0319.png 
Figura 3-19. Può essere di aiuto pensare ai rami come dei silos.

Puoi mantenere questa cosa per svariati livelli di stabilità. Alcuni progetti molto grandi hanno inoltre un ramo `proposte` o `ap` (aggiornamenti proposti) che integrano rami che non sono pronti per entrare nel ramo `master` o `successivo`. L'idea è che i tuoi rami sono a vari livelli di stabilità; quando raggiungono un maggior livello di stabilità, sono fusi nel ramo superiore.
Ancora, avere rami di lunga durata non è necessario, ma a volte può essere utile, specialmente quando si ha a che fare con progetti molto grandi e complessi.

### Rami a Tema ###

I rami a tema, tuttavia, sono utili in progetti di ogni dimensione. Un ramo a tema è un ramo di breve durata che crei e usi per una singola funzionalità particolare o per un lavoro collegato. Questo è qualcosa che non hai mai fatto con un VCS prima perché è generalmente troppo dispendioso creare e fondere rami di sviluppo. Ma con Git è facile creare, lavorare, unire ed eliminare rami più volte al giorno.

Lo hai visto nell'ultima sezione per i rami `iss53` e `hotfix`. Hai fatto alcuni commit in essi, li hai eliminati direttamente dopo averli fusi nel ramo principale. Questa tecnica ti permette di cambiare contenuto velocemente e completamente — perché il tuo lavoro è separato in silos dove tutti i cambiamenti in quei rami avverranno li, è più facile vedere cosa è successo durante una revisione del codice o altro. Puoi lasciare lì i cambiamenti per minuti, giorni o mesi e fonderli assieme quando sono pronti, indipendentemente dall'ordine con cui sono stati creati o su come si è lavorato.

Considera un esempio di lavoro (su `master`), ti sposti in un altro ramo per un problema (`iss91`), lavori su questo per un po', ti sposti in una seconda branca per provare un altro modo per risolvere il problema (`iss91v2`), torni al ramo principale e lavori su questo per un poco, e poi vai in un altro ramo per fare un lavoro che non sei sicuro sia proprio una buona idea (ramo `dumbidea`). La storia dei tuoi commit assomiglierà a qualcosa come la Figura 3-20.

Insert 18333fig0320.png 
Figura 3-20. La storia dei tuoi commit con più rami.

Ora, diciamo che hai deciso che ti piace la seconda soluzione per risolvere il problema (`iss91v2`); e hai mostrato il ramo `dumbidea` ai tuoi collaboratori, e si scopre una genialata. Puoi gettare via il ramo `iss91` (perdendo i commit C5 e C6) e fondere gli altri due. La tua storia assomiglierà alla Figura 3-21.

Insert 18333fig0321.png 
Figura 3-21. La tua storia dopo che hai fatto la fusione di dumbidea e iss91v2.

É importante ricordare che ogni volta che si fa una cosa simile i rami sono completamente separate. Quando crei rami o fai fusioni, tutto è eseguito nel tuo repository Git — nessuna comunicazione con il server è avvenuta.

## Rami Remoti ##

I rami remoti sono riferimenti allo stato dei rami sui tuoi repository remoti. Sono rami locali che non puoi muovere; sono spostate automaticamente ogni volta che fai una comunicazione di rete.  I rami remoti sono come dei segnalibri per ricordarti dove i rami sui tuoi repository remoti erano quando ti sei connesso l'ultima volta.

Prendono la forma di `(remote)/(branch)`. Per esempio, se vuoi vedere come appariva il ramo `master` sul tuo ramo `origin` l'ultima volta che hai comunicato con esso, puoi controllare il ramo `origin/master`. Se stavi lavorando su un problema con un compagno ed hanno inviato un ramo `iss53`, potresti avere il ramo `iss53` in locale; ma il ramo sul server punta al commit `origin/iss53`.

Questo può un po' confondere, quindi vediamo un esempio. Diciamo che hai un server Git nella tua rete raggiungibile a `git.ourcompany.com`. Se fai una clonazione da qui, Git automaticamente lo nomina `origin` per te, effettua il pull di tutti i dati, crea un puntatore dove si trova il ramo `master` e lo nomina localmente `origin/master`; e non puoi spostarlo. Git inoltre ti da il tuo ramo `master` che parte dallo stesso punto del ramo originario `master`, così hai qualcosa da cui puoi iniziare a lavorare (vedi Figura 3-22).

Insert 18333fig0322.png 
Figura 3-22. Un clone con Git fornisce un proprio ramo principale e un puntatore origin/master al ramo principale di origine.

Se fai del lavoro sul tuo ramo principale locale, e, allo stesso tempo, qualcuno ha inviato degli aggiornamenti al ramo principale di `git.ourcompany.com`, allora la tua storia si muoverà in avanti in modo differente. Inoltre, mentre non hai contatti con il tuo server di partenza, il tuo puntatore `origin/master` non si sposterà (vedi Figura 3-23).

Insert 18333fig0323.png 
Figura 3-23. Lavorando in locale ed avendo qualcuno che ha inviato al server remoto qualcosa rende l'avanzamento delle storie differente.

Per sincronizzare il tuo lavoro, devi avviare il comando `git fetch origin`. Questo comando guarda qual'è il server di origine (in questo caso, è `git.ourcompany.com`), preleva qualsiasi dato che ancora non possiedi, e aggiorna il tuo database locale, spostando il puntatore `origin/master` alla sua nuova, più aggiornata posizione (vedi Figura 3-24).

Insert 18333fig0324.png 
Figura 3-24. Il comando git fetch aggiorna i tuoi riferimenti remoti.

Avendo più server remoti e volendo vedere come sono i rami remoti per questi progetti esterni, assumiamo che abbia un altro server Git interno che è usato solamente per lo sviluppo di un tuo team. Questo server è `git.team1.ourcompany.com`. Puoi aggiungerlo come una nuova referenza remoto al tuo progetto su cui stai lavorando avviando il comando `git remote add` come visto al Capitolo 2. Nominalo `teamone`, che sarà l'abbreviazione per tutto l'URL (vedi Figura 3-25).

Insert 18333fig0325.png 
Figura 3-25. Aggiungere un altro server remoto.

Ora, puoi lanciare `git fetch teamone` per prelevare tutto quello che non possiedi dal server remoto `teamone`. Dato che il server ha un sottoinsieme dei dati del server `origin` che già possiedi, Git non va a prendere nessun dato ma imposta un ramo remoto chiamato `teamone/master` a puntare al commit che `teamone` ha come suo ramo `master` (vedi Figura 3-26).

Insert 18333fig0326.png 
Figura 3-26. Hai un riferimento al ramo principale di teamone posizionato localmente.

### Invio ###

Quando vuoi condividere un ramo con il mondo, hai bisogno di inviarlo su di un server remoto su cui hai accesso in scrittura. I tuoi rami locali non sono automaticamente sincronizzati sul remoto in cui scrivi — devi esplicitamente dire di inviare il ramo che vuoi condividere. In questo modo, puoi usare rami privati per il lavoro che non vuoi condividere ed inviare solamente i rami su cui vuoi collaborare.

Se hai un ramo chiamato `serverfix` su cui vuoi lavorare con altri, puoi inviarlo nello stesso modo con cui hai inviato il primo ramo. Lancia `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Questa è una piccola abbreviazione. Git automaticamente espande il nome del ramo `serverfix` to `refs/heads/serverfix:refs/heads/serverfix`, questo significa, “Prendi il mio ramo locale serverfix ed invialo per aggiornare il ramo remoto serverfix.“ Vedremo in modo più approfondito la parte `refs/heads/` nel Capitolo 9, ma puoi generalmente lasciare perdere. Puoi anche fare `git push origin serverfix:serverfix`, che fa la stessa cosa — questo dice, “Prendi il mio serverfix e crea il serverfix remoto.“ Puoi usare questo formato per inviare rami locali in rami remoti che hanno nomi differenti. Se non vuoi chiamare il ramo remoto `serverfix`, puoi avviare `git push origin serverfix:awesomebranch` per inviare il tuo ramo locale `serverfix` in `awesomebranch` sul progetto remoto.

La prossima volta che i tuoi collaboratori preleveranno dal server, avranno un riferimento di dove si trova la versione del server di `serverfix` nel ramo `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

É importante notare che quando fai un prelievo di un nuovo ramo, non hai automaticamente un ramo locale modificabile. In altre parole, in questo caso, non hai un nuovo ramo `serverfix` — hai solamente il puntatore `origin/serverfix` che non puoi modificare.

Per fondere questo lavoro nel ramo corrente, puoi avviare `git merge origin/serverfix`. Se vuoi il tuo ramo `serverfix` su cui poter lavorare, puoi basarlo sul ramo remoto:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Questo ti fornirà un ramo locale da dove si trovava `origin/serverfix` su cui tu puoi iniziare a lavorare.

### Rami di Monitoraggio ###

Quando crei e ti sposti in un ramo locale partendo da un ramo remoto crei quello che viene chiamato _ramo di monitoraggio_. Questi sono rami locali che hanno una relazione diretta con il ramo remoto. Se ti trovi su uno di questi rami e dai `git push`, Git automaticamente sa a quale server e ramo inviare i dati. Inoltre, avviando `git pull` mentre si è su uno di questi rami si prelevano tutte le referenze remote ed automaticamente si fa la fusione dei corrispondenti rami remoti.

Quando cloni un repository, generalmente crea automaticamente un ramo `master` che traccia `origin/master`. Questa è la ragione per cui `git push` e `git pull` lavorano senza argomenti dall'inizio. Tuttavia, puoi impostare altri rami di monitoraggio se vuoi — che non monitorano i rami su `origin` e non monitorano il ramo `master`. Il caso più semplice è l'esempio che hai già visto, lancia `git checkout -b [branch] [remotename]/[branch]`. Se hai una versione 1.6.2 o successiva di Git, puoi inoltre usare l'abbreviazione `--track`:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Per impostare un ramo locale con un nome differente rispetto al remoto, puoi facilmente usare la prima versione con un nome locale diverso:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Ora il tuo ramo locale sf verrà automaticamente collegato a origin/serverfix.

### Eliminazione di Rami Remoti ###

Supponiamo che tu stia lavorando con un ramo remoto — diciamo che tu e i tuoi collaboratori avete finito con una funzionalità e l'avete fusa nel ramo remoto `master` (o qualsiasi ramo stabile del progetto). Puoi eliminare un ramo remoto con una sintassi abbastanza ottusa `git push [remotename] :[branch]`. Se vuoi eliminare il ramo `serverfix`, lancia il seguente comando:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. Non c'è più il ramo sul server. Tieni d'occhio questa pagina perché avrai bisogno di questo comando e dimenticherai facilmente la sintassi. Un modo per ricordare questo comando è richiamare la sintassi `git push [remotename] [localbranch]:[remotebranch]` che abbiamo visto precedentemente. Se lasci bianca la porzione `[localbranch]`, stai dicendo, “Non prendere niente dalla mia parte e rendila `[remotebranch]`.“

## Rifondazione ##

In Git, ci sono due modi per integrare i cambiamenti da un ramo in un altro: il `merge` ed il `rebase`. In questa sezione imparerai cos'è la rifondazione, come farlo, perché è uno strumento così fantastico, ed in quali casi puoi non volerlo utilizzare.

### Le Basi del Rebase ###

Se torni indietro in un precedente esempio alla sezione sulla fusione (vedi Figura 3-27), puoi vedere che hai separato il tuo lavoro e hai fatto dei commit in rami differenti.

Insert 18333fig0327.png 
Figura 3-27. L'inizio della divisione della storia dei commit.

Il modo più semplice per integrare i due rami, come abbiamo visto, è il comando `merge`. Lui avvia una fusione a tre vie con le ultime due istantanee dei rami (C3 e C4) ed il più recente progenitore comune dei due (C2), creando un nuovo snapshot (e commit), come visualizzato in Figura 3-28.

Insert 18333fig0328.png 
Figura 3-28. Fusione di un ramo per integrare una storia divisa.

Tuttavia, esiste un'altra possibilità: puoi prendere una patch del cambiamento che abbiamo introdotto in C3 ed applicarla all'inizio di C4. In Git, questo è chiamato _rifondazione_. E con il comando `rebase`, puoi prendere tutti i cambiamenti che sono stati inviati su un ramo ed applicarli su un altro.

In questo esempio, digita quanto segue:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Questi comandi funzionano andando al progenitore comune dei due rami (uno è quello in cui ti trovi e uno è quello su cui stai facendo il rebase), ottiene il diff di ogni commit del ramo in cui ti trovi, salva le informazioni in un file temporaneo, reimposta il ramo corrente allo stesso commit del ramo su cui stai facendo il rebase, e alla fine applica ogni singolo cambiamento. La Figura 3-29 illustra questo processo.

Insert 18333fig0329.png 
Figura 3-29. Rifondazione dei cambiamenti introdotti in C3 in C4.

A questo punto, puoi tornare indietro sul ramo principale e fare una fusione veloce (vedi Figura 3-30).

Insert 18333fig0330.png 
Figura 3-30. Avanzamento veloce del ramo principale.

Ora, lo snapshot puntato da C3' è esattamente lo stesso del puntatore nell'esempio di fusione. Non c'è differenza nel prodotto finale dell'integrazione, ma la rifondazione crea una storia più pulita. Se esamini il log del ramo su cui è stato fatto il rebase, assomiglia ad una storia lineare: appare come se tutto il lavoro fosse stato fatto in serie, invece è stato fatto in parallelo.

A volte, farai questa cosa per essere sicuro che i tuoi commit appaiano puliti nel ramo remoto — probabilmente in un progetto a cui stai cercando di contribuire ma che non mantieni. In questo caso, fai il tuo lavoro in  un ramo e poi fai il rebase in `origin/master` quando sei pronto per inviare le tue patch al progetto principale. In questo modo, gli amministratori non hanno da integrare niente — semplicemente applicano la fusione o fanno una fusione veloce.

Nota che lo snapshot punta al commit finale, che è l'ultimo dei commit su cui è stato fatto il rebase per un rebase o il commit finale di fusione dopo un merge, è lo stesso snapshot — è solo la storia che è differente. La rifondazione applica i cambiamenti su una linea di lavoro in un'altra nell'ordine con cui sono stati introdotti, dove la fusione prende lo stato finale e fa un'unione di essi.

### Rebase Più Interessanti ###

Puoi anche avere il tuo rebase su qualcosa che non è il ramo di rebase. Prendi la storia della Figura 3-31, per esempio. Hai un ramo a tema (`server`) per aggiungere delle funzioni lato server al tuo progetto, e fai un commit. Poi, ti sposti su un altro ramo per creare dei cambiamenti sul lato client (`client`) e fai dei commit. Alla fine, torni sul tuo ramo server e fai degli altri commit.

Insert 18333fig0331.png 
Figura 3-31. Una storia con un ramo a tema ed un altro ramo a tema da questo.

Supponiamo che tu decida di voler unire i tuoi cambiamenti lato client nella linea principale per un rilascio, ma non vuoi unire le modifiche lato server per testarle ulteriormente. Puoi prendere le modifiche sul client che non sono sul server (C8 e C9) ed applicarle nel ramo master usano l'opzione `--onto` di `git rebase`:

	$ git rebase --onto master server client

Questo dice, “Prendi il ramo client, fai le patch a partire dall'ancora comune dei rami `client` e `server`, ed applicali in `master`.“ É un po' complesso; ma il risultato, mostrato in Figura 3-32, è davvero interessante.

Insert 18333fig0332.png 
Figura 3-32. Rifondazione di un ramo a tema con un altro ramo a tema.

Ora puoi fare una fusione veloce con il ramo master (vedi Figura 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figura 3-33. Fusione ad avanzamento veloce con il ramo master per includere i cambiamenti del ramo client.

Diciamo che hai deciso di inviare il tutto nel ramo server. Puoi fare un rebase del ramo server in quello master senza dover controllarlo prima lanciando `git rebase [basebranch] [topicbranch]` — che controlla il ramo a tema (in questo caso, `server`) per te e gli applica il ramo base (`master`):

	$ git rebase master server

Questo applica il tuo lavoro `server` sopra al tuo lavoro `master`, come in Figura 3-34.

Insert 18333fig0334.png 
Figura 3-34. Rifondazione del ramo server sopra al ramo master.

Poi, puoi fare una fusione veloce con il ramo base (`master`):

	$ git checkout master
	$ git merge server

Puoi rimuovere i rami `client` e `server` perché tutto il lavoro è integrato e non ne hai più bisogno, lasciando così la storia dell'intero processo come in Figura 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figura 3-35. Storia finale dei commit.

### I Rischio della Rifondazione ###

Ahh, ma la bellezza della rifondazione non è senza macchia, che può essere riassunta in una singola frase:

**Non fare il rebase dei commit che hai inviato in un repository pubblico.**

Se segui queste linea guida è ok. Se non lo farai, le persone ti odieranno e sarai disprezzato dagli amici e dalla famiglia.

Quando fai il rebase di qualcosa, stai abbandonando i commit esistenti per crearne di nuovi che sono simili ma differenti. Se invii i commit da qualche parte e altri li hanno scaricati hanno basato il loro lavoro su questi, e tu riscrivi questi commit con `git rebase` e poi li invii nuovamente, i tuoi collaboratori dovranno fare una nuova fusione del loro lavoro e le cose saranno disordinate quando cercherai di scaricare il loro lavoro nel tuo.

Vedi l'esempio su come funziona il rebase che hai reso pubblico e cosa può causare. Supponiamo che abbia clonato un repository da un server centrale e poi abbia fatto dei lavori. La storia dei tuoi commit assomiglierà alla Figura 3-36.

Insert 18333fig0336.png 
Figura 3-36. Repository clonato e del lavoro basato su questo.

Ora, qualcuno ha fatto molto lavoro che include una fusione, e ha inviato questo lavoro al server centrale. Tu scarichi questo e lo unisci con un nuovo ramo remoto nel tuo lavoro, rendendo la tua storia come qualcosa in Figura 3-37.

Insert 18333fig0337.png 
Figura 3-37. Scarichi più commit, e li fondi assieme nel tuo lavoro.

Poi, la persona che ha inviato il suo lavoro decide di tornare indietro e fa un rebase del suo lavoro; e da un `git push --force` per sovrascrivere la storia del server. Puoi poi scaricare nuovamente dal server i nuovi commit.

Insert 18333fig0338.png 
Figura 3-38. Qualcuno ha inviato dei commit su cui è stato fatto il rebase, abbandonando i commit che su cui avevi basato il tuo lavoro.

A questo punto devi fondere di nuovo il tuo lavoro, e tu lo avevi già fatto. La rifondazione modifica gli hash SHA-1 di questi commit così per Git sono come dei nuovi commit, mentre di fatto hai già il lavoro C4 nel tuo repository (vedi Figura 3-39).

Insert 18333fig0339.png 
Figura 3-39. Fai la fusione nello stesso lavoro con un nuovo commit di unione.

Devi fondere questo lavoro in ogni punto così puoi rimanere aggiornato con l'altro sviluppatore in futuro. Dopo che hai fatto questo, la storia dei tuoi commit contiene sia i commit C4 e C4', che hanno un hash SHA-1 differente ma introducono lo stesso lavoro e hanno lo stesso messaggio per il commit. Se lanci `git log` quando la tua storia assomiglia a questo, vedrai i due commit che hanno lo stesso autore data e messaggio, e ciò confonde. Inoltre, Se invii questa storia al server, tu reinserisci nel server centrale questi commit che hanno subito un rebase, ciò confonde ulteriormente le persone.

Se tratti la rifondazione com un modo per essere pulito e lavorare con i commit prima di inviarli, e se fai il rebase solamente dei commit che non sono mai diventati pubblici, allora la cosa è ok. Se fai il rebase dei commit che sono già stati inviati e sono pubblici, e le persone hanno basato il loro lavoro su questi commit, allora potresti creare dei problemi di frustazione.

## Riassunto ##

Abbiamo visto le basi di diramazione e di fusione in Git. Dovresti sentirti a tuo agio nel creare e spostarti in nuovi rami, spostarti fra i vari rami e fondere i rami locali insieme. Dovresti essere ingrado anche di condividere i tuoi rami su un server condiviso, lavorare con altri su rami condivisi e fare il rebase dei tuoi rami prima di condividerli.
