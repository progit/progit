# Git 도구 #

지금까지 일상적으로 자주 사용하는 명령어들과 몇 가지 Workflow를 배웠다. 파일을 추적하고 커밋하는 등의 기본적인 명령어뿐만 아니라 Staging Area가 왜 좋은지도 배웠고 가볍게 토픽 브랜치를 만들고 Merge하는 방법도 다뤘다. 이제는 소스코드 관리를 Git 저장소로 충분히 해낼 수 있을 것이다.

이 장에서는 일상적으로 사용하지는 않지만 위급한 상황에서 반드시 필요한 Git 도구를 살펴본다.

## 리비전 조회하기 ##

리비전 하나를 조회할 수도 있고 범위를 주고 여러 개를 조회할 수도 있다. 잘 쓰진 않지만 알아두는게 좋다.

### 리비전 하나 가리키기 ###

사람은 커밋을 나타내는 SHA-1 해시 값을 쉽게 기억할 수 없다. 이 절에서는 커밋을 표현하는 방법을 몇 가지 설명한다. 좀 더 사람이 기억하기 쉬운 방법들이다.

### 짧은 SHA-1 ###

해시 값의 앞 몇 글자만으로도 어떤 커밋인지 충분히 식별할 수 있다. 중복되지 않으면 해시 값의 앞 4자만 사용해도 된다. 유일하기만 하면 짧은 SHA-1 값이라도 괜찮다.

먼저 `git log` 명령으로 어떤 커밋이 있는지 조회한다:

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

`git show` 명령으로 `1c002dd....`로 시작하는 커밋을 조회한다면 아래와 같이 조회 할 수 있다. 다음 명령어는 모두 같다(단 짧은 해시 값이 다른 커밋과 중복되지 않다고 가정):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

`git log` 명령어에 `--abbrev-commit` 옵션을 추가하면 짧은 해시 값을 보여준다. 기본으로 7자를 보여주고 해시 값이 중복되면 더 긴 해시 값을 보여준다:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

보통은 8자에서 10자 내외로도 충분하다. 이 정도로도 중복되지 않는다. 대규모 프로젝트인 리눅스 커널도 커밋을 가리키는데 해시 값 40자 중에서 12자만 사용한다.

### SHA-1 해시 값에 대한 단상  ###

Git을 쓰는 사람 중에서 가능성이 낮긴 하지만 언젠가 SHA-1 값이 중복될까 봐 걱정하는 사람도 있다. 정말 그렇게 되면 어떤 일이 벌어질까?

이미 있는 SHA-1 값을 Git 데이터베이스에 커밋하면 새로운 개체라고 해도 이미 커밋한 것으로 간주된다. 그래서 해당 SHA-1 값의 커밋을 Checkout하면 항상 처음에 저장한 커밋만 Checkout된다.

그러나 해시 값이 중복되는 일은 일어나기 어렵다. SHA-1 값의 크기는 20 바이트(160비트)이다. 해시 값이 중복될 확률이 50%가 되는 데 필요한 개체의 수는 `2^80`이다. 이 수는 1.2 자('자'는 '경'의 '억'배 - `10^24`)이다(충돌 확률을 구하는 공식은 `p=(n(n-1)/2) * (1/2^160)`이다). 즉, 지구에 존재하는 모래알의 수에 1200을 곱한 수와 맞먹는다.

아직도 SHA-1 해시 값이 중복될까 봐 걱정하는 사람들을 위해 좀 더 덧붙이겠다. 지구에서 약 6.5억 명의 인구가 개발하고 각자 매초 리눅스 커널 히스토리 전체와(100만 개) 맞먹는 개체를 쏟아 내고 바로 Push한다고 가정하자. 이런 상황에서 해시 값의 충돌 날 확률이 50%가 되기까지는 5년이 걸린다. 그냥 어느 날 동료가 전부 한순간에 늑대에게 물려 죽을 확률이 훨씬 더 높다.

### 브랜치로 가리키기 ###

브랜치를 사용하는 것이 커밋을 나타내는 가장 쉬운 방법이다. 커밋 개체나 SHA-1 값이 필요한 곳이면 브랜치 이름을 사용할 수 있다. 만약 `topic1` 브랜치의 최근 커밋을 보고 싶으면 아래와 같이 실행한다. `topic1` 브랜치가 `ca82a6d`를 가리키고 있기 때문에 두 명령의 결과는 같다:

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

브랜치가 가리키는 개체의 SHA-1 값에 대한 궁금증은 `rev-parse`이라는 Plumbing 도구가 해결해 준다. *9장*에서 이 도구에 대해 좀 더 자세히 설명한다. 기본적으로 `rev-parse`은 저수준 명령어이기 때문에 평소에는 전혀 필요하지 않지만 그래도 한번 사용해보고 어떤 결과가 나오는지 알아 두자:

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### RefLog로 가리키기 ###

Git은 자동으로 브랜치와 HEAD가 지난 몇 달 동안에 가리켰었던 커밋을 모두 기록하는데 이 로그를 Reflog라고 부른다.

`git reflog`를 실행하면 Reflog를 볼 수 있다:

	$ git reflog
	734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd HEAD@{2}: commit: added some blame and merge stuff
	1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
	95df984 HEAD@{4}: commit: # This is a combination of two commits.
	1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD

Git은 브랜치가 가리키는 것이 변경될 때마다 그 정보를 임시 영역에 저장한다. 그래서 예전에 뭘 가리켰었는지 확인할 수 있다. `@{n}` 규칙을 사용하면 아래와 같이 HEAD가 5번 전에 가리켰던 것을 알 수 있다:

	$ git show HEAD@{5}

순서뿐 아니라 시간도 가능하다. 어제 날짜의 `master` 브랜치를 보고 싶으면 아래와 같이 한다:

	$ git show master@{yesterday}

이 명령은 어제 master 브랜치가 가리키고 있던 것이 무엇인지 보여준다. Reflog에 남아있는 것만 조회할 수 있기 때문에 너무 오래된 커밋은 조회할 수 없다.

`git log -g` 명령을 사용하면 `git reflog` 결과를 `git log` 명령과 같은 형태로 볼 수 있다:

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

reflog의 일은 모두 로컬의 일이기 때문에 내 reflog가 동료의 저장소에는 있을 수 없다. 이제 막 Clone한 저장소에도 아무것도 한게 없어서 reflog가 하나도 없다. `git show HEAD@{2.months.ago}` 같은 명령은 적어도 두 달 전에 Clone한 저장소에서나 사용할 수 있다. 그러니까 이 명령을 5분 전에 Clone한 저장소에 사용하면 아무것도 나오지 않는다.

### 계통 관계로 가리키기 ###

계통 관계로도 커밋을 표현할 수 있다. 이름 끝에 `^`를 붙이면 Git은 해당 커밋의 부모를 찾는다. 프로젝트 히스토리가 아래와 같을 때:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

