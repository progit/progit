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

このオプションが使えるのは Git 1.6.1 以降だけです。Git でコマンドを打ち間違えると、こんなふうに表示されます。

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

これを設定すると、出力がターミナルに送られる場合に Git がその出力を色づけします。ほかに false という値を指定することもでき、これは出力に決して色をつけません。また always を指定すると、すべての場合に色をつけます。すべての場合とは、Git コマンドをファイルにリダイレクトしたり他のコマンドにパイプでつないだりする場合も含みます。

`color.ui = always` を使うことは、まずないでしょう。たいていの場合は、カラーコードを含む結果をリダイレクトしたい場合は Git コマンドに `--color` フラグを渡してカラーコードの使用を強制します。ふだんは `color.ui = true` の設定で要望を満たせるでしょう。

#### `color.*` ####

どのコマンドをどのように色づけするかをより細やかに指定したい場合、コマンド単位の色づけ設定を使用します。これらの項目には `true`、`false` あるいは `always` を指定することができます。

	color.branch
	color.diff
	color.interactive
	color.status

さらに、これらの項目ではサブ設定が使え、出力の一部について特定の色を使うように指定することもできます。たとえば、diff の出力でのメタ情報を青の太字で出力させたい場合は次のようにします。

	$ git config --global color.diff.meta "blue black bold"

色として指定できる値は normal、black、red、green、yellow、blue、magenta、cyan あるいは white のいずれかです。先ほどの例の bold のように属性を指定することもできます。bold、dim、ul、blink および reverse のいずれかを指定できます。

`git config` のマニュアルページに、すべてのサブ設定がまとめられていますので参照ください。

### 外部のマージツールおよび Diff ツール ###

Git には diff の実装が組み込まれておりそれを使うことができますが、外部のツールを使うよう設定することもできます。また、コンフリクトを手動で解決するのではなくグラフィカルなコンフリクト解消ツールを使うよう設定することもできます。ここでは Perforce Visual Merge Tool (P4Merge) を使って diff の表示とマージの処理を行えるようにする例を示します。これはすばらしいグラフィカルツールで、しかもフリーだからです。

P4Merge はすべての主要プラットフォーム上で動作するので、実際に試してみたい人は試してみるとよいでしょう。この例では、Mac や Linux 形式のパス名を例に使います。Windows の場合は、`/usr/local/bin` のところを環境に合わせたパスに置き換えてください。

まず、P4Merge をここからダウンロードします。

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

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
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
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

これらの設定は、`git rebase`コマンドにも適用されます。空白に関する問題を含むコミットをしたけれどまだそれを公開リポジトリにプッシュしていない場合は、`rebase` に `--whitespace=fix` オプションをつけて実行すれば、パッチを書き換えて空白問題を自動修正してくれます。

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

これで、Git が CRLF 問題の対応をすることもなくなりますし、`git show` や `git diff` を実行したときにもこのファイルの diff を調べることはなくなります。また､次のようなマクロ`binary`を使うこともできます。これは `-crlf -diff` と同じ意味です。

	*.pbxproj binary

#### バイナリファイルの差分 ####

Gitでは、バイナリファイルの差分を効果的に扱うためにGitの属性機能を使うことができます。通常のdiff機能を使って比較を行うことができるように、バイナリデータをテキストデータに変換する方法をGitに教えればいいのです。ただし問題があります。*バイナリ*データをどうやってテキストに変換するか？ということです。この場合、一番いい方法はバイナリファイル形式ごとに専用の変換ツールを使うことです。とはいえ、判読可能なテキストに変換可能なバイナリファイル形式はそう多くありません(音声データをテキスト形式に変換？うまくいかなさそうです...)。ただ、仮にそういった事例に出くわしデータをテキスト形式にできなかったとしても、ファイルの内容についての説明、もしくはメタデータを取得することはそれほど難しくないでしょう。もちろん、そのファイルについての全てがメタデータから読み取れるわけではありませんが、何もないよりはよっぽどよいはずです。

これから、上述の2手法を用い、よく使われてるバイナリファイル形式から有用な差分を取得する方法を説明します。

