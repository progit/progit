# Git 分支 #

幾乎每一種版本控制系統都以某種形式支援分支。使用分支意味著你可以從開發主線上分離開來，然後在不影響主線的同時繼續工作。在很多版本控制系統中，這是個昂貴的過程，常常需要建立一個原始程式碼目錄的完整副本，對大型專案來說會花費很長時間。

有人把 Git 的分支模型稱為“必殺技特性”，而正是因為它，將 Git 從版本控制系統家族裡區分出來。Git 有何特別之處呢？Git 的分支可謂是難以置信的羽量級，它的新增操作幾乎可以在瞬間完成，並且在不同分支間切換起來也差不多一樣快。和許多其他版本控制系統不同，Git 鼓勵在工作流程中頻繁使用分支與合併，哪怕一天之內進行許多次都沒有關係。理解分支的概念並熟練運用後，你才會意識到為什麼 Git 是一個如此強大而獨特的工具，並從此真正改變你的開發方式。

## 何謂分支 ##

為了理解 Git 分支的實現方式，我們需要回顧一下 Git 是如何保存資料的。或許你還記得第一章的內容，Git 保存的不是檔差異或者變化量，而只是一系列檔快照。

在 Git 中提交時，會保存一個提交（commit）物件，該物件包含一個指向暫存內容快照的指標，包含本次提交的作者等相關附屬資訊，包含零個或多個指向該提交物件的父物件指標：首次提交是沒有直接祖先的，普通提交有一個祖先，由兩個或多個分支合併產生的提交則有多個祖先。

為直觀起見，我們假設在工作目錄中有三個檔案，準備將它們暫存後提交。暫存操作會對每一個檔計算雜湊值（即第一章中提到的 SHA-1 雜湊字串），然後把目前版本的檔快照保存到 Git 倉庫中（Git 使用 blob 類型的物件存儲這些快照），並將雜湊值加入暫存區域：

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

當使用 `git commit` 新建一個提交物件前，Git 會先計算每一個子目錄（本例中就是專案根目錄）的雜湊值，然後在 Git 倉庫中將這些目錄保存為樹（tree）物件。之後 Git 建立的提交物件，除了包含相關提交資訊以外，還包含著指向這個樹物件（專案根目錄）的指標，如此它就可以在將來需要的時候，重現此次快照的內容了。

現在，Git 倉庫中有五個物件：三個表示檔快照內容的 blob 物件；一個記錄著目錄樹內容及其中各個檔對應 blob 物件索引的 tree 物件；以及一個包含指向 tree 物件（根目錄）的索引和其他提交資訊中繼資料的 commit 物件。概念上來說，倉庫中的各個物件保存的資料和相互關係看起來如圖 3-1 所示：

Insert 18333fig0301.png
圖 3-1. 單個提交物件在倉庫中的資料結構

作些修改後再次提交，那麼這次的提交物件會包含一個指向上次提交物件的指標（譯注：即下圖中的 parent 物件）。兩次提交後，倉庫歷史會變成圖 3-2 的樣子：

Insert 18333fig0302.png
圖 3-2. 多個提交物件之間的連結關係

現在來談分支。Git 中的分支，其實本質上僅僅是個指向 commit 物件的可變指標。Git 會使用 master 作為分支的預設名字。在若干次提交後，你其實已經有了一個指向最後一次提交物件的 master 分支，它在每次提交的時候都會自動向前移動。

Insert 18333fig0303.png
圖 3-3. 分支其實就是從某個提交物件往回看的歷史

那麼，Git 又是如何建立一個新的分支的呢？答案很簡單，建立一個新的分支指標。比如新建一個 testing 分支，可以使用 `git branch` 命令：

	$ git branch testing

這會在目前 commit 物件上新建一個分支指標（見圖 3-4）。

Insert 18333fig0304.png
圖 3-4. 多個分支指向提交資料的歷史

那麼，Git 是如何知道你目前在哪個分支上工作的呢？其實答案也很簡單，它保存著一個名為 HEAD 的特別指標。請注意它和你熟知的許多其他版本控制系統（比如 Subversion 或 CVS）裡的 HEAD 概念大不相同。在 Git 中，它是一個指向你正在工作中的本地分支的指標（譯注：將 HEAD 想像為目前分支的別名。）。執行 `git branch` 命令，僅僅是建立了一個新的分支，但不會自動切換到這個分支中去，所以在這個例子中，我們依然還在 master 分支裡工作（參考圖 3-5）。

Insert 18333fig0305.png
圖 3-5. HEAD 指向目前所在的分支

要切換到其他分支，可以執行 `git checkout` 命令。我們現在轉換到新增的 testing 分支：

	$ git checkout testing

這樣 HEAD 就指向了 testing 分支（見圖3-6）。

Insert 18333fig0306.png
圖 3-6. HEAD 在你轉換分支時指向新的分支

這樣的實現方式會給我們帶來什麼好處呢？好吧，現在不妨再提交一次：

	$ vim test.rb
	$ git commit -a -m 'made a change'

圖 3-7 示範了提交後的結果。

Insert 18333fig0307.png
圖 3-7. 每次提交後 HEAD 隨著分支一起向前移動

非常有趣，現在 testing 分支向前移動了一格，而 master 分支仍然指向原先 `git checkout` 時所在的 commit 物件。現在我們回到 master 分支看看：

	$ git checkout master

