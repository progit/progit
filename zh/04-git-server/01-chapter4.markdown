# 服务器上的 Git #

到目前为止，你应该已经学会了使用 Git 来完成日常的工作。然而，如果想与他人合作，你还需要一个远程的 Git 仓库。尽管技术上可以从个人的仓库里推送和获取修改，但是我们不鼓励这样做，因为你一不小心就很容易困惑其他人到底在干什么。另外，你也一定希望你的合作者们即使在你不开机的时候也能从仓库获取数据——拥有一个更稳定的公共仓库通常是很有必要的。因此，更好的合作方式是建立一个大家都可以访问的共享仓库，并向那里推送和获取数据。我们将把这个仓库称为“Git 服 务器”；你不过你会发现架设一个 Git 仓库只需要花费一点点的资源，所以很少需要整个服务器来支持运行它。

架设一个 Git 服务器不难。第一步是选择与服务器通讯的协议。本章的第一节将介绍可用的协议以及他们各自的优缺点。下面一节将介绍一些针对各个协议典型的设置以及如何在服务器上运行它们。最后，如果你不介意在其他人的服务器上保存你的代码，又不想经历自己架设和维护服务器的麻烦，我们将介绍几个网络上的仓库托管服务。

如果你对架设自己的服务器没兴趣，可以跳到本章最后一节去看看如何创建一个代码托管账户然后继续下一章，我们会在那里讨论一个分布式源码控制环境的林林总总。

远程仓库通常只是一个 _纯仓库(bare repository)_ ——一个没有当前工作目录的仓库。因为该仓库只是一个合作媒介，所以不需要从一个处于已从硬盘上签出状态的快照；仓库里仅仅是 Git 的数据。简单的说，纯仓库是你项目里 `.git` 目录的内容，别无他物。

## 协议 ##

Git 可以使用四种主要的协议来传输数据：本地传输，SSH 协议，Git 协议和 HTTP 协议。下面分别介绍一下他们以及你应该（或不应该）在怎样的情形下使用他们。

值得注意的是除了 HTTP 协议之外，其他所有协议都要求在服务器端安装并运行 Git 。

### 本地协议 ###

最基础的就是 _本地协议(Local protocol)_ 了，远程仓库在该协议中就是硬盘上的另一个目录。这常见于团队每一个成员都对一个共享的文件系统(例如 NFS )拥有访问权，抑或比较少见的多人共用同一台电脑的时候。后者不是很理想，因为你所有的代码仓库实例都储存在同一台电脑里，增加了灾难性数据损失的可能性。

如果你使用一个共享的文件系统，就可以在一个本地仓库里克隆，推送和获取。要从这样的仓库里克隆或者将其作为远程仓库添加现有工程里，可以用指向该仓库的路径作为URL。比如，克隆一个本地仓库，可以用如下命令完成：

	$ git clone /opt/git/project.git

或者这样：

	$ git clone file:///opt/git/project.git
如果你在URL的开头明确的使用 `file://` ，那么 Git 会以一种略微不同的方式运行。如果你只给出路径，Git 会尝试使用硬链接或者直接复制它需要的文件。如果使用了 `file://` ，Git会调用它平时通过网络来传输数据的工序，而这种方式的效率相对很低。使用 `file://` 前缀的主要原因是当你需要一个不包含无关引用或对象的干净仓库副本的时候——一般是从其他版本控制系统的导入之后或者类似的情形（参见第9章的维护任务）。我们这里使用普通路径，因为通常这样总是更快。

要添加一个本地仓库到现有 Git 工程，运行如下命令：

	$ git remote add local_proj /opt/git/project.git

然后就可以像在网络上一样向这个远程仓库推送和获取数据了。

#### 优点 ####

基于文件仓库的优点在于它的简单，同时保留了现存文件的权限和网络访问权限。如果你的团队已经有一个全体共享的文件系统，建立仓库就十分容易了。你只需把一份纯仓库的副本放在大家能访问的地方，然后像对其他共享目录一样设置读写权限就可以了。我们将在下一节“在服务器上部署 Git ”中讨论如何为此导出一个纯仓库的副本。

这也是个从别人工作目录里获取他工作成果的快捷方法。假如你和你的同事在一个项目中合作，他们想让你签出一些东西的时候，运行类似 `git pull /home/john/project` 通常会比他们推送到服务器，而你又从服务器获取简单得多。

