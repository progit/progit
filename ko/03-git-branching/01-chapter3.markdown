# Git 브랜치 #

모든 버전 관리 시스템은 브랜치를 지원한다. 개발을 하다 보면 코드를 여러 개로 복사해야 하는 일이 자주 생긴다. 코드를 통째로 복사하고 나서 원래 코드와는 상관없이 독립적으로 개발을 진행할 수 있는데, 이렇게 독립적으로 개발하는 것이 브랜치다.

버전 관리 시스템에서 브랜치를 만드는 과정은 고생스럽다. 개발자가 수동으로 소스코드 디렉토리를 복사해서 브랜치를 만들어야 하고 소스코드의 양이 많으면 브랜치를 만드는 시간도 오래 걸린다.

사람들은 브랜치 모델이 Git의 최고의 장점이라고, Git이 다른 것들과 구분되는 특징이라고 말한다. 당최 어떤 점이 그렇게 특별한 것일까? Git의 브랜치는 매우 가볍다. 순식간에 브랜치를 새로 만들고 브랜치 사이를 이동할 수 있다. 다른 버전 관리 시스템과는 달리 Git은 브랜치를 만들어 작업하고 나중에 Merge하는 방법을 권장한다. 심지어 하루에 수십 번씩해도 괜찮다. Git 브랜치에 능숙해지면 개발 방식이 완전히 바뀌고 다른 도구를 사용할 수 없게 된다.

## 브랜치란 무엇인가? ##

Git이 브랜치하는 과정을 이해하려면 우선 Git이 데이터를 어떻게 저장하는지 알아야 한다. Git은 데이터를 `Change Set`이나 변경사항(Diff)으로 기록하지 않고 일련의 스냅샷으로 기록한다는 것을 *1장*에서 보여줬다.

커밋하면 Git은 현 Staging Area에 있는 데이터의 스냅샷에 대한 포인터, 저자나 커밋 메시지 같은 메타데이터, 이전 커밋에 대한 포인터 등을 포함하는 커밋 개체(커밋 Object)를 저장한다. 이전 커밋 포인터가 있어서 현재 커밋이 무엇을 기준으로 바뀌었는지를 알 수 있다. 최초 커밋을 제외한 나머지 커밋은 이전 커밋 포인터가 적어도 하나씩 있고 브랜치를 합친 Merge 커밋 같은 경우에는 이전 커밋 포인터가 여러 개 있다.

예제를 보자. 파일이 3개 있는 디렉토리가 하나 있고 이 파일을 Staging Area에 저장하고 커밋해 보자. 파일을 Stage하면 Git 저장소에 파일을 저장하고(Git은 이것을 Blob이라고 부른다) Staging Area에 해당 파일의 체크섬을 저장한다(*1장*에서 살펴본 SHA-1을 사용한다).

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

'git commit'으로 커밋하면 먼저 루트 디렉토리와 각 하위 디렉토리의 트리 개체를 체크섬과 함께 저장소에 저장한다. 그다음에 커밋 개체를 만들고 메타데이터와 루트 디렉토리 트리 개체를 가리키는 포인터 정보를 커밋 개체에 넣어 저장한다. 그래서 필요하면 언제든지 스냅샷을 다시 만들 수 있다.

이 작업을 마치고 나면 Git 저장소에는 다섯 개의 데이터 개체가 생긴다. 각 파일에 대한 Blob 세 개, 파일과 디렉토리 구조가 들어 있는 트리 개체 하나, 메타데이터와 루트 트리를 가리키는 포인터가 담긴 커밋 개체 하나이다. 이것을 그림으로 그리면 그림 3-1과 같다.

Insert 18333fig0301.png
그림 3-1. 저장소의 커밋 데이터

다시 파일을 수정하고 커밋하면 이전 커밋이 무엇인지도 저장한다. 커밋을 두 번 더 하면 그림 3-2과 같이 저장된다.

Insert 18333fig0302.png
그림 3-2. Git 커밋의 개체 데이터

Git의 브랜치는 커밋 사이를 가볍게 이동할 수 있는 어떤 포인터 같은 것이다. 기본적으로 Git은 `master` 브랜치를 만든다. 최초로 커밋하면 Git은 master라는 이름의 브랜치를 만들어서 자동으로 가장 마지막 커밋을 가리키게 한다.

Insert 18333fig0303.png
그림 3-3. 가장 최근 커밋 정보를 가리키는 브랜치

브랜치를 하나 새로 만들면 어떨까? 브랜치를 하나 만들어서 놀자. 다음과 같이 `git branch` 명령으로 testing 브랜치를 만든다.

	$ git branch testing

새로 만든 브랜치도 지금 작업하고 있던 마지막 커밋을 가리킨다(그림 3-4).

Insert 18333fig0304.png
그림 3-4. 커밋 개체를 가리키는 두 브랜치

지금 작업 중인 브랜치가 무엇인지 Git은 어떻게 파악할까? 다른 버전 관리 시스템과는 달리 Git은 'HEAD'라는 특수한 포인터가 있다. 이 포인터는 지금 작업하는 로컬 브랜치를 가리킨다. 브랜치를 새로 만들었지만, Git은 아직 master 브랜치를 가리키고 있다. `git branch` 명령은 브랜치를 만들기만 하고 브랜치를 옮기지 않는다.

Insert 18333fig0305.png
그림 3-5. HEAD는 현재 작업 중인 브랜치를 가리킴

`git checkout` 명령으로 새로 만든 브랜치로 이동할 수 있다. testing 브랜치로 이동하려면 다음과 같이 한다:

	$ git checkout testing

이렇게 하면 HEAD는 testing 브랜치를 가리킨다.

Insert 18333fig0306.png
그림 3-6. HEAD는 옮겨간 다른 브랜치를 가리킨다

자, 이제 핵심이 보일 거다! 커밋을 새로 한 번 해보면:

	$ vim test.rb
	$ git commit -a -m 'made a change'

결과는 그림 3-7과 같다.

Insert 18333fig0307.png
그림 3-7. HEAD가 가리키는 testing 브랜치가 새 커밋을 가리킨다

