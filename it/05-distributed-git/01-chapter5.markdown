# Git distribuito #

Ora che avete un repository Git remoto messo a punto per tutti gli sviluppatore per condividere il proprio codice, e siete familiari con i comandi di base di Git nel lavoro in locale, andremo a vedere come utilizzare alcuni dei workflows distribuiti che Git offre.

In questo capitolo, vedrete come lavorare con Git in un ambiente distribuito come contributore ed integratore. Imparerai come contribuire in maniera efficiente ad un progetto e rendere semplice la vita al gestore del progetto, oltre a come mantenere un progetto in maniera corretta con un certo numero di sviluppatori che contribuiscono ad esso.

## Workflows distribuiti ##

A differenza dei gestori di versione centralizzati (CVCSs), la natura distrubuita di Git render possibile una maggiore flessibilità nel modo in cui gli sviluppatori collaborano nei progetti. Nel sistemi centralizzati, ogni sviluppatore è un nodo che lavora appoggiandosi più o meno ad un fulcro centrale. Con Git invece, ogni sviluppatore è potenzialmente sia un nodo che il fulcro stesso - infatti ogni sviluppatore può fornire del codice agli altri repository e mantenere un pubblico repository sul quale gli altri basano il proprio lavoro e verso il quale contribuiscono. Questo apre ad una vasta gamma di possibilità di workflow per il vostro progetto e/o il vostro team, quindi coprirò alcuni paradigmi che si avvantaggiano di questa flessibilità. Discuterò dei punti di forza e quelli deboli di ogni possibilità; potete usarne una sola, oppure prendere pezzi da diverse ed adattarle alle vostre necessità.

### Workflow centralizzato ###

Nei sistemi centralizzati, generalmente c'è un modo solo di collarare. Un fulcro centrale, o repository, può accettare il codice e tutti sincronizzano il lavoro con questo. Un numero di sviluppatori sono nodi - rispetto al fulcro - e restano sincronizzati rispetto ad un luogo centrale (vedi Figura 5-1).

Insert 18333fig0501.png 
Figura 5-1. Worlflow centralizzato

Questo significa che se due sviluppatori clonano dal fulcro ed entrambi fanno dei cambiamenti, il primo sviluppatore che eseguirà un push verso il fulcro non avrà problemi. Il secondo invece, dovrà unire al proprio il lavoro effettuato dal primo, prima di fare un push dei cambiamenti, per non sovrascrivere il lavoro del primo. Questo accade in Git come in Subversion (o un altro CVCS), e funziona tranquillamente in Git.

Se hai un piccolo team, o nella tua azienda sono già abituati ad un workflow centralizzato, puoi facilmente continuare ad utilizzare questo metodo con Git. Semplicemente crea un singolo repository, e dai ad ognuno la possibilità di effettuare un push; Git non lascerà agli utenti la possibilità di sovrascriversi l'un l'altro. Se uno sviluppatore clona, esegue dei cambiamenti, e poi prova a fare un push delle proprie modifiche dopo che un altro utente ha cambiato qualcosa, il server si rifiuterà di consentire l'operazione. L'utente sarà avvisato che sta cercando di fare un push di una copia non aggiornata, e non sarà capace di caricare le proprie modifiche finché non le unirà con quelle effettuate dagli altri.
Questo metodo è utilizzato da tanti dato che è il paradigma che molti conoscono e a cui sono abituati.

### Workflow con manager d'integrazione ###

Dato che Git ti consente di avere multipli repositories, è possibile avere un workflow dove ogni sviluppatore ha accesso in scrittura al proprio pubblico respository, e accesso il lettura a quello degli altri. Questo scenario spesso un repository "standard" che rappresenta il progetto "ufficiale". Per contribuire a quel progetto, devi creare il tuo clone pubblico del progetto stesso e fare un push delle modifiche verso esso. In seguito, si invia una richiesta al manager del progetto di eseguire un pull dei vostri cambiamenti. Possono aggiungere il vostro repository come remoto, testarlo localmente, unirlo al proprio ramo e fare un push verso il proprio repository. Il processo funziona così (vedi Figura 5-2):

1.  Il mantenitore del progetto fa un push del proprio repository pubblico.
2.  Un contributore clona il reposiory ed esegue dei cambiamenti.
3.  Il contributore fa un push dei propri cambiamenti.
4.  Il contributore invia al mantenitore una e-mail chiedendo di fare un pull dei cambiamenti.
5.  Il mantenitore aggiunge il repository del contributore come remoto e fa un merge in locale dei cambiamenti.
6.  Il mantenitore fa un push dei cambiamenti (compresi quelli aggiunti dal contributore) verso il repository principale.

Insert 18333fig0502.png 
Figura 5-2. Workflow con manager d'integrazione

Questo è un workflow comune con siti come GitHub, dove è facile eseguire un fork di un progetto e fare un push dei propri cambiamenti dentro al proprio fork, in modo che tutti possano accedere. Uno dei maggiori vantaggi di questo approccio è che puoi continuare il tuo lavoro, ed il mantenitore del repository principale può eseguire un pull dei tuoi cambiamenti in qualsiasi momento. I contributori non devono aspettare che il progetto incorpori i propri camiamenti, ed ognuno può lavorare per conto suo.

### Workflow con Dittatori e Tenenti ###

