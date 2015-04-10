# Git 工具 #

現在，你已經學習了管理或者維護 Git 倉庫，實現代碼控制所需的大多數日常命令和工作流程。你已經完成了跟蹤和提交檔案的基本任務，並且發揮了暫存區(staging area)和羽量級的特性分支及合併的威力。

接下來你將領略到一些 Git 可以實現的非常強大的功能，這些功能你可能並不會在日常操作中使用，但在某些時候你也許會需要。 

## 選擇修訂版本 ##

Git 允許你通過幾種方法來指定特定的或者一定範圍內的提交。瞭解它們並不是必需的，但是瞭解一下總沒壞處。 

### 單個修訂版本 ###

顯然你可以使用給出的 SHA-1 值來指定一次提交，不過也有更加人性化的方法來做同樣的事。本節概述了指定單個提交的諸多方法。 

### 簡短的 SHA ###

Git 很聰明，它能夠通過你提供的前幾個字元來識別你想要的那次提交，只要你提供的那部分 SHA-1 不短於四個字元，並且沒有歧義——也就是說，目前倉庫中只有一個物件以這段 SHA-1 開頭。 

例如，想要查看一次指定的提交，假設你執行 `git log` 命令並找到你增加了功能的那次提交： 

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

假設是 `1c002dd`.... 。如果你想 `git show` 這次提交，下面命令的作用是相同的（假設簡短的版本沒有歧義）： 

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git 可以為你的 SHA-1 值生成出簡短且唯一的縮寫。如果你傳遞 `--abbrev-commit` 給 `git log` 命令，輸出結果裡就會使用簡短且唯一的值；它預設使用七個字元來表示，不過必要時為了避免 SHA-1 的歧義，會增加字元數： 

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

通常在一個專案中，使用八到十個字元來避免 SHA-1 歧義已經足夠了。最大的 Git 專案之一，Linux 核心，目前也只需要最長 40 個字元中的 12 個字元來保持唯一性。 

### 關於 SHA-1 的簡短說明 ###

許多人可能會擔心一個問題：在隨機的偶然情況下，在他們的倉庫裡會出現兩個具有相同 SHA-1 值的物件。那會怎麼樣呢？ 

如果你真的向倉庫裡提交了一個跟之前的某個物件具有相同 SHA-1 值的物件，Git 將會發現之前的那個物件已經存在在 Git 資料庫中，並認為它已經被寫入了。如果什麼時候你想再次檢出那個物件時，你會總是得到先前的那個物件的資料。 

不過，你應該瞭解到，這種情況發生的概率是多麼微小。SHA-1 摘要長度是 20 位元組，也就是 160 位元。為了保證有 50% 的概率出現一次衝突，需要 2^80 個隨機雜湊的物件（計算衝突機率的公式是 p = (n(n-1)/2) * (1/2^160))。2^80 是 1.2 x 10^24，也就是一億億億，那是地球上沙粒總數的 1200 倍。 

現在舉例說一下怎樣才能產生一次 SHA-1 衝突。如果地球上 65 億的人類都在程式設計，每人每秒都在產生相當於整個 Linux 核心歷史（一百萬個 Git 物件）的代碼，並將之提交到一個巨大的 Git 倉庫裡面，那將花費 5 年的時間才會產生足夠的物件，使其擁有 50% 的概率產生一次 SHA-1 物件衝突。這要比你程式設計團隊的成員同一個晚上在互不相干的意外中被狼襲擊並殺死的機率還要小。 

### 分支引用 (Branch References) ###

指定一次提交的最直接的方法是有一個指向它的分支引用。這樣，你就可以在任何需要一個提交物件或者 SHA-1 值的 Git 命令中使用該分支名稱了。如果你想要顯示一個分支的最後一次提交的物件，例如假設 topic1 分支指向 ca82a6d，那麼下面的命令是相等的： 

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

如果你想知道某個分支指向哪個特定的 SHA，或者想看任何一個例子中被簡寫的 SHA-1，你可以使用一個叫做 `rev-parse` 的 Git plumbing 工具。在第 9 章你可以看到關於 plumbing 工具的更多資訊；簡單來說，`rev-parse` 是為了底層操作而不是日常操作設計的。不過，有時你想看 Git 現在到底處於什麼狀態時，它可能會很有用。現在，你可以對你的分支執行 `rev-parse`：

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### 引用日誌(RefLog)裡的簡稱  ###

在你工作的同時，Git 在後臺的工作之一就是保存一份引用日誌(reflog)——一份記錄最近幾個月你的 HEAD 和分支引用的日誌。 

你可以使用 `git reflog` 來查看引用日誌：

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

每次你的分支頂端因為某些原因被修改時，Git 就會為你將資訊保存在這個臨時歷史記錄裡面。你也可以使用這份資料來指定更早的分支。如果你想查看倉庫中 HEAD 在五次前的值，你可以使用引用日誌的輸出中的 @{n} 引用： 

	$ git show HEAD@{5}

你也可以使用這個語法來查看一定時間前分支指向哪裡。例如，想看你的 `master` 分支昨天在哪，你可以輸入 

	$ git show master@{yesterday}

它就會顯示昨天分支的頂端在哪。這項技術只對還在你引用日誌裡的資料有用，所以不能用來查看比幾個月前還早的提交。 

想要看類似於 `git log` 輸出格式的引用日誌資訊，你可以執行 `git log -g`：

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

需要注意的是，日誌引用資訊只存在於本地——這是一個你在倉庫裡做過什麼的日誌。這些引用不會和其他人的倉庫拷貝裡的相同；當你新 clone 一個倉庫的時候，引用日誌是空的，因為你在倉庫裡還沒有操作。只有你克隆了一個專案至少兩個月，`git show HEAD@{2.months.ago}` 才會有用——如果你是五分鐘前克隆的倉庫，將不會有結果回傳。

