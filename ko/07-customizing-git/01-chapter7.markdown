# Git맞춤 #

지금까지 Git이 어떻게 동작하고 Git을 어떻게 사용하는지 설명했다. 이제 Git을 좀 더 쉽고 편하게 사용할 수 있도록 도와주는 도구를 살펴본다. 이 장에서는 먼저 많이 쓰이는 설정 그리고 훅 시스템을 먼저 설명한다. 그 후에 Git을 내게 맞추어(Customize) 본다. Git을 자신의 프로젝트에 맞추고 편하게 사용하자.

## Git 설정하기 ##

1장에서 설명했지만, 제일 먼저 해야 하는 것은 `git config` 명령으로 이름과 e-mail 주소를 설정하는 것이다:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

이렇게 설정하는 것들 중에서 중요한 것을 몇 가지 설명한다.

아주 기초적인 설정은 1장에서도 설명했지만, 이번 장에서 다시 한 번 복습한다. Git은 내장된 기본 규칙 따르지만, 설정된 것이 있으면 그에 따른다. Git은 먼저 `/etc/gitconfig` 파일을 찾는다. 이 파일은 해당 시스템에 있는 모든 사용자와 모든 저장소에 적용되는 설정 파일이다. `git config` 명령에 `--system` 옵션을 주면 이 파일을 사용한다.

다음으로 `~/.gitconfig` 파일을 찾는다. 이 파일은 해당 사용자에게만 적용되는 설정 파일이다. `--global` 옵션을 주면 Git은 이 파일을 사용한다.

마지막으로 현재 작업 중인 저장소의 Git 디렉토리에 있는 `.git/config` 파일을 찾는다. 이 파일은 해당 저장소에만 적용된다. 각 설정 파일에 중복된 설정이 있으면 설명한 순서대로 덮어쓴다. 예를 들어 `.git/config`와 `/etc/gitconfig`에 같은 설정이 들어 있다면 `.git/config`에 있는 설정을 사용한다. 설정 파일은 손으로 직접 편집해도 되지만 보통 `git config` 명령을 사용하는 것이 더 편하다.

### 클라이언트 설정 ###

설정은 클라이언트와 서버로 나뉜다. 대부분은 개인작업 환경과 관련된 클라이언트 설정이다. Git에는 설정거리가 매우 많은데, 여기서는 Workflow를 관리하는 데 필요한 것과 잘 사용하는 것만 설명한다. 한 번도 겪지 못할 상황에서나 유용한 옵션까지 다 포함하면 설정할 게 너무 많다. Git 버전마다 옵션이 조금씩 다른데, 아래와 같이 실행하면 설치한 버전에서 사용할 수 있는 옵션을 모두 보여준다:

	$ git config --help

어떤 옵션을 사용할 수 있는지 `git config`의 에 자세히 설명돼 있다.

#### core.editor ####

Git은 편집기를 설정하지 않았거나 설정한 편집기를 찾을 수 없으면 Vi를 실행한다. 커밋할 때나 tag 메시지를 편집할 때 설정한 편집기를 실행한다. `code.editor` 설정으로 편집기를 설정한다:

	$ git config --global core.editor emacs

이렇게 설정하면 메시지를 편집할 때 환경변수에 설정한 편집기가 아니라 Emacs를 실행한다.

#### commit.template ####

커밋할 때 Git이 보여주는 커밋 메시지는 이 옵션에 설정한 템플릿 파일이다. 예를 들어 `$HOME/.gitmessage.txt` 파일을 아래와 같이 만든다:

	subject line

	what happened

	[ticket: X]

이 파일을 `commit.template`에 설정하면 Git은 `git commit` 명령이 실행하는 편집기에 이 메시지를 기본으로 넣어준다:

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

그러면 commit할 때 아래와 같은 메시지를 편집기에 자동으로 채워준다:

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

소속 팀에 커밋 메시지 규칙이 있으면 그 규칙에 맞는 템플릿 파일을 만든다. Git이 그 파일을 사용하도록 설정하면 규칙을 따르기가 쉬워진다.

#### core.pager ####

Git은 `log`나 `diff`같은 명령의 메시지를 출력할 때 페이지로 나누어 보여준다. 기본으로 사용하는 명령은 `less`다. `more`를 더 좋아하면 `more`라고 설정한다. 페이지를 나누고 싶지 않으면 빈 문자열로 설정한다:

	$ git config --global core.pager ''

이 명령을 실행하면 Git은 길든지 짧든지 결과를 한 번에 다 보여 준다.

#### user.signingkey ####

*2장*에서 설명했던 Annotated Tag를 만들 때 유용하다. 사용할 GPG 키를 설정해 둘 수 있다. 아래 처럼 GPG 키를 설정하면 서명할 때 편리하다:

	$ git config --global user.signingkey <gpg-key-id>

`git tag` 명령을 실행할 때 키를 생략하고 서명할 수 있다:

	$ git tag -s <tag-name>

#### core.excludesfile ####

Git이 무시하는 untracked 파일은 `.gitignore`에 해당 패턴을 적으면 된다고 *2장*에서 설명했다. 해당 패턴의 파일은 `git add` 명령으로 추가해도 Stage되지 않는다. `.gitignore` 파일을 저장소 밖에 두고 관리하고 싶으면 `core.excludesfile`에 해당 파일의 경로를 설정한다. 이 파일을 작성하는 방법은 `.gitignore` 파일을 작성하는 방법과 같다. 그리고 `core.excludesfile`에 설정한 파일과 저장소 안에 있는 `.gitignore` 파일은 둘 다 사용된다.

#### help.autocorrect ####

이 옵션은 Git 1.6.1 버전부터 사용할 수 있다. 명령어를 잘못 입력하면 Git은 메시지를 아래와 같이 보여 준다:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

그러나 `help.autocorrect`를 1로 설정하면 명령어를 잘못 입력해도 Git이 자동으로 해당 명령어를 찾아서 실행해준다. 단, 해당 명령어가 딱 하나 찾았을 때에만 실행한다.

### 컬러 터미널 ###

사람이 쉽게 인식할 수 있도록 터미널에 결과를 컬러로 출력할 수 있다. 터미널 컬러와 관련된 옵션은 매우 다양하기 때문에 꼼꼼하게 설정할 수 있다.

#### color.ui ####

`color.ui`를 true로 설정하면 Git이 알아서 결과에 색칠한다. 물론 무엇을 어떤 색으로 칠할지 꼼꼼하게 설정할 수 있지만, 이 옵션을 켜면 터미널을 그냥 기본 컬러로 칠한다.

	$ git config --global color.ui true

이 옵션을 켜면 Git은 터미널에 컬러로 결과를 출력한다. 이 값을 false로 설정하면 절대 컬러로 출력하지 않는다. 결과를 파일로 리다이렉트하거나 다른 프로그램으로 보낼(Piping. 파이프라인)때도 그렇다.

`color.ui = always`라고 설정하면 결과를 리다이렉트할 때에도 컬러 코드가 출력된다. 이렇게까지 설정해야 하는 경우는 매우 드물다. 대신 Git 명령에는 `--color` 옵션이 있어서 어떻게 출력할지 그때그때 정해줄 수 있다. 보통은 `color.ui = true` 만으로도 충분하다.

#### `color.*` ####

Git은 좀 더 꼼꼼하게 컬러를 설정하는 방법을 제공한다. 아래와 같은 설정들이 있다. 모두 `true`, `false`, `always` 중 하나를 고를 수 있다:

	color.branch
	color.diff
	color.interactive
	color.status

