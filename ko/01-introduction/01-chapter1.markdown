# 시작하기 #

이 장에서는 처음 접하는 사람들에게 Git을 설명한다. 먼저 버전 관리 도구에 대한 이해를, 그리고 Git을 설치하는 방법을, 마지막으로 Git 서버를 설정하고 사용하는 방법을 설명한다. 이 장을 다 읽고 나면 Git의 탄생 배경, Git을 사용하는 이유, Git을 설정하고 사용하는 방법을 터득할 것이다.

## 버전 관리란? ##

버전 관리는 무엇이고, 우리는 왜 이것을 알아야 할까? 버전 관리는 파일들의 변화를 시간에 따라 기록하는 것이다. 이 책에 있는 모든 예제는 모두 버전 관리 시스템을 사용한다. 실제로 컴퓨터에서 사용하는 거의 모든 파일의 버전을 관리할 수 있다.

그래픽 디자이너나 웹 디자이너도 이미지나 레이아웃의 모든 버전(변경 이력 혹은 수정 내용)을 관리하기 위해 버전 관리 시스템 (VCS - Version Control System)을 사용하는 것이 현명하다. VCS를 사용하면 각 파일을 이전 상태로 되돌릴 수 있고, 프로젝트를 통째로 이전 상태로 되돌릴 수 있고, 시간에 따라 수정 내용을 비교해 볼 수 있고, 누가 문제를 일으켰는지도 추적할 수 있고, 누가 언제 만들어낸 이슈인지도 알 수 있다. VCS를 사용하면 파일을 잃어버리거나 잘못 고쳤을 때도 쉽게 복구할 수 있다. 이런 모든 장점을 큰 노력 없이 이용할 수 있다.

### 로컬 버전 관리 시스템 ###

많은 사람은 버전을 관리하기 위해 Directory로 파일을 복사하는 방법을 쓴다(똑똑한 사람이라면 Directory 이름으로 시간을 쓸 거다). 이 방법은 간단하므로 자주 사용한다. 그렇지만, 정말 뭔가가 잘못되기 쉽다. 작업하는 Directory를 지워버리거나, 실수로 파일을 잘못 고칠 수도 있고, 잘못 복사할 수도 있다.

이런 이유로 프로그래머들은 오래전에 로컬 VCS를 만들었다. 그 VCS는 관리 중인 파일의 변경 정보를 저장하려고 아주 간단한 데이터베이스를 사용했다. 

Insert 18333fig0101.png 
그림 1-1. 로컬 버전 관리 다이어그램.

많이 쓰는 VCS 도구 중에 rcs라고 부르는 것이 있는데 오늘날까지도 아직 많은 회사가 사용하고 있다. Mac OS X 운영체제에서도 개발 도구를 설치하면 RCS가 함께 설치된다. RCS는 기본적으로 Patch Set(파일에서 변경되는 부분)을 관리한다. 이 Patch Set은 특별한 형식의 파일로 저장한다. 그리고 일련의 Patch Set을 적용해서 모든 파일을 특정 시점으로 되돌릴 수 있다.

### 중앙집중식 버전 관리 시스템 (Centralized VCS) ###

프로젝트를 진행하다 보면 다른 개발자와 함께 작업해야 하는 경우가 많다. 이럴 때 생기는 문제를 해결하기 위해 CVCS(Centralized Version Control System)가 개발됐다. CVS, Subversion, Perforce 같은 시스템은 모든 파일을 관리하는 서버가 별도로 있고 많은 클라이언트가 중앙 서버에서 파일을 받아서 사용(Checkout)한다. 수년 동안 이러한 시스템들이 많은 사랑을 받았다.

Insert 18333fig0102.png 
그림 1-2. 중앙집중식 버전 관리 (CVCS) 다이어그램.

CVCS 환경은 로컬 VCS비해 장점이 많다. 프로젝트에 참여한 사람이면 누가 무엇을 하고 있는지 알 수 있다. 관리자는 누가 무엇을 할 수 있는지 꼼꼼하게 관리할 수 있다. 모든 클라이언트의 로컬 데이터페이스를 관리하는 것보다 CVS 하나를 관리하기가 훨씬 쉽다.

