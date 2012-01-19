# Git의 내부구조 #

여기까지 다 읽고 왔든 건너뛰고 왔든 간에 지금 펼친 9장은 Git이 어떻게 구현돼 있고 내부적으로 어떻게 동작하는지 설명한다. Git이 얼마나 유용하고 강력한지 깊이 이해하려면 9장의 내용을 꼭 알아야 한다. 초보자에게는 9장이 너무 혼란스럽고 불필요하다고 이야기하는 사람들도 있다. 그래서 필자는 본 내용을 책의 가장 마지막에 두었고 독자가 스스로 먼저 볼지, 나중에 볼지 선택할 수 있도록 하였다.

자 이제 본격적으로 살펴보자. 우선 Git은 기본적으로 Content-addressable 파일 시스템이고 그 위에 VCS 사용자 인터페이스가 있는 구조다. 뭔가 깔끔한 정의는 아니지만, 이 말이 무슨 의미인지는 차차 알아갈 것이다.

Git의 초년 기에는 (1.5 이전 버전) 사용자 인터페이스가 훨씬 복잡했었다. VCS가 아니라 파일 시스템을 강조했기 때문이었다. 최근 몇 년간 Git은 다른 VCS처럼 쉽고 간결하게 사용자 인터페이스를 다듬어 왔다. 하지만, 여전히 복잡하고 배우기 어렵다는 선입견이 있다.

우선 Content-addressable 파일 시스템은 정말 대단한 것이므로 먼저 다룰 것이다. 그리고 나서 데이터 전송 원리를 배우고 마지막에는 저장소를 관리하는 법까지 배우게 될 것이다.

## Plumbing 명령과 Porcelain 명령 ##

이 책에서는 `checkout`, `branch`, `remote`와 같은 30여 가지의 Git 명령을 사용하였다. Git은 사실 사용자 친화적인 VCS이기 보다는 VCS로도 사용할 수 있는 툴킷이였다. 그래서 저수준의 일을 처리할 수 있는 수많은 명령어를 갖고 있다. 명령어 여러 개를 Unix 스타일로 함께 엮어서 실행하거나 스크립트에서 호출될 수 있도록 디자인됐다. 이러한 저수준의 명령어는 "Plumbing" 명령어라고 부르고 좀 더 사용자 친화적인 명령어는 "Porcelain" 명령어라고 부른다.

이 책의 앞 8개 장은 Porcelain 명령만 사용했다. 하지만, 이 장에서는 저수준의 Plumbing 명령을 주로 사용할 것이다. 이 명령으로 Git의 내부구조에 접근할 수 있고 실제로 왜, 그렇게 작동하는지도 살펴볼 수 있다. Plumbing 명령은 직접 커맨드라인에서 실행하기보다 새로운 도구를 만들거나 각자 필요한 스크립트를 작성할 때 사용한다.

새로 만든 디렉토리나 이미 파일이 있는 디렉토리에서 `git init` 명령을 실행하면 Git은 데이터를 저장하고 관리하는 `.git` 디렉토리를 만든다. 이 디렉토리를 복사하기만 해도 저장소가 백업 된다. 이 장은 기본적으로 이 디렉토리에 대한 내용을 다루고 있다. 디렉토리 구조는 다음과 같다:

	$ ls
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

기본적으로 이것이 `git init`을 한 직후에 보이는 새 저장소의 모습이고, 이 외에 다른 파일들이 더 있을 수 있다. `branches` 디렉토리는 Git의 예전 버전에서만 사용하고 `description` 파일은 기본적으로 GitWeb 프로그램에서만 사용하기 때문에 이 둘은 무시해도 된다. `config` 파일에는 해당 프로젝트에만 적용되는 설정 옵션이 들어 있고, `info` 디렉토리는 .gitignore 파일처럼 무시할 파일의 패턴을 적어 두는 곳이다. 하지만 .gitignore 파일과는 달리 Git으로 관리되지 않는다. `hook` 디렉토리에는 클라이언트 훅이나 서버 훅을 넣는다. 관련 내용은 7장에서 다루었다.

이제 남은 네 가지 항목은 모두 중요한 항목이다. `HEAD`와 `index` 파일, `objects`와 `refs` 디렉토리가 남았다. 이 네 항목이 Git의 핵심이다. `objects` 디렉토리는 모든 컨텐트를 저장하는 데이터베이스이고 `refs` 디렉토리에는 Commit 개체의 포인터를 저장한다. `HEAD` 파일은 현재 Checkout한 브랜치를 가리키고 `index` 파일은 Staging Area의 정보를 저장한다. 이 네 가지 항목을 자세히 살펴보면 Git이 어떻게 동작하는지 알게 된다.

## Git 개체 ##

Git은 Content-addressible 파일시스템이다. 대단하지 않은가? 이게 무슨 말이냐 하면 Git은 단순한 Key-Value 데이터 저장소라는 것이다. 어떤 형식의 데이터라도 집어넣을 수 있고 해당 Key로 언제든지 데이터를 다시 가져올 수 있다. Plumbing 명령어 `hash-object`에 데이터를 주면 `.git` 디렉토리에 저장하고 그 key를 알려준다. 우선 Git 저장소를 새로 만들고 `objects` 디렉토리에 뭐가 들어 있는지 확인한다:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

아무것도 없다. Git은 `objects` 디렉토리를 만들고 그 밑에 `pack`과 `info` 디렉토리도 만들었다. 그 디렉토리는 빈 디렉토리일 뿐 파일은 아직 아무것도 없다. Git 데이터베이스에 텍스트 파일을 저장해보자:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

이 명령은 표준입력으로 들어오는 데이터를 저장할 수 있다. `-w` 옵션을 줘야 저장한다. `-w`가 없으면 저장하지 않고 key만 보여준다. 그리고 `--stdin` 옵션을 주면 표준입력으로 입력되는 데이터를 읽도록 지시하는 것이다. 이 옵션이 없으면 파일 경로를 알려줘야 한다. `hash-object` 명령이 출력하는 것은 40자 길이의 체크섬 해시다. 이 해시는 헤더 정보와 데이터 모두에 대한 SHA-1 해시이다. 헤더 정보는 차차 자세히 살펴볼 것이다. 이제 Git이 저장한 데이터를 알아보자:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

`objects` 디렉토리에 파일이 하나 새로 생겼다. Git은 데이터를 저장할 때 데이터와 헤더로 생성한 SHA-1 체크섬으로 파일 이름을 짓는다. 해시의 처음 두 글자를 따서 디렉토리 이름을 짓고 나머지 38글자를 파일 이름에 사용한다. 그리고 새로 만든 파일에 데이터를 저장한다.

`cat-file` 명령으로 저장한 데이터를 불러올 수 있다. 이 명령은 Git 개체를 살펴보고 싶을 때 맥가이버칼처럼 사용할 수 있다. `cat-file` 명령에 `-p` 옵션을 주면 파일 내용이 출력된다:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

