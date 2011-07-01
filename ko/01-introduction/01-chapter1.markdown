# Getting Started #
시작하기

이 챕터는 Git을 처음 사용하는 법에 대해 다룰 것이다. 나는 버전 관리 도구들에 대한 지식들을 먼저 설명한 후에 git을 설치하는 방법을 다루고 마지막으로 설정해서 사용하는 방법에 대해 다룰 것이다. 이 장을 다 읽고 나면 Git의 탄생배경, Git을 사용하는 이유, Git을 설정하고 사용하는 방법을 알게 될 것이다.

This chapter will be about getting started with Git.  We will begin at the beginning by explaining some background on version control tools, then move on to how to get Git running on your system and finally how to get it setup to start working with.  At the end of this chapter you should understand why Git is around, why you should use it and you should be all setup to do so.

## About Version Control ##
버전 컨트롤이란?

버전 컨트롤은 뭐고 왜 알아야 할까? 버전 컨트롤은 파일들의 변화를 시간에 따라 기록하는 시스템을 말한다. 이 책에 있는 모든 예제들은 모두 버전 컨트롤 시스템을 사용한다. 실제로 컴퓨터에서 사용하는 거의 모든 종류의 파일들은 버전 컨트롤할 수 있다.

What is version control, and why should you care? Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later. For the examples in this book you will use software source code as the files being version controlled, though in reality you can do this with nearly any type of file on a computer.

당신이 그래픽 디자이너이거나 웹 디자이너라면 이미지나 레이아웃의 모든 버전을 관리하고 싶을때 VCS(Version Control System)을 사용하는 것이 현명하다. VCS를 사용하면 파일을 이전 상태로 되돌릴 수도 있고, 프로젝트 전체를 이전 상태로 되돌릴 수도 있고, 수정내역을 계속 비교해 볼 수도 있고, 누가 문제를 만들었는지도 추적할 수 있고, 이슈를 누가 언제 제기했는지도 알 수 있다. VCS를 사용하면 파일을 잃거나 잘못 고쳤을 때 쉽게 복구할 수 있다. 이 모든 것을 얻는데 드는 오버헤드도 별로 없다.

If you are a graphic or web designer and want to keep every version of an image or layout (which you would most certainly want to), a Version Control System (VCS) is a very wise thing to use. It allows you to revert files back to a previous state, revert the entire project back to a previous state, compare changes over time, see who last modified something that might be causing a problem, who introduced an issue and when, and more. Using a VCS also generally means that if you screw things up or lose files, you can easily recover. In addition, you get all this for very little overhead.

### Local Version Control Systems ###
로컬 버전 컨트롤 시스템

많은 사람들이 버전을 관리하는 방법으로 다른 디렉토리로 파일을 복사하는 방법이 있다(현명한 사람이라면 디렉토리 이름에 시간을 활용했을 것이다). 이 방법은 간단하기 때문에 자주 사용한다. 그렇지만 정말 에러나기 쉽니다. 작업하고 있는 디렉토리를 잃어버리거나 실수로 파일을 잘못 고칠 수도 있고 잘못 복사할 수도 있다.

Many people’s version-control method of choice is to copy files into another directory (perhaps a time-stamped directory, if they’re clever). This approach is very common because it is so simple, but it is also incredibly error prone. It is easy to forget which directory you’re in and accidentally write to the wrong file or copy over files you don’t mean to.

이런 이유로 프로그래머들은 오래전에 로컬 VCS를 만들었다. 그 VCS는 버전 컨트롤중인 파일의 변경 정보를 저장하기 위해 아주 간단한 데이터베이스을 사용했다. 

To deal with this issue, programmers long ago developed local VCSs that had a simple database that kept all the changes to files under revision control (see Figure 1-1).

Insert 18333fig0101.png 
Figure 1-1. Local version control diagram.
그림 1-1. 로컬 버전 컨트롤 다이어그램.