그러나 CVCS 환경은 몇 가지 치명적인 결점이 있다. 가장 대표적인 것이 중앙 서버에 발생한 문제다. 만약 서버가 한 시간 동안 다운되면 그동안 아무도 다른 사람과 협업할 수 없고 사람들이 하는 일을 백업할 방법도 없다. 그리고 중앙 데이터베이스가 있는 하드디스크에 문제가 생기면 프로젝트의 모든 히스토리를 잃는다. 물론 사람마다 하나씩 가진 Snapshot은 괜찮다. 로컬 VCS 시스템도 이와 비슷한 결점이 있고 이런 문제가 발생하면 모든 것을 잃는다.

### 분산형 버전 관리 시스템(Distributed VCS) ###

분산형 버전 관리 시스템(DVCS)을 설명할 차례다. Git, Mecurial, Bazaar, Dearcs 같은 DVCS에서는 클라이언트가 파일의 마지막 Snapshot을 Checkout 하지 않는다. 그냥 저장소를 전부 복제한다. 서버에 문제가 생기면 이 복제물로 다시 작업을 시작할 수 있다. 클라이언트 중에서 아무거나 골라도 서버를 복원할 수 있다. 모든 Checkout은 모든 데이터를 가진 진정한 백업이다.

Insert 18333fig0103.png
그림 1-3. 분산형 버전 관리 시스템(DVCS) 다이어그램.

게다가 대부분의 DVCS 환경에서는 원격 저장소가 존재할 수 있다. 원격 저장소가 많다고 해도 문제없다. 그래서 사람들은 동시에 다양한 그룹과 다양한 방법으로 협업할 수 있다. 계층 모델 같은 중앙집중식 시스템으로는 할 수 없는 몇 가지 워크플로우도 사용할 수 있다.

## 짧게 보는 Git의 역사 ##

인생을 살다 보면 여러 가지 일들이 벌어지듯이 Git의 삶 또한 창조적인 파괴와 모순 속에서 시작되었다. 리눅스 커널은 굉장히 규모가 큰 오픈소스 프로젝트다. 리눅스 커널의 일생에서 대부분 시절은 패치와 단순 파일(Archived file)로만 관리했다. 2002년에 드디어 리눅스 커널은 BitKeeper라고 불리는 상용 DVCS를 사용하기 시작했다.

2005년에 커뮤니티가 만드는 리눅스 커널과 이익을 추구하는 회사가 개발한 BitKeeper의 관계는 틀어졌다. BitKeeper의 무료 사용이 제고된 것이다. 이 사건은 리눅스 개발 커뮤니티(특히 리눅스 창시자 리누스 토발즈)가 자체 도구를 만드는 계기가 됐다. Git은 BitKeeper를 사용하면서 배운 교훈을 기초로 다음과 같은 목표를 세웠다:

* 빠른 속도
* 단순한 구조
* 비선형적인 개발(수천 개의 동시 다발적인 브랜치)
* 완벽한 분산
* 리눅스 커널 같은 대형 프로젝트에도 유용할 것(속도나 데이터 크기 면에서)

Git은 2005년 탄생하고 나서 아직도 초기 목표를 그대로 유지하고 있으면서도 사용하기 쉽게 진화하고 성숙했다. Git은 미친 듯이 빨라서 대형 프로젝트에 사용하기도 좋다. Git은 동시다발적인 브랜치에도 끄떡없는 슈퍼 울트라 브랜칭 시스템이다 (3장 참고).

## Git 기초 ##

Git의 핵심은 뭘까? 이 질문은 Git을 이해하는데 굉장히 중요하다. Git이 무엇이고 어떻게 동작하는지 이해한다면 쉽게 Git을 효과적으로 사용할 수 있다. Git을 배우려면 Subversion이나 Perforce 같은 다른 VCS를 사용하던 경험을 지워버려야 한다. Git은 미묘하게 달라서 다른 VCS에서 쓰던 개념으로는 헷갈릴 거다. 사용자 인터페이스는 매우 비슷하지만, 정보를 취급하는 방식이 다르다. 이런 차이점들을 이해하면 Git을 사용하는 것이 어렵지 않다.