#### 缺点 ####

这种方法的缺点是，与基本的网络连接访问相比，能从不同的位置访问的共享权限难以架设。如果你想从家里的笔记本电脑上推送，就要先挂载远程硬盘，这和基于网络连接的访问相比更加困难和缓慢。

另一个很重要的问题是该方法不一定就是最快的，尤其是对于共享挂载的文件系统。本地仓库只有在你对数据访问速度快的时候才快。在同一个服务器上，如果二者同时允许 Git 访问本地硬盘，通过 NFS 访问仓库通常会比 SSH 慢。

### SSH 协议 ###

Git 使用的传输协议中最常见的可能就是 SSH 了。这是因为大多数环境已经支持通过 SSH 对服务器的访问——即使还没有，也很容易架设。SSH 也是唯一一个同时便于读和写操作的网络协议。另外两个网络协议（HTTP 和 Git）通常都是只读的，所以虽然二者对大多数人都可用，但执行写操作时还是需要 SSH。SSH 同时也是一个验证授权的网络协议；而因为其普遍性，通常也很容易架设和使用。

通过 SSH 克隆一个Git仓库，你可以像下面这样给出 ssh:// 的 URL：

	$ git clone ssh://user@server:project.git

或者不指明某个协议——这时Git会默认使用 SSH ：
	
	$ git clone user@server:project.git

也可以不指明用户，Git 会默认使用你当前登录的用户。 

#### 优点 ####

使用 SSH 的好处有很多。首先，如果你想拥有对网络仓库的写权限，基本上不可能不使用SSH。其次，SSH 架设相对比较简单—— SSH 守护进程很常见，很多网络管理员都有一些使用经验，而且很多操作系统都自带了它或者相关的管理工具。再次，通过 SSH 进行访问是安全的——所有数据传输都是加密和授权的。最后，类似 Git 和 本地协议，SSH 很高效，会在传输之前尽可能的压缩数据。

#### 缺点 ####

SSH 的限制在于你不能通过它实现仓库的匿名访问。即使仅为读取数据，人们也必须在能通过 SSH 访问主机的前提下才能访问仓库，这使得 SSH 不利于开源的项目。如果你仅仅在公司网络里使用，SSH 可能是你唯一需要使用的协议。如果想允许对项目的匿名只读访问，那么除了为自己推送而架设 SSH 协议之外，还需要其他协议来让别人获取数据。

### Git 协议 ###

接下来是 Git 协议。这是一个包含在 Git 软件包中的特殊守护进程； 它会监听一个提供类似于 SSH 服务的特定端口（9418），而无需任何授权。用 Git 协议运营仓库，你需要创建 `git-export-daemon-ok` 文件——它是协议进程提供仓库服务的必要条件——但除此之外该服务没有什么安全措施。要么所有人都能克隆Git 仓库，要么谁也不能。这也意味着该协议通常不能用来进行推送。你可以允许推送操作；然而由于没有授权机制，一旦允许该操作，网络上任何一个知道项目 URL 的人将都有推送权限。不用说，这是十分罕见的情况。

#### 优点 ####

Git 协议是现存最快的传输协议。如果你在提供一个有很大访问量的公共项目，或者一个不需要对读操作进行授权的庞大项目，架设一个 Git 守护进程来供应仓库是个不错的选择。它使用与 SSH 协议相同的数据传输机制，但省去了加密和授权的开销。

#### 缺点 ####

Git 协议消极的一面是缺少授权机制。用 Git 协议作为访问项目的唯一方法通常是不可取的。一般做法是，同时提供 SSH 接口，让几个开发者拥有推送（写）权限，其他人通过 `git://` 拥有只读权限。
Git 协议可能也是最难架设的协议。它要求有单独的守护进程，需要定制——我们将在本章的 “Gitosis” 一节详细介绍它的架设——需要设定 `xinetd` 或类似的程序，而这些就没那么平易近人了。该协议还要求防火墙开放 9418 端口，而企业级防火墙一般不允许对这个非标准端口的访问。大型企业级防火墙通常会封锁这个少见的端口。

### HTTP/S 协议 ###

最后还剩下 HTTP 协议。HTTP 或 HTTPS 协议的优美之处在于架设的简便性。基本上，
只需要把 Git 的纯仓库文件放在 HTTP 的文件根目录下，配置一个特定的 `post-update` 挂钩（hook），就搞定了（Git 挂钩的细节见第七章）。从此，每个能访问 Git 仓库所在服务器上的 web 服务的人都可以进行克隆操作。下面的操作可以允许通过 HTTP 对仓库进行读取：

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