또한, 각 옵션의 컬러를 직접 지정할 수도 있다. 아래처럼 설정하면 diff 명령에서 meta 정보의 포그라운드는 blue, 백그라운드는 black, 테스트는 bold로 바뀐다:

	$ git config --global color.diff.meta "blue black bold"

컬러는 normal, black, red, green, yellow, blue, magenta, cyan, white 중에서 고를 수 있고 텍스트 속성은 bold, dim, ul, blink, reverse 중에서 고를 수 있다.

`git config` 맨페이지를 보면 어떤 설정거리가 있는지 자세히 나온다.

### 다른 Merge, Diff 도구 사용하기 ###

Git에 들어 있는 diff 말고 다른 도구로 바꿀 수 있다. 화려한 GUI 도구로 바꿔서 좀 더 편리하게 충돌을 해결할 수 있다. 여기서는 Perforce의 Merge 도구인 P4Merge로 설정하는 것을 보여준다. P4Merge는 무료인데다 꽤 괜찮다.

P4Merge는 중요 플랫폼을 모두 지원하기 때문에 웬만한 환경이면 사용할 수 있다. 여기서는 Mac과 Linux 시스템에 설치하는 것을 보여준다. 윈도에서 사용하려면 `/usr/local/bin` 경로만 윈도 경로로 바꿔준다.

다음 페이지에서 P4Merge를 내려받는다:

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

먼저 P4Merge에 쓸 Wrapper 스크립트를 만든다. 필자는 Mac 사용자라서 Mac 경로를 사용한다. 어떤 시스템이든 `p4merge`가 설치된 경로를 사용하면 된다. extMerge라는 Merge용 Wrapper 스크립트를 만들고 이 스크립트로 넘어오는 모든 아규먼트를 p4merge 프로그램으로 넘긴다:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

그리고 diff용 Wrapper도 만든다. 이 스크립트로 넘어오는 아규먼트는 총 7개지만 그 중 2개만 Merge Wrapper로 넘긴다. Git이 diff 프로그램에 넘겨주는 아규먼트는 아래와 같다:

	path old-file old-hex old-mode new-file new-hex new-mode

이 중에서 `old-file`과 `new-file` 만 사용하는 wrapper script를 만든다:

	$ cat /usr/local/bin/extDiff
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

이 두 스크립트에 실행 권한을 부여한다:

	$ sudo chmod +x /usr/local/bin/extMerge
	$ sudo chmod +x /usr/local/bin/extDiff

Git config 파일에 이 스크립트를 모두 추가한다. 설정해야 하는 옵션이 좀 많다. `merge.tool`로 무슨 Merge 도구를 사용할지, `mergetool.*.cmd`로 실제로 어떻게 명령어를 실행할지, `mergetool.trustExitCode`로 Merge 도구가 반환하는 exit 코드가 merge의 성공여부를 나타내는지, `diff.external`은 diff할 때 실행할 명령어가 무엇인지를 설정할 때 사용한다. 모두 `git config` 명령으로 설정한다:

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

`~/.gitconfig/` 파일을 직접 편집해도 된다:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	  trustExitCode = false
	[diff]
	  external = extDiff

설정을 완료하고 나서 아래와 같이 diff 명령어를 실행한다: 

	$ git diff 32d1776b1^ 32d1776b1

diff 결과가 터미널에 출력되는 대신 P4Merge가 실행된다. 그리고 그림 7-1처럼 그 프로그램 안에서 보여준다:

Insert 18333fig0701.png
그림 7-1. P4Merge

브랜치를 Merge할 때 충돌이 나면 `git mergetool` 명령을 실행한다. 이 명령을 실행하면 GUI 도구로 충돌을 해결할 수 있도록 P4Merge를 실행해준다.

Wrapper를 만들어 설정해두면 다른 diff, Merge 도구로 바꾸기도 쉽다. 예를 들어, KDiff3를 사용하도록 extDiff와 extMerge 스크립트를 수정한다:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

이제부터 Git은 diff 결과를 보여주거나 충돌을 해결할 때 KDiff3 도구를 사용한다.

어떤 Merge 도구는 Git에 미리 cmd 설정이 들어 있다. 그래서 cmd 설정 없이 사용할 수 있는 것도 있다. kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff는 cmd 설정 없이 Merge 도구로 사용할 수 있다. diff 도구로는 다른 것을 사용하지만, Merge 도구로는 KDiff3를 사용하고 싶은 경우에는 kdiff3 명령을 실행경로로 넣고 아래와 같이 설정하기만 하면 된다:

	$ git config --global merge.tool kdiff3

extMerge와 extDiff 파일을 사용하지 않고 이렇게 Merge 도구만 kdiff3로 설정하고 diff 도구는 Git에 원래 들어 있는 것을 사용할 수 있다.

### 소스 포맷과 공백 ###

협업할 때 겪는 소스 포맷(Formatting)과 공백 문제는 미묘하고 난해하다. 동료 사이에 사용하는 플랫폼이 다를 때는 특히 더 심하다. 다른 사람이 보내온 Patch는 공백 문자 패턴이 미묘하게 다를 확률이 높다. 편집기가 몰래 공백문자를 추가해 버릴 수도 있고 크로스-플랫폼 프로젝트에서 윈도 개발자가 줄 끝에 CR(Carriage-Return) 문자를 추가해 버렸을 수도 있다. Git에는 이 이슈를 돕는 몇 가지 설정이 있다.

#### core.autocrlf ####

윈도에서 개발하는 동료와 함께 일하면 줄 바꿈(New Line) 문자에 문제가 생긴다. 윈도는 줄 바꿈 문자로 CR(Carriage-Return)과 LF(Line Feed) 문자를 둘 다 사용하지만, Mac과 Linux는 LF 문자만 사용한다. 아무것도 아닌 것 같지만, 크로스 플랫폼 프로젝트에서는 꽤 성가신 문제다.

Git은 커밋할 때 자동으로 CRLF를 LF로 변환해주고 반대로 Checkout할 때 LF를 CRLF로 변환해 주는 기능이 있다. `core.autocrlf` 설정으로 이 기능을 켤 수 있다. 윈도에서 이 값을 true로 설정하면 Checkout할 때 LF 문자가 CRLR 문자로 변환된다:

	$ git config --global core.autocrlf true

줄 바꿈 문자로 LF를 사용하는 Linux와 Mac에서는 Checkout할 때 Git이 LF를 CRLF로 변환할 필요가 없다. 게다가 우연히 CRLF가 들어간 파일이 저장소에 들어 있어도 Git이 알아서 고쳐주면 좋을 것이다. `core.autocrlf` 값을 input으로 설정하면 커밋할 때만 CRLF를 LF로 변환한다:

	$ git config --global core.autocrlf input

이 설정을 이용하면 윈도에서는 CRLF를 사용하고 Mac, Linux, 저장소에서는 LF를 사용할 수 있다.

윈도 플랫폼에서만 개발하면 이 기능이 필요 없다. 이 옵션을 `false`라고 설정하면 이 기능이 꺼지고 CR 문자도 저장소에도 저장된다:

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git에는 공백 문자를 다루는 방법으로 네 가지가 미리 정의돼 있다. 두 가지는 기본적으로 켜져 있지만 끌 수 있고 나머지 두 가지는 꺼져 있지만 켤 수 있다.

먼저 기본적으로 켜져 있는 것을 살펴보자. `trailing-space`는 각 줄 끝에 공백이 있는지 찾고 `space-before-tab`은 모든 줄 처음에 tab보다 공백이 먼저 나오는지 찾는다.

기본적으로 꺼져 있는 나머지 두 개는 `indent-with-non-tab`과 `cr-at-eol`이다. `intent-with-non-tab`은 tab이 아니라 공백 8자 이상으로 시작하는 줄이 있는지 찾고 `cr-at-eol`은 줄 끝에 CR 문자가 있어도 괜찮다고 Git에 알리는 것이다.

