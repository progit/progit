# Git 客製化 #

到目前為止，我闡述了 Git 基本的運作機制和使用方式，介紹了 Git 提供的許多工具來幫助你簡單且有效地使用它。在本章，我將會介紹 Git 的一些重要的組態設定(configuration)和鉤子(hooks)機制以滿足自訂的要求。通過這些工具，它能夠更容易地使 Git 按照你、你的公司或團隊所需要的方式去運作。 

## Git 設定 ##

如第一章所言，用 `git config` 設定 Git，要做的第一件事就是設定名字和電子郵件信箱：

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

從現在開始，你會瞭解到一些類似以上但更為有趣的設定選項來自訂 Git。 

先過一遍第一章中提到的 Git 設定細節。Git 使用一系列的設定檔來保存你定義的偏好，它首先會查找 `/etc/gitconfig` 檔，該檔所含的設定值對系統上所有使用者都有效，也對他們所擁有的倉庫都有效（譯注：gitconfig 是全域設定檔）， 如果傳遞 `--system` 選項給 `git config` 命令， Git 會讀寫這個檔案。 

接下來 Git 會尋找每個用戶的 `~/.gitconfig` 檔，它是針對個別使用者的，你可以傳遞 `--global` 選項讓 Git 讀寫該檔。 

最後，Git 會尋找你目前使用中的倉庫 Git 目錄下的設定檔（`.git/config`），該文件中的設定值只對這個倉庫有效。以上闡述的三層設定從一般到特殊層層推進，如果定義的值有衝突，後面層級的設定會面寫前面層級的設定值，例如：在 `.git/config` 和 `/etc/gitconfig` 的較量中， `.git/config` 取得了勝利。雖然你也可以直接手動編輯這些設定檔，但是執行 git config 命令將會來得簡單些。

### 用戶端基本設定 ###

Git 能夠識別的設定項被分為了兩大類：用戶端和伺服器端，其中大部分屬於用戶端設定，這是基於你個人工作偏好所做的設定。儘管有數不盡的選項，但我只闡述其中經常使用、或者會對你的工作流程產生巨大影響的選項。許多選項只在極端的情況下有用，這裏就不多做介紹了。如果你想觀察你的 Git 版本能識別的選項清單，請執行 

	$ git config --help

`git config` 的手冊頁（譯注：以 man 命令的顯示方式）非常細緻地羅列了所有可用的設定項。 

#### core.editor ####

預設情況下，Git 會使用你所設定的「預設文字編輯器」，否則會使用 Vi 來建立和編輯提交以及標籤資訊，你可以使用 `core.editor` 改變預設編輯器： 

	$ git config --global core.editor emacs

現在無論你的環境變數 editor 被定義成什麼，Git 都會觸發 Emacs 來編輯相關訊息。 

#### commit.template ####

如果把這個專案指定為你系統上的一個檔案，當你提交的時候，Git 會預設使用該檔定義的內容做為預設的提交訊息。例如：你建立了一個範本檔 `$HOME/.gitmessage.txt`，它看起來像這樣： 

	subject line

	what happened

	[ticket: X]

如下設定 `commit.template` 可以告訴 Git，把上列內容做為預設訊息，當你執行 `git commit` 的時候，在你的編輯器中顯示： 

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

然後當你提交時，在編輯器中顯示的提交資訊如下： 

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

如果你對於提交訊息有特定的政策，那就在系統上建立一個範本檔，設定 Git 使用它做為預設值，這樣可以幫助提升你的政策經常被遵守的機會。 

#### core.pager ####

core.pager 指定 Git 執行諸如 log、diff 等命令時所使用的分頁器，你可以設成用 `more` 或者任何你喜歡的分頁器（預設用的是 `less`）， 當然你也可以不用分頁器，只要把它設成空字串： 

	$ git config --global core.pager ''

這樣不管命令的輸出量多少，都會在一頁顯示所有內容。 

#### user.signingkey ####

如果你要建立經簽署的含附注的標籤(signed annotated tags)（正如第二章所述），那麼把你的 GPG 簽署金鑰設為設定項會更好，設定金鑰 ID 如下： 

	$ git config --global user.signingkey <gpg-key-id>

現在你能夠簽署標籤，從而不必每次執行 `git tag` 命令時定義金鑰： 

	$ git tag -s <tag-name>

#### core.excludesfile ####

正如第二章所述，你能在專案倉庫的 `.gitignore` 檔裡頭用模式(pattern)來定義那些無需納入 Git 管理的檔案，這樣它們不會出現在未追蹤列表，也不會在你執行 `git add` 後被暫存。然而，如果你想用專案倉庫之外的檔案來定義那些需被忽略的檔的話，可以用 `core.excludesfile` 來通知 Git 該檔所在的位置，檔案內容則和 .gitignore 類似。 

#### help.autocorrect ####

這個選置項只在 Git 1.6.1 以上(含)版本有效，假如你在 Git 1.6 中錯打了一條命令，它會像這樣顯示： 

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

如果你把 help.autocorrect 設定成1（譯注：啟動自動修正），那麼在只有一個命令符合的情況下，Git 會自動執行該命令。 

### Git 中的著色 ###

Git 能夠為輸出到你終端(terminal)的內容著色，以便你可以憑直觀進行快速、簡單地分析，有許多選項能幫你將顏色調成你喜好的。

#### color.ui ####

Git 會按照你的需要，自動為大部分的輸出加上顏色。你能明確地規定哪些需要著色、以及怎樣著色，設定 color.ui 為 true 來打開所有的預設終端著色：

	$ git config --global color.ui true

設定好以後，當輸出到終端時，Git 會為之加上顏色。其他的參數還有 false 和 always，false 意味著不為輸出著色，而 always 則表示在任何情況下都要著色 -- 即使 Git 命令被重定向到文件或 pipe 到另一個命令。Git 1.5.5 版本引進了此項設定，如果你的版本更舊，你必須對顏色有關選項各自進行詳細地設定。 

你會很少用到 `color.ui = always`，在大多數情況下，如果你想在被重定向的輸出中插入顏色碼，你可以傳遞 `--color` 旗標給 Git 命令來迫使它這麼做，`color.ui = true` 應該是你的首選。 

#### `color.*` ####

