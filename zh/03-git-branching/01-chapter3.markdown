# Git 分支 #

几乎每一种版本控制系统都以某种形式支持分支。使用分支意味着你可以从开发主线上分离开来，然后在不影响主线的同时继续工作。在很多版本控制系统中，这是个昂贵的过程，常常需要创建一个源代码目录的完整副本，对大型项目来说会花费很长时间。

有人把 Git 的分支模型称为“必杀技特性”，而正是因为它，将 Git 从版本控制系统家族里区分出来。Git 有何特别之处呢？Git 的分支可谓是难以置信的轻量级，它的新建操作几乎可以在瞬间完成，并且在不同分支间切换起来也差不多一样快。和许多其他版本控制系统不同，Git 鼓励在工作流程中频繁使用分支与合并，哪怕一天之内进行许多次都没有关系。理解分支的概念并熟练运用后，你才会意识到为什么 Git 是一个如此强大而独特的工具，并从此真正改变你的开发方式。

## 何谓分支 ##

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

它们形如`(远程仓库名)/(分支名)`。假使你想看看上次和`origin`仓库通讯的时候`master`是什么样的，你应该查看`origin/master`分支。如果你和同伴一起修复某个问题而他们推送了一个`iss53`分支，虽然你可能也有一个本地的`iss53`分支，服务器上的分支却应该以`origin/iss53`指向其commit。

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

在你想和全世界分享一个分支的时候，你需要把它推送到一个你拥有写权限的远程仓库。你的本地分支不会自动的被同步到你写入的远程分支里——除非你特意把想要分享的分支推送出去。这样一来，你可以为你不想分享的部分建立私人的分支，同时只分享那些想要与其他人合作的特性分支。

如果你有个叫`serverfix`的分支需要和其他人一起开发，你可以用推送第一个分支的相同方法推送之。运行`git branch (远程仓库名) (分支名)`：

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

这其实有点像一条捷径。Git自动把`serverfix`分支名扩展为`refs/heads/serverfix:refs/heads/serverfix`，意为“取出我的serverfix本地分支，推送它来更新远程仓库的 serverfix分支。”我们将在第9章里进一步介绍`refs/heads/`部分的细节，不过通常你可以省略它。你也可以运行`git push origin serverfix:serferfix`来实现相同的效果——它的意思是“提取我的serverfix并把它设定为远程仓库的serverfix。”通过这个格式你可以把一个本地分支推送到一个命名不同的远程分支。如果不想它在远程被叫做`serverfix`，可以用`git push origin serverfix:awesomebranch`取而代之，它把你本地的`serverfix`分支推动到远程的`awesomebranch`分支。

当你的和作者们再次从服务器获取数据的时候，他们将得到一个指向`serverfix`在远程的`origin/serverfix`分支的索引：

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

值得强调的是，在一次fetch获得了新的远程分支以后，你不会自动获得本地的，可以编辑的副本。换句话说，在本例中，你不会有一个新的`serverfix`分支——只有一个你无法移动的`origin/serverfix`指针。

如果要把该内容合并到当前的分支，你可以运行`git merge origin/serverfix`。如果你想要一份自己的`serverfix`来进行开发，可以从远程分支上获得：

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

这将给你一个始于`origin/serverfix`位置的本地分支用来开发。

### 跟踪(tracking)分支 ###

从一个远程分支签出一个本地分支的操作会自动建立一个所谓的 _跟踪分支(tracking branch)_ 。跟踪分支是一种和远程分支有直接联系的本地分支。如果你在一个跟踪分支里输入git push，Git自动知道应该向那个服务器的哪个分支推送。同时，在这些分支里运行`git pull`会获取所有的远程索引并且把它们都合并到相应的本地分支。