`core.whitespace` 옵션으로 이 네 가지 방법을 켜고 끌 수 있다. 설정에서 해당 옵션을 빼버리거나 이름이 `-`로 시작하면 기능이 꺼진다. 예를 들어, 다른 건 다 켜고 `cr-at-eol` 옵션만 끄려면 아래와 같이 설정한다:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

`git diff` 명령을 실행하면 Git은 이 설정에 따라 검사해서 컬러로 표시해준다. 그래서 좀 더 쉽게 검토해서 커밋할 수 있다. `git apply` 명령으로 Patch를 적용할 때도 이 설정을 이용할 수 있다. 아래처럼 명령어를 실행하면 해당 Patch가 공백문자 정책에 들어맞는지 확인할 수 있다:

	$ git apply --whitespace=warn <patch>

아니면 Git이 자동으로 고치도록 할 수 있다:

	$ git apply --whitespace=fix <patch>

이 옵션은 `git rebase` 명령에서도 사용할 수 있다. 공백 문제가 있는 커밋을 서버로 Push하기 전에  `--whitespace=fix` 옵션을 주고 Rebase하면 Git은 다시 Patch를 적용하면서 공백을 설정한 대로 고친다.

### 서버 설정 ###

서버 설정은 많지 않지만, 꼭 짚고 넘어가야 하는 것이 몇 개 있다.

#### receive.fsckObjects ####

Git은 Push할 때 기본적으로 개체를 검증하지(check for consistency) 않는다. 하지만, Push할 때마다 각 개체가 SHA-1 체크섬에 맞는지, 잘못된 개체가 가리키고 있는지 검사하게 할 수 있다. 개체를 점검하는 것은 상대적으로 느려서 Push하는 시간이 늘어난다. 얼마나 늘어나는지는 저장소 크기와 Push하는 양에 달렸다. `receive.fsckOBjects` 값을 true로 설정하면 Git이 Push할 때마다 검증한다.

	$ git config --system receive.fsckObjects true

이렇게 설정하면 Push할 때마다 검증하기 때문에 클라이언트는 잘못된 데이터를 Push하지 못한다.

#### receive.denyNonFastForwards ####

이미 Push한 커밋을 Rebase해서 다시 Push하지 못하게 할 수 있다. 브랜치를 Push할 때 해당 리모트 브랜치가 가리키는 커밋이 Push하려는 브랜치에 없을 때 Push하지 못하게 할 수 있다. 보통은 이런 정책이 좋고 `git push` 명령에 `-f` 옵션을 주면 강제로 Push할 수 있다.

하지만, 강제로 Push하지 못하게 할 수도 있다. `receive.denyNonFastForwards` 옵션을 켜면 Fast-forward로 Push할 수 없는 브랜치는 아예 Push하지 못한다:

	$ git config --system receive.denyNonFastForwards true

사용자마다 다른 정책을 적용하고 싶으면 서버 훅을 사용해야 한다. 서버의 receive 훅으로 할 수 있고 이 훅도 이 장에서 설명한다.

#### receive.denyDeletes ####

`receive.denyNonFastForwards`와 비슷한 정책으로 `receive.denyDeletes`라는 것이 있다. 이 설정을 켜면 브랜치를 삭제하는 Push가 거절된다. Git 1.6.1부터 receive.denyDeletes를 사용할 수 있다:

	$ git config --system receive.denyDeletes true

이제 브랜치나 Tag를 삭제하는 Push는 거절된다. 아무도 삭제할 수 없다. 리모트 브랜치를 삭제하려면 직접 손으로 server의 ref 파일을 삭제해야 한다. 그리고 사용자마다 다른 정책을 적용시키는 ACL을 만드는 방법도 있다. 이 방법은 이 장 끝 부분에서 다룬다.

## Git Attribute ##

디렉토리와 파일 단위로 다른 설정을 적용할 수도 있다. 이렇게 경로별로 설정하는 것을 'Git Attribute'라고 부른다. 이 설정은 `.gitattributes`라는 파일에 저장하고 아무 디렉토리에나 둘 수 있지만, 보통은 프로젝트 최상위 디렉토리에 둔다. 그리고 이 파일을 커밋하고 싶지 않으면 `.gitattributes`가 아니라 `.git/info/attributes`로 파일을 만든다.

이 Attribute로 Merge는 어떻게 할지, 텍스트가 아닌 파일은 어떻게 Diff할지, checkin/checkout할 때 어떻게 필터링할지 정해줄 수 있다. 이 절에서는 설정할 수 있는 Attribute가 어떤 것이 있는지, 그리고 어떻게 설정하는지 배우고 예제를 살펴본다.

### 바이너리 파일 ###

이 Attribute로 어떤 파일이 바이너리 파일인지 Git에게 알려줄 수 있다. 기본적으로 Git은 어떤 파일이 바이너리 파일인지 알지 못한다. 하지만, Git에는 파일을 어떻게 다뤄야 하는지 알려주는 방법이 있다. 텍스트 파일 중에서 프로그램이 생성하는 파일에는 바이너리 파일과 진배없는 파일이 있다. 이런 파일은 diff할 수 없으니 바이너리 파일이라고 알려줘야 한다. 반대로 바이너리 파일 중에서 취급 방법을 Git에 알려주면 diff할 수 있는 파일도 있다.

#### 바이너리 파일이라고 알려주기 ####

사실 텍스트 파일이지만 만든 목적과 의도를 보면 바이너리 파일인 것이 있다. 예를 들어 Mac의 Xcode는 `.pbxproj` 파일을 만든다. 이 파일은 IDE 설정 등을 디스크에 저장하는 파일로 JSON 포맷이다. 모든 것이 ASCII인 텍스트 파일이지만 실제로는 간단한 데이터베이스이기 때문에 텍스트 파일처럼 취급할 수 없다. 그래서 여러 명이 이 파일을 동시에 수정하고 Merge할 때 diff가 도움이 안 된다. 이 파일은 프로그램이 읽고 쓰는 파일이기 때문에 바이너리 파일처럼 취급하는 것이 옳다.

모든 `pbxproj` 파일을 바이너리로 파일로 취급하는 설정은 아래와 같다. `.gitattributes` 파일에 넣으면 된다:

	*.pbxproj -crlf -diff

이제 `pbxproj` 파일은 CRLF 변환이 적용되지 않는다. `git show`나 `git diff` 같은 명령을 실행할 때에도 통계를 계산하거나 diff를 출력하지 않는다. Git 1.6부터는 `-crlf -diff`를 한 마디로 줄여서 표현할 수 있다:

	*.pbxproj binary

#### 바이너리 파일 Diff하기 ####

Git은 바이너리 파일도 diff할 수 있다. Git Attribute를 통해 Git이 바이너리 파일을 텍스트 포맷으로 변환하고 그 결과를 diff로 비교하도록 하는 것이다. 그래서 문제는 어떻게 *바이너리*를 텍스트로 변환해야 할까에 있다. 바이너리를 텍스트로 변환해 주는 도구 중에서 내가 필요한 바이너리 파일에 꼭 맞는 도구를 찾는게 가장 좋다. 사람이 읽을 수 있는 텍스트로 표현된 바이너리 포맷은 극히 드물다(오디오 데이터를 텍스트로 변환한다고 생각해보라). 파일 내용을 텍스트로 변환할 방법을 찾지 못했을 때는 파일의 설명이나 메타데이터를 텍스트로 변환하는 방법을 찾아보자. 이런 방법이 가능한 경우가 많다. 메타데이터는 파일 내용을 완벽하게 알려주지 않지만 전혀 비교하지 못하는 것보다 이렇게라도 하는 게 훨씬 낫다.