想要具體指定哪些命令輸出需要被著色，以及怎樣著色，或者 Git 的版本很舊，你就要用到和具體命令有關的顏色設定選項，它們都能被設為 true、false 或 always： 

	color.branch
	color.diff
	color.interactive
	color.status

除此之外，以上每個選項都有子選項，可以被用來覆蓋其父設定，以達到為輸出的各個部分著色的目的。例如，要讓 diff 輸出的改變資訊 (meta information) 以粗體、藍色前景和黑色背景的形式顯示，你可以執行： 

	$ git config --global color.diff.meta "blue black bold"

你能設定的顏色值如下：normal、black、red、green、yellow、blue、magenta、cyan、white。正如以上例子設定的粗體屬性，想要設定字體屬性的話，你的選擇有：bold、dim、ul、blink、reverse。 

如果你想設定子選項的話，可以參考 git config 幫助頁。 

### 外部的合併與比較工具 ###

雖然 Git 自己實做了 diff，而且到目前為止你一直在使用它，但你能夠設定一個外部的工具來替代它。你還可以設定用一個圖形化的工具來合併和解決衝突，而不必自己手動解決。有一個不錯且免費的工具可以被用來做比較和合併工作，它就是 P4Merge（譯注：Perforce 圖形化合併工具），我會示範它的安裝過程。 

所以如果你想試試看的話，因為 P4Merge 可以在所有主流平臺上執行，所以你應該可以嘗試看看。對於向你示範的例子，在 Mac 和 Linux 系統上，我會使用路徑名；在 Windows 上，`/usr/local/bin` 應該被改為你環境中的可執行路徑。 

你可以在這裏下載 P4Merge： 

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

首先，你要設定一個外部包裝腳本(external wrapper scripts)來執行你要的命令，我會使用 Mac 系統上的路徑來指定該腳本的位置；在其他系統上，它應該被放置在二進位檔案 `p4merge` 所在的目錄中。建立一個 merge 包裝腳本，名字叫作 `extMerge`，讓它附帶所有參數呼叫 p4merge 二進位檔案： 

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

diff 包裝腳本首先確定傳遞過來7個參數，隨後把其中2個傳遞給你的 merge 包裝腳本，預設情況下，Git 會傳遞以下參數給 diff： 

	path old-file old-hex old-mode new-file new-hex new-mode

由於你僅僅需要 `old-file` 和 `new-file` 參數，用 diff 包裝腳本來傳遞它們吧。 

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

你還需要確認一下這兩個腳本是可執行的： 

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

現在來設定使用你自訂的比較和合併工具吧。這需要許多自訂設定：`merge.tool` 通知 Git 使用哪個合併工具；`mergetool.*.cmd` 規定命令如何執行；`mergetool.trustExitCode` 會通知 Git 該程式的退出碼(exit code)是否指示合併操作成功；`diff.external` 通知 Git 用什麼命令做比較。因此，你可以執行以下4條設定命令： 

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

或者直接編輯 `~/.gitconfig` 檔案如下： 

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	  trustExitCode = false
	[diff]
	  external = extDiff

設定完畢後，如果你像這樣執行 diff 命令： 

	$ git diff 32d1776b1^ 32d1776b1

不同於在命令列得到 diff 命令的輸出，Git 觸發了剛剛設定的 P4Merge，它看起來像圖7-1這樣： 

Insert 18333fig0701.png
Figure 7-1. P4Merge.

當你設法合併兩個分支，結果卻有衝突時，執行 `git mergetool`，Git 會啟用 P4Merge 讓你通過圖形介面來解決衝突。 

設定包裝腳本的好處是你能簡單地改變 diff 和 merge 工具，例如把 `extDiff` 和 `extMerge` 改成 KDiff3，要做的僅僅是編輯 `extMerge` 指令檔： 

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

現在 Git 會使用 KDiff3 來做比較、合併和解決衝突。 

Git 預先設定了許多其他的合併和解決衝突的工具，而你不必設定 cmd。可以把合併工具設定為：kdiff3、opendiff、tkdiff、meld、xxdiff、emerge、vimdiff、gvimdiff。如果你不想用 KDiff3 來做 diff，只是想用它來合併，而且 kdiff3 命令也在你的路徑裏，那麼你可以執行： 

	$ git config --global merge.tool kdiff3

如果執行了以上命令，沒有設定 `extMerge` 和 `extDiff` 檔，Git 會用 KDiff3 做合併，讓平常內建的比較工具來做比較。 

### 格式化與空格 ###

格式化與空格是許多開發人員在協同工作時，特別是在跨平臺情況下，遇到的令人頭疼的細小問題。在一些大家合作的工作或提交的修補檔中，很容易因為編輯器安靜無聲地加入一些小空格，或者 Windows 程式師在跨平臺專案中的檔案行尾加入了Enter分行符號(carriage return)。Git 的一些設定選項可以幫助解決這些問題。 

#### core.autocrlf ####

如果你在 Windows 上寫程式，或者你不是用 Windows，但和其他在 Windows 上寫程式的人合作，在這些情況下，你可能會遇到換行符號的問題。這是因為 Windows 使用Enter(carriage-return)和換行(linefeed)兩個字元來結束一行，而 Mac 和 Linux 只使用一個換行字元。雖然這是小問題，但它會極大地擾亂跨平臺協作。 

Git 可以在你提交時自動地把換行符號 CRLF 轉換成 LF，而在簽出代碼時把 LF 轉換成 CRLF。用 `core.autocrlf` 來打開此項功能，如果是在Windows 系統上，把它設定成 `true`，這樣當 check out 程式的時候，LF 會被轉換成 CRLF： 

	$ git config --global core.autocrlf true

Linux 或 Mac 系統使用 LF 作為行結束符，因此你不希望 Git 在 check out 檔案時進行自動的轉換；但是，當一個以 CRLF 做為換行符號的檔案不小心被引入時，你肯定希望 Git 可以修正它。你可以把 `core.autocrlf` 設定成 input 來告訴 Git 在提交時把 CRLF 轉換成 LF，check out 時不轉換： 

	$ git config --global core.autocrlf input

這樣會在 Windows 系統上的 check out 檔案中保留 CRLF，而在 Mac 和 Linux 系統上，以及倉庫中保留 LF。 