다시 한 번 데이터를 Git 저장소에 추가하고 불러와 보자. Git이 파일 버전을 관리하는 방식을 이해하기 위해 가상의 상황을 만든다. 우선 새 파일을 하나 만들고 Git 저장소에 저장한다:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

그리고 그 파일을 수정하고 다시 저장한다:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

이제 데이터베이스에는 데이터가 두 가지 버전으로 저장돼 있다:

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

파일의 내용을 첫 번째 버전으로 되돌리려면 다음과 같이 한다:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

다시 두 번째 버전을 적용하려면 다음과 같이 한다:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

파일의 SHA-1 키를 외워서 사용하는 것은 너무 어려운 일이다. 게다가 원래 파일의 이름은 저장하지도 않았다. 단지 파일 내용만 저장했을 뿐이다. 이런 종류의 개체를 Blob 개체라고 부른다. `cat-file -t` 명령으로 해당 개체가 무슨 타입인지 확인할 수 있다:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Tree 개체 ###

다음으로, 살펴볼 것은 Tree 개체이다. 이 Tree 개체로 파일 이름을 저장할 수 있고 파일 여러 개를 한 번에 저장할 수도 있다. Git은 유닉스 파일 시스템과 비슷한 방법으로 저장하지만 좀 더 단순하다. 모든 것을 Tree와 Blob 개체로 저장한다. Tree는 유닉스의 디렉토리에 대응되고 Blob은 Inode나 일반 파일에 대응된다. Tree 개체 하나는 항목을 여러 개 가질 수 있다. 그리고 그 항목은 Blob 개체나 하위 Tree 개체를 가리키는 SHA-1 포인터, 파일 모드, 개체 타입, 파일 이름을 갖고 있다. simplegit 프로젝트의 마지막 Tree 개체를 살펴보자:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

`master^{tree}` 구문은 `master` 브랜치가 가리키는 Tree 개체를 말한다. `lib` 디렉토리는 Blob이 아니고 다른 Tree 개체를 가리킨다는 점을 주목하자:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Git이 저장하는 데이터는 대강 그림 9-1과 같다.

Insert 18333fig0901.png 
Figure 9-1. 단순화한 Git 데이터 모델.

직접 Tree 개체를 만들어 보자. Git은 일반적으로 Staging Area(Index)의 상태대로 Tree 개체를 만들고 기록한다. 그래서 Tree 개체를 만들려면 Staging Area에 파일을 추가해서 Index를 만들어 줘야 한다. 우선 Plumbing 명령 `update-index`로 `test.txt` 파일만 들어 있는 Index를 만든다. 이 명령으로 test.txt 파일을 인위적으로 Staging Area에 추가하는 것이다. 아직 Staging Area에 없는 파일이기 때문에 `--add` 옵션을 꼭 줘야 한다(사실 아직 Staging Area도 설정하지 않았다). 그리고 디렉토리에 있는 파일이 아니라 데이터베이스에만 있는 파일을 추가하는 것이기 때문에 `--cacheinfo` 옵션이 필요하다. 그리고 파일 모드, SHA-1 해시, 파일 이름을 지정해준다:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

여기서 파일 모드는 보통의 파일을 나타내는 `100644`로 지정했다. 실행파일이라면 `100755`로 지정하고, 심볼릭 링크라면 `120000`으로 지정한다. 이런 파일 모드는 유닉스에서 가져오긴 했지만, 유닉스 모드를 전부 사용하지는 않는다. Blob 파일에는 이 세 가지 모드만 사용한다. 디렉토리나 서브모듈에는 다른 모드를 사용한다.

이제 Staging Area를 Tree 개체로 저장하려면 `write-tree` 명령을 사용한다. `write-tree` 명령은 Tree 개체가 없으면 자동으로 생성하므로 `-w` 옵션이 필요 없다:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

다음 명령으로 이 개체가 Tree 개체라는 것을 확인한다:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

파일을 새로 하나 추가하고 test.txt 파일의 두 번째 버전을 만들어 새 Tree 개체를 만들어 보자:

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

새 파일인 new.txt와 새 버전의 test.txt 파일까지 Staging Area에 추가했다. 현재 상태의 Staging Area를 새로운 Tree 개체로 기록하면 어떻게 보이는지 살펴보자:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

이 Tree 개체에는 파일이 두 개 있고 test.txt 파일의 SHA 값도 두 번째 버전인 `1f7a7a1`이다. 재미난 걸 해보자. 처음에 만든 Tree 개체를 하위 디렉토리로 만들 수 있다. `read-tree` 명령으로 Tree 개체를 읽어 Staging Area에 추가한다. `--prefix` 옵션을 주면 Tree 개체를 하위 디렉토리로 추가할 수 있다.

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

지금 만든 Tree 개체로 Working Directory를 만들면 파일이 두 개와 `bak`이라는 하위 디렉토리가 있을 것이다. 그리고 `bak` 디렉토리 안에는 test.txt 파일의 처음 버전이 들어 있다. Git은 그림 9-2와 같은 구조로 데이터를 저장한다고 생각하면 된다.

Insert 18333fig0902.png 
Figure 9-2. Git 데이터 구조.

### Commit 개체 ###

각기 다른 Snapshot을 나타내는 Tree 개체를 세 개 만들었다. 하지만, 여전히 이 Snapshot을 불러 내려면 SHA-1 값을 기억하고 있어야 한다. 또한, Snapshot을 누가, 언제, 왜 저장했는지에 대한 정보가 아예 없다. 이런 정보는 Commit 개체에 저장된다:

Commit 개체는 `commit-tree` 명령으로 만든다. 이 명령에 Commit 개체에 대한 설명과 Tree 개체의 SHA-1 값 한 개를 넘겨준다. 앞서 저장한 첫 번째 Tree를 가지고 아래와 같이 만들어 본다:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

새로 생긴 Commit 개체를 `cat-file` 명령으로 확인해보자:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Commit 개체의 형식은 간단하다. 해당 Snapshot에서 최상단 Tree를(역주 - 루트 디렉터리 같은) 하나 가리키고 `user.name`과 `user.email` 설정에서 가져온 Author/Committer 정보, 시간 정보, 그리고 한 줄 띄운 다음 커밋 메시지가 들어 있다.

이제 Commit 개체를 두 개 더 만들어 보자. 각 Commit 개체는 이전 개체를 가리키도록 한다:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

세 Commit 개체는 각각 해당 Snapshot을 나타내는 Tree 개체를 하나씩 가리키고 있다. 이상해 보이겠지만 우리는 진짜 Git 히스토리를 만들었다. 마지막 Commit 개체의 SHA-1 값을 주고 `git log` 명령을 실행하면 아래와 같이 출력한다:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

