# Како да започнам #

Ова поглавје се однесува на тоа како да започнете со Git.  На почетокот ќе започнеме со објаснување на позадината на алатките за контрола на верзии, понатаму ќе продолжиме со тоа како да го покренете Git на вашиот систем и конечно како да го подесите и да работите со него.  На крајот од ова поглавје ќе разберете зошто е направен Git, зошто треба да го користите и што се треба да направите за да го користите.

## За контрола на верзиите ##

Што е контрола на верзии, и зошто би требало да се грижите? Контрола на верзии е систем кој што ги бележи промените во една датотека или во група од датотеки со текот на времето така што подоцна би можеле да се вратите на одредена верзија. За примерите во оваа книга ќе користите изворен код од софтвер како датотеки кои што ќе бидат верзионирани, инаку истото можете да го правите со било каков тип на датотеки.

Ако си графички дизајнер и сакаш да ја сочуваш секоја верзија од сликата или нацртот (секако дека би сакал), тогаш користење на Систем за Контрола на Верзии (VCS од англиски Version Control System) е разумен начин да се постигне тоа. Тој ви овозможува одредени датотеки да ги вратите во претходна состојба, целиот проект да го вратите во претходна состојба, да ги споредите измените кои што се направени во одреден временски период, да видите кој последен менувал и дали тоа предизвикало некој проблем, кој и кога вовел неправилност итн. Користење на VCS генерално значи дури и да уништите или изгубите датотеки, секогаш може лесно да ги вратите назад. Дополнително, сето тоа го добивате за сосема мал напор.

### Локални системи за контрола на верзии ###

Многу луѓе како систем за верзионирање го користат методот на копирање на датотеките во друга папка (можеби папка со датум во името). Овој пристап е многу вообичаен затоа што е едноставен, но неверојатно многу е склон на грешки. Многу е лесно да заборавите во која папка се наоѓате моментално, и по грешка да запишете или да пребришете датотека.

За да се справат со овој проблем, програмерите одамна развиле локални VCS-и кои што имале едноставна база во која што се бележеле сите промени во датотеките кои што биле ставен под системот за контрола на верзиите (види Сл 1-1).

Insert 18333fig0101.png 
Слика 1-1. Дијаграм на локален систем за контрола на верзиите.

Еден од попопуларните VCS алатки бил системот наречен rcs, кој што и денеска сеуште се користи. Дури и популарниот Mac OS X оперативен систем ја вклучува наредбата rcs кога ќе инсталирате развојни алатки. Оваа алатка работи на тој начин што чува серија од закрпи (разлики помеѓу датотеките) од една до друга промена во специјален формат на дискот; понатаму на тој начин може да ја добие секоја состојба што ја имала датотеката во одредено време со додавање на закрпите.

### Централизирани системи за контрола на верзиите ###

Следен голем проблем со кој што се судриле луѓето е неможноста да колаборираат со програмерите на други системи. За да се разреши овој проблем биле развиени Централизирани Системи за Контрола на Верзиите (CVCSs - Centralized Version Control Systems). Овие системи, како што се CVS, Subversion, и Perforce, имаат централен сервер кој што ги содржи сите верзионирани датотеки, и голем број на клиенти кои што ги менуваат или прегледуваат датотеките од тоа централно место. Многу години тоа беше стандард за контрола на верзиите (види Слика 1-2).

Insert 18333fig0102.png 
Слика 1-2. Дијаграм на централизиран систем за контрола на верзиите.

Ваквата поставка нуди многу предности, особено во однос на локалните VCS-и. На пример, секој во одредена мерка знае што работат другите на проектот. Администраторите фино може да подесат кој што може да работи, и далеку е поедноставно да се администрира CVCS отколку да се администрираат базите на секој клиент.

Но, ваквата поставка исто така има и сериозни недостатоци. >>>The most obvious is the single point of failure that the centralized server represents.<<< Ако тој сервер биде исклучен еден час на пример, во тој час никој воопшто нема да може да колаборира, ниту пак да ги зачува верзионираните промени на она на што работи. Доколку хард-дискот се корумпира, и доколку не постои соодветен бекап, тогаш апсолутно се е загубено - целосниот историјат на проектот, освен копиите кои што луѓето случајно би ги имале на локалните компјутери. Локалните VCS системи се подложни на истите проблеми - доколку целосната историја на проектот е на едно место, тогаш ризикувате да загубите се.

### Дистрибуирани системи за контрола на верзиите ###

Тука стапуваат на сцена Дистрибуираните Системи за Контрола на Верзиите (DVCSs - Distributed Version Control Systems). Кај DVCS (како што е Git, Mercurial, Bazaar или Darcs), клиентите не ја прегледуваат само последната состојба од датотеките туку прават целосна копија од репозиторито. Така, доколку некој од серверите биде уништен, било која копија од клиентите може да биде земена за да се реставрира серверот. Секое прегледување е целосен бекап на сите податоци (види Слика 1-3).