这样就可以了。Git 附带的 `post-update` 挂钩会默认运行合适的命令（`git update-server-info`）来确保通过 HTTP 的获取和克隆正常工作。这条命令在你用 SSH 向仓库推送内容时运行；之后，其他人就可以用下面的命令来克隆仓库：

	$ git clone http://example.com/gitproject.git

在本例中，我们使用了 Apache 设定中常用的 `/var/www/htdocs` 路径，不过你可以使用任何静态 web 服务——把纯仓库放在它的目录里就行了。 Git 的数据是以最基本的静态文件的形式提供的（关于如何提供文件的详情见第9章）。

通过HTTP进行推送操作也是可能的，不过这种做法不太常见并且牵扯到复杂的 WebDAV 架设。由于很少用到，本书将略过对该内容的讨论。如果你对 HTTP 推送协议感兴趣，不妨在这个地址看一下如何操作：`http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` 。通过 HTTP 推送的好处之一是你可以使用任何 WebDAV 服务器，不需要为 Git 设定特殊环境；所以如果主机提供商支持通过 WebDAV 更新网站内容，你也可以使用这项功能。

#### 优点 ####

使用 HTTP 协议的好处是易于架设。几条必要的命令就可以让全世界读取到仓库的内容。花费不过几分钟。HTTP 协议不会占用过多服务器资源。因为它一般只用到静态的 HTTP 服务提供所有的数据，普通的 Apache 服务器平均每秒能供应数千个文件——哪怕是让一个小型的服务器超载都很难。

你也可以通过 HTTPS 提供只读的仓库，这意味着你可以加密传输内容；你甚至可以要求客户端使用特定签名的 SSL 证书。一般情况下，如果到了这一步，使用 SSH 公共密钥可能是更简单的方案；不过也存在一些特殊情况，这时通过 HTTPS 使用带签名的 SSL 证书或者其他基于 HTTP 的只读连接授权方式是更好的解决方案。

HTTP 还有个额外的好处：HTTP 是一个如此常见的协议，以至于企业级防火墙通常都允许此端口的通信。

#### 缺点 ####

HTTP 协议的消极面在于，相对来说客户端效率更低。克隆或者下载仓库内容可能会花费更多时间，而且 HTTP 传输的体积和网络开销比其他任何一个协议都大。因为它没有按需供应的能力——传输过程中没有服务端的动态计算——因而 HTTP 协议经常会被称为 _傻瓜(dumb)_ 协议。更多 HTTP 协议和其他协议效率上的差异见第九章。

## 在服务器部署 Git ##

开始架设 Git 服务器的时候，需要把一个现存的仓库导出为新的纯仓库——不包含当前工作目录的仓库。方法非常直截了当。
把一个仓库克隆为纯仓库，可以使用 clone 命令的 `--bare` 选项。纯仓库的目录名以 `.git` 结尾， 如下：

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

该命令的输出有点迷惑人。由于 `clone` 基本上等于 `git init` 加 `git fetch`，这里出现的就是 `git init` 的输出，它建立了一个空目录。实际的对象转换不会有任何输出，不过确实发生了。现在在 `my_project.git` 中已经有了一份 Git 目录数据的副本。

大体上相当于

	$ cp -Rf my_project/.git my_project.git

在配置文件中有几个小改变；不过从效果角度讲，克隆的内容是一样的。它仅包含了 Git 目录，没有工作目录，并且专门为之（译注： Git 目录）建立了一个单独的目录。

### 将纯目录转移到服务器 ###

有了仓库的纯副本以后，剩下的就是把它放在服务器上并设定相关的协议。假设一个域名为 `git.example.com` 的服务器已经架设好，并可以通过 SSH 访问，而你想把所有的 Git 仓库储存在 `/opt/git` 目录下。只要把纯仓库复制上去：

	$ scp -r my_project.git user@git.example.com:/opt/git

现在，其他对该服务器具有 SSH 访问权限并可以读取 `/opt/git` 的用户可以用以下命令克隆：

	$ git clone user@git.example.com:/opt/git/my_project.git

假如一个 SSH 用户对 `/opt/git/my_project.git` 目录有写权限，他会自动具有推送权限。这时如果运行 `git init` 命令的时候加上 `--shared` 选项，Git 会自动对该仓库加入可写的组。

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