놀랍지 않은가! 방금 우리는 고수준 명령어 없이 저수준의 명령으로만 Git 히스토리를 만들었다. 지금 한 일이 `git add`와 `git commit` 명령을 실행했을 때 Git 내부에서 일어나는 일이다. Git은 변경된 파일을 Blob 개체로 저장하고 현 Index에 따라서 Tree 개체를 만든다. 그리고 이전 Commit 개체와 최상위 Tree 개체를 참고해서 Commit 개체를 만든다. 즉 Blob, Tree, Commit 개체가 Git의 주요 개체이고 이 개체들은 각각 `.git/objects` 디렉토리에 저장된다. 위의 예에서 생성한 개체는 다음과 같다:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

내부의 포인터를 따라가면 그림 9-3과 같은 그래프가 그려진다.

Insert 18333fig0903.png 
Figure 9-3. Git 저장소 내의 모든 개체.

### 개체 저장소 ###

내용과 함께 헤더도 저장한다고 얘기했다. 잠시 Git이 개체를 어떻게 저장하는지부터 살펴보자. "what is up, doc?" 문자열을 가지고 대화형 Ruby 쉘 `irb` 명령어로 흉내 내 보자:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git은 개체의 타입을 시작으로 헤더를 만든다. 그다음에 공백 문자 하나, 내용의 크기, 마지막에 널 문자가 추가된다:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git은 헤더와 원래 내용을 붙이고 붙인 것으로 SHA-1 체크섬을 계산한다. `require`로 SHA1 라이브러리를 가져다가 Ruby에서도 흉내 낼 수 있다. `require`로 라이브러리를 포함하고 나서 `Digest::SHA1.hexdigest()`를 호출한다:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git은 또 zlib으로 내용을 압축한다. Ruby에도 zlib 라이브러리가 있으니 Ruby에서도 할 수 있다. 라이브러리를 포함하고 `Zlib::Deflate.deflate()`를 호출한다:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

마지막으로 zlib으로 압축한 내용을 개체로 저장한다. SHA-1 값 중에서 맨 앞에 있는 두 자를 가져다 하위 디렉토리 이름으로 사용하고 나머지 38자를 그 디렉토리 안에 있는 파일이름으로 사용한다. Ruby에서는 `FileUtils.mkdir_p()`로 하위 디렉토리의 존재를 보장하고 나서 `File.open()`으로 파일을 연다. 그리고 그 파일에 zlib으로 압축한 내용을 `write()` 함수로 저장한다.

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

다 됐다. 이제 Git Blob 개체를 손으로 만들었다. Git 개체는 모두 이 방식으로 저장되며 단지 종류만 다를 뿐이다. Blob 개체가 아니면 헤더가 그냥 `commit`이나 `tree`로 시작하게 되는 것뿐이다. Blob 개체는 여기서 보여준 것이 거의 전부지만 Commit이나 Tree 개체는 각기 다른 형식을 사용한다.

## Git 레퍼런스 ##

`git log 1a410e` 라고 실행하면 전체 히스토리를 볼 수 있지만, 여전히 `1a410e`를 기억해야 한다. 이 커밋은 마지막 커밋이기 때문에 히스토리를 따라 모든 개체를 조회할 수 있다. SHA-1 값을 날로 사용하기보다 쉬운 이름으로 된 포인터를 사용하는 것이 더 좋다. 즉 SHA-1 값을 쉬운 이름으로 저장한 파일이 필요하다.

Git에서는 이런 것을 "레퍼런스" 또는 "refs"라고 부른다. `.git/refs` 디렉토리에 SHA-1 값이 들어 있는 파일이 있다. 현 프로젝트에 아직 레퍼런스는 하나도 없지만, 그 구조는 매우 단순하다:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

레퍼런스가 있으면 마지막 커밋이 무엇인지 기억하기 쉽다. 사실 내부적으로는 다음과 같이 단순하다:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

SHA-1 값 대신에 지금 만든 레퍼런스를 사용할 수 있다:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

레퍼런스 파일을 직접 고치는 것은 좀 못마땅하다. Git은 좀 더 안전하게 바꿀 수 있는 `update-ref` 명령을 하고 있다:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Git의 브랜치의 역할이 바로 이것이다: 브랜치는 일련의 작업들의 헤드를 참조하는 포인터 또는 레퍼런스이다. 간단히 두 번째 커밋을 가리키는 브랜치를 만들어 보자:

	$ git update-ref refs/heads/test cac0ca

브랜치는 직접 가리키는 커밋과 그 커밋으로 따라갈 수 있는 모든 커밋을 포함한다:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

이제 Git 데이터베이스는 그림 9-4처럼 보인다.

Insert 18333fig0904.png 
Figure 9-4. 브랜치 레퍼런스가 추가된 Git 데이터베이스

`git branch (branchname)` 명령을 실행하면 Git은 내부적으로 `update-ref` 명령을 실행한다. 입력받은 브랜치 이름과 현 브랜치의 마지막 커밋에서 SHA-1 값을 가져다 `update-ref` 명령을 실행하는 것이다.

### HEAD ###

`git branch (branchname)` 명령을 실행할 때 Git은 어떻게 마지막 커밋의 SHA-1 값을 아는 걸까? HEAD 파일은 현 브랜치를 가리키는 간접(symbolic) 레퍼런스다. 간접 레퍼런스이기 때문에 다른 레퍼런스와 다르게 생겼다. 이 레퍼런스은 다른 레퍼런스를 가리키는 것이라서 SHA-1 값이 없다. 파일을 열어 보면 다음과 같이 생겼다:

	$ cat .git/HEAD 
	ref: refs/heads/master

`git checkout test`를 실행하면 Git은 HEAD 파일을 다음과 같이 바꾼다:

	$ cat .git/HEAD 
	ref: refs/heads/test

`git commit`을 실행하면 Commit 개체가 만들어지는데, 지금 HEAD가 가리키고 있던 커밋의 SHA-1 값이 그 Commit 개체의 부모로 사용된다.

이 파일도 손으로 직접 편집할 수 있지만  `symbolic-ref`라는 명령어가 있어서 좀 더 안전하게 사용할 수 있다. 이 명령으로 HEAD의 값을 읽을 수 있다:

	$ git symbolic-ref HEAD
	refs/heads/master

HEAD의 값을 변경할 수도 있다:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

refs 형식에 맞지 않으면 수정할 수 없다:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Tag ###

중요한 개체 타입을 모두 살펴봤지만 남은 개체가 하나 더 있다. Tag 개체는 Commit 개체랑 매우 비슷하다. Commit 개체처럼 누가, 언제 Tag를 달았는지 Tag 메시지는 무엇이고 어떤 커밋을 가리키는지에 대한 정보가 포함된다. Tag 개체는 Tree 개체가 아니라 Commit 개체를 가리킨다는 것이 그 둘의 차이다. 브랜치처럼 Commit 개체를 가리키지만 옮길 수는 없다. Tag 개체는 늘 그 이름이 뜻하는 커밋만 가리킨다.

