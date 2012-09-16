# Başlangıç #

Bu bölümde Git kullanımı hakkında temel bilgileri bulacaksınız. İşe, versiyon kontrol sistemleri hakkında açıklamalarla başlayacağız; daha sonra Git kurulumunun nasıl yaplacağını, en son olarak da konfigürasyon ve kullanımını açıklayacağız. Bu bölümün sonunda Git'in varlık sebebini ve neden onu kullanmanız gerektiğini anlayacak, Git'i kullanmaya başlamak için kurulumu tamamlamış olacaksınız.

## Versiyon Kontrolü Hakkında ##

Versiyon kontrolü nedir ve ne işe yarar? Versiyon kontrolü, bir ya da daha fazla dosya üzerinde yapılan değişiklikleri kaydeden ve daha sonra belirli bir versiyona geri dönebilmenizi sağlayan bir sistemdir. Bu kitaptaki örneklerde yazılım kaynak kod dosyalarının versiyon kontrolünü yapacaksınız, ne var ki gerçekte versiyon kontrolünü neredeyse her türden dosya için kullanabilirsiniz.

Bir grafik ya da web tasarımcısıysanız ve bir görselin ya da tasarımın değişik versiyonlarn korumak istiyorsanız (ki muhtemelen bunu yapmak istersiniz), bir Versiyon Kontrol Sistemi (VKS) kullanmanız çok akıllıca olacaktır. VKS, dosyaların ya da bütün projenin geçmişteki belirli bir versiyonuna erişebilmenizi, zaman içinde yapılan değişiklikleri karşılaştırmanızı, soruna neden olan şeyde en son kimin değişiklik yaptığını, belirli bir hatayı kimin, ne zaman sisteme dahil ettiğini ve daha başka pek çok şeyi görebilmenizi sağlar. Öte yandan, VKS kullanmak, bir hata yaptığınızda ya da bazı dosyaları yanlışlıkla sildiğinizde durumu kolayca tel^afi etmenize yardımcı olur. Üstelik, bütün bunlar size kayda değer bir ek yük de getirmez.

### Yerel Versiyon Kontrol Sistemleri ###

Çoğu insan, dosyaları bir klasöre (akılları başlarındaysa tarih ve zaman bilgisini de içeren bir klasöre) kopyalayarak versiyon kontrolü yapmayı tercih eder. Bu yaklaşım çok yaygındır, çünkü çok kolaydır; ama aynı zamanda hatalara da olabildiğince açıktır. Hangi klasörde olduğunuzu unutup yanlış dosyaya yazabilir ya da istemediğiniz dosyaların üstüne kopyalama yapabilirsiniz.

Bu sorunla başedebilmek için, programcılar uzun zaman önce, dosyalardaki bütün değişiklikleri versiyon kontrolüne alan basit bir veritabanına sahip olan yerel VKS'ler geliştirdiler (bkz. Figür 1-1).

Insert 18333fig0101.png 
Figür 1-1. Yerel versiyon kontrol diyagramı.

En popüler VKS araçlarndan biri, bugün h^al^a pekçok bilgisayara kurulu olarak dağıtılan, rcs adında bir sistemdi. Ünlü Mac OS X işletim sistemi bile, Developer Tools'u yüklediğinizde, rcs komutunu kurmaktadır. Bu araç, iki versiyon arasındaki yamaları (yani, dosyalar arasındaki farkları) özel bir formatta diske kaydeder; daha sonra, bu yamaları birbirine ekleyerek, bir dosyann belirli bir versiyondaki görünümünü yeniden oluşturur.

### Merkezi Versiyon Kontrol Sistemleri ###

İnsanların karşılaştığı ikinci büyük sorun, başka sistemlerdeki programcılarla birlikte çalışma ihtiyacından ileri gelir. Bu sorunla başa çıkabilmek için, Merkezi Versiyon Kontrol Sistemleri (MVKS) gelitirilmiştir. Bu sistemler, mesel^a CVS, Subversion ve Perforce, versiyonlanan bütün dosyaları tutan bir sunucu ve bu sunucudan dosyaları seçerek alan (_check out_) istemcilerden oluşur. Bu yöntem, yıllarca, versiyon kontrolünde standart yöntem olarak kabul gördü (bkz. Figür 1-2).

Insert 18333fig0102.png 
Figür 1-2. Merkezi versiyon kontrol diyagramı.

Bu yöntemin, özellikle yerel VKS'lere göre, çok sayıda avantajı vardır. Örneğin, bir projedeki herkes, diğerlerinin ne yaptığından belirli ölçüde haberdardır. Sistem yöneticileri kimin hangi yetkilere sahip olacağını oldukça ayrıntılı biçimde düzenleyebilirler; üstelik bir MVKS'yi yönetmek, her istemcide ayrı ayrı kurulu olan yerel veritabanlarını yönetmeye göre çok daha kolaydır.

