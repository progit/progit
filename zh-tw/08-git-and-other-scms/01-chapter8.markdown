# Git 與其他系統 #

世界不是完美的。大多數時候，將所有接觸到的專案全部轉向 Git 是不可能的。有時我們不得不為某個專案使用其他的版本控制系統（VCS, Version Control System ），其中比較常見的是 Subversion 。你將在本章的第一部分學習使用 `git svn`，這是 Git 為 Subversion 附帶的雙向橋接工具。 

或許現在你已經在考慮將先前的專案轉向 Git 。本章的第二部分將介紹如何將專案遷移到 Git：先介紹從 Subversion 的遷移，然後是 Perforce，最後介紹如何使用自訂的腳本進行非標準的導入。

## Git 與 Subversion ##

目前，大多數開發中的開源專案以及大量的商業專案都使用 Subversion 來管理原始碼。作為最流行的開源版本控制系統，Subversion 已經存在了接近十年的時間。它在許多方面與 CVS 十分類似，後者是前者出現之前代碼控制世界的霸主。 

Git 最為重要的特性之一是名為 `git svn` 的 Subversion 雙向橋接工具。該工具把 Git 變成了 Subversion 服務的用戶端，從而讓你在本地享受到 Git 所有的功能，而後直接向 Subversion 伺服器推送內容，仿佛在本地使用了 Subversion 用戶端。也就是說，在其他人忍受古董的同時，你可以在本地享受分支合併，使用暫存區域，衍合以及單項挑揀(cherry-picking)等等。這是個讓 Git 偷偷潛入合作開發環境的好東西，在幫助你的開發同伴們提高效率的同時，它還能幫你勸說團隊讓整個專案框架轉向對 Git 的支持。這個 Subversion 之橋是通向分散式版本控制系統（DVCS, Distributed VCS ）世界的神奇隧道。 

### git svn ###

Git 中所有 Subversion 橋接命令的基礎是 `git svn` 。所有的命令都從它開始。相關的命令數目不少，你將通過幾個簡單的工作流程瞭解到其中常見的一些。

值得注意的是，在使用 `git svn` 的時候，你實際是在與 Subversion 互動，Git 比它要高級複雜的多。儘管可以在本地隨意的進行分支和合併，最好還是通過衍合保持線性的提交歷史，儘量避免類似「與遠端 Git 倉庫同步互動」這樣的操作。 

避免修改歷史再重新推送的做法，也不要同時推送到並行的 Git 倉庫來試圖與其他 Git 用戶合作。Subersion 只能保存單一的線性提交歷史，一不小心就會被搞糊塗。合作團隊中同時有人用 SVN 和 Git，一定要確保所有人都使用 SVN 服務來協作——這會讓生活輕鬆很多。 

### 初始設定 ###

為了示範功能，先要一個具有寫入許可權的 SVN 倉庫。如果想嘗試這個範例，你必須複製一份其中的測試倉庫。比較簡單的做法是使用一個名為 `svnsync` 的工具。較新的 Subversion 版本中都帶有該工具，它將資料編碼為用於網路傳輸的格式。 

要嘗試本例，先在本地新建一個 Subversion 倉庫：

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

然後，允許所有用戶修改 revprop —— 簡單的做法是增加一個總是以 0 作為傳回值的 pre-revprop-change 腳本： 

	$ cat /tmp/test-svn/hooks/pre-revprop-change
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

現在可以呼叫 `svnsync init`，參數加目標倉庫，再加來源倉庫，就可以把該專案同步到本地了： 

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/

這將建立進行同步所需的屬性(property)。可以通過執行以下命令來 clone 程式碼：

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

別看這個操作只花掉幾分鐘，要是你想把源倉庫複製到另一個遠端倉庫，而不是本地倉庫，那將花掉接近一個小時，儘管專案中只有不到 100 次的提交。 Subversion 每次只複製一次修改，把它推送到另一個倉庫裡，然後周而復始——驚人的低效率，但是我們別無選擇。 

### 入門 ###

