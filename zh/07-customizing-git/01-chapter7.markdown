# 自定义Git #

到目前为止，我阐述了Git基本的运作机制和使用方式，介绍了Git提供的许多工具来帮助你简单且有效地使用它。
在本章当中，我将会介绍Git的一些重要的配置方法和钩子机制以满足你自定义的要求，通过这些方法，它会和你、你的公司或团队配合得天衣无缝。

## 配置Git ##

正如你在第一章见到的那样，你能用`git config`配置Git，要做的第一件事就是设置名字和邮箱地址：

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

从现在开始，你会了解到一些更为有趣的设置选项，按照以上方式来自定义Git。

我会在这先过一遍第一章中提到的Git配置细节。Git使用一系列的配置文件来存储你定义的偏好，它首先会查找`/etc/gitconfig`文件，该文件含有
对系统上所有用户及他们所拥有的仓库都生效的配置值（译注：gitconfig是全局配置文件），
如果传递`--system`选项给`git config`命令，Git会读写这个文件。

接下来Git会查找每个用户的`~/.gitconfig`文件，你能传递`--global`选项让Git读写该文件。

最后Git会查找由用户定义的各个库中Git目录下的配置文件（`.git/config`），该文件中的值只对属主库有效。
以上阐述的三层配置从一般到特殊层层推进，如果定义的值有冲突，以后面层中定义的为准，例如：在`.git/config`和`/etc/gitconfig`的较量中，
`.git/config`取得了胜利。虽然你也可以直接手动编辑这些配置文件，但是运行`git config`命令将会来得简单些。

### 客户端基本配置 ###

Git能够识别的配置项被分为了两大类：客户端和服务器端，其中大部分基于你个人工作偏好，属于客户端配置。尽管有数不尽的选项，但我只阐述
其中经常使用或者会对你的工作流产生巨大影响的选项，如果你想观察你当前的Git能识别的选项列表，请运行

	$ git config --help

`git config`的手册页（译注：以man命令的显示方式）非常细致地罗列了所有可用的配置项。

#### core.editor ####

Git默认会调用你的环境变量editor定义的值作为文本编辑器，如果没有定义的话，会调用Vi来创建和编辑提交以及标签信息，
你可以使用`core.editor`改变默认编辑器：

	$ git config --global core.editor emacs

现在无论你的环境变量editor被定义成什么，Git都会调用Emacs编辑信息。

#### commit.template ####

如果把此项指定为你系统上的一个文件，当你提交的时候，Git会默认使用该文件定义的内容。
例如：你创建了一个模板文件`$HOME/.gitmessage.txt`，它看起来像这样：

	subject line

	what happened

	[ticket: X]

设置`commit.template`，当运行`git commit`时，Git会在你的编辑器中显示以上的内容，
设置`commit.template`如下：

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

然后当你提交时，在编辑器中显示的提交信息如下：

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

如果你有特定的策略要运用在提交信息上，在系统上创建一个模板文件，设置Git默认使用它，这样当提交时，你的策略每次都会被运用。

#### core.pager ####

core.pager指定Git运行诸如`log`、`diff`等所使用的分页器，你能设置成用`more`或者任何你喜欢的分页器（默认用的是`less`），
当然你也可以什么都不用，设置空字符串：

	$ git config --global core.pager ''

这样不管命令的输出量多少，都会在一页显示所有内容。

#### user.signingkey ####

如果你要创建经签署的含附注的标签（正如第二章所述），那么把你的GPG签署密钥设置为配置项会更好，设置密钥ID如下：

	$ git config --global user.signingkey <gpg-key-id>

现在你能够签署标签，从而不必每次运行`git tag`命令时定义密钥：

	$ git tag -s <tag-name>

#### core.excludesfile ####

正如第二章所述，你能在项目库的`.gitignore`文件里头用模式来定义那些无需纳入Git管理的文件，这样它们不会出现在未跟踪列表，
也不会在你运行`git add`后被暂存。然而，如果你想用项目库之外的文件来定义那些需被忽略的文件的话，用`core.excludesfile`
通知Git该文件所处的位置，文件内容和`.gitignore`类似。

#### help.autocorrect ####

该配置项只在Git 1.6.1及以上版本有效，假如你在Git 1.6中错打了一条命令，会显示：

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

如果你把`help.autocorrect`设置成1（译注：启动自动修正），那么在只有一个命令被模糊匹配到的情况下，Git会自动运行该命令。

### Git中的着色 ###

Git能够为输出到你终端的内容着色，以便你可以凭直观进行快速、简单地分析，有许多选项能供你使用以符合你的偏好。

#### color.ui ####

Git会按照你需要自动为大部分的输出加上颜色，你能明确地规定哪些需要着色以及怎样着色，设置`color.ui`为true来打开所有的默认终端着色。

	$ git config --global color.ui true

设置好以后，当输出到终端时，Git会为之加上颜色。其他的参数还有false和always，false意味着不为输出着色，而always则表明在任何情况下
都要着色，即使Git命令被重定向到文件或管道。Git 1.5.5版本引进了此项配置，如果你拥有的版本更老，你必须对颜色有关选项各自进行详细地设置。

你会很少用到`color.ui = always`，在大多数情况下，如果你想在被重定向的输出中插入颜色码，你能传递`--color`标志给Git命令来迫使
它这么做，`color.ui = true`应该是你的首选。