2장에서 살펴봤듯이 Tag는 Annotated Tag와 Lightweight Tag 두 종류로 나뉜다. 먼저 다음과 같이 Lightweight Tag를 만들어 보자:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Lightwieght Tag는 만들기 쉽다. 브랜치랑 비슷하지만 브랜치처럼 옮길 수는 없다. 이에 비해 Annotated Tag는 좀 더 복잡하다. Annotated Tag를 만들면 Git은 Tag 개체를 만들고 거기에 커밋을 가리키는 레퍼런스를 저장한다. Annotated Tag는 커밋을 직접 가리키지 않고 Tag 개체를 가리킨다. `-a` 옵션을 주고 Annotated Tag를 만들어 확인할 수 있다:

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 -m 'test tag'

Tag 개체의 SHA-1 값을 확인한다:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

`cat-file` 명령으로 해당 SHA-1 값의 내용을 조회한다:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

`object` 부분에 있는 SHA-1 값이 실제로 Tag를 단 커밋이다. 그리고 Commit 개체에 Tag를 다는 것이 아니라 Git 개체에 Tag를 다는 것이다. 그래서 모든 개체에 Tag를 달 수 있다. Git 프로젝트에서는 관리자가 자신의 GPG 공개키를 Blob 개체로 추가하고 그 파일에 Tag를 달아 둔다. 다음 명령으로 그 공개키를 확인할 수 있다:

	$ git cat-file blob junio-gpg-pub

Linux Kernel 저장소에도 커밋이 아닌 다른 개체를 가리키는 Tag 개체가 있다. 그 Tag는 저장소에 처음으로 소스 코드를 임포트했을 때 그 첫 Tree 개체를 가리킨다.

### Remote 레퍼런스 ###

그리고 Remote 레퍼런스라는 것도 있다. Remote를 추가하고 Push하면 Git은 각 브랜치마다 Push한 마지막 커밋이 무엇인지 `refs/remotes` 디렉토리에 저장한다. 예를 들어, `origin`이라는 Remote를 추가하고 `master` 브랜치를 Push 한다:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

`origin`의 `master` 브랜치에서 서버와 마지막으로 교환한 커밋이 어떤 것인지 확인하려면 `refs/remotes/origin/master` 파일을 확인한다:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Remote 레퍼런스와 `refs/heads`에 있는 레퍼런스인 브랜치와 차이점은 Checkout할 수 없다는 것이다. 이 Remote 레퍼런스는 서버의 브랜치가 가리키는 커밋이 무엇인지 적어둔 일종의 북마크이다.

## Packfile ##

테스트용 Git 저장소의 개체 데이터베이스를 다시 살펴보자. 아마 지금 개체는 모두 11개로 Blob 4개, Tree 3개, Commit 3개, Tag 1개가 있을 것이다:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git은 zlib으로 파일 내용을 압축하기 때문에 저장 공간이 많이 필요하지 않다. 그래서 이 데이터베이스에 저장된 파일은 겨우 925바이트밖에 되지 않는다. 크기가 큰 파일을 추가해서 이 기능의 효과를 좀 더 살펴보자. 앞 장에서 사용했던 Grit 라이브러리에 들어 있는 repo.rb 파일을 추가한다. 이 파일의 크기는 약 12K이다.

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

추가한 Tree 개체를 보면 repo.rb 파일의 SHA-1 값이 무엇인지 확인할 수 있다:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

개체의 크기도 `git cat-file` 명령으로 확인할 수 있다:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

피일을 조금 수정하면 어떻게 되는지 살펴보자:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

수정한 커밋의 Tree 개체를 확인해보면 흥미로운 점을 발견할 수 있다:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

이 Blob 개체는 다른 개체다. 새 Blob 개체는 400줄 이후에 한 줄이 더 추가된 새것이다. Git은 완전히 새로운 Blob 개체를 만들어 저장한다:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

그럼 약 12K짜리 파일을 두 개 가지게 된다. 거의 같은 파일을 두 개나 가지게 되는 것이 못마땅할 수도 있다. 처음 것과 두 번째 것 사이의 차이점만 저장할 수 없을까?

가능하다. Git이 처음 개체를 저장하는 형식은 Loose 개체 포멧이라고 부른다. 하지만, 나중에 이 개체들을 파일 하나로 압축(Pack)할 수 있다. 그래서 공간을 절약하고 효율을 높일 수 있다. Loose 개체가 너무 많거나, `git gc` 명령을 실행했을 때, 그리고 리모트 서버로 Push할 때 Git은 압축한다. `git gc` 명령을 실행해서 어떻게 압축되는지 살펴보자:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

`objects` 디렉토리를 열어보면 개체 대부분이 사라졌고 한 쌍의 파일이 새로 생긴 것을 확인할 수 있다:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

아직 남아 있는 Blob 개체는 어떤 커밋도 가리키지 않는 개체다. 즉, "what is up, doc?"과 "test content" 예제에서 만들었던 개체이다. 어떤 커밋에도 추가돼 있지 않으면 이 개체는 `dangling` 상태라고 취급되고 Packfile에 추가되지 않는다.

새로 생긴 파일은 Packfile과 그 Index이다. 파일 시스템에서 삭제된 개체가 전부 이 Packfile에 저장된다. Index 파일은 빠르게 찾을 수 있도록 Packfile의 오프셋이 들어 있다. `git gc` 명령을 실행하기 전에 있던 파일 크기는 약 12K 정도였었는데 새로 만들어진 Packfile은 겨우 6K에 불과하다. 짱이다. 개체를 압축하면 디스크 사용량은 절반으로 줄어든다.

어떻게 이런 일이 가능할까? 개체를 압축하면 Git은 먼저 이름이나 크기가 비슷한 파일을 찾는다. 그리고 두 파일을 비교해서 한 파일은 다른 부분만 저장한다. Git이 얼마나 공간을 절약해 주는지 Packfile을 열어 확인할 수 있다. `git verify-pack` 명령어는 압축한 것을 보여준다:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1
	05408d195263d853f09dca71d55116663690c27c \
	  ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

`9bc1d1` Blob이 처음 추가한 `repo.rb` 파일인데, 이 Blob은 두 번째 버전인 `05408` Blob을 가리킨다. 개체에서 세 번째 컬럼은 압축된 개체의 크기를 나타낸다. `05408`의 크기는 12K지만 `9bc1d`는 7바이트밖에 안 된다. 특이한 점은 원본을 그대로 저장하는 것이 첫 번째가 아니라 두 번째 버전이라는 것이다. 첫 번째 버전은 차이점만 저장된다. 보통 최신 버전에 접근하는 속도가 더 빨라야 하기 때문에 이렇게 하는 것이다.

이 기능이 정말 죽여주는 점은 언제나 다시 압축할 수 있다는 것이다. Git은 자동으로 데이터베이스를 재압축해서 공간을 절약한다. 그리고 `git gc` 명령으로 언제나 직접 다시 압축할 수도 있다.

## Refspec ##

