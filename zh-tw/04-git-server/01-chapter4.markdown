# 伺服器上的 Git #

到目前為止，你應該已經學會了使用 Git 來完成日常工作。然而，如果想與他人合作，還需要一個遠端的 Git 倉庫。儘管技術上可以從個人的倉庫裡推送和拉取修改內容，但我們不鼓勵這樣做，因為一不留心就很容易弄混其他人的進度。另外，你也一定希望合作者們即使在自己不開機的時候也能從倉庫取得資料 — 擁有一個更穩定的公開倉庫十分有用。因此，更好的合作方式是建立一個大家都可以存取的共用倉庫，從那裡推送和拉取資料。我們將把這個倉庫稱為 "Git 伺服器"；代理一個 Git 倉庫只需要花費很少的資源，幾乎從不需要整個伺服器來支援它的執行。

架設一台 Git 伺服器並不難。第一步是選擇與伺服器通訊的協定。本章第一節將介紹可用的協議以及各自優缺點。下面一節將介紹一些針對各個協議典型的設定以及如何在伺服器上實施。最後，如果你不介意在他人伺服器上保存你的代碼，又想免去自己架設和維護伺服器的麻煩，倒可以試試我們介紹的幾個倉庫託管服務。

如果你對架設自己的伺服器沒興趣，可以跳到本章最後一節去看看如何申請一個代碼託管服務的帳戶然後繼續下一章，我們會在那裡討論分散式原始碼控制環境的林林總總。

遠端倉庫通常只是一個_裸倉庫（bare repository）_ — 即一個沒有目前工作目錄的倉庫。因為該倉庫只是一個合作媒介，所以不需要從硬碟上取出最新版本的快照；倉庫裡存放的僅僅是 Git 的資料。簡單地說，裸倉庫就是你工作目錄中 `.git` 子目錄內的內容。

## 協議 ##

Git 可以使用四種主要的協定來傳輸資料：本地傳輸，SSH 協定，Git 協定和 HTTP 協定。下面分別介紹一下哪些情形應該使用（或避免使用）這些協定。

值得注意的是，除了 HTTP 協定外，其他所有協定都要求在伺服器端安裝並執行 Git。

### 本地協定 ###

最基本的就是_本地協議（Local protocol）_，所謂的遠端倉庫在該協定中的表示，就是硬碟上的另一個目錄。這常見於團隊每一個成員都對一個共用的檔案系統（例如 NFS）擁有存取權，或者比較少見的多人共用同一台電腦的情況。後面一種情況並不安全，因為所有代碼倉庫實例都保存在同一台電腦裡，增加了災難性資料損失的可能性。

如果你使用一個共用的檔案系統，就可以在一個本地檔案系統中克隆倉庫，推送和取得。克隆的時候只需要將遠端倉庫的路徑作為 URL 使用，比如下面這樣：

	$ git clone /opt/git/project.git

或者這樣：

	$ git clone file:///opt/git/project.git

如果在 URL 開頭明確使用 `file://` ，那麼 Git 會以一種略微不同的方式執行。如果你只給出路徑，Git 會嘗試使用硬連結或直接複製它所需要的檔案。如果使用了 `file://` ，Git 會呼叫它平時通過網路來傳輸資料的工序，而這種方式的效率相對較低。使用 `file://` 首碼的主要原因是當你需要一個不包含無關引用或物件的乾淨倉庫副本的時候 — 一般指從其他版本控制系統導入的，或類似情形（參見第 9 章的維護任務）。我們這裡僅僅使用普通路徑，這樣更快。

要增加一個本地倉庫作為現有 Git 專案的遠端倉庫，可以這樣做：

	$ git remote add local_proj /opt/git/project.git

然後就可以像在網路上一樣向這個遠端倉庫推送和取得資料了。

#### 優點 ####

基於檔案庫的優點在於它的簡單，同時保留了現存檔案的許可權和網路存取權限。如果你的團隊已經有一個全體共用的檔案系統，建立倉庫就十分容易了。你只需把一份裸倉庫的副本放在大家都能存取的地方，然後像對其他共用目錄一樣設定讀寫許可權就可以了。我們將在下一節“在伺服器上部署 Git ”中討論如何匯出一個裸倉庫的副本。

這也是從別人工作目錄中取得工作成果的快速方法。假如你和你的同事在一個專案中合作，他們想讓你檢出一些東西的時候，執行類似 `git pull /home/john/project` 通常會比他們推送到伺服器，而你再從伺服器取得簡單得多。

#### 缺點 ####

這種方法的缺點是，與基本的網路連接存取相比，難以控制從不同位置來的存取權限。如果你想從家裡的筆記型電腦上推送，就要先掛載遠端硬碟，這和基於網路連接的存取相比更加困難和緩慢。

另一個很重要的問題是該方法不一定就是最快的，尤其是對於共用掛載的檔案系統。本地倉庫只有在你對資料存取速度快的時候才快。在同一個伺服器上，如果二者同時允許 Git 存取本地硬碟，通過 NFS 存取倉庫通常會比 SSH 慢。

### SSH 協議 ###

Git 使用的傳輸協議中最常見的可能就是 SSH 了。這是因為大多數環境已經支持通過 SSH 對伺服器的存取 — 即便還沒有，架設起來也很容易。SSH 也是唯一一個同時支持讀寫操作的網路通訊協定。另外兩個網路通訊協定（HTTP 和 Git）通常都是唯讀的，所以雖然二者對大多數人都可用，但執行寫操作時還是需要 SSH。SSH 同時也是一個驗證授權的網路通訊協定；而因為其普遍性，一般架設和使用都很容易。

通過 SSH 克隆一個 Git 倉庫，你可以像下面這樣給出 ssh:// 的 URL：

	$ git clone ssh://user@server/project.git

或者不指定某個協定 — 這時 Git 會預設使用 SSH ：

	$ git clone user@server:project.git

如果不指定用戶，Git 會預設使用目前登錄的使用者名稱連接伺服器。 

#### 優點 ####

使用 SSH 的好處有很多。首先，如果你想擁有對網路倉庫的寫許可權，基本上不可能不使用 SSH。其次，SSH 架設相對比較簡單 — SSH 服務很常見，很多網路系統管理員都有一些使用經驗，而且很多作業系統都自帶了它或者相關的管理工具。再次，通過 SSH 進行存取是安全的 — 所有資料傳輸都是加密和授權的。最後，和 Git 及本地協議一樣，SSH 也很高效，會在傳輸之前盡可能壓縮資料。

#### 缺點 ####

SSH 的限制在於你不能通過它實現倉庫的匿名存取。即使僅為讀取資料，人們也必須在能通過 SSH 存取主機的前提下才能存取倉庫，這使得 SSH 不利於開源的專案。如果你僅僅在公司網路裡使用，SSH 可能是你唯一需要使用的協定。如果想允許對專案的匿名唯讀存取，那麼除了為自己推送而架設 SSH 協定之外，還需要支援其他協定以便他人存取讀取。

### Git 協議 ###