補足： バイナリファイル形式で、かつデータがテキストで記述されているけれど、テキスト形式に変換するためのツールがないケースがよくあります。そういった場合、`strings` プログラムを使ってそのファイルからテキストを抽出できるかどうか、試してみるとよいでしょう。UTF-16 などのエンコーディングで記述されている場合だと、`strings` プログラムではうまくいかないかもしれません。どこまで変換できるかはケースバイケースでしょう。とはいえ、`strings` プログラムは 大半の Mac と Linux で使えるので、バイナリファイル形式を取り扱う最初の一手としては十分でしょう。
 
##### MS Word ファイル #####

あなたはまずこれらのテクニックを使って、人類にとって最も厄介な問題のひとつ、Wordで作成した文書のバージョン管理を解決したいと思うでしょう。奇妙なことに、Wordは最悪のエディタだと全ての人が知っているにも係わらず、皆がWordを使っています。Word文書をバージョン管理したいと思ったなら、Gitのリポジトリにそれらを追加して、まとめてコミットすればいいのです。しかし、それでいいのでしょうか？ あなたが `git diff` をいつも通りに実行すると、次のように表示されるだけです。

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

これでは2つのバージョンをcheckoutしてそれらを自分で見比べてみない限り、比較することは出来ませんよね？ Gitの属性を使えば、うまく解決できます。`.gitattributes`に次の行を追加して下さい。

	*.doc diff=word

これは、指定したパターン(.doc)にマッチした全てのファイルに対して、差分を表示する時には"word"というフィルタを使うべきであるとGitに教えているのです。"word"フィルタとは何でしょうか？ それはあなたが用意しなければなりません。Word文書をテキストファイルに変換するプログラムとして `catdoc` を使うように次のようにGitを設定してみましょう。なお、`catdoc` とは、差分を正しく表示するために、Word文書からテキストを取り出す専用のツール( `http://www.wagner.pp.ru/~vitus/software/catdoc/` からダウンロードできます。)です。

	$ git config diff.word.textconv catdoc

このコマンドは、`.git/config` に次のようなセクションを追加します。

	[diff "word"]
		textconv = catdoc

これで、`.doc` という拡張子をもったファイルはそれぞれのファイルに `catdoc` というプログラムとして定義された"word"フィルタを通してからdiffを取るべきだということをGitは知っていることになります。こうすることで、Wordファイルに対して直接差分を取るのではなく、より効果的なテキストベースでの差分を取ることができるようになります。

例を示しましょう。この本の第1章をGitリポジトリに登録した後、ある段落にいくつかの文章を追加して保存し、それから、変更箇所を確認するために`git diff`を実行しました。

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -128,7 +128,7 @@ and data size)
	 Since its birth in 2005, Git has evolved and matured to be easy to use
	 and yet retain these initial qualities. It’s incredibly fast, it’s
	 very efficient with large projects, and it has an incredible branching
	-system for non-linear development.
	+system for non-linear development (See Chapter 3).

Gitは、追加した"(See Chapter 3)"という文字列を首尾よく、かつ、簡潔に知らせてくれました。正確で、申し分のない動作です！

##### OpenDocument Text ファイル #####

MS Word ファイル (`*.doc`) と同じ考えかたで、OpenOffice.org の OpenDocument Text ファイル (`*.odt`) も扱えます。

次の行を `.gitattributes` ファイルに追加しましょう。

	*.odt diff=odt

そして、`odt` diff フィルタを `.git/config` に追加します。

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

