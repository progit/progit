# Git 서버 #

이 글을 읽는 독자라면 이미 하루 업무의 대부분을 Git으로 처리할 수 있을 거라고 생각한다. 이제는 다른 사람과 협업하는 방법을 고민해보자. 다른 사람과 협업하려면 리모트 저장소가 필요하다. 물론 혼자서 저장소를 만들고 거기에 Push하고 Pull할 수도 있지만 이렇게 하는 것은 아무 의미가 없다. 이런 방식으로는 다른 사람이 무슨 일을 하고 있는지 알려면 항상 지켜보고 있어야 간신히 알 수 있을 터이다. 당신 컴퓨터가 오프라인일 때에도 동료가 저장소를 사용할 수 있도록 언제나 이용할 수 있는 저장소가 필요하다. 즉, 공동으로 사용할 수 있는 저장소를 만들고 모두 이 저장소에 접근하여 Push, Pull할 수 있어야 한다. 우리는 이 저장소를 "Git 서버"라고 부른다. Git 저장소를 운영하는데 자원이 많이 필요하지도 않아서 별도로 Git 서버를 준비하지 않아도 된다.

Git 서버를 운영하는 것은 어렵지 않다. 우선 사용할 전송 프로토콜부터 정한다. 이 장의 앞부분에서는 어떤 프로토콜이 있는지 그리고 각 장단점은 무엇인지 살펴본다. 그다음엔 각 프로토콜을 사용하는 방법과 그 프로토콜을 사용할 수 있도록 서버를 구성하는 방법을 살펴본다. 마지막으로 다른 사람의 서버에 내 코드를 맡기긴 싫고 고생스럽게 서버를 설치하고 관리하고 싶지도 않을 때 고를 수 있는 선택지가 어떤 것들이 있는지 살펴본다.

서버를 직접 설치해서 운영할 생각이 없으면 이 장의 마지막 절만 읽어도 된다. 마지막 절에서는 Git 호스팅 서비스에 계정을 만들고 사용하는 방법에 대해 설명한다. 그리고 다음 장에서는 분산 환경에서 소스를 관리하는 다양한 패턴에 대해 논의할 것이다.

리모트 저장소는 일반적으로 워킹 디렉토리가 없는 _Bare 저장소_ 이다. 이 저장소는 협업용이기 때문에 체크아웃이 필요 없다. 그냥 Git 데이터만 있으면 된다. 다시 말해서 Bare 저장소는 일반 프로젝트에서 `.git` 디렉토리만 있는 저장소다.

## 프로토콜 ##

Git은 Local, SSH, Git, HTTP 이렇게 네 가지의 네트워크 프로토콜을 사용할 수 있다. 이 절에서는 각각 어떤 경우에 유용한지 살펴볼 것이다.

HTTP 프로토콜을 제외한 나머지들은 모두 Git이 서버에 설치돼 있어야 한다.

### 로컬 프로토콜 ###

가장 기본적인 것이 _로컬 프로토콜_ 이다. 리모트 저장소가 단순히 디스크의 다른 디렉토리에 있을 때 사용한다. 팀원들이 전부 한 시스템에 로그인하여 개발하거나 아니면 NFS같은 것으로 파일시스템을 공유하고 있을 때 사용한다. 전자는 문제가 될 수 있다. 모든 저장소가 한 시스템에 있기 때문에 한순간에 모두 잃을 수 있다.

공유 파일시스템을 마운트했을 때는 로컬 저장소를 사용하는 것처럼 Clone하고 Push하고 Pull하면 된다. 일단 저장소를 Clone하거나 프로젝트에 리모트 저장소로 추가한다. 추가할 때 URL 자리에 저장소의 경로를 사용한다. 예를 들어 아래와 같이 로컬 저장소를 Clone한다:

	$ git clone /opt/git/project.git

아래 처럼도 가능하다:

	$ git clone file:///opt/git/project.git

Git은 파일 경로를 직접 쓸 때와 `file://`로 시작하는 URL을 사용할 때에 약간 다르게 처리한다. 디렉토리 경로를 사용해서 같은 파일시스템에 있는 저장소를 Clone할 때 Git은 하드링크를 만든다. 같은 파일시스템에 있는게 아니면 그냥 복사한다. 하지만 `file://`로 시작하면 Git은 네트워크를 통해서 데이터를 전송할 때처럼 프로세스를 별도로 생성하여 처리한다. 이 프로세스로 데이터를 전송하는 것은 효율이 좀 떨어지지만 그래도 `file://`를 사용하는 이유가 있다. 보통은 다른 버전 관리 시스템들에서 임포트한 후에 이렇게 사용하는데, 외부 레퍼런스나 개체들이 포함된 저장소의 복사본을 깨끗한 상태로 남겨두고자 할때 사용한다(*9장*에서 자세히 다룬다). 여기서는 속도가 빠른 디렉토리 경로를 사용한다.

이미 있는 Git 프로젝트에서 아래와 같이 로컬 저장소를 추가한다:

	$ git remote add local_proj /opt/git/project.git

그러면 네트워크에 있는 리모트 저장소처럼 Push하고 Pull할 수 있다.

#### 장점 ####

파일 기반 저장소는 단순한 것이 장점이다. 기존에 있던 네트워크나 파일의 권한을 그대로 사용하기 때문에 설정하기 쉽다. 이미 팀 전체가 접근 가능한 파일시스템이 있으면 저장소를 아주 쉽게 구성할 수 있다. 디렉토리를 공유하듯이 동료가 모두 읽고 쓸 수 있는 공유 디렉토리에 Bare 저장소를 만든다. 다음 절인 "서버에 Git 설치하기"에서 Bare 저장소를 만드는 방법을 살펴볼 것이다.

또한, 동료가 작업하는 저장소에서 한 일을 바로 가져오기에도 좋다. 만약 함께 프로젝트를 하는 동료가 자신이 한 일을 당신이 확인해 줬으면 한다. 이럴 때 그 동료가 서버에 Push하고 당신이 다시 Pull할 필요없이 `git pull /home/john/project` 라는 명령어를 바로 실행시켜서 매우 쉽게 동료의 코드를 가져올 수 있다.

#### 단점 ####

다양한 상황에서 접근할 수 있도록 디렉토리를 공유하는 것 자체가 일반적으로 어렵다. 집에 있을 때 Push하려면 리모트 저장소가 있는 디스크를 마운트해야 하는데 이것은 다른 프로토콜을 이용하는 방법보다 느리고 어렵다.

게다가 네트워크 파일시스템을 마운트해서 사용하는 중이라면 별로 빠르지도 않다. 로컬 저장소는 데이터를 빠르게 읽을 수 있을 때만 빠르다. NFS에 있는 저장소에 Git을 사용하는 것은 보통 같은 서버에 SSH로 접근하는 것보다 느리다.

### SSH 프로토콜 ###

Git의 대표 프로토콜은 SSH이다. 대부분 서버는 SSH로 접근할 수 있도록 설정돼 있다. 뭐, 설정돼 있지 않더라도 쉽게 설정할 수 있다. 그리고 SSH는 읽기/쓰기 접근을 쉽게 할 수 있는 유일한 네트워크 프로토콜이다. 다른 네트워크 프로토콜인 HTTP와 Git은 일반적으로 읽기만 가능하다. 그래서 초보자(unwashed masses)라고 해도 쓰기 명령을 이용하려면 SSH가 필요하다. SSH는 또한 인증도 지원한다. SSH는 보통 유비쿼터스 적이면서도, 사용하기도, 설치하기도 쉽다.

SSH를 통해 Git 저장소를 Clone하려면 `ssh://`로 시작하는 URL을 사용한다:

	$ git clone ssh://user@server/project.git

아니면 scp 명령어처럼 사용할 수 있다. 이게 조금 더 짧다:

	$ git clone user@server:project.git

사용자 계정을 생략할 수도 있는데 계정을 생략하면 Git은 현재 로그인한 사용자의 계정을 사용한다.

#### 장점 ####

SSH는 장점이 매우 많은 프로토콜이다. 첫째, 누가 리모트에서 저장소에 접근하는지 알고 싶다면 SSH를 사용해야 한다. 둘째, SSH는 상대적으로 설정하기 쉽다. SSH 데몬은 정말 흔하다. 거의 모든 네트워크 관리자는 SSH 데몬을 다루어본 경험을 가지고 있을것이고, 대부분의 OS 배포판에는 SSH 데몬과 관리도구가 들어 있다. 셋째, SSH를 통해 접근하면 보안에 안전하다. 모든 데이터는 암호화되어 인증된 상태로 전송된다. 마지막으로 SSH는 전송 시 데이터를 가능한 압축하기 때문에 효율적이다.