接下來是 Git 協議。這是一個包含在 Git 套裝軟體中的特殊服務； 它會監聽一個提供類似於 SSH 服務的特定埠（9418），而無需任何授權。打算支援 Git 協定的倉庫，需要先建立 `git-daemon-export-ok` 檔 — 它是協定行程提供倉庫服務的必要條件 — 但除此之外該服務沒有什麼安全措施。要麼所有人都能克隆 Git 倉庫，要麼誰也不能。這也意味著該協議通常不能用來進行推送。你可以允許推送操作；然而由於沒有授權機制，一旦允許該操作，網路上任何一個知道專案 URL 的人將都有推送許可權。不用說，這是十分罕見的情況。

#### 優點 ####

Git 協定是現存最快的傳輸協議。如果你在提供一個有很大存取量的公開專案，或者一個不需要對讀操作進行授權的龐大專案，架設一個 Git 服務來供應倉庫是個不錯的選擇。它使用與 SSH 協定相同的資料傳輸機制，但省去了加密和授權的開銷。

#### 缺點 ####

Git 協議消極的一面是缺少授權機制。用 Git 協議作為存取專案的唯一方法通常是不可取的。一般的做法是，同時提供 SSH 介面，讓幾個開發者擁有推送（寫）許可權，其他人通過 `git://` 擁有唯讀許可權。
Git 協定可能也是最難架設的協議。它要求有單獨的服務，需要定制 — 我們將在本章的 “Gitosis” 一節詳細介紹它的架設 — 需要設定 `xinetd` 或類似的程式，而這些工作就沒那麼輕鬆了。該協議還要求防火牆開放 9418 埠，而企業級防火牆一般不允許對這個非標準埠的存取。大型企業級防火牆通常會封鎖這個少見的埠。

### HTTP/S 協議 ###

最後還有 HTTP 協議。HTTP 或 HTTPS 協議的優美之處在於架設的簡便性。基本上，只需要把 Git 的裸倉庫檔放在 HTTP 的根目錄下，設定一個特定的 `post-update` 掛鉤（hook）就可以搞定（Git 掛鉤的細節見第 7 章）。此後，每個能存取 Git 倉庫所在伺服器上 web 服務的人都可以進行克隆操作。下面的操作可以允許通過 HTTP 對倉庫進行讀取：

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

這樣就可以了。Git 附帶的 `post-update` 掛鉤會預設執行合適的命令（`git update-server-info`）來確保通過 HTTP 的取得和克隆正常工作。這條命令在你用 SSH 向倉庫推送內容時執行；之後，其他人就可以用下面的命令來克隆倉庫：

	$ git clone http://example.com/gitproject.git

在本例中，我們使用了 Apache 設定中常用的 `/var/www/htdocs` 路徑，不過你可以使用任何靜態 web 服務 — 把裸倉庫放在它的目錄裡就行。 Git 的資料是以最基本的靜態檔的形式提供的（關於如何提供檔的詳情見第 9 章）。

通過 HTTP 進行推送操作也是可能的，不過這種做法不太常見，並且牽扯到複雜的 WebDAV 設定。由於很少用到，本書將略過對該內容的討論。如果對 HTTP 推送協議感興趣，不妨打開這個位址看一下操作方法：`http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` 。通過 HTTP 推送的好處之一是你可以使用任何 WebDAV 伺服器，不需要為 Git 設定特殊環境；所以如果主機提供商支援通過 WebDAV 更新網站內容，你也可以使用這項功能。

#### 優點 ####

使用 HTTP 協定的好處是易於架設。幾條必要的命令就可以讓全世界讀取到倉庫的內容。花費不過幾分鐘。HTTP 協議不會佔用過多伺服器資源。因為它一般只用到靜態的 HTTP 服務提供所有資料，普通的 Apache 伺服器平均每秒能支撐數千個檔的併發存取 — 哪怕讓一個小型伺服器超載都很難。

你也可以通過 HTTPS 提供唯讀的倉庫，這意味著你可以加密傳輸內容；你甚至可以要求用戶端使用特定簽名的 SSL 證書。一般情況下，如果到了這一步，使用 SSH 公開金鑰可能是更簡單的方案；不過也存在一些特殊情況，這時通過 HTTPS 使用帶簽名的 SSL 證書或者其他基於 HTTP 的唯讀連接授權方式是更好的解決方案。

HTTP 還有個額外的好處：HTTP 是一個非常常見的協議，所以企業級防火牆通常都允許該連接埠的通訊。

#### 缺點 ####

HTTP 協議的消極面在於，相對來說用戶端效率更低。克隆或者下載倉庫內容可能會花費更多時間，而且 HTTP 傳輸的體積和網路開銷比其他任何一個協議都大。因為它沒有按需供應的能力 — 傳輸過程中沒有服務端的動態計算 — 因而 HTTP 協定經常會被稱為_傻瓜（dumb）_協議。更多 HTTP 協定和其他協定效率上的差異見第 9 章。

## 在伺服器上部署 Git ##

開始架設 Git 伺服器前，需要先把現有倉庫匯出為裸倉庫 — 即一個不包含目前工作目錄的倉庫。做法直截了當，克隆時用 `--bare` 選項即可。裸倉庫的目錄名一般以 `.git` 結尾，像這樣：

	$ git clone --bare my_project my_project.git
	Cloning into bare repository 'my_project.git'...
	done.

該命令的輸出或許會讓人有些不解。其實 `clone` 操作基本上相當於 `git init` 加 `git fetch`，所以這裡出現的其實是 `git init` 的輸出，先由它建立一個空目錄，而之後傳輸資料物件的操作並無任何輸出，只是悄悄在幕後執行。現在 `my_project.git` 目錄中已經有了一份 Git 目錄資料的副本。

整體上的效果大致相當於：

	$ cp -Rf my_project/.git my_project.git

但在設定檔中有若干小改動，不過對使用者來講，使用方式都一樣，不會有什麼影響。它僅取出 Git 倉庫的必要原始資料，存放在該目錄中，而不會另外建立工作目錄。

### 把裸倉庫移到伺服器上 ###

有了裸倉庫的副本後，剩下的就是把它放到伺服器上並設定相關協定。假設一個功能變數名稱為 `git.example.com` 的伺服器已經架設好，並可以通過 SSH 存取，我們打算把所有 Git 倉庫保存在 `/opt/git` 目錄下。只要把裸倉庫複製過去：

	$ scp -r my_project.git user@git.example.com:/opt/git

現在，所有對該伺服器有 SSH 存取權限，並可讀取 `/opt/git` 目錄的使用者都可以用下面的命令克隆該專案：

	$ git clone user@git.example.com:/opt/git/my_project.git

如果某個 SSH 用戶對 `/opt/git/my_project.git` 目錄有寫許可權，那他就有推送許可權。如果到該專案目錄中執行 `git init` 命令，並加上 `--shared` 選項，那麼 Git 會自動修改該倉庫目錄的組許可權為可寫（譯注：實際上 `--shared` 可以指定其他行為，只是預設為將組許可權改為可寫並執行 `g+sx`，所以最後會得到 `rws`。）。

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

