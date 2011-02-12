# Git のカスタマイズ #

ここまで本書では、Git の基本動作やその使用法について扱ってきました。また、Git をより簡単に効率よく使うためのさまざまなツールについても紹介しました。本章では、Git をよりカスタマイズするための操作方法を扱います。重要な設定項目やフックシステムについても説明します。これらを利用すれば、みなさん自身やその勤務先、所属グループのニーズにあわせた方法で Git を活用できるようになるでしょう。

## Git の設定 ##

第 1 章で手短にごらんいただいたように、`git config` コマンドで Git の設定をすることができます。まず最初にすることと言えば、名前とメールアドレスの設定でしょう。

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

ここでは、同じようにして設定できるより興味深い項目をいくつか身につけ、Git をカスタマイズしてみましょう。

Git の設定については最初の章でちらっと説明しましたが、ここでもう一度振り返っておきます。Git では、いくつかの設定ファイルを使ってデフォルト以外の挙動を定義します。まず最初に Git が見るのは `/etc/gitconfig` で、ここにはシステム上の全ユーザーの全リポジトリ向けの設定値を記述します。`git config` にオプション `--system` を指定すると、このファイルの読み書きを行います。

次に Git が見るのは `~/.gitconfig` で、これは各ユーザー専用のファイルです。Git でこのファイルの読み書きをするには、`--global` オプションを指定します。

最後に Git が設定値を探すのは、現在使用中のリポジトリの設定ファイル (`.git/config`) です。この値は、そのリポジトリだけで有効なものです。後から読んだ値がその前の値を上書きします。したがって、たとえば `.git/config` に書いた値は `/etc/gitconfig` での設定よりも優先されます。これらのファイルを手動で編集して正しい構文で値を追加することもできますが、通常は `git config` コマンドを使ったほうが簡単です。

### 基本的なクライアントのオプション ###

Git の設定オプションは、おおきく二種類に分類できます。クライアント側のオプションとサーバー側のオプションです。大半のオプションは、クライアント側のもの、つまり個人的な作業環境を設定するためのものとなります。大量のオプションがありますが、ここでは一般的に使われているものやワークフローに大きな影響を及ぼすものに絞っていくつかを紹介します。その他のオプションの多くは特定の場合にのみ有用なものなので、ここでは扱いません。Git で使えるすべてのオプションを知りたい場合は、次のコマンドを実行しましょう。

	$ git config --help

また、`git config` のマニュアルページには、利用できるすべてのオプションについて詳しい説明があります。

#### core.editor ####

コミットやタグのメッセージを編集するときに使うエディタは、ユーザーがデフォルトエディタとして設定したものとなります。デフォルトエディタが設定されていない場合は Vi エディタを使います。このデフォルト設定を別のものに変更するには `core.editor` を設定します。

	$ git config --global core.editor emacs

これで、シェルのデフォルトエディタを設定していない場合に Git が起動するエディタが Emacs に変わりました。

#### commit.template ####

システム上のファイルへのパスをここに設定すると、Git はそのファイルをコミット時のデフォルトメッセージとして使います。たとえば、次のようなテンプレートファイルを作って `$HOME/.gitmessage.txt` においたとしましょう。

	subject line

	what happened

	[ticket: X]

`git commit` のときにエディタに表示されるデフォルトメッセージをこれにするには、`commit.template` の設定を変更します。

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

すると、コミットメッセージの雛形としてこのような内容がエディタに表示されます。

	subject line

	what happened

	[ticket: X]
	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	# modified:   lib/test.rb
	#
	~
	~
	".git/COMMIT_EDITMSG" 14L, 297C

コミットメッセージについて所定の決まりがあるのなら、その決まりに従ったテンプレートをシステム上に作って Git にそれを使わせるようにするとよいでしょう。そうすれば、その決まりに従ってもらいやすくなります。

#### core.pager ####

core.pager は、Git が `log` や `diff` などを出力するときに使うページャを設定します。`more` などのお好みのページャを設定したり (デフォルトは `less` です)、空文字列を設定してページャを使わないようにしたりすることができます。

	$ git config --global core.pager ''

これを実行すると、すべてのコマンドの出力を、どんなに長くなったとしても全部 Git が出力するようになります。

#### user.signingkey ####

署名入りの注釈付きタグ (第 2 章で取り上げました) を作る場合は、GPG 署名用の鍵を登録しておくと便利です。鍵の ID を設定するには、このようにします。

	$ git config --global user.signingkey <gpg-key-id>

これで、`git tag` コマンドでいちいち鍵を指定しなくてもタグに署名できるようになりました。

	$ git tag -s <tag-name>

#### core.excludesfile ####

プロジェクトごとの `.gitignore` ファイルでパターンを指定すると、`git add` したときに Git がそのファイルを無視してステージしないようになります。これについては第 2 章で説明しました。しかし、これらの内容をプロジェクトの外部で管理したい場合は、そのファイルがどこにあるのかを `core.excludesfile` で設定します。ここに設定する内容はファイルのパスです。ファイルの中身は `.gitignore` と同じ形式になります。

#### help.autocorrect ####

このオプションが使えるのは Git 1.6.1 以降だけです。Git 1.6 でコマンドを打ち間違えると、こんなふうに表示されます。

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

`help.autocorrect` を 1 にしておくと、同じような場面でもし候補がひとつしかなければ自動的にそれを実行します。

### Git における色 ###

Git では、ターミナルへの出力に色をつけることができます。ぱっと見て、すばやくお手軽に出力内容を把握できるようになるでしょう。さまざまなオプションで、お好みに合わせて色を設定しましょう。

#### color.ui ####

あらかじめ指定しておけば、Git は自動的に大半の出力に色づけをします。何にどのような色をつけるかをこと細かに指定することもできますが、すべてをターミナルのデフォルト色設定にまかせるなら `color.ui` を true にします。

	$ git config --global color.ui true

これを設定すると、出力がターミナルに送られる場合に Git がその出力を色づけします。ほかに false という値を指定することもでき、これは出力に決して色をつけません。また always を指定すると、すべての場合に色をつけます。すべての場合とは、Git コマンドをファイルにリダイレクトしたり他のコマンドにパイプでつないだりする場合も含みます。この設定項目は Git バージョン 1.5.5 で追加されました。それより前のバージョンを使っている場合は、すべての色設定を個別に指定しなければなりません。

