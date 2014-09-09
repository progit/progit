# Git distribuito #

Ora che avete un repository Git remoto configurato per tutti gli sviluppatore per condividere il proprio codice, e usate comunemente i comandi di base di Git per il tuo lavoro in locale, vedremo come utilizzare alcuni dei flussi di lavoro offerti da Git.

In questo capitolo, vedremo come lavorare con Git in un ambiente distribuito come contributore e integratore. Imparerai come contribuire in maniera efficiente ad un progetto e rendere la vita al gestore del progetto il più semplice possibile, ma anche come mantenere correttamente un progetto con un certo numero di sviluppatori che vi contribuiscono.

## Workflows distribuiti ##

A differenza dei gestori di versione centralizzati (CVCS), la natura distribuita di Git ti permette di essere più flessibile nel gestire il modo in cui gli sviluppatori collaborano ai progetti. Nel sistemi centralizzati ogni sviluppatore è un nodo che lavora appoggiandosi ad un nucleo centrale più o meno ugualmente agli altri. Con Git, invece, ogni sviluppatore è potenzialmente sia un nodo che un nucleo: infatti ogni sviluppatore può contemporaneamente contribuire al codice di altri repository e mantenere un repository pubblico sul quale gli altri basino il proprio lavoro e verso il quale possano contribuire. Questo apre ad una vasta gamma di possibilità di workflow per il tuo progetto e/o il tuo gruppo. Tratterò quindi alcuni paradigmi che sfruttano questa flessibilità. Discuterò i punti di forza e le possibili debolezze di ogni design: potrai usarne uno o combinarli per adattarli alle tue necessità.

### Workflow centralizzato ###

Nei sistemi centralizzati, generalmente c'è un solo modo per collaborare: il flusso centralizzato. Un nucleo centrale, c.d. repository, può accettare il codice e tutti sincronizzano il proprio lavoro con questo nucleo. Un numero di sviluppatori sono nodi - utenti del nucleo - e restano sincronizzati con questo nucleo centrale (vedi Figura 5-1).

Insert 18333fig0501.png
Figura 5-1. Worlflow centralizzato

Questo significa che se due sviluppatori clonano dal nucleo ed entrambi fanno dei cambiamenti, il primo sviluppatore che trasmetterà le proprie modifiche al nucleo non avrà problemi. Il secondo, invece, dovrà prima unire al proprio lavoro quello del primo e quindi potrà inviare i suoi cambiamenti, per non sovrascrivere il lavoro del primo. Questo accade in Git come in Subversion (o un altro CVCS), e questo modello funziona tranquillamente in Git.

Se hai un piccolo gruppo, o nella tua azienda siete già abituati ad un workflow centralizzato, puoi facilmente continuare ad utilizzare questo metodo con Git. Crea un singolo repository e dai a ognuno del tuo gruppo la possibilità di effettuare una push; Git non lascerà agli utenti la possibilità di sovrascrivere il lavoro di un l'altro. Se uno sviluppatore clona, fa dei cambiamenti, e poi prova a fare una push delle proprie modifiche dopo che un altro utente abbia già inviato le proprie modifiche, il server rifiuterà le modifiche dell'ultimo. Questi sarà avvisato che sta cercando di fare la push di una copia non aggiornata e non potrà caricare le proprie modifiche finché non le unirà con quelle effettuate dagli altri.
Molti usano questo metodo perché sono abituati a lavorare con questo paradigma.

### Workflow con manager d'integrazione ###

Poiché Git permette di avere repository multipli, è possibile avere un workflow dove ogni sviluppatore ha accesso in scrittura al proprio repository pubblico e accesso in lettura a quello degli altri. Questo scenario spesso prevede anche un repository classico che rappresenta il progetto "ufficiale". Per contribuire a progetti di questo tipo, devi creare il tuo clone pubblico del progetto e inviarvi (con una push) le tue modifiche e successivamente chiedere al mantenitore del progetto di fare una pull delle stesse. Questi può aggiungere il tuo repository come remoto, testarlo localmente, unirlo al proprio branch e fare una push verso il proprio repository. Il processo funziona così (vedi Figura 5-2):

1.  Il mantenitore del progetto fa le push sul proprio repository pubblico.
2.  Un contributore clona il reposiory ed fa delle cambiamenti.
3.  Il contributore invia le modifiche al suo repository pubblico.
4.  Il contributore invia al mantenitore una e-mail chiedendo di fare una pull dei cambiamenti.
5.  Il mantenitore aggiunge il repository del contributore come remoto e fa un merge in locale dei cambiamenti.
6.  Il mantenitore fa una push dei cambiamenti (compresi quelli aggiunti dal contributore) verso il repository principale.

Insert 18333fig0502.png
Figura 5-2. Workflow con manager d'integrazione

Questo è un workflow comune con siti come GitHub, dove è facile eseguire un fork di un progetto e inviare le tue modifiche al tuo fork, in modo che tutti possano accedervi. Uno dei vantaggi principali di questo approccio è che puoi continuare il tuo lavoro mentre il mantenitore del repository principale può eseguire una pull dei tuoi cambiamenti in qualsiasi momento. I contributori non devono aspettare che il progetto incorpori le modifiche: ognuno può lavorare per conto suo.

### Workflow con Dittatore e Tenenti ###

Questa è una variante del workflow con repository multipli. Viene generalmente usata da grandi progetti con centinaia di collaboratori: un esempio famoso è il Kernel Linux. Molti manager d'integrazione sono responsabili di certe parti del repository e vengono chiamati tenenti. Tutti i tenenti hanno un manager d'integrazione conosciuto come "dittatore benevolo". Il repository del dittatore benevolo è il repository di riferimento dal quale tutti i collaboratori prendono il codice. Il flusso di lavoro è il seguente (vedi Figura 5-3):

1.  Sviluppatori normali lavorano sul loro branch ed eseguono un _rebase_ del proprio lavoro sul master. Il branch master è quello del dittatore.
2.  I tenenti uniscono il lavoro degli sviluppatori nel proprio branch master.
3.  Il dittatore esegue l'unione dei branch master dei tenenti nel proprio branch master.
4.  Il dittatore esegue una push del proprio ramo master nel repository di riferimento, cosicché gli sviluppatori possano accedervi.

Insert 18333fig0503.png
Figura 5.3. Workflow con dittatore benevolo.

Questo tipo di workflow non è comune ma può essere utile in progetti molto grandi o in ambienti con una gerarchia forte, perché consente al leader del progetto (il dittatore) di delegare molto del lavoro e raccogliere vasti sottoinsiemi di codice in punti diversi prima di integrarli.

Ci sono alcuni workflow utilizzati comunemente che sono possibili con un sistema distribuito come Git, ma esistono molte possibili varianti per adattarli al tuo caso specifico. Ora che hai (spero) determinato quale combinazione di workflow possa funzionare per te, illustrerò alcuni esempi sui ruoli principali dei diversi workflow.

## Contribuire a un Progetto ##

Conosci i diversi workflow e dovresti aver chiaro i fondamentali di Git. In questa sezione imparerai alcuni metodi comuni per contribuire a un progetto.

La difficoltà maggiore nel descrivere questo processo è che ci sono molte variazioni su come può venir fatto. Poiché Git è molto flessibile la gente può lavorare insieme in molti modi (ed effettivamente lo fa), ed è difficile descrivere come dovresti contribuire ad un progetto: ogni progetto è diverso. Alcune delle variabili coinvolte sono la quantità di contributori attivi, il workflow adottato, il tuo tipo di accesso, ed eventualmente il metodo di contribuzione esterno.

