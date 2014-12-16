# Git のさまざまなツール #

Git を使ったソースコード管理のためのリポジトリの管理や保守について、日々使用するコマンドやワークフローの大半を身につけました。ファイルの追跡やコミットといった基本的なタスクをこなせるようになっただけではなくステージングエリアの威力もいかせるようになりました。また気軽にトピックブランチを切ってマージする方法も知りました。

では、Git の非常に強力な機能の数々をさらに探っていきましょう。日々の作業でこれらを使うことはあまりありませんが、いつかは必要になるかもしれません。

## リビジョンの選択 ##

Git で特定のコミットやコミットの範囲を指定するにはいくつかの方法があります。明白なものばかりではありませんが、知っておくと役立つでしょう。

### 単一のリビジョン ###

SHA-1 ハッシュを指定すれば、コミットを明確に参照することができます。しかしそれ以外にも、より人間にやさしい方式でコミットを参照することもできます。このセクションでは単一のコミットを参照するためのさまざまな方法の概要を説明します。

### SHA の短縮形 ###

Git は、最初の数文字をタイプしただけであなたがどのコミットを指定したいのかを汲み取ってくれます。条件は、SHA-1 の最初の 4 文字以上を入力していることと、それでひとつのコミットが特定できる (現在のリポジトリに、入力した文字ではじまる SHA-1 のコミットがひとつしかない) ことです。

あるコミットを指定するために `git log` コマンドを実行し、とある機能を追加したコミットを見つけました。

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

探していたのは、`1c002dd....` で始まるコミットです。`git show` でこのコミットを見るときは、次のどのコマンドでも同じ結果になります (短いバージョンで、重複するコミットはないものとします)。

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

一意に特定できる範囲での SHA-1 の短縮形を Git に見つけさせることもできます。`git log` コマンドで `--abbrev-commit` を指定すると、コミットを一意に特定できる範囲の省略形で出力します。デフォルトでは 7 文字ぶん表示しますが、それだけで SHA-1 を特定できない場合はさらに長くなります。

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

ひとつのプロジェクト内での一意性を確保するには、普通は 8 文字から 10 文字もあれば十分すぎることでしょう。最も大規模な Git プロジェクトのひとつである Linux カーネルの場合は、40 文字のうち先頭の 12 文字を指定しないと一意性を確保できません。

### SHA-1 に関するちょっとしたメモ ###
「リポジトリ内のふたつのオブジェクトがたまたま同じ SHA-1 ハッシュ値を持ってしまったらどうするの?」と心配する人も多いでしょう。実際、どうなるのでしょう?

すでにリポジトリに存在するオブジェクトと同じ SHA-1 値を持つオブジェクトをコミットしてした場合、Git はすでにそのオブジェクトがデータベースに格納されているものと判断します。そのオブジェクトを後からどこかで取得しようとすると、常に最初のオブジェクトのデータが手元にやってきます (訳注: つまり、後からコミットした内容は存在しないことになってしまう)。

しかし、そんなことはまず起こりえないということを知っておくべきでしょう。SHA-1 ダイジェストの大きさは 20 バイト (160 ビット) です。ランダムなハッシュ値がつけられた中で、たった一つの衝突が 50% の確率で発生するために必要なオブジェクトの数は約 2^80 となります (衝突の可能性の計算式は `p = (n(n-1)/2) * (1/2^160)` です)。2^80 は、ほぼ 1.2 x 10^24 、つまり一兆二千億のそのまた一兆倍です。これは、地球上にあるすべての砂粒の数の千二百倍にあたります。

SHA-1 の衝突を見るにはどうしたらいいのか、ひとつの例をごらんに入れましょう。地球上の人類 65 億人が全員プログラムを書いていたとします。そしてその全員が、Linux カーネルのこれまでの開発履歴 (100 万の Git オブジェクト) と同等のコードを一秒で書き上げ、馬鹿でかい単一の Git リポジトリにプッシュしていくとします。これを五年間続けたとして、SHA-1 オブジェクトの衝突がひとつでも発生する可能性がやっと 50% になります。それよりも「あなたの所属する開発チームの全メンバーが、同じ夜にそれぞれまったく無関係の事件で全員オオカミに殺されてしまう」可能性のほうがよっぽど高いことでしょう。

### ブランチの参照 ###

特定のコミットを参照するのに一番直感的なのは、そのコミットを指すブランチがある場合です。コミットオブジェクトや SHA-1 値を指定する場面ではどこでも、その代わりにブランチ名を指定することができます。たとえば、あるブランチ上の最新のコミットを表示したい場合は次のふたつのコマンドが同じ意味となります (`topic1` ブランチが `ca82a6d` を指しているものとします)。

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

あるブランチがいったいどの SHA を指しているのか、あるいはその他の例の内容が結局のところどの SHA に行き着くのかといったことを知るには、Git の調査用ツールである `rev-parse` を使います。こういった調査用ツールのより詳しい情報は第 9 章で説明します。`rev-parse` は低レベルでの操作用のコマンドであり、日々の操作で使うためのものではありません。しかし、今実際に何が起こっているのかを知る必要があるときなどには便利です。ブランチ上で `rev-parse` を実行すると、このようになります。

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### 参照ログの短縮形 ###

あなたがせっせと働いている間に Git が裏でこっそり行っていることのひとつが、参照ログ (reflog) の管理です。これは、HEAD とブランチの参照が過去数ヶ月間どのように動いてきたかをあらわすものです。

参照ログを見るには `git reflog` を使います。

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

何らかの理由でブランチの先端が更新されるたびに、Git はその情報をこの一時履歴に格納します。そして、このデータを使って過去のコミットを指定することもできます。リポジトリの HEAD の五つ前の状態を知りたい場合は、先ほど見た reflog の出力のように `@{n}` 形式で参照することができます。

	$ git show HEAD@{5}

この構文を使うと、指定した期間だけさかのぼったときに特定のブランチがどこを指していたかを知ることもできます。たとえば `master` ブランチの昨日の状態を知るには、このようにします。

	$ git show master@{yesterday}

こうすると、そのブランチの先端が昨日どこを指していたかを表示します。この技が使えるのは参照ログにデータが残っている間だけなので、直近数ヶ月よりも前のコミットについては使うことができません。

参照ログの情報を `git log` の出力風の表記で見るには `git log -g` を実行します。

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