圖 3-8 顯示了結果。

Insert 18333fig0308.png
圖 3-8. HEAD 在一次 checkout 之後移動到了另一個分支

這條命令做了兩件事。它把 HEAD 指標移回到 master 分支，並把工作目錄中的檔換成了 master 分支所指向的快照內容。也就是說，現在開始所做的改動，將始於本專案中一個較老的版本。它的主要作用是將 testing 分支裡作出的修改暫時取消，這樣你就可以向另一個方向進行開發。

我們作些修改後再次提交：

	$ vim test.rb
	$ git commit -a -m 'made other changes'

現在我們的專案提交歷史產生了分叉（如圖 3-9 所示），因為剛才我們建立了一個分支，轉換到其中進行了一些工作，然後又回到原來的主分支進行了另外一些工作。這些改變分別孤立在不同的分支裡：我們可以在不同分支裡反覆切換，並在時機成熟時把它們合併到一起。而所有這些工作，僅僅需要 `branch` 和 `checkout` 這兩條命令就可以完成。

Insert 18333fig0309.png
圖 3-9. 不同流向的分支歷史

由於 Git 中的分支實際上僅是一個包含所指物件雜湊值（40 個字元長度 SHA-1 字串）的檔，所以建立和銷毀一個分支就變得非常廉價。說白了，新建一個分支就是向一個檔寫入 41 個位元組（外加一個分行符號）那麼簡單，當然也就很快了。

這和大多數版本控制系統形成了鮮明對比，它們管理分支大多採取備份所有專案檔案到特定目錄的方式，所以根據專案檔案數量和大小不同，可能花費的時間也會有相當大的差別，快則幾秒，慢則數分鐘。而 Git 的實現與專案複雜度無關，它永遠可以在幾毫秒的時間內完成分支的建立和切換。同時，因為每次提交時都記錄了祖先資訊（譯注：即 `parent` 物件），將來要合併分支時，尋找恰當的合併基礎（譯注：即共同祖先）的工作其實已經自然而然地擺在那裡了，所以實現起來非常容易。Git 鼓勵開發者頻繁使用分支，正是因為有著這些特性作保障。

接下來看看，我們為什麼應該頻繁使用分支。

## 分支的新增與合併 ##

現在讓我們來看一個簡單的分支與合併的例子，實際工作中大體也會用到這樣的工作流程：

1. 開發某個網站。
2. 為實現某個新的需求，建立一個分支。
3. 在這個分支上開展工作。

假設此時，你突然接到一個電話說有個很嚴重的問題需要緊急修補，那麼可以按照下面的方式處理：

1. 返回到原先已經發佈到生產伺服器上的分支。
2. 為這次緊急修補建立一個新分支，並在其中修復問題。
3. 通過測試後，回到生產伺服器所在的分支，將修補分支合併進來，然後再推送到生產伺服器上。
4. 切換到之前實現新需求的分支，繼續工作。

### 分支的新增與切換 ###

首先，我們假設你正在專案中愉快地工作，並且已經提交了幾次更新（見圖 3-10）。

Insert 18333fig0310.png
圖 3-10. 一個簡短的提交歷史

現在，你決定要修補問題追蹤系統上的 #53 問題。順帶說明下，Git 並不同任何特定的問題追蹤系統打交道。這裡為了說明要解決的問題，才把新增的分支取名為 iss53。要新建並切換到該分支，執行 `git checkout` 並加上 `-b` 參數：

	$ git checkout -b iss53
	Switched to a new branch 'iss53'

這相當於執行下面這兩條命令：

	$ git branch iss53
	$ git checkout iss53

圖 3-11 示意該命令的執行結果。

Insert 18333fig0311.png
圖 3-11. 建立了一個新分支的指標

接著你開始嘗試修復問題，在提交了若干次更新後，`iss53` 分支的指標也會隨著向前推進，因為它就是目前分支（換句話說，目前的 `HEAD` 指標正指向 `iss53`，見圖 3-12）：

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png
圖 3-12. iss53 分支隨工作進展向前推進

現在你就接到了那個網站問題的緊急電話，需要馬上修補。有了 Git ，我們就不需要同時發佈這個修補檔和 `iss53` 裡作出的修改，也不需要在建立和發佈該修補檔到伺服器之前花費大力氣來復原這些修改。唯一需要的僅僅是切換回 `master` 分支。

不過在此之前，留心你的暫存區或者工作目錄裡，那些還沒有提交的修改，它會和你即將檢出的分支產生衝突從而阻止 Git 為你切換分支。切換分支的時候最好保持一個乾淨的工作區域。稍後會介紹幾個繞過這種問題的辦法（分別叫做 stashing 和 commit amending）。目前已經提交了所有的修改，所以接下來可以正常轉換到 `master` 分支：

	$ git checkout master
	Switched to branch 'master'

此時工作目錄中的內容和你在解決問題 #53 之前一模一樣，你可以集中精力進行緊急修補。這一點值得牢記：Git 會把工作目錄的內容恢復為檢出某分支時它所指向的那個提交物件的快照。它會自動增加、刪除和修改檔以確保目錄的內容和你當時提交時完全一樣。