#### 단점 ####

SSH의 단점은 익명으로 접근할 수 없다는 것이다. 심지어 읽기 전용인 경우에도 익명으로 시스템에 접근할 수 없다. 회사에서만 사용할 것이라면 SSH가 가장 적합한 프로토콜일 것이지만 오픈소스 프로젝트는 SSH만으로는 부족하다. 만약 사람들이 프로젝트에 익명으로 접근할 수 있게 하려면, 자신이 Push할 때 사용할 SSH를 설치하는 것과 별개로 다른 사람들이 Pull할 때 사용할 다른 프로토콜을 추가해야 한다.

### Git 프로토콜 ###

Git 프로토콜은 Git에 포함된 데몬을 사용하는 방법이다. 포트는 9418이며 SSH 프로토콜과 비슷한 서비스를 제공하지만, 인증 메커니즘이 없다. 저장소에 git-export-daemon-ok 파일을 만들면 Git 프로토콜로 서비스할 수 있지만, 보안은 없다. 이 파일이 없는 저장소는 Git 프로토콜로 서비스할 수 없다. 이 저장소는 누구나 Clone할 수 있거나 아무도 Clone할 수 없거나 둘 중의 하나만 선택할 수 있다. 그래서 이 프로토콜로는 Push를 가능하게 설정할 수 없다. 엄밀히 말해서 Push할 수 있도록 설정할 수 있지만, 인증하도록 할 수 없다. 그러니까 당신이 Push할 수 있으면 이 프로젝트의 URL을 아는 사람은 누구나 Push할 수 있다. 그냥 이런 것도 있지만 잘 안 쓴다고 알고 있으면 된다.

#### 장점 ####

Git 프로토콜은 전송속도가 가장 빠르다. 전송량이 많은 공개 프로젝트나 별도의 인증이 필요 없고 읽기만 허용하는 프로젝트를 서비스할 때 유용하다. 암호화와 인증을 빼면 SSH 프로토콜과 전송 메커니즘이 별반 다르지 않다.

#### 단점 ####

Git 프로토콜은 인증 메커니즘이 없는게 단점이다. Git 프로토콜만 사용하는 프로젝트는 바람직하지 못하다. 일반적으로 SSH 프로토콜과 함께 사용한다. 소수의 개발자만 Push할 수 있고 대다수 사람은 `git://`을 사용하여 읽을 수만 있게 한다. 어쩌면 가장 설치하기 어려운 방법일 수도 있다. 별도의 데몬이 필요하고 프로젝트에 맞게 설정해야 한다. 이 장의 Gitosis 절에서 설정하는 법을 살펴볼 것이다. 자원을 아낄 수 있도록 xinetd 같은 것도 설정해야 하고 방화벽을 통과할 수 있도록 9418 포트도 열어야 한다. 이 포트는 일반적으로 회사들이 허용하는 표준 포트가 아니다. 규모가 큰 회사라면 당연히 방화벽에서 이 포트를 막아 놓는다.

### HTTP/S 프로토콜 ###

마지막으로, HTTP 프로토콜이 있다. HTTP와 HTTPS 프로토콜의 미학은 설정이 간단하다는 점이다. HTTP 도큐먼트 루트 밑에 Bare 저장소를 두고 post-update 훅을 설정하는 것이 기본적으로 해야 하는 일의 전부다(*7장*에서 Git 훅에 대해 자세히 다룰 것이다). 저장소가 있는 웹 서버에 접근할 수 있다면 그 저장소를 Clone할 수도 있다. HTTP를 통해서 저장소를 읽을 수 있게 하려면 아래와 같이 한다:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

post-update 훅은 Git에 포함되어 있으며 `git update-server-info`라는 명령어를 실행시킨다. 이 명령어는 HTTP로 Fetch와 Clone 명령이 잘 동작하게 한다. SSH를 통해서 저장소에 Push할 때 실행되며, 사람들은 아래와 같이 Clone한다:

	$ git clone http://example.com/gitproject.git

여기서는 Apache 서버가 기본으로 사용하는 `/var/www/htdocs`을 루트 디렉토리로 사용하지만 다른 웹 서버를 사용해도 된다. 단순히 Bare 저장소를 HTTP 문서 루트에 넣으면 된다. Git 데이터는 일반적인 정적 파일처럼 취급된다(*9장*에서 정확히 어떻게 처리하는지 다룰 것이다).

HTTP를 통해서 Push하는 것도 가능하다. 단지 이 방법은 잘 사용하지 않는 WebDAV 환경을 완벽하게 구축해야 한다. 잘 사용하지 않기 때문에 이 책에서도 다루지 않는다. HTTP 프로토콜로 Push하고 싶으면 `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` 을 읽고 저장소를 만들면 된다. HTTP를 통해서 Push하는 방법의 좋은 점은 WebDAV 서버를 아무거나 골라 쓸 수 있다는 것이다. 그래서 WebDAV를 지원하는 웹 호스팅 업체를 이용하면 이 기능을 사용할 수 있다.

#### 장점 ####

HTTP 프로토콜은 설정하기 쉽다는 것이 장점이다. 몇 개의 필수 명령어만 실행하면 세계 어디에서나 당신의 저장소에 접근할 수 있게 만들 수 있다. 이렇게 하는데 몇 분이면 충분하다. HTTP 프로토콜은 서버의 리소스를 많이 잡아먹지도 않는다. 보통은 정적 HTTP 서버만으로도 충분하기 때문에 흔한 Apache 서버로 초당 수천 개의 파일을 처리할 수 있다. 작은 서버로도 충분히 감당할 수 있다.

또 HTTPS를 사용해서 서비스할 수도 있기 때문에 전송하는 데이터를 암호화할 수 있다. 그리고 클라이언트가 서명된 SSL 인증서를 사용하게 할 수도 있다. 이렇게 하더라도 SSH 공개키를 사용하는 방식보다 쉽다. 서명한 SSL 인증서를 사용하는 게 나을 때도 있고 단순히 HTTPS위에서 HTTP기반 인증을 사용하는 게 나을 때도 있다.

HTTP는 매우 보편적인 프로토콜이라서 거의 모든 회사가 트래픽이 방화벽을 통과하도록 허용한다는 장점도 있다.

#### 단점 ####

클라이언트에서는 HTTP가 좀 비효율적이다. 저장소에서 Fetch하거나 Clone할 때 좀 더 오래 걸린다. 다른 프로토콜의 네트워크 오버헤드보다 HTTP의 오버헤드가 좀 더 크다. 지능적으로 정말 필요한 데이터만 전송하지 않기 때문에 HTTP 프로토콜은 _멍청한_ 프로토콜(Dumb Protocol)이라고도 부른다. 효율적으로 전송하고자 서버는 아무것도 하지 않는다. HTTP와 다른 프로토콜의 성능 차이는 *9장*에서 자세히 설명한다.

## 서버에 Git 설치하기 ##

어떤 서버를 설치하더라도 일단 저장소를 Bare 저장소로 만들어야 한다. 다시 말하지만, Bare 저장소는 워킹 디렉토리가 없는 저장소이다. `--bare` 옵션을 주고 Clone하면 새로운 Bare 저장소가 만들어진다. Bare 저장소 디렉토리는 관례에 따라. git 확장자로 끝난다:

	$ git clone --bare my_project my_project.git
	Cloning into bare repository 'my_project.git'...
	done.

<!-- This next part doesn't fit the actual output as shown, the confusing part
     of the output is no longer shown in the command output. I would like to asks
     the original author to modify the text.
-->

이 명령이 출력하는 메시지가 조금 이상해보일 수도 있다.  사실 `git clone` 명령은 `git init`을 하고 나서 `git fetch`를 실행한다. 그런데 빈 디렉토리밖에 만들지 않는 `git init` 명령의 메시지만 보여준다. 개체 전송에 관련된 메시지는 아무것도 보여주지 않는다. 전송 메시지를 보여주지 않지만 `my_project.git` 디렉토리를 보면 Git 데이터가 들어 있다.

아래와 같이 실행한 것과 비슷하다:

	$ cp -Rf my_project/.git my_project.git

물론 설정 상의 미세한 차이가 있지만, 저장소의 내용만 고려한다면 같다고 볼 수 있다. 워킹 디렉토리가 없는 Git 저장소인 데다가 별도의 디렉토리도 하나 만들었다는 점에서는 같다.

### 서버에 Bare 저장소 넣기 ###