`color.ui = always` を使うことは、まずないでしょう。たいていの場合は、カラーコードを含む結果をリダイレクトしたい場合は Git コマンドに `--color` フラグを渡してカラーコードの使用を強制します。ふだんは `color.ui = true` の設定で要望を満たせるでしょう。

#### `color.*` ####

どのコマンドをどのように色づけするかをより細やかに指定したい場合、あるいはバージョンが古くて先ほどの設定が使えない場合は、コマンド単位の色づけ設定を使用します。これらの項目には `true`、`false` あるいは `always` を指定することができます。

	color.branch
	color.diff
	color.interactive
	color.status

さらに、これらの項目ではサブ設定が使え、出力の一部について特定の色を使うように指定することもできます。たとえば、diff の出力でのメタ情報を青の太字で出力させたい場合は次のようにします。

	$ git config --global color.diff.meta “blue black bold”

色として指定できる値は normal、black、red、green、yellow、blue、magenta、cyan あるいは white のいずれかです。先ほどの例の bold のように属性を指定することもできます。bold、dim、ul、blink および reverse のいずれかを指定できます。

`git config` のマニュアルページに、すべてのサブ設定がまとめられていますので参照ください。

### 外部のマージツールおよび Diff ツール ###

Git には diff の実装が組み込まれておりそれを使うことができますが、外部のツールを使うよう設定することもできます。また、コンフリクトを手動で解決するのではなくグラフィカルなコンフリクト解消ツールを使うよう設定することもできます。ここでは Perforce Visual Merge Tool (P4Merge) を使って diff の表示とマージの処理を行えるようにする例を示します。これはすばらしいグラフィカルツールで、しかもフリーだからです。

P4Merge はすべての主要プラットフォーム上で動作するので、実際に試してみたい人は試してみるとよいでしょう。この例では、Mac や Linux 形式のパス名を例に使います。Windows の場合は、`/usr/local/bin` のところを環境に合わせたパスに置き換えてください。

まず、P4Merge をここからダウンロードします。

	http://www.perforce.com/perforce/downloads/component.html

最初に、コマンドを実行するための外部ラッパースクリプトを用意します。この例では、Mac 用の実行パスを使います。他のシステムで使う場合は、`p4merge` のバイナリがインストールされた場所に置き換えてください。次のようなマージ用ラッパースクリプト `extMerge` を用意しました。これは、すべての引数を受け取ってバイナリをコールします。

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

diff のラッパーは、7 つの引数が渡されていることを確認したうえでそのうちのふたつをマージスクリプトに渡します。デフォルトでは、Git は次のような引数を diff プログラムに渡します。

	path old-file old-hex old-mode new-file new-hex new-mode

ここで必要な引数は `old-file` と `new-file` だけなので、ラッパースクリプトではこれらを渡すようにします。

	$ cat /usr/local/bin/extDiff 
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

また、これらのツールは実行可能にしておかなければなりません。

	$ sudo chmod +x /usr/local/bin/extMerge 
	$ sudo chmod +x /usr/local/bin/extDiff

これで、自前のマージツールや diff ツールを使えるように設定する準備が整いました。設定項目はひとつだけではありません。まず `merge.tool` でどんなツールを使うのかを Git に伝え、`mergetool.*.cmd` でそのコマンドを実行する方法を指定し、`mergetool.trustExitCode` では「そのコマンドの終了コードでマージが成功したかどうかを判断できるのか」を指定し、`diff.external` では diff の際に実行するコマンドを指定します。つまり、このような 4 つのコマンドを実行することになります。

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

あるいは、`~/.gitconfig` ファイルを編集してこのような行を追加します。

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

すべて設定し終えたら、
	
	$ git diff 32d1776b1^ 32d1776b1

このような diff コマンドを実行すると、結果をコマンドラインに出力するかわりに P4Merge を立ち上げ、図 7-1 のようになります。

Insert 18333fig0701.png 
図 7-1. P4Merge

ふたつのブランチをマージしてコンフリクトが発生した場合は `git mergetool` を実行します。すると P4Merge が立ち上がり、コンフリクトの解決を GUI ツールで行えるようになります。

このようなラッパーを設定しておくと、あとで diff ツールやマージツールを変更したくなったときにも簡単に変更することができます。たとえば `extDiff` や `extMerge` で KDiff3 を実行させるように変更するには `extMerge` ファイルをこのように変更するだけでよいのです。

	$ cat /usr/local/bin/extMerge
	#!/bin/sh	
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

これで、Git での diff の閲覧やコンフリクトの解決の際に KDiff3 が立ち上がるようになりました。

Git にはさまざまなマージツール用の設定が事前に準備されており、特に設定しなくても利用することができます。事前に設定が準備されているツールは kdiff3、opendiff、tkdiff、meld、xxdiff、emerge、vimdiff そして gvimdiff です。KDiff3 を diff ツールとしてではなくマージのときにだけ使いたい場合は、kdiff3 コマンドにパスが通っている状態で次のコマンドを実行します。

	$ git config --global merge.tool kdiff3

`extMerge` や `extDiff` を準備せずにこのコマンドを実行すると、マージの解決の際には KDiff3 を立ち上げて diff の際には通常の Git の diff ツールを使うようになります。

### 書式設定と空白文字 ###

書式設定や空白文字の問題は微妙にうっとうしいもので、とくにさまざまなプラットフォームで開発している人たちと共同作業をするときに問題になりがちです。使っているエディタが知らぬ間に空白文字を埋め込んでしまっていたり Windows で開発している人が行末にキャリッジリターンを付け加えてしまったりなどしてパッチが面倒な状態になってしまうことも多々あります。Git では、こういった問題に対処するための設定項目も用意しています。

#### core.autocrlf ####

自分が Windows で開発していたり、チームの中に Windows で開発している人がいたりといった場合に、改行コードの問題に巻き込まれることがありがちです。Windows ではキャリッジリターンとラインフィードでファイルの改行を表すのですが、Mac や Linux ではラインフィードだけで改行を表すという違いが原因です。ささいな違いではありますが、さまざまなプラットフォームにまたがる作業では非常に面倒なものです。

Git はこの問題に対処するために、コミットする際には行末の CRLF を LF に自動変換し、ファイルシステム上にチェックアウトするときには逆の変換を行うようにすることができます。この機能を使うには `core.autocrlf` を設定します。Windows で作業をするときにこれを `true` に設定すると、コードをチェックアウトするときに行末の LF を CRLF に自動変換してくれます。

	$ git config --global core.autocrlf true