이 책에서 리모트 브랜치와 로컬 레퍼런스로 연결하는 것이 간단하다고 배웠지만 실제로는 좀 더 복잡하다. 다음과 같은 리모트 저장소를 추가해보자:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

이 명령은 `origin`이라는 저장소가 있고, 그 URL은 무엇인지, Fetch할 Refspec은 무엇인지를 `.git/config` 파일에 추가한다.

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Refspec 형식은 `+`와 `<src>:<dest>`로 돼 있다. `+`는 생략 가능하고, `<src>`은 리모트 저장소의 레퍼런스 패턴이고, `<dst>`는 매핑될 로컬 저장소의 레퍼런스 패턴이다. `+`가 없으면 Fast-forward가 아니면 업데이트되지 않는다.

`git remote add` 명령은 알아서 생성한 설정대로 서버의 `refs/heads/`에 있는 레퍼런스를 가져다 `refs/remotes/origin/` 디렉토리에 만든다. 서버에 있는 `master` 브랜치는 로컬에서 다음과 같이 접근해 사용할 수 있다:

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Git은 이 세 개를 모두 `refs/remotes/origin/master`라고 해석하기 때문에 모두 같다.

`master` 브랜치만 Pull할 수 있게 만들려면 `fetch` 부분을 다음과 같이 바꿔준다. 그러면 다른 브랜치는 Pull할 수 없다:

	fetch = +refs/heads/master:refs/remotes/origin/master

이것은 해당 리모트 저장소에 `git fetch` 명령이 사용하는 자동 Refspec일 뿐이다. 명령을 실행할 때 다른 Refspec이 필요하면 그냥 인자로 넘기면 된다. 리모트 브랜치 `master`를 로컬 브랜치 `origin/mymaster`로 가져오려면 다음과 같이 실행한다.

	$ git fetch origin master:refs/remotes/origin/mymaster

동시에 Refspec을 여러 개 줄 수도 있다. 다음과 같이 한꺼번에 브랜치 여러 개를 가져온다:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

여기서 `master` 브랜치는 Fast-forward가 아니라서 거절된다. Refspec 앞에 `+`를 추가하면 강제로 덮어쓴다.

설정 파일에도 Refspec을 여러 개 적을 수 있다. 항상 `master`와 `experiment` 브랜치를 함께 가져오려면 둘 다 적어 준다:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

하지만, Glob 패턴은 사용할 수 없다:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

그 대신 일종의 네임스페이스를 사용할 수 있다. 만약 QA 팀이 Push하는 브랜치가 있고 이 브랜치를 가져오고 싶으면 다음과 같이 설정한다. 다음은 `master` 브랜치와 QA 팀의 브랜치만 가져오는 설정이다:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

이 방법으로 좀 더 복잡한 것도 가능하다. QA 팀뿐만 아니라, 일반 개발자, 통합 팀 등등이 사용하는 브랜치를 네임스페이스 별로 구분해 놓으면 좀 더 Git을 편리하게 사용할 수 있다.

### Refspec Push하기 ###

네임스페이스 별로 가져오는 방법은 끝내 주지만 어떻게 Push할까? QA 팀은 `qa/` 네임스페이스에 자신의 브랜치를 어떻게 올릴 수 있을까? Push할 때도 Refspec을 사용할 수 있다.

QA 팀은 `master` 브랜치를 리모트 저장소에 `qa/master`로 Push할 수 있다:

	$ git push origin master:refs/heads/qa/master

`git push origin`을 실행할 때마다 Git이 자동으로 Push하게 하려면 다음과 같이 설정 파일에 `push` 항목을 추가한다:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

다시 말하지만 `git push origin`을 실행하면 로컬 브랜치 `master`가 리모트 브랜치 `qa/master`로 Push된다.

### 레퍼런스 삭제하기 ###

Refspec으로 서버에 있는 레퍼런스를 삭제할 수 있다:

	$ git push origin :topic

Refspec의 형식은 `<src>:<dst>`이니까 `<src>`를 비우면 `<dst>`를 비우라는 의미가 된다. 그래서 `<dst>`는 삭제된다.

## 데이터 전송 프로토콜 ##

Git은 두 저장소 간 데이터를 전송할 때 주로 두 가지 종류의 프로토콜을 사용한다. 하나는 HTTP이며 다른 종류는 Smart 프로토콜이라고 부를 수 있는 `file://`, `ssh://`, and `git://` 프로토콜을 사용한다. 주로 사용하는 이 두 가지 종류의 프로토콜을 통해 Git이 어떻게 데이터를 전송하는지 살펴볼 것이다.

### Dumb 프로토콜 ###

Git이 HTTP로 데이터를 전송할 때 Dumb 프로토콜이라고 부른다. 데이터를 전송할 때 서버에서는 Git만을 위해 특화된 코드를 전혀 사용하지 않기 때문이다. Fetch 하는 과정은 여러 개의 GET 요청을 순서대로 보내고 데이터를 받는다. Git은 서버의 Git 저장소 구성이 일반적인 Git 저장소의 모습이라고 가정한다. `simplegit` 라이브러리에 대한 `http-fetch` 과정을 살펴보자:

	$ git clone http://github.com/schacon/simplegit-progit.git

처음으로 하는 일은 `info/refs` 파일을 내려받는 것이다. 이 파일은 `update-server-info` 명령으로 작성되기 때문에 `post-receive` 훅에서 `update-server-info` 명령을 호출해줘야만 HTTP 전송이 잘 이루어진다.

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

리모트 레퍼런스와 SHA 값이 든 목록을 가져왔고 다음은 HEAD 레퍼런스를 찾는다. 이 HEAD 레퍼런스 덕택에 Git은 데이터를 내려받고 나서 어떤 레퍼런스를 Checkout할 지 알게 된다:

	=> GET HEAD
	ref: refs/heads/master

데이터 전송을 마치고 나면 `master` 브랜치를 Checkout할 준비가 끝난다. 이 시점에서 `info/refs`에 보면 `master` 브랜치는 `ca82a6` Commit 개체를 기점으로 시작한다. 그래서 그 커밋을 기점으로 Fetch한다:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

개체는 서버에 Loose 형식으로 돼 있기 때문에 HTTP 서버에 있는 정적 파일을 가져오는 것처럼 가져오면 된다. 이렇게 서버로부터 얻어온 개체를 zlib로 압축을 풀고 header를 떼어 내면 다음과 같은 모습이 된다:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

아직 개체 두 개를 더 내려받아야 한다. `cfda3b` 개체는 방금 내려받은 Commit 개체의 Tree 개체이고, `085bb3` 개체는 부모 Commit 개체이다:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

위와 같이 Commit 개체는 내려받았다. 하지만, Tree 개체를 내려받으려고 하면:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

