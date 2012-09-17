# Başlangıç #

Bu bölümde Git kullanımı hakkında temel bilgileri bulacaksınız. İşe, sürüm kontrol sistemleri hakkında açıklamalarla başlayacağız; daha sonra Git kurulumunun nasıl yaplacağını, en son olarak da aracın konfigürasyon ve kullanımını açıklayacağız. Bu bölümün sonunda Git'in varlık sebebini ve neden onu kullanmanız gerektiğini anlayacak, Git'i kullanmaya başlamak için kurulumu tamamlamış olacaksınız.

## Sürüm Kontrolü Hakkında ##

Sürüm kontrolü nedir ve ne işe yarar? Sürüm kontrolü, bir ya da daha fazla dosya üzerinde yapılan değişiklikleri kaydeden ve daha sonra belirli bir sürüme geri dönebilmenizi sağlayan bir sistemdir. Bu kitaptaki örneklerde yazılım kaynak kod dosyalarının sürüm kontrolünü yapacaksınız, ne var ki gerçekte sürüm kontrolünü neredeyse her türden dosya için kullanabilirsiniz.

Bir grafik ya da web tasarımcısıysanız ve bir görselin ya da tasarımın değişik sürümlerini korumak istiyorsanız (ki muhtemelen bunu yapmak istersiniz), bir Sürüm Kontrol Sistemi (SKS) kullanmanız çok akıllıca olacaktır. SKS, dosyaların ya da bütün projenin geçmişteki belirli bir sürümüne erişmenizi, zaman içinde yapılan değişiklikleri karşılaştırmanızı, soruna neden olan şeyde en son kimin değişiklik yaptığını, belirli bir hatayı kimin, ne zaman sisteme dahil ettiğini ve daha başka pek çok şeyi görebilmenizi sağlar. Öte yandan, SKS kullanmak, bir hata yaptığınızda ya da bazı dosyaları yanlışlıkla sildiğinizde durumu kolayca telâfi etmenize yardımcı olur. Üstelik, bütün bunlar size kayda değer bir ek yük de getirmez.

### Yerel Sürüm Kontrol Sistemleri ###

Çoğu insan, dosyaları bir klasöre (akılları başlarındaysa tarih ve zaman bilgisini de içeren bir klasöre) kopyalayarak sürüm kontrolü yapmayı tercih eder. Bu yaklaşım çok yaygındır, çünkü çok kolaydır; ama aynı zamanda hatalara da alabildiğine açıktır. Hangi klasörde olduğunuzu unutup yanlış dosyaya yazabilir ya da istemediğiniz dosyaların üstüne kopyalama yapabilirsiniz.

Bu sorunla başedebilmek için, programcılar uzun zaman önce, dosyalardaki bütün değişiklikleri sürüm kontrolüne alan basit bir veritabanına sahip olan yerel SKS'ler geliştirdiler (bkz. Figür 1-1).

Insert 18333fig0101.png 
Figür 1-1. Yerel sürüm kontrol diyagramı.

En popüler SKS araçlarndan biri, bugün hâlâ pekçok bilgisayara kurulu olarak dağıtılan, rcs adında bir sistemdi. Ünlü Mac OS X işletim sistemi bile, Developer Tools'u yüklediğinizde, rcs komutunu kurmaktadır. Bu araç, iki sürüm arasındaki yamaları (yani, dosyalar arasındaki farkları) özel bir formatta diske kaydeder; daha sonra, bu yamaları birbirine ekleyerek, bir dosyann belirli bir sürümdeki görünümünü yeniden oluşturur.

### Merkezi Sürüm Kontrol Sistemleri ###

İnsanların karşılaştığı ikinci büyük sorun, başka sistemlerdeki programcılarla birlikte çalışma ihtiyacından ileri gelir. Bu sorunla başa çıkabilmek için, Merkezi Sürüm Kontrol Sistemleri (MSKS) gelitirilmiştir. Bu sistemler, meselâ CVS, Subversion ve Perforce, sürüm kontrolüne alınan bütün dosyaları tutan bir sunucu ve bu sunucudan dosyaları seçerek alan (_check out_) istemcilerden oluşur. Bu yöntem, yıllarca, sürüm kontrolünde standart yöntem olarak kabul gördü (bkz. Figür 1-2).

