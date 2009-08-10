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

Occasionally, this process doesn’t go smoothly. If you changed the same part of the same file differently in the two branches you’re merging together, Git won’t be able to merge them cleanly. If your fix for issue #53 modified the same part of a file as the `hotfix`, you’ll get a merge conflict that looks something like this:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git hasn’t automatically created a new merge commit. It has paused the process while you resolve the conflict. If you want to see which files are unmerged at any point after a merge conflict, you can run `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Anything that has merge conflicts and hasn’t been resolved is listed as unmerged. Git adds standard conflict-resolution markers to the files that have conflicts, so you can open them manually and resolve those conflicts. Your file contains a section that looks something like this:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

This means the version in HEAD (your master branch, because that was what you had checked out when you ran your merge command) is the top part of that block (everything above the `=======`), while the version in your `iss53` branch looks like everything in the bottom part. In order to resolve the conflict, you have to either choose one side or the other or merge the contents yourself. For instance, you might resolve this conflict by replacing the entire block with this:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

This resolution has a little of each section, and I’ve fully removed the `<<<<<<<`, `=======`, and `>>>>>>>` lines. After you’ve resolved each of these sections in each conflicted file, run `git add` on each file to mark it as resolved. Staging the file marks it as resolved in Git.
If you want to use a graphical tool to resolve these issues, you can run `git mergetool`, which fires up an appropriate visual merge tool and walks you through the conflicts:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

If you want to use a merge tool other than the default (Git chose `opendiff` for me in this case because I ran the command on a Mac), you can see all the supported tools listed at the top after “merge tool candidates”. Type the name of the tool you’d rather use. In Chapter 7, we’ll discuss how you can change this default value for your environment.

After you exit the merge tool, Git asks you if the merge was successful. If you tell the script that it was, it stages the file to mark it as resolved for you.

You can run `git status` again to verify that all conflicts have been resolved:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

If you’re happy with that, and you verify that everything that had conflicts has been staged, you can type `git commit` to finalize the merge commit. The commit message by default looks something like this:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

You can modify that message with details about how you resolved the merge if you think it would be helpful to others looking at this merge in the future — why you did what you did, if it’s not obvious.

## 分支管理 ##

Now that you’ve created, merged, and deleted some branches, let’s look at some branch-management tools that will come in handy when you begin using branches all the time.

The `git branch` command does more than just create and delete branches. If you run it with no arguments, you get a simple listing of your current branches:

	$ git branch
	  iss53
	* master
	  testing