Questa è una variante del workflow con multipli repository. E' generalmente usata da grandi progetti con centinaia di collaboratori; un esempio famoso è il Kernel Linux. Molti manager d'integrazione sono in carica di certe parti del repository; sono chiamati tenenti. Tutti i tenenti hanno un manager d'integrazione conosciuto come "dittatore benevolo". Il repository del dittatore benevolo funziona come repository di riferimento dal quale tutti i collaboratori eseguono un pull. Il flusso di lavoro è il seguente (vedi Figura 5-3):

1.  Normali sviluppatori lavorano nel loro ramo ed eseguono un rebase del proprio lavoro sul master. Il ramo master è quello del dittatore.
2.  I tenenti eseguono l'unione del lavoro degli sviluppatori nel ramo master.
3.  Il dittatore esegue l'unione dei rami master dei tenenti nel proprio ramo master.
4.  Il dittatore esegue un push del proprio ramo master nel repository di riferimento, cosicché gli sviluppatori possano accedervi.

Insert 18333fig0503.png  
Figura 5.3. Workflow con dittatore benevolo.

Questo tipo di workflow non è comune ma può essere utile in progetti davvero grandi, o in ambienti con una stretta gerarchia, perché consente al leader del progetto (il dittatore) di delegare molto del lavoro e raccogliere vasti sottoinsiemi di codice in momenti diversi prima di integrarli.

Ci sono alcuni workflow comunemente utilizzati che sono possibili con un sistema distribuito come Git, ma puoi vedere che esistono molte variazioni attuabili per farlo adattare al tuo caso specifico. Ora che hai (spero) determinato quale workflow può funzionare per te, coprirò alcuni specifici esempi su come determinare i ruoli principali per realizzare differenti workflows.

## Contribuire ad un Progetto ##

Sai quali sono i diversi worlflows, e dovresti avere chiari i fondamentali utilizzi di Git. In questa sezione, parleremo di alcuni metodi comuni per contribuire ad un progetto.

La difficoltà maggiore nel descrivere questo processo, è che ci sono molte variazioni su come può venir fatto. Data la natura flessibile di Git, la gente può lavorare insieme in molti modi, ed è difficile descrivere come dovresti contribuire ad un progetto - ogni progetto è diverso. Alcune delle variabili coinvolte sono la quantità di contributori attivi, il workflow deciso, il tuo tipo di accesso per commit, ed eventualmente il metodo di contribuzione esterno.

La prima variabile è il numero di contributori attivi. Quando utenti attivamente contribuiscono con del codice a questo progetto, e quanto spesso? In molte situazioni avrai una manciata di sviluppatori con alcuni commits al giorno, o forse meno per dei progetti meno attivi. Per azienda o progetti davvero grandi, il numero di sviluppatori potrebbe essere nell'ordine delle migliaia, con dozzine o addirittura di centinaia di patches in arrivo ogni giorno. Questo è importante perché con più sviluppatori vai incontro a più problemi nell'applicare le modifiche in maniera pulita. I cambiamenti che fai potrebbero essere stati resi obsoleti o corrotti da altri che sono stati uniti mentre aspettavi che il tuo lavoro venisse approvato a applicato. Come si può tenere il proprio codice aggiornato e le proprie modifiche valide?

La prossima variabile è il workflow in uso nel progetto. E' centralizzato, con ogni sviluppatore avente lo stesso tipo di accesso in scrittura nel repository principale? Il progetto ha un manager d'integrazione che controlla tutte le modifiche? Tutte le modifiche sono riviste da più persone ed approvate? Sei coinvolto in questo processo? E' un sistema con dei tenenti, e devi fornire a loro il tuo lavoro innanzitutto?

Il problema successivo è il tuo accesso per il commit. Il workflow richiesto per poter contribuire al progetto è molto diverso a seconda del fatto che tua abbia accesso in scrittura o no. Se non hai accesso in scrittura, come viene preferito il lavoro dei contributori? Esiste qualche regola a riguardo? Quando contribuisci per volta? Quanto spesso?

Tutte queste domande possono influire effettivamente sul progetto e sul tipo di workflow preferibile per la tua situazione. Coprirò aspetti di ognuno di questi in una serie di casi d'uso, spaziando dal semplice al complesso; dovresti essere capace di ricostruire il workflow specifico per il tuo caso basandoti sugli esempi.

### Linee guida per il commit ###

Prima di guardare ai casi specifici, una breve nota riguardo ai messaggi di commit. Avere una linea guida per creare commit e aderirvi rende il lavoro con Git e la collaborazione con altri molto più semplice. Il progetto Git fornisce un documento che da alcuni suggerimenti per la creazione di messaggi di commit - puoi leggerlo nel codice sorgente di Git nel file `Documentation/SubmittingPatches`.

Innanzitutto, non è il caso di inserire spazi bianchi. Git fornisce un modo semplice per cercarli - prima di un commit, esegui `git diff --check`, che identifica possibili errori riguardanti spazi bianchi e li lista per te. Qui c'è un esempio, dove ho sistituiro il colore rosso del terminale con delle lettere `X`:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Se esegui quel commando prima del commit, puoi vedere se stai per inserire degli spazi bianchi che potrebbero infastidire altri sviluppatori.