有了可以寫入的 Subversion 倉庫以後，就可以嘗試一下典型的工作流程了。我們從 `git svn clone` 命令開始，它會把整個 Subversion 倉庫導入到一個本地的 Git 倉庫中。提醒一下，這裡導入的是一個貨真價實的 Subversion 倉庫，所以應該把下面的 `file:///tmp/test-svn` 換成你所用的 Subversion 倉庫的 URL： 

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

這相當於針對所提供的 URL 執行了兩條命令—— `git svn init` 加上 `gitsvn fetch` 。可能會花上一段時間。我們所用的測試專案僅僅包含 75 次提交並且它的代碼量不算大，所以只有幾分鐘而已。不過，Git 仍然需要提取每一個版本，每次一個，再逐個提交。對於一個包含成百上千次提交的專案，花掉的時間則可能是幾小時甚至數天。 

`-T trunk -b branches -t tags` 告訴 Git 該 Subversion 倉庫遵循了基本的分支和標籤命名法則。如果你的主幹(譯注：trunk，相當於非分散式版本控制裡的 master 分支，代表開發的主線）分支或者標籤以不同的方式命名，則應做出相應改變。由於該法則的常見性，可以使用 `-s` 來代替整條命令，它意味著標準佈局（s 是 Standard layout 的首字母），也就是前面選項的內容。下面的命令有相同的效果： 

	$ git svn clone file:///tmp/test-svn -s

現在，你有了一個有效的 Git 倉庫，包含著導入的分支和標籤： 

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

值得注意的是，該工具分配命名空間時和遠端參照的方式不盡相同。clone 普通的 Git 倉庫時，可以用 `origin/[branch]` 的形式取得遠端伺服器上所有可用的分支——分配到遠端服務的名稱下。然而 `git svn` 假定不存在多個遠端伺服器，所以把所有指向遠端服務的引用不加區分(no namespacing)的保存下來。可以用 Git 底層(plumbing)命令 `show-ref` 來查看所有引用的全名：

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

而普通的 Git 倉庫應該是這個模樣：

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

這裡有兩個遠端伺服器：一個名為 `gitserver` ，具有一個 `master` 分支；另一個叫 `origin`，具有 `master` 和 `testing` 兩個分支。 

注意本例中通過 `git svn` 導入的遠端參照，（Subversion 的)標籤是當作遠端分支增加的，而不是真正的 Git 標籤。導入的 Subversion 倉庫仿佛是有一個帶有不同分支的 tags 遠端伺服器。

### 提交到 Subversion ###

有了可以開展工作的（本地）倉庫以後，你可以開始對該專案做出貢獻並向上游倉庫提交內容了，Git 這時相當於一個 SVN 用戶端。假如編輯了一個檔並進行提交，那麼這次提交僅存在於本地的 Git 而非 Subversion 伺服器上：

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

接下來，可以將作出的修改推送到上游。值得注意的是，Subversion 的使用流程也因此改變了——你可以在離線狀態下進行多次提交然後一次性的推送到 Subversion 的伺服器上。向 Subversion 伺服器推送的命令是 `git svn dcommit`： 

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

所有在原 Subversion 資料基礎上提交的 commit 會一一提交到 Subversion，然後你本地 Git 的 commit 將被重寫，加入一個特別標識。這一步很重要，因為它意味著所有 commit 的 SHA-1 指都會發生變化。這也是同時使用 Git 和 Subversion 兩種服務作為遠端服務不是個好主意的原因之一。檢視以下最後一個 commit，你會找到新增加的 `git-svn-id` （譯注：即本段開頭所說的特別標識）： 

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

注意看，原本以 `97031e5` 開頭的 SHA-1 校驗值在提交完成以後變成了 `938b1a5` 。如果既要向 Git 遠端伺服器推送內容，又要推送到 Subversion 遠端伺服器，則必須先向 Subversion 推送（`dcommit`），因為該操作會改變所提交的資料內容。 

### 拉取最新進展 ###

如果要與其他開發者協作，總有那麼一天你推送完畢之後，其他人發現他們推送自己修改的時候（與你推送的內容）產生衝突。這些修改在你合併之前將一直被拒絕。在 `git svn` 裡這種情況像這樣： 

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

為了解決該問題，可以執行 `git svn rebase` ，它會拉取伺服器上所有最新的改變，再於此基礎上衍合你的修改： 

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

