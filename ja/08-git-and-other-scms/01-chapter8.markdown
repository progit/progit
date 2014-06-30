# Gitとその他のシステムの連携 #

世の中はそんなにうまくいくものではありません。あなたが関わることになったプロジェクトで使うバージョン管理システムを、すぐさまGitに切り替えられることはほとんどないでしょう。また、関わっているプロジェクトが他のVCSを使っていることも時々あるでしょうし、多くの場合 Subversion が使われているのではないかと思います。この章の前半では、まず Subversion と Git を繋ぐ双方向ゲートウェイである `git svn` について説明します。

どこかの時点で、プロジェクトで Git を使うようにしたくなることもあるでしょう。この章の後半では、プロジェクトのVCSを Git へ移行する方法について説明します。Subversion と Perforce からの移行について説明したあと、特殊なケースにおいてスクリプトを使ったインポートの方法を説明します。

## Git と Subversion ##

現在のところ、オープンソースや企業のプロジェクトの大多数が、ソースコードの管理に Subversion を利用しています。Subversion は最も人気のあるオープンソースのVCSで、10年近く前から使われています。Subversion 以前は CVS がソースコード管理に広く用いられていたのですが、多くの点で両者はよく似ています。

Git の素晴しい機能のひとつに、Git と Subversion を双方向にブリッジする `git svn` があります。このツールを使うと、Subversion のクライアントとして Git を使うことができます。つまり、ローカルの作業では Git の機能を十分に活用することができて、あたかも Subversion を使っているかのように Subversion サーバーに変更をコミットすることができます。共同作業をしている人達が古き良き方法を使っているのと
同時に、ローカルでのブランチ作成やマージ、ステージング・エリア、リベース、チェリーピックなどの Git の機能を使うことができるということです。共同の作業環境に Git を忍び込ませておいて、仲間の開発者たちが Git より効率良く作業できるように手助けをしつつ、Git の全面的な採用のための根回しをしてゆく、というのが賢いやり方です。Subversion ブリッジは、分散VCS の素晴しい世界へのゲートウェイ・ドラッグといえるでしょう。

### git svn ###

Git と Subversion の橋渡しをするコマンド群のベースとなるコマンドが `git svn` です。すべてはここから始めることができます。この後に続くコマンドはかなりたくさんあるので、いくつかのワークフローを通して一般的なものから身につけていきましょう。

注意すべきことは、`git svn` を使っているときは Subversion を相手にしているのだということです。これは、Git ほど洗練されてはいません。ローカルでのブランチ作成やマージは簡単にできますが、作業内容をリベースするなどして歴史をできるだけ一直線に保つようにし、Git リモートリポジトリを相手にするときのように考えるのは避けましょう。

歴史を書き換えてもう一度プッシュしようなどとしてはいけません。また、他の開発者との共同作業のために複数の Git リポジトリに並行してプッシュするのもいけません。Subversion が扱えるのは一本の直線上の歴史だけで、ちょっとしたことですぐに混乱してしまいます。チームのメンバーの中に SVN を使う人と Git を使う人がいる場合は、全員が SVN サーバーを使って共同作業するようにしましょう。そうすれば、少しは生きやすくなります。

### 準備 ###

この機能を説明するには、書き込みアクセス権を持つ標準的な SVN リポジトリが必要です。もしこのサンプルをコピーして試したいのなら、私のテスト用リポジトリの書き込み可能なコピーを作らなければなりません。これを簡単に行うには、`svnsync` というツールを使います。最近のバージョンの Subversion、少なくとも 1.4 以降に付属しているツールです。テスト用として、新しい Subversion リポジトリを Google code 上に作りました。これは `protobuf` プロジェクトの一部で、`protobuf` は構造化されたデータを符号化してネットワーク上で転送するためのツールです。

まずはじめに、新しいローカル Subversion リポジトリを作ります。

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

そして、すべてのユーザーが revprop を変更できるようにします。簡単な方法は、常に 0 で終了する pre-revprop-change スクリプトを追加することです。

	$ cat /tmp/test-svn/hooks/pre-revprop-change
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