In seguito, prova a rendere ogni commit un insieme logico di cambiamenti. Se puoi, cerca di rendere i cambiamenti "digeribili" - non scrivere codice per un intero weekend su cinque diversi problemi e poi fare un commit massivo il Lunedì. Anche se non esegui commit nel weekend, usa l'area di staging il Lunedì per suddividere il tuo lavoro in almeno un commit per problema, con un utile messaggio. Se diverse modifiche coinvolgono lo stesso file, usa `git add --patch` per aggiungere file in maniera parziale all'area di staging (spiegato nel dettaglio nel capitolo 6). Il risultato finale sarà lo stesso sia che tu faccia un commit sia che tu ne faccia cinque, finché tutti i cambiamenti sono aggiunti ad un certo punto, per cui cerca di rendere le cose più semplici ai tuoi colleghi sviluppatori quando devono controllare i tuoi cambiamenti. Questo approccio inoltre rende più semplice includere o escludere uno dei cambiamenti nel caso ti serva in seguito. Il capitolo 6 descrive una manciata di utili trucchetti di Git per riscrivere la storia ed aggiungere files all'area di staging in maniera interattiva - usa questi strumenti per mantenere una comprensibile cronologia.

L'ultima cosa da tenere in mente è il messaggio di commit. Prendere l'abitudine di creare messaggi di commit di qualità rende usare e collaborare tramite Git molto più semplice. Come regola generale, i tuoi messaggi dovrebbero iniziare con una singola linea di al massimo 50 caratteri che descrive il set di cambiamenti in maniera concisa, seguito da una linea bianca, ed in seguito una spiegazione dettagliata. Il progetto Git richiede che la spiegazione dettagliata includa il motivo del cambiamento ed il confronto con il comportamento precedente - questa è una buona linea guida da seguire. E' anche una buona idea usare la forma imperativa nel messaggio. In altre parole, usa dei comandi. Al posto di "Ho aggiunto dei test per" oppure "Aggiungere dei test per", usa "Aggiunti dei test per".
Questo è un modello scritto originariamente da Tim Pope su tpope.net:

  Breve (50 caratteri o meno) riassunto delle modifiche

  Testo di spiegazione più dettagliato, se necessario. Suddividilo ogni
  circa 72 caratteri. In alcuni contesti, la prima linea è trattata
  come l'oggetto di un'email, ed il resto come il contenuto. La linea
  vuota che separa il riassunto dal testo è importante (a meno che tu
  non ometta il testo del tutto); strumenti come rebase possono andare
  in confusione senza di essa.

  Ulteriore paragrafo dopo alcune linee vuote.

   - Le liste puntate sono concesse

   - Di solito un trattino od un asterisco viene usato come separatore,
     preceduto da uno spazio singolo, con linee vuote tra i punti,
     ma le convenzioni potrebbero variare in questo caso

Se tutti i tuoi messaggi di commit hanno questo aspetto, le cose saranno molto più semplici per per te e gli sviluppatore con cui lavori. Il progetto Git ha dei messaggi di commit ben formattati - ti incoraggio ad eseguire `git log --no-merges` per vedere qual'è l'aspetto di una cronologia ben leggibile.

Nei seguenti esempi, ed attraverso la maggior parte di questo libro, per brevità non formatterò i messaggi così accuratamente; invece userò l'opzione `-m` di `git commit`.
Fa come dico, non come faccio.

### Piccoli team privati ###

La configurazione più semplice e facile da incontrare è il progetto privato con uno o due sviluppatori. Con privato, intendo codice a sorgente chiuso - non accessibile dal resto del mondo. Tu gli altri sviluppatori avete tutti accesso per il push verso il repository.

In questo ambiente, puoi utilizzare un workflow simile a quello che magari stai già usando con Subversion od un altro sistema centralizzato. Hai ancora i vantaggi (ad esempio) di poter eseguire commit da offline e la creazione di rami (ed unione delli stessi) molto più semplici, ma il workflow può restare simile; la differenza principale è che l'unione avviene nel tuo repository piuttosto che in quello sul server nel momento del commit.
Vediamo come potrebbe essere la situazione quando due sviluppatori iniziano a lavorare insieme con un repository condiviso. Il primo sviluppatore, John, clona in repository, fa dei cambiamenti, ed esegue il commit localmente. (Sostituisco il messaggio di protocollo con `...` in questi esempi per brevità.)

	# Computer di John
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb 
	$ git commit -am 'rimosso valore di default non valido'
	[master 738ee87] rimosso valore di default non valido
	 1 files changed, 1 insertions(+), 1 deletions(-)

Il secondo sviluppatore, Jessica, fa la stessa cosa - clona il repository ed esegue dei cambiamenti:

	# Computer di Jessica
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO 
	$ git commit -am 'aggiunto il processo di reset'
	[master fbff5bc] aggiunto il processo di reset
	 1 files changed, 1 insertions(+), 0 deletions(-)

Ora, Jessica esegue un push del suo lavoro nel server:

	# Computer di Jessica
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

Anche John cerca di eseguire un push:

	# Computer di John
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

A John non è consentito eseguire un push perché Jessica ha fatto lo stesso nel frattempo. Questo è particolarmente importante se sei abituato a Subversion, perché avrai notato che i due sviluppatori non hanno modificato lo stesso file. Anche se Subversion automaticamente esegue questa unione nel server se differenti file sono stati modificati, in Git devi unire i cambiamenti localmente. John deve recuperare i cambiamenti di Jessica ed unirli ai suoi prima di poter eseguire il push:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

A questo punto, il repository locale di John somiglia a quello di figura 5-4.

Insert 18333fig0504.png 
Figura 5-4. Il repository iniziale di John.