可见选择一个 Git 仓库，创建一个纯的版本，最后把它放在你和同事都有 SSH 访问权的服务器上是多么容易。现在已经可以开始在同一项目上密切合作了。

值得注意的是，这的的确确是架设一个少数人具有连接权的 Git 服务的全部——只要在服务器上加入可以用 SSH 接入的帐号，然后把纯仓库放在大家都有读写权限的地方。一切都做好了，无须更多。

下面的几节中，你会了解如何扩展到更复杂的设定。这些内容包含如何避免为每一个用户建立一个账户，给仓库添加公共读取权限，架设网页界面，使用 Gitosis 工具等等。然而，只是和几个人在一个不公开的项目上合作的话，仅仅是一个 SSH 服务器和纯仓库就足够了，请牢记这一点。

### 小型安装 ###

如果设备较少或者你只想在小型的开发团队里尝试 Git ，那么一切都很简单。架设 Git 服务最复杂的方面之一在于账户管理。如果需要仓库对特定的用户可读，而给另一部分用户读写权限，那么访问和许可的安排就比较困难。

#### SSH 连接 ####

如果已经有了一个所有开发成员都可以用 SSH 访问的服务器，架设第一个服务器将变得异常简单，几乎什么都不用做（正如上节中介绍的那样）。如果需要对仓库进行更复杂的访问控制，只要使用服务器操作系统的本地文件访问许可机制就行了。

如果需要团队里的每个人都对仓库有写权限，又不能给每个人在服务器上建立账户，那么提供 SSH 连接就是唯一的选择了。我们假设用来共享仓库的服务器已经安装了 SSH 服务，而且你通过它访问服务器。

有好几个办法可以让团队的每个人都有访问权。第一个办法是给每个人建立一个账户，直截了当但过于繁琐。反复的运行 `adduser` 并且给所有人设定临时密码可不是好玩的。

第二个办法是在主机上建立一个 `git` 账户，让每个需要写权限的人发送一个 SSH 公钥，然后将其加入 `git` 账户的 `~/.ssh/authorized_keys` 文件。这样一来，所有人都将通过 `git` 账户访问主机。这丝毫不会影响提交的数据——访问主机用的身份不会影响commit的记录。

另一个办法是让 SSH 服务器通过某个 LDAP 服务，或者其他已经设定好的集中授权机制，来进行授权。只要每个人都能获得主机的 shell 访问权，任何可用的 SSH 授权机制都能达到相同效果。

## 生成 SSH 公钥 ##

话虽如此，大多数 Git 服务器使用 SSH 公钥来授权。为了得到授权，系统中的每个没有公钥用户都得生成一个新的。该过程在所有操作系统上都差不多。
首先，确定一下是否已经有一个公钥了。SSH 公钥默认储存在账户的 `~/.ssh` 目录。进入那里并查看其内容，有没有公钥一目了然：

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

关键是看有没有用 文件名 和 文件名.pub 来命名的一对文件，这个 文件名 通常是 `id_dsa` 或者 `id_rsa`。 `.pub` 文件是公钥，另一个文件是密钥。假如没有这些文件（或者干脆连 `.ssh` 目录都没有），你可以用 `ssh-keygen` 的程序来建立它们，该程序在 Linux/Mac 系统由 SSH 包提供， 在 Windows 上则包含在 MSysGit 包里：

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

它先要求你确认保存公钥的位置（`.ssh/id_rsa`），然后它会让你重复一个密码两次，如果不想在使用公钥的时候输入密码，可以留空。

现在，所有做过这一步的用户都得把它们的公钥给你或者 Git 服务器的管理者（假设 SSH 服务被设定为使用公钥机制）。他们只需要复制 `.put` 文件的内容然后 e-email 之。公钥的样子大致如下：

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

关于在多个操作系统上设立相同 SSH 公钥的教程，可以在 GitHub 有关 SSH 公钥的向导中找到：`http://github.com/guides/providing-your-ssh-key`。

## 架设服务器 ##

现在我们过一边服务器端架设 SSH 访问的流程。本例将使用 `authorized_keys` 方法来给用户授权。我们还将假定使用类似 Ubuntu 这样的标准 Linux 发行版。首先，创建一个 'git' 用户并为其创建一个 `.ssh` 目录（译注：在用户的主目录下）。

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

