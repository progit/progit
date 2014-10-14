# Git의 기초 #

Git을 사용하는 방법을 알고 싶은데 한 챕터밖에 읽을 시간이 없다면 2장을 읽어야 한다. Git에서 자주 사용하는 명령어는 모두 2장에 등장한다. 2장을 다 읽으면 저장소를 만들고 설정하는 방법, 파일을 추적하거나(Track) 추적을 그만두는 방법, 변경 내용을 Stage하고 커밋하는 방법을 알게 된다. 그리고 또 파일이나 파일 패턴을 무시하도록 Git을 설정하는 방법, 실수를 쉽고 빠르게 만회하는 방법, 프로젝트 히스토리를 조회하고 커밋을 비교하는 방법, 리모트 저장소에 Push하고 Pull하는 방법을 살펴본다.

## Git 저장소 만들기 ##

Git 저장소를 만드는 방법은 두 가지다. 기존 프로젝트를 Git 저장소로 만드는 방법이 있고 다른 서버에 있는 저장소를 Clone하는 방법이 있다.

### 기존 디렉토리를 Git 저장소로 만들기 ###

기존 프로젝트를 Git으로 관리하고 싶을 때, 프로젝트의 디렉토리로 이동해서 아래과 같은 명령을 실행한다.

	$ git init

이 명령은 `.git`이라는 하위 디렉토리를 만든다. `.git` 디렉토리에는 저장소에 필요한 뼈대 파일(Skeleton)이 들어 있다(`.git` 디렉토리가 막 만들어진 직후에 어떤 파일이 있는지에 대한 내용은 *9장*에서 다룬다). 이 명령만으로는 아직 프로젝트의 어떤 파일도 관리하지 않는다.

Git이 파일을 관리하게 하려면 저장소에 파일을 추가하고 커밋해야 한다. `git add` 명령으로 파일을 추가하고 커밋한다:

	$ git add *.c
	$ git add README
	$ git commit -m 'initial project version'

매우 짧은 시간에 명령어를 몇개 실행해서 Git 저장소를 만들고 파일이 관리되게 했다.

### 기존 저장소를 Clone하기 ###

다른 프로젝트에 참여하거나(Contribute) Git 저장소를 복사하고 싶을 때 `git clone` 명령을 사용한다. 이미 Subversion 같은 VCS에 익숙한 사용자에게는 `checkout`이 아니라 `clone`이라는 점이 도드라져 보일 것이다. Git이 Subversion과 다른 가장 큰 차이점은 서버에 있는 모든 데이터를 복사한다는 것이다. `git clone`을 실행하면 프로젝트 히스토리를 전부 받아온다. 실제로 서버의 디스크가 망가져도 클라이언트 저장소 중에서 아무거나 하나 가져다가 복구하면 된다(서버에만 적용했던 설정은 복구하지 못하지만 모든 데이터는 복구된다 - *4장*에서 좀 더 자세히 다룬다).

`git clone [url]` 명령으로 저장소를 Clone한다. Ruby용 Git 라이브러리인 Grit을 Clone하려면 아래과 같이 실행한다:

	$ git clone git://github.com/schacon/grit.git

이 명령은 "grit"이라는 디렉토리를 만들고 그 안에 `.git` 디렉토리를 만든다. 그리고 저장소의 데이터를 모두 가져와서 자동으로 가장 최신 버전을 Checkout해 놓는다. `grit` 디렉토리로 이동하면 Checkout으로 생성한 파일을 볼 수 있고 당장 하고자 하는 일을 시작할 수 있다. 아래과 같은 명령을 사용하여 저장소를 Clone하면 "grit"이 아니라 다른 디렉토리 이름으로 Clone할 수 있다:

	$ git clone git://github.com/schacon/grit.git mygrit

디렉토리 이름이 `mygrit`이라는 것만 빼면 이 명령의 결과와 앞선 명령의 결과는 같다.

Git은 다양한 프로토콜을 지원한다. 이제까지는 `git://` 프로토콜을 사용했지만 `http(s)://`를 사용할 수도 있고 `user@server:/path.git`처럼 SSH 프로토콜을 사용할 수도 있다. 자세한 내용은 *4장*에서 다룬다. *4장*에서는 각 프로토콜의 장단점과 Git 저장소에 접근하는 방법을 설명한다.

## 수정하고 저장소에 저장하기 ##

만질 수 있는 Git 저장소를 하나 만들었고 워킹 디렉토리에 Checkout도 했다. 이제는 파일을 수정하고 파일의 스냅샷을 커밋해 보자. 파일을 수정하다가 저장하고 싶으면 스냅샷을 커밋한다.

워킹 디렉토리의 모든 파일은 크게 *Tracked*(관리대상임)와 *Untracked*(관리대상이 아님)로 나눈다. *Tracked* 파일은 이미 스냅샷에 포함돼 있던 파일이다. *Tracked* 파일은 또 *Unmodified*(수정하지 않음)와 *Modified*(수정함) 그리고 *Staged*(커밋하면 저장소에 기록되는) 상태 중 하나이다. 그리고 나머지 파일은 모두 *Untracked* 파일이다. *Untracked* 파일은 워킹 디렉토리에 있는 모든 파일이 스냅샷에 포함돼 있는 것은 아니고 Staging Area에 있는 것도 아니다. 처음 저장소를 Clone하면 모든 파일은 *Tracked*이면서 *Unmodified* 상태가 된다. 파일을 Checkout하고 나서 아무것도 수정하지 않았기 때문에 그렇다.

마지막 커밋 이후 아직 아무것도 수정하지 않은 상태에서 어떤 파일이 수정되면 Git은 그 즉시 파일을 *Modified* 상태로 인식한다. 그리고 이 수정한 파일을 Stage하고 *Staged* 상태인 파일을 커밋한다. 이 라이프사이클을 그림 2-1처럼 계속 반복한다.

Insert 18333fig0201.png
그림 2-1. 파일의 라이프사이클

### 파일의 상태 확인하기 ###

파일의 상태를 확인하려면 보통 `git status` 명령을 사용한다. Clone한 후에 바로 이 명령을 실행하면 아래과 같은 메시지를 볼 수 있다:

	$ git status
	On branch master
	nothing to commit, working directory clean

위의 내용은 파일을 하나도 수정하지 않았다는 것을 말해준다. Tracked나 Modified 상태인 파일이 없다는 의미다. Untracked 파일은 아직 없어서 목록에 나타나지 않는다. 그리고 현재 작업 중인 브랜치를 알려준다. 기본 브랜치가 master이기 때문에 현재 master로 나오는 것이다. 브랜치 관련 내용은 차차 알아가자. 다음 장에서 브랜치와 레퍼런스에 대해 자세히 다룬다.

프로젝트에 `README` 파일을 만들어보자. `README` 파일은 새로 만든 파일이기 때문에 `git status`를 실행하면 'Untracked files'에 들어 있다:

	$ vim README
	$ git status
	On branch master
	Untracked files:
	  (use "git add <file>..." to include in what will be committed)
	
		README
	
	nothing added to commit but untracked files present (use "git add" to track)

