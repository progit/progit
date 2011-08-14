# Першыя крокі #

Гэтая глава прысвечана пачатку працы з Git. Мы пачнем з тлумачэння асноў працы прылад кантролю версій, затым пяройдзем да таго як атрымаць працуючы Git ў сваёй сістэмы і, урэшце, як наладзіць яго так, каб з ім можна было пачаць працаваць. Напрыканцы гэтай главы вы будзеце мець разуменне для чаго наогул прызначаны Git, чаму ім варта карыстацца і мець усе неабходныя наладкі дзеля гэтага.

## Пра кантроль версій ##

Што такое кантроль версій і навошта ён патрэбны? Кантроль версій — гэта сістэма, якая запісвае змены, што адбыліся з файлам ці наборам файлаў з цягам часу, так што вы можаце вярнуцца да розных версій пазней. У прыкладах гэтай кнігі мы будзем працаваць з зыходнікамі праграмнага забеспечэння ў якасці файлаў, версіі якіх будуць кантралявацца, але, насамрэч, вы можаце выкарыстоўваць гэтую магчымасць практычна з любым тыпам файла, які існуе на вашым кампутары.

Калі вы графічны ці web дызайнер і маеце намер захоўваць кожную версію малюнкаў ці слаёў (што вам больш патрэбна), то выкарыстанне сістэмы кантролю версій (СКВ; Version Control System, VCS) гэта вельмі разумны выбар. Гэта дазволіць вам вярнуць файлы да папярэдняга стану, вярнуць весь праект да папярэдняга стану, параўнаць змены паміж рознымі станамі, убачыць хто апошнім змяняў нешта, што можа выклікаць праблемы, хто прапанаваў змену і калі, і шмат іншага. Выкарыстанне СКВ у асноўным значыць, што калі вы сапсавалі нешта ці страцілі файлы, то гэта можна лёгка ўзнавіць. Як дадатак, гэта не запатрабуе вялікіх намаганняў і выдаткаў з вашага боку.  

### Лакальныя сістэмы кантролю версій ###

Шмат людзей ў якасці метаду кантролю версій выбірае капіяванне файлаў у іншую тэчку (магчыма, з датай у назве, калі чалавек досыць разумны). Гэты падыход вельмі распаўсюджаны з-за сваёй прастаты, але ён пакідае неверагодна шмат магчымасцяў для памылак. Вельмі лёгка забыцца ў якой тэчцы вы зараз і выпадкова запісаць не ў той файл, ці зкапіяваць зусім не туды, куды вы збіраліся.

Каб развязаць гэтую праблему праграмісты шмат часу таму распрацавлі лакальныя СКВ, якія выкарыстоўваюць простую базу дадзеных каб захоўваць ўсе змены ў файлах, версіі якіх адсочваюцца (гл. Малюнак 1-1).

Insert 18333fig0101.png 
Малюнак 1-1. Схема лакальнага кантролю версій.

Адной з папулярных у той час СКВ была rcs, якая ўсё яшчэ пастаўляецца з вялікай колькасцю кампутараў. Нават папулярная аперацыйная сістэма Mac OS X усталёўвае rcs у складзе пакета Developer Tools. Праца гэтай прылады заснаваная на захаванні на дыску ў спецыяльным фармаце набораў латак (patch) (гэта запісы розніцы паміж дзвума файламі) для кожнай змены файла. Гэта дапамагае вярнуць файл да любога з зафіксаваных станаў, паслядоўна накладыючы латкі адну за адной.

### Цэнтралізаваныя сістэмы кантролю версій ###

Наступнай сур'ёзнай праблемай, з якой людзі сутыкнуліся была неабходнасць супрацоўнічаць з распрацоўшчыкамі за іншымі кампутарамі. Централізаваныя сістэмы кантролю версій (ЦСКВ) былі распрацаваныя каб развязаць гэтую праблему. Такія сістэмы як CVS, Subversion і Perforce складаюцца з сервера, на якім захоўваюцца ўсе дадзеныя па версіях файлаў, і некаторай колькасці кліенцкіх машын, якія атрымліваюць файлы з сервера. Шмат год такая схема з'яўлялася стандартам кантролю версій (гл. Малюнак 1-2).

Insert 18333fig0102.png 
Малюнак 1-2. Схема цэнтралізаванага кантролю версій.

Гэты падыход мае шмат пераваг, асабліва ў параўнанні з лакальнымі СКВ. Напрыклад, усе дакладна ведаюць што асатнія робяць і што наогул адбываецца ў праекце. Адміністратары маюць зручную магчымасць кантролю за тым хто што можа зрабіць. І гэта значна прасцей, чым адміністраванне лакальных баз дадзеных СКВ на кожнай кліенцкай машыне.