これで、ローカルマシンにこのプロジェクトを同期できるようになりました。同期元と同期先のリポジトリを指定して `svnsync init` を実行します。

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/

このコマンドは、同期を実行するためのプロパティを設定します。次に、このコマンドでコードをコピーします。

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

この操作は数分で終わりますが、もし元のリポジトリのコピー先がローカルではなく別のリモートリポジトリだった場合、この処理には約一時間かかります。総コミット数はたかだか 100 にも満たないにもかかわらず。Subversion では、リビジョンごとにクローンを作ってコピー先のリポジトリに投入していかなければなりません。これはばかばかしいほど非効率的ですが、簡単に済ませるにはこの方法しかないのです。

### はじめましょう ###

書き込み可能な Subversion リポジトリが手に入ったので、一般的なワークフローに沿って進めましょう。まずは `git svn clone` コマンドを実行します。このコマンドは、Subversion リポジトリ全体をローカルの Git リポジトリにインポートします。どこかにホストされている実際の Subversion リポジトリから取り込む場合は `file:///tmp/test-svn` の部分を Subversion リポジトリの URL に変更しましょう。

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

これは、指定した URL に対して `git svn init` に続けて `git svn fetch` を実行するのと同じ意味です。しばらく時間がかかります。test プロジェクトには 75 のコミットしかなくてコードベースもそれほど大きくないので、数分しかかかりません。しかし、Git は各バージョンをそれぞれチェックアウトしては個別にコミットしています。もし数百数千のコミットがあるプロジェクトで試すと、終わるまでには数時間から下手をすると数日かかってしまうかもしれません。

`-T trunk -b branches -t tags` の部分は、この Subversion リポジトリが標準的なブランチとタグの規約に従っていることを表しています。trunk、branches、tags にもし別の名前をつけているのなら、この部分を変更します。この規約は一般に使われているものなので、単に `-s` とだけ指定することもできます。これは、先の 3 つのオプションを指定したのと同じ標準のレイアウトを表します。つまり、次のようにしても同じ意味になるということです。

	$ git svn clone file:///tmp/test-svn -s

これで、ブランチやタグも取り込んだ Git リポジトリができあがりました。

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

このツールがリモート参照を取り込むときの名前空間が通常と異なることに注意しましょう。Git リポジトリのクローンを作成した場合は、リモートサーバー上のすべてのブランチが `origin/[branch]` のような形式で取り込まれます。つまりリモートの名前で名前空間が作られます。しかし、`git svn` はリモートが複数あることを想定しておらず、すべてのリモートサーバーを名前空間なしに保存します。Git のコマンド `show-ref` を使うと、すべての参照名を完全な形式で見ることができます。

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

通常の Git リポジトリは、このようになります。

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

2 つのリモートサーバーがあり、一方の `gitserver` には `master` ブランチが、そしてもう一方の `origin` には `master` と `testing` の 2 つのブランチがあります。

サンプルのリモート参照が `git svn` でどのように取り込まれたかに注目しましょう。タグはリモートブランチとして取り込まれており、Git のタグにはなっていません。Subversion から取り込んだ内容は、まるで tags という名前のリモートからブランチを取り込んだように見えます。

### Subversion へのコミットの書き戻し ###

作業リポジトリを手に入れたあなたはプロジェクト上で何らかの作業を終え、コミットを上流に書き戻すことになりました。Git を SVN クライアントとして使います。どれかひとつのファイルを変更してコミットした時点では、Git上でローカルに存在するそのコミットはSubversionサーバー上には存在しません。

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

次に、これをプッシュして上流を変更しなければなりません。この変更が Subversion に対してどのように作用するのかに注意しましょう。オフラインで行った複数のコミットを、すべて一度に Subversion サーバーにプッシュすることができます。Subversion サーバーにプッシュするには `git svn dcommit` コマンドを使います。

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