#### `color.*` ####

想要具体到哪些命令输出需要被着色以及怎样着色或者Git的版本很老，你就要用到和具体命令有关的颜色配置选项，
它们都能被置为`true`、`false`或`always`：

	color.branch
	color.diff
	color.interactive
	color.status

除此之外，以上每个选项都有子选项，可以被用来覆盖其父设置，以达到为输出的各个部分着色的目的。
例如，让diff输出的改变信息以粗体、蓝色前景和黑色背景的形式显示：

	$ git config --global color.diff.meta “blue black bold”

你能设置的颜色值如：normal、black、red、green、yellow、blue、magenta、cyan、white，
正如以上例子设置的粗体属性，想要设置字体属性的话，可以选择如：bold、dim、ul、blink、reverse。

如果你想配置子选项的话，可以参考`git config`帮助页。

### 外部的合并与比较工具 ###

虽然Git自己实现了diff,而且到目前为止你一直在使用它，但你能够用一个外部的工具替代它，除此以外，你还能用一个图形化的工具来合并和解决冲突
从而不必自己手动解决。有一个不错且免费的工具可以被用来做比较和合并工作，它就是P4Merge（译注：Perforce图形化合并工具），我会展示它的安装过程。

P4Merge可以在所有主流平台上运行，现在开始大胆尝试吧。对于向你展示的例子，在Mac和Linux系统上，我会使用路径名，
在Windows上，`/usr/local/bin`应该被改为你环境中的可执行路径。

下载P4Merge：

	http://www.perforce.com/perforce/downloads/component.html

首先把你要运行的命令放入外部包装脚本中，我会使用Mac系统上的路径来指定该脚本的位置，在其他系统上，
它应该被放置在二进制文件`p4merge`所在的目录中。创建一个merge包装脚本，名字叫作`extMerge`，让它带参数调用`p4merge`二进制文件：

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

diff包装脚本首先确定传递过来7个参数，随后把其中2个传递给merge包装脚本，默认情况下，Git传递以下参数给diff：

	path old-file old-hex old-mode new-file new-hex new-mode

由于你仅仅需要`old-file`和`new-file`参数，用diff包装脚本来传递它们吧。

	$ cat /usr/local/bin/extDiff 
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

确认这两个脚本是可执行的：

	$ sudo chmod +x /usr/local/bin/extMerge 
	$ sudo chmod +x /usr/local/bin/extDiff

现在来配置使用你自定义的比较和合并工具吧。这需要许多自定义设置：`merge.tool`通知Git使用哪个合并工具；
`mergetool.*.cmd`规定命令运行的方式；`mergetool.trustExitCode`会通知Git程序的退出是否指示合并操作成功；
`diff.external`通知Git用什么命令做比较。因此，你能运行以下4条配置命令：

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

或者直接编辑`~/.gitconfig`文件如下：

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

设置完毕后，运行diff命令：
	
	$ git diff 32d1776b1^ 32d1776b1

命令行居然没有发现diff命令的输出，其实，Git调用了刚刚设置的P4Merge，它看起来像图7-1这样：

Insert 18333fig0701.png 
Figure 7-1. P4Merge.

当你设法合并两个分支，结果却有冲突时，运行`git mergetool`，Git会调用P4Merge让你通过图形界面来解决冲突。

设置包装脚本的好处是你能简单地改变diff和merge工具，例如把`extDiff`和`extMerge`改成KDiff3，要做的仅仅是编辑`extMerge`脚本文件：

	$ cat /usr/local/bin/extMerge
	#!/bin/sh	
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

现在Git会使用KDiff3来做比较、合并和解决冲突。

Git预先设置了许多其他的合并和解决冲突的工具，而你不必设置cmd。可以把合并工具设置为：
kdiff3、opendiff、tkdiff、meld、xxdiff、emerge、vimdiff、gvimdiff。如果你不想用到KDiff3的所有功能，只是想用它来合并，
那么kdiff3正符合你的要求，运行：

	$ git config --global merge.tool kdiff3

如果运行了以上命令，没有设置`extMerge`和`extDiff`文件，Git会用KDiff3做合并，让通常内设的比较工具来做比较。

### 格式化与空白 ###

格式化与空白是许多开发人员在协作时，特别是在跨平台情况下，遇到的令人头疼的细小问题。
由于编辑器的不同或者Windows程序员在跨平台项目中的文件行尾加入了回车换行符，
一些细微的空格变化会不经意地进入大家合作的工作或提交的补丁中。不用怕，Git的一些配置选项会帮助你解决这些问题。

#### core.autocrlf ####

假如你正在Windows上写程序，又或者你正在和其他人合作，他们在Windows上编程，而你却在其他系统上，在这些情况下，你可能会遇到行尾结束符问题。
这是因为Windows使用回车和换行两个字符来结束一行，而Mac和Linux只使用换行一个字符（译注：Windows系统的回车换行符号为\r\n，而在Mac和Linux系统中则是\n）。
虽然这是小问题，但它会极大地扰乱跨平台协作。 

Git可以在你提交时自动地把行结束符CRLF转换成LF，而在签出代码时把LF转换成CRLF。用`core.autocrlf`来打开此项功能，
如果是在Windows系统上，把它设置成`true`，这样当签出代码时，LF会被转换成CRLF：

	$ git config --global core.autocrlf true