OpenDocument ファイルの正体は zip で、複数のファイル (XML 形式のコンテンツやスタイルシート、画像など) を含むディレクトリをまとめたものです。このコンテンツを展開し、プレーンテキストとして返すスクリプトが必要です。`/usr/local/bin/odt-to-txt` というファイルを作って (ディレクトリはどこでもかまいません)、次のような内容を書きましょう。

	#! /usr/bin/env perl
	# Simplistic OpenDocument Text (.odt) to plain text converter.
	# Author: Philipp Kempgen

	if (! defined($ARGV[0])) {
		print STDERR "No filename given!\n";
		print STDERR "Usage: $0 filename\n";
		exit 1;
	}

	my $content = '';
	open my $fh, '-|', 'unzip', '-qq', '-p', $ARGV[0], 'content.xml' or die $!;
	{
		local $/ = undef;  # slurp mode
		$content = <$fh>;
	}
	close $fh;
	$_ = $content;
	s/<text:span\b[^>]*>//g;           # remove spans
	s/<text:h\b[^>]*>/\n\n*****  /g;   # headers
	s/<text:list-item\b[^>]*>\s*<text:p\b[^>]*>/\n    --  /g;  # list items
	s/<text:list\b[^>]*>/\n\n/g;       # lists
	s/<text:p\b[^>]*>/\n  /g;          # paragraphs
	s/<[^>]+>//g;                      # remove all XML tags
	s/\n{2,}/\n\n/g;                   # remove multiple blank lines
	s/\A\n+//;                         # remove leading blank lines
	print "\n", $_, "\n\n";

そして実行権限をつけます。

	chmod +x /usr/local/bin/odt-to-txt

これで、`git diff` で `.odt` ファイルの変更点を確認できるようになりました。


##### 画像ファイル #####

その他の興味深い問題としては画像ファイルの差分があります。PNGファイルに対するひとつの方法としては、EXIF情報(多くのファイルでメタデータとして使われています)を抽出するフィルタを使う方法です。`exiftool`をダウンロードしインストールすれば、画像データをメタデータの形でテキストデータとして扱うことができます。従って、次のように設定すれば、画像データの差分をメタデータの差分という形で表示することができます。

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
	-File Modification Date/Time     : 2009:04:17 10:12:35-07:00
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

これで、プロジェクトのtarballを作成するために`git archive`を実行した時、アーカイブには`test/`ディレクトリが含まれないようになります。

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

フックはGitディレクトリの`hooks`サブディレクトリに格納されています。一般的なプロジェクトでは、`.git/hooks`がそれにあたります。Gitはデフォルトでこのディレクトリに例となるスクリプトを生成します。それらの多くはそのままでも十分有用ですし、引数も記載されています。全ての例は基本的にシェルスクリプトで書かれています。いくつかPerlを含むものもありますが、適切に命名されたそれらの実行可能スクリプトはうまく動きます。RubyやPython等で自作していただいてもかまいません｡それらのフックファイルの末尾は.sampleとなっていますので適時リネームしてください。

フックスクリプトを有効にするには、Gitディレクトリの`hooks`サブディレクトリに適切な名前の実行可能なファイルを配置する必要があります。これによってファイルが呼び出されることになります。ここでは重要なフックファイル名をいくつか取り上げます。

### クライアントサイドフック ###

クライアントサイドフックにはたくさんの種類があります。ここではコミットワークフローフック、Eメールワークフロースクリプト、その他クライアントサイドフックに分類します。

#### コミットワークフローフック ####

最初の4つのフックはコミットプロセスに関するものです。`pre-commit`フックはコミットメッセージが入力される前に実行されます。これはいまからコミットされるであろうスナップショットを検査したり、何かし忘れた事を確認したり、事前にテストを実行したり、何かしらコードを検査する目的で使用されます。`git commit --no-verify`で回避することもできますが、このフックから0でない値が返るとコミットが中断されます。コーディングスタイルの検査（lintを実行する等）や、行末の空白文字の検査（デフォルトのフックがまさにそうです）、新しく追加されたメソッドのドキュメントが正しいかどうかの検査といったことが可能です。

`prepare-commit-msg`フックは、コミットメッセージエディターが起動する直前、デフォルトメッセージが生成された直後に実行されます。コミットの作者がそれを目にする前にデフォルトメッセージを編集することができます。このフックはオプションを必要とします: 現在までのコミットメッセージを保存したファイルへのパス、コミットのタイプ、さらにamendされたコミットの場合はコミットSHA-1が必要です。このフックは普段のコミットにおいてあまり有用ではありませんが、テンプレートのコミットメッセージ・mergeコミット・squashコミット・amendコミットのようなデフォルトメッセージが自動で挿入されるコミットにおいて効果を発揮します。テンプレートのコミットメッセージと組み合わせて、動的な情報をプログラムで挿入することができます。

