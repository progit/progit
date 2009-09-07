# 使い始める #

この章は、Gitを使い始めることに関してになります。はじめにバージョン管理システムの幾つかの背景を、その後にどうやってGitをあなたのシステムで稼動させるかに移り、最後にどうやってGitで作業を始めるために設定するかについて説明することからはじめます。この章の終りでは、なぜGitが広まっているか、なぜGitを使うべきなのか、それをするための準備が全て整っているだろうということを、あなたはきっと理解できることでしょう。

## バージョン管理に関して ##

バージョン管理とは何か、また、なぜそれを気にする必要があるのか？
バージョン管理とは、変更を一つのファイル、もしくは時間を通じたファイルの集合に記録するシステムで、そのため後で特定バージョンを呼び出すことができます。現実にはコンピューター上のほとんどあらゆるファイルのタイプでバージョン管理を行なう事ができますが、本書の中の例では、バージョン管理されるファイルとして、ソフトウェアのソースコードを利用します。

もしあなたが、グラフィックス・デザイナー、もしくはウェブ・デザイナーであって、（あなたが最も確実に望んでいるであろう）画像もしくはレイアウトの全てのバージョンを管理したいのであれば、バージョン管理システム（VCS）はとても賢く利用できるものです。それは、ファイルを以前の状態まで戻し、プロジェクト丸ごとを以前の状態に戻し、時間を通じた変化を比較し、誰が最後に問題を引き起こすだろう何かを修正したか、誰が課題を導入したか、何時、それ以上を可能にします。VCSを使うということはまた、一般的に、何かをもみくちゃにするか、ファイルを失うとしても、簡単に復活させることができることを意味します。加えて、とても僅かな諸経費で、それら全てを得ることができます。

### ローカル・バージョン管理システム ###

多くの人々の選り抜きのバージョン管理手法は、他のディレクトリー（もし彼らが賢いのであれば、恐らく日時が書かれたディレクトリー）にファイルをコピーするというものです。このアプローチは、とても単純なためにすごく一般的ですが、信じられない間違い傾向もあります。どのディレクトリーにいるのか忘れやすいですし、偶然に間違ったファイルに書き込んだり、意図しないファイルに上書きしたりします。

この問題を扱うため、大昔にプログラマーは、バージョン管理下で全ての変更をファイルに保持するシンプルなデータベースを持つ、ローカルなバージョン管理システムを開発しました（図1-1参照）。

Insert 18333fig0101.png 
図1-1. ローカル・バージョン管理図解

もっとも有名なVCSツールの一つが、RCSと呼ばれるシステムでした。今日でも以前として多くのコンピューターに入っています。人気のMac OS Xオペレーティング・システムさえも、開発者ツールをインストールしたときは、rcsコマンドを含みます。このツールは基本的に、ディスク上に特殊フォーマットで、一つの変更からもう一つの変更へのパッチ（これはファイル間の差分です）の集合を保持することで稼動します。そういうわけで、全てのパッチを積み上げることで、いつかは、あらゆる時点の、あらゆるファイルのように見えるものを再生成する事ができます。

### 集中バージョン管理システム ###

次に人々が遭遇した大きな問題は、他のシステムの開発者と共同制作をする必要があることです。この問題に対処するために、集中バージョン管理システム（CVCSs）が開発されました。CVSやSubversion、Perforceのような、これらのシステムは、全てのバージョン管理されたファイルと、その中央の場所からファイルをチェック・アウトする多数のクライアントを含む単一のサーバーを持ちます。長年の間、これはバージョン管理の標準となって来ました（図1-2参照）。

Insert 18333fig0102.png 
図1-2. 集中バージョン管理図解

この構成は、特にローカルVCSに対して、多くの利点を提供します。例えば、全ての人は、プロジェクトのその他の全ての人々が何をしているのか、一定の程度は知っています。管理者は、誰が何をできるのかについて、きめ細かい統制手段を持ちます。このため、一つのCVCSを管理するということは、全てのクライアントのローカル・データベースを取り扱うより、はるかに容易です。