Linux或Mac系统使用LF作为行结束符，因此你不想Git在签出文件时进行自动的转换；当一个以CRLF为行结束符的文件不小心被引入时你肯定想进行修正，
把`core.autocrlf`设置成input来告诉Git在提交时把CRLF转换成LF，签出时不转换：

	$ git config --global core.autocrlf input

这样会在Windows系统上的签出文件中保留CRLF，会在Mac和Linux系统上，包括仓库中保留LF。

如果你是Windows程序员，且正在开发仅运行在Windows上的项目，可以设置`false`取消此功能，把回车符记录在库中：

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git预先设置了一些选项来探测和修正空白问题，其4种主要选项中的2个默认被打开，另2个被关闭，你可以自由地打开或关闭它们。

默认被打开的2个选项是`trailing-space`和`space-before-tab`，`trailing-space`会查找每行结尾的空格，`space-before-tab`会查找每行开头的制表符前的空格。

默认被关闭的2个选项是`indent-with-non-tab`和`cr-at-eol`，`indent-with-non-tab`会查找8个以上空格（非制表符）开头的行，`cr-at-eol`让Git知道行尾回车符是合法的。

设置`core.whitespace`，按照你的意图来打开或关闭选项，选项以逗号分割。通过逗号分割的链中去掉选项或在选项前加`-`来关闭，例如，如果你想要打开除了`cr-at-eol`之外的所有选项：

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

当你运行`git diff`命令且为输出着色时，Git会探测到这些问题，因此你也许在提交前能修复它们，当你用`git apply`打补丁时同样也会从中受益。
如果正准备运用的补丁有特别的空白问题，你可以让Git发警告：

	$ git apply --whitespace=warn <patch>

或者让Git在打上补丁前自动修正此问题：

	$ git apply --whitespace=fix <patch>

这些选项也能运用于衍合。如果提交了有空白问题的文件但还没推送到上流，你可以运行带有`--whitespace=fix`选项的`rebase`来让Git
在重写补丁时自动修正它们。

### 服务器端配置 ###

Git服务器端的配置选项并不多，但仍有一些饶有生趣的选项值得你一看。

#### receive.fsckObjects ####

Git默认情况下不会在推送期间检查所有对象的一致性。虽然会确认每个对象的有效性以及是否仍然匹配SHA-1检验和，但Git不会在每次推送时都检查一致性。
对于Git来说，库或推送的文件越大，这个操作代价就相对越高，每次推送会消耗更多时间，如果想在每次推送时Git都检查一致性，设置
`receive.fsckObjects`为true来强迫它这么做：

	$ git config --system receive.fsckObjects true

现在Git会在每次推送生效前检查库的完整性，确保有问题的客户端没有引入破坏性的数据。

#### receive.denyNonFastForwards ####

如果对已经被推送的提交历史做衍合，继而再推送，又或者以其它方式推送一个提交历史至远程分支，且该提交历史没在这个远程分支中，这样的推送会被拒绝。这通常是个很好的禁止策略，但有时你在做衍合并确定要更新远程分支，可以在push命令后加`-f`标志来强制更新。

要禁用这样的强制更新功能，可以设置`receive.denyNonFastForwards`：

    $ git config --system receive.denyNonFastForwards true

稍后你会看到，用服务器端的接收钩子也能达到同样的目的。这个方法可以做更细致的控制，例如：禁用特定的用户做强制更新。

#### receive.denyDeletes ####

规避`denyNonFastForwards`策略的方法之一就是用户删除分支，然后推回新的引用。在更新的Git版本中（从1.6.1版本开始），把`receive.denyDeletes`设置为true：

    $ git config --system receive.denyDeletes true

这样会在推送过程中阻止删除分支和标签 — 没有用户能够这么做。要删除远程分支，必须从服务器手动删除引用文件。通过用户访问控制列表也能这么做，
在本章结尾将会介绍这些有趣的方式。

## Git属性 ##

一些设置项也能被运用于特定的路径中，这样，Git可以对一个特定的子目录或子文件集运用那些设置项。这些设置项被称为Git属性，可以在你目录中的`.gitattributes`文件内进行设置
（通常是你项目的根目录），也可以当你不想让这些属性文件和项目文件一同提交时，在`.git/info/attributes`进行设置。

使用属性，你可以对个别文件或目录定义不同的合并策略，让Git知道怎样比较非文本文件，在你提交或签出前让Git过滤内容。你将在这部分了解到能在自己的项目中使用的属性，以及一些实例。

### 二进制文件 ###

你可以用Git属性让其知道哪些是二进制文件（以防Git没有识别出来），以及指示怎样处理这些文件，这点很酷。例如，一些文本文件是由机器产生的，而且无法比较，而一些二进制文件可以比较 —
你将会了解到怎样让Git识别这些文件。

#### 识别二进制文件 ####

一些文件看起来像是文本文件，但其实是作为二进制数据被对待。例如，在Mac上的Xcode项目含有一个以`.pbxproj`结尾的文件，它是由记录设置项的IDE写到磁盘的JSON数据集（纯文本javascript数据类型）。虽然技术上看它是由ASCII字符组成的文本文件，但你并不认为如此，因为它确实是一个轻量级数据库 — 如果有2人改变了它，你通常无法合并和比较内容，只有机器才能进行识别和操作，于是，你想把它当成二进制文件。