Bare 저장소는 이제 만들었으니까 서버에 넣고 프로토콜을 설정한다. `git.example.com`라는 이름의 서버를 하나 준비하자. 그리고 그 서버에 SSH로 접속할 수 있게 하고 `/opt/git`에 Git 저장소를 만든다. 아래와 같이 Bare 저장소를 복사한다:

	$ scp -r my_project.git user@git.example.com:/opt/git

이제 다른 사용자들은 SSH로 서버에 접근해서 저장소를 Clone할 수 있다. 사용자는 `/opt/git` 디렉토리에 읽기 권한이 있어야 한다:

	$ git clone user@git.example.com:/opt/git/my_project.git

이 서버에 SSH로 접근할 수 있는 사용자가 `/opt/git/my_project.git` 디렉토리에 쓰기 권한까지 가지고 있으면 바로 Push할 수 있다. `git init` 명령에 `--shared` 옵션을 추가하면 Git은 자동으로 그룹 쓰기 권한을 추가한다:

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Git 저장소를 만드는 것이 얼마나 쉬운지 살펴보았다. Bare 저장소를 만들어 SSH로 접근할 수 있는 서버에 올리면 동료와 함께 일할 준비가 끝난다.

그러니까 Git 서버를 구축하는데 사람이 할 일은 정말 별로 없다. SSH로 접속할 수 있도록 서버에 계정을 만들고 Bare 저장소를 사람들이 읽고 쓸 수 있는 곳에 넣어 두기만 하면 된다. 다른 것은 아무것도 필요 없다.

다음 절에서는 좀 더 정교하게 설정하는 법을 살펴본다. 사용자에게 계정을 만들어 주는 법, 저장소를 읽고 쓸 수 있게 하는 법, Web UI를 설정하는 법, Gitosis를 사용하는 법, 등등은 여기에서 설명하지 않는다. 꼭 기억해야 할 것은 동료와 함께 개발할 때 꼭 필요한 것이 SSH 서버와 Bare 저장소뿐이라는 것이다.

### 바로 설정하기 ###

만약 창업을 준비하고 있거나 회사에서 Git을 막 도입하려고 할 때처럼 사용할 개발자의 수가 많지 않을 때에는 설정할 게 별로 없다. Git 서버 설정에서 사용자 관리가 가장 골치 아프다. 사람이 많으면 어떤 사용자는 읽기만 가능하게 하고 어떤 사용자는 읽고 쓰기 둘 다 가능하게 하는 것이 좀 까다롭다.

#### SSH 접근 ####

만약 모든 개발자가 SSH로 접속할 수 있는 서버가 있으면 너무 쉽게 저장소를 만들 수 있다. 앞서 말했듯이 할 일이 별로 없다. 저장소의 권한을 꼼꼼하게 관리해야 하면 그냥 운영체제의 파일시스템 권한관리를 이용한다. 동료가 저장소에 쓰기 접근을 해야 하는 데 아직 SSH로 접속할 수 있는 서버가 없으면 하나 마련해야 한다. 아마 독자에게 서버가 있다면 그 서버에는 이미 SSH 서버가 설치돼 있어서 이미 SSH로 접속하고 있을 것이다.

동료가 접속하도록 하는 방법은 몇 가지가 있다. 첫째로 모두에게 계정을 만들어 주는 방법이 있다. 이 방법이 제일 단순하지만 다소 귀찮은 방법이다. 팀원마다 adduser를 실행시키고 임시 암호를 부여해야 하기 때문에 보통 이 방법을 쓰고 싶어 하지 않는다.

둘째로 서버마다 git이라는 계정을 하나씩 만드는 방법이 있다. 쓰기 권한이 필요한 사용자의 SSH 공개키를 모두 모아서 git 계정의 `~/.ssh/authorized_keys`파일에 모든 키를 입력한다. 그러면 모두 git 계정으로 그 서버에 접속할 수 있다. 이 git 계정은 커밋 데이터에는 아무런 영향을 주지 않는다. 다시 말해서 접속하는 데 사용한 SSH 계정과 커밋에 저장되는 사용자는 아무 상관없다.

이미 LDAP 서버 같은 중앙집중식 인증 소스를 가지고 있으면 SSH 서버가 해당 인증을 이용하도록 할 수도 있다. SSH 인증 메커니즘 중 아무거나 하나 이용할 수 있으면 그 서버에 접속이 가능하다.

## SSH 공개키 만들기 ##

이미 말했듯이 많은 Git 서버들은 SSH 공개키로 인증한다. 공개키를 사용하려면 일단 공개키를 만들어야 한다. 공개키를 만드는 방법은 모든 운영체제가 비슷하다. 먼저 키가 있는지부터 확인하자. 사용자의 SSH 키들은 기본적으로 사용자의 `~/.ssh` 디렉토리에 저장한다. 그래서 만약  디렉토리의 파일을 살펴보면 공개키가 있는지 확인할 수 있다:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

something, something.pub이라는 형식으로 된 파일을 볼 수 있다. something은 보통 `id_dsa`나 `id_rsa`라고 돼 있다. 그중 `.pub`파일이 공개키이고 다른 파일은 개인키이다. 만약 이 파일이 없거나 `.ssh` 디렉토리도 없으면 `ssh-keygen`이라는 프로그램으로 키를 생성해야 한다. `ssh-keygen` 프로그램은 리눅스나 Mac의 SSH 패키지에 포함돼 있고 윈도는 MSysGit 패키지 안에 들어 있다:

	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

먼저 키를 어디에 저장할지 경로를(`.ssh/id_rsa`) 입력하고 암호를 두 번 입력한다. 이때 암호를 비워두면 키를 사용할 때 암호를 묻지 않는다.

사용자는 그 다음에 자신의 공개기를 Git 서버 관리자에게 보내야 한다. 사용자는 `.pub` 파일의 내용을 복사하여 메일을 보내기만 하면 된다. 공개키는 아래와 같이 생겼다:

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

다양한 운영 체제에서 SSH 키를 만드는 방법이 궁금하면 `http://github.com/guides/providing-your-ssh-key`에 있는 Github 설명서를 찾아보는 게 좋다.

## 서버에 설정하기 ##

서버에 설정하는 일을 살펴보자. 일단 Ubuntu같은 표준 리눅스 배포판을 사용한다고 가정한다. 사용자는 아마도 `authorized_keys` 파일로 인증할 것이다. 먼저 `git` 계정을 만들고 사용자 홈 디렉토리에 .ssh 디렉토리를 만든다:

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

`authorized_keys` 파일에 SSH 공개키를 추가해야 사용자가 접근할 수 있다. 추가하기 전에 이미 이메일로 공개키를 몇 개 받아서 가지고 있다고 가정하자. 공개키가 어떻게 생겼는지 다시 한번 확인한다:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

`authorized_keys` 파일에 추가한다:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

`--bare` 옵션을 주고 `git init`을 실행해서 워킹 디렉토리가 없는 빈 저장소를 하나 만든다:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

이제 John씨, Josie씨, Jessica씨는 이 저장소를 리모트 저장소로 등록하면 브랜치를 Push할 수 있다. 프로젝트마다 적어도 한 명은 서버에 접속하여 Bare 저장소를 만들어야 한다. git 계정과 저장소를 만든 서버의 호스트 이름이 `gitserver`라고 하자. 만약 이 서버가 내부망에 있으면 `gitserver`가 그 서버를 가리키도록 DNS에 설정한다. 그러면 명령을 아래와 같이 사용할 수 있다:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

이제 이 프로젝트를 Clone하고 나서 수정하고 Push한다:

	$ git clone git@gitserver:/opt/git/project.git
	$ cd project
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

개발자들이 읽고 쓸 수 있는 Git 서버를 간단하게 만들었다.

그리고 `git-shell`이라는 걸 사용해서 보안을 강화할 수 있다. 이 쉘로 git 계정을 사용하는 사용자들이 Git 말고 다른 것을 할 수 없도록 제한하는 것이다. git 계정의 로그인 쉘을 이것으로 설정하면 `git` 사용자는 일반적인 쉘을 사용할 수 없다. 통상의 bash, csh 대신에 `git-shell`을 로그인 쉘로 설정하기만 하면 된다. 이것을 하려면 `/etc/passwd` 파일을 편집한다:

	$ sudo vim /etc/passwd

그리고 아래와 같은 줄을 찾는다:

	git:x:1000:1000::/home/git:/bin/sh

`/bin/sh`를 `/usr/bin/git-shell`로(`which git-shell` 명령으로 어디에 설치됐는지 확인하는게 좋다) 변경한다:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