如果你是 Windows 程式師，且正在開發僅執行在 Windows 上的專案，可以設定 `false` 取消此功能，把 carriage returns 記錄在倉庫中： 

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git 預先設定了一些選項來探測和修正空格問題，其中有四個主要選項，有2個預設開啟，2個預設關閉，你可以自由地打開或關閉它們。 

預設開啟的2個選項是：`trailing-space` 會查找每行結尾的空格，`space-before-tab` 會查找每行開頭的定位字元前的空格。 

預設關閉的2個選項是：`indent-with-non-tab` 會查找8個以上空格（非定位字元）開頭的行，`cr-at-eol` 告訴 Git carriage returns 是合法的。 

設定 `core.whitespace`，按照你的需要來打開或關閉選項，設定值之間以逗號分隔。從設定字串裏把設定值去掉，就可以關閉這個設定，或是在設定值前面加上減號 `-` 也可以。例如，如果你想要打開除了 cr-at-eol 之外的所有選項，你可以這麼做： 

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

當你執行 `git diff` 命令且為輸出著色時，Git 會偵測這些問題，因此你有可能在提交前修復它們。當你用 `git apply` 打修補檔時，它也同樣會使用這些設定值來幫助你。你可以要 Git 警告你，如果正準備運用的修補檔有特別的空白問題： 

	$ git apply --whitespace=warn <patch>

或者讓 Git 在打上修補檔嘗試自動修正此問題：

	$ git apply --whitespace=fix <patch>

這些選項也能運用於衍合。如果提交了有空格問題的檔但還沒推送到上游，你可以執行帶有 `--whitespace=fix` 選項的 `rebase` 來讓 Git 在重寫修補檔時自動修正它們。

### 伺服器端設定 ###

Git 伺服器端的設定選項並不多，但仍有一些有趣的選項值得你一看。

#### receive.fsckObjects ####

Git 預設情況下不會在推送期間檢查所有物件的一致性。Git 雖然會檢查確認每個物件仍然符合它的 SHA-1 checksum，所指向的物件也都是有效的，但是預設 Git 不會在每次推送時都做這種檢查。對於 Git 來說，倉庫或推送的檔越大，這個操作代價就相對越高，每次推送會消耗更多時間。如果想讓 Git 在每次推送時都檢查物件一致性，可以設定 `receive.fsckObjects` 為 true 來強迫它這麼做： 

	$ git config --system receive.fsckObjects true

現在 Git 會在每次推送被接受前檢查庫的完整性，確保有問題的用戶端沒有引入破壞性的資料。 

#### receive.denyNonFastForwards ####

如果對已經被推送的提交歷史做衍合，繼而再推送；或是要將某個提交推送到遠端分支，而該提交歷史未包含這個遠端分支目前指向的 commit，這樣的推送會被拒絕。這通常是個很好的禁止策略，但有時你在做衍合的時候，你可能很確定自己在做什麼，那就可以在 push 命令後加 `-f` 旗標來強制更新遠端分支。

要禁用這樣的強制更新遠端分支 non-fast-forward references 的功能，可以如下設定 `receive.denyNonFastForwards`： 

	$ git config --system receive.denyNonFastForwards true

稍後你會看到，用伺服器端的 receive hooks 也能達到同樣的目的。這個方法可以做更細緻的控制，例如：拒絕某些特定的使用者強制更新 non-fast-forwards。 

#### receive.denyDeletes ####

避開 `denyNonFastForwards` 策略的方法之一就是使用者刪除分支，然後推回新的引用(reference)。在更新的 Git 版本中（從1.6.1版本開始），你可以把 receive.denyDeletes 設定為 true： 

	$ git config --system receive.denyDeletes true

這樣會在推送過程中阻止刪除分支和標籤 — 沒有使用者能夠這麼做。要刪除遠端分支，必須從伺服器手動刪除引用檔(ref files)。通過用戶存取控制清單也能這麼做，在本章結尾將會介紹這些有趣的方式。 

## Git 屬性 ##

一些設定值(settings)也能指定到特定的路徑，這樣，Git 只對這個特定的子目錄或某些檔案應用這些設定值。這些針對特定路徑的設定值被稱為 Git 屬性(attributes)，可以在你目錄中的 `.gitattributes` 檔內進行設定（通常是你專案的根目錄），當你不想讓這些屬性檔和專案檔案一同提交時，也可以在 `.git/info/attributes` 檔進行設定。 

使用屬性，你可以對個別檔案或目錄定義不同的合併策略，讓 Git 知道怎樣比較非文字檔，在你提交或簽出(check out)前讓 Git 過濾內容。你將在這個章節裏瞭解到能在自己的專案中使用的屬性，以及一些實例。 

### 二進位檔案 ###

你可以用 Git 屬性讓其知道哪些是二進位檔案（以防 Git 沒有識別出來），以及指示怎樣處理這些檔案，這點很酷。例如，一些文字檔是由機器產生的，而且無法比較，而一些二進位檔案可以比較 — 你將會瞭解到怎樣讓 Git 識別這些檔。 

#### 識別二進位檔案 ####

某些檔案看起來像是文字檔，但其實是看做為二進位資料。例如，在 Mac 上的 Xcode 專案含有一個以 `.pbxproj` 結尾的檔，它是由記錄設定項的 IDE 寫到磁碟的 JSON 資料集（純文字 javascript 資料類型）。雖然技術上看它是由 ASCII 字元組成的文字檔，但是你並不想這麼看它，因為它確實是一個輕量級資料庫 — 如果有兩個人改變了它，你沒辦法合併它們，diff 通常也幫不上忙，只有機器才能進行識別和操作，於是，你想把它當成二進位檔案。 

讓 Git 把所有 `pbxproj` 檔當成二進位檔案，在 `.gitattributes` 文件中加上下面這行： 

	*.pbxproj -crlf -diff

現在，Git 不會嘗試轉換和修正 CRLF（Enter換行）問題；也不會當你在專案中執行 git show 或 git diff 時，嘗試比較不同的內容。在 Git 1.6 及之後的版本中，可以用一個巨集代替 `-crlf -diff`： 

	*.pbxproj binary

#### Diffing Binary Files ####

在 Git 1.6 及以上版本中，你能利用 Git 屬性來有效地比較二進位檔案。可以設定 Git 把二進位資料轉換成文本格式，然後用一般 diff 來做比較。 