`README` 파일은 `Untracked files` 부분에 속해 있는데 이것은 `README` 파일이 Untracked 상태라는 것을 말한다. Git은 Untracked 파일을 아직 스냅샷(커밋)에 넣어지지 않은 파일이라고 본다. 파일이 Tracked 상태가 되기 전까지는 Git은 절대 그 파일을 커밋하지 않는다. 그래서 일하면서 생성하는 바이너리 파일 같은 것을 커밋하는 실수는 하지 않게 된다. README 파일을 추가해서 직접 Tracked 상태로 만들어 보자.

### 파일을 새로 추적하기 ###

`git add` 명령으로 파일을 새로 추적할 수 있다. 아래 명령을 실행하면 Git은 `README` 파일을 추적한다:

	$ git add README

`git status` 명령을 다시 실행하면 README 파일이 Tracked 상태이면서 Staged 상태라는 것을 확인할 수 있다:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	

'Changes to be committed' 에 들어 있는 파일은 Staged 상태라는 것을 의미한다. 커밋하면 `git add`를 실행한 시점의 파일이 커밋되어 저장소 히스토리에 남는다. 앞에서 `git init` 명령을 실행했을 때, 그 다음 `git add (files)` 명령을 실행했던 걸 기억할 것이다. 이것은 작업 디렉토리에 있는 파일들을 추적하기 시작하게 하였다. `git add` 명령은 파일 또는 디렉토리의 경로명을 아규먼트로 받는다; 만일 디렉토리를 아규먼트로 줄 경우, 그 디렉토리 아래에 있는 모든 파일들을 재귀적으로 추가한다.

### Modified 상태의 파일을 Stage하기 ###

이미 Tracked 상태인 파일을 수정하는 법을 알아보자. `benchmarks.rb`라는 파일을 수정하고 나서 `git status` 명령을 다시 실행하면 결과는 아래와 같다:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

이 `benchmarks.rb` 파일은 `Changes not staged for commit`에 있다. 이것은 수정한 파일이 Tracked 상태이지만 아직 Staged 상태는 아니라는 것이다. Staged 상태로 만들려면 `git add` 명령을 실행해야 한다. `git add`는 파일을 새로 추적할 때도 사용하고 수정한 파일을 Staged 상태로 만들 때도 사용한다. `git add`를 실행하여 benchmarks.rb 파일을 Staged 상태로 만들고 `git status` 명령으로 결과를 확인해보자:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

두 파일 모두 Staged 상태이므로 다음 커밋에 포함된다. 하지만, 아직 더 수정해야 한다는 것을 알게 되어 바로 커밋하지 못하는 상황이 되었다고 하자. 이 상황에서 benchmark.rb 파일을 열고 수정한다. 아마 당신은 커밋할 준비가 다 됐다고 생각할 테지만, Git은 그렇지 않다. `git status` 명령으로 파일의 상태를 다시 확인해보자:

	$ vim benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	
	        modified:   benchmarks.rb
	

헉! benchmarks.rb가 Staged 상태이면서 동시에 Unstaged 상태로 나온다. 어떻게 이런 일이 가능할까? `git add` 명령을 실행하면 Git은 파일을 바로 Staged 상태로 만든다. 지금 이 시점에서 커밋을 하면 `git commit` 명령을 실행하는 시점의 버전이 커밋되는 것이 아니라 마지막으로 `git add` 명령을 실행했을 때의 버전이 커밋된다. 그러니까 `git add` 명령을 실행한 후에 또 파일을 수정하면 `git add` 명령을 다시 실행해서 최신 버전을 Staged 상태로 만들어야 한다:

	$ git add benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	        modified:   benchmarks.rb
	

### 파일 무시하기 ###

어떤 파일은 Git이 자동으로 추가하거나 Untracked 파일이라고 보여줄 필요가 없다. 보통 로그 파일이나 빌드 시스템이 자동으로 생성한 파일이 그렇다. 그런 파일을 무시하려면 `.gitignore` 파일을 만들고 그 안에 무시할 파일 패턴을 적는다. 아래는 `.gitignore` 파일의 예이다:

	$ cat .gitignore
	*.[oa]
	*~

첫번째 줄은 확장자가 `.o` 나 `.a`인 파일을 Git이 무시하라는 것이고 둘째 줄은 `~`로 끝나는 모든 파일을 무시하라는 것이다. `.o`와 `.a`는 각각 빌드 시스템이 만들어내는 오브젝트와 아카이브 파일이고 `~`로 끝나는 파일은 Emacs나 VI 같은 텍스트 편집기가 임시로 만들어내는 파일이다. 또 log, tmp, pid 같은 디렉토리나, 자동으로 생성하는 문서 같은 것들도 추가할 수 있다. `.gitignore` 파일은 보통 처음에 만들어 두는 것이 편리하다. 그래서 Git 저장소에 커밋하고 싶지 않은 파일을 실수로 커밋하는 일을 방지할 수 있다.

.gitignore 파일에 입력하는 패턴은 아래 규칙을 따른다:

* 아무것도 없는 줄이나, `#`로 시작하는 줄은 무시한다.
* 표준 Glob 패턴을 사용한다.
* 디렉토리는 슬래시(`/`)를 끝에 사용하는 것으로 표현한다.
* 느낌표(`!`)로 시작하는 패턴의 파일은 무시하지 않는다.

Glob 패턴은 정규표현식을 단순하게 만든 것으로 생각하면 되고 보통 쉘에서 많이 사용한다. 애스터리스크(`*`)는 문자가 하나도 없거나 하나 이상을 의미하고, `[abc]`는 중괄호 안에 있는 문자 중 하나를 의미한다(그러니까 이 경우에는 a, b, c). 물음표(`?`)는 문자 하나를 말하고, `[0-9]`처럼 중괄호 안의 캐릭터 사이에 하이픈(`-`)을 사용하면 그 캐릭터 사이에 있는 문자 하나를 말한다.

다음은 .gitignore 파일의 예이다:

	# a comment - 이 줄은 무시한다.
	# 확장자가 .a인 파일 무시
	*.a
	# 윗 줄에서 확장자가 .a인 파일은 무시하게 했지만 lib.a는 무시하지 않는다.
	!lib.a
	# 루트 디렉토리에 있는 TODO파일은 무시하고 subdir/TODO처럼 하위디렉토리에 있는 파일은 무시하지 않는다.
	/TODO
	# build/ 디렉토리에 있는 모든 파일은 무시한다.
	build/
	# `doc/notes.txt`같은 파일은 무시하고 doc/server/arch.txt같은 파일은 무시하지 않는다.
	doc/*.txt
	# `doc` 디렉토리 아래의 모든 .txt 파일을 무시한다.
	doc/**/*.txt

`**/` 스타일의 문법은 Git 1.8.2 버전부터 사용할 수 있다.

### Staged와 Unstaged 상태의 변경 내용을 보기 ###