`HEAD^`는 바로 "HEAD의 부모"를 의미하므로 바로 이전 커밋을 보여준다:

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

`^` 뒤에 숫자도 사용할 수 있다. 예를 들어 `d921970^2`는 "d921970의 두 번째 부모"를 의미하기에 두 번째 부모가 있는 Merge 커밋에만 사용할 수 있다. 첫 번째 부모는 Merge할 때 Checkout했던 브랜치를 말하고 두 번째 부모는 Merge한 대상 브랜치를 의미한다.

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

계통을 표현하는 방법으로 `~`라는 것도 있다. `HEAD~`와 `HEAD^`는 똑같이 첫 번째 부모를 가리킨다. 하지만 그 뒤에 숫자를 사용하면 달라진다. `HEAD~2`는 명령을 실행할 시점의 "첫 번째 부모의 첫 번째 부모", 즉 "조부모"를 가리킨다. 위의 예제에서 `HEAD~3`은 아래와 같다:

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

이 것은 `HEAD^^^`와 같은 표현이다. 다시 말해서 첫 번째 부모의 첫 번째 부모의 첫 번째 부모를 말한다:

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

이 두 표현을 같이 사용할 수도 있다. 위의 예제에서 `HEAD~3^2`를 사용하면 증조부모의 Merge 커밋의 두 번째 부모를 조회한다.

### 범위로 커밋 가리키기 ###

커밋을 하나씩 조회할 수도 있지만, 범위를 주고 여러 커밋을 한꺼번에 조회할 수도 있다. 범위을 주고 조회하면 브랜치를 관리할 때 유용하다. 브랜치가 상당히 많고 "왜 아직도 주 브랜치에 Merge가 안된 브랜치들은 무엇에 대한 브랜치일까?"라는 의문이 들면 범위를 주고 어떤 브랜치인지 쉽게 알아볼 수 있다.

#### Double Dot ####

범위를 표현하는 문법으로 Double Dot(..)을 많이 쓴다. Double Dot은 한쪽에는 있고 다른 쪽에는 없는 커밋이 무엇인지 Git에게 물어보는 것이다. 예들 들어 그림 6-1과 같은 커밋 히스토리가 있다고 가정하자.

Insert 18333fig0601.png
그림 6-1. 범위를 설명하는 데 사용할 예제

experiment 브랜치의 커밋들 중에서 아직 master 브랜치에 Merge하지 않은 것만 보고 싶으면 `master..experiment`라고 사용한다. 이 표현은 "master에는 없지만, experiment에는 있는 커밋"을 의미한다. 여기에서는 설명을 쉽게 하고자 실제 조회 결과가 아니라 그림 6-1의 문자를 사용한다:

	$ git log master..experiment
	D
	C

반대로 `experiment`에는 없고 `master`에만 있는 커밋이 궁금하면 브랜치 순서를 거꾸로 사용한다. `experiment..master`는 `experiment`에는 없고 `master`에만 있는 것을 알려준다:

	$ git log experiment..master
	F
	E

`experiment` 브랜치를 Merge하기 전에 무엇이 변경됐는지 궁금하다. 그리고 리모트 저장소에 Push할 때에도 마찬가지로 차이가 궁금하다. 이렇게 궁금한 상황에서 굉장히 유용하다:

	$ git log origin/master..HEAD

이 명령은 `origin` 저장소의 `master` 브랜치에는 없고 현재 Checkout중인 브랜치에만 있는 커밋을 보여준다. Checkout한 브랜치가 `origin/master`라면 `git log origin/master..HEAD`가 보여주는 커밋이 Push하면 서버에 전송될 커밋이다. 그리고 한쪽의 레퍼런스를 생략하면 Git은 HEAD라고 가정한다. `git log origin/master..`는 `git log origin/master..HEAD`와 같다.

#### 세 개 이상의 레퍼런스 ####

Double Dot은 간단하고 유용하다. 하지만, 두 개 이상의 브랜치에는 사용할 수 없다. 그러니까 현재 작업 중인 브랜치에는 있지만 다른 여러 브랜치에는 없는 커밋이 보고 싶으면 `..`으로는 확인할 수 없다. `^`과 `--not` 옵션 뒤에 브랜치 이름을 넣으면 그 브랜치에 없는 커밋을 찾아준다. 다음 명령어는 모두 같은 명령이다:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Double Dot으로는 세 개 이상의 레퍼런스에 사용할 수 없지만 이 옵션은 가능하다. 예를 들어 `refA`나 `refB`에는 있지만 `refC`에는 없는 커밋을 보려면 다음 중 하나를 사용한다:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

이 조건을 잘 응용하면 작업 중인 브랜치와 다른 브랜치를 매우 상세하게 비교할 수 있다.

#### Triple Dot ####

Triple Dot은 양쪽에 있는 두 레퍼런스 사이에서 공통으로 가지는 것을 제외하고 서로 다른 커밋만 보여준다. 그림 6-1의 커밋 히스토리를 다시 보자. 만약 `master`와 `experiment`의 공통부분은 빼고 다른 커밋만 보고 싶으면 아래와 같이 하면 된다:

	$ git log master...experiment
	F
	E
	D
	C

우리가 아는 `log` 명령의 결과를 최근 날짜순으로 보여준다. 이 예제에서는 커밋을 네 개 보여준다.

그리고 `log` 명령에 `--left-right` 옵션을 추가하면 각 커밋이 어느 브랜치에 속하는지도 보여주기 때문에 좀 더 이해하기 쉽다:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

위와 같은 명령들을 사용하면 원하는 커밋을 좀 더 꼼꼼하게 살펴볼 수 있다.

## 대화형 명령어 ##

Git은 대화형 명령어도 제공해서 좀 더 쉽게 사용할 수 있다. 여기서 소개하는 몇 가지 대화형 명령어를 이용하면 바로 전문가처럼 능숙하게 커밋할 수 있다. 대화형으로 커밋할 파일을 고를 수도 있고 수정된 파일의 일부분만 커밋할 수도 있다. 수정한 파일이 매우 많고 통째로 커밋하지 않고 이슈 별로 나눠서 커밋할 때 유용하다. 이슈 별로 나눠서 커밋하면 동료가 쉽게 검토할 수 있다. `git add` 명령에 `-i`나 `--interactive` 옵션을 주고 실행하면 Git은 아래와 같은 대화형 모드로 들어간다:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now>

이 명령어는 Staging Area의 현재 상태가 어떻고 할 수 있는 일이 무엇인지 보여준다. 기본적으로 `git status` 명령이 보여주는 것과 같지만 좀 더 간결하고 정돈돼 있다. 왼쪽에는 Staged 상태인 파일들을 보여주고 오른쪽에는 Unstaged인 파일들을 보여준다.

