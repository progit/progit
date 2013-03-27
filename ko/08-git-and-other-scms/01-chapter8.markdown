# Git과 다른 VCS #

세상은 완벽하지 않다. 보통 프로젝트를 전부 Git으로 옮기는 것은 쉽지 않다. 프로젝트가 다른 VCS 시스템에 매우 단단히 결합되어 있을 수 있다. 보통 Subversion이 그렇다. 이번 장은 `git svn` 이라는 Git과 Subversion을 양방향으로 이어 주는 도구를 알아 보며 시작한다.

언젠가 이미 존재하는 프로젝트 환경을 Git으로 변경하고 싶게 될 것이다. 이 장의 나머지 부분에서 프로젝트를 Git으로 변경하는 방법에 대해 다룰 것이다. 먼저 Subversion에서 프로젝트를 옮겨 오는 방법을 설명하고 그 다음에는 Perforce, 그리고 스크립트를 직접 만들어서 잘 쓰지 않는 VCS에서도 프로젝트를 옮기는 방법을 다룰 것이다.

## Git과 Subversion ##

현재 주요 오픈소스 프로젝트와 아주 많은 수의 기업 프로젝트에서 소스코드 관리를 위해 Subversion을 사용한다. 10여년간 Subversion은 가장 인기있는 오픈소스 VCS 도구였다. 그 이전 시대에서 가장 많이 사용하였던 CVS와 많이 닮았다.

Git이 자랑하는 또 하나의 기능은 `git svn`이라는 양방향 Subversion 지원 도구이다. Git을 완벽한 Subversion 클라이언트로 사용할 수 있기 때문에 로컬에서는 Git의 기능을 활용하고 Push 할 때 Subversion 서버에 Push 할 수 있다. 즉 로컬 브랜치와 Merge, Stage 영역, Rebase, Cherry-pick 등의 Git 기능을 충분히 사용할 수 있다. 같이 일하는 동료는 선사시대 빛도 없는 곳에서 일하겠지만 말이다. `git svn`은 기업의 개발 환경에서 git을 사용하는 출발점으로 사용할 수 있고 우리가 Git을 도입하기 위해 기업내에서 노력하는 동안 동료가 효율적으로 환경을 바꿀 수 있도록 도움을 줄 수 잇다. Subversion 지원 도구는 DVCS 세상으로 인도하는 붉은 알약과 같은 것이다.

### git svn ###

Git과 Subversion을 이어주는 명령은 `git svn` 으로 시작한다. 이 명령 뒤에 추가적으로 몇 가지 더 명령이 정의되어 있으며 작은 예제를 보여주고 설명할 것이다.

`git svn` 명령을 사용할 때는 절름발이인 Subversion을 사용하고 있다는 점을 염두해두자. 우리가 로컬 브랜치와 Merge 기능을 손쉽게 쓸 수 있다고 하더라도 최대한 일직선으로 히스토리를 유지하는것이 좋다. Git 저장소를 사용하는것 처럼 하지 않는 것이 좋다.

히스토리를 재작성하지 말아야 하고 Push를 재전송하지도 말아야 한다. 동시에 같은 Git 저장소에 Push하지도 말아야 한다. Subversion은 단순히 일직선의 히스토리만 가질 수 있다. 우리가 일부는 SVN을 일부는 Git을 사용하는 팀에 있을 때에는 협업을 위해서 모두가 SVN Server를 사용해야 한다. 그래야 삶이 편하다.

### 설정하기 ###

이 기능을 써보기 위해 우리는 SVN 저장소 하나가 필요하다. 물론 쓰기 권한도 있어야 한다. 아래 나오는 예제를 써보려면 필자의 test 저장소를 하나 복사해야 한다. 최근의 Subversion(1.4 이상) 에 포함된 `svnsync`라는 도구를 사용하여 SVN 저장소를 복사할 수 있다. 테스트를 해보기 위해 필자는 Google Code에 새로 Subversion 저장소를 하나 만들고 `protobuf` 라는 프로젝트의 일부 코드를 복사했다. `protobuf`는 네트워크 전송에 필요한 구조화된 데이터(프로토콜 같은 것들)의 인코딩을 도와주는 도구이다.

우선 로컬 Subversion 저장소를 하나 만들어야 한다:

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