John ha a disposizione i cambiamenti che Jessica ha eseguito, ma deve unirli ai suoi prima di avere la possibilità di eseguire un push:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

L'unione fila liscia - ora la cronologia dei commit di John sarà come quella di Figura 5-5.

Insert 18333fig0505.png 
Figura 5-5. Il repository di John dopo aver unito origin/master.

Ora, John può testare il suo codice per essere sicuro che funzioni anche correttamente, e può eseguire il push del tutto verso il server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Infine, la cronologia dei commit di John somiglierà a quella di figura 5-6.

Insert 18333fig0506.png 
Figura 5-6. La cronologia di John dopo avere eseguito il push verso il server.

Nel frattempo, Jessica sta lavorando su un altro ramo. Ha creato un ramo chiamato `problema54` ed ha eseguito tre commit su quel ramo. Non ha ancora recuperato i cambiamenti di John, per cui la sua cronologia di commit è quella di Figura 5-7.

Insert 18333fig0507.png 
Figura 5-7. La cronologia iniziale di Jessica.

Jessica vuole sincronizzarsi con John, così recupera:

	# Computer di Jessica
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Questo recupera il lavoro che John ha eseguito nel frattempo. La cronologia di Jessica ora è quella di Figura 5-8.

Insert 18333fig0508.png 
Figura 5-8. La cronologia di Jessica dopo aver recuperato i cambiamenti di John.

Jessica pensa che il suo ramo sia pronto, però vuole sapere con cosa deve unire il suo lavoro prima di eseguire il push. Esegue `git log` per scoprirlo:

	$ git log --no-merges origin/master ^problema54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    rimosso valore di default non valido