参照ログの情報は、完全にローカルなものであることに気をつけましょう。これは、あなた自身が自分のリポジトリで何をしたのかを示す記録です。つまり、同じリポジトリをコピーした別の人の参照ログとは異なる内容になります。また、最初にリポジトリをクローンした直後の参照ログは空となります。まだリポジトリ上であなたが何もしていないからです。`git show HEAD@{2.months.ago}` が動作するのは、少なくとも二ヶ月以上前にそのリポジトリをクローンした場合のみで、もしつい 5 分前にクローンしたばかりなら何も結果を返しません。

### 家系の参照 ###

コミットを特定する方法として他によく使われるのが、その家系をたどっていく方法です。参照の最後に `^` をつけると、Git はそれを「指定したコミットの親」と解釈します。あなたのプロジェクトの歴史がこのようになっていたとしましょう。

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

直前のコミットを見るには `HEAD^` を指定します。これは "HEAD の親" という意味になります。

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

`^` の後に数字を指定することもできます。たとえば `d921970^2` は "d921970 の二番目の親" という意味になります。これが役立つのはマージコミット (親が複数存在する) のときくらいでしょう。最初の親はマージを実行したときにいたブランチとなり、二番目の親は取り込んだブランチ上のコミットとなります。

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

家系の指定方法としてもうひとつよく使うのが `~` です。これも最初の親を指します。つまり `HEAD~` と `HEAD^` は同じ意味になります。違いが出るのは、数字を指定したときです。`HEAD~2` は "最初の親の最初の親" つまり "祖父母" という意味になります。指定した数だけ、順に最初の親をさかのぼっていくことになります。たとえば、先ほど示したような歴史上では `HEAD~3` は次のようになります。

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

これは `HEAD^^^` のようにあらわすこともできます。これは「最初の親の最初の親の最初の親」という意味になります。

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

これらふたつの構文を組み合わせることもできます。直近の参照 (マージコミットだったとします) の二番目の親を取得するには `HEAD~3^2` などとすればいいのです。

### コミットの範囲指定 ###

個々のコミットを指定できるようになったので、次はコミットの範囲を指定する方法を覚えていきましょう。これは、ブランチをマージするときに便利です。たくさんのブランチを持っている場合など「で、このブランチの作業のなかでまだメインブランチにマージしていないのはどれだったっけ?」といった疑問に答えるために範囲指定を使えます。

#### ダブルドット ####

範囲指定の方法としてもっとも一般的なのが、ダブルドット構文です。これは、ひとつのコミットからはたどれるけれどもうひとつのコミットからはたどれないというコミットの範囲を Git に調べさせるものです。図 6-1 のようなコミット履歴を例に考えましょう。

Insert 18333fig0601.png
図 6-1. 範囲指定選択用の歴史の例

experiment ブランチの内容のうち、まだ master ブランチにマージされていないものを調べることになりました。対象となるコミットのログを見るには、Git に `master..experiment` と指示します。これは "experiment からはたどれるけれど、master からはたどれないすべてのコミット" という意味です。説明を短く簡潔にするため、実際のログの出力のかわりに上の図の中でコミットオブジェクトをあらわす文字を使うことにします。

	$ git log master..experiment
	D
	C

もし逆に、`master` には存在するけれども `experiment` には存在しないすべてのコミットが知りたいのなら、ブランチ名を逆にすればいいのです。`experiment..master` とすれば、`master` のすべてのコミットのうち `experiment` からたどれないものを取得できます。

	$ git log experiment..master
	F
	E

これは、`experiment` ブランチを最新の状態に保つために何をマージしなければならないのかを知るのに便利です。もうひとつ、この構文をよく使う例としてあげられるのが、これからリモートにプッシュしようとしている内容を知りたいときです。

	$ git log origin/master..HEAD

このコマンドは、現在のブランチ上でのコミットのうち、リモート `origin` の `master` ブランチに存在しないものをすべて表示します。現在のブランチが `origin/master` を追跡しているときに `git push` を実行すると、`git log origin/master..HEAD` で表示されたコミットがサーバーに転送されます。この構文で、どちらか片方を省略することもできます。その場合、Git は省略したほうを HEAD とみなします。たとえば、`git log origin/master..` と入力すると先ほどの例と同じ結果が得られます。Git は、省略した側を HEAD に置き換えて処理を進めるのです。

#### 複数のポイント ####

ダブルドット構文は、とりあえず使うぶんには便利です。しかし、二つよりもっと多くのブランチを指定してリビジョンを特定したいこともあるでしょう。複数のブランチの中から現在いるブランチには存在しないコミットを見つける場合などです。Git でこれを行うには `^` 文字を使うか、あるいはそこからたどりつけるコミットが不要な参照の前に `--not` をつけます。これら三つのコマンドは、同じ意味となります。

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

これらの構文が便利なのは、二つよりも多くの参照を使って指定できるというところです。ダブルドット構文では二つの参照しか指定できませんでした。たとえば、`refA` と `refB` のどちらかからはたどれるけれども `refC` からはたどれないコミットを取得したい場合は、次のいずれかを実行します。

	$ git log refA refB ^refC
	$ git log refA refB --not refC

この非常に強力なリビジョン問い合わせシステムを使えば、今あなたのブランチに何があるのかを知るのに非常に役立つことでしょう。

#### トリプルドット ####

範囲指定選択の主な構文であとひとつ残っているのがトリプルドット構文です。これは、ふたつの参照のうちどちらか一方からのみたどれるコミット (つまり、両方からたどれるコミットは含まない) を指定します。図 6-1 で示したコミット履歴の例を振り返ってみましょう。`master` あるいは `experiment` に存在するコミットのうち、両方に存在するものを除いたコミットを知りたい場合は次のようにします。

	$ git log master...experiment
	F
	E
	D
	C

これは通常の `log` の出力と同じですが、これら四つのコミットについての情報しか表示しません。表示順は、従来どおりコミット日時順となります。

この場合に `log` コマンドでよく使用するスイッチが `--left-right` です。このスイッチは、それぞれのコミットがどちら側に存在するのかを表示します。これを使うとデータをより活用しやすくなるでしょう。

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

これらのツールを使えば、より簡単に「どれを調べたいのか」を Git に伝えられるようになります。

## 対話的なステージング ##

Git には、コマンドラインでの作業をしやすくするためのスクリプトがいくつか付属しています。ここでは、対話コマンドをいくつか紹介しましょう。これらを使うと、コミットの内容に細工をして特定のコミットだけとかファイルの中の一部だけとかを含めるようにすることが簡単にできるようになります。大量のファイルを変更した後に、それをひとつの馬鹿でかいコミットにしてしまうのではなくテーマごとの複数のコミットに分けて処理したい場合などに非常に便利です。このようにして各コミットを論理的に独立した状態にしておけば、同僚によるレビューも容易になります。`git add` に `-i` あるいは `--interactive` というオプションをつけて実行すると、Git は対話シェルモードに移行し、このように表示されます。

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

