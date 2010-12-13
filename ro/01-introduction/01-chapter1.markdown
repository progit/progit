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

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

The basic Git workflow goes something like this:

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
