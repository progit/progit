# Git 基礎 #

讀完這一章，你就可以開始使用Git了。本章節涵蓋大部份最常被使用的Git基本指令。 在讀完本章節後，讀者應該有能力組態及初始化一個版本控制倉庫(repository)、開始及停止追蹤檔案(track)、暫存(stage)及提交(commit)更新。 本章還會提到如何讓Git忽略某些檔案、如何輕鬆且很快地救回失誤、如何瀏覽讀者的專案歷史及觀看各個已提交的更新之間的變更、以及如何從遠端版本控制倉庫`拉`(pull)更新下來或將更新`推`(push)上去。

## 取得Git版本控制倉庫 ##

讀者可使用兩種主要的方法取得一個Git版本控制倉庫。 第一種是將現有的專案或者目錄匯入Git。 第二種從其它伺服器複製一份已存在的Git版本控制倉庫。

### 在現有目錄初始化版本控制倉庫 ###

若讀者要開始使用 Git 追蹤現有的專案，只需要進入該專案的目錄並執行：

	$ git init

這個命令會建立名為 `.git` 的子目錄，該目錄包含一個Git版本控制倉庫架構必要的所有檔案。 目前來說，專案內任何檔案都還沒有被追蹤。（關於.git目錄內有些什麼檔案，可參考第九章）

若讀者想要開始對現有的檔案開始做版本控制（除了空的目錄以外），讀者也許應該開始追蹤這些檔案並做第一次的提交。 讀者能以少數的git add命令指定要追蹤的檔案，並將它們提交：

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

這些命令執行完畢大約只需要一分鐘。 現在，讀者已經有個追蹤部份檔案及第一次提交內容的Git版本控制倉庫。

### 複製現有的版本控制倉庫 ###

若讀者想要取得現有的Git版本控制倉庫的複本（例如：讀者想要散佈的），那需要使用的命令是 `git clone`。 若讀者熟悉其它版本控制系統，例如：Subversion，讀者應該注意這個命令是複製(clone)，而不是取出特定版本(checkout)。 這一點非常重要，Git取得的是大部份伺服器端所有的資料複本。 該專案歷史中所有檔案的所有版本都在讀者執行過 `git clone` 後拉回來。 事實上，若伺服器的磁碟機損毀，讀者可使用任何一個客戶端的複本還原伺服器為當初取得該複本的狀態（讀者可能會遺失一些僅存於伺服器的攔截程式，不過所有版本的資料都健在），參考第四章取得更多資訊。

讀者可以 `git clone [url]`，複製一個版本控制倉庫。 例如：若讀者想複製名為Grit的Ruby Git程式庫，可以執行下列命令：

	$ git clone git://github.com/schacon/grit.git

接下來會有個名為`grit`的目錄被建立，並在其下初始化名為`.git`的目錄。 拉下所有存在該版本控制倉庫的所有資料，並取出最新版本為工作複本。 若讀者進入新建立的 `grit` 目錄，會看到專案的檔案都在這兒，且可使用。 若讀者想要複製版本控制倉庫到grit以外其它名字的目錄，只需要在下一個參數指定即可：

	$ git clone git://github.com/schacon/grit.git mygrit

這個命令做的事大致如同上一個命令，只不過目的目錄名為mygrit。

Git提供很多種協定給讀者使用。 上一個範例採用 `git://` 協定，讀者可能會看過 `http(s)://` 或者 `user@server:/path.git` 等使用 SSH 傳輸的協定。 在第四章會介紹設定存取伺服器上的 Git 版本控制倉庫的所有可用的選項，以及它們的優點及缺點。

## 提交更新到版本控制倉庫 ##

讀者現在有一個貨真價實的Git版本控制倉庫，而且有一份已放到工作複本的該專案的檔案。 讀者需要做一些修改並提交這些更動的快照到版本控制倉庫，當這些修改到達讀者想要記錄狀態的情況。

記住工作目錄內的每個檔案可能為兩種狀態的任一種：追蹤或者尚未被追蹤。 被追蹤的檔案是最近的快照；它們可被復原、修改，或者暫存。 未被追蹤的檔案則是其它未在最近快照也未被暫存的任何檔案。 當讀者第一次複製保存器時，讀者所有檔案都是被追蹤且未被修改的。 因為讀者剛取出它們而且尚未更改做任何修改。

只要讀者編輯任何已被追蹤的檔案。 Git將它們視為被更動的，因為讀者將它們改成與最後一次提交不同。 讀者暫存這些已更動檔案並提供所有被暫存的更新， 並重複此週期。 此生命週期如圖2-1所示。

Insert 18333fig0201.png
圖2-1. 檔案狀態的生命週期。

### 檢視檔案的狀態 ###

主要給讀者用來檢視檔案的狀態是 git status 命令。 若讀者在複製完複本後馬上執行此命令，會看到如下的文字：

	$ git status
	On branch master
	nothing to commit, working directory clean

Wokring directory clean意謂著目前的工作目錄沒有未被追蹤或已被修改的檔案。Git未看到任何未被追蹤的檔案，否則會將它們列出。 最後，這個命令告訴讀者目前在哪一個分支(branch)。到目前為止，一直都是master，這是預設的。下一個章節會詳細介紹分支(branch)，目前我們先不考慮它。