La prima variabile è il numero di contributori attivi. Quando utenti  contribuiscono attivamente al progetto con del codice e quanto spesso? In molte casi avrai due o tre sviluppatori con poche commit quotidiane, o anche meno per dei progetti semi dormienti. Per azienda o progetti molto grandi, il numero di sviluppatori potrebbe essere nell'ordine delle migliaia, con dozzine o addirittura di centinaia di patches rilasciate ogni giorno. Questa è importante perché con più sviluppatori vai incontro a molti problemi nell'applicare le modifiche in maniera pulita o che queste possano essere facilmente integrate. I cambiamenti che fai potrebbero essere stati resi obsoleti o corrotti da altri che sono stati integrati mentre lavoravi o mentre aspettavi che il tuo lavoro venisse approvato o applicato. Come puoi mantenere il tuo codice aggiornato e le tue modifiche valide?

La variabile successiva è il workflow usato nel progetto. È centralizzato, con ogni sviluppatore con lo stesso tipo di accesso in scrittura sul repository principale? Il progetto ha un manager d'integrazione che controlla tutte le modifiche? Tutte le modifiche sono riviste da più persone ed approvate? Sei coinvolto in questo processo? È un sistema con dei tenenti, e devi inviare a loro il tuo lavoro?

Il problema successivo riguarda i tuoi permessi per effettuare commit. Il workflow richiesto per poter contribuire al progetto è molto diverso a seconda del fatto che tua abbia accesso in scrittura o solo lettura. Se non hai accesso in scrittura, qual'è il modo preferito dal progetto per accettare il lavoro dei contributori? Esistono regole a riguardo? Quanto contribuisci? Quanto spesso?

Tutte queste domande possono influire sul modo in cui contribuisci al progetto e quale tipo di workflow sia quello preferito o disponibile. Illustrerò gli aspetti di ciascuno di questi in una serie di casi d'uso, dal più semplice al più complesso: dovresti essere capace di definire il workflow specifico per il tuo caso basandoti su questi esempi.

### Linee guida per le commit ###

Prima di vedere i casi specifici faccio una breve nota riguardo i messaggi delle commit. Avere una linea guida per le commit e aderirvi rende il lavoro con Git e la collaborazione con altri molto più semplice. Il progetto di Git fornisce un documento che da molti suggerimenti circa le commit per da cui creare patch: puoi trovarlo nel codice sorgente di Git nel file `Documentation/SubmittingPatches`.

Innanzitutto non è il caso di inviare errori con degli spazi. Git fornisce un modo semplice per verificarli: esegui, prima di un commit, `git diff --check`, che identifica possibili errori riguardanti gli spazi e li elenca per te. Qui c'è un esempio in cui ho sostituiro il colore rosso del terminale con delle `X`:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Se esegui il commando prima della commit, puoi vedere se stai per committare degli spazi bianchi che potrebbero infastidire altri sviluppatori.

Cerca quindi di aver per ciascuna commit un insieme logico di modifiche. Se puoi, cerca di rendere i cambiamenti "digeribili": non lavorare per un intero fine settimana su cinque diversi problemi per fare poi una commit massiva il lunedì. Anche se non fai commit nel weekend, il lunedì usa l'area di staging per suddividere il tuo lavoro in almeno un commit per problema con un messaggio utile per ciascuna. Se modifiche diverse coinvolgono lo stesso file, usa `git add --patch` per aggiungere parti del file all'area di staging (trattato in dettaglio nel capitolo 6). Il risultato finale sarà lo stesso che tu faccia una o cinque commit quando queste vengano integrate in un punto, per cui cerca di rendere le cose più semplici ai tuoi colleghi sviluppatori quando devono controllare le tue modifiche. Questo approccio inoltre rende più semplice includere o escludere alcuni dei cambiamenti, nel caso ti serva successivamente. Il capitolo 6 descrive una serie di trucchi di Git utili per riscrivere la storia e aggiungere interattivamente file all'area di staging: usa questi strumenti per mantenere la cronologia pulita e comprensibile.

L'ultima cosa da tenere a mente è il messaggio di commit. Prendere l'abitudine di creare messaggi di commit di qualità rende l'uso e la collaborazione tramite Git molto più semplice. Come regola generale, i tuoi messaggi dovrebbero iniziare con una sola linea di massimo 50 caratteri che descriva sinteticamente l'insieme delle modifiche seguito da una linea bianca e quindi una spiegazione dettagliata. Il progetto di Git prevede che una spiegazione molto dettagliata includa il motivo della modifica e confrontare l'implementazione committata con la precedente: questa è una buona linea guida da seguire. È una buona idea anche usare l'imperativo presente in questi messaggi. In altre parole, usa dei comandi. Al posto di "Ho aggiunto dei test per" o "Aggiungendo test per", usa "Aggiungi dei test per".
Questo modello è stato originariamente scritto da Tim Pope su tpope.net:

  Breve (50 caratteri o meno) riassunto delle modifiche

  Spiegazione più dettagliata, se necessario. Manda a capo ogni 72 caratteri 
  circa. In alcuni contesti, la prima linea è trattata come l'oggetto di
  un'email, ed il resto come il contenuto. La linea vuota che separa l'oggetto
  dal testo è importante (a meno che tu non ometta il testo del tutto):
  strumenti come rebase possono confondersi se non dovesse esserci.

  Ulteriori paragrafi vanno dopo altre linee vuote.

   - Le liste puntate sono concesse

   - Di solito viene usato un trattino o un asterisco come separatore,
     preceduto da uno spazio singolo, con delle linee vuote tra i punti,
     ma le convenzioni possono essere diverse

Se tutti i tuoi messaggi di commit fossero così, per te e gli altri sviluppatori con cui lavori le cose saranno molto più semplici per te e per gli sviluppatore con cui lavori. Il progetto di Git ha dei messaggi di commit ben formattati: ti incoraggio a eseguire `git log --no-merges` per vedere qual è l'aspetto di una cronologia ben leggibile.

Negli esempi che seguono e nella maggior parte di questo libro, per brevità, non formatterò i messaggi accuratamente come descritto: userò invece l'opzione `-m` di `git commit`. Fa' come dico, non come faccio.

### Piccoli gruppi privati ###

La configurazione più semplice che probabilmente incontrerai sarà di un progetto privato con uno o due sviluppatori. Con privato intendo codice a sorgente chiuso: non accessibile al resto del mondo. Tu e gli altri sviluppatori avete accesso in scrittura al repository.

Con questa configurazione, puoi utilizzare un workflow simile a quello che magari stai già usando con Subversion o un altro sistema centralizzato. Hai comunque i vantaggi (ad esempio) di poter eseguire commit da offline e la creazione di rami (ed unione degli stessi) molto più semplici, ma il workflow può restare simile; la differenza principale è che, nel momento del commit, l'unione avviene nel tuo repository piuttosto che in quello sul server.
Vediamo come potrebbe essere la situazione quando due sviluppatori iniziano a lavorare insieme con un repository condiviso. Il primo sviluppatore, John, clona in repository, fa dei cambiamenti ed esegue il commit localmente. (In questi esempi sostituirò, per brevità, il messaggio del protocollo con `...`)

	# Computer di John
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'rimosso valore di default non valido'
	[master 738ee87] rimosso valore di default non valido
	 1 files changed, 1 insertions(+), 1 deletions(-)