이 부분이 흥미롭다. 새로 커밋해서 testing 브랜치는 앞으로 이동했다. 하지만, `master` 브랜치는 여전히 이전 커밋을 가리킨다. `master` 브랜치로 되돌아가면:

	$ git checkout master

결과는 그림 3-8과 같다.

Insert 18333fig0308.png
그림 3-8. HEAD가 Checkout한 브랜치로 이동함

방금 실행한 명령이 한 일은 두 가지다. master 브랜치가 가리키는 커밋을 HEAD가 가리키게 하고 워킹 디렉토리의 파일도 그 시점으로 되돌려 놓았다. 앞으로 커밋을 하면 다른 브랜치의 작업들과 별개로 진행되기 때문에 testing 브랜치에서 임시로 작업하고 원래 master 브랜치로 돌아와서 하던 일을 계속할 수 있다.

파일을 수정하고 다시 커밋을 해보자:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

프로젝트 히스토리는 분리돼 진행한다(그림 3-9). 우리는 브랜치를 하나 만들어 그 브랜치에서 일을 좀 하고, 다시 원래 브랜치로 되돌아와서 다른 일을 했다. 두 작업 내용은 서로 독립적으로 각 브랜치에 존재한다. 커밋 사이를 자유롭게 이동하다가 때가 되면 두 브랜치를 Merge한다. 간단히 `branch`와 `checkout` 명령을 써서 말이다.

Insert 18333fig0309.png
그림 3-9. 브랜치 히스토리가 서로 독립적임

실제로 Git의 브랜치는 어떤 한 커밋을 가리키는 40글자의 SHA-1 체크섬 파일에 불과하기 때문에 만들기도 쉽고 지우기도 쉽다. 새로 브랜치를 하나 만드는 것은 41바이트 크기의 파일을(40자와 줄 바꿈 문자) 하나 만드는 것에 불과하다.

브랜치를 만들어야 하면 프로젝트를 통째로 복사해야 하는 다른 버전 관리 도구와 Git의 차이는 극명하다. 통째로 복사하는 작업은 프로젝트 크기에 따라 다르겠지만 수십 초에서 수십 분까지 걸린다. 그에 비해 Git은 순식간이다. 게다가 커밋을 할 때마다 이전 커밋의 정보를 저장하기 때문에 Merge할 때 어디서부터(Merge Base) 합쳐야 하는지 안다. 이런 특징은 개발자들이 수시로 브랜치를 만들어 사용하게 한다.

이제 왜 그렇게 브랜치를 수시로 만들고 사용해야 하는지 알아보자.

## 브랜치와 Merge의 기초 ##

실제 개발과정에서 겪을 만한 예제를 하나 살펴보자. 브랜치와 Merge는 보통 이런 식으로 진행한다:

1. 작업 중인 웹사이트가 있다.
2. 새로운 이슈를 처리할 새 Branch를 하나 생성.
3. 새로 만든 Branch에서 작업 중.

이때 중요한 문제가 생겨서 그것을 해결하는 Hotfix를 먼저 만들어야 한다. 그러면 다음과 같이 할 수 있다:

1. 새로운 이슈를 처리하기 이전의 운영(Production) 브랜치로 이동.
2. Hotfix 브랜치를 새로 하나 생성.
3. 수정한 Hotfix 테스트를 마치고 운영 브랜치로 Merge.
4. 다시 작업하던 브랜치로 옮겨가서 하던 일 진행.

### 브랜치의 기초 ###

먼저 커밋을 몇 번 했다고 가정하자.

Insert 18333fig0310.png
그림 3-10. 현재 커밋 히스토리

이슈 관리 시스템에 등록된 53번 이슈를 처리한다고 하면 이 이슈에 집중할 수 있는 브랜치를 새로 하나 만든다. Git은 어떤 이슈 관리 시스템에도 종속돼 있지 않다. 브랜치를 만들면서 Checkout까지 한 번에 하려면 `git checkout` 명령에 `-b`라는 옵션을 준다.

	$ git checkout -b iss53
	Switched to a new branch 'iss53'

위 명령은 아래 명령을 줄여놓은 것이다:

	$ git branch iss53
	$ git checkout iss53

그림 3-11은 위 명령의 결과를 나타낸다.

Insert 18333fig0311.png
그림 3-11. 브랜치 포인터를 새로 만듦

iss53 브랜치를 Checkout했기 때문에(즉, HEAD는 iss53 브랜치를 가리킨다) 뭔가 일을 하고 커밋하면 iss53 브랜치가 앞으로 진행한다:

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png
그림 3-12. 진행 중인 iss53 브랜치

다른 상황을 가정해보자. 만드는 사이트에 문제가 생겨서 즉시 고쳐야 한다. 버그를 해결한 Hotfix에 'iss53'이 섞이는 것을 방지하기 위해 'iss53'와 관련된 코드를 어딘가에 저장해두고 원래 운영 환경의 소스로 복구해야 한다. Git을 사용하면 이런 노력을 들일 필요 없이 그냥 master 브랜치로 옮기면 된다.

그렇지만, 브랜치를 이동하려면 해야 할 일이 있다. 아직 커밋하지 않은 파일이 Checkout할 브랜치와 충돌 나면 브랜치를 변경할 수 없다. 브랜치를 변경할 때에는 워킹 디렉토리를 정리하는 것이 좋다. 이런 문제를 다루는 방법은(주로, Stash이나 커밋 Amend에 대해) 나중에 다룰 것이다. 지금은 작업하던 것을 모두 커밋하고 master 브랜치로 옮긴다:

	$ git checkout master
	Switched to branch 'master'

이때 워킹 디렉토리는 53번 이슈를 시작하기 이전 모습으로 되돌려지기 때문에 새로운 문제에 집중할 수 있는 환경이 만들어진다. Git은 자동으로 워킹 디렉토리에 파일들을 추가하고, 지우고, 수정해서 Checkout한 브랜치의 스냅샷으로 되돌려 놓는다는 것을 기억해야 한다.

hotfix라는 브랜치를 만들고 새로운 이슈를 해결할 때까지 사용한다:

	$ git checkout -b hotfix
	Switched to a new branch 'hotfix'
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix 3a0874c] fixed the broken email address
	 1 files changed, 1 deletion(-)