現在，你做出的修改都在 Subversion 伺服器上，所以可以順利的執行 `dcommit` ：

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

需要牢記的一點是，Git 要求我們在推送之前先合併上游倉庫中最新的內容，而 `git svn` 只要求存在衝突的時候才這樣做。假如有人向一個檔推送了一些修改，這時你要向另一個文件推送一些修改，那麼 `dcommit` 將正常工作：

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

這一點需要牢記，因為它的結果是推送之後專案處於一個不完整存在於任何主機上的狀態。如果做出的修改無法相容但沒有產生衝突，則可能造成一些很難確診的難題。這和使用 Git 伺服器是不同的——在 Git 世界裡，發佈之前，你可以在用戶端系統裡完整的測試專案的狀態，而在 SVN 永遠都沒法確保提交前後專案的狀態完全一樣。 

即使還沒打算進行提交，你也應該用這個命令從 Subversion 伺服器拉取最新修改。你可以執行 `git svn fetch` 取得最新的資料，不過 `git svn rebase` 才會在取得之後在本地進行更新 。 

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

不時地執行一下 `git svn rebase` 可以確保你的代碼沒有過時。不過，執行該命令時需要確保工作目錄的整潔。如果在本地做了修改，則必須在執行 `git svn rebase` 之前暫存工作、或暫時提交內容——否則，該命令會發現衍合的結果包含著衝突因而終止。 

### Git 分支問題 ###

習慣了 Git 的工作流程以後，你可能會建立一些特性分支，完成相關的開發工作，然後合併他們。如果要用 git svn 向 Subversion 推送內容，那麼最好是每次用衍合來併入一個單一分支，而不是直接合併。使用衍合的原因是 Subversion 只有一個線性的歷史而不像 Git 那樣處理合併，所以 Git svn 在把快照轉換為 Subversion 的 commit 時只能包含第一個祖先。 

假設分支歷史如下：建立一個 `experiment` 分支，進行兩次提交，然後合併到 `master` 。在 `dcommit` 的時候會得到如下輸出： 

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

在一個包含了合併歷史的分支上使用 `dcommit` 可以成功執行，不過在 Git 專案的歷史中，它沒有重寫你在 `experiment` 分支中的兩個 commit ——取而代之的是，這些改變出現在了 SVN 版本中同一個合併 commit 中。 

在別人 clone 該專案的時候，只能看到這個合併 commit 包含了所有發生過的修改；他們無法獲知修改的作者和時間等提交資訊。 

### Subversion 分支 ###

Subversion 的分支和 Git 中的不盡相同；避免過多的使用可能是最好方案。不過，用 git svn 建立和提交不同的 Subversion 分支仍是可行的。 

#### 建立新的 SVN 分支 ####

要在 Subversion 中建立一個新分支，可以執行 `git svn branch [分支名]`: 

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

這相當於在 Subversion 中的 `svn copy trunk branches/opera` 命令並且對 Subversion 伺服器進行了相關操作。值得提醒的是它沒有檢出(check out)並轉換到那個分支；如果現在進行提交，將提交到伺服器上的 `trunk`， 而非 `opera`。 

### 切換目前分支 ###

Git 通過搜尋提交歷史中 Subversion 分支的頭部(tip)來決定 dcommit 的目的地——而它應該只有一個，那就是目前分支歷史中最近一次包含 `git-svn-id` 的提交。 

如果需要同時在多個分支上提交，可以通過導入 Subversion 上某個其他分支的 commit 來建立以該分支為 `dcommit` 目的地的本地分支。比如你想擁有一個並行維護的 `opera` 分支，可以執行

	$ git branch opera remotes/opera

然後，如果要把 `opera` 分支併入 `trunk` （本地的 `master` 分支），可以使用普通的 `git merge`。不過最好提供一條描述提交的資訊（通過 `-m`），否則這次合併的記錄會是「Merge branch opera」，而不是任何有用的東西。 