接下來，你得進行緊急修補。我們建立一個緊急修補分支 `hotfix` 來開展工作，直到搞定（見圖 3-13）：

	$ git checkout -b hotfix
	Switched to a new branch 'hotfix'
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix 3a0874c] fixed the broken email address
	 1 files changed, 1 deletion(-)

Insert 18333fig0313.png
圖 3-13. hotfix 分支是從 master 分支所在點分化出來的

有必要作些測試，確保修補是成功的，然後回到 `master` 分支並把它合併進來，然後發佈到生產伺服器。用 `git merge` 命令來進行合併：

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast-forward
	 README | 1 -
	 1 file changed, 1 deletion(-)

請注意，合併時出現了“Fast forward”的提示。由於目前 `master` 分支所在的提交物件是要併入的 `hotfix` 分支的直接上游，Git 只需把 `master` 分支指標直接右移。換句話說，如果順著一個分支走下去可以到達另一個分支的話，那麼 Git 在合併兩者時，只會簡單地把指標右移，因為這種單線的歷史分支不存在任何需要解決的分歧，所以這種合併過程可以稱為快進（Fast forward）。

現在最新的修改已經在目前 `master` 分支所指向的提交物件中了，可以部署到生產伺服器上去了（見圖 3-14）。

Insert 18333fig0314.png
圖 3-14. 合併之後，master 分支和 hotfix 分支指向同一位置。

在那個超級重要的修補發佈以後，你想要回到被打擾之前的工作。由於目前 `hotfix` 分支和 `master` 都指向相同的提交物件，所以 `hotfix` 已經完成了歷史使命，可以刪掉了。使用 `git branch` 的 `-d` 選項執行刪除操作：

	$ git branch -d hotfix
	Deleted branch hotfix (was 3a0874c).

現在回到之前未完成的 #53 問題修復分支上繼續工作（圖 3-15）：

	$ git checkout iss53
	Switched to branch 'iss53'
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53 ad82d7a] finished the new footer [issue 53]
	 1 file changed, 1 insertion(+)

Insert 18333fig0315.png
圖 3-15. iss53 分支可以不受影響繼續推進。

值得注意的是之前 `hotfix` 分支的修改內容尚未包含到 `iss53` 中來。如果需要納入此次修補，可以用 `git merge master` 把 master 分支合併到 `iss53`；或者等 `iss53` 完成之後，再將 `iss53` 分支中的更新併入 `master`。

### 分支的合併 ###

在問題 #53 相關的工作完成之後，可以合併回 `master` 分支。實際操作同前面合併 `hotfix` 分支差不多，只需回到 `master` 分支，執行 `git merge` 命令指定要合併進來的分支：

	$ git checkout master
	$ git merge iss53
	Auto-merging README
	Merge made by the 'recursive' strategy.
	 README | 1 +
	 1 file changed, 1 insertion(+)

請注意，這次合併操作的底層實現，並不同於之前 `hotfix` 的併入方式。因為這次你的開發歷史是從更早的地方開始分叉的。由於目前 `master` 分支所指向的提交物件（C4）並不是 `iss53` 分支的直接祖先，Git 不得不進行一些額外處理。就此例而言，Git 會用兩個分支的末端（C4 和 C5）以及它們的共同祖先（C2）進行一次簡單的三方合併計算。圖 3-16 用紅框標出了 Git 用於合併的三個提交對象：

Insert 18333fig0316.png
圖 3-16. Git 為分支合併自動識別出最佳的同源合併點。

這次，Git 沒有簡單地把分支指標右移，而是對三方合併後的結果重新做一個新的快照，並自動建立一個指向它的提交物件（C6）（見圖 3-17）。這個提交物件比較特殊，它有兩個祖先（C4 和 C5）。

值得一提的是 Git 可以自己決定哪個共同祖先才是最佳合併基礎；這和 CVS 或 Subversion（1.5 以後的版本）不同，它們需要開發者手工指定合併基礎。所以此特性讓 Git 的合併操作比其他系統都要簡單不少。

Insert 18333fig0317.png
圖 3-17. Git 自動建立了一個包含了合併結果的提交物件。

既然之前的工作成果已經合併到 `master` 了，那麼 `iss53` 也就沒用了。你可以就此刪除它，並在問題追蹤系統裡關閉該問題。

	$ git branch -d iss53

### 遇到衝突時的分支合併 ###

有時候合併操作並不會如此順利。如果在不同的分支中都修改了同一個檔的同一部分，Git 就無法乾淨地把兩者合到一起（譯注：邏輯上說，這種問題只能由人來決定。）。如果你在解決問題 #53 的過程中修改了 `hotfix` 中修改的部分，將得到類似下面的結果：

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git 作了合併，但沒有提交，它會停下來等你解決衝突。要看看哪些檔在合併時發生衝突，可以用 `git status` 查閱：

	$ git status
	On branch master
	You have unmerged paths.
	  (fix conflicts and run "git commit")
	
	Unmerged paths:
	  (use "git add <file>..." to mark resolution)
	
	        both modified:      index.html
	
	no changes added to commit (use "git add" and/or "git commit -a")

任何包含未解決衝突的檔都會以未合併（unmerged）的狀態列出。Git 會在有衝突的檔裡加入標準的衝突解決標記，可以通過它們來手工定位並解決這些衝突。可以看到此檔包含類似下面這樣的部分：

	<<<<<<< HEAD
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53