그 다음에, 모든 사용자가 revprops 속성을 변경할 수 있도록 항상 0을 반환하는 pre-revprop-change 스크립트를 준비한다(역주: 파일이 없거나, 다른 이름으로 되어있을 수 있다. 이 경우 아래 내용으로 새로 파일을 만들고 실행 권한을 준다):

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

이제 `svnsync init` 명령으로 다른 Subversion 저장소를 로컬로 복사하도록 지정할 수 있다:

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

위와 같이 다른 저장소의 주소를 설정하면 복사할 준비가 된다. 아래 명령으로 저장소를 실제로 복사한다:

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

이 명령은 몇 분 걸리지 않지만, 저장하는 위치가 로컬이 아니라 리모트 서버라면 시간이 많이 걸린다. 커밋이 100개 이하라고 해도 오래 걸릴 것이다. Subversion은 한번에 커밋을 하나씩 받아서 Push하기 때문에 엄청나게 비효율적이다. 하지만 저장소를 복사하는 다른 방법은 없다.

### 시작하기 ###

이제 갖고 놀 Subversion 저장소가 하나 준비되었다. `git svn clone` 명령으로 Subversion 저장소 전체를 Git 저장소로 가져올 수 있다. 만약  Subversion 저장소가 로컬에 있는 것이 아니라 리모트 서버에 있다면 `file:///tmp/test-svn` 부분에 서버 저장소의 URL을 적어 주면 된다.

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

위 명령은 사실 SVN 저장소 주소를 주고 `git svn init`과 `git svn fetch` 명령을 순서대로 실행한 것과 같다. 이 명령은 시간이 좀 걸린다. 테스트로 사용하는 프로젝트는 커밋이 75개 정도 밖에 안되서 시간이 많이 걸리지 않는다. 하지만 Git은 커밋을 한번에 하나씩 일일이 기록을 해야 하기 때문에 커밋이 수천개인 프로젝트라면 몇 시간 혹은 몇 일이 걸릴 수도 있다.

`-T trunk -b branches -t tags` 부분은 Git에게 Subversion이 어떤 브랜치 구조를 가지고 있는지 정보를 알려주는 부분이다. Subversion의 표준 형식과 다른 이름을 가지고 있다면 이 옵션 부분에서 알맞은 이름을 지정해줄 수 있다. 표준 형식을 사용한다면 간단하게 `-s` 옵션을 사용한다. 즉 아래의 명령도 같은 의미이다.

	$ git svn clone file:///tmp/test-svn -s

Git에서도 브랜치와 Tag 정보가 제대로 보이는 것을 확인할 수 있다:

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

`git svn` 도구가 리모트 브랜치의 이름을 어떻게 짓는지 알아두는 것이 중요하다. 일반적으로 Git 저장소를 복제할 때 모든 브랜치는 `origin/[branch]` 처럼 리모트 저장소의 이름을 가지고 모든 브랜치를 로컬에 복제해 놓는다. `git svn`은 우리가 리모트 저장소를 단 하나만 사용한다고 가정한다. 그렇기에 리모트 저장소의 이름을 붙여서 브랜치를 관리하지 않는다. Git의 Plumbing 명령어인 `show-ref` 명령으로 리모트 브랜치들의 정확한 이름을 확인할 수 있다.

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

일반적인 Git 저장소라면 다음과 비슷할 것이다:

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

`master` 브랜치가 있는 `gitserver` 서버 저장소와 `master`, `testing` 브랜치가 있는 `origin` 이라는 리모트 저장소가 있다.

`git svn`으로 가져온 저장소는 Tag가 일반적인 Git Tag가 아니라 리모트 브랜치로 등록되는 점을 잘 기억해두자. Subversion Tag는 tags라는 리모트 서버의 브랜치처럼 보일 것이다.

### Subversion 서버에 커밋하기 ###

자 이제 작업할 Git 저장소는 준비되었고, 무엇인가 수정하고 서버로 고친 내용을 Push 해야 할 때가 왔다. Git을 Subversion의 클라이언트로 사용해서 수정한 내용을 전송할 수 있다. 어떤 파일을 수정하고 커밋을 하면 그 수정한 내용은 Git의 로컬 저장소에 저장되지만 Subversion 서버에는 아직 반영되지 않는다.

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

이제 서버로 수정한 내용을 전송한다. 유심히 살펴볼 부분은 Git 저장소에 여러개의 커밋을 쌓아놓고 Subversion 서버로는 해당 커밋을 한번에 보낼 수 있다는 점이다. `git svn dcommit` 명령으로 서버로 Push한다.

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

