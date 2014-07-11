# Git の基本 #

Git を使い始めるにあたってどれかひとつの章だけしか読めないとしたら、読むべきは本章です。この章では、あなたが実際に Git を使う際に必要となる基本コマンドをすべて取り上げています。本章を最後まで読めば、リポジトリの設定や初期化、ファイルの追跡、そして変更内容のステージやコミットなどができるようになるでしょう。また、Git で特定のファイル (あるいは特定のファイルパターン) を無視させる方法やミスを簡単に取り消す方法、プロジェクトの歴史や各コミットの変更内容を見る方法、リモートリポジトリとの間でのプッシュやプルを行う方法についても説明します。

## Git リポジトリの取得 ##

Git プロジェクトを取得するには、大きく二通りの方法があります。ひとつは既存のプロジェクトやディレクトリを Git にインポートする方法、そしてもうひとつは既存の Git リポジトリを別のサーバーからクローンする方法です。

### 既存のディレクトリでのリポジトリの初期化 ###

既存のプロジェクトを Git で管理し始めるときは、そのプロジェクトのディレクトリに移動して次のように打ち込みます。

	$ git init

これを実行すると `.git` という名前の新しいサブディレクトリが作られ、リポジトリに必要なすべてのファイル (Git リポジトリのスケルトン) がその中に格納されます。この時点では、まだプロジェクト内のファイルは一切管理対象になっていません (今作った `.git` ディレクトリに実際のところどんなファイルが含まれているのかについての詳細な情報は、*第 9 章* を参照ください)。

空のディレクトリではなくすでに存在するファイルのバージョン管理を始めたい場合は、まずそのファイルを監視対象に追加してから最初のコミットをすることになります。この場合は、追加したいファイルについて `git add` コマンドを実行したあとでコミットを行います。

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

これが実際のところどういう意味なのかについては後で説明します。ひとまずこの時点で、監視対象のファイルを持つ Git リポジトリができあがり最初のコミットまで済んだことになります。

### 既存のリポジトリのクローン ###

既存の Git リポジトリ (何か協力したいと思っているプロジェクトなど) のコピーを取得したい場合に使うコマンドが、`git clone` です。Subversion などの他の VCS を使っている人なら「`checkout` じゃなくて `clone` なのか」と気になることでしょう。これは重要な違いです。Git は、サーバーが保持しているデータをほぼすべてコピーするのです。そのプロジェクトのすべてのファイルのすべての歴史が、`git clone` で手元にやってきます。実際、もし仮にサーバーのディスクが壊れてしまったとしても、どこかのクライアントに残っているクローンをサーバーに戻せばクローンした時点まで復元することができます (サーバーサイドのフックなど一部の情報は失われてしまいますが、これまでのバージョン管理履歴はすべてそこに残っています。*第 4 章* で詳しく説明します)。

リポジトリをクローンするには `git clone [url]` とします。たとえば、Ruby の Git ライブラリである Grit をクローンする場合は次のようになります。

	$ git clone git://github.com/schacon/grit.git

これは、まず `grit` というディレクトリを作成してその中で `.git` ディレクトリを初期化し、リポジトリのすべてのデータを引き出し、そして最新バージョンの作業コピーをチェックアウトします。新しくできた `grit` ディレクトリに入ると、プロジェクトのファイルをごらんいただけます。もし grit ではない別の名前のディレクトリにクローンしたいのなら、コマンドラインオプションでディレクトリ名を指定します。

	$ git clone git://github.com/schacon/grit.git mygrit

このコマンドは先ほどと同じ処理をしますが、ディレクトリ名は `mygrit` となります。

Git では、さまざまな転送プロトコルを使用することができます。先ほどの例では `git://` プロトコルを使用しましたが、`http(s)://` や `user@server:/path.git` といった形式を使うこともできます。これらは SSH プロトコルを使用します。*第 4 章* で、サーバー側で準備できるすべてのアクセス方式についての利点と欠点を説明します。

## 変更内容のリポジトリへの記録 ##

これで、れっきとした Git リポジトリを準備して、そのプロジェクト内のファイルの作業コピーを取得することができました。次は、そのコピーに対して何らかの変更を行い、適当な時点で変更内容のスナップショットをリポジトリにコミットすることになります。

作業コピー内の各ファイルには *追跡されている(tracked)* ものと *追跡されてない(untracked)* ものの二通りがあることを知っておきましょう。*追跡されている* ファイルとは、直近のスナップショットに存在したファイルのことです。これらのファイルについては変更されていない(unmodified)」「変更されている(modified)」「ステージされている(staged)」の三つの状態があります。追跡されていないファイルは、そのどれでもありません。直近のスナップショットには存在せず、ステージングエリアにも存在しないファイルのことです。最初にプロジェクトをクローンした時点では、すべてのファイルは「追跡されている」かつ「変更されていない」状態となります。チェックアウトしただけで何も編集していない状態だからです。

ファイルを編集すると、Git はそれを「変更された」とみなします。直近のコミットの後で変更が加えられたからです。変更されたファイルを *ステージ* し、それをコミットする。この繰り返しです。ここまでの流れを図 2-1 にまとめました。

Insert 18333fig0201.png
図 2-1. ファイルの状態の流れ

### ファイルの状態の確認 ###

どのファイルがどの状態にあるのかを知るために主に使うツールが `git status` コマンドです。このコマンドをクローン直後に実行すると、このような結果となるでしょう。

	$ git status
	On branch master
	nothing to commit, working directory clean

これは、クリーンな作業コピーである (つまり、追跡されているファイルの中に変更されているものがない) ことを意味します。また、追跡されていないファイルも存在しません (もし追跡されていないファイルがあれば、Git はそれを表示します)。最後に、このコマンドを実行するとあなたが今どのブランチにいるのかを知ることができます。現時点では常に `master` となります。これはデフォルトであり、ここでは特に気にする必要はありません。ブランチについては次の章で詳しく説明します。

ではここで、新しいファイルをプロジェクトに追加してみましょう。シンプルに、`README` ファイルを追加してみます。それ以前に README ファイルがなかった場合、`git status` を実行すると次のように表示されます。

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)
	
	        README

	nothing added to commit but untracked files present (use "git add" to track)