`commit-msg`フックも、現在のコミットメッセージを保存した一時ファイルへのパスをパラメータに持つ必要があります。このスクリプトが0以外の値を返した場合Gitはコミットプロセスを中断しますので、プロジェクトの状態や許可待ちになっているコミットメッセージを有効にすることができます 。この章の最後のセクションでは、このフックを使用してコミットメッセージが要求された様式に沿っているか検査するデモンストレーションを行います。

コミットプロセスが全て完了した後に、`post-commit`フックが実行されます。パラメータは必要無く、`git log -1 HEAD`を実行することで直前のコミットを簡単に取り出すことができます。一般的にこのスクリプトは何かしらの通知といった目的に使用されます。

コミットワークフロークライアントサイドスクリプトはあらゆるワークフローに使用することができます。clone中にスクリプトが転送される事はありませんが、これらはしばしばサーバー側で決められたポリシーを強制する目的で使用されます。これらのスクリプトは開発者を支援するために存在するのですから、いつでもオーバーライドされたり変更されたりすることがありえるとしても開発者らによってセットアップされ、メンテナンスされてしかるべきです。

#### Eメールワークフローフック ####

Eメールを使ったワークフロー用として、三種類のクライアントサイドフックを設定することができます。これらはすべて `git am` コマンドに対して起動されるものなので、ふだんの作業でこのコマンドを使っていない場合は次のセクションを読み飛ばしてもかまいません。`git format-patch` で作ったパッチを受け取ることがある場合は、ここで説明する内容が有用になるかもしれません。

まず最初に実行されるフックは `applypatch-msg` です。これは引数をひとつだけ受け取ります。コミットメッセージを含む一時ファイル名です。このスクリプトがゼロ以外の値で終了した場合、Git はパッチの処理を強制終了させます。このフックを使うと、コミットメッセージの書式が正しいかどうかを確認したり、スクリプトで正しい書式に手直ししたりすることができます。

`git am` でパッチを適用するときに二番目に実行されるフックは `pre-applypatch` です。これは引数を受け取らず、パッチが適用された後に実行されます。このフックを使うと、パッチ適用後の状態をコミットする前に調べることができます。つまり、このスクリプトでテストを実行したり、その他の調査をしたりといったことができるということです。なにか抜けがあったりテストが失敗したりした場合はスクリプトをゼロ以外の値で終了させます。そうすれば、`git am` はパッチをコミットせずに強制終了します。

`git am` において最後に実行されるフックは `post-applypatch` です。これを使うと、グループのメンバーやそのパッチの作者に対して処理の完了を伝えることができます。このスクリプトでは、パッチの適用を中断させることはできません。

#### その他のクライアントフック ####

`pre-rebase` フックは何かをリベースする前に実行され、ゼロ以外を返すとその処理を中断させることができます。このフックを使うと、既にプッシュ済みのコミットのリベースを却下することができます。Gitに含まれているサンプルの `pre-rebase` フックがちょうどこの働きをします。ただしこのサンプルは、公開ブランチの名前が next であることを想定したものです。実際に使っている安定版公開ブランチの名前に変更する必要があるでしょう。

`git checkout` が正常に終了すると、`post-checkout` フックが実行されます。これを使うと、作業ディレクトリを自分のプロジェクトの環境にあわせて設定することができます。たとえば、バージョン管理対象外の巨大なバイナリファイルや自動生成ドキュメントなどを作業ディレクトリに取り込むといった処理です。

最後に説明する `post-merge` フックは、`merge` コマンドが正常に終了したときに実行されます。これを使うと、Git では追跡できないパーミッション情報などを作業ツリーに復元することができます。作業ツリーに変更が加わったときに取り込みたい Git の管理対象外のファイルの存在確認などにも使えます。

### サーバーサイドフック ###