단순히 파일이 변경됐다는 사실이 아니라 어떤 내용이 변경됐는지 살펴보기엔 `git status` 명령이 아니라 `git diff` 명령을 사용해야 한다. 보통우리는 '수정했지만, 아직 Staged 파일이 아닌것?'과 '어떤 파일이 Staged 상태인지?'가 궁금하기 때문에 `git status` 명령으로도 충분하다. `git diff`는 Patch처럼 어떤 라인을 추가했고 삭제했는지가 궁금할 때에 사용한다. `git diff`는 나중에 더 자세히 다룬다.

README 파일을 수정해서 Staged 상태로 만들고 benchmarks.rb 파일은 그냥 수정만 해둔다. 이 상태에서 `git status` 명령을 실행하면 아래와 같은 메시지를 볼 수 있다:

	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        new file:   README
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

`git diff` 명령을 실행하면 수정했지만 아직 staged 상태가 아닌 파일을 비교해 볼 수 있다:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

이 명령은 워킹 디렉토리에 있는 것과 Staging Area에 있는 것을 비교한다. 그래서 수정하고 아직 Stage하지 않은 것을 보여준다.

만약 커밋하려고 Staging Area에 넣은 파일의 변경 부분을 보고 싶으면 `git diff --cached` 옵션을 사용한다(Git 버전 1.6.1부터는 좀 더 기억하기 쉽게 `git diff --staged`로도 사용할 수 있다). 이 명령은 저장소에 커밋한 것과 Staging Area에 있는 것을 비교한다: 

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

꼭 잊지 말아야 할 것이 있는데 `git diff` 명령은 마지막으로 커밋한 후에 수정한 것들 전부를 보여주지 않는다. `git diff`는 Unstaged 상태인 것들만 보여준다. 이 부분이 조금 헷갈릴 수 있다. 수정한 파일을 모두 Staging Area에 넣었다면 `git diff` 명령은 아무것도 출력하지 않는다.

benchmarks.rb 파일을 Stage한 후에 다시 수정해도 `git diff` 명령을 사용할 수 있다. 이때는 Staged 상태인 것과 Unstaged 상태인 것을 비교한다:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   benchmarks.rb
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

`git diff` 명령으로 Unstaged 상태인 변경 부분을 확인해 볼 수 있다:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

Staged 상태인 파일은 `git diff --cached` 옵션으로 확인한다:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### 변경사항 커밋하기 ###

수정한 것을 커밋하기 위해 Staging Area에 파일을 정리했다. Unstaged 상태의 파일은 커밋되지 않는다는 것을 기억해야 한다. Git은 생성하거나 수정하고 나서 `git add` 명령으로 추가하지 않은 파일은 커밋하지 않는다. 그 파일은 여전히 Modified 상태로 남아 있다.
커밋하기 전에 `git status` 명령으로 모든 것이 Staged 상태인지 확인할 수 있다. 그리고 `git commit`을 실행하여 커밋한다:

	$ git commit

Git 설정에 지정된 편집기가 실행되고, 아래와 같은 텍스트가 자동으로 포함된다(아래 예제는 Vim 편집기의 화면이다). 이 편집기는 쉘의 $EDITOR 환경 변수에 등록된 편집기이고 보통은 Vim이나 Emacs을 사용한다. 또 *1장*에서 설명했듯이 `git config --global core.editor` 명령으로 어떤 편집기를 사용할지 설정할 수 있다:

편집기는 아래와 같은 내용을 표시한다(아래 예제는 Vim 편집기):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#       new file:   README
	#       modified:   benchmarks.rb
	#
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

자동으로 생성되는 커밋 메시지의 첫 줄은 비어 있고 둘째 줄부터 `git status` 명령의 결과가 채워진다. 커밋한 내용을 쉽게 기억할 수 있도록 이 메시지를 포함할 수도 있고 메시지를 전부 지우고 새로 작성할 수 있다(수정한 내용을 좀 더 구체적으로 남겨 둘 수 있다. `git commit`에 -v 옵션을 추가하면 편집기에 diff 메시지도 추가된다).

메시지를 인라인으로 첨부할 수도 있다. `commit` 명령을 실행할 때 아래와 같이 `-m` 옵션을 사용한다:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master 463dc4f] Story 182: Fix benchmarks for speed
	 2 files changed, 3 insertions(+)
	 create mode 100644 README

`commit` 명령은 몇 가지 정보를 출력하는데 위 예제는 master 브랜치에 커밋했고 체크섬은 `463dc4f`이라고 알려준다. 그리고 수정한 파일이 몇 개이고 삭제됐거나 추가된 줄이 몇 줄인지 알려준다.

Git은 Staging Area에 속한 스냅샷을 커밋한다는 것을 기억해야 한다. 수정은 했지만, 아직 Staging Area에 넣지 않은 것은 다음에 커밋할 수 있다. 커밋할 때마다 프로젝트의 스냅샷을 기록하기 때문에 나중에 스냅샷끼리 비교하거나 예전 스냅샷으로 되돌릴 수 있다.

### Staging Area 생략하기 ###

Staging Area는 커밋할 파일을 정리한다는 점에서 매우 유용하지만 복잡하기만 하고 필요하지 않은 때도 있다. 아주 쉽게 Staging Area를 생략할 수 있다. `git commit` 명령을 실행할 때 `-a` 옵션을 추가하면 Git은 Tracked 상태의 파일을 자동으로 Staging Area에 넣는다. 그래서 `git add` 명령을 실행하는 수고를 덜 수 있다:

	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	
	no changes added to commit (use "git add" and/or "git commit -a")
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+)

이 예제에서는 커밋하기 전에 `git add` 명령으로 benchmarks.rb 파일을 추가하지 않았다는 점을 눈여겨보자.

### 파일을 삭제하기 ###

Git에서 파일을 제거하려면 `git rm` 명령으로 Tracked 상태의 파일을 삭제한 후에(정확하게는 Staging Area에서 삭제하는 것) 커밋해야 한다. 이 명령은 워킹 디렉토리에 있는 파일도 삭제하기 때문에 실제로 지워진다.