記住，雖然使用了 `git merge` 來進行這次操作，並且合併過程可能比使用 Subversion 簡單一些（因為 Git 會自動找到適合的合併基礎），這並不是一次普通的 Git 合併提交。最終它將被推送回Subversion 伺服器上，而 Subversion 伺服器上無法處理包含多個祖先的 commit；因而在推送之後，它將變成一個包含了所有在其他分支上做出的改變的單一 commit。把一個分支合併到另一個分支以後，你沒法像在 Git 中那樣輕易的回到那個分支上繼續工作。提交時執行的 `dcommit` 命令擦掉了所有關於哪個分支被併入的資訊，因而以後的合併基礎計算將是不正確的—— dcommit 讓 `git merge` 的結果變得類似於 `git merge --squash`。不幸的是，我們沒有什麼好辦法來避免該情況—— Subversion 無法保存這個資訊，所以在使用它作為伺服器的時候你將永遠為這個缺陷所困。為了不出現這種問題，在把本地分支（本例中的 `opera`）併入 trunk 以後應該立即將其刪除。 

### 對應 Subversion 的命令 ###

`git svn` 工具集合了若干個與 Subversion 類似的功能，對應的命令可以簡化向 Git 的轉化過程。下面這些命令能實現 Subversion 的這些功能。 

#### SVN 風格的歷史紀錄 ####

習慣了 Subversion 的人可能想以 SVN 的風格顯示歷史，執行 `git svn log` 可以讓提交歷史顯示為 SVN 格式： 

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

關於 `git svn log` ，有兩點需要注意。首先，它可以離線工作，不像 `svn log 命令`，需要向 Subversion 伺服器索取資料。其次，它僅僅顯示已經提交到 Subversion 伺服器上的 commit。在本地尚未 dcommit 的 Git 資料不會出現在這裡；其他人向 Subversion 伺服器新提交的資料也不會顯示。等於說是顯示了最近已知 Subversion 伺服器上的狀態。 

#### SVN Annotation ####

類似 `git svn log` 命令模擬了 `svn log` 命令的離線操作，`svn annotate` 的等效命令是 `git svn blame [檔案名]`。其輸出如下： 

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

同樣，它不顯示本地的 Git 提交以及 Subversion 上後來更新的內容。

#### SVN 伺服器資訊 ####

還可以使用 `git svn info` 來取得與執行 `svn info` 類似的資訊： 

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

它與 blame 和 log 的相同點在於離線執行以及只更新到最後一次與 Subversion 伺服器通訊的狀態。 

#### 忽略 Subversion 所忽略的 ####

假如 clone 了一個包含了 `svn:ignore` 屬性的 Subversion 倉庫，就有必要建立對應的 `.gitignore` 文件來防止意外提交一些不應該提交的文件。`git svn` 有兩個有助於改善該問題的命令。第一個是 `git svn create-ignore`，它自動建立對應的 `.gitignore` 檔，以便下次提交的時候可以包含它。 

第二個命令是 `git svn show-ignore`，它把需要放進 `.gitignore` 檔中的內容列印到標準輸出，方便我們把輸出重定向到專案的黑名單檔(exclude file)： 

	$ git svn show-ignore > .git/info/exclude

這樣一來，避免了 `.gitignore` 對專案的干擾。如果你是一個 Subversion 團隊裡唯一的 Git 用戶，而其他隊友不喜歡專案裏出現 `.gitignore` 檔案，該方法是你的不二之選。 

### Git-Svn 總結 ###

`git svn` 工具集在目前不得不使用 Subversion 伺服器或者開發環境要求使用 Subversion 伺服器的時候格外有用。不妨把它看成一個跛腳的 Git，然而，你還是有可能在轉換過程中碰到一些困惑你和合作者們的謎題。為了避免麻煩，試著遵守如下守則： 

* 保持一個不包含由 `git merge` 產生的 commit 的線性提交歷史。將在主線分支外進行的開發通通衍合回主線；避免直接合併。 
* 不要單獨建立和使用一個 Git 服務來搞合作。可以為了加速新開發者的 clone 行程建立一個，但是不要向它提供任何不包含 `git-svn-id` 條目的內容。甚至可以增加一個 `pre-receive` 掛鉤，在每一個提交資訊中檢查 `git-svn-id`，並拒絕提交那些不包含它的 commit。 

如果遵循這些守則，在 Subversion 上工作還可以接受。然而，如果能遷徙到真正的 Git 伺服器，則能為團隊帶來更多好處。 

