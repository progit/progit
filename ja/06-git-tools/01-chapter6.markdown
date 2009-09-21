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
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

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

`^` の後に数字を指定することもできます。たとえば `d921970^2` は "d921970 の二番目のの親" という意味になります。これが役立つのはマージコミット (親が複数存在する) のときくらいでしょう。最初の親はマージを実行したときにいたブランチとなり、二番目の親は取り込んだブランチ上のコミットとなります。

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

experiment ブランチの内容のうち、まだ master ブランチにマージされていないものを調べることになりました。対象と鳴るコミットのログを見るには、Git に `master..experiment` と指示します。これは "experiment からはたどれるけれど、master からはたどれないすべてのコミット" という意味です。説明を短く簡潔にするため、実際のログの出力のかわりに上の図の中でコミットオブジェクトをあらわす文字を使うことにします。

	$ git log master..experiment
	D
	C

もし逆に、`master` には存在するけれども `experiment` には存在しないすべてのコミットが知りたいのなら、ブランチ名を逆にすればいいのです。`experiment..master` とすれば、`master` のすべてのコミットのうち `experiment` からたどれないものを取得できます。

	$ git log experiment..master
	F
	E

これは、`experiment` ブランチを最新の状態に保つために何をマージしなければならないのかを知るのに便利です。もうひとつ、この構文をよく使う例としてあげられるのが、これからリモートにプッシュしようとしている内容を知りたいときです。

	$ git log origin/master..HEAD

このコマンドは、現在のブランチ上でのコミットのうち、リモート `origin` の `master` ブランチに存在しないものをすべて表示します。現在のブランチが `origin/master` を追跡しているときに `git push` を実行すると、`git log origin/master..HEAD` で表示されたコミットがサーバに転送されます。この構文で、どちらか片方を省略することもできます。その場合、Git は省略したほうを HEAD とみなします。たとえば、`git log origin/master..` と入力すると先ほどの例と同じ結果が得られます。Git は、省略した側を HEAD に置き換えて処理を進めるのです。

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
	# Changed but not updated:
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
	nothing to commit (working directory clean)

これで、簡単にブランチを切り替えて別の作業をできるようになりました。これまでの変更内容はスタックに格納されています。今までに格納した内容を見るには `git stash list` を使います。

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

この例では、以前にも二回ほど作業を隠していたようです。そこで、三種類の異なる作業にアクセスできるようになっています。先ほど隠した変更を再度適用するには、stash コマンドの出力に書かれていたように `git stash apply` コマンドを実行します。それよりもっと前に隠したものを適用したい場合は `git stash apply stash@{2}` のようにして名前を指定することもできます。名前を指定しなければ、Git は直近に隠された変更を再適用します。

	$ git stash apply
	# On branch master
	# Changed but not updated:
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
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

apply オプションは、スタックに隠した作業を再度適用するだけで、スタックにはまだその作業が残ったままになります。スタックから削除するには、`git stash drop` に削除したい作業の名前を指定して実行します。

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

あるいは `git stash pop` を実行すれば、隠した内容を再適用してその後スタックからも削除してくれます。

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
	# Changed but not updated:
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

これはリベースコマンドであることを認識しておきましょう。 `HEAD~3..HEAD` に含まれるすべてのコミットは、実際にメッセージを変更したか否かにかかわらずすべて書き換えられます。すでに中央サーバにプッシュしたコミットをここに含めてはいけません。含めてしまうと、同じ変更が別のバージョンで見えてしまうことになって他の開発者が混乱します。

このコマンドを実行すると、テキストエディタが開いてコミットの一覧が表示され、このようになります。

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

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

### Squashing a Commit ###

It’s also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool. The script puts helpful instructions in the rebase message:

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

If, instead of "pick" or "edit", you specify "squash", Git applies both that change and the change directly before it and makes you merge the commit messages together. So, if you want to make a single commit from these three commits, you make the script look like this:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

When you save and exit the editor, Git applies all three changes and then puts you back into the editor to merge the three commit messages:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

When you save that, you have a single commit that introduces the changes of all three previous commits.

### Splitting a Commit ###

Splitting a commit undoes a commit and then partially stages and commits as many times as commits you want to end up with. For example, suppose you want to split the middle commit of your three commits. Instead of "updated README formatting and added blame", you want to split it into two commits: "updated README formatting" for the first, and "added blame" for the second. You can do that in the `rebase -i` script by changing the instruction on the commit you want to split to "edit":

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Then, when the script drops you to the command line, you reset that commit, take the changes that have been reset, and create multiple commits out of them. When you save and exit the editor, Git rewinds to the parent of the first commit in your list, applies the first commit (`f7f3f6d`), applies the second (`310154e`), and drops you to the console. There, you can do a mixed reset of that commit with `git reset HEAD^`, which effectively undoes that commit and leaves the modified files unstaged. Now you can stage and commit files until you have several commits, and run `git rebase --continue` when you’re done:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git applies the last commit (`a5f4a0d`) in the script, and your history looks like this:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Once again, this changes the SHAs of all the commits in your list, so make sure no commit shows up in that list that you’ve already pushed to a shared repository.