出力結果の “Untracked files” 欄に `README` ファイルがあることから、このファイルが追跡されていないということがわかります。これは、Git が「前回のスナップショット (コミット) にはこのファイルが存在しなかった」とみなしたということです。明示的に指示しない限り、Git はコミット時にこのファイルを含めることはありません。自動生成されたバイナリファイルなど、コミットしたくないファイルを間違えてコミットしてしまう心配はないということです。今回は README をコミットに含めたいわけですから、まずファイルを追跡対象に含めるようにしましょう。

### 新しいファイルの追跡 ###

新しいファイルの追跡を開始するには `git add` コマンドを使用します。`README` ファイルの追跡を開始する場合はこのようになります。

	$ git add README

再び status コマンドを実行すると、`README` ファイルが追跡対象となり、ステージされていることがわかるでしょう。

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	

ステージされていると判断できるのは、“Changes to be committed” 欄に表示されているからです。ここでコミットを行うと、`git add` した時点の状態のファイルがスナップショットとして歴史に書き込まれます。先ほど `git init` をしたときに、ディレクトリ内のファイルを追跡するためにその後 `git add (ファイル)` としたことを思い出すことでしょう。`git add` コマンドには、ファイルあるいはディレクトリのパスを指定します。ディレクトリを指定した場合は、そのディレクトリ以下にあるすべてのファイルを再帰的に追加します。

### 変更したファイルのステージング ###

すでに追跡対象となっているファイルを変更してみましょう。たとえば、すでに追跡対象となっているファイル `benchmarks.rb` を変更して `status` コマンドを実行すると、結果はこのようになります。

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

`benchmarks.rb` ファイルは “Changes not staged for commit” という欄に表示されます。これは、追跡対象のファイルが作業ディレクトリ内で変更されたけれどもまだステージされていないという意味です。ステージするには `git add` コマンドを実行します (このコマンドにはいろんな意味合いがあり、新しいファイルの追跡開始・ファイルのステージング・マージ時に衝突が発生したファイルに対する「解決済み」マーク付けなどで使用します)。では、`git add` で `benchmarks.rb` をステージしてもういちど `git status` を実行してみましょう。

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

両方のファイルがステージされました。これで、次回のコミットに両方のファイルが含まれるようになります。ここで、さらに `benchmarks.rb` にちょっとした変更を加えてからコミットしたくなったとしましょう。ファイルを開いて変更を終え、コミットの準備が整いました。しかし、`git status` を実行してみると何か変です。

	$ vim benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

これはどういうことでしょう? `benchmarks.rb` が、ステージされているほうにもステージされていないほうにも登場しています。こんなことってありえるんでしょうか? 要するに、Git は「`git add` コマンドを実行した時点の状態のファイル」をステージするということです。ここでコミットをすると、実際にコミットされるのは `git add` を実行した時点の `benchmarks.rb` であり、`git commit` した時点の作業ディレクトリにある内容とは違うものになります。`git add` した後にファイルを変更した場合に、最新版のファイルをステージしなおすにはもう一度 `git add` を実行します。

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

### ファイルの無視 ###

ある種のファイルについては、Git で自動的に追加してほしくないしそもそも「追跡されていない」と表示されるのも気になる。そんなことがよくあります。たとえば、ログファイルやビルドシステムが生成するファイルなどの自動生成されるファイルがそれにあたるでしょう。そんな場合は、無視させたいファイルのパターンを並べた `.gitignore` というファイルを作成します。`.gitignore` ファイルは、たとえばこのようになります。

	$ cat .gitignore
	*.[oa]
	*~

最初の行は `.o` あるいは `.a` で終わる名前のファイル (コードをビルドする際にできるであろうオブジェクトファイルとアーカイブファイル) を無視するよう Git に伝えています。次の行で Git に無視させているのは、チルダ (`~`) で終わる名前のファイルです。Emacs をはじめとする多くのエディタが、この形式の一時ファイルを作成します。これ以外には、たとえば `log`、`tmp`、`pid` といった名前のディレクトリや自動生成されるドキュメントなどもここに含めることになるでしょう。実際に作業を始める前に `.gitignore` ファイルを準備しておくことをお勧めします。そうすれば、予期せぬファイルを間違って Git リポジトリにコミットしてしまう事故を防げます。

`.gitignore` ファイルに記述するパターンの規則は、次のようになります。

*	空行あるいは `#` で始まる行は無視される
*	標準の glob パターンを使用可能
*	ディレクトリを指定するには、パターンの最後にスラッシュ (`/`) をつける
*	パターンを逆転させるには、最初に感嘆符 (`!`) をつける

glob パターンとは、シェルで用いる簡易正規表現のようなものです。アスタリスク (`*`) は、ゼロ個以上の文字にマッチします。`[abc]` は、角括弧内の任意の文字 (この場合は `a`、`b` あるいは `c`) にマッチします。疑問符 (`?`) は一文字にマッチします。また、ハイフン区切りの文字を角括弧で囲んだ形式 (`[0-9]`) は、ふたつの文字の間の任意の文字 (この場合は 0 から 9 までの間の文字) にマッチします。

では、`.gitignore` ファイルの例をもうひとつ見てみましょう。

	# コメント。これは無視されます
	# .a ファイルは無視
	*.a
	# しかし、lib.a ファイルだけは .a であっても追跡対象とします
	!lib.a
	# ルートディレクトリの TODO ファイルだけを無視し、サブディレクトリの TODO は無視しません
	/TODO
	# build/ ディレクトリのすべてのファイルを無視します
	build/
	# doc/notes.txt は無視しますが、doc/server/arch.txt は無視しません
	doc/*.txt
	# doc/ ディレクトリの .txt ファイル全てを無視します
	doc/**/*.txt

`**/` 形式は 1.8.2 以降のGitで利用可能です｡

### ステージされている変更 / されていない変更の閲覧 ###

`git status` コマンドだけではよくわからない (どのファイルが変更されたのかだけではなく、実際にどのように変わったのかが知りたい) という場合は `git diff` コマンドを使用します。`git diff` コマンドについては後で詳しく解説します。おそらく、最もよく使う場面としては次の二つの問いに答えるときになるでしょう。「変更したけどまだステージしていない変更は?」「コミット対象としてステージした変更は?」もちろん `git status` でもこれらの質問に対するおおまかな答えは得られますが、`git diff` の場合は追加したり削除したりした正確な行をパッチ形式で表示します。