이제 `git` 계정은 Git 저장소에 Push하고 Pull하는 것만 가능하고 서버의 쉘에는 접근할 수 없다. 실제로 로그인을 해보면 아래와 같은 메시지로 로그인이 거절된다:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## 공개하기 ##

익명의 사용자에게 읽기 접근을 허용하고 싶을 때는 어떻게 해야 할까? 프로젝트를 비공개가 아니라 오픈 소스 프로젝트로 공개한다거나 자동 빌드 서버나 CI(Continuous Integration) 서버가 많아서 계정마다 하나하나 설정해야 할 수 있다. 아니면 그냥 매번 SSH 키를 생성하는 게 귀찮을 수도 있다. 그러니까 그냥 간단하게 익명의 사용자도 읽을 수 있도록 하고 싶을 때는 어떻게 해야 할까?

분명 웹 서버를 설치하는 것이 가장 쉬운 방법이다. 이 장의 첫 부분에 설명했듯이 웹 서버를 설치하고 Git 저장소를 문서 루트 디렉토리에 두고 `post-update` 훅을 켜기만 하면 된다. 먼저 설명했던 예제를 따라 해보자. `/opt/git` 디렉토리에 저장소가 있고 서버에 Apache가 설치돼 있다고 가정하자. 아무 웹 서버나 다 사용할 수 있지만, 이 예제에서는 Apache를 사용한다. 여기에서는 이해하는 것이 목적이므로 아주 기본적인 Apache 설정만을 보여줄 것이다.

먼저 이 훅을 설정해야 한다:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

`post-update` 훅은 무슨 일을 할까? 기본적으로 다음과 같다:

	$ cat .git/hooks/post-update
	#!/bin/sh
	#
	# An example hook script to prepare a packed repository for use over
	# dumb transports.
	#
	# To enable this hook, rename this file to "post-update".
	#
	
	exec git-update-server-info

SSH를 통해서 서버에 Push하면 Git은 이 명령어를 실행하여 HTTP를 통해서도 Fetch할 수 있도록 파일를 갱신한다.

그다음 Apache 설정에 VirtualHost 항목을 추가한다. 이 항목에서 문서 루트가 Git 저장소의 루트 디렉토리가 되도록 한다. 그리고 `*.gitserver`로 접속하는 사람들이 모두 이 서버에 접속하도록 한다. 와일드카드를 이용하여 VirtualHost항목을 아래와 같이 설정한다:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

그리고 Apache 서버는 `www-data` 권한으로 CGI 스크립트를 실행시키기 때문에 `/opt/git` 디렉토리의 그룹 소유 권한을 `www-data`로 수정해 주어야 웹 서버로 접근하는 사용자들이 읽을 수 있다.

	$ chgrp -R www-data /opt/git

Apache를 재시작하면 아래와 같은 URL로 저장소를 Clone할 수 있다:

	$ git clone http://git.gitserver/project.git

이렇게 사용자들이 HTTP로 프로젝트에 접근하도록 설정하는 데 몇 분밖에 걸리지 않는다. 그리고 Git 데몬으로도 똑같이 인증 없이 접속하게 할 수 있다. 프로세스를 데몬으로 만들어야 한다는 단점이 있지만 가능하다. 이것은 다음 절에서 살펴볼 것이다.

## GitWeb ##

프로젝트 저장소를 단순히 읽거나 쓰는 것에 대한 설정은 다뤘다. 이제는 웹 기반 인터페이스를 설정해보자. Git에는 GitWeb이라는 CGI 스크립트를 제공해서 쉽게 웹에서 저장소를 조회하도록 할 수 있다. `http://git.kernel.org`같은 사이트에서 GitWeb을 구경할 수 있다(그림 4-1).

Insert 18333fig0401.png
그림 4-1. Git 웹용 UI, GitWeb

Git은 GitWeb을 쉽게 사용해 볼 수 있도록 서버를 잠시 띄우는 명령을 제공한다. 시스템에 `lighttpd`나 `webrick` 같은 경량 웹서버가 설치돼 있어야 이 명령을 사용할 수 있다. 리눅스에서는 `lighttpd`가 설치돼 있을 확률이 높고 프로젝트 디렉토리에서 그냥 `git instaweb`을 실행하면 바로 실행된다. Mac의 Leopard 버전은 Ruby가 미리 설치돼 있기 때문에 `webrick`이 더 낫다. lighttpd이 아니라면 아래와 같이 `--httpd` 옵션을 사용해야 한다:

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

1234 포트로 HTTPD 서버를 시작하고 이 페이지를 여는 웹브라우저를 자동으로 실행시킨다. 꽤 편리하다. 필요한 일을 모두 마치고 나서 같은 명령어에 `--stop` 옵션을 추가하여 서버를 중지한다:

	$ git instaweb --httpd=webrick --stop

항상 접속가능한 웹 인터페이스를 운영하려면 먼저 웹서버에 이 CGI 스크립트를 설치해야 한다. `apt`나 `yum`으로도 `gitweb`을 설치할 수 있지만, 여기에서는 수동으로 설치한다. 먼저 GitWeb이 포함된 Git 소스 코드를 구한 다음 CGI 스크립트를 빌드한다:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

빌드할 때 `GITWEB_PROJECTROOT` 변수로 Git 저장소의 위치를 알려줘야 한다. 이제 Apache가 이 스크립트를 사용하도록 VirtualHost 항목을 설정한다:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

다시 말해서 GitWeb은 CGI를 지원하는 웹서버라면 아무거나 사용할 수 있다. 이제 `http://gitserver/`에 접속하여 온라인으로 저장소를 확인할 수 있을 뿐만 아니라 `http://git.gitserver`를 통해서 HTTP 프로토콜로 저장소를 Clone하고 Fetch할 수 있다.

## Gitosis ##

처음에는 모든 사용자의 공개키를 `authorized_keys`에 저장하는 방법으로도 불편하지 않을 것이다. 하지만, 사용자가 수백 명이 넘으면 관리하기가 매우 고통스럽다. 사용자를 추가할 때마다 매번 서버에 접속할 수도 없고 권한 관리도 안된다. `authorized_keys`에 등록된 모든 사용자는 누구나 프로젝트를 읽고 쓸 수 있다.

이 문제는 매우 널리 사용되고 있는 Gitosis라는 소프트웨어로 해결할 수 있다. Gitosis는 기본적으로 `authorized_keys` 파일을 관리하고 접근제어를 돕는 스크립트 패키지다. 사용자를 추가하고 권한을 관리하는 UI가 웹 인터페이스가 아니라 일종의 Git 저장소라는 점이 재미있다. 프로젝트 설정을 Push하면 그 설정이 Gitosis에 적용된다. 신비롭다!

Gitosis를 설치하기가 쉽지는 않지만 그렇다고 어렵지도 않다. Gitosis는 리눅스에 설치하는 것이 가장 쉽다. 여기서는 Ubuntu 8.10 서버를 사용한다.

Gitosis는 Python이 필요하기 때문에 먼저 Python setuptools 패키지를 설치해야 한다. Ubuntu에서는 아래와 같이 설치한다:

	$ apt-get install python-setuptools

그리고 Gitosis 프로젝트 사이트에서 Gitosis를 Clone한 후 설치한다:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Gitosis가 설치되면 Gitosis는 저장소 디렉토리로 `/home/git`를 사용하려고 한다. 이대로 사용해도 괜찮지만, 우리의 저장소는 이미 `/opt/git`에 있다. 다시 설정하지 말고 아래와 같이 간단하게 심볼릭 링크를 만들자:

	$ ln -s /opt/git /home/git/repositories

Gitosis가 키들을 관리할 것이기 때문에 현재 파일은 삭제하고 다시 추가해야 한다. 이제부터는 Gitosis가 `authorized_keys`파일을 자동으로 관리할 것이다. `authorized_keys` 파일을 백업해두자:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

그리고 `git` 계정의 쉘을 `git-shell`로 변경했었다면 원래대로 복원해야 한다. Gitosis가 대신 이 일을 맡아줄 것이기 때문에 복원해도 사람들은 여전히 로그인할 수 없다. `/etc/passwd` 파일의 다음 줄을:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

아래와 같이 변경한다:

	git:x:1000:1000::/home/git:/bin/sh

이제 Gitosis를 초기화할 차례다. `gitosis-init` 명령을 공개키와 함께 실행한다. 만약 공개키가 서버에 없으면 공개키를 서버로 복사해와야 한다:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

이 명령으로 등록하는 키의 사용자는 Gitosis를 제어하는 파일들이 있는 Gitosis 설정 저장소를 수정할 수 있게 된다. 그리고 수동으로 `post-update` 스크립트에 실행권한을 부여한다:

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