### 차이점이 아니라 Snapshot ###

Subversion과 Subversion 비슷한 놈들과 Git의 가장 큰 차이점은 데이터를 다루는 방법에 있다. 큰 틀에서 봤을 때 대부분의 VCS 시스템이 관리하는 정보는 파일들의 목록이다. CVS, Subversion, Perforce, Bazaar 등의 시스템은 파일의 집합으로 정보를 관리한다. 각 파일의 변화를 그림 1-4처럼 시간순으로 관리한다.

Insert 18333fig0104.png 
그림 1-4. 각 파일에 대한 변화(차이점)를 저장하는 시스템들.

Git은 이런 식으로 데이터를 저장하지도 취급하지도 않는다. 대신 Git의 데이터는 파일 시스템의 Snapshot이라 할 수 있으며 크기가 아주 작다. Git은 Commit 하거나 프로젝트의 상태를 저장할 때마다 파일이 존재하는 그 순간을 중요하게 여긴다. 파일이 달라지지 않았으면 Git은 성능을 위해서 파일을 저장하지 않는다. 단지 이전 상태의 파일에 대한 링크만 저장한다. Git은 그림 1-5처럼 동작한다.

Insert 18333fig0105.png 
그림 1-5. Git은 시간순으로 프로젝트의 Snapshot을 저장한다.

이것이 Git이 다른 VCS와 구분되는 점이다. Git은 이전 버전을 복사하는 다른 버전 관리 시스템들을 바보로 만들었다. Git은 강력한 도구를 지원하는 작은 파일시스템이다. Git은 단순한 VCS가 아니다. 이제 3장에서 설명할 Git 브랜치를 사용하면 얻게 되는 이득이 무엇인지 설명한다.

### 거의 모든 명령을 로컬에서 실행 ###

거의 모든 명령이 로컬 파일과 데이터만 사용하기 때문에 네트워크에 있는 다른 컴퓨터는 필요 없다. 대부분의 명령어가 네트워크의 속도에 영향을 받는 CVCS에 익숙하다면 Git이 매우 놀라울 것이다. Git의 이런 특징에서 나오는 미칠듯한 속도는 오직 Git느님만이 구사할 수 있는 초인적인 능력이다. 프로젝트의 모든 히스토리가 로컬 디스크에 있기 때문에 모든 명령을 순식간에 실행된다.

예를 들어 프로젝트의 히스토리를 조회하려 할 때 Git은 서버가 필요 없다. 그냥 로컬 데이터베이스에서 히스토리를 읽어서 보여 준다. 그래서 눈 깜짝할 사이에 히스토리를 조회할 수 있다. 어떤 파일의 현재 버전과 한 달 전의 상태를 비교해보고 싶을 때도 Git은 그냥 한 달 전의 파일과 지금의 파일을 로컬에서 찾는다. 파일을 비교하기 위해 원격에 있는 서버에 접근하고 나서 예전 버전을 가져올 필요가 없다.

즉 오프라인 상태에서도 비교할 수 있다. 비행기나 기차 등에서 작업하고 네트워크에 접속하고 있지 않아도 Commit 할 수 있다. 다른 VCS 시스템에서는 불가능한 일이다. Perforce는 서버에 연결할 수 없을 때 할 수 있는 일이 별로 없다. Subversion이나 CVS에서도 마찬가지다. 데이터베이스에 접근할 수 없어서 파일을 편집할 수는 있지만, Commit 할 수 없다. 매우 사소해 보이지만 실제로 이 상황에 부닥쳐보면 느껴지는 차이가 매우 크다.

### Git의 무결성 ###