假設讀者新增一些檔案到專案，如`README`。 若該檔案先前並不存在，執行 `git status` 命令後，讀者會看到未被追蹤的檔案，如下：

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)
	
	        README

	nothing added to commit but untracked files present (use "git add" to track)

我們可以看到新增的`README`尚未被追蹤，因為它被列在輸出訊息的 Untracked files 下方。 除非我們明確指定要將該檔案加入提交的快照，Git不會主動將它加入。這樣可以避免加入一些二進位格式的檔案或其它使用者不想列入追蹤的檔案。 不過在這個例子中，我們的確是要將 `README` 檔案加入追蹤:

### 追蹤新檔案 ###

要追蹤新增的檔案，我們可以使用`git add`命令。例如:要追蹤`README`檔案，可執行：

	$ git add README

如此一來，我們重新檢查狀態(status)時，可看到`README`檔案已被列入追蹤並且已被暫存：

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	

因為它被放在Changes to be commited文字下方，讀者可得知它已被暫存起來。 若讀者此時提交更新，剛才執行`git add`加進來的檔案就會被記錄在歷史的快照。 讀者可能可回想一下先前執行`git init`後也有執行過`git add`，開始追蹤目錄內的檔案。`git add`命令可接受檔名或者目錄名。 若是目錄名，Git會以遞迴(recursive)的方式會將整個目錄下所有檔案及子目錄都加進來。

### 暫存已修改檔案 ###

讓我們修改已被追蹤的檔案。 若讀者修改先前已被追蹤的檔案，名為`benchmarks.rb`，並檢查目前版本控制倉庫的狀態。我們會看到類似以下文字：

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

`benchmarks.rb`檔案出現在 “Changes not staged for commit” 下方，代表著這個檔案已被追蹤，而且位於工作目錄的該檔案已被修改，但尚未暫存。 要暫存該檔案，可執行`git add`命令（這是一個多重用途的指令）。現在，讀者使用 `git add` 將`benchmarks.rb`檔案暫存起來，並再度執行`git status`：

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

這兩個檔案目前都被暫存起來，而且會進入下一次的提交。 假設讀者記得仍需要對`benchmarks.rb`做一點修改後才要提交，可再度開啟並編輯該檔案。 然而，當我們再度執行`git status`：

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
	

到底發生了什麼事？ 現在`benchmarks.rb`同時被列在已被暫存及未被暫存。 這怎麼可能？ 這表示Git的確在讀者執行`git add`命令後，將檔案暫存起來。 若讀者現在提交更新，最近一次執行`git add`命令時暫存的`benchmarks.rb`會被提交。 若讀者在`git add`後修改檔案，需要再度執行`git add`將最新版的檔案暫存起來：

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

### 忽略某些檔案 ###

通常讀者會有一類不想讓Git自動新增，也不希望它們被列入未被追蹤的檔案。 這些通常是自動產生的檔案，例如：記錄檔或者編譯系統產生的檔案。 在這情況下，讀者可建立一個名為`.gitignore`檔案，列出符合這些檔案檔名的特徵。 以下是一個範例：

	$ cat .gitignore
	*.[oa]
	*~

第一列告訴Git忽略任何檔名為`.o`或`.a`結尾的檔案，它們是可能是編譯系統建置讀者的程式碼時產生的目的檔及程式庫。 第二列告訴Git忽略所有檔名為~結尾的檔案，通常被很多文書編輯器，如：Emacs，使用的暫存檔案。 讀者可能會想一併將log、tmp、pid目錄及自動產生的文件等也一併加進來。 依據類推。在讀者要開始開發之前將`.gitignore`設定好，通常是一個不錯的點子。這樣子讀者不會意外地將真的不想追蹤的檔案提交到Git版本控制倉庫。

編寫`.gitignore`檔案的規則如下：

*	空白列或者以#開頭的列會被忽略。
*	可使用標準的Glob pattern。
*	可以/結尾，代表是目錄。
*	可使用!符號將特徵反過來使用。

Glob pattern就像是shell使用的簡化版正規運算式。 星號（`*`）匹配零個或多個字元；`[abc]`匹配中括弧內的任一字元（此例為`a`、`b`、`c`）；問號（`?`）匹配單一個字元；中括孤內的字以連字符連接（如：`[0-9]`），用來匹配任何符合該範圍的字（此例為0到9）。

以下是另一個`.gitignore`的範例檔案：

	# 註解，會被忽略。
	# 不要追蹤檔名為 .a 結尾的檔案
	*.a
	# 但是要追蹤 lib.a，即使上方已指定忽略所有的 .a 檔案
	!lib.a
	# 只忽略根目錄下的 TODO 檔案。 不包含子目錄下的 TODO
	/TODO
	# 忽略build/目錄下所有檔案
	build/
	# 忽略doc/notes.txt但不包含doc/server/arch.txt
	doc/*.txt
	# ignore all .txt files in the doc/ directory
	doc/**/*.txt

A `**/` pattern is available in Git since version 1.8.2.

### 檢視已暫存及尚未暫存的更動 ###