모든 준비가 끝났다. 설정이 잘 됐으면 추가한 공개키의 사용자로 SSH 서버에 접속했을 때 아래와 같은 메시지를 보게 된다:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	ERROR:gitosis.serve.main:Need SSH_ORIGINAL_COMMAND in environment.
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

이것은 접속을 시도한 사용자가 누구인지 식별할 수는 있지만, Git 명령이 아니어서 거절한다는 뜻이다. 그러니까 실제 Git 명령어를 실행시켜보자. Gitosis 제어 저장소를 Clone한다:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

`gitosis-admin`이라는 디렉토리가 생긴다. 디렉토리 내용은 크게 두 가지로 나눌 수 있다:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

`gitoiss.conf` 파일은 사용자, 저장소, 권한 등을 명시하는 설정파일이다. `keydir` 디렉토리에는 저장소에 접근할 수 있는 사용자의 공개키가 저장된다. 사용자마다 공개키가 하나씩 있고 이 공개키로 서버에 접근한다. 이 예제에서는 `scott.pub`이지만 `keydir` 안에 있는 파일의 이름은 사용자마다 다르다. 파일 이름은 `gitosis-init` 스크립트로 공개키를 추가할 때 결정되는데 공개키 끝 부분에 있는 이름이 사용된다.

이제 `gitosis.conf` 파일을 열어보자. 지금 막 Clone한 `gitosis-admin` 프로젝트에 대한 정보만 들어 있다:

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	members = scott
	writable = gitosis-admin

scott이라는 사용자는 Gitosis를 초기화할 때 사용한 공개키의 사용자이다. 이 사용자만 `gitosis-admin` 프로젝트에 접근할 수 있다.

이제 프로젝트를 새로 추가해보자. `mobile` 단락을 추가하고 그 프로젝트에 속한 개발자나 프로젝트에 접근해야 하는 사용자를 추가한다. 현재는 scott이외에 다른 사용자가 없으니 `scott`만 추가한다. 그리고 `iphone_project` 프로젝트를 새로 추가한다:

	[group mobile]
	writable = iphone_project
	members = scott

`gitosis-admin` 프로젝트를 수정하면 커밋하고 서버에 Push해야 수정한 설정이 적용된다:

	$ git commit -am 'add iphone_project and mobile group'
	[master 8962da8] add iphone_project and mobile group
	 1 file changed, 4 insertions(+)
	$ git push origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 272 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:gitosis-admin.git
	   fb27aec..8962da8  master -> master

로컬에 있는 `iphone_project` 프로젝트에 이 서버를 리모트 저장소로 추가하고 Push하면 서버에 새로운 저장소가 추가된다. 서버에 프로젝트를 새로 만들 때 이제는 수동으로 Bare 저장소를 만들 필요가 없다. 처음 Push할 때 Gitosis가 알아서 생성해 준다:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
> Writing objects: 100% (3/3), 230 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Gitosis를 이용할 때에는 저장소 경로를 명시할 필요도 없고 사용할 수도 없다. 단지 콜론 뒤에 프로젝트 이름만 적어도 Gitosis가 알아서 찾아 준다.

동료와 이 프로젝트를 공유하려면 동료의 공개키도 모두 추가해야 한다. `~/.ssh/authorized_keys` 파일에 수동으로 추가하는 게 아니라 `keydir` 디렉토리에 하나의 공개키를 하나의 파일로 추가한다. 이 공개키의 파일이름이 `gitosis.conf` 파일에서 사용하는 사용자 이름을 결정한다. John, Josie, Jessica의 공개키를 추가해 보자:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

이 세 사람을 모두 mobile 팀으로 추가하여 `iphone_project` 에 대한 읽기, 쓰기를 허용한다:

	[group mobile]
	members = scott john josie jessica
	writable = iphone_project

이 파일을 커밋하고 Push하고 나면 네 명 모두 `iphone_project`를 읽고 쓸 수 있게 된다.

Gitosis의 접근제어 방법은 매우 단순하다. 만약 이 프로젝트에 대해서 John은 읽기만 가능하도록 설정하려면 아래와 같이 한다:

	[group mobile]
	members = scott josie jessica
	writable = iphone_project

	[group mobile_ro]
	members = john
	readonly = iphone_project

이제 John은 프로젝트를 Clone하거나 Fetch할 수는 있지만, 프로젝트에 Push할 수는 없다. 다양한 사용자와 프로젝트가 있어도 필요한 만큼 그룹을 만들어 사용하면 된다. 그리고 members 항목에 사용자 대신 그룹명을 사용할 수도 있다. 그룹명 앞에 `@`를 붙이면 그 그룹의 사용자를 그대로 상속한다:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	members   = @mobile_committers
	writable  = iphone_project

	[group mobile_2]
	members   = @mobile_committers john
	writable  = another_iphone_project

`[gitosis]` 절에 `loglevel=DEBUG`라고 적으면 문제가 생겼을 때 해결하는데 도움이 된다. 그리고 설정이 꼬여버려서 Push할 수 없게 되면 서버에 있는 파일을 수동으로 고쳐도 된다. Gitosis는 `/home/git/.gitosis.conf` 파일의 정보를 읽기 때문에 이 파일을 고친다. `gitosis.conf`는 Push할 때 그 위치로 복사되기 때문에 수동으로 고친 파일은 `gitosis-admin` 프로젝트가 다음에 Push될 때까지 유지된다.

## Gitolite ##

이 절에서는 Gitolite가 뭐고 기본적으로 어떻게 설치하는 지를 살펴본다. 물론 Gitolite에 들어 있는 [Gitolite 문서][gltoc]는 양이 많아서 이 절에서 모두 다룰 수 없다. Gitolite는 계속 진화하고 있기 때문에 이 책의 내용과 다를 수 있다. 최신 내용은 [여기][gldpg]에서 확인해야 한다.

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

Gitolite은 간단히 말해 Git 위에서 운영하는 권한 제어(Authorization) 도구다. 사용자 인증(Authentication)은 `sshd`와 `httpd`를 사용한다. 접속한 접속하는 사용자가 누구인지 가려내는 것이 인증(Authentication)이고 리소스에 대한 접근 권한을 가려내는 일은 권한 제어(Authorization)이다.

Gitolite는 저장소뿐만 아니라 저장소의 브랜치나 태그에도 권한을 명시할 수 있다. 즉, 어떤 사람은 refs(브랜치나 태그)에 Push할 수 있고 어떤 사람은 할 수 없게 하는 것이 가능하다.

### 설치하기 ###

별도 문서를 읽지 않아도 유닉스 계정만 하나 있으면 Gitolite를 쉽게 설치할 수 있다. 이 글은 여러 가지 리눅스들과 솔라리스 10에서 테스트를 마쳤다. Git, Perl, OpenSSH가 호환되는 SSH 서버가 설치돼 있으면 root 권한도 필요 없다. 앞서 사용했던 `gitserver`라는 서버와 그 서버에 `git` 계정을 만들어 사용한다.

Gitolite는 보통의 서버 소프트웨어와는 달리 SSH를 통해서 접근한다. 서버의 모든 계정은 근본적으로 "Gitolite 호스트"가 될 수 있다. 이 책에서는 가장 간단한 설치 방법으로 설명한다. 자세한 설명 문서는 Gitolite의 문서를 참고한다.

먼저 서버에 `git` 계정을 만들고 `git` 계정으로 로그인 한다. 사용자의 SSH 공개키(`ssh-keygen`으로 생성한 SSH 공개키는 기본적으로 `~/.ssh/id_rsa.pub`에 위치함)를 복사하여 `<이름>.pub` 파일로 저장한다(이 책의 예제에서는 `scott.pub`로 저장). 그리고 다음과 같은 명령을 실행한다:

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	    # $HOME/bin가 이미 $PATH에 등록돼있다고 가정
	$ gitolite setup -pk $HOME/scott.pub

마지막 명령은 `gitolite-admin`라는 새 Git 저장소를 서버에 만든다.

다시 작업하던 환경으로 돌아가서 `git clone git@gitserver:gitolite-admin` 명령으로 서버의 저장소를 Clone 했을 떄 문제없이 Clone 되면 Gitolite가 정상적으로 설치된 것이다. 이 `gitolite-admin` 저장소의 내용을 수정하고 Push하여 Gitolite을 설치를 마치도록 한다.

### 자신에게 맞게 설치하기 ###

보통은 기본설정으로 빠르게 설치하는 것으로 충분하지만, 자신에게 맞게 고쳐서 설치할 수 있다. 일부 설정은 주석이 잘 달려있는 rc 파일을 간단히 고쳐서 쓸 수 있지만, 자세한 설정을 위해서는 Gitolite가 제공하는 문서를 살펴보도록 한다.