Ora, Jessica può unire il suo lavoro al ramo master, unire il lavoro di John (`origin/master`) nel suo ramo `master`, e poi eseguire il push verso il server di nuovo. Per prima cosa, torna nel suo ramo master per integrare il suo lavoro:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Può unire sia `origin/master` che `problema54` per primo - sono entrambi a monte, per cui l'ordine non conta. Il risultato finale sarà lo stesso a prescindere dall'ordine scelto; solo la cronologia sarà leggermente differente. Lei sceglie di unire `problema54` per primo:

	$ git merge problema54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Non ci sono problemi; come puoi vederem è stato tutto semplice. Ora Jessica unisce il lavoro di John (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Tutto viene unito correttamente, e la cronologia di Jessica è come quella di Figura 5-9.

Insert 18333fig0509.png 
Figura 5-9. La cronologia di Jessica dopo aver unito i cambiamenti di John.

Ora `origin/master` è raggiungibile dal ramo `master` di Jessica, cosicché lei sia capace di eseguire dei push successivamente (assumento che John non abbia fatto lo stesso nel frattempo):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Ogni sviluppatore ha eseguito alcuni commit ed unito il proprio lavoro con quello di altri con successo; vedi Figura 5-10.

Insert 18333fig0510.png
Figura 5-10. La cronologia di Jessica dopo aver eseguito il push dei cambiamenti verso il server.

Questo è uno dei workflow più semplici. Lavori per un pò, generalmente in un ramo, ed unisci il tutto al ramo master questo è pronto ad essere integrato. Quando vuoi condividere il tuoi lavoro, uniscilo al tuo ramo master, poi recupera ed unisci `origin/master` se è cambiato, ed infine esegui il push verso il ramo `master` nel server. La sequenza è simile a quella di Figura 5-11.

Insert 18333fig0511.png
Figura 5-11. La sequenza generale di eventi per un semplice workflow con Git a più sviluppatori.

### Team privato con manager ###

In questo prossimo scenario, scoprirai ai ruoli di un contributore in un gruppo privato più grande. Imparerai come lavorare in un ambiente dove piccoli gruppi collaborano a delle funzionalità e poi queste contribuzioni sono integrate da un altro componente.

Supponiamo che John e Jessica stiano lavorando insieme su una funzionalità, mentre Jessica e Josie si stanno concentrando su una seconda. In questo caso, l'azienda sta usando un workflow con manager d'integrazione dove il lavoro di ogni gruppo è integrato solo da certi ingegneri, ed il ramo `master` del repository principale può essere aggiornato solo dai suddetti ingegneri. In questo scenario, tutto il lavoro è eseguito sui rami suddivisi per team, ed unito dagli integratori in seguito.

Seguiamo il workflow di Jessica mentre lavora sulle due funzionalità, collaborando parallelamente con due diversi sviluppatori in questo ambiente. Assumendo che lei abbia già clonato il suo repository, decide di lavorare su `funzionalitaA` per prima. Crea un nuovo ramo per la funzionalità ed esegue del lavoro su di esso.

	# Computer di Jessica
	$ git checkout -b featureA
	Switched to a new branch "funzionalitaA"
	$ vim lib/simplegit.rb
	$ git commit -am 'aggiunto il limite alla funzione di log'
	[featureA 3300904] aggiunto il limite alla funzione di log
	 1 files changed, 1 insertions(+), 1 deletions(-)

A questo punto, lei ha bisogno di condividere il suo lavoro con John, così lei esegue il push del ramo `funzionalitaA` sul server. Jessica non ha accesso per il push al ramo `master` - solo gli integratori ce l'hanno - perciò deve eseguire il push verso un altro ramo per poter collaborare con John:

	$ git push origin funzionalitaA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica manda una e-mail a John dicendogli che ha eseguito il push del suo lavoro in un ramo chiamato `funzioanlitaA` e lui può dargli un'occhiata. Mentre aspetta una risposta da John, Jessica decide di iniziare a lavorare su `funzionalitaB` con Josie. Per iniziare, crea un nuovo ramo basandosi sul ramo `master` del server:

  # Computer di Jessica
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Ora, Jessica esegue un paio di commit sul ramo `funzionalitaB`:

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
Figura 5.12. La cronologia iniziale dei commit di Jessica
Figure 5-12. Jessica’s initial commit history.

Lei è pronta ad eseguire un push del proprio lavoro, ma riceve una e-mail da Josie la quale dice che una parte del lavoro era già stato messo nel server nel ramo chiamato `funzionalitaBee`. Jessica innanzitutto deve unire questi cambiamenti ai suoi prima di poter eseguire il push verso il server. Può recuperare il lavoro di Josie usando `git fetch`:

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

C'è un problema - deve eseguire il push del suo ramo `funzionalitaB` verso il ramo `funzionalitaBee` nel server. Può farlo specificando il ramo locale seguito dal simbolo dei due punti (:) seguito a sua volta dal nome del ramo remoto destinazione del comando `git push`:

	$ git push origin funzionalitaB:funzionalitaBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Questo è chiamato _refSpec_. Vedi il capitolo 9 per una discussione più dettagliata sui refspec di Git ed altre cose che puoi fare con loro.

Ora John manda una mail a Jessica dicendo che ha eseguito il push di alcuni cambiamenti sul ramo `funzionalitaA` e le chiede di controllarli. Lei esegue `git fetch` per recuperare questi cambiamenti:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

Ora, lei può vedere cos'è stato cambiamento con `git log`:

	$ git log origin/funzionalitaA ^funzionalitaA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    cambianto l'output del log da 30 a 25

Finalmente, unisce il lavoro di John al suo sul ramo `funzionalitaA`:

	$ git checkout funzionalitaA
	Switched to branch "funzionalitaA"
	$ git merge origin/funzionalitaA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica vuole aggiustare qualcosa, così esegue un altro commit ed un push verso il server:

	$ git commit -am 'leggero aggiustamento'
	[featureA ed774b3] leggero aggiustamento
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

Ora la cronologia dei commit di Jessica sarà come quella di Figura 5-13.

Insert 18333fig0513.png 
Figura 5-13. La cronologia di Jessica dopo aver eseguito il commit sul ramo.

Jessica, Josie e John informato gli integratori che i rami `funzionalitaA` e `funzionalitaB` sono sul server e pronti per l'integrazione nel ramo `master`. Dopo l'integrazione di questi rami nel `master`, un recupero del ramo principale aggiungerà anche i nuovi commit, rendendo la cronologia dei commit come quella di figura 5.14.

Insert 18333fig0514.png
Figura 5.14. La cronologia di Jessica dopo aver unito entrambi i rami.

Molti gruppi migrano verso Git per la sua capacità di avere più team a lavorarare in parallelo, unendo le differenti linee di lavoro alla fine del processo. L'abilità di piccoli sotto gruppi di una squadra di collaborare tramite rami remoti senza necessariamenti dover coinvolgere o ostacolare l'intero team è un grande beneficio di Git. La sequenza per il workflow che hai appena visto è rappresentata dalla Figura 5-15.

Insert 18333fig0515.png
Figura 5-15. Sequenza base di questo workflow con team separati.

### Piccolo progetto pubblico ###

Contribuire ad un progetto pubblico è leggermente differente. Dato che non hai il permesso di aggiornare direttamente i rami del progetto, devi far avere il tuo lavoro ai mantenitori in qualche altro modo. Questo esempio descrive la contribuzione via fork su host Git che lo supportano in maniera semplice. I siti repo.or.cz e GitHub lo supportano, e molti altri mantenitori di progetti si aspettano questo tipo di contribuzione. La prossima sezione si occupa di progetti che preferiscono accettare patch via e-mail

Innanzitutto, probabilemnte dovrai clonare il repository principale, creare un ramo per le modifiche che hai in programma di fare, e fare li il tuo lavoro. La sequenza è grossomodo questa:

	$ git clone (url)
	$ cd project
	$ git checkout -b funzionalitaA
	$ (lavoro)
	$ git commit
	$ (lavoro)
	$ git commit

Potresti voler usare `rebase -i` per ridurre il tuo lavoro ad un singolo commit, o riorganizzare il lavoro nei commit per rendere le modifiche semplice da controllare per il mantenitore - vedi il Capitolo 6 per altre informazioni sul rebasing interattivo.

Quando il tuo lavoro sul ramo è completato e sei pronto per farlo avere ai mantenitori, vai alla pagina principale del progetto e clicca sul link "Fork", creando una tua copia scrivibile del progetto. Dovrai poi aggiungere questo nuovo URL di repository come secondo URL remoto, in questo caso chiamato `miofork`:

	$ git remote add miofork (url)

Dovrai eseguire un push del tuo lavoro verso esso. E' più semplice eseguire il push del ramo su cui stai lavorando piuttosto che unirlo al ramo master ed eseguire il push di quest'ultimo. La ragione è che se il tuo lavoro non è accettato, oppure lo è solo in parte, non dovrai tornare indietro nei commit sul tuo ramo master. Se i mantenitori uniscono, eseguono un rebase, o prendono pezzi dal tuo lavoro, riuscirai in ogni caso a recuperarlo eseguendo un pull dal loro repository:

	$ git push myfork funzionalitaA

Quando hai eseguito il push del tuo lavoro verso il tuo fork, devi farlo sapere al mantenitore. Questo passaggio è chiamato spesso richiesta di pull (pull request), e puoi farlo sia tramite il sito - GitHub ha un pulsante "pull request" che automaticamente notifica al mantenitore - o eseguire il comando `git request-pull` ed inviare l'output il mantenitore manualmente.

Il comando `request-pull` riceve come parametri il ramo base sul quale vuoi far applicare le modifiche ed l'URL del repository Git da cui vuoi estrarle, ed in output fornisce un riassunto di tutte queste modifiche. Per esempio, se Jessica volesse inviare a John una richiesta di pull, e lei ha eseguito due commit sul ramo di cui ha appena effettuato il push, può eseguire questo:

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

L'output può venir inviarto al mantenitore - riporta da dove è stato creato il nuovo ramo, un riassunto dei commit e dice da dove possono eseguire il pull.

Su un progetto dove non sei il mantenitore, è generalmente comune avere un ramo come `master` sempre collegato a `origin/master` ed eseguire il tuo lavoro su rami che puoi eliminare nel caso non venissero accettati. Avere il lavoro suddiviso in rami inoltre rende semplice per te eseguire il rebase del tuo lavoro se è stato modificato il repository principale ed i tuoi commit non possono venire applicati in maniera pulita. Per esempio, se vuoi aggiungere un secondo argomento di lavoro ad un progetto, non continuare a lavorare sul ramo di cui hai appena fatto il push - creane un altro partendo dal ramo `master` del repository:

	$ git checkout -b funzionalitaB origin/master
	$ (lavoro)
	$ git commit
	$ git push miofork funzionalitaB
	$ (email al mantenitore)
	$ git fetch origin

Ora, ognuno dei tuoi lavori è separato - simile ad una coda di modifiche - che puoi riscrivere, effettuare un rebase, e modificare senza che i rami interferiscano o dipendano l'uno dall'altro, come in Figura 5-16.

Insert 18333fig0516.png 
Figura 5-16. Conologia iniziale dei commit con del lavoro su funzionalitaB.

Diciamo che il mantenitore del progetto ha eseguito il pull una manciata di altre modifiche, e provato il tuo primo ramo, ma non riesce più ad applicarsi in maniera pulita. In questo caso, puoi provare ad effettuare un rebase di quel ramo basandoti sul nuovo `origin/master`, risolvere in conflitti e poi inviare di nuovo i tuoi cambiamenti:

	$ git checkout funzionalitaA
	$ git rebase origin/master
	$ git push –f miofork featureA

Questo riscrive la tua cronologia per farla diventare come quella di Figura 5-17.

Insert 18333fig0517.png
Fgiura 5-17. La cronologia dei commit dopo il lavoro su funzionalitaA.

Dato che hai eseguito un rebase del ramo, devi specificare l'opzione `-f` per eseguire un push, per poter sostituire il ramo `funzionalitaA` sul server con un commit che non discende da esso. Un'alternativa potrebbe essere un push di questo nuovo lavoro verso un diverso branch sul server (chiamato ad esempio `funzionalitaAv2`).

Diamo un'occhiata ad un possibile scenario: il mantenitore ha guardato al tuo lavoro in un secondo ramo, e gradisce il concetto ma vorrebbe che tu cambiassi dei dettagli dell'implementazione. Potresti inoltre cogliere questa opportunità per basarti sul ramo `master` corrente. Crei un nuovo ramo basato sul corrente `origin/master`, sposti i cambiamenti di `funzionalitaB` qui, risolvi i conflitti, cambi l'implementazione, e poi esegui il push come un nuovo ramo:

	$ git checkout -b funzionalitaBv2 origin/master
	$ git merge --no-commit --squash funzionalitaB
	$ (cambia implementazione)
	$ git commit
	$ git push miofork funzionalitaBv2

L'opzione `--squash` prende tutto il lavoro nel ramo da unire e lo aggiunge al ramo in cui sei. L'opzione `no-commit` dice a Git di non eseguire automaticamente un commit. Questo ti consente di aggiungere i cambiamenti da un altro ramo e poi eseguire altre modifiche prima di effettuare il nuovo commit.

Ora puoi inviare al mantenitore un messaggio dicendo che hai effettuato i cambiamenti richiesti e che può trovare nel ramo `funzionalitaBv2` (vedi Figura 5-18).

Insert 18333fig0518.png
Figura 5-18. La cronologia dei commit dopo il lavoro su funzionalitaBv2.

### Public Large Project ###

Many larger projects have established procedures for accepting patches — you’ll need to check the specific rules for each project, because they will differ. However, many larger public projects accept patches via a developer mailing list, so I’ll go over an example of that now.

The workflow is similar to the previous use case — you create topic branches for each patch series you work on. The difference is how you submit them to the project. Instead of forking the project and pushing to your own writable version, you generate e-mail versions of each commit series and e-mail them to the developer mailing list:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Now you have two commits that you want to send to the mailing list. You use `git format-patch` to generate the mbox-formatted files that you can e-mail to the list — it turns each commit into an e-mail message with the first line of the commit message as the subject and the rest of the message plus the patch that the commit introduces as the body. The nice thing about this is that applying a patch from an e-mail generated with `format-patch` preserves all the commit information properly, as you’ll see more of in the next section when you apply these commits:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

The `format-patch` command prints out the names of the patch files it creates. The `-M` switch tells Git to look for renames. The files end up looking like this:

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

You can also edit these patch files to add more information for the e-mail list that you don’t want to show up in the commit message. If you add text between the `--` line and the beginning of the patch (the `lib/simplegit.rb` line), then developers can read it; but applying the patch excludes it.

To e-mail this to a mailing list, you can either paste the file into your e-mail program or send it via a command-line program. Pasting the text often causes formatting issues, especially with "smarter" clients that don’t preserve newlines and other whitespace appropriately. Luckily, Git provides a tool to help you send properly formatted patches via IMAP, which may be easier for you. I’ll demonstrate how to send a patch via Gmail, which happens to be the e-mail agent I use; you can read detailed instructions for a number of mail programs at the end of the aforementioned `Documentation/SubmittingPatches` file in the Git source code.

First, you need to set up the imap section in your `~/.gitconfig` file. You can set each value separately with a series of `git config` commands, or you can add them manually; but in the end, your config file should look something like this:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

If your IMAP server doesn’t use SSL, the last two lines probably aren’t necessary, and the host value will be `imap://` instead of `imaps://`.
When that is set up, you can use `git send-email` to place the patch series in the Drafts folder of the specified IMAP server:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>] 
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Then, Git spits out a bunch of log information looking something like this for each patch you’re sending:

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