在某些情況下，`git status`指令提供的資訊就太過簡要。
有的時候我們不只想知道那些檔案被更動，而是想更進一步知道被檔案的內容被做了那些修改，這時我們可以使用`git diff`命令。稍後我們會有更詳盡講解該命令。讀者使用它時通常會是為了瞭解兩個問題：目前已做的修改但尚未暫存的內容是哪些？以及將被提交的暫存資料有哪些？儘管`git status`指令可以大略回答這些問題，但`git diff`可顯示檔案裡的哪些列被加入或刪除，以修補檔(patch)方式表達。

假設讀者編輯並暫存(stage)`README`，接著修改`benchmarks.rb`檔案，卻未暫存。若讀者檢視目前的狀況，會看到類似下方文字：

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

想瞭解尚未暫存的修改，執行`git diff`，不用帶任何參數：

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

這命令會比對目前工作目錄(working directory)及暫存區域(stage area)的版本，然後顯示尚未被存入暫存區(stage area)的變更。

若讀者想比對暫存區域(stage)及最後一次提交(commit)的差異，可用`git diff --cached`指令（Git 1.6.1之後的版本，可用較易記的`git diff --staged` 指令）:

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

很重要的一點是`git diff`不會顯示最後一次commit後的所有變更；只會顯示尚未存入暫存區(即unstaged)的變更。這麼說可能會混淆，舉個例子來說，若讀者已暫存(stage)所有的變更，輸入`git diff`不會顯示任何資訊。

舉其它例子，若讀者暫存`benchmarks.rb`檔案後又編輯，可使用`git diff`看已暫存的版本與工作目錄內版本尚未暫存的變更：

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
	

現在讀者可使用`git diff`檢視哪些部份尚未被暫存：

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

以及使用`git diff --cached`檢視目前已暫存的變更：

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

### 提交修改 ###

現在讀者的暫存區域已被更新為讀者想要的，可開始提交變更的部份。 要記得任何尚未被暫存的新增檔案或已被修改但尚未使用git add暫存的檔案將不會被記錄在本次的提交中。 它們仍會以被修改的檔案的身份存在磁碟中。
在這情況下，最後一次執行`git status`，讀者會看到所有已被暫存的檔案，讀者也準備好要提交修改。 最簡單的提交是執行`git commit`：

	$ git commit

執行此命令會叫出讀者指定的編輯器。（由讀者shell的$EDITOR環境變數指定，通常是vim或emacs。讀者也可以如同第1章介紹的，使用`git config --global core.editor` 命令指定）

編輯器會顯示如下文字（此範例為Vim的畫面）：

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

讀者可看到預設的提交訊息包含最近一次`git status`的輸出以註解方式呈現，以及螢幕最上方有一列空白列。 讀者可移除這些註解後再輸入提交的訊息，或者保留它們，提醒你現在正在進行提交。（若想知道更動的內容，可傳遞-v參數給`git commit`。如此一來連比對的結果也會一併顯示在編輯器內，方便讀者明確看到有什麼變更。） 當讀者離開編輯器，Git會利用這些提交訊息產生新的提交（註解及比對的結果會先被濾除）。

另一種方式則是在commit命令後方以`-m`參數指定提交訊息，如下：

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Story 182: Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

現在讀者已建立第一個提交！ 讀者可從輸出的訊息看到此提交、放到哪個分支（`master`）、SHA-1查核碼（`463dc4f`）、有多少檔案被更動，以及統計此提交有多少列被新增及移除。

記得提交記錄讀者放在暫存區的快照。 任何讀者未暫存的仍然保持在已被修改狀態；讀者可進行其它的提交，將它增加到歷史。 每一次讀者執行提交，都是記錄專案的快照，而且以後可用來比對或者復原。

### 跳過暫存區域 ###

雖然優秀好用的暫存區域能很有技巧且精確的提交讀者想記錄的資訊，有時候暫存區域也比讀者實際需要的工作流程繁瑣。 若讀者想跳過暫存區域，Git提供了簡易的使用方式。 在`git commit`命令後方加上`-a`參數，Git自動將所有已被追蹤且被修改的檔案送到暫存區域並開始提交程序，讓讀者略過`git add`的步驟：

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

留意本次的提交之前，讀者並不需要執行`git add`將`benchmarks.rb`檔案加入。

### 刪除檔案 ###

要從Git刪除檔案，讀者需要將它從已被追蹤檔案中移除（更精確的來說，是從暫存區域移除），並且提交。 `git rm`命令除了完成此工作外，也會將該檔案從工作目錄移除。 因此讀者以後不會在未被追蹤檔案列表看到它。

若讀者僅僅是將檔案從工作目錄移除，那麼在`git status`的輸出，可看見該檔案將會被視為“已被變更且尚未被更新”（也就是尚未存到暫存區域）：

	$ rm grit.gemspec
	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add/rm <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        deleted:    grit.gemspec
	
	no changes added to commit (use "git add" and/or "git commit -a")

接著，若執行`git rm`，則會將暫存區域內的該檔案移除：

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        deleted:    grit.gemspec
	

下一次提交時，該檔案將會消失而且不再被追蹤。 若已更動過該檔案且將它記錄到暫存區域。 必須使用`-f`參數才能將它強制移除。 這是為了避免已被記錄的快照意外被移除且再也無法使用Git復原。