このコマンドは、Subversionサーバーからのコード上で行われたすべてのコミットに対して個別に Subversion 上にコミットし、ローカルの Git のコミットを書き換えて一意な識別子を含むようにします。ここで重要なのは、書き換えによってすべてのローカルコミットの SHA-1 チェックサムが変化するということです。この理由もあって、Git ベースのリモートリポジトリにあるプロジェクトと Subversion サーバーを同時に使うことはおすすめできません。直近のコミットを調べれば、新たに `git-svn-id` が追記されたことがわかります。

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

元のコミットの SHA チェックサムが `97031e5` で始まっていたのに対して今は `938b1a5` に変わっていることに注目しましょう。Git と Subversion の両方のサーバーにプッシュしたい場合は、まず Subversion サーバーにプッシュ (`dcommit`) してから Git のほうにプッシュしなければなりません。dcommit でコミットデータが書き換わるからです。

### 新しい変更の取り込み ###

複数の開発者と作業をしていると、遅かれ早かれ、誰かがプッシュしたあとに他の人がプッシュしようとして衝突を起こすということが発生します。他の人の作業をマージするまで、その変更は却下されます。`git svn` では、このようになります。

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

この状態を解決するには `git svn rebase` を実行します。これは、サーバー上の変更のうちまだ取り込んでいない変更をすべて取り込んでから、自分の作業をリベースします。

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

これで手元の作業が Subversion サーバー上の最新状態の上でなされたことになったので、無事に `dcommit` することができます。

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

ここで注意すべき点は、Git の場合は上流での変更をすべてマージしてからでなければプッシュできないけれど、`git svn` の場合は衝突さえしなければマージしなくてもプッシュできるということです。だれかがあるファイルを変更した後で自分が別のファイルを変更してプッシュしても、`dcommit` は正しく動作します。

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

これは忘れずに覚えておきましょう。というのも、プッシュした後の結果はどの開発者の作業環境にも存在しない状態になっているからです。たまたま衝突しなかっただけで互換性のない変更をプッシュしてしまったときに、その問題を見つけるのが難しくなります。これが、Git サーバーを使う場合と異なる点です。Git の場合はクライアントの状態をチェックしてからでないと変更を公開できませんが、SVN の場合はコミットの直前とコミット後の状態が同等であるかどうかすら確かめられないのです。

もし自分のコミット準備がまだできていなくても、Subversion から変更を取り込むときにもこのコマンドを使わなければなりません。`git svn fetch` でも新しいデータを取得することはできますが、`git svn rebase` はデータを取得するだけでなくローカルのコミットの更新も行います。

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

`git svn rebase` をときどき実行しておけば、手元のコードを常に最新の状態に保っておけます。しかし、このコマンドを実行するときには作業ディレクトリがクリーンな状態であることを確認しておく必要があります。手元で変更をしている場合は、stash で作業を退避させるか一時的にコミットしてからでないと `git svn rebase` を実行してはいけません。さもないと、もしリベースの結果としてマージが衝突すればコマンドの実行が止まってしまいます。

### Git でのブランチに関する問題 ###

Git のワークフローに慣れてくると、トピックブランチを作ってそこで作業を行い、それをマージすることもあるでしょう。`git svn` を使って Subversion サーバーにプッシュする場合は、それらのブランチをまとめてプッシュするのではなく一つのブランチ上にリベースしてからプッシュしたくなるかもしれません。リベースしたほうがよい理由は、Subversion はリニアに歴史を管理していて Git のようなマージができないからです。`git svn` がスナップショットを Subversion のコミットに変換するときには、最初の親だけに続けます。

歴史が次のような状態になっているものとしましょう。`experiment` ブランチを作ってそこで 2 回のコミットを済ませ、それを `master` にマージしたところです。ここで `dcommit` すると、出力はこのようになります。

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

歴史をマージしたブランチで `dcommit` を実行してもうまく動作します。ただし、Git プロジェクト上での歴史を見ると、`experiment` ブランチ上でのコミットは書き換えられていません。そこでのすべての変更は、SVN 上での単一のマージコミットとなっています。

他の人がその作業をクローンしたときには、すべての作業をひとまとめにしたマージコミットしか見ることができません。そのコミットがどこから来たのか、そしていつコミットされたのかを知ることができないのです。

### Subversion のブランチ ###