Insert 18333fig0102.png 
Figür 1-2. Merkezi sürüm kontrol diyagramı.

Bu yöntemin, özellikle yerel SKS'lere göre, çok sayıda avantajı vardır. Örneğin, bir projedeki herkes, diğerlerinin ne yaptığından belirli ölçüde haberdardır. Sistem yöneticileri kimin hangi yetkilere sahip olacağını oldukça ayrıntılı biçimde düzenleyebilirler; üstelik bir MSKS'yi yönetmek, her istemcide ayrı ayrı kurulu olan yerel veritabanlarını yönetmeye göre çok daha kolaydır.

Ne var ki, bu yöntemin de ciddi bazı sıkıntıları vardır. En aşikar sıkıntı, merkezi sunucunun arızalanması durumunda ortaya çıkacak kırılma noktası problemidir. Sunucu bir saatliğine çökecek olsa, o bir saat boyunca kullanıcıların çalışmalarını sisteme aktarmaları ya da çalıştıkları şeylerin sürümlenmiş kopyalarını kaydetmeleri mümkün olmayacaktır. Merkezi veritabanının sabit diski bozulacak olsa, yedekleme de olması gerektiği gibi yapılmamışsa, elinizdeki her şeyi —projenin, kullanıcıların bilgisayarlarında kalan yerel bellek kopyaları (_snapshot_) dışındaki bütün tarihçesini— kaybedersiniz. Yerel SKS'ler de bu sorundan muzdariptir —projenin bütün tarihçesini tek bir yerde tuttuğunuz sürece her şeyi kaybetme riskiniz vardır.

### Dağıtık Sürüm Kontrol Sistemleri ###

Bu noktada Dağıtık Sürüm Kontrol Sistemleri (DSKS) devreye girer. Bir DSKS'de (Git, Mercurial, Bazaar ya da Darcs örneklerinde olduğu gibi), istemciler (kullanıcılar) dosyaların yalnızca en son bellek kopyalarını almakla kalmazlar: yazılım havuzunu (_repository_) bütünüyle yansılarlar (kopyalarlar).

Böylece, sunuculardan biri çökerse, ve o sunucu üzerinden ortak çalışma yürüten sistemler varsa, istemcilerden birinin yazılım havuzu sunucuya geri yüklenerek sistem kurtarılabilir. Her seçme (_checkout_) işlemi esasında bütün verinin yedeklenmesiyle sonuçlanır (bkz. Figür 1-3).

Insert 18333fig0103.png 
Figür 1-3. Dağıtık sürüm kontrol diyagramı.

Dahası, bu sistemlerden çoğu birden çok uzak uçbirimdeki yazılım havuzuyla rahatlıkla çalışır, böylece, aynı proje için aynı anda farklı insan topluluklarıyla farklı biçimlerde ortak çalışmalar yürütebilirsiniz. Bu, birden çok iş akışı ile çalışabilmenizi sağlar, ki bu merkezi sistemlerde (hiyerarşik modeller gibi) mümkün değildir.

## Git'in Kısa Bir Tarihçesi ##

Hayattaki pekçok harika şey gibi, Git de bir miktar yaratıcı yıkım ve ateşli tartışmayla başladı. Linux çekirdeği (_kernel_) oldukça büyük ölçekli bir açık kaynak kodlu yazılım projesidir. Linux çekirdek bakım ve geliştirme yaşam süresinin çoğunda (1991-2002), yazılım değişiklikleri yamalar ve arşiv dosyaları olarak tutulup taşındı. 2002 yılında, Linux çekirdek projesi, BitKeeper adında tescilli bir DSKS kullanmaya başladı.