このコマンドは、ステージングエリアに関する情報を違った観点で表示します。`git status` で得られる情報と基本的には同じですが、より簡潔で有益なものとなっています。ステージした変更が左側、そしてステージしていない変更が右側に表示されます。

Commands セクションでは、さまざまなことができるようになっています。ファイルをステージしたりステージングエリアから戻したり、ファイルの一部だけをステージしたりまだ追跡されていないファイルを追加したり、あるいは何がステージされたのかを diff で見たりといったことが可能です。

### ファイルのステージとその取り消し ###

`What now>` プロンプトで `2` または `u` と入力すると、どのファイルをステージするかを聞いてきます。

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

TODO と index.html をステージするには、その番号を入力します。

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

ファイル名の横に `*` がついていれば、そのファイルがステージ対象として選択されたことを意味します。`Update>>` プロンプトで何も入力せずに Enter を押すと、選択されたすべてのファイルを Git がステージします。

	Update>>
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

TODO と index.html がステージされ、simplegit.rb はまだステージされていないままです。ここで仮に TODO ファイルのステージを取り消したくなったとしたら、`3` あるいは `r` (revert の r) を選択します。

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

もう一度 Git のステータスを見ると、TODO ファイルのステージが取り消されていることがわかります。

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

ステージした変更の diff を見るには、`6` あるいは `d` (diff の d) を使用します。このコマンドは、ステージしたファイルの一覧を表示します。その中から、ステージされた diff を見たいファイルを選択します。これは、コマンドラインで `git diff --cached` を使用するのと同じようなことです。

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

これらの基本的なコマンドを使えば、ステージングエリアでの対話的な追加モードを多少簡単に扱えるようになるでしょう。

### パッチのステージ ###

Git では、ファイルの特定の箇所だけをステージして他の部分はそのままにしておくということもできます。たとえば、simplegit.rb のふたつの部分を変更したけれど、そのうちの一方だけをステージしたいという場合があります。Git なら、そんなことも簡単です。対話モードのプロンプトで `5` あるいは `p` (patch の p) と入力しましょう。Git は、どのファイルを部分的にステージしたいのかを聞いてきます。その後、選択したファイルのそれぞれについて diff のハンクを順に表示し、ステージするかどうかをひとつひとつたずねます。

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]?

ここでは多くの選択肢があります。何ができるのかを見るには `?` を入力しましょう。

	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? ?
	y - stage this hunk
	n - do not stage this hunk
	a - stage this and all the remaining hunks in the file
	d - do not stage this hunk nor any of the remaining hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

たいていは、`y` か `n` で各ハンクをステージするかどうかを指定していくでしょう。しかし、それ以外にも「このファイルの残りのハンクをすべてステージする」とか「このハンクをステージするかどうかの判断を先送りする」などというオプションも便利です。あるファイルのひとつの箇所だけをステージして残りはそのままにした場合、ステータスの出力はこのようになります。

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

simplegit.rb のステータスがおもしろいことになっています。ステージされた行もあれば、ステージされていない行もあるという状態です。つまり、このファイルを部分的にステージしたというわけです。この時点で対話的追加モードを抜けて `git commit` を実行すると、ステージした部分だけをコミットすることができます。

最後に、この対話的追加モードを使わずに部分的なステージを行いたい場合は、コマンドラインから `git add -p` あるいは `git add --patch` を実行すれば同じことができます。

## 作業を隠す ##

何らかのプロジェクトの一員として作業している場合にありがちなのですが、ある作業が中途半端な状態になっているときに、ブランチを切り替えてちょっとだけ別の作業をしたくなることがあります。中途半端な状態をコミットしてしまうのはいやなので、できればコミットせずにしておいて後でその状態から作業を再開したいものです。そんなときに使うのが `git stash` コマンドです。

これは、作業ディレクトリのダーティな状態 (追跡しているファイルのうち変更されたもの、そしてステージされた変更) を受け取って未完了の作業をスタックに格納し、あとで好きなときに再度それを適用できるようにするものです。

### 自分の作業を隠す ###

例を見てみましょう。自分のプロジェクトでいくつかのファイルを編集し、その中のひとつをステージしたとします。ここで `git status` を実行すると、ダーティな状態を確認することができます。

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

ここで別のブランチに切り替えることになりましたが、現在の作業内容はまだコミットしたくありません。そこで、変更をいったん隠すことにします。新たにスタックに隠すには `git stash` を実行します。

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

これで、作業ディレクトリはきれいな状態になりました。

	$ git status
	# On branch master
	nothing to commit, working directory clean

これで、簡単にブランチを切り替えて別の作業をできるようになりました。これまでの変更内容はスタックに格納されています。今までに格納した内容を見るには `git stash list` を使います。

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

この例では、以前にも二回ほど作業を隠していたようです。そこで、三種類の異なる作業にアクセスできるようになっています。先ほど隠した変更を再度適用するには、stash コマンドの出力に書かれていたように `git stash apply` コマンドを実行します。それよりもっと前に隠したものを適用したい場合は `git stash apply stash@{2}` のようにして名前を指定することもできます。名前を指定しなければ、Git は直近に隠された変更を再適用します。

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Git がファイルを変更して、未コミットのファイルが先ほどスタックに隠したときと同じ状態に戻ったことがわかるでしょう。今回は、作業ディレクトリがきれいな状態で変更を書き戻しました。また、変更を隠したときと同じブランチに書き戻しています。しかし、隠した内容を再適用するためにこれらが必須条件であるというわけではありません。あるブランチの変更を隠し、別のブランチに移動して移動先のブランチにそれを書き戻すこともできます。また、隠した変更を書き戻す際に、現在のブランチに未コミットの変更があってもかまいません。もしうまく書き戻せなかった場合は、マージ時のコンフリクトと同じようになります。

さて、ファイルへの変更はもとどおりになりましたが、以前にステージしていたファイルはステージされていません。これを行うには、`git stash apply` コマンドに `--index` オプションをつけて実行し、変更のステージ処理も再適用するよう指示しなければなりません。先ほどのコマンドのかわりにこれを実行すると、元の状態に戻ります。

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

apply オプションは、スタックに隠した作業を再度適用するだけで、スタックにはまだその作業が残ったままになります。スタックから削除するには、`git stash drop` に削除したい作業の名前を指定して実行します。

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

あるいは `git stash pop` を実行すれば、隠した内容を再適用してその後スタックからも削除してくれます。

### 隠した内容の適用の取り消し ###