여기서 설명한 두 가지 방법을 많이 사용하는 바이너리 파일에 적용해 볼 거다.

댓글: 전용 변환기는 없지만 텍스트가 들어 있는 바이너리 포맷들이 있다. 이런 포맷은 `strings` 프로그램으로 바이너리 파일에서 텍스트를 추출한다. 이런 종류의 바이너리 파일 중에서 UTF-16 인코딩이나 다른 "codepages"로 된 파일들도 있다. 그런 인코딩으로 된 파일에서 `strings`으로 추출할 수 있는 텍스트는 제한적이다. 상황에 따라 다르게 추출된다. 그래도 `strings`는 Mac과 Linux 시스템에서 쉽게 사용할 수 있기 때문에 다양한 바이너리 파일에 쉽게 적용할 수 있다.

##### MS Word 파일 #####

먼저 이 기술을 인류에게 알려진 가장 귀찮은 문제 중 하나인 Word 문서를 버전 관리하는 상황을 살펴보자. 모든 사람이 Word가 가장 끔찍한 편집기라고 말하지만 애석하게도 모두 Word를 사용한다. Git 저장소에 넣고 이따금 커밋하는 것만으로도 Word 문서의 버전을 관리할 수 있다. 그렇지만 `git diff`를 실행하면 다음과 같은 메시지를 볼 수 있을 뿐이다:

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

직접 파일을 하나하나 까보지 않으면 두 버전이 뭐가 다른지 알 수 없다. Git Attribute를 사용하면 이를 더 좋게 개선할 수 있다. `.gitattributes` 파일에 아래와 같은 내용을 추가한다:

	*.doc diff=word

이것은 `*.doc` 파일의 두 버전이 무엇이 다른지 diff할 때 "word" 필터를 사용하라고 설정하는 것이다. 그럼 "word" 필터는 뭘까? 이 "word" 필터도 정의해야 한다. Word 문서에서 사람이 읽을 수 있는 텍스트를 추출해주는 `catdoc` 프로그램을 "word" 필터로 사용한다. 그러면 Word 문서를 diff할 수 있다. (catdoc 프로그램은 MS Word 문서에 특화된 텍스트 추출기다. `http://www.wagner.pp.ru/~vitus/software/catdoc/`에서 구할 수 있다):

	$ git config diff.word.textconv catdoc

위의 명령은 아래와 같은 내용을 `.git/config` 파일에 추가한다:

	[diff "word"]
	    textconv = catdoc

이제 Git은 확장자가 `.doc`인 파일의 스냅샷을 diff할 때 "word" 필터로 정의한 `catdoc` 프로그램을 사용한다. 이 프로그램은 Word 파일을 텍스트 파일로 변환해 주기 때문에 diff할 수 있다.

이 책의 *1장*을 Word 파일로 만들어서 Git에 넣고 나서 단락 하나를 수정하고 저장하는 예를 살펴보자. `git diff`를 실행하면 어디가 달려졌는지 확인할 수 있다:

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

Git은 "(See Chapter 3)"가 추가됐다는 것을 정확하게 찾아 준다.

##### OpenDocument 파일 #####

MS Word(`*.doc`) 파일에 사용한 방법은 OpenOffice.org(혹은 LibreOffice.org) 파일 형식인 OpenDocument(`*.odt`) 파일에도 적용할 수 있다.

아래의 내용을 `.gitattributes` 파일에 추가한다:

	*.odt diff=odt

`.git/config` 파일에 `odt` diff 필터를 설정한다:

	[diff "odt"]
	    binary = true
	    textconv = /usr/local/bin/odt-to-txt

OpenDocument 파일은 사실 여러 파일(XML, 스타일, 이미지 등등)을 Zip으로 압축한 형식이다. OpenDocument 파일에서 텍스트만 추출하는 스크립트를 하나 작성한다. 아래와 같은 내용을 `/usr/local/bin/odt-to-txt` 파일로(다른 위치에 저장해도 상관없다) 저장한다:

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

그리고 실행 가능하도록 만든다:

	chmod +x /usr/local/bin/odt-to-txt

이제 `git diff` 명령으로 `.odt` 파일에 대한 변화를 살펴볼 수 있다.

##### 이미지 파일 #####

이 방법으로 이미지 파일도 diff할 수 있다. 필터로 EXIF 정보를 추출해서 PNG 파일을 비교한다. EXIF 정보는 대부분의 이미지 파일에 들어 있는 메타데이터다. `exiftool`이라는 프로그램을 설치하고 이미지 파일에서 메타데이터 텍스트를 추출한다. 그리고 그 결과를 diff해서 무엇이 달라졌는지 본다:

	$ echo '*.pngdiff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

프로젝트에 들어 있는 이미지 파일을 변경하고 `git diff`를 실행하면 아래와 같이 보여준다:

	diff --git a/image.pngb/image.png
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

이미지 파일의 크기와 해상도가 달라진 것을 쉽게 알 수 있다:

### 키워드 치환 ###

SVN이나 CVS에 익숙한 사람들은 해당 시스템에서 사용하던 키워드 치환(Keyword Expansion) 기능을 찾는다. Git에서는 이것이 쉽지 않다. Git은 먼저 체크섬을 계산하고 커밋하기 때문에 그 커밋에 대한 정보를 가지고 파일을 수정할 수 없다. 하지만, Checkout할 때 그 정보가 자동으로 파일에 삽입되도록 했다가 다시 커밋할 때 삭제되도록 할 수 있다.

파일 안에 `$Id$` 필드를 넣으면 Blob의 SHA-1 체크섬을 자동으로 삽입한다. 이 필드를 파일에 넣으면 Git은 앞으로 Checkout할 때 해당 Blob의 SHA-1 값으로 교체한다. 여기서 꼭 기억해야 할 것이 있다. 교체되는 체크섬은 커밋의 것이 아니라 Blob 그 자체의 SHA-1 체크섬이다:

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

Git은 이 파일을 Checkout할 때마다 SHA 값을 삽입해준다:

	$ rm test.txt
	$ git checkout -- test.txt
	$ cat test.txt
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

하지만 이것은 별로 유용하지 않다. CVS나 SVN의 키워드 치환(Keyword Substitution)을 써봤으면 날짜(Datestamp)도 가능했다는 것을 알고 있을 것이다. SHA는 그냥 해시이고 식별할 수 있을 뿐이지 다른 것을 알려주진 않는다. SHA만으로는 예전 것보다 새 것인지 오래된 것인지는 알 수 없다.

Commit/Checkout할 때 사용하는 필터를 직접 만들어 쓸 수 있다. 방향에 따라 "clean" 필터와 "smudge" 필터라고 부른다. ".gitattributes" 파일에 설정하고 파일 경로마다 다른 필터를 설정할 수 있다. Checkout할 때 파일을 처리하는 것이 "smudge" 필터이고(그림 7-2) 커밋할 때 처리하는 필터가 "clean" 필터이다. 이 필터로 할 수 있는 일은 무궁무진하다.

Insert 18333fig0702.png
그림 7-2. "smudge" 필터는 Checkout할 때 실행된다

Insert 18333fig0703.png
그림 7-3. "clean" 필터는 파일을 Stage할 때 실행된다

커밋하기 전에 `indent` 프로그램으로 C 코드 전부를 필터링하지만 커밋 메시지는 단순한 예제를 보자. `*.c` 파일은 indent 필터를 사용하도록 `.gitattributes` 파일에 설정한다:

	*.c     filter=indent