At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off.

### Summary ###

This section has covered a number of common workflows for dealing with several very different types of Git projects you’re likely to encounter and introduced a couple of new tools to help you manage this process. Next, you’ll see how to work the other side of the coin: maintaining a Git project. You’ll learn how to be a benevolent dictator or integration manager.

## Maintaining a Project ##

In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run.

### Working in Topic Branches ###

When you’re thinking of integrating new work, it’s generally a good idea to try it out in a topic branch — a temporary branch specifically made to try out that new work. This way, it’s easy to tweak a patch individually and leave it if it’s not working until you have time to come back to it. If you create a simple branch name based on the theme of the work you’re going to try, such as `ruby_client` or something similarly descriptive, you can easily remember it if you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these branches as well — such as `sc/ruby_client`, where `sc` is short for the person who contributed the work. 
As you’ll remember, you can create the branch based off your master branch like this:

	$ git branch sc/ruby_client master

Or, if you want to also switch to it immediately, you can use the `checkout -b` option:

	$ git checkout -b sc/ruby_client master

Now you’re ready to add your contributed work into this topic branch and determine if you want to merge it into your longer-term branches.

### Applying Patches from E-mail ###

If you receive a patch over e-mail that you need to integrate into your project, you need to apply the patch in your topic branch to evaluate it. There are two ways to apply an e-mailed patch: with `git apply` or with `git am`.