可以看到 `=======` 隔開的上半部分，是 `HEAD`（即 `master` 分支，在執行 `merge` 命令時所切換到的分支）中的內容，下半部分是在 `iss53` 分支中的內容。解決衝突的辦法無非是二者選其一或者由你親自整合到一起。比如你可以通過把這段內容替換為下面這樣來解決：

	<div id="footer">
	please contact us at email.support@github.com
	</div>

這個解決方案各採納了兩個分支中的一部分內容，而且我還刪除了 `<<<<<<<`，`=======` 和 `>>>>>>>` 這些行。在解決了所有檔裡的所有衝突後，執行 `git add` 將把它們標記為已解決狀態（譯注：實際上就是來一次快照保存到暫存區域。）。因為一旦暫存，就表示衝突已經解決。如果你想用一個有圖形介面的工具來解決這些問題，不妨執行 `git mergetool`，它會呼叫一個視覺化的合併工具並引導你解決所有衝突：

	$ git mergetool

	This message is displayed because 'merge.tool' is not configured.
	See 'git mergetool --tool-help' or 'git help config' for more details.
	'git mergetool' will now attempt to use one of the following tools:
	opendiff kdiff3 tkdiff xxdiff meld tortoisemerge gvimdiff diffuse diffmerge ecmerge p4merge araxis bc3 codecompare vimdiff emerge
	Merging:
	index.html

	Normal merge conflict for 'index.html':
	  {local}: modified file
	  {remote}: modified file
	Hit return to start merge resolution tool (opendiff):

如果不想用預設的合併工具（Git 為我預設選擇了 `opendiff`，因為我在 Mac 上執行了該命令），你可以在上方"merge tool candidates"裡找到可用的合併工具列表，輸入你想用的工具名。我們將在第七章討論怎樣改變環境中的預設值。

退出合併工具以後，Git 會詢問你合併是否成功。如果回答是，它會為你把相關檔暫存起來，以表示狀態為已解決。

再執行一次 `git status` 來確認所有衝突都已解決：

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   index.html
	

如果覺得滿意了，並且確認所有衝突都已解決，也就是進入了暫存區，就可以用 `git commit` 來完成這次合併提交。提交的記錄差不多是這樣：

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a merge.
	# If this is not correct, please remove the file
	#       .git/MERGE_HEAD
	# and try again.
	#

如果想給將來看這次合併的人一些方便，可以修改該資訊，提供更多合併細節。比如你都作了哪些改動，以及這麼做的原因。有時候決定衝突的理由並不直接或明顯，有必要略加注解。

## 分支的管理 ##

到目前為止，你已經學會了如何建立、合併和刪除分支。除此之外，我們還需要學習如何管理分支，在日後的常規工作中會經常用到下面介紹的管理命令。

`git branch` 命令不僅僅能建立和刪除分支，如果不加任何參數，它會給出目前所有分支的清單：

	$ git branch
	  iss53
	* master
	  testing

注意看 `master` 分支前的 `*` 字元：它表示目前所在的分支。也就是說，如果現在提交更新，`master` 分支將隨著開發進度前移。若要查看各個分支最後一個提交物件的資訊，執行 `git branch -v`：

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

要從該清單中篩選出你已經（或尚未）與目前分支合併的分支，可以用 `--merged` 和 `--no-merged` 選項（Git 1.5.6 以上版本）。比如用 `git branch --merged` 查看哪些分支已被併入目前分支（譯注：也就是說哪些分支是目前分支的直接上游。）：

	$ git branch --merged
	  iss53
	* master

之前我們已經合併了 `iss53`，所以在這裡會看到它。一般來說，清單中沒有 `*` 的分支通常都可以用 `git branch -d` 來刪掉。原因很簡單，既然已經把它們所包含的工作整合到了其他分支，刪掉也不會損失什麼。

另外可以用 `git branch --no-merged` 查看尚未合併的工作：

	$ git branch --no-merged
	  testing

它會顯示還未合併進來的分支。由於這些分支中還包含著尚未合併進來的工作成果，所以簡單地用 `git branch -d` 刪除該分支會提示錯誤，因為那樣做會丟失資料：

	$ git branch -d testing
	error: The branch 'testing' is not fully merged.
	If you are sure you want to delete it, run 'git branch -D testing'.

不過，如果你確實想要刪除該分支上的改動，可以用大寫的刪除選項 `-D` 強制執行，就像上面提示資訊中給出的那樣。

## 利用分支進行開發的工作流程 ##

現在我們已經學會了新建分支和合併分支，可以（或應該）用它來做點什麼呢？在本節，我們會介紹一些利用分支進行開發的工作流程。而正是由於分支管理的方便，才衍生出了這類典型的工作模式，你可以根據專案的實際情況選擇一種用用看。

### 長期分支 ###

由於 Git 使用簡單的三方合併，所以就算在較長一段時間內，反覆多次把某個分支合併到另一分支，也不是什麼難事。也就是說，你可以同時擁有多個開放的分支，每個分支用於完成特定的任務，隨著開發的推進，你可以隨時把某個特性分支的成果並到其他分支中。