아래처럼 "indent" 필터의 smudge와 clean이 무엇인지 설정한다:

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

`*.c` 파일을 커밋하면 `indent` 프로그램을 통해서 커밋되고 Checkout하면 `cat` 프로그램을 통해 Checkout된다. `cat`은 입력된 데이터를 그대로 다시 내보내는, 사실 아무것도 안 하는 프로그램이다. 이렇게 설정하면 모든 C 소스 파일은 `indent` 프로그램을 통해 커밋된다.

이제 RCS 처럼 `$Date$`를 치환하는 예제을 살펴보자. 이것를 하려면 간단한 스크립트가 하나 필요하다. 이 스크립트는 `$Date$` 필드를 프로젝트의 마지막 커밋 일자로 치환한다. 표준 입력을 읽어서 `$Date$` 필드를 치환한다. 아래는 Ruby로 구현한 스크립트다:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

`git log` 명령으로 마지막 커밋 정보를 얻고 표준 입력(STDIN)에서 `$Date$` 스트링을 찾아서 치환한다. 스크립트는 자신이 편한 언어로 만든다. 이 스크립트의 이름을 `expand_date`라고 짓고 실행 경로에 넣는다. 그리고 `dater`라는 Git 필터를 정의한다. Checkout시 실행하는 smudge 필터로 `expand_date`를 사용하고 커밋할 때 실행하는 clean 필터는 Perl을 사용한다:

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

이 Perl 코드는 `$Date$` 스트링에 있는 문자를 제거해서 원래대로 복원한다. 이제 필터가 준비됐으니 `$Date$` 키워드가 들어 있는 파일을 만들고 Git Attribute를 설정한다. 새 필터를 시험해보자:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

커밋하고 파일을 다시 Checkout 하면 해당 키워드가 적절히 치환된 것을 볼 수 있다:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

이것은 매우 강력해서 두루두루 사용할 수 있다. `.gitattributes` 파일은 커밋하는 파일이기 때문에 드라이버(여기서는 `dater`)가 없는 사람에게도 배포된다. 그리고 `dater`가 없으면 에러가 난다. 필터를 만들 때 이런 예외 상황도 고려해서 항상 잘 동작하게 해야 한다.

### 저장소 익스포트하기 ###

프로젝트를 익스포트해서 아카이브를 만들 때에도 Git Attribute가 유용하다.

#### export-ignore ####

아카이브를 만들 때 제외할 파일이나 디렉토리가 무엇인지 설정할 수 있다. 특정 디렉토리나 파일을 프로젝트에는 포함하고 아카이브에는 포함하고 싶지 않을 때 `export-ignore` Attribute를 사용한다.

예를 들어 `test/` 디렉토리에 테스트 파일이 있다고 하자. 보통 tar 파일로 묶어서 익스포트할 때 테스트 파일은 포함하지 않는다. Git Attribute 파일에 다음 라인을 추가하면 테스트 파일은 무시된다:

	test/ export-ignore

`git archive` 명령으로 tar 파일을 만들면 test 디렉토리는 아카이브에 포함되지 않는다.

#### export-subst ####

아카이브를 만들 때에도 키워드 치환을 할 수 있다. 파일을 하나 만들고 거기에 `$Format:$` 스트링을 넣으면 Git이 치환해준다. 이 스트링에 `--pretty=format` 옵션에 사용하는 것과 같은 포맷 코드를 넣을 수 있다. `--pretty=format`은 *2장*에서 배웠다. 예를 들어 `LAST_COMMIT`이라는 파일을 만들고 `git archive` 명령을 실행할 때 자동으로 이 파일에 마지막 커밋 날짜가 삽입되게 하려면 아래와 같이 해야 한다:

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

`git archive` 명령으로 아카이브를 만들고 나서 이 파일을 열어보면 아래와 같이 보인다:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge 전략 ###

파일마다 다른 Merge 전략을 사용하도록 설정할 수 있다. Merge할 때 충돌이 날 것 같은 파일이 있다고 하자. Git Attrbute로 이 파일만 항상 타인의 코드 말고 내 코드를 사용하도록 설정할 수 있다.

이 설정은 다양한 환경에서 운영하려고 만든 환경 브랜치를 Merge할 때 좋다. 이때는 환경 설정과 관련된 파일은 Merge하지 않고 무시하는 게 편리하다. 브랜치에 `database.xml`이라는 데이터베이스 설정파일이 있는데 이 파일은 브랜치마다 다르다. Database 설정 파일은 Merge하면 안된다. Attribute를 아래와 같이 설정하면 이 파일은 그냥 두고 Merge한다.

	database.xml merge=ours

이제 Merge해도 `database.xml` 파일은 충돌하지 않는다:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

Merge했지만 `database.xml`은 원래 가지고 있던 파일 그대로다.

## Git 훅 ##

Git도 다른 버전 관리 시스템처럼 어떤 이벤트가 생겼을 때 자동으로 특정 스크립트를 실행하도록 할 수 있다. 이 훅은 클라이언트 훅과 서버 훅으로 나눌 수 있다. 클라이언트 훅은 커밋이나 Merge할 때 실행되고 서버 훅은 Push할 때 서버에서 실행된다. 이 절에서는 어떤 훅이 있고 어떻게 사용하는지 배운다.

### 훅 설치하기 ###

훅은 Git 디렉토리 밑에 `hooks`라는 디렉토리에 저장한다. 기본 훅 디렉토리는 `.git/hooks`이다. 이 디렉토리에 가보면 Git이 자동으로 넣어준 매우 유용한 스크립트 예제가 몇 개 있다. 그리고 스크립트가 입력받는 값이 어떤 값인지 파일 안에 자세히 설명돼 있다. 모든 예제는 쉘과 Perl 스크립트로 작성돼 있지만 실행할 수만 있으면 되고 Ruby나 Python같은 다른 스크립트 언어로 만들어도 된다.예제 스크립트의 파일 이름에는 `.sample`이라는 확장자가 붙어 있다. 그래서 이름만 바꿔주면 그 훅을 사용할 수 있다.

실행할 수 있는 스크립트 파일을 저장소의 `hooks` 디렉토리에 넣으면 훅 스크립트가 켜진다. 이 스크립트는 앞으로 계속 호출된다. 중요한 훅은 여기서 모두 설명한다.

### 클라이언트 훅 ###

클라이언트 훅은 매우 다양하다. 이 절에서는 클라이언트 훅을 커밋 Workflow 훅, E-mail Workflow 훅, 그리고 나머지로 분류해서 설명한다.

#### 커밋 Workflow 훅 ####

먼저 커밋과 관련된 훅을 살펴보자. 커밋과 관련된 훅은 모두 네 가지다. `pre-commit` 훅은 커밋할 때 가장 먼저 호출되는 훅으로 커밋 메시지를 작성하기 전에 호출된다. 이 훅에서 커밋하는 Snapshot을 점검한다. 빠트린 것은 없는지, 테스트는 확실히 했는지 등을 검사한다. 커밋할 때 꼭 확인해야 할 게 있으면 이 훅으로 확인한다. 그리고 이 훅의 Exit 코드가 0이 아니면 커밋은 취소된다. 물론 `git commit --no-verify`라고 실행하면 이 훅을 일시적으로 생략할 수 있다. lint 같은 프로그램으로 코드 스타일을 검사하거나, 줄 끝의 공백 문자를 검사하거나(예제로 들어 있는 `pre-commit` 훅이 하는 게 이 일이다), 코드에 주석을 달았는지 검사하는 일은 이 훅으로 하는 것이 좋다.