接下来，把开发者的 SSH 公钥添加到这个用户的 `authorized_keys` 文件中。假设你通过 e-mail 收到了几个公钥并存到了临时文件里。重复一下，公钥大致看起来是这个样子：

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

只要把它们加入 `authorized_keys` 文件（译注：本例加入到了文件尾部）：

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

现在可以使用 `--bare` 选项运行 `git init` 来设定一个空仓库，这会初始化一个不包含工作目录的仓库。

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

这时，Join，Josie 或者 Jessica 就可以把它加为远程仓库，推送一个分支，从而把第一个版本的工程上传到仓库里了。值得注意的是，每次添加一个新项目都需要通过 shell 登入主机并创建一个纯仓库。我们不妨以 `gitserver` 作为 `git` 用户和仓库所在的主机名。如果你在网络内部运行该主机，并且在 DNS 中设定 `gitserver` 指向该主机，那么以下这些命令都是可用的：

	# 在 John 的电脑上
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

这样，其他人的克隆和推送也一样变得很简单：

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

用这个方法可以很快捷的为少数几个开发者架设一个可读写的 Git 服务。

作为一个额外的防范措施，你可以用 Git 自带的 `git-shell` 简单工具来把 `git` 用户的活动限制在仅与 Git 相关。把它设为 `git` 用户登入的 shell，那么该用户就不能拥有主机正常的 shell 访问权。为了实现这一点，需要指明用户的登入shell 是 `git-shell` ，而不是 bash 或者 csh。你可能得编辑 `/etc/passwd` 文件：

	$ sudo vim /etc/passwd

在文件末尾，你应该能找到类似这样的行：

	git:x:1000:1000::/home/git:/bin/sh

把 `bin/sh` 改为 `/usr/bin/git-shell` （或者用 `which git-shell` 查看它的位置）。该行修改后的样子如下：

	git:x:1000:1000::/home/git:/usr/bin/git-shell

现在 `git` 用户只能用 SSH 连接来推送和获取 Git 仓库，而不能直接使用主机 shell。尝试登录的话，你会看到下面这样的拒绝信息：

	$ ssh git@gitserver
	fatal: What do you think I am? A shell? （你以为我是个啥？shell吗？)
	Connection to gitserver closed. （gitserver 连接已断开。）

## 公共访问 ##

匿名的读取权限该怎么实现呢？也许除了内部私有的项目之外，你还需要托管一些开源项目。抑或你使用一些自动化的服务器来进行编译，或者一些经常变化的服务器群组，而又不想整天生成新的 SSH 密钥——总之，你需要简单的匿名读取权限。

或许对小型的配置来说最简单的办法就是运行一个静态 web 服务，把它的根目录设定为 Git 仓库所在的位置，然后开启本章第一节提到的 `post-update` 挂钩。这里继续使用之前的例子。假设仓库处于 `/opt/git` 目录，主机上运行着 Apache 服务。重申一下，任何 web 服务程序都可以达到相同效果；作为范例，我们将用一些基本的 Apache 设定来展示大体需要的步骤。

首先，开启挂钩：

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

假如使用的 Git 版本小于 1.6，那 `mv` 命令可以省略—— Git 是从较晚的版本才开始在挂钩实例的结尾添加 .sample 后缀名的。

`post-update` 挂钩是做什么的呢？其内容大致如下：

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

意思是当通过 SSH 向服务器推送时，Git 将运行这个命令来更新 HTTP 获取所需的文件。

其次，在 Apache 配置文件中添加一个 VirtualHost 条目，把根文件（译注： DocumentRoot 参数）设定为 Git 项目的根目录。假定 DNS 服务已经配置好，会把 `.gitserver` 发送到任何你所在的主机来运行这些：

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

另外，需要把 `/opt/git` 目录的 Unix 用户组设定为 `www-data` ，这样 web 服务才可以读取仓库内容，因为 Apache 运行 CGI 脚本的模块（默认）使用的是该用户：

	$ chgrp -R www-data /opt/git

重启 Apache 之后，就可以通过项目的 URL 来克隆该目录下的仓库了。

	$ git clone http://git.gitserver/project.git

这一招可以让你在几分钟内为相当数量的用户架设好基于 HTTP 的读取权限。另一个提供非授权访问的简单方法是开启一个 Git 守护进程，不过这将要求该进程的常驻——下一节将是想走这条路的人准备的。