#### Applying a Patch with apply ####

If you received the patch from someone who generated it with the `git diff` or a Unix `diff` command, you can apply it with the `git apply` command. Assuming you saved the patch at `/tmp/patch-ruby-client.patch`, you can apply the patch like this:

	$ git apply /tmp/patch-ruby-client.patch

This modifies the files in your working directory. It’s almost identical to running a `patch -p1` command to apply the patch, although it’s more paranoid and accepts fewer fuzzy matches than patch. It also handles file adds, deletes, and renames if they’re described in the `git diff` format, which `patch` won’t do. Finally, `git apply` is an "apply all or abort all" model where either everything is applied or nothing is, whereas `patch` can partially apply patchfiles, leaving your working directory in a weird state. `git apply` is overall much more paranoid than `patch`. It won’t create a commit for you — after running it, you must stage and commit the changes introduced manually.

You can also use git apply to see if a patch applies cleanly before you try actually applying it — you can run `git apply --check` with the patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch 
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

If there is no output, then the patch should apply cleanly. This command also exits with a non-zero status if the check fails, so you can use it in scripts if you want.

#### Applying a Patch with am ####

If the contributor is a Git user and was good enough to use the `format-patch` command to generate their patch, then your job is easier because the patch contains author information and a commit message for you. If you can, encourage your contributors to use `format-patch` instead of `diff` to generate patches for you. You should only have to use `git apply` for legacy patches and things like that.

To apply a patch generated by `format-patch`, you use `git am`. Technically, `git am` is built to read an mbox file, which is a simple, plain-text format for storing one or more e-mail messages in one text file. It looks something like this:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

This is the beginning of the output of the format-patch command that you saw in the previous section. This is also a valid mbox e-mail format. If someone has e-mailed you the patch properly using git send-email, and you download that into an mbox format, then you can point git am to that mbox file, and it will start applying all the patches it sees. If you run a mail client that can save several e-mails out in mbox format, you can save entire patch series into a file and then use git am to apply them one at a time. 

However, if someone uploaded a patch file generated via `format-patch` to a ticketing system or something similar, you can save the file locally and then pass that file saved on your disk to `git am` to apply it:

	$ git am 0001-limit-log-function.patch 
	Applying: add limit to log function

You can see that it applied cleanly and automatically created the new commit for you. The author information is taken from the e-mail’s `From` and `Date` headers, and the message of the commit is taken from the `Subject` and body (before the patch) of the e-mail. For example, if this patch was applied from the mbox example I just showed, the commit generated would look something like this:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

The `Commit` information indicates the person who applied the patch and the time it was applied. The `Author` information is the individual who originally created the patch and when it was originally created. 