##### MS Word files #####

這個特性很酷，而且鮮為人知，因此我會結合實例來講解。首先，你將使用這項技術來解決最令人頭疼的問題之一：對 Word 文檔進行版本控制。每個人都知道 Word 是最可怕的編輯器，奇怪的是，每個人都在使用它。如果想對 Word 文件進行版本控制，你可以把檔案加入到 Git 倉庫中，每次修改後提交即可。但這樣做有什麼好處？如果你像平常一樣執行 `git diff` 命令，你只能得到如下的結果： 

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

你不能直接比較兩個 Word 文件版本，除非人工細看，對吧？Git 屬性能很好地解決此問題，把下面這行加到 `.gitattributes` 文件： 

	*.doc diff=word

當你要看比較結果時，如果檔副檔名是 ”doc”，Git 會使用 ”word” 篩檢程式(filter)。什麼是 ”word” 篩檢程式呢？你必須設定它。下面你將設定 Git 使用 `strings` 程式，把 Word 文檔轉換成可讀的文字檔，之後再進行比較： 

	$ git config diff.word.textconv catdoc

This command adds a section to your `.git/config` that looks like this:

	[diff "word"]
		textconv = catdoc

現在 Git 知道了，如果它要在在兩個快照之間做比較，而其中任何一個檔檔名是以 `.doc` 結尾，它應該要對這些檔執行 ”word” 篩檢程式，也就是定義為執行 `strings` 程式。這樣就可以在比較前把 Word 檔轉換成文字檔。 

下面示範了一個實例，我把此書的第一章納入 Git 管理，在一個段落中加入了一些文字後保存，之後執行 `git diff` 命令，得到結果如下： 

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

Git 成功且簡潔地顯示出我增加的文字 ”(See Chapter 3)”。雖然有些瑕疵 -- 在末尾顯示了一些隨機的內容 -- 但確實可以比較了。如果你能找到或自己寫個 Word 到純文字的轉換器的話，效果可能會更好。不過因為 `strings` 可以在大部分 Mac 和 Linux 系統上執行，所以在初次嘗試對各種二進位格式檔進行類似的處理，它是個不錯的選擇。 

##### OpenDocument Text files #####

The same approach that we used for MS Word files (`*.doc`) can be used for OpenDocument Text files (`*.odt`) created by OpenOffice.org.

Add the following line to your `.gitattributes` file:

	*.odt diff=odt

Now set up the `odt` diff filter in `.git/config`:

	[diff "odt"]
		binary = true
		textconv = /usr/local/bin/odt-to-txt

OpenDocument files are actually zip’ped directories containing multiple files (the content in an XML format, stylesheets, images, etc.). We’ll need to write a script to extract the content and return it as plain text. Create a file `/usr/local/bin/odt-to-txt` (you are free to put it into a different directory) with the following content:

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

And make it executable

	chmod +x /usr/local/bin/odt-to-txt

Now `git diff` will be able to tell you what changed in `.odt` files.


##### Image files #####

你還能用這個方法解決另一個有趣的問題：比較影像檔。方法之一是對 JPEG 檔執行一個篩檢程式，把 EXIF 資訊捉取出來 — EXIF 資訊是記錄在大部分圖像格式裏面的 metadata。如果你下載並安裝了 `exiftool` 程式，可以用它把圖檔的 metadata 轉換成文本，於是至少 diff 可以用文字呈現的方式向你示範發生了哪些修改： 

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

如果你把專案中的一個影像檔替換成另一個，然後執行 `git diff` 命令的結果如下： 

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

你可以很容易看出來，檔案的大小跟影像的尺寸都發生了改變。 

### 關鍵字擴展 ###

使用 SVN 或 CVS 的開發人員經常要求關鍵字擴展。這在 Git 中主要的問題是，你無法在一個檔案被提交後再修改它，因為 Git 會先對該檔計算 checksum。然而，你可以在檔案 check out 之後注入(inject)一些文字，然後在提交前再把它移除。Git 屬性提供了兩種方式來進行。 

首先，你可以把某個 blob 的 SHA-1 checksum 自動注入檔案的 $Id$ 欄位。如果在一個或多個檔案上設定了此欄位，當下次你 check out 該分支的時候，Git 會用 blob 的 SHA-1 值替換那個欄位。注意，這不是 commit 物件的 SHA，而是 blob 本身的： 

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

下次 check out 這個檔案的時候，Git 注入了 blob 的 SHA 值： 

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

然而，這個結果的用處有限。如果你在 CVS 或 Subversion 中用過關鍵字替換，你可以包含一個日期值 -- 而這個 SHA 值沒什麼幫助，因為它相當地隨機，也無法區分某個 SHA 跟另一個 SHA 比起來是比較新或是比較舊。

因此，你可以撰寫自己的篩檢程式，在提交或 checkout 文件時替換關鍵字。有兩種篩檢程式，”clean” 和 ”smudge”。在 `.gitattributes` 檔中，你能對特定的路徑設定一個篩檢程式，然後設定處理檔案的腳本，這些腳本會在檔案 check out 前（”smudge”，見圖 7-2）和提交前（”clean”，見圖7-3）被執行。這些篩檢程式能夠做各種有趣的事。 

Insert 18333fig0702.png
Figure 7-2. “smudge” filter 在 checkout 時執行

Insert 18333fig0703.png
Figure 7-3. “clean” filter 在檔案被 staged 的時候執行

這裡舉一個簡單的例子：在提交前，用 indent（縮進）程式過濾所有C原始程式碼。在 `.gitattributes` 檔中設定 ”indent” 篩檢程式過濾 `*.c` 文件： 

	*.c     filter=indent

然後，通過以下設定，讓 Git 知道 ”indent” 篩檢程式在遇到 ”smudge” 和 ”clean” 時分別該做什麼： 

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

於是，當你提交 `*.c` 檔時，indent 程式會被觸發，在把它們 check out 之前，cat 程式會被觸發。但 `cat` 程式在這裡沒什麼實際作用。這樣的組合，使C原始程式碼在提交前被 indent 程式過濾，非常有效。 

另一個有趣的例子是類似 RCS 的 $Date$ 關鍵字擴展。為了演示，需要一個小腳本，接受檔案名參數，得到專案的最新提交日期，最後把日期寫入該檔。下面用 Ruby 腳本來實現： 

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