在克隆一个仓库的时候，Git通常自动创建一个`master`分支来跟踪`origin/master`。这正是`git push`和`git pull`一开始就正常工作的原因。当然，你可以随心所有的设定其他的跟踪分支——那些不跟踪`origin`上的分支的，或者不跟踪`master`分支的。最简单的例子是你刚刚看到的，运行`git checkout -b [分支名] [远程名]/[分支名]`。如果你有1.6.2以上版本的Git，还可以用`--track``缩写：

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

要为本地分支设定一个不同于远程分支的名字，只需要在第一个版本的命令里换个名字：

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

现在你的本地分支sf会自动的向origin/serverfix推送和抓取了。

### 删除远程分支 ###

如果你不需要某个远程分支了——比如说，你和你的合作者搞定了某个特性并且把它合并进了远程的`master`分支（或者任何其他你们存放稳定代码的地方）。你可以用这个非常无厘头的语法来删除它：`git push [远程名] :[分支名]`。如果你想在服务器上删除`serverfix`分支，运行如下命令：

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

咚！服务器上的分支没了。你最好特别留心这一页，因为你一定会用到那个命令，而且你很可能会忘掉它的语法。一种方便记忆这条命令的方法是记住我们不久前见过的`git push [远程名] [本地分支]:[远程分支]`的语法。如果你省略`[本地分支]`的部分，那基本等于在说“在这里提取空白然后把它变成`[远程分支]`。”

在Git里主要有两种把一个分支整合到另一个分支里的办法：`merge（合并）`和`rebase（衍合）`。在本章你将学习什么事衍合，怎样使用它，它为什么是个异常有用的工具，以及你应该在什么情况下使用它。

### 衍合(rebasing)基础 ###

如果你回顾之前有关合并的一节（见图3-27），你会看到你的开发被分叉并在两个不同分支里进行了提交。

Insert 18333fig0327.png 
图 3-27. 最初分叉的提交历史。

之前介绍过，整合分支的最好方法是`merge`命令。它将使用两个分支最新的快照（C3和C4）以及二者最新的共同祖先（C2）来进行三方合并。如图3-28所示。

Insert 18333fig0328.png 
图 3-28. 通过合并一个分支来整合分叉了的历史。

其实，还有另外一个选择：你可以把在C3里产生的变化补丁重新在C4的基础上打一变。在Git里，这叫做 _衍合(rebasing)_ 。有了`rebase`命令，你就可以把在一个分支里提交的改变在另一个分支里重放一遍。

在这个例子里，你需要运行如下命令：

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

它的原理是回到两个分支（你所在的分支和你想要衍合进去的分支）的共同祖先，提取你所在分支每次提交时产生的差别(diff)，把这些差别保存到临时文件里，从当前分支转换到你需要衍合入的分支，最后依序施用每一个差别文件。图3-29演示了这一过程。

Insert 18333fig0329.png 
图 3-29. 把C3里产生的改变衍合到C4中。

现在，你可以回到master分支然后进行一次快进合并（见图3-30）。

Insert 18333fig0330.png 
图 3-30. master分支的快进。

现在，C3指向的镜像和合并例子里C5指向的内容一模一样了。最后整合的结果没有任何区别，不过衍合能产生一个更整洁的历史。如果你视察一个衍合过分支的记录(log)，它看起来更清楚：仿佛所有修改都是先后进行的，尽管它们原来是同时发生的。

经常的，你可能通过它来保证你的提交在远程分支里更清晰——很可能是一个你想要帮忙但自己又不是维护者的项目。如果是这样，你需要在一个分支里进行开发，在你准备向主项目提交补丁的时候把它衍合到`origin/master`里面。那样，维护者不需要做任何整合工作——只需要快进或者简单的打补丁。

注意结果里你最后一次提交指向的快照，无论是通过一次衍合还是一次合并形成的，是同样的快照——只有提交历史是不同的。衍合按照每行改变发生的次序重演发生的改变，而合并是把最终结果合在一起。

### 更多有趣的衍合 ###

你还可以在衍合分支以外的地方衍合。以图3-31的历史为例。你创建了一个特性分支（`server`）来给服务器端添加一些功能，然后提交。然后你从那里再增加一个分支(`client`）来对客户端进行一些修改，进行几次提交。最后，你回到server分支又提交了几次。

Insert 18333fig0331.png 
图 3-31. 从一个特性分支里再分出一个特性分支的历史。

假设你决定为一次发布把客户端的变化合并到主线中，而在进一步测试之前暂缓服务端的变化。你可以仅提取对客户端的改变（C8和C9）然后通过使用`git rebase`的`--onto`选项来把它们在master分支上重演：

	$ git rebase --onto master server client

这基本上等于在说“签出client分支，找出`client`分支和`server`分支共同祖先之后发生的变化，然后把它们在`master`上重演一遍。是不是有点复杂？不过它的结果，如图3-32所示，非常酷：

Insert 18333fig0332.png 
图 3-32. 衍合一个特性分支上的另一个特性分支。

现在可以快进master分支了（见图3-33）：

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
图 3-33. 快进master分支，使之包含client分支的变化。

现在你决定把server分支的变化也包含进来。你可以直接把server分支衍合到master而不用事先通过`git rebase [主分支] [特性分支]`来签出它——后者签出特性分支（本例中指`server`）然后在主分支上（本例中指`master`）重演：

	$ git rebase master server

这会把`server`的进度应用到`master`的基础上，如图3-34。

Insert 18333fig0334.png 
图 3-34. 在master分支上衍合server分支。

然后，你可以快进主分支（`master'）：

	$ git checkout master
	$ git merge server