しかしながら、この構成はまた、深刻な不利益も持ちます。もっとも明白なのは、中央サーバーで発生する単一障害点です。もし、そのサーバーが1時間の間停止すると、その1時間の間は誰も全く、共同作業や、彼らが作業を進めている全てに対してバージョン変更の保存をすることができなくなります。もし中央データベースがのっているハードディスクが破損し、適切なバックアップが保持されていないとすると、人々が偶然にローカル・マシンに持っていた幾らかの単一スナップショットを除いた、プロジェクト全体の履歴を失うことになります。ローカルVCSシステムも、これと同じ問題に悩まされます。つまり、単一の場所にプロジェクトの全体の履歴を持っているときはいつでも、全てを失う事を覚悟することになります。

### 分散バージョン管理システム ###

ここから分散バージョン管理システム(DVCs)に入ります。DVCS(Git、Mercurial、Bazaar、Darcsのようなもの)では、クライアントはファイルの最新スナップショットをチェックアウトするだけではありません。リポジトリ（訳者注：バージョン管理の対象になるファイル、ディレクトリー、更新履歴などの一群）全体をミラーリングします。故にどのサーバが故障したとして、故障したサーバを介してそれらのDVCSが共同作業をしていたとしても、あらゆるクライアント・リポジトリーは修復のためにサーバーにコピーして戻す事ができます。そのサーバを介してコラボレーションしていたシステムは, どれか一つのクライアントのリポジトリからサーバ復旧の為バックアップをコピーすることができます. 全てのチェックアウトは、実は全データの完全バックアップなのです(図1-3を参照)。

Insert 18333fig0103.png 
図1-3. 分散バージョン管理システムの図解

そのうえ、これらのDVCSの多くは、 連携する複数のリモート・リポジトリを扱いながら大変よく機能するため、同一のプロジェクト内において、同時に異なった方法で、異なる人々のグループと共同作業が可能です。このことは、集中システムでは可能では無かった階層モデルのような、幾つかの作業手順の様式を始めることを許します。

## Git の簡単な歴史 ##

人生における多くの素晴らしい出来事のように, Git はわずかな創造的破壊と情熱的論争から始まりました. Linux カーネルは非常に巨大なオープンソース・ソフトウェア・プロジェクトです. Linux カーネル保守の生涯のほとんど(1991-2002年)で, ソフトウェアへの変更はパッチとして配布されファイルに保管されました. 2002年, Linux カーネル・プロジェクトはプロプライエタリの DVCS である BitKeeper を使い始めました.

2005年, Linux カーネルの開発コミュニティと BitKeeper 開発会社との関係が砕けました. BitKeeper の無償利用が取り消されたのです. これは Linux 開発コミュニティ(と特に Linux 開発者 Linus Torvalds)に, BitKeeper から得た教訓を踏まえた専用のツール開発を促しました. 新たなシステムのゴールにすえられたもののうちいくつかは以下の通りです:

*	スピード
*	シンプル・デザイン
*	ノンリニア開発(数千の並列ブランチ)への強力なサポート
*	完全な分散
*	Linux カーネルのような大規模プロジェクトを(スピードとデータサイズで)効率的に処理可能

2005年に誕生してから, Git はその使いやすさとこれら基本品質を保持しながら発展しています. 驚くほど早く, 大規模プロジェクトでとても効率的で, 驚くべきブランチ・システムをノンリニア開発に与えています(第3章参照).

## Git の基本 ##

では, 小さな容器の中で Git は何なのでしょう. これは理解すべき重要な部分です. Git とは何か, そして基本的動作を理解すれば, Git を効果的に使うのがより簡単になるはずです. Git 学習のため, Subversion や Perforce など他の VCS は忘れて下さい. これはこのツールを使うときの混乱を避けるのに役立ちます. Git の情報の格納方法と考え方は他 VCS と大きく異なります. そうでありながらユーザインタフェースはかなり似ています. これら違いを理解することが使用時の混乱を防ぎます.

### スナップショット != 相違 ###