由此可見，根據現有的 Git 倉庫建立一個裸倉庫，然後把它放上你和同事都有 SSH 存取權的伺服器是多麼容易。現在已經可以開始在同一專案上密切合作了。

值得注意的是，這的的確確是架設一個少數人具有連接權的 Git 服務的全部 — 只要在伺服器上加入可以用 SSH 登錄的帳號，然後把裸倉庫放在大家都有讀寫許可權的地方。一切都準備停當，無需更多。

下面的幾節中，你會瞭解如何擴展到更複雜的設定。這些內容包含如何避免為每一個用戶建立一個帳戶，給倉庫增加公開讀取許可權，架設網頁介面，使用 Gitosis 工具等等。然而，只是和幾個人在一個不公開的專案上合作的話，僅僅是一個 SSH 伺服器和裸倉庫就足夠了，記住這點就可以了。

### 小型安裝 ###

如果設備較少或者你只想在小型開發團隊裡嘗試 Git ，那麼一切都很簡單。架設 Git 服務最複雜的地方在於帳戶管理。如果需要倉庫對特定的使用者可讀，而給另一部分用戶讀寫許可權，那麼存取和許可的安排就比較困難。

#### SSH 連接 ####

如果已經有了一個所有開發成員都可以用 SSH 存取的伺服器，架設第一個伺服器將變得異常簡單，幾乎什麼都不用做（正如上節中介紹的那樣）。如果需要對倉庫進行更複雜的存取控制，只要使用伺服器作業系統的本地檔存取許可機制就行了。

如果需要團隊裡的每個人都對倉庫有寫許可權，又不能給每個人在伺服器上建立帳戶，那麼提供 SSH 連接就是唯一的選擇了。我們假設用來共用倉庫的伺服器已經安裝了 SSH 服務，而且你通過它存取伺服器。

有好幾個辦法可以讓團隊的每個人都有存取權。第一個辦法是給每個人建立一個帳戶，直截了當但略過繁瑣。反覆執行 `adduser` 並給所有人設定臨時密碼可不是好玩的。

第二個辦法是在主機上建立一個 `git` 帳戶，讓每個需要寫許可權的人發送一個 SSH 公開金鑰，然後將其加入 `git` 帳戶的 `~/.ssh/authorized_keys` 文件。這樣一來，所有人都將通過 `git` 帳戶存取主機。這絲毫不會影響提交的資料 — 存取主機用的身份不會影響提交物件的提交者資訊。

另一個辦法是讓 SSH 伺服器通過某個 LDAP 服務，或者其他已經設定好的集中授權機制，來進行授權。只要每個人都能獲得主機的 shell 存取權，任何可用的 SSH 授權機制都能達到相同效果。

## 生成 SSH 公開金鑰 ##

大多數 Git 伺服器都會選擇使用 SSH 公開金鑰來進行授權。系統中的每個使用者都必須提供一個公開金鑰用於授權，沒有的話就要生成一個。生成公開金鑰的過程在所有作業系統上都差不多。
首先先確認一下是否已經有一個公開金鑰了。SSH 公開金鑰預設保存在帳戶的主目錄下的 `~/.ssh` 目錄。進去看看：

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

關鍵是看有沒有用 `something` 和 `something.pub` 來命名的一對檔，這個 `something` 通常就是 `id_dsa` 或 `id_rsa`。有 `.pub` 尾碼的檔就是公開金鑰，另一個檔則是金鑰。假如沒有這些檔，或者乾脆連 `.ssh` 目錄都沒有，可以用 `ssh-keygen` 來建立。該程式在 Linux/Mac 系統上由 SSH 包提供，而在 Windows 上則包含在 MSysGit 包裡：

	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

它先要求你確認保存公開金鑰的位置（`.ssh/id_rsa`），然後它會讓你重複一個密碼兩次，如果不想在使用公開金鑰的時候輸入密碼，可以留空。

現在，所有做過這一步的用戶都得把它們的公開金鑰給你或者 Git 伺服器的管理員（假設 SSH 服務被設定為使用公開金鑰機制）。他們只需要複製 `.pub` 檔的內容然後發郵件給管理員。公開金鑰的樣子大致如下：

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

關於在多個作業系統上設立相同 SSH 公開金鑰的教程，可以查閱 GitHub 上有關 SSH 公開金鑰的嚮導：`http://github.com/guides/providing-your-ssh-key`。

## 架設伺服器 ##

現在我們過一邊伺服器端架設 SSH 存取的流程。本例將使用 `authorized_keys` 方法來給用戶授權。我們還將假定使用類似 Ubuntu 這樣的標準 Linux 發行版本。首先，建立一個名為 'git' 的用戶，並為其建立一個 `.ssh` 目錄。

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

接下來，把開發者的 SSH 公開金鑰增加到這個用戶的 `authorized_keys` 檔中。假設你通過電子郵件收到了幾個公開金鑰並存到了暫存檔案裡。重複一下，公開金鑰大致看起來是這個樣子：

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

只要把它們逐個追加到 `authorized_keys` 檔案結尾部即可：

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

現在可以用 `--bare` 選項執行 `git init` 來建立一個裸倉庫，這會初始化一個不包含工作目錄的倉庫。

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

這時，Join，Josie 或者 Jessica 就可以把它加為遠端倉庫，推送一個分支，從而把第一個版本的專案檔案上傳到倉庫裡了。值得注意的是，每次增加一個新專案都需要通過 shell 登入主機並建立一個裸倉庫目錄。我們不妨以 `gitserver` 作為 `git` 用戶及專案倉庫所在的主機名稱。如果在網路內部執行該主機，並在 DNS 中設定 `gitserver` 指向該主機，那麼以下這些命令都是可用的：

	# 在 John 的電腦上
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

這樣，其他人的克隆和推送也一樣變得很簡單：

	$ git clone git@gitserver:/opt/git/project.git
	$ cd project
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

用這個方法可以很快速地為少數幾個開發者架設一個可讀寫的 Git 服務。

作為一個額外的防範措施，你可以用 Git 自帶的 `git-shell` 工具限制 `git` 用戶的活動範圍。只要把它設為 `git` 用戶登入的 shell，那麼該用戶就無法使用普通的 bash 或者 csh 什麼的 shell 程式。編輯 `/etc/passwd` 檔：

	$ sudo vim /etc/passwd

在檔末尾，你應該能找到類似這樣的行：

	git:x:1000:1000::/home/git:/bin/sh

把 `bin/sh` 改為 `/usr/bin/git-shell` （或者用 `which git-shell` 查看它的實際安裝路徑）。該行修改後的樣子如下：

	git:x:1000:1000::/home/git:/usr/bin/git-shell

現在 `git` 用戶只能用 SSH 連接來推送和取得 Git 倉庫，而不能直接使用主機 shell。嘗試普通 SSH 登錄的話，會看到下面這樣的拒絕資訊：

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## 公開存取 ##