이런! 존재하지 않는다는 404 메시지를 받았다. 해당 Tree 개체는 서버에 Loose 형식으로 저장돼 있지 않은가보다. 이런 상황이 벌어지는 이유가 좀 있다. 해당 개체가 다른 저장소에 있거나 저장소의 Packfile 속에 들어 있을 때 그렇다. 우선 Git은 다른 저장소 목록에서 찾는다:

	=> GET objects/info/http-alternates
	(empty file)

다른 저장소 목록이 비워져 있으면 Git은 Packfile에서 해당 개체를 검색한다. 그래서 Git은 프로젝트를 Fork 해도 디스크 공간을 효율적으로 사용할 수 있게 해준다. 우선 서버로부터 받은 다른 저장소 목록이 비어 있기 때문에 개체는 확실히 Packfile 속에 있을 것이다. 서버에 어떤 Packfile이 있는지 살펴보려면 `objects/info/packs` 파일이 필요하다. 이 파일 또한 `update-server-info` 명령에 의해 작성된다.

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

현재 서버에는 Packfile이 하나 있고 당연히 개체는 이 파일 속에 있다. 확실히 확인해보기 위해 Packfile의 인덱스(Packfile이 포함하는 파일의 목록)에서 확인한다. 서버에 Packfile이 여러 개 있으면 이런 식으로 인덱스를 검색해서 원하는 개체가 있는 Packfile을 찾는다:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

이제 Packfile의 인덱스를 가져와서 개체가 들어 있는지 확인한다. Packfile Index에 해당 개체의 SHA 값과 오프셋을 파악할 수 있다. 찾았으면 해당 Packfile을 내려받도록 한다:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Tree 개체를 얻어 오고 나면 다시 커밋 데이터를 가져 온다. 아마도 방금 내려받은 Packfile 속에 모든 커밋 데이터가 들어 있을 것이기 때문에 서버로 다시 데이터 전송 요청을 보내지 않아도 된다. Git은 HEAD가 가리키는 `master` 브랜치에 대한 소스코드를 복원해놓을 것이다.

이 과정에서 출력하는 것을 한 번에 모아 보면 다음과 같다:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### Smart 프로토콜 ###

HTTP 프로토콜은 매우 단순하다는 장점이 있으나 전송은 효율적이지 못하다. Smart 프로토콜로 데이터를 전송하는 것이 더 일반적이다. 이 프로토콜은 리모트 서버에서 할 일이 좀 있다. 서버는 클라이언트가 어떤 데이터를 갖고 있고 어떤 데이터가 필요한지 분석하여 실제로 전송할 데이터를 추려낼 수 있다. 데이터 전송을 위해서 크게 두 가지로 나눌 수 있는데 하나는 데이터를 업로드하는 것이고 다른 하나는 다운로드하는 것이다.

#### 데이터 업로드 ####

리모트 서버로 데이터를 업로드하는 과정에서 Git은 `send-pack`과 `receive-pack`으로 나눌 수 있다. 클라이언트에서 실행되는 `send-pack` 과정과 서버의 `receive-pack` 과정은 서로 연결된다.

예를 들어 `origin`이 SSH 프로토콜 URL로 설정된 상태에서 `git push origin master` 명령을 실행하면 Git은 `send-pack` 과정을 시작한다. 이 과정은 우선 서버에 SSH 연결을 만든다:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

`git-receive-pack` 명령은 우선 가진 레퍼런스 정보를 한 줄에 하나씩 보여준다. 이 예제는 첫 번째 줄에 `master` 브랜치의 이름과 SHA 체크섬을 보여준다. 그리고 첫 번째 줄에는 서버의 Capability도 보여준다(여기서는 `report-status`와 `delete-refs`이다).

각 줄의 첫 번째 4바이트의 Hex 값은 4바이트를 제외한 각 줄의 나머지 길이를 나타낸다. 첫 번째 줄이 005b로 시작하는데 이 Hex 값은 91을 나타낸다. 즉 첫 번째 줄의 처음 4바이트를 제외한 나머지 길이는 91바이트라는 것이다. 다음 줄의 값은 003b이며 이는 62바이트를 나타낸다. 마지막 줄은 값이 0000이며 이는 서버가 레퍼런스 목록의 출력을 끝냈다는 것을 의미한다.

`send-pack` 과정에서 이렇게 서버가 가진 정보를 알고 나면 어떤 커밋 데이터가 서버에 없는가를 분석한다. `send-pack`은 Push할 레퍼런스에 대한 정보를 서버의 `receive-pack`에 전달한다. 예를 들어 `master` 브랜치를 업데이트하고 `experiment` 브랜치를 추가하려 한다면 `send-pack`은 서버에 다음과 같은 정보를 서버에 보낸다:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

SHA-1 값이 모두 0이면 전에 없었던 것이다. 새로 추가하는 `experiment` 레퍼런스가 이에 해당한다. 반대로 레퍼런스를 삭제하려면 반대편 즉 업데이트를 할 오른편 위치의 해시 값을 모두 0으로 채운다.

Git은 업데이트할 레퍼런스의 예전 SHA, 새로운 SHA, 레퍼런스 이름을 각 줄에 담아 전송한다. 첫 번째 줄에는 클라이언트의 Capability도 포함된다. 그다음 클라이언트는 서버가 갖고 있지 않은 모든 데이터를 하나의 Packfile에 담아서 전송한다. 마지막으로 서버는 성공적으로 데이터를 처리했다고 응답하거나 아니면 실패했다고 응답한다:

	000Aunpack ok

#### 데이터 다운로드 ####

데이터를 다운로드하는 것에는 `fetch-pack`과 `upload-pack` 과정으로 나뉜다. 클라이언트가 `fetch-pack` 과정을 시작하면 서버의 `upload-pack` 과정에 연결되고 서로 어떤 데이터를 내려받을지 논의한다.

리모트 저장소에서 `upload-pack` 과정을 시작하는 방법은 여러 가지다. `receive-pack` 과정처럼 SSH를 이용할 수도 있고 기본 포트가 9418인 Git 데몬을 이용할 수도 있다. 데몬에 연결되고 나면 `fetch-pack`은 다음과 같은 데이터를 전송한다:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

처음 4바이트는 뒤에 이어지는 데이터의 길이를 나타낸다. 첫 번째 NULL 바이트까지가 실행할 명령이고 다음 NULL 바이트까지는 연결할 서버의 호스트 이름이다. Git 데몬은 실행할 수 있는 명령인지, 저장소가 존재하는지, 권한은 있는지 등을 확인한다. 모든 것이 가능하다면 `upload-pack` 과정을 시작하고 들어오는 요청 데이터를 처리한다:

SSH 프로토콜을 사용한다면 `fetch-pack`은 다음과 같이 실행한다:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

내부 방식이야 어쨌든, `fetch-pack`과 연결된 `upload-pack`은 다음과 같은 데이터를 전송한다:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

위 `receive-pack`의 응답과 매우 비슷하지만, Capability 부분은 다를 수 있다. HEAD 레퍼런스도 알려주기 때문에 저장소를 복제했을 때 어디부터 시작해야 할지 알 수 있다.