Linux や Mac などの行末に LF を使うシステムで作業をしている場合は、Git にチェックアウト時の自動変換をされてしまうと困ります。しかし、行末が CRLF なファイルが紛れ込んでしまった場合には Git に自動修正してもらいたいものです。コミット時の CRLF から LF への変換はさせたいけれどもそれ以外の自動変換が不要な場合は、`core.autocrlf` を input に設定します。

	$ git config --global core.autocrlf input

この設定は、Windows にチェックアウトしたときの CRLF への変換は行いますが、Mac や Linux へのチェックアウト時は LF のままにします。またリポジトリにコミットする際には LF への変換を行います。

Windows のみのプロジェクトで作業をしているのなら、この機能を無効にしてキャリッジリターンをそのままリポジトリに記録してもよいでしょう。その場合は、値 `false` を設定します。

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git には、空白文字に関する問題を見つけて修正するための設定もあります。空白文字に関する主要な四つの問題に対応するもので、そのうち二つはデフォルトで有効になっています。残りの二つはデフォルトでは有効になっていませんが、有効化することができます。

デフォルトで有効になっている設定は、行末の空白文字を見つける `trailing-space` と行頭のタブ文字より前にある空白文字を見つける `space-before-tab` です。

デフォルトでは無効だけれども有効にすることもできる設定は、行頭にある八文字以上の空白文字を見つける `indent-with-non-tab` と行末のキャリッジリターンを許容する `cr-at-eol` です。

これらのオン・オフを切り替えるには、`core.whitespace` にカンマ区切りで項目を指定します。無効にしたい場合は、設定文字列でその項目を省略するか、あるいは項目名の前に `-` をつけます。たとえば `cr-at-eol` 以外のすべてを設定したい場合は、このようにします。

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

`git diff` コマンドを実行したときに Git がこれらの問題を検出すると、その部分を色付けして表示します。修正してからコミットするようにしましょう。この設定は、`git apply` でパッチを適用する際にも助けとなります。空白に関する問題を含むパッチを適用するときに警告を発してほしい場合には、次のようにします。

	$ git apply --whitespace=warn <patch>

あるいは、問題を自動的に修正してからパッチを適用したい場合は、次のようにします。

	$ git apply --whitespace=fix <patch>

これらの設定は、リベースのオプションにも適用されます。空白に関する問題を含むコミットをしたけれどまだそれを公開リポジトリにプッシュしていない場合は、`rebase` に `--whitespace=fix` オプションをつけて実行すれば、パッチを書き換えて空白問題を自動修正してくれます。

### サーバーの設定 ###

Git のサーバー側の設定オプションはそれほど多くありませんが、いくつか興味深いものがあるので紹介します。

#### receive.fsckObjects ####

デフォルトでは、Git はプッシュで受け取ったオブジェクトの一貫性をチェックしません。各オブジェクトの SHA-1 チェックサムが一致していて有効なオブジェクトを指しているということを Git にチェックさせることもできますが、デフォルトでは毎回のプッシュ時のチェックは行わないようになっています。このチェックは比較的重たい処理であり、リポジトリのサイズが大きかったりプッシュする量が多かったりすると、毎回チェックさせるのには時間がかかるでしょう。毎回のプッシュの際に Git にオブジェクトの一貫性をチェックさせたい場合は、`receive.fsckObjects` を true にして強制的にチェックさせるようにします。

	$ git config --system receive.fsckObjects true

これで、Git がリポジトリの整合性を確認してからでないとプッシュが認められないようになります。壊れたデータをまちがって受け入れてしまうことがなくなりました。

#### receive.denyNonFastForwards ####

すでにプッシュしたコミットをリベースしてもう一度プッシュした場合、あるいはリモートブランチが現在指しているコミットを含まないコミットをプッシュしようとした場合は、プッシュが拒否されます。これは悪くない方針でしょう。しかしリベースの場合は、自分が何をしているのかをきちんと把握していれば、プッシュの際に `-f` フラグを指定して強制的にリモートブランチを更新することができます。

このような強制更新機能を無効にするには、`receive.denyNonFastForwards` を設定します。

	$ git config --system receive.denyNonFastForwards true

もうひとつの方法として、サーバー側の receive フックを使うこともできます。こちらの方法については後ほど簡単に説明します。receive フックを使えば、特定のユーザーだけ強制更新を無効にするなどより細やかな制御ができるようになります。

#### receive.denyDeletes ####

`denyNonFastForwards` の制限を回避する方法として、いったんブランチを削除してから新しいコミットを参照するブランチをプッシュしなおすことができます。その対策として、新しいバージョン (バージョン 1.6.1 以降) の Git では `receive.denyDeletes` を true に設定することができます。

	$ git config --system receive.denyDeletes true

これは、プッシュによるブランチやタグの削除を一切拒否し、誰も削除できないようにします。リモートブランチを削除するには、サーバー上の ref ファイルを手で削除しなければなりません。ACL を使って、ユーザー単位でこれを制限することもできますが、その方法は本章の最後で扱います。

## Git の属性 ##

設定項目の中には、パスにも指定できるものがあります。Git はその設定を、指定したパスのサブディレクトリやファイルにのみ適用するのです。これらのパス固有の設定は Git の属性と呼ばれ、あるディレクトリ (通常はプロジェクトのルートディレクトリ) の直下の `.gitattributes` か、あるいはそのファイルをプロジェクトとともにコミットしたくない場合は `.git/info/attributes` に設定します。

属性を使うと、ファイルやディレクトリ単位で個別のマージ戦略を指定したりテキストファイル以外での diff の取得方法を指示したり、あるいはチェックインやチェックアウトの前に Git にフィルタリングさせたりすることができます。このセクションでは、Git プロジェクトでパスに設定できる属性のいくつかについて学び、実際にその機能を使う例を見ていきます。

### バイナリファイル ###

Git の属性を使ってできるちょっとした技として、どのファイルがバイナリファイルなのかを (その他の方法で判別できない場合のために) 指定して Git に対してバイナリファイルの扱い方を指示するというものがあります。たとえば、機械で生成したテキストファイルの中には diff が取得できないものがありますし、バイナリファイルであっても diff が取得できるものもあります。それを Git に指示する方法を紹介します。

#### バイナリファイルの特定 ####