匿名的讀取許可權該怎麼實現呢？也許除了內部私有的專案之外，你還需要託管一些開源專案。或者因為要用一些自動化的伺服器來進行編譯，或者有一些經常變化的伺服器群組，而又不想整天生成新的 SSH 金鑰 — 總之，你需要簡單的匿名讀取許可權。

或許對小型的設定來說最簡單的辦法就是執行一個靜態 web 服務，把它的根目錄設定為 Git 倉庫所在的位置，然後開啟本章第一節提到的 `post-update` 掛鉤。這裡繼續使用之前的例子。假設倉庫處於 `/opt/git` 目錄，主機上執行著 Apache 服務。重申一下，任何 web 服務程式都可以達到相同效果；作為範例，我們將用一些基本的 Apache 設定來示範大體需要的步驟。

首先，開啟掛鉤：

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

`post-update` 掛鉤是做什麼的呢？其內容大致如下：

	$ cat .git/hooks/post-update
	#!/bin/sh
	#
	# An example hook script to prepare a packed repository for use over
	# dumb transports.
	#
	# To enable this hook, rename this file to "post-update".
	#
	
	exec git-update-server-info

意思是當通過 SSH 向伺服器推送時，Git 將執行這個 `git-update-server-info` 命令來更新匿名 HTTP 存取取得資料時所需要的檔案。

接下來，在 Apache 設定檔中增加一個 VirtualHost 條目，把文檔根目錄設為 Git 專案所在的根目錄。這裡我們假定 DNS 服務已經設定好，會把對 `.gitserver` 的請求發送到這台主機：

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

另外，需要把 `/opt/git` 目錄的 Unix 使用者組設定為 `www-data` ，這樣 web 服務才可以讀取倉庫內容，因為執行 CGI 腳本的  Apache 實例行程預設就是以該使用者的身份起來的：

	$ chgrp -R www-data /opt/git

重啟 Apache 之後，就可以通過專案的 URL 來克隆該目錄下的倉庫了。

	$ git clone http://git.gitserver/project.git

這一招可以讓你在幾分鐘內為相當數量的用戶架設好基於 HTTP 的讀取許可權。另一個提供未經授權存取的簡單方法是開啟一個 Git 服務，不過這將要求該行程作為後臺行程常駐 — 接下來的這一節就要討論這方面的細節。

## GitWeb ##

現在我們的專案已經有了可讀可寫和唯讀的連接方式，不過如果能有一個簡單的 web 介面存取就更好了。Git 自帶一個叫做 GitWeb 的 CGI 腳本，執行效果可以到 `http://git.kernel.org` 這樣的網站體驗下（見圖 4-1）。

Insert 18333fig0401.png
Figure 4-1. 基於網頁的 GitWeb 使用者介面

如果想看看自己專案的效果，不妨用 Git 自帶的一個命令，可以使用類似 `lighttpd` 或 `webrick` 這樣羽量級的伺服器啟動一個臨時行程。如果是在 Linux 主機上，通常都預裝了 `lighttpd` ，可以到專案目錄中鍵入 `git instaweb` 來啟動。如果用的是 Mac ，Leopard 預裝了 Ruby，所以 `webrick` 應該是最好的選擇。如果要用 lighttpd 以外的程式來啟動 `git instaweb`，可以通過 `--httpd` 選項指定：

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

這會在 1234 埠開啟一個 HTTPD 服務，隨之在流覽器中顯示該頁，十分簡單。關閉服務時，只需在原來的命令後面加上 `--stop` 選項就可以了：

	$ git instaweb --httpd=webrick --stop

如果需要為團隊或者某個開源專案長期執行 GitWeb，那麼 CGI 腳本就要由正常的網頁服務來執行。一些 Linux 發行版本可以通過 `apt` 或 `yum` 安裝一個叫做 `gitweb` 的套裝軟體，不妨首先嘗試一下。我們將快速介紹一下手動安裝 GitWeb 的流程。首先，你需要 Git 的原始碼，其中帶有 GitWeb，並能生成定制的 CGI 腳本：

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb
	$ sudo cp -Rf gitweb /var/www/

注意，通過指定 `GITWEB_PROJECTROOT` 變數告訴編譯命令 Git 倉庫的位置。然後，設定 Apache 以 CGI 方式執行該腳本，增加一個 VirtualHost 設定：

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

不難想像，GitWeb 可以使用任何相容 CGI 的網頁服務來執行；如果偏向使用其他 web 伺服器，設定也不會很麻煩。現在，通過 `http://gitserver` 就可以線上存取倉庫了，在 `http://git.server` 上還可以通過 HTTP 克隆和取得倉庫的內容。

## Gitosis ##

把所有用戶的公開金鑰保存在 `authorized_keys` 檔的做法，只能湊和一陣子，當用戶數量達到幾百人的規模時，管理起來就會十分痛苦。每次改刪用戶都必須登錄伺服器不去說，這種做法還缺少必要的許可權管理 — 每個人都對所有專案擁有完整的讀寫許可權。

幸好我們還可以選擇應用廣泛的 Gitosis 專案。簡單地說，Gitosis 就是一套用來管理 `authorized_keys` 檔和實現簡單連接限制的腳本。有趣的是，用來增加用戶和設定許可權的並非通過網頁程式，而只是管理一個特殊的 Git 倉庫。你只需要在這個特殊倉庫內做好相應的設定，然後推送到伺服器上，Gitosis 就會隨之改變執行策略，聽起來就很酷，對吧？

Gitosis 的安裝算不上傻瓜化，但也不算太難。用 Linux 伺服器架設起來最簡單 — 以下例子中，我們使用裝有 Ubuntu 8.10 系統的伺服器。

Gitosis 的工作依賴於某些 Python 工具，所以首先要安裝 Python 的 setuptools 包，在 Ubuntu 上稱為 python-setuptools：

	$ apt-get install python-setuptools

接下來，從 Gitosis 專案主頁克隆並安裝：

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

這會安裝幾個供 Gitosis 使用的工具。預設 Gitosis 會把 `/home/git` 作為存儲所有 Git 倉庫的根目錄，這沒什麼不好，不過我們之前已經把專案倉庫都放在 `/opt/git` 裡面了，所以為方便起見，我們可以做一個符號連接，直接劃轉過去，而不必重新設定：

	$ ln -s /opt/git /home/git/repositories

Gitosis 將會幫我們管理用戶公開金鑰，所以先把目前控制檔改名備份，以便稍後重新增加，準備好讓 Gitosis 自動管理 `authorized_keys` 文件：

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

接下來，如果之前把 `git` 用戶的登錄 shell 改為 `git-shell` 命令的話，先恢復 'git' 用戶的登錄 shell。改過之後，大家仍然無法通過該帳號登錄（譯注：因為 `authorized_keys` 檔已經沒有了。），不過不用擔心，這會交給 Gitosis 來實現。所以現在先打開 `/etc/passwd` 檔，把這行：

	git:x:1000:1000::/home/git:/usr/bin/git-shell

改回:

	git:x:1000:1000::/home/git:/bin/sh