그리고 마지막 `Commands` 부분에서는 할 수 일이 무엇인지 보여준다. 파일을 Stage하고 Unstage하는 것, Untracked 상태의 파일을 추가하는 것, Stage한 파일을 diff해보는 것을 할 수 있다. 게다가 수정한 파일의 일부분만 Staging Area에 추가할 수도 있다.

### Staging Area에 파일 추가하고 추가 취소하기 ###

`What now>` 프롬프트에서 `2`나 `u`를(update) 입력하면 Staging Area에 추가할 수 있는 파일을 전부 보여준다:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

TODO와 index.html 파일을 Stage하려면 아래와 같이 입력한다:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

`*` 표시가 붙은 파일은 stage하도록 선택한 것이다. 선택하고 `Update>>` 프롬프트에 아무것도 입력하지 않고 엔터를 치면 Git은 선택한 파일을 Staging Area로 추가한다:

	Update>>
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

이제 TODO와 index.html 파일은 Stage했고 simplegit.rb 파일만 아직 Unstaged 상태로 남아 있다. 이제 TODO 파일을 다시 Unstage하고 싶으면 `3`이나 `r`을(Revert) 입력한다:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

다시 Status를 선택하면 TODO 파일이 Unstaged 상태인 것을 알 수 있다:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Staged 파일의 변경내용을 보려면 `6`이나 `d`를(diff) 입력한다. 그러면 먼저 Staged 상태인 파일을 보여준다. 그리고 그중에서 파일 하나를 선택한다. 그 결과는 명령 줄에서 `git diff --cached`라고 실행한 결과와 같다:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

대화형 모드를 사용하면 Staging Area에 파일을 좀 더 쉽게 추가할 수 있다.

### 파일의 일부분만 Staging Area에 추가하기 ###

파일의 일부분만 Staging Area에 추가하는 것도 가능하다. 예를 들어 simplegit.rb 파일은 고친 부분이 두 군데이다. 그 중 하나를 추가하고 나머지는 그대로 두고 싶다. Git에서는 이런 작업도 매우 쉽게 할 수 있다. 대화형 프롬프트에서 `5`, `p`를(patch) 입력한다. 그러면 Git은 부분적으로 Staging Area에 추가할 파일이 있는지 묻는다. 파일을 선택하면 파일의 특정 부분을 Staging Area에 추가할 것인지 부분별로 구분하여 묻는다:

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]?

여기에서 `?`를 입력하면 선택 가능한 명령어를 설명해준다:

	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? ?
	y - stage this hunk
	n - do not stage this hunk
	a - stage this and all the remaining hunks in the file
	d - do not stage this hunk nor any of the remaining hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

`y`나 `n`을 입력하면 각 부분을 Stage할지 말지 결정할 수 있다. 하지만, 파일을 통째로 stage하거나 필요할 때까지 아예 그대로 남겨 두는 것이 다음에 더 유용할지도 모른다. 어쨌든 파일의 한 부분은 Stage하고 다른 부분은 unstaged 상태로 남겨놓고 status 명령으로 확인해보면 결과는 아래와 같다:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

simplegit.rb 파일의 상태를 보자. 어떤 줄은 Staged 상태이고 어떤 줄은 Unstaged라고 알려줄 것이다. 이 파일은 부분적으로 Stage하였다. 이제 대화형 모드를 종료하고 일부분만 Stage한 파일을 커밋할 수 있다.

끝으로 대화형 스크립트로만 파일 일부분을 Stage할 수 있는 것은 아니다. `git add -p`나 `git add --patch`로도 같은 일을 할 수 있다.

## Stashing ##

당신이 어떤 프로젝트에서 한 부분을 담당하고 있다고 하자. 그리고 여기에서 뭔가 작업하던 일이 있고 다른 요청이 들어와서 잠시 브랜치를 변경해야 할 일이 생겼다고 치자. 아직 완료하지 않은 일을 커밋하는 것은 좀 껄끄럽다. 이런 상황에서는 커밋하지 않고 나중에 다시 돌아와서 작업을 다시 하고 싶을 것이다. 이 문제는 `git stash`라는 명령으로 해결할 수 있다.

Stash 명령을 사용하면 워킹 디렉토리에서 수정한 파일만 저장한다. Stash는 Modified이면서 Tracked 상태인 파일과 Staging Area에 있는 파일들을 보관해두는 장소다. 아직 끝나지 않은 수정사항을 스택에 잠시 저장했다가 나중에 다시 적용할 수 있다.

### 하던 일을 Stash하기 ###

예제 프로젝트를 하나 살펴보자. 파일을 두 개 수정하고 그 중 하나는 Staging Area에 추가한다. 그리고 `git status` 명령을 실행하면 아래와 같은 결과를 볼 수 있다:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

이제 브랜치를 변경한다. 아직 작업 중인 파일은 커밋할 게 아니라서 모두 Stash한다. `git stash`를 실행하면 스택에 새로운 Stash가 만들어진다:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

대신 워킹 디렉토리는 깨끗해졌다:

	$ git status
	# On branch master
	nothing to commit, working directory clean

이제 아무 브랜치나 골라서 바꿀 수 있다. 수정하던 것은 스택에 저장했다. 아래와 같이 `git stash list`를 사용하여 저장한 Stash를 확인한다:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log

Stash 두 개는 원래 있었던 것이다. 그래서 현재 총 세 개의 Stash를 사용할 수 있다. 이제 `git stash apply`를 사용하여 Stash를 적용할 수 있다. `git stash` 명령을 실행하면 이 명령에 대한 도움말을 보여주기 때문에 편리하다. 다른 Stash를 고르고 싶으면 Stash 이름을 입력해야 한다. 이름이 없으면 Git은 가장 최근의 Stash를 적용한다:

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Git은 Stash에 저장할 때 수정하던 파일을 복원해준다. 복원할 때의 워킹 디렉토리는 Stash할 때의 그 브랜치이고 워킹 디렉토리도 깨끗한 상태였다. 하지만, 꼭 깨끗한 워킹 디렉토리나 Stash할 때와 같은 브랜치에 적용해야 하는 것은 아니다. 어떤 브랜치에서 Stash하고 다른 브랜치로 옮기고서 거기에 Stash를 복원할 수 있다. 그리고 꼭 워킹 디렉토리가 깨끗한 상태일 필요도 없다. 워킹 디렉토리에 수정하고 커밋하지 않은 파일들이 있을 때에도 Stash를 적용할 수 있다. 만약 충돌이 나면 알려준다.

Git은 Stash를 적용할 때 Staged 상태였던 파일을 자동으로 다시 Staged 상태로 만들어 주지 않는다. 그래서 `git stash apply` 명령을 실행할 때 `--index` 옵션을 주어야 Staged 상태까지 복원한다. 그럼 원래 작업하던 상태로 돌아올 수 있다:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

`apply` 옵션은 단순히 Stash를 적용하는 것뿐이다. Stash는 여전히 스택에 남아 있다. `git stash drop` 명령을 사용하여 해당 Stash를 제거한다:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051 Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5 added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