Git と他の VCS (Subversion とその類を含む)の代表的な相違は, Git のデータについての考え方です. 概念的に, 他システムのほとんどが情報をファイルごとの変更のリストとして格納します. これらシステム(CVS, Subversion, Perforce, Bazaar 等々)はシステムが保持するファイル群と各ファイルの時間ごとの変更を考えます. 図1-4に表しました.

Insert 18333fig0104.png 
図1-4. 他システムはデータを各ファイルの元となるバージョンへの変更として格納します.

Git は考え方もデータ格納方法も上記とは異なります. 代わりに Git は データをミニ・ファイルシステムのスナップショット群のように考えます. コミットする度, Git でプロジェクトの状態を保存する度, 全てのファイルがどのように見えるか, その瞬間の写真を撮るのです. そしてそのスナップショットへの参照を格納します. 効果的にするため, そのファイルは変更されません. Git は2度とそのファイルを格納しません. ちょうど以前の識別可能な格納済みファイルへのリンクのようなものです. Git はデータを図1-5のように考えます.

Insert 18333fig0105.png 
図1-5. Git は時間とともにプロジェクトのスナップショットをデータとして格納します.

これは Git と ほぼそれ以外全ての VCS における相違です.  Git はほぼ全ての面で, 過去の世代からコピーされたほとんどのバージョン管理システムを見直しています. これは Git をミニ・ファイルシステムとその上に組み上げられた驚くほど力強いツールとしています. ただの VCS 以上のものにです. 第3章, Git ブランチを扱う時, データに対するこの考え方で得られる利益を見出せるでしょう.

### ほぼ全ての操作はローカル ###

Git のほとんどの操作はローカルファイルと操作のためのリソースだけで十分です. 基本的にネットワーク上の他コンピュータから情報は必要ありません. ほとんどの操作を呼び出し時間のオーバヘッドがあるネットワークで行う集中バージョン管理に慣れていると, この面で Git は, この世のものでない, 神に祝福をされたスピードだと思えるでしょう. これはプロジェクト全体の履歴を目前のコンピュータが全て持っているからに他なりません. ほとんどの操作が一瞬に感じられます.

例えば, プロジェクトの履歴を参照するのに, Git はサーバにアクセスして履歴を取得する必要がありません. 単純にローカルデータベースを直接参照します. つまりプロジェクトの履歴をほぼ即座に確認できます. 現バージョンのファイルと1ヶ月前の変更を確認したければ, Git は1ヶ月前のファイルを検索しローカルで相違の確認が出来ます. サーバに相違の確認を問い合わせる必要も古いバージョンをサーバから入手してローカルで確認する手間もありません.

つまるところ, オフラインや VPN に接続していないコンピュータで何も出来ないわけではありません. 飛行機や電車で作業したい場合, どこかでネットワーク接続するまでコミットを続けられます. もし自宅で VPN クライアントが正常に動作しなくても, 作業は続けられます. 多くの他システムでこれは不可能か現実的ではありません. Perforce では例えばネットワーク接続がないと大したことができません. Subversion と CVS ではファイルの編集は出来ますが変更のコミットをデータベースに反映できません(データベースに接続できないので). これは大きな問題ではないかも知れません. しかし Git のもたらす大きな利点には驚いたのではないでしょうか.

### Git は誠実です ###

Git のリソースは全て, 格納前と参照前にチェックサムが実施されます. つまり Git に感知されずにファイルやディレクトリに変更を加えることは不可能です. これは根本的な機能として組み込まれ, Git の哲学にもなっています. 情報伝達を失うこともファイルを破壊することも, Git 抜きでは不可能です.

Git の用いるこのチェックサム・メカニズムは SHA-1 ハッシュです. これは40文字からなる16進数(0-9 と a-f)と ファイルの中身や Git のディレクトリ構造を計算した物を基本としています. SHA-1 ハッシュは下記のようなものです:

	24b9da6552252987aa493b52f8696cd6d3b00373

Git の中ではこのようなハッシュをいたるところで目にするでしょう. 実際, Git は全てをファイル名でなく, ファイルの内容をハッシュ値でデータベースに記録します.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory

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

	$ apt-get install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel
	
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
Figure 1-7. Git OS X installer

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