### 祖先引用 (Ancestry References) ###

另一種指定某次提交的常用方法是通過它的祖先。如果你在引用最後加上一個 `^`，Git 將其理解為此次提交的父提交。 假設你的專案歷史是這樣的：

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

那麼，想看上一次提交，你可以使用 `HEAD^`，意思是「HEAD 的父提交」： 

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

你也可以在 `^` 後增加一個數字——例如，`d921970^2` 意思是「d921970 的第二父提交」。這種語法只在合併提交時有用，因為合併提交可能有多個父提交。第一父提交是你合併時所在分支，而第二父提交是你所合併進來的分支： 

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

另外一個指定祖先提交的方法是 `~`。這也是指向第一父提交，所以 `HEAD~` 和 `HEAD^` 是相等的。當你指定數字的時候就明顯不一樣了。`HEAD~2` 是指「第一父提交的第一父提交」，也就是「祖父提交」——它會根據你指定的次數檢索第一父提交。例如，在上面列出的歷史記錄裡面，`HEAD~3` 會是 

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

也可以寫成 HEAD^^^，同樣是第一父提交的第一父提交的第一父提交： 

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

你也可以混合使用這些語法——你可以通過 `HEAD~3^2` 指定先前引用的第二父提交（假設它是一個合併提交），依此類推。 

### 提交範圍 ###

現在你已經可以指定單次的提交，讓我們來看看怎樣指定一定範圍的提交。這在你管理分支的時候尤顯重要——如果你有很多分支，你可以指定範圍來圈定一些問題的答案，比如：「這個分支上我有哪些工作還沒合併到主分支的？」 

#### 雙點 ####

最常用的指定範圍的方法是雙點的語法。這種語法主要是讓 Git 區分出可從一個分支中獲得而不能從另一個分支中獲得的提交。例如，假設你有類似於圖 6-1 的提交歷史。 

Insert 18333fig0601.png
Figure 6-1. 範圍選擇的提交歷史實例

你想要查看你的試驗分支(experiment)上哪些沒有被提交到主分支，那麼你就可以使用 `master..experiment` 來讓 Git 顯示這些提交的日誌——這句話的意思是「所有可從 experiment 分支中獲得而不能從 master 分支中獲得的提交」。為了使例子簡單明瞭，我使用了圖示中提交物件的字母，來代替它們在實際的日誌輸出裏的顯示順序： 

	$ git log master..experiment
	D
	C

另一方面，如果你想看相反的——所有在 `master` 而不在 `experiment` 中的分支——你可以交換分支的名字。experiment..master 顯示所有可在 master 獲得而在 experiment 中不能獲得的提交： 

	$ git log experiment..master
	F
	E

這在你想將 `experiment` 分支維持在最新狀態，並預覽你將合併的提交的時候特別有用。這個語法的另一種常見用途是查看你將把什麼推送到遠端： 

	$ git log origin/master..HEAD

這條命令顯示任何在你目前分支上而不在遠端 `origin` 上的 `master` 分支上的提交。如果你執行 `git push` 並且你的目前分支正在追蹤 `origin/master`，被 `git log origin/master..HEAD` 列出的提交就是將被傳輸到伺服器上的提交。
你也可以省略語法中的一邊讓 Git 來假定它是 HEAD。例如，輸入 git log origin/master.. 將得到和上面的例子一樣的結果—— Git 使用 HEAD 來代替不存在的一邊。

#### 多點 ####

雙點語法就像速記一樣有用；但是你也許會想針對兩個以上的分支來指定修訂版本，比如查看哪些提交被包含在某些分支中的一個，但是不在你目前的分支上。Git 允許你在引用前使用 `^` 字元或者 `--not` 指定你不希望提交被包含其中的分支。因此下面三個命令是等同的： 

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

這樣很好，因為它允許你在查詢中指定多於兩個的引用，而這是雙點語法所做不到的。例如，如果你想查找所有從 `refA` 或 `refB` 包含的但是不被 `refC` 包含的提交，你可以輸入下面中的一個

	$ git log refA refB ^refC
	$ git log refA refB --not refC

這建立了一個非常強大的修訂版本查詢系統，應該可以幫助你了解你的分支裡有些什麼東西。 

#### 三點 ####

最後一種主要的範圍選擇語法是三點語法，這個可以指定被兩個引用中的一個包含但又不被兩者同時包含的分支。回過頭來看一下圖6-1裡所列的提交歷史的例子。
如果你想查看 `master` 或者 `experiment` 中包含的但不是兩者共有的引用，你可以執行 

	$ git log master...experiment
	F
	E
	D
	C

這個再次給出你普通的 `log` 輸出但是只顯示那四次提交的資訊，按照傳統的提交日期排列。 

這種情形下，`log` 命令的一個常用參數是 `--left-right`，它會顯示每個提交到底處於哪一側的分支。這使得資料更加有用。 

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

有了以上工具，讓 Git 知道你要察看哪些提交就容易得多了。 

## 互動式暫存 ##

Git 提供了很多腳本來輔助某些命令列任務。這裡，你將看到一些互動式命令，它們幫助你方便地構建只包含特定組合和部分檔案的提交。在你修改了一大批檔案然後決定將這些變更分佈在幾個有聚焦的提交而不是單個又大又亂的提交時，這些工具非常有用。用這種方法，你可以確保你的提交在邏輯上劃分為相應的變更集合，以便於和你一起工作的開發者審閱。 
如果你執行 `git add` 時加上 `-i` 或者 `--interactive` 選項，Git 就進入了一個互動式的 shell 模式，顯示一些類似於下面的資訊： 

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

