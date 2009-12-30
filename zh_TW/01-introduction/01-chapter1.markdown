# 開始 #


本章介紹Git的相關知識。 先從講解一些版本控制工具的背景知識開始，然後試著在讀者的系統將Git跑起來，最後則是設定它。 本在章結束，讀者應瞭解為什麼Git如 此流行、為什麼讀者應該利用它、以及完成使用它的準備工作。

## 關於版本控制 ##


什麼是版本控制？ 以及為什麼讀者會在意它？ 版本控制是一個能夠記錄一個或一組檔案在某一段時間的變更，使得讀者以後能取回特定版本的系統。 在本書的範例中，讀者會學到如何對軟體的原始碼做版本控制。 即使實際上讀者幾乎可以針對電腦上任意型態的檔案做版本控制。


若讀者是繪圖或網頁設計師且想要記錄每一版影像或版面配置（這也通常是讀者想要做的），採用版本控制系統（VCS）做這件事是非常明智的。 它允許讀者將檔案復原到原本的狀態、將整個專案復原到先前的狀態、比對某一段時間的修改、查看最後是誰在哪個時間點做了錯誤的修改導致問題發生，等。 使用版本控制系統一般也意謂著若讀者做了一些傻事、或者遺失檔案，讀者能很容易的回復。 更進一步，僅需付出很小的代價即可得到這些優點。

### 本地端版本控制 ###


許多讀者採用複製檔案到其它目錄的方式來做版本控制（若他們夠聰明的話，或許會是有記錄時間戳記的目錄）。 因為它很簡單，這是個很常見的方法；但它也很容易出錯。 讀者很容易就忘記在哪個目錄，並不小心的把錯誤的檔案寫入、或者複製到不想要的檔案。


為了解決這問題，設式設計師在很久以前開發了本地端的版本控制系統，具備簡單的資料庫，用來記載檔案的所有變更記錄（參考圖1-1）。

Insert 18333fig0101.png 
圖1－1。 本地端版本控制流程圖。


這種版本控制工具中最流行的是RCS，目前仍存在於許多電腦。 即使是流行的Mac OS X作業系統，都會在讀者安裝開發工具時安裝rcs命令。 此工具基本上以特殊的格式記錄修補集合（即檔案從一個版本變更到另一個版本所需資訊），並儲存於磁碟上。 它就可以藉由套用各修補集合産生各時間點的檔案內容。

### 集中式版本控制系統 ###


接下來人們遇到的主要問題是需要多位其它系統的開發協同作業。 為了解決此問題，集中式版本控制系統被發展出來。 此系統，如：CVS、Subversion及Perforce皆具備單一伺服器，記錄所有版本的檔案，且有多個客戶端從伺服器從伺服器取出檔案。 在多年後，這已經是版本控制系統的標準（參考圖1－2）。

Insert 18333fig0102.png 
圖1－2. 集中式版本控制系統

這樣的配置提供了很多優點，特別是相較於本地端的版本控制系統來說。 例如：每個人皆能得知其它人對此專案做了些什麼修改有一定程度的瞭解。 管理員可調整存取權限，限制各使用者能做的事。 而且維護集中式版本控制系統也比維護散落在各使用者端的資料庫來的容易。

然而，這樣的配置也有嚴重的缺點。 最明顯的就是無法連上伺服器時。 如果伺服器關閉一個小時，在這段時間中沒有人能進行協同開發的工作或者將變更的部份傳遞給其它使用者。 如果伺服器用來儲存資料庫的硬碟損毀，而且沒有相關的偏份資料。 除了使用者已取到自己的電腦的版本外，所有資訊，包含該專案開發的歷史都會遺失。 本地端版本控制系統也會有同樣的問題，只要使用者將整個專案的開發歷史都放在同一個地方，就有遺失所有資料的風險。

### 分散式版本控制系統 ###

這就是分散式版本控制系統被引入的原因。 在分散式版本控制系統，諸如：Git、Mercurial、Bazaar、Darcs。 客戶端不只是取出最後一版的檔案，而是複製整個儲存庫。 即使是整個系統賴以運作的電腦損毀，皆可將任何一個客戶端先前複製的資料還原到伺服器。 每一次的取出動作實際上就是完整備份整個儲存庫。（參考圖1-3）

Insert 18333fig0103.png 
圖1-3. 分散式版本控制系統

Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.
更進一步來說，許多這樣子的系統皆能同時與數個遠端的機器同時運作。 因此讀者能同時與許多不同群組的人們協同開發同一個專案。 這允許讀者設定多種集中式系統做不到的工作流程，如：階層式模式。

## Git 的簡史 ##

如同許多生命中美好的事物一樣，Git從有一點創意的破壞及激烈的討論中誕生。 Linux kernel 是開放原始碼中相當大的專案。 在 Linux kernel 大部份的維護時間內（1991～2002），修改該軟體的方式通常以多個修補檔及壓縮檔流通。 在2002年，Linux kernel 開始採用名為 BitKeeper 的商業分散式版本控制系統。

在 2005年，開發 Linux kernel 的社群與開發 BitKeeper 的商業公司的關係走向決裂，也無法再免費使用該工具。 這告訴了 Linux 社群及 Linux 之父 Linux Torvalds，該是基於使用 BitKeeper 得到的經驗，開發自有的工具的時候。 這個系統必須達成下列目標：

*	快速
*	簡潔的設計
*	完整支援非線性的開發（上千個同時進行的分支）
*	完全的分散式系統
*	能夠有效的處理像 Linux kernel 規模的專案（快速及資料大小）

自從 2005 年誕生後，Git已相當成熟，也能很容易使手，並保持著最一開始的要求的品質。 它不可思議的快速、處理大型專案非常有效率、也具備相當優秀足以應付非線性開發的分支系統。（參考第三章）

## Git 基礎要點 ##

那麼，簡單的說，Git是一個什麼樣的系統？ 這一章節是非常的重要的。 若讀者瞭解什麼是Git以及它的基本工作原因，那麼使用垉來就會很輕鬆且有效率。 在學習之前，試著忘記以前所知道的其它版本控制系統，如：Subversion 及 Perforce。 這將會幫助讀者使用此工具時發生不必要的誤會。 Git儲存資料及運作它們的方式遠異於其它系統，即使它們的使用者介面是很相似的。 瞭解這些差異會幫助讀者更準確的使用此工具。

### Snapshots, Not Differences ###

The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4.

Insert 18333fig0104.png 
Figure 1-4. Other systems tend to store data as changes to a base version of each file.

Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. 

Insert 18333fig0105.png 
Figure 1-5. Git stores data as snapshots of the project over time.

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

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