Insert 18333fig0313.png
그림 3-13. master 브랜치에서 갈라져 나온 hotfix 브랜치

운영 환경에 적용하려면 문제를 제대로 고쳤는지 테스트하고 master 브랜치에 합쳐야 한다. `git merge` 명령으로 다음과 같이 한다:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast-forward
	 README | 1 -
	 1 file changed, 1 deletion(-)

Merge 메시지에서 'Fast-forward'가 보이는가? Merge할 브랜치가 가리키고 있던 커밋이 현 브랜치가 가리키는 것보다 '앞으로 진행한' 커밋이기 때문에 master 브랜치 포인터는 최신 커밋으로 이동한다. 이런 Merge 방식을 'Fast forward'라고 부른다. 다시 말해서 A 브랜치에서 다른 B 브랜치를 Merge할 때 B가 A 이후의 커밋을 가리키고 있으면 그저 A가 B의 커밋을 가리키게 할 뿐이다.

이제 hotfix는 master 브랜치에 포함됐고 운영환경에 적용할 수 있다(그림 3-14).

Insert 18333fig0314.png
그림 3-14. Merge 후 hotfix 브랜치와 같은 것을 가리키는 master 브랜치

문제를 급히 해결하고 master 브랜치에 적용하고 나면 다시 일하던 브랜치로 돌아가야 한다. 하지만, 그전에 필요없는 hotfix 브랜치를 삭제한다. `git branch` 명령에 `-d` 옵션을 주고 브랜치를 삭제한다.

	$ git branch -d hotfix
	Deleted branch hotfix (was 3a0874c).

자 이제 이슈 53번을 처리하던 환경으로 되돌아가서 하던 일을 계속 하자(그림 3-15):

	$ git checkout iss53
	Switched to branch 'iss53'
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53 ad82d7a] finished the new footer [issue 53]
	 1 file changed, 1 insertion(+)

Insert 18333fig0315.png
그림 3-15. master와 별개로 진행하는 iss53 브랜치

위에서 작업한 hotfix가 iss53 브랜치에 영향을 끼치지 않는다는 점을 이해하는 것이 중요하다. `git merge master` 명령으로 master 브랜치를 iss53 브랜치에 Merge하면 iss53 브랜치에 hotfix가 적용된다. 아니면 iss53 브랜치가 master에 Merge할 수 있는 수준이 될 때까지 기다렸다가 Merge하면 hotfix와 iss53가 합쳐진다.

### Merge의 기초 ###

53번 이슈를 다 구현하고 master 브랜치에 Merge하는 과정을 살펴보자. master 브랜치에 Merge하는 것은 앞서 살펴본 hotfix 브랜치를 Merge하는 것과 비슷하다. `git merge` 명령으로 합칠 브랜치에서 합쳐질 브랜치를 Merge하면 된다:

	$ git checkout master
	$ git merge iss53
	Auto-merging README
	Merge made by the 'recursive' strategy.
	 README | 1 +
	 1 file changed, 1 insertion(+)

hotfix를 Merge했을 때와 메시지가 다르다. 현 브랜치가 가리키는 커밋이 Merge할 브랜치의 조상이 아니므로 Git은 'Fast-forward'로 Merge하지 않는다. 이러면 Git은 각 브랜치가 가리키는 커밋 두 개와 공통 조상 하나를 사용하여 3-way Merge를 한다. 그림 3-16에 이 Merge에서 사용하는 커밋 세 개가 표시된다.

Insert 18333fig0316.png
그림 3-16. Git은 Merge에 필요한 공통 커밋을 자동으로 찾음

단순히 브랜치 포인터를 최신 커밋으로 옮기는 게 아니라 3-way Merge의 결과를 별도의 커밋으로 만들고 나서 해당 브랜치가 그 커밋을 가리키도록 이동시킨다(그림 3-17). 그래서 이런 커밋은 부모가 여러 개고 Merge 커밋이라고 부른다.

Git은 Merge하는데 필요한 최적의 공통 조상을 자동으로 찾는다. 이런 기능도 Git이 다른 버전 관리 시스템보다 나은 점이다. CVS나 Subversion 같은 버전 관리 시스템은 개발자가 직접 공통 조상을 찾아서 Merge해야 한다. Git은 다른 시스템보다 Merge가 대단히 쉽다.

Insert 18333fig0317.png
그림 3-17. Git은 Merge할 때 Merge에 대한 정보가 들어 있는 커밋를 하나 만든다.

iss53 브랜치를 master에 Merge하고 나면 더는 iss53 브랜치가 필요 없다. 다음 명령으로 브랜치를 삭제하고 이슈의 상태를 처리 완료로 표시한다:

	$ git branch -d iss53

### 충돌의 기초 ###

가끔씩 3-way Merge가 실패할 때도 있다. Merge하는 두 브랜치에서 같은 파일의 한 부분을 동시에 수정하고 Merge하면 Git은 해당 부분을 Merge하지 못한다. 예를 들어, 53번 이슈와 hotfix가 같은 부분을 수정했다면 Git은 Merge하지 못하고 다음과 같은 충돌(Conflict) 메시지를 출력한다:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git은 자동으로 Merge하지 못해서 새 커밋이 생기지 않는다. 변경사항의 충돌을 개발자가 해결하지 않는 한 Merge 과정을 진행할 수 없다. Merge 충돌이 일어났을 때 Git이 어떤 파일을 Merge할 수 없었는지 살펴보려면 `git status` 명령을 이용한다:

	$ git status
	On branch master
	You have unmerged paths.
	  (fix conflicts and run "git commit")
	
	Unmerged paths:
	  (use "git add <file>..." to mark resolution)
	
	        both modified:      index.html
	
	no changes added to commit (use "git add" and/or "git commit -a")

충돌이 일어난 파일은 unmerged 상태로 표시된다. Git은 충돌이 난 부분을 표준 형식에 따라 표시해준다. 그러면 개발자는 해당 부분을 수동으로 해결한다. 충돌 난 부분은 다음과 같이 표시된다.

	<<<<<<< HEAD
	<div id='footer'>contact : email.support@github.com</div>
	=======
	<div id='footer'>
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53