你會看到這個命令以一個完全不同的視圖顯示了你的暫存區——主要是你通過 `git status` 得到的那些資訊但是稍微簡潔但資訊更加豐富一些。它在左側列出了你暫存的變更，在右側列出了未被暫存的變更。 

在這之後是一個命令區。這裡你可以做很多事情，包括暫存檔案(stage)、撤回檔案(unstage)、暫存部分檔案、加入未被追蹤的文件、查看暫存文件的差別。 

### 暫存和撤回檔案 ###

如果你在 `What now>` 的提示後輸入 `2` 或者 `u`，這個腳本會提示你那些檔你想要暫存： 

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

如果想暫存 TODO 和 index.html，你可以輸入相應的編號： 

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

每個檔旁邊的 `*` 表示選中的檔將被暫存。如果你在 update>> 提示後直接敲入 Enter，Git會替你把所有選中的內容暫存： 

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

現在你可以看到 TODO 和 index.html 檔被暫存了，同時 simplegit.rb 檔仍然未被暫存。如果這時你想要撤回 TODO 檔，就使用 `3` 或者 `r`（代表 revert，恢復）選項： 

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

再次查看 Git 的狀態，你會看到你已經撤回了 TODO 檔 

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

要查看你暫存內容的差異，你可以使用 `6` 或者 `d`（表示diff）命令。它會顯示你暫存檔的列表，你可以選擇其中的幾個，顯示其被暫存的差異。這跟你在命令列下指定 `git diff --cached` 非常相似： 

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

通過這些基本命令，你可以使用互動式增加模式更加方便地處理暫存區。 

### 暫存修補檔 (Staging Patches) ###

只讓 Git 將檔案的某些部分暫存，而忽略其他部份也是有可能的。例如，你對 simplegit.rb 檔作了兩處修改但是只想暫存其中一個而忽略另一個，在 Git 中實現這一點非常容易。在互動式的提示符下，輸入 `5` 或者 `p`（表示 patch，修補檔）。Git 會詢問哪些檔你希望部分暫存；然後對於被選中檔案的每一節，他會逐個顯示檔案的差異區塊並詢問你是否希望暫存他們： 

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

此處你有很多選擇。輸入 `?` 可以顯示清單： 

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

如果你想暫存各個區塊，通常你會輸入 `y` 或者 `n`，但是暫存特定檔裡的全部區塊或者暫時跳過對一個區塊的處理同樣也很有用。如果你暫存了檔案的一個部分而保留另外一個部分不被暫存，你的狀態輸出看起來會是這樣： 

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

simplegit.rb 的狀態非常有意思。它顯示有幾行被暫存了，有幾行沒有。你部分地暫存了這個檔案。這時候，你可以退出互動式腳本然後執行 `git commit` 來提交部分暫存的檔案。 

最後，你也可以不通過互動式增加的模式來實現檔案部分暫存——你可以在命令列下使用 `git add -p` 或者 `git add --patch` 來啟動同樣的腳本。 

## 儲藏 (Stashing) ##

經常有這樣的事情發生，當你正在進行專案中某一部分的工作，裡面的東西處於一個比較雜亂的狀態，而你想轉到其他分支上進行一些工作。問題是，你不想只為了待會要回到這個工作點，就把做到一半的工作進行提交。解決這個問題的辦法就是 `git stash` 命令。 

「儲藏」可以取得你工作目錄的 dirty state——也就是你修改過的被追蹤檔和暫存的變更——並將它保存到一個未完成變更的堆疊(stack)中，隨時可以重新套用。 

### 儲藏你的工作 ###

為了演示這一功能，你可以進入你的專案，在一些檔上進行工作，有可能還暫存其中一個變更。如果你執行 `git status`，你可以看到你的 dirty state： 

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

現在你想切換分支，但是你還不想提交你正在進行中的工作；所以你儲藏這些變更。為了往堆疊推送一個新的儲藏，執行 `git stash`： 

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

你的工作目錄就乾淨了： 

	$ git status
	# On branch master
	nothing to commit, working directory clean

這時，你可以方便地切換到其他分支工作；你的變更都保存在堆疊上。要查看現有的儲藏，你可以使用 `git stash list`： 

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

在這個案例中，之前已經進行了兩次儲藏，所以你可以取得三個不同的儲藏。你可以重新套用你剛剛的儲藏，所採用的命令就是原本 stash 命令輸出的輔助訊息裡提示的：`git stash apply`。如果你想應用較舊的儲藏，你可以通過名字指定它，像這樣：`git stash apply stash@{2}`。如果你不指定，Git 預設使用最近的儲藏並嘗試應用它： 

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

你可以看到 Git 重新修改了你所儲藏的那些當時尚未提交的檔案。在這個案例裡，你嘗試應用儲藏的工作目錄是乾淨的，並且屬於同一分支；但是一個乾淨的工作目錄和套用到相同的分支上並不是應用儲藏的必要條件。你可以在其中一個分支上保留一份儲藏，隨後切換到另外一個分支，再重新套用這些變更。在工作目錄裡包含已修改、未提交的檔時，你也可以應用儲藏——Git 會給出合併衝突，如果有任何變更無法乾淨地被應用。 

對檔案的變更被重新套用，但是被暫存的檔沒有重新被暫存。想那樣的話，你必須在執行 `git stash apply` 命令時帶上一個 `--index` 的選項來重新套用被暫存的變更。如果你是這麼做的，你應該已經回到你原來的位置：

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

apply 選項只嘗試應用儲藏的工作——儲藏的內容仍然在堆疊上。要移除它，你可以執行 `git stash drop`，加上你希望移除的儲藏的名字： 

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