其它有用的技巧是保留工作目錄內的檔案，但從暫存區域移除。 換句話說，或許讀者想在磁碟機上的檔案且不希望Git繼續追蹤它。 這在讀者忘記將某些檔案記錄到`.gitignore`且不小心將它增加到暫存區域時特別有用。 比如說：巨大的記錄檔、或大量在編譯時期產生的`.a`檔案。 欲使用此功能，加上`--cached`參數：

	$ git rm --cached readme.txt

除了檔名、目錄名以外，還可以指定簡化的正規運算式給`git rm`命令。 這意謂著可執行類似下列指令：

	$ git rm log/\*.log

注意星號（`*`）前方的倒斜線（`\`）。 這是必須的，因為Git會在shell以上執行檔案的擴展。 此命令移除log目錄下所有檔名以`.log`結尾的檔案。 讀者也可以執行類似下列命令：

	$ git rm \*~

此命令移除所有檔名以`~`結尾的檔案。

### 搬動檔案 ###

Git並不像其它檔案控制系統一樣，明確地追蹤檔案的移動。 若將被Git追蹤的檔名重新命名，並沒有任何metadata保存在Git中去標示此重新命名動作。 然而Git能很聰明地指出這一點。 稍後會介紹關於偵測檔案的搬動。

因此Git存在`mv`這個指令會造成一點混淆。 若想要在Git中重新命名某個檔案，可執行以下命令：

	$ git mv file_from file_to

而且這命令可正常工作。 事實上，在執行完重新命名的動作後檢視一下狀態。 可看到Git認為該檔案被重新命名：

	$ git mv README.txt README
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        renamed:    README.txt -> README
	

不過，這就相當於執行下列命令：

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git會在背後判斷檔案是否被重新命名，因此不管是用上述方法還是'mv'命令都沒有差別。 實際上唯一不同的是'mv'是一個命令，而不是三個。 使用上較方便。 更重要的是讀者可使用任何慣用的工具重新命名，再使用add/rm，接著才提交。

## 檢視提交的歷史記錄 ##

在提交數個更新，或者複製已有一些歷史記錄的版本控制倉庫後。 或許會想希望檢視之前發生過什麼事。 最基本也最具威力的工具就是 `git log` 命令。

以下採用非常簡單，名為 `simplegit` 的專案做示範。 欲取得此專案，執行以下命令：

	git clone git://github.com/schacon/simplegit-progit.git

在此專案目錄內執行 `git log`，應該會看到類似以下訊息：

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

在未加任何參數情況下，`git log`以新到舊的順序列出版本控制倉庫的提交的歷史記錄。 也就是說最新的更新會先被列出來。 同時也會列出每個更新的 SHA-1 查核值、作者大名及電子郵件地址、及提交時輸入的訊息。

`git log`命令有很多樣化的選項，供讀者精確指出想搜尋的結果。 接下來會介紹一些常用的選項。

最常用的選項之一為 `-p`，用來顯示每個更新之間差別的內容。 另外還可以加上 `-2` 參數，限制為只輸出最後兩個更新。

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

這個選項除了顯示相同的資訊外，還另外附上每個更新的差異。 這對於重新檢視或者快速的瀏覽協同工作伙伴新增的更新非常有幫助。

有時候用 word level 的方式比 line level 更容易看懂變化。在 `git log -p` 後面附加 `--word-diff` 選項，就可以取代預設的  line level 模式。當你在看原始碼的時候 word level 還挺有用的，還有一些大型文字檔，如書籍或論文就派上用場了，範例如下：

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

如你所見，輸出範例中沒有列出新增與刪除的行，變動的地方用內嵌的方式顯示，你可以看到新增的字被包括在 `{+ +}` 內，而刪除的則包括在 `[- -]` 內，如果你想再減少顯示的資訊，將上述的三行再減少到只顯示變動的那行。你可以用 `-U1` 選項，就像上述的範例中那樣。

另外也可以使用`git log`提供的一系統摘要選項。 例如：若想檢視每個更新的簡略統計資訊，可使用 `--stat` 選項：

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

如以上所示，`--stat`選項在每個更新專案的下方列出被更動的檔案、有多少檔案被更動，以及有多行列被加入或移出該檔案。 也會在最後印出摘要的訊息。
其它實用的選項是 `--pretty`。 這個選項改變原本預設輸出的格式。 有數個內建的選項供讀者選用。 其中 `oneline` 選項將每一個更新印到單獨一行，對於檢視很多更新時很有用。 更進一步，`short`、`full`、`fuller` 選項輸出的格式大致相同，但會少一些或者多一些資訊。

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

最有趣的選項是 `format`，允許讀者指定自訂的輸出格式。 當需要輸出給機器分析時特別有用。 因為明確地指定了格式，即可確定它不會因為更新 Git 而被更動：

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

表格2-1列出一些 `format` 支援的選項。

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	選項	選項的說明
	%H	該更新的SHA1雜湊值
	%h	該更新的簡短SHA1雜湊值
	%T	存放該更新的根目錄的Tree物件的SHA1雜湊值
	%t	存放該更新的根目錄的Tree物件的簡短SHA1雜湊值
	%P	該更新的父更新的SHA1雜湊值
	%p	該更新的父更新的簡短SHA1雜湊值
	%an	作者名字
	%ae	作者電子郵件
	%ad	作者的日期 (格式依據 date 選項而不同)
	%ar	相對於目前時間的作者的日期
	%cn	提交者的名字
	%ce	提交者的電子郵件
	%cd	提交的日期
	%cr	相對於目前時間的提交的日期
	%s	標題

讀者可能會好奇 __作者__ 與 __提交者__ 之間的差別。 __作者__ 是完成該工作的人，而 __提交者__ 則是最後將該工作提交出來的人。 因此，若讀者將某個專案的修補檔送出，而且該專案的核心成員中一員套用該更新，則讀者與該成員皆會被列入該更新。 讀者即 __作者__，而該成員則是 __提交者__。 在第五章會提到較多之間的差別。

`oneline` 及 `format` 選項對於另一個名為 `--graph` 的選項特別有用。 該選項以 ASCII 畫出分支的分歧及合併的歷史。 可參考我們的 Grit 的版本控制倉庫：

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

這些只是一些簡單的 `git log` 的選項，還有許多其它的。 表格2-2列出目前我們涵蓋的及一些可能有用的格式選項，以及它們如何更動 `log` 命令的輸出格式。

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	選項	選項的說明
	-p	顯示每個更新與上一個的差異。
	--word-diff	使用 word diff 格式顯示 patch 內容。
	--stat	顯示每個更新更動的檔案的統計及摘要資訊。
	--shortstat	僅顯示--stat提供的的訊息中關於更動、插入、刪除的文字。
	--name-only	在更新的訊息後方顯示更動的檔案列表。
	--name-status	顯示新增、更動、刪除的檔案列表。
	--abbrev-commit	僅顯示SHA1查核值的前幾位數，而不是顯示全部的40位數。
	--relative-date	以相對於目前時間方式顯示日期（例如：“2 weeks ago”），而不是完整的日期格式。
	--graph	以 ASCII 在 log 輸出旁邊畫出分支的分歧及合併。
	--pretty	以其它格式顯示更新。 可用的選項包含oneline、short、full、fuller及可自訂格式的format。
	--oneline	`--pretty=oneline --abbrev-commit` 的簡短用法。

### 限制 log 的輸出範圍 ###

除了輸出格式的選項，`git log`也接受一些好用的選項。 也就是指定只顯示某一個子集合的更新。 先前已介紹過僅顯示最後兩筆更新的 `-2` 選項。 實際上可指定 `-<n>`，而 `n` 是任何整數，用來顯示最後的 `n` 個更新。 不過讀者可能不太會常用此選項，因為 Git 預設將所有的輸出導到分頁程式，故一次只會看到一頁。

然而，像 `--since` 及 `--until` 限制時間的選項就很有用。 例如，以下命令列出最近兩週的更新：

	$ git log --since=2.weeks

此命令支援多種格式。 可指定特定日期（如：“2008-01-15”）或相對的日期，如：“2 years 1 day 3 minutes ago”。

使用者也可以過濾出符合某些搜尋條件的更新。 `--author` 選項允許使用者過濾出特定作者，而 `--grep` 選項允許以關鍵字搜尋提交的訊息。（注意：若同時使用作者名字及字串比對，該命令會列出同時符合二個條件的更新。）

若希望比對多個字串，需要再加上 `--all-match`；否則只會列出符合任一條件的更新。

最後一個有用的選項是過濾路徑。 若指定目錄或檔案名稱，可僅印出更動到這些檔案的更新。 這選項永遠放在最後，而且一般來說會在前方加上 -- 以資區別。

在表格2-3，我們列出這些選項以及少數其它常見選項以供參考。

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	選項	選項的說明文字
	-(n)	僅顯示最後 n 個更新
	--since, --after	列出特定日期後的更新。
	--until, --before	列出特定日期前的更新。
	--author	列出作者名稱符合指定字串的更新。
	--committer	列出提交者名稱符合指定字串的更新。

例如：若想檢視 Git 的原始碼中，Junio Hamano 在 2008 年十月提交且不是合併用的更新。 可執行以下命令：

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Git 原始碼的更新歷史接近二萬筆更新，本命令顯示符合條件的六筆更新。

### 使用圖形界面檢視歷史 ###

若讀者較偏向使用圖形界面檢視歷史，或許會想看一下隨著 Git 發佈的，名為 `gitk` 的 Tcl/Tk 程式。 Gitk 基本上就是 `git log` 的圖形界面版本，而且幾乎接受所有 `git log` 支援的過濾用選項。 若在專案所在目錄下執行 gitk 命令，將會看到如圖2-2的畫面。

Insert 18333fig0202.png
圖2-2。 gitk檢視歷史程式。

在上圖中可看到視窗的上半部顯示相當棒的更新歷史圖。 視窗下半部則顯示當時被點選的更新引入的變更。

## 復原 ##

在任何時間點，或許讀者會想要復原一些事情。 接下來我們會介紹一些基本的復原方式。 但要注意，由於有些復原動作所做的變更無法再被還原。 這是少數在使用 Git 時，執行錯誤的動作會遺失資料的情況。

### 更動最後一筆更新 ###

最常見的復原發生在太早提交更新，也許忘了加入某些檔案、或者搞砸了提交的訊息。 若想要試著重新提交，可試著加上 `--amend` 選項：

	$ git commit --amend

此命令取出暫存區資料並用來做本次的提交。 只要在最後一次提交後沒有做過任何修改（例如：在上一次提交後，馬上執行此命令），那麼整個快照看起來會與上次提交的一模一樣，唯一有更動的是提交時的訊息。

同一個文書編輯器被帶出來，並且已包含先前提交的更新內的訊息。 讀者可像往常一樣編輯這些訊息，差別在於它們會覆蓋上一次提交。

如下例，若提交了更新後發現忘了一併提交某些檔案，可執行最後一個命令：

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

這些命令的僅僅會提交一個更新，第二個被提交的更新會取代第一個。

### 取消已被暫存的檔案 ###

接下來兩節示範如何應付暫存區及工作目錄的復原。 用來判斷這兩個區域狀態的命令也以相當好的方式提示如何復原。 比如說已經修改兩個檔案，並想要以兩個不同的更新提交它們，不過不小心執行 `git add *` 將它們同時都加入暫存區。 應該如何將其中一個移出暫存區？ `git status` 命令已附上相關的提示：

	$ git add .
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	        modified:   benchmarks.rb
	

在 “Changes to be commited” 文字下方，註明著使用 “`git reset HEAD <file>...`，將 file 移出暫存區”。 因此，讓我們依循該建議將 `benchmarks.rb` 檔案移出暫存區：

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
	

這個命令看起來有點奇怪，不過它的確可行。 `benchmarks.rb` 檔案被移出暫存區了。

### 復原已被更動的檔案 ###

若讀者發現其者並不需要保留 `benchmarks.rb` 檔案被更動部份，應該如何做才能很容易的復原為最後一次提交的狀態（或者最初複製版本控制倉庫時、或放到工作目錄時的版本）？ 很幸運的，`git status` 同樣也告訴讀者如何做。 在最近一次檢視狀態時，暫存區看起來應如下所示：

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

在這訊息中已很明確的說明如何放棄所做的修改（至少需升級為 Git 1.6.1或更新版本。 若讀者使用的是舊版，強烈建議升級，以取得更好用的功能。） 讓我們依據命令執行：

	$ git checkout -- benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	

在上述文字可看到該變更已被復原。 讀者應該瞭解這是危險的命令，任何對該檔案做的修改將不復存在，就好像複製別的檔案將它覆蓋。 除非很清楚真的不需要該檔案，絕不要使用此檔案。 若需要將這些修改排除，我們在下一章節會介紹備份及分支。 一般來說會比此方法來的好。

切記，任何在 Git 提交的更新幾乎都是可復原的。 即使是分支中的更新被刪除或被 `--amend` 覆寫，皆能被復原。（參考第九章關於資料的復原） 然而，未被提交的則幾乎無法救回。

## 與遠端協同工作 ##

想要在任何Git控管的專案協同作業，需要瞭解如何管理遠端的版本控制倉庫。 遠端版本控制倉庫是置放在網際網路或網路其它地方中的專案版本。 讀者可設定多個遠端版本控制倉庫，具備唯讀或可讀寫的權限。 與他人協同作業時，需要管理這些遠端版本控制倉庫，並在需要分享工作時上傳或下載資料。
管理遠端版本控制倉庫包含瞭解如何新增遠端版本控制倉庫、移除已失效的版本控制倉庫、管理許多分支及定義是否要追蹤它們等等。 本節包含如何遠端管理的技巧。

### 顯示所有的遠端版本控制倉庫 ###

欲瞭解目前已加進來的遠端版本控制倉庫，可執行 `git remote` 命令。 它會列出當初加入遠端版本控制倉庫時指定的名稱。 若目前所在版本控制倉庫是從其它版本控制倉庫複製過來的，至少應該看到 *origin*，也就是 Git 複製版本控制倉庫時預設名字：

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

也可以再加上 `-v` 參數，將會在名稱後方顯示其URL：

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

若有一個以上遠端版本控制倉庫，此命令會全部列出。 例如：我的 Grit 版本控制倉庫包含以下遠端版本控制倉庫。

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

這意謂著我可以很容易從這些伙伴的版本控制倉庫取得最新的更新。 要留意的是只有 origin 遠端的 URL 是 SSH。 因此它是唯一我能上傳的遠端的版本控制倉庫。（關於這部份將在第四章介紹） 

### 新增遠端版本控制倉庫 ###

在先前章節已提到並示範如何新增遠端版本控制倉庫，這邊會很明確的說明如何做這項工作。 欲新增遠端版本控制倉庫並取一個簡短的名字，執行 `git remote add [shortname] [url]`： 

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

現在可看到命令列中的 `pb` 字串取代了整個 URL。 例如，若想取得 Paul 上傳的且本地端版本控制倉庫沒有的更新，可執行 `git fetch pb`：

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

現在可在本地端使用 `pb/master` 存取 Paul 的 master 分支。 讀者可將它合併到本地端任一分支、或者建立一個本地端的分支指向它，如果讀者想監看它。

### 從遠端版本控制倉庫擷取或合併 ###

如剛才所示，欲從遠端擷取資料，可執行：

	$ git fetch [remote-name]

此命令到該遠端專案將所有本地端沒有的資料拉下來。 在執行此動作後，讀者應該有參考到該遠端專案所有分支的參考點，可在任何時間點用來合併或監看。（在第三章將會提及更多關於如何使用分支的細節）

若複製了一個版本控制倉庫，會自動將該遠端版本控制倉庫命令為 *origin*。 因此 `git fetch origin` 取出所有在複製或最後一下擷取後被上傳到該版本控制倉庫的更新。 需留意的是 `fetch` 命令僅僅將資料拉到本地端的版本控制倉庫，並未自動將它合併進來，也沒有修改任何目前工作的專案。 讀者得在必要時將它們手動合併進來。

若讀者設定一個會追蹤遠端分支的分支（參考下一節及第三章，取得更多資料），可使用 `git pull` 命令自動擷取及合併遠端分支到目錄的分支。 這對讀者來說或許是較合適的工作流程。 而且 `git clone` 命令預設情況下會自動設定本地端的 master 分支追蹤被複製的遠端版本控制倉庫的 master 分支。（假設該版本控制倉庫有 master 分支） 執行 `git pull` 一般來說會從當初複製時的來源版本控制倉庫擷取資料並自動試著合併到目前工作的版本。

### 上傳到遠端版本控制倉庫 ###

當讀者有想分享出去的專案，可將更新上傳到上游。 執行此動作的命令很簡單：`git push [remote-name] [branch-name]`。 若想要上傳 master 分支到 `origin` 伺服器（再說一次，複製時通常自動設定此名字），接著執行以下命令即可上傳到伺服器：

	$ git push origin master

此命令只有在被複製的伺服器開放寫入權限給使用者，而且同一時間內沒有其它人在上傳。 若讀者在其它同樣複製該伺服器的使用者上傳一些更新後上傳到上游，該上傳動作將會被拒絕。 讀者必須先將其它使用者上傳的資料拉下來並整合進來後才能上傳。 參考第三章瞭解如何上傳到遠端版本控制倉庫的細節。

### 監看遠端版本控制倉庫 ###

若讀者想取得遠端版本控制倉庫某部份更詳盡的資料，可執行 `git remote show [remote-name]`。 若執行此命令時加上特定的遠端名字，比如說： `origin`。 會看到類似以下輸出：

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

它將同時列出遠端版本控制倉庫的URL位置和追蹤分支資訊。特別是告訴你如果你在master分支時用`git pull`時，會去自動抓取數據合併到本地的master分支。它也列出所有曾經被抓取過的遠端分支。

當你使用Git更頻繁之後，你或許會想利用 `git remote show` 去看到更多的資訊。

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

這個指令顯示當你執行`git push`會自動推送的哪個分支(最後兩行)。它也顯示哪些遠端分支還沒被同步到本地端(在這個例子是caching)，哪些已同步到本地的遠端分支在遠端已被刪除(libwalker和walker2)，以及當執行`git pull`時會自動被合併的分支。

### 移除或重新命名遠端版本控制倉庫 ###

在新版 Git 中可以用 `git remote rename` 命令修改某個遠端版本控制倉庫在本地的簡稱，舉例而言，想把 `pb` 改成 `paul`，可以執行下列指令：


	$ git remote rename pb paul
	$ git remote
	origin
	paul

值得留意的是這也改變了遠端分支的名稱，原來的 `pb/master` 分支現在變成 `paul/master`。

當你為了種種原因想要移除某個遠端，像是換伺服器或是已不再使用某個特別的鏡像，又或是某個貢獻者已不再貢獻時。你可以使用`git remote rm`：

	$ git remote rm paul
	$ git remote
	origin

## 標籤 ##

就像大多數的版本管理系統，Git具備在特定時間點加入標籤去註明其重要性的功能。一般而言，我們會使用這個功能去標記出發行版本(如V1.0等等)。這個小節中，你將會學到如何列出既有的標籤、建立新標籤以及各種不同標籤間的差異。


### 列出標籤 ###

在Git中列出既有的標籤是非常簡單的。直接輸入`git tag`：

	$ git tag
	v0.1
	v1.3

這個指令將以字母順序列出標籤；所以這個順序並不代表其重要性。

你也可以用特定的字串規則去搜尋標籤。以Git本身的版本控制倉庫為例，其中包含超過240個標籤。當你只對1.4.2感興趣時，你可以執行以下指令：

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### 建立標籤 ###

Git使用兩大類的標籤：輕量級(lightweight)和含附註(annotated)。輕量級標籤就像是沒有更動的分支，實際上它僅是指到特定commit的指標。然而，含附註的標籤則是實際存在Git資料庫上的完整物件。它具備檢查碼、e-mail和日期，也包含標籤訊息，並可以被GNU Privacy Guard (GPG)簽署和驗證。一般而言，我們都建議使用含附註的標籤以便保留相關訊息；但如果只是臨時加註標籤或不需要保留其他訊息，就是使用輕量級標籤的時機。

### 含附註的標籤 ###

建立一個含附註的標籤很簡單。最容易的方法是加入`-a`到`tag`指令上：

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

而`-m`選項用來設定標籤訊息。如果你沒有設定該訊息，Git會啟動文字編輯器讓你輸入。

透過`git show`可看到指定標籤的資料與對應的commit。

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

在列出commit資訊前，我們可以看到這個標籤的設定者資訊，下標籤時間與附註訊息。

### 簽署標籤 ###

假設你有私鑰(private key)，你也可以用GPG簽署在標籤上。只要用`-s`取代`-a`：

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

再對這個標籤執行`git show`，你就能看到你的GPG簽章以經附在裡面：

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

稍後你會看到如何驗證已簽署的標籤。

### 輕量級的標籤 ###

另一種則是輕量級的標籤。基本上就是只保存commit檢查碼的文件。要建立這樣的標籤，不必下任何選項，直接設定標籤名稱即可。

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

這樣一來，當執行`git show`查看這個標籤時，你不會看到其他標籤資訊，只會顯示對應的commit：

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### 驗證標籤 ###

想要驗證已簽署的標籤，需要使用`git tag -v [tag-name]`。這個指令透過GPG去驗證簽章。而且在你的keyring中需要有簽署者的公鑰才能進行驗證：

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

如果沒有簽署者的公鑰，則會看到下列訊息：

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### 追加標籤 ###

你也可以對過去的commit上加入標籤。假設你的commit歷史如下：

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

如果你之前忘了將"updated rakefile"這個commit加入v1.2標籤。仍然可在事後設定。要完成這個動作，你必須加入該次commit的檢查碼(或前幾碼即可)到以下指令：

	$ git tag -a v1.2 9fceb02

你可以看到標籤已經補上：

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

### 分享標籤 ###

在預設的情況下，`git push`指令並不會將標籤傳到遠端伺服器上。當建立新標籤後，你必須特別下指令才會將它推送到遠端版本控制倉庫上。類似將分支推送到遠端的過程，透過`git push origin [tagname]`指令。

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

如果你有很多標籤需要一次推送上去，你也可以加入`--tags`選項到`git push`指令中。這將會傳送所有尚未在遠端伺服器上的標籤。

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

現在，當其他使用者clone或pull你的版本控制倉庫時，他們也同時會取得所有你的標籤。

## 提示和技巧 ##

在結束Git基礎這個章節前，我們將介紹有一些將會使你的Git使用經驗更簡單、方便和親切的提示和技巧。或許很多人從未運用過這些技巧，我們也不會假設你在本書的後續章節會使用它們。但你也許會想知道如何使用它們。

### 自動補齊 ###

如果你用的是 Bash shell，你可以啟動Git本身寫好的自動補齊腳本。下載Git原始碼，切到`contrib/completion`目錄；可以看到檔案名為`git-completion.bash`。將它複製到你的家目錄，並加入以下指令到你的`.bashrc`檔案裡：

	source ~/git-completion.bash

如果你想為所有使用者都自動設定Bash shell的補齊功能，在Mac系統上將這個腳本複製到`/opt/local/etc/bash_completion.d`目錄，若你使用Linux系統複製到 `/etc/bash_completion.d/`目錄。這兩個目錄中的脚本，都會在 Bash 啟動時自動載入。

如果你在Windows使用Git Bash，也就是利用Windows with msysGit安裝Git，自動補齊功能已預先設定好，可以直接使用。

在你輸入Git指令時，只要按下Tab鍵，便會列出所有合適的指令建議：

	$ git co<tab><tab>
	commit config

然後按下Tab鍵兩次，便會提示commit和config這些可用指令。當再輸入`m<tab>`便會自動補齊`git commit`。

指令的選項也可以自動補齊，這或許是更實用的功能。舉例而言，當你下`git log`指令時，若忘記該輸入哪個選項，只要輸入開頭字元然後按下Tab去看看可能的選項：

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

這是個好用的小技巧，或許可以省下許多輸入和查文件的時間

### Git 命令別名 ###

如果僅輸入命令的部份字元，Git並不會幫你推論出你想要下的完整命令。如果你想偷懶，不想輸入Git命令的所有字元，你可以輕易地利用`git config`設定別名(alias)。你也許會想要設定以下這幾個範例：

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

這些例子顯示出，你可以只輸入`git ci`，取代輸入`git commit`。隨著你深入使用Git，將會發現某些命令用得頻繁；這時不妨建立新的別名提高使用效率。

利用這個技術將有助於創造出你認為應該存在的命令。舉例而言，為了提高取消暫存檔案的便利性，你可以加入以下命令：

	$ git config --global alias.unstage 'reset HEAD --'

這將使得下列兩個命令完全相等：

	$ git unstage fileA
	$ git reset HEAD fileA

使用別名看起來更清楚。另外，加入`last`別名也是很常用的技巧：

	$ git config --global alias.last 'log -1 HEAD'

如此一來，將可更簡單地看到最新的提交訊息：

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

你可以發現，Git只是簡單地在命令中替換你設定的別名。然而，你不僅希望執行Git 的子命令，而想執行外部命令。在這個情形中，你可以加入`!`字元在所要執行的命令前。這將有助於設計運作於Git版本控制倉庫的自製工具。這個範例藉由設定`git visual`別名去執行`gitk`：

	$ git config --global alias.visual '!gitk'

## 總結 ##

至此，讀者已具備所有Git的本地端操作，包括：建立和複製版本控制倉庫、建立修改、暫存和提交這些修改，以及檢視在版本控制倉庫中所有修改歷史。接下來，我們將觸及Git的殺手級特性，也就是他的分支模型。
