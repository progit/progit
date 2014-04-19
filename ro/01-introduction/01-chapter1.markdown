# Introducere #

În acest capitol vom discuta despre cum să facem primii pași cu Git. Vom începe cu începutul, și anume, prin a explica câteva detalii despre controlul versiunilor, apoi vom continua prin a arăta cum instalăm Git pe sistemul dumneavoastră și în final cum să începem să lucram cu el. La finalul acestui capitol ar trebui să înțelegeți de ce Git este folosit, de ce ar trebui sa îl folosiți și ar trebui ca totul să fie pregătit pentru utilizare.

## Despre Controlul Versiunilor ##

Ce este de fapt controlul versiunilor, și de ce ar trebui să ne pese? Controlul versiunilor este un sistem care înregistrează schimbările dintr-un fișier sau o mulțime de fișiere de-a lungul timpului astfel încât putem reveni la anumite versiuni mai târziu. Pentru exemplele din acestă carte veți folosi cod sursă ca și fișiere ce se află în sistemul de versionare, cu toate că în realitate puteți face asta pentru aproape orice tip de fișier de pe un calculator.

Dacă sunteți un designer web sau de grafică și doriți să vă păstrați fiecare versiune a unei imagini sau fiecare paginare creată (pe care mai mult ca sigur o doriți), un Sistem de Control al Versiunilor (SCV, VCS [en]) este un lucru foarte util în munca zilnică. Acesta vă va permite să reveniți la o stare anterioară, să comparați schimbările de-a lungul timpului, să vedeți cine a făcut ultima modificare ce poate cauza o problemă, cine a introdus o anumită problemă și când, și multe altele. Folosind un VCS mai înseamnă în general că dacă reușiți totuși să stricați lucruri sau să pierdeți fișiere, veți putea recupera cu ușurință datele inițiale. În plus, obțineți toate acestea cu un minim de resurse suplimentare.

### Sisteme Locale pentru Controlul Versiunilor ###

Metoda aleasă de mulți pentru controlul versiunilor este de a copia fișierele în alt director (poate chiar un director care conține data în nume, dacă sunt isteți). Această abordare este foarte comună pentru că este atât de simplă, dar în același timp este foarte susceptibilă la erori. Este atât de ușor să uitați în care director lucrați în prezent și din neatenție să scrieți în fișierul incorect sau să suprascrieți fișiere ce nu intenționați să schimbați.

Pentru a trata această problemă, programatorii au dezvoltat cu mult timp în urmă sisteme locale pentru controlul versiunilor (VCS locale) care conțineau o bază de date simplă ce ținea toate schimbările fișierelor aflate sub controlul versiunilor (vezi Figura 1-1).

Insert 18333fig0101.png 
Figura 1-1. Diagramă pentru controlul versiunilor local.

Unul dintre cele mai populare unelte VCS era un sistem denumit rcs, care este încă distribuit cu multe calculatoare și astăzi. Până și popularul sistem de operare Mac OS X include comanda rcs atunci când instalați Uneltele de Dezvoltare. Acest utilitar practic funcționează prin menținerea mai multor mulțimi de patch-uri ("petice" [ro], care reprezintă de fapt diferențele dintre fișiere) de la schimbare la alta într-un format special pe disc; apoi utilitarul poate recrea cum arăta un anumit fișier la un anumit moment de timp prin adăugarea tuturor patch-urilor.

### Sisteme Centralizate pentru Controlul Versiunilor ###

Următoarea mare problemă pe care oamenii o au este necesitatea de a colabora cu alți dezvoltatori din alte sisteme. Pentru a face față acestei probleme, au fost dezvoltate Sisteme Centralizate de Controlul Versiunilor (SCCV, CVCS [en]). Aceste sisteme, cum ar fi CVS, Subversion, și Perforce, au un singur server care conține toate fișierele aflate sub controlul versiunilor, și un număr de clienți care preiau (check out [en]) fișiere din acea locație centrală. Timp de mulți ani, acesta a reprezentat standardul sistemele pentru controlul versiunilor (vezi Figura 1-2).

Insert 18333fig0102.png 
Figura 1-2. Diagramă pentru controlul versiunilor centralizat.