이 명령은 새로 추가한 커밋을 모두 Subversion에 커밋하고 로컬 Git 커밋을 다시 만든다. 커밋이 다시 만들어지기 때문에 이미 저장된 커밋의 SHA-1 체크섬이 바뀐다. 그래서 리모트 Git 저장소와 Subversion 저장소를 함께 사용하는 것은 좋은 생각이 아니다. 그리고 새로 만들어진 커밋을 살펴보면 아래와 같이 `git-svn-id`가 추가된 것을 볼 수 있다:

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

원래 `97031e5`로 시작하는 SHA 체크섬이 지금은 `938b1a5`로 시작한다. 만약 Git 서버와 Subversion 서버에 함께 Push하고 싶다면 우선 Subversion 서버에 `dcommit`으로 먼저 Push를 하고 그 다음에 Git 서버에 Push 해야 한다.

### 새로운 변경사항 받아오기 ###

다른 개발자들과 함께 일하는 과정에서 다른 개발자가 Push한 상태에서 Push를 하면 충돌이 날 수도 있다. 충돌을 해결하지 않으면 서버로 Push할 수 없다. 충돌이 날 때 `git svn` 명령은 다음과 같이 보여준다:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

이런 상황에서는 `git svn rebase` 명령으로 이 문제를 해결한다. 이 명령은 서버에서 변경사항을 내려받고 그 다음에 로컬의 변경사항들을 그 위에 적용한다:

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

그러면 서버의 코드 위에 변경사항이 적용됐기 때문에 성공적으로 `dcommit` 명령을 마칠 수 있다:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Push하기 전에 서버의 내용을 Merge하는 Git과 달리 `git svn`은 충돌이 발생했을 때에만 서버에서 업데이트할 것이 있다고 알려 준다. 이 점을 꼭 기억해야 한다. 만약 서로 다른 파일을 수정한다면 `dcommit`은 성공적으로 수행된다:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

이 부분이 왜 중요하냐면 Push하고 난 프로젝트 상태가 Push하기 이전의 상태와 같지 않다는 것이다. 충돌은 없고 변경사항이 원하는 대로 적용되지 않을 때 제대로 코드를 확인할 수 없다. 이러한 부분이 Git과 다른점인데 Git에서는 서버로 보내기 전에 프로젝트 코드의 모든 상태를 테스트할 수 있다. SVN은 서버로 커밋하기 전과 후의 상태가 동일하다는 것을 확신할 수 없다.

`git svn rebase` 명령으로도 Subversion 서버로부터 변경사항을 가져오는데 사용할 수 있다. 커밋을 보낼 준비가 되지 않았다 해도 말이다. `git svn fetch` 명령을 사용할 수도 있지만 `git svn rebase` 명령은 변경사항을 가져오고 적용까지 한 번에 해준다.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

수시로 `git svn rebase` 명령을 사용하면 로컬 코드를 항상 최신 버전으로 유지할 수 있다. 이 명령을 사용하기 전에 작업하고 있는 디렉토리를 깨끗하게 만드는 것이 좋다. 깨끗하지 못하면 Stash를 하거나 임시로 커밋을 하고 나서 `git svn rebase` 명령을 실행하는 것이 좋다. 깨끗하지 않아서 충돌이 나면 이 명령은 중지된다.

### Git 브랜치 문제 ###

Git에 익숙하다면 일을 할 때 먼저 토픽 브랜치를 만들고 다시 Merge하는 방식을 쓰려고 할 것이다. `git svn`으로 Subversion 서버에 Push할 거라면 브랜치를 Merge하지 않고 Rebase할 것이다. 그 이유는 Subversion은 일직선 히스토리 밖에 모르고 Git의 Merge도 알지 못하기 때문이다. 그래서 Git 커밋을 Subversion 커밋으로 변경할 때 `git svn`은 첫 번째 부모 정보만 사용한다.

`experiment` 브랜치를 하나 만들고 2개의 변경사항을 커밋한다. 그리고 `master` 브랜치로 Merge하고 나서 `dcommit` 명령을 수행하면 아래와 같은 모양이 된다:

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Merge 커밋이 들어 있는 히스토리에서 `dcommit` 명령을 수행하고 나서 Git 히스토리를 살펴보면 `experiment` 브랜치의 커밋은 재작성되지 않았다. 대신 Merge 커밋만 SVN 서버로 전송됐을 뿐이다.