让Git把所有`pbxproj`文件当成二进制文件，在`.gitattributes`文件中设置如下：

    *.pbxproj -crlf -diff

现在，Git不会尝试转换和修正CRLF（回车换行）问题，也不会当你在项目中运行git show或git diff时，比较不同的内容。在Git 1.6及之后的版本中，可以用一个宏代替`-crlf -diff`：

    *.pbxproj binary

#### 比较二进制文件 ####

在Git 1.6及以上版本中，你能利用Git属性来有效地比较二进制文件。可以设置Git把二进制数据转换成文本格式，用通常的diff来比较。

这个特性很酷，而且鲜为人知，因此我会结合实例来讲解。首先，要解决的是最令人头疼的问题：对Word文档进行版本控制。很多人对Word文档又恨又爱，如果想对其进行版本控制，你可以把文件加入到Git库中，每次修改后提交即可。但这样做没有一点实际意义，因为运行`git diff`命令后，你只能得到如下的结果：

    $ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index 88839c4..4afcb7c 100644
    Binary files a/chapter1.doc and b/chapter1.doc differ

你不能直接比较两个不同版本的Word文件，除非进行手动扫描，不是吗？Git属性能很好地解决此问题，把下面的行加到`.gitattributes`文件：

    *.doc diff=word

当你要看比较结果时，如果文件扩展名是"doc"，Git会调用"word"过滤器。什么是"word"过滤器呢？其实就是Git使用`strings` 程序，把Word文档转换成可读的文本文件，之后再进行比较：

    $ git config diff.word.textconv strings

现在如果在两个快照之间比较以`.doc`结尾的文件，Git会对这些文件运用"word"过滤器，在比较前把Word文件转换成文本文件。

下面展示了一个实例，我把此书的第一章纳入Git管理，在一个段落中加入了一些文本后保存，之后运行`git diff`命令，得到结果如下：

    $ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index c1c8a0a..b93c9e4 100644
    --- a/chapter1.doc
    +++ b/chapter1.doc
    @@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
     re going to cover how to get it and set it up for the first time if you don
     t already have it on your system.
     In Chapter Two we will go over basic Git usage - how to use Git for the 80%
    -s going on, modify stuff and contribute changes. If the book spontaneously
    +s going on, modify stuff and contribute changes. If the book spontaneously
    +Let's see if this works.

Git 成功且简洁地显示出我增加的文本"Let’s see if this works"。虽然有些瑕疵，在末尾显示了一些随机的内容，但确实可以比较了。如果你能找到或自己写个Word到纯文本的转换器的话，效果可能会更好。 `strings`可以在大部分Mac和Linux系统上运行，所以它是处理二进制格式的第一选择。

你还能用这个方法比较图像文件。当比较时，对JPEG文件运用一个过滤器，它能提炼出EXIF信息 — 大部分图像格式使用的元数据。如果你下载并安装了`exiftool`程序，可以用它参照元数据把图像转换成文本。比较的不同结果将会用文本向你展示：

    $ echo '*.png diff=exif' >> .gitattributes
    $ git config diff.exif.textconv exiftool

如果在项目中替换了一个图像文件，运行`git diff`命令的结果如下：

    diff --git a/image.png b/image.png
    index 88839c4..4afcb7c 100644
    --- a/image.png
    +++ b/image.png
    @@ -1,12 +1,12 @@
     ExifTool Version Number         : 7.74
    -File Size                       : 70 kB
    -File Modification Date/Time     : 2009:04:21 07:02:45-07:00
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

你会发现文件的尺寸大小发生了改变。

### 关键字扩展 ###

使用SVN或CVS的开发人员经常要求关键字扩展。在Git中，你无法在一个文件被提交后修改它，因为Git会先对该文件计算校验和。然而，你可以在签出时注入文本，在提交前删除它。Git属性提供了2种方式这么做。

首先，你能够把blob的SHA-1校验和自动注入文件的`$Id$`字段。如果在一个或多个文件上设置了此字段，当下次你签出分支的时候，Git会用blob的SHA-1值替换那个字段。注意，这不是提交对象的SHA校验和，而是blob本身的校验和：

    $ echo '*.txt ident' >> .gitattributes
    $ echo '$Id$' > test.txt

下次签出文件时，Git注入了blob的SHA值：

    $ rm text.txt
    $ git checkout -- text.txt
    $ cat test.txt
    $Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

然而，这样的显示结果没有多大的实际意义。这个SHA的值相当地随机，无法区分日期的前后，所以，如果你在CVS或Subversion中用过关键字替换，一定会包含一个日期值。

因此，你能写自己的过滤器，在提交文件到暂存区或签出文件时替换关键字。有2种过滤器，"clean"和"smudge"。在 `.gitattributes`文件中，你能对特定的路径设置一个过滤器，然后设置处理文件的脚本，这些脚本会在文件签出前（"smudge"，见图 7-2）和提交到暂存区前（"clean"，见图7-3）被调用。这些过滤器能够做各种有趣的事。

Insert 18333fig0702.png
图7-2. 签出时，“smudge”过滤器被触发。

Insert 18333fig0703.png
图7-3. 提交到暂存区时，“clean”过滤器被触发。