該腳本從 `git log` 命令中得到最新提交日期，找到檔案中所有的 $Date$ 字串，最後把該日期填到 $Date$ 字串中 — 此腳本很簡單，你可以選擇你喜歡的程式設計語言來實現。把該腳本命名為 `expand_date`，放到正確的路徑中，之後需要在 Git 中設定一個篩檢程式（`dater`），讓它在 check ou 檔案時使用 `expand_date`，在提交時用 Perl 清除之： 

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

這個 Perl 小程式會刪除 $Date$ 字串裡多餘的字元，恢復 $Date$ 原貌。到目前為止，你的篩檢程式已經設定完畢，可以開始測試了。打開一個檔案，在檔中輸入 $Date$ 關鍵字，然後設定 Git 屬性： 

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

如果把這些修改提交，之後再 check out，你會發現關鍵字被替換了： 

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

雖說這項技術對自訂應用來說很有用，但還是要小心，因為 `.gitattributes` 檔會隨著專案一起提交，而篩檢程式（例如：`dater`）不會，所以，它不會在所有地方都成功運作。當你在設計這些篩檢程式時要注意，即使它們無法正常工作，也要讓整個專案運作下去。 

### 匯出倉庫 ###

Git 屬性在將專案匯出歸檔(archive)時也能發揮作用。 

#### export-ignore ####

當產生一個 archive 時，可以告訴 Git 不要匯出某些檔案或目錄。如果你不想在 archive 中包含一個子目錄或檔案，但想將他們納入專案的版本管理中，你能對應地設定 `export-ignore` 屬性。

例如，在 `test/` 子目錄中有一些測試檔，在專案的壓縮包中包含他們是沒有意義的。因此，可以增加下面這行到 Git 屬性檔中： 

	test/ export-ignore

現在，當執行 git archive 來建立專案的壓縮包時，那個目錄不會在 archive 中出現。 

#### export-subst ####

還能對 archives 做一些簡單的關鍵字替換。在第2章中已經可以看到，可以以 `--pretty=format` 形式的簡碼在任何檔中放入 `$Format:$` 字串。例如，如果想在專案中包含一個叫作 `LAST_COMMIT` 的檔，當執行 `git archive` 時，最後提交日期自動地注入進該檔，可以這樣設定： 

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

執行 `git archive` 後，打開該檔，會發現其內容如下： 

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### 合併策略 ###

通過 Git 屬性，還能對專案中的特定檔案使用不同的合併策略。一個非常有用的選項就是，當一些特定檔案發生衝突，Git 不會嘗試合併他們，而使用你這邊的來覆蓋別人的。 

如果專案的一個分支有歧義或比較特別，但你想從該分支合併，而且需要忽略其中某些檔，這樣的合併策略是有用的。例如，你有一個資料庫設定檔 database.xml，在兩個分支中他們是不同的，你想合併一個分支到另一個，而不弄亂該資料庫檔，可以設定屬性如下： 

	database.xml merge=ours

如果合併到另一個分支，database.xml 檔不會有合併衝突，顯示如下： 

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

這樣，database.xml會保持原樣。 

## Git Hooks ##

和其他版本控制系統一樣，當某些重要事件發生時，Git 有方法可以觸發自訂腳本。有兩組掛鉤(hooks)：用戶端和伺服器端。用戶端掛鉤用於用戶端的操作，如提交和合併。伺服器端掛鉤用於 Git 伺服器端的操作，如接收被推送的提交。你可以為了各種不同的原因使用這些掛鉤，下面會講解其中一些。

### 安裝一個 Hook ###

掛鉤都被保存在 Git 目錄下的 `hooks` 子目錄中，即大部分專案中預設的 `.git/hooks`。Git 預設會放置一些腳本範例在這個目錄中，除了可以作為掛鉤使用，這些樣本本身是可以獨立使用的。所有的樣本都是 shell 腳本，其中一些還包含了 Perl 的腳本，不過，任何正確命名的可執行腳本都可以正常使用 — 可以用 Ruby 或 Python，或其他。在 Git 1.6 版本之後，這些樣本檔名都是以 .sample 結尾，因此，你必須重新命名。在 Git 1.6 版本之前，這些樣本名都是正確的，但這些樣本不是可執行檔。 

把一個正確命名且可執行的檔放入 Git 目錄下的 hooks 子目錄中，可以啟動該掛鉤腳本，之後他一直會被 Git 呼叫。隨後會講解主要的掛鉤腳本。 

### 用戶端掛鉤 ###

有許多用戶端掛鉤，以下把他們分為：提交工作流程掛鉤、電子郵件工作流程掛鉤及其他用戶端掛鉤。 

#### 提交工作流程掛鉤 ####

有四個掛鉤被用來處理提交的過程。`pre-commit` 掛鉤在鍵入提交資訊前執行，被用來檢查即將提交的快照，例如，檢查是否有東西被遺漏，確認測試是否執行，以及檢查代碼。當從該掛鉤返回非零值時，Git 放棄此次提交，但可以用 `git commit --no-verify` 來忽略。該掛鉤可以被用來檢查程式碼樣式（執行類似 lint 的程式），檢查尾部空白（預設掛鉤是這麼做的），檢查新方法（簡體中文版譯注：程式的函數）的說明。 

`prepare-commit-msg` 掛鉤在提交資訊編輯器顯示之前，預設資訊被建立之後執行。因此，可以有機會在提交作者看到預設資訊前進行編輯。該掛鉤接收一些選項：擁有提交資訊的檔案路徑，提交類型，以及提交的 SHA-1 (如果這是一個 amended 提交)。該掛鉤對通常的提交來說不是很有用，只在自動產生的預設提交資訊的情況下有作用，如提交資訊範本、合併、壓縮和 amended 提交等。可以和提交範本配合使用，以程式設計的方式插入資訊。 

`commit-msg` 掛鉤接收一個參數，此參數是包含最近提交資訊的暫存檔路徑。如果該掛鉤腳本以非零退出，Git 會放棄提交，因此，可以用來在提交通過前驗證專案狀態或提交資訊。本章上一小節已經示範了使用該掛鉤核對提交資訊是否符合特定的模式。 