누군가 이 것을 내려 받으면 결과가 합쳐진 Merge 커밋 하나면 볼 수 있다. 다른 사람은 언제 어디서 커밋한 것인지 알 수 없다.

### Subversion의 브랜치 ###

Subversion의 브랜치는 Git의 브랜치와 달라서 가능한 사용을 하지 않는 것이 좋다. 하지만 `git svn`으로 Subversion 브랜치를 사용할 수 있다.

#### SVN 브랜치 만들기 ####

Subversion 브랜치를 만들려면 `git svn branch [branchname]` 명령을 사용한다:

	$ git svn branch opera
	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

이 명령은 Subversion의 `svn copy trunk branches/opera` 명령과 동일하다. 이 명령은 브랜치를 Checkout해주지 않는다는 것을 주의해야 한다. 여기서 커밋하면 `opera` 브랜치가 아니라 `trunk` 브랜치에 컷민된다.

### Subversion 브랜치 넘나들기 ###

`dcommit` 명령은 어떻게 커밋 할 브랜치를 결정할까? Git은 히스토리에 있는 커밋중에서 가장 마지막으로 기록된 Subversion 브랜치를 찾는다. 즉, 현 브랜치 히스토리의 커밋 메시지에 있는 `git-svn-id` 항목을 읽는 것이기 때문에 오직 한 브랜치에만 전송할 수 있다.

`dcommit` 명령으로 다른 브랜치에 커밋할 수 있다. 그 다른 브랜치의 Subversion 커밋에서 시작하는 브랜치를 만들면 된다. 그러면 동시에 여러 브랜치에서 작업할 수 있다. 다음과 같이 `opera` 브랜치를 만들면 독립적으로 일 할 수 있다:

	$ git branch opera remotes/opera

일반적인 `git merge` 명령으로 `opera` 브랜치를 `trunk` 브랜치(`master` 브랜치 역할)에 Merge하면 된다. 하지만 `-m` 옵션을 주고 적절한 커밋 메시지를 작성해주지 않으면 아무짝에 쓸모없는 "Merge branch opera" 같은 메시지가 커밋된다.

`git merge` 명령으로 Merge한다는 것에 주목하자. Git은 자동으로 공통 커밋을 찾아서 Merge에 참고하기 때문에 Subversion에서 하는 것보다 Merge가 더 잘된다. 하지만 일반적인 Merge 커밋과는 다르다. 이 커밋을 Subversion 서버에 Push해야 하지만 Subversion에서는 부모가 2개인 커밋이 있을 수 없다. 그래서 Push하면 브랜치에서 만들었던 커밋 여러개가 하나로 합쳐진(squash된) 것처럼 Push된다. 그래서 일단 Merge를 하고 나면 취소하거나 해당 브랜치에서 계속 작업하기 어렵다. `dcommit` 명령을 수행하면 Merge된 브랜치의 정보를 어쩔 수 없이 잃어버리게 된다. 그래서 Merge Base도 찾을 수 없다. `dcommit` 명령은 Merge한 것을 `git merge --squash`로 Merge한 것과 똑 같이 만들어 버린다. Branch를 Merge한 정보는 저장되지 않기 때문에 이 문제를 해결할 방법이 없다. 문제를 최소화하려면 trunk에 Merge하자마자 해당 브랜치를(여기서는 `opera`) 삭제하는 것이 좋다.

### Subversion 명령 ###

`git svn` 명령은 Git으로 전향하기 쉽도록 Subversion에 있는 것과 비슷한 명령어를 지원한다. 아마 여기서 설명하는 명령이 익숙할 것이다.

#### SVN 형식의 히스토리 ####

Subversion에 익숙한 사람은 Git 히스토리를 SVN 형식으로 보고 싶을지도 모른다. `git svn log` 명령은 SVN 형식으로 히스토리를 보여준다:

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines
	
	updated the changelog

`git svn log`명령에서 기억해야 할 것은 두 가지다. 우선 오프라인에서 동작한다는 점이다. 실제 `svn log` 명령어는 히스토리 데이터를 조회하려면 서버가 필요하다. 둘째로 이미 서버로 전송한 커밋만 출력해준다. 아직 `dcommit` 명령으로 서버로 전송하지 않은 로컬 Git 커밋은 보여주지 않는다. Subversion 서버에는 있지만 아직 내려받지 않은 변경사항도 보여주지 않는다. 즉, 현재 알고있는 Subversion 서버의 상태만 보여준다.