Subversion のブランチは Git のブランチとは異なります。可能ならば、Subversion のブランチは使わないようにするのがベストでしょう。しかし、Subversion のブランチの作成やコミットも、`git svn` を使ってすることができます。

#### 新しい SVN ブランチの作成 ####

Subversion に新たなブランチを作るには `git svn branch [branchname]` を実行します。

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

これは Subversion の `svn copy trunk branches/opera` コマンドと同じ意味で、Subversion サーバー上で実行されます。ここで注意すべき点は、このコマンドを実行しても新しいブランチに入ったことにはならないということです。この後コミットをすると、そのコミットはサーバーの `trunk` に対して行われます。`opera` ではありません。

### アクティブなブランチの切り替え ###

Git が dcommit の行き先のブランチを決めるときには、あなたの手元の歴史上にある Subversion ブランチのいずれかのヒントを使います。手元にはひとつしかないはずで、それは現在のブランチの歴史上の直近のコミットにある `git-svn-id` です。

複数のブランチを同時に操作するときは、ローカルブランチを `dcommit` でその Subversion ブランチにコミットするのかを設定することができます。そのためには、Subversion のブランチをインポートしてローカルブランチを作ります。`opera` ブランチを個別に操作したい場合は、このようなコマンドを実行します。

	$ git branch opera remotes/opera

これで、`opera` ブランチを `trunk` (手元の `master` ブランチ) にマージするときに通常の `git merge` が使えるようになりました。しかし、そのときには適切なコミットメッセージを (`-m` で) 指定しなければなりません。さもないと、有用な情報ではなく単なる "Merge branch opera" というメッセージになってしまいます。

`git merge` を使ってこの操作を行ったとしても、そしてそれが Subversion でのマージよりもずっと簡単だったとしても (Git は自動的に適切なマージベースを検出してくれるからね)、これは通常の Git のマージコミットとは違うということを覚えておきましょう。このデータを Subversion に書き戻すことになりますが Subversion では複数の親を持つコミットは処理できません。そのため、プッシュした後は、別のブランチ上で行ったすべての操作をひとまとめにした単一のコミットに見えてしまいます。あるブランチを別のブランチにマージしたら、元のブランチに戻って作業を続けるのは困難です。Git なら簡単なのですが。`dcommit` コマンドを実行すると、どのブランチからマージしたのかという情報はすべて消えてしまいます。そのため、それ以降のマージ元の算出は間違ったものとなります。dcommit は、`git merge` の結果をまるで `git merge --squash` を実行したのと同じ状態にしてしまうのです。残念ながら、これを回避するよい方法はありません。Subversion 側にこの情報を保持する方法がないからです。Subversion をサーバーに使う以上は、常にこの制約に縛られることになります。問題を回避するには、trunk にマージしたらローカルブランチ (この場合は `opera`) を削除しなければなりません。

### Subversion コマンド ###

`git svn` ツールセットには、Git への移行をしやすくするための多くのコマンドが用意されています。Subversion で使い慣れていたのと同等の機能を提供するコマンド群です。その中からいくつかを紹介します。

#### SVN 形式のログ ####

Subversion に慣れているので SVN が出力する形式で歴史を見たい、という場合は `git svn log` を実行しましょう。すると、コミットの歴史が SVN 形式で表示されます。

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines

	updated the changelog

`git svn log` に関して知っておくべき重要なことがふたつあります。まず。このコマンドはオフラインで動作します。実際の `svn log` コマンドのように Subversion サーバーにデータを問い合わせたりしません。次に、すでに Subversion サーバーにコミット済みのコミットしか表示されません。つまり、ローカルの Git へのコミットのうちまだ dcommit していないものは表示されないし、その間に他の人が Subversion サーバーにコミットした内容も表示されません。最後に Subversion サーバーの状態を調べたときのログが表示されると考えればよいでしょう。

#### SVN アノテーション ####

`git svn log` コマンドが `svn log` コマンドをオフラインでシミュレートしているのと同様に、`svn annotate` と同様のことを `git svn blame [FILE]` で実現できます。出力は、このようになります。

	$ git svn blame README.txt
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal
	79    schacon Committing in git-svn.
	78    schacon
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal

先ほどと同様、このコマンドも Git にローカルにコミットした内容や他から Subversion にプッシュされていたコミットは表示できません。

#### SVN サーバ情報 ####

`svn info` と同様のサーバー情報を取得するには `git svn info` を実行します。

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

`blame` や `log` と同様にこれもオフラインで動作し、最後に Subversion サーバーと通信した時点での情報しか表示されません。

#### Subversion が無視するものを無視する ####

どこかに `svn:ignore` プロパティが設定されている Subversion リポジトリをクローンした場合は、対応する `.gitignore` ファイルを用意したくなることでしょう。コミットすべきではないファイルを誤ってコミットしてしまうことを防ぐためにです。`git svn` には、この問題に対応するためのコマンドが二つ用意されています。まず最初が `git svn create-ignore` で、これは、対応する `.gitignore` ファイルを自動生成して次のコミットに含めます。

もうひとつは `git svn show-ignore` で、これは `.gitignore` に書き込む内容を標準出力に送ります。この出力を、プロジェクトの exclude ファイルにリダイレクトしましょう。

	$ git svn show-ignore > .git/info/exclude

これで、プロジェクトに `.gitignore` ファイルを散らかさなくてもよくなります。Subversion 使いのチームの中で Git を使うのが自分だけだという場合、他のメンバーにとっては `.gitignore` ファイルは目障りでしょう。そのような場合はこの方法が使えます。

### Git-Svn のまとめ ###

`git svn` ツール群は、Subversion サーバーに行き詰まっている場合や使っている開発環境が Subversion サーバー前提になっている場合などに便利です。Git のできそこないだと感じるかもしれません。また、他のメンバーとの間で混乱が起こるかもしれません。トラブルを避けるために、次のガイドラインに従いましょう。

* Git の歴史をリニアに保ち続け、`git merge` によるマージコミットを含めないようにする。本流以外のブランチでの作業を書き戻すときは、マージではなくリベースすること。
* Git サーバーを別途用意したりしないこと、新しい開発者がクローンするときのスピードをあげるためにサーバーを用意することはあるでしょうが、そこに `git-svn-id` エントリを持たないコミットをプッシュしてはいけません。`pre-receive` フックを追加してコミットメッセージをチェックし、`git-svn-id` がなければプッシュを拒否するようにしてもよいでしょう。

これらのガイドラインを守れば、Subversion サーバーでの作業にも耐えられることでしょう。しかし、もし本物の Git サーバーに移行できるのなら、そうしたほうがチームにとってずっと利益になります。

## Git への移行 ##

別の VCS で管理している既存のコードベースを Git で管理しようと思ったら、何らかの方法でそのプロジェクトを移行しなければなりません。この節では、一般的なシステム上の Git に含まれているインポートツールについて説明します。そして、インポートツールを自作する方法も扱います。

### インポート ###

ここでは、業務のソースコード管理に使われる2大ツールである Subversion と Perforce からデータをインポートする方法を説明します。現在 Git への移行を考えている人たちの多くがこれらを使っていると聞いています。そのため、これらからのインポート用に、Git には高品質のツールが付属しています。

### Subversion ###

先ほどの節で `git svn` の使い方を読んでいれば、話は簡単です。まず `git svn clone` でリポジトリを作り、そして Subversion サーバーを使うのをやめ、新しい Git サーバーにプッシュし、あとはそれを使い始めればいいのです。これまでの歴史が欲しいのなら、それも Subversion サーバーからプルすることができます (多少時間がかかります)。

しかし、インポートは完全ではありません。また時間もかかるので、正しくやるのがいいでしょう。まず最初に問題になるのが作者 (author) の情報です。Subversion ではコミットした人すべてがシステム上にユーザーを持っており、それがコミット情報として記録されます。たとえば先ほどの節のサンプルで言うと `schacon` がそれで、`blame` の出力や `git svn log` の出力に含まれています。これをうまく Git の作者データとしてマップするには、Subversion のユーザーと Git の作者のマッピングが必要です。`users.txt` という名前のファイルを作り、このような書式でマッピングを記述します。

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

