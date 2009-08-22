# Git の基本 #

Git を使い始めるにあたってどれかひとつの章だけしか読めないとしたら、読むべきは本章です。この章では、あなたが実際に Git を使う際に必要となる基本コマンドをすべて取り上げています。本章を最後まで読めば、リポジトリの設定や初期化、ファイルの追跡、そして変更内容のステージやコミットなどができるようになるでしょう。また、Git で特定のファイル (あるいは特定のファイルパターン) を無視させる方法やミスを簡単に取り消す方法、プロジェクトの歴史や各コミットの変更内容を見る方法、リモートリポジトリとの間でのプッシュやプルを行う方法についても説明します。

## Git リポジトリの取得 ##

Git プロジェクトを取得するには、大きく二通りの方法があります。ひとつは既存のプロジェクトやディレクトリを Git にインポートする方法、そしてもうひとつは既存の Git リポジトリを別のサーバからクローンする方法です。

### 既存のディレクトリでのリポジトリの初期化 ###

既存のプロジェクトを Git で管理し始めるときは、そのプロジェクトのディレクトリに移動して次のように打ち込みます。

	$ git init

これを実行すると .git という名前の新しいサブディレクトリが作られ、リポジトリに必要なすべてのファイル (Git リポジトリのスケルトン) がその中に格納されます。この時点では、まだプロジェクト内のファイルは一切管理対象になっていません (今作った .git ディレクトリに実際のところどんなファイルが含まれているのかについての詳細な情報は、第 9 章を参照ください)。

空のディレクトリではなくすでに存在するファイルのバージョン管理を始めたい場合は、まずそのファイルを監視対象に追加してから最初のコミットをすることになります。この場合は、追加したいファイルについて git add コマンドを実行したあとでコミットを行います。

	$ git add *.c
	$ git add README
	$ git commit –m 'initial project version'

これが実際のところどういう意味なのかについては後で説明します。ひとまずこの時点で、監視対象のファイルを持つ Git リポジトリができあがり最初のコミットまで済んだことになります。

### 既存のリポジトリのクローン ###

既存の Git リポジトリ (何か協力したいと思っているプロジェクトなど) のコピーを取得したい場合に使うコマンドが、git clone です。Subversion などの他の VCS を使っている人なら「checkout じゃなくて clone なのか」と気になることでしょう。これは重要な違いです。Git は、サーバが保持しているデータをほぼすべてコピーするのです。そのプロジェクトのすべてのファイルのすべての歴史が、`git clone` で手元にやってきます。実際、もし仮にサーバのディスクが壊れてしまったとしても、どこかのクライアントに残っているクローンをサーバに戻せばクローンした時点まで復元することができます (サーバサイドのフックなど一部の情報は失われてしまいますが、これまでのバージョン管理履歴はすべてそこに残っています。第 4 章で詳しく説明します)。

リポジトリをクローンするには `git clone [url]` とします。たとえば、Ruby の Git ライブラリである Grit をクローンする場合は次のようになります。

	$ git clone git://github.com/schacon/grit.git

これは、まず "grit" というディレクトリを作成してその中で `.git` ディレクトリを初期化し、リポジトリのすべてのデータを引き出し、そして最新バージョンの作業コピーをチェックアウトします。新しくできた `grit` ディレクトリに入ると、プロジェクトのファイルをごらんいただけます。もし grit ではない別の名前のディレクトリにクローンしたいのなら、コマンドラインオプションでディレクトリ名を指定します。

	$ git clone git://github.com/schacon/grit.git mygrit

このコマンドは先ほどと同じ処理をしますが、ディレクトリ名は mygrit となります。

Git では、さまざまな転送プロトコルを使用することができます。先ほどの例では `git://` プロトコルを使用しましたが、`http(s)://` や `user@server:/path.git` といった形式を使うこともできます。これらは SSH プロトコルを使用します。第 4 章で、サーバ側で準備できるすべてのアクセス方式についての利点と欠点を説明します。

## 変更内容のリポジトリへの記録 ##

これで、れっきとした Git リポジトリを準備して、そのプロジェクト内のファイルの作業コピーを取得することができました。次は、そのコピーに対して何らかの変更を行い、適当な時点で変更内容のスナップショットをリポジトリにコミットすることになります。

作業コピー内の各ファイルには「追跡されている(tracked)」ものと「追跡されてない(untracked)」ものの二通りがあることを知っておきましょう。追跡されているファイルとは、直近のスナップショットに存在したファイルのことです。これらのファイルについては「変更されていない(unmodified)」「変更されている(modified)」「ステージされている(staged)」の三つの状態があります。追跡されていないファイルは、そのどれでもありません。直近のスナップショットには存在せず、ステージングエリアにも存在しないファイルのことです。最初にプロジェクトをクローンした時点では、すべてのファイルは「追跡されている」かつ「変更されていない」状態となります。チェックアウトしただけで何も編集していない状態だからです。

ファイルを編集すると、Git はそれを「変更された」とみなします。直近のコミットの後で変更が加えられたからです。変更されたファイルをステージし、それをコミットする。この繰り返しです。ここまでの流れを図 2-1 にまとめました。

Insert 18333fig0201.png 
図 2-1. ファイルの状態の流れ