Notice the `*` character that prefixes the `master` branch: it indicates the branch that you currently have checked out. This means that if you commit at this point, the `master` branch will be moved forward with your new work. To see the last commit on each branch, you can run `git branch –v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Another useful option to figure out what state your branches are in is to filter this list to branches that you have or have not yet merged into the branch you’re currently on. The useful `--merged` and `--no-merged` options have been available in Git since version 1.5.6 for this purpose. To see which branches are already merged into the branch you’re on, you can run `git branch –merged`:

	$ git branch --merged
	  iss53
	* master

Because you already merged in `iss53` earlier, you see it in your list. Branches on this list without the `*` in front of them are generally fine to delete with `git branch -d`; you’ve already incorporated their work into another branch, so you’re not going to lose anything.

To see all the branches that contain work you haven’t yet merged in, you can run `git branch --no-merged`:

	$ git branch --no-merged
	  testing

This shows your other branch. Because it contains work that isn’t merged in yet, trying to delete it with `git branch -d` will fail:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.

If you are sure you want to delete it, run `git branch -D testing`.
If you really do want to delete the branch and lose that work, you can force it with `-D`, as the helpful message points out.

## 分支式工作流程 ##

Now that you have the basics of branching and merging down, what can or should you do with them? In this section, we’ll cover some common workflows that this lightweight branching makes possible, so you can decide if you would like to incorporate it into your own development cycle.

### 长期(long-term）分支 ###

Because Git uses a simple three-way merge, merging from one branch into another multiple times over a long period is generally easy to do. This means you can have several branches that are always open and that you use for different stages of your development cycle; you can merge regularly from some of them into others.

Many Git developers have a workflow that embraces this approach, such as having only code that is entirely stable in their `master` branch — possibly only code that has been or will be released. They have another parallel branch named develop or next that they work from or use to test stability — it isn’t necessarily always stable, but whenever it gets to a stable state, it can be merged into `master`. It’s used to pull in topic branches (short-lived branches, like your earlier `iss53` branch) when they’re ready, to make sure they pass all the tests and don’t introduce bugs.

In reality, we’re talking about pointers moving up the line of commits you’re making. The stable branches are farther down the line in your commit history, and the bleeding-edge branches are farther up the history (见图 3-18).

Insert 18333fig0318.png 
图 3-18. More stable branches are generally farther down the commit history.

It’s generally easier to think about them as work silos, where sets of commits graduate to a more stable silo when they’re fully tested (见图 3-19).

Insert 18333fig0319.png 
图 3-19. It may be helpful to think of your branches as silos.

You can keep doing this for several levels of stability. Some larger projects also have a `proposed` or `pu` (proposed updates) branch that has integrated branches that may not be ready to go into the `next` or `master` branch. The idea is that your branches are at various levels of stability; when they reach a more stable level, they’re merged into the branch above them.
Again, having multiple long-running branches isn’t necessary, but it’s often helpful, especially when you’re dealing with very large or complex projects.

### 特性(Topic)分支 ###

Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and use for a single particular feature or related work. This is something you’ve likely never done with a VCS before because it’s generally too expensive to create and merge branches. But in Git it’s common to create, work on, merge, and delete branches several times a day.

You saw this in the last section with the `iss53` and `hotfix` branches you created. You did a few commits on them and deleted them directly after merging them into your main branch. This technique allows you to context-switch quickly and completely — because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.

Consider an example of doing some work (on `master`), branching off for an issue (`iss91`), working on it for a bit, branching off the second branch to try another way of handling the same thing (`iss91v2`), going back to your master branch and working there for a while, and then branching off there to do some work that you’re not sure is a good idea (`dumbidea` branch). Your commit history will look something like 图 3-20.

Insert 18333fig0320.png 
图 3-20. Your commit history with multiple topic branches

Now, let’s say you decide you like the second solution to your issue best (`iss91v2`); and you showed the `dumbidea` branch to your coworkers, and it turns out to be genius. You can throw away the original `iss91` branch (losing commits C5 and C6) and merge in the other two. Your history then looks like 图 3-21.

Insert 18333fig0321.png 
图 3-21. Your history after merging in dumbidea and iss91v2

It’s important to remember when you’re doing all this that these branches are completely local. When you’re branching and merging, everything is being done only in your Git repository — no server communication is happening.

## 远程(Remote)分支 ##

Remote branches are references to the state of branches on your remote repositories. They’re local branches that you can’t move; they’re moved automatically whenever you do any network communication. Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.

They take the form `(remote)/(branch)`. For instance, if you wanted to see what the `master` branch on your `origin` remote looked like as of the last time you communicated with it, you would check the `origin/master` branch. If you were working on an issue with a partner and they pushed up an `iss53` branch, you might have your own local `iss53` branch; but the branch on the server would point to the commit at `origin/iss53`.

This may be a bit confusing, so let’s look at an example. Let’s say you have a Git server on your network at `git.ourcompany.com`. If you clone from this, Git automatically names it `origin` for you, pulls down all its data, creates a pointer to where its `master` branch is, and names it `origin/master` locally; and you can’t move it. Git also gives you your own `master` branch starting at the same place as origin’s `master` branch, so you have something to work from (见图 3-22).

Insert 18333fig0322.png 
图 3-22. A Git clone gives you your own master branch and origin/master pointing to origin’s master branch.

If you do some work on your local master branch, and, in the meantime, someone else pushes to `git.ourcompany.com` and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your `origin/master` pointer doesn’t move (见图 3-23).

Insert 18333fig0323.png 
图 3-23. Working locally and having someone push to your remote server makes each history move forward differently.

To synchronize your work, you run a `git fetch origin` command. This command looks up which server origin is (in this case, it’s `git.ourcompany.com`), fetches any data from it that you don’t yet have, and updates your local database, moving your `origin/master` pointer to its new, more up-to-date position (见图 3-24).

Insert 18333fig0324.png 
图 3-24. The git fetch command updates your remote references.

To demonstrate having multiple remote servers and what remote branches for those remote projects look like, let’s assume you have another internal Git server that is used only for development by one of your sprint teams. This server is at `git.team1.ourcompany.com`. You can add it as a new remote reference to the project you’re currently working on by running the `git remote add` command as we covered in Chapter 2. Name this remote `teamone`, which will be your shortname for that whole URL (见图 3-25).

Insert 18333fig0325.png 
图 3-25. Adding another server as a remote

Now, you can run `git fetch teamone` to fetch everything server has that you don’t have yet. Because that server is a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (见图 3-26).

Insert 18333fig0326.png 
图 3-26. You get a reference to teamone’s master branch position locally.

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