Insert 18333fig0103.png 
Слика 1-3. Дијаграм на дистрибуирани системи за контрола на верзиите.

Дополнително, многу од овие системи одлично се снаоѓаат при работа со повеќе оддалечени репозиторија, така што можете да колаборирате со различни групи луѓе на различни начини истовремено во рамките на ист проект. Тоа ви овозможува да поставите повеке типови на начини на работа кои што не се возможни во централизираните системи, како што се хиерархискиот модели.

## Кратка историја на Git ##

Како и со многу големи работи во животот, Git настана со мала креативна деструкција и жестока расправија. Линукс кернелот е проект со отворен код и сосема широк делокруг. Одржувањето за поголемиот дел од животниот век на Линукс кернелот (1991-2002) се одвивалот на тој начин што измените во софтверот се предавале како закрпи и архиви. Во 2002 Линукс кернел проектот почнал да користи лиценциран DVCS систем наречен BitKeeper.

Во 2005, врската помеѓу заедницата која што го развиваше Линукс кернелот и компанијата која што го разви BitKeeper се распадна, и алатката повеќе не можеше да се користи бесплатно. Тоа и наложи на Линукс развојната заедница (а посебно на Линус Торвалдс, авторот на Линукс) да развијат сопствена алатка базирана на некои лекции кои што ги научија додека го користеа BitKeeper. Некои од целите на новиот систем беа:

*	Брзина
*	Едноставен дизајн
*	Силна подршка за не-линеарен начин на развој (илјадници паралелни гранки на развој)
*	Целосно дистрибуиран
*	Ефикасно да може да подржи големи проекти како Линукс кернелот (брзина и количина на податоци)

Од неговото раѓање во 2005, Git еволуираше во систем кој што е лесен за користење и сеуште ги задржува иницијалните цели. Тој е извонредно брз, многу ефикасен со големи проекти, и има извонреден систем за гранање за не-линеарен начин на развој (Види поглавје 3).

## Основи на Git ##

Во неколку збора, што е Git? Оваа секција е многу битно да ја разберете, бидејќи ако разберете што е Git и основите како работи, тогаш ефикасното користење на Git веројатно ќе биде многу едноставно за вас. Додека учите за Git, пробајте да ги изолирате работите што евентуално ги знаете за другите VCS, како што е Subversion и Perforce; на тој начин ќе ја избегнете забуната при користењето на алатката. Git ги складира и обработува информациите многу поразлично од другите системи, иако корисничкиот интерфејс е прилично сличен; доколку ги разберете тие разлики ќе ги избегнете забуните при неговото користење.

### Целосни слики, наместо закрпи ###

Најголемата разлика помеѓу Git и било кој друг VCS (Subversion и сл.) е во начинот на кој Git ги обработува податоците. Концептуално, повеќето други системи информациите ги складираат како листа од промени над поединечните датотеки. Тие системи (CVS, Subversion, Perforce, Bazaar итн) информациите ги чуваат како множества од датотеки и промените настанати над тие датотеки со текот на времето, како што е прикажано на Слика 1-4.

Insert 18333fig0104.png 
Слика 1-4. Другите системи чуваат закрпи за секоја датотека.

Git не ги третира или чува податоците на тој начин. Наместо тоа, Git податоците ги третира како множества од целосни слики/копии од мини фајлсистем. Секогаш кога сакате да ја зачувате состојбата во која се наоѓа проектот во Git, тој едноставно прави слика од тоа како изгледаат сите датотеки во тој момент и зачувува референца до таа слика. За да биде ефикасен, доколку датотеките не се променети, Git не прави копија од датотеките туку само прави линк до претходно зачуваната идентична датотека. Git ги третира податоците како што е прикажано на сликата 1-5.

Insert 18333fig0105.png 
Слика 1-5. Git ги зачувува податоците како целосни копии од проектот.

Ова е битна разлика помеѓу Git и речиси сите други VCS. Со тоа Git ги преиспитува речиси сите аспекти од системите за контрола на верзиите, за разлика од другите системи кои што едноставно ги копирале од претходните генерации. Тоа го прави Git да личи помалку на мини фајлсистем со извонредно моќни алатки над него, отколку како едноставен VCS. Ќе ги истражиме придобивките од таквото третирање на податоците при обработка на гранањето во Git во Поглавје 3.

### Nearly Every Operation Is Local ###

Most operations in Git only need local files and resources to operate – generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.

This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.

### Git Has Integrity ###

Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.

The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory.

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
	  libz-dev
	
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