But it’s possible that the patch won’t apply cleanly. Perhaps your main branch has diverged too far from the branch the patch was built from, or the patch depends on another patch you haven’t applied yet. In that case, the `git am` process will fail and ask you what you want to do:

	$ git am 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

This command puts conflict markers in any files it has issues with, much like a conflicted merge or rebase operation. You solve this issue much the same way — edit the file to resolve the conflict, stage the new file, and then run `git am --resolved` to continue to the next patch:

	$ (fix the file)
	$ git add ticgit.gemspec 
	$ git am --resolved
	Applying: seeing if this helps the gem

If you want Git to try a bit more intelligently to resolve the conflict, you can pass a `-3` option to it, which makes Git attempt a three-way merge. This option isn’t on by default because it doesn’t work if the commit the patch says it was based on isn’t in your repository. If you do have that commit — if the patch was based on a public commit — then the `-3` option is generally much smarter about applying a conflicting patch:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In this case, I was trying to apply a patch I had already applied. Without the `-3` option, it looks like a conflict.

If you’re applying a number of patches from an mbox, you can also run the `am` command in interactive mode, which stops at each patch it finds and asks if you want to apply it:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all 

This is nice if you have a number of patches saved, because you can view the patch first if you don’t remember what it is, or not apply the patch if you’ve already done so.

When all the patches for your topic are applied and committed into your branch, you can choose whether and how to integrate them into a longer-running branch.

### Checking Out Remote Branches ###

If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and then sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and do merges locally.

For instance, if Jessica sends you an e-mail saying that she has a great new feature in the `ruby-client` branch of her repository, you can test it by adding the remote and checking out that branch locally:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

If she e-mails you again later with another branch containing another great feature, you can fetch and check out because you already have the remote setup.

This is most useful if you’re working with a person consistently. If someone only has a single patch to contribute once in a while, then accepting it over e-mail may be less time consuming than requiring everyone to run their own server and having to continually add and remove remotes to get a few patches. You’re also unlikely to want to have hundreds of remotes, each for someone who contributes only a patch or two. However, scripts and hosted services may make this easier — it depends largely on how you develop and how your contributors develop.

The other advantage of this approach is that you get the history of the commits as well. Although you may have legitimate merge issues, you know where in your history their work is based; a proper three-way merge is the default rather than having to supply a `-3` and hope the patch was generated off a public commit to which you have access.

If you aren’t working with a person consistently but still want to pull from them in this way, you can provide the URL of the remote repository to the `git pull` command. This does a one-time pull and doesn’t save the URL as a remote reference:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Determining What Is Introduced ###

Now you have a topic branch that contains contributed work. At this point, you can determine what you’d like to do with it. This section revisits a couple of commands so you can see how you can use them to review exactly what you’ll be introducing if you merge this into your main branch.

It’s often helpful to get a review of all the commits that are in this branch but that aren’t in your master branch. You can exclude commits in the master branch by adding the `--not` option before the branch name. For example, if your contributor sends you two patches and you create a branch called `contrib` and applied those patches there, you can run this:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

To see what changes each commit introduces, remember that you can pass the `-p` option to `git log` and it will append the diff introduced to each commit.

To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to use a weird trick to get the correct results. You may think to run this:

	$ git diff master

This command gives you a diff, but it may be misleading. If your `master` branch has moved forward since you created the topic branch from it, then you’ll get seemingly strange results. This happens because Git directly compares the snapshots of the last commit of the topic branch you’re on and the snapshot of the last commit on the `master` branch. For example, if you’ve added a line in a file on the `master` branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.

If `master` is a direct ancestor of your topic branch, this isn’t a problem; but if the two histories have diverged, the diff will look like you’re adding all the new stuff in your topic branch and removing everything unique to the `master` branch.

What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.

Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db 

However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch:

	$ git diff master...contrib

This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember.

### Integrating Contributed Work ###

When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them.

#### Merging Workflows ####

One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20.

Insert 18333fig0519.png 
Figure 5-19. History with several topic branches.

Insert 18333fig0520.png
Figure 5-20. After a topic branch merge.

That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects.

If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23).

Insert 18333fig0521.png 
Figure 5-21. Before a topic branch merge.

Insert 18333fig0522.png 
Figure 5-22. After a topic branch merge.

Insert 18333fig0523.png 
Figure 5-23. After a topic branch release.

This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.
You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch.

#### Large-Merging Workflows ####

The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together.

Insert 18333fig0524.png 
Figure 5-24. Managing a complex series of parallel contributed topic branches.

If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25).

Insert 18333fig0525.png 
Figure 5-25. Merging contributed topic branches into long-term integration branches.

When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions.

#### Rebasing and Cherry Picking Workflows ####

Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history.

The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26.

Insert 18333fig0526.png 
Figure 5-26. Example history before a cherry pick.

If you want to pull commit `e43a6` into your master branch, you can run

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27.

Insert 18333fig0527.png 
Figure 5-27. History after cherry-picking a commit on a topic branch.

Now you can remove your topic branch and drop the commits you didn’t want to pull in.

### Tagging Your Releases ###

When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg --list-keys`:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

If you run `git push --tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG:

	$ git show maintainer-pgp-pub | gpg --import

They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification.

### Generating a Build Number ###

Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git --version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name.

The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated.

### Preparing a Release ###

Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `--format=zip` option to `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people.

### The Shortlog ###

It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1:

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

You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list.

## Summary ##

You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master.