2005 yılında, Linux çekirdeğini geliştiren toplulukla BitKeeper'ı geliştiren şirket arasındaki ilişki bozuldu ve aracın topluluk tarafından ücretsiz olarak kullanılabilmesi uygulamasına son verildi. Bu, Linux geliştirim topluluğunu (ve özellikle Linux'un yaratıcısı olan Linus Torvalds'ı) BitKeeper'ı kullanırken aldıkları derslerden yola çıkarak kendi araçlarını geliştirme konusunda harekete geçirdi. Yeni sistemin hedeflerinden bazıları şunlardı:

*	Hız
*	Basit tasarım
*	Çizgisel olmayan geliştirim için güçlü destek (binlerce paralel dal (_branch_))
*	Bütünüyle dağıtık olma
*	Linux çekirdeği gibi büyük projelerle verimli biçimde başa çıkabilme (hız ve veri boyutu)

2005'teki doğumundan beri, Git kullanım kolaylıklarını geliştirebilmek için evrilip olgunlaştı, ama yine de bu niteliklerini korudu. Git, inanılmaz ölçüde hızlı, büyük ölçekli projelerde alabildiğine verimli ve çizgisel olmayan geiştirim (bkz. Bölüm 3) için inanılmaz bir dallanma (_branching_) sistemine sahip.

## Git'in Temelleri ##

Peki Git özünde nedir? Bu, özümsenmesi gereken önemli bir altbölüm, çünkü Git'in ne olduğunu ve temel çalışma ilkelerini anlarsanız, Git'i etkili biçimde kullanmanız çok daha kolay olacaktır. Git'i öğrenirken, Subversion ve Perforce gibi diğer SKS'ler hakkında bildiklerinizi aklınızdan çıkarmaya çalışın; bu aracı kullanırken yaşanabilecek kafa karışıklıklarını önlemenize yardımcı olacaktır. Git'in, kullanıcı arayüzü söz konusu sistemlerle benzerlik gösterse de, bilgiyi depolama ve yorumlama biçimi çok farklıdır; bu farklılıkları anlamak, aracı kullanırken kafa karışıklığına düşmenizi engellemekte yardımcı olacaktır.

### Farklar Değil, Bellek Kopyaları ###

Git ile diğer SKS'ler (Subversion ve ahbapları dahil) arasındaki esas fark, Git'in bilgiyi yorumlayış biçimiyle ilgilidir. Kavramsal olarak, diğer sistemlerin çoğu, bilgiyi dosya-tabanlı bir dizi değişiklik olarak depolar. Bu sistemler (CVS, Subversion, Perforce, Bazaar ve saire) bilgiyi, kayıt altında tuttukları bir dosya kümesi ve zamanla her bir dosya üzerinde yapılan değişikliklerin listesi olarak yorumlarlar (bkz. Figür 1-4).

Insert 18333fig0104.png 
Figür 1-4. Diğer sistemler veriyi her bir dosyanın ilk sürümu üzerinde yapılan değişiklikler olarak depolarma eğilimindedir.

Git, veriyi böyle yorumlayıp depolamaz. Bunun yerine, Git, veriyi, bir mini dosya sisteminin bellek kopyaları olarak yorumlar. Her kayıt işleminde (_commit_), ya da projenizin konumunu her kaydedişinizde, Git o anda dosyalarınızın nasıl göründüğünün bir fotoğrafını çekip o bellek kopyasına bir referansı depolar. Verimli olabilmek için, değişmeyen dosyaları yeniden depolamaz, yalnızca halihazırda depolanmış olan bir önceki özdeş kopyaya bir bağlantı kurar. Git'in veriyi yorumlayışı daha çok Figür 1-5'teki gibidir.

Insert 18333fig0105.png 
Figür 1-5. Git veriyi projenin zaman içindeki bellek kopyaları olarak depolar.