这里举一个简单的例子：在暂存前，用`indent`（缩进）程序过滤所有C源代码。在`.gitattributes`文件中设置"indent"过滤器过滤`*.c`文件：

    *.c     filter=indent

然后，通过以下配置，让Git知道"indent"过滤器在遇到"smudge"和"clean"时分别该做什么：

    $ git config --global filter.indent.clean indent
    $ git config --global filter.indent.smudge cat

于是，当你暂存`*.c`文件时，`indent`程序会被触发，在把它们签出之前，`cat`程序会被触发。但`cat`程序在这里没什么实际作用。这样的组合，使C源代码在暂存前被`indent`程序过滤，非常有效。

另一个例子是类似RCS的`$Date$`关键字扩展。为了演示，需要一个小脚本，接受文件名参数，得到项目的最新提交日期，最后把日期写入该文件。下面用Ruby脚本来实现：

    #! /usr/bin/env ruby
    data = STDIN.read
    last_date = `git log --pretty=format:"%ad" -1`
    puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

该脚本从`git log`命令中得到最新提交日期，找到文件中的所有`$Date$`字符串，最后把该日期填充到`$Date$`字符串中 — 此脚本很简单，你可以选择你喜欢的编程语言来实现。把该脚本命名为`expand_date`，放到正确的路径中，之后需要在Git中设置一个过滤器（`dater`），让它在签出文件时调用`expand_date`，在暂存文件时用Perl清除之：

    $ git config filter.dater.smudge expand_date
    $ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

这个Perl小程序会删除`$Date$`字符串里多余的字符，恢复`$Date$`原貌。到目前为止，你的过滤器已经设置完毕，可以开始测试了。打开一个文件，在文件中输入`$Date$`关键字，然后设置Git属性：

    $ echo '# $Date$' > date_test.txt
    $ echo 'date*.txt filter=dater' >> .gitattributes

如果暂存该文件，之后再签出，你会发现关键字被替换了：

    $ git add date_test.txt .gitattributes
    $ git commit -m "Testing date expansion in Git"
    $ rm date_test.txt
    $ git checkout date_test.txt
    $ cat date_test.txt
    # $Date: Tue Apr 21 07:26:52 2009 -0700$

虽说这项技术对自定义应用来说很有用，但还是要小心，因为`.gitattributes`文件会随着项目一起提交，而过滤器（例如：`dater`）不会，所以，过滤器不会在所有地方都生效。当你在设计这些过滤器时要注意，即使它们无法正常工作，也要让整个项目运作下去。

### 导出仓库 ### 
Git attribute data also allows you to do some interesting things when exporting an archive of your project.

#### export-ignore ####

You can tell Git not to export certain files or directories when generating an archive. If there is a subdirectory or file that you don’t want to include in your archive file but that you do want checked into your project, you can determine those files via the `export-ignore` attribute.

For example, say you have some test files in a `test/` subdirectory, and it doesn’t make sense to include them in the tarball export of your project. You can add the following line to your Git attributes file:

	test/ export-ignore

Now, when you run git archive to create a tarball of your project, that directory won’t be included in the archive.

#### export-subst ####

Another thing you can do for your archives is some simple keyword substitution. Git lets you put the string `$Format:$` in any file with any of the `--pretty=format` formatting shortcodes, many of which you saw in Chapter 2. For instance, if you want to include a file named `LAST_COMMIT` in your project, and the last commit date was automatically injected into it when `git archive` ran, you can set up the file like this:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

When you run `git archive`, the contents of that file when people open the archive file will look like this:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge Strategies ###

You can also use Git attributes to tell Git to use different merge strategies for specific files in your project. One very useful option is to tell Git to not try to merge specific files when they have conflicts, but rather to use your side of the merge over someone else’s.

This is helpful if a branch in your project has diverged or is specialized, but you want to be able to merge changes back in from it, and you want to ignore certain files. Say you have a database settings file called database.xml that is different in two branches, and you want to merge in your other branch without messing up the database file. You can set up an attribute like this:

	database.xml merge=ours

If you merge in the other branch, instead of having merge conflicts with the database.xml file, you see something like this:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In this case, database.xml stays at whatever version you originally had.

## Git Hooks ##

Like many other Version Control Systems, Git has a way to fire off custom scripts when certain important actions occur. There are two groups of these hooks: client side and server side. The client-side hooks are for client operations such as committing and merging. The server-side hooks are for Git server operations such as receiving pushed commits. You can use these hooks for all sorts of reasons, and you’ll learn about a few of them here.

### Installing a Hook ###

The hooks are all stored in the `hooks` subdirectory of the Git directory. In most projects, that’s `.git/hooks`. By default, Git populates this directory with a bunch of example scripts, many of which are useful by themselves; but they also document the input values of each script. All the examples are written as shell scripts, with some Perl thrown in, but any properly named executable scripts will work fine — you can write them in Ruby or Python or what have you. For post-1.6 versions of Git, these example hook files end with .sample; you’ll need to rename them. For pre-1.6 versions of Git, the example files are named properly but are not executable.

To enable a hook script, put a file in the `hooks` subdirectory of your Git directory that is named appropriately and is executable. From that point forward, it should be called. I’ll cover most of the major hook filenames here.

### Client-Side Hooks ###