Ne var ki, bu yöntemin de ciddi bazı sıkıntıları vardır. En aşikar sıkıntı, merkez^i sunucunun arızalanması durumunda ortaya çıkacak kırılma noktası hatasıdır. Sunucu bir saatliğine çökecek olsa, o bir saat boyunca kullanıcıların çalışmalarını sisteme aktarmaları ya da çalıştıkları şeylerin versiyonlanmış kopyalarını kaydetmeleri mümkün olmayacaktır. Merkezi veritabanının sabit diski bozulacak olsa, yedekleme de olması gerektiği gibi yapılmamışsa, elinizdeki her şeyi —projenin, kullanıcıların bilgisayarlarında kalan yerel bellek kopyaları dışındaki bütün tarihçesini— kaybedersiniz. Yerel VKS'ler de bu sorundan muzdariptir —projenin bütün tarihçesini tek bir yerde tuttuğunuz sürece her şeyi kaybetme riskiniz vardır.

### Dağıtık Versiyon Kontrol Sistemleri ###

Bu noktada Dağıtık Versiyon Kontrol Sistemleri (DVKS) devreye girer. Bir DVKS'de (Git, Mercurial, Bazaar ya da Darcs örneklerinde olduğu gibi), istemciler (kullanıcılar) dosyaların yalnızca en son bellek kopyalarını almakla kalmazlar: yazılım havuzunu (_repository_) bütünüyle yansılarlar (kopyalarlar).

Böylece, sunuculardan biri çökerse, ve o sunucu üzerinden ortak çalışma yürüten sistemler varsa, istemcilerden birinin yazılım havuzu sunucuya geri yüklenerek sistem kurtarılabilir. Her seçerek alma (_checkout_) işlemi esasında bütün verinin yedeklenmesiyle sonuçlanır (bkz. Figür 1-3).

Insert 18333fig0103.png 
Figür 1-3. Dağıtık versiyon kontrol diyagramı.

Dahası, bu sistemlerden çoğu birden çok uzak uçbirimdeki yazılım havuzuyla rahatlıkla çalışır, böylece, aynı proje için aynı anda farklı insan topluluklarıyla farklı biçimlerde ortak çalışmalar yürütebilirsiniz. Bu, birden çok iş akışı ile çalışabilmenizi sağlar, ki bu merkezi sistemlerde (hiyerarşik modeller gibi) mümkün değildir.

## Git'in Kısa Bir Tarihçesi ##

Hayattaki pekçok harika şey gibi, Git de bir miktar yaratıcı yıkım ve ateşli tartışmayla başladı. Linux çekirdeği (_kernel_) oldukça büyük ölçekli bir açık kaynak kodlu yazılım projesidir. Linux çekirdek bakım ve geliştirme yaşam süresinin çoğunda (1991-2002), yazılım değişiklikleri yamalar ve arşiv dosyaları olarak tutulup taşındı. 2002 yılında, Linux çekirdek projesi, BitKeeper adında tescilli bir DVKS kullanmaya başladı.

2005 yılında, Linux çekirdeğini geliştiren toplulukla BitKeeper'ı geliştiren şirket arasındaki ilişki bozuldu ve aracın topluluk tarafından ücretsiz olarak kullanılabilmesi uygulamasına son verildi. Bu, Linux geliştirim topluluğunu (ve özellikle Linux'un yaratıcısı olan Linus Torvalds'ı) BitKeeper'ı kullanırken aldıkları derslerden yola çıkarak kendi araçlarını geliştirme konusunda harekete geçirdi. Yeni sistemin hedeflerinden bazıları şunlardı:

*	Hız
*	Basit tasarım
*	Çizgisel olmayan geliştirim için güçlü destek (binlerce paralel dal (_branch_))
*	Bütünüyle dağıtık olma
*	Linux çekirdeği gibi büyük projelerle verimli biçimde başa çıkabilme (hız ve veri boyutu)

2005'teki doğumundan beri, Git kullanım kolaylıklarını geliştirebilmek için evrilip olgunlaştı, ama yine de bu niteliklerini korudu. Git, inanılmaz ölçüde hızlı, büyük ölçekli projelerde alabildiğine verimli ve çizgisel olmayan geiştirim (bkz. Bölüm 3) için inanılmaz bir dallanma (_branching_) sistemine sahip.

## Git'in Temelleri ##

Peki Git özünde nedir? Bu, özümsenmesi gereken önemli bir altbölüm, çünkü Git'in ne olduğunu ve temel çalışma ilkelerini anlarsanız, Git'i etkili biçimde kullanmanız çok daha kolay olacaktır. Git'i öğrenirken, Subversion ve Perforce gibi diğer VKS'ler hakkında bildiklerinizi aklınızdan çıkarmaya çalışın; bu aracı kullanırken yaşanabilecek kafa karışıklıklarını önlemenize yardımcı olacaktır. Git'in, kullanıcı arayüzü söz konusu sistemlerle benzerlik gösterse de, bilgiyi depolama ve yorumlama biçimi çok farklıdır; bu farklılıkları anlamak, aracı kullanırken kafa karışıklığına düşmenizi engellemekte yardımcı olacaktır.

### Snapshots, Not Differences ###

The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4.

Insert 18333fig0104.png 
Figure 1-4. Other systems tend to store data as changes to a base version of each file.

Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. 

Insert 18333fig0105.png 
Figure 1-5. Git stores data as snapshots of the project over time.

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

### Nearly Every Operation Is Local ###

Most operations in Git only need local files and resources to operate — generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.

This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.

### Git Has Integrity ###

Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.

The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory.

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

The basic Git workflow goes something like this:

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