你也可以執行 `git stash pop` 來重新套用儲藏，同時立刻將其從堆疊中移走。 

### 取消儲藏 (Un-applying a Stash) ###

在某些使用情境下，你可能想要應用儲藏的變更，做一些工作，然後又要把來自原儲藏的變更取消。Git 並未提供類似 `stash unapply` 的命令，但是達成相同效果是可能的，只要取得該儲藏關連的修補檔然後反向應用它就行了：

    $ git stash show -p stash@{0} | git apply -R

同樣的，如果你沒有指定某個儲藏，Git 會預設為最近的儲藏：

    $ git stash show -p | git apply -R

你可能會想要新建一個別名，在你的 git 增加一個 `stash-unapply` 命令，這樣更有效率。例如：

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

### 從儲藏中建立分支 ###

如果你儲藏了一些工作，暫時不去理會，然後繼續在你儲藏工作的分支上工作，你在重新套用工作時可能會碰到一些問題。如果嘗試應用的變更是針對一個你那之後修改過的檔，你會碰到一個合併衝突並且必須去化解它。如果你想用更方便的方法來重新檢驗你儲藏的變更，你可以執行 `git stash branch`，這會建立一個新的分支，檢出你儲藏工作時所處的提交，重新套用你的工作，如果成功，將會丟棄儲藏。 

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

這是一個很棒的捷徑來恢復儲藏的工作然後在新的分支上繼續當時的工作。 

## 重寫歷史 ##

很多時候，在 Git 上工作的時候，你也許會由於某種原因想要修訂你的提交歷史。Git 的一個卓越之處就是它允許你在最後可能的時刻再作決定。你可以在你即將提交暫存區時決定什麼檔歸入哪一次提交，你可以使用 stash 命令來決定你暫時擱置的工作，你可以重寫已經發生的提交以使它們看起來是另外一種樣子。這個包括改變提交的次序、改變說明或者修改提交中包含的檔，將提交歸併(squash)、拆分或者完全刪除——這一切在你尚未開始將你的工作和別人共用前都是可以的。 

在這一節中，你會學到如何完成這些很有用的任務，使得你的提交歷史在你將其共用給別人之前變成你想要的樣子。 

### 改變最後一次提交 ###

改變最後一次提交也許是最常見的重寫歷史的行為。對於你的最近一次提交，你經常想做兩件基本事情：改變提交說明，或者經由增加、改變、移除檔案而改變你剛記錄的快照。

如果你只想修改最近一次提交說明，這非常簡單： 

	$ git commit --amend

這會把你帶入文字編輯器，裡面包含了你最近一次提交的說明訊息，供你修改。當你保存並退出編輯器，這個編輯器會寫入一個新的提交，裡面包含了那個說明，並且讓它成為你的新的最後提交。

如果你完成提交後又想修改被提交的快照，增加或者修改其中的檔案，可能因為你最初提交時，忘了增加一個新增的檔，這個過程基本上一樣。你通過修改檔案然後對其執行 `git add` 或對一個已被記錄的檔執行 `git rm`，隨後的 `git commit --amend` 會取得你目前的暫存區並將它作為新提交對應的快照。 

使用這項技術的時候你必須小心，因為修正會改變提交的SHA-1值。這個很像是一次非常小的 rebase——不要在你最近一次提交被推送後還去修正它。 

### 修改多個提交訊息 ###

要修改歷史中更早的提交，你必須採用更複雜的工具。Git 沒有一個修改歷史的工具，但是你可以使用 rebase 工具來衍合一系列的提交到它們原來所在的 HEAD 上而不是移到新的上。依靠這個互動式的 rebase 工具，你就可以停留在每一次提交後，如果你想修改或改變說明、增加檔案或做任何事情。在 `git rebase` 增加 `-i` 選項可以對話模式執行 rebase。你必須告訴 rebase 命令要衍合到哪次提交，來指定你想要重寫的提交要回溯到多遠。 

例如，你想修改最近三次的提交說明，或者其中任意一次，你必須給 `git rebase -i` 提供一個參數，指定你想要修改的提交的父提交，例如 `HEAD~2^` 或者 `HEAD~3`。可能記住 `~3` 更加容易，因為你想修改最近三次提交；但是請記住你事實上所指的是四次提交之前，即你想修改的提交的父提交。

	$ git rebase -i HEAD~3

再次提醒這是一個衍合命令—— `HEAD~3..HEAD` 範圍內的每一次提交都會被重寫，無論你是否修改說明。不要涵蓋你已經推送到中心伺服器的提交——這麼做會使其他開發者產生混亂，因為你提供了同樣變更的不同版本。 

執行這個命令會在你的文字編輯器提供一個提交列表，看起來像下面這樣：

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

很重要的一點是你得注意這些提交的順序與你通常通過 `log` 命令看到的是相反的。如果你執行 `log`，你會看到下面這樣的結果： 

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

請注意這裡的順序是相反的。互動式的 rebase 給了你一個即將執行的腳本。它會從你在命令列上指定的提交開始(`HEAD~3`)然後自上至下重播每次提交裡引入的變更。它將最早的列在頂上而不是最近的，因為這是第一個需要重播的。 

你需要修改這個腳本來讓它停留在你想修改的變更上。要做到這一點，你只要將你想修改的每一次提交前面的 pick 改為 edit。例如，只想修改第三次提交說明的話，你就像下面這樣修改文件：

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

當你存檔並退出編輯器，Git 會倒回至列表中的最後一次提交，然後把你送到命令列中，同時顯示以下資訊： 

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

這些指示很明確地告訴了你該幹什麼。輸入 

	$ git commit --amend

修改提交說明，退出編輯器。然後，執行 

	$ git rebase --continue

