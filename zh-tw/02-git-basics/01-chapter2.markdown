# Git 基礎 #

若讀者只需要讀取一個章節即可開始使用Git，這就是了。 本章節涵蓋讀者大部份用到Git時需要使用的所有基本命令。 在讀完本章節後，讀者應該有能力組態及初始化一個儲存庫、開始及停止追蹤檔案、暫存及提供更新。 還會提到如何讓Git忽略某些檔案、如何輕鬆且很快的救回失誤、如何瀏覽讀者的專案的歷史及觀看各個已提交的更新之間的變更、以及如何上傳到遠端儲存庫或取得。

## 取得Git儲存庫 ##

讀者可使用兩種主要的方法取得一個Git儲存庫。 第一種是將現有的專案或者目錄匯入Git。 第二種從其它伺服器複製一份已存在的Git儲存庫。

### 在現有目錄初始化儲存庫 ###

若讀者要開始使用 Git 追蹤現有的專案，只需要進入該專案的目錄並執行：

	$ git init

這個命令會建立名為 .git 的子目錄，該目錄包含一個Git儲存庫架構必要的所有檔案。 目前來說，專案內任何檔案都還沒有被追蹤。（關於.git目錄內有些什麼檔案，可參考第九章）

若讀者想要開始對現有的檔案開始做版本控制（除了空的目錄以外），讀者也許應該開始追蹤這些檔案並做第一次的提交。 讀者能以少數的git add命令指定要追蹤的檔案，並將它們提交：

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

這些命令執行完畢大約只需要一分鐘。 現在，讀者已經有個追蹤部份檔案及第一次提交內容的Git儲存庫。

### 複製現有的儲存庫 ###

若讀者想要取得現有的Git儲存庫的複本（例如：讀者想要散佈的），那需要使用的命令是 git clone。 若讀者熟悉其它版本控制系統，例如：Subversion，讀者應該注意這個命令是複製，而不是取出特定版本。 這一點非常重要，Git取得的是大部份伺服器端所有的資料複本。 該專案歷史中所有檔案的所有版本都在讀者執行過 git clone 後拉回來。 事實上，若伺服器的磁碟機損毀，讀者可使用任何一個客戶端的複本還原伺服器為當初取得該複本的狀態（讀者可能會遺失一些僅存於伺服器的攔截程式，不過所有版本的資料都健在），參考第四章取得更多資訊。

讀者可以 git clone 超連結，複製一個儲存庫。 例如：若讀者想複製名為Grit的Ruby Git程式庫，可以執行下列命令：

	$ git clone git://github.com/schacon/grit.git

接下來會有個名為grit的目錄被建立，並在其下初始化名為.git的目錄。 拉下所有存在該儲存庫的所有資料，並取出最新版本為工作複本。 若讀者進入新建立的 grit 目錄，會看到專案的檔案都在這兒，且可使用。 若讀者想畏複製儲存庫到grit以外其它名字的目錄，只需要在下一個參數指定即可：

	$ git clone git://github.com/schacon/grit.git mygrit

這個命令做的事大致如同上一個命令，只不過目的目錄名為mygrit。

Git提供很多種協定給讀者使用。 上一個範例採用 git:// 協定，讀者可能會看過 http(s):// 或者 user@server:/path.git 等使用 SSH 傳輸的協定。 在第四章會介紹設定存取伺服器上的 Git 儲存庫的所有可用的選項，以及它們的優點及缺點。

## 提交更新到儲存庫 ##

讀者現在有一個貨真價實的Git儲存庫，而且有一份已放到工作複本的該專案的檔案。 讀者需要做一些修改並提交這些更動的快照到儲存庫，當這些修改到達讀者想要記錄狀態的情況。

記住工作目錄內的每個檔案可能為兩種狀態的任一種：追蹤或者尚未被追蹤。 被追蹤的檔案是最近的快照；它們可被復原、修改，或者暫存。 未被追蹤的檔案則是其它未在最近快照也未被暫存的任何檔案。 當讀者第一次複製儲存器時，讀者所有檔案都是被追蹤且未被修改的。 因為讀者剛取出它們而且尚未更改做任何修改。

只要讀者編輯任何已被追蹤的檔案。 Git將它們視為被更動的，因為讀者將它們改成與最後一次提交不同。 讀者暫存這些已更動檔案並提供所有被暫存的更新， 並重複此週期。 此生命週期如圖2-1所示。