クライアントサイドフックの他に、いくつかのサーバーサイドフックを使うこともできます。これは、システム管理者がプロジェクトのポリシーを強制させるために使うものです。これらのスクリプトは、サーバへのプッシュの前後に実行されます。pre フックをゼロ以外の値で終了させると、プッシュを却下してエラーメッセージをクライアントに返すことができます。つまり、プッシュに関するポリシーをここで設定することができるということです。

#### pre-receive および post-receive ####

クライアントからのプッシュを処理するときに最初に実行されるスクリプトが `pre-receive` です。このスクリプトは、プッシュされた参照のリストを標準入力から受け取ります。ゼロ以外の値で終了させると、これらはすべて却下されます。このフックを使うと、更新内容がすべてfast-forwardであることをチェックしたり、プッシュしてきたユーザーがそれらのファイルに対する適切なアクセス権を持っているかを調べたりといったことができます。

`post-receive` フックは処理が終了した後で実行されるもので、他のサービスの更新やユーザーへの通知などに使えます。`pre-receive` フックと同様、データを標準入力から受け取ります。サンプルのスクリプトには、メーリングリストへの投稿や継続的インテグレーションサーバーへの通知、チケット追跡システムの更新などの処理が含まれています。コミットメッセージを解析して、チケットのオープン・修正・クローズなどの必要性を調べることだってできます。このスクリプトではプッシュの処理を中断させることはできませんが、クライアント側ではこのスクリプトが終了するまで接続を切断することができません。このスクリプトで時間のかかる処理をさせるときには十分注意しましょう。

#### update ####

update スクリプトは `pre-receive` スクリプトと似ていますが、プッシュしてきた人が更新しようとしているブランチごとに実行されるという点が異なります。複数のブランチへのプッシュがあったときに `pre-receive` が実行されるのは一度だけですが、update はブランチ単位でそれぞれ一度ずつ実行されます。このスクリプトは、標準入力を読み込むのではなく三つの引数を受け取ります。参照 (ブランチ) の名前、プッシュ前を指す参照の SHA-1、そしてプッシュしようとしている参照の SHA-1 です。update スクリプトをゼロ以外で終了させると、その参照のみが却下されます。それ以外の参照はそのまま更新を続行します。

## Git ポリシーの実施例 ##

このセクションでは、これまでに学んだ内容を使って実際に Git のワークフローを確立してみます。コミットメッセージの書式をチェックし、プッシュは fast-forward 限定にし、そしてプロジェクト内の各サブディレクトリに対して特定のユーザーだけが変更を加えられるようにするというものです。開発者に対して「なぜプッシュが却下されたのか」を伝えるためのクライアントスクリプト、そして実際にそのポリシーを実施するためのサーバースクリプトを作成します。

スクリプトは Ruby を使って書きます。その理由のひとつは私が Ruby を好きなこと、そしてもうひとつの理由はその他のスクリプト言語の疑似コードとしてもそれっぽく見えるであろうということです。Ruby 使いじゃなくても、きっとコードの大まかな流れは追えるはずです。しかし、Ruby 以外の言語であってもきちんと動作します。Git に同梱されているサンプルスクリプトはすべて Perl あるいは Bash で書かれているので、それらの言語のサンプルも大量に見ることができます。

### サーバーサイドフック ###

サーバーサイドの作業は、すべて hooks ディレクトリの update ファイルにまとめます。update ファイルはプッシュされるブランチごとに実行されるもので、プッシュされる参照と操作前のブランチのリビジョン、そしてプッシュされる新しいリビジョンを受け取ります。また、SSH 経由でのプッシュの場合は、プッシュしたユーザーを知ることもできます。全員に共通のユーザー ("git" など) を使って公開鍵認証をさせている場合は、公開鍵の情報に基づいて実際のユーザーを判断して環境変数を設定するというラッパーが必要です。ここでは、接続しているユーザー名が環境変数 `$USER` に格納されているものとします。スクリプトは、まずこれらの情報を取得するところから始まります。

	#!/usr/bin/env ruby

	refname = ARGV[0]
	oldrev  = ARGV[1]
	newrev  = ARGV[2]
	user    = ENV['USER']

	puts "Enforcing Policies... \n(#{refname}) (#{oldrev[0,6]}) (#{newrev[0,6]})"