許多使用 Git 的開發者都喜歡用這種方式來開展工作，比如僅在 `master` 分支中保留完全穩定的代碼，即已經發佈或即將發佈的代碼。與此同時，他們還有一個名為 `develop` 或 `next` 的平行分支，專門用於後續的開發，或僅用於穩定性測試 — 當然並不是說一定要絕對穩定，不過一旦進入某種穩定狀態，便可以把它合併到 `master` 裡。這樣，在確保這些已完成的特性分支（短期分支，比如之前的 `iss53` 分支）能夠通過所有測試，並且不會引入更多錯誤之後，就可以並到主幹分支中，等待下一次的發佈。

本質上我們剛才談論的，是隨著提交物件不斷右移的指標。穩定分支的指標總是在提交歷史中落後一大截，而前沿分支總是比較靠前（見圖 3-18）。

Insert 18333fig0318.png
圖 3-18. 穩定分支總是比較老舊。

或者把它們想像成工作流水線，或許更好理解一些，經過測試的提交物件集合被遴選到更穩定的流水線（見圖 3-19）。

Insert 18333fig0319.png
圖 3-19. 想像成流水線可能會容易點。

你可以用這招維護不同層次的穩定性。某些大專案還會有個 `proposed`（建議）或 `pu`（proposed updates，建議更新）分支，它包含著那些可能還沒有成熟到進入 `next` 或 `master` 的內容。這麼做的目的是擁有不同層次的穩定性：當這些分支進入到更穩定的水準時，再把它們合併到更高層分支中去。再次說明下，使用多個長期分支的做法並非必需，不過一般來說，對於特大型專案或特複雜的專案，這麼做確實更容易管理。

### 特性分支 ###

在任何規模的專案中都可以使用特性（Topic）分支。一個特性分支是指一個短期的，用來實現單一特性或與其相關工作的分支。可能你在以前的版本控制系統裡從未做過類似這樣的事情，因為通常建立與合併分支消耗太大。然而在 Git 中，一天之內建立、使用、合併再刪除多個分支是常見的事。

我們在上節的例子裡已經見過這種用法了。我們建立了 `iss53` 和 `hotfix` 這兩個特性分支，在提交了若干更新後，把它們合併到主幹分支，然後刪除。該技術允許你迅速且完全的進行語境切換 — 因為你的工作分散在不同的流水線裡，每個分支裡的改變都和它的目標特性相關，流覽代碼之類的事情因而變得更簡單了。你可以把作出的改變保持在特性分支中幾分鐘，幾天甚至幾個月，等它們成熟以後再合併，而不用在乎它們建立的順序或者進度。

現在我們來看一個實際的例子。請看圖 3-20，由下往上，起先我們在 `master` 工作到 C1，然後開始一個新分支 `iss91` 嘗試修復 91 號缺陷，提交到 C6 的時候，又冒出一個解決該問題的新辦法，於是從之前 C4 的地方又分出一個分支 `iss91v2`，幹到 C8 的時候，又回到主幹 `master` 中提交了 C9 和 C10，再回到 `iss91v2` 繼續工作，提交 C11，接著，又冒出個不太確定的想法，從 `master` 的最新提交 C10 處開了個新的分支 `dumbidea` 做些試驗。

Insert 18333fig0320.png
圖 3-20. 擁有多個特性分支的提交歷史。

現在，假定兩件事情：我們最終決定使用第二個解決方案，即 `iss91v2` 中的辦法；另外，我們把 `dumbidea` 分支拿給同事們看了以後，發現它竟然是個天才之作。所以接下來，我們準備放棄原來的 `iss91` 分支（實際上會丟棄 C5 和 C6），直接在主幹中併入另外兩個分支。最終的提交歷史將變成圖 3-21 這樣：

Insert 18333fig0321.png
圖 3-21. 合併了 dumbidea 和 iss91v2 後的分支歷史。

請務必牢記這些分支全部都是本地分支，這一點很重要。當你在使用分支及合併的時候，一切都是在你自己的 Git 倉庫中進行的 — 完全不涉及與伺服器的交互。

## 遠端分支 ##

遠端分支（remote branch）是對遠端倉庫中的分支的索引。它們是一些無法移動的本地分支；只有在 Git 進行網路交互時才會更新。遠端分支就像是書簽，提醒著你上次連接遠端倉庫時上面各分支的位置。 

我們用 `(遠端倉庫名)/(分支名)` 這樣的形式表示遠端分支。比如我們想看看上次同 `origin` 倉庫通訊時 `master` 分支的樣子，就應該查看 `origin/master` 分支。如果你和同伴一起修復某個問題，但他們先推送了一個 `iss53` 分支到遠端倉庫，雖然你可能也有一個本地的 `iss53` 分支，但指向伺服器上最新更新的卻應該是 `origin/iss53` 分支。

可能有點亂，我們不妨舉例說明。假設你們團隊有個地址為 `git.ourcompany.com` 的 Git 伺服器。如果你從這裡克隆，Git 會自動為你將此遠端倉庫命名為 `origin`，並下載其中所有的資料，建立一個指向它的 `master` 分支的指標，在本地命名為 `origin/master`，但你無法在本地更改其資料。接著，Git 建立一個屬於你自己的本地 `master` 分支，始於 `origin` 上 `master` 分支相同的位置，你可以就此開始工作（見圖 3-22）：

Insert 18333fig0322.png
圖 3-22. 一次 Git 克隆會建立你自己的本地分支 master 和遠端分支 origin/master，並且將它們都指向 `origin` 上的 `master` 分支。