`=======` 위쪽의 내용은 HEAD 버전(merge 명령을 실행할 때 작업하던 master 브랜치)의 내용이고 아래쪽은 iss53 브랜치의 내용이다. 충돌을 해결하려면 위쪽이나 아래쪽 내용 중에서 고르거나 새로 작성하여 Merge한다. 다음은 아예 새로 작성하여 충돌을 해결하는 예제다:

	<div id='footer'>
	please contact us at email.support@github.com
	</div>

충돌한 양쪽에서 조금씩 가져와서 새로 수정했다. 그리고 `<<<<<<<`, `=======`, `>>>>>>>` 가 포함된 행을 삭제하였다. 이렇게 충돌한 부분을 해결하고 `git add` 명령으로 다시 Git에 저장한다. 충돌을 쉽게 해결하기 위해 다른 Merge 도구도 이용할 수 있다. `git mergetool` 명령으로 실행한다:

	$ git mergetool

	This message is displayed because 'merge.tool' is not configured.
	See 'git mergetool --tool-help' or 'git help config' for more details.
	'git mergetool' will now attempt to use one of the following tools:
	opendiff kdiff3 tkdiff xxdiff meld tortoisemerge gvimdiff diffuse diffmerge ecmerge p4merge araxis bc3 codecompare vimdiff emerge
	Merging:
	index.html

	Normal merge conflict for 'index.html':
	  {local}: modified file
	  {remote}: modified file
	Hit return to start merge resolution tool (opendiff):

Mac에서는 `opendiff`가 실행된다. 기본 도구 말고 사용할 수 있는 다른 Merge 도구도 있는데, "... one of the following tools:" 부분에 보여준다. 여기에 표시된 도구 중 하나를 고를 수 있다. Merge 도구를 변경하는 방법은 *7장*에서 다룬다.

Merge 도구를 종료하면 Git은 잘 Merge했는지 물어본다. 잘 마쳤다고 입력하면 자동으로 `git add`가 수행되고 해당 파일이 Staging Area에 저장된다.

`git status` 명령으로 충돌이 해결된 상태인지 다시 한번 확인해볼 수 있다.

	$ git status
	On branch master
	Changes to be committed:
	  (use 'git reset HEAD <file>...' to unstage)
	
	        modified:   index.html
	

충돌을 해결하고 나서 해당 파일이 Staging Area에 저장됐는지 확인했으면 `git commit` 명령으로 Merge 한 것을 커밋한다. 충돌을 해결하고 Merge할 때에는 커밋 메시지가 아래와 같다.

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a merge.
	# If this is not correct, please remove the file
	#       .git/MERGE_HEAD
	# and try again.
	#

어떻게 충돌을 해결했고 좀 더 확인해야 하는 부분은 무엇을 어떻게 했는지 자세하게 기록한다. 자세한 기록은 나중에 이 Merge 커밋을 이해하는데 도움을 줄 것이다.

## 브랜치 관리 ##

지금까지 브랜치를 만들고, Merge하고, 삭제하는 방법에 대해서 살펴봤다. 브랜치를 관리하는 데 필요한 다른 명령도 살펴보자.

`git branch` 명령은 단순히 브랜치를 만들고 삭제해 주기만 하는 것이 아니다. 아무런 옵션 없이 실행하면 브랜치의 목록을 보여준다:

	$ git branch
	  iss53
	* master
	  testing

`*` 기호가 붙어 있는 master브랜치는 현재 Checkout해서 작업하는 브랜치를 나타낸다. 즉, 지금 수정한 내용을 커밋하면 master 브랜치에 커밋되고 포인터가 앞으로 한 단계 나아간다. `git branch -v` 명령을 실행하면 브랜치마다 마지막 커밋 메시지도 함께 보여준다:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

각 브랜치가 지금 어떤 상태인지 확인하기에 좋은 옵션도 있다. 현재 Checkout한 브랜치를 기준으로 Merge된 브랜치인지 그렇지 않은지 필터링해 볼 수 있다. `--merged`와 `--no-merged` 옵션을 사용하여 해당 목록을 볼 수 있다. `git branch --merged` 명령으로 이미 Merge한 브랜치 목록을 확인한다:

	$ git branch --merged
	  iss53
	* master

iss53 브랜치는 앞에서 이미 Merge했기 때문에 목록에 나타난다. `*` 기호가 붙어 있지 않은 브랜치는 `git branch -d` 명령으로 삭제해도 되는 브랜치다. 이미 다른 브랜치와 Merge 했기 때문에 삭제해도 정보를 잃지 않는다.

반대로 현재 Checkout한 브랜치에 Merge하지 않은 브랜치를 살펴보려면 `git branch --no-merged` 명령을 사용한다:

	$ git branch --no-merged
	  testing

위에는 없었던 다른 브랜치가 보인다. 아직 Merge하지 않은 커밋을 담고 있기 때문에 `git branch -d` 명령으로 삭제되지 않는다:

	$ git branch -d testing
	error: The branch 'testing' is not fully merged.
	If you are sure you want to delete it, run 'git branch -D testing'.

Merge하지 않은 브랜치를 강제로 삭제하려면 `-D` 옵션으로 삭제한다.

## 브랜치 Workflow ##

브랜치를 만들고 Merge하는 것을 어디에 써먹어야 할까? 이 절에서는 Git의 브랜치가 유용한 몇 가지 Workflow를 살펴본다. 여기서 설명하는 Workflow를 개발에 적용하면 도움이 될 것이다.

### Long-Running 브랜치 ###

Git은 꼼꼼하게 3-way Merge를 사용하기 때문에 장기간에 걸쳐서 한 브랜치를 다른 브랜치와 여러 번 Merge하는 것도 어렵지 않다. 그래서 개발 과정에서 필요한 용도에 따라 브랜치를 만들어 두고 계속 사용할 수 있다. 그리고 정기적으로 브랜치를 다른 브랜치로 Merge한다:

이런 접근법에 따라서 Git 개발자가 많이 선호하는 Workflow가 하나 있다. 배포했거나 배포할 코드만 master 브랜치에 Merge해서 안정 버전의 코드만 master 브랜치에 둔다. 개발을 진행하고 안정화하는 브랜치는 develop이나 next라는 이름으로 추가로 만들어 사용한다. 이 브랜치는 언젠가 안정 상태가 되겠지만, 항상 안정 상태를 유지해야 하는 것이 아니다. 테스트를 거쳐서 안정적이라고 판단되면 master 브랜치에 Merge한다. 토픽 브랜치(앞서 살펴본 iss53 브랜치 같은 짧은 호흡 브랜치)에도 적용할 수 있는데, 해당 토픽을 처리하고 테스트해서 버그도 없고 안정적이면 그때 Merge한다.

사실 우리가 얘기하는 것은 커밋을 가리키는 포인터에 대한 얘기다. 개발 브랜치는 공격적으로 히스토리를 만들어 나아가고 안정 브랜치는 이미 만든 히스토리를 뒤따르며 나아간다.

Insert 18333fig0318.png
그림 3-18. 안정적인 브랜치일수록 커밋 히스토리가 뒤쳐진다

실험실에서 충분히 테스트하고 실전에 배치하는 과정으로 보면 이해하기 쉽다(그림 3-19).

Insert 18333fig0319.png
그림 3-19. 각 브랜치를 하나의 실험실로 생각하라

코드를 여러 단계로 나누어 안정성을 높여가며 운영할 수 있다. 큰 규모의 프로젝트라면 proposed 혹은 pu(proposed updates)라는 이름의 브랜치를 두어 next나 master 브랜치에 아직 Merge할 준비가 되지 않은 것을 일단 Merge시킨다.

중요한 개념은 브랜치를 이용해 여러 단계에 걸쳐서 안정화해 나아가면서 충분히 안정화가 됐을 때 안정 브랜치로 Merge한다는 점이다. 다시 말해서 반드시 Long-Running의 브랜치를 여러 개 만들어야 하는 것은 아니지만 정말 유용하다. 특히 규모가 크고 복잡한 프로젝트일수록 그 유용성이 반짝반짝 빛난다.

### 토픽 브랜치 ###

토픽 브랜치는 프로젝트 크기에 상관없이 유용하다. 토픽 브랜치는 어떤 한 가지 주제나 작업을 위해 만든 짧은 호흡의 브랜치다. 다른 버전 관리 시스템에서 이런 브랜치를 본 적이 없을 것이다. Git이 아닌 다른 버전 관리 도구에서는 브랜치를 하나 만드는 데 큰 비용이 든다. Git에서는 매우 일상적으로 브랜치를 만들고 Merge하고 삭제한다.

앞서 사용한 iss53이나 hotfix 브랜치가 토픽 브랜치다. 우리는 브랜치를 새로 만들고 어느 정도 커밋하고 나서 다시 master 브랜치에 Merge하고 브랜치 삭제도 해 보았다. 보통 주제별로 브랜치를 만들고 각각은 독립돼 있기 때문에 매우 쉽게 컨텍스트 사이를 옮겨 다닐 수 있다. 묶음별로 나눠서 일하면 내용별로 검토하기에도, 테스트하기에도 더 편하다. 각 작업을 하루든 한 달이든 유지하다가 master 브랜치에 Merge할 시점이 되면 순서에 관계없이 그때 Merge하면 된다.

master 브랜치를 checkout한 상태에서 어떤 작업을 한다고 해보자. 한 이슈를 처리하기 위해서 iss91라는 브랜치를 만들고 해당 작업을 한다. 같은 이슈를 다른 방법으로 해결해보고 싶을 때도 있다. iss91v2라는 브랜치를 만들고 다른 방법을 시도해 본다. 확신할 수 없는 아이디어를 적용해보기 위해 다시 master 브랜치로 되돌아가서 dumbidea 브랜치를 하나 더 만든다. 지금까지 말했던 커밋 히스토리는 그림 3-20과 같다.

Insert 18333fig0320.png
그림 3-20. 여러 토픽 브랜치에 대한 커밋 히스토리

이슈를 처리했던 방법 중 두 번째 방법인 iss91v2 브랜치가 괜찮아서 적용하기로 결정을 내렸다. 그리고 아이디어를 확신할 수 없었던 dumbidea 브랜치를 같이 일하는 다른 개발자에게 보여줬더니 썩 괜찮다는 반응을 얻었다. iss91 브랜치는 (C5, C6 커밋도 함께) 버리고 다른 두 브랜치를 Merge하면 그림 3-21과 같이 된다.

Insert 18333fig0321.png
그림 3-21. dumbidea와 iss91v2 브랜치를 Merge하고 난 후의 모습

지금까지 한 작업은 전부 로컬에서만 처리한다는 것을 꼭 기억하자. 로컬 저장소에서만 브랜치를 만들고 Merge했으며 서버와 통신을 주고받는 일은 없었다.

## 리모트 브랜치 ##

리모트 브랜치란 리모트 저장소에 있는 브랜치를 말한다. 사실 리모트 브랜치도 로컬에 있지만 멋대로 옮기거나 할 수 없고 리모트 저장소와 통신하면 자동으로 업데이트된다. 리모트 브랜치는 브랜치 상태를 알려주는 책갈피라고 볼 수 있다. 이 책갈피로 리모트 저장소에서 마지막으로 데이터를 가져온 시점의 상태를 알 수 있다.

리모트 브랜치의 이름은 (remote)/(branch) 형식으로 되어 있다. 예를 들어 리모트 저장소 origin의 master 브랜치를 보고 싶다면 origin/master라는 이름으로 브랜치를 확인하면 된다. 다른 팀원과 함께 어떤 이슈를 구현할 때 그 팀원이 iss53 브랜치를 서버로 Push했고 당신도 로컬에 iss53 브랜치가 있다고 가정하자. 이때 서버가 가리키는 iss53 브랜치는 로컬에서 origin/iss53이 가리키는 커밋이다.

다소 헷갈릴 수 있으니 예제를 좀 더 살펴보자. `git.ourcompany.com`이라는 Git 서버가 있고 이 서버의 저장소를 하나 Clone하면 Git은 자동으로 origin이라는 이름을 붙인다. origin으로부터 저장소 데이터를 모두 내려받고 master 브랜치를 가리키는 포인터를 만든다. 이 포인터는 origin/master라고 부르고 멋대로 조종할 수 없다. 그리고 Git은 로컬의 master 브랜치가 origin/master를 가리키게 한다. 이제 이 master 브랜치에서 작업을 시작할 수 있다.