Insert 18333fig0201.png 
圖2-1. 檔案狀態的生命週期。

### 檢視檔案的狀態 ###

主要給讀者用來檢視檔案的狀態是 git status 命令。 若讀者在複製完複本後馬上執行此命令，會看到如下的文字：

	$ git status
	# On branch master
	nothing to commit (working directory clean)

這意謂著讀者有一份乾淨的工作目錄（換句話說，沒有未被追蹤或已被修改的檔案）。 Git未看到任何未被追蹤的檔案，否則會將它們列出。 最後，這個命令告訴讀者目前在哪一個分支。 到目前為止，一直都是master，這是預設的。 目前讀者不用考慮它。 下一個章節會詳細介紹分支。

假設讀者新增一些檔案到專案，如README。 若該檔案先前並不存在，執行 git status 命令後，讀者會看到未被追蹤的檔案，如下：

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

讀者可看到新增的README尚未被追蹤，因為它被列在輸出訊息的 Untracked files 下方。 除非讀者明確指定要將該檔案加入提交的快照，Git不會主動將它加入。 這樣就不會突然地將一些二進位格式的檔案或其它讀者並不想加入的檔案含入。 讀者的確是要新增 README 檔案，因此讓我們開始追蹤該檔案。

### 追蹤新檔案 ###

要追蹤新增的檔案，讀者可使用git add命令。 欲追蹤README檔案，讀者可執行：

	$ git add README

若讀者再度檢查目前狀態，可看到README檔案已被列入追蹤並且已被暫存：

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

因為它被放在Changes to be commited文字下方，讀者可得知它已被暫存起來。 若讀者此時提交更新，剛才執行git add加進來的檔案就會被記錄在歷史的快照。 讀者可能可回想一下先前執行git init後也有執行過git add，開始追蹤目錄內的檔案。 git add命令可接受檔名或者目錄名。 若是目錄名，會遞迴將整個目錄下所有檔案及子目錄都加進來。

### 暫存已修改檔案 ###

讓我們修改已被追蹤的檔案。 若讀者修改先前已被追蹤的檔案，名為benchmarks.rb，並檢查目前儲存庫的狀態。 讀者會看到類似以下文字：

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

benchmarks.rb檔案出現在Changed but not updated下方，代表著這個檔案已被追蹤，而且位於工作目錄的該檔案已被修改，但尚未暫存。 要暫存該檔案，可執行git add命令（這是一個多重用途的檔案）。現在，讀者使用 git add將benchmarks.rb檔案暫存起來，並再度執行git status：

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

這兩個檔案目前都被暫存起來，而且會進入下一次的提交。 假設讀者記得仍需要對benchmarks.rb做一點修改後才要提交，可再度開啟並編輯該檔案。 然而，當我們再度執行git status：

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

到底發生了什麼事？ 現在benchmarks.rb同時被列在已被暫存及未被暫存。 這怎麼可能？ 這表示Git的確在讀者執行git add命令後，將檔案暫存起來。 若讀者現在提交更新，最近一次執行git add命令時暫存的benchmarks.rb會被提交。 若讀者在git add後修改檔案，需要再度執行git add將最新版的檔案暫存起來：

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### 忽略某些檔案 ###

通常讀者會有一類不想讓Git自動新增，也不希望它們被列入未被追蹤的檔案。 這些通常是自動產生的檔案，例如：記錄檔或者編譯系統產生的檔案。 在這情況下，讀者可建立一個名為.gitignore檔案，列出符合這些檔案檔名的特徵。 以下是一個範例：

	$ cat .gitignore
	*.[oa]
	*~

第一列告訴Git忽略任何檔名為.o或.a結尾的檔案，它們是可能是編譯系統建置讀者的程式碼時產生的目的檔及程式庫。 第二列告訴Git忽略所有檔名為~結尾的檔案，通常被很多文書編輯器，如：Emacs，使用的暫存檔案。 讀者可能會想一併將log、tmp、pid目錄及自動產生的文件等也一併加進來。 依據類推。 在讀者要開始開發之前將.gitignore設定好，通常是一個不錯的點子。 這樣子讀者不會意外的將真的不想追蹤的檔案提交到Git儲存庫。