There are a lot of client-side hooks. This section splits them into committing-workflow hooks, e-mail–workflow scripts, and the rest of the client-side scripts.

#### Committing-Workflow Hooks ####

The first four hooks have to do with the committing process. The `pre-commit` hook is run first, before you even type in a commit message. It’s used to inspect the snapshot that’s about to be committed, to see if you’ve forgotten something, to make sure tests run, or to examine whatever you need to inspect in the code. Exiting non-zero from this hook aborts the commit, although you can bypass it with `git commit --no-verify`. You can do things like check for code style (run lint or something equivalent), check for trailing whitespace (the default hook does exactly that), or check for appropriate documentation on new methods.

The `prepare-commit-msg` hook is run before the commit message editor is fired up but after the default message is created. It lets you edit the default message before the commit author sees it. This hook takes a few options: the path to the file that holds the commit message so far, the type of commit, and the commit SHA-1 if this is an amended commit. This hook generally isn’t useful for normal commits; rather, it’s good for commits where the default message is auto-generated, such as templated commit messages, merge commits, squashed commits, and amended commits. You may use it in conjunction with a commit template to programmatically insert information.

The `commit-msg` hook takes one parameter, which again is the path to a temporary file that contains the current commit message. If this script exits non-zero, Git aborts the commit process, so you can use it to validate your project state or commit message before allowing a commit to go through. In the last section of this chapter, I’ll demonstrate using this hook to check that your commit message is conformant to a required pattern.

After the entire commit process is completed, the `post-commit` hook runs. It doesn’t take any parameters, but you can easily get the last commit by running `git log -1 HEAD`. Generally, this script is used for notification or something similar.

The committing-workflow client-side scripts can be used in just about any workflow. They’re often used to enforce certain policies, although it’s important to note that these scripts aren’t transferred during a clone. You can enforce policy on the server side to reject pushes of commits that don’t conform to some policy, but it’s entirely up to the developer to use these scripts on the client side. So, these are scripts to help developers, and they must be set up and maintained by them, although they can be overridden or modified by them at any time.

#### E-mail Workflow Hooks ####

You can set up three client-side hooks for an e-mail–based workflow. They’re all invoked by the `git am` command, so if you aren’t using that command in your workflow, you can safely skip to the next section. If you’re taking patches over e-mail prepared by `git format-patch`, then some of these may be helpful to you.

The first hook that is run is `applypatch-msg`. It takes a single argument: the name of the temporary file that contains the proposed commit message. Git aborts the patch if this script exits non-zero. You can use this to make sure a commit message is properly formatted or to normalize the message by having the script edit it in place.

The next hook to run when applying patches via `git am` is `pre-applypatch`. It takes no arguments and is run after the patch is applied, so you can use it to inspect the snapshot before making the commit. You can run tests or otherwise inspect the working tree with this script. If something is missing or the tests don’t pass, exiting non-zero also aborts the `git am` script without committing the patch.

The last hook to run during a `git am` operation is `post-applypatch`. You can use it to notify a group or the author of the patch you pulled in that you’ve done so. You can’t stop the patching process with this script.

#### Other Client Hooks ####

The `pre-rebase` hook runs before you rebase anything and can halt the process by exiting non-zero. You can use this hook to disallow rebasing any commits that have already been pushed. The example `pre-rebase` hook that Git installs does this, although it assumes that next is the name of the branch you publish. You’ll likely need to change that to whatever your stable, published branch is.

After you run a successful `git checkout`, the `post-checkout` hook runs; you can use it to set up your working directory properly for your project environment. This may mean moving in large binary files that you don’t want source controlled, auto-generating documentation, or something along those lines.

Finally, the `post-merge` hook runs after a successful `merge` command. You can use it to restore data in the working tree that Git can’t track, such as permissions data. This hook can likewise validate the presence of files external to Git control that you may want copied in when the working tree changes.

### Server-Side Hooks ###

In addition to the client-side hooks, you can use a couple of important server-side hooks as a system administrator to enforce nearly any kind of policy for your project. These scripts run before and after pushes to the server. The pre hooks can exit non-zero at any time to reject the push as well as print an error message back to the client; you can set up a push policy that’s as complex as you wish.

#### pre-receive and post-receive ####

The first script to run when handling a push from a client is `pre-receive`. It takes a list of references that are being pushed from stdin; if it exits non-zero, none of them are accepted. You can use this hook to do things like make sure none of the updated references are non-fast-forwards; or to check that the user doing the pushing has create, delete, or push access or access to push updates to all the files they’re modifying with the push.

The `post-receive` hook runs after the entire process is completed and can be used to update other services or notify users. It takes the same stdin data as the `pre-receive` hook. Examples include e-mailing a list, notifying a continuous integration server, or updating a ticket-tracking system — you can even parse the commit messages to see if any tickets need to be opened, modified, or closed. This script can’t stop the push process, but the client doesn’t disconnect until it has completed; so, be careful when you try to do anything that may take a long time.

#### update ####

The update script is very similar to the `pre-receive` script, except that it’s run once for each branch the pusher is trying to update. If the pusher is trying to push to multiple branches, `pre-receive` runs only once, whereas update runs once per branch they’re pushing to. Instead of reading from stdin, this script takes three arguments: the name of the reference (branch), the SHA-1 that reference pointed to before the push, and the SHA-1 the user is trying to push. If the update script exits non-zero, only that reference is rejected; other references can still be updated.