现在`client`和`server`分支的变化都被整合了，不妨删掉它们，把你的提交历史变成图3-35的样子：

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
图 3-35. 最终的提交历史

### 衍合的风险 ###

呃，奇妙的衍合也不是完美无缺的，一句话可以总结这点：

**永远不要衍合那些已经推送到公共仓库的commit。**

如果你遵循这条金科玉律，就不会出差错。如果不遵循，人民会仇恨你，而且你将糟到朋友和家人的一致谴责（译注：^_^）。

在你衍合的时候，实际上抛弃了一些现存的commit而创造了一些类似但不同的新commit。如果你把commit推送到某处然后其他人下载并在其基础上工作，然后你用`git rebase`重写了这些commit再推送一次，你的和作者们将不得不重新合并他们的工作，这样当你再次从他们那里获取内容的时候事情就会变得一团糟。

我们用一个例子来说明为什么公开的衍合会带来问题。假设你从一个中央服务器克隆然后在它的基础上搞了一些开发。你的提交历史类似图3-36。

Insert 18333fig0336.png 
图 3-36. 克隆一个仓库，在其基础上工作一番。

现在，其他人进行了一些包含一次合并的工作，然后把它推送到了中央服务器。你获取了这些并把新的远程分支里的内容合并到你的开发进程里，让你的历史变成类似图3-37这样：

Insert 18333fig0337.png 
图 3-37. 获取更多commit，并入你的开发进程。

接下来，那个推送带有合并的工作的人决定用衍合取代那次合并；他们用`git push --force`覆盖了服务器上的历史。然后你再从服务器上获取它，得到新的变化。

Insert 18333fig0338.png 
图 3-38. 有人推送了衍合过的commit，丢弃了你作为开发基础的commit。

这时候，你需要再次合并这些内容，尽管之前已经做过一次了。衍合会改变这些commit的SHA-1校验值，这样Git会把它们当作新的commit，然而这时候在你的提交历史早就有了C4的内容（见图3-39）。

Insert 18333fig0339.png 
图 3-39. 你把相同的内容又合并了一遍，生成一个新的commit。

你或早或晚必须要并入那些内容，这样才能和其他开发者在将来保持同步。当你做完这些，你的提交历史里会同时包含C4和C4'，二者有着不同的SHA-1校验值却拥有一样的作者日期与附加信息，令人费解！更糟糕的是，当你把这样的历史推送到服务器，会再次把这些衍合的commit引入了中央服务器，进一步的迷惑其他人。

如果把衍合当成一种在推送之前清理提交历史的手段，而且你仅衍合那些永远不会公开的commit，那不会有任何问题。如果你衍合那些已经公开的commit，而其他人已经用这些commit进行了一些工作，那么你会遇到令人沮丧的麻烦。

## 小结 ##

我们介绍了Git基本的分支与合并。你应该熟悉了如何创建并转换到新分支，在不同分支间转换以及合并本地分支。你还学会了如何把分支推送到共享服务器上来和世界分享它们，与他人在共享的分支上合作以及在分享之前进行衍合。