### 설정 파일과 접근제어 규칙 ###

설치가 완료되면 홈 디렉토리에 Clone한 `gitolite-admin` 디렉토리로 이동해서 어떤 것들이 있는지 한번 살펴보자:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/scott.pub
	$ cat conf/gitolite.conf

	repo gitolite-admin
	    RW+                 = scott

	repo testing
	    RW+                 = @all

`gitolite setup` 명령을 실행했을 때 주었던 공개키 파일의 이름인 `scott`은 `gitolite-admin` 저장소에 대한 읽기와 쓰기 권한을 갖도록 공개키가 등록돼 있다.

사용자를 새로 추가하기도 쉽다. "alice"라는 사용자를 새로 등록하려면 우선 등록할 사람의 공개키 파일을 얻어서 `alice.pub`라는 이름으로 `gitolite-admin` 디렉토리 아래에 `keydir` 디렉토리에 저장한다. 새로 추가한 이 파일을 Add하고 커밋한 후 Push를 하면 `alice`라는 사용자가 등록된 것이다.

Gitolite의 설정 파일인 `conf/example.conf`에 대한 내용은 Gitolite 문서에 설명이 잘 되어 있다. 이 책에서는 주요 일부 설정에 대해서만 간단히 살펴본다.

저장소의 사용자 그룹을 쉽게 만들 수 있다. 이 그룹은 매크로와 비슷하다. 그룹을 만들 때는 그 그룹이 프로젝트의 그룹인지 사용자의 그룹인지 구분하지 않지만 *사용*할 때에는 다르다.

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

그리고 ref 단위로 권한을 제어한다. 다음 예제를 보자. 인턴(interns)은 int 브랜치만 Push할 수 있고 engineers는 eng-로 시작하는 브랜치와 rc 뒤에 숫자가 붙는 태그만 Push할 수 있다. 그리고 관리자는 모든 ref에 무엇이든지(되돌리기도 포함됨) 할 수 있다.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

`RW`나 `RW+` 뒤에 나오는 표현식은 정규표현식(regex)이고 Push하는 ref 이름의 패턴을 의미한다. 그래서 우리는 refex라고 부른다. 물론 refex는 여기에 보여준 것보다 훨씬 더 강력하다. 하지만, 펄의 정규표현식에 익숙하지 않은 독자도 있으니 여기서는 무리하지 않았다.

그리고 이미 예상했겠지만 Gitolite는 `refs/heads/`라고 시작하지 않는 refex에 대해서는 암묵적으로 `refs/heads/`가 생략된 것으로 판단한다.

특정 저장소에 사용하는 규칙을 한 곳에 모아 놓지 않아도 괜찮다. 위에 보여준 `oss_repos` 저장소 설정과 다른 저장소 설정이 마구 섞여 있어도 괜찮다. 아래와 같이 목적이 분명하고 제한적인 규칙을 아무 데나 추가해도 좋다:

	repo gitolite
	    RW+                     = sitaram

이 규칙은 `gitolite` 저장소를 위해 지금 막 추가한 규칙이다.

이제는 접근제어 규칙이 실제로 어떻게 적용되는지 설명한다. 이제부터 그 내용을 살펴보자.

Gitolite는 접근 제어를 두 단계로 한다. 첫 단계가 저장소 단계인데 접근하는 저장소의 ref 중에서 하나라도 읽고 쓸 수 있으면 실제로 그 저장소 전부에 대해 읽기, 쓰기 권한이 있는 것이다.

두 번째 단계는 브랜치나 태그 단위로 제어하는 것으로 오직 "쓰기" 접근만 제어할 수 있다. 어느 사용자가 특정 ref 이름으로 접근을 시도하면(`W`나 `+`같은) 설정 파일에 정의된 순서대로 접근 제어 규칙이 적용된다. 그 순서대로 사용자 이름과 ref 이름을 비교하는데 ref 이름의 경우 단순히 문자열을 비교하는 것이 아니라 정규 표현식으로 비교한다. 해당되는 것을 찾으면 정상적으로 Push되지만 찾지 못하면 거절된다.

### "deny" 규칙을 꼼꼼하게 제어하기 ###

지금까지는 `R`, `RW`, `RW+` 권한에 대해서만 다뤘다. Gitolite는 "deny" 규칙을 위해서 `-` 권한도 지원한다. 이것으로 복잡도를 낮출 수 있다. `-`로 거절도 할 수 있기 때문에 *규칙의 순서가 중요하다*.

다시 말해서 engineers가 master와 integ 브랜치 *이외의* 모든 브랜치를 되돌릴 수 있게 하고 싶으면 아래와 같이 한다:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

즉, 접근제어 규칙을 순서대로 찾기 때문에 순서대로 정의해야 한다. 첫 번째 규칙은 master나 integ 브랜치에 대해서 읽기, 쓰기만 허용하고 되돌리기는 허용하지 않는다. master나 integ 브랜치를 되돌리는 Push는 첫 번째 규칙에 어긋나기 때문에 바로 두 번째 규칙으로 넘어간다. 그리고 거기서 거절된다. master나 integ 브랜치 이외 다른 ref에 대한 Push는 첫 번째 규칙과 두 번째 규칙에는 만족하지 않고 마지막 규칙으로 허용된다.

### 파일 단위로 Push를 제어하기 ###

브랜치 단위로 Push를 제어할 수 있지만 수정된 파일 단위로도 제어할 수 있다. 예를 들어 Makefile을 보자. Makefile 파일에 의존하는 파일은 매우 많고 보통 *꼼꼼하게* 수정하지 않으면 문제가 생긴다. 그래서 아무나 Makefile을 수정하게 둘 수 없다. 그러면 아래와 같이 설정한다:

	repo foo
	    RW                      =   @junior_devs @senior_devs

	    -   VREF/NAME/Makefile  =   @junior_devs

예전 버전의 Gitolite에서 버전을 올리려는 사용자는 설정이 많이 달라진 것을 알게 될 것이다. Gitolite의 버전업 가이드를 필히 참고하자.

### Personal 브랜치 ###

Gitolite는 또 "Personal 브랜치"라고 부르는 기능을 지원한다. 이 기능은 실제로 "Personal 브랜치 네임스페이스"라고 부르는 것이 더 적절하다. 이 기능은 기업에서 매우 유용하다.

Git을 사용하다 보면 코드를 공유하려고 "Pull 해주세요"라고 말해야 하는 일이 자주 생긴다. 그런데 기업에서는 인증하지 않은 접근을 절대 허용하지도 않는 데다가 아예 다른 사람의 컴퓨터에 접근할 수 없다. 그래서 공유하려면 중앙 서버에 Push하고 나서 Pull해야 한다고 다른 사람에게 말해야만 한다.

중앙집중식 VCS에서 이렇게 마구 사용하면 브랜치 이름이 충돌할 확률이 높다. 그때마다 관리자는 추가로 권한을 관리해줘야 하기 때문에 관리자의 노력이 쓸데없이 낭비된다.

Gitolite는 모든 개발자가 "personal"이나 "scratch" 네임스페이스를 가질 수 있도록 허용한다. 이 네임스페이스는 `refs/personal/<devname>/*` 라고 표현한다. 자세한 내용은 Gitolite 문서를 참고한다.

### "와일드카드" 저장소 ###

Gitolite는 펄 정규표현식으로 저장소 이름을 표현하기 때문에 와일드카드를 사용할 수 있다. 그래서 `assignments/s[0-9][0-9]/a[0-9][0-9]` 같은 정규표현식을 사용할 수 있다. 사용자가 새로운 저장소를 만들 수 있는 새로운 권한 모드인 `C` 모드를 사용할 수도 있다. 저장소를 새로 만든 사람에게는 자동으로 접근 권한이 부여된다. 다른 사용자에게 접근 권한을 주려면 `R` 또는 `RW` 권한을 설정한다. 다시 한번 말하지만 문서에 모든 내용이 다 있으므로 꼭 보기를 바란다.

### 그 밖의 기능들 ###

마지막으로 알고 있으면 유용한 것들이 있다. Gitolite에는 많은 기능이 있고 자세한 내용은 "Faq, Tip, 등등"의 다른 문서에 잘 설명돼 있다.

**로깅**: 누군가 성공적으로 접근하면 Gitolite는 무조건 로그를 남긴다. 관리자가 한눈파는 사이에 되돌리기(`RW+`) 권한을 가진 망나니가 `master` 브랜치를 날려버릴 수 있다. 이 경우 로그 파일이 구원해준다. 이 로그 파일을 참고하여 버려진 SHA를 빠르고 쉽게 찾을 수 있다.