## An Example Git-Enforced Policy ##

In this section, you’ll use what you’ve learned to establish a Git workflow that checks for a custom commit message format, enforces fast-forward-only pushes, and allows only certain users to modify certain subdirectories in a project. You’ll build client scripts that help the developer know if their push will be rejected and server scripts that actually enforce the policies.

I used Ruby to write these, both because it’s my preferred scripting language and because I feel it’s the most pseudocode-looking of the scripting languages; thus you should be able to roughly follow the code even if you don’t use Ruby. However, any language will work fine. All the sample hook scripts distributed with Git are in either Perl or Bash scripting, so you can also see plenty of examples of hooks in those languages by looking at the samples.

### Server-Side Hook ###

All the server-side work will go into the update file in your hooks directory. The update file runs once per branch being pushed and takes the reference being pushed to, the old revision where that branch was, and the new revision being pushed. You also have access to the user doing the pushing if the push is being run over SSH. If you’ve allowed everyone to connect with a single user (like "git") via public-key authentication, you may have to give that user a shell wrapper that determines which user is connecting based on the public key, and set an environment variable specifying that user. Here I assume the connecting user is in the `$USER` environment variable, so your update script begins by gathering all the information you need:

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Yes, I’m using global variables. Don’t judge me — it’s easier to demonstrate in this manner.

#### Enforcing a Specific Commit-Message Format ####

Your first challenge is to enforce that each commit message must adhere to a particular format. Just to have a target, assume that each message has to include a string that looks like "ref: 1234" because you want each commit to link to a work item in your ticketing system. You must look at each commit being pushed up, see if that string is in the commit message, and, if the string is absent from any of the commits, exit non-zero so the push is rejected.

You can get a list of the SHA-1 values of all the commits that are being pushed by taking the `$newrev` and `$oldrev` values and passing them to a Git plumbing command called `git rev-list`. This is basically the `git log` command, but by default it prints out only the SHA-1 values and no other information. So, to get a list of all the commit SHAs introduced between one commit SHA and another, you can run something like this:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

You can take that output, loop through each of those commit SHAs, grab the message for it, and test that message against a regular expression that looks for a pattern.

You have to figure out how to get the commit message from each of these commits to test. To get the raw commit data, you can use another plumbing command called `git cat-file`. I’ll go over all these plumbing commands in detail in Chapter 9; but for now, here’s what that command gives you:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

A simple way to get the commit message from a commit when you have the SHA-1 value is to go to the first blank line and take everything after that. You can do so with the `sed` command on Unix systems:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

You can use that incantation to grab the commit message from each commit that is trying to be pushed and exit if you see anything that doesn’t match. To exit the script and reject the push, exit non-zero. The whole method looks like this:

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

Putting that in your `update` script will reject updates that contain commits that have messages that don’t adhere to your rule.

#### Enforcing a User-Based ACL System ####

Suppose you want to add a mechanism that uses an access control list (ACL) that specifies which users are allowed to push changes to which parts of your projects. Some people have full access, and others only have access to push changes to certain subdirectories or specific files. To enforce this, you’ll write those rules to a file named `acl` that lives in your bare Git repository on the server. You’ll have the `update` hook look at those rules, see what files are being introduced for all the commits being pushed, and determine whether the user doing the push has access to update all those files.

The first thing you’ll do is write your ACL. Here you’ll use a format very much like the CVS ACL mechanism: it uses a series of lines, where the first field is `avail` or `unavail`, the next field is a comma-delimited list of the users to which the rule applies, and the last field is the path to which the rule applies (blank meaning open access). All of these fields are delimited by a pipe (`|`) character.

In this case, you have a couple of administrators, some documentation writers with access to the `doc` directory, and one developer who only has access to the `lib` and `tests` directories, and your ACL file looks like this:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

You begin by reading this data into a structure that you can use. In this case, to keep the example simple, you’ll only enforce the `avail` directives. Here is a method that gives you an associative array where the key is the user name and the value is an array of paths to which the user has write access:

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

On the ACL file you looked at earlier, this `get_acl_access_data` method returns a data structure that looks like this:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Now that you have the permissions sorted out, you need to determine what paths the commits being pushed have modified, so you can make sure the user who’s pushing has access to all of them.