Аднак, гэты падыход мае і некаторыя сур'ёзныя мінусы. Самы відавочны з іх — центральны сервер яўляе сабою пункт, крах якога цягне за сабою крах усёй сістэмы. Калі гэты сервер спыніць працу на гадзіну — у гэтую гадзіну ніхто не зможа абмяняцца з супрацоўнікамі вынікамі сваёй працы ці захаваць новую версію таго, над чым ён ці яна зараз працуе. Калі жосткі дыск, на якім змешчаная цэнтральная база дадзеных пашкоджаны, а актуальных рэзервовых копій няма, то вы згубіце абсалютна ўсё: усё гісторыю праекту, за выключэннем тых здымкаў, што карыстальнікі выпадкова мелі на сваіх лакальных кампутарах. Лакальныя СКВ пакутуюць на тую ж праблему: калі ты маеш усю гісторыю пракета толькі ў адным месцы, то ты рызыкуеш згубіць усё.

### Размеркаваныя сістэмы кантролю версій ###

І вось тут у гульню ўступаюць размеркаваныя сістэмы кантролю версій (РСКВ). У РСКВ (такіх як Git, Mercurial, Bazaar ці Darcs) кліенты не толькі атрымліваюць апошнія здымкі файлаў: яны атрымліваюць поўную копію сховішча. Такім чынам, калі любы з сервераў праз які ідзе абмен вынікамі працы памрэ, то любое з кліенцкіх сховішчаў можа быць зкапіявана на сервер каб аднавіць усю інфармацыю. Кожнае сховішча на кожным з працоўных месцаў насамрэч поўная рэзервовая копія ўсіх дадзеных (гл. Малюнак 1-3).

Insert 18333fig0103.png 
Малюнак 1-3. Схема размеркаванага кантролю версій.

Апроч таго, шмат якія з гэтых сістэм выдатна працуюць з некалькімі аддаленымі сховішчамі, так што вы можаце адначасова па-рознаму узаемадзейнічаць з некалькімі рознымі групамі людзей у межах аднаго праекта. Гэта дазваляе наладжваць розные тыпы паслядоўнасцяў дзеянняў, што немагчыма з цэнтралізаванымі сістэмамі, такімі як іерархічныя мадэлі.

## Кароткая гісторыя Git ##

Як і шмат іншых вялікіх рэчаў у жыцці, Git пачынаўся з стваральнага разбурэння і палымяных спрэчак. Ядро Linux — праграмны праект з адкрытымі зыходнікамі даволі вялікага аб'ёму. На пряцягу большай часткі перыяду існавання ядра Linux змены ў ім распаўсюджваліся у выглядзе патчаў і архіваваных файлаў. У 2002 годзе праект распрацоўкі ядра Linux пачаў карыстацца BitKeeper — прапрыетарнай РСКВ