`post-commit` 掛鉤在整個提交過程完成後執行，他不會接收任何參數，但可以執行 `git log -1 HEAD` 來獲得最後的提交資訊。總之，該掛鉤是作為通知之類使用的。 

提交工作流程的用戶端掛鉤腳本可以在任何工作流程中使用，他們經常被用來實施某些策略，但值得注意的是，這些腳本在 clone 期間不會被傳送。可以在伺服器端實施策略來拒絕不符合某些策略的推送，但這完全取決於開發者在用戶端使用這些腳本的情況。所以，這些腳本對開發者是有用的，由他們自己設定和維護，而且在任何時候都可以覆蓋或修改這些腳本。 

#### E-mail 工作流掛鉤 ####

有三個可用的用戶端掛鉤用於 e-mail工作流。當執行 `git am` 命令時，會呼叫他們，因此，如果你沒有在工作流中用到此命令，可以跳過本節。如果你通過 e-mail 接收由 git `format-patch` 產生的修補檔，這些掛鉤也許對你有用。 

首先執行的是 applypatch-msg 掛鉤，他接收一個參數：包含被建議提交資訊的暫存檔案名。如果該腳本以非零值退出，Git 將放棄此修補檔。可以使用這個腳本確認提交資訊是否被正確格式化，或讓腳本把提交訊息編輯為正規化。

下一個當透過 `git am` 應用修補檔時執行的是 `pre-applypatch` 掛鉤。該掛鉤不接收參數，在修補檔被應用之後執行，因此，可以被用來在提交前檢查快照。你能用此腳本執行測試，檢查工作樹。如果有些什麼遺漏，或測試沒通過，腳本會以非零退出，放棄此次 `git am` 的執行，修補檔不會被提交。

最後在 `git am` 操作期間執行的掛鉤是 `post-applypatch`。你可以用他來通知一個小組或該修補檔的作者，但無法使用此腳本阻止打修補檔的過程。

#### 其他用戶端掛鉤 ####

`pre-rebase` 掛鉤在衍合前執行，腳本以非零退出可以中止衍合的過程。你可以使用這個掛鉤來禁止衍合已經推送的提交物件，Git 所安裝的 `pre-rebase` 掛鉤範例就是這麼做的，不過它假定 next 是你定義的分支名。因此，你可能要修改樣本，把 next 改成你定義過且穩定的分支名。 

在 `git checkout` 成功執行後會執行 `post-checkout` 掛鉤。他可以用來為你的專案環境設定合適的工作目錄。例如：放入大的二進位檔案、自動產生的文檔或其他一切你不想納入版本控制的檔案。 

最後，在 `merge` 命令成功執行後會執行 `post-merge` 掛鉤。他可以用來在 Git 無法跟蹤的工作樹中恢復資料，例如許可權資料。該掛鉤同樣能夠驗證在 Git 控制之外的檔是否存在，當工作樹改變時，你希望可以複製進來的檔案。

### 伺服器端掛鉤 ###

除了用戶端掛鉤，作為系統管理員，你還可以使用兩個伺服器端的掛鉤對專案實施各種類型的策略。這些掛鉤腳本可以在提交物件推送到伺服器前執行，也可以在推送到伺服器後執行。推送到伺服器前執行的掛鉤(pre hooks)可以在任何時候以非零退出，拒絕推送、傳回錯誤訊息給用戶端；還可以如你所願設定足夠複雜的推送策略。

#### pre-receive and post-receive ####

處理來自用戶端的推送（push）操作時最先執行的腳本就是 `pre-receive` 。它從標準輸入（stdin）取得被推送的引用(references)列表；如果它退出時的返回值不是0，那麼所有推送內容都不會被接受。利用此掛鉤腳本可以實現類似保證被更新的索引(references)都不是 non-fast-forward 類型；抑或檢查執行推送操作的用戶擁有建立、刪除或者推送的許可權，或者他是否對將要修改的每一個檔都有存取權限。

`post-receive` 掛鉤在整個過程完結以後執行，可以用來更新其他系統服務或者通知使用者。它接受與 `pre-receive` 相同的標準輸入資料。應用實例包括給某郵寄清單發信，通知即時整合資料的伺服器，或者更新軟體專案的問題追蹤系統 —— 甚至可以通過分析提交資訊來決定某個問題是否應該被開啟、修改或結案。該腳本無法停止推送程序，不過用戶端在它完成之前將保持連接狀態；所以在用它作一些長時間的操作之前請三思。

#### update ####

update 腳本和 `pre-receive` 腳本十分類似，除了它會為推送者更新的每一個分支執行一次。假如推送者同時向多個分支推送內容，`pre-receive` 只執行一次，相較之下 update 則會為每一個更新的分支執行一次。它不會從標準輸入讀取內容，而是接受三個參數：索引(reference)的名字（分支），推送前索引指向的內容的 SHA-1 值，以及使用者試圖推送內容的 SHA-1 值。如果 update 腳本退出時返回非零值，只有相應的那一個索引會被拒絕；其餘的依然會得到更新。 

## Git 強制策略實例 ##

在本節中，我們應用前面學到的知識建立這樣一個 Git 工作流程：檢查提交資訊的格式，只接受純 fast-forward 內容的推送，並且指定專案中的某些特定用戶只能修改某些特定子目錄。我們將撰寫一個用戶端腳本來提示開發人員他們推送的內容是否會被拒絕，以及一個伺服端腳本來實際執行這些策略。 

我使用 Ruby 來撰寫這些腳本，一方面因為它是我喜好的指令碼語言(scripting language)，也因為我覺得它是最接近偽代碼(pseudocode-looking)的指令碼語言；因而即便你不使用 Ruby 也能大致看懂。不過任何其他語言也一樣適用。所有 Git 自帶的範例腳本都是用 Perl 或 Bash 寫的，所以從這些腳本中能找到相當多的這兩種語言的掛鉤範例。

### 服務端掛鉤 ###