인기있는 VCS 도구 중에 rcs라고 부르는 것이 있는데 오늘날까지도 아직 많은 회사들이 배포 하고 있다. 심지어 인기있는 Mac OS X 운영체제에서 Developer Tools를 설치할때에도 rcs는 함께 설치된다. 이 툴은 기본적으로 patch set(파일의 다른 부분만)을 관리한다. 이 patch set을 위한 특수한 포멧이 있고 디스크에 저장한다. 일련의 patch set을 적용하므로써 모든 파일을 특정 시점으로 되돌릴 수 있다.

One of the more popular VCS tools was a system called rcs, which is still distributed with many computers today. Even the popular Mac OS X operating system includes the  rcs command when you install the Developer Tools. This tool basically works by keeping patch sets (that is, the differences between files) from one change to another in a special format on disk; it can then re-create what any file looked like at any point in time by adding up all the patches.

### Centralized Version Control Systems ###
중앙집중식 버전콘트롤 시스템

다른 개발자와 협업해야만 하는 경우도 많다. 이런 경우에 생기는 문제를 해결하기 위해 CVCS(Centralized Version Control System)가 개발됐다. CVS, Subversion, Perforce같은 시스템들은 모든 파일을 관리하는 서버가 별도로 있고 다수의 클라이언트들이 중앙 서버에서 파일을 체크아웃한다. 몇 년 동안 이러한 시스템들이 많은 사랑을 받았다.

The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems, such as CVS, Subversion, and Perforce, have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control (see Figure 1-2).

Insert 18333fig0102.png 
Figure 1-2. Centralized version control diagram.
그림 1-2. 중앙집중식 버전 컨트롤 다이어그램.

이 환경은 로컬 VCS비해 많은 장점이 있다. 예를 들어, 누가 무었을 하고 있는지 프로젝트에 참여하고 있는 사람 모두 알 수 있다. 관리자는 누가 무었을 할 수 있는지 세세히 관리할 수 있다. 모든 클라이언트의 로컬 데이터페이스를 관리하는 것보다 CVS 하나를 관리하는 것이 훨씬 쉽다.

This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client.

그러나 이런 환경은 몇 가지 치명적인 결점이 있다. 가장 대표되는 것은 중앙 서버에서 생기는 문제다. 만약 서버가 한 시간 동안 다운된다면 그동안 아무도 다른 사람과 협업을 할 수 없고 사람들이 하고 있는 일을 백업할 수 있는 방법도 마땅히 찾을 수 없다. 그리고 중앙 데이터베이스가 있는 하드디스크에 문제가 생긴다면 프로젝트의 모든 히스토리를 잃게 된다. 물론 사람들마다 하나씩 가지고 있는 snapshot은 괜찮다. 로컬 VCS 시스템도 비슷하다. 만약 같은 문제가 발생하면 모든 것을 잃게 된다.

However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything—the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCS systems suffer from this same problem—whenever you have the entire history of the project in a single place, you risk losing everything.

### Distributed Version Control Systems ###
DVCS(Distributed Version Control Systems) 

이제 DVCS 차례다. Git, Mecurial, Bazaar, Darcs같은 DVCS에서는 클라이언트가 파일의 마지막 snapshot을 체크아웃하지 않는다. 단지 repository를 전부 복제할 뿐이다. 서버가 죽으면 그 복제물로 다시 작업을 시작할 수 있다. 클라이언트 중에서 아무거나 골라도 서버를 복원할 수 있다. 모든 체크아웃은 모든 데이터를 가지고 있는 진정한 백업이다.

This is where Distributed Version Control Systems (DVCSs) step in. In a DVCS (such as Git, Mercurial, Bazaar or Darcs), clients don’t just check out the latest snapshot of the files: they fully mirror the repository. Thus if any server dies, and these systems were collaborating via it, any of the client repositories can be copied back up to the server to restore it. Every checkout is really a full backup of all the data (see Figure 1-3).

Insert 18333fig0103.png 
Figure 1-3. Distributed version control diagram.
그림 1-3. 분산 버전 컨트롤 다이어그램.