## 网页界面 GitWeb ##

如今我们的项目已经有了读写和只读的连接方式，也许应该再架设一个简单的网页界面使其更加可视化。为此，Git 自带了一个叫做 GitWeb 的 CGI 脚本。你可以在类似 `http://git.kernel.org` 这样的站点找到 GitWeb 的应用实例（见图 4-1）。

Insert 18333fig0401.png 
Figure 4-1. 基于网页的 GitWeb 用户界面

如果想知道项目的 GitWeb 长什么样，Git 自带了一个命令，可以在类似 `lighttp	 或 `webrick` 这样轻量级的服务器程序上打开一个临时的实例。在 Linux 主机上通常都安装了 `lighttpd` ，这时就可以在项目目录里输入 `git instaweb` 来运行它。如果使用的是 Mac ，Leopard 预装了 Ruby，所以 `webrick` 应该是最好的选择。使用 lighttpd 以外的程序来启用 `git instaweb`， 可以通过它的 `--httpd` 选项来实现。

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

这会在 1234 端口开启一个 HTTPD 服务，随之在浏览器中显示该页。简单的很。需要关闭服务的时候，只要使用相同命令的 `--stop` 选项就好了：

	$ git instaweb --httpd=webrick --stop

如果需要为团队或者某个开源项目长期的运行 web 界面，那么 CGI 脚本就要由正常的网页服务来运行。一些 Linux 发行版可以通过 `apt` 或 `yum` 安装一个叫做 `gitweb` 的软件包，不妨首先尝试一下。我们将快速的介绍一下手动安装 GitWeb 的流程。首先，你需要 Git 的源码，其中带有 GitWeb，并能生成 CGI 脚本：

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

注意通过指定 `GITWEB_PROJECTROOT` 变量告诉编译命令 Git 仓库的位置。然后，让 Apache 来提供脚本的 CGI，为此添加一个 VirtualHost：

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

不难想象，GitWeb 可以使用任何兼容 CGI 的网页服务来运行；如果偏向使用其他的（译注：这里指Apache 以外的服务），配置也不会很麻烦。现在，通过 `http://gitserver` 就可以在线访问仓库了，在 `http://git.server` 上还可以通过 HTTP 克隆和获取仓库的内容。
Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## 权限管理器 Gitosis ##

把所有用户的公钥保存在 `authorized_keys` 文件的做法只能暂时奏效。当用户数量到了几百人的时候，它会变成一种痛苦。每一次都必须进入服务器的 shell，而且缺少对连接的限制——文件里的每个人都对所有项目拥有读写权限。

现在，是时候向广泛使用的软件 Gitosis 求救了。Gitosis 简单的说就是一套用来管理 `authorized_keys` 文件和实现简单连接限制的脚本。最有意思的是，该软件用来添加用户和设定权限的界面不是网页，而是一个特殊的 Git 仓库。你只需要设定好某个项目；然后推送，Gitosis 就会随之改变服务器设定，酷吧？

Gitosis 的安装算不上傻瓜化，不过也不算太难。用 Linux 服务器架设起来最简单——以下例子中的服务器使用 Ubuntu 8.10 系统。

Gitosis 需要使用部分 Python 工具，所以首先要安装 Python 的 setuptools 包，在 Ubuntu 中名为 python-setuptools：

	$ apt-get install python-setuptools

接下来，从项目主页克隆和安装 Gitosis：

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

这会安装几个 Gitosis 用的可执行文件。现在，Gitosis 想把它的仓库放在 `/home/git`，倒也可以。不过我们的仓库已经建立在 `/opt/git` 了，这时可以创建一个文件连接，而不用从头开始重新配置：

	$ ln -s /opt/git /home/git/repositories

Gitosis 将为我们管理公钥，所以当前的文件需要删除，以后再重新添加公钥，并且让 Gitosis 自动控制 `authorized_keys` 文件。现在，把 `authorized_keys`文件移走：

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

然后恢复 'git' 用户的 shell，假设之前把它改成了 `git-shell` 命令。其他人仍然不能通过它来登录系统，不过这次有 Gitosis 帮我们实现。所以现在把 `/etc/passwd` 文件的这一行

	git:x:1000:1000::/home/git:/usr/bin/git-shell

恢复成:

	git:x:1000:1000::/home/git:/bin/sh