`prepare-commit-msg` 훅은 Git이 커밋 메시지를 생성하고 나서 편집기를 실행하기 전에 실행된다. 이 훅은 사람이 커밋 메시지를 수정하기 전에 먼저 프로그램으로 손보고 싶을 때 사용한다. 이 훅은 커밋 메시지가 들어 있는 파일의 경로, 커밋의 종류를 아규먼트로 받는다. 그리고 최근 커밋을 수정할 때에는(Amending 커밋) SHA-1 값을 추가 아규먼트로 더 받는다. 사실 이 훅은 일반 커밋에는 별로 필요 없고 커밋 메시지를 자동으로 생성하는 커밋에 좋다. 커밋 메시지에 템플릿을 적용하거나, Merge 커밋, Squash 커밋, Amend 커밋일 때 유용하다. 이 스크립트로 커밋 메시지 템플릿에 정보를 삽입할 수 있다.

`commit-msg` 훅은 커밋 메시지가 들어 있는 임시 파일의 경로를 아규먼트로 받는다. 그리고 이 스크립트가 0이 아닌 값을 반환하면 커밋되지 않는다. 이 훅에서 최종적으로 커밋이 완료되기 전에 프로젝트 상태나 커밋 메시지를 검증한다. 이 장의 마지막 절에서 이 훅을 사용하는 예제를 보여준다. 커밋 메시지가 정책에 맞는지 검사하는 스크립트를 만들어 보자.

커밋이 완료되면 `post-commit` 훅이 실행된다. 이 훅은 넘겨받는 아규먼트가 하나도 없지만 `git log -1 HEAD` 명령으로 정보를 쉽게 가져올 수 있다. 일반적으로 이 스크립트는 커밋된 것을 누군가에게 알릴 때 사용한다.

이 커밋 Workflow 스크립트는 어떤 Workflow에나 사용할 수 있다. 특히 정책을 강제할 때 유용하다. 클라이언트 훅은 개발자가 클라이언트에서 사용하는 훅이다. 모든 개발자에게 유용한 훅이지만 Clone할 때 복사되지 않는다. 그래서 직접 설치하고 관리해야 한다. 물론 정책을 서버 훅으로 만들고 정책을 잘 지키는지 Push할 때 검사해도 된다.

#### E-mail Workflow 훅 ####

E-mail Workflow에 해당하는 클라이언트 훅은 세 가지이다. 이 훅은 모두 `git am` 명령으로 실행된다. 이 명령어를 사용할 일이 없으면 이 절은 읽지 않아도 된다. 하지만, 언젠가는 `git format-patch` 명령으로 만든 Patch를 E-mail로 받는 날이 올지도 모른다.

제일 먼저 실행하는 훅은 `applypatch-msg`이다. 이 훅의 아규먼트는 Author가 보내온 커밋 메시지 파일의 이름이다. 이 스크립트가 종료할 때 0이 아닌 값을 반환하면 Git은 Patch하지 않는다. 커밋 메시지가 규칙에 맞는지 확인하거나 자동으로 메시지를 수정할 때 이 훅을 사용한다.

`git am`으로 Patch할 때 두 번째로 실행되는 훅이 `pre-applypatch`이다. 이 훅은 아규먼트가 없고 단순히 Patch를 적용하고 나서 실행된다. 그래서 커밋할 스냅샷을 검사하는 데 사용한다. 이 스크립트로 테스트를 수행하고 파일을 검사할 수 있다. 테스트에 실패하거나 뭔가 부족하면 0이 아닌 값을 반환시켜서 `git am` 명령을 취소시킬 수 있다.

`git am` 명령에서 마지막으로 실행되는 훅은 `post-applypatch`다. 이 스크립트를 이용하면 자동으로 Patch를 보낸 사람이나 그룹에게 알림 메시지를 보낼 수 있다. 이 스크립트로는 Patch를 중단시킬 수 없다.

#### 기타 훅 ####

`pre-rebase` 훅은 Rebase하기 전에 실행된다. 이 훅이 0이 아닌 값을 반환하면 Rebase가 취소된다. 이 훅으로 이미 Push한 커밋을 Rebase하지 못하게 할 수 있다. Git이 자동으로 넣어주는 `pre-rebase` 예제가 바로 그 예제다. 이 예제에는 기준 브랜치가 `next`라고 돼 있다. 실제로 적용할 브랜치 이름으로 사용하면 된다.

그리고 `git checkout` 명령이 끝나면 `post-checkout` 훅이 실행된다. 이 훅은 Checkout할 때마다 작업하는 디렉토리에서 뭔가 할 일이 있을 때 사용한다. 그러니까 용량이 크거나 Git이 관리하지 않는 파일을 옮기거나, 문서를 자동으로 생성하는 데 쓴다.

마지막으로, `post-merge` 훅은 Merge가 끝나고 나서 실행된다. 이 훅은 파일 권한 같이 Git이 추적하지 않는 정보를 관리하는 데 사용한다. Merge로 Working Tree가 변경될 때 Git이 관리하지 않는 파일이 원하는 대로 잘 배치됐는지 검사할 때도 좋다.

### 서버 훅 ###

클라이언트 훅으로도 어떤 정책을 강제할 수 있지만, 시스템 관리자에게는 서버 훅이 더 중요하다. 서버 훅은 모두 Push 전후에 실행된다. Push 전에 실행되는 훅이 0이 아닌 값을 반환하면 해당 Push는 거절되고 클라이언트는 에러 메시지를 출력한다. 이 훅으로 아주 복잡한 Push 정책도 가능하다.

#### pre-receive와 post-receive ####

Push하면 가장 처음 실행되는 훅은 `pre-receive` 훅이다. 이 스크립트는 표준 입력(STDIN)으로 Push하는 레퍼런스의 목록을 입력받는다. 0이 아닌 값을 반환하면 해당 레퍼런스가 전부 거절된다. Fast-forward Push가 아니면 거절하거나, 브랜치 Push 권한을 제어하려면 이 훅에서 하는 것이 좋다. 관리자만 브랜치를 새로 Push하고 삭제할 수 있고 일반 개발자는 수정사항만 Push할 수 있게 할 수 있다.

`post-receive` 훅은 Push한 후에 실행된다. 이 훅으로 사용자나 서비스에 알림 메시지를 보낼 수 있다. 그리고 `pre-receive` 훅처럼 표준 입력(STDIN)으로 레퍼런스 목록이 넘어간다. 이 훅으로 메일링리스트에 메일을 보내거나, CI(Continuous Integration) 서버나 Ticket-tracking 시스템의 정보를 수정할 수 있다. 심지어 커밋 메시지도 파싱할 수 있기 때문에 이 훅으로 Ticket을 만들고, 수정하고, 닫을 수 있다. 이 스크립트가 완전히 종료할 때까지 클라이언트와의 연결은 유지되고 Push를 중단시킬 수 없다. 그래서 이 스크립트로 시간이 오래 걸릴만한 일을 할 때는 조심해야 한다.

#### update ####

update 스크립트는 각 브랜치마다 한 번씩 실행된다는 것을 제외하면 `pre-receive` 스크립트와 거의 같다. 한 번에 브랜치를 여러 개 Push하면 `pre-receive`는 딱 한 번만 실행되지만, update는 브랜치마다 실행된다. 이 스크립트는 표준 입력으로 데이터를 입력받는 것이 아니라 아규먼트로 브랜치 이름, 원래 가리키던 SHA-1 값, 사용자가 Push하는 SHA-1 값을 입력받는다. update 스크립트가 0이 아닌 값을 반환하면 해당 레퍼런스만 거절되고 나머지 다른 레퍼런스는 상관없다.

## 정책 구현하기 ##