Il secondo sviluppatore, Jessica, fa la stessa cosa - clona il repository e committa le modifiche:

	# Computer di Jessica
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'aggiunto il processo di reset'
	[master fbff5bc] aggiunto il processo di reset
	 1 files changed, 1 insertions(+), 0 deletions(-)

Ora, Jessica invia il suo lavoro al server con una push:

	# Computer di Jessica
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

Anche John cerca di eseguire una push:

	# Computer di John
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

A John non è permesso fare un push perché nel frattempo lo ha già fatto Jessica. Questo è particolarmente importante se sei abituato a Subversion, perché vedrai che i due sviluppatori non hanno modificato lo stesso file. Sebbene Subversion unisca automaticamente sul server queste commit se i file modificati sono diversi, in Git sei tu che devi farlo localmente. John deve quindi scaricare le modifiche di Jessica e unirle alle sue prima di poter fare una push:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

A questo punto, il repository locale di John somiglia a quello di figura 5-4.

Insert 18333fig0504.png
Figura 5-4. Il repository iniziale di John.

John sa quali sono le modifiche di Jessica, ma deve unirle alle sue prima poter fare una push:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

L'unione fila liscia e ora la cronologia delle commit di John sarà come quella di Figura 5-5.

Insert 18333fig0505.png
Figura 5-5. Il repository di John dopo aver unito origin/master.

John ora può testare il suo codice per essere sicuro che continui a funzionare correttamente e può quindi eseguire la push del tutto sul server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

La cronologia dei commit di John somiglierà quindi a quella di figura 5-6.

Insert 18333fig0506.png
Figura 5-6. La cronologia di John dopo avere eseguito la push verso il server.

Jessica nel frattempo sta lavorando a un altro ramo. Ha creato un branch chiamato `problema54` e ha eseguito tre commit su quel branch. Poiché non ha ancora recuperato le modifiche di John la sua cronologia è quella della Figura 5-7.

Insert 18333fig0507.png
Figura 5-7. La cronologia iniziale di Jessica.

Jessica vuole sincronizzarsi con John, quindi esegue:

	# Computer di Jessica
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Con cui recupera il lavoro che nel frattempo John ha eseguito. La cronologia di Jessica ora è quella di Figura 5-8.

Insert 18333fig0508.png
Figura 5-8. La cronologia di Jessica dopo aver recuperato i cambiamenti di John.

Jessica pensa che il suo ramo sia pronto, però vuole sapere con cosa deve unire il suo lavoro prima di eseguire la push. Esegue quindi `git log` per scoprirlo:

	$ git log --no-merges origin/master ^problema54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    rimosso valore di default non valido