게다가 대부분의 DVCS들은 다 수의 원격 레파지토리가 존재할 수 있다. 원격 레파지토리가 여러개라고 해도 아무 문제 없다. 그래서 사람들은 동시에 다양한 그룹과 다양한 방법으로 협업할 수 있다. 계층 모델같은 중앙집중식 시스템으로는 할 수 없는 몇 가지 워크플로우를 사용할 수 있다.

Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.

## A Short History of Git ##
Git의 역사

인생은 길다. Git은 창조적인 파괴와 모순속에서 가지고 태어났다. 리눅스 커널은 괭장히 규모가 큰 오픈소스 프로젝트이다. 리눅스 커널의 일생에서 대부분의 시절은 패치와 단순 파일*archived file*로만 관리했다. 2002년에 드디어 리눅스 커널은 BitKeeper라고 불리는 상용 DVCS를 사용하기 시작했다.

As with many great things in life, Git began with a bit of creative destruction and fiery controversy. The Linux kernel is an open source software project of fairly large scope. For most of the lifetime of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS system called BitKeeper.

2005년 커뮤니티가 만드는 리눅스 커널과 사익을 추구하는 회사가 개발한 BitKeeper의 관계는 틀어졌다. BitKeeper의 무료 사용이 제고된 것이다. 이것은 리눅스 개발 커뮤니티(특히 리눅스 창시자 리누스 토발즈)가 자체 도구를 만들도록 만들었다. Git은 BitKeeper를 사용하면서 배운 교훈을 기초로 다음과 같은 목표를 표방했다:

* 속도
* 단순한 설계
* 비선형적인 개발(수 천개의 동시 다발적인 브랜치)
* 완벽한 분산
* 리눅스 커널같이 대형 프로젝트에도 유용할 것(속도나 데이터 크기 면에서)

In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. Some of the goals of the new system were as follows:

*	Speed
*	Simple design
*	Strong support for non-linear development (thousands of parallel branches)
*	Fully distributed
*	Able to handle large projects like the Linux kernel efficiently (speed and data size)

Git은 2005년 탄생한 후에 아직 초기 지향점을 그대로 유지하고 있으면서도 사용하기 쉽게 진화, 성숙했다. 이건 미친듯이 빠르고 대형 프로젝트에도 굉장히 유용하다. 이 것은 동시다발적인 브랜치에도 끄떡없은 슈퍼 울트라 브랜칭 시스템이다.

Since its birth in 2005, Git has evolved and matured to be easy to use and yet retain these initial qualities. It’s incredibly fast, it’s very efficient with large projects, and it has an incredible branching system for non-linear development (See Chapter 3).

## Git Basics ##
Git의 기초

그래서 Git의 핵심은 뭘까? 이 질문은 Git을 이해하는데 굉장히 중요하다. Git이 무엇이고 어떻게 동작하는지 이해한다면 쉽게 Git을 효과적으로 사용할 수 있다. Git을 배우고 있다면 Subversion이나 Perforce같은 다른 VCS를 사용하던 경험을 지워버려야 한다. Git은 미묘하게 달라서 기존의 경험을 조금 혼란스럽게 만들어 버릴 것이다. 사용자 인터페이스는 매우 비슷하지만 Git은 다른 시스템과는 정보를 다른게 취급한다. 이 차이들을 이해 한다면 Git을 사용하는 것이 어렵지 않을 것이다.

So, what is Git in a nutshell? This is an important section to absorb, because if you understand what Git is and the fundamentals of how it works, then using Git effectively will probably be much easier for you. As you learn Git, try to clear your mind of the things you may know about other VCSs, such as Subversion and Perforce; doing so will help you avoid subtle confusion when using the tool. Git stores and thinks about information much differently than these other systems, even though the user interface is fairly similar; understanding those differences will help prevent you from becoming confused while using it.

### Snapshots, Not Differences ###
Snapshot은 모두 똑같다.

Subversion, Subversion의 친구들과 Git의 가장 큰 차이점은 데이터를 다루는 방법에 있다. 개념적으로 대부분의 다른 시스템들이 관리하는 정보는 파일들을 목록이다. CVS, Subversion, Perforce, BaZaar등의 시스템들은 파일의 집합으로 정보를 관리한다. 각 파일들의 변화를 그림 1-4처럼 시간순으로 관리한다.