지금까지 배운 것을 한 번 적용해보자. 커밋 메시지 규칙 검사하고, Fast-forward Push만 허용하고, 디렉토리마다 사용자의 수정 권한을 제어하는 Workflow를 만든다. 실질적으로 정책을 강제하려면 서버 훅으로 만들어야 한다. 하지만, 개발자들이 Push할 수 없는 커밋은 아예 만들지 않도록 클라이언트 훅도 만든다.

필자가 제일 좋아하는 Ruby로 만든다. 필자는 독자가 슈도코드를 읽듯이 Ruby 코드를 읽을 수 있다고 생각한다. Ruby를 모르더라도 충분히 개념을 이해할 수 있을 것이다. 하지만, Git은 언어를 가리지 않는다. Git이 자동으로 생성해주는 예제는 모두 Perl과 Bash로 작성돼 있다. 그래서 예제를 열어 보면 Perl과 Bash로 작성된 예제를 참고 할 수 있다.

### 서버 훅 ###

서버 정책은 전부 update 훅으로 만든다. 이 스크립트는 브랜치가 Push될 때마다 한 번 실행되고 해당 브랜치의 이름, 원래 브랜치가 가리키던 레퍼런스, 새 레퍼런스를 아규먼트로 받는다. 그리고 SSH를 통해서 Push하는 것이라면 누가 Push하는 지도 알 수 있다. SSH로 접근하긴 하지만 개발자 모두 계정 하나로("git" 같은) Push하고 있다면 실제로 Push하는 사람이 누구인지 판별해주는 쉘 Wrapper가 필요하다. 이 스크립트에서는 `$USER` 환경 변수에 현재 접속한 사용자 정보가 있다고 가정한다. update 스크립트는 필요한 정보를 수집하는 것으로 시작한다:

	#!/usr/bin/env ruby

	refname = ARGV[0]
	oldrev  = ARGV[1]
	newrev  = ARGV[2]
	user    = ENV['USER']

	puts "Enforcing Policies... \n(#{refname}) (#{oldrev[0,6]}) (#{newrev[0,6]})"

#### 커밋 메시지 규칙 만들기 ####

커밋 메시지 규칙부터 해보자. 일단 목표가 있어야 하니까 커밋 메시지에 "ref: 1234" 같은 스트링이 포함돼 있어야 한다고 가정하자. 보통 커밋은 이슈 트래커에 있는 이슈와 관련돼 있으니 그 이슈가 뭔지 커밋 메시지에 적어 놓으면 좋다. Push할 때마다 커밋 메시지에 해당 스트링이 포함돼 있는지 확인한다. 만약 커밋 메시지에 해당 스트링이 없는 커밋이면 0이 아닌 값을 반환해서 Push를 거절한다.

`$newrev`, `$oldrev` 변수와 `git rev-list`라는 Plumbing 명령어를 이용해서 Push하는 커밋의 모든 SHA-1 값을 알 수 있다. 이것은 `git log`와 근본적으로 같은 명령이고 옵션을 하나도 주지 않으면 다른 정보 없이 SHA-1 값만 보여준다. 이 명령으로 Push하는 커밋을 모두 알 수 있다:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

이 SHA-1 값으로 각 커밋의 메시지도 가져온다. 커밋 메시지를 가져와서 정규표현식으로 해당 패턴이 있는지 검사한다.

커밋 메시지를 얻는 방법을 알아보자. 커밋의 raw 데이터는 `git cat-file`이라는 Plumbing 명령어로 얻을 수 있다. *9장*에서 Plumbing 명령어에 대해 자세히 다루니까 지금은 커밋 메시지 얻는 것에 집중하자:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

이 명령이 출력하는 메시지에서 커밋 메시지만 잘라내야 한다. 첫 번째 빈 줄 다음부터가 커밋 메시지니까 유닉스 명령어 `sed`로 첫 빈 줄 이후를 잘라낸다.

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

이제 커밋 메시지에서 찾는 패턴과 일치하는 문자열이 있는지 검사해서 있으면 통과시키고 없으면 거절한다. 스크립트가 종료할 때 0이 아닌 값을 반환하면 Push가 거절된다. 이 일을 하는 코드는 아래와 같다:

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

이 코드를 update 스크립트에 넣으면 규칙을 어긴 커밋은 Push할 수 없다.

#### ACL로 사용자마다 다른 규칙 적용하기 ####

진행하는 프로젝트에 모듈이 여러 개 있는데, 모듈마다 속한 사용자들만 Push할 수 있게 설정해야 한다고 가정하자. 모든 권한을 다 가진 사람들도 있고 특정 디렉토리나 파일만 Push할 수 있는 사람도 있다. 이런 일을 강제하려면 먼저 서버의 Bare 저장소에 `acl`이라는 파일을 만들고 거기에 규칙을 기술한다. 그리고 update 훅에서 Push하는 파일이 무엇인지 확인하고 ACL과 비교해서 Push할 수 있는지 없는지 결정한다.

우선 ACL부터 작성한다. CVS에서 사용하는 것과 비슷한 ACL을 만든다. 규칙은 한 줄에 하나씩 기술한다. 각 줄의 첫 번째 필드는 `avail`이나 `unavail`이고 두 번째 필드는 규칙을 적용할 사용자들의 목록을 CSV(Comma-Separated Values) 형식으로 적는다. 마지막 필드엔 규칙을 적용할 경로를 적는다. 만약 마지막 필드가 비워져 있으면 모든 경로를 의미한다. 이 필드는 파이프(`|`) 문자로 구분한다.

관리자도 여러 명이고, `doc` 디렉토리에서 문서를 만드는 사람도 여러 명이다. 하지만 `lib`과 `tests` 디렉토리에 접근하는 사람은 한 명이다. 이런 상황을 ACL로 만들면 아래와 같다:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

이 ACL 정보는 스크립트에서 읽어 사용한다. 설명을 쉽게 하고자 여기서는 `avail`만 처리한다. 다음 메소드는 Associative Array를 반환하는데, 키는 사용자이름이고 값은 사용자가 Push할 수 있는 경로의 목록이다:

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

이 함수가 ACL 파일을 처리하고 나서 반환하는 결과는 아래와 같다:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

바로 사용할 수 있는 권한 정보를 만들었다. 이제 Push하는 파일을 그 사용자가 Push할 수 있는지 없는지 알아내야 한다.

`git log` 명령에 `--name-only` 옵션을 주면 해당 커밋에서 수정된 파일이 뭔지 알려준다. `git log` 명령은 *2장*에서 다루었다:

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

`get_acl_access_data` 메소드를 호출해서 ACL 정보를 구하고, 각 커밋에 들어 있는 파일 목록도 얻은 다음에, 사용자가 모든 커밋을 Push할 수 있는지 판단한다:

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

어렵지 않다. 먼저 `git rev-list` 명령으로 서버에 Push하려는 커밋이 무엇인지 알아낸다. 그리고 각 커밋에서 수정한 파일이 어떤 것들이 있는지 찾고, 해당 사용자가 모든 파일에 대한 권한이 있는지 확인한다. Rubyism 철학에 따르면 `path.index(access_path) == 0`이란 표현은 불명확하다. 이 표현은 해당 파일의 경로가 `access_path`로 시작할 때 참이라는 뜻이다. 그러니까 `access_path`가 단순히 허용된 파일 하나를 의미하는 것이 아니라 `access_path`로 시작하는 모든 파일을 의미한다.

이제 사용자는 메시지 규칙을 어겼거나 권한이 없는 파일이 포함된 커밋은 어떤 것도 Push하지 못한다.

#### Fast-Forward Push만 허용하기 ####