### The Nuclear Option: filter-branch ###

There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit. The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite. However, it can be very useful. You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of.

#### Removing a File from Every Commit ####

This occurs fairly commonly. Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere. Perhaps you accidentally committed a file that contained a password, and you want to make your project open source. `filter-branch` is the tool you probably want to use to scrub your entire history. To remove a file named passwords.txt from your entire history, you can use the `--tree-filter` option to `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

The `--tree-filter` option runs the specified command after each checkout of the project and then recommits the results. In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not. If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch --tree-filter 'rm -f *~' HEAD`.

You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end. It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want. To run `filter-branch` on all your branches, you can pass `--all` to the command.

#### Making a Subdirectory the New Root ####

Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on). If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Now your new project root is what was in the `trunk` subdirectory each time. Git will also automatically remove commits that did not affect the subdirectory. 

#### Changing E-Mail Addresses Globally ####

Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address. In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well. You need to be careful to change only the e-mail addresses that are yours, so you use `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

This goes through and rewrites every commit to have your new address. Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address.

## Debugging with Git ##

Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.

### File Annotation ###

If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22:

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

Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.

Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:

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

This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file.

### Binary Search ###

Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.

Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:

	$ git bisect reset

This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.

## Submodules ##

It often happens that while working on one project, you need to use another project from within it. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.

Here’s an example. Suppose you’re developing a web site and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.

Git addresses this issue using submodules. Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.

### Starting with Submodules ###

Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes. The first thing you should do is clone the external repository into your subdirectory. You add external projects as submodules with the `git submodule add` command:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Now you have the Rack project under a subdirectory named `rack` within your project. You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more. If you run `git status` right after you add the submodule, you see two things:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

First you notice the `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file. It’s pushed and pulled with the rest of your project. This is how other people who clone this project know where to get the submodule projects from.

The other listing in the `git status` output is the rack entry. If you run `git diff` on that, you see something interesting:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory. Instead, Git records it as a particular commit from that repository. When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly.

This is an important point with submodules: you record them as the exact commit they’re at. You can’t record a submodule at `master` or some other symbolic reference.

When you commit, you see something like this:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Notice the 160000 mode for the rack entry. That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file.

You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject. All the Git commands work independently in the two directories:

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

### Cloning a Project with Submodules ###

Here you’ll clone a project with a submodule in it. When you receive such a project, you get the directories that contain submodules, but none of the files yet:

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

The `rack` directory is there, but empty. You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject:

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

Now your `rack` subdirectory is at the exact state it was in when you committed earlier. If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory. To fix this, you must run `git submodule update` again:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

You have to do this every time you pull down a submodule change in the main project. It’s strange, but it works.

One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server. Then, they commit a pointer to that non-public state and push up the superproject. When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system. If that happens, you see an error like this:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

You have to see who last changed the submodule:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Then, you e-mail that guy and yell at him.

### Superprojects ###

Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on. This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow.

A good way to do this in Git is to make each of the subfolders a separate Git repository and then create superproject Git repositories that contain multiple submodules. A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects.

### Issues with Submodules ###

Using submodules isn’t without hiccups, however. First, you must be relatively careful when working in the submodule directory. When you run `git submodule update`, it checks out the specific version of the project, but not within a branch. This is called having a detached head — it means the HEAD file points directly to a commit, not to a symbolic reference. The issue is that you generally don’t want to work in a detached head environment, because it’s easy to lose changes. If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.  Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieive.

To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent. When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to.

Switching branches with submodules in them can also be tricky. If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory:

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

You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up.

The last main caveat that many people run into involves switching from subdirectories to submodules. If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you. Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule. If you delete the subdirectory and then run `submodule add`, Git yells at you:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

You have to unstage the `rack` directory first. Then you can add the submodule:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Now suppose you did that in a branch. If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Then, when you switch back, you get an empty `rack` directory. You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory.

## Subtree Merging ##

Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a _recursive_ strategy. If you’re merging more than two branches, Git picks the _octopus_ strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.

However, there are other strategies you can choose as well. One of them is the _subtree_ merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.

The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.

You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch:

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

Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch. If you check out one and then the other, you can see that they have different project roots:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

You want to pull the Rack project into your `master` project as a subdirectory. You can do that in Git with `git read-tree`. You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project:

	$ git read-tree --prefix=rack/ -u rack_branch

When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:

	$ git checkout rack_branch
	$ git pull

Then, you can merge those changes back into your master branch. You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the `--squash` and `--no-commit` options as well as the `-s subtree` strategy option:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream.

To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command. Instead, you must run `git diff-tree` with the branch you want to compare to:

	$ git diff-tree -p rack_branch

Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run

	$ git diff-tree -p rack_remote/master

## Summary ##

You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely. When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom. If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs. At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so.