**접근 권한 보여주기**: 만약 어떤 서버에서 작업을 시작하려고 할 때 필요한 것이 무엇일까? Gitolite는 해당 서버에 대해 접근할 수 있는 저장소가 무엇인지, 어떤 권한을 가졌는지 보여준다:

	    hello scott, this is git@git running gitolite3 v3.01-18-g9609868 on git 1.7.4.4

	         R     anu-wsd
	         R     entrans
	         R  W  git-notes
	         R  W  gitolite
	         R  W  gitolite-admin
	         R     indic_web_input
	         R     shreelipi_converter

**권한 위임**: 조직 규모가 크면 저장소에 대한 책임을 여러 사람이 나눠 가지는 게 좋다. 여러 사람이 각자 맡은 바를 관리하도록 한다. 그래서 주요 관리자의 업무가 줄어들기에 병목현상이 적어진다. 이 기능에 대해서는 `doc/` 디렉토리에 포함된 Gitolite 문서를 참고하라.

**미러링**: Gitolite의 미러는 여러 개 만들 수 있어서 주 서버가 다운 돼도 변경하면 된다.

## Git 데몬 ##

공개된 프로젝트는 누가 읽기 접근을 시도하는지 알 필요가 없다. 그래서 HTTP 프로토콜을 사용하거나 Git 프로토콜을 사용해야 한다. Git 프로토콜이 HTTP 프로토콜보다 효율적이기 때문에 속도가 빠르다. 따라서 사용자의 시간을 절약해 준다.

다시 강조하지만, 이것은 불특정 다수에게 읽기 접근을 허용할 때에만 쓸만하다. 만약 서버가 외부에 그냥 노출돼 있으면 우선 방화벽으로 보호하고 프로젝트만 외부에서 접근할 수 있게 만든다. 서버를 방화벽으로 보호하고 있으면 CI 서버나 빌드 서버같은 컴퓨터나 사람이 읽기 접근이 가능하도록 설정한다. 모두 SSH 키를 일일이 추가하고 싶지 않을 때 이 방법을 사용한다.

어쨌든 Git 프로토콜은 상대적으로 설치하기 쉽다. 그냥 데몬을 실행한다:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr`는 서버가 기존의 연결이 타임아웃될 때까지 기다리지 말고 바로 재시작하게 하는 옵션이다. `--base-path` 옵션을 사용하면 사람들이 프로젝트를 Clone할 때 전체 경로를 사용하지 않아도 된다. 그리고 마지막에 있는 경로는 노출할 저장소의 위치다. 마지막으로 방화벽을 사용하고 있으면 9418 포트를 열어서 지금 작업하는 서버의 숨통을 틔워준다.

운영체제에 따라 Git 데몬을 실행시키는 방법은 다르다. 우분투에서는 *Upstart* 스크립트를 사용한다. 아래와 같이 파일을 만들고:

	/etc/event.d/local-git-daemon

다음의 내용을 입력한다:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

저장소를 읽을 수만 있는 사용자로 데몬을 실행시킬 것을 보안을 위해 강력하게 권고한다. `git-ro`라는 계정을 새로 만들고 그 계정으로 데몬을 실행시킨다. 여기에서는 쉽게 설명하려고 그냥 Gitosis를 실행했던 `git` 계정으로 실행시킨다.

서버가 재시작할 때 Git 데몬이 자동으로 실행되고 데몬이 죽어도 자동으로 재시작된다. 서버는 놔두고 Git 데몬만 재시작할 수 있다:

	initctl start local-git-daemon

다른 시스템에서는 `sysvinit` 시스템의 `xinetd` 스크립트를 사용하거나 자신만의 방법으로 해야 한다.

Git 데몬을 통해서 아무나 읽을 수 있다는 것을 Gitosis 서버에 알려주어야 한다. Git 데몬으로 읽기 접근을 허용하는 저장소가 무엇인지 설정에 추가해야 한다. 만약 `iphone_project`에 Git 프로토콜을 허용했다면 아래와 같은 것을 `gitosis.conf` 파일의 하단에 추가한다:

	[repo iphone_project]
	daemon = yes

차례대로 커밋과 Push하고 나면 지금 실행 중인 데몬이 9418 포트로 접근하는 사람에게 서비스하기 시작한다.

Gitosis 없이도 Git 데몬을 설치할 수 있지만 그러려면 서비스하고자 하는 프로젝트마다 아래와 같이 `git-daemon-export-ok` 파일을 넣어 주어야 한다:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

이 파일이 있으면 Git 데몬은 인증 없이 프로젝트를 노출하는 것으로 판단한다.

또한, Gitweb으로 노출하는 프로젝트도 Gitosis로 제어할 수 있다. 먼저 `/etc/gitweb.conf` 파일에 아래와 같은 내용을 추가해야 한다:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Gitosis 설정 파일에 `gitweb` 설정을 넣거나 빼면 사용자는 GitWeb을 통해 프로젝트를 볼 수도 있고 못 볼 수도 있다.

	[repo iphone_project]
	daemon = yes
	gitweb = yes

이제 이것을 커밋하고 Push하면 GitWeb을 통해 `iphone_project`를 볼 수 있다.

## Hosted Git ##

Git 서버를 설치하는 등의 일을 하고 싶지 않으면 전문 호스팅 사이트를 이용하면 된다. 호스팅 사이트는 몇 가지 장점이 있다. 설정이 쉬워서 바로 프로젝트를 시작할 수 있을 뿐만 아니라 직접 서버를 관리하고 모니터링하지 않아도 된다. 내부적으로 Git 서버를 직접 설치하고 운영하고 있어도 오픈소스 프로젝트는 호스팅 사이트를 이용하는 것이 좋다. 이렇게 하면 보통 오픈소스 커뮤니티로부터 좀 더 쉽게 도움받을 수 있다.

요즘은 이용할 수 있는 호스팅 사이트들이 많다. 각각 장단점이 있기 때문에 다음 페이지에서 최신 정보를 확인해보자:

	https://git.wiki.kernel.org/index.php/GitHosting

이 절에서 전부 설명할 수는 없고(필자는 저 회사 중 한군데에서 일한다) GitHub에 계정과 프로젝트를 만드는 방법을 설명한다.

GitHub은 가장 큰 오픈소스 Git 호스팅 사이트이고 공개(Public) 프로젝트와 비공개(Private) 프로젝트에 대한 호스팅 서비스를 제공하는 보기 드문 사이트다. 그래서 상업용 비공개 코드와 공개 코드를 같은 곳에 둘 수 있다. 실제로 이 책도 GitHub에서 비공개로 작성했다.

### GitHub ###

GitHub는 프로젝트 네임스페이스가 다른 코드 호스팅 사이트들과 다르다. GitHub는 프로젝트가 아니라 사용자가 중심이다. GitHub에 `grit` 프로젝트를 호스팅하고 싶으면 `github.com/grit`이 아니라 `github.com/schacon/grit`으로 접속해야 한다. 그리고 처음 프로젝트를 시작한 사람이 그 프로젝트를 잊어버려도 누구나 프로젝트를 이어갈 수 있다. 프로젝트 주 저장소라고 해서 특별한게 아니다.

GitHub은 이윤을 목적으로 하는 회사이기 때문에 비공개 저장소를 만들려면 돈을 내야 한다. 하지만, 누구나 손쉽게 무료 계정을 만들어 오픈소스 프로젝트를 시작할 수 있다. 어떻게 사용하는지 간략하게 설명한다.

### 계정 설정하기 ###

먼저 무료 계정을 하나 만든다. 가격 정책에 대해 알려주며 가입을 시작할 수 있는 `https://github.com/pricing`에 방문하여 "Sign up" 버튼을 클릭한다. 그러면 가입 페이지로 이동한다.

Insert 18333fig0402.png
그림 4-2. GitHub 가격 정책 페이지

아직 등록되지 않은 사용자 이름을 입력하고 e-mail 주소와 암호를 입력한다(그림 4-3).

Insert 18333fig0403.png
그림 4-3. GitHub 가입 폼

그리고 SSH 공개키가 있으면 바로 등록한다. SSH 키를 만드는 방법은 "바로 설정하기" 절에서 이미 설명했다. 그 공개키 파일의 내용을 복사해서 SSH 공개키 입력 박스에 붙여 넣는다. "explain ssh keys" 링크를 클릭하면 key를 생성하는 방법을 자세히 설명해준다. 주요 운영체제에서 하는 방법이 모두 설명돼 있다. "I agree, sign me up" 버튼을 클릭하면 자신만의 대쉬보드 페이지가 나타난다.