先ほどの続きで、ふたたび `README` ファイルを編集してステージし、一方 `benchmarks.rb` ファイルは編集だけしてステージしない状態にあると仮定しましょう。ここで `status` コマンドを実行すると、次のような結果となります。

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

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

次のコミットに含めるべくステージされた内容を知りたい場合は、`git diff --cached` を使用します (Git バージョン 1.6.1 以降では `git diff --staged` も使えます。こちらのほうが覚えやすいでしょう)。このコマンドは、ステージされている変更と直近のコミットの内容を比較します。

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
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

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

これを実行すると、指定したエディタが立ち上がります (シェルの `$EDITOR` 環境変数で設定されているエディタ。通常は vim あるいは emacs でしょう。しかし、それ以外にも *第 1 章* で説明した `git config --global core.editor` コマンドでお好みのエディタを指定することもできます)。

エディタには次のようなテキストが表示されています (これは Vim の画面の例です)。

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#       new file:   README
	#       modified:   benchmarks.rb
	#
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

デフォルトのコミットメッセージとして、直近の `git status` コマンドの結果がコメントアウトして表示され、先頭に空行があることがわかるでしょう。このコメントを消して自分でコミットメッセージを書き入れていくこともできますし、何をコミットしようとしているのかの確認のためにそのまま残しておいてもかまいません (何を変更したのかをより明確に知りたい場合は、`git commit` に `-v` オプションを指定します。そうすると、diff の内容がエディタに表示されるので何を行ったのかが正確にわかるようになります)。エディタを終了させると、Git はそのメッセージつきのコミットを作成します (コメントおよび diff は削除されます)。

あるいは、コミットメッセージをインラインで記述することもできます。その場合は、`commit` コマンドの後で `-m` フラグに続けて次のように記述します。

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Story 182: Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

これではじめてのコミットができました! 今回のコミットについて、「どのブランチにコミットしたのか (`master`)」「そのコミットの SHA-1 チェックサム (`463dc4f`)」「変更されたファイルの数」「そのコミットで追加されたり削除されたりした行数」といった情報が表示されているのがわかるでしょう。

コミットが記録するのは、ステージングエリアのスナップショットであることを覚えておきましょう。ステージしていない情報については変更された状態のまま残っています。別のコミットで歴史にそれを書き加えるには、改めて add する必要があります。コミットするたびにプロジェクトのスナップショットが記録され、あとからそれを取り消したり参照したりできるようになります。

### ステージングエリアの省略 ###

コミットの内容を思い通りに作り上げることができるという点でステージングエリアは非常に便利なのですが、普段の作業においては必要以上に複雑に感じられることもあるでしょう。ステージングエリアを省略したい場合のために、Git ではシンプルなショートカットを用意しています。`git commit` コマンドに `-a` オプションを指定すると、追跡対象となっているファイルを自動的にステージしてからコミットを行います。つまり `git add` を省略できるというわけです。

	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	
	no changes added to commit (use "git add" and/or "git commit -a")
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+)

この場合、コミットする前に `benchmarks.rb` を `git add` する必要がないことに注意しましょう。

### ファイルの削除 ###

ファイルを Git から削除するには、追跡対象からはずし (より正確に言うとステージングエリアから削除し)、そしてコミットします。`git rm` コマンドは、この作業を行い、そして作業ディレクトリからファイルを削除します。つまり、追跡されていないファイルとして残り続けることはありません。

単に作業ディレクトリからファイルを削除しただけの場合は、`git status` の出力の中では “Changes not staged for commit” (つまり _ステージされていない_) 欄に表示されます。

	$ rm grit.gemspec
	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add/rm <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        deleted:    grit.gemspec
	
	no changes added to commit (use "git add" and/or "git commit -a")

`git rm` を実行すると、ファイルの削除がステージされます。

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        deleted:    grit.gemspec
	

次にコミットするときにファイルが削除され、追跡対象外となります。変更したファイルをすでにステージしている場合は、`-f` オプションで強制的に削除しなければなりません。まだスナップショットに記録されていないファイルを誤って削除してしまうと Git で復旧することができなくなってしまうので、それを防ぐための安全装置です。

ほかに「こんなことできたらいいな」と思われるであろう機能として、ファイル自体は作業ツリーに残しつつステージングエリアからの削除だけを行うこともできます。つまり、ハードディスク上にはファイルを残しておきたいけれど、もう Git では追跡させたくないというような場合のことです。これが特に便利なのは、`.gitignore` ファイルに書き足すのを忘れたために巨大なログファイルや大量の `.a` ファイルがステージされてしまったなどというときです。そんな場合は `--cached` オプションを使用します。

	$ git rm --cached readme.txt

ファイル名やディレクトリ名、そしてファイル glob パターンを `git rm` コマンドに渡すことができます。つまり、このようなこともできるということです。

	$ git rm log/\*.log