#### SVN 어노테이션 ####

`git svn log` 명령이 `svn log` 명령을 흉내내는 것처럼 `git svn blame [FILE]` 명령으로 `svn annotate` 명령을 흉내낼 수 있다. 실행한 결과는 다음과 같을 것이다:

	$ git svn blame README.txt 
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal 
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal 
	79    schacon Committing in git-svn.
	78    schacon 
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal 

다시 한번 말하지만 이 명령도 아직 서버로 전송하지 않은 커밋은 보여주지 않는다.

#### SVN 서버 정보 ####

`svn info` 명령은 `git svn info` 명령으로 대신할 수 있다:

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

`blame`이나 `log`명령이 오프라인에서 동작하듯이 이 명령도 가장 마지막으로 서버에서 정보를 내려받은 시점의 정보를 출력한다.

#### Subversion에서 무시하는것 무시하기 ####

Subversion 저장소를 클론하면 쓸데 없는 파일을 커밋하지 않도록 `svn:ignore` 속성을 `.gitignore` 파일로 만들고 싶을 것이다. `git svn`은 이 문제와 관련된 명령 두 가지 있다. 하나는 `git svn create-ignore` 명령으로 해당 위치에 커밋할 수 있는 `.gitignore` 파일을 생성해준다.

두 번째 방법은 `git svn show-ignore` 명령으로 `.gitignore`에 추가할 목록을 출력해 준다. 프로젝트 exclude 파일로 결과를 리다이렉트할 수 있다:

	$ git svn show-ignore > .git/info/exclude

이 방법은 `.gitignore` 파일로 프로젝트를 더럽히지 않아도 된다. 혼자서만 Git을 사용하고 있으면 다른 팀원들은 프로젝트에 `.gitignore` 파일이 있는 것을 싫어 할 수도 있다.

### Git-Svn 요약 ###

`git svn` 도구는 여러가지 이유로 Subversion 서버를 사용해야만 하는 상황에서 빛을 발한다. 하지만 Git의 모든 장점을 이용할 수는 없다. Git과 Subversion은 다르기 때문에 혼란이 빚어질 수도 있다. 이런 문제에 빠지지 않기 위해서 다음 가이드라인을 지키고자 노력해야 한다:

* Git 히스토리를 일직선으로 유지하라. `git merge`로 Merge 커밋이 생기지 않도록 하라. Merge 말고 Rebase로 변경사항을 Master 브랜치에 적용하라.
* 따로 Git 저장소 서버를 두지 말라. 클론을 빨리 하기 위해서 잠깐 하나 만들어 쓰는 것은 무방하나 절대로 Git 서버에 Push하지는 말아야 한다. `pre-receive` 훅에서 `git-svn-id`가 들어 있는 커밋 메시지는 거절하는 방법도 괜찮다.

이러한 가이드라인을 잘 지키면 Subversion 서버도 쓸만하다. 그렇다고 하더라도 진짜 Git 서버를 사용해도 되면 진짜 Git 서버를 사용하는 것이 훨씬 좋다.

## Git으로 옮기기 ##

다른 VCS를 사용하는 프로젝트를 Git으로 옮기고 싶다면 우선 프로젝트를 Git으로 이전(Migrate)해야 한다. 이번 절에서는 Git에 들어 있는 Importer를 살펴보고 직접 Importer를 만드는 방법을 알아본다.

### 가져오기 ###

널리 사용되는 Subversion과 Perforce로부터 프로젝트를 이전하는 방법을 살펴본다. 이 두 VCS에서 Git으로 이전하고자 하는 사람이 많고 Importer도 Git에 이미 들어 있다.

### Subversion ###

`git svn`을 설명하는 절을 읽었으면 쉽게 `git svn clone` 명령으로 저장소를 가져올 수 있다. 가져오고 나서 Subversion 서버는 중지하고 Git 서버를 만들고 사용하면 된다. 만약 히스토리 정보가 필요하면 (느린) Subversion 서버 없이 로컬에서 조회해 볼 수 있다.

이 가져오기 기능에 문제가 좀 있는데, 우선 가져오기에 시간이 많이 든다는 점이다. 하지만 일단 가져오기를 하는 것이 낫다. 첫 번째 문제는 Author 정보이다. Subversion에서 커밋하는 사람은 해당 시스템에 계정이 있어야 한다. `blame`이나 `git svn log`와 같은 명령에서 `schacon`이라는 이름을 봤을 것이다. 이 정보를 Git 형식의 정보려 변경하려면 Subversion 사용자와 Git Author를 연결시켜줘야 한다.  이 Author 정보를 좀 더 나은 Git Author 정보로 변경하기 위해서 Subversion 사용자 이름과 Git Author 간에 연결을 해 주어야 한다. `users.txt`라는 파일을 다음과 같이 만든다:

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

