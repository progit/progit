# Git 分支 #

几乎每一个版本控制系统都以某种形式支持分支。使用分支意味着你从开发的主线上分离开来然后在不影响主线的同时继续工作。在很多版本控制系统中，这是个昂贵的过程，常常需要你创建源代码目录的一个副本，这个过程对于大型项目来说会花费很长的时间。

有人把Git的分支模式成为它的“必杀特性”，而它的确使得Git在版本控制系统的家族里一枝独秀。它为什么这么特别呢？Git的分支可谓是难以置信的轻量级，使得其创建操作几乎可以在瞬间完成并且在不同分支间的反复切换也差不多快。不同于很多其他的版本控制系统，Git鼓励在工作流程中经常性的分支与合并，哪怕在一天之内进行多次。理解和掌握这个特性你会获得一个强大而独特的工具，并且真正的改变你开发的方式。

## 什么是分支(branch) ##

为了真正弄明白Git分支的方式，我们需要回顾一下Git储存其数据的方式。你或许还记得第一章的内容，Git不以文件差异或者变化量的形式保存数据，而是保存一系列的镜像。

你在Git中提交的时候，Git会保存一个commit对象，它包含一个指向你缓存内容快照的指针，作者和相关附属信息，以及一定数量（可能为零）的指向该commit对象的直接祖先的指针：第一次提交有没有直接祖先，普通的提交有一个祖先，由两个或多个分支合并产生的提交具有多个祖先。

为了更直观，我们假设有个一包含3个文件的目录，并且你将他们暂存并提交。暂存操作会对每一个文件进行校验（在第一章中提到的SHA-1哈希），把这个版本的文件保存到Git仓库(Git使用blobs引用它们)，并且将校验值加入暂存区域：

	$ git add README test.rb LICENSE2
	$ git commit -m 'initial commit of my project'

当你使用git commit创建一个commit，Git会校验每一个子目录（本例中仅工程的根目录）并且在Git仓库中保存这些Tree对象。然后Git会创建一个commit对象，包含相关附加信息和一个指向工程目录树的指针，如此它就可以在需要的时候重建这个快照了。

你的Git仓库现在包含了5个对象：对应3个文件的blob对象，一个列举根目录内容以及各文件与blog对象对应关系的tree对象，以及一个包含指向根树和附加信息的commit对象。概念上，你Git仓库里的数据看起来如图3-1所示：

Insert 18333fig0301.png 
图3-1. 一次提交后仓库里的数据

如果你做了一写修改然后再一次提交，这次提交包含一个指向上次提交的指针。两次提交以后，仓库历史会变成图3-2的样子：

Insert 18333fig0302.png 
图3-2. 多次提交后的Git对象 

Git中的一个分支仅仅是一个轻巧的指向一个commit的可变指针。Git里默认的分支名字为master。初次提交若干次后，你其实已经拥有一个指向最后一次提交的master分支。它在你每一次提交的时候自动向前移动。

Insert 18333fig0303.png 
图3-3. 指向提交数据历史的分支

创建一个新分支的时候会发生什么事情呢？答案是你会有一个新的指针来四处移动。比如你创建了一个叫做testing的新分支。创建它的命令是`git branch`:

	$ git branch testing

这将在你当前所在的commit建立一个新的指针（见图3-4）。

Insert 18333fig0304.png 
图 3-4. 多个分支指向提交数据的历史

Git如何知道你当前在哪一个分支工作呢？它保存一个名为HEAD的特别指针。请注意它和你熟知的许多其他版本控制里的HEAD概念大不相同,比如Subversion或CVS。在Git中，它是一个指向你正在工作的本地分支的指针。在本例中，你仍然处于master。git branch命令仅仅建立一个新分支——而不会进入这个分支（参考图3-5）。

Insert 18333fig0305.png 
图 3-5. HEAD文件指向你所在的分支

要转换到某个现存的分支，你需要执行`git checkout`命令。我们现在转换到新建的testing分支：

	$ git checkout testing

这样HEAD就指向了testing分支（见图3-6）。

Insert 18333fig0306.png
图3-6. HEAD在你转换分支的时候指向了另一分支

这一点有什么重要性吗？我们不妨再进行一次提交：

	$ vim test.rb
	$ git commit -a -m 'made a change'

图3-7 展示了提交后的结果。