`*` の前にバックスラッシュ (`\`) があることに注意しましょう。これが必要なのは、シェルによるファイル名の展開だけでなく Git が自前でファイル名の展開を行うからです。ただしWindowsのコマンドプロンプトの場合は､バックスラッシュは取り除かなければなりません｡このコマンドは、`log/` ディレクトリにある拡張子 `.log` のファイルをすべて削除します。あるいは、このような書き方もできます。

	$ git rm \*~

このコマンドは、`~` で終わるファイル名のファイルをすべて削除します。

### ファイルの移動 ###

他の多くの VCS とは異なり、Git はファイルの移動を明示的に追跡することはありません。Git の中でファイル名を変更しても、「ファイル名を変更した」というメタデータは Git には保存されないのです。しかし Git は賢いので、ファイル名が変わったことを知ることができます。ファイルの移動を検出する仕組みについては後ほど説明します。

しかし Git には `mv` コマンドがあります。ちょっと混乱するかもしれませんね。Git の中でファイル名を変更したい場合は次のようなコマンドを実行します。

	$ git mv file_from file_to

このようなコマンドを実行してから status を確認すると、Git はそれをファイル名が変更されたと解釈していることがわかるでしょう。

	$ git mv README.txt README
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        renamed:    README.txt -> README
	

しかし、実際のところこれは、次のようなコマンドを実行するのと同じ意味となります。

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git はこれが暗黙的なファイル名の変更であると理解するので、この方法であろうが `mv` コマンドを使おうがどちらでもかまいません。唯一の違いは、この方法だと 3 つのコマンドが必要になるかわりに `mv` だとひとつのコマンドだけで実行できるという点です。より重要なのは、ファイル名の変更は何でもお好みのツールで行えるということです。あとでコミットする前に add/rm を指示してやればいいのです。

## コミット履歴の閲覧 ##

何度かコミットを繰り返すと、あるいはコミット履歴つきの既存のリポジトリをクローンすると、過去に何が起こったのかを振り返りたくなることでしょう。そのために使用するもっとも基本的かつパワフルな道具が `git log` コマンドです。

ここからの例では、`simplegit` という非常にシンプルなプロジェクトを使用します。これは、私が説明用によく用いているプロジェクトで、次のようにして取得できます。

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

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,5 +5,5 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	     s.name      =   "simplegit"
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"
	     s.email     =   "schacon@gee-mail.com

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

このオプションは、先ほどと同じ情報を表示するとともに、各エントリの直後にその diff を表示します。これはコードレビューのときに非常に便利です。また、他のメンバーが一連のコミットで何を行ったのかをざっと眺めるのにも便利でしょう。

コードレビューの際､行単位ではなく単語単位でレビューするほうが容易な場合もあるでしょう｡`git log -p` コマンドのオプション `--word-diff` を使えば､通常の行単位diffではなく､単語単位のdiffを表示させることができます｡単語単位のdiffはソースコードのレビューに用いても役に立ちませんが､書籍や論文など､長文テキストファイルのレビューを行う際は便利です｡こんな風に使用します｡

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

ご覧のとおり､通常のdiffにある｢追加行や削除行の表示｣はありません｡その代わりに､変更点はインラインで表示されることになります｡追加された単語は `{+ +}` で､削除された単語は `[- -]` で囲まれます｡また､着目すべき点が行ではなく単語なので､diffの出力を通常の｢変更行前後3行ずつ｣から｢変更行前後1行ずつ｣に減らしたほうがよいかもしれません｡上記の例で使用した `-U1` オプションを使えば行数を減らせます｡

また、`git log` では「まとめ」系のオプションを使うこともできます。たとえば、各コミットに関するちょっとした統計情報を見たい場合は `--stat` オプションを使用します。

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 file changed, 1 insertion(+), 1 deletion(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 file changed, 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+)

ごらんの通り `--stat` オプションは、各コミットエントリに続けて変更されたファイルの一覧と変更されたファイルの数、追加・削除された行数が表示されます。また、それらの情報のまとめを最後に出力します。もうひとつの便利なオプションが `--pretty` です。これは、ログをデフォルトの書式以外で出力します。あらかじめ用意されているいくつかのオプションを指定することができます。`oneline` オプションは、各コミットを一行で出力します。これは、大量のコミットを見る場合に便利です。さらに `short` や `full` そして `fuller` といったオプションもあり、これは標準とほぼ同じ書式だけれども情報量がそれぞれ少なめあるいは多めになります。

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

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	オプション	出力される内容
	%H	コミットのハッシュ
	%h	コミットのハッシュ (短縮版)
	%T	ツリーのハッシュ
	%t	ツリーのハッシュ (短縮版)
	%P	親のハッシュ
	%p	親のハッシュ (短縮版)
	%an	Author の名前
	%ae	Author のメールアドレス
	%ad	Author の日付 (--date= オプションに従った形式)
	%ar	Author の相対日付
	%cn	Committer の名前
	%ce	Committer のメールアドレス
	%cd	Committer の日付
	%cr	Committer の相対日付
	%s	件名

_author_ と _committer_ は何が違うのか気になる方もいるでしょう。_author_ とはその作業をもともと行った人、_committer_ とはその作業を適用した人のことを指します。あなたがとあるプロジェクトにパッチを送り、コアメンバーのだれかがそのパッチを適用したとしましょう。この場合、両方がクレジットされます (あなたが author、コアメンバーが committer です)。この区別については *第 5 章* でもう少し詳しく説明します。

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

これらは `git log` の出力フォーマット指定のほんの一部でしかありません。まだまだオプションはあります。表 2-2 に、今まで取り上げたオプションとそれ以外によく使われるオプション、そしてそれぞれが`log`の出力をどのように変えるのかをまとめました。

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	オプション	説明
	-p	各コミットのパッチを表示する
	--word-diff	変更点を単語単位で表示する
	--stat	各コミットで変更されたファイルの統計情報を表示する
	--shortstat	--stat コマンドのうち、変更/追加/削除 の行だけを表示する
	--name-only	コミット情報の後に変更されたファイルの一覧を表示する
	--name-status	変更されたファイルと 追加/修正/削除 情報を表示する
	--abbrev-commit	SHA-1 チェックサムの全体 (40文字) ではなく最初の数文字のみを表示する
	--relative-date	完全な日付フォーマットではなく、相対フォーマット (“2 weeks ago” など) で日付を表示する
	--graph	ブランチやマージの歴史を、ログ出力とともにアスキーグラフで表示する
	--pretty	コミットを別のフォーマットで表示する。オプションとして oneline, short, full, fuller そして format (独自フォーマットを設定する) を指定可能
	--oneline	`--pretty=oneline --abbrev-commit`と同じ意味の便利なオプション

### ログ出力の制限 ###

出力のフォーマット用オプションだけでなく、 `git log` にはログの制限用の便利なオプションもあります。コミットの一部だけを表示するようなオプションのことです。既にひとつだけ紹介していますね。`-2` オプション、これは直近のふたつのコミットだけを表示するものです。実は `-<n>` の `n` には任意の整数値を指定することができ、直近の `n` 件のコミットだけを表示させることができます。ただ、実際のところはこれを使うことはあまりないでしょう。というのも、Git はデフォルトですべての出力をページャにパイプするので、ログを一度に 1 ページだけ見ることになるからです。

しかし `--since` や `--until` のような時間制限のオプションは非常に便利です。たとえばこのコマンドは、過去二週間のコミットの一覧を取得します。

	$ git log --since=2.weeks

このコマンドはさまざまな書式で動作します。特定の日を指定する (“2008-01-15”) こともできますし、相対日付を“2 years 1 day 3 minutes ago”のように指定することも可能です。

コミット一覧から検索条件にマッチするものだけを取り出すこともできます。`--author` オプションは特定の author のみを抜き出し、`--grep` オプションはコミットメッセージの中のキーワードを検索します (author と grep を両方指定すると、両方にマッチするものだけが対象になります)。

grep を複数指定したい場合は、`--all-match` を追加しないといけません。そうしないと、どちらか一方にだけマッチするものも対象になってしまいます。

最後に紹介する `git log` のフィルタリング用オプションは、パスです。ディレクトリ名あるいはファイル名を指定すると、それを変更したコミットのみが対象となります。このオプションは常に最後に指定し、一般にダブルダッシュ (`--`) の後に記述します。このダブルダッシュが他のオプションとパスの区切りとなります。

表 2-3 に、これらのオプションとその他の一般的なオプションをまとめました。

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	オプション	説明
	-(n)	直近の n 件のコミットのみを表示する
	--since, --after	指定した日付/時刻以降のCommitDateのコミットのみに制限する
	--until, --before	指定した日付/時刻以前のCommitDateのコミットのみに制限する
	--author	エントリが指定した文字列にマッチするコミットのみを表示する
	--committer	エントリが指定した文字列にマッチするコミットのみを表示する

### 日時にもとづくログ出力の制限 ###

Git のリポジトリ(git://git.kernel.org/pub/scm/git/git.git)からCommitDateを使ってコミットを検索してみましょう。パソコンに設定されたタイムゾーンにおける2014/04/29のコミットを検索するには、以下のコマンドを実行します。

    $ git log --after="2014-04-29 00:00:00" --before="2014-04-29 23:59:59" \
      --pretty=fuller

この場合、コマンドの結果はパソコンのタイムゾーン設定ごとに異なってしまいます。それを避けるには、タイムゾーンを含むISO 8601フォーマットのような日時を `--after` や `--before` の引数に指定するといいでしょう。そうすれば、上述のケースのようにコマンド実行結果が異なる可能性がなくなります。

特定日時(例として、中央ヨーロッパ時間で2013/04/29 17:07:22)を指定してコミットを検索するには、以下のコマンドを使います。

    $ git log  --after="2013-04-29T17:07:22+0200"      \
              --before="2013-04-29T17:07:22+0200" --pretty=fuller
    
    commit de7c201a10857e5d424dbd8db880a6f24ba250f9
    Author:     Ramkumar Ramachandra <artagnon@gmail.com>
    AuthorDate: Mon Apr 29 18:19:37 2013 +0530
    Commit:     Junio C Hamano <gitster@pobox.com>
    CommitDate: Mon Apr 29 08:07:22 2013 -0700
    
        git-completion.bash: lexical sorting for diff.statGraphWidth
        
        df44483a (diff --stat: add config option to limit graph width,
        2012-03-01) added the option diff.startGraphWidth to the list of
        configuration variables in git-completion.bash, but failed to notice
        that the list is sorted alphabetically.  Move it to its rightful place
        in the list.
        
        Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
        Signed-off-by: Junio C Hamano <gitster@pobox.com>

これらの日時(`AuthorDate` と `CommitDate`)はGitのデフォルトフォーマット(`--date=default` オプション相当)です。作者とコミッター、それぞれのタイムゾーン情報を表示します。

日時フォーマットの指定は他にも `--date=iso` (ISO 8601)、`--date=rfc` (RFC 2822)、`--date=raw` (Unix時間)、`--date=local` (端末のタイムゾーン)、`--date=relative`("2 hours ago"のように相対的な指定)などがあります。

また、 `git log` 実行時に日時指定を省略すると、パソコンの時計をもとにコマンド実行日時を指定日時として使用します(協定標準時からの時差も同一になります)。

具体的には、仮にパソコンの時計が09:00を指していて、かつタイムゾーン設定が協定標準時プラス3時間の場合、以下の `git log` コマンドの日時指定は同一として扱われます。

    $ git log --after=2008-06-01 --before=2008-07-01
    $ git log --after="2008-06-01T09:00:00+0300" \
        --before="2008-07-01T09:00:00+0300"

もう一つ例を挙げておきましょう。Git ソースツリーのテストファイルに対する変更があったコミットのうち、Junio Hamano がコミットしたもの (マージは除く) で 2008 年 10 月(ニューヨークのタイムゾーン)に行われたものを知りたければ次のように指定します。

	$ git log --pretty="%h - %s" --author=gitster \
	   --after="2008-10-01T00:00:00-0400"         \
	  --before="2008-10-31T23:59:59-0400" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

約 36,000 件におよぶ Git ソースコードのコミットの歴史の中で、このコマンドの条件にマッチするのは 6 件となります。

### GUI による歴史の可視化 ###

もう少しグラフィカルなツールでコミットの歴史を見たい場合は、Tcl/Tk のプログラムである `gitk` を見てみましょう。これは Git に同梱されています。gitk は、簡単に言うとビジュアルな `git log` ツールです。`git log` で使えるフィルタリングオプションにはほぼすべて対応しています。プロジェクトのコマンドラインで `gitk` と打ち込むと、図 2-2 のような画面があらわれるでしょう。

Insert 18333fig0202.png
図 2-2. gitk history visualizer

ウィンドウの上半分に、コミットの歴史がきれいな家系図とともに表示されます。ウィンドウの下半分には diff ビューアがあり、任意のコミットをクリックしてその変更内容を確認することができます。

## 作業のやり直し ##

どんな場面であっても、何かをやり直したくなることはあります。ここでは、行った変更を取り消すための基本的なツールについて説明します。注意点は、ここで扱う内容の中には「やり直しの取り消し」ができないものもあるということです。Git で何か間違えたときに作業内容を失ってしまう数少ない例がここにあります。

### 直近のコミットの変更 ###

やり直しを行う場面としてもっともよくあるのは、「コミットを早まりすぎて追加すべきファイルを忘れてしまった」「コミットメッセージが変になってしまった」などです。そのコミットをもう一度やりなおす場合は、`--amend` オプションをつけてもう一度コミットします。

	$ git commit --amend

このコマンドは、ステージングエリアの内容をコミットに使用します。直近のコミット以降に何も変更をしていない場合 (たとえば、コミットの直後にこのコマンドを実行したような場合)、スナップショットの内容はまったく同じでありコミットメッセージを変更することになります。

コミットメッセージのエディタが同じように立ち上がりますが、既に前回のコミット時のメッセージが書き込まれた状態になっています。ふだんと同様にメッセージを編集できますが、前回のコミット時のメッセージがその内容で上書きされます。

たとえば、いったんコミットした後、何かのファイルをステージするのを忘れていたのに気づいたとしましょう。そんな場合はこのようにします。

	$ git commit -m '初期コミット'
	$ git add 忘れてたファイル
	$ git commit --amend

これら 3 つのコマンドの実行後、最終的にできあがるのはひとつのコミットです。二番目のコミットが、最初のコミットの結果を上書きするのです。

### ステージしたファイルの取り消し ###

続くふたつのセクションでは、ステージングエリアと作業ディレクトリの変更に関する作業を扱います。すばらしいことに、これらふたつの場所の状態を表示するコマンドを使用すると、変更内容を取り消す方法も同時に表示されます。たとえば、ふたつのファイルを変更し、それぞれを別のコミットとするつもりだったのに間違えて `git add *` と打ち込んでしまったときのことを考えましょう。ファイルが両方ともステージされてしまいました。ふたつのうちの一方だけのステージを解除するにはどうすればいいでしょう? `git status` コマンドが教えてくれます。

	$ git add .
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	        modified:   benchmarks.rb
	

“Changes to be committed” の直後に、"use `git reset HEAD <file>...` to unstage" と書かれています。では、アドバイスに従って `benchmarks.rb` ファイルのステージを解除してみましょう。

	$ git reset HEAD benchmarks.rb
	Unstaged changes after reset:
	M       benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

ちょっと奇妙に見えるコマンドですが、きちんと動作します。`benchmarks.rb` ファイルは、変更されたもののステージされていない状態に戻りました。

### ファイルへの変更の取り消し ###

`benchmarks.rb` に加えた変更が、実は不要なものだったとしたらどうしますか? 変更を取り消す (直近のコミット時点の状態、あるいは最初にクローンしたり最初に作業ディレクトリに取得したときの状態に戻す) 最も簡単な方法は? 幸いなことに、またもや `git status` がその方法を教えてくれます。先ほどの例の出力結果で、ステージされていないファイル一覧の部分を見てみましょう。

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

とても明確に、変更を取り消す方法が書かれています (少なくとも、バージョン 1.6.1 以降の新しい Git ではこのようになります。もし古いバージョンを使用しているのなら、アップグレードしてこのすばらしい機能を活用することをおすすめします)。ではそのとおりにしてみましょう。

	$ git checkout -- benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	

変更が取り消されたことがわかります。また、これが危険なコマンドであることも知っておかねばなりません。あなたがファイルに加えた変更はすべて消えてしまいます。変更した内容を、別のファイルで上書きしたのと同じことになります。そのファイルが不要であることが確実にわかっているとき以外は、このコマンドを使わないようにしましょう。単にファイルを片付けたいだけなら、次の章で説明する stash やブランチを調べてみましょう。一般にこちらのほうがおすすめの方法です。

Git にコミットした内容のすべては、ほぼ常に取り消しが可能であることを覚えておきましょう。削除したブランチへのコミットや `--amend` コミットで上書きされた元のコミットでさえも復旧することができます (データの復元方法については *第 9 章* を参照ください)。しかし、まだコミットしていない内容を失ってしまうと、それは二度と取り戻せません。

## リモートでの作業 ##

Git を使ったプロジェクトで共同作業を進めていくには、リモートリポジトリの扱い方を知る必要があります。リモートリポジトリとは、インターネット上あるいはその他ネットワーク上のどこかに存在するプロジェクトのことです。複数のリモートリポジトリを持つこともできますし、それぞれを読み込み専用にしたり読み書き可能にしたりすることもできます。他のメンバーと共同作業を進めていくにあたっては、これらのリモートリポジトリを管理し、必要に応じてデータのプル・プッシュを行うことで作業を分担していくことになります。リモートリポジトリの管理には「リモートリポジトリの追加」「不要になったリモートリポジトリの削除」「リモートブランチの管理や追跡対象/追跡対象外の設定」などさまざまな作業が含まれます。このセクションでは、これらの作業について説明します。

### リモートの表示 ###

今までにどのリモートサーバーを設定したのかを知るには `git remote` コマンドを実行します。これは、今までに設定したリモートハンドルの名前を一覧表示します。リポジトリをクローンしたのなら、少なくとも *origin* という名前が見えるはずです。これは、クローン元のサーバーに対して Git がデフォルトでつける名前です。

	$ git clone git://github.com/schacon/ticgit.git
	Cloning into 'ticgit'...
	remote: Reusing existing pack: 1857, done.
	remote: Total 1857 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (1857/1857), 374.35 KiB | 193.00 KiB/s, done.
	Resolving deltas: 100% (772/772), done.
	Checking connectivity... done.
	$ cd ticgit
	$ git remote
	origin

`-v` を指定すると、その名前に対応する URL を表示します。

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

複数のリモートを設定している場合は、このコマンドはそれをすべて表示します。たとえば、私の Grit リポジトリの場合はこのようになっています。

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

つまり、これらのユーザーによる変更を容易にプルして取り込めるということです。ここで、origin リモートだけが SSH の URL であることに注目しましょう。私がプッシュできるのは origin だけだということになります (なぜそうなるのかについては *第 4 章* で説明します)。

### リモートリポジトリの追加 ###

これまでのセクションでも何度かリモートリポジトリの追加を行ってきましたが、ここで改めてその方法をきちんと説明しておきます。新しいリモート Git リポジトリにアクセスしやすいような名前をつけて追加するには、`git remote add [shortname] [url]` を実行します。

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

これで、コマンドラインに URL を全部打ち込むかわりに `pb` という文字列を指定するだけでよくなりました。たとえば、Paul が持つ情報の中で自分のリポジトリにまだ存在しないものをすべて取得するには、`git fetch pb` を実行すればよいのです。

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul の master ブランチは、ローカルでは `pb/master` としてアクセスできます。これを自分のブランチにマージしたり、ローカルブランチとしてチェックアウトして中身を調べたりといったことが可能となります。

### リモートからのフェッチ、そしてプル ###

ごらんいただいたように、データをリモートリポジトリから取得するには次のコマンドを実行します。

	$ git fetch [remote-name]

このコマンドは、リモートプロジェクトのすべてのデータの中からまだあなたが持っていないものを引き出します。実行後は、リモートにあるすべてのブランチを参照できるようになり、いつでもそれをマージしたり中身を調べたりすることが可能となります (ブランチとは何なのか、どのように使うのかについては、*第 3 章* でより詳しく説明します)。

リポジトリをクローンしたときには、リモートリポジトリに対して自動的に *origin* という名前がつけられます。つまり、`git fetch origin` とすると、クローンしたとき (あるいは直近でフェッチを実行したとき) 以降にサーバーにプッシュされた変更をすべて取得することができます。ひとつ注意すべき点は、`fetch` コマンドはデータをローカルリポジトリに引き出すだけだということです。ローカルの環境にマージされたり作業中の内容を書き換えたりすることはありません。したがって、必要に応じて自分でマージをする必要があります。

リモートブランチを追跡するためのブランチを作成すれば (次のセクションと *第 3 章* で詳しく説明します)、`git pull` コマンドを使うことができます。これは、自動的にフェッチを行い、リモートブランチの内容を現在のブランチにマージします。おそらくこのほうが、よりお手軽で使いやすいことでしょう。またデフォルトで、`git clone` コマンドはローカルの master ブランチが (取得元サーバー上の) リモートの master ブランチを追跡するよう自動設定します (リモートに master ブランチが存在することを前提としています)。`git pull` を実行すると、通常は最初にクローンしたサーバーからデータを取得し、現在作業中のコードへのマージを試みます。

### リモートへのプッシュ ###

あなたのプロジェクトがみんなと共有できる状態に達したら、それを上流にプッシュしなければなりません。そのためのコマンドが `git push [remote-name] [branch-name]` です。master ブランチの内容を `origin` サーバー (何度も言いますが、クローンした時点でこのブランチ名とサーバー名が自動設定されます) にプッシュしたい場合は、このように実行します。

	$ git push origin master

このコマンドが動作するのは、自分が書き込みアクセス権を持つサーバーからクローンし、かつその後だれもそのサーバーにプッシュしていない場合のみです。あなた以外の誰かが同じサーバーからクローンし、誰かが上流にプッシュした後で自分がプッシュしようとすると、それは拒否されます。拒否された場合は、まず誰かがプッシュした作業内容を引き出してきてローカル環境で調整してからでないとプッシュできません。リモートサーバーへのプッシュ方法の詳細については *第 3 章* を参照ください。

### リモートの調査 ###

特定のリモートの情報をより詳しく知りたい場合は `git remote show [remote-name]` コマンドを実行します。たとえば `origin` のように名前を指定すると、このような結果が得られます。

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

リモートリポジトリの URL と、追跡対象になっているブランチの情報が表示されます。また、ご丁寧にも「master ブランチ上で `git pull` すると、リモートの情報を取得した後で自動的にリモートの master ブランチの内容をマージする」という説明があります。また、引き出してきたすべてのリモート情報も一覧表示されます。

Git をもっと使い込むようになると、`git remote show` で得られる情報はどんどん増えていきます。たとえば次のような結果を得ることになるかもしれません。

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

このコマンドは、特定のブランチ上で `git push` したときにどのブランチに自動プッシュされるのかを表示しています。また、サーバー上のリモートブランチのうちまだ手元に持っていないもの、手元にあるブランチのうちすでにサーバー上では削除されているもの、`git pull` を実行したときに自動的にマージされるブランチなども表示されています。

### リモートの削除・リネーム ###

リモートを参照する名前を変更したい場合、新しいバージョンの Git では `git remote rename` を使うことができます。たとえば `pb` を `paul` に変更したい場合は `git remote rename` をこのように実行します。

	$ git remote rename pb paul
	$ git remote
	origin
	paul

これは、リモートブランチ名も変更することを付け加えておきましょう。これまで `pb/master` として参照していたブランチは、これからは `paul/master` となります。

何らかの理由でリモートの参照を削除したい場合 (サーバーを移動したとか特定のミラーを使わなくなったとか、あるいはプロジェクトからメンバーが抜けたとかいった場合) は `git remote rm` を使用します。

	$ git remote rm paul
	$ git remote
	origin

## タグ ##

多くの VCS と同様に Git にもタグ機能があり、歴史上の重要なポイントに印をつけることができます。一般に、この機能は (`v 1.0` など) リリースポイントとして使われています。このセクションでは、既存のタグ一覧の取得や新しいタグの作成、さまざまなタグの形式などについて扱います。

### タグの一覧表示 ###

Git で既存のタグの一覧を表示するのは簡単で、単に `git tag` と打ち込むだけです。

	$ git tag
	v0.1
	v1.3

このコマンドは、タグをアルファベット順に表示します。この表示順に深い意味はありません。

パターンを指定してタグを検索することもできます。Git のソースリポジトリを例にとると、240 以上のタグが登録されています。その中で 1.4.2 系のタグのみを見たい場合は、このようにします。

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### タグの作成 ###

Git のタグには、軽量 (lightweight) 版と注釈付き (annotated) 版の二通りがあります。軽量版のタグは、変更のないブランチのようなものです。特定のコミットに対する単なるポインタでしかありません。しかし注釈付きのタグは、Git データベース内に完全なオブジェクトとして格納されます。チェックサムが付き、タグを作成した人の名前・メールアドレス・作成日時・タグ付け時のメッセージなども含まれます。また、署名をつけて GNU Privacy Guard (GPG) で検証することもできます。一般的には、これらの情報を含められる注釈付きのタグを使うことをおすすめします。しかし、一時的に使うだけのタグである場合や何らかの理由で情報を含めたくない場合は、軽量版のタグも使用可能です。

### 注釈付きのタグ ###

Git では、注釈付きのタグをシンプルな方法で作成できます。もっとも簡単な方法は、`tag` コマンドの実行時に `-a` を指定することです。

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

`-m` で、タグ付け時のメッセージを指定します。これはタグとともに格納されます。注釈付きタグの作成時にメッセージを省略すると、エディタが立ち上がるのでそこでメッセージを記入します。

タグのデータとそれに関連づけられたコミットを見るには `git show` コマンドを使用します。

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

タグ付けした人の情報とその日時、そして注釈メッセージを表示したあとにコミットの情報が続きます。

### 署名付きのタグ ###

GPG 秘密鍵を持っていれば、タグに署名をすることができます。その場合は `-a` の代わりに `-s` を指定すればいいだけです。

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

このタグに対して `git show` を実行すると、あなたの GPG 署名が表示されます。

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

タグの署名を検証する方法については後ほど説明します。

### 軽量版のタグ ###

コミットにタグをつけるもうひとつの方法が、軽量版のタグです。これは基本的に、コミットのチェックサムだけを保持するもので、それ以外の情報は含まれません。軽量版のタグを作成するには `-a`、`-s` あるいは `-m` といったオプションをつけずにコマンドを実行します。

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

このタグに対して `git show` を実行しても、先ほどのような追加情報は表示されません。単に、対応するコミットの情報を表示するだけです。

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### タグの検証 ###

署名付きのタグを検証するには `git tag -v [tag-name]` を使用します。このコマンドは、GPG を使って署名を検証します。これを正しく実行するには、署名者の公開鍵があなたの鍵リングに含まれている必要があります。

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

署名者の公開鍵を持っていない場合は、このようなメッセージが表示されます。

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### 後からのタグ付け ###

過去にさかのぼってコミットにタグ付けすることもできます。仮にあなたのコミットの歴史が次のようなものであったとしましょう。

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

今になって、このプロジェクトに `v1.2` のタグをつけるのを忘れていたことに気づきました。本来なら "updated rakefile" のコミットにつけておくべきだったものです。しかし今からでも遅くありません。特定のコミットにタグをつけるには、そのコミットのチェックサム (あるいはその一部) をコマンドの最後に指定します。

	$ git tag -a v1.2 -m 'version 1.2' 9fceb02

これで、そのコミットにタグがつけられたことが確認できます。

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

### タグの共有 ###

デフォルトでは、`git push` コマンドはタグ情報をリモートに送りません。タグを作ったら、タグをリモートサーバーにプッシュするよう明示する必要があります。その方法は、リモートブランチを共有するときと似ています。`git push origin [tagname]` を実行するのです。

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

多くのタグを一度にプッシュしたい場合は、`git push` コマンドのオプション `--tags` を使用します。これは、手元にあるタグのうちまだリモートサーバーに存在しないものをすべて転送します。

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

これで、誰か他の人がリポジトリのクローンやプルを行ったときにすべてのタグを取得できるようになりました。

## ヒントと裏技 ##

Git の基本を説明した本章を終える前に、ほんの少しだけヒントと裏技を披露しましょう。これを知っておけば、Git をよりシンプルかつお手軽に使えるようになり、Git になじみやすくなることでしょう。ほとんどの人はこれらのことを知らずに Git を使っています。別にどうでもいいことですし本書の後半でこれらの技を使うわけでもないのですが、その方法ぐらいは知っておいたほうがよいでしょう。

### 自動補完 ###

Bash シェルを使っているのなら、Git にはよくできた自動補完スクリプトが付属しています。Git のソースコードをダウンロードし、`contrib/completion` ディレクトリを見てみましょう。`git-completion.bash` というファイルがあるはずです。このファイルをホームディレクトリにコピーし、それを `.bashrc` ファイルに追加しましょう。

	source ~/.git-completion.bash

すべてのユーザーに対して Git 用の Bash シェル補完を使わせたい場合は、Mac なら `/opt/local/etc/bash_completion.d` ディレクトリ、Linux 系なら `/etc/bash_completion.d/` ディレクトリにこのスクリプトをコピーします。Bash は、これらのディレクトリにあるスクリプトを自動的に読み込んでシェル補完を行います。

Windows で Git Bash を使用している人は、msysGit で Windows 版 Git をインストールした際にデフォルトでこの機能が有効になっています。

Git コマンドの入力中にタブキーを押せば、補完候補があらわれて選択できるようになります。

	$ git co<tab><tab>
	commit config

ここでは、`git co` と打ち込んだ後にタブキーを二度押してみました。すると commit と config という候補があらわれました。さらに `m<tab>` と入力すると、自動的に `git commit` と補完されます。

これは、コマンドのオプションに対しても機能します。おそらくこっちのほうがより有用でしょう。たとえば、`git log` を実行しようとしてそのオプションを思い出せなかった場合、タブキーを押せばどんなオプションを使えるのかがわかります。

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

この裏技を使えば、ドキュメントを調べる時間を節約できることでしょう。

### Git エイリアス ###

Git は、コマンドの一部だけが入力された状態でそのコマンドを推測することはありません。Git の各コマンドをいちいち全部入力するのがいやなら、`git config` でコマンドのエイリアスを設定することができます。たとえばこんなふうに設定すると便利かもしれません。

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

こうすると、たとえば `git commit` と同じことが単に `git ci` と入力するだけでできるようになります。Git を使い続けるにつれて、よく使うコマンドがさらに増えてくることでしょう。そんな場合は、きにせずどんどん新しいエイリアスを作りましょう。

このテクニックは、「こんなことできたらいいな」というコマンドを作る際にも便利です。たとえば、ステージを解除するときにどうしたらいいかいつも迷うという人なら、こんなふうに自分で unstage エイリアスを追加してしまえばいいのです。

	$ git config --global alias.unstage 'reset HEAD --'

こうすれば、次のふたつのコマンドが同じ意味となります。

	$ git unstage fileA
	$ git reset HEAD fileA

少しはわかりやすくなりましたね。あるいは、こんなふうに `last` コマンドを追加することもできます。

	$ git config --global alias.last 'log -1 HEAD'

こうすれば、直近のコミットの情報を見ることができます。

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Git が単に新しいコマンドをエイリアスで置き換えていることがわかります。しかし、時には Git のサブコマンドではなく外部コマンドを実行したくなることもあるでしょう。そんな場合は、コマンドの先頭に `!` をつけます。これは、Git リポジトリ上で動作する自作のツールを書くときに便利です。例として、`git visual` で `gitk` が起動するようにしてみましょう。

	$ git config --global alias.visual '!gitk'

## まとめ ##

これで、ローカルでの Git の基本的な操作がこなせるようになりました。リポジトリの作成やクローン、リポジトリへの変更・ステージ・コミット、リポジトリのこれまでの変更履歴の閲覧などです。次は、Git の強力な機能であるブランチモデルについて説明しましょう。