이제 Fast-forward Push가 아니면 거절되게 해보자. `receive.denyDeletes`와 `receive.denyNonFastForwards` 설정으로 간단하게 거절할 수 있다. 하지만, 그 이전 버전에는 꼭 훅으로 구현해야 했다. 게다가 특정 사용자만 제한하거나 허용하려면 훅으로 구현해야 한다.

기존에 있던 커밋이 Push하는 브랜치에 없으면 Fast-forward Push가 아니라고 판단한다. 커밋 하나라도 없으면 거절하고 모두 있으면 Fast-forward Push이므로 그대로 둔다:

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

이 정책을 다 구현해서 update 스크립트에 넣고 `chmod u+x .git/hooks/update` 명령으로 실행 권한을 준다. 그리고 나서 `-f` 옵션을 주고 강제로 Push하면 아래와 같이 실패한다:

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

정책과 관련해 하나씩 살펴보자. 먼저 훅이 실행될 때마다 다음 메시지가 출력된다.

	Enforcing Policies...
	(refs/heads/master) (fb8c72) (c56860)

이것은 update 스크립트 맨 윗부분에서 표준출력(STDOUT)에 출력한 내용이다. 스크립트에서 표준출력으로 출력하면 클라이언트로 전송된다. 이점을 꼭 기억하자.

그리고 아래의 에러 메시지를 보자:

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

첫 번째 줄은 스크립트에서 직접 출력한 것이고 나머지 두 줄은 Git이 출력해 주는 것이다. 이 메시지는 update 스크립트에서 0이 아닌 값을 반환해서 Push할 수 없다는 메시지다. 그리고 마지막 메시지를 보자:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

이 메시지는 훅에서 거절된 것이라고 말해주는 것이고 브랜치가 거부될 때마다 하나씩 출력된다.

게다가 Push하는 커밋에 커밋 메시지 규칙을 지키지 않은 것이 하나라도 있으면 아래와 같은 에러 메시지를 보여준다:

	[POLICY] Your message is not formatted correctly

그리고 누군가 권한이 없는 파일을 수정해서 Push해도 에러 메시지를 출력한다. 예를 들어 문서 담당자가 `lib` 디렉토리에 있는 파일을 수정해서 커밋하면 아래와 같은 메시지가 출력된다:

	[POLICY] You do not have access to push to lib/test.rb

이제 서버 훅은 다 만들었다. 앞으로는 update 스크립트가 항상 실행될 것이기 때문에 저장소를 되돌릴 수 없고, 커밋 메시지도 규칙대로 작성해야 하고, 권한이 있는 파일만 Push할 수 있다.

### 클라이언트 훅 ###

서버 훅의 단점은 Push할 때까지 Push할 수 있는지 없는지 알 수 없다는데 있다. 기껏 공들여 정성껏 구현했는데 막상 Push할 수 없으면 곤혹스럽다. 히스토리를 제대로 고치는 일은 정신건강에 매우 해롭다.

이 문제는 클라이언트 훅으로 해결한다. 클라이언트 훅으로 서버가 거부할지 말지 검사한다. 사람들은 커밋하기 전에, 그러니까 시간이 지나 고치기 어려워지기 전에 문제를 해결할 수 있다. Clone할 때 이 훅은 전송되지 않기 때문에 다른 방법으로 동료에게 배포해야 한다. 그 훅을 가져다 `.git/hooks` 디렉토리에 복사하고 실행할 수 있게 만든다. 이 훅 파일을 프로젝트에 넣어서 배포해도 되고 Git 훅 프로젝트를 만들어서 배포해도 된다. 하지만, 자동으로 설치하는 방법은 없다.

커밋 메시지부터 검사해보자. 이 훅이 있으면 커밋 메시지가 구리다고 서버가 뒤늦게 거절하지 않는다. 이것은 `commit-msg` 훅으로 구현한다. 이 훅은 커밋 메시지가 저장된 파일을 첫 번째 아규먼트로 입력받는다. 그 파일을 읽어 패턴을 검사한다. 필요한 패턴이 없으면 커밋을 중단시킨다:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

이 스크립트를 `.git/hooks/commit-msg`라는 파일로 만들고 실행권한을 준다. 커밋이 메시지 규칙을 어기면 아래와 같은 메시지를 보여 준다:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

커밋하지 못했다. 하지만, 커밋 메지시를 바르게 작성하면 커밋할 수 있다:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

그리고 아예 권한이 없는 파일을 수정 못하게 할 때는 `pre-commit` 훅을 이용한다. 사전에 `.git` 디렉토리 안에 ACL 파일을 가져다 놓고 아래와 같이 작성한다:

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

내용은 서버 훅과 똑같지만 두 가지가 다르다. 첫째, 클라이언트 훅은 Git 디렉토리가 아니라 워킹 디렉토리에서 실행하기 때문에 ACL 파일 위치가 다르다. 그래서 ACL 파일 경로를 수정해야 한다:

	access = get_acl_access_data('acl')

이 부분을 아래와 같이 바꾼다:

	access = get_acl_access_data('.git/acl')

두 번째 차이점은 파일 목록을 얻는 방법이다. 서버 훅에서는 커밋에 있는 파일을 모두 찾았지만 여기서는 아직 커밋하지도 않았다. 그래서 Staging Area의 파일 목록을 이용한다:

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

이 부분을 아래와 같이 바꾼다:

	files_modified = `git diff-index --cached --name-only HEAD`

이 두 가지 점만 다르고 나머지는 똑같다. 보통은 리모트 저장소의 계정과 로컬의 계정도 같다. 다른 계정을 사용하려면 `$user` 환경변수에 누군지 알려야 한다.

Fast-forward Push인지 확인하는 일이 남았다. 보통은 Fast-forward가 아닌 Push는 좀 드물다. Fast-forward가 아닌 Push를 하려면 Rebase로 이미 Push한 커밋을 바꿔 버렸거나 전혀 다른 로컬 브랜치를 Push하는 경우다.

어쨌든 이 서버는 Fast-forward Push만 허용하기 때문에 이미 Push한 커밋을 수정했다면 그건 아마 실수로 그랬을 것이다. 이 실수를 막는 훅을 살펴보자.

아래는 이미 Push한 커밋을 Rebase하지 못하게 하는 pre-rebase 스크립트다. 이 스크립트는 먼저 Rebase할 커밋 목록을 구하고 커밋이 리모트 레퍼런스/브랜치에 들어 있는지 확인한다. 커밋이 한 개라도 리모트 레퍼런스/브랜치에 들어 있으면 Rebase할 수 없다:

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

이 스크립트는 *6장* '리비전 조회하기' 절에서 설명하지 않은 표현을 사용했다. 아래의 표현은 이미 Push한 커밋 목록을 얻어오는 부분이다:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

`SHA^@`은 해당 커밋의 모든 부모를 가리킨다. 그러니까 이 명령은 지금 Push하려는 커밋에서 리모트 저장소의 커밋에 도달할 수 있는지 확인하는 명령이다. 즉, Fast-forward인지 확인하는 것이다.

이 방법은 매우 느리고 보통은 필요 없다. 어차피 Fast-forward가 아닌 Push은 `-f` 옵션을 주어야 Push할 수 있다. 문제가 될만한 Rebase를 방지할 수 있다는 것을 보여주려고 이 예제를 설명했다.

## 요약 ##

Git을 프로젝트에 맞추는 방법을 배웠다. 주요한 서버/클라이언트 설정 방법, 파일 단위로 설정하는 Git Attributes, 이벤트 훅, 정책을 강제하는 방법을 배웠다. 이제 필요한 Workflow를 만들고 Git을 거기에 맞게 설정할 수 있을 것이다.