Insert 18333fig0307.png 
图3-7. HEAD指向的分支在每次提交后向前移动

非常有趣，因为现在你的testing分支向前移动了，但你的master分支仍然指向你使用`git checkout`来转换分支时所在的commit。现在我们转回master分支：

	$ git checkout master

图 3-8 显示了结果。

Insert 18333fig0308.png 
图 3-8. HEAD在一次checkout之后移动到了另一个分支。

这条命令做了两件事。它把HEAD指针移回了master分支，并且它把你工作目录里的文件换成了master指向快照里的内容。这也意味这你在这里作出的改变将始于本工程中一个较旧的版本。它的主要作用是将你在testing分支里做出的改变暂时取消，这样你就可以向另一个方向进行开发。

我们做一些修改然后再一次提交：

	$ vim test.rb
	$ git commit -a -m 'made other changes'

现在你工程的历史产生了分叉（见图3-9）。你创建并转换到一个分支，在里面进行了一些工作，然后转换回你的主分支进行了另一些工作。这些改变分别孤立在不同的分支里：你可以在不同分支里反复切换并且在时机成熟的时候把它们合并在一起。而你仅用了`branch`和`checkout`命令就做到了这些。

Insert 18333fig0309.png 
图 3-9. 分叉了的分支历史

由于一个分支实际仅仅是Git中一个包含它所指向内容的40字符SHA-1校验值的文件，创建和销毁一个分支就变的非常廉价。创建一个新分支可以快捷和简单到向一个文件写入41个字节（40个字符加一个换行符）。

这和大多数版本控制系统管理分支的方法形成鲜明的对比，它们的方法涉及到把所有的工程文件复制到另一个目录里。该过程可能要花掉数秒甚至数分钟，取决于工程的体积，而Git永远可以在瞬间完成。同时，因为每次提交的时候记录了祖先的信息，寻找合并分支时恰当的合并基础的工走已经自动完成并且非常容易。这些特性能够鼓励开发者经常性的创建和使用分支。

我们来看看为什么你应该这么做。

## 基本的分支与合并(merge) ##

现在使用一个简单的分支与合并的例子来演示一下你可能在现实中使用的工作流行。你将遵循以下步骤：

1.	在一个网站上工作。
2.	为你的一个新作品创建一个分支。
3.	在这个分支上做一些工作。

在这个阶段，你接到一个电话说有一个很严重的突发问题需要紧急修补。你会做下面这些事情：

1.	返回你的主分支。
2.	为这次紧急修补建立一个新分支。
3.	经过测试，合并这个修补分支，把它推送到主分支。
4.	转换到你原来的作品继续工作。

### 基本分支 ###

首先，我们假设你正在你的项目中工作并且已经进行了几次提交：（见图 3-10）。

Insert 18333fig0310.png 
图 3-10. 一段短小简单的提交历史

你决定修补公司的问题追踪系统上的问题#53。顺便声明，Git并不依附任何问题追踪系统；但因为问题#53是一个你想修补的关键问题，你会它创建一个新分支。要建立一个新分支同时转换进去，运行`git checkout`并加上`-b`参数：

	$ git checkout -b iss53
	Switched to a new branch "iss53"

这是以下命令的简写：

	$ git branch iss53
	$ git checkout iss53

图 3-11 示意该命令的结果。

Insert 18333fig0311.png 
图 3-11. 创建一个新分支指针

你在你的网站上工作并进行一些提交。这会让`iss53`分支向前推进，因为它处于签出的状态（或者说，你的HEAD指针目前指向它，见图3-12）：

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
图 3-12. iss53分支随你的工作向前推进

现在你就接到了那个网站问题的紧急电话，需要马上修补。在Git里，你不需要同时发布这个补丁和你在`iss53`里作出的修改，也不需要在创建和发布该补丁到服务器之前花费很多努力来复原这些修改。唯一需要的仅仅是转换回你的master分支：

不过，在这之前，留心你的暂存区或者工作目录里那些还没有提交的修改，它会和你即将签出的分支产生冲突从而阻止Git为你转换分支。转换分支的时候最好保持一个清洁的工作区域。有几个可以绕过这个问题的办法（stashing和amending）将在以后给出。目前你已经提交了所有的修改，所以你可以转换到master分支：

	$ git checkout master
	Switched to branch "master"