## 遷移到 Git ##

如果在其他版本控制系統(VCS)中保存了某專案的代碼而後決定轉而使用 Git，那麼該專案必須經歷某種形式的遷移。本節將介紹 Git 中包含的一些針對常見系統的導入腳本(importer)，並將示範編寫自訂的導入腳本的方法。

### 導入 ###

你將學習到如何從專業重量級的版本控制系統(SCM)中匯入資料—— Subversion 和 Perforce —— 因為據我所知這二者的用戶是（向 Git）轉換的主要群體，而且 Git 為此二者附帶了高品質的轉換工具。

### Subversion ###

讀過前一節有關 `git svn` 的內容以後，你應該能輕而易舉的根據其中的指導來 `git svn clone` 一個倉庫了；然後，停止 Subversion 的使用，向一個新 Git server 推送，並開始使用它。想保留歷史記錄，所花的時間應該不過就是從 Subversion 伺服器拉取資料的時間（可能要等上好一會就是了）。 

然而，這樣的匯入並不完美；而且還要花那麼多時間，不如乾脆一次把它做對！首當其衝的任務是作者資訊。在 Subversion，每個提交者都在主機上有一個使用者名稱，記錄在提交資訊中。上節例子中多處顯示了 schacon ，比如 `blame` 的輸出以及 `git svn log`。如果想讓這條資訊更好的映射到 Git 作者資料裡，則需要從 Subversion 使用者名稱到 Git 作者的一個映射關係。建立一個叫做 `user.txt` 的檔，用如下格式表示映射關係： 

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

通過以下命令可以獲得 SVN 作者的列表： 

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

它將輸出 XML 格式的日誌——你可以找到作者，建立一個單獨的列表，然後從 XML 中抽取出需要的資訊。（顯而易見，本方法要求主機上安裝了`grep`，`sort` 和 `perl`.）然後把輸出重定向到 user.txt 檔，然後就可以在每一項的後面增加相應的 Git 使用者資料。 

為 `git svn` 提供該檔可以讓它更精確的映射作者資料。你還可以在 `clone` 或者 `init` 後面增加 `--no-metadata` 來阻止 `git svn` 包含那些 Subversion 的附加資訊。這樣 `import` 命令就變成了：

	$ git svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

現在 `my_project` 目錄下導入的 Subversion 應該比原來整潔多了。原來的 commit 看上去是這樣： 

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029
現在是這樣： 

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

不僅作者一項乾淨了不少，`git-svn-id` 也就此消失了。 

你還需要一點 post-import（導入後） 清理工作。最起碼的，應該清理一下 `git svn` 建立的那些怪異的索引結構。首先要移動標籤，把它們從奇怪的遠端分支變成實際的標籤，然後把剩下的分支移動到本地。 

要把標籤變成合適的 Git 標籤，執行 

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname"; done

該命令將原本以 `tag/` 開頭的遠端分支的索引變成真正的 (lightweight) 標籤。 

接下來，把 `refs/remotes` 下面剩下的索引(reference)變成本地分支： 

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname"; done

現在所有的舊分支都變成真正的 Git 分支，所有的舊標籤也變成真正的 Git 標籤。最後一項工作就是把新增的 Git 伺服器增加為遠端伺服器並且向它推送。為了讓所有的分支和標籤都得到上傳，我們使用這條命令： 

	$ git remote add origin git@my-git-server:myrepository.git

Because you want all your branches and tags to go up, you can now run this:

	$ git push origin --all
	$ git push origin --tags

所有的分支和標籤現在都應該整齊乾淨的躺在新的 Git 伺服器裡了。 

### Perforce ###

你將瞭解到的下一個被導入的系統是 Perforce. Git 發行的時候同時也附帶了一個 Perforce 導入腳本，不過它是包含在原始碼的 `contrib` 部分——而不像 `git svn` 那樣預設就可以使用。執行它之前必須取得 Git 的原始碼，可以在 git.kernel.org 下載： 

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