好了，現在可以初始化 Gitosis 了。你可以用自己的公開金鑰執行 `gitosis-init` 命令，要是公開金鑰不在伺服器上，先臨時複製一份：

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

這樣該公開金鑰的擁有者就能修改用於設定 Gitosis 的那個特殊 Git 倉庫了。接下來，需要手工對該倉庫中的 `post-update` 腳本加上可執行許可權：

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

基本上就算是好了。如果設定過程沒出什麼差錯，現在可以試一下用初始化 Gitosis 的公開金鑰的擁有者身份 SSH 登錄伺服器，應該會看到類似下面這樣：

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	ERROR:gitosis.serve.main:Need SSH_ORIGINAL_COMMAND in environment.
	  Connection to gitserver closed.

說明 Gitosis 認出了該用戶的身份，但由於沒有執行任何 Git 命令，所以它切斷了連接。那麼，現在執行一個實際的 Git 命令 — 克隆 Gitosis 的控制倉庫：

	# 在你本地電腦上
	$ git clone git@gitserver:gitosis-admin.git

這會得到一個名為 `gitosis-admin` 的工作目錄，主要由兩部分組成：

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

`gitosis.conf` 檔是用來設定用戶、倉庫和許可權的控制檔。`keydir` 目錄則是保存所有具有存取權限用戶公開金鑰的地方— 每人一個。在 `keydir` 裡的檔案名（比如上面的 `scott.pub`）應該跟你的不一樣 — Gitosis 會自動從使用 `gitosis-init` 腳本導入的公開金鑰尾部的描述中取得該名字。

看一下 `gitosis.conf` 檔的內容，它應該只包含與剛剛克隆的 `gitosis-admin` 相關的資訊：

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	members = scott
	writable = gitosis-admin

它顯示使用者 `scott` — 初始化 Gitosis 公開金鑰的擁有者 — 是唯一能管理 `gitosis-admin` 專案的人。

現在我們來增加一個新專案。為此我們要建立一個名為 `mobile` 的新段落，在其中羅列手機開發團隊的開發者，以及他們擁有寫許可權的專案。由於 'scott' 是系統中的唯一使用者，我們把他設為唯一用戶，並允許他讀寫名為 `iphone_project` 的新專案：

	[group mobile]
	members = scott
	writable = iphone_project

修改完之後，提交 `gitosis-admin` 裡的改動，並推送到伺服器使其生效：

	$ git commit -am 'add iphone_project and mobile group'
	[master 8962da8] add iphone_project and mobile group
	 1 file changed, 4 insertions(+)
	$ git push origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 272 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:gitosis-admin.git
	   fb27aec..8962da8  master -> master

在新工程 `iphone_project` 裡首次推送資料到伺服器前，得先設定該伺服器地址為遠端倉庫。但你不用事先到伺服器上手工建立該專案的裸倉庫— Gitosis 會在第一次遇到推送時自動建立：

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

請注意，這裡不用指定完整路徑（實際上，如果加上反而沒用），只需要一個冒號加專案名字即可 — Gitosis 會自動幫你映射到實際位置。

要和朋友們在一個專案上協同工作，就得重新增加他們的公開金鑰。不過這次不用在伺服器上一個一個手工增加到 `~/.ssh/authorized_keys` 檔末端，而只需管理 `keydir` 目錄中的公開金鑰檔。文件的命名將決定在 `gitosis.conf` 中對使用者的標識。現在我們為 John，Josie 和 Jessica 增加公開金鑰：

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

然後把他們都加進 'mobile' 團隊，讓他們對 `iphone_project` 具有讀寫許可權：

	[group mobile]
	members = scott john josie jessica
	writable = iphone_project

如果你提交並推送這個修改，四個用戶將同時具有該專案的讀寫許可權。

Gitosis 也具有簡單的存取控制功能。如果想讓 John 只有讀許可權，可以這樣做：

	[group mobile]
	members = scott josie jessica
	writable = iphone_project

	[group mobile_ro]
	members = john
	readonly = iphone_project

現在 John 可以克隆和取得更新，但 Gitosis 不會允許他向專案推送任何內容。像這樣的組可以隨意建立，多少不限，每個都可以包含若干不同的用戶和專案。甚至還可以指定某個組為成員之一（在組名前加上 `@` 首碼），自動繼承該組的成員：

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	members   = @mobile_committers
	writable  = iphone_project

	[group mobile_2]
	members   = @mobile_committers john
	writable  = another_iphone_project

如果遇到意外問題，試試看把 `loglevel=DEBUG` 加到 `[gitosis]` 的段落（譯注：把日誌設定為調試級別，記錄更詳細的執行資訊。）。如果一不小心搞錯了設定，失去了推送許可權，也可以手工修改伺服器上的 `/home/git/.gitosis.conf` 檔 — Gitosis 實際是從該檔讀取資訊的。它在得到推送資料時，會把新的 `gitosis.conf` 存到該路徑上。所以如果你手工編輯該檔的話，它會一直保持到下次向 `gitosis-admin` 推送新版本的設定內容為止。

## Gitolite ##

This section serves as a quick introduction to Gitolite, and provides basic installation and setup instructions.  不能完全替代隨 gitolite 自帶的大量文檔。 There may also be occasional changes to this section itself, so you may also want to look at the latest version [here][gldpg].

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

Gitolite is an authorization layer on top of Git, relying on `sshd` or `httpd` for authentication.  (Recap: authentication is identifying who the user is, authorization is deciding if he is allowed to do what he is attempting to).

Gitolite 允許你定義存取許可而不只作用於倉庫，而同樣於倉庫中的每個branch和tag name。你可以定義確切的人 (或一組人) 只能push特定的 "refs" (或者branches或者tags)而不是其他人。

### 安裝 ###

安裝 Gitolite非常簡單, 你甚至不用讀自帶的那一大堆文檔。你需要一個unix伺服器上的帳戶；許多linux變種和solaris 10都已經試過了。你不需要root存取，假設git，perl，和一個openssh相容的ssh伺服器已經裝好了。在下面的例子裡，我們會用 `git` 帳戶在 `gitserver`上.

Gitolite 是不同於 "server" 的軟體 -- 通過ssh存取, 而且每個在伺服器上的userid都是一個潛在的 "gitolite host". We will describe the simplest install method in this article; for the other methods please see the documentation.