`fetch-pack`은 이 정보에서 이미 가지는 개체에는 "have"를 붙이고 내려받아야 하는 개체는 "want"를 붙인 정보를 만든다. 마지막 줄에 "done"이라고 적어서 보내면 서버의 `upload-pack`은 해당 데이터를 Packfile로 만들어 전송하기 시작한다:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

데이터 전송 프로토콜에 대하여 아주 기초적인 상황을 통해 간단하게 살펴보았다. 클라이언트가 `multi_ack`나 `side-band`를 지원하는 더 복잡한 시나리오도 있다. 하지만, 여기에서는 Smart 프로토콜 과정을 설명하기 위해 가장 기초적인 시나리오를 설명한다.

## 운영 및 데이터 복구 ##

언젠가는 저장소를 손수 정리해야 할 날이 올지도 모른다. 저장소를 좀 더 꼼꼼하게(Compact) 하게 만들고, 다른 CVS에서 임포트하고 나서 그 잔재를 치운다든가, 아니면 문제가 생겨서 복구해야 할 수도 있다. 이 절은 이때 필요한 것을 설명한다.

### 운영 ###

Git은 때가 되면 자동으로 "auto gc" 명령을 실행한다. 물론 거의 실행되지 않는다. Loose 개체가 너무 많거나, Packfile 자체가 너무 많으면 Git은 그제야 진짜로 `git gc` 명령을 실행한다. `gc` 명령은 Garbage Collect하는 명령이다. 이 명령은 Loose 개체를 모아서 Packfile에 저장하거나 작은 Packfile을 모아서 하나의 큰 Packfile에 저장한다. 그리고 아무런 커밋도 가리키지 않는 개체가 있고 그 상태가 오래가면 그때 개체를 삭제한다.

직접 "auto gc" 명령을 실행할 수도 있다:

	$ git gc --auto

이 명령을 실행해도 보통은 아무 일도 일어나지 않는다. Loose 개체가 7천 개가 넘거나 Packfile이 50개가 넘지 않으면 Git은 실제로 `gc` 명령을 실행하지 않는다. 그리고 필요하면 `gc.auto`나 `gc.autopacklimit` 옵션으로 그 숫자를 조절할 수 있다:

`gc`는 레퍼런스를 파일 하나로 압축한다. 예를 들어 저장소에 다음과 같은 브랜치와 Tag가 있다고 하자:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

`git gc`를 실행하면 `refs`에 있는 파일들이 사라진다. 대신 Git은 그 파일을 `.git/packed-refs` 파일로 압축해서 효율을 높인다: 

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

이 상태에서 레퍼런스를 수정하면 파일을 수정하는 게 아니라 `refs/heads` 폴더에 파일을 새로 만든다. Git은 레퍼런스가 가리키는 SHA 값을 찾을 때 먼저 `refs` 디렉토리에서 찾고 없으면 `packed-refs` 파일에서 찾는다. 그러니까 어떤 레퍼런스가 있는데 `refs` 디렉토리에서 찾을 수 없다면 `packed-refs`에 있을 것이다.

마지막에 있는 `^`로 시작하는 줄을 살펴보자. 이것은 해당 Tag가 Annotated Tag라는 것을 말해준다. 그 줄의 SHA 값은 Annotated Tag가 가리키는 커밋이다.

### 데이터 복구 ###

Git을 사용하다 보면 커밋을 잃어 버리는 실수를 할 때도 있다. 보통 작업 중인 브랜치를 강제로 삭제하거나, 어떤 커밋을 브랜치 밖으로 끄집어 내버렸거나, Hard-reset 하면 그렇게 될 수 있다. 어쨌든 원치 않게 커밋을 잃어 버리면 어떻게 다시 찾아야 할까?

`master` 브랜치를 예전 커밋으로 Hard-reset하고 그것을 다시 복구해보자. 먼저 연습용 저장소를 만든다:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

`master` 브랜치를 예전 커밋으로 Reset한다:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

그리하여 최근 커밋 두 개는 어떤 브랜치도 가리키지 않게 됐다. 잃어 버렸다고 볼 수 있다. 그 두 커밋을 브랜치에 다시 포함하려면 마지막 커밋이 무엇인지 찾아야 한다. SHA 값을 기억할 리도 없고 뭔가 찾아낼 방법이 필요하다.

보통 `git reflog` 명령을 사용하는 게 가장 쉽다. HEAD가 가리키는 커밋이 바뀔 때마다 Git은 자동으로 그 커밋이 무엇이었는지 기록해둔다. 커밋을 새로 하거나 브랜치를 바꾸면 Reflog도 늘어난다. 또한 "Git 레퍼런스" 절에서 배운 `git update-ref` 명령으로 직접 Reflog를 남길 수 있다. 물론 `.git/HEAD` 파일을 직접 수정해도 되지만 기록으로 남기고자 `git update-ref`를 사용한다. `git reflog` 명령만 실행하면 언제나 발자취를 돌아볼 수 있다:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Checkout했었던 커밋 두 개만 보여 주는데 구체적인 정보까지 보여주진 않는다. 좀 더 자세히 보려면 `git log -g` 명령을 사용해야 한다. 이 명령은 Reflog를 `log` 명령 형식으로 보여준다.

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

두 번째 커밋을 잃어버린 것이니까 그 커밋을 가리키는 브랜치를 만들어 복구한다. 그 커밋(ab1afef)을 가리키는 브랜치 `recover-branch`를 만든다:

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

`master` 브랜치가 가리키던 커밋을 `recover-branch` 브랜치가 가리키게 하여서 그 커밋 두 개는 다시 도달될 수 있게 됐다.

이보다 안 좋은 상황을 가정해보자. 잃어 버린 두 커밋을 Reflog에서 못 찾았다. `recover-branch`를 다시 삭제하고 Reflog를 삭제하여 이 상황을 재연하자. 그러면 그 두 커밋은 다시 도달할 수 없게 된다:

	$ git branch -D recover-branch
	$ rm -Rf .git/logs/

Reflog 데이터는 `.git/logs/` 디렉토리에 있기 때문에 그 디렉토리를 지우면 Reflog도 다 지워진다. 그러면 커밋을 어떻게 복구할 수 있을까? 한 가지 방법이 있는데 `git fsck` 명령으로 데이터베이스의 Integrity를 검사할 수 있다. 이 명령에 `--full` 옵션을 주고 실행하면 가리키는 개체가 없는 개체를 모두 보여준다:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293


결과에 보이는 저 Dangling 커밋이 잃어버린 커밋이니까 그 SHA를 가리키는 브랜치를 만들어 복구한다.

### 개체 삭제 ###