SVN에 기록된 Author 이름은 어떤 것들이 있는지 다음 명령으로 조회한다:

	$ svn log --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

우선 XML 형식으로 SVN 로그를 출력하고, 거기서 Author 정보만 찾고, 중복된 것을 제거하고, XML Tag는 버린다. 물론 `grep`, `sort`, `perl` 명령이 동작하는 시스템에서만 이 명령을 사용할 수 있다. 이 결과에 Git Author 정보를 더해서 `users.txt` 만든다.

이 파일을 `git svn` 명령에 전달하면 보다 정확한 Author 정보를 Git 저장소에 남길 수 있다. 그리고 `git svn`의 `clone`이나 `init` 명령에 `--no-metadata` 옵션을 주면 Subversion의 메타데이터를 저장하지 않는다. 해당 명령은 아래와 같다:

	$ git-svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

`my_project` 디렉토리에 진짜 Git 저장소가 생성된다. 결과는 바로 아래와 같지 않고:

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

다음과 같을 것이다:

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Author 정보 항목이 훨씬 Git답고 `git-svn-id` 항목도 기록되지 않았다.

이제 뒷 정리를 해야 한다. `git svn`이 만들어 준 이상한 브랜치나 Tag를 제거해야 한다. 우선 이상한 리모트 Tag를 모두 진짜 Git Tag로 옮긴다.그리고 브랜치도 똑같다. 리모트 브랜치를 로컬 브랜치로 옮긴다. 

Tag를 진정한 Git Tag로 만들려면 다음과 같이 한다:

	$ cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
	$ rm -Rf .git/refs/remotes/tags

`tags/` 로 시작하는 리모트 브랜치를 가져다 (Lightweight) Tag로 만들었다.