现在就可以初始化 Gitosis 了。需要通过自己的公钥来运行 `gitosis-init`。如果公钥不在服务器上，则必须复制一份：

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

这样该公钥的拥有者就能修改包含着 Gitosis 设置的那个 Git 仓库了。然后手动将这个新的控制仓库中的 	`post-update` 脚本加上执行权限。

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

万事俱备了。如果设定过程没出什么差错，现在可以试一下用初始化 Gitosis 公钥的拥有者身份 SSH 进服务器。看到的结果应该和下面类似：

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

说明 Gitosis 认出了该用户的身份，但由于没有运行任何 Git 命令所以它切断了连接。所以，现在运行一个确切的 Git 命令——克隆 Gitosis 的控制仓库：

	# 在自己的电脑上
	$ git clone git@gitserver:gitosis-admin.git

得到一个名为 `gitosis-admin` 的目录，主要由两部分组成：

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

`gitosis.conf` 文件是用来设置用户、仓库和权限的控制文件。`keydir` 目录则是保存所有具有访问权限用户公钥的地方——每人一个。你 `keydir` 中的文件名（前例中的 `scott.pub`）应该有所不同—— Gitosis 从使用 `gitosis-init` 脚本导入的公钥尾部的描述中获取该名。

看一下 `gitosis.conf` 的内容，它应该只包含与刚刚克隆的 `gitosis-admin` 相关的信息：

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

它显示用户 `scott` ——初始化 Gitosis 公钥的拥有者——是唯一能访问 `gitosis-admin` 项目的人。

现在我们添加一个新的项目。我们将添加一个名为 `mobile` 的新节段，在这里罗列手机开发团队的开发者以及他们需要访问权限的项目。由于 'scott' 是系统中的唯一用户，我们把它加成唯一的用户，从创建一个叫做 `iphone_project` 的新项目开始：

	[group mobile]
	writable = iphone_project
	members = scott

一旦修改了 `gitosis-admin` 项目的内容，只有提交并推送至服务器才能使之生效：

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

第一次向新工程 `iphone_project` 的推送需要在本地的版本中把服务器添加为一个 remote 然后推送。从此手动为新项目在服务器上创建纯仓库的麻烦就是历史了—— Gitosis 会在第一次遇到推送的时候自动创建它们：

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

注意到路径被忽略了（加上它反而没用），只有一个冒号加项目的名字—— Gitosis 会为你找到项目的位置。

要和朋友们共同在一个项目上共同工作，就得重新添加他们的公钥。不过这次不用在服务器上一个一个手动添加到 `~/.ssh/authorized_keys` 文件末端，而是在 `keydir` 目录为每一个公钥添加一个文件。文件的命名将决定在 `gitosis.conf` 文件中用户的称呼。现在我们为 John，Josie 和 Jessica 添加公钥：

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

然后把他们都加进 'mobile' 团队，让他们对 `iphone_project` 具有读写权限：

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

如果你提交并推送这个修改，四个用户将同时具有该项目的读写权限。

Gitosis 也具有简单的访问控制功能。如果想让 John 只有读权限，可以这样做：

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

现在 John 可以克隆和获取更新，但 Gitosis 不会允许他向项目推送任何内容。这样的组可以有尽可能有随意多个，每一个包含不同的用户和项目。甚至可以指定某个组为成员，来继承它所有的成员。

如果出现了什么问题，把 `loglevel=DEBUG` 加入到 `[gitosis]` 部分或许有帮助（译注：把日志设置到调试级别，记录更详细的信息）。如果你一不小心搞错了配置，失去了推送权限，可以手动修改服务器上的 `/home/git/.gitosis` 文件—— Gitosis 从该文件读取信息。一次推送会把 `gitosis.conf` 保存在服务器上。如果你手动编辑该文件，它将在你下次向 `gitosis-admin` 推送之前它将保持原样。

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories – you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

	[repo iphone_project]
	daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved. 

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Figure 4-3. The GitHub user signup form

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Figure 4-4. The GitHub user dashboard

Next you can create a new repository. 

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Figure 4-5. Creating a new repository on GitHub

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Figure 4-6. GitHub project header information

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instructions for a new repository

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Figure 4-8. Project header with a public URL and a private URL

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Figure 4-9. Subversion importing interface

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Figure 4-10. GitHub administration page

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adding a collaborator to your project

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Figure 4-12. A list of collaborators on your project

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Figure 4-13. A GitHub main project page

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project 

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