隠した変更を適用して何らかの作業をした後に、先ほどの適用を取り消してしまいたくなることもあるでしょう。そんなときに使えそうな `stash unapply` コマンドは git にはありませんが、同じような操作をすることはできます。適用した変更を表すパッチを取得して、それを逆に適用すればいいのです。

    $ git stash show -p stash@{0} | git apply -R

名前を指定しなければ、Git は直近に隠した変更を使うものとみなします。

    $ git stash show -p | git apply -R

次の例のようにエイリアスを作れば、Git に `stash-unapply` コマンドを追加したのと事実上同じことになります。

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... 何か作業をして ...
    $ git stash-unapply

### 隠した変更からのブランチの作成 ###

作業をいったん隠し、しばらくそのブランチで作業を続けていると、隠した内容を再適用するときに問題が発生する可能性があります。隠した後に何らかの変更をしたファイルに変更を再適用しようとすると、マージ時にコンフリクトが発生してそれを解決しなければならなくなるでしょう。もう少しお手軽な方法で以前の作業を確認したい場合は `git stash branch` を実行します。このコマンドは、まず新しいブランチを作成し、作業をスタックに隠したときのコミットをチェックアウトし、スタックにある作業を再適用し、それに成功すればスタックからその作業を削除します。

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

これを使うと、保存していた作業をお手軽に復元して新しいブランチで作業をすることができます。

## 歴史の書き換え ##

Git を使って作業をしていると、何らかの理由でコミットの歴史を書き換えたくなることが多々あります。Git のすばらしい点のひとつは、何をどうするかの決断をぎりぎりまで先送りできることです。どのファイルをどのコミットに含めるのかは、ステージングエリアの内容をコミットする直前まで変更することができますし、既に作業した内容でも stash コマンドを使えばまだ作業していないことにできます。また、すでにコミットしてしまった変更についても、それを書き換えてまるで別の方法で行ったかのようにすることもできます。コミットの順序を変更したり、コミットメッセージやコミットされるファイルを変更したり、複数のコミットをひとつにまとめたりひとつのコミットを複数に分割したり、コミットそのものをなかったことにしたり……といった作業を、変更内容を他のメンバーに公開する前ならいつでもすることができます。

このセクションでは、これらの便利な作業の方法について扱います。これで、あなたのコミットの歴史を思い通りに書き換えてから他の人と共有できるようになります。

### 直近のコミットの変更 ###

直近のコミットを変更するというのは、歴史を書き換える作業のうちもっともよくあるものでしょう。直近のコミットに対して手を加えるパターンとしては、コミットメッセージを変更したりそのコミットで記録されるスナップショットを変更 (ファイルを追加・変更あるいは削除) したりといったものがあります。

単に直近のコミットメッセージを変更したいだけの場合は非常にシンプルです。

	$ git commit --amend

これを実行するとテキストエディタが開きます。すでに直近のコミットメッセージが書き込まれた状態になっており、それを変更することができます。変更を保存してエディタを終了すると、変更後のメッセージを含む新しいコミットを作成して直近のコミットをそれで置き換えます。

いったんコミットしたあとで、そこにさらにファイルを追加したり変更したりしたくなったとしましょう。「新しく作ったファイルを追加し忘れた」とかがありそうですね。この場合の手順も基本的には同じです。ファイルを編集して `git add` したり追跡中のファイルを `git rm` したりしてステージングエリアをお好みの状態にしたら、続いて `git commit --amend` を実行します。すると、現在のステージングエリアの状態を次回のコミット用のスナップショットにします。

この技を使う際には注意が必要です。この処理を行うとコミットの SHA-1 が変わるからです。いわば、非常に小規模なリベースのようなものです。すでにプッシュしているコミットは書き換えないようにしましょう。

### 複数のコミットメッセージの変更 ###

さらに歴史をさかのぼったコミットを変更したい場合は、もう少し複雑なツールを使わなければなりません。Git には歴史を修正するツールはありませんが、リベースツールを使って一連のコミットを (別の場所ではなく) もともとあった場所と同じ HEAD につなげるという方法を使うことができます。対話的なリベースツールを使えば、各コミットについてメッセージを変更したりファイルを追加したりお望みの変更をすることができます。対話的なリベースを行うには、`git rebase` に `-i` オプションを追加します。どこまでさかのぼってコミットを書き換えるかを指示するために、どのコミットにリベースするかを指定しなければなりません。

直近の三つのコミットメッセージあるいはそのいずれかを変更したくなった場合、変更したい最古のコミットの親を `git rebase -i` の引数に指定します。ここでは `HEAD~2^` あるいは `HEAD~3` となります。直近の三つのコミットを編集しようと考えているのだから、`~3` のほうが覚えやすいでしょう。しかし、実際のところは四つ前 (変更したい最古のコミットの親) のコミットを指定していることに注意しましょう。

	$ git rebase -i HEAD~3

これはリベースコマンドであることを認識しておきましょう。 `HEAD~3..HEAD` に含まれるすべてのコミットは、実際にメッセージを変更したか否かにかかわらずすべて書き換えられます。すでに中央サーバーにプッシュしたコミットをここに含めてはいけません。含めてしまうと、同じ変更が別のバージョンで見えてしまうことになって他の開発者が混乱します。

このコマンドを実行すると、テキストエディタが開いてコミットの一覧が表示され、このようになります。

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

このコミット一覧の表示順は、`log` コマンドを使ったときの通常の表示順とは逆になることに注意しましょう。`log` を実行すると、このようになります。

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

逆順になっていますね。対話的なリベースを実行するとスクリプトが出力されるので、それをあとで実行することになります。このスクリプトはコマンドラインで指定したコミット (`HEAD~3`) から始まり、それ以降のコミットを古い順に再現していきます。最新のものからではなく古いものから表示されているのは、最初に再現するのがいちばん古いコミットだからです。

このスクリプトを編集し、手を加えたいコミットのところでスクリプトを停止させるようにします。そのためには、各コミットのうちスクリプトを停止させたいものについて「pick」を「edit」に変更します。たとえば、三番目のコミットメッセージだけを変更したい場合はこのようにファイルを変更します。

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

これを保存してエディタを終了すると、Git はそのリストの最初のコミットまで処理を巻き戻し、次のようなメッセージとともにコマンドラインを返します。

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

この指示が、まさにこれからすべきことを教えてくれています。

	$ git commit --amend

と打ち込んでコミットメッセージを変更してからエディタを終了し、次に

	$ git rebase --continue