這個命令會自動應用其他兩次提交，你就完成任務了。如果你將更多行的 pick 改為 edit ，你就能對你想修改的提交重複這些步驟。Git 每次都會停下，讓你修正提交，完成後繼續執行。

### 重排(Reordering) 提交 ###

你也可以使用互動式的衍合來徹底重排或刪除提交。如果你想刪除 ”added cat-file” 這個提交並且修改其他兩次提交引入的順序，你將 rebase 腳本從這個 

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

改為這個:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

當你存檔並退出編輯器，Git 將分支倒回至這些提交的父提交，應用 `310154e`，然後 `f7f3f6d`，接著停止。你有效地修改了這些提交的順序並且徹底刪除了 ”added cat-file” 這次提交。

### 擠壓(Squashing) 提交 ###

互動式的衍合工具還可以將一系列提交擠壓為單一提交。腳本在 rebase 的資訊裡放了一些有用的指示： 

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

如果不用 ”pick” 或者 ”edit”，而是指定 ”squash”，Git 會同時應用那個變更和它之前的變更並將提交說明歸併。因此，如果你想將這三個提交合併為單一提交，你可以將腳本修改成這樣： 

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

當你保存並退出編輯器，Git 會應用全部三次變更然後將你送回編輯器來歸併三次提交說明。 

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

當你保存之後，你就擁有了一個包含前三次提交的全部變更的單一提交。 

### 拆分(Splitting) 提交 ###

拆分提交就是撤銷一次提交，然後多次部分地暫存或提交直到結束。例如，假設你想將三次提交中的中間一次拆分。將「updated README formatting and added blame」拆分成兩次提交：第一次為「updated README formatting」，第二次為「added blame」。你可以在 `rebase -i` 腳本中修改你想拆分的提交前的指令為 ”edit”： 

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

然後，這個腳本就將你帶入命令列，你重置那次提交，提取被重置的變更，從中建立多次提交。當你保存並退出編輯器，Git 倒回到列表中第一次提交的父提交，應用第一次提交（`f7f3f6d`），應用第二次提交（`310154e`），然後將你帶到控制台。那裡你可以用 `git reset HEAD^` 對那次提交進行一次混合的重置，這將撤銷那次提交並且將修改的檔從暫存區撤回。此時你可以暫存並提交檔案，直到你擁有多次提交，結束後，執行 `git rebase --continue`。 

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git 在腳本中應用了最後一次提交（`a5f4a0d`），你的歷史看起來就像這樣了： 

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

再次提醒，這會修改你列表中的提交的 SHA 值，所以請確保這個列表裡不包含你已經推送到共用倉庫的提交。 

### 核彈級選項: filter-branch ###

如果你想用腳本的方式修改大量的提交，還有一個重寫歷史的選項可以用——例如，全域性地修改電子郵寄地址或者將一個檔從所有提交中刪除。這個命令是 `filter-branch`，這會大面積地修改你的歷史，所以你很有可能不該去用它，除非你的專案尚未公開，沒有其他人在你準備修改的提交的基礎上工作。儘管如此，這個可以非常有用。你會學習一些常見用法，借此對它的能力有所認識。 

#### 從所有提交中刪除一個檔 ####

這個經常發生。有些人不經思考使用 `git add .`，意外地提交了一個巨大的二進位檔案，你想將它從所有地方刪除。也許你不小心提交了一個包含密碼的檔，而你想讓你的專案成為 open source。`filter-branch` 大概會是你用來清理整個歷史的工具。要從整個歷史中刪除一個名叫 password.txt 的檔，你可以在 `filter-branch` 上使用 `--tree-filter` 選項： 

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

`--tree-filter` 選項會在每次 checkout 專案時先執行指定的命令然後重新提交結果。在這個例子中，你會在所有快照中刪除一個名叫 password.txt 的檔，無論它是否存在。如果你想刪除所有不小心提交上去的編輯器備份檔案，你可以執行類似 `git filter-branch --tree-filter "find * -type f -name '*~' -delete" HEAD` 的命令。 

你可以觀察到 Git 重寫目錄樹並且提交，然後將分支指標移到末尾。一個比較好的辦法是在一個測試分支上做這件事，然後在你確定結果真的是你所要的之後，再 hard-reset 你的主分支。要在你所有的分支上執行 `filter-branch` 的話，你可以傳遞一個 `--all` 參數給該命令。 

#### 將一個子目錄設定為新的根目錄 ####

假設你完成了從另外一個代碼控制系統的導入工作，得到了一些沒有意義的子目錄（trunk, tags 等等）。如果你想讓 trunk 子目錄成為每一次提交的新的專案根目錄，`filter-branch` 也可以幫你做到： 

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

現在你的專案根目錄就是 trunk 子目錄了。Git 會自動地刪除不對這個子目錄產生影響的提交。

#### 全域性地更換電子郵寄地址 ####

另一個常見的案例是你在開始時忘了執行 `git config` 來設定你的姓名和電子郵寄地址，也許你想開源一個專案，把你所有的工作電子郵寄地址修改為個人位址。無論哪種情況你都可以用 `filter-branch` 來更換多次提交裡的電子郵寄地址。你必須小心一些，只改變屬於你的電子郵寄地址，所以你使用 `--commit-filter`： 

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

這樣會巡迴並重寫所有提交使之擁有你的新地址。因為提交裡包含了它們的父提交的 SHA-1 值，這個命令會修改你的歷史中的所有提交，而不僅僅是包含了匹配的電子郵寄地址的那些。 

## 使用 Git 做 Debug ##

Git 也提供了一些工具來幫助你 debug 專案中遇到的問題。由於 Git 被設計為可應用於幾乎任何類型的專案，這些工具是通用型的，但是在遇到問題時經常可以幫助你找到 bug 在哪裏。 