그리고 `git stash pop`이라는 명령도 있는데 이 명령은 Stash를 적용하고 나서 바로 스택에서 제거해준다.

### Stash 되돌리기 ###

Stash를 적용하고 나서 아차 싶을 때에는 다시 되돌려 놓아야 한다. Git은 `stash unapply` 같은 명령을 제공하지는 않는다. 하지만, Stash를 이용해서 패치를 만들고 그것을 거꾸로 적용할 수 있다:

	$ git stash show -p stash@{0} | git apply -R

Stash를 명시하지 않으면 Git은 가장 최근의 Stash를 사용한다:

	$ git stash show -p | git apply -R

`stash-unapply`라는 alias를 만들고 편리하게 할 수도 있다:

	$ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
	$ git stash apply
	$ #... work work work
	$ git stash-unapply

### Stash를 적용한 브랜치 만들기 ###

보통 Stash에 저장하면 한동안 그대로 유지하고 그 브랜치에서는 계속 새로운 일을 한다. 그러면 저장한 Stash를 적용하는 것이 문제가 될 수 있다. 수정한 파일에 Stash를 적용하면 충돌이 날 수 있다. 충돌이 나면 충돌을 해결해야 한다. 그리고 Stash한 것은 다시 테스트해야 한다. `git stash branch` 명령을 실행하면 Stash할 당시의 커밋을 Checkout한 후 새로운 브랜치를 만들고 여기에 적용한다. 이 모든 것이 성공하면 Stash를 삭제한다:

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

이 명령은 브랜치를 새로 만들고 Stash를 복원해주는 매우 편리한 도구다.

## 히스토리 단장하기 ##

Git으로 일하다 보면 어떤 이유로든 커밋 히스토리를 수정해야 할 때가 있다. 결정을 나중으로 미룰 수 있던 것은 Git의 장점이다. Staging Area가 있어서 커밋할 파일을 고르는 일을 커밋하는 순간으로 미룰 수 있고 Stash 명령으로 하던 일을 미룰 수 있다. 게다가 이미 커밋한 내용을 수정할 수 있다. 거의 모든 것을 수정할 수 있다. 커밋 순서도 변경할 수 있고 커밋 메시지와 커밋한 파일도 변경할 수 있다. 여러 개의 커밋을 하나로 합치거나 반대로 하나의 커밋을 여러 개로 분리할 수도 있다. 아니면 커밋 전체를 삭제할 수도 있다. 하지만, 이 모든 것은 다른 사람과 코드를 공유하기 전에 해야 한다.

이 절에서는 사람들과 코드를 공유하기 전에 커밋 히스토리를 예쁘게 단장하는 방법에 대해서 설명한다.

### 마지막 커밋을 수정하기 ###

히스토리를 단장하는 일 중에서는 마지막 커밋을 수정하는 것이 가장 자주 하는 일이다. 기본적으로 두 가지로 나눌 수 있는데 하나는 커밋 메시지를 수정하는 것이고 다른 하나는 파일 목록을 수정하는 것이다.

커밋 메시지를 수정하는 방법은 매우 간단하다:

	$ git commit --amend

이 명령은 자동으로 텍스트 편집기를 실행시켜서 마지막 커밋 메시지를 열어준다. 여기에 메시지를 수정하고 편집기를 닫으면 편집기는 수정한 메시지로 마지막 커밋을 수정한다.

커밋하고 나서 새로 만들었거나 다시 수정한 파일을 마지막 커밋에 포함할 수 있다. 기본적으로 방법은 같다. 파일을 수정하고 `git add` 명령으로 Staging Area에 넣거나 `git rm` 명령으로 파일 삭제한다. 그리고 `git commit --amend` 명령으로 커밋하면 된다. 이 명령은 현 Staging Area의 내용을 이용해서 수정한다.

이때 SHA-1 값이 바뀌기 때문에 과거의 커밋을 변경할 때 주의해야 한다. rebase처럼 이미 Push한 커밋은 수정하면 안 된다.

### 커밋 메시지를 여러 개 수정하기 ###

최근 커밋이 아니라 예전 커밋을 수정하려면 다른 도구가 필요하다. 히스토리 수정용 도구는 없지만 `rebase` 명령을 이용하여 수정할 수 있다. 현재 작업하는 브랜치에서 각 커밋을 하나하나 수정하는 것이 아니라 어느 시점부터 HEAD까지의 커밋을 한 번에 Rebase한다. 대화형 Rebase 도구를 사용하면 커밋을 처리할 때마다 멈춘다. 그러면 각 커밋의 메시지를 수정하거나 파일을 추가하고 변경하는 등의 일을 진행할 수 있다. `git rebase` 명령에 `-i` 옵션을 추가하면 대화형 모드로 Rebase할 수 있다. 어떤 시점부터 HEAD까지 Rebase할 것인지 아규먼트로 넘기면 된다.

마지막 커밋 메시지 세 개를 모두 수정하거나 그 중 몇 개를 수정하는 시나리오를 살펴보자. `git rebase -i`의 아규먼트로 편집하려는 마지막 커밋의 부모를 `HEAD~2^`나 `HEAD~3`로 해서 넘긴다. 마지막 세 개의 커밋을 수정하는 것이기 때문에 `~3`이 좀 더 기억하기 쉽다. 그렇지만, 실질적으로 가리키게 되는 것은 수정하려는 커밋의 부모인 네 번째 이전 커밋이다.

	$ git rebase -i HEAD~3

이 명령은 rebase하는 것이기 때문에 메시지의 수정 여부에 관계없이 `HEAD~3..HEAD` 범위에 있는 모든 커밋을 수정한다. 다시 강조하지만 이미 중앙서버에 Push한 커밋은 절대 고치지 말아야 한다. Push한 커밋을 Rebase하면 결국 같은 내용을 두 번 Push하는 것이기 때문에 다른 개발자들이 혼란스러워 한다.

실행하면 텍스트 편집기가 열리고 그 안에는 수정하려는 커밋 목록이 첨부된다:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

이 커밋은 모두 `log` 명령과는 정반대의 순서로 나열된다. `log` 명령을 실행하면 아래와 같은 결과를 볼 수 있다:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

위 결과의 역순임을 기억하자. 대화형 rebase는 스크립트에 적혀 있는 순서대로 `HEAD~3`부터 적용하기 시작하고 위에서 아래로 각각의 커밋을 순서대로 수정한다. 순서대로 적용하는 것이기 때문에 제일 위에 있는 것이 최신이 아니라 가장 오래된 것이다.

특정 커밋에서 실행을 멈추게 하려면 스크립트를 수정해야 한다. `pick`이라는 단어를 `edit`로 수정하면 그 커밋에서 멈춘다. 가장 오래된 커밋 메시지를 수정하려면 아래와 같이 편집한다:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

저장하고 편집기를 종료하면 Git은 목록에 있는 커밋 중에서 가장 오래된 커밋으로 이동하고, 아래와 같은 메시지를 보여주고, 명령 프롬프트를 보여준다:

<!-- This is actually weird, as the SHA-1 of 7482e0d is not present in the list, 
nor is the commit message. Please review 
-->

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

정확히 뭘 해야 하는지 알려준다. 아래와 같은 명령을 실행하고:

	$ git commit --amend

커밋 메시지를 수정하고 텍스트 편집기를 종료한다. 그리고 아래 명령어를 실행한다:

	$ git rebase --continue

이렇게 나머지 두 개의 커밋에 적용하면 끝이다. 다른 것도 `pick`을 `edit`로 수정해서 이 작업을 몇 번이든 반복할 수 있다. Git이 멈출 때마다 커밋을 수정할 수 있고 완료할 때까지 계속 할 수 있다.

### 커밋 순서 바꾸기 ###

대화형 Rebase 도구로 커밋 전체를 삭제하고 순서도 바꿀 수 있다. "added cat-file" 커밋을 삭제하고 다른 두 커밋의 순서를 변경하려면 이 rebase 스크립트를:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

아래와 같이 수정한다:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

수정한 내용을 저장하고 편집기를 종료하면 Git은 브랜치를 이 커밋들의 부모로 이동시키고서 `310154e`와 `f7f3f6d`를 순서대로 적용한다. 그러면 커밋 순서가 변경됐고 "added cat-file" 커밋이 제거된 것을 확인할 수 있다.

### 커밋 합치기 ###

대화형 Rebase 명령을 이용하여 여러 개의 커밋을 꾹꾹 눌러서 하나의 커밋으로 만들어 버릴 수 있다. Rebase 스크립트에 자동으로 포함된 도움말에 설명돼 있다:

	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	#
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

"pick"이나 "edit"말고 "squash"를 입력하면 Git은 해당 커밋과 바로 이전 커밋을 합칠 것이고 커밋 메시지도 Merge한다. 그래서 3개의 커밋을 모두 합치려면 스크립트를 아래와 같이 수정한다:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

저장하고 나서 편집기를 종료하면 Git은 3개의 커밋 메시지를 Merge할 수 있도록 에디터를 바로 실행해준다:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

이 메시지를 저장하면 3개의 커밋이 모두 합쳐진 하나의 커밋만 남는다.

### 커밋 분리하기 ###

커밋을 분리한다는 것은 기존 커밋을 Reset하고(혹은 되돌려 놓고) Stage를 여러 개로 분리하고 나서 그것을 원하는 횟수만큼 다시 커밋하는 것이다. 예로 들었던 커밋 세 개 중에서 가운데 것을 분리해보자. 이 커밋은 "updated README formatting and added blame"라는 커밋인데 "updated README formatting"과 "added blame"으로 분리해보자. `rebase -i` 스크립트에서 해당 커밋을 "edit"로 변경한다:

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

위와 같이 수정하고 나서 저장하고 편집기를 종료하면 Git은 제일 오래된 커밋의 부모로 이동하고서 `f7f3f6d`과 `310154e`을 처리하고 콘솔 프롬프트를 보여준다. 여기서 커밋을 해제하는 `git reset HEAD^`라는 명령으로 커밋을 해제한다. 그러면 수정했던 파일은 Unstaged 상태가 된다. 그다음에 파일들을 Stage한 후 커밋하는 일을 원하는 만큼 반복하고 나서 `git rebase --continue`라는 명령을 실행하면 남은 Rebase작업이 끝난다:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

나머지 `a5f4a0d` 커밋도 처리되면 히스토리는 아래와 같다:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

다시 강조하지만, 목록에 있는 모든 커밋의 SHA-1 값은 변경된다. 그래서 이미 서버에 Push한 커밋을 수정하면 안된다.

### filter-branch는 포크레인 ###

수정해야 하는 커밋이 너무 많아서 rebase 스크립트로 수정하기 어려울 것 같으면 다른 방법을 사용하는 것이 좋다. 모든 커밋의 이메일 주소를 변경하거나 어떤 파일을 삭제하는 경우를 살펴보자. `filter-branch`라는 명령으로 수정할 수 있는데 rebase가 삽이라면 이 명령은 포크레인이라고 할 수 있다. `filter-branch`도 역시 수정하려는 커밋이 이미 공개돼서 다른 사람과 함께 공유하는 중이라면 사용하지 말아야 한다. 하지만, 잘 쓰면 꽤 유용하다. `filter-branch`가 어떤 경우에 유용할지 예를 들어서 설명한다.

#### 모든 커밋에서 파일을 제거하기 ####

갑자기 누군가 생각 없이 `git add .` 같은 명령어를 실행해 버려서 공룡 똥 덩어리가 커밋됐거나 실수로 암호가 포함된 파일을 커밋해서 이런 파일들을 다시 삭제해야 하는 상황을 살펴보자. 이런 상황은 생각보다 자주 발생한다. `filter-branch`는 히스토리 전체에서 필요한 것만 골라내는 데 사용하는 도구다. `filter-branch`의 `--tree-filter`라는 옵션을 사용하면 히스토리에서 passwords.txt라는 파일을 아예 제거할 수 있다:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

`--tree-filter` 옵션은 프로젝트를 Checkout한 후에 각 커밋에 명시한 명령어를 실행시키고 그 결과를 다시 커밋한다. 이 예제에서는 각 스냅샷에 passwords.txt라는 파일이 있으면 그 파일을 삭제한다. 실수로 편집기의 백업파일을 커밋했으면 `git filter-branch --tree-filter "find * -type f -name '*~' -delete" HEAD`라고 실행해서 삭제할 수 있다.

이 명령은 모든 파일과 커밋을 정리하고 브랜치 포인터를 다시 복원해준다. 테스팅 브랜치에서 사용할 명령을 점검하고 나서 master 브랜치를 정리한다. 그리고 `filter-branch` 명령에 `--all` 옵션을 추가하면 모든 브랜치에 적용된다.

#### 하위 디렉토리를 루트 디렉토리로 만들기 ####

다른 VCS에서 코드를 임포트하면 그 VCS만을 위한 디렉토리가 있을 수 있다. SVN에서 코드를 임포트하면 trunk, tags, branch 디렉토리가 포함된다. 모든 커밋에 대해 `trunk` 디렉토리를 프로젝트 루트 디렉토리로 만들 때에도 `filter-branch` 명령이 유용하다:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

이제 `trunk` 디렉토리를 루트 디렉토리로 만들었다. Git은 입력한 디렉토리와 관련이 없는 커밋을 자동으로 삭제한다.

#### 모든 커밋의 이메일 주소를 수정하기 ####

프로젝트를 오픈소스로 공개할 때에도 회사 이메일 주소로 커밋된 것을 개인 이메일 주소로 변경해야 한다. 아니면 아예 `git config`로 이름과 이메일 주소를 설정하는 것을 잊었을 수도 있다. 어쨌든 `filter-branch` 명령의 `--commit-filter` 옵션을 사용하여 각 커밋에 등록된 이메일 주소를 수정할 수 있다. 이메일 주소를 변경할 때는 조심해야 한다.

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