を実行します。このコマンドはその他のふたつのコミットも自動的に適用するので、これで作業は終了です。複数行で「pick」を「edit」に変更した場合は、これらの作業を各コミットについてくりかえすことになります。それぞれの場面で Git が停止するので、amend でコミットを書き換えて continue で処理を続けます。

### コミットの並べ替え ###

対話的なリベースで、コミットの順番を変更したり完全に消し去ってしまったりすることもできます。"added cat-file" のコミットを削除して残りの二つのコミットの適用順を反対にしたい場合は、リベーススクリプトを

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

から

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

のように変更します。これを保存してエディタを終了すると、Git はまずこれらのコミットの親までブランチを巻き戻してから `310154e` を適用し、その次に `f7f3f6d` を適用して停止します。これで、効率的にコミット順を変更して "added cat-file" のコミットは完全に取り除くことができました。

### コミットのまとめ ###

一連のコミット群をひとつのコミットにまとめて押し込んでしまうことも、対話的なリベースツールで行うことができます。リベースメッセージの中に、その手順が出力されています。

	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

「pick」や「edit」のかわりに「squash」を指定すると、Git はその変更と直前の変更をひとつにまとめて新たなコミットメッセージを書き込めるようにします。つまり、これらの三つのコミットをひとつのコミットにまとめたい場合は、スクリプトをこのように変更します。

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

これを保存してエディタを終了すると、Git は三つの変更をすべて適用してからエディタに戻るので、そこでコミットメッセージを変更します。

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

これを保存すると、さきほどの三つのコミットの内容をすべて含んだひとつのコミットができあがります。

### コミットの分割 ###

コミットの分割は、いったんコミットを取り消してから部分的なステージとコミットを繰り返して行います。たとえば、先ほどの三つのコミットのうち真ん中のものを分割することになったとしましょう。"updated README formatting and added blame" のコミットを、"updated README formatting" と "added blame" のふたつに分割します。そのためには、`rebase -i` スクリプトを実行してそのコミットの指示を「edit」に変更します。

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

変更を保存してエディタを終了すると、Git はリストの最初のコミットの親まで処理を巻き戻します。そして最初のコミット (`f7f3f6d`) と二番目のコミット (`310154e`) を適用してからコンソールに戻ります。コミットをリセットするには `git reset HEAD^` を実行します。これはコミット自体を取り消し、変更されたファイルはステージしていない状態にします。ここまでくれば､取り消された変更点から必要なものだけを選択してコミットすることができます｡一連のコミットが終わったら､以下のように`git rebase --continue` を実行しましょう｡

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git はスクリプトの最後のコミット (`a5f4a0d`) を適用し、歴史はこのようになります。

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

念のためにもう一度言いますが、この変更はリスト内のすべてのコミットの SHA を変更します。すでに共有リポジトリにプッシュしたコミットは、このリストに表示させないようにしましょう。

### 最強のオプション: filter-branch ###

歴史を書き換える方法がもうひとつあります。これは、大量のコミットの書き換えを機械的に行いたい場合 (メールアドレスを一括変更したりすべてのコミットからあるファイルを削除したりなど) に使うものです。そのためのコマンドが `filter-branch` です。これは歴史を大規模にばさっと書き換えることができるものなので、プロジェクトを一般に公開した後や書き換え対象のコミットを元にしてだれかが作業を始めている場合はまず使うことはありません。しかし、これは非常に便利なものでもあります。一般的な使用例をいくつか説明するので、それをもとにこの機能を使いこなせる場面を考えてみましょう。

#### 全コミットからのファイルの削除 ####

これは、相当よくあることでしょう。誰かが不注意で `git add .` をした結果、巨大なバイナリファイルが間違えてコミットされてしまったとしましょう。これを何とか削除してしまいたいものです。あるいは、間違ってパスワードを含むファイルをコミットしてしまったとしましょう。このプロジェクトをオープンソースにしたいと思ったときに困ります。`filter-branch` は、こんな場合に歴史全体を洗うために使うツールです。passwords.txt というファイルを歴史から完全に抹殺してしまうには、`filter-branch` の `--tree-filter` オプションを使います。

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

`--tree-filter` オプションは、プロジェクトの各チェックアウトに対して指定したコマンドを実行し、結果を再コミットします。この場合は、すべてのスナップショットから passwords.txt というファイルを削除します。間違えてコミットしてしまったエディタのバックアップファイルを削除するには、`git filter-branch --tree-filter "rm -f *~" HEAD` のように実行します。

Git がツリーを書き換えてコミットし、ブランチのポインタを末尾に移動させる様子がごらんいただけるでしょう。この作業は、まずはテスト用ブランチで実行してから結果をよく吟味し、それから master ブランチに適用することをおすすめします。`filter-branch` をすべてのブランチで実行するには、このコマンドに `--all` を渡します。

#### サブディレクトリを新たなルートへ ####

別のソース管理システムからのインポートを終えた後、無意味なサブディレクトリ (trunk、tags など) が残っている状態を想定しましょう。すべてのコミットの `trunk` ディレクトリを新たなプロジェクトルートとしたい場合にも、`filter-branch` が助けになります。

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

これで、新たなプロジェクトルートはそれまで `trunk` ディレクトリだった場所になります。Git は、このサブディレクトリに影響を及ぼさないコミットを自動的に削除します。

#### メールアドレスの一括変更 ####

もうひとつよくある例としては、「作業を始める前に `git config` で名前とメールアドレスを設定することを忘れていた」とか「業務で開発したプロジェクトをオープンソースにするにあたって、職場のメールアドレスをすべて個人アドレスに変更したい」などがあります。どちらの場合についても、複数のコミットのメールアドレスを一括で変更することになりますが、これも `filter-branch` ですることができます。注意して、あなたのメールアドレスのみを変更しなければなりません。そこで、`--commit-filter` を使います。

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

これで、すべてのコミットであなたのアドレスを新しいものに書き換えます。コミットにはその親の SHA-1 値が含まれるので、このコマンドは (マッチするメールアドレスが存在するものだけではなく) すべてのコミットを書き換えます。

## Git によるデバッグ ##

Git には、プロジェクトで発生した問題をデバッグするためのツールも用意されています。Git はほとんどあらゆる種類のプロジェクトで使えるように設計されているので、このツールも非常に汎用的なものです。しかし、バグを見つけたり不具合の原因を探したりするための助けとなるでしょう。

### ファイルの注記 ###