編寫.gitignore檔案的規則如下：

*	空白列或者以#開頭的列會被忽略。
*	可使用標準的Glob pattern。
*	可以/結尾，代表是目錄。
*	可使用!符號將特徵反過來使用。

Glob pattern就像是shell使用的簡化版正規運算式。 星號（*）匹配零個或多個字元；[abc]匹配中括弧內的任一字元（此例為a、b、c）；問號（?）匹配單一個字元；中括孤內的字以連字符連接（如：[0-9]），用來匹配任何符合該範圍的字（此例為0到9）。


以下是其它的範例：

	# 註解，會被忽略。
	*.a       # 不要追蹤檔名為 .a 結尾的檔案
	!lib.a    # 但是要追蹤 lib.a，即使上方已指定忽略所有的 .a 檔案
	/TODO     # 只忽略根目錄下的 TODO 檔案。 不包含子目錄下的 TODO
	build/    # 忽略build/目錄下所有檔案
	doc/*.txt # 忽略doc/notes.txt但不包含doc/server/arch.txt

### 檢視已暫存及尚未暫存的更動 ###

若git status命令仍無法清楚告訴讀者想要的資訊（讀者想知道的是更動了哪些內容，而不是哪些檔案）。 可使用git diff命令。 稍後我們會更詳盡講解該命令。 讀者使用它時通常會是為了瞭解兩個問題： 目前已做的修改但尚未暫存的內容是哪些？ 以及將被提交的暫存資料有哪些？ 雖然git status一般來說即可回答這些問題。 git diff可精確的顯示哪些列被加入或刪除，以修補檔方式表達。

假設讀者編輯並暫存README，接者修改benchmarks.rb檔案，卻未暫存。 若讀者檢視目前的狀況，會看到類似下方文字：

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

想瞭解尚未暫存的修改，執行git diff，不用帶任何參數：

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

這命令比對目前工作目錄及暫存區域後告訴讀者哪些變更尚未被暫存。

若讀者想知道將被提交的暫存資料，使用git diff --cached（在Git 1.6.1及更新版本，也可以使用較易記憶的git diff --staged命令）。 這命令比對暫存區域及最後一個提交。

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

很重要的一點是git diff不會顯示最後一次commit後的所有變更；只會顯示尚未暫存的變更。 這一點可能會混淆，若讀者已暫存所有的變更，git diff不會顯示任何資訊。

舉其它例子，若讀者暫存benchmarks.rb檔案後又編輯，可使用git diff看已暫存的版本與工作目錄內版本尚未暫存的變更：

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

現在讀者可使用git diff檢視哪些部份尚未被暫存：

	$ git diff 
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats 
	+# test line

以及使用git diff --cached檢視目前已暫存的變更：

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

現在讀者的暫存區域已被更新為讀者想畏的，可開始提交變更的部份。 要記得任何尚未被暫存的新建檔案或已被修改但尚未使用git add暫存的檔案將不會被記錄在本次的提交中。 它們仍會以被修改的檔案的身份存在磁碟中。
在這情況下，最後一次執行git status，讀者會看到所有已被暫存的檔案，讀者也準備好要提交修改。 最簡單的提交是執行git commit：

	$ git commit

執行此命令會叫出讀者指定的編輯器。（由讀者shell的$EDITOR環境變數指定，通常是vim或emacs。讀者也可以如同第1章介紹的，使用git config --global core.editor命令指定）

編輯器會顯示如下文字（此範例為Vim的畫面）：

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

讀者可看到預設的提交訊息包含最近一次git status的輸出以註解方式呈現，以及螢幕最上方有一列空白列。 讀者可移除這些註解後再輸入提交的訊息，或者保留它們，提醒你現在正在進行提交。（若想知道更動的內容，可傳遞-v參數給git commit。如此一來連比對的結果也會一併顯示在編輯器內，方便讀者明確看到有什麼變更。） 當讀者離開編輯器，Git會利用這些提交訊息產生新的提交（註解及比對的結果會先被濾除）。

另一種方式則是在commit命令後方以-m參數指定提交訊息，如下：

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

現在讀者已建立第一個提交！ 讀者可從輸出的訊息看到此提交、放到哪個分支（master）、SHA-1查核碼（463dc4f）、有多少檔案被更動，以及統計此提交有多少列被新增及移除。

記得提交記錄讀者放在暫存區的快照。 任何讀者未暫存的仍然保持在已被修改狀態；讀者可進行其它的提交，將它增加到歷史。 每一次讀者執行提供，都是記錄專案的快照，而且以後可用來比對或者復原。

### 跳過暫存區域 ###

雖然優秀好用的暫存區域能很有技巧且精確的提交讀者想記錄的資訊，有時候暫存區域也比讀者實際需要的工作流程繁瑣。 若讀者想跳過暫存區域，Git提供了簡易的使用方式。 在git commit命令後方加上-a參數，Git自動將所有已被追蹤且被修改的檔案送到暫存區域並開始提交程序，讓讀者略過git add的步驟：

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

留意本次的提交之前，讀者並不需要執行git add將benchmarks.rb檔案加入。

### 刪除檔案 ###

要從Git刪除檔案，讀者需要將它從已被追蹤檔案中移除（更精確的來說，是從暫存區域移除），並且提交。 git rm命令除了完成此工作外，也會將該檔案從工作目錄移除。 因此讀者以後不會在未被追蹤檔案列表看到它。

若讀者僅僅是將檔案從工作目錄移除，那麼在git status的輸出，可看見該檔案將會被視為已被變更且尚未被更新（也就是尚未存到暫存區域）：

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

接著，若執行git rm，則會將暫存區域內的該檔案移除：

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

下一次提交時，該檔案將會消失而且不再被追蹤。 若已更動過該檔案且將它記錄到暫存區域。 必須使用-f參數才能將它強制移除。 這是為了避免已被記錄的快照意外被移除且再也無法使用Git復原。

其它有用的技巧的是保留工作目錄內的檔案，但從暫存區域移除。 換句話說，或許讀者想在磁碟機上的檔案且不希望Git繼續追蹤它。 這在讀者忘記將某些檔案記錄到.gitignore且不小心將它增加到暫存區域時特別有用。 比如說：巨大的記錄檔、或大量在編譯時期產生的.a檔案。 欲使用此功能，加上--cached參數：

	$ git rm --cached readme.txt

除了檔名、目錄名以外，還可以指定簡化的正規運算式給git rm命令。 這意謂著可執行類似下列指令：

	$ git rm log/\*.log

注意倒斜線（\）前方的星號（*）。 這是必須的，因為Git會在shell以上執行檔案的擴展。 此命令移除log目錄下所有檔名以.log結尾的檔案。 讀者也可以執行類似下列命令：

	$ git rm \*~

此命令移除所有檔名以~結尾的檔案。

### 搬動檔案 ###

Git並不像其它檔案控制系統一樣，很精確的追蹤檔案的移動。 若將被Git追蹤的檔名更名，Git並沒有任何元數據記錄此更名動作。 然而Git能很聰明的指出這一點。 稍後會介紹關於偵測檔案的搬動。

因此Git的mv指令會造成一點混淆。 若想要用Git更名某個檔案，可執行以下命令：

	$ git mv file_from file_to

而且這命令可正常工作。 事實上，在執行完更名的動作後檢視一下狀態。 可看到Git認為該檔案被更名：

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

不過，這就相當於執行下列命令：

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git會在背後判斷檔案是否被更名，因此不管是用上述方法還是mv命令都沒有差別。 實際上唯一不同的是mv是一個命令，而不是三個。 使用上較方便。 更重畏的是讀者可使用任何慣用的工具更名，再使用add/rm，接著才提交。

## 檢視提交的歷史記錄 ##

在提交數個更新，或者複製已有一些歷史記錄的儲存庫後。 或許會想希望檢視之前發生過什麼事。 最基本也最具威力的工具就是 git log 命令。

以下採用非常簡單，名為 simplegit 的專案做展示。 欲取得此專案，執行以下命令：

	git clone git://github.com/schacon/simplegit-progit.git

在此專案目錄內執行 git log，應該會看到類似以下訊息：

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

在未加任何參數情況下，git log以新到舊的順序列出儲存庫的提交的歷史記錄。 也就是說最新的更新會先被列出來。 同時也會列出每個更新的 SHA1 查核值、作者大名及電子郵件地址、及提交時輸入的訊息。

git log命令有很多樣化的選項，供讀者精確指出想搜尋的結果。 接下來會介紹一些常用的選項。

最常用的選項之一為 -p，用來顯示每個更新之間差別的內容。 另外還可以加上 -2 參數，限制為只輸出最後兩個更新。

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

這個選項除了顯示相同的資訊外，還另外附上每個更新的差異。 這對於重新檢視或者快速的瀏覽協同工作伙伴新增的更新非常有幫助。
另外也可以使用git log提供的一系統摘要選項。 例如：若想檢視每個更新的簡略統計資訊，可使用 --stat 選項：

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

如以上所示，--stat選項在每個更新項目的下方列出被更動的檔案、有多少檔案被更動，以及有多行列被加入或移出該檔案。 也會在最後印出摘要的訊息。
其它實用的選項是 --pretty。 這個選項改變原本預設輸出的格式。 有數個內建的選項供讀者選用。 其中 oneline 選項將每一個更新印到單獨一行，對於檢視很多更新時很有用。 更進一步，short、full、fuller 選項輸出的格式大致相同，但會少一些或者多一些資訊。

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

最有趣的選項是 format，允許讀者指定自訂的輸出格式1。 當需要輸出給機器分析時特別有用。 因為明確的指定了格式，即可確定它不會因為更新 Git 而被更動：

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

表格2-1列出一些 format 支援的選項。

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

讀者可能會好奇作者與提交者之間的差別。 作者是完成該工作的人，而提交者則是最後將該工作提交出來的人。 因此，若讀者將某個專案的修補檔送出，而且該專案的核心成員中一員套用該更新，則讀者與該成員皆會被列入該更新。 讀者即作者，而該成員則是提交者。 在第五章會提到較多之間的差別。

oneline 及 format 選項對於另一個名為 --graph 的選項特別有用。 該選項以 ASCII 畫出分支的分歧及合併的歷史。 可參考我們的 Grit 的儲存庫：

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

這些只是一些簡單的 git log 的選項，還有許多其它的。 表格2-2列出目前我們涵蓋的及一些可能有用的格式選項，以及它們如何更動 git log 命令的輸出格式。

	選項	選項的說明
	-p	顯示每個更新與上一個的差異。
	--stat	顯示每個更新更動的檔案的統計及摘要資訊。
	--shortstat	僅顯示--stat提供的的訊息中關於更動、插入、刪除的文字。
	--name-only	在更新的訊息後方顯示更動的檔案列表。
	--name-status	顯示新增、更動、刪除的檔案列表。
	--abbrev-commit	僅顯示SHA1查核值的前幾位數，而不是顯示全部的40位數。
	--relative-date	以相對於目前時間方式顯示日期（例如：“2 weeks ago”），而不是完整的日期格式。
	--graph	以 ASCII 在 log 輸出旁邊畫出分支的分歧及合併。
	--pretty	以其它格式顯示更新。 可用的選項包含oneline、short、full、fuller及可自訂格式的format。

### 限制 log 的輸出範圍 ###

除了輸出格式的選項，git log也接受一些好用的選項。 也就是指定只顯示某一個子集合的更新。 先前已介紹過僅顯示最後兩筆更新的 -2 選項。 實際上可指定 -n，而 n 是任何整數，用來顯示最後的 n 個更新。 不過讀者可能不太會常用此選項，因為 Git 預設將所有的輸出導到分頁程式，故一次只會看到一頁。

然而，像 --since 及 --until 限制時間的選項就很有用。 例如，以下命令列出最近兩週的更新：

	$ git log --since=2.weeks

此命令支援多種格式。 可指定特定日期（如：2008-01-15）或相對的日期，如：2 years 1day 3minutes ago。

使用者也可以過濾出符合某些搜尋條件的更新。 --author 選項允許使用者過濾出特定作者，而 --grep 選項允許以關鍵字搜尋提交的訊息。（注意：若希望同時符合作者名字及字串比對，需要再加上 --all-match；否則預設為列出符合任一條件的更新）

最後一個有用的選項是過濾路徑。 若指定目錄或檔案名稱，可僅印出更動到這些檔案的更新。 這選項永遠放在最後，而且一般來說會在前方加上 -- 以資區別。

在表格2-3，我們列出這些選項以及少數其它常見選項以供參考。

	選項	選項的說明文字
	-(n)	僅顯示最後 n 個更新
	--since, --after	列出特定日期後的更新。
	--until, --before	列出特定日期前的更新。
	--author	列出作者名稱符合指定字串的更新。
	--committer	列出提交者名稱符合指定字串的更新。

例如：若想檢視 Git 的原始碼中，Junio Hamano 在 2008 年十月份提交且不是合併用的更新。 可執行以下命令：

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

若讀者較偏向使用圖形界面檢視歷史，或與會想看一下隨著 Git 發怖的，名為 gitk 的 Tcl/Tk 程式。 Gitk 基本上就是 git log 的圖形界面版本，而且幾乎接受所有 git log 支援的過濾用選項。 若在專案所在目錄下執行 gitk 命令，將會看到如圖2-2的畫面。

Insert 18333fig0202.png 
圖2-2。 gitk檢視歷史程式。

在上圖中可看到視窗的上半部顯示相當棒的更新歷史圖。 視窗下半部則顯示當時被點選的更新引入的變更。

## 復原 ##

在任何時間點，或許讀者會想要復原一些事情。 接下來我們會介紹一些基本的復原方式。 但要注意，由於有些復原動作所做的變更無法再被還原。 這是少數在使用 Git 時，執行錯誤的動作會遺失資料的情況。

### 更動最後一筆更新 ###

最常見的復原發生在太早提交更新，也許忘了加入某些檔案、或者搞砸了提交的訊息。 若想要試著重新提交，可試著加上 --amend 選項：

	$ git commit --amend

此命令取出暫存區資料並用來做本次的提交。 只要在最後一次提交後沒有做過任何修改（例如：在上一次提交後，馬上執行此命令），那麼整個快照看起來會與上次提交的一模一樣，唯一有更動的是提交時的訊息。

同一個文書編輯器被帶出來，並且已包含先前提交的更新內的訊息。 讀者可像往常一樣編輯這些訊息，差別在於它們會覆蓋上一次提交。

如下例，若提交了更新後發現忘了一併提交某些檔案，可執行最後一個命令：

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

這些命令的僅僅會提交一個更新，第二個被提交的更新會取代第一個。

### 取消已被暫存的檔案 ###

接下來兩節展示如何應付暫存區及工作目錄的復原。 用來判斷這兩個區域狀態的命令也以相當好的方式提示如何復原。 比如說已經修改兩個檔案，並想要以兩個不同的更新提交它們，不過不小心執行 git add * 將它們同時都加入暫存區。 應該如何將其中一個移出暫存區？ git status 命令已附上相關的提示：

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

在 "Changes to be commited" 文字下方，註明著使用 "git reset HEAD <file>..."，將 file 移出暫存區。 因此，讓我們依循該建議將 benchmarks.rb 檔案移出暫存區：

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

這個命令看起來有點奇怪，不過它的確可用。 benchmarks.rb 檔案被移出暫存區了。

### 復原已被更動的檔案 ###

若讀者發現其者並不需要保留 benchmarks.rb 檔案被更動部份，應該如何做才能很容易的復原為最後一次提交的狀態（或者最被複製儲存庫時、或放到工作目錄時的版本）？ 很幸運的，git status 同樣也告訴讀者如何做。 在最近一次檢視狀態時，暫存區看起來應如下所示：

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

在這訊息中已很明確的說明如何拋棄所做的修改（至少需升級為 Git 1.6.1或更新版本。 若讀者使用的是舊版，強烈建議升級，以取得更好用的功能。） 讓我們依據命令執行：

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

在上述文字可看到該變更已被復原。 讀者應該瞭解這是危險的命令，任何對該檔案做的修改將不復存在，就好像複製別的檔案將它覆蓋。 除非很清楚真的不需要該檔案，絕不要使用此檔案。 若需要將這些修改排除，我們在下一章節會介紹備份及分支。 一般來說會比此方法來的好。

切記，任何在 Git 提交的更新幾乎都是可復原的。 即使是分支中的更新被刪除或被 --amend 覆寫，皆能被覆原。（參考第九章關於資料的復原） 然而，未被提交的則幾乎無法救回。

## 與遠端協同工作 ##

欲在任何Git控管的專案協同作業，需要瞭解如何管理遠端的儲存庫。 遠端儲存庫讀者是置放在網際網路或網路其它地方的複本。 讀者可設定多個遠端儲存庫，唯讀或者可讀寫。 與他人協同作業時，需要管理這些遠端儲存庫，並在需要分享工作時上傳或下載資料。
管理遠端儲存庫包含瞭解如何新增遠端儲存庫、移除已失效的儲存庫、管理許多分支及定義是否要追蹤它們等等。 本節包含如何遠端管理的技巧。

### 顯示所有的遠端儲存庫 ###

欲瞭解目前已加進來的遠端儲存庫，可執行 git remote 命令。 它會列出當初加入遠端儲存庫時指定的名稱。 若目前所在儲存庫是從其它儲存庫複製過來的，至少應該看到 origin，也就是 Git 複製儲存庫時預設取的名字：

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

也可以再加上 -v 參數，將會在名稱後方顯示其URL：

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

若有一個以上遠端儲存庫，此命令會列出全部。 例如：我的 Grit 儲存庫包含以下遠端儲存庫。

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

這意謂著我們可很容易從這些伙伴的儲存庫取得最新的更新。 要留意的是只有 origin 遠端的 URL 是 SSH。 因此它是唯一我們能上傳的遠端的儲存庫。（關於這部份將在第四章介紹） 

### 新增遠端儲存庫 ###

在先前章節已提到並示範如何新增遠端儲存庫，這邊會很明確的說明如何做這項工作。 欲新增遠端儲存庫並取一個簡短的名字，執行 git remote add名字 URL： 

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

現在可看到命令列中的 pb 字串取代了整個 URL。 例如，若想取得 Paul 上傳的且本地端儲存庫沒有的更新，可執行 git fetch pb：

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

現在可在本地端使用 pb/master 存取 Paul 的 master 分支。 讀者可將它合併到本地端任一分支、或者建立一個本地端的分支指向它，如果讀者想監看它。

### 從遠端儲存庫擷取或合併 ###

如剛才所示，欲從遠端擷取資料，可執行：

	$ git fetch [remote-name]

此命令到該遠端專案將所有本地端沒有的資料拉下來。 在執行此動作後，讀者應該有參考到該遠端專案所有分支的參考點，可在任何時間點用來合併或監看。（在第三章將會提及更多關於如何使用分支的細節）

若複製了一個儲存庫，會自動將該遠端儲存庫命令為 origin。 因此 git fetch origin 取出所有在複製或最後一下擷取後被上傳到該儲存庫的更新。 需留意的是 fetch 命令僅僅將資料拉到本地端的儲存庫，並未自動將它合併進來，也沒有修改任何目前工作的項目。 讀者得在必要時將它們手動合併進來。

若讀者設定一個會追蹤遠端分支的分支（參考下一節及第三章，取得更多資料），可使用 git pull 命令自動擷取及合併遠端分支到目錄的分支。 這對讀者來說或許是較合適的工作流程。 而且 git clone 命令預設情況下會自動設定本地端的 master 分支追蹤被複製的遠端儲存庫的 master 分支。（假設該儲存庫有 master 分支） 執行 git pull 一般來說會從當初複製時的來源儲存庫擷取資料並自動試著合併到目前工作的版本。

### 上傳到遠端儲存庫 ###

當讀者有想分享出去的專案，可將更新上傳到上游。 執行此動作的命令很簡單：git push 遠端儲存庫名字 分支名。 若想要上傳 master 分支到 origin 伺服器（再說一次，複製時通常自動設定此名字），接著執行以下命令即可上傳到伺服器：

	$ git push origin master

此命令只有在被複製的伺服器開放寫入權限給使用者，而且同一時間內沒有其它人在上傳。 若讀者在其它同樣複製該伺服器的使用者上傳一些更新後上傳到上游，該上傳動作將會被拒絕。 讀者必須先將其它使用者上傳的資料拉下來並整合進來後才能上傳。 參考第三章瞭解如何上傳到遠端儲存庫的細節。

### 監看遠端儲存庫 ###

若讀者想取得遠端儲存庫某部份更詳盡的資料，可執行 git remote show 遠端儲存庫名字。 若執行此命令時加上特定的遠端名字，比如說： origin。 會看到類似以下輸出：

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

## Tagging ##

Like most VCSs, Git has the ability to tag specific points in history as being important. Generally, people use this functionality to mark release points (v1.0, and so on). In this section, you’ll learn how to list the available tags, how to create new tags, and what the different types of tags are.

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