### 檔案標注 (File Annotation) ###

如果你在追查程式碼中的 bug，想要知道這是什麼時候、為什麼被引進來的，檔案標注會是你的最佳工具。它會顯示檔案中對每一行進行修改的最近一次提交。因此，如果你發現自己程式碼中的一個 method 有 bug，你可以用 `git blame` 來標注該檔案，查看那個 method 的每一行分別是由誰在哪一天修改的。下面這個例子使用了 `-L` 選項來限制輸出範圍在第12至22行：

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

請注意第一欄是最後一次修改該行的那次提交的 SHA-1 部份值。接下去的兩欄是從那次提交中取出的值——作者姓名和日期——所以你可以方便地獲知誰在什麼時候修改了這一行。在這後面是行號和檔案內容。請注意 `^4832fe2` 提交的那些行，這些指的是檔案最初提交(original commit)的那些行。那個提交是檔案第一次被加入這個專案時存在的，自那以後未被修改過。這會帶來小小的困惑，因為你已經至少看到了 Git 使用 `^` 來修飾一個提交的 SHA值 的三種不同的意義，但這裡確實就是這個意思。 

另一件很酷的事情是，Git 並不會明確地記錄對檔案所做的重命名(rename)動作。它會記錄快照，然後根據實際狀況嘗試找出隱藏在背後的重命名動作。這其中有一個很有意思的特性，就是你可以讓它找出所有的程式碼移動。如果你在 `git blame` 後加上 `-C`，Git 會分析你所標注的檔案，然後嘗試找出其中代碼片段的原始出處，如果它是從其他地方拷貝過來的話。最近，我在對 `GITServerHandler.m` 這個檔案做程式碼重構(code refactoring)，將它分解為多個檔案，其中一個是 `GITPackUpload.m`。通過對 `GITPackUpload.m` 執行帶 `-C` 參數的 blame 命令，我可以看到程式碼片段的原始出處： 

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

這真的非常有用。通常，你會把你拷貝代碼的那次提交作為原始提交，因為這是你在這個檔中第一次接觸到那幾行。Git可以告訴你編寫那些行的原始提交，即便是在另一個檔裡。

### 二分法查找 (Binary Search) ###

當你知道問題在哪裡的時候，標注檔案會有幫助。如果你不知道，並且自從上次程式碼可用的狀態之後已經經歷了上百次的提交，你可能就要求助於 `git bisect` 命令了。`bisect` 會在你的提交歷史中進行二分查找，來儘快地確定哪一次提交引入了錯誤。 

例如你剛剛推送了一個代碼發佈版本到產品環境中，得到一些在你開發環境中沒有發生的錯誤報告，而你對代碼為什麼會表現成那樣百思不得其解。你回到你的代碼中，還好你可以重現那個錯誤，但是找不到問題在哪裡。你可以對代碼執行 `bisect` 來尋找。首先你執行 `git bisect start` 啟動，然後你用 `git bisect bad` 來告訴系統目前的提交已經有問題了。然後你必須告訴 bisect 已知的最後一次正常狀態是哪次提交，使用 `git bisect good [good_commit]`： 

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git 發現在你標記為正常的提交(v1.0)和目前的錯誤版本之間有大約12次提交，於是它 check out 中間的一個。在這裡，你可以進行測試，檢查問題是否存在於這次提交。如果是，那麼它是在這個中間提交之前的某一次引入的；如果否，那麼問題是在中間提交之後引入的。假設這裡是沒有錯誤的，那麼你就通過 `git bisect good` 來告訴 Git 然後繼續你的旅程：

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

現在你在另外一個提交上了，在你剛剛測試通過的和一個錯誤提交的中點處。你再次執行測試然後發現這次提交是錯誤的，因此你通過 `git bisect bad` 來告訴 Git： 

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

這次提交是好的，那麼 Git 就獲得了確定問題引入位置所需的所有資訊。它告訴你第一個錯誤提交的 SHA-1 值，並且顯示一些提交說明，以及哪些檔在那次提交裡被修改過，這樣你可以找出 bug 被引入的根源： 

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

當你完成之後，你應該執行 `git bisect reset` 來重設你的 HEAD 到你開始前的地方，否則你會處於一個詭異的狀態： 

	$ git bisect reset

這是個強大的工具，可以幫助你檢查上百的提交，在幾分鐘內找出 bug 引入的位置。事實上，如果你有一個腳本程式會在專案工作正常時返回0，錯誤時返回非0的話，你可以完全自動地執行 `git bisect`。首先你需要提供已知的錯誤和正確提交來告訴它二分查找的範圍。你可以通過 `bisect start` 命令來列出它們，先列出已知的錯誤提交再列出已知的正確提交：

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

這樣會自動地在每一個 checked-out 提交裡執行 test-error.sh 直到 Git 找出第一個破損的提交。你也可以執行像 `make` 或者 `make tests`，或者任何你所能執行的自動化測試。 

## 子模組 (Submodules) ##

經常有這樣的事情，當你在一個專案上工作時，你需要在其中使用另外一個專案。也許它是一個協力廠商開發的程式庫(Library)，或者是你另外開發給多個父專案使用的子專案。在這個情境下產生了一個常見的問題：你想將這兩個專案分開處理，但是又需要在其中一個中使用另外一個。 

這裡有一個例子。假設你在開發一個網站，並提供 Atom 訂閱(Atom feeds)。你不想自己編寫產生 Atom 的程式，而是決定使用一個 Library。你可能必須從 CPAN install 或者 Ruby gem 之類的共用庫(shared library)將那段程式 include 進來，或者將原始程式碼複製到你的專案樹中。如果採用包含程式庫的辦法，那麼不管用什麼辦法都很難對這個程式庫做客製化(customize)，部署它就更加困難了，因為你必須確保每個客戶都擁有那個程式庫。把程式碼包含到你自己的專案中帶來的問題是，當上游被修改時，任何你進行的客製化的修改都很難歸併(merge)。 