如果你在本地 `master` 分支做了些改動，與此同時，其他人向 `git.ourcompany.com` 推送了他們的更新，那麼伺服器上的 `master` 分支就會向前推進，而於此同時，你在本地的提交歷史正朝向不同方向發展。不過只要你不和伺服器通訊，你的 `origin/master` 指標仍然保持原位不會移動（見圖 3-23）。

Insert 18333fig0323.png
圖 3-23. 在本地工作的同時有人向遠端倉庫推送內容會讓提交歷史開始分流。

可以執行 `git fetch origin` 來同步遠端伺服器上的資料到本地。該命令首先找到 `origin` 是哪個伺服器（本例為 `git.ourcompany.com`），從上面取得你尚未擁有的資料，更新你本地的資料庫，然後把 `origin/master` 的指針移到它最新的位置上（見圖 3-24）。

Insert 18333fig0324.png
圖 3-24. git fetch 命令會更新 remote 索引。

為了演示擁有多個遠端分支（在不同的遠端伺服器上）的專案是如何工作的，我們假設你還有另一個僅供你的敏捷開發小組使用的內部伺服器 `git.team1.ourcompany.com`。可以用第二章中提到的 `git remote add` 命令把它加為目前專案的遠端分支之一。我們把它命名為 `teamone`，以便代替完整的 Git URL 以方便使用（見圖 3-25）。

Insert 18333fig0325.png
圖 3-25. 把另一個伺服器加為遠端倉庫

現在你可以用 `git fetch teamone` 來取得小組伺服器上你還沒有的資料了。由於目前該伺服器上的內容是你 `origin` 伺服器上的子集，Git 不會下載任何資料，而只是簡單地建立一個名為 `teamone/master` 的遠端分支，指向 `teamone` 伺服器上 `master` 分支所在的提交物件 `31b8e`（見圖 3-26）。

Insert 18333fig0326.png
圖 3-26. 你在本地有了一個指向 teamone 伺服器上 master 分支的索引。

### 推送本地分支 ###

要想和其他人分享某個本地分支，你需要把它推送到一個你擁有寫許可權的遠端倉庫。你建立的本地分支不會因為你的寫入操作而被自動同步到你引入的遠端伺服器上，你需要明確地執行推送分支的操作。換句話說，對於無意分享的分支，你儘管保留為私人分支好了，而只推送那些協同工作要用到的特性分支。

如果你有個叫 `serverfix` 的分支需要和他人一起開發，可以執行 `git push (遠端倉庫名) (分支名)`：

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

這裡其實走了一點捷徑。Git 自動把 `serverfix` 分支名擴展為 `refs/heads/serverfix:refs/heads/serverfix`，意為“取出我在本地的 serverfix 分支，推送到遠端倉庫的 serverfix 分支中去”。我們將在第九章進一步介紹 `refs/heads/` 部分的細節，不過一般使用的時候都可以省略它。也可以執行 `git push origin serverfix:serverfix` 來實現相同的效果，它的意思是“上傳我本地的 serverfix 分支到遠端倉庫中去，仍舊稱它為 serverfix 分支”。通過此語法，你可以把本地分支推送到某個命名不同的遠端分支：若想把遠端分支叫作 `awesomebranch`，可以用 `git push origin serverfix:awesomebranch` 來推送數據。

接下來，當你的協作者再次從伺服器上取得資料時，他們將得到一個新的遠端分支 `origin/serverfix`，並指向伺服器上 `serverfix` 所指向的版本：

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

值得注意的是，在 `fetch` 操作下載好新的遠端分支之後，你仍然無法在本地編輯該遠端倉庫中的分支。換句話說，在本例中，你不會有一個新的 `serverfix` 分支，有的只是一個你無法移動的 `origin/serverfix` 指標。

如果要把該遠端分支的內容合併到目前分支，可以執行 `git merge origin/serverfix`。如果想要一份自己的 `serverfix` 來開發，可以在遠端分支的基礎上分化出一個新的分支來：

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

這會切換到新增的 `serverfix` 本地分支，其內容同遠端分支 `origin/serverfix` 一致，這樣你就可以在裡面繼續開發了。

### 跟蹤遠端分支 ###

從遠端分支 `checkout` 出來的本地分支，稱為 _追蹤分支_ (tracking branch)。追蹤分支是一種和某個遠端分支有直接聯繫的本地分支。在追蹤分支裡輸入 `git push`，Git 會自行推斷應該向哪個伺服器的哪個分支推送資料。同樣，在這些分支裡執行 `git pull` 會取得所有遠端索引，並把它們的資料都合併到本地分支中來。

在克隆倉庫時，Git 通常會自動建立一個名為 `master` 的分支來跟蹤 `origin/master`。這正是 `git push` 和 `git pull` 一開始就能正常工作的原因。當然，你可以隨心所欲地設定為其它追蹤分支，比如 `origin` 上除了 `master` 之外的其它分支。剛才我們已經看到了這樣的一個例子：`git checkout -b [分支名] [遠端名]/[分支名]`。如果你有 1.6.2 以上版本的 Git，還可以用 `--track` 選項簡化：

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

要為本地分支設定不同于遠端分支的名字，只需在第一個版本的命令裡換個名字：

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch serverfix from origin.
	Switched to a new branch 'sf'