テキストファイルのように見えるファイルであっても、何らかの目的のために意図的にバイナリデータとして扱いたいこともあります。たとえば、Mac の Xcode プロジェクトの中には `.pbxproj` で終わる名前のファイルがあります。これは JSON (プレーンテキスト形式の javascript のデータフォーマット) のデータセットで、IDE がビルド設定などをディスクに書き出したものです。すべて ASCII で構成されるので、理論上はこれはテキストファイルです。しかしこのファイルをテキストファイルとして扱いたくはありません。実際のところ、このファイルは軽量なデータベースとして使われているからです。他の人が変更した内容をマージすることはできませんし、diff をとってもあまり意味がありません。このファイルは、基本的に機械が処理するものなのです。要するに、バイナリファイルと同じように扱いたいということです。

すべての `pbxproj` ファイルをバイナリデータとして扱うよう Git に指定するには、次の行を `.gitattributes` ファイルに追加します。

	*.pbxproj -crlf -diff

これで、Git が CRLF 問題の対応をすることもなくなりますし、git show や git diff を実行したときにもこのファイルの diff を調べることはなくなります。Git 1.6 系では、次のようなマクロを使うこともできます。これは `-crlf -diff` と同じ意味です。

	*.pbxproj binary

#### バイナリファイルの差分 ####

Git 1.6系では、バイナリファイルの差分を効果的に扱うためにGitの属性機能を使うことができます。通常のdiff機能を使って比較を行うことができるように、バイナリデータをテキストデータに変換する方法をGitに教えればいいのです。

これは素晴らしい機能ですがほとんど知られていないので、少し例をあげてみたいと思います。あなたはまず最初に人類にとっても最も厄介な問題のひとつを解決するためにこのテクニックを使いたいと思うでしょう。そう、Wordで作成した文書のバージョン管理です。奇妙なことに、Wordは最悪のエディタだと全ての人が知ってるいるにも係わらず、全ての人がWordを使っています。Word文書をバージョン管理したいと思ったなら、Gitのリポジトリにそれらを追加して、まとめてcommitすればいいのです。しかし、それでいいのでしょうか？ あなたが'git diff'をいつも通りに実行すると、次のように表示されるだけです。

	$ git diff 
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

これでは2つのバージョンをcheckoutしてそれらを自分で見比べてみない限り、比較することは出来ませんよね？ Gitの属性を使えば、うまく解決できます。`.gitattributes`に次の行を追加して下さい。

	*.doc diff=word

これは、指定したパターン(.doc)にマッチした全てのファイルに対して、差分を表示する時には"word"というフィルタを使うべきであるとGitに教えているのです。"word"フィルタとは何でしょうか？ それはあなたが用意しなければなりません。Word文書をテキストファイルに変換するプログラムとして `strings` を使うように次のようにGitを設定してみましょう。

	$ git config diff.word.textconv strings

これで、`.doc`という拡張子をもったファイルはそれぞれのファイルに`strings`というプログラムとして定義された"word"フィルタを通してからdiffを取るべきだということをGitは知っていることになります。こうすることで、Wordファイルに対して直接差分を取るのではなく、より効果的なテキストベースでの差分を取ることができるようになります。

例を示しましょう。この本の第1章をGitリポジトリに登録した後、ある段落にいくつかの文章を追加して保存し、それから、変更箇所を確認するために`git diff`を実行しました。

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
	 re going to cover how to get it and set it up for the first time if you don
	 t already have it on your system.
	 In Chapter Two we will go over basic Git usage - how to use Git for the 80% 
	-s going on, modify stuff and contribute changes. If the book spontaneously 
	+s going on, modify stuff and contribute changes. If the book spontaneously 
	+Let's see if this works.

Gitは正しく、追加した"Let’s see if this works"という文字列を首尾よく、かつ、簡潔に知らせてくれました。予想外の差分が表示されているので、完璧といえません。しかし、正しく動作しているとはいえます。あなたがWord文書をテキストファイルに変換するもっと良いプログラムを見付けられれば、よりよい結果を得られるでしょう。とはいえ、`strings`はほとんどのMacとLinuxで動作するので、様々なバイナリフォーマットに試してみるのに、最初の選択肢としては良いと思います。

その他の興味深い問題としては画像ファイルの差分があります。JPEGファイルに対するひとつの方法としては、EXIF情報(多くのファイルでメタデータとして使われています)を抽出するフィルタを使う方法です。`exiftool`をダウンロードしインストールすれば、画像データをメタデータの形でテキストデータとして扱うことができます。従って、次のように設定すれば、画像データの差分をメタデータの差分という形で表示することができます。

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

上記の設定をしてからプロジェクトで画像データを置き換えて`git diff`と実行すれば、次のように表示されることになるでしょう。

	diff --git a/image.png b/image.png
	index 88839c4..4afcb7c 100644
	--- a/image.png
	+++ b/image.png
	@@ -1,12 +1,12 @@
	 ExifTool Version Number         : 7.74
	-File Size                       : 70 kB
	-File Modification Date/Time     : 2009:04:21 07:02:45-07:00
	+File Size                       : 94 kB
	+File Modification Date/Time     : 2009:04:21 07:02:43-07:00
	 File Type                       : PNG
	 MIME Type                       : image/png
	-Image Width                     : 1058
	-Image Height                    : 889
	+Image Width                     : 1056
	+Image Height                    : 827
	 Bit Depth                       : 8
	 Color Type                      : RGB with Alpha

ファイルのサイズと画像のサイズが変更されたことが簡単に見て取れるでしょう。

### キーワード展開 ###

SubversionやCVSを使っていた開発者から、キーワード展開機能をリクエストされることがよくあります。これについてGitにおける主な問題は、Gitはまずファイルのチェックサムを生成するためにcommitした後にファイルに関する情報を変更できないという点です。しかし、commitするためにaddする前にファイルをcheckoutしremoveするという手順を踏めば、その時にファイルにテキストを追加することが可能です。Gitの属性はそうするための方法を2つ提供します。

ひとつめの方法として、ファイルの`$Id$`フィールドを自動的にblobのSHA-1 checksumを挿入するようにできます。あるファイル、もしくはいくつかのファイルに対してこの属性を設定すれば、次にcheckoutする時、Gitはこの置き換えを行うようになるでしょう。ただし、挿入されるチェックサムはcommitに対するものではなく、対象となるblobものであるという点に注意して下さい。

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

次にtest.txtをcheckoutする時、GitはSHA-1チェックサムを挿入します。

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt 
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

しかし、このやりかたには制限があります。CVSやSubversionのキーワード展開ではタイムスタンプを含めることができます。対して、SHA-1チェックサムは完全にランダムな値ですから、2つの値の新旧を知るための助けにはなりません。