Insert 18333fig0404.png
그림 4-4. GitHub 사용자 대쉬보드

그리고 저장소를 만들자.

### 저장소 만들기 ###

`Your Repositories`옆에 있는 "create a new one" 링크를 클릭하면 저장소를 만드는 입력 폼을 볼 수 있다(그림 4-5).

Insert 18333fig0405.png
그림 4-5. GitHub의 저장소를 생성하는 폼

이 폼에 프로젝트 이름과 프로젝트 설명을 적는다. 다 적은 후에 "Create Repository" 버튼을 클릭하면 GitHub에 저장소가 생긴다.

Insert 18333fig0406.png
그림 4-6. GitHub 프로젝트 정보

이 저장소에는 아직 코드가 없어서 GitHub은 프로젝트를 새로 만드는 방법, 이미 있는 Git 프로젝트를 Push하는 법, 공개된 Subversion 저장소에서 프로젝트를 가져오는(Import) 방법 등을 보여준다.

Insert 18333fig0407.png
그림 4-7. 새 저장소를 위한 사용설명서

여기 설명하는 내용은 이미 우리가 배웠다. 프로젝트가 없을 때는 아래와 같이 프로젝트를 초기화한다:

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

만약 이미 로컬에 Git 저장소가 있으면 GitHub 저장소를 리모트 저장소로 등록하고 master 브랜치를 Push한다:

	$ git remote add origin git@GitHub.com:testinguser/iphone_project.git
	$ git push origin master

이제 프로젝트가 GitHub에서 서비스되니 공유하고 싶은 사람에게 URL을 알려 주면 된다. URL은 `http://github.com/testinguser/iphone_project`이다. 그리고 이 저장소의 정보를 잘 살펴보면 Git URL이 두 개라는 것을 발견할 수 있다.

Insert 18333fig0408.png
그림 4-8. 프로젝트의 공개 URL과 비공개 URL

`Public Clone URL`은 말 그대로 누구나 프로젝트를 Clone할 수 있도록 모두에게 읽기 전용으로 공개하는 것이다. 이 URL을 다른 사람에 알려주거나 웹사이트 같은데 공개하는 것을 부담스러워 하지 않아도 된다.

`Your Clone URL`은 읽고 쓸 수 있는 SSH 기반 URL이다. 사용자 계정에 등록한 공개키와 한 짝인 개인키로만 접속할 수 있다. 다른 사용자로 이 프로젝트에 방문하면 이 URL은 볼 수 없고 공개 URL만 볼 수 있다.

### Subversion으로부터 코드 가져오기(Import) ###

GitHub은 공개 중인 Subversion 프로젝트를 Git 프로젝트로 만들어 준다. 사용설명서 하단에 있는 "Subversion에서 Import하기" 링크를 클릭하면 임포트 폼을 볼 수 있고 거기에 Subversion 프로젝트의 URL을 넣는다(그림 4-9).

Insert 18333fig0409.png
그림 4-9. Subversion 프로젝트를 Import하는 화면

프로젝트가 비표준 방식을 사용하거나 규모가 너무 크고 비공개라면 이 기능을 사용할 수 없다. *7장*에서 수동으로 임포트하는 방법에 대해 좀 더 자세히 배운다.

### 동료 추가하기 ###

동료를 추가하자. 먼저 John씨, Josie씨, Jessica씨를 모두 GitHub에 가입시키고 나서 그들을 동료로 추가하고 저장소에 Push할 수 있는 권한을 준다.

프로젝트 페이지에 있는 Admin 버튼을 클릭해서 관리 페이지로 이동한다(그림 4-10).

Insert 18333fig0410.png
그림 4-10. GitHub의 프로젝트 관리 페이지

다른 사람에게 쓰기 권한을 주려면 “Add another collaborator” 링크를 클릭한다. 그러면 텍스트 박스가 새로 나타나는 데 거기에 사용자 이름을 입력한다. 사용자 이름을 입력하기 시작하면 자동으로 시스템에 존재하는 사용자를 찾아서 보여 준다. 원하는 사용자를 찾으면 Add 버튼을 클릭해서 그 사용자를 동료로 만든다.

Insert 18333fig0411.png
그림 4-11. 프로젝트에 동료 추가하기

추가한 사람은 동료 목록 박스에서 모두 확인할 수 있다(그림 4-12).

Insert 18333fig0412.png 
그림 4-12. 프로젝트 동료들

그리고 만약 다시 혼자 작업하고 싶어지면 "revoke" 링크를 클릭하여 쫓아낸다. 쫓겨나면 더는 Push할 수 없다. 또 기존 프로젝트에 등록된 동료를 그룹으로 묶어 추가할 수도 있다.

### 내 프로젝트 ###

Subversion에서 Import했거나 로컬의 프로젝트를 Push하고 나면 프로젝트 메인 페이지가 그림 4-13같이 바뀐다.

Insert 18333fig0413.png
그림 4-13. GitHub의 프로젝트 메인 페이지

사람들이 이 프로젝트에 방문하면 이 페이지가 제일 처음 보인다. 이 페이지는 몇 가지 탭으로 구성된다. Commits 탭은 지금까지의 커밋을 `git log` 명령을 실행시킨 것처럼 최신 것부터 보여준다. Network 탭은 프로젝트를 복제한 사람들과 기여한 사람들을 모두 보여준다. Downloads 탭에는 바이너리 파일이나 프로젝트의 태그 버전을 압축해서 올릴 수 있다. Wiki 탭은 프로젝트에 대한 정보나 문서를 쓰는 곳이다. Graphs 탭은 사람들의 활동을 그림과 통계로 보여준다. 메인 탭인 Source 탭은 프로젝트의 메인 디렉토리를 보여주고 README 파일이 있으면 자동으로 화면에 출력해 준다. 그리고 마지막 커밋 내용도 함께 보여준다.

### 프로젝트 Fork ###

권한이 없는 프로젝트에 참여하고 싶으면 GitHub는 프로젝트를 Fork하도록 권고한다. 마침 매우 흥미롭게 보이는 프로젝트를 발견했다고 하자. 그 프로젝트를 조금 뜯어고치려면 프로젝트 페이지 상단에 있는 "fork" 버튼을 클릭한다. 그러면 GitHub는 접속한 사용자의 계정으로 프로젝트를 Fork해 준다. 사용자는 이 프로젝트에 마음대로 Push할 수 있다.

굳이 Push할 수 있도록 사람들을 동료로 추가하지 않아도 된다. 사람들은 마음껏 프로젝트를 Fork하고 Push할 수 있다. 그리고 원래 프로젝트의 관리자는 다른 사람의 프로젝트를 리모트 저장소로 추가하고 그 작업물을 가져와서 Merge한다.

프로젝트 페이지에 들어가서 상단의 "fork" 버튼을 클릭하여 프로젝트를 복제한다(그림 4-14) 그림 4-14의 예는 mojombo/chronic 프로젝트 페이지이다

Insert 18333fig0414.png
그림 4-14. 어떤 저장소든지 "fork" 버튼을 클릭하면 Push할 수 있는 저장소를 얻을 수 있다

클릭하는 순간, 이 프로젝트를 즉시 Fork한다(그림 4-15).

Insert 18333fig0415.png
그림 4-15. Fork한 프로젝트

### GitHub 요약 ###

빨리 한번 전체를 훑어보는 것이 중요하기 때문에 여기에서는 GitHub에 대해 이 정도로만 설명했다. 몇 분 만에 계정과 프로젝트를 만들고 Push까지 할 수 있다. GitHub에 있는 개발자 커뮤니티 규모는 매우 크기 때문에 만약 GitHub에 오픈 소스 프로젝트를 만들면 다른 개발자들이 당신의 프로젝트를 복제하고 당신을 도울 것이다. GitHub는 Git을 빨리 사용해 볼 수 있도록 돕는다.

## 요약 ##

리모트 저장소를 만들고 다른 사람과 협업하거나 작업물을 공개하는 방법은 여러 가지다.

서버를 직접 구축하는 것은 할 일이 많은데다가 방화벽도 필요하다. 그리고 이렇게 서버를 만들고 관리하는 일은 시간이 많이 든다. 호스팅 사이트를 이용하면 쉽게 시작할 수 있다. 하지만, 코드를 타인의 서버에 보관해야 하기 때문에 사용하지 않는 조직들이 많다.

자신의 조직에서 어떤 방법으로 협업해야 할지 고민해야 하는 시점이 되었다.