Acest model oferă multe avantaje, în special pentru sistemele locale de versionare. De exemplu, oricine știe până la un anumit punct ce face într-un proiect orice altcineva. Administratorii au un control foarte exact asupra ce poate face un anumit utilizator; în același timp fiind mult mai ușor de administrat un CVCS decât lucrul cu baze de date locale fiecărui client.

Totuși, acest model are și niște dezavantaje serioase. Cel mai evident este legat de un singur punct slab care este reprezentat de serverul central. Dacă acel server se oprește timp de o oră, în acea perioadă nimeni nu mai poate colabora cu nimeni altcineva sau nu poate salva schimbările făcute în cadrul proiectului la care lucrează. Dacă hard discul bazei de date centrale se defectează, și nu există un back-up consistent, se poate ajunge la situația de a pierde totul - întreaga istorie a proiectului cu excepția lucrurilor curente pe care unii membrii ai proiectului le pot avea pe stațiile de lucru locale. Sistemele locale de versionare suferă de aceleași probleme - oricând avem întreaga istorie a unui proiect într-un singur loc, riști să pierzi totul.

### Sisteme Distribuite pentru Controlul Versiunilor ###

Acum este momentul în care Sistemele Distribuite pentru Controlul Versiunilor (DVCS [en]) își fac apariția. Într-un DVCS (cum ar fi Git, Mercurial, Bazaar sau Darcs), clienții nu doar preiau ultima versiune a fișierelor: ei descarcă o copie completă a repository-ului. Deci chiar dacă orice server se defectează, și aceste sisteme colaborau prin intermediul lui, oricare din repository-urile de la client pot fi copiate înapoi pe server pentru a-l aduce la starea inițială. Fiecare checkout este efectiv un backup complet a tuturor datelor (vezi Figura 1-3).

Insert 18333fig0103.png 
Figura 1-3. Diagramă cu sistemul distribuit al versiunilor.

Mai mult, multe din aceste sisteme se descurcă suficient de bine cu lucrul simultan cu mai multe repository-uri, așă că putem colabora cu diferite grupuri de oameni în diverse moduri în același timp în cadrul aceluiași proiect. Aceasta ne permite să ne configurăm diverse modele de lucru care nu sunt posibile în sistemele centralizate, de exemplu un model ierarhic.
Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.

## O Scurtă Istorie a Git ##

Ca și cu multe alte lucruri bune din viață, Git a început cu puțină distrugere creativă și multe controverse. Kernelul Linux este un proiect open source cu o gamă de aplicabilitate destul de mare. În marea parte a vieții proiectului (1991-2002), schimbările din cadrul kernelului Linux erau trimise ca și patches sau fișiere arhivate. În 2002, kernelul Linux a început să folosească un DVCS proprietar numit BitKeeper.

În 2005, relațiile dintre comunitatea care dezvolta kernelul și firma care dezvolta BitKeeper s-au stricat, și statutul de gratuit al aplicației a fost revocat. Această schimbare a impus comunității (și în special lui Linus Torvalds, creatorul Linux) să dezvolte propriul sistem bazat pe unele din lucrurile învățate în timpul utilizării BitKeeper. Unele din scopurile noului sistem au fost:

*	Rapiditate
*	Design simplu
*	Suport puternic pentru dezvoltare nelineară (mii de branch-uri paralele)
*	Complet distribuit
*	Abilitatea de a gestiona proiecte mari similare cu kernelul Linux într-un mod eficient (din punct de vedere al vitezei și mărimii datelor)

Începând cu nașterea sa din 2005, Git a evoluat și s-a maturizat pentru a deveni ușor de folosit dar păstrându-și toate aceste calități inițiale. Git este incredibil de rapid, este foarte eficient cu proiecte mari, și deține un sistem incredibil pentru crearea de branch-uri utilizate in dezvoltarea neliniară (Vezi Capitolul 3).

## Bazele Git ##

Pe scurt, ce este Git? Această secțiune este important de urmărit, deoarece dacă ințelegeți ceea ce este Git și bazele funcționării acestuia, atunci folosirea lui eficientă va fi mult ușurată pentru dumneavoastră. Pe măsură ce învățați Git, încercați să vă mențineți o minte limpede cu privire la lucrurile deja cunoscute de la alte sisteme de versionare, cum ar fi Subversion și Perforce; făcând asta vă va ajuta să evitați confuziile subtile cauzate de folosirea inițială a sa. Git stochează informațiile și lucrează cu ele mult diferit comparativ cu oricare din acele sisteme, chiar dacă interfața cu utilizatorul este destul de asemănătoare; înțelegerea acelor diferențe vă va ajuta să nu fiți confuz în timpul folosirii.