Git은 너무 굉장하지만 Clone할 때 히스토리를 전부 내려받는 것이 문제가 될 때도 있다. Git은 모든 파일의 모든 버전을 내려받는다. 사실 모든 파일이 소스코드라면 아무 문제 없다. Git은 최적화를 잘해서 데이터를 잘 압축한다. 하지만, 누군가 매우 큰 파일을 넣어버리면 Clone할 때마다 그 파일을 내려받는다. 다음 커밋에서 그 파일을 삭제해도 히스토리에는 그대로 남아 있기 때문에 Clone할 때마다 포함된다.

이것은 Subversion이나 Perforce 저장소를 Git으로 변환할 때에도 문제가 된다. Subversion이나 Perforce 시스템은 전체 히스토리를 내려받는 것이 아니므로 해당 파일이 여러 번 추가될 수 있다. 또, 다른 VCS에서 Git 저장소로 임포트하려고 하는데 Git 저장소의 공간이 충분하지 않으면 너무 큰 개체는 찾아서 삭제해야 한다.

주의: 이 작업을 하다가 커밋 히스토리를 망쳐버릴 수 있다. 삭제하거나 수정할 파일이 들어 있는 커밋 이후에 추가된 커밋은 모두 재작성된다. 프로젝트를 임포트 하자마자 하는 것은 괜찮다. 아직 아무도 새 저장소를 기반으로 일하지 않기 때문이다. 그게 아니면 히스토리를 Rebase한다고 관련된 사람 모두에게 알려야 한다.

이 시나리오를 살펴보려고 먼저 저장소에 크기가 큰 파일을 넣고 다음 커밋에서는 삭제할 것이다. 그리고 나서 그 파일을 다시 찾아 저장소에서 삭제한다. 먼저 히스토리에 크기가 큰 개체를 추가한다:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

tar 파일을 넣고 나서 너무 커서 다시 삭제한다:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

`gc` 명령으로 최적화하고 나서 저장소 크기가 얼마나 되는지 확인한다:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

`count-objects` 명령은 사용하는 용량이 얼마나 되는지 알려준다:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

`size-pack` 항목의 숫자가 Packfile의 크기다. 단위가 킬로바이트라서 이 Packfile의 크기는 약 2MB이다. 큰 파일을 커밋하기 전에는 약 2K였다. 파일을 지우고 커밋해도 히스토리에서 삭제되지 않는다. 어쨌든 큰 파일이 하나 들어 있기 때문에 너무 작은 프로젝트인데도 Clone하는 사람마다 2MB씩 필요하다. 이제 그 파일을 삭제해 보자.

먼저 파일을 찾는다. 뭐, 지금은 무슨 파일인지 이미 알고 있지만 모른다고 가정한다. 어떤 파일이 용량이 큰지 어떻게 찾아낼까? 게다가 `git gc`를 실행했다면 모든 개체는 Packfile 안에 있어서 더 찾기 어렵다. Plumbing 명령어 `git verify-pack`로 파일과 그 크기 정보를 수집하고 세 번째 필드를 기준으로 그 결과를 정렬한다. 세 번째 필드가 파일 크기다. 가장 큰 파일 몇 개만 삭제할 것이기 때문에 tail 명령으로 가장 큰 파일 3개만 골라낸다.

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

마지막에 있는 개체가 2MB로 가장 크다. 이제 그 파일이 정확히 무슨 파일인지 알아내야 한다. 7 장에서 소개했던 `rev-list` 명령에 `--objects` 옵션을 추가하면 커밋의 SHA 값과 Blob 개체의 파일이름, SHA 값을 보여준다. 그 결과에서 해당 Blob의 이름을 찾는다:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

히스토리에 있는 모든 Tree 개체에서 이 파일을 삭제한다. 먼저 이 파일을 추가한 커밋을 찾는다:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

이 파일을 히스토리에서 완전히 삭제하면 `6df76` 이후 커밋은 모두 재작성된다. 이것은 6장에서 배운 `filter-branch` 명령으로 한다:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

`--index-filter` 옵션은 6장에서 배운 `--tree-filter`와 비슷한 옵션이다. `--tree-filter`는 디스크에 Checkout해서 파일을 수정하지만 `--index-filter`는 Staging Area에서 수정한다. 삭제도 `rm file` 명령이 아니라 `git rm --cached` 명령으로 삭제한다. 디스크에서 삭제하는 것이 아니라 Index에서 삭제하는 것이다. 이렇게 하는 이유는 속도가 빠르기 때문이다. Filter를 실행할 때마다 각 리비전을 디스크에 Checkout하지 않기 때문에 이것이 울트라 캡숑 더 빠르다. 즉, `--tree-filter`로도 같은 것을 할 수 있다. 단지 느릴 뿐이다. 그리고 `git rm` 명령에 `--ignore-unmatch` 옵션을 주면 파일이 없는 경우에 에러를 출력하지 않는다. 마지막으로 문제가 생긴 것은 `6df7640` 커밋부터라서 `filter-branch` 명령에 `6df7640` 커밋부터 재작성하라고 알려줘야 한다. 그렇지 않으면 첫 커밋부터 시작해서 불필요한 것까지 재작성해 버린다.

히스토리에서는 더는 그 파일을 가리키지 않는다. 하지만, Reflog나 filter-branch를 실행할 때 생기는 레퍼런스가 있다. `filter-branch`는 `.git/refs/original` 디렉토리에 실행될 때의 상태를 저장한다. 그래서 이 파일도 삭제하고 데이터베이스를 다시 압축해야 한다. 압축하기 전에 해당 개체를 가리키는 레퍼런스는 모두 없애야 한다:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

공간이 얼마나 절약됐는지 확인한다:

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

압축된 저장소의 크기는 7K로 내려갔다. 2MB보다 한참 작다. 하지만, size 항목은 아직 압축되지 않는 Loose 개체의 크기를 나타내는데 그 항목이 아직 크다. 즉, 아직 완전히 제거된 것은 아니다. 하지만, 이 개체는 Push할 수도 Clone할 수도 없다. 이 점이 중요하다. 정말로 완전히 삭제하려면 `git prune --expire` 명령으로 삭제해야 한다.

## 요약 ##

Git이 내부적으로 어떻게 동작하는지 잘 이해하였으며 어떻게 구현됐는지까지 꽤 알게 됐을 것이다. 이 장은 저수준 명령어인 Plumbing 명령어들을 설명했다. 다른 장에서 우리가 배웠던 Porcelain 명령어보다는 단순하다. Git이 내부적으로 어떻게 동작하는지 알면 Git이 왜 그렇게 하는가를 더 쉽게 이해할 수 있을 뿐만 아니라 개인적으로 필요한 도구나 스크립트를 만들어 자신의 Workflow를 개선할 수 있다.

Git은 Content-addressble 파일 시스템이기 때문에 VCS 이상의 일을 할 수 있는 매우 강력한 도구다. 필자는 독자가 새로 배운 Git 내부에 대한 지식을 활용해서 필요한 애플리케이션을 만들었으면 좋겠다. 그리고 진정 Git을 꼼꼼하고 디테일하게 다룰 수 있게 되길 바란다.