Bu, Git'le neredeyse bütün diğer SKS'ler arasında ciddi bir ayrımdır. Bu ayrım nedeniyle Git, sürüm kontrolünün, diğer sürüm kontrol sistemlerinin çoğu tarafından önceki kuşaklardan devralınan neredeyse bütün yönlerini yeniden gözden geçirmek zorunda bırakır. Bu ayrım Git'i basit bir SKS olmanın ötesinde, etkili araçlara sahip bir mini dosya sistemi gibi olmaya iter. Veriyi bu şekilde yorumlamanın yararlarından bazılarını dallanmayı işleyeceğimiz 3. Bölüm'de ele alacağız.

### Neredeyse Her İşlem Yerel ###

Git'teki işlemlerin çoğu, yalnızca yerel dosyalara ve kaynaklara ihtiyaç duyar —genellikle bilgisayar ağındaki başka bir bilgisayardaki bilgilere ihtiyaç yoktur. Eğer çoğu işlemin ağ gecikmesi maliyetiyle gerçekleştiği bir MSKS kullanmışsanız, Git'in bu yönünü görünce, onun hız tanrıları tarafından kutsanmış olduğunu düşünebilirsiniz. Çünkü projenin bütün tarihçesi orada, yerel diskinide bulunmaktadır, işlemlerin çoğu anlık gerçekleşiyor gibi görünür.

Örneğin, projenin tarihçesini taramak için Git bir sunucuya bağlanıp oradan tarihçeyi indirdikten sonra görüntülemekle uğraşmaz —yerel veritabanını okumak yeterlidir. Bu da proje terihçesini neredeyse anında görünteleyebilmeniz anlamına gelir. Bir dosyanın şimdiki haliyle bir ay önceki hali arasındaki farkları görmek isterseniz, Git, bir sunucudan fark hesaplaması yapmasını talep etmek ya da karşılaştırmayı yerelde yapabilmek için dosyanın bir ay önceki halini indirmek zorunda kalmak yerine,  dosyanın bir ay önceki halini yerelde bulup fark hesaplamasını yerelde yapar.

Bu aynı zamanda, eğer bağlantınız kopmuşsa, ya da VPN bağlantını yoksa yapamayacağınız şeylerin de sayıca oldukça sınırlı olduğu anlamına geliyor. Uçağa ya da trene binmiş olduğunuz halde biraz çalışmak istiyorsanız, yükleme yapabileceğiniz bir ağ bağlantısına kavuşana kadar güle oynaya kayıt yapabilirsiniz. Eve vardığınızda VPN istemcinizin olması gerektiği gibi çalışmıyorsa, yine de çalışmaya devam edebilirsiniz. pekçok başka sistemde bunları yapmak ya imk^ansız ya da zahmetlidir. Söz gelimi Perforce'ta, bir sunucuya bağlı değilseniz fazlaca bir şey yapamazsınız; Subversion ve CVS'te dosyaları değiştirebilirsiniz, ama veritabanına kayıt yapamazsınız (çünkü veritabanına bağlantınız yoktur). Bu, çok önemli bir sorun gibi görünmeyebilir, ama ne kadar fark yaratabileceğini gördüğünüzde şaşırabilirsiniz.

### Git Bütünlüklüdür ###

Git'te her şey depolanmadan önce sınama toplamından geçirilir (_checksum_) ve daha sonra bu sınama toplamı kullanılarak ifade edilir. Bu da demek oluyor ki, Git fark etmeden bir dosyanın ya da klasörün içeriğini değiştirmek mümkün değildir. Bu işlev Git'in merkezi işlevlerinden biridir ve felsefesiyle bir bütünlük oluşturur. Transfer sırasında veri kaybı ya da doysa arızası olmuşsa, Git bunu mutlaka fark edecektir.

Git'in sınama toplamı için kullandığı mekanizmaya SHA-1 özeti denir. Bu, on altılı sayı sisteminin (_hexadecimal_) sembolleriyle gösterilen (0-9 ve A-F) ve dosya ve klasör düzenini temel alan bir hesaplamayla elde deilen 40 karakterlik bir karakter dizisidir. Bir SHA-1 özeti şuna benzer:

	24b9da6552252987aa493b52f8696cd6d3b00373