### Instantanee, nu Diferențe ###
Principala diferență dintre Git și oricare alte sisteme de versionare (Subversion și prietenii săi inclusiv) este modul în care Git își gestionează datele. Conceptual, majoritatea celorlalte sisteme își stochează informațiile ca o listă de schimbări asupra fișierelor. Aceste sisteme (CVS, Subversion, Perforce, Bazaar și altele) văd informațiile ca o mulțime de fișiere și schimbările asupra fișierelor în timp, după cum este ilustrat în Figura 1-4.

Insert 18333fig0104.png 
Figura 1-4. Alte sisteme tind să stocheze datele ca schimbări relative la versiune de bază a fiecărui fișier.

Git nu vede și nici nu stochează datele în acest mod. În schimb, Git consideră datele sale mai mult ca o mulțime de instantanee (snapshots [en]) ale unu mini sistem de fișiere. De fiecare dată când faceți commit, sau salvați starea proiectului dumneavoastră în Git, acesta practic salvează o poză a stării curente a tuturor fișierelor din acel moment și stochează o referință la acel instantaneu. Pentru a fi eficient, dacă există fișiere care nu s-au schimbat, Git nu stochează fișierul iarași ci doar o legătură către fișierul anterior stocat identic cu cel din prezent. Git vede datele stocate similar cu Figura 1-5.

Insert 18333fig0105.png 
Figura 1-5. Git stochează datele ca și instantanee ale proiectului de-a lungul timpului.

Aceasta este o distincție importantă dintre Git și aproape toate celelalte VCS. Aceasta face ca Git să reconsidere fiecare aspect al controlului versiunilor pe care majoritatea sistemelor le-au copiat de la generația anterioară. Acest aspect face ca Git să fie mult asemănător cu un mini sistem de fișiere cu niște unelte incredibil de utile adăugate peste el, comparativ cu un simplu VCS, Vom analiza unele dintre benefiicle câștigate prin a vedea datele voastre în acest fel atunci când ne vom ocupa de crearea ramurilor (branches [en]) in Capitolul 3.

### Aproape Orice Operație Este Locală ###

Majoritatea operațiilor în Git necesită doar fișiere locale și resurse locale pentru a funcționa - în general nu sunt necesare informații de la un alt calculator din rețea. Dacă sunteți obișnuit cu un CVCS în care majoritatea operațiilor au o extra latență dată de rețea, aceste aspect al Git vă va face să credeți că zeii vitezei au binecuvântat Git cu puteri din alte lumi. Deoarece aveți întreaga istorie a proiectului chiar aici pe discul local, majoritatea operațiilor par aproape instantanee.

De exemplu, pentru a răsfoi istoria proiectului, Git nu necesită să acceseze serverul pentru a prelua istoria și să o afișeze pentru dumneavoastră - pur și simplu o citește direct din baza de date locală. Aceasta înseamnă că vedeți istoria proiectului aproape instant. Dacă doriți să vedeți schimbările introduse între versiunea curentă a fișierului și cea de acum o lună, Git poate căuta fișierul de acum o lună și să facă un calcul față de diferența locală, în loc de a cere unui server să o facă sau să descarce o versiune mai veche a fișierului de la un server și apoi să facă operația local.

Aceasta înseamnă de asemenea că sunt foarte puține lucruri care nu le puteți face atunci când nu sunteți conectat la rețea sau prin VPN. Dacă sunteți într-un avion sau într-un tren și doriți să munciți putin, puteți adăuga schimbări proiectului iar când ajungeți la o rețea să le încărcați. Dacă ajungeți acasă și nu vă puteți porni clientul VPN, încă puteți lucra. În multe alte sisteme, aceste activități sunt fie imposibile fie foarte greoaie de gestionat. În Perforce, nu puteți face mare lucru atunci când nu sunteți conectat la server; și în Subversion și CVS, puteți edita fișiere, dar nu le puteți face commit în baza de date (deoarece baza de date nu poate fi accesată). Aceasta poate părea o mică îmbunătațire, dar veți fi surprins ce diferență imensă poate face.