이메일 주소를 새 주소로 변경했다. 모든 커밋은 부모의 SHA-1 값을 가지고 있기 때문에 조건에 만족하는 커밋의 SHA-1값만 바뀌는 것이 아니라 모든 커밋의 SHA-1 값이 바뀐다.

## Git으로 버그 찾기 ##

Git은 굉장히 유연해서 어떤 프로젝트에나 사용할 수 있다. 게다가 문제를 일으킨 범인이나 버그도 쉽게 찾을 수 있도록 도와준다.

### 파일 어노테이션 ###

버그를 찾을 때 먼저 그 코드가 왜, 언제 추가했는지 알고 싶을 것이다. 이때는 파일 어노테이션을 활용한다. 한줄한줄 마지막으로 커밋한 사람이 누구인지, 언제 마지막으로 커밋했는지 볼 수 있다. 어떤 메소드에 버그가 있으면 `git blame` 명령으로 그 메소드의 각 줄을 누가 언제 마지막으로 고쳤는지 찾아낼 수 있다:

	$ git blame -L 12,22 simplegit.rb
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

첫 항목은 그 줄을 마지막에 수정한 커밋의 SHA-1 값이다. 그다음 두 항목은 누가, 언제 그 줄을 커밋했는지 보여준다. 그래서 누가, 언제 커밋했는지 쉽게 찾을 수 있다. 그 뒤에 파일의 줄 번호와 내용을 보여준다. 그리고 `^4832fe2` 커밋이 궁금할 텐데 이 표시가 붙어 있으면 해당 줄이 처음 커밋한 것을 의미한다. 그러니까 해당 줄은 `4832fe2`에서 커밋된 후 변경된 적이 없다. 지금까지 커밋을 수정하는 것을 배우면서 `^`을 적어도 세 곳에서 사용한다고 배웠기 때문에 약간 헷갈릴 수 있으니 혼동하지 말자.

Git은 파일 이름을 변경한 이력을 별도로 기록해두지 않는다. 하지만, 원래 이 정보들은 각 스냅샷에 저장되고 이 정보를 이용하여 변경 이력을 만들어 낼 수 있다. 그러니까 파일에 생긴 변화는 무엇이든지 알아낼 수 있다. Git은 파일 어노테이션을 분석하여 코드들이 원래 어떤 파일에서 커밋된 것인지 찾아준다. 예를 들어보자. `GITServerHandler.m`을 여러 개의 파일로 리팩토링했는데 그 중 한 파일이 `GITPackUpload.m`이라는 파일이라고 하자. `-C` 옵션으로 `GITPackUpload.m` 파일을 추적해보면 각 코드가 원래 어떤 파일로 커밋된 것인지 알 수 있다:

	$ git blame -C -L 141,153 GITPackUpload.m
	f344f58d GITServerHandler.m (Scott 2009-01-04 141)
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

언제나 코드가 커밋될 당시의 파일이름을 알 수 있기 때문에 코드를 어떻게 리팩토링해도 추적할 수 있다. 그리고 어떤 파일에 적용해봐도 각 줄을 커밋할 당시의 파일이름을 알 수 있다. 버그를 찾을 때 정말 유용하다.

### 이진 탐색 ###

파일 어노테이션은 특정 이슈와 관련된 커밋을 찾는 데에도 좋다. 문제가 생겼을 때 의심스러운 커밋이 수십, 수백 개에 이르면 도대체 어디서부터 시작해야 할지 모를 수 있다. 이때는 `git bisect` 명령이 유용하다. `bisect` 명령은 커밋 히스토리를 이진 탐색 방법으로 좁혀 주기 때문에 이슈와 관련된 커밋을 최대한 빠르게 찾아낼 수 있도록 도와준다.

코드를 운용 환경에 배포하고 난 후에 개발할 때 발견하지 못한 버그가 있다고 보고받았다. 그런데 왜 그런 현상이 발생하는지 아직 이해하지 못하는 상황을 가정해보자. 해당 이슈를 다시 만들고 작업하기 시작했는데 뭐가 잘못됐는지 알아낼 수 없다. 이럴 때 bisect를 사용하여 코드를 뒤져 보는 게 좋다. 먼저 `git bisect start` 명령으로 이진 탐색을 시작하고 `git bisect bad`를 실행하여 현재 커밋에 문제가 있다고 표시를 남기고 나서 문제가 없는 마지막 커밋을 `git bisect good [good_commit]` 명령으로 표시한다.

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

이 예제에서 마지막으로 괜찮았던 커밋(v1.0)과 현재 문제가 있는 커밋 사이에 있는 커밋은 전부 12개이고 Git은 그 중간에 있는 커밋을 Checkout해준다. 여기에서 해당 이슈가 구현됐는지 테스트해보고 만약 이슈가 있으면 그 중간 커밋 이전으로 범위를 좁히고 이슈가 없으면 그 중간 커밋 이후로 범위를 좁힌다. 이슈를 발견하지 못했으면 `git bisect good`으로 이슈가 아직 없음을 알리고 계속 진행한다:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

현재 문제가 있는 커밋과 지금 테스트한 커밋 사이에서 중간에 있는 커밋이 Checkout됐다. 다시 테스트해보고 이슈가 있으면 `git bisect bad`로 이슈가 있다고 알린다:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

이제 이슈를 처음 구현한 커밋을 찾았다. 이 SHA-1 값을 포함한 이 커밋의 정보를 확인하고 수정된 파일이 무엇인지 확인한다. 이 문제가 발생한 시점에 도대체 무슨 일이 있었는지 아래와 같이 살펴본다:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

이제 찾았으니까 `git bisect reset` 명령을 실행시켜서 이진 탐색을 시작하기 전으로 HEAD를 돌려놓는다:

	$ git bisect reset

수백 개의 커밋들 중에서 버그가 만들어진 커밋을 찾는 데 몇 분밖에 걸리지 않는다. 프로젝트가 정상적으로 수행되면 0을 반환하고 문제가 있을 경우 1을 반환하는 스크립트를 만들면 이 `git bisect` 과정을 완전히 자동화 할 수 있다. 먼저 `bisect start` 명령으로 bisect를 사용할 범위를 알려준다. 위에서 한 것처럼 문제가 있다고 아는 커밋과 문제가 없다고 아는 커밋을 넘기면 된다:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

문제가 생긴 첫 커밋을 찾을 때까지 Checkout할 때마다 `test-error.sh`를 실행한다. `make`든지 `make tests`든지 어쨌든 이슈를 찾는 테스트를 실행하여 찾는다.

## 서브모듈 ##