这时候，项目目录里的内容和你在解决问题#53之前一模一样，你可以集中精力进行紧急修补。这一点值得牢记：Git会把你目录的内容恢复为你签出某分支时它所指向的那个commit的快照。它会自动的添加，删除和修改文件以确保目录的内容和你上次提交时完全一样。

接下来，你得进行紧急修补。我们创建一个紧急修补(译注：命名为hotfix)分支来进行工作，直到搞定（见图 3-13）

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
图 3-13. 从master原点分支出来的hotfix分支

你可以进行一些测试，确保修补是成功的，然后把它合并到master分支并发布到服务器。用`git merge`命令来进行合并：

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

注意合并时出现的"Fast forward"（快进）提示。由于所并入的分支指向一个位于被并入分支直接上游的commit，Git只需要把指针（译注：所并入分支的指针，例中的master）直接前移。换句话说，如果顺着一个分支走下去可以到达另一个分支，那Git在二者合并的时候只会简单的把指针前移，因为没有什么分歧需要解决——这个过程叫做一次“快进(Fast forward)。

现在你的修改进入了master分支指向的commit里的快照，可以发布了（见图3-14）。

Insert 18333fig0314.png 
图 3-14. 合并之后，你的master分支和hotfix分支指向同一位置。

在那个超级重要的修补发布以后，你想要回到被打扰之前的工作。不过你想先删掉`hotfix`分支，因为它已经没用了——`master`指向相同的地方。你可以用`git branch`的`-d`选项删除之：

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

现在可以回到未完成的问题#53分支继续工作了（图3-15）：

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
图 3-15. iss53分支可以不受影响继续推进。

`hotfix`分支的内容没有包含在`iss53`不值得担心。如果需要它的存在，你可以用`git merge master`把master分支合并得到`iss53`，或者等到你把`iss53`分支整合到`master`的时候。

### 基本合并 ###

假设你觉得问题#53相关的工作已经完成并且可以合并到`master`分支了。要这样做，你可以用与之前合并`hotfix`分支差不多的方式来合并`iss53`。只需签出你想要合并进去的分支并运行`git merge`命令：

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

看上去这次和`hotfix`的合并有一点不同。这一次，你的开发历史是从更早的地方开始分叉的。由于你目前分支的位置不是你想要并入分支的直接祖先，Git不得不进行一些处理。本例中，Git会用两个分支的末端和他们的共同祖先进行一次三方合并。图3-16标出了Git在例中用来合并的三个快照：

Insert 18333fig0316.png 
图 3-16. Git为分支合并自动识别出最佳的同源合并点。

Git没有简单的把分支指针前移，而是创建了一个包含三方合并结果的新快照并且自动创建一个指向它的commit。（见图3-17）。这个commit被称为一个合并提交(merge commit)，它是一个包含多个祖先的特殊commit。

值得一提的是Git可以自己决定哪个共同祖先是最佳的合并基础；这和CVS或者Subversion(1.5以前的版本)是不同的：后者需要进行合并的开发者来寻找最佳的合并基础。该特性让Git的合并操作比其他系统要简单不少。

Insert 18333fig0317.png 
图 3-17. Git自动创建了一个包含了合并结果的commit对象。

既然你的工作成果已经合并了，`iss53`也就没用了。你可以就此删除它，并且从你的问题追踪系统里把该问题关闭。

	$ git branch -d iss53

### 简单冲突(conflicts)的合并 ###

有些时候，合并操作不会这么顺利。如果你同时修改了两个待合并分支里同一个文件的同一部分，Git就无法干净的把二者合并在一起。如果你在解决问题#53的时候修改了`hotfix`中修改的部分，你将得到一个类似如下的结果：

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git还没有自动创建一个新的合并提交。它会暂停下来等待你解决冲突。如果你想看下哪些文件在合并冲突中没被合并，可以使用`git status`：

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

任何包含未解决冲突的文件都会以尚未合并(unmerged)的状态被列出。Git会在有冲突的文件里加入标准的冲突解决标记，你可以通过它们来手工解决这些冲突。这些文件将包含一些类似下面这样的部分：

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

这表示在HEAD（你的master，在运行merge命令的时候签出的分支）的版本在上半部分（`=======`之前的内容），而在`iss53`分支的内容在下面。解决冲突的办法无非是二者选其一或者由你亲自整合到一起。比如你可以通过把它替换为如下这样来解决：

	<div id="footer">
	please contact us at email.support@github.com
	</div>