Insert 18333fig0322.png
그림 3-22. 저장소를 Clone하면 로컬 master 브랜치, 리모트 저장소의 master 브랜치를 가리키는 origin/master 브랜치가 생김

로컬 저장소에서 어떤 작업을 하고 있는데 동시에 다른 팀원이 `git.ourcompany.com` 서버에 Push하고 master 브랜치를 업데이트한다. 그러면 이제 팀원 간의 히스토리는 서로 달라진다. 서버 저장소로부터 어떤 데이터도 주고받지 않아서 origin/master 포인터는 그대로다.

Insert 18333fig0323.png
그림 3-23. 로컬과 서버의 커밋 히스토리는 독립적임

리모트 서버로부터 저장소 정보를 동기화하려면 `git fetch origin` 명령을 사용한다. 명령을 실행하면 우선 origin 서버의 주소 정보(이 예에서는 `git.ourcompany.com`)를 찾아서, 현재 로컬의 저장소가 갖고 있지 않은 새로운 정보가 있으면 모두 내려받고, 받은 데이터를 로컬 저장소에 업데이트하고 나서, origin/master 포인터의 위치를 최신 커밋으로 이동시킨다.

Insert 18333fig0324.png
그림 3-24. Git의 Fetch 명령은 리모트 브랜치 정보를 업데이트한다

리모트 저장소를 여러 개 운영하는 상황을 이해할 수 있도록 개발용으로 사용할 Git 저장소를 팀 내부에 하나 추가해 보자.

이 저장소의 주소가 `git.team1.ourcompany.com` 이면 *2장*에서 살펴본 `git remote add` 명령으로 현재 작업 중인 프로젝트에 팀의 저장소를 추가한다. 이름을 teamone으로 짓고 긴 서버 주소 대신 사용한다.

Insert 18333fig0325.png
그림 3-25. 서버를 리모트 저장소로 추가하기

서버를 추가하고 나면 git fetch teamone 명령으로 teamone 서버의 데이터를 내려받는다. 명령을 실행해도 teamone 서버의 데이터는 모두 origin 서버에도 있는 것들이라서 아무것도 내려받지 않는다. 하지만, 이 명령은 teamone/master 브랜치가 teamone 서버의 master 브랜치가 가리키는 커밋을 가리키게 한다.

Insert 18333fig0326.png
그림 3-26. 로컬 저장소에 만들어진 teamone의 master 브랜치를 가리키는 포인터

### Push하기 ###

로컬의 브랜치를 서버로 전송하려면 쓰기 권한이 있는 리모트 저장소에 Push해야 한다. 로컬 저장소의 브랜치는 자동으로 리모트 저장소로 전송되지 않는다. 명시적으로 브랜치를 Push해야 정보가 전송된다. 따라서 리모트 저장소에 전송하지 않고 로컬 브랜치에만 두는 비공개 브랜치를 만들 수 있다. 또 다른 사람과 협업하기 위해 토픽 브랜치만 전송할 수도 있다.

serverfix라는 브랜치를 다른 사람과 공유할 때에도 브랜치를 처음 Push하는 것과 같은 방법으로 Push한다. 다음과 같이 `git push (remote) (branch)` 명령을 사용한다:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

이 메시지에는 숨겨진 내용이 많다.

Git은 serverfix라는 브랜치 이름을 `refs/heads/serverfix:refs/heads/serverfix`로 확장한다. 이것은 serverfix라는 로컬 브랜치를 서버로 Push하는데 리모트의 serverfix 브랜치로 업데이트한다는 것을 의미한다. 나중에 *9장*에서 `refs/heads/`의 뜻을 자세히 알아볼 것이기 때문에 일단 넘어가도록 한다. `git push origin serverfix:serverfix`라고 Push하는 것도 같은 의미인데 이것은 '로컬의 serverfix 브랜치를 리모트 저장소의 serverfix 브랜치로 Push하라'라는 뜻이다. 로컬 브랜치의 이름과 리모트 서버의 브랜치 이름이 다를 때 필요하다. 리모트 저장소에 serverfix라는 이름 대신 다른 이름을 사용하려면 `git push origin serverfix:awesomebranch`처럼 사용한다.

나중에 누군가 저장소를 Fetch하고 나서 서버에 있는 serverfix 브랜치에 접근할 때 origin/serverfix라는 이름으로 접근할 수 있다:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

여기서 짚고 넘어가야 할 게 있다. Fetch 명령으로 리모트 브랜치를 내려받는다고 해서 로컬 저장소에 수정할 수 있는 브랜치가 새로 생기는 것이 아니다. 다시 말해서 serverfix라는 브랜치가 생기는 것이 아니라 그저 수정 못 하는 origin/serverfix 브랜치 포인터가 생기는 것이다.

새로 받은 브랜치의 내용을 Merge하려면 `git merge origin/serverfix` 명령을 사용한다. Merge하지 않고 리모트 브랜치에서 시작하는 새 브랜치를 만들려면 아래와 같은 명령을 사용한다.

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

그러면 origin/serverfix에서 시작하고 수정할 수 있는 serverfix라는 로컬 브랜치가 만들어진다.

### 브랜치 추적 ###

리모트 브랜치를 로컬 브랜치로 Checkout하면 자동으로 트래킹(Tracking) 브랜치가 만들어진다. 트래킹 브랜치는 리모트 브랜치와 직접적인 연결고리가 있는 로컬 브랜치이다. 트래킹 브랜치에서 `git push` 명령을 내려도 Git은 연결고리가 있어서 어떤 리모트 저장소에 Push해야 하는지 알 수 있다. 또한 `git pull` 명령을 내리면 리모트 저장소로부터 데이터를 내려받아 연결된 리모트 브랜치와 자동으로 Merge한다.