The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4.

Insert 18333fig0104.png 
Figure 1-4. Other systems tend to store data as changes to a base version of each file.
그림 1-4. 각파일에 대한 변화를 저장하는 시스템들.

Git은 이런 식으로 데이터를 저장하지도 취급하지도 않는다. 대신 Git의 데이터는 아주 작은 파일 시스템의 snapshot이라고 할 수 있다. Git은 커밋하거나 프로젝트의 상태를 저장할 때마다 파일이 존재하고 있는 그 순간을 중요하게 여긴다. 성능을 위해서 파일이 달라지지 않았으면 Git은 저장하지 않는다. 단지 이전 상태의 파일에 대한 링크만 저장한다. Git은 그림 1-5처럼 동작한다.

Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. 

Insert 18333fig0105.png 
Figure 1-5. Git stores data as snapshots of the project over time.
그림 1-5. Git은 시간순으로 프로젝트의 snapshot을 저장한다.

이 것은 Git과 다른 VCS를 구분하는 중요한 점이다. Git은 이전 버전을 복사하는 다른 버전 컨트롤 시스템을 바보로 만든다. Git은 마치 작은 독자적인 파일시스템처럼 보이게 만든다. 물론 강력한 도구도 있다. Git은 단순한 VCS가 아니다. 이제 3장에서 설명할 Git 브랜칭을 사용할 때 얻을 수 있는 이득에 대해 설명할 것이다.

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

### Nearly Every Operation Is Local ###
거의 모든 명령은 로컬에서 실행된다.

거의 모든 명령은 로컬 파일과 자원만을 사용한다. 보통 네트웍에 있는 다른 컴퓨터의 정보는 필요하지 않다. 대부분의 명령어가 네트워크의 레이턴시에 영향을 받는 CVCS에 익숙하다면 Git이 매우 놀라울 것이다. Git의 이런 특징은 이런 빛의 속도는 Git신만이 구사할 수 있는 초인적인 능력이라고 생각하게 만들 것이다. 프로젝트의 모든 히스토리를 로컬 디스크에 가지고 있기 때문에 모든 명령어는 순식같에 실행된다.

Most operations in Git only need local files and resources to operate — generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

예를 들어 프로젝트의 히스토리를 조회하려 할때 Git은 서버가 필요없다. 그냥 로컬 데이터베이스에서 히스토리를 읽어서 보여 준다. 이 것은 당신이 눈깜짝할 사이에 히스토리를 조회할 수 있도록 만들어 준다. 어떤 파일의 현재버전과 한달전의 상태를 비교해보고 싶다면 git은 그냥 한달전의 파일과 지금의 파일을 찾는다. 로컬에서 비교하기 위해 원격에 있는 서버에 접근한 후 예전 버전을 가져올 필요가 없다.

For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.

즉 오프라인 상태에서도 비교할 수 있다. 비행기나 기차등에서 작업하고 네트워크에 접속하고 있지 않아도 커밋할 수 있다. 다른 시스템에서는 불가능한 일이다. 예를 들어 Perforce에서는 서버에 연결할 수 없을 때 할 수 있는 일이 별로 없다. Subversion이나 CVS에서도 마찬가지다. 데이터베이스에 접근할 수 없기 때문에 파일을 편집할 수 있지만 커밋할 수는 없다. 이 것이 매우 사소해 보일지라도 격어보면 매우 큰 차이를 느낄 수 있을 것이다.

This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.

### Git Has Integrity ###
Git은 일관적이다. 

Git은 모든 것을 저장하기 전에 체크섬을 구한 후 그 체크섬으로 관리한다. 때문에 체크섬없이 모든 파일의 내용과 디렉토리를 바꾸는 것이 불가능하다. 체크섬은 Git에서 사용하는 원자적인 데이터 단위이고 Git의 기본 철학도 이에 따른다. Git없이 작업 내용을 잃어버릴 수도 파일의 상태를 알 수도 없다. 모든 것에는 Git이 필요하다.

Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.