这个结局方案包括了两者的各一部分，而且我还删除了`<<<<<<<`，`=======`，和`>>>>>>>`这些行。解决了所有文件里的所有冲突以后，运行`git add`将把它们标记为已解决（resolved）。在Git缓存中为已解决冲突。
如果你想用一个有图形界面的工具来解决这些问题，不妨运行`git mergetool`，它会调启用一个可视化的合并工具并引导你解决所有冲突：

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

如果不想用默认的合并工具（Git为我默认选择了`opendiff`，因为我在Mac上运行了该命令），你可以在上方"merge tool candidates（候选合并工具）"里找到可用的合并工具的列表。输入你想用的工具名。在第7章，我们将讨论怎样改变环境中的默认值。

退出合并工具以后，Git会询问你合并是否成功。如果你告诉脚本是，它会为你把相关文件合并并标记为已解决。

再运行一次`git status`来确认所有冲突已经被解决：

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

如果觉得满意了，并且确认所有解决的冲突都已经进入了缓存，你就可以用`git commit`来完成这次合并提交。提交的记录差不多是这样：

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

如果你想给将来看到这次合并的人一些方便，可以修改该信息来提供更多合并的细节——你都做了什么以及原因，如果这些不明显。

## 分支管理 ##

目前为止你已经创建，合并和删除了一些分支，我们现在关注一下几个分支管理系统，它们可能在你开始常规使用分支以后变得异常有帮助。

`git branch`命令不仅仅能创建和删除分支。如果你不加任何参数运行之，你将得到一个当前分支的清单：

	$ git branch
	  iss53
	* master
	  testing

注意看`master`分支前的`*`字符：它指出你当前签出的分支。这意味着如果你现在进行提交，`master`分支将由于你的进度前移。若要看一下各分支的最后一次commit，运行`git branch -v`：

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

另一个有用的选项是筛从该清单中筛选出你已经或尚未与当前分支合并的分支。为此从Git的1.5.6版本开始加入了有用的`--merge`和`--no-merged`选项。你可以用`git branch -merge`查看哪些分支已经被并入了当前分支：

	$ git branch --merged
	  iss53
	* master

由于你之前已经合并了`iss53`，你将在该列表中发现它。该列表中没有`*`在前面的分支通常都可以用`git branch -d`来删掉；你已经把他们包含的工作整合到了其他分支，所以你不会损失任何东西。

你可以用`git branch --no-merged`查看尚未合并的工作：

	$ git branch --no-merged
	  testing

这将显示剩余的分支。由于它们包含还没有被合并的工作，用`git branch -d`来删除的尝试将会失败：

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.

如果你坚信你要删除它，运行`git branch -D testing`。
如果你确实想要删掉这个分支同时丢失其中包含的工作，你可以用`-D`强制执行。

## 分支式工作流程 ##

如今你已经有了分支与合并的基础，你可以或者应该用它做点什么？在本节，我们将介绍一些由轻巧的分支带来的常见的工作流程，由此你可以决定是否在你自己的工作循环中使用它们。

### 长期(long-term）分支 ###

由于Git使用简单的三方合并，长期反复的从一个分支合并到另一个分支通常是很容易的。这意味着你可以拥有多个开放的分支用来进行不同阶段的开发；你可以经常性的把一个合并到另一个里。

许多Git开发者在其工作流程中采用该方法，比如在`master`分支里只保留完全稳定的代码——唯一已经或将要发布的代码。他们还有一个平行的分支名为develop或者next来进行工作或者进行稳定性测试 —— 它不一定永远稳定，不过一旦进入一个稳定状态，它便可以被合并到`master`里。其的作用是从已完成的特性分支（短期分支，如前例的`iss53`分支）里提取(pull)内容，从而确保这些分支的内容通过所有的测试并且不引入更多错误。

实际上，我们讨论的是随着你创造的commit不停前移的指针。稳定分支在你提交的历史里比较落后，而前沿的分支则遥遥领先（见图3-18）。

Insert 18333fig0318.png 
图 3-18. 更稳定的分支通常比较落后。

可能把它们想象成工作流水线比较容易理解，经过测试的commit集合被遴选到更稳定的流水线。

Insert 18333fig0319.png 
图 3-19. 想象成流水线可能会容易点。