Ora, Jessica può unire il lavoro del suo branch nel suo master, quindi le modifiche di John (`origin/master`) nel suo branch `master`, e ritrasmettere il tutto al server con una push. Per prima cosa torna al suo branch master per integrare il lavoro svolto nell'altro branch:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Può decidere di unire prima `origin/master` o `problema54`: entrambi sono flussi principali, per cui non conta l'ordine. Il risultato finale sarà lo stesso a prescindere dall'ordine scelto, ma la cronologia sarà leggermente differente. Lei sceglie di fare il merge prima di `problema54`:

	$ git merge problema54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Non ci sono stati problemi: come puoi vedere tutto è stato molto semplice. Quindi Jessica unisce il lavoro di John (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Tutto viene unito correttamente, e la cronologia di Jessica è come quella di Figura 5-9.

Insert 18333fig0509.png
Figura 5-9. La cronologia di Jessica dopo aver unito i cambiamenti di John.

Ora `origin/master` è raggiungibile dal ramo `master` di Jessica, cosicché lei sia capace di eseguire delle push con successo (supponendo che John non abbia fatto altre push nel frattempo):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Ogni sviluppatore ha eseguito alcune commit ed unito con successo il proprio lavoro con quello degli altri; vedi Figura 5-10.

Insert 18333fig0510.png
Figura 5-10. La cronologia di Jessica dopo aver eseguito il push dei cambiamenti verso il server.

Questo è uno dei workflow più semplici. Lavori per un po', generalmente in un branch, ed unisci il tutto al branch master quando è pronto per essere integrato. Quando vuoi condividere questo lavoro lo unisci al tuo branch master e poi scarichi ed unisci `origin/master`, se è cambiato, e infine esegui la push verso il branch `master` nel server. La sequenza è simile a quella in Figura 5-11.

Insert 18333fig0511.png
Figura 5-11. La sequenza generale di eventi per un workflow semplice con Git a più sviluppatori.

### Team privato con manager ###

In questo scenario, scoprirai i ruoli di contributore in un gruppo privato più grande. Imparerai come lavorare in un ambiente dove gruppi piccoli collaborano a delle funzionalità e poi queste contribuzioni sono integrate da un altra persona.

Supponiamo che John e Jessica stiano lavorando insieme a una funzionalità, mentre Jessica e Josie si stiano concentrando a una seconda. In questo caso l'azienda sta usando un workflow con manager d'integrazione dove il lavoro di ogni gruppo è integrato solo da alcuni ingegneri, ed il branch `master` del repository principale può essere aggiornato solo da questi. In questo scenario, tutto il lavoro è eseguito sui rami suddivisi per team, e unito successivamente dagli integratori.

Seguiamo il workflow di Jessica mentre lavora sulle due funzionalità, collaborando parallelamente con due diversi sviluppatori in questo ambiente. Assumendo che lei abbia già clonato il suo repository, decide di lavorare prima alla `funzionalitaA`. Crea un nuovo branch per la funzionalità e ci lavora.

	# Computer di Jessica
	$ git checkout -b featureA
	Switched to a new branch "funzionalitaA"
	$ vim lib/simplegit.rb
	$ git commit -am 'aggiunto il limite alla funzione di log'
	[featureA 3300904] aggiunto il limite alla funzione di log
	 1 files changed, 1 insertions(+), 1 deletions(-)

A questo punto lei deve condividere il suo lavoro con John, così fa la push sul server del branch `funzionalitaA`. Poiché Jessica non ha permessi per fare la push sul ramo `master` (solo gli integratori ce l'hanno) deve perciò eseguire la push su un altro branch per poter collaborare con John:

	$ git push origin funzionalitaA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica manda una e-mail a John dicendogli che fatto la push del suo lavoro su un branch chiamato `funzioanlitaA` chiedendogli se lui può dargli un'occhiata. Mentre aspetta una risposta da John, Jessica decide di iniziare a lavorare su `funzionalitaB` con Josie. Per iniziare, crea un nuovo branch basandosi sul branch `master` del server:

	# Computer di Jessica
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Quindi Jessica esegue un paio di commit sul branch `funzionalitaB`:

	$ vim lib/simplegit.rb
	$ git commit -am 'resa la funzione ls-tree ricorsiva'
	[featureB e5b0fdc] resa la funziona ls-tree ricorsiva
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'aggiunto ls-files'
	[featureB 8512791] aggiunto ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

Il repository di Jessica è come quello di Figura 5-12.

Insert 18333fig0512.png
Figura 5.12. La cronologia iniziale delle commit di Jessica

Quando è pronta a eseguire una push del proprio lavoro riceve una e-mail da Josie che le dice che una parte del lavoro era già stato caricato sul server nel branch chiamato `funzionalitaBee`. Jessica deve unire prima le modifiche al server alle sue per poter fare la push verso il server. Può recuperare il lavoro di Josie usando `git fetch`:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Jessica ora può unire il suo lavoro a quello di Josie con `git merge`:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

C'è un piccolo problema: deve fare la push del suo branch `funzionalitaB` sul branch `funzionalitaBee` del server. Può farlo specificando il branch locale seguito da due punti (:) seguito a sua volta dal nome del branch remoto di destinazione al comando `git push`:

	$ git push origin funzionalitaB:funzionalitaBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Questo è detto _refSpec_. Vedi il capitolo 9 per una discussione più dettagliata sui refspec di Git e cosa ci puoi fare.

John manda una mail a Jessica dicendole che ha fatto la push di alcune modifiche sul branch `funzionalitaA` e le chiede di controllarle. Lei esegue `git fetch` per scaricarle:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

E può vederle con `git log`:

	$ git log origin/funzionalitaA ^funzionalitaA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    cambiato l'output del log da 25 a 30

Infine unisce il lavoro di John al suo nel branch `funzionalitaA`:

	$ git checkout funzionalitaA
	Switched to branch "funzionalitaA"
	$ git merge origin/funzionalitaA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica vuole aggiustare qualcosa e fa un'altro commit ed una push verso il server:

	$ git commit -am 'leggero aggiustamento'
	[featureA ed774b3] leggero aggiustamento
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

La cronologia delle commit di Jessica ora sarà come quella della Figura 5-13.

Insert 18333fig0513.png
Figura 5-13. La cronologia di Jessica dopo aver eseguito la commit sul branch.

Jessica, Josie e John informano gli integratori che i rami `funzionalitaA` e `funzionalitaB` che sono sul server sono pronti per l'integrazione nel `master`. Dopo l'integrazione di questi branch nel `master`, una fetch scaricherà tutte queste nuove commit, rendendo la cronologia delle commit come quella della Figura 5.14.

Insert 18333fig0514.png
Figura 5.14. La cronologia di Jessica dopo aver unito entrambi i rami.

Molti gruppi migrano a Git per la sua capacità di avere gruppi che lavorino in parallelo, unendo le differenti righe di lavoro alla fine del processo. La possibilità che piccoli sottogruppi del team possano collaborare con branch remoti senza dover necessariamente coinvolgere o ostacolare l'intero team è un grande beneficio di Git. La sequenza del workflow che hai appena visto è rappresentata nella Figura 5-15.

Insert 18333fig0515.png
Figura 5-15. Sequenza base di questo workflow con team separati.

### Piccolo progetto pubblico ###

Contribuire ad un progetto pubblico è leggermente differente. Poiché non hai il permesso di aggiornare direttamente i rami del progetto, devi far avere il tuo lavoro ai mantenitori in qualche altro modo. Questo primo esempio descrive come contribuire con i fork su host Git che lo supportano in maniera semplice. I siti di repo.or.cz e GitHub lo supportano, e molti mantenitori di progetti si aspettano questo tipo di contribuzione. La sezione successiva tratta i progetti che preferiscono ricevere le patch per e-mail

Per iniziare probabilemnte dovrai clonare il repository principale, creare un branch per le modifiche che programmi di fare, quindi lavorarci. La sequenza è grosso modo questa:

	$ git clone (url)
	$ cd project
	$ git checkout -b funzionalitaA
	$ (lavoro)
	$ git commit
	$ (lavoro)
	$ git commit

Potresti voler usare `rebase -i` per ridurre il tuo lavoro a una singola commit, o riorganizzare il lavoro delle commit per facilitare il lavoro di revisione dei mantenitori - vedi il Capitolo 6 per altre informazioni sul rebase interattivo.

Quando il lavoro sul tuo branch è completato e sei pronto per condividerlo con i mantenitori, vai alla pagina principale del progetto e clicca sul pulsante "Fork", creando la tua copia modificabile del progetto. Dovrai quindi aggiungere l'URL di questo nuovo repository come un secondo remoto, chiamato in questo caso `miofork`:

	$ git remote add miofork (url)

E dovrai eseguire una push del tuo lavoro verso il nuovo repository. È più semplice fare la push del branch a cui stai lavorando piuttosto che unirlo al tuo master e fare la push di quest'ultimo. La ragione è che se il tuo lavoro non verrà accettato, oppure lo sarà solo in parte, non dovrai ripristinare il tuo master. Se i mantenitori uniscono, fanno un rebase, o prendono pezzi dal tuo lavoro col cherry-pick, otterrai il nuovo master alla prossima pull dal loro repository:

	$ git push myfork funzionalitaA

Quando avrai eseguito la push del tuo lavoro sul tuo fork, devi avvisare i mantenitori. Questo passaggio viene spesso definito "richiesta di pull" (pull request), e puoi farlo tramite lo stesso sito - GitHub ha un pulsante "pull request" che automaticamente notifica i mantenitori - o eseguire il comando `git request-pull` e inviare manualmente via email l'output ai mantenitori.

Il comando `request-pull` riceve come parametri il branch di base sul quale vuoi far applicare le modifiche e l'URL del repository Git da cui vuoi che le prendano, e produce il sommario di tutte queste modifiche in output. Se, per esempio, Jessica volesse inviare a John una richiesta di pull, e avesse eseguito due commit sul branch di cui ha appena effettuato il push, può eseguire questo:

	$ git request-pull origin/master miofork
	The following changes since commit 1edee6b1d61823a2de3b09c160d7080b8d1b3a40:
	  John Smith (1):
	        aggiunta una nuova funzione

	are available in the git repository at:

	  git://githost/simplegit.git funzionalitaA

	Jessica Smith (2):
	      aggiunto limite alla funzione di log
	      cambiato l'output del log da 30 a 25

	 lib/simplegit.rb |   10 +++++++++-
	 1 files changed, 9 insertions(+), 1 deletions(-)

L'output può essere inviato ai mantenitori: riporta da dove è stato creato il nuovo branch, un riassunto delle commit e da dove si possono scaricare.

In un progetto dove non sei il mantenitore normalmente è comodo avere un branch come `master` sempre collegato a `origin/master` e lavorare su altri branch che puoi eliminare nel caso non venissero accettati. Suddividere il lavoro in branch per argomento ti rende più semplice ribasare il tuo lavoro se il repository principale è stato modificato e le tue commit non possono venire applicate in maniera pulita. Se per esempio vuoi aggiungere un'altra caratteristica al progetto, invece di continuare a lavorare sul branch di cui hai appena fatto la push, creane un altro partendo dal `master` del repository:

	$ git checkout -b funzionalitaB origin/master
	$ (lavoro)
	$ git commit
	$ git push miofork funzionalitaB
	$ (email al mantenitore)
	$ git fetch origin

Ora ognuno dei tuoi lavori è separato come in una coda di modifiche che puoi riscrivere, ribasare e modificare senza che gli argomenti interferiscano o dipendano dagli altri, come in Figura 5-16.

Insert 18333fig0516.png
Figura 5-16. Conologia iniziale col lavoro su funzionalitaB.

Supponiamo che il mantenitore del progetto ha inserito una manciata di altre modifiche e provato il tuo primo branch ma non riesce più ad applicare tali modifiche in maniera pulita. In questo caso puoi provare a ribasare il nuovo `origin/master` su quel branch, risolvere i conflitti per poi inviare di nuovo le tue modifiche:

	$ git checkout funzionalitaA
	$ git rebase origin/master
	$ git push –f miofork featureA

Questo riscrive la tua cronologia per essere come quella di Figura 5-17.

Insert 18333fig0517.png
Fgiura 5-17. La cronologia ddopo il lavoro su funzionalitaA.

Poiché hai eseguito un rebase del branch, per poter sostituire il branch `funzionalitaA` sul server con una commit che non discenda dallo stesso, devi usare l'opzione `-f` perché la push funzioni. Un'alternativa sarebbe fare una push di questo nuovo lavoro su un branch diverso (chiamato per esempio `funzionalitaAv2`).

Diamo un'occhiata a un altro scenario possibile: il mantenitore ha visto tuo lavoro nel secondo branch e gli piace il concetto ma vorrebbe che tu cambiassi un dettaglio dell'implementazione. Potresti cogliere l'occasione per ribasarti sul `master` corrente. Crea un nuovo branch basato sull'`origin/master` attuale, sposta lì le modifiche di `funzionalitaB`, risolvi gli eventuali conflitti, fai la modifica all'implementazione ed esegui la push del tutto su un nuovo branch:

	$ git checkout -b funzionalitaBv2 origin/master
	$ git merge --no-commit --squash funzionalitaB
	$ (cambia implementazione)
	$ git commit
	$ git push miofork funzionalitaBv2

L'opzione `--squash` prende tutto il lavoro dal branch da unire e lo aggiunge come una singola commit nel branch dove sei. L'opzione `--no-commit` dice a Git di non fare la commit automaticamente. Questo ti permette di aggiungere le modifiche di un altro branch e fare ulteriori modifiche prima di effettuare la nuovo commit.

Ora puoi avvisare i mantenitori che hai effettuato le modifiche richieste e che possono trovarle nel branch `funzionalitaBv2` (vedi Figura 5-18).

Insert 18333fig0518.png
Figura 5-18. La cronologia dopo il lavoro su funzionalitaBv2.

### Grande Progetto Pubblico ###

Molti grandi progetti hanno definito delle procedure per l'invio delle patch: dovrai leggere le specifiche di ciascun progetto, perchè saranno diverse. Tuttavia molti grandi progetti pubblici accettano patch tramite la mailing list degli sviluppatori, quindi tratterò ora questo caso.

Il flusso di lavoro è simile al caso precedente: crei un branch per ognuna delle modifiche sulle quali intendi lavorare. La differenza sta nel modo in cui invii tali modifiche al progetto. Invece di fare un tuo fork del progetto e di inviare le tue modifiche con una push, crei una versione e-mail di ogni commit e invii il tutto per email alla mailing list degli sviluppatori:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Ora hai due commit che vuoi inviare alla mailing list. Usi `git format-patch` per generare un file formato mbox che possa inviare via e-mail alla lista: questo trasforma ogni commit in un messaggio email il cui oggetto è la prima linea del messaggio della commit e il contenuto è dato dal resto del messaggio della commit più la patch delle modifiche. La cosa bella di tutto ciò è che, applicando le commit da un'email, vengono mantenute le informazioni delle commit, come vedrai meglio nella prossima sezione:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

Il comando `format-patch` visualizza i nomi dei file delle patch che crea. Il parametro `-M` indica a Git di tener traccia dei file rinominati. I file alla fine avranno questo aspetto:

	$ cat 0001-add-limit-to-log-function.patch
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

	---
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index 76f47bc..f9815f1 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -14,7 +14,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log #{treeish}")
	+    command("git log -n 20 #{treeish}")
	   end

	   def ls_tree(treeish = 'master')
	--
	1.6.2.rc1.20.g8c5b.dirty

Puoi anche modificare questi file per aggiungere maggiori informazioni per la mailing list che però non vuoi che vengano visualizzate all'interno del messaggio della commit. Se aggiungi del testo tra la riga con `---` e l'inizio della patch (ad esempio la riga `lib/simplegit.rb`), gli sviluppatori potranno leggerlo ma verrà escluso dal messaggio della commit una volta che la patch sarà applicata.

Per inviare le patch alla mailing list, puoi copiare ed incollare il file nel tuo programma di posta o inviare il tutto dalla riga di comando. Incollare il testo è spesso causa di problemi di formattazione, sopratutto con i client di posta "intelligenti" che non mantengono correttamente i caratteri di a-capo e altri caratteri di spaziatura. Fortunatamente Git fornisce uno strumento che ti aiuta a inviare correttamente le patch tramite IMAP, che potrebbe facilitarti il compito. Ti mostrerò come mandare una patch con Gmail perché è il client di posta che utilizzo, ma troverai istruzioni dettagliate per molti client di posta alla fine del documento `Documention/SubmittingPatches`, che trovi nel codice sorgente di Git.

Prima di tutto devi configurare la sezione imap nel tuo file `~/.gitconfig`. Puoi configurare ogni parametro separatamente con una serie di comandi `git config` o scriverli direttamente con un editor di testo. Alla fine il tuo file di configurazione dovrebbe comunque essere più o meno così:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Se il tuo server IMAP non usa SSL, probabilmente le ultime due righe non ti saranno necessarie e il valore del campo host sarà `imap://` invece di `imaps://`.
Quando avrai configurato tutto, potrai usare `git send-email` per inviare la serie di patch alla cartella "Bozze" del tuo server IMAP:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Per ciascuna patch che stai per inviare, Git produce alcune informazioni di log che appariranno più o meno così:

	(mbox) Adding cc: Jessica Smith <jessica@example.com> from
	  \line 'From: Jessica Smith <jessica@example.com>'
	OK. Log says:
	Sendmail: /usr/sbin/sendmail -i jessica@example.com
	From: Jessica Smith <jessica@example.com>
	To: jessica@example.com
	Subject: [PATCH 1/2] added limit to log function
	Date: Sat, 30 May 2009 13:29:15 -0700
	Message-Id: <1243715356-61726-1-git-send-email-jessica@example.com>
	X-Mailer: git-send-email 1.6.2.rc1.20.g8c5b.dirty
	In-Reply-To: <y>
	References: <y>

	Result: OK

A questo punto, dovresti essere in grado di andare nella cartella bozze del tuo account, inserire nel campo "A:" la mailing list alla quale vuoi inviare la patch, magari aggiungendo in copia il mantenitore del progetto o la persona responsabile per quella determinata sezione e manda l'email.

### Sommario ###

Questa sezione ha trattato alcuni workflow comuni che è facile incontrare quando si ha a che fare con progetti Git diversi e ha introdotto un paio di strumenti nuovi per aiutarti a gestire questo processo. Vedremo ora l'altra faccia della medaglia: mantenere un progetto Git. Imparerai ad essere un dittatore benevolo (_benevolent dictator_) o un manager d'integrazione (_integration manager_).

## Mantenere un Progetto ##

Oltre a sapere come contribuire ad un progetto in maniera effettiva, dovrai probabilmente sapere anche come mantenerne uno. Ciò consiste nell'accettare ed applicare le patch generate con il comando `format-patch` e ricevute tramite e-mail oppure nell'integrare le modifiche dei branch remoti che hai definito nel tuo progetto come remoti. Sia che mantenga un repository o che voglia contribuire verificando o approvando le patch, devi sapere come svolgere il tuo compito in modo che sia chiaro per gli altri contributori del progetto e sostenibile per te nel lungo periodo.

### Lavorare coi branch per argomento ###

Quando pensi di integrare un nuovo lavoro generalmente è una buona idea provarlo in un branch per argomento: un branch temporaneo, creato specificatamente per provare le modifiche dalla patch. In questo modo è semplice verificare la singola patch e, se questa non funziona, lasciarla intalterata fino a quando non avrai il tempo di ritornarci. Se crei un branch col nome dell'argomento della patch che proverai, per esempio `ruby_client` o qualcosa ugualmente descrittiva, ti sarà facile individuarlo nel caso tu debba temporaneamente lasciare il lavoro sulla patch per ritornarci più avanti. Il mantenitore del progetto Git  usa dare uno gerarchia ai nomi di questi branch: come `sc/ruby_client`, dove `sc` sono le iniziali della persona che ha realizzato la patch.
Come ricorderai, puoi creare un branch partendo dal tuo master così:

	$ git branch sc/ruby_client master

E, se vuoi passare immediatamente al nuovo branch, puoi usare il comando `checkout -b`:

	$ git checkout -b sc/ruby_client master

Ora sei pronto per aggiungere il lavoro a questo branch e decidere se vuoi unirlo a uno dei branch principali del tuo progetto.

### Applicare le patch da un'e-mail ###

Se ricevi le patch via e-mail e le vuoi integrarle nel tuo progetto, devi prima applicarle per poterle giudicare. Ci sono due modi per applicare una patch ricevuta via email: con `git apply` o con `git am`.

#### Applicare una patch con apply ####

Se hai ricevuto la patch da qualcuno che l'ha generata usando il comando `git diff` o un qualsiasi comando Unix `diff`, puoi applicarla usando `git apply`. Se hai salvato la patch in `/tmp/patch-ruby-client.patch`, puoi applicarla così:

	$ git apply /tmp/patch-ruby-client.patch

Ciò modifica i file nella tua directory corrente. E' quasi uguale ad eseguire il comando `patch -p1` per applicare la patch, anche se questo comando è più paranoico e accetta meno corrispondenze di patch. Gstisce anche l'aggiunta, la rimozione e il cambio del nome dei file se ciò è descritto nel formato di `git diff`, cose che non fa `patch`. Infine `git apply` segue il modello "applica tutto o rigetta tutto" per cui o vengono applicato tutte le modifiche oppure nessuna, mentre `patch` può anche applicarne solo alcune, lasciando la tua directory corrente in uno stato intermedio. `git apply` è in generale molto più paranoico di `patch`. Non creerà una commit per te: una volta eseguito devi eseguire manualmente lo stage delle modifiche e farne la commit.

Puoi anche usare `git apply` per verificare se una patch può essere applicata in maniera pulita, prima di applicarla veramente eseguendo `git apply --check` sulla patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

Se non viene visualizzato alcun output, allora la patch può essere applicata in maniera pulita. Questo comando restituisce un valore diverso da zero se la verifica fallisce, quindi puoi usarlo anche in uno script.

#### Applicare una patch con am ####

Se il contributore è un utente Git ed è stato abbastanza bravo a usare il comando `format-patch` per generare la sua patch, allora il tuo lavoro sarà più facile perché la patch già contiene le informazioni sull'autore e un messaggio di commit. Se pouoi, per generare le patch per te, incoraggia i tuoi collaboratori ad utilizzare `format-patch` invece di `diff`. Dovresti dover usare solo `git apply` per le patch precedenti e altre cose del genere.

Per applicare una patch generata con `format-patch`, userai `git am`. Tecnicamente `git am` è fatto per leggere un file mbox, che è un file piatto di puro testo per memorizzare uno o più messaggi email in un solo file. Assomiglia a questo:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

Questo è l'inizio dell'output del comando 'format-patch' che hai visto nella sezione precedente, ma è anche un formato valido per mbox per le email. Se qualcuno ti ha inviato la patch usando 'git send-email' e l'hai scaricata nel formato mbox, allora puoi selezionare il file mbox in 'git am' che inizierà ad applicare tutte le patch che trovi. Se hai un client di posta elettronica che ti permette di salvare più messaggi in un file mbox allora puoi salvare tutta una serie di patch in un singolo file e usare `git am` per applicarle tutte assieme.

Se invece qualcuno ha caricato una patch generata con `format-patch` su un sistema di ticket e tracciamento, puoi salvare localmente il file e passarlo a `git am` perché lo applichi:

	$ git am 0001-limit-log-function.patch
	Applying: add limit to log function

Puoi vedere che ha applicato senza errori le modifiche e ha creato automaticamente una nuova commit per te. Le informazioni sull'autore e la data della commit vengono prese delle intestazioni `From`  e `Date` dell'email, mentre il messaggio della commit è preso dal `Subject` e dal corpo dell'email che precede la patch. Se questa patch fosse stata applicata dall'esempio dell'mbox appena mostrato, la commit generata apparirebbe così:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

`Commit` indica chi ha applicato la patch e `CommitDate` quando. `Author` chi ha creato la patch originariamente e quando.

Ma è possibile che la patch non sia applicabile correttamente. Il tuo branch principale potrebbe essere cambiato troppo rispetto al branch da cui deriva la patch o che la patch dipenda da altre che non hai ancora applicato. In questo caso il processo di `git am` fallirà e ti chiederà cosa voglia fareprocess will fail and ask you what you want to do:

	$ git am 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

Questo comando aggiunge dei marcatori di conflicco in ciascun file che presenti un problema, similmente a quanto avviene nelle operazioni di merge o rebase. E tu risolverai il problema allo stesso modo: modifica il file per risolvere il conflitto, mettilo nello stage ed esegui `git am --resolved` per continuare con la patch successiva:

	$ (fix the file)
	$ git add ticgit.gemspec
	$ git am --resolved
	Applying: seeing if this helps the gem

Se vuoi che Git provi a risolvere i conflitti più intelligentemente, puoi passargli l'opzione `-3`, e Git proverà a eseguire un merge a 3-vie. Quest'opzione non è attiva di default perché non funziona se la patch si basa su una commit che non hai nel tuo repository. Se invece hai quella commit (ovvero se la patch è basata su una commit pubblica) allora generalmente l'opzione `-3` è più intelligente nell'applicare una patch con conflitti:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In questo caso sto cercando di applicare una patch che ho già applicato. Senza l'opzione `-3` sembrerebbe che ci sia un conflitto.

Se stai applicando una serie di patch da un file mbox puoi eseguire il comando `am` anche in modalità interattiva, che si ferma ogni volta che incontra una patch per chiederti se vuoi applicarla:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

Questo è utile se hai una serie di patch salvate, perché se non ti ricordi cosa sia puoi rivedere la patch, o non applicarla se l'hai già applicata.

Quando tutte la patch per l'orgomento sono state applicate e committate nel tuo branch, puoi decidere se e come integrarle in un branch principale.

### Scaricare branch remoti ###

Se la contribuzione viene da un utente Git che ha un proprio repository su cui ha pubblicato una serie di modifiche e ti ha mandato l'indirizzo del repository e il nome del branch remoto in cui sono le stesse, puoi aggiungerlo come remoto e unirle localmente.

Se, per esempio, Jessica ti invia un'email dicendoti che nel branch `ruby-client` del suo repository ha sviluppato un'interessante funzionalità, tu puoi testarla aggiungendo il branch remoto e scaricarlo come uno localmente:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

Se successivamente t'invia un'altra email con un altro branch che contenga un'altra funzionalità interessante tu puoi scaricarla più velocemente perché hai già configurato il repository remoto.

Questa configurazione è molto utile se lavori molto con una persona. Se qualcuno produce una sola patch di tanto in tanto può essere più rapido accettarle per email, invece di chiedere a tutti di avere un proprio server pubblico e aggiungere in continuazione dei repository remoti per poche modifiche. Allo stesso tempo non vorrai centinaia di repository remoti per qualcuno che contribuisce solo con una patch o due. In ogni caso degli script o servizi di hostin possono rendere il tutto più semplice e principalmente dipende da come sviluppate tu e i tuoi contributori.

L'altro vantaggio di questo approccio è che in aggiunta ricevi la cronologia delle commit. Sebbene tu possa avere problemi coi merge saprai su quale parte della tua cronologia si basi il lavoro dei contributori, il merge a 3-vie è il default e non richiede di specificare l'opzione `-3` e la patch potrebbe essere generata da una commit pubblica a cui tu abbia accesso.

Se non lavori spesso con una persona ma vuoi comunque prendere le modifiche in questo modo puoi sempre passare l'URL del repository remoto al comando `git pull`. Questo farà una pull una tantum senza salvare l'URL come un riferimento remoto:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Determinare cos'è stato introdotto ###

Hai un branch che contiene il lavoro di un contributore. A questo punto puoi decidere cosa farne. Questa sezione rivisita un paio di comandi così che tu possa vedere come usarli per revisionare con precisione cosa introdurrai se unissi queste modifiche al tuo branch principale.

Spesso è utile revisionare le commit del branch che non sono ancora nel tuo master. Puoi escludere le commit di un branch aggiungendo l'opzione `--not` prima del nome del branch. Se un tuo contributore ti manda due patch e tu crei un branch chiamato `contrib` dove applichi le patch, puoi eseguire:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

Ricorda che puoi passare l'opzione `-p` a `git log` per vedere le modifiche di ciascuna commit, così che all'output aggiungerà le differenze introdotte da ciascuna commit.

Per vedere tutte le differenze che verrebbero applicate se unissi il branch attuale con un altro dovrai usare un trucchetto per vedere il risultato corretto. Potresti pensare di usare:

	$ git diff master

Ed effettivamente questo comando esegue una differenza, ma può essere causa di errori. Se il tuo branch `master` si fosse spostato in avanti rispetto a quando hai creato il branch vedrai risultati strani. Questo succede perché Git confronta direttamente l'istantanea ('snapshots') dell'ultima commit del branch con l'istantanea dell'ultima commit di `master`. Se, per esempio, hai aggiunto una riga in un file su `master` branch, un confronto diretto delle istantanee sembrerà indicare che il branch rimuova quella riga.

Se `master` è un antenato diretto del branch allora non sarà un problema, ma se le due cronologie si sono biforcate ti apparirà che stai aggiungendo tutte le cose nuove del tuo branch e rimuovendo tutto ciò che è solo in `master`.

Quello che vuoi realmente vedere sono le modifiche aggiunte nel branch: il lavoro che effettivamente introdurrai se le unissi al master. Potrai ottenerlo facendo si che Git confronti l'ultima commit del branch col primo antenato comune con il branch master.

Tecnicamente puoi farlo tu scoprendo l'antenato comune ed eseguendo quindi la diff:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db

Questo però è scomodo e Git fornisce un modo più veloce per farlo: i tre punti. Nel contesto del comando `diff`, puoi usare tre punti dopo il nome di un branch per eseguire una `diff` tra l'ultima commit del branch in cui sei e l'antenato comune con un altro branch:

	$ git diff master...contrib

Questo comando ti mostra solo le modifiche introdotte dal branch attuale a partire dall'antenato comune con master. Questa sintassi è molto utile da ricordare.

### Integrare il lavoro dei contributori ###

Quando tutto il lavoro del tuo branch è pronto per essere integrato in un branch principale nasce il prblema di come farlo. Inoltre, quale workflow vuoi usare per mantenere il tuo progetto? Hai una serie di scelte e ne tratterò alcune.

#### I workflow per il merge ####

Un workflow semplice unisce le modifiche nel branch `master`. In questo scenario hai un `master` che contiene del codice stabile. Quando hai del lavoro in un branch funzionale che sia tuo o di un contributore e di cui tu abbia già verificato il buon funzionamento, lo unisci al master, cancelli il branch e così via. Se abbiamo un repository che abbia delle modifiche in due branch  funzionali chiamati `ruby_client` e `php_client` questo apparirà come in Figura 5-19 e se unissimo prima `ruby_client` e poi `php_client` allora la nostra cronologia apparirà come quella in Figura 5-20.

Insert 18333fig0519.png
Figura 5-19. Cronologia con branch funzionali multipli.

Insert 18333fig0520.png
Figura 5-20. Dopo l'unione dei branch funzionali.

Probabilmente questo è il workflow più semplice, ma è anche problematico se stai lavorando con repository o progetti grandi.

Se hai più sviluppatori o lavori in un progetto grande, probabilmente vorrai usare un ciclo d'unione a due fasi. In questo scenario hai due branch principali, `master` e `develop`, e hai deciso che `master` viene aggiornato esclusivamente con un rilascio molto stabile e tutto il codice nuovo viene integrato nel branch `develop`. Condividi regolarmente entrambi i branch su un repository pubblico e ogni volta che hai un nuovo branch funzionale da integrare (Figura 5-21) lo fai in `develop` (Figura 5-22), quindi taggi il rilascio e fai un `fast-forward` di `master` al punto in cui `develop` è stabile (Figura 5-23).

Insert 18333fig0521.png
Figura 5-21. Prima dell'unione del branch funzionale.

Insert 18333fig0522.png
Figura 5-22. Dopo l'unione del branch funzionale.

Insert 18333fig0523.png
Figura 5-23. Dopo il rilascio di un branch funzionale.

In questo modo quando qualcuno clona il repository del tuo progetto, questi può scaricare il master per avere l'ultima versione stabile e tenersi aggiornato, o scaricare la versione di sviluppo che contiene le ultime cose.
Puoi estendere questo concetto avendo un branch in cui integri tutto il nuovo lavoro. Quando il codice di questo branch è stabile e ha passato tutti i test lo unisci al branch di sviluppo e quando questo ha dimostrato di essere stabile per un po', fai un _fast-forward_ del tuo master.

#### Workflow per unioni grandi ####

Il progetto Git ha quattro branch principali: `master`, `next`, e `pu` (aggiornamenti suggeriti - `proposed updates`) per il nuovo lavoro, e `maint` per la manutenzione dei backport. Quando un contributore introduce una modifica, questa viene raccolta nei branch funzionali del repository del mantenitore in modo simile a quanto ho già descritto (vedi Figura 5-24). A questo punto le modifiche vengono valutate per deteminare se sono sicure e pronte per essere utilizzate o se hanno bisogno di ulteriore lavoro. Se sono sicure vengono unite in `next` e questo branch viene condiviso perché chiunque possa provarle tutte assieme.

Insert 18333fig0524.png
Figura 5-24. Gestire una serie complessa di branch funzionali paralleli.

Se la funzione ha bisogno di ulteriori modifiche viene unita invece in `pu` e quando viene ritenuta realmente stabile viene unita di nuovo su `master` e viene ricostruita dal codice che era in `next`, ma non è ancora promossa su `master`. Questo significa che `master` va quasi sempre avanti, `next` raramente è ribasato e `pu` viene ribasato molto spesso (see Figura 5-25).

Insert 18333fig0525.png
Figura 5-25. Unire branch di contribuzione nei branch principali.

Quando un branch funzionale viene finalmente unito in `master` viene anche rimosso dal repository. Il progetto Git ha anche un branch `maint` che è un fork dell'ultima release per fornire patch a versioni precedenti nel caso sia necessaria un rilascio di manutenzione. Quindi, quando cloni il repository di Git puoi usare quattro branch per valutare il progetto in stadi diversi dello sviluppo, a seconda che tu voglia le ultime funzionalità o voglia contribuire, e il mantenitore ha strutturato il workflow in modo da favorire nuove contribuzioni.

#### Workflow per il rebase e lo _cherry pick_ ####

Altri mantenitori preferiscono ribasare o usare lo _cherry-pick_ aggiungere i contributi nel loro branch master, piuttosto che unirli, per mantenere una cronologia il più lineare possibile. Quando hai delle modifiche in un branch funzionale e hai deciso che vuoi integrarle, ti sposti su quel branch ed esegui il comando _rebase_ per replicare le modifiche del tuo master attuale (o `develop` e così via). Se queste funzionano, allora fai un _fast-forward_ del tuo `master` e ti ritroverai con un progetto dalla cronologia lineare.

L'altro modo per spostare il lavoro dei contributori da un branch all'altro è di usare lo _cherry-pick_. Lo _cherry-pick_ in Git è come una rebase per una commit singola. Prende la patch introdotta nella commit e prova a riapplicarla sul branch dove sei. Questo è utile se hai molte commit in un branch funzionale e vuoi integrarne solo alcune o se hai un'unica commit in un branch funzionale e preferisci usare lo `cherry-pick` piuttosto che ribasare. Immagina di avere un progetto che sembri quello di Figura 5-26.

Insert 18333fig0526.png
Figura 5-26. Cronologia prima dello _cherry pick_.

Se vuoi introdurre la commit `e43a6` nel tuo master puoi eseguire

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

Che replica le stesse modifiche introdotte in `e43a6`, ma produce una nuova commit con un suo SHA-1 differente perché le date sono diverse. La tua cronologia ora assomiglia a quella in Figura 5-27.

Insert 18333fig0527.png
Figura 5-27. Cronologia dopo lo _cherry-picking_ dal branch funzionale.

Puoi ora eliminare il branch funzionale e cancellare le commit che non vuoi integrare.

### Tagga i tuoi rilasci ###

Quando hai deciso di eseguire un rilascio probabilmente vorrai anche taggarla, così che tu possa ricrearla in qualsiasi momento nel futuro. Puoi aggiungere un nuovo tag come discusso nel Capitolo 2. Se vuoi firmare il tag in quanto mantenitore, il tag potrebbe apparire come il seguente:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Se firmi il tuo tag potresti avere il problema di distribuire la chiave PGP usata per firmarlo. Il mantenitore del progetto Git lo ha risolto includendo le chiavi dei mantenitori come un blob sul repository e aggiungendo quindi un tag che vi punti direttamente. Per farlo dovrai identificare la chiave che vuoi esportare eseguendo `gpg --list-keys`:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Potrai quindi importare la chiave direttamente nel database di Git esportandola e mettendola in pipe con `git hash-object`, che scrive in Git un nuovo blob con il suo contenuto e ti restituisce l'hash SHA-1:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Ora che hai importato il contenuto della tua chiave in Git puoi creare un tag che vi punti direttamente, specificando l'SHA-1 appena ottenuto:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Se esegui `git push --tags` verrà condiviso con tutti il tag `maintainer-pgp-pub`. Se qualcuno volesse verificare il tag potrà farlo importando la tua chiave PGP scaricando il blob dal database e importandolo in GPG:

	$ git show maintainer-pgp-pub | gpg --import

Può quindi usare la chiave per verificare tutti i tag che hai firmato. Inoltre, se aggiungi delle istruzioni nel messaggio del tag, eseguendo `git show <tag>` darai all'utente finale maggiori informazioni specifiche su come verificare il tag.

### Generare un numero di build ###

Poiché Git non usa una numerazione incrementale come 'v123' o un equivalente associato a ciascuna commit, se vuoi un nome per una commit che sia intellegibile, puoi usare il comando `git describe` su quella commit. Git restituirà il nome del tag più vicino assieme al numero di commit successivi e una parte dell'SHA-1 della commit che vuoi descrivere:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

In questo modo puoi esportare un'istantanea o una build  echiamarla in modo che le persone possano capire. Se infatti fai una build di Git dai sorgenti clonati dal repository di Git repository, `git --version` ti restituirà qualcosa che gli assomigli. Se vuoi descrivere una commit che hai taggato, Git ti darà il nome del tag.

Il comando `git describe` predilige i tag annotati (i tags creati con`-a` o `-s`) e quindi i tag dei rilasci dovrebbero essere creati in questo modo se usi `git describe`, per assicurarsi che le commit vengano denominate correttamente quando vengono descritte. Puoi usare questa stringa per i comandi `checkout` o `show`, sebbene il basarsi sull'SHA-1 abbreviato potrebbe renderla non valida per sempre. Per esempio, recentemente il kernel di Linux è passato recentemente da 8 a 10 caratteri per garantire l'unicità degli SHA-1 abbreviati, e quindi gli output precedenti di `git describe` non sono più validi.

### Pronti per il rilascio ###

Vuoi ora rilasciare una build. Una delle cose che vorrai fare sarà creare un archivio con l'ultima istantanea del tuo codice per quelle anime dannate che non usano Git. Il comando è `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

Quando qualcuno aprirà questo  tarball, troverà l'ultima versione del tuo progetto nella directory `project`. Allo stesso modo puoi creare un archivio zip passando l'opzione `--format=zip` a `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Ora hai un tarball e uno zip del rilascio del tuo progetto che puoi caricare sul tuo sito o inviare per email.

### Lo Shortlog ###

È il momento di inviare un'email alla lista di persone che vogliono sapere cosa succede nel tuo progetto. Un modo piacevole per produrre una specie di changelog delle modifiche dall'ultimo rilascio o dall'ultima email è usando il comando `git shortlog`, che riassume tutte le commit nell'intervallo dato. L'esempio seguente produce il sommario di tutte le commit dall'ultimo rilascio, assumento che lo abbia chiamato v1.0.1:

	$ git shortlog --no-merges master --not v1.0.1
	Chris Wanstrath (8):
	      Add support for annotated tags to Grit::Tag
	      Add packed-refs annotated tag support.
	      Add Grit::Commit#to_patch
	      Update version and History.txt
	      Remove stray `puts`
	      Make ls_tree ignore nils

	Tom Preston-Werner (4):
	      fix dates in history
	      dynamic version method
	      Version bump to 1.0.2
	      Regenerated gemspec for version 1.0.2

Ottieni un sommario pulito di tutte le commit dalla v1.0.1, raggruppate per autore che puoi quindi inviare per email alla tua lista.

## Sommario ##

Dovresti sentirti ora a tuo agio nel contribuire a progetti Git, tanto quanto mantenere il tuo progetto o integrare i contributi di altri utenti. Congratulazione per essere un vero sviluppatore Git! Nel prossimo capitolo imparerai alcuni strumenti molto potenti e suggerimenti per affrontare situazione complesse che ti faranno diventare un maestro di Git.