コードのバグを追跡しているときに「それが、いつどんな理由で追加されたのか」が知りたくなることがあるでしょう。そんな場合にもっとも便利なのが、ファイルの注記です。これは、ファイルの各行について、その行を最後に更新したのがどのコミットかを表示します。もしコードの中の特定のメソッドにバグがあることを見つけたら、そのファイルを `git blame` しましょう。そうすれば、そのメソッドの各行がいつ誰によって更新されたのかがわかります。この例では、`-L` オプションを使って 12 行目から 22 行目までに出力を限定しています。

	$ git blame -L 12,22 simplegit.rb
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

最初の項目は、その行を最後に更新したコミットの SHA-1 の一部です。次のふたつの項目は、そのコミットから抽出した作者情報とコミット日時です。これで、いつ誰がその行を更新したのかが簡単にわかります。それに続いて、行番号とファイルの中身が表示されます。`^4832fe2` のコミットに関する行に注目しましょう。これらの行は、ファイルが最初にコミットされたときのままであることを表します。このコミットはファイルがプロジェクトに最初に追加されたときのものであり、これらの行はそれ以降変更されていません。これはちょっと戸惑うかも知れません。Git では、これまで紹介してきただけで少なくとも三種類以上の意味で `^` を使っていますからね。しかし、ここではそういう意味になるのです。

Git のすばらしいところのひとつに、ファイルのリネームを明示的には追跡しないということがあります。スナップショットだけを記録し、もしリネームされていたのなら暗黙のうちにそれを検出します。この機能の興味深いところは、ファイルのリネームだけでなくコードの移動についても検出できるということです。`git blame` に `-C` を渡すと Git はそのファイルを解析し、別のところからコピーされたコード片がないかどうかを探します。最近私は `GITServerHandler.m` というファイルをリファクタリングで複数のファイルに分割しました。そのうちのひとつが `GITPackUpload.m` です。ここで `-C` オプションをつけて `GITPackUpload.m` を調べると、コードのどの部分をどのファイルからコピーしたのかを知ることができます。

	$ git blame -C -L 141,153 GITPackUpload.m
	f344f58d GITServerHandler.m (Scott 2009-01-04 141)
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

これはほんとうに便利です。通常は、そのファイルがコピーされたときのコミットを知ることになります。コピー先のファイルにおいて最初にその行をさわったのが、その内容をコピーしてきたときだからです。Git は、その行が本当に書かれたコミットがどこであったのかを (たとえ別のファイルであったとしても) 教えてくれるのです。

### 二分探索 ###

ファイルの注記を使えば、その問題がどの時点で始まったのかを知ることができます。何がおかしくなったのかがわからず、最後にうまく動作していたときから何十何百ものコミットが行われている場合などは、`git bisect` に頼ることになるでしょう。`bisect` コマンドはコミットの歴史に対して二分探索を行い、どのコミットで問題が混入したのかを可能な限り手早く見つけ出せるようにします。

自分のコードをリリースして運用環境にプッシュしたあとに、バグ報告を受け取ったと仮定しましょう。そのバグは開発環境では再現せず、なぜそんなことになるのか想像もつきません。コードをよく調べて問題を再現させることはできましたが、何が悪かったのかがわかりません。こんな場合に、二分探索で原因を特定することができます。まず、`git bisect start` を実行します。そして次に `git bisect bad` を使って、現在のコミットが壊れた状態であることをシステムに伝えます。次に、まだ壊れていなかったとわかっている直近のコミットを `git bisect good [good_commit]` で伝えます。

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git は、まだうまく動いていたと指定されたコミット (v1.0) と現在の壊れたバージョンの間には 12 のコミットがあるということを検出しました。そして、そのちょうど真ん中にあるコミットをチェックアウトしました。ここでテストを実行すれば、このコミットで同じ問題が発生するかどうかがわかります。もし問題が発生したなら、実際に問題が混入したのはそれより前のコミットだということになります。そうでなければ、それ以降のコミットで問題が混入したのでしょう。ここでは、問題が発生しなかったものとします。`git bisect good` で Git にその旨を伝え、旅を続けましょう。

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

また別のコミットがやってきました。先ほど調べたコミットと「壊れている」と伝えたコミットの真ん中にあるものです。ふたたびテストを実行し、今度はこのコミットで問題が再現したものとします。それを Git に伝えるには `git bisect bad` を使います。

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

このコミットはうまく動きました。というわけで、問題が混入したコミットを特定するための情報がこれですべて整いました。Git は問題が混入したコミットの SHA-1 を示し、そのコミット情報とどのファイルが変更されたのかを表示します。これを使って、いったい何が原因でバグが発生したのかを突き止めます。

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

原因がわかったら、作業を始める前に `git bisect reset` を実行して HEAD を作業前の状態に戻さなければなりません。そうしないと面倒なことになってしまいます。

	$ git bisect reset

この強力なツールを使えば、何百ものコミットの中からバグの原因となるコミットを数分で見つけだせるようになります。実際、プロジェクトが正常なときに 0 を返してどこかおかしいときに 0 以外を返すスクリプトを用意しておけば、`git bisect` を完全に自動化することもできます。まず、先ほどと同じく、壊れているコミットと正しく動作しているコミットを指定します。これは `bisect start` コマンドで行うこともできます。まず最初に壊れているコミット、そしてその後に正しく動作しているコミットを指定します。

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

こうすると、チェックアウトされたコミットに対して自動的に `test-error.sh` を実行し、壊れる原因となるコミットを見つけ出すまで自動的に処理を続けます。`make` や `make tests`、その他自動テストを実行するためのプログラムなどをここで実行させることもできます。

## サブモジュール ##

あるプロジェクトで作業をしているときに、プロジェクト内で別のプロジェクトを使わなければならなくなることがよくあります。サードパーティが開発しているライブラリや、自身が別途開発していて複数の親プロジェクトから利用しているライブラリなどがそれにあたります。こういったときに出てくるのが「ふたつのプロジェクトはそれぞれ別のものとして管理したい。だけど、一方を他方の一部としても使いたい」という問題です。

例を考えてみましょう。ウェブサイトを制作しているあなたは、Atom フィードを作成することになりました。Atom 生成コードを自前で書くのではなく、ライブラリを使うことに決めました。この場合、CPAN や gem などの共有ライブラリからコードをインクルードするか、ソースコードそのものをプロジェクトのツリーに取り込むかのいずれかが必要となります。ライブラリをインクルードする方式の問題は、ライブラリのカスタマイズが困難であることと配布が面倒になるということです。すべてのクライアントにそのライブラリを導入させなければなりません。コードをツリーに取り込む方式の問題は、手元でコードに手を加えてしまうと本家の更新に追従しにくくなるということです。

Git では、サブモジュールを使ってこの問題に対応します。サブモジュールを使うと、ある Git リポジトリを別の Git リポジトリのサブディレクトリとして扱うことができるようになります。これで、別のリポジトリをプロジェクト内にクローンしても自分のコミットは別管理とすることができるようになります。