SVN で使っている作者の一覧を取得するには、このようにします。

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

これは、まずログを XML フォーマットで出力します。その中から作者を捜して重複を省き、XML を除去します (ちょっと見ればわかりますが、これは `grep` や `sort`、そして `perl` といったコマンドが使える環境でないと動きません)。この出力を users.txt にリダイレクトし、そこに Git のユーザーデータを書き足していきます。

このファイルを `git svn` に渡せば、作者のデータをより正確にマッピングできるようになります。また、Subversion が通常インポートするメタデータを含めないよう `git svn` に指示することもできます。そのためには `--no-metadata` を `clone` コマンドあるいは `init` コマンドに渡します。そうすると、 `import` コマンドは次のようになります。

	$ git svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

これで、Subversion をちょっとマシにインポートした `my_project` ディレクトリができあがりました。コミットがこんなふうに記録されるのではなく、

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

次のように記録されています。

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Author フィールドの見た目がずっとよくなっただけではなく、`git-svn-id` もなくなっています。

インポートした後に、ちょっとした後始末が必要です。たとえば、`git svn` が準備した変な参照などです。まずはタグを移動して、奇妙なリモートブランチではなくちゃんとしたタグとして扱えるようにします。そして、残りのブランチを移動してローカルで扱えるようにします。

タグを Git のタグとして扱うには、次のコマンドを実行します。

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname"; done

これは、リモートブランチのうち `tag/` で始まる名前のものを、実際の (軽量な) タグに変えます。

次に、`refs/remotes` 以下にあるそれ以外の参照をローカルブランチに移動します。

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname"; done

これで、今まであった古いブランチはすべて Git のブランチとなり、古いタグもすべて Git のタグになりました。最後に残る作業は、新しい Git サーバーをリモートに追加してプッシュすることです。自分のサーバーをリモートとして追加するには以下のようにします｡

	$ git remote add origin git@my-git-server:myrepository.git

すべてのブランチやタグを一緒にプッシュするには、このようにします。

	$ git push origin --all
	$ git push origin --tags

これで、ブランチやタグも含めたすべてを、新しい Git サーバーにきれいにインポートできました。

### Perforce ###

次のインポート元としてとりあげるのは Perforce です。Perforce からのインポートツールも Git に同梱されています｡ただし､使用しているGitのバージョンが1.7.11より古い場合は同梱されておらず､Gitソースコードの `contrib` から取り出す必要があります。ソースコードは git.kernel.org からダウンロードできます。

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

この `fast-import` ディレクトリにある実行可能な Python スクリプト `git-p4` が、それです。このツールを使うには、Python と `p4` ツールがマシンにインストールされていなければなりません。たとえば、Jam プロジェクトを Perforce Public Depot からインポートします。クライアントをセットアップするには、環境変数 P4PORT をエクスポートして Perforce depot の場所を指すようにしなければなりません。

	$ export P4PORT=public.perforce.com:1666

`git-p4 clone` コマンドを実行して Jam プロジェクトを Perforce サーバーからインポートし、depot とプロジェクトそしてプロジェクトの取り込み先のパスを指定します。

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

`/opt/p4import` ディレクトリに移動して `git log` を実行すると、インポートされた内容を見ることができます。

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

`git-p4` という識別子が各コミットに含まれることがわかるでしょう。この識別子はそのままにしておいてもかまいません。後で万一 Perforce のチェンジ番号を参照しなければならなくなったときのために使えます。しかし、もし削除したいのならここで消しておきましょう。新しいリポジトリ上で何か作業を始める前のこの段階で。`git filter-branch` を使えば、この識別子を一括削除することができます。

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

`git log` を実行すれば各コミットの SHA-1 チェックサムがすべて変わったことがわかります。そして `git-p4` 文字列はコミットメッセージから消えました。

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

これで、インポートした内容を新しい Git サーバーにプッシュする準備がととのいました。

### カスタムインポーター ###