你可以用这招维护不同层次的稳定性。一些更大的项目还会有一个`proposed(建议)'或`pu`(proposed updates，建议更新)分支，它包含着那些可能还没有成熟到进入`next`或`master`的分支。这样的目的是你拥有了不同层次的稳定性；当这些分支进入到更稳定的水平的时候，你再把它们合并到更高层次中去。
使用多个长期分支不一定是必要的，但通常都会有帮助，尤其是在你应付非常大型或者复杂的工程的时候。

### 特性(Topic)分支 ###

特性分支在任何规模的项目中都十分有用。一个特性分支是一个短期的，用来实现单一特性或与其相关工作的分支。这可能是你在以前的版本控制系统里从未做过的事请，因为通常创建和合并分支消耗太大。然而在Git中，一天之内建立，使用，合并再删除多个分支是常见的事。

你在上节`iss53`和`hotfix`分支的例子里已经见过了。你向它们进行几次提交然后在合并到主分支以后彻底删除之。该技术允许你迅速和完全的进行语境切换——因为你的工作分散在不同的流水线里，每个分支里的改变都和它的目标特性相关，浏览代码之类的事情因而变得更简单了。你可以把做出的改变保持在其中几分钟，几天或者几个月，等它们成熟以后再合并，而不用在乎他们建立的顺序或者进度。

设想在一个例子中做一点工作（在`master`里），分出一个问题解决分支（`iss91`），在该分支里工作一会，分出另一个分支来尝试用不同的方法来解决同一个问题（`iss91v2`），返回master分支然后在那里再工作一下，再从那里分支尝试一个你不太确定的想法（`dumbidea`分支）。你的提交历史将变成图 3-20 这样。

Insert 18333fig0320.png 
图 3-20. 拥有多个特性分支的提交历史。

现在，假定你决定第二个解决方案是最好的（`iss91v2`）；你拿`dumbidea`分支给你的同事们看了以后发现它竟然是个天才之作。现在需要抛弃原来的`iss91`分支（失去C5和C6）并把另外两个分支并入。提交历史将变成图3-21这样。

Insert 18333fig0321.png 
图 3-21. 合并了dumbidea和iss91v2以后的历史。

牢记这些分支全部本地分支这一点很重要。当你在使用分支和合并的时候，一切都是在你自己的Git仓库里进行的——完全不涉及与服务器的交流。

## 远程(Remote)分支 ##

远程分支是对远程仓库状态的索引。它们是一些本地你无法移动的分支；只有在你进行Git的网络活动时才会移动。远程分支就像是一些书签,提醒着你上次连接远程仓库时上面各分支位置。 

它们形如`(远程仓库名)/(分支)`。假使你想看看上次和`origin`仓库通讯的时候`master`是什么样的，你应该查看`origin/master`分支。如果你和同伴一起修复某个问题而他们推送了一个`iss53`分支，虽然你可能也有一个本地的`iss53`分支，服务器上的分支却应该以`origin/iss53`指向其commit。

这可能有点混乱，我们不妨举例说明。假设你的团队有个地址为`git.ourcompany.com`的Git服务器。如果你从这里克隆，Git会自动为你将它（远程仓库）命名为`origin`，下载其中所有的数据，建立一个指向它`master`分支的指针，并在本地命名为`origin/master`，但你无法移动它。Git同时建立一个属于你的`master`分支，始于和origin上的master分支相同的位置，你可以就此开始工作（见图3-22）。

Insert 18333fig0322.png 
图 3-22. 一次Git克隆会建立一个你自己的master分支和一个origin/master并共同指向origin的master分支。

要是你在本地的master分支做了一点工作，与此同时，其他人向`git.ourcompany.com`推送了内容，更新了它的master分支，你的提交历史会开始朝不同的方向发展。不过只要你不和服务器通讯，你的`origin/master`指针不会移动。

Insert 18333fig0323.png 
图 3-23. 在本地工作的同时有人向远程仓库推送内容会让提交历史发生分歧。

你可以运行`git fetch origin`来进行同步。该命令首先找到origin是哪个服务器（本例中，结果是`git.ourcompany.com`），从上面获取你尚未拥有的数据，更新你本地的数据库，然后把`origin/master`移到它最新的位置（见图3-24）。

Insert 18333fig0324.png 
图 3-24. git fetch命令会更新你的remote索引。

为了演示拥有多个远程服务器的多个远程分支的项目是个什么样，我们假设你还有另一个仅供你的迅捷开发小组使用的内部服务器。该服务器处于`git.team1.ourcompany.com`。你可以用第二章中提到的`git remote add`命令把它加为当前项目的远程分支之一。我们把它命名为`teamone`，这就变成了那一整个URL的缩写（见图3-25）。

Insert 18333fig0325.png 
图 3-25. 把另一个服务器加为远程仓库

现在你可以用`git fetch teamone`来获取服务器上你还没有的数据了。因为这个服务器上的内容是你`origin`服务器上的子集，Git不会下载任何数据而是简单的创建一个叫`teamone/master`的分支来指向`teamone`在它的`master`里的commit（见图3-26）。

Insert 18333fig0326.png 
图 3-26. 你在本地有了一个指向teamone的master分支的索引。

### 推送(pushing) ###

When you want to share a branch with the world, you need to push it up to a remote that you have write access to. Your local branches aren’t automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share. That way, you can use private branches for work you don’t want to share, and push up only the topic branches you want to collaborate on.

If you have a branch named `serverfix` that you want to work on with others, you can push it up the same way you pushed your first branch. Run `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