Git 通過子模組處理這個問題。子模組允許你將一個 Git 倉庫當作另外一個 Git 倉庫的子目錄。這允許你 clone 另外一個倉庫到你的專案中並且保持你的提交相對獨立。 

### 子模組初步 ###

假設你想把 Rack library（一個 Ruby 的 web 伺服器閘道介面）加入到你的專案中，可能既要保持你自己的變更，又要延續上游的變更。首先你要把外部的倉庫 clone 到你的子目錄中。你通過 `git submodule add` 命令將外部專案加為子模組： 

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

現在你就在專案裡的 `rack` 子目錄下有了一個 Rack 專案。你可以進入那個子目錄，進行變更，加入你自己的遠端可寫倉庫來推送你的變更，從原始倉庫拉取(pull)和歸併等等。如果你在加入子模組後立刻執行 `git status`，你會看到下面兩項： 

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

首先你注意到有一個 `.gitmodules` 文件。這是一個設定檔，保存了專案 URL 和你拉取到的本地子目錄 

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

如果你有多個子模組，這個檔裡會有多個條目。很重要的一點是這個文件跟其他文件一樣也是處於版本控制之下的，就像你的 `.gitignore` 檔一樣。它跟專案裡的其他檔一樣可以被推送和拉取。這是其他 clone 此專案的人獲知子模組專案來源的途徑。 

`git status` 的輸出裡所列的另一項 rack 。如果你在它上面執行 `git diff`，會發現一些有趣的東西： 

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

儘管 rack 是你工作目錄裡的子目錄，但 Git 把它視作一個子模組，當你不在那個目錄裡的時候，Git 並不會追蹤記錄它的內容。取而代之的是，Git 將它記錄成來自那個倉庫的一個特殊的提交。當你在那個子目錄裡修改並提交時，子專案會通知那裡的 HEAD 已經發生變更並記錄你目前正在工作的那個提交；通過那樣的方法，當其他人 clone 此專案，他們可以重新建立一致的環境。 

這是關於子模組的重要一點：你記錄他們目前確切所處的提交。你不能記錄一個子模組的 `master` 或者其他的符號引用(symbolic reference)。 

當你提交時，會看到類似如下： 

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

注意 rack 條目的 160000 模式。這在 Git 中是一個特殊模式，基本意思是你將一個提交記錄為一個目錄項而不是子目錄或者檔案。 

你可以將 `rack` 目錄當作一個獨立的專案，保持一個指向子目錄的最新提交的指標然後反覆地更新上層專案。所有的 Git 命令都在兩個子目錄裡獨立工作： 

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

### Clone 一個帶子模組的專案 ###

這裡你將 clone 一個帶子模組的專案。當你接收到這樣一個專案，你將得到了包含子專案的目錄，但裡面沒有檔案： 

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

`rack` 目錄存在了，但是是空的。你必須執行兩個命令：`git submodule init` 來初始化你的本地設定檔，`git submodule update` 來從那個專案拉取所有資料並 check out 你上層專案裡所列的合適的提交： 

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

現在你的 `rack` 子目錄就處於你先前提交的確切狀態了。如果另外一個開發者變更了 rack 的代碼並提交，你拉取那個引用然後歸併之，你會得到有點怪怪的東西： 

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

你歸併進來的僅僅是一個指向你的子模組的指標；但是它並不更新你子模組目錄裡的代碼，所以看起來你的工作目錄處於一個臨時狀態(dirty state)： 

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

事情就是這樣，因為你所擁有的子模組的指標，並沒有對應到子模組目錄的真實狀態。為了修復這一點，你必須再次執行 `git submodule update`： 

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

每次你從主專案中拉取一個子模組的變更都必須這樣做。看起來很怪但是管用。 

一個常見問題是當開發者對子模組做了一個本地的變更但是並沒有推送到公開伺服器。然後他們提交了一個指向那個非公開狀態的指標然後推送上層專案。當其他開發者試圖執行 `git submodule update`，那個子模組系統會找不到所引用的提交，因為它只存在于第一個開發者的系統中。如果發生那種情況，你會看到類似這樣的錯誤： 

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

你不得不去查看誰最後變更了子模組：

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

然後，你給那個傢伙發電子郵件說他一通。 

### 上層專案 ###

有時候，開發者想按照他們的分組取得一個大專案的子目錄的子集。如果你是從 CVS 或者 Subversion 遷移過來的話這個很常見，在那些系統中你已經定義了一個模組或者子目錄的集合，而你想延續這種類型的工作流程。

在 Git 中實現這個的一個好辦法是你將每一個子目錄都做成獨立的 Git 倉庫，然後建立一個上層專案的 Git 倉庫包含多個子模組。這個辦法的一個優勢是，你可以在上層專案中通過標籤和分支更為明確地定義專案之間的關係。 

### 子模組的問題 ###

使用子模組並非沒有任何缺點。首先，你在子模組目錄中工作時必須相對小心。當你執行 `git submodule update`，它會 check out 專案的指定版本，但是不在分支內。這叫做獲得一個分離的頭(detached head)——這意味著 HEAD 檔直接指向一次提交，而不是一個符號引用(symbolic reference)。問題在於你通常並不想在一個分離的頭的環境下工作，因為太容易丟失變更了。如果你先執行了一次 `submodule update`，然後在那個子模組目錄裡不建立分支就進行提交，然後再次從上層專案裡執行 `git submodule update` 同時不進行提交，Git 會毫無提示地覆蓋你的變更。技術上講你不會丟失工作，但是你將失去指向它的分支，因此會很難取得。 