У 2005 годзе адносіны паміж суполкай распрацоўшчыкаў ядра Linux і камерцыйнай кампаніяй, што распрацоўвала BitKeeper сапсаваліся і бясплатна карыстацца гэтай утылітай стала немагчыма. Гэта запатрабавала ад суполкі распрацоўшчыкаў Linux (і, ў прыватнасці, Лінуса Торвальдса (Linus Torvalds), стваральніка Linux'а) стварыць іх уласную сістэму, заснаваную на некаторых з урокаў, якія яны вынеслі для сябе з досведу карыстання BitKeeper. Некаторыя з мэтаў новай сітэмы ніжэй:

*	Хуткасць
*	Просты дызайн
*	Моцная падтрымка нелінейнай распрацоўкі (сотні паралельных галін)
*	Цалкам размеркаваная
*	Магчымасць эфектыўна працаваць з вялікімі праектамі, кшталту ядра Linux (хуткасць і памер дадзеных)

З часу свайго з'яўлення ў 2005 годзе Git развіваўся і сталеў каб быць лёгкім у выкарыстанні і пры гэтым захоўваць гэтыя першапачатковыя якасці. Ён неверагодна хуткі, вельмі эфектыўны ў працы з вялікімі праектамі і мае неверагодную сістэму кіравання галінамі для нелінейных праектаў (гл. главу 3).

## Асновы Git ##

Такім чынам, што ж такое Git, калі ў двух словах? Гета вельмі важны для засваення раздзел, таму што калі вы зразумееце што такое Git і фундаментальныя асновы таго як ён працуе, то  эфектыўнае выкарыстанне Git можа стаць значна больш простым для вас. Пад час вывучэння Git пастарайцеся не абапірацца на ўспаміны пра іншыя СКВ, кшталту Subversion і Perforce, гэта дапаможа пазбегнуць памылак і разгубленасці пад час выкарыстання гэтай прылады. Git захоўвае інфармацыю і успрымае яе вельмі непадобна на іншыя сістэмы, нават не гледзячы на даволі блізкае падабенства карыстальніцкага інтэрфейсу. Разуменне гэтых адрозненняў дапаможа прадухіліць памылкі і разгубленасць пад час работы з Git.

### Здымкі, а не адрозненні ###

Асноўнае адрозненне Git ад любой іншай СКВ (уключаючы Subversion і кампанію) — тое як Git ўяўляе сабе дадзеныя, якіе захоўвае. Канцэптуальна, большасць іншых сістэмы захоўвае інфармацыю ў выглядзе набор змяненнеў. Гэтыя сістэмы (CVS, Subversion, Perforce, Bazaar і гэтай далей) ставяцца да інфармацыі, якую яны захозваюць, як да набора адрозненняў для кожнага з файлаў у параўнанні з папярэднім станам, як гэта паказана на Малюнку 1-4.

Insert 18333fig0104.png 
Малюнак 1-4. Іншыя сістэмы звычайна захоўваюць дадзеныя ў выглядзе набора зменаў для базавай версіі кожнага файла.

Git ўспрымае данныя ў сховішчы інакш. Замест таго, каб успрымаць іх як наборы зменаў, Git ставіцца да дадзеных хутчэй як да набора здымкаў стану невялікай файлавай стэмы. Кожны раз, калі вы захоўваеце дадзеныя вашага праекду ў Git, ён па-сутнасці, робіць здымак таго, як вашыя файлы выглядаюць ў гэты момант і спасылку на гэты здымак. Для павышэння эфектыўнасці, калі файл не змяняўся, то Git не захоўвае яго яшчэ раз, а проста робіць спасылку на яго папярэдні стан, які ўжо быў захаваны. Гіт успрымае дадзеныя больш падобна на тое, што паказана на Малюнку 1-5.

Insert 18333fig0105.png 
Малюнак 1-5. Git захоўвае дадзеныя як здымкі стану праекта пэўнага часу.

Гэта вельмі сур'ёзна адрознівае Git ад практычна ўсіх іншых СКВ. Гэта вымушае Git пераглядзець амаль усе аспекты кіравання версіямі, які большасць іншых сістэм узялі з сістэм папярэдняга пакалення. Гэта робіць Git больш падобным на невялікую файлавую сістэму з неверагодна магутнымі інструмантамі, створанымі каб працаваць павер яе, чымсці на звычайную СКВ. Некаторыя з пераваг, які дае такі падыход да захоўвання дадзеных, мы разгледзім ў Раздзеле 3, пад час вывучэння працы з галінамі.

### Практычна ўсе аперацыі выконваюцца лакальна ###

Большасць аперацый у Git патрабуюць для працы толькі лакальныя файлы і рэсурсы, бо звычайна інфармацыя з іншых кампутараў у сетцы не патрэбныя. Калі вы карысталіся ЦСКВ, дзе большасць аперацый маюць дадатковыя затрымкі, звязаныя з працай праз сець, то гэты аспект Git прымусіць думаць, што богі хуткасці блаславілі гэтую сістэмы неверагоднымі здольнасцямі. Большасць аперацыі выглядае практычна імгненнымі, паколькі ўся гісторыя праекта захоўваецца непасрэдна на вашым лакальным дыску.

Напрыклад, каб паглядзець гісторыю праекта Git не трэба звяртацца да сервера, каб атрымаць гісторыю і адлюстраваць яе для вас — можна проста прачытаць яе непасрэдна з вашай лакальнай базы дадзеных. Гэта значыць, што вы убачыце гісторыю праекта практычна імгненна. Калі вы захацелі ўбачыць розніцу паміж бягучай версіяй файла і той, што была месяц таму, Git можа праглядзець файл месячнай даўніны і вылічыць розніцу паміж версіямі лакальна, замест таго капрасіць у сервера зрабіць гэта, альбо выцягваць старую версію з сервера і потым зноўку ж вылічваць розніцу лакальна.

Да таго ж, гэта значыць што вельмі няшмат чаго нельга зрабіць калі вы па-за сеткай ці VPN. Калі вы ў самалёце ці ў цягніку і хочаце крыху папрацаваць, то вы можаце захоўваць праект ў СКВ (ці рабіць каміты, як яшчэ кажуць) без аніякіх праблем і перашкод ажно пакуль не з'явіцца сетка, з дапамогай якой вы зможаць выгрузіць змены. Калі вы прыйшлі дадому не і здолелі наладзіць VPN, вы ўсё яшчэ ў стане працаваць. У многіх іншых сістэмах вельмі цяжка, калі наогул магчыма рабіць так. У Perforce, напрыклад, вы няшмат што можаць зрабіць, калі няма сувязі з серверам, а ў Subversion і CVS вы можаце рэдактаваць файлы, але не будзеце ў стане захаваць змены ў сваю базу дадзеных (паколькі сувязі з базай дадзеных няма). Можа гэта і не выглядае вялікім дасягненнем, але вы будзеце здзіўленыя, убачыўшы наколькі гэта можа змяніць справу.

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