This is a bit of a shortcut. Git automatically expands the `serverfix` branchname out to `refs/heads/serverfix:refs/heads/serverfix`, which means, “Take my serverfix local branch and push it to update the remote’s serverfix branch.” We’ll go over the `refs/heads/` part in detail in Chapter 9, but you can generally leave it off. You can also do `git push origin serverfix:serverfix`, which does the same thing — it says, “Take my serverfix and make it the remote’s serverfix.” You can use this format to push a local branch into a remote branch that is named differently. If you didn’t want it to be called `serverfix` on the remote, you could instead run `git push origin serverfix:awesomebranch` to push your local `serverfix` branch to the `awesomebranch` branch on the remote project.

The next time one of your collaborators fetches from the server, they will get a reference to where the server’s version of `serverfix` is under the remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

It’s important to note that when you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. In other words, in this case, you don’t have a new `serverfix` branch — you only have an `origin/serverfix` pointer that you can’t modify.

To merge this work into your current working branch, you can run `git merge origin/serverfix`. If you want your own `serverfix` branch that you can work on, you can base it off your remote branch:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

This gives you a local branch that you can work on that starts where `origin/serverfix` is.

### 跟踪(tracking)分支 ###

Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type git push, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.

When you clone a repository, it generally automatically creates a `master` branch that tracks `origin/master`. That’s why `git push` and `git pull` work out of the box with no other arguments. However, you can set up other tracking branches if you wish — ones that don’t track branches on `origin` and don’t track the `master` branch. The simple case is the example you just saw, running `git checkout -b [branch] [remotename]/[branch]`. If you have Git version 1.6.2 or later, you can also use the `--track` shorthand:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Now, your local branch sf will automatically push to and pull from origin/serverfix.

### 删除远程分支 ###

Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### 衍合(rebasing)基础 ###

If you go back to an earlier example from the Merge section (见图 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png 
图 3-27. Your initial diverged commit history

The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in 图 3-28.

Insert 18333fig0328.png 
图 3-28. Merging a branch to integrate the diverged work history

However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. 图 3-29 illustrates this process.

Insert 18333fig0329.png 
图 3-29. Rebasing the change introduced in C3 onto C4

At this point, you can go back to the master branch and do a fast-forward merge (见图 3-30).

Insert 18333fig0330.png 
图 3-30. Fast-forwarding the master branch

Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### 更多有趣的衍合 ###

You can also have your rebase replay on something other than the rebase branch. Take a history like 图 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
图 3-31. A history with a topic branch off another topic branch

Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
图 3-32. Rebasing a topic branch off another topic branch

Now you can fast-forward your master branch (见图 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
图 3-33. Fast-forwarding your master branch to include the client branch changes

Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
图 3-34. Rebasing your server branch on top of your master branch

Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
图 3-35. Final commit history

### 衍合的风险 ###

Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Do not rebase commits that you have pushed to a public repository.**

If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
图 3-36. Clone a repository, and base some work on it.

Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
图 3-37. Fetch more commits, and merge them into your work.

Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
图 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (见图 Figure 3-39).

Insert 18333fig0339.png 
图 3-39. You merge in the same work again into a new merge commit.

You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## 小结 ##

We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