現在你的本地分支 `sf` 會自動將推送和抓取資料的位置定位到 `origin/serverfix` 了。

### 刪除遠端分支 ###

如果不再需要某個遠端分支了，比如搞定了某個特性並把它合併進了遠端的 `master` 分支（或任何其他存放穩定代碼的分支），可以用這個非常無厘頭的語法來刪除它：`git push [遠端名] :[分支名]`。如果想在伺服器上刪除 `serverfix` 分支，執行下面的命令：

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

咚！伺服器上的分支沒了。你最好特別留心這一頁，因為你一定會用到那個命令，而且你很可能會忘掉它的語法。有種方便記憶這條命令的方法：記住我們不久前見過的 `git push [遠端名] [本地分支]:[遠端分支]` 語法，如果省略 `[本地分支]`，那就等於是在說“在這裡提取空白然後把它變成`[遠端分支]`”。

## 分支的衍合 ##

把一個分支中的修改整合到另一個分支的辦法有兩種：`merge` 和 `rebase`（譯注：`rebase` 的翻譯暫定為“衍合”，大家知道就可以了。）。在本章我們會學習什麼是衍合，如何使用衍合，為什麼衍合操作如此富有魅力，以及我們應該在什麼情況下使用衍合。

### 基本的衍合操作 ###

請回顧之前有關合併的一節（見圖 3-27），你會看到開發行程分叉到兩個不同分支，又各自提交了更新。

Insert 18333fig0327.png
圖 3-27. 最初分叉的提交歷史。

之前介紹過，最容易的整合分支的方法是 `merge` 命令，它會把兩個分支最新的快照（C3 和 C4）以及二者最新的共同祖先（C2）進行三方合併，合併的結果是產生一個新的提交物件（C5）。如圖 3-28 所示：

Insert 18333fig0328.png
圖 3-28. 通過合併一個分支來整合分叉了的歷史。

其實，還有另外一個選擇：你可以把在 C3 裡產生的變化修補檔在 C4 的基礎上重新打一遍。在 Git 裡，這種操作叫做_衍合（rebase）_。有了 `rebase` 命令，就可以把在一個分支裡提交的改變移到另一個分支裡重放一遍。

在上面這個例子中，執行：

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

它的原理是回到兩個分支最近的共同祖先，根據目前分支（也就是要進行衍合的分支 `experiment`）後續的歷次提交物件（這裡只有一個 C3），生成一系列檔修補檔，然後以基底分支（也就是主幹分支 `master`）最後一個提交物件（C4）為新的出發點，逐個應用之前準備好的修補檔檔，最後會生成一個新的合併提交物件（C3'），從而改寫 `experiment` 的提交歷史，使它成為 `master` 分支的直接下游，如圖 3-29 所示：

Insert 18333fig0329.png
圖 3-29. 把 C3 裡產生的改變到 C4 上重演一遍。

現在回到 `master` 分支，進行一次快進合併（見圖 3-30）：

Insert 18333fig0330.png
圖 3-30. master 分支的快進。

現在的 C3' 對應的快照，其實和普通的三方合併，即上個例子中的 C5 對應的快照內容一模一樣了。雖然最後整合得到的結果沒有任何區別，但衍合能產生一個更為整潔的提交歷史。如果視察一個衍合過的分支的歷史記錄，看起來會更清楚：仿佛所有修改都是在一根線上先後進行的，儘管實際上它們原本是同時並行發生的。

一般我們使用衍合的目的，是想要得到一個能在遠端分支上乾淨應用的修補檔 — 比如某些專案你不是維護者，但想幫點忙的話，最好用衍合：先在自己的一個分支裡進行開發，當準備向主專案提交修補檔的時候，根據最新的 `origin/master` 進行一次衍合操作然後再提交，這樣維護者就不需要做任何整合工作（譯注：實際上是把解決分支修補檔同最新主幹代碼之間衝突的責任，化轉為由提交修補檔的人來解決。），只需根據你提供的倉庫位址作一次快進合併，或者直接採納你提交的修補檔。

請注意，合併結果中最後一次提交所指向的快照，無論是通過衍合，還是三方合併，都會得到相同的快照內容，只不過提交歷史不同罷了。衍合是按照每行的修改次序重演一遍修改，而合併是把最終結果合在一起。

### 有趣的衍合 ###

衍合也可以放到其他分支進行，並不一定非得根據分化之前的分支。以圖 3-31 的歷史為例，我們為了給伺服器端代碼增加一些功能而建立了特性分支 `server`，然後提交 C3 和 C4。然後又從 C3 的地方再增加一個 `client` 分支來對用戶端代碼進行一些相應修改，所以提交了 C8 和 C9。最後，又回到 `server` 分支提交了 C10。

Insert 18333fig0331.png
圖 3-31. 從一個特性分支裡再分出一個特性分支的歷史。

假設在接下來的一次軟體發佈中，我們決定先把用戶端的修改並到主線中，而暫緩併入服務端軟體的修改（因為還需要進一步測試）。這個時候，我們就可以把基於 `server` 分支而非 `master` 分支的改變（即 C8 和 C9），跳過 `server` 直接放到 `master` 分支中重演一遍，但這需要用 `git rebase` 的 `--onto` 選項指定新的基底分支 `master`：

	$ git rebase --onto master server client