#### 特定のコミットメッセージ書式の強制 ####

まずは、コミットメッセージを特定の書式に従わせることに挑戦してみましょう。ここでは、コミットメッセージには必ず "ref: 1234" 形式の文字列を含むこと、というルールにします。個々のコミットをチケットシステムとリンクさせたいという意図です。やらなければならないことは、プッシュされてきた各コミットのコミットメッセージにその文字列があるかどうかを調べ、もしなければゼロ以外の値で終了してプッシュを却下することです。

プッシュされたすべてのコミットの SHA-1 値を取得するには、`$newrev` と `$oldrev` の内容を `git rev-list` という低レベル Git コマンドに渡します。これは基本的には `git log` コマンドのようなものですが、デフォルトでは SHA-1 値だけを表示してそれ以外の情報は出力しません。ふたつのコミットの間のすべてのコミットの SHA を得るには、次のようなコマンドを実行します。

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

この出力を受け取ってループさせて各コミットの SHA を取得し、個々のメッセージを取り出し、正規表現でそのメッセージを調べることができます。

さて、これらのコミットからコミットメッセージを取り出す方法を見つけなければなりません。生のコミットデータを取得するには、別の低レベルコマンド `git cat-file` を使います。低レベルコマンドについては第 9 章で詳しく説明しますが、とりあえずはこのコマンドがどんな結果を返すのだけを示します。

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

SHA-1 値がわかっているときにコミットからコミットメッセージを得るシンプルな方法は、空行を探してそれ以降をすべて取得するというものです。これには、Unix システムの `sed` コマンドが使えます。

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

この呪文を使ってコミットメッセージを取得し、もし条件にマッチしないものがあれば終了させればよいのです。スクリプトを抜けてプッシュを却下するには、ゼロ以外の値で終了させます。以上を踏まえると、このメソッドは次のようになります。

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

これを `update` スクリプトに追加すると、ルールを守らないコミットメッセージが含まれるコミットのプッシュを却下するようになります。

#### ユーザーベースのアクセス制御 ####

アクセス制御リスト (ACL) を使って、ユーザーごとにプロジェクトのどの部分を変更できるのかを指定できるようにしてみましょう。全体にアクセスできるユーザーもいれば、特定のサブディレクトリやファイルだけにしか変更をプッシュできないユーザーもいる、といった仕組みです。これを実施するには、ルールを書いたファイル `acl` をサーバー上のベア Git リポジトリに置きます。`update` フックにこのファイルを読ませ、プッシュされたコミットにどのファイルが含まれているのかを調べ、そしてプッシュしたユーザーがそれらのファイルを変更する権限があるのかどうかを判断します。

まずは ACL を作るところから始めましょう。ここでは、CVS の ACL と似た書式を使います。これは各項目を一行で表すもので、最初のフィールドは `avail` あるいは `unavail`、そして次の行がそのルールを適用するユーザーの一覧 (カンマ区切り)、そして最後のフィールドがそのルールを適用するパス (ブランクは全体へのアクセスを意味します) です。フィールドの区切りには、パイプ文字 (`|`) を使います。

ここでは、全体にアクセスする管理者と `doc` ディレクトリにアクセスするドキュメント担当者、そして `lib` と `tests` サブディレクトリだけにアクセスできる開発者を設定します。ACL ファイルは次のようになります。

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

まずはこのデータを読み込んで、スクリプト内で使えるデータ構造にしてみましょう。例をシンプルにするために、ここでは `avail` ディレクティブだけを使います。次のメソッドは連想配列を返すものです。ユーザー名が配列のキー、そのユーザーが書き込み権を持つパスの配列が対応する値となります。

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

先ほどの ACL ファイルをこの `get_acl_access_data` メソッドに渡すと、このようなデータ構造を返します。

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

これで権限がわかったので、あとはプッシュされた各コミットがどのパスを変更しようとしているのかを調べれば、そのユーザーがプッシュすることができるのかどうかを判断できます。