これには、commit/checkout時にキーワード展開を行うためのフィルタを書いてやることで対応できます。このために"clean"と"smudge"フィルタがあります。特定のファイルに対して使用するフィルタを設定し、checkoutされる前("smudge" 図7-2参照)もしくはcommitされる前("clean" 図7-3参照)に指定したスクリプトが実行させるよう、`.gitattributes`ファイルで設定できます。これらのフィルタはあらゆる種類の面白い内容を実行するように設定できます。

Insert 18333fig0702.png 
図7-2. checkoutする時に"smudge"フィルタを実行する

Insert 18333fig0703.png 
図7-3. ステージする時に"clean"フィルタを実行する。

この機能に対してオリジナルのcommitメッセージは簡単な例を与えてくれています。それはcommit前にあなたのCのソースコードを`indent`プログラムに通すというものです。`*.c`ファイルに対して"indent"フィルタを実行するように、`.gitattributes`ファイルにfilter属性を設定することができます。

	*.c     filter=indent

それから、smudgeとcleanで"indent"フィルタが何を行えばいいのかをGitに教えます。

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

このケースでは、`*.c`にマッチするファイルをcommitした時、Gitはcommit前にindentプログラムにファイルを通し、checkoutする前には`cat`を通すようにします。`cat`は基本的に何もしません。入力されたデータと同じデータを吐き出すだけです。この組み合わせでCのソースコードに対してcommit前に`indent`を通すことが効果的に行えます。

RCSスタイルの`$Date$`キーワード展開もまた別の興味深い例です。満足のいく形でこれを行うには、ファイル名を受け取って、プロジェクトの最新のcommitの日付を見付けだし、その日付をファイルに挿入するちょっとしたスクリプトが必要になります。そのようなRubyスクリプトが以下です。

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

このスクリプトは、`git log`コマンドの出力から最新のcommitの日付を取得し、標準入力からの入力中のすべての`$Date$`文字列にその日付を追加し、結果を表示します。あなたのお気に入りのどのような言語でスクリプトを書くにしても、簡潔にすべきです。このスクリプトファイルに`expand_date`と名前をつけ、実行パスのどこかに置きます。次に、Gitが使うフィルタ(`dater`と呼びましょうか)を設定し、checkout時に`expand_date`が実行されるようにGitに教えてあげましょう。

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

このPerlのスクリプトは、開始点に戻るために`$Date$`文字列内の他の文字列を削除します。さあ、フィルタの準備ができました。ファイルに`$Date$`キーワードを追加して新しいフィルタに仕事をさせるためにGitの属性を設定して、テストしてみましょう。

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

これらの変更をcommitして再度ファイルをcheckoutすれば、キーワード展開が正しく行われているのがわかります。

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

アプリケーションをカスタマイズするためのこのテクニックがどれほど強力か、おわかりいただけたと思います。しかし、注意が必要です。`.gitattributes`ファイルはcommitされ、プロジェクト内で共有されますが、ドライバ(このケースで言えば、`dater`)はそうはいきません。そう、すべての環境で動くとは限らないのです。あなたがこうしたフィルタをデザインする時、たとえフィルタが正常に動作しなかったとしても、プロジェクトは適切に動き続けられるようにすべきです。

### リポジトリをエクスポートする ###

あなたのプロジェクトのアーカイブをエクスポートする時には、Gitの属性データを使って興味深いことを行うことができます。

#### export-ignore ####

アーカイヴを生成するとき、あるファイルやディレクトリをエクスポートしないように設定することができます。プロジェクトにはcheckinしたいがアーカイブファイルには含めたくないディレクトリやファイルがあるなら、それらに`export-ignore`を設定してやることができます。

例えば、`test/`ディレクトリ以下にいくつかのテストファイルがあって、それらをプロジェクトのtarballには含めたくないとしましょう。その場合、次の1行をGitの属性ファイルに追加します。

	test/ export-ignore

これで、プロジェクトのtarballを作成するためにgitを実行した時、アーカイブには`test/`ディレクトリが含まれないようになります。

#### export-subst ####

アーカイブ作成時にできる別のこととして、いくつかの簡単なキーワード展開があります。第2章で紹介した`--pretty=format`で指定できるフォーマット指定子とともに`$Format:$`文字列をファイルに追加することができます。例えば、`LAST_COMMIT`という名前のファイルをプロジェクトに追加し、`git archive`を実行した時にそれを最新のcommitの日付に変換したい場合、次のように設定します。

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

`git archive`を実行したあと、アーカイブを展開すると、`LAST_COMMIT`は以下のような内容になっているでしょう。

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### マージの戦略 ###

Git属性を使えば、プロジェクトにある指定したファイルに対して異なるマージ戦略を使うようにすることができます。とても有効なオプションのひとつは、指定したファイルで競合が発生した場合に、マージを行わずにあなたの変更内容で他の誰かの変更を上書きするように設定するというものです。

これはブランチを分岐させ特別な作業をしている時、そのブランチでの変更をマージさせたいが、いくつかのファイルの変更はなかったことにしたいというような時に助けになります。例えば、database.xmlというデータベースの設定ファイルがあり、ふたつのブランチでその内容が異なっているとしましょう。そして、そのデータベースファイルを台無しすることなしに、一方のブランチへとマージしたいとします。これは、次のように属性を設定すれば実現できます。

	database.xml merge=ours

マージを実行すると、database.xmlに関する競合は発生せず、次のような結果になります。

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

この場合、database.xmlは元々のバージョンのまま、書き変わりません。

## Git フック ##

他のバージョンコントロールシステムと同じように、Gitにも特定のアクションが発生した時にスクリプトを叩く方法があります。フックはクライアントサイドとサーバーサイドの二つのグループに分けられます。クライアントサイドフックはコミットやマージといったクライアントでの操作用に、サーバーサイドフックはプッシュされたコミットを受け取るといったサーバーでの操作用に利用されます。これらのフックをさまざまなな理由に用いることができます。ここではそのうちのいくつかをご紹介しましょう。

### フックをインストールする ###