Bu özetler sıklıkla karşınıza çıkacak, çünkü Git onları yaygın biçimde kullanyor. Hatta, Git her şeyi dosya adıyla değil, içeriğinin özet değeriyle adreslenen veritabanında tutar.

### Git Genellikle Yalnızca Veri Ekler ###

Git'te işlem yaptığınızda neredeyse bu işlemlerin tamamı Git veritabanına veri ekler. Sistemin geri döndürülemez bir şey yapmasını ya da veri silmesini sağlamak çok zordur. Her SKS'de olduğu gibi henüz kaydetmediğiniz değişiklikleri kaybedebilir ya da bozabilirsiniz; ama Git'e bir bellek kopyasını kaydettikten sonra veri kaybetmek çok zordur, özellikle de veritabanınızı düzenli olarak başka bir yazılım havuzuna iteliyorsanız (_push_).

Bu Git kullanmayı keyifli hale getirir, çünkü işleri ciddi biçimde sıkıntıya sokmadan denemeler yapabileceğimizi biliriz. Git'in veriyi nasıl depoladığı ve kaybolmuş görünen veriyi nasıl kurtarabileceğiniz hakkında daha derinlikli bir inceleme için bkz. Bölüm 9.

### Üç Aşama ###

Şimdi dikkat! Öğrenme sürecinizin pürüzsüz ilerlemesini istiyorsanız, aklınızda bulundurmanız gereken esas şey bu. Git'te, dosyalarınızın içinde bulunabileceği üç aşama (_state_) vardır: kaydedilmiş, değiştirilmiş ve hazırlanmış. Kaydedilmiş, verinin güvenli biçimde veritabanında depolanmış olduğu anlamına gelir. Değiştirilmiş, dosyayı değiştirmiş olduğunuz fakat henüz veritabanına kaydetmediğiniz anlamına gelir. Hazılanmış ise, değiştirilmiş bir dosyayı bir sonraki kayıt işleminde bellek kopyasına alınmak üzere işaretlediğiniz anlamına gelir.

Bu da bizi bir Git projesinin üç ana bölümüne getiriyor: Git klasörü, çalışma klasörü ve hazırlık alanı.

Insert 18333fig0106.png 
Figür 1-6. Çalışma klasörü, hazırlık alanı ve Git klasörü.

Git klasörü, Git'in üstverileri (_metadata_) ve nesne veritabanını depoladığı yerdir. Bu, Git'in en önemli parçasıdır ve bir yazılım havuzunu bir bilgisayardan bir başkasına klonladığınızda kopyalanan şeydir.

Çalışma klasörü projenin bir sürümünden yapılan tek bir seçmedir. Bu dosyalar Git klasöründeki sıkıştırılmış veritabanından çıkartılıp sizin kullanımınız için sabit diske yerleştirilir.

Hazırlık alanı (_staging area_), genellikle Git klasörünüzde bulunan ve bir sonraki kayıt işlemine hangi değişikliklerin dahil olacağını tutan sade bir dosyadır. Buna bazen indeks dendiği de olur, ama hazırlık alanı ifadesi giderek daha standart hale geliyor.

Git işleyişi temelde şöyledir:

1.	Çalışma klasörünüzdeki dosyalar üzerinde değişiklik yaparsınız.
2.	Dosyaları bellek kopyalarını hazırlık alanına ekleyerek hazırlarsınız.
3.	Dosyaların hazırlık alanındaki hallerini alıp oradaki bellek kopyasını kalıcı olarak Git klasörüne depolayan bir kayıt işlemi yaparsınız.

Bir dosyanın belirli bir sürümü Git klasöründeyse, onun kaydedilmiş olduğu kabul edilir. Eğer üzerinde değişiklik yapılmış fakat hazırlık alanına eklenmişse, hazırlanmış olduğu söylenir. Ve seçme işleminden sonra üzerinde değişiklik yapılmış fakat kayıt için hazırlanmamışsa, değiştirilmiş olarak nitelenir.

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