あるコミットでどのファイルが変更されるのかを知るのはとても簡単で、`git log` コマンドに `--name-only` オプションを指定するだけです (第 2 章で簡単に説明しました)。

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

`get_acl_access_data` メソッドが返す ACL のデータとこのファイルリストを付き合わせれば、そのユーザーがコミットをプッシュする権限があるかどうかを判断できます。

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
	        if !access_path || # user has access to everything
	          (path.index(access_path) == 0) # access to this path
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

それほど難しい処理ではありません。まず最初に `git rev-list` でコミットの一覧を取得し、それぞれに対してどのファイルが変更されるのかを調べ、ユーザーがそのファイルを変更する権限があることを確かめています。Ruby を知らない人にはわかりにくいところがあるとすれば `path.index(access_path) == 0` でしょうか。これは、パスが `access_path` で始まるときに真となります。つまり、`access_path` がパスの一部に含まれるのではなく、パスがそれで始まっているということを確認しています。

これで、まずい形式のコミットメッセージや権利のないファイルの変更を含むコミットはプッシュできなくなりました。

#### Fast-Forward なプッシュへの限定 ####

最後は、fast-forward なプッシュに限るという仕組みです。 `receive.denyDeletes` および `receive.denyNonFastForwards` という設定項目で設定できます｡また､フックを用いてこの制限を課すこともできますし､特定のユーザーにだけこの制約を加えたいなどといった変更にも対応できます。

これを調べるには、旧リビジョンからたどれるすべてのコミットについて、新リビジョンから到達できないものがないかどうかを探します。もしひとつもなければ、それは fast-forward なプッシュです。ひとつでも見つかれば、却下することになります。

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

これですべてがととのいました。これまでのコードを書き込んだファイルに対して `chmod u+x .git/hooks/update` を実行し、fast-forward ではない参照をプッシュしてみましょう。すると、こんなメッセージが表示されるでしょう。

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

この中には、いくつか興味深い点があります。まず、フックの実行が始まったときの次の表示に注目しましょう。

	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)

これは、スクリプトの先頭で標準出力に表示した内容でした。ここで重要なのは「スクリプトから標準出力に送った内容は、すべてクライアントにも送られる」ということです。

次に注目するのは、エラーメッセージです。

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

最初の行はスクリプトから出力したもので、その他の 2 行は Git が出力したものです。この 2 行では、スクリプトがゼロ以外の値で終了したためにプッシュが却下されたということを説明しています。最後に、次の部分に注目します。

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

フックで却下したすべての参照について、remote rejected メッセージが表示されます。これを見れば、フック内での処理のせいで却下されたのだということがわかります。

さらに、もしコミットメッセージに適切な ref が含まれていなければ、それを示す次のようなエラーメッセージが表示されるでしょう。

	[POLICY] Your message is not formatted correctly

また、変更権限のないファイルを変更してそれを含むコミットをプッシュしようとしたときも、同様にエラーが表示されます。たとえば、ドキュメント担当者が `lib` ディレクトリ内の何かを変更しようとした場合のメッセージは次のようになります。

	[POLICY] You do not have access to push to lib/test.rb

以上です。この `update` スクリプトが動いてさえいれば、もう二度とリポジトリが汚されることはありません。コミットメッセージは決まりどおりのきちんとしたものになるし、ユーザーに変なところをさわられる心配もなくなります。

### クライアントサイドフック ###

この方式の弱点は、プッシュが却下されたときにユーザーが泣き寝入りせざるを得なくなるということです。手間暇かけて仕上げた作業が最後の最後で却下されるというのは、非常にストレスがたまるし不可解です。プッシュするためには歴史を修正しなければならないのですが、気弱な人にとってそれはかなりつらいことです。

このジレンマに対する答えとして、サーバーが却下するであろう作業をするときにそれをユーザーに伝えるためのクライアントサイドフックを用意します。そうすれば、何か問題があるときにそれをコミットする前に知ることができるので、取り返しのつかなくなる前に問題を修正することができます。プロジェクトをクローンしてもフックはコピーされないので、別の何らかの方法で各ユーザーにスクリプトを配布しなければなりません。各ユーザーはそれを `.git/hooks` にコピーし、実行可能にします。フックスクリプト自体をプロジェクトに含めたり別のプロジェクトにしたりすることはできますが、各自の環境でそれをフックとして自動的に設定することはできないのです。