在這個 `fast-import` 目錄下，應該有一個叫做 `git-p4` 的 Python 可執行腳本。主機上必須裝有 Python 和 `p4` 工具該導入才能正常進行。例如，你要從 Perforce 公開代碼倉庫（譯注： Perforce Public Depot，Perforce 官方提供的代碼寄存服務）導入 Jam 專案。為了設定用戶端，我們要把 P4PORT 環境變數 export 到 Perforce 倉庫： 

	$ export P4PORT=public.perforce.com:1666

執行 `git-p4 clone` 命令將從 Perforce 伺服器導入 Jam 專案，我們需要給出倉庫和專案的路徑以及導入的目標路徑： 

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

現在去 `/opt/p4import` 目錄執行一下 `git log` ，就能看到導入的成果： 

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

每一個 commit 裡都有一個 `git-p4` 識別字。這個識別字可以保留，以防以後需要引用 Perforce 的修改版本號。然而，如果想刪除這些識別字，現在正是時候——開始在新倉庫上工作之前。可以通過 `git filter-branch` 來批量刪除這些識別字： 

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

現在執行一下 `git log`，你會發現這些 commit 的 SHA-1 校驗值都發生了改變，而那些 `git-p4` 字串則從提交資訊裡消失了： 

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

至此導入已經完成，可以開始向新的 Git 伺服器推送了。 

### 自定導入腳本 ###

如果你的系統不是 Subversion 或 Perforce 之一，先上網找一下有沒有與之對應的導入腳本——導入 CVS，Clear Case，Visual Source Safe，甚至存檔目錄的導入腳本已經存在。假如這些工具都不適用，或者使用的工具很少見，抑或你需要導入過程具有更多可制定性，則應該使用 `git fast-import`。該命令從標準輸入讀取簡單的指令來寫入具體的 Git 資料。這樣建立 Git 物件比執行純 Git 命令或者手動寫物件要簡單的多（更多相關內容見第九章）。通過它，你可以編寫一個導入腳本來從導入來源讀取必要的資訊，同時在標準輸出直接輸出相關指令(instructions)。你可以執行該腳本並把它的輸出管道連接(pipe)到 `git fast-import`。 

下面演示一下如何編寫一個簡單的導入腳本。假設你在進行一項工作，並且按時通過把工作目錄複寫為以時間戳記 back_YY_MM_DD 命名的目錄來進行備份，現在你需要把它們導入 Git 。目錄結構如下： 

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

為了導入到一個 Git 目錄，我們首先回顧一下 Git 保存資料的方式。你可能還記得，Git 本質上是一個 commit 物件的鏈表，每一個物件指向一個內容的快照。而這裡需要做的工作就是告訴 `fast-import` 內容快照的位置，什麼樣的 commit 資料指向它們，以及它們的順序。我們採取一次處理一個快照的策略，為每一個內容目錄建立對應的 commit ，每一個 commit 與前一個 commit 建立連結。 

正如在第七章 “Git 執行策略一例” 一節中一樣，我們將使用 Ruby 來編寫這個腳本，因為它是我日常使用的語言而且閱讀起來簡單一些。你可以用任何其他熟悉的語言來重寫這個例子——它僅需要把必要的資訊列印到標準輸出而已。同時，如果你在使用 Windows，這意味著你要特別留意不要在換行的時候引入Enter符（譯注：carriage returns，Windows 換行時加入的符號，通常說的 \r ）—— Git 的 fast-import 對僅使用分行符號（LF）而非 Windows 的Enter符（CRLF）要求非常嚴格。 

首先，進入目標目錄並且找到所有子目錄，每一個子目錄將作為一個快照被導入為一個 commit。我們將依次進入每一個子目錄並列印所需的命令來匯出它們。腳本的主迴圈大致是這樣： 

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

我們在每一個目錄裡執行 `print_export`，它會取出上一個快照的索引和標記並返回本次快照的索引和標記；由此我們就可以正確的把二者連接起來。”標記（mark）” 是 `fast-import` 中對 commit 識別字的叫法；在建立 commit 的同時，我們逐一賦予一個標記以便以後在把它連接到其他 commit 時使用。因此，在 `print_export` 方法中要做的第一件事就是根據目錄名產生一個標記： 

	mark = convert_dir_to_mark(dir)

實現該函數的方法是建立一個目錄的陣列序列並使用陣列的索引值作為標記，因為標記必須是一個整數。這個方法大致是這樣的： 

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