프로젝트를 수행하다 보면 다른 프로젝트를 사용해야 하는 경우가 종종 있다. 보통 사용할 프로젝트들은 독립적으로 개발된 라이브러리들이다. 이런 상황에서 자주 생기는 이슈는, 두 프로젝트를 서로 별개로 다루면서도 그 중 하나를 다른 하나 안에서 사용할 수 있어야 한다는 것이다.

Atom 피드를 제공하는 웹사이트를 만든다고 가장하자. Atom 피드를 생성하는 코드는 직접 작성하지 않고 라이브러리를 가져다 쓰기로 했다. 그러면 CPAN이나 Ruby gem 같은 라이브러리 관리 도구를 사용하거나 해당 소스코드를 프로젝트로 복사해야 한다. 사실 라이브러리를 수정하는 것은 어렵다. 하지만 수정한 라이브러리를 모든 사용자가 이용할 수 있도록 배포하는 것은 더 어렵다. 그래서 프로젝트에 라이브러리 코드를 포함시켜서 수정하는 방법도 사용한다. 이렇게 라이브러리 코드를 포함시키면 원래 라이브러리 프로젝트의 코드와 Merge하기 어렵게 된다.

Git의 서브모듈은 이런 문제를 해결해준다. 서브모듈은 Git 저장소 안에 다른 Git 저장소를 둘 수 있게 해준다. 이렇게 해도 두 Git 저장소 모두 여전히 독립적으로 관리된다.

### 서브모듈 시작하기 ###

한 번 Ruby 웹서버 게이트웨이 인터페이스인 Rack 라이브러리를 프로젝트에 추가해보자. 추가하고 나서도 앞으로 여전히 해당 저장소에서 관리할 수 있기 때문에 마음 놓고 코드를 수정할 수 있다. 먼저 `git submodule add` 명령으로 프로젝트를 서브모듈로 추가한다:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

이제 프로젝트 디렉토리를 보면 `rack`이라는 디렉토리가 생겼을 것이다. 그 디렉토리가 Rack 프로젝트이다. `rack` 디렉토리 안에서 수정하고 Push할 권한이 있는 저장소를 하나 추가하고 나서 그 저장소에 Push한다. 물론 원래 프로젝트 저장소에서도 Fetch하고 Merge할 수 있다. 서브모듈을 추가한 직후 바로 `git status`라는 명령을 실행하면 아래와 같이 두 파일이 생긴 것을 알 수 있다:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

`.gitmodules` 파일을 살펴보자. 이 것은 로컬 디렉토리와 프로젝트 URL의 매핑 정보가 저장된 설정파일이다:

	$ cat .gitmodules
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

서브모듈 개수만큼 이 항목이 생긴다. 이 파일도 `.gitignore` 파일처럼 버전 관리된다. 다른 파일처럼 Push하고 풀한다. 이 프로젝트를 Clone하는 사람은 `.gitmodules` 파일을 보고 어떤 서브모듈 프로젝트가 있는지 알 수 있다.

`.gitmodules`은 살펴봤고 이제 `rack` 항목에 대해 살펴보자. `git diff` 명령을 실행시키면 흥미로운 점을 발견할 수 있다:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Git은 `rack` 디렉토리를 서브모듈로 취급하기 때문에 파일들을 직접 추적하지 않고 커밋 하나만 저장한다. `rack` 디렉토리에서 수정을 하고 커밋하면 다른 사람이 같은 환경을 만들 수 있도록 HEAD가 가리키는 커밋이 슈퍼프로젝트에 저장된다.

`master`처럼 브랜치 이름 같은 레퍼런스가 저장되는 것이 아니라 커밋의 SHA-1 값이 저장된다.

슈퍼프로젝트도 커밋해야 된다:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

rack 디렉토리의 모드는 160000이다. 160000 모드는 일반적인 파일이나 디렉토리가 아니라는 의미다.

하위 프로젝트의 마지막 커밋이 바뀔 때마다 슈퍼프로젝트에 저장된 커밋도 바꿔준다. `rack` 디렉토리를 별도의 프로젝트로 취급하기 때문에 모든 Git 명령은 독립적으로 동작한다:

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### 서브모듈이 있는 프로젝트 Clone하기 ###

서브모듈을 사용하는 프로젝트를 Clone하면 해당 서브모듈 디렉토리는 빈 디렉터리다:

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

분명히 `rack` 디렉토리가 있지만 비워져 있다. 먼저 `git submodule init` 명령으로 서브모듈을 초기화하고 `git submodule update` 명령으로 서버에서 데이터를 가져온다. 데이터를 전부 가져오면 슈퍼프로젝트에 저장된 커밋으로 Checkout된다:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

`rack` 디렉토리는 이제 복원했다. 그리고 누군가 rack을 수정하면 그 코드를 가져다 Merge한다:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

Merge해서 서브모듈의 HEAD 값이 변경됐다. 슈퍼프로젝트가 아는 커밋과 서브모듈의 HEAD가 달라서 아직 워킹 디렉토리의 상태는 깨끗한 상태가 아니다:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

이럴 때 `git submodule update` 명령을 실행해서 해결한다:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

서브모듈 프로젝트를 풀할 때마다 `git submodule update` 명령을 실행해야 한다. 뭔가 속는 것 같지만 잘 된다.

개발자들이 흔히 저지르는 실수로 서브모듈의 코드를 수정하고 나서 서버에 Push하지 않는 경우가 있다. 슈퍼프로젝트는 Push했지만 프로젝트가 아는 커밋은 아직 Push하지 않고 개발자 PC에만 있다. 만약 다른 개발자가 `git submodule update`를 실행하면 슈퍼프로젝트에 저장된 커밋을 서브모듈 프로젝트에서 찾을 수 없어서 에러가 발생한다:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

누가 마지막으로 서브모듈을 수정했는지 확인하고:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

그 개발자에게 이메일을 보내거나 전화를 건다.

### 슈퍼프로젝트 ###

프로젝트 규모가 크면 CVS나 Subversion에서는 모듈 프로젝트를 간단히 하위 디렉토리로 만들었다. 가끔 Git에서도 이런 Workflow을 사용하려는 개발자들이 있다.

Git에서는 각 하위 디렉토리를 별도의 Git 저장소로 만들어야 한다. 그리고 그 저장소를 포함하는 상위 저장소를 만든다. 슈퍼프로젝트의 태그와 브랜치를 이용해서 각 프로젝트의 관계를 구체적으로 정의할 수 있다는 것은 Git만의 장점이다.

### 서브모듈 사용할 때 주의할 점들 ###

전체적으로 서브모듈은 어렵지 않게 사용할 수 있지만, 서브모듈의 코드를 수정하는 경우에는 주의가 필요하다. `git submodule update` 명령을 실행시키면 특정 브랜치가 아니라 슈퍼프로젝트에 저장된 커밋을 Checkout해 버린다. 그러면 `detached HEAD`라고 부르는 상태가 된다. `detached HEAD`는 HEAD가 브랜치나 태그 같은 간접 레퍼런스를 가리키지 않고 커밋을 가리키는 것을 말한다. 데이터를 잃어 버릴 수도 있기 때문에 일반적으로 `detached HEAD` 상태는 피해야 한다.