Subversion や Perforce 以外のシステムを使っている場合は、それ用のインポートツールを探さなければなりません。CVS、Clear Case、Visual Source Safe、あるいはアーカイブのディレクトリなどのためのツールはオンラインで公開されています。これらのツールがうまく動かなかったり手元で使っているバージョン管理ツールがもっとマイナーなものだったり、あるいはインポート処理で特殊な操作をしたりしたい場合は `git fast-import` を使います。このコマンドはシンプルな指示を標準入力から受け取って、特定の Git データを書き出します。生の Git コマンドを使ったり生のオブジェクトを書きだそうとしたりする (詳細は第 9 章を参照ください) よりもずっと簡単に Git オブジェクトを作ることができます。この方法を使えばインポートスクリプトを自作することができます。必要な情報を元のシステムから読み込み、単純な指示を標準出力に出せばよいのです。そして、このスクリプトの出力をパイプで `git fast-import` に送ります。

手軽に試してみるために、シンプルなインポーターを書いてみましょう。currentで作業をしており、プロジェクトのバックアップはディレクトリまるごとのコピーで行っているものとします。バックアップディレクトリの名前は、タイムスタンプをもとに `back_YYYY_MM_DD` としています。これらを Git にインポートしてみましょう。ディレクトリの構造は、このようになっています。

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

Git のディレクトリにインポートするにはまず、これらのデータをどのように Git に格納するかをレビューしなければなりません。Git は基本的にはコミットオブジェクトのリンクリストであり、コミットオブジェクトがコンテンツのスナップショットを指しています。`fast-import` に指示しなければならないのは、コンテンツのスナップショットが何でどのコミットデータがそれを指しているのかということと、コミットデータを取り込む順番だけです。ここでは、スナップショットをひとつずつたどって各ディレクトリの中身をさすコミットオブジェクトを作り、それらを日付順にリンクさせるものとします。

第 7 章の「Git ポリシーの実施例」同様、ここでも Ruby を使って書きます。ふだんから使いなれており、きっと他の方にも読みやすいであろうからです。このサンプルをあなたの使いなれた言語で書き換えるのも簡単でしょう。単に適切な情報を標準出力に送るだけなのだから。また、Windows を使っている場合は、行末にキャリッジリターンを含めないように注意が必要です。`git fast-import` が想定している行末は LF だけであり、Windows で使われている CRLF は想定していません。

まず最初に対象ディレクトリに移動し、コミットとしてインポートするスナップショットとしてサブディレクトリを識別します。基本的なメインループは、このようになります。

	last_mark = nil

	# 各ディレクトリをループ
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # 対象ディレクトリに移動
	    Dir.chdir(dir) do
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

各ディレクトリ内で実行している `print_export` は、前のスナップショットの内容とマークを受け取ってこのディレクトリの内容とマークを返します。このようにして、それぞれを適切にリンクさせます。「マーク」とは `fast-import` 用語で、コミットに対する識別子を意味します。コミットを作成するときにマークをつけ、それを使って他のコミットとリンクさせます。つまり、`print_export` メソッドで最初にやることは、ディレクトリ名からマークを生成することです。

	mark = convert_dir_to_mark(dir)

これを行うには、まずディレクトリの配列を作り、そのインデックスの値をマークとして使います。マークは整数値でなければならないからです。メソッドの中身はこのようになります。

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

これで各コミットを整数値で表せるようになりました。次に必要なのは、コミットのメタデータ用の日付です。日付はディレクトリ名で表されているので、ここから取得します。`print_export` ファイルで次にすることは、これです。

	date = convert_dir_to_date(dir)

`convert_dir_to_date` の定義は次のようになります。

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

これは、各ディレクトリの日付に対応する整数値を返します。コミットのメタ情報として必要な最後の情報はコミッターのデータで、これはグローバル変数にハードコードします。

	$author = 'Scott Chacon <schacon@example.com>'

これで、コミットのデータをインポーターに流せるようになりました。最初の情報で示しているのは、今定義しているのがコミットオブジェクトであることとどのブランチにいるのかを表す宣言です。その後に先ほど生成したマークが続き、さらにコミッターの情報とコミットメッセージが続いた後にひとつ前のコミットが (もし存在すれば) 続きます。コードはこのようになります。

	# インポート情報の表示
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