はじめに、コミットを書き込む直前にコミットメッセージをチェックしなければなりません。そして、サーバーに却下されないようにコミットメッセージの書式を調べるのです。そのためには `commit-msg` フックを使います。最初の引数で渡されたファイルからコミットメッセージを読み込んでパターンと比較し、もしマッチしなければ Git の処理を中断させます。

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

このスクリプトを適切な場所 (`.git/hooks/commit-msg`) に置いて実行可能にしておくと、不適切なメッセージを書いてコミットしようとしたときに次のような結果となります。

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

このとき、実際にはコミットされません。もしメッセージが適切な書式になっていれば、Git はコミットを許可します。

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

次に、ACL で決められた範囲以外のファイルを変更していないことを確認しましょう。先ほど使った ACL ファイルのコピーがプロジェクトの `.git` ディレクトリにあれば、次のような `pre-commit` スクリプトでチェックすることができます。

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

大まかにはサーバーサイドのスクリプトと同じですが、重要な違いがふたつあります。まず、ACL ファイルの場所が違います。このスクリプトは作業ディレクトリから実行するものであり、Git ディレクトリから実行するものではないからです。ACL ファイルの場所を、先ほどの

	access = get_acl_access_data('acl')

から次のように変更しなければなりません。

	access = get_acl_access_data('.git/acl')

もうひとつの違いは、変更されたファイルの一覧を取得する方法です。サーバーサイドのメソッドではコミットログを調べていました。しかしこの時点ではまだコミットが記録されていないので、ファイルの一覧はステージング・エリアから取得しなければなりません。つまり、先ほどの

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

は次のようになります。

	files_modified = `git diff-index --cached --name-only HEAD`

しかし、違うのはこの二点だけ。それ以外はまったく同じように動作します。ただ、このスクリプトは、ローカルで実行しているユーザーとリモートマシンにプッシュするときのユーザーが同じであることを前提にしています。もし異なる場合は、変数 `$user` を手動で設定しなければなりません。

最後に残ったのは fast-forward でないプッシュを止めることですが、これは多少特殊です。fast-forward でない参照を取得するには、すでにプッシュした過去のコミットにリベースするか、別のローカルブランチにリモートブランチと同じところまでプッシュしなければなりません。

サーバーサイドでは fast-forward ではないプッシュをできないようにしているので、それ以外にあり得るのは、すでにプッシュ済みのコミットをリベースしようとするときくらいです。

それをチェックする pre-rebase スクリプトの例を示します。これは書き換えようとしているコミットの一覧を取得し、それがリモート参照の中に存在するかどうかを調べます。リモート参照から到達可能なコミットがひとつでもあれば、リベースを中断します。

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
	    if shas_pushed.split("\n").include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

このスクリプトでは、第 6 章の「リビジョンの選択」ではカバーしていない構文を使っています。既にプッシュ済みのコミットの一覧を得るために、次のコマンドを実行します。

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

`SHA^@` 構文は、そのコミットのすべての親を解決します。リモートの最後のコミットから到達可能で、これからプッシュしようとするコミットの親のいずれかからアクセスできないコミットを探します。

この方式の弱点は非常に時間がかかることで、多くの場合このチェックは不要です。`-f` つきで強制的にプッシュしようとしない限り、サーバーが警告を出してプッシュできないからです。しかし練習用の課題としてはおもしろいもので、あとでリベースを取り消してやりなおすはめになることを理屈上は防げるようになります。

## まとめ ##

Git クライアントとサーバーをカスタマイズして自分たちのプロジェクトやワークフローにあてはめるための主要な方法を説明しました。あらゆる設定項目やファイルベースの属性、そしてイベントフックについて学び、特定のポリシーを実現するサーバーを構築するサンプルを示しました。これで、あなたが思い描くであろうほぼすべてのワークフローにあわせて Git を調整できるようになったはずです。