所有服務端的工作都在 hooks（掛鉤）目錄的 update（更新）腳本中制定。update 腳本為每一個得到推送的分支執行一次；它接受推送目標的索引(reference)、該分支原來指向的位置、以及被推送的新內容。如果推送是通過 SSH 進行的，還可以取得發出此次操作的用戶。如果設定所有操作都通過公鑰授權的單一帳號（比如＂git＂）進行，就有必要通過一個 shell 包裝(wrapper)依據公鑰來判斷用戶的身份，並且設定環境變數來表示該使用者的身份。下面假設嘗試連接的使用者保存在 `$USER` 環境變數裡，我們的 update 腳本首先搜集一切需要的資訊： 

	#!/usr/bin/env ruby

	refname = ARGV[0]
	oldrev  = ARGV[1]
	newrev  = ARGV[2]
	user    = ENV['USER']

	puts "Enforcing Policies... \n(#{refname}) (#{oldrev[0,6]}) (#{newrev[0,6]})"

#### 強制特定的提交資訊格式 ####

我們的第一項任務是指定每一條提交資訊都必須遵循某種特殊的格式。只是設定一個目標，假定每一條資訊必須包含一條形似 “ref: 1234” 這樣的字串，因為我們需要把每一次提交連結到專案問題追蹤系統裏面的工作專案。我們要逐一檢查每一條推送上來的提交內容，看看提交資訊是否包含這麼一個字串，然後，如果該提交裡不包含這個字串，以非零返回值退出從而拒絕此次推送。

把 `$newrev` 和 `$oldrev` 變數的值傳給一個叫做 `git rev-list` 的 Git plumbing 命令可以取得所有提交內容 SHA-1 值的列表。`git rev-list` 基本上是個 `git log` 命令，但它預設只輸出 SHA-1 值而已，沒有其他資訊。所以要取得由 SHA 值表示的從一次提交到另一次提交之間的所有 SHA 值，可以執行： 

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

取得這些輸出內容，迴圈遍歷其中每一個提交的 SHA 值，找出與之對應的提交資訊，然後用規則運算式(regular expression)來測試該資訊是否符合某個 pattern。

下面要搞定如何從所有的提交內容中提取出提交資訊。使用另一個叫做 `git cat-file` 的 Git plumbing 工具可以獲得原始的提交資料。我們將在第九章瞭解到這些 plumbing 工具的細節；現在暫時先看一下這條命令會給你什麼： 

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

通過 SHA-1 值獲得提交內容中的提交資訊的一個簡單辦法是找到提交的第一個空白行，然後取出它之後的所有內容。可以使用 Unix 系統的 `sed` 命令來實現這個效果： 

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

這條咒語從每一個待提交內容裡提取提交訊息，並且會在提交訊息不符合要求的情況下退出。為了退出腳本和拒絕此次推送，返回一個非零值。整個 method 大致如下： 

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

把這一段放在 `update` 腳本裡，所有包含不符合指定規則的提交都會遭到拒絕。 

#### 實現基於使用者的存取權限控制清單（ACL）系統 ####

假設你需要增加一個使用存取權限控制列表 (access control list, ACL) 的機制來指定哪些使用者對專案的哪些部分有推送許可權。某些使用者具有全部的存取權，其他人只對某些子目錄或者某些特定的檔案具有推送許可權。要搞定這一點，所有的規則將被寫入一個位於伺服器的原始 Git 倉庫的 `acl` 檔。我們讓 update 掛鉤檢閱這些規則，審視推送的提交內容中需要修改的所有檔案，然後判定執行推送的用戶是否對所有這些檔案都有許可權。 

我們首先要建立這個列表。這裡使用的格式和 CVS 的 ACL 機制十分類似：它由若干行構成，第一欄的內容是 `avail` 或者 `unavail`；下一欄是由逗號分隔的使用者清單，列出這條規則會對哪些使用者生效；最後一欄是這條規則會對哪個目錄生效（空白表示開放存取）。這些欄位由 pipe (`|`) 字元隔開。 

下例中，我們指定幾個管理員，幾個對 `doc` 目錄具有許可權的文件作者，以及一個只對 `lib` 和 `tests` 目錄具有許可權的開發人員，ACL 檔看起來像這樣： 

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

首先把這些資料讀入到你所能使用的資料結構中。本例中，為保持簡潔，我們暫時只實做 `avail` 的規則（譯注：也就是省略了 unavail 部分）。下面這個 method 產生一個關聯式陣列，它的主鍵是使用者名稱，對應的值是一個該用戶有寫入許可權的所有目錄組成的陣列： 

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

針對之前給出的 ACL 規則檔，這個 `get_acl_access_data` method 回傳的資料結構如下： 

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

搞定了使用者許可權的資料，下面需要找出這次推送的提交之中，哪些位置被修改，從而確保試圖推送的使用者對這些位置都有許可權。 

使用 `git log` 的 `--name-only` 選項（在第二章裡簡單的提過）我們可以輕而易舉的找出一次提交裡有哪些被修改的檔案： 

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

使用 `get_acl_access_data` 回傳的 ACL 結構來一一核對每一次提交修改的檔案列表，就能判定該用戶是否有許可權推送所有的提交內容: 

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

以上的大部分內容應該還算容易理解。通過 `git rev-list` 取得推送到伺服器的提交清單。然後，針對其中每一項，找出它試圖修改的檔案，然後確保執行推送的用戶對這些檔案具有許可權。一個不太容易理解的 Ruby 技巧是 `path.index(access_path) ==0` 這句，如果路徑以 `access_path` 開頭，它會回傳 True——這是為了確保 `access_path` 並不是只在允許的路徑之一，而是所有准許全選的目錄都在該目錄之下。

現在，如果提交資訊的格式不對的話，或是修改的檔案在允許的路徑之外的話，你的用戶就不能推送這些提交。 

#### 只允許 Fast-Forward 類型的推送 ####

剩下的最後一項任務是指定只接受 fast-forward 的推送。在 Git 1.6 或者較新的版本裡，只需要設定 `receive.denyDeletes` 和 `receive.denyNonFastForwards` 選項就可以了。但是用掛鉤來實做這個功能，便可以在舊版本的 Git 上運作，並且通過一定的修改，它可以做到只針對某些用戶執行，或者更多以後可能用到的規則。

檢查的邏輯是看看是否有任何的提交在舊版本(revision)裡能找到、但在新版本裡卻找不到。如果沒有，那這是一次純 fast-forward 的推送；如果有，那我們拒絕此次推送： 

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