### ファイルの状態の確認 ###

どのファイルがどの状態にあるのかを知るために主に使うツールが git status コマンドです。このコマンドをクローン直後に実行すると、このような結果となるでしょう。

	$ git status
	# On branch master
	nothing to commit (working directory clean)

これは、クリーンな作業コピーである (つまり、追跡されているファイルの中に変更されているものがない) ことを意味します。また、追跡されていないファイルも存在しません (もし追跡されていないファイルがあれば、Git はそれを表示します)。最後に、このコマンドを実行するとあなたが今どのブランチにいるのかを知ることができます。現時点では常に master となります。これはデフォルトであり、ここでは特に気にする必要はありません。ブランチについては次の章で詳しく説明します。

ではここで、新しいファイルをプロジェクトに追加してみましょう。シンプルに、README ファイルを追加してみます。それ以前に README ファイルがなかった場合、`git status` を実行すると次のように表示されます。

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

出力結果の “Untracked files” 欄に README ファイルがあることから、このファイルが追跡されていないということがわかります。これは、Git が「前回のスナップショット (コミット) にはこのファイルが存在しなかった」とみなしたということです。明示的に指示しない限り、Git はコミット時にこのファイルを含めることはありません。自動生成されたバイナリファイルなど、コミットしたくないファイルを間違えてコミットしてしまう心配はないということです。今回は README をコミットに含めたいわけですから、まずファイルを追跡対象に含めるようにしましょう。

### 新しいファイルの追跡 ###

新しいファイルの追跡を開始するには `git add` コマンドを使用します。README ファイルの追跡を開始する場合はこのようになります。

	$ git add README

再び status コマンドを実行すると、README ファイルが追跡対象となり、ステージされていることがわかるでしょう。

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

ステージされていると判断できるのは、“Changes to be committed” 欄に表示されているからです。ここでコミットを行うと、git add した時点の状態のファイルがスナップショットとして歴史に書き込まれます。先ほど git init をしたときに、ディレクトリ内のファイルを追跡するためにその後 git add したことを思い出すことでしょう。git add コマンドには、ファイルあるいはディレクトリのパスを指定します。ディレクトリを指定した場合は、そのディレクトリ以下にあるすべてのファイルを再起的に追加します。

### 変更したファイルのステージング ###

すでに追跡対象となっているファイルを変更してみましょう。たとえば、すでに追跡対象となっているファイル `benchmarks.rb` を変更して `status` コマンドを実行すると、結果はこのようになります。

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

benchmarks.rb ファイルは “Changed but not updated” という欄に表示されます。これは、追跡対象のファイルが作業ディレクトリ内で変更されたけれどもまだステージされていないという意味です。ステージするには `git add` コマンドを実行します (このコマンドにはいろんな意味合いがあり、新しいファイルの追跡開始・ファイルのステージング・マージ時に衝突が発生したファイルに対する「解決済み」マーク付けなどで使用します)。では、`git add` で benchmarks.rb をステージしてもういちど `git status` を実行してみましょう。

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

両方のファイルがステージされました。これで、次回のコミットに両方のファイルが含まれるようになります。ここで、さらに benchmarks.rb にちょっとした変更を加えてからコミットしたくなったとしましょう。ファイルを開いて変更を終え、コミットの準備が整いました。しかし、`git status` を実行してみると何か変です。

	$ vim benchmarks.rb 
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

これはどういうことでしょう? benchmarks.rb が、ステージされているほうにもステージされていないほうにも登場しています。こんなことってありえるんでしょうか? 要するに、Git は「git add コマンドを実行した時点の状態のファイル」をステージするということです。ここでコミットをすると、実際にコミットされるのは git add を実行した時点の benchmarks.rb であり、git commit した時点の作業ディレクトリにある内容とは違うものになります。`git add` した後にファイルを変更した場合に、最新版のファイルをステージしなおすにはもう一度 `git add` を実行します。

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### ファイルの無視 ###

ある種のファイルについては、Git で自動的に追加してほしくないしそもそも「追跡されていない」と表示されるのも気になる。そんなことがよくあります。たとえば、ログファイルやビルドシステムが生成するファイルなどの自動生成されるファイルがそれにあたるでしょう。そんな場合は、無視させたいファイルのパターンを並べた .gitignore というファイルを作成します。.gitignore ファイルは、たとえばこのようになります。

	$ cat .gitignore
	*.[oa]
	*~

最初の行は .o あるいは .a で終わる名前のファイル (コードをビルドする際にできるであろうオブジェクトファイルとアーカイブファイル) を無視するよう Git に伝えています。次の行で Git に無視させているのは、チルダ (`~`) で終わる名前のファイルです。Emacs をはじめとする多くのエディタが、この形式の一時ファイルを作成します。これ以外には、たとえば log、tmp、pid といった名前のディレクトリや自動生成されるドキュメントなどもここに含めることになるでしょう。実際に作業を始める前に .gitignore ファイルを準備しておくことをお勧めします。そうすれば、予期せぬファイルを間違って Git リポジトリにコミットしてしまう事故を防げます。

.gitignore ファイルに記述するパターンの規則は、次のようになります。