`submodule update`를 실행하고 나서 별도의 작업용 브랜치를 만들지 않고 서브모듈 코드를 수정하고 커밋한다. 그리고 나중에 커밋한 것을 잊은 채로 슈퍼프로젝트에서 다시 `git submodule update`를 실행시키면 Git은 아무 말 없이 Checkout해 버린다. 엄밀히 말해서 커밋을 없어진 것은 아니지만 브랜치에 속하지 않는 커밋을 찾아내기란 정말 어렵다.

`git checkout -b work` 같은 명령으로 작업할 때마다 work 브랜치를 만들면 이 문제를 피할 수 있다. 실수로 `submodule update` 명령을 실행해 버려서 하던 일을 놓쳐버려도 포인터가 있어서 언제든지 되찾을 수 있다.

그리고 서브모듈이 있는 슈퍼프로젝트의 브랜치를 오갈 때는 약간의 추가작업이 필요하다. 브랜치를 만들고 서브모듈을 추가한다. 그 다음에 서브모듈이 없는 브랜치로 돌아간다. 그렇지만, 이미 추가한 서브모듈 디렉토리가 untracked 상태로 보인다:

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

서브모듈 디렉토리를 다른 곳에 옮겨 두거나 삭제해야 한다. 삭제할 경우는 원래 브랜치로 돌아왔을 때 서브모듈을 다시 Clone해야 하고, 이 경우 아직 Push하지 않았던 변경사항이나 브랜치를 잃을 수 있다.

rack이라는 디렉토리가 있고 이것을 서브모듈로 바꾸려고 한다고 가정하자. 먼저 rack 디렉토리를 삭제하고 `submodule add`를 실행하면 Git은 아래와 같은 에러를 뱉는다:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

`rack` 디렉토리를 Staging Area에서 제거하면 서브모듈을 추가할 수 있다.

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

한 브랜치에서는 해결했다. 아직 해당 디렉토리를 서브모듈로 만들지 않은 브랜치를 Checkout하려고 하면 아래와 같은 에러가 난다:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

다른 브랜치로 바꾸기 전에 `rack` 서브모듈 디렉토리를 다른 곳으로 옮겨 둔다:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

그리고 나서 다시 서브모듈이 있는 브랜치로 돌아가면 rack 디렉토리는 텅 비어 있다. `git submodule update` 명령으로 다시 Clone하거나 `/tmp/rack/`에 복사해둔 파일을 다시 복사한다.

## Subtree Merge ##

서브모듈 시스템이 무엇이고 어디에 쓰는지 배웠다. 그런데 같은 문제를 해결하는 방법이 또 하나 있다. Git은 Merge하는 시점에 무엇을 Merge할지, 어떤 전략을 사용할지 결정해야 한다. Git은 브랜치 두 개를 Merge할 때에는 _Recursive_ 전략을 사용하고 세 개 이상의 브랜치를 Merge할 때에는 _Octopus_ 전략을 사용한다. 이 전략은 자동으로 선택된다. Merge할 브랜치가 두개면 _Recursive_ 전략이 선택된다. _Recursive_ 전략은 Merge하려는 두 커밋과 공통 조상 커밋을 이용하는 `three-way merge`를 사용하기 때문에 단 두 개의 브랜치에만 적용할 수 있다. Octopus 전략은 브랜치가 여러 개라도 Merge할 수 있지만 비교적 충돌이 쉽게 일어난다.

다른 전략도 있는데 그중 하나가 _Subtree_ Merge다. 이 Merge는 하위 프로젝트 문제를 해결하는 데에도 사용한다. 위에서 사용했던 Rack 예제를 적용해 보자.

Subtree Merge는 마치 하위 프로젝트가 아예 합쳐진 것처럼 보일 정도로 한 프로젝트를 다른 프로젝트의 하위 디렉토리에 연결해준다. 정말 놀라운 기능이다.

Rack 프로젝트를 리모트 저장소로 추가시키고 브랜치를 Checkout한다:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

Checkout한 `rack_branch`의 루트 디렉토리와 origin 프로젝트의 `master` 브랜치의 루트 디렉토리는 다르다. 브랜치를 바꿔가며 어떻게 다른지 확인한다:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

여기에서 Rack 프로젝트를 `master` 브랜치의 하위 디렉토리에 넣으려면 `git read-tree` 명령어를 사용한다. *9장*에서 `read-read` 류의 명령어를 좀 더 자세히 다룬다. 여기에서는 워킹 디렉토리와 Staging Area로 어떤 브랜치를 통째로 넣을 수 있다는 것만 알면 된다. `master` 브랜치로 되돌아가서 `rack_branch`를 `rack` 디렉토리에 넣는다:

	$ git read-tree --prefix=rack/ -u rack_branch

그리고 나서 커밋을 하면 rack 디렉토리는 rack 프로젝트의 파일들을 직접 복사해 넣은 것과 똑같다. 복사한 것과 다른 점은 브랜치를 자유롭게 바꿀 수 있고 최신 버전의 Rack 프로젝트의 코드를 쉽게 끌어 올 수 있다는 점이다:

	$ git checkout rack_branch
	$ git pull

그리고 `git merge -s subtree`라는 명령어를 사용하여 `master` 브랜치와 Merge할 수 있고 원하든 원하지 않든 간에 히스토리도 함께 Merge된다. 수정 내용만 Merge하거나 커밋 메시지를 다시 작성하려면 `-s subtree` 옵션에다가 `--squash`, `--no-commit`를 함께 사용해야 한다:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Rack 프로젝트의 최신 코드를 가져다가 Merge했고 이제 커밋하면 된다. 물론 반대로 하는 것도 가능하다. `rack` 디렉토리로 이동해서 코드를 수정하고 `rack_branch` 브랜치로 Merge한다. 그리고 Rack 프로젝트 저장소에 Push할 수 있다.

`rack` 디렉토리와 `rack_branch` 브랜치와의 차이점도 비교할 수 있다. 일반적인 `diff` 명령은 사용할 수 없고 `git diff-tree` 명령을 사용해야 한다:

	$ git diff-tree -p rack_branch

또 `rack` 디렉토리와 저장소의 `master` 브랜치와 비교할 수 있다:

	$ git diff-tree -p rack_remote/master

## 요약 ##

커밋과 저장소를 꼼꼼하게 관리하는 도구를 살펴보았다. 문제가 생기면 바로 누가, 언제, 무엇을 했는지 찾아내야 한다. 그리고 프로젝트를 쪼개고 싶을 때 사용하는 방법들도 배웠다. 이제 Git 명령어는 거의 모두 배운 것이다. 독자들이 하루빨리 익숙해져서 자유롭게 사용했으면 좋겠다.