這好比在說：“取出 `client` 分支，找出 `client` 分支和 `server` 分支的共同祖先之後的變化，然後把它們在 `master` 上重演一遍”。是不是有點複雜？不過它的結果如圖 3-32 所示，非常酷（譯注：雖然 `client` 裡的 C8, C9 在 C3 之後，但這僅表示時間上的先後，而非在 C3 修改的基礎上進一步改動，因為 `server` 和 `client` 這兩個分支對應的代碼應該是兩套檔，雖然這麼說不是很嚴格，但應理解為在 C3 時間點之後，對另外的檔所做的 C8，C9 修改，放到主幹重演。）：

Insert 18333fig0332.png
圖 3-32. 將特性分支上的另一個特性分支衍合到其他分支。

現在可以快進 `master` 分支了（見圖 3-33）：

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
圖 3-33. 快進 master 分支，使之包含 client 分支的變化。

現在我們決定把 `server` 分支的變化也包含進來。我們可以直接把 `server` 分支衍合到 `master`，而不用手工切換到 `server` 分支後再執行衍合操作 — `git rebase [主分支] [特性分支]` 命令會先取出特性分支 `server`，然後在主分支 `master` 上重演：

	$ git rebase master server

於是，`server` 的進度套用到 `master` 的基礎上，如圖 3-34 所示：

Insert 18333fig0334.png
圖 3-34. 在 master 分支上衍合 server 分支。

然後就可以快進主幹分支 `master` 了：

	$ git checkout master
	$ git merge server

現在 `client` 和 `server` 分支的變化都已經整合到主幹分支來了，可以刪掉它們了。最終我們的提交歷史會變成圖 3-35 的樣子：

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
圖 3-35. 最終的提交歷史

### 衍合的風險 ###

呃，奇妙的衍合也並非完美無缺，要用它得遵守一條準則：

**一旦分支中的提交物件發佈到公開倉庫，就千萬不要對該分支進行衍合操作。**

如果你遵循這條金科玉律，就不會出差錯。否則，人民群眾會仇恨你，你的朋友和家人也會嘲笑你，唾棄你。

在進行衍合的時候，實際上放棄了一些現存的提交物件而創造了一些類似但不同的新的提交物件。如果你把原來分支中的提交物件發佈出去，並且其他人更新下載後在其基礎上開展工作，而稍後你又用 `git rebase` 放棄這些提交物件，把新的重演後的提交物件發佈出去的話，你的合作者就不得不重新合併他們的工作，這樣當你再次從他們那裡取得內容時，提交歷史就會變得一團糟。

下面我們用一個實際例子來說明為什麼公開的衍合會帶來問題。假設你從一個中央伺服器克隆然後在它的基礎上搞了一些開發，提交歷史類似圖 3-36 所示：

Insert 18333fig0336.png
圖 3-36. 克隆一個倉庫，在其基礎上工作一番。

現在，某人在 C1 的基礎上做了些改變，並合併他自己的分支得到結果 C6，推送到中央伺服器。當你抓取並合併這些資料到你本地的開發分支中後，會得到合併結果 C7，歷史提交會變成圖 3-37 這樣：

Insert 18333fig0337.png
圖 3-37. 抓取他人提交，併入自己主幹。

接下來，那個推送 C6 上來的人決定用衍合取代之前的合併操作；繼而又用 `git push --force` 覆蓋了伺服器上的歷史，得到 C4'。而之後當你再從伺服器上下載最新提交後，會得到：

Insert 18333fig0338.png
圖 3-38. 有人推送了衍合後得到的 C4'，丟棄了你作為開發基礎的 C4 和 C6。

下載更新後需要合併，但此時衍合產生的提交物件 C4' 的 SHA-1 校驗值和之前 C4 完全不同，所以 Git 會把它們當作新的提交物件處理，而實際上此刻你的提交歷史 C7 中早已經包含了 C4 的修改內容，於是合併操作會把 C7 和 C4' 合併為 C8（見圖 3-39）:

Insert 18333fig0339.png
圖 3-39. 你把相同的內容又合併了一遍，生成一個新的提交 C8。

C8 這一步的合併是遲早會發生的，因為只有這樣你才能和其他協作者提交的內容保持同步。而在 C8 之後，你的提交歷史裡就會同時包含 C4 和 C4'，兩者有著不同的 SHA-1 校驗值，如果用 `git log` 查看歷史，會看到兩個提交擁有相同的作者日期與說明，令人費解。而更糟的是，當你把這樣的歷史推送到伺服器後，會再次把這些衍合後的提交引入到中央伺服器，進一步困擾其他人（譯注：這個例子中，出問題的責任方是那個發佈了 C6 後又用衍合發佈 C4' 的人，其他人會因此回饋雙重歷史到共用主幹，從而混淆大家的視聽。）。

如果把衍合當成一種在推送之前清理提交歷史的手段，而且僅僅衍合那些尚未公開的提交物件，就沒問題。如果衍合那些已經公開的提交物件，並且已經有人基於這些提交物件開展了後續開發工作的話，就會出現叫人沮喪的麻煩。

## 小結 ##

讀到這裡，你應該已經學會了如何建立分支並切換到新分支，在不同分支間轉換，合併本地分支，把分支推送到共用伺服器上，使用共用分支與他人協作，以及在分享之前進行衍合。