*	空行あるいは # で始まる行は無視される
*	標準の glob パターンを使用可能
*	ディレクトリを指定するには、パターンの最後にスラッシュ (`/`) をつける
*	パターンを逆転させるには、最初に感嘆符 (`!`) をつける

glob パターンとは、シェルで用いる簡易正規表現のようなものです。アスタリスク (`*`) は、ゼロ個以上の文字にマッチします。`[abc]` は、角括弧内の任意の文字 (この場合は a、b あるいは c) にマッチします。疑問符 (`?`) は一文字にマッチします。また、ハイフン区切りの文字を角括弧で囲んだ形式 (`[0-9]`) は、ふたつの文字の間の任意の文字 (この場合は 0 から 9 までの間の文字) にマッチします。

では、.gitignore ファイルの例をもうひとつ見てみましょう。

	# コメント。これは無視されます
	*.a       # .a ファイルは無視
	!lib.a    # しかし、lib.a ファイルだけは .a であっても追跡対象とします
	/TODO     # ルートディレクトリの TODO ファイルだけを無視し、サブディレクトリの TODO は無視しません
	build/    # build/ ディレクトリのすべてのファイルを無視します
	doc/*.txt # doc/notes.txt は無視しますが、doc/server/arch.txt は無視しません

### ステージされている変更 / されていない変更の閲覧 ###

`git status` コマンドだけではよくわからない (どのファイルが変更されたのかだけではなく、実際にどのように変わったのかが知りたい) という場合は `git diff` コマンドを使用します。`git diff` コマンドについては後で詳しく解説します。おそらく、最もよく使う場面としては次の二つの問いに答えるときになるでしょう。「変更したけどまだステージしていない変更は?」「コミット対象としてステージした変更は?」もちろん `git status` でもこれらの質問に対するおおまかな答えは得られますが、`git diff` の場合は追加したり削除したりした正確な行をパッチ形式で表示します。

先ほどの続きで、ふたたび README ファイルを編集してステージし、一方 benchmarks.rb ファイルは編集だけしてステージしない状態にあると仮定しましょう。ここで `status` コマンドを実行すると、次のような結果となります。

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

変更したけれどもまだステージしていない内容を見るには、引数なしで `git diff` を実行します。

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

このコマンドは、作業ディレクトリの内容とステージングエリアの内容を比較します。この結果を見れば、あなたが変更した内容のうちまだステージされていないものを知ることができます。

次のコミットに含めるべくステージされた内容を知りたい場合は、`git diff –-cached` を使用します (Git バージョン 1.6.1 以降では `git diff –-staged` も使えます。こちらのほうが覚えやすいでしょう)。このコマンドは、ステージされている変更と直近のコミットの内容を比較します。

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

`git diff` 自体は、直近のコミット以降のすべての変更を表示するわけではないことに注意しましょう。あくまでもステージされていない変更だけの表示となります。これにはすこし戸惑うかもしれません。変更内容をすべてステージしてしまえば `git diff` は何も出力しなくなるわけですから。

もうひとつの例を見てみましょう。benchmarks.rb ファイルをいったんステージした後に編集してみましょう。`git diff` を使用すると、ステージされたファイルの変更とまだステージされていないファイルの変更を見ることができます。

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#

ここで `git diff` を使うと、まだステージされていない内容を知ることができます。

	$ git diff 
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats 
	+# test line

そして `git diff --cached` を使うと、これまでにステージした内容を知ることができます。

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+              
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### 変更のコミット ###

ステージングエリアの準備ができたら、変更内容をコミットすることができます。コミットの対象となるのはステージされたものだけ、つまり追加したり変更したりしただけでまだ `git add` を実行していないファイルはコミットされないことを覚えておきましょう。そういったファイルは、変更されたままの状態でディスク上に残ります。今回の場合は、最後に `git status` を実行したときにすべてがステージされていることを確認しています。つまり、変更をコミットする準備ができた状態です。コミットするための最もシンプルな方法は `git commit` と打ち込むことです。

	$ git commit

これを実行すると、指定したエディタが立ち上がります (シェルの `$EDITOR` 環境変数で設定されているエディタ。通常は vim あるいは emacs でしょう。しかし、それ以外にも第 1 章で説明した `git config --global core.editor` コマンドでお好みのエディタを指定することもできます)。

エディタには次のようなテキストが表示されています (これは Vim の画面の例です)。

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb 
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

デフォルトのコミットメッセージとして、直近の `git status` コマンドの結果がコメントアウトして表示され、先頭に空行があることがわかるでしょう。このコメントを消して自分でコミットメッセージを書き入れていくこともできますし、何をコミットしようとしているのかの確認のためにそのまま残しておいてもかまいません (何を変更したのかをより明確に知りたい場合は、`git commit` に `-v` オプションを指定します。そうすると、diff の内容がエディタに表示されるので何を行ったのかが正確にわかるようになります)。エディタを終了させると、Git はそのメッセージつきのコミットを作成します (コメントおよび diff は削除されます)。

あるいは、コミットメッセージをインラインで記述することもできます。その場合は、`commit` コマンドの後で -m フラグに続けて次のように記述します。

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

これではじめてのコミットができました! 今回のコミットについて、「どのブランチにコミットしたのか (master)」「そのコミットの SHA-1 チェックサム (`463dc4f`)」「変更されたファイルの数」「そのコミットで追加されたり削除されたりした行数」といった情報が表示されているのがわかるでしょう。

コミットが記録するのは、ステージングエリアのスナップショットであることを覚えておきましょう。ステージしていない情報については変更された状態のまま残っています。別のコミットで歴史にそれを書き加えるには、改めて add する必要があります。コミットするたびにプロジェクトのスナップショットが記録され、あとからそれを取り消したり参照したりできるようになります。

### ステージングエリアの省略 ###

コミットの内容を思い通りに作り上げることができるという点でステージングエリアは非常に便利なのですが、普段の作業においては必要以上に複雑に感じられることもあるでしょう。ステージングエリアを省略したい場合のために、Git ではシンプルなショートカットを用意しています。`git commit` コマンドに `-a` オプションを指定すると、追跡対象となっているファイルを自動的にステージしてからコミットを行います。つまり `git add` を省略できるというわけです。

	$ git status
	# On branch master
	#
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

この場合、コミットする前に benchmarks.rb を `git add` する必要がないことに注意しましょう。

### ファイルの削除 ###

ファイルを Git から削除するには、追跡対象からはずし (より正確に言うとステージングエリアから削除し)、そしてコミットします。`git rm` コマンドは、この作業を行い、そして作業ディレクトリからファイルを削除します。つまり、追跡されていないファイルとして残り続けることはありません。

単に作業ディレクトリからファイルを削除しただけの場合は、`git status` の出力の中では “Changed but not updated” (つまり _ステージされていない_) 欄に表示されます。

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

`git rm` を実行すると、ファイルの削除がステージされます。

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

次にコミットするときにファイルが削除され、追跡対象外となります。変更したファイルをすでにステージしている場合は、`-f` オプションで強制的に削除しなければなりません。まだスナップショットに記録されていないファイルを誤って削除してしまうと Git で復旧することができなくなってしまうので、それを防ぐための安全装置です。

ほかに「こんなことできたらいいな」と思われるであろう機能として、ファイル自体は作業ツリーに残しつつステージングエリアからの削除だけを行うこともできます。つまり、ハードディスク上にはファイルを残しておきたいけれど、もう Git では追跡させたくないというような場合のことです。これが特に便利なのは、`.gitignore` ファイルに書き足すのを忘れたために巨大なログファイルや大量の `.a` ファイルが追加されてしまったなどというときです。そんな場合は `--cached` オプションを使用します。

	$ git rm --cached readme.txt

ファイル名やディレクトリ名、そしてファイル glob パターンを `git rm` コマンドに渡すことができます。つまり、このようなこともできるということです。

	$ git rm log/\*.log

`*` の前にバックスラッシュ (`\`) があることに注意しましょう。これが必要なのは、シェルによるファイル名の展開だけでなく Git が自前でファイル名の展開を行うからです。このコマンドは、`log/` ディレクトリにある拡張子 `.log` のファイルをすべて削除します。あるいは、このような書き方もできます。

	$ git rm \*~

このコマンドは、`~` で終わるファイル名のファイルをすべて削除します。

### ファイルの移動 ###

他の多くの VCS とは異なり、Git はファイルの移動を明示的に追跡することはありません。Git の中でファイル名を変更しても、「ファイル名を変更した」というメタデータは Git には保存されないのです。しかし Git は賢いので、ファイル名が変わったことを知ることができます。ファイルの移動を検出する仕組みについては後ほど説明します。

しかし Git には `mv` コマンドがあります。ちょっと混乱するかもしれませんね。Git の中でファイル名を変更したい場合は次のようなコマンドを実行します。

	$ git mv file_from file_to

このようなコマンドを実行してから status を確認すると、Git はそれをファイル名が変更されたと解釈していることがわかるでしょう。

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

しかし、実際のところこれは、次のようなコマンドを実行するのと同じ意味となります。

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git はこれが暗黙的なファイル名の変更であると理解するので、この方法であろうが `mv` コマンドを使おうがどちらでもかまいません。唯一の違いは、この方法だと 3 つのコマンドが必要になるかわりに `mv` だとひとつのコマンドだけで実行できるという点です。より重要なのは、ファイル名の変更は何でもお好みのツールで行えるということです。あとでコミットする前に add/rm を指示してやればいいのです。

## コミット履歴の閲覧 ##

何度かコミットを繰り返すと、あるいはコミット履歴つきの既存のリポジトリをクローンすると、過去に何が起こったのかを振り返りたくなることでしょう。そのために使用するもっとも基本的かつパワフルな道具が `git log` コマンドです。

ここからの例では、simplegit という非常にシンプルなプロジェクトを使用します。これは、私が説明用によく用いているプロジェクトで、次のようにして取得できます。

	git clone git://github.com/schacon/simplegit-progit.git

このプロジェクトで `git log` を実行すると、このような結果が得られます。

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

デフォルトで引数を何も指定しなければ、`git log` はそのリポジトリでのコミットを新しい順に表示します。つまり、直近のコミットが最初に登場するということです。ごらんのとおり、このコマンドは各コミットについて SHA-1 チェックサム・作者の名前とメールアドレス・コミット日時・コミットメッセージを一覧表示します。

`git log` コマンドには数多くのバラエティに富んだオプションがあり、あなたが本当に見たいものを表示させることができます。ここでは、よく用いられるオプションのいくつかをご覧に入れましょう。

もっとも便利なオプションのひとつが `-p` で、これは各コミットの diff を表示します。また `-2` は、直近の 2 エントリだけを出力します。

	$ git log –p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,7 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

このオプションは、先ほどと同じ情報を表示するとともに、各エントリの直後にその diff を表示します。これはコードレビューのときに非常に便利です。また、他のメンバーが一連のコミットで何を行ったのかをざっと眺めるのにも便利でしょう。また、`git log` では「まとめ」系のオプションを使うこともできます。たとえば、各コミットに関するちょっとした統計情報を見たい場合は `--stat` オプションを使用します。

	$ git log --stat 
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

ごらんの通り `--stat` オプションは、各コミットエントリに続けて変更されたファイルの一覧と変更されたファイルの数、追加・削除された行数が表示されます。また、それらの情報のまとめを最後に出力します。もうひとつの便利なオプションが `--pretty` です。これは、ログをデフォルトの書式以外で出力します。あらかじめ用意されているいくつかのオプションを指定することができます。oneline オプションは、各コミットを一行で出力します。これは、大量のコミットを見る場合に便利です。さらに `short` や `full` そして `fuller` といったオプションもあり、これは標準とほぼ同じ書式だけれども情報量がそれぞれ少なめあるいは多めになります。

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

もっとも興味深いオプションは `format` で、これは独自のログ出力フォーマットを指定することができます。これは、出力結果を機械にパースさせる際に非常に便利です。自分でフォーマットを指定しておけば、将来 Git をアップデートしても結果が変わらないようにできるからです。

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

表 2-1 は、format で使用できる便利なオプションをまとめたものです。

	オプション	出力される内容
	%H	コミットのハッシュ
	%h	コミットのハッシュ (短縮版)
	%T	ツリーのハッシュ
	%t	ツリーのハッシュ (短縮版)
	%P	親のハッシュ
	%p	親のハッシュ (短縮版)
	%an	Author の名前
	%ae	Author のメールアドレス
	%ad	Author の日付 (–date= オプションにしたがった形式)
	%ar	Author の相対日付
	%cn	Committer の名前
	%ce	Committer のメールアドレス
	%cd	Committer の日付
	%cr	Committer の相対日付
	%s	件名

_author_ と _committer_ は何が違うのか気になる方もいるでしょう。author とはその作業をもともと行った人、committer とはその作業を適用した人のことを指します。あなたがとあるプロジェクトにパッチを送り、コアメンバーのだれかがそのパッチを適用したとしましょう。この場合、両方がクレジットされます (あなたが author、コアメンバーが committer です)。この区別については第 5 章でもう少し詳しく説明します。

oneline オプションおよび format オプションは、`log` のもうひとつのオプションである `--graph` と組み合わせるとさらに便利です。このオプションは、ちょっといい感じのアスキーグラフでブランチやマージの歴史を表示します。Grit プロジェクトのリポジトリならこのようになります。

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\  
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/  
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

これらは `git log` の出力フォーマット指定のほんの一部でしかありません。まだまだオプションはあります。表 2-2 に、今まで取り上げたオプションとそれ以外によく使われるオプション、そしてそれぞれがログの出力をどのように変えるのかをまとめました。

	オプション	説明
	-p	各コミットのパッチを表示する
	--stat	各コミットで変更されたファイルの統計情報を表示する
	--shortstat	--stat コマンドのうち、変更/追加/削除 の行だけを表示する
	--name-only	コミット情報の後に変更されたファイルの一覧を表示する
	--name-status	変更されたファイルと 追加/修正/削除 情報を表示する
	--abbrev-commit	SHA-1 チェックサムの全体 (40文字) ではなく最初の数文字のみを表示する
	--relative-date	完全な日付フォーマットではなく、相対フォーマット (“2 weeks ago”など) で日付を表示する
	--graph	ブランチやマージの歴史を、ログ出力とともにアスキーグラフで表示する
	--pretty	コミットを別のフォーマットで表示する。オプションとして oneline, short, full, fuller そして format (独自フォーマットを設定する) を指定可能

### ログ出力の制限 ###

出力のフォーマット用オプションだけでなく、git log にはログの制限用の便利なオプションもあります。コミットの一部だけを表示するようなオプションのことです。既にひとつだけ紹介していますね。`-2` オプション、これは直近のふたつのコミットだけを表示するものです。実は `-<n>` の `n` には任意の整数値を指定することができ、直近の `n` 件のコミットだけを表示させることができます。ただ、実際のところはこれを使うことはあまりないでしょう。というのも、Git はデフォルトですべての出力をページャにパイプするので、ログを一度に 1 ページだけ見ることになるからです。

しかし `--since` や `--until` のような時間制限のオプションは非常に便利です。たとえばこのコマンドは、過去二週間のコミットの一覧を取得します。

	$ git log --since=2.weeks

このコマンドはさまざまな書式で動作します。特定の日を指定する (“2008-01-15”) こともできますし、相対日付を“2 years 1 day 3 minutes ago”のように指定することも可能です。

コミット一覧から検索条件にマッチするものだけを取り出すこともできます。`--author` オプションは特定の author のみを抜き出し、`--grep` オプションはコミットメッセージの中のキーワードを検索します (author と grep を両方指定したい場合は `--all-match` を追加しないといけません。そうしないと、どちらか一方にだけマッチするものも対象になってしまいます)。

最後に紹介する `git log` のフィルタリング用オプションは、パスです。ディレクトリ名あるいはファイル名を指定すると、それを変更したコミットのみが対象となります。このオプションは常に最後に指定し、一般にダブルダッシュ (`--`) の後に記述します。このダブルダッシュが他のオプションとパスの区切りとなります。

表 2-3 に、これらのオプションとその他の一般的なオプションをまとめました。

	オプション	説明
	-(n)	直近の n 件のコミットのみを表示する
	--since, --after	指定した日付以降のコミットのみに制限する
	--until, --before	指定した日付以前のコミットのみに制限する
	--author	author エントリが指定した文字列にマッチするコミットのみを表示する
	--committer	committer エントリが指定した文字列にマッチするコミットのみを表示する

たとえば、Git ソースツリーのテストファイルに対する変更があったコミットのうち、Junio Hamano がコミットしたもの (マージは除く) で 2008 年 10 月に行われたものを知りたければ次のように指定します。

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

約 20,000 件におよぶ Git ソースコードのコミットの歴史の中で、このコマンドの条件にマッチするのは 6 件となります。

### GUI による歴史の可視化 ###

もう少しグラフィカルなツールでコミットの歴史を見たい場合は、Tcl/Tk のプログラムである gitk を見てみましょう。これは Git に同梱されています。gitk は、簡単に言うとビジュアルな `git log` ツールです。`git log` で使えるフィルタリングオプションにはほぼすべて対応しています。プロジェクトのコマンドラインで gitk と打ち込むと、図 2-2 のような画面があらわれるでしょう。

Insert 18333fig0202.png 
図 2-2. gitk history visualizer

ウィンドウの上半分に、コミットの歴史がきれいな家系図とともに表示されます。ウィンドウの下半分には diff ビューアがあり、任意のコミットをクリックしてその変更内容を確認することができます。

## Undoing Things ##

At any stage, you may want to undo something. Here, we’ll review a few basic tools for undoing changes that you’ve made. Be careful, because you can’t always undo some of these undos. This is one of the few areas in Git where you may lose some work if you do it wrong.

### Changing Your Last Commit ###

One of the common undos takes place when you commit too early and possibly forget to add some files, or you mess up your commit message. If you want to try that commit again, you can run commit with the `--amend` option:

	$ git commit --amend

This command takes your staging area and uses it for the commit. If you’ve have made no changes since your last commit (for instance, you run this command immediately after your previous commit), then your snapshot will look exactly the same and all you’ll change is your commit message.

The same commit-message editor fires up, but it already contains the message of your previous commit. You can edit the message the same as always, but it overwrites your previous commit.

As an example, if you commit and then realize you forgot to stage the changes in a file you wanted to add to this commit, you can do something like this:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

All three of these commands end up with a single commit — the second command replaces the results of the first.

### Unstaging a Staged File ###

The next two sections demonstrate how to wrangle your staging area and working directory changes. The nice part is that the command you use to determine the state of those two areas also reminds you how to undo changes to them. For example, let’s say you’ve changed two files and want to commit them as two separate changes, but you accidentally type `git add *` and stage them both. How can you unstage one of the two? The `git status` command reminds you:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Right below the “Changes to be committed” text, it says use `git reset HEAD <file>...` to unstage. So, let’s use that advice to unstage the benchmarks.rb file:

	$ git reset HEAD benchmarks.rb 
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

The command is a bit strange, but it works. The benchmarks.rb file is modified but once again unstaged.

### Unmodifying a Modified File ###

What if you realize that you don’t want to keep your changes to the benchmarks.rb file? How can you easily unmodify it — revert it back to what it looked like when you last committed (or initially cloned, or however you got it into your working directory)? Luckily, `git status` tells you how to do that, too. In the last example output, the unstaged area looks like this:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

It tells you pretty explicitly how to discard the changes you’ve made (at least, the newer versions of Git, 1.6.1 and later, do this — if you have an older version, we highly recommend upgrading it to get some of these nicer usability features). Let’s do what it says:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

You can see that the changes have been reverted. You should also realize that this is a dangerous command: any changes you made to that file are gone — you just copied another file over it. Don’t ever use this command unless you absolutely know that you don’t want the file. If you just need to get it out of the way, we’ll go over stashing and branching in the next chapter; these are generally better ways to go. 

Remember, anything that is committed in Git can almost always be recovered. Even commits that were on branches that were deleted or commits that were overwritten with an `--amend` commit can be recovered (see Chapter 9 for data recovery). However, anything you lose that was never committed is likely never to be seen again.

## Working with Remotes ##

To be able to collaborate on any Git project, you need to know how to manage your remote repositories. Remote repositories are versions of your project that are hosted on the Internet or network somewhere. You can have several of them, each of which generally is either read-only or read/write for you. Collaborating with others involves managing these remote repositories and pushing and pulling data to and from them when you need to share work.
Managing remote repositories includes knowing how to add remote repositories, remove remotes that are no longer valid, manage various remote branches and define them as being tracked or not, and more. In this section, we’ll cover these remote-management skills.

### Showing Your Remotes ###

To see which remote servers you have configured, you can run the git remote command. It lists the shortnames of each remote handle you’ve specified. If you’ve cloned your repository, you should at least see origin — that is the default name Git gives to the server you cloned from:

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote 
	origin

You can also specify `-v`, which shows you the URL that Git has stored for the shortname to be expanded to:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

If you have more than one remote, the command lists them all. For example, my Grit repository looks something like this.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

This means we can pull contributions from any of these users pretty easily. But notice that only the origin remote is an SSH URL, so it’s the only one I can push to (we’ll cover why this is in Chapter 4).

### Adding Remote Repositories ###

I’ve mentioned and given some demonstrations of adding remote repositories in previous sections, but here is how to do it explicitly. To add a new remote Git repository as a shortname you can reference easily, run `git remote add [shortname] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Now you can use the string pb on the command line in lieu of the whole URL. For example, if you want to fetch all the information that Paul has but that you don’t yet have in your repository, you can run git fetch pb:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul’s master branch is accessible locally as `pb/master` — you can merge it into one of your branches, or you can check out a local branch at that point if you want to inspect it.

### Fetching and Pulling from Your Remotes ###

As you just saw, to get data from your remote projects, you can run

	$ git fetch [remote-name]

The command goes out to that remote project and pulls down all the data from that remote project that you don’t have yet. After you do this, you should have references to all the branches from that remote, which you can merge in or inspect at any time. (We’ll go over what branches are and how to use them in much more detail in Chapter 3.)

If you cloned a repository, the command automatically adds that remote repository under the name origin. So, `git fetch origin` fetches any new work that has been pushed to that server since you cloned (or last fetched from) it. It’s important to note that the fetch command pulls the data to your local repository — it doesn’t automatically merge it with any of your work or modify what you’re currently working on. You have to merge it manually into your work when you’re ready.

If you have a branch set up to track a remote branch (see the next section and Chapter 3 for more information), you can use the `git pull` command to automatically fetch and then merge a remote branch into your current branch. This may be an easier or more comfortable workflow for you; and by default, the `git clone` command automatically sets up your local master branch to track the remote master branch on the server you cloned from (assuming the remote has a master branch). Running `git pull` generally fetches data from the server you originally cloned from and automatically tries to merge it into the code you’re currently working on.

### Pushing to Your Remotes ###

When you have your project at a point that you want to share, you have to push it upstream. The command for this is simple: `git push [remote-name] [branch-name]`. If you want to push your master branch to your `origin` server (again, cloning generally sets up both of those names for you automatically), then you can run this to push your work back up to the server:

	$ git push origin master

This command works only if you cloned from a server to which you have write access and if nobody has pushed in the meantime. If you and someone else clone at the same time and they push upstream and then you push upstream, your push will rightly be rejected. You’ll have to pull down their work first and incorporate it into yours before you’ll be allowed to push. See Chapter 3 for more detailed information on how to push to remote servers.

### Inspecting a Remote ###

If you want to see more information about a particular remote, you can use the `git remote show [remote-name]` command. If you run this command with a particular shortname, such as `origin`, you get something like this:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

It lists the URL for the remote repository as well as the tracking branch information. The command helpfully tells you that if you’re on the master branch and you run `git pull`, it will automatically merge in the master branch on the remote after it fetches all the remote references. It also lists all the remote references it has pulled down.

That is a simple example you’re likely to encounter. When you’re using Git more heavily, however, you may see much more information from `git remote show`:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

This command shows which branch is automatically pushed when you run `git push` on certain branches. It also shows you which remote branches on the server you don’t yet have, which remote branches you have that have been removed from the server, and multiple branches that are automatically merged when you run `git pull`.

### Removing and Renaming Remotes ###

If you want to rename a reference, in newer versions of Git you can run `git remote rename` to change a remote’s shortname. For instance, if you want to rename `pb` to `paul`, you can do so with `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

It’s worth mentioning that this changes your remote branch names, too. What used to be referenced at `pb/master` is now at `paul/master`.

If you want to remove a reference for some reason — you’ve moved the server or are no longer using a particular mirror, or perhaps a contributor isn’t contributing anymore — you can use `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## タグ ##

多くの VCS と同様に Git にもタグ機能があり、歴史上の重要なポイントに印をつけることができます。一般に、この機能は (バージョン 1.0 などの) リリースポイントとして使われています。このセクションでは、既存のタグ一覧の取得や新しいタグの作成、さまざまなタグの形式などについて扱います。

### Listing Your Tags ###

Listing the available tags in Git is straightforward. Just type `git tag`:

	$ git tag
	v0.1
	v1.3

This command lists the tags in alphabetical order; the order in which they appear has no real importance.

You can also search for tags with a particular pattern. The Git source repo, for instance, contains more than 240 tags. If you’re only interested in looking at the 1.4.2 series, you can run this:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creating Tags ###

Git uses two main types of tags: lightweight and annotated. A lightweight tag is very much like a branch that doesn’t change — it’s just a pointer to a specific commit. Annotated tags, however, are stored as full objects in the Git database. They’re checksummed; contain the tagger name, e-mail, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG). It’s generally recommended that you create annotated tags so you can have all this information; but if you want a temporary tag or for some reason don’t want to keep the other information, lightweight tags are available too.

### Annotated Tags ###

Creating an annotated tag in Git is simple. The easiest way is to specify `-a` when you run the `tag` command:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

The `-m` specifies a tagging message, which is stored with the tag. If you don’t specify a message for an annotated tag, Git launches your editor so you can type it in.

You can see the tag data along with the commit that was tagged by using the `git show` command:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

That shows the tagger information, the date the commit was tagged, and the annotation message before showing the commit information.

### Signed Tags ###

You can also sign your tags with GPG, assuming you have a private key. All you have to do is use `-s` instead of `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you run `git show` on that tag, you can see your GPG signature attached to it:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

A bit later, you’ll learn how to verify signed tags.

### Lightweight Tags ###

Another way to tag commits is with a lightweight tag. This is basically the commit checksum stored in a file — no other information is kept. To create a lightweight tag, don’t supply the `-a`, `-s`, or `-m` option:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

This time, if you run `git show` on the tag, you don’t see the extra tag information. The command just shows the commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verifying Tags ###

To verify a signed tag, you use `git tag -v [tag-name]`. This command uses GPG to verify the signature. You need the signer’s public key in your keyring for this to work properly:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

If you don’t have the signer’s public key, you get something like this instead:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Tagging Later ###

You can also tag commits after you’ve moved past them. Suppose your commit history looks like this:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Now, suppose you forgot to tag the project at v1.2, which was at the "updated rakefile" commit. You can add it after the fact. To tag that commit, you specify the commit checksum (or part of it) at the end of the command:

	$ git tag -a v1.2 9fceb02

You can see that you’ve tagged the commit:

	$ git tag 
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Sharing Tags ###

By default, the `git push` command doesn’t transfer tags to remote servers. You will have to explicitly push tags to a shared server after you have created them.  This process is just like sharing remote branches – you can run `git push origin [tagname]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

If you have a lot of tags that you want to push up at once, you can also use the `--tags` option to the `git push` command.  This will transfer all of your tags to the remote server that are not already there.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Now, when someone else clones or pulls from your repository, they will get all your tags as well.

## Tips and Tricks ##

Before we finish this chapter on basic Git, a few little tips and tricks may make your Git experience a bit simpler, easier, or more familiar. Many people use Git without using any of these tips, and we won’t refer to them or assume you’ve used them later in the book; but you should probably know how to do them.

### Auto-Completion ###

If you use the Bash shell, Git comes with a nice auto-completion script you can enable. Download the Git source code, and look in the `contrib/completion` directory; there should be a file called `git-completion.bash`. Copy this file to your home directory, and add this to your `.bashrc` file:

	source ~/.git-completion.bash

If you want to set up Git to automatically have Bash shell completion for all users, copy this script to the `/opt/local/etc/bash_completion.d` directory on Mac systems or to the `/etc/bash_completion.d/` directory on Linux systems. This is a directory of scripts that Bash will automatically load to provide shell completions.

If you’re using Windows with Git Bash, which is the default when installing Git on Windows with msysGit, auto-completion should be preconfigured.

Press the Tab key when you’re writing a Git command, and it should return a set of suggestions for you to pick from:

	$ git co<tab><tab>
	commit config

In this case, typing git co and then pressing the Tab key twice suggests commit and config. Adding `m<tab>` completes `git commit` automatically.
	
This also works with options, which is probably more useful. For instance, if you’re running a `git log` command and can’t remember one of the options, you can start typing it and press Tab to see what matches:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

That’s a pretty nice trick and may save you some time and documentation reading.

### Git Aliases ###

Git doesn’t infer your command if you type it in partially. If you don’t want to type the entire text of each of the Git commands, you can easily set up an alias for each command using `git config`. Here are a couple of examples you may want to set up:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

This means that, for example, instead of typing `git commit`, you just need to type `git ci`. As you go on using Git, you’ll probably use other commands frequently as well; in this case, don’t hesitate to create new aliases.

This technique can also be very useful in creating commands that you think should exist. For example, to correct the usability problem you encountered with unstaging a file, you can add your own unstage alias to Git:

	$ git config --global alias.unstage 'reset HEAD --'

This makes the following two commands equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

This seems a bit clearer. It’s also common to add a `last` command, like this:

	$ git config --global alias.last 'log -1 HEAD'

This way, you can see the last commit easily:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

As you can tell, Git simply replaces the new command with whatever you alias it for. However, maybe you want to run an external command, rather than a Git subcommand. In that case, you start the command with a `!` character. This is useful if you write your own tools that work with a Git repository. We can demonstrate by aliasing `git visual` to run `gitk`:

	$ git config --global alias.visual "!gitk"

## Summary ##

At this point, you can do all the basic local Git operations — creating or cloning a repository, making changes, staging and committing those changes, and viewing the history of all the changes the repository has been through. Next, we’ll cover Git’s killer feature: its branching model.