### サブモジュールの作り方 ###

Rack ライブラリ (Ruby のウェブサーバーゲートウェイインターフェイス) を自分のプロジェクトに取り込むことになったとしましょう。手元で変更を加えるかもしれませんが、本家で更新があった場合にはそれを取り込み続けるつもりです。まず最初にしなければならないことは、外部のリポジトリをサブディレクトリにクローンすることです。外部のプロジェクトをサブモジュールとして追加するには `git submodule add` コマンドを使用します。

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

これで、プロジェクト内の `rack` サブディレクトリに Rack プロジェクトが取り込まれました。このサブディレクトリに入って変更を加えたり、書き込み権限のあるリモートリポジトリを追加してそこに変更をプッシュしたり、本家のリポジトリの内容を取得してマージしたり、さまざまなことができるようになります。サブモジュールを追加した直後に `git status` を実行すると、二つのものが見られます。

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

まず気づくのが `.gitmodules` ファイルです。この設定ファイルには、プロジェクトの URL とそれを取り込んだローカルサブディレクトリの対応が格納されています。

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

複数のサブモジュールを追加した場合は、このファイルに複数のエントリが書き込まれます。このファイルもまた他のファイルと同様にバージョン管理下に置かれることに注意しましょう。`.gitignore` ファイルと同じことです。プロジェクトの他のファイルと同様、このファイルもプッシュやプルの対象となります。プロジェクトをクローンした人は、このファイルを使ってサブモジュールの取得元を知ることになります。

`git status` の出力に、もうひとつ rack というエントリが含まれています。これに対して `git diff` を実行すると、ちょっと興味深い結果が得られます。

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

`rack` は作業ディレクトリ内にあるサブディレクトリですが、Git はそれがサブモジュールであるとみなし、あなたがそのディレクトリにいない限りその中身を追跡することはありません。そのかわりに、Git はこのサブディレクトリを元のプロジェクトの特定のコミットとして記録します。このサブディレクトリ内に変更を加えてコミットすると、親プロジェクト側で HEAD が変わったことを検知し、実際の作業内容をコミットとして記録します。そうすることで、他の人がこのプロジェクトをクローンしたときに正しく環境を作れるようになります。

ここがサブモジュールのポイントです。サブモジュールは、それがある場所の実際のコミットとして記録され、`master` やその他の参照として記録することはできません。

コミットすると、このようになります。

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

rack エントリのモードが 160000 となったことに注目しましょう。これは Git における特別なモードで、サブディレクトリやファイルではなくディレクトリエントリとしてこのコミットを記録したことを意味します。

`rack` ディレクトリを独立したプロジェクトとして扱い、ときどき親プロジェクトをアップデートして親プロジェクトの最新コミットにポインタを移動させることができます。すべての Git コマンドが、これらふたつのディレクトリで独立して使用可能です。

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### サブモジュールを含むプロジェクトのクローン ###

ここでは、内部にサブモジュールを含むプロジェクトをクローンしてみます。すると、サブモジュールを含むディレクトリは取得できますがその中にはまだ何もファイルが入っていません。

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

`rack` ディレクトリは存在しますが、中身がからっぽです。ここで、ふたつのコマンドを実行しなければなりません。まず `git submodule init` でローカルの設定ファイルを初期化し、次に `git submodule update` でプロジェクトからのデータを取得し、親プロジェクトで指定されている適切なコミットをチェックアウトします。

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

これで、サブディレクトリ `rack` の中身が先ほどコミットしたときとまったく同じ状態になりました。別の開発者が rack のコードを変更してコミットしたときにそれを取り込んでマージするには、もう少し付け加えます。

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

このマージで、サブモジュールが指すポインタの位置が変わりました。しかしサブモジュールディレクトリ内のコードは更新されていません。つまり、作業ディレクトリ内でダーティな状態になっています。

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

これは、サブモジュールのポインタが指す位置と実際のサブモジュールディレクトリの中身が異なるからです。これを修正するには、ふたたび `git submodule update` を実行します。

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

サブモジュールの変更をプロジェクトに取り込んだときには、毎回これをしなければなりません。ちょっと奇妙ですが、これでうまく動作します。

よくある問題が、開発者がサブモジュール内でローカルに変更を加えたけれどそれを公開サーバーにプッシュしていないときに起こります。ポインタの指す先を非公開の状態にしたまま、それを親プロジェクトにプッシュしてしまうと、他の開発者が `git submodule update` をしたときにサブモジュールが参照するコミットを見つけられなくなります。そのコミットは最初の開発者の環境にしか存在しないからです。この状態になると、次のようなエラーとなります。

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

サブモジュールを最後に更新したのがいったい誰なのかを突き止めなければなりません。

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

犯人がわかったら、メールで彼に怒鳴りつけてやりましょう。

### 親プロジェクト ###

時には、大規模なプロジェクトのサブディレクトリから今自分がいるチームに応じた組み合わせを取得したくなることもあるでしょう。これは、CVS や Subversion から移行した場合によくあることでしょう。モジュールを定義したりサブディレクトリのコレクションを定義していたりといったかつてのワークフローをそのまま維持したいというような状況です。

Git でこれと同じことをするためのよい方法は、それぞれのサブディレクトリを別々の Git リポジトリにして、それらのサブモジュールとして含む親プロジェクトとなる Git リポジトリを作ることです。この方式の利点は、親プロジェクトのタグやブランチを活用してプロジェクト間の関係をより細やかに定義できることです。

### サブモジュールでの問題 ###

しかし、サブモジュールを使っているとなにかしらちょっとした問題が出てくるものです。まず、サブモジュールのディレクトリで作業をするときはいつも以上に注意深くならなければなりません。`git submodule update` を実行すると、プロジェクトの特定のバージョンをチェックアウトしますが、それはブランチの中にあるものではありません。これを、切り離された HEAD (detached HEAD) と呼びます。つまり、HEAD が何らかの参照ではなく直接特定のコミットを指している状態です。通常は、HEAD が切り離された状態で作業をしようとは思わないでしょう。手元の変更が簡単に失われてしまうからです。最初に `submodule update` し、作業用のブランチを作らずにサブモジュールディレクトリ内にコミットし、`git submodule update` を再び実行すると、親プロジェクトでコミットが何もなくても Git は手元の変更を断りなく上書きしてしまいます。技術的な意味では手元の作業は失われたわけではないのですが、それを指すブランチが存在しない以上、先ほどの作業を取り戻すのは困難です。