フックはGitディレクトリの`hooks`サブディレクトリに格納されています。一般的なプロジェクトでは、`.git/hooks`がそれにあたります。Gitはデフォルトでこのディレクトリに例となるスクリプトを生成します。それらの多くはそのままでも十分有用ですし、引数も記載されています。全ての例は基本的にシェルスクリプトで書かれています。いくつかPerlを含むものもありますが、適切に命名されたそれらの実行可能スクリプトはうまく動きます。RubyやPython等で自作していただいてもかまいません。バージョン1.6以降のGitの場合、それらのフックファイルの末尾は.sampleとなっていますので適時リネームしてください。バージョン1.6以前のGitの場合ファイル名は適切ですが実行可能にはなっていません。

フックスクリプトを有効にするには、Gitディレクトリの`hooks`サブディレクトリに適切な名前の実行可能なファイルを配置する必要があります。これによってファイルが呼び出されることになります。ここでは重要なフックファイル名をいくつか取り上げます。

### クライアントサイドフック ###

クライアントサイドフックにはたくさんの種類があります。ここではコミットワークフローフック、Eメールワークフロースクリプト、その他クライアントサイドフックに分類します。

#### コミットワークフローフック ####

最初の4つのフックはコミットプロセスに関するものです。`pre-commit`フックはコミットメッセージが入力される前に実行されます。これはいまからコミットされるであろうスナップショットを検査したり、何かし忘れた事を確認したり、事前にテストを実行したり、何かしらコードを検査する目的で使用されます。`git commit --no-verify`で回避することもできますが、このフックから0でない値が返るとコミットが中断されます。コーディングスタイルの検査（lintを実行する等）や、空白文字の追跡（デフォルトのフックがまさにそうです）、新しく追加されたメソッドのドキュメントが正しいかどうかを検査したりといったことが可能です。

`prepare-commit-msg`フックは、コミットメッセージエディターが起動する直前、デフォルトメッセージが生成された直後に実行されます。コミットの作者がそれを目にする前にデフォルトメッセージを編集することができます。このフックはオプションを必要とします: 現在までのコミットメッセージを保存したファイルへのパス、コミットのタイプ、さらにamendされたコミットの場合はコミットSHA-1が必要です。このフックは普段のコミットにおいてあまり有用ではありませんが、テンプレートのコミットメッセージ・mergeコミット・squashコミット・amendコミットのようなデフォルトメッセージが自動で挿入されるコミットにおいて効果を発揮します。テンプレートのコミットメッセージと組み合わせて、動的な情報をプログラムで挿入することができます。

`commit-msg`フックも、現在のコミットメッセージを保存した一時ファイルへのパスをパラメータに持つ必要があります。このスクリプトが0以外の値を返した場合Gitはコミットプロセスを中断しますので、プロジェクトの状態や許可待ちになっているコミットメッセージを有効にすることができます 。この章の最後のセクションでは、このフックを使用してコミットメッセージが要求された様式に沿っているか検査するデモンストレーションを行います。

コミットプロセスが全て完了した後に、`post-commit`フックが実行されます。パラメータは必要無く、`git log -1 HEAD`を実行することで直前のコミットを簡単に取り出すことができます。一般的にこのスクリプトは何かしらの通知といった目的に使用されます。

コミットワークフロークライアントサイドスクリプトはあらゆるワークフローに使用することができます。clone中にスクリプトが転送される事はありませんが、これらはしばしばサーバー側で決められたポリシーを強制する目的で使用されます。これらのスクリプトは開発者を支援するために存在するのですから、いつでもオーバーライドされたり変更されたりすることがありえるとしても開発者らによってセットアップされ、メンテナンスされてしかるべきです。

#### Eメールワークフローフック ####

Eメールを使ったワークフロー用として、三種類のクライアントサイドフックを設定することができます。これらはすべて `git am` コマンドに対して起動されるものなので、ふだんの作業でこのコマンドを使っていない場合は次のセクションを読み飛ばしてもかまいません。`git format-patch` で作ったパッチを受け取ることがある場合は、ここで説明する内容が有用になるかもしれません。

まず最初に実行されるフックは `applypatch-msg` です。これは引数をひとつだけ受け取ります。コミットメッセージを含む一時ファイル名です。このスクリプトがゼロ以外の値で終了した場合、Git はパッチの処理を強制終了させます。このフックを使うと、コミットメッセージの書式が正しいかどうかを確認したり、スクリプトで正しい書式に手直ししたりすることができます。

`git am` でパッチを適用するときに二番目に実行されるフックは `pre-applypatch` です。これは引数を受け取らず、パッチが適用された後に実行されます。このフックを使うと、パッチ適用後の状態をコミットする前に調べることができます。つまり、このスクリプトでテストを実行したり、その他の調査をしたりといったことができるということです。なにか抜けがあったりテストが失敗したりした場合はスクリプトをゼロ以外の値で終了させます。そうすれば、`git am` はパッチをコミットせずに強制終了します。

`git am` において最後に実行されるフックは `post-applypatch` です。これを使うと、グループのメンバーやそのパッチの作者に対して処理の完了を伝えることができます。このスクリプトでは、パッチの適用を中断させることはできません。

#### Other Client Hooks ####

The `pre-rebase` hook runs before you rebase anything and can halt the process by exiting non-zero. You can use this hook to disallow rebasing any commits that have already been pushed. The example `pre-rebase` hook that Git installs does this, although it assumes that next is the name of the branch you publish. You’ll likely need to change that to whatever your stable, published branch is.

After you run a successful `git checkout`, the `post-checkout` hook runs; you can use it to set up your working directory properly for your project environment. This may mean moving in large binary files that you don’t want source controlled, auto-generating documentation, or something along those lines.

Finally, the `post-merge` hook runs after a successful `merge` command. You can use it to restore data in the working tree that Git can’t track, such as permissions data. This hook can likewise validate the presence of files external to Git control that you may want copied in when the working tree changes.

### Server-Side Hooks ###

In addition to the client-side hooks, you can use a couple of important server-side hooks as a system administrator to enforce nearly any kind of policy for your project. These scripts run before and after pushes to the server. The pre hooks can exit non-zero at any time to reject the push as well as print an error message back to the client; you can set up a push policy that’s as complex as you wish.

#### pre-receive and post-receive ####

The first script to run when handling a push from a client is `pre-receive`. It takes a list of references that are being pushed from stdin; if it exits non-zero, none of them are accepted. You can use this hook to do things like make sure none of the updated references are non-fast-forwards; or to check that the user doing the pushing has create, delete, or push access or access to push updates to all the files they’re modifying with the push.