為了避免這個問題，當你在子模組目錄裡工作時應使用 `git checkout -b work` 或類似的命令來 建立一個分支。當你再次在子模組裡更新的時候，它仍然會覆蓋你的工作，但是至少你擁有一個可以回溯的指標。 

切換帶有子模組的分支同樣也很有技巧。如果你建立一個新的分支，增加了一個子模組，然後切換回不帶該子模組的分支，你仍然會擁有一個未被追蹤的子模組的目錄 ：

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

你將不得不將它移走或者刪除，這樣的話當你切換回去的時候必須重新 clone 它——你可能會丟失你未推送的本地的變更或分支。 

最後一個需要注意的是關於從子目錄切換到子模組。如果你已經追蹤了你專案中的一些檔案，但是想把它們移到子模組去，你必須非常小心，否則 Git 會生你的氣。假設你的專案中有一個子目錄裡放了 rack 的檔，然後你想將它轉換為子模組。如果你刪除子目錄然後執行 `submodule add`，Git 會向你大吼： 

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

你必須先將 `rack` 目錄撤回(unstage)。然後你才能加入子模組： 

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

現在假設你在一個分支裡那樣做了。如果你嘗試切換回一個仍然在目錄裡保留那些檔而不是子模組的分支時——你會得到下面的錯誤： 

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

你必須先移除 `rack` 子模組的目錄才能切換到不包含它的分支：

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

然後，當你切換回來，你會得到一個空的 `rack` 目錄。你可以執行 `git submodule update` 重新 clone，也可以將 `/tmp/rack` 目錄重新移回空目錄。

## 子樹合併 ##

現在你已經看到了子模組系統的麻煩之處，讓我們來看一下解決相同問題的另一途徑。當 Git 歸併(merge)時，它會檢查需要歸併的內容然後選擇一個合適的歸併策略。如果你歸併的分支是兩個，Git使用一個「遞迴 (recursive)」策略。如果你歸併的分支超過兩個，Git採用「章魚」策略。這些策略是自動選擇的，因為遞迴策略可以處理複雜的三路歸併情況——比如多於一個共同祖先——但是它只能處理兩個分支的歸併。章魚歸併可以處理多個分支，但是必須更加小心以避免衝突帶來的麻煩，因此它被選中作為歸併兩個以上分支的預設策略。

實際上，你也可以選擇其他策略。其中的一個就是「子樹歸併 (subtree merge)」，你可以用它來處理子專案問題。這裡你會看到如何換用子樹歸併的方法來實現前一節裡所做的 rack 的嵌入。 

子樹歸併的想法是你擁有兩個專案，其中一個專案映射到另外一個專案的子目錄中，反過來也一樣。當你指定一個子樹歸併，Git 可以聰明地探知其中一個是另外一個的子樹從而實現正確的歸併——這相當神奇。 

首先你將 Rack 應用加入到專案中。你將 Rack 專案當作你專案中的一個遠端參照，然後將它 check out 到它自身的分支： 

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

現在在你的 `rack_branch` 分支中就有了 Rack 專案的根目錄，而你自己的專案在 `master` 分支中。如果你先 check out 其中一個然後另外一個，你會看到它們有不同的專案根目錄： 

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

要將 Rack 專案當作子目錄拉取到你的 `master` 專案中。你可以在 Git 中用 `git read-tree` 來實現。你會在第9章學到更多與 `read-tree` 和它的朋友相關的東西，目前你會知道它讀取一個分支的根目錄樹到目前的暫存區和工作目錄。你只要切換回你的 `master` 分支，然後拉取 `rack_branch` 分支到你主專案的 `master` 分支的 `rack` 子目錄： 

	$ git read-tree --prefix=rack/ -u rack_branch

當你提交的時候，看起來就像你在那個子目錄下擁有全部 Rack 的檔案——就像你從一個 tarball 裡拷貝的一樣。有意思的是你可以比較容易地歸併其中一個分支的變更到另外一個。因此，如果 Rack 專案更新了，你可以通過切換到那個分支並執行拉取來獲得上游的變更： 

	$ git checkout rack_branch
	$ git pull

然後，你可以將那些變更歸併回你的 master 分支。你可以使用 `git merge -s subtree`，它會工作的很好；但是 Git 同時會把歷史歸併到一起，這可能不是你想要的。為了拉取變更並預置提交說明，需要在 `-s subtree` 策略選項的同時使用 `--squash` 和 `--no-commit` 選項。 

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

所有 Rack 專案的變更都被歸併進來，而且可以進行本地提交。你也可以做相反的事情——在你主分支的 `rack` 目錄裡進行變更然後歸併回 `rack_branch` 分支，然後將它們提交給維護者或者推送到上游。 

為了得到 `rack` 子目錄和你 `rack_branch` 分支的區別——以決定你是否需要歸併它們——你不能使用一般的 `diff` 命令。而是對你想比較的分支執行 `git diff-tree`： 

	$ git diff-tree -p rack_branch

或者，為了比較你的 `rack` 子目錄和伺服器上你拉取時的 `master` 分支，你可以執行 

	$ git diff-tree -p rack_remote/master

## 總結 ##

你已經看到了很多高級的工具，允許你更加精確地操控你的提交和暫存區(staging area)。當你碰到問題時，你應該可以很容易找出是哪個分支、什麼時候、由誰引入了它們。如果你想在專案中使用子專案，你也已經學會了一些方法來滿足這些需求。到此，你應該能夠在 Git 命令列下完成大部分的日常事務，並且感到比較順手。 