Git은 모든 데이터를 저장하기 전에 체크섬(Checksum 또는 Hash)을 구하고 그 체크섬으로 데이터를 관리한다. 체크섬 없이 어떠한 파일이나 Directory도 변경할 수 없다. 체크섬은 Git에서 사용하는 가장 기본적인(Atomic) 데이터 단위이자 Git의 기본 철학이다. Git 없이는 체크섬을 다룰 수 없어서 파일의 상태도 알 수 없고 데이터를 잃어버릴 수도 없다.

Git은 SHA-1 Hash를 사용하여 체크섬을 만든다. 만든 체크섬은 40자 길이의 16진수 문자열이다. 파일의 내용이나 Directory 구조를 이용하여 체크섬을 구한다. SHA-1은 아래처럼 생겼다.

	24b9da6552252987aa493b52f8696cd6d3b00373

Git은 모든 것을 Hash로 식별하기 때문에 이런 값은 보일 것이다. 실제로 Git은 파일을 이름으로 저장하지 않고 해당 파일의 Hash로 저장한다.

### Git은 데이터를 추가할 뿐 ###

Git으로 무얼 하든 데이터가 추가된다. 되돌리거나 데이터를 삭제할 방법이 없다. 다른 VCS처럼 Git도 Commit 하지 않으면 변경사항을 잃어버릴 수 있다. 하지만, 일단 Snapshot을 Commit하고 나면 데이터를 잃어버리기 어렵다.

Git을 사용하면 프로젝트가 심각하게 망가질 걱정 없이 매우 즐겁게 여러 가지 실험을 해 볼 수 있다. Git이 데이터를 어떻게 저장하고 손실을 복구할 수 있는지 좀 더 알아보려면 9장 'Maintenance and Data Recovery'를 살펴본다.

### 세 가지 상태 ###

이 부분은 중요하기에 집중해서 읽어야 한다. Git을 공부하기 위해 반드시 짚고 넘어가야 할 부분이다. Git은 파일을 Commited, Modified, Staged 이렇게 세 가지 상태로 관리한다. Commited란 데이터가 로컬 데이터베이스에 안전하게 저장됐다는 것을 의미한다. Modified는 수정한 파일을 아직 로컬 데이터베이스에 Commit 하지 않은 것을 말한다. Staged란 현재 수정한 파일을 곧 Commit 할 것이라고 표시한 상태를 의미한다.

이 세 가지 상태는 Git 프로젝트의 세 가지 단계와 연결돼 있다. Git Directory, Working Directory, Staging Area 이 세 가지 단계를 이해하고 넘어가자.

Insert 18333fig0106.png 
그림 1-5. Working Directory, Staging Area, Git Directory

Git Directory는 Git이 프로젝트의 메타데이터와 객체 데이터베이스를 저장하는 곳을 말한다. Git Directory가 Git의 핵심이다. 다른 컴퓨터에 있는 저장소를 Clone 할 때 Git Directory가 만들어진다.

Working Directory는 프로젝트의 특정 버전을 Checkout 한 것이다. Git Directory는 지금 작업하는 디스크에 있고 그 Directory에 압축된 데이터베이스에서 파일을 가져와서 Working Directory를 만든다.

Staging Area는 Git Directory에 있다. 단순한 파일이고 곧 Commit 할 파일에 대한 정보를 저장한다. 인덱스처럼 단순히 Staging Area는 파일을 가리키는 것에 불과하다.

Git으로 하는 일은 기본적으로 다음과 같다:

- Working Directory에서 파일을 수정한다.
- Staging Area에 파일을 Stage 해서 Commit 할 Snapshot을 만든다.
- Staging Area에 있는 파일들을 Commit 해서 Git Directory에 영구적인 Snapshot으로 저장한다.

해당 작업이 독립적인 의미가 되면 Commit 한다. 파일을 수정하고 Staging Area에 추가했다면 단지 Staged 상태만 된 것이다. Checkout 한 후에 파일을 수정하고 Staged 상태로 만들지 않았다면 그냥 Modified 상태이다. 2장에서 이 상태들에 대해서 좀 더 배울 것이다. 2장에서는 이 상태들의 활용법과 Staged 단계를 사용하지 않는 방법도 배운다.