この問題を回避するには、サブモジュールのディレクトリで作業をするときに `git checkout -b work` などとしてブランチを作っておきます。次にサブモジュールを更新するときにあなたの作業は消えてしまいますが、少なくとも元に戻すためのポインタは残っています。

サブモジュールを含むブランチを切り替えるのは、これまた用心が必要です。新しいブランチを作成してそこにサブモジュールを追加し、サブモジュールを含まないブランチに戻ったとしましょう。そこには、サブモジュールのディレクトリが「追跡されていないディレクトリ」として残ったままになります。

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

これをどこか別の場所に移すか、削除しなければなりません。いずれにせよ、先ほどのブランチに戻ったときには改めてクローンしなおさなければならず、ローカルでの変更やプッシュしていないブランチは失われてしまうことになります。

最後にもうひとつ、多くの人がハマるであろう点を指摘しておきましょう。これは、サブディレクトリからサブモジュールへ切り替えるときに起こることです。プロジェクト内で追跡しているファイルをサブモジュール内に移動したくなったとしましょう。よっぽど注意しないと、Git に怒られてしまいます。rack のファイルをプロジェクト内のサブディレクトリで管理しており、それをサブモジュールに切り替えたくなったとしましょう。サブディレクトリをいったん削除してから `submodule add` と実行すると、Git に怒鳴りつけられてしまいます。

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

まず最初に `rack` ディレクトリをアンステージしなければなりません。それからだと、サブモジュールを追加することができます。

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

これをどこかのブランチで行ったとしましょう。そこから、(まだサブモジュールへの切り替えがすんでおらず実際のツリーがある状態の) 別のブランチに切り替えようとすると、このようなエラーになります。

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

いったん `rack` サブモジュールのディレクトリを別の場所に追い出してからでないと、サブモジュールを持たないブランチに切り替えることはできません。

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

さて、戻ってきたら、空っぽの `rack` ディレクトリが得られました。ここで `git submodule update` を実行して再クローンするか、あるいは `/tmp/rack` ディレクトリを書き戻します。

## サブツリーマージ ##

サブモジュールの仕組みに関する問題を見てきました。今度は同じ問題を解決するための別の方法を見ていきましょう。Git でマージを行うときには、何をマージしなければならないのかを Git がまず調べてそれに応じた適切なマージ手法を選択します。ふたつのブランチをマージするときに Git が使うのは、_再帰 (recursive)_ 戦略です。三つ以上のブランチをマージするときには、Git は _たこ足 (octopus)_ 戦略を選択します。どちらの戦略を使うかは、Git が自動的に選択します。再帰戦略は複雑な三方向のマージ (共通の先祖が複数あるなど) もこなせますが、ふたつのブランチしか処理できないからです。たこ足マージは三つ以上のブランチを扱うことができますが、難しいコンフリクトを避けるためにより慎重になります。そこで、三つ以上のブランチをマージするときのデフォルトの戦略として選ばれています。しかし、それ以外にも選べる戦略があります。そのひとつが _サブツリー (subtree)_ マージで、これを使えば先ほどのサブプロジェクト問題に対応することができます。先ほどのセクションと同じような rack の取り込みを、サブツリーマージを用いて行う方法を紹介しましょう。

サブツリーマージの考え方は、ふたつのプロジェクトがあるときに一方のプロジェクトをもうひとつのプロジェクトのサブディレクトリに位置づけたりその逆を行ったりするというものです。サブツリーマージを指定すると、Git は一方が他方のサブツリーであることを理解して適切にマージを行います。驚くべきことです。

まずは Rack アプリケーションをプロジェクトに追加します。つまり、Rack プロジェクトをリモート参照として自分のプロジェクトに追加し、そのブランチにチェックアウトします。

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

これで Rack プロジェクトのルートが `rack_branch` ブランチに取得でき、あなたのプロジェクトが `master` ブランチにある状態になりました。まずどちらかをチェックアウトしてそれからもう一方に移ると、それぞれ別のプロジェクトルートとなっていることがわかります。

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Rack プロジェクトを `master` プロジェクトのサブディレクトリとして取り込みたくなったときには、`git read-tree` を使います。`read-tree` とその仲間たちについては第 9 章で詳しく説明します。現時点では、とりあえず「あるブランチのルートツリーを読み込んで、それを現在のステージングエリアと作業ディレクトリに書き込むもの」だと認識しておけばよいでしょう。まず `master` ブランチに戻り、`rack_branch` ブランチの内容を `master` ブランチの `rack` サブディレクトリに取り込みます。

	$ git read-tree --prefix=rack/ -u rack_branch

これをコミットすると、Rack のファイルをすべてサブディレクトリに取り込んだようになります。そう、まるで tarball からコピーしたかのような状態です。おもしろいのは、あるブランチでの変更を簡単に別のブランチにマージできるということです。もし Rack プロジェクトが更新されたら、そのブランチに切り替えてプルするだけで本家の変更を取得できます。

	$ git checkout rack_branch
	$ git pull

これで、変更を master ブランチにマージできるようになりました。`git merge -s subtree` を使えばうまく動作します。が、Git は歴史もともにマージしようとします。おそらくこれはお望みの動作ではないでしょう。変更をプルしてコミットメッセージを埋めるには、戦略を指定するオプション `-s subtree` のほかに `--squash` オプションと `--no-commit` オプションを使います。

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Rack プロジェクトでのすべての変更がマージされ、ローカルにコミットできる準備が整いました。この逆を行うこともできます。master ブランチの `rack` サブディレクトリで変更した内容を後で `rack_branch` ブランチにマージし、それをメンテナに投稿したり本家にプッシュしたりといったことも可能です。

`rack` サブディレクトリの内容と `rack_branch` ブランチのコードの差分を取得する (そして、マージしなければならない内容を知る) には、通常の `diff` コマンドを使うことはできません。そのかわりに、`git diff-tree` で比較対象のブランチを指定します。

	$ git diff-tree -p rack_branch

あるいは、`rack` サブディレクトリの内容と前回取得したときのサーバーの `master` ブランチとを比較するには、次のようにします。

	$ git diff-tree -p rack_remote/master

## まとめ ##

さまざまな高度な道具を使い、コミットやステージングエリアをより細やかに操作できる方法をまとめました。何か問題が起こったときには、いつ誰がどのコミットでそれを仕込んだのかを容易に見つけられるようになったことでしょう。また、プロジェクトの中で別のプロジェクトを使いたくなったときのための方法もいくつか紹介しました。Git を使った日々のコマンドラインでの作業の大半を、自信を持ってできるようになったことでしょう。