### Git Are Integritate ###

Totul in Git are o sumă de control (checksum [en]) înainte de a fi stocat și este apoi referit de către acea sumă de control. Aceasta înseamnă că este imposibil de schimbat conținutul oricărui fișier sau director fără ca Git să știe de el. Aceast funcționalitate este inclusă în Git la cele mai de jos nivele și este o parte integrantă a filosofiei sale. Nu puteți pierde informații în tranzit sau să întâlniți corupere de fișiere fără ca Git să le detecteze.

Mecanismul folosit de Git pentru sumele de control este denumit hash SHA-1. Acesta este un șir de 40 de caractere compus din caractere hexazecimale (toate cifrele, 0 la 9 și caracterele de la a la f) și este calculat pe baza conținutului unui fișier sau a structurii de directoare din Git. Un hash SHA-1 arată similar cu următorul șir:

	24b9da6552252987aa493b52f8696cd6d3b00373

Veți vedea aceste șiruri peste tot în cadrul Git deoarece Git le folosește foarte mult. De fapt, Git stochează orice nu bazându-se pe numele fișierului ci în baza de date Git adresabilă prin intermediul valorii hash a conținutului său. 

### Git Adaugă Date în General ###

Când efectuați anumite operații în Git, aproape toate din ele doar adaugă date în baza de date Git. Este foarte dificil să constrângem sistemul să facă orice operații care sunt permanente sau să șteargă date în vreun fel. Dar ca în orice VCS, puteți pierde sau strica informații datorată schimbărilor care nu sunt deja adăugate; dar după ce faceți commit unui snapshot în Git, este foarte dificil să pierdeți date, mai ales dacă vă împingeți (push [en]) repository-ul către un alt repository.

Acest fapt face Git foarte ușor de folosit deoarece știm că putem experimenta fără a fi în pericol de a strica lucrurile într-un mod grav. Pentru o privire mai atentă la cum stochează Git datele și cum puteți recupera date care par pierdute, vedeți "Sub Capota Git" din Capitolul 9.

### Cele Trei Stări ###

Acum, fiți atenți. Acesta este lucrul principal care trebuie să vi-l amintiți despre Git dacă doriți ca restul procesului de învățare să se desfășoare lin. Git are trei stări principale în care se pot afla fișierele: comise, modificate, și în așteptare (commited, modified, staged [en]). Comise (commited [en]) presupune că datele sunt în siguranță în baza de date locală. Modificate presupune că ați schimbat fișierul dar nu l-ați comis încă în baza de date. În așteptare (staged [en]) înseamnă că ați marcat un fișier în forma curentă să fie inclus în următorul instantaneu comis (commited snapshot [en]).

Aceasta ne duce la principalele trei secțiuni ale unui proiect Git: directorul Git, directorul curent, și zona de așteptare (staging area [en]).

Insert 18333fig0106.png 
Figura 1-6. Directorul de lucru, zona de așteptare, și directorul git.

Directorul Git este locația unde Git își stochează metadate și baza de date cu obiecte a proiectului dumneavoastră. Aceasta este partea cea mai importantă a Git, și reprezintă ceea ce este copiat atunci când clonați un repository de la un alt calculator.

Directorul de lucru reprezintă un singur checkout al unei versiuni a proiectului. Aceste fișiere sunt preluate din baza de date comprimată din directorul Git și plasate pe discul dumneavoastră pentru a le putea modifica.

Zona de așteptare (staging [en]) este un simplu fișier, de obicei conținut in directorul Git, și stochează informații despre ce va fi folosit pentru urmatorul commit. Este uneori denumit și index, dar devine obișnuit să i se spună zona de așteptare.

Modelul de lucru a Git poate arată ceva similar cu:

1. Modificați fișierele din directorul de lucru.
2. Puneți fișierele în așteptare, adăugând instantanee ale lor în zona de așteptare.
3. Faceți un commit, care preia fișierele în starea curentă din zona de așteptare și stochează acel instantaneu permanent în directorul dumneavoastră Git.

Dacă o anumită versiune a unui fișier este în directorul Git, este considerat ca și adăugat (commited [en]). Dacă este modificat dar a fost adăugat în zona de așteptare, este în așteptare. Si dacă a fost schimbat de la ultimul moment în care a fost comis dar nu este în așteptare, este modificat. În Capitolul 2, veți învăța mai multe despre aceste stări și cum puteți fie să le folosiți în avantajul dumneavoastră sau să le omiteți complet.