The `post-receive` hook runs after the entire process is completed and can be used to update other services or notify users. It takes the same stdin data as the `pre-receive` hook. Examples include e-mailing a list, notifying a continuous integration server, or updating a ticket-tracking system — you can even parse the commit messages to see if any tickets need to be opened, modified, or closed. This script can’t stop the push process, but the client doesn’t disconnect until it has completed; so, be careful when you try to do anything that may take a long time.

#### update ####

The update script is very similar to the `pre-receive` script, except that it’s run once for each branch the pusher is trying to update. If the pusher is trying to push to multiple branches, `pre-receive` runs only once, whereas update runs once per branch they’re pushing to. Instead of reading from stdin, this script takes three arguments: the name of the reference (branch), the SHA-1 that reference pointed to before the push, and the SHA-1 the user is trying to push. If the update script exits non-zero, only that reference is rejected; other references can still be updated.

## An Example Git-Enforced Policy ##

In this section, you’ll use what you’ve learned to establish a Git workflow that checks for a custom commit message format, enforces fast-forward-only pushes, and allows only certain users to modify certain subdirectories in a project. You’ll build client scripts that help the developer know if their push will be rejected and server scripts that actually enforce the policies.

I used Ruby to write these, both because it’s my preferred scripting language and because I feel it’s the most pseudocode-looking of the scripting languages; thus you should be able to roughly follow the code even if you don’t use Ruby. However, any language will work fine. All the sample hook scripts distributed with Git are in either Perl or Bash scripting, so you can also see plenty of examples of hooks in those languages by looking at the samples.

### Server-Side Hook ###

All the server-side work will go into the update file in your hooks directory. The update file runs once per branch being pushed and takes the reference being pushed to, the old revision where that branch was, and the new revision being pushed. You also have access to the user doing the pushing if the push is being run over SSH. If you’ve allowed everyone to connect with a single user (like "git") via public-key authentication, you may have to give that user a shell wrapper that determines which user is connecting based on the public key, and set an environment variable specifying that user. Here I assume the connecting user is in the `$USER` environment variable, so your update script begins by gathering all the information you need:

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Yes, I’m using global variables. Don’t judge me — it’s easier to demonstrate in this manner.

#### Enforcing a Specific Commit-Message Format ####

Your first challenge is to enforce that each commit message must adhere to a particular format. Just to have a target, assume that each message has to include a string that looks like "ref: 1234" because you want each commit to link to a work item in your ticketing system. You must look at each commit being pushed up, see if that string is in the commit message, and, if the string is absent from any of the commits, exit non-zero so the push is rejected.

You can get a list of the SHA-1 values of all the commits that are being pushed by taking the `$newrev` and `$oldrev` values and passing them to a Git plumbing command called `git rev-list`. This is basically the `git log` command, but by default it prints out only the SHA-1 values and no other information. So, to get a list of all the commit SHAs introduced between one commit SHA and another, you can run something like this:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

You can take that output, loop through each of those commit SHAs, grab the message for it, and test that message against a regular expression that looks for a pattern.

You have to figure out how to get the commit message from each of these commits to test. To get the raw commit data, you can use another plumbing command called `git cat-file`. I’ll go over all these plumbing commands in detail in Chapter 9; but for now, here’s what that command gives you:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

A simple way to get the commit message from a commit when you have the SHA-1 value is to go to the first blank line and take everything after that. You can do so with the `sed` command on Unix systems:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

You can use that incantation to grab the commit message from each commit that is trying to be pushed and exit if you see anything that doesn’t match. To exit the script and reject the push, exit non-zero. The whole method looks like this:

	$regex = /\[ref: (\d+)\]/

	# enforced custom commit message format
	def check_message_format
	  missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  missed_revs.each do |rev|
	    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
	    if !$regex.match(message)
	      puts "[POLICY] Your message is not formatted correctly"
	      exit 1
	    end
	  end
	end
	check_message_format

Putting that in your `update` script will reject updates that contain commits that have messages that don’t adhere to your rule.

#### Enforcing a User-Based ACL System ####

Suppose you want to add a mechanism that uses an access control list (ACL) that specifies which users are allowed to push changes to which parts of your projects. Some people have full access, and others only have access to push changes to certain subdirectories or specific files. To enforce this, you’ll write those rules to a file named `acl` that lives in your bare Git repository on the server. You’ll have the `update` hook look at those rules, see what files are being introduced for all the commits being pushed, and determine whether the user doing the push has access to update all those files.

The first thing you’ll do is write your ACL. Here you’ll use a format very much like the CVS ACL mechanism: it uses a series of lines, where the first field is `avail` or `unavail`, the next field is a comma-delimited list of the users to which the rule applies, and the last field is the path to which the rule applies (blank meaning open access). All of these fields are delimited by a pipe (`|`) character.

In this case, you have a couple of administrators, some documentation writers with access to the `doc` directory, and one developer who only has access to the `lib` and `tests` directories, and your ACL file looks like this:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

You begin by reading this data into a structure that you can use. In this case, to keep the example simple, you’ll only enforce the `avail` directives. Here is a method that gives you an associative array where the key is the user name and the value is an array of paths to which the user has write access:

	def get_acl_access_data(acl_file)
	  # read in ACL data
	  acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
	  access = {}
	  acl_file.each do |line|
	    avail, users, path = line.split('|')
	    next unless avail == 'avail'
	    users.split(',').each do |user|
	      access[user] ||= []
	      access[user] << path
	    end
	  end
	  access
	end

On the ACL file you looked at earlier, this `get_acl_access_data` method returns a data structure that looks like this:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Now that you have the permissions sorted out, you need to determine what paths the commits being pushed have modified, so you can make sure the user who’s pushing has access to all of them.