만약 Git없이 그냥 파일을 삭제하고 `git status` 명령으로 상태를 확인하면 `Changes not staged for commit`(즉, Unstaged) 에 속한다는 것을 확인할 수 있다:

	$ rm grit.gemspec
	$ git status
	On branch master
	Changes not staged for commit:
	  (use "git add/rm <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        deleted:    grit.gemspec
	
	no changes added to commit (use "git add" and/or "git commit -a")

그리고 `git rm` 명령을 실행하면 삭제한 파일은 staged 상태가 된다:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        deleted:    grit.gemspec
	

커밋하면 파일은 삭제되고 Git은 이 파일을 더는 추적하지 않는다. 이미 파일을 수정했거나 Index에(역주, Staging Area을 Git Index라고도 부른다) 추가했다면 `-f`옵션을 주어 강제로 삭제해야 한다. 이 점은 실수로 데이터를 삭제하지 못하도록 하는 안전장치다. 한 번도 커밋한적 없는 데이터는 Git으로 복구할 수 없다.

또 Staging Area에서만 제거하고 워킹 디렉토리에 있는 파일은 지우지 않고 남겨둘 수 있다. 다시 말해서 하드디스크에 있는 파일은 그대로 두고 Git만 추적하지 않게 한다. 이것은 `.gitignore` 파일에 추가하는 것을 빼먹었거나 대용량 로그 파일이나 컴파일된 파일인 `.a` 파일 같은 것을 실수로 추가했을 때 쓴다. `--cached` 옵션을 사용하여 명령을 실행한다:

	$ git rm --cached readme.txt

여러 개의 파일이나 디렉토리를 한꺼번에 삭제할 수도 있다. 아래와 같이 `git rm` 명령에 file-glob 패턴을 사용한다:

	$ git rm log/\*.log

`*`앞에 `\`을 사용한 것을 기억하자. 파일명 확장 기능은 쉘에만 있는 것이 아니라 Git 자체에도 있기 때문에 필요하다. Windows 기본 쉘을 쓸 때는 `\` 기호를 붙이지 않는다. 이 명령은 `log/` 디렉토리에 있는 `.log` 파일을 모두 삭제한다. 아래의 예제처럼 할 수도 있다:

	$ git rm \*~

이 명령은 `~`로 끝나는 파일을 모두 삭제한다.

### 파일 이름 변경하기 ###

Git은 다른 VCS 시스템과는 달리 파일 이름의 변경이나 파일의 이동을 명시적으로 관리하지 않는다. 다시 말해서 파일 이름이 변경됐다는 별도의 정보를 저장하지 않는다. Git은 똑똑해서 굳이 파일 이름이 변경되었다는 것을 추적하지 않아도 아는 방법이 있다. 파일의 이름이 변경된 것을 Git이 어떻게 알아내는지 살펴보자.

이렇게 말하고 Git에 `mv` 명령이 있는 게 좀 이상하겠지만, 아래와 같이 파일이름을 변경할 수 있다:

	$ git mv file_from file_to

잘 동작한다. 이 명령을 실행하고 Git의 상태를 확인해보면 Git은 이름이 바뀐 사실을 알고 있다:

	$ git mv README.txt README
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        renamed:    README.txt -> README
	

사실 `git mv` 명령은 아래 명령어들을 수행한 것과 완전히 똑같다:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

`git mv`는 일종의 단축 명령어이다. 이 명령으로 파일이름을 바꿔도 되고 `mv` 명령으로 파일이름을 직접 바꿔도 된다. 단지 Git의 `mv`명령은 편리하게 명령을 세 번 실행해주는 것뿐이다. 어떤 도구로 이름을 바꿔도 상관없다. 중요한 것은 이름을 변경하고 나서 꼭 rm/add 명령을 실행해야 한다는 것뿐이다.

## 커밋 히스토리 조회하기 ##

새로 저장소를 만들어서 몇 번 커밋을 했을 수도 있고, 커밋 히스토리가 있는 저장소를 Clone했을 수도 있다. 어쨌든 가끔 저장소의 히스토리를 보고 싶을 때가 있다. Git에는 히스토리를 조회하는 명령어인 `git log`가 있다.

이 예제에서는 simplegit이라는 매우 단순한 프로젝트를 사용한다. simplegit은 Git을 설명하는데 자주 사용하는 예제다. 아래와 같이 이 프로젝트를 Clone한다:

	git clone git://github.com/schacon/simplegit-progit.git

이 프로젝트 디렉토리에서 `git log` 명령을 실행하면 아래와 같이 출력된다:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

특별한 아규먼트 없이 `git log` 명령을 실행하면 저장소의 커밋 히스토리를 시간순으로 보여준다. 즉, 가장 최근의 커밋이 가장 먼저 나온다. 그리고 이어서 각 커밋의 SHA-1 체크섬, 저자 이름, 저자 이메일, 커밋한 날짜, 커밋 메시지를 보여준다.

원하는 히스토리를 검색할 수 있도록 `git log` 명령은 매우 다양한 옵션을 지원한다. 여기에서는 자주 사용하는 옵션을 설명한다.

`-p`가 가장 유용한 옵션 중 하나다. `-p`는 각 커밋의 diff 결과를 보여준다. 게다가 `-2`는 최근 두 개의 결과만 보여주는 옵션이다:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,5 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	     s.name      =   "simplegit"
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"
	     s.email     =   "schacon@gee-mail.com"

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

이 옵션은 직접 diff를 실행한 것과 같은 결과를 출력하기 때문에 동료가 무엇을 커밋했는지 리뷰하고 빨리 조회하는데 유용하다.

가끔은 diff 결과를 줄 단위로 보기보다는 단어 단위로 보는 것이 좋을 때도 있다. `git log -p`와 같은 명령에 `--word-diff` 옵션을 사용하면 줄 단위 대신 단어 단위로 변경사항을 보여준다. 단어 단위로 다른 부분을 확인하는 것은 소스코드에는 별로 유용하지 않다. 책이나 에세이 같이 문장이 긴 글을 쓸 때는 단어 단위로 보는 것이 편하다. `--word-diff` 옵션은 다음과 같이 사용한다:

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

위의 예제는 줄 단위로 보여주는 일반적인 diff와 좀 다르다. 줄 안에서 변경한 부분을 단어 단위로 표시한다. 추가한 단어는 `{+ +}` 기호가 둘러싸고 삭제한 단어는 `[- -]` 기호가 둘러싼다. diff는 기본적으로 다른 줄과 위아래 줄을 포함해서 3줄을 보여준다. 줄 단위가 아니라 단어 단위로 비교해서 볼 때는 굳이 3줄을 다 볼 필요가 없다. 예제에서 처럼 `-U1` 옵션을 주면 해당 줄만 보여준다.

또 `git log` 명령에는 히스토리의 통계를 보여주는 옵션도 있다. `--stat` 옵션으로 각 커밋의 통계 정보를 조회할 수 있다:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 file changed, 1 insertion(+), 1 deletion(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 file changed, 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+)

이 결과에서 `--stat` 옵션은 어떤 파일이 수정됐는지, 얼마나 많은 파일이 변경됐는지, 또 얼마나 많은 줄을 추가하거나 삭제했는지 보여준다. 요약정보는 가장 뒤쪽에 보여준다.

다른 또 유용한 옵션은 `--pretty` 옵션이다. 이 옵션을 통해 log의 내용을 보여줄 때 기본 형식 이외에 여러 가지 중에 하나를 선택할 수 있다.  `oneline` 옵션은 각 커밋을 한 줄로 보여준다. 이 옵션은 많은 커밋을 한 번에 조회할 때 유용하다. 추가로 `short`, `full`, `fuller` 옵션도 있는데 이것은 정보를 조금씩 가감해서 보여준다:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

가장 재밌는 옵션은 `format` 옵션이다. 나만의 포맷으로 결과를 출력하고 싶을 때 사용한다. 특히 결과를 다른 프로그램으로 파싱하고자 할 때 유용하다. 이 옵션을 사용하면 포맷을 정확하게 일치시킬 수 있기 때문에 Git을 새 버전으로 바꿔도 결과 포맷이 바뀌지 않는다:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

표 2-1 형식에서 사용하는 유용한 옵션들.

	Option	Description of Output
	%H	Commit hash
	%h	Abbreviated commit hash
	%T	Tree hash
	%t	Abbreviated tree hash
	%P	Parent hashes
	%p	Abbreviated parent hashes
	%an	Author name
	%ae	Author e-mail
	%ad	Author date (format respects the --date= option)
	%ar	Author date, relative
	%cn	Committer name
	%ce	Committer email
	%cd	Committer date
	%cr	Committer date, relative
	%s	Subject

_저자(Author)_ 와 _커미터(Committer)_ 를 구분하는 것이 조금 이상해 보일 수 있다. 저자는 원래 작업을 수행한 원작자이고 커밋터는 마지막으로 이 작업을 적용한 사람이다. 만약 당신이 어떤 프로젝트에 패치를 보냈고 그 프로젝트의 담당자가 패치를 적용했다면 두 명의 정보를 모두 알 필요가 있다. 그래서 이 경우 당신이 저자고 그 담당자가 커미터다. *5장*에서 이 주제에 대해 자세히 다룰 것이다.

`oneline`과 `format` 옵션은 `--graph` 옵션과 함께 사용할 때 더 빛난다. 이 명령은 브랜치와 머지 히스토리를 보여주는 아스키 그래프를 출력한다. 이 명령을 Grit 프로젝트 저장소에서 사용해보면 아래와 같다:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

`git log` 명령의 기본적인 옵션과 출력물의 형식에 관련된 옵션을 살펴보았다. `git log` 명령은 앞서 살펴본 것보다 더 많은 옵션을 지원한다. 표 2-2 는 지금 설명한 것과 함께 유용하게 사용할 수 있는 옵션이다. 각 옵션으로 어떻게 `log` 명령을 제어할 수 있는지 보여준다.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	옵션	설명
	-p	각 커밋에 적용된 패치를 보여준다.
	--word-diff	diff 결과를 단어 단위로 보여준다.
	--stat	각 커밋에서 수정된 파일의 통계정보를 보여준다.
	--shortstat	`--stat` 명령의 결과 중에서 수정한 파일, 추가된 줄, 삭제된 줄만 보여준다.
	--name-only	커밋 정보중에서 수정된 파일의 목록만 보여준다.
	--name-status	수정된 파일의 목록을 보여줄 뿐만 아니라 파일을 추가한 것인지, 수정한 것인지, 삭제한 것인지도 보여준다.
	--abbrev-commit	40자 짜리 SHA-1 체크섬을 전부 보여주는 것이 아니라 처음 몇 자만 보여준다.
	--relative-date	정확한 시간을 보여주는 것이 아니라 `2 주전`처럼 상대적인 형식으로 보여준다.
	--graph	브랜치와 머지 히스토리 정보까지 아스키 그래프로 보여준다.
	--pretty	지정한 형식으로 보여준다. 이 옵션에는 oneline, short, full, fuller, format이 있다. format은 원하는 형식으로 출력하고자 할 때 사용한다.
	--oneline	`--pretty=oneline --abbrev-commit` 옵션을 함께 사용한 것과 동일하다.

### 조회 제한조건 ###

출력 형식과 관련된 옵션을 살펴봤지만 `git log` 명령은 조회 범위를 제한하는 옵션들도 있다. 히스토리 전부가 아니라 부분만 조회한다. 이미 최근 두 개만 조회하는 `-2` 옵션은 살펴봤다. 실제 사용법은 `-<n>`이고 n은 최근 n개의 커밋을 의미한다. 사실 이 옵션은 잘 쓰이지 않는다. Git은 기본적으로 출력을 pager류의 프로그램을 거쳐서 내보내므로 한 번에 한 페이지씩 보여준다.

반면 `--since`나 `--until`같은 시간을 기준으로 조회하는 옵션은 매우 유용하다. 지난 2주 동안 만들어진 커밋들만 조회하는 명령은 아래와 같다:

	$ git log --since=2.weeks

이 옵션은 다양한 형식을 지원한다. `2008-01-15`같이 정확한 날짜도 사용할 수 있고 `2 years 1 day 3 minutes ago`같이 상대적인 기간을 사용할 수도 있다.

또 다른 기준도 있다. `--author` 옵션으로 저자를 지정하여 검색할 수도 있고 `--grep` 옵션으로 커밋 메시지에서 키워드를 검색할 수도 있다(author와 grep 옵션을 함께 사용하면 모두 만족하는 커밋을 찾는다).

grep 옵션을 여러개 사용하면 그중 하나이상 만족하는 커밋을 찾는다. 모두 만족하는 커밋을 찾으려면 `--all-match` 옵션을 추가해야 한다.

마지막으로 파일 경로로 검색하는 옵션이 있는데 이것도 정말 유용하다. 디렉토리나 파일 이름을 사용하여 그 파일이 변경된 log의 결과를 검색할 수 있다. 이 옵션은 `--`와 함께 경로 이름을 사용하는데 명령어 끝 부분에 쓴다(역주, `git log -- path1 path2`).

표 2-3은 조회 범위를 제한하는 옵션들이다.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	옵션	설명
	-(n)	최근 n 개의 커밋만 조회한다.
	--since, --after	명시한 날짜 이후의 커밋만 검색한다.
	--until, --before	명시한 날짜 이전의 커밋만 조회한다.
	--author	입력한 저자의 커밋만 보여준다.
	--committer	입력한 커미터의 커밋만 보여준다.

아래 예제는 2008년 10월에 Junio Hamano가 커밋한 히스토리를 조회하는 것이다. 그 중에서 테스트 파일을 수정한 커밋 중에서 머지 커밋이 아닌 것들만 조회한다:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

총 2만여 개의 커밋 히스토리에서 이 명령의 검색 조건에 만족하는 것은 단 6개였다.

### GUI 도구로 히스토리를 시각화하기 ###

GUI 도구로 커밋 히스토리를 시각화하고 싶다면 gitk를 사용할 수 있다. gitk는 Tcl/Tk 프로그램이고 `git log` 명령을 시각화해주는 도구다. gitk는 `git log` 명령이 지원하는 필터링 옵션을 거의 모두 지원한다. 프로젝트 디렉토리에서 gitk를 실행하면 그림 2-2처럼 보일 것이다.

Insert 18333fig0202.png
그림 2-2. gitk의 히스토리

위쪽 반을 차지하는 윈도에서는 히스토리를 그래프로 예쁘게 보여준다. 아래쪽 반을 차지하는 윈도는 diff 결과를 보여주는데 위쪽 윈도에서 선택한 커밋에 대한 diff 결과를 보여준다.

## 되돌리기 ##

일을 하다보면 모든 단계에서 어떤 것은 되돌리고(Undo) 싶을 때가 있다. 이번에는 우리가 한 일을 되돌리는 방법을 살펴볼 것이다. 한 번 되돌리면 복구할 수 없어서 주의해야 한다. Git을 사용하면 우리가 한 실수를 복구하지 못할 것은 거의 없지만 되돌리기는 복구할 수 없다.

### 커밋 수정하기 ###

종종 완료한 커밋을 수정해야 할 때가 있다. 너무 일찍 커밋했거나 어떤 파일을 빼먹었을 때 그리고 커밋 메시지를 잘못 적었을 때 하게 된다. 다시 커밋하고 싶으면 `--amend` 옵션을 사용한다:

	$ git commit --amend

이 명령은 Staging Area를 사용하여 커밋한다. 만약 마지막으로 커밋하고 나서 수정한 것이 없다면(커밋하자마자 바로 이 명령을 실행하는 경우) 조금 전에 한 커밋과 모든 것이 같다. 이때는 커밋 메시지만 수정한다.

편집기가 실행되면 이전 커밋 메시지가 자동으로 포함된다. 메시지를 수정하지 않고 그대로 커밋해도 기존의 커밋을 덮어쓴다. 

커밋을 했는데 Stage하는 것을 깜빡하고 빠트린 파일이 있으면 아래와 같이 고칠 수 있다:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

여기서 실행한 명령어 3개는 모두 하나의 커밋으로 기록된다. 두 번째 커밋은 첫 번째 커밋을 덮어쓴다.

### 파일 상태를 Unstage로 변경하기 ###

다음은 Staging Area와 워킹 디렉토리 사이를 넘나드는 방법을 설명한다. 두 영역의 상태를 확인할 때마다 변경된 상태를 되돌리는 방법을 알려주기 때문에 매우 편리하다. 예를 들어 파일을 두 개 수정하고서 따로따로 커밋하려고 했지만, 실수로 `git add *` 라고 실행해 버렸다. 두 파일 모두 Staging Area에 들어 있다. 이제 둘 중 하나를 어떻게 꺼낼까? 우선 `git status` 명령으로 확인해보자:

	$ git add .
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	        modified:   benchmarks.rb
	

`Changes to be commited` 밑에 `git reset HEAD <file>...`이라는 문장을 볼 수 있다. 이 명령으로 Unstage 상태로 변경할 수 있다. benchmarks.rb 파일을 Unstage 상태로 변경해보자:

	$ git reset HEAD benchmarks.rb
	Unstaged changes after reset:
	M       benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	
	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

명령어가 낮설게 느껴질 수도 있지만 잘 동작한다. benchmarks.rb 파일은 Unstage 상태가 됐다.

### Modified 파일 되돌리기 ###

어떻게 해야 benchmarks.rb 파일을 수정하고 나서 다시 되돌릴 수 있을까? 그러니까 최근 커밋된 버전으로(아니면 처음 Clone했을 때처럼 워킹 디렉토리에 처음 Checkout 한 그 내용으로) 되돌리는 방법이 무얼까? `git status` 명령이 친절하게 알려준다. 바로 위에 있는 예제에서 Unstaged 부분을 보자:

	Changes not staged for commit:
	  (use "git add <file>..." to update what will be committed)
	  (use "git checkout -- <file>..." to discard changes in working directory)
	
	        modified:   benchmarks.rb
	

위의 메시지는 수정한 파일을 되돌리는 방법을 꽤 정확하게 알려준다(적어도 Git 1.6.1이후 버전부터는 그렇다. 만약 예전 것을 아직 사용하고 있으면 업그레드하는 것이 좋다. 편의성이 많이 개선됐다). 알려주는 대로 한 번 해보자:

	$ git checkout -- benchmarks.rb
	$ git status
	On branch master
	Changes to be committed:
	  (use "git reset HEAD <file>..." to unstage)
	
	        modified:   README.txt
	

정상적으로 복원된 것을 알 수 있다. 하지만 이 명령은 꽤 위험한 명령이라는 것을 알아야 한다. 수정 이전의 파일로 덮어썼기 때문에 수정했던 내용은 전부 사라진다. 수정한 내용이 진짜 마음에 들지 않을 때에만 사용하자. 정말 이렇게 삭제해야 한다면 Stash와 Branch를 사용하자. 다음 장에서 다루는 이 방법들이 훨씬 낫다.

Git으로 커밋한 모든 것은 언제나 복구할 수 있다. 삭제한 브랜치에 있었던 것도 `--amend` 옵션으로 다시 커밋한 것도 복구할 수 있다(자세한 것은 *9장*에서 다룬다). 하지만, 커밋하지 않고 잃어버린 것은 절대로 되돌릴 수 없다.

## 리모트 저장소 ##

리모트 저장소를 관리할 줄 알아야 다른 사람과 함께 일할 수 있다. 리모트 저장소는 인터넷이나 네트워크 어딘가에 있는 저장소를 말한다. 저장소는 여러 개가 있을 수 있는데 어떤 저장소는 읽고 쓰기 모두 할 수 있고 어떤 저장소는 읽기 권한만 있을 수도 있다. 간단히 말해서 다른 사람들과 함께 일한다는 것은 리모트 저장소를 관리하면서 데이터를 거기에 Push하고 Pull하는 것이다. 리모트 저장소를 관리한다는 것은 저장소를 추가, 삭제하는 것뿐만 아니라 브랜치를 관리하고 추적할지 말지 등을 관리하는 것을 말한다. 이번에는 리모트 저장소를 관리하는 방법에 대해 설명한다.

### 리모트 저장소 확인하기 ###

`git remote` 명령으로 현재 프로젝트에 등록된 리모트 저장소를 확인할 수 있다. 이 명령은 리모트 저장소의 단축 이름을 보여준다. 저장소를 Clone하면 origin이라는 리모트 저장소가 자동으로 등록되기 때문에 origin이라는 이름을 볼 수 있다:

	$ git clone git://github.com/schacon/ticgit.git
	Cloning into 'ticgit'...
	remote: Reusing existing pack: 1857, done.
	remote: Total 1857 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (1857/1857), 374.35 KiB | 193.00 KiB/s, done.
	Resolving deltas: 100% (772/772), done.
	Checking connectivity... done.
	$ cd ticgit
	$ git remote
	origin

`-v`옵션을 주어 단축이름과 URL을 함께 볼 수 있다:

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

리모트 저장소가 여러 개 있다면 이 명령은 전부 보여준다. 내 Grit 저장소에서 실행하면 아래와 같이 출력한다:

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

이렇게 리모트 저장소가 여러 개가 등록되어 있으면 다른 사람이 기여한 내용(Contributions)을 쉽게 가져올 수 있다. 그리고 origin만 SSH URL이기 때문에 origin에만 Push할 수 있다(*4장*에서 좀 더 자세히 다룬다).

### 리모트 저장소 추가하기 ###

이전 절에서도 리모트 저장소를 추가하는 것에 대해 설명했었지만 수박 겉핥기식으로 살펴봤을 뿐이었다. 여기에서는 리모트 저장소를 추가하는 방법을 자세하게 설명한다. 쉽게 새 리모트 저장소를 추가할 수 있는데 `git remote add [단축이름] [url]` 명령을 실행한다:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

이제 URL 대신에 스트링 `pb`를 사용할 수 있다. 예를 들어 로컬 저장소에는 없지만 Paul의 저장소에 있는 것을 가져오려면 아래과 같이 실행한다:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

로컬에서 `pb/master`가 Paul의 master 브랜치이다. 이것을 로컬 브랜치중 하나에 머지하거나 체크아웃하여 브랜치 내용을 자세히 확인할 수 있다.

### 리모트 저장소를 Pull 하거나 Fetch 하기 ###

앞서 설명했듯이 리모트 저장소에서 데이터를 가져오려면 간단히 아래와 같이 실행한다:

	$ git fetch [remote-name]

이 명령은 로컬에는 없지만, 리모트 저장소에는 있는 데이터를 모두 가져온다. 그리고 나면 리모트 저장소의 모든 브랜치를 로컬에서 접근할 수 있어서 언제든지 머지를 하거나 내용을 살펴볼 수 있다(우리는 *3장*에서 브랜치를 사용하는 방법에 대해 좀 더 자세히 설명할 것이다).

저장소를 Clone하면 명령은 자동으로 리모트 저장소를 origin이라는 이름으로 추가한다. 그래서 나중에 `git fetch origin`을 실행하면 Clone한 이후에(혹은 마지막으로 가져온 이후에) 수정된 것을 모두 가져온다. `fetch` 명령은 리모트 저장소의 데이터를 모두 로컬로 가져오지만, 자동으로 머지하지 않는다. 그래서 당신이 로컬에서 하던 작업을 정리하고 나서 수동으로 머지해야 한다.

그냥 쉽게 `git pull` 명령으로 리모트 저장소 브랜치에서 데이터를 가져올 뿐만 아니라 자동으로 로컬 브랜치와 머지시킬 수 있다. 먼저 `git clone` 명령은 자동으로 로컬의 master 브랜치가 리모트 저장소의 master 브랜치를 추적하도록 한다(물론 리모트 저장소에 master 브랜치가 있다고 가정에서). 그리고 `git pull` 명령은 Clone한 서버에서 데이터를 가져오고 그 데이터를 자동으로 현재 작업하는 코드와 머지시킨다.

### 리모트 저장소에 Push하기 ###

프로젝트를 공유하고 싶을 때 리모트 저장소에 Push할 수 있다. 이 명령은 `git push [리모트 저장소 이름] [브랜치 이름]`으로 단순하다. master 브랜치를 `origin` 서버에 Push하려면(다시 말하지만 Clone하면 보통 자동으로 origin 이름이 생성된다) 아래와 같이 서버에 Push한다:

	$ git push origin master

이 명령은 Clone한 리모트 저장소에 쓰기 권한이 있고, Clone하고 난 이후 아무도 리모트 저장소에 Push하지 않았을 때만 사용할 수 있다. 다시 말해서 Clone한 사람이 여러 명 있을 때, 다른 사람이 Push한 후에 Push하려고 하면 Push할 수 없다. 먼저 다른 사람이 작업한 것을 가져와서 머지한 후에 Push할 수 있다. *3장*에서 서버에 Push하는 방법에 대해 자세히 설명할 것이다.

### 리모트 저장소 살펴보기 ###

(역주, 이 절은 최신 버전의 Git이 출력하는 메시지와 조금 다르다.)

`git remote show [리모트 저장소 이름]` 명령으로 리모트 저장소의 구체적인 정보를 확인할 수 있다. `origin` 같은 단축이름으로 이 명령을 실행하면 아래와 같은 정보를 볼 수 있다:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

리모트 저장소의 URL과 추적하는 브랜치를 출력한다. 이 명령은 `git pull` 명령을 실행할 때 master 브랜치와 머지할 브랜치가 무엇인지 보여 준다. `git pull` 명령은 리모트 저장소 브랜치의 데이터를 모두 가져오고 나서 자동으로 머지할 것이다. 그리고 가져온 모든 리모트 저장소 정보도 출력한다.

좀 더 Git을 열심히 사용하게 되면 `git remote show` 명령은 더 많은 정보를 보여줄 것이다. 여러분도 언젠가는 아래와 같은 메시지(역주, 다수의 브랜치를 사용하는 메시지)를 볼 날이 올 것이다.

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

브랜치명을 생략하고 `git push` 명령을 실행할 때 어떤 브랜치가 어떤 브랜치로 Push되는지 보여준다. 또 아직 로컬로 가져오지 않은 리모트 저장소의 브랜치는 어떤 것들이 있는지, 서버에서는 삭제됐지만 아직 가지고 있는 브랜치는 어떤 것인지, `git pull` 명령을 실행했을 때 자동으로 머지할 브랜치는 어떤 것이 있는지 보여준다.

### 리모트 저장소 이름을 바꾸거나 리모트 저장소를 삭제하기 ###

`git remote rename` 명령으로 리모트 저장소의 이름을 변경할 수 있다. 예를 들어 `pb`를 `paul`로 변경하려면 `git remote rename` 명령을 사용한다:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

리모트 저장소의 브랜치 이름도 바뀐다. 여태까지 `pb/master`로 리모트 저장소 브랜치를 사용했으면 이제는 `paul/master`라고 사용해야 한다.

리모트 저장소를 삭제해야 한다면 `git remote rm` 명령을 사용한다. 서버 정보가 바뀌었을 때, 더는 별도의 미러가 필요하지 않을 때, 더는 기여자가 활동하지 않을 때 필요하다:

	$ git remote rm paul
	$ git remote
	origin

## 태그 ##

다른 VCS처럼 Git도 태그를 지원한다. 사람들은 보통 릴리즈할 때 사용한다(v1.0, 등등). 이번에는 태그를 조회하고 생성하는 법과 태그의 종류를 설명한다. 

### 태그 조회하기 ###

우선 `git tag` 명령으로 이미 만들어진 태그가 있는지 확인할 수 있다:

	$ git tag
	v0.1
	v1.3

이 명령은 알파벳 순서로 태그를 보여준다. 사실 순서는 별로 중요한 게 아니다.

검색 패턴을 사용하여 태그를 검색할 수 있다. Git 소스 저장소는 240여 개의 태그가 있다. 만약 1.4.2 버전의 태그들만 검색하고 싶으면 아래와 같이 실행한다:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### 태그 붙이기 ###

Git의 태그는 Lightweight 태그와 Annotated 태그로 두 종류가 있다. Lightweight 태그는 브랜치와 비슷한데 브랜치처럼 가리키는 지점을 최신 커밋으로 이동시키지 않는다. 단순히 특정 커밋에 대한 포인터일 뿐이다. 한편, Annotated 태그는 Git 데이터베이스에 태그를 만든 사람의 이름, 이메일과 태그를 만든 날짜, 그리고 태그 메시지도 저장한다. 또 GPG(GNU Privacy Guard)로 서명할 수도 있다. 이 모든 정보를 저장해둬야 할 때에만 Annotated 태그를 추천한다. 그냥 다른 정보를 저장하지 않는 단순한 태그가 필요하다면 Lightweight 태그를 사용하는 것이 좋다.

### Annotated 태그 ###

Annotated 태그를 만드는 방법은 간단하다. `tag` 명령을 실행할 때 `-a` 옵션을 추가한다:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

`-m` 옵션으로 태그를 저장할 때 메시지를 함께 저장할 수 있다. 명령을 실행할 때 메시지를 입력하지 않으면 Git은 편집기를 실행시킨다.

`git show` 명령으로 태그 정보와 커밋 정보를 모두 확인할 수 있다:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

커밋 정보를 보여주기 전에 먼저 태그를 만든 사람이 누구인지, 언제 태그를 만들었는지, 그리고 태그 메시지가 무엇인지 보여준다.

### 태그에 서명하기 ###

GPG 개인키가 있으면 태그에 서명할 수 있다. 이때에는 `-a`옵션 대신 `-s`를 사용한다:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

이 태그에 `git show`를 실행하면 GPG 서명도 볼 수 있다:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

잠시 후에 서명한 태그를 검증하는 방법도 설명한다.

### Lightweight 태그 ###

Lightweight 태그는 기본적으로 파일에 커밋 체크섬을 저장하는 것뿐이다. 다른 정보는 저장하지 않는다. Lightweight 태그를 만들 때에는 `-a`, `-s`, `-m` 옵션을 사용하지 않는다:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

이 태그에 `git show`를 실행하면 별도의 태그 정보를 확인할 수 없다. 이 명령은 단순히 커밋 정보만을 보여준다:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### 태그 검증하기 ###

`git tag -v [태그 이름]` 명령으로 서명한 태그를 검증한다. 이 명령은 GPG를 사용하여 서명을 검증한다. 그래서 서명자의 GPG 공개키가 필요하다. 이 공개키가 Keyring에 있어야만 이 명령이 성공적으로 실행된다:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

만약 서명자의 공개키가 없으면 아래와 같은 메시지를 출력한다:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### 나중에 태그하기 ###

예전 커밋에 대해서도 태그할 수 있다. 커밋 히스토리는 아래와 같고:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

"updated rakefile" 커밋을 v1.2로 태그하지 못했다고 해도 차후에 태그를 붙일 수 있다. 특정 커밋에 태그하기 위해서 명령의 끝에 커밋 체크섬을 명시한다(긴 체크섬을 전부 사용할 필요는 없다):

	$ git tag -a v1.2 -m 'version 1.2' 9fceb02

이제 아래와 같이 만든 태그를 확인한다:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### 태그 공유하기 ###

`git push` 명령은 자동으로 리모트 서버에 태그를 전송하지 않는다. 태그를 만들었으면 서버에 별도로 Push해야 한다. 브랜치를 공유하는 것과 같은 방법으로 할 수 있다. `git push origin [태그 이름]`을 실행한다:

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

만약 한 번에 태그를 여러 개 Push하고 싶으면 `--tags` 옵션을 추가하여 `git push`명령을 실행한다. 이 명령으로 리모트 서버에 없는 태그를 모두 전송할 수 있다:

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

누군가 저장소에서 Clone하거나 Pull을 하면 모든 태그 정보도 함께 전송된다.

## 팁과 트릭 ##

Git의 기초를 마치기 전에 Git을 좀 더 쉽고 편안하게 쓸 수 있게 만들어 줄 몇 가지 팁과 트릭도 설명한다. 이런 팁 없이 Git을 사용하는 사람들도 많다. 우리는 이 책에서 이 팁을 다시 거론하지 않고 이런 팁을 알고 있다고 가정한다. 그래서 알고 있는 것이 좋다.

### 자동완성 ###

Bash 쉘을 쓰고 있다면 멋진 자동완성(Auto-completion) 기능을 사용할 수 있다. https://github.com/git/git/blob/master/contrib/completion/git-completion.bash 에서 바로 다운받는다. 그 파일을 홈 디렉토리에 카피하고 `.bashrc` 파일에 아래와 같은 내용을 추가하자:

	source ~/git-completion.bash

또 모든 사용자가 사용할 수 있게 설정할 수 있다. Mac 시스템이라면 이 스크립트를 `/opt/local/etc/bash_completion.d` 디렉토리에 복사하고 리눅스라면 `/etc/bash_completion.d/`에 복사한다. 이 디렉토리는 Bash가 자동완성을 지원하기 위해 사용하는 디렉토리다.

윈도에 msysGit을 설치해서 Git Bash를 사용하는 경우에는 자동완성이 미리 설정되어 있다.

Git 명령을 입력할 때 `<Tab>` 키를 누르면 Git이 제안하는 명령어가 출력된다:

	$ git co<tab><tab>
	commit config

이 경우 `git co`를 입력하고 Tab 키를 두번 누르면 commit과 config를 제안한다. 이 때 `m<tab>`을 입력하면 자동으로 `git commit`명령을 완성한다.

옵션에도 이 기능이 되고 더 유용하다. 예를 들어 `git log`명령을 실행하는데 옵션이 전혀 기억나지 않는다면 아래와 같이 입력하고 Tap 키를 누르면 아래와 같은 옵션을 제안한다:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

이건 상당히 멋진 팁이다. 아마 문서를 찾아보는 등의 시간을 절약해 줄 것이다.

### Git Alias ###

명령을 완벽하게 입력하지 않으면 Git은 알아듣지 못한다. Git의 명령을 전부 입력하는 것이 귀찮다면 `git config`를 사용하여 각 명령의 Alias을 쉽게 만들 수 있다. 아래는 Alias을 만드는 예이다:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

이제 `git commit` 대신 `git ci`만으로도 커밋할 수 있다. Git을 계속 사용한다면 다른 명령어도 자주 사용하게 될 것이다. 자주 사용하는 명령은 Alias을 만들어 편하게 사용한다.

이미 있는 명령을 편리하고 새로운 명령으로 만들어 사용할 수 있다. 예를 들어 파일을 Unstage 상태로 변경하는 명령을 만들어서 불편함을 덜 수 있다. 아래와 같이 `unstage` 라는 Alias을 만든다:

	$ git config --global alias.unstage 'reset HEAD --'

아래 두 명령은 동일한 명령이다:

	$ git unstage fileA
	$ git reset HEAD fileA

한결 간결해졌다. 추가로 `last` 명령을 만들어 보자:

	$ git config --global alias.last 'log -1 HEAD'

이제 최근 커밋을 좀 더 쉽게 확인할 수 있다:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

이것으로 쉽게 새로운 명령을 만들 수 있다. 그리고 Git의 명령어뿐만 아니라 외부 명령어도 실행할 수 있다. `!`를 제일 앞에 추가하면 외부 명령을 실행한다. 아래 명령은 `git visual`이라고 입력하면 `gitk`가 실행된다:

	$ git config --global alias.visual '!gitk'

## 요약 ##

이제 우리는 로컬에서 사용할 수 있는 Git 명령에 대한 기본 지식은 갖추었다. 저장소를 만들고 Clone하는 방법, 수정하고 나서 Stage하고 커밋하는 방법, 저장소의 히스토리를 조회하는 방법 등을 살펴보았다. 이어지는 장에서는 Git의 가장 강력한 기능인 브랜치 모델을 살펴볼 것이다.