서버로부터 저장소를 Clone해올 때도 Git은 자동으로 master 브랜치를 origin/master 브랜치의 트래킹 브랜치로 만든다. 그래서 `git push`, `git pull` 명령이 추가적인 아규먼트 없이도 동작한다. 트래킹 브랜치를 직접 만들 수 있는데 origin/master뿐만 아니라 다른 저장소의 다른 브랜치도 추적하게(Tracking) 할 수 있다. `git checkout -b [branch] [remotename]/[branch]` 명령으로 간단히 트래킹 브랜치를 만들 수 있다. Git 1.6.2 버전 이상을 사용하는 경우에는  --track 옵션도 사용할 수 있다.

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch serverfix from origin.
	Switched to a new branch 'serverfix'

리모트 브랜치와 다른 이름으로 브랜치를 만들려면 로컬 브랜치의 이름을 아래와 같이 다르게 지정한다:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch serverfix from origin.
	Switched to a new branch 'sf'

이제 `sf` 브랜치에서 Push나 Pull하면 자동으로 `origin/serverfix`에 데이터를 보내거나 가져온다.

### 리모트 브랜치 삭제 ###

동료와 협업하기 위해 리모트 브랜치를 만들었다가 작업을 마치고 master 브랜치로 Merge했다. 협업하는 데 사용했던 그 리모트 브랜치는 이제 안정화됐으므로 삭제할 수 있다. `git push [remotename] :[branch]`라고 실행해서 삭제할 수 있는데 이 명령은 좀 특이하게 생겼다. serverfix라는 리모트 브랜치를 삭제하려면 다음과 같이 실행한다:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

위 명령을 실행하고 나면 서버의 브랜치는 삭제된다. 이 명령을 잊어버릴 경우를 대비해서 페이지 귀퉁이를 접어놓고 필요할 때 펴보는 게 좋을지도 모르겠다. 이 명령은 앞서 살펴본 `git push [remotename] [localbranch]:[remotebranch]` 형식으로 기억하는 것이 좋다. `[localbranch]` 부분에 비워 둔 채로 실행하면 '로컬에서 빈 내용을 리모트의 `[remotebranch]`에 채워 넣어라' 라는 뜻이 되기 때문이다.

## Rebase하기 ##

Git에서 한 브랜치에서 다른 브랜치로 합치는 방법은 두 가지가 있다. 하나는 Merge이고 다른 하나는 Rebase다. 이 절에서는 Rebase가 무엇인지, 어떻게 사용하는지, 좋은 점은 뭐고, 어떤 상황에서 사용하고 어떤 상황에서 사용하지 말아야 하는지 알아 본다.

### Rebase의 기초 ###

앞의 Merge 절에서 살펴본 예제로 다시 돌아가 보자(그림 3-27). 두 개의 나누어진 브랜치의 모습을 볼 수 있다.

Insert 18333fig0327.png
그림 3-27. 두 개의 브랜치로 나누어진 커밋 히스토리

이 두 브랜치를 합치는 가장 쉬운 방법은 앞에서 살펴본 대로 Merge 명령을 사용하는 것이다. 두 브랜치의 마지막 커밋 두 개(C3, C4)와 공통 조상(C2)을 사용하는 3-way Merge로 그림 3-28처럼 새로운 커밋을 만들어 낸다.

Insert 18333fig0328.png
그림 3-28. 나뉜 브랜치를 Merge하기

비슷한 결과를 만드는 다른 방식으로, C3에서 변경된 사항을 패치(Patch)로 만들고 이를 다시 C4에 적용시키는 방법이 있다. Git에서는 이런 방식을 _Rebase_ 라고 한다. Rebase 명령으로 한 브랜치에서 변경된 사항을 다른 브랜치에 적용할 수 있다.

위의 예제는 다음과 같은 명령으로 Rebase한다:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

실제로 일어나는 일을 설명하자면 일단 두 브랜치가 나뉘기 전인 공통 커밋으로 이동하고 나서 그 커밋부터 지금 Checkout한 브랜치가 가리키는 커밋까지 diff를 차례로 만들어 어딘가에 임시로 저장해 놓는다. Rebase할 브랜치(역주 - experiment)가 합칠 브랜치(역주 - master)가 가리키는 커밋을 가리키게 하고 아까 저장해 놓았던 변경사항을 차례대로 적용한다. 그림 3-29는 이러한 과정을 나타내고 있다.

Insert 18333fig0329.png
그림 3-29. C3의 변경사항을 C4에 적용하는 Rebase 과정

그리고 나서 master 브랜치를 Fast-forward 시킨다.

Insert 18333fig0330.png
그림 3-30. master 브랜치를 Fast-forward시키기

C3'로 표시된 커밋에서의 내용은 Merge 예제에서 살펴본 C5 커밋에서의 내용과 같을 것이다. Merge이든 Rebase든 둘 다 합치는 관점에서는 서로 다를 게 없다. 하지만, Rebase가 좀 더 깨끗한 히스토리를 만든다. Rebase한 브랜치의 Log를 살펴보면 히스토리가 선형적이다. 일을 병렬로 동시에 진행해도 Rebase하고 나면 모든 작업이 차례대로 수행된 것처럼 보인다.

Rebase는 보통 리모트 브랜치에 커밋을 깔끔하게 적용하고 싶을 때 사용한다. 아마 이렇게 Rebase하는 리모트 브랜치는 직접 관리하는 것이 아니라 그냥 참여하는 브랜치일 것이다. 메인 프로젝트에 패치를 보낼 준비가 되면 하는 것이 Rebase이니까 브랜치에서 하던 일을 완전히 마치고 origin/master로 Rebase한다. 프로젝트 관리자는 어떠한 통합작업도 필요 없다. 그냥 master 브랜치를 Fast-forward 시키면 된다.

Rebase를 하든지, Merge를 하든지 최종 결과물은 같고 커밋 히스토리만 다르다는 것이 중요하다. Rebase의 경우는 브랜치의 변경사항을 순서대로 다른 브랜치에 적용하면서 합치고 Merge의 경우는 두 브랜치의 최종결과만을 가지고 합친다.

### 좀 더 Rebase ###

Rebase는 단순히 브랜치를 합치는 것만 아니라 다른 용도로도 사용할 수 있다. 그림 3-31과 같은 히스토리가 있다고 하자. server 브랜치를 만들어서 서버 기능을 추가하고 그 브랜치에서 다시 client 브랜치를 만들어 클라이언트 기능을 추가한다. 마지막으로 server 브랜치로 돌아가서 몇 가지 기능을 더 추가한다.