Git이 SHA-1 해시를 사용하여 체크섬을 만든다. 이 것은 40자 길이의 16진수 스트링이다. 파일의 내용이나 디렉토리 구조를 이용하여 체크섬을 구한다. SHA-1은 다음과 같이 생겼다.

	24b9da6552252987aa493b52f8696cd6d3b00373

The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373

Git은 모든 것을 해시값으로 사용하기 때문에 눈으로 확인할 수 있다. 실제로 Git은 파일 이름으로 저장하지 않기 때문에 해당 파일의 해시값으로만 접근 할 수 있다.

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.

### Git Generally Only Adds Data ###
Git은 일반적으로 데이터를 추가할 뿐이다.

Git으로 무엇인가를 할때 Git은 데이터를 추가할 뿐이다. 어떤 방법으로든 되돌리거나 데이터를 삭제할 수 없다. 다른 VCS에서 처럼 Git에서도 커밋하지 않았기 때문에 변경사항을 잃어버리거나 망쳐버릴 수 있다. 하지만 Git으로 snapshot을 커밋한 후에 데이터를 동일한 프로젝트의 다른 레파지토리로 푸시할 수 있다.

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

심각하게 회손시킬 걱정없이 실험할 수 있기 때문에 Git을 사용하는 것은 매우 신난다. Git이 데이터를 어떻게 저장하고 손실을 복구할 수 있는지 좀 더 알아보려면 9장의 'Under the Covers'를 보아라.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###
세가지 상태

이제 집중해야 한다. Git을 큰 어려움없이 계속 공부하기위해 반드시 기억해야 할 부분이다. Git에서 파일은 세가지 상태를 가질 수 있다. Commited, Modified, Staged가 그 세가지 상태이다. Commited는 데이터가 로컬 데이터베이스에 안전하게 저장됐다는 것을 의미한다. Modified는 수정한 파일이 아직 로컬 데이터베이스에 커밋되지 않은 것을 말한다. Staged는 현재 수정한 파일을 곧 커밋할 것이라고 마킹된 상태를 의미한다.

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

그러니까 당연히 Git 프로젝트의 세가지 단계 Git 디렉토리, 워킹 디렉토리, Staging Area를 알아야 한다.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory.
그림 1-5. 워킹 디렉토리, Staging Area, Git 디렉토리

Git 디렉토리는 Git이 해당 프로젝트의 메타데이터와 객체 데이터베이스를 저장하는 곳을 말한다. 이 것은 Git의 가장 중요한 부분이다. 다른 컴퓨터에서 레파지토리를 Clone할 때 생성된다.

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

워킹 디렉토리는 프로젝트의 특정 버전을 체크아웃한 곳을 말한다. 이 파일들은 Git 디렉토리에 있는 압축된 데이터베이스에서 가져온다. 이 것은 지금 작업하려는 디스크에 있다.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

Staging Area는 보통 Git 디렉토리에 있는 단순한 파일이다. 여기에 곧 커밋할 파일에 대한 정보를 저장한다. 하나의 인덱스와 비슷하지만 단순히 Staging Area에 파일을 참조시키는 것에 불과하다.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

기본적인 Git의 워크플로우는 다음과 같다:

1. 워킹 디렉토리에서 파일을 수정한다.
2. 파일을 Stage해서 Staging area에 있는 snapshot에 그 파일을 추가한다.
3. Staging Area에 있는 파일들을 커밋해서 Git 디렉토리에 영구적인 snapshot으로 저장한다.

The basic Git workflow goes something like this:

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

Git 디렉토리에서 파일을 수정했는데 그 것이 그 자체로 의미를 갖는다면 커밋하라. 파일을 수정하고 Staging Area에 추가했다면 단지 Stage했을 뿐이다. 체크아웃한 후에 파일을 수정하고 Stage하지 않았다면 그냥 Modified 상태가 된다. 2장에서 이 상태들에 대해서 좀 더 배울 수 있을 것이다. 거기서에서는 이 상태들의 활용법과 staged 단계를 사용하지 않는 방법도 배운다.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##
Git 설치하기