## Instalarea Git ##

Să începem să folosim Git. Începând cu începutul - trebuie să îl instalăm. Puteți să îl obțineți în mai multe feluri; cele mai importante sunt să îl instalați din surse sau să instalați un pachet deja existent pentru platforma dumneavoastră.

### Instalarea din Fișiere Sursă ###

Dacă puteți, este uneori folositor să instalați Git din surse, deoarece veți obține cea mai nouă versiune. Fiecare nouă versiune tinde să conțină îmbunătațiri ale interfeței, așa că dacă doriți ultima apariție aceasta este cea mai bună metodă dacă sunteți confortabil în lucrul cu cod sursă. Uneori puteți întâlni cazul în care versiunea dumneavoastră de Linux conține pachete foarte vechi; așa că dacă nu aveți ultima apariție a distribuției sau folosiți backports, instalarea din surse poate fi cea mai sigură alegere.

Pentru a instala Git, aveți nevoie de următoarele biblioteci de care Git depinde: curl, zlib, openssl, expat, și libiconv. De exemplu, dacă sunteți într-un sistem care folosește yum (cum ar fi Fedora) sau apt-get (cum ar fi un sistem bazat pe Debian), puteți să folosiți una din aceste comenzi pentru a instala toate dependințele:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

Când aveți toate dependințele cerute, puteți să treceți la pasul următor și să luați ultimul snapshot de pe site-ul Git:

	http://git-scm.com/download

Apoi, compilați și instalați:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

După toți acești pași, puteți să luați Git prin intermediul lui însăși folosind update-uri:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Instalarea în sistemele Linux ###

Dacă doriți să instalați Git în Linux prin intermediul unui program de instalare, puteți de obicei să folosiți uneltele locale pentru administrarea pachetelor în funcție de distribuția utilizată. Dacă folosiți Fedora, puteți folosi yum:

	$ yum install git-core

Sau dacă folosiți o distribuție bazată pe Debian, de exemplu Ubuntu, încercați apt-get:

	$ apt-get install git

### Instalarea pe sistemele Mac ###