Git directory에 있는 파일들은 Committed 상태이다. 파일을 수정하고 Staging Area에 추가했다면 Staged이다. 그리고 Checkout하고 나서 수정했지만, 아직 Staging Area에 추가하지 않았으면 Modified이다. 2장에서 이 상태에 대해 좀 더 자세히 배운다. 특히 Staging Area를 어떻게 이용하는지 혹은 아예 생략하는 방법도 설명한다.

## Git 설치 ##

Git을 사용해 보려면 우선 설치해야 한다. 다양한 방법으로 Git을 설치할 수 있지만 가장 일반적인 방법은 두 가지가 있다. 하나는 소스코드로 컴파일하여 설치하는 방법이고 다른 하나는 각 운영체제(혹은 Platform)의 패키지를 사용하여 설치하는 방법이다.

### 소스코드로 설치하기 ###

소스코드로 설치하면 Git의 가장 최신 버전을 설치할 수 있기 때문에 컴파일하여 설치할 시간이 있으면 소스코드로 Git을 설치하는 것이 좋다. Git은 계속 UI를 개선하고 있기 때문에 최신 버전을 사용하면 좋은 기능을 빨리 사용할 수 있다. 리눅스 패키지는 보통 최신 버전이 아니고 예전 버전이다. 그래서 Backport를 사용하거나 소스코드로 설치하는 것도 좋은 대안이다.

Git을 설치하려면 다음과 같은 라이브러리들이 필요하다. Git은 curl, zlib, openssl, expat, libiconv를 필요로 한다. 예를 들어 Fedora처럼 yum을 가지는 시스템을 사용하고 있거나 apt-get이 있는 데비안류 시스템을 사용하면 다음의 명령어를 실행하여 의존 패키지를 설치할 수 있다:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

필요한 라이브러리를 모두 설치하고 다음 단계를 진행한다. Git 웹 사이트에서 최신 Snapshot을 가져온다:

	http://git-scm.com/download
	
그리고 컴파일하고 설치한다:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

설치한 다음부터는 Git을 사용하여 Git 소스코드를 갱신할 수 있다:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### 리눅스에 설치 ###

리눅스에서 패키지로 Git을 설치할 때에는 보통 각 배포판에서 사용하는 패키지 관리도구를 사용하여 설치한다. Fedora에서는 다음과 같이 한다:

	$ yum install git-core

Ubuntu같은 데비안류 배포판에서는 apt-get을 사용한다:

	$ apt-get install git-core

### Mac에 설치하기 ###

Mac에 Git을 쉽게 설치하는 방법은 두 가지가 있다. GUI 인스톨러를 사용하기가 가장 쉽다. Google Code 페이지에서 내려받는다:

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
그림 1-7. OS X Git 인스톨러.

MacPorts(`http://www.macports.org`)를 사용하는 방법도 있다. MacPorts가 설치돼 있으면 다음과 같이 Git을 설치한다:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

이제 설치는 했다. 만약 Subversion 저장소를 Git과 함께 사용해야 하면 svn도 필요하다.

### 윈도우에 설치 ###

Git을 윈도우에 설치하기도 쉽다. 그저 구글 코드 페이지에서 msysGit 인스톨러를 내려받고 실행하면 된다:

	http://code.google.com/p/msysgit

설치가 완료되면 CLI 프로그램과 GUI 프로그램을 둘 다 사용할 수 있다. CLI 프로그램에는 SSH 클라이언트가 포함돼 있기 때문에 유용하다.

## Git 최초 설정 ##

Git을 설치하고 나면 Git의 사용 환경을 적절히 설정해 주어야 한다. 한 번만 설정하면 된다. 설정한 내용은 Git을 업그레이드해도 유지된다. 또한, 명령어로 언제든지 다시 바꿀 수 있다.

Git은 'git config'라는 도구로 설정 내용을 확인하고 변경할 수 있다. Git은 이 설정에 따라 동작한다. 이 설정 파일은 세 가지나 된다.