Git을 실제로 한 번 사용해 보려면 우선 설치해야 한다. 다양한 방법으로 Git을 설치할 수 있다. 그렇지만 가장 일반적인 방법은 두 가지가 있는데 하나는 소스로 설치하는 것이고 다른 하나는 각 플랫폼의 패키지로 설치하는 것이다.

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###
소스로 설치하기

가장 최신 버전을 설치할 수 있기 때문에 여력이 되면 소스로 Git을 설치하는게 유용하다. Git은 계속 UI를 개선 하고 있다. 소스를 가지고 Git을 컴파일할 수 있다면 최신 버전을 사용할 수 있다. 많은 리눅스 배포판의 패키지들은 조금 옜날 버전이다. 그래서 Backport를 사용하거나 최근 버전의 배포판을 사용하고 있지 않다면 소스로 설치하는 것이 최선일 수 있다.
 
If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

Git을 설치하려면 다음과 같은 라이브러리 들이 필요하다. Git은 curl, zlib, openssl, expat, libiconv에 의존한다. 예를 들어 Fedora처럼 yum을 가지고 있는 시스템을 사용하고 있거나 apt-get이 있는 데비안 기반 시스템을 사용하고 있다면 다음의 명령어를 실행하여 의존 패키지들을 설치할 수 있다:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev


To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

필요한 의존성을 다 해결하고 다음 단계를 진행한다. Git 웹 사이트에서 최신 snapshot을 가져온다:

	http://git-scm.com/download
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download

그리고 컴파일하고 설치한다:
	
	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Then, compile and install:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

그 다음부터는 Git을 사용하여 Git 자체를 업데이트할 수 있다:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###
리눅스에 설치하기

리눅스에서 인스톨러로 Git을 설치할 때에는 보통 각 배포판에서 사용하는 패키지 관리도구를 사용하여 설치한다. Fedora에서는 다음과 같이 한다:

	$ yum install git-core

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Ubuntu같은 데비안 기반 배포판이라면 apt-get을 사용한다:

	$ apt-get install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###
Mac에 설치하기

Mac에 Git을 설치하는 방법은 두 가지다. 가장 쉬운 방법은 GUI 인스톨러를 사용하는 방법이다. 이 것은 Google Code 페이지에서 다운받을 수 있다:

	http://code.google.com/p/git-osx-installer

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.
그림 1-7. OS X Git 인스톨러.

다른 방법은 MacPorts(`http://www.macports.org`)를 사용한 방법이다. MacPorts가 설치돼 있으면 다음과 같이 Git을 설치한다:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

이제 설치에 대한 모든 것은 알아봤다. 그렇지만 만약 Subversion 레파지토리를 Git과 함께 사용해야 하는 경우라면 svn도 필요할 것이다.

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###
윈도우에 설치하기

윈도우에 Git을 설치하는 것은 매우 쉽다. msysGit 프로젝트가 가장 쉬운 방법이다. 그냥 구글 코드 페이지에서 인스톨러를 다운받고 실행하면 된다:

	http://code.google.com/p/msysgit

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

설치가 완료되면 CLI와 GUI 둘 다 사용할 수 있다. CLI에는 유용할게 사용할 수 있는 SSH 클라이언트가 포함돼 있다.

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##
처음으로 Git을 설정하기.

Git을 설치했다면 Git의 사용 환경을 원하는 대로 설정하고 싶을 것이다. 단 한번만 설정하면 된다. 업그레이드를 해도 유지된다. 그리고 그냥 명령어를 다시 실행해서 언제든지 바꿀 수 있다.

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git은 'git config'라는 쓸만한 도구를 가지고 있다. 이 도구로 설정 변수를 확인하거나 변경할 수 있다. 이 변수를 통해 Git이 어떻게 동작해야 할지를 제어할 수 있다. 이 변수들은 세가지 위치에 저장된다.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