有了整數來代表每個 commit，我們現在需要提交附加資訊中的日期。由於日期是用目錄名表示的，我們就從中解析出來。`print_export` 文件的下一行將是： 

	date = convert_dir_to_date(dir)

而 `convert_dir_to_date` 則定義為 

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

它為每個目錄回傳一個 integer。提交附加資訊裡最後一項所需的是提交者資料，我們在一個全域變數中直接定義之： 

	$author = 'Scott Chacon <schacon@example.com>'

我們差不多可以開始為導入腳本輸出提交資料了。第一項資訊指定我們定義的是一個 commit 物件以及它所在的分支，隨後是我們產生的標記、提交者資訊以及提交備註，然後是前一個 commit 的索引，如果有的話。程式碼大致像這樣： 

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

為了簡化，時區寫死(hardcode)為（-0700）。如果是從其他版本控制系統導入，則必須以變數的形式指定時區。
提交訊息必須以特定格式給出： 

	data (size)\n(contents)

該格式包含了「data」這個字、所讀取資料的大小、一個分行符號，最後是資料本身。由於隨後指定檔案內容的時候要用到相同的格式，我們寫一個輔助方法，`export_data`： 

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

唯一剩下的就是每一個快照的內容了。這簡單的很，因為它們分別處於一個目錄——你可以輸出 `deleeall` 命令，隨後是目錄中每個檔的內容。Git 會正確的記錄每一個快照： 

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

注意：由於很多系統把每次修訂看作一個 commit 到另一個 commit 的變化量，fast-import 也可以依據每次提交取得一個命令來指出哪些檔被增加，刪除或者修改過，以及修改的內容。我們將需要計算快照之間的差別並且僅僅給出這項資料，不過該做法要複雜很多——還不如直接把所有資料丟給 Git 讓它自己搞清楚。假如前面這個方法更適用於你的資料，參考 `fast-import` 的 man 説明頁面來瞭解如何以這種方式提供資料。 

列舉新檔內容或者指定帶有新內容的已修改檔的格式如下： 

	M 644 inline path/to/file
	data (size)
	(file contents)

這裡，644 是許可權模式（如果有執行檔，則需要偵測之並設定為 755），而 inline 說明我們在本行結束之後立即列出檔的內容。我們的 `inline_data` 方法大致是： 

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

我們再次使用了前面定義過的 `export_data`，因為這裡和指定提交注釋的格式如出一轍。 

最後一項工作是回傳目前的標記以便下次迴圈的使用。 

	return mark

注意：如果你是在 Windows 上執行，一定記得增加一項額外的步驟。前面提過，Windows 使用 CRLF 作為換行字元而 Git fast-import 只接受 LF。為了避開這個問題來滿足 git fast-import，你需要讓 ruby 用 LF 取代 CRLF： 

	$stdout.binmode

搞定了。現在執行該腳本，你將得到如下內容： 

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

要執行導入腳本，在需要導入的目錄把該內容用管道定向(pipe)到 `git fast-import`。你可以建立一個空目錄然後執行 `git init` 作為起點，然後執行該腳本： 

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

你會發現，在它成功執行完畢以後，會給出一堆有關已完成工作的資料。上例在一個分支導入了5次提交資料，包含了18個物件。現在可以執行 `git log` 來檢視新的歷史： 

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

就這樣——一個乾淨整潔的 Git 倉庫。需要注意的是此時沒有任何內容被檢出(checked out)——剛開始目前的目錄裡沒有任何檔。要取得它們，你得轉到 `master` 分支的所在： 

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

`fast-import` 還可以做更多——處理不同的檔案模式、二進位檔案、多重分支與合併、標籤、進展標識(progress indicators)等等。一些更加複雜的實例可以在 Git 原始碼的 `contib/fast-import` 目錄裡找到；較佳的其中之一是前面提過的 `git-p4` 腳本。 

## 總結 ##

現在的你應該掌握了在 Subversion 上使用 Git，以及把幾乎任何現存倉庫在不遺漏資料的情況下導入為 Git 倉庫。下一章將介紹 Git 內部的原始資料格式，從而使你能親手鍛造其中的每一個位元組，如果需要的話。 