* `/etc/gitconfig` 파일: 시스템의 모든 사용자와 모든 저장소에 적용되는 설정이다. `git config --system` 옵션으로 이 파일을 읽고 쓸 수 있다.
* `~/.gitconfig` 파일: 특정 사용자에게만 적용되는 설정이다. `git config --global` 옵션으로 이 파일을 읽고 쓸 수 있다.
* `.git/config`: 이 파일은 Git Directory에 있고 특정 저장소(혹은 현재 작업 중인 프로젝트)에만 적용된다. 각 설정은 역순으로 우선시 된다. 그래서 `.git/config`가 `/etc/gitconfig`보다 우선한다.

윈도우에서 Git은 `$HOME` Directory(`C:\Documents and Settings\$USER`)에 있는 `.gitconfig` 파일을 찾는다. 그리고 msysGit도 /etc/gitconfig를 가지고 있다. 경로는 MSys 루트에 따른 상대 경로다. 인스톨러로 msysGit을 설치할 때 설치 경로를 선택할 수 있다.

### 사용자 정보 ###

Git을 설치하고 나서 가장 먼저 해야 하는 것은 사용자 이름과 이메일 주소를 설정하는 것이다. Git은 Commit 할 때마다 이 정보를 사용한다. 한 번 Commit 한 후에는 정보를 변경할 수 없다.

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

다시 말하자면 `--global` 옵션으로 설정한 것은 딱 한 번만 하면 된다. 해당 시스템에서 해당 사용자가 사용할 때에는 이 정보를 사용한다. 만약 프로젝트마다 다른 이름과 이메일 주소를 사용하고 싶으면 `--global` 옵션을 빼고 명령을 실행한다.

### 편집기 ###

사용자 정보를 설정하고 나면 Git에서 사용할 텍스트 편집기를 고른다. 기본적으로 Git은 시스템의 기본 편집기를 사용하고 보통 이것은 Vi나 Vim이다. 하지만, Emacs 같은 다른 텍스트 편집기를 사용하고 싶다면 다음과 같이 실행한다.:

	$ git config --global core.editor emacs

### Diff 도구 ###

Merge 충돌을 해결하기 위해 사용하는 Diff 도구를 설정할 수 있다. vimdiff를 사용하고 싶으면 다음과 같이 실행한다:

	$ git config --global merge.tool vimdiff

이렇게 kdiff3, tkdiff, meld, xxdif, emerge, vimdiff, gvimdiff, ecmerge, opendiff를 사용할 수 있다. 물론 다른 도구도 사용할 수 있다. 자세한 내용은 7장에서 다룬다.

### 설정 확인 ###

`git config --list` 명령을 실행하면 모든 설정 내용을 확인할 수 있다:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Git은 같은 키를 여러 파일(`/etc/gitconfig`와 `~/.gitconfig`같은)에서 읽기 때문에 같은 키가 하나 이상 나올 수도 있다. 이 경우에 Git은 나중 값을 사용한다.

`git config {key}` 명령으로 Git이 특정 Key에 대해 어떤 값을 사용하는지 확인할 수 있다:

	$ git config user.name
	Scott Chacon

## 도움말 보기 ##

명령어에 대한 도움말이 필요할 때 도움말을 보는 방법은 세 가지이다:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

예를 들어 다음과 같이 실행하면 config 명령에 대한 도움말을 볼 수 있다:

	$ git help config

도움말은 언제 어디서나 볼 수 있다. 오프라인 상태에서도 가능하다. 도움말과 이 책으로 부족하면 다른 사람의 도움을 받는 것이 필요하다. Freenode IRC 서버(irc.freenode.net)에 있는 `#git`이나 `#github` 채널로 찾아가라. 이 채널은 보통 수백 명의 사람이 접속해 있다. 이 사람들은 모두 Git에 대해 잘 알고 있다. 기꺼이 도와줄 것이다.

## 요약 ##

우리는 Git이 무엇이고 지금까지 사용해 왔던 다른 CVCS와 어떻게 다른지 배웠다. 시스템에 Git을 설치하고 사용자 정보도 설정했다. 다음 장에서는 Git의 사용법을 배운다.