* `/etc/gitconfig` 파일: 시스템의 모든 사용자와 모든 레파지토리에 적용되는 설정이다. `git config --system` 옵션으로 이 파일을 일고 쓸 수 있다.
* `~/.gitconfig` 파일: 특정 사용자에게만 적용되는 설정이다. `git config --global` 옵션으로 이 파일을 읽고 쓸 수 있다.
* Git 디렉토리에 있는 config 파일(`.git/config`): 특정 레파지토리에만 적용되는 설정이다. 각각의 설정은 역순으로 오버라이드된다. 그래서 `.git/config`가 `/etc/gitconfig`보다 우선한다.

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

윈도우에서 Git은 `$HOME` 디렉토리(`C:\Documents and Settings\$USER`)에 있는 `.gitconfig` 파일을 찾는다. 물론 msysGit은 /etc/gitconfig도 사용한다. 경로는 MSys 루트에 따른 상대 경로다. 인스톨러로 msysGit을 설치할 때 설치 경로를 선택할 수 있다.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###
아이덴터티

Git을 설치한 후에 가장 처음으로 해야 하는 것은 이름과 이메일 주소를 설정하는 것이다. 이 것은 매우 중요하다. Git은 커밋할 때마다 이 정보를 사용한다. 커밋한 후에는 정보를 변경할 수 없다.

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

다시 말하지만 `--global` 옵션으로 설정한 것은 단 한번만 하면 된다. Git은 해당 시스템에서 항상 이 정보를 사용한다. 만약 프로젝트마다 다른 이름과 이메일 주소를 사용하고 싶으면 `--global` 옵션을 빼고 명령을 실행하면 된다.

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###
편집기

내가 누구인지를 설정했다. 이제는 Git에서 사용할 텍스트 편집기를 고를 차례다. Git은 시스템의 기본 편집기를 사용한다. 일반적으로는 Vi나 Vim이다. 하지만 Emacs같은 다른 텍스트 편집기를 사용하고 싶으면 다음과 같이 실행한다:

	$ git config --global core.editor emacs

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###
Diff

머지 충돌*conflict*을 해결하기 위해 사용하는 Diff 툴을 변경할 수 있다. vimdiff를 사용하고 싶으면 다음과 같이 실행한다:

	$ git config --global merge.tool vimdiff

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

kdiff3, tkdiff, meld, xxdif, emerge, vimdiff, gvimdiff, ecmerge, opendiff를 사용할 수 있다. 물론 다른 도구도 사용할 수 있다. 7장에서 좀 더 자세하게 다룬다.

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###
설정 확인하기

내 설정을 확인하려면 `git config --list` 명령을 실행한다. 그러면 모든 설정 내역을 확인할 수 있다:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Git은 같은 키를 여러 파일(`/etc/gitconfig` and `~/.gitconfig`같은)에서 읽기 때문에 같은 키가 하나 이상 나올 수도 있다. 이 경우에 Git은 나중 값을 사용한다.

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

`git config {key}` 명령을 실행시켜 Git이 특정키에 대해 어떤 값을 사용하는지 확인할 수 있다:

	$ git config user.name
	Scott Chacon

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##
도움말 보기

명령어에 대한 도움말이 필요할 때 도움말을 볼 수 있는 방법은 세가지이다:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

예를 들어 다음과 같이 실행하면 config 명령에 대한 도움말을 볼 수 있다:

	$ git help config

For example, you can get the manpage help for the config command by running

	$ git help config

이 도움말은 언제 어디서나 볼 수 있다. 오프라인 상태에서도 가능하다. 도움말과 이 책으로도 충분하지 않으면 다른 사람의 도움이 필요할 것이다. Freenode IRC 서버(irc.freenode.net)에 있는 `#git`이나 `#github` 채널로 찾아가라. 이 채널은 보통 수 백명의 사람들이 접속해 있다. 이 사람들은 모두 Git에 대해 잘 알고 있다. 기꺼히 도와줄 것이다.

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##
요약

당신은 Git이 무엇이고 당신이 지금까지 사용해 왔던 다른 CVCS와 어떻게 다른지 배웠다. 또 당신의 시스템에 Git을 성공적으로 설치하고 아이덴티티도 설정했다. 이제는 Git의 기초에 대해 배울 차례이다.

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