タイムゾーン (-0700) をハードコードしているのは、そのほうがお手軽だったからです。別のシステムからインポートする場合は、タイムゾーンを適切に指定しなければなりません。コミットメッセージは、次のような特殊な書式にする必要があります。

	data (size)\n(contents)

まず最初に「data」という単語、そして読み込むデータのサイズ、改行、最後にデータがきます。同じ書式は後でファイルのコンテンツを指定するときにも使うので、ヘルパーメソッド `export_data` を作ります。

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

残っているのは、各スナップショットが持つファイルのコンテンツを指定することです。今回の場合はどれも一つのディレクトリにまとまっているので簡単です。`deleteall` コマンドを表示し、それに続けてディレクトリ内の各ファイルの中身を表示すればよいのです。そうすれば、Git が各スナップショットを適切に記録します。

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

注意:	多くのシステムではリビジョンを「あるコミットと別のコミットの差分」と考えているので、fast-importでもその形式でコマンドを受け取ることができます。つまりコミットを指定するときに、追加/削除/変更されたファイルと新しいコンテンツの中身で指定できるということです。各スナップショットの差分を算出してそのデータだけを渡すこともできますが、処理が複雑になります。すべてのデータを渡して、Git に差分を算出させたほうがよいでしょう。もし差分を渡すほうが手元のデータに適しているようなら、`fast-import` のマニュアルで詳細な方法を調べましょう。

新しいファイルの内容、あるいは変更されたファイルと変更後の内容を表す書式は次のようになります。

	M 644 inline path/to/file
	data (size)
	(file contents)

この 644 はモード (実行可能ファイルがある場合は、そのファイルについては 755 を指定する必要があります) を表し、inline とはファイルの内容をこの次の行に続けて指定するという意味です。`inline_data` メソッドは、このようになります。

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

先ほど定義した `export_data` メソッドを再利用することができます。この書式はコミットメッセージの書式と同じだからです。

最後に必要となるのは、現在のマークを返して次の処理に渡せるようにすることです。

	return mark

注意: Windows 上で動かす場合はさらにもう一手間必要です。先述したように、Windows の改行文字は CRLF ですが `git fast-import` は LF にしか対応していません。この問題に対応して `git fast-import` をうまく動作させるには、CRLF ではなく LF を使うよう ruby に指示しなければなりません。

	$stdout.binmode

これで終わりです。このスクリプトを実行すれば、次のような結果が得られます。

	$ ruby import.rb /opt/import_from
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

インポーターを動かすには、インポート先の Git レポジトリにおいて､インポーターの出力をパイプで `git fast-import` に渡す必要があります。インポート先に新しいディレクトリを作成したら､以下のように `git init` を実行し、そしてスクリプトを実行してみましょう｡

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

ご覧のとおり、処理が正常に完了すると、処理内容に関する統計情報が表示されます。この場合は、全部で 18 のオブジェクトからなる 5 つのコミットが 1 つのブランチにインポートされたことがわかります。では、`git log` で新しい歴史を確認しましょう。

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

きれいな Git リポジトリができていますね。ここで重要なのは、この時点ではまだ何もチェックアウトされていないということです。作業ディレクトリには何もファイルがありません。ファイルを取得するには、ブランチをリセットして `master` の現在の状態にしなければなりません。

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

`fast-import` ツールにはさらに多くの機能があります。さまざまなモードを処理したりバイナリデータを扱ったり、複数のブランチやそのマージ、タグ、進捗状況表示などです。より複雑なシナリオのサンプルは Git のソースコードの `contrib/fast-import` ディレクトリにあります。先ほど取り上げた `git-p4` スクリプトがよい例となるでしょう。

## まとめ ##

Git を Subversion と組み合わせて使う方法を説明しました。また、既存のリポジトリのほぼすべてを、データを失うことなく新たな Git リポジトリにインポートできるようになりました。次章では、Git の内部に踏み込みます。必要とあらばバイト単位での操作もできることでしょう。