Sunt două moduri simple de a instala Git pe sistemele Mac. Cea mai simplă este să folosiți programul de instalare grafic pentru Git, pe care îl puteți descărca de la pagina SourceForge ( vedeți Figura 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png 
Figura 1-7. Programul de instalare Git în OS X.

Cealaltă posibilitate este să instalați Git prin intermediul MacPorts (`http://www.macports.org`). Dacă aveți instalat MacPorts, atunci instalați Git cu comanda

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Nu trebuie să adăugați toate extra-opțiunile, dar probabil veți dori să includeți +svn în caz că veți dori să folosiți Git cu repository-uri Subversion (vedeți Capitolul 8).

### Instalarea pe sistemele Windows ###

Instalarea Git în Windows este foarte simplă. Proiectul msysGit are una din procedurile cele mai simple de instalare. Pur și simplu descărcați programul de instalare de pe pagina GitHub, și rulați-l:

	http://msysgit.github.com/

După ce este instalat, veți avea atât o versiune în linie de comandă (inclusiv un client SSH care vă va fi util mai târziu) cât și o interfață grafică standard (GUI [en]).

## Stările Git Pentru Prima Rulare ##

Acum că aveți Git instalat pe sistemul dumneavoastră, veți dori să faceți câteva schimbări în mediul dumneavoastră Git. Ar trebui să faceți aceste lucruri o singură dată; ele se vor păstra între diverse actualizări. Puteți de asemenea să le schimbați în orice moment rulând din nou comenzile.

Git vine cu un utilitar denumit git config care vă permite să setați variabile de configurare care controlează toate aspectele legate de funcționarea Git și interfața sa. Aceste variabile pot fi păstrate în diverse locuri:

*	fișierul `/etc/gitconfig`: Conține valuroi pentru fiecare utilizator al unui sistem și pentru toate repository-urile sale. Dacă introduceți opțiunea ` --system` pentru `git config`, va citi și scrie din fișierul menționat anterior. 
*	fișierul `~/.gitconfig`: Specific utilizatorului dumneavoastră. Puteți de asemenea să instruiți Git să citească și să scrie în acest fișier dacă introduceți opțiunea `--global`. 
*	fișierul de configurare pentru configurația git (adică, `.git/config`) sau specific repository-ului curent: Specific doar pentru acel repository. Fiecare nivel suprascrie valorile din celălalt nivel, deci valorile din `.git/config` le suprascriu pe cele din `/etc/gitconfig`.

În sistemele Windows, Git caută fișierul `.gitconfig` din directorul `$HOME` (`C:\Documents and Settings\$USER` (utilizator [ro])). De asemenea se va uita în /etc/gitconfig, chiar dacă este relativ la rădăcin MSys, care este dată de locul unde v-ați decis să instalați Git pe sistemul dumneavoastră Windows la instalare.

### Identitatea Dumneavoastră ###

Primul lucru care ar trebui să îl faceți atunci când instalați Git este să vă stabiliți numele și adresa de email. Acest aspect este important deoarece fiecare commit în Git va folosi aceste informații, și acestea vor fi conținute în commit-urile care le veți distribui:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Din nou, va fi necesar să efectuați acești pași o singură dată dacă introduceți opțiunea `--global`, deoarece atunci Git va folosi întotdeauna aceste informații pentru toate operațiile efectuate pe acel sistem. Dacă doriți să suprascrieți aceste informații cu un nume sau email diferite pentru anumite proiecte, atunci puteți executa comanda fără opțiunea `--global` atunci când vă aflați în acel proiect.

### Editorul Dumneavoastră ###

Acum că v-ați setat identitatea, puteți configura editorul de text ce va fi folosit implicit atunci când Git are nevoie să introduceți mesaje. Implicit, Git va folosi editorul definit în sistem, cel mai des acesta va fi Vi sau Vim. Dacă doriți să folosiți un editor text diferit, cum ar fi Emacs, puteți să faceți următoarele:

	$ git config --global core.editor emacs
	
### Utilitatorul Pentru Diferențe ###

O altă configurare utilă pe care o puteți face este utilitarul folosit în aflarea diferențelor (diff [en]) folosit pentru rezolvarea conflictelor. Să presupunem că doriți să folosiți vimdiff:

	$ git config --global merge.tool vimdiff

Git acceptă ca și unelte valide pentru diferențe următoarele: kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, și opendiff. Puteți de asemenea să configurați un utlitar personalizat; vedeți Capitolul 7 pentru mai multe informații despre această procedură.

### Verificarea Setărilor ###

Dacă doriți să vă verificați setările, puteți folosi comanda `git config --list` pentru a afișa toate setările pe care Git le poate utiliza în prezent:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Puteți vedea și mai multe chei de mai multe ori, deoarece Git citește aceeași cheie din fișiere diferite (`/etc/gitconfig` și `~/.gitconfig`, de exemplu). În acest caz, Git folosește ultima valoare pentru fiecare cheie unică întâlnită.

Puteți de asemenea să vedeți ceea ce Git crede despre valoarea unei anumite chei dacă scrieți `git config {cheie}`:

	$ git config user.name
	Scott Chacon

## Cum să Obțineți Ajutor ##

Dacă veți avea vreodată nevoie de ajutor pentru a folosi Git, sunt trei modalități pentru a ajunge la pagina din manual sau manpage pentru ajutor cu oricare din comenzile Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

De exemplu, puteți ajunge la pagina din manual pentru comanda config dacă rulați

	$ git help config

Aceste comande sunt utile pentru că le puteți accesa de oriunde, chiar și când nu sunteți conectat la rețea.
Dacă paginile din manual și această carte nu vă sunt suficiente și aveți nevoie de ajutor personal, puteți încerca canalele `#git` sau `#github` de pe serverul de IRC Freenode (irc.freenode.net). Aceste canale sunt în mod obișnuit pline cu sute de oameni care sunt versați în folosirea Git și sunt de obicei dispuși să vă ofere ajutorul.

## Sumar ##

Ar trebui să dețineți o înțelegere de bază a ceea ce este Git și cum este el diferit de CVCS pe care le utilizați în curent. De asemenea ar trebui să aveți o versiune funcțională a Git pe sistemul dumneavoastră care este configurată cu identitatea dumneavoastră. Acum a venit timpul să învățăm bazele Git.