You can pretty easily see what files have been modified in a single commit with the `--name-only` option to the `git log` command (mentioned briefly in Chapter 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

If you use the ACL structure returned from the `get_acl_access_data` method and check it against the listed files in each of the commits, you can determine whether the user has access to push all of their commits:

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # see if anyone is trying to push something they can't
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path  # user has access to everything
	          || (path.index(access_path) == 0) # access to this path
	          has_file_access = true 
	        end
	      end
	      if !has_file_access
	        puts "[POLICY] You do not have access to push to #{path}"
	        exit 1
	      end
	    end
	  end  
	end

	check_directory_perms

Most of that should be easy to follow. You get a list of new commits being pushed to your server with `git rev-list`. Then, for each of those, you find which files are modified and make sure the user who’s pushing has access to all the paths being modified. One Rubyism that may not be clear is `path.index(access_path) == 0`, which is true if path begins with `access_path` — this ensures that `access_path` is not just in one of the allowed paths, but an allowed path begins with each accessed path. 

Now your users can’t push any commits with badly formed messages or with modified files outside of their designated paths.

#### Enforcing Fast-Forward-Only Pushes ####

The only thing left is to enforce fast-forward-only pushes. In Git versions 1.6 or newer, you can set the `receive.denyDeletes` and `receive.denyNonFastForwards` settings. But enforcing this with a hook will work in older versions of Git, and you can modify it to do so only for certain users or whatever else you come up with later.

The logic for checking this is to see if any commits are reachable from the older revision that aren’t reachable from the newer one. If there are none, then it was a fast-forward push; otherwise, you deny it:

	# enforces fast-forward only pushes 
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

Everything is set up. If you run `chmod u+x .git/hooks/update`, which is the file you into which you should have put all this code, and then try to push a non-fast-forwarded reference, you get something like this:

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies... 
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non-fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

There are a couple of interesting things here. First, you see this where the hook starts running.

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Notice that you printed that out to stdout at the very beginning of your update script. It’s important to note that anything your script prints to stdout will be transferred to the client.

The next thing you’ll notice is the error message.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

The first line was printed out by you, the other two were Git telling you that the update script exited non-zero and that is what is declining your push. Lastly, you have this:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

You’ll see a remote rejected message for each reference that your hook declined, and it tells you that it was declined specifically because of a hook failure.

Furthermore, if the ref marker isn’t there in any of your commits, you’ll see the error message you’re printing out for that.

	[POLICY] Your message is not formatted correctly

Or if someone tries to edit a file they don’t have access to and push a commit containing it, they will see something similar. For instance, if a documentation author tries to push a commit modifying something in the `lib` directory, they see

	[POLICY] You do not have access to push to lib/test.rb

That’s all. From now on, as long as that `update` script is there and executable, your repository will never be rewound and will never have a commit message without your pattern in it, and your users will be sandboxed.

### Client-Side Hooks ###

The downside to this approach is the whining that will inevitably result when your users’ commit pushes are rejected. Having their carefully crafted work rejected at the last minute can be extremely frustrating and confusing; and furthermore, they will have to edit their history to correct it, which isn’t always for the faint of heart.

The answer to this dilemma is to provide some client-side hooks that users can use to notify them when they’re doing something that the server is likely to reject. That way, they can correct any problems before committing and before those issues become more difficult to fix. Because hooks aren’t transferred with a clone of a project, you must distribute these scripts some other way and then have your users copy them to their `.git/hooks` directory and make them executable. You can distribute these hooks within the project or in a separate project, but there is no way to set them up automatically.

To begin, you should check your commit message just before each commit is recorded, so you know the server won’t reject your changes due to badly formatted commit messages. To do this, you can add the `commit-msg` hook. If you have it read the message from the file passed as the first argument and compare that to the pattern, you can force Git to abort the commit if there is no match:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

If that script is in place (in `.git/hooks/commit-msg`) and executable, and you commit with a message that isn’t properly formatted, you see this:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

No commit was completed in that instance. However, if your message contains the proper pattern, Git allows you to commit:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Next, you want to make sure you aren’t modifying files that are outside your ACL scope. If your project’s `.git` directory contains a copy of the ACL file you used previously, then the following `pre-commit` script will enforce those constraints for you:

	#!/usr/bin/env ruby

	$user    = ENV['USER']

	# [ insert acl_access_data method from above ]

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('.git/acl')

	  files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
	  files_modified.each do |path|
	    next if path.size == 0
	    has_file_access = false
	    access[$user].each do |access_path|
	    if !access_path || (path.index(access_path) == 0)
	      has_file_access = true
	    end
	    if !has_file_access
	      puts "[POLICY] You do not have access to push to #{path}"
	      exit 1
	    end
	  end
	end

	check_directory_perms

This is roughly the same script as the server-side part, but with two important differences. First, the ACL file is in a different place, because this script runs from your working directory, not from your Git directory. You have to change the path to the ACL file from this

	access = get_acl_access_data('acl')

to this:

	access = get_acl_access_data('.git/acl')

The other important difference is the way you get a listing of the files that have been changed. Because the server-side method looks at the log of commits, and, at this point, the commit hasn’t been recorded yet, you must get your file listing from the staging area instead. Instead of

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

you have to use

	files_modified = `git diff-index --cached --name-only HEAD`

But those are the only two differences — otherwise, the script works the same way. One caveat is that it expects you to be running locally as the same user you push as to the remote machine. If that is different, you must set the `$user` variable manually.

The last thing you have to do is check that you’re not trying to push non-fast-forwarded references, but that is a bit less common. To get a reference that isn’t a fast-forward, you either have to rebase past a commit you’ve already pushed up or try pushing a different local branch up to the same remote branch.

Because the server will tell you that you can’t push a non-fast-forward anyway, and the hook prevents forced pushes, the only accidental thing you can try to catch is rebasing commits that have already been pushed.

Here is an example pre-rebase script that checks for that. It gets a list of all the commits you’re about to rewrite and checks whether they exist in any of your remote references. If it sees one that is reachable from one of your remote references, it aborts the rebase:

	#!/usr/bin/env ruby

	base_branch = ARGV[0]
	if ARGV[1]
	  topic_branch = ARGV[1]
	else
	  topic_branch = "HEAD"
	end

	target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
	remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

	target_shas.each do |sha|
	  remote_refs.each do |remote_ref|
	    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
	    if shas_pushed.split(“\n”).include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

This script uses a syntax that wasn’t covered in the Revision Selection section of Chapter 6. You get a list of commits that have already been pushed up by running this:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

The `SHA^@` syntax resolves to all the parents of that commit. You’re looking for any commit that is reachable from the last commit on the remote and that isn’t reachable from any parent of any of the SHAs you’re trying to push up — meaning it’s a fast-forward.

The main drawback to this approach is that it can be very slow and is often unnecessary — if you don’t try to force the push with `-f`, the server will warn you and not accept the push. However, it’s an interesting exercise and can in theory help you avoid a rebase that you might later have to go back and fix.

## Summary ##

You’ve covered most of the major ways that you can customize your Git client and server to best fit your workflow and projects. You’ve learned about all sorts of configuration settings, file-based attributes, and event hooks, and you’ve built an example policy-enforcing server. You should now be able to make Git fit nearly any workflow you can dream up.