Insert 18333fig0331.png
그림 3-31. 다른 토픽 브랜치에서 갈라져 나온 토픽 브랜치

이때 테스트가 덜 된 server 브랜치는 그대로 두고 client 브랜치만 master로 합치려는 상황을 생각해보자. server와는 아무 관련이 없는 client 커밋은 C8, C9이다. 이 두 커밋을 master 브랜치에 적용하기 위해서 `--onto` 옵션을 사용하여 아래와 같은 명령을 실행한다:

	$ git rebase --onto master server client

이 명령은 client 브랜치를 Checkout하고 server와 client의 공통조상 이후의 패치를 만들어 master에 적용한다. 조금 복잡하긴 해도 꽤 쓸모 있다. 그림 3-32를 보자.

Insert 18333fig0332.png
그림 3-32. 다른 토픽 브랜치에서 갈라져 나온 토픽 브랜치를 Rebase하기

이제 master 브랜치로 돌아가서 Fast-forward 시킬 수 있다:

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
그림 3-33. master 브랜치를 client 브랜치 위치로 진행 시키기

server 브랜치의 일이 다 끝나면 `git rebase [basebranch] [topicbranch]`라는 명령으로 Checkout하지 않고 바로 server 브랜치를 master 브랜치로 rebase할 수 있다. 이 명령은 토픽(server) 브랜치를 Checkout하고 베이스(master) 브랜치에 Rebase한다:

	$ git rebase master server

server 브랜치의 수정사항을 master 브랜치에 적용했다. 그 결과는 그림 3-34와 같다.

Insert 18333fig0334.png
그림 3-34. master 브랜치에 server 브랜치의 수정 사항을 적용

그리고 나서 master 브랜치를 Fast-forward 시킨다:

	$ git checkout master
	$ git merge server

모든 것이 master 브랜치에 통합됐기 때문에 더 필요하지 않다면 client나 server 브랜치는 삭제해도 된다. 브랜치를 삭제해도 커밋 히스토리는 그림 3-35와 같이 여전히 남아 있다:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
그림 3-35. 최종 커밋 히스토리

### Rebase의 위험성 ###

Rebase가 장점이 많은 기능이지만 단점이 없는 것은 아니니 조심해야 한다. 그 주의사항은 다음 한 문장으로 표현할 수 있다:

**이미 공개 저장소에 Push한 커밋을 Rebase하지 마라**

이 지침만 지키면 Rebase를 하는 데 문제 될 게 없다. 하지만, 이 주의사항을 지키지 않으면 사람들에게 욕을 먹을 것이다(역주 - 아마도 가카의 호연지기가 필요해질 것이다).

Rebase는 기존의 커밋을 그대로 사용하는 것이 아니라 내용은 같지만 다른 커밋을 새로 만든다. 새 커밋을 서버에 Push하고 동료 중 누군가가 그 커밋을 Pull해서 작업을 한다고 하자. 그런데 그 커밋을 `git rebase`로 바꿔서 Push해버리면 동료가 다시 Push했을 때 동료는 다시 Merge해야 한다. 그리고 동료가 다시 Merge한 내용을 Pull하면 내 코드는 정말 엉망이 된다.

이미 공개 저장소에 Push한 커밋을 Rebase하면 어떤 결과가 초래되는지 예제를 통해 알아보자. 중앙 저장소에서 Clone하고 일부 수정을 하면 커밋 히스토리는 그림 3-36과 같아 진다.

Insert 18333fig0336.png
그림 3-36. 저장소를 Clone하고 일부 수정함

이제 팀원 중 누군가 커밋, Merge하고 나서 서버에 Push 한다. 이 리모트 브랜치를 Fetch, Merge하면 그림 3-37과 같이 된다.

Insert 18333fig0337.png
그림 3-37. Fetch한 후 Merge함

그런데 Push했던 팀원은 Merge한 일을 되돌리고 다시 Rebase한다. 서버의 히스토리를 새로 덮어씌우려면 `git push --force` 명령을 사용해야 한다. 이후에 저장소에서 Fetch하고 나면 아래 그림과 같은 상태가 된다:

Insert 18333fig0338.png
그림 3-38. 한 팀원이 다른 팀원이 의존하는 커밋을 없애고 Rebase한 커밋을 다시 Push함

기존 커밋이 사라졌기 때문에 이미 처리한 일이라고 해도 다시 Merge해야 한다. Rebase는 커밋의 SHA-1 해시를 바꾸기 때문에 Git은 새로운 커밋으로 생각한다. 사실 C4는 이미 히스토리에 적용되어 있지만, Git은 모른다.

Insert 18333fig0339.png
그림 3-39. 같은 Merge를 다시 한다

다른 개발자와 계속 같이 일하려면 이런 Merge도 해야만 한다. Merge하면 C4와 C4' 커밋 둘 다 히스토리에 남게 된다. 실제 내용과 메시지가 같지만 SHA-1 해시 값이 전혀 다르다. `git log`로 히스토리를 확인해보면 저자, 커밋 날짜, 메시지가 같은 커밋이 두 개 있을 것이다. 이렇게 되면 혼란스럽다. 게다가 이 히스토리를 서버에 Push하면 같은 커밋이 두 개 있기 때문에 다른 사람들도 혼란스러워한다.

Push하기 전에 정리하려고 Rebase하는 것은 괜찮다. 또 절대 공개하지 않고 혼자 Rebase하는 경우도 괜찮다. 하지만, 이미 공개하여 사람들이 사용하는 커밋을 Rebase하면 틀림없이 문제가 생길 것이다.

## 요약 ##

우리는 이 장에서 Git으로 브랜치를 만들고 Merge 기능의 기본적인 명령을 다루었다. 이제 브랜치를 만들고 옮겨다니고 Merge하는 것에 익숙해졌을 것으로 생각한다. 브랜치를 Push하여 공유하거나 Push하기 전에 브랜치를 Rebase하는 것 정도는 어렵지 않게 할 수 있을 것이다.