To begin, create a user called `git` on your server and login to this user.  Copy your SSH public key (a file called `~/.ssh/id_rsa.pub` if you did a plain `ssh-keygen` with all the defaults) from your workstation, renaming it to `<yourname>.pub` (we'll use `scott.pub` in our examples).  Then run these commands:

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	    # assumes $HOME/bin exists and is in your $PATH
	$ gitolite setup -pk $HOME/scott.pub

That last command creates new Git repository called `gitolite-admin` on the server.

Finally, back on your workstation, run `git clone git@gitserver:gitolite-admin`. And you’re done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in your workstation.  You administer your Gitolite setup by making changes to this repository and pushing.

### 定制安裝 ###

預設快速安裝對大多數人都管用，還有一些定制安裝方法如果你用的上的話。Some changes can be made simply by editing the rc file, but if that is not sufficient, there’s documentation on customising Gitolite.

### 設定檔和存取規則 ###

安裝結束後，你切換到 `gitolite-admin` 倉庫 (放在你的 HOME 目錄) 然後看看都有啥：

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/scott.pub
	$ cat conf/gitolite.conf

	repo gitolite-admin
	    RW+                 = scott

	repo testing
	    RW+                 = @all

注意 "scott" ( 之前用`gl-setup` 命令時候的 pubkey 名稱) 有讀寫許可權而且在 `gitolite-admin` 倉庫裡有一個同名的公開金鑰檔。

Adding users is easy.  To add a user called "alice", obtain her public key, name it `alice.pub`, and put it in the `keydir` directory of the clone of the `gitolite-admin` repo you just made on your workstation.  Add, commit, and push the change, and the user has been added.

gitolite設定檔的語法在 `conf/example.conf`裡，我們只會提到一些主要的。

你可以給用戶或者倉庫分組。分組名就像一些宏；定義的時候，無所謂他們是工程還是使用者；區別在於你’使用‘“宏”的時候

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

你可以控制許可在 "ref" 級別。在下面的例子裡，實習生可以 push "int" branch.  工程師可以 push任何有 "eng-"開頭的branch，還有refs/tags下面用 "rc"開頭的後面跟數字的。而且管理員可以隨便改 (包括rewind) 對任何參考名.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

在 `RW` or `RW+`之後的運算式是規則運算式 (regex) 對應著後面的push用的參考名字 (ref) 。所以我們叫它 "參考正則"（refex）！當然，一個 refex 可以比這裡表現的更強大，所以如果你對perl的規則運算式不熟的話就不要改過頭。

同樣，你可能猜到了，Gitolite 字頭 `refs/heads/` 是一個方便句法如果參考正則沒有用 `refs/`開頭。

一個這個設定檔語法的重要功能是，所有的倉庫的規則不需要在同一個位置。你能報所有普通的東西放在一起，就像上面的對所有 `oss_repos` 的規則那樣，然後建一個特殊的規則對後面的特殊案例，就像：

	repo gitolite
	    RW+                     = sitaram

那條規則剛剛加入規則集的 `gitolite` 倉庫.

這次你可能會想要知道存取控制規則是如何應用的，我們簡要介紹一下。

在gitolite裡有兩級存取控制。第一是在倉庫級別；如果你已經讀或者寫存取過了任何在倉庫裡的參考，那麼你已經讀或者寫存取倉庫了。

第二級，應用只能寫存取，通過在倉庫裡的 branch或者 tag。使用者名稱如果嘗試過存取 (`W` 或 `+`)，參考名被更新為已知。存取規則檢查是否出現在設定檔裡，為這個聯合尋找匹配 (但是記得參考名是正則匹配的，不是字串匹配的)。如果匹配被找到了，push就成功了。不匹配的存取會被拒絕。

### 帶'拒絕'的高級存取控制 ###

目前，我們只看過了許可是 `R`, `RW`, 或者 `RW+`這樣子的。但是gitolite還允許另外一種許可：`-`，代表 "拒絕"。這個給了你更多的能力，當然也有一點複雜，因為不匹配並不是唯一的拒絕存取的方法，因此規則的順序變得無關了！

這麼說好了，在前面的情況中，我們想要工程師可以 rewind 任意 branch 除了master和 integ。 這裡是如何做到的

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

你再一次簡單跟隨規則從上至下知道你找到一個匹配你的存取模式的，或者拒絕。非rewind push到 master或者 integ 被第一條規則允許。一個 rewind push到那些 refs不匹配第一條規則，掉到第二條，因此被拒絕。任何 push (rewind 或非rewind) 到參考或者其他 master 或者 integ不會被前兩條規則匹配，即被第三條規則允許。

### 通過改變檔限制 push ###

此外限制用戶 push改變到哪條branch的，你也可以限制哪個檔他們可以碰的到。比如, 可能 Makefile (或者其他哪些程式) 真的不能被任何人做任何改動，因為好多東西都靠著它呢，或者如果某些改變剛好不對就會崩潰。你可以告訴 gitolite:

    repo foo
        RW                      =   @junior_devs @senior_devs

        -   VREF/NAME/Makefile  =   @junior_devs

這是一個強力的公能寫在 `conf/example.conf`裡。

### 個人分支 ###

Gitolite 也支援一個叫 "個人分支"的功能 (或者叫, "個人分支命名空間") 在合作環境裡非常有用。

在 git世界裡許多代碼交換通過 "pull" 請求發生。然而在合作環境裡，委任制的存取是‘絕不’，一個開發者工作站不能認證，你必須push到中心伺服器並且叫其他人從那裡pull。

這個通常會引起一些 branch 名稱簇變成像 VCS裡一樣集中化，加上設定許可變成管理員的苦差事。

Gitolite讓你定義一個 "個人的" 或者 "亂七八糟的" 命名空間字首給每個開發人員 (比如，`refs/personal/<devname>/*`)；看在 `doc/3-faq-tips-etc.mkd`裡的 "personal branches" 一段取得細節。

### "萬用字元" 倉庫 ###

Gitolite 允許你定義帶萬用字元的倉庫 (其實還是 perl正則式), 比如隨便整個例子的話 `assignments/s[0-9][0-9]/a[0-9][0-9]`。 這是一個非常有用的功能，需要通過設定 `$GL_WILDREPOS = 1;` 在 rc文件中啟用。允許你安排一個新許可模式 ("C") 允許用戶建立倉庫基於萬用字元，自動分配擁有權對特定用戶 - 建立者，允許他交出 R和 RW許可給其他合作用戶等等。這個功能在`doc/4-wildcard-repositories.mkd`文檔裡

### 其他功能 ###

我們用一些其他功能的例子結束這段討論，這些以及其他功能都在 "faqs, tips, etc" 和其他文檔裡。

**記錄**: Gitolite 記錄所有成功的存取。如果你太放鬆給了別人 rewind許可 (`RW+`) 和其他孩子弄沒了 "master"， 記錄檔會救你的命，如果其他簡單快速的找到SHA都不管用。

**存取權報告**: 另一個方便的功能是你嘗試用ssh連接到伺服器的時候發生了什麼。Gitolite告訴你哪個 repos你存取過，那個存取可能是什麼。這裡是例子：

        hello scott, this is git@git running gitolite3 v3.01-18-g9609868 on git 1.7.4.4

             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**委託**：真正的大安裝，你可以把責任委託給一組倉庫給不同的人然後讓他們獨立管理那些部分。這個減少了主管理者的負擔，讓他瓶頸更小。這個功能在他自己的文檔目錄裡的 `doc/`下面。

**鏡像**: Gitolite可以幫助你維護多個鏡像，如果主要伺服器掛掉的話在他們之間很容易切換。

## Git 服務 ##

對於提供公開的，未經授權的唯讀存取，我們可以放棄 HTTP 協議，改用 Git 自己的協議，這主要是出於性能和速度的考慮。Git 協定遠比 HTTP 協定高效，因而存取速度也快，所以它能節省很多用戶的時間。

重申一下，這一點只適用於未經授權的唯讀存取。如果建在防火牆之外的伺服器上，那麼它所提供的服務應該只是那些公開的唯讀專案。如果是在防火牆之內的伺服器上，可用于支撐大量參與人員或自動系統（用於持續整合或編譯的主機）唯讀存取的專案，這樣可以省去逐一設定 SSH 公開金鑰的麻煩。

但不管哪種情形，Git 協定的設定設定都很簡單。基本上，只要以服務的形式執行該命令即可：

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

這裡的 `--reuseaddr` 選項表示在重啟服務前，不等之前的連接逾時就立即重啟。而 `--base-path` 選項則允許克隆專案時不必給出完整路徑。最後面的路徑告訴 Git 服務允許開放給使用者存取的倉庫目錄。假如有防火牆，則需要為該主機的 9418 埠設定為允許通訊。

以服務的形式執行該行程的方法有很多，但主要還得看用的是什麼作業系統。在 Ubuntu 主機上，可以用 Upstart 腳本達成。編輯該檔：

	/etc/event.d/local-git-daemon

加入以下內容：

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

出於安全考慮，強烈建議用一個對倉庫只有讀取許可權的使用者身份來執行該行程 — 只需要簡單地新建一個名為 `git-ro` 的用戶（譯注：新建用戶預設對倉庫檔不具備寫許可權，但這取決於倉庫目錄的許可權設定。務必確認 `git-ro` 對倉庫只能讀不能寫。），並用它的身份來啟動行程。這裡為了簡化，後面我們還是用之前執行 Gitosis 的用戶 'git'。

這樣一來，當你重啟電腦時，Git 行程也會自動啟動。要是行程意外退出或者被殺掉，也會自行重啟。在設定完成後，不重啟電腦就啟動該服務，可以執行：

	initctl start local-git-daemon

而在其他作業系統上，可以用 `xinetd`，或者 `sysvinit` 系統的腳本，或者其他類似的腳本 — 只要能讓那個命令變為服務並可監控。

接下來，我們必須告訴 Gitosis 哪些倉庫允許通過 Git 協議進行匿名唯讀存取。如果每個倉庫都設有各自的段落，可以分別指定是否允許 Git 行程開放給使用者匿名讀取。比如允許通過 Git 協議存取 iphone_project，可以把下面兩行加到 `gitosis.conf` 文件的末尾：

	[repo iphone_project]
	daemon = yes

在提交和推送完成後，執行中的 Git 服務就會回應來自 9418 埠對該專案的存取請求。

如果不考慮 Gitosis，單單起了 Git 服務的話，就必須到每一個允許匿名唯讀存取的倉庫目錄內，建立一個特殊名稱的空檔作為標誌：

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

該檔的存在，表示允許 Git 服務開放對該專案的匿名唯讀存取。

Gitosis 還能設定哪些專案允許放在 GitWeb 上顯示。先打開 GitWeb 的設定檔 `/etc/gitweb.conf`，增加以下四行：

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

接下來，只要設定各個專案在 Gitosis 中的 `gitweb` 參數，便能達成是否允許 GitWeb 用戶流覽該專案。比如，要讓 iphone_project 專案在 GitWeb 裡出現，把 `repo` 的設定改成下面的樣子：

	[repo iphone_project]
	daemon = yes
	gitweb = yes

在提交並推送過之後，GitWeb 就會自動開始顯示 iphone_project 專案的細節和歷史。

## Git 託管服務 ##

如果不想經歷自己架設 Git 伺服器的麻煩，網路上有幾個專業的倉庫託管服務可供選擇。這樣做有幾大優點：託管帳戶的建立通常比較省時，方便專案的啟動，而且不涉及伺服器的維護和監控。即使內部建立並執行著自己的伺服器，同時為開源專案提供一個公開託管網站還是有好處的 — 讓開源社區更方便地找到該專案，並給予幫助。

目前，可供選擇的託管服務數量繁多，各有利弊。在 Git 官方 wiki 上的 Githosting 頁面有一個最新的託管服務清單：

	https://git.wiki.kernel.org/index.php/GitHosting

由於本書無法全部一一介紹，而本人（譯注：指本書作者 Scott Chacon。）剛好在其中一家公司工作，所以接下來我們將會介紹如何在 GitHub 上建立新帳戶並啟動專案。至於其他託管服務大體也是這麼一個過程，基本的想法都是差不多的。

GitHub 是目前為止最大的開源 Git 託管服務，並且還是少數同時提供公開代碼和私有代碼託管服務的網站之一，所以你可以在上面同時保存開源和商業代碼。事實上，本書就是放在 GitHub 上合作編著的。（譯注：本書的翻譯也是放在 GitHub 上廣泛協作的。）

### GitHub ###

GitHub 和大多數的代碼託管網站在處理專案命名空間的方式上略有不同。GitHub 的設計更側重於用戶，而不是完全基於專案。也就是說，如果我在 GitHub 上託管一個名為 `grit` 的專案的話，它的位址不會是 `github.com/grit`，而是按在用戶底下 `github.com/shacon/grit` （譯注：本書作者 Scott Chacon 在 GitHub 上的使用者名稱是 `shacon`。）。不存在所謂某個專案的官方版本，所以假如第一作者放棄了某個專案，它可以無縫轉移到其它用戶的名下。

GitHub 同時也是一個向使用私有倉庫的用戶收取費用的商業公司，但任何人都可以方便快速地申請到一個免費帳戶，並在上面託管數量不限的開源專案。接下來我們快速介紹一下 GitHub 的基本使用。

### 建立新帳戶 ###

首先註冊一個免費帳戶。存取 "Plans and pricing" 頁面 `https://github.com/pricing` 並點選 Free acount 裡的 Sign Up 按鈕（見圖 4-2），進入註冊頁面。

Insert 18333fig0402.png
圖 4-2. GitHub 服務簡介頁面

選擇一個系統中尚未使用的使用者名稱，提供一個與之相關聯的電子郵件位址，並輸入密碼（見圖 4-3）：

Insert 18333fig0403.png
圖 4-3. GitHub 用戶註冊表單

如果方便，現在就可以提供你的 SSH 公開金鑰。我們在前文的"小型安裝" 一節介紹過生成新公開金鑰的方法。把新生成的公開金鑰複製粘貼到 SSH Public Key 文字方塊中即可。要是對生成公開金鑰的步驟不太清楚，也可以點選 "explain ssh keys" 連結，會顯示各個主流作業系統上完成該步驟的介紹。
點選 "I agree，sign me up" 按鈕完成使用者註冊，並轉到該使用者的 dashboard 頁面（見圖 4-4）:

Insert 18333fig0404.png
圖 4-4. GitHub 的用戶面板

接下來就可以建立新倉庫了。

### 建立新倉庫 ###

點選用戶面板上倉庫旁邊的 "create a new one" 連結，顯示 Create a New Repository 的表單（見圖 4-5）：

Insert 18333fig0405.png
圖 4-5. 在 GitHub 上建立新倉庫

當然，專案名稱是必不可少的，此外也可以適當描述一下專案的情況或者給出官方網站的位址。然後點選 "Create Repository" 按鈕，新倉庫就建立起來了（見圖 4-6）：

Insert 18333fig0406.png
圖 4-6. GitHub 上各個專案的概要資訊

由於尚未提交代碼，點選專案位址後 GitHub 會顯示一個簡要的指南，告訴你如何新建一個專案並推送上來，如何從現有專案推送，以及如何從一個公開的 Subversion 倉庫導入專案（見圖 4-7）：

Insert 18333fig0407.png
圖 4-7. 新倉庫指南

該指南和本書前文介紹的類似，對於新的專案，需要先在本地初始化為 Git 專案，增加要管理的檔並作首次提交：

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

然後在這個本地倉庫內把 GitHub 增加為遠端倉庫，並推送 master 分支上來：

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

現在該專案就託管在 GitHub 上了。你可以把它的 URL 分享給每位對此專案感興趣的人。本例的 URL 是 `http://github.com/testinguser/iphone_project`。而在專案頁面的摘要部分，你會發現有兩個 Git URL 位址（見圖 4-8）：

Insert 18333fig0408.png
圖 4-8. 專案摘要中的公開 URL 和私有 URL

Public Clone URL 是一個公開的，唯讀的 Git URL，任何人都可以通過它克隆該專案。可以隨意散播這個 URL，比如發佈到個人網站之類的地方等等。

Your Clone URL 是一個基於 SSH 協議的可讀可寫 URL，只有使用與上傳的 SSH 公開金鑰對應的金鑰來連接時，才能通過它進行讀寫操作。其他使用者存取該專案頁面時只能看到之前那個公開的 URL，看不到這個私有的 URL。

### 從 Subversion 導入專案 ###

如果想把某個公開 Subversion 專案導入 Git，GitHub 可以幫忙。在指南的最後有一個指嚮導入 Subversion 頁面的連結。點選它會看到一個表單，包含有關導入流程的資訊以及一個用來粘貼公開 Subversion 專案連接的文字方塊（見圖 4-9）：

Insert 18333fig0409.png
圖 4-9. Subversion 導入介面

如果專案很大，採用非標準結構，或者是私有的，那就無法借助該工具實現導入。到第 7 章，我們會介紹如何手工導入複雜工程的具體方法。

### 增加協作開發者 ###

現在把團隊裡的其他人也加進來。如果 John，Josie 和 Jessica 都在 GitHub 註冊了帳戶，要賦予他們對該倉庫的推送許可權，可以把他們加為專案協作者。這樣他們就可以通過各自的公開金鑰存取我的這個倉庫了。

點選專案頁面上方的 "edit" 按鈕或者頂部的 Admin 標籤，進入該專案的管理頁面（見圖 4-10）：

Insert 18333fig0410.png
圖 4-10. GitHub 的專案管理頁面

為了給另一個用戶增加專案的寫許可權，點選 "Add another collaborator" 連結，出現一個用於輸入使用者名稱的表單。在輸入的同時，它會自動跳出一個符合條件的候選名單。找到正確使用者名稱之後，點 Add 按鈕，把該使用者設為專案協作者（見圖 4-11）：

Insert 18333fig0411.png
圖 4-11. 為專案增加協作者

增加完協作者之後，就可以在 Repository Collaborators 區域看到他們的名單（見圖 4-12）：

Insert 18333fig0412.png
圖 4-12. 專案協作者名單

如果要取消某人的存取權，點選 "revoke" 即可取消他的推送許可權。對於將來的專案，你可以從現有專案複製協作者名單，或者直接借用協作者群組。

### 專案頁面 ###

在推送或從 Subversion 導入專案之後，你會看到一個類似圖 4-13 的專案主頁：

Insert 18333fig0413.png
圖 4-13. GitHub 上的專案主頁

別人存取你的專案時看到的就是這個頁面。它有若干導航標籤，Commits 標籤用於顯示提交歷史，最新的提交位於最上方，這和 `git log` 命令的輸出類似。Network 標籤示範所有派生了該專案並做出貢獻的用戶的關係圖譜。Downloads 標籤允許你上傳專案的二進位檔案，提供下載該專案各個版本的 tar/zip 包。Wiki 標籤提供了一個用於撰寫文檔或其他專案相關資訊的 wiki 網站。Graphs 標籤包含了一些視覺化的專案資訊與資料。預設打開的 Source 標籤頁面，則列出了該專案的目錄結構和概要資訊，並在下方自動示範 README 檔的內容（如果該檔存在的話），此外還會顯示最近一次提交的相關資訊。

### 派生專案 ###

如果要為一個自己沒有推送許可權的專案貢獻代碼，GitHub 鼓勵使用派生（fork）。到那個感興趣的專案主頁上，點選頁面上方的 "fork" 按鈕，GitHub 就會為你複製一份該專案的副本到你的倉庫中，這樣你就可以向自己的這個副本推送資料了。

採取這種辦法的好處是，專案擁有者不必忙於應付賦予他人推送許可權的工作。隨便誰都可以通過派生得到一個專案副本並在其中展開工作，事後只需要專案維護者將這些副本倉庫加為遠端倉庫，然後提取更新合併即可。

要派生一個專案，到原始專案的頁面（本例中是 mojombo/chronic）點選 "fork" 按鈕（見圖 4-14）：

Insert 18333fig0414.png
圖 4-14. 點選 "fork" 按鈕獲得任意專案的可寫副本

幾秒鐘之後，你將進入新增的專案頁面，會顯示該專案派生自哪一個專案（見圖 4-15）：

Insert 18333fig0415.png
圖 4-15. 派生後得到的專案副本

### GitHub 小結 ###

關於 GitHub 就先介紹這麼多，能夠快速達成這些事情非常重要（譯注：門檻的降低和完成基本任務的簡單高效，對於推動開源專案的協作發展有著舉足輕重的意義。）。短短幾分鐘內，你就能建立一個新帳戶，增加一個專案並開始推送。如果專案是開源的，整個龐大的開發者社區都可以立即存取它，提供各式各樣的幫助和貢獻。最起碼，這也是一種 Git 新手立即體驗嘗試 Git 的捷徑。

## 小結 ##

我們討論並介紹了一些建立遠端 Git 倉庫的方法，接下來你可以通過這些倉庫同他人分享或合作。

執行自己的伺服器意味著更多的控制權以及在防火牆內部操作的可能性，當然這樣的伺服器通常需要投入一定的時間精力來架設維護。如果直接託管，雖然能免去這部分工作，但有時出於安全或版權的考慮，有些公司禁止將商業代碼託管到協力廠商服務商。

所以究竟採取哪種方案，並不是個難以取捨的問題，或者其一，或者相互配合，哪種合適就用哪種。