一切都設定好了。如果現在執行 `chmod u+x .git/hooks/update` —— 這是包含以上內容的案，我們修改它的許可權，然後嘗試推送一個包含非 fast-forward 類型的索引，會得到類似如下： 

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

這裡有幾個有趣的資訊。首先，我們可以看到掛鉤執行的起點： 

	Enforcing Policies...
	(refs/heads/master) (8338c5) (c5b616)

注意這是你在 update 腳本一開頭的地方印出到標準輸出的東西。所有從腳本印出到 stdout 的東西都會發送到用戶端，這點很重要。 

下一個值得注意的部分是錯誤資訊。 

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

第一行是我們的腳本輸出的，在往下是 Git 在告訴我們 update 腳本退出時傳回了非零值，因而推送遭到了拒絕。最後一點：

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

每一個被掛鉤拒絕的索引(reference)，你都會看到一條遠端拒絕訊息，解釋它被拒絕是因為一個掛鉤失敗的原因。 

而且，如果 ref 標記字串(譯註: 例如 ref: 1234)沒有包含在任何的提交裡，我們將看到前面腳本裡印出的錯誤資訊： 

	[POLICY] Your message is not formatted correctly

又或者某人想修改一個自己不具備許可權的檔，然後推送了一個包含它的提交，他將看到類似的提示。比如，一個文件作者嘗試推送一個修改了 `lib` 目錄下某些東西的提交，他會看到 

	[POLICY] You do not have access to push to lib/test.rb

都做好了。從這裡開始，只要 `update` 腳本存在並且可執行，我們的倉庫永遠都不會遭到回轉(rewound)，或者包含不符合要求資訊的提交內容，並且使用者都被鎖在了沙箱裡面。 

### 用戶端掛鉤 ###

這種方法的缺點在於使用者推送內容遭到拒絕後幾乎無法避免的抱怨。辛辛苦苦寫成的代碼在最後時刻慘遭拒絕是令人十分沮喪、迷惑的；更可憐的是他們不得不修改提交歷史來解決問題，有時候這可不是隨便哪個人都做得來的。

這種兩難境地的解答是提供一些用戶端的掛鉤，讓使用者可以用來在他們作出伺服器可能會拒絕的事情時給以警告。這樣的話，用戶們就能在提交--問題變得更難修正之前修正問題。由於掛鉤本身不跟隨 clone 的專案副本分發，所以必須通過其他途徑把這些掛鉤分發到用戶的 `.git/hooks` 目錄並設為可執行檔。雖然可以在專案裏或用另一個專案分發這些掛鉤，不過全自動的解決方案是不存在的。

首先，你應該在每次提交前檢查你的提交說明訊息，這樣你才能確保伺服器不會因為不合格式的提交說明訊息而拒絕你的更改。為了達到這個目的，你可以增加 `commit-msg` 掛鉤。如果你使用該掛鉤來讀取第一個參數傳遞的檔案裏的訊息，並且與規定的模式(pattern)作對比，你就可以使 Git 在提交說明訊息不符合條件的情況下，拒絕執行提交。

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

如果這個腳本放在這個位置 (`.git/hooks/commit-msg`) 並且是可執行的, 而你的提交說明訊息沒有做適當的格式化，你會看到： 

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

在這個實例中，提交沒有成功。然而如果你的提交說明訊息符合要求的，Git 會允許你提交： 

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

接下來我們要保證沒有修改到 ACL 允許範圍之外的檔案。如果你的專案 `.git` 目錄裡有前面使用過的 ACL 檔，那麼以下的 `pre-commit` 腳本將執行裡面的限制規定：

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

這和服務端的腳本幾乎一樣，除了兩個重要區別。第一，ACL 檔的位置不同，因為這個腳本在目前工作目錄執行，而非 Git 目錄。ACL 檔的目錄必須由這個

	access = get_acl_access_data('acl')

改成這個:

	access = get_acl_access_data('.git/acl')

另一個重要區別是取得「被修改檔案清單」的方式。在服務端的時候使用了查看提交紀錄的方式，可是目前的提交都還沒被記錄下來呢，所以這個清單只能從暫存區域取得。原來是這樣：

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

現在要用這樣：

	files_modified = `git diff-index --cached --name-only HEAD`

不同的就只有這兩點——除此之外，該腳本完全相同。一個小陷阱在於它假設在本地執行的帳戶和推送到遠端服務端的相同。如果這二者不一樣，則需要手動設定一下 `$user` 變數。

最後一項任務是檢查確認推送內容中不包含非 fast-forward 類型的索引(reference)，不過這個需求比較少見。以下情況會得到一個非 fast-forward 類型的索引，要麼在某個已經推送過的提交上做衍合，要麼從本地不同分支推送到遠端相同的分支上。

既然伺服器會告訴你不能推送非 fast-forward 內容，而且上面的掛鉤也能阻止強制的推送，唯一剩下的潛在問題就是衍合已經推送過的提交內容。

下面是一個檢查這個問題的 pre-rabase 腳本的例子。它取得一個所有即將重寫的提交內容的清單，然後檢查它們是否在遠端的索引(reference)裡已經存在。一旦發現某個提交可以從遠端索引裡衍變過來，它就放棄衍合操作：

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

這個腳本利用了一個第六章「修訂版本選擇」一節中不曾提到的語法。執行這個命令可以獲得一個所有已經完成推送的提交的列表：

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

`SHA^@` 語法解析該次提交的所有祖先。我們尋找任何一個提交，這個提交可以從遠端最後一次提交衍變獲得(reachable)，但從我們嘗試推送的任何一個提交的 SHA 值的任何一個祖先都無法衍變獲得——也就是 fast-forward 的內容。

這個解決方案的缺點在於它可能會很慢而且通常是沒有必要的——只要不用 -f 來強制推送，伺服器會自動給出警告並且拒絕推送內容。然而，這是個不錯的練習，而且理論上能幫助用戶避免一個將來不得不回頭修改的衍合操作。

## 總結 ##

你已經見識過絕大多數通過自訂 Git 用戶端和服務端來適應自己工作流程和專案內容的方式了。你已經學到了各種設定設定(configuration settings)、以檔案為基礎的屬性(file-based attributes)、以及事件掛鉤，你也建置了一個執行強制政策的伺服器。現在，差不多任何你能想像到的工作流程，你應該都能讓 Git 切合你的需要。