You can pretty easily see what files have been modified in a single commit with the `--name-only` option to the `git log` command (mentioned briefly in Chapter 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

If you use the ACL structure returned from the `get_acl_access_data` method and check it against the listed files in each of the commits, you can determine whether the user has access to push all of their commits:

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
	        if !access_path  # user has access to everything
	          || (path.index(access_path) == 0) # access to this path
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

Most of that should be easy to follow. You get a list of new commits being pushed to your server with `git rev-list`. Then, for each of those, you find which files are modified and make sure the user who’s pushing has access to all the paths being modified. One Rubyism that may not be clear is `path.index(access_path) == 0`, which is true if path begins with `access_path` — this ensures that `access_path` is not just in one of the allowed paths, but an allowed path begins with each accessed path. 

Now your users can’t push any commits with badly formed messages or with modified files outside of their designated paths.

#### Enforcing Fast-Forward-Only Pushes ####

The only thing left is to enforce fast-forward-only pushes. In Git versions 1.6 or newer, you can set the `receive.denyDeletes` and `receive.denyNonFastForwards` settings. But enforcing this with a hook will work in older versions of Git, and you can modify it to do so only for certain users or whatever else you come up with later.

The logic for checking this is to see if any commits are reachable from the older revision that aren’t reachable from the newer one. If there are none, then it was a fast-forward push; otherwise, you deny it:

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

Everything is set up. If you run `chmod u+x .git/hooks/update`, which is the file you into which you should have put all this code, and then try to push a non-fast-forwarded reference, you get something like this:

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies... 
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non-fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

There are a couple of interesting things here. First, you see this where the hook starts running.

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Notice that you printed that out to stdout at the very beginning of your update script. It’s important to note that anything your script prints to stdout will be transferred to the client.

The next thing you’ll notice is the error message.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

The first line was printed out by you, the other two were Git telling you that the update script exited non-zero and that is what is declining your push. Lastly, you have this:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

You’ll see a remote rejected message for each reference that your hook declined, and it tells you that it was declined specifically because of a hook failure.

Furthermore, if the ref marker isn’t there in any of your commits, you’ll see the error message you’re printing out for that.

	[POLICY] Your message is not formatted correctly

Or if someone tries to edit a file they don’t have access to and push a commit containing it, they will see something similar. For instance, if a documentation author tries to push a commit modifying something in the `lib` directory, they see

	[POLICY] You do not have access to push to lib/test.rb

That’s all. From now on, as long as that `update` script is there and executable, your repository will never be rewound and will never have a commit message without your pattern in it, and your users will be sandboxed.

### Client-Side Hooks ###

The downside to this approach is the whining that will inevitably result when your users’ commit pushes are rejected. Having their carefully crafted work rejected at the last minute can be extremely frustrating and confusing; and furthermore, they will have to edit their history to correct it, which isn’t always for the faint of heart.

The answer to this dilemma is to provide some client-side hooks that users can use to notify them when they’re doing something that the server is likely to reject. That way, they can correct any problems before committing and before those issues become more difficult to fix. Because hooks aren’t transferred with a clone of a project, you must distribute these scripts some other way and then have your users copy them to their `.git/hooks` directory and make them executable. You can distribute these hooks within the project or in a separate project, but there is no way to set them up automatically.

To begin, you should check your commit message just before each commit is recorded, so you know the server won’t reject your changes due to badly formatted commit messages. To do this, you can add the `commit-msg` hook. If you have it read the message from the file passed as the first argument and compare that to the pattern, you can force Git to abort the commit if there is no match:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

If that script is in place (in `.git/hooks/commit-msg`) and executable, and you commit with a message that isn’t properly formatted, you see this:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

No commit was completed in that instance. However, if your message contains the proper pattern, Git allows you to commit:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Next, you want to make sure you aren’t modifying files that are outside your ACL scope. If your project’s `.git` directory contains a copy of the ACL file you used previously, then the following `pre-commit` script will enforce those constraints for you:

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

This is roughly the same script as the server-side part, but with two important differences. First, the ACL file is in a different place, because this script runs from your working directory, not from your Git directory. You have to change the path to the ACL file from this

	access = get_acl_access_data('acl')

to this:

	access = get_acl_access_data('.git/acl')

The other important difference is the way you get a listing of the files that have been changed. Because the server-side method looks at the log of commits, and, at this point, the commit hasn’t been recorded yet, you must get your file listing from the staging area instead. Instead of

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

you have to use

	files_modified = `git diff-index --cached --name-only HEAD`

But those are the only two differences — otherwise, the script works the same way. One caveat is that it expects you to be running locally as the same user you push as to the remote machine. If that is different, you must set the `$user` variable manually.

The last thing you have to do is check that you’re not trying to push non-fast-forwarded references, but that is a bit less common. To get a reference that isn’t a fast-forward, you either have to rebase past a commit you’ve already pushed up or try pushing a different local branch up to the same remote branch.

Because the server will tell you that you can’t push a non-fast-forward anyway, and the hook prevents forced pushes, the only accidental thing you can try to catch is rebasing commits that have already been pushed.

Here is an example pre-rebase script that checks for that. It gets a list of all the commits you’re about to rewrite and checks whether they exist in any of your remote references. If it sees one that is reachable from one of your remote references, it aborts the rebase:

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
	    if shas_pushed.split(“\n”).include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

This script uses a syntax that wasn’t covered in the Revision Selection section of Chapter 6. You get a list of commits that have already been pushed up by running this:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

The `SHA^@` syntax resolves to all the parents of that commit. You’re looking for any commit that is reachable from the last commit on the remote and that isn’t reachable from any parent of any of the SHAs you’re trying to push up — meaning it’s a fast-forward.

The main drawback to this approach is that it can be very slow and is often unnecessary — if you don’t try to force the push with `-f`, the server will warn you and not accept the push. However, it’s an interesting exercise and can in theory help you avoid a rebase that you might later have to go back and fix.

## Summary ##

You’ve covered most of the major ways that you can customize your Git client and server to best fit your workflow and projects. You’ve learned about all sorts of configuration settings, file-based attributes, and event hooks, and you’ve built an example policy-enforcing server. You should now be able to make Git fit nearly any workflow you can dream up.