`refs/remotes` 밑에 있는 레퍼런스는 전부 로컬 브랜치로 만든다:

	$ cp -Rf .git/refs/remotes/* .git/refs/heads/
	$ rm -Rf .git/refs/remotes

이제 모든 Tag와 브랜치는 진짜 Git Tag와 브랜치가 됐다. Git 서버를 새로 추가를 하고 지금까지의 작업을 Push하는 일이 남았다. 다음과 같이 리모트 서버를 추가한다:

	$ git remote add origin git@my-git-server:myrepository.git

분명 모든 브랜치와 Tag를 Push하고 싶을 것이다:

	$ git push origin --all

모든 브랜치와 Tag를 Git 서버로 깔끔하게 잘 옮겼다.

### Perforce ###

이제 Perforce 차례다. Preforce Importer도 Git에 들어 있지만 소스코드의 `contrib` 에 있기 때문에 `git svn` 처럼 바로 사용할 수 없다. Perforce Importer를 사용하려면 우선 git.kernel.org에서 Git 소스코드를 가져와야 한다:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

`git-p4` 라는 Python 스크립트는 `fast-import` 디렉토리에 있다. 그리고 Python과 `p4`가 설치돼 있어야 이 스크립트가 동작한다. Perforce Public Depot에 있는 Jam 프로젝트를 옮기는 예제를 살펴보자. 우선 Perfoce Depot의 주소를 P4PORT 환경변수에 설정한다:

	$ export P4PORT=public.perforce.com:1666

`git-p4 clone` 명령으로 Perforce 서버에서 Jam 프로젝트를 가져온다. 이 명령에 Depot, 프로젝트 경로, 프로젝트를 가져올 경로를 주면 된다:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

`/opt/p4import` 디렉토리로 이동하고 `git log` 명령을 실행하면 프로젝트의 정보를 볼 수 있다:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

커밋마다 `git-p4` 라는 ID 항목이 들어가 있다. 나중에 Perforce Change Number가 필요해질 수도 있으니 커밋에 그대로 유지하는 편이 좋다. 하지만 ID를 지우고자 한다면 지금 하는 것이 가장 좋다. `git filter-branch` 명령으로 한방에(en masse) 삭제한다:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

`git log` 명령을 실행하면 모든 SHA-1 체크섬이 변경됐고 커밋 메시지에서 `git-p4` 항목도 삭제된 것을 확인할 수 있다.

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

이제 새 Git 서버에 Push하기만 하면 된다.

### 직접 Importer 만들기 ###

사용하는 VCS가 Subversion이나 Perforce가 아니면 인터넷에서 적당한 Importer를 찾아봐야 한다. CVS, Clear Case, Visual Source Safe 같은 시스템용 Importer가 좋은게 많다. 심지어 단순히 디렉토리 아카이브용 Importer에도 좋은게 있다. 사람들이 잘 안쓰는 시스템을 사용하고 있다면 적당한 Importer를 못 찾았거나 부족해서 좀 더 고쳐야 한다면 `git fast-import`를 사용할 수 있다. 이 명령은 표준입력으로 데이터를 입력받는데, 9장에서 배우는 저수준 명령어와 내부 객체를 직접 다루는 것보다 훨씬 쉽다. 먼저 사용하는 VCS에서 필요한 정보를 수집해서 표준출력으로 출력하는 스크립트를 만든다. 그리고 그 결과를 `git fast-import`의 표준입력으로 보낸다(pipe).

간단한 Importer를 작성해보자. `back_YYYY_MM_DD` 라는 디렉토리에 백업하면서 프로젝트를 진행하는 예제를 보자. Importer를 만들 때 디렉토리 상태는 다음과 같다고 가정한다:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

Importer를 만들기 전에 우선 Git이 어떻게 데이터를 저장하는지 알아야 한다. 이미 알고 있듯이 Git은 기본적으로 Snapshot을 가리키는 커밋 개체가 연결된 리스트이다. Snapshot이 뭐고, 그걸 가리키는 커밋은 또 뭐고, 그 커밋의 순서가 어떻게 되는가를 `fast-import`에 알려 주는 것이 해야할 일의 전부다. 그래서 디렉토리마다 Snapshot을 만들고, 커밋 개체를 만들고, 이전 커밋과 연결 시킨다.

7장의 "정책 구현하기" 절에서 했던 것 처럼 Ruby로 스크립트를 작성한다. 필자는 Ruby를 많이 사용하기도 하고 Ruby가 읽기도 쉽다. 하지만 자신에게 익숙한 것을 사용하여 표준출력으로 적절한 정보만 출력할 수 있으면 된다. 그리고 이 일을 Windows에서 할 것이라면 줄바꿈 문자에 CR(Carriage Return) 문자가 들어가지 않도록 주의해야 한다. Windows인데도 불구하고 `git fast-import` 명령은 줄바꿈 문자로 CRLF 문자가 아니라 LF(Line Feed) 문자만 허용한다.

우선 대상 디렉토리로 이동해서 각 하위 디렉토리를 살펴보자. 각 하위 디렉토리가 Snapshot 하나가 되고 커밋 하나가 된다. 하위 디렉토리마다 다니면서 필요한 정보를 출력한다. 기본적인 로직은 다음과 같다:

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do 
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

각 디렉토리에서 `print_export`를 호출하는데 이 함수는 인자로 디렉토리와 이전 Snapshot Mark를 전달받고 현 Snapshot Mark를 반환한다. 그래서 적절히 연결 시킬 수 있다. `fast-import`에서 "Mark"는 커밋의 식별자를 말한다. 커밋을 하나 만들면 Mark도 같이 만들어 이 Mark로 다른 커밋과 연결 시킨다. 그래서 `print_export`에서 우선 해야 하는 일은 각 디렉토리 이름으로 Mark를 생성하는 것이다:

	mark = convert_dir_to_mark(dir)

Mark는 정수 값을 사용해야 하기 때문에 디렉토리를 배열에 담고 그 인덱스를 Mark로 사용한다. 다음과 같이 작성한다:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

각 커밋을 가리키는 정수 Mark를 만들었고 다음은 커밋 메타데이터에 넣을 날짜 정보가 필요하다. 이 날짜는 디렉토리 이름에 있는 것을 가져다 사용한다. `print_export`의 두 번째 줄은 다음과 같다:

	date = convert_dir_to_date(dir)

`convert_dir_to_date`는 아래와 같이 정의한다:

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

시간는 정수 형태로 반환한다. 메타정보에 마지막으로 필요한 것은 Author인데 이 것은 전역 변수 하나로 설정해서 사용한다:

	$author = 'Scott Chacon <schacon@example.com>'

이제 Importer에서 출력할 커밋 데이터는 다 준비했다. 이제 출력해보자. 사용할 브랜치, 해당 커밋과 관련된 Mark, 커미터 정보, 커밋 메시지, 이전 커밋를 출력한다. 코드로 만들면 다음과 같다:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

우선 시간대(-0700) 정보는 편의상 하드코딩 처리했다. 각자의 시간대에 맞는 오프셋을 설정해야 한다. 커밋 메시지는 다음과 같은 형식을 따라야 한다:

	data (size)\n(contents)

이 형식은 'data'라는 단어, 읽을 데이터의 크기, 줄바꿈 문자, 실 데이터로 구성된다. 이 형식을 여러 곳에서 사용해야 하므로 `export_data`라는 메소드로 만들어 놓는게 좋다:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

이제 남은 것은 Snapshot에 파일 내용를 포함시키는 것 뿐이다. 디렉토리로 구분돼 있기 때문에 어렵지 않다. 우선 `deleteall` 이라는 명령을 출력하고 그 뒤에 모든 파일의 내용을 출력한다. 그런면 Git은 Snapshot을 잘 저장할 것이다:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

중요:	대부분의 VCS는 리비전을 커밋간의 변화로 생각하기 때문에 `fast-import`는 추가/삭제/변경된 부분만 입력받을 수도 있다. Snapshot 사이의 차이점밖에 출력할 수 없는 상황이라면 훨씬 어렵다. 줄 수 있는 데이터는 전부 Git에 줘서 Git이 계산하게 해야 한다. 꼭 이렇게 해야 한다면 어떻게 데이터를 전달해야 하는지 `fast-import`의 ManPage를 참고하라.

파일 정보와 내용은 다음과 같이 출력한다:

	M 644 inline path/to/file
	data (size)
	(file contents)

644는 파일의 모드를 나타낸다(실행파일이라면 755로 지정해줘야 한다). `inline`은 다음 줄 부터는 파일 내용이라는 말하는 것이다. `inline_data` 메소드는 다음과 같다:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

파일 내용은 커밋 메시지랑 같은 방법을 사용하기 때문에 앞서 만들어 놓은 `export_data` 메소드를 다시 이용할 수 있다.

마지막으로 다음 커밋에 사용할 현 Mark 값을 반환한다:

	return mark

중요: Windows 에서 실행할 때는 추가 작업이 하나 더 필요하다. 앞에서 얘기했지만 Windows는 CRLF를 사용하지만 `git fast-import`는 LF를 사용한다. 이 문제를 해결 하려면 Ruby가 CRLF 대신 LF를 사용하도록 알려 줘야 한다:

	$stdout.binmode

모든게 끝났다. 스크립트를 실행하면 다음과 같은 출력 내용을 볼 수 있다:

	$ ruby import.rb /opt/import_from 
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

디렉토리를 하나 만들고 `git init` 명령을 실행해서 옮길 Git 프로젝트를 만든다. 그리고 그 프로젝트 디렉토리로 이동해서 `git fast-import` 명령의 표준입력으로 이 명령의 표준출력을 연결한다(pipe). 

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

여기서 보여주는 것처럼 성공적으로 끝나면 어떻게 됐는지 통계를 보여준다. 이 경우엔 브랜치 1개와 커밋 5개 그리고 개체 18개가 임포트됐다. `git log` 명령으로 히스토리를 조회할 수 있다:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

이 시점에서는 아무것도 Checkout 하지 않았기 때문에 Working Directory에 아직 아무 파일도 없다. `master` 브랜치를 Reset해서 파일을 Checkout한다:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

`fast-import` 명령으로 할 수 있는 일은 훨씬 더 많다. 모드를 설정하하고, 바이너리 데이터를 다루고, 브랜치를 여러개 다루고, Merge 시킬 수 도 있고, Tag를 달 수 도, 진행상황을 보여 주고, 등등 무수히 많은 일을 할 수 있다. Git 소스의 `contrib/fast-import` 디렉토리에 훨씬 복잡한 상황을 다루는 예제가 많다. 그 중 `git-p4` 스크립트가 좋은 예제이다.

## 요약 ##

Subversion 프로젝트에서 Git을 사용하거나, 다른 VCS 저장소를 Git 저장소로 손실 없이 옮기는 방법에 대해 알아 봤다. 다음장에서는 Git 내부를 까볼 것이다. 필요하다면 바이트 하나하나 다룰 수 있는 수준이 될 것이다.
